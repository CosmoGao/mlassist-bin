启动地点阿凯鲁法传送石

设置("timer", 100)
是否定居=用户复选框("定居否？",1)
::begin::
	if(取当前地图名() == "艾欧奇亚号")then goto  aoqy end
	if(取当前地图名() == "阿凯鲁法村")then goto  aklfc end
	回城()
	等待到指定地图("阿凯鲁法村", 99, 165)	
::aklfc::
	移动(57, 176)
	转向(6, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("阿凯鲁法")

	移动(16, 15,"港湾管理处")
	移动(15, 12)
	转向(2, "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("往伊尔栈桥")	
	移动(51, 50)
::shang::
	转向(2, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待(15000)
	if(取当前地图名() == "艾欧奇亚号")then goto  aoqy end
	goto shang 

::aoqy::
    等待(15000)
::aoqy1:: 
   if(string.find(聊天(50)," 本船已到达了伊尔港。")~=nil)then goto  xia	end
   等待(3000)
	goto aoqy1 
::xia::
	移动(70, 26)
	转向(2, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待(5000)
	if(取当前地图名() == "往阿凯鲁法栈桥")then goto  ty end
	goto xia 

::ty::
	移动(20, 54)
	转向(6, "")
	等待服务器返回()
	对话选择("4", "", "")

	等待到指定地图("港湾管理处")
	移动(9, 22,"伊尔")
	移动(24, 19)
	转向(0, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("伊尔村")
	移动(47, 83,"村长的家")
	移动(14, 17,"伊尔村的传送点")
	移动(21, 11)
	if(取物品数量( "传送石优待卷") >  0)then goto  aaa end			
	转向(0, "")
	等待服务器返回()
	对话选择("4", "", "")		
	goto ylt 
::aaa::
	转向(0, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")
::ylt::

	等待到指定地图("启程之间")
	移动(25, 24,"里谢里雅堡 1楼")
	移动(75, 40,"里谢里雅堡")	
	移动(28,88)
	等待服务器返回()			
	对话选择(32,0)
	等待服务器返回()			
	对话选择(32,0)
	等待服务器返回()		
	对话选择(32,0)
	等待服务器返回()			
	对话选择(32,0)
	等待服务器返回()	
	对话选择(4,0)
	等待到指定地图("？")	
	移动(19, 20)
	移动一格(4,1)	
	等待到指定地图("法兰城遗迹")		
	移动(98, 138,"盖雷布伦森林")
	移动(124, 168,"温迪尔平原")		
	移动(264, 108,"艾尔莎岛")	
::dingju::
	移动(141, 106)	
	if(是否定居 == 0)then		
		goto quit1
	end
	对话选是(142,105)
	移动(140, 105)	
::quit1::
	移动(157, 94)
   	转向(1, "")   	
   	等待到指定地图("艾夏岛")      
   	移动(114, 105)
   	移动(114, 104)   	
   	等待到指定地图("银行")	  
   	移动(49, 25)   	