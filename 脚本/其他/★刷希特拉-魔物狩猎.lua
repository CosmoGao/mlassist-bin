启动点::艾尔莎,辛美尔 说明:　　目标遗留品的数量是以整队人来计算.并非一定要在一个人身上；同一种目标遗留品只算一个.一直打一处BOSS没有意义。奖品是随机发放的，并不是身上目标遗留品越多奖品就越好，也许你身上一件目标遗留品都没有，但换到了好奖品。 
	
	
common=require("common")


设置("timer", 20)	
	
	
设置("高速延时", 3)	
设置("自动叠",1,"地的水晶碎片&999")
设置("自动叠",1,"水的水晶碎片&999")
设置("自动叠",1,"火的水晶碎片&999")
设置("自动叠",1,"风的水晶碎片&999")
设置("自动扔",1,"卡片？")


isSuccessed=false		--是否成功鉴定过
	

补血值=取脚本界面数据("人补血")
补魔值=取脚本界面数据("人补魔")
宠补血值=取脚本界面数据("宠补血")
宠补魔值=取脚本界面数据("宠补魔")

if(补血值==nil or 补血值==0)then
	补血值=用户输入框("多少血以下补血", "430")
end
if(补魔值==nil or 补魔值==0)then
	补魔值 = 用户输入框("多少魔以下补魔", "200")
end
if(宠补血值==nil or 宠补血值==0)then
	宠补血值 = 用户输入框( "宠多少血以下补血", "300")
end
if(宠补魔值==nil or 宠补魔值==0)then
	宠补魔值=用户输入框( "宠多少魔以下补魔", "150")
end



local targetCondition={
	[1]={have=nil,dontHave=2,x=120,y=178,mapId=59959},
	[2]={have=nil,dontHave=3,x=208,y=226,mapId=59959},
	[3]={have=nil,dontHave=4,x=297,y=181,mapId=59956},
	[4]={have=nil,dontHave=5,x=240,y=200,mapId=59959},
	[5]={have=1,dontHave=nil,x=201,y=183,mapId=59959},
	[6]={have=9,dontHave=14,x=273,y=232,mapId=59958},
	[7]={have=3,dontHave=8,x=306,y=257,mapId=59959},
	[8]={have=3,dontHave=9,x=207,y=176,mapId=59959},
	[9]={have=5,dontHave=10,x=250,y=115,mapId=59959},
	[10]={have=6,dontHave=11,x=163,y=135,mapId=59959},
	[11]={have=6,dontHave=12,x=205,y=294,mapId=59959},
	[12]={have=8,dontHave=13,x=237,y=216,mapId=59958},
	[13]={have=9,dontHave=14,x=230,y=159,mapId=59958},
	[14]={have=9,dontHave=15,x=161,y=120,mapId=59959},
	[15]={have=9,dontHave=16,x=219,y=257,mapId=59959},
	[16]={have=11,dontHave=2,x=233,y=126,mapId=59959}
}
local targetOrder={1,2,5,9,6,13,14,3,11,8,10,4,16,12,15,7}
local targetQuarryName="目标遗留品No"
local targetNumber={1,2,3,4,5,6,7,8,9,'A','B','C','D','E','F','G'}
local currentOrder=1
--根据当前轮 挑选队长
--拥有的物品  以及包裹空格
function SelectLeader(tgtNumber)
	if(tgtNumber == nil)then return false end
	--时刻更新自己的物品信息
	local haveList=''
	for i,v in pairs(targetNumber) do
		local newName=targetQuarryName..i	 
		if(取物品数量(newName) >0)then
			haveList=haveList..v
		end
	end
	设置个人简介("玩家称号",haveList)
end

function toTargetBoss(tgtNumber)
	if(tgtNumber == nil)then return false end
	local nextBoss = targetCondition[tgtNumber]
	if(nextBoss ~= nil)then
		toTargetMap(nextBoss.mapId)
		移动(nextBoss.x,nextBoss.y)
	end
	--开始遇敌()
end

function toTargetMap(tgtMapNum)
	if(tgtMapNum == nil)then return end
	local mapNumber = 取当前地图编号()
	if(tgtMapNum == 59959)then
		if(mapNumber == 59956)then
			移动(334,214,59959)
		elseif(mapNumber == 59958)then			
			移动(301,250,59959)	
		end
	elseif(tgtMapNum == 59956)then
		if(mapNumber == 59959)then
			移动(54,194,59956)
		elseif(mapNumber == 59958)then
			移动(66,198,59956)		
		end
	elseif(tgtMapNum == 59958)then
		if(mapNumber == 59959)then
			移动(154,103,59958)
		elseif(mapNumber == 59956)then
			移动(196,65,59958)		
		end
	end	
end
function checkSelfHaveItems()
	local haveList=''
	for i,v in pairs(targetNumber) do
		local newName=targetQuarryName..i	 
		if(取物品数量(newName) >0)then
			haveList=haveList..v
		end
	end
	return haveList
end

function checkAndSetSelfHaveItems()
	local haveList = checkSelfHaveItems()
	设置个人简介("玩家称号",haveList)
end

--检查总数量
function leaderCheckTotal()
	local newTargetNumberList=targetNumber
	local teamPlayers = 队伍信息()	
	for index,teamPlayer in ipairs(teamPlayers) do	
		if(teamPlayer.is_me ~= 0)then
			local friendCard = 取好友名片(teamPlayer)
			local tblSize=common.getTableSize(newTargetNumberList)
			if(friendCard ~= nil)then
				for i=tblSize,1,-1 do
					if(string.find(friendCard.title,newTargetNumberList[i]) ~= nil)then
						table.remove(newTargetNumberList,i)						
					end			
				end			
			end		
		end
	end	
	local selfItems = checkSelfHaveItems()
	local tblSize=common.getTableSize(newTargetNumberList)
	for i=tblSize,1,-1 do
		if(string.find(selfItems,newTargetNumberList[i]) ~= nil)then
			table.remove(newTargetNumberList,i)			
		end			
	end			
	if(common.getTableSize(newTargetNumberList) == 0)then
		return true
	end
	return false	
end

function checkTeamHaveTgtNumber(tgtNum)
	if tgtNum == nil then return end
	等待空闲()
	--日志("检查队伍是否有目标物："..tgtNum)
	local teamPlayers = 队伍信息()	
	for index,teamPlayer in ipairs(teamPlayers) do	
		if(teamPlayer.is_me ~= 0)then
			local friendCard = 取好友名片(teamPlayer)			
			if(friendCard ~= nil)then				
				if(string.find(friendCard.title,tgtNum) ~= nil)then
					return true					
				end						
			end		
		end
	end	
	local selfItems = checkSelfHaveItems()	
	if(string.find(selfItems,tgtNum) ~= nil)then
		return true
	end	
	return false	

end
function main()
	清除系统消息()	
::begin::	
	等待空闲()
	mapNum=取当前地图编号()
	mapName=取当前地图名()
	if(mapName == "公寓")then goto 补魔 end 
	if(mapName == "辛梅尔")then goto 开始 end 
	if(mapName == "艾尔莎岛")then goto 出发 end
	if(mapName == "光之路")then goto map59505 end 
	if(mapNum == 59959)then goto map59959 	--圣炎高地
	elseif(mapNum == 59956)then goto map59956
	elseif(mapNum == 59958)then goto map59958
	
	end
	goto begin
	common.checkHealth()
	common.checkCrystal(水晶名称)
	回城()
	等待(2000)
	goto begin 
::map59505::		--光之路
	移动(199,94)
	对话选是(200,95)
	goto begin
::map59956::		--圣炎高地
	goto loopCheck	
::map59958::		--圣炎高地		--北区  换奖也在这
	if(目标是否可达(208,340))then	--换奖
		移动(208,340)
		对话选是(209,339)
		goto begin
	end
	goto loopCheck		
::map59959::		--圣炎高地
	--开始
	if(取物品数量("猎人证") < 1)then	--623000
		移动(210,271)
		对话选是(211,271)
	end
	goto loopCheck	
	--结束
	移动(207,268)
	对话选是(207,267)
	goto begin
::loopCheck::
	--组队 检查总数
	if(currentOrder >= 1 and currentOrder <= 16)then
		日志("检查队伍是否有目标物："..targetOrder[currentOrder])
		if(checkTeamHaveTgtNumber(targetOrder[currentOrder])==false)then
			日志("没有目标物："..targetOrder[currentOrder].."，去目标Boss位置")
			toTargetBoss(targetOrder[currentOrder])
			开始遇敌()
			while checkTeamHaveTgtNumber(targetOrder[currentOrder])==false do
				if(人物("血") < 200 or 宠物("血") < 200)then
					停止遇敌()
					goto 回辛梅尔
					return
				end
				等待(2000)
			end
			停止遇敌()
		end
		日志("已经有目标物【"..targetOrder[currentOrder].."】继续下一个",1)
		--停止遇敌()
		currentOrder=currentOrder+1
		日志("下一目标物【"..targetOrder[currentOrder].."】",1)
	end
	goto begin
::回辛梅尔::
	common.checkHealth()		--受伤登出  否则 走回去回补
	toTargetMap(59959)
	移动(209,330,"光之路")		
	移动(201, 19,"辛梅尔")		
	移动(191,99)
	goto 开始 
::出发::	
	if(取物品数量("王冠") < 1)then		
		common.gotoBankTalkNpc()
		银行("取物","王冠",1)
		等待(2000)
		if(取物品数量("王冠") < 1)then
			日志("脚本需要王冠，如果没有的话，请走到辛美尔在启动",1)			
			等待(2000)
			goto begin
		else
			回城()
			goto begin
		end
	end
	移动(165,153)	
	转向(4)
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("利夏岛")	
	移动(90,99,"国民会馆")	
	移动(108,39,"雪拉威森塔１层")
	移动(34,95)	
	转向(2)
	等待服务器返回()	
	对话选择("4", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
::开始::		
	等待到指定地图("辛梅尔")	
	移动(181,81,"公寓")	
	移动(93,58)   	
::补魔::		
	移动(91,58)   	 
	回复(0)	
	日志("人物金币："..人物("金币"))		
	移动(100,70,"辛梅尔")	 	
	移动(207,91,"光之路")			
	goto begin       
::回补::		
	停止遇敌()	
	common.checkHealth()
	移动(201, 19,"辛梅尔")		
	移动(191,99)
	goto 开始 
end

main()