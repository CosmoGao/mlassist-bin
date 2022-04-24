艾岛启动，抽技能草，自己吃

设置("自动扔",1,"卡片？")
设置("自动扔",1,"艾夏糖")
设置("自动扔",1,"串烧哥布林")
设置("自动扔",1,"家族兽之笛")
设置("自动扔",1,"绿头盔")
设置("自动扔",1,"红头盔")
设置("自动扔",1,"赖光的头盔")
设置("自动扔",1,"中型的土之宝石")
设置("自动扔",1,"中型的水之宝石")
设置("自动扔",1,"中型的火之宝石")
设置("自动扔",1,"中型的风之宝石")
--设置("自动扔",1,"生命力回复药（75）")
设置("自动扔",1,"魔石")
设置("timer",100)
技能名称="精灵的盟约"
技能等级=8		--停止等级

function main()
::begin::
	等待空闲()
	当前地图名=取当前地图名()
	mapNum=取当前地图编号()
	if(当前地图名=="艾尔莎岛")then
		goto aiersha	
	elseif (当前地图名=="利夏岛" )then	
		goto map59522
	elseif (当前地图名=="国民会馆" )then	
		goto map59552
	elseif (当前地图名=="雪拉威森塔１层" )then	
		goto map59801
	elseif (当前地图名=="雪拉威森塔２５层" )then	
		goto map59825	
	end
	等待(1000)
	回城()
	goto begin 
::aiersha::	
	移动(165, 153)
	转向(4)
	等待服务器返回()
	对话选择(32,0)
	等待服务器返回()
	对话选择(4, 0)		
::map59522::					--利夏岛
	if(取当前地图名() ~= "利夏岛")then
		goto begin
	end
	移动(90,99,"国民会馆")
::map59552::					--国民会馆
	移动(108,39,"雪拉威森塔１层")
	goto begin
::map59801::					--雪拉威森塔１层
	移动(76,52,"雪拉威森塔２５层")		
	goto begin
	
::map59825::
	移动(95,34)
	兑换100怪物硬币()
	if(common.playerSkillLv(技能名称)>=技能等级)then
		return
	end
	goto begin
end
	
	
function 兑换100怪物硬币()
	local position=1
::begin::
	移动(95,34)
	转向(0)
	while(取物品数量("鲈鱼饭团") > 0)do
		if(取物品数量("鲈鱼饭团") > 1)then
			扔("鲈鱼饭团")
		end		
		使用物品("鲈鱼饭团")
		等待服务器返回()
		对话选择(1,0)
		等待(1000)
		local tryNum=0
		while(取物品数量("布斯特药草")>0) do
			使用物品("布斯特药草")
			if(tryNum > 100)then
				日志("技能等级满了，不能使用",1)
			end
			tryNum=tryNum+1
		end
		tryNum=0
		while(取物品数量("特级布斯特药草")>0) do
			使用物品("特级布斯特药草")
			if(tryNum > 100)then
				日志("技能等级满了，不能使用",1)
			end
			tryNum=tryNum+1
		end
		
		while(取物品数量("生命力回复药（75）") > 0) do
			使用物品("生命力回复药（75）")	
			--等待菜单返回()
			菜单选择(0,"")
			菜单项选择(0,"")			
		end
		if(string.find(最新系统消息(),"无法放置")~=nil)then
			if(position == 1)then goto 移位1 
			elseif(position == 2)then goto 移位2
			elseif(position == 3)then goto 移位3 
			elseif(position == 4)then goto 移位4 
			elseif(position == 5)then goto 移位5 		
			elseif(position == 6)then goto 移位6
			end
			goto 移位1	
		elseif(string.find(聊天(50),"获得了 天狼星")~=nil)then
			清除系统消息()
			if (人物("宠物数量") >= 5 )then	
				日志("宠物满了，去银行存货！")
				common.depositNoBattlePetToBank()
				if (人物("宠物数量") >= 5 )then	
					日志("银行宠物也满啦！请先清理，再重新执行脚本！")
					return
				end
				return
			end
		end
		if(取物品叠加数量("５怪物硬币") < 100 and 取物品叠加数量("１０怪物硬币") < 100  and 取物品数量("１０００怪物硬币") < 1 and 取物品数量("１万怪物硬币") < 1)then
			日志("没有怪物硬币了",1)
			return
		end		
	end
	if(取物品数量("鲈鱼饭团") < 1)then
		if(string.find(最新系统消息(),"无法放置")~=nil)then
			if(position == 1)then goto 移位1 
			elseif(position == 2)then goto 移位2
			elseif(position == 3)then goto 移位3 
			elseif(position == 4)then goto 移位4 
			elseif(position == 5)then goto 移位5 		
			elseif(position == 6)then goto 移位6
			end
			goto 移位1	
		else
			喊话("厨师呕心沥血的料理",2,3,5)
			等待服务器返回()
			对话选择(4,0)
			等待服务器返回()
			对话选择(1,0)
		end		
	end
	if(取物品叠加数量("５怪物硬币") < 100 and 取物品叠加数量("１０怪物硬币") < 100)then
		--大换小
		移动(97,31)
		if(取物品数量("１万怪物硬币") > 0 )then			
			if(取物品数量("１０００怪物硬币") < 1)then
				转向(0)
				等待服务器返回()
				对话选择(32,0)
				等待服务器返回()
				对话选择(4,0)			
				等待服务器返回()
				对话选择(4,0)		
			end		
			if(取物品叠加数量("１０怪物硬币") < 100)then
				转向(0)
				等待服务器返回()
				对话选择(32,0)
				等待服务器返回()
				对话选择(4,0)
				等待服务器返回()
				对话选择(8,0)
				等待服务器返回()
				对话选择(4,0)	
			end	
		elseif(取物品数量("１０００怪物硬币") > 0)then
			if(取物品叠加数量("１０怪物硬币") < 100)then
				转向(0)
				等待服务器返回()
				对话选择(32,0)
				等待服务器返回()
				对话选择(4,0)				
				等待服务器返回()
				对话选择(4,0)	
			end	
		end
	end
	if(common.playerSkillLv(技能名称)>=技能等级)then
		return
	end
	等待(1000)		
	goto begin
::移位1::
	清除系统消息()
	移动(93,34)
	等待(2000)
	移动(90,32)
	等待(2000)
	移动(88,34)
	position=position+1
	goto begin
::移位2::
	清除系统消息()
	移动(97,34)
	等待(2000)
	移动(99,34)
	等待(2000)
	移动(99,36)
	position=position+1
	goto begin
::移位3::
	清除系统消息()
	移动(99,39)
	等待(2000)
	移动(98,41)
	等待(2000)
	移动(96,41)
	position=position+1
	goto begin
::移位4::
	清除系统消息()
	移动(95,36)
	等待(2000)
	移动(95,39)
	等待(2000)
	移动(93,40)
	position=position+1
	goto begin
::移位5::
	移动(90,41)
	等待(2000)
	移动(88,43)
	等待(2000)
	移动(90,37)
	position=position+1
	goto begin
::移位6::
	移动(92,36)
	等待(2000)
	移动(89,36)
	等待(2000)
	移动(87,36)
	position=1
	goto begin
end
main()