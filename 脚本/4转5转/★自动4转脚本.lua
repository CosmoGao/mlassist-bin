\\4转换花，自己设置逃跑，4个组组队，然后运行脚本，会自动检测队伍其他组信息，自动交易
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
defGroup={
	["红组"]={"黄组","蓝组"},
	["黄组"]={"红组","绿组"},
	["绿组"]={"蓝组","黄组"},
	["蓝组"]={"绿组","红组"}	
	}

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
--单纯启动开关，不嵌入脚本
function main()	
	local oathGroup = 人物("4转属组")
	-- local 交易组类型 = defGroup[oathGroup]
	-- 日志("当前4转属组:"..oathGroup,1)
	-- 设置个人简介("玩家称号",oathGroup)
	-- teamNameList={}
	-- GetOathGroup(交易组类型[1],交易组类型[2])	
	-- if(交易对象名称[1] == nil)then		
		-- 交易对象名称[1]=用户下拉框(交易组类型[1].."名称", teamNameList)
	-- end	
	-- if(交易对象名称[2] == nil)then	
		-- 交易对象名称[2]=用户下拉框(交易组类型[2].."名称", teamNameList)
	-- end	
	-- 日志(交易组类型[1].."名称:"..交易对象名称[1],1)
	-- 日志(交易组类型[2].."名称:"..交易对象名称[2],1)
	if(oathGroup == "红组")then
		执行脚本("./脚本/4转5转/4转红组.lua")
	elseif(oathGroup == "黄组")then
		执行脚本("./脚本/4转5转/4转黄组.lua")	
	elseif(oathGroup == "蓝组")then
		执行脚本("./脚本/4转5转/4转蓝组.lua")	
	elseif(oathGroup == "绿组")then
		执行脚本("./脚本/4转5转/4转绿组.lua")
	else
		日志("判断4转属组错误",1)
		return
	end		
end
main()