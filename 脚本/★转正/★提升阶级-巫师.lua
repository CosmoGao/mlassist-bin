★定居艾尔莎岛，。

common=require("common")


设置("遇敌全跑",1)

common.supplyCastle()
common.sellCastle()		--默认卖
common.checkHealth(医生名称)


function main()
::begin::
	等待空闲()
	mapName=取当前地图名()
	mapNum=取当前地图编号()	
	if(mapName=="奇利村的传送点") then
		自动寻路(7, 6)		
	elseif(mapNum==300)then		--索奇亚	
		goto map300
	elseif(mapNum==3299)then	--村长的家	
		自动寻路(7, 6)	
	elseif(mapNum==3214)then	--村长的家	
		自动寻路(7, 1)	
	elseif(mapNum==3212)then	--村长的家	
		自动寻路(1, 8)		
	elseif(mapNum==3200)then	--奇利村	
		goto map3200
	elseif(mapNum==3350)then	--解任务
		goto map3350
	elseif(mapNum==3352)then	--冯奴的家 就职
		goto map3352
	else
		common.toTeleRoom("奇利村")		
	end	
		
	等待(2000)
	goto begin
::map3200::
	自动寻路(59, 45,"索奇亚")	
	goto begin
::map300::			--索奇亚
	自动寻路(349,261,"冯奴的家")
	goto begin
::map3350::
	自动寻路(14,2)	
	对话选是(14,1)
	goto begin
::map3352::
	自动寻路(9,10)
	转向(0)
	等待服务器返回()
	对话选择(0,2)
	等待服务器返回()
	对话选择(0,0)	
	等待(2000)

end
main()