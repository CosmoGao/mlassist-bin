★队伍人数小于2逃跑（有些地图懒得打直接逃跑）,没有用table来判断地图和调用函数，普通人能看懂方式

common=require("common")

设置("timer",0)
local 队长名称=用户输入框("队长名称","￠夏梦￡雨￠")

日志("队长名称:"..队长名称,1)

local 是否队长=false		--是否队长
if(人物("名称") == 队长名称)then
	是否队长=true
end
local 队伍人数=用户下拉框("队伍人数",{1,2,3,4,5})
local 卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶|口袋龙的卡片|地狱看门犬的卡片"		--可以增加多个 不影响速度


local 步骤=1
清除系统消息()
function checkTeammateItem(chatMsg)
	if(chatMsg==nil)then return end
	local teamPlayers = 队伍信息()
	local teammateCount = common.getTableSize(teamPlayers)
	local count=0
::begin::	
	for index,teamPlayer in ipairs(teamPlayers) do
		if(string.find(聊天(50),teamPlayer.name..": "..chatMsg)~=nil)then 
			count=count+1
		end			
	end  
	if(count>=(teammateCount-1))then
		return
	end		
	count=0
	goto begin
	
end
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


function checkSupply()
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
	local 当前地图名 = 取当前地图名()
	mapNum = 取当前地图编号()
	if (当前地图名 =="艾尔莎岛" )then goto togle
	elseif(当前地图名 ==  "里谢里雅堡")then goto togle 
	elseif(当前地图名 ==  "哥拉尔镇")then goto map43100 
	elseif(当前地图名 ==  "法兰城")then goto togle 			
	elseif(当前地图名 ==  "库鲁克斯岛")then goto map43000 					
	elseif(当前地图名 ==  "米诺基亚镇")then goto map43500				
	elseif(当前地图名 ==  "食堂")then goto map46017				
	elseif(mapNum ==  43200)then 		--白之宫殿
		goto map43200
	elseif(mapNum ==  43210)then 		--白之宫殿
		goto map43210 	
	elseif(mapNum ==  43510)then 		--米村 医院
		goto map43510 		
	elseif(mapNum ==  43570)then 		--民家
		goto map43570 			
	elseif(mapNum ==  46016)then 		--艾儿卡丝之家
		goto map46016	
	elseif(mapNum ==  46017)then 		--艾儿卡丝之家
		goto map46017
	elseif(mapNum ==  46018)then 		--艾儿卡丝之家 2楼
		goto map46018	
	elseif(mapNum ==  46019)then 		--艾儿卡丝之家
		goto map46019
	elseif(mapNum ==  46020)then 		--艾儿卡丝之家
		goto map46020
	elseif(mapNum ==  46021)then 		--艾儿卡丝之家 2楼
		goto map46021		
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
	elseif(mapNum ==  48008)then 		--贝尼恰斯火山 地下10楼
		goto map48008	
	elseif(mapNum ==  48011)then 		--贝尼恰斯火山 最下层
		goto map48011
	end		
	--回城()
	等待(2000)
	goto begin
::togle::
	执行脚本("./脚本/直通车/★公交车-法兰To哥拉尔.lua")
	等待到指定地图("哥拉尔镇")
	goto begin
::map43000::									--库鲁克斯岛
	
	if(取物品数量("红龙诺利的鳞片") > 0) then	
		移动(511,843,"米诺基亚镇")	
	elseif(取物品数量("牺牲品之指轮") > 0) then		
		if(取物品数量("古代的研钵") > 0) then	
			if(是否目标附近(609,774,10))then	--出来以后 可以在这加组队 我这还是逃跑回去吧
				if(checkSupply())then
					移动(511,843,"米诺基亚镇")	
				end
			end			
			if(目标是否可达(546,635))then
				移动(546,635,"贝尼恰斯火山地下1楼")
				goto map48000
			else
				移动(530,706)	
				对话选是(530,705)	
			end		
		elseif(取物品数量("赛米列的记事纸条") > 0) then	
			if(目标是否可达(546,656))then		--出火山
				移动(546,656)	
			elseif(是否目标附近(609,774,10))then
				移动(609,775,"库鲁克斯岛")
				对话选是(609,774)	
			else								--回村补给 去打白银骑士
				移动(511,843,"米诺基亚镇")					
			end	
		else
			--没判断是否在哥拉尔那边
			if(目标是否可达(546,635))then
				移动(546,635,"贝尼恰斯火山地下1楼")
				goto map48000
			else
				移动(530,706)	
				对话选是(530,705)	
			end			
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
::map48007::							--1级烟罗
	移动(20,46,"贝尼恰斯火山 地下10楼")
::map48008::							--贝尼恰斯火山 地下10楼
	移动(24,47,"贝尼恰斯火山 最下层")
::map48011::
	移动(77,38)
	移动(75,38)
	移动(77,38)
	对话选是(76,37)	
	if(取物品数量("赛米列的秘药") > 0) then
		对话选是(78,38)	
		等待到指定地图("归途",20,20)		--打 出来在这
		等待到指定地图("库鲁克斯岛",530,706)	--不打 直接出火山
	end
	等待到指定地图("库鲁克斯岛",546,636)
	--需要组队 在这里组队
	--移动(546,656)	--出火山
	goto begin
::map48025::							--归途
		--组队
	移动(14,14)
	对话选是(14,13)	
	
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
	elseif(目标是否可达(44,40))then
		移动(44,40,"贝尼恰斯火山1楼")
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
	if(取物品数量("古代的研钵") > 0)then	--刷百年草
		--带160哥布林 无压力 单刷  
		if(取物品数量("百年草") < 1)then
			移动(64,31)
			设置("无一级逃跑",1)	--打开无1级逃跑
			设置("队人数小于逃跑",0)	--打开无1级逃跑
			开始遇敌()
			while (取物品数量("百年草") < 1)do		--补血自己设置好
				等待(3000)
			end
			停止遇敌()
			设置("无一级逃跑",0)	--关闭无1级逃跑
			设置("队人数小于逃跑",1)	--打开无1级逃跑
		else
			if(目标是否可达(60,32))then
				移动(60,32)
				对话选是(4)
			elseif(目标是否可达(55,46))then
				移动(55,46,"贝尼恰斯火山6楼")
			end
		end
	else
		if(目标是否可达(60,32))then
			移动(60,32)
			对话选是(4)
		elseif(目标是否可达(55,46))then
			移动(55,46,"贝尼恰斯火山6楼")
		end
	end

	goto begin
::map43100::					--哥拉尔镇
	if(checkSupply())then
		移动(165,91,"医院")
		移动(29,26)	
		回复(30,26)
		移动(9,23,"哥拉尔镇")		
	end	
	--白之宫殿
	if(是否目标附近(120,107,10))then
		移动(120,107)
		转向(0)		-- 转向北	
		等待到指定地图("哥拉尔镇",118,214)
	end	
	移动(140, 214,"白之宫殿")	
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
	移动( 10, 12,"村长之家")	
::map43540::
	移动( 20, 24,"米诺基亚镇")
::map43500::								--米诺基亚镇
	if(取物品数量("阿萨姆的介绍信") > 0) then	
		米村回补判断()
		移动(144,114,"库鲁克斯岛")
		移动(609,775,"库鲁克斯岛")
		对话选是(609,774)	
	elseif(取物品数量("古代的研钵") > 0) then	
		米村回补判断()
		移动(144,114,"库鲁克斯岛")
		--移动(530,706)	
		--对话选是(530,705)	
	elseif(取物品数量("赛米列的记事纸条") > 0) then	
		米村回补判断()
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
	if(checkTitle("龙之拯救者"))then
		日志("已获得【龙之拯救者】称号，任务完成",1)
		return
	end
	移动(10,15,"米诺基亚镇")	
	移动(91,87,"水精灵酒吧")
	goto begin
::map43530::				--水精灵酒吧
	移动(21,11)
	对话选是(22,10)
	移动(10,24,"米诺基亚镇")	
	goto begin
::map46016::				--艾儿卡丝之家
	if(取物品数量("赛米列的记事纸条") > 0) then		--去2楼 干白银团长
		if(目标是否可达(13,32))then
			移动(13,32)	
			对话选是(14,32)
		elseif(目标是否可达(17,34))then
			移动(17,34,"艾儿卡丝之家 地下1楼")	
		elseif(目标是否可达(28,24))then
			移动(28,24,"艾儿卡丝之家 2楼")
		end		
	else
		移动(24,2,"食堂")
	end
	goto begin		
::map46017::				--食堂
	移动(6,4)
	对话选是(6,3)	
	if(取物品数量("牺牲品之指轮") > 0) then
		移动(14,18,"艾儿卡丝之家")	
		移动(20,38,"库鲁克斯岛")	
	end
	goto begin
::map46018::				--艾儿卡丝之家 2楼
	if(是否队长) then		
		if(队伍("人数")>=队伍人数) then		
			if(目标是否可达(7,30))then
				移动(7,30,"艾儿卡丝之家")
				移动(17,34,"艾儿卡丝之家 地下1楼")
				移动(28,38,"艾儿卡丝之家 地下2楼")
			elseif(目标是否可达(23,16))then
				移动(22,14)					
				移动(22,16)			
				移动(22,14)	
				对话选是(23,15)		--本次会打白银骑士  选否 下个龙任务打百合
				等待(10000)			--等队友对话
				移动(15,20)
				对话选是(14,21)
				等待到指定地图("艾儿卡丝之家 2楼",15,21)
			end	
		else
			common.makeTeam(队伍人数)
		end		
	else
		common.joinTeam(队长名称)
		while 队伍("人数") > 1 do		--循环 等解散队伍时候 判断下一步
			if(是否目标附近(23,15))then
				对话选是(23,15)	
			end
			等待(5000)
		end
		goto begin
	end				
	goto begin
::map46019::
	if(目标是否可达(28,38))then
		移动(28,38,"艾儿卡丝之家 地下2楼")
	elseif(目标是否可达(48,3))then
		移动(48,3,"艾儿卡丝之家 地下2楼")
	elseif(目标是否可达(33,45))then
		移动(33,45,"艾儿卡丝之家")
	end		
	goto begin	
::map46020::
	if(目标是否可达(8,5))then
		移动(8,5,"艾儿卡丝之家 地下1楼")
	elseif(目标是否可达(48,3))then
		移动(56,40,"艾儿卡丝之家 地下1楼")
	end		
	goto begin
::map46021::					--艾儿卡丝之家 2楼  打赢	
	移动(15,21)
	对话选是(14,21)
	等待到指定地图("库鲁克斯岛",609,775)	--回村补个血去  不组队 还是单独跑了
	移动(511,843,"米诺基亚镇")	
	goto begin				
end	

function 米村回补判断()
	if(checkSupply())then
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