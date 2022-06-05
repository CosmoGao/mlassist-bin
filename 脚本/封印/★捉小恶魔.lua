★捉水龙脚本，起点艾尔莎岛登入点，请设置好自动战斗,战斗1中设置好遇一级宠时的战斗方法 ::战斗2设置好宠物满下线保护.脚本发现BUG联系Q::274100927-----------星落


common=require("common")				
				-- 自动遇敌
设置("自动战斗",1)
设置("高速战斗", 1)
设置("高速延时",4)

		--原地遇敌      
local 人补魔=tonumber(用户输入框( "人多少魔以下补魔", "50"))
local 人补血=tonumber(用户输入框( "人多少血以下补血", "300"))
local 宠补魔=tonumber(用户输入框( "宠多少魔以下补魔", "50"))
local 宠补血=tonumber(用户输入框( "宠多少血以下补血", "200"))
local 自动换风地的水晶耐久值=tonumber(用户输入框( "多少耐久以下自动换风地的水晶,不换可不填", "30")  )  
local 封印卡名称="封印卡（飞行系）"
local 封印卡数量=40    

设置("自动叠",1,封印卡名称.."&20")

local topicList={"小恶魔仓库信息"}

订阅消息(topicList)
local 抓宠线=人物("几线")
local tradeName=nil				--仓库人物名称
local tradeBagSpace=nil			--仓库人物宠物空格
local tradePlayerLine=nil			--仓库人物当前线路


function waitTopic()
	if(抓宠线==nil)then 抓宠线=人物("几线") end
::begin::
	等待空闲()
	tryNum=0
	if(取当前地图名()~= "银行")then
		common.gotoFalanBankTalkNpc()
		tradeName=nil
		tradeBagSpace=nil
		tradePlayerLine=nil
	end
	设置("timer",0)
	topic,msg=等待订阅消息()
	日志(topic.." Msg:"..msg,1)
	if(topic == "小恶魔仓库信息")then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeBagSpace=recvTbl.pets
		tradePlayerLine=recvTbl.line
	end				
	if(tradePlayerLine ~= nil and tradePlayerLine ~= 0 and tradePlayerLine ~= 人物("几线"))then
		切换登录信息("","",tradePlayerLine,"")
		登出服务器()
		等待(3000)			
		goto begin
	end	
	if(tradeName ~= nil and tradeBagSpace ~= nil and tradePlayerLine==人物("几线"))then	
		while tryNum<3 do
			tradex=nil
			tradey=nil
			units = 取周围信息()
			if(units ~= nil)then
				for i,u in pairs(units) do
					if(u.unit_name==tradeName)then
						tradex=u.x
						tradey=u.y
						break
					end
				end
			else
				goto begin
			end
			if(tradex ~=nil and tradey ~= nil)then
				移动到目标附近(tradex,tradey)
			else
				goto begin
			end
			转向坐标(tradex,tradey)				
			pets = 全部宠物信息()
			tradeList="金币:2000;宠物:"
			hasData=false
			selfTradeCount=0
			for i,v in pairs(pets) do
				if(v.realname == "小恶魔" and v.level==1)then					
					if(selfTradeCount >= tradeBagSpace)then
						break
					end		
					selfTradeCount=selfTradeCount+1
					hasData=true				
				end
			end	
			tradeList = tradeList.."小恶魔|"..selfTradeCount			
			
			日志(tradeList)
			if(hasData)then
				交易(tradeName,tradeList,"",10000)
			else	
				设置("timer",100)
				--下次说不定是哪个仓库 设置为nil
				tradeName=nil
				tradeBagSpace=nil
				tradePlayerLine=nil	
				回城()
				goto checkLine
			end
			tryNum=tryNum+1
		end
	end
	goto begin
::checkLine::
	if(人物("几线")~=抓宠线)then
		切换登录信息("","",抓宠线,"")
		登出服务器()
		等待(3000)
		return
	end
end

function main()
::begin::	
	停止遇敌()				-- 结束战斗	
	等待空闲()
	if (人物("宠物数量") >= 5 )then	
		日志("宠物满了，去银行存货！")
		common.depositNoBattlePetToBank()
		if (人物("宠物数量") >= 5 )then	
			日志("银行宠物也满啦！请先清理，再重新执行脚本！")
			common.gotoFalanBankTalkNpc()
			tradeName=nil
			tradeBagSpace=nil
			waitTopic()
			goto begin
		end
	end
	if (取当前地图名()=="索奇亚" )then	
		goto dstpos	
	end	
	common.checkHealth()
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.toCastle()	
	goto liBao
::liBao::	
	移动(41, 53)
	if(取物品数量( 封印卡名称) <  1)then goto  maika end
	if(取物品数量( "风地的水晶（5：5）") <  1)then goto  maika end
	移动(41, 50)	
	等待到指定地图("里谢里雅堡 1楼")	
    移动(45, 20,"启程之间")	
	移动(8, 33)	
	转向(0)
	等待服务器返回()
	对话选择(4, 0)	
	等待到指定地图("奇利村的传送点")
	移动(7, 6,"3214")	
    移动(7, 1,"3212")
	移动(1, 8,"奇利村")	
::map3200::
	移动( 79, 76,"索奇亚")			
::dstpos::	
	移动(280, 400)
	开始遇敌()		-- 开始自动遇敌
	goto scriptstart 
::scriptstart::
	if(人物("魔") < 人补魔)then goto  huibu end		-- 魔小于100
	if(人物("血") < 人补血)then goto  huibu end
	if(宠物("血") < 宠补血)then goto  huibu end
	if(宠物("魔") < 宠补魔)then goto  huibu end
	if (人物("宠物数量") >= 5 )then	
		日志("宠物数量满了，回城存储！")
		停止遇敌()
		等待空闲()
		回城()
		goto begin	
	end
	if(取物品数量( 封印卡名称) <  1)then 
		回城()
		goto begin 
	end
	common.checkHealth()
	if(取当前地图名() ~= "索奇亚")then 	
		goto begin 
	end
	if(耐久(7) < 自动换风地的水晶耐久值) then goto  checkcrystalnow end
	等待(2000)		--不等待卡死了
	goto scriptstart 		-- 继续自动遇敌
::huibu::
	停止遇敌()				-- 结束战斗	
	等待空闲()
	移动(294,325,"奇利村")	
	移动(64,56,"医院")		
	移动(11,6)
	回复(0)			-- 转向东边恢复人宠血魔		
	移动(3,10,"奇利村")
	goto map3200

	
::salebegin::
	停止遇敌()				-- 结束战斗	
	goto begin 
::checkcrystalnow::
	if(取物品数量( "风地的水晶（5：5）") <  1)then 
		停止遇敌()
		等待空闲()
		回城()
		goto  begin 
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
	if(取物品数量( 封印卡名称) <  1)then goto  buy end
	if(取物品数量( "风地的水晶（5：5）") <  1)then goto  maishuijing end
	goto begin 
::buy::	
	等待服务器返回()
	对话选择(0,0) --第二个参数0 0买 1卖 2不用了
	dlg = 等待服务器返回()
	buyData = 解析购买列表(dlg.message)
	itemList = buyData.items
	dstItem = nil
	for i,item in ipairs(itemList)do
		if( item.name == 封印卡名称) then
			dstItem={index=i-1,count=封印卡数量-取物品叠加数量(封印卡名称)}			
		end
	end
	if (dstItem ~= nil)then
		买(dstItem.index,dstItem.count)
		等待(1000)		
	else
		日志("购买封印卡失败！")
	end
	对话选择(0,2) 
	对话选择(0,-1) 	
	
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
end
main()