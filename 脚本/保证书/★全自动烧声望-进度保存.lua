刷称号脚本，人物要能单独打卵4长老的，一般120攻人攻宠都能达标，此脚本会自动做卵4任务，前置1 3需要自己做好，后续称号每次转职后，会差好几级，这里用玩家称号记录上次进度，默认以此为记录，身上需要有传教和咒术推荐信
     
common=require("common")

设置("高速延时",0)  
设置("高速战斗",1)  
设置("自动战斗",1)  
设置("遇敌速度",20)  
设置("不带宠二动",1)  
设置("二动防御",1)  

local 脚本启动时间=os.date("%Y-%m-%d %H:%M:%S",os.time())
local 脚本启动秒数=os.time()
local 刷声望前时间=os.time() 
local 刷声望回补总计=0
local 刷声望前金币=人物("金币")

local 刷之前称号=人物("称号")
local 刷之前声望进度=nil

local 目标称号数据=nil
local 不达标多刷金币=10000	--刷到指定金币 但称号未达到 多刷的金币数
local 多刷次数=0		--每次多刷1万金币 最多3次
local 不达标多刷金币倍数=1
local 任务步骤=1
local 是否缓存任务中=false  --缓存保证书任务中途-天亮 中断用
local 刷称号阶段=1
local 指定初始称号列表={ "恶人",
			"忌讳的人",
			"受挫折的人",
			"无名的旅人",
			"路旁的落叶",
			"水面上的小草",
			"呢喃的歌声",
			"地上的月影",
			"奔跑的春风",
			"苍之风云",
			"摇曳的金星",
			"欢喜的慈雨",
			"蕴含的太阳",
			"敬畏的寂静",
			"无尽星空",
			"迈步前进者",
			"追求技巧的人",
			"刻于新月之铭",
			"掌上的明珠",
			"敬虔的技巧",
			"踏入神的领域",
			"贤者",
			"神匠",
			"摘星的技巧",
			"万物创造者",
			"持石之贤者" }

local target={}
function 统计消耗(beginTime)	
	local nowTime = os.time() 
	local time = math.floor((nowTime - beginTime)/60)--已持续时间
	if(time == 0)then
		time=1
	end	
	刷声望回补总计 = 刷声望回补总计+1	
	local nowGold=人物("金币")
	if(nowGold == nil or nowGold <= 0)then
		日志("获取金币失败"..nowGold)
	end
	local usedGold = 刷声望前金币 - nowGold
	日志("第【"..刷声望回补总计.."】轮回补,已持续【"..time.."】分钟，总计消耗【"..usedGold.."】金币")
	保存声望进度()
end

--通过金币判断 再去阿蒙和医院那二次确认
function 判断称号()
	if(目标称号数据 == nil) then return false end
	local nowGold=人物("金币")
	if(nowGold == nil or nowGold <= 0)then
		return false
	end
	保存声望进度()
	local usedGold = (刷声望前金币 - 人物("金币"))
	if(usedGold >= 目标称号数据.gold) then
		日志("已消耗:"..usedGold.." 金币，达到下级声望所需金币，去领取称号")
		return true
	end
	--日志("还需消耗:"..(目标称号数据.gold-usedGold).." 金币")
	return false
end

function 称号进度(msg)
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

function 步骤1()
::begin::
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
			return
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
	任务步骤= 任务步骤+1
	回城()
end

function 对战长老(target)
	移动到目标附近(target.x,target.y)
	设置("遇敌全跑",0)	
	等待空闲()
	local eroCount=0
::begin::	
	-- x,y=取当前坐标()	
	-- if(x ~= target.x and y ~= target.y)then
		-- 移动到目标附近(target.x,target.y)
	-- end
	转向坐标(target.x,target.y)	
	local dlg=等待服务器返回()
	if(dlg ~= nil ) then
		if(string.find(dlg.message,"回头见啰") ~= nil) then	
			return false--查找下一个长老
		end
	else
		eroCount=eroCount+1
		if(eroCount >= 3)then
			日志("对话长老错误，返回")
			return false
		end
		goto begin
	end
	对话选择(1,0)
	等待(3000)
	if(是否战斗中() ) then		
		goto loopBattle			
	end
	if(string.find(取当前地图名(),"海底墓场外苑")==nil) then --迷宫刷新 返回
		return false
	end			
	goto begin
::loopBattle::
	if(取物品叠加数量("长老之证")>=7 or string.find(聊天(50),"长老之证够了")~=nil)then
		日志("长老之证齐了")				
		return true
	elseif(取包裹空格()< 1 and 取物品叠加数量("长老之证")<7)then
		日志("包裹满了")
		goto bagFull
	end 		
	if(string.find(取当前地图名(),"海底墓场外苑")==nil)then --迷宫刷新 返回
		return false
	end			
	对话选择(1,0)
	等待(1000)		
	goto loopBattle
::bagFull::
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
	return false   --不打这个了 重新找新的
end
--没有处理多个长老情况
function 开始找人()
	设置("遇敌全跑",1)
	local itemfull=false
::beFind::
	if(是否空闲中()==false)then
		等待(2000)
		goto beFind
	end		
	if(string.find(取当前地图名(),"海底墓场外苑")==nil)then --错误 返回
		return false
	end
	找到,target.x,target.y,nextX,nextY=搜索地图("守墓员",1)
	if(找到) then		
		移动到目标附近(target.x,target.y)
		对战长老(target)
	end	
	if(取物品叠加数量("长老之证")>=7) then
		return 
	end	
	自动寻路(nextX,nextY)	--下一层
	等待(2000)
	goto beFind
end
function outMaze()
::穿越迷宫::
	等待空闲()
	当前地图名 = 取当前地图名()
	if(当前地图名=="？？？") then
		goto goEnd
	end
	if (string.find(当前地图名,"海底墓场外苑")==nil)then
		--不知道哪 返回
		return
	end
	自动迷宫(1)
	等待(1000)
	goto 穿越迷宫
::goEnd::
	return
end
function 步骤2()
	等待空闲()	
	local outMazeX,outMazeY
	local outMapName
::begin::
	if(取当前地图名() == "？？？") then
		goto shua
	end
	if(string.find(取当前地图名(),"海底墓场外苑")~=nil)then
		goto shua
	end
	common.supplyCastle()
	common.checkHealth()
	common.sellCastle()
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	设置("遇敌全跑",1)
	自动寻路(130, 50, "盖雷布伦森林")	
	自动寻路(246, 76, "路路耶博士的家")	
	等待(2000)
	自动寻路(3,10,"？？？")
	设置("遇敌全跑",0)		
	自动寻路(132, 62)
::shua::
	while true do
		等待空闲()	
		if(取当前地图名() == "？？？") then
			自动寻路(122, 69,"海底墓场外苑第1地带")
			日志("开始找守墓员")				
		elseif(string.find(取当前地图名(),"海底墓场外苑")~=nil)then
			outMazeX,outMazeY=取当前坐标()
			outMapName=取当前地图名()
			开始找人()
			if(取物品叠加数量("长老之证")>=7 or string.find(聊天(50),"长老之证够了")~=nil)then
				设置("遇敌全跑",1)				
				break
			end
		elseif(取当前地图名() == "路路耶博士的家") then
			自动寻路(3,10,"？？？")
		elseif(取当前地图名() == "盖雷布伦森林") then
			任务步骤= 1
			回城()
			return		
		else
			日志("地图信息错误"..取当前地图名())
			return
		end
	end
	goto outMaze
::outMaze::	
	等待空闲()	
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
			return
		end
		自动迷宫(1)
		等待(1000)
	end
	goto outMaze
::mapJudge::
	if(取当前地图名() == "？？？" and 取物品叠加数量("长老之证")>=7) then		
		自动寻路(131,61)
		if(是否目标附近(131,60))then			
			对话选是(131,60)			
		end
	else
		goto begin
	end
	if(取当前地图名() == "盖雷布伦森林") then
		任务步骤= 任务步骤+1
		回城()
		return
	end	
	等待(1000)
	goto mapJudge
end

function 步骤3()

::begin::
	等待空闲()	
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	自动寻路(201,96,"神殿　伽蓝")	
	自动寻路(91, 138)		
	while true do 
		--npc=查周围信息("荷特普",1)
		转向坐标(92,138)
		dlg=等待服务器返回()
		if(dlg ~= nil and string.find(dlg.message,"最近每天晚上都会到北边的荒野去喔？")~= nil) then
			对话选是(92,138)
			break
		else
			日志("当前时间是【"..游戏时间().."】，等待黄昏或夜晚【荷特普】出现")
			if(是否缓存任务中)then
				日志("当前时间是【"..游戏时间().."】，当前是缓存保证书进度中，停止缓存，先刷声望")
				任务步骤=100
				return
			end
			等待(30000)
		end	
		if(取当前地图名() ~= "神殿　伽蓝")then goto begin end
	end		
	任务步骤= 任务步骤+1
	回城()
end

function 打障碍物()
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
function 步骤4()
::begin::
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
			return false
		end	
	else
		if(取当前地图名() == "梅布尔隘地")then goto mbead end	
		mapNum=取当前地图编号()
		if(mapNum == 59714)then goto map59714 end	
		if(mapNum == 59716)then goto map59716 end	
	end
	common.supplyCastle()
	common.checkHealth()
	common.sellCastle()
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		等待空闲()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	设置("遇敌全跑",1)
	自动寻路(165, 153)
	对话选否(4)
	等待(2000)
::mbead::
	if(取当前地图名() ~= "梅布尔隘地")then goto begin end	
	自动寻路(212, 116)
	自动寻路(211, 117)
	对话选是(212,116)
::map59714::
	if(取当前地图名() ~= "？？？")then goto mbead end  --回退上一地图	
	自动寻路(134,197)
	自动寻路(135,197)
	方向穿墙(2,8)
	自动寻路(156, 197,59714)
	设置("遇敌全跑",0)
	打障碍物()	
	自动寻路(163, 107)
	方向穿墙(4,8)
	自动寻路(242,117, 59716)
::map59716::
	自动寻路(221, 188)
	转向(2)
	等待服务器返回()
	对话选择(32,0)
	等待服务器返回()
	对话选择(32,0)
	等待服务器返回()
	对话选择(32,0)
	等待服务器返回()
	对话选择(32,0)
	等待服务器返回()
	对话选择(32,0)
	等待服务器返回()
	对话选择(32,0)
	等待服务器返回()
	对话选择(8,0)
	等待服务器返回()
	对话选择(1,0)
	--对话选否(222,188)	
	等待(500)
	if(是否战斗中) then 
		等待(2000)
		回城() 
	else
		goto map59716
	end
	任务步骤= 任务步骤+1	
end

function 步骤5()
	等待空闲()		
	if(取物品数量("觉醒的文言抄本") < 1)then
		日志("身上没有【觉醒的文言抄本】，请先准备好道具再去换【保证书】")
		return
	end
	if(取物品数量("转职保证书") > 0)then
		日志("身上已经有一本【保证书】，请先使用后再去换保证书")
		任务步骤= 任务步骤+1	
		return
	end
	if(取当前地图名()~="艾尔莎岛")then 
		回城()
		if(取当前地图名()~="艾尔莎岛")then 
			日志("必须先定居新城【艾尔莎岛】")
			return
		end
	end
	设置("遇敌全跑",1)
	自动寻路(130, 50, "盖雷布伦森林")	
	自动寻路(244, 74)	
	对话选是(245,73)
	if(取物品数量("转职保证书") > 0)then
		日志("恭喜你！获得了【转职保证书】")		
	end
	任务步骤= 任务步骤+1	
end

function 卵4()
	宠物("改状态","战斗",5)		--0-4 宠位置 5最高等级宠 6最低等级宠
	设置("移动速度",120)
	设置("自动叠",1,"长老之证&3")
	任务步骤=1
	读取配置("./配置/保证书.save")
	while true do	
		if(任务步骤==1)then
			步骤1()
		elseif(任务步骤==2)then
			步骤2()
		elseif(任务步骤==3)then
			步骤3()
		elseif(任务步骤==4)then
			步骤4()	
		elseif(任务步骤==5)then
			步骤5()	
		elseif(任务步骤==100)then
			日志("中断缓存保证书任务，先刷称号")
			设置("移动速度",100)
			break
		elseif(任务步骤>=6)then
			日志("任务已完成")
			设置("移动速度",100)
			break			
		end
	end
	return 任务步骤
end
function 去转咒术()	
	if(取物品数量("咒术师推荐信") < 1 )then
		执行脚本("脚本/就职/★就职-咒术.lua")--去拿咒术推荐信()
	end	
	if(取物品数量("咒术师推荐信") < 1 )then
		日志("没有咒术推荐信，转职失败！")
		return
	end	
	tryNum=0
::start::
	设置("遇敌全跑",1)
	回城()	
	等待到指定地图("艾尔莎岛")        
	转向(1)
	等待服务器返回()
	对话选择(4,0)
	等待(2000)		
	等待空闲()
	if (取当前地图名()=="艾尔莎岛" )then	
		goto start
	end	
	等待(1000)		
	自动寻路(34,89)
	回复(1)			-- 转向北边恢复人宠血魔
    自动寻路(41, 80)
    --    if(取物品数量( "咒术师推荐信") >  0)then goto  jidi end      
::jidi::
	自动寻路(41, 50,"里谢里雅堡 1楼")	
	自动寻路(45, 20,"启程之间")
	自动寻路(15, 4)	
	转向(2, "")
	等待服务器返回()
	对话选择("4", 0)
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
	自动寻路(10, 0,15008)
	自动寻路(10, 0)
	对话选是(2)
	等待到指定地图("15012")	
::zhuanZhi::
	自动寻路(10, 10)		
	等待(1000)	
	if(取物品数量("转职保证书") < 1)then
		日志("没有转职保证书，转职失败，返回！")
		return
	end
	转向(2)
	等待服务器返回()
	对话选择(0,1)
	等待服务器返回()
	对话选择(32,-1)
	等待服务器返回()
	对话选择(0,0)
	等待(5000)
	if(人物("职业") == "咒术师")then
		日志("转职咒术成功！")		
	else	
		if(tryNum > 3)then 
			日志("多次尝试转职失败，请手动查看原因")
			return 
		end
		tryNum=tryNum+1
		goto start		
	end
	设置("遇敌全跑",0)
end


function 去转传教()
	tryNum=0
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
	等待(2000)				
	等待空闲()
	if (取当前地图名()=="艾尔莎岛" )then	
		goto begin
	end
::liBao::
	等待到指定地图("里谢里雅堡")
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
	if(取物品数量("转职保证书") < 1)then
		日志("没有转职保证书，转职失败，返回！")
		return
	end
	转向(1)
	等待服务器返回()
	对话选择(0,1)
	等待服务器返回()
	对话选择(32,-1)
	等待服务器返回()
	对话选择(0,0)
	等待(2000)
	if(人物("职业") == "传教士")then
		日志("转职传教成功！")
	else		
		if(tryNum > 3)then 
			日志("多次尝试转职失败，请手动查看原因")
			return 
		end
		tryNum=tryNum+1
		goto begin
	end
end

function 继续保证书()
	日志("当前正在卵4，继续做两次任务，预留两张转职保证书",1)

::begin::		
	if(游戏时间() ~= "黄昏" and 游戏时间() ~= "夜晚")then
		日志("当前时间是【"..游戏时间().."】，返回继续刷称号，等下次缓存！")
		return
	end
	if(取物品数量("转职保证书") < 1)then		
		日志("身上没有转职保证书，去做第一次缓存保证书任务！")		
		卵4()	
		if(任务步骤==100)then	--游戏时间变更 退出缓存
			日志("游戏时间变更,退出第一次缓存保证书，继续刷称号!")
			return
		end
		if(取物品数量("转职保证书") < 1)then
			日志("缓存保证书任务失败，请查看失败原因")
		end
		goto begin
	else
		日志("身上已缓存一张转职保证书，去做第二次缓存保证书任务！")	
		卵4()	
		if(任务步骤==100)then	--游戏时间变更 退出缓存
			日志("游戏时间变更,退出第二次缓存保证书，继续刷称号!")
			return
		end
		日志("缓存保证书任务完成，继续刷称号!")
	end	
end
--判断是否有保证书
function 去转职()
	日志("当前去转职，现称号:"..人物("称号").." 现职业:"..人物("职业"))
	local isMission=false
	是否缓存任务中=false
::begin::
	if(取物品数量("转职保证书") < 1)then
		日志("没有转职保证书，去领取看有没有缓存一张！")	
		步骤5()
	end
	if(取物品数量("转职保证书") < 1)then		
		日志("没有转职保证书，去做任务！")		
		卵4()	
		isMission=true
		if(取物品数量("转职保证书") < 1)then
			日志("卵4任务失败，请查看失败原因")
		end
		goto begin
	end	
	if(人物("职业") == "传教士")then
		去转咒术()
	elseif(人物("职业") == "咒术师")then
		去转传教()
	end
	日志("转完信息，现称号:"..人物("称号").." 现职业:"..人物("职业"))
	if(isMission)then	--如果正在做卵4  继续做两次 预留2张转职保证书
		是否缓存任务中=true
		继续保证书()
	end
	根据职业加载配置()
end

function 称号提交获取()
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()	
	if (当前地图名=="艾尔莎岛" )then	
		goto erDao	
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao	
	elseif (当前地图名=="法兰城" )then	
		goto faLanBank		
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
	等待(2000)		
	等待空闲()
	if (取当前地图名()=="艾尔莎岛" )then	
		goto begin
	end
::liBao::
	自动寻路(41,98)	
	等待到指定地图("法兰城")	
	自动寻路(162, 130)	
	goto faLan	
::faLan::
	if(取当前地图名() ~= "法兰城")then
		goto begin
	end
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
	goto begin
::faLanBank::		
	等待到指定地图("法兰城")	
	自动寻路(230,84)
	title = 人物("称号")
	转向(0)
	转向(0)
	等待(2000)	--等系统刷新
	当前时间=os.date("%Y-%m-%d %H:%M:%S")
	刷之前称号 = 人物("称号")
	if(title == 刷之前称号)then
		日志(当前时间.." 未获得新称号，当前人物称号为【"..刷之前称号.."】",1)
	else
		日志(当前时间.." 获得新称号【"..刷之前称号.."】",1)
	end
	设置("人物称号",刷之前称号)
	自动寻路(235,107)
	转向(4)
	dlg = 等待服务器返回()
	if(dlg ~= nil)then
		range = 称号进度(dlg.message)
	else
		range=-1
		日志("称号对话框返回nil")
	end
	
	日志(当前时间.." 当前人物称号进度为【"..range.."/4】",1)
	刷之前声望进度=range	
	刷声望前时间=os.time() 
	刷声望回补总计=0
	刷声望前金币=人物("金币")

	目标称号数据=下级称号数据(人物("称号"),刷之前声望进度)
	if(目标称号数据 ~= nil) then		
		目标称号数据.gold = 目标称号数据.gold*不达标多刷金币倍数
		if(目标称号数据.gold > 400000)then
			日志("计算下级消耗金币数量错误，请查看",1)
			return 2
		end
		日志("下级称号数据 金币："..目标称号数据.gold.." 下级称号:"..目标称号数据.title.." 分钟:"..目标称号数据.time.." 等级:"..目标称号数据.grade.." 需要次数:"..目标称号数据.count)		
		if(人物("金币") < 目标称号数据.gold) then
			日志("人物金币不够刷到下个称号，去银行取钱，当前金币【"..人物("金币").."】")
			common.getMoneyFromBank(目标称号数据.gold)
		end
		if(人物("金币") < 目标称号数据.gold) then
			日志("人物金币不够刷到下个称号，银行也没有钱了，退出")	
			return -1
		end
	end
		
    goto goEnd 
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
::goEnd::
	return 0
	
end
-- 0继续刷下级称号 
-- 1初始获取的下级称号数据有误 退出
-- 2没有达到下级称号 多刷一会
-- 3已到最终称号
function 称号提交二次判断()		
	if(目标称号数据 == nil) then		
		日志("下级称号数据有误，二次判断失败！")
		return 1
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
	等待(2000)		
	等待空闲()
	if (取当前地图名()=="艾尔莎岛" )then	
		goto begin
	end
::liBao::
	自动寻路(41,98)	
	等待到指定地图("法兰城")	
	自动寻路(162, 130)	
	goto faLan	
::faLan::
	x,y=取当前坐标()	
	if(取当前地图名() ~= "法兰城")then 
		goto begin 
	elseif (x==72 and y==123 )then	-- 西2登录点
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
	goto begin
::faLanBank::		
	等待到指定地图("法兰城")	
	自动寻路(230,84)
	title = 人物("称号")
	转向(0)
	转向(0)
	等待(2000)	--等系统刷新	
	nowTitle =人物("称号")
	if(刷之前称号 == nowTitle)then
		日志("未获得新称号，当前人物称号为【"..nowTitle.."】",1)
	else
		日志("获得新称号【"..nowTitle.."】",1)
	end
	设置("人物称号",nowTitle)
	if(nowTitle == "无尽星空" or nowTitle == "敬畏的寂静")then
		日志("已达最终称号，退出！")
		return 3
	end
	自动寻路(235,107)
	转向(4)
	dlg = 等待服务器返回()
	if(dlg == nil)then
		日志("称号对话框返回nil")
		curGrade=-1
	else
		curGrade = 称号进度(dlg.message)	
	end
	
	日志(" 二次判断,当前人物称号进度为【"..curGrade.."/4】",1)
	if(目标称号数据.title ~= nowTitle ) then		--and curGrade < 目标称号数据.grade
		if(多刷次数 >= 3)then
			日志("未到目标称号，已多刷3次，转职继续下一个")
			return 0
		end
		日志("未达到目标称号，继续刷【"..不达标多刷金币.."】金币")
		目标称号数据.gold=目标称号数据.gold + 不达标多刷金币
		多刷次数=多刷次数+1
		return 2
	end		
    goto goEnd 
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
::goEnd::
	多刷次数=0
	return 0
end

function 根据职业加载配置()
	if(人物("职业") == "传教士")then
		读取配置("./配置/气绝.save")
	elseif(人物("职业") == "咒术师")then
		读取配置("./配置/石化.save")
	end
	宠物("改状态","待命")
end
function main()
	local 本地声望进度=读取声望进度()
	if 本地声望进度==nil then
		刷称号阶段=用户下拉框("选择‘1’从（现称号）开始刷，\n"..
		"选择‘2’从当前进行转职并开始刷，\n"..
		"选择‘3’从指定称号开始刷"
		,{"1","2","3"})	
		if(刷称号阶段 == 1)then		
			日志("当前选择从现称号开始刷到下一级")
			if(刷之前声望进度 == nil)then
				if(称号提交获取() ~= 0)then
					日志("获取称号数据错误，退出",1)
				end
			end
		elseif(刷称号阶段 == 2)then	
			日志("当前选择从现称号转职，并刷到下一级")
			if(称号提交获取() ~=  0)then
				日志("获取称号数据错误，退出",1)
			end
			去转职()			
		elseif(刷称号阶段 == 3)then	
			日志("当前选择从指定称号开始刷（重启脚本时专用）")
			指定初始称号 =用户下拉框("指定初始称号刷",指定初始称号列表)	
			if(指定初始称号==nil or 指定初始称号=="")then
				指定初始称号 = 人物("称号")
			end		
			刷之前声望进度=0	
			刷声望前时间=os.time() 
			刷声望回补总计=0
			刷声望前金币=人物("金币")
			目标称号数据=下级称号数据(指定初始称号,刷之前声望进度)
			if(目标称号数据 ~= nil) then		
				目标称号数据.gold = 目标称号数据.gold*不达标多刷金币倍数
				if(目标称号数据.gold > 400000)then
					日志("计算下级消耗金币数量错误，请查看",1)
					return 2
				end
				日志("下级称号数据 金币："..目标称号数据.gold.." 下级称号:"..目标称号数据.title.." 分钟:"..目标称号数据.time.." 等级:"..目标称号数据.grade.." 需要次数:"..目标称号数据.count)		
				if(人物("金币") < 目标称号数据.gold) then
					日志("人物金币不够刷到下个称号，去银行取钱，当前金币【"..人物("金币").."】")
					common.getMoneyFromBank(目标称号数据.gold)
				end
				if(人物("金币") < 目标称号数据.gold) then
					日志("人物金币不够刷到下个称号，银行也没有钱了，退出")	
					return -1
				end
			end		
		end	
	else
		日志("读取到上次声望进度，继续刷称号")
		指定初始称号 =本地声望进度.nextTitle
		if(指定初始称号==nil or 指定初始称号=="")then
			指定初始称号 = 人物("称号")
		end		
		刷之前声望进度=本地声望进度.lastStep
		刷声望前时间=os.time() 
		刷声望回补总计=本地声望进度.count
		刷声望前金币=人物("金币")
		刷声望前金币=刷声望前金币+本地声望进度.useGold			--加上本地记录的上次消耗金币数 可能会超100W 问题不大
		目标称号数据=下级称号数据(指定初始称号,刷之前声望进度)
		if(目标称号数据 ~= nil) then		
			目标称号数据.gold = 本地声望进度.nextGold		--目标称号数据.gold*不达标多刷金币倍数
			if(目标称号数据.gold > 400000)then
				日志("计算下级消耗金币数量错误，请查看",1)
				return 2
			end
			日志("下级称号数据 金币："..目标称号数据.gold.." 下级称号:"..目标称号数据.title.." 分钟:"..目标称号数据.time.." 等级:"..目标称号数据.grade.." 需要次数:"..目标称号数据.count)		
			if(人物("金币") < 目标称号数据.gold) then
				日志("人物金币不够刷到下个称号，去银行取钱，当前金币【"..人物("金币").."】")
				common.getMoneyFromBank(目标称号数据.gold)
			end
			if(人物("金币") < 目标称号数据.gold) then
				日志("人物金币不够刷到下个称号，银行也没有钱了，退出")	
				return -1
			end
		end		
	end	
	if(common.findSkillData("石化魔法") ==nil)then
		设置("遇敌全跑",1)
		日志("去学习石化魔法",1)
		common.autoLearnSkill("石化魔法")
		设置("遇敌全跑",0)
	end
	if(common.findSkillData("气绝回复") ==nil)then
		设置("遇敌全跑",1)
		日志("去学习气绝回复",1)
		common.autoLearnSkill("气绝回复")
		设置("遇敌全跑",0)
	end
	local playerMaxMp = 人物("最大魔")
	if(playerMaxMp <= 500 )then
		不达标多刷金币倍数 = 1.5--2
	elseif(playerMaxMp > 500 and playerMaxMp < 1000)then
		--不达标多刷金币倍数 = 1.5
		不达标多刷金币倍数 = 1.2
	elseif(playerMaxMp >= 1000 and playerMaxMp < 1500)then
		--不达标多刷金币倍数 = 1.3
		不达标多刷金币倍数 = 1
	elseif(playerMaxMp >= 1500)then
		不达标多刷金币倍数 = 1
	else
		不达标多刷金币倍数 = 1
	end
	等待空闲()	
	if(取物品数量("咒术师推荐信") < 1)then
		日志("去拿咒术推荐信",1)
		执行脚本("脚本/就职/★就职-咒术.lua")--	去拿咒术推荐信()
	end
	
	日志("根据职业加载配置",1)
	根据职业加载配置()
::begin::
	等待空闲()
	local 当前地图名 = 取当前地图名()	
	if (当前地图名=="艾尔莎岛" )then	
		goto erDao	
	elseif (当前地图名=="里谢里雅堡" )then	
		goto liBao
	elseif (当前地图名=="灵堂" )then	
		goto yudi	
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
	等待(2000)			
	等待空闲()
	if (取当前地图名()=="艾尔莎岛" )then	
		goto begin
	end
::liBao::
	--默认战斗宠物改为待命 
	宠物("改状态","待命")
	--宠物("改状态","战斗",5)
	自动寻路(47,86)	
	自动寻路(47,85,"召唤之间")		
	自动寻路(27,8,"回廊")		
	自动寻路(23,19,"灵堂")
::yudi::	
	自动寻路(27,54)
	if (取当前地图名()~="灵堂" )then
		停止遇敌()  
		goto begin
	end
	开始遇敌() 
	goto scriptStart 
::scriptStart::	
	if(人物("魔") < 300)then goto  buxue end     --魔小于10
	if(人物("血") < 300)then goto  buxue end
	if (取当前地图名()~="灵堂" )then
		停止遇敌()  
		goto begin
	end
	等待(2000)
	goto scriptStart 
::buxue::
	停止遇敌()          -- 结束战斗		
	等待(5000)
	等待空闲()
	统计消耗(刷声望前时间)
	if(判断称号() == true) then --金币消耗达标 转职 声望达标 切换下一级
		二次判断=称号提交二次判断() 
		if(二次判断 ==0)then	--确实达到第二阶段，则去转职
			多刷次数=0		--重置多刷次数
			if(称号提交获取() ~=  0)then
				日志("获取称号数据错误，退出",1)
			end
			去转职()
			根据职业加载配置()
			goto begin
		elseif(二次判断 == 1)then --下级称号获取失败 整个退出
			日志("下级称号获取失败，退出!")
			return
		elseif(二次判断 == 2)then 
			日志("二次判断称号未达到要求，继续刷声望!")
			goto begin		
		elseif(二次判断 == 3)then 
			日志("一键刷称号已达目标，判断身上保证书",1)
			if(取物品数量("转职保证书") > 0)then
				日志("一键刷称号已达目标，身上已预留一张保证书，脚本退出",1)
			else				
				日志("没有转职保证书，去领取看有没有缓存一张！",1)	
				步骤5()				
				if(取物品数量("转职保证书") < 1)then		
					日志("没有转职保证书，去做任务！")		
					卵4()						
					if(取物品数量("转职保证书") < 1)then
						日志("一键刷称号已达目标，卵4任务失败，身上预留保证书失败，脚本退出",1)
					end						
				end	
			end
			日志("脚本启动时间："..脚本启动时间.." 结束时间："..os.date("%Y-%m-%d %H:%M:%S",os.time()))
			local diffSecTime = os.time()-脚本启动秒数					
			日志("间隔时间："..common.secondsToTime(diffSecTime))
			日志("脚本退出")
			return
		end		
	end
	if (取当前地图名()~="灵堂" )then
		停止遇敌()  
		goto begin
	end
	自动寻路(31,48,"回廊")	
	自动寻路(25,22)
	回复(2)		-- 恢复人宠		
	自动寻路(23,19,"灵堂")
	goto yudi 
end
function 保存声望进度()
	local 进度表 = {lastStep=刷之前声望进度,useGold=刷声望前金币 - 人物("金币"),count=刷声望回补总计,nextGold=目标称号数据.gold,nextTitle=目标称号数据.title}
	local transText = common.TableToStr(进度表)
	--日志(transText)
	设置个人简介("简介",1,2,"卖东西",1,"买东西",1,"想东西",transText)
end
function 读取声望进度()
	local playerInfo = 人物信息()	
	if(playerInfo.persdesc) then
		local descText = playerInfo.persdesc.descString
		if string.len(descText) > 0 and string.find(descText,"{") ~= nil then
			--日志(descText)
			local 进度表 = common.StrToTable(descText)
			return 进度表
		end
	end
	return nil
end
	
main()

		
-- local transText = common.TableToStr(testTbl)
-- 日志(transText)
-- 设置个人简介("简介",1,2,"卖东西",1,"买东西",1,"想东西",transText)
