★雪塔50\55\60\65\70\75\79楼队长脚本。楼层可以自己选定。起点国民会馆108.42附近。
     
设置("timer", 200)						-- 设置定时器，单位毫秒  						
设置("高速延时", 4)                     -- 高速战斗时的操作等待时间单位秒，3以上为好，不然容易断线
                     -- 设置遇敌方式3为随机4为原地

雪塔补魔值=用户输入框( "多少魔以下补魔", "100")
雪塔补血值=用户输入框( "多少血以下补血", "100")
雪塔宠补血值=用户输入框( "宠多少血以下补血", "100")
雪塔宠补魔值=用户输入框( "宠多少魔以下补魔", "100")
是否50=用户输入框( "是否在T50楼练级，否填10000，是填0，", "0")
是否55=用户输入框( "是否在T55楼练级，否填10000，是填0，", "10000")
是否60=用户输入框( "是否在T60楼练级，否填10000，是填0，", "10000")
是否65=用户输入框( "是否在T65楼练级，否填10000，是填0，", "10000")
是否70=用户输入框( "是否在T70楼练级，否填10000，是填0，", "10000")
是否75=用户输入框( "是否在T75楼练级，否填10000，是填0，", "10000")
是否79=用户输入框( "是否在T79楼练级，否填10000，是填0，", "10000")



goto jinta 
等待到指定地图("国民会馆", 1)


::care::
	移动(112, 50)
	移动(109, 50)
	移动(109, 51)
	移动(107, 51)
	移动(109, 51)
	回复(5)         -- 恢复人宠	
	等待(13000)      
	移动(109, 50)
	移动(112, 50)
	移动(112, 46)
	移动(109, 42)
	移动(109, 43)
	移动(109, 42)
	移动(109, 43)
	移动(109, 42)
	卖(2, "魔石")
	
	等待(13000)
	移动(108, 42)
::jinta::
	移动(108, 40)
	printf("钱")
  	
  	移动(108, 39)


等待到指定地图("雪拉威森塔１层")	
  	移动(75, 50)

panding：
	等待到指定地图("雪拉威森塔５０层", 1)
	if(人物("血") > 是否50)then goto  t50 end
	if(人物("血") > 是否55)then goto  lu1 end
	if(人物("血") > 是否60)then goto  lu1 end
	if(人物("血") > 是否65)then goto  lu1 end
	if(人物("血") > 是否70)then goto  lu1 end
	if(人物("血") > 是否75)then goto  lu1 end
	if(人物("血") > 是否79)then goto  lu1 end


::t50::
	等待到指定地图("雪拉威森塔５０层", 1)
	
	等待(2000)     

	开始遇敌()         
::scriptstart50::    
	if(人物("魔") < 雪塔补魔值)then goto  salebegin50 end         
	if(人物("血") < 雪塔补血值)then goto  salebegin50 end
	if(宠物("血") < 雪塔宠补血值)then goto  salebegin50 end
	if(宠物("魔") < 雪塔宠补魔值)then goto  salebegin50 end
	goto scriptstart50        
::salebegin50::	
	停止遇敌() 	
	移动(77, 59)	
	移动(78, 59)
	等待到指定地图("雪拉威森塔１层", 1)
	
	移动(75, 60)
	goto huibu  



::lu1::
	移动(63, 47)	
	if(人物("血") > 是否55)then goto  lu2 end
	if(人物("血") > 是否60)then goto  lu2 end
	if(人物("血") > 是否65)then goto  lu2 end
	if(人物("血") > 是否70)then goto  lu2 end
	if(人物("血") > 是否75)then goto  lu3 end
	if(人物("血") > 是否79)then goto  lu3 end
::lu2::	
	移动(27, 59)	
	if(人物("血") > 是否55)then goto  t55 end
	if(人物("血") > 是否60)then goto  t60 end
	if(人物("血") > 是否65)then goto  t65 end
	if(人物("血") > 是否70)then goto  t70 end

::t55::
	移动(27, 56)
	
  	移动(27, 55)
	等待到指定地图("雪拉威森塔５５层", 1)
	
	等待(2000)
     

	开始遇敌()         
::scriptstart55::    
	if(人物("魔") < 雪塔补魔值)then goto  salebegin55 end         
	if(人物("血") < 雪塔补血值)then goto  salebegin55 end
	if(宠物("血") < 雪塔宠补血值)then goto  salebegin55 end
	if(宠物("魔") < 雪塔宠补魔值)then goto  salebegin55 end
	goto scriptstart55        
::salebegin55::
	
	停止遇敌() 
	
	移动(132, 93)
	
	移动(133, 93)
	等待到指定地图("雪拉威森塔５０层", 1)
	
	移动(27, 59)
	goto huibu1  


::t60::
  	移动(25, 55)
	等待到指定地图("雪拉威森塔６０层")	
	等待(2000)
	开始遇敌()         
::scriptstart60::    
	if(人物("魔") < 雪塔补魔值)then goto  salebegin60 end         
	if(人物("血") < 雪塔补血值)then goto  salebegin60 end
	if(宠物("血") < 雪塔宠补血值)then goto  salebegin60 end
	if(宠物("魔") < 雪塔宠补魔值)then goto  salebegin60 end
	goto scriptstart60        
::salebegin60::
	
	停止遇敌() 	
	移动(95, 145)	
	移动(95, 144)
	等待到指定地图("雪拉威森塔５０层")	
	移动(25, 59)	
	移动(27, 59)
	goto huibu1  

::t65::
	移动(23, 59)	
	移动(23, 56)	
  	移动(23, 55)
	等待到指定地图("雪拉威森塔６５层")	
	等待(2000) 
	开始遇敌()         
::scriptstart65::    
	if(人物("魔") < 雪塔补魔值)then goto  salebegin65 end         
	if(人物("血") < 雪塔补血值)then goto  salebegin65 end
	if(宠物("血") < 雪塔宠补血值)then goto  salebegin65 end
	if(宠物("魔") < 雪塔宠补魔值)then goto  salebegin65 end
	goto scriptstart65        
::salebegin65::	
	停止遇敌() 
	移动(148, 54)
	等待到指定地图("雪拉威森塔５０层")	
	移动(23, 59)
	移动(27, 59)
	goto huibu1  

::t70::
  	移动(21, 55)
	等待到指定地图("雪拉威森塔７０层")	
	等待(2000)       
	开始遇敌()         
::scriptstart70::    
	if(人物("魔") < 雪塔补魔值)then goto  salebegin70 end         
	if(人物("血") < 雪塔补血值)then goto  salebegin70 end
	if(宠物("血") < 雪塔宠补血值)then goto  salebegin70 end
	if(宠物("魔") < 雪塔宠补魔值)then goto  salebegin70 end
	goto scriptstart70        
::salebegin70::	
	停止遇敌() 
	移动(78, 55)
	等待到指定地图("雪拉威森塔５０层")	
	移动(27, 59)
	goto huibu1  


::lu3::	
	移动(24, 47)
	if(人物("血") > 是否75)then goto  t75 end
	if(人物("血") > 是否79)then goto  t79 end

::t75::
	移动(24, 45)	
  	移动(24, 44)
	等待到指定地图("雪拉威森塔７５层")
	等待(2000)     

	开始遇敌()         
::scriptstart75::    
	if(人物("魔") < 雪塔补魔值)then goto  salebegin75 end         
	if(人物("血") < 雪塔补血值)then goto  salebegin75 end
	if(宠物("血") < 雪塔宠补血值)then goto  salebegin75 end
	if(宠物("魔") < 雪塔宠补魔值)then goto  salebegin75 end
	goto scriptstart75        
::salebegin75::	
	停止遇敌() 
	移动(137, 133)
	等待到指定地图("雪拉威森塔５０层")	
	移动(24, 47)
	goto huibu2  



::t79::
	移动(22, 47)
	
	移动(22, 45)
	
  	移动(22, 44)
	等待到指定地图("雪拉威森塔８０层")

  	移动(159, 123)
	
	等待到指定地图("雪拉威森塔７９层")
	等待(2000)      
	开始遇敌()         
::scriptstart79::    
	if(人物("魔") < 雪塔补魔值)then goto  salebegin79 end         
	if(人物("血") < 雪塔补血值)then goto  salebegin79 end
	if(宠物("血") < 雪塔宠补血值)then goto  salebegin79 end
	if(宠物("魔") < 雪塔宠补魔值)then goto  salebegin79 end
	goto scriptstart79        
::salebegin79::	
	停止遇敌() 	
	移动(161, 122)
	等待到指定地图("雪拉威森塔８０层")	
  	移动(162, 122)
	等待到指定地图("雪拉威森塔５０层")
	移动(24, 47)
	goto huibu2  

::huibu::	
	移动(33, 99)	
	等待到指定地图("国民会馆")      
	等待(2000) 
	
	移动(108, 46)
	移动(112, 46)
	移动(112, 50)
	goto care 


::huibu1::	
	移动(63, 47)	
	goto hui1lou 


::huibu2::
	移动(62, 47)	
	goto hui1lou 

::hui1lou::
	移动(78, 59)	
	等待到指定地图("雪拉威森塔１层")	
	移动(75, 60)
	goto huibu  

