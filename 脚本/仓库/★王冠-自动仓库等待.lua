
common=require("common")



--切换游戏账号部分
function tableSize(data)
	count = 0  
	for k,v in pairs(data) do  
		count = count + 1  
	end  
	return count
end
function 等待游戏窗口()
	tryNum=0
	while (游戏窗口状态() == false and tryNum < 15) do
		tryNum=tryNum+1
		等待(1000)
	end

end
function 登录游戏id(游戏id)	
	左右角色=0
	--切换游戏id
::switchCharacter::
	if(左右角色 > 1)then	--左右都已获取仓库 去下一个		
		return
	end
	重置登录状态()
	设置登录子账号(游戏id)
	设置登录角色(左右角色)	--左边
	登录游戏()
::checkCharacter::	--检查游戏角色和状态
	worldStatus=世界状态()
	gameStatus=游戏状态()
	if(loginState == 0 and string.find(loginMsg,"无法连上服务器") ~= nil)then
		重置登录状态()
		登录游戏()		
	end
	if(游戏窗口状态() == false)then --窗口被服务器干掉了 重新运行窗口
		重置登录状态()
		打开游戏窗口()
		等待(2000)
		等待游戏窗口()
	end
	if(worldStatus ==3  and gameStatus == 11)then  --判断有没有角色
		loginState,loginMsg = 取登录状态()
		if(loginState == 3 and string.find(loginMsg,"no character") ~= nil)then
			左右角色=左右角色+1				
			回到选择线路()
			goto switchCharacter
		elseif((loginState == 10000 or loginState == 0) and string.find(loginMsg,"角色数据读取失败") ~= nil)then
			--跳过 游戏已经登录
			左右角色=左右角色+1				
			回到选择线路()
			goto switchCharacter
		end	
	elseif(worldStatus ==2  and gameStatus == 1)then  --没有连接线
		登录游戏()
	end
	if(是否空闲中())then
		goto dengru
	end	
	等待(1000)
	goto checkCharacter
::dengru::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	mapNum =取当前地图编号()
	if (当前地图名=="银行" and mapNum== 1121)then	
		goto bankWait	
	end	
	common.gotoFalanBankTalkNpc()
	goto dengru
::saveData::
	获取仓库信息()
	保存仓库信息()
	左右角色=左右角色+1
	if(左右角色 > 1)then	--左右都已获取仓库 去下一个
		common.WriteFileData("王冠仓库.txt",tonumber(string.sub(人物("gid"),-3)))
		登出服务器()
		return
	end
	重置登录状态()
	设置登录子账号(游戏id)
	设置登录角色(左右角色)	--左边		
	登出服务器()
	等待(1000)	
	goto switchCharacter

	
::bankWait::
	if(取当前地图编号() ~= 1121)then
		common.gotoFalanBankTalkNpc()
	end
	
	移动(10,15)	
	topicMsg = {name=人物("名称"),bagcount=取包裹空格(),line=人物("几线")}
	发布消息("王冠仓库信息", common.TableToStr(topicMsg))	
	if(银行("金币") >= 1000000)then
		if(人物("金币") > 998000)then
			等待交易("","金币:2000","",10000)
		else
			等待交易("","","",10000)
		end
	else
		if(人物("金币") > 900000)then		
			goto cun
		else
			等待交易("","","",10000)		
		end
	end	
	if(取包裹空格() < 1)then
		goto cun
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
			goto saveData	--登出 切换仓库
		end
	else
		i=8
		while i<= 28 do
			银行("存包裹位置",i)
			i=i+1
			等待(500)
		end
	end
	goto bankWait	
end

function main()
::begin::
	游戏id列表=获取游戏子账户()	--登录成功才能获取
	if(tableSize(游戏id列表) > 0)then
		goto 切换游戏id
	else
		打开游戏窗口()
		等待(10000)
	end
	
	等待(1000)
	goto begin
	
::切换游戏id::
	readFileMsg = common.ReadFileData("王冠仓库.txt")
	if(readFileMsg == nil)then
		readFileMsg=0
	end
	lastGid = tonumber(readFileMsg)
	if(lastGid==nil)then lastGid=0 end
	日志("最后gid"..lastGid)
	if(tonumber(string.sub(人物("gid"),-3)) < lastGid)then
		登出服务器()
	end
	for k,v in pairs(游戏id列表) do  
		if(tonumber(string.sub(v,-3)) >= lastGid)then
			登录游戏id(v)
		end
	end  
	--获取完成 退出
	return
end

main()