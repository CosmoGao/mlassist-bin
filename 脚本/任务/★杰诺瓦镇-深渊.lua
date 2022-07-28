★深渊脚本，需要完成AKS，起点艾尔莎岛登入点，请设置好自动战斗
--被迷宫送出来后，三菱镜会失效，进不去的，必须扔掉

common=require("common")

local 人补魔=用户输入框("人多少魔以下补魔", "50")
local 人补血=用户输入框( "人多少血以下补血", "300")
local 宠补魔=用户输入框( "宠多少魔以下补魔", "50")
local 宠补血=用户输入框( "宠多少血以下补血", "200")	
local 自动换水火的水晶耐久值 = 用户输入框("多少耐久以下自动换水火的水晶,不换可不填", "30")        
设置("遇敌类型",1)

function FindMaze()
	local units = 取周围信息()
	if( units ~= nil) then
		
		for index,u in ipairs(units) do			
			if ((u.flags & 4096)~=0 and u.model_id > 0) then				
				自动寻路(u.x,u.y)
				等待空闲()
				if(取当前地图名() == "奇怪的坑道地下1楼")then
					return true
				end
			end
		end 
	end	
	return false
end

function 检查当前位置()

::checkLocation::
	local mapData = 取当前地图数据()
	if(mapData ~= nil) then
		日志(mapData.width.."距离"..mapData.height)
		if(mapData.width == 18 and mapData.height == 22) then	--最底层
			if(目标是否可达(10,15) == true ) then --在里面
				if(取物品数量("红色三菱镜") > 0)then			
					自动寻路(10,16)
					自动寻路(10,15)
					等待(2000)
					等待空闲()
				else	--出错
					回城()
					return false
				end
				goto checkLocation
			end
			if(目标是否可达(8,5) == true) then 
				自动寻路(8,5)
				设置("无一级逃跑",0)	--和迪太对战
				local tryNum=0
				while tryNum<3 do
					转向(2)
					等待(2000)
					等待战斗结束()					
					mapData = 取当前地图数据()
					if(mapData ~= nil and mapData.width ~= 18 and mapData.height ~= 22) then
						自动寻路(4,5)
						转向(2)
						等待(1000)
						等待空闲()	
						if(取当前地图名() == "地下水脉" and 取当前地图编号() == 15531)then
							return true
						end
					end
					tryNum=tryNum+1
				end				
				设置("无一级逃跑",1)				
			end
--			bottomMap=查周围信息("迪次郎")
--			if(bottomMap~=nil)then	--是最底层
--				自动寻路(10,15)
--			else
--				goto crossMaze
--			end		
		end
	end
	return false
end
function findHoleEntry()
	if(取当前地图名() ~= "莎莲娜")then
		return false
	end
	local findMazeList={
		{365,354},{365,362},{364,370},{354,384},{351,398},{361,408},
                           {359,453},{375,457},{387,459},
                           {395,447},{395,431},{388,421},{378,414},
                           {373,390},{361,420},{360,434},{374,433}}

	for index,pos in ipairs(findMazeList) do						
		自动寻路(pos[1],pos[2])	
		if(FindMaze() == true)then
			return true
		end
	end
	return false
end

function FindNpc()
	目标所在坐标={}
::开始找人::
	if(取物品数量("红色三菱镜") > 0)then			
		return true
	end
	if(是否空闲中()==false)then
		等待(2000)
		goto 开始找人
	end		
	if(取当前地图名()=="莎莲娜") then--迷宫刷新
		return false
	end	
	if( string.find(取当前地图名(),"奇怪的坑道")==nil)then	--不是迷宫 不找人
		return false
	end

	找到,findX,findY,nextX,nextY=搜索地图("挖掘的迪太",1)
	if(找到) then
		目标所在坐标["x"]=findX
		目标所在坐标["y"]=findY
		目标所在坐标["名称"]=取当前地图名()
		目标所在坐标["nextX"]=nextX
		目标所在坐标["nextY"]=nextY
		转向坐标(目标所在坐标["x"],目标所在坐标["y"])	
		喊话("记录坐标: "..目标所在坐标["名称"].." "..目标所在坐标["x"]..","..目标所在坐标["y"],2,3,5)
--		if(取物品数量("红色三菱镜") > 0)then				--物品得到后 包裹不会立马有 循环去拿下
--			自动寻路(nextX,nextY)
--			return true
--		end
		goto  穿越迷宫	
	end
	等待(2000)
	goto 开始找人
::穿越迷宫::
	x,y = 取当前坐标()
	if(取当前地图名() == 目标所在坐标["名称"])then		
		tryNum = 0
		while 取物品数量("红色三菱镜") < 1 and tryNum <= 3  do
			等待空闲()
			移动到目标附近(目标所在坐标["x"],目标所在坐标["y"],1)
			转向坐标(目标所在坐标["x"],目标所在坐标["y"])	
			tryNum=tryNum+1
			等待(1000)
		end				
	end
	if(取物品数量("红色三菱镜") > 0)then
		自动寻路(目标所在坐标["nextX"],目标所在坐标["nextY"])
		return true		
	end
	--还没刷新出来 重新到找人环节
	goto 开始找人
end


function main()
	local mapName=""
::HomePos::	
	停止遇敌()				-- 结束战斗	
	等待空闲()	
	mapName = 取当前地图名()
	if (mapName=="艾尔莎岛" )then	
		goto start  	  
	elseif (mapName=="杰诺瓦镇" )then	
		goto outJnw 
	elseif (mapName=="杰诺瓦镇的传送点" )then	
		goto jnwcf  
	elseif( mapName== "莎莲娜")then
		goto shaLianNa	
	elseif( string.find(mapName,"奇怪的坑道")~=nil)then
		goto inMaze	
	elseif( string.find(mapName,"深渊")~=nil)then
		goto 深渊
	elseif( mapName== "地下水脉")then goto map15531
	elseif( mapName== "黑暗医生集团总部")then goto map15535
	elseif( mapName== "黑暗沼泽 2楼")then goto map15533
	elseif( mapName== "黑暗沼泽 1楼")then goto map15532
	end
	等待(1000)
	回城()
	goto HomePos
::start::		
	等待到指定地图("艾尔莎岛", 1)    
	自动寻路(140,105)    
	转向(1)		-- 转向北
	等待服务器返回()	
	对话选择(4, 0)
	等待到指定地图("里谢里雅堡")		
	common.checkHealth()	
	common.supplyCastle()    
	自动寻路(41, 50,"里谢里雅堡 1楼")	
	自动寻路(45, 20,"启程之间")
	自动寻路(15, 4)    		
	转向(2)
	等待服务器返回()	
	对话选择(4, 0)
	goto jnwcf
::mfgcs2::
        	
	转向(2)
	等待服务器返回()			
	对话选择(4, 0)
	等待服务器返回()	
	对话选择(1, 0)
        
::jnwcf::
	等待到指定地图("杰诺瓦镇的传送点", 1)	 
	自动寻路(14, 6)	
	等待到指定地图("村长的家", 1)	 
	自动寻路(1, 9)	
::outJnw::
	等待到指定地图("杰诺瓦镇")
	自动寻路(71, 18)
	
::shaLianNa::
	等待到指定地图("莎莲娜") 
	if(取物品数量("塔比欧的细胞") == 0 and 取物品数量("月之锄头") == 0)then
		自动寻路(281, 371)
		设置("无一级逃跑",0)
		转向(0)
		等待(1000)
		等待空闲()
		设置("无一级逃跑",1)
	end
	if(取物品数量("塔比欧的细胞") > 0 and 取物品数量("月之锄头") == 0)then
		自动寻路(314,432)
		对话坐标选是(313, 432)
		等待空闲()
	end
	if(取物品数量("月之锄头") > 0)then
		findHoleEntry()
	end
	goto HomePos
::inMaze::
	当前地图名 = 取当前地图名()--取当前地图数据
	if(当前地图名== "莎莲娜")then
		goto shaLianNa	
	elseif(string.find(最新系统消息(),"被不可思议的力量送出了")~=nil and 取物品数量("红色三菱镜")  > 0)then 
		清除系统消息()
		扔("红色三菱镜")
	elseif( string.find(当前地图名,"奇怪的坑道")~=nil and 取物品数量("月之锄头") > 0 and 取物品数量("红色三菱镜") == 0)then
		FindNpc()	
	elseif( string.find(当前地图名,"奇怪的坑道")~=nil and 取物品数量("红色三菱镜") > 0)then
		goto crossMaze
	elseif( 当前地图名 == "地下水脉" and 取当前地图编号() == 15531)then
		goto map15531
	elseif(检查当前位置()==true) then
		goto map15531				
	else
		回城()
		goto HomePos
	end
	goto inMaze
::crossMaze::		
	if(检查当前位置()==true) then
		goto map15531
	end
	自动迷宫(1)
	goto inMaze

::map15531::
	if(目标是否可达(50,32))then
		自动寻路(50,32)
	else
		自动寻路(46,32)
		对话选是(2)
	end
::深渊::
	自动迷宫(1)
end
main()