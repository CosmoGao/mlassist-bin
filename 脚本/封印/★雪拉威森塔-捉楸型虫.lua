★雪塔50\55\60\65\70\75\79楼队长脚本。楼层可以自己选定。起点国民会馆108.42附近。
     
设置("timer", 0)						-- 设置定时器，单位毫秒  						
设置("高速延时", 4)                     -- 高速战斗时的操作等待时间单位秒，3以上为好，不然容易断线
                     -- 设置遇敌方式3为随机4为原地

雪塔补魔值=用户输入框( "多少魔以下补魔", "100")
雪塔补血值=用户输入框( "多少血以下补血", "100")
雪塔宠补血值=用户输入框( "宠多少血以下补血", "100")
雪塔宠补魔值=用户输入框( "宠多少魔以下补魔", "100")
	
local cardName = "封印卡（昆虫系）"
local cardCount=20		--一次买多少

::begin::  
	--等待空闲()
	mapName=取当前地图名()
	mapNum=取当前地图编号()	
	if (人物("宠物数量") >= 5 )then	
		日志("宠物满了，去银行存货！")
		common.depositNoBattlePetToBank()
		if (人物("宠物数量") >= 5 )then	
			日志("银行宠物也满啦！请先清理，再重新执行脚本！")
			return
		end
	end
	if(mapName=="艾尔莎岛")then	goto aiersha	
	elseif (mapName=="利夏岛" )then	goto map59522
	elseif (mapName=="国民会馆" )then goto map59552	
	elseif (mapName=="雪拉威森塔１层" )then goto map59801
	elseif (mapName=="雪拉威森塔５０层" )then goto map59850
	elseif (mapName=="雪拉威森塔８５层" )then goto t85
	elseif (mapName=="雪拉威森塔８４层" )then goto yudi
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
	if(取物品叠加数量(cardName) < cardCount) then
		goto maika
	end
	common.checkHealth()
	自动寻路(165, 153)
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
	自动寻路(90,99,"国民会馆")
	goto care 
::map59552::
	等待到指定地图("国民会馆", 1)

::care::	
	自动寻路(109, 51)
	回复(5)         -- 恢复人宠		
	自动寻路(109, 42)
	卖(2, "魔石")		
::jinta::	
  	自动寻路(108, 39)
::map59801::
	等待到指定地图("雪拉威森塔１层")	
  	自动寻路(75, 50)
::map59850::
	等待到指定地图("雪拉威森塔５０层")		
	自动寻路(20, 44,"雪拉威森塔８５层")
::t85::
	自动寻路(59, 134,"雪拉威森塔８４层")
::yudi::
	--自动寻路(88,58)	     
	自动寻路(92,64)	     
	开始遇敌()         
::scriptstart85::    
	if(人物("魔") < 雪塔补魔值)then goto  salebegin85 end         
	if(人物("血") < 雪塔补血值)then goto  salebegin85 end
	if(宠物("血") < 雪塔宠补血值)then goto  salebegin85 end
	if(宠物("魔") < 雪塔宠补魔值)then goto  salebegin85 end
	if(取物品叠加数量(cardName) < 1)then goto  salebegin85 end
	if(取当前地图编号() ~= 59884)then goto  salebegin85 end
	if (人物("宠物数量") >= 5 )then	
		日志("宠物数量满了，回城存储！")
		goto salebegin85	
	end
	等待(3000)
	goto scriptstart85        
::salebegin85::	
	停止遇敌() 	
	等待空闲()
	回城()
	goto begin
	
::maika::
	自动寻路(144,105)
	自动寻路(157,93)
	转向(2)	
	等待到指定地图("艾夏岛", 1)	
	转向(6)
	等待到指定地图("艾夏岛", 164,159)	
	转向(7)
	等待到指定地图("艾夏岛", 151,97)	
	自动寻路(150, 125,"克罗利的店")
::shop::
	自动寻路(40,23)
	转向(2)
	等待服务器返回()
	nowCount = cardCount-取物品叠加数量(cardName)
	common.buyDstItem(cardName,nowCount)	
::outshop::
	if(取物品叠加数量(cardName) < cardCount) then
		goto shop
	end
	回城()
	goto begin