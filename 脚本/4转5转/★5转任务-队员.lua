★刷5转碎片脚本，加入自动组队功能

common=require("common")

清除系统消息()
    	

local 走路加速值=115	--脚本走路中可以设定移动速度  到达目的地后，再还原值即可
local 走路还原值=100	--防止掉线 还原速度
local 卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"		--可以增加多个 不影响速度

local 队长名称=取脚本界面数据("队长名称")
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","乱￠逍遥")--风依旧￠花依然  乱￠逍遥
end
local 当前刷碎片属性=nil		--地水火风
local 刷碎片数量=用户输入框("刷碎片数量","20")	--默认刷20个
--获取队长当前服务器线路
local 身上最少金币数=50000	--身上最少5万  判断会用这个判断 取得话 会用这个的2倍取 防止来回判断
local 多少金币去拿钱=10000
local 十层等待时间=5000		--毫秒
function 买5斧()  
	if(取物品数量("突进斧") > 0)then		
		return	
	end
	local tryCount=0
	if(取当前地图名() == "装备品店")then 
		goto maifu
	end
	common.toTeleRoom("杰诺瓦镇")
::jnwcf::	
	自动寻路(14, 6,"村长的家")	 
	自动寻路(1, 9,"杰诺瓦镇")
	自动寻路(43, 23,"杂货店")
	自动寻路(9, 6,"装备品店")
::maifu::
	自动寻路(10, 6)
	转向(2)
	等待服务器返回()
	对话选择(0,0)
	等待服务器返回()
	买(1,1)
	等待(2000)
	--common.buyDstItem("突进斧",1)
	if(取物品数量("突进斧") > 0)then
		回城()
		return	
	end
	if(tryCount > 3)then
		return
	end
	tryCount = tryCount+1
	goto maifu
end
	
function 五转碎片()
	common.changeLineFollowLeader(队长名称)	
	checkElementBoss()
	清除系统消息()	
	--买5斧()  	
::begin::
	等待空闲()	
	if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			日志("判断队长失败,重新执行",1)
			离开队伍()
		end				
	end	
	当前地图名 = 取当前地图名()	
	if (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "装备品店")then 买5斧()   
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "工房")then goto gongFang
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "商店")then goto yingDiShangDian
	elseif(当前地图名 ==  "银行")then goto yingDiYinHang
	elseif (string.find(当前地图名,"隐秘之洞")~= nil )then goto scriptstart
	elseif(当前地图名 ==  "肯吉罗岛")then goto scriptstart end
	--回城()
	等待(1000)
	goto begin
::yingDiShangDian::
	营地商店检测水晶()
	自动寻路(0,14,"圣骑士营地")	
	goto begin
::yingDiYinHang::
	自动寻路(3,23,"圣骑士营地")	
	goto begin
::gongFang::
	自动寻路( 30, 37)
    等待到指定地图("圣骑士营地",87,72)     
	goto begin
::quYiYuan::
	换水晶()
	checkElementBoss()
	自动寻路( 95, 73)
	自动寻路( 95, 72)
	goto begin 
::quYingDi::
	设置("移动速度",走路加速值)
	common.checkHealth()
	common.checkCrystal(水晶名称)
	common.supplyCastle()
	common.sellCastle()
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin
::StartBegin::
	等待到指定地图("医院")
	取下装备("突进斧")
	common.changeLineFollowLeader(队长名称)	
   if(取队伍人数() > 1)then
		if(common.judgeTeamLeader(队长名称)==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end	
	自动寻路(9,14)	
	等待(1000)
	common.joinTeam(队长名称)
	goto begin   

::huiYingDi::
	自动寻路(551, 332,"圣骑士营地")
	goto begin               
::scriptstart::	
	当前地图名 = 取当前地图名()
	mapNum=取当前地图编号()
	if(当前地图名 == "工房")then
		卖(21,23,卖店物品列表)	
	end
	if(当前地图名 == "医院" ) then
		checkElementBoss()
	end
	--队伍人数检测
	if(取队伍人数() < 2 and 当前地图名 ~= "隐秘之洞 地下10层" and 当前地图名 ~= "隐秘之洞 最底层")then
		goto ting
	end
	if(当前地图名 == "医院" and 宠物("健康") > 0 and 是否目标附近(7,6,1)==true)then	
		转向坐标(7,6)
		等待服务器返回()
		对话选择(-1,6)		
	end
	if(取当前地图名() == "隐秘之洞 最底层")then
		装备物品("突进斧")	
	end
	if(当前地图名 == "隐秘之洞 地下10层")then
		crossBarrier()
	end
	if(mapNum == 27314)then
		对话选是(4)
	elseif(mapNum == 27308)then
		对话选是(0)
	elseif(mapNum == 27311)then
		对话选是(6)
	elseif(mapNum == 27305)then
		对话选是(2)	
	elseif(mapNum == 27315)then
		对话选是(1)
	end
	common.changeLineFollowLeader(队长名称)		
	等待(1000)
	goto scriptstart  
	
::ting::	
	等待空闲()
	if(取队伍人数() < 2)then	--掉线 回城
		回城()
		等待(2000)
	end
	goto begin
::goEnd::
	return
end
function 换水晶()
	local tryCount=0
::begin::
	if(取物品数量("洛伊夫的护身符") < 1)then
		自动寻路( 99, 84)
		对话选是(100,84)
	end
	if(取物品数量("隐秘的水晶（风）") < 1 and 取物品数量("净化的烈风碎片") < 1)then
		自动寻路( 99, 84)
		对话选是(100,84)
	end
	if(取物品数量("隐秘的水晶（水）") < 1 and 取物品数量("净化的流水碎片") < 1 )then
		自动寻路( 99, 84)
		对话选是(100,84)
	end
	if(取物品数量("隐秘的水晶（火）") < 1 and 取物品数量("净化的火焰碎片") < 1)then
		自动寻路( 99, 84)
		对话选是(100,84)
	end
	if(取物品数量("隐秘的水晶（地）") < 1 and 取物品数量("净化的大地碎片") < 1)then
		自动寻路( 99, 84)
		对话选是(100,84)
	end
	if(tryCount > 2)then
		return
	end
	tryCount = tryCount+1
	goto begin
end
function checkElementBoss()
	local elementList={"地","水","火","风"}
	local titleData=""
	for i,tmpEle in ipairs(elementList) do
		if(取物品数量("隐秘的水晶（"..tmpEle.."）") > 0) then
			titleData=titleData..tmpEle.."打"		
		end
	end
	设置个人简介("玩家称号",titleData)	
end
function crossBarrier()
	if(当前地图名 == "隐秘之洞 地下10层")then		
		等待(十层等待时间)
		使用物品("隐秘的水晶（地）")
		对话选择(1,0)
		等待(2000)
		使用物品("隐秘的水晶（水）")
		对话选择(1,0)	
		等待(2000)
		使用物品("隐秘的水晶（火）")
		对话选择(1,0)
		等待(2000)
		使用物品("隐秘的水晶（风）")
		对话选择(1,0)
		等待(2000)
	end
	common.joinTeam(队长名称)
end
function checkElement()
	local elementList={"地","水","火","风"}
	local titleData=""
	for i,tmpEle in ipairs(elementList) do
		if(取物品叠加数量("隐秘的徽记（"..tmpEle.."）") < 刷碎片数量) then
			titleData=titleData..tmpEle.."缺"
		else
			titleData=titleData..tmpEle.."满"
		end
	end
	设置个人简介("玩家称号",titleData)	
end

五转碎片() 	
