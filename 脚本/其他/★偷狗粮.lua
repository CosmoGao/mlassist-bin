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

--练级统计信息打印
刷改图总数=0
开始刷图时间=os.time()

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
		自动寻路( 3, 7)	
		等待到指定地图("里谢里雅堡")	
		goto star2
	end	
	回城()
	goto dengru
::star1::
	自动寻路(157,94)	
	转向坐标(158,93)		
	等待到指定地图("艾夏岛")	
	自动寻路(114,105)	
	自动寻路(114,104)	
	等待到指定地图("银行")	
	自动寻路(49,30)
	面向("东")
	等待服务器返回()
	银行("取钱",money)--没有取钱金额判断
    goto goEnd 
::star2::		
	自动寻路(41,98)	
	等待到指定地图("法兰城")	
	自动寻路(162, 130)		
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
	自动寻路(238,111)
	等待到指定地图("银行")	
	自动寻路(11,8)
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

function main()
	设置("遇敌全跑",1)
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
	elseif (当前地图名=="牛鬼的洞穴" )then	
		自动寻路(16,10)
		等待(2000)		
	elseif (string.find(当前地图名,"牛鬼的洞窟" ) ~= nil)then			
		goto 开始找人  					
	elseif(当前地图名=="芙蕾雅") then
		goto 芙蕾雅
	elseif(当前地图名=="法兰城") then
		goto FaLan
	elseif(当前地图名=="宝物库" )then			
		goto map11019
	elseif(地图编号==11016)then	--洞窟
		goto map11016
	end		
	等待(1000)
	goto begin
::aiersa::
	等待到指定地图("艾尔莎岛")		
	自动寻路(140,105)
	转向(1)
	等待服务器返回()	
	对话选择(4, 0)	
::libao::
	等待到指定地图("里谢里雅堡")	
	自动寻路(34,89)
	回复(1)				
	if(耐久(7) < 自动换水晶耐久值) then goto liBaoToFaLan end
	自动寻路(41,98,"法兰城")
	自动寻路(162,130)
	转向(2)
	等待到指定地图("法兰城",72,123)
	转向(2)
	等待到指定地图("法兰城",233,78)	
::FaLan::
	自动寻路(281,87)
	goto 芙蕾雅
::芙蕾雅::		
	自动寻路(665,184)
	等待(2000)	
	goto begin
::map11016::	--洞窟 白天
	日志("现在是白天，进不了牛鬼的洞穴，等待天黑",1)
	while true do 			
		if(游戏时间() == "黄昏" or 游戏时间() == "夜晚")then
			自动寻路(16,19,"芙蕾雅")
			break
		else
			日志("当前时间是【"..游戏时间().."】，等待【黄昏或夜晚】")
			等待(30000)
		end			
	end		
	goto begin
::map11019::
	if(目标是否可达(27,15)) then
		自动寻路(27,15)
		设置("遇敌全跑",0)
		宠物("改状态","待命")
		goto scriptStart
	end
	自动寻路(25,34)
	对话选是(25,33)
	等待(2000)
	goto map11019
::scriptStart::
	if(取当前地图名() ~= "宝物库")then
		goto begin	
	end
	转向(0)
	if(是否战斗中()) then
		等待战斗结束()
	end
	if(人物("血") < 500 or 人物("魔") < 100)then
		--多等一会，等面板自动吃料理和血瓶
		等待(5000)
	end
	等待(2000)
	goto scriptStart

::开始找人::
	if(取物品数量("牛鬼杀") > 0)then			
		goto 正常走迷宫
	end
	if(是否空闲中()==false)then
		等待(2000)
		goto 开始找人
	end		
	if(取当前地图名()=="芙蕾雅") then--迷宫刷新
		goto begin
	end
	if( string.find(取当前地图名(),"牛鬼的洞窟")==nil)then	--不是迷宫 不招人
		goto begin
	end
	找到,findX,findY,nextX,nextY=搜索地图("冒险者金德其",1)
	if(找到) then		
		转向坐标(findX,findY)	
		对话选是(findX,findY)	
		喊话("记录坐标: "..取当前地图名().." "..findX..","..findY,2,3,5)
		自动寻路(nextX,nextY)
		goto 正常走迷宫
	end
	等待(2000)
	goto  开始找人

	
::正常走迷宫::
	等待空闲()
	当前地图名 = 取当前地图名()
	if(当前地图名=="芙蕾雅") then
		goto 芙蕾雅
	elseif (当前地图名=="艾尔莎岛" )then	
		goto begin
	elseif (当前地图名=="宝物库") then--15505		
		goto map11019
	end
	自动迷宫(1)
	等待(1000)
	goto 正常走迷宫

::bank::
	回城()
	等待(2000)
	当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		自动寻路(157,94)	
		转向坐标(158,93)		
		等待到指定地图("艾夏岛")	
		自动寻路(114,105)	
		自动寻路(114,104)	
		goto aiBank
	end
::aiBank::
	等待到指定地图("银行")	
	自动寻路(49,30)
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
	goto manle	

::liBaoToFaLan::
	自动寻路(17,53,"法兰城")	
	自动寻路(94,78,"达美姊妹的店")		
	自动寻路(17,18)	
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
