1-160全自动练级

common=require("common")

local 补血值=取脚本界面数据("人补血")
local 补魔值=取脚本界面数据("人补魔")
local 宠补血值=取脚本界面数据("宠补血")
local 宠补魔值=取脚本界面数据("宠补魔")
local 队伍人数=取脚本界面数据("队伍人数")
local 设置队员列表=取脚本界面数据("队员列表")
local 队员列表={}
local 是否练宠=取脚本界面数据("是否练宠")
if(补血值==nil or 补血值==0)then
	补血值=用户输入框("人多少血以下补血", "430")
else
	补血值=tonumber(补血值)
end
if(补魔值==nil or 补魔值==0)then
	补魔值 = 用户输入框("人多少魔以下补魔", "200")
else
	补魔值=tonumber(补魔值)
end
if(宠补血值==nil or 宠补血值==0)then
	宠补血值 = 用户输入框( "宠多少血以下补血", "50")
else
	宠补血值=tonumber(宠补血值)
end
if(宠补魔值==nil or 宠补魔值==0)then
	宠补魔值=用户输入框( "宠多少魔以下补魔", "50")
else
	宠补魔值=tonumber(宠补魔值)
end
if(队伍人数==nil or 队伍人数==0)then
	队伍人数 = 用户下拉框("队伍人数",{1,2,3,4,5},5)
else
	队伍人数=tonumber(队伍人数)
end
if(设置队员列表==nil or 设置队员列表=="")then
	设置队员列表 = 用户输入框("练级队员列表，不设置则不判断队员！","")
end
if(设置队员列表 ~= nil and string.find(设置队员列表,"|") ~= nil)then
	队员列表=common.luaStringSplit(设置队员列表,"|")
end
local 龙顶还是半山=用户下拉框("龙顶还是半山练级",{"龙顶","半山"},"龙顶")
if(是否练宠==nil or 是否练宠 ==0)then
	是否练宠 = 用户输入框("是否练宠,是1，否0",0)
else
	是否练宠=tonumber(是否练宠)
end
local 是否卖石=用户下拉框("是否卖魔石",{"是","否"},"是")
local 走路加速值=110	--脚本走路中可以设定移动速度  到达目的地后，再还原值即可
local 走路还原值=100	--防止掉线 还原速度
local 身上最少金币=100000	--10w
local 多少金币去拿钱=10000	--1w

local 卖店物品列表="魔石|卡片？|锹型虫的卡片|狮鹫兽的卡片|水蜘蛛的卡片|虎头蜂的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"		--可以增加多个 不影响速度
local 医生名称={"星落护士","谢谢惠顾☆"}
local 遇敌总次数=0
local 练级前经验=0
local 练级前时间=os.time() 
local 半山西门=true	--半山是西门还是里堡二楼
local 是否自动购买水晶=1

local 扔物品列表={'时间的碎片','时间的结晶','绿头盔','红头盔','秘文之皮','星之砂','奇香木','巨石','龙角','坚硬的鳞片','传说的鹿皮','碎石头'}
设置("自动叠",1, "时间的结晶&20")	
设置("自动叠",1, "时间的碎片&20")	
for i,v in pairs(扔物品列表) do
	设置("自动扔",1, v)	
end


--不踢人 踢人可以用common接口
function 等待队伍人数达标(练级点,tmpMapName)				--等待队友	
::begin::
	喊话(练级点 .."练级脚本，来打手人够脚本自动前往【"..练级点.."】++++",2,3,5)
	等待(5000)
	if(取当前地图名()~= tmpMapName)then --增加判断地图切换返回 否则掉线后，还在新城喊
		return
	end
	if(队伍("人数") < 队伍人数) then	--数量不足 等待
		goto begin
	end	
	喊话("人数达标，自动前往【"..练级点.."】，请不要离开队伍,谢谢！",2,3,5)
	return 
end

function 营地商店检测水晶(crystalName,equipsProtectValue,buyCount)
	if(equipsProtectValue==nil)then equipsProtectValue =100 end
	if(crystalName == nil)then crystalName="水火的水晶（5：5）" end
	if(buyCount==nil) then buyCount=1 end
	--检测水晶
	local itemList = 物品信息()
	local crystal = nil
	for i,item in ipairs(itemList)do
		if(item.pos == 7)then
			crystal = item
			break
		end
	end
	if(crystal~=nil and crystal.name == crystalName and crystal.durability > equipsProtectValue) then
		return
	end
	crystal=nil
	--需要更换 检查身上是否有备用水晶
	for i,item in ipairs(itemList)do
		if(item.name == crystalName and item.durability > equipsProtectValue)then
			crystal = item
			break
		end
	end

	if(crystal~=nil ) then
		交换物品(crystal.pos,7,-1)
		return
	end
	--买水晶
	local 当前地图名 = 取当前地图名()
	if(当前地图名 == "商店")then 
		自动寻路(14,26)
	elseif(当前地图名 == "圣骑士营地")then 
		自动寻路(92, 118,"商店")
		自动寻路(14,26)
	else
		return
	end
	转向(2)
	等待服务器返回()
	common.buyDstItem(crystalName,1)
	扔(7)--扔旧的
	等待(1000)	--等待刷新
	使用物品(crystalName)	
	自动寻路(0,14,"圣骑士营地")	
end

function 营地存取金币(金额,存取)
	if(金额==nil) then return end
	local 当前地图名 = 取当前地图名()
	if(当前地图名 == "银行")then 
		自动寻路(27,23)
	elseif(当前地图名 == "圣骑士营地")then 
		自动寻路(116, 105,"银行")
		自动寻路(27,23)
	else
		return
	end
	转向(2)
	等待服务器返回()
	if(存取==nil or 存取=="存")then
		银行("存钱",金额)	
	else
		银行("取钱",金额)
	end
end
--1-10
function 森林练级(目标等级)
	日志("森林练级",1)
	设置个人简介("玩家称号",目标等级)
	练级前经验=人物("经验")	
::begin::						--开始
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	mapNum=取当前地图编号()
	if(取当前等级()	>= 目标等级) then
		return
	elseif (当前地图名=="艾尔莎岛" )then	
		goto erDao	
	elseif (mapNum==59539 )then	
		goto erYiYuan
	elseif (当前地图名=="冒险者旅馆" )then	
		goto sale
	elseif (当前地图名=="盖雷布伦森林" )then	
		goto toUpgradePos
	elseif (当前地图名=="艾夏岛" )then	
		goto aiXiaDao
	end
	回城()
	等待(1000)
	goto begin
::erDao::
	等待到指定地图("艾尔莎岛")	
	自动寻路(144,105)
	自动寻路(157,93)
	转向(2)	
	等待到指定地图("艾夏岛")		
	goto aiXiaDao
	
::aiXiaDao::					--去医院
	自动寻路(112, 81)	
	goto erYiYuan
::erYiYuan::	
	等待到指定地图("医院")	
	if common.checkHealth(医生名称) then
		goto begin
	end
	自动寻路(34, 46)
	自动寻路(35, 46)
	自动寻路(35, 47)
	自动寻路(35, 45)
	自动寻路(35, 47)
	回复(1)        			-- 恢复人宠        
	等待(8000)
	自动寻路(28, 47)
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标("森林练级","医院")
	end
	if(取当前等级()	>= 目标等级) then 
		return
	end	
	自动寻路(28, 52)	
	等待到指定地图("艾夏岛")	
	goto toSenLin
::toSenLin::					--去练级点		
	等待到指定地图("艾夏岛")
	自动寻路(190, 116)	
	goto toUpgradePos
::toUpgradePos::
	等待到指定地图("盖雷布伦森林")	
	自动寻路(225,227)
	自动寻路(223,227)
	goto kaishi
::kaishi::						--开始遇敌		
	开始遇敌()      
	goto battle
::battle::						--状态判断			--自动遇敌中 循环判断血魔
	if (人物("血") < 补血值 )then		
		goto back
	elseif (人物("魔") < 补魔值 )then	
		goto back
	elseif (宠物("血") < 宠补血值 )then	
		goto back
	elseif (宠物("魔") < 宠补魔值 )then	
		goto back
	elseif(取当前等级()	>= 目标等级) then 
		goto back		
	elseif 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	end		
	等待(1000)	
	goto battle      
::back::						--回补
	停止遇敌()                 	-- 结束战斗			
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验)	--统计脚本效率
	等待(1000)
    自动寻路(30,193,"盖雷布伦森林")	
	自动寻路(199, 211,"艾夏岛")		
	自动寻路(112, 88)
	-- if(是否卖石 == 1)then 
		-- 自动寻路(102, 115)	
		-- goto sale 
	-- end
	自动寻路(112, 81)	
	goto erYiYuan
::sale::	--卖石	
	等待到指定地图("冒险者旅馆")	
	自动寻路(37,30)
	自动寻路(38,30)
	自动寻路(37,30)
	自动寻路(38,30)
	自动寻路(37,30)
	卖(37,29,卖店物品列表)	 
	等待(3000)
	自动寻路(38, 48)
	goto begin

end
	
function 布拉基姆高地练级(目标等级,练级坐标x,练级坐标y,练级地名称)
	日志("布拉基姆高地练级-"..练级地名称,1)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")
	水晶名称="火风的水晶（5：5）"
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)	
::begin::						--开始
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	if(取当前等级()	>= 目标等级) then
		return
	elseif (当前地图名=="艾尔莎岛" )then	
		goto erDao	
	elseif(取当前地图编号() == 1112)then
		回城()
		goto begin
	elseif (当前地图名=="医院" )then	
		goto erYiYuan
	elseif (当前地图名=="冒险者旅馆" )then	
		goto sale
	elseif (当前地图名=="盖雷布伦森林" )then	
		goto toGaoDi
	elseif (当前地图名=="布拉基姆高地" )then	
		goto toUpgradePos
	elseif (当前地图名=="艾夏岛" )then	
		goto aiXiaDao
	end
	回城()
	等待(1000)
	goto begin
::erDao::
	等待到指定地图("艾尔莎岛")	
	自动寻路(144,105)
	自动寻路(157,93)
	转向(2)	
	等待到指定地图("艾夏岛")		
	goto aiXiaDao
	
::aiXiaDao::					--去医院
	自动寻路(112, 81)	
	goto erYiYuan
::erYiYuan::	
	等待到指定地图("医院")	
	if common.checkHealth(医生名称) then
		goto begin
	end
	自动寻路(34, 46)
	自动寻路(35, 46)
	自动寻路(35, 47)
	自动寻路(35, 45)
	自动寻路(35, 47)
	回复(1)        			-- 恢复人宠        
	等待(8000)
	自动寻路(28, 47)
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标(练级地名称,"医院")
	end
	if(取当前等级()	>= 目标等级) then 
		return
	end	
	自动寻路(28, 52)	
	等待到指定地图("艾夏岛")	
	goto toSenLin
::toSenLin::					--去练级点		
	等待到指定地图("艾夏岛")
	自动寻路(190, 116)	
	goto toGaoDi
::toGaoDi::
	等待到指定地图("盖雷布伦森林")
	自动寻路(231, 222)	
	goto toUpgradePos
::toUpgradePos::
	等待到指定地图("布拉基姆高地")	
	自动寻路(练级坐标x,练级坐标y)	         
	goto kaishi
::kaishi::						--开始遇敌		
	开始遇敌()      
	goto battle
::battle::						--状态判断			--自动遇敌中 循环判断血魔
	if (人物("血") < 补血值 )then		
		日志(人物("血").."<"..补血值.."回补",1)
		goto back
	elseif (人物("魔") < 补魔值 )then	
		日志(人物("魔").."<"..补血值.."回补",1)
		goto back
	elseif (宠物("血") < 宠补血值 )then	
		日志(宠物("血").."<"..宠补血值.."回补",1)
		goto back
	elseif (宠物("魔") < 宠补魔值 )then	
		日志(宠物("魔").."<"..宠补魔值.."回补",1)
		goto back
	elseif(取当前等级()	>= 目标等级) then 
		日志(取当前等级()..">="..目标等级.."回去切换脚本",1)
		goto back		
	elseif 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()	
	elseif 取当前地图名() ~= "布拉基姆高地" then
		停止遇敌()     
		goto begin		
	end		
	等待(1000)	
	goto battle      
::back::						--回补
	停止遇敌()                 	-- 结束战斗			
	日志("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率		
	等待(1000)
	自动寻路(30,193)	
	等待到指定地图("盖雷布伦森林")	
	自动寻路(199, 211)
	等待到指定地图("艾夏岛")		
	自动寻路(112, 88)
	-- if(是否卖石 == 1)then 
		-- 自动寻路(102, 115)	
		-- goto sale 
	-- end
	自动寻路(112, 81)	
	goto erYiYuan
::sale::	--卖石	
	等待到指定地图("冒险者旅馆")	
	自动寻路(37,30)
	自动寻路(38,30)
	自动寻路(37,30)
	自动寻路(38,30)
	自动寻路(37,30)
	卖(37,29,卖店物品列表)		
	等待(3000)
	自动寻路(38, 48)
	goto begin
end
function 洞窟练级(目标等级)	
	日志("洞窟练级",1)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")
	水晶名称="地水的水晶（5：5）"
	common.checkHealth(医生名称)
	if(是否自动购买水晶)then
		common.checkCrystal(水晶名称)	
	end
::begin::	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	mapNum=取当前地图编号()
	if(取当前等级()	>= 目标等级) then
		return
	elseif (当前地图名=="艾尔莎岛" )then	
		goto erDao	
	elseif (mapNum==59539 )then	
		goto erYiYuan
	elseif (当前地图名=="冒险者旅馆" )then	
		goto sale
	elseif (当前地图名=="盖雷布伦森林" )then	
		goto toGaoDi
	elseif (当前地图名=="布拉基姆高地" )then	
		goto lu4
	elseif (当前地图名=="艾夏岛" )then	
		goto aiXiaDao
	end
	回城()
	等待(1000)
	goto begin
::aiXiaDao::					--去医院
	自动寻路(112, 81)	
	goto erYiYuan
::erDao::
	自动寻路(158, 94)	
	转向(0)
	等待到指定地图("艾夏岛")
	自动寻路(112, 81)	
::erYiYuan::
	等待到指定地图("医院")	
	自动寻路(34, 46)
	自动寻路(35, 46)
	自动寻路(35, 47)
	自动寻路(35, 45)
	自动寻路(35, 47)
	回复(1)  
	等待(8000)
	自动寻路(28, 47)
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标("洞窟","医院")
	end
	if(取当前等级()	>= 目标等级) then 
		return
	end	
	自动寻路(28, 52)	
	等待到指定地图("艾夏岛")	
::start_1::
	自动寻路(190, 116)	
::toGaoDi::
	等待到指定地图("盖雷布伦森林")	
	自动寻路(231, 222)	
	等待到指定地图("布拉基姆高地")		
	自动寻路(227, 165)
    goto lu4 
::StartBegin::	
	等待到指定地图("洞窟之村　第２层", 148, 170)	
	自动寻路( 52, 145)
	goto lu1 
::lu1::
	等待到指定地图("洞窟之村　第１层")
	自动寻路( 97, 76)
	goto lu4 
::lu4::
	等待到指定地图("布拉基姆高地")	
	等待(1000)	
	自动寻路(230,165) 	     
	自动寻路(230,166) 
	等待(1000)      
	开始遇敌()  
  	goto yudi         
::yudi::	
	if(人物("血") < 补血值) then goto  ting end
	if(人物("魔") < 补魔值) then goto  ting end
	if(宠物("血") < 宠补血值) then goto  ting end
	if(宠物("魔") < 宠补魔值) then goto  ting end
	if(取当前等级()	>= 目标等级) then goto  ting end
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	end		
	if(取队伍人数() ~= 队伍人数)then	--掉线 回城
		脚本日志("队友掉线，回城！")
		goto  ting		
	elseif 取当前地图名() ~= "布拉基姆高地" then
		停止遇敌()     
		goto begin
	end
	等待(1000)	
	goto yudi  
	
::ting::	
	停止遇敌()                 -- 结束战斗
	等待到指定地图("布拉基姆高地")
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验)	--统计脚本效率
	if(取当前等级()	>= 目标等级) then 
		调试(取当前等级()..">="..目标等级)
		回城()
		return 
	end
	if(取队伍人数() ~= 队伍人数)then	--掉线 回城
		脚本日志("队友掉线，回城！")
		回城()
		goto begin
	end
	if common.checkHealth(医生名称) then
		goto begin
	end
	自动寻路(230,165)
	自动寻路(231,165)       
	等待到指定地图("洞窟之村　第１层")	
	自动寻路(203,98)	
	自动寻路(203,100)
	goto lu6 

::lu6::
	等待到指定地图("洞窟之村　第２层", 52, 145)
	自动寻路(142,163)
	自动寻路(142,170)
	自动寻路(148,170)
	自动寻路(148,169)
	自动寻路(148,171)
	自动寻路(148,170)      
    goto xue 
::xue::
    回复(2)			-- 转向北边恢复人宠血魔      
    等待(16000)                   --等待X秒等候队友反应
    goto StartBegin 
::sale::	--卖石	
	等待到指定地图("冒险者旅馆")	
	自动寻路(37,30)
	自动寻路(38,30)
	自动寻路(37,30)
	自动寻路(38,30)
	自动寻路(37,30)
	卖(37,29,卖店物品列表)	
	等待(3000)
	自动寻路(38, 48)
	goto begin
end
function 回廊练级(目标等级)	
	日志("回廊练级",1)
	设置个人简介("玩家称号",目标等级)
	练级前经验=人物("经验")
::begin::	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	if(取当前等级()	>= 目标等级) then
		return
	elseif (当前地图名=="艾尔莎岛" )then	
		自动寻路(140,105)				
		转向(1)
		等待服务器返回()
		对话选择(4,0)
		等待到指定地图("里谢里雅堡")
		goto liBao
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao	
	elseif (当前地图名=="过去与现在的回廊" )then	
		goto huiLang	
--法兰城先不判断		
	end
	回城()
	等待(1000)
	goto begin
::liBao::
	自动寻路(34, 89)
	等待(2000)
	回复(1)		
	common.checkHealth(医生名称)
	common.toCastle()
	自动寻路(30, 79)
	卖(0,卖店物品列表)		
	自动寻路(52, 72)		
	对话选是(2)	
::huiLang::
	等待到指定地图("过去与现在的回廊")	
	等待(1000)
	自动寻路(11, 21)
	--等待入队(队伍人数)
	if(队伍("人数") < 队伍人数) then	--数量不足 等待
		等待队伍人数达标("回廊","过去与现在的回廊")
	end
	自动寻路(7, 20)	
	开始遇敌()
::yudi::	
	if(人物("血") < 补血值) then goto  ting end
	if(人物("魔") < 补魔值) then goto  ting end
	if(宠物("血") < 宠补血值) then goto  ting end
	if(宠物("魔") < 宠补魔值) then goto  ting end
	if(取当前等级()	>= 目标等级) then goto  ting end
	if(队伍("人数") < 2) then goto ting end
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	end		
	等待(1000)	
	goto yudi  
::ting::	
	停止遇敌()                 -- 结束战斗	
	等待空闲()
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验)	--统计脚本效率
	if(取当前等级()	>= 目标等级) then 
		调试(取当前等级()..">="..目标等级)
		回城()
		return 
	end
	回城()
	等待(2000)	
	goto begin 
end

--登补 比走路快
function 雪塔练级(目标等级,目标地图)
	日志("雪塔练级-"..目标地图,1)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")
	水晶名称="地水的水晶（5：5）"
	local tgtMapName="雪拉威森塔４９层"
	if(目标地图=="t49")then
		tgtMapName="雪拉威森塔４９层"
		水晶名称="地水的水晶（5：5）"
	elseif(目标地图=="t55")then	
		tgtMapName="雪拉威森塔５５层"
		水晶名称="地水的水晶（5：5）"
	elseif(目标地图=="t60")then		
		tgtMapName="雪拉威森塔６０层"
		水晶名称="地水的水晶（5：5）"
	elseif(目标地图=="t65")then	
		tgtMapName="雪拉威森塔６５层"
		水晶名称="火风的水晶（5：5）"
	elseif(目标地图=="t70")then	
		tgtMapName="雪拉威森塔７０层"
		水晶名称="火风的水晶（5：5）"
	elseif(目标地图=="t75")then	
		tgtMapName="雪拉威森塔７５层"
		水晶名称="火风的水晶（5：5）"
	elseif(目标地图=="t79")then	
		tgtMapName="雪拉威森塔７９层"
		水晶名称="火风的水晶（5：5）"
	elseif(目标地图=="t80")then	
		tgtMapName="雪拉威森塔８０层"
		水晶名称="地水的水晶（5：5）"
	elseif(目标地图=="t85")then	
		tgtMapName="雪拉威森塔８５层"
		水晶名称="火风的水晶（5：5）"
	elseif(目标地图=="t90")then	
		tgtMapName="雪拉威森塔９０层"
		水晶名称="火风的水晶（5：5）"
	elseif(目标地图=="t95")then	
		tgtMapName="雪拉威森塔９５层"
		水晶名称="火风的水晶（5：5）"
	end	
	设置("自动加血",0)
::begin::	
	等待空闲()	
	common.checkHealth(医生名称)
	if(是否自动购买水晶)then
		common.checkCrystal(水晶名称)	
	end
	local 当前地图名 = 取当前地图名()	
	if(取当前等级()	>= 目标等级) then
		return
	elseif (当前地图名=="艾尔莎岛" )then		
		goto aiDao	
	elseif (当前地图名=="雪拉威森塔４９层" )then	
		goto t49	
	elseif (当前地图名=="雪拉威森塔５５层" )then	
		goto t55
	elseif (当前地图名=="雪拉威森塔６０层" )then	
		goto t60	
	elseif (当前地图名=="雪拉威森塔６５层" )then	
		goto t65	
	elseif (当前地图名=="雪拉威森塔７０层" )then	
		goto t70	
	elseif (当前地图名=="雪拉威森塔７５层" )then	
		goto t75	
	elseif (当前地图名=="雪拉威森塔７９层" )then	
		goto t79	
	elseif (当前地图名=="雪拉威森塔８０层" )then	
		goto t80	
	elseif (当前地图名=="雪拉威森塔８５层" )then	
		goto t85	
	elseif (当前地图名=="雪拉威森塔９０层" )then	
		goto t90	
	elseif (当前地图名=="雪拉威森塔９５层" )then	
		goto t95
	elseif (当前地图名=="国民会馆" )then	
		goto 国民会馆	
	end
	回城()
	等待(1000)
	goto begin
::aiDao::
	设置("移动速度",走路加速值)	
	自动寻路(165,153)
	等待(1000)	
	对话选是(4)	
::liXiaDao::
	等待到指定地图("利夏岛")	
	自动寻路(90,99,"国民会馆")
::国民会馆::	
	自动寻路(110,43)	
	卖(110,42, 卖店物品列表)		
	自动寻路(109,51)
	回复(108,52)
	自动寻路(109,50)
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标("T"..目标等级,"国民会馆")
	end
	if(取当前等级()	>= 目标等级) then 
		return
	end	
	自动寻路(108,39,"雪拉威森塔１层")
	自动寻路(75, 50,"雪拉威森塔５０层")
::judgeLv::
	if(目标地图=="t49")then
		自动寻路(74, 59,"雪拉威森塔４９层")	
		goto t49
	elseif(目标地图=="t55")then
		自动寻路(27, 55,"雪拉威森塔５５层")	
		goto t55
	elseif(目标地图=="t60")then
		自动寻路(25, 55,"雪拉威森塔６０层")	
		goto t60
	elseif(目标地图=="t65")then
		自动寻路(23, 55,"雪拉威森塔６５层")	
		goto t65
	elseif(目标地图=="t70")then
		自动寻路(21, 55,"雪拉威森塔７０层")	
		goto t70
	elseif(目标地图=="t75")then
		自动寻路(24, 44,"雪拉威森塔７５层")	
		goto t75
	elseif(目标地图=="t79")then
		自动寻路(22, 44,"雪拉威森塔８０层")	
		goto t80
	elseif(目标地图=="t80")then
		自动寻路(22, 44,"雪拉威森塔８０层")	
		goto t80
	elseif(目标地图=="t85")then
		自动寻路(20, 44,"雪拉威森塔８５层")	
		goto t85
	elseif(目标地图=="t90")then
		自动寻路(18, 44,"雪拉威森塔９０层")	
		goto t90
	elseif(目标地图=="t95")then
		自动寻路(16, 44,"雪拉威森塔９５层")	
		goto t90
	end
	
::t55::
	等待到指定地图("雪拉威森塔５５层")	
	设置("移动速度",走路还原值)
	自动寻路(131, 93)		
	开始遇敌()
	goto yudi
::t60::
	等待到指定地图("雪拉威森塔６０层")	
	设置("移动速度",走路还原值)
	自动寻路(95, 147)		
	开始遇敌()
	goto yudi
::t65::
	等待到指定地图("雪拉威森塔６５层")	
	设置("移动速度",走路还原值)
	自动寻路(116, 55)		
	开始遇敌()
	goto yudi
::t70::
	等待到指定地图("雪拉威森塔７０层")	
	设置("移动速度",走路还原值)
	自动寻路(77, 55)		
	开始遇敌()
	goto yudi
::t75::
	等待到指定地图("雪拉威森塔７５层")	
	设置("移动速度",走路还原值)
	自动寻路(135, 132)		
	开始遇敌()
	goto yudi
::t79::
	等待到指定地图("雪拉威森塔７９层")	
	设置("移动速度",走路还原值)
	自动寻路(158, 122)		
	开始遇敌()
	goto yudi
::t80::
	等待到指定地图("雪拉威森塔８０层")	
	if(目标地图=="t79")then
		自动寻路(159, 123,"雪拉威森塔７９层")	
		goto t79
	end
	设置("移动速度",走路还原值)
	自动寻路(161, 123)		
	开始遇敌()
	goto yudi
::t85::
	等待到指定地图("雪拉威森塔８５层")	
	设置("移动速度",走路还原值)
	自动寻路(57, 133)		
	开始遇敌()
	goto yudi
::t90::
	等待到指定地图("雪拉威森塔９０层")	
	设置("移动速度",走路还原值)
	自动寻路(61,41)		
	开始遇敌()
	goto yudi
::t95::
	等待到指定地图("雪拉威森塔９５层")	
	设置("移动速度",走路还原值)
	自动寻路(101, 45)		
	开始遇敌()
	goto yudi
::t49::
	等待到指定地图("雪拉威森塔４９层")	
	设置("移动速度",走路还原值)
	自动寻路(82, 64)
	自动寻路(82, 58)	
	开始遇敌()
	goto yudi
::yudi::	
	if(人物("血") < 补血值) then goto  ting end
	if(人物("魔") < 补魔值) then goto  ting end
	if(宠物("血") < 宠补血值) then goto  ting end
	if(宠物("魔") < 宠补魔值) then goto  ting end
	if(取当前等级()	>= 目标等级) then goto  ting end
	if(队伍("人数") < 队伍人数) then goto ting end	--只判断3个 掉线的先不管
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	end		
	if(取当前地图名() ~= tgtMapName)then goto ting end
	等待(1000)	
	goto yudi  
::ting::	
	停止遇敌()                 -- 结束战斗	
	等待空闲()
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	
	if(取当前等级()	>= 目标等级) then 
		日志("当前等级大于指定等级，切换脚本",1)
		回城()
		return 
	end
	回城()
	等待(2000)	
	goto begin 
end

function 是否需要做营地任务()
	local needCampMission=false
	if(取物品数量("承认之戒") < 1)then
		日志("需要做承认任务",1)
		return true
	end
	
::begin::
	local getEro=false
	if(队伍("人数") == 队伍人数)then
		local teamPlayers = 队伍信息()
		for index,teamPlayer in ipairs(teamPlayers) do
			if(teamPlayer.is_me ~= 1)then
				local friendCard = 取好友名片(teamPlayer.name)
				if( friendCard ~= nil)then
					if(friendCard.title == "需要做承认任务")then
						needCampMission=true
						break
					elseif(friendCard.title ~= "有承认")then	
						getEro=true
						break
					end
				end
			end	
		end
	else
		for index,teamPlayer in ipairs(队员列表) do			
			local friendCard = 取好友名片(teamPlayer)
			if( friendCard ~= nil)then
				if(friendCard.title == "需要做承认任务")then
					needCampMission=true
					break
				elseif(friendCard.title ~= "有承认")then	
					getEro=true
					break
				end
			end
			
		end
	end
	
	if(getEro) then
		goto begin
	end
	if(needCampMission)then
		日志("需要做承认任务",1)
	else
		日志("不需要做承认任务",1)
	end
	return needCampMission
end
function 营地任务()
	local needCampMission=是否需要做营地任务()		
	if(needCampMission==false) then
		return
	end
	--队长拿信
	-- if(取物品数量("承认之戒") > 0)then
		-- 扔("承认之戒")
	-- end
	common.checkHealth(医生名称)
	common.supplyCastle()
::begin::	
	--加个重复判断吧，防止卡在这个函数中	
	if (取物品数量("团长的证明") > 0 ) then
		goto battleBoss	
	end
	if(取物品数量("信笺") > 0)then		
		goto naZhengMing
	end
	if(取物品数量("信笺") < 1 and 取物品数量("信") < 1 and 取物品数量("承认之戒") < 1)then
		common.toCastle("f3")
		对话坐标选是(5,3)		
	end	
	if(取物品数量("信") > 0) then
		common.toCastle("f3")
		对话坐标选是(5,3)	
		-- if(取物品数量("承认之戒") > 0)then
			-- 扔("承认之戒")
		-- end
	end
	if(取物品数量("承认之戒") > 0)then		
		goto naZhengMing
	end
	goto begin	

::naZhengMing::
	common.checkHealth(医生名称)
	common.supplyCastle()
	common.toCastle()	--默认城堡卖石附近
	自动寻路(41,84)
	while (队伍("人数") < 队伍人数) do --等待组队完成
		if(是否需要做营地任务() == false)then
			return 
		end
		等待(5000)
	end
	自动寻路(41,98)	
	自动寻路(153,241,"芙蕾雅")
	自动寻路(513,282,"曙光骑士团营地")
	自动寻路(52,68,"曙光营地指挥部")
	if(目标是否可达(69,70))then
		自动寻路(69,70)
	end	
	if(目标是否可达(95,7))then		
		自动寻路(96,6)
		自动寻路(94,6)
		自动寻路(96,6)
		对话选是(95,7)
	end		
	goto battleBoss

::battleBoss::		
	if(队伍("人数") < 队伍人数) then --等待组队完成
		日志("队伍人数:"..队伍("人数").." 小于预设人数:"..队伍人数,1)
		common.checkHealth(医生名称)
		common.supplyCastle()
		common.toCastle()	--默认城堡卖石附近
		自动寻路(41,84)
		needCampMission=是否需要做营地任务()		
		if(needCampMission==false) then
			return
		end
		common.makeTeam(队伍人数)	
		自动寻路(41,98)	
		自动寻路(153,241,"芙蕾雅")
		自动寻路(513,282,"曙光骑士团营地")
	end
	local 当前地图名 = 取当前地图名()
	if (当前地图名 =="曙光营地指挥部" )then 
		自动寻路(85,3)
		--自动寻路(69,70)
		自动寻路(53,79,"曙光骑士团营地")
		自动寻路(55,47,"辛希亚探索指挥部")
		goto quMiGong
	elseif(当前地图名 =="曙光骑士团营地" ) then
		自动寻路(55,47,"辛希亚探索指挥部")
		goto quMiGong
	elseif(当前地图名 =="辛希亚探索指挥部" ) then		
		goto quMiGong
	elseif(当前地图名 =="遗迹" ) then
		goto boss
	elseif(当前地图名 =="研究室" ) then
		goto naSuiPian
	elseif(string.find(当前地图名,"废墟地下") ~= nil)then
		goto chuanYueMiGong
	end
	goto begin
::quMiGong::	
	if(是否目标附近(44,22)) then  --如果穿越中 被传出来 
		移动到目标附近(44,22)
		自动寻路(44,22,"废墟地下1层")	
		goto chuanYueMiGong
	end
	等待空闲()
	mapIndex = 取当前地图编号()
	if (mapIndex==27014 )then	
		if(目标是否可达(95,9) == false) then --第一个
			自动寻路(7,4)		
		else
			自动寻路(95,9)			
		end
		等待(1000)
	elseif (mapIndex==27101 )then
		自动寻路(39,21)
		自动寻路(39,23)
		自动寻路(39,21)
		对话选是(40,22)		
		等待(2000)
		自动寻路(44,22,"废墟地下1层")	
		goto chuanYueMiGong
	end	
	等待(1000)
	goto battleBoss		
	-- 自动寻路(55,47,"辛希亚探索指挥部")
	-- 自动寻路(7,4)
	-- 自动寻路(91,6)
	-- 自动寻路(95,9,"27101")
	-- 对话坐标选是(40,22)		
	-- 自动寻路(44,22,"废墟地下1层")		
::boss::
	自动寻路(15,14)
	对话选是(6)
	等待(2000)
	等待空闲()
	goto battleBoss
::naSuiPian::
	扔("魔石")
	自动寻路(13,15)
	自动寻路(15,15)
	自动寻路(13,15)	
	对话选是(14,14)
	if(取物品数量("怪物碎片") > 0) then
		--回城()
		等待(2000)
		common.gotoFaLanCity()	
		自动寻路(153,241,"芙蕾雅")
		自动寻路(513,282,"曙光骑士团营地")
		自动寻路(52,68,"曙光营地指挥部")
		自动寻路(69,70)
		自动寻路(85,3)		
		对话坐标选是(95,7)	
		if(取物品数量("信") > 0) then
			common.toCastle("f3")
			对话坐标选是(5,3)	
			return
		end
	end
	goto battleBoss
::chuanYueMiGong::
	自动穿越迷宫()
	goto battleBoss
end

function 营地练级(目标等级)
	日志("目标等级",1)
	日志("营地练级",1)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")
	水晶名称="火风的水晶（5：5）"
	等待空闲()
	营地任务()
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	--营地任务()
	mapNum=取当前地图编号()	
	if(取当前等级()	>= 目标等级) then 
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	elseif (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(mapNum ==  1112)then goto quYingDi 	
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "肯吉罗岛")then goto lu4 end
	回城()
	等待(1000)
	goto begin
::quYingDi::
	设置("移动速度",走路加速值)
	common.checkHealth(医生名称)
	common.checkCrystal("火风的水晶（5：5）")
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin
::StartBegin::
	喊话("脚本启动等待",06,0,0)
	等待(1000)
	自动寻路(9,15)
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标("营地","医院")
	end
	if(取当前等级()	>= 目标等级) then 
		--下一个不需要登出 直接返回
		return
	end	
	喊话("美特斯邦威  飞一般滴感觉",06,0,0)
    自动寻路( 0, 20)      
    goto lu1 

::lu1::
    等待到指定地图("圣骑士营地",95,72)
::lu1a::   
	自动寻路( 87, 72)      
	goto lu2 
::lu2::
	等待到指定地图("工房",30,37)
	自动寻路(21,22)
	自动寻路(20,22)
	自动寻路(20,24)
	自动寻路(21,24)      
	等待(2000)
	goto sale 

::sale::      
    卖(0, 卖店物品列表)	
    等待(15000)
    goto lu3 
::lu3::      
    等待到指定地图("工房",21,24)    
    自动寻路( 30, 37)
    等待到指定地图("圣骑士营地",87,72)     
    自动寻路( 36, 87)      
    goto lu4 
::lu4::
	等待到指定地图("肯吉罗岛")	
    喊话("网络不好 小心自动掉线 请时常查看",06,0,0)
	等待(1000)
    喊话("么有传教 亲 自救",06,0,0)	
	自动寻路(528, 332)        		--离远点
    开始遇敌()                 
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(取当前等级()	>= 目标等级) then goto  ting end
	if(取当前地图名()~="肯吉罗岛")then goto  ting end
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	else
		minHp=队友当前血最少值()
		if(minHp~= 88888 and minHp ~= 0 and  minHp < 200)then	
			日志("队友血量过低"..minHp.."，回补！",1)				
			goto ting
		end
	end		
	等待(2000)
	goto scriptstart  
	
::ting::
	停止遇敌()      
	等待空闲() 	
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率
	if(取当前地图名()~="肯吉罗岛")then goto  begin end
	自动寻路(551, 332,"圣骑士营地")	
	goto quYiYuan
::quYiYuan::
	自动寻路( 95, 72)
	goto lu6 
::lu6::
	等待到指定地图("医院", 0, 20)     
	自动寻路(14,20)
	自动寻路(18,16)
	自动寻路(18,15)
	自动寻路(17,15)
	自动寻路(19,15)
	自动寻路(18,15)       
	goto xue 

::xue::
	回复(0)			-- 转向北边恢复人宠血魔      
	等待(15000)                   --等待X秒等候队友反应 
	if(宠物("健康") > 0) then	
		自动寻路(6,7)
		自动寻路(8,7)
		自动寻路(6,7)
		转向坐标(7,6)
		等待服务器返回()
		对话选择(-1,6)		
	end
	goto begin 

::goEnd::
	return
end
function 蝎子练级(目标等级)
	日志("蝎子练级",1)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")
	水晶名称="水火的水晶（5：5）"
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()		
	mapNum=取当前地图编号()	
	if(取当前等级()	>= 目标等级) then 
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	elseif (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(mapNum ==  1112)then 回城() goto begin 
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "矮人城镇")then goto chufa 
	elseif(当前地图名 ==  "蜥蜴洞穴")then goto xiYi 
	elseif(当前地图名 ==  "肯吉罗岛")then goto kenDaoPanDuan end
	回城()
	等待(1000)
	goto begin
::kenDaoPanDuan::
	if(目标是否可达(232,439) == false) then --营地这边岛
		goto lu4
	end
	goto yudi
::quYingDi::
	设置("移动速度",走路加速值)
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin

::quYiYuan::
	自动寻路( 95, 73)
	自动寻路( 95, 72)
	goto begin 

::StartBegin::
	喊话("脚本启动等待",06,0,0)
	等待(1000)
	自动寻路(9,15)
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标("蝎子","医院")
	end
	if(取当前等级()	>= 目标等级) then 
		--下一个不需要登出 直接返回
		return
	end	
	喊话("美特斯邦威  飞一般滴感觉",06,0,0)
	goto xue
::xue::		
	自动寻路(18,16)
	自动寻路(18,15)
	自动寻路(17,15)
	自动寻路(19,15)
	自动寻路(18,15)      
	回复(0)			-- 转向北边恢复人宠血魔      
	等待(10000)                   --等待X秒等候队友反应      
	自动寻路( 0, 20)   
	goto lu1

::lu1::
    等待到指定地图("圣骑士营地",95,72)
::lu3::					--出营地
    自动寻路( 30, 37)     
    自动寻路( 36, 87)      
    goto lu4 
::lu4::					--去矮人
	等待到指定地图("肯吉罗岛")	
	自动寻路(384, 247)
	自动寻路(384, 245)
::xiYi::
	等待到指定地图("蜥蜴洞穴")
	自动寻路(11, 2)
	自动寻路(12, 2)
	等待到指定地图("肯吉罗岛", 307, 362)	
	自动寻路(231, 434)	
	等待到指定地图("矮人城镇", 110, 191)	
	goto salebegin 

::yudi::	
	自动寻路(232, 439,"肯吉罗岛")	
	等待(1000)
	开始遇敌()		-- 开始自动遇敌	
::scriptstart::		-- 遇敌回补判断
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(取当前等级()	>= 目标等级) then goto  ting end
	if(取当前地图名()~="肯吉罗岛")then goto  ting end
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	else
		minHp=队友当前血最少值()
		if(minHp~= 88888 and minHp ~= 0 and  minHp < 200)then	
			日志("队友血量过低"..minHp.."，回补！",1)				
			goto ting
		end
	end		
	if(取队伍人数() ~= 队伍人数)then	--掉线 回城
		脚本日志("队友掉线，回城！")
		goto  ting		
	end
	等待(2000)
	goto scriptstart  
	 
::ting::			--停止遇敌 回补
	停止遇敌()      
	等待空闲() 	
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率		
	if(取队伍人数() ~= 队伍人数)then	--掉线 回城
		回城()
		等待(2000)
		goto begin
	end
	if(取当前地图名()~="肯吉罗岛")then goto  begin end
	自动寻路(231, 434)		
	等待到指定地图("矮人城镇", 110, 191)
::salebegin::			--卖和回补
	自动寻路(121, 111)
	自动寻路(121, 109)
	自动寻路(121, 111)
	卖(1, 卖店物品列表)	
	等待(15000)
	自动寻路(163, 94)
	自动寻路(163, 95)		
	自动寻路(163, 94)
	自动寻路(163, 95)
	自动寻路(163, 94)
	等待(4000)
	回复(2)		-- 恢复人宠
	等待(16000)
::chufa::			--去练级点
	自动寻路(110, 189)		
	自动寻路( 110, 191)	
	等待到指定地图("肯吉罗岛", 231, 434)	
	自动寻路(231, 439)
	if(取当前等级()	>= 目标等级) then 
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	end
	goto yudi 

::goEnd::
	return
end

function 沙滩练级(目标等级)
	日志("沙滩练级",1)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")
	水晶名称="风地的水晶（5：5）"
	--营地任务()

::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()
	mapNum=取当前地图编号()	
	if(取当前等级()	>= 目标等级) then 
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	elseif (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(mapNum ==  1112)then 回城() goto begin 
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "肯吉罗岛")then goto kenDaoPanDuan end
	回城()
	等待(1000)
	goto begin
::kenDaoPanDuan::
	if(目标是否可达(551, 332)) then --营地这边岛
		goto lu4
	end
	--矮人这边 回营地		
	自动寻路(307, 362,"蜥蜴洞穴")
	自动寻路(12, 12)
	自动寻路(12, 13,"肯吉罗岛")
	等待(1000)
	等待空闲()
	goto lu4
::quYingDi::
	设置("移动速度",走路加速值)
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin
::StartBegin::
	喊话("脚本启动等待",06,0,0)
	等待(1000)
	自动寻路(9,15)
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标("营地","医院")
	end
	if(取当前等级()	>= 目标等级) then 
		--下一个不需要登出 直接返回
		return
	end	
	喊话("美特斯邦威  飞一般滴感觉",06,0,0)
    自动寻路( 0, 20)      
    goto lu1 

::lu1::
    等待到指定地图("圣骑士营地",95,72)
::lu1a::   
	自动寻路( 87, 72)      
	goto lu2 
::lu2::
	等待到指定地图("工房",30,37)
	自动寻路(21,22)
	自动寻路(20,22)
	自动寻路(20,24)
	自动寻路(21,24)      
	等待(2000)
	goto sale 

::sale::      
    卖(0, 卖店物品列表)	
    等待(15000)
    goto lu3 
::lu3::      
    等待到指定地图("工房",21,24)    
    自动寻路( 30, 37)
    等待到指定地图("圣骑士营地",87,72)     
    自动寻路( 36, 87)      
    goto lu4 
::lu4::
	等待到指定地图("肯吉罗岛")	  
	自动寻路(467, 201)        
    开始遇敌()                 
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(取当前等级()	>= 目标等级) then goto  ting end
	if(取当前地图名()~="肯吉罗岛")then goto  ting end
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	else
		minHp=队友当前血最少值()
		if(minHp~= 88888 and minHp ~= 0 and  minHp < 200)then	
			日志("队友血量过低"..minHp.."，回补！",1)				
			goto ting
		end
	end		
	if(取队伍人数() < 3)then	--掉线 回城
		脚本日志("队友掉线，回城！")
		goto ting		
	end
	等待(2000)
	goto scriptstart  
	
::ting::
	停止遇敌()      
	等待空闲() 	
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率
	if(取当前地图名()~="肯吉罗岛")then goto  begin end
	自动寻路(551, 332,"圣骑士营地")	
	goto quYiYuan
::quYiYuan::
	自动寻路( 95, 72)
	goto lu6 
::lu6::
	等待到指定地图("医院", 0, 20)     
	自动寻路(14,20)
	自动寻路(18,16)
	自动寻路(18,15)
	自动寻路(17,15)
	自动寻路(19,15)
	自动寻路(18,15)       
	goto xue 

::xue::
	回复(0)			-- 转向北边恢复人宠血魔      
	等待(15000)                   --等待X秒等候队友反应 
	if(宠物("健康") > 0) then	
		自动寻路(6,7)
		自动寻路(8,7)
		自动寻路(6,7)
		转向坐标(7,6)
		等待服务器返回()
		对话选择(-1,6)		
	end
	goto begin 

::goEnd::
	return
end


function 拿酒瓶()	
	local tryCount=0
	if(取物品数量("矮人徽章")>0 or 取物品数量("巴萨的破酒瓶")>0)then
		return true
	end		
	自动寻路(116,56,"酒吧")
::tryNa::
	--自动寻路(14, 7) 
	自动寻路(13, 5) 
	自动寻路(13, 4) 
	自动寻路(13, 5) 
	自动寻路(13, 4)
	自动寻路(13, 5) 
	对话选是(14,5)
	tryCount= tryCount+1
	if(tryCount > 3 and 取物品数量("巴萨的破酒瓶")< 1)then
		扔("魔石")
		goto tryNa
	end
	自动寻路(0,23,"圣骑士营地")
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
function 石头练级(目标等级)
	日志("石头练级",1)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")
	水晶名称="风地的水晶（5：5）"	
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()
	mapNum	=取当前地图编号()
	if(取当前等级()	>= 目标等级) then 
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	elseif (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(mapNum ==  1112)then 回城() goto begin 
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
	自动寻路( 95, 73)
	自动寻路( 95, 72)
	goto begin 

::StartBegin::
	喊话("脚本启动等待",06,0,0)
	等待(1000)
	自动寻路(9,15)
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标("石头","医院")
	end
	if(取当前等级()	>= 目标等级) then 
		--下一个不需要登出 直接返回
		日志("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",1)
		return
	end	
	喊话("美特斯邦威  飞一般滴感觉",06,0,0)
	goto xue
::xue::		
	自动寻路(18,16)
	自动寻路(18,15)
	自动寻路(17,15)
	自动寻路(19,15)
	自动寻路(18,15)      
	回复(0)			-- 转向北边恢复人宠血魔      
	等待(10000)                   --等待X秒等候队友反应      
	自动寻路( 0, 20)   
	goto lu1

::lu1::
    等待到指定地图("圣骑士营地",95,72)	
::lu3::					--出营地
    自动寻路( 30, 37)     
    自动寻路( 36, 87)      
    goto lu4 
::lu4::					--去矮人
	等待到指定地图("肯吉罗岛")	
	自动寻路(384, 247)
	自动寻路(384, 245)
::xiYi::
	等待到指定地图("蜥蜴洞穴")
	自动寻路(11, 2)
	自动寻路(12, 2)
	等待到指定地图("肯吉罗岛", 307, 362)	
::quAiRen::
	自动寻路(231, 434)	
	等待到指定地图("矮人城镇", 110, 191)	
	goto salebegin 
::lu2::        
	等待(2000)
    自动寻路(62, 125)
::yudi::		
	等待(1000)
	开始遇敌()		-- 开始自动遇敌	
::scriptstart::		-- 遇敌回补判断
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(取当前等级()	>= 目标等级) then goto  ting end
	if(取当前地图名()~="矮人城镇")then goto  begin end
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	else
		minHp=队友当前血最少值()
		if(minHp~= 88888 and minHp ~= 0 and  minHp < 200)then	
			日志("队友血量过低"..minHp.."，回补！",1)				
			goto ting
		end
	end		
	if(取队伍人数() ~= 队伍人数)then	--掉线 回城
		脚本日志("队友掉线，回城！")
		goto  ting		
	end
	等待(2000)
	goto scriptstart  
	 
::ting::			--停止遇敌 回补
	停止遇敌()      
	等待空闲() 	
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率		
	if(取队伍人数() ~= 队伍人数)then	--掉线 回城
		回城()
		等待(2000)
		goto begin
	end
	if(取当前地图名()~="矮人城镇")then goto  begin end
	自动寻路(90, 125) 
	自动寻路(92, 125)	
	等待(2000)
	if(目标是否可达(101,131) == false) then --营地这边岛 去矮人
		goto ting
	end
	--等待到指定地图("矮人城镇", 101, 131)
::salebegin::			--卖和回补	
	自动寻路(121, 111)	
	自动寻路(163, 94)
	自动寻路(163, 95)		
	自动寻路(163, 94)
	自动寻路(163, 95)
	自动寻路(163, 94)	
	回复(2)		-- 恢复人宠
	等待(10000)
::chufa::			--去练级点
	if(取物品数量("矮人徽章") < 1 and 取物品数量("巴萨的破酒瓶") < 1) then
		自动寻路( 110, 191)	
		等待到指定地图("肯吉罗岛", 231, 434)	
		自动寻路(307, 362,"蜥蜴洞穴")
		自动寻路(12, 13,"肯吉罗岛")
		自动寻路(551, 332,"圣骑士营地")	
		goto begin
	end
	自动寻路(97, 124)    
	自动寻路(97, 123)
	自动寻路(97, 124)
	进石头判断()
	goto begin

::goEnd::
	return
end


function 蜥蜴练级(目标等级)
	日志("蜥蜴练级",1)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")	
	水晶名称="风地的水晶（5：5）"	
	outMazeX=nil	--蜥蜴和黑一 练级时 记录迷宫坐标
	outMazeY=nil
::begin::
	停止遇敌()      
	等待空闲() 	
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()		
	if(取当前等级()	>= 目标等级) then 
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	elseif (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(取当前地图编号() ==  1112)then 回城() goto begin 	
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "矮人城镇")then goto Lu1OrLu2 
	elseif(当前地图名 ==  "蜥蜴洞穴")then goto xiYi2 
	elseif(当前地图名 ==  "蜥蜴洞穴上层第1层")then goto yudi 
	elseif(当前地图名 ==  "肯吉罗岛")then goto kenDaoPanDuan end
	回城()
	等待(1000)
	goto begin
::kenDaoPanDuan::
	if(目标是否可达(232,439) == false) then --营地这边岛 去矮人
		goto lu4
	end
	--矮人这边 回矮人吧
	goto HuiAiRen
::Lu1OrLu2::	
	if(目标是否可达(92,124) == false) then --矮人城镇
		goto chufa
	else
		自动寻路(92, 125)
		等待(1000)
		等待到指定地图("矮人城镇", 101, 131)
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
	自动寻路( 95, 73)
	自动寻路( 95, 72)
	goto begin 

::StartBegin::
	喊话("脚本启动等待",06,0,0)
	等待(1000)
	自动寻路(9,15)
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标("蝎子","医院")
	end
	if(取当前等级()	>= 目标等级) then 
		--下一个不需要登出 直接返回
		return
	end	
	喊话("美特斯邦威  飞一般滴感觉",06,0,0)
	goto xue
::xue::		
	自动寻路(18,16)
	自动寻路(18,15)
	自动寻路(17,15)
	自动寻路(19,15)
	自动寻路(18,15)      
	回复(0)			-- 转向北边恢复人宠血魔      
	等待(10000)                   --等待X秒等候队友反应      
	自动寻路( 0, 20)   
	goto lu1

::lu1::
    等待到指定地图("圣骑士营地",95,72)
::lu3::					--出营地
    自动寻路( 30, 37)     
    自动寻路( 36, 87)      
    goto lu4 
::lu4::					--去矮人
	等待到指定地图("肯吉罗岛")	
	自动寻路(384, 247)
	自动寻路(384, 245)
::xiYi::
	等待到指定地图("蜥蜴洞穴")
	自动寻路(11, 2)
	自动寻路(12, 2)
	等待到指定地图("肯吉罗岛", 307, 362)	
::HuiAiRen::
	自动寻路(231, 434)	
	等待到指定地图("矮人城镇", 110, 191)	
	goto salebegin 
::xiYi2::
	自动寻路(12, 4)
	if(取当前等级()	>= 目标等级) then goto  HuiYingDi end
	自动寻路(17, 4)
	等待(1000)
	等待空闲()
	if(取当前地图名() == "蜥蜴洞穴")then 
		goto xiYi2 --重新进 
	elseif(取当前地图名() == "蜥蜴洞穴上层第1层")then 
		--查找周围空坐标 遇敌
		outMazeX,outMazeY = 取当前坐标()
		tgtx,tgty = 取周围空地(outMazeX,outMazeY,1)--取当前坐标3格范围内 空地
		自动寻路(tgtx,tgty)
		goto yudi
	end
	goto begin 
::HuiYingDi::
	自动寻路(12, 13,"肯吉罗岛")
	喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
	goto goEnd	--没有切换水晶 让黑一脚本去切换购买
::yudi::		
	等待(1000)
	开始遇敌()		-- 开始自动遇敌	
::scriptstart::		-- 遇敌回补判断
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(string.find(取当前地图名(),"蜥蜴洞穴上层第1层")== nil )then goto begin end	--不是黑龙沼泽 退回
	if(取当前等级()	>= 目标等级) then goto  ting end
	if(string.find(最新系统消息(),"被不可思议的力量送出了")~=nil)then goto  ting2	end	
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	else
		minHp=队友当前血最少值()
		if(minHp~= 88888 and minHp ~= 0 and  minHp < 200)then	
			日志("队友血量过低"..minHp.."，回补！",1)				
			goto ting
		end
	end		
	if(取队伍人数() ~= 队伍人数)then	--掉线 回城
		脚本日志("队友掉线，回城！")
		goto  ting		
	end
	等待(2000)
	goto scriptstart  
	 
::ting::			--停止遇敌 回补
	停止遇敌()      
	等待空闲() 	
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率		
	if(取队伍人数() ~= 队伍人数)then	--掉线 回城
		回城()
		等待(2000)
		goto begin
	end
	--都是容错的
	if(outMazeX == nil or outMazeY==nil) then	
		outMazeX,outMazeY =取迷宫远近坐标(false)	--false 近 true远
		自动寻路(outMazeX,outMazeY)
		等待(2000)
		等待空闲() 	
		if(取当前地图名() == "蜥蜴洞穴上层第2层") then	--反了
			local curx,cury = 取当前坐标()
			local tx,ty=取周围空地(curx,cury,1)--取当前坐标指定距离范围内 空地
			自动寻路(tx,ty)
			自动寻路(curx,cury)			
			等待空闲() 	
			if(取当前地图名() == "蜥蜴洞穴上层第1层") then	
				outMazeX,outMazeY =取迷宫远近坐标(true)	--false 近 true远
				自动寻路(outMazeX,outMazeY)				
				等待空闲() 	
			end
		end
	else
		自动寻路(outMazeX,outMazeY)
	end
	等待到指定地图("蜥蜴洞穴")
	自动寻路(12,4)
	自动寻路(12,2)
	goto dao1 
::dao1::
	自动寻路(231, 434)		
	等待到指定地图("矮人城镇", 110, 191)
::salebegin::			--卖和回补
	自动寻路(121, 111)
	自动寻路(121, 109)
	自动寻路(121, 111)
	卖(1, 卖店物品列表)	
	等待(15000)
	自动寻路(163, 94)
	自动寻路(163, 95)		
	自动寻路(163, 94)
	自动寻路(163, 95)
	自动寻路(163, 94)
	等待(4000)
	回复(2)		-- 恢复人宠
	等待(16000)
::chufa::			--去练级点
	自动寻路(110, 189)		
	自动寻路( 110, 191)	
	等待到指定地图("肯吉罗岛", 231, 434)	
	自动寻路(307, 362)
	goto xiYi2 
	
::ting2::	
	停止遇敌()	
	清除系统消息()	
	等待到指定地图("蜥蜴洞穴")		
	自动寻路(14,4)	
	自动寻路(17,4)	
	goto yudi 
::goEnd::
	return
end


function 黑一练级(目标等级)
	日志("黑一练级",1)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")
	outMazeX=nil	--蜥蜴和黑一 练级时 记录迷宫坐标
	outMazeY=nil
	是否到达过龙顶=false
	水晶名称="水火的水晶（5：5）"
	local curLv=取当前等级()
	--营地任务()
::begin::
	停止遇敌()      
	等待空闲() 	
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	

	if(取当前等级()	>= 目标等级) then 
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	elseif (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif (string.find(当前地图名,"黑龙沼泽")~= nil )then goto yudi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(取当前地图编号() ==  1112)then 回城() goto begin 
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "商店")then goto yingDiShangDian
	elseif(当前地图名 ==  "银行")then goto yingDiYinHang
	elseif(当前地图名 ==  "工房")then goto lu2
	elseif(当前地图名 ==  "肯吉罗岛")then goto kenDaoPanDuan end
	回城()
	等待(1000)
	goto begin
::yingDiShangDian::
	营地商店检测水晶()
	自动寻路(0,14,"圣骑士营地")	
	goto begin
::yingDiYinHang::
	if(人物("金币") > 950000)then
		营地存取金币(-300000)		--留30万
	elseif(人物("金币") <50000)then
		营地存取金币(-300000,"取")	--取出后 身上总30万
	end
	自动寻路(3,23,"圣骑士营地")	
	goto begin
::kenDaoPanDuan::
	if(目标是否可达(232,439) == false) then --营地这边岛 去黑龙
		goto lu4
	end
	--矮人这边 回营地去黑一		
	自动寻路(307, 362,"蜥蜴洞穴")
	自动寻路(12, 12)
	自动寻路(12, 13,"肯吉罗岛")
	等待(1000)
	等待空闲()
	goto lu4

::quYingDi::
	设置("移动速度",走路加速值)
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)
	common.supplyCastle()
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin
::StartBegin::
	喊话("脚本启动等待",06,0,0)
	等待(1000)
	自动寻路(9,15)
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标("营地","医院")
	end
	if(取当前等级()	>= 目标等级) then 
		--下一个不需要登出 直接返回
		return
	end	
	喊话("美特斯邦威  飞一般滴感觉",06,0,0)	
	goto xue	
--	自动寻路(1,20)   
--    自动寻路(0,20)      
 --   goto lu1 

::lu1::
    等待到指定地图("圣骑士营地",95,72)
::lu1a::   
	自动寻路( 87, 72)      
	goto lu2 
::lu2::
	--等待到指定地图("工房",30,37)
	等待到指定地图("工房")
	自动寻路(21,22)
	自动寻路(20,22)
	自动寻路(20,24)
	自动寻路(21,24)      
	等待(2000)
	goto sale 

::sale::      
	卖(0, 卖店物品列表)	
	等待(15000)
	goto lu3 
::lu3::      
	等待到指定地图("工房",21,24)    
	自动寻路( 30, 37)
	等待到指定地图("圣骑士营地",87,72)    
	自动寻路( 80, 87)
	营地商店检测水晶()
	if(人物("金币") > 950000)then
		营地存取金币(-300000)		--留30万
	elseif(人物("金币") <50000)then
		营地存取金币(-300000,"取")	--取出后 身上总30万
	end
	if(取当前地图名() == "商店")then
		自动寻路(0,14,"圣骑士营地")	
	elseif(取当前地图名() == "银行")then
		自动寻路(3,23,"圣骑士营地")	
	end
	自动寻路(36,87)      
	goto lu4 
::lu4::
	等待到指定地图("肯吉罗岛")	  
	自动寻路(424, 344)        
	自动寻路(424, 345,"黑龙沼泽1区")

::yudi::
	outMazeX,outMazeY = 取当前坐标()
	目标楼层="黑龙沼泽1区"
	-- curLv=取当前等级()
	-- if(curLv > 110) then	--1层加3级 		
		-- 目标楼层="黑龙沼泽"..(math.ceil(curLv-113)).."区"
	-- end
-- ::dstFloor::
	-- while true do 
		-- 当前地图名=取当前地图名()
		-- if(string.find(当前地图名,目标楼层)~=nil)then break	end
		-- if (string.find(当前地图名,"黑龙沼泽")== nil )then goto begin end	--不是黑龙沼泽 退回
		-- if(当前地图名 == "黑龙沼泽")then
			-- 是否到达过龙顶=true
			-- 移动到目标附近(11,17,1)	
			-- 自动寻路(11,17)
			-- break	
		-- end
		-- 自动迷宫(1)
	-- end
	curx,cury = 取当前坐标()
	tgtx,tgty = 取周围空地(curx,cury,3)--取当前坐标3格范围内 空地
	自动寻路(tgtx,tgty)
	等待(1000)
	开始遇敌()                 
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(取当前等级()	>= 目标等级) then goto  ting end
	if(string.find(取当前地图名(),"黑龙沼泽")== nil )then goto begin end	--不是黑龙沼泽 退回
	if(string.find(最新系统消息(),"被不可思议的力量送出了")~=nil)then goto  ting2	end	
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	else
		minHp=队友当前血最少值()
		if(minHp~= 88888 and minHp ~= 0 and  minHp < 200)then	
			日志("队友血量过低"..minHp.."，回补！",1)				
			goto ting
		end
	end		
	if(取队伍人数() < 3)then			--队友掉线-人数太少 登出回城 
		脚本日志("队友掉线，回补！")
		goto ting		
	end
	等待(2000)
	goto scriptstart  
::ting2::	
	停止遇敌()	
	清除系统消息()	
	goto lu4 
::ting::
	停止遇敌()      
	等待空闲() 	
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率
::maze::
	--都是容错的
	if(目标楼层 ~= "黑龙沼泽1区")then
		if(是否到达过龙顶==true)then --取最远迷宫
			while true do
				if(取当前地图名() == "肯吉罗岛") then break end
				if(取当前地图名() == "黑龙沼泽") then 
					移动到目标附近(11,17,1)	
					自动寻路(11,17)				
				end
				--血量太低，又没蓝  直接登出回补
				if(队友当前血最少值() ~= 88888  and  队友当前血最少值() < 200)then	
					日志("队友血量过低，登出回补！")
					等待空闲() 	
					回城()
					等待(2000)
					goto begin
				end
				自动迷宫(0)
			end
		else
			if (string.find(当前地图名,"黑龙沼泽")== nil )then goto begin end	--不是黑龙沼泽 退回
			自动迷宫(0,"",0)
			while true do
				if(取当前地图名() == "肯吉罗岛") then break end
				if(取当前地图名() == "黑龙沼泽") then 
					移动到目标附近(11,17,1)	
					自动寻路(11,17)				
				end
				--血量太低，又没蓝  直接登出回补
				if(队友当前血最少值() ~= 88888  and  队友当前血最少值() < 200)then	
					日志("队友血量过低，登出回补！")
					等待空闲() 	
					回城()
					等待(2000)
					goto begin
				end				
				自动迷宫(0)
			end
		end
	else
		if(outMazeX == nil or outMazeY==nil) then	
			goto outHeiYiMaze
		else
			自动寻路(outMazeX,outMazeY)
		end
	end	
::outHeiYiMaze::
	tryNum=0
	while true do 
		if(取当前地图名() == "肯吉罗岛")then goto kenDao end
		if (string.find(当前地图名,"黑龙沼泽")== nil )then goto begin end	--不是黑龙沼泽 退回
		自动迷宫(1,"",0)	--1下载地图 过滤点 0取近距离出口/1远距离出口
		等待空闲()
		if(取当前地图名() == "黑龙沼泽2区") then	--反了
			local curx,cury = 取当前坐标()
			local tx,ty=取周围空地(curx,cury,1)--取当前坐标指定距离范围内 空地
			自动寻路(tx,ty)
			自动寻路(curx,cury)			
			等待空闲() 	
			if(取当前地图名() == "黑龙沼泽1区") then	
				自动迷宫(1,"",1)	
				等待空闲() 	
			end
		end
		if(取当前地图名() == "肯吉罗岛") then	
			goto kenDao
		end
		tryNum=tryNum+1
		if(tryNum >= 3)then 
			回城()
			goto begin
		end
	end
::kenDao::	
	等待空闲() 	
	if(取当前地图名() == "肯吉罗岛")then
		自动寻路(551, 332,"圣骑士营地")	
		goto quYiYuan
	elseif(取当前地图名() ~= "黑龙沼泽1区" and 取当前地图名() ~= "黑龙沼泽2区") then	
		--不知道在哪 登出回城
		回城()
	end
	goto begin
::quYiYuan::
	自动寻路( 94, 72)
	自动寻路( 95, 72)
	goto lu6 
::lu6::
	等待到指定地图("医院", 0, 20)     
	goto begin
::xue::
	自动寻路(14,20)
	自动寻路(18,16)
	自动寻路(18,15)
	自动寻路(17,15)
	自动寻路(19,15)
	自动寻路(18,15)     
	回复(0)			-- 转向北边恢复人宠血魔      
	等待(15000)                   --等待X秒等候队友反应 
	if(宠物("健康") > 0) then	
		自动寻路(6,7)
		自动寻路(8,7)
		自动寻路(6,7)
		转向坐标(7,6)
		等待服务器返回()
		对话选择(-1,6)		
	end
	自动寻路(1,20)   
    自动寻路(0,20)      
    goto lu1 

::goEnd::
	return
end



function 旧日练级(目标等级)
	日志("旧日练级",1)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")	
	水晶名称="地水的水晶（5：5）"
	outMazeX=nil	--练级时 记录迷宫坐标
	outMazeY=nil
::begin::
	停止遇敌()	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	--营地任务()
	if(取当前等级()	>= 目标等级) then 
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd
	elseif (string.find(当前地图名,"旧日迷宫")~= nil )then goto yudi
	elseif (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 	
	elseif(当前地图名 ==  "圣骑士营地")then goto quMiGong
	elseif(当前地图名 ==  "旧日之地")then goto jiuRiZhiDi
	elseif(当前地图名 ==  "迷宫入口")then goto StartBegin
	elseif(当前地图名 ==  "商店")then goto yingDiShangDian
	elseif(当前地图名 ==  "银行")then goto yingDiYinHang end	
	回城()
	等待(1000)
	goto begin
::yingDiShangDian::
	营地商店检测水晶()
	自动寻路(0,14,"圣骑士营地")	
	goto begin
::yingDiYinHang::
	if(人物("金币") > 950000)then
		营地存取金币(-300000)		--留30万
	elseif(人物("金币") <50000)then
		营地存取金币(-300000,"取")	--取出后 身上总30万
	end
	自动寻路(3,23,"圣骑士营地")	
	goto begin

::quYingDi::
	设置("移动速度",走路加速值)
	if(人物("金币") <50000)then
		common.gotoBankTalkNpc()
		银行("取钱",-300000)	--取出后 身上总30万
	end
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)	
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin
::quMiGong::	
	if(取物品数量("战斗号角") < 1)then
		自动寻路(116,69,"总部1楼")
		自动寻路(86,50)
		对话选是(2)
		自动寻路(4,47,"圣骑士营地")		
	end	
	自动寻路(116,81)
	自动寻路(119,81)
	转向(2)
	等待服务器返回()
	对话选择("1", "", "")	
	对话选择("1", "", "")	
	等待(2000)
	等待空闲()
::jiuRiZhiDi::
	if(取当前地图名() ~= "旧日之地" ) then		
		goto begin
	end
	自动寻路(45,47)	
	转向(0, "")
	等待服务器返回()
	对话选择("1", "", "")	
	对话选择("1", "", "")
	等待空闲()
	goto mazeEntrance
::mazeEntrance::
	if(取当前地图名() ~= "迷宫入口" ) then
		goto begin
	end
	自动寻路(8,8)
	goto StartBegin
::StartBegin::
	喊话("脚本启动等待",06,0,0)	
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标("旧日","迷宫入口")
	end
	if(取当前等级()	>= 目标等级) then 
		--下一个不需要登出 直接返回
		return
	end	
	喊话("美特斯邦威  飞一般滴感觉",06,0,0)	
	goto jinMiGong	
::jinMiGong::	
	自动寻路(8,6)	
	自动寻路(9,5)
	等待到指定地图("旧日迷宫第1层")	
	goto yudi	

::yudi::
	outMazeX,outMazeY = 取当前坐标()
	tgtx,tgty = 取周围空地(outMazeX,outMazeY,1)--取当前坐标3格范围内 空地
	自动寻路(tgtx,tgty)
	等待(1000)
	开始遇敌()                 
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(取当前等级()	>= 目标等级) then goto  ting end
	if(string.find(取当前地图名(),"旧日迷宫第1层")== nil )then goto begin end
	if(string.find(最新系统消息(),"被不可思议的力量送出了")~=nil)then goto  ting2	end	
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	else
		minHp=队友当前血最少值()
		if(minHp~= 88888 and minHp ~= 0 and  minHp < 200)then	
			日志("队友血量过低"..minHp.."，回补！",1)				
			goto ting
		end
	end		
	if(取队伍人数() < 3)then			--队友掉线-人数太少 登出回城 
		脚本日志("队友掉线，回补！")
		goto ting		
	end
	等待(2000)
	goto scriptstart  
::ting2::	
	停止遇敌()	
	清除系统消息()	
	goto jinMiGong 
::ting::
	停止遇敌()      
	等待空闲() 	
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率
	回城()
	goto begin
::goEnd::
	return
end
function 龙顶练级(目标等级)  
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")
	outMazeX=nil	--蜥蜴和黑一 练级时 记录迷宫坐标
	outMazeY=nil
	是否到达过龙顶=false
	水晶名称="水火的水晶（5：5）"	
	日志("龙顶练级",1)
	设置个人简介("玩家称号",目标等级)
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local mapIndex = 取当前地图编号()
	local x,y=取当前坐标()		
	if (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif (string.find(当前地图名,"黑龙沼泽")~= nil )then goto yudi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "商店")then goto yingDiShangDian
	elseif(当前地图名 ==  "银行" and mapIndex == 59548)then goto aiDaoBank
	elseif(当前地图名 ==  "银行" and mapIndex == 1121)then goto faLanBank
	elseif(当前地图名 ==  "银行" and mapIndex == 44698)then goto yingDiYinHang
	elseif(当前地图名 ==  "工房")then goto lu2
	elseif(当前地图名 ==  "肯吉罗岛")then goto kenDaoPanDuan end
	回城()
	等待(1000)
	goto begin
::faLanBank::
	自动寻路(11,8)
	面向("东")
	等待服务器返回()
	if(人物("金币") > 950000)then
		营地存取金币(-300000)		--留30万
	elseif(人物("金币") <50000)then
		营地存取金币(-300000,"取")	--取出后 身上总30万
	end
	回城()
	goto begin
::aiDaoBank::
	自动寻路(49,30)
	面向("东")
	等待服务器返回()
	if(人物("金币") > 950000)then
		营地存取金币(-300000)		--留30万
	elseif(人物("金币") <50000)then
		营地存取金币(-300000,"取")	--取出后 身上总30万
	end
	回城()
	goto begin
::yingDiShangDian::
	营地商店检测水晶()
	自动寻路(0,14,"圣骑士营地")	
	goto begin
::yingDiYinHang::
	if(人物("金币") > 950000)then
		营地存取金币(-300000)		--留30万
	elseif(人物("金币") <50000)then
		营地存取金币(-300000,"取")	--取出后 身上总30万
	end
	自动寻路(3,23,"圣骑士营地")	
	goto begin
::kenDaoPanDuan::
	if(目标是否可达(232,439) == false) then --营地这边岛 去黑龙
		goto lu4
	end
	--矮人这边 回营地去黑一		
	自动寻路(307, 362,"蜥蜴洞穴")
	自动寻路(12, 12)
	自动寻路(12, 13,"肯吉罗岛")
	等待(1000)
	等待空闲()
	goto lu4

::quYingDi::
	设置("移动速度",走路加速值)
	common.checkHealth()
	common.checkCrystal(水晶名称)
	common.supplyCastle()
	common.sellCastle()		
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin
::StartBegin::
	喊话("脚本启动等待",06,0,0)
	等待(1000)
	自动寻路(9,15)
	if(取当前地图名() ~= "医院")then
		goto begin
	end
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		common.makeTeam(队伍人数,队员列表)
	else
		喊话("美特斯邦威  飞一般滴感觉",06,0,0)	
		goto xue	
	end	
	goto StartBegin
::lu1::
    等待到指定地图("圣骑士营地",95,72)
::lu1a::   
	自动寻路( 87, 72)      
	goto lu2 
::lu2::
	--等待到指定地图("工房",30,37)
	等待到指定地图("工房")
	自动寻路(21,22)
	自动寻路(20,22)
	自动寻路(20,24)
	自动寻路(21,24)      
	等待(2000)
	goto sale 

::sale::      
	卖(0, 卖店物品列表)	
	等待(15000)
	goto lu3 
::lu3::      
	等待到指定地图("工房",21,24)    
	自动寻路( 30, 37)
	等待到指定地图("圣骑士营地",87,72)    
	自动寻路( 80, 87)
	营地商店检测水晶()
	if(人物("金币") > 950000)then
		营地存取金币(-300000)		--留30万
	elseif(人物("金币") <50000)then
		营地存取金币(-300000,"取")	--取出后 身上总30万
	end
	if(取当前地图名() == "商店")then
		自动寻路(0,14,"圣骑士营地")	
	elseif(取当前地图名() == "银行")then
		自动寻路(3,23,"圣骑士营地")	
	end
	自动寻路(36,87)      
	goto lu4 
::lu4::
	等待到指定地图("肯吉罗岛")	  
	自动寻路(424, 344)        
	自动寻路(424, 345)
	等待(1000)
	等待空闲() 	
::yudi::
	if(string.find(当前地图名,"黑龙沼泽")== nil )then
		goto begin
	end
	--增加一层判断 防止重启脚本一直循环死
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end	
	if( (人物("健康") > 0 or 人物("灵魂") > 0)  and 是否空闲中())then
		回城()
		goto begin
	end
	if(取队伍人数() < 3)then			--队友掉线-人数太少 登出回城 
		脚本日志("队友掉线，回补！")
		goto ting		
	end
::dstFloor::
	while true do 
		当前地图名=取当前地图名()		
		if(string.find(当前地图名,"黑龙沼泽")== nil )then goto begin end	--不是黑龙沼泽 退回
		if(当前地图名 == "黑龙沼泽")then			
			移动到目标附近(11,17,1)	
			自动寻路(11,17)
			等待(2000)
			等待空闲()
			if(取当前地图名()== "黑龙沼泽")then	--还是黑龙沼泽 说明迷宫刷新 稍等会
				goto dstFloor
			end
			break	
		end
		if(队伍("人数")<2)then		--爬楼中途 增加人数判断
			回城()
			goto begin
		end
		自动迷宫(1)
	end
	outMazeX,outMazeY = 取当前坐标()	
	curx,cury = 取当前坐标()
	tgtx,tgty = 取周围空地(curx,cury,1)--取当前坐标3格范围内 空地
	自动寻路(tgtx,tgty)
	等待(1000)
	开始遇敌()                 
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end	
	if(string.find(当前地图名,"黑龙沼泽")== nil)then	goto begin end
	if(string.find(最新系统消息(),"被不可思议的力量送出了")~=nil)then goto  ting2	end	
	if(string.find(最新系统消息(),"你感觉到一股不可思议的力量")~=nil)then goto  ting3	end	
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	end		
	if( (人物("健康") > 0 or 人物("灵魂") > 0)  and 是否空闲中())then
		回城()
		goto begin
	end
	if(取队伍人数() < 3)then			--队友掉线-人数太少 登出回城 
		脚本日志("队友掉线，回补！")
		goto ting		
	end
	等待(2000)
	goto scriptstart  
::ting2::	
	停止遇敌()	
	清除系统消息()	
	goto lu4 
::ting3::
	停止遇敌()	
	清除系统消息()
	自动寻路(outMazeX,outMazeY)	--沼泽坐标
	等待(3000)		--这个是等指定时间
	等待空闲()		--这个是等待切图或战斗  状态是正常后，才会退出当前等待
	if(取当前地图名() == "黑龙沼泽")then
		日志("呼哈，等待迷宫刷新",1)
		等待(170000)		--等待迷宫刷新
		goto dstFloor
	end
	goto begin		--不知道在哪 就begin吧
::ting::
	停止遇敌()      
	等待空闲() 	
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率
	回城()
	等待(2000)
	goto begin
::quYiYuan::
	自动寻路( 94, 72)
	自动寻路( 95, 72)
	goto lu6 
::lu6::
	等待到指定地图("医院", 0, 20)     
	goto begin
::xue::
	自动寻路(14,20)
	自动寻路(18,16)
	自动寻路(18,15)
	自动寻路(17,15)
	自动寻路(19,15)
	自动寻路(18,15)     
	回复(0)			-- 转向北边恢复人宠血魔      
	等待(15000)                   --等待X秒等候队友反应 
	if(宠物("健康") > 0) then	
		自动寻路(6,7)
		自动寻路(8,7)
		自动寻路(6,7)
		转向坐标(7,6)
		等待服务器返回()
		对话选择(-1,6)		
	end
	自动寻路(1,20)   
    自动寻路(0,20)      
    goto lu1 
::goEnd::
	return
end
function 半山练级(目标等级)
	日志("半山练级",1)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")	
	水晶名称="火风的水晶（5：5）"
::begin::
	停止遇敌()	
	等待空闲()
	if(人物("金币") < 多少金币去拿钱) then
		日志("人物金币不够，去银行取钱，当前金币【"..人物("金币").."】")
		common.getMoneyFromBank(身上最少金币)
	end
	local 当前地图名 = 取当前地图名()	
	if(取当前等级()	>= 目标等级) then 
		喊话("当前等级【"..取当前等级().."】已达到目标等级【"..目标等级.."】切换脚本",2,3,5)
		goto goEnd	
	elseif(当前地图名 =="艾尔莎岛" )then goto toIsland
	elseif(当前地图名 ==  "里谢里雅堡")then goto toIsland 
	elseif(当前地图名 ==  "法兰城")then goto toIsland 	
	elseif(当前地图名 ==  "小岛")then goto island
	elseif(当前地图名 ==  "图书室")then goto library
	elseif(当前地图名 ==  "半山腰")then goto mountainOfHalf
	elseif(string.find(当前地图名,"通往山顶的路")~= nil)then goto crossMaze
	end	
	回城()
	等待(1000)
	goto begin
::toIsland::
	if(取物品数量("阿斯提亚锥形水晶") > 0)then
		使用物品("阿斯提亚锥形水晶")
		等待(2000)
		goto island
	end
	设置("移动速度",走路加速值)
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)
	if(半山西门)then
		goto falanw
	else
		common.toCastle("f2")
		自动寻路(0,74,"图书室")
		goto library
	end
	goto begin
::library::					--图书室
	扔("锄头")
	自动寻路(27,16)
	设置("移动速度",走路还原值)
	对话选是(27,15)
	goto begin
::falanw::	--西门
	common.outFaLan("w")
	自动寻路(396,168)
	自动寻路(397,168)
	对话选是(398,168)
	goto begin
::island::
	if(取当前地图名() ~= "小岛")then
		goto begin
	end
	if(人物("坐标") == "64,45")then
		if(队伍("人数") < 队伍人数)then	--被迷宫弹出来 人数错误 回城
			回城()
			goto begin
		end
		goto toMaze
	end
	自动寻路(66, 97)
	--组队
::makeTeam::
	喊话("脚本启动等待",06,0,0)	
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		common.makeTeam(5,队员列表)
	end
	等待(3000)		--防止队员判断队长错误 又离队
	if(取当前等级()	>= 目标等级) then 
		--下一个不需要登出 直接返回
		return
	end	
	if(队伍("人数") == 队伍人数)then	
		goto toMaze	
	end
	goto island
::toMaze::	
	自动寻路(65, 46)
	自动寻路(64,45,"通往山顶的路100M")
	goto crossMaze
::crossMaze::
	自动穿越迷宫("半山腰")
	if(取当前地图名()=="半山腰")then
		goto mountainOfHalf
	end
	if(string.find(当前地图名,"通往山顶的路")== nil)then
		goto begin
	end
	等待(5000)
	等待空闲()
	goto crossMaze
::mountainOfHalf::
	if(取当前地图名() ~= "半山腰")then
		goto begin
	end
	自动寻路(60, 65) 
	等待(1000)
	开始遇敌()                 
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(取当前等级()	>= 目标等级) then goto  ting end
	if(取当前地图名() ~= "半山腰")then goto begin end	
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	else
		minHp=队友当前血最少值()
		if(minHp~= 88888 and minHp ~= 0 and  minHp < 200)then	
			日志("队友血量过低"..minHp.."，回补！",1)				
			goto ting
		end
	end		
	if(取队伍人数() < 3)then			--队友掉线-人数太少 登出回城 
		脚本日志("队友掉线，回补！")
		goto ting		
	end
	等待(2000)
	goto scriptstart  
::ting::
	停止遇敌()      
	等待空闲() 	
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率
	回城()
	goto begin
::goEnd::
	return
end
function getTeammateMinLv()
	local minLv=人物("等级")
	for index,teamPlayer in ipairs(队员列表) do			
		local friendCard = 取好友名片(teamPlayer)
		if( friendCard ~= nil)then
			--日志(friendCard.level)
			if(minLv > friendCard.level )then
				minLv=friendCard.level			
			end
		end		
	end	
	return minLv
end
function 取当前等级()
	local avgLevel=人物("等级")
	if(是否练宠==1)then
		avgLevel=宠物("等级")--取队伍宠物平均等级()		
	else
		avgLevel = getTeammateMinLv()
		if(avgLevel > 180 or avgLevel == 0)then
			avgLevel = 人物("等级")	
		end				
	end
	return tonumber(avgLevel)
end
function 队伍当前人物最低等级()
	teamPlayers = 队伍信息()
	local level=88888
	for i,teamPlayer in ipairs(teamPlayers) do
		if(level > teamPlayer.level)then level = teamPlayer.level end
	end
	return level
end
-- function 队伍当前宠物最低等级()
	-- teamPlayers = 队伍信息()
	-- local level=88888
	-- for i,teamPlayer in ipairs(teamPlayers) do
		-- if(level > teamPlayer.level)then level = teamPlayer.level end
	-- end
	-- return level
-- end
--返回当前队伍中 血量最少的值 用来判断是否回城
function 队友当前血最少值()
	teamPlayers = 队伍信息()
	local hpVal=88888
	for i,teamPlayer in ipairs(teamPlayers) do
		if(hpVal > teamPlayer.hp)then hpVal = teamPlayer.hp end
	end
	return hpVal
end


function 输出队员信息()
	if(队员列表~=nil)then
		for i,teamPlayer in ipairs(队员列表) do
			日志("队员-"..teamPlayer,1)
		end
	end
end
function main()    
	--等级切换练级地图	
	while true do
		local avgLevel=取当前等级()			
		if(avgLevel == 0)then
			日志("获取宠物等级失败！",1)
		else
			日志("当前等级:"..avgLevel,1)
		end
		输出队员信息()
        if(avgLevel < 20)then		--森林
			森林练级(20)
		elseif(avgLevel<27)then		--鸡场
			布拉基姆高地练级(27,31,191,"鸡场")			
		elseif(avgLevel<32)then		--龙骨
			布拉基姆高地练级(32,112,203,"龙骨")
		elseif(avgLevel<37)then		--黄金龙骨
			布拉基姆高地练级(37,130, 190,"黄金龙骨")
		elseif(avgLevel<44)then		--洞穴
			洞窟练级(44)
		elseif(avgLevel<50)then		--洞穴
		 	雪塔练级(50,"t49")			--49
		elseif(avgLevel<55)then		--洞穴
		 	雪塔练级(55,"t55")
		-- elseif(avgLevel<60)then		--回廊
			-- 回廊练级(60)
		elseif(avgLevel<60)then		--T59
			雪塔练级(60,"t60")
		elseif(avgLevel<65)then		--T59
			雪塔练级(65,"t65")
		elseif(avgLevel<70)then		--营地
			雪塔练级(70,"t70")
		elseif(avgLevel<75)then		--营地
			雪塔练级(75,"t75")
		elseif(avgLevel<80)then		--营地
			雪塔练级(80,"t79")
		elseif(avgLevel<85)then		--营地
			雪塔练级(85,"t85")
		elseif(avgLevel<71)then		--营地
			营地练级(71)
		elseif(avgLevel<78)then		--蝎子
			蝎子练级(78)
		elseif(avgLevel<85)then		--沙滩
			沙滩练级(85)
		elseif(avgLevel<93)then		--石头
			石头练级(93)
		elseif(avgLevel<103)then	--蜥蜴
			蜥蜴练级(103)
		elseif(avgLevel<115)then	--黑一
			黑一练级(115)
		elseif(avgLevel<135)then	--龙顶 或 旧日
			旧日练级(135)
		-- elseif(avgLevel < 160)then	--龙顶	刷钱 然后声望 然后继续练级	
			-- 龙顶练级(160)
		elseif(avgLevel<160)then	--半山
			半山练级(160)
		end
		喊话("已满级，脚本退出",2,3,5)
		等待(2000)
    end
	--切换脚本("新手任务加入门派.lua")	--判断刷称号
end
main()