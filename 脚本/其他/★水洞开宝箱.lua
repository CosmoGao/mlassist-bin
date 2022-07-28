脚本支持发蓝和艾尔莎岛启动，支持传送羽毛，请设置好自动战斗,谢谢支持魔力辅助程序

common=require("common")
补魔值 = 50--用户输入框("多少魔以下补魔", "50")
补血值=430--用户输入框("多少血以下补血", "430")
宠补血值=50--用户输入框( "宠多少血以下补血", "50")
宠补魔值=100--用户输入框( "宠多少魔以下补血", "100")
迷宫最后入口坐标={}
护士所在坐标={}
迷宫是否已刷新=1
开箱子数量=0
上次迷宫顺序=2
设置("自动叠",1,"铜钥匙&999")
function 开箱子(宝箱信息)
	移动到目标附近(宝箱信息.x,宝箱信息.y)
	转向坐标(宝箱信息.x,宝箱信息.y)
	--使用物品("黑钥匙")
	--使用物品("白钥匙")
	使用物品("铜钥匙")
	等待(1000)
	等待空闲()
	开箱子数量=开箱子数量+1
	喊话("已开箱子数："..开箱子数量,2,3,5)
end

function searchCallBack(findx,findy,nextx,nexty)
	日志("回调函数："..findx.." y:"..findy)
	日志("回调函数 Next："..nextx.." y:"..nexty)
	if(findx ~= 0 and findy ~= 0)then
		移动到目标附近(findx,findy)
		转向坐标(findx,findy)
		--使用物品("黑钥匙")
		--使用物品("白钥匙")
		使用物品("铜钥匙")
		等待(1000)
		等待空闲()
		开箱子数量=开箱子数量+1
		喊话("已开箱子数："..开箱子数量,2,3,5)
	end
	return false,0,0
end

function main()
	if(取物品叠加数量("铜钥匙") < 100)then
		common.gotoFaLanCity()
		goto 去买钥匙 
	end
::begin::
	当前地图名 = 取当前地图名()
	x,y=取当前坐标()	
	mapNum=取当前地图编号()	
	if (当前地图名=="艾尔莎岛" )then	
		goto  aiersa  
	elseif (当前地图名=="里谢里雅堡" )then	
		goto  libao  	
	elseif (string.find(当前地图名,"水之洞窟地下" ) ~= nil)then			
		goto  开始找箱子  	
	elseif (string.find(当前地图名,"水之迷宫地下" ) ~= nil)then			
		goto  开始找箱子  		
	elseif (string.find(当前地图名,"水之试炼" ) ~= nil)then			
		goto  原地进入  
	elseif (string.find(当前地图名,"水之洞窟中层" ) ~= nil)then			
		goto  进水洞2  	
	elseif(当前地图名=="芙蕾雅") then
		goto  fuleiya
	elseif(当前地图名=="维诺亚村") then
		goto  去水洞	
	elseif(当前地图名=="启程之间") then
		goto  warpRoom	
	elseif(当前地图名=="水之洞窟" and mapNum==15542) then
		goto  进水洞
	elseif(mapNum==1172)then
		goto 买钥匙
	elseif (当前地图名 == "法兰城" and x==72 and y==123 )then	-- 西2登录点
		goto  w2
	elseif (当前地图名 == "法兰城" and x==233 and y==78 )then	-- 东2登录点
		goto  e2
	elseif (当前地图名 == "法兰城" and x==162 and y==130 )then	-- 南2登录点
		goto  s2
	elseif (当前地图名 == "法兰城" and x==63 and y==79 )then	-- 西1登录点
		goto  w1
	elseif (当前地图名 == "法兰城" and x==242 and y==100 )then	-- 东1登录点
		goto  e1
	elseif (当前地图名 == "法兰城" and x==141 and y==148 )then	-- 南1登录点
		goto  s1
	end	
	--回城()
	等待(1000)
	goto  begin



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
	自动寻路(41,50)	
	goto yabao1

::yabao1::
	等待到指定地图("里谢里雅堡 1楼")	
	自动寻路(74,30)
	自动寻路(68,24)
	自动寻路(49,24)
	自动寻路(45,20)
::warpRoom::
	等待到指定地图("启程之间")
	自动寻路(9, 22)		
	对话选是(8,22)	
	goto  yacun

::s2::	-- 南2登录点
	等待到指定地图("法兰城",162, 130)
	
	自动寻路(153,130)
	自动寻路(153,101)
	自动寻路(153,100)
	
	goto  yabao

::w1::	-- 西1登录点
	转向(0)		-- 转向北
	
	等待到指定地图("法兰城", 242, 100)
	
	转向(2)		-- 转向东
	
	等待到指定地图("市场三楼 - 修理专区", 46, 16)
	
	转向(0)		-- 转向北
	
	等待到指定地图("法兰城", 141, 148)
	
	自动寻路(153,148)
	自动寻路(153,101)
	自动寻路(153,100)
	
	goto  yabao

::s1::	-- 南1登录点
	等待到指定地图("法兰城", 141, 148)
	
	自动寻路(153,148)
	自动寻路(153,101)
	自动寻路(153,100)
	
	goto  yabao

::e1::	-- 东1登录点
	转向(2)		-- 转向东
	
	等待到指定地图("市场三楼 - 修理专区", 46, 16)
	
	转向(0)		-- 转向北
	
	等待到指定地图("法兰城", 141, 148)
	
	自动寻路(153,148)
	自动寻路(153,101)
	自动寻路(153,100)
	
	goto  yabao

::e2::	-- 东2登录点
	转向(0)		-- 转向北
	
	等待到指定地图("市场一楼 - 宠物交易区", 46, 16)
	
	转向(0)		-- 转向北
	
	等待到指定地图("法兰城", 162, 130)
	
	自动寻路(153,130)
	自动寻路(153,101)
	自动寻路(153,100)
	
	goto  yabao

::w2::	-- 西2登录点
	转向(2)			-- 转向东
	
	等待到指定地图("法兰城",233,78)
	
	转向(0)		-- 转向北
	
	等待到指定地图("市场一楼 - 宠物交易区", 46, 16)
	
	转向(0)		-- 转向北
	
	等待到指定地图("法兰城", 162, 130)
	
	自动寻路(153,130)
	自动寻路(153,101)
	自动寻路(153,100)
	
	goto  yabao

::yabao::
	等待到指定地图("里谢里雅堡")
	自动寻路(34,89)
	回复(1)		
	自动寻路( 41,50)	
	goto  yabao1
	
::yacun::
	等待到指定地图("维诺亚村的传送点")
	自动寻路(5, 1)
	等待到指定地图("村长家的小房间")
	自动寻路(0, 5)
	等待到指定地图("村长的家")
	自动寻路(10, 16)
	等待到指定地图("维诺亚村")
::去水洞::
	自动寻路(67, 47)
::fuleiya::
	等待到指定地图("芙蕾雅")
	自动寻路(429, 570)

::进水洞::
	等待到指定地图("水之洞窟")
	if(目标是否可达(10,8) == false) then 
		自动寻路(17,24)
		对话选是(17,23)
	end	
	等待(2000)
	等待空闲()
	自动寻路(10,7)
	自动寻路(10,8)
	goto begin	
::水洞::
--	等待到指定地图("奇怪的洞窟地下1楼")	
	if(取当前地图名() == "水之洞窟地下1楼") then				
		goto  开始找箱子			
	end		
	等待(2000)
	goto fuleiya
::进水洞2::
	mazeList = 取迷宫出入口()
	x,y=取当前坐标()	
	for k,v in pairs(mazeList) do
		if(上次迷宫顺序 > 4)then
			上次迷宫顺序=1
		end
		if( k==上次迷宫顺序 ) then
			日志("进入第"..上次迷宫顺序.."个洞")
			自动寻路(v.x,v.y)			
			上次迷宫顺序=上次迷宫顺序+1			
			break
		end		
	end
	goto begin
::原地进入::
	x,y=取当前坐标()	
	自动寻路(x+1,y)
	自动寻路(x,y)
	goto begin
	
::开始找箱子::	
	if(是否空闲中()==false)then
		等待(2000)
		goto 开始找箱子
	end		
	if(string.find(取当前地图名(),"水之洞窟中层" ) ~= nil)then			
		goto 进水洞2  	
	end
	if(取当前地图名() == "水之试炼" )then			
		goto 原地进入  	
	end
	找到,findX,findY,nextX,nextY=搜索地图("宝箱",0,"","searchCallBack")
			
	--自动寻路(nextX,nextY)
	
	--等待(2000)
	-- if(取当前地图名()=="芙蕾雅") then--迷宫刷新
		-- goto begin
	-- end
	-- x,y=取当前坐标()	
	-- 下载地图()	
	-- nx,ny=取迷宫远近坐标()--默认拿离自己最远坐标 
	-- if(x==nx and y == ny)then	--到最顶层 或地图错误
		-- goto begin
	-- end
	-- 找到宝箱=查周围信息("宝箱",0)
	-- if(找到宝箱 ~= nil) then	--找到目标
		-- 开箱子(找到宝箱)
	-- end
	-- searchMazePath = 取搜索路径(nx,ny)
	-- for k,v in pairs(searchMazePath) do
		-- print(k,v,v.x,v.y)
        -- 自动寻路(v.x,v.y)
		-- 找到宝箱=查周围信息("宝箱",0)
		-- while (找到宝箱 ~= nil) do --找到目标
			-- 开箱子(找到宝箱)
			-- 找到宝箱=查周围信息("宝箱",0)
		-- end		
	-- end
	-- 自动寻路(nx,ny)
	等待(2000)
	goto 开始找箱子

::去买钥匙::
	自动寻路(102,131)
	等待到指定地图("安其摩酒吧", 16,23)
	自动寻路(19,6)
	等待到指定地图("酒吧里面", 17,7)
	自动寻路(21,1)
	等待到指定地图("客房", 7,11)
	自动寻路(8,3)
	
::买钥匙::	
	转向(0)	
	喊话("头目万岁",2,3,5)
	等待服务器返回()	
	对话选择(4, 0)		
	if(取物品叠加数量("铜钥匙") >= 100)then
		回城()
		goto begin
	end
	goto 买钥匙
end
main()