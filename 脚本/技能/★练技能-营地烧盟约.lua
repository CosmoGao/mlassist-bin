★起点圣骑士营地医院或营地西门外，坐标不变60秒重启。

common=require("common")


补魔值=用户输入框( "多少魔以下去补给", "400")
补血值=用户输入框( "多少血以下去补给", "400")
宠补魔值=用户输入框( "宠多少魔以下去补给", "200")
宠补血值=用户输入框( "宠多少血以下去补给", "200")
卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"	
cardName = "封印卡（人形系）"
cardCount=100		--一次买多少
设置("自动叠",1,cardName.."&20")
技能名称="精灵的盟约"
清除系统消息()

function 盟约等级()
	local playerData = 人物信息()
	for i,skill in ipairs(playerData.skill) do
		if(skill.name == 技能名称)then
			日志("盟约等级："..技能名称..skill.lv)
			return skill.lv
		end
	end
	return 0
end
::begin::  
	if(取当前地图名() == "医院")then goto StartBegin end
	if(取当前地图名() ==  "圣骑士营地")then goto lu1a end
	if(取当前地图名() ==  "商店")then goto outshop end
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth()
	common.checkCrystal(水晶名称)
	common.去营地()
	goto begin 
::StartBegin::
	if(盟约等级() >= 8)then
		切换脚本("脚本/练级/★黑一队员.lua")
	end
	喊话("脚本启动等待",06,0,0)
	等待(1000)
	喊话("美特斯邦威  飞一般滴感觉",06,0,0)
	移动(11,20)
	移动( 0, 20)
	goto lu1 

::lu1::
	等待到指定地图("圣骑士营地",95,72)
::lu1a::		
	if(取物品叠加数量(cardName) < cardCount) then
		goto maika
	end
	移动(37,87)
	移动(36, 87)      
	goto lu4 

::lu4::
	等待到指定地图("肯吉罗岛")	
	移动(543, 332)
	开始遇敌()         
        
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(取物品叠加数量(cardName) < 20)then goto  ting end
	等待(2000)
	goto scriptstart  
	
::ting::
	停止遇敌()
	移动(550, 332)    
	移动(551, 332)       
	等待到指定地图("圣骑士营地")
	移动(94,73)
	移动(95, 72)       
	goto lu6 

::lu6::
	等待到指定地图("医院", 0, 20)
	移动(19,15)
	移动(18,15)
	goto xue 

::xue::
	回复(0)			-- 转向北边恢复人宠血魔	
	goto StartBegin 
::maika::
	移动(92, 118,"商店")
	移动(14,26)
	转向(2)
	等待服务器返回()
	nowCount = cardCount-取物品叠加数量(cardName)
	common.buyDstItem(cardName,nowCount)	
::outshop::
	移动(0,14,"圣骑士营地")	
	goto begin