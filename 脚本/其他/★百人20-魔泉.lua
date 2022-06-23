★定居艾岛；支持法兰，可设置自动更换装备；自己设置丢不要的卡，新城支持存宝石鼠铜奖，银行满以后丢弃★坐标180秒未变重启	★脚本联系：风星落-QQ:274100927


common=require("common")
补血值=1000--用户输入框("多少血以下补血", "430")
补魔值 = 300--用户输入框("多少魔以下补魔", "50")
宠补血值=1000--用户输入框( "宠多少血以下补血", "50")
宠补魔值=300--用户输入框( "宠多少魔以下补血", "100")

	
--设置自动更换装备水晶耐久值
自动换武器耐久值=0--用户输入框("多少耐久以下自动换武器,不换可不填", "10")
备用武器名的名称=""--用户输入框( "换备用武器的名称,如：国民弓、平民弓,不换可不填", "国民弓")
扔换下的旧武器=1--用户输入框( "是否扔换下的旧武器,扔填1,不扔填0", "1")
自动换衣服或铠甲耐久值=0
要换下衣服或铠甲的名称=""
备用衣服或铠甲的名称=""
扔换下的旧衣服或铠甲=11111
自动换帽子或头盔耐久值=0
备用帽子或头盔的名称=""
扔换下的旧帽子或头盔=11111
自动换鞋子或长靴耐久值=0
备用鞋子或长靴的名称=""
扔换下的旧鞋子或长靴=11111
--用户输入框("自动换衣服或铠甲耐久值", "多少耐久以下自动换衣服或铠甲,不换可不填", "10")
--用户输入框("要换下衣服或铠甲的名称", "要换下衣服或铠甲的名称,如：如：平民衣、平民铠,不换可不填", "平民衣")
--用户输入框("备用衣服或铠甲的名称", "换备用衣服或铠甲的名称,如：平民衣、平民铠,不换可不填", "平民衣")
--用户输入框("扔换下的旧衣服或铠甲", "是否扔换下的旧衣服或铠甲,扔填11111,不扔填0", "11111")

--用户输入框("自动换帽子或头盔耐久值", "多少耐久以下自动换帽子或头盔,不换可不填", "10")
--用户输入框("备用帽子或头盔的名称", "换备用帽子或头盔的名称,如：平民帽、平民盔,不换可不填", "平民帽")
--用户输入框("扔换下的旧帽子或头盔", "是否扔换下的旧帽子或头盔,扔填11111,不扔填0", "11111")

--用户输入框("自动换鞋子或长靴耐久值", "多少耐久以下自动换鞋子或长靴,不换可不填", "10")
--用户输入框("备用鞋子或长靴的名称", "换备用鞋子或长靴的名称,如：平民鞋、平民靴,不换可不填", "平民鞋")
--用户输入框("扔换下的旧鞋子或长靴", "是否扔换下的旧鞋子或长靴,扔填11111,不扔填0", "11111")
设置("自动扔",1,"34754")
设置("自动扔",1,"迷之手册")
设置("自动扔",1,"迷之晶体")
设置("自动扔",1,"黑暗之戒")
设置("自动扔",1,"勾玉的戒指")
设置("自动扔",1,"火焰鼠闪卡「D1奖」|火焰鼠闪卡「D2奖」|火焰鼠闪卡「D3奖」|火焰鼠闪卡「D4奖」|火焰鼠闪卡「C1奖」|火焰鼠闪卡「C2奖」|火焰鼠闪卡「C3奖」|火焰鼠闪卡「C4奖」|宝石鼠残念奖|宝石鼠铜奖|宝石鼠银奖|宝石鼠金奖|黑暗之戒|宝石？|迷之手册|迷之晶体|鼠娃娃兑换券|魅惑的哈密瓜|魅惑的哈密瓜面包|印度轻木|34583|34584|34585|34586|蕃茄|封印卡（昆虫系）|封印卡（野兽系)|封印卡（人形系）|封印卡（金属系）|封印卡（龙系）|封印卡（特殊系）|封印卡（植物系）|封印卡（飞行系）|封印卡（不死系）|鼠王的卡片|鹿皮|鸡蛋|铜|苹果薄荷|勾玉的戒指|宝石鼠洋娃娃|大地鼠洋娃娃|火焰鼠洋娃娃|恶梦鼠洋娃娃|试验红药水|面包|特制雕鱼烧|生命力回复药（75）")

预置交易物品列表={"小护士家庭号","魔力之泉","完全结晶体的紫水晶","完全结晶体的骑士宝石","完全结晶体的绿宝石","火焰鼠闪卡「B4奖」","火焰鼠闪卡「B3奖」","火焰鼠闪卡「B2奖」","火焰鼠闪卡「B1奖」","火焰鼠闪卡「A4奖」","火焰鼠闪卡「A3奖」","火焰鼠闪卡「A2奖」","火焰鼠闪卡「A1奖」","宝石鼠月亮奖","宝石鼠钻石奖","海洋之心","火焰之魂","天空之枪","帕鲁凯斯之斧","村正","鼠王"}
local tradeName=nil
local tradeBagSpace=nil
local tradePlayerLine=nil			--仓库人物当前线路
topicList={"百人道场仓库信息"}
订阅消息(topicList)
function 去打二十层()
	tryCount=0
::warpErShi::
	if( tryCount > 3 ) then
		return
	end
	if(取物品数量("34753") > 0) then
		使用物品("34753")
		等待服务器返回()	
		对话选择(4,0)	
	end
	等待(1000)
	当前地图名 = 取当前地图名()	
	if(string.find(当前地图名,"第")~=nil ) then
		return
	end	   
	tryCount=tryCount+1
	goto warpErShi
end
function openCard()
	while 取物品数量("火焰鼠闪卡") > 0 do 
		使用物品("火焰鼠闪卡")
	end
	while 取物品数量("宝石鼠闪卡") > 0 do 
		使用物品("宝石鼠闪卡")
	end
end
--换元素水晶
function exchangeShuiJing(水晶列表)
	等待到指定地图("百人道场大厅")	
	--判断碎片数量
	是否换=false
	for k,v in ipairs(elements) do	
		if(取物品叠加数量(v.."地元素碎片") >= 4)then
			是否换=true
			break
		end		
	end 	
	if 是否换 then
		移动(28,29)
		转向(0)	
		for k,v in ipairs(elements) do	
			喊话(v,2,3,5)
			等待服务器返回()	
			对话选择(4, 0)
		end 	
	end	
end

function exchangeH(count)
	移动(23,24)
	转向(2)
	while count > 0 do	
		喊话("H",2,3,5)
		等待服务器返回()	
		对话选择(4, 0)
		count = count -1
		openCard()
	end	
	等待(1000)
	openCard()
end
function exchangeC()
	移动(23,24)
	转向(2)
	喊话("C",2,3,5)
	等待服务器返回()	
	对话选择(4, 0)
end
function exchangeCH()
	
	local elements = {"地","水","风","火"}
	--三种水晶 去换C奖
	cNeedCount=0
	for k,v in ipairs(elements) do
		if(取物品数量(v.."元素水晶") > 0)then 		
			cNeedCount=cNeedCount+1
		end	
	end 	
	if(cNeedCount >= 3)then
		exchangeC()
	end
	for k,v in ipairs(elements) do
		if(取物品数量(v.."元素水晶") < 1)then 		
			if(取物品叠加数量(v.."元素碎片") >= 4)then
				移动(28,29)
				转向(0)					
				喊话(v,2,3,5)
				等待服务器返回()	
				对话选择(4, 0)				
			end		
		end	
	end 	
	cNeedCount=0
	for k,v in ipairs(elements) do
		if(取物品数量(v.."元素水晶") > 0)then 		
			cNeedCount=cNeedCount+1
		end	
	end 
	if(cNeedCount >= 3)then
		exchangeC()
	end	
	if(取物品数量("地元素水晶") > 0)then 		
		--地的全换
		地碎片多余数量=取物品叠加数量("地元素碎片")
		if(地碎片多余数量 > 0)then 
			叠("地元素碎片",4)
			exchangeH(地碎片多余数量)
		end	
		--水的次之 保留4个
		水碎片多余数量=取物品叠加数量("水元素碎片")-4
		if(水碎片多余数量 > 0)then 
			叠("水元素碎片",4)
			exchangeH(水碎片多余数量)
		end	
	end	
	-- --多余的换H奖 叠加没有排序 不知道有没有影响
	-- 地碎片多余数量=取物品叠加数量("地元素碎片")-4
	-- if(地碎片多余数量 > 0)then 
		-- 叠("地元素碎片",4)
		-- exchangeH(地碎片多余数量)
	-- end	
	
end
::StartBegin::	
	等待空闲()
	common.checkHealth()
	if(人物("金币") < 10000)then
		common.getMoneyFromBank(500000)				
	end
	当前地图名 = 取当前地图名()	
	if (当前地图名=="艾尔莎岛" )then	
		goto  island  
	elseif (当前地图名=="法兰城" )then	
		goto  Begin  
	elseif (当前地图名=="百人道场大厅" )then	
		goto  百人大厅  
	elseif( 当前地图名== "治愈的广场")then
		goto  治愈广场
	elseif(string.find(当前地图名,"第")~=nil ) then
		goto  battle
	end	   
	回城()	
	goto  StartBegin
::island::	
	x,y=取当前坐标()	
	if (x==140 and y==105 )then
		goto  aidao
	end
	移动(140,105)
	goto  StartBegin
::Begin::		
	x,y=取当前坐标()	
	if (x==72 and y==123 )then	-- 西2登录点
		goto  w2
	elseif (x==233 and y==78 )then	-- 东2登录点
		goto  e2
	elseif (x==162 and y==130 )then	-- 南2登录点
		goto  s2
	elseif (x==63 and y==79 )then	-- 西1登录点
		goto  w1
	elseif (x==242 and y==100 )then	-- 东1登录点
		goto  e1
	elseif (x==141 and y==148 )then	-- 南1登录点
		goto  s1
	end
	移动(153, 148)
	goto  qubairen

::w2::	-- 西2登录点
	转向(2)			-- 转向东	
	等待到指定地图("法兰城",233,78)	
	转向(0)		-- 转向北	
	等待到指定地图("市场一楼 - 宠物交易区", 46, 16)	
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 162, 130)
	goto  qubairen

::e2::	-- 东2登录点
	转向(0)		-- 转向北	
	等待到指定地图("市场一楼 - 宠物交易区", 46, 16)	
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 162, 130)	
	goto  qubairen

::s2::	-- 南2登录点	
	goto  qubairen

::w1::	-- 西1登录点
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 242, 100)	
	转向(2)		-- 转向东	
	等待到指定地图("市场三楼 - 修理专区", 46, 16)	
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 141, 148)	
	移动(153,148)
	goto  qubairen


::e1::	-- 东1登录点
	转向(2)		-- 转向东	
	等待到指定地图("市场三楼 - 修理专区", 46, 16)	
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 141, 148)		
	goto  qubairen

::s1::	-- 南1登录点		
	goto  qubairen



::aidao::
	if(取包裹空格() < 5)then 
		goto mai
	elseif(耐久(7) < 200 )then 
		goto mai	
	end		
	转向(1)		
	等待服务器返回()	
	对话选择(4,0)
	等待空闲()
	等待到指定地图("里谢里雅堡")	
	移动(34,89)
	renew(1)			-- 转向北边恢复人宠血魔	
	if(取物品数量("34753") > 0) then
		去打二十层()			
		等待空闲()
		goto battle
	end
	移动(41, 97)
	移动(41, 98)
    等待到指定地图("法兰城", 1)
	移动(153, 123) 
	if(耐久(2) < 自动换武器耐久值 )then 
		goto  needhzb
	elseif(耐久(1) < 自动换衣服或铠甲耐久值)then 
		goto  needhzb
	elseif(耐久(0) < 自动换帽子或头盔耐久值)then 
		goto  needhzb
	elseif(耐久(4) < 自动换鞋子或长靴耐久值)then 
		goto  needhzb
	end	
::gobairen::	 	
	移动(141, 151)	     
::qubairen::	
	if(取物品数量("34753") > 0) then
		去打二十层()			
		等待空闲()
		goto battle
	end
	移动(126, 160)
--	扔("道场记忆")
	扔("迷之手册")
	扔("迷之晶体")	

	
	移动(124, 161)
	转向(6)
	等待到指定地图("竞技场的入口", 15,23)	
	移动(26,15)
	等待到指定地图("竞技场的入口", 26,15)
	移动一格(2)
	等待到指定地图("治愈的广场", 5,32)	
::治愈广场::
	移动(25,28)	
	转向(2)
	等待服务器返回()	
	对话选择(4,0)
	等待服务器返回()	
	对话选择(1, 0)
::百人大厅::
	等待到指定地图("百人道场大厅")		
	exchangeCH()
	移动(15,23)
::zhandou::	
	转向(2)
	等待服务器返回()	
	对话选择(1, 0)
	等待(1000)
	等待空闲()
	if(取当前地图名() == "第一道场")then
		goto  battle
	end
	等待(2000)
	goto  zhandou
::battle::
	当前地图名 = 取当前地图名()		
	if(当前地图名 == "法兰城")then
		goto  回补判断
	end
	if (当前地图名=="艾尔莎岛" )then	--掉线判断
		goto  island  
	elseif(string.find(当前地图名,"第")~=nil and string.find(当前地图名,"组通过")==nil) then
		移动(15,10)
		转向(2)
		等待(3000)
		等待空闲()
	end
	当前地图名 = 取当前地图名()
	if(string.find(当前地图名,"组通过")~=nil) then
		移动(20,12)			
		转向(2)
		等待服务器返回()			
		对话选择(1, 0)
	end
	goto  battle
::回补判断::
    --扔("道场记忆")
	if (人物("血") < 补血值 )then		
		goto  回城补
	elseif (人物("魔") < 补魔值 )then	
		goto  回城补		
	elseif (宠物("血") < 宠补血值 )then	
		goto  回城补		
	elseif (宠物("魔") < 宠补魔值 )then	
		goto  回城补		
	elseif(耐久(7) < 200)then 
		goto  checkxy
	elseif(耐久(2) < 自动换武器耐久值 )then 
		goto  回城补
	elseif(耐久(1) < 自动换衣服或铠甲耐久值)then 
		goto  回城补
	elseif(耐久(0) < 自动换帽子或头盔耐久值)then 
		goto  回城补
	elseif(耐久(4) < 自动换鞋子或长靴耐久值)then 
		goto  回城补
	end	           
    goto  qubairen
::回城补::
	回城()
	等待(2000)
	--等待到指定地图("艾尔莎岛")		
	等待空闲()
	goto  StartBegin

::checkxy::
	x,y=取当前坐标()	
	if (x==141 and y==148 )then	-- 西2登录点
		goto  maisj
	end
	goto  StartBegin	
::maisj::	
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 63, 79)			
	移动(92,78)	
	取下装备("火风的水晶（5：5）")
	等待(2000)
	扔("火风的水晶（5：5）")	
	移动(94,78)	
	等待到指定地图("达美姊妹的店", 1)		
	移动(17,18)		
	取下装备("火风的水晶（5：5）")
	等待(2000)
	扔("火风的水晶（5：5）")	
	等待(3000)        	
	转向(2)
	等待服务器返回()			
	对话选择(0, 0)
	等待服务器返回()			
	买(11,1)
	等待服务器返回()		
	等待(3000)
	装备物品("火风的水晶（5：5）", 7)
	等待(1000)
	goto  StartBegin


::mai::
	移动(157,94)	
	转向坐标(158,93)		
	等待到指定地图("艾夏岛")	
	移动(112,116)
	等待(2000)
	if(取包裹空格() < 5)then 
		goto yinhang
	end	
	移动(150,125)	
	等待到指定地图("克罗利的店", 20,23)		
	移动(39,24)	
	取下装备("火风的水晶（5：5）")
	等待(1000)
	扔("火风的水晶（5：5）")
	移动(39,23)
	移动(40,23)	
	转向(2)
    等待服务器返回()	       
    对话选择(0, 0)
    等待服务器返回()	   
	买(11,1)    
    等待服务器返回()		
	等待(1000)
	使用物品("火风的水晶（5：5）")
	等待(1000)
	goto  StartBegin
::yinhang::		
	移动(114,104)		
	等待到指定地图("银行", 27,34)	
	移动(49,30)
	面向("东")
	等待服务器返回()	
::cunwu::
	银行("全存","小护士家庭号")	
	银行("全存","魔力之泉")	
	银行("全存","火焰鼠闪卡「B4奖」")	
	银行("全存","火焰鼠闪卡「B3奖」")	
	银行("全存","火焰鼠闪卡「B2奖」")	
	银行("全存","火焰鼠闪卡「B1奖」")	
	银行("全存","火焰鼠闪卡「A4奖」")	
	银行("全存","火焰鼠闪卡「A3奖」")	
	银行("全存","火焰鼠闪卡「A2奖」")	
	银行("全存","火焰鼠闪卡「A1奖」")	
	银行("全存","宝石鼠月亮奖")	
	等待(2000)
	if(取物品数量("宝石鼠金奖") > 1)then 
		goto clearpack
	end	
	if(取包裹空格() < 5)then
		common.gotoFalanBankTalkNpc()
		tradeName=nil
		tradeBagSpace=nil
		goto waitTopic		
	end	
	goto StartBegin
::waitTopic::
	if(取当前地图名()~= "银行")then
		goto StartBegin
	end
	设置("timer",0)
	topic,msg=等待订阅消息()
	日志(topic.." Msg:"..msg,1)
	if(topic == "百人道场仓库信息")then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeBagSpace=recvTbl.bagcount
		tradePlayerLine=recvTbl.line
	end	
	if(tradePlayerLine ~= nil and tradePlayerLine ~= 0 and tradePlayerLine ~= 人物("几线"))then
		切换登录信息("","",tradePlayerLine,"")
		登出服务器()
		等待(3000)			
		goto StartBegin
	end	
	if(tradeName ~= nil and tradeBagSpace ~= nil)then	
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
			goto waitTopic
		end
		if(tradex ~=nil and tradey ~= nil)then
			移动到目标附近(tradex,tradey)
		else
			goto waitTopic
		end
		转向坐标(tradex,tradey)				
		items = 物品信息()
		tradeList="金币:20;物品:"
		hasData=false
		selfTradeCount=0
		for i,v in pairs(items) do
			if(common.isInTable(预置交易物品列表,v.name) or
				(v.name=="魔族的水晶" and v.count==5))then
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
		--金币:20;物品:设计图？|0|1|誓约之花|0|1|
		--string.sub(tradeList,1,string.len(tradeList)-1)
		日志(tradeList)
		if(hasData)then
			交易(tradeName,tradeList,"",10000)
		else	
			设置("timer",100)
			tradeName=nil
			tradeBagSpace=nil
			tradePlayerLine=nil	
			回城()
			goto StartBegin
		end
	end
	goto waitTopic
::clearpack::	
	扔("宝石鼠金奖")		
	等待(1000)	
	goto  StartBegin
::needhzb::	
	if(耐久(2) < 自动换武器耐久值 )then 
		goto  buywuqi
	elseif(耐久(1) < 自动换衣服或铠甲耐久值)then 
		goto  buyyifu
	elseif(耐久(0) < 自动换帽子或头盔耐久值)then 
		goto  buymaozi
	elseif(耐久(4) < 自动换鞋子或长靴耐久值)then 
		goto  buyxiezi
	end
	goto  gobairen
::buywuqi::	
	移动(150,123)		
	转向(0)                
	等待服务器返回()	
	对话选择(0, 0)
	等待服务器返回()	
	买(4, 1) 
	等待(2000)	
	goto  checknj
::buymaozi::	
	移动(156,123)				
	转向(0)                 
	等待服务器返回()			
	对话选择(0, 0)
	等待服务器返回()			
	买(0, 1) 
	等待(2000)	
	goto  checknj
::buyyifu::	
	移动(156,123)				
	转向(0)                 
	等待服务器返回()			
	对话选择(0, 0)
	等待服务器返回()			
	买(3, 1) 
	等待(2000)	
	goto  checknj
::buyxiezi::
	移动(156,123)				
	转向(0)                 
	等待服务器返回()			
	对话选择(0, 0)
	等待服务器返回()			
	买(6, 1) 
	等待(2000)	
	goto  checknj
::checknj::
	if(耐久(2) < 自动换武器耐久值 )then 
		goto  reequiparm1
	elseif(耐久(1) < 自动换衣服或铠甲耐久值)then 
		goto  reequipbody4
	elseif(耐久(0) < 自动换帽子或头盔耐久值)then 
		goto  reequiphead1
	elseif(耐久(4) < 自动换鞋子或长靴耐久值)then 
		goto  reequipfeet1
	end
	goto  gobairen
::reequiparm1::	
	if(耐久(2) < 扔换下的旧武器 )then 
		goto  reequiparm2
	end	
	取下装备("自动换武器耐久值")
	等待(1000)
	装备物品("备用武器名的名称", 2)
	等待(1000)
	goto  needhzb
::reequiparm2::	
	扔(2)
	等待(1000)
	装备物品("备用武器名的名称", 2)
	等待(1000)
	goto  needhzb

::reequipbody4::
	if(耐久(1) < 扔换下的旧衣服或铠甲 )then 
		goto  reequipbody5
	end		
	取下装备("要换下衣服或铠甲的名称")
	等待(1000)
	装备物品("备用衣服或铠甲的名称", 1)
	等待(1000)
	goto  needhzb
::reequipbody5::	
	扔(1)
	等待(1000)
	装备物品("备用衣服或铠甲的名称", 1)
	等待(1000)
	goto  needhzb

::reequiphead1::
	if(耐久(0) < 扔换下的旧帽子或头盔 )then 
		goto  reequiphead2
	end		
	取下装备("自动换帽子或头盔耐久值")
	等待(1000)
	装备物品("备用帽子或头盔的名称", 0)
	等待(1000)
	goto  needhzb
::reequiphead2::	
	扔(0)
	等待(1000)
	装备物品("备用帽子或头盔的名称", 0)
	等待(1000)
	goto  needhzb
::reequipfeet1::
	if(耐久(4) < 扔换下的旧鞋子或长靴 )then 
		goto  reequipfeet2
	end		
	取下装备("自动换鞋子或长靴耐久值")
	等待(1000)
	装备物品("备用鞋子或长靴的名称", 4)
	等待(1000)
	goto  needhzb

::reequipfeet2::	
	扔(4)
	等待(1000)
	装备物品("备用鞋子或长靴的名称", 4)
	等待(1000)
	goto  needhzb

::reequipcrystal1::
	if(耐久(7) < 扔换下的旧水晶 )then 
		goto  reequipcrystal2
	end		
	取下装备("自动换水晶耐久值")
	等待(1000)
	装备物品("备用水晶的名称", 7)
	等待(1000)
	goto  needhzb
::reequipcrystal2::	
	扔(7)
	等待(1000)
	装备物品("备用水晶的名称", 7)
	等待(1000)
	goto  needhzb

