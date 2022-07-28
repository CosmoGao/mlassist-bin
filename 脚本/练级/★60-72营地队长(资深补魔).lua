★起点圣骑士营地医院或营地西门外，坐标不变60秒重启。显卡不行 爱卡屏的建议此脚本


common=require("common")

补血值=取脚本界面数据("人补血")
补魔值=取脚本界面数据("人补魔")
宠补血值=取脚本界面数据("人补血")
宠补魔值=取脚本界面数据("人补血")
队伍人数=取脚本界面数据("队伍人数")

是否练宠=用户输入框("是否练宠,是1，否0",1)
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
if(队伍人数==nil or 队伍人数==0)then
	队伍人数 = 用户输入框("练级队伍人数，不足则固定点等待！",5)
end
是否卖石=用户输入框("是否卖魔石,是1，否0",1)


卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶"	
遇敌总次数=0
练级前经验=0
练级前时间=os.time() 	 

--返回当前队伍中 血量最少的值 用来判断是否回城
function 队友当前血最少值()
	teamPlayers = 队伍信息()
	local hpVal=88888
	for i,teamPlayer in ipairs(teamPlayers) do
		if(hpVal > teamPlayer.hp)then hpVal = teamPlayer.hp end
	end
	return hpVal
end

function 等待队伍人数达标(练级点)				--等待队友	
::begin::
	喊话(练级点 .."练级脚本，来打手人够脚本自动前往【"..练级点.."】++++",2,3,5)
	等待(5000)
	if(取当前地图名() ~= "医院")then
		return
	end
	if(队伍("人数") < 队伍人数) then	--数量不足 等待
		goto begin
	end	
	喊话("人数达标，自动前往【"..练级点.."】，请不要离开队伍,谢谢！",2,3,5)
	return 
end
function 营地存取金币(金额,存取)
	if(金额==nil) then return end
	local 当前地图名 = 取当前地图名()
	if(当前地图名 == "银行")then 
		自动寻路(27,23)
	elseif(当前地图名 == "圣骑士营地")then 
		自动寻路(116, 105,"银行")
		自动寻路(27,23)
	else
		return
	end
	转向(2)
	等待服务器返回()
	if(存取==nil or 存取=="存")then
		银行("存钱",金额)	
	else
		银行("取钱",金额)
	end
end

function main()
	清除系统消息()
	练级前经验=人物("经验")
	练级前宠经验=宠物("经验")
	练级前金币=人物("金币")	
	水晶名称="火风的水晶（5：5）"
::begin:: 
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()		
	if (当前地图名 =="艾尔莎岛" )then goto quYingDi	
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "商店")then goto yingDiShangDian
	elseif(当前地图名 ==  "银行")then goto yingDiYinHang
	elseif(当前地图名 ==  "工房")then goto lu2
	elseif(当前地图名 ==  "肯吉罗岛")then goto lu4 end	
	goto begin 
::yingDiShangDian::
	营地商店检测水晶()
	自动寻路(0,14,"圣骑士营地")	
	goto begin
::yingDiYinHang::
	if(人物("金币") > 950000)then
		营地存取金币(-300000)		--留30万
	elseif(人物("金币") <50000)then
		营地存取金币(-300000,"取")	--取出后 身上总30万
	end
	自动寻路(3,23,"圣骑士营地")	
	goto begin
::quYingDi::
	设置("移动速度",走路加速值)
	common.checkHealth()
	common.checkCrystal(水晶名称)
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.去营地()
	设置("移动速度",走路还原值)
	goto begin
	
::StartBegin::
	喊话("脚本启动等待",06,0,0)
	等待(1000)
	自动寻路(9,15)
	if(取当前地图名() ~= "医院")then
		goto begin
	end
	if(队伍("人数") < 队伍人数)then	--数量不足 等待
		等待队伍人数达标("营地")
	end	
	喊话("美特斯邦威  飞一般滴感觉",06,0,0)	
	goto xue	

::lu1::
	等待到指定地图("圣骑士营地",95,72)
::lu1a::	
	自动寻路(88,73)
	自动寻路(87, 72)
	goto lu2 

::lu2::
	等待到指定地图("工房",30,37)
	自动寻路(21,22)
	自动寻路(20,22)
	自动寻路(20,24)
	自动寻路(21,24)        
	卖(0, 卖店物品列表)	
	等待(15000)
	自动寻路( 30, 37)
	等待到指定地图("圣骑士营地",87,72)    
	自动寻路(37,87)
	自动寻路( 36, 87)      
	goto lu4 

::lu4::
	等待到指定地图("肯吉罗岛")	
	自动寻路(543, 332)
	开始遇敌()         
        
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if 是否战斗中() then
		遇敌总次数=遇敌总次数+1
		等待战斗结束()
	else
		minHp=队友当前血最少值()
		if(minHp~= 88888 and minHp ~= 0 and  minHp < 200)then	
			日志("队友血量过低"..minHp.."，回补！",1)				
			goto ting
		end
	end		
	等待(2000)
	goto scriptstart  	
::ting::
	停止遇敌()
	等待空闲() 	
	自动寻路(550, 332)    
	自动寻路( 551, 332)       
	等待到指定地图("圣骑士营地")
	自动寻路(94,73)
	自动寻路( 95, 72)       
	goto lu6 
::quYiYuan::
	自动寻路( 94, 72)
	自动寻路( 95, 72)
	goto lu6 
::lu6::
	等待到指定地图("医院", 0, 20)	
	goto begin 
::xue::
	自动寻路(14,20)
	自动寻路(18,16)
	自动寻路(18,15)
	自动寻路(17,15)
	自动寻路(19,15)
	自动寻路(18,15)     
	回复(0)			-- 转向北边恢复人宠血魔      
	等待(15000)                   --等待X秒等候队友反应 
	if(宠物("健康") > 0) then	
		自动寻路(6,7)
		自动寻路(8,7)
		自动寻路(6,7)
		转向坐标(7,6)
		等待服务器返回()
		对话选择(-1,6)		
	end
	自动寻路(1,20)   
    自动寻路(0,20)      
    goto lu1 
end
main()