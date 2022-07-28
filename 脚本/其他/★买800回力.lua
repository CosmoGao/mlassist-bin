买800回力脚本


common=require("common")

--800回力
function buy800boomerang(count)
	等待空闲()
	if(取队伍人数()>1)then
		离开队伍()
	end 
	if(取包裹空格() < 1) then
		回城()
		common.sellCastle()		
	end	
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="冒险者旅馆" )then	
		goto lvGuan
	end
	common.gotoFaLanCity("e2")	
::lvGuan::	
	自动寻路(238,64,"冒险者旅馆")
	自动寻路(37,37,"冒险者旅馆")
	findNum=0
	while findNum < 10 do
		找到npc=查周围信息("约翰·荷里",1)
		if(找到npc ~= nil) then	--找到目标
			移动到目标附近(找到npc.x,找到npc.y)
			local countNum=count
			while countNum > 0 do	
				对话选是(找到npc.x,找到npc.y)
				countNum = countNum-1
			end
			return true
		end
		等待(10000)
		findNum = findNum+1
	end
end
buy800boomerang(10)