鹿皮刷狩猎技能

common=require("common")
hunting={}
设置("timer", 100)						-- 设置定时器，单位毫秒
设置("自动加血",0)
设置("高速延时",4)  
设置("高速战斗",1)  
设置("自动战斗",1)  
设置("遇敌全跑",1) 			
设置("自动叠",1, "海苔&40")		
是否卖=用户输入框("是否卖！","1")
狩猎材料名="海苔"
狩猎技能等级=4
function hunting.采集物品()
	while true do
		if(取包裹空格() < 1)then break end	-- 包满回城		
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "芙蕾雅")then break end	--地图切换 也返回
		工作("狩猎","",6500)	--技能名 物品名 延时时间
		等待工作返回(6500)
	end 
	扔叠加物(狩猎材料名,40)
	--回城()
end
function hunting.亚村卖和回复()
	if(mapName=="芙蕾雅")then			--加在这，主要是随时启动脚本原地复原
		移动(588, 51,"亚留特村")
		移动(56, 48,"村长的家")	
		移动(15, 8)	
		卖(2,"海苔")
		移动(6, 13,"亚留特村")
		移动(52,63)
		等待到指定地图("医院", 2,9)
		移动(10, 5)
		回复(2) 
		移动(2, 9)
		等待到指定地图("亚留特村", 52,63)	
		移动(59, 31,"芙蕾雅")
	end
end
function hunting.main()

	local skill=common.findSkillData("狩猎")
	if(skill == nil)then
		日志("提示：没有狩猎技能！",1)
		common.autoLearnSkill("狩猎")		
	end
	skill=common.findSkillData("狩猎")
	if(skill == nil)then
		日志("提示：没有狩猎技能！",1)
		common.autoLearnSkill("狩猎")
		return
	end
	if(skill.lv < 狩猎技能等级) then
		日志("提示：狩猎技能等级不足，至少要"..狩猎技能等级.."级技能！",1)
		return
	end
::begin::
	等待空闲()
	mapName=取当前地图名()
	if(mapName=="芙蕾雅")then			--加在这，主要是随时启动脚本原地复原		
		goto map100	
	end

	if(取包裹空格() < 1)then		-- 去压矿
		if(是否卖)then		
			扔叠加物(狩猎材料名,40)
			common.sellCastle(狩猎材料名)
		else
			cunYinHang() 
		end
	end			
	
	common.supplyCastle()
	common.checkHealth()
	common.toTeleRoom("亚留特村")
	移动(8, 3,"村长的家")
	移动(6, 13,"亚留特村")
	移动(59, 31,"芙蕾雅")
::map100::
	移动(617, 25)	
	hunting.采集物品()
	hunting.亚村卖和回复()	
	goto begin
	
	
::cunYinHang::
	common.gotoBankTalkNpc()
	银行("全存",狩猎材料名,40)	
	if(取包裹空格() < 2)then
		goto manle
	end
	goto begin 
::manle::	--可以在这加个仓库交易  懒得搞了
	日志("包裹满了，清理后执行",1)
	等待(12000)
	goto manle	
end
hunting.main()
return hunting

