设置脚本简介("辅助登录界面填写账号信息，点击统计道具,自动运行此脚本！此脚本会辅助程序进行账号信息获取，包括身上物品、宠物、金币、银行物品、宠物、金币！")
--设置("timer",100)

数字尾号=1
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
	if(是否空闲中())then --登出服务器
		登出服务器()	
	end
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
			name="落￠仓库左"..数字尾号
			if(左右角色==0)then
				name="落￠仓库左"..数字尾号			
			else
				name="落￠仓库右"..数字尾号			
			end				
			设置创建角色信息(true,name,12,1,1,1,"15,0,0,15,0","10,0,0,0")	
			左右角色=左右角色+1				
			回到选择线路()
			goto switchCharacter
		elseif((loginState == 10000 or loginState == 0) and string.find(loginMsg,"角色数据读取失败") ~= nil)then
			--跳过 游戏已经登录
			左右角色=左右角色+1				
			回到选择线路()
			goto switchCharacter
		end	
		登录游戏()
	elseif(worldStatus ==2  and gameStatus == 1)then  --没有连接线
		登录游戏()	
	elseif(worldStatus ==2  and gameStatus == 101)then  --无法连接服务器
		登录游戏()
	elseif(worldStatus ==4  and gameStatus == 101)then  --名字重复
		数字尾号=数字尾号+1
		name="落￠仓库左"..数字尾号
		if(左右角色==0)then
			name="落￠仓库左"..数字尾号			
		else
			name="落￠仓库右"..数字尾号			
		end				
		设置创建角色信息(true,name,12,1,1,1,"15,0,0,15,0","10,0,0,0")	
		日志("创建角色名称："..name)
		登录游戏()
		等待(2000)
	end
	if(是否空闲中())then
		登出服务器()
		左右角色=左右角色+1
		等待(1000)	
		goto switchCharacter
	end	
	等待(1000)
	goto checkCharacter
::waitlogin::--等待登录游戏成功
	if(是否空闲中())then
		登出服务器()
		左右角色=左右角色+1
		等待(1000)	
		goto switchCharacter
	end	
	等待(2000)	
	goto waitlogin
::dengru::
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto star1
	elseif (当前地图名=="里谢里雅堡" )then	
		goto star2
	elseif (当前地图名=="法兰城" )then	
		goto faLan
	elseif (当前地图名=="召唤之间" )then	--登出 bank
		goto saveData
	end	
	goto waitlogin
::star1::
	移动(157,94)	
	转向坐标(158,93)		
	等待到指定地图("艾夏岛")	
	移动(114,105)	
	移动(114,104)	
	等待到指定地图("银行")	
	移动(49,30)
	面向("东")
	等待服务器返回()
    goto saveData
::star2::		
	移动(41,98)	
	等待到指定地图("法兰城")	
	移动(162, 130)		
    goto faLan
::saveData::
	获取仓库信息()
	保存仓库信息()
	登出服务器()
	左右角色=左右角色+1
	等待(1000)	
	goto switchCharacter
::faLan::
	x,y=取当前坐标()	
	if (x==72 and y==123 )then	-- 西2登录点
		goto  w2
	elseif (x==233 and y==78 )then	-- 东2登录点
		goto  e2
	elseif (x==162 and y==130 )then	-- 南2登录点
		goto  s2
	elseif (x==63 and y==79 )then	-- 西1登录点
		goto  w1
	elseif (x==242 and y==100 )then	-- 东1登录点
		goto  e1
	elseif (x==141 and y==148 )then	-- 南1登录点
		goto  s1
	end
	goto dengru
::faLanBank::		
	等待到指定地图("法兰城")	
	移动(238,111)
	等待到指定地图("银行")	
	移动(11,8)
	面向("东")
	等待服务器返回()
    goto saveData	


::w2::	-- 西2登录点
	转向(2)			-- 转向东	
	等待到指定地图("法兰城",233,78)		
	goto faLanBank

::e2::	-- 东2登录点	
	goto faLanBank

::s2::	-- 南2登录点	
	转向(2)	
	goto faLan	

::w1::	-- 西1登录点
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 242, 100)		
	goto faLanBank


::e1::	-- 东1登录点
	goto faLanBank

::s1::	-- 南1登录点		
	转向(0)		-- 转向北	
	等待到指定地图("法兰城", 63, 79)		
	goto faLan
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
	for k,v in pairs(游戏id列表) do  
		if(v ~= "account0001" and v ~= "account0002")then
			登录游戏id(v)
		end
	end  
	--获取完成 退出
	return
end

main()