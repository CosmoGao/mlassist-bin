偷改狗材料脚本  人物我设置的是10级窃盗  宠物要有5级树海护卫 要偷4次才会跑 宝宝血满3500一般不会受伤  不行的一次偷一个脚本


common=require("common")

function 去治疗()
	转向(2)
	加入队伍("")	
	tryNum=1
	while (取队伍人数() > 1 and tryNum < 10) do
		if(人物("健康") == 0)then
			开关(2,0)		--0战 1聊 2队 3名 4易 5家 100公共 101摆摊
			离开队伍()
			return
		end	
		tryNum = tryNum+1
		等待(2000)
	end
end
function main()	
	补魔值 = 300--用户输入框("多少魔以下补魔", "50")
	补血值=1500--用户输入框("多少血以下补血", "430")
	宠补血值=2500--用户输入框( "宠多少血以下补血", "50")
	宠补魔值=300--用户输入框( "宠多少魔以下补血", "100")	
	
::begin::
	等待空闲()
	if(人物("健康") > 0)then
		common.checkHealth()
		goto begin
--		去治疗()
	end	
	if(人物("金币") < 10000)then
		common.getMoneyFromBank(-500000)				
	end
	当前地图名 = 取当前地图名()
	mapNum = 取当前地图编号()
	if (当前地图名=="艾尔莎岛" )then	
		goto aiersa  
	elseif (当前地图名=="伊尔村" )then	
		goto hunt  			
	elseif(当前地图名=="里谢里雅堡") then
		goto start
	elseif(mapNum == 1112)then --东医院
		回城()		
		goto begin
	elseif(当前地图名=="医院") then
		goto yiyuan
	end
	回城()
	goto  begin
::aiersa::
	等待到指定地图("艾尔莎岛", 1)
	自动寻路(140,105)
	转向(1)
	等待服务器返回()	
	对话选择(4, 0)
	等待到指定地图("里谢里雅堡", 1)
	等待(500)
	
	自动寻路(30,90)
	自动寻路(34,90)
	自动寻路(34,89)
	renew(1)	
	
	goto  start
::start::	
	自动寻路(41, 50)	
	等待到指定地图("里谢里雅堡 1楼", 1)	
    自动寻路(45, 20)	
	等待到指定地图("启程之间", 1)
	自动寻路(44, 33)	
	转向(0)
	等待服务器返回()	
	对话选择(4, 0)
	等待到指定地图("伊尔村的传送点", 1)	
	等待(1000)    
	自动寻路(12, 17)
	等待到指定地图("村长的家", 1)
	自动寻路(6, 13)	
	等待到指定地图("伊尔村", 1)		
	goto  hunt
	
::hunt::
	等待(1000)
	等待到指定地图("伊尔村", 1)	
	自动寻路(32,45)
	转向(6)
	等待服务器返回()	
	对话选择("4", "", "")   
	等待服务器返回()	
	对话选择("8", "", "")           -- 8代表选否
	等待服务器返回()	
	对话选择("8", "", "")           -- 8代表选否
	等待服务器返回()	
	对话选择("8", "", "")           -- 8代表选否
	等待服务器返回()	
	对话选择("4", "", "")  
	等待(2000)
::yudi::
	if (人物("血") < 补血值 )then		
		goto  ting
	elseif (人物("魔") < 补魔值 )then	
		goto  ting
	elseif (宠物("血") < 宠补血值 )then	
		goto  ting
	elseif (宠物("魔") < 宠补魔值 )then	
		goto  ting
	elseif(取包裹空格() < 1)then
		goto  bank
	elseif(是否战斗中() == false)then
		goto  hunt	
	end	
	等待(2000)
	goto  yudi
::ting::		
	等待战斗结束()
	等待到指定地图("伊尔村", 1)
	自动寻路(52,39)	
::yiyuan::
	等待到指定地图("医院", 1)		
	自动寻路(10,15)
	renew(0)			-- 转向北边恢复人宠血魔
	if(人物("健康") > 0)then
		common.checkHealth()
		goto begin
--		去治疗()
	elseif(取队伍人数() > 1)then
		离开队伍()
	end
	if(人物("金币") < 10000)then
		common.getMoneyFromBank(-500000)				
	end
	自动寻路(14,20)
	等待到指定地图("伊尔村", 1)
	自动寻路(46,45)
	自动寻路(32,45)
	goto  hunt	
::bank::
	回城()
	等待(2000)
	当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		自动寻路(157,94)	
		转向坐标(158,93)		
		等待到指定地图("艾夏岛")	
		自动寻路(114,105)	
		自动寻路(114,104)	
		goto  aiBank
	end
::aiBank::
	等待到指定地图("银行")	
	自动寻路(49,30)
	面向("东")
	银行("全存","豪克爱犬的毛")
	银行("全存","豪克爱犬的牙")
	银行("全存","豪克爱犬的爪")
	银行("全存","豪克爱犬的眼")	
	银行("全存","身体的一部份？")		
	if(取包裹空格() < 1)then
		goto  manle
	end
	回城()
	goto  begin
::manle::
	喊话("包裹满了，清理后执行",2,3,5)
	等待(12000)
	goto  manle
end
main()