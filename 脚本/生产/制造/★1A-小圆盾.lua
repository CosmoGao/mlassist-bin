做1A长剑冲技能，起始点任意，要求定居法兰城  魔至少500，会挖掘、伐木、做剑、治疗  设定好自动叠加铜条&20、铜&40、印度轻木&40  星落制作：274100927 


 
common=require("common")

--设置("高速延时",3) 
设置("自动加血",0)
设置("高速延时",4)  
设置("高速战斗",1)  
设置("自动战斗",1)  
设置("遇敌全跑",1)  

设置("自动叠",1,"印度轻木&40")
设置("自动叠",1,"铜条&20")
设置("自动叠",1,"铜&40")
设置("自动扔",1,"卡片？")
设置("自动扔",1,"魔石")
设置("自动扔",1,"盐")
身上最少金币=5000			--少于去取
身上最多金币=950000			--大于去存
身上预置金币=200000			--取和拿后 身上保留金币
矿石名="铜"
铜条数量=64
制造物品名="小圆盾"
麻布数量=16
合成所需矿条数量=4
合成所需麻布数量=1
function 采集铜矿()	
	while true do
		if(取包裹空格() < 1)then break end	-- 包满回城		
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
	移动(26,24,"法兰城")
end

function main()

::begin::
	等待空闲()
	common.checkGold(身上最少金币,身上最多金币,身上预置金币)
	mapName=取当前地图名()
	if(mapName~="芙蕾雅" and mapName~="国营第24坑道 地下1楼")then			--加在这，主要是随时启动脚本原地复原
		common.supplyCastle()
		common.checkHealth()	
	end	
	if(取物品数量(制造物品名) >= 1)then
		common.toCastle()
		移动(40, 98,"法兰城")	
		移动(150, 123)
		卖(0,制造物品名)	
		goto begin
	end
	if(取物品叠加数量('铜条')< 铜条数量)then	
		if(取当前地图名() == "国营第24坑道 地下1楼")then					
			采集铜矿()	
			goto begin
		elseif(取物品叠加数量(矿石名) > 200)then	--回城加魔 或者掉线回城时 矿石有5组先换矿
			StartRefine() 
		end		
		if(取物品叠加数量('铜条')< 铜条数量)then	
			common.outFaLan("w")	--西门
			移动(351, 145,11013)			
			采集铜矿()
		end				
		goto begin
	end
	if(取物品叠加数量('麻布')< 麻布数量)then				
		if(取当前地图名() ~= "流行商店")then
			common.gotoFaLanCity()
			移动(117, 112,"流行商店")
		end
		移动(8,7)
		转向(0)
		等待服务器返回()		
		对话选择(0, 0)
		等待服务器返回()		
		买(0,麻布数量-取物品叠加数量('麻布'))
		goto begin
	end					
	goto work
::work::
	合成(制造物品名)	
	if(取包裹空格() < 1) then goto  pause end			
	if(取物品叠加数量("铜条") < 合成所需矿条数量 or 取物品叠加数量("麻布") < 合成所需麻布数量 )then 
		common.supplyCastle()	--正好在旁边 补完再走
		goto begin 
	end			
	if(人物("魔") <  50) then 
		common.supplyCastle() 		
	end
	goto work 
::pause::	
	叠("铜条", 20)
	叠("麻布", 20)	
	if(取包裹空格() < 1) then goto begin end			
	goto work 
end
main()
