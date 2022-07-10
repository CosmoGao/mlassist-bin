屏蔽的是自己实现相应交易代码函数，需要修改的打开修改即可

common=require("common")
common.warehouseOnlineWait("T98仓库信息.txt",common.waitTradeItemsAction,{x=10,y=16,topic="T98仓库信息"})