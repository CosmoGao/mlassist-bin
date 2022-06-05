设置脚本简介("营地换改图，坐标附近一格执行脚本")

::dengru::
	当前地图名 = 取当前地图名()
	if (当前地图名=="圣骑士营地" )then	
		goto star1
	else
		执行脚本("./脚本/直通车/★公交车-营地直通车.lua")
	end		
	等待(2000)
	goto dengru
::star1::	
	if(取物品叠加数量("能量结晶") < 5) then
		等待(2000)
		goto dengru
	end 
	if( 是否目标附近(120,90)) then		
		while 取包裹空格() > 0 do
			转向坐标(120,90)		
			等待服务器返回()		
			对话选择(4,0)	
			等待服务器返回()
			对话选择(1,0)			
		end		
	end			
    等待(1000)
	goto dengru