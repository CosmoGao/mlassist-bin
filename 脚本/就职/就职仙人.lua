--定居艾尔莎岛

common=require("common")
--设置("timer", 100)

::begin::	
	等待空闲()
	mapNum=取当前地图编号()
	if(mapNum==45012)then goto map45012 end
	if(mapNum==45011)then goto map45011 end
	if(mapNum==45010)then goto map45010 end
	if(mapNum==45009)then goto map45009 end
	if(mapNum==45008)then goto map45008 end
	if(mapNum==45007)then goto map45007 end
	if(取当前地图名() == "哥拉尔镇")then goto  gelaer end
	if(取当前地图名() == "世外桃源")then goto  TaoYuanX end
	if(取当前地图名() == "世外桃源2")then goto  TaoYuan2 end
	if(取当前地图名() == "世外桃源3")then goto  TaoYuan3 end
	if(取当前地图名() == "世外桃源4")then goto  TaoYuan4 end
	if(取当前地图名() == "世外桃源仙人家前")then goto  XianRenHomePre end
	if(取当前地图名() ==  "艾尔莎岛")then goto   aidao end
	if(取当前地图名() ==  "威尔迪酒吧")then goto picture2 end
	if(取当前地图名() ==  "旅馆")then goto hotel end
	if(string.find(最新系统消息()," 您将被强制离开")~=nil)then goto offlinechat	end
	等待(2000)
	goto begin 		
::aidao::
	执行脚本("./脚本/直通车/★公交车-法兰To哥拉尔.lua")
	goto begin
::hotel::
	if(取当前地图名() ~= "旅馆")then
		goto begin
	end
	if(取物品数量("破烂的画像") > 0)then		
		移动(13,9)
		移动(13,7)
		对话选是(14,7)
		移动(19,33,"哥拉尔镇")
		移动(123,189)	
		对话选是(123,188)
		if(取物品数量("清楚的画像") > 0)then		
			goto buyseed	
		end
		goto picture3
		
	else
		移动(23,4)
		对话选是(24,4)
		if(取物品数量("心写镜") > 0)then
			移动(19,33,"哥拉尔镇")
			goto goXianRenHome
		end
	end		
::gelaer::	
	if(取物品数量("心写镜") >0 )then goto goXianRenHome  end
	if(取物品数量("水晶硬核") >0 )then goto goXianRenHome  end
	if(取物品数量("给仙人的信") >0 )then goto goXianRenHome  end
	if(string.find(聊天(50),"交出了 水晶硬核 。")~=nil)then 		
		goto goXianRenHome 
	end
	if(string.find(聊天(50),"交出了 想泉丸 。")~=nil)then 
		移动(94,48,"威尔迪酒吧")
		goto bar 
	end
	if(取物品数量("仙人的画像") > 0)then
		移动(94,48,"威尔迪酒吧")
		goto picture2
	end
	if(取物品数量("破烂的画像") > 0)then		
		移动(107,48,"旅馆")
		goto picture3	
	end
	if(取物品数量("清楚的画像") > 0)then		
		goto buyseed	
	end
	goto picture1
	
--1.前往哥拉尔镇与亚莱（123.188）对话，与佩琪卡（124.189）对话，再与亚莱对话，获得【仙人的画像】。
--◆与佩琪卡（124.189）对话，当提示“亚莱一直碎碎念。。。。”时选择“是”，可以重置本任务。
::picture1::
	移动(123,189)	
	对话选是(123,188)
	对话选是(124,189)
	对话选是(123,188)
	if(取物品数量("仙人的画像") > 0)then
		移动(94,48,"威尔迪酒吧")
		goto picture2
	end	
	goto picture1
--2.白天或傍晚前往哥拉尔镇威尔迪酒吧（94.48）与夏拉拉道士对话，交出【仙人的画像】获得【破烂的画像】。
::picture2::
	if(取当前地图名() ~= "威尔迪酒吧")then
		goto begin
	end
	if(取物品数量("仙人的画像") < 1)then
		goto begin
	end
	移动(15,17)
	while true do 	
		if(游戏时间() == "黄昏" or 游戏时间() == "白天")then
			对话选是(16,18)			
			break
		else
			日志("当前时间是【"..游戏时间().."】，等待【黄昏或夜晚】")
			等待(30000)
		end					
	end	
	if(取物品数量("破烂的画像") > 0)then
		移动(8,28,"哥拉尔镇")
		移动(107,48,"旅馆")
		goto picture3	
	end
	goto picture2
--3.前往哥拉尔镇旅馆（107.48）调查窃听用的墙壁（14.8）。与亚莱（123.188）对话，交出【破烂的画像】获得【清楚的画像】。
::picture3::
	if(取当前地图名() ~= "旅馆")then
		goto begin
	end
	if(取物品数量("破烂的画像") < 1)then
		goto begin
	end	
	移动(13,9)
	移动(13,7)
	对话选是(14,7)
	移动(19,33,"哥拉尔镇")
	移动(123,189)	
	对话选是(123,188)
	if(取物品数量("清楚的画像") > 0)then		
		goto buyseed	
	end
	goto picture3
--4.前往法兰城冒险者旅馆（238.64）与冒险野郎马克盖（43.44）对话，选“是”交出300G购买【桃源乡之桃种】。
--◆此步骤时，若队伍里每个人物都持有1个【想泉丸】及额外（【桃连蛇】、【桃茂】、【桃冠】、【想泉丸】中的任意一个），则可以不返回法兰城购买【桃源乡之桃种】，否则建议购买，以作为后续任务进入世外桃源的道具。
::buyseed::
	if(取物品数量("想泉丸") > 0  )then 
		if(取物品数量("桃源乡之桃种") > 0 )then goto goXianRenHome  end
		if(取物品数量("桃连蛇") > 0 )then goto goXianRenHome  end
		if(取物品数量("桃茂") > 0 )then goto goXianRenHome  end
		if(取物品数量("桃冠") > 0 )then goto goXianRenHome  end
		if(取物品数量("想泉丸") >= 2 )then goto goXianRenHome  end
		--法兰购买种子
		local tryNum=0
		while tryNum < 3 do
			common.gotoFaLanCity("e1")
			移动(238,64,"冒险者旅馆")
			移动(42,44)
			对话选是(43,44)
			if(取物品数量("桃源乡之桃种") >0 )then 
				执行脚本("./脚本/直通车/★公交车-法兰To哥拉尔.lua")
				goto begin
			end
		end
	else
		common.gotoFaLanCity("e1")
		移动(238,64,"冒险者旅馆")
		移动(42,44)
		对话选是(43,44)
		if(取物品数量("桃源乡之桃种") >0 )then 
			执行脚本("./脚本/直通车/★公交车-法兰To哥拉尔.lua")
			goto begin
		end
	end	
::bar::	--移动(94,48,"威尔迪酒吧")
	if(取当前地图名() ~= "威尔迪酒吧")then
		goto begin
	end
	if(取物品数量("仙人的画像") > 0)then
		移动(15,17)
		while true do 	
			if(游戏时间() == "黄昏" or 游戏时间() == "白天")then
				对话选是(16,18)			
				break
			else
				日志("当前时间是【"..游戏时间().."】，等待【黄昏或夜晚】")
				等待(30000)
			end					
		end	
		if(取物品数量("破烂的画像") > 0)then
			移动(8,28,"哥拉尔镇")
			移动(107,48,"旅馆")
			goto begin	
		end
	else
		移动(21,17)
		while true do 	
			if(游戏时间() == "黎明" or 游戏时间() == "夜晚")then
				转向坐标(22,18)
				日志("心写镜...",1)
				对话选是(22,18)
				移动(8,28,"哥拉尔镇")
				break
			else
				日志("当前时间是【"..游戏时间().."】，等待【黄昏或夜晚】")
				等待(30000)
			end					
		end	
		移动(107,48,"旅馆")	
		移动(23,4)
		对话选是(24,4)
		if(取物品数量("心写镜") > 0)then
			移动(19,33,"哥拉尔镇")
			goto goXianRenHome
		end
	end	
	goto begin

	
	
	
	
::goXianRenHome::	
	移动(175, 105)	
	移动(176, 105,"库鲁克斯岛")	
	移动(288, 437)	
	移动(402, 341)	
	移动(406, 341)	
	转向(3)	
	等待服务器返回()
	对话选择("1", "", "")	
::TaoYuanX::		
	等待到指定地图("世外桃源")		
	移动(54, 35)	
	移动(55, 35)	
::TaoYuan2::		
	等待到指定地图("世外桃源2")	
	移动(31, 37)	
	移动(31, 49)	
	移动(34, 52)	
	移动(34, 58)		
::TaoYuan3::		
	等待到指定地图("世外桃源3")		
	移动(14, 36)	
	移动(13, 36)		
::TaoYuan4::		
	等待到指定地图("世外桃源4")
	移动(51, 35)	
	移动(36, 35)
	移动(33, 32)	
	移动(33, 15)	
	移动(33, 14)		
::XianRenHomePre::		
	等待到指定地图("世外桃源仙人家前")		
	移动(33, 21)	
	移动(33, 20)	
	转向(0, "")	
	等待服务器返回()
	对话选择("1", "", "")	
::XianRenHome::
	等待到指定地图("仙人之家")	
	移动(10, 5)	
	对话选是(1)	
	对话选是(1)	
	
	goto bar 
::xiuXingC::
		
	等待到指定地图("修行场", 1)
	

::offlinechat::
	清除系统消息()
	等待(1000)
	喊话("星落专用队友脚本 防掉线喊话中。。。。",0,0,0)
	等待(200000)
	goto begin 

::outXianRenHome::
	移动(10,18,"世外桃源仙人家前")	
	移动(31,57,45000)
	移动(33,59,"库鲁克斯岛")
	移动(286,437,"哥拉尔镇")
	
::bingshe::
	移动(174,170,"哥拉尔镇 兵舍")
	移动(19, 11)	
	对话选是(20, 11)	
	移动(9,14,"哥拉尔镇")
	移动(94,48,"威尔迪酒吧")
	移动(15,17)
	while true do 	
		if(游戏时间() == "黄昏" or 游戏时间() == "白天")then
			对话选是(16,18)		--变更场景	
			break
		else
			日志("当前时间是【"..游戏时间().."】，等待【黄昏或夜晚】")
			等待(30000)
		end					
	end	
	对话选否(93,50)
	
	
	----地图:45013 哥拉尔镇
	移动(93,51)
	对话选否(93,50)
	等待(2000)
	if(是否战斗中())then 等待战斗结束() end
	--地图:45014 旅馆
	移动(20,6)
	对话选是(20,5)
	if(取物品数量("夏拉拉Ａ钱日记") >0 )then 
		对话选是(123,188)  
		移动(174,170,"哥拉尔镇 兵舍")
		移动(19, 11)	
		对话选是(20, 11)	
	end
	
::map45007::  --修行场
	移动(39,31)
	对话选是(39, 30)	
	goto begin
::map45008::	 --修行场
	移动(34,29)
	对话选是(33, 28)	
	等待(2000)
	if(是否战斗中())then 
		等待战斗结束()
	end
	if(取当前地图编号()~=45008)then goto begin end
	
	移动(39,39)
	对话选是(40, 39)	
	if(取当前地图编号()~=45008)then goto begin end
	goto begin
::map45009::	 --修行场
	移动(39,31)
	对话选是(39, 30)	
	goto begin
::map45010::		--托托仙人
	unit=查周围信息("托托仙人",1)
	if(unit ~= nil)then
		移动到目标附近(unit.x,unit.y)
		对话选是(unit.x,unit.y)
		if(取当前地图编号()~=45010)then goto begin end
	end
	移动(35,36)
	对话选是(35, 35)	
	等待(2000)
	if(是否战斗中())then 
		等待战斗结束()
	end
	if(取当前地图编号()~=45010)then goto begin end
	
	移动(29,40)
	对话选是(28, 40)	
	if(取当前地图编号()~=45010)then goto begin end
	移动(39,29)
	对话选是(39, 28)	
	if(取当前地图编号()~=45010)then goto begin end
	goto begin
::map45011::
	移动(39,31)
	对话选是(39, 30)	
	goto begin
::map45012::		--8675 8676 8671 8677
	units=取周围信息()
	if(units ~= nil)then
		for i,u in ipairs(units) do
			if(u.unit_id == 8671)then
				移动到目标附近(u.x,u.y)
				对话选是(u.x,u.y)
				if(取当前地图编号()~=45012)then goto begin end
			end
		end
	end
	移动(39,37)
	对话选是(40, 37)	
	等待(2000)
	if(是否战斗中())then 
		等待战斗结束()
	end
	if(取当前地图编号()~=45012)then goto begin end
	
	移动(35,33)
	对话选是(34, 33)	
	if(取当前地图编号()~=45012)then goto begin end
	移动(35,37)
	对话选是(34,37)	
	if(取当前地图编号()~=45012)then goto begin end
	移动(34,40)
	对话选是(33,40)	
	if(取当前地图编号()~=45012)then goto begin end
	goto begin
::map45006::		--仙人之家 就职地方
	移动(16,10)
	common.learnPlayerSkill(17,10)	
	移动(9,5)
	对话选是(9,4)	--就职
		