--定居艾尔莎岛 请注意,要将伊尔,圣村,维村传送开好,身上没有物品情况下，会重置任务从头开始，后续需要从小道进入的，请任务完成后，去维村、汉克以及大圣堂去解任务，这里只到boss这步

common=require("common")


	
function main()
	common.toTeleRoom("维诺亚村")
	自动寻路(5, 1,"村长家的小房间")	
	自动寻路(0, 5,"村长的家")	
	自动寻路(10, 16,"维诺亚村")	
	goto mapCheck	
::mapCheck::
	mapNum=取当前地图编号()
	if(mapNum == 100)then		--芙蕾雅
		goto map100
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
	end		
	goto mapCheck
	
::map100::		--芙蕾雅
	if(目标是否可达(352, 382))then	--去乌克兰
		自动寻路(352, 382)
		转向(0)
		等待服务器返回()
		喊话("乌克兰...", "5", "5", "0")
		等待服务器返回()
		对话选择(32, 0)
		等待服务器返回()
		对话选择(1,0)
	end
	if(目标是否可达(354, 367))then
		自动寻路(354, 367,"小路")	
	end
	goto mapCheck
::map2100::
	if(取物品数量("亚尔科尔的点心") >0)then
		自动寻路(49, 64)
		转向(2)
		喊话("心美...", "5", "5", "0")
		等待服务器返回()
		对话选择(1,0)	
		自动寻路(37, 52,"民家")
		自动寻路(13, 5)
		转向(2)
		喊话("心美...", "5", "5", "0")
		等待服务器返回()
		对话选择(1,0)
		等待到指定地图("地下室")	
		自动寻路(8, 10)
		对话选是(2)
		对话选是(2)
		自动寻路(4, 10)
		自动寻路(4, 9,"民家")
		自动寻路(3, 9,"维诺亚村")	
		自动寻路(67, 47,"芙蕾雅")	
	else
		自动寻路(67, 47,"芙蕾雅")	
	end	
	goto mapCheck
::map2200::		--乌克兰 这部分是线性的 判断依据
	自动寻路(46, 22,"民家")		
	goto mapCheck

::map2212::		--村长的家
	自动寻路(16, 9,"族长的家地下室")	
	goto mapCheck
::map2213::		--族长的家地下室
	boss()
	goto mapCheck
::map2220::		--民家
	自动寻路(8, 6)
	喊话("毒...", "5", "5", "0")
	对话选择(1,0)
	自动寻路(1, 10,"乌克兰")	
	goto mapCheck
::map2223::
	if(取物品数量("忍者推荐信") <1)then
		日志("没有忍者推荐信，脚本结束",1)
		return
	end

::map21014::	--忍者之家
	自动寻路(13,20)	
	转向(0)
	等待服务器返回()
	对话选择(4, 0)	
	goto mapCheck
::map21015::	--忍者之家
	自动寻路(63, 38)	
	转向(2)
	等待服务器返回()
	对话选择(4, 0)
	goto mapCheck
::map21017::	--忍者之家2楼
	自动寻路(37,19)		
	goto mapCheck
::map21023::	--井的底部
	自动寻路(7, 4,21024)		
	goto mapCheck
::map21024::	--通路
	自动寻路(22, 26,21025)		
	goto mapCheck
::map21025::	--通路	
	自动寻路(5, 15,"乌克兰")	
	goto mapCheck
::map21050::	--忍者的隐居地
	自动寻路(19, 9,"忍者之家")	
	goto mapCheck
::map21051::	--小路
	自动寻路(46, 23,"忍者的隐居地")	
	goto mapCheck
::last::		
	回城()
	等待(1000)
	等待到指定地图("艾尔莎岛")
	转向(1, "")
	等待服务器返回()
	对话选择(4,0)
	等待到指定地图("里谢里雅堡")	
	自动寻路(41, 50)
	等待到指定地图("里谢里雅堡 1楼")	
	自动寻路(45, 20)
	等待到指定地图("启程之间")	
	自动寻路(8, 23)
	转向(0, "")
	等待服务器返回()
	对话选择(4,0)
	等待到指定地图("维诺亚村的传送点")
	自动寻路(5, 1)
	等待到指定地图("村长家的小房间")	
	自动寻路(0, 5)
	等待到指定地图("村长的家")	
	自动寻路(10, 16)
	等待到指定地图("维诺亚村")	
	自动寻路(49, 64)
	转向(2)
	喊话("心美...", "5", "5", "0")
	等待服务器返回()
	对话选择(1,0)	
	自动寻路(37, 52)
	等待到指定地图("民家")
	自动寻路(13, 5)
	转向(2)
	喊话("心美...", "5", "5", "0")
	等待服务器返回()
	对话选择(1,0)
	等待到指定地图("地下室")	
	自动寻路(8, 10)
	对话选是(2)
	对话选是(2)
	自动寻路(4, 10)
	自动寻路(4, 9)
	等待到指定地图("民家")	
	自动寻路(3, 9)
	等待到指定地图("维诺亚村")	
	自动寻路(67, 47)
	等待到指定地图("芙蕾雅")	
	自动寻路(352, 382)
	转向(0)
	等待服务器返回()
	喊话("乌克兰...", "5", "5", "0")
	等待服务器返回()
	对话选择(32, 0)
	等待服务器返回()
	对话选择(1,0)
	等待到指定地图("芙蕾雅")	
	自动寻路(354, 367)
	等待到指定地图("小路")	
	自动寻路(46, 23)
	等待到指定地图("忍者的隐居地")	
	自动寻路(19, 9)
	等待到指定地图("忍者之家")	
	自动寻路(13, 20)
	转向(0, "")
	等待服务器返回()
	对话选择(4,0)
	等待到指定地图("忍者之家2楼")	
	自动寻路(37, 19)
	等待到指定地图("忍者之家")		
	自动寻路(63, 38)
	转向(2)
	等待服务器返回()
	对话选择(4, 0)
	等待到指定地图("井的底部")	
	自动寻路(7, 4)
	等待到指定地图(21024)	
	自动寻路(22, 26)
	等待到指定地图(21025)	
	自动寻路(11, 11)
	自动寻路(5, 15,"乌克兰")	
	自动寻路(77, 47)
	等待到指定地图("民家")	
	自动寻路(8, 6)
	喊话("毒...", "5", "5", "0")
	对话选择(1,0)
	自动寻路(1, 10)
	等待到指定地图("乌克兰")	
	自动寻路(69, 28)
	等待到指定地图("村长的家")	
	自动寻路(16, 9)
	等待到指定地图("族长的家地下室")	
end
main()

