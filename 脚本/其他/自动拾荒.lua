★定居艾岛；支持法兰，可设置自动更换装备；自己设置丢不要的卡，新城支持存宝石鼠铜奖，银行满以后丢弃★坐标180秒未变重启	★脚本联系：风星落-QQ:274100927

common=require("common")

设置("timer",0)
设置("自动捡",1)
设置("跟随捡物",1)
设置("自动捡",1,"金币")
设置("自动捡",1,"小护士家庭号")
设置("自动捡",1,"魔力之泉")
设置("自动捡",1,"火焰鼠闪卡「D4奖」")
设置("自动捡",1,"火焰鼠闪卡「C4奖」")
设置("自动捡",1,"火焰鼠闪卡「D2奖」")
设置("自动叠",1,"小护士家庭号&10")
设置("自动叠",1,"魔力之泉&10")
设置("自动扔",1,"如月沙罗戒|苹果薄荷|宝石鼠残念奖|味噌汤|印度轻木|铜")
设置("自动扔",1,"如月沙罗戒")

local 卖店物品列表="魔石|卡片？|丘比特的卡片|水蓝鼠的卡片|猫熊的卡片|火精的卡片|风精的卡片|水精的卡片|地精的卡片|丸子炸弹的卡片|黄金树精的卡片|使魔的卡片|小蝙蝠的卡片"		--可以增加多个 不影响速度
local 捡物列表={"小护士家庭号","火焰鼠闪卡「C1奖」"
	,"火焰鼠闪卡「C2奖」","火焰鼠闪卡「C3奖」","火焰鼠闪卡「C4奖」","火焰鼠闪卡「D1奖」","火焰鼠闪卡「D2奖」",
	"火焰鼠闪卡「D3奖」","火焰鼠闪卡「D4奖」","宝石鼠铜奖","宝石鼠银奖","宝石鼠金奖","魔力之泉","火焰鼠闪卡「B1奖」",
	"火焰鼠闪卡「B2奖」","火焰鼠闪卡「B3奖」","火焰鼠闪卡「B4奖」","火焰鼠闪卡「A4奖」","火焰鼠闪卡「A3奖」",
	"火焰鼠闪卡「A2奖」","火焰鼠闪卡「A1奖」","宝石鼠月亮奖","宝石鼠钻石奖","海洋之心","火焰之魂","天空之枪",
	"帕鲁凯斯之斧","村正","鼠王","金币","纯白吓人箱Ⅱ设计图B","纯白吓人箱Ⅱ设计图A","纯白吓人箱Ⅱ设计图C","兔耳吓人箱Ⅱ设计图B","兔耳吓人箱Ⅱ设计图A","兔耳吓人箱Ⅱ设计图C","纯白吓人箱设计图A","纯白吓人箱设计图B","纯白吓人箱设计图C","纯白吓人箱设计图D","飞行券","黄金树精的卡片","使魔的卡片","小蝙蝠的卡片"}
local 奖券列表={"火焰鼠闪卡「C1奖」"
	,"火焰鼠闪卡「C2奖」","火焰鼠闪卡「C3奖」","火焰鼠闪卡「C4奖」","火焰鼠闪卡「D1奖」","火焰鼠闪卡「D2奖」",
	"火焰鼠闪卡「D3奖」","火焰鼠闪卡「D4奖」","宝石鼠铜奖","宝石鼠银奖","宝石鼠金奖","火焰鼠闪卡「B1奖」",
	"火焰鼠闪卡「B2奖」","火焰鼠闪卡「B3奖」","火焰鼠闪卡「B4奖」","火焰鼠闪卡「A4奖」","火焰鼠闪卡「A3奖」",
	"火焰鼠闪卡「A2奖」","火焰鼠闪卡「A1奖」","宝石鼠月亮奖","宝石鼠钻石奖"}

local quickSearch=""
local lotteryTicket=""
local 预设包裹空格=2
local 左右角色=0
local 游戏id=""
local 切换角色= false
function LuaTblSplitStr(tbl)
	if(tbl == nil)then return "" end
	local transText=""
	for i,v in ipairs(tbl) do
		transText=transText.."|"..v
	end
	return transText
end

function 捡周边物品()
	local items=取周围信息()
	if(items == nil)then return end
	if(取当前地图名() == "第一道场")then
		for i,v in pairs(items) do
			if(取包裹空格() < 1)then break end
			if(v.valid and v.model_id ~= 0 and (v.flags & 4096)==0 and (v.flags & 256)==0 )then
				if(string.find(quickSearch,v.item_name)~= nil)then
					if(v.x ==16 and v.y==10)then
						
					else
						移动到目标附近(v.x,v.y)
						转向坐标(v.x,v.y)
					end
				end
			end	
		end
	else
		for i,v in pairs(items) do
			if(取包裹空格() < 1)then break end
			if(v.valid and v.model_id ~= 0 and (v.flags & 4096)==0 and (v.flags & 256)==0 )then
				if(string.find(quickSearch,v.item_name)~= nil)then
					移动到目标附近(v.x,v.y)
					转向坐标(v.x,v.y)
				end
			end	
		end
	end
	
	
	if(换道具())then 
		回城() 		
	end	
end

function 换道具()
	if(取包裹空格() > 预设包裹空格)then return false end
	if(取当前地图名() ~= "魔力宝贝服务中心")then 
		common.gotoFaLanCity("e2")
		自动寻路(241,78)
		转向(0)
		等待到指定地图("魔力宝贝服务中心")	
	end	
	local tDlg=nil
	local tryCount=0
	while true do
		if(取包裹空格() < 1)then break end
		自动寻路(20,29)	 	
		转向坐标(22,29)
		tDlg = 等待服务器返回()
		if(string.find(tDlg.message,"恭喜你中奖")~=nil)then
			--对话选是(21,29)	
			对话选择(4,0)
			等待服务器返回()
			对话选择(1,0)
		else
			tryCount = tryCount+1
		end
		if(tryCount >= 3)then break end
	end	
	使用物品("水晶加工装置")
	等待(2000)
	if(取包裹空格() < 1)then
		common.gotoBankTalkNpc()
		银行("全存")
		等待(2000)
		if(取包裹空格() < 1)then
			日志("换号",1)			
			重置登录状态()
			设置登录子账号(游戏id)
			左右角色=左右角色+1
			if(左右角色 > 1)then	--左右都已获取仓库 去下一个						
				切换角色 = true
				return true
			end
			设置登录角色(左右角色)	--左边	
			登出服务器()				
		end
	end
	common.sellFaLanPile(卖店物品列表)
	return true
end

--切换游戏账号部分
function tableSize(data)
	count = 0  
	for k,v in pairs(data) do  
		count = count + 1  
	end  
	return count
end
function 登录游戏id(游戏id)
	左右角色=0
	
::begin::
	等待空闲()
	mapName=取当前地图名()
	if(换道具())then 
		回城() 		
	end	
	if(切换角色) then 
		切换角色 = false	
		
		return 
	end
	if(mapName == "艾尔莎岛")then
		捡周边物品()
		自动寻路(140,105)
		转向(1)
		等待服务器返回()
		对话选择(4,0)
	elseif(mapName == "召唤之间")then	
		自动寻路(3,9)
		对话选是(4,9)
		common.gotoFaLanCity()		
		goto 法兰城
	elseif(mapName == "魔力宝贝服务中心")then	
		换道具()
		回城() 				
	elseif(mapName == "里谢里雅堡")then	
		自动寻路(29,84)
		捡周边物品()
		common.gotoFaLanCity()		
		goto 法兰城
	elseif(mapName == "百人道场大厅")then
		goto 百人大厅	
	elseif(mapName == "法兰城")then
		common.gotoFaLanCity("s1")		
		goto 法兰城
	else
		回城()
	end
	等待(2000)
	goto begin
::法兰城::
	自动寻路(124, 161)
	转向(6)
	等待到指定地图("竞技场的入口", 15,23)	
	自动寻路(26,15)
	等待到指定地图("竞技场的入口", 26,15)
	移动一格(2)
	等待到指定地图("治愈的广场", 5,32)	
::治愈广场::
	自动寻路(25,28)	
	转向(2)
	等待服务器返回()	
	对话选择(4,0)
	等待服务器返回()	
	对话选择(1, 0)
::百人大厅::
	等待到指定地图("百人道场大厅")			
	自动寻路(15,23)
	捡周边物品()	
	if(取当前地图名() == "百人道场大厅")then
		自动寻路(15,23)
		对话选是(17,23)
		自动寻路(12,10)
		捡周边物品()	
		回城()
	end
	goto begin
end
function main()
	quickSearch=LuaTblSplitStr(捡物列表)	--快速查询用
	lotteryTicket=LuaTblSplitStr(奖券列表)	--快速查询用
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
	readFileMsg = common.ReadFileData("自动拾荒仓库信息.txt")
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
			重置登录状态()
			设置登录子账号(v)			
			设置登录角色(0)		--左边	
			登出服务器()	
			登录游戏id(v)
			common.WriteFileData("自动拾荒仓库信息.txt",tonumber(string.sub(人物("gid"),-3)))			
		end
	end  
	--获取完成 退出
	return	
end

main()