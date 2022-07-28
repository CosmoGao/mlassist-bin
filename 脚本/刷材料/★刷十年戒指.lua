刷十年戒指脚本,5转传教+4个攻人带改哥布林，4怪以上优先海盗即可，平均8-10分钟一趟，4天一个证。偶尔小帕翻车，无伤大雅

common=require("common")
设置("timer",20)
local 队长名称=取脚本界面数据("队长名称",false)
local 队伍人数=取脚本界面数据("队伍人数")
if(队长名称==nil or 队长名称=="" or 队长名称==0)then
	队长名称=用户输入框("请输入队伍名称！","风依旧￠花依然")--风依旧￠花依然  乱￠逍遥
end


--local 水晶名称="风地的水晶（5：5）"
local 水晶名称="水火的水晶（5：5）"
local isTeamLeader=false		--是否队长
local 身上最少金币=5000			--少于去取
local 身上最多金币=1000000		--大于去存
local 身上预置金币=500000		--取和拿后 身上保留金币
local 脚本运行前时间=os.time()	--统计效率
local 脚本运行前金币=人物("金币")	--统计金币
local 已刷戒指数量=0				--统计刷签名总数

local tradeName=nil
local tradeBagSpace=nil
local tradePlayerLine=nil			--仓库人物当前线路
local sEquipWeaponName=用户下拉框("武器名称",{"平民剑","平民斧","平民枪","平民弓","平民回力镖","平民小刀","平民杖"})		--武器名称
local sEquipHatName=用户下拉框("帽子名称",{"平民帽","平民盔"})				--帽子名称
local sEquipClothesName=用户下拉框("衣服名称",{"平民衣","平民铠","平民袍"})	--衣服名称
local sEquipShoesName=用户下拉框("鞋名称",{"平民鞋","平民靴"})				--鞋名称
--local sEquipShieldName=用户下拉框("盾名称",{"平民盾"})						--盾名称	
local bossData={
	{name="露比",x=15,y=110,nexty=103},
	{name="法尔肯",x=15,y=99,nexty=92},
	{name="犹大",x=15,y=88,nexty=81},
	{name="海贼",x=15,y=77,nexty=70},
	{name="双王",x=15,y=66,nexty=59},
	{name="小帕",x=15,y=55,nexty=48}
	}	
local topicList={"十年攻戒信息","十年魔戒信息"}
订阅消息(topicList)

function waitToNextBoss(name,x,y,nexty)
	if(目标是否可达(x,y))then	--露比
		移动到目标附近(x,y)
		对话选是(x,y)	
		等待(3000)
		if(是否战斗中())then 等待战斗结束() end
		等待空闲()
		nowx,nowy=取当前坐标()
		if(nowy==nexty)then
			return 1
		else
			日志("没有打过"..name,1)
			return -1
		end
	end
	return 0
end
function leaderLastTalk()
	if(目标是否可达(15,5))then	--出去
		自动寻路(14,5)
		自动寻路(16,5)
		自动寻路(14,5)
		自动寻路(16,5)
		对话选是(15,4)
		if(取当前地图名() == "里谢里雅堡")then	
			common.statisticsTime(脚本运行前时间,脚本运行前金币)	
			已刷戒指数量=已刷戒指数量+1
			日志("包裹现有十年戒指数量："..取物品数量("十周年纪念戒指").."个，总刷戒指数量"..已刷戒指数量,1)					
		end
		return true
	end		
	return false
end

function waitTopic(tgtTopic,tgtItemID)
	
	local tradex=nil
	local tradey=nil
	local topic=""
	local msg=""
	local recvTbl={}
	local units=nil
	local tradeList=""
	local hasData=false
	local selfTradeCount=0
	--日志(tgtTopic)
::begin::
	等待空闲()
	topic,msg=等待订阅消息()
	--日志(topic.." Msg:"..msg)
	if(topic == tgtTopic)then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeBagSpace=recvTbl.bagcount
		tradePlayerLine=recvTbl.line
	else
		goto begin
	end	
	--日志(tradeName.." "..tradeBagSpace .." " ..tradePlayerLine)
	if(tradePlayerLine ~= nil and tradePlayerLine ~= 0 and tradePlayerLine ~= 人物("几线"))then
		切换登录信息("","",tradePlayerLine,"")
		登出服务器()
		等待(3000)			
		goto begin
	end	
	if(tradeName ~= nil and tradeBagSpace ~= nil)then	
		if(取当前地图名()~= "银行" and 取当前地图编号() ~= 1121)then			
			common.gotoFalanBankTalkNpc()		
		end	
		tradex=nil
		tradey=nil
		units = 取周围信息()
		if(units ~= nil)then
			for i,u in pairs(units) do
				if(u.unit_name==tradeName)then
					tradex=u.x
					tradey=u.y
					break
				end
			end
		else
			goto begin
		end
		if(tradex ~=nil and tradey ~= nil)then
			移动到目标附近(tradex,tradey)
		else
			goto begin
		end
		转向坐标(tradex,tradey)		
		local items = 物品信息()
		tradeList="金币:20;物品:"
		hasData=false
		selfTradeCount=0
		for i,v in pairs(items) do		
			if v.pos > 7 and v.itemid == tgtItemID then
				if(hasData)then
					tradeList=tradeList.."|"..v.itemid.."|"..v.count.."|".."1"
				else
					tradeList=tradeList..v.itemid.."|"..v.count.."|".."1"			
				end
				selfTradeCount=selfTradeCount+1
				hasData=true
				if(selfTradeCount >= tradeBagSpace)then
					break
				end			
			end
		end	
		--日志(tradeList)
		if(hasData)then
			交易(tradeName,tradeList,"",10000)
		else				
			--下次说不定是哪个仓库 设置为nil
			tradeName=nil
			tradeBagSpace=nil
			tradePlayerLine=nil	
			--回城()
			return
		end		
	end
	goto begin
end


function main()
	日志("欢迎使用星落刷十年戒指脚本",1)
	日志("当前职业："..人物("职业"),1)
	日志("当前职称："..人物("职称"),1)
	common.baseInfoPrint()
	common.statisticsTime(脚本运行前时间,脚本运行前金币)	
	
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
::begin::	
	等待空闲()
	common.changeLineFollowLeader(队长名称)		--同步服务器线路	
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="追忆之路" )then	
		goto battle
	end	
	if(取包裹空格() < 5)then				--银行存满 然后给仓库
		common.gotoFalanBankTalkNpc()
		银行("全存","十周年纪念戒指")	
		等待(2000)
		if(取包裹空格() < 5)then
			tradeName=nil
			tradeBagSpace=nil
			if 取物品数量( "491322") > 0 then waitTopic("十年攻戒信息",491322) end
			if 取物品数量( "491323") > 0 then waitTopic("十年魔戒信息",491323) end	
		end
	end
	common.checkEquipDurable(0,sEquipHatName,20)
	common.checkEquipDurable(2,sEquipWeaponName,20)
	common.checkEquipDurable(1,sEquipClothesName,20)
	common.checkEquipDurable(4,sEquipShoesName,20)
	common.checkGold(身上最少金币,身上最多金币,身上预置金币)
	if(人物("金币") < 5000)then 
		日志("没有魔币了，脚本退出",1)
		return
	end
	if(取当前地图名() == "法兰城")then 回城() end
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)
	common.supplyCastle()
	common.sellCastle()		--默认卖	
	common.toCastle()
	自动寻路(30,81)
	对话选是(30,79)
	goto begin
        
::battle::
	if(是否战斗中())then 等待战斗结束() end
	if(isTeamLeader)then
		--加个判断 防止在最后 队友对话出去后 队长登出
		if leaderLastTalk() then goto begin end		
		--没有打过boss的 回城重新进入
		if(队伍("人数") < 队伍人数)then	--数量不足 等待
			if(目标是否可达(16,122))then
				自动寻路(16,122)
				common.makeTeam(队伍人数)
			else	--中途队友掉线 回城
				日志("中途队友掉线，回城",1)
				回城()	
				等待(2000)
			end	
		else
			for i,v in ipairs(bossData) do
				if(waitToNextBoss(v.name,v.x,v.y,v.nexty) == -1)then 			
					回城()
					goto begin
				end		
				if(队伍("人数") < 队伍人数) then	
					日志("中途队友掉线，回城",1)
					回城()	
					等待(2000)
					goto begin
				end				
			end			
			if leaderLastTalk() then goto begin end			
		end		
	else
		if(取队伍人数() > 1)then
			if(common.judgeTeamLeader(队长名称)==true) then
				teammateAction()
			else
				离开队伍()
			end		
		else
			if(目标是否可达(15,5))then	--出去				
				自动寻路(15,5)				
				对话选是(15,4)
				goto begin
			else
				if(目标是否可达(16,122) == false)then
					回城()
					goto begin
				end							
				等待(2000)
				common.joinTeam(队长名称)
			end
				
		end					
	end
	goto begin
end

function teammateAction()
	while true do
		if(取当前地图名() ~= "追忆之路")then
			return
		end
		if(取队伍人数() < 2 and 取当前地图名() == "追忆之路")then	
			if(目标是否可达(15,5))then	--出去		
				if(是否目标附近(15, 4) == false)then
					自动寻路(15,5)		
				end
				对话选是(15, 4)
			else
				回城()
				return
			end					
		end	
		if(是否目标附近(15, 4))then
			对话选是(15, 4)
		end			
		等待(3000)
	end
end
main()