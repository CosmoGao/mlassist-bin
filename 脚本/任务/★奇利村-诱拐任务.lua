★定居艾尔莎岛，半成品

common=require("common")


设置("遇敌全跑",1)


local isTeamLeader=用户输入框("是否队长？是1，否0","1")
if(isTeamLeader==0)then
	local 队长名称=用户输入框("请输入队长名称！","风依旧￠花依然")
else
	local 队伍人数=用户下拉框("队伍人数",{1,2,3,4,5})
end

function 等待队伍人数达标()				--等待队友	
::begin::
	等待(5000)
	if(取当前地图名() ~= "冯奴的家")then
		return
	end
	if(队伍("人数") < 队伍人数) then	--数量不足 等待
		goto begin
	end	
	喊话("人数达标，请不要离开队伍,谢谢！",2,3,5)
	return 
end


function waitAddTeam()
	local tryNum=0
::begin::	
	加入队伍(队长名称)
	if(取队伍人数()>1)then		
		return		
	end
	if(是否空闲中()==false)then
		return
	end
	if(tryNum>10)then
		return
	end
	goto begin
end



function 等天黑(tmpMap)
	while true do 				
		if(游戏时间() == "夜晚")then
			return true
		else
			日志("当前时间是【"..游戏时间().."】，等待【夜晚】")
			等待(30000)
		end
		if(取当前地图名() ~= tmpMap)then
			return false
		end					
	end		
	return true
end
function main()
	local mapName=""
	local mapNum=0
::begin::
	等待空闲()
	mapName=取当前地图名()
	mapNum=取当前地图编号()	
	if(mapName=="奇利村的传送点") then
		移动(7, 6)		
	elseif( string.find(取当前地图名(),"阿鲁巴斯的洞窟")~=nil)then	--
		goto crossMaze	
	elseif(mapNum==300)then		--索奇亚	
		goto map300
	elseif(mapNum==3299)then	--村长的家	
		移动(7, 6)	
	elseif(mapNum==3214)then	--村长的家	
		移动(7, 1)	
	elseif(mapNum==3212)then	--村长的家	
		移动(1, 8)		
	elseif(mapNum==3200)then	--奇利村	
		goto map3200
	elseif(mapNum==3220)then	--民家
		goto map3220
	elseif(mapNum==3221)then	--老夫妇的家
		goto map3221
	elseif(mapNum==15513)then	--医院
		goto map15513
	elseif(mapNum==15514)then	--医院
		goto map15514
	elseif(mapNum==15515)then	--医院
		goto map15515
	elseif(mapNum==15516)then	--医院
		goto map15516	
	elseif(mapNum==15517)then	--森林小路
		goto map15517
	else
		common.toTeleRoom("奇利村")	
	end	
	等待(1000)
	goto begin
::map3200::			--奇利村	
	if(取物品数量( "18338" ) > 0 and 取物品数量( "18339" ) > 0 and 取物品数量( "18340") > 0 and 取物品数量( "18345") > 0)then	
		移动(59, 45,"索奇亚")	
	elseif(取物品数量( "18340" ) > 0)then			--调查诱拐事件的委托信 3
		移动(71,63,"民家")	
	elseif(取物品数量( "18339") > 0)then			--调查诱拐事件的委托信 2
		等天黑("奇利村")
		移动(50,63,"村长的家")	
	elseif(取物品数量( "18338") > 0)then			--调查诱拐事件的委托信 1
		移动(64,56,"医院")	
	elseif(取物品数量( "18341" ) > 0)then			--记载罪行的纸条
		移动(50,54,"老夫妇的家")	
	elseif(取物品数量( "18342" ) > 0)then			--记载罪行的纸条
		移动(64,56,"医院")	
	elseif(取物品数量( "18343" ) > 0)then			--记载罪行的纸条
		等天黑("奇利村")
		移动(50,63,"村长的家")			
	else							--接任务
		移动(50,54,"老夫妇的家")		
	end
	goto begin
::map3220::			--民家
	移动(10,10)		
	对话选是(11,10)		
	if(取物品数量("18345") > 0)then			--双亲的信
		移动(3, 10,"奇利村")	
	end
	goto begin
::map3221::			--老夫妇的家
	if(取物品数量( "18341" ) > 0)then		--记载罪行的纸条
		移动(11, 9)		
		对话选是(11,8)			
	elseif(取物品数量( "18338" )>0)then		--18338	调查诱拐事件的委托信
		移动(10, 15,"奇利村")			
	else			--接任务		
		移动(7,5)
		对话选是(6,5)
	end
	goto begin
::map15513::		--医院
	if(取物品数量( "18338" ) > 0 and 取物品数量( "18339" ) > 0 )then		
		移动(3, 9,"奇利村")		
	elseif(取物品数量( "18342" ) > 0)then				--记载罪行的纸条
		移动(13,16)	
		对话选是(14,16)		
	elseif(取物品数量( "18338") > 0)then 				--18339 调查诱拐事件的委托信
		移动(7, 2)	
		对话选是(8,2)		
	else			--接任务		
		移动(7,5)
		对话选是(6,5)
	end
	goto begin
::map15514::			--村长的家
	移动(8,7)
	转向(0)
	等待(3000)
	if(是否战斗中())then 等待战斗结束() end
::map15515::			--村长的家
	移动(7,4)
	对话选是(7,3)
	if(取物品数量( "18343") > 0 or 取物品数量( "18340") > 0)then
		移动(7,13,"15516")	
	end
	goto begin
::map15516::			--村长的家
	if(取物品数量( "18340") > 0)then
		移动(1,8,"奇利村")	
	elseif(取物品数量( "18339") > 0)then
		移动(10,2,"15514")	
	elseif(取物品数量( "18343") > 0)then
		移动(10,7)
		对话选是(11,7)
	end		
	goto begin
::map15517::			--森林小路
	移动(8,38,"阿鲁巴斯的洞窟1楼")
::crossMaze::
	自动穿越迷宫()
	goto begin
::map15518::			--阿鲁巴斯的研究所
	
::map15520::			--阿鲁巴斯的研究所
	移动(48,39)	
	对话选是(48,38)
	移动(49,55,"索奇亚")
::map300::			--索奇亚
	if(取物品数量("勋章？") > 0)then
		移动(274,294,"奇利村")
	elseif(取物品数量("调查诱拐事件的委托信") >= 3 and 取物品数量("双亲的信") > 0)then
		if(目标是否可达(216,222))then
			移动(217,222)	
			等天黑("索奇亚")
			对话选是(216,222)
		end
	end
	goto begin


end 
main()