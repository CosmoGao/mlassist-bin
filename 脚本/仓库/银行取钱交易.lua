
交易名称="￠幽幽￠"
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	mapNum=取当前地图编号()
	if (当前地图名=="艾尔莎岛" )then	
		goto aiersha	
	elseif(mapNum == 59548)then
		goto aiBank	
	end	
	回城()
	等待(2000)
	goto begin
::aiersha::
	自动寻路(157,94)	
	转向坐标(158,93)		
	等待到指定地图("艾夏岛")	
	自动寻路(114,105)	
	自动寻路(114,104)	
::aiBank::
	等待到指定地图("银行")		
	if(人物("名称") == 交易名称)then goto cun 
	else goto qu end
::cun::
	自动寻路(49,30)
	面向("东")
	等待服务器返回()
	bankGold = 银行("金币")
	cGold=人物("金币")
	if(bankGold > 1000000)then	--银行金币大于100万 取最小值
		cGold =  math.min(10000000-bankGold,cGold)
	else
		cGold =  math.max(1000000-bankGold,cGold)
	end
	银行("存钱",cGold)
	while true do
		if(人物("坐标")  ~= "49,30")then
			goto cun			
		end				
		等待交易("","","",10000)
		if(人物("金币") > 900000)then
			goto cun
		end
	end
	goto cun
	
::qu::
	自动寻路(49,30)
	面向("东")
	等待服务器返回()
	bankGold = 银行("金币")
	quCount= 1000000-人物("金币")
	银行("取钱",quCount)
	移动到目标附近(49,30)
	转向坐标(49,30)
	交易(交易名称,"金币:"..人物("金币"),"",9000)	
	if(人物("金币") < 150000)then
		goto qu
	end
	if(银行("金币") < 50000)then
		日志("银行没有金币了"..银行("金币"),1)
	end
	