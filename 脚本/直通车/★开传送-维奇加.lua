★起点艾尔莎岛登入点，亚、维、奇、加村传送开启脚本。不开传送的村子请设置为【已经】开启。



是否唯村=用户输入框("是否【已经】开启维诺亚村，否填10000，是填0，", "10000")
是否奇村=用户输入框("是否【已经】开启奇利村，否填10000，是填0，", "10000")
是否加村=用户输入框("是否【去】开启加纳村，是填10000，否填0，", "10000")
是否生产=用户输入框("是否生产", "1")

::begin::
	当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto aiersa  
	elseif (当前地图名=="里谢里雅堡" )then	
		goto libao  
	
	elseif(当前地图名=="维诺亚村的传送点") then
		goto weiCun
	elseif(当前地图名=="奇利村的传送点" )then			
		goto qccsd
	end	
	回城()
	等待(1000)
	goto begin	

::aiersa::
	等待到指定地图("艾尔莎岛")		
	自动寻路(140,105)
	转向(1)
	等待服务器返回()	
	对话选择(4, 0)	
::libao::
	等待到指定地图("里谢里雅堡")	
	自动寻路(34,89)
	回复(1)			
	if(是否唯村 == 10000) then
		goto quwnyc
	elseif(是否奇村 == 10000) then
		goto chuansong
	elseif(是否加村 == 10000) then
		goto chuansong
	end	
	goto begin

::quwnyc::
	自动寻路(41, 98)	
	等待到指定地图("法兰城")
	自动寻路(153, 241)	
	等待到指定地图("芙蕾雅")	
	自动寻路(474, 316)	
	自动寻路(473, 316)	
	对话选是(472,316)	
	等待到指定地图("维诺亚洞穴 地下1楼")	
    自动寻路(20, 59)	
	等待到指定地图("维诺亚洞穴 地下2楼")
	自动寻路(24, 81)	
	等待到指定地图("维诺亚洞穴 地下3楼")	
    自动寻路(26, 64)	
	等待到指定地图("芙蕾雅")	
	自动寻路(330, 480)	
	等待到指定地图("维诺亚村")		
	自动寻路(40, 36)	
	等待到指定地图("村长的家")
	自动寻路(18, 10)	
	等待到指定地图("村长家的小房间")
	自动寻路(8, 2)	
::weiCun::
	等待到指定地图("维诺亚村的传送点")	
	自动寻路(5, 5)	
	转向(0)
	等待(1000)
	if(是否生产 == 0)then
		if(取物品数量("欧兹尼克的戒指") <  1)then
			goto qilicun2
		end
	end	
	if(是否奇村 == 10000)then
		goto wnycf
	end    
::xhxs7::
    喊话("由于您不需开启奇利村传送，请重新执行脚本开启另外路线的传送!",2,3,5)
	等待(10000)
	goto xhxs7

::wnycf::
	等待(1000)
	自动寻路(5, 1)	
	等待到指定地图("村长家的小房间")	
    自动寻路(0, 5)	
	等待到指定地图("村长的家")	
    自动寻路(9, 16)	
	等待到指定地图("维诺亚村")
	自动寻路(67, 46)	
	等待到指定地图("芙蕾雅")
	自动寻路(343, 497)	
	等待到指定地图("索奇亚海底洞窟 地下1楼")
	自动寻路(18, 34)	
	等待到指定地图("索奇亚海底洞窟 地下2楼")	
    自动寻路(27, 29)	
	等待到指定地图("索奇亚海底洞窟 地下1楼")
	自动寻路(7, 37)	
	等待到指定地图("索奇亚海底洞窟 地下1楼")		
	转向(2)
	等待服务器返回()
	对话选择(1,0)
	等待服务器返回()
	对话选择(4, 0)	
	等待到指定地图("索奇亚")
	自动寻路(274, 294)
	等待到指定地图("奇利村")
	自动寻路(50, 63)	
	等待到指定地图("村长的家")
	自动寻路(10, 15)	
	等待到指定地图("村长的家")
	自动寻路(5, 3)
::qccsd::
	等待到指定地图("奇利村的传送点")
	自动寻路(13, 9)	
	转向(0)
	等待(1000)
	if(是否加村 == 10000)then
		goto qlcf
	end      
::xhxs9::
	喊话("由于您不需开启加纳村传送，脚本到此结束!",2,3,5)
	等待(10000)
	goto xhxs9

::qlcf::
	等待到指定地图("奇利村的传送点")
    自动寻路(7, 6)	
	等待到指定地图("村长的家")	
    自动寻路(7, 1)	
	等待到指定地图("村长的家")
	自动寻路(1, 8)	
	等待到指定地图("奇利村")	
    自动寻路(79, 76)	
	等待到指定地图("索奇亚")
	自动寻路(356, 334)	
	等待到指定地图("角笛大风穴")
	自动寻路(133, 26)	
	等待到指定地图("索奇亚")	
    自动寻路(529, 328)	
	等待(1000)
    喊话("要学乱射的速度!10秒后出发!",2,3,5)
	等待(10000)
	等待(1000)
	喊话("现在向加纳村出发!",2,3,5)
	等待(1000)
    自动寻路(704, 147)	
	等待到指定地图("加纳村")
	自动寻路(36, 40)	
	等待到指定地图("村长的家")
	自动寻路(17, 6)	
	等待到指定地图("加纳村的传送点")
	自动寻路(14, 7)	
	转向(2)
	等待(1000)        
::xhxs0::
	喊话("全部传送已开启，脚本到此结束!",2,3,5)
	等待(10000)
	goto xhxs0

::chuansong::
	自动寻路(41, 50,"里谢里雅堡 1楼")
	自动寻路(45, 20,"启程之间")		
	自动寻路(25, 29)
	if(是否奇村 == 10000) then
		goto qilicun
	elseif(是否加村 == 10000) then
		goto jianacun
	end	


::qilicun2::
	喊话("由于没有欧兹尼克的戒指，所以无法通过海底，脚本到此结束!",2,3,5)
	等待(1000)
	等待(10000)
	goto qilicun2
::qilicun::
	if(是否生产 == 0)then
		if(取物品数量("欧兹尼克的戒指") <  1)then
			goto qilicun2
		end
	end	
	自动寻路(8, 23)	
	转向(0)
	等待服务器返回()
	对话选择(4, 0)
	goto wnycf
::jianacun::
	自动寻路(8, 33)
	转向(0)
	等待服务器返回()
	对话选择(4, 0)
	goto qlcf