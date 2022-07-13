半山小岛单烧技能(半山5锄头路线)


common=require("common")
设置("timer",20)

--设置("高速延时",0)  
设置("高速战斗",1)  
设置("自动战斗",1)  
设置("遇敌速度",20)  

local 补血值=用户输入框("多少血以下去补给","400")
local 补魔值=用户输入框("多少魔以下去补给","400")
local 宠补血值=用户输入框("宠多少血以下补血","100")
local 宠补魔值=用户输入框("宠多少魔以下去补给","400")
local 技能达标是否切换配置=用户勾选框("技能达标是否切换配置",0)
local sEquipWeaponName=用户下拉框("武器名称",{"平民剑","平民斧","平民枪","平民弓","平民回力镖","平民小刀","平民杖"})		--武器名称
local 技能名称="强力补血魔法"
local 下个配置文件=""
local 技能目标等级=10
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
		移动(41,30)
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
	local skills = {}
	local playerData = 人物信息()
	for i,skill in ipairs(playerData.skill) do
		table.insert(skills,skill.name)		
	end
	技能名称=用户下拉框("技能名称",skills)
	技能目标等级= 用户下拉框("技能目标等级",{1,2,3,4,5,6,7,8,9,10})
	下个配置文件=用户输入框("下个配置文件","传教补血")
	日志("所烧技能名称:"..技能名称.." 目标等级:"..技能目标等级.." 下个配置文件:"..下个配置文件,1)
::begin::
	停止遇敌()	
	等待空闲()
	if(人物("金币") < 100000) then
		common.getMoneyFromBank(300000)		
	end
	common.checkHealth()
	common.supplyCastle()
	if(技能等级() >= 技能目标等级)then
		if(技能达标是否切换配置==1)then
			--读取配置("配置/小岛超补.save")
			读取配置("配置/"..下个配置文件..".save")
		else
			return
		end
	end
	common.checkEquipDurable(2,sEquipWeaponName,20)
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
	移动(34,89)
	回复(1)	
	移动(31,83)
	goto chufa 

::chufa::	    
	移动(42,50)	
	等待到指定地图("里谢里雅堡 1楼")       
	移动(75,20)        
	移动(75,19)	
	等待到指定地图("里谢里雅堡 2楼")        
	移动(44,75)
	移动(1,75)        
	移动(0,75)	
	等待到指定地图("图书室")
	移动(27,18)
	移动(27,16)           
	转向(0,"")
	等待服务器返回()
	对话选择("32","","")	
	等待服务器返回()
	对话选择("4","","")	
	等待服务器返回()
	对话选择("1","","")    	
	等待到指定地图("小岛")	
	移动(64,90)
	开始遇敌()	
	goto jiance 

::jiance::
	
	if(人物("血") < 补血值)then goto begin end
	if(人物("魔") < 补魔值)then goto begin end
	if(宠物("血") < 宠补血值)then goto begin end
	if(宠物("魔") < 宠补魔值)then goto begin end
	goto jiance 
end
main()