不设置重新启动脚本.起点任意  
       
设置("timer", 100)
common=require("common")

设置("自动扔",1,"卡片？")
设置("自动扔",1,"14942")
设置("自动扔",1,"14848")
设置("自动扔",1,"魔石|地的水晶碎片|水的水晶碎片|火的水晶碎片|风的水晶碎片")

人补魔=用户输入框("人多少魔以下补魔", "50")
人补血=用户输入框( "人多少血以下补血", "300")
宠补魔=用户输入框( "宠多少魔以下补魔", "100")
宠补血=用户输入框( "宠多少血以下补血", "200")	

sealCardName="封印卡（人形系）"
sealCardCount=200
crystalName="水火的水晶（5：5）"
身上最少金币=5000			--少于去取
身上最多金币=1000000			--大于去存
身上预置金币=200000			--取和拿后 身上保留金币
::begin::
	停止遇敌()				-- 结束战斗	
	等待空闲()
	common.checkGold(身上最少金币,身上最多金币,身上预置金币)
	if (人物("宠物数量") >= 5 )then	
		日志("宠物满了，去银行存货！")
		common.depositNoBattlePetToBank()
		if (人物("宠物数量") >= 5 )then	
			日志("银行宠物也满啦！请先清理，再重新执行脚本！")
			common.gotoFalanBankTalkNpc()			
			goto begin
		end
	end
	当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto start  	  
	elseif( 当前地图名== "芙蕾雅")then
		goto yudi		
	end
	等待(1000)
	回城()
	goto begin
::start:: 
	移动(140,105)    
	转向(1)		-- 转向北
	等待服务器返回()	
	对话选择(4, 0)
	等待到指定地图("里谢里雅堡", 1)		
	common.checkHealth()	
	common.supplyCastle()   
	if(取物品叠加数量(sealCardName) < sealCardCount)then 
		goto maika
	end
	common.gotoFaLanCity("e2")
	移动(230,84)	
	转向(0)
	等待(2000)	--等系统刷新
	设置("人物称号",人物("称号"))
	移动(281,88,"芙蕾雅")
::yudi::	
	移动(483, 195)
	开始遇敌()
	goto startaction 
  
::startaction::  
	if (人物("血") < 人补血 )then		
		goto stopaction
	elseif (人物("魔") < 人补魔 )then	
		goto stopaction		
	elseif (宠物("血") < 宠补血 )then	
		goto stopaction		
	elseif (宠物("魔") < 宠补魔 )then	
		goto stopaction		
	elseif (取当前地图名() ~= "芙蕾雅" )then	
		goto stopaction			
	elseif(取物品数量(sealCardName) < 1)then 
		日志("封印卡没了，回城！")
		goto stopaction
	end			
	等待(3000)
	goto startaction 
::stopaction::  
	停止遇敌()
	等待空闲()
	扔("卡片？")  	
	回城()
	goto begin 

::maika::
	移动(17,53)
	等待到指定地图("法兰城")
	移动(94,78)	
	等待到指定地图("达美姊妹的店")	
::shop::
	移动(17,18)	
	等待(1000)
	if(耐久(7) < 100)then 		
		转向(2)
		等待服务器返回()
		对话选择(0,0) --第二个参数0 0买 1卖 2不用了
		local dlg = 等待服务器返回()
		local buyData = 解析购买列表(dlg.message)
		local itemList = buyData.items
		local dstItem = nil
		for i,item in ipairs(itemList)do
			if( item.name == crystalName) then
				dstItem={index=i-1,count=1}		
				break
			end
		end
		if (dstItem ~= nil)then
			买(dstItem.index,dstItem.count)
			对话选择(-1,0)
			等待(1000)		
			扔(7)
			等待(1000)
			装备物品(crystalName, 7)
			等待(1000)
		else
			日志("购买水晶失败！")		
		end
	end
	if(取物品叠加数量(sealCardName) < sealCardCount)then
		转向(2)
		等待服务器返回()
		对话选择(0,0) --第二个参数0 0买 1卖 2不用了
		local dlg = 等待服务器返回()
		if(dlg == nil)then goto shop end
		local buyData = 解析购买列表(dlg.message)
		local itemList = buyData.items
		local dstItem = nil
		for i,item in ipairs(itemList)do
			if( item.name == sealCardName) then
				dstItem={index=i-1,count=sealCardCount-取物品叠加数量(sealCardName) }	
				break
			end
		end
		if (dstItem ~= nil)then
			买(dstItem.index,dstItem.count)
			等待(1000)		
			对话选择(-1,0)
		else
			日志("购买封印卡失败！")		
		end
	end	
	叠(sealCardName,20)		
	goto begin