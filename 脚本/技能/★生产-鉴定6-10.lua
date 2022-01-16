

设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 开启高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 开启遇敌全跑 
common=require("common")
设置("自动扔",1)
设置("自动扔",1,"鲈鱼")
--设置("自动扔",1,"14670")

function 技能等级(技能名称)
	local playerData = 人物信息()
	for i,skill in ipairs(playerData.skill) do
		if(skill.name == 技能名称)then
			日志("技能等级："..技能名称..skill.lv)
			return skill.lv
		end
	end
	return 0
end

function trainSkill()
	local lv1TryNum=0
	skillLv = 技能等级("鉴定")
	while true do		
		if(skillLv == 1)then
			if(取当前地图名() ~= "拿潘食品店")then
				common.gotoFaLanCity("e1")		
				移动(217, 53, '拿潘食品店')
			end
			移动(10, 14)
			转向坐标(11, 14)
			对话选择(4,0)
			while 取物品数量("抓猫用的鱼？") > 0 and 人物("魔")>= skillLv*10 do
				工作("鉴定","抓猫用的鱼？",6500,true)		
				等待(500)
			end
			扔("鲈鱼")
		else
			if(取当前地图名() ~= "哈丝塔的家")then
				回城()
				移动(144,105)
				移动(157,93)
				转向(2)	
				等待到指定地图("艾夏岛",84,112)	
				转向(6)
				等待到指定地图("艾夏岛",164,159)					
				转向(7)				
				等待到指定地图("艾夏岛",151,97)		
				移动(167, 102, '哈丝塔的家')				
			end
			移动(11, 11)
			转向坐标(12,10)
			对话选择(32,0)
			对话选择(32,0)
			对话选择(4,0)
			对话选择(1,0)
			if(skillLv < 6 and 取物品数量("14670") > 0)then
				扔(14670)
			end
			while 取物品数量("家具？") > 0 and 人物("魔")>= skillLv*10 do
				if(skillLv < 6 and 取物品数量("14670") > 0)then
					扔(14670)
				end
				工作("鉴定","家具？",6500,true)					
				等待(500)
			end
			扔("鲈鱼")
			--ren("家具？")
			扔("垃圾２")
			扔("垃圾１")
			扔("垃圾３")
		end
		if(人物("魔")<skillLv*10)then
			break
		end
		if(skillLv == 1 and lv1TryNum>=50)then
			skillLv = 技能等级("鉴定")
			lv1TryNum=0		
		end
	end
end
function main()
	skill = common.findSkillData("鉴定")
	if(skill == nil)then
		日志("需要鉴定技能",1)
		return
	end		
	if(取当前地图名() == "拿潘食品店" or 取当前地图名() == "哈丝塔的家")then
		trainSkill()
	end
::begin::
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)	
	trainSkill()
	goto begin	
end
main()