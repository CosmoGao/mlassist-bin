
minMp=100	--最少魔
::dengru::
	local 当前地图名 = 取当前地图名()
	x,y=取当前坐标()	
	if (当前地图名=="艾尔莎岛" )then	
		goto star1
	elseif (当前地图名=="里谢里雅堡" )then	
		goto star2	
	elseif (x==34 and y==89 )then	
		goto work
	end	
	等待(2000)
	goto dengru
::star1::
	移动(140,105)
	等待(500)
	转向(1)
	等待服务器返回()
	对话选择(4,0)	
	等待到指定地图("里谢里雅堡")		
    goto star2
::star2::	
	移动(34,89)
::work::
	x,y=取当前坐标()	
	if (x ~= 34 and y ~= 89 )then	
		goto dengru
	end
	if (人物("魔") < minMp )then	
		装备物品("如月沙罗戒")
		等待(2000)		
		转向(1)
		等待(3000)	--等待自动回补		
		if (人物("魔") > minMp )then	
			取下装备("如月沙罗戒")
			等待(2000)
			装备物品("如月沙罗戒")
			等待(2000)
		end
	elseif (人物("血") ==人物("maxhp")) then	
		取下装备("如月沙罗戒")
		等待(2000)
		装备物品("如月沙罗戒")
		等待(2000)
	end
	等待(2000)
	goto dengru	