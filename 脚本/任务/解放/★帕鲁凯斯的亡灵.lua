★队伍人数小于2逃跑

common=require("common")

设置("timer",0)
local 队长名称=用户输入框("队长名称","￠夏梦￡雨￠")

日志("队长名称:"..队长名称,1)

local 是否队长=false		--是否队长
if(人物("名称") == 队长名称)then
	是否队长=true
end
local 队伍人数=用户下拉框("队伍人数",{1,2,3,4,5})
local 卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶|口袋龙的卡片|地狱看门犬的卡片"		--可以增加多个 不影响速度


清除系统消息()
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
--魔鬼克星
function checkTitle(dstTitle)
	local player=人物信息()
	for i,title in ipairs(player.titles) do
		if(title.name == dstTitle)then
			return true
		end
	end
	return false
end


function checkSupply()
	local needSupply = false
	if(人物("血") < 人物("最大血") or 人物("魔") < 人物("最大魔")) then
		needSupply=true
	end
	if(宠物("血") < 宠物("最大血") or 宠物("魔") < 宠物("最大魔")) then
		needSupply=true
	end
	return needSupply
end
function main()
	停止遇敌()	
::begin::	
	等待空闲()	
	local 当前地图名 = 取当前地图名()
	mapNum = 取当前地图编号()
	if (当前地图名 =="艾尔莎岛" )then goto togle
	elseif(当前地图名 ==  "里谢里雅堡")then goto togle 
	elseif(当前地图名 ==  "哥拉尔镇")then goto map43100 
	elseif(当前地图名 ==  "法兰城")then goto togle 		
	elseif(当前地图名 ==  "扎营处")then goto map47012 		
	elseif(当前地图名 ==  "库鲁克斯岛")then goto map43000 		
	elseif(当前地图名 ==  "鲁米那斯")then goto map43600 		
	elseif(当前地图名 ==  "长老之家")then goto map43676 		
	elseif(当前地图名 ==  "长老之家2楼")then goto map43675 		
	elseif(当前地图名 ==  "伊姆尔森林 入口")then goto map47009 				
	elseif(mapNum ==  43200)then 		--白之宫殿
		goto map43200
	elseif(mapNum ==  43210)then 		--白之宫殿
		goto map43210 		
	elseif(mapNum ==  43217)then 		--牢房
		goto map43217	
	elseif(mapNum ==  46011)then 		--过去的哥拉尔城地下牢
		goto map46011	
	elseif(mapNum ==  46012)then 		--勇者里雍的房间
		goto map46012 	
	elseif(mapNum ==  46010)then 		--过去的哥拉尔
		goto map46010 	
	elseif(mapNum ==  43210)then 		--白之宫殿
		goto map43210 
	elseif(mapNum ==  47010)then 		--伊姆尔森林
		goto map47010		
	elseif(mapNum ==  47011)then 		--伊姆尔森林
		goto map47011		
	elseif(mapNum ==  47013)then 		--伊姆尔森林
		goto map47013	
	elseif(mapNum ==  47014)then 		--伊姆尔森林
		goto map47014		
	elseif(mapNum ==  47017)then 		--森之墓场
		goto map47017	
	elseif(mapNum ==  47018)then 		--森之墓场
		goto map47018	
	end		
	--回城()
	等待(2000)
	goto begin
::togle::
	执行脚本("./脚本/直通车/★公交车-法兰To哥拉尔.lua")
	等待到指定地图("哥拉尔镇")
	goto begin
::map43100::				--哥拉尔镇
	if(checkTitle("魔鬼克星"))then
		日志("已完成帕鲁凯斯亡灵任务",1)
	end
	
	if(checkSupply())then
		移动(165,91,"医院")
		移动(29,26)	
		回复(30,26)
		移动(9,23,"哥拉尔镇")		
	end	
	--白之宫殿
	if(是否目标附近(120,107,10))then
		移动(120,107)
		转向(0)		-- 转向北	
		等待到指定地图("哥拉尔镇",118,214)
	end	
	移动(140, 214,"白之宫殿")	
::map43200::
	移动(47, 36,43210)	
::map43210::
	移动(23, 18,"牢房")		
::map43217::				--牢房
	if(目标是否可达(33,16))then
		移动(33, 16,"牢房")	
		对话选是(0)
	end
	if(目标是否可达(28, 7))then
		移动(28, 7)
		对话选是(28,6)
	end	
::map46011::				--过去的哥拉尔城地下牢	
	移动(26, 12)	
	对话选是(27,12)
::map46012::				--勇者里雍的房间
	移动(10, 8)	
	对话选是(10,7)
::map46010::				--过去的哥拉尔
	if(是否队长) then
		common.makeTeam(队伍人数)
		if(队伍("人数")>=队伍人数) then
			if(目标是否可达(84,65))then
				移动(84,65)
				转向(4)
				等待到指定地图("过去的哥拉尔",84,76)
			end
			if(目标是否可达(84,65))then
				等待空闲()
				移动(84,83)
				对话选是(84,84)				
			end
			goto begin
		end
	else
		common.joinTeam(队长名称)
		while 队伍("人数") > 1 do		--循环 等解散队伍时候 判断下一步
			等待(5000)
		end
		goto begin
	end	
	goto map46010
::map47012::				--扎营处
	移动(23,13)
	移动(23,15)
	移动(23,13)
	对话选是(24,14)	
	if(取当前地图名() == "牢房")then
		去鲁村()
		goto begin
	end
	goto map47012	
::map43000::			--库鲁克斯岛
	if(目标是否可达(322,883)==false)then
		移动(476,526)
		对话选是(477,526)
	end
	if(取物品数量("火把") > 0) then
		移动(463,632,"伊姆尔森林 入口")
	else	
		移动(322,883,"鲁米那斯")
	end
	goto begin
::map43600::			--鲁米那斯
	if(取物品数量("火把") > 0) then
		移动(60,29,"库鲁克斯岛")
		goto begin
	end	
	移动(88, 51, "杂货店")
	移动(11, 12)
	卖(2,卖店物品列表)	
	移动(4,13,"鲁米那斯")	
	移动(87,35,"医院")		
	移动(17, 16)
	回复(2)
	移动(4,14,"鲁米那斯")
	移动(94,43,"长老之家")	
::map43676::
	移动(11,2,"长老之家2楼")	
::map43675::
	移动(12, 13)
	对话选是(12,14)
	if(取物品数量("火把") > 0) then
		移动(11,4,"长老之家")
		移动(2,12)
		移动(60,29,"库鲁克斯岛")
	end
	if(取物品数量("失魂的耳饰") > 0) then
		if(checkTitle("魔鬼克星"))then
			日志("获得称号【魔鬼克星】,已完成帕鲁凯斯亡灵任务",1)
			return
		end
	end
	goto begin
::map47009::			--伊姆尔森林 入口
	移动(28,14)
	对话选是(28,13)
	goto begin
::map47010::			--伊姆尔森林
	if(是否队长) then		
		common.makeTeam(队伍人数)
		if(队伍("人数")>=队伍人数) then
			移动(31,7,"森之迷宫")
			自动穿越迷宫("47011")			
			goto begin
		end
	else
		common.joinTeam(队长名称)
		while 队伍("人数") > 1 do		--循环 等解散队伍时候 判断下一步
			等待(5000)
		end
		goto begin
	end	
	goto map46010
::map47011::			--伊姆尔森林
	移动(29,11,"森之迷宫")
	自动穿越迷宫("47013")	
	goto begin
::map47013::			--伊姆尔森林
	移动(36,39,"森之迷宫")
	自动穿越迷宫("47013")	
	goto begin
::map47014::			--伊姆尔森林
	移动(11,35,"森之迷宫")
	自动穿越迷宫("47013")	
	goto begin
::map47017::			--森之墓场
	移动(27,14)
	转向(0)
	等待(5000)
	if(是否战斗中())then
		等待到指定地图("森之墓场",27,15)
		goto map47018
	end
	goto map47017
::map47018::			--森之墓场
	对话选是(27,13)
	goto begin
end	
function 去鲁村()
::begin::	
	等待空闲()	
	local mapName = 取当前地图名()
	local mapNum = 取当前地图编号()
	if(mapName ==  "牢房")then goto map43217
	elseif(mapName ==  "哥拉尔镇")then goto map43100	
	elseif(mapNum ==  43210)then goto map43210	
	elseif(mapNum ==  43200)then goto map43200
	end		
	等待(1000)
	goto begin
::map43217::
	移动(9,16,"43210")
::map43210::
	移动(9,46,"43200")
::map43200::
	移动(41,22,"哥拉尔镇")	
::map43100::
	移动(165,91,"医院")
	移动(29,26)	
	回复(30,26)
	移动(9,23,"哥拉尔镇")		
	移动(176,105,"库鲁克斯岛")	
end

main()