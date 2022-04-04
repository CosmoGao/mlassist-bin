刷探险手环脚本

-- 1.前往法兰城里谢里雅堡与贝尔（53.22）对话，获得【证明信】。
-- 2.前往莎莲娜岛西方洞窟与贝尔的助手（13.10）对话，交出【证明信】进入隐秘的山道。
-- ◆隐秘的山道为随机迷宫，共21层；迷宫分上、中、下三个部分，每部分皆为7层；上层魔物为Lv.133土蜘蛛、中层魔物为Lv.133独角仙、下层魔物为Lv.133穴熊
-- ◆迷宫内不得组队行走，否则魔物会追加技能全体即死魔法（100%命中）、自爆（全体伤害）
-- 3.通过随机迷宫抵达山道尽头，调查军刀（13.6）获得【贝尔的军刀】并传送出迷宫。
-- 4.返回法兰城里谢里雅堡与贝尔（53.22）对话，交出【贝尔的军刀】并传送至贝尔的隐居地。
-- 5.与饥饿的贝尔对话，进入战斗。
-- ◆Lv.135饥饿的贝尔，血量约16000；技能：攻击、防御、阳炎、乾坤一掷、连击、暗杀、气功弹
-- 6.战斗胜利后与饥饿的贝尔对话，获得【签名】并传送出贝尔的隐居地。
-- 7.前往法兰城，持有【签名】*60与签名收集者（166.121）对话，可兑换【探险之勇气手环】，任务完结。
-- ◆【探险之勇气手环】：Lv.6手环、耐久250；攻击+70、防御+70、回复+30、抗昏睡/石化/混乱+15、必杀+25、命中+30、闪躲+20、抗魔+50；可以交易

common=require("common")


队长名称=取脚本界面数据("队长名称")
队伍人数=取脚本界面数据("队伍人数")
设置队员列表=取脚本界面数据("队员列表")
队员列表=nil
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


isTeamLeader=false		--是否队长
if(人物("名称") == 队长名称)then
	isTeamLeader=true
end


医生名称={"星落护士","谢谢惠顾☆"}
水晶名称="水火的水晶（5：5）"
上次迷宫楼层=nil
当前迷宫楼层=nil
function main()

::begin::
	等待空闲()
	mapNum=取当前地图编号()
	mapName=取当前地图名()
	if(mapNum == 57195)then		--"隐秘山道上层"
		goto map57195
	elseif(mapNum == 57196)then		--"隐秘山道上层"
		goto map57196
	elseif(mapNum == 57197)then		--"隐秘山道下层"
		goto map57197	
	elseif(mapNum == 57198)then		--"山道尽头"
		goto map57198
	elseif(string.find(mapName,"隐秘山道") ~= nil)then	--迷宫
		goto maze
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
	end
	common.supplyCastle()
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)
	if(取物品数量("491723") > 0) then --证明信		
		common.toTeleRoom("阿巴尼斯村")
		goto map4399
	elseif(取物品数量("贝尔的军刀") > 0) then 
		common.toCastle()
		移动(53, 23)
		对话选是(53,21)
	else
		common.toCastle()
		移动(53, 23)
		对话选是(53,21)
	end	
	goto begin
::map4399::							--阿巴尼斯村的传送点
	等待到指定地图("阿巴尼斯村的传送点")
	移动(5, 4, 4313)
::map4313::							--村长的家
	移动(6, 13, 4312)
::map4312::							--村长的家
	移动(6, 13, "阿巴尼斯村")
::map4300::							--阿巴尼斯村
	移动(37, 71,"莎莲娜")	
::map400::							--莎莲娜
	if(取物品数量("贝尔的军刀") > 0) then
		回城()
		goto begin
	end
	移动(258, 180,"莎莲娜西方洞窟") 
::map14002::						--莎莲娜西方洞窟
	移动(30, 44,14001)
::map14001::						--莎莲娜西方洞窟
	移动(14, 68, 14000)
::map14000::
	移动(13,11)
	对话选是(13,9)
	goto begin
::map57195::						--隐秘山道上层
	移动(17,9,"隐秘山道上层B1")
	上次迷宫楼层=nil
	当前迷宫楼层=nil
	goto begin
::map57196::
	移动(8,4,"隐秘山道中层B1")
	上次迷宫楼层=nil
	当前迷宫楼层=nil
	goto begin
::map57197::
	移动(15,10,"隐秘山道下层B1")
	上次迷宫楼层=nil
	当前迷宫楼层=nil
	goto begin
::map57198::
	移动(13,6)
	对话选是(13,5)
	if(取当前地图名() == "莎莲娜") then 回城() end		
	goto begin
::map57199::
	if(isTeamLeader)then
		移动(23,20)
		if(队伍("人数") < 队伍人数)then	--数量不足 等待
			common.makeTeam(队伍人数,队员列表)
		else
			移动(20,18)
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
		等待(2000)		
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
	对话选是(20,16)
	goto begin
::maze::
	mapName = 取当前地图名()
	当前迷宫楼层=取当前楼层(mapName)		--从地图名取楼层
	if(上次迷宫楼层~=nil and 当前迷宫楼层 < 上次迷宫楼层 )then	--反了
		tx,ty=取迷宫远近坐标(false)			--取最近迷宫坐标
		移动(tx,ty)		
		当前迷宫楼层=取当前楼层(取当前地图名())	
	end	
	上次迷宫楼层=当前迷宫楼层
	自动迷宫()	
	goto begin
end
main()    



