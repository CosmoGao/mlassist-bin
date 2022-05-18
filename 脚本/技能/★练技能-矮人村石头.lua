矮人村石头烧技能脚本，自己设置技能名称和停止脚本的技能等级

common=require("common")

local 补血值=取脚本界面数据("人补血")
local 补魔值=取脚本界面数据("人补魔")
local 宠补血值=取脚本界面数据("人补血")
local 宠补魔值=取脚本界面数据("人补血")

if(补血值==nil or 补血值==0)then
	补血值=用户输入框("多少血以下补血", "430")
end
if(补魔值==nil or 补魔值==0)then
	补魔值 = 用户输入框("多少魔以下补魔", "200")
end
if(宠补血值==nil or 宠补血值==0)then
	宠补血值 = 用户输入框( "宠多少血以下补血", "50")
end
if(宠补魔值==nil or 宠补魔值==0)then
	宠补魔值=用户输入框( "宠多少魔以下补魔", "50")
end


local 走路加速值=125	--脚本走路中可以设定移动速度  到达目的地后，再还原值即可
local 走路还原值=100	--防止掉线 还原速度
local 卖店物品列表="魔石|卡片？|锹型虫的卡片|虎头蜂的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"		--可以增加多个 不影响速度
local 医生名称={"星落护士","谢谢惠顾☆"}
local 遇敌总次数=0
local 练级前经验=0
local 练级前时间=os.time() 
local 技能名称=用户输入框( "技能名称", "窃盗")
local 预设技能等级=用户输入框( "预设技能等级", "8")

function 拿酒瓶()	
	local tryCount=0
	if(取物品数量("矮人徽章")>0 or 取物品数量("巴萨的破酒瓶")>0)then
		return true
	end		
	移动(116,56,"酒吧")
::tryNa::
	移动(14, 7) 
	对话选是(0)
	tryCount= tryCount+1
	if(tryCount > 3 and 取物品数量("巴萨的破酒瓶")< 1)then
		goto tryNa
	end
	移动(0,23,"圣骑士营地")
	return true
end
function 进石头判断()
	local tryCount=0
::tryJin::
	对话选是(96,124)	
	if(人物("坐标") == "91,125")then
		return 
	elseif(tryCount > 3)then
		扔("巨石")
		return
	end
	tryCount = tryCount+1
	goto tryJin
end

function 石头练级()
	日志("石头练级",1)	
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")
	水晶名称="风地的水晶（5：5）"	
	if(common.playerSkillLv(技能名称) >= 预设技能等级)then
		日志("技能达标，脚本退出",1)
		return
	end
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()		
	if (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "矮人城镇")then goto Lu1OrLu2 
	elseif(人物("坐标")  == "91,125")then goto lu2 
	elseif(人物("坐标")  == "62,125")then goto yudi 	
	elseif(当前地图名 ==  "蜥蜴洞穴")then goto xiYi 
	elseif(当前地图名 ==  "肯吉罗岛")then goto kenDaoPanDuan end
	回城()
	等待(1000)
	goto begin
::kenDaoPanDuan::
	if(目标是否可达(232,439) == false) then --营地这边岛
		goto lu4
	end
	goto quAiRen
::Lu1OrLu2::	
	if(目标是否可达(92,124) == false) then --矮人城镇
		goto chufa
	else
		goto lu2
	end
	goto begin
::quYingDi::
	设置("移动速度",走路加速值)
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin

::quYiYuan::
	拿酒瓶()
	移动( 95, 73)
	移动( 95, 72)
	goto begin 

::StartBegin::
	喊话("脚本启动等待",06,0,0)
	等待(1000)
	移动(9,15)	
	喊话("美特斯邦威  飞一般滴感觉",06,0,0)
	goto xue
::xue::		
	移动(18,16)
	移动(18,15)
	移动(17,15)
	移动(19,15)
	移动(18,15)      
	回复(0)			-- 转向北边恢复人宠血魔      
	--等待(10000)                   --等待X秒等候队友反应      
	移动( 0, 20)   
	goto lu1

::lu1::
    等待到指定地图("圣骑士营地",95,72)	
::lu3::					--出营地
    移动( 30, 37)     
    移动( 36, 87)      
    goto lu4 
::lu4::					--去矮人
	等待到指定地图("肯吉罗岛")	
	移动(384, 247)
	移动(384, 245)
::xiYi::
	等待到指定地图("蜥蜴洞穴")
	移动(11, 2)
	移动(12, 2)
	等待到指定地图("肯吉罗岛", 307, 362)	
::quAiRen::
	移动(231, 434)	
	等待到指定地图("矮人城镇", 110, 191)	
	goto salebegin 
::lu2::        
	等待(2000)
    移动(62, 125)
::yudi::		
	等待(1000)
	开始遇敌()		-- 开始自动遇敌	
::scriptstart::		-- 遇敌回补判断
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end	
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	end		
	等待(2000)
	goto scriptstart  
	 
::ting::			--停止遇敌 回补
	停止遇敌()      
	等待空闲() 	
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率			
	if 人物("灵魂") > 0  then
		回城()
		goto begin
	end
	移动(90, 125) 
	移动(92, 125)
	等待(1000)
	等待到指定地图("矮人城镇", 101, 131)
::salebegin::			--卖和回补	
	移动(121, 111)	
	移动(163, 94)	
	回复(2)		-- 恢复人宠
	if(common.playerSkillLv(技能名称) >= 预设技能等级)then
		日志("技能达标，脚本退出",1)
		return
	end
::chufa::			--去练级点
	if(取物品数量("矮人徽章") < 1 and 取物品数量("巴萨的破酒瓶") < 1) then
		移动( 110, 191)	
		等待到指定地图("肯吉罗岛", 231, 434)	
		移动(307, 362,"蜥蜴洞穴")
		移动(12, 13,"肯吉罗岛")
		移动(551, 332,"圣骑士营地")	
		goto begin
	end
	移动(97, 124)    
	移动(97, 123)
	移动(97, 124)
	进石头判断()
	goto begin

::goEnd::
	return
end
石头练级()