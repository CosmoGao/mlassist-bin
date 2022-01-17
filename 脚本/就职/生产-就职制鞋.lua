

common=require("common")

mapName=取当前地图名()
if(mapName=="职业介绍所")then
	goto EmploymentAgency
end
common.checkHealth()
common.supplyCastle()
common.sellCastle()		--默认卖
common.outCastle("e")		
移动(195,50,"职业介绍所")
::EmploymentAgency::
	skillName="锻造体验"
	skill = common.findSkillData(skillName)
	if(skill ~= nil)then
		日志("已存在技能【"..skillName.."】")		
	else
		移动(9,6)
		common.learnPlayerSkill(9,5)
	end		
	
	移动(8,10)
	删除技能(8,11,"气功弹")
	common.learnPlayerSkill(8,11)