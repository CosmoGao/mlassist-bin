--定居艾尔莎岛 需要做过忍者任务，可以进入乌克兰小路

common=require("common")

::begin::
	mapNum=取当前地图编号()
	if(mapNum == 2200)then
		goto map2200
	elseif(mapNum == 21015)then	--忍者之家
		goto map21015
	elseif(mapNum == 21017)then	--忍者之家2楼
		goto map21017
	elseif(mapNum == 21023)then	--井的底部
		goto map21023
	elseif(mapNum == 21024)then	--通路
		goto map21024
	elseif(mapNum == 21025)then	--通路
		goto map21025		
	elseif(mapNum == 21016)then
		goto map21016
	elseif(mapNum == 21017)then
		goto map21017
	elseif(mapNum == 21018)then
		goto map21018
	elseif(mapNum == 21019)then
		goto map21019
	elseif(mapNum == 21020)then
		goto map21020
	end
	--goto begin
	common.outFaLan("s")
	等待到指定地图("芙蕾雅")
	移动(409, 294)
	对话选是(4)	
	等待到指定地图("小路")
	移动( 46, 23,"忍者的隐居地")
	移动( 19, 9,"忍者之家")	
	移动(13,20)	
	转向(0)
	等待服务器返回()
	对话选择(4, 0)	
	等待到指定地图("忍者之家2楼")		
	移动(37,19)	
	等待到指定地图("忍者之家")	
	goto begin	
::map2200::
	移动(90,84,21025)
	goto begin
::map21015::	
::map21016::	--忍者之家 
	if(目标是否可达(59,5))then
		移动(59,5)		
		对话选是(4)
	elseif(目标是否可达(62,13))then
		移动(62,13)		
		对话选是(2)	
	end
	goto begin
::map21017::	--忍者之家2楼
	if(目标是否可达(70,25))then
		移动(70,25)		
		对话选是(2)	
	end
	goto begin
::map21018::	--忍者之家  隐藏道路
	移动(8,10)
	goto begin
::map21019::	--忍者之家三楼
	移动(5,19)
	对话选是(6)
	goto begin
::map21020::	--忍者之家三楼
	移动(12,17)
	common.learnPlayerSkill(11,17)
	goto fini
::map21023::
	移动(19,12)
	goto begin
::map21024::
	移动(45,43)
	goto begin
::map21025::
	移动(22,26)
	goto begin

::fini::
	日志("学习暗杀完成",1)




