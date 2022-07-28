★定居艾尔莎岛，。

 -- function reload( moduleName )  
	 -- package.loaded[moduleName] = nil  
	 -- return require(moduleName)  
 -- end
 -- common=reload("common")
common=require("common")


设置("遇敌全跑",1)

是否学攻吸=true
是否转职=false
--萌子
--黑色的祈祷地下6楼
tryNum=0
isTeamLeader=用户输入框("是否队长？是1，否0","1")
if(isTeamLeader==0)then
	队长名称=用户输入框("请输入队长名称！","风依旧￠花依然")
else
	队伍人数=用户输入框("队伍人数","5")
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


::begin::
	等待空闲()
	mapName=取当前地图名()
	mapNum=取当前地图编号()
	if(取物品数量("希望的蜡烛") > 0)then

	end
	if(mapName=="奇利村的传送点") then
		自动寻路(7, 6)		
	elseif( string.find(取当前地图名(),"黑色的祈祷地下")~=nil)then	--
		goto findNpc	
	elseif(mapNum==15004)then	--索奇亚海底洞窟 地下1楼
		goto map15004
	elseif(mapNum==15006)then	--索奇亚海底洞窟 地下2楼
		goto map15006 	
	elseif(mapNum==300)then		--索奇亚	
		goto map300
	elseif(mapNum==3299)then	--村长的家	
		自动寻路(7, 6)	
	elseif(mapNum==3214)then	--村长的家	
		自动寻路(7, 1)	
	elseif(mapNum==3212)then	--村长的家	
		自动寻路(1, 8)		
	elseif(mapNum==3200)then	--奇利村	
		goto map3200
	elseif(mapNum==3208)then	--奇利村	
		goto map3208
	elseif(mapNum==16508)then	--黑之祈祷
		goto map16508
	elseif(mapNum==16509)then	--黑之祈祷	打完对话
		goto map16509
	elseif(mapNum==3350)then	--解任务
		goto map3350
	elseif(mapNum==3351)then	--冯奴的家 天书  学攻吸
		goto map3351
	elseif(mapNum==3352)then	--冯奴的家 就职
		goto map3352
	elseif(mapNum==3353)then	--冯奴的家 学洁净
		goto map3353
	end	
	--回城()
	等待(2000)
	自动寻路(140,105)	
	转向(1)
	等待服务器返回()	
	对话选择(4,0)	
	自动寻路(41,50,"里谢里雅堡 1楼")
	自动寻路(45,20,"启程之间")	
	自动寻路(9, 33) 
	对话选是(8,32)	
	--common.toTeleRoom("奇利村")	
	等待(1000)
	goto begin
::map3200::			--奇利村
	--先拿信，然后在蜡烛那等待 没解任务的解任务
	if(取物品数量("亚莉耶鲁的信") > 0)then
		自动寻路(79, 76,"索奇亚")		
	elseif(取物品数量("希望的蜡烛") > 0)then
		自动寻路(59, 45,"索奇亚")	
	else	--拿信
		自动寻路(46,78,"PUB")
	end
	goto begin
::map300::			--索奇亚
	if(取物品数量("亚莉耶鲁的信") > 0)then
		自动寻路(349,261,"冯奴的家")	
	elseif(取物品数量("希望的蜡烛") > 0)then
		自动寻路(240,265,"索奇亚海底洞窟 地下1楼")		
	end
	goto begin
::map3208::
	if(取物品数量("亚莉耶鲁的信") > 0)then
		自动寻路(2,3,"奇利村")			
	else	--拿信	这个不知道坐标 需要走一下
		自动寻路(2,3)

		--失败以后，需要解任务
		if(取物品数量("亚莉耶鲁的信") < 1)then
			自动寻路(2,3,"奇利村")	
			自动寻路(59, 45,"索奇亚")	
			自动寻路(349,261,"冯奴的家")	
		end
	end
	goto begin
::map3350::			--冯奴的家 解任务		
	if(取物品数量("亚莉耶鲁的信") > 0)then
		自动寻路(13,3)
		对话选是(12,4)
	end
	if(取物品数量("希望的蜡烛") > 0) then	--队长等待 队员组队
		if(isTeamLeader == 1)then
			等待队伍人数达标()	
			自动寻路(1,6,"索奇亚")
		else
			waitAddTeam()
		end
	else
		自动寻路(13,3)
		转向坐标(12,4)
		dlg = 等待服务器返回()
		if(string.find(dlg.message,"不会放弃") ~= nil)then	--但我不会放弃的 
			对话选是(12,4)	--交任务 不然下次还得来
			自动寻路(1,6,"索奇亚")
			自动寻路(294,324,"奇利村")
		end
	end	
	goto begin
::map15004::
	自动寻路(24,13,"索奇亚海底洞窟 地下2楼")	
::map15006::
	自动寻路(34,7)	
	对话选是(35,7)
	--逃跑走迷宫
	--不知道迷宫位置
::findNpc::
	if(取物品数量("恐怖旅团之证") > 0)then			
		goto crossMaze
	end
	if(是否空闲中()==false)then
		等待(2000)
		goto findNpc
	end		
	if(取当前地图编号()==map59933) then--迷宫刷新  这个进去地图 要找下信息
		goto begin
	end
	if( string.find(取当前地图名(),"黑色的祈祷地下")==nil)then	--不是迷宫 不找
		goto begin
	end
	找到,findX,findY,nextX,nextY=搜索地图("萌子",1)
	if(找到) then				
		日志("记录坐标: "..取当前地图名().." "..findX..","..findY,1)
		对话选是(findX,findY)			
		等待(3000)				
		if(取物品数量("恐怖旅团之证") > 0)then		
			自动寻路(nextX,nextY)		
		end
		goto crossMaze
	end
	等待(2000)
	goto findNpc
::crossMaze::
	当前地图名 = 取当前地图名()
	if(string.find(当前地图名,"黑色的祈祷地下") == nil) then	
		goto begin	
	end
	mazeList = 取迷宫出入口()
	isDownMap=1
	if(GetTableSize(mazeList) > 1)then
		isDownMap=0		
	end
	自动迷宫(isDownMap)
	等待(1000)
	goto crossMaze
::map16508::		--黑之祈祷
	if(目标是否可达(24,32) ) then
		自动寻路(23,33)
		自动寻路(25,33)
		自动寻路(23,33)
		if(取物品数量("恐怖旅团之证") > 0)then
			对话选是(24,32)
		else
			日志("没有道具，错误！",1)
		end
	else
		自动寻路(24,27)	--在这组队
		if(isTeamLeader == 1)then
			等待队伍人数达标()	
			自动寻路(24,12)	--打露比 
			转向(0)
		else
			waitAddTeam()
		end		
	end
	goto begin
::map16509::		--黑之祈祷	打完对话
	日志("左攻吸，右魔吸",1)
	自动寻路(21,17)	
	自动寻路(23,17)
	对话选是(22,16)	--都需要解散队伍
::map3351::			--冯奴的家 天书  学攻吸
	--需要学的话 在这
	if(是否学攻吸)then
		自动寻路(9,5)
		转向(0)
		common.learnPlayerSkillDir(0)

	end
	自动寻路(13,9)
	对话选是(14,9)	
::map3352::			--可以就职巫师了
	if(是否转职) then
		自动寻路(9,10)
		if(取物品数量("转职保证书") < 1)then
			日志("没有转职保证书，转职失败，返回！")
			return
		end		
		转向(0)
		等待服务器返回()
		对话选择(0,1)
		等待服务器返回()
		对话选择(32,-1)
		等待服务器返回()
		对话选择(0,0)
		等待(2000)
		if(人物("职业") == "巫师")then
			日志("转职巫师成功！")
		else		
			if(tryNum > 3)then 
				日志("多次尝试转职失败，请手动查看原因")
				return 
			end
			tryNum=tryNum+1
			goto map3352
		end
	end


::map3353::	--学洁净 恢复
	自动寻路(7,5)
	common.learnPlayerSkillDir(0)
	自动寻路(10,5)
	common.learnPlayerSkillDir(0)
	自动寻路(2,8)
	return
