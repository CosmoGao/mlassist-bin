卵6脚本,艾尔莎启动,此任务完成后，刷保证书4时，朵拉后，如果刷完长老证，会在逆十字这步卡住，去时空之人回退任务，弗里德里希 即可领取逆十字，可直接几线

设置("timer",50)

common=require("common")
设置("移动速度",120)
设置("自动叠",1,"长老之证&3")
设置("自动加血",0)

local 队伍人数=取脚本界面数据("队伍人数")
local 设置队员列表=取脚本界面数据("队员列表")
local 队员列表={}
local 队长名称=取脚本界面数据("队长名称")
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","乱￠逍遥")--风依旧￠花依然  乱￠逍遥
end
if(人物("名称") == 队长名称)then
	if(队伍人数==nil or 队伍人数==0)then
		队伍人数 = 用户输入框("练级队伍人数，不足则固定点等待！",5)
	end
end

if(设置队员列表 ~= nil and string.find(设置队员列表,"|") ~= nil)then
	队员列表=common.luaStringSplit(设置队员列表,"|")
end
local 是否刷逆十字 = true
local isTeamLeader=false		--是否队长
local 当前步骤=1

function 重置任务到5()
	回城()
	自动寻路(157,93)
	转向(2)	
	等待到指定地图("艾夏岛")	
	自动寻路(102, 115,"冒险者旅馆")	
	自动寻路(30, 21)	
	转向(0)
	喊话("弗里德里希",2,3,5)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(1,0)
	喊话("弗里德里希",2,3,5)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(1,0)	
	回城()
end

function 阿布荷斯的逆十字对话()
	if(取物品数量("阿布荷斯的逆十字") > 0 and 是否目标附近(22,44))then
		对话选是(22,44)
	end
end
--给了逆十字 并且有仙人掌刺时候 返回对话
--哦，你拿来了。\n　快拿着这个\n　去找安洁可吧。
function 检测步骤1对话()	
	if(是否目标附近(22,44))then
		 转向坐标(22,44)
		local dlg =等待服务器返回()
		if(dlg ~= nil ) then
			if(string.find(dlg.message,"去找安洁可吧") ~= nil) then	
				return true
			end
		end
	end
	return false
end
function main()	
	
	local mapName=""
	local mapNum=0
	-- if(取物品数量("觉醒的文言抄本") < 1)then
		-- 日志("身上没有【觉醒的文言抄本】，请先准备好道具再进行任务")
		-- return
	-- end
	--重置任务到4()
	当前步骤=1
::begin::
	等待空闲()
	mapName=取当前地图名()
	mapNum=取当前地图编号()
	if(mapName=="艾尔莎岛")then
		goto aiersha
	elseif(mapName=="法兰城遗迹")then
		goto map59510	
	elseif(string.find(mapName,"库瓦托劳姆")~=nil)then
		goto map59510
	elseif mapNum == 59725 then goto map59725 
	elseif mapNum == 59726 then goto map59726 
	elseif mapNum == 59727 then goto map59727 
	elseif mapNum == 59728 then goto map59728 
	elseif mapNum == 59729 then goto map59729
	elseif mapNum == 59730 then goto map59730
	elseif mapNum == 59731 then goto map59731
	elseif mapNum == 59732 then goto map59732
	elseif mapNum == 59733 then goto map59733
	elseif mapNum == 59734 then goto map59734
	elseif mapNum == 59735 then goto map59735
	elseif mapNum == 59736 then goto map59736
	elseif mapNum == 59538 then goto map59538			--冒险者旅馆
	elseif mapNum == 59714 then goto map59714			--？？？
	end
	等待(1000)
	goto begin
::aiersha::
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)		
	if(取物品数量("地底仙人掌的刺") > 0)then		
		回城()
		自动寻路(157,93)
		转向(2)	
		等待到指定地图("艾夏岛")	
		自动寻路(102, 115,"冒险者旅馆")			
	else
		common.toCastle()
		自动寻路(28,88)
		等待服务器返回()	
		对话选择(32, 0)
		等待服务器返回()	
		对话选择(32, 0)
		等待服务器返回()	
		对话选择(32, 0)
		等待服务器返回()	
		对话选择(32, 0)
		等待服务器返回()
		对话选择(4, 0)
		等待到指定地图("？")	
		自动寻路(19, 20)
		移动一格(4)	
		等待到指定地图("法兰城遗迹")		
	end
	goto begin
::map59538::				--冒险者旅馆
	if(isTeamLeader)then
		if(队伍("人数") < 队伍人数) then  
			common.makeTeam(队伍人数)
		else
			if(当前步骤 == 1)then
				自动寻路(21,43)
				自动寻路(23,43)
				自动寻路(21,43)
				自动寻路(23,43)
				阿布荷斯的逆十字对话()	
				if(检测步骤1对话())then
					当前步骤=2
				end
			elseif 当前步骤== 2 then
				自动寻路(57,32)
				自动寻路(55,32)
				自动寻路(57,32)
				自动寻路(55,32)
				对话选是(56,31)
				if(取物品数量("卡库塔西道尔") > 0)then
					checkTeammateItem()
					使用物品("卡库塔西道尔")
					对话选是(4)
					等待到指定地图("？？？")					
				end
			end
			
		end		
	else
		if(队伍("人数") > 1) then  
			阿布荷斯的逆十字对话()
		else
			common.joinTeam(队长名称)
		end		
	end	
	goto begin
::map59714::				--？？？ 东71 南142
	if(取物品叠加数量("冰冻的悲鸣") < 5)then
		自动寻路(79,125)			--1层
		--自动寻路(64,125)			--5层
	else
		自动寻路(80,143)	
		自动寻路(78,143)
		自动寻路(80,143)	
		自动寻路(78,143)
		对话选是(79,144)	
		等待到指定地图("神殿　伽蓝",154,96)
		自动寻路(155,96)
		对话选是(156,96)
		等待到指定地图("拉·梵·琉　第一层",85,124)
	end
	goto begin
::map59530::				--神殿　伽蓝
	自动寻路(155,96)
	对话选是(156,96)
	等待到指定地图("拉·梵·琉　第一层",85,124)
	goto begin
::map59741::				--拉·梵·琉　第一层
	if(目标是否可达(257,103))then	
		自动寻路(257,103,"拉·梵·琉　第二层")
	elseif(目标是否可达(138,194))then
		自动寻路(138,194)
	elseif(目标是否可达(174,125))then
		自动寻路(174,125)
		对话选是(175,125)
		if(是否战斗中())then
			等待战斗结束()
		end	
	end
	goto begin
::map59742::				--拉·梵·琉　第二层
	if(目标是否可达(130,156))then	
		自动寻路(130,156,"拉·梵·琉　第三层")
	elseif(目标是否可达(162,185))then
		自动寻路(162,185)
	elseif(目标是否可达(143,124))then
		自动寻路(143,124,"拉·梵·琉　第一层")
	end
	goto begin
::map59743::				--拉·梵·琉　第二层
	自动寻路(120,125)
	if(目标是否可达(257,104))then	
		自动寻路(257,104)
		对话选是(0)
		if(是否战斗中())then
			等待战斗结束()
		end		--跳转点 三层   142 141
	elseif(目标是否可达(130,126))then
		自动寻路(130,126)	
	elseif(目标是否可达(177,116))then
		自动寻路(177,116)
	end
	goto begin
::map59744::				--拉·梵·琉　第四层  130 126
	if(目标是否可达(186,47))then
		自动寻路(186,47)
	elseif(目标是否可达(212,110))then
		自动寻路(212,110)	
	elseif(目标是否可达(168,115))then
		自动寻路(168,115)
	end
	goto begin
::map59745::				--拉·梵·琉　第五层 东211 南109
	自动寻路(168,135)
	goto begin
	
::map59752::				--？？？
	自动寻路(265,206)
	对话选是(6)

::maze::		
	自动寻路(取周围空地(取当前坐标(),3))
	开始遇敌()
	while true do
		if(取物品叠加数量("冰冻的悲鸣") >= 5)then break end
	
	end	
	停止遇敌()
	goto begin
	
	
	
	
	
	
	
	
	
::map59510::				--法兰城遗迹
	自动寻路(83,36)
	if(等待黄昏或夜晚())then		
		对话选择(1,0)
		等待(2000)
		if(是否战斗中())then
			等待战斗结束()
		end
		if 取物品数量("精灵之牙？") > 0 then			
			回城()
		else
			goto map59510
		end
	end
	goto begin

::map59727::				--地之昏神的领域 57 146
	自动寻路(45,95,"59728")
	等待(1500)
	goto begin
::map59728::				--地之昏神的领域 67 74
	自动寻路(165,80,"59728")
	对话选是(1)				--地使者
	if(是否战斗中())then
		等待战斗结束()
	end
	等待(1500)
	goto begin
::map59734::				--葛拉奇的领域—内宫 38 83
	自动寻路(68,52)
	对话选是(1)		
	goto begin	
::map59729::				--水之昏神的领域 57 146
	自动寻路(45,95,"59730")
	等待(1500)
	goto begin
::map59730::				--水之昏神的领域 67 74		--1级红铜怪 167 101
	自动寻路(165,80)
	对话选是(1)				--水使者
	if(是否战斗中())then
		等待战斗结束()
	end
	等待(1500)
	goto begin
::map59735::				--克塔多的领域—内宫 38 83
	自动寻路(68,52)
	对话选是(1)		
	goto begin
::map59725::				--火之昏神的领域 57 146
	自动寻路(45,95,"59730")
	等待(1500)
	goto begin
::map59726::				--火之昏神的领域 67 74		
	自动寻路(165,80)
	对话选是(1)				--火使者
	if(是否战斗中())then
		等待战斗结束()
	end
	等待(1500)
	goto begin
::map59733::				--库特嘉的领域—内宫 38 83
	自动寻路(68,52)
	对话选是(1)	
	goto begin	
::map59731::				--风之昏神的领域 57 146
	自动寻路(45,95,"59730")
	等待(1500)
	goto begin
::map59732::				--风之昏神的领域 67 74		65 142可以回复
	自动寻路(165,80)
	对话选是(1)				--风使者
	if(是否战斗中())then
		等待战斗结束()
	end
	等待(1500)
	goto begin
::map59736::				--哈斯塔的领域—内宫 38 83
	自动寻路(68,52)
	对话选是(1)	
	goto begin
::map59716::				--？？？
	if 目标是否可达(166,141) then
		自动寻路(166,141)
		等待到指定地图("四昏神的领域地下1阶")
	elseif 目标是否可达(67,172) then
		自动寻路(67,172)		--boss
		对话选是(0)	
	end
	goto begin
::maze::
	自动穿越迷宫()
::map59737::				--四昏神的领域—内宫 东59 南62
	自动寻路(68,50)
	对话选是(0)	
	if(是否战斗中())then
		等待战斗结束()
	end
	if(人物("血") <= 1)then
		日志("没有打过Boss，脚本结束")
		return
	end
	if(取当前地图名() == "精灵之下宫")then
		if(是否刷逆十字) then
			
		
		else
			日志("打完boss，去领取改造图")
			回城()
			if(取物品数量("阿布荷斯的逆十字") > 0)then
				设置("遇敌全跑",1)
				自动寻路(130, 50, "盖雷布伦森林")	
				自动寻路(244, 74)	
				对话选是(245,73)
			else
				日志("没有阿布荷斯的逆十字 无法领取改造图")
				return
			end
		end
	end
	goto begin
end
function 等待黄昏或夜晚()
	local mapName=取当前地图名()
	local mapNum=取当前地图编号()
	if(游戏时间() == "夜晚" or 游戏时间() == "黄昏")then		
		return true
	else
		while true do 
			if(游戏时间() ~= "夜晚" and 游戏时间() ~= "黄昏")then		
				日志("当前时间是【"..游戏时间().."】，等待黄昏或夜晚")
				等待(30000)		
			elseif(取当前地图编号() ~= mapNum)then
				return false
			else						
				return true
			end		
		end		
	end
	return false
end
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
main()

-- if(检测步骤1对话())then
	-- 日志("已完成步骤1")
-- end