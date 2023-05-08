▲自动去跑记忆 ::启动点::艾尔莎,公寓  光之路  辛梅尔  此为王冠脚本	
	
	
common=require("common")
	
设置("timer",100)
local 卖店物品列表="魔石|卡片？|锹型虫的卡片|水晶怪的卡片|哥布林的卡片|红帽哥布林的卡片|迷你蝙蝠的卡片|绿色口臭鬼的卡片|锥形水晶|口袋龙的卡片|地狱看门犬的卡片"		--可以增加多个 不影响速度

local 人补血=用户输入框( "人补血", "150")
local 人补魔=用户输入框( "人补魔", "50")
local 宠补血=用户输入框( "宠补血", "100")	
local 宠补魔=用户输入框( "宠补魔", "50")

local 自动换水火的水晶耐久值 = 用户输入框("自动换水晶耐久值", "30")
local 封印卡数量=40
local 封印卡名称="封印卡（不死系）"
设置("自动叠",1,封印卡名称.."&20")

清除系统消息()

function 取脚镣耐久()
	local items=物品信息()
	for i,v in pairs(items) do
		if(v.name == "很重的脚镣")then
			return v.durability
		end
	end
	return 20
end
function main()
::begin::	
	等待空闲()
	mapNum=取当前地图编号()
	mapName=取当前地图名()
	if(mapName == "艾尔莎岛")then goto 出发 end 	--艾尔莎岛
	if(mapName == "里谢里雅堡")then goto 出发 end 	--艾尔莎岛
	if(mapNum == 400)then goto map400 end 			--莎莲娜
	if(mapNum == 4000)then goto map4000 end 		--杰诺瓦镇
	if(mapNum == 4200)then goto map4200 end 		--蒂娜村
	if(mapNum == 4201)then goto map4201 end 		--蒂娜村
	if(mapNum == 4230)then goto map4230 end 		--酒吧
	if(mapNum == 14017)then goto map14017 end 		--海贼海湾
	if(mapNum == 14018)then goto map14018 end 		--海贼指挥部
	if(mapNum == 14019)then goto map14019 end 		--海贼指挥部  地下5楼
	if(mapNum == 14020)then goto map14020 end 		--海贼指挥部  地下4楼
	if(mapNum == 14021)then goto map14021 end 		--海贼指挥部  地下3楼
	if(mapNum == 14022)then goto map14022 end 		--海贼指挥部  地下2楼
	if(mapNum == 14023)then goto map14023 end 		--海贼指挥部  
	if(mapNum == 14024)then goto map14024 end 		--海贼指挥部  	Boss战
	if(mapNum == 14025)then goto map14025 end 		--海贼指挥部  	
	if(mapNum == 14036)then goto map14036 end 		--海贼指挥部  	学属性翻转
	if(mapNum == 14037)then goto map14037 end 		--海贼指挥部  	魔无
	if(mapNum == 14038)then goto map14038 end 		--海贼指挥部  	攻无
	回城()
	等待(1000)
	goto begin
::出发::
	设置("无一级逃跑",1)	
	宠物("改状态","战斗",5)		--0-4 宠位置 5最高等级宠 6最低等级宠
	common.checkHealth()
	common.checkCrystal()
	common.supplyCastle()
	common.sellCastle()		--默认卖	
	common.buySealCard(封印卡名称,封印卡数量,1)
	common.toCastle()
	自动寻路(41,50)
	等待到指定地图("里谢里雅堡 1楼")	
	自动寻路(45,20,"启程之间")	
	if(游戏时间() == "夜晚" or 游戏时间() == "黄昏")then
		日志("当前时间是【"..游戏时间().."，去杰村！")						
		goto quJieCun
	end		
	goto diNaCun
::quJieCun::
	自动寻路(15, 4)	
	离开队伍()
	转向(2)
	dlg=等待服务器返回()
	--日志(dlg.message,1)
	if(dlg.message~=nil and (string.find(dlg.message,"此传送点的资格")~=nil or string.find(dlg.message,"很抱歉")~=nil ))then
		回城()
		执行脚本("./脚本/直通车/★开传送-杰诺瓦镇.lua")
		goto jiecun
	end	
	转向(2, "")
	等待服务器返回()
	对话选择("4", 0)
	goto jiecun
::diNaCun::	
	自动寻路(25, 4)
	离开队伍()
	对话选是(26,4)
	等待(2000)
	等待空闲()
	if(取当前地图名() ~= "蒂娜村的传送点")then
		日志("未开蒂娜传送。去杰村！")
		goto quJieCun 
	end 
	goto dina
::dina::
	自动寻路(11, 6)
	自动寻路(11, 2)
	等待到指定地图("村长的家")	
	自动寻路(10, 6)
	自动寻路(7, 3)
	自动寻路(7, 1)
	等待到指定地图("村长的家")
	自动寻路(7, 11)
	自动寻路(3, 7)
	自动寻路(1, 7)
	等待到指定地图("村长的家")
	自动寻路(8, 6)
	自动寻路(1, 6)
	goto diNaCunLi

::jiecun::	
	等待到指定地图("杰诺瓦镇的传送点")	
	自动寻路(14, 8)
	自动寻路(14, 6)
	等待到指定地图("村长的家")
	自动寻路(13, 9)
	自动寻路(1, 9)
::map4000::
	等待到指定地图("杰诺瓦镇")
	自动寻路(71, 18)
	等待到指定地图("莎莲娜")	
::map400::
	自动寻路(570,275,"蒂娜村")	
	goto diNaCunLi
::ShaLianLa::
	自动寻路(570,275,"蒂娜村")	
	goto diNaCunLi	
::diNaCunLi::
	等待到指定地图("蒂娜村")	
	if(取当前地图编号() ~= 4201)then		
		自动寻路(44, 60)
		自动寻路(44, 62,"莎莲娜")
		while true do 
			if(游戏时间() ~= "夜晚" and 游戏时间() ~= "黄昏")then		
				日志("当前时间是【"..游戏时间().."】，等待黄昏或夜晚")
				等待(30000)			
			else
				等待(30000)		
				自动寻路(585,316,"蒂娜村")					
				break
			end		
		end	
	end		
	goto begin
::map4200::
	自动寻路(44, 60)
	自动寻路(44, 62,"莎莲娜")
	while true do 
		if(游戏时间() ~= "夜晚" and 游戏时间() ~= "黄昏")then		
			日志("当前时间是【"..游戏时间().."】，等待黄昏或夜晚")
			等待(30000)			
		else
			等待(30000)		
			自动寻路(585,316,"蒂娜村")					
			break
		end		
	end	
	goto begin
::map4201::
	自动寻路(46,56,4230)		
	goto begin
::map4230::
	自动寻路(22,11,4230)	
	对话选是(22,12)
	goto begin
::map14018::
	if(取所有物品数量("有鱼腥味的头巾")  > 0)then
		使用物品("有鱼腥味的头巾")
		自动寻路(3,11)   
		对话选是(3,13)
		goto begin
	end
	if(取所有物品数量("很重的脚镣") < 1)then	--包括装备在身上的
		自动寻路(3,11)   
		对话选是(3,13)
	else
		使用物品("很重的脚镣")
		宠物("改状态","待命")
		自动寻路(7,6)
		if(取脚镣耐久() <= 4)then
			宠物("改状态","战斗",5)		--0-4 宠位置 5最高等级宠 6最低等级宠
			自动寻路(3,11)   
			对话选是(3,13)
		else
			设置("无一级逃跑",0)	
			解脚镣遇敌()			
			设置("无一级逃跑",1)	
		end
	end
	goto begin
::map14019::
	使用物品("有鱼腥味的头巾")
	移动(2,4)	
	等待到指定地图("海贼指挥部  地下5楼",2,4)
	移动(4,4)
	等待到指定地图("海贼指挥部  地下5楼",4,4)
	移动(5,5)
	等待到指定地图("海贼指挥部  地下5楼",5,5)
	移动(6,4)
	等待到指定地图("海贼指挥部  地下5楼",6,4)
	移动(7,5)
	等待到指定地图("海贼指挥部  地下5楼",7,5)
	转向(2)
	移动(8,6)
	等待到指定地图("海贼指挥部  地下5楼",8,6)
	移动(9,6)
	等待到指定地图("海贼指挥部  地下5楼",9,6)
	移动(10,5)
	等待到指定地图("海贼指挥部  地下5楼",10,5)
	移动(11,4)
	等待到指定地图("海贼指挥部  地下5楼",11,4)
	移动(12,5)
	等待到指定地图("海贼指挥部  地下5楼",12,5)
	自动寻路(12,8,"海贼指挥部  地下4楼")
	goto begin
::map14020::
	等待(2000)
	if(人物("坐标") == "2,3")then
		移动(2,4)
		等待到指定地图("海贼指挥部  地下4楼",2,4)
		移动(3,5)
		等待到指定地图("海贼指挥部  地下4楼",9,5)
	elseif(人物("坐标") == "9,5")then
		移动(11,5)
		等待到指定地图("海贼指挥部  地下4楼",4,3)
	elseif(人物("坐标") == "4,3")then
		移动(5,3)
		等待到指定地图("海贼指挥部  地下4楼",5,3)		
		移动(6,3)
		等待到指定地图("海贼指挥部  地下4楼",12,4)
		转向坐标(11,4)
		等待(1000)
		移动(12,5,14021)
	end
	-- 移动(2,4)
	-- 移动(3,5)
	-- 等待到指定地图("海贼指挥部  地下4楼",9,5)
	-- 移动(11,5)
	-- 等待到指定地图("海贼指挥部  地下4楼",4,3)
	-- 移动(5,3)
	-- 转向坐标(4,3)
	-- 移动(6,3)
	-- 移动(12,5,14021)
	goto begin
::map14021::	
	if(人物("坐标") == "2,2")then
		移动(3,2)	
		等待到指定地图("海贼指挥部  地下3楼",8,2)
	elseif(人物("坐标") == "8,5")then		
		移动(10,5)
		等待到指定地图("海贼指挥部  地下3楼",10,5)		
		移动(10,4)
		等待到指定地图("海贼指挥部  地下3楼",12,8)
	elseif(人物("坐标") == "8,2")then
		转向坐标(7,2)--转向(6)
		移动(7,3)
		等待到指定地图("海贼指挥部  地下3楼",8,5)
	elseif(人物("坐标") == "12,8")then
		转向坐标(7,2)--转向(6)
		自动寻路(12,11,"14022")
	end
	-- 移动(3,2)
	-- 等待到指定地图(14021,8,2)
	-- 转向坐标(7,2)--转向(6)
	-- 移动(7,3)
	-- 等待到指定地图(14021,8,5)
	-- 移动(9,6)
	-- 移动(10,5)
	-- 移动(10,4)
	-- 等待到指定地图(14021,12,8)
	-- 移动(12,11,14022)
	goto begin
::map14022::	
	if(人物("坐标") == "2,1")then
		移动(2,2)	
		等待到指定地图("海贼指挥部  地下2楼",2,2)
		转向坐标(4,2)
	elseif(人物("坐标") == "2,2")then
		转向坐标(4,2)
	elseif(人物("坐标") == "12,2")then
		转向坐标(12,4)
	elseif(人物("坐标") == "7,6")then
		转向坐标(5,4)
	elseif(人物("坐标") == "2,6")then
		转向坐标(2,5)
	elseif(人物("坐标") == "12,11")then
		自动寻路(12,12,"14023")
	end
	-- 自动寻路(2,2)
	-- 转向坐标(4,2)
	-- 等待到指定地图("14022",12,2)
	-- 转向坐标(12,4)
	-- 等待到指定地图("14022",7,6)
	-- 转向坐标(5,4)
	-- 等待到指定地图("14022",2,6)
	-- 转向坐标(2,5)
	-- 等待到指定地图("14022",12,11)
	-- 自动寻路(12,12,14023)
	等待(1000)
	goto begin
::map14023::
	自动寻路(7,15)	
	goto begin
::map14024::		--Boss
	自动寻路(20,10)
	转向(2)	
	等待(2000)
	if(是否战斗中())then
		等待战斗结束()
	end
	goto begin
::map14025::		--另个地图
	自动寻路(3,14)
	goto begin
::map14017::		--海贼海湾
	自动寻路(16,32)
	转向(0)
	开始遇敌()
::scriptLoop::
	if(人物("魔") < 人补魔)then goto  ting end		-- 魔小于100
	if(人物("血") < 人补血)then goto  ting end
	if(宠物("血") < 宠补血)then goto  ting end
	if(宠物("魔") < 宠补魔)then goto  ting end
	if(取物品叠加数量(封印卡名称) < 1)then goto  ting end	
	if(取物品叠加数量(封印卡名称) < 1)then goto  ting end	
	if(取当前地图编号() ~= 14017) then goto begin end
	if (人物("宠物数量") >= 5 )then	
		日志("宠物数量满了，回城存储！")
		goto ting	
	end
	if( 人物("灵魂") > 0 )then
		goto  ting 
	end
	等待(3000)
	goto scriptLoop 					
::ting::
	停止遇敌()
	等待空闲()
	等待(5000)			--如果有血瓶 等吃血瓶
	--二次判断 成功就回城
	if(人物("魔") < 人补魔)then goto  backbu end		-- 魔小于100
	if(人物("血") < 人补血)then goto  backbu end
	if(宠物("血") < 宠补血)then goto  backbu end
	if(宠物("魔") < 宠补魔)then goto  backbu end
	if(取物品叠加数量(封印卡名称) < 1)then goto  backbu end	
	if (人物("宠物数量") >= 5 )then	
		日志("宠物数量满了，回城存储！")
		goto backbu	
	end
	if( 人物("灵魂") > 0 )then
		goto  backbu 
	end
	goto map14017
::backbu::	
	回城()     
	goto begin 
	
::map14036::
	日志("任务已完成，请手动学习技能",1)
	if(是否属性翻转)then
		自动寻路(20,10)
		common.learnPlayerSkill(21,10)
	end
	自动寻路(16,7)
	对话选是(16,6)		--貌似真是随机传送
	goto begin
::map14037::	--魔无  这个没测 但八九不离十
	日志("魔无地图，要学攻无，再来一遍",1)
	自动寻路(16,7)
	common.learnPlayerSkill(16,6)	
	--大地的祈祷
	自动寻路(21,9)
	common.learnPlayerSkill(22,9)
	--海洋的祈祷
	自动寻路(21,12)
	common.learnPlayerSkill(22,12)
::map14038::	--攻无
	日志("攻无地图，要学魔无，再来一遍",1)
	自动寻路(16,7)
	common.learnPlayerSkill(16,6)
	--火焰的祈祷
	自动寻路(21,9)
	common.learnPlayerSkill(22,9)
	--云群的祈祷
	自动寻路(21,12)
	common.learnPlayerSkill(22,12)
	
::map14039::	--海贼的秘道
	自动寻路(6,21,"莎莲娜")
	
end
function 解脚镣遇敌()
	开始遇敌()
::begin::
	if(人物("魔") < 人补魔)then goto  ting end		-- 魔小于100
	if(人物("血") < 人补血)then goto  ting end
	--if(宠物("血") < 宠补血)then goto  ting end
	--if(宠物("魔") < 宠补魔)then goto  ting end	
	if(取脚镣耐久() <= 4)then goto retJudge end		
	if(取所有物品数量("很重的脚镣") < 1)then goto retJudge end	
	等待(2000)
	goto begin
::ting::
	停止遇敌()
	等待空闲()
	--回城()	
::retJudge::
	停止遇敌()
	等待空闲()	 
	
end
main()