★起点艾尔莎岛登入点，UD男性路线，路上默认逃跑，使用前，男和女2人组队，脚本自动获取队伍中ud女信息，失败则默认取队长名称。组队的话 路上请勿逃跑 不然火车不等人


交易对象名称=nil
设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 高速战斗


function 判断队长()
	local teamPlayers=队伍信息()
	local count=0
	for i,teammate in ipairs(teamPlayers)do
		count=count+1
		--日志(i..teammate.name .."队长名称："..队长名称)
		if( i==1 and teammate.name ~= 交易对象名称) then	
			--日志(i..teammate.name .."!- 队长名称："..队长名称)
			return false
		else
			break
		end
	end
	if count ==0 then
		return false
	else
		return true
	end
end
function waitAddTeam()
	local tryNum=0
::begin::	
	加入队伍(交易对象名称)
	if(取队伍人数()>1)then
		if(判断队长()==true) then
			return
		else
			离开队伍()
		end		
	end
	if(是否空闲中()==false)then
		return
	end
	if(tryNum>10)then
		return
	end
	tryNum=tryNum+1
	goto begin
end

function GetOathGroup()
	local teamPlayers
	local dstGroup=0
::begin::	
	dstGroup=0
	teamPlayers = 队伍信息()
	for index,teamPlayer in ipairs(teamPlayers) do			
		if(teamPlayer.nick_name == "UD女")then
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
	--取队伍中ud女信息
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
	日志("当前UD男脚本，交易UD女："..交易对象名称,1)
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
	elseif(mapNum == 24000) then --开启者之间 打完Boss对话地图
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

::start::.
	if(取当前地图名() ~= "艾尔莎岛")then
		goto begin
	end
	移动(140,105)    
	转向(1)
	等待服务器返回()
	对话选择(4,0)
	goto begin
::libao::
	if(取当前地图名() ~= "里谢里雅堡")then
		goto begin
	end	
	移动(34,89)
	回复(1)			-- 转向北边恢复人宠血魔	
	移动(41, 50,"里谢里雅堡 1楼")	
    移动(45, 20,"启程之间")
	移动(15, 4)	
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
	goto jnwcf 

::jnwcf::
	等待到指定地图("杰诺瓦镇的传送点") 	
	-- 等待(2000)
    -- 喊话("请组好队后重新执行脚本",0,0,0)
	-- 等待(8000)
	-- goto jnwcf 

::jienuowa::	     
	移动(14, 6,"村长的家")	
	移动(1, 9,"杰诺瓦镇")	
	移动(31,27,"莎莲娜")	
::shalianla::	
	移动(259, 359)        
	对话选是(260,359)	
	goto begin
::map14010::
	移动(27,11,14011)
::map14011::
	移动(34,12,14012)
::map14012::
	移动(16,9,14013)
::map14013::
	移动(34,9,14014)
::map14014::
	移动(24,8,14015)
::map14015::
	移动(18,28,14016)
::map14016::
	移动(22, 10,"阿斯提亚镇")		
::map4100::
	移动(101, 72,"神殿")	
::map4130::
	移动(25, 11,"回复之间")	
::map4140::	--回复之间
	移动(17, 10)
	回复(1)		
	移动(5, 10,"神殿")	
::神殿::
	等待到指定地图("神殿")
	移动(20, 17)	
	移动(20, 22)	
	等待到指定地图("大厅")
	移动(25, 23)	
	移动(25, 24)	
	移动(27, 24)	
	移动(25, 24)	        
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")
::map24006::
	等待到指定地图("圣餐之间")	
	移动(39, 12)	
    等待(1000)
    转向(2, "")
    等待服务器返回()
    对话选择("1", "", "")
	等待到指定地图("圣坛")		
::map24003::
	if(取物品数量("18496") > 0)then		--男拿完蜡烛 去换蜡烛
		if(目标是否可达(24, 19)) then	--拿完蜡烛卡主 会执行此
			移动(24,19)				
		elseif(目标是否可达(70,47))then
			移动(70,47)	
			goto huan1		
		end
	elseif(取物品数量("18492") > 0)then	--男换完蜡烛 去下一层
		if(目标是否可达(102,57))then
			移动(102,57)	
			转向(5, "")
			等待服务器返回()
			对话选择("1", "", "")		
			goto begin					--下张图 让begin去判断	
		end
	else								--上面2个都不是 就是没有蜡烛咯 刚进来 去拿蜡烛
		if(目标是否可达(24, 24))then
			移动(24, 24)			
		elseif(目标是否可达(28, 29))then
			移动(28, 29)	
			转向(3, "")
			等待服务器返回()        
			对话选择("1", "", "")		
			移动(24, 19)			
		end			
	end	
	goto begin
::huan1::
	if(取物品数量("18492") < 1 and 取物品数量("18496") > 0)then		
		while true do
			if(人物("坐标")  ~= "70,47")then
				goto begin			
			end
			转向(4)
			交易(交易对象名称,"物品:18496|1|1","物品:18492|1|1",10000)
			if(取物品数量("18492") > 0)then
				break
			end
			日志("等待一次换烛台!",1)
		end	
	end
	goto begin	
::map24004::
	if(取物品数量("18493") > 0)then		--男 去换蜡烛		
		if(目标是否可达(7,54))then
			移动(7, 54)
		elseif(目标是否可达(15, 52))then
			移动(15, 52)
		elseif(目标是否可达(26, 52))then
			移动(26, 52)
		elseif(目标是否可达(60, 3))then
			移动(60, 3)
		elseif(目标是否可达(101, 16))then
			移动(101, 16)
		elseif(目标是否可达(86, 50))then
			移动(86, 50)
			goto huan2		
		end
	elseif(取物品数量("18497") > 0)then	--男换完蜡烛 去下一层
		if(目标是否可达(106, 44))then
			移动(106, 44)
		elseif(目标是否可达(128, 43))then
			移动(128, 43)
		elseif(目标是否可达(143, 11))then
			移动(143, 11)
			等待(1000)        
			转向(5, "")
			等待服务器返回()        
			对话选择("1", "", "")		
			goto begin					--下张图 让begin去判断	
		end		
	end
	goto begin
::huan2::
	if(取物品数量("18497") < 1 and 取物品数量("18493") > 0)then		
		while true do
			if(人物("坐标")  ~= "86,50")then
				goto begin			
			end	
			转向(4)
			交易(交易对象名称,"物品:18493|1|1","物品:18497|1|1",10000)
			if(取物品数量("18497") > 0)then
				break
			end
			日志("等待二次换烛台!",1)
		end	
	end
	goto begin
::map24005::
	if(取物品数量("18494") < 1)then	
		if(目标是否可达(23, 15))then
			移动(23, 15)
		elseif(目标是否可达(37, 23))then
			移动(37, 23)
		elseif(目标是否可达(37, 46))then
			移动(37, 46)
		elseif(目标是否可达(37, 68))then
			移动(37, 68)
		elseif(目标是否可达(47, 81))then
			移动(47, 81)
		elseif(目标是否可达(61, 75))then
			移动(61, 75)
		elseif(目标是否可达(71, 60))then
			移动(71, 60)	
		elseif(目标是否可达(83, 95))then
			移动(83, 95)
		elseif(目标是否可达(140, 28))then
			移动(140, 28)
		elseif(目标是否可达(135, 39))then
			移动(135, 39)
			goto huan3		
		end
	else
		if(目标是否可达(135,33))then
			移动(135,33)		
		elseif(目标是否可达(88, 94))then
			移动(88, 94)
		elseif(目标是否可达(82, 64))then
			移动(82, 64)
			对话选是(82,63)	
			goto begin
		end
	end
	goto begin
::huan3::
	if(取物品数量("18494") < 1 and 取物品数量("18498") > 0)then			
		while true do
			if(人物("坐标")  ~= "135,39")then
				goto begin			
			end	
			转向(4)
			交易(交易对象名称,"物品:18498|1|1","物品:18494|1|1",10000)
			if(取物品数量("18494") > 0)then
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
	移动(91, 49)        
	转向(2, "")
	等待服务器返回()	
	对话选择("1", "", "")
	等待(3000)
	goto begin
::map24001::
	if(取当前地图名() ~= "洗礼的试炼") then
		goto begin
	end
	设置("遇敌全跑",0)
	if(队伍("人数") > 1) then	
		goto waitBattle
	end	
	移动(8, 7)
	等待(2000)
  --  喊话("请自行组队打Boss",0,0,0)
	waitAddTeam()
	等待(2000)
	if(是否战斗中()) then
		等待战斗结束()
	end
	goto begin
::waitBattle::
	if(取当前地图名() ~= "洗礼的试炼") then
		goto begin
	end
	if(队伍("人数") == 1) then	
		goto begin
	end	
	if(是否战斗中()) then
		等待战斗结束()
	end
	等待(2000)
	goto waitBattle
::map24000::
	--地图:24000
	移动(16,9)
	对话选是(17,9)	
	goto begin
::map24007::	--圣餐之间  
	日志("需要学超强咒术的，在此学，脚本退出",1)
--	移动(39,12)
--	对话选是(40,12)	
	
end

main()