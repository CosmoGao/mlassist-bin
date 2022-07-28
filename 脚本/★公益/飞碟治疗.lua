里堡飞碟治疗

common=require("common")

补魔值 = 100
身上最少金币=3000			--少于去取
身上最多金币=1000000		--大于去存
身上预置金币=500000			--取和拿后 身上保留金币

function main()
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	if (当前地图名 =="艾尔莎岛" )then goto aiersa
	elseif(当前地图名 ==  "里谢里雅堡")then goto LiBao 		
	end	
	回城()
	等待(1000)
	goto begin
::aiersa::
	等待到指定地图("艾尔莎岛")
	自动寻路(140,105)
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
::LiBao::
	等待到指定地图("里谢里雅堡")	
	自动寻路(34,89)
	回复(1)			-- 转向北边恢复人宠血魔
    自动寻路(28, 85)  
	common.checkGold(身上最少金币,身上最多金币,身上预置金币)	
	if(人物("金币")<人物("最大魔"))then		
		goto reqHelp	
	end
	goto scriptstart
::scriptstart::	
	--工作("治疗",4)     
	if(人物("魔") < 补魔值)then goto LiBao end		
	if(取当前地图名() ~= "里谢里雅堡") then goto begin end	
	等待(5000)
	goto scriptstart  
::reqHelp::
	if(取当前地图名() ~= "里谢里雅堡")then
		回城()
		等待到指定地图("艾尔莎岛")
		自动寻路(140,105)
		转向(1, "")
		等待服务器返回()
		对话选择("4", "", "")
		等待到指定地图("里谢里雅堡")	
		自动寻路(28, 85)  
	end	
	等待交易("","","",10000)
	if(人物("金币") > 3000)then
		日志("当前金币"..人物("金币").."超3000，开始继续提供服务",1)
		goto scriptstart
	end	
	goto reqHelp	
end
main()