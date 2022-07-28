艾岛启动，抽技能草，自己吃

设置("自动扔",1,"卡片？")
设置("自动扔",1,"艾夏糖")
设置("自动扔",1,"串烧哥布林")
设置("自动扔",1,"家族兽之笛")
设置("自动扔",1,"绿头盔")
设置("自动扔",1,"红头盔")
设置("自动扔",1,"赖光的头盔")
设置("自动扔",1,"中型的土之宝石")
设置("自动扔",1,"中型的水之宝石")
设置("自动扔",1,"中型的火之宝石")
设置("自动扔",1,"中型的风之宝石")
--设置("自动扔",1,"生命力回复药（75）")
设置("自动扔",1,"魔石")
设置("timer",100)
技能名称="精灵的盟约"
技能等级=10		--停止等级

local sTopicMsg="天狼星仓库信息"
topicList={sTopicMsg}
订阅消息(topicList)
抽奖线=人物("几线")
local tradePetRealName="天狼星"
tradeName=nil				--仓库人物名称
tradeBagSpace=nil			--仓库人物宠物空格
tradePlayerLine=nil			--仓库人物当前线路

function waitTopic()
	if(抽奖线==nil)then 抽奖线=人物("几线") end
::begin::
	等待空闲()
	tryNum=0
	if(取当前地图名()~= "银行")then
		common.gotoFalanBankTalkNpc()
		tradeName=nil
		tradeBagSpace=nil
		tradePlayerLine=nil
	end
	设置("timer",0)
	topic,msg=等待订阅消息()
	日志(topic.." Msg:"..msg,1)
	if(topic == sTopicMsg)then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeBagSpace=recvTbl.pets
		tradePlayerLine=recvTbl.line
	end				
	if(tradePlayerLine ~= nil and tradePlayerLine ~= 0 and tradePlayerLine ~= 人物("几线"))then
		切换登录信息("","",tradePlayerLine,"")
		登出服务器()
		等待(3000)			
		goto begin
	end	
	if(tradeName ~= nil and tradeBagSpace ~= nil and tradePlayerLine==人物("几线"))then	
		while tryNum<3 do
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
			pets = 全部宠物信息()
			tradeList="金币:20;宠物:"
			hasData=false
			selfTradeCount=0
			for i,v in pairs(pets) do
				if(v.realname == tradePetRealName and v.level==1)then					
					if(selfTradeCount >= tradeBagSpace)then
						break
					end		
					selfTradeCount=selfTradeCount+1
					hasData=true				
				end
			end	
			tradeList = tradeList..tradePetRealName.."|"..selfTradeCount
			--金币:20;物品:设计图？|0|1|誓约之花|0|1|
			--string.sub(tradeList,1,string.len(tradeList)-1)
			
			日志(tradeList)
			if(hasData)then
				交易(tradeName,tradeList,"",10000)
			else	
				设置("timer",100)
				--下次说不定是哪个仓库 设置为nil
				tradeName=nil
				tradeBagSpace=nil
				tradePlayerLine=nil	
				回城()
				goto checkLine
			end
			tryNum=tryNum+1
		end
	end
	goto begin
::checkLine::
	if(人物("几线")~=抽奖线)then
		切换登录信息("","",抽奖线,"")
		登出服务器()
		等待(3000)
		return
	end
end
function main()
::begin::
	等待空闲()
	if (人物("宠物数量") >= 5 )then	
		日志("宠物满了，去银行存货！")
		common.depositNoBattlePetToBank()
		if (人物("宠物数量") >= 5 )then	
			日志("银行宠物也满啦！请先清理，再重新执行脚本！")
			common.gotoFalanBankTalkNpc()
			tradeName=nil
			tradeBagSpace=nil
			waitTopic()
		end
		goto begin
	end
	当前地图名=取当前地图名()
	mapNum=取当前地图编号()
	if(当前地图名=="艾尔莎岛")then
		goto aiersha	
	elseif (当前地图名=="利夏岛" )then	
		goto map59522
	elseif (当前地图名=="国民会馆" )then	
		goto map59552
	elseif (当前地图名=="雪拉威森塔１层" )then	
		goto map59801
	elseif (当前地图名=="雪拉威森塔２５层" )then	
		goto map59825	
	end
	等待(1000)
	回城()
	goto begin 
::aiersha::	
	自动寻路(165, 153)
	转向(4)
	等待服务器返回()
	对话选择(32,0)
	等待服务器返回()
	对话选择(4, 0)		
::map59522::					--利夏岛
	if(取当前地图名() ~= "利夏岛")then
		goto begin
	end
	自动寻路(90,99,"国民会馆")
::map59552::					--国民会馆
	自动寻路(108,39,"雪拉威森塔１层")
	goto begin
::map59801::					--雪拉威森塔１层
	自动寻路(76,52,"雪拉威森塔２５层")		
	goto begin
	
::map59825::
	自动寻路(95,34)
	兑换100怪物硬币()
	if(common.playerSkillLv(技能名称)>=技能等级)then
		return
	end
	goto begin
end
	
	
function 兑换100怪物硬币()
	local position=1
::begin::
	自动寻路(95,34)
	转向(0)
	while(取物品数量("鲈鱼饭团") > 0)do
		if(取物品数量("鲈鱼饭团") > 1)then
			扔("鲈鱼饭团")
		end		
		使用物品("鲈鱼饭团")
		等待服务器返回()
		对话选择(1,0)
		等待(1000)
		local tryNum=0
		while(取物品数量("布斯特药草")>0) do
			使用物品("布斯特药草")
			if(tryNum > 100)then
				日志("技能等级满了，不能使用",1)
			end
			tryNum=tryNum+1
		end
		tryNum=0
		while(取物品数量("特级布斯特药草")>0) do
			使用物品("特级布斯特药草")
			if(tryNum > 100)then
				日志("技能等级满了，不能使用",1)
			end
			tryNum=tryNum+1
		end
		
		while(取物品数量("生命力回复药（75）") > 0) do
			使用物品("生命力回复药（75）")	
			--等待菜单返回()
			菜单选择(0,"")
			菜单项选择(0,"")			
		end
		if(string.find(最新系统消息(),"无法放置")~=nil)then
			if(position == 1)then goto 移位1 
			elseif(position == 2)then goto 移位2
			elseif(position == 3)then goto 移位3 
			elseif(position == 4)then goto 移位4 
			elseif(position == 5)then goto 移位5 		
			elseif(position == 6)then goto 移位6
			end
			goto 移位1	
		elseif(string.find(聊天(50),"获得了 天狼星")~=nil)then
			清除系统消息()
			if (人物("宠物数量") >= 5 )then	
				日志("宠物满了，去银行存货！")
				common.depositNoBattlePetToBank()
				if (人物("宠物数量") >= 5 )then	
					日志("银行宠物也满啦！请先清理，再重新执行脚本！")
					common.gotoFalanBankTalkNpc()
					tradeName=nil
					tradeBagSpace=nil
					waitTopic()
				end
				goto begin
			end
		end
		if(取物品叠加数量("５怪物硬币") < 100 and 取物品叠加数量("１０怪物硬币") < 100  and 取物品数量("１０００怪物硬币") < 1 and 取物品数量("１万怪物硬币") < 1)then
			日志("没有怪物硬币了",1)
			return
		end		
	end
	if(取物品数量("鲈鱼饭团") < 1)then
		if(string.find(最新系统消息(),"无法放置")~=nil)then
			if(position == 1)then goto 移位1 
			elseif(position == 2)then goto 移位2
			elseif(position == 3)then goto 移位3 
			elseif(position == 4)then goto 移位4 
			elseif(position == 5)then goto 移位5 		
			elseif(position == 6)then goto 移位6
			end
			goto 移位1	
		else
			喊话("厨师呕心沥血的料理",2,3,5)
			等待服务器返回()
			对话选择(4,0)
			等待服务器返回()
			对话选择(1,0)
		end		
	end
	if(取物品叠加数量("５怪物硬币") < 100 and 取物品叠加数量("１０怪物硬币") < 100)then
		--大换小
		自动寻路(97,31)
		if(取物品数量("１万怪物硬币") > 0 )then			
			if(取物品数量("１０００怪物硬币") < 1)then
				转向(0)
				等待服务器返回()
				对话选择(32,0)
				等待服务器返回()
				对话选择(4,0)			
				等待服务器返回()
				对话选择(4,0)		
			end		
			if(取物品叠加数量("１０怪物硬币") < 100)then
				转向(0)
				等待服务器返回()
				对话选择(32,0)
				等待服务器返回()
				对话选择(4,0)
				等待服务器返回()
				对话选择(8,0)
				等待服务器返回()
				对话选择(4,0)	
			end	
		elseif(取物品数量("１０００怪物硬币") > 0)then
			if(取物品叠加数量("１０怪物硬币") < 100)then
				转向(0)
				等待服务器返回()
				对话选择(32,0)
				等待服务器返回()
				对话选择(4,0)				
				等待服务器返回()
				对话选择(4,0)	
			end	
		end
	end
	if(common.playerSkillLv(技能名称)>=技能等级)then
		return
	end
	等待(1000)		
	goto begin
::移位1::
	清除系统消息()
	自动寻路(93,34)
	等待(2000)
	自动寻路(90,32)
	等待(2000)
	自动寻路(88,34)
	position=position+1
	goto begin
::移位2::
	清除系统消息()
	自动寻路(97,34)
	等待(2000)
	自动寻路(99,34)
	等待(2000)
	自动寻路(99,36)
	position=position+1
	goto begin
::移位3::
	清除系统消息()
	自动寻路(99,39)
	等待(2000)
	自动寻路(98,41)
	等待(2000)
	自动寻路(96,41)
	position=position+1
	goto begin
::移位4::
	清除系统消息()
	自动寻路(95,36)
	等待(2000)
	自动寻路(95,39)
	等待(2000)
	自动寻路(93,40)
	position=position+1
	goto begin
::移位5::
	自动寻路(90,41)
	等待(2000)
	自动寻路(88,43)
	等待(2000)
	自动寻路(90,37)
	position=position+1
	goto begin
::移位6::
	自动寻路(92,36)
	等待(2000)
	自动寻路(89,36)
	等待(2000)
	自动寻路(87,36)
	position=1
	goto begin
end
main()