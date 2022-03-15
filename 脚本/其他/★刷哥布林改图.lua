脚本支持法蓝和艾尔莎岛启动，自动存改图以及自动改哥布林，请设置好自动战斗

补魔值 = 50--用户输入框("多少魔以下补魔", "50")
补血值=430--用户输入框("多少血以下补血", "430")
宠补血值=50--用户输入框( "宠多少血以下补血", "50")
宠补魔值=150--用户输入框( "宠多少魔以下补血", "150")
自动换水晶耐久值=30--用户输入框( "多少耐久以下自动换水晶,不换可不填", "30")        
迷宫最后入口坐标={}
护士所在坐标={}
迷宫是否已刷新=1
刷之前金币=人物("金币")
卖店物品列表="魔石|卡片？|锹型虫的卡片|虎头蜂的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"		--可以增加多个 不影响速度
topicList={"烈风哥布林改图仓库信息"}
订阅消息(topicList)
刷改图线=人物("几线")
tradeName=nil				--仓库人物名称
tradeBagSpace=nil			--仓库人物宠物空格
tradePlayerLine=nil			--仓库人物当前线路

--练级统计信息打印
刷改图总数=0
开始刷图时间=os.time()
improvePlan = {
	{name="哥布林矿工设计图A",count=0},
	{name="哥布林矿工设计图B",count=0},
	{name="哥布林矿工设计图C",count=0},
	{name="哥布林矿工设计图D",count=0},
	{name="哥布林矿工设计图E",count=0},
	}
function 统计(beginTime)	
	local playerinfo = 人物信息()
	local nowTime = os.time() 
	local time = math.floor((nowTime - beginTime)/60)--已持续练级时间
	if(time == 0)then
		time=1
	end	
	
	local oldGold=刷之前金币
	local goldContent =""
	if(oldGold~=nil) then
		local nowGold = 人物("金币")
		local getGold = nowGold - oldGold
		local avgGold = math.floor(60 * getGold/time)
		goldContent = " 消耗金币【"..getGold.."】平均每小时消耗【"..avgGold.."】金币"
	end
	local avgCount = math.floor(60 * 刷改图总数/time)	
	
	local content ="已持续刷图【"..time.."】分钟，共获得【"..刷改图总数.."张】改图，平均每小时【"..avgCount.."张】改图，"..goldContent	
	local planConten="其中："
	for i,item in ipairs(improvePlan)do
		if(string.find(最新系统消息(),item.name)~=nil)then
			planConten=planConten..item.name.." "..item.count.."张 "
		end
	end
	日志(content..planConten,1)
end
function 去银行拿钱(money)
	等待空闲()
	if(取队伍人数()>1)then
		离开队伍()
	end        
::dengru::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto star1
	elseif (当前地图名=="里谢里雅堡" )then	
		goto star2
	elseif (当前地图名=="法兰城" )then	
		goto faLan
	elseif (当前地图名=="召唤之间" )then	--登出 bank
		移动( 3, 7)	
		等待到指定地图("里谢里雅堡")	
		goto star2
	end	
	回城()
	goto dengru
::star1::
	移动(157,94)	
	转向坐标(158,93)		
	等待到指定地图("艾夏岛")	
	移动(114,105)	
	移动(114,104)	
	等待到指定地图("银行")	
	移动(49,30)
	面向("东")
	等待服务器返回()
	银行("取钱",money)--没有取钱金额判断
    goto goEnd 
::star2::		
	移动(41,98)	
	等待到指定地图("法兰城")	
	移动(162, 130)		
    goto faLan
::faLan::
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
	goto dengru
::faLanBank::		
	等待到指定地图("法兰城")	
	移动(238,111)
	等待到指定地图("银行")	
	移动(11,8)
	面向("东")
	等待服务器返回()
	银行("取钱",money)--没有取钱金额判断
    goto goEnd 
::w2::	-- 西2登录点
	转向(2)			-- 转向东	
	等待到指定地图("法兰城",233,78)		
	goto faLanBank

::e2::	-- 东2登录点	
	goto faLanBank

::s2::	-- 南2登录点	
	转向(2)	
	goto faLan	

::w1::	-- 西1登录点
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 242, 100)		
	goto faLanBank


::e1::	-- 东1登录点
	goto faLanBank

::s1::	-- 南1登录点		
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 63, 79)		
	goto faLan
::goEnd::
	return		
end

function waitTopic()
	if(刷改图线==nil)then 刷改图线=人物("几线") end
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
	if(topic == "烈风哥布林改图仓库信息")then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeBagSpace=recvTbl.bagcount
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
			allitems = 物品信息()
			tradeList="金币:2000;物品:"
			hasData=false
			selfTradeCount=0
			for i,v in pairs(allitems) do
				if(string.find(v.name,"哥布林矿工")~=nil  and v.pos>=8)then					
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
			else	
				设置("timer",100)
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
	--不用换线 仓库线刷即可
	-- if(人物("几线")~=刷改图线)then
		-- 切换登录信息("","",刷改图线,"")
		-- 登出服务器()
		-- 等待(3000)
		-- return
	-- end
end
function main()
::begin::	
	等待空闲()
	--common.checkHealth()
	if(人物("金币") < 4000)then
		去银行拿钱(500000)				
		if(人物("金币") < 4000)then
			日志("没有钱了哦，银行也没有钱了，咱先不刷了！",1)
			等待(3000)
			goto begin
		end
	end
	当前地图名 = 取当前地图名()
	x,y=取当前坐标()	
	地图编号=取当前地图编号()
	if(取包裹空格() < 2)then
		if (当前地图名=="银行" )then	
			goto aiBank  
		end
		goto bank
	end	
	if (当前地图名=="艾尔莎岛" )then	
		goto aiersa  
	elseif (当前地图名=="里谢里雅堡" )then	
		goto libao  	
	elseif (string.find(当前地图名,"奇怪的洞窟" ) ~= nil)then			
		goto 开始找人  					
	elseif(当前地图名=="芙蕾雅") then
		goto fuleiya
	elseif(当前地图名=="亚留特村") then
		goto 去狗洞
	elseif(当前地图名=="阿鲁巴斯实验所" )then			
		goto boss
	elseif(当前地图名=="阿鲁巴斯研究所")then		
		goto boss
	elseif(当前地图名=="香蒂的房间")then
		移动(9, 7)		
		goto  mai	
	elseif (x==72 and y==123 )then	-- 西2登录点
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
	回城()
	等待(1000)
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
	移动(41, 53)
	if(耐久(7) < 自动换水晶耐久值) then goto liBaoToFaLan end
	移动(41,50)
	goto yabao1
::yabao1::
	等待到指定地图("里谢里雅堡 1楼")		
	移动(45,20,"启程之间")
	移动(43, 23)		
	转向(1)
	等待服务器返回()	
	对话选择(4, 0)
	goto  yacun

::s2::	-- 南2登录点
	等待到指定地图("法兰城",162, 130)
	
	移动(153,130)
	移动(153,101)
	移动(153,100)
	
	goto  yabao

::w1::	-- 西1登录点
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 242, 100)	
	转向(2)		-- 转向东	
	等待到指定地图("市场三楼 - 修理专区", 46, 16)	
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 141, 148)
	移动(153,100)	
	goto  yabao

::s1::	-- 南1登录点
	等待到指定地图("法兰城", 141, 148)
	移动(153,100)	
	goto  yabao

::e1::	-- 东1登录点
	转向(2)		-- 转向东	
	等待到指定地图("市场三楼 - 修理专区", 46, 16)	
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 141, 148)		
	移动(153,100)	
	goto  yabao

::e2::	-- 东2登录点
	转向(0)		-- 转向北	
	等待到指定地图("市场一楼 - 宠物交易区", 46, 16)	
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 162, 130)	
	移动(153,100)	
	goto  yabao

::w2::	-- 西2登录点
	转向(2)			-- 转向东	
	等待到指定地图("法兰城",233,78)	
	转向(0)		-- 转向北	
	等待到指定地图("市场一楼 - 宠物交易区", 46, 16)	
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 162, 130)	
	移动(153,100)	
	goto yabao
::yabao::
	等待到指定地图("里谢里雅堡")		
	移动(34,89)
	回复(1)		
	移动(41,51)
	移动(41,50)	
	goto yabao1	
::yacun::
	等待到指定地图("亚留特村的传送点", 5,15)
	移动(8, 3)
	等待到指定地图("村长的家", 22,9)
	移动(6, 13)
	等待到指定地图("亚留特村", 56,48)
::去狗洞::
	移动(58, 31)
	等待到指定地图("芙蕾雅")
	移动(541, 33)
	移动(540, 33)
::fuleiya::	
	找迷宫= 搜索范围迷宫(520, 15, 40, 40,"549,43;")
	if(找迷宫) then				
		goto 狗洞
	end	
	移动(541, 33)
	等待(2000)
	if(取当前地图名() == "奇怪的洞窟地下1楼") then
		goto 狗洞
	end		
	goto fuleiya
::狗洞::
--	等待到指定地图("奇怪的洞窟地下1楼")	
	if(取当前地图名() == "奇怪的洞窟地下1楼") then		
		x,y = 取当前坐标()	
		if(迷宫最后入口坐标["x"] == x and 迷宫最后入口坐标["y"]==y and 护士所在坐标["x"] ~= 0 and 护士所在坐标["y"] ~= 0) then
			迷宫是否已刷新 = 0		--早期判断不下载地图用的 
			喊话("迷宫未刷新:"..迷宫最后入口坐标["x"]..","..迷宫最后入口坐标["y"],2,3,5)				
			goto  穿越迷宫			
		else--记录坐标 下次寻路用		
			--重置状态，下次判断用
			迷宫是否已刷新=1
			迷宫最后入口坐标["x"],迷宫最后入口坐标["y"]=取当前坐标()	
			护士所在坐标["x"]=0
			护士所在坐标["y"]=0
			护士所在坐标["名称"]=""	--最后找到的地图名重置
			喊话("记录迷宫:"..迷宫最后入口坐标["x"]..","..迷宫最后入口坐标["y"],2,3,5)
			goto  开始找人
		end			
	end		
	等待(2000)
	goto  fuleiya
::开始找人::
	if(取物品数量("实验药") > 0)then		--中途刷新 会导致有问题 需要增加	
		goto 正常走迷宫
	end
	if(是否空闲中()==false)then
		等待(2000)
		goto  开始找人
	end		
	if(取当前地图名()=="芙蕾雅") then--迷宫刷新
		goto  begin
	end
	if( string.find(取当前地图名(),"奇怪的洞窟")==nil)then	--不是迷宫 不招人
		goto begin
	end
	找到,findX,findY,nextX,nextY=搜索地图("无照护士米内鲁帕",1)
	if(找到) then
		护士所在坐标["x"]=findX
		护士所在坐标["y"]=findY
		护士所在坐标["名称"]=取当前地图名()
		护士所在坐标["nextX"]=nextX
		护士所在坐标["nextY"]=nextY
		移动到目标附近(护士所在坐标["x"],护士所在坐标["y"])
		转向坐标(护士所在坐标["x"],护士所在坐标["y"])	
		喊话("记录坐标: "..护士所在坐标["名称"].." "..护士所在坐标["x"]..","..护士所在坐标["y"],2,3,5)
		goto 穿越迷宫
	end
	等待(2000)
	goto  开始找人
::穿越迷宫::				--加判断 如果护士坐标为0 重新搜索
	x,y = 取当前坐标()
	if(取当前地图名() == 护士所在坐标["名称"])then		
		tryNum = 0
		while 取物品数量("实验药") < 1 and tryNum <= 3  do
			等待空闲()
			移动到目标附近(护士所在坐标["x"],护士所在坐标["y"],1)
			转向坐标(护士所在坐标["x"],护士所在坐标["y"])	
			tryNum=tryNum+1
		end		
		if(取物品数量("实验药") > 0)then
			移动(护士所在坐标["nextX"],护士所在坐标["nextY"])
			goto  正常走迷宫
		else						--这边有bug 如果中途被送出去，虽然会记录迷宫，但因为实验药>0 所以还是不会找人
			goto  开始找人
		end
	end
	goto 正常走迷宫
	
::正常走迷宫::
	当前地图名 = 取当前地图名()
	if(当前地图名=="芙蕾雅") then
		goto  fuleiya
	elseif (当前地图名=="艾尔莎岛" )then	
		goto  begin
	elseif (当前地图名=="阿鲁巴斯实验所") then--15505
		移动(21, 19)	
		喊话("打boss咯",2,3,5)
		转向(0)
		等待(2000)
		goto boss
	end
	自动迷宫(迷宫是否已刷新)
	等待(1000)
	goto  穿越迷宫
::boss::	
	等待空闲()
	当前地图名 = 取当前地图名()
	if(当前地图名=="芙蕾雅") then
		if (人物("血") < 补血值 )then		
			goto back
		elseif (人物("魔") < 补魔值 )then	
			goto back
		elseif (宠物("血") < 宠补血值 )then	
			goto back
		elseif (宠物("魔") < 宠补魔值 )then	
			goto back
		elseif(取包裹空格() < 2)then
			goto bank
		else
			goto begin	
		end		
	elseif (当前地图名=="艾尔莎岛" )then	
		goto begin
	elseif(当前地图名=="阿鲁巴斯实验所" )then
		if(取物品数量("实验药") < 1 and 是否空闲中()==true) then
			移动(40, 8)
			移动(40, 6)
			goto 开始找人	
		else
			移动(21, 19)	
			喊话("打boss咯",2,3,5)
			转向(0)
			等待(2000)
		end
	elseif(当前地图名=="阿鲁巴斯研究所")then
		if(取当前地图编号() == 15506)then
			移动(13, 15)
			转向(7)
			goto  boss			
		end		
	elseif(当前地图名=="香蒂的房间")then
		移动(9, 7)		
		goto mai	
	end
	等待(2000)
	goto  boss
::back::
	移动(588,51)
	等待到指定地图("亚留特村", 59,32)
	移动(52,63)
	等待到指定地图("医院", 2,9)
	移动(10, 5)
	renew(2) 
	--队长的话  这里等待5秒 
	移动(2, 9)
	等待到指定地图("亚留特村", 52,63)	
	goto  begin
::mai::
	转向(2)
	等待服务器返回()	
	对话选择(32, 0)	
	等待服务器返回()	
	对话选择(32, 0)
	等待服务器返回()	
	对话选择(32, 0)
	等待服务器返回()	
	对话选择(4, 0)
	等待服务器返回()	
	对话选择(4, 0)
	等待服务器返回()	
	对话选择(1, 0)
	等待(2000)
	等待空闲()
	if(string.find(最新系统消息(),"哥布林矿工设计图")~=nil)then
		刷改图总数=刷改图总数+1
		for i,item in ipairs(improvePlan)do
			if(string.find(最新系统消息(),item.name)~=nil)then
				item.count = item.count+1
				break
			end
		end		
	end
	统计(开始刷图时间)
	清除系统消息()
	goto boss
::bank::
	回城()
	等待(2000)
	当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		移动(157,94)	
		转向坐标(158,93)		
		等待到指定地图("艾夏岛")	
		移动(114,105)	
		移动(114,104)	
		goto aiBank
	end
::aiBank::
	等待到指定地图("银行")	
	移动(49,30)
	面向("东")
	银行("全存","哥布林矿工设计图A")
	银行("全存","哥布林矿工设计图B")
	银行("全存","哥布林矿工设计图C")
	银行("全存","哥布林矿工设计图D")
	银行("全存","哥布林矿工设计图E")
	银行("全存","设计图？")
	if(取包裹空格() < 2)then
		goto manle
	end
	回城()
	goto begin
::manle::
	喊话("包裹满了，清理后执行",2,3,5)
	等待(12000)
	goto checkWholePlan	
::checkWholePlan::	--检测图纸是否全了 以及有未改哥布林
	if(取物品数量("哥布林矿工设计图A") > 0 and 取物品数量("哥布林矿工设计图B") > 0 and 取物品数量("哥布林矿工设计图C") > 0 and 取物品数量("哥布林矿工设计图D") > 0 and 取物品数量("哥布林矿工设计图E") > 0)then
		身上宠物信息=全部宠物信息()
		for i,pet in ipairs(身上宠物信息) do
			if(pet.realname == "烈风哥布林" and pet.level == 1)then
				回城()
				goto convertGBL
			end
		end
	end
	if(取包裹空格() < 2)then
		common.gotoFalanBankTalkNpc()
		tradeName=nil
		tradeBagSpace=nil
		waitTopic()
	end
	if(取包裹空格() < 2)then
		goto manle		
	end
	goto begin
::convertGBL::
	等待空闲()
	当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then				
		移动(140,105)
		转向(1)
		等待服务器返回()	
		对话选择(4, 0)		
		等待到指定地图("里谢里雅堡")	
		移动(65,53,"法兰城")
		goto convertGBLTofaLan	
	elseif (当前地图名=="法兰城" )then	
		goto convertGBLTofaLan	
	end	
	回城()
	goto convertGBL
::convertGBLTofaLan::
	移动(194,67)		
	对话选是(195,67)
	对话选是(195,67)
	对话选是(195,67)
	goto begin
::liBaoToFaLan::
	移动(17,53,"法兰城")	
	移动(94,78,"达美姊妹的店")		
	移动(17,18)	
	等待(1000)		
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
		扔(7)
		等待(1000)		
		使用物品("风地的水晶（5：5）")
	else
		日志("购买水晶失败！")
		卖(2, 卖店物品列表)			
	end	
	回城()
	goto begin
end

main()
