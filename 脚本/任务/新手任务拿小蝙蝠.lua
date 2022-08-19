▲自动去跑记忆 ::启动点::艾尔莎,公寓  光之路  辛梅尔  此为王冠脚本	
	
	
common=require("common")
	
设置("高速延时", 3)	
设置("遇敌全跑", 1)	
	
local 领小蝙蝠还是使魔=用户下拉框("领小蝙蝠还是使魔",{"小蝙蝠","使魔"})

::begin::	
	等待空闲()
	mapNum=取当前地图编号()
	mapName=取当前地图名()
	if(mapName== "召唤之间")then goto BetweenCalls   
	elseif(mapName == "试验之间")then goto BetweenTests  
	elseif(mapName == "回廊")then goto map1531  
	elseif(mapName == "灵堂")then goto map11015
	elseif(mapName == "谒见之间")then goto map1511
	elseif(mapName == "里谢里雅堡 2楼")then goto map1521
	end	
	等待(1000)
	goto begin
::BetweenCalls::
	自动寻路(18,6)	
	对话选是(19,6)			
	goto begin
::map1511::
	if(取物品数量("赏赐状") > 0)then
		自动寻路(8,19)
	else
		自动寻路(7,4)
		对话选是(0)
	end
	goto begin
::map1521::
	if(领小蝙蝠还是使魔 == "小蝙蝠")then
		自动寻路(51,78)
		对话选是(4)
		local oldPetList=全部宠物信息()
		if(common.getTableSize(oldPetList) >= 1)then
			petInfo=宠物信息(0)			
			日志("领取小蝙蝠成功，档次:"..petInfo.grade,1)			
			return
		end
	else
		自动寻路(47,78)
		对话选是(4)
		local oldPetList=全部宠物信息()
		if(common.getTableSize(oldPetList) >= 1)then
			petInfo=宠物信息(0)			
			日志("领取使魔成功，档次:"..petInfo.grade,1)			
			return
		end
	end
	goto begin
::map1531::			--回廊	
	if(取物品数量("死者的戒指") > 0)then
		自动寻路(44,15)
	else
		自动寻路(23,19)
	end
	goto begin
::map11015::			--灵堂
	if(取物品数量("死者的戒指") > 0)then
		自动寻路(31,48)
	else
		自动寻路(53,3)
		对话选是(1)
	end
	goto begin
::BetweenTests::
	if(目标是否可达(84,51))then
		if(取物品数量("修练者之剑") < 1)then
			自动寻路(83,52)
			对话选是(84,51)
		else
			自动寻路(80,85)
		end
	end	
	if(目标是否可达(88,67))then
		if(取物品数量("修练者之服") < 1)then
			自动寻路(88,68)
			对话选是(87,67)
		else
			自动寻路(54,75)
		end
	end	
	if(目标是否可达(108,67))then
		if(取物品数量("死者之眼") > 0)then
			自动寻路(75,130)			
			goto begin
		end
		if(取物品数量("魔物封珠") < 1)then
			自动寻路(107,68)
			对话选是(108,67)
		else
			自动寻路(116,98)
			对话选是(117,98)
		end
		if(取物品数量("死者之眼") > 0)then
			自动寻路(75,130)		
			goto begin
		end
	end
	
	goto begin
