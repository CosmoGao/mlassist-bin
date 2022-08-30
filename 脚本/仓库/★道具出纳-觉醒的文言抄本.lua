

common=require("common")


args={x=7,y=13,topic="觉醒的文言抄本发放员",publish="领取觉醒的文言抄本",itemName="觉醒的文言抄本",itemCount=1,itemPileCount=1}


common.warehouseOnlineWait("觉醒的文言抄本出纳仓库.txt",common.waitProvideTradeItemsAction,args)
--common.waitProvideTradeItemsAction(args)