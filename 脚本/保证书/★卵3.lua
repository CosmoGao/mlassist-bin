保证书卵3脚本,艾尔莎启动


common=require("common")
设置("移动速度",120)

任务步骤=1
function 步骤1()
	等待空闲()
	if(取物品数量("琥珀之卵") < 1)then 
		回城() 
		自动寻路(201,96,"神殿　伽蓝")
		自动寻路(95,80,"神殿　前廊")
		自动寻路(44,41,59531)
		自动寻路(34,34,59535)
		自动寻路(48,60,"约尔克神庙")
		自动寻路(39,22)
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
	任务步骤= 任务步骤+1
	回城()
end
function 步骤2()
	等待空闲()	
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	设置("遇敌全跑",1)
	自动寻路(165, 153)
	对话选否(4)
	等待到指定地图("梅布尔隘地")
	自动寻路(169, 120)
	设置("遇敌全跑",0)
	对话选否(2)
	等待(2000)
	等待空闲()	
	if(取物品数量("魔导书抄本") >= 0)then 	
		任务步骤= 任务步骤+1
		回城()
	end
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
	设置("遇敌全跑",1)
	自动寻路(130, 50, "盖雷布伦森林")	
	自动寻路(244, 73)		
	对话选是(2)
	对话选是(2)	
	任务步骤= 任务步骤+1
	回城()
end

function 步骤4()
	等待空闲()	
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	自动寻路(201,96,"神殿　伽蓝")	
	自动寻路(91, 138)		
	while true do 
		npc=查周围信息("荷特普",1)
		if(npc ~= nil) then
			对话选是(92,138)
			break
		else
			日志("当前时间是【"..游戏时间().."】，等待【黄昏或夜晚】")
			等待(30000)
		end		
	end		
	任务步骤= 任务步骤+1
	回城()
end

function 步骤5()
	等待空闲()	
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	自动寻路(157,93)
	转向(2)	
	等待到指定地图("艾夏岛")	
	自动寻路(102, 115,"冒险者旅馆")	
	自动寻路(56, 32)	
	对话选是(0)
	对话选是(0)
	任务步骤= 任务步骤+1
	回城()
end
function FindMaze()
	local units = 取周围信息()
	if( units ~= nil) then		
		for index,u in ipairs(units) do			
			if ((u.flags & 4096)~=0 and u.model_id > 0) then				
				自动寻路(u.x,u.y)
				等待空闲()
				if(string.find(取当前地图名(),"虫洞地下")~=nil )then
					return true
				end
			end
		end 
	end	
	return false
end
function 开始找人()

::begin::
	自动寻路(203, 265)
	FindMaze()
	if(取当前地图名()=="布拉基姆高地")then
		goto begin
	end
::beFind::
	if(是否空闲中()==false)then
		等待(2000)
		goto beFind
	end		
	if(取当前地图名()=="布拉基姆高地") then--迷宫刷新
		goto begin
	end
	if(string.find(取当前地图名(),"虫洞")==nil)then --错误 返回
		return false
	end
	找到,findX,findY,nextX,nextY=搜索地图("纳塞",1)
	if(找到) then				
		移动到目标附近(findX,findY)
		对话选是(findX,findY)			
		return true
	end
	等待(2000)
	goto beFind
end
function 步骤6()
	等待空闲()	
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	设置("遇敌全跑",1)
	自动寻路(165, 153)
	对话选否(4)
	等待到指定地图("梅布尔隘地")
	自动寻路(256, 166,"布拉基姆高地")
::findNpc::
	自动寻路(203, 265)
	FindMaze()
	开始找人()
	if(取当前地图名() == "？？？")then
		设置("遇敌全跑",0)
		自动寻路(195, 33)
		对话选是(195,32)
		等待(2000)
		等待空闲()	
		自动寻路(229,67)
		对话选是(229,66)
		等待(2000)
		等待空闲()	
		自动寻路(230, 57, "布拉基姆高地")
	else
		goto findNpc
	end	
	任务步骤= 任务步骤+1	
end


function 步骤7()
	等待空闲()	
	if(取当前地图名()~="布拉基姆高地")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
		common.checkHealth()
		自动寻路(165, 153)
		对话选否(4)
		等待到指定地图("梅布尔隘地")
		自动寻路(256, 166,"布拉基姆高地")
		自动寻路(203, 265)
	end
::begin::
	设置("遇敌全跑",1)	
	自动寻路(203, 265)
	FindMaze()
::crossMaze::	--穿越迷宫
	自动穿越迷宫("布拉基姆高地|59714")
	if(取当前地图名()=="布拉基姆高地")then 
		goto begin			
	end
	自动寻路(50, 114)
	设置("遇敌全跑",0)	
	while true do 
		npc=查周围信息("安洁可",1)
		if(npc ~= nil) then
			对话选是(50, 113)
			break
		else
			日志("当前时间是【"..游戏时间().."】，等待夜晚或清晨【安洁可】出现】")
			等待(30000)
		end		
	end		
	等待(2000)
	等待空闲()	
	自动寻路(131, 101)
	对话选是(131, 100)
	等待到指定地图("布拉基姆高地")
	任务步骤= 任务步骤+1
	--回城()
end
--步骤7 获胜后地图id：59716  ？？？
function main()	
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)
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
		elseif(任务步骤==6)then
			步骤6()
		elseif(任务步骤==7)then
			步骤7()
		elseif(任务步骤>=8)then
			日志("任务已完成")
			设置("移动速度",100)
			break
		end
	end
end
main()

