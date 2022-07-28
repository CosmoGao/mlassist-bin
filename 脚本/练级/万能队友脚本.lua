★里谢里雅堡、高地、洞窟村、砍村、雪塔、营地、矮人、石头、蜥蜴、黑龙、龙鼎万能队员脚本，自动补血、卖石、换取徽章、士兵牌,【脚本停止7秒重启动】。1转、2转、UD自动拿道具。

设置("timer", 100)



设置("自动战斗", 1)
设置("高速战斗", 1)
设置("高速延时", 3)
::begin::
	if(取物品数量( "树苗？") >  0)then goto  huiqu end
	if(string.find(最新系统消息()," 您将被强制离开")~=nil)then goto offlinechat	end
	if(取当前地图名() ==  "里谢里雅堡")then goto chengbao end
	if(取当前地图名() ==  "艾尔莎岛")then goto 新城 end
	if(取当前地图名() ==  "辛希亚探索指挥部")then goto ydq end
	if(取当前地图名() ==  "国民会馆")then goto huiguan end
	if(取当前地图名() ==  "冒险者旅馆")then goto 旅馆 end
	if(取当前地图名() ==  "医院")then goto yingdi end
	if(取当前地图名() ==  "公寓")then goto yingdi end
	if(取当前地图名() ==  "工房")then goto gongfang end
	if(取当前地图名() ==  "酒吧")then goto najiuping end
	if(取当前地图名() ==  "肯吉罗岛")then goto huandunpai end
	if(取当前地图名() ==  "矮人城镇")then goto airen end
	if(取当前地图名() ==  "洞窟之村　第２层")then goto dongku end
	if(取当前地图名() ==  "医院2楼")then goto erzhuan end
	if(取当前地图名() ==  "叹息森林")then goto tanxi end
	if(取当前地图名() ==  "莎莲娜")then goto ud end
	if(取当前地图名() ==  "回复之间")then goto hfzj end
	if(取当前地图名() ==  "大厅")then goto dating end
	if(取当前地图名() ==  "圣坛")then goto shengtan end
	if(取当前地图名() ==  "阿尔杰斯的慈悲")then goto cibei end
	if(取当前地图名() ==  "启程之间")then goto 传送 end
	if(取当前地图名() ==  "神殿　伽蓝")then goto 神殿 end
	if(取当前地图名() ==  "约尔克神庙")then goto 神庙 end
	if(取当前地图名() ==  "梅布尔隘地")then goto 隘地 end
	if(取当前地图名() ==  "？？？")then goto 神之召唤 end   
	if(取当前地图名() ==  "民家")then goto 双王 end     
	if(取当前地图名() ==  "民家地下")then goto 双王碎片 end  
	goto begin 
::ydq::
	if(人物("坐标")  == "6,22")then	goto ydq1 end
        if(人物("坐标")  == "7,22")then	goto ydq2 end
        if(人物("坐标")  == "8,22")then	goto ydq3 end
       	goto begin 
::ydq1::
	
	转向(1, "")		-- 转向北
	
	goto begin 
::ydq2::
	
	转向(0, "")		-- 转向北
	
	goto begin 
::ydq3::
	
	转向(7, "")		-- 转向北
	
	goto begin 
::chengbao::
        if(人物("坐标")  == "34,88")then	goto cbbuxue1 end
        if(人物("坐标")  == "34,89")then	goto cbbuxue2 end
        if(人物("坐标")  == "34,87")then	goto cbbuxue3 end
        if(人物("坐标")  == "30,79")then	goto cbmai1 end
        if(人物("坐标")  == "31,78")then	goto cbmai2 end
        if(人物("坐标")  == "31,77")then	goto cbmai3 end
        if(人物("坐标")  == "31,76")then	goto cbmai4 end
        if(人物("坐标")  == "30,76")then	goto cbmai5 end
        if(人物("坐标")  == "29,76")then	goto cbmai6 end
        if(人物("坐标")  == "29,77")then	goto cbmai7 end
	goto begin 
::huiguan::
        if(人物("坐标")  == "107,52")then	goto ydbumo7 end
        if(人物("坐标")  == "107,51")then	goto ydbumo6 end
        if(人物("坐标")  == "108,51")then	goto ydbumo5 end
        if(人物("坐标")  == "109,51")then	goto ydbumo4 end
        if(人物("坐标")  == "109,52")then	goto ydbumo3 end
        if(人物("坐标")  == "108,54")then	goto ydbumo1 end
        if(人物("坐标")  == "109,42")then	goto cbmai7 end
        if(人物("坐标")  == "109,43")then	goto gfsale1 end
        if(人物("坐标")  == "110,43")then	goto cbmai1 end
        if(人物("坐标")  == "110,43")then	goto cbmai2 end
	goto begin 
::dongku::
        if(人物("坐标")  == "146,163")then	goto bumo1 end
	if(人物("坐标")  == "147,163")then	goto bumo2 end
        if(人物("坐标")  == "145,163")then	goto bumo3 end  
        if(人物("坐标")  == "150,171")then	goto bumo2 end
        if(人物("坐标")  == "148,171")then	goto bumo3 end
        if(人物("坐标")  == "149,171")then	goto bumo1 end
	if(人物("坐标")  == "148,169")then	goto bumo4 end
        if(人物("坐标")  == "148,170")then	goto bumo5 end        
	goto begin 


::bumo1::
        回复(1)		
	
	等待(1000)
        goto begin 
::bumo2::
        回复(8)		
	
	等待(1000)
        goto begin 
::bumo3::
        回复(2)		
	
	等待(1000)
        goto begin 
::bumo4::
        回复(4)		
	
	等待(1000)
        goto begin 
::bumo5::
        回复(3)		
	
	等待(1000)
        goto begin 




::cbbuxue1::
	回复(2)
	
	等待(1000)
	goto begin 
::cbbuxue2::
	回复(1)
	
	等待(1000)
	goto begin 
::cbbuxue3::
	回复(3)
	
	等待(1000)
	goto begin 
::cbmai1::
	卖(0, "魔石")		
	
	等待(1000)
	goto begin 
::cbmai2::
	卖(7, "魔石")		
	
	等待(1000)
	goto begin 
::cbmai3::
	卖(6, "魔石")		
	
	等待(1000)
	goto begin 
::cbmai4::
	卖(5, "魔石")		
	
	等待(1000)
        goto begin 
::cbmai5::
	卖(4, "魔石")		
	
	等待(1000)
	goto begin 
::cbmai6::
	卖(3, "魔石")		
	
	等待(1000)
	goto begin 
::cbmai7::
	卖(2, "魔石")		
	
	goto begin 
::yingdi::
        if(人物("坐标")  == "6,5")then	goto nahuoba end	
	if(人物("坐标")  == "10,5")then	goto ydbumo7 end		--杰村
        if(人物("坐标")  == "10,12")then	goto ydbumo1 end
	if(人物("坐标")  == "11,12")then	goto ydbumo2 end
	if(人物("坐标")  == "11,11")then	goto ydbumo3 end
        if(人物("坐标")  == "11,10")then	goto ydbumo4 end
        if(人物("坐标")  == "10,10")then	goto ydbumo5 end
        if(人物("坐标")  == "9,10")then	goto ydbumo6 end
        if(人物("坐标")  == "9,11")then	goto ydbumo7 end
        if(人物("坐标")  == "9,12")then	goto ydbumo8 end
        if(人物("坐标")  == "35,47")then	goto ydbumo8 end
        if(人物("坐标")  == "35,46")then	goto ydbumo7 end
        if(人物("坐标")  == "35,45")then	goto ydbumo6 end
        if(人物("坐标")  == "35,44")then	goto ydbumo8 end
        if(人物("坐标")  == "35,43")then	goto ydbumo7 end
        if(人物("坐标")  == "35,42")then	goto ydbumo6 end
        if(人物("坐标")  == "16,8")then	goto bumo1 end
	if(人物("坐标")  == "17,8")then	goto bumo2 end
        if(人物("坐标")  == "15,8")then	goto bumo3 end 
	if(人物("坐标")  == "15,9")then	goto ydbumo1 end		--杰村 
        if(人物("坐标")  == "18,15")then	goto bumo1 end
 	if(人物("坐标")  == "18,13")then	goto ydbumo5 end
	if(人物("坐标")  == "17,13")then	goto ydbumo6 end
	if(人物("坐标")  == "17,14")then	goto ydbumo7 end
 	if(人物("坐标")  == "19,14")then	goto bumo2 end
        if(人物("坐标")  == "19,15")then	goto bumo2 end
        if(人物("坐标")  == "17,15")then	goto bumo3 end   
	if(人物("坐标")  == "89,58")then	goto ydbumo1 end  
	if(人物("坐标")  == "91,58")then	goto ydbumo1 end 
	if(人物("坐标")  == "88,57")then	goto ydbumo7 end  
	if(人物("坐标")  == "90,57")then	goto ydbumo7 end  
	if(人物("坐标")  == "88,58")then	goto ydbumo8 end
	if(人物("坐标")  == "90,58")then	goto ydbumo8 end
	if(人物("坐标")  == "92,58")then	goto ydbumo2 end
	goto begin 
::ydbumo1::
        回复(1)		
	
	等待(1000)
        goto begin 
::ydbumo2::
        回复(0)		
	
	等待(1000)
        goto begin 
::ydbumo3::
        回复(7)		
	
	等待(1000)
        goto begin 	
::ydbumo4::
        回复(6)		
	
	等待(1000)
        goto begin 
::ydbumo5::
        回复(5)		
	
	等待(1000)
        goto begin 
::ydbumo6::
        回复(4)		
	
	等待(1000)
        goto begin 
::ydbumo7::
        回复(3)		
	
	等待(1000)
        goto begin 
::ydbumo8::
        回复(2)		
	
	等待(1000)
        goto begin 

::gongfang::
        if(人物("坐标")  == "20,24")then	goto gfsale1 end
        if(人物("坐标")  == "20,23")then	goto gfsale2 end
        if(人物("坐标")  == "20,22")then	goto gfsale3 end
        if(人物("坐标")  == "21,22")then	goto gfsale4 end
	goto begin 
::gfsale1::
	卖(1, "魔石")		
	
	卖(1, "水晶怪的卡片")
	
	卖(1, "绿色口臭鬼的卡片")
	
	卖(1, "虎头蜂的卡片")
	
	卖(1, "锹型虫的卡片")
	
	卖(1,"狮鹫兽的卡片")
	
	卖(1,"水蜘蛛的卡片")
	
        喊话("队员卖石完毕~~",01,03,04)
        
        等待(1000)
	goto begin 
::gfsale2::
	卖(2, "魔石")		
	
	卖(2, "水晶怪的卡片")
	
	卖(2, "绿色口臭鬼的卡片")
	
	卖(2, "虎头蜂的卡片")
	
	卖(2, "锹型虫的卡片")
	
	卖(2,"狮鹫兽的卡片")
	
	卖(2,"水蜘蛛的卡片")
	
        喊话("队员卖石完毕~~",01,03,04)
        
        等待(1000)
	goto begin 
::gfsale3::
	卖(3, "魔石")		
	
	卖(3, "水晶怪的卡片")
	
	卖(3, "绿色口臭鬼的卡片")
	
	卖(3, "虎头蜂的卡片")
	
	卖(3, "锹型虫的卡片")
	
	卖(3,"狮鹫兽的卡片")
	
	卖(3,"水蜘蛛的卡片")
	
        喊话("队员卖石完毕~~",01,03,04)
        
        等待(1000)
	goto begin 
::gfsale4::
	卖(4, "魔石")		
	
	卖(4, "水晶怪的卡片")
	
	卖(4, "绿色口臭鬼的卡片")
	
	卖(4, "虎头蜂的卡片")
	
	卖(4, "锹型虫的卡片")
	
	卖(4,"狮鹫兽的卡片")
	
	卖(4,"水蜘蛛的卡片")
	
        喊话("队员卖石完毕~~",01,03,04)
        
        等待(1000)
	goto begin 
::najiuping::
	
	转向(8, "")
	等待服务器返回()
        对话选择("32", "", "")           --4代表选是
        对话选择("32", "", "")           --8代表选否
        对话选择("32", "", "")           --32代表下一步  
	对话选择("32", "", "")	    --1代表确定
	对话选择("32", "", "")
	对话选择("32", "", "")
	对话选择("1", "", "")
	对话选择("1", "", "")
        等待(1000)
	if(string.find(最新系统消息()," 巴萨的破酒瓶")~=nil)then goto  tishi1	end
        
	goto begin 
::huandunpai::
        if(人物("坐标")  == "475,209")then	goto huandun1 end
	if(人物("坐标")  == "476,209")then	goto huandun2 end
	if(人物("坐标")  == "476,208")then	goto huandun3 end
        if(人物("坐标")  == "476,207")then	goto huandun4 end
        if(人物("坐标")  == "475,207")then	goto huandun5 end
        if(人物("坐标")  == "474,207")then	goto huandun6 end
        if(人物("坐标")  == "474,208")then	goto huandun7 end
        if(人物("坐标")  == "474,209")then	goto huandun8 end
	goto begin 
::huandun1::
	
	转向(0, "")
	等待服务器返回()
	if(取物品数量( "龙角") >  "0")then goto  longjiao end
	goto begin 
::huandun2::
	
	转向(7, "")
	等待服务器返回()
	if(取物品数量( "龙角") >  "0")then goto  longjiao end
	goto begin 
::huandun3::
	
	转向(6, "")
	等待服务器返回()
	if(取物品数量( "龙角") >  "0")then goto  longjiao end
	goto begin 
::huandun4::
	
	转向(5, "")
	等待服务器返回()
	if(取物品数量( "龙角") >  "0")then goto  longjiao end
	goto begin 
::huandun5::
	
	转向(4, "")
	等待服务器返回()
	if(取物品数量( "龙角") >  "0")then goto  longjiao end
	goto begin 
::huandun6::
	
	转向(3, "")
	等待服务器返回()
	if(取物品数量( "龙角") >  "0")then goto  longjiao end
	goto begin 
::huandun7::
	
	转向(2, "")
	等待服务器返回()
	if(取物品数量( "龙角") >  "0")then goto  longjiao end
	goto begin 
::huandun8::
	
	转向(1, "")
	等待服务器返回()
	if(取物品数量( "龙角") >  "0")then goto  longjiao end
	goto begin 
::longjiao::
	if(取物品数量( "收集箱") >  "0")then goto  xiangzi end
        对话选择("32", "", "")         
        对话选择("32", "", "")        
::xiangzi::
        对话选择("32", "", "")            
	对话选择("1", "", "")
	goto bugei 
::bugei::
	使用物品("加强补给品")
	对话选择("4", "", "")
        等待(500)
	使用物品("加强补给品")
	对话选择("4", "", "")
        等待(500)
	if(取物品数量( "龙角") > "30")then goto  xiangzi end
	goto begin 
::airen::
	if(string.find(聊天(50),"全队装备矮人徽章")~=nil)then goto  zbhuizhang	end
	if(人物("坐标")  == "163,94")then	goto arbumo end
	if(人物("坐标")  == "163,95")then	goto arbumo end
	if(人物("坐标")  == "121,111")then	goto arsale1 end       
	if(人物("坐标")  == "121,110")then	goto arsale2 end
	if(人物("坐标")  == "121,109")then	goto arsale3 end
	if(人物("坐标")  == "97,123")then	goto huizhang1 end
	if(人物("坐标")  == "97,124")then	goto huizhang2 end
	if(人物("坐标")  == "97,125")then	goto huizhang3 end
	goto begin 
::arbumo::
	回复("east")		
	
	等待(1000)
        goto begin 
::arsale1::
	卖(1, "魔石")		
	
	等待(1000)
	goto begin 
::arsale2::
	卖(2, "魔石")		
	
	等待(1000)
	goto begin 
::arsale3::
	卖(3, "魔石")		
	
	等待(1000)
	goto begin 
::huizhang1::
	if(取物品数量( "矮人徽章") >  "0")then goto  begin end
	
	转向(5, "")
	等待服务器返回()
        对话选择("32", "", "")         
        对话选择("32", "", "")           
        对话选择("32", "", "")           
        对话选择("32", "", "")
        对话选择("32", "", "")  
	对话选择("1", "", "")	    
        等待(1000)
	if(string.find(最新系统消息()," 矮人徽章")~=nil)then goto  tishi2	end
        	    
	goto begin 
::huizhang2::
	if(取物品数量( "矮人徽章") >  "0")then goto  begin end
	
	转向(6, "")
	等待服务器返回()
        对话选择("32", "", "")          
        对话选择("32", "", "")           
        对话选择("32", "", "")          
        对话选择("32", "", "")
        对话选择("32", "", "")  
	对话选择("1", "", "")	   
        等待(1000)
	if(string.find(最新系统消息()," 矮人徽章")~=nil)then goto  tishi2	end
        	    	   
	goto begin 
::huizhang3::
	if(取物品数量( "矮人徽章") >  "0")then goto  begin end
	
	转向(7, "")
	等待服务器返回()
        对话选择("32", "", "")          
        对话选择("32", "", "")         
        对话选择("32", "", "")           
        对话选择("32", "", "")
        对话选择("32", "", "")  
	对话选择("1", "", "")	   
        等待(1000)
	if(string.find(最新系统消息()," 矮人徽章")~=nil)then goto  tishi2	end	   
	goto begin 
::zbhuizhang::
	等待(1000)
	装备物品("矮人徽章", 5)
	等待(1000)
	喊话("矮人徽章已装备。",02,07,08)
		   
	goto begin 
::nahuoba::
        
        转向(2, "")
        等待服务器返回()
        
        对话选择("4", "", "")
        等待服务器返回()
        对话选择("1", "", "")
	goto begin 
::erzhuan::
        if(人物("坐标")  == "10,4")then	goto nayaoshi1 end
        if(人物("坐标")  == "10,5")then	goto nayaoshi2 end
	if(人物("坐标")  == "11,5")then	goto nayaoshi3 end
 	if(人物("坐标")  == "12,4")then	goto nayaoshi4 end
	if(人物("坐标")  == "12,5")then	goto nayaoshi5 end
	goto begin 
::nayaoshi1::
	
        
        转向(2, "")
        等待服务器返回()
        
        对话选择("1", "", "")
        等待服务器返回()
        对话选择("32", "", "")
        等待服务器返回()
        对话选择("1", "", "")
	goto begin 
::nayaoshi2::
	
        
        转向(1, "")
        等待服务器返回()
        
        对话选择("1", "", "")
        等待服务器返回()
        对话选择("32", "", "")
        等待服务器返回()
        对话选择("1", "", "")
	goto begin 
::nayaoshi3::
	
        
        转向(0, "")
        等待服务器返回()
        
        对话选择("1", "", "")
        等待服务器返回()
        对话选择("32", "", "")
        等待服务器返回()
        对话选择("1", "", "")
	goto begin 
::nayaoshi4::
	
        
        转向(7, "")
        等待服务器返回()
        
        对话选择("1", "", "")
        等待服务器返回()
        对话选择("32", "", "")
        等待服务器返回()
        对话选择("1", "", "")
	goto begin 
::nayaoshi5::
	
        
        转向(6, "")
        等待服务器返回()
        
        对话选择("1", "", "")
        等待服务器返回()
        对话选择("32", "", "")
        等待服务器返回()
        对话选择("1", "", "")
	goto begin 
::tanxi::
	扔("艾里克的大剑")
        if(人物("坐标")  == "26,13")then	goto shumiao1 end
        if(人物("坐标")  == "27,13")then	goto shumiao2 end
	goto begin 
::shumiao1::
        
        转向(0, "")
        等待服务器返回()
        对话选择("1", "", "")
	等待(1000)
	goto begin 
::shumiao2::
        
        转向(7, "")
        等待服务器返回()
        对话选择("1", "", "")
	goto begin 
::huiqu::
	等待到指定地图("艾尔莎岛", 1)
        
	转向(1, "RECV_HEAD_crXf")		
	对话选择("4", "", "RECV_HEAD_GUZ")
	等待到指定地图("里谢里雅堡", 1)
        自动寻路(41, 82)
        自动寻路(41, 53)
        自动寻路(65, 53)
	
	等待到指定地图("法兰城", 1)
	等待(1000)
        自动寻路(185, 88)
	
        自动寻路(195, 78)
	
        自动寻路(196, 78)
	
        自动寻路(15, 13)
	
        自动寻路(15, 12)
	
::kaishijianding::
        喊话("请手动鉴定树苗？",0,0,0)
	等待(2000)
        if(取物品数量( "生命之花") >  0)then goto  begin end
	goto kaishijianding 
	goto begin 
::ud::
	if(人物("坐标")  == "259, 359")then	goto candao1 end
	if(人物("坐标")  == "259, 360")then	goto candao2 end
	if(人物("坐标")  == "668, 319")then	goto 半山1 end
	if(人物("坐标")  == "668, 320")then	goto 半山2 end
	if(人物("坐标")  == "669, 320")then	goto 半山3 end
	if(人物("坐标")  == "670, 320")then	goto 半山4 end
	if(人物("坐标")  == "667, 319")then	goto 半山5 end
	if(人物("坐标")  == "54,162")then	goto 双王1 end
	if(人物("坐标")  == "53,162")then	goto 双王2 end
	if(人物("坐标")  == "55,162")then	goto 双王3 end
	if(人物("坐标")  == "55,161")then	goto 双王4 end
	goto begin 
::双王1::
	
        转向(0, "")
        等待服务器返回()
        goto begin 
::双王2::
	
        转向(1, "")
        等待服务器返回()
        goto begin 
::双王3::
	
        转向(7, "")
        等待服务器返回()
        goto begin 
::双王4::
	
        转向(6, "")
        等待服务器返回()
        goto begin 
::candao1::
        
        转向(2, "")
        等待服务器返回()
        
        对话选择("32", "", "")
        等待服务器返回()
        对话选择("4", "", "")
        等待服务器返回()
        对话选择("1", "", "")
	goto begin 
::candao2::
        
        转向(1, "")
        等待服务器返回()
        
        对话选择("32", "", "")
        等待服务器返回()
        对话选择("4", "", "")
        等待服务器返回()
        对话选择("1", "", "")
	goto begin 
::hfzj::
        if(人物("坐标")  == "17,8")then	goto ydbumo7 end
        if(人物("坐标")  == "17,9")then	goto ydbumo8 end
        if(人物("坐标")  == "17,10")then	goto ydbumo1 end
	goto begin 
::dating::
        if(人物("坐标")  == "25,24")then	goto dating1 end
        if(人物("坐标")  == "26,24")then	goto dating2 end
        if(人物("坐标")  == "27,24")then	goto dating3 end
	if(人物("坐标")  == "29,32")then	goto ydbumo7 end
        if(人物("坐标")  == "29,33")then	goto ydbumo8 end
	goto begin 
::dating1::
        
        转向(1, "")
        等待服务器返回()
        
        对话选择("4", "", "")
        等待服务器返回()
        对话选择("1", "", "")
	等待到指定地图("圣餐之间", 1)
	
	自动寻路(39, 12)
	
	等待(1000)
        
        转向(2, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	等待到指定地图("圣坛", 1)
	goto begin 
::dating2::
        
        转向(0, "")
        等待服务器返回()
        
        对话选择("4", "", "")
        等待服务器返回()
        对话选择("1", "", "")
	等待到指定地图("圣餐之间", 1)
	
	自动寻路(39, 12)
	
	等待(1000)
        
        转向(2, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	等待到指定地图("圣坛", 1)
	goto begin 
::dating3::
        
        转向(7, "")
        等待服务器返回()
        
        对话选择("4", "", "")
        等待服务器返回()
        对话选择("1", "", "")
	等待到指定地图("圣餐之间", 1)
	
	自动寻路(39, 12)
	       
	等待(1000)
        
        转向(2, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	等待到指定地图("圣坛", 1)
	goto begin 
::shengtan::
        if(人物("坐标")  == "30,29")then	goto shengtan1 end
        if(人物("坐标")  == "29,29")then	goto shengtan2 end
        if(人物("坐标")  == "28,29")then	goto shengtan3 end
        if(人物("坐标")  == "30,80")then	goto shengtan1 end
        if(人物("坐标")  == "29,80")then	goto shengtan2 end
        if(人物("坐标")  == "28,80")then	goto shengtan3 end
        if(人物("坐标")  == "112,33")then	goto shengtan1 end
        if(人物("坐标")  == "111,33")then	goto shengtan2 end
        if(人物("坐标")  == "110,33")then	goto shengtan3 end
        if(人物("坐标")  == "102,57")then	goto shengtan1 end
        if(人物("坐标")  == "101,57")then	goto shengtan2 end
        if(人物("坐标")  == "100,57")then	goto shengtan3 end
        if(人物("坐标")  == "143,11")then	goto shengtan1 end
        if(人物("坐标")  == "142,11")then	goto shengtan2 end
        if(人物("坐标")  == "141,11")then	goto shengtan3 end
        if(人物("坐标")  == "136,77")then	goto shengtan1 end
        if(人物("坐标")  == "135,77")then	goto shengtan2 end
        if(人物("坐标")  == "134,77")then	goto shengtan3 end
        if(人物("坐标")  == "83,42")then	goto shengtan1 end
        if(人物("坐标")  == "82,42")then	goto shengtan2 end
        if(人物("坐标")  == "81,42")then	goto shengtan3 end
        if(人物("坐标")  == "83,62")then	goto shengtan1 end
        if(人物("坐标")  == "82,62")then	goto shengtan2 end
        if(人物("坐标")  == "81,62")then	goto shengtan3 end
	goto begin 
::shengtan1::
        
        转向(5, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	goto begin 
::shengtan2::
        
        转向(4, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	goto begin 
::shengtan3::
        
        转向(3, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	goto begin 
::cibei::
        if(人物("坐标")  == "26,76")then	goto cibei1 end
        if(人物("坐标")  == "26,21")then	goto cibei2 end
	goto begin 
::cibei1::
	等待到指定地图("阿尔杰斯的慈悲", 1)
	
	自动寻路(26, 55)
	
	自动寻路(33, 55)
	
	自动寻路(33, 49)
	
	自动寻路(91, 49)
	等待(1000)
	
	等待(1000)
        
        转向(2, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	goto begin 
::cibei2::
	等待到指定地图("阿尔杰斯的慈悲", 1)
	
	自动寻路(26, 43)
	
	自动寻路(33, 43)
	
	自动寻路(33, 49)
	
	自动寻路(91, 49)
	等待(1000)
	
	等待(1000)
        
        转向(2, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	goto begin 
::半山1::
	
        转向(2, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	goto begin 
::半山2::
	
        转向(1, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	goto begin 
::半山3::
	
        转向(0, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	goto begin 
::半山4::
	
        转向(7, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	goto begin 
::半山5::
	
        转向(2, "")
        等待服务器返回()
        
        对话选择("1", "", "")
	goto begin 
::新城::
	if(人物("坐标")  == "164,153")then	goto qgm1 end
        if(人物("坐标")  == "165,153")then	goto qgm2 end
	if(人物("坐标")  == "166,153")then	goto qgm3 end
	if(人物("坐标")  == "166,154")then	goto qgm4 end
	if(人物("坐标")  == "166,155")then	goto qgm5 end
	goto begin 
::qgm1::
	
	转向(3, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	goto begin 
::qgm2::
	
	转向(4, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	goto begin 
::qgm3::
	
	转向(5, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	goto begin 
::qgm4::
	
	转向(6, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	goto begin 
::qgm5::
	
	转向(7, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	goto begin 
::传送::
	if(人物("坐标")  == "25,4")then	goto dina1 end
        if(人物("坐标")  == "25,5")then	goto dina2 end
	if(人物("坐标")  == "26,5")then	goto dina3 end
	if(人物("坐标")  == "27,5")then	goto dina4 end
	if(人物("坐标")  == "27,4")then	goto dina5 end
	if(人物("坐标")  == "27,3")then	goto dina6 end
	if(人物("坐标")  == "15,4")then	goto dina1 end
        if(人物("坐标")  == "15,5")then	goto dina2 end
	if(人物("坐标")  == "16,5")then	goto dina3 end
	if(人物("坐标")  == "17,5")then	goto dina4 end
	if(人物("坐标")  == "17,4")then	goto dina5 end
	if(人物("坐标")  == "17,3")then	goto dina6 end
	if(人物("坐标")  == "37,4")then	goto dina1 end
        if(人物("坐标")  == "37,5")then	goto dina2 end
	if(人物("坐标")  == "38,5")then	goto dina3 end
	if(人物("坐标")  == "39,5")then	goto dina4 end
	if(人物("坐标")  == "39,4")then	goto dina5 end
	if(人物("坐标")  == "39,3")then	goto dina6 end
	if(人物("坐标")  == "7,22")then	goto dina1 end
        if(人物("坐标")  == "7,23")then	goto dina2 end
	if(人物("坐标")  == "8,23")then	goto dina3 end
	if(人物("坐标")  == "9,23")then	goto dina4 end
	if(人物("坐标")  == "9,22")then	goto dina5 end
	if(人物("坐标")  == "9,21")then	goto dina6 end
	if(人物("坐标")  == "7,32")then	goto dina1 end
        if(人物("坐标")  == "7,33")then	goto dina2 end
	if(人物("坐标")  == "8,33")then	goto dina3 end
	if(人物("坐标")  == "9,33")then	goto dina4 end
	if(人物("坐标")  == "9,32")then	goto dina5 end
	if(人物("坐标")  == "9,31")then	goto dina6 end
	if(人物("坐标")  == "7,43")then	goto dina1 end
        if(人物("坐标")  == "7,44")then	goto dina2 end
	if(人物("坐标")  == "8,44")then	goto dina3 end
	if(人物("坐标")  == "9,44")then	goto dina4 end
	if(人物("坐标")  == "9,43")then	goto dina5 end
	if(人物("坐标")  == "9,42")then	goto dina6 end
	if(人物("坐标")  == "43,43")then	goto dina1 end
        if(人物("坐标")  == "43,44")then	goto dina2 end
	if(人物("坐标")  == "44,44")then	goto dina3 end
	if(人物("坐标")  == "45,44")then	goto dina4 end
	if(人物("坐标")  == "45,43")then	goto dina5 end
	if(人物("坐标")  == "45,42")then	goto dina6 end
	if(人物("坐标")  == "43,32")then	goto dina1 end
        if(人物("坐标")  == "43,33")then	goto dina2 end
	if(人物("坐标")  == "44,33")then	goto dina3 end
	if(人物("坐标")  == "45,33")then	goto dina4 end
	if(人物("坐标")  == "45,32")then	goto dina5 end
	if(人物("坐标")  == "45,31")then	goto dina6 end
	if(人物("坐标")  == "43,22")then	goto dina1 end
        if(人物("坐标")  == "43,23")then	goto dina2 end
	if(人物("坐标")  == "44,23")then	goto dina3 end
	if(人物("坐标")  == "45,23")then	goto dina4 end
	if(人物("坐标")  == "45,22")then	goto dina5 end
	if(人物("坐标")  == "45,21")then	goto dina6 end

::dina1::
        
	转向(2, "")
	等待服务器返回()
	对话选择("4", "(null)", "")
	goto begin 
::dina2::
        
	转向(1, "")
	等待服务器返回()
	对话选择("4", "(null)", "")
	goto begin 
::dina3::
        
	转向(0, "")
	等待服务器返回()
	对话选择("4", "(null)", "")
	goto begin 
::dina4::
        
	转向(7, "")
	等待服务器返回()
	对话选择("4", "(null)", "")
	goto begin 
::dina5::
        
	转向(6, "")
	等待服务器返回()
	对话选择("4", "(null)", "")
	goto begin 
::dina6::
        
	转向(5, "")
	等待服务器返回()
	对话选择("4", "(null)", "")
	goto begin 
::旅馆::
 	if(人物("坐标")  == "55,31")then	goto getnishizi1 end
	if(人物("坐标")  == "55,32")then	goto getnishizi2 end
	if(人物("坐标")  == "56,32")then	goto getnishizi3 end
        if(人物("坐标")  == "57,32")then	goto getnishizi4 end
        if(人物("坐标")  == "57,31")then	goto getnishizi5 end   
        if(人物("坐标")  == "30,21")then	goto resetbaozhengshu1 end   
        if(人物("坐标")  == "29,21")then	goto resetbaozhengshu2 end     
        if(人物("坐标")  == "31,21")then	goto resetbaozhengshu3 end    
	goto begin 
::resetbaozhengshu1::
	
	转向(0, "")
	等待服务器返回()
		
	喊话("朵拉",0,0,0)	
	等待服务器返回()
	对话选择("4", "", "")
        等待服务器返回()        
	对话选择("1", "", "")
	goto begin 
::resetbaozhengshu2::
	
	转向(1, "")
	等待服务器返回()
		
	喊话("朵拉",0,0,0)	
	等待服务器返回()
	对话选择("4", "", "")
        等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::resetbaozhengshu3::
	
	转向(7, "")
	等待服务器返回()
		
	喊话("朵拉",0,0,0)	
	等待服务器返回()
	对话选择("4", "", "")
        等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::getnishizi1::
 	
	转向(2, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::getnishizi2::
 	
	转向(1, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::getnishizi3::
 	
	转向(0, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::getnishizi4::
 	
	转向(7, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::getnishizi5::
 	
	转向(6, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::神殿::
	if(人物("坐标")  == "91,122")then	goto ydbumo7 end
	if(人物("坐标")  == "94,121")then	goto ydbumo5 end
	if(人物("坐标")  == "94,122")then	goto ydbumo4 end
        if(人物("坐标")  == "94,123")then	goto ydbumo3 end
        if(人物("坐标")  == "91,137")then	goto baozhengshu1 end    
	if(人物("坐标")  == "92,137")then	goto baozhengshu2 end
	if(人物("坐标")  == "91,138")then	goto baozhengshu3 end
	if(人物("坐标")  == "91,139")then	goto baozhengshu4 end 
	if(人物("坐标")  == "92,139")then	goto baozhengshu5 end
	goto begin 
::baozhengshu1::
	
	转向(3, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::baozhengshu2::
	
	转向(4, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::baozhengshu3::
	
	转向(2, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::baozhengshu4::
	
	转向(1, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::baozhengshu5::
	
	转向(0, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::神庙::
	if(人物("坐标")  == "38,22")then	goto gethubozhiluan1 end     
	goto begin 
::gethubozhiluan1::
	
	转向(1, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("32", "", "")
        等待服务器返回()
	对话选择("1", "", "")
	goto begin 
::隘地::
	if(人物("坐标")  == "212,115")then	goto jitanshouwei1 end
	if(人物("坐标")  == "211,115")then	goto jitanshouwei5 end
	if(人物("坐标")  == "211,116")then	goto jitanshouwei2 end
	if(人物("坐标")  == "211,117")then	goto jitanshouwei3 end
        if(人物("坐标")  == "212,117")then	goto jitanshouwei4 end        
	goto begin 
::jitanshouwei1::
	
	转向(4, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("1", "", "")
	goto begin 
::jitanshouwei2::
	
	转向(2, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("1", "", "")
	goto begin 
::jitanshouwei3::
	
	转向(1, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("1", "", "")
	goto begin 
::jitanshouwei4::
	
	转向(0, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("1", "", "")
	goto begin 
::jitanshouwei5::
	
	转向(3, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("1", "", "")
	goto begin 
::神之召唤::
	if(人物("坐标")  == "221,188")then	goto shenzhizhaohuan end	   
	goto begin 
::shenzhizhaohuan::
	
	转向(2, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("8", "", "")
	等待服务器返回()	
	对话选择("1", "", "")
	goto begin 
::双王::
	if(人物("坐标")  == "13,10")then	goto caomei1 end
	if(人物("坐标")  == "13,11")then	goto caomei2 end
	if(人物("坐标")  == "14,11")then	goto caomei3 end
	if(人物("坐标")  == "15,11")then	goto caomei4 end
        if(人物("坐标")  == "15,10")then	goto caomei5 end    
	if(人物("坐标")  == "9,5")then	goto caomei6 end
	if(人物("坐标")  == "10,5")then	goto caomei7 end
        if(人物("坐标")  == "10,4")then	goto caomei8 end         
	goto begin 
::caomei1::
	
	转向(2, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("1", "", "")
	goto begin 
::caomei2::
	
	转向(1, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("1", "", "")
	goto begin 
::caomei3::
	
	转向(0, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("1", "", "")
	goto begin 
::caomei4::
	
	转向(7, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("1", "", "")
	goto begin 
::caomei5::
	
	转向(6, "")
	等待服务器返回()
	
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()
	对话选择("4", "", "")
	等待服务器返回()
	对话选择("32", "", "")
	等待服务器返回()	
	对话选择("1", "", "")
	goto begin 
::caomei6::
	
	转向(0, "")
	等待服务器返回()
		
	对话选择("1", "", "")
	goto begin 
::caomei7::
	
	转向(7, "")
	等待服务器返回()
		
	对话选择("1", "", "")
	goto begin 
::caomei8::
	
	转向(6, "")
	等待服务器返回()
		
	对话选择("1", "", "")
	goto begin 
::双王碎片::
	if(人物("坐标")  == "14,6")then	goto daorensuipian1 end
	if(人物("坐标")  == "14,7")then	goto daorensuipian2 end
	if(人物("坐标")  == "14,8")then	goto daorensuipian3 end	
	goto begin 
::daorensuipian1::
	
	转向(3, "")
	等待服务器返回()
		
	对话选择("4", "", "")
	goto begin 
::daorensuipian2::
	
	转向(2, "")
	等待服务器返回()
		
	对话选择("4", "", "")
	goto begin 
::daorensuipian3::
	
	转向(1, "")
	等待服务器返回()
		
	对话选择("4", "", "")
	goto begin 
::tishi1::
	喊话("队员获得【巴萨的破酒瓶】",02,07,08)
	
	清除系统消息()
	goto begin 

::tishi2::
	喊话("队员获得【矮人徽章】",02,07,08)
    
	清除系统消息()
	goto begin 
::offlinechat::
	清除系统消息()
	等待(1000)
	喊话("星落专用队友脚本 防掉线喊话中。。。。",0,0,0)
	等待(200000)
	goto begin 