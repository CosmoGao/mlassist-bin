脚本支持发蓝和艾尔莎岛启动，支持传送羽毛，请设置好自动战斗,谢谢支持魔力辅助程序

common=require("common")

设置("timer",0)
local 补魔值 = 50--用户输入框("多少魔以下补魔", "50")
local 补血值=430--用户输入框("多少血以下补血", "430")
local 宠补血值=50--用户输入框( "宠多少血以下补血", "50")
local 宠补魔值=100--用户输入框( "宠多少魔以下补血", "100")
local 卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶|口袋龙的卡片|地狱看门犬的卡片"		--可以增加多个 不影响速度
local oldGold = 人物("金币")
local allGoldNum=0	--累计获得金币
local 练级前时间=os.time() 
local 走路加速值=125	
local 走路还原值=100	
local 卡对话检测次数=0


local tradeName=nil
local tradeBagSpace=nil
local tradePlayerLine=nil			--仓库人物当前线路
--topicList={"金币仓库名称","金币仓库余钱","金币仓库几线"}
local topicList={"金币仓库信息"}
订阅消息(topicList)	

function waitTopic()

::begin::
	topic,msg=等待订阅消息()
	日志(topic.." Msg:"..msg,1)
	if(topic == "金币仓库信息")then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeBagSpace=recvTbl.gold
		tradePlayerLine=recvTbl.line
	end	
	if(tradePlayerLine ~= nil and tradePlayerLine ~= 0 and tradePlayerLine ~= 人物("几线"))then
		切换登录信息("","",tradePlayerLine,"")
		登出服务器()
		等待(3000)			
		goto begin
	end	
	if(tradeName ~= nil and tradeBagSpace ~= nil)then	
		if(取当前地图名()~= "银行" and 取当前地图编号() ~= 1121)then			
			if(取当前地图名() ~= "哥拉尔镇")then 
				回城()
			end
			执行脚本("./脚本/直通车/★公交车-哥拉尔To法兰银行.lua")				
		end	
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
			goto begin
		end
		if(tradex ~=nil and tradey ~= nil)then
			移动到目标附近(tradex,tradey)
		else
			goto begin
		end
		转向坐标(tradex,tradey)		
		if(人物("金币") > 200000)then
			goldNum = 人物("金币")-200000
			if(goldNum > tradeBagSpace)then goldNum = tradeBagSpace end
			tradeList="金币:"..goldNum	
			日志(tradeList)		
			交易(tradeName,tradeList,"",10000)
		else	
			自动寻路(11,8)
			银行("取钱",-1000000)
			tradeName=nil--交易完后，这里重置
			if(人物("金币") <= 200000)then						
				回城()
				return
			end
		end
	end
	goto begin
end

function logbackG()
	当前地图名 = 取当前地图名()
	x,y=取当前坐标()		
	if (当前地图名=="阿凯鲁法村"  )then return end			
	回城()	
	等待(3000)
end

function statistics(beginTime)
	local playerinfo = 人物信息()
	local nowTime = os.time() 
	local time = math.floor((nowTime - beginTime)/60)--已持续练级时间
	if(time == 0)then
		time=1
	end	
	local goldContent =""
	if(oldGold~=0 ) then
		local nowGold = 人物("金币")
		local getGold = nowGold - oldGold
		allGoldNum=allGoldNum+getGold
		local avgGold = math.floor(60 * allGoldNum/time)
		goldContent = "已持续刷钱【"..time.."】分钟，共获得".."【"..allGoldNum.."】金币，平均每小时【"..avgGold.."】金币"
		日志(goldContent)
		oldGold=人物("金币")
	-- else
		-- oldGold = 人物("金币")
		-- allGoldNum=0	--累计获得金币
	end
end

function recallSoul()
	if( 人物("灵魂") > 0 )then
		日志("触发登出补给:人物掉魂")
		logbackG()
		转向(0)
		等待(1000)
		自动寻路(183,104,"阿凯鲁法城")
		自动寻路(37,29,"阿凯鲁法城地下")
		自动寻路(25, 8, "礼拜堂")
		自动寻路(25, 16)
		对话选是(0)
		等待(1000)
		logbackG()
	end
end

function healPlayer()
	if( 人物("健康") > 0  or 宠物("健康") > 0)then
		logbackG()
		--砍村治疗 或者回法兰治疗
		日志("人物受伤")
		执行脚本("./脚本/直通车/★公交车-阿凯鲁法To里堡.lua")
		common.checkHealth()
		-- 自动寻路(165,91,"医院")
		-- 自动寻路(29,15)
		-- 转向(2)
		-- 等待服务器返回()
		-- 对话选择(-1,6)
		-- 自动寻路(29,26)
		-- 回复(30,26)
		logbackG()
	end      

end

function buyCrystal(crystalName,buyCount)
	喊话("买水晶")
	if(buyCount==nil) then buyCount=1 end
	if(crystalName == nil)then  crystalName = "水火的水晶（5：5）" end
	if(取包裹空格() < 1) then
		if(取当前地图名() ~= "比比卡片屋")then	
			回城()
			自动寻路(161, 156, "比比卡片屋")	
		end
		自动寻路(16, 18)	
		卖(0,卖店物品列表)				
	end
	if(取包裹空格() < 1) then
		日志("背包没有空格，买水晶中断！")
		回城()	
		return
	end
	if(取包裹空格() < buyCount) then
		日志("背包空格数量不够，买水晶中断！")
		回城()	
		return
	end	
	转向(0)
	等待服务器返回()
	对话选择(0,0) --第二个参数0 0买 1卖 2不用了
	local dlg = 等待服务器返回()
	local buyData = 解析购买列表(dlg.message)
	local itemList = buyData.items
	local dstItem = nil
	for i,item in ipairs(itemList)do
		if( item.name == crystalName) then
			dstItem={index=i-1,count=buyCount}			
		end
	end
	if (dstItem ~= nil)then
		买(dstItem.index,dstItem.count)
		等待(1000)
		return true
	else
		日志("购买水晶失败！")
		return false
	end
	return false
end
function checkCrystal(crystalName,equipsProtectValue)
	if(equipsProtectValue==nil)then equipsProtectValue =100 end
	if(crystalName == nil)then  crystalName = "水火的水晶（5：5）" end
	local itemList = 物品信息()
	local crystal = nil
	for i,item in ipairs(itemList)do
		if(item.pos == 7)then
			crystal = item
			break
		end
	end
	--当前水晶不需要更换
	--喊话(crystal.name.."耐久"..crystal.durability.."设置值"..equipsProtectValue)
	if(crystal~=nil and crystal.name == crystalName and crystal.durability > equipsProtectValue) then
		return
	end
	crystal=nil
	--需要更换 检查身上是否有备用水晶
	for i,item in ipairs(itemList)do
		if(item.name == crystalName and item.durability > equipsProtectValue)then
			crystal = item
			break
		end
	end

	if(crystal~=nil ) then
		交换物品(crystal.pos,7,-1)
		return
	end	
	--买水晶
	buyCrystal(crystalName)
	扔(7)--扔旧的
	等待(1000)	--等待刷新
	使用物品(crystalName)
    logbackG()	
end

function checkHealth()
	local health = 人物("健康")
	local petinfo = 宠物信息()
	if( 人物("健康") > 0 or 人物("灵魂") > 0 or 宠物("健康") > 0)then
		--登出 去治疗 招魂		
		recallSoul()	
		healPlayer()		
	end           
end

function checkGold()
	if(人物("金币") > 990000)then
		日志("钱包快满了：" .. 人物("金币") .."去银行存钱")
		logbackG()
		自动寻路(139,136,"银行")
		自动寻路(20,17)
		转向(2)
		等待(2000)		
		日志("银行现有【"..银行("金币").."】金币",1)
		银行("存钱",100000)	
		银行("存钱",100000)	
		银行("存钱",100000)	
		银行("存钱",100000)	
		银行("存钱",100000)	
		银行("存钱",100000)	
		银行("存钱",100000)	
		银行("存钱",100000)	
		银行("存钱",100000)	
		等待(3000)
		转向(2)
		日志("银行存后还有【"..银行("金币").."】金币",1)
		if(人物("金币") > 990000)then
			日志("钱包满了，银行也放不下了，去法兰仓库")
			--执行脚本("./脚本/直通车/★公交车-哥拉尔To法兰银行.lua")	
			回城()
			tradeName=nil
			tradeBagSpace=nil
			waitTopic()	
			return
		end
		oldGold = 人物("金币")	--重新记录金币
	end

end

function battle()
	自动寻路(204, 351)		
	开始遇敌()
	while true do
		if(人物("血") < 补血值)then break end
		if(人物("魔") < 补魔值)then break end
		if(宠物("血") < 宠补血值)then break end
		if(宠物("魔") < 宠补魔值)then break end
		if(取当前地图名() ~= "米内葛尔岛")then break end
		if(取包裹空格() < 1)then break end
		if( 人物("健康") > 0 or 人物("灵魂") > 0 or 宠物("健康") > 0)then break end
		if(是否战斗中()) then 等待战斗结束() end		
		等待(5000)
	end
	停止遇敌()	
	自动寻路(203,345,"阿凯鲁法村")
	等待(1000)
end

function 卡对话检测()
	
	while true do
		if(人物("血") < 补血值)then break end
		if(人物("魔") < 补魔值)then break end
		if(宠物("血") < 宠补血值)then break end
		if(宠物("魔") < 宠补魔值)then break end
		if(取包裹空格() < 1)then break end
	end

end
function main()
	日志("脚本启动，初始金币："..oldGold.." 总获得金币:"..allGoldNum)

::begin::
	等待空闲()
	当前地图名 = 取当前地图名()
	x,y=取当前坐标()	
	地图编号=取当前地图编号()	
	if (当前地图名=="艾尔莎岛" )then	
		执行脚本("./脚本/直通车/★定居-阿凯鲁法.lua")
	elseif (当前地图名=="里谢里雅堡" )then	
		执行脚本("./脚本/直通车/★定居-阿凯鲁法.lua")
	elseif(当前地图名=="米内葛尔岛") then
		battle()
	elseif(当前地图名=="阿凯鲁法村")then
		if(取物品数量("魔石") > 0)then
			自动寻路(161, 156, "比比卡片屋")
		else
			自动寻路(196,208,"冒险者旅馆 1楼")		
		end
	elseif(当前地图名=="比比卡片屋")then
		自动寻路(16, 18)
		卖(0,卖店物品列表)	
		checkGold()
		checkCrystal()
		自动寻路(18,32,"阿凯鲁法村")
		自动寻路(196,208,"冒险者旅馆 1楼")		
	elseif(当前地图名=="冒险者旅馆 1楼")then
		自动寻路(22, 17)
		回复(0)			
		自动寻路(16,23,"阿凯鲁法村")
		statistics(练级前时间)	--统计脚本效率		
		自动寻路(178,227,"米内葛尔岛")
		自动寻路(204, 351)		
	else
		设置("移动速度",走路加速值)
		logbackG()		
		checkHealth()			
	end	
	--回城()
	等待(1000)
	goto  begin

end
main()