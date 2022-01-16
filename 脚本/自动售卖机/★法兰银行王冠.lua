法兰银行售卖王冠

王冠价格=50000

common=require("common")

function 取银行物品数量(itemName)
	local count=0
	local bankData = 银行("物品")
	for i,item in ipairs(bankData) do
		if( item.name == itemName)then
			count=count+1
		end
	end
	return count
end


function 银行存取金币(金额,存取)
	if(金额 == nil) then 
		return
	end
	当前地图名 = 取当前地图名()
	if(当前地图名 == "银行")then --1121  法兰银行编码
		移动(11,8)	
	else
		return
	end
	转向(2)
	等待服务器返回()
	if(存取==nil or 存取=="存")then
		bankGold = 银行("金币")
		日志("银行现有"..bankGold.."金币，预存"..金额,1)
		--100万算
		ableGold = 1000000-bankGold
		if(金额 >= ableGold )then
			银行("存钱",金额)	
		else
			curGold = 人物("金币")
			while true do				
				银行("存钱",100000)	
				等待(2000)
				if(curGold ==人物("金币")) then
					ableGold=1000000-银行("金币")
					银行("存钱",ableGold)	
					日志("银行金币满了,请倒仓库",1)
					是否钱满=true
					break
				end
				curGold = 人物("金币")
			end		
		end
	else
		curGold=人物("金币")
		银行("取钱",金额)
		等待(2000)
		if(curGold ==人物("金币")) then
			银行("取钱",银行("金币"))
			日志("银行没有钱了,请倒仓库",1)			
		end
	end
end

function main()
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local x,y=取当前坐标()	
	if (当前地图名 =="艾尔莎岛" )then goto aiersa
	elseif(当前地图名 ==  "里谢里雅堡")then goto LiBao 		
	elseif(当前地图名 ==  "法兰城")then goto FaLan 		
	elseif(当前地图名 ==  "银行")then goto 卖货 		
	end	
	回城()
	等待(1000)
	goto begin
::aiersa::
	等待到指定地图("艾尔莎岛")
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
::LiBao::
	等待到指定地图("里谢里雅堡")	
	移动(34,89)
	回复(1)			-- 转向北边恢复人宠血魔
    common.gotoFaLanCity("e2")		
	等待到指定地图("法兰城")	
	移动(238,111,"银行")	
	移动(11,8)	
	goto 卖货
::FaLan::
	common.gotoFaLanCity("e2")		
	等待到指定地图("法兰城")	
	移动(238,111,"银行")	
	移动(11,8)	
	goto 卖货
::卖货::	
	if(人物("坐标")  ~= "11,5")then
		移动(11,5)
	end	
	日志("王冠5W一个，加队自己交易！",1)
	if(取物品数量("王冠") < 1)then goto 取货 end		
	if(取当前地图名() ~= "银行") then goto begin end
	if(人物("金币") > 950000) then
		银行存取金币(950000,"存")
		goto begin
	end		
	转向(6)
	等待交易("","物品:王冠|1|1","金币:50000",10000)	
	等待(2000)
	goto 卖货  
::取货::
	if(取当前地图名() ~=  "银行")then 
		common.gotoBankTalkNpc()
		银行("全取","王冠")
	end	
	移动(11,8)
	转向(2)
	等待服务器返回()
	银行("全取","王冠")
	if(取物品数量("王冠") > 1)then goto 卖货 end		
	if(取银行物品数量("王冠") < 1)then
		goto 等上货喊话
	end
	goto 取货
::等上货喊话::
	日志("银行没有存货了，等待上货!",1)
	等待(5000)
	goto 收货
::收货::
	if(人物("坐标")  ~= "11,5")then
		移动(11,5)
	end	
	日志("银行没有存货了，等待上货!",1)
	转向(6)
	等待交易("","","",10000)		
	if(取物品数量("王冠") > 10)then
		goto 卖货
		-- 移动(11,8)
		-- 转向(2)
		-- 等待服务器返回()
		-- 银行("全存","王冠")
	end
	等待(5000)
	goto 收货
end
main()