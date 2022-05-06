启动点::艾尔莎,辛美尔 说明:　　目标遗留品的数量是以整队人来计算.并非一定要在一个人身上；同一种目标遗留品只算一个.一直打一处BOSS没有意义。奖品是随机发放的，并不是身上目标遗留品越多奖品就越好，也许你身上一件目标遗留品都没有，但换到了好奖品。 啊、注意（脚本会自动扔碎片） 队伍人数<1 逃跑
	
	
common=require("common")

设置("timer", 0)		
设置("高速延时", 3)	
设置("自动叠",1,"地的水晶碎片&999")
设置("自动叠",1,"水的水晶碎片&999")
设置("自动叠",1,"火的水晶碎片&999")
设置("自动叠",1,"风的水晶碎片&999")
for i=1,16 do
	设置("自动叠",1,"目标遗留品No"..i.."&99")	
end
设置("自动扔",1,"卡片？|魔石|地的水晶碎片|水的水晶碎片|火的水晶碎片|风的水晶碎片|魔族的水晶|曼陀罗草的皮|火焰之魂|妖草的血|风龙蜥的甲壳|狩猎高额奖金|狩猎奖金|精英奖章|狩猎纪念品|猎人奖章|硬币？|红铜的卡片|１怪物硬币|大蝙蝠的卡片|西比亚的卡片|甲虫的卡片")

local 补血值=取脚本界面数据("人补血")
local 补魔值=取脚本界面数据("人补魔")
local 宠补血值=取脚本界面数据("宠补血")
local 宠补魔值=取脚本界面数据("宠补魔")

if(补血值==nil or 补血值==0)then
	补血值=用户输入框("多少血以下补血", "100")
end
if(补魔值==nil or 补魔值==0)then
	补魔值 = 用户输入框("多少魔以下补魔", "100")
end
-- if(宠补血值==nil or 宠补血值==0)then
	-- 宠补血值 = 用户输入框( "宠多少血以下补血", "300")
-- end
-- if(宠补魔值==nil or 宠补魔值==0)then
	-- 宠补魔值=用户输入框( "宠多少魔以下补魔", "150")
-- end
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


设置("timer", 20)			--设定脚本运行速度间隔 单位是毫秒
设置("自动加血", 0)			--关闭自动加血，脚本对话加血 
local isTeamLeader=false	--是否队长
local 是否临时队长=false	--是否临时队长
local 走路加速值=110				--脚本走路中可以设定移动速度  到达目的地后，再还原值即可 不要超125  
local 走路还原值=100				--防止掉线 还原速度
local 身上最少金币=5000				--少于去取
local 身上最多金币=1000000			--大于去存
local 身上预置金币=500000			--取和拿后 身上保留金币
local 脚本运行前时间=os.time()		--统计效率
local 脚本运行前金币=人物("金币")	--统计金币
local isFirstRun=true				--是否第一次运行
local recordx=nil					--组队卡原地后 还原用
local recordy=nil					--组队卡原地后 还原用
local recordType=true				--移动到哪		
local 已刷狩猎总次数=0				--统计	
local 已刷壶总数=0					--统计
local 预置扔鸟档次=0				--0档以上仍 鸟用此选项
local 预置扔巨人档次=5				--5档以上扔
local 预置扔地雷档次=5				--0档以上仍
local 已刷宠物数量={
	["希特拉"]={count=0,msg="惊喜,您刷到了稀缺宠物【希特拉】,档次 ",grade=22},
	["泰坦巨人"]={count=0,msg="恭喜,您刷到了宠物【泰坦巨人】,档次 ",grade=预置扔巨人档次},
	["萨普地雷"]={count=0,msg="恭喜,您刷到了宠物【萨普地雷】,档次 ",grade=预置扔地雷档次},
	["托罗帝鸟"]={count=0,msg="恭喜,您刷到了个性宠物【托罗帝鸟】,档次 ",grade=预置扔鸟档次},
	["岩地跑者"]={count=0,msg="恭喜,您刷到了个性宠物【岩地跑者】,档次 ",grade=预置扔鸟档次}
	}		--希特拉 泰坦巨人 萨普地雷 托罗帝鸟 岩地跑者
local targetCondition={
	[1]={have=nil,dontHave=2,x=120,y=178,mapId=59959,exclude={}},
	[2]={have=nil,dontHave=3,x=208,y=226,mapId=59959,exclude={}},
	[3]={have=1,dontHave=4,x=297,y=181,mapId=59956,exclude={9}},
	[4]={have=1,dontHave=5,x=240,y=200,mapId=59956,exclude={}},
	[5]={have=1,dontHave=nil,x=201,y=183,mapId=59959,exclude={1}},
	[6]={have=2,dontHave=7,x=273,y=232,mapId=59958,exclude={}},
	[7]={have=3,dontHave=8,x=290,y=260,mapId=59959,exclude={}},
	[8]={have=3,dontHave=9,x=175,y=180,mapId=59956,exclude={3,13}},
	[9]={have=5,dontHave=10,x=250,y=115,mapId=59959,exclude={}},
	[10]={have=6,dontHave=11,x=163,y=135,mapId=59956,exclude={}},
	[11]={have=6,dontHave=12,x=205,y=294,mapId=59956,exclude={2,6}},
	[12]={have=8,dontHave=13,x=232,y=216,mapId=59958,exclude={}},
	[13]={have=9,dontHave=14,x=230,y=159,mapId=59958,exclude={}},
	[14]={have=9,dontHave=15,x=161,y=120,mapId=59958,exclude={}},
	[15]={have=9,dontHave=16,x=216,y=257,mapId=59959,exclude={}},
	[16]={have=11,dontHave=2,x=233,y=126,mapId=59956,exclude={9}}
}
local targetOrder={1,2,5,9,6,13,14,3,11,8,10,4,16,12,7,15}
local targetQuarryName="目标遗留品No"
local targetNumber={1,2,3,4,5,6,7,8,9,"A","B","C","D","E","F","G"}
local currentOrder=1
local 临时队长名称=队长名称			--挑选出来的队长 --临时队长名称
local syncTargetTbl={leaderName=队长名称,order=currentOrder,东=0,南=0,mapNum=59959,丢=0}

function 临时队长通知变更目标()
	syncTargetTbl.order=currentOrder	
	syncTargetTbl.丢=0	
	local transText=common.TableToStr(syncTargetTbl)
	
	--日志("转换表内容"..transText)
	if(isTeamLeader)then	--发给队员						
		for i,v in ipairs(队员列表) do
			发送邮件(v,transText)	
		end
		--等待(3000)	--等队友接收
	else
		发送邮件(队长名称,transText)	
		--等待(5000)	--等队长转发
	end
end

function 默认队长中转邮件()
	local bChangeLeader=false
	if(isTeamLeader)then
		for i,v in ipairs(队员列表) do
			mailData = 查看邮件(v,0)	
			if(mailData ~= nil and mailData.state == 1)then			
				更新邮件状态(mailData.index,0,0)	--已阅				
				--日志("收到"..v.." 邮件:"..mailData.msg)
				local tmpData = common.StrToTable(mailData.msg)
				--判断队长更换 切换目标等		
				if(tmpData == nil)then	--空或是字符串 直接发送自己的同步表
					if(mailData.msg == "同步数据")then
						local transTblData = common.TableToStr(syncTargetTbl)
						日志("同步数据："..transTblData.."Y:"..syncTargetTbl.南)
						发送邮件(v,transTblData)			
					end
				else										--判断队长更换 切换目标等							
					if(tmpData.leaderName ~= nil)then
						if(tmpData.leaderName ~= 临时队长名称)then
							临时队长名称=tmpData.leaderName
							syncTargetTbl.leaderName=临时队长名称	
							日志("变更队长："..临时队长名称)
							bChangeLeader=true
							if(临时队长名称 == 人物("名称",false))then
								是否临时队长=true
							else
								是否临时队长=false
							end
						end
					end
					if(tmpData.order ~= nil)then
						if(tmpData.order ~= currentOrder)then
							currentOrder=tmpData.order
							syncTargetTbl.order=currentOrder	
							--日志("调试"..currentOrder)
							if(currentOrder>=1 and currentOrder <= 16)then
								日志("当前第"..currentOrder.."/16步,目标"..targetOrder[currentOrder],1)
							elseif(currentOrder > 16)then
								日志("当前第"..currentOrder.."/16步,去换奖咯！",1)
							end
							bChangeLeader=true
						end
					end		
					
					if(tmpData.东 ~= nil)then
						if(tmpData.东 ~= syncTargetTbl.东)then
							syncTargetTbl.东=tmpData.东						
						end
					end		
					if(tmpData.南 ~= nil)then
						if(tmpData.南 ~= syncTargetTbl.南)then
							syncTargetTbl.南=tmpData.南						
						end
					end	
					if(tmpData.mapNum ~= nil)then
						if(tmpData.mapNum ~= syncTargetTbl.mapNum) then
							syncTargetTbl.mapNum=tmpData.mapNum						
						end
					end		
					if(tmpData.丢 ~= nil)then
						if(tmpData.丢 ~= syncTargetTbl.丢) then
							syncTargetTbl.丢=tmpData.丢						
						end
					end								
					--if(bChangeLeader)then	--等待解散队伍 重新组队
						--队员发送邮件 变更队长，通知其他队友							
						if(bChangeLeader)then
							日志("新队长名称"..临时队长名称)	
							日志("表：新队长名称"..syncTargetTbl.leaderName)	
						end
											
						local transText = common.TableToStr(syncTargetTbl)
						设置个人简介("简介",0,0,"卖",1,"买",2,"想",transText)	
						for n,tv in ipairs(队员列表) do	--发送全体队员 除了队长
							if(v ~= tv)then
								发送邮件(tv,transText)	
							end
						end						
					--end
							
				end				
			end	
		end
	end
	return bChangeLeader
end
function 队员检测和同步数据()
	local bChangeLeader=false
	if(isTeamLeader)then
		return 默认队长中转邮件()			
	else
		mailData = 查看邮件(队长名称,0)			
		if(mailData ~= nil and mailData.state == 1)then			
			更新邮件状态(mailData.index,0,0)	--已阅		
			--日志(mailData.msg)			
			local tmpData = common.StrToTable(mailData.msg)
			
			--判断队长更换 切换目标等			
			if(tmpData == nil or type(tmpData) == "string")then	--空或是字符串 		直接发送自己的同步表
				if(tmpData == "同步数据")then
					local transTblData = common.TableToStr(syncTargetTbl)
					发送邮件(队长名称,transTblData)			
				end
			else				
				if(tmpData.leaderName ~= nil)then
					if(tmpData.leaderName ~= 临时队长名称)then
						临时队长名称=tmpData.leaderName
						日志("变更队长："..临时队长名称)
						bChangeLeader=true
						syncTargetTbl.leaderName = 临时队长名称
						if(临时队长名称 == 人物("名称",false))then
							是否临时队长=true
						else
							是否临时队长=false
						end						
					end
				end
				if(tmpData.order ~= nil)then
					if(tmpData.order ~= currentOrder)then
						currentOrder=tmpData.order
						syncTargetTbl.order = currentOrder
						if(currentOrder>=1 and currentOrder <= 16)then
							日志("当前第"..currentOrder.."/16步,目标"..targetOrder[currentOrder],1)
						elseif(currentOrder > 16)then
							日志("当前第"..currentOrder.."/16步,去换奖咯！",1)
						end
						--日志("当前第"..currentOrder.."/16步,目标"..targetOrder[currentOrder],1)
					end
				end		
				if(tmpData.东 ~= nil)then
					if(tmpData.东 ~= syncTargetTbl.东)then
						syncTargetTbl.东=tmpData.东						
					end
				end		
				if(tmpData.南 ~= nil)then
					if(tmpData.南 ~= syncTargetTbl.南)then
						syncTargetTbl.南=tmpData.南						
					end
				end	
				if(tmpData.mapNum ~= nil)then
					if(tmpData.mapNum ~= syncTargetTbl.mapNum)then
						syncTargetTbl.mapNum=tmpData.mapNum						
					end
				end		
				if(tmpData.丢 ~= nil)then
					if(tmpData.丢 ~= syncTargetTbl.丢) then
						syncTargetTbl.丢=tmpData.丢		
						if(tmpData.丢 == 1 and currentOrder>= 1 and currentOrder <= 16)then
							checkCurrentTgtObjAndDrop(targetOrder[currentOrder])
							syncTargetTbl.丢=0
						end
					end
				end		
				
			end
		end	
	end
	return bChangeLeader
end

--第一版取聊天数据
function 字符串拆分取队长名称(sText,startText,endText)
	if(sText == nil or startText==nil)then return nil end
	local pos = string.find(sText, startText)
	if (not pos) then
		return nil
	end
	local sub_str = string.sub(sText, pos+string.len(startText))
	if(endText == nil)then
		return sub_str
	end
	--日志(sub_str)
	pos = string.find(sub_str, endText)
	if (not pos) then
		return sub_str
	end
	sub_str = string.sub(sub_str, 1, pos - 1)
	return sub_str
end

--检查队友是否有目标物
function checkTeammateItem(chatMsg)
	if(chatMsg==nil)then return false end
	local teamPlayers = 队伍信息()
	local teammateCount = common.getTableSize(teamPlayers)	
	for index,teamPlayer in ipairs(teamPlayers) do
		if(string.find(聊天(20),teamPlayer.name..": "..chatMsg)~=nil)then 
			return true
		end			
	end  
	return false	
end
--去目标物boss位置
function toTargetBoss(tgtNumber)
	if(tgtNumber == nil)then return false end
	local nextBoss = targetCondition[tgtNumber]
	if(nextBoss ~= nil)then
		toTargetMap(nextBoss.mapId)
		移动(nextBoss.x,nextBoss.y)
	end	
end

--扔当前冲突物
function checkCurrentTgtObjAndDrop(tgtNumber)	
	local curBoss = targetCondition[tgtNumber]	
	if(curBoss ~= nil)then
		if(curBoss.have== nil or 取物品数量(targetQuarryName..curBoss.have) >= 1)then	--有目标物 判断是否和后续冲突				
			if(curBoss.dontHave == nil)then
				return
			end
			if(取物品数量(targetQuarryName..curBoss.dontHave) >= 1)then
				日志("当前狩猎物"..tgtNumber.."和".. curBoss.dontHave.."有冲突，扔当前狩猎物品")
				扔(targetQuarryName..curBoss.dontHave)		
				checkAndSetSelfHaveItems()
			end					
		end
	end			
end

function 扔所有目标物()
	for i=1,16 do
		if(取物品数量(targetQuarryName..i) >= 1)then	--有目标物 判断是否和后续冲突			
			扔(targetQuarryName..i)				
		end
	end
end
--检查是否目标物，如果有并且和后面不冲突，则返回true否则 返回false
function checkCurrentTargetObjAndFilterDrop(tgtNumber)
	if(tgtNumber == nil)then return false end
	local curBoss = targetCondition[tgtNumber]
	local conflict=false
	local haveTgt=false
	if(curBoss ~= nil)then
		if(取物品数量(targetQuarryName..tgtNumber) >= 1)then	--有目标物 判断是否和后续冲突
			haveTgt=true
			for i,v in ipairs(curBoss.exclude) do				
				if(取物品数量(targetQuarryName..v) >= 1)then
					日志("当前狩猎物"..tgtNumber.."和".. v.."有冲突，扔当前狩猎物品")
					扔(targetQuarryName..tgtNumber)
					conflict=true
				end				
			end			
		end
	end		
	if(conflict)then 		--冲突 返回false
		return false		
	end
	if(haveTgt)then
		return true			--不冲突 有目标物 返回true
	end
	return false
end
--全局检测冲突
function globalCheckTargetConflict()
	--再加个所有检测 防止路过途中 打到boos 冲突
	local conflict=false
	for i=1,16 do
		if(i <= 16)then
			if(checkCurrentTargetObjAndFilterDrop(targetOrder[i]))then
				conflict=true
			end
		end
	end
	if(conflict==true)then 	--冲突 返回false
		return false
	else 
		return true 		--不冲突 有目标物 返回true
	end
end
--去指定地图
function toTargetMap(tgtMapNum)
	if(tgtMapNum == nil)then return end	
	local mapNumber = 取当前地图编号()
	if(mapNumber==tgtMapNum)then
		return
	end
	if(tgtMapNum == 59959)then
		if(mapNumber == 59956)then
			移动(334,214,59959)
		elseif(mapNumber == 59958)then			
			移动(301,250,59959)	
		end
	elseif(tgtMapNum == 59956)then
		if(mapNumber == 59959)then
			移动(54,194,59956)
		elseif(mapNumber == 59958)then
			移动(66,198,59956)		
		end
	elseif(tgtMapNum == 59958)then
		if(mapNumber == 59959)then
			移动(154,103,59958)
		elseif(mapNumber == 59956)then
			移动(196,65,59958)		
		end
	end		
end
--检查自身拥有的目标物
function checkSelfHaveItems()
	local haveList=''
	for i,v in pairs(targetNumber) do
		local newName=targetQuarryName..i	 
		if(取物品数量(newName) >0)then
			haveList=haveList..v
		end
	end
	return haveList
end
--检查自身目标物并设置个人简介
function checkAndSetSelfHaveItems()
	local haveList = checkSelfHaveItems()
	设置个人简介("玩家称号",haveList)
end

--检查狩猎物总数量 这个赋值 在remove过程中，会连带原始targetNumber清除
function leaderCheckTotal()
	local newTargetNumberList=targetNumber
	local teamPlayers = 队伍信息()	
	for index,teamPlayer in ipairs(teamPlayers) do	
		if(teamPlayer.is_me ~= 0)then			
			local tblSize=common.getTableSize(newTargetNumberList)
			if(teamPlayer.nick_name ~= nil)then
				for i=tblSize,1,-1 do
					if(string.find(teamPlayer.nick_name,newTargetNumberList[i]) ~= nil)then
						table.remove(newTargetNumberList,i)						
					end			
				end			
			end		
		end
	end	
	local selfItems = checkSelfHaveItems()
	local tblSize=common.getTableSize(newTargetNumberList)
	for i=tblSize,1,-1 do
		if(string.find(selfItems,newTargetNumberList[i]) ~= nil)then
			table.remove(newTargetNumberList,i)			
		end			
	end			
	if(common.getTableSize(newTargetNumberList) == 0)then
		return true
	end
	return false	
end

--检测队友是否有指定目标物
function checkTeamHaveTgtNumber(tmpTgtNum)
	if (tmpTgtNum == nil) then 
		--日志("Check TgtNum 为nil,当前第"..targetOrder[currentOrder])
		return false 
	end
	等待空闲()
	--日志("检查队伍是否有目标物,编码："..tmpTgtNum)
	local teamPlayers = 队伍信息()	
	for index,teamPlayer in ipairs(teamPlayers) do	
		if(teamPlayer.is_me == 0)then	--0 队员 1队长
			--日志(teamPlayer.name)				
			if(teamPlayer.nick_name ~= nil)then	
				--日志(teamPlayer.name.." Title:"..teamPlayer.nick_name)
				if(string.find(teamPlayer.nick_name,tmpTgtNum) ~= nil)then
					return true					
				end						
			end		
		end
	end	
	local selfItems = checkSelfHaveItems()	
	if(string.find(selfItems,tmpTgtNum) ~= nil)then
		return true
	end	
	return false		
end
--返回当前队伍中 血量最少的值 用来判断是否回城
function 队友当前血最少值()
	local teamPlayers = 队伍信息()
	local hpVal=88888
	for i,teamPlayer in ipairs(teamPlayers) do
		if(hpVal > teamPlayer.hp)then hpVal = teamPlayer.hp end
	end
	return hpVal
end
--固定判断
-- function 判断是否需要回补()
	-- local minHp=队友当前血最少值()
	-- if(minHp~= 88888 and minHp ~= 0 and  minHp <= 1)then	
		-- 日志("队友血量过低"..minHp.."，回补！",1)				
		-- 停止遇敌()
		-- return true
	-- end			
	-- return false
-- end
--全体队员 血魔 受伤   判断不了宠物  受伤暂时没加，可以加这里 回到辛梅尔后 自己医生治疗
function 判断是否需要回补()
	local teamPlayers = 队伍信息()
	for i,t in ipairs(teamPlayers) do
		if(t.hp ~= 0 and  t.hp < 补血值) then 
			日志("队友".. t.name .."血量过低"..t.hp.."，回补！",1)				
			停止遇敌()
			return true
		end
		if(t.mp ~= 0 and  t.mp < 补魔值) then 
			日志("队友".. t.name .."魔量过低"..t.mp.."，回补！",1)			
			停止遇敌()
			return true
		end	
	end	
	return false
end
--看队友谁有目标物 获取他的名称
function getNameFromTeamHaveTgtNumber(tgtNum,dontHave)
	if tgtNum == nil and dontHave == nil then return 人物("名称",false) end
	等待空闲()
	--优先检测自己
	local selfItems = checkSelfHaveItems()	
	if(tgtNum==nil or string.find(selfItems,tgtNum) ~= nil)then
		if(dontHave==nil or string.find(selfItems,dontHave) == nil)then
			return 人物("名称",false)					
		end		
	end	
	--日志("检查队伍是否有目标物："..tgtNum)
	local teamPlayers = 队伍信息()	
	for index,teamPlayer in ipairs(teamPlayers) do	
		if(teamPlayer.is_me == 0)then	--0 队员 1队长						
			if(teamPlayer.nick_name ~= nil)then	
				--日志(teamPlayer.name.." Title:"..teamPlayer.nick_name)
				if(tgtNum==nil or string.find(teamPlayer.nick_name,tgtNum) ~= nil)then			--有 持有物
					if(dontHave==nil or string.find(teamPlayer.nick_name,dontHave) == nil)then	--没有 未持有物
						return teamPlayer.name					
					end
				end						
			end		
		end
	end	
	
	return nil
end

function 通知全体队员(mailMsg)
	if(mailMsg == nil)then return false end
	if(isTeamLeader)then			
		for i,v in ipairs(队员列表) do
			发送邮件(v,mailMsg)	
		end
	else
		发送邮件(队长名称,mailMsg)
	end
	return true
end

function 开壶()
	if(取当前地图编号() ~= 59959)then	--包裹没有2个空格 是过不去的
		return 
	end
	checkAndSetSelfHaveItems()
	currentOrder=1
	if(isTeamLeader)then
		syncTargetTbl.leaderName=人物("名称",false)
		临时队长名称=人物("名称",false)
		是否临时队长 = true					
	else
		syncTargetTbl.leaderName=队长名称
		临时队长名称=队长名称
		是否临时队长 = false
	end
	syncTargetTbl.东 = 210
	syncTargetTbl.南 = 271
	syncTargetTbl.mapNum=59959	
	syncTargetTbl.order=currentOrder
	local hasPot=0
	if(取物品数量("不可思议的壶") > 0)then
		已刷壶总数=已刷壶总数+1
		hasPot=1
		日志("获得了不可思议的壶，开奖咯！")
		local oldPetList=全部宠物信息()
		if(common.getTableSize(oldPetList) >= 5)then
			日志("自动开奖失败，宠物已满，请至少预留一个空位!")
		else
			使用物品("不可思议的壶")
			等待服务器返回()
			对话选择(4,-1)
			等待(1000)
			local newPetList = 全部宠物信息()
			local newPet = 取新开出的宠信息(oldPetList,newPetList)
			if(newPet ~= nil)then			
				for i,v in pairs(已刷宠物数量) do
					if(newPet.realname == i)then	
						v.count = v.count + 1
						if(newPet.grade == nil)then
							日志(v.msg .. "未知")							
						else
							日志(v.msg .. newPet.grade)
							if(newPet.grade > v.grade)then
								日志("档次低于设定值，丢弃")
								扔宠(newPet.index)
							end
						end
						break
					end
				end				
			end
		end	
	end
	common.statisticsTime(脚本运行前时间,脚本运行前金币)	
	已刷狩猎总次数=已刷狩猎总次数+1
	日志("已刷狩猎次数："..已刷狩猎总次数.."次，刷到不可思议的壶总数:"..已刷壶总数.."，本次刷壶数量："..hasPot,1)
	local msgCount="各宠物数量分别为："	
	for i,v in pairs(已刷宠物数量) do			
		msgCount=msgCount..i.."："..v.count.." "		
	end
	日志(msgCount)
end

function 取新开出的宠信息(oldPetList,newPetList)
	if(oldPetList ==nil or newPetList ==nil )then return nil end
	local findNewPet=false
	for i,n in ipairs(newPetList) do
		findNewPet=false
		for j,o in ipairs(oldPetList) do
			if(n.index == o.index)then
				findNewPet=true
				break
			end
		end
		if(findNewPet==false)then
			return n
		end
	end		
	return nil
end


function 跑王冠()
设置("遇敌全跑", 1)
::kaishi::	
	等待空闲()
	当前地图名=取当前地图名()	
	if(当前地图名=="雪拉威森塔９６层")then	
		goto T96
	elseif(当前地图名=="雪拉威森塔９７层")then		
		goto T97
	elseif(当前地图名=="雪拉威森塔９８层")then		
		goto T98
	elseif(当前地图名=="雪拉威森塔９９层")then		
		goto T99
	elseif(当前地图名=="雪拉威森塔最上层")then		
		goto T100
	elseif(当前地图名=="雪拉威森塔前庭")then		
		goto T101
	end
	common.healPlayer(doctorName)
	common.recallSoul()
	common.supplyCastle()
	if(人物("血") < 1000)then goto  lookbu end
	if(人物("魔") < 300)then goto  lookbu end
	--if(宠物("血") < 宠补血值)then goto  lookbu end
	--if(宠物("魔") < 宠补魔值)then goto  lookbu end
	if(取物品数量("塞特的护身符") > 0)then goto  saite end
	if(取物品数量("梅雅的护身符") > 0)then goto  meiya end
	if(取物品数量("提斯的护身符") > 0)then goto  tisi end
	if(取物品数量("伍斯的护身符") > 0)then goto  wusi end
	if(取物品数量("尼斯的护身符") > 0)then goto  nisi end
	if(当前地图名=="艾尔莎岛")then		
		goto 雪拉威森塔
	end
	回城()
	goto kaishi
::雪拉威森塔::	
	移动(165, 153)	
	转向(4)
	等待服务器返回()	
	对话选择(32,0)
	等待服务器返回()
	对话选择(4, 0)	
	等待到指定地图("利夏岛")		
	移动(90,99,"国民会馆")
	移动(108, 54)	
	回复(0)		
	移动(108, 39)	
	等待到指定地图("雪拉威森塔１层")		
	移动(75, 50)	
	等待到指定地图("雪拉威森塔５０层")		
	移动(16, 44)	
	等待到指定地图("雪拉威森塔９５层")	
	移动(26, 104)
	移动(27, 104)		
	转向(2)
	等待服务器返回()	
	对话选择("32", "", "")	
	对话选择("4", "", "")	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９６层")		
	goto lookbu
	
::saite::	
	使用物品("塞特的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９５层")		
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９６层")	
	goto kaishi
::T96::
	移动(86, 120)
	移动(87, 119)			
	转向(1, "")
	等待服务器返回()	
	对话选择("32", "", "")	
	等待服务器返回()	
	对话选择("32", "", "")	
	等待服务器返回()	
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９７层")		
	goto lookbu
::meiya::	
	使用物品("梅雅的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９６层")	
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９７层")	
	goto kaishi
::T97::
	移动(117, 126)	
	转向(0, "")
	等待服务器返回()	
	对话选择("32", "", "")	
	对话选择("32", "", "")	
	对话选择("32", "", "")	
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９８层")		
	goto lookbu
::tisi::	
	使用物品("提斯的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９７层")	
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９８层")	
	goto kaishi	
::T98::	
	移动(120, 121)		
	转向(0, "")
	等待服务器返回()	
	对话选择("32", "", "")	
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９９层")	
	goto lookbu	
::wusi::	
	使用物品("伍斯的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９８层")		
	转向(0)
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９９层")		
	goto kaishi
::T99::
	移动(101, 55)		
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔最上层")		
	goto lookbu
::nisi::	
	使用物品("尼斯的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９９层")		
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔最上层")	
	goto kaishi
::T100::	
	移动(103, 134)	
	等待到指定地图("雪拉威森塔前庭")	
	goto kaishi
::T101::	
	移动(103, 19)		
::jiance::
	goto wangguan	
::wangguan::
	等待(300)	
	喊话("男",2,3,4)
	等待服务器返回()
	对话选择(1,0)
	goto dengdai 

::dengdai::
	等待到指定地图("国民会馆")	
	等待(200)
	if(取物品数量("王冠") > 0)then goto  qucun end			
	goto kaishi 
::lookbu::
	needSupply = false
	if(人物("血") < 人物("最大血") or 人物("魔") < 人物("最大魔")) then
		needSupply=true
	end
	if(宠物("血") < 宠物("最大血") or 宠物("魔") < 宠物("最大魔")) then
		needSupply=true
	end
	if(needSupply == false)then
		goto kaishi
	end
	回城()
	等待到指定地图("艾尔莎岛")	
	转向(1)
	等待服务器返回()
	对话选择(4,0)	
	等待到指定地图("里谢里雅堡")		
	移动(34, 89)	
	回复(1)	
	common.healPlayer(doctorName)
	common.recallSoul()
	等待(2000)
	goto kaishi 
::qucun::
   	回城()
   	等待到指定地图("艾尔莎岛")   
设置("遇敌全跑", 0)
end

function main()
	日志("欢迎使用星落狩猎脚本",1)
	日志("当前职业："..人物("职业"),1)
	日志("当前职称："..人物("职称"),1)
	common.baseInfoPrint()
	common.statisticsTime(脚本运行前时间,脚本运行前金币)
	if(人物("名称",false) == 队长名称)then
		日志("当前是队长",1)
		isTeamLeader = true
		是否临时队长 = true	
	else
		isTeamLeader = false
		是否临时队长 = false
		日志("当前是队员",1)
	end
	日志("队长名称："..队长名称.." 角色名称:" .. 人物("名称",false))
	common.changeLineFollowLeader(队长名称)		--同步服务器线路
	设置("移动速度",走路加速值)	-- 掉线的自己关闭加速就行
	syncTargetTbl.leaderName=队长名称
	syncTargetTbl.order=currentOrder
	清除系统消息()		
::begin::	
	等待空闲()
	common.checkHealth()
	mapNum=取当前地图编号()
	mapName=取当前地图名()
	if(mapName == "公寓")then goto 补魔 end 
	if(mapName == "辛梅尔")then goto 开始 end 
	if(mapName == "艾尔莎岛")then goto 出发 end
	if(mapName=="国民会馆" )then goto 国民会馆	end	
	if(mapName == "光之路")then goto map59505 end 
	if(mapNum == 59801 )then goto map59801 end	--雪塔一层
	if(mapNum == 59959)then goto map59959 		--圣炎高地
	elseif(mapNum == 59956)then goto map59956
	elseif(mapNum == 59958)then goto map59958	
	end		
	common.checkCrystal(水晶名称)
	回城()
	等待(2000)
	goto begin 
::map59505::		--光之路	
	移动(199,94)
	-- if(isTeamLeader and 队伍("人数") > 1)then	--补血回来 原地集合
		-- syncTargetTbl.东 = 210
		-- syncTargetTbl.南 = 271
		-- local transText=common.TableToStr(syncTargetTbl)
		-- 通知全体队员(transText)	--初始坐标集合
	-- end
	对话选是(200,95)	
	等待到指定地图("59959")
	移动(210,271)
	if(取物品数量("猎人证") < 1)then	--623000		
		对话选是(211,271)
	end	
	goto begin
::map59956::		--圣炎高地
	goto map59959	
::map59958::		--圣炎高地		--北区  换奖也在这
	if(目标是否可达(208,340))then	--换奖 1-5
		移动(208,340)
		扔所有目标物()
		对话选是(209,339)		
		开壶()
		goto 回辛梅尔
	end
	if(目标是否可达(179,309))then	--换奖 1-5
		移动(178,309)
		扔所有目标物()
		对话选是(179,309)		
		开壶()
		goto 回辛梅尔
	end
	if(目标是否可达(148,279))then	--换奖 12-15
		移动(148,279)
		扔所有目标物()
		对话选是(149,279)
		开壶()
		goto 回辛梅尔
	end	
	if(目标是否可达(118,249))then	--换奖 16
		移动(118,249)
		扔所有目标物()
		对话选是(2)
		开壶()	
		goto 回辛梅尔
	end
	goto map59959		
::map59959::		--圣炎高地	
	if(取物品数量("猎人证") < 1)then	--623000	
		离开队伍()		
		移动(210,271)
		对话选是(211,271)		
	end
	if(是否临时队长)then		
		if(队伍("人数") < 队伍人数)then	--数量不足 等待					
			syncTargetTbl.leaderName=临时队长名称			
			syncTargetTbl.order=currentOrder			
			syncTargetTbl.东,syncTargetTbl.南 = 取当前坐标()
			syncTargetTbl.mapNum=取当前地图编号()		
			--第一版 队长掉线后 让队员过来找队长 先不从队员那取数据			
			if(队员检测和同步数据())then
				离开队伍()
				goto begin
			end
			--common.makeTeam(队伍人数)
			local transText=common.TableToStr(syncTargetTbl)
			--日志("转换表内容"..transText)
			-- if(isTeamLeader and isFirstRun)then	--默认队长 第一次运行 说明掉线 全体重新组队
				-- isFirstRun=false
				-- for i,v in ipairs(队员列表) do
					-- 发送邮件(v,transText)	
				-- end
			-- end
			通知全体队员(transText)	--定时发送 初始坐标集合
			--这里来回走动下，防止卡住后 队友加不上队伍
			if(recordx == nil or recordy ==nil)then
				recordx = syncTargetTbl.东
				recordy = syncTargetTbl.南				
			else
				if(recordType)then
					移动(recordx,recordy)
					recordType=false
				else
					移动到目标附近(recordx,recordy,1)
					recordType=true
				end				
			end			
			等待(10000)	--等队友接收
		else
			if(isTeamLeader and isFirstRun)then
				isFirstRun=false
			end
			recordx = nil
			recordy = nil 
			goto loopCheck
		end
	else
		if(取队伍人数() > 1)then
			if(common.judgeTeamLeader(临时队长名称)==true) then
				goto teammateAction
			else
				离开队伍()
			end				
		end		
		--去下个目标点过程中，如果队长掉线，全部队员会回退到上一个Boss点
		队员检测和同步数据()		
		--日志("加入队伍，队长名称："..临时队长名称)
		if(syncTargetTbl.东 ==0 and syncTargetTbl.南 == 0)then
			mailData = 查看邮件(队长名称,0)			
			if(mailData ~= nil and mailData.state == 0)then			
				发送邮件(队长名称,"同步数据")
			end
			等待(5000)
			队员检测和同步数据()
		else					
			toTargetMap(syncTargetTbl.mapNum)
			if(是否目标附近(syncTargetTbl.东,syncTargetTbl.南,10) == false)then				
				日志("移动到队长附近 东："..syncTargetTbl.东.." 南："..syncTargetTbl.南)
				移动( tonumber(syncTargetTbl.东),tonumber(syncTargetTbl.南))				
			end	
			if(syncTargetTbl.leaderName ~= 人物("名称",false))then
				加入队伍(临时队长名称)
			end
			--common.joinTeam(临时队长名称)
		end		
	end	
	goto begin
::teammateAction::	
	等待空闲()		
	--if(currentOrder >= 1 and currentOrder <= 16)then		
		if(checkCurrentTargetObjAndFilterDrop(targetOrder[currentOrder]) == true)then
			日志("获得目标物:"..targetOrder[currentOrder],1)	--喊话 通知队友				
			checkAndSetSelfHaveItems()
		end
		--路过打死boss 扔物品
		if(globalCheckTargetConflict() == true)then			
			checkAndSetSelfHaveItems()
		end
		if(队伍("人数") < 2)then
			goto begin
		end		
		if(队员检测和同步数据())then
			goto begin					
		end		
	-- else
		-- toTargetMap(59959)
		-- 移动(206,267)
		-- 对话选是(207,267)
	--end
	if(取当前地图编号() == 59556 and 是否目标附近(89,57))then
		回复(89,57)	
	end
	等待(1000)
	goto teammateAction	

::loopCheck::
	--组队 检查总数
	if(判断是否需要回补())then		
		停止遇敌()
		goto 回辛梅尔
	end		
	if(currentOrder > 16)then	--16个达标
		日志("已刷满16个，去换奖咯！",1)
		toTargetMap(59959)
		移动(206,267)
		对话选是(207,267)
	else		--刷剩余的
		if(是否空闲中())then
			if(checkCurrentTargetObjAndFilterDrop(targetOrder[currentOrder])==true)then
				停止遇敌()
				checkAndSetSelfHaveItems()		
			end
			--路过打死boss 扔物品
			if(globalCheckTargetConflict() == true)then			
				checkAndSetSelfHaveItems()
			end
		end
		if(currentOrder >= 1 and currentOrder <= 16)then
			日志("当前第"..currentOrder.."/16步,检查队伍是否有目标物"..targetOrder[currentOrder],1)		
			临时队长通知变更目标()
			if(队伍("人数") ~= 队伍人数) then 
				goto begin
			end
			--检查队伍目标物
			if(checkTeamHaveTgtNumber(targetNumber[targetOrder[currentOrder]])==false)then
				日志("没有目标物："..targetOrder[currentOrder].."，去目标Boss位置")
				日志("当前第"..currentOrder.."/16步,目标"..targetOrder[currentOrder],1)
				
				toTargetBoss(targetOrder[currentOrder])	
				
				local nextBoss = targetCondition[targetOrder[currentOrder]]
				if(nextBoss == nil)then
					return nil
				end	
				local needHave = targetNumber[nextBoss.have]
				local dontHave = targetNumber[nextBoss.dontHave]	
				--获取新队长
				local tmpNewLeaderName = getNameFromTeamHaveTgtNumber(needHave,dontHave)				
				if(tmpNewLeaderName ~= nil and tmpNewLeaderName == 人物("名称",false))then
					--队长不变
					日志("下一轮队长名称"..tmpNewLeaderName,1)
					开始遇敌()
					while checkTeammateItem("获得目标物:"..targetOrder[currentOrder])==false do
						if(判断是否需要回补())then		
							停止遇敌()
							移动到目标附近(取当前坐标(),3)
							goto 回辛梅尔
						end					
						--日志("当前第"..currentOrder.."个顺序目标")
						等待(1000)						
						if(是否空闲中())then
							if(checkCurrentTargetObjAndFilterDrop(targetOrder[currentOrder]))then
								日志("获得目标物:"..targetOrder[currentOrder],1)	
								checkAndSetSelfHaveItems()		
							end
							if(globalCheckTargetConflict() == true)then			
								checkAndSetSelfHaveItems()
							end
						end								
						if(nextBoss ~= nil )then
							if(是否目标附近(nextBoss.x,nextBoss.y,10)==false)then
								停止遇敌()
								移动到目标附近(取当前坐标(),3)
								toTargetBoss(targetOrder[currentOrder])	
								break
							end							
						end	
						if(队伍("人数") ~= 5)then
							break
						end
					end		
					停止遇敌()
					if(checkTeammateItem("获得目标物:"..targetOrder[currentOrder]))then
						日志("已经有目标物【"..targetOrder[currentOrder].."】继续下一个",1)
						停止遇敌()
						currentOrder=currentOrder+1		
						if(currentOrder <= 16)then
							日志("下一目标物【"..targetOrder[currentOrder].."】",1)
						end
					end
				elseif(tmpNewLeaderName ~= nil )then
					日志("新队长名称"..tmpNewLeaderName)
					syncTargetTbl.leaderName=tmpNewLeaderName
					
					日志("表：新队长名称"..syncTargetTbl.leaderName)
					
					syncTargetTbl.order=currentOrder
					syncTargetTbl.丢=0
					syncTargetTbl.东,syncTargetTbl.南 = 取当前坐标()
					syncTargetTbl.mapNum=取当前地图编号()				
					if(tmpNewLeaderName==人物("名称",false))then
						是否临时队长 = true
					else
						是否临时队长 = false
					end
					临时队长名称 = tmpNewLeaderName
					local transText=common.TableToStr(syncTargetTbl)
					--日志("转换表内容"..transText)
					if(isTeamLeader)then	--发给队员						
						for i,v in ipairs(队员列表) do
							发送邮件(v,transText)	
						end
						等待(8000)	--等队友接收
					else
						发送邮件(队长名称,transText)	
						等待(8000)	--等队长转发
					end
					离开队伍()
					goto begin
				else	--目标物冲突 通知队友扔当前冲突目标物
					syncTargetTbl.丢=1
					local transText=common.TableToStr(syncTargetTbl)
					--日志("转换表内容"..transText)
					if(isTeamLeader)then	--发给队员						
						for i,v in ipairs(队员列表) do
							发送邮件(v,transText)	
						end
						等待(8000)	--等队友接收
					else
						发送邮件(队长名称,transText)	
						等待(8000)	--等队长转发
					end
				end
			else
				日志("已经有目标物【"..targetOrder[currentOrder].."】继续下一个",1)
				停止遇敌()
				currentOrder=currentOrder+1		
				if(currentOrder <= 16)then
					日志("下一目标物【"..targetOrder[currentOrder].."】",1)
				end
			end			
		else
			currentOrder=1
		end		
	end	
	goto begin
::回辛梅尔::	
	common.checkHealth()		--受伤登出  否则 走回去回补
	toTargetMap(59959)
	移动(209,330,"光之路")		
	移动(201, 19,"辛梅尔")		
	移动(191,99)	
	goto 开始 
::出发::	
	if(取物品数量("王冠") < 1)then		
		common.gotoBankTalkNpc()
		银行("取物","王冠",1)
		等待(2000)
		if(取物品数量("王冠") < 1)then
			日志("脚本需要王冠，如果没有的话，请走到辛美尔在启动",1)		
			跑王冠()
			等待(2000)
			goto begin
		else
			回城()
			goto begin
		end
	end
	移动(165,153)	
	转向(4)
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("利夏岛")	
	移动(90,99,"国民会馆")	
::国民会馆::
	移动(108,39,"雪拉威森塔１层")
::map59801::
	移动(34,95)	
	转向(2)
	等待服务器返回()	
	对话选择("4", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
::开始::		
	if(取当前地图名() ~= "辛梅尔")then
		等待(2000)
		goto begin
	end
	移动(181,81,"公寓")	
	移动(93,58)   	
::补魔::			
	移动(91,58)   
	if(是否临时队长)then
		移动(88,58)   
		移动(90,58) 
		移动(88,58)   
	else
		移动(88,58)   		
	end
	回复(89,57)	
	common.checkGold(身上最少金币,身上最多金币,身上预置金币)	
	日志("人物金币："..人物("金币"))
	if(宠物("健康") > 0) then	
		离开队伍()
		移动(86,60)		
		转向坐标(86,59)
		等待服务器返回()
		对话选择(-1,6)		
	end
	移动(100,70,"辛梅尔")	 	
	移动(207,91,"光之路")			
	goto begin       
::回补::		
	停止遇敌()	
	common.checkHealth()
	移动(201, 19,"辛梅尔")		
	移动(191,99)
	goto 开始 
end

main()