★定居艾尔莎岛，。

common=require("common")
设置("遇敌全跑",1)

function main()

	local mapName=""
::begin::
	等待空闲()
	mapName=取当前地图名()
	if(mapName == "芙蕾雅")then
		goto map100
	end
	common.outFaLan("w")
	等待(1000)
	goto begin
::map100::
	自动寻路(298, 148)
	while true do 
		npc=查周围信息("神木",1)
		if(npc ~= nil) then
			移动到目标附近(npc.x,npc.y)
			转向坐标(npc.x,npc.y)
			日志("魔术",1)
			对话选择(1,0)	
			等待(2000)
			if(取当前地图名() ~= "芙蕾雅")then			
				break
			end
		else
			日志("当前时间是【"..游戏时间().."】，】，等待黄昏或夜晚【荷特普】出现")
			等待(30000)
		end		
	end	
	
end

main()