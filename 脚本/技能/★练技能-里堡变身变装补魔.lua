
设置("自动加血",0)
::dengru::
	local 当前地图名 = 取当前地图名()
	x,y=取当前坐标()	
	if (当前地图名=="艾尔莎岛" )then	
		goto star1
	elseif (当前地图名=="里谢里雅堡" )then	
		goto star2		
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
    goto star2
::star2::	
	if (人物("魔") < 10 )then	
		自动寻路(34,89)
		renew(1)
	end
	自动寻路(27,83)
	转向(0)
	goto dengru	