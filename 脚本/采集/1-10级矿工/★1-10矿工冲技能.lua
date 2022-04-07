★起始点：艾夏岛-法兰城任一传送石

common=require("common")

设置("timer", 100)			-- 设置定时器，单位毫秒 内置100毫秒 不要太快
设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 遇敌全跑 
设置("自动加血", 0)			-- 遇敌全跑 关闭自动加血，脚本对话加血 
设置("自动扔",1,"卡片？")
设置("自动扔",1,"魔石")
设置("自动扔",1,"盐")
身上最少金币=5000			--少于去取
身上最多金币=950000			--大于去存
身上预置金币=200000			--取和拿后 身上保留金币
走路加速值=110	
走路还原值=100	
采集技能等级=1
材料名="铜"
采集技能名称="挖掘"
高速采集速度=5000

function Mining1()
	材料名="铜"
	采集技能等级=1
::begin::
	等待空闲()	
	common.checkGold(身上最少金币,身上最多金币,身上预置金币)
	mapNum=取当前地图编号() 	
	if(mapNum == 11013) then	--国营第24坑道 地下1楼
		goto map11013	
	elseif(mapNum == 100)then	--芙蕾雅
		goto map100			
	end
	设置("移动速度",走路加速值)
	if(取包裹空格() < 1)then		
		扔叠加物(材料名,40)
		common.sellCastlePile(材料名,20,40)			
	end		
	if(common.playerSkillLv("挖掘") >= 3)then
		日志("达到设定技能等级，返回",1)
		return
	end	
	common.supplyCastle()
	common.checkHealth()
	common.gotoFaLanCity("w1")	
	移动(22, 87,"芙蕾雅")	
	goto begin   

::map100::							--芙蕾雅
	移动(351, 145)	
::map11013::						--国营第24坑道
	--移动(49, 66)					--直接挖
	设置("移动速度",走路还原值)
	while true do
		if(取包裹空格() < 1)then 
			扔叠加物(矿石名,40)
			break
		end	
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "国营第24坑道 地下1楼")then break end	--地图切换 也返回
		工作("挖掘","",高速采集速度)	--技能名 物品名 延时时间
		等待工作返回(高速采集速度)
	end 
	回城()
	goto begin	

::manle::	--可以在这加个仓库交易  懒得搞了
	日志("包裹满了，清理后执行",1)
	等待(12000)
	goto manle	
end
--矿山钥匙
function NaYaoShi()
	common.toCastle("灵堂")
	移动(7, 52,"地下牢房")
	移动(31, 20)
	对话选是(2)
	回城()
	common.gotoFaLanCity("w1")	
	移动(61, 63,"仓库内部")
	移动(11, 10)
	对话选是(1)
end
function Mining3()
	材料名="银"
	采集技能等级=3
	if(人物("职业")=="矿工" and 取物品数量("矿山钥匙") < 1)then
		NaYaoShi()
	end
::begin::		
	等待空闲()	
	common.checkGold(身上最少金币,身上最多金币,身上预置金币)
	mapNum=取当前地图编号() 
	if(mapNum == 11000) then	--维诺亚洞穴 地下1楼
		goto map11000	
	elseif(mapNum == 100)then	--芙蕾雅
		goto map100	
	elseif(mapNum == 11013)then	--国营第24坑道 地下1楼
		goto map11013		
	elseif(mapNum == 11014)then	--国营第24坑道 地下2楼
		goto map11014
	elseif(mapNum == 11500)then	--国营第24坑道 地下3楼
		goto map11500		
	elseif(mapNum == 11502)then	--国营第24坑道 地下4楼
		goto map11502			
	end
	设置("移动速度",走路加速值)
	if(取包裹空格() < 1)then		-- 去压矿
		扔叠加物(材料名,40)
		common.sellCastlePile(材料名,20,40)			
	end			
	common.supplyCastle()
	common.checkHealth()
	if(common.playerSkillLv("挖掘") == 4)then
		if(人物("职称") == "见习矿工" and 人物("声望等级") >= 3)then
			日志("当前技能等级为4，尚未1转，去做生产系1转任务",1)
			执行脚本("./脚本/生产/生产系1转任务.lua")		
			执行脚本("./脚本/★转正/★生产提升阶级-矿工.lua")				
		end		
	elseif(common.playerSkillLv("挖掘") == 6)then
		if(人物("职称") == "矿工" and 人物("声望等级") >= 6)then
			设置("脚本坐标静止重启",0,0)
			设置("脚本坐标静止登出",0,0)
			日志("当前技能等级为6，尚未2转，去做生产系2转任务",1)
			执行脚本("./脚本/生产/★生产二转跑路版.lua")		
			执行脚本("./脚本/★转正/★生产提升阶级-矿工.lua")	
			设置("脚本坐标静止重启",1,0)
			设置("脚本坐标静止登出",1,0)			
		end
		--8级得配合 暂时不加
	end
	if(取物品数量("矿山钥匙") < 1)then
		common.gotoFaLanCity("s")	
		移动(153, 241,"芙蕾雅")	
	else
		common.gotoFaLanCity("w1")	
		移动(22, 87,"芙蕾雅")	
	end
	goto begin   

::map100::		
	if(取物品数量("矿山钥匙") < 1)then	--南门 
		if(目标是否可达(473,316)==false)then
			回城()
			goto begin
		end
		移动(473, 316)	
		对话选是(472,316)		
	else								--西门 
		if(目标是否可达(351, 145)==false)then
			回城()
			goto begin
		end
		移动(351, 145,11013)	
	end
	goto begin   
::map11013::		--国营第24坑道
	移动(22, 22,11014)		
	goto begin	
::map11014::		--国营第24坑道  地下2楼	
	if(目标是否可达(22,21))then
		移动(22, 21)
		转向(0)
	else
		移动(23, 13,11500)
	end
	goto begin
::map11500::		--国营第24坑道  地下3楼
	移动(6,3,11502)
::map11502::		--国营第24坑道  地下4楼
	移动(30,20)
	设置("移动速度",走路还原值)
	while true do		
		if(取包裹空格() < 1)then break end	-- 奥利哈钢满回城
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "维诺亚洞穴 地下2楼" and  取当前地图编号() ~= 11502)then break end
		工作("挖掘","",高速采集速度)	--技能名 物品名 延时时间
		等待工作返回(高速采集速度)
	end 
	回城()
	goto begin		
::map11000::						--莎莲娜西方洞窟
	移动(49, 66)
	设置("移动速度",走路还原值)
	while true do		
		if(取包裹空格() < 1)then break end	-- 奥利哈钢满回城
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "维诺亚洞穴 地下2楼" and  取当前地图编号() ~= 11502)then break end
		工作("挖掘","",高速采集速度)	--技能名 物品名 延时时间
		等待工作返回(高速采集速度)
	end 
	回城()
	goto begin	
::End::
	return
end

--主流程
function main()
	日志("欢迎使用星落全自动刷挖掘技能脚本",1)
	日志("当前职业："..人物("职业"),1)
	日志("当前职称："..人物("职称"),1)
	if(人物("职业") ~= "矿工")then
		日志("职业不是矿工",1)
		return	
	end
	扔("竹子")
	扔("孟宗竹")
	扔("铜")
	local skill=common.findSkillData("挖掘")
	if(skill == nil)then
		日志("提示：没有狩猎技能，去学习狩猎技能！",1)
		common.autoLearnSkill("挖掘")		
	end
	skill=common.findSkillData("挖掘")
	if(skill == nil)then
		日志("提示：学习挖掘技能失败，脚本退出！",1)		
		return
	end	
::begin::
	等待空闲()
	local skillLV = common.playerSkillLv("挖掘")
	if(skillLV < 3)then
		日志("当前技能等级为"..skillLV.."，去刷铜",1)
		Mining1()	
	else
		日志("当前技能等级为"..skillLV.."，去刷银",1)
		Mining3()				
	end
	goto begin
	
end
main()
	
	

