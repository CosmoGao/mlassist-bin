


common=require("common")
队伍人数=取脚本界面数据("队伍人数")
if(队伍人数==nil or 队伍人数==0)then
	队伍人数 = 用户输入框("练级队伍人数，不足则固定点等待！",5)
end
function 营地任务()
	
::begin::	
	当前地图名 = 取当前地图名()
	if(string.find(当前地图名,"废墟地下") ~= nil)then
		goto chuanYueMiGong
	elseif(当前地图名 =="遗迹" ) then
		goto boss
	end
	if(取物品数量("怪物碎片") > 0) then
		goto suipian
	end
	if (取物品数量("团长的证明") > 0 ) then
		goto battleBoss	
	end
	if(取物品数量("信") > 0) then
		common.toCastle("f3")
		对话坐标选是(5,3)			
	end
	if(取物品数量("信笺") > 0)then		
		goto naZhengMing
	end
	--队长拿信
	-- if(取物品数量("承认之戒") > 0)then
		-- 扔("承认之戒")
		-- 等待(3000)
	-- end
	if(取物品数量("信笺") < 1 and 取物品数量("信") < 1 and 取物品数量("承认之戒") < 1)then
		common.checkHealth()
		common.supplyCastle()
		common.sellCastle()		--默认卖
		common.toCastle("f3")		
		对话坐标选是(5,3)		
	end		
	goto begin	

::naZhengMing::
	common.toCastle()	--默认城堡卖石附近
	自动寻路(41,84)
	while (队伍("人数") < 队伍人数) do --等待组队完成
		等待(5000)
	end
	自动寻路(41,98)	
	自动寻路(153,241,"芙蕾雅")
	自动寻路(513,282,"曙光骑士团营地")
	自动寻路(52,68,"曙光营地指挥部")
	if(目标是否可达(69,70))then
		自动寻路(69,70)
	end	
	if(目标是否可达(95,7))then
		自动寻路(95,6)
		对话选是(95,7)
	end		
	goto battleBoss

::battleBoss::		
	if(取物品数量("怪物碎片") > 0) then
		goto suipian
	end
	if(取物品数量("信") > 0) then
		common.toCastle("f3")
		对话坐标选是(5,3)			
	end
	if(队伍("人数") < 队伍人数) then --等待组队完成
		common.toCastle()	--默认城堡卖石附近
		自动寻路(41,84)
		common.makeTeam(队伍人数)	
		自动寻路(41,98)	
		自动寻路(153,241,"芙蕾雅")
		自动寻路(513,282,"曙光骑士团营地")
	end
	当前地图名 = 取当前地图名()
	if (当前地图名 =="曙光营地指挥部" )then 
		自动寻路(85,3)
		--自动寻路(69,70)
		自动寻路(53,79,"曙光骑士团营地")
		自动寻路(55,47,"辛希亚探索指挥部")
		goto quMiGong
	elseif(当前地图名 =="曙光骑士团营地" ) then
		自动寻路(55,47,"辛希亚探索指挥部")
		goto quMiGong
	elseif(当前地图名 =="遗迹" ) then
		goto boss
	elseif(当前地图名 =="研究室" ) then
		goto naSuiPian
	elseif(string.find(当前地图名,"废墟地下") ~= nil)then
		goto chuanYueMiGong
	end
	goto begin
::quMiGong::	
	if(是否目标附近(44,22)) then  --如果穿越中 被传出来 
		移动到目标附近(44,22)
		自动寻路(44,22,"废墟地下1层")	
		goto chuanYueMiGong
	end
	等待空闲()
	mapIndex = 取当前地图编号()
	if (mapIndex==27014 )then	
		if(目标是否可达(95,9) == false) then --第一个
			自动寻路(7,4)		
		else
			自动寻路(95,9)			
		end
		等待(1000)
	elseif (mapIndex==27101 )then	
		对话坐标选是(40,22)		
		等待(2000)
		自动寻路(44,22,"废墟地下1层")	
		goto chuanYueMiGong
	end	
	goto quMiGong		
	-- 自动寻路(55,47,"辛希亚探索指挥部")
	-- 自动寻路(7,4)
	-- 自动寻路(91,6)
	-- 自动寻路(95,9,"27101")
	-- 对话坐标选是(40,22)		
	-- 自动寻路(44,22,"废墟地下1层")		
::boss::
	设置("遇敌全跑",0)
	自动寻路(15,14)
	对话选是(6)
	等待(2000)
	等待空闲()
	goto battleBoss
::naSuiPian::
	自动寻路(13,15)
	自动寻路(15,15)
	自动寻路(13,15)
	对话选是(14,14)
	goto battleBoss
::chuanYueMiGong::
	if(队伍人数 == 1)then
		设置("遇敌全跑",1)
	end
	自动穿越迷宫()
	goto battleBoss
::suipian::
	if(取物品数量("怪物碎片") > 0) then
		--回城()
		等待(2000)
		common.gotoFaLanCity()	
		自动寻路(153,241,"芙蕾雅")
		自动寻路(513,282,"曙光骑士团营地")
		自动寻路(52,68,"曙光营地指挥部")
		while true do
			if(取物品数量("信") > 0) then
				break
			end
			if(目标是否可达(69,70))then
				自动寻路(69,70)
			end	
			if(目标是否可达(95,7))then
				自动寻路(95,6)
				对话选是(95,7)
			end			
		end			
	end
	goto battleBoss
end
营地任务()