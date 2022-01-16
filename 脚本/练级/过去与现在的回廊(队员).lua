--定居艾尔莎岛，只允许交换过名片的队员加入，组队人员请先交换好名片，并保证助手名片表有显示后再执行

common=require("common")

补血值=取脚本界面数据("人补血")
补魔值=取脚本界面数据("人补魔")
宠补血值=取脚本界面数据("人补血")
宠补魔值=取脚本界面数据("人补血")


是否练宠=用户输入框("是否练宠,是1，否0",1)
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


队长名称=取脚本界面数据("队长名称")
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","乱￠逍遥")--风依旧￠花依然  乱￠逍遥
end
跟随队长换线=用户输入框("是否跟随队长换线,是1，否0！","1")
遇敌总次数=0
练级前经验=0
练级前时间=os.time()
走路加速值=125	--脚本走路中可以设定移动速度  到达目的地后，再还原值即可
走路还原值=100	--防止掉线 还原速度
卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"		--可以增加多个 不影响速度
水晶名称="水火的水晶（5：5）"
满金币存银行数=950000	--95万存银行
身上最少金币数=50000	--身上最少5万  判断会用这个判断 取得话 会用这个的2倍取 防止来回判断
喊话(队长名称,2,3,5)
医生名称={"星落护士","谢谢惠顾☆"}

--获取队长当前服务器线路
function getLeaderServerLine()
	local 队长名片 = 取好友名片(队长名称)
	if( 队长名片 ~= nil)then
		return 队长名片.server
	end
	return 0
end

function followLeader()
	local leaderServerLine = getLeaderServerLine()
	if(leaderServerLine==0)then
		return
	end
	local curLine=人物("几线")
	if(curLine == 0)then
		return
	end
	if(leaderServerLine ~= curLine)then
		切换登录信息("",0,leaderServerLine,0) --0默认 
		登出服务器()	
		登录游戏()	--如果有自动登录 这步不需要
	end
end

function 判断队长()
	local teamPlayers=队伍信息()
	local count=0
	for i,teammate in ipairs(teamPlayers)do
		count=count+1
		--日志(i..teammate.name .."队长名称："..队长名称)
		if( i==1 and teammate.name ~= 队长名称) then	
			--日志(i..teammate.name .."!- 队长名称："..队长名称)
			return false
		else
			break
		end
	end
	if count ==0 then
		return false
	else
		return true
	end
end

function waitAddTeam()
	local tryNum=0
::begin::	
	加入队伍(队长名称)
	if(取队伍人数()>1)then
		if(判断队长()==true) then
			return
		else
			离开队伍()
		end		
	end
	if(是否空闲中()==false)then
		return
	end
	if(tryNum>10)then
		return
	end
	if (取当前地图名()~="过去与现在的回廊" )then	
		return
	end
	goto begin
end
function 回廊练级()
	设置("自动加血",0)	
	练级前经验=人物("经验")
	followLeader()
::begin::	
	等待空闲()
	common.checkHealth(医生名称)
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	if (当前地图名=="艾尔莎岛" )then	
		移动(140,105)				
		转向(1)
		等待服务器返回()
		对话选择(4,0)
		等待到指定地图("里谢里雅堡")
		goto liBao
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao	
	elseif (当前地图名=="过去与现在的回廊" )then	
		goto addTeam		
	end
	回城()
	goto begin
::liBao::
	移动(34, 89)	
	回复(1)		
	common.checkHealth()
	common.toCastle()
	移动(30, 79)
	卖(0,卖店物品列表)	
	移动(52, 72)	
	对话选是(2)	
::addTeam::
	等待到指定地图("过去与现在的回廊")	
	if(取队伍人数() > 1)then
		if(判断队长()==true) then
			goto yudi
		else
			离开队伍()
		end				
	end	
	移动(10, 20)
	followLeader()
	waitAddTeam()
	goto begin
::yudi::		
	if(人物("血") < 补血值) then goto  ting end
	if(人物("魔") < 补魔值) then goto  ting end
	if(宠物("血") < 宠补血值) then goto  ting end
	if(宠物("魔") < 宠补魔值) then goto  ting end	
	if(取队伍人数() < 2)then
		goto ting
	end
	common.checkHealth()
	followLeader()
	等待(1000)	
	goto yudi  
::ting::	
	回城()
	等待(2000)
	goto begin 
end

回廊练级(65)