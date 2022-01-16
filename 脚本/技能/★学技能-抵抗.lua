

设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 开启高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 开启遇敌全跑 
common=require("common")



common.supplyCastle()
common.sellCastle()		--默认卖
common.checkHealth(医生名称)
common.toCastle()
移动(41, 50,"里谢里雅堡 1楼")	
移动(45, 20,"启程之间")
移动(15, 4)	
转向(2)
dlg=等待服务器返回()
if(dlg.message~=nil and string.find(dlg.message,"此传送点的资格")~=nil)then
	执行脚本("./脚本/直通车/★开传送-杰诺瓦镇.lua")
	goto jiecun
end	
转向(2, "")
等待服务器返回()
对话选择("4", 0)
::jiecun::
等待到指定地图("杰诺瓦镇的传送点")
移动(14, 6,"村长的家")
移动(1, 9,"杰诺瓦镇")
移动(24, 40,"莎莲娜")
设置("遇敌全跑",1)
移动(196, 443,"莎莲娜海底洞窟 地下1楼")	
移动(14, 41,"莎莲娜海底洞窟 地下2楼")
移动(32, 21)
转向(5, "")
等待服务器返回()	
喊话("咒术",0,0,0)	
等待服务器返回()
对话选择("1", "", "")
等待到指定地图("莎莲娜海底洞窟 地下2楼",31,22)	
移动(38, 37,"咒术师的秘密住处")
设置("遇敌全跑",0)		

common.autoLearnSkill("抗混乱")
common.autoLearnSkill("抗毒")
common.autoLearnSkill("抗石化")
common.autoLearnSkill("抗昏睡")
common.autoLearnSkill("抗遗忘")
common.autoLearnSkill("抗酒醉")
