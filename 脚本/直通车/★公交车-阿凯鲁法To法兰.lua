启动地点阿凯鲁法传送石

设置("timer", 100)
是否定居=用户复选框("定居否？",1)
::begin::
	if(取当前地图名() == "艾欧奇亚号")then goto  aoqy end
	if(取当前地图名() == "阿凯鲁法村")then goto  aklfc end
	回城()
	等待到指定地图("阿凯鲁法村", 99, 165)	
::aklfc::
	自动寻路(57, 176)
	转向(6, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("阿凯鲁法")

	自动寻路(16, 15,"港湾管理处")
	自动寻路(15, 12)
	转向(2, "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("往伊尔栈桥")	
	自动寻路(51, 50)
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
	自动寻路(70, 26)
	转向(2, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待(5000)
	if(取当前地图名() == "往阿凯鲁法栈桥")then goto  ty end
	goto xia 

::ty::
	自动寻路(20, 54)
	转向(6, "")
	等待服务器返回()
	对话选择("4", "", "")

	等待到指定地图("港湾管理处")
	自动寻路(9, 22,"伊尔")
	自动寻路(24, 19)
	转向(0, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("伊尔村")
	自动寻路(47, 83,"村长的家")
	自动寻路(14, 17,"伊尔村的传送点")
	自动寻路(21, 11)
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
	自动寻路(25, 24,"里谢里雅堡 1楼")
	自动寻路(75, 40,"里谢里雅堡")	
	自动寻路(42,98,"法兰城")	
	自动寻路(162, 130)	
	转向(2)		
	等待到指定地图("法兰城")
	转向(2)	
	等待到指定地图("法兰城")	
	自动寻路(231,78)
	自动寻路(231,77)
	if(是否定居==0)then goto  quit1 end
	转向(0, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待(1000)
::quit1::
	等待(1000)