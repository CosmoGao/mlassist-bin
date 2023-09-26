1-160全自动练级

common=require("common")
local 补血值=取脚本界面数据("人补血")
local 补魔值=取脚本界面数据("人补魔")
local 宠补血值=取脚本界面数据("宠补血")
local 宠补魔值=取脚本界面数据("宠补魔")

local 队长名称=取脚本界面数据("队长名称",false)
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("队长名称","乱￠逍遥")--风依旧￠花依然  乱￠逍遥
end
if(补血值==nil or 补血值==0)then
	补血值=用户输入框("人多少血以下补血", "430")
end
if(补魔值==nil or 补魔值==0)then
	补魔值 = 用户输入框("人多少魔以下补魔", "200")
end
if(宠补血值==nil or 宠补血值==0)then
	宠补血值 = 用户输入框( "宠多少血以下补血", "50")
end
if(宠补魔值==nil or 宠补魔值==0)then
	宠补魔值=用户输入框( "宠多少魔以下补魔", "50")
end
local 跟随队长换线=用户输入框("是否跟随队长换线,是1，否0！","1")
local 遇敌总次数=0
local 练级前经验=0
local 练级前时间=os.time()
local 走路加速值=110	--脚本走路中可以设定移动速度  到达目的地后，再还原值即可
local 走路还原值=100	--防止掉线 还原速度
local 卖店物品列表="魔石|卡片？|锹型虫的卡片|狮鹫兽的卡片|水蜘蛛的卡片|虎头蜂的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"		--可以增加多个 不影响速度
	--可以增加多个 不影响速度
local 水晶名称="水火的水晶（5：5）"
local 是否自动购买水晶=1
local 满金币存银行数=950000	--95万存银行
local 身上最少金币数=1000	--身上最少5万  判断会用这个判断 取得话 会用这个的2倍取 防止来回判断
local 多少金币去拿钱=10000	--1w
local 扔物品列表={'时间的碎片','时间的结晶','绿头盔','红头盔','秘文之皮','星之砂','奇香木','巨石','龙角','坚硬的鳞片','传说的鹿皮','碎石头'}
设置("自动叠",1, "时间的结晶&20")	
设置("自动叠",1, "时间的碎片&20")	
for i,v in pairs(扔物品列表) do
	设置("自动扔",1, v)	
end
local tradeName=nil
local tradeBagSpace=nil
local tradePlayerLine=nil			--仓库人物当前线路
topicList={"金币仓库信息"}

订阅消息(topicList)	


喊话(队长名称,2,3,5)
local 医生名称={"星落护士","谢谢惠顾☆"}
local 半山西门=true	--半山是西门还是里堡二楼
local 是否是驯兽=false
local 是否有完美调教=false
if(人物("职业") == "驯兽师")then
	是否是驯兽=true
end
if(common.findSkillData("完美调教术") ~= nil)then
	是否有完美调教=true
end
function 营地商店检测水晶(crystalName,equipsProtectValue,buyCount)
	if(equipsProtectValue==nil)then equipsProtectValue =100 end
	if(crystalName == nil)then crystalName="水火的水晶（5：5）" end
	if(buyCount==nil) then buyCount=1 end
	--检测水晶
	local itemList = 物品信息()
	local crystal = nil
	for i,item in ipairs(itemList)do
		if(item.pos == 7)then
			crystal = item
			break
		end
	end
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
	离开队伍()
	local 当前地图名 = 取当前地图名()
	if(当前地图名 == "商店")then 
		自动寻路(14,26)
	elseif(当前地图名 == "圣骑士营地")then 
		自动寻路(92, 118,"商店")
		自动寻路(14,26)
	else
		return
	end
	转向(2)
	等待服务器返回()
	common.buyDstItem(crystalName,1)
	扔(7)--扔旧的
	等待(1000)	--等待刷新
	使用物品(crystalName)	
	自动寻路(0,14,"圣骑士营地")	
end


function 营地存取金币(金额,存取)
	if(金额==nil) then return end
	local 当前地图名 = 取当前地图名()
	if(当前地图名 == "银行")then 
		自动寻路(27,23)
	elseif(当前地图名 == "圣骑士营地")then 
		自动寻路(116, 105,"银行")
		自动寻路(27,23)
	else
		return
	end
	local oldGold=人物("金币")
	转向(2)
	等待服务器返回()
	if(存取==nil or 存取=="存")then
		银行("存钱",金额)
		等待(3000)
		转向(2)
		等待服务器返回()
		if(人物("金币") == oldGold) then
			日志("存【"..金额.."】金币失败,尝试按100W存金币")
			金额=1000000-银行("金币")
			银行("存钱",金额)	
			等待(3000)
			转向(2)
			等待服务器返回()
			if(人物("金币") == oldGold) then
				日志("存【"..金额.."】金币失败,尝试按1000W存金币")
				金额=10000000-银行("金币")
				银行("存钱",金额)	
				if(人物("金币") == oldGold) then
					等待(3000)
					--去找指定仓库存储
					tradeName=nil
					tradeBagSpace=nil
					waitTopic()	
					return
				end
			end
		end
	else
		银行("取钱",金额)
	end
end
function waitTopic()
::begin::
	if(取当前地图名()~= "银行" and 取当前地图编号() ~= 1121)then
		common.gotoFaLanCity("e1")		
		等待到指定地图("法兰城")	
		自动寻路(238,111,"银行")	
	end
	设置("timer",0)
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
			设置("timer",100)
			--下次说不定是哪个仓库 设置为nil
			tradeName=nil
			tradeBagSpace=nil
			tradePlayerLine=nil	
			回城()
			return
		end
	end
	goto begin
end
function 布拉基姆高地练级(目标等级,练级地名称)	
	清除系统消息()
	练级前经验=人物("经验")		
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")
	设置("自动加血",1)
	if(练级地名称 == "洞窟")then
		水晶名称="地水的水晶（5：5）"	
	else	--高地 龙骨 统一火风
		水晶名称="火风的水晶（5：5）"	
	end
	common.changeLineFollowLeader(队长名称)
::begin::						--开始
	等待空闲()
	common.changeLineFollowLeader(队长名称)
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	elseif (当前地图名=="艾尔莎岛" )then	
		goto erDao	
	elseif(取当前地图编号() ==  1112)then 回城() goto begin 
	elseif (当前地图名=="医院" )then	
		goto erYiYuan
	elseif (当前地图名=="冒险者旅馆" )then	
		goto scriptstart
	elseif (当前地图名=="盖雷布伦森林" )then	
		goto scriptstart
	elseif (当前地图名=="布拉基姆高地" )then	
		goto scriptstart
	elseif (当前地图名=="艾夏岛" )then	
		goto aiXiaDao
	end
	回城()
	等待(1000)
	goto begin
::erDao::
	等待到指定地图("艾尔莎岛")	
	设置("移动速度",走路加速值)
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)
	if(是否自动购买水晶==1)then common.checkCrystal(水晶名称) end 
	if(取当前地图名() ~= "艾尔莎岛")then
		回城()
		等待(1000)		
	end
	自动寻路(144,105)
	自动寻路(157,93)
	转向(2)	
	等待到指定地图("艾夏岛")		
	goto aiXiaDao	
::aiXiaDao::					--去医院
	自动寻路(112, 81)	
	goto erYiYuan
::erYiYuan::	
	等待到指定地图("医院")	
	设置("移动速度",走路还原值)
	自动寻路(35, 47)
	renew(1)        			-- 恢复人宠        
::checkAddTeam::
	--医院里检测掉魂
	common.changeLineFollowLeader(队长名称)
	if(取当前地图名() ~= "医院")then
		goto begin
	end
	--切换练级地检测
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		goto ting
	end
	if(人物("灵魂") > 0)then
		回城()
		等待(2000)
		goto begin
	end
	--黄白 继续砍怪 其余登出
	if(人物("健康") >= 1) then 
		common.checkHealth(医生名称)
		goto begin
	end	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end		
	等待(2000)
	common.joinTeam(队长名称)
	goto begin   
           
::scriptstart::
	leaderSetLv=getLeaderSetLv()
	当前地图名 = 取当前地图名()
	--卖魔石检测
	if(当前地图名 == "工房")then
		卖(21,23,卖店物品列表)	
	elseif(当前地图名 == "冒险者旅馆")then
		卖(37,29,卖店物品列表)	 
	end
	--切换练级地检测
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		goto ting
	end
	--队伍人数检测
	if(取队伍人数() < 2)then
		goto ting
	end
	if(人物("灵魂") > 0)then	
		等待空闲()
		回城()
		等待(2000)
		goto begin
	end
	--黄白 继续砍怪 其余登出
	if(人物("健康") >= 1) then 
		等待空闲()
		common.checkHealth(医生名称)
		goto begin
	end	
	--宠物受伤检测
	if(当前地图名 == "医院" and 宠物("健康") > 0 and 是否目标附近(7,6,1)==true)then	
		--不知道医生坐标
		转向坐标(7,6)	--需要改医生坐标
		等待服务器返回()
		对话选择(-1,6)		
	end
	等待(2000)
	goto scriptstart  
::ting::	
	--common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率
	等待空闲()
	if(取队伍人数() < 2)then	--掉线 回城
		回城()
		等待(2000)
	end	
	goto begin
::goEnd::
	return
end
function 洞窟练级(目标等级)	
	设置("自动加血",1)	
	练级前经验=人物("经验")	
::begin::	
	等待空闲()
	common.changeLineFollowLeader(队长名称)
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	leaderSetLv=getLeaderSetLv()	
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		return
	elseif (当前地图名=="艾尔莎岛" )then	
		goto erDao	
	elseif(取当前地图编号() ==  1112)then 回城() goto begin 
	elseif (当前地图名=="医院" )then	
		goto erYiYuan	
	elseif (当前地图名=="布拉基姆高地" )then	
		 goto addTeam
	elseif (当前地图名=="艾夏岛" )then	
		goto aiXiaDao
	elseif(取队伍人数() > 1)then
		goto yudi		
	end
	回城()
	等待(1000)
	goto begin
::aiXiaDao::					--去医院
	自动寻路(112, 81)	
	goto erYiYuan
::erDao::
	自动寻路(158, 94)	
	转向(0)
	等待到指定地图("艾夏岛")
	自动寻路(112, 81)	
::erYiYuan::
	等待到指定地图("医院")	
	leaderSetLv=getLeaderSetLv()	
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		return
	end
	if(取队伍人数() > 1)then
		goto yudi
	end	
	自动寻路(28, 46) 
	common.changeLineFollowLeader(队长名称)	
	common.joinTeam(队长名称,10)	
	goto begin
::addTeam::
	等待到指定地图("布拉基姆高地")	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto yudi
		else
			离开队伍()
		end				
	end	
	自动寻路(230,165) 	  
	common.joinTeam(队长名称)
	goto begin
::yudi::	
	leaderSetLv=getLeaderSetLv()	
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		goto ting
	end
	if(取队伍人数() < 2)then
		goto ting
	end	
	等待(2000)	
	goto yudi  
::ting::	
	-- 结束战斗	
	--喊话("共遇敌次数"..遇敌总次数,2,3,5)
	--common.statistics(练级前时间,练级前经验)	--统计脚本效率
	回城()
	等待(2000)
	goto begin 
end

--登补 比走路快
function 雪塔练级(目标等级)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")	
	水晶名称="地水的水晶（5：5）"	
	if(目标等级==50 or 目标等级==55 or 目标等级==60)then		
		水晶名称="地水的水晶（5：5）"
	elseif(目标等级==65 or 目标等级==70  or 目标等级==80)then	
		水晶名称="火风的水晶（5：5）"
	end	
	设置("自动加血",0)
::begin::	
	等待空闲()
	common.changeLineFollowLeader(队长名称)
	common.checkHealth(医生名称)
	if(是否自动购买水晶==1)then common.checkCrystal(水晶名称) end	
	local 当前地图名 = 取当前地图名()	
	local leaderSetLv=getLeaderSetLv()
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		return	
	elseif (当前地图名=="艾尔莎岛" )then		
		goto aiDao	
	elseif (string.find(当前地图名,"雪拉威森塔") ~= nil)then	
		goto scriptstart		
	elseif (当前地图名=="国民会馆" )then	
		goto 国民会馆	
	end
	回城()
	等待(1000)
	goto begin
::aiDao::
	设置("移动速度",走路加速值)
	自动寻路(165,153)
	等待(1000)	
	对话选是(4)	
::liXiaDao::
	等待到指定地图("利夏岛")	
	自动寻路(90,99,"国民会馆")
::国民会馆::	
	自动寻路(110,43)	
	卖(110,42, 卖店物品列表)		
	自动寻路(109,51)
	回复(108,52)
	--转向(108,52)
	自动寻路(109,50)
::checkAddTeam::
	common.changeLineFollowLeader(队长名称)
	--医院里检测掉魂
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end		
	--切换练级地检测
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		goto ting
	end
	自动寻路(113,50)
	等待(2000)
	common.joinTeam(队长名称,300)
	goto begin  	
             
::scriptstart::
	leaderSetLv=getLeaderSetLv()
	当前地图名 = 取当前地图名()
	--卖魔石检测
	if(当前地图名 == "国民会馆")then
		卖(110,42,卖店物品列表)	
	end
	--切换练级地检测
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		goto ting
	end
	--队伍人数检测
	if(取队伍人数() < 2)then
		goto ting
	end
	common.checkHealth(医生名称)	
	等待(2000)
	goto scriptstart  
::ting::	
	停止遇敌()                 -- 结束战斗	
	等待空闲()
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	
	回城()
	等待(2000)	
	goto begin 
end
function 回廊练级(目标等级)
	设置("自动加血",0)	
	练级前经验=人物("经验")
	
::begin::	
	等待空闲()
	common.changeLineFollowLeader(队长名称)	
	common.supplyCastle()
	common.checkHealth(医生名称)
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	local leaderSetLv=getLeaderSetLv()
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		return	
	elseif (当前地图名=="艾尔莎岛" )then	
		自动寻路(140,105)				
		转向(1)
		等待服务器返回()
		对话选择(4,0)
		等待到指定地图("里谢里雅堡")
		common.toCastle()
		common.sellCastle(卖店物品列表)	
		goto liBao
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao	
	elseif (当前地图名=="过去与现在的回廊" )then	
		goto addTeam		
	end
	回城()
	goto begin
::liBao::	
	自动寻路(52, 72)	
	对话选是(2)	
::addTeam::
	if(取当前地图名() ~= "过去与现在的回廊")then
		goto begin
	end	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto yudi
		else
			离开队伍()
		end				
	end	
	--切换练级地检测
	leaderSetLv=getLeaderSetLv()
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		goto ting
	end
	自动寻路(10, 20)
	common.changeLineFollowLeader(队长名称)
	common.joinTeam(队长名称)
	goto begin
::yudi::	
	leaderSetLv=getLeaderSetLv()
	if(人物("血") < 补血值) then goto  ting end
	if(人物("魔") < 补魔值) then goto  ting end
	if(宠物("血") < 宠补血值) then goto  ting end
	if(宠物("魔") < 宠补魔值) then goto  ting end
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		goto ting
	end
	if(取队伍人数() < 2)then
		goto ting
	end
	if(checkCharisma())then goto begin end	--检查魅力
	common.checkHealth(医生名称)	
	等待(2000)	
	goto yudi  
::ting::	
	-- 结束战斗	
	--喊话("共遇敌次数"..遇敌总次数,2,3,5)
	--common.statistics(练级前时间,练级前经验)	--统计脚本效率	
	回城()		
	等待(2000)
	goto begin 
end

function 营地任务()
	common.checkHealth(医生名称)
	common.supplyCastle()
	common.toCastle()
::begin::		
	if(取物品数量("怪物碎片") > 0)then 
		goto mission
	end
	if(取物品数量("信笺") < 1 and 取物品数量("信") < 1 and 取物品数量("承认之戒") < 1)then
		common.toCastle("f3")
		对话坐标选是(5,3)		
	end	
	if(取物品数量("信笺") > 0)then		
		goto mission
	end
	if(取物品数量("信") > 0)then		
		common.toCastle("f3")
		对话坐标选是(5,3)	
		日志("神域任务已完成！")
		return		
	end
	goto begin	
::mission::
	当前地图名 = 取当前地图名()
	if(当前地图名 =="研究室" ) then
		扔("魔石")
		对话坐标选是(14,14)
	elseif(取物品数量("怪物碎片") < 1 and 取物品数量("信") < 1 and 取队伍人数() < 2 )then		
		common.checkHealth(医生名称)
		common.supplyCastle()
		common.toCastle()
		自动寻路(41,83)		
		common.joinTeam(队长名称)
		if(取队伍人数() > 1)then
			if(common.judgeTeamLeader(队长名称)==true) then
				goto mission
			else
				离开队伍()
			end				
		end	
	elseif(取物品数量("怪物碎片") > 0)then
		--回城()
		等待(2000)
		common.gotoFaLanCity()	
		自动寻路(153,241,"芙蕾雅")
		自动寻路(513,282,"曙光骑士团营地")
		自动寻路(52,68,"曙光营地指挥部")
		if(目标是否可达(69,70))then
			自动寻路(69,70)
		end	
		if(目标是否可达(95,7))then
			自动寻路(95,6)
			对话选是(95,7)
		end			
	elseif(取物品数量("信") > 0)then
		common.toCastle("f3")
		对话坐标选是(5,3)	
		日志("神域任务已完成！")
		return		
	elseif (取物品数量("团长的证明") > 0 ) then
		if(是否目标附近(40,22))then
			对话选是(40,22)		
		end		
	elseif(取物品数量("信笺") > 0)then		
		if(是否目标附近(95,7))then
			对话选是(95,7)
		end		
	end	
	等待(3000)
	goto mission
end


function 营地练级(目标等级,练级地名称)
	清除系统消息()
	练级前经验=人物("经验")		
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")
	设置("自动加血",1)
	if(练级地名称 == "营地")then
		水晶名称="火风的水晶（5：5）"
	elseif(练级地名称 == "沙滩")then
		水晶名称="风地的水晶（5：5）"
	elseif(练级地名称 == "黑一")then
		水晶名称="水火的水晶（5：5）"
	end
	日志(练级地名称.."练级",1)
	--暂时调过
::judgeMission::
	等待空闲()
	if(取物品数量("承认之戒") < 1)then
		设置个人简介("玩家称号","需要做承认任务")
		goto mission
	else
		设置个人简介("玩家称号","有承认")
	end	
	goto begin
::mission::	
	营地任务()
	goto judgeMission
	
::begin::
	等待空闲()
	common.changeLineFollowLeader(队长名称)
	leaderSetLv=getLeaderSetLv()	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end	
	if(人物("金币")>950000)then
		waitTopic()	
	end
	当前地图名 = 取当前地图名()	
	mapIndex = 取当前地图编号()
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	elseif (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(取当前地图编号() ==  1112)then 回城() goto begin 
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "工房")then goto gongFang
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "商店")then goto yingDiShangDian
	elseif(当前地图名 ==  "银行" and mapIndex == 44698)then goto yingDiYinHang
	elseif(当前地图名 ==  "肯吉罗岛")then goto scriptstart end
	回城()
	等待(1000)
	goto begin
::yingDiShangDian::
	营地商店检测水晶()
	自动寻路(0,14,"圣骑士营地")	
	goto begin
::yingDiYinHang::
	自动寻路(3,23,"圣骑士营地")	
	goto begin
::gongFang::
	自动寻路( 30, 37)
    等待到指定地图("圣骑士营地",87,72)     
	goto begin
::quYiYuan::
	--金币满存银行检测
	if(当前地图名 == "圣骑士营地" and 人物("金币") > 满金币存银行数)then
		离开队伍()
		营地存取金币(-身上最少金币数*2)		--留10万指定金币
		goto begin
	elseif(当前地图名 == "圣骑士营地" and 人物("金币") < 身上最少金币数)then
		离开队伍()
		营地存取金币(-身上最少金币数*2,"取")	--取出后 身上总30万
		goto begin
	end	
	自动寻路( 95, 73)
	自动寻路( 95, 72)
	goto begin 
::quYingDi::
	设置("移动速度",走路加速值)
	common.checkHealth(医生名称)
	if(是否自动购买水晶==1)then common.checkCrystal(水晶名称) end
	common.supplyCastle()
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin
::StartBegin::
	等待到指定地图("医院")
	--医院里检测掉魂
	if(人物("灵魂") > 0)then--人物("健康") > 0 or
		回城()
		等待(2000)
		goto begin
	end
	--黄白 继续砍怪 其余登出
	if(人物("健康") >= 50) then 
		common.localHealPlayer()	
		if(人物("健康") ~= 0 ) then
			回城()
			等待(2000)
			goto begin
		else
			离开队伍()	--localHealPlayer会进行离队 这里再次调用下
		end		
	end	
   if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end	
	自动寻路(9,14)	
	等待(1000)
	common.changeLineFollowLeader(队长名称)
	common.joinTeam(队长名称)
	goto begin   

::huiYingDi::
	自动寻路(551, 332,"圣骑士营地")
	goto begin
               
::scriptstart::
	leaderSetLv=getLeaderSetLv()
	当前地图名 = 取当前地图名()
	--卖魔石检测
	if(当前地图名 == "工房")then
		卖(21,23,卖店物品列表)	
	end
	--切换练级地检测
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		goto ting
	end
	--队伍人数检测
	if(取队伍人数() < 2)then
		goto ting
	end
	--宠物受伤检测
	if(当前地图名 == "医院" and 宠物("健康") > 0 and 是否目标附近(7,6,1)==true)then	
		转向坐标(7,6)
		等待服务器返回()
		对话选择(-1,6)		
	end
	--金币满存银行检测
	if(当前地图名 == "圣骑士营地")then
		if(checkMainSkillLevel())then		--检测调教技能
			设置("遇敌全跑",0)				--防止哪个脚本卡了这个 不行的话 重新读取配置	
			goto begin						--提升阶级后，重新begin
		end 
		if(checkCharisma())then goto begin end	--检查魅力
		if(人物("金币") > 满金币存银行数)then
			离开队伍()
			营地存取金币(-身上最少金币数*2)		--留10万指定金币
			goto begin
		elseif(人物("金币") < 身上最少金币数)then
			离开队伍()
			营地存取金币(-身上最少金币数*2,"取")	--取出后 身上总30万
			goto begin
		end	
	end	
	等待(2000)
	goto scriptstart  
	
::ting::
--	停止遇敌()       	
	日志("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率
	等待空闲()
	if(取队伍人数() < 2)then	--掉线 回城
		回城()
		等待(2000)
	end
	goto begin
::goEnd::
	return
end

function 拿酒瓶()	
	local tryCount=0
	if(取物品数量("矮人徽章")>0 or 取物品数量("巴萨的破酒瓶")>0)then
		return true
	end		
	自动寻路(116,56,"酒吧")
::tryNa::
	自动寻路(14, 7) 
	对话选是(0)
	tryCount= tryCount+1
	if(tryCount > 3 and 取物品数量("巴萨的破酒瓶")< 1)then
		goto tryNa
	end
	自动寻路(0,23,"圣骑士营地")
	return true
end
--蝎子 石头人 和蜥蜴 公用一个吧
function 矮人练级(目标等级,练级地名称)
	清除系统消息()
	练级前经验=人物("经验")		
	设置("自动加血",1)
	if(练级地名称 == "蝎子")then
		水晶名称="水火的水晶（5：5）"
	else
		水晶名称="风地的水晶（5：5）"	
	end	
	
	
::judgeMission::
	if(取物品数量("承认之戒") < 1)then
		--设置个人简介("玩家称号",需要做承认任务)
		goto mission
	else
		--设置个人简介("玩家称号",目标等级)
	end	
	goto begin
::mission::	
	营地任务()
	goto judgeMission
	
::begin::
	等待空闲()
	common.changeLineFollowLeader(队长名称)
	leaderSetLv=getLeaderSetLv()	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end	
	当前地图名 = 取当前地图名()	
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	elseif (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(取当前地图编号() ==  1112)then 回城() goto begin 
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "工房")then goto gongFang	
	elseif(当前地图名 ==  "圣骑士营地")then goto jiuPing
	elseif(当前地图名 ==  "矮人城镇")then goto scriptstart 
	elseif(当前地图名 ==  "蜥蜴洞穴")then goto scriptstart 
	elseif(当前地图名 ==  "蜥蜴洞穴上层第1层")then goto scriptstart 
	elseif(当前地图名 ==  "肯吉罗岛")then goto scriptstart end
	回城()
	等待(1000)
	goto begin
::gongFang::
	自动寻路( 30, 37)
    等待到指定地图("圣骑士营地",87,72)     
	goto begin
::jiuPing::
	拿酒瓶()	
::quYiYuan::
	自动寻路( 95, 73)
	自动寻路( 95, 72)
	goto begin 
::quYingDi::
	设置("移动速度",走路加速值)
	common.checkHealth(医生名称)
	common.supplyCastle()
	if(是否自动购买水晶==1)then common.checkCrystal(水晶名称) end
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin
::StartBegin::
	等待到指定地图("医院")
	--医院里检测掉魂
	if(人物("灵魂") > 0)then--人物("健康") > 0 or
		回城()
		等待(2000)
		goto begin
	end
	--黄白 继续砍怪 其余登出
	if(人物("健康") >= 50) then 
		common.localHealPlayer()	
		if(人物("健康") ~= 0 ) then
			回城()
			等待(2000)
			goto begin
		else
			离开队伍()	--localHealPlayer会进行离队 这里再次调用下
		end		
	end	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end	
	自动寻路(9,14)	
	等待(1000)
	common.changeLineFollowLeader(队长名称)
	common.joinTeam(队长名称)
	goto begin   
	
::scriptstart::
	leaderSetLv=getLeaderSetLv()
	mapName=取当前地图名()
	if(mapName == "工房")then
		卖(21,23,卖店物品列表)	
	elseif(mapName == "矮人城镇")then
		if(checkMainSkillLevel())then		--检测调教技能
			设置("遇敌全跑",0)				--防止哪个脚本卡了这个 不行的话 重新读取配置	
			goto begin						--提升阶级后，重新begin
		end 
		if(checkCharisma())then goto begin end	--检查魅力
		卖(122, 110,卖店物品列表)	
	end
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		goto ting
	end
	if(取队伍人数() < 2)then
		goto ting
	end
	if(是否目标附近(96,124,1)==true)then	--对话老人 防止队长满包裹卡住
		对话选是(96,124)
	end	
	等待(2000)
	goto scriptstart  
	
::ting::
--	停止遇敌()       	
--	喊话("共遇敌次数"..遇敌总次数,2,3,5)
--	common.statistics(练级前时间,练级前经验)	--统计脚本效率
	等待空闲()
	if(取队伍人数() < 2)then	--掉线 回城
		回城()
		等待(2000)
	end
	goto begin
::goEnd::
	return
end



function 旧日练级(目标等级)
	--设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")	
	水晶名称="地水的水晶（5：5）"
	outMazeX=nil	--练级时 记录迷宫坐标
	outMazeY=nil	
::begin::
	等待空闲()
	common.changeLineFollowLeader(队长名称)
	leaderSetLv=getLeaderSetLv()	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end	
	当前地图名 = 取当前地图名()	
	mapIndex = 取当前地图编号()
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	elseif (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 	
	elseif(当前地图名 ==  "圣骑士营地")then goto quMiGong
	elseif(当前地图名 ==  "旧日之地")then goto jiuRiZhiDi
	elseif(当前地图名 ==  "迷宫入口")then goto StartBegin
	elseif (string.find(当前地图名,"旧日迷宫")~= nil )then goto scriptstart
	elseif(当前地图名 ==  "商店")then goto yingDiShangDian
	elseif(当前地图名 ==  "银行" and mapIndex == 44698)then goto yingDiYinHang end
	回城()
	等待(1000)
	goto begin
::yingDiShangDian::
	营地商店检测水晶()
	自动寻路(0,14,"圣骑士营地")	
	goto begin
::yingDiYinHang::
	if(人物("金币") > 950000)then
		营地存取金币(-300000)		--留30万
	elseif(人物("金币") <50000)then
		营地存取金币(-300000,"取")	--取出后 身上总30万
	end
	自动寻路(3,23,"圣骑士营地")	
	goto begin

::quYingDi::
	设置("移动速度",走路加速值)
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)
	if(是否自动购买水晶==1)then common.checkCrystal(水晶名称) end
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin
::quMiGong::	
	if(取物品数量("战斗号角") < 1)then
		自动寻路(116,69,"总部1楼")
		自动寻路(86,50)
		对话选是(2)
		自动寻路(4,47,"圣骑士营地")		
	end	
	自动寻路(116,81)
	自动寻路(119,81)
	转向(2)
	等待服务器返回()
	对话选择("1", "", "")	
	对话选择("1", "", "")	
	等待(2000)
	等待空闲()
::jiuRiZhiDi::
	if(取当前地图名() ~= "旧日之地" ) then		
		goto begin
	end
	自动寻路(45,47)	
	转向(0, "")
	等待服务器返回()
	对话选择("1", "", "")	
	对话选择("1", "", "")
	等待空闲()
	goto mazeEntrance
::mazeEntrance::
	if(取当前地图名() ~= "迷宫入口" ) then
		goto begin
	end	
	goto StartBegin
::StartBegin::	
	--医院里检测掉魂
	if(人物("灵魂") > 0)then--人物("健康") > 0 or
		回城()
		等待(2000)
		goto begin
	end
	--黄白 继续砍怪 其余登出
	if(人物("健康") >= 50) then 
		common.localHealPlayer()	
		if(人物("健康") ~= 0 ) then
			回城()
			等待(2000)
			goto begin
		else
			离开队伍()	--localHealPlayer会进行离队 这里再次调用下
		end		
	end	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end		
	common.changeLineFollowLeader(队长名称)	
	等待(2000)
	common.joinTeam(队长名称)
	goto begin   
	
::scriptstart::
	leaderSetLv=getLeaderSetLv()	
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		goto ting
	end
	if(取队伍人数() < 2)then
		goto ting
	end		
	等待(4000)
	goto scriptstart  
	
::ting::
	日志("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率
	等待空闲()
	if(取队伍人数() < 2)then	--掉线 回城
		回城()
		等待(2000)
	end	
	goto begin
::goEnd::
	return

end

function 半山练级(目标等级)
	日志("半山练级",1)	
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")	
	水晶名称="火风的水晶（5：5）"
::begin::
	停止遇敌()	
	等待空闲()
	if(checkMainSkillLevel())then		--检测调教技能
		设置("遇敌全跑",0)				--防止哪个脚本卡了这个 不行的话 重新读取配置	
		goto begin						--提升阶级后，重新begin
	end 
	if(checkCharisma())then goto begin end	--检查魅力
	if(人物("金币") < 多少金币去拿钱) then
		日志("人物金币不够，去银行取钱，当前金币【"..人物("金币").."】")
		common.getMoneyFromBank(多少金币去拿钱)
	end
	common.changeLineFollowLeader(队长名称)
	leaderSetLv=getLeaderSetLv()	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end	
	当前地图名 = 取当前地图名()		
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	elseif(当前地图名 =="艾尔莎岛" )then goto toIsland
	elseif(当前地图名 ==  "里谢里雅堡")then goto toIsland 
	elseif(当前地图名 ==  "法兰城")then goto toIsland 	
	elseif(当前地图名 ==  "小岛")then goto island
	elseif(当前地图名 ==  "图书室")then goto library
	elseif(当前地图名 ==  "半山腰")then goto scriptstart
	end	
	回城()
	等待(1000)
	goto begin
::toIsland::
	if(取物品数量("阿斯提亚锥形水晶") > 0)then
		使用物品("阿斯提亚锥形水晶")
		等待(2000)
		goto island
	end
	设置("移动速度",走路加速值)
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)
	if(是否自动购买水晶==1)then common.checkCrystal(水晶名称) end
	if(半山西门)then
		goto falanw
	else
		common.toCastle("f2")
		自动寻路(0,74,"图书室")
		goto library
	end
	goto begin
::library::					--图书室
	扔("锄头")
	自动寻路(27,16)
	设置("移动速度",走路还原值)
	对话选是(27,15)
	goto begin
::falanw::	--西门
	common.outFaLan("w")
	自动寻路(396,168)
	自动寻路(397,168)
	对话选是(398,168)
	goto begin
::island::
	if(取当前地图名() ~= "小岛")then
		goto begin
	end	
	if(人物("坐标") ~= "65,97")then
		自动寻路(65,97)
		common.checkHealth(医生名称)--一个人 如果受伤 则回城		
		goto begin
	end
	--组队
::makeTeam::	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end		
	common.changeLineFollowLeader(队长名称)	
	等待(2000)
	common.joinTeam(队长名称)
	goto begin   
   
::scriptstart::
	leaderSetLv=getLeaderSetLv()	
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		goto ting
	end
	if(取队伍人数() < 2)then
		goto ting
	end		
	等待(4000)
	goto scriptstart  
	
::ting::
	日志("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率
	等待空闲()
	if(取队伍人数() < 2)then	--掉线 回城
		回城()
		等待(2000)
	end	
	goto begin
::goEnd::
	return
end
function 取当前等级()
	local avgLevel=人物("等级")
	if(是否练宠==1)then
		avgLevel=取队伍宠物平均等级()		
	else
		avgLevel=队伍("平均等级")	
	end
	return avgLevel
end
--获取队长的练级等级
function getLeaderSetLv()
	local 队长名片 = 取好友名片(队长名称)
	if( 队长名片 ~= nil)then
		lv = tonumber(队长名片.title)
		日志("队长等级:"..lv)
		return lv
	end
	喊话("队长不在线",2,3,5)
	return nil
end
--检测驯兽技能等级 
function checkTamerSkillLevel()
	if(是否是驯兽 == false)then
		return false
	end
	local nowSkillLv = common.playerSkillLv("调教")
	if(nowSkillLv == 0 or nowSkillLv>=8)then	--3转以后 先屏蔽
		return false
	end
	--4转 5转 不转 这里没有自动调用4转5转任务
	local rankLv = 人物("职称等级")
	if(nowSkillLv >= (4 + rankLv*2))then
		--去提升等价
		执行脚本("./脚本/★转正/★提升阶级-驯兽.lua")	
		等待(2000)
		if(rankLv == 人物("职称等级"))then	
			-- 【一 二 三转任务】 三转先放一下 这个需要队伍联动
			if(rankLv == 0)then		--1转树精
				回城()
				执行脚本("./脚本/★转正/★晋级-树精一转单人版不等待.lua")	
			elseif(rankLv == 1)then --2转神兽
				回城()
				执行脚本("./脚本/★转正/★晋级-神兽二转.lua")	
			else -- 3 4 5先不做
				return false
			end
			执行脚本("./脚本/★转正/★提升阶级-驯兽.lua")
		end		
		--不管成功与否 继续回去练级 当然 下次战斗判断 会重复进入此步
		return true
	end
	return false
end
--检查忍者职业技能  暂时不扩展，可以用表 把职业技能 和提升阶级脚本关联起来
function checkNinjaSkillLevel()
	local nowSkillLv = common.playerSkillLv("暗杀")
	if(nowSkillLv == 0 or nowSkillLv>=8)then	--3转以后 先屏蔽
		return false
	end
	--4转 5转 不转 这里没有自动调用4转5转任务
	local rankLv = 人物("职称等级")
	if(nowSkillLv >= (4 + rankLv*2))then
		--去提升等价
		执行脚本("./脚本/★转正/★提升阶级-忍者.lua")	
		等待(2000)
		if(rankLv == 人物("职称等级"))then	
			-- 【一 二 三转任务】 三转先放一下 这个需要队伍联动
			if(rankLv == 0)then		--1转树精
				回城()
				执行脚本("./脚本/★转正/★晋级-树精一转单人版不等待.lua")	
			elseif(rankLv == 1)then --2转神兽
				回城()
				执行脚本("./脚本/★转正/★晋级-神兽二转.lua")	
			else -- 3 4 5先不做
				return false
			end
			执行脚本("./脚本/★转正/★提升阶级-忍者.lua")
		end		
		--不管成功与否 继续回去练级 当然 下次战斗判断 会重复进入此步
		return true
	end
	return false
end
function checkMainSkillLevel()
	local profession=人物("职业")
	if(profession == "驯兽师")then
		return checkTamerSkillLevel()
	elseif(profession == "忍者")then
		return checkNinjaSkillLevel()
	end	
	return false
end
--检查魅力 没有完美调教术的 才检查
function checkCharisma()
	if(是否有完美调教)then return false end
	--if(人物("魅力") < 60 and 宠物("忠诚") < 60)then
	if(人物信息().value_charisma  < 60 and 宠物("忠诚") < 60)then
		if(人物("金币") > 200000)then	--40w 金币 去买魅力
			执行脚本("./脚本/其他/★花钱买魅力.lua")
			return true
		end
	end
	return false
end
function main()    
	--跟随队长设置切换练级地图		
	while true do
		local avgLevel=getLeaderSetLv()	
		leaderSetLv=avgLevel
		common.changeLineFollowLeader(队长名称)		
		if(avgLevel ~= nil)then
			喊话("队长当前设置练级等级："..avgLevel,2,3,5)
			if(avgLevel == 20)then		--森林
				布拉基姆高地练级(20,"森林")	
			elseif(avgLevel == 27)then		--鸡场
				布拉基姆高地练级(27,"鸡场")			
			elseif(avgLevel == 32)then		--龙骨
				布拉基姆高地练级(32,"龙骨")
			elseif(avgLevel == 37)then		--黄金龙骨
				布拉基姆高地练级(37,"黄金龙骨")
			elseif(avgLevel == 44)then		--洞穴
				布拉基姆高地练级(44,"洞窟")			
			elseif(avgLevel==50)then		--洞穴
				雪塔练级(50)					
			elseif(avgLevel==55)then		--洞穴
				雪塔练级(55)			
			elseif(avgLevel==60)then		--T59
				雪塔练级(60)
			elseif(avgLevel==65)then		--T59
				雪塔练级(65)				
			elseif(avgLevel==70)then		--回廊
				雪塔练级(70)
			elseif(avgLevel==75)then		--回廊
				雪塔练级(75)	
			elseif(avgLevel==80)then		--回廊
				雪塔练级(80)	
			elseif(avgLevel==85)then		--回廊
				雪塔练级(85)	
			elseif(avgLevel==60)then		--回廊
				 回廊练级(60)	
			elseif(avgLevel==71)then		--营地
				营地练级(71,"营地")
			elseif(avgLevel == 78)then		--蝎子
				矮人练级(78,"蝎子")
			elseif(avgLevel == 85)then		--沙滩
				营地练级(85,"沙滩")
			elseif(avgLevel == 93)then		--石头
				矮人练级(93,"石头")
			elseif(avgLevel == 103)then		--蜥蜴
				矮人练级(103,"蜥蜴")
			elseif(avgLevel == 115)then		--黑一
				营地练级(115,"黑一")
			elseif(avgLevel == 135)then		--龙顶 或 旧日 
				旧日练级(135)
			-- elseif(avgLevel == 160)then		--龙顶		
				-- 营地练级(160,"龙顶")
			elseif(avgLevel == 160)then		--半山		
				半山练级(160)
			elseif(avgLevel >= 160)then	
				喊话("已满级，脚本退出",2,3,5)
				return
			end		
		end
		等待(2000)
    end
end
main()