★起始点：艾夏岛-法兰城任一传送石

common=require("common")

设置("timer", 100)			-- 设置定时器，单位毫秒 内置100毫秒 不要太快
设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 遇敌全跑 
设置("自动加血", 0)			-- 遇敌全跑 关闭自动加血，脚本对话加血 
走路加速值=110	
走路还原值=100	
伐木技能等级=2

采集物品名="柠檬草"
--采集
function StartWork()
	while true do
		if(取包裹空格() < 1)then break end	-- 包满回城
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "芙蕾雅")then break end	--地图切换 也返回
		工作("伐木","",6500)	--技能名 物品名 延时时间
		等待工作返回(6500)
	end 
	回城()
end


--主流程
function main()
	local skill=common.findSkillData("伐木")
	if(skill == nil)then
		日志("提示：没有伐木技能！",1)
		return
	end
	if(skill.lv < 伐木技能等级) then
		日志("提示：伐木技能等级不足，至少要"..伐木技能等级.."级技能！",1)
		return
	end
::begin::		
	等待空闲()	
	当前地图名=取当前地图名()
	mapNum=取当前地图编号() 
	if(mapNum == 100)then	--芙蕾雅
		goto map100			
	end
	设置("移动速度",走路加速值)
	
	if(取物品数量(采集物品名) >  3)then		
		goto cunYinHang 
	end
	common.supplyCastle()
	common.checkHealth()
	common.outFaLan("w")	--西门
	goto begin   

::map100::							--莎莲娜
	自动寻路(515,100)	
	设置("移动速度",走路还原值)
	StartWork()		
	goto begin	
::cunYinHang::
	common.gotoBankTalkNpc()
	银行("全存",采集物品名,40)	
	if(取包裹空格() < 2)then
		goto manle
	end
	goto begin 

::manle::	--可以在这加个仓库交易  懒得搞了
	日志("包裹满了，清理后执行",1)
	等待(12000)
	goto manle	

::End::
	return
end
main()
	
	

