★起始点：艾夏岛-法兰城任一传送石

common=require("common")

设置("timer", 100)			-- 设置定时器，单位毫秒 内置100毫秒 不要太快
设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 遇敌全跑 
设置("自动加血", 0)			-- 遇敌全跑 关闭自动加血，脚本对话加血 
设置("自动扔",1,"卡片？")
设置("自动扔",1,"魔石")
设置("自动扔",1,"盐")
走路加速值=110	
走路还原值=100	
采集技能等级=1
材料名="鹿皮"
采集技能名称="狩猎"

function hunt1()
	材料名="鹿皮"
	采集技能等级=1
::begin::
	等待空闲()	
	mapName=取当前地图名()
	if(mapName=="盖雷布伦森林")then			--加在这，主要是随时启动脚本原地复原
		goto work
	end
	common.supplyCastle()
	common.checkHealth()	
	if(取包裹空格() < 1)then		
		扔叠加物(材料名,40)
		common.sellCastlePile(材料名,20,40)			
	end		
	if(common.playerSkillLv("狩猎") >= 4)then
		日志("达到设定技能等级，返回",1)
		return
	end
	回城()		
	移动(130, 50,"盖雷布伦森林")		
	goto work	
::work::
	if(目标是否可达(175,182))then
		移动(175,182)
	else
		回城()
		goto begin
	end	
	while true do
		if(取包裹空格() < 1)then break end	-- 包满回城		
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "盖雷布伦森林")then break end	--地图切换 也返回
		工作("狩猎","",5000)	--技能名 物品名 延时时间
		等待工作返回(5000)
	end 
	扔叠加物(材料名,40)
	回城()
	goto begin	
::End::
	return
end

--黄月木
function hunt4()
	材料名="海苔"
	采集技能等级=4
	if(common.playerSkillLv("狩猎") < 采集技能等级)then
		日志("技能等级不足，返回",1)
		return
	end
::begin::		
	等待空闲()	
	if(common.playerSkillLv("狩猎") == 4)then
		if(人物("职称") == "见习猎人" and 人物("声望等级") >= 3)then
			日志("当前技能等级为4，尚未1转，去做生产系1转任务",1)
			执行脚本("./脚本/生产/生产系1转任务.lua")		
			执行脚本("./脚本/★转正/★生产提升阶级-猎人.lua")				
		end		
	elseif(common.playerSkillLv("狩猎") == 6)then
		if(人物("职称") == "猎人" and 人物("声望等级") >= 6)then
			设置("脚本坐标静止重启",0,0)
			设置("脚本坐标静止登出",0,0)
			日志("当前技能等级为6，尚未2转，去做生产系2转任务",1)
			执行脚本("./脚本/生产/★生产二转跑路版.lua")		
			执行脚本("./脚本/★转正/★生产提升阶级-猎人.lua")	
			设置("脚本坐标静止重启",1,0)
			设置("脚本坐标静止登出",1,0)			
		end
		--8级得配合 暂时不加
	end
	mapNum=取当前地图编号() 
	if(mapNum == 100)then	--芙蕾雅
		goto map100			
	end
	设置("移动速度",走路加速值)
	if(取包裹空格() < 1)then		
		扔叠加物(材料名,40)
		common.sellCastlePile(材料名,20,40)		
	end			
	common.supplyCastle()
	common.checkHealth()
	common.toTeleRoom("亚留特村")
	移动(8, 3,"村长的家")
	移动(6, 13,"亚留特村")
	移动(59, 31,"芙蕾雅")	
	goto begin   
::map100::	
	if(目标是否可达(617, 25))then
		移动(617, 25)	
	else
		回城()
		goto begin
	end
	设置("移动速度",走路还原值)
	while true do
		if(取包裹空格() < 1)then break end	-- 包满回城
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "芙蕾雅")then break end	--地图切换 也返回
		工作("狩猎","",5000)	--技能名 物品名 延时时间
		等待工作返回(5000)
	end 
	移动(588, 51,"亚留特村")
	移动(56, 48,"村长的家")	
	移动(15, 8)	
	common.sellPileDir(2,材料名)
	移动(6, 13,"亚留特村")
	移动(52,63)
	等待到指定地图("医院", 2,9)
	移动(10, 5)
	回复(2) 
	移动(2, 9)
	等待到指定地图("亚留特村", 52,63)	
	移动(59, 31,"芙蕾雅")
	goto begin	
::End::
	return
end
--主流程
function main()
	日志("欢迎使用星落全自动刷狩猎技能脚本",1)
	日志("当前职业："..人物("职业"),1)
	日志("当前职称："..人物("职称"),1)
	if(人物("职业") ~= "猎人")then
		日志("职业不是猎人",1)
		return	
	end
	扔("竹子")
	扔("孟宗竹")
	扔("铜")
	local skill=common.findSkillData("狩猎")
	if(skill == nil)then
		日志("提示：没有狩猎技能，去学习狩猎技能！",1)
		common.autoLearnSkill("狩猎")		
	end
	skill=common.findSkillData("狩猎")
	if(skill == nil)then
		日志("提示：学习狩猎技能失败，脚本退出！",1)		
		return
	end	
::begin::
	等待空闲()
	local skillLV = common.playerSkillLv("狩猎")
	if(skillLV < 4)then
		日志("当前技能等级为"..skillLV.."，去刷鹿皮",1)
		hunt1()	
	else
		日志("当前技能等级为"..skillLV.."，去刷海苔",1)
		hunt4()				
	end
	goto begin
	
end
main()
	
	

