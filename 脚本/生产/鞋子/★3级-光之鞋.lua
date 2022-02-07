造光之鞋卖店，要求：会狩猎伐木，设好自动战斗，启动脚本时物品栏全空，自动扔东西（包括魔石/各种卡片/各种碎片），自动治疗!以及自动叠加 鹿皮&40 麻布&20 木棉布&20 毛毡&20

common=require("common")
makeShoe={}
设置("timer", 100)						-- 设置定时器，单位毫秒
设置("自动加血",0)
设置("高速延时",4)  
设置("高速战斗",1)  
设置("自动战斗",1)  
设置("遇敌全跑",1) 			
设置("自动叠",1, "麻布&20")			
设置("自动叠",1, "木棉布&20")		
设置("自动叠",1, "毛毡&20")		
设置("自动叠",1, "鹿皮&40")		
鹿皮数量=240
麻布数量=60
木棉布数量=48
毛毡数量=48
function makeShoe.采集鹿皮()
	while true do
		if(取包裹空格() < 1)then break end	-- 包满回城
		if(取物品叠加数量('鹿皮')>= 鹿皮数量)then break end	
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "盖雷布伦森林")then break end	--地图切换 也返回
		工作("狩猎","",6500)	--技能名 物品名 延时时间
		等待工作返回(6500)
	end 
	扔叠加物("鹿皮",40)
	回城()
end

function makeShoe.main()

	local zxlv = common.playerSkillLv("制鞋")
	if(zxlv < 3)then
		日志("3级光之鞋，需要3级制鞋技能，脚本退出",1)
		return
	end
::begin::
	等待空闲()
	mapName=取当前地图名()
	if(mapName=="盖雷布伦森林")then			--加在这，主要是随时启动脚本原地复原
		makeShoe.采集鹿皮()
		goto begin	
	end
	if(取物品数量("光之鞋") >= 1)then		--得去老头那卖
		--common.outCastle("s")		--默认卖
		common.toCastle()
		移动(40, 98,"法兰城")	
		移动(150, 123)
		卖(0,"光之鞋")		
		goto begin
	end
	if(取物品叠加数量('鹿皮')< 鹿皮数量)then					
		回城()		
		移动(130, 50,"盖雷布伦森林")	
		移动(175,182)
		makeShoe.采集鹿皮()
		goto begin
	end
	if(取物品叠加数量('麻布')< 麻布数量)then				
		if(取当前地图名() ~= "流行商店")then
			common.gotoFaLanCity()
			移动(117, 112,"流行商店")
		end
		移动(8,7)
		转向(0)
		等待服务器返回()		
		对话选择(0, 0)
		等待服务器返回()		
		买(0,麻布数量-取物品叠加数量('麻布'))
		goto begin
	end	
	if(取物品叠加数量('木棉布')< 木棉布数量)then				
		if(取当前地图名() ~= "流行商店")then
			common.gotoFaLanCity()
			移动(117, 112,"流行商店")
		end
		移动(8,7)
		转向(0)
		等待服务器返回()		
		对话选择(0, 0)
		等待服务器返回()		
		买(1,木棉布数量-取物品叠加数量('木棉布'))
		goto begin
	end
	if(取物品叠加数量('毛毡')< 毛毡数量)then				
		if(取当前地图名() ~= "流行商店")then
			common.gotoFaLanCity()
			移动(117, 112,"流行商店")
		end
		移动(8,7)
		转向(0)
		等待服务器返回()		
		对话选择(0, 0)
		等待服务器返回()		
		买(2,毛毡数量-取物品叠加数量('毛毡'))
		goto begin
	end	
	common.supplyCastle()
	common.checkHealth()	
	goto work
::work::
	合成("光之鞋")	
	if(取包裹空格() < 1) then goto  pause end			
	if(取物品叠加数量("鹿皮") < 20 or 取物品叠加数量("麻布") < 5 or 取物品叠加数量("木棉布") < 4 or 取物品叠加数量("毛毡") < 4 )then 
		common.supplyCastle()	--正好在旁边 补完再走
		goto begin 
	end			
	if(人物("魔") <  50) then 
		common.supplyCastle() 		
	end
	goto work 
::pause::	
	叠("麻布", 20)
	叠("木棉布", 20)	
	叠("毛毡", 20)	
	叠("鹿皮", 40)	
	goto work 
end
makeShoe.main()
return makeShoe

