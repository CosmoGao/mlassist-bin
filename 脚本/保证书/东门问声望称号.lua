

common=require("common")
function 称号提交获取()
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()	
	if (当前地图名=="艾尔莎岛" )then	
		goto erDao	
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao	
	elseif (当前地图名=="法兰城" )then	
		goto faLanBank		
	end
	回城()
	等待(1000)
	goto begin
::erDao::	
	移动(140,105)
	等待(500)	
	转向(1)
	等待服务器返回()
	对话选择(4,0)
	等待(2000)		
	等待空闲()
	if (取当前地图名()=="艾尔莎岛" )then	
		goto begin
	end
::liBao::
	移动(41,98)	
	等待到指定地图("法兰城")	
	移动(162, 130)	
	goto faLan	
::faLan::
	x,y=取当前坐标()	
	if (x==72 and y==123 )then	-- 西2登录点
		goto  w2
	elseif (x==233 and y==78 )then	-- 东2登录点
		goto  e2
	elseif (x==162 and y==130 )then	-- 南2登录点
		goto  s2
	elseif (x==63 and y==79 )then	-- 西1登录点
		goto  w1
	elseif (x==242 and y==100 )then	-- 东1登录点
		goto  e1
	elseif (x==141 and y==148 )then	-- 南1登录点
		goto  s1
	end
	goto begin
::faLanBank::		
	等待到指定地图("法兰城")	
	移动(230,84)
	title = 人物("称号")
	转向(0)
	转向(0)
	等待(2000)	--等系统刷新
	当前时间=os.date("%Y-%m-%d %H:%M:%S")
	刷之前称号 = 人物("称号")
	if(title == 刷之前称号)then
		日志(当前时间.." 未获得新称号，当前人物称号为【"..刷之前称号.."】",1)
	else
		日志(当前时间.." 获得新称号【"..刷之前称号.."】",1)
	end
	设置("人物称号",刷之前称号)
	移动(235,107)
	转向(4)
	dlg = 等待服务器返回()
	if(dlg ~= nil)then
		range = common.askNowPrestige(dlg.message)
	else
		range=-1
		日志("称号对话框返回nil")
	end
	
	日志(当前时间.." 当前人物称号进度为【"..range.."/4】",1)
		
    goto goEnd 
::w2::	-- 西2登录点
	转向(2)			-- 转向东	
	等待到指定地图("法兰城",233,78)		
	goto faLanBank

::e2::	-- 东2登录点	
	goto faLanBank

::s2::	-- 南2登录点	
	转向(2)	
	goto faLan	

::w1::	-- 西1登录点
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 242, 100)		
	goto faLanBank


::e1::	-- 东1登录点
	goto faLanBank

::s1::	-- 南1登录点		
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 63, 79)		
	goto faLan
::goEnd::
	return 0
	
end
称号提交获取()