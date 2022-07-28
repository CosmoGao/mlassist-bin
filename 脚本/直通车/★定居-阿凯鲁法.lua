启动地点，法兰，艾尔莎岛，阿凯鲁法传送石。

common=require("common")


是否定居=用户复选框("定居否？",0)
::begin::
	if(取当前地图名() == "阿凯鲁法村")then goto  star3 end
	if(取当前地图名() == "里谢里雅堡")then goto  goto2 end
	
	if(取当前地图名() ==  "艾尔莎岛")then goto   star1 end
	if(人物("坐标")  == "72,123")then	goto  w2 end	-- 西2登录点
	if(人物("坐标")  == "233,78")then	goto  e2 end	-- 东2登录点
	if(人物("坐标")  == "162,130")then	goto  s2 end	-- 南2登录点
	if(人物("坐标")  == "63,79")then	goto  w1 end	-- 西1登录点
	if(人物("坐标")  == "242,100")then	goto  e1 end	-- 东1登录点
	if(人物("坐标")  == "141,148")then	goto  s1 end	-- 南1登录点
	goto begin 

::hei::	
	使用物品("黑之记忆")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("黑之祭坛")	
	自动寻路(23, 18)	
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("召唤之间")		
	自动寻路( 3, 7,"里谢里雅堡")	
	goto libao 
::bai::	
	使用物品("白之记忆")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("白之祭坛")	
	自动寻路(22, 26)	
	转向(5, "")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("召唤之间")		
	自动寻路( 3, 7,"里谢里雅堡")

::libao::
	等待到指定地图("里谢里雅堡", 47, 85)	
	自动寻路(41,69)	
	goto goto2 


::w2::	-- 西2登录点
	转向(2, "")		-- 转向东	
	等待到指定地图("法兰城",233,78)	
	转向(0, "")		-- 转向北	
	等待到指定地图("市场一楼 - 宠物交易区", 46, 16)	
	转向(0, "")		-- 转向北	
	等待到指定地图("法兰城", 162, 130)	
	自动寻路(153,130)
	goto begin_1 			

::e2::	-- 东2登录点
	转向(0, "")		-- 转向北	
	等待到指定地图("市场一楼 - 宠物交易区", 46, 16)	
	转向(0, "")		-- 转向北	
	等待到指定地图("法兰城", 162, 130)	
	自动寻路(153,130)
	goto begin_1 			

::s2::	-- 南2登录点
	等待到指定地图("法兰城", 162, 130)	
	自动寻路(153,130)
	goto begin_1 			

::w1::	-- 西1登录点
	转向(0, "")		-- 转向北	
	等待到指定地图("法兰城", 242, 100)	
	转向(2, "")		-- 转向东	
	等待到指定地图("市场三楼 - 修理专区", 46, 16)	
	转向(0, "")		-- 转向北	
	等待到指定地图("法兰城", 141, 148)	
	自动寻路(153,148)
	自动寻路(153,130)
	goto begin_1 				

::e1::	-- 东1登录点
	转向(2, "")		-- 转向东	
	等待到指定地图("市场三楼 - 修理专区", 46, 16)	
	转向(0, "")		-- 转向北	
	等待到指定地图("法兰城", 141, 148)	
	自动寻路(153,148)
	自动寻路(153,130)
	goto begin_1 				

::s1::	-- 南1登录点
	等待到指定地图("法兰城", 141, 148)	
	自动寻路(153,148)
	自动寻路(153,130)
	goto begin_1 				

::begin_1::	
	自动寻路(153, 100,"里谢里雅堡")
	自动寻路(41, 69)
	goto goto2 


::star1::
	自动寻路(140,105)
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("里谢里雅堡")	
	转向(2, "")
	自动寻路(28, 82)	
::goto2::
	common.toTeleRoom("伊尔村")
	goto ylt 
	自动寻路(41,50,"里谢里雅堡 1楼")	
	自动寻路(45,20,"启程之间")	
	自动寻路(43, 33)
	if(取物品数量( "传送石优待卷") >  0)then goto  aaa end	
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")	
	goto ylt 
::aaa::	
	转向(1, "")
	等待服务器返回()	
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")
::ylt::
	等待到指定地图("伊尔村的传送点")
	自动寻路(12, 17,"村长的家")	
	自动寻路(6, 13,"伊尔村")	
	自动寻路(58, 71)	
	转向(2, "")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("伊尔")	
	自动寻路(30, 21,"港湾管理处")	
	自动寻路(23, 25)	
	转向(0, "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("往阿凯鲁法栈桥")		
	自动寻路(52, 51)
::TOA::
	
	转向(0, "")
	等待服务器返回()
	对话选择("4", "", "")	
	等待(15000)
	if(取当前地图名() == "艾欧奇亚号")then goto  aoqy end
	goto TOA 

::aoqy::
    等待(15000)
::aoqy1::
    if(string.find(聊天(50)," 本船已到达了阿凯鲁法港。")~=nil)then goto  xia end
	goto aoqy1 
::xia::
	自动寻路(70, 26)
	
	转向(2, "")
	等待服务器返回()
	对话选择("4", "", "")
	
	等待(15000)
	if(取当前地图名() == "往伊尔栈桥")then goto  toa end
	goto xia 




::toa::

	等待到指定地图("往伊尔栈桥", 50, 49)
	自动寻路(45,54)
	自动寻路(19, 54)
	转向(0, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("港湾管理处")		
	自动寻路(22, 31,"阿凯鲁法")		
	自动寻路(28,31)	
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("阿凯鲁法村")	
::star3::	
	自动寻路(119,116)	
	转向(0, "")
	等待服务器返回()
	
	对话选择("4", "", "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	
	对话选择("4", "", "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	自动寻路(121,155,"夏姆吉诊所")			
	自动寻路(10,17)
	自动寻路(10,11)	
	转向(1, "")
	等待服务器返回()
	
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	等待(1000)	
	
	自动寻路(16,23,"阿凯鲁法村")		
	自动寻路(139,136,"银行")
	自动寻路(31,17)
	
	转向(2, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	
	对话选择("1", "", "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	
	对话选择("4", "", "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	自动寻路(8,16,"阿凯鲁法村")	
	自动寻路(192,208,"冒险者旅馆 1楼")		
	自动寻路(21,6)	
	
	转向(0, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	自动寻路(16,23,"阿凯鲁法村")		
	自动寻路(196,162,"马查酒吧")	
	自动寻路(23,19)	
	转向(2, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	
	自动寻路(4,32,"阿凯鲁法村")		
	自动寻路(119,116)
	
	转向(0, "")
	等待服务器返回()
	
	对话选择("32	", "", "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	
	自动寻路(183,104,"阿凯鲁法城")	
	自动寻路(25,12)
	移动一格(0)	
	等待到指定地图("阿凯鲁法城")	
	移动一格(0)
	自动寻路(24,6,"谒见之间")
	自动寻路(25,21)
	
	转向(7, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	
	自动寻路(25,43,"阿凯鲁法城")	
	自动寻路(24,7)
	移动一格(4)	
	等待到指定地图("阿凯鲁法城")	
	移动一格(4)	
	自动寻路(25,44)
	自动寻路(25,45,"阿凯鲁法村")	
	自动寻路(98,164)	
	转向(1, "")
	等待服务器返回()
	if(是否定居)then
		对话选择("4", "", "")
	end
	
	