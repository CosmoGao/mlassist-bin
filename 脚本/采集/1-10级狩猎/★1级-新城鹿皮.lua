鹿皮刷狩猎技能

common=require("common")
hunting={}
设置("timer", 100)						-- 设置定时器，单位毫秒
设置("自动加血",0)
设置("高速延时",4)  
设置("高速战斗",1)  
设置("自动战斗",1)  
设置("遇敌全跑",1) 			
设置("自动叠",1, "鹿皮&40")		
是否卖=用户输入框("是否卖！","1")
狩猎材料名="鹿皮"
狩猎技能等级=1
function hunting.采集鹿皮()
	while true do
		if(取包裹空格() < 1)then break end	-- 包满回城		
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "盖雷布伦森林")then break end	--地图切换 也返回
		工作("狩猎","",6500)	--技能名 物品名 延时时间
		等待工作返回(6500)
	end 
	扔叠加物(狩猎材料名,40)
	回城()
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
	if(mapName=="盖雷布伦森林")then			--加在这，主要是随时启动脚本原地复原
		hunting.采集鹿皮()
		goto begin	
	end
	common.supplyCastle()
	common.checkHealth()	
	if(取包裹空格() < 1)then		-- 去压矿
		if(是否卖)then		
			扔叠加物(狩猎材料名,40)
			common.sellCastle(狩猎材料名)
		else
			cunYinHang() 
		end
	end			
	
	回城()		
	移动(130, 50,"盖雷布伦森林")	
	移动(175,182)
	hunting.采集鹿皮()
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

