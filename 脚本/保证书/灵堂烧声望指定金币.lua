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
指定消耗金币=用户输入框("指定消耗金币","100000")
刷之前称号=人物("称号")

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
--通过金币判断 再去阿蒙和医院那二次确认
function 判断称号()	

	local usedGold = (刷声望前金币 - 人物("金币"))
	if(usedGold >= 指定消耗金币) then
		日志("已消耗:"..usedGold.." 金币，达到下级声望所需金币，去领取称号")
		return true
	end
	--日志("还需消耗:"..(目标称号数据.gold-usedGold).." 金币")
	return false
end
-- 0继续刷下级称号 
-- 1初始获取的下级称号数据有误 退出
-- 2没有达到下级称号 多刷一会
-- 3已到最终称号
function 称号提交()		
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()	
	if (当前地图名=="艾尔莎岛" )then	
		goto erDao	
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao		
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
	等待(2000)		
	等待空闲()
	if (取当前地图名()=="艾尔莎岛" )then	
		goto begin
	end
::liBao::
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
	goto begin
::faLanBank::		
	等待到指定地图("法兰城")	
	自动寻路(230,84)
	title = 人物("称号")
	转向(0)
	转向(0)
	等待(2000)	--等系统刷新	
	nowTitle =人物("称号")
	if(刷之前称号 == nowTitle)then
		日志(" 未获得新称号，当前人物称号为【"..nowTitle.."】",1)
	else
		日志(" 获得新称号【"..nowTitle.."】",1)
	end
	设置("人物称号",nowTitle)
	if(nowTitle == "无尽星空")then
		日志("已达最终称号，退出！")
		return 3
	end
	自动寻路(235,107)
	转向(4)
	dlg = 等待服务器返回()
	range = 称号进度(dlg.message)	
	日志(当前时间.." 当前人物称号进度为【"..range.."/4】",1)
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
	return 0
end

function main()
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
	if(人物("魔") < 300)then goto  buxue end     --魔小于10
	if(人物("血") < 300)then goto  buxue end
	等待(1000)
	goto scriptStart 
::buxue::
	停止遇敌()          -- 结束战斗		
	统计消耗(刷声望前时间)
	if(判断称号() == true) then 
		日志("已刷够指定金币，去领取称号!")
		称号提交()	
		return
	end
	自动寻路(31,48,"回廊")	
	自动寻路(25,22)
	回复(2)		-- 恢复人宠		
	自动寻路(23,19,"灵堂")
	goto yudi 

end
main()

