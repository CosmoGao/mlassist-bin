require('./common').then(cga => {
//1.本脚本从深渊任务开始，依次完成【打神眼】，【深渊】，【询问之地】，【黑龙城】
//2.脚本共同改变玩家称号来控制任务进程，首次启动请将游戏中玩家称号改成0.
//3.称号对应的任务阶段：
//     0：身上没有神眼，去大风洞打神眼，打完后称号自动变成1。
//     1：身上有神眼，去做深渊任务，得到世界之心和黑之记忆后，改变称号为：2
//     2：身上有世界之心和黑之记忆，去询问之地，获得黑之意志，获得后改成称号为：3
//     3：身上有黑之意志，去黑龙城刷龙鳞，其中，获得混沌之魂2后，在执行完脚本后，会重新再跑一次黑龙城，均完成后，改成称号为：0，登出服务器，更换线路重新执行。
//4.配置说明，本脚本全部自动战斗，请在leo文件夹里新建一个名为“盗贼.JOSN”的战斗配置文件（打开CGA，配置好了，保存在LEO里面就行了），脚本会自动加载。
//5，CGA面板勾选，需勾选自动换线，自动补血补魔，方便跑路或战斗时进行补充。
    var taskIndex = 0;
    leo.log("大秋快乐の刷龙鳞脚本，启动！");

    var teamLeader = '此处填队长名称'; //队长名称
    var teamPlayerCount = 1; //队伍人数
    var teammates = [];

    cga.EnableFlags(cga.ENABLE_FLAG_TEAMCHAT, true); //开启队聊
    cga.EnableFlags(cga.ENABLE_FLAG_JOINTEAM, true); //开启组队
    var prepareOptions = {
        rechargeFlag: 1,
        repairFlag: -1,
        crystalName: '水火的水晶（5：5）',
        doctorName: '医道之殇'

    };
    var petOptions = {
        sealCardName: '神眼',
        petChecker: () => {
            var sealCardCount = cga.getItemCount(petOptions.sealCardName);
            if (sealCardCount > 0) {
                return true;
            }
        }
    };
    var protect = {
        minHp: 500,
        minMp: 200,
        minPetHp: 500,
        minPetMp: 200,
        checker: petOptions.petChecker
    };
    var playerinfo = cga.GetPlayerInfo();
    var playerName = playerinfo.name;
    var isTeamLeader = false;
    if (playerName == teamLeader) {
        isTeamLeader = true;
    }
    if (teamPlayerCount <= 1){//单人模式
        teamPlayerCount = 1;
        teamLeader = playerName;
        isTeamLeader = true;
    }
    var gotoTarget = ()=>{
        var targetEntryArr = {
            '奇怪的坑道' : [[365,354],[365,362],[364,370],[354,384],[351,398],[361,408],
                           [359,453],[375,457],[387,459],
                           [395,447],[395,431],[388,421],[378,414],
                           [373,390],[361,420],[360,434],[374,433]]
        }
        var index = -1;
        var targetEntryAreaArr = targetEntryArr['奇怪的坑道'];
        var findHoleEntry = ()=>{
            var mapInfo = leo.getMapInfo();
            if(mapInfo.name == '奇怪的坑道地下1楼'){
                return leo.next();
            }
            index++;
            if(index >= targetEntryAreaArr.length){
                return leo.reject('没有找到迷宫入口');
            }
            if (mapInfo.name == '莎莲娜') {
                return leo.autoWalk(targetEntryAreaArr[index])
                .then(()=>{
                    var mazeEntry = cga.GetMapUnits().filter(u => (u.flags & leo.UnitFlags.NpcEntry) && u.model_id > 0);
                    if(mazeEntry && mazeEntry.length>0){
                        return leo.autoWalk([mazeEntry[0].xpos,mazeEntry[0].ypos,'*'])
                        .then(()=>findHoleEntry());
                    }else{
                        return findHoleEntry();
                    }
                })
            }
        }
        return findHoleEntry();
    }
    var findNpc = ()=>{
        var npcPosition;
        if (!leo.isMapDownloaded(cga.buildMapCollisionMatrix())) {
            npcPosition = null;
        }
        const gotoNpc = (npc) => {
            const positions = leo.getMovablePositionsAround({x: npc.xpos, y: npc.ypos});
            return leo.autoWalk([positions[0].x, positions[0].y],undefined,undefined,{compress: false})
            .then(
                () => leo.talkNpc(npc.xpos, npc.ypos, leo.talkNpcSelectorYes)
            )
            .then(
                () => leo.autoWalk([npc.entries[0].x, npc.entries[0].y, '*'],undefined,undefined,{compress: false})
            );
        };
        if (npcPosition) {
            return leo.walkRandomMazeUntil(() => cga.GetMapName() == npcPosition.mapName, false).then(
                () => gotoNpc(npcPosition)
            );
        }
        return leo.searchMap(
            units => units.find(u => u.unit_name == '挖掘的迪太' && u.type == 1), true, false
        ).then(unit => {
            npcPosition = unit;
            npcPosition.mapName = cga.GetMapName();
            return gotoNpc(npcPosition);
        });
    }
    leo.log('队伍人数【'+teamPlayerCount+'】，队长是【'+teamLeader+'】'+(isTeamLeader?'，没错，就是我':''));

    var task0 = async () => {
    var playerinfo = cga.GetPlayerInfo();
    var playernickName = playerinfo.nick;
        if(cga.getItemCount('世界之心') < 1 && playernickName == "0" ) {
            await console.log('身上没有神眼，启动第0阶段，去打个神眼')
            await leo.logBack()
            await leo.supplyCastle()
            var currentMap = cga.GetMapName();
            if (currentMap == '艾尔莎岛' || currentMap == '里谢里雅堡' || currentMap == '法兰城' || currentMap == '银行' || currentMap == '杂货店') {
                await leo.panel.loadFromFile('通用任务配置.json');
                await leo.goto(n => n.teleport.kili)
                await leo.autoWalkList([
                    [79, 76, '索奇亚'], [356, 334, '角笛大风穴']
                ])
            }
            var currentMap = cga.GetMapName();
            await leo.loop(async ()=>{
                if(currentMap == '角笛大风穴' && cga.getItemCount('神眼') > 0){
                        await leo.logBack()
                        await cga.ChangeNickName('1')
                        await leo.delay(1000)
                        await leo.reject()
                }else{
                    await leo.encounterTeamLeader(protect)
                    await leo.waitAfterBattle()
                }
            })

        }
        await leo.delay(2000);

        taskIndex++;
        await leo.delay(1000)
    }

    var task1 = async () => {
    var playerinfo = cga.GetPlayerInfo();
    var playernickName = playerinfo.nick;
        if(cga.getItemCount('世界之心') < 1 && playernickName == "1" ){
            await console.log('身上有【神眼】，身上没有【世界之心】，没有【黑之记忆】，启动第1阶段，去做深渊任务')
        await leo.logBack()
        await leo.supplyCastle()
                var currentMap = cga.GetMapName();

                if(currentMap == '艾尔莎岛' || currentMap == '里谢里雅堡' || currentMap == '法兰城' || currentMap == '银行' || currentMap == '杂货店'){
                     await leo.panel.loadFromFile('通用任务配置.json');
                    await leo.goto(n => n.teleport.jenova)
                    await leo.autoWalkList([
                        [71, 18, '莎莲娜']
                    ])
                }
                var currentMap = cga.GetMapName();
                if(currentMap == '莎莲娜' && cga.getItemCount('塔比欧的细胞')==0 && cga.getItemCount('月之锄头')==0){

                    await leo.autoWalk([281, 371])
                    await leo.turnDir(6)
                    await leo.delay(1000)
                    await leo.waitAfterBattle()
                }
                var currentMap = cga.GetMapName();
                if(currentMap == '莎莲娜' && cga.getItemCount('塔比欧的细胞')>0 && cga.getItemCount('月之锄头')==0){
                    await leo.autoWalk([314,432])
                    await leo.talkNpc(313, 432,leo.talkNpcSelectorYes)
                }
                var currentMap = cga.GetMapName();
                if(currentMap == '莎莲娜' && cga.getItemCount('月之锄头')>0){
                      await leo.panel.loadFromFile('逃跑.json');
                    await gotoTarget();
                }
                var currentMap = cga.GetMapName();
                if(currentMap.indexOf('奇怪的坑道')!=-1 && cga.getItemCount('红色三菱镜')==0){
                    await findNpc();
                }
                var currentMap = cga.GetMapName();
                if(currentMap.indexOf('奇怪的坑道')!=-1 && cga.getItemCount('红色三菱镜')==1){
                    await leo.walkRandomMazeUntil(() => {
                            var mapInfo = leo.getMapInfo();
                            if (mapInfo.name.indexOf('奇怪的坑道地下1')!=-1 && mapInfo.x == 10 && mapInfo.y == 19) {
                                return true;
                            }
                            return false;
                    },false)
                      await leo.panel.loadFromFile('通用任务配置.json');
                    await leo.autoWalk([10,15,[12, 7]])
                    await leo.autoWalk([8,5])
                    await leo.turnDir(0)
                    await leo.delay(1000)
                    await leo.waitAfterBattle()
                    await leo.waitUntil(()=>{
                        var mapInfo = leo.getMapInfo();
                        if (mapInfo.x == 2 && mapInfo.y == 5) {
                            return true;
                        }
                        return false;
                    })
                    await leo.autoWalk([4,5])
                    await leo.turnDir(0)
                    await leo.waitUntil(()=>{
                        var mapInfo = leo.getMapInfo();
                        if (mapInfo.name == '地下水脉' && mapInfo.indexes.index3 == 15531) {
                            return true;
                        }
                        return false;
                    })
                }
                var currentMap = cga.GetMapName();
                if (currentMap == '地下水脉') {
                      await leo.panel.loadFromFile('逃跑.json');
                    await leo.autoWalkList([
                        [29, 55]
                    ])
                    await leo.talkNpc(29, 54,leo.talkNpcSelectorYes)
                    await leo.autoWalkList([
                        [46, 32]
                    ])
                    await leo.talkNpc(47, 32,leo.talkNpcSelectorYes)
                    await leo.autoWalkList([
                        [50, 32, '地底的龟裂处']
                    ])
                    var currentMap = cga.GetMapName();
                    await leo.autoWalkList([
                        [14, 7, '深渊第1层']
                    ])
                }
                var currentMap = cga.GetMapName();
                if (currentMap == '深渊第1层') {
                  await  leo.walkRandomMazeUntil(() => {
                            var mn = cga.GetMapName();
                            if (mn == '黑之祭坛') {
                                return true;
                            }
                            return false;
                    },false)
                }
                var currentMap = cga.GetMapName();
                if (currentMap == '黑之祭坛') {
                      await leo.panel.loadFromFile('通用任务配置.json');
                  await leo.autoWalkList([
                        [20, 9]
                    ])
                  await leo.talkNpc(20, 8,leo.talkNpcSelectorYes)
                  await leo.waitAfterBattle()
                  await leo.delay(1000)
                  await leo.autoWalkList([
                        [15, 22]
                    ])
                  await leo.talkNpc(15, 21,leo.talkNpcSelectorYes)
                }
                if(cga.getItemCount('黑之记忆')==1){
                    await cga.ChangeNickName("2");
                    await leo.logBack()
                }

        }
        await leo.delay(2000);

        taskIndex++;
        await leo.delay(1000)
    }

    var task2 = async () => {

        var playerinfo = cga.GetPlayerInfo();
        var playernickName = playerinfo.nick;
        if(cga.getItemCount('世界之心')>0  && cga.getItemCount('黑之记忆')>0 && playernickName == "2"){
                await console.log('身上有世界之心，已拿到黑之记忆，启动第2阶段，去做深渊任务')
        await leo.logBack()
        await leo.supplyCastle()
        if(cga.getItemCount('黑之记忆')>0){
        var itemArr = cga.findItemArray('黑之记忆');
                //console.log(itemArr);
                if(itemArr.length==0){
                    return leo.reject('身上没有白之记忆');
                }else if(itemArr.length>1){
                    for (var i = 0; i < itemArr.length; i++) {
                        if(i!=itemArr.length-1){
                            cga.DropItem(itemArr[i].itempos);
                        }else{
                            cga.MoveItem(itemArr[i].itempos, 8, -1);//移到第一格
                        }

                    }
                }else{
                    cga.MoveItem(itemArr[0].itempos, 8, -1);//移到第一格
                }
                    await leo.useItem(8)
                    await leo.waitNPCDialog(dialog => {
                                    cga.ClickNPCDialog(4, -1)
                                    return leo.delay(2000);
                                })

        }
        var currentMap = cga.GetMapName();
        if (currentMap == '黑之祭坛'){
            await leo.delay(1000)
            await leo.autoWalkList([[17,24]])
        await leo.talkNpc(16, 25,leo.talkNpcSelectorYes)
        }


        var currentMap = cga.GetMapName();
        if (currentMap == '光明与黑暗的祭坛') {
        await leo.autoWalkList([[58,70]])
        await leo.talkNpc(59, 70,leo.talkNpcSelectorYes)
        }

        var currentMap = cga.GetMapName();
        if (currentMap == '玄关') {
        await leo.autoWalkList([[18,39,'询问之地1楼']])
        await leo.delay(1000)
        }
        var currentMap = cga.GetMapName();
        if (currentMap == '询问之地1楼') {
              await leo.panel.loadFromFile('逃跑.json');
          await  leo.walkRandomMazeUntil(() => {
                    var mn = cga.GetMapName();
                    if (mn == '询问处') {
                        return true;
                    }
                    return false;
            },false)
        }
        var currentMap = cga.GetMapName();
        if (currentMap == '询问处') {
        await leo.autoWalkList([[13,14]])
        await leo.talkNpc(13, 15,leo.talkNpcSelectorNo)
        await leo.autoWalkList([[10,18,'询问之地11楼']])
        }
        var currentMap = cga.GetMapName();
        if (currentMap == '询问之地11楼') {
          await  leo.walkRandomMazeUntil(() => {
                    var mn = cga.GetMapName();
                    if (mn == '询问处') {
                        return true;
                    }
                    return false;
            },false)
        }
        var currentMap = cga.GetMapName();
        if (currentMap == '询问处') {
        await leo.autoWalkList([[13,14]])
        await leo.talkNpc(13, 15,leo.talkNpcSelectorYes)
        await leo.autoWalkList([[10,18,'询问之地21楼']])
        }
        var currentMap = cga.GetMapName();
        if (currentMap == '询问之地21楼') {
          await  leo.walkRandomMazeUntil(() => {
                    var mn = cga.GetMapName();
                    if (mn == '询问处') {
                        return true;
                    }
                    return false;
            },false)
        }
        var currentMap = cga.GetMapName();
        if (currentMap == '询问处') {
        await leo.autoWalkList([[13,14]])
        await leo.talkNpc(13, 15,leo.talkNpcSelectorNo)
        await leo.autoWalkList([[10,18,'询问之地31楼']])
        }
        var currentMap = cga.GetMapName();
        if (currentMap == '询问之地31楼') {
          await  leo.walkRandomMazeUntil(() => {
                    var mn = cga.GetMapName();
                    if (mn == '询问处') {
                        return true;
                    }
                    return false;
            },false)
        }
        var currentMap = cga.GetMapName();
        if (currentMap == '询问处') {
        await leo.autoWalkList([[13,14]])
            await leo.turnTo(13,15)
            await leo.waitNPCDialog(dialog => {
                            cga.ClickNPCDialog(1, -1)
                            return leo.delay(2000);
                        })
        }
        if(cga.getItemCount('黑之意志')==1){
            await cga.ChangeNickName("3");
                await leo.logBack()
        }
        }
        taskIndex++;

        await leo.delay(2000)
    }

    var task3 = async () => {

        var playerinfo = cga.GetPlayerInfo();
        var playernickName = playerinfo.nick;
        if( playernickName == "3"){
            await console.log('身上有黑之意志，启动第3阶段，去做黑龙城刷碎片了')

          if(cga.getItemCount('黑之意志')>0){
                var itemArr = cga.findItemArray('黑之意志');
                //console.log(itemArr);
                if(itemArr.length==0){
                    return leo.reject('身上没有黑之意志');
                }else if(itemArr.length>1){
                    for (var i = 0; i < itemArr.length; i++) {
                        if(i!=itemArr.length-1){
                            cga.DropItem(itemArr[i].itempos);
                        }else{
                            cga.MoveItem(itemArr[i].itempos, 8, -1);//移到第一格
                        }

                    }
                }else{
                    cga.MoveItem(itemArr[0].itempos, 8, -1);//移到第一格
                }
                    await leo.useItem(8)
                    await leo.waitNPCDialog(dialog => {
                                    cga.ClickNPCDialog(4, -1)
                                    return leo.delay(2000);
                                })
          }
                var currentMap = cga.GetMapName();
                if(cga.getItemCount('混沌之魂2')>0 && currentMap != '询问处'){
                    await leo.supplyCastle()
                var itemArr = cga.findItemArray('混沌之魂2');
                //console.log(itemArr);
                if(itemArr.length==0){
                    return leo.reject('身上没有混沌之魂2');
                }else if(itemArr.length>1){
                    for (var i = 0; i < itemArr.length; i++) {
                        if(i!=itemArr.length-1){
                            cga.DropItem(itemArr[i].itempos);
                        }else{
                            cga.MoveItem(itemArr[i].itempos, 8, -1);//移到第一格
                        }

                    }
                }else{
                    cga.MoveItem(itemArr[0].itempos, 8, -1);//移到第一格
                }
                await leo.useItem(8)
                await leo.waitNPCDialog(dialog => {
                                cga.ClickNPCDialog(4, -1)
                                return leo.delay(2000);
                            })
                var currentMap = cga.GetMapName();
                if (currentMap == '询问处') {
                await leo.autoWalkList([[13,15]])
                    await leo.turnTo(13,16)
                    await leo.waitNPCDialog(dialog => {
                                    cga.ClickNPCDialog(1, -1)
                                    return leo.delay(2000);
                                })
                }
                var currentMap = cga.GetMapName();
                if (currentMap == '光明与黑暗的祭坛') {
                await leo.autoWalkList([[102,110,'往南的下山道']])
                    await leo.delay(500)
                await leo.autoWalkList([[11,57,'光明与黑暗的祭坛']])
                    await leo.delay(500)
                await leo.autoWalkList([[116,40,'小翠的家']])
                await leo.delay(500)
                await leo.autoWalkList([[24,20]])
                await leo.talkNpc(25, 20,leo.talkNpcSelectorYes)
                await leo.delay(500)
                    // await leo.waitUntil(()=>{
                    //     var mapInfo = leo.getMapInfo();
                    //     if (mapInfo.x == 2 && mapInfo.y == 5) {
                    //         return true;
                    //     }
                    //     return false;
                    // })
                await leo.autoWalkList([[20,8]])
                await leo.talkNpc(21, 20,leo.talkNpcSelectorYes)
                    await leo.delay(500)

                await leo.autoWalkList([[3,14,'光明与黑暗的祭坛']])
                    await leo.delay(500)
                await leo.autoWalkList([[124,103]])
                await leo.talkNpc(123, 103,leo.talkNpcSelectorYes)
                await leo.delay(500)
                }
                var currentMap = cga.GetMapName();
                if (currentMap == '黑龙城宫殿') {
                await leo.delay(500)
                await leo.autoWalkList([[24,26,'黑龙城1楼']])
                }
                var currentMap = cga.GetMapName();
                if (currentMap == '黑龙城1楼') {
                  await  leo.walkRandomMazeUntil(() => {
                            var mn = cga.GetMapName();
                            if (mn == '黑龙城 20楼') {
                                return true;
                            }
                            return false;
                    },false)
                }
                var currentMap = cga.GetMapName();
                if (currentMap == '黑龙城 20楼') {
                await leo.delay(2000)
                await leo.autoWalkList([[15,5]])
                await leo.panel.loadFromFile('盗贼.json');   //请在leo里面保存一个自己设置的盗贼.JOSN的战斗配置，这里会自动加载
                await leo.loop(async ()=>{
                if(cga.GetPlayerInfo().hp > 500 && cga.GetPlayerInfo().hp > 200){
                    await leo.talkNpc(15,4,leo.talkNpcSelectorYes)
                    await leo.waitAfterBattle()
                    await console.log("检查血魔，自动补充，请开启CGA自动补血补魔")
                    await leo.delay(10000)
                }else{
                    await console.log("没药了回城");
                    await leo.delay(10000);
                    await leo.logBack()
                 }
                var currentMap = cga.GetMapName();
                    if(currentMap == '艾尔莎岛'){
                                await leo.supplyCastle()
                        await cga.ChangeNickName("0");
                        await console.log("退出脚本重新执行")
                        await leo.delay(2000)
                        await leo.reject();
                        await cga.LogOut();
                    }
                })
                }
                }else {
                var currentMap = cga.GetMapName();
                if (currentMap == '询问处') {
                await leo.autoWalkList([[13,15]])
                    await leo.turnTo(13,16)
                    await leo.waitNPCDialog(dialog => {
                                    cga.ClickNPCDialog(1, -1)
                                    return leo.delay(2000);
                                })
                }
                var currentMap = cga.GetMapName();
                if (currentMap == '光明与黑暗的祭坛') {
                await leo.autoWalkList([[102,110,'往南的下山道']])
                    await leo.delay(500)
                await leo.autoWalkList([[11,57,'光明与黑暗的祭坛']])
                    await leo.delay(500)
                await leo.autoWalkList([[116,40,'小翠的家']])
                await leo.delay(500)
                await leo.autoWalkList([[24,20]])
                await leo.talkNpc(25, 20,leo.talkNpcSelectorYes)
                await leo.delay(500)
                    // await leo.waitUntil(()=>{
                    //     var mapInfo = leo.getMapInfo();
                    //     if (mapInfo.x == 2 && mapInfo.y == 5) {
                    //         return true;
                    //     }
                    //     return false;
                    // })
                await leo.autoWalkList([[20,8]])
                await leo.talkNpc(21, 20,leo.talkNpcSelectorYes)
                    await leo.delay(500)

                await leo.autoWalkList([[3,14,'光明与黑暗的祭坛']])
                    await leo.delay(500)
                await leo.autoWalkList([[124,103]])
                await leo.talkNpc(123, 103,leo.talkNpcSelectorYes)
                await leo.delay(500)
                }
                var currentMap = cga.GetMapName();
                if (currentMap == '黑龙城宫殿') {
                await leo.delay(500)
                await leo.autoWalkList([[24,26,'黑龙城1楼']])
                }
                var currentMap = cga.GetMapName();
                if (currentMap == '黑龙城1楼') {
                  await  leo.walkRandomMazeUntil(() => {
                            var mn = cga.GetMapName();
                            if (mn == '黑龙城 20楼') {
                                return true;
                            }
                            return false;
                    },false)
                }
                var currentMap = cga.GetMapName();
                if (currentMap == '黑龙城 20楼') {
                await leo.delay(2000)
                await leo.autoWalkList([[15,5]])
                await leo.panel.loadFromFile('盗贼.json');//请在leo里面保存一个自己设置的盗贼.JOSN的战斗配置，这里会自动加载
                await leo.loop(async ()=>{
                if(cga.GetPlayerInfo().hp > 500 && cga.GetPlayerInfo().hp > 200){
                    await leo.talkNpc(15,4,leo.talkNpcSelectorYes)
                    await leo.waitAfterBattle()
                    await console.log("检查血魔，自动补充，请开启CGA自动补血补魔")
                    await leo.delay(10000)
                }else{
                    await console.log("没药了回城");
                    await leo.delay(10000);
                    await leo.logBack()
                 }
                var currentMap = cga.GetMapName();
                    if(currentMap == '艾尔莎岛'){
                        await cga.ChangeNickName("3");
                        await console.log("退出脚本重新执行")
                        await leo.delay(2000)
                        await leo.exit();
                    }
                })
                }
                }

        }
        taskIndex++;
                await leo.delay(2000)
    }


    leo.loop(async ()=>{
        try{


            if(taskIndex == 0){
                await task0()
                console.log("已完成任务阶段：0")
            }
            if(taskIndex == 1){
                await task1()
                console.log("已完成任务阶段：1")
            }
            if(taskIndex == 2){
                await task2()
                console.log("已完成任务阶段：2")
            }
            if(taskIndex == 3){
                await task3()
                console.log("已完成任务阶段：3")
            }
            if(taskIndex >= 4){

                await leo.log('任务已完成')
                await leo.exit();//重启脚本
            }
            return leo.reject();
        }catch(e){
            console.log(leo.logTime()+'任务出错:'+e);
            await leo.delay(10000)
            console.log(leo.logTime()+'重新开始');
        }
    })
    .then(()=>leo.log('脚本结束'))

});
