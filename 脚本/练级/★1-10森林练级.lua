★高地杀黄金龙多练脚本带队。达到目标等级退出，不退出可以设置180级


common=require("common")

starfall={}

protect={}
--1-10
function starfall.森林练级(arg)
	if(arg ~= nil)then
		protect=arg
	else
		protect = 执行脚本("./脚本/保护设置.lua")
	end
	protect.打印保护设置()
	日志("森林练级",1)	
	清除系统消息()
	设置个人简介("玩家称号",protect.目标等级)
	protect.练级前经验=人物("经验")
	protect.练级前宠经验=宠物("经验")
	protect.练级前金币=人物("金币")	
	protect.水晶名称="火风的水晶（5：5）"	
::begin::						--开始
	停止遇敌()
	等待空闲()
	common.changeLineFollowLeader(protect.队长名称)	
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	mapNum=取当前地图编号()
	if(protect.checkTargetLevel()) then		--队长达到目标等级退出  队员根据队长设置退出
		return
	elseif (当前地图名=="艾尔莎岛" )then  
		goto erDao	
	elseif (取当前地图编号() == 1112)then	--法兰东医院
		回城() 
		goto begin 
	elseif (mapNum==59539 )then	
		goto erYiYuan
	elseif (当前地图名=="冒险者旅馆" )then	
		goto sale
	elseif (当前地图名=="盖雷布伦森林" )then	
		goto toUpgradePos
	elseif (当前地图名=="艾夏岛" )then	
		goto aiXiaDao
	end
	回城()
	等待(1000)
	goto begin
::erDao::
	等待到指定地图("艾尔莎岛")	
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)
	common.checkCrystal(水晶名称)	
	if(取当前地图名() ~= "艾尔莎岛")then
		回城()
		等待(1000)		
	end
	移动(144,105)
	移动(157,93)
	转向(2)	
	等待到指定地图("艾夏岛")		
	goto aiXiaDao	
::aiXiaDao::					--去医院
	移动(112, 81,"医院")	
	goto erYiYuan
::erYiYuan::	
	if(取当前地图名() ~= "医院")then goto begin end
	if(protect.isTeamLeader==false)then goto teammateAction end
	移动(34, 46)
	移动(35, 46)
	移动(35, 47)
	移动(35, 45)
	移动(35, 47)
	回复(1)        			-- 恢复人宠        
	等待(3000)				--等待3秒 
	移动(28, 47)
	protect.等待队伍人数达标(protect.队伍人数)	
	if(protect.取当前等级()	>= protect.目标等级) then 
		return
	end	
	移动(28, 52,"艾夏岛")	
	goto toSenLin
::toSenLin::					--去练级点			
	移动(190, 116,"盖雷布伦森林")	
	goto toUpgradePos
::toUpgradePos::
	等待到指定地图("盖雷布伦森林")	
	移动(225,227)
	移动(223,227)
	goto kaishi
::kaishi::						--开始遇敌		
	开始遇敌()      
	goto battle
::battle::						--状态判断			--自动遇敌中 循环判断血魔
	if(人物("血") < protect.补血值)then goto  ting end
	if(人物("魔") < protect.补魔值)then goto  ting end
	if(宠物("血") < protect.宠补血值)then goto  ting end
	if(宠物("魔") < protect.宠补魔值)then goto  ting end
	if(取当前等级()	>= protect.目标等级) then goto  ting end
	if 是否战斗中() then
		protect.遇敌总次数=protect.遇敌总次数+1
		等待战斗结束()
	else
		minHp=protect.队友当前血最少值()
		if(minHp~= 88888 and minHp ~= 0 and  minHp < 200)then	
			日志("队友血量过低"..minHp.."，回补！",1)				
			goto ting
		end
	end				
	--需要自动喊话的 自己加
	等待(1000)	
	goto battle      
::ting::						--回补
	停止遇敌()                 	-- 结束战斗			
	喊话("共遇敌次数"..protect.遇敌总次数,2,3,5)
	common.statistics(protect.练级前时间,protect.练级前经验)	--统计脚本效率
	等待(1000)
    移动(30,193,"盖雷布伦森林")	
	移动(199, 211,"艾夏岛")		
	移动(112, 88)
	if(protect.是否卖石 == 1)then 
		移动(102, 115)	
		goto sale 
	end
	移动(112, 81)	
	goto erYiYuan
::sale::	--卖石	
	等待到指定地图("冒险者旅馆")	
	移动(37,30)
	移动(38,30)
	移动(37,30)
	移动(38,30)
	移动(37,30)
	卖(37,29,protect.卖店物品列表)	 
	等待(3000)
	移动(38, 48)
	goto begin

--队员动作
::teammateAction::
	--医院里检测掉魂
	common.checkHealth()			
	if(队伍("人数") < 2)then
		common.changeLineFollowLeader(protect.队长名称)
		if(取当前地图编号() ~= 59539)then goto begin end		--艾夏岛医院
		common.joinTeam(protect.队长名称)		
	end	
	if(common.judgeTeamLeader(protect.队长名称)==true) then
		if(protect.checkTargetLevel()) then		--队长达到目标等级退出  队员根据队长设置退出
			return
		end
		if(取当前地图名() == "冒险者旅馆")then
			卖(37,29,卖店物品列表)	 
		end
		protect.checkTargetLevel()
		goto scriptstart
	else
		离开队伍()
	end				
	等待(2000)
	goto teammateAction

	leaderSetLv=getLeaderSetLv()
	当前地图名 = 取当前地图名()
	--卖魔石检测
	if(当前地图名 == "工房")then
		卖(21,23,卖店物品列表)	
	elseif(当前地图名 == "冒险者旅馆")then
		卖(37,29,卖店物品列表)	 
	end
	--切换练级地检测
	if(leaderSetLv ~= nil and leaderSetLv ~= 目标等级) then
		goto ting
	end
	--队伍人数检测
	if(取队伍人数() < 2)then
		goto ting
	end
	if(人物("灵魂") > 0)then	
		等待空闲()
		回城()
		等待(2000)
		goto begin
	end
	--黄白 继续砍怪 其余登出
	if(人物("健康") >= 1) then 
		等待空闲()
		common.checkHealth(医生名称)
		goto begin
	end	
	--宠物受伤检测
	if(当前地图名 == "医院" and 宠物("健康") > 0 and 是否目标附近(7,6,1)==true)then	
		--不知道医生坐标
		转向坐标(7,6)	--需要改医生坐标
		等待服务器返回()
		对话选择(-1,6)		
	end
	等待(2000)
	goto scriptstart  
::ting::	
	--common.statistics(练级前时间,练级前经验,练级前宠经验,练级前金币)	--统计脚本效率
	等待空闲()
	if(取队伍人数() < 2)then	--掉线 回城
		回城()
		等待(2000)
	end	
	goto begin

end
starfall.森林练级()
return starfall