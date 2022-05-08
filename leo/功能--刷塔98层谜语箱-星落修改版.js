require(process.env.CGA_DIR_PATH_UTF8+'/leo').then(async (cga) => {
    //leo.baseInfoPrint();
    leo.monitor.config.keepAlive = false;   //关闭防掉线
    var teamLeader = ''; //队长名称
    var teamPlayerCount = 1; //队伍人数
    var fly = false; 
    var teammates = [];
    var boxs = ['谜语箱１','谜语箱２','谜语箱３','谜语箱４','谜语箱５','谜语箱６','谜语箱７','谜语箱８','谜语箱９','谜语箱１０'];
    var dropList = ['宠物水晶','奇美拉的羽毛','不可思议的鳞片','液体','精灵','妖草的血','火焰之魂','风龙蜥的甲壳','德特家的布'];
    var logFlag = true;
    var shuangye = cga.getItemCount('双叶妹妹');
    cga.EnableFlags(cga.ENABLE_FLAG_TEAMCHAT, true); //开启队聊
    cga.EnableFlags(cga.ENABLE_FLAG_JOINTEAM, true); //开启组队
    var prepareOptions = {
        rechargeFlag: 1,
        repairFlag: -1,
        crystalName: '水火的水晶（5：5）',
        doctorName: '医道之殇'
    };
    var protect = {
        minHp: 500,
        minMp: 100,
        minPetHp: 150,
        minPetMp: 100,
        maxItemNumber: 19,
        minTeamNumber: 1,
        checker: ()=>{
            if(cga.isInNormalState()){
                var dropItem = cga.getInventoryItems().find(item => {
                    var idDrop = false;
                    for (var i = 0; i < dropList.length; i++) {
                        if(item.name.indexOf(dropList[i])>-1){
                            idDrop = true;
                        }
                    }
                    return idDrop;
                });
                if(dropItem){
                    leo.log('扔掉了【'+dropItem.name+'】')
                    leo.dropItemEx(dropItem.name);
                }

                var items = cga.getInventoryItems().filter(item => {
                    return boxs.indexOf(item.name)>-1;
                });
                if(items && items.length>0){
                    return true
                }
            }
            if(cga.getMapInfo.name=='雪拉威森塔９５层'){
                return true;
            }
            if(cga.getMapInfo.name=='雪拉威森塔９６层'){
                return true;
            }
            if(cga.getMapInfo.name=='雪拉威森塔９７层'){
                return true;
            }
        }
    };
    var playerinfo = cga.GetPlayerInfo();
    var playerName = playerinfo.name;
    var isTeamLeader = false;
    if (playerName == teamLeader) {
        isTeamLeader = true;
    }   

    var color = 4;
    var countDown = 30;
	
	var itemFilter = (unit)=>{
		if(!(unit.flags & cga.emogua.UnitFlags.NpcEntry) && !(unit.flags & leo.UnitFlags.Player)){
			for(var i in boxs){
				if(unit.item_name.indexOf(boxs[i]) != -1){
					return true;
				}
			}
		}
	}
	var openBox=async () => 
	{
		var items = cga.getInventoryItems().filter(item => {
			return boxs.indexOf(item.name)>-1;
		});
		while(items && items.length == 1)
		{							
			var box = items[0]
			leo.log('获得了【'+box.name+'】')
			await leo.useItemEx(box.name)
			await leo.talkNpc(leo.talkYes)
			var shuangye2 = cga.getItemCount('双叶妹妹');
			if(shuangye2>shuangye){
				leo.log('恭喜，获得了【双叶妹妹】');
				shuangye = shuangye2;
			}
			items = cga.getInventoryItems().filter(item => {
				return boxs.indexOf(item.name)>-1;
			});
			leo.delay(1000)
		} 		
	}
    var task = async () => {
        await leo.checkHealth(prepareOptions.doctorName)
        await leo.checkCrystal(prepareOptions.crystalName)
        if(cga.getMapInfo().name != '雪拉威森塔９８层' )
		{
			if(leo.has('提斯的护身符'))
			{
				await leo.useItemEx('提斯的护身符')
				await leo.talkNpc(leo.talkYes)
				await leo.talkNpc(0, leo.talkYes)
				await leo.moveAround()
			}else if(leo.has('梅雅的护身符'))
			{
				await leo.useItemEx('梅雅的护身符')
				await leo.talkNpc(leo.talkYes)
				await leo.talkNpc(0, leo.talkYes)
				await leo.moveAround()
			}else if(leo.has('塞特的护身符'))
			{
				await leo.useItemEx('塞特的护身符')
				await leo.talkNpc(leo.talkYes)
				await leo.talkNpc(0, leo.talkYes)
				await leo.moveAround()
			}
        }
        if(cga.getMapInfo().name == '艾尔莎岛'){
            await leo.autoWalk([138,108])            
            await leo.autoWalk([165,153])       
            await leo.talkNpc(2,leo.talkYes,'利夏岛')
        }
        if(cga.getMapInfo().name == '利夏岛'){
            await leo.autoWalk([93,63])            
            await leo.autoWalk([90,99,'国民会馆'])
        }
        if(cga.getMapInfo().name == '国民会馆'){ 
            await leo.autoWalk([107,51])
            await leo.supply(108, 52)
            await leo.autoWalk([108,39,'雪拉威森塔１层'])
        }
        if(cga.getMapInfo().name == '雪拉威森塔１层'){
            await leo.autoWalk([75,50,'雪拉威森塔５０层'])
        }
        if(cga.getMapInfo().name == '雪拉威森塔５０层'){
            await leo.autoWalk([16,44,'雪拉威森塔９５层'])
        }
        if(cga.getMapInfo().name == '雪拉威森塔９５层'){
            await leo.autoWalk([28, 105])           
            await leo.leaveTeam()
            await leo.talkNpc(28,104,leo.talkYes)
            await leo.moveAround()
        }
        if(cga.getMapInfo().name == '雪拉威森塔９６层'){          
            await leo.autoWalk([87, 118])            
            await leo.leaveTeam()
            await leo.talkNpc(88,118,leo.talkYes)
            await leo.moveAround()
        }
        if(cga.getMapInfo().name == '雪拉威森塔９７层'){           
            await leo.autoWalk([117, 126])           
            await leo.leaveTeam()
            await leo.talkNpc(117,125,leo.talkYes)
            await leo.moveAround()
        }
        if(cga.getMapInfo().name == '雪拉威森塔９８层'){          
            await leo.autoWalk([117,90])
            console.log(leo.logTime() + '开始战斗');
            await leo.encounterTeamLeader(protect)
            await leo.log('停止遇敌');
			var items = cga.getInventoryItems().filter(item => {
                    return boxs.indexOf(item.name)>-1;
                });
			if(items && items.length>0)
			{
				if(items.length == 1)
				{
					await openBox();
				}else{					
					await leo.autoWalk([115,85])   					
					for (var i = 0; i < items.length; i++) {
						
						leo.log('扔掉了【'+items[i].name+'】')
						await leo.dropItem(items[i].name);
					}
					//捡回来开
					var units = cga.GetMapUnits().filter(itemFilter);
					if(units && units.length>0)
					{
						for(var i = 0; i < units.length; i++)
						{						
							var unit = units[i];						
							console.log('发现【'+unit.item_name+'】，坐标【'+unit.xpos+','+unit.ypos+'】')
							await leo.pickup(unit.xpos,unit.ypos);	
							await openBox();
						}				
					}
				}				
			}else
			{	
			    await leo.supplyCastle(true)
			}
        }
    }

    leo.loop(async ()=>{
        try{
            await task();			
        }catch(e){
            if(e){
                console.log(leo.logTime()+'任务出错:'+e);
                console.log(leo.logTime()+'重新开始');
            }else{
                console.log(leo.logTime()+'退出循环，重新开始');
            }
        }
    })
    
});