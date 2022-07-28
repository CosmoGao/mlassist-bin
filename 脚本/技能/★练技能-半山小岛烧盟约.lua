半山小岛单烧技能(半山5锄头路线)


common=require("common")
设置("timer",100)

--设置("高速延时",0)  
设置("高速战斗",1)  
设置("自动战斗",1)  
设置("遇敌速度",20)  

补血值=用户输入框("多少血以下去补给","400")
补魔值=用户输入框("多少魔以下去补给","400")
宠补血值=用户输入框("宠多少血以下补血","100")
宠补魔值=用户输入框("宠多少魔以下去补给","400")

技能名称="精灵的盟约"
目标等级=10
cardName = "封印卡（人形系）"
cardCount=240		--一次买多少
设置("自动叠",1,cardName.."&20")

function 技能等级()
	local playerData = 人物信息()
	for i,skill in ipairs(playerData.skill) do
		if(skill.name == 技能名称)then
			日志("技能等级："..技能名称..skill.lv)
			return skill.lv
		end
	end
	return 0
end
function 拿钱()
	if(人物("金币") < 100000) then
		common.gotoBankTalkNpc()
	end
::begin::
	if(人物("金币") < 100000) then
		自动寻路(41,30)
		转向(2)
		银行("取钱",-500000)
		if(银行("金币") < 500000 and 人物("金币") < 500000)then
			转向(4)
			交易("￠秋雨￡落￠","","金币:500000",10000)
		end
	else
		return
	end
	goto begin
end
function main()
::begin::
	停止遇敌()	
	等待空闲()
	if(人物("金币") < 100000) then
		common.getMoneyFromBank(300000)		
	end
	common.checkHealth()
	common.supplyCastle()
	if(技能等级() >= 目标等级)then
		return
	end
	if(取物品叠加数量(cardName) < cardCount) then
		goto maika
	end
	拿钱()
	回城()
	等待到指定地图("艾尔莎岛")
	等待(500)
	扔("锄头")
	等待(500)
	转向(1,"")
	等待服务器返回()
	对话选择("4","","")
	等待到指定地图("里谢里雅堡")	
	自动寻路(34,89)
	回复(1)	
	自动寻路(31,83)
	goto chufa 

::chufa::	    
	自动寻路(42,50)	
	等待到指定地图("里谢里雅堡 1楼")       
	自动寻路(75,20)        
	自动寻路(75,19)	
	等待到指定地图("里谢里雅堡 2楼")        
	自动寻路(44,75)
	自动寻路(1,75)        
	自动寻路(0,75)	
	等待到指定地图("图书室")
	自动寻路(27,18)
	自动寻路(27,16)           
	转向(0,"")
	等待服务器返回()
	对话选择("32","","")	
	等待服务器返回()
	对话选择("4","","")	
	等待服务器返回()
	对话选择("1","","")    	
	等待到指定地图("小岛")	
	自动寻路(64,90)
	开始遇敌()	
	goto jiance 

::jiance::
	
	if(人物("血") < 补血值)then goto begin end
	if(人物("魔") < 补魔值)then goto begin end
	if(宠物("血") < 宠补血值)then goto begin end
	if(宠物("魔") < 宠补魔值)then goto begin end
	if(取当前地图名() ~= "小岛")then goto begin end
	等待(2000)
	goto jiance 

::maika::
	回城()
	自动寻路(144,105)
	自动寻路(157,93)
	转向(2)	
	等待到指定地图("艾夏岛", 1)	
	转向(6)
	等待到指定地图("艾夏岛", 164,159)	
	转向(7)
	等待到指定地图("艾夏岛", 151,97)	
	自动寻路(150, 125,"克罗利的店")
::shop::
	自动寻路(40,23)
	转向(2)
	等待服务器返回()
	nowCount = cardCount-取物品叠加数量(cardName)
	common.buyDstItem(cardName,nowCount)	
::outshop::
	if(取物品叠加数量(cardName) < cardCount) then
		goto shop
	end
	回城()
	goto begin
end
main()