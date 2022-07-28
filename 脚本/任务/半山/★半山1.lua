★半山1脚本，起点艾尔莎岛登入点，根据提示执行脚本

common=require("common")

local 队长名称=取脚本界面数据("队长名称")
if(队长名称==nil or 队长名称=="")then
	队长名称=用户输入框("请输入队伍名称！","风依旧￠花依然")--风依旧￠花依然  乱￠逍遥
end
local 队伍人数=取脚本界面数据("队伍人数")
local isTeamLeader=false
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

::begin::	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then			
		自动寻路(140,105)				
		转向(1)
		等待服务器返回()
		对话选择(4,0)
		等待到指定地图("里谢里雅堡")
		goto liBao
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao		
	elseif (当前地图名=="里谢里雅堡 1楼" )then	
		goto liBaoYiLow	
	elseif (当前地图名=="召唤之间" )then	--登出 bank
		自动寻路( 3, 7)	
		等待到指定地图("里谢里雅堡")	
		goto liBao
	elseif (当前地图名=="莎莲娜" )then	
		goto ShaLianLa
	elseif (当前地图名=="蒂娜村" and 取当前地图编号() == 57175)then	
		goto CheckBattleReslut
	elseif (当前地图名=="蒂娜村" )then	
		goto diNaCunLi
	elseif (当前地图名=="启程之间" )then	
		goto quJieCun
	end	
	回城()
	goto begin
        
::liBao::      
	common.checkHealth()
	common.checkCrystal()
	common.supplyCastle()
	common.sellCastle()		--默认卖	
	common.toCastle()
	自动寻路(41,50)
::liBaoYiLow::
	等待到指定地图("里谢里雅堡 1楼")	
	if(取物品数量("491668") > 0 ) then		
		自动寻路(80, 17)
		对话选是(81, 18)
		if(取物品数量("海德的戒指") > 0 ) then	
			人物信息()	--查下称号 有 追查真相中 就完事了
			return
		end
	end
	if(取物品数量("海德的好运符") < 1 ) then		
		自动寻路(80, 17)
		对话选是(81, 18)
	end
	if(取物品数量("海德的好运符") < 1 ) then	
		goto begin
	end
   	自动寻路(45,20,"启程之间")	
	if(游戏时间() == "夜晚" or 游戏时间() == "黄昏")then
		日志("当前时间是【"..游戏时间().."，去杰村！")						
		goto quJieCun
	end		
	goto diNaCun
::quJieCun::
	自动寻路(15, 4)	
	离开队伍()
	转向(2)
	dlg=等待服务器返回()
	--日志(dlg.message,1)
	if(dlg.message~=nil and (string.find(dlg.message,"此传送点的资格")~=nil or string.find(dlg.message,"很抱歉")~=nil ))then
		回城()
		执行脚本("./脚本/直通车/★开传送-杰诺瓦镇.lua")
		goto jiecun
	end	
	转向(2, "")
	等待服务器返回()
	对话选择("4", 0)
	goto jiecun
::diNaCun::	
	自动寻路(25, 4)
	离开队伍()
	对话选是(26,4)
	等待(2000)
	等待空闲()
	if(取当前地图名() ~= "蒂娜村的传送点")then
		日志("未开蒂娜传送。去杰村！")
		goto quJieCun 
	end 
	goto dina
::dina::
	自动寻路(11, 6)
	自动寻路(11, 2)
	等待到指定地图("村长的家")	
	自动寻路(10, 6)
	自动寻路(7, 3)
	自动寻路(7, 1)
	等待到指定地图("村长的家")
	自动寻路(7, 11)
	自动寻路(3, 7)
	自动寻路(1, 7)
	等待到指定地图("村长的家")
	自动寻路(8, 6)
	自动寻路(1, 6)
::diNaCunLi::
	等待到指定地图("蒂娜村")	
	if(取当前地图编号() ~= 4201)then		
		自动寻路(44, 60)
		自动寻路(44, 62,"莎莲娜")
		while true do 
			if(游戏时间() ~= "夜晚" and 游戏时间() ~= "黄昏")then		
				日志("当前时间是【"..游戏时间().."】，等待黄昏或夜晚")
				等待(30000)			
			else
				等待(30000)		
				自动寻路(585,316,"蒂娜村")					
				break
			end		
		end	
	end	
	自动寻路(60, 52)
	goto dinahanhua
::jiecun::	
	等待到指定地图("杰诺瓦镇的传送点")	
	自动寻路(14, 8)
	自动寻路(14, 6)
	等待到指定地图("村长的家")
	自动寻路(13, 9)
	自动寻路(1, 9)
	等待到指定地图("杰诺瓦镇")
	自动寻路(54, 43)
	自动寻路(54, 35)
	自动寻路(71, 18)
	设置("遇敌全跑",1)
	等待到指定地图("莎莲娜")	
	自动寻路(570,275,"蒂娜村")	
	goto diNaCunLi
::ShaLianLa::
	自动寻路(570,275,"蒂娜村")	
	goto diNaCunLi	
::dinahanhua::
	if(取当前地图编号()==4200)then
		goto diNaCunLi
	end
::map4201::			--夜晚蒂娜
	设置("遇敌全跑",0)
	--喊话("Boss到了，请手动战斗",02,03,05)	
	if(isTeamLeader)then
		common.makeTeam(队伍人数)
		if(队伍("人数") >= 队伍人数) then  
			自动寻路(64,50)
			对话选是(64,51)
		end
	else
		common.joinTeam(队长名称)
	end	
	等待(1000)
::CheckBattleReslut::
	等待空闲()
	if(取当前地图编号() == 57175)then
		日志("战斗胜利，对话boss")
		对话选是(64,51)
	end
	if(取当前地图名() == "莎莲娜" and 取物品数量("修特的项链") > 0 )then
		日志("半山1任务已完成！回城")
		回城()	
		goto begin
	end
	等待(2000)
	goto CheckBattleReslut