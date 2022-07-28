★定居艾尔莎岛，。

common=require("common")

设置("遇敌全跑",1)
function main()
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)   	
::begin::
	等待空闲()     
	if(取物品数量("水果蕃茄") > 0)then	
		common.outFaLan("e")
		自动寻路(509, 153,"山男的家")	
		自动寻路(8,3)
		对话选是(9,3)
		goto begin
	end	
	if(取物品数量("莫洛草") > 0) then	--给葛利玛的信？
		common.toTeleRoom("圣拉鲁卡村")	
		自动寻路(7, 3,"村长的家")
		自动寻路(2, 9,"圣拉鲁卡村")	
		自动寻路(37, 50,"医院")	
		自动寻路(8, 5)
		对话选是(8,4)	
		goto begin		
	end	
	if(取物品数量("药剂师推荐信") > 0) then	--给葛利玛的信？
		if(取当前地图编号()==2310)then
			自动寻路(14, 11,"医院 2楼")
		elseif(取当前地图编号()==2311)then
			自动寻路(12, 6)
			对话选是(12,5)	
		else
			自动寻路(7, 3,"村长的家")
			自动寻路(2, 9,"圣拉鲁卡村")	
			自动寻路(37, 50,"医院")	
			自动寻路(14, 11,"医院 2楼")
			自动寻路(12, 6)
			对话选是(12,5)	
			return
		end
	else
		common.toCastle("f1")
		自动寻路(103,21,"厨房")
		自动寻路(8,7)
		对话选是(8,6)
		goto begin		
	end		
	goto begin		
end

main()