★雪塔14捉布卡  起点艾尔莎岛登入点，请设置好自动战斗,战斗1中设置好遇一级宠时的战斗方法 ::战斗2设置好宠物满下线保护，谢谢支持魔力辅助程序.脚本发现BUG联系Q::274100927-----------星落

设置("timer", 100)						


				-- 自动遇敌
设置("自动战斗",1)
设置("高速战斗", 1)
设置("高速延时",1)
		--原地遇敌      
人补魔=用户输入框( "人多少魔以下补魔", "50")
人补血=用户输入框( "人多少血以下补血", "300")
宠补魔=用户输入框( "宠多少魔以下补魔", "50")
宠补血=用户输入框( "宠多少血以下补血", "200")	
自动换水火的水晶耐久值=用户输入框( "多少耐久以下自动换水火的水晶不换可不填", "30")         

::start::
	
	回城()
	等待(3000)
	等待到指定地图("艾尔莎岛", 1)        
	if(取物品数量("封印卡（野兽系)") < 1)then goto  maika end
	自动寻路(140, 126)
	自动寻路(165, 151)
	自动寻路(165, 153)	
	转向(4, "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("利夏岛", 1)	
	等待(200)	
	自动寻路(93, 64)
	自动寻路(90, 67)
	自动寻路(90, 98)
	
	自动寻路( 90, 99)
	
	
	等待到指定地图("国民会馆", 1)
	
	等待(200)
	
	自动寻路(100, 50)
	自动寻路(104, 54)
	自动寻路(108, 54)
	
	回复(1)
	
	
	等待(600)
	
	自动寻路(104, 54)
	自动寻路(104, 46)
	自动寻路(108, 42)
	自动寻路(108, 39)
	
	
	等待到指定地图("雪拉威森塔１层", 1)
	
	等待(300)
	
	自动寻路(37, 99)
	等待(200)
	
	自动寻路(42, 99)
	自动寻路(46, 95)
	自动寻路(54, 87)
	自动寻路(62, 79)
	自动寻路(67, 74)
	自动寻路(72, 74)
	自动寻路(72, 69)
	自动寻路(72, 63)
	自动寻路(74, 61)
	自动寻路(74, 52)
	自动寻路(74, 56)
	自动寻路(75, 56)
	
	自动寻路(76, 56)
	
	
	等待到指定地图("雪拉威森塔１５层", 1)
	
	等待(300)
	
	自动寻路(129, 69)
	
	自动寻路(129, 70)
	
	等待到指定地图("雪拉威森塔１４层", 1)
	
	等待(300)
	
	自动寻路(239, 159)
	自动寻路(239, 153)
	
	开始遇敌()		-- 开始自动遇敌
	goto scriptstart 
::scriptstart::
	if(人物("魔") < 人补魔)then goto  salebegin end		-- 魔小于100
	if(人物("血") < 人补血)then goto  salebegin end
	if(宠物("血") < 宠补血)then goto  salebegin end
	if(宠物("魔") < 宠补魔)then goto  salebegin end
	if(取物品数量("封印卡（野兽系)") < 1)then goto  start end
	if(耐久(7) < 自动换水火的水晶耐久值)then goto checkcrystalnow end
	
	goto scriptstart 		-- 继续自动遇敌
::salebegin::
	停止遇敌()				-- 结束战斗
	
	等待(3000)
	goto start 
::checkcrystalnow::
	if(取物品数量("水火的水晶（5：5）") < 1)then goto  start end
	停止遇敌()						-- 结束战斗
	
	等待(1000)
	扔("7")
	等待(1000)
	装备物品("水火的水晶（5：5）", 7)
	等待(1000)
	goto scriptstart 
	
::maika::
	回城()
	等待(3000)
	
	等待到指定地图("艾尔莎岛", 1)
	
	
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("里谢里雅堡", 1)
	
	自动寻路(24,82)
	自动寻路(24,53)
	自动寻路(17,53)
	等待到指定地图("法兰城", 1)
	等待(500)
	自动寻路(92,88)
	自动寻路(92,78)
	自动寻路(94,78)
	
	等待到指定地图("达美姊妹的店", 1)
	
	自动寻路(10,13)
	自动寻路(13,16)
	自动寻路(17,16)
	自动寻路(17,18)
	
	等待(1000)
	
	转向(2, "")             
	等待服务器返回()
	
	对话选择("0", "1", "")
	等待服务器返回()
	买(2,40)        
	等待服务器返回()	
	叠("封印卡（野兽系）",20)	
	叠("封印卡（野兽系）",20)		
	
	if(取物品数量("水火的水晶（5：5）") < 1)then goto  maishuijing end
	
	goto start 
::maishuijing::
	
	转向(2, "")             
	等待服务器返回()
	
	对话选择("0", "1", "")
	等待服务器返回()
	买(10,2)    
       
	等待服务器返回()
	
	goto start 	

