没多写  随便写了点  自动跑路学二戒 起点新城  请自己补好魔
::begin::	
	等待(500)
	自动寻路(144,105)
	自动寻路(157,93)
	转向(2, "")	
	等待到指定地图("艾夏岛", 1)	
	转向(6, "")
	等待到指定地图("艾夏岛", 164,159)	
	转向(7, "")
	等待到指定地图("艾夏岛", 151,97)
	自动寻路(190,115)	
	等待到指定地图("盖雷布伦森林")
	自动寻路(231,222)		
::start_2::	
	等待到指定地图("布拉基姆高地")		
	自动寻路(91, 192)
	等待(1000)
	使用物品("梯子")	
	等待服务器返回()
	对话选择(1, 0)	    --1代表确定	
	等待(1000)
::midao::
	等待到指定地图("秘道　第３层")		
	自动寻路(234,121)
::midao2::
	等待到指定地图("秘道　第２层")	
	自动寻路(96,122)	
	自动寻路(114,122)	
	自动寻路(114,81)	
	自动寻路(130,81)	
	自动寻路(130,73)	
	自动寻路(121,73)	
	自动寻路(121,69)	
	自动寻路(119,69)	
	自动寻路(119,59)	
	自动寻路(126,59)	
	自动寻路(129,56)	
	自动寻路(132,56)	
	自动寻路(133,54)
::midao3::
	等待到指定地图("秘道　第１层")	
	自动寻路(142,78)	
	自动寻路(149,78)	
	自动寻路(149,76)	
	自动寻路(152,76)	
	自动寻路(152,87)	
	自动寻路(151,88)	
	自动寻路(151,110)	
	自动寻路(150,111)	
	等待(1000)
	使用物品("梯子")	
	等待服务器返回()
	对话选择(1, 0)	    --1代表确定	
	等待(1000)
	goto hanhua
::hanhua::
	喊话("二戒地点到达，请自己去学",2,3,5)	
	等待(1000)
    goto hanhua