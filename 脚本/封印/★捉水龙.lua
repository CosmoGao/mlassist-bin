★捉水龙脚本，起点艾尔莎岛登入点，请设置好自动战斗,战斗1中设置好遇一级宠时的战斗方法 ::战斗2设置好宠物满下线保护.脚本发现BUG联系Q::274100927-----------星落


common=require("common")				
				-- 自动遇敌
设置("自动战斗",1)
设置("高速战斗", 1)
设置("高速延时",4)
		--原地遇敌      
人补魔=tonumber(用户输入框( "人多少魔以下补魔", "50"))
人补血=tonumber(用户输入框( "人多少血以下补血", "300"))
宠补魔=tonumber(用户输入框( "宠多少魔以下补魔", "50"))
宠补血=tonumber(用户输入框( "宠多少血以下补血", "200"))
自动换风地的水晶耐久值=tonumber(用户输入框( "多少耐久以下自动换风地的水晶,不换可不填", "30")  )      
::start::	
	等待空闲()
	if (当前地图名=="索奇亚海底洞窟 地下2楼" )then	
		goto dstpos	
	end	
	common.checkHealth()
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.toCastle()
	等待(1000)
	goto liBao
::liBao::	
	等待到指定地图("里谢里雅堡")	
	移动(34,89)
	回复(1)			-- 转向北边恢复人宠血魔	
	移动(41, 53)
	if(取物品数量( "封印卡（龙系）") <  1)then goto  maika end
	if(取物品数量( "风地的水晶（5：5）") <  1)then goto  maika end
	移动(41, 50)	
	等待到指定地图("里谢里雅堡 1楼")	
    移动(45, 20,"启程之间")	
	移动(8, 23)	
	转向(0, "")
	等待服务器返回()
	对话选择(4, 0)	
	等待到指定地图("维诺亚村的传送点")	
	移动( 5, 1,"村长家的小房间")		
	移动( 0, 5,"村长的家")		
	移动( 10, 16,"维诺亚村")	
::weicun::
	移动( 67, 46,"芙蕾雅")		
	移动( 343, 497,"索奇亚海底洞窟 地下1楼")		
	移动( 18, 34,"索奇亚海底洞窟 地下2楼")
::dstpos::	
	移动(49, 8)
	开始遇敌()		-- 开始自动遇敌
	goto scriptstart 
::scriptstart::
	if(人物("魔") < 人补魔)then goto  huibu end		-- 魔小于100
	if(人物("血") < 人补血)then goto  huibu end
	if(宠物("血") < 宠补血)then goto  huibu end
	if(宠物("魔") < 宠补魔)then goto  huibu end
	if(取物品数量( "封印卡（龙系）") <  1)then 
		回城()
		goto start 
	end
	common.checkHealth()
	if(取当前地图名() ~= "索奇亚海底洞窟 地下2楼")then 	
		goto start 
	end
	if(耐久(7) < 自动换风地的水晶耐久值) then goto  checkcrystalnow end
	等待(2000)		--不等待卡死了
	goto scriptstart 		-- 继续自动遇敌
::huibu::
	停止遇敌()				-- 结束战斗	
	移动(49,46,"索奇亚海底洞窟 地下1楼")		
	移动(10,5,"芙蕾雅")		
	移动(330,481,"维诺亚村")	
	移动(61,53,"医院")	
	移动(11,9)
	移动(11,5)
	回复(2)			-- 转向东边恢复人宠血魔		
	移动(2,9,"维诺亚村")
	goto weicun

	
::salebegin::
	停止遇敌()				-- 结束战斗	
	goto start 
::checkcrystalnow::
	if(取物品数量( "风地的水晶（5：5）") <  1)then 
		停止遇敌()
		等待空闲()
		回城()
		goto  start 
	end
	停止遇敌()-- 结束战斗	
	等待空闲()
	等待(1000)
	扔(7)
	等待(1000)
	装备物品("风地的水晶（5：5）", 7)
	等待(1000)
	goto scriptstart 
	

::maika::
	移动(17,53,"法兰城")	
	移动(94,78,"达美姊妹的店")		
	移动(17,18)	
	等待(1000)	
	转向(2)
::maiJudge::
	if(取物品数量( "封印卡（龙系）") <  1)then goto  buy end
	if(取物品数量( "风地的水晶（5：5）") <  1)then goto  maishuijing end
	goto start 
::buy::	
	等待服务器返回()
	对话选择(0,0) --第二个参数0 0买 1卖 2不用了
	dlg = 等待服务器返回()
	buyData = 解析购买列表(dlg.message)
	itemList = buyData.items
	dstItem = nil
	for i,item in ipairs(itemList)do
		if( item.name == "封印卡（龙系）") then
			dstItem={index=i-1,count=60}			
		end
	end
	if (dstItem ~= nil)then
		买(dstItem.index,dstItem.count)
		等待(1000)		
	else
		日志("购买封印卡失败！")
	end
	对话选择(0,2) 
	
	
	叠("封印卡（龙系）",20)	
	if(取物品数量( "风地的水晶（5：5）") <  1)then goto  maishuijing end
	goto maiJudge 
::maishuijing::	
	转向(2)             
	等待服务器返回()
	对话选择(0,0) --第二个参数0 0买 1卖 2不用了
	dlg = 等待服务器返回()
	buyData = 解析购买列表(dlg.message)
	itemList = buyData.items
	dstItem = nil
	for i,item in ipairs(itemList)do
		if( item.name == "风地的水晶（5：5）") then
			dstItem={index=i-1,count=1}			
		end
	end
	if (dstItem ~= nil)then
		买(dstItem.index,dstItem.count)
		等待(1000)		
	else
		日志("购买水晶失败！")
	end	
	goto maiJudge 
