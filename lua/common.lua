-- 文件名为 common.lua
-- 定义一个名为 common 的模块

common={}
cjson = require "cjson"

--读取文件内容
function common.ReadFileData(name)
	if(name ==nil)then return "" end
	local file = io.open(字符串转换(取程序路径().."data/"..name), "r+")		
	if(file==nil)then 
		日志("本地仓库文件为空",1) 
		return nil
	else
		readFileMsg = file:read("*a")	
		file:close()
		return readFileMsg
	end
end
--覆盖写入文件
function common.WriteFileData(name,data)
	if(data == nil or name ==nil)then return false end
	local tryCount=0
	while tryCount < 3 do
		local file = io.open(字符串转换(取程序路径().."data/"..name), "w+")		
		if(file ~= nil)then
			file:write(data)
			file:close()
			return true
		end
		tryCount = tryCount + 1
	end
	return false
end
--文件是否存在
function common.IsExistFile(name)
	local file = io.open(字符串转换(取程序路径().."data/"..name), "r+")	
	if(file==nil)then 
		return false	
	end
	file:close()
	return true
end

--打开仓库文件 并返回文件句柄,文件不存在则建立，需要外部关闭
function common.OpenFile(name)
	local file = io.open(字符串转换(取程序路径().."data/"..name), "r+")	
	if(file==nil)then 
		日志("本地仓库文件不存在，建立仓库文件",1) 
		file = io.open(字符串转换(取程序路径().."data/"..name), "w+")	
	end
	return file
end

--获取表大小
function common.getTableSize(tmpTable)
	if(tmpTable == nil) then
		return 0		
	end
	local nSize=0
	for i,v in ipairs(tmpTable) do
		nSize=nSize+1	
	end
	return nSize
end
--查找表index   数组可用
function common.findTableIndex(tmpTable,tVal)
	if(tmpTable == nil) then
		return 0		
	end	
	for i,v in ipairs(tmpTable) do
		if v == tVal then
			return i
		end
	end
	return 0
end
-- 分隔字符串
-- 参数:待分割的字符串,分割字符
-- 返回:子串表.(含有空串)
function common.luaStringSplit(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end
--转字符串类型判断
function common.ToStringEx(value)
    if type(value)=='table' then
       return common.TableToStr(value)
    elseif type(value)=='string' then
        return "\'"..value.."\'"
    else
       return tostring(value)
    end
end
--lua表转字符串
-- function common.TableToStr(t)
--     if t == nil then return "" end
-- 	if type(t) == 'string' then return "" end
--     local retstr= "{"

--     local i = 1
--     for key,value in pairs(t) do
--         local signal = ","
--         if i==1 then
--           signal = ""
--         end

--         if key == i then
--             retstr = retstr..signal..common.ToStringEx(value)
--         else
--             if type(key)=='number' or type(key) == 'string' then
--                 retstr = retstr..signal..'['..common.ToStringEx(key).."]="..common.ToStringEx(value)
--             else
--                 if type(key)=='userdata' then
--                     retstr = retstr..signal.."*s"..common.TableToStr(getmetatable(key)).."*e".."="..common.ToStringEx(value)
--                 else
--                     retstr = retstr..signal..key.."="..common.ToStringEx(value)
--                 end
--             end
--         end

--         i = i+1
--     end

--      retstr = retstr.."}"
--      return retstr
-- end
--lua表转json字符串
function common.TableToStr(t)
	retstr = cjson.encode(t)
	return retstr
end
--json字符串转lua表
function common.StrToTable(str)
    if str == nil or type(str) ~= "string" then
        return
    end    
    return cjson.decode(str)
end
-- --字符串转表
-- function common.StrToTable(str)
--     if str == nil or type(str) ~= "string" then
--         return
--     end    
--     return load("return " .. str)()
-- end
--获取好友当前服务器线路
function common.getFriendServerLine(friendName)
	if(friendName == nil)then return 0 end
	local friendCard = 取好友名片(friendName)
	if( friendCard ~= nil)then
		return friendCard.server
	end
	return 0
end

--跟随好友换线 参数:好友名称
function common.changeLineFollowLeader(leaderName,useTool)
	if(leaderName==nil)then return end
	if(人物("名称",false) == leaderName)then	return	end
	useTool=1
	local leaderServerLine = nil
	if useTool ==nil then
		leaderServerLine = common.getFriendServerLine(leaderName)
		if(leaderServerLine==0)then
			return
		end
	else
		role=取角色信息(leaderName)
		if role~=nil then
			leaderServerLine=role.character_data.server_line
		end
	end
	local curLine=人物("几线")
	if(curLine == 0)then
		return
	end
	if leaderServerLine == nil then
		日志("获取队长线路失败..")
		return
	end
	if(leaderServerLine ~= curLine)then
		日志("队长线路:"..leaderServerLine.." 当前线路："..curLine.." 不一致，登出切换线路")
		切换登录信息("",0,leaderServerLine,0) --0默认 
		登出服务器()	
		登录游戏()	--如果有自动登录 这步不需要	
	end
end
--队伍人数 队员名称表
function common.makeTeam(teamCount,teammateList,timeout)
	if(teamCount == nil and teammateList == nil)then
		日志("队伍人数和队员列表为空，建立队伍失败！",1)
		return
	end
	if(timeout==nil)then
		timeout=100000		--100秒
	else
		if(timeout < 0)then
			timeout = 1000000
		elseif(timeout<1000)then 
			timeout = 1000 			
		end		
	end
	local waitNum=timeout/1000
	local tryNum=0
::begin::
	while tryNum<=waitNum  do		
		if(队伍("人数") >= teamCount) then	--数量不足 等待
			--日志("队伍人数达标")
			break
		end		
		等待(1000)
		tryNum=tryNum+1
	end
	if(tryNum > waitNum)then	--超时退出
		return
	end
	if(teammateList == nil)then		--不判断队友
		goto goEnd
	else							--判断是否是设置队员 
		common.kickTeam(teammateList)
		if(队伍("人数") < teamCount) then	--重新等待组队 
			goto begin
		end
	end
::goEnd::
	return	
end


--判断当前队伍队长 是否是指定名称
function common.judgeTeamLeader(leaderName)
	if(leaderName == nil)then return false end
	local teamPlayers=队伍信息()
	local count=0
	for i,teammate in ipairs(teamPlayers)do
		count=count+1
		--日志(i..teammate.name .."队长名称："..队长名称)
		if( i==1 and teammate.name ~= leaderName) then	
			--日志(i..teammate.name .."!- 队长名称："..队长名称)
			return false
		else
			break
		end
	end
	if count ==0 then
		return false
	else
		return true
	end
end


--加入队伍 
function common.joinTeam(leaderName,tryCount)
	if(tryCount == nil)then tryCount=99999 end
	local tryNum=0
	local orix,oriy=取当前坐标()
	local srcMapName=取当前地图名()
::begin::	
	加入队伍(leaderName)
	if(取队伍人数()>1)then
		if(common.judgeTeamLeader(leaderName)==true) then
			return
		else
			离开队伍()
		end		
	end
	if(是否空闲中()==false)then
		return
	end
	if(取当前地图名() ~= srcMapName )then
		return
	end
	if(tryNum>tryCount)then
		return
	end
	自动寻路(orix,oriy)
	tryNum=tryNum+1
	goto begin	
end

--剔除不在队员列表里的队员
function common.kickTeam(teammateList)
	if(teammateList==nil)then
		return
	end	
	teamPlayers = 队伍信息()
	for index,teamPlayer in ipairs(teamPlayers) do
		if(teamPlayer.is_me==0 and common.isInTable(teammateList,teamPlayer.name) ==nil)then--不在列表 踢
			人物动作("剔除队伍")	
			dlg=等待服务器返回()
			teamMsg=dlg.message
			if(teamMsg ~= nil) then
				--日志(teamMsg)
				local msgIndexBe,msgIndexEnd=string.find(teamMsg,"你要把谁踢出队伍？\n")
				if(msgIndexEnd ~= nil)then
					teamMsg=string.sub(teamMsg,msgIndexEnd)
					--日志(teamMsg)
					kickIndex=-1
					teamNameList = common.luaStringSplit(teamMsg,"\n")
					for i,tName in ipairs(teamNameList) do
						--日志("split"..tName)
						if(string.find(tName,"|") ~= nil)then
						--	日志("|"..tName..teamPlayer.name)
							kickIndex=kickIndex+1
							if(string.find(tName,teamPlayer.name) ~= nil)then
								对话选择(0,kickIndex)
							--	日志("剔除队伍"..tName..kickIndex)
								break
							end
						end
					end				
				end
			end
		end
	end
end
--查找周围迷宫，需要判断nil 
function common.findAroundMaze()
	local units = 取周围信息()
	if( units ~= nil) then		
		for index,u in ipairs(units) do			
			if ((u.flags & 4096)~=0 and u.model_id > 0) then	
				return u			
			end
		end 
	end	
	return nil
end
--查找周围迷宫，有名字则自动寻路进入
function common.findAroundMazeEx(mazeName,modelid)
	if(mazeName == nil) then
		return false
	end		
	local units = 取周围信息()
	if( units ~= nil) then		
		for index,u in ipairs(units) do			
			if ((u.flags & 4096)~= 0 and u.model_id > 0) then	
				if(modelid==nil or (modelid~=nil and u.model_id == modelid))then
					自动寻路(u.x,u.y)
					等待空闲()
					if(取当前地图名() == mazeName)then
						return true
					else--出去
						local curx,cury = 取当前坐标()
						local tx,ty=取周围空地(curx,cury,1)--取当前坐标指定距离范围内 空地
						自动寻路(tx,ty)
						自动寻路(curx,cury)		
						等待空闲()
					end
				end
			end
		end 
	end	
	return false
end
--去里堡 空参:34,89 
--"c" 里堡打卡点
--"f1"里堡1层
--"f2"里堡2层
--"f3"谒见之间
--"s"召唤之间
--"l"图书室
function common.toCastle(warpPos)
::dengru::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then			
		自动寻路(140,105)				
		转向(1)
		等待服务器返回()
		对话选择(4,0)
		等待到指定地图("里谢里雅堡")
		goto checkPos
	elseif (当前地图名=="里谢里雅堡" )then	
		goto checkPos	
	elseif (当前地图名=="法兰城" )then		
		common.gotoFaLanCity("s1")
		自动寻路(153,100,"里谢里雅堡")
		goto checkPos	
	elseif (当前地图名=="召唤之间" )then	--登出 bank
		自动寻路( 3, 7)	
		等待到指定地图("里谢里雅堡")		
		goto checkPos
	end	
	回城()
	等待(2000)
	goto dengru
::checkPos::
	if(warpPos == nil) then
		自动寻路(27,82)	--艾岛上来传送点
		goto goEnd
	end
	if(warpPos == "c") then	--clock打卡处
		自动寻路(58, 83)	--
	elseif(warpPos == "召唤之间")then--召唤之间
		自动寻路(47,85,"召唤之间")
	elseif(warpPos == "回廊")then--回廊
		自动寻路(47,85,"召唤之间")		
		自动寻路(27,8,"回廊")	
	elseif(warpPos == "灵堂")then--灵堂
		自动寻路(47,85,"召唤之间")		
		自动寻路(27,8,"回廊")		
		自动寻路(23,19,"灵堂")
	elseif(warpPos == "f1")then--里堡1层
		自动寻路(41,50,"里谢里雅堡 1楼")			
	elseif(warpPos == "f2")then--里堡1层
		自动寻路(41,50,"里谢里雅堡 1楼")	
		自动寻路(74,19,"里谢里雅堡 2楼")
	elseif(warpPos == "f3")then--谒见之间
		自动寻路(41,50,"里谢里雅堡 1楼")	
		自动寻路(74,19,"里谢里雅堡 2楼")	
		自动寻路(49,22,"谒见之间")	
	elseif(warpPos == "l")then--图书室
		自动寻路(41,50,"里谢里雅堡 1楼")	
		自动寻路(74,19,"里谢里雅堡 2楼")	
		自动寻路(0, 74,"图书室")
	end
::goEnd::
	return
end

function common.isNeedSupply()
	local needSupply = false
	if(人物("血") < 人物("最大血") or 人物("魔") < 人物("最大魔")) then
		needSupply=true
	end
	if(宠物("血") < 宠物("最大血") or 宠物("魔") < 宠物("最大魔")) then
		needSupply=true
	end
	return needSupply
end
--城堡回补
function common.supplyCastle()
	local needSupply = common.isNeedSupply()	
	if(needSupply == false)then
		return
	end
::begin::	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then			
		自动寻路(140,105)				
		转向(1)
		等待服务器返回()
		对话选择(4,0)
		等待到指定地图("里谢里雅堡")
		goto liBao
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao		
	elseif (当前地图名=="召唤之间" )then	--登出 bank
		自动寻路( 3, 7)	
		等待到指定地图("里谢里雅堡")	
		goto liBao
	elseif (当前地图名=="法兰城" )then	--登出 bank
		common.toCastle()
		等待到指定地图("里谢里雅堡")	
		goto liBao
	end	
	回城()
	等待(2000)
	goto begin
::liBao::		
	自动寻路(34,89)
	回复(1)		
	goto goEnd
::goEnd::
	return
end

function common.sellPileDir(dir,saleItem,count,maxCount)
	if(saleItem == nil)then return false end
	if(count == nil)then count=20 end
	if(maxCount == nil)then maxCount=40 end
	local loopCount=0
	while loopCount<2 do
		apiSaleItems={}
		bagItems = 物品信息()
		for i,v in pairs(bagItems) do
			if(v.pos > 7 and v.name == saleItem and v.count>=count)then
				apiSaleItem={id=v.itemid,pos=v.pos,count=v.count/count}
				table.insert(apiSaleItems,apiSaleItem)					
			end		
		end
		转向(dir)
		等待服务器返回()		
		对话选择(-1,0)	--这边没有类型判断 直接-1了
		等待服务器返回()
		SellNPCStore(apiSaleItems)
		叠(saleItem,maxCount)
		等待(3000)
		loopCount=loopCount+1
	end
end
function common.sellPilePos(x,y,saleItem,count,maxCount)
	if(saleItem == nil)then return false end
	if(count == nil)then count=20 end
	if(maxCount == nil)then maxCount=40 end
	local loopCount=0
	while loopCount<2 do
		saleItems={}
		bagItems = 物品信息()
		for i,v in pairs(bagItems) do
			if(v.pos > 7 and v.name == saleItem and v.count>=count)then
				saleItem={id=v.itemid,pos=v.pos,count=v.count/count}
				table.insert(saleItems,saleItem)					
			end		
		end
		转向坐标(x,y)
		等待服务器返回()		
		对话选择(-1,0)	--这边没有类型判断 直接-1了
		等待服务器返回()
		SellNPCStore(saleItems)
		叠(saleItem,maxCount)
		等待(3000)
		loopCount=loopCount+1
	end
end

--城堡卖采集叠加物品 count是卖物品最小数量 比如采集20个起卖
function common.sellCastlePile(saleItem,count,maxCount)	
	if(saleItem == nil)then return false end
	if(count == nil)then count=20 end
	if(maxCount == nil)then maxCount=40 end
	local needSale=false	
	if(取物品叠加数量(saleItem) >= count) then
		needSale = true		
	end	
	if(needSale == false)then return end
::begin::	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then			
		自动寻路(140,105)				
		转向(1)
		等待服务器返回()
		对话选择(4,0)		
		goto liBao
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao	
	elseif (当前地图名=="工房" )then	
		goto gongFang
	elseif (当前地图名=="召唤之间" )then	--登出 bank
		自动寻路( 3, 7)	
		等待到指定地图("里谢里雅堡")	
		goto liBao
	end	
	回城()
	等待(2000)
	goto begin
::liBao::		
	if(取当前地图名() ~= "里谢里雅堡")then
		等待(2000)
		goto begin
	end
	自动寻路(31,77)		
	common.sellPileDir(6,saleItem,count,maxCount)	
	goto goEnd
::gongFang::	
	if(是否目标附近(21,23,1)==true) then
		common.sellPilePos(21,23,saleItem,count,maxCount)	
	end
	goto goEnd
::goEnd::
	return
end

--法兰武器商人卖制造物品 1个起卖
function common.sellFaLanPile(saleItem)
	common.gotoFaLanCity()
	--自动寻路(40, 98,"法兰城")	
	自动寻路(150, 123)
	卖(0,saleItem)		
end

--城堡卖魔石 卡片等
function common.sellCastle(saleItems)
	local saleList=
	{
		"魔石","锥形水晶","卡片？","锹型虫的卡片","水晶怪的卡片","哥布林的卡片","红帽哥布林的卡片","迷你蝙蝠的卡片","绿色口臭鬼的卡片","锥形水晶"
	}
	--不判断是否有重复名称了  这里直接合并一个表
	if(saleItems ~= nil)then
		if(type(saleItems) == "string")then
			table.insert(saleList,saleItems)
		elseif(type(saleItems) == "table")then		
			for i,item in ipairs(saleItems) do
				table.insert(saleList, item)
			end
		end		
	end
	local needSale=false
	for i,item in ipairs(saleList)do
		if(取物品数量(item) > 0) then
			needSale = true
			break
		end
	end
	if(needSale == false)then return end
::begin::	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then			
		自动寻路(140,105)				
		转向(1)
		等待服务器返回()
		对话选择(4,0)		
		goto liBao
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao	
	elseif (当前地图名=="工房" )then	
		goto gongFang
	elseif (当前地图名=="召唤之间" )then	--登出 bank
		自动寻路( 3, 7)	
		等待到指定地图("里谢里雅堡")	
		goto liBao
	end	
	回城()
	等待(2000)
	goto begin
::liBao::		
	if(取当前地图名() ~= "里谢里雅堡")then
		等待(2000)
		goto begin
	end
	自动寻路(31,77)		
	for i,item in ipairs(saleList)do
		if(取物品数量(item) > 0) then
			卖(6,item)
		end
	end    
	for i,item in ipairs(saleList)do
		if(取物品数量(item) > 0) then
			卖(6,item)
		end
	end 
	goto goEnd
::gongFang::
	if(是否目标附近(21,23,1)==true) then
		for i,item in ipairs(saleList)do
			if(取物品数量(item) > 0) then
				卖(21,23,item)
			end
		end    
		for i,item in ipairs(saleList)do
			if(取物品数量(item) > 0) then
				卖(21,23,item)
			end
		end  
	end
	goto goEnd
::goEnd::
	return
end

--本地买水晶,要求目标地 不登出 
--法兰城 艾夏岛 矮人 后面扩 阿港 哥拉尔 坎村等
function common.localBuyCrystal(crystalName,buyCount)
	local dlg = nil
	local buyData = nil
	local itemList = nil
	local dstItem = nil
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	local mapIndex = 取当前地图编号()
	if (当前地图名=="艾尔莎岛" )then	
		goto aiDao
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao
	elseif (当前地图名=="法兰城" )then	
		goto faLan
	elseif (当前地图名=="圣骑士营地" )then	
		goto yingdi
	elseif (当前地图名=="商店" and  mapIndex == 44699)then	
		goto yingdiShangDian
	else
		return false
	end	
::aiDao::
	自动寻路(157,94)	
	转向坐标(158,93,"艾夏岛")	
	自动寻路(150,125)	
	等待到指定地图("克罗利的店", 20,23)			
	自动寻路(39,23)
	自动寻路(40,23)	
	转向(2)
	goto buy
::liBao::
	自动寻路(17,53,"法兰城")
	goto faLan
::yingdi::
	自动寻路(92,118,"商店")
::yingdiShangDian::	
	自动寻路(14,26)
	转向(2)	
	goto buy

::faLan::
	自动寻路(94,78,"达美姊妹的店")	
	自动寻路(17,18)
	等待(1000)
	转向(2)	
	goto buy
::buy::	
	等待服务器返回()
	return common.buyDstItem(crystalName,buyCount)	
end
--商店购买指定物品
function common.buyDstItem(itemName,buyCount)
	if(itemName == nil)then 
		日志("购买物品名为空，返回")
		return 
	end
	if(buyCount==nil) then buyCount=1 end
	对话选择(0,0) --第二个参数0 0买 1卖 2不用了
	local dlg = 等待服务器返回()
	if(dlg == nil)then
		return false
	end
	local buyData = 解析购买列表(dlg.message)
	local itemList = buyData.items
	local dstItem = nil
	for i,item in ipairs(itemList)do
		if( item.name == itemName) then
			dstItem={index=i-1,count=buyCount}			
		end
	end
	if (dstItem ~= nil)then
		买(dstItem.index,dstItem.count)
		等待(1000)
		对话选择(-1,0)
		return true
	else
		日志("购买道具"..itemName.."失败！")
		return false
	end
	return false
end
--买水晶 会登出
function common.buyCrystal(crystalName,buyCount)
	喊话("买水晶")
	if(buyCount==nil) then buyCount=1 end
	if(crystalName == nil)then  crystalName = "水火的水晶（5：5）" end
	if(取包裹空格() < 1) then
		回城()
		common.sellCastle()		
	end
	if(取包裹空格() < 1) then
		日志("背包没有空格，买水晶中断！")
		回城()	
		return
	end
	if(取包裹空格() < buyCount) then
		日志("背包空格数量不够，买水晶中断！")
		回城()	
		return
	end
	common.gotoFaLanCity("w1")
	自动寻路(94,78,"达美姊妹的店")	
	自动寻路(17,18)
	等待(1000)
	转向(2)
	等待服务器返回()	
	return common.buyDstItem(crystalName,buyCount)	
end
--检查水晶
function common.checkCrystal(crystalName,equipsProtectValue)
	if(equipsProtectValue==nil)then equipsProtectValue =100 end
	if(crystalName == nil)then  crystalName = "水火的水晶（5：5）" end
	local itemList = 物品信息()
	local crystal = nil
	for i,item in ipairs(itemList)do
		if(item.pos == 7)then
			crystal = item
			break
		end
	end
	--当前水晶不需要更换
	--喊话(crystal.name.."耐久"..crystal.durability.."设置值"..equipsProtectValue)
	if(crystal~=nil and crystal.name == crystalName and crystal.durability > equipsProtectValue) then
		return
	end
	crystal=nil
	--需要更换 检查身上是否有备用水晶
	for i,item in ipairs(itemList)do
		if(item.pos > 7 and item.name == crystalName and item.durability > equipsProtectValue)then
			crystal = item
			break
		end
	end

	if(crystal~=nil ) then
		交换物品(crystal.pos,7,-1)
		return
	end
	--买水晶
	common.buyCrystal(crystalName)
	扔(7)--扔旧的
	等待(1000)	--等待刷新
	使用物品(crystalName)
end
--检查平民装备
function common.checkEquipDurable(equipPos,equipName,equipProtectValue)
	if(equipProtectValue==nil)then equipProtectValue =20 end
	if(equipName == nil)then  return end
	if(equipPos == nil)then  return end
	local itemList = 物品信息()
	local tgtEquip = nil
	for i,item in ipairs(itemList)do
		if(item.pos == equipPos)then
			tgtEquip = item
			break
		end
	end
	--当前水晶不需要更换
	--喊话(crystal.name.."耐久"..crystal.durability.."设置值"..equipsProtectValue)
	if(tgtEquip~=nil and tgtEquip.name == equipName and tgtEquip.durability > equipProtectValue) then
		return
	end
	tgtEquip=nil
	--需要更换 检查身上是否有备用水晶
	for i,item in ipairs(itemList)do
		if(item.pos > 7 and item.name == equipName and item.durability > equipProtectValue)then
			tgtEquip = item
			break
		end
	end

	if(tgtEquip~=nil ) then
		交换物品(tgtEquip.pos,equipPos,-1)
		return
	end
	--买水晶
	common.buyPopulaceEquip(equipName,1)
	扔(equipPos)--扔旧的
	等待(1000)	--等待刷新
	使用物品(equipName)
end

--购买平民装备
function common.buyPopulaceEquip(equipName,buyCount)
	common.gotoFaLanCity()
	local sWeapon="平民剑|平民斧|平民枪|平民弓|平民回力镖|平民小刀|平民杖"
	if(string.find(sWeapon,equipName) ~= nil)then
		--自动寻路(40, 98,"法兰城")	
		自动寻路(150, 123)
		转向(0)
		等待服务器返回()
		common.buyDstItem(equipName,buyCount)	
	else
		自动寻路(156, 123)
		转向(0)
		等待服务器返回()
		common.buyDstItem(equipName,buyCount)	
	end
end
--去里堡打卡处并打卡
function common.toCastleBeginWork()
	common.toCastle("c")	
	if(人物("卡时") == 0) then
		日志("没有卡时，无法打卡")
		return
	end
	对话选是(58,84)
end

--去招魂
function common.recallSoul()
	local tryCount=0
::begin::
	if 人物("灵魂") > 0  then
		日志("人物掉魂：登出招魂")
		common.outCastle("n")--出城堡北门	
		自动寻路(154, 29,"大圣堂的入口")				
		自动寻路(14, 7,"礼拜堂")		
		自动寻路(12, 19)	
		对话选是(0)
		if tryCount > 3 then return end
		
		tryCount = tryCount+1
		if 人物("灵魂") > 0  then			
			日志("没钱招魂了，去看看银行有没钱")
			common.checkGold(人物("灵魂")*30000,1000001,200000)
			goto begin
		end
	end
end

--城堡找医生治疗人物
function common.healPlayer(doctorName)
	if 人物("健康") == 0 then
		return
	end
	日志("人物受伤：登出治伤")
	local tryNum=0
	local filterName={"星落护士","谢谢惠顾☆","司徒启绒","毋然溟","喻天磊","段干澎乔"}
	if(doctorName ~= nil and type(doctorName) == "string")then
		table.insert(filterName,doctorName)
	elseif(doctorName ~= nil and type(doctorName) == "table")then		
		for i,item in ipairs(doctorName) do
			table.insert(filterName, item)
		end		
	end
	common.toCastle()
::liBao::
	自动寻路(34, 89)
	等待(2000)
	回复(1)			
::reTry::	
	自动寻路(29, 85)
	if 人物("健康") == 0 then
		离开队伍()
		return
	end	
	local units = 取周围信息()
	if units ~= nil then
		local doctor=nil		
		for index,u in ipairs(units) do			
			if ((u.flags & 256)~=0 and common.isInTable(filterName,u.unit_name)~=nil) then
				doctor = u
				break
			end
		end 			
		if doctor ==nil then--找周围医生
			for index,u in ipairs(units) do		
				-- if ((u.flags & 256)~=0) then
				   -- --日志(u.unit_name.."icon:"..u.icon.."flags"..(u.flags & 256))
				-- end
				if ((u.flags & 256)~=0 and (string.find(u.title_name,"医")~=nil )) then
					doctor = u
					break				
				end
			end 	
		end
		if doctor ~=nil then
			移动到目标附近(doctor.x,doctor.y,1)	--最后一个距离
			local oldHealth=人物("健康")
			local healTryNum=0
			加入队伍(doctor.unit_name)
			if(取队伍人数() > 1)then
				while(healTryNum < 4) do
					if 人物("健康") == 0 then
						离开队伍()
						return
					end
					等待(8000)	--等待8秒 还受伤 重新加队
--					if( oldHealth == 人物("健康")) then --医生水平太差没治好 或者是医德太差 站着不治疗
--						break
--					end
					healTryNum = healTryNum+1
				end
				if 人物("健康") > 0 then
					-- if(common.isInTable(filterName,u.unit_name)==nil)then
						-- table.insert(filterName,doctor.unit_name)
					-- end
					离开队伍()	--重新找医生
					for i,v in ipairs(filterName) do
						if(v == doctor.unit_name)then
							table.remove(filterName,i)
						end
					end
				end	
			end
		end
	end
	if tryNum >= 10 then
		return
	end
	tryNum = tryNum+1
	goto reTry
end

--附近查找医生治伤 没有返回false 成功返回true 不登出  27秒
function common.localHealPlayer(doctorName)
	if 人物("健康") == 0 then
		return true
	end
	日志("人物受伤：附近查找医生治伤")
	local tryNum=0
	local filterName={"星落护士","谢谢惠顾☆","司徒启绒","毋然溟","喻天磊","段干澎乔"}
	if(doctorName ~= nil and type(doctorName) == "string")then
		table.insert(filterName,doctorName)
	elseif(doctorName ~= nil and type(doctorName) == "table")then		
		for i,item in ipairs(doctorName) do
			table.insert(filterName, item)
		end		
	end
::reTry::	
	if 人物("健康") == 0 then
		离开队伍()
		return true
	end	
	local units = 取周围信息()
	if units ~= nil then
		local doctor=nil		
		for index,u in ipairs(units) do			
			if ((u.flags & 256)~=0 and common.isInTable(filterName,u.unit_name)~=nil) then
				doctor = u
				break
			end
		end 			
		if doctor ==nil then--找周围医生
			for index,u in ipairs(units) do		
				if ((u.flags & 256)~=0) then
				   --日志(u.unit_name.."icon:"..u.icon.."flags"..(u.flags & 256))
				end
				if ((u.flags & 256)~=0 and (string.find(u.title_name,"医")~=nil )) then--or u.icon==13 先屏蔽
					doctor = u
					break				
				end
			end 	
		end
		if doctor ~=nil then
			移动到目标附近(doctor.x,doctor.y,1)	--最后一个距离
			local oldHealth=人物("健康")
			local healTryNum=0
			加入队伍(doctor.unit_name)
			if(取队伍人数() > 1)then
				while(healTryNum < 4) do
					if 人物("健康") == 0 then
						离开队伍()
						return true
					end
					等待(8000)	--等待8秒 还受伤 重新加队
--					if( oldHealth == 人物("健康")) then --医生水平太差没治好 或者是医德太差 站着不治疗
--						break
--					end
					healTryNum = healTryNum+1
				end
				if 人物("健康") > 0 then
					table.insert(filterName,doctor.unit_name)
					离开队伍()	--重新找医生					
				end	
			end
		end
	end
	if tryNum >= 3 then
		return false
	end
	tryNum = tryNum+1
	等待(3000)
	goto reTry
	return false
end

--治疗宠物 先去治疗主号，否则会治疗全部
function common.healPet()
	if 宠物("健康") == 0 then
		return
	end
	--宠物受伤 登出治伤
	日志("宠物受伤：登出治伤")
	common.gotoFaLanCity("e2")
	自动寻路(221,83,"医院")
	自动寻路(12, 18)
	local tryNum=0
::zhiLiao::
	转向坐标(10,18)
	等待服务器返回()
	对话选择(-1,6)
	if 宠物("健康") == 0 then
		回城()
		return
	end
	if tryNum>=10 then
		return
	end
	tryNum = tryNum+1
	goto zhiLiao
end
--里堡和艾尔莎检查 检查受伤以及去招魂治人治宠
function common.checkHealth(doctorName)
	local health = 人物("健康")
	local petinfo = 宠物信息()
	if( 人物("健康") > 0 or 人物("灵魂") > 0 or 宠物("健康") > 0)then
		--登出 去治疗 招魂
		common.toCastle()
		common.recallSoul()	
		common.healPlayer(doctorName)
		common.healPet()
	end
end
--去哥拉尔
function common.toGle()
	local x,y=取当前坐标()		
	if (取当前地图名()=="哥拉尔镇" and x==120 )then return end			
	回城()	
	等待(3000)
end
function common.gleCheckHealth(doctorName)
	local health = 人物("健康")
	local petinfo = 宠物信息()
	if( 人物("健康") > 0 or 人物("灵魂") > 0 or 宠物("健康") > 0)then
		--登出 去治疗 招魂
		common.toGle()
		common.gleRecallSoul()	
		common.gleHealPlayer(doctorName)		
	end
end
--哥拉尔招魂
function common.gleRecallSoul()
	if( 人物("灵魂") > 0 )then
		日志("触发登出补给:人物掉魂")
		common.toGle()
		转向(0)
		等待(1000)
		自动寻路(140,214,"白之宫殿")
		自动寻路(47, 36, 43210)
		自动寻路(61, 46)
		对话选是(2)
		等待(1000)		
	end
end
function common.gleSupply()
	local needSupply = common.isNeedSupply()	
	if(needSupply == false)then
		return
	end
	if (取当前地图名()~="哥拉尔镇" )then common.toGle() end			
	自动寻路(165,91,"医院")
	自动寻路(29,26)	
	回复(30,26)	
end

--哥拉尔医院医生治疗
function common.gleHealPlayer(doctorName)
	if( 人物("健康") > 0  or 宠物("健康") > 0)then
		common.toGle()
		日志("人物受伤")
		自动寻路(165,91,"医院")
		自动寻路(29,15)
		转向(2)
		等待服务器返回()
		对话选择(-1,6)
		自动寻路(29,26)
		回复(30,26)	
	end      
end
--检查人物金币 不足去拿 
--minGold人物最少金币 少于此值去银行拿钱
--maxGold人物最多金币 大于此值去银行存钱
--bagGold人物身上取钱和存钱保留的钱数 取钱后身上有这么多钱 存钱后身上有这么多钱
--值设定时候不要给错，满足minGold < bagGold < maxGold
function common.checkGold(minGold,maxGold,bagGold)
	if(minGold==nil or maxGold ==nil or bagGold == nil)then return end
	local oldGold=人物("金币")
	if(oldGold < minGold)then
		日志("人物现有金币【"..oldGold.."】小于设定的最少值【"..minGold.."】,去银行取钱",1)
		common.gotoBankTalkNpc()
		银行("取钱",-bagGold)
		等待(1000)
		local nowGold=人物("金币")
		if(nowGold ~= oldGold)then
			日志("取钱成功，现有金币："..nowGold)
		end
	elseif(oldGold > maxGold)then
		日志("人物现有金币【"..oldGold.."】大于设定的最大值【"..maxGold.."】,去银行存钱",1)
		common.gotoBankTalkNpc()
		银行("存钱",-bagGold)
		等待(1000)
		local nowGold=人物("金币")
		if(nowGold == oldGold)then	--银行满了 存少点
			日志("银行金币满了，尝试存部分金币")
			local bankGold = 银行("金币")
			if(bagGold > 1000000)then	
				银行("存钱",10000000-bankGold)
			else
				银行("存钱",1000000-bankGold)
			end
			等待(1000)
			nowGold=人物("金币")
			if(nowGold ~= oldGold)then	
				日志("存钱成功，现有金币："..nowGold)
			end
		else
			日志("存钱成功，现有金币："..nowGold)
		end
	end
end

--获取队伍宠物平均等级
function common.GetPetAverageLevel()
	return 取队伍宠物平均等级()
end
-- 保留n位小数
function common.keepDecimalTest(num, n)
    if type(num) ~= "number" then
        return num    
    end
    n = n or 2
    if num < 0 then
        return -(math.abs(num) - math.abs(num) % 0.1 ^ n)
    else
        return num - num % 0.1 ^ n
    end
end
 --计算比率，保留两位小数
function getRatio(a, b)
	if (b == 0) then
		return 0
	else
		return common.keepDecimalTest((a / b),2)
	end
end
--人物卡时信息
function common.getPunchClockStr(a, b) 
	a = a / 1000
	local h = math.floor((a / 3600) < 10 and '0' .. math.floor(a / 3600) or math.floor(a / 3600))
	local m = math.floor((a / 60 % 60)) < 10 and '0' .. math.floor((a / 60 % 60)) or math.floor((a / 60 % 60))
	local s = math.floor((a % 60)) < 10 and '0' .. math.floor((a % 60)) or math.floor((a % 60))
	local str = h..":" ..m..":"..s
	if (b~=0) then
		str = str.." (已打卡)"
	else 
		str = str.." (未打卡)"
	end
	return str
end
--控制台基础信息打印
function common.baseInfoPrint()
	--人物信息
	local playerinfo = 人物信息()
	日志("人物信息： Lv"..playerinfo.level.."【 "..playerinfo.name.."】【 "..playerinfo.job.." 】")
	日志("生命： " .. playerinfo.hp .. "/" .. playerinfo.maxhp .. " (" .. getRatio(playerinfo.hp, playerinfo.maxhp) .. ")")
	日志("魔法： " .. playerinfo.mp .. "/" .. playerinfo.maxmp .. " (" .. getRatio(playerinfo.mp, playerinfo.maxmp) .. ")")
	日志("健康： " .. playerinfo.health .. "  掉魂： " .. playerinfo.souls)
	日志("金钱： " .. playerinfo.gold .. "  卡时： " .. common.getPunchClockStr(playerinfo.punchclock, playerinfo.usingpunchclock))
	--装备信息
	日志("装备信息： ")
	local items = 装备信息()
	for index,item in ipairs(items) do			
		local nCur,nMax = 装备耐久(item.attr)	
		日志("穿戴位置"..item.pos .. "： Lv" .. item.level .. " " .. item.name .. "  (" .. nCur .. "/" .. nMax .. ")")
	end 
	
    --出战宠物
	local petinfo = 宠物信息(playerinfo.petid)
	日志("出战宠物： Lv" .. petinfo.level .. " " .. petinfo.realname .. "  (" .. petinfo.name .. ")")
	日志("生命： " .. petinfo.hp .. "/" .. petinfo.maxhp .. " (" .. getRatio(petinfo.hp, petinfo.maxhp) .. ")")
	日志("魔法： " .. petinfo.mp .. "/" .. petinfo.maxmp .. " (" .. getRatio(petinfo.mp, petinfo.maxmp) .. ")")
	日志("健康： " .. petinfo.health)
	--宠物信息
	日志("宠物信息： ")
	common.petInfoPrint()

end
--统计时间
function common.statisticsTime(beginTime,oldGold)	
	local nowTime = os.time() 
	local time = math.floor((nowTime - beginTime)/60)--已持续练级时间
	if(time == 0)then
		time=1
	end		
	local goldContent =""
	if(oldGold~=nil) then
		local nowGold = 人物("金币")
		local getGold = nowGold - oldGold
		local avgGold = math.floor(60 * getGold/time)
		goldContent = "总消耗【"..getGold.."】金币，平均每小时消耗【"..avgGold.."】金币"
	end
	local content ="脚本已持续【"..time.."】分钟，"..goldContent	
	日志(content)--字符串太长 崩溃
	return content

end

--练级统计信息打印
function common.statistics(beginTime,oldXp,oldPetXp,oldGold)
	if(oldXp == nil) then
		return ""
	end
	local playerinfo = 人物信息()
	local nowTime = os.time() 
	local time = math.floor((nowTime - beginTime)/60)--已持续练级时间
	if(time == 0)then
		time=1
	end	
	local nowLevel = playerinfo.level
	local nowXp = playerinfo.xp
	local nowMaxXp = playerinfo.maxxp
	if(nowLevel==nil or nowXp == nil or nowMaxXp==nil)then
		日志("获取人物信息错误，统计失败")
		return
	end
	local getXp = math.floor((nowXp - oldXp)/10000)
	local avgXp = math.floor(60 * getXp/time)
	local nextXp = 0
	if(nowLevel~=160)then	
		nextXp=math.floor((nowMaxXp-nowXp)/10000)
	end
	local levelUpTime=0
	if(avgXp > 0)then
		levelUpTime = math.floor(60 * nextXp/avgXp)
	end	

	local goldContent =""
	if(oldGold~=nil) then
		local nowGold = 人物("金币")
		local getGold = nowGold - oldGold
		local avgGold = math.floor(60 * getGold/time)
		goldContent = "，总消耗【"..getGold.."】金币，平均每小时消耗【"..avgGold.."】金币"
	end
	local content ="已持续练级【"..time.."】分钟，人物共获得【"..getXp.."万】经验，平均每小时【"..avgXp.."万】经验，当前等级【"..nowLevel.."】，距离下一级还差【"..nextXp.."万】经验，大约需要【"..levelUpTime.."】分钟 "..goldContent
	if(oldPetXp==nil)then
		if(nowLevel==160)then
			return ""--满级不打印信息
		else
			日志(content)
			return content
		end	
	end
	local nowPetLevel = 宠物("等级")
	local nowPetXp = 宠物("经验")
	local nowMaxPetXp = 宠物("最大经验")
	local getPetXp = math.floor((nowPetXp - oldPetXp)/10000)
	local avgPetXp = math.floor(60 * getPetXp/time)
	local nextPetXp = 0
	if(nowPetLevel~=160)then	
		nextPetXp=math.floor((nowMaxPetXp-nowPetXp)/10000)
	end	
	local petLevelUpTime =0
	if(avgPetXp > 0)then
		petLevelUpTime = math.floor(60 * nextPetXp/avgPetXp)
	end
	local petcontent ="，宠物共获得【"..getPetXp.."万】经验，平均每小时【"..avgPetXp.."万】经验，当前等级【"..nowPetLevel.."】，距离下一级还差【"..nextPetXp.."万】经验，大约需要【"..petLevelUpTime.."】分钟"
	-- if(nowPetLevel==160)then
		-- return ""--满级不打印信息
	-- else
		-- 喊话(content,2,3,5)
		-- return content
	-- end	
	local allContent=content..petcontent
	日志(allContent)--字符串太长 崩溃
	return allContent
end
--打印宠物信息
function common.petInfoPrint()
	local pets=全部宠物信息()
	for index,pet in ipairs(pets) do			
		日志("宠物位置"..pet.index .. "： LV" .. pet.level .. " " .. pet.realname .. "  (" .. pet.name ..")")
	end 
end
--传送之间
function common.toTeleRoom(villageName)
	warpList={
		["亚留特村"]={{x=43,y=23},{x=43, y=22},{x=44,y=22},{script="./脚本/直通车/★开传送-亚留特村.lua"}},
		["伊尔村"]={{x=43,y=33},{x=43, y=32},{x=44,y=32},{script="./脚本/直通车/★开传送-伊尔村.lua"}},
		["圣拉鲁卡村"]={{x=43,y=44},{x=43, y=43},{x=44,y=43},{script="./脚本/直通车/★开传送-圣拉鲁卡村.lua"}},
		["维诺亚村"]={{x=9,y=22},{x=9, y=23},{x=8,y=22},{script="./脚本/直通车/★开传送-维诺亚村.lua"}},
		["奇利村"]={{x=9,y=33},{x=8, y=33},{x=8,y=32},{script="./脚本/直通车/★开传送-奇利村.lua"}},
		["加纳村"]={{x=9,y=44},{x=8, y=44},{x=8,y=43},{script="./脚本/直通车/★开传送-加纳村.lua"}},
		["杰诺瓦镇"]={{x=15,y=4},{x=15, y=5},{x=16,y=4},{script="./脚本/直通车/★开传送-杰诺瓦镇.lua"}},
		["阿巴尼斯村"]={{x=37,y=4},{x=37, y=5},{x=38,y=4},{script="./脚本/直通车/★开传送-阿巴尼斯村.lua"}},
		["蒂娜村"]={{x=25,y=4},{x=25, y=5},{x=26,y=4},{script="./脚本/直通车/★开传送-蒂娜村.lua"}},
		}
	local data = warpList[villageName]
	if(data~=nil)then
		common.toTeleRoomTemplate(data)
	elseif(villageName == "魔法大学")then
		data = warpList["阿巴尼斯村"]
		common.toTeleRoomTemplate(data)
		自动寻路(5, 4, 4313)
		自动寻路(6, 13, 4312)
		自动寻路(6, 13, "阿巴尼斯村")
		自动寻路(37, 71,"莎莲娜")
		自动寻路(118, 100,"魔法大学")
	elseif(villageName == "咒术师的秘密住处")then		
		common.toCastle("f1")
		自动寻路(45,20,"启程之间")	
		自动寻路(15, 4)	
		离开队伍()
		转向(2)
		dlg=等待服务器返回()
		if(dlg.message~=nil and (string.find(dlg.message,"此传送点的资格")~=nil or string.find(dlg.message,"不能使用这个传送石")~=nil))then			
			执行脚本("./脚本/直通车/★开传送-杰诺瓦镇.lua")			
			goto jiecun
		end	
		转向(2, "")
		等待服务器返回()
		对话选择("4", 0)
		goto jiecun
	::jiecun::
--		common.toTeleRoom("杰诺瓦镇")
		等待到指定地图("杰诺瓦镇的传送点")
		自动寻路(14, 6,"村长的家")
		自动寻路(1, 9,"杰诺瓦镇")
		自动寻路(24, 40,"莎莲娜")
		自动寻路(196, 443,"莎莲娜海底洞窟 地下1楼")	
		自动寻路(14, 41,"莎莲娜海底洞窟 地下2楼")
		自动寻路(32, 21)
		转向(5, "")
		等待服务器返回()	
		喊话("咒术",0,0,0)	
		等待服务器返回()
		对话选择("1", "", "")
		等待到指定地图("莎莲娜海底洞窟 地下2楼",31,22)	
		自动寻路(38, 37,"咒术师的秘密住处")		
	else
		日志("未知地图名称！",1)
	end
end
function common.toTeleRoomTemplate(warpData)
	local tryCount=0
::Begin::
	x,y=取当前坐标()	
	当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		自动寻路(140,105)	
		转向(1)
		等待服务器返回()	
		对话选择(4,0)	
		goto goWarp
	elseif (当前地图名=="里谢里雅堡" )then	
		goto goWarp		
	elseif (当前地图名=="里谢里雅堡 1楼" )then	
		goto map1520	
	elseif (当前地图名=="启程之间" )then	
		goto map1522		
	end	
	common.toCastle()
::goWarp::		
	if(取当前地图名() ~= "里谢里雅堡")then
		等待(2000)
		goto Begin
	end		
	自动寻路(41,50,"里谢里雅堡 1楼")
::map1520::
	自动寻路(45,20,"启程之间")	
::map1522::
	自动寻路(25, 27) 	
	if (是否队长()) then
		自动寻路(warpData[1].x,warpData[1].y)
		自动寻路(warpData[2].x,warpData[2].y)
		自动寻路(warpData[1].x,warpData[1].y)
		自动寻路(warpData[2].x,warpData[2].y)
		自动寻路(warpData[1].x,warpData[1].y)	
	else
		自动寻路(warpData[1].x,warpData[1].y)	
	end
	
::warpTalk::
	转向坐标(warpData[3].x,warpData[3].y)
	dlg=等待服务器返回()
	if(dlg.message~=nil and (string.find(dlg.message,"此传送点的资格")~=nil or string.find(dlg.message,"不能使用这个传送石")~=nil))then		
		执行脚本(warpData[4].script)		
		return true
	elseif(dlg.message==nil)then
		tryCount=tryCount+1
		if(tryCount >= 5)then	--尝试5次，还卡对话框退出
			return false
		end
		goto warpTalk
	end		
	对话选是(warpData[3].x,warpData[3].y)	
	return true
end


--查找技能信息
function common.findSkillData(skillName)
	local playerInfo = 人物信息()
	local skillInfo = playerInfo.skill
	for index,skill in ipairs(skillInfo) do			
		if(skill.name == skillName)then
			return skill
		end		
	end 
	return nil
end
--表里查找是否有指定名称
function common.isInTable(data,name)
	for index,tblName in ipairs(data) do			
		if(tblName == name)then
			return index
		end		
	end 
	return nil
end
--法兰传送一次
function common.faLanStoreWarpOne()
	local x,y=取当前坐标()	
	local 当前地图名 = 取当前地图名()		
	if (x==72 and y==123 )then		-- 西2登录点
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
	elseif (当前地图名=="市场三楼 - 修理专区" and x==46 and y==16 )then	-- t3
		goto  t3
	elseif (当前地图名=="市场一楼 - 宠物交易区" and x==46 and y==16 )then	-- t1
		goto  t1
	end
	goto goEnd
::w2::				-- 西2登录点
	转向(2)			-- 转向东	
	等待到指定地图("法兰城",233,78)		
	goto goEnd

::e2::				-- 东2登录点	
	转向(0)			-- 转向北	
	等待到指定地图("市场一楼 - 宠物交易区", 46, 16)			
	goto goEnd

::s2::				-- 南2登录点	
	转向(2)	
	等待到指定地图("法兰城",72,123)		
	goto goEnd

::w1::				-- 西1登录点
	转向(0)			-- 转向北	
	等待到指定地图("法兰城", 242, 100)		
	goto goEnd

::e1::				-- 东1登录点
	转向(2)			-- 转向北	
	等待到指定地图("市场三楼 - 修理专区", 46, 16)		
	goto goEnd

::s1::				-- 南1登录点		
	转向(0)			-- 转向北	
	等待到指定地图("法兰城", 63, 79)		
	goto goEnd
::t1::
	转向(0)			-- 转向北	
	等待到指定地图("法兰城", 162, 130)			
	goto goEnd
::t3::
	转向(0)			-- 转向北	
	等待到指定地图("法兰城", 141, 148)			
	goto goEnd
::goEnd::
	return
end
--计算距离
function common.GetDistance(sx,sy,tx,ty)
	if(sx == tx and sy == ty)then
		return 0
	end
	--日志((sx-tx)..","..(sy-ty))
	local x=math.abs(sx-tx)
	local y=math.abs(sy-ty)
	return math.sqrt(x*x + y*y)	
end
--前往法兰城 6个点
--"s2","w2","e2","t1"	t1市场一楼 t3市场三楼
--"s1","w1","e1","t3"
function common.gotoFaLanCity(storeName)
::dengru::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then			
		自动寻路(140,105)				
		转向(1)
		等待服务器返回()
		对话选择(4,0)		
		goto liBao
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao
	elseif (当前地图名=="法兰城" )then	
		goto faLan
	elseif (当前地图名=="召唤之间" )then	--登出 bank
		自动寻路( 3, 7)	
		等待到指定地图("里谢里雅堡")	
		goto liBao
	end	
	回城()
	goto dengru
::liBao::		
	if(取当前地图名() ~= "里谢里雅堡")then
		等待(2000)
		goto dengru
	end
	自动寻路(41,98,"法兰城")	
	自动寻路(153, 130)		
	if(storeName==nil or storeName=="s")then
		return
	end
    goto faLan
::faLan::
	local warpList={
		["w2"]={x=72,y=123,name="法兰城"},		--西2登录点
		["w1"]={x=63,y=79,name="法兰城"},		--西1登录点
		["e1"]={x=242,y=100,name="法兰城"},		--东1登录点
		["e2"]={x=233,y=78,name="法兰城"},		--东2登录点
		["s1"]={x=141,y=148,name="法兰城"},		--南1登录点
		["s2"]={x=162,y=130,name="法兰城"},		--南2登录点
		["t3"]={x=46,y=16,name="市场三楼 - 修理专区"},		--市场三楼
		["t1"]={x=46,y=16,name="市场一楼 - 宠物交易区"},		--市场1楼
		["whospital"]={x=82,y=83,name="医院"},		--西医院		
		
		}
	local warp1={"s2","w2","e2","t1"}
	local warp2={"s1","w1","e1","t3"}
	--西二 东二 南二 市场一楼宠物交易区
	local tmpWarpList
	local data = warpList[storeName]
	isFind = common.isInTable(warp1,storeName)	
	if(isFind ~= nil)then--找最近传送点
		tmpWarpList= warp1	
	else
		isFind = common.isInTable(warp2,storeName)	
		if(isFind ~= nil)then--找最近传送点
			tmpWarpList= warp2		
		end
	end	
	local x,y=取当前坐标()
	if(isFind ~= nil)then--找最近传送点
		local nearPos
		local minDistance=99999
		for index,warpName in ipairs(tmpWarpList) do	
			warpData = warpList[warpName]
			local tDis = common.GetDistance(x,y,warpData.x,warpData.y)
			if(minDistance > tDis) then
				nearPos = warpData
				minDistance=tDis
			end
		end 
		自动寻路(nearPos.x,nearPos.y)
		tryNum=0
		while 1 do
			 x,y=取当前坐标()
			if( 取当前地图名() == data.name and x==data.x and y==data.y)then
				return
			else
				common.faLanStoreWarpOne()
			end	
			if(tryNum > 10)then
				日志("前往法兰城坐标错误！")
				return
			end
			tryNum = tryNum+1			
		end		
	end
	
end

--学人物技能
function common.learnPlayerSkill(x,y)
	转向坐标(x,y)
	等待服务器返回()
	对话选择(-1,0)
	等待服务器返回()
	对话选择(0,0)
	等待服务器返回()
	对话选择(1,0)
end
function common.forgetPlayerSkill(x,y,skillName)
	if(skillName == nil)then return false end
	local skill = common.findSkillData(skillName)
	if(skill == nil)then 
		日志("没有"..skillName.."技能",1)
		return false
	end
	local playerInfo = 人物信息()
	local skillInfo = playerInfo.skill 
	table.sort(skillInfo , function(a , b)
		return a.pos < b.pos
	end)  
	local index=-1
	for i,value in ipairs(skillInfo) do  
		日志(i..value.name,1)
		if(value.name == skillName)then
			index = i
			break
		end
	end  
	if(index < 0)then
		return false
	end	
	对话选择(0,index)
	等待服务器返回()
	对话选择(4,-1)
	等待服务器返回()
	对话选择(0,0)
end


--转方向
function common.learnPlayerSkillDir(d)
	转向(d)
	等待服务器返回()
	对话选择(-1,0)
	等待服务器返回()
	对话选择(0,0)
	等待服务器返回()
	对话选择(1,0)
end

--NPC xy 坐标，学习技能名称，那只宠物，宠物技能位置
function common.learnPetSkill(x,y,skillIndex,petIndex,petSkillIndex)
	转向坐标(x,y)
	local dlg=等待服务器返回()
	if(dlg ~= nil and dlg.type==24)then
		对话选择(0,skillIndex)
	end
	dlg=等待服务器返回()
	if(dlg ~= nil and dlg.type==25)then
		对话选择(0,petIndex)
	end	
	dlg=等待服务器返回()
	if(dlg ~= nil and dlg.type==26)then
		对话选择(0,petSkillIndex)
		 return true
	end   
	return false
end
--NPC xy 坐标，学习技能名称，那只宠物，宠物技能位置
function common.learnPetSkillDir(d,skillIndex,petIndex,petSkillIndex)
	转向(d)
	local dlg=等待服务器返回()
	if(dlg ~= nil and dlg.type==24)then
		对话选择(0,skillIndex)
	end
	dlg=等待服务器返回()
	if(dlg ~= nil and dlg.type==25)then
		对话选择(0,petIndex)
	end	
	dlg=等待服务器返回()
	if(dlg ~= nil and dlg.type==26)then
		对话选择(0,petSkillIndex)
		 return true
	end   
	对话选择(-1,0)
	return false
end
--就职传教
function common.joinMissionary()
	if(人物("职业") == "传教士")then
		return
	end
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()	
	if (当前地图名=="艾尔莎岛" )then	
		goto erDao	
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao	
	end
	回城()
	等待(1000)
	goto begin
::erDao::	
	自动寻路(140,105)
	等待(500)	
	转向(1)
	等待服务器返回()
	对话选择(4,0)
	等待(500)		
	等待空闲()
	if (取当前地图名()=="艾尔莎岛" )then	
		goto begin
	end
::liBao::
	if(取当前地图名() ~= "里谢里雅堡")then
		等待(2000)
		goto begin
	end
	自动寻路(41,14,"法兰城")
	自动寻路(153,29,"大圣堂的入口")	
	自动寻路(14,7,"礼拜堂")
	自动寻路(23, 0,"大圣堂里面")
::naXin::
	自动寻路(16,10)	
	等待(1000)
	if(取物品数量("僧侣适性检查合格证") < 1 and 取当前地图名() == "大圣堂里面")then
		对话选是(4)	
	end		
	转向(1)
	等待服务器返回()
	对话选择(0,0)
	等待服务器返回()
	对话选择(32,-1)
	等待服务器返回()
	对话选择(0,0)
	等待(2000)
	if(人物("职业") == "传教士")then
		日志("就职传教成功！")
	else		
		日志("就职传教失败，请手动查看原因")				
	end
end

--自动学习技能
function common.autoLearnSkill(skillName)
	skill = common.findSkillData(skillName)
	if(skill ~= nil)then
		日志("已存在技能【"..skillName.."】")		
	end		
	if(skillName=="气功弹")then		
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(1000)				
		end
		common.gotoFaLanCity("s1")
		自动寻路(124, 161)
		转向(6)
		等待到指定地图("竞技场的入口", 15,23)	
		自动寻路(15,6)
		等待到指定地图("竞技场", 34,67)
		自动寻路(15,57)			
		common.learnPlayerSkill(15,56)			
	elseif(skillName=="圣盾")then
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(1000)				
		end	
		common.toTeleRoom("伊尔村")
		等待到指定地图("伊尔村的传送点")	
		自动寻路(12, 17,"村长的家")
		自动寻路(6, 13,"伊尔村")	
		自动寻路(32, 65,"旧金山酒吧")	
		自动寻路(22, 16)
		common.learnPlayerSkill(23, 16)		
	elseif(skillName=="乾坤一掷")then
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(1000)				
		end
		common.gotoFaLanCity("w2")
		自动寻路(102,131,"安其摩酒吧")	
		自动寻路(10,13)			
		common.learnPlayerSkill(11, 13)			
	elseif(skillName=="调教")then
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(1000)				
		end
		common.gotoFaLanCity("e1")
		自动寻路(219,136,"科特利亚酒吧")
		自动寻路(27,20,"酒吧里面")			
		自动寻路(10,6,"客房")	
		自动寻路(10,5)			
		common.learnPlayerSkill(11, 5)			
	elseif(skillName=="宠物强化")then
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(1000)				
		end
		common.outCastle("n")
		自动寻路(122, 36,"饲养师之家")
		自动寻路(13,4)				
		common.learnPlayerSkill(14, 4)			
	elseif(skillName=="补血魔法")then
		if(人物("职业") ~= "传教士")then
			日志("非传教职业！")
			return
		end
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(1000)				
		end
		if(取当前地图编号() == 1207)then goto map1207 end
		if(取当前地图编号() == 1208)then goto map1208 end
		common.outCastle("n")
		自动寻路(153,29,"大圣堂的入口")	
		自动寻路(14,7,"礼拜堂")
		自动寻路(23, 0,"大圣堂里面")
::map1207::
		自动寻路(13, 7)
		对话选是(14,6)
::map1208::
		等待到指定地图(1208)	
		自动寻路(14, 11)		
		common.learnPlayerSkill(14, 10)			
	elseif(skillName=="强力补血魔法")then
		if(人物("职业") ~= "传教士")then
			日志("非传教职业！")
			return
		end
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(1000)				
		end
		if(取当前地图编号() == 1207)then goto map1207 end
		if(取当前地图编号() == 1208)then goto map1208 end
		common.outCastle("n")
		自动寻路(153,29,"大圣堂的入口")	
		自动寻路(14,7,"礼拜堂")
		自动寻路(23, 0,"大圣堂里面")
::map1207::
		自动寻路(13, 7)
		对话选是(14,6)
::map1208::
		等待到指定地图(1208)	
		自动寻路(19, 13)		
		common.learnPlayerSkill(19, 12)			
	elseif(skillName=="石化魔法")then
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(1000)				
		end
		common.outCastle("w")
		自动寻路(120, 65)							
		common.learnPlayerSkill(120, 64)			
	elseif(skillName=="抗毒" or skillName=="抗昏睡" or skillName=="抗石化" or skillName=="抗酒醉" or skillName=="抗混乱" or skillName=="抗遗忘")then		
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 5000)then
			common.getMoneyFromBank(5000)				
		end
		if(取当前地图名() == "咒术师的秘密住处")then
			if(取当前地图编号() == 15007)then goto map15007 end
			if(取当前地图编号() == 15008)then goto map15008 end
			if(取当前地图编号() == 15010)then goto map15010 end
		end
		common.toCastle()
		common.toTeleRoom("咒术师的秘密住处")	
::map15007::
		自动寻路(10, 0,15008)
::map15008::	--进入房间
		自动寻路(1, 10,15010)
		goto map15010 
::map15010::
		等待到指定地图(15010)	
		if(skillName=="抗毒")then 
			自动寻路(10,8)		
			common.learnPlayerSkillDir(1)	
		elseif(skillName=="抗昏睡")then 
			自动寻路(10,8)		
			common.learnPlayerSkillDir(3)	
		elseif(skillName=="抗石化")then 
			自动寻路(10,14)		
			common.learnPlayerSkillDir(1)	
		elseif(skillName=="抗酒醉")then 
			自动寻路(10,14)		
			common.learnPlayerSkillDir(3)	
		elseif(skillName=="抗混乱")then 
			自动寻路(15,8)		
			common.learnPlayerSkillDir(7)	
		elseif(skillName=="抗遗忘")then 
			自动寻路(15,8)		
			common.learnPlayerSkillDir(3)	
		end		
	elseif(skillName=="气绝回复")then		
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 5000)then
			common.getMoneyFromBank(5000)				
		end		
	::begin2499::
		common.toCastle("f1")
		自动寻路(45,20,"启程之间")	
		自动寻路(43, 22)	
		离开队伍()
		转向(2)
		dlg=等待服务器返回()
		if(dlg.message~=nil and (string.find(dlg.message,"此传送点的资格")~=nil or string.find(dlg.message,"不能使用这个传送石")~=nil))then
			执行脚本("./脚本/直通车/★开传送-亚留特村.lua")
			goto map2499
		end	
		转向(2)
		等待服务器返回()
		对话选择(4, 0)		
		等待(3000)
	::map2499::		
		if(取当前地图名() ~= "亚留特村的传送点")then
			goto begin2499
		end
		自动寻路(8, 3,"村长的家")		
		自动寻路(6, 13,"亚留特村")
		自动寻路(48,71)
		common.learnPlayerSkillDir(4)			
	elseif(skillName=="挖掘")then		
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(100)				
		end			
		common.gotoFaLanCity()	
		自动寻路(200,132,"基尔的家")
		自动寻路(9,3)
		common.learnPlayerSkill(9,2)	
	elseif(skillName=="挖掘")then		
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(100)				
		end			
		common.gotoFaLanCity()	
		自动寻路(200,132,"基尔的家")
		自动寻路(9,3)
		common.learnPlayerSkill(9,2)	
	elseif(skillName=="伐木")then		
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(100)				
		end			
		common.outFaLan("e")
		自动寻路(509, 153,"山男的家")	
		自动寻路(10,8)		
		common.learnPlayerSkill(10,7)	
	elseif(skillName=="狩猎")then		
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(100)				
		end			
		common.outFaLan("e")
		自动寻路(485,199)
		local searchList={{485,199},{486,209},{496,208},{481,232}}		
		for index,pos in ipairs(searchList) do						
			自动寻路(pos[1],pos[2])	
			u = 查周围信息("猎人拉修",1)
			if(u ~= nil)then
				移动到目标附近(u.x,u.y)
				common.learnPlayerSkill(u.x,u.y)	
				break
			end
		end		
	elseif(skillName=="治疗")then		
		if(取队伍人数()>1)then
			离开队伍()
		end
		if(人物("金币") < 100)then
			common.getMoneyFromBank(100)				
		end			
		common.gotoFaLanCity("w1")
		自动寻路(82,83,"医院")
		自动寻路(10,6)
		common.learnPlayerSkill(10,5)			
	elseif(skillName=="风刃魔法" or skillName=="火焰魔法"or skillName=="冰冻魔法"or skillName=="陨石魔法")then				
		等待空闲()			
		common.outFaLan("w")
		自动寻路(298, 148)
		while true do 
			npc=查周围信息("神木",1)
			if(npc ~= nil) then
				移动到目标附近(npc.x,npc.y)
				转向坐标(npc.x,npc.y)
				日志("魔术",1)
				对话选择(1,0)	
				等待(2000)
				if(取当前地图名() ~= "芙蕾雅")then			
					break
				end
			else
				日志("当前时间是【"..游戏时间().."】，】，等待黄昏或夜晚【荷特普】出现")
				等待(30000)
			end		
		end	
		if(skillName == "风刃魔法")then
			自动寻路(21,13)
			common.learnPlayerSkill(21,14)	
		elseif(skillName=="冰冻魔法")then
			自动寻路(21,9)
			common.learnPlayerSkill(21,8)	
		elseif(skillName=="陨石魔法")then
			自动寻路(21,9)
			common.learnPlayerSkill(22,9)
		elseif(skillName=="火焰魔法")then
			自动寻路(21,16)
			common.learnPlayerSkill(22,17)	
		end
	end
	if(common.findSkillData(skillName) ~=nil)then		
		喊话("已经完成技能【"..skillName.."】的学习",1,2,5)
		return
	else
		喊话("未能完成技能【"..skillName.."】的学习，请检查！",1,2,5)
		return	
	end
end
function common.outFaLan(dir)
::dengru::
	if(dir=="e")then		--东
		common.gotoFaLanCity("e1")
		自动寻路(281,88)
	elseif(dir == "s")then	--南
		common.gotoFaLanCity("s")
		自动寻路(154, 241)
	elseif(dir == "w")then	--西
		common.gotoFaLanCity("w1")
		自动寻路(22,88)	
	end
end
--出城堡 东南西北 e s w n
function common.outCastle(dir)
::dengru::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then			
		自动寻路(140,105)				
		转向(1)
		等待服务器返回()
		对话选择(4,0)
		等待到指定地图("里谢里雅堡")
		goto liBao
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao	
	elseif (当前地图名=="召唤之间" )then	--登出 bank
		自动寻路( 3, 7)	
		等待到指定地图("里谢里雅堡")	
		goto liBao
	end	
	回城()
	goto dengru
::liBao::
	if(dir=="e")then
		自动寻路(65,53)
	elseif(dir == "s")then
		自动寻路(41,98)
	elseif(dir == "w")then
		自动寻路(17,53)
	elseif(dir == "n")then
		自动寻路(41,14)
	end

end
function common.gotoFalanBankTalkNpc()
	if(取当前地图编号() ~= 1121)then
		common.gotoFaLanCity("e1")		
		等待到指定地图("法兰城")	
		自动寻路(238,111,"银行")	
	end
	自动寻路(11,8)
	面向("东")
	等待服务器返回()
end
--去银行和职员对话
function common.gotoBankTalkNpc()
::dengru::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto star1
	elseif (当前地图名=="里谢里雅堡" )then	
		goto star2
	elseif (当前地图名=="法兰城" )then	
		goto faLan
	elseif (当前地图名=="召唤之间" )then	--登出 bank
		自动寻路( 3, 7)	
		等待到指定地图("里谢里雅堡")	
		goto star2
	end	
	回城()
	goto dengru
::star1::
	自动寻路(157,94)	
	转向坐标(158,93)		
	等待到指定地图("艾夏岛")	
	自动寻路(114,105)	
	自动寻路(114,104,"银行")	
	自动寻路(49,30)
	面向("东")
	等待服务器返回()
    goto goEnd 
::star2::		
	自动寻路(41,98,"法兰城")	
	自动寻路(162, 130)		
    goto faLan
::faLan::
	common.gotoFaLanCity("e1")		
	等待到指定地图("法兰城")	
	自动寻路(238,111,"银行")	
	自动寻路(11,8)
	面向("东")
	等待服务器返回()
    goto goEnd 
::goEnd::
	return
end
--去银行取钱
function common.getMoneyFromBank(money)
	等待空闲()
	if(取队伍人数()>1)then
		离开队伍()
	end        
	common.gotoBankTalkNpc()
	银行("取钱",money)--没有取钱金额判断
end
--把非作战宠物全存银行
function common.depositNoBattlePetToBank()
	等待空闲()
	if(取队伍人数()>1)then
		离开队伍()
	end        
	common.gotoBankTalkNpc()
	allPets = 全部宠物信息()		
	--除了作战宠物 其余全存
	for i,pet in ipairs(allPets) do
		if(pet.battle_flags~=2)then	
			银行("存宠",pet.index)
			等待(2000)
		end
	end		
	allPets = 全部宠物信息()	
	for i,pet in ipairs(allPets) do
		if(pet.battle_flags~=2)then	
			银行("存宠",pet.index)			
		end
	end	
end
--购买封印卡
function common.buySealCard(sealCardName, buyCount, level )
	if(sealCardName==nil) then return end
	if(buyCount==nil)then buyCount=20 end
	if(level==nil)then level=1 end
	if (level <= 1 or level > 4) then
		level = 1
	end
	if(取物品叠加数量(sealCardName) >= buyCount)then return end
	if(取队伍人数()>1)then
		离开队伍()
	end 
	if(取包裹空格() < 1) then
		回城()
		common.sellCastle()		
	end	
	--封印卡默认20个一组 直接计算20
	local needSpace = math.ceil(buyCount/20)
	if(取包裹空格() < needSpace) then
		日志("背包空格不够，买封印卡中断！")
		return
	end
	if(level == 1)then		
		common.gotoFaLanCity("w1")
		自动寻路(94,78,"达美姊妹的店")	
		自动寻路(17,18)
		等待(1000)
		转向(2)
		等待服务器返回()
		对话选择(0,0) --第二个参数0 0买 1卖 2不用了
		local dlg = 等待服务器返回()
		local buyData = 解析购买列表(dlg.message)
		local itemList = buyData.items
		local dstItem = nil
		for i,item in ipairs(itemList)do
			if( item.name == sealCardName) then
				dstItem={index=i-1,count=buyCount}			
			end
		end
		if (dstItem ~= nil)then
			买(dstItem.index,dstItem.count)
			等待(1000)
			return true
		else
			日志("购买水晶失败！")
			return false
		end
		return false
	end
end
function common.艾岛定居()
	
::dengru::
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto dingju
	elseif (当前地图名=="里谢里雅堡" )then	
		goto StartBegin
	elseif (当前地图名=="法兰城" )then	
		goto StartBegin
	elseif (当前地图名=="召唤之间" )then	--登出 bank		
		goto StartBegin
	end	
	回城()
	goto dengru	
::StartBegin::		
	common.toCastle()
	等待到指定地图("里谢里雅堡")		
	自动寻路(28,88)
	等待服务器返回()			
	对话选择(32,0)
	等待服务器返回()			
	对话选择(32,0)
	等待服务器返回()		
	对话选择(32,0)
	等待服务器返回()			
	对话选择(32,0)
	等待服务器返回()	
	对话选择(4,0)
	等待到指定地图("？")	
	自动寻路(19, 20)
	移动一格(4,1)	
	等待到指定地图("法兰城遗迹")		
	自动寻路(98, 138,"盖雷布伦森林")
	自动寻路(124, 168,"温迪尔平原")		
	自动寻路(264, 108,"艾尔莎岛")	
::dingju::
	自动寻路(141, 106)		
	对话选是(142,105)
	自动寻路(140, 105)
	return
end
function common.去营地()	
::dengru::	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then	
		goto star1
	elseif (当前地图名=="里谢里雅堡" )then	
		goto star2
	elseif (当前地图名=="法兰城" )then	
		goto begin
	elseif (当前地图名=="芙蕾雅" )then	
		goto fuLeiYa
	elseif (当前地图名=="曙光骑士团营地" )then	
		goto shuGuang
	end	
	回城()
	等待(2000)
	goto dengru
::star1::
	自动寻路(140,105)
	等待(500)	
	转向(1)
	等待服务器返回()
	对话选择(4,0)
	等待(500)		
	等待空闲()
	if (取当前地图名()=="艾尔莎岛" )then	
		goto dengru
	end
    goto star2
::star2::		
	等待到指定地图("里谢里雅堡")		
	自动寻路(41,98)	
    goto begin
::begin::		
	等待到指定地图("法兰城")		
	自动寻路(153,241)	
::fuLeiYa::
	等待到指定地图("芙蕾雅")	
	自动寻路(510,282)	
	自动寻路(513,282,"曙光骑士团营地")	
::shuGuang::
	等待到指定地图("曙光骑士团营地")	
	自动寻路(55,47,"辛希亚探索指挥部")		
::zhiHuiBu::
	等待空闲()
	local mapIndex = 取当前地图编号()
	if (mapIndex==27014 )then	
		goto judgeTgt	
	elseif (mapIndex==27101 )then	
		goto daoYingDi
	elseif (mapIndex==44690 )then	--圣骑士营地
		goto dao
	else
		goto dengru
	end	
	goto zhiHuiBu	
::judgeTgt::
	if(目标是否可达(95,9) == false) then --第一个
		自动寻路(7,4)		
	else
		自动寻路(95,9)			
	end
	等待(1000)
	goto zhiHuiBu		
::daoYingDi::
	自动寻路(7,22)  	
	转向(0)		-- 转向北	
	等待(2000)
	goto zhiHuiBu
::dao::
	自动寻路(96,86)
	喊话("营地到了，等待猪的出现",2,3,5)
	等待(1000)
    return
end
--法兰工坊换矿
function common.faLanExchangeMine(mineName)
	if mineName==nil then return end
	mineList={
		["铜"]={{x=26,y=5},{x=26, y=4}},
		["铁"]={{x=28,y=6},{x=28, y=5}},
		["银"]={{x=29,y=6},{x=30, y=5}},
		["纯银"]={{x=27,y=7},{x=27, y=5}},
		["金"]={{x=24,y=6},{x=24, y=5}},
		["白金"]={{x=29,y=6},{x=30, y=7}},
		["幻之钢"]={{x=26,y=10},{x=28, y=10}},
		["幻之银"]={{x=27,y=9},{x=28, y=8}},
		["勒格耐席鉧"]={{x=23,y=7},{x=22, y=6}},		
		["奥利哈钢"]={{x=26,y=12},{x=27, y=12}}
		}
	local data = mineList[mineName]
	if(data~=nil)then
		自动寻路(data[1].x,data[1].y)
		压矿(data[2].x,data[2].y,mineName)
		叠(mineName.."条", 20)	
	end
end







function common.卵4步骤1(step)
	等待空闲()
	if(取物品数量("琥珀之卵") < 1)then 
		回城() 
		自动寻路(201,96,"神殿　伽蓝")
		自动寻路(95,80,"神殿　前廊")
		自动寻路(44,41,59531)
		自动寻路(34,34,59535)
		自动寻路(48,60,"约尔克神庙")
		自动寻路(39,22)
		while true do 
			if(取物品数量("琥珀之卵") < 1)then 
				if(游戏时间() == "黄昏" or 游戏时间() == "夜晚")then
					对话选是(0)
				else
					日志("当前时间是【"..游戏时间().."】，等待【黄昏或夜晚】")
					等待(30000)
				end
			else
				break
			end			
		end		
	end	
	等待空闲()	
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return step
		end
	end
	自动寻路(157,93)
	转向(2)	
	等待到指定地图("艾夏岛")	
	自动寻路(102, 115,"冒险者旅馆")	
	自动寻路(30, 21)	
	转向(0)
	喊话("朵拉",2,3,5)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(1,0)
	喊话("朵拉",2,3,5)
	等待服务器返回()
	对话选择(4,0)
	等待服务器返回()
	对话选择(1,0)	
	回城()
	step = step+1	
	return step
end

function common.卵4找长老(队伍人数)
	if(队伍人数 <= 1)then
		设置("遇敌全跑",1)
	end
::beFind::
	if(是否空闲中()==false)then
		等待(2000)
		goto beFind
	end		
	if(string.find(取当前地图名(),"海底墓场外苑")==nil)then --错误 返回
		return false
	end
	找到,findX,findY,nextX,nextY=搜索地图("守墓员",1)
	if(找到) then		
		移动到目标附近(findX,findY)
		if(队伍人数 <= 1)then
			设置("遇敌全跑",0)
		end	
		while true do
			if 是否战斗中() == false then
				转向坐标(findX,findY)	
				等待服务器返回()
				对话选择(1, 0)
			else
				break
			end
			等待(1000)
		end			
		while true do	--打长老之证			
			if(取物品叠加数量("长老之证")>=7 or string.find(聊天(50),"长老之证够了")~=nil)then
				日志("长老之证齐了")				
				return true
			elseif(取包裹空格()< 1 and 取物品叠加数量("长老之证")<7)then
				日志("包裹满了")
				break
			end 		
			if(string.find(取当前地图名(),"海底墓场外苑")==nil)then --错误 返回
				return false
			end
			叠("长老之证",3)	--战斗中 不知道会不会崩
			对话选择(1, 0)
			等待(1000)
		end
		if(取物品叠加数量("长老之证")>=7 )then
			return true
		end
		丢("魔石")
		丢("僧侣适性检查合格证")
		丢("风的水晶碎片")
		丢("地的水晶碎片")
		丢("水的水晶碎片")
		丢("火的水晶碎片")
		丢("卡片？")	
	end
	等待(2000)
	goto beFind
end
function common.卵4步骤2(step,队长名称,队伍人数,队员列表)	
	等待空闲()	
	local outMazeX,outMazeY
	local outMapName	
::begin::
	if(取当前地图名() == "？？？") then
		if(队伍("人数") < 队伍人数)then	--数量不足 等待
			common.makeTeam(队伍人数,队员列表)
		end
		goto shua
	end
	if(string.find(取当前地图名(),"海底墓场外苑")~=nil)then
		goto shua
	end
	common.supplyCastle()
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return step
		end
	end
	设置("遇敌全跑",1)
	自动寻路(130, 50, "盖雷布伦森林")	
	自动寻路(246, 76, "路路耶博士的家")	
	等待(2000)
	自动寻路(3,10,"？？？")
	设置("遇敌全跑",0)		
	if(人物("名称",false) == 队长名称)then	
		if(队伍("人数") < 队伍人数)then	--数量不足 等待
			common.makeTeam(队伍人数,队员列表)
		end
		自动寻路(132, 62)
		goto shua
	else
		goto teamTalk	
	end
	goto begin
::teamTalk::
	当前地图名=取当前地图名()
	if(当前地图名 == "？？？") then
		if(队伍("人数") < 2)then
			common.joinTeam(队长名称)
		else
			if(是否目标附近(131,60))then			
				对话选是(131,60)			
			end
		end	
	end
	if(当前地图名 == "盖雷布伦森林") then		
		回城()
		step = step+1
		return step
	end	
	if(取物品叠加数量("长老之证")>=7 )then
		日志("长老之证够了",1)
	end  	
	if(当前地图名=="艾尔莎岛")then 
		return step
	end
	等待(3000)
	goto teamTalk

::shua::	
	while true do
		等待空闲()	
		if(取当前地图名() == "？？？") then
			自动寻路(122, 69,"海底墓场外苑第1地带")
			日志("开始找守墓员")				
		elseif(string.find(取当前地图名(),"海底墓场外苑")~=nil)then
			outMazeX,outMazeY=取当前坐标()
			outMapName=取当前地图名()
			common.卵4找长老(队伍人数)
			if(取物品叠加数量("长老之证")>=7 or string.find(聊天(50),"长老之证够了")~=nil)then				
				break				
			end  	
		elseif(取当前地图名() == "路路耶博士的家") then
			自动寻路(3,10,"？？？")
		else
			日志("地图信息错误"..取当前地图名())
			return step
		end
	end
	goto outMaze
::outMaze::	
	等待空闲()
	if(队伍人数 <= 1)then	--1个人还是跑着
		设置("遇敌全跑",1)
	end
	if(outMapName ~=nil and 取当前地图名()==outMapName)then
		if(outMazeX ~= nil and outMazeY ~= nil)then
			自动寻路(outMazeX,outMazeY)
		end
	end
	while true do
		当前地图名 = 取当前地图名()
		if(当前地图名=="？？？") then
			goto mapJudge
		end
		if (string.find(当前地图名,"海底墓场外苑")==nil)then
			--不知道哪 返回
			return step
		end
		自动迷宫(1)
		等待(1000)
	end
	goto outMaze
::mapJudge::
	if(取当前地图名() == "？？？" and 取物品叠加数量("长老之证")>=7) then				  
		while (队伍("人数") < 队伍人数) do--数量不足 等待
			common.makeTeam(队伍人数,队员列表)
			等待(5000)	
		end
		自动寻路(131,61)
		自动寻路(132,61)
		自动寻路(131,61)
		自动寻路(132,61)
		自动寻路(131,61)
		if(是否目标附近(131,60))then			
			对话选是(131,60)			
		end
	else
		goto begin
	end
	if(取当前地图名() == "盖雷布伦森林") then		
		回城()
		step = step+1	
		return step
	end	
	等待(1000)
	goto mapJudge
end

function common.卵4步骤3(step)
	等待空闲()	
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")			
			return step
		end
	end
	自动寻路(201,96,"神殿　伽蓝")	
	自动寻路(91, 138)		
	while true do 
		npc=查周围信息("荷特普",1)
		if(npc ~= nil) then
			对话选是(92,138)
			break
		else
			日志("当前时间是【"..游戏时间().."】，】，等待黄昏或夜晚【荷特普】出现")
			等待(30000)
		end		
	end			
	回城()
	step = step+1	
	return step
end

function common.卵4打障碍物()
	local tmpPos=
	{
		{x=229,y=177,npcx=230,npcy=177},
		{x=234,y=202,npcx=235,npcy=202},
		{x=228,y=206,npcx=228,npcy=207},
		{x=213,y=225,npcx=213,npcy=226},
		{x=193,y=184,npcx=192,npcy=184}
	}
	
::begin::
	for i,pos in ipairs(tmpPos) do
		自动寻路(pos.x,pos.y)
		转向坐标(pos.npcx,pos.npcy)
		等待(2000)
		等待空闲()
		if(人物("坐标") == "163,100") then 
			return
		end
	end
	if(目标是否可达(163,100) == true) then 
		return
	end
	goto begin
end
function common.卵4步骤4(step,队长名称,队伍人数,队员列表)	
	等待空闲()			
	if(取物品数量("逆十字") < 1)then
		自动寻路(157,93)
		转向(2)	
		等待到指定地图("艾夏岛")	
		自动寻路(102, 115,"冒险者旅馆")	
		自动寻路(56, 32)	
		对话选是(0)
		if(取物品数量("逆十字") < 1)then
			日志("没有获得【逆十字】，请检查任务进度是否有误")
			return step
		end	
	end
	if(取当前地图名()=="？？？")then 
		goto map59714
	end
	common.supplyCastle()
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return step
		end
	end
	设置("遇敌全跑",1)
	自动寻路(165, 153)
	对话选否(4)
	等待到指定地图("梅布尔隘地")
	自动寻路(211, 117)
	对话选是(212,116)
	等待到指定地图("？？？")
	设置("遇敌全跑",0)
	--不知道坐标 原地等吧
::meiBuEr::
	自动寻路(211, 117)
	对话选是(212,116)
	等待到指定地图("？？？")
::map59714::
	设置("遇敌全跑",0)
	if(人物("名称",false) == 队长名称)then
		while (队伍("人数") < 队伍人数) do--数量不足 等待
			common.makeTeam(队伍人数,队员列表)
			等待(5000)	
		end
		自动寻路(135,197)
		方向穿墙(2,8)
		自动寻路(156, 197,59714)		
		common.卵4打障碍物()		
		自动寻路(163, 107)
		方向穿墙(4,8)
		自动寻路(242,117, 59716)
		自动寻路(221, 188)
		对话选否(222,188)
		等待(1000)
		回城()
		step= step+1	
		return step
	else
		goto teamTalk
	end
::teamTalk::
	当前地图名=取当前地图名()
	if(当前地图名 == "？？？") then
		if(队伍("人数") < 2)then
			common.joinTeam(队长名称)		
		end	
	elseif(string.find(当前地图名,"梅布尔隘地")~=nil)then
		离开队伍()
		goto meiBuEr
	elseif(取当前地图编号() == 59716) then
		goto map59716		
	end
	等待(3000)
	goto teamTalk
::map59716::
	if(是否战斗中())then
		等待(1000)
		回城()
		step= step+1	
		return step
	end
	等待(1000)
	goto map59716		
	
end

function common.卵4步骤5(step)
	等待空闲()		
	if(取物品数量("觉醒的文言抄本") < 1)then
		日志("身上没有【觉醒的文言抄本】，请先准备好道具再去换【保证书】")
		return step
	end
	if(取物品数量("转职保证书") > 0)then
		日志("身上已经有一本【保证书】，请先使用后再去换保证书")
		return step
	end
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return step
		end
	end
	设置("遇敌全跑",1)
	自动寻路(130, 50, "盖雷布伦森林")	
	自动寻路(244, 74)	
	对话选是(245,73)
	if(取物品数量("转职保证书") > 0)then
		日志("恭喜你！获得了【转职保证书】")
		step=step+1
		return step
	end
end


function common.卵4(step,队长名称,队伍人数,队员列表)	
	if(step == nil)then
		step=1
	end
	if(队长名称 == nil)then
		队长名称=人物("名称",false)
	end
	if(队伍人数 == nil)then
		队伍人数=1
	end
	设置("移动速度",110)
	设置("自动叠",1,"长老之证&3")
	日志("队长名称"..队长名称,1)
	stepMsg={
		[1]="1、从头（朵拉）开始任务",
		[2]="2、从打长老证之前开始任务",
		[3]="3、从荷普特开始任务",
		[4]="4、从祭坛守卫开始任务",
		[5]="5、从打完BOSS换保证书开始任务（必须有文言抄本）"	
		}
	日志("开始保证书之-卵4任务，开始步骤："..stepMsg[step],1)
	while true do	
		日志("卵4任务，当前步骤："..stepMsg[step],1)
		if(step == 1)then
			step=common.卵4步骤1(step)
		elseif(step == 2)then
			step=common.卵4步骤2(step,队长名称,队伍人数,队员列表)	
		elseif(step == 3)then
			step=common.卵4步骤3(step)
		elseif(step == 4)then
			step=common.卵4步骤4(step,队长名称,队伍人数,队员列表)	
		elseif(step == 5)then
			step=common.卵4步骤5(step)	
		elseif(step >= 6)then
			日志("卵4任务已完成")
			设置("移动速度",100)
			break
		end
	end
end
--获取人物技能等级 失败返回0
function common.playerSkillLv(skillName)
	local playerData = 人物信息()
	for i,skill in ipairs(playerData.skill) do
		if(skill.name == skillName)then
			--日志("技能等级："..skillName..skill.lv)
			return skill.lv
		end
	end
	return 0
end
--宠物学习蛋二
function common.leanPetEggSecondSkill(x,y,skillIndex,petIndex,petSkillIndex)
	--判断宠物是不是改造烈风哥布林  不是返回
	local pet = 宠物信息(petIndex)
	if(pet == nil)then
		日志("获取宠物信息失败，请确认宠物index",1)
		return false
	end
	if(pet.realname ~= "改造烈风哥布林")then
		日志("限制只能改造烈风哥布林自动学习",1)
		return false
	end
	if(pet.level < 40)then
		日志("宠物等级不够40",1)
		return false
	end
	if(取物品数量(450769) < 1)then
		日志("包裹没有蛋二劵",1)
		return false
	end
end
function common.askNowPrestige(msg)
	if( msg == nil) then
		日志("称号进度msg为空，返回0")
		return 0 
	end
	if( string.find(msg,"一点兴趣都没有") ~= nil)then
		return 0
	end
	if( string.find(msg,"要拿到新称号还久") ~= nil)then
		return 0
	end
	if( string.find(msg,"只有四分之一") ~= nil)then
		return 1
	end
	if( string.find(msg,"过一半了吧") ~= nil)then
		return 2
	end
	if( string.find(msg,"爱谄媚的勇者") ~= nil)then
		return 3
	end
	if( string.find(msg,"应该能得到新称号") ~= nil)then
		return 4
	end
	if( string.find(msg,"天天找小孩子问称号的呆子") ~= nil)then
		return 9
	end
	return 0
end

--检查聊天信息中，是否包含队友指定喊话内容 true包含 false不包含
function common.checkChatContainTeammateMsg(chatMsg)
	if(chatMsg==nil)then return end
	local teamPlayers = 队伍信息()
	local teammateCount = common.getTableSize(teamPlayers)
	for index,teamPlayer in ipairs(teamPlayers) do
		if(string.find(聊天(50),teamPlayer.name..": "..chatMsg)~=nil)then 
			return true
		end			
	end  	
	return false
end
--循环等待队友指定喊话
function common.waitTeammateChat(chatMsg)
	if(chatMsg==nil)then return end
	local teamPlayers = 队伍信息()
	local teammateCount = common.getTableSize(teamPlayers)
	local count=0
::begin::	
	for index,teamPlayer in ipairs(teamPlayers) do
		if(string.find(聊天(50),teamPlayer.name..": "..chatMsg)~=nil)then 
			count=count+1
		end			
	end  
	if(count>=(teammateCount-1))then	--不计算自己所以-1
		return
	end		
	count=0
	goto begin	
end


function common.登录游戏id(游戏id,tFileName,lastGidInfo,functionAction,funArg,dstRole)

	local 左右角色=0
	--如果是最后一次gid  则使用记录的左右角色值 登录
	if dstRole then 左右角色=lastGidInfo.role end
	--切换游戏id
	local worldStatus=0
	local gameStatus=0
	local loginState,loginMsg = 取登录状态()
	local mapNum=0
	local mapName=""
	local topicMsg={}
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
		for tryNum=1,15 do		--等15秒 判断是否连接成功
			if(游戏窗口状态() == true )then break end
			等待(1000)
		end
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
		goto begin
	end	
	等待(1000)
	goto checkCharacter
::begin::
	functionAction(funArg)		--回调用户自定义行为
	获取仓库信息()
	保存仓库信息()
	左右角色=左右角色+1
	if(左右角色 > 1)then	--左右都已获取仓库 去下一个
		lastGidInfo.role=人物("左右角色")
		lastGidInfo.gid=人物("gid")
		lastGidInfo.roleName=人物("名称",false)
		lastGidInfo.index=common.findTableIndex(获取游戏子账户(),人物("gid"))		
		common.WriteFileData(tFileName,common.TableToStr(lastGidInfo))
		登出服务器()
		return
	end
	重置登录状态()
	设置登录子账号(游戏id)
	设置登录角色(左右角色)	--左边		
	登出服务器()
	等待(1000)	
	goto switchCharacter

end
--仓库在线等待函数 
--tFileName 仓库本地文件名  百人道场仓库.txt
function common.warehouseOnlineWait(tFileName,functionAction,funArg)
	local cgGidList={}	--游戏Gid列表
	local lastGidInfo={gid="",role=0,roleName="",index=1}	--最后一次仓库信息
--循环等待获取游戏的所有子id  成功后去下一步
::begin::
	cgGidList=获取游戏子账户()	--登录成功才能获取
	if(common.getTableSize(cgGidList) > 0)then
		goto switchGid
	else
		打开游戏窗口()
		等待(10000)
	end
	
	等待(1000)
	goto begin
--控制切换游戏id
::switchGid::
	local readFileMsg = common.ReadFileData(tFileName)
	if(readFileMsg == nil)then
		lastGidInfo.gid = cgGidList[1]
	else
		lastGidInfo = common.StrToTable(readFileMsg)	
	end
	
	if(lastGidInfo==nil or type(lastGidInfo) ~= "table")then 
		lastGidInfo={gid="",role=0,roleName="",index=1}
	end
	日志("上次仓库index".. lastGidInfo.index.." gid"..lastGidInfo.gid.." 角色"..lastGidInfo.role)	
	if(lastGidInfo.gid ~= 人物("gid"))then
		登出服务器()
	end
	for k,v in pairs(cgGidList) do  
		if(k == lastGidInfo.index)then
			日志("登录最后一次仓库")
			common.登录游戏id(v,tFileName,lastGidInfo,functionAction,funArg,true)
		elseif(k > lastGidInfo.index)then
			common.登录游戏id(v,tFileName,lastGidInfo,functionAction,funArg,false)
		end
	end  
	--获取完成 退出
	return

end 
--预置交易金币函数
common.waitTradeGoldAction=function(args)
	local mapName=""
	local mapNum=0
	local bankGold=0
	local cGold=0
	local topicMsg=nil
::begin::
	等待空闲()
	mapName = 取当前地图名()
	mapNum =取当前地图编号()
	if (mapName=="艾尔莎岛" or mapName=="法兰城" or mapName=="里谢里雅堡" )then	
		common.gotoFalanBankTalkNpc()
		goto bankWait
	elseif (mapName=="银行" and mapNum== 1121)then	
		goto bankWait
	elseif (mapName=="召唤之间" )then	--登出 bank
		自动寻路(3,9)
		对话选是(4,9)
		回城()
		common.gotoFalanBankTalkNpc()
		goto bankWait
	end	
	回城()
	等待(1000)	
	goto begin
::bankWait::
	if(取当前地图编号() ~= 1121)then
		common.gotoFalanBankTalkNpc()
	end
	自动寻路(args.x,args.y)
	topicMsg = {name=人物("名称",false),gold=1000000-人物("金币"),line=人物("几线")}
	发布消息(args.topic, common.TableToStr(topicMsg))
	等待交易("","","",10000)
	if(人物("金币") > 900000)then
		goto cun
	end	
	goto bankWait
::cun::
	自动寻路(11,8)
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
	等待(2000)
	if(银行("金币") == 1000000 and 人物("金币") > 1)then	--看看是不是大客户
		银行("存钱",1)
	end	
	等待(2000)
	if(人物("金币")>=1000000)then		--如果金币满了 就退出
		return	--登出 切换仓库
	end
	goto bankWait	
end
--预置交易道具函数
common.waitTradeItemsAction=function(args)
	local mapName=""
	local mapNum=0
::begin::
	等待空闲()
	mapName = 取当前地图名()
	mapNum =取当前地图编号()
	if (mapName=="艾尔莎岛" or mapName=="法兰城" or mapName=="里谢里雅堡" )then	
		common.gotoFalanBankTalkNpc()
		goto bankWait
	elseif (mapName=="银行" and mapNum== 1121)then	
		goto bankWait
	elseif (mapName=="召唤之间" )then	--登出 bank
		自动寻路(3,9)
		对话选是(4,9)
		回城()
		common.gotoFalanBankTalkNpc()
		goto bankWait
	end	
	回城()
	等待(1000)	
	goto begin
::bankWait::
	if(取当前地图编号() ~= 1121)then
		common.gotoFalanBankTalkNpc()
	end
	
	自动寻路(args.x,args.y)	
	topicMsg = {name=人物("名称",false),bagcount=取包裹空格(),line=人物("几线")}
	发布消息(args.topic, common.TableToStr(topicMsg))	
	if(银行("金币") >= 1000000)then
		if(人物("金币") > 998000)then
			等待交易("","金币:20","",10000)
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
	自动寻路(11,8)
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
			return	--登出 切换仓库
		end
	else
		i=8
		while i<= 28 do
			银行("存包裹位置",i)
			i=i+1
			等待(1000)
		end
	end
	goto bankWait
end
--预置交易宠物函数
common.waitTradePetsAction=function(args)
	local mapName=""
	local mapNum=0
::begin::
	等待空闲()
	mapName = 取当前地图名()
	mapNum =取当前地图编号()
	if (mapName=="艾尔莎岛" or mapName=="法兰城" or mapName=="里谢里雅堡" )then	
		common.gotoFalanBankTalkNpc()
		goto bankWait
	elseif (mapName=="银行" and mapNum== 1121)then	
		goto bankWait
	elseif (mapName=="召唤之间" )then	--登出 bank
		自动寻路(3,9)
		对话选是(4,9)
		回城()
		common.gotoFalanBankTalkNpc()
		goto bankWait
	end	
	回城()
	等待(1000)	
	goto begin
::bankWait::
	if(取当前地图编号() ~= 1121)then
		common.gotoFalanBankTalkNpc()
	end
	if(common.getTableSize(全部宠物信息()) == 5)then
		自动寻路(11,8)
		面向("东")
		等待服务器返回()
		if(银行("宠物数") == 5)then	--默认20
			return
		end
	end		
	自动寻路(args.x,args.y)
	topicMsg = {name=人物("名称",false),pets=5-common.getTableSize(全部宠物信息()),line=人物("几线")}
	发布消息(args.topic, common.TableToStr(topicMsg))
	开关(4,1)		--打开交易
	if(银行("金币") >= 1000000)then
		if(人物("金币") > 998000)then			--钱太多 交易给对方20
			--等待交易("","金币:20","",20000)			
			tradeDlg = 已接收最新交易消息()		--默认5秒内交易消息 可以传毫秒进去
			if(tradeDlg.level ~= 0)then
				交易物品验证确认("","金币:20","",20000)
			end
		else
			
			tradeDlg = 已接收最新交易消息()		--默认5秒内交易消息 可以传毫秒进去
			if(tradeDlg.level ~= 0)then
				交易物品验证确认("","","",20000)
			end
			--等待交易("","","",20000)
		end
	else
		if(人物("金币") > 900000)then		
			goto cun
		else
			tradeDlg = 已接收最新交易消息()	--默认5秒内交易消息 可以传毫秒进去
			if(tradeDlg.level ~= 0)then
				交易物品验证确认("","","",20000)
			end
			--等待交易("","","",20000)
		end
	end	
	if(common.getTableSize(全部宠物信息()) == 5)then
		goto cun
	end
	goto bankWait
::cun::
	自动寻路(11,8)
	面向("东")
	等待服务器返回()
	bankGold = 银行("金币")
	cGold=人物("金币")
	if(bankGold > 1000000)then	--银行金币大于100万 取最小值
		cGold =  math.min(10000000-bankGold,cGold)
	else
		cGold =  math.min(1000000-bankGold,cGold-2000)
	end
	银行("存钱",cGold)
	等待(2000)
	银行("取钱",2000)
	if(银行("宠物数") == 5)then	--默认20
		if(common.getTableSize(全部宠物信息()) == 5)then
			return
		end
	else
		i=0
		while i<= 5 do
			银行("存宠",i)
			i=i+1
			等待(1000)
		end
	end
	goto bankWait
end

--预置发放道具函数 itemName  itemId因为从银行获取不到 只支持名称
--args.x args.y args.topic args.publish
--args.itemName args.itemCount args.itemPileCount 交易物品名 或id 交易数量以及交易叠加数量 默认1
--坐标以及通知消息和接受交易信息
common.waitProvideTradeItemsAction=function(args)
	local mapName=""
	local mapNum=0
	local topic=""
	local msg=""
	local topicMsg={}
	if(args.itemName ==nil)then 
		日志("发放物品名为空，请检查后再启用脚本",1)
	end
	if(args.itemCount ==nil)then args.itemCount=1 end
	if(args.itemPileCount ==nil)then args.itemPileCount=1 end
	local provideTradeInfo="物品:"..args.itemName.."|"..args.itemPileCount.."|"..args.itemCount
	local tryCount=0
	local preTradeItemCount=0
	local recvTbl=nil
	local topicList={args.publish}
	订阅消息(topicList)
::begin::
	等待空闲()
	mapName = 取当前地图名()
	mapNum =取当前地图编号()
	if (mapName=="艾尔莎岛" or mapName=="法兰城" or mapName=="里谢里雅堡" )then	
		common.gotoFalanBankTalkNpc()
		goto bankWait
	elseif (mapName=="银行" and mapNum== 1121)then	
		goto bankWait
	elseif (mapName=="召唤之间" )then	--登出 bank
		自动寻路(3,9)
		对话选是(4,9)
		回城()
		common.gotoFalanBankTalkNpc()
		goto bankWait
	end	
	回城()
	等待(1000)	
	goto begin
::bankWait::
	if(取当前地图编号() ~= 1121)then
		common.gotoFalanBankTalkNpc()
	end
	自动寻路(args.x,args.y)	
	topicMsg = {name=人物("名称",false),bagcount=取包裹空格(),line=人物("几线")}
	发布消息(args.topic, common.TableToStr(topicMsg))	
	topic,msg=已接收订阅消息(args.publish)	
	--日志(topic.." Msg:"..msg)
	if(topic == args.publish)then
		recvTbl = common.StrToTable(msg)			
	end	
	等待空闲()	
	if(recvTbl~=nil and recvTbl.name ~= nil and recvTbl.bagcount ~= nil)then	
		preTradeItemCount=取物品数量(recvTbl.name)
		tryCount=0
		while tryCount < 3 do
			tryCount=tryCount+1
			日志("等待交易"..recvTbl.name)		
			等待交易(recvTbl.name,provideTradeInfo,"",10000)	
			--交易成功 就终止
			if(preTradeItemCount ~= 取物品数量(recvTbl.name))then
				break
			end
		end
		recvTbl=nil
	else
		人物动作(14)	
	end
	if(取物品数量(args.itemName) < 1)then
		goto 从银行取
	end
	等待(4000)
	goto bankWait
::从银行取::
	自动寻路(11,8)
	转向(2)
	等待服务器返回()
	银行("全取",args.itemName)
	等待(5000)
	if(取物品数量(args.itemName) < 1)then
		return  --切换账号
	end
	goto bankWait
end
--去银行领取物品
--args.topic  args.publish args.itemName  args.itemPileCount args.itemCount
common.gotoBankRecvTradeItemsAction=function(args)
	local tryCount=0
	local topicList={args.topic}
	订阅消息(topicList)
	local topic=""
	local msg=""
	local recvTbl=nil
	local topicMsg={}
::begin::
	等待空闲()	
	topic,msg=已接收订阅消息(args.topic)	
	--日志(topic.." Msg:"..msg)
	if(topic == args.topic)then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeBagSpace=recvTbl.bagcount
		tradePlayerLine=recvTbl.line
	else
		等待(5000)
		goto begin
	end	
	--日志(tradeName.." "..tradeBagSpace .." " ..tradePlayerLine)
	if(tradePlayerLine ~= nil and tradePlayerLine ~= 0 and tradePlayerLine ~= 人物("几线"))then
		切换登录信息("","",tradePlayerLine,"")
		登出服务器()
		等待(3000)			
		goto begin
	end	
	if(tradeName ~= nil and tradeBagSpace ~= nil)then	
		if(取当前地图编号() ~= 1121)then			
			common.gotoFalanBankTalkNpc()		
		end	
		tryCount=0
		while tryCount < 3 do
			tryCount=tryCount+1
			topicMsg = {name=人物("名称",false),bagcount=取包裹空格(),line=人物("几线")}
			发布消息(args.publish, common.TableToStr(topicMsg))
			tradex=nil
			tradey=nil
			units = 取周围信息()
			if(units ~= nil)then
				for i,u in pairs(units) do
					if(u.unit_name==tradeName)then
						tradex=u.x
						tradey=u.y
						break
					end
				end
			else
				goto begin
			end
			if(tradex ~=nil and tradey ~= nil)then
				移动到目标附近(tradex,tradey)
			else
				goto begin
			end
			转向坐标(tradex,tradey)		
			--日志(tradeList)		
			交易(tradeName,"","",10000)
			if(取物品数量(args.itemName) >= args.itemCount)then
				tradeName=nil
				tradeBagSpace=nil
				tradePlayerLine=nil	
				--回城()
				return
			end		
		end
	end
	goto begin
end
--去银行领取金币
--这里金币代指人物拥有的金币 而不是去领取的金币数
--needGold理想需要的金币  minGold没有达到理想金币，但有最小金币，尝试n次后返回
--args.topic  args.publish args.needGold  args.minGold 
common.gotoBankRecvTradeGoldAction=function(args)
	local tryCount=0
	local topicList={args.topic}
	订阅消息(topicList)
	local topic=""
	local msg=""
	local recvTbl=nil
	local topicMsg={}
	local tradeGold=0
	local tradeName=""
	local tradeBagSpace=0
	local tradePlayerLine=0
	local tradey=0
	local tradex=0
	local units=nil
	local oldGold=人物("金币")
	local minGoldTryCount=0
	if(oldGold >= args.needGold )then
		return
	end
	local calcNeedGold=args.needGold-oldGold
::begin::
	等待空闲()	
	topic,msg=已接收订阅消息(args.topic)	
	--日志(topic.." Msg:"..msg)
	if(topic == args.topic)then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeGold=recvTbl.gold
		tradePlayerLine=recvTbl.line
	else
		等待(5000)
		goto begin
	end	
	--日志(tradeName.." "..tradeBagSpace .." " ..tradePlayerLine)
	if(tradePlayerLine ~= nil and tradePlayerLine ~= 0 and tradePlayerLine ~= 人物("几线"))then
		切换登录信息("","",tradePlayerLine,"")
		登出服务器()
		等待(3000)			
		goto begin
	end	
	if(tradeName ~= nil and tradeBagSpace ~= nil)then	
		if(取当前地图编号() ~= 1121)then			
			common.gotoFalanBankTalkNpc()		
		end	
		tryCount=0
		while tryCount < 3 do
			tryCount=tryCount+1
			topicMsg = {name=人物("名称",false),bagcount=取包裹空格(),line=人物("几线"),needGold=calcNeedGold}
			发布消息(args.publish, common.TableToStr(topicMsg))
			tradex=nil
			tradey=nil
			units = 取周围信息()
			if(units ~= nil)then
				for i,u in pairs(units) do
					if(u.unit_name==tradeName)then
						tradex=u.x
						tradey=u.y
						break
					end
				end
			else
				goto begin
			end
			if(tradex ~=nil and tradey ~= nil)then
				移动到目标附近(tradex,tradey)
			else
				goto begin
			end
			转向坐标(tradex,tradey)		
			--日志(tradeList)		
			交易(tradeName,"","",10000)
			if( 人物("金币") >= args.needGold  )then
				tradeName=nil
				tradeBagSpace=nil
				tradePlayerLine=nil	
				--回城()
				return
			elseif(人物("金币") >= args.minGold )then
				minGoldTryCount =minGoldTryCount+1
				if(minGoldTryCount >= 10)then
					日志("已领取最少金币，继续之前任务")
					tradeName=nil
					tradeBagSpace=nil
					tradePlayerLine=nil	
					--回城()
					return
				end
			end			
		end
	end
	goto begin
end
--去银行交易道具
--args.topic  args.publish args.itemName  args.itemPileCount args.itemCount
common.gotoBankStoreItemsAction=function(args)	
	local tradex=nil
	local tradey=nil
	local topic=""
	local msg=""
	local recvTbl={}
	local units=nil
	local tradeList=""
	local hasData=false
	local selfTradeCount=0
	local tradeName=""
	local tradeBagSpace=0
	local tradePlayerLine =0
	local topicList={args.topic}
	订阅消息(topicList)
	if(args.itemCount == nil )then args.itemCount=0 end
	if(args.itemPileCount == nil )then args.itemPileCount=0 end
	local tryNum=0
	--日志(args.tgtTopic)
::begin::
	等待空闲()
	topic,msg=已接收订阅消息(args.topic)	
	--日志(topic.." Msg:"..msg)
	if(topic == args.topic)then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeBagSpace=recvTbl.bagcount
		tradePlayerLine=recvTbl.line
	else
		等待(5000)		--给内部时间  去接收收到的信息
		goto begin
	end	
	--日志(tradeName.." "..tradeBagSpace .." " ..tradePlayerLine)
	if(tradePlayerLine ~= nil and tradePlayerLine ~= 0 and tradePlayerLine ~= 人物("几线"))then
		切换登录信息("","",tradePlayerLine,"")
		登出服务器()
		等待(3000)			
		goto begin
	end	
	if(tradeName ~= nil and tradeBagSpace ~= nil)then	
		if(取当前地图编号() ~= 1121)then			
			common.gotoFalanBankTalkNpc()		
		end	
		tradex=nil
		tradey=nil
		units = 取周围信息()
		if(units ~= nil)then
			for i,u in pairs(units) do
				if(u.unit_name==tradeName)then
					tradex=u.x
					tradey=u.y
					break
				end
			end
		else
			goto begin
		end
		if(tradex ~=nil and tradey ~= nil)then
			移动到目标附近(tradex,tradey)
		else
			goto begin
		end
		转向坐标(tradex,tradey)			
		local items = 物品信息()
		tradeList="金币:20;物品:"
		hasData=false
		selfTradeCount=0
		for i,v in pairs(items) do		
			if v.pos > 7 and (v.itemid == args.itemID or v.name == args.itemName) then
				if(v.count==0 or v.count >= args.itemPileCount)then	--数量够 再进行下一步
					if(args.itemID ~= nil)then
						if(hasData)then
							tradeList=tradeList.."|"..args.itemID.."|"..v.count.."|".."1"
						else
							tradeList=tradeList..args.itemID.."|"..v.count.."|".."1"			
						end
					else
						if(hasData)then
							tradeList=tradeList.."|"..args.itemName.."|"..v.count.."|".."1"
						else
							tradeList=tradeList..args.itemName.."|"..v.count.."|".."1"			
						end
					end
					selfTradeCount=selfTradeCount+1
					hasData=true
					if(selfTradeCount >= tradeBagSpace)then
						break
					end		
				end				
			end
		end			
		日志(tradeList)
		if(hasData)then
			交易(tradeName,tradeList,"",10000)
		else	
			--设置("timer",100)
			--下次说不定是哪个仓库 设置为nil
			tradeName=nil
			tradeBagSpace=nil
			tradePlayerLine=nil	
			--回城()
			return
		end
		tryNum=tryNum+1	
	end
	goto begin
end
--去银行交易宠物
--args.topic  args.publish args.itemName  args.itemPileCount args.itemCount
common.gotoBankStorePetsAction=function(args)	
	local tradex=nil
	local tradey=nil
	local topic=""
	local msg=""
	local recvTbl={}
	local units=nil
	local tradeList=""
	local hasData=false
	local selfTradeCount=0
	local tradeName=""
	local tradeBagSpace=0
	local tradePlayerLine =0
	local topicList={args.topic}
	订阅消息(topicList)
	--日志(args.tgtTopic)
::begin::
	等待空闲()
	topic,msg=已接收订阅消息(args.topic)	
	--日志(topic.." Msg:"..msg)
	if(topic == args.topic)then
		recvTbl = common.StrToTable(msg)		
		tradeName=recvTbl.name
		tradeBagSpace=recvTbl.pets
		tradePlayerLine=recvTbl.line
	else
		等待(5000)		--给内部时间  去接收收到的信息
		goto begin
	end	
	--日志(tradeName.." "..tradeBagSpace .." " ..tradePlayerLine)
	if(tradePlayerLine ~= nil and tradePlayerLine ~= 0 and tradePlayerLine ~= 人物("几线"))then
		切换登录信息("","",tradePlayerLine,"")
		登出服务器()
		等待(3000)			
		goto begin
	end	
	if(tradeName ~= nil and tradeBagSpace ~= nil)then	
		if(取当前地图编号() ~= 1121)then			
			common.gotoFalanBankTalkNpc()		
		end	
		tradex=nil
		tradey=nil
		units = 取周围信息()
		if(units ~= nil)then
			for i,u in pairs(units) do
				if(u.unit_name==tradeName)then
					tradex=u.x
					tradey=u.y
					break
				end
			end
		else
			goto begin
		end
		if(tradex ~=nil and tradey ~= nil)then
			移动到目标附近(tradex,tradey)
		else
			goto begin
		end
		转向坐标(tradex,tradey)			
		local pets = 全部宠物信息()
		tradeList="金币:20;宠物:"
		hasData=false
		selfTradeCount=0
		for i,v in pairs(pets) do
			if(v.realname == args.petName and v.level==1)then					
				if(selfTradeCount >= tradeBagSpace)then
					break
				end		
				selfTradeCount=selfTradeCount+1
				hasData=true				
			end
		end	
		tradeList = tradeList..args.petName.."|"..selfTradeCount			
		
		日志(tradeList)
		if(hasData)then
			交易(tradeName,tradeList,"",10000)
		else	
			--设置("timer",100)
			--下次说不定是哪个仓库 设置为nil
			tradeName=nil
			tradeBagSpace=nil
			tradePlayerLine=nil	
			--回城()
			return
		end
		tryNum=tryNum+1	
	end
	goto begin
end
--检查是否有某称号
function common.checkTitle(dstTitle)
	local player=人物信息()
	for i,title in ipairs(player.titles) do
		if(title.name == dstTitle)then
			return true
		end
	end
	return false
end
--秒转日期格式
function common.secondsToTime(ts)
    local seconds = math.fmod(ts, 60)
    local min = math.floor(ts/60)
    local hour = math.floor(min/60) 
    local day = math.floor(hour/24)    
    local str = ""        
    if tonumber(seconds) > 0 and tonumber(seconds) < 60 then
        str = ""..seconds.."秒" ..str
    end
    if tonumber(min - hour*60)>0 and tonumber(min - hour*60)<60 then
        str = ""..(min - hour*60).."分"..str
    end
    if tonumber(hour - day*24)>0 and tonumber(hour - day*60)<24 then
        str = (hour - day*24).."时"..str
    end    
    if tonumber(day) > 0 then
        str = day.."天"..str
    end
    return str
end
--获取身上指定宠物数量
function common.getTgtPetCount(tgtPetName)
	if tgtPetName==nil then return 0 end
	local newPetList = 全部宠物信息()
	local petCount=0
	for i,n in ipairs(newPetList) do	
		if(n.realname == tgtPetName)then
			petCount=petCount+1
		end		
	end		
	return petCount
end

--哥拉尔检查封印卡 需要定居哥拉尔 不在哥拉尔 会回城
function common.gleCheckSaelCard(cardName,cardCount)
	local mapName = ""
	local mapNum = 0
	local tryCount=0
	if(取物品叠加数量(cardName) < cardCount)then 	
		goto begin 
	else
		return
	end	
::begin::
	mapName = 取当前地图名()
	mapNum = 取当前地图编号()
	if(mapName == "哥拉尔镇")then 
		自动寻路(146, 117,"魔法店")		
		自动寻路(18, 12)	
		转向(2, "")
		等待服务器返回()
		return common.buyDstItem(cardName,cardCount)			
	else
		if(tryCount >= 3)then
			日志("此接口需要定居哥拉尔，或者在哥拉尔镇执行此函数!",1)
			return
		end
		tryCount=tryCount+1
		回城()
		等待(2000)
	end
	goto begin
end

--城堡卖魔石 卡片等
function common.gleSellItems(saleItems)
	local saleList=
	{
		"魔石","锥形水晶","卡片？","锹型虫的卡片","水晶怪的卡片","哥布林的卡片","红帽哥布林的卡片","迷你蝙蝠的卡片","绿色口臭鬼的卡片","锥形水晶"
	}
	--不判断是否有重复名称了  这里直接合并一个表
	if(saleItems ~= nil)then
		if(type(saleItems) == "string")then
			table.insert(saleList,saleItems)
		elseif(type(saleItems) == "table")then		
			for i,item in ipairs(saleItems) do
				table.insert(saleList, item)
			end
		end		
	end
	local needSale=false
	for i,item in ipairs(saleList)do
		if(取物品数量(item) > 0) then
			needSale = true
			break
		end
	end
	if(needSale == false)then return end
::begin::	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="艾尔莎岛" )then			
		自动寻路(140,105)				
		转向(1)
		等待服务器返回()
		对话选择(4,0)		
		goto liBao
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao	
	elseif (当前地图名=="工房" )then	
		goto gongFang
	elseif (当前地图名=="召唤之间" )then	--登出 bank
		自动寻路( 3, 7)	
		等待到指定地图("里谢里雅堡")	
		goto liBao	
	elseif (当前地图名=="哥拉尔镇" )then	--登出 bank
		自动寻路(146, 117,"魔法店")			
		goto 哥拉尔魔法店
	end	
	回城()
	等待(2000)
	goto begin
::liBao::		
	if(取当前地图名() ~= "里谢里雅堡")then
		等待(2000)
		goto begin
	end
	自动寻路(31,77)		
	for i,item in ipairs(saleList)do
		if(取物品数量(item) > 0) then
			卖(6,item)
		end
	end    
	for i,item in ipairs(saleList)do
		if(取物品数量(item) > 0) then
			卖(6,item)
		end
	end 
	goto goEnd
::gongFang::
	if(是否目标附近(21,23,1)==true) then
		for i,item in ipairs(saleList)do
			if(取物品数量(item) > 0) then
				卖(21,23,item)
			end
		end    
		for i,item in ipairs(saleList)do
			if(取物品数量(item) > 0) then
				卖(21,23,item)
			end
		end  
	end
	goto goEnd
::哥拉尔魔法店::
	自动寻路(18, 12)	
	for i,item in ipairs(saleList)do
		if(取物品数量(item) > 0) then
			卖(2,item)
		end
	end    
	for i,item in ipairs(saleList)do
		if(取物品数量(item) > 0) then
			卖(2,item)
		end
	end  
::goEnd::
	return
end
function common.gleGotoBankTalkNpc()
	
::begin::	
	等待空闲()
	local 当前地图名 = 取当前地图名()
	if (当前地图名=="哥拉尔镇" )then	--登出 bank
		自动寻路(167,66,"银行")	
		goto bank		
	end	
	回城()
	等待(2000)
	goto begin
::bank::
	自动寻路(25,10)
	转向(2)
	等待(2000)		
end
--检查人物金币 不足去拿 
--minGold人物最少金币 少于此值去银行拿钱
--maxGold人物最多金币 大于此值去银行存钱
--bagGold人物身上取钱和存钱保留的钱数 取钱后身上有这么多钱 存钱后身上有这么多钱
--值设定时候不要给错，满足minGold < bagGold < maxGold
function common.gleCheckGold(minGold,maxGold,bagGold)
	if(minGold==nil or maxGold ==nil or bagGold == nil)then return end
	local oldGold=人物("金币")
	if(oldGold < minGold)then
		日志("人物现有金币【"..oldGold.."】小于设定的最少值【"..minGold.."】,去银行取钱",1)
		common.gleGotoBankTalkNpc()
		银行("取钱",-bagGold)
		等待(1000)
		local nowGold=人物("金币")
		if(nowGold ~= oldGold)then
			日志("取钱成功，现有金币："..nowGold)
		end
	elseif(oldGold > maxGold)then
		日志("人物现有金币【"..oldGold.."】大于设定的最大值【"..maxGold.."】,去银行存钱",1)
		common.gleGotoBankTalkNpc()
		银行("存钱",-bagGold)
		等待(1000)
		local nowGold=人物("金币")
		if(nowGold == oldGold)then	--银行满了 存少点
			日志("银行金币满了，尝试存部分金币")
			local bankGold = 银行("金币")
			if(bagGold > 1000000)then	
				银行("存钱",10000000-bankGold)
			else
				银行("存钱",1000000-bankGold)
			end
			等待(1000)
			nowGold=人物("金币")
			if(nowGold ~= oldGold)then	
				日志("存钱成功，现有金币："..nowGold)
			end
		else
			日志("存钱成功，现有金币："..nowGold)
		end
	end
end
function common.等待黄昏或夜晚()
	local mapName=取当前地图名()
	local mapNum=取当前地图编号()
	if(游戏时间() == "夜晚" or 游戏时间() == "黄昏")then		
		return true
	else
		while true do 
			if(游戏时间() ~= "夜晚" and 游戏时间() ~= "黄昏")then		
				日志("当前时间是【"..游戏时间().."】，等待黄昏或夜晚")
				等待(30000)		
			elseif(取当前地图编号() ~= mapNum)then
				return false
			else						
				return true
			end		
		end		
	end
	return false
end
return common