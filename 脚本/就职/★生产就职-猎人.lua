★定居艾尔莎岛，。

common=require("common")

设置("遇敌全跑",1)
设置("自动扔",0,"传说的鹿皮")

function 到伊尔村()
	common.toTeleRoom("伊尔村")
	等待到指定地图("伊尔村的传送点")
	自动寻路(12, 17,"村长的家")
	自动寻路(6, 13,"伊尔村")
end
function main()
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)   
::begin::	
	if(取物品数量("传说的鹿皮") > 0)then 	--只能是在芙蕾雅 不然登出消失
		--到伊尔村()
		自动寻路(681, 343, '伊尔村')
		自动寻路(48,77)
		对话选是(49,77)     
		自动寻路(35, 25, '装备店')
		自动寻路(13, 17)
		转向坐标(13,16)	
		等待服务器返回()
		对话选择(0,0)
		等待服务器返回()
		对话选择(32,-1)
		等待服务器返回()
		对话选择(0,0)
		等待(2000)
		if(人物("职业") == "见习猎人")then
			日志("就职猎人成功！")
		else		
			日志("就职猎人失败，请手动查看原因")				
		end
		return
	end
	if(common.findSkillData("狩猎体验") == nil)then		
		到伊尔村()
		自动寻路(48,75)
		common.learnPlayerSkill(48,76)	
		自动寻路(45, 31, '芙蕾雅')
		自动寻路(649, 228, '芙蕾雅')
	else
		if(取当前地图名() ~= "芙蕾雅")then
			common.outFaLan("e")		
		end
		自动寻路(649, 228, '芙蕾雅')
		while true do
			if(取包裹空格() < 1)then break end	-- 包满回城
			if(人物("魔") <  1)then 
				common.supplyCastle() 
				break 
			end	-- 魔无回城
			if(取物品数量("传说的鹿皮") > 0)then break end	-- 魔无回城
			if(取当前地图名() ~= "芙蕾雅")then break end	--地图切换 也返回
			工作("狩猎体验","",6500)	--技能名 物品名 延时时间
			等待工作返回(6500)
		end 		
	end	
	goto begin
end

main()