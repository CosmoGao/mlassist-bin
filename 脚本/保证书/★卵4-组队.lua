保证书卵1脚本,艾尔莎启动

设置("timer",50)

common=require("common")
设置("移动速度",120)
设置("自动叠",1,"长老之证&3")
设置("自动加血",0)

队伍人数=取脚本界面数据("队伍人数")
设置队员列表=取脚本界面数据("队员列表")
队员列表={}
队长名称=取脚本界面数据("队长名称")
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","乱￠逍遥")--风依旧￠花依然  乱￠逍遥
end
if(人物("名称") == 队长名称)then
	if(队伍人数==nil or 队伍人数==0)then
		队伍人数 = 用户输入框("练级队伍人数，不足则固定点等待！",5)
	end
end
-- if(设置队员列表==nil or 设置队员列表=="")then
	-- 设置队员列表 = 用户输入框("队员列表，不设置则不判断队员！","")
-- end
if(设置队员列表 ~= nil and string.find(设置队员列表,"|") ~= nil)then
	队员列表=common.luaStringSplit(设置队员列表,"|")
end
isTeamLeader=false		--是否队长

任务步骤=用户输入框("输入‘1’从头（朵拉）开始任务，\n"..
    "输入‘2’从打长老证之前开始任务，\n"..
    "输入‘3’从荷普特开始任务，\n"..
    "输入‘4’从祭坛守卫开始任务，\n"..
    "输入‘5’从打完BOSS换保证书开始任务（必须有文言抄本）","1")

function 步骤1()
	等待空闲()
	if(取物品数量("琥珀之卵") < 1)then 
		回城() 
		移动(201,96,"神殿　伽蓝")
		移动(95,80,"神殿　前廊")
		移动(44,41,59531)
		移动(34,34,59535)
		移动(48,60,"约尔克神庙")
		移动(39,22)
		while true do 
			if(取物品数量("琥珀之卵") < 1)then 
				if(游戏时间() == "黄昏" or 游戏时间() == "夜晚")then
					对话选是(0)
				else
					日志("当前时间是【"..游戏时间().."】，等待【黄昏或夜晚】")
					等待(30000)
				end
			else
				break
			end			
		end		
	end	
	等待空闲()	
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	移动(157,93)
	转向(2)	
	等待到指定地图("艾夏岛")	
	移动(102, 115,"冒险者旅馆")	
	移动(30, 21)	
	转向(0)
	喊话("朵拉",2,3,5)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(1,0)
	喊话("朵拉",2,3,5)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(1,0)	
	任务步骤= 任务步骤+1
	回城()
end

function 开始找人()
	设置("遇敌全跑",1)
::beFind::
	if(是否空闲中()==false)then
		等待(2000)
		goto beFind
	end		
	if(string.find(取当前地图名(),"海底墓场外苑")==nil)then --错误 返回
		return false
	end
	找到,findX,findY,nextX,nextY=搜索地图("守墓员",1)
	if(找到) then		
		移动到目标附近(findX,findY)
		设置("遇敌全跑",0)		
		while true do
			if 是否战斗中() == false then
				转向坐标(findX,findY)	
				等待服务器返回()
				对话选择("1", "", "")
			else
				break
			end
			等待(1000)
		end			
		while true do	--打长老之证			
			if(取物品叠加数量("长老之证")>=7 or string.find(聊天(50),"长老之证够了")~=nil)then
				日志("长老之证齐了")				
				return true
			elseif(取包裹空格()< 1 and 取物品叠加数量("长老之证")<7)then
				日志("包裹满了")
				break
			end 			
			对话选择("1", "", "")
			等待(1000)
		end
		if(取物品叠加数量("长老之证")>=7 )then
			return true
		end
		丢("魔石")
		丢("僧侣适性检查合格证")
		丢("风的水晶碎片")
		丢("地的水晶碎片")
		丢("水的水晶碎片")
		丢("火的水晶碎片")
		丢("卡片？")	
	end
	等待(2000)
	goto beFind
end
function outMaze()
::穿越迷宫::
	等待空闲()
	当前地图名 = 取当前地图名()
	if(当前地图名=="？？？") then
		goto goEnd
	end
	if (string.find(当前地图名,"海底墓场外苑")==nil)then
		--不知道哪 返回
		return
	end
	自动迷宫(1)
	等待(1000)
	goto 穿越迷宫
::goEnd::
	return
end
function 步骤2()
	等待空闲()	
::begin::
	if(取当前地图名() == "？？？") then
		if(队伍("人数") < 队伍人数)then	--数量不足 等待
			common.makeTeam(队伍人数,队员列表)
		end
		goto shua
	end
	if(string.find(取当前地图名(),"海底墓场外苑")~=nil)then
		goto shua
	end
	common.supplyCastle()
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	设置("遇敌全跑",1)
	移动(130, 50, "盖雷布伦森林")	
	移动(246, 76, "路路耶博士的家")	
	移动(3,10,"？？？")
	设置("遇敌全跑",0)	
	if(isTeamLeader)then	
		if(队伍("人数") < 队伍人数)then	--数量不足 等待
			common.makeTeam(队伍人数,队员列表)
		end
		移动(132, 62)
		goto shua
	else
		goto teamTalk	
	end
	goto begin
::teamTalk::
	当前地图名=取当前地图名()
	if(当前地图名 == "？？？") then
		if(队伍("人数") < 2)then
			common.joinTeam(队长名称)
		else
			if(是否目标附近(131,60))then			
				对话选是(131,60)			
			end
		end	
	end
	if(当前地图名 == "盖雷布伦森林") then
		任务步骤= 任务步骤+1
		回城()
		return
	end	
	if(取物品叠加数量("长老之证")>=7 )then
		日志("长老之证够了",1)
	end  	
	if(当前地图名=="艾尔莎岛")then 
		return
	end
	等待(3000)
	goto teamTalk
	
::shua::
	while true do
		等待空闲()	
		if(取当前地图名() == "？？？") then
			移动(122, 69,"海底墓场外苑第1地带")
			日志("开始找守墓员")				
		elseif(string.find(取当前地图名(),"海底墓场外苑")~=nil)then
			开始找人()
			if(取物品叠加数量("长老之证")>=7 or string.find(聊天(50),"长老之证够了")~=nil)then
				设置("遇敌全跑",1)
				outMaze()	
				break
			end  	
		else
			日志("地图信息错误"..取当前地图名())
			return
		end
	end
::mapJudge::
	if(取当前地图名() == "？？？" and 取物品叠加数量("长老之证")>=7) then		
		移动(131,61)
		while (队伍("人数") < 队伍人数) do--数量不足 等待
			common.makeTeam(队伍人数,队员列表)
			等待(5000)	
		end
		if(是否目标附近(131,60))then			
			对话选是(131,60)			
		end
	else
		goto begin
	end
	if(取当前地图名() == "盖雷布伦森林") then
		任务步骤= 任务步骤+1
		回城()
		return
	end	
	goto mapJudge
end

function 步骤3()
	等待空闲()	
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	移动(201,96,"神殿　伽蓝")	
	移动(91, 138)		
	while true do 
		npc=查周围信息("荷特普",1)
		if(npc ~= nil) then
			对话选是(92,138)
			break
		else
			日志("当前时间是【"..游戏时间().."】，】，等待黄昏或夜晚【荷特普】出现")
			等待(30000)
		end		
	end		
	任务步骤= 任务步骤+1
	回城()
end

function 打障碍物()
	local tmpPos=
	{
		{x=229,y=177,npcx=230,npcy=177},
		{x=234,y=202,npcx=235,npcy=202},
		{x=228,y=206,npcx=228,npcy=207},
		{x=213,y=225,npcx=213,npcy=226},
		{x=193,y=184,npcx=192,npcy=184}
	}
	
::begin::
	for i,pos in ipairs(tmpPos) do
		移动(pos.x,pos.y)
		转向坐标(pos.npcx,pos.npcy)
		等待(2000)
		等待空闲()
		if(人物("坐标") == "163,100") then 
			return
		end
	end
	if(目标是否可达(163,100) == true) then 
		return
	end
	goto begin
end
function 步骤4()
	等待空闲()		
	if(取物品数量("逆十字") < 1)then
		移动(157,93)
		转向(2)	
		等待到指定地图("艾夏岛")	
		移动(102, 115,"冒险者旅馆")	
		移动(56, 32)	
		对话选是(0)
		if(取物品数量("逆十字") < 1)then
			日志("没有获得【逆十字】，请检查任务进度是否有误")
			return false
		end	
	end
	if(取当前地图名()=="？？？")then 
		goto map59714
	end
	common.supplyCastle()
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	设置("遇敌全跑",1)
	移动(165, 153)
	对话选否(4)
	等待到指定地图("梅布尔隘地")
	移动(211, 117)
	对话选是(212,116)
	等待到指定地图("？？？")
	设置("遇敌全跑",0)
	--不知道坐标 原地等吧
::meiBuEr::
	移动(211, 117)
	对话选是(212,116)
	等待到指定地图("？？？")
::map59714::
	设置("遇敌全跑",0)
	if(isTeamLeader)then
		while (队伍("人数") < 队伍人数) do--数量不足 等待
			common.makeTeam(队伍人数,队员列表)
			等待(5000)	
		end
		移动(135,197)
		方向穿墙(2,8)
		移动(156, 197,59714)
		设置("遇敌全跑",0)
		打障碍物()
		
		移动(163, 107)
		方向穿墙(4,8)
		移动(242,117, 59716)
		移动(221, 188)
		对话选否(222,188)
		等待(1000)
		回城()
		任务步骤= 任务步骤+1	
		return
	else
		goto teamTalk
	end
::teamTalk::
	当前地图名=取当前地图名()
	if(当前地图名 == "？？？") then
		if(队伍("人数") < 2)then
			common.joinTeam(队长名称)		
		end	
	elseif(string.find(当前地图名,"梅布尔隘地")~=nil)then
		离开队伍()
		goto meiBuEr
	elseif(取当前地图编号() == 59716) then
		goto map59716		
	end
	等待(3000)
	goto teamTalk
::map59716::
	if(是否战斗中())then
		等待(1000)
		回城()
		任务步骤= 任务步骤+1	
		return
	end
	等待(1000)
	goto map59716		
end

function 步骤5()
	等待空闲()		
	if(取物品数量("觉醒的文言抄本") < 1)then
		日志("身上没有【觉醒的文言抄本】，请先准备好道具再去换【保证书】")
		return
	end
	if(取物品数量("转职保证书") > 0)then
		日志("身上已经有一本【保证书】，请先使用后再去换保证书")
		return
	end
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	设置("遇敌全跑",1)
	移动(130, 50, "盖雷布伦森林")	
	移动(244, 74)	
	对话选是(245,73)
	if(取物品数量("转职保证书") > 0)then
		日志("恭喜你！获得了【转职保证书】")
		return
	end
end


function main()	
	等待空闲()	
	if(人物("名称") == 队长名称)then
		isTeamLeader=true
	end
	日志("队长名称"..队长名称,1)
	while true do	
		if(任务步骤==1)then
			步骤1()
		elseif(任务步骤==2)then
			步骤2()
		elseif(任务步骤==3)then
			步骤3()
		elseif(任务步骤==4)then
			步骤4()	
		elseif(任务步骤==5)then
			步骤5()	
		elseif(任务步骤>=6)then
			日志("任务已完成")
			设置("移动速度",100)
			break
		end
	end
end
main()

