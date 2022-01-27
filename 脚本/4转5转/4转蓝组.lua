\\蓝组换花，路上逃跑，启动点28.108，换好一层花90.131启动，换好二层花127.102启动，换好三层花55.120启动
设置("高速战斗", 1)             -- 高速战斗时的操作等待时间单位秒，3以上为好，不然容易断线
设置("高速延时", 4)             -- 高速战斗速度，0速度最低，6速度最高

--绿 红 绿 红
--交易对象名称={"￠衣服￡","￠星￡梦￠"}

交易对象名称={}



队长名称 = 交易对象名称[2]

--设置("timer", 100)			-- 设置定时器，单位毫秒 内置100毫秒 不要太快
设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 开启高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 开启遇敌全跑 
设置("自动加血", 0)			-- 关闭自动加血，脚本对话加血 
走路加速值=125	
走路还原值=100	
上次迷宫楼层=1
当前迷宫楼层=1

function GetTableSize(tmpTable)
	if(tmpTable == nil) then
		return 0		
	end
	local nSize=0
	for i,v in ipairs(tmpTable) do
		nSize=nSize+1	
	end
	return nSize
end
function 判断队长()
	local teamPlayers=队伍信息()
	local count=0
	for i,teammate in ipairs(teamPlayers)do
		count=count+1
		--日志(i..teammate.name .."队长名称："..队长名称)
		if( i==1 and teammate.name ~= 队长名称) then	
			--日志(i..teammate.name .."!- 队长名称："..队长名称)
			return false
		else
			break
		end
	end
	if count ==0 then
		return false
	else
		return true
	end
end

--等待入队
function waitAddTeam()
	local tryNum=0
::begin::	
	加入队伍(队长名称)
	if(取队伍人数()>1)then
		if(判断队长()==true) then
			return
		else
			离开队伍()
		end		
	end
	if(是否空闲中()==false)then
		return
	end
	if(tryNum>10)then
		return
	end
	goto begin
end

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
	GetOathGroup("绿组","红组")	
	if(交易对象名称[1] == nil)then		
		交易对象名称[1]=用户下拉框("绿组名称", teamNameList)
	end	
	if(交易对象名称[2] == nil)then	
		交易对象名称[2]=用户下拉框("红组名称", teamNameList)
	end
	日志("绿组名称:"..交易对象名称[1],1)
	日志("红组名称:"..交易对象名称[2],1)
	--默认蓝组不打龙，上面加队
	队长名称=取脚本界面数据("队长名称",false)	
	if(队长名称==nil or 队长名称=="")then
		队长名称 = 交易对象名称[2]
	end
	if(队长名称==nil or 队长名称=="")then
		队长名称=用户输入框("请输入队长名称！","星￠空")--风依旧￠花依然  乱￠逍遥
	end
	日志("队长名称："..队长名称,1)
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
	elseif(当前地图名 == "黑色方舟第1层")then	
		goto 穿越迷宫 
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
	if(取物品数量("622054") > 0)then
		if(目标是否可达(89,131))then
			移动(89,131)
			goto huan1
		end	
	end
	if(取物品数量("622053") > 0)then		--第一次还完
		if(目标是否可达(147,138))then
			移动(147,138)
			对话选是(148,137)
		end	
	end
	if(目标是否可达(21,108))then		--拿花
		移动(21, 108)
		对话选是(2)
	elseif(目标是否可达(59,141))then	--传送去换花
		移动(59,141)
		对话选是(60,142)			
	end
	goto begin
::huan1::
	if(取物品数量("622053") < 1 and 取物品数量("622054") > 0)then
		
		while true do
			if(人物("坐标")  ~= "89,131")then
				goto map59930			
			end	
			转向(0)
			交易(交易对象名称[1],"物品:622054|1|1","物品:622053|1|1",10000)
			if(取物品数量("622053") > 0)then
				break
			end
			日志("等待一次换花!",1)
		end	
	end
	goto map59930
::map59931::	--白色方舟·第二层
	if(取物品数量("622057") > 0)then
		if(目标是否可达(126,102))then
			移动(126,102)
			goto huan2
		end	
	end
	if(取物品数量("622056") > 0)then		--第二次换完
		if(目标是否可达(152,108))then
			移动(152,108)
			对话选是(153,108)
		end	
	end	
	goto begin
::huan2::
	if(取物品数量("622056") < 1 and 取物品数量("622057") > 0)then
		
		while true do
			if(人物("坐标")  ~= "126,102")then
				goto begin			
			end	
			转向(0)
			等待交易(交易对象名称[2],"物品:622057|1|1","物品:622056|1|1",10000)
			if(取物品数量("622056") > 0)then
				break
			end
			日志("等待二次换花!",1)
		end	
	end
	goto begin

::map59932::	--白色方舟·第三层
	if(取物品数量("622060") > 0)then
		if(目标是否可达(54,120))then
			移动(54,120)
			goto huan3
		end	
	end
	if(取物品数量("622059") > 0)then		--第二次换完
		if(目标是否可达(36,121))then
			移动(36,121)
			对话选是(37,120)
		end	
	end	
	goto begin
::huan3::
	if(取物品数量("622059") < 1 and 取物品数量("622060") > 0)then
		
		while true do
			if(人物("坐标")  ~= "54,120")then
				goto begin			
			end	
			转向(0)
			交易(交易对象名称[1],"物品:622060|1|1","物品:622059|1|1",10000)
			if(取物品数量("622059") > 0)then
				break
			end
			日志("等待三次换花!",1)
		end	
	end
	goto begin
::map59933::	--白色方舟·第四层
	移动(99,95)
	移动(100,95)
	等待到指定地图("黑色方舟第1层")	
	--穿越迷宫 去最后等
::穿越迷宫::
	当前地图名 = 取当前地图名()
	if(string.find(当前地图名,"黑色方舟") == nil) then	--白色方舟会跳到下面
		goto begin	
	end
	当前迷宫楼层=取当前楼层(当前地图名)	--从地图名取楼层
	if(当前迷宫楼层 < 上次迷宫楼层 )then	--反了
		tx,ty=取迷宫远近坐标(false)	--取最近迷宫坐标
		移动(tx,ty)		
		当前迷宫楼层=取当前楼层(取当前地图名())	
	end	
	上次迷宫楼层=当前迷宫楼层
	自动迷宫()
	等待(1000)
	goto 穿越迷宫
	
	
::map59934::		--4转 露比对话	
	--判断蓝组是否已经有龙心，有的话去对话	
	if(取物品数量("龙心") > 0)then
		if(目标是否可达(149,78))then
			移动(149,78)	
			对话选是(149,79)
		end	
	end
	--没有龙心，组队4转
	if(目标是否可达(149,78))then
		if(取队伍人数()>1)then
			if(判断队长()==true) then
				等待(5000)	--等待队长对话成功
				goto begin
			else
				离开队伍()
			end		
		end
		waitAddTeam()
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
	goto begin
end
main()
	