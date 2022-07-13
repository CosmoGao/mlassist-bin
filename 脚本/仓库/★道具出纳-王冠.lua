

common=require("common")
--common.warehouseOnlineWait("王冠仓库.txt",common.waitTradeItemsAction,{x=10,y=15,topic="王冠仓库信息"})
-- local topicList={"领取王冠"}
-- 订阅消息(topicList)
--预置交易道具函数
function waitTradeItemsAction(args)
	local mapName=""
	local mapNum=0
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
		移动(3,9)
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

	移动(args.x,args.y)	
	topicMsg = {name=人物("名称"),bagcount=取包裹空格(),line=人物("几线")}
	发布消息(args.topic, common.TableToStr(topicMsg))	
	topic,msg=等待订阅消息(10000)
	日志(topic.." Msg:"..msg)
	if(topic == "领取王冠")then
		recvTbl = common.StrToTable(msg)			
	end	
	等待空闲()	
	if(recvTbl~=nil and recvTbl.name ~= nil and recvTbl.bagcount ~= nil)then	
		日志("等待交易"..recvTbl.name)
		等待交易(recvTbl.name,"物品:王冠|1|1","",10000)	
	else
		人物动作(14)
		
	end
	goto bankWait
::cun::
	移动(11,8)
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
	等待(1000)
	银行("取钱",2000)
	if(银行("已用空格") == 20)then	--默认20
		if(取包裹空格() < 1)then
			return	--登出 切换仓库
		end
	else
		i=8
		while i<= 28 do
			银行("存包裹位置",i)
			i=i+1
			等待(1000)
		end
	end
	goto bankWait
end

args={x=9,y=8,topic="王冠发放员",publish="领取王冠",itemName="王冠",itemCount=1,itemPileCount=1}
--waitTradeItemsAction(args)
--等待交易("幻々古","物品:王冠|1|1","",10000)	

common.warehouseOnlineWait("王冠出纳仓库.txt",common.waitProvideTradeItemsAction,args)