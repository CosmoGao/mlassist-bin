★自己设置抓宠，默认检测的是特别封印卡，需要改判断的，去抓捕点改

common=require("common")

设置("timer",0)

local 卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶|口袋龙的卡片|地狱看门犬的卡片"		--可以增加多个 不影响速度

local 人补血=用户输入框( "人补血", "0")
local 人补魔=用户输入框( "人补魔", "50")
local 宠补血=用户输入框( "宠补血", "0")	
local 宠补魔=用户输入框( "宠补魔", "50")

local 自动换水火的水晶耐久值 = 用户输入框("自动换水晶耐久值", "30")
local 封印卡数量=40
local 封印卡名称="封印卡（特别）"
设置("自动叠",1,封印卡名称.."&20")

清除系统消息()

--魔鬼克星
function checkTitle(dstTitle)
	local player=人物信息()
	for i,title in ipairs(player.titles) do
		if(title.name == dstTitle)then
			return true
		end
	end
	return false
end

function logbackG()
	当前地图名 = 取当前地图名()
	x,y=取当前坐标()		
	if (当前地图名=="哥拉尔镇" and x==120 )then return end			
	回城()	
	等待(3000)
end

function healPlayer()
	if( 人物("健康") > 0  or 宠物("健康") > 0)then
		logbackG()
		日志("人物受伤")
		移动(165,91,"医院")
		移动(29,15)
		转向(2)
		等待服务器返回()
		对话选择(-1,6)
		移动(29,26)
		回复(30,26)
		logbackG()
	end      
end
function checkSupply()
	local needSupply = false
	if(人物("血") < 人物("最大血") or 人物("魔") < 人物("最大魔")) then
		needSupply=true
	end
	if(宠物("血") < 宠物("最大血") or 宠物("魔") < 宠物("最大魔")) then
		needSupply=true
	end
	if(needSupply == false)then
		return
	end
	if (取当前地图名()~="哥拉尔镇" )then logbackG() end			
	移动(165,91,"医院")
	移动(29,26)	
	回复(30,26)
	logbackG()
end
function recallSoul()
	if( 人物("灵魂") > 0 )then
		日志("触发登出补给:人物掉魂")
		logbackG()
		转向(0)
		等待(1000)
		移动(140,214,"白之宫殿")
		移动(47, 36, 43210)
		移动(61, 46)
		对话选是(2)
		等待(1000)
		logbackG()
	end
end

function healPlayer()
	if( 人物("健康") > 0  or 宠物("健康") > 0)then
		logbackG()
		日志("人物受伤")
		移动(165,91,"医院")
		移动(29,15)
		转向(2)
		等待服务器返回()
		对话选择(-1,6)
		移动(29,26)
		回复(30,26)
		logbackG()
	end      

end

function buyCrystal(crystalName,buyCount)
	喊话("买水晶")
	if(buyCount==nil) then buyCount=1 end
	if(crystalName == nil)then  crystalName = "水火的水晶（5：5）" end
	if(取包裹空格() < 1) then
		回城()
		移动(147,79,"杂货店")
		移动(11,18)
		卖(0,卖店物品列表)			
		移动(18,30,"哥拉尔镇")
	end
	if(取包裹空格() < 1) then
		日志("背包没有空格，买水晶中断！")
		回城()	
		return
	end
	if(取包裹空格() < buyCount) then
		日志("背包空格数量不够，买水晶中断！")
		回城()	
		return
	end
	
	移动(146,117,"魔法店")	
	移动(18,12)
	等待(1000)
	转向(2)
	等待服务器返回()
	对话选择(0,0) --第二个参数0 0买 1卖 2不用了
	local dlg = 等待服务器返回()
	local buyData = 解析购买列表(dlg.message)
	local itemList = buyData.items
	local dstItem = nil
	for i,item in ipairs(itemList)do
		if( item.name == crystalName) then
			dstItem={index=i-1,count=buyCount}			
		end
	end
	if (dstItem ~= nil)then
		买(dstItem.index,dstItem.count)
		等待(1000)
		return true
	else
		日志("购买水晶失败！")
		return false
	end
	return false
end
function checkCrystal(crystalName,equipsProtectValue)
	if(equipsProtectValue==nil)then equipsProtectValue =100 end
	if(crystalName == nil)then  crystalName = "水火的水晶（5：5）" end
	local itemList = 物品信息()
	local crystal = nil
	for i,item in ipairs(itemList)do
		if(item.pos == 7)then
			crystal = item
			break
		end
	end
	--当前水晶不需要更换
	--喊话(crystal.name.."耐久"..crystal.durability.."设置值"..equipsProtectValue)
	if(crystal~=nil and crystal.name == crystalName and crystal.durability > equipsProtectValue) then
		return
	end
	crystal=nil
	--需要更换 检查身上是否有备用水晶
	for i,item in ipairs(itemList)do
		if(item.name == crystalName and item.durability > equipsProtectValue)then
			crystal = item
			break
		end
	end

	if(crystal~=nil ) then
		交换物品(crystal.pos,7,-1)
		return
	end
	logbackG()	
	--买水晶
	buyCrystal(crystalName)
	扔(7)--扔旧的
	等待(1000)	--等待刷新
	使用物品(crystalName)
    logbackG()	
end

function checkHealth()
	local health = 人物("健康")
	local petinfo = 宠物信息()
	if( 人物("健康") > 0 or 人物("灵魂") > 0 or 宠物("健康") > 0)then
		--登出 去治疗 招魂		
		recallSoul()	
		healPlayer()		
	end           
end

function checkGold()
	if(人物("金币") < 50000)then		
		logbackG()
		移动(167,66,"银行")
		移动(25,10)
		转向(2)
		等待(2000)		
		日志("银行现有【"..银行("金币").."】金币",1)
		银行("取钱",100000)			
	end

end
function checkNeedSupply()
	local needSupply = false
	if(人物("血") < 人物("最大血") or 人物("魔") < 人物("最大魔")) then
		needSupply=true
	end
	if(宠物("血") < 宠物("最大血") or 宠物("魔") < 宠物("最大魔")) then
		needSupply=true
	end
	return needSupply
end
function main()
	停止遇敌()	
	if(checkTitle("魔鬼克星")==false)then
		日志("未完成帕鲁凯斯亡灵任务，请先完成帕鲁凯斯亡灵任务，再执行此脚本",1)
		return
	end
::begin::	
	等待空闲()	
	if (人物("宠物数量") >= 5 )then	
		日志("宠物满了，去银行存货！")
		移动(167,66,"银行")
		移动(25,10)
		转向(2)
		allPets = 全部宠物信息()		
		--除了作战宠物 其余全存
		for i,pet in ipairs(allPets) do
			if(pet.battle_flags~=2)then	
				银行("存宠",pet.index)
				等待(2000)
			end
		end		
		allPets = 全部宠物信息()	
		for i,pet in ipairs(allPets) do
			if(pet.battle_flags~=2)then	
				银行("存宠",pet.index)			
			end
		end	
		if (人物("宠物数量") >= 5 )then	
			日志("银行宠物也满啦！请先清理，再重新执行脚本！")
			return
		end
	end
	local 当前地图名 = 取当前地图名()
	mapNum = 取当前地图编号()		
	if (当前地图名 =="艾尔莎岛" )then goto togle
	elseif(当前地图名 ==  "里谢里雅堡")then goto togle 
	elseif(当前地图名 ==  "哥拉尔镇")then goto map43100 
	elseif(当前地图名 ==  "法兰城")then goto togle 			
	elseif(当前地图名 ==  "库鲁克斯岛")then goto map43000 					
	elseif(当前地图名 ==  "米诺基亚镇")then goto map43500				
	elseif(当前地图名 ==  "食堂")then goto map46017				
	elseif(mapNum ==  43125)then 		--哥拉尔银行
		goto map43125	
	elseif(mapNum ==  43110)then 		--哥拉尔医院
		goto map43110
	elseif(mapNum ==  43200)then 		--白之宫殿
		goto map43200
	elseif(mapNum ==  43210)then 		--白之宫殿
		goto map43210 	
	elseif(mapNum ==  43510)then 		--米村 医院
		goto map43510 
	elseif(mapNum ==  43541)then 		--米村 村长之家2楼
		goto map43541 			
	elseif(mapNum ==  46016)then 		--艾儿卡丝之家
		goto map46016	
	elseif(mapNum ==  46017)then 		--艾儿卡丝之家
		goto map46017	
	elseif(mapNum ==  43530)then 		--水精灵酒吧
		goto map43530	
	elseif(mapNum ==  48000)then 		--水精灵酒吧
		goto map48000
	elseif(mapNum ==  48014)then 		--水精灵酒吧
		goto map48014
	elseif(mapNum ==  48015)then 		--贝尼恰斯火山1楼
		goto map48015	
	elseif(mapNum ==  48016)then 		--贝尼恰斯火山2楼
		goto map48016
	elseif(mapNum ==  48017)then 		--贝尼恰斯火山3楼
		goto map48017
	elseif(mapNum ==  48018)then 		--贝尼恰斯火山
		goto map48018	
	elseif(mapNum ==  48019)then 		--贝尼恰斯火山4楼
		goto map48019
	elseif(mapNum ==  48020)then 		--贝尼恰斯火山4楼
		goto map48020
	elseif(mapNum ==  48021)then 		--贝尼恰斯火山4楼
		goto map48021
	elseif(mapNum ==  48022)then 		--贝尼恰斯火山4楼
		goto map48022
	elseif(mapNum ==  48023)then 		--贝尼恰斯火山4楼
		goto map48023
	elseif(mapNum ==  44000)then 		--贝尼恰斯火山 地下2楼
		goto map44000
	elseif(mapNum ==  48001)then 		--贝尼恰斯火山地下3楼
		goto map48001
	elseif(mapNum ==  48002)then 		--贝尼恰斯火山地下4楼
		goto map48002
	elseif(mapNum ==  48003)then 		--贝尼恰斯火山地下5楼
		goto map48003
	elseif(mapNum ==  48004)then 		--贝尼恰斯火山地下6楼
		goto map48004	
	elseif(mapNum ==  48005)then 		--贝尼恰斯火山地下7楼
		goto map48005
	elseif(mapNum ==  48006)then 		--贝尼恰斯火山地下8楼
		goto map48006
	elseif(mapNum ==  48007)then 		--贝尼恰斯火山地下9楼
		goto map48007	
	end		
	--回城()
	等待(2000)
	goto begin
::togle::
	执行脚本("./脚本/直通车/★公交车-法兰To哥拉尔.lua")
	等待到指定地图("哥拉尔镇")
	goto begin
::map43000::				--库鲁克斯岛
	if(取物品数量("牺牲品之指轮") > 0) then
		--没判断是否在哥拉尔那边
		if(目标是否可达(546,635))then
			移动(546,635,"贝尼恰斯火山地下1楼")
			goto map48000
		else
			移动(530,706)	
			对话选是(530,705)	
		end	
		
	elseif(取物品数量("阿萨姆的介绍信") > 0) then	
		移动(609,775,"库鲁克斯岛")
		对话选是(609,774)	
	end
	goto begin
::map44000::					--贝尼恰斯火山 地下2楼
	移动(99,40,"贝尼恰斯火山地下3楼")
::map48001::					--贝尼恰斯火山地下3楼
	移动(56,37,"贝尼恰斯火山地下4楼")
::map48002::
	移动(51,52,"贝尼恰斯火山地下5楼")
::map48003::
	移动(55,50,"贝尼恰斯火山地下6楼")
::map48004::
	移动(56,70,"贝尼恰斯火山地下7楼")
::map48005::
	移动(58,57,"贝尼恰斯火山地下8楼")
::map48006::
	移动(30,49,"贝尼恰斯火山地下9楼")
::map48007::
	移动(30,56)
	开始遇敌()		--烟罗
::scriptLoop::
	if(人物("魔") < 人补魔) then
		日志(人物("魔").."魔小于")
		goto  ting
	end		-- 魔小于100
	if(人物("血") < 人补血) then 
		日志(人物("血").."血小于")
		goto  ting 
	end
	if(宠物("血") < 宠补血) then 
		日志(宠物("血").."宠物血小于")
		goto  ting 
	end
	if(宠物("魔") < 宠补魔) then 
		日志(宠物("魔").."宠物魔小于")
		goto  ting 
	end
	if(取物品叠加数量(封印卡名称) < 1)then 
		日志(取物品叠加数量(封印卡名称).."封印卡小于")
		goto  ting 
	end
	if (人物("宠物数量") >= 5 )then	
		日志("宠物数量满了，回城存储！")
		goto ting	
	end
	if( 人物("灵魂") > 0 )then
		goto  ting 
	end
	等待(3000)
	goto scriptLoop 					
::ting::
	停止遇敌()
	等待空闲()
	回城()     
	goto begin 
	
	
::map48000::					--贝尼恰斯火山地下1楼	
	if(目标是否可达(46,4))then
		移动(46,4,"贝尼恰斯火山1楼")
	elseif(目标是否可达(12,4))then
		移动(12,4,"贝尼恰斯火山 地下2楼")
	end
	goto begin
::map48014::					--贝尼恰斯火山1楼	
	if(目标是否可达(39,38))then
		移动(39,38,"贝尼恰斯火山")
	elseif(目标是否可达(23,39))then
		移动(23,39,"贝尼恰斯火山地下1楼")
	end
	goto begin
	
::map48015::					--贝尼恰斯火山
	移动(30,61,"贝尼恰斯火山2楼")
::map48016::					--贝尼恰斯火山2楼	
	if(目标是否可达(50,24))then
		移动(50,24,"贝尼恰斯火山3楼")
	elseif(目标是否可达(59,44))then
		移动(59,44)
		开始遇敌()
		goto scriptLoop
	end
	goto begin	
::map48017::					--贝尼恰斯火山3楼
	if(目标是否可达(84,75))then
		移动(84,75,"贝尼恰斯火山")
	elseif(目标是否可达(46,47))then
		移动(46,47,"贝尼恰斯火山3楼")
	end
	goto begin	
::map48018::	
	if(目标是否可达(42,49))then
		移动(42,49,"贝尼恰斯火山4楼")
	elseif(目标是否可达(46,47))then
		移动(46,47,"贝尼恰斯火山2楼")
	end
	goto begin
	
::map48019::					--贝尼恰斯火山4楼
	if(目标是否可达(45,26))then
		移动(45,26,"贝尼恰斯火山5楼")
	elseif(目标是否可达(56,75))then
		移动(56,75,"贝尼恰斯火山5楼")
	elseif(目标是否可达(44,44))then
		移动(44,44,"贝尼恰斯火山3楼")
	end
	goto begin
::map48020::					--贝尼恰斯火山5楼
	if(目标是否可达(42,10))then
		移动(42,10,"贝尼恰斯火山4楼")
	elseif(目标是否可达(57,80))then
		移动(57,80,"贝尼恰斯火山")
	elseif(目标是否可达(43,47))then
		移动(43,47,"贝尼恰斯火山4楼")
	end
	goto begin
::map48021::					--贝尼恰斯火山
	移动(66,61,"贝尼恰斯火山6楼")
	goto begin
::map48022::					--贝尼恰斯火山6楼	
	if(目标是否可达(47,36))then
		移动(47,36,"贝尼恰斯山顶上")
	elseif(目标是否可达(42,48))then
		移动(42,48,"贝尼恰斯火山5楼")
	end
	goto begin
::map48023::					--贝尼恰斯山顶上
	if(目标是否可达(60,32))then
		移动(60,32)
		对话选是(4)
	elseif(目标是否可达(55,46))then
		移动(55,46,"贝尼恰斯火山6楼")
	end
	goto begin
::map43100::					--哥拉尔镇	
	checkHealth()
	checkSupply()
	checkGold()
	if(人物("金币") < 50000)then	
		日志("没钱了，脚本退出",1)
		return
	end
	
	--白之宫殿
	if(是否目标附近(120,107,10))then
		移动(120,107)
		转向(0)		-- 转向北	
		等待到指定地图("哥拉尔镇",118,214)
	end	
	移动(140, 214,"白之宫殿")	
	goto map43200
::map43125::
	移动(11,12,"哥拉尔镇")
	goto begin
::map43110::					--哥拉尔医院
	移动(165,91,"医院")
	移动(29,15)
	转向(2)
	等待服务器返回()
	对话选择(-1,6)
	移动(29,26)
	回复(30,26)
	移动(9,22,"哥拉尔镇")
	goto begin
::map43200::
	移动(47, 36,43210)	
::map43210::
	移动(23, 70,"启程之间")
	移动(11, 7)	
	转向(2)
	dlg=等待服务器返回()
	if(dlg.message~=nil and (string.find(dlg.message,"此传送点的资格")~=nil or string.find(dlg.message,"不能使用这个传送石")~=nil))then	
		移动(9,16,"43210")
		移动(9,46,"43200")
		移动(41,22,"哥拉尔镇")	
		移动(165,91,"医院")
		移动(29,26)	
		回复(30,26)
		移动(9,23,"哥拉尔镇")		
		移动(176,105,"库鲁克斯岛")			
		移动(476,526)
		对话选是(477,526)
		移动(315,822,"伊利斯矿山 地下1楼")
		移动(41,7,"伊利斯矿山入口 大坑道")
		移动(188,12,"伊利斯矿山 地下1楼")
		移动(85,93,"库鲁克斯岛")		
		移动(431,824,"米诺基亚镇")		
		移动(68,118,"村长之家")		
		移动(6,12,"村长之家2楼")	
		移动(19,14)			
		转向(2)
		转向(2)
	end
	对话选择("4", "", "")	
::map43541::
	等待到指定地图("村长之家2楼")	
	if(取物品叠加数量(封印卡名称) < 封印卡数量)then		--2组卡
		移动(23, 7)		
		转向(7)             
		等待服务器返回()		
		对话选择(0, 0)
		等待服务器返回()
		买(2,封印卡数量-取物品叠加数量(封印卡名称))        
		等待服务器返回()	
	end	
	移动( 10, 12,"村长之家")	
::map43540::
	移动( 20, 24,"米诺基亚镇")
::map43500::		
	if(取物品数量("阿萨姆的介绍信") > 0) then	
		if(checkNeedSupply())then
			移动(45,87,"医院")
			移动(11, 8)
			回复(2)
			移动(10,19,"米诺基亚镇")
		end
		移动(144,114,"库鲁克斯岛")
		移动(609,775,"库鲁克斯岛")
		对话选是(609,774)	
	elseif(取物品数量("牺牲品之指轮") > 0) then	
		米村回补判断()
		移动(144,114,"库鲁克斯岛")		
	else
		移动(68,88,"民家")
		goto map43570
	end	
	goto begin
::map43510::				--医院
	移动(11, 8)
	回复(2)
	移动(11, 6)				--治伤
	转向坐标(11,5)
	等待服务器返回()
	对话选择(-1,6)
	移动(10,19,"米诺基亚镇")
	goto begin
::map43570::				--民家
	移动(8,6)
	对话选是(8,5)	
	移动(10,15,"米诺基亚镇")	
	移动(91,87,"水精灵酒吧")
	goto begin
::map43530::				--水精灵酒吧
	移动(21,11)
	对话选是(22,10)
	移动(10,24,"米诺基亚镇")	
	goto begin
::map46016::				--艾儿卡丝之家
	移动(24,2,"食堂")	
::map46017::				--食堂
	移动(6,4)
	对话选是(6,3)	
	if(取物品数量("牺牲品之指轮") > 0) then
		移动(14,18,"艾儿卡丝之家")	
		移动(20,38,"库鲁克斯岛")	
	end
	goto begin
end	
function 米村回补判断()
	if(checkNeedSupply())then
		移动(45,87,"医院")
		移动(11, 8)
		回复(2)
		移动(11, 6)		--治伤
		转向坐标(11,5)
		等待服务器返回()
		对话选择(-1,6)
		移动(10,19,"米诺基亚镇")
	end
end
main()