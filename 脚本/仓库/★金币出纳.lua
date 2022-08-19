
common=require("common")


waitAction = function()
	local mapName=""
	local mapNum=0
	local tradeGold=0
	local tradeInfo=""
	local topicList={"领取金币"}
	订阅消息(topicList)
::begin::
	等待空闲()
	mapName = 取当前地图名()
	mapNum =取当前地图编号()
	if (mapName=="艾尔莎岛" or mapName=="法兰城" or mapName=="里谢里雅堡" )then	
		common.gotoFalanBankTalkNpc()
		goto bankWait
	elseif (mapName=="银行" and mapNum== 1121)then	
		goto bankWait
	elseif (mapName=="召唤之间" )then	--登出 bank
		自动寻路(3,9)
		对话选是(4,9)
		回城()
		common.gotoFalanBankTalkNpc()
		goto bankWait
	end	
	回城()
	等待(1000)	
	goto begin
::bankWait::
	if(取当前地图编号() ~= 1121)then
		common.gotoFalanBankTalkNpc()
	end
	自动寻路(10,13)
	topicMsg = {name=人物("名称"),gold=人物("金币"),line=人物("几线")}
	发布消息("金币出纳信息", common.TableToStr(topicMsg))
	topic,msg=等待订阅消息(10000)
	日志(topic.." Msg:"..msg)
	if(topic == "领取金币")then
		recvTbl = common.StrToTable(msg)			
	end	
	等待空闲()	
	if(recvTbl~=nil and recvTbl.name ~= nil and recvTbl.needGold ~= nil)then	
		日志("等待交易"..recvTbl.name)
		
		if(人物("金币") < recvTbl.needGold)then	--人物金币 小于要领取的金币 交易身上的金币
			tradeGold=人物("金币")
		else
			tradeGold = recvTbl.needGold
		end
		tradeInfo="金币:"..tradeGold
		等待交易(recvTbl.name,tradeInfo,"",10000)	
	else
		人物动作(14)		
	end	
	if(人物("金币") <= 100000 and 银行("金币") > 0)then	--人物身上钱少于10W时候 去银行拿钱 直到银行没钱
		goto 银行去拿钱
	elseif(人物("金币") <= 0)then		--身上没有钱了，去银行再问一遍 还没有的话 会登出
		goto 银行去拿钱		
	end	
	goto bankWait
::cun::
	自动寻路(11,8)
	面向("东")
	等待服务器返回()
	bankGold = 银行("金币")
	cGold=人物("金币")
	if(bankGold > 1000000)then	--银行金币大于100万 取最小值
		cGold =  math.min(10000000-bankGold,cGold)
	else
		cGold =  math.min(1000000-bankGold,cGold)
	end
	银行("存钱",cGold)
	等待(2000)
	if(人物("金币")>=1000000)then	
		return	--登出 切换仓库
	end
	goto bankWait	
::银行去拿钱::
	自动寻路(11,8)
	转向(2)
	等待服务器返回()
	银行("取钱",1000000)	--全取
	等待(2000)
	if(人物("金币") <= 0 and 银行("金币") <= 0)then
		日志("当前仓库没有钱了，切换下个角色"..人物("名称"),1)
		return
	end
	goto begin
end
common.warehouseOnlineWait("金币出纳仓库.txt",waitAction)
--common.warehouseOnlineWait("金币仓库.txt",common.waitTradeGoldAction,{x=10,y=13,topic="金币仓库信息"})
--waitAction()