★捉赤熊脚本，起点艾尔莎岛登入点，请设置好自动战斗,战斗1中设置好遇一级宠时的战斗方法 战斗2设置好宠物满下线保护，谢谢支持魔力辅助程序.脚本发现BUG联系Q:274100927-----------星落


-- 设置(timer, 300)						
-- 设置(timer1, 300)
-- 设置("高速遇敌",1)
-- 设置(auto_protect, AutoMove, 1)				-- 自动遇敌
-- 设置(auto_action, 自动战斗,1)
-- 设置(auto_action, 高速战斗, 1)
-- 设置(auto_action, 高速延迟,1)
-- 设置(auto_protect, AutoMoveType, 4)		--原地遇敌     
人补血值=用户输入框( "人血到多少去补", "280")
人补魔值=用户输入框( "人魔到多少去补", "30")
宠补血值=用户输入框( "宠补血值到多少去补", "50")
宠补魔值=用户输入框( "宠补魔值到多少去补", "50")

--盆地西 163 77   254 237
--盆地南 228 178 144 110

::begin:: 
	当前地图名 = 取当前地图名()		
	if (当前地图名=="艾尔莎岛" )then	
		goto aiersa  
	elseif (当前地图名=="里谢里雅堡" )then	
		goto libao  
	elseif (当前地图名=="方堡盆地" )then	
		goto penDi  		
	end
	
	回城()
	等待(2000)
	goto begin
::aiersa::
    等待到指定地图("艾尔莎岛", 140, 105)        
	转向(1)
	等待服务器返回()
	对话选择(4, 0)    
::libao::
	等待到指定地图("里谢里雅堡", 1)	
	自动寻路(31,90)
    goto bu

::bu::
   自动寻路(34,89)
	renew(1)			-- 转向北边恢复人宠血魔	
	goto chickxxx
     
  
::chickxxx::
	if (人物("血") < 人补血值 )then		
		goto  StartSale
	elseif (人物("魔") < 人补魔值 )then	
		goto  StartSale
	elseif (宠物("血") < 宠补血值 )then	
		goto  StartSale
	elseif (宠物("魔") < 宠补魔值 )then	
		goto  StartSale
	end
  goto StartBegin

::StartBegin::
  回城()
  等待(2000)

  等待到指定地图("艾尔莎岛", 140, 105)
  goto senlin

::senlin:: 
  自动寻路(130, 50)
  等待到指定地图("盖雷布伦森林", 1)
  自动寻路(215, 44)   
  对话选否(1)
::penDi::
  等待到指定地图("方堡盆地", 1)    
  自动寻路(182, 104)	       
  开始遇敌()            -- 开始自动遇敌
  goto ss1

::ss1::
	if (人物("血") < 人补血值 )then		
		goto  StartSale
	elseif (人物("魔") < 人补魔值 )then	
		goto  StartSale
	elseif (宠物("血") < 宠补血值 )then	
		goto  StartSale
	elseif (宠物("魔") < 宠补魔值 )then	
		goto  StartSale
	end
	goto ss1

::xz1::

::StartSale::  
  停止遇敌()                 -- 结束战斗   
  goto begin

