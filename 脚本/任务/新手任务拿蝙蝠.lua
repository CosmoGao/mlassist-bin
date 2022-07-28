▲自动去跑记忆 ::启动点::艾尔莎,公寓  光之路  辛梅尔  此为王冠脚本	
	
	
common=require("common")
	
设置("高速延时", 3)	
	

::begin::	
	等待空闲()
	mapNum=取当前地图编号()
	mapName=取当前地图名()
	if(mapName== "召唤之间")then goto BetweenCalls   
	elseif(mapName == "试验之间")then goto BetweenTests  end	
	等待(1000)
	goto begin
::BetweenCalls::
	自动寻路(18,6)
	if(取物品数量("死者之眼") > 0)then
		对话选是(19,6)		
	else
		对话选否(19,6)
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
