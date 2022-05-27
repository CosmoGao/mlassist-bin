★捉神盾脚本，起点哥拉尔登入点，要开了米村传。请设置好自动战斗,战斗1中设置好遇一级宠时的战斗方法 ::战斗2设置好宠物满下线保护，谢谢支持魔力辅助程序.脚本发现BUG联系Q::274100927-----------星落

设置("timer", 100)						

设置("自动战斗",1)
设置("高速战斗", 1)
设置("高速延时",1)
	
local 人补魔=用户输入框( "人多少魔以下补魔", "50")
local 人补血=用户输入框( "人多少血以下补血", "300")
local 宠补魔=用户输入框( "宠多少魔以下补魔", "50")
local 宠补血=用户输入框( "宠多少血以下补血", "200")	
local 自动换水火的水晶耐久值 = 用户输入框("多少耐久以下自动换水火的水晶,不换可不填", "30")


::begin::
	清除系统消息()
	停止遇敌()					-- 结束战斗	
	if(人物("坐标")  == "402,345")then	goto  kaishi end
	等待(1000)
	回城()
	等待(2000)
	
	等待到指定地图("哥拉尔镇", 120, 107)	

	if(取物品数量("封印卡（龙系）") < 1)then goto  buycardsnow end
	if(耐久(7) < 自动换水火的水晶耐久值)then goto  checkcrystalnow end
	if(人物("魔") < 人补魔)then goto  recovernow end		-- 魔小于100
	if(人物("血") < 人补血)then goto  recovernow end
	if(宠物("血") < 宠补血)then goto  recovernow end
	if(宠物("魔") < 宠补魔)then goto  recovernow end
	goto herewego 

::herewego::	
	移动(176, 105,"库鲁克斯岛")			
	goto kaishi 
::buycardsnow::
	移动(146, 117,"魔法店")	
	移动(18, 12)	
	转向(2)
	等待服务器返回()	
	对话选择(0, 1)
	等待服务器返回()
	买(5,20)	
	等待服务器返回()
	卖(2,"魔石")					-- 转向东边卖石	
	--printf("钱")
	goto begin 

::checkcrystalnow::
	if(取物品数量("水火的水晶（5：5）") < 1)then goto  buyreequipcrystalnow end
	扔("7")
	等待(1000)
	装备物品("水火的水晶（5：5）", 7)
	等待(1000)
	goto begin 

::buyreequipcrystalnow::
	移动(146, 117,"魔法店")	
	移动(18, 12)	
	转向(2, "")
	等待服务器返回()
	
	对话选择("0", "1", "")
	等待服务器返回()
	买(12,1)	
	等待服务器返回()	
	卖(2,"魔石")				-- 转向东边卖石	
	--printf("钱")
	goto begin 

::recovernow::
	移动(165, 91,"医院")	
	移动(28, 25)
	回复("north")						-- 恢复人宠	
	--printf("钱")
	if(取物品数量("魔石") > 9)then goto  salenow end
	goto begin 

::salenow::
	移动(9, 23,"哥拉尔镇")
	移动(147, 79,"杂货店")	
	移动(11, 18)
	卖(2,"魔石")		
	--printf("钱")
	goto begin 
::kaishi::
	移动(402, 345)	
	开始遇敌()       
	goto scriptstart 

::scriptstart::
	if(人物("魔") < 人补魔)then goto  battleover end		-- 魔小于100
	if(人物("血") < 人补血)then goto  battleover end
	if(宠物("血") < 宠补血)then goto  battleover end
	if(宠物("魔") < 宠补魔)then goto  battleover end
	if(取物品数量("封印卡（龙系）") < 1)then goto  begin end
	--if("耐久", "7", "<", "自动换水火的水晶耐久值", checkcrystal)
	--扔("卡片？")						-- 要自动扔的东西
	goto scriptstart 	


::battleover::	
	停止遇敌()						-- 结束战斗	
	等待(1000)
	goto recover 
::buycards::
	停止遇敌()						-- 结束战斗		
	回城()	
	等待到指定地图("哥拉尔镇", 120, 107)	
	移动(146, 117,"魔法店")	
	移动(18, 12)	
	转向(2)
	等待服务器返回()	
	对话选择(0, 1)
	等待服务器返回()
	买(5,20)	
	等待服务器返回()
	卖(2,"魔石")					-- 转向东边卖石	
	goto recover 

::recover::
	回城()
	等待(2000)	
	等待到指定地图("哥拉尔镇", 120, 107)	
	移动(165, 91,"医院")	
	移动(28, 25)
	回复("north")						-- 恢复人宠	
	--printf("钱")
	if(取物品数量("魔石") > 9)then goto  salenow end	
	移动(28, 25)
	回复("north")						-- 恢复人宠	
	--printf("钱")
	if(取物品数量("魔石") > 9)then goto  sale end
	goto begin 

::sale::	
	移动( 9, 23,"哥拉尔镇")	
	移动( 147, 79,"杂货店")
	移动(11, 18)	
	卖(0,"魔石")		
	--printf("钱")
	goto begin 


::checkcrystal::
	if(取物品数量("水火的水晶（5：5）") < 1)then goto  buyreequipcrystal end
	停止遇敌()						-- 结束战斗
	
	设置("timer", 200)						-- 设置定时器，单位毫秒
	等待(1000)
	扔("7")
	等待(1000)
	装备物品("水火的水晶（5：5）", 7)
	等待(1000)
	goto scriptstart 

::buyreequipcrystal::
	停止遇敌()						-- 结束战斗
	回城()
	等待(2000)
	
	等待到指定地图("哥拉尔镇", 120, 107)	
	移动( 146, 117,"魔法店")	
	移动(18, 12)	
	转向(2, "")
	等待服务器返回()	
	对话选择("0", "1", "")
	等待服务器返回()	
	买(12,1)	
	等待服务器返回()
	
	卖(0,"魔石")		
	
	--printf("钱")
	扔("7")
	等待(1000)
	装备物品("水火的水晶（5：5）", 7)
	等待(1000)
	goto begin 


