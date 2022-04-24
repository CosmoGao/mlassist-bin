艾岛启动，抽技能草，自己吃

local 卖物品列表 ="卡片？|绿头盔|红头盔|赖光的头盔|中型的土之宝石|中型的水之宝石|中型的火之宝石|中型的风之宝石|魔石"
local 捡物品列表 ="卡片？|绿头盔|红头盔|赖光的头盔|中型的土之宝石|中型的水之宝石|中型的火之宝石|中型的风之宝石|魔石|生命力回复药（75）"

--设置("自动扔",1,"艾夏糖")
--设置("自动扔",1,"家族兽之笛")
--设置("自动扔",1,"串烧哥布林")
--设置("自动扔",1,"生命力回复药（75）")

设置("timer",100)
身上最少金币=5000			--少于去取
身上最多金币=950000			--大于去存
身上预置金币=200000			--取和拿后 身上保留金币

function main()		
::begin::
	等待空闲()
	common.checkGold(身上最少金币,身上最多金币,身上预置金币)
	当前地图名=取当前地图名()
	mapNum=取当前地图编号()
	if(当前地图名=="艾尔莎岛")then
		goto aiersha	
	elseif (当前地图名=="利夏岛" )then	
		goto map59522
	elseif (当前地图名=="国民会馆" )then	
		goto map59552
	elseif (当前地图名=="雪拉威森塔１层" )then	
		goto map59801
	elseif (当前地图名=="雪拉威森塔２５层" )then	
		goto map59825	
	end
	等待(1000)
	回城()
	goto begin 
::aiersha::	
	if(取包裹空格() <6)then		
		common.toCastle()
		移动(40, 98,"法兰城")	
		移动(150, 123)
		卖(0,卖物品列表)	
		goto begin
	end
	移动(165, 153)
	转向(4)
	等待服务器返回()
	对话选择(32,0)
	等待服务器返回()
	对话选择(4, 0)		
::map59522::					--利夏岛
	if(取当前地图名() ~= "利夏岛")then
		goto begin
	end
	移动(90,99,"国民会馆")
::map59552::					--国民会馆
	移动(108,39,"雪拉威森塔１层")
	goto begin
::map59801::					--雪拉威森塔１层
	移动(76,52,"雪拉威森塔２５层")		
	goto begin
	
::map59825::
	移动(95,34)
	周围捡物()
	while(取物品数量("生命力回复药（75）") > 0) do
		使用物品("生命力回复药（75）")	
		--等待菜单返回()
		菜单选择(0,"")
		菜单项选择(0,"")
	end
	if(取包裹空格() <1)then
		回城()
		common.toCastle()
		移动(40, 98,"法兰城")	
		移动(150, 123)
		卖(0,卖物品列表)	
		等待(1000)
		卖(0,卖物品列表)	
		
	end
	goto begin
end
function 周围捡物()
	local mapUnit=nil
::begin::
	mapUnit = 取周围信息()
	if(mapUnit ~= nil)then
		for i,v in ipairs(mapUnit) do
			if(string.find(捡物品列表,v.item_name) ~= nil)then
				移动到目标附近(v.x,v.y)
				转向坐标(v.x,v.y)
			end
			if(取包裹空格() <1)then
				return
			end
		end
	end	
	goto begin
end

main()