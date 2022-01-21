▲自动去跑记忆 ::启动点::艾尔莎,公寓  光之路  辛梅尔  此为王冠脚本	
	
	
common=require("common")
	


function 取脚镣耐久()
	local items=物品信息()
	for i,v in pairs(items) do
		if(v.name == "很重的脚镣")then
			return v.durability
		end
	end
	return 20
end

::begin::	
	等待空闲()
	mapNum=取当前地图编号()
	mapName=取当前地图名()
	if(mapNum == 4201)then goto map4201 end 		--蒂娜村
	if(mapNum == 4230)then goto map4230 end 		--酒吧
	if(mapNum == 14018)then goto map14018 end 		--海贼指挥部
	if(mapNum == 14019)then goto map14019 end 		--海贼指挥部  地下5楼
	if(mapNum == 14020)then goto map14020 end 		--海贼指挥部  地下4楼
	if(mapNum == 14021)then goto map14021 end 		--海贼指挥部  地下3楼
	if(mapNum == 14022)then goto map14022 end 		--海贼指挥部  地下2楼
	if(mapNum == 14023)then goto map14023 end 		--海贼指挥部  
	if(mapNum == 14024)then goto map14024 end 		--海贼指挥部  	Boss战
	if(mapNum == 14036)then goto map14036 end 		--海贼指挥部  	学属性翻转
	if(mapNum == 14037)then goto map14037 end 		--海贼指挥部  	魔无
	if(mapNum == 14038)then goto map14038 end 		--海贼指挥部  	攻无
	等待(1000)
	goto begin
::map4201::
	移动(46,56,4230)		
	goto begin
::map4230::
	移动(22,11,4230)	
	对话选是(22,12)
	goto begin
::map14018::
	if(取所有物品数量("有鱼腥味的头巾")  > 0)then
		使用物品("有鱼腥味的头巾")
		goto begin
	end
	if(取所有物品数量("很重的脚镣") < 1)then	--包括装备在身上的
		移动(3,11)   
		对话选是(3,13)
	else
		if(取脚镣耐久() <= 4)then
			移动(3,11)   
			对话选是(3,13)
		end
	end
	goto begin
::map14019::
	使用物品("有鱼腥味的头巾")
	移动(2,4)
	移动(4,4)
	移动(5,5)
	移动(6,4)
	移动(7,5)
	转向(2)
	移动(8,6)
	移动(9,6)
	移动(10,5)
	移动(11,4)
	移动(12,5)
	移动(12,8,14020)
	goto begin
::map14020::
	移动(2,4)
	移动(3,5)
	等待到指定地图(14020,9,5)
	移动(11,5)
	等待到指定地图(14020,4,3)
	移动(5,3)
	转向坐标(4,3)
	移动(6,3)
	移动(12,5,14021)
	goto begin
::map14021::
	移动(3,2)
	等待到指定地图(14021,8,2)
	转向坐标(7,2)--转向(6)
	移动(7,3)
	等待到指定地图(14021,8,5)
	移动(9,6)
	移动(10,5)
	移动(10,4)
	等待到指定地图(14021,12,8)
	移动(12,11,14022)
	goto begin
::map14022::
	移动(2,2)
	转向坐标(4,2)
	等待到指定地图(14022,12,2)
	转向坐标(12,4)
	等待到指定地图(14022,7,6)
	转向坐标(5,4)
	等待到指定地图(14022,2,6)
	转向坐标(2,5)
	等待到指定地图(14022,12,11)
	移动(12,12,14023)
	goto begin
::map14023::
	移动(7,11)
	对话选是(8,11)
	--没有检测 匆忙写下的纸条
	goto begin
::map14024::
	移动(20,10)
	转向(2)	
	等待(2000)
	if(是否战斗中())then
		等待战斗结束()
	end
	goto begin
::map14036::
	日志("任务已完成，请手动学习技能",1)
	if(是否属性翻转)then
		移动(20,10)
		common.learnPlayerSkill(21,10)
	end
	移动(16,7)
	对话选是(16,6)		--貌似真是随机传送
	goto begin
::map14037::	--魔无  这个没测 但八九不离十
	日志("魔无地图，要学攻无，再来一遍",1)
	移动(16,7)
	common.learnPlayerSkill(16,6)	
	--大地的祈祷
	移动(21,9)
	common.learnPlayerSkill(22,9)
	--海洋的祈祷
	移动(21,12)
	common.learnPlayerSkill(22,12)
::map14038::	--攻无
	日志("攻无地图，要学魔无，再来一遍",1)
	移动(16,7)
	common.learnPlayerSkill(16,6)
	--火焰的祈祷
	移动(21,9)
	common.learnPlayerSkill(22,9)
	--云群的祈祷
	移动(21,12)
	common.learnPlayerSkill(22,12)
	
::map14039::	--海贼的秘道
	移动(6,21,"莎莲娜")
	
	