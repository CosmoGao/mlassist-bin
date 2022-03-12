★定居艾尔莎岛，。

common=require("common")

function main()	
	回城()	
	common.outCastle("e")		
	移动(195,50,"职业介绍所")
	移动(7, 10)
	转向坐标(7,11)
	等待服务器返回()
	对话选择(0,2)
	等待服务器返回()
	对话选择(0,0)	
	等待(2000)

end

main()