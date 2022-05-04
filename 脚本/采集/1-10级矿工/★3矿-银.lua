★起始点：艾夏岛-法兰城任一传送石
-- function reload( moduleName )  
	-- package.loaded[moduleName] = nil  
	-- return require(moduleName)  
-- end
-- common=reload("common")
common=require("common")

设置("timer", 100)			-- 设置定时器，单位毫秒 内置100毫秒 不要太快
设置("自动战斗", 1)			-- 开启自动战斗，0不自动战斗，1自动战斗
设置("高速战斗", 1)			-- 高速战斗
设置("高速延时", 4)			-- 高速战斗速度，0不延时 
设置("遇敌全跑", 1)			-- 遇敌全跑 
设置("自动加血", 0)			-- 遇敌全跑 关闭自动加血，脚本对话加血 
走路加速值=110	
走路还原值=100	
挖矿技能等级=3
是否卖=用户输入框("是否卖！","1")

矿条名="银条"
矿石名="银"
--挖矿
function StartWork()
	while true do		
		if(取包裹空格() < 1)then break end	-- 奥利哈钢满回城
		if(人物("魔") <  1)then break end	-- 魔无回城
		if(取当前地图名() ~= "维诺亚洞穴 地下2楼" and  取当前地图编号() ~= 11502)then break end
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
	
	if(人物("职业")=="矿工" and 取物品数量("矿山钥匙") < 1)then
		NaYaoShi()
	end
::begin::		
	等待空闲()	
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
	StartWork()		
	goto begin		
::map11000::						--莎莲娜西方洞窟
	移动(49, 66)
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
	
	

