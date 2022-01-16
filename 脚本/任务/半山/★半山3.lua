★半山3脚本，起点艾尔莎岛登入点，根据提示执行脚本

设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 开启高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 



队长名称=取脚本界面数据("队长名称")
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","风依旧￠花依然")--风依旧￠花依然  乱￠逍遥
end

isTeamLeader=false		--是否队长
if(人物("名称") == 队长名称)then
	isTeamLeader=true
end


common=require("common")

function checkTeammateItem(chatMsg)
	if(chatMsg==nil)then return end
	local teamPlayers = 队伍信息()
	local teammateCount = common.getTableSize(teamPlayers)
	local count=0
::begin::	
	for index,teamPlayer in ipairs(teamPlayers) do
		if(string.find(聊天(50),teamPlayer.name..": "..chatMsg)~=nil)then 
			count=count+1
		end			
	end  
	if(count>=(teammateCount-1))then
		return
	end		
	count=0
	goto begin
	
end

function main()
::begin::
	停止遇敌()	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	mapNum = 取当前地图编号()
	--营地任务()
	if (string.find(当前地图名,"通往山顶的路")~= nil )then goto crossMaze
	elseif (当前地图名 =="艾尔莎岛" )then goto toIsland
	elseif(当前地图名 ==  "里谢里雅堡")then goto toIsland 
	elseif(当前地图名 ==  "法兰城")then goto toIsland 	
	elseif(当前地图名 ==  "小岛")then goto island
	elseif(当前地图名 ==  "图书室")then goto library
	elseif(当前地图名 ==  "圣鸟之巢")then goto birdnest
	elseif(当前地图名 ==  "圣山之巅")then goto mountainPeak
	elseif(当前地图名 ==  "杰诺瓦镇的传送点")then goto jiecun
	elseif(当前地图名 ==  "蒂娜村的传送点")then goto jiecun
	elseif(mapNum ==  57180)then map57180()
	elseif(mapNum ==  57181)then map57181()
	elseif(mapNum ==  57185)then map57185() --打完boss
	end	
	回城()
	等待(1000)
	goto begin
::toIsland::	
	common.checkHealth()
	common.supplyCastle()	
	common.sellCastle()		--默认卖
	if(取物品数量("鸟类大全") > 0)then	
		common.toTeleRoom("杰诺瓦镇")
		goto jiecun			
	end
	if(取物品数量("匆忙写下的笔录") > 0)then	
		common.toCastle("f2")
		移动(0,74,"图书室")		
		goto library		
	end
	if(取物品数量("暗号") > 0)then	
		common.toTeleRoom("杰诺瓦镇")
		goto jiecun			
	end
	common.toTeleRoom("杰诺瓦镇")		
	goto begin
::jiecun::	
	等待到指定地图("杰诺瓦镇的传送点")	
	移动(14, 8)
	移动(14, 6)
	等待到指定地图("村长的家")
	移动(13, 9)
	移动(1, 9)
	等待到指定地图("杰诺瓦镇")
	移动(54, 43)
	移动(54, 35)
	移动(71, 18)
	设置("遇敌全跑",1)
	等待到指定地图("莎莲娜")	
	移动(668,319)	
	对话选是(669,319)
	goto island	
::dina::
	等待到指定地图("蒂娜村的传送点")	
	移动(11, 2,4214)
	移动(7, 1,4213)
	移动(1, 7,4212)
	移动(1, 6,4200)
	移动(43, 62,"莎莲娜")	
	设置("遇敌全跑",1)	
	移动(668,319)	
	对话选是(669,319)
::library::					--图书室
	移动(18,18)
	对话选是(18,19)
	if(取物品数量("鸟类大全") > 0)then	
		common.toTeleRoom("杰诺瓦镇")
		goto jiecun			
	end
	goto begin
::island::
	if(取当前地图名() ~= "小岛")then
		goto begin
	end
	设置("遇敌全跑",0)
	if(isTeamLeader)then
		leaderAction()		
	else
		teammateAction()
	end	
	
	goto crossMaze
::crossMaze::
	自动穿越迷宫("圣鸟之巢")
	if(取当前地图名()=="圣鸟之巢")then
		goto birdnest
	end
	等待(1000)
	goto crossMaze
::birdnest::
	if(取当前地图名() ~= "圣鸟之巢")then
		goto begin
	end
	if(isTeamLeader)then
		leaderAction()		
	else
		teammateAction()
	end	
	-- 移动(14,12)
	-- 对话选是(14,11)
	-- 喊话("我是来送鳗鱼饭的",2,3,5)
	-- 等待服务器返回()
	-- 对话选择(1,0)
	-- 等待(2000)		
	goto begin
::mountainPeak::
	if(取当前地图名() ~= "圣山之巅")then
		goto begin
	end
	if(isTeamLeader)then
		leaderAction()		
	else
		teammateAction()
	end	
	-- 移动(23,23)
	-- 对话选是(23,22)
	-- if(取当前地图名() == "法兰城")then
		-- 日志("任务结束，可以去半山练级了",1)
	-- end
	-- 日志("任务完成，但没有传送至法兰城，请手动查看问题",1)
end
	
function map57185()
	移动(23,23)
	对话选是(23,22)
end
--队长
function leaderAction()
::begin::	
	等待空闲()	
	local 当前地图名 = 取当前地图名()
	mapNum = 取当前地图编号()
	if (string.find(当前地图名,"达尔文海")~= nil )then goto crossMaze	
	elseif(当前地图名 ==  "小岛")then goto island
	elseif(当前地图名 ==  "圣鸟之巢")then goto anhao	
	elseif(当前地图名 ==  "圣山之巅")then goto boss	
	elseif(mapNum ==  57180)then map57180()
	elseif(mapNum ==  57181)then map57181()
	elseif(mapNum ==  57185)then map57185()
	end		
	等待(1000)
	goto begin
::island::
	if(取当前地图名() ~= "小岛")then
		goto begin
	end
	if(队伍("人数") ~= 5)then
		移动(66, 97)
		common.makeTeam(5)
	end	
	if(取物品数量("暗号") > 0)then		
		checkTeammateItem("已拿到暗号")
		移动(54,80)
		移动(56,80)
		移动(54,80)
		移动(56,80)
		if(取物品数量("星鳗饭团") < 1)then
			对话选是(55,81)
		end
		if(取物品数量("星鳗饭团") > 0)then
			checkTeammateItem("已拿到星鳗饭团")
		end		
		goto toMaze
	else
		if(取物品数量("鸟类大全") > 0)then
			移动(78, 88)
			移动(78, 87)
			移动(78, 88)
			移动(78, 87)
			移动(78, 88)		
			对话选是(79, 88)	--暗号
			if(取物品数量("暗号") > 0)then
				checkTeammateItem("已拿到暗号")
			end			
		end	
	end	
	goto begin
::toMaze::
	移动(64,45,"通往山顶的路100M")
	goto crossMaze
::crossMaze::
	自动穿越迷宫("圣鸟之巢")
	if(取当前地图名()=="圣鸟之巢")then
		goto anhao
	end
	等待(1000)
	goto crossMaze
::anhao::
	if(取当前地图名() ~= "圣鸟之巢")then
		goto begin
	end
	移动(13, 11)
	移动(13, 10)
	移动(13, 11)
	移动(13, 10)
	移动(13, 11)
	对话选是(14,11)
	喊话("我是来送鳗鱼饭的",2,3,5)
	等待服务器返回()
	对话选择(1,0)
	等待(2000)		
	goto begin
::boss::
	if(取当前地图名() ~= "圣山之巅")then
		goto begin
	end
	移动(32,27)
	common.makeTeam(5)
	移动(23,23)
	对话选是(23,22)
	goto begin
	
end
function teammateAction()
::begin::	
	等待空闲()	
	mapNum = 取当前地图编号()
	local 当前地图名 = 取当前地图名()
	if(当前地图名 ==  "小岛")then goto island
	elseif(当前地图名 ==  "圣鸟之巢")then goto anhao	
	elseif(当前地图名 ==  "圣山之巅")then goto boss	
	elseif(mapNum ==  57180)then map57180()
	elseif(mapNum ==  57181)then map57181()
	elseif(mapNum ==  57185)then map57185()
	end		
	等待(3000)
	goto begin
::island::
	if(取当前地图名() ~= "小岛")then
		goto begin
	end	
	
	
	if(是否目标附近(79, 88))then
		if(取物品数量("暗号") > 0)then
			喊话("已拿到暗号",2,3,5)
		else
			对话选是(79, 88)
		end		
	end
	if(是否目标附近(55, 81))then	
		if(取物品数量("星鳗饭团") < 1)then
			对话选是(55, 81)	
		else			
			喊话("已拿到星鳗饭团",2,3,5)	
		end
	end	
	if(取队伍人数() < 2)then	
		common.joinTeam(队长名称)
	end		
	goto begin
::anhao::
	if(取当前地图名() ~= "圣鸟之巢")then
		goto begin
	end
	if(是否目标附近(14,11))then
		对话选是(14,11)
		喊话("我是来送鳗鱼饭的",2,3,5)
		等待服务器返回()
		对话选择(1,0)
		等待(2000)		
	end	
	goto begin
::boss::
	if(取当前地图名() ~= "圣山之巅")then
		goto begin
	end
	if(取队伍人数() < 2)then	
		common.joinTeam(队长名称)
	end	
	if(是否目标附近(23,22))then		
		对话选是(23,22)		
	end	
	goto begin
end
main()