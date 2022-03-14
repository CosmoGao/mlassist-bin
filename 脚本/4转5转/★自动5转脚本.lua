★5转任务脚本，加入自动组队功能

function 判断是否队长()
	local teamPlayers=队伍信息()
	local count=0
	for i,teammate in ipairs(teamPlayers)do
		count=count+1		
		if( i==1 and teammate.name == 人物("名称")) then				
			return true
		else
			break
		end
	end
	return false
end	
function main()
	if(判断是否队长())then
		切换脚本("./脚本/4转5转/★5转任务-队长.lua")	
	else
		切换脚本("./脚本/4转5转/★5转任务-队员.lua")		
	end
end

main()
