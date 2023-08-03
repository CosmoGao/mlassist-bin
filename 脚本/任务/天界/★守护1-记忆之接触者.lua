▲自动去跑记忆 ::启动点::艾尔莎,公寓  光之路  辛梅尔  此为王冠脚本	
	
	
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
local 是否学一击必中=用户勾选框("是否学一击必中",0)
local 是否领取王冠=用户勾选框("是否领取王冠",1)		--需要有王冠发放员
	
local bossData={
{name="梦魔1",x=207,y=238,nexty=235},	--204 235
{name="梦魔2",x=194,y=215,nexty=209},	--199 209
{name="梦魔3",x=228,y=199,nexty=203},	--232 203
{name="梦魔4",x=259,y=230,nexty=149}	--283 149
}	

function 跑王冠()
设置("遇敌全跑", 1)
::kaishi::	
	等待空闲()
	当前地图名=取当前地图名()	
	if(当前地图名=="雪拉威森塔９６层")then	
		goto T96
	elseif(当前地图名=="雪拉威森塔９７层")then		
		goto T97
	elseif(当前地图名=="雪拉威森塔９８层")then		
		goto T98
	elseif(当前地图名=="雪拉威森塔９９层")then		
		goto T99
	elseif(当前地图名=="雪拉威森塔最上层")then		
		goto T100
	elseif(当前地图名=="雪拉威森塔前庭")then		
		goto T101
	end
	common.healPlayer(doctorName)
	common.recallSoul()
	common.supplyCastle()
	if(人物("血") < 1000)then goto  lookbu end
	if(人物("魔") < 300)then goto  lookbu end
	--if(宠物("血") < 宠补血值)then goto  lookbu end
	--if(宠物("魔") < 宠补魔值)then goto  lookbu end
	if(取物品数量("塞特的护身符") > 0)then goto  saite end
	if(取物品数量("梅雅的护身符") > 0)then goto  meiya end
	if(取物品数量("提斯的护身符") > 0)then goto  tisi end
	if(取物品数量("伍斯的护身符") > 0)then goto  wusi end
	if(取物品数量("尼斯的护身符") > 0)then goto  nisi end
	if(当前地图名=="艾尔莎岛")then		
		goto 雪拉威森塔
	end
	回城()
	goto kaishi
::雪拉威森塔::	
	自动寻路(165, 153)	
	转向(4)
	等待服务器返回()	
	对话选择(32,0)
	等待服务器返回()
	对话选择(4, 0)	
	等待到指定地图("利夏岛")		
	自动寻路(90,99,"国民会馆")
	自动寻路(108, 54)	
	回复(0)		
	自动寻路(108, 39)	
	等待到指定地图("雪拉威森塔１层")		
	自动寻路(75, 50)	
	等待到指定地图("雪拉威森塔５０层")		
	自动寻路(16, 44)	
	等待到指定地图("雪拉威森塔９５层")	
	自动寻路(26, 104)
	自动寻路(27, 104)		
	转向(2)
	等待服务器返回()	
	对话选择("32", "", "")	
	对话选择("4", "", "")	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９６层")		
	goto lookbu
	
::saite::	
	使用物品("塞特的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９５层")		
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９６层")			
::T96::
	自动寻路(86, 120)
	自动寻路(87, 119)			
	转向(1, "")
	等待服务器返回()	
	对话选择("32", "", "")	
	等待服务器返回()	
	对话选择("32", "", "")	
	等待服务器返回()	
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９７层")		
	goto lookbu
::meiya::	
	使用物品("梅雅的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９６层")	
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９７层")	
::T97::
	自动寻路(117, 126)	
	转向(0, "")
	等待服务器返回()	
	对话选择("32", "", "")	
	对话选择("32", "", "")	
	对话选择("32", "", "")	
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９８层")		
	goto lookbu
::tisi::	
	使用物品("提斯的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９７层")	
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９８层")		
::T98::	
	自动寻路(120, 121)		
	转向(0, "")
	等待服务器返回()	
	对话选择("32", "", "")	
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９９层")	
	goto lookbu	
::wusi::	
	使用物品("伍斯的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９８层")		
	转向(0)
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔９９层")		
::T99::
	自动寻路(101, 55)		
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔最上层")		
	goto lookbu
::nisi::	
	使用物品("尼斯的护身符")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("雪拉威森塔９９层")		
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")	
	等待到指定地图("雪拉威森塔最上层")		
::T100::	
	自动寻路(103, 134)	
	等待到指定地图("雪拉威森塔前庭")		
::T101::	
	自动寻路(103, 19)		
::jiance::
	goto wangguan
	if(取物品数量("王冠") < 1)then goto  wangguan end	
	if(取物品数量("公主头冠") < 1)then goto  gongzhuguan end
::xiaomaomao::	
	转向(1, "")
	等待服务器返回()	
	对话选择("4", "", "")
	等待服务器返回()	
	对话选择("1", "", "")	
	goto dengdai 
::wangguan::
	等待(300)	
	喊话("男",2,3,4)
	等待服务器返回()
	对话选择(1,0)
	goto dengdai 
::gongzhuguan::
	等待(300)	
	转向(1)
	等待服务器返回()	
	对话选择(32,0)
	等待服务器返回()	
	对话选择(1,0)
	goto dengdai 
::dengdai::
	等待到指定地图("国民会馆")	
	等待(200)
	if(取物品数量("王冠") > 0)then goto  qucun end	
	if(取物品数量("小猫帽") > 0)then goto  qucun end	
	goto kaishi 
::lookbu::
	needSupply = false
	if(人物("血") < 人物("最大血") or 人物("魔") < 人物("最大魔")) then
		needSupply=true
	end
	if(宠物("血") < 宠物("最大血") or 宠物("魔") < 宠物("最大魔")) then
		needSupply=true
	end
	if(needSupply == false)then
		goto kaishi
	end
	回城()
	等待到指定地图("艾尔莎岛")	
	转向(1)
	等待服务器返回()
	对话选择(4,0)	
	等待到指定地图("里谢里雅堡")		
	自动寻路(34, 89)	
	回复(1)	
	common.healPlayer(doctorName)
	common.recallSoul()
	等待(2000)
	goto kaishi 
::qucun::
   	回城()
   	等待到指定地图("艾尔莎岛")   
设置("遇敌全跑", 0)
end	
function waitToNextBoss(name,x,y,nexty)
	if(目标是否可达(x,y))then	--露比
		移动到目标附近(x,y)
		对话选是(x,y)	
		等待(3000)
		if(是否战斗中())then 等待战斗结束() end
		等待空闲()
		nowx,nowy=取当前坐标()
		if(nowy==nexty)then
			return 1
		else
			日志("没有打过"..name,1)
			return -1
		end
	end
	return 0
end
function main()
	日志("欢迎使用星落刷自动跑记忆脚本",1)
	--日志("当前职业："..人物("职业"),1)
	--日志("当前职称："..人物("职称"),1)
	--common.baseInfoPrint()
	--common.statisticsTime(脚本运行前时间,脚本运行前金币)	
	--日志("是否领取王冠"..tostring(是否领取王冠),1)
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
	common.changeLineFollowLeader(队长名称)		--同步服务器线路	
	mapNum=取当前地图编号()
	mapName=取当前地图名()
	if(mapNum == 59513)then goto map59513 
	elseif(mapNum==59984)then goto map59984
	elseif(mapNum==59982)then goto map59982
	elseif(mapNum==59988)then goto map59988
	elseif(mapNum==59986)then goto map59986
	elseif(mapNum==59987)then goto map59987
	elseif(mapName== "公寓")then goto 补魔  
	elseif(mapName == "辛梅尔")then goto map59987  
	elseif(mapName == "艾尔莎岛")then goto 出发 
	elseif(人物("坐标")  == "319,139")then	goto yiji 
	elseif(人物("坐标")  == "26,15")then	goto najiyi 
	else	
		goto 出发 
	end
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
	if(取物品数量("王冠") < 1)then		
		common.gotoBankTalkNpc()
		银行("取物","王冠",1)
		等待(2000)
		if(取物品数量("王冠") < 1)then
			日志("脚本需要王冠，如果没有的话，请走到辛美尔在启动",1)	
			日志("是否领取王冠"..tostring(是否领取王冠),1)
			回城()
			等待空闲()
			if(是否领取王冠)then			
				common.gotoBankRecvTradeItemsAction({topic="王冠发放员",publish="领取王冠",itemName="王冠",itemCount=1,itemPileCount=1})
			else
				跑王冠()	
			end
			等待(2000)
			goto begin
		else
			回城()
			goto begin
		end
	end
	if(取物品数量("王冠")>1)then
		common.gotoBankTalkNpc()
		银行("全存","王冠")
		等待(2000)
		银行("取物","王冠",1)
		等待(2000)
		goto begin
	end
	自动寻路(165,153)	
	转向(4, "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")	
	等待到指定地图("利夏岛")	
	自动寻路(90,99,"国民会馆")	
	自动寻路(108,39,"雪拉威森塔１层")
	自动寻路(34,95)		
	转向(2, "")
	等待服务器返回()	
	对话选择("4", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	
::map59987::		--辛梅尔
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
		if(是否学一击必中==1)then
			自动寻路(318, 135)	
			日志("学一击必中的赶紧哦，10秒后继续下一步",1)
		end
		--对话选是(2)	.
		自动寻路(318, 148)		
		自动寻路(319, 148)		
		对话选择("4", "", "")	
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
	if(目标是否可达(282, 156))then		--第5个boss
		自动寻路(282, 156)		
		对话选是(5)				
	end
	if(目标是否可达(81, 138))then		--第6个boss
		自动寻路(81, 138)		
		对话选是(2)			
	end
	if(isTeamLeader)then
		if(队伍("人数") < 队伍人数)then	--数量不足 等待		
			if(目标是否可达(208, 239))then		--第一个boss
				common.makeTeam(队伍人数)					
			end					
		else
			for i,v in ipairs(bossData) do
				if(waitToNextBoss(v.name,v.x,v.y,v.nexty) == -1)then 			
					--回城()
					日志("没有打过boss，回城重来！")
					goto begin
				end		
				if(队伍("人数") < 队伍人数) then	
					日志("中途队友掉线，回城222",1)
					--回城()	
					等待(2000)
					goto begin
				end				
			end			
		end	
	else
		if(取队伍人数() > 1)then
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
			if(取当前地图编号()~=59982)then
				goto begin
			end
			if(目标是否可达(208, 239))then		--第一个boss
				common.joinTeam(队长名称)			
			end						
		end				
	end
	goto begin
::map59988::
	--等待到指定地图("？？？")		
	自动寻路(358, 173)		
	对话选是(0)
	goto begin
::map59986::
	--等待到指定地图("？？？")		
	自动寻路(139, 63)
	自动寻路(141, 61)	
	对话选是(0)
	goto begin

::yiji::	
	--等待到指定地图("？？？")	
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
	goto jieshu 
::pd::
	if(取当前地图名() == "？？？")then goto pd1 end 
	goto najiyi 
::pd1::
	自动寻路(318, 148)
	自动寻路(319, 148)
	
			
	对话选择("4", "", "")
	goto najiyi 
::jieshu::
	
	if(取物品数量("托尔丘的记忆") < 1)then goto  najiyi end
	回城()
::dashu::
	喊话("自动跑记忆脚本结束，星落制作，谢谢使用",02,03,05)
	
	等待(1000)
        goto dashu 
::hunt::
	等待(1000)
	if(是否战斗中())then goto  hunt end
	等待(2000)
	goto begin 
end
main()