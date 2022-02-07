★半山5脚本，起点艾尔莎岛登入点，根据提示执行脚本

设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 开启高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 开启遇敌全跑 

common=require("common")

::begin::
	停止遇敌()	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	--营地任务()
	if (string.find(当前地图名,"通往山顶的路")~= nil )then goto crossMaze
	elseif (当前地图名 =="艾尔莎岛" )then goto toIsland
	elseif (当前地图名 =="半山腰" )then goto crossMaze
	elseif(当前地图名 ==  "里谢里雅堡")then goto toIsland 
	elseif(当前地图名 ==  "法兰城")then goto toIsland 	
	elseif(当前地图名 ==  "小岛")then goto island
	elseif(当前地图名 ==  "图书室")then goto library
	elseif(当前地图名 ==  "圣鸟之巢")then goto birdnest
	elseif(当前地图名 ==  "圣山之巅")then goto mountainPeak
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
	common.checkHealth()
	common.supplyCastle()	
	common.toCastle("f2")
	移动(0,74,"图书室")
	goto library
::library::					--图书室
	if(取物品数量("阿斯提亚锥形水晶") > 0)then
		使用物品("阿斯提亚锥形水晶")
		等待(2000)
		goto island
	end
	移动(27,16)
	对话选是(27,15)
	goto begin
::island::
	if(取当前地图名() ~= "小岛")then
		goto begin
	end
	移动(64,45,"通往山顶的路100M")
	goto crossMaze
::crossMaze::
	自动穿越迷宫("圣鸟之巢")
	if(取当前地图名()=="圣鸟之巢")then
		goto birdnest
	elseif(取当前地图名()=="半山腰")then
		移动(78,52)
	end
	等待(1000)
	goto crossMaze
::birdnest::
	if(取当前地图名() ~= "圣鸟之巢")then
		goto begin
	end
	移动(14,12)
	对话选是(14,11)
::mountainPeak::
	if(取当前地图名() ~= "圣山之巅")then
		goto begin
	end
	移动(23,23)
	对话选是(23,22)
	if(取当前地图名() == "法兰城")then
		日志("任务结束，可以去半山练级了",1)
	end
	日志("任务完成，但没有传送至法兰城，请手动查看问题",1)