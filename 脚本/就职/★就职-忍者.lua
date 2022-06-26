--定居艾尔莎岛 请注意,要将伊尔,圣村,维村传送开好,身上没有物品情况下，会重置任务从头开始，后续需要从小道进入的，请任务完成后，去维村、汉克以及大圣堂去解任务，这里只到boss这步

common=require("common")


taskStep=用户下拉框("输入‘1’从头开始任务，\n"..
	"输入‘2’酒吧开始执行，\n"..
   "输入‘3’伊尔村拿纸条，\n"..
   "输入‘4’拿面包，\n"..
   "输入‘5’拿亚尔科尔的点心，\n"..
   "输入‘6’拿杀人用的毒\n"..
   "输入‘7’探听毒岚的信息\n"..
   "输入‘8’维诺亚执行后续\n"..
   "输入‘9’乌克兰执行后续\n"
   ,{1,2,3,4,5,6,7,8,9},"1")

answer={
		["问题一：坐垫总共有几个？"]="十...",
		["问题二：总共有几扇窗户？"]="八...",
		["问题三：供奉在神明前的书是什么颜色的？"]="红...",
		["问题四：从最里面开始数来第5个宝箱是什么色的？"]="蓝...",
		["问题五：有放一篮橘子的桌子是前面的还是后面的？"]="后...",
		["问题六：谜之鸟·1一直说的是什么水果？"]="桃...",
		["问题七：正中央写的字是什么？"]="忍...",
		["问题八：草鞋总共有几双？"]="三...",
		["问题九：绿色的桶子是从里面数来的第几个？"]="五...",
		["问题十：墙壁是什么颜色的？"]="白...",	
		
		["问题一：谜之鸟·2一直说的是什么水果？"]="柿...",
		["问题二：从里面数来的第一个招牌上写了些什么？"]="影...",
		["问题三：宠物哥布林的名字叫什么？"]="松...",
		["问题四：哥布林的头盔是什么色的？"]="绿...",
		["问题五：有几只刀？"]="五...",
		["问题六：时钟指着哪个时间？"]="子...",
		["问题七：柜子里放了什么？"]="笔...",
		["问题八：地板上总共有几本书？"]="三...",
		["问题九：总共有几棵树？"]="八...",
		["问题十：宠物幽灵的名字是什么？"]="梅..."		
		
	}
function 学暗杀()
::begin::
	mapNum=取当前地图编号()
	if(mapNum == 21016)then
		goto map21016
	elseif(mapNum == 21015)then	--忍者之家
		goto map21015
	elseif(mapNum == 21017)then
		goto map21017
	elseif(mapNum == 21018)then
		goto map21018
	elseif(mapNum == 21019)then
		goto map21019
	elseif(mapNum == 21020)then
		goto map21020
	elseif(mapNum == 21023)then	--井的底部
		goto map21023
	elseif(mapNum == 21024)then	--通路
		goto map21024
	elseif(mapNum == 21025)then	--通路
		goto map21025	
	end
	goto begin
::map21015::	
::map21016::	--忍者之家 
	if(目标是否可达(59,5))then
		移动(59,5)		
		对话选是(4)
	elseif(目标是否可达(62,13))then
		移动(62,13)		
		对话选是(2)	
	end
	goto begin
::map21017::	--忍者之家2楼
	if(目标是否可达(70,25))then
		移动(70,25)		
		对话选是(2)	
	end
	goto begin
::map21018::	--忍者之家  隐藏道路
	移动(8,10)
	goto begin
::map21019::
	移动(5,19)
	对话选是(6)
	goto begin
::map21020::
	移动(12,17)
	common.learnPlayerSkill(11,17)
	goto fini
::map21023::
	移动(19,12)
	goto begin
::map21024::
	移动(45,43)
	goto begin
::map21025::
	移动(22,26)
	goto begin
::fini::
	return
end
	
--boss map2216
--wukelan 2200
--地图:2212
--族长的家地下室 地图:2213
--打赢 地图:2214 族长的家地下室  10 11 对话11 11
--小助的家 地图:2223 7 6  对话  7 5
--地图:2224  
--地图:2225
--地图:2250 
--地图:2251 2252  7 4 对话 73
function boss()
::begin::
	mapNum=取当前地图编号()
	if(mapNum == 2212)then
		goto map2212
	elseif(mapNum == 21016)then
		goto map21016
	elseif(mapNum == 2213)then
		goto map2213
	elseif(mapNum == 2214)then
		goto map2214	
	elseif(mapNum == 2216)then	--族长的家地下室
		goto map2216
	elseif(mapNum == 21017)then
		goto map21017
	elseif(mapNum == 21018)then
		goto map21018
	elseif(mapNum == 21019)then
		goto map21019
	elseif(mapNum == 21020)then
		goto map21020
	end
	goto begin
::map2212::
	if(取物品数量("岚之秘传书") > 0)then	
		移动(11,7)
		转向坐标(11,6)
		喊话("忍者...",2,3,5)
	elseif(取物品数量("忍者推荐信") > 0)then
		移动(2,22,"乌克兰")
		return
	else
		移动(10,11)
		转向(2)
		喊话("毒...",2,3,1)
		对话选否(11,11)
	end	
	goto begin
::map2213::
	移动(10,11)
	转向(2)
	喊话("毒...",2,3,1)
	对话选否(11,11)
	goto begin
::map2214::			--打完 有 岚之秘传书
	转向(2)
	if(取物品数量("岚之秘传书") >0)then
		移动(7,8,"2212")		
	end
::map2216::		--组队 8 11  对话选是 11 11
	移动(10,11)
	
::map21016::	--忍者之家 
	if(目标是否可达(59,5))then
		移动(59,5)		
		对话选是(4)
	elseif(目标是否可达(62,13))then
		移动(62,13)		
		对话选是(2)	
	end
	goto begin
::map21017::	--忍者之家2楼
	if(目标是否可达(70,25))then
		移动(70,25)		
		对话选是(2)	
	end
	goto begin
::map21018::	--忍者之家  隐藏道路
	移动(8,10)
	goto begin
::map21019::
	移动(5,19)
	对话选是(6)
	goto begin
::map21020::
	移动(12,17)
	common.learnPlayerSkill(11,17)
	return

end

--接任务	
function step1()
	回城()
	common.gotoFaLanCity()	
	移动(102, 131,"安其摩酒吧")
	等待空闲()
::recvTask::
	if(取当前地图名() ~= "安其摩酒吧")then
		return
	end
	移动(20, 9)
	转向(2)
	dlg=等待服务器返回()		
	if(dlg.message ~=nil) then
		日志(dlg.message)
		if(string.find(dlg.message,"搜查好像已经结束了") ~= nil) then--任务完成，去大圣堂对话即可
			对话选择(32,0)
			等待服务器返回()
			对话选择(1,0)
			日志("任务已经结束，去大圣堂对话！")
			common.outCastle("n")
			移动(144,19)
			对话选是(144,18)
			日志("任务完成，现在可以去法兰南门传送到乌克兰了！",1)
			taskStep=100
			return
		end
		if(string.find(dlg.message,"你也在找心美的下落吗") ~= nil) then--初始状态
			对话选是(21,9)		
			taskStep=2
		end
		if(string.find(dlg.message,"搜查的如何啦") ~= nil) then--已经接任务 任务执行中,没有任务物品时，重置至开始
			--taskStep=1	--step不知道那步 返回
			对话选是(21,9)
			对话选是(21,9)
			taskStep=2
			return
		end
	else
		日志("对话返回空！")
		goto recvTask
	end	
end	

--酒吧判断
function step2()
	回城()
	common.gotoFaLanCity()	
	移动(219, 136,"科特利亚酒吧")
::map1101::	
	移动(17, 17)
	转向(4)
	等待服务器返回()		
	喊话("亚尔科尔...", "5", "5", "0")
	dlg=等待服务器返回()	
	if(dlg.message==nil)then
		goto map1101
	end
	日志(dlg.message)
	if(string.find(dlg.message,"亚尔科尔？") == nil) then--没有看到情报 第一步有错 返回
		taskStep=1	
		日志("没有看到亚尔科尔的信息，需要重做第一步!")
		return
	end
	对话选择(1,0)
	taskStep=3
end
--12村拿纸条
function step3()
	tryNum=0
	common.toTeleRoom("伊尔村")
	等待到指定地图("伊尔村的传送点")	
	移动(12, 17)
	等待到指定地图("村长的家")
	移动(6, 13)
	等待到指定地图("伊尔村")
	移动(32, 65)
	等待到指定地图("旧金山酒吧")	
::bar::
	if(取当前地图名() ~= "旧金山酒吧")then
		return
	end
	移动(21, 3)
	转向(2)
	等待服务器返回()	
	日志("心美...", 1)	
	dlg=等待服务器返回()	
	if(dlg.message ~= nil) then
		日志(dlg.message)
		if(string.find(dlg.message,"心美？") == nil) then--没有看到情报 上一步有错 返回		
			日志("没有看到心美的信息，需要重做上步!")
			return
		end	
	end	
	对话选择(32, 0)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(1,0)
	if(取物品数量("亚尔科尔的纸条") > 0) then
		taskStep=4
		return
	end
	if(tryNum > 3)then
		return
	end
	tryNum=tryNum+1
	goto bar
end

--拿面包
function step4()
	回城()
	common.gotoFaLanCity()		
	移动(162, 130)
	转向(2)
	等待到指定地图("法兰城",72,123)
	移动(72, 104)
	等待到指定地图("陶欧食品店")
	移动(15, 11)
	移动(12, 11)
	对话选是(0)
	--后面这个可以用来判断是否到这一步了
--	转向(0)
--	等待(2000)
--	dlg=等待服务器返回()
--	日志(dlg.message)
--	if(string.find(dlg.message,"请帮我在往伊尔村的路上找找好吗") == nil) then 
--		--步骤有问题  返回
--		return
--	end
	移动(15, 24,"法兰城")
	移动(72, 123)
	转向(2)
	等待到指定地图("法兰城",233,78)	
	移动(281, 88,"芙蕾雅")	
	local tryNum=0
::fuleiya::
	if(取当前地图名() ~= "芙蕾雅")then
		return
	end
	移动(530, 250)
	转向(2)
	等待服务器返回()
	喊话("亚尔科尔...", 5, 5, 0)
	等待服务器返回()
	对话选择(4, 0)
	等待服务器返回()
	对话选择(1,0)
	等待(5000)
	if(取物品数量("陶欧食品店精制面包") > 0)then
		taskStep = 5
		return
	end
	if(tryNum > 3)then
		日志("上一步有问题，返回！",1)
		return
	end
	tryNum=tryNum+1
	goto fuleiya
end

--拿点心
function step5()
	common.toTeleRoom("伊尔村")
	等待到指定地图("伊尔村的传送点")	
	移动(12, 17)
	等待到指定地图("村长的家")
	移动(6, 13)
	等待到指定地图("伊尔村")	
	移动(32, 65)
	等待到指定地图("旧金山酒吧")	
	移动(21, 3)
	对话选是(2)	
	if(取物品数量("亚尔科尔的点心") > 0)then
		taskStep = 6
		return
	end
	日志("上一步有问题，返回！",1)
	return
end
--拿毒
function step6()
	回城()	
	common.outCastle("e")	
	移动(196, 33,"别室")
	移动(5, 9)
	移动(8, 6)
	喊话("毒...", "5", "5", "0")
	对话选择(1,0)
	回城()	
	common.toCastle("f2")		
	移动(0, 74,"图书室")
	移动(18, 28)
	喊话("毒...", 5, 5, 0)
	等待服务器返回()
	对话选择(32, 0)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(1,0)
	等待(5000)
	if(取物品数量("杀人用的毒") > 0) then
		taskStep=7
	else
		日志("未获得杀人用的毒，步骤有误！",1)
	end
end
function step7()
	if(取当前地图名()=="图书室")then
		移动(29, 19,"里谢里雅堡 2楼")	
		移动(49, 80,"里谢里雅堡 1楼")	
		移动(45, 20,"启程之间")	
		移动(44, 44)
		转向(0, "")
		等待服务器返回()
		对话选择(4,0)
	else
		common.toTeleRoom("圣拉鲁卡村")
	end
	等待到指定地图("圣拉鲁卡村的传送点")	
	移动(7, 3,"村长的家")
	移动(2, 9,"圣拉鲁卡村")	
	移动(37, 50,"医院")	
	移动(10, 13)
	喊话("毒...", "5", "5", "0")
	等待服务器返回()
	对话选择(1,0)
	喊话("岚...", "5", "5", "0")
	等待服务器返回()
	对话选择(1,0)	
	回城()
	common.toCastle("f2")		
	移动(0, 74,"图书室")
	移动(18, 28)
	喊话("毒...", "5", "5", "0")
	等待服务器返回()
	对话选择(1,0)
	喊话("岚...", "5", "5", "0")
	等待服务器返回()
	对话选择(1,0)
	回城()
	common.outCastle("e")	
	移动(196, 33,"别室")
	移动(5, 9)
	移动(8, 6)
	喊话("毒...", "5", "5", "0")
	等待服务器返回()
	对话选择(1,0)
	喊话("岚...", "5", "5", "0")
	等待服务器返回()
	对话选择(1,0)
	taskStep=8
end

function main()
	--判断
	if(taskStep == 0)then	--自动判断
		if(取物品数量("亚尔科尔的纸条") > 0) then
			taskStep=4
		end
		if(取物品数量("陶欧食品店精制面包") > 0)then
			taskStep = 5
		end
		if(取物品数量("亚尔科尔的点心") > 0 and 取物品数量("杀人用的毒") > 0 ) then
			taskStep=7
		elseif(取物品数量("亚尔科尔的点心") > 0 ) then --还有可能是步骤8 先当6处理
			taskStep=6
		end
	end
	
::begin::	
	if(taskStep==1) then	
		step1()
	elseif(taskStep==2) then		
		step2()
	elseif(taskStep==3) then		
		step3()
	elseif(taskStep==4) then		
		step4()
	elseif(taskStep==5) then		
		step5()
	elseif(taskStep==6) then		
		step6()	
	elseif(taskStep==7) then		
		step7()
	elseif(taskStep==8) then		
		--goto last
		common.toTeleRoom("维诺亚村")
		移动(5, 1,"村长家的小房间")	
		移动(0, 5,"村长的家")	
		移动(10, 16,"维诺亚村")	
		goto mapCheck
	else
		goto mapCheck
	end		
	goto begin
	
	
	
::mapCheck::
	mapNum=取当前地图编号()
	if(mapNum == 100)then		--芙蕾雅
		goto map100
	elseif(mapNum == 2199)then	--维诺亚村
		移动(5, 1,"村长家的小房间")	
	elseif(mapNum == 2198)then	--维诺亚村
		移动(0, 5,"村长的家")	
	elseif(mapNum == 2112)then	--维诺亚村
		移动(10, 16,"维诺亚村")	
	elseif(mapNum == 2100)then	--维诺亚村
		goto map2100
	elseif(mapNum == 2200)then	--乌克兰
		goto map2200
	elseif(mapNum == 2212)then	--村长的家
		goto map2212
	elseif(mapNum == 2213)then	--族长的家地下室
		goto map2213
	elseif(mapNum == 2220)then	--民家
		goto map2220	
	elseif(mapNum == 2223)then	--小助的家
		goto map2223	
	elseif(mapNum == 2224)then	--小助的家
		goto map2224
	elseif(mapNum == 2225)then	--小助的家
		goto map2225
	elseif(mapNum == 2226)then	--小助的家
		goto map2226
	elseif(mapNum >= 2250 and mapNum <= 2259)then	--小助的家
		goto map2250	
	elseif(mapNum == 21014)then	--忍者之家
		goto map21014
	elseif(mapNum == 21015)then	--忍者之家
		goto map21015
	elseif(mapNum == 21017)then	--忍者之家2楼
		goto map21017
	elseif(mapNum == 21023)then	--井的底部
		goto map21023
	elseif(mapNum == 21024)then	--通路
		goto map21024
	elseif(mapNum == 21025)then	--通路
		goto map21025
	elseif(mapNum == 21050)then	--忍者的隐居地
		goto map21050
	elseif(mapNum == 21051)then	--小路
		goto map21051
	else
		--common.toTeleRoom("维诺亚村")
	end		
	goto mapCheck
	
::map100::		--芙蕾雅
	if(目标是否可达(352, 382))then	--去乌克兰
		移动(352, 382)
		转向(0)
		等待服务器返回()
		喊话("乌克兰...", "5", "5", "0")
		等待服务器返回()
		对话选择(32, 0)
		等待服务器返回()
		对话选择(1,0)
	end
	if(目标是否可达(354, 367))then
		移动(354, 367,"小路")	
	end
	goto mapCheck
::map2100::
	if(取物品数量("亚尔科尔的点心") >0)then
		移动(49, 64)
		转向(2)
		喊话("心美...", "5", "5", "0")
		等待服务器返回()
		对话选择(1,0)	
		移动(37, 52,"民家")
		移动(13, 5)
		转向(2)
		喊话("心美...", "5", "5", "0")
		等待服务器返回()
		对话选择(1,0)
		等待到指定地图("地下室")	
		移动(8, 10)
		对话选是(2)
		对话选是(2)
		移动(4, 10)
		移动(4, 9,"民家")
		移动(3, 9,"维诺亚村")	
		移动(67, 47,"芙蕾雅")	
	else
		移动(67, 47,"芙蕾雅")	
	end	
	goto mapCheck
::map2200::		--乌克兰 这部分是线性的 判断依据
	if(取物品数量("忍者推荐信") > 0)then
		移动(46, 22,"小助的家")	
	else
		移动(77, 47,"民家")	
		移动(8, 6)
		喊话("毒...", "5", "5", "0")
		对话选择(1,0)
		移动(1, 10,"乌克兰")	
		移动(69, 28,"村长的家")	
		移动(16, 9,"族长的家地下室")	--2213
		boss()	
	end
	goto mapCheck

::map2212::		--村长的家
	if(取物品数量("忍者推荐信") > 0)then
		移动(2,22,"乌克兰")
	elseif(取物品数量("岚之秘传书") > 0)then
		移动(11,7)
		转向坐标(11,6)
		喊话("忍者...",2,3,5)
	else
		移动(16, 9,"族长的家地下室")
	end			
	goto mapCheck
::map2213::		--族长的家地下室
	boss()
	goto mapCheck
::map2220::		--民家
	移动(8, 6)
	喊话("毒...", "5", "5", "0")
	对话选择(1,0)
	移动(1, 10,"乌克兰")	
	goto mapCheck
::map2223::
	if(取物品数量("忍者推荐信") <1)then
		日志("没有忍者推荐信，脚本结束",1)
		return
	end
	移动(7,6)	
	对话选是(0)
	goto mapCheck
::map2224::
::map2225::
	移动(7,6)	
	对话选是(0)
	goto mapCheck
::map2226::
	if(人物("职业") == "忍者")then
		日志("转职忍者完成,去学暗杀",1)
		移动(6,15,"乌克兰")
		移动(90,84,21025)
		移动(22,26,21024)
		移动(45,43,21023)
		移动(19,12,21015)		
		学暗杀()
		return
	end
	移动(7,5)	
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
	goto mapCheck
::map2250::
::map2251::
::map2252::
::map2253::
::map2254::
::map2255::
::map2256::
::map2257::
::map2258::
::map2259::		--白天和黑夜坐标位置不一样，懒得判断时间了，直接判断坐标
	unitData=取周围信息()
	qusu=nil
	zuozhu=nil
	for i,u in ipairs(unitData) do
		if(u.model_id == 10416)then
			qusu=u	
		elseif(u.model_id == 14004)then
			zuozhu=u
		end
	end
	if(qusu ~= nil)then
		移动到目标附近(qusu.x,qusu.y)
		转向坐标(qusu.x,qusu.y)
		dlg=等待服务器返回()
		if(dlg ~= nil )then
			for q,a in pairs(answer) do
				if(string.find(dlg.message,q) ~= nil)then
					if(zuozhu~= nil) then
						移动到目标附近(zuozhu.x,zuozhu.y)
						转向坐标(zuozhu.x,zuozhu.y)
						喊话(a,2,3,5)
						等待(2000)
						break
					end
				end
			end		
		end
	end	
	goto mapCheck
	
	
::map21014::	--忍者之家
	移动(13,20)	
	转向(0)
	等待服务器返回()
	对话选择(4, 0)	
	goto mapCheck
::map21015::	--忍者之家
	移动(63, 38)	
	转向(2)
	等待服务器返回()
	对话选择(4, 0)
	goto mapCheck
::map21017::	--忍者之家2楼
	移动(37,19)		
	goto mapCheck
::map21023::	--井的底部
	移动(7, 4,21024)		
	goto mapCheck
::map21024::	--通路
	移动(22, 26,21025)		
	goto mapCheck
::map21025::	--通路	
	移动(5, 15,"乌克兰")	
	goto mapCheck
::map21050::	--忍者的隐居地
	移动(19, 9,"忍者之家")	
	goto mapCheck
::map21051::	--小路
	移动(46, 23,"忍者的隐居地")	
	goto mapCheck
::last::		
	回城()
	等待(1000)
	等待到指定地图("艾尔莎岛")
	转向(1, "")
	等待服务器返回()
	对话选择(4,0)
	等待到指定地图("里谢里雅堡")	
	移动(41, 50)
	等待到指定地图("里谢里雅堡 1楼")	
	移动(45, 20)
	等待到指定地图("启程之间")	
	移动(8, 23)
	转向(0, "")
	等待服务器返回()
	对话选择(4,0)
	等待到指定地图("维诺亚村的传送点")
	移动(5, 1)
	等待到指定地图("村长家的小房间")	
	移动(0, 5)
	等待到指定地图("村长的家")	
	移动(10, 16)
	等待到指定地图("维诺亚村")	
	移动(49, 64)
	转向(2)
	喊话("心美...", "5", "5", "0")
	等待服务器返回()
	对话选择(1,0)	
	移动(37, 52)
	等待到指定地图("民家")
	移动(13, 5)
	转向(2)
	喊话("心美...", "5", "5", "0")
	等待服务器返回()
	对话选择(1,0)
	等待到指定地图("地下室")	
	移动(8, 10)
	对话选是(2)
	对话选是(2)
	移动(4, 10)
	移动(4, 9)
	等待到指定地图("民家")	
	移动(3, 9)
	等待到指定地图("维诺亚村")	
	移动(67, 47)
	等待到指定地图("芙蕾雅")	
	移动(352, 382)
	转向(0)
	等待服务器返回()
	喊话("乌克兰...", "5", "5", "0")
	等待服务器返回()
	对话选择(32, 0)
	等待服务器返回()
	对话选择(1,0)
	等待到指定地图("芙蕾雅")	
	移动(354, 367)
	等待到指定地图("小路")	
	移动(46, 23)
	等待到指定地图("忍者的隐居地")	
	移动(19, 9)
	等待到指定地图("忍者之家")	
	移动(13, 20)
	转向(0, "")
	等待服务器返回()
	对话选择(4,0)
	等待到指定地图("忍者之家2楼")	
	移动(37, 19)
	等待到指定地图("忍者之家")		
	移动(63, 38)
	转向(2)
	等待服务器返回()
	对话选择(4, 0)
	等待到指定地图("井的底部")	
	移动(7, 4)
	等待到指定地图(21024)	
	移动(22, 26)
	等待到指定地图(21025)	
	移动(11, 11)
	移动(5, 15,"乌克兰")	
	移动(77, 47)
	等待到指定地图("民家")	
	移动(8, 6)
	喊话("毒...", "5", "5", "0")
	对话选择(1,0)
	移动(1, 10)
	等待到指定地图("乌克兰")	
	移动(69, 28)
	等待到指定地图("村长的家")	
	移动(16, 9)
	等待到指定地图("族长的家地下室")
	boss()
	学暗杀()
end
main()

