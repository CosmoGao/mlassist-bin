

common=require("common")
::begin::
	common.toTeleRoom("圣拉鲁卡村")	
	自动寻路(7, 3,"村长的家")
	自动寻路(2, 9,"圣拉鲁卡村")
	自动寻路(32, 70,"装备品店")
	自动寻路(14, 4,"1楼小房间")
	自动寻路(9, 3,"地下工房")
	自动寻路(18, 31)
	转向坐标(17, 31)
	等待服务器返回()
	对话选择(0,2)
	等待服务器返回()
	对话选择(0,0)	
	等待(2000)
