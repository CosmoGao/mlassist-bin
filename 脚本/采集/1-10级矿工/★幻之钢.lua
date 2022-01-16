★起始点：艾夏岛-法兰城任一传送石
function reload( moduleName )  
	package.loaded[moduleName] = nil  
	return require(moduleName)  
end
common=reload("common")
--common=require("common")

设置("timer", 100)			-- 设置定时器，单位毫秒 内置100毫秒 不要太快
设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 遇敌全跑 
设置("自动加血", 0)			-- 遇敌全跑 关闭自动加血，脚本对话加血 
走路加速值=110	
走路还原值=100	
挖矿技能等级=7


矿条名="幻之钢条"
矿石名="幻之钢"
--挖矿
function StartWork()
	while true do
		if(取包裹空格() < 1)then break end	-- 包满回城
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "莎莲娜海底洞窟 地下2楼")then break end	--地图切换 也返回
		工作("挖掘","",6500)	--技能名 物品名 延时时间
		等待工作返回(6500)
	end 
	回城()
end

--换矿
function StartRefine()
	common.gotoFaLanCity("w1")		
	移动(106, 61,"米克尔工房")	
	common.faLanExchangeMine(矿石名)
	回城()
end
--主流程
function main()
	local skill=common.findSkillData("挖掘")
	if(skill == nil)then
		日志("提示：没有挖掘技能！",1)
		return
	end
	if(skill.lv < 挖矿技能等级) then
		日志("提示：挖矿技能等级不足，至少要"..挖矿技能等级.."级技能！",1)
		return
	end
::begin::		
	等待空闲()	
	当前地图名=取当前地图名()
	mapNum=取当前地图编号() 
	if(mapNum == 15002) then	--莎莲娜西方洞窟
		goto map15002
	elseif(mapNum == 15001)then	--莎莲娜西方洞窟
		goto map15001	
	elseif(mapNum == 4099)then	--杰诺瓦镇的传送点
		goto map4099
	elseif(mapNum == 4012)then	--村长的家
		goto map4012		
	elseif(mapNum == 4000)then	--杰诺瓦镇
		goto map4000
	elseif(mapNum == 400)then	--莎莲娜
		goto map400			
	end
	设置("移动速度",走路加速值)

	if(取包裹空格() < 1)then		-- 去压矿
		StartRefine() 
	end		
	if(取物品数量(矿条名) >  3)then		
		goto cunYinHang 
	end
	common.supplyCastle()
	common.checkHealth()
	common.toTeleRoom("杰诺瓦镇")	
	goto begin   

::map4099::							--杰诺瓦镇的传送点
	等待到指定地图("杰诺瓦镇的传送点")
	移动(14, 6,"村长的家")
::map4012::							--村长的家
	移动(1, 9,"杰诺瓦镇")
::map4000::							--杰诺瓦镇
	移动(24, 40,"莎莲娜")	
::map400::							--莎莲娜
	移动(196, 443,"莎莲娜海底洞窟 地下1楼")	
::map15002::						--莎莲娜海底洞窟
	移动(14, 41,"莎莲娜海底洞窟 地下2楼")
::map15001::						--莎莲娜海底洞窟
	移动(8, 42)
	设置("移动速度",走路还原值)
	StartWork()		
	goto begin	
::cunYinHang::
	common.gotoBankTalkNpc()
	银行("全存",矿条名,20)	
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
	
	

