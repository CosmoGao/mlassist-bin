-- 设定自动战斗设置,设置 李贝留斯 逃跑

停止遇敌()

设置("自动战斗", 1)		-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速延时", 0)        -- 高速战斗速度，0速度最低，6速度最高


补魔值=用户输入框( "多少魔以下去补给", "100")
补血值=用户输入框( "多少血以下去补给", "400")

local count=0					--已刷次数
local prestigeVal = 180			--每次获得声望
local beginTime=os.time() 		--开始刷时间
local target= 650				--打算刷多少次
function main()
	if(取物品数量("咬花") < 1) then
		日志("身上没有咬花",1)
		return
	end
	playerLv =人物("等级")
	if(playerLv > 112) then 
		titleUp = 170
	elseif(playerinfo.level > 132)then 	
		titleUp = 160
	elseif(playerinfo.level > 152)then	
		titleUp = 150 
	end
::begin::
	等待空闲()	
	mapName=取当前地图名()
	if(mapName == "艾尔莎岛") then
		goto hao
	elseif(mapName == "回忆之间")then
		goto hao2
	end
	回城()
	等待(3000)
	等待到指定地图("艾尔莎岛", 140, 105)
::hao::	
	移动(157, 94)	
	转向(1)	
	等待到指定地图("艾夏岛")	
	移动(106,121)
	转向(2)	
	等待服务器返回()
	对话选择("4","", "")
	等待服务器返回()
	对话选择("1","", "")
	等待到指定地图("回忆之间")
	移动(8,8)	
::hao2::
	if(取当前地图名() ~= "回忆之间")then 
		goto begin
	end	
	转向(0)
	等待服务器返回()	
	对话选择(4, 0)
	等待服务器返回()
	对话选择(1, 0)	
	等待(2000)
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(是否战斗中())then
		等待战斗结束()
		count=count+1
		local playerinfo = 人物信息()
		local nowTime = os.time() 		
		local time = math.floor((nowTime - beginTime)/60)--已持续练级时间
		if(time == 0)then
			time=1
		end	
		local getVal=prestigeVal*count
		local content = "咬花(李贝留斯逃跑)脚本,已刷次数【"..count.."/"..target.."】,获得声望【"..getVal.."】,共耗时"..time.."分钟"					
		if(count%10 == 0)then
			日志(content)	
		end
	end  
	goto hao2 

::ting::
	if(是否空闲中()) then goto huibu end
	goto ting 

::huibu::
	等待空闲()
	回城()
	等待到指定地图("艾尔莎岛")
	等待(2000)	
	转向(1)
	等待服务器返回()
	对话选择(4, 0)
	
	等待到指定地图("里谢里雅堡")
	移动(30,82)
	移动(30,90)
	移动(34,90)
	移动(34,88)
	回复(2)	
	goto begin 
end
main()