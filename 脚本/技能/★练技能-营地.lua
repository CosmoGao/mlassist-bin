★起点圣骑士营地医院或营地西门外，坐标不变60秒重启。

common=require("common")


补魔值=用户输入框( "多少魔以下去补给", "400")
补血值=用户输入框( "多少血以下去补给", "400")
宠补魔值=用户输入框( "宠多少魔以下去补给", "200")
宠补血值=用户输入框( "宠多少血以下去补给", "200")
卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"	

清除系统消息()
local 技能名称=用户输入框( "技能名称", "气绝回复")

local 技能目标等级=8
function 技能等级()
	local playerData = 人物信息()
	for i,skill in ipairs(playerData.skill) do
		if(skill.name == 技能名称)then
			日志("技能等级："..技能名称..skill.lv)
			return skill.lv
		end
	end
	return 0
end
function checkSkillLevel()
	local nowSkillLv = common.playerSkillLv(技能名称)
	if(nowSkillLv>=8)then	--3转以后 先屏蔽
		return true
	end
	--4转 5转 不转 这里没有自动调用4转5转任务
	local rankLv = 人物("职称等级")
	if(nowSkillLv >= (4 + rankLv*2))then
		--去提升等价
		执行脚本("./脚本/★转正/★提升阶级-传教.lua")	
		等待(2000)
		if(rankLv == 人物("职称等级"))then	
			-- 【一 二 三转任务】 三转先放一下 这个需要队伍联动
			if(rankLv == 0)then		--1转树精
				回城()
				执行脚本("./脚本/★转正/★晋级-树精一转单人版不等待.lua")	
			elseif(rankLv == 1)then --2转神兽
				回城()
				执行脚本("./脚本/★转正/★晋级-神兽二转.lua")	
			else -- 3 4 5先不做
				return false
			end
			执行脚本("./脚本/★转正/★提升阶级-传教.lua")
		end		
		--不管成功与否 继续回去练级 当然 下次战斗判断 会重复进入此步
		return false
	end
	return false
end
::begin::  
	if(取当前地图名() == "医院")then goto StartBegin end
	if(取当前地图名() ==  "圣骑士营地")then goto lu1a end    
	if(取当前地图名() ==  "肯吉罗岛")then goto lu4 end     
	common.去营地()
	goto begin 
::StartBegin::
	if(checkSkillLevel())then return end
	喊话("脚本启动等待",06,0,0)
	等待(1000)
	喊话("美特斯邦威  飞一般滴感觉",06,0,0)
	自动寻路(11,20)
	自动寻路( 0, 20)
	goto lu1 
::lu1::
	等待到指定地图("圣骑士营地",95,72)
::lu1a::		
	自动寻路(37,87)
	自动寻路(36, 87)      
	goto lu4 

::lu4::
	等待到指定地图("肯吉罗岛")	
	自动寻路(543, 332)
	开始遇敌()         
        
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	等待(2000)
	goto scriptstart  
	
::ting::
	停止遇敌()
	自动寻路(550, 332)    
	自动寻路(551, 332)       
	等待到指定地图("圣骑士营地")
	自动寻路(94,73)
	自动寻路(95, 72)       
	goto lu6 

::lu6::
	等待到指定地图("医院", 0, 20)
	自动寻路(19,15)
	自动寻路(18,15)
	goto xue 

::xue::
	回复(0)			-- 转向北边恢复人宠血魔	
	goto StartBegin 
