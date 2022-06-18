★神兽队长脚本，起点艾尔莎岛登入点，根据提示执行脚本。

common=require("common")
水晶名称="水火的水晶（5：5）"

是否学超补=1
是否学超恢=1
设置("遇敌全跑",1)

	等待空闲()
	common.checkHealth()
	common.checkCrystal(水晶名称)
	--回城()
	common.supplyCastle()
	common.sellCastle()		--默认卖
::begin::
	等待空闲()
	等待(2000)
	if(取当前地图名() ==  "艾尔莎岛")then goto  aiersa end
	if(取当前地图名() ==  "里谢里雅堡")then goto liBao end
	if(取当前地图名() ==  "杰诺瓦镇")then goto quYiYuan end
	if(取当前地图名() ==  "杰诺瓦镇的传送点")then goto jnwcf end
	if(取当前地图名() ==  "医院2楼")then goto quShenShouw end
	if(取当前地图名() ==  "医院")then goto yiYuan end
	if(取当前地图名() ==  "莎莲娜")then goto shaLianLa end
	if(取当前地图名() ==  "静谧之间" and 取当前地图编号() == 16512)then goto missionFini end
	if(取当前地图名() ==  "静谧之间")then goto judge end
	if(取当前地图名() ==  "启程之间")then goto warproom end--15508
	if(取当前地图名() ==  "入口")then goto map16510 end--15508
	-- if(取当前地图名() ==  "叹息森林")then goto naShuMiao end--15508
	if(string.find(取当前地图名(),"贝兹雷姆的迷宫")~= nil)then goto crossMaze end		
	goto begin 
::aiersa::	
	等待到指定地图("艾尔莎岛")        
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
::liBao::
	等待到指定地图("里谢里雅堡")	
	移动(34,89)
	回复(1)			-- 转向北边恢复人宠血魔
	移动(41, 50,"里谢里雅堡 1楼")
	移动(45, 20,"启程之间")
::warproom::
	移动(15, 4)	
	转向(2)
	dlg=等待服务器返回()
	if(dlg == nil)then
		goto warproom
	end
	if(string.find(dlg.message,"此传送点的资格")~=nil or string.find(dlg.message,"你不能使用这个传送石")~=nil)then
		回城()
		执行脚本("./脚本/直通车/★开传送-杰诺瓦镇.lua")
		goto jnwcf
	end	
	转向(2, "")
	等待服务器返回()
	对话选择("4", 0)
	goto jnwcf 

::jnwcf::
	等待到指定地图("杰诺瓦镇的传送点")	
	移动(14, 8)
	移动(14, 6,"村长的家")	
	移动(1, 9,"杰诺瓦镇")
	if(取物品数量("贝兹雷姆之钥") > 0) then
		移动(44, 39)
		移动(24, 39,"莎莲娜")
		goto shaLianLa
	end
::quYiYuan::
	移动(44, 33,"医院")
::yiYuan::
	移动(15, 13,"医院2楼")
	移动(10, 4)
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
::quShenShouw::
	移动(15, 9)
	移动(15, 11,"医院")	
	移动(1, 9,"杰诺瓦镇")
	移动(44, 39)
	移动(24, 39,"莎莲娜")
::shaLianLa::	
	移动(135, 334,"莎莲娜")	
	等待(1000)	 
	转向(0, "")
	等待服务器返回()
	对话选择("1", "", "")
	等待到指定地图("入口", 1)
::map16510::
	等待(1000)
	移动(25, 7)
	等待到指定地图("贝兹雷姆的迷宫1楼", 1)
	喊话("请手动穿越迷宫，不要忘记刷龙鳞!",0,0,0)
	等待(3000)        
	喊话("杀过BOSS传教士可以学习超强补血魔法，巫师可以学习强力、超强恢复魔法!",0,0,0)
	等待(7000)
	喊话("杀过BOSS必须和鸟人对话才算完成任务!",0,0,0)
	等待(5000)
-- ::wancheng::
	-- 喊话("2转晋级移动脚本到此结束，请停止脚本",0,0,0)
	-- 等待(7000)
	-- goto wancheng 
::crossMaze::	
	自动穿越迷宫("静谧之间")
	等待(3000)
	goto begin 


::judge::
	设置("遇敌全跑",0)
	if(目标是否可达(26,68) == false) then 
		goto boss
	end
	if(取物品数量("地龙的麟片") > 0) then
		移动(26, 68)
		对话选是(26,67)
		goto begin
	end
	移动(26,71)
	移动(26,72)
	goto daLinPian
::daLinPian::
	等待(2000)
	等待空闲()	
	if(string.find(取当前地图名(),"贝兹雷姆的迷宫")~= nil)then 		
		curx,cury = 取当前坐标()
		tgtx,tgty = 取周围空地(curx,cury,1)--取当前坐标3格范围内 空地
		移动(tgtx,tgty)
		等待(1000)
		开始遇敌()     
		goto caiLiaoFini
	end
::caiLiaoFini::
	if(取物品数量("地龙的麟片") > 0) then
		停止遇敌()
		移动(curx,cury,"静谧之间")
		goto judge
	end	
	if(取包裹空格() < 2)then
		扔("魔石")
		扔("地的水晶碎片")
		扔("水的水晶碎片")
		扔("火的水晶碎片")
		扔("风的水晶碎片")
	end
	等待(2000)
	goto caiLiaoFini  
::boss::
	移动(26,26)
	转向(0)
	等待(2000)
	等待空闲()
	goto begin
::missionFini::
	移动(26,12,"咒缚之帐")
	移动(14,15)
	移动(13,15)
	移动(15,15)
	对话选是(14,14)
	对话选是(14,14)
	日志("任务完成，需要学技能的下去自己学！",1)
	
	if(是否学超补==1)then
		goto chaoBu
	elseif(是否学超恢==1)then
		goto chaoHui
	else
		return
	end
::chaoBu::
	移动(14,27,"静谧之间")
	移动(13,53)
	对话选是(13,52)
::map16514::
	移动(14,5)
	转向坐标(14,4)
	等待服务器返回()
	对话选择(-1,0)
	等待服务器返回()
	对话选择(0,0)
	等待服务器返回()
	对话选择(1,0)	
	
::chaoHui::
	移动(39,52,"静谧之间")
	移动(40,52)
	对话选是(13,52)
::map16515::
	移动(11,10)
	转向坐标(11,9)
	等待服务器返回()
	对话选择(-1,0)
	等待服务器返回()
	对话选择(0,0)
	等待服务器返回()
	对话选择(1,0)	
	--强恢
	移动(15,10)
	转向坐标(15,9)
	等待服务器返回()
	对话选择(-1,0)
	等待服务器返回()
	对话选择(0,0)
	等待服务器返回()
	对话选择(1,0)	