
common=require("common")



::begin::
	mapName=取当前地图名()
	if(mapName == "追忆之路")then
		自动寻路(12,119)		
	end
	
::checkBag::
	if(取包裹空格() < 1)then
		common.gotoFalanBankTalkNpc()
		银行("全存")
	end
