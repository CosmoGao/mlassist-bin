随便改一改的做得不好别见怪       
  
设置("高速延时",0)  
设置("高速战斗",1)  
设置("自动战斗",1)  
设置("遇敌速度",20)  
设置("不带宠二动",1)  
设置("二动防御",1)  

刷声望前时间=os.time() 
刷声望回补总计=0
刷声望前金币=人物("金币")

function 统计消耗(beginTime)	
	local nowTime = os.time() 
	local time = math.floor((nowTime - beginTime)/60)--已持续时间
	if(time == 0)then
		time=1
	end	
	刷声望回补总计 = 刷声望回补总计+1
	local usedGold = 刷声望前金币 - 人物("金币")
	日志("第【"..刷声望回补总计.."】轮回补,已持续【"..time.."】分钟，总计消耗【"..usedGold.."】金币")
end
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()	
	if (当前地图名=="艾尔莎岛" )then	
		goto erDao	
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao
	elseif (当前地图名=="灵堂" )then	
		goto yudi	
	end
	回城()
	等待(1000)
	goto begin
::erDao::	
	自动寻路(140,105)
	等待(500)	
	转向(1)
	等待服务器返回()
	对话选择(4,0)
	等待(500)		
	等待空闲()
	if (取当前地图名()=="艾尔莎岛" )then	
		goto begin
	end
::liBao::
	自动寻路(47,86)	
	自动寻路(47,85,"召唤之间")		
	自动寻路(27,8,"回廊")		
	自动寻路(23,19,"灵堂")
::yudi::	
	自动寻路(27,54)
	开始遇敌() 
	goto scriptStart 
::scriptStart::	
	if(人物("魔") < 100)then goto  buxue end     --魔小于10
	if(人物("血") < 100)then goto  buxue end
	等待(1000)
	goto scriptStart 
::buxue::
	停止遇敌()          -- 结束战斗		
	统计消耗(刷声望前时间)
	自动寻路(31,48,"回廊")	
	自动寻路(25,22)
	回复(2)		-- 恢复人宠		
	自动寻路(23,19,"灵堂")
	goto yudi 


