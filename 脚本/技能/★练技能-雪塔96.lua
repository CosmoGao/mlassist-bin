全程自动跑96层刷箱子！遇到： 伊鲁特奇美拉 欧特奇美拉 欧奴奇美拉 艾德奇美拉 只打依鲁特奇美拉 可设置逃跑！

common=require("common")


	设置("timer", 100)						-- 设置定时器，单位毫秒
						-- 设置定时器，单位毫秒

--	设置("自动战斗", 1)                     -- 开启自动战斗，0不自动战斗，1自动战斗
--	设置("高速延时", 1)                     -- 高速战斗时的操作等待时间单位秒，3以上为好，不然容易断线
--	设置("高速延时", 4)                  -- 高速战斗速度，0速度最低，6速度最高       -- 自动遇敌  				
     
	补血值=用户输入框( "多少血以下去补给", "400")
	补魔值=用户输入框( "多少魔以下去补给", "400")
	宠补血值=用户输入框( "宠多少血以下去补给", "400")
	宠补魔值=用户输入框( "宠多少魔以下去补给", "50")

技能名称=""
指定技能等级切换=10


function 获取人物技能名称列表()
	local skills={}
	local playerData = 人物信息()
	for i,skill in ipairs(playerData.skill) do
		table.insert(skills,skill.name)
	end
	return skills
end
function 技能等级()
	local playerData = 人物信息()
	for i,skill in ipairs(playerData.skill) do
		if(skill.name == 技能名称)then
			日志("技能等级："..技能名称..skill.lv)
			return skill.lv
		end
	end
	return 0
end
function 拿钱()
	if(人物("金币") < 100000) then
		common.gotoBankTalkNpc()
	end
::begin::
	if(人物("金币") < 100000) then
		自动寻路(41,30)
		转向(2)
		银行("取钱",-500000)
		if(银行("金币") < 500000 and 人物("金币") < 500000)then
			转向(4)
			交易("￠秋雨￡落￠","","金币:500000",10000)
		end
	else
		return
	end
	goto begin
end

function main()
	是否切换下个技能=用户下拉框("是否自动切换下个技能",{"是","否"})
	if(是否切换下个技能=="是")then
		技能名称=用户下拉框("练技能的名称",获取人物技能名称列表())--	"强力恢复魔法"
		指定技能等级切换=用户输入框( "指定技能等级切换下一个配置\n(达到技能，切换下一个烧技能配置)", "10")
		下个烧技能配置=用户输入框( "下个烧技能配置\n(达到技能，切换下一个烧技能配置)", "配置/96练技能气绝回复.save")
		日志(指定技能等级切换,1)
		日志(下个烧技能配置,1)
	end
::kaishi::
	common.checkHealth()
	common.supplyCastle()
	回城()	
	等待到指定地图("艾尔莎岛", 1)
	等待(200)

	if(取物品数量( "塞特的护身符") >  0)then goto  saite end	
	自动寻路(165, 151)
	自动寻路(165, 153)
	转向(4, "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("利夏岛")
	等待(200)
	自动寻路(90, 98)
	自动寻路( 90, 99)
	等待到指定地图("国民会馆")	
	自动寻路(108, 54)
	回复(1)
	自动寻路(108, 39)
	等待到指定地图("雪拉威森塔１层")
	自动寻路(75, 51)
	自动寻路(75, 50)
	等待到指定地图("雪拉威森塔５０层")
	自动寻路(16, 44)
	等待到指定地图("雪拉威森塔９５层")
	自动寻路(26, 104)
	自动寻路(27, 104)
::tisi4::
	转向(2, "")
	等待服务器返回()
	对话选择("32", "", "")
	对话选择("4", "", "")
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	等待到指定地图("雪拉威森塔９６层")
	回城()
	等待到指定地图("艾尔莎岛")
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("里谢里雅堡")
	自动寻路(34, 89)
	回复(1)
::saite::
	使用物品("塞特的护身符")
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("雪拉威森塔９５层")
	if(取物品数量( "塞特的护身符") <  1)then goto  saite1 end
	转向(2, "")
	等待服务器返回()
	对话选择("1", "", "")
	等待到指定地图("雪拉威森塔９６层")
	自动寻路(30,101)
::yd::
    开始遇敌()         -- 开始自动遇敌
  	goto scriptstart 
::scriptstart::
	--战斗中会停在此句 节省资源
	if(人物("血") < 补血值)then goto  ting end
	if(人物("魔") < 补魔值)then goto  ting end
	if(宠物("血") < 宠补血值)then goto  ting end
	if(宠物("魔") < 宠补魔值)then goto  ting end
	goto scriptstart          --自动遇敌中 循环判断血魔
::ting::
	清除系统消息()
	停止遇敌()
	等待(5000)		--离谱 回城了 还能遇敌
	等待空闲()
	回城()
	等待到指定地图("艾尔莎岛")
	转向(1, "")
	等待服务器返回()
	对话选择("4", "", "")
	等待到指定地图("里谢里雅堡")	
	自动寻路(34, 89)
	回复(1)
	if(人物("金币") < 100000) then
		common.getMoneyFromBank(300000)		
	end
	common.checkHealth()	
	if(是否切换下个技能=="是")then
		if(技能等级() >= 指定技能等级切换)then
			--读取配置("配置/96练技能气绝回复.save")
			读取配置(下个烧技能配置)
		end
	end
	goto saite 
::saite1::	
	转向(2, "")
	等待服务器返回()
	对话选择("32", "", "")
	对话选择("4", "", "")
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	等待到指定地图("雪拉威森塔９６层")
	自动寻路(30,101)
	goto yd 
end
main()