\\红组换花，路上逃跑，启动点28.96，换好一层花90.75启动，换好二层花127.100启动，换好三层花55.120启动
设置("高速战斗", 1)             -- 高速战斗时的操作等待时间单位秒，3以上为好，不然容易断线
设置("高速延时", 4)             -- 高速战斗速度，0速度最低，6速度最高

--黄 蓝 黄 
--交易对象名称={"星落々仙","星々空","￠衣服￡"}

--分组名称={"红组"="","绿组"="","蓝组"="","黄组"=""}

local 交易对象名称={}

--622043 622051
local 队伍人数=2	--用户输入框("队伍人数", "2")

--设置("timer", 100)			-- 设置定时器，单位毫秒 内置100毫秒 不要太快
设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 开启高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 开启遇敌全跑 
设置("自动加血", 0)			-- 关闭自动加血，脚本对话加血 
local 走路加速值=125	
local 走路还原值=100	


function 等待队伍人数达标()				--等待队友	
::begin::	
	等待(5000)
	if(队伍("人数") < 队伍人数) then	--数量不足 等待
		goto begin
	end		
	return 
end


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

function GetOathGroup()
	local teamPlayers
	local dstGroup=0
::begin::	
	dstGroup=0
	teamPlayers = 队伍信息()
	for index,teamPlayer in ipairs(teamPlayers) do			
		if(teamPlayer.nick_name == "黄组")then
			交易对象名称[1] = teamPlayer.name		
			dstGroup=dstGroup+1
		end
		if(teamPlayer.nick_name == "蓝组")then
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
	
	-- while true do
		-- if(队伍("人数") < 4)then		--一样一个
			-- 日志("请先组队，获取队伍信息",1)
		-- else
			-- break
		-- end		
	-- end
	local oathGroup = 人物("4转属组")
	日志("当前4转属组:"..oathGroup,1)
	设置个人简介("玩家称号",人物("4转属组"))
	teamNameList={}
	GetOathGroup()	
	if(交易对象名称[1] == nil)then		
		交易对象名称[1]=用户下拉框("黄组名称", teamNameList)
	end	
	if(交易对象名称[2] == nil)then	
		交易对象名称[2]=用户下拉框("蓝组名称", teamNameList)			
	end
	日志("黄组名称:"..交易对象名称[1],1)
	日志("蓝组名称:"..交易对象名称[2],1)	
	
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
		goto 找龙 
	elseif(string.find(取当前地图名(),"黑色方舟第")~=nil)then	
		goto mazeJudge 
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
	if(取物品数量("622051") > 0)then
		if(目标是否可达(89,75))then
			移动(89,75)
			goto huan1
		end	
	end
	if(取物品数量("622052") > 0)then		
		if(目标是否可达(163,78))then
			移动(163,78)
			对话选是(164,77)			
		end	
	end
	if(取物品数量("622043") > 0)then		
		if(目标是否可达(57,92))then	--传送去换花
			移动(57,92)
			对话选是(58,93)			
		end
	end
	if(目标是否可达(21,96))then		--拿花
		移动(21, 96)
		对话选是(2)
	end
	goto begin
::huan1::
	if(取物品数量("622052") < 1 and 取物品数量("622051") > 0)then
		while true do
			if(人物("坐标")  ~= "89,75")then
				goto map59930			
			end			
			转向(0)
			交易(交易对象名称[1],"物品:622051|1|1","物品:622052|1|1",10000)
			if(取物品数量("622052") > 0)then
				break
			end
			日志("等待一次换花!",1)
		end	
	end
	goto map59930
::map59931::	--白色方舟·第二层
	if(取物品数量("622056") > 0)then
		if(目标是否可达(126,100))then
			移动(126,100)
			goto huan2
		end	
	end
	if(取物品数量("622057") > 0)then		--第二次换完
		if(目标是否可达(152,88))then
			移动(152,88)
			对话选是(153,88)
		end	
	end	
	goto begin
::huan2::
	if(取物品数量("622057") < 1 and 取物品数量("622056") > 0)then
		while true do
			if(人物("坐标")  ~= "126,100")then
				goto begin			
			end	
		
			转向(4)
			交易(交易对象名称[2],"物品:622056|1|1","物品:622057|1|1",10000)
			if(取物品数量("622057") > 0)then
				break
			end
			日志("等待二次换花!",1)
		end	
	end
	goto begin

::map59932::	--白色方舟·第三层
	if(取物品数量("622061") > 0)then
		if(目标是否可达(122,92))then
			移动(122,92)
			goto huan3
		end	
	end
	if(取物品数量("622062") > 0)then		--第二次换完
		if(目标是否可达(88,40))then
			移动(88,40)
			对话选是(89,40)
		end	
	end	
	goto begin
::huan3::
	if(取物品数量("622062") < 1 and 取物品数量("622061") > 0)then		
		while true do
			if(人物("坐标")  ~= "122,92")then
				goto begin			
			end	
			转向(0)
			交易(交易对象名称[1],"物品:622061|1|1","物品:622062|1|1",10000)
			if(取物品数量("622062") > 0)then
				break
			end
			日志("等待三次换花!",1)
		end	
	end
	goto begin
::map59933::							--白色方舟·第四层
	移动(99,95)
	移动(100,95)	
	等待到指定地图("黑色方舟第1层")
	if(true)then
		return
	end
::找龙::								--搜索暗黑龙 打龙
	if(取物品数量("龙心") > 0)then			
		goto 穿越迷宫
	end
	if(是否空闲中()==false)then
		等待(2000)
		goto 找龙
	end		
	if(取当前地图编号()==map59933) then--迷宫刷新
		goto begin
	end
	if( string.find(取当前地图名(),"黑色方舟第")==nil)then	--不是迷宫 不找
		goto begin
	end
	找到,findX,findY,nextX,nextY=搜索地图("暗黑龙",1)
	if(找到) then		
		宠物("改状态","待命")
		设置("遇敌全跑", 0)		--单挑黑龙 
		日志("记录坐标: "..取当前地图名().." "..findX..","..findY,1)
		对话选是(findX,findY)			
		等待(3000)
		if(是否战斗中())then
			等待战斗结束()
		end
		等待空闲()
		if(取物品数量("龙心") > 0)then
			设置("遇敌全跑", 1)	
			宠物("改状态","战斗",5)	
			移动(nextX,nextY)
		else
			日志("单挑黑龙失败，请手动打boos，脚本停止！")
			return
		end
		goto 穿越迷宫
	end
	等待(2000)
	goto 找龙
::mazeJudge::			--迷宫判断
	if(取物品数量("龙心") > 0)then			
		goto 穿越迷宫
	end
	goto 找龙

::穿越迷宫::
	当前地图名 = 取当前地图名()
	if(string.find(当前地图名,"黑色方舟") == nil) then	--白色方舟会跳到下面
		goto begin	
	end
	mazeList = 取迷宫出入口()
	isDownMap=1
	if(GetTableSize(mazeList) > 1)then
		isDownMap=0		
	end
	自动迷宫(isDownMap)
	等待(1000)
	goto 穿越迷宫
	
::map59934::		--4转 露比对话
	--等待组队 	
	if(取物品数量("龙心") > 0)then
		移动(142,60)
		if(队伍("人数") < 队伍人数)then	--数量不足 等待
			等待队伍人数达标()
		end	
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
	goto begin
end
main()
	






