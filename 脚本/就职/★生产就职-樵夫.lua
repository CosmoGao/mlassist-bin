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
	if(取物品叠加数量("孟宗竹") < 20 )then		
		if(common.findSkillData("伐木体验") == nil)then		
			日志("提示：没有伐木体验技能！",1)
			common.outCastle("e")		
			自动寻路(195,50,"职业介绍所")
			自动寻路(8,10)
			common.learnPlayerSkill(8,11)
			goto begin		
		else		
			if(取当前地图名()~="芙蕾雅")then
				common.outFaLan("e")
			end			
			自动寻路(484, 198)			
			while true do
				if(取包裹空格() < 1)then break end	-- 包满回城
				if(人物("魔") <  1)then break end	-- 魔无回城
				if(取当前地图名() ~= "芙蕾雅")then break end	--地图切换 也返回
				if(取物品叠加数量("孟宗竹") >20)then break end
				工作("伐木体验","",6500)	--技能名 物品名 延时时间
				等待工作返回(6500)
			end 
			回城()
			goto begin	
		end
	end	
	
	if(取物品数量("樵夫推荐信")>0)then
		common.outCastle("e")		
		自动寻路(195,50,"职业介绍所")
		自动寻路(7, 10)
		转向坐标(7,11)
		等待服务器返回()
		对话选择(0,0)
		等待服务器返回()
		对话选择(32,-1)
		等待服务器返回()
		对话选择(0,0)
		等待(2000)
		if(人物("职业") == "见习樵夫")then
			日志("就职樵夫成功！")
		else		
			日志("就职樵夫失败，请手动查看原因")				
		end
		goto begin		
	end
	if(取物品数量("18212") > 0)then	--艾文的饼干
		common.gotoFaLanCity("s1")
		自动寻路(107, 191)
		while true do 
			npc=查周围信息("樵夫弗伦",1)
			if(npc ~= nil) then
				对话选是(106, 191)
				break
			else
				日志("当前时间是【"..游戏时间().."】，等待【凌晨或白天】")
				等待(30000)
			end		
		end		
		日志("换取樵夫推荐信",1)
		goto begin
	end
	if(取物品数量("18178") > 0)then	--木材
		common.outCastle("e")	
		自动寻路(216, 148,"艾文蛋糕店")
		自动寻路(11,6)
		对话选是(12,5)
		日志("换艾文的饼干",1)
		goto begin
	end
	if(取物品数量("18181") > 0)then	--水色的花
		common.gotoFaLanCity("s1")
		自动寻路(107, 191)
		while true do 
			npc=查周围信息("樵夫弗伦",1)
			if(npc ~= nil) then
				对话选是(106, 191)
				break
			else
				日志("当前时间是【"..游戏时间().."】，等待【凌晨或白天】")
				等待(30000)
			end		
		end				
		日志("换取木柴",1)
		goto begin
	end
	if(取物品数量("18180") > 0) then	--树苗
		common.gotoFaLanCity("s1")
		自动寻路(134, 37)
		
		while true do 
			npc=查周围信息("种树的阿姆罗斯",1)
			if(npc ~= nil) then
				对话选是(134, 36)
				break
			else
				日志("当前时间是【"..游戏时间().."】，等待【凌晨或白天】")
				等待(30000)
			end		
		end				
		日志("换取水色的花",1)
		goto begin
	end	
	if(取物品数量("18179") > 0)then		--有手斧换树苗
		common.gotoFaLanCity("s1")
		自动寻路(107, 191)
		while true do 
			npc=查周围信息("樵夫弗伦",1)
			if(npc ~= nil) then
				对话选是(106, 191)
				break
			else
				日志("当前时间是【"..游戏时间().."】，等待【凌晨或白天】")
				等待(30000)
			end		
		end				
		日志("换取树苗",1)
		goto begin
	else								--孟宗竹换手斧
		common.outCastle("e")	
		自动寻路(216, 148,"艾文蛋糕店")
		自动寻路(11,6)
		对话选是(12,5)
		日志("手斧",1)
		goto begin
	end	
	goto begin	
end

main()