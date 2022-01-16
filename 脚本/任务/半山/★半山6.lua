★半山6脚本，起点艾尔莎岛登入点，迷宫太长 还是组队打吧 

设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 开启高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
--设置("遇敌全跑", 1)			-- 开启遇敌全跑 

队长名称=取脚本界面数据("队长名称")
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","风依旧￠花依然")--风依旧￠花依然  乱￠逍遥
end

isTeamLeader=false		--是否队长
if(人物("名称") == 队长名称)then
	isTeamLeader=true
end

common=require("common")


function main()
::begin::
	停止遇敌()	
	等待空闲()	
	local 当前地图名 = 取当前地图名()
	if (string.find(当前地图名,"通往山顶的路")~= nil )then leaderAction()
	elseif (string.find(当前地图名,"通往地狱的道路地下")~= nil )then leaderAction()
	elseif (当前地图名 =="艾尔莎岛" )then goto toIsland
	elseif(当前地图名 ==  "里谢里雅堡")then goto toIsland 
	elseif(当前地图名 ==  "法兰城")then goto toIsland 	
	elseif(当前地图名 ==  "小岛")then goto island
	elseif(当前地图名 ==  "图书室")then goto library	
	end		
	等待(3000)
	goto begin
::toIsland::
	if(取物品数量("阿斯提亚锥形水晶") > 0)then
		使用物品("阿斯提亚锥形水晶")
		等待(2000)
		goto island
	end
	common.checkHealth()
	common.supplyCastle()
	common.toCastle("f2")
	移动(0,74,"图书室")
	goto library
::library::					--图书室
	扔("锄头")
	移动(27,16)
	对话选是(27,15)
	goto begin
::island::
	if(取当前地图名() ~= "小岛")then
		goto begin
	end
	if(isTeamLeader)then
		leaderAction()		
	else
		teammateAction()
	end	
end

--队长
function leaderAction()
::begin::	
	等待空闲()	
	local 当前地图名 = 取当前地图名()
	if (string.find(当前地图名,"通往山顶的路")~= nil )then goto crossMaze
	elseif (string.find(当前地图名,"通往地狱的道路地下")~= nil )then goto corssHellMaze
	elseif(当前地图名 ==  "小岛")then goto island
	elseif(当前地图名 ==  "半山腰")then goto mountainOfHalf
	elseif(当前地图名 ==  "圣山内部")then goto mountainInside
	elseif(当前地图名 ==  "地狱入口")then goto hellEntrance	
	elseif(当前地图名 ==  "圣山之巅")then goto mountainPeak
	end		
	等待(3000)
	goto begin
::island::
	if(取当前地图名() ~= "小岛")then
		goto begin
	end
	移动(66, 97)
	common.makeTeam(5)
	goto toMaze
::toMaze::
	移动(64,45,"通往山顶的路100M")
	goto crossMaze
::crossMaze::
	自动穿越迷宫("半山腰")
	if(取当前地图名()=="半山腰")then
		goto mountainOfHalf
	end
	等待(1000)
	goto crossMaze
::mountainOfHalf::
	if(取当前地图名() ~= "半山腰")then
		goto begin
	end
	移动(80,56)
	移动(80,57)
	移动(80,56)
	移动(80,57)
	移动(80,56)
	离开队伍()
	对话选是(81,56)
::mountainInside::
	if(取当前地图名() ~= "圣山内部")then
		goto begin
	end
	移动(16,11)
	common.makeTeam(5)
	移动(19, 7,"通往地狱的道路地下1层")
::corssHellMaze::			--地狱
	自动穿越迷宫("地狱入口")
	if(取当前地图名()=="地狱入口")then
		goto hellEntrance
	end
	等待(1000)
	goto corssHellMaze
::hellEntrance::		--地狱入口
	if(取当前地图名()~="地狱入口")then
		goto begin
	end
	移动(24,26)
	移动(25,25)
	移动(24,26)
	移动(25,25)
	移动(24,26)
	离开队伍()
	对话选是(24,25)
::mountainPeak::
	if(取当前地图名() ~= "圣山之巅")then
		goto begin
	end
	移动(23,23)
	对话选是(23,22)
	等待(2000)
	if(取当前地图名() == "法兰城")then
		日志("任务结束，可以去半山练级了",1)
	else
		日志("任务完成，但没有传送至法兰城，请手动查看问题",1)
	end
end

--队员
function teammateAction()	
::begin::	
	等待空闲()	
	local 当前地图名 = 取当前地图名()
	if(当前地图名 ==  "小岛")then goto island
	elseif(当前地图名 ==  "半山腰")then goto mountainOfHalf
	elseif(当前地图名 ==  "圣山内部")then goto mountainInside
	elseif(当前地图名 ==  "地狱入口")then goto hellEntrance	
	elseif(当前地图名 ==  "圣山之巅")then goto mountainPeak
	end		
	等待(3000)
	goto begin
::island::
	if(取当前地图名() ~= "小岛")then
		goto begin
	end	
	if(取队伍人数() > 1)then
		goto begin
	end
	common.joinTeam(队长名称)
	goto begin
::mountainOfHalf::
	if(是否目标附近(81,56))then
		对话选是(81,56)
	end
	goto begin
::mountainInside::
	if(取当前地图名() ~= "圣山内部")then
		goto begin
	end	
	if(取队伍人数() > 1)then
		goto begin
	end
	common.joinTeam(队长名称)
	goto begin
::hellEntrance::
	if(是否目标附近(24, 25))then
		对话选是(24, 25)
	end	
	goto begin
::mountainPeak::
	if(取当前地图名() ~= "圣山之巅")then
		goto begin
	end
	移动(23,23)
	对话选是(23,22)
	等待(2000)
	if(取当前地图名() == "法兰城")then
		日志("任务结束，可以去半山练级了",1)
	else
		日志("任务完成，但没有传送至法兰城，请手动查看问题",1)
	end
	
end
main()