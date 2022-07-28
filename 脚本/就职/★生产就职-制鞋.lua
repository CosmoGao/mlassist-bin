

common=require("common")
设置("timer", 100)			-- 设置定时器，单位毫秒 内置100毫秒 不要太快
设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 遇敌全跑 
设置("自动加血", 0)			-- 遇敌全跑 关闭自动加血，脚本对话加血 
function StartWork()
	while true do
		if(取包裹空格() < 1)then break end	-- 包满回城
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "芙蕾雅")then break end	--地图切换 也返回
		if(取物品叠加数量("孟宗竹") >20)then break end
		工作("伐木体验","",6500)	--技能名 物品名 延时时间
		等待工作返回(6500)
	end 
	回城()
end
function StartFmWork()
	while true do
		if(取包裹空格() < 1)then break end	-- 包满回城
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "盖雷布伦森林")then break end	--地图切换 也返回
		if(取物品叠加数量("鹿皮") >20)then break end
		工作("狩猎","",6500)	--技能名 物品名 延时时间
		等待工作返回(6500)
	end 
	回城()
end
function StartWJWork()
	while true do
		if(取包裹空格() < 1)then break end	-- 包满回城
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "国营第24坑道 地下1楼")then break end	--地图切换 也返回
		if(取物品叠加数量("铜") >20)then break end
		工作("挖掘","",6500)	--技能名 物品名 延时时间
		等待工作返回(6500)
	end 
	回城()
end

--主流程
function main()	
::begin::		
	等待空闲()	
	if(取物品数量("防具工推荐信") > 0)then
		common.toTeleRoom("圣拉鲁卡村")
		自动寻路(7, 3,"村长的家")
		自动寻路(2, 9,"圣拉鲁卡村")
		自动寻路(32, 70,"装备品店")
		自动寻路(14, 4,"1楼小房间")
		自动寻路(9, 3,"地下工房")
		自动寻路(19, 24)
		转向坐标(19, 25)
		等待服务器返回()
		对话选择(0,1)
		等待服务器返回()
		对话选择(32,-1)
		等待服务器返回()
		对话选择(0,0)
		等待(2000)
		if(人物("职业") == "制鞋学徒")then
			自动寻路(23, 23)
			删除技能(23,24,"锻造体验")
			common.learnPlayerSkill(23,24)
			skill=common.findSkillData("制鞋")
			if(skill ~= nil)then
				common.autoLearnSkill("治疗")
			end			
		end		
		return
	end
	if(取物品数量("试炼衣") > 0)then
		common.gotoFaLanCity("e2")
		自动寻路(238,64,"冒险者旅馆")
		自动寻路(14, 7)
		转向(0)
		等待(2000)
		goto begin
	end	
	
	local skill=common.findSkillData("伐木体验")
	if(skill == nil)then
		if(取物品叠加数量("孟宗竹") <20)then
			日志("提示：没有伐木体验技能！",1)
			if(取当前地图名()=="职业介绍所")then
				goto EmploymentAgency
			end
			common.checkHealth()
			common.supplyCastle()
			common.sellCastle()		--默认卖
			common.outCastle("e")		
			自动寻路(195,50,"职业介绍所")
			goto EmploymentAgency
		end
	else
		if(取物品叠加数量("孟宗竹") <20)then
			goto 准备材料			
		end
	end		
	skill=common.findSkillData("挖掘")
	if(skill == nil)then
		日志("提示：没有挖掘技能！",1)
		common.gotoFaLanCity()	
		自动寻路(200,132,"基尔的家")
		自动寻路(9,3)
		删除技能(9,2,"伐木体验")
		对话选择(-1,0)	--不管有没有 先取消 在学
		转向坐标(9,2)
		common.learnPlayerSkill(9,2)
		--common.autoLearnSkill("挖掘")			
	end	
	skill=common.findSkillData("狩猎")
	if(skill == nil)then
		日志("提示：没有狩猎技能！",1)
		common.autoLearnSkill("狩猎")			
	end		
	if(取物品叠加数量("孟宗竹") <20)then goto 准备材料 end
	if(取物品叠加数量("鹿皮") <20)then goto 准备材料 end
	if(取物品叠加数量("铜") <20)then goto 准备材料 end
	mapName=取当前地图名()
	if(mapName=="职业介绍所")then
		goto EmploymentAgency
	end
	mapNum=取当前地图编号() 
	if(mapNum == "芙蕾雅")then	--芙蕾雅
		goto 准备材料			
	end
	if(mapNum == "盖雷布伦森林")then	--芙蕾雅
		goto 准备材料			
	end	
	if(mapNum == "国营第24坑道 地下1楼")then	--芙蕾雅
		goto 准备材料			
	end	
	goto 准备材料

::EmploymentAgency::
	skillName="锻造体验"
	skill = common.findSkillData(skillName)
	if(skill ~= nil)then
		日志("已存在技能【"..skillName.."】")		
	else
		自动寻路(9,6)
		common.learnPlayerSkill(9,5)
	end		
	自动寻路(8,10)
	删除技能(8,11,"气功弹")
	--对话选择(-1,0)	--不管有没有 先取消 在学
	删除技能(8,11,"石化魔法")
	删除技能(8,11,"强力补血魔法")
	--对话选择(-1,0)	--不管有没有 先取消 在学
	common.learnPlayerSkill(8,11)
	goto begin
::准备材料::
	if(取物品叠加数量("孟宗竹") <20)then 
		if(取当前地图名()~="芙蕾雅")then
			common.outFaLan("e")
		end
		common.outFaLan("e")
		自动寻路(484, 198)
		设置("移动速度",走路还原值)
		StartWork()		
		goto begin	
	end
	if(取物品叠加数量("鹿皮") <20)then 
		if(取当前地图名()~="盖雷布伦森林")then
			回城()
			自动寻路(130, 50,"盖雷布伦森林")
		end
		自动寻路(175,182)     
		扔("魔石")
		扔("地的水晶碎片")
		扔("水的水晶碎片")
		扔("火的水晶碎片")
		扔("风的水晶碎片")
		StartFmWork()		
		goto begin
	end
	if(取物品叠加数量("铜") <20)then 
		if(取当前地图名()~="国营第24坑道 地下1楼")then
			common.outFaLan("w")
			自动寻路(351, 145)			
		end
		扔("魔石")
		扔("地的水晶碎片")
		扔("水的水晶碎片")
		扔("火的水晶碎片")
		扔("风的水晶碎片")
		StartWJWork()		
		goto begin
	end
	common.checkHealth()
	common.supplyCastle()
	合成("试炼衣")
	goto begin
end
main()