★定居艾尔莎岛，。

common=require("common")

设置("遇敌全跑",1)
function main()
	common.supplyCastle()
	common.sellCastle()		--默认卖
	common.checkHealth(医生名称)   
	回城()	
::begin::
	等待空闲()     
	if(取物品数量("有关矿石成分的笔记") > 0)then	
		common.outCastle("e")	
		移动(196,78,"凯蒂夫人的店")
		移动(12,9)
		对话选是(13,9)
		日志("钙",1)
		goto begin
	end	
	if(取物品数量("18168") > 0) then	--给葛利玛的信？
		common.outCastle("e")	
		移动(216, 43,"葛利玛的家")		
		移动(12,13)
		对话选是(13,13)
		goto begin
	end	
	if(取物品数量("梦露草") > 0)then
		common.gotoFaLanCity("w1")	
		移动(22, 87,"芙蕾雅")	
		移动(351, 145,"国营第24坑道 地下1楼")	
		移动(34,8)
		对话选是(35,7)
		goto begin
	end
	if(取物品数量("给山男的信？") > 0)then	--18167
		common.outFaLan("e")
		移动(509, 153,"山男的家")	
		移动(8,3)
		对话选是(9,3)
		goto begin
	end
	if(取物品数量("钙矿") > 0)then
		common.gotoFaLanCity("w1")	
		移动(22, 87,"芙蕾雅")	
		移动(351, 145,"国营第24坑道 地下1楼")	
		移动(34,8)
		对话选是(35,7)
		goto begin
	else
		common.outCastle("e")
		移动(196,78,"凯蒂夫人的店")
		移动(12,9)
		对话选是(13,9)	
	goto begin		
	end		

end

main()