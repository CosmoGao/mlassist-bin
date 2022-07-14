▲神域的使者 ::启动点::艾尔莎,公寓  光之路  辛梅尔  此为王冠脚本，队长和队员换片	
	
	
common=require("common")
	
设置("高速延时", 3)	
设置("timer",20)
设置("自动扔",1,"达杰乌鲁姆的卡片|１０怪物硬币|５怪物硬币|１怪物硬币|大犬座的卡片")


local 队长名称=取脚本界面数据("队长名称",false)
local 队伍人数=取脚本界面数据("队伍人数")
if(队长名称==nil or 队长名称=="" or 队长名称==0)then
	队长名称=用户输入框("请输入队伍名称！","风依旧￠花依然")--风依旧￠花依然  乱￠逍遥
end
local 设置队员列表=取脚本界面数据("队员列表")
local 队员列表={}
if(设置队员列表 ~= nil and string.find(设置队员列表,"|") ~= nil)then
	队员列表=common.luaStringSplit(设置队员列表,"|")
end
--日志(设置队员列表)
local sEquipWeaponName=用户下拉框("武器名称",{"平民剑","平民斧","平民枪","平民弓","平民回力镖","平民小刀","平民杖"})		--武器名称
local sEquipHatName=用户下拉框("帽子名称",{"平民帽","平民盔"})				--帽子名称
local sEquipClothesName=用户下拉框("衣服名称",{"平民衣","平民铠","平民袍"})	--衣服名称
local sEquipShoesName=用户下拉框("鞋名称",{"平民鞋","平民靴"})				--鞋名称

--local 水晶名称="风地的水晶（5：5）"
local 水晶名称="水火的水晶（5：5）"
local isTeamLeader=false		--是否队长
local 身上最少金币=5000			--少于去取
local 身上最多金币=1000000		--大于去存
local 身上预置金币=500000		--取和拿后 身上保留金币
local 脚本运行前时间=os.time()	--统计效率
local 脚本运行前金币=人物("金币")	--统计金币
local 已刷卵总数=0

local 上次迷宫楼层=1
local 当前迷宫楼层=1

local 预置扔依格罗斯档次=22				--多少档扔 如果宠为0档，则永远小于22，不会扔
local 预置扔麒麟档次=22					--0档以上仍 鸟用此选项
local 预置扔翼龙档次=用户输入框("预置扔翼龙档次","5")				--5档以上扔
local 预置扔罗修档次=用户输入框("预置扔罗修档次","2")				--2档以上仍
local 已刷宠物数量={
	["依格罗斯"]={count=0,msg="惊喜,您刷到了稀缺宠物【依格罗斯】,档次 ",grade=预置扔依格罗斯档次},
	["麒麟"]={count=0,msg="恭喜,您刷到了宠物【麒麟】,档次 ",grade=预置扔麒麟档次},
	["翼龙"]={count=0,msg="恭喜,您刷到了宠物【翼龙】,档次 ",grade=预置扔翼龙档次},
	["罗修"]={count=0,msg="恭喜,您刷到了个性宠物【罗修】,档次 ",grade=预置扔罗修档次},
	}		--希特拉 泰坦巨人 萨普地雷 托罗帝鸟 岩地跑者
	
local topicList={"依格罗斯仓库信息","麒麟仓库信息","翼龙仓库信息"}
订阅消息(topicList)

local 当前任务编号=3

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

function waitTopic(tgtTopic,tgtPetName)
	
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
	topic,msg=已接收订阅消息(tgtTopic)	
	--日志(topic.." Msg:"..msg)
	if(topic == tgtTopic)then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeBagSpace=recvTbl.pets
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
		local pets = 全部宠物信息()
		tradeList="金币:20;宠物:"
		hasData=false
		selfTradeCount=0
		for i,v in pairs(pets) do
			if(v.realname == tgtPetName and v.level==1)then					
				if(selfTradeCount >= tradeBagSpace)then
					break
				end		
				selfTradeCount=selfTradeCount+1
				hasData=true				
			end
		end	
		tradeList = tradeList..tgtPetName.."|"..selfTradeCount			
		
		日志(tradeList)
		if(hasData)then
			交易(tradeName,tradeList,"",10000)
		else	
			--设置("timer",100)
			--下次说不定是哪个仓库 设置为nil
			tradeName=nil
			tradeBagSpace=nil
			tradePlayerLine=nil	
			--回城()
			return
		end
		tryNum=tryNum+1	
	end
	goto begin
end

function 开奖()
	if(取物品数量("偏方多面体的卵") > 0)then
		已刷卵总数=已刷卵总数+1		
		日志("获得了【偏方多面体的卵】，开奖咯！")
		local oldPetList=全部宠物信息()
		if(common.getTableSize(oldPetList) >= 5)then
			日志("自动开奖失败，宠物已满，请至少预留一个空位!")
		else
			使用物品("偏方多面体的卵")
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
							if(newPet.grade == 20 or newPet.grade==0)then
							
							elseif(newPet.grade > v.grade)then
								日志(newPet.realname.."【"..newPet.grade.."】档,档次低于设定值【"..v.grade .."】，丢弃")
								宠物("改名",newPet.grade,newPet.index)
								等待(3000)
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
	日志("已刷守护次数："..已刷卵总数.."次",1)
	local msgCount="各宠物数量分别为："	
	for i,v in pairs(已刷宠物数量) do			
		msgCount=msgCount..i.."："..v.count.." "		
	end
	日志(msgCount,1)
end

function main()	
	--开奖()	
	日志("欢迎使用星落刷自动跑守护脚本",1)
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
	-- if(取物品数量("托尔丘的记忆") > 0)then
		-- if(common.checkTitle("天界变革者"))then
			-- 当前任务编号=3
		-- else
			-- 当前任务编号=2
		-- end
		-- 设置个人简介("玩家称号",当前任务编号)
	-- end
	local mapNum=0
	local mapName=""
::begin::	
	等待空闲()
	common.changeLineFollowLeader(队长名称)		--同步服务器线路	
	mapNum=取当前地图编号()
	mapName=取当前地图名()
	if(mapNum == 59513)then goto map59513 
	elseif(mapNum==59522)then goto map59522			--利夏岛
	elseif(mapNum==59557)then goto map59557
	elseif(mapNum==59552)then goto map59552			--国民会馆
	elseif(mapNum==59984)then goto map59984	
	elseif(mapNum==59988)then goto map59988
	elseif(mapNum==59985)then goto map59985			--？？？  真实之顶打完boss位置
	elseif(mapNum==59986)then goto map59986
	elseif(mapNum==59987)then goto map59987
	elseif(mapNum==59757)then goto map59757			--星之领域　１层
	elseif(mapNum==59758)then goto map59758			--星之领域　２层
	elseif(mapNum==59759)then goto map59759			--星之领域　３层
	elseif(mapNum==59760)then goto map59760			--星之领域　４层
	elseif(mapNum==59761)then goto map59761			--星之领域　５层
	elseif(mapNum==59992)then goto map59992			--真实之顶
	elseif(mapNum==59993)then goto map59993			--约尔克神庙
	elseif(string.find(mapName,"通向顶端的阶梯")~=nil)then goto crossMaze  
	elseif(mapName== "公寓")then goto 补魔  
	elseif(mapName == "辛梅尔")then goto map59987  
	elseif(mapName == "艾尔莎岛")then goto 出发
	else goto 出发 end
	等待(2000)
	goto begin
::补魔::	
	移动(91,58)   	 
	回复(0)		
	移动(100,70,"辛梅尔")	
	goto begin	
::出发::	
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
	if (人物("宠物数量") >= 5 )then	
		日志("宠物满了，去银行存货！")
		common.depositNoBattlePetToBank()
		if (人物("宠物数量") >= 5 )then	
			日志("银行宠物也满啦！去存仓库！")
			common.gotoFalanBankTalkNpc()
			tradeName=nil
			tradeBagSpace=nil
			if common.getTgtPetCount( "依格罗斯") > 0 then waitTopic("依格罗斯仓库信息","依格罗斯") end
			if common.getTgtPetCount( "麒麟") > 0 then waitTopic("麒麟仓库信息","麒麟") end
			if common.getTgtPetCount( "翼龙") > 0 then waitTopic("翼龙仓库信息","翼龙") end
			
			goto begin
		end
	end
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)
	common.supplyCastle()
	common.sellCastle()		--默认卖	
	
	if(取物品数量("托尔丘的记忆") < 1)then
		当前任务编号=1
		设置个人简介("玩家称号",当前任务编号)
		日志("包裹没有记忆，去做【记忆之接触者】任务",1)
	--	设置("敌平均级小于逃跑",0,45)
		执行脚本("./脚本/任务/天界/★守护1-记忆之接触者.lua")	
		当前任务编号=3
		设置个人简介("玩家称号",当前任务编号)		
		if(取当前地图名()~="艾尔莎岛")then 回城() end
		goto begin
	end	
	if(common.checkTitle("天界变革者")==false)then
		当前任务编号=2
		设置个人简介("玩家称号",当前任务编号)
		日志("未做守护任务2，去做【天界之变革者】任务",1)
		--设置("敌平均级小于逃跑",1,45)
		执行脚本("./脚本/任务/天界/★守护2-天界变革者.lua")	
		当前任务编号=3
		设置个人简介("玩家称号",当前任务编号)			
		if(取当前地图名()~="艾尔莎岛")then 回城() end
		goto begin
	end
	if(取当前地图名()~="艾尔莎岛")then 回城() end
	当前任务编号=3
	设置个人简介("玩家称号",当前任务编号)
	等待空闲()
	等待到指定地图("艾尔莎岛")		
	--设置("敌平均级小于逃跑",0,45)		--守护2才需要开启
	移动(165,153)	
	转向(4, "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")	
::map59522::
	等待到指定地图("利夏岛")	
	移动(90,99,"国民会馆")
::map59552::		--国民会馆
	if(取物品数量("托尔丘的记忆") < 1)then
		回城()
		goto begin
	end
	移动(115,51)
	对话选是(116,50)
	goto begin
::map59987::		--辛梅尔
	if(common.isNeedSupply() and 目标是否可达(181,81))then	--到辛梅尔 主要不满血魔 就去补一下 
		移动(181,81,"公寓")	
		goto begin
	end
	if(取物品数量("托尔丘的记忆") > 0)then
		日志("记忆任务完成,去做3",1)
		回城()
		goto begin
	end
	if(目标是否可达(26,15))then
		移动(25,15)	
		对话选是(1)		
		if(取物品数量("托尔丘的记忆") > 0)then
			日志("记忆任务完成",1)
			return			
		end
	else
		移动(187,88)   
		移动(192,83) 
		移动(192, 82,"第二宝座")		
		移动(105, 20,"辛梅尔")	   
	end
	goto begin
::map59557::		--第二宝座
	移动(105, 20,"辛梅尔")	   
	goto begin
::map59513::
	if(目标是否可达(153, 121))then
		移动(153, 121)
	end
	if(目标是否可达(167,28))then
		移动(167, 26)
		移动(169, 26)		
		对话选是(2)
		移动(169, 20)		
		对话选是(7)
		移动(167, 16)			
		对话选是(0)
		移动(162, 22)	
		对话选是(4)
	end
	if(目标是否可达(116, 69))then
		移动(118, 67)	
		对话选是(2)	
	end
	goto begin
::map59984::		--？？？
	if(目标是否可达(161,58))then	
		移动(161, 58)	
		对话选是(2)	
	end
	if(目标是否可达(121,98))then	
		移动(121, 98)	
		对话选是(2)	
	end	
	if(目标是否可达(201, 18))then	
		移动(201, 18)	
		对话选是(2)	
	end
	if(目标是否可达(318, 135))then	
		移动(318, 135)			
		日志("学一击必中的赶紧哦，10秒后继续下一步",1)
		等待(10000)
		--对话选是(2)	
		移动(319, 148)	
		等待(2000)
		对话选择("4", "", "")	
	end
	if(目标是否可达(238,139))then	
		移动(238,139)
	end
	if(目标是否可达(355,180))then	
		移动(355,180)
	end
	if(目标是否可达(315,220))then	
		移动(315,220)
	end
	if(目标是否可达(279,256))then	
		移动(279,256)
	end
	goto begin

::map59988::							--？？？
	等待到指定地图("？？？")		
	if(目标是否可达(203, 14))then	
		if isTeamLeader then			
			if(队伍("人数") < 队伍人数)then
				if(checkTeammateSameFloor())then
					common.makeTeam(队伍人数)	
				else
					扔("托尔丘的记忆")
					回城()
					goto begin
				end				
			else
				移动(203, 14,"通向顶端的阶梯1楼")		
			end		
			
		else
			if(队伍("人数") > 1)then
				if(common.judgeTeamLeader(队长名称)==true) then
					TeammateAction()
				else
					离开队伍()
				end	
			else			
				if(checkTeamLeaderTask())then
					common.joinTeam(队长名称)
				else
					扔("托尔丘的记忆")
					回城()
					goto begin
				end													
			end
		end				
	end
	if(目标是否可达(163, 54))then		
		移动(163, 54,"真实之顶")				
	end
	if(目标是否可达(358, 173))then		
		移动(358, 173)		
		对话选是(0)		
	end
	goto begin
::map59992::			--真实之顶
	移动(103,19)
	对话选是(1)
	等待(3000)
	if(是否战斗中())then 等待战斗结束() end
	goto begin
::map59985::			--？？？
	--等待到指定地图("？？？",110,146)
	if(目标是否可达(116, 131))then		
		移动(116, 131)		
		对话选是(0)		
	end
	if(目标是否可达(156,171))then		
		移动(156,171)		
		对话选是(0)		
	end	
	goto begin
::map59986::
	等待到指定地图("？？？")		
	移动(139, 63)
	移动(141, 61)	
	对话选是(0)
	goto begin
::map59757::			--星之领域　１层
	等待到指定地图("星之领域　１层")    
	if(队伍("人数") <2)then
		日志("队伍人数小于2，回城")
		回城()
		goto begin
	end
	移动(98,17)
	移动(99,17)	
::map59758::    
    等待到指定地图("星之领域　２层")  
	if(队伍("人数") <2)then
		日志("队伍人数小于2，回城")
		回城()
		goto begin
	end
	if(目标是否可达(29, 89))then			
		移动(29,89)	
	elseif(目标是否可达(166,102))then		
		移动(166,102)	
	end	
	goto map59759 	
::map59759::    
    等待到指定地图("星之领域　３层")	
	if(队伍("人数") <2)then
		日志("队伍人数小于2，回城")
		回城()
		goto begin
	end
	if(目标是否可达(107,167))then			
		移动(107,167)	
	elseif(目标是否可达(97,28))then		
		移动(97,28)	
	end		
	goto begin
::map59760::    
    等待到指定地图("星之领域　４层")  
	if(队伍("人数") <2)then
		日志("队伍人数小于2，回城")
		回城()
		goto begin
	end  	
	移动(107,98)
	移动(108,98)	
	等待(1000)	
	goto map59761 	
::map59761::    
    --等待到指定地图("星之领域　５层", 110,97) 
	if(目标是否可达(39,99))then		
		if(队伍("人数") <2)then
			日志("队伍人数小于2，回城")
			回城()
			goto begin
		end
		移动(39,99)	
		对话选是(40,99)
		if(是否战斗中())then 
			等待战斗结束()
			等待(5000)
			等待空闲()
			if(取当前地图编号() ~= 59761)then
				goto begin
			elseif(取当前地图编号() == 59761 and 人物("血") <= 2)then
				日志("没有打过boss,登出回城")
				回城()
				goto begin						
			end			
		end
	elseif(目标是否可达(141,113))then		
		移动(141,113)	
		转向(2)		
		等待(3000)
	end	
	goto begin
::map59993::		--约尔克神庙
	-- 移动(41,27)
	-- 移动(41,28)
	-- 移动(41,27)	
	移动(41,28)
	移动(41,27)
	--丢魔石
	对话选是(42,28)
	对话选是(42,27)
::map59536::		--约尔克神庙
	回城()
	等待空闲()
	移动(144,108)
	开奖()
	上次迷宫楼层=1
	当前迷宫楼层=1
	goto begin
::crossMaze::
	if isTeamLeader then			
		--自动穿越迷宫()	
		if(队伍("人数") ~= 队伍人数)then		--队友掉线回城
			回城()		
			goto begin
		end
		mapName=取当前地图名()		
		if(string.find(mapName,"通向顶端的阶梯") == nil) then	
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
		if(队伍("人数") < 2)then		--队友掉线回城
			回城()		
			goto begin
		else
			TeammateAction()
		end		
	end
	goto begin
end

function TeammateAction()
	while true do
		if(队伍("人数") < 2)then							
			break											
		end
		等待(3000)
	end
end


--获取好友的当前任务
function getFriendSetText(name)
	local friendcard = 取好友名片(name)
	if( friendcard ~= nil)then
		return tonumber(friendcard.title)		--转换失败 返回nil
	end	
	return nil
end
--检查队友和队长是否同一任务
function checkTeammateSameFloor()	
	--日志("当前任务"..当前任务编号)
	for i,u in pairs(队员列表) do
		--日志(u)
		local friendTask=getFriendSetText(u)
		if(friendTask~=nil)then		--成功设置楼层的才判断，其余默认在同一楼层
			--日志(u..friendTask)
			if(friendTask == 1 or friendTask == 2 or friendTask == 3)then
				if( 当前任务编号 ~= friendTask)then
					日志(u.."的任务编号和队长任务不一致，重新从任务1开始,队长任务编号:"..当前任务编号.." 队员任务:"..friendTask,1)
					return false
				end
			end
		end
	end
	return true
end
--检查队长是否在同一楼层
function checkTeamLeaderTask()	
	--日志(队长名称)
	local leaderTask=getFriendSetText(队长名称)
	if(leaderTask~=nil)then		
		--日志(type(leaderTask))
		--日志(type(当前任务编号))
		--日志(leaderTask.." "..当前任务编号)
		if(leaderTask ~= 1 and leaderTask ~= 2 and leaderTask ~= 3)then
			return true
		end
		if(leaderTask ~= 当前任务编号) then
			日志("队员任务编号和队长任务不一致，重新从1开始,队长任务:"..leaderTask.." 队员任务:"..当前任务编号,1)
			return false
		end		
	end
	return true
end
main()