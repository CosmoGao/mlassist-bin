★捉潜盾脚本，起点哥拉尔登入点 请设置好自动战斗,战斗1中设置好遇一级宠时的战斗方法 ::战斗2设置好宠物满下线保护，谢谢支持魔力辅助程序.脚本发现BUG联系Q::274100927-----------星落

common=require("common")

设置("timer", 100)						

设置("自动战斗",1)
设置("高速战斗", 1)
设置("高速延时",1)
local 卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶|口袋龙的卡片|地狱看门犬的卡片"		--可以增加多个 不影响速度
local 人补魔=用户输入框( "人多少魔以下补魔", "50")
local 人补血=用户输入框( "人多少血以下补血", "300")
local 宠补魔=用户输入框( "宠多少魔以下补魔", "50")
local 宠补血=用户输入框( "宠多少血以下补血", "200")	
local 自动换水火的水晶耐久值 = 用户输入框("自动换水晶耐久值", "30")
local 封印卡数量=40
local 封印卡名称="封印卡（金属系）"
设置("自动叠",1,封印卡名称.."&20")


function main()
	清除系统消息()
	停止遇敌()	
	local mapName=""
	local mapNum=0
::begin::
	等待空闲()
	mapName = 取当前地图名()
	mapNum = 取当前地图编号()
	if(mapName == "库鲁克斯岛")then goto kaishi 		--43000
	elseif(mapName == "哥拉尔镇")then goto map43100
	else
		回城()
		goto begin
	end
	等待(2000)
	goto begin 
::map43100::		--哥拉尔镇
	common.gleCheckSaelCard(封印卡名称,封印卡数量)
	common.gleSellItems(卖店物品列表)
	common.gleCheckHealth()
	common.gleSupply()
	common.toGle()
	自动寻路(119, 38,"库鲁克斯岛")
	goto begin
::kaishi::
	自动寻路(153, 405)	
	开始遇敌()       
	goto scriptLoop 
::scriptLoop::
	if(人物("魔") < 人补魔)then goto  ting end		-- 魔小于100
	if(人物("血") < 人补血)then goto  ting end
	if(宠物("血") < 宠补血)then goto  ting end
	if(宠物("魔") < 宠补魔)then goto  ting end
	if(取物品叠加数量(封印卡名称) < 1)then goto  ting end	
	if (人物("宠物数量") >= 5 )then	
		日志("宠物数量满了，回城存储！")
		goto ting	
	end
	if( 人物("灵魂") > 0 )then
		goto  ting 
	end
	等待(3000)
	goto scriptLoop 					
::ting::
	停止遇敌()
	等待空闲()
	回城()
	goto begin
	
end
main()