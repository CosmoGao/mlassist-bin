★起点新城

common=require("common")

设置("timer",0)
local 补魔值=用户输入框( "多少魔以下去补给", "400")
local 补血值=用户输入框( "多少血以下去补给", "400")
local 宠补魔值=用户输入框( "宠多少魔以下去补给", "200")
local 宠补血值=用户输入框( "宠多少血以下去补给", "200")
local 卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"	
local cardName = "封印卡（野兽系)"
local cardCount=60		--一次买多少
设置("自动叠",1,cardName.."&20")
local mapName=""
local mapNum=0
local 是否需要重置任务=true
清除系统消息()
function 重置任务到4()
	回城()
	自动寻路(157,93)
	转向(2)	
	等待到指定地图("艾夏岛")	
	自动寻路(102, 115,"冒险者旅馆")	
	自动寻路(30, 21)	
	转向(0)
	喊话("爱蜜儿",2,3,5)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(1,0)
	喊话("爱蜜儿",2,3,5)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(1,0)	
	回城()
end
function 获取精灵之牙()
	if(取当前地图名() ~= "法兰城遗迹")then return false end
	local tryCount=0
	while tryCount < 3 do
		自动寻路(83,36)
		local dlg = 等待服务器返回()
		if(dlg.dialog_id == 0)then
			tryCount=tryCount+1
		else
			return true
		end
		自动寻路(83,37)
	end	
	return false
end
function main()
	local mapName=""
	local mapNum=0
::begin::  
	等待空闲()
	mapName=取当前地图名()
	mapNum=取当前地图编号()
	if (人物("宠物数量") >= 5 )then	
		日志("宠物满了，去银行存货！")
		common.depositNoBattlePetToBank()
		if (人物("宠物数量") >= 5 )then	
			日志("银行宠物也满啦！请先清理，再重新执行脚本！")
			return
		end
	end
	if(mapName=="艾尔莎岛")then
		goto aiersha
	elseif(mapName=="法兰城遗迹")then
		goto map59510	
	elseif mapNum == 59727 then goto map59727 
	elseif mapNum == 59728 then goto map59728 
	elseif mapNum == 59729 then goto map59729
	elseif mapNum == 59730 then goto map59730		
	elseif mapNum == 59734 then goto map59734
	elseif mapNum == 59537 then goto map59537		--精灵之下宫
	else	
		回城()
	end
	等待(1000)
	goto begin
::aiersha::	
	if(取物品叠加数量(cardName) < cardCount) then
		goto maika
	end
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)		
	if(取物品数量("精灵之牙？") > 0)then
		if(取物品数量("觉醒的文言抄本") < 1)then
			日志("身上没有【觉醒的文言抄本】，请先准备好道具再进行任务")
			--领取抄本
			common.gotoBankRecvTradeItemsAction({topic="觉醒的文言抄本发放员",publish="领取觉醒的文言抄本",itemName="觉醒的文言抄本",itemCount=1,itemPileCount=1})
			goto begin
		end
		回城()
		自动寻路(201,96,"神殿　伽蓝")
		自动寻路(95,80,"神殿　前廊")
		自动寻路(44,41,59531)
		自动寻路(17,33,59537)
		--队长调查任意雕像 才能进入  单人进不去		
		自动寻路(103,65,地之昏神的领域)		--有抄本 	自动寻路(102,66,地之昏神的领域)		
	else
		common.toCastle()
		自动寻路(28,88)
		等待服务器返回()	
		对话选择(32, 0)
		等待服务器返回()	
		对话选择(32, 0)
		等待服务器返回()	
		对话选择(32, 0)
		等待服务器返回()	
		对话选择(32, 0)
		等待服务器返回()
		对话选择(4, 0)
		等待到指定地图("？")	
		自动寻路(19, 20)
		移动一格(4)	
		等待到指定地图("法兰城遗迹")		
	end
	goto begin
::map59510::				--法兰城遗迹
	自动寻路(83,36)
	设置("无一级逃跑",0)
	if(common.等待黄昏或夜晚())then
		if(是否需要重置任务)then
			if(获取精灵之牙()==false)then
				重置任务到4()
				goto begin
			end
			是否需要重置任务=false
		end
		对话选择(1,0)
		等待(2000)
		if(是否战斗中())then
			等待战斗结束()
		end
		if 取物品数量("精灵之牙？") > 0 then			
			回城()
		else
			goto map59510
		end
	end
	goto begin
::map59537::				--精灵之下宫
	if(取物品数量("精灵之牙？") > 0)then
		自动寻路(103,65,地之昏神的领域)		--有抄本 	自动寻路(102,66,地之昏神的领域)		
	elseif(人物("坐标")=="92,76")then
		日志("卵5任务完成")
		if(是否刷逆十字) then
			
			return
		else
			if(去领取改鲨图()==false)then	--得领取逆十字 然后领改鲨 领完再还回去
				return --失败返回
			end
		end
	end
::map59727::				--地之昏神的领域 57 146	
	设置("无一级逃跑",1)
	自动寻路(147,141)	
	等待(1500)
	goto loop
::map59728::				--地之昏神的领域 67 74
	自动寻路(165,80,"59728")
	设置("无一级逃跑",0)
	对话选是(1)				--地使者
	if(是否战斗中())then
		等待战斗结束()
	end
	等待(1500)
	goto begin
::map59734::				--葛拉奇的领域—内宫 38 83
	设置("无一级逃跑",1)
	自动寻路(68,52)
	对话选是(1)		
	goto begin	
::map59729::				--水之昏神的领域 57 146	
	自动寻路(45,95,"59730")	
	等待(1500)
	goto begin
::map59730::				--水之昏神的领域 67 74		--1级红铜怪 167 101
	自动寻路(167,101)	
	等待(1500)
	goto loop
	
::loop::	
	设置("无一级逃跑",1)
	开始遇敌()         
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(取物品叠加数量(cardName) < 1)then goto  ting end
	if (人物("宠物数量") >= 5 )then	
		日志("宠物数量满了，回城存储！")
		goto ting	
	end
	if(取当前地图编号() ~= 59727)then goto ting end
	等待(2000)
	goto scriptstart  	
::ting::
	停止遇敌()
	等待空闲()
	等待(5000)			--如果有血瓶 等吃血瓶
	--二次判断 成功就回城
	if(人物("魔") < 补血值)then goto  backbu end		-- 魔小于100
	if(人物("血") < 补魔值)then goto  backbu end
	if(宠物("血") < 宠补血值)then goto  backbu end
	if(宠物("魔") < 宠补魔值)then goto  backbu end
	if(取物品叠加数量(cardName) < 1)then goto  backbu end	
	if (人物("宠物数量") >= 5 )then	
		日志("宠物数量满了，回城存储！")
		goto backbu	
	end
	if( 人物("健康") > 0 )then
		goto  backbu 
	end	
	if( 人物("灵魂") > 0 )then
		goto  backbu 
	end
	goto begin	
::backbu::	
	回城()     
	goto begin 

::maika::
	自动寻路(144,105)
	自动寻路(157,93)
	转向(2)	
	等待到指定地图("艾夏岛", 1)	
	转向(6)
	等待到指定地图("艾夏岛", 164,159)	
	转向(7)
	等待到指定地图("艾夏岛", 151,97)	
	自动寻路(150, 125,"克罗利的店")
::shop::
	自动寻路(40,23)
	转向(2)
	等待服务器返回()
	nowCount = cardCount-取物品叠加数量(cardName)
	common.buyDstItem(cardName,nowCount)	
::outshop::
	if(取物品叠加数量(cardName) < cardCount) then
		goto shop
	end
	回城()
	goto begin
end 

main()