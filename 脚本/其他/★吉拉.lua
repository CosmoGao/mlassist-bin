--自动吉拉。注意：定居艾岛



common=require("common")
设置("timer", 100)
设置("自动战斗", 1)
设置("高速战斗", 1)
设置("高速延时", 0)
设置("自动加血",0)
local 走路加速值=110	--脚本走路中可以设定移动速度  到达目的地后，再还原值即可
local 走路还原值=100	--防止掉线 还原速度
local mapNum=0
local battleCount=0		--统计次数
local 开始时间=os.time() 
local allGoldNum=0
local oldGold = 人物("金币")
local jjctbl={
	[1450]={x=22,y=13},
	[1451]={x=15,y=8},
	[1452]={x=22,y=8},
	[1453]={x=15,y=8},
	[1454]={x=22,y=16}
	}
local mapWaitTime=1500		--切换地图等待时间
local 人补血值=用户输入框( "人多少血以下补血", "200")
local 人补魔值=用户输入框( "人多少魔以下补魔", "100")
local 宠补血值=用户输入框( "宠多少血以下补血", "200")
local 宠补魔值=用户输入框( "宠多少魔以下补魔", "100")
	
function main()
	设置("移动速度",走路加速值)
::begin::
	等待空闲()
	mapNum=取当前地图编号()
	if(mapNum == 1455)then
		goto map1455
	elseif(mapNum >= 1450 and mapNum <=1454)then	--竞技场
		goto map1450
	elseif(mapNum == 1456)then
		goto map1456
	elseif(mapNum == 1457)then
		goto map1457
	elseif(mapNum == 1496)then
		goto map1496
	elseif(mapNum == 59520)then	--艾尔莎岛
		goto map59520
	elseif(mapNum == 1000)then	--法兰城
		goto map1000
	elseif(mapNum == 1500)then	--里谢里雅堡
		goto map1500
	elseif(mapNum == 1400)then	--竞技场的入口
		goto map1400
	elseif(mapNum == 1403)then	--治愈的广场
		goto map1403	
	end
	回城()        
	goto begin
::huicheng::
	等待空闲()
	回城()    
	goto begin	
::map59520::        		--艾尔莎岛
	if(人物("坐标")~="140,105")then 
		回城()
		goto begin
	end	
	转向(1)
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("里谢里雅堡", 27, 82)
	goto map1500
      
::map1500::
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)
	common.gotoFaLanCity()		
::map1000::
	自动寻路(124, 161)	--
	转向(6, "")
::map1400::			--竞技场的入口
	等待到指定地图("竞技场的入口")
	自动寻路(27, 15,"治愈的广场")	
::map1403::
	自动寻路(26, 14)	
	转向(0)
	等待服务器返回()
	对话选择("32", "", "")
	对话选择("4", "", "")
	对话选择("1", "", "")	
	--等待到指定地图("竞技场", 15, 9)
	等待(mapWaitTime)

::map1450::		
	tgtPos=jjctbl[取当前地图编号()]
	自动寻路(tgtPos.x,tgtPos.y)
	--等待(mapWaitTime)
	goto begin
::map1455::	
	自动寻路(16, 12)	
	转向(0, "")
	等待服务器返回()
	对话选择("4", "", "")
	对话选择("1", "", "")
	--等待到指定地图("休息室")
	等待(mapWaitTime)	
	goto begin
::map1456::		--休息室		
	自动寻路(15, 5)	
	转向(4)
	等待服务器返回()
	对话选择("4", "", "")
	对话选择("32", "", "")
	对话选择("32", "", "")
	对话选择("32", "", "")
	对话选择("32", "", "")
	对话选择("1", "", "")
	对话选择("1", "", "")
	等待(mapWaitTime)		--斗士之证 18256
	自动寻路(16, 5)	
	转向(2, "")
	等待服务器返回()
	对话选择("4", "", "")
	对话选择("1", "", "")		
	--等待到指定地图("竞技预赛会场") --有时候服务器返回慢 会卡这
	等待(mapWaitTime)						--改成这个 begin去判断
	goto begin
::map1457::		--竞技预赛会场	
	自动寻路(31,23)
	等待到指定地图("竞技预赛会场", 31,23)	
::Kill::
	if(人物("血") < 人补血值)then goto  huicheng end
	if(人物("魔") < 人补魔值)then goto  huicheng end	 
	if(宠物("血") < 宠补血值)then goto  huicheng end	
	if(宠物("魔") < 宠补魔值)then goto  huicheng end		
	if(人物信息().value_charisma >= 100 )then 
		日志("魅力已满，退出")
		return
	end
	转向(2, "")
	等待服务器返回()	
	对话选择(4, 0)
	等待服务器返回()
	对话选择(1, 0)	
	等待(2000)
	等待空闲()		
	扔("18257")
	goto Kill
::map1496::			--后场休息
	自动寻路(15,6)
	转向(0)
	等待服务器返回()
	对话选择("1", "", "")
	等待(mapWaitTime)
	goto begin
end
main()