就职传教，学调教和宠强，附带石化和气功弹

common=require("common")

设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 遇敌全跑 
走路加速值=110	
设置("移动速度",走路加速值)

function main()
	等待空闲()
	if(取当前地图名() == "召唤之间")then
		自动寻路(3,9)
		对话选是(4,9)
	end
	common.艾岛定居()
	设置("遇敌全跑", 0)
--大树交易
::爱心救助::
	自动寻路(136,106)
	转向(0)
	人物动作("换片")
	交易("￠夏梦￡雨￠","","",10000)	
	if(人物("金币") < 1000)then
		goto 爱心救助
	end
	common.joinMissionary()	
	common.autoLearnSkill("补血魔法")
	common.autoLearnSkill("强力补血魔法")
	common.autoLearnSkill("调教")
	common.autoLearnSkill("宠物强化")
	common.autoLearnSkill("气功弹")
	common.autoLearnSkill("石化魔法")
	common.gotoFaLanCity("s")
	自动寻路(216,124,"美容院")
	自动寻路(15,10)
::StartBegin::	
	转向(0, "")
	等待服务器返回()		--这些完了。才能和NPC说话
	对话选择("4", "", "")           --4代表选是
	等待服务器返回()		--这些完了。才能和NPC说话
	对话选择("4", "", "")           --4代表选是
	等待服务器返回()		--这些完了。才能和NPC说话
	对话选择("1", "", "")	    --1代表确定
	player=人物信息()
	if(player.value_charisma >= 100)then
		切换脚本("脚本/练级/★1-160全自动-队员.lua")
	end
	goto StartBegin
end
main()