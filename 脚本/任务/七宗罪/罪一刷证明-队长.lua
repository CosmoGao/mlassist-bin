设置脚本简介("罪一刷证明队员版,请自己设置战斗")

teamLeader="风依旧￠花依然"
setTeamCount=5--组队人数多少去做任务
::dengru::
	当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto star1
	elseif (当前地图名=="里谢里雅堡" )then	
		goto star2	
	elseif (当前地图名=="莎莲娜" )then	
		goto jindong
	elseif (当前地图名=="启程之间" )then	
		goto chuanSongJieCun
	elseif (当前地图名=="杰诺瓦镇的传送点" )then	
		goto ziDongDuDui
	elseif (当前地图名=="贝兹雷姆小道" )then	
		goto goDaBoss
	end	
	地图编号 = 取当前地图编号()
	if (地图编号==44879 )then	
		goto bossFini
	elseif (地图编号==44877)then	
		goto goBattleBoss2
	elseif (地图编号==44878)then	
		goto goBattleBoss22
	end
	等待(2000)
	goto dengru
::star1::
	自动寻路(140,105)
	等待(500)
	转向(1)
	等待服务器返回()
	对话选择(4,0)	
	等待到指定地图("里谢里雅堡")	
	自动寻路(41,83)
	等待(1000)
    goto dengru
::star2::	
	if( 是否目标附近(34,70)) then	
		if( 取物品数量("灵魂晶石") < 1) then
			转向坐标(34,70)		
			等待服务器返回()
			对话选择(32,0)	
			等待服务器返回()
			对话选择(4,0)	
			等待服务器返回()
			对话选择(1,0)	
		else
			--去杰村
		end
		if( 取物品数量("灵魂晶石") < 1) then
			喊话("接任务失败，请查看任务条件重试",2,3,5)
			等待(1000)
		else
			等待(7000)--等待队友拿到 不监测喊话了
			--去杰村
		end		
		等待(1000)
		goto dengru		
	end		
	x,y=取当前坐标()		
	if( x == 41 and y == 83) then	
		人数=取队伍人数()
		while(人数 != setTeamCount)
		do						
			等待(3000)
			人数 = 取队伍人数()
		end
		自动寻路(34,71)
		等待(1000)
		自动寻路(33,71)
		等待(1000)
		自动寻路(34,71)
		等待(1000)
		自动寻路(33,71)
		等待(1000)
		自动寻路(34,71)
		等待(1000)
		自动寻路(33,71)		
		等待(1000)
		goto star2	
	end
    等待(1000)
	goto dengru
::chuanSongJieCun::
	if (是否目标附近(16,4)) then
		转向坐标(16,4)
		等待服务器返回()	
		对话选择(4,0)			
	end
	等待(2000)
	goto dengru
::jindong::		
	if( 是否目标附近(150,334)) then		
		转向坐标(150,334)		
		等待服务器返回()	
		对话选择(1,-1)	
	end				
	等待(1000)
	goto dengru
::xiaodao1::
	自动寻路(28,3)
	自动寻路(29,3)
	等待(2000)
::xiaodao2::
	自动寻路(68,8)
	自动寻路(67,7)
	等待(2000)
::xiaodao3::
	自动寻路(107,29)
	自动寻路(108,29)
	等待(2000)
::xiaodao4::
	自动寻路(106,74)
	自动寻路(106,73)
	等待(2000)
::xiaodao5::
	自动寻路(43,97)
	自动寻路(43,98)
	等待(2000)
::xiaodao6::
	自动寻路(10,78)
	自动寻路(10,77)
	等待(2000)
::xiaodao7::
	自动寻路(14,15)
	--自动寻路(14,14)--boss
	等待(2000)
::battleBoss::
	转向(0)
	等待服务器返回()	
	对话选择(1,-1)	
	等待(2000)
	goto dengru
::goBattleBoss2::
	转向(0)	
	等待(2000)
	goto dengru
::goBattleBoss22::
	if(是否战斗中()) then
		等待(2000)
		goto dengru
	end
	自动寻路(11,12)
	转向(0)
	等待服务器返回()	
	对话选择(1,-1)		
	等待(2000)
	goto dengru
::bossFini::
	if( 取物品数量("灵魂晶石") < 1) then		
		等待(2000)
		goto dengru
	end		
	转向(0)
	等待服务器返回()
	对话选择(32,0)	
	等待服务器返回()
	对话选择(32,0)	
	等待服务器返回()
	对话选择(32,0)	
	等待服务器返回()
	对话选择(32,0)	
	等待服务器返回()
	对话选择(32,0)	
	等待服务器返回()
	对话选择(1,0)	
	等待(1000)
	goto dengru

::ziDongDuDui::
	if(取队伍人数() > 1)then
		等待(2000)
		goto dengru
	end
	加入队伍(teamLeader)
	等待(2000)
	goto dengru
::goDaBoss::
	if(取队伍人数() == setTeamCount )then
		goto xiaodao1
	end
	等待(2000)
	goto dengru