★起点艾尔莎岛登入点，自动UD脚本，路上默认逃跑，使用前，男和女2人组队，脚本自动获取队伍中ud男女信息，失败则默认取队长名称。组队的话 路上请勿逃跑 不然火车不等人


ud={}
function ud.main()
	local sex = 人物("性别")
	日志("自动UD脚本，当前识别到的人物性别："..sex,1)
	if(sex == "男")then
		执行脚本("./脚本/★转正/★UD男-单人.lua")
	elseif(sex == "女")then
		执行脚本("./脚本/★转正/★UD女-单人.lua")
	else
		日志("获取人物性别失败，脚本退出",1)
	end
end
ud.main()

return ud