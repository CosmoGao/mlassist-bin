设置脚本简介("辅助登录界面填写账号信息，点击统计道具,自动运行此脚本！此脚本会辅助程序进行账号信息获取，包括身上物品、宠物、金币、银行物品、宠物、金币！")

设置("timer",100)

--切换游戏账号部分
function tableSize(data)
	count = 0  
	for k,v in pairs(data) do  
		count = count + 1  
	end  
	return count
end

function main()

::dengru::
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto star1
	elseif (当前地图名=="里谢里雅堡" )then	
		goto star2
	elseif (当前地图名=="法兰城" )then	
		goto faLan
	elseif (当前地图名=="召唤之间" )then	--登出 bank
		goto saveData
	end	
	回城()
	goto dengru
::star1::
	移动(157,94)	
	转向坐标(158,93)		
	等待到指定地图("艾夏岛")	
	移动(114,105)	
	移动(114,104)	
	等待到指定地图("银行")	
	移动(49,31)	
    goto saveData
::star2::		
	移动(41,98)	
	等待到指定地图("法兰城")	
	移动(162, 130)		
    goto faLan
::saveData::
	移动(49,31)	
	转向(0)
	等待交易("花々语","金币:500000","",10000)	
	if(人物("金币") < 500000)then
		移动(49,30)
		转向(2)
		银行("取钱",-1000000)
	end
	goto saveData
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
	goto dengru
::faLanBank::		
	等待到指定地图("法兰城")	
	移动(238,111)
	等待到指定地图("银行")	
	移动(11,9)
    goto saveData	


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
end

main()