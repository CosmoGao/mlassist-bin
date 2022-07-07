刷神之金脚本

common=require("common")
设置("timer",20)
设置("自动扔",1,"魔石|奇香木|秘文之皮|星之砂|誓言的烛台|卡片？|绿头盔|红头盔")
设置("自动叠",1,"地的水晶碎片&999")
设置("自动叠",1,"水的水晶碎片&999")
设置("自动叠",1,"火的水晶碎片&999")
设置("自动叠",1,"风的水晶碎片&999")
设置("自动叠",1,"神之金&20")


local 上次迷宫楼层=1
local 当前迷宫楼层=1


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
local 已刷神之金次数=0				--统计总数


local tradeName=nil
local tradeBagSpace=nil
local tradePlayerLine=nil			--仓库人物当前线路

local topicList={"神之金信息"}
订阅消息(topicList)

function waitTopic(tgtTopic,tgtItemID,tgtCount)
	
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
			if v.pos > 7 and v.itemid == tgtItemID and v.count==tgtCount then
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
		--teammateAction()
	end		
	local mapNum=0
	local mapName=""
::begin::	
	等待空闲()
	common.changeLineFollowLeader(队长名称)		--同步服务器线路		
	mapName = 取当前地图名()
	mapNum = 取当前地图编号()
	if(string.find(mapName,"废墟地下") ~= nil)then
		goto crossMaze	
	elseif(mapNum==100)then goto map100			--芙蕾雅
	elseif(mapNum==27001)then goto map27001		--曙光骑士团营地
	elseif(mapNum==27014)then goto map27014		--辛希亚探索指挥部
	elseif(mapNum==27015)then goto map27015		--辛希亚探索指挥部
	elseif(mapNum==27101)then goto map27101		--辛希亚探索指挥部	
	elseif(mapNum==44707)then goto map44707		--遗迹	
	elseif(mapNum==44708)then goto map44708		--研究室		
	else
		common.checkGold(身上最少金币,身上最多金币,身上预置金币)
		if(人物("金币") < 5000)then 
			日志("没有魔币了，脚本退出",1)
			return
		end
		if(取包裹空格() < 5)then				--银行存满 然后给仓库
			common.gotoFalanBankTalkNpc()
			银行("全存","神之金",20)	
			等待(2000)
			if(取包裹空格() < 5)then
				tradeName=nil
				tradeBagSpace=nil
				if 取物品数量( "神之金") > 0 then waitTopic("神之金信息",35256,20) end			
			end
		end
		common.checkHealth()
		common.checkCrystal()
		common.supplyCastle()
		common.sellCastle()			--默认卖			
		if(isTeamLeader)then		--队长拿信
			if(取物品数量("怪物碎片") > 0) then
				扔("怪物碎片")		
			end		
			if(取物品数量("承认之戒") > 0)then
				扔("承认之戒")				
			end	
			if(取物品数量("信") > 0)then
				扔("信")				
			end
			if (取物品数量("团长的证明") > 0 or 取物品数量("信笺") > 0) then
				if(队伍("人数") < 队伍人数)then
					if(取当前地图名() ~= "里谢里雅堡")then common.toCastle() end
					移动(41,82)	
					common.makeTeam(队伍人数)
					if(队伍("人数") < 队伍人数) then
						--防止异次元 切图
						移动(41,98,"法兰城")
						移动(153,100,"里谢里雅堡")
					end
				else
					common.outFaLan("s")
				end										
			else							
				common.toCastle("f3")		
				对话坐标选是(5,3)		
			end		
		else
			if(取当前地图名() ~= "里谢里雅堡")then common.toCastle() end
			移动(40,82)	
			common.joinTeam(队长名称,10)
			if(取队伍人数() > 1)then
				if(common.judgeTeamLeader(队长名称)==false) then				
					离开队伍()
				else
					TemmateAction()
				end		
			else		--防止异次元 切图
				移动(41,98,"法兰城")
				移动(153,100,"里谢里雅堡")				
			end			
		end	
	end	
	等待(1000)
	goto begin	
::map100::
	移动(513,282,"曙光骑士团营地")	
::map27001::			--曙光骑士团营地
	if isTeamLeader then
		if 取物品数量("团长的证明") > 0 then
			移动(55,47)
		elseif(取物品数量("信笺") > 0)then
			移动(52,68,"曙光营地指挥部")	
			if(目标是否可达(69,70))then
				移动(69,70)
			end	
			if(目标是否可达(95,7))then
				移动(95,6)
				对话选是(95,7)
			end	
		else	--有问题 回去拿信去
			回城()
			goto begin
		end		
	else
		移动(55,47)
	end
::map27014::			--辛希亚探索指挥部
	if(目标是否可达(7,4))then
		移动(7,4)
	end		
	if(目标是否可达(95,9))then
		移动(95,9)
	end		
	goto begin
::map27015::			--曙光营地指挥部
	if 取物品数量("团长的证明") > 0 then
		if(目标是否可达(85,2))then
			移动(85,2)
		end		
		if(目标是否可达(53,79))then
			移动(53,79)
		end			
	elseif(取物品数量("信笺") > 0)then
		if(目标是否可达(69,70))then
			移动(69,70)
		end	
		if(目标是否可达(95,7))then
			移动(95,6)
			对话选是(95,7)
		end	
	end
		移动(55,47,"辛希亚探索指挥部")
	goto begin
::map27101::			--辛希亚探索指挥部	
	if isTeamLeader then	
		if(目标是否可达(44,22)==false)then	--迷宫传出				
			对话坐标选是(40,22)		
		end	
		移动到目标附近(44,22)
		移动(44,22,"废墟地下1层")				
		goto crossMaze		
	else
		if(队伍("人数") < 2)then 回城() end
	end
	goto begin		
::map44707::
	if(取队伍人数() < 3)then		--队友掉线回城
		回城()	
		goto begin		
	end
	移动(15,14)
	对话选是(6)
	等待(2000)
	等待空闲()
	goto begin
::map44708::
	回城()
	common.statisticsTime(脚本运行前时间,脚本运行前金币)	
	已刷神之金次数=已刷神之金次数+1
	日志("包裹现有神之金数量："..取物品叠加数量("神之金").."个，已刷神之金次数"..已刷神之金次数,1)		
	等待(3000)
	goto begin
::crossMaze::	
	if(isTeamLeader)then				--队长穿越迷宫
		--自动穿越迷宫()	
		mapName=取当前地图名()		
		if(string.find(mapName,"废墟地下") == nil) then	
			goto begin	
		end
		当前迷宫楼层=取当前楼层(mapName)	--从地图名取楼层
		if(当前迷宫楼层 < 上次迷宫楼层 )then	--反了
			--取最近迷宫坐标
			移动(取迷宫远近坐标(false))		
			当前迷宫楼层=取当前楼层(取当前地图名())	
		end	
		上次迷宫楼层=当前迷宫楼层
		自动迷宫()
		等待(1000)
	else
		if(取队伍人数() < 2)then		--队友掉线回城
			回城()			
		end
		等待(5000)
	end
	goto begin
end
function TemmateAction()
	local mapName=取当前地图名()
	local mapNum = 取当前地图编号()
	while true do
		mapName=取当前地图名()
		mapNum = 取当前地图编号()
		if(mapNum==44708)then 
			回城()
			common.statisticsTime(脚本运行前时间,脚本运行前金币)	
			已刷神之金次数=已刷神之金次数+1
			日志("包裹现有神之金数量："..取物品叠加数量("神之金").."个，已刷神之金次数"..已刷神之金次数,1)		
			等待(3000)
			return
		end
		if(队伍("人数") < 2)then 
			回城()
			return
		end
		等待(5000)
	end
end
main()