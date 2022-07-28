★半山6脚本，起点艾尔莎岛登入点，迷宫太长 还是组队打吧 

设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 开启高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
--设置("遇敌全跑", 1)			-- 开启遇敌全跑 

队长名称=取脚本界面数据("队长名称")
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","风依旧￠花依然")--风依旧￠花依然  乱￠逍遥
end

补血值=取脚本界面数据("人补血")
补魔值=取脚本界面数据("人补魔")
宠补血值=取脚本界面数据("宠补血")
宠补魔值=取脚本界面数据("宠补魔")

isTeamLeader=false		--是否队长
if(人物("名称") == 队长名称)then
	isTeamLeader=true
end
if(补血值==nil or 补血值==0)then
	补血值=用户输入框("多少血以下补血", "430")
else
	补血值=tonumber(补血值)
end
if(补魔值==nil or 补魔值==0)then
	补魔值 = 用户输入框("多少魔以下补魔", "200")
else
	补魔值=tonumber(补魔值)
end
if(宠补血值==nil or 宠补血值==0)then
	宠补血值 = 用户输入框( "宠多少血以下补血", "50")
else
	宠补血值=tonumber(宠补血值)
end
if(宠补魔值==nil or 宠补魔值==0)then
	宠补魔值=用户输入框( "宠多少魔以下补魔", "50")
else
	宠补魔值=tonumber(宠补魔值)
end
common=require("common")

遇敌总次数=0
function main()
::begin::
	停止遇敌()	
	等待空闲()	
	local 当前地图名 = 取当前地图名()
	local mapNum=取当前地图编号()
	if(当前地图名 ==  "冥界之森")then goto map57484	
	elseif(mapNum == 57485)then goto map57485
	end		
	if(取物品叠加数量("哭泣的灵魂") >= 100)then
		日志("哭泣的灵魂已达100个，脚本停止",1)
	end	
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth()
	common.checkCrystal()
	使用物品("饥饿的死神之卵")
	等待服务器返回()
	对话选择(1,0)
	等待(3000)
	goto begin
::map57485::
	自动寻路(22,19)
	对话选是(23,19)
	goto begin
::map57484::			--冥界之森
	自动寻路(19,34)			--没有组队
	开始遇敌()
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end	
	if(取物品叠加数量("哭泣的灵魂") >= 100)then goto  ting end	
	if(取当前地图名() ~= "冥界之森")then goto begin end	
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	-- else
		-- minHp=队友当前血最少值()
		-- if(minHp~= 88888 and minHp ~= 0 and  minHp < 200)then	
			-- 日志("队友血量过低"..minHp.."，回补！",1)				
			-- goto ting
		-- end
	end		
	-- if(取队伍人数() < 3)then			--队友掉线-人数太少 登出回城 
		-- 脚本日志("队友掉线，回补！")
		-- goto ting		
	-- end
	等待(2000)
	goto scriptstart  
::ting::
	停止遇敌()      
	等待空闲() 	
	喊话("共遇敌次数"..遇敌总次数,2,3,5)	
	回城()
	goto begin
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
	自动寻路(66, 97)
	common.makeTeam(5)
	goto toMaze
::toMaze::
	自动寻路(64,45,"通往山顶的路100M")
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
	自动寻路(80,56)
	自动寻路(80,57)
	自动寻路(80,56)
	自动寻路(80,57)
	自动寻路(80,56)
	离开队伍()
	对话选是(81,56)
::mountainInside::
	if(取当前地图名() ~= "圣山内部")then
		goto begin
	end
	自动寻路(16,11)
	common.makeTeam(5)
	自动寻路(19, 7,"通往地狱的道路地下1层")
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
	自动寻路(24,26)
	自动寻路(25,25)
	自动寻路(24,26)
	自动寻路(25,25)
	自动寻路(24,26)
	离开队伍()
	对话选是(24,25)
::mountainPeak::
	if(取当前地图名() ~= "圣山之巅")then
		goto begin
	end
	自动寻路(23,23)
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
	自动寻路(23,23)
	对话选是(23,22)
	等待(2000)
	if(取当前地图名() == "法兰城")then
		日志("任务结束，可以去半山练级了",1)
	else
		日志("任务完成，但没有传送至法兰城，请手动查看问题",1)
	end
	
end
main()