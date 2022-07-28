★捉神盾脚本，起点哥拉尔登入点，要开了米村传。请设置好自动战斗,战斗1中设置好遇一级宠时的战斗方法 ::战斗2设置好宠物满下线保护.脚本发现BUG联系Q::274100927-----------星落

设置("timer", 100)						

设置("自动战斗",1)
设置("高速战斗", 1)
设置("高速延时",1)
	
local 人补魔=用户输入框( "人多少魔以下补魔", "50")
local 人补血=用户输入框( "人多少血以下补血", "300")
local 宠补魔=用户输入框( "宠多少魔以下补魔", "50")
local 宠补血=用户输入框( "宠多少血以下补血", "200")	
local 自动换水火的水晶耐久值 = 用户输入框("多少耐久以下自动换水火的水晶,不换可不填", "30")

清除系统消息()
::begin::	
	停止遇敌()					-- 结束战斗
	等待空闲()
	mapName=取当前地图名()
	if(mapName == "米内葛尔岛")then
		goto yudi 	
	elseif(mapName == "比比卡片屋")then
		goto map33213 
	elseif (mapName~="阿凯鲁法村" )then 
		回城()
		goto begin 
	end	
	if (人物("宠物数量") >= 5 )then	
		自动寻路(139,136,"银行")
		自动寻路(20,17)
		转向(2)
		等待(2000)		
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
	
	if(取物品数量("封印卡（植物系）") < 1)then goto  maika end	
	if(人物("魔") < 人补魔)then goto  recovernow end		-- 魔小于100
	if(人物("血") < 人补血)then goto  recovernow end
	if(宠物("血") < 宠补血)then goto  recovernow end
	if(宠物("魔") < 宠补魔)then goto  recovernow end
	自动寻路(178,227,"米内葛尔岛")
	goto begin 
::maika::
	自动寻路(161, 156, "比比卡片屋")
::map33213::
	自动寻路(16, 18)
	转向(0)             
	等待服务器返回()	
	对话选择(0,0)
	等待服务器返回()
	买(8,20)	   	
	等待服务器返回()	
	叠("封印卡（植物系）",20)	
	if(取物品叠加数量("风地的水晶（5：5）") < 20)then 
		转向(0)
		等待服务器返回()	
		对话选择(0,0)
		等待服务器返回()
		买(12,1)       
		等待服务器返回()
		装备("风地的水晶（5：5）")
	end
	自动寻路(18,32,"阿凯鲁法村")
	goto begin 

::recovernow::
	自动寻路(196,208,"冒险者旅馆 1楼")		
	自动寻路(22, 17)
	回复(0)			
	自动寻路(16,23,"阿凯鲁法村")
	自动寻路(178,227,"米内葛尔岛")
	goto begin 
::yudi::
	自动寻路(241, 266)	
	开始遇敌()       
	goto scriptstart 
::scriptstart::
	if(人物("魔") < 人补魔)then goto  battleover end		-- 魔小于100
	if(人物("血") < 人补血)then goto  battleover end
	if(宠物("血") < 宠补血)then goto  battleover end
	if(宠物("魔") < 宠补魔)then goto  battleover end
	if(取物品数量("封印卡（植物系）") < 1)then goto battleover end
	if (人物("宠物数量") >= 5 )then	
		日志("宠物数量满了，回城存储！")
		goto battleover	
	end
	等待(2000)
	goto scriptstart 					-- 继续自动遇敌

::battleover::	
	停止遇敌()						-- 结束战斗	
	等待(1000)
	回城()
	goto begin 
