▲神域的使者 ::启动点::艾尔莎,公寓  光之路  辛梅尔  此为王冠脚本,光之路中途一段可以设置小于45级逃跑	
	
	
common=require("common")

设置("timer",20)
设置("高速延时", 3)	

local 队长名称=取脚本界面数据("队长名称",false)
local 队伍人数=取脚本界面数据("队伍人数")
if(队长名称==nil or 队长名称=="" or 队长名称==0)then
	队长名称=用户输入框("请输入队伍名称！","风依旧￠花依然")--风依旧￠花依然  乱￠逍遥
end

--local 水晶名称="风地的水晶（5：5）"
local 水晶名称="水火的水晶（5：5）"
local isTeamLeader=false		--是否队长
local 身上最少金币=5000			--少于去取
local 身上最多金币=1000000		--大于去存
local 身上预置金币=500000		--取和拿后 身上保留金币
local 脚本运行前时间=os.time()	--统计效率
local 脚本运行前金币=人物("金币")	--统计金币


function main()
	if(人物("名称",false) == 队长名称)then
		isTeamLeader=true
		日志("当前是队长:"..人物("名称",false),1)
		if(队伍人数==nil or 队伍人数==0)then
			队伍人数 = 用户输入框("队伍人数",5)
		else
			队伍人数=tonumber(队伍人数)
		end
		日志("队伍人数:"..队伍人数,1)		
	else	
		日志("当前是队员:"..人物("名称",false),1)
	end	
local mapNum=0
local mapName=""
::begin::	
	等待空闲()
	mapNum=取当前地图编号()
	mapName=取当前地图名()
	if(mapNum == 59505)then goto map59505 		--光之路
	elseif(mapNum==59752)then goto map59752 	--？？？
	elseif(mapNum==59513)then goto map59513 
	elseif(mapNum==59982)then goto map59982
	elseif(mapNum==59984)then goto map59984
	elseif(mapNum==59985)then goto map59985		
	elseif(mapNum==59986)then goto map59986
	elseif(mapNum==59987)then goto map59987
	elseif(mapNum==59988)then goto map59988
	elseif(string.find(mapName,"秘密回廊")~=nil)then goto crossMaze  
	elseif(string.find(mapName,"通向顶端的阶梯")~=nil)then goto crossMaze  
	elseif(mapName== "公寓")then goto 补魔  
	elseif(mapName == "辛梅尔")then goto map59987  
	elseif(mapName == "艾尔莎岛")then goto 出发 
	elseif(人物("坐标")  == "319,139")then	goto yiji 
	elseif(人物("坐标")  == "26,15")then	goto najiyi end
	等待(1000)
	goto begin
::补魔::	
	移动(91,58)   	 
	回复(0)		
	移动(100,70,"辛梅尔")	
	goto begin	
::出发::	
	common.supplyCastle()
	common.checkHealth()
	common.sellCastle()
	回城()
	等待空闲()
	等待到指定地图("艾尔莎岛")	
	移动(165,153)	
	转向(4, "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("利夏岛")	
	移动(90,99,"国民会馆")	
	移动(108,39,"雪拉威森塔１层")
	移动(34,95)	
	转向(2, "")
	等待服务器返回()	
	对话选择("4", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
::map59552::		--国民会馆
	移动(115,51)
	对话选是(116,50)
	goto begin
::map59505::		--光之路
	if(取物品数量("谢蕾简的结晶体") > 0)then		
		if(目标是否可达(325,198))then
			移动(325,198)
		end
		if(目标是否可达(201,19))then
			移动(201,19)			
		end	
	elseif(取物品数量("秘密回廊的钥匙") > 0)then
		if(目标是否可达(315,221))then
			移动(315,221)
		end
		if(目标是否可达(325,184))then
			移动(325,184)
			移动(325,182)
		end	
	end	
	goto begin
::map59752::		--？？？
	if(目标是否可达(173,190))then	--穿过25层迷宫到达位置
		移动(173,190)
	elseif(目标是否可达(92,190))then			
		移动(91,190)
		对话选是(92,189)
	elseif(目标是否可达(130,228))then			
		移动(130,228)
		对话选是(130,227)
	else							--迷宫入口 组队
		if isTeamLeader then
			移动(130,77)	
			if(队伍("人数") < 队伍人数)then
				common.makeTeam(队伍人数)	
			else
				移动(140,77,"秘密回廊1层")
			end		
		else
			if(队伍("人数") > 1)then
				if(common.judgeTeamLeader(队长名称)==true) then
					while true do
						if(队伍("人数") < 2)then
							if(取当前地图编号()~=59982)then
								break
							end					
						end
						等待(3000)
					end
				else
					离开队伍()
				end	
			else
				if(目标是否可达(130, 77))then		--第一个boss
					common.joinTeam(队长名称)			
				end					
			end
		end
	end

	goto begin
::map59987::		--辛梅尔
	if(common.isNeedSupply())then	--到辛梅尔 主要不满血魔 就去补一下 
		移动(181,81,"公寓")	
		goto begin
	end
	if(取物品数量("秘密回廊的钥匙") > 0)then
		移动(207,91,"光之路")
	elseif(取物品数量("谢蕾简的结晶体") > 0)then		
		--公寓补血魔
		移动(195,67)
		移动(195,62)		
	else
		移动(195,67)
		移动(195,62)
	end
	goto begin
::map59513::
	if(目标是否可达(153, 121))then
		移动(153, 121)
	end
	if(目标是否可达(167,28))then
		移动(167, 26)
		移动(169, 26)		
		对话选是(2)
		移动(169, 20)		
		对话选是(7)
		移动(167, 16)			
		对话选是(0)
		移动(162, 22)	
		对话选是(4)
	end
	if(目标是否可达(116, 69))then
		移动(118, 67)	
		对话选是(2)	
	end
	goto begin
::map59984::		--？？？
	if(目标是否可达(161,58))then	
		移动(161, 58)	
		对话选是(2)	
	end
	if(目标是否可达(121,98))then	
		移动(121, 98)	
		对话选是(2)	
	end	
	if(目标是否可达(201, 18))then	
		移动(201, 18)	
		对话选是(2)	
	end
	if(目标是否可达(318, 135))then	
		移动(318, 135)			
		日志("学一击必中的赶紧哦，10秒后继续下一步",1)
		等待(10000)
		--对话选是(2)	
		移动(319, 148)	
		等待(2000)
		对话选择("4", "", "")	
	end
	if(目标是否可达(238,139))then	
		移动(238,139)
	end
	if(目标是否可达(355,180))then	
		移动(355,180)
	end
	if(目标是否可达(315,220))then	
		移动(315,220)
	end
	if(目标是否可达(279,256))then	
		移动(279,256)
	end
	if(目标是否可达(162,140))then		--守护
		移动(162,140)
		对话选是(163,140)	
	end	
	if(目标是否可达(123,180))then		--守护完结
		移动(122,180)
		对话选是(123,180)	
		if(common.checkTitle("天界变革者"))then
			日志("守护任务完成，已获得【天界变革者】称号！",1)
			return
		end
	end
	goto begin
::map59982::
	if(目标是否可达(101, 137))then
		移动(101, 137)	
		对话选是(0)
	end
	if(目标是否可达(205, 55))then
		移动(205, 55)				
	end
	if(目标是否可达(165, 105))then
		移动(165, 105)				
	end
	if(目标是否可达(234, 106))then
		移动(234, 106)					
	end
	if(目标是否可达(193, 132))then
		移动(193, 132)				
	end
	if(目标是否可达(208, 239))then		--第一个boss
		移动(208, 239)			
		对话选是(7)		
		等待战斗结束()
	end
	if(目标是否可达(193, 216))then		--第2个boss
		移动(193, 216)		
		对话选是(1)		
		等待战斗结束()
	end	
	if(目标是否可达(227, 198))then		--第3个boss
		移动(227, 198)		
		对话选是(3)		
		等待战斗结束()
	end
	if(目标是否可达(258, 229))then		--第4个boss
		移动(258, 229)		
		对话选是(3)		
		等待战斗结束()
	end
	if(目标是否可达(282, 156))then		--第5个boss
		移动(282, 156)		
		对话选是(5)				
	end
	if(目标是否可达(81, 138))then		--第6个boss
		移动(81, 138)		
		对话选是(2)			
	end
	goto begin
::map59988::							--？？？		
	if(目标是否可达(203, 14))then		
		移动(203, 14,"通向顶端的阶梯1楼")				
	end
	if(目标是否可达(163, 54))then		
		移动(163, 54,"真实之顶")				
	end
	if(目标是否可达(358, 173))then		
		移动(358, 173)		
		对话选是(0)		
	end	
	if(目标是否可达(318, 228))then		--		
		if isTeamLeader then			
			if(队伍("人数") < 队伍人数)then
				移动(318, 228)	
				common.makeTeam(队伍人数)	
			else
				移动(318,210)
				对话选是(318,209)		
			end		
		else
			if(队伍("人数") > 1)then
				if(common.judgeTeamLeader(队长名称)==true) then
					while true do
						if(队伍("人数") < 2)then						
							break										
						end
						等待(3000)
					end
				else
					离开队伍()
				end	
			else
				if(目标是否可达(318, 228))then		
					common.joinTeam(队长名称)			
				end					
			end
		end
	end	
	goto begin
::map59992::			--真实之顶
	移动(103,19)
	对话选是(1)
::map59986::
	等待到指定地图("？？？")		
	移动(139, 63)
	移动(141, 61)	
	对话选是(0)
	goto begin
::map59985::			--？？？	
	if(目标是否可达(116, 131))then		
		移动(116, 131)		
		对话选是(0)		
	end
	if(目标是否可达(156,171))then		
		移动(156,171)		
		对话选是(0)		
	end	
	if(目标是否可达(200,59))then		
		移动(200,59)		
		对话选是(201,58)		
	end	
	if(目标是否可达(280,141))then							
		if isTeamLeader then			
			if(队伍("人数") < 队伍人数)then
				移动(280,141)	
				common.makeTeam(队伍人数)	
			else
				移动(280,136)		
				对话选是(280,135)	
			end		
		else
			if(队伍("人数") > 1)then
				if(common.judgeTeamLeader(队长名称)==true) then
					while true do
						if(队伍("人数") < 2)then						
							break										
						end
						等待(3000)
					end
				else
					离开队伍()
				end	
			else
				if(目标是否可达(280, 141))then		
					common.joinTeam(队长名称)			
				end					
			end
		end
	end	
	if(目标是否可达(230,186))then		
		移动(230,186)		
		对话选是(230,185)		
	end	
	if(取物品数量("谢蕾简的结晶体") > 0)then	
		移动(240,99)
		对话选是(241,98)	
	end		
	goto begin
::yiji::	
	等待到指定地图("？？？")	
	移动(318, 139)
	移动(318, 148)
	移动(319, 148)		
	对话选择("4", "", "")	
::najiyi::
	等待(1000)	
	转向(0, "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	
	if(人物("坐标")  == "188,70")then	goto pd end
	goto jieshu 
::pd::
	if(取当前地图名() == "？？？")then goto pd1 end 
	goto najiyi 
::pd1::
	移动(318, 148)
	移动(319, 148)
	
			
	对话选择("4", "", "")
	goto najiyi 
::jieshu::
	
	if(取物品数量("托尔丘的记忆") < 1)then goto  najiyi end
	回城()
::dashu::
	喊话("自动跑记忆脚本结束，星落制作，谢谢使用",02,03,05)
	
	等待(1000)
        goto dashu 
::hunt::
	等待(1000)
	if(是否战斗中())then goto  hunt end
	等待(2000)
	goto begin 
::crossMaze::
	自动穿越迷宫()
	goto begin
end
main()