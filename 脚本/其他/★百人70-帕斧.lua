★定居艾岛；支持法兰，可设置自动更换装备；自己设置丢不要的卡，新城支持存宝石鼠铜奖，银行满以后丢弃★坐标180秒未变重启	★脚本联系：风星落-QQ:274100927

--延时 处理一些不调用服务器交互的 可以设置为0，否则设置为100，速度太快，没有延时情况下，给服务器发送多个数据，没有效果，反而可能会掉线
common=require("common")
设置("timer",100)			
--设置("自动扔",1,"34754")

设置("自动叠",1,"地元素碎片&4")
设置("自动叠",1,"水元素碎片&4")
设置("自动叠",1,"火元素碎片&4")
设置("自动叠",1,"风元素碎片&4")
设置("自动叠",1,"魔族的水晶&5")
设置("自动叠",1,"香水：深蓝九号&3")
设置("自动叠",1,"魅惑的哈密瓜&3")
设置("自动叠",1,"火焰之魂&5")
--设置("自动扔",1,"34754")		--百人20层 传送券
设置("自动扔",1,"宝石？")		--10级宝石	13667 紫水晶
--设置("自动扔",1,"宝石？")		--10级宝石	13626 优良的骑士宝石
设置("自动扔",1,"冻王护符|岩王护符|炎王护符|风王护符|石化秘笈|遗忘秘笈|混乱秘笈|酒醉秘笈|昏睡秘笈|洒毒沙铃")
设置("自动扔",1,"34583")		--法兰城
设置("自动扔",1,"34584")		--阿凯鲁法村
设置("自动扔",1,"34585")		--哥拉尔
设置("自动扔",1,"34586")		--新城	
设置("自动扔",1,"火焰鼠闪卡「D1奖」|火焰鼠闪卡「D2奖」|火焰鼠闪卡「D3奖」|火焰鼠闪卡「D4奖」|火焰鼠闪卡「C1奖」|火焰鼠闪卡「C2奖」|火焰鼠闪卡「C3奖」|火焰鼠闪卡「C4奖」|宝石鼠残念奖|宝石鼠铜奖|宝石鼠银奖|宝石鼠金奖|黑暗之戒|宝石？|迷之手册|迷之晶体|鼠娃娃兑换券|魅惑的哈密瓜|魅惑的哈密瓜面包|印度轻木|34583|34584|34585|34586|蕃茄|封印卡（昆虫系）|封印卡（野兽系)|封印卡（人形系）|封印卡（金属系）|封印卡（龙系）|封印卡（特殊系）|封印卡（植物系）|封印卡（飞行系）|封印卡（不死系）|鼠王的卡片|鹿皮|鸡蛋|铜|苹果薄荷|勾玉的戒指|宝石鼠洋娃娃|大地鼠洋娃娃|火焰鼠洋娃娃|恶梦鼠洋娃娃|试验红药水|面包|特制雕鱼烧|生命力回复药（75）")

预置交易物品列表={"小护士家庭号","魔力之泉","完全结晶体的紫水晶","完全结晶体的骑士宝石","完全结晶体的绿宝石","火焰鼠闪卡「B4奖」","火焰鼠闪卡「B3奖」","火焰鼠闪卡「B2奖」","火焰鼠闪卡「B1奖」","火焰鼠闪卡「A4奖」","火焰鼠闪卡「A3奖」","火焰鼠闪卡「A2奖」","火焰鼠闪卡「A1奖」","宝石鼠月亮奖","海洋之心","火焰之魂","天空之枪","帕鲁凯斯之斧","村正","鼠王"}
	
	
local tradeName=nil
local tradeBagSpace=nil
local tradePlayerLine=nil			--仓库人物当前线路
topicList={"百人道场仓库信息"}
订阅消息(topicList)

补血值=1000--用户输入框("多少血以下补血", "430")
补魔值 = 300--用户输入框("多少魔以下补魔", "50")
宠补血值=1000--用户输入框( "宠多少血以下补血", "50")
宠补魔值=300--用户输入框( "宠多少魔以下补血", "100")

设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 高速战斗
最高楼层=71

中奖物品列表={"魔力之泉","小护士家庭号","天空之枪","帕鲁凯斯之斧","村正","鼠王"}

队长名称 = 取脚本界面数据("队长名称",false)
设置队员列表=取脚本界面数据("队员列表")
队员列表={}
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","乱￠逍遥")--风依旧￠花依然  乱￠逍遥
end
lotteryList={"CH","BCH","BH"}
抽奖选项=用户下拉框("抽奖项", lotteryList)
日志("当前抽奖已选择："..抽奖选项,1)
isTeamLeader=false		--是否队长
if(人物("名称",false) == 队长名称)then
	isTeamLeader=true
	日志("当前是队长",1)
end

队伍人数=1
if(isTeamLeader)then	
	队伍人数=取脚本界面数据("队伍人数")	
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
	if(队员列表 == nil or common.getTableSize(队员列表) < 2)then
		日志("没有设置队员列表，不能判断掉线不同楼层问题",1)
	end
end

日志("队长名称："..队长名称.." 队伍人数:"..队伍人数,1)
	
--设置自动更换装备水晶耐久值
自动换武器耐久值=0--用户输入框("多少耐久以下自动换武器,不换可不填", "10")
备用武器名的名称=""--用户输入框( "换备用武器的名称,如：国民弓、平民弓,不换可不填", "国民弓")
扔换下的旧武器=1--用户输入框( "是否扔换下的旧武器,扔填1,不扔填0", "1")
自动换衣服或铠甲耐久值=0
要换下衣服或铠甲的名称=""
备用衣服或铠甲的名称=""
扔换下的旧衣服或铠甲=11111
自动换帽子或头盔耐久值=0
备用帽子或头盔的名称=""
扔换下的旧帽子或头盔=11111
自动换鞋子或长靴耐久值=0
备用鞋子或长靴的名称=""
扔换下的旧鞋子或长靴=11111
--用户输入框("自动换衣服或铠甲耐久值", "多少耐久以下自动换衣服或铠甲,不换可不填", "10")
--用户输入框("要换下衣服或铠甲的名称", "要换下衣服或铠甲的名称,如：如：平民衣、平民铠,不换可不填", "平民衣")
--用户输入框("备用衣服或铠甲的名称", "换备用衣服或铠甲的名称,如：平民衣、平民铠,不换可不填", "平民衣")
--用户输入框("扔换下的旧衣服或铠甲", "是否扔换下的旧衣服或铠甲,扔填11111,不扔填0", "11111")

--用户输入框("自动换帽子或头盔耐久值", "多少耐久以下自动换帽子或头盔,不换可不填", "10")
--用户输入框("备用帽子或头盔的名称", "换备用帽子或头盔的名称,如：平民帽、平民盔,不换可不填", "平民帽")
--用户输入框("扔换下的旧帽子或头盔", "是否扔换下的旧帽子或头盔,扔填11111,不扔填0", "11111")

--用户输入框("自动换鞋子或长靴耐久值", "多少耐久以下自动换鞋子或长靴,不换可不填", "10")
--用户输入框("备用鞋子或长靴的名称", "换备用鞋子或长靴的名称,如：平民鞋、平民靴,不换可不填", "平民鞋")
--用户输入框("扔换下的旧鞋子或长靴", "是否扔换下的旧鞋子或长靴,扔填11111,不扔填0", "11111")

function 继续下一层()
	tryCount=0
::warpErShi::
	if( tryCount > 3 ) then
		return
	end
	if(取物品数量("道场记忆") > 0) then
		使用物品("道场记忆")
		等待服务器返回()	
		对话选择(4,0)	
	end
	等待(1000)
	当前地图名 = 取当前地图名()	
	if(string.find(当前地图名,"第")~=nil ) then
		return
	end	   
	tryCount=tryCount+1
	goto warpErShi
end
function openCard()
	while 取物品数量("火焰鼠闪卡") > 0 do 
		使用物品("火焰鼠闪卡")
	end
	while 取物品数量("宝石鼠闪卡") > 0 do 
		使用物品("宝石鼠闪卡")
	end
end
--换元素水晶
function exchangeShuiJing(水晶列表)
	等待到指定地图("百人道场大厅")	
	--判断碎片数量
	是否换=false
	for k,v in ipairs(elements) do	
		if(取物品叠加数量(v.."地元素碎片") >= 4)then
			是否换=true
			break
		end		
	end 	
	if 是否换 then
		移动(28,29)
		转向(0)	
		for k,v in ipairs(elements) do	
			喊话(v,2,3,5)
			等待服务器返回()	
			对话选择(4, 0)
		end 	
	end	
end

function exchangeH(count)
	移动(23,24)
	转向(2)
	while count > 0 do	
		喊话("H",2,3,5)
		等待服务器返回()	
		对话选择(4, 0)
		count = count -1
		等待(1500)
		openCard()
	end	
	等待(1000)
	openCard()
end
function exchangeC()	
	移动(23,24)
	转向(2)
	喊话("C",2,3,5)
	等待服务器返回()	
	对话选择(4, 0)	
end
function exchangeB()
	移动(23,24)
	转向(2)
	喊话("B",2,3,5)
	等待服务器返回()	
	对话选择(4, 0)
	对话选择(1, 0)
end
function exchangeCH()
	清除系统消息()
	local elements = {"地","水","风","火"}
	--三种水晶 去换C奖
	cNeedCount=0
	for k,v in ipairs(elements) do
		if(取物品数量(v.."元素水晶") > 0)then 		
			cNeedCount=cNeedCount+1
		end	
	end 	
	if(cNeedCount >= 3)then
		exchangeC()
	end
	for k,v in ipairs(elements) do
		if(取物品数量(v.."元素水晶") < 1)then 		
			if(取物品叠加数量(v.."元素碎片") >= 4)then
				移动(28,29)
				转向(0)					
				喊话(v,2,3,5)
				等待服务器返回()	
				对话选择(4, 0)				
			end		
		end	
	end 	
	cNeedCount=0
	for k,v in ipairs(elements) do
		if(取物品数量(v.."元素水晶") > 0)then 		
			cNeedCount=cNeedCount+1
		end	
	end 
	if(cNeedCount >= 3)then
		exchangeC()
	end	
	if(取物品数量("地元素水晶") > 0)then 		
		--地的全换
		地碎片多余数量=取物品叠加数量("地元素碎片")
		if(地碎片多余数量 > 0)then 
			叠("地元素碎片",4)
			exchangeH(地碎片多余数量)
		end	
		--水的次之 保留4个
		水碎片多余数量=取物品叠加数量("水元素碎片")-4
		if(水碎片多余数量 > 0)then 
			叠("水元素碎片",4)
			exchangeH(水碎片多余数量)
		end	
	end	
	-- --多余的换H奖 叠加没有排序 不知道有没有影响
	-- 地碎片多余数量=取物品叠加数量("地元素碎片")-4
	-- if(地碎片多余数量 > 0)then 
		-- 叠("地元素碎片",4)
		-- exchangeH(地碎片多余数量)
	-- end	
	for i,v in ipairs(中奖物品列表) do
		if(string.find(系统消息(),v)~=nil)then
			日志("喜提"..v,1)
			发布消息("百人道场","喜提"..v)
		end
	end
	
end
function exchangeBCH()
	清除系统消息()
	local elements = {"地","水","风","火"}
	local cElements = {"地","水","风"}
	--四种碎片 去换B奖
	while true do
		bNeedCount=0
		for k,v in ipairs(elements) do
			if(取物品数量(v.."元素碎片") > 0)then 		
				bNeedCount=bNeedCount+1
			end	
		end 	
		--这里只换了1次 多的火 下次去换 
		if(bNeedCount >= 4)then
			exchangeB()
		else
			break
		end		
	end
	--三种水晶 去换C奖
	local cNeedCount=0
	for k,v in ipairs(cElements) do
		if(取物品数量(v.."元素水晶") > 0)then 		
			cNeedCount=cNeedCount+1
		end	
	end 	
	--先换一次C
	if(cNeedCount >= 3)then
		exchangeC()
	end
	--换水晶去
	for k,v in ipairs(cElements) do
		if(取物品数量(v.."元素水晶") < 1)then 		
			if(取物品叠加数量(v.."元素碎片") >= 4)then
				移动(28,29)
				转向(0)					
				喊话(v,2,3,5)
				等待服务器返回()	
				对话选择(4, 0)				
			end		
		end	
	end 	
	cNeedCount=0
	for k,v in ipairs(cElements) do
		if(取物品数量(v.."元素水晶") > 0)then 		
			cNeedCount=cNeedCount+1
		end	
	end 
	if(cNeedCount >= 3)then
		exchangeC()
	end	
	if(取物品数量("地元素水晶") > 0)then 		
		--地的全换
		地碎片多余数量=取物品叠加数量("地元素碎片")
		if(地碎片多余数量 > 0)then 
			叠("地元素碎片",4)
			exchangeH(地碎片多余数量)
		end	
		--水的次之 保留4个
		水碎片多余数量=取物品叠加数量("水元素碎片")-4
		if(水碎片多余数量 > 0)then 
			叠("水元素碎片",4)
			exchangeH(水碎片多余数量)
		end	
		--风 火 不换
	end		
	for i,v in ipairs(中奖物品列表) do
		if(string.find(系统消息(),v)~=nil)then
			日志("喜提"..v,1)
			发布消息("百人道场","喜提"..v)
		end
	end
end
function exchangeBH()
	清除系统消息()
	local elements = {"地","水","风","火"}
	--三种水晶 去换C奖
	bNeedCount=0
	for k,v in ipairs(elements) do
		if(取物品数量(v.."元素碎片") > 0)then 		
			bNeedCount=bNeedCount+1
		end	
	end 	
	if(bNeedCount >= 4)then
		exchangeB()
	end		
	bNeedCount=0	
	地碎片多余数量=取物品叠加数量("地元素碎片")-4	
	if(地碎片多余数量 > 0)then 
		叠("地元素碎片",4)
		exchangeH(地碎片多余数量)
	end	
	--水的次之 保留4个
	水碎片多余数量=取物品叠加数量("水元素碎片")-4
	if(水碎片多余数量 > 0)then 
		叠("水元素碎片",4)
		exchangeH(水碎片多余数量)
	end	
	风碎片多余数量=取物品叠加数量("风元素碎片")-4
	if(风碎片多余数量 > 0)then 
		叠("风元素碎片",4)
		exchangeH(风碎片多余数量)
	end	
	-- --多余的换H奖 叠加没有排序 不知道有没有影响
	-- 地碎片多余数量=取物品叠加数量("地元素碎片")-4
	-- if(地碎片多余数量 > 0)then 
		-- 叠("地元素碎片",4)
		-- exchangeH(地碎片多余数量)
	-- end	
	for i,v in ipairs(中奖物品列表) do
		if(string.find(系统消息(),v)~=nil)then
			日志("喜提"..v,1)
			发布消息("百人道场","喜提"..v)
		end
	end
	
end
function getCurrentFloor(mapName)
	if( mapName == nil)then return 200 end
	--mapName = 取当前地图名()
	if (string.find(mapName,"道场")~=nil)then
		if (string.find(mapName,"第十")~=nil)then return 20 end
		if (string.find(mapName,"第二十")~=nil)then return 30 end
		if (string.find(mapName,"第三十")~=nil)then return 40 end
		if (string.find(mapName,"第四十")~=nil)then return 50 end
		if (string.find(mapName,"第五十")~=nil)then return 60 end
		if (string.find(mapName,"第六十")~=nil)then return 70 end
		if (string.find(mapName,"第七十")~=nil)then return 80 end
		if (string.find(mapName,"第八十")~=nil)then return 90 end
		if (string.find(mapName,"第九十")~=nil)then return 100 end				
		return 10	
	end
	return 200
end
--当前楼层 精确到数字
function getCurrentFloorFromNum(mapNumber)
	if( mapNumber == nil)then return 200 end
	if(mapNumber >= 9201 and mapNumber <= 9299)then 
		return mapNumber-9200	
	end
	return 200
end
--获取好友的楼层
function getFriendSetText(name)
	local friendCard = 取好友名片(name)
	if( friendCard ~= nil)then
		return tonumber(friendCard.title)		--转换失败 返回Nil
	end	
	return nil
end
--检查队友和队长是否在同一楼层
function checkTeammateSameFloor()
	local selfFloor = getCurrentFloorFromNum(取当前地图编号())
	if(selfFloor == 200)then return true end 
	
	for i,u in pairs(队员列表) do
		local friendFloor=getFriendSetText(u)
		if(friendFloor~=nil)then		--成功设置楼层的才判断，其余默认在同一楼层
			if(friendFloor ~= 200 and selfFloor ~= friendFloor)then
				日志(u.."的楼层和队长楼层不一致，重新从1层开始,队长楼层:"..selfFloor.." 队员楼层:"..friendFloor,1)
				return false
			end
		end
	end
	return true
end
--检查队长是否在同一楼层
function checkTeamLeaderFloor()
	local selfFloor = getCurrentFloorFromNum(取当前地图编号())
	if(selfFloor == 200)then return true end 	
	
	local leaderFloor=getFriendSetText(队长名称)
	if(leaderFloor~=nil)then		--成功设置楼层的才判断，其余默认在同一楼层
		if(leaderFloor ~= 200 and selfFloor ~= leaderFloor)then
			日志("队员楼层和队长楼层不一致，重新从1层开始,队长楼层:"..leaderFloor.." 队员楼层:"..selfFloor,1)
			return false
		end
	end
	return true
end
function main()
	--重启脚本 默认从1层开始，重新组队，否则掉线容易卡在不同楼层
	扔("道场记忆")
	--回城()
::begin::	
	等待空闲()
	common.changeLineFollowLeader(队长名称)
	当前地图名 = 取当前地图名()
	mapNum = 取当前地图编号()
	if (当前地图名=="艾尔莎岛" )then	
		goto island  
	elseif (当前地图名=="法兰城" )then	
		goto qubairen  
	elseif (当前地图名=="百人道场大厅" )then	
		goto 百人大厅  
	elseif( 当前地图名== "治愈的广场")then
		goto 治愈广场
	elseif(string.find(当前地图名,"第")~=nil) then	
		if(string.find(当前地图名,"组通过")==nil and getCurrentFloorFromNum(mapNum) >= 最高楼层)then
			回城()
			goto begin
		end
		if(string.find(当前地图名,"一")~=nil and string.find(当前地图名,"组通过")==nil)then	
			设置个人简介("玩家称号",getCurrentFloorFromNum(mapNum))
			--每个楼层第一层 等待
			if(isTeamLeader)then	
				--增加队友掉线后 不在同一楼层判断
				if(getCurrentFloorFromNum(mapNum) ~= 1)then		--不是1层，检查队员楼层
					if(checkTeammateSameFloor() == false)then 
						回城()
						goto begin
					end
				end
				if(队伍("人数") < 队伍人数)then	--数量不足 等待
					common.makeTeam(队伍人数)					
					goto begin
				end			
			else				
				if(取队伍人数() > 1)then
					if(common.judgeTeamLeader(队长名称)==true) then
						goto begin
					else
						离开队伍()
					end				
				end		
				if(checkTeamLeaderFloor()==false)then	--检查队员楼层和队长是否不一致
					回城()
					goto begin
				end
				common.joinTeam(队长名称)	
				goto begin
			end  			
		end
		if(string.find(当前地图名,"第")~=nil and string.find(当前地图名,"组通过")==nil) then					
			if(isTeamLeader)then	
				if(队伍("人数") < 队伍人数)then	--中途队友掉线 回城
					回城()
					goto begin
				end
				移动(15,10)
				转向(2)
				等待(2000)			
				转向(3)
				等待(3000)
			else
				if(队伍("人数") < 2)then	--中途队友掉线 回城
					回城()
					goto begin
				end
				等待(2000)				
			end
			等待空闲()
		end
		if(string.find(当前地图名,"组通过")~=nil) then
			设置个人简介("玩家称号",getCurrentFloorFromNum(mapNum))
			if(isTeamLeader==false and 队伍("人数") >1)then
				等待(2000)				
				goto begin
			end			
			移动(20,12)				
			转向坐标(21,12)
			等待服务器返回()			
			对话选择(1, 0)
			等待(1500)
			if(取当前地图名() == "法兰城")then
				common.checkHealth()		--检查一下受伤 回城补下
			end
		end		
		goto begin
	end   
	回城()	
	common.checkHealth()
	if(人物("金币") < 10000)then
		common.getMoneyFromBank(500000)				
	end
	goto begin
::island::	
	x,y=取当前坐标()	
	if (x==140 and y==105 )then
		goto aidao
	end
	移动(140,105)
	goto  begin

::aidao::
	if(人物("健康")>0 or 宠物("健康")>0)then
		common.checkHealth()
		回城()
	end
	if(取包裹空格() < 5)then 
		goto mai	
	end		
	common.checkCrystal()
	common.supplyCastle()
	common.toCastle()	
	if(取物品数量("道场记忆") > 0) then
		继续下一层()			
		等待空闲()
		goto begin
	end	
	移动(41, 98,"法兰城")
	移动(153, 123) 
	if(耐久(2) < 自动换武器耐久值 )then 
		goto  needhzb
	elseif(耐久(1) < 自动换衣服或铠甲耐久值)then 
		goto  needhzb
	elseif(耐久(0) < 自动换帽子或头盔耐久值)then 
		goto  needhzb
	elseif(耐久(4) < 自动换鞋子或长靴耐久值)then 
		goto  needhzb
	end	
::gobairen::	 	
	移动(141, 151)	     
::qubairen::	
	if(取物品数量("道场记忆") > 0) then
		继续下一层()				
		等待空闲()
		goto begin
	end
	移动(126, 160)
--	扔("道场记忆")
	扔("迷之手册")
	扔("迷之晶体")		
	移动(124, 161)
	转向(6)
	等待到指定地图("竞技场的入口", 15,23)	
	移动(26,15)
	等待到指定地图("竞技场的入口", 26,15)
	移动一格(2)
	等待到指定地图("治愈的广场", 5,32)	
::治愈广场::
	移动(25,28)	
	转向(2)
	等待服务器返回()	
	对话选择(4,0)
	等待服务器返回()	
	对话选择(1, 0)
::百人大厅::
	等待到指定地图("百人道场大厅")		
	if(抽奖选项 == "BCH")then
		exchangeBCH()
	elseif(抽奖选项=="CH")then
		exchangeCH()
	elseif(抽奖选项=="BH")then
		exchangeBH()	
	end
	移动(15,23)
::zhandou::	
	转向(2)
	等待服务器返回()	
	对话选择(1, 0)
	等待(1000)
	等待空闲()
	if(取当前地图名() == "第一道场")then
		goto begin
	end
	if(取当前地图名() ~= "百人道场大厅")then
		goto begin
	end
	等待(2000)
	goto zhandou

::回补判断::
    --扔("道场记忆")
	if (人物("血") < 补血值 )then		
		goto  回城补
	elseif (人物("魔") < 补魔值 )then	
		goto  回城补		
	elseif (宠物("血") < 宠补血值 )then	
		goto  回城补		
	elseif (宠物("魔") < 宠补魔值 )then	
		goto  回城补		
	elseif(耐久(7) < 200)then 
		goto  checkxy
	elseif(耐久(2) < 自动换武器耐久值 )then 
		goto  回城补
	elseif(耐久(1) < 自动换衣服或铠甲耐久值)then 
		goto  回城补
	elseif(耐久(0) < 自动换帽子或头盔耐久值)then 
		goto  回城补
	elseif(耐久(4) < 自动换鞋子或长靴耐久值)then 
		goto  回城补
	end	           
    goto  qubairen
::回城补::
	回城()
	等待(2000)
	--等待到指定地图("艾尔莎岛")		
	等待空闲()
	goto  begin

::checkxy::
	x,y=取当前坐标()	
	if (x==141 and y==148 )then	-- 西2登录点
		goto  maisj
	end
	goto  begin	
::maisj::	
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 63, 79)			
	移动(92,78)	
	取下装备("火风的水晶（5：5）")
	等待(2000)
	扔("火风的水晶（5：5）")	
	移动(94,78)	
	等待到指定地图("达美姊妹的店", 1)		
	移动(17,18)		
	取下装备("火风的水晶（5：5）")
	等待(2000)
	扔("火风的水晶（5：5）")	
	等待(3000)        	
	转向(2)
	等待服务器返回()			
	对话选择(0, 0)
	等待服务器返回()			
	买(11,1)
	等待服务器返回()		
	等待(3000)
	装备物品("火风的水晶（5：5）", 7)
	等待(1000)
	goto  begin


::mai::
	移动(157,94)	
	转向坐标(158,93)		
	等待到指定地图("艾夏岛")	
	移动(112,116)
	等待(2000)
	if(取包裹空格() < 5)then 
		goto yinhang
	end	
	移动(150,125)	
	等待到指定地图("克罗利的店", 20,23)		
	移动(39,24)	
	取下装备("火风的水晶（5：5）")
	等待(1000)
	扔("火风的水晶（5：5）")
	移动(39,23)
	移动(40,23)	
	转向(2)
    等待服务器返回()	       
    对话选择(0, 0)
    等待服务器返回()	   
	买(11,1)    
    等待服务器返回()		
	等待(1000)
	使用物品("火风的水晶（5：5）")
	等待(1000)
	goto  begin
::yinhang::		
	移动(114,104)		
	等待到指定地图("银行", 27,34)	
	移动(49,30)
	面向("东")
	等待服务器返回()	
::cunwu::
	银行("全存","小护士家庭号")	
	银行("全存","魔力之泉")	
	银行("全存","完全结晶体的紫水晶")	
	银行("全存","完全结晶体的骑士宝石")	
	银行("全存","完全结晶体的绿宝石")	
	银行("全存","火焰鼠闪卡「B4奖」")	
	银行("全存","火焰鼠闪卡「B3奖」")	
	银行("全存","火焰鼠闪卡「B2奖」")	
	银行("全存","火焰鼠闪卡「B1奖」")	
	银行("全存","火焰鼠闪卡「A4奖」")	
	银行("全存","火焰鼠闪卡「A3奖」")	
	银行("全存","火焰鼠闪卡「A2奖」")	
	银行("全存","火焰鼠闪卡「A1奖」")	
	银行("全存","宝石鼠月亮奖")	
	银行("全存","飞行券")	
	银行("全存","香水：深蓝九号",3)	
	银行("全存","魅惑的哈密瓜面包",3)	
	银行("全存","火焰之魂",5)	
	银行("全存","魔族的水晶",5)	
	等待(2000)
	if(取物品数量("宝石鼠金奖") > 1)then 
		goto clearpack
	end	
	if(取包裹空格() < 5)then
		common.gotoFalanBankTalkNpc()
		tradeName=nil
		tradeBagSpace=nil
		goto waitTopic		
	end
	goto begin
::waitTopic::
	if(取当前地图名()~= "银行")then
		goto begin
	end
	设置("timer",0)
	topic,msg=等待订阅消息()
	日志(topic.." Msg:"..msg,1)
	if(topic == "百人道场仓库信息")then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeBagSpace=recvTbl.bagcount
		tradePlayerLine=recvTbl.line
	end	
	if(tradePlayerLine ~= nil and tradePlayerLine ~= 0 and tradePlayerLine ~= 人物("几线"))then
		切换登录信息("","",tradePlayerLine,"")
		登出服务器()
		等待(3000)			
		goto begin
	end	
	if(tradeName ~= nil and tradeBagSpace ~= nil)then	
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
			goto waitTopic
		end
		if(tradex ~=nil and tradey ~= nil)then
			移动到目标附近(tradex,tradey)
		else
			goto waitTopic
		end
		转向坐标(tradex,tradey)				
		items = 物品信息()
		tradeList="金币:2000;物品:"
		hasData=false
		selfTradeCount=0
		for i,v in pairs(items) do
			if(common.isInTable(预置交易物品列表,v.name) or
				(v.name=="魔族的水晶" and v.count==5))then
				if(hasData)then
					tradeList=tradeList.."|"..v.name.."|"..v.count.."|".."1"
				else
					tradeList=tradeList..v.name.."|"..v.count.."|".."1"			
				end
				selfTradeCount=selfTradeCount+1
				hasData=true
				if(selfTradeCount >= tradeBagSpace)then
					break
				end			
			end
		end	
		--金币:2000;物品:设计图？|0|1|誓约之花|0|1|
		--string.sub(tradeList,1,string.len(tradeList)-1)
		日志(tradeList)
		if(hasData)then
			交易(tradeName,tradeList,"",10000)
		else	
			设置("timer",100)
			tradeName=nil
			tradeBagSpace=nil
			tradePlayerLine=nil	
			回城()
			goto begin
		end
	end
	goto waitTopic
::clearpack::	
	扔("宝石鼠金奖")		
	等待(1000)	
	goto  begin
::needhzb::	
	if(耐久(2) < 自动换武器耐久值 )then 
		goto  buywuqi
	elseif(耐久(1) < 自动换衣服或铠甲耐久值)then 
		goto  buyyifu
	elseif(耐久(0) < 自动换帽子或头盔耐久值)then 
		goto  buymaozi
	elseif(耐久(4) < 自动换鞋子或长靴耐久值)then 
		goto  buyxiezi
	end
	goto  gobairen
::buywuqi::	
	移动(150,123)		
	转向(0)                
	等待服务器返回()	
	对话选择(0, 0)
	等待服务器返回()	
	买(4, 1) 
	等待(2000)	
	goto  checknj
::buymaozi::	
	移动(156,123)				
	转向(0)                 
	等待服务器返回()			
	对话选择(0, 0)
	等待服务器返回()			
	买(0, 1) 
	等待(2000)	
	goto  checknj
::buyyifu::	
	移动(156,123)				
	转向(0)                 
	等待服务器返回()			
	对话选择(0, 0)
	等待服务器返回()			
	买(3, 1) 
	等待(2000)	
	goto  checknj
::buyxiezi::
	移动(156,123)				
	转向(0)                 
	等待服务器返回()			
	对话选择(0, 0)
	等待服务器返回()			
	买(6, 1) 
	等待(2000)	
	goto  checknj
::checknj::
	if(耐久(2) < 自动换武器耐久值 )then 
		goto  reequiparm1
	elseif(耐久(1) < 自动换衣服或铠甲耐久值)then 
		goto  reequipbody4
	elseif(耐久(0) < 自动换帽子或头盔耐久值)then 
		goto  reequiphead1
	elseif(耐久(4) < 自动换鞋子或长靴耐久值)then 
		goto  reequipfeet1
	end
	goto  gobairen
::reequiparm1::	
	if(耐久(2) < 扔换下的旧武器 )then 
		goto  reequiparm2
	end	
	取下装备("自动换武器耐久值")
	等待(1000)
	装备物品("备用武器名的名称", 2)
	等待(1000)
	goto  needhzb
::reequiparm2::	
	扔(2)
	等待(1000)
	装备物品("备用武器名的名称", 2)
	等待(1000)
	goto  needhzb

::reequipbody4::
	if(耐久(1) < 扔换下的旧衣服或铠甲 )then 
		goto  reequipbody5
	end		
	取下装备("要换下衣服或铠甲的名称")
	等待(1000)
	装备物品("备用衣服或铠甲的名称", 1)
	等待(1000)
	goto  needhzb
::reequipbody5::	
	扔(1)
	等待(1000)
	装备物品("备用衣服或铠甲的名称", 1)
	等待(1000)
	goto  needhzb

::reequiphead1::
	if(耐久(0) < 扔换下的旧帽子或头盔 )then 
		goto  reequiphead2
	end		
	取下装备("自动换帽子或头盔耐久值")
	等待(1000)
	装备物品("备用帽子或头盔的名称", 0)
	等待(1000)
	goto  needhzb
::reequiphead2::	
	扔(0)
	等待(1000)
	装备物品("备用帽子或头盔的名称", 0)
	等待(1000)
	goto  needhzb
::reequipfeet1::
	if(耐久(4) < 扔换下的旧鞋子或长靴 )then 
		goto  reequipfeet2
	end		
	取下装备("自动换鞋子或长靴耐久值")
	等待(1000)
	装备物品("备用鞋子或长靴的名称", 4)
	等待(1000)
	goto  needhzb

::reequipfeet2::	
	扔(4)
	等待(1000)
	装备物品("备用鞋子或长靴的名称", 4)
	等待(1000)
	goto  needhzb

::reequipcrystal1::
	if(耐久(7) < 扔换下的旧水晶 )then 
		goto  reequipcrystal2
	end		
	取下装备("自动换水晶耐久值")
	等待(1000)
	装备物品("备用水晶的名称", 7)
	等待(1000)
	goto  needhzb
::reequipcrystal2::	
	扔(7)
	等待(1000)
	装备物品("备用水晶的名称", 7)
	等待(1000)
	goto  needhzb

end
main()
