require('./common').then(async (cga) => {
    leo.baseInfoPrint();                    //显示基础信息
    leo.moveTimeout = 220;                  //遇敌速度
    leo.monitor.config.keepAlive = false;   //关闭防掉线
    leo.monitor.config.logStatus = false;   //关闭战斗状态提示
    //自动跟随队长换线，设置为true时，需要先提前与队长交换名片
    leo.monitor.config.autoChangeLineForLeader = false;
    var battleStatus = true;   //队长打印战斗明细
    var teamLeader = '此处填队长名称'; //队长名称
    var teamPlayerCount = 5; //队伍人数
    var protect = {
        //contactType遇敌类型：-1-旧遇敌，0-按地图自适应，1-东西移动，2-南北移动，
        //3-随机移动，4-画小圈圈，5-画中圈圈，6-画大圈圈，7-画十字，8-画8字
        contactType: 0,
        visible: false, 
        minHp: 500,
        minMp: 100,
        minPetHp: 150,
        minPetMp: 100,
        maxItemNumber: 21,
        minTeamNumber: 5
    };
    var teammates = [];
    var isPrepare = false; //招魂、治疗、补血、卖石
    var isLogBackFirst = false; //启动登出
    var prepareOptions = {
        rechargeFlag: 1,
        repairFlag: -1,
        crystalName: '水火的水晶（5：5）',
        doctorName: '医道之殇'
    };
    
    leo.log('红叶の半山脚本，推荐138~160级使用，启动~');
    cga.EnableFlags(cga.ENABLE_FLAG_TEAMCHAT, true); //开启队聊
    cga.EnableFlags(cga.ENABLE_FLAG_JOINTEAM, true); //开启组队
    cga.EnableFlags(cga.ENABLE_FLAG_CARD, false); //关闭名片
    cga.EnableFlags(cga.ENABLE_FLAG_TRADE, false); //关闭交易
    var playerinfo = cga.GetPlayerInfo();
    var playerName = playerinfo.name;
    var isTeamLeader = false;
    if (playerName == teamLeader) {
        isTeamLeader = true;
        protect.minMp = 350; //队长是传教，回城魔值至少要大于等于一次祈祷的魔
        leo.log('我是队长，预设队伍人数【'+teamPlayerCount+'】');
        if(battleStatus){
            leo.battleMonitor.start(cga);
        }
    }else{
        leo.log('我是队员，队长是【'+teamLeader+'】');
    }

    leo.todo().then(() => {
        //登出
        if (isLogBackFirst) {
            return leo.logBack();
        } else {
            return leo.next();
        }
    }).then(() => {
        //招魂、治疗、补血、卖石
        if (isPrepare) {
            return leo.logBack().then(() => leo.prepare(prepareOptions));
        } else {
            return leo.next();
        }
    }).then(() => {
        return leo.loop(
            () => leo.waitAfterBattle()
            .then(() => leo.checkHealth(prepareOptions.doctorName))
            .then(() => leo.checkCrystal(prepareOptions.crystalName))
            .then(() => {
                if(cga.GetPlayerInfo().gold < 5000){
                    return leo.goto(n=>n.falan.bank)
                    .then(()=>leo.turnDir(0))
                    .then(()=>leo.moveGold(100000,cga.MOVE_GOLD_FROMBANK))
                    .then(()=>leo.moveGold(100000,cga.MOVE_GOLD_FROMBANK))
                    .then(()=>leo.moveGold(100000,cga.MOVE_GOLD_FROMBANK))
                    .then(()=>leo.moveGold(100000,cga.MOVE_GOLD_FROMBANK))
                    .then(()=>leo.moveGold(100000,cga.MOVE_GOLD_FROMBANK))
                    .then(()=>{
                        if(cga.GetPlayerInfo().gold < 5000){
                            leo.log('钱到用时方恨少！请补充足够银子后重新执行脚本！')
                            return leo.delay(10000000)
                            .then(()=>leo.reject());
                        }
                    })
                }
            })
            .then(() => {
                //完成组队
                var teamplayers = cga.getTeamPlayers();
                if ((isTeamLeader && teamplayers.length >= protect.minTeamNumber)
                		|| (!isTeamLeader && teamplayers.length > 0)) {
                    //console.log('组队已就绪');
                    return leo.next();
                } else {
                    console.log(leo.logTime() + '寻找队伍');
                    return leo.logBack()
                    .then(() => leo.statistics(leo.beginTime, leo.oldXp))   //打印统计信息
                    .then(()=>leo.sellCastle())
                    .then(()=>leo.checkHealth(prepareOptions.doctorName))
                    .then(()=>leo.checkCrystal(prepareOptions.crystalName))
                    .then(()=>leo.goto(n => n.falan.wout))
                    .then(()=>leo.autoWalk([397,168]))
                    .then(()=>leo.talkNpc(398, 168, leo.talkNpcSelectorYes,'小岛'))
                    .then(() => {
                        if (isTeamLeader) {
                            return leo.moveAround()
                            .then(()=>leo.buildTeamBlock(teamPlayerCount,teammates));
                        } else {
                            return leo.enterTeamBlock(teamLeader);
                        }
                    });
                }
            }).then(() => {
                //爬山
                if (isTeamLeader) {
                    return leo.todo()
                    .then(()=>{
                        var mapInfo = leo.getMapInfo();
                        if (mapInfo.name == '小岛'){
                            return leo.autoWalk([64, 45, '通往山顶的路100M']);
                        }
                    })
                    .then(()=>{
                        var mapInfo = leo.getMapInfo();
                        if (mapInfo.name.indexOf('通往山顶的路')!=-1){
                            return leo.walkRandomMazeUntil(() => {
                                const mn = cga.GetMapName();
                                if (mn == '半山腰') {
                                    return true;
                                }
                                return false;
                            },false);
                        }
                    })
                    .then(()=>{
                        var mapInfo = leo.getMapInfo();
                        if (mapInfo.name == '半山腰'){
                            return leo.autoWalk([60,61])
                            .then(()=>{
                                console.log(leo.logTime() + '开始战斗');
                                return leo.encounterTeamLeader(protect) //队长遇敌
                                .then(() => {
                                    console.log(leo.logTime() + "登出回补");
                                    return leo.leaveTeam();
                                });
                            });
                        }
                    })
                } else {
                    var mapInfo = leo.getMapInfo();
                    if (mapInfo.name == '半山腰'){
                        return leo.encounterTeammate(protect, '半山腰');    //队员遇敌
                    }
                }
                //console.log('延时3秒');
                return leo.delay(3000);
            }).
            catch (console.log));
    });
});