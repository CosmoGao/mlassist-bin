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
是否卖=用户输入框("是否卖！","1")

矿条名="铜条"
矿石名="铜"
--挖矿
function StartWork()
	while true do
		if(取包裹空格() < 1)then 
			扔叠加物(矿石名,40)
			break
		end	-- 奥利哈钢满回城
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "国营第24坑道 地下1楼")then break end	--地图切换 也返回
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

::begin::		
	等待空闲()	
	mapNum=取当前地图编号() 	
	if(mapNum == 11013) then	--国营第24坑道 地下1楼
		goto map11013	
	elseif(mapNum == 100)then	--芙蕾雅
		goto map100			
	end
	设置("移动速度",走路加速值)
	if(取包裹空格() < 2)then		-- 去压矿
		if(是否卖)then		
			扔叠加物(矿石名,40)
			common.sellCastle(矿石名)
		else
			StartRefine() 
		end
	end		
	if(取物品数量(矿条名) >  3)then		
		goto cunYinHang 
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
	
	

