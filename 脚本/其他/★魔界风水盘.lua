★定居艾岛；第4步开始，默认已经使用过小刀进入过地图	★脚本联系：风星落-QQ:274100927

common=require("common")

补血值=1000--用户输入框("多少血以下补血", "430")
补魔值 = 300--用户输入框("多少魔以下补魔", "50")
宠补血值=1000--用户输入框( "宠多少血以下补血", "50")
宠补魔值=300--用户输入框( "宠多少魔以下补血", "100")
队伍人数=取脚本界面数据("队伍人数")
补血值=取脚本界面数据("人补血")
补魔值=取脚本界面数据("人补魔")
宠补血值=取脚本界面数据("宠补血")
宠补魔值=取脚本界面数据("宠补魔")

队长名称=取脚本界面数据("队长名称",false)
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","￠星￡梦￠")--风依旧￠花依然  乱￠逍遥
end
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
else
	队伍人数=tonumber(队伍人数)
end

风水盘名称={"坏掉的风水盘A","坏掉的风水盘B","坏掉的风水盘C","坏掉的风水盘D"}


function 去存风水盘()
	common.gotoBankTalkNpc()
	for i,v in ipairs(风水盘名称) do
		银行("全存",v)
	end
	回城()
end
function checkItem()
	if(人物("职称") == "仙人" or 人物("职称") == "忍者" )then
		for i,v in ipairs(风水盘名称) do
			if(取物品数量(v) > 0)then
				去存风水盘()
				return
			end
		end
	end	
end
function 技能等级(技能名称)
	local playerData = 人物信息()
	for i,skill in ipairs(playerData.skill) do
		if(skill.name == 技能名称)then
			日志("技能等级："..技能名称..skill.lv)
			return skill.lv
		end
	end
	return 0
end
function transform()
	if(人物("职称") == "仙人" or 人物("职称") == "忍者" )then
		工作("变身","",1)	
		menus = 等待菜单返回()
		if(menus ~= nil)then
			for i,v in ipairs(menus) do
				日志(v.name,0)
				if(v.name == "前主教威普尔")then
					日志(v.index,0)
					菜单选择(v.index,"")
					break
				end
			end
		end
	end
end
日志("队长名称:"..队长名称,1)
isTeamLeader=false		--是否队长
if(人物("名称") == 队长名称)then
	isTeamLeader=true
end

function main()

::begin::	
	等待空闲()
	当前地图名 = 取当前地图名()
	mapNum = 取当前地图编号()
	if(当前地图名=="艾尔莎岛" )then goto aiersha  
	elseif(mapNum == 59502)then goto map59502 
	elseif(mapNum == 59705)then goto map59705 	
	elseif(mapNum == 59706)then goto map59706 	
	elseif(mapNum == 59707)then goto map59707
	end   
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)
	回城()	
	等待(2000)
	goto begin
::aiersha::
	if(common.isNeedSupply())then
		goto bu
	end
	checkItem()
	移动(136,114)	
	移动(165, 153)
	对话选否(4)
	等待(2000)
	goto begin
::map59502::	--	地图:59502  梅布尔隘地
	if(取当前地图名() ~= "梅布尔隘地")then goto begin end	
	设置("遇敌全跑",1)
	移动(149, 134)	
	移动(151, 132)	
	等待(3000)
	goto begin
::map59705::
	移动(119,148)
	移动(179,86,59706)
	goto begin	
::map59706::
	移动(141,54,59707)
	goto begin
::map59707::
	--if(取队伍人数() > 1)then goto begin end
	if(目标是否可达(167,103))then 
		等待空闲()	
		移动(167,103)		
		转向(0)
		transform()	
		if(人物("外观") == 101103)then
			对话选是(0)
			if(取当前地图名() == "梅布尔隘地")then
				回城()
				goto begin
			end
		end
	else
		--没组队 单挑
		移动(252,186,59707)
		设置("遇敌全跑",0)
		if(isTeamLeader)then		
			if(队伍("人数") < 队伍人数)then	--数量不足 等待
				common.makeTeam(队伍人数)	
			end
			if(队伍("人数") == 队伍人数)then			
				对话选否(252,187)
				等待(2000)
				if(是否战斗中())then 等待战斗结束() end
			end
		else	
			if(取队伍人数() > 1)then
				if(common.judgeTeamLeader(队长名称)==true) then
					while 队伍("人数") > 1 do
						等待(5000)
					end
				else
					离开队伍()
				end		
			else
				等待(2000)
				common.joinTeam(队长名称)
			end					
		end	
	end
	goto begin
::bu::
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)
	回城()	
	goto begin
end
function leaderAction()
	移动(179,86,59706)
	移动(141,54,59707)
	移动(252,186,59707)
	对话选否(252,187)
	等待(2000)
	if(是否战斗中())then 等待战斗结束() end
	移动(166,103)
	移动(168,103)
	移动(166,103)
	移动(168,103)
	transform()		
	
end

function teammateAction()
	
end	
main()