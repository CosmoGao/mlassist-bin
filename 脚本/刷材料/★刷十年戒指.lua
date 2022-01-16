刷十年戒指脚本

common=require("common")

队长名称=取脚本界面数据("队长名称",false)
队伍人数=取脚本界面数据("队伍人数")
if(队长名称==nil or 队长名称=="" or 队长名称==0)then
	队长名称=用户输入框("请输入队伍名称！","风依旧￠花依然")--风依旧￠花依然  乱￠逍遥
end
if(队伍人数==nil or 队伍人数==0)then
	队伍人数 = 用户输入框("练级队伍人数，不足则固定点等待！",5)
else
	队伍人数=tonumber(队伍人数)
end


水晶名称="风地的水晶（5：5）"

isTeamLeader=false		--是否队长
if(人物("名称") == 队长名称)then
	isTeamLeader=true
end
日志("队长名称:"..队长名称,1)

function waitToNextBoss(name,x,y,nexty)
	if(目标是否可达(x,y))then	--露比
		移动到目标附近(x,y)
		对话选是(x,y)	
		等待(3000)
		if(是否战斗中())then 等待战斗结束() end
		等待空闲()
		nowx,nowy=取当前坐标()
		if(nowy==nexty)then
			return 1
		else
			日志("没有打过"..name,1)
			return -1
		end
	end
	return 0
end

function main()
::begin::	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="追忆之路" )then	
		goto battle
	end	
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)
	common.toCastle()
	移动(30,81)
	对话选是(30,80)
	goto begin
        
::liBao::      
	移动(34,89)
	回复(1)			-- 转向北边恢复人宠血魔		
	移动(41,50)
	
::battle::
	if(是否战斗中())then 等待战斗结束() end
	if(isTeamLeader)then
		--没有打过boss的 回城重新进入
		if(队伍("人数") < 队伍人数)then	--数量不足 等待
			if(目标是否可达(16,122))then
				移动(16,122)
				common.makeTeam(队伍人数)
			else	--中途队友掉线 回城
				日志("中途队友掉线，回城",1)
				回城()	
				等待(2000)
			end	
		else
			if(waitToNextBoss("露比",15,110,103) == -1)then 			
				回城()
				goto begin
			end
			if(waitToNextBoss("法尔肯",15, 99,92) == -1)then 			
				回城()
				goto begin
			end
			if(waitToNextBoss("犹大",15, 88,81) == -1)then 			
				回城()
				goto begin
			end
			if(waitToNextBoss("海贼",15, 77,70) == -1)then 			
				回城()
				goto begin
			end
			if(waitToNextBoss("双王",15, 66,59) == -1)then 			
				回城()
				goto begin
			end
			if(waitToNextBoss("小帕",15, 55,48) == -1)then 			
				回城()
				goto begin
			end
			
			if(目标是否可达(15,5))then	--出去
				移动(14,5)
				移动(16,5)
				移动(14,5)
				移动(16,5)
				对话选是(15,4)
				goto begin
			end				
		end		
	else
		if(取队伍人数() > 1)then
			if(common.judgeTeamLeader(队长名称)==true) then
				teammateAction()
			else
				离开队伍()
			end		
		else
			if(目标是否可达(15,5))then	--出去				
				移动(15,5)				
				对话选是(15,4)
				goto begin
			else
				if(目标是否可达(16,122) == false)then
					回城()
					goto begin
				end			
				--common.changeLineFollowLeader(队长名称)	
				等待(2000)
				common.joinTeam(队长名称)
			end
				
		end					
	end
	goto begin
end

function teammateAction()
	while true do
		if(取当前地图名() ~= "追忆之路")then
			return
		end
		if(取队伍人数() < 2 and 取当前地图名() == "追忆之路")then	
			if(是否目标附近(15, 4))then
				对话选是(15, 4)
			end	
			回城()
			return
		end	
		if(是否目标附近(15, 4))then
			对话选是(15, 4)
		end			
		等待(3000)
	end
end
main()