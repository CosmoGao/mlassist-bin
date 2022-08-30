

common=require("common")


args={x=8,y=8,topic="十年魔戒发放员",publish="领取十年魔戒",itemName="十周年纪念戒指",itemCount=1,itemPileCount=1}
--waitTradeItemsAction(args)
--等待交易("幻々古","物品:王冠|1|1","",10000)	

common.warehouseOnlineWait("十年魔戒出纳仓库.txt",common.waitProvideTradeItemsAction,args)