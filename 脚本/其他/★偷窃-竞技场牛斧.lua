偷竞技场牛鬼斧头脚本,不带宠一回合偷，二动选择跑，屏蔽切图，移速120；带宠1回合偷宠物护卫，2回合以上逃跑，带宠比较稳定，牛打人还是疼

common=require("common")
设置("timer", 100)
设置("自动战斗", 1)
设置("高速战斗", 1)
设置("高速延时", 0)
设置("自动加血",0)
local 走路加速值=115	--脚本走路中可以设定移动速度  到达目的地后，再还原值即可
local 走路还原值=100	--防止掉线 还原速度
local 人补血=500
local 人补魔=100
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


function statistics(beginTime,count)
	local playerinfo = 人物信息()
	local nowTime = os.time() 
	local time = math.floor((nowTime - beginTime)/60)--已持续时间
	if(time == 0)then
		time=1
	end	
	local goldContent =""
	if(oldGold~=0 ) then
		local nowGold = 人物("金币")
		local getGold = nowGold - oldGold
		allGoldNum=allGoldNum+getGold
		local avgGold = math.floor(60 * allGoldNum/time)
		goldContent = "已持续偷窃【"..time.."】分钟，偷窃次数【"..count.."】次，共消耗".."【"..allGoldNum.."】金币，平均每小时【"..avgGold.."】金币"
		日志(goldContent)
		oldGold=人物("金币")	
	end
end

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
	-- 自动寻路(22, 13)
	-- 等待(2000)
	-- goto begin
-- ::map1451::		
	-- 自动寻路(15, 8)
	-- 等待(2000)
	-- goto begin
-- ::map1452::	
	-- 自动寻路(22, 8)
	-- 等待(2000)
	-- goto begin
-- ::map1453::
	-- 自动寻路(15, 8) 
	-- 等待(2000)
	-- goto begin
-- ::map1454::	
	-- 自动寻路(22, 16)
	-- 等待(2000)
	-- goto begin
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
	if(取物品数量("18256") > 0)then
		自动寻路(30, 21)	
		转向(2, "")
		等待服务器返回()
		对话选择("4", "", "")
		对话选择("1", "", "")
		等待(1000)
		if(是否战斗中())then 
			等待战斗结束()			
		end
		if(取物品数量("18256") <= 0)then	
			battleCount=battleCount+1
			statistics(开始时间,battleCount)			
			if(取物品数量("17727") > 0)then 	--斧？
				日志("恭喜偷到牛斧！")
			end			
		end
		if(人物("魔") < 人补魔)then goto huicheng end 
		if(人物("血") < 人补血)then goto huicheng end			
		等待(2000)
	else
		自动寻路(28, 19)	
		转向(0)
		等待服务器返回()
		对话选择("1", "", "")
		等待(mapWaitTime)
	end	
	goto begin 
	 
::map1496::			--后场休息
	自动寻路(15,6)
	转向(0)
	等待服务器返回()
	对话选择("1", "", "")
	等待(mapWaitTime)
	goto begin
        
end
main()
