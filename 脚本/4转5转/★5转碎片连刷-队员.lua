★5洞连刷5转碎片脚本，加入自动组队功能

common=require("common")

清除系统消息()
    	

走路加速值=125	--脚本走路中可以设定移动速度  到达目的地后，再还原值即可
走路还原值=100	--防止掉线 还原速度
卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"		--可以增加多个 不影响速度

队长名称=取脚本界面数据("队长名称")
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","乱￠逍遥")--风依旧￠花依然  乱￠逍遥
end
当前刷碎片属性=nil		--地水火风
刷碎片数量=用户输入框("刷碎片数量","20")	--默认刷20个
--获取队长当前服务器线路
身上最少金币数=50000	--身上最少5万  判断会用这个判断 取得话 会用这个的2倍取 防止来回判断
多少金币去拿钱=10000

function getLeaderServerLine()
	local 队长名片 = 取好友名片(队长名称)
	if( 队长名片 ~= nil)then
		return 队长名片.server
	end
	return 0
end
function followLeader()
	local leaderServerLine = getLeaderServerLine()
	if(leaderServerLine==0)then
		return
	end
	local curLine=人物("几线")
	if(curLine == 0)then
		return
	end
	if(leaderServerLine ~= curLine)then
		切换登录信息("",0,leaderServerLine,0) --0默认 
		登出服务器()	
		登录游戏()	--如果有自动登录 这步不需要
	end
end
function 判断队长()
	local teamPlayers=队伍信息()
	local count=0
	for i,teammate in ipairs(teamPlayers)do
		count=count+1
		日志(i..teammate.name .."队长名称："..队长名称)
		if( i==1 and teammate.name ~= 队长名称) then	
			日志(i..teammate.name .."!- 队长名称："..队长名称)
			return false
		else
			break
		end
	end
	if count ==0 then
		日志("数据有误，获取到队伍人数为0",1)
		return false
	else
		return true
	end
end

function waitAddTeam()
	local tryNum=0
::begin::	
	加入队伍(队长名称)
	if(取队伍人数()>1)then
		if(判断队长()==true) then
			return
		else
			离开队伍()
		end		
	end
	if(是否空闲中()==false)then
		return
	end
	if(tryNum>10)then
		return
	end
	goto begin
end
function 营地商店检测水晶(crystalName,equipsProtectValue,buyCount)
	if(equipsProtectValue==nil)then equipsProtectValue =100 end
	if(crystalName == nil)then crystalName="水火的水晶（5：5）" end
	if(buyCount==nil) then buyCount=1 end
	--检测水晶
	local itemList = 物品信息()
	local crystal = nil
	for i,item in ipairs(itemList)do
		if(item.pos == 7)then
			crystal = item
			break
		end
	end
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
	--买水晶
	local 当前地图名 = 取当前地图名()
	if(当前地图名 == "商店")then 
		自动寻路(14,26)
	elseif(当前地图名 == "圣骑士营地")then 
		自动寻路(92, 118,"商店")
		自动寻路(14,26)
	else
		return
	end
	转向(2)
	等待服务器返回()
	common.buyDstItem(crystalName,1)
	扔(7)--扔旧的
	等待(1000)	--等待刷新
	使用物品(crystalName)	
	自动寻路(0,14,"圣骑士营地")	
end

function 营地存取金币(金额,存取)
	if(金额==nil) then return end
	local 当前地图名 = 取当前地图名()
	if(当前地图名 == "银行")then 
		自动寻路(27,23)
	elseif(当前地图名 == "圣骑士营地")then 
		自动寻路(116, 105,"银行")
		自动寻路(27,23)
	else
		return
	end
	转向(2)
	等待服务器返回()
	if(存取==nil or 存取=="存")then
		银行("存钱",金额)	
	else
		银行("取钱",金额)
	end
end

function 五转碎片()
	followLeader()
	checkElement()
	清除系统消息()		
::begin::
	等待空闲()	
	if(取队伍人数() > 1)then
		if(判断队长()==true) then
			goto scriptstart
		else
			日志("判断队长失败,重新执行",1)
			离开队伍()
		end				
	end	
	当前地图名 = 取当前地图名()	
	if (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "工房")then goto gongFang
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "商店")then goto yingDiShangDian
	elseif(当前地图名 ==  "银行")then goto yingDiYinHang
	elseif(当前地图名 ==  "肯吉罗岛")then goto scriptstart end
	回城()
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
	自动寻路( 95, 73)
	自动寻路( 95, 72)
	goto begin 
::quYingDi::
	设置("移动速度",走路加速值)
	common.checkHealth()
	common.checkCrystal(水晶名称)
	common.supplyCastle()
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin
::StartBegin::
	等待到指定地图("医院")
	followLeader()
	--医院里检测掉魂
	if(人物("灵魂") > 0)then--人物("健康") > 0 or
		回城()
		等待(2000)
		goto begin
	end
	--黄白 继续砍怪 其余登出
	if(人物("健康") >= 50) then 
		common.localHealPlayer()	
		if(人物("健康") ~= 0 ) then
			回城()
			等待(2000)
			goto begin
		else
			离开队伍()	--localHealPlayer会进行离队 这里再次调用下
		end		
	end	
   if(取队伍人数() > 1)then
		if(判断队长()==true) then
			goto scriptstart
		else
			离开队伍()
		end				
	end	
	自动寻路(9,14)	
	等待(1000)
	waitAddTeam()
	goto begin   

::huiYingDi::
	自动寻路(551, 332,"圣骑士营地")
	goto begin
               
::scriptstart::	
	当前地图名 = 取当前地图名()
	--卖魔石检测
	if(当前地图名 == "工房")then
		卖(21,23,卖店物品列表)	
	end
	--切换碎片更新
	if(当前地图名 == "医院" ) then
		checkElement()
	end
	--队伍人数检测
	if(取队伍人数() < 2)then
		goto ting
	end
	--宠物受伤检测
	if(当前地图名 == "医院" and 宠物("健康") > 0 and 是否目标附近(7,6,1)==true)then	
		转向坐标(7,6)
		等待服务器返回()
		对话选择(-1,6)		
	end
	--金币满存银行检测
	if(当前地图名 == "圣骑士营地" and 人物("金币") < 身上最少金币数)then
		离开队伍()
		营地存取金币(-身上最少金币数*2,"取")	--取出后 身上总30万
		goto begin
	end
	followLeader()	
	等待(2000)
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
