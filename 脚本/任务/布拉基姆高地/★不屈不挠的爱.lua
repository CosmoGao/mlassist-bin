艾尔莎启动,包裹需要至少19个空


common=require("common")
设置("移动速度",120)

local 补血值=取脚本界面数据("人补血")
local 补魔值=取脚本界面数据("人补魔")
local 宠补血值=取脚本界面数据("宠补血")
local 宠补魔值=取脚本界面数据("宠补魔")
if(补血值==nil or 补血值==0)then
	补血值=用户输入框("多少血以下补血", "430")
end
if(补魔值==nil or 补魔值==0)then
	补魔值 = 用户输入框("多少魔以下补魔", "200")
end
if(宠补血值==nil or 宠补血值==0)then
	宠补血值 = 用户输入框( "宠多少血以下补血", "50")
end
if(宠补魔值==nil or 宠补魔值==0)then
	宠补魔值=用户输入框( "宠多少魔以下补魔", "50")
end
function main()	
	local mapName=""
	local mapNum=0
::begin::
	停止遇敌()
	等待空闲()	
	mapName=取当前地图名()
	mapNum=取当前地图编号()
	if(string.find(mapName,"深草绿洞")~=nil)then
		goto crossMaze
	elseif(mapNum==59715)then		--？？？
		goto map59715
	else
		common.supplyCastle()
		common.sellCastle()		--默认卖
		common.checkHealth(医生名称)
		回城()
		等待空闲()
		
		设置("遇敌全跑",1)
		自动寻路(165, 153)
		对话选否(4)
		等待到指定地图("梅布尔隘地")
		自动寻路(256, 166,"布拉基姆高地")
		自动寻路(234, 315)
		对话选是(234,314)
		自动寻路(315,213)
		设置("遇敌全跑",0)
	end
	等待(1500)
	goto begin
::crossMaze::
	自动穿越迷宫()
	goto begin
::map59715::
	if(目标是否可达(315,213))then
		自动寻路(315,213)
		设置("遇敌全跑",0)
	else
		if(取物品数量("潮湿的火柴") >= 19)then
			自动寻路(128,95)
			对话选是(129,95)
			if(common.checkTitle("不屈不挠的爱")) then
				日志("已得到【不屈不挠的爱】称号，脚本退出",1)
				return
			end
		else
			自动寻路(119,86,"深草绿洞第5层")
			local curx,cury = 取当前坐标()
			local tx,ty=取周围空地(curx,cury,2)--取当前坐标指定距离范围内 空地
			自动寻路(tx,ty)
			--遇敌
			开始遇敌()
			goto scriptstart
		end
	end
	goto begin
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end	
	if(取当前地图名() ~= "深草绿洞第5层")then	goto begin end	
	if 是否战斗中() then
		等待战斗结束()
	end			
	等待(2000)
	goto scriptstart 
::ting::
	停止遇敌()      
	等待空闲() 	
	回城()
	goto begin
end
main()

