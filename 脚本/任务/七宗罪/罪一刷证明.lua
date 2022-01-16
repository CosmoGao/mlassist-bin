设置脚本简介("罪一刷证明队员版,请自己设置战斗")

teamLeader="风依旧￠花依然"
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
		goto ziDongDuDui
	end	
	地图编号 = 取当前地图编号()
	if (地图编号==44879 )then	
		goto bossFini
	end
	--boss完成 地图编号 44879
	等待(2000)
	goto dengru
::star1::
	移动(140,105)
	等待(500)
	转向(0)
	等待服务器返回()
	对话选择(4,0)	
	等待到指定地图("里谢里雅堡")	
	移动(41,82)
	等待(1000)
    goto dengru
::star2::	
	等待到指定地图("里谢里雅堡")
	if( 是否目标附近(34,70)) then		
		转向坐标(34,70)		
		等待服务器返回()
		对话选择(32,0)	
		等待服务器返回()
		对话选择(4,0)	
		等待服务器返回()
		对话选择(1,0)	
		if( 取物品数量("灵魂晶石") < 1) then
			喊话("接任务失败，请查看任务条件重试",2,3,5)
			等待(1000)
		end		
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
	移动(28,3)
	移动(29,3)
::xiaodao2::
	移动(68,8)
	移动(67,7)
::xiaodao3::
	移动(107,29)
	移动(108,29)
::xiaodao4::
	移动(106,74)
	移动(106,73)
::xiaodao5::
	移动(43,97)
	移动(43,98)
::xiaodao6::
	移动(10,78)
	移动(10,77)
::xiaodao7::
	移动(14,15)
	移动(14,14)--boss
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
	等待(2000)
	goto dengru

::ziDongDuDui::
	if(取队伍人数() > 1)then
		等待(2000)
		goto dengru
	end
	加入队伍(teamLeader)
	等待(2000)
	goto dengru