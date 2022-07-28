▲神域的使者 ::启动点::艾尔莎,公寓  光之路  辛梅尔  此为王冠脚本，血多优先	
	
	
common=require("common")
	
设置("高速延时", 3)	
设置("timer",20)
local 队长名称=取脚本界面数据("队长名称",false)
local 队伍人数=取脚本界面数据("队伍人数")
if(队长名称==nil or 队长名称=="" or 队长名称==0)then
	队长名称=用户输入框("请输入队伍名称！","风依旧￠花依然")--风依旧￠花依然  乱￠逍遥
end


--local 水晶名称="风地的水晶（5：5）"
local 水晶名称="水火的水晶（5：5）"
local isTeamLeader=false		--是否队长
local 身上最少金币=5000			--少于去取
local 身上最多金币=1000000		--大于去存
local 身上预置金币=500000		--取和拿后 身上保留金币
local 脚本运行前时间=os.time()	--统计效率
local 脚本运行前金币=人物("金币")	--统计金币
local 已刷卵总数=0

local 预置扔依格罗斯档次=22				--0档以上仍 鸟用此选项
local 预置扔麒麟档次=22				--0档以上仍 鸟用此选项
local 预置扔翼龙档次=5				--5档以上扔
local 预置扔罗修档次=2				--2档以上仍
local 已刷宠物数量={
	["依格罗斯"]={count=0,msg="惊喜,您刷到了稀缺宠物【依格罗斯】,档次 ",grade=预置扔依格罗斯档次},
	["麒麟"]={count=0,msg="恭喜,您刷到了宠物【麒麟】,档次 ",grade=预置扔麒麟档次},
	["翼龙"]={count=0,msg="恭喜,您刷到了宠物【翼龙】,档次 ",grade=预置扔翼龙档次},
	["罗修"]={count=0,msg="恭喜,您刷到了个性宠物【罗修】,档次 ",grade=预置扔罗修档次},
	}		--希特拉 泰坦巨人 萨普地雷 托罗帝鸟 岩地跑者
function 取新开出的宠信息(oldPetList,newPetList)
	if(oldPetList ==nil or newPetList ==nil )then return nil end
	local findNewPet=false
	for i,n in ipairs(newPetList) do
		findNewPet=false
		for j,o in ipairs(oldPetList) do
			if(n.index == o.index)then
				findNewPet=true
				break
			end
		end
		if(findNewPet==false)then
			return n
		end
	end		
	return nil
end

function 开奖()
	if(取物品数量("偏方多面体的卵") > 0)then
		已刷卵总数=已刷卵总数+1		
		日志("获得了【偏方多面体的卵】，开奖咯！")
		local oldPetList=全部宠物信息()
		if(common.getTableSize(oldPetList) >= 5)then
			日志("自动开奖失败，宠物已满，请至少预留一个空位!")
		else
			使用物品("偏方多面体的卵")
			等待服务器返回()
			对话选择(4,-1)
			等待(1000)
			local newPetList = 全部宠物信息()
			local newPet = 取新开出的宠信息(oldPetList,newPetList)
			if(newPet ~= nil)then			
				for i,v in pairs(已刷宠物数量) do
					if(newPet.realname == i)then	
						v.count = v.count + 1
						if(newPet.grade == nil)then
							日志(v.msg .. "未知")							
						else
							日志(v.msg .. newPet.grade)
							if(newPet.grade == 20 or newPet.grade==0)then
							
							elseif(newPet.grade > v.grade)then
								日志("档次低于设定值，丢弃")
								宠物("改名",newPet.grade,newPet.index)
								等待(3000)
								扔宠(newPet.index)
							end
						end
						break
					end
				end				
			end
		end	
	end	
	common.statisticsTime(脚本运行前时间,脚本运行前金币)	
	已刷卵总数=已刷卵总数+1
	日志("已刷守护次数："..已刷卵总数.."次",1)
	local msgCount="各宠物数量分别为："	
	for i,v in pairs(已刷宠物数量) do			
		msgCount=msgCount..i.."："..v.count.." "		
	end
	日志(msgCount)
end

function main()	
	--开奖()	
	日志("欢迎使用星落刷自动跑守护脚本",1)
	日志("当前职业："..人物("职业"),1)
	日志("当前职称："..人物("职称"),1)
	common.baseInfoPrint()
	common.statisticsTime(脚本运行前时间,脚本运行前金币)	
	
	if(人物("名称",false) == 队长名称)then
		isTeamLeader=true
		日志("当前是队长:"..人物("名称",false),1)
		if(队伍人数==nil or 队伍人数==0)then
			队伍人数 = 用户输入框("队伍人数",5)
		else
			队伍人数=tonumber(队伍人数)
		end
		日志("队伍人数:"..队伍人数,1)
		
	else	
		日志("当前是队员:"..人物("名称",false),1)
	end
	日志("队长名称："..队长名称.." 角色名称:" .. 人物("名称",false))	
	local mapNum=0
	local mapName=""
::begin::	
	等待空闲()
	mapNum=取当前地图编号()
	mapName=取当前地图名()
	if(mapNum == 59513)then goto map59513 
	elseif(mapNum==59522)then goto map59522			--利夏岛
	elseif(mapNum==59557)then goto map59557
	elseif(mapNum==59552)then goto map59552			--国民会馆
	elseif(mapNum==59984)then goto map59984
	elseif(mapNum==59982)then goto map59982
	elseif(mapNum==59988)then goto map59988
	elseif(mapNum==59985)then goto map59985			--？？？  真实之顶打完boss位置
	elseif(mapNum==59986)then goto map59986
	elseif(mapNum==59987)then goto map59987
	elseif(mapNum==59757)then goto map59757			--星之领域　１层
	elseif(mapNum==59758)then goto map59758			--星之领域　２层
	elseif(mapNum==59759)then goto map59759			--星之领域　３层
	elseif(mapNum==59760)then goto map59760			--星之领域　４层
	elseif(mapNum==59761)then goto map59761			--星之领域　５层
	elseif(mapNum==59992)then goto map59992			--真实之顶
	elseif(mapNum==59993)then goto map59993			--约尔克神庙
	elseif(string.find(mapName,"通向顶端的阶梯")~=nil)then goto crossMaze  
	elseif(mapName== "公寓")then goto 补魔  
	elseif(mapName == "辛梅尔")then goto map59987  
	elseif(mapName == "艾尔莎岛")then goto 出发 
	elseif(人物("坐标")  == "319,139")then	goto yiji 
	elseif(人物("坐标")  == "26,15")then	goto najiyi end
	等待(1000)
	goto begin
::补魔::	
	自动寻路(91,58)   	 
	回复(0)		
	自动寻路(100,70,"辛梅尔")	
	goto begin	
::出发::	
	common.supplyCastle()
	common.checkHealth()
	common.sellCastle()
	回城()
	等待空闲()
	等待到指定地图("艾尔莎岛")	
	自动寻路(165,153)	
	转向(4, "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")	
::map59522::
	等待到指定地图("利夏岛")	
	自动寻路(90,99,"国民会馆")
::map59552::		--国民会馆
	自动寻路(115,51)
	对话选是(116,50)
	goto begin
::map59987::		--辛梅尔
	if(common.isNeedSupply() and 目标是否可达(181,81))then	--到辛梅尔 主要不满血魔 就去补一下 
		自动寻路(181,81,"公寓")	
		goto begin
	end
	if(取物品数量("托尔丘的记忆") > 0)then
		日志("记忆任务完成,去做3",1)
		回城()
		goto begin
	end
	if(目标是否可达(26,15))then
		自动寻路(25,15)	
		对话选是(1)		
		if(取物品数量("托尔丘的记忆") > 0)then
			日志("记忆任务完成",1)
			return			
		end
	else
		自动寻路(187,88)   
		自动寻路(192,83) 
		自动寻路(192, 82,"第二宝座")		
		自动寻路(105, 20,"辛梅尔")	   
	end
	goto begin
::map59557::		--第二宝座
	自动寻路(105, 20,"辛梅尔")	   
	goto begin
::map59513::
	if(目标是否可达(153, 121))then
		自动寻路(153, 121)
	end
	if(目标是否可达(167,28))then
		自动寻路(167, 26)
		自动寻路(169, 26)		
		对话选是(2)
		自动寻路(169, 20)		
		对话选是(7)
		自动寻路(167, 16)			
		对话选是(0)
		自动寻路(162, 22)	
		对话选是(4)
	end
	if(目标是否可达(116, 69))then
		自动寻路(118, 67)	
		对话选是(2)	
	end
	goto begin
::map59984::		--？？？
	if(目标是否可达(161,58))then	
		自动寻路(161, 58)	
		对话选是(2)	
	end
	if(目标是否可达(121,98))then	
		自动寻路(121, 98)	
		对话选是(2)	
	end	
	if(目标是否可达(201, 18))then	
		自动寻路(201, 18)	
		对话选是(2)	
	end
	if(目标是否可达(318, 135))then	
		自动寻路(318, 135)			
		日志("学一击必中的赶紧哦，10秒后继续下一步",1)
		等待(10000)
		--对话选是(2)	
		自动寻路(319, 148)	
		等待(2000)
		对话选择("4", "", "")	
	end
	if(目标是否可达(238,139))then	
		自动寻路(238,139)
	end
	if(目标是否可达(355,180))then	
		自动寻路(355,180)
	end
	if(目标是否可达(315,220))then	
		自动寻路(315,220)
	end
	if(目标是否可达(279,256))then	
		自动寻路(279,256)
	end
	goto begin
::map59982::
	if(目标是否可达(101, 137))then
		自动寻路(101, 137)	
		对话选是(0)
	end
	if(目标是否可达(205, 55))then
		自动寻路(205, 55)				
	end
	if(目标是否可达(165, 105))then
		自动寻路(165, 105)				
	end
	if(目标是否可达(234, 106))then
		自动寻路(234, 106)					
	end
	if(目标是否可达(193, 132))then
		自动寻路(193, 132)				
	end
	if(目标是否可达(208, 239))then		--第一个boss
		自动寻路(208, 239)			
		对话选是(7)		
		等待战斗结束()
	end
	if(目标是否可达(193, 216))then		--第2个boss
		自动寻路(193, 216)		
		对话选是(1)		
		等待战斗结束()
	end	
	if(目标是否可达(227, 198))then		--第3个boss
		自动寻路(227, 198)		
		对话选是(3)		
		等待战斗结束()
	end
	if(目标是否可达(258, 229))then		--第4个boss
		自动寻路(258, 229)		
		对话选是(3)		
		等待战斗结束()
	end
	if(目标是否可达(282, 156))then		--第5个boss
		自动寻路(282, 156)		
		对话选是(5)				
	end
	if(目标是否可达(81, 138))then		--第6个boss
		自动寻路(81, 138)		
		对话选是(2)			
	end
	goto begin
::map59988::							--？？？
	等待到指定地图("？？？")		
	if(目标是否可达(203, 14))then	
		if isTeamLeader then			
			if(队伍("人数") < 队伍人数)then
				common.makeTeam(队伍人数)	
			else
				自动寻路(203, 14,"通向顶端的阶梯1楼")		
			end		
		else
			if(队伍("人数") > 1)then
				if(common.judgeTeamLeader(队长名称)==true) then
					while true do
						if(队伍("人数") < 2)then							
							break											
						end
						等待(3000)
					end
				else
					离开队伍()
				end	
			else				
				common.joinTeam(队长名称)							
			end
		end				
	end
	if(目标是否可达(163, 54))then		
		自动寻路(163, 54,"真实之顶")				
	end
	if(目标是否可达(358, 173))then		
		自动寻路(358, 173)		
		对话选是(0)		
	end
	goto begin
::map59992::			--真实之顶
	自动寻路(103,19)
	对话选是(1)
	等待(3000)
	if(是否战斗中())then 等待战斗结束() end
	goto begin
::map59985::			--？？？
	--等待到指定地图("？？？",110,146)
	if(目标是否可达(116, 131))then		
		自动寻路(116, 131)		
		对话选是(0)		
	end
	if(目标是否可达(156,171))then		
		自动寻路(156,171)		
		对话选是(0)		
	end	
	goto begin
::map59986::
	等待到指定地图("？？？")		
	自动寻路(139, 63)
	自动寻路(141, 61)	
	对话选是(0)
	goto begin
::map59757::			--星之领域　１层
	等待到指定地图("星之领域　１层")    
	自动寻路(98,17)
	自动寻路(99,17)	
::map59758::    
    等待到指定地图("星之领域　２层")  	
	if(目标是否可达(29, 89))then			
		自动寻路(29,89)	
	elseif(目标是否可达(166,102))then		
		自动寻路(166,102)	
	end	
	goto map59759 	
::map59759::    
    等待到指定地图("星之领域　３层")	
	if(目标是否可达(107,167))then			
		自动寻路(107,167)	
	elseif(目标是否可达(97,28))then		
		自动寻路(97,28)	
	end		
	goto begin
::map59760::    
    等待到指定地图("星之领域　４层")    	
	自动寻路(107,98)
	自动寻路(108,98)	
	等待(1000)	
	goto map59761 	
::map59761::    
    --等待到指定地图("星之领域　５层", 110,97) 
	if(目标是否可达(39,99))then			
		自动寻路(39,99)	
		对话选是(40,99)
	elseif(目标是否可达(141,113))then		
		自动寻路(141,113)	
		转向(2)		
		等待(3000)
	end	
	goto begin
::jiance::    
	if(人物("坐标")   ==  "83,129")then	goto  conglai end
	if(人物("坐标")   ==  "32,99")then	goto  jieshu end	
	goto jiance 	
::conglai::
    自动寻路(83,126)
	自动寻路(69,126)
	goto map59761 	
::jieshu::
    自动寻路(35,99)
	goto begin
::map59993::		--约尔克神庙
	自动寻路(41,27)
	自动寻路(41,28)
	自动寻路(41,27)	
	自动寻路(41,28)
	自动寻路(41,27)
	--丢魔石
	对话选是(42,28)
	对话选是(42,27)
::map59536::		--约尔克神庙
	回城()
	等待空闲()
	自动寻路(144,108)
	开奖()
	if(true)then return end
::yiji::	
	等待到指定地图("？？？")	
	自动寻路(318, 139)
	自动寻路(318, 148)
	自动寻路(319, 148)		
	对话选择("4", "", "")	
::najiyi::
	等待(1000)	
	转向(0, "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	
	if(人物("坐标")  == "188,70")then	goto pd end
	goto begin 

::crossMaze::
	自动穿越迷宫()
	goto begin
end
main()