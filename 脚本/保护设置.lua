--读取界面设置

common=require("common")

starfall={}

starfall.补血值=取脚本界面数据("人补血")
starfall.补魔值=取脚本界面数据("人补魔")
starfall.宠补血值=取脚本界面数据("宠补血")
starfall.宠补魔值=取脚本界面数据("宠补魔")
starfall.队伍人数=取脚本界面数据("队伍人数")
starfall.是否卖石=取脚本界面数据("是否卖石")
starfall.设置队员列表=取脚本界面数据("队员列表")
starfall.队员列表={}
starfall.是否练宠=取脚本界面数据("是否练宠")
starfall.队长名称=取脚本界面数据("队长名称",false)
if(starfall.队长名称==nil or starfall.队长名称=="")then
	starfall.队长名称=用户输入框("请输入队伍名称！","乱￠逍遥")
end
starfall.isTeamLeader=false		--是否队长
if(人物("名称") == starfall.队长名称)then
	starfall.isTeamLeader=true
end
if(starfall.补血值==nil or starfall.补血值==0)then
	starfall.补血值=用户输入框("多少血以下补血", "430")
else
	starfall.补血值=tonumber(starfall.补血值)
end
if(starfall.补魔值==nil or starfall.补魔值==0)then
	starfall.补魔值 = 用户输入框("多少魔以下补魔", "200")
else
	starfall.补魔值=tonumber(starfall.补魔值)
end
if(starfall.宠补血值==nil or starfall.宠补血值==0)then
	starfall.宠补血值 = 用户输入框( "宠多少血以下补血", "50")
else
	starfall.宠补血值=tonumber(starfall.宠补血值)
end
if(starfall.宠补魔值==nil or starfall.宠补魔值==0)then
	starfall.宠补魔值=用户输入框( "宠多少魔以下补魔", "50")
else
	starfall.宠补魔值=tonumber(starfall.宠补魔值)
end
if(starfall.isTeamLeader)then		--队长附加设置
	if(starfall.队伍人数==nil or starfall.队伍人数==0)then
		starfall.队伍人数 = 用户输入框("练级队伍人数，不足则固定点等待！",5)
	else
		starfall.队伍人数=tonumber(starfall.队伍人数)
	end
	if(starfall.设置队员列表==nil or starfall.设置队员列表=="")then
		starfall.设置队员列表 = 用户输入框("练级队员列表，不设置则不判断队员！","")
	end
	if(starfall.设置队员列表 ~= nil and string.find(starfall.设置队员列表,"|") ~= nil)then
		starfall.队员列表=common.luaStringSplit(starfall.设置队员列表,"|")
	end
	if(starfall.是否练宠==nil)then
		starfall.是否练宠 = 用户输入框("是否练宠,是1，否0",1)
	else
		starfall.是否练宠=tonumber(starfall.是否练宠)
	end
	if(starfall.是否卖石==nil or starfall.是否卖石==0)then
		starfall.是否卖石 = 用户输入框("是否卖魔石,是1，否0",1)
	else
		starfall.是否卖石=tonumber(starfall.是否卖石)
	end
end
starfall.是否踢人=false
starfall.目标等级 = 180			--目标等级，切换练级地图时退出判断用
starfall.走路加速值=125			--脚本走路中可以设定移动速度  到达目的地后，再还原值即可
starfall.走路还原值=100			--防止掉线 还原速度
starfall.身上最少金币=100000	--10w
starfall.多少金币去拿钱=10000	--1w

starfall.卖店物品列表="魔石|卡片？|锹型虫的卡片|狮鹫兽的卡片|水蜘蛛的卡片|虎头蜂的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"		--可以增加多个 不影响速度
starfall.医生名称={"星落护士","谢谢惠顾☆"}
starfall.遇敌总次数=0
starfall.练级前经验=0
starfall.练级前时间=os.time() 
function starfall.打印保护设置()
	日志("人补血:"..starfall.补血值)
	日志("人补魔:"..starfall.补魔值)
	日志("宠补血:"..starfall.宠补血值)
	日志("宠补魔:"..starfall.宠补魔值)
	日志("队伍人数:"..starfall.队伍人数)	
	日志("队长名称:"..starfall.队长名称)
	日志("队员列表:"..starfall.设置队员列表)
	日志("是否卖石:"..starfall.是否卖石)	
	日志("是否练宠:"..starfall.是否练宠)
	日志("走路加速值:"..starfall.走路加速值)
	日志("走路还原值:"..starfall.走路还原值)
	日志("身上最少金币:"..starfall.身上最少金币)
	日志("多少金币去拿钱:"..starfall.多少金币去拿钱)
	日志("卖店物品列表:"..starfall.卖店物品列表)
	--日志("医生名称:"..starfall.医生名称)
	日志("练级前经验:"..starfall.练级前经验)
	日志("练级前时间:"..starfall.练级前时间)
	日志("目标等级:"..starfall.目标等级)
end


function starfall.输出预置队员信息()
	if(starfall.队员列表~=nil)then
		for i,teamPlayer in ipairs(starfall.队员列表) do
			日志("队员-"..teamPlayer,1)
		end
	end
end
function starfall.打印队伍信息()
	local teamPlayers = 队伍信息()	
	for i,teamPlayer in ipairs(teamPlayers) do
		日志("队员"..i.."-"..teamPlayer.name.." Lv:"..teamPlayers.level.." "..teamPlayers.hp.."/"..teamPlayers.maxhp,1)
	end	
end
function starfall.队友当前血最少值()
	teamPlayers = 队伍信息()
	local hpVal=88888
	for i,teamPlayer in ipairs(teamPlayers) do
		if(hpVal > teamPlayer.hp)then hpVal = teamPlayer.hp end
	end
	return hpVal
end
--通过名片 获取预置队友中 最低等级
function starfall.getTeammateMinLv(teamPlayers)
	local minLv=人物("等级")
	for index,teamPlayer in ipairs(teamPlayers) do			
		local friendCard = 取好友名片(teamPlayer)
		if( friendCard ~= nil)then
			if(minLv > friendCard.level )then
				minLv=friendCard.level			
			end
		end		
	end	
	return minLv
end
--取队伍中当前最低等级，如果当前是练宠模式，暂时只获取队长宠物等级
function starfall.取当前等级()
	local avgLevel=人物("等级")
	if(starfall.是否练宠==1)then
		avgLevel=宠物("等级")--取队伍宠物平均等级()		
	else
		avgLevel = getTeammateMinLv()
		if(avgLevel > 180 or avgLevel == 0)then
			avgLevel = 人物("等级")	
		end				
	end
	return tonumber(avgLevel)
end
-- 获取预置队友中 最低等级
function starfall.队伍当前人物最低等级()
	teamPlayers = 队伍信息()
	local level=88888
	for i,teamPlayer in ipairs(teamPlayers) do
		if(level > teamPlayer.level)then level = teamPlayer.level end
	end
	return level
end
function starfall.等待队伍人数达标(练级点)				--等待队友	
::begin::	
	while(队伍("人数") < starfall.队伍人数) do			--数量不足 等待
		喊话(练级点 .."练级脚本，来打手人够脚本自动前往【"..练级点.."】++++",2,3,5)	
		if(starfall.是否踢人)then
			common.makeTeam(starfall.队伍人数,starfall.队员列表,5000)		--5秒一轮		nil替换为队员列表，则会进行自动踢人
		else
			common.makeTeam(starfall.队伍人数,nil,5000)						--5秒一轮		nil替换为队员列表，则会进行自动踢人
		end
	end	
	喊话("人数达标，自动前往【"..练级点.."】，请不要离开队伍,谢谢！",2,3,5)
	return 
end
--获取队长的练级等级
function starfall.getLeaderSetLv()
	local 队长名片 = 取好友名片(starfall.队长名称)
	if( 队长名片 ~= nil)then
		return tonumber(队长名片.title)
	end
	日志("队长不在线",1)
	return nil
end

function starfall.checkTargetLevel()
	if(starfall.isTeamLeader)then
		if(protect.取当前等级() >= protect.目标等级)then
		  日志("当前等级已达目标等级，退出森林练级脚本",1)
		  return true
		end
	else
		--获取队长设置的练级目标等级，根据等级切换脚本
		leaderSetLv=getLeaderSetLv()
		if(leaderSetLv ~= nil and leaderSetLv ~= protect.目标等级) then
			日志("队长当前设置练级等级"..leaderSetLv.." 之前目标等级【"..protect.目标等级.."】切换脚本",1)
			return true
		end
	end
	return false
end

return starfall