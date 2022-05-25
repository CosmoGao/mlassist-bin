★起点艾尔莎岛登入点，圣、杰村传送开启脚本。

       
::begin::
	等待空闲()
	当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto aiersa  
	elseif (当前地图名=="里谢里雅堡" )then	
		goto libao  	
	elseif(当前地图名=="圣拉鲁卡村的传送点") then
		goto sllkc		
	elseif(当前地图名=="杰诺瓦镇的传送点") then
		goto jlwc			
	elseif(当前地图名=="芙蕾雅") then
		goto fly		
	elseif(当前地图名=="启程之间") then
		goto warproom		
	end	
	回城()
	等待(1000)
	goto begin	
::warproom::			--去圣拉鲁卡村 如果没开传送，则回城去开圣村
	移动(43, 44)	
	离开队伍()
	转向坐标(44,43)
	dlg=等待服务器返回()
	if(dlg.message~=nil and (string.find(dlg.message,"此传送点的资格")~=nil or string.find(dlg.message,"很抱歉")~=nil or string.find(dlg.message,"不能使用这个传送石")~=nil))then
		回城()
		执行脚本("./脚本/直通车/★开传送-圣拉鲁卡村.lua")
		goto sllkc
	end		
	对话选是(44,43)	
	goto begin
::aiersa::
	等待到指定地图("艾尔莎岛")		
	移动(140,105)
	转向(1)
	等待服务器返回()	
	对话选择(4, 0)	
::libao::
	等待到指定地图("里谢里雅堡")	
	移动(34,89)
	回复(1)		
	移动(41,50,"里谢里雅堡 1楼")	
	移动(45,20,"启程之间")	
	goto begin
::sllkc::
	if(取当前地图名() ~= "圣拉鲁卡村的传送点")then goto begin end
	移动(15, 4)	
	转向(0)
	等待(1000)	
::sccf::	
	等待(1000)
	移动(7, 3)
	等待到指定地图("村长的家")
	移动(2, 9,"圣拉鲁卡村")
	移动(52, 54,"芙蕾雅")
::fly::
    移动(201, 166)	
	转向(0)
	等待服务器返回()		
	对话选择(1, 0)
	等待(2000)
::slnhddk::
	if(取当前地图名() ~= "莎莲娜海底洞窟 地下1楼")then
		goto begin
	end
    移动(20, 8,"莎莲娜海底洞窟 地下2楼")
	移动(11, 9,"莎莲娜海底洞窟 地下1楼")
	移动(24, 11,"莎莲娜")	
    移动(217, 456,"杰诺瓦镇")
    移动(58, 43,"村长的家")
	移动(13, 7)
::jlwc::
	等待到指定地图("杰诺瓦镇的传送点")
	移动(6, 7)	
	转向(2)
	等待(1000)
	