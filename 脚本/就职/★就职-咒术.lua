★定居艾尔莎岛，。

common=require("common")
设置("遇敌全跑",1)

function main()
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)   
::begin::
	等待空闲()
	if(取物品数量( "神器·紫念珠") >  0)then goto  jidi end
	if(取物品数量( "咒器·红念珠") <  1)then goto  jidi end
	mapName=取当前地图名()
	mapNum=取当前地图编号()	
	if(mapNum == 21005)then goto map21005
	elseif(mapNum == 21006)then goto map21006
	elseif(mapNum == 21007)then goto map21007	
	elseif(mapNum == 21008)then goto map21008
	elseif(mapNum == 21009)then goto map21009
	elseif(mapNum == 21010)then goto map21010
	elseif(mapNum == 21011)then goto map21011	
	end	
	if(取物品数量( "咒器·红念珠") >  0)then goto  tohaozhai end
	回城()	
	等待(2000)
	goto begin
::jidi::
	common.toTeleRoom("杰诺瓦镇")	
    自动寻路(6, 8)
	自动寻路(14, 8)	
	自动寻路(14, 6,"村长的家")
	自动寻路(1, 9,"杰诺瓦镇")
	自动寻路(24, 40,"莎莲娜")
	自动寻路(196, 443,"莎莲娜海底洞窟 地下1楼")	
	自动寻路(14, 41,"莎莲娜海底洞窟 地下2楼")
	自动寻路(32, 21)
	转向(5)
	等待服务器返回()	
	喊话("咒术",0,0,0)	
	等待服务器返回()
	对话选择(1, 0)
	等待到指定地图("莎莲娜海底洞窟 地下2楼",31,22)	
	自动寻路(38, 37,"咒术师的秘密住处")	
	自动寻路(13, 8)	
    if(取物品数量( "神器·紫念珠") >  0)then goto  naxin end	
	转向(0)
	等待服务器返回()
	对话选择(4, 0)	
	goto begin 
::tohaozhai::
	common.gotoFaLanCity()
	自动寻路(96, 148,"豪宅")	
	goto begin
::map21005::	--豪宅
	if(目标是否可达(33, 22))then
		自动寻路(33, 22)	
	end
	if(目标是否可达(33, 10))then
		自动寻路(33, 10)	
	end
	if(目标是否可达(58, 66))then
		自动寻路(58, 66)	
	end
	if(目标是否可达(59, 6))then
		自动寻路(59, 6)	
	end
	goto begin
::map21006::	--镜中的豪宅
	if(目标是否可达(35,2))then
		自动寻路(35, 2)	
		转向(0)
		等待服务器返回()
		对话选择(4,0)
	end
	if(目标是否可达(37,9))then
		自动寻路(37,9)	
		转向(5)
		等待服务器返回()
		对话选择(4, 0)
	end
	if(目标是否可达(27, 67))then
		自动寻路(27, 67)		
	end	
	goto begin
::map21007::	--豪宅  地下	
	if(目标是否可达(9,5))then
		自动寻路(9, 5,"豪宅")	
	end
	if(目标是否可达(41,23))then
		自动寻路(41, 23,"豪宅")	
	end	
	goto begin
::map21008::	--豪宅2楼
	if(目标是否可达(5,23))then
		自动寻路(5, 23)	
	end	
	if(目标是否可达(16,9))then
		自动寻路(16, 9)	
	end		
	goto begin
::map21009::	--镜中的豪宅 2楼
	if(目标是否可达(40,11))then
		自动寻路(40, 11)	
		转向(1)
		等待服务器返回()
		对话选择(4,0)
	end
	if(目标是否可达(40,16))then
		自动寻路(40, 16)	
		转向(4)
		等待服务器返回()
		对话选择(4,0)
	end
	if(目标是否可达(17,61))then
		自动寻路(17, 61,"豪宅  2楼")	
	end
	if(目标是否可达(13, 36))then
		自动寻路(13, 36)	
		转向(7)
		等待服务器返回()
		对话选择(4,0)   
	end
	if(目标是否可达(16,51))then
		自动寻路(16, 51,"镜中的豪宅  阁楼")	
	end
	goto begin
::map21010::	--豪宅阁楼
	if(目标是否可达(14,30))then
		自动寻路(14, 30,"镜中的豪宅  阁楼")	
	end		
	goto begin
::map21011::	--镜中的豪宅阁楼
	if(取物品数量("阁楼的钥匙") < 1)then
		if(目标是否可达(14,36))then
			自动寻路(14, 36,"镜中的豪宅  2楼")
		end	
	end
	if(目标是否可达(23, 20))then
		自动寻路(23, 20)		
		转向(0)
		等待服务器返回()
		对话选择(4,0)
	end	
	if(目标是否可达(23, 11))then
		自动寻路(23, 11)		
		转向(0)
		等待服务器返回()
		对话选择(32,0)
		等待服务器返回()
		对话选择(32,0)
		等待服务器返回()
		对话选择(4,0)	
	end		
	goto begin
::naxin::	
	转向(0, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	等待(1000)
	设置("遇敌全跑",0)
end

main()