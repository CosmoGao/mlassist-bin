全程自动跑猫，要求定居新城，带高血防护卫宠护卫自己，全程设置逃跑 脚本发现BUG联系Q::274100927-----------星落

	
设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 开启高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 开启遇敌全跑 
设置("自动加血", 0)			-- 关闭自动加血，脚本对话加血 
走路加速值=120	
走路还原值=100	
doctorName="星落护士"

common=require("common")
local 身上最少金币=5000			--少于去取
local 身上最多金币=1000000			--大于去存
local 身上预置金币=200000			--取和拿后 身上保留金币
local tradeName=nil
local tradeBagSpace=nil
local tradePlayerLine=nil			--仓库人物当前线路
topicList={"王冠仓库信息"}
订阅消息(topicList)


function waitTopic()
	
::begin::
	等待空闲()
	tryNum=0
	if(取当前地图名() ~= "银行" or 取当前地图编号() ~= 1121)then		
		common.gotoFalanBankTalkNpc()
		银行("全取","王冠")
		tradeName=nil
		tradeBagSpace=nil
		tradePlayerLine=nil
	end
	设置("timer",0)
	topic,msg=等待订阅消息()
	日志(topic.." Msg:"..msg,1)
	if(topic == "王冠仓库信息")then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeBagSpace=recvTbl.bagcount
		tradePlayerLine=tonumber(recvTbl.line)	
	end	
	if(tradePlayerLine ~= nil and tradePlayerLine ~= 0 and tradePlayerLine ~= 人物("几线"))then
		切换登录信息("","",tradePlayerLine,"")
		登出服务器()
		等待(3000)			
		goto begin
	end
	
	if(tradeName ~= nil and tradeBagSpace ~= nil and tradePlayerLine==人物("几线"))then		
	
		local wgCount=取物品数量("王冠")
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
			allitems = 物品信息()
			tradeList="金币:2000;物品:"
			hasData=false
			selfTradeCount=0
			for i,v in pairs(allitems) do
				if(string.find(v.name,"王冠")~=nil  and v.pos>=8)then					
					if(hasData)then
						tradeList=tradeList.."|"..v.name.."|"..v.count.."|".."1"
					else
						tradeList=tradeList..v.name.."|"..v.count.."|".."1"			
					end
					selfTradeCount=selfTradeCount+1
					hasData=true
					if(selfTradeCount >= tradeBagSpace)then
						break
					end			
				end
			end				
			日志(tradeList)
			if(hasData)then
				交易(tradeName,tradeList,"",10000)
			end
			if(wgCount~=取物品数量("王冠") or hasData==false)then	--交易成功 重置交易信息
				--设置("timer",100)
				tradeName=nil
				tradeBagSpace=nil
				tradePlayerLine=nil				
				goto checkLine
			end
			tryNum=tryNum+1
		end
	end
	goto begin
::checkLine::
	--不用换线 仓库线刷即可
	-- if(人物("几线")~=刷改图线)then
		-- 切换登录信息("","",刷改图线,"")
		-- 登出服务器()
		-- 等待(3000)
		-- return
	-- end
end
function main()	
::kaishi::	
	等待空闲()
	if(取物品数量("王冠") > 0)then
		goto qucun
	end
	当前地图名=取当前地图名()	
	if(当前地图名=="雪拉威森塔９６层")then	
		goto T96
	elseif(当前地图名=="雪拉威森塔９７层")then		
		goto T97
	elseif(当前地图名=="雪拉威森塔９８层")then		
		goto T98
	elseif(当前地图名=="雪拉威森塔９９层")then		
		goto T99
	elseif(当前地图名=="雪拉威森塔最上层")then		
		goto T100
	elseif(当前地图名=="雪拉威森塔前庭")then		
		goto T101
	end
	common.checkGold(身上最少金币,身上最多金币,身上预置金币)
	common.healPlayer(doctorName)
	common.recallSoul()
	common.supplyCastle()
	if(人物("血") < 1000)then goto  lookbu end
	if(人物("魔") < 300)then goto  lookbu end
	--if(宠物("血") < 宠补血值)then goto  lookbu end
	--if(宠物("魔") < 宠补魔值)then goto  lookbu end
	if(取物品数量("塞特的护身符") > 0)then goto  saite end
	if(取物品数量("梅雅的护身符") > 0)then goto  meiya end
	if(取物品数量("提斯的护身符") > 0)then goto  tisi end
	if(取物品数量("伍斯的护身符") > 0)then goto  wusi end
	if(取物品数量("尼斯的护身符") > 0)then goto  nisi end
	if(当前地图名=="艾尔莎岛")then		
		goto 雪拉威森塔
	end
	回城()
	goto kaishi
::雪拉威森塔::	
	移动(165, 153)	
	转向(4)
	等待服务器返回()	
	对话选择(32,0)
	等待服务器返回()
	对话选择(4, 0)	
	等待到指定地图("利夏岛")		
	移动(90,99,"国民会馆")
	移动(108, 54)	
	回复(0)		
	移动(108, 39)	
	等待到指定地图("雪拉威森塔１层")		
	移动(75, 50)	
	等待到指定地图("雪拉威森塔５０层")		
	移动(16, 44)	
	等待到指定地图("雪拉威森塔９５层")	
	移动(26, 104)
	移动(27, 104)		
	转向(2)
	等待服务器返回()	
	对话选择("32", "", "")	
	对话选择("4", "", "")	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９６层")		
	goto lookbu
	
::saite::	
	使用物品("塞特的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９５层")		
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９６层")			
::T96::
	移动(86, 120)
	移动(87, 119)			
	转向(1, "")
	等待服务器返回()	
	对话选择("32", "", "")	
	等待服务器返回()	
	对话选择("32", "", "")	
	等待服务器返回()	
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９７层")		
	goto lookbu
::meiya::	
	使用物品("梅雅的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９６层")	
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９７层")	
::T97::
	移动(117, 126)	
	转向(0, "")
	等待服务器返回()	
	对话选择("32", "", "")	
	对话选择("32", "", "")	
	对话选择("32", "", "")	
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９８层")		
	goto lookbu
::tisi::	
	使用物品("提斯的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９７层")	
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９８层")		
::T98::	
	移动(120, 121)		
	转向(0, "")
	等待服务器返回()	
	对话选择("32", "", "")	
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９９层")	
	goto lookbu	
::wusi::	
	使用物品("伍斯的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９８层")		
	转向(0)
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９９层")		
::T99::
	移动(101, 55)		
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔最上层")		
	goto lookbu
::nisi::	
	使用物品("尼斯的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９９层")		
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔最上层")		
::T100::	
	移动(103, 134)	
	等待到指定地图("雪拉威森塔前庭")		
::T101::	
	移动(103, 19)		
::jiance::
	goto wangguan
	if(取物品数量("王冠") < 1)then goto  wangguan end	
	if(取物品数量("公主头冠") < 1)then goto  gongzhuguan end
::xiaomaomao::	
	转向(1, "")
	等待服务器返回()	
	对话选择("4", "", "")
	等待服务器返回()	
	对话选择("1", "", "")	
	goto dengdai 
::wangguan::
	等待(300)	
	喊话("男",2,3,4)
	等待服务器返回()
	对话选择(1,0)
	goto dengdai 
::gongzhuguan::
	等待(300)	
	转向(1)
	等待服务器返回()	
	对话选择(32,0)
	等待服务器返回()	
	对话选择(1,0)
	goto dengdai 
::dengdai::
	等待到指定地图("国民会馆")	
	等待(200)
	if(取物品数量("王冠") > 0)then goto  qucun end	
	if(取物品数量("小猫帽") > 0)then goto  qucun end	
	goto kaishi 
::qucun::
   	回城()
   	等待到指定地图("艾尔莎岛")   
   	移动(146, 105)
   	移动(157, 94)
   	转向(1, "")   	
   	等待到指定地图("艾夏岛")      
   	移动(114, 105)
   	移动(114, 104)   	
   	等待到指定地图("银行")	  
   	移动(49, 25)   	
::cun::   
   	转向(2)
   	等待服务器返回()
   	银行("全存","王冠")   	
   	银行("全存","小猫帽")   
	if(取物品数量("王冠") > 0)then
		waitTopic()
	end
   	goto kaishi 
::lookbu::
	local needSupply = false
	if(人物("血") < 人物("最大血") or 人物("魔") < 人物("最大魔")) then
		needSupply=true
	end
	if(宠物("血") < 宠物("最大血") or 宠物("魔") < 宠物("最大魔")) then
		needSupply=true
	end
	if(needSupply == false)then
		goto kaishi
	end
	回城()
	等待到指定地图("艾尔莎岛")	
	转向(1)
	等待服务器返回()
	对话选择(4,0)	
	等待到指定地图("里谢里雅堡")		
	移动(34, 89)	
	回复(1)	
	common.healPlayer(doctorName)
	common.recallSoul()
	等待(2000)
	goto kaishi 
end
main()
