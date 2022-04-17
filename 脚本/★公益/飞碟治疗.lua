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
	移动(140,105)
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
::LiBao::
	等待到指定地图("里谢里雅堡")	
	移动(34,89)
	回复(1)			-- 转向北边恢复人宠血魔
    移动(28, 85)  
	goto scriptstart
::scriptstart::	
	工作("治疗",4)     
	if(人物("魔") < 补魔值)then goto LiBao end		
	if(取当前地图名() ~= "里谢里雅堡") then goto begin end
	common.checkGold(身上最少金币,身上最多金币,身上预置金币)
	等待(2000)
	goto scriptstart  
end
main()