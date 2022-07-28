刷探险手环脚本,平均每小时3-4个,静止1800秒(30分钟)重启，脚本停止160秒重启，不勾选回城重启，静止3600秒(60分钟)登出（此项防止异次元）

-- 1.前往法兰城里谢里雅堡与贝尔（53.22）对话，获得【证明信】。
-- 2.前往莎莲娜岛西方洞窟与贝尔的助手（13.10）对话，交出【证明信】进入隐秘的山道。
-- ◆迷宫内不得组队行走，否则魔物会追加技能全体即死魔法（100%命中）、自爆（全体伤害）
-- 3.通过随机迷宫抵达山道尽头，调查军刀（13.6）获得【贝尔的军刀】并传送出迷宫。
-- 4.返回法兰城里谢里雅堡与贝尔（53.22）对话，交出【贝尔的军刀】并传送至贝尔的隐居地。
-- 5.与饥饿的贝尔对话，进入战斗。
-- ◆Lv.135饥饿的贝尔，血量约16000；技能：攻击、防御、阳炎、乾坤一掷、连击、暗杀、气功弹
-- 6.战斗胜利后与饥饿的贝尔对话，获得【签名】并传送出贝尔的隐居地。
-- 7.前往法兰城，持有【签名】*60与签名收集者（166.121）对话，可兑换【探险之勇气手环】，任务完结。
-- ◆【探险之勇气手环】：Lv.6手环、耐久250；攻击+70、防御+70、回复+30、抗昏睡/石化/混乱+15、必杀+25、命中+30、闪躲+20、抗魔+50；可以交易

common=require("common")
设置("自动叠",1,"签名&999")

local 队长名称=取脚本界面数据("队长名称",false)	--false是不转换成数字 默认字符串
local 队伍人数=取脚本界面数据("队伍人数")
local 设置队员列表=取脚本界面数据("队员列表")
local 队员列表=nil
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","风依旧￠花依然")
end
if(队伍人数==nil or 队伍人数==0)then
	队伍人数 = 用户输入框("队伍人数，不足则固定点等待！",5)
else
	队伍人数=tonumber(队伍人数)
end
if(设置队员列表==nil or 设置队员列表=="")then
	设置队员列表 = 用户输入框("练级队员列表，不设置则不判断队员！","")
end
if(设置队员列表 ~= nil and string.find(设置队员列表,"|") ~= nil)then
	队员列表=common.luaStringSplit(设置队员列表,"|")
end


设置("timer",20)			--设定脚本运行速度间隔 单位是毫秒
设置("自动加血", 0)			--关闭自动加血，脚本对话加血 
local isTeamLeader=false			--是否队长
local 走路加速值=110				--脚本走路中可以设定移动速度  到达目的地后，再还原值即可 不要超125  
local 走路还原值=100				--防止掉线 还原速度
local 身上最少金币=5000			--少于去取
local 身上最多金币=1000000		--大于去存
local 身上预置金币=500000			--取和拿后 身上保留金币
local 脚本运行前时间=os.time()	--统计效率
local 脚本运行前金币=人物("金币")	--统计金币
local 已刷签名数量=0				--统计刷签名总数
local 医生名称={"星落护士","谢谢惠顾☆"}	--自定义医生 优先找自己的
local 水晶名称="水火的水晶（5：5）"	--指定水晶名称
local 上次迷宫楼层=nil			--迷宫判断正反
local 当前迷宫楼层=nil			--迷宫判断正反

function main()
	日志("欢迎使用星落刷签名脚本",1)
	日志("当前职业："..人物("职业"),1)
	日志("当前职称："..人物("职称"),1)
	common.baseInfoPrint()
	common.statisticsTime(脚本运行前时间,脚本运行前金币)
	if(人物("名称",false) == 队长名称)then
		日志("当前是队长",1)
		isTeamLeader=true
	else
		日志("当前是队员",1)
	end
	日志("队长名称："..队长名称.." 角色名称:" .. 人物("名称",false))
	common.changeLineFollowLeader(队长名称)		--同步服务器线路
	设置("移动速度",走路加速值)	-- 掉线的自己关闭加速就行
	设置("遇敌全跑", 1)			-- 遇敌全跑 
::begin::
	等待空闲()
	common.changeLineFollowLeader(队长名称)		--同步服务器线路
	mapNum=取当前地图编号()
	mapName=取当前地图名()
	if(mapNum == 1000)then		--"法兰城"
		回城()
		等待(2000)
		goto begin
	elseif(mapNum == 57195)then		--"隐秘山道上层"
		goto map57195
	elseif(mapNum == 57196)then		--"隐秘山道上层"
		goto map57196
	elseif(mapNum == 57197)then		--"隐秘山道下层"
		goto map57197	
	elseif(mapNum == 57198)then		--"山道尽头"
		goto map57198	
	elseif(mapNum == 57199)then	--贝尔的隐居地
		goto map57199
	elseif(mapNum == 57200)then	--贝尔的隐居地		
		goto map57200
	elseif(mapNum == 14002)then	--莎莲娜西方洞窟
		goto map14002	
	elseif(mapNum == 14001)then	--莎莲娜西方洞窟
		goto map14001		
	elseif(mapNum == 14000)then	--莎莲娜西方洞窟
		goto map14000	
	elseif(mapNum == 4399)then	--阿巴尼斯村的传送点
		goto map4399
	elseif(mapNum == 4313)then	--村长的家
		goto map4313	
	elseif(mapNum == 4312)then	--村长的家
		goto map4312	
	elseif(mapNum == 4300)then	--阿巴尼斯村
		goto map4300
	elseif(mapNum == 400)then	--莎莲娜
		goto map400		
	elseif(string.find(mapName,"隐秘山道") ~= nil)then	--迷宫
		goto maze
	end
	common.checkGold(身上最少金币,身上最多金币,身上预置金币)
	common.supplyCastle()
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)
	if(取物品数量("491723") > 0) then --证明信		
		common.toTeleRoom("阿巴尼斯村")
		goto map4399
	elseif(取物品数量("贝尔的军刀") > 0) then 
		if(取当前地图编号() ~= 1500)then common.toCastle() end
		自动寻路(53, 23)
		对话选是(53,21)
	else
		if(取当前地图编号() ~= 1500)then common.toCastle() end
		自动寻路(53, 23)
		对话选是(53,21)
	end	
	goto begin
::map4399::							--阿巴尼斯村的传送点
	等待到指定地图("阿巴尼斯村的传送点")
	自动寻路(5, 4, 4313)
::map4313::							--村长的家
	自动寻路(6, 13, 4312)
::map4312::							--村长的家
	自动寻路(6, 13, "阿巴尼斯村")
::map4300::							--阿巴尼斯村
	自动寻路(37, 71,"莎莲娜")	
::map400::							--莎莲娜
	if(取物品数量("贝尔的军刀") > 0) then
		回城()
		goto begin
	end
	自动寻路(258, 180,"莎莲娜西方洞窟") 
::map14002::						--莎莲娜西方洞窟
	自动寻路(30, 44,14001)
::map14001::						--莎莲娜西方洞窟
	自动寻路(14, 68, 14000)
::map14000::
	自动寻路(13,11)
	对话选是(13,9)
	goto begin
::map57195::						--隐秘山道上层
	自动寻路(17,9,"隐秘山道上层B1")
	上次迷宫楼层=nil
	当前迷宫楼层=nil
	goto begin
::map57196::
	自动寻路(8,4,"隐秘山道中层B1")
	上次迷宫楼层=nil
	当前迷宫楼层=nil
	goto begin
::map57197::
	自动寻路(15,10,"隐秘山道下层B1")
	上次迷宫楼层=nil
	当前迷宫楼层=nil
	goto begin
::map57198::
	自动寻路(13,6)
	对话选是(13,5)
	if(取当前地图名() == "莎莲娜") then 回城() end		
	goto begin
::map57199::
	设置("遇敌全跑", 0)			-- 关闭遇敌全跑 组队打Boss
	if(isTeamLeader)then
		自动寻路(23,20)
		if(队伍("人数") < 队伍人数)then	--数量不足 等待
			common.makeTeam(队伍人数,队员列表)
		else
			自动寻路(20,18)
			对话选是(20,17)
			if(是否战斗中())then
				等待战斗结束()
			end
			if(取当前地图编号() == 57199 and 人物("血") <= 1)then
				日志("队伍没有打过Boss,回城重新开始",1)
				回城()
				goto begin
			end
		end
	else
		if(取队伍人数() > 1)then
			if(common.judgeTeamLeader(队长名称)==true) then
				goto teammateAction
			else
				离开队伍()
			end				
		end				
		common.joinTeam(队长名称)
	end
	goto begin
::teammateAction::		--队员判断
	--队伍人数检测
	if(取队伍人数() < 2 )then
		if(人物("血") <= 1)then	--判断是不是没打过boss
			日志("队伍没有打过Boss,回城重新开始",1)
			回城()
			goto begin
		end
		goto begin   --还有血 那就重新组队
	end
	if(取当前地图编号() ~= 57199)then goto begin end
	等待(2000)
	goto teammateAction
::map57200::
	设置("遇敌全跑", 1)			-- 遇敌全跑 
	自动寻路(20,18)
	对话选是(20,16)
	if(取当前地图名() == "法兰城")then	
		common.statisticsTime(脚本运行前时间,脚本运行前金币)	
		已刷签名数量=已刷签名数量+1
		日志("包裹现有签名数量："..取物品叠加数量("签名").."个，总刷签名数量"..已刷签名数量,1)
		回城()		
	end
	goto begin
::maze::
	mapName = 取当前地图名()
	当前迷宫楼层=取当前楼层(mapName)		--从地图名取楼层
	if(上次迷宫楼层~=nil and 当前迷宫楼层 < 上次迷宫楼层 )then	--反了
		tx,ty=取迷宫远近坐标(false)			--取最近迷宫坐标
		if(tx==0 and ty==0)then goto begin end
		自动寻路(tx,ty)		
		当前迷宫楼层=取当前楼层(取当前地图名())	
		if(string.find(mapName,"隐秘山道") == nil)then	--迷宫
			goto begin
		end
	end	
	上次迷宫楼层=当前迷宫楼层
	自动迷宫()	
	goto begin
end
main()    



