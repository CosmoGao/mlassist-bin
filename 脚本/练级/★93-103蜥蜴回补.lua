::起点::蜥蜴洞穴1层水晶点上方一格，矮人城镇护士处，圣骑士营地入口，圣骑士营地医院内；无视自动更新地图，请设置坐标60S未变重启打勾－

common=require("common")

补血值=取脚本界面数据("人补血")
补魔值=取脚本界面数据("人补魔")
宠补血值=取脚本界面数据("人补血")
宠补魔值=取脚本界面数据("人补血")
队伍人数=取脚本界面数据("队伍人数")
设置队员列表=取脚本界面数据("队员列表")
队员列表={}
是否练宠=取脚本界面数据("是否练宠")
if(补血值==nil or 补血值==0)then
	补血值=用户输入框("多少血以下补血", "430")
end
if(补魔值==nil or 补魔值==0)then
	补魔值 = 用户输入框("多少魔以下补魔", "200")
end
if(宠补血值==nil or 宠补血值==0)then
	宠补血值 = 用户输入框( "宠多少血以下补血", "50")
end
if(宠补魔值==nil or 宠补魔值==0)then
	宠补魔值=用户输入框( "宠多少魔以下补魔", "50")
end
if(队伍人数==nil or 队伍人数==0)then
	队伍人数 = 用户输入框("练级队伍人数，不足则固定点等待！",5)
end
if(设置队员列表==nil or 设置队员列表=="")then
	设置队员列表 = 用户输入框("练级队员列表，不设置则不判断队员！","")
end
if(设置队员列表 ~= nil and string.find(设置队员列表,"|") ~= nil)then
	队员列表=common.luaStringSplit(设置队员列表,"|")
end
if(是否练宠==nil)then
	是否练宠 = 用户输入框("是否练宠,是1，否0",1)
end
是否卖石=用户输入框("是否卖魔石,是1，否0",1)

走路加速值=125	--脚本走路中可以设定移动速度  到达目的地后，再还原值即可
走路还原值=100	--防止掉线 还原速度
身上最少金币=100000	--10w
多少金币去拿钱=10000	--1w

卖店物品列表="魔石|卡片？|锹型虫的卡片|虎头蜂的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"		--可以增加多个 不影响速度
医生名称={"星落护士","谢谢惠顾☆"}
遇敌总次数=0
练级前经验=0
练级前时间=os.time() 

function 蜥蜴练级()
	日志("蜥蜴练级",1)
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")	
	水晶名称="风地的水晶（5：5）"	
	outMazeX=nil	--蜥蜴和黑一 练级时 记录迷宫坐标
	outMazeY=nil
::begin::
	停止遇敌()      
	等待空闲() 	
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()		
	if (当前地图名 =="艾尔莎岛" )then goto quYingDi
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "矮人城镇")then goto Lu1OrLu2 
	elseif(当前地图名 ==  "蜥蜴洞穴")then goto xiYi2 
	elseif(当前地图名 ==  "蜥蜴洞穴上层第1层")then goto yudi 
	elseif(当前地图名 ==  "肯吉罗岛")then goto kenDaoPanDuan end
	回城()
	等待(1000)
	goto begin
::kenDaoPanDuan::
	if(目标是否可达(232,439) == false) then --营地这边岛 去矮人
		goto lu4
	end
	--矮人这边 回矮人吧
	goto HuiAiRen
::Lu1OrLu2::	
	if(目标是否可达(92,124) == false) then --矮人城镇
		goto chufa
	else
		自动寻路(92, 125)
		等待(1000)
		等待到指定地图("矮人城镇", 101, 131)
	end
	goto begin
::quYingDi::
	设置("移动速度",走路加速值)
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin

::quYiYuan::
	自动寻路( 95, 73)
	自动寻路( 95, 72)
	goto begin 

::StartBegin::
	喊话("脚本启动等待",06,0,0)
	等待(1000)
	自动寻路(9,15)
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		common.makeTeam(5,队员列表)
	end	
	if(队伍("人数") == 队伍人数)then	
		goto xue	
	end	
	goto begin
::xue::		
	自动寻路(18,16)
	自动寻路(18,15)
	自动寻路(17,15)
	自动寻路(19,15)
	自动寻路(18,15)      
	回复(0)			-- 转向北边恢复人宠血魔      
	等待(10000)                   --等待X秒等候队友反应      
	自动寻路( 0, 20)   
	goto lu1

::lu1::
    等待到指定地图("圣骑士营地",95,72)
::lu3::					--出营地
    自动寻路( 30, 37)     
    自动寻路( 36, 87)      
    goto lu4 
::lu4::					--去矮人
	等待到指定地图("肯吉罗岛")	
	自动寻路(384, 247)
	自动寻路(384, 245)
::xiYi::
	等待到指定地图("蜥蜴洞穴")
	自动寻路(11, 2)
	自动寻路(12, 2)
	等待到指定地图("肯吉罗岛", 307, 362)	
::HuiAiRen::
	自动寻路(231, 434)	
	等待到指定地图("矮人城镇", 110, 191)	
	goto salebegin 
::xiYi2::
	自动寻路(12, 4)
	自动寻路(17, 4)
	等待(1000)
	等待空闲()
	if(取当前地图名() == "蜥蜴洞穴")then 
		goto xiYi2 --重新进 
	elseif(取当前地图名() == "蜥蜴洞穴上层第1层")then 
		--查找周围空坐标 遇敌
		outMazeX,outMazeY = 取当前坐标()
		tgtx,tgty = 取周围空地(outMazeX,outMazeY,1)--取当前坐标3格范围内 空地
		自动寻路(tgtx,tgty)
		goto yudi
	end
	goto begin 
::HuiYingDi::
	自动寻路(12, 13,"肯吉罗岛")	
	goto goEnd	--没有切换水晶 让黑一脚本去切换购买
::yudi::		
	等待(1000)
	开始遇敌()		-- 开始自动遇敌	
::scriptstart::		-- 遇敌回补判断
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(string.find(取当前地图名(),"蜥蜴洞穴上层第1层")== nil )then goto begin end	--不是黑龙沼泽 退回	
	if(string.find(最新系统消息(),"被不可思议的力量送出了")~=nil)then goto  ting2	end	
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	end		
	if(取队伍人数() ~= 队伍人数)then	--掉线 回城
		脚本日志("队友掉线，回城！")
		goto ting		
	end
	等待(2000)
	goto scriptstart  
	 
::ting::			--停止遇敌 回补
	停止遇敌()      
	等待空闲() 	
	喊话("共遇敌次数"..遇敌总次数,2,3,5)
	common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率		
	if(取队伍人数() ~= 队伍人数)then	--掉线 回城
		回城()
		等待(2000)
		goto begin
	end
	--都是容错的
	if(outMazeX == nil or outMazeY==nil) then	
		outMazeX,outMazeY =取迷宫远近坐标(false)	--false 近 true远
		自动寻路(outMazeX,outMazeY)
		等待(2000)
		等待空闲() 	
		if(取当前地图名() == "蜥蜴洞穴上层第2层") then	--反了
			local curx,cury = 取当前坐标()
			local tx,ty=取周围空地(curx,cury,1)--取当前坐标指定距离范围内 空地
			自动寻路(tx,ty)
			自动寻路(curx,cury)			
			等待空闲() 	
			if(取当前地图名() == "蜥蜴洞穴上层第1层") then	
				outMazeX,outMazeY =取迷宫远近坐标(true)	--false 近 true远
				自动寻路(outMazeX,outMazeY)				
				等待空闲() 	
			end
		end
	else
		自动寻路(outMazeX,outMazeY)
	end
	等待到指定地图("蜥蜴洞穴")
	自动寻路(12,4)
	自动寻路(12,2)
	goto dao1 
::dao1::
	自动寻路(231, 434)		
	等待到指定地图("矮人城镇", 110, 191)
::salebegin::			--卖和回补
	自动寻路(121, 111)
	自动寻路(121, 109)
	自动寻路(121, 111)
	卖(1, 卖店物品列表)	
	等待(15000)
	自动寻路(163, 94)
	自动寻路(163, 95)		
	自动寻路(163, 94)
	自动寻路(163, 95)
	自动寻路(163, 94)
	等待(4000)
	回复(2)		-- 恢复人宠
	等待(16000)
::chufa::			--去练级点
	自动寻路(110, 189)		
	自动寻路( 110, 191)	
	等待到指定地图("肯吉罗岛", 231, 434)	
	自动寻路(307, 362)
	goto xiYi2 
	
::ting2::	
	停止遇敌()	
	清除系统消息()	
	等待到指定地图("蜥蜴洞穴")		
	自动寻路(14,4)	
	自动寻路(17,4)	
	goto yudi 
::goEnd::
	return
end
蜥蜴练级()