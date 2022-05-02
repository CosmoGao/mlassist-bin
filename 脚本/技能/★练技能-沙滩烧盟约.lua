★起点圣骑士营地医院或营地西门外，坐标不变60秒重启。显卡不行 爱卡屏的建议此脚本


common=require("common")

local 补血值=取脚本界面数据("人补血")
local 补魔值=取脚本界面数据("人补魔")
local 宠补血值=取脚本界面数据("人补血")
local 宠补魔值=取脚本界面数据("人补血")
local 队伍人数=取脚本界面数据("队伍人数")

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



卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶|水蜘蛛的卡片"	
遇敌总次数=0
练级前经验=0
练级前时间=os.time() 	 
cardName = "封印卡（人形系）"
cardCount=240		--一次买多少
设置("自动叠",1,cardName.."&20")
技能名称="精灵的盟约"

function 营地存取金币(金额,存取)
	if(金额==nil) then return end
	local 当前地图名 = 取当前地图名()
	if(当前地图名 == "银行")then 
		移动(27,23)
	elseif(当前地图名 == "圣骑士营地")then 
		移动(116, 105,"银行")
		移动(27,23)
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
	水晶名称="地风的水晶（5：5）"
::begin:: 
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()		
	if (当前地图名 =="艾尔莎岛" )then goto quYingDi	
	elseif(当前地图名 ==  "里谢里雅堡")then goto quYingDi 
	elseif(当前地图名 ==  "法兰城")then goto quYingDi 
	elseif(当前地图名 == "医院")then goto StartBegin
	elseif(当前地图名 ==  "圣骑士营地")then goto quYiYuan
	elseif(当前地图名 ==  "商店")then goto yingDiShangDian
	elseif(当前地图名 ==  "银行")then goto yingDiYinHang
	elseif(当前地图名 ==  "肯吉罗岛")then goto lu4 end	
	回城()
	goto begin 
::yingDiShangDian::
	营地商店检测水晶()
	移动(0,14,"圣骑士营地")	
	goto begin
::yingDiYinHang::
	if(人物("金币") > 950000)then
		营地存取金币(-300000)		--留30万
	elseif(人物("金币") <50000)then
		营地存取金币(-300000,"取")	--取出后 身上总30万
	end
	移动(3,23,"圣骑士营地")	
	if(人物("金币") <50000)then
		营地存取金币(-300000,"取")	--取出后 身上总30万
	end
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
	移动(9,15)
	if(取当前地图名() ~= "医院")then
		goto begin
	end
	喊话("美特斯邦威  飞一般滴感觉",06,0,0)	
	goto xue	

::lu1::
	等待到指定地图("圣骑士营地",95,72)
::lu1a::		
	if(取物品叠加数量(cardName) < cardCount) then
		goto maika
	end
	移动(37,87)
	移动(36, 87)      
	goto lu4 

::lu4::
	等待到指定地图("肯吉罗岛")	
	移动(467, 201)      
	开始遇敌()         
        
::scriptstart::
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	if(取物品数量(cardName) < 1)then goto ting end
	等待(2000)
	goto scriptstart  
	
::ting::
	停止遇敌()
	移动(550, 332)    
	移动( 551, 332)       
	等待到指定地图("圣骑士营地")
	移动(94,73)
	移动( 95, 72)       
	goto lu6 
::quYiYuan::
	移动( 94, 72)
	移动( 95, 72)
	goto lu6 
::lu6::
	等待到指定地图("医院", 0, 20)	
	goto begin 
::xue::	
	移动(18,15)     
	回复(0)			-- 转向北边恢复人宠血魔      	
	if(宠物("健康") > 0) then	
		移动(6,7)
		移动(8,7)
		移动(6,7)
		转向坐标(7,6)
		等待服务器返回()
		对话选择(-1,6)		
	end
	common.checkHealth()
	移动(1,20)   
    移动(0,20)      
    goto lu1 
::maika::
	移动(92, 118,"商店")
	移动(14,26)
	转向(2)
	等待服务器返回()
	nowCount = cardCount-取物品叠加数量(cardName)
	common.buyDstItem(cardName,nowCount)	
::outshop::
	移动(0,14,"圣骑士营地")	
	goto begin
end
main()