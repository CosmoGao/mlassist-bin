造光之鞋卖店，要求：会狩猎伐木，设好自动战斗，启动脚本时物品栏全空，自动扔东西（包括魔石/各种卡片/各种碎片），自动治疗!以及自动叠加 鹿皮&40 麻布&20 木棉布&20 毛毡&20 鹿皮不要捡多了，会卡住

common=require("common")
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

设置("自动扔",1,"卡片？")
设置("自动扔",1,"魔石")
设置("自动扔",1,"盐")
鹿皮数量=240
麻布数量=60
木棉布数量=48
毛毡数量=48
合成鞋名称="运动鞋"

鹿皮需要数量=20
麻布需要数量=5
木棉布需要数量=4
毛毡需要数量=4

function 采集鹿皮()
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
function 去卖鞋(name)
	if(name == nil)then return end
	common.toCastle()
	移动(40, 98,"法兰城")	
	移动(150, 123)
	卖(0,name)		
end
function makeShoe(retLv)	
	local zxlv = common.playerSkillLv("制鞋")
	if(zxlv < 3)then
		鹿皮数量=360
		麻布数量=72
		木棉布数量=0
		毛毡数量=0
		鹿皮需要数量=20
		麻布需要数量=4
		木棉布需要数量=0
		毛毡需要数量=0
		合成鞋名称="运动鞋"
	elseif(zxlv >= 3)then
		鹿皮数量=240
		麻布数量=60
		木棉布数量=48
		毛毡数量=48
		鹿皮需要数量=20
		麻布需要数量=5
		木棉布需要数量=4
		毛毡需要数量=4
		合成鞋名称="光之鞋"
	end
	-- if(取物品叠加数量('鹿皮')> 鹿皮数量)then
		-- 扔("麻布")
	-- end
	if(取物品叠加数量('麻布')> 麻布数量)then
		扔("麻布")
	end
	if(取物品叠加数量('木棉布')> 木棉布数量)then
		扔("木棉布")
	end
	if(取物品叠加数量('毛毡')> 毛毡数量)then
		扔("毛毡")
	end
	if(取物品数量("光之鞋") >= 1)then		--得去老头那卖
		去卖鞋("光之鞋")		
		goto begin
	end
	if(取物品数量("运动鞋") >= 1)then		--得去老头那卖
		去卖鞋("运动鞋")		
		goto begin
	end
::begin::
	等待空闲()	
	mapName=取当前地图名()
	if(mapName=="盖雷布伦森林")then			--加在这，主要是随时启动脚本原地复原
		采集鹿皮()
		goto begin	
	end
	if(取物品数量(合成鞋名称) >= 1)then		--得去老头那卖
		去卖鞋(合成鞋名称)		
		goto begin
	end
	if(retLv ~= nil  and common.playerSkillLv("制鞋") >= retLv)then
		日志("达到设定技能等级，返回",1)
		return
	end
	common.supplyCastle()
	common.checkHealth()	
	if(取物品叠加数量('鹿皮')< 鹿皮数量)then					
		回城()		
		移动(130, 50,"盖雷布伦森林")	
		移动(175,182)
		采集鹿皮()
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
	common.toCastle()
	goto work
::work::
	合成(合成鞋名称)	
	if(取包裹空格() < 1) then goto  pause end			
	if(取物品叠加数量("鹿皮") < 鹿皮需要数量 
		or 取物品叠加数量("麻布") < 麻布需要数量 
		or 取物品叠加数量("木棉布") < 木棉布需要数量 
		or 取物品叠加数量("毛毡") < 毛毡需要数量 )then 
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
function learnMakeShoreSkill()
	local tryNum=0
::begin::
	skill=common.findSkillData("制鞋")
	if(skill == nil)then
		common.toTeleRoom("圣拉鲁卡村")
		移动(7, 3,"村长的家")
		移动(2, 9,"圣拉鲁卡村")
		移动(32, 70,"装备品店")
		移动(14, 4,"1楼小房间")
		移动(9, 3,"地下工房")	
		while tryNum< 3 do
			移动(23, 23)
			common.learnPlayerSkill(23,24)
			等待(3000)
			skill=common.findSkillData("制鞋")
			if(skill ~= nil)then
				return true
			elseif(取当前地图名() ~= "地下工房")then
				break
			end
		end
	end	
	return true
end
function main()
	日志("欢迎使用星落全自动制鞋刷双百脚本",1)
	日志("当前职业："..人物("职业"),1)
	日志("当前职称："..人物("职称"),1)
	if(人物("职业") ~= "制鞋工")then
		日志("职业不是制鞋工",1)
		return	
	end
	扔("竹子")
	扔("孟宗竹")
	扔("铜")
::begin::
	等待空闲()
	skill=common.findSkillData("制鞋")
	if(skill == nil)then
		learnMakeShoreSkill()
	end
	if(common.findSkillData("制鞋") == nil)then
		日志("学习制鞋技能失败，脚本退出",1)
	end
	local zxlv = common.playerSkillLv("制鞋")
	if(zxlv < 3)then
		日志("当前制鞋等级为1，去刷运动鞋",1)
		makeShoe(3)
	elseif(zxlv == 3)then	--返回判断下是否需要进行转正
		日志("当前制鞋等级为3，去刷光之鞋",1)		
		if(skill ~= nil)then				
			craft = 取合成信息(skill.index,4)
			日志(craft.name.."ID:"..craft.id,1)
			if(craft.available == false)then
				日志("合成"..craft.name.."无效，登出服务器",1)
				登出服务器()
				等待(3000)
				goto begin
			end
		end
		makeShoe(4)	
	elseif(zxlv == 4)then		
		if(人物("职称") == "制鞋学徒")then
			日志("当前制鞋等级为4，尚未1转，去做生产系1转任务",1)
			执行脚本("./脚本/生产/生产系1转任务.lua")		
			执行脚本("./脚本/★转正/★生产提升阶级-制鞋.lua")		
		else
			日志("当前制鞋等级为4，已经1转，继续刷光之鞋",1)
			makeShoe(5)			
		end				
	elseif(zxlv >= 5)then
		日志("当前制鞋等级为5，去圣村重新学习技能",1)
		common.toTeleRoom("圣拉鲁卡村")
		移动(7, 3,"村长的家")
		移动(2, 9,"圣拉鲁卡村")
		移动(32, 70,"装备品店")
		移动(14, 4,"1楼小房间")
		移动(9, 3,"地下工房")		
		移动(23, 23)
		删除技能(23,24,"制鞋")
		common.learnPlayerSkill(23,24)
		skill=common.findSkillData("制鞋")
		if(skill == nil)then
			common.learnPlayerSkill(23,24)
		end				
	end
	goto begin
end
main()