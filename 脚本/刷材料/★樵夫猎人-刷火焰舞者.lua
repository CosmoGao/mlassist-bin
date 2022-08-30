刷十年戒指脚本,5转传教+4个攻人带改哥布林，4怪以上优先海盗即可，平均8-10分钟一趟，4天一个证。偶尔小帕翻车，无伤大雅

common=require("common")
设置("timer",20)
设置("高速延时",2)
设置("遇敌全跑",1)
设置("自动扔",1,"620032")		--1怪物硬币
设置("自动扔",1,"地的水晶碎片|水的水晶碎片|火的水晶碎片|风的水晶碎片|卡片？|魔石")
--local 水晶名称="风地的水晶（5：5）"
local 水晶名称="水火的水晶（5：5）"
local isTeamLeader=false		--是否队长
local 身上最少金币=5000			--少于去取
local 身上最多金币=1000000		--大于去存
local 身上预置金币=500000		--取和拿后 身上保留金币
local 脚本运行前时间=os.time()	--统计效率
local 脚本运行前金币=人物("金币")	--统计金币
local 已刷火舞总数=0				--统计刷总数
local 预设火舞档次=20			
local 工作技能名称="伐木"
local tradeArgs={topic="火焰舞者仓库信息",petName="火焰舞者"}
local skillMapItemCount={
	["5"]="3",
	["4"]="6",
	["3"]="10",
	["2"]="14"
}
--采集
function StartWork(itemName,itemCount,mapName,mapNum)
	while true do
		if(取包裹空格() < 1)then break end	-- 包满回城
		if(人物("魔") <  1)then 回城() end	-- 魔无回城
		if(取当前地图名() ~= mapName)then break end	--地图切换 也返回
		if(取当前地图编号() ~= mapNum)then break end	--地图切换 也返回
		if(取物品叠加数量(itemName) >= itemCount)then break end	--地图切换 也返回
		工作(工作技能名称,"",6000)	--技能名 物品名 延时时间
		等待工作返回(6000)
	end 	
end
function checkBagItems()
	叠("恶玉菌首领A",10)
	叠("恶玉菌首领B",10)
	叠("恶玉菌首领C",10)
	叠("恶玉菌首领D",10)
	等待(3000)
	local tgtItemName=""
	local items=物品信息()
	for i,v in ipairs(items) do
		if string.find(v.name,"恶玉菌首领") ~= nil and v.count > 6 then		
			local spacePosList=取包裹空格集合()
			for n,spacePos in ipairs(spacePosList) do
				交换物品(v.pos,spacePos,6)
				扔(v.pos)
				--日志("扔"..v.pos)
				等待(3000)
				break
			end
		end
	end
end
function 检测包裹宠物数量()
	if (人物("宠物数量") >= 5 )then	
		日志("宠物满了，去银行存货！")
		common.depositNoBattlePetToBank()
		if (人物("宠物数量") >= 5 )then	
			日志("银行宠物也满啦！去存仓库！")
			common.gotoFalanBankTalkNpc()
			tradeName=nil
			tradeBagSpace=nil
			if common.getTgtPetCount( "火焰舞者") > 0 then 
				common.gotoBankStorePetsAction(tradeArgs)
			end				
		end
		return true
	end
	return false
end
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
	if(取物品数量("鲶鱼大王的眼泪")>0 and 取物品数量("鲶鱼大王的胡须")>0 and 取物品数量("鲶鱼大王的金牙")>0)then
		已刷火舞总数=已刷火舞总数+1		
		日志("材料齐全，开奖咯！")
		local oldPetList=全部宠物信息()
		if(common.getTableSize(oldPetList) >= 5)then
			日志("自动开奖失败，宠物已满，请至少预留一个空位!")
		else
			自动寻路(13,14)		--酒吧 没判断地图 外部调用注意
			对话选是(2)		
			local newPetList = 全部宠物信息()
			local newPet = 取新开出的宠信息(oldPetList,newPetList)
			if(newPet ~= nil)then								
				if(newPet.grade == nil)then
					日志("未知")							
				else
					日志(newPet.grade)
					if(newPet.grade == 20 or newPet.grade==0)then
					
					elseif(newPet.grade > 预设火舞档次)then
						日志(newPet.realname.."【"..newPet.grade.."】档,档次低于设定值【"..预设火舞档次 .."】，丢弃")
						宠物("改名",newPet.grade,newPet.index)
						等待(3000)
						扔宠(newPet.index)
					end
				end										
			end
		end	
		
		common.statisticsTime(脚本运行前时间,脚本运行前金币)		
		日志("已刷火舞次数："..已刷火舞总数.."次",1)
	end
end
function 检查包裹空格()
	if(取包裹空格() < 6)then
		common.gotoFalanBankTalkNpc()
		银行("全存","鲶鱼大王的眼泪")	
		银行("全存","鲶鱼大王的胡须")	
		银行("全存","鲶鱼大王的金牙")	
		等待(2000)
		if(取包裹空格() < 6)then	--交易给仓库	
			if 取物品数量("鲶鱼大王的眼泪")>0 then common.gotoBankStoreItemsAction({topic="鲶鱼大王的眼泪",itemName="鲶鱼大王的眼泪"}) end
			if 取物品数量("鲶鱼大王的胡须")>0 then common.gotoBankStoreItemsAction({topic="鲶鱼大王的胡须",itemName="鲶鱼大王的胡须"}) end
			if 取物品数量("鲶鱼大王的金牙")>0 then common.gotoBankStoreItemsAction({topic="鲶鱼大王的金牙",itemName="鲶鱼大王的金牙"}) end			
		end
		return true
	end
	return false
end
function main()
	--checkBagItems()
	-- local test = 取包裹空格集合()
	-- for i,v in ipairs(test) do
		-- 日志(i.." "..v)
	-- end
	-- if true then return end
	日志("欢迎使用星落刷火焰舞者脚本",1)
	日志("当前职业："..人物("职业"),1)
	日志("当前职称："..人物("职称"),1)
	
	if(人物("职业") == "猎人")then
		工作技能名称="狩猎"
	elseif(人物("职业") == "樵夫")then
		工作技能名称="伐木"
	else
		日志("职业不是猎人或者樵夫,脚本退出",1)
		return
	end
	--common.baseInfoPrint()
	common.statisticsTime(脚本运行前时间,脚本运行前金币)	
	local skillLevel = common.playerSkillLv(工作技能名称)
	local needCount=14
	if(skillLevel>=5)then
		needCount=3
	elseif(skillLevel>=4)then
		needCount=6
	elseif(skillLevel>=3)then
		needCount=10
	elseif(skillLevel>=2)then
		needCount=14
	else
		日志("技能等级不够，脚本退出!",1)
		return		
	end
	local mapName=""
	local mapNum=0
::begin::	
	等待空闲()
	mapName = 取当前地图名()
	mapNum=取当前地图编号()
	if(mapNum==300)then goto map300
	elseif(mapNum==3000)then goto map3000		--加纳村
	elseif(mapNum==3008)then goto map3008		--酒吧
	elseif(mapNum==3099)then goto map3099		--加纳村的传送点
	elseif(mapNum==3012)then goto map3012		--村长的家
	elseif(mapNum==13500)then goto map13500
	elseif(mapNum==13501)then goto map13501
	elseif(mapNum==13502)then goto map13502
	elseif(mapNum==13503)then goto map13503
	elseif(mapNum==13504)then goto map13504
	elseif(mapNum==13505)then goto map13505
	elseif(mapNum==13506)then goto map13506
	elseif(mapNum==13507)then goto map13507
	elseif(mapNum==13508)then goto map13508
	elseif(mapNum==13509)then goto map13509
	elseif(mapNum==13510)then goto map13510
	elseif(mapNum==13511)then goto map13511
	elseif(mapNum==13512)then goto map13512	
	elseif(mapNum==13513)then goto map13513
	elseif(mapNum==13514)then goto map13514
	elseif(mapNum==13515)then goto map13515
	else
		if(检测包裹宠物数量())then goto begin end
		if(检查包裹空格())then	goto begin	end
		common.checkGold(身上最少金币,身上最多金币,身上预置金币)
		common.checkHealth(医生名称)
		common.checkCrystal(水晶名称)
		common.supplyCastle()
		common.sellCastle()		--默认卖	
		common.toTeleRoom("加纳村")
	end	
	等待(2000)
	goto begin
::map3008::			--酒吧
	自动寻路(3,3,"加纳村")
	goto begin
::map3099::			--加纳村的传送点
	自动寻路(5,12,"村长的家")	
::map3012::
	自动寻路(1,10,"加纳村")	
::map3000::
	common.checkGold(身上最少金币,身上最多金币,身上预置金币)
	if(人物("金币") < 5000)then 
		日志("没有魔币了，脚本退出",1)
		return
	end	
	if(取物品数量("鲶鱼大王的眼泪")>0 and 取物品数量("鲶鱼大王的胡须")>0 and 取物品数量("鲶鱼大王的金牙")>0)then		
		自动寻路(51,34,"酒吧")
		自动寻路(13,14)
		--对话选是(2)
		开奖()
		自动寻路(3,3,"加纳村")
	end	
	--酒吧出来 检测下宠物满没满
	if(检测包裹宠物数量())then goto begin end
	if(common.isNeedSupply())then
		自动寻路(52,72,"医院")
		自动寻路(9,9)
		回复(2)
		自动寻路(3,10)
		goto begin
	end
	自动寻路(47,77,"索奇亚")		--自动寻路(49,26,"索奇亚") 另一个门
::map300::
	if(人物("魔") < 200)then
		自动寻路(703,147,"加纳村")		--获取补魔
		自动寻路(52,72,"医院")
		自动寻路(9,9)
		回复(2)
		自动寻路(3,10)
		goto begin
	end
	if(取物品数量("鲶鱼大王的眼泪")>0 and 取物品数量("鲶鱼大王的胡须")>0 and 取物品数量("鲶鱼大王的金牙")>0)then
		自动寻路(703,147,"加纳村")		
		goto begin
	end
	if(检查包裹空格())then	goto begin	end
	自动寻路(626,209,"鲶鱼洞窟  地下1楼")	
::map13500::
	自动寻路(9,23,"鲶鱼洞窟  地下2楼")	
::map13501::
	自动寻路(40,32,"鲶鱼洞窟  地下3楼")	
::map13502::
	自动寻路(45,24,"鲶鱼洞窟的地底湖")	
::map13503::
	自动寻路(39,32)	
	对话选是(2)
	goto begin
::map13504::
	goto begin
::map13505::			--鲶鱼大王的口内
	自动寻路(26,18)	
	对话选是(2)
::map13506::			--鲶鱼大王的胃袋
	自动寻路(56,7)	
	扔("恶玉A菌")
	扔("恶玉B菌")
	扔("恶玉C菌")
	对话选是(2)
::map13507::			--鲶鱼大王的胃袋
	-- if(取物品数量("抗生素T-5") > 0 )then
	-- end
	if(工作技能名称=="狩猎")then	
		if(取物品叠加数量("恶玉C菌") < needCount)then
			自动寻路(40,30)	
			StartWork("恶玉C菌",needCount,"鲶鱼大王的胃袋",13507)		
		elseif(取物品叠加数量("恶玉A菌") < needCount)then
			自动寻路(40,40)	
			StartWork("恶玉A菌",needCount,"鲶鱼大王的胃袋",13507)	
		elseif(取物品叠加数量("恶玉B菌") < needCount)then
			自动寻路(70,70)	
			StartWork("恶玉B菌",needCount,"鲶鱼大王的胃袋",13507)	
		else
			自动寻路(97,85)	
			对话选是(2)
		end	
	else
		if(取物品叠加数量("恶玉A菌") < needCount)then
			自动寻路(40,30)	
			StartWork("恶玉A菌",needCount,"鲶鱼大王的胃袋",13507)		
		elseif(取物品叠加数量("恶玉B菌") < needCount)then
			自动寻路(40,40)	
			StartWork("恶玉B菌",needCount,"鲶鱼大王的胃袋",13507)	
		elseif(取物品叠加数量("恶玉C菌") < needCount)then
			自动寻路(70,70)	
			StartWork("恶玉C菌",needCount,"鲶鱼大王的胃袋",13507)	
		else
			自动寻路(97,85)	
			对话选是(2)
		end	
	end
	goto begin
::map13508::
	if(工作技能名称=="狩猎")then	
		if(取物品叠加数量("恶玉B菌") < needCount)then
			自动寻路(40,30)	
			StartWork("恶玉B菌",needCount,"鲶鱼大王的胃袋",13508)		
		elseif(取物品叠加数量("恶玉C菌") < needCount)then
			自动寻路(40,40)	
			StartWork("恶玉C菌",needCount,"鲶鱼大王的胃袋",13508)	
		elseif(取物品叠加数量("恶玉A菌") < needCount)then
			自动寻路(70,70)	
			StartWork("恶玉A菌",needCount,"鲶鱼大王的胃袋",13508)	
		else
			自动寻路(97,85)	
			对话选是(2)
		end	
	else
		if(取物品叠加数量("恶玉C菌") < needCount)then
			自动寻路(40,30)	
			StartWork("恶玉C菌",needCount,"鲶鱼大王的胃袋",13508)		
		elseif(取物品叠加数量("恶玉A菌") < needCount)then
			自动寻路(40,40)	
			StartWork("恶玉A菌",needCount,"鲶鱼大王的胃袋",13508)	
		elseif(取物品叠加数量("恶玉B菌") < needCount)then
			自动寻路(70,70)	
			StartWork("恶玉B菌",needCount,"鲶鱼大王的胃袋",13508)	
		else
			自动寻路(97,85)	
			对话选是(2)
		end	
	end
	goto begin
::map13509::
	if(工作技能名称=="狩猎")then
		if(取物品叠加数量("恶玉A菌") < needCount)then			
			自动寻路(40,30)	
			StartWork("恶玉A菌",needCount,"鲶鱼大王的胃袋",13509)		
		elseif(取物品叠加数量("恶玉B菌") < needCount)then
			自动寻路(40,40)	
			StartWork("恶玉B菌",needCount,"鲶鱼大王的胃袋",13509)	
		elseif(取物品叠加数量("恶玉C菌") < needCount)then
			自动寻路(70,70)	
			StartWork("恶玉C菌",needCount,"鲶鱼大王的胃袋",13509)	
		else
			自动寻路(97,85)	
			对话选是(2)
		end	

	else
		if(取物品叠加数量("恶玉B菌") < needCount)then
			自动寻路(40,30)	
			StartWork("恶玉B菌",needCount,"鲶鱼大王的胃袋",13509)		
		elseif(取物品叠加数量("恶玉C菌") < needCount)then
			自动寻路(40,40)	
			StartWork("恶玉C菌",needCount,"鲶鱼大王的胃袋",13509)	
		elseif(取物品叠加数量("恶玉A菌") < needCount)then
			自动寻路(70,70)	
			StartWork("恶玉A菌",needCount,"鲶鱼大王的胃袋",13509)	
		else
			自动寻路(97,85)	
			对话选是(2)
		end	
	end	
	goto begin
::map13510::			--鲶鱼大王的通道
	自动寻路(25,14)	
	扔("恶玉A菌")
	扔("恶玉B菌")
	扔("恶玉C菌")
	对话选是(2)
	goto begin
::map13511::
	if(取物品叠加数量("恶玉C菌") < needCount)then
		自动寻路(28,30)
		StartWork("恶玉C菌",needCount,"鲶鱼大王的大肠",13511)		
	elseif(取物品叠加数量("恶玉B菌") < needCount)then
		自动寻路(13,38)	
		StartWork("恶玉B菌",needCount,"鲶鱼大王的大肠",13511)	
	elseif(取物品叠加数量("恶玉A菌") < needCount)then
		自动寻路(32,66)
		StartWork("恶玉A菌",needCount,"鲶鱼大王的大肠",13511)	
	else
		自动寻路(45,74)		
		对话选是(2)
	end
	goto begin
::map13512::
	if(取物品叠加数量("恶玉C菌") < needCount)then
		自动寻路(14,49)
		StartWork("恶玉C菌",needCount,"鲶鱼大王的大肠",13512)	
	elseif(取物品叠加数量("恶玉A菌") < needCount)then
		自动寻路(26,52)
		StartWork("恶玉A菌",needCount,"鲶鱼大王的大肠",13512)	
	elseif(取物品叠加数量("恶玉B菌") < needCount)then
		自动寻路(17,68)	
		StartWork("恶玉B菌",needCount,"鲶鱼大王的大肠",13512)	
	else
		自动寻路(45,74)		
		对话选是(2)
	end	
	goto begin
::map13513::			--鲶鱼大王的大肠
	if(取物品叠加数量("恶玉A菌") < needCount)then
		自动寻路(3,33)	
		StartWork("恶玉A菌",needCount,"鲶鱼大王的大肠",13513)
	elseif(取物品叠加数量("恶玉C菌") < needCount)then
		自动寻路(34,46)				
		StartWork("恶玉C菌",needCount,"鲶鱼大王的大肠",13513)	
	elseif(取物品叠加数量("恶玉B菌") < needCount)then
		自动寻路(76,19)	
		StartWork("恶玉B菌",needCount,"鲶鱼大王的大肠",13513)
	else
		自动寻路(77,26)	
		对话选是(0)
	end		
	goto begin
::map13514::			--鲶鱼大王的通道
	自动寻路(25,14)	
	扔("恶玉A菌")
	扔("恶玉B菌")
	扔("恶玉C菌")
	对话选是(2)
	goto begin
::map13515::			--鲶鱼大王的小肠
	if(取物品叠加数量("恶玉菌首领C") < 6)then
		自动寻路(65,13)
		StartWork("恶玉菌首领C",6,"鲶鱼大王的小肠",13515)	
	elseif(取物品叠加数量("恶玉菌首领D") < 6)then
		自动寻路(45,16)
		StartWork("恶玉菌首领D",6,"鲶鱼大王的小肠",13515)	
	elseif(取物品叠加数量("恶玉菌首领B") < 6)then
		自动寻路(24,29)	
		StartWork("恶玉菌首领B",6,"鲶鱼大王的小肠",13515)		
	elseif(取物品叠加数量("恶玉菌首领A") < 6)then
		自动寻路(25,55)		
		StartWork("恶玉菌首领A",6,"鲶鱼大王的小肠",13515)	
	else
		自动寻路(47,64)
		checkBagItems()
		对话选是(2)
	end	
	goto begin    
end
main()