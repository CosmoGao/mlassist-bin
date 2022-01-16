法兰银行售卖王冠

王冠价格=50000

common=require("common")


function main()
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	if (当前地图名 =="艾尔莎岛" )then goto aiersa
	elseif(当前地图名 ==  "里谢里雅堡")then goto LiBao 		
	elseif(当前地图名 ==  "法兰城")then goto FaLan 			
	end	
	回城()
	等待(1000)
	goto begin
::aiersa::
	等待到指定地图("艾尔莎岛")
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
::LiBao::
	等待到指定地图("里谢里雅堡")	
	移动(34,89)
	回复(1)			-- 转向北边恢复人宠血魔
    common.gotoFaLanCity("e2")		
	等待到指定地图("法兰城")	
	移动(238,111,"银行")	
	移动(11,8)	
	goto goEnd
::FaLan::
	common.gotoFaLanCity("e2")		
	等待到指定地图("法兰城")	
	移动(238,111,"银行")	
	移动(11,8)	
	移动(11,8)
	转向(2)
	等待服务器返回()	
::goEnd::
	return
end
main()