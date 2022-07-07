★雪塔50\55\60\65\70\75\79楼队长脚本。楼层可以自己选定。起点国民会馆108.42附近。
     
设置("timer", 0)						-- 设置定时器，单位毫秒  						
设置("高速延时", 4)                     -- 高速战斗时的操作等待时间单位秒，3以上为好，不然容易断线
                     -- 设置遇敌方式3为随机4为原地

local 雪塔补魔值=用户输入框( "多少魔以下补魔", "200")
local 雪塔补血值=用户输入框( "多少血以下补血", "200")
local 雪塔宠补血值=用户输入框( "宠多少血以下补血", "200")
local 雪塔宠补魔值=用户输入框( "宠多少魔以下补魔", "200")

::begin::  
	等待空闲()
	mapName=取当前地图名()
	mapNum=取当前地图编号()	
	if(取包裹空格() < 1)then return end
	if(mapName=="艾尔莎岛")then	goto aiersha	
	elseif (mapName=="利夏岛" )then	goto map59522
	elseif (mapName=="国民会馆" )then goto map59552	
	elseif (mapName=="雪拉威森塔１层" )then goto map59801
	elseif (mapName=="雪拉威森塔５０层" )then goto map59895
	elseif (mapName=="雪拉威森塔８５层" )then goto yudi
	elseif (mapName=="雪拉威森塔９０层" )then goto yudi
	elseif (mapName=="雪拉威森塔９５层" )then goto yudi
	--elseif (mapName=="雪拉威森塔４０层" )then goto map59840
	--elseif (mapName=="雪拉威森塔３９层" )then goto map59839
	end
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth()
	common.checkCrystal(水晶名称)	
	回城()
	goto begin 
::aiersha::		
	common.checkHealth()
	移动(165, 153)
	转向(4)
	等待服务器返回()
	对话选择(32,0)
	等待服务器返回()
	对话选择(4, 0)		
	等待(1000)
::map59522::					--利夏岛
	if(取当前地图名() ~= "利夏岛")then
		goto begin
	end
	移动(90,99,"国民会馆")
	goto care 
::map59552::
	等待到指定地图("国民会馆")	
::care::	
	移动(109, 51)
	回复(5)         -- 恢复人宠		
	移动(109, 42)
	卖(2, "魔石")		
::jinta::	
  	移动(108, 39)
::map59801::
	等待到指定地图("雪拉威森塔１层")	
  	移动(75, 50)
::map59850::
	等待到指定地图("雪拉威森塔５０层")		
	goto map59895
::t85::
	移动(20, 44,"雪拉威森塔８５层")
	goto yudi
::map59890::
	移动(18, 44,"雪拉威森塔９０层")
	移动(61,42)	    
	goto yudi
::map59895::
	移动(16, 44,"雪拉威森塔９５层")
	移动(101,47)	    
	goto yudi
::yudi::	 
	开始遇敌()         
::scriptstart85::    
	if(人物("魔") < 雪塔补魔值)then goto  salebegin85 end         
	if(人物("血") < 雪塔补血值)then goto  salebegin85 end
	if(宠物("血") < 雪塔宠补血值)then goto  salebegin85 end
	if(宠物("魔") < 雪塔宠补魔值)then goto  salebegin85 end
	if(取包裹空格() < 1)then goto salebegin85 end
	if(取当前地图名() ~= "雪拉威森塔９５层")then goto salebegin85 end
	等待(3000)
	goto scriptstart85        
::salebegin85::	
	停止遇敌() 	
	等待空闲()
	回城()
	goto begin