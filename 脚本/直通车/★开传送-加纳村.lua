★起点艾尔莎岛登入点，奇力村传送开启脚本。


function main()
::begin::
	当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto aiersa  
	elseif (当前地图名=="里谢里雅堡" )then	
		goto libao  	
	elseif(当前地图名=="维诺亚村的传送点") then
		goto weiCun		
	elseif(当前地图名=="启程之间") then
		goto warproom		
	elseif(当前地图名=="奇利村的传送点") then
		goto qccsd		
	end	
	回城()
	等待(1000)
	goto begin	
::warproom::			--去圣拉鲁卡村 如果没开传送，则回城去开圣村
	自动寻路(8, 23)	
	离开队伍()
	转向(0)
	dlg=等待服务器返回()
	if(dlg.message~=nil and (string.find(dlg.message,"此传送点的资格")~=nil or string.find(dlg.message,"很抱歉")~=nil or string.find(dlg.message,"不能使用这个传送石")~=nil))then
		回城()
		执行脚本("./脚本/直通车/★开传送-维诺亚村.lua")
		goto weiCun
	end		
	对话选是(0)	
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
	自动寻路(41,50,"里谢里雅堡 1楼")	
	自动寻路(45,20,"启程之间")	
	goto begin
::weiCun::
	等待到指定地图("维诺亚村的传送点")	
	自动寻路(5, 5)	
	转向(0)
	等待(1000)
	自动寻路(5, 1,"村长家的小房间")	
    自动寻路(0, 5,"村长的家")	
    自动寻路(9, 16,"维诺亚村")
	自动寻路(67, 46,"芙蕾雅")
	自动寻路(343, 497,"索奇亚海底洞窟 地下1楼")
	自动寻路(18, 34,"索奇亚海底洞窟 地下2楼")	
    自动寻路(27, 29,"索奇亚海底洞窟 地下1楼")
	自动寻路(7, 37,"索奇亚海底洞窟 地下1楼")		
	转向(2)
	等待服务器返回()
	对话选择(1,0)
	等待服务器返回()
	对话选择(4, 0)	
	等待到指定地图("索奇亚")
	自动寻路(274, 294,"奇利村")
	自动寻路(50, 63,"村长的家")
	自动寻路(10, 15,"村长的家")
	自动寻路(5, 3,"奇利村的传送点")	
::qiliCun::
	自动寻路(13, 9)	
	转向(0)
	等待(1000)
::qccsd::
	等待到指定地图("奇利村的传送点")
	自动寻路(13, 9)	
	转向(0)
	等待(1000)
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
end
main()