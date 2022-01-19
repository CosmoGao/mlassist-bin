★定居艾尔莎岛，。

common=require("common")

设置("遇敌全跑",1)
function main()

::menu::
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)  
::begin::
	等待空闲()     
	if(取物品数量("矿工推荐信") > 0)then	
		common.toCastle("f1")
		移动(45,20,"启程之间")	
		移动(43, 43)	
		离开队伍()
		转向(2)
		dlg=等待服务器返回()
		if(dlg.message~=nil and string.find(dlg.message,"此传送点的资格")~=nil)then
			回城()
			执行脚本("./脚本/直通车/★开传送-圣拉鲁卡村.lua")	
		else
			转向(2)
			等待服务器返回()
			对话选择(4, 0)
		end	
		移动(7, 3,"村长的家")
		移动(6, 14,"村长的家 2楼")		
		移动(8,5)
		--对话选是(35,7)	
		return
	end	
	if(取物品数量("便当？") > 0)then	
		common.gotoFaLanCity("w1")	
		移动(22, 87,"芙蕾雅")	
		移动(351, 145,"国营第24坑道 地下1楼")	
		移动(34,8)
		对话选是(35,7)		
		goto begin
	end	
	if(取物品数量("矿石？") > 0)then	
		common.outCastle("e")	
		移动(196,78,"凯蒂夫人的店")
		移动(12,9)
		对话选是(13,9)			
		goto begin
	end	
	if(取物品数量("给那尔薇的信") > 0) then	--给葛利玛的信？
		if(取当前地图名()=="凯蒂夫人的店")then
			移动(4,13,"法兰城")
		else
			common.outCastle("e")				
		end		
		移动(206,37,"毕夫鲁的家")
		移动(8,4)
		对话选是(8,3)
		goto begin
	end	
	if(取物品数量("饮料？") > 0)then
		common.gotoFaLanCity("w1")	
		移动(22, 87,"芙蕾雅")	
		移动(351, 145,"国营第24坑道 地下1楼")	
		移动(34,8)
		对话选是(35,7)
		goto begin
	end
	if(取物品叠加数量("铜") > 20)then
		common.outCastle("e")	
		移动(206,37,"毕夫鲁的家")
		移动(8,4)
		对话选是(8,3)
		goto begin
	else
		skill = common.findSkillData("挖矿")
		if(skill == nil)then
			common.gotoFaLanCity()	
			移动(200,132,"基尔的家")
			移动(9,3)
			common.learnPlayerSkill(9,2)					
		end		
		common.gotoFaLanCity("w1")	
		移动(22, 87,"芙蕾雅")	
		移动(351, 145)	
		while true do
			if(取物品叠加数量("铜") > 20)then break end	
			if(人物("魔") < 1)then break end	-- 魔无回城
			if(取当前地图名() ~= "国营第24坑道 地下1楼")then break end	--地图切换 也返回
			工作("挖掘","",6500)	--技能名 物品名 延时时间
			等待工作返回(6500)
		end 
		goto begin
	end
end

main()