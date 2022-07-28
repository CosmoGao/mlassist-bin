过海班车脚本


补魔值 = 200
补血值=300
班车间隔时间 = 30	--30秒

班车发车时间=os.time()
function main()
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	if (当前地图名 =="艾尔莎岛" )then goto aiersa
	elseif(当前地图名 ==  "里谢里雅堡")then goto LiBao 		
	elseif(当前地图名 ==  "索奇亚海底洞窟 地下1楼")then goto panDuanZuoBiao 		
	elseif(当前地图名 ==  "奇利村的传送点")then goto qlcsd 		
	elseif(当前地图名 ==  "奇利村")then goto qlc 		
	elseif(当前地图名 ==  "索奇亚")then goto suoqiya 		
	end	
	回城()
	等待(1000)
	goto begin
::aiersa::
	等待到指定地图("艾尔莎岛")
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
::LiBao::
	等待到指定地图("里谢里雅堡")	
	自动寻路(34,89)
	回复(1)			-- 转向北边恢复人宠血魔
    自动寻路(41, 50,"里谢里雅堡 1楼")		
	自动寻路(45, 20,"启程之间")			
	自动寻路(8, 33)
	对话选是(8,32)
::qlcsd::
	等待到指定地图("奇利村的传送点")		
    自动寻路(7, 6,"3214")		
    自动寻路(7, 1,"3212")		
	自动寻路(1, 8,"奇利村")	
::qlc::
    自动寻路(59, 45,"索奇亚")	
::suoqiya::
	自动寻路(240,265,"索奇亚海底洞窟 地下1楼")	
	自动寻路(8,42)
	自动寻路(7,42)
	转向(0)
	等待服务器返回()
	对话选择(4,0)	
	等待到指定地图("索奇亚海底洞窟 地下1楼", 7,39)	
	goto tgtStart
::panDuanZuoBiao::
	if(目标是否可达(7,37))then
		goto tgtStart
	end
::tgtStart::
	自动寻路(7,37)
	班车发车时间=os.time()	
::scriptstart::	
	if(人物("魔") < 补魔值)then goto buxue end		
	if(人物("血") < 补血值)then goto buxue end	
	if(取队伍人数() >= 5)then	
		日志("人满过海",1)
		goto guoHai
	end	

	已过时间=os.time() - 班车发车时间	
	发车剩余时间=班车间隔时间 - 已过时间
	
	if(发车剩余时间 <= 0)then 
		if(取队伍人数() > 1)then
			goto guoHai
		else	
			日志("队伍没有人，进行下一班班车轮询")
			班车发车时间=os.time()	
		end
	end
	喊话("过海班车，30秒一趟，下次过海还剩"..发车剩余时间.."秒需要过海+++++++",2,3,5)
	if(发车剩余时间 < 5)then
		等待(1000)
		goto scriptstart 
	end
	等待(5000)
	goto scriptstart  
::guoHai::
	自动寻路(7,37)
	对话选是(2)
	等待空闲()
	if(取当前地图名() == "索奇亚")then
		喊话("过海完成，剩余路自己走哦~",2,3,5)
		离开队伍()
		自动寻路(239,265)
		goto suoqiya
	end
	goto guoHai
::buxue::
	自动寻路(7,37)
	对话选是(2)	
	等待空闲()
	if(取当前地图名() ~= "索奇亚")then	
		goto buxue
	end
	自动寻路(274, 294,"奇利村")
	自动寻路(64, 56,"医院")
	自动寻路(11,6)
	回复(0)
	自动寻路(3,9,"奇利村")
	goto qlc
end
main()