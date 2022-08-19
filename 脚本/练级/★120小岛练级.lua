1-160全自动练级

common=require("common")

local 补血值=取脚本界面数据("人补血")
local 补魔值=取脚本界面数据("人补魔")
local 宠补血值=取脚本界面数据("宠补血")
local 宠补魔值=取脚本界面数据("宠补魔")
local 队伍人数=取脚本界面数据("队伍人数")
local 队长名称=取脚本界面数据("队长名称")
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","风依旧￠花依然")--风依旧￠花依然  乱￠逍遥
end
local 设置队员列表=取脚本界面数据("队员列表")
local 队员列表={}
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
local 是否自动购买水晶=false

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

function 半山练级(目标等级)
	日志("小岛练级",1)
	设置个人简介("玩家称号",目标等级)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")	
	水晶名称="火风的水晶（5：5）"
	local isTeamLeader=false
	if(人物("名称",false) == 队长名称)then
		isTeamLeader=true
		日志("当前是队长:"..人物("名称",false),1)
		if(队伍人数==nil or 队伍人数==0)then
			队伍人数 = 用户输入框("队伍人数",5)
		else
			队伍人数=tonumber(队伍人数)
		end
		if(设置队员列表==nil or 设置队员列表=="")then
			设置队员列表 = 用户输入框("练级队员列表，不设置则不判断队员！","")
		end
		if(设置队员列表 ~= nil and string.find(设置队员列表,"|") ~= nil)then
			队员列表=common.luaStringSplit(设置队员列表,"|")
		end
		日志("队伍人数:"..队伍人数,1)		
	else	
		日志("当前是队员:"..人物("名称",false),1)	
		teammateAction()
		return
	end	
::begin::
	停止遇敌()	
	等待空闲()
	if(人物("金币") < 多少金币去拿钱) then
		日志("人物金币不够，去银行取钱，当前金币【"..人物("金币").."】")
		common.getMoneyFromBank(身上最少金币)
	end
	local 当前地图名 = 取当前地图名()	
	if(当前地图名 =="艾尔莎岛" )then goto toIsland
	elseif(当前地图名 ==  "里谢里雅堡")then goto toIsland 
	elseif(当前地图名 ==  "法兰城")then goto toIsland 	
	elseif(当前地图名 ==  "小岛")then goto island
	elseif(当前地图名 ==  "图书室")then goto library
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
	if(队伍("人数") == 队伍人数)then	
		goto toMaze	
	end
	goto island
::toMaze::	
	自动寻路(64,90)
	等待(1000)
	开始遇敌()                 
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(取当前地图名() ~= "小岛")then goto begin end	
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()	
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
function teammateAction()
	日志("半山练级",1)	
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
		common.getMoneyFromBank(多少金币去拿钱)
	end
	common.changeLineFollowLeader(队长名称)	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end	
	当前地图名 = 取当前地图名()		
	if(当前地图名 =="艾尔莎岛" )then goto toIsland
	elseif(当前地图名 ==  "里谢里雅堡")then goto toIsland 
	elseif(当前地图名 ==  "法兰城")then goto toIsland 	
	elseif(当前地图名 ==  "小岛")then goto island
	elseif(当前地图名 ==  "图书室")then goto library
	elseif(当前地图名 ==  "半山腰")then goto scriptstart
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
	if(是否自动购买水晶==1)then common.checkCrystal(水晶名称) end
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
	if(人物("坐标") ~= "65,97")then
		自动寻路(65,97)
		common.checkHealth(医生名称)--一个人 如果受伤 则回城		
		goto begin
	end
	--组队
::makeTeam::	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end		
	common.changeLineFollowLeader(队长名称)	
	等待(2000)
	common.joinTeam(队长名称)
	goto begin   
   
::scriptstart::	
	if(取队伍人数() < 2)then
		goto ting
	end		
	等待(4000)
	goto scriptstart  
	
::ting::
	日志("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率
	等待空闲()
	if(取队伍人数() < 2)then	--掉线 回城
		回城()
		等待(2000)
	end	
	goto begin
::goEnd::
	return

end
半山练级(160)