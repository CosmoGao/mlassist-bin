★捉白狗脚本，起点艾尔莎岛登入点，请设置好自动战斗,战斗1中设置好遇一级宠时的战斗方法 战斗2设置好宠物满下线保护，谢谢支持魔力辅助程序.脚本发现BUG联系Q:274100927-----------星落


common=require("common")
local 人补魔=用户输入框("人多少魔以下补魔", "50")
local 人补血=用户输入框( "人多少血以下补血", "300")
local 宠补魔=用户输入框( "宠多少魔以下补魔", "50")
local 宠补血=用户输入框( "宠多少血以下补血", "200")	
设置("遇敌类型",1)
设置("遇敌速度",100)	--毫秒

function main()
	local tradeArgs={topic="地狱妖犬仓库信息",petName="地狱妖犬"}
	local mapName=""
::begin::
	停止遇敌()				-- 结束战斗	
	等待空闲()
	if (人物("宠物数量") >= 5 )then	
		日志("宠物满了，去银行存货！")
		common.depositNoBattlePetToBank()
		if (人物("宠物数量") >= 5 )then	
			日志("银行宠物也满啦！去交易给仓库！")
			common.gotoBankStorePetsAction(tradeArgs)
			goto begin
		end
	end	
	mapName = 取当前地图名()
	if (mapName=="艾尔莎岛" )then	
		goto start  	  
	elseif (mapName=="杰诺瓦镇的传送点" )then	
		goto jnwcf  
	elseif( mapName== "莎莲娜")then
		goto shaLianNa
	end
	等待(1000)
	回城()
	goto begin
::start::		
	common.checkHealth()
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.toCastle()	
    移动(41, 53)
	if(取物品叠加数量("封印卡（野兽系)") < 40)then 
		goto maika	
	end
	移动(41, 50)	
	等待到指定地图("里谢里雅堡 1楼", 1)	
	移动(45, 20)	
	等待到指定地图("启程之间", 1)
	移动(15, 4)    		
	转向(2)
	等待服务器返回()	
	对话选择(4, 0)
	goto jnwcf
::mfgcs2::        	
	转向(2)
	等待服务器返回()			
	对话选择(4, 0)
	等待服务器返回()	
	对话选择(1, 0)        
::jnwcf::
	等待到指定地图("杰诺瓦镇的传送点", 1)	 
	移动(14, 6)	
	等待到指定地图("村长的家", 1)	 
	移动(1, 9)	
	等待到指定地图("杰诺瓦镇", 1)
	移动(24, 39)
	
::shaLianNa::
	等待到指定地图("莎莲娜", 1) 
	移动(121, 315)
	开始遇敌()		-- 开始自动遇敌
	goto scriptstart
::scriptstart::
	if (人物("血") < 人补血 )then		
		goto salebegin
	elseif (人物("魔") < 人补魔 )then	
		goto salebegin		
	elseif (宠物("血") < 宠补血 )then	
		goto salebegin		
	elseif (宠物("魔") < 宠补魔 )then	
		goto salebegin		
	elseif(取物品叠加数量("封印卡（野兽系)") < 1)then 
		goto start	
	elseif (人物("宠物数量") >= 5 )then	
		日志("宠物数量满了，回城存储！")
		停止遇敌()
		等待空闲()
		回城()
		goto begin	
	end	
	common.checkHealth()
	if(取当前地图名() ~= "莎莲娜")then 	
		goto begin 
	end
	等待(2000)
	goto scriptstart		-- 继续自动遇敌
::salebegin::
	停止遇敌()				-- 结束战斗	
	回城()
	等待(3000)	
	goto start
::checkcrystalnow::
	if(取物品数量("水火的水晶（5：5）") < 1  )then
		goto start
	end
	停止遇敌()						-- 结束战斗	
	等待(1000)
	扔(7)
	等待(1000)
	装备物品("水火的水晶（5：5）", 7)
	等待(1000)
	goto scriptstart
	

::maika::
	移动(17,53)
	等待到指定地图("法兰城", 1)
	等待(500)
	移动(92,88)
	移动(92,78)
	移动(94,78)
	
	等待到指定地图("达美姊妹的店", 1)
	
	移动(10,13)
	移动(13,16)
	移动(17,16)
	移动(17,18)
	
	等待(1000)
		
	转向(2)             
	等待服务器返回()	
	对话选择(0, 0)		
	等待服务器返回()			
	买(2,40)          
	等待服务器返回()			
	转向(2, "")             
	等待服务器返回()			
	对话选择(0, 0)	
	等待服务器返回()			
	买(10,1)       
	等待服务器返回()		
	叠("封印卡（野兽系)",20)	
	叠("封印卡（野兽系)",20)	
	叠("封印卡（野兽系)",20)	
	goto begin

end
main()