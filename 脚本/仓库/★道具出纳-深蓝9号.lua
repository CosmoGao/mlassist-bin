发放深蓝9号

common=require("common")

args={x=7,y=8,topic="深蓝9号发放员",publish="领取深蓝9号",itemName="香水：深蓝九号",itemCount=1,itemPileCount=3}

common.warehouseOnlineWait("深蓝9号出纳仓库.txt",common.waitProvideTradeItemsAction,args)