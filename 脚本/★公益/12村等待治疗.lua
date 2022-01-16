配合偷改狗材料脚本，给偷狗人治疗


function main()	
	补魔值 = 300--用户输入框("多少魔以下补魔", "50")
	补血值=1500--用户输入框("多少血以下补血", "430")
	等待(500)      	
	goto begin
::begin::
	当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto aiersa  
	elseif (当前地图名=="伊尔村" )then	
		goto quyiyuan  			
	elseif(当前地图名=="里谢里雅堡") then
		goto start
	elseif(当前地图名=="医院") then
		goto yiyuan
	end
	回城()
	goto begin
::aiersa::
	等待到指定地图("艾尔莎岛", 1)
	
	转向(1)
	等待服务器返回()	
	对话选择(4, 0)
	等待到指定地图("里谢里雅堡", 1)
	等待(500)
	
	移动(30,90)
	移动(34,90)
	移动(34,89)
	renew(1)	
	
	goto start
::start::	
	移动(41, 50)	
	等待到指定地图("里谢里雅堡 1楼", 1)	
    移动(45, 20)	
	等待到指定地图("启程之间", 1)
	移动(44, 33)	
	转向(0)
	等待服务器返回()	
	对话选择(4, 0)
	等待到指定地图("伊尔村的传送点", 1)	
	等待(1000)    
	移动(12, 17)
	等待到指定地图("村长的家", 1)
	移动(6, 13)	
	等待到指定地图("伊尔村", 1)		
::quyiyuan::
	移动(52,39)	
	goto yiyuan
::pandun::
	if (人物("血") < 补血值 )then		
		goto yiyuan
	elseif (人物("魔") < 补魔值 )then	
		goto yiyuan		
	end	
	等待(2000)
	goto pandun
	
::yiyuan::
	等待到指定地图("医院", 1)		
	移动(10,15)
	renew(0)			-- 转向北边恢复人宠血魔	
	移动(11,15)
	goto pandun
end
main()