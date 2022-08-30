保证书卵5脚本,艾尔莎启动,目前侦探无法进入，其余职业没有全部验证,设置

设置("timer",50)

common=require("common")
设置("移动速度",120)
设置("自动叠",1,"长老之证&3")
设置("自动扔",1,"魔石|卡片？|地的水晶碎片|水的水晶碎片|火的水晶碎片|风的水晶碎片")
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
local 是否刷逆十字 = false
local isTeamLeader=false		--是否队长
local 是否需要重置任务=true
function 重置任务到4()
	回城()
	自动寻路(157,93)
	转向(2)	
	等待到指定地图("艾夏岛")	
	自动寻路(102, 115,"冒险者旅馆")	
	自动寻路(30, 21)	
	转向(0)
	喊话("爱蜜儿",2,3,5)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(1,0)
	喊话("爱蜜儿",2,3,5)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(1,0)	
	回城()
end

function TeammateAction()
	if(队伍("人数") > 1) then  
		while 队伍("人数") > 1 do
			等待(3000)		
			if(取当前地图名() == "精灵之下宫" and 人物("坐标")=="92,76")then
				日志("任务完成！")
				break
			end
		end
		--解散队伍时候 到下一个点
	else
		common.joinTeam(队长名称)
	end	
	
end
function 去领取改鲨图()
	日志("打完boss，去领取改造图")
	回城()
	if(取物品数量("阿布荷斯的逆十字") > 0)then
		设置("遇敌全跑",1)
		自动寻路(130, 50, "盖雷布伦森林")	
		自动寻路(244, 74)	
		对话选是(245,73)
		return true
	else
		日志("没有阿布荷斯的逆十字 无法领取改造图")
		return false
	end
	return false
end
function 获取精灵之牙()
	if(取当前地图名() ~= "法兰城遗迹")then return false end
	local tryCount=0
	while tryCount < 3 do
		自动寻路(83,36)
		local dlg = 等待服务器返回()
		if(dlg.dialog_id == 0)then
			tryCount=tryCount+1
		else
			return true
		end
		自动寻路(83,37)
	end	
	return false
end
function main()	
	if(人物("名称",false) == 队长名称)then
		isTeamLeader=true
		日志("当前是队长:"..人物("名称",false),1)
		if(队伍人数==nil or 队伍人数==0)then
			队伍人数 = 用户输入框("队伍人数",5)
		else
			队伍人数=tonumber(队伍人数)
		end
		日志("队伍人数:"..队伍人数,1)
		
	else	
		日志("当前是队员:"..人物("名称",false),1)
	end
	日志("队长名称："..队长名称.." 角色名称:" .. 人物("名称",false))	
	local mapName=""
	local mapNum=0
	-- if(取物品数量("觉醒的文言抄本") < 1)then
		-- 日志("身上没有【觉醒的文言抄本】，请先准备好道具再进行任务")
		-- return
	-- end
	--重置任务到4()		--默认重置
	
::begin::
	等待空闲()
	mapName=取当前地图名()
	mapNum=取当前地图编号()
	if(mapName=="艾尔莎岛")then
		goto aiersha
	elseif(mapName=="法兰城遗迹")then
		goto map59510
	elseif(string.find(mapName,"四昏神的领域地下") ~= nil) then goto maze
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
	elseif mapNum == 59737 then goto map59737
	elseif mapNum == 59716 then goto map59716		--？？？
	elseif mapNum == 59537 then goto map59537		--精灵之下宫
	else	
		回城()
	end
	等待(1000)
	goto begin
::aiersha::
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)		
	if(取物品数量("精灵之牙？") > 0)then
		if(取物品数量("觉醒的文言抄本") < 1)then
			日志("身上没有【觉醒的文言抄本】，请先准备好道具再进行任务")
			--领取抄本
			common.gotoBankRecvTradeItemsAction({topic="觉醒的文言抄本发放员",publish="领取觉醒的文言抄本",itemName="觉醒的文言抄本",itemCount=1,itemPileCount=1})
			goto begin
		end
		回城()
		自动寻路(201,96,"神殿　伽蓝")
		自动寻路(95,80,"神殿　前廊")
		自动寻路(44,41,59531)
		自动寻路(17,33,59537)
		--队长调查任意雕像 才能进入  单人进不去		
		自动寻路(103,65,地之昏神的领域)		--有抄本 	自动寻路(102,66,地之昏神的领域)		
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
::map59510::				--法兰城遗迹
	自动寻路(83,36)
	if(等待黄昏或夜晚())then
		if(是否需要重置任务)then
			if(获取精灵之牙()==false)then
				重置任务到4()
				goto begin
			end
			是否需要重置任务=false
		end
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
::map59537::				--精灵之下宫
	if(取物品数量("精灵之牙？") > 0)then
		自动寻路(103,65,地之昏神的领域)		--有抄本 	自动寻路(102,66,地之昏神的领域)		
	elseif(人物("坐标")=="92,76")then
		日志("卵5任务完成")
		if(是否刷逆十字) then
			
			return
		else
			if(去领取改鲨图()==false)then	--得领取逆十字 然后领改鲨 领完再还回去
				return --失败返回
			end
		end
	end
::map59727::				--地之昏神的领域 57 146
	if isTeamLeader then		
		if(队伍("人数") < 队伍人数) then  
			common.makeTeam(队伍人数)
		else
			自动寻路(45,95,"59728")
		end
	else
		TeammateAction()
	end
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
	if isTeamLeader then		
		if(队伍("人数") < 队伍人数) then  
			common.makeTeam(队伍人数)
		else
			自动寻路(45,95,"59730")
		end
	else
		TeammateAction()
	end	
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
	if isTeamLeader then		
		if(队伍("人数") < 队伍人数) then  
			common.makeTeam(队伍人数)
		else
			自动寻路(45,95,"59726")
		end
	else
		TeammateAction()
	end	
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
	if isTeamLeader then		
		if(队伍("人数") < 队伍人数) then  
			common.makeTeam(队伍人数)
		else
			自动寻路(45,95,"59732")
		end
	else
		TeammateAction()
	end	
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
		if isTeamLeader then		
			if(队伍("人数") < 队伍人数) then  
				common.makeTeam(队伍人数)
			else
				自动寻路(166,141)
				等待到指定地图("四昏神的领域地下1阶")
			end
		else
			TeammateAction()
		end			
	elseif 目标是否可达(67,172) then
		自动寻路(67,172)		--boss
		对话选是(0)	
	end
	goto begin
::maze::
	自动穿越迷宫()
	goto begin
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
		日志("卵5任务完成")
		if(是否刷逆十字) then
			
			return
		else
			if(去领取改鲨图()==false)then	--得领取逆十字 然后领改鲨 领完再还回去
				return --失败返回
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
main()

