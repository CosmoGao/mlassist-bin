造光之鞋卖店，要求：会狩猎伐木，设好自动战斗，启动脚本时物品栏全空，自动扔东西（包括魔石/各种卡片/各种碎片），自动治疗!以及自动叠加 鹿皮&40 麻布&20 木棉布&20 毛毡&20 鹿皮不要捡多了，会卡住

common=require("common")
设置("timer", 100)						-- 设置定时器，单位毫秒
设置("自动加血",0)
设置("高速延时",4)  
设置("高速战斗",1)  
设置("自动战斗",1)  
设置("遇敌全跑",1) 			
设置("自动叠",1, "麻布&20")			
设置("自动叠",1, "木棉布&20")		
设置("自动叠",1, "毛毡&20")		
设置("自动叠",1, "鹿皮&40")		
设置("自动扔",1,"卡片？")
设置("自动扔",1,"魔石")
设置("自动扔",1,"盐")
身上最少金币=5000			--少于去取
身上最多金币=950000			--大于去存
身上预置金币=200000			--取和拿后 身上保留金币

local tradeName=nil
local tradeBagSpace=nil
local tradePlayerLine=nil			--仓库人物当前线路

local client=nil			--客户端句柄
local shoeTbl={material="麻布",playerName=人物("名称",false),materialCount=20,cmd=""}	--发送当前需要的材料 数量
local 麻布数量=200 --10组
local lastCount=0	--上次麻布数量
local waitTradeLoopCount=0	--循环次数 防止卡住

function 交易通信确认()
	if(client == nil)then return end	
	local recvData = 接收目标服务数据(client.id)	
	--查收信息 看客户端谁有这个材料，收到以后，点到点通信，确定交易，其余的不通知				
	if(recvData.state)then	--接收数据成功  
		日志("收到数据:"..recvData.data)
		local tmpData = common.StrToTable(recvData.data)	--转换表
		if(tmpData)then	
			--制造求的物品 和当前采集一致 并且数量达标 则响应
			if(tmpData.cmd == "求" and tmpData.material==shoeTbl.material and 取物品叠加数量(shoeTbl.material)>=tmpData.materialCount)then	
				tmpData.cmd="应"
				tmpData.playerName=人物("名称",false)
				local testSendData=common.TableToStr(tmpData)
				日志("发送回应："..testSendData)
				发送数据到目标服务(client.id,testSendData)
			elseif(tmpData.cmd == "成" and tmpData.playerName==人物("名称",false))then	
				--达成交易协商  则回去交易
				tradeName=tmpData.reqPlayerName
				shoeTbl.materialCount = tmpData.materialCount				
				return true
			end
		end			
	end
	等待(1000)	--1秒等待回信	
	return false
end


function main()
	日志("欢迎使用星落全自动制鞋刷双百脚本",1)
	日志("当前职业："..人物("职业"),1)
	日志("当前职称："..人物("职称"),1)
	-- if(人物("职业") ~= "猎人")then
		-- 日志("职业不是猎人",1)
		-- return	
	-- end
	扔("竹子")
	扔("孟宗竹")
	扔("铜")
	client = 创建网络客户端("127.0.0.1",33333)
	if(client.state == false) then
		日志(client.msg,1)
		return
	end
::begin::
	等待空闲()	
	mapName=取当前地图名()	
	common.supplyCastle()
	common.checkHealth()	
	if(取物品叠加数量('麻布') < 麻布数量)then
		if(取当前地图名() ~= "流行商店")then
			common.gotoFaLanCity()
			自动寻路(117, 112,"流行商店")
		end
		自动寻路(8,7)
		转向(0)
		等待服务器返回()		
		对话选择(0, 0)
		等待服务器返回()		
		买(0,麻布数量-取物品叠加数量('麻布'))
		goto begin
	end	
	叠("鹿皮", 40)	
	common.toCastle()
	自动寻路(28,91)
	goto waitTrade
::waitTrade::
	if(取物品叠加数量('麻布') >= 麻布数量)then
		if(交易通信确认() == true ) then
			lastCount = 取物品叠加数量('麻布')
			waitTradeLoopCount=0
			goto waitTopic
		end
	end
	等待(2000)
	goto waitTrade
::waitTopic::
	if(取当前地图名()~= "里谢里雅堡")then
		回城()
		common.toCastle()
		自动寻路(28,91)
	end
	waitTradeLoopCount=waitTradeLoopCount+1
	if(waitTradeLoopCount>=10)then
		重置数据()
		goto begin
	end
	设置("timer",0)	
	if(tradeName ~= nil)then	
		tradex=nil
		tradey=nil
		units = 取周围信息()
		if(units ~= nil)then
			for i,u in pairs(units) do
				if(u.unit_name==tradeName)then
					tradex=u.x
					tradey=u.y
					break
				end
			end
		else
			goto waitTopic
		end
		if(tradex ~=nil and tradey ~= nil)then
			移动到目标附近(tradex,tradey)
		else
			goto waitTopic
		end
		转向坐标(tradex,tradey)				
		items = 物品信息()
		tradeList="物品:"
		hasData=false
		selfTradeCount=0
		for i,v in pairs(items) do
			if(v.name==shoeTbl.material and v.count==20)then
				if(hasData)then
					tradeList=tradeList.."|"..v.name.."|"..v.count.."|".."1"
				else
					tradeList=tradeList..v.name.."|"..v.count.."|".."1"			
				end
				selfTradeCount=selfTradeCount+20
				hasData=true
				if(selfTradeCount >= shoeTbl.materialCount)then
					break
				end			
			end
		end	
		--金币:20;物品:设计图？|0|1|誓约之花|0|1|
		--string.sub(tradeList,1,string.len(tradeList)-1)
		日志(tradeList)
		if(hasData)then
			交易(tradeName,tradeList,"",10000)
		else	
			设置("timer",100)
			重置数据()
			tradeName=nil
			tradeBagSpace=nil
			tradePlayerLine=nil	
			回城()
			goto begin
		end
		if(lastCount ~= 取物品叠加数量('麻布'))then
			重置数据()
			goto begin
		end
	end	
	goto waitTopic
end
function 重置数据()
	tradeName=nil
	清除客户端接收缓冲区()
end
main()