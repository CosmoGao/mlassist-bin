\\黄组换花，路上逃跑，启动点28.92，每层换好花后停止脚本再重新启动就可以了
设置("高速战斗", 1)             -- 高速战斗时的操作等待时间单位秒，3以上为好，不然容易断线
设置("高速延时", 4)             -- 高速战斗速度，0速度最低，6速度最高

--红 绿 红 绿

--交易对象名称={"￠星￡梦￠","￠衣服￡"}

交易对象名称={}

--设置("timer", 100)			-- 设置定时器，单位毫秒 内置100毫秒 不要太快
设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 开启高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 开启遇敌全跑 
设置("自动加血", 0)			-- 关闭自动加血，脚本对话加血 
走路加速值=125	
走路还原值=100	


function GetOathGroup(group1,group2)
	if(group1==nil or group2 == nil)then
		return
	end
	local teamPlayers
	local dstGroup=0
::begin::	
	dstGroup=0
	teamPlayers = 队伍信息()
	for index,teamPlayer in ipairs(teamPlayers) do			
		if(teamPlayer.nick_name == group1)then
			交易对象名称[1] = teamPlayer.name		
			dstGroup=dstGroup+1
		end
		if(teamPlayer.nick_name == group2)then
			交易对象名称[2] = teamPlayer.name		
			dstGroup=dstGroup+1
		end
	end	
	if(dstGroup >= 2)then
		return
	end
	if(队伍("人数") < 2)then
		return
	end
	等待(1000)
	goto begin
end
function main()	
	local oathGroup = 人物("4转属组")
	日志("当前4转属组:"..oathGroup,1)
	设置个人简介("玩家称号",人物("4转属组"))
	teamNameList={}
	GetOathGroup("红组","绿组")	
	if(交易对象名称[1] == nil)then		
		交易对象名称[1]=用户下拉框("红组名称", teamNameList)
	end	
	if(交易对象名称[2] == nil)then	
		交易对象名称[2]=用户下拉框("绿组名称", teamNameList)
	end
	
	日志("红组名称:"..交易对象名称[1],1)
	日志("绿组名称:"..交易对象名称[2],1)
	
	
::begin::
	等待空闲()
	当前地图名=取当前地图名()
	mapNum=取当前地图编号()
	if(当前地图名=="艾尔莎岛")then
		goto aiersha	
	elseif (当前地图名=="利夏岛" )then	
		goto map59522
	elseif (当前地图名=="国民会馆" )then	
		goto map59552
	elseif (当前地图名=="雪拉威森塔１层" )then	
		goto map59801
	elseif (当前地图名=="公寓" )then	
		goto map59556
	elseif (当前地图名=="辛梅尔" )then	
		goto map59526	
	elseif (当前地图名=="光之路" )then	
		goto map59505		
	elseif(mapNum == 59930)then	--白色方舟·第一层
		goto map59930
	elseif(mapNum == 59931)then	--白色方舟·第二层
		goto map59931	
	elseif(mapNum == 59932)then	--白色方舟·第三层
		goto map59932
	elseif(mapNum == 59933)then	--白色方舟·第四层
		goto map59933
	elseif(mapNum == 59934)then	--白色方舟·第四层
		goto map59934
	end
	等待(1000)
	日志("4转脚本启动需在艾尔莎岛",1)
	goto begin 
::aiersha::
	if(队伍("人数") > 1)then
		日志("等待解散队伍")
		等待(2000)
		goto begin
	end
	if(取物品数量("誓约之花") > 0) then	--誓约之花
		扔("誓约之花")
	end
	if(取物品数量("王冠") < 1)then
		日志("4转脚本需要王冠，如果没有的话，请走到辛美尔在启动",1)
		等待(2000)
		goto begin
	end
	移动(165, 153)
	转向(4)
	等待服务器返回()
	对话选择(32,0)
	等待服务器返回()
	对话选择(4, 0)		
::map59522::					--利夏岛
	if(取当前地图名() ~= "利夏岛")then
		goto begin
	end
	移动(90,99,"国民会馆")
::map59552::					--国民会馆
	移动(108,39,"雪拉威森塔１层")
::map59801::					--雪拉威森塔１层
	移动(34,95)		
	转向(2)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(32, 0)
	等待服务器返回()
	对话选择(32, 0)
	等待服务器返回()
	对话选择(1, 0)
::map59526::					--辛梅尔
	等待到指定地图("辛梅尔")		
	移动(181,81) 
::map59556::					--公寓
	等待到指定地图("公寓")	
	移动(91,58)    
	回复(0)						-- 转向北边恢复人宠血魔
	移动(100,70)
	等待到指定地图("辛梅尔")	 
	移动(207,91) 		
::map59505::					--光之路
	if(取当前地图名() ~= "光之路")then
		goto begin
	end
	移动(165, 82)		
	转向(0)
	等待服务器返回()
	对话选择(4, 0)
	等待(2000)
	goto begin
::map59930::
	if(取物品数量("622052") > 0)then
		if(目标是否可达(89,73))then
			移动(89,73)
			goto huan1
		end	
	end
	if(取物品数量("622051") > 0)then		--第一次还完
		if(目标是否可达(136,49))then
			移动(136,49)
			对话选是(137,48)
		end	
	end
	if(取物品数量("622044") > 0)then		
		if(目标是否可达(59,63))then	--传送去换花
			移动(59,63)
			对话选是(60,63)			
		end
	end
	if(目标是否可达(21,92))then		--拿花
		移动(21, 92)
		对话选是(2)
	end
	goto begin
::huan1::
	if(取物品数量("622051") < 1 and 取物品数量("622052") > 0)then
		while true do
			if(人物("坐标")  ~= "89,73")then
				goto map59930			
			end	
		
			转向(4)
			等待交易(交易对象名称[1],"物品:622052|1|1","物品:622051|1|1",10000)
			if(取物品数量("622051") > 0)then
				日志("一次换花结束!")
				break
			end
			日志("等待一次换花!",1)
		end	
	end
	goto map59930
::map59931::	--白色方舟·第二层
	if(取物品数量("622055") > 0)then
		if(目标是否可达(70,102))then
			移动(70,102)
			goto huan2
		end	
	end
	if(取物品数量("622058") > 0)then		--第二次换完
		if(目标是否可达(84,88))then
			移动(84,88)
			对话选是(85,88)
		end	
	end	
	if(取物品数量("622060") > 0)then		--第四次换完 侦探做任务
		if(目标是否可达(97,83))then
			移动(97,83)
			转向坐标(97,84)			
		end		
		if(目标是否可达(114,114))then	--随机了半小时
			移动(114,114)
			转向(2)		--115，114	
			
		end	if(目标是否可达(115,85))then	--随机了半小时
			移动(114,85)
			转向(2)		--115，114				
		end	
		if(目标是否可达(97,109))then
			移动(97,109)
			转向(0)			
		end	
		if(取物品数量("侦探眼镜")>0)then
			移动(109,123)
			转向坐标(109,124)
		end
		if(取物品数量("仙花")>0)then
			移动(109,77)
			转向坐标(109,76)
		end
	end	
	goto begin
	
::huan2::
	if(取物品数量("622058") < 1 and 取物品数量("622055") > 0)then
		
		while true do
			if(人物("坐标")  ~= "70,102")then
				goto begin			
			end	
			转向(4)
			交易(交易对象名称[2],"物品:622055|1|1","物品:622058|1|1",10000)
			if(取物品数量("622058") > 0)then
				日志("二次换花结束!")
				break
			end
			日志("等待二次换花!",1)
		end	
	end
	goto begin

::map59932::	--白色方舟·第三层
	if(取物品数量("622062") > 0)then
		if(目标是否可达(122,90))then
			移动(122,90)
			goto huan3
		end	
	end
	if(取物品数量("622061") > 0)then		--第二次换完
		if(目标是否可达(101,17))then
			移动(101,17)
			对话选是(101,16)
		end	
	end	
	if(取物品数量("622060") > 0)then		--第四次换完 侦探做任务
		if(目标是否可达(121,125))then
			移动(121,125)
			转向(0)			
		end			
		if(目标是否可达(90,112))then
			移动(90,112)
			转向坐标(89,112)			
		end	
		if(目标是否可达(146,88))then
			移动(146,88)
			转向坐标(145,88)			
		end	
		if(目标是否可达(53,57))then
			移动(53,57)
			转向坐标(53,56)			
		end	
	end
	goto begin
::huan3::
	if(取物品数量("622061") < 1 and 取物品数量("622062") > 0)then
		
		while true do
			if(人物("坐标")  ~= "122,90")then
				goto begin			
			end	
			转向(4)
			等待交易(交易对象名称[1],"物品:622062|1|1","物品:622061|1|1",10000)
			if(取物品数量("622061") > 0)then
				日志("三次换花结束!")
				break
			end
			日志("等待三次换花!",1)
		end	
	end
	goto begin
::map59933::	--白色方舟·第四层
	if(取物品数量("622061") > 0)then
		if(目标是否可达(99,83))then
			移动(99,83)
			goto huan4
		end	
	end
	if(取物品数量("622060") > 0)then		--第四次换完
		playerJob=人物("职业")
		if(playerJob == "药剂师")then			
		elseif(playerJob == "厨师" )then--and 取物品数量("鳖料理") > 0
		elseif(playerJob == "樵夫" )then--and 取物品数量("鳖料理") > 0
		elseif(playerJob == "猎人" )then--and 取物品数量("鳖料理") > 0
		elseif(playerJob == "矿工" )then--and 取物品数量("鳖料理") > 0
			if(取物品叠加数量("奥利哈钢")>20)then				
				移动(95,79)
				对话选是(95,78)
				日志("可以进行4转了",1)
				goto begin
			end
		elseif(playerJob == "仙人" )then--and 取物品数量("鳖料理") > 0
			if(取物品数量("仙花")>0)then
				移动(95,79)
				对话选是(95,78)
--				喊话("完成")
				goto begin
			end
			移动(93,85)
			转向坐标(92,85)
		elseif(playerJob == "鉴定" )then--and 取物品数量("鳖料理") > 0
			if(取物品数量("陨石？")>0)then
				工作("鉴定","陨石？",15000,false)				
				等待工作返回(15000)					
				移动(95,79)
				对话选是(95,78)
--				喊话("完成")
				goto begin
			end
			if(取物品数量("谜之陨石")>0)then				
				移动(95,79)
				对话选是(95,78)
--				喊话("完成")
				goto begin
			end
			移动(93,78)
			转向坐标(92,78)
		elseif(playerJob == "侦探" )then--and 取物品数量("鳖料理") > 0
			if(取物品数量("侦探眼镜")>0)then
				移动(95,79)
				对话选是(95,78)
--				喊话("完成")
				goto begin
			end
			移动(93,85)
			转向坐标(92,85)
		elseif(playerJob == "武器修理工" )then--and 取物品数量("鳖料理") > 0
		elseif(playerJob == "防具修理工" )then--and 取物品数量("鳖料理") > 0
			
		end
		if(目标是否可达(68,97))then
			移动(68,97)
			转向坐标(69,96)
		end	
	end	
	goto begin
::huan4::
	if(取物品数量("622060") < 1 and 取物品数量("622061") > 0)then
		
		while true do
			if(人物("坐标")  ~= "99,83")then
				goto begin			
			end	
			转向(2)
			交易(交易对象名称[2],"物品:622061|1|1","物品:622060|1|1",10000)
			if(取物品数量("622060") > 0)then
				日志("4次换花结束!")
				break
			end
			日志("等待四次换花!",1)
		end	
	end
	goto begin
::map59934::		--4转 露比对话
	--等待组队 	
	if(取物品数量("龙心") > 0)then
		if(目标是否可达(149,78))then
			移动(149,78)	
			对话选是(149,79)
		end	
	end
	if(取当前地图编号() == 59934 and 目标是否可达(98,15))then
		移动(98,15)
		对话选是(99,15)	
	end		
	--检测职业是生产 并且没有11级技能 则去学那个 否则来拿11技能格 
	--貌似不是生产 不能对话的，如果有11级 会传到下面去  那就不用判断了
	if(取当前地图编号() == 59934 and 目标是否可达(64,60))then
		移动(63,60)
		对话选是(64,60)	
	end			
	
	if(取当前地图编号() == 59934 and 目标是否可达(51,131))then
		移动(51,131)
		对话选是(51,132)	
	end			
	if(取当前地图名() == "光之路")then
		日志("恭喜4转完成，可以回城去提升阶级了!",1)
		return	--脚本退出
	end
end
main()