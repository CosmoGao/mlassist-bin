--定居艾尔莎岛


	if(取当前地图名() =="旅馆")then
		goto map1183
	end
::begin::
	回城()
	等待(1000)

	等待到指定地图("艾尔莎岛")
	对话选是(1)	

	等待到指定地图("里谢里雅堡")
	自动寻路(41,14)
	等待到指定地图("法兰城")
	自动寻路(106,38)
::map1183::
	等待到指定地图("旅馆")	
	自动寻路(23,12)
	
	--转向(0)
	--地水火风 0-7
	common.learnPetSkillDir(0,2,0,4)
	等待(1500)
	common.learnPetSkillDir(0,3,0,5)
	等待(1500)
	common.learnPetSkillDir(0,4,0,6)
	等待(1500)
	common.learnPetSkillDir(0,5,0,7)
	等待(1500)
	common.learnPetSkillDir(0,6,0,8)
	等待(1500)
	common.learnPetSkillDir(0,7,0,9)
	等待(1000)


