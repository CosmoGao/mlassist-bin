★起点艾尔莎岛登入点，UD女性路线，路上默认逃跑，使用前，男和女2人组队，脚本自动获取队伍中ud男信息，失败则默认取队长名称。组队的话 路上请勿逃跑 不然火车不等人


交易对象名称=nil
队伍人数=2
设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 高速战斗


function 等待队伍人数达标()				--等待队友	
::begin::	
	等待(5000)
	if(队伍("人数") < 队伍人数) then	--数量不足 等待
		goto begin
	end		
	return 
end
function GetOathGroup()
	local teamPlayers
	local dstGroup=0
::begin::	
	dstGroup=0
	teamPlayers = 队伍信息()
	for index,teamPlayer in ipairs(teamPlayers) do			
		if(teamPlayer.nick_name == "UD男")then
			交易对象名称 = teamPlayer.name		
			dstGroup=dstGroup+1
		end		
	end	
	if(dstGroup >= 1)then
		return
	end
	if(队伍("人数") < 2)then
		return
	end
	等待(1000)
	goto begin
end
function main()
	扔("誓言的烛台")
	--取队伍中ud男信息
	GetOathGroup()
	--失败则获取脚本界面数据
	if(交易对象名称 == nil)then
		交易对象名称=取脚本界面数据("队长名称",false)
	end
	--再失败，由人工设置交易对象名称
	if(交易对象名称==nil or 交易对象名称==0 or 交易对象名称=="")then
		交易对象名称=用户输入框("交易对象名称", "星々落")
	end
	设置("遇敌全跑",1)
	日志("当前UD女脚本，交易UD男："..交易对象名称,1)
 ::begin::   
	等待空闲()
	当前地图名=取当前地图名()
	x,y=取当前坐标()
	mapNum=取当前地图编号()
	if(当前地图名=="艾尔莎岛")then
		goto start
	elseif(当前地图名 == "里谢里雅堡")then	
		goto libao 
	elseif(当前地图名 == "莎莲娜")then	
		goto shalianla 
	elseif(当前地图名 ==  "杰诺瓦镇的传送点")then 
		goto jienuowa
	elseif(mapNum == 14010)then	--参道一
		goto map14010	
	elseif(mapNum == 14011)then	--参道二
		goto map14011
	elseif(mapNum == 14012)then	--参道三
		goto map14012
	elseif(mapNum == 14013)then	--参道四
		goto map14013
	elseif(mapNum == 14014)then	--参道五
		goto map14014
	elseif(mapNum == 14015)then	--参道六
		goto map14015
	elseif(mapNum == 14016)then	--参道七
		goto map14016
	elseif(mapNum == 4100)then	--阿斯提亚镇
		goto map4100
	elseif(mapNum == 4130)then	--神殿
		goto map4130	
	elseif(mapNum == 4140)then	--回复之间
		goto map4140	
	elseif(mapNum == 24003) then --第一张图
		goto map24003
	elseif(mapNum == 24004) then --第二张图
		goto map24004
	elseif(mapNum == 24005) then --第三张图
		goto map24005	
	elseif(mapNum == 24000) then --勇者之间 打完Boss对话地图
		goto map24000	
	elseif(mapNum == 24001) then --洗礼的试炼 Boss
		goto map24001
	elseif(mapNum == 24002) then --阿尔杰斯的慈悲
		goto map24002
	elseif(mapNum == 24007) then --圣餐之间 超咒
		goto map24007
	else
		回城()
	end	
	等待(2000)
	goto begin
::start::
	if(取当前地图名() ~= "艾尔莎岛")then
		goto begin
	end
	自动寻路(140,105)    
	转向(1)
	等待服务器返回()
	对话选择(4,0)
	goto begin
::libao::
	if(取当前地图名() ~= "里谢里雅堡")then
		goto begin
	end	
	自动寻路(34,89)
	回复(1)			-- 转向北边恢复人宠血魔	
	自动寻路(31,77)			
	卖(6,"魔石")
	自动寻路(41, 50,"里谢里雅堡 1楼")	
    自动寻路(45, 20,"启程之间")
	自动寻路(15, 4)	
	if(取物品数量( "传送石优待卷") >  0)then goto  mfgcs2 end		
	转向(2, "")
	等待服务器返回()
	对话选择(4, 0)
	goto jnwcf 
::mfgcs2::        
	转向(2, "")
	等待服务器返回()	
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")  
::jnwcf::
	等待到指定地图("杰诺瓦镇的传送点")	

::jienuowa::	     
	自动寻路(14, 6,"村长的家")	
	自动寻路(1, 9,"杰诺瓦镇")	
	自动寻路(31,27,"莎莲娜")	
	goto begin
::shalianla::
	自动寻路(259, 359)        
	转向(2, "")
	等待服务器返回()
	对话选择("32", 0)
	等待服务器返回()
	对话选择("4", 0)
	等待服务器返回()
	对话选择("1", 0)	
	goto begin
::map14010::
	自动寻路(27,11,14011)
	goto begin
::map14011::
	自动寻路(34,12,14012)
	goto begin
::map14012::
	自动寻路(16,9,14013)
	goto begin
::map14013::
	自动寻路(34,9,14014)
	goto begin
::map14014::
	自动寻路(24,8,14015)
	goto begin
::map14015::
	自动寻路(18,28,14016)
	goto begin
::map14016::
	自动寻路(22, 10,"阿斯提亚镇")	
	goto begin	
::map4100::
	自动寻路(101, 72,"神殿")	
::map4130::
	自动寻路(25, 11,"回复之间")		
::map4140::	--回复之间
	自动寻路(17, 10)
	回复(1)		
	自动寻路(5, 10,"神殿")	
::神殿::
	等待到指定地图("神殿", 1)
	自动寻路(20, 17)	
	自动寻路(20, 22)	
	等待到指定地图("大厅", 1)
	自动寻路(25, 23)	
	自动寻路(25, 24)	
	自动寻路(27, 24)	
	自动寻路(25, 24)	        
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")
::map24006::
	等待到指定地图("圣餐之间")	
	自动寻路(39, 12)	
    等待(1000)
    转向(2, "")
    等待服务器返回()
    对话选择("1", "", "")
	等待到指定地图("圣坛")		
::map24003::	
	if(取物品数量("18492") > 0)then		--女拿完蜡烛 去换蜡烛
		if(目标是否可达(24, 71))then
			自动寻路(24, 71)			
		elseif(目标是否可达(70,49))then
			自动寻路(70,49)		
			goto huan1
		end	
	elseif(取物品数量("18496") > 0)then	--女换完蜡烛 去下一层
		if(目标是否可达(81,80))then
			自动寻路(81,80)			
		elseif(目标是否可达(97,34))then
			自动寻路(97,34)
		elseif(目标是否可达(111,33))then
			自动寻路(111,33)
			对话选是(111,34)
			goto begin
		end
	else
		if(目标是否可达(24, 76))then
			自动寻路(24, 76)			
		elseif(目标是否可达(29, 80))then
			自动寻路(29, 80)
			对话选是(29,81)	
			自动寻路(24, 71)		
		end				
	end	
	goto begin
::huan1::
	if(取物品数量("18496") < 1 and 取物品数量("18492") > 0)then			
		while true do
			if(人物("坐标")  ~= "70,49")then
				goto map24003			
			end		
			转向(0)
			等待交易(交易对象名称,"物品:18492|1|1","物品:18496|1|1",10000)
			if(取物品数量("18496") > 0)then
				break
			end
			日志("等待一次换烛台!",1)
		end	
	end
	goto begin	
::map24004::
	if(取物品数量("18497") > 0)then	
		if(目标是否可达(14,29))then
			自动寻路(14,29)			
		elseif(目标是否可达(31,70))then
			自动寻路(31,70)
		elseif(目标是否可达(74,82))then
			自动寻路(74,82)
		elseif(目标是否可达(62,64))then
			自动寻路(62,64)
		elseif(目标是否可达(86,52))then
			自动寻路(86,52)
			goto huan2
		end	
	else
		if(目标是否可达(68,63))then
			自动寻路(68,63)			
		elseif(目标是否可达(94,71))then
			自动寻路(94,71)
		elseif(目标是否可达(67,34))then
			自动寻路(67,34)
		elseif(目标是否可达(58,47))then
			自动寻路(58,47)
		elseif(目标是否可达(135,77))then
			自动寻路(135,77)
			对话选是(135,78)
			goto begin
		end	
	end
	goto map24004
::huan2::
	if(取物品数量("18493") < 1 and 取物品数量("18497") > 0)then
			
		while true do
			if(人物("坐标")  ~= "86,52")then
				goto map24004			
			end		
			转向(0)
			等待交易(交易对象名称,"物品:18497|1|1","物品:18493|1|1",10000)
			if(取物品数量("18493") > 0)then
				break
			end
			日志("等待二次换烛台!",1)
		end	
	end	
	goto begin
::map24005::
	if(取物品数量("18498") < 1)then	
		if(目标是否可达(76,30))then
			自动寻路(76,30)		
		elseif(目标是否可达(98,16))then
			自动寻路(98,16)	
		elseif(目标是否可达(110,24))then
			自动寻路(110,24)
		elseif(目标是否可达(110,47))then
			自动寻路(110,47)
		elseif(目标是否可达(121,61))then
			自动寻路(121,61)
		elseif(目标是否可达(135,54))then
			自动寻路(135,54)
		elseif(目标是否可达(135,41))then
			自动寻路(135,41)			
			goto huan3		
		end
	else
		if(目标是否可达(135,47))then
			自动寻路(135,47)			
		elseif(目标是否可达(130,60))then
			自动寻路(130,60)			
		elseif(目标是否可达(110,54))then
			自动寻路(110,54)			
		elseif(目标是否可达(111,32))then
			自动寻路(111,32)			
		elseif(目标是否可达(106,16))then
			自动寻路(106,16)		
		elseif(目标是否可达(82,42))then
			自动寻路(82,42)
			对话选是(82,43)	
			goto begin
		end	
	end	
::huan3::
	if(取物品数量("18498") < 1 and 取物品数量("18494") > 0)then
			
		while true do
			if(人物("坐标")  ~= "135,41")then
				goto map24005			
			end		
			转向(0)
			等待交易(交易对象名称,"物品:18494|1|1","物品:18498|1|1",10000)
			if(取物品数量("18498") > 0)then
				break
			end
			日志("等待三次换烛台!",1)
		end		
	end
	goto begin	
::map24002::
	if(取当前地图名() ~= "阿尔杰斯的慈悲") then
		goto begin
	end
	设置("遇敌全跑",0)
	自动寻路(91, 49)        
	转向(2, "")
	等待服务器返回()	
	对话选择("1", "", "")
	等待(2000)
	goto begin
::map24001::
	if(取当前地图名() ~= "洗礼的试炼") then
		goto begin
	end
	自动寻路(8, 7)
	等待(2000)
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标()
	end	
    喊话("打boss了哦",0,0,0)
	自动寻路(14,8)
	转向(2)
	等待(2000)
	if(是否战斗中()) then
		等待战斗结束()
	end
	goto begin
::map24000::
	--地图:24000
	自动寻路(16,9)
	对话选是(17,9)	
	goto begin
::map24007::	--圣餐之间  
	日志("需要学超强咒术的，在此学，脚本退出",1)
--	自动寻路(39,12)
--	对话选是(40,12)	
end
main()