★捉烈风哥布林脚本，起点艾尔莎岛登入点，请设置好自动战斗,战斗1中设置好遇一级宠时的战斗方法 战斗2设置好宠物满下线保护，谢谢支持魔力辅助程序.脚本发现BUG联系Q:274100927-----------星落

common=require("common")

人补魔=用户输入框("人多少魔以下补魔", "50")
人补血=用户输入框( "人多少血以下补血", "300")
宠补魔=用户输入框( "宠多少魔以下补魔", "50")
宠补血=用户输入框( "宠多少血以下补血", "200")	
自动换水火的水晶耐久值 = 用户输入框("多少耐久以下自动换水火的水晶,不换可不填", "30")        
设置("遇敌类型",1)
--设置("遇敌速度",100)	--毫秒
设置("无一级逃跑",1)	--毫秒
crystalName="水火的水晶（5：5）"
sealCardName="封印卡（人形系）"
sealCardCount=40
function FindMaze()
	local units = 取周围信息()
	if( units ~= nil) then
		
		for index,u in ipairs(units) do			
			if ((u.flags & 4096)~=0 and u.model_id > 0) then				
				移动(u.x,u.y)
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
					移动(10,16)
					移动(10,15)
					等待(2000)
					等待空闲()
				else	--出错
					回城()
					return false
				end
				goto checkLocation
			end
			if(目标是否可达(8,5) == true) then 
				移动(8,5)
				设置("无一级逃跑",0)	--和迪太对战
				local tryNum=0
				while tryNum<3 do
					转向(2)
					等待(2000)
					等待战斗结束()					
					mapData = 取当前地图数据()
					if(mapData ~= nil and mapData.width ~= 18 and mapData.height ~= 22) then
						移动(4,5)
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
--				移动(10,15)
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
		移动(pos[1],pos[2])	
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
	if( string.find(取当前地图名(),"奇怪的坑道")==nil)then	--不是迷宫 不招人
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
--			移动(nextX,nextY)
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
		移动(目标所在坐标["nextX"],目标所在坐标["nextY"])
		return true		
	end
	--还没刷新出来 重新到找人环节
	goto  开始找人
end
function main()
::HomePos::	
	停止遇敌()				-- 结束战斗	
	等待空闲()
	if (人物("宠物数量") >= 5 )then	
		日志("宠物满了，去银行存货！")
		common.depositNoBattlePetToBank()
		if (人物("宠物数量") >= 5 )then	
			日志("银行宠物也满啦！请先清理，再重新执行脚本！")
			return
		end
	end
	当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto start  	  
	elseif (当前地图名=="杰诺瓦镇" )then	
		goto outJnw 
	elseif (当前地图名=="杰诺瓦镇的传送点" )then	
		goto jnwcf  
	elseif( 当前地图名== "莎莲娜")then
		goto shaLianNa	
	elseif( string.find(当前地图名,"奇怪的坑道")~=nil)then
		goto inMaze
	elseif( 当前地图名== "地下水脉")then
		goto yudi
	end
	等待(1000)
	回城()
	goto HomePos
::start::		
	等待到指定地图("艾尔莎岛", 1)    
	移动(140,105)    
	转向(1)		-- 转向北
	等待服务器返回()	
	对话选择(4, 0)
	等待到指定地图("里谢里雅堡", 1)	
	移动(34,89)
	renew(1)			-- 转向北边恢复人宠血魔	
    移动(41, 53)
	if(取物品叠加数量(sealCardName) < sealCardCount)then 
		goto maika
	elseif(耐久(7) < 自动换水火的水晶耐久值)then 
		goto maika
	end
	移动(41, 50)	
	等待到指定地图("里谢里雅堡 1楼", 1)	
	移动(45, 20)	
	等待到指定地图("启程之间", 1)
	移动(15, 4)    		
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
	移动(14, 6)	
	等待到指定地图("村长的家", 1)	 
	移动(1, 9)	
::outJnw::
	等待到指定地图("杰诺瓦镇")
	移动(71, 18)
	
::shaLianNa::
	等待到指定地图("莎莲娜") 
	if(取物品数量("塔比欧的细胞") == 0 and 取物品数量("月之锄头") == 0)then
		移动(281, 371)
		设置("无一级逃跑",0)
		转向(0)
		等待(1000)
		等待空闲()
		设置("无一级逃跑",1)
	end
	if(取物品数量("塔比欧的细胞") > 0 and 取物品数量("月之锄头") == 0)then
		移动(314,432)
		对话坐标选是(313, 432)
		等待空闲()
	end
	if(取物品数量("月之锄头") > 0)then
		findHoleEntry()
	end
	goto HomePos
::inMaze::
	当前地图名 = 取当前地图名()--取当前地图数据
	if( 当前地图名== "莎莲娜")then
		goto shaLianNa	
	elseif( string.find(当前地图名,"奇怪的坑道")~=nil and 取物品数量("月之锄头") > 0 and 取物品数量("红色三菱镜") == 0)then
		FindNpc()	
	elseif( string.find(当前地图名,"奇怪的坑道")~=nil and 取物品数量("红色三菱镜") > 0)then
		goto crossMaze
	elseif( 当前地图名 == "地下水脉" and 取当前地图编号() == 15531)then
		goto yudi
	elseif(检查当前位置()==true) then
		goto yudi	
	else
		回城()
		goto HomePos
	end
	goto inMaze
::crossMaze::		
	if(检查当前位置()==true) then
		goto yudi
	end
	自动迷宫(1)
	goto inMaze
::yudi::
	设置("无一级逃跑",1)
	移动(46, 57)
	移动(44, 55)
	开始遇敌()		-- 开始自动遇敌
	goto scriptstart
::scriptstart::
	if (人物("血") < 人补血 )then		
		goto salebegin
	elseif (人物("魔") < 人补魔 )then	
		goto salebegin		
	elseif (宠物("血") < 宠补血 )then	
		goto salebegin		
	elseif (宠物("魔") < 宠补魔 )then	
		goto salebegin			
	elseif (人物("宠物数量") >= 5 )then	
		日志("宠物数量满了，回城存储！")
		goto HomePos		
	elseif(取物品数量(sealCardName) < 1)then 
		日志("封印卡没了，回城！")
		goto HomePos
	-- elseif(耐久(7) < 自动换水火的水晶耐久值)then 
		-- goto checkcrystalnow
	end		
	等待(2000)
	goto scriptstart		-- 继续自动遇敌
::salebegin::
	停止遇敌()				-- 结束战斗	
	等待(3000)
	goto start
::checkcrystalnow::
	if(取物品数量(crystalName) < 1  )then
		goto start
	end
	停止遇敌()						-- 结束战斗	
	等待(1000)
	扔(7)
	等待(1000)
	装备物品(crystalName, 7)
	等待(1000)
	goto scriptstart
	

::maika::
	移动(17,53)
	等待到指定地图("法兰城", 1)
	等待(500)
	移动(92,88)
	移动(92,78)
	移动(94,78)
	
	等待到指定地图("达美姊妹的店", 1)
	
	移动(10,13)
	移动(13,16)
	移动(17,16)
	移动(17,18)
	
	等待(1000)
	if(耐久(7) < 自动换水火的水晶耐久值)then 		
		转向(2)
		等待服务器返回()
		对话选择(0,0) --第二个参数0 0买 1卖 2不用了
		local dlg = 等待服务器返回()
		local buyData = 解析购买列表(dlg.message)
		local itemList = buyData.items
		local dstItem = nil
		for i,item in ipairs(itemList)do
		if( item.name == crystalName) then
				dstItem={index=i-1,count=1}		
				break
			end
		end
		if (dstItem ~= nil)then
			买(dstItem.index,dstItem.count)
			等待(1000)		
		else
			日志("购买水晶失败！")		
		end
	end
	if(取物品叠加数量(sealCardName) < sealCardCount)then
		转向(2)
		等待服务器返回()
		对话选择(0,0) --第二个参数0 0买 1卖 2不用了
		local dlg = 等待服务器返回()
		local buyData = 解析购买列表(dlg.message)
		local itemList = buyData.items
		local dstItem = nil
		for i,item in ipairs(itemList)do
			if( item.name == sealCardName) then
				dstItem={index=i-1,count=40}	
				break
			end
		end
		if (dstItem ~= nil)then
			买(dstItem.index,dstItem.count)
			等待(1000)		
		else
			日志("购买封印卡失败！")		
		end
	end	
	叠(sealCardName,20)		
	goto HomePos

end
main()