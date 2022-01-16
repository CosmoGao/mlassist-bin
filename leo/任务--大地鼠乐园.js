require('./common').then(cga => {
    //leo.baseInfoPrint();
    leo.monitor.config.keepAlive = false;   //关闭防掉线

    cga.EnableFlags(cga.ENABLE_FLAG_TEAMCHAT, false); //关闭队聊
    cga.EnableFlags(cga.ENABLE_FLAG_JOINTEAM, false); //关闭组队
    var prepareOptions = {
        rechargeFlag: 1,
        repairFlag: -1,
        crystalName: '水火的水晶（5：5）',
        doctorName: '医道之殇'
    };
    var playerinfo = cga.GetPlayerInfo();
    var playerName = playerinfo.name;
    var isTeamLeader = true;

    leo.log('红叶の大地鼠乐园任务脚本，启动~');

    var gotoNpc = ()=>{
        return leo.todo()
        .then(()=>{
            if(cga.getItemCount('王冠')==0){
                leo.log('身上没有【王冠】，脚本结束');
                return leo.reject();
            }
            if(cga.getItemCount('王冠')>1){
                leo.log('身上的【王冠】只能带1个，多余的请先存银行，脚本结束');
                return leo.reject();
            }
        })
        .then(()=>{
            return leo.loop(()=>{
                var mapInfo = cga.getMapInfo();
                if(mapInfo.name == '里谢里雅堡' || mapInfo.name == '法兰城'){
                    return leo.logBack();
                }
                if(mapInfo.name == '艾尔莎岛'){
                    return leo.autoWalk([165,153])
                    .then(()=>leo.talkNpc(2,leo.talkNpcSelectorYes,'利夏岛'));
                }
                if(mapInfo.name == '利夏岛'){
                    return leo.autoWalk([90,99,'国民会馆']);
                }
                if(mapInfo.name == '国民会馆'){
                    return leo.autoWalk([108,39,'雪拉威森塔１层']);
                }
                if(mapInfo.name == '雪拉威森塔１层'){
                    return leo.autoWalk([34,95])
                    .then(()=>leo.talkNpc(0,leo.talkNpcSelectorYes,'辛梅尔'));
                }
                if(mapInfo.name == '辛梅尔'){
                    return leo.autoWalk([181,81,'公寓'])
                    .then(()=>leo.autoWalk([89,58]))
                    .then(()=>leo.supply(89,57))
                    .then(()=>leo.autoWalk([100,70,'辛梅尔']))
                    .then(()=>leo.autoWalk([207,91,'光之路']));
                }
                if(mapInfo.name == '光之路' && mapInfo.x < 218){
                    return leo.autoWalk([214,194])
                    .then(()=>leo.talkNpc(0, leo.talkNpcSelectorYes))
                    .then(()=>leo.autoWalk([222,207]))
                    .then(()=>leo.reject());//退出循环，进入下一步
                }
                if(mapInfo.name == '光之路' 
                    && (mapInfo.x != 222 || mapInfo.y != 207)){
                    return leo.autoWalk([222,207])
                    .then(()=>leo.reject());//退出循环，进入下一步
                }
                return leo.delay(2000);
            });
        })
    }

    var task = async () => {
        await leo.waitAfterBattle()
        if(cga.GetPlayerInfo().gold < 5000){
            await leo.goto(n=>n.falan.bank)
            await leo.turnDir(0)
            await leo.moveGold(100000,cga.MOVE_GOLD_FROMBANK)
            await leo.moveGold(100000,cga.MOVE_GOLD_FROMBANK)
            await leo.moveGold(100000,cga.MOVE_GOLD_FROMBANK)
            await leo.moveGold(100000,cga.MOVE_GOLD_FROMBANK)
            await leo.moveGold(100000,cga.MOVE_GOLD_FROMBANK)
            if(cga.GetPlayerInfo().gold < 5000){
                await leo.log('钱到用时方恨少！请补充足够银子后重新执行脚本！')
                await leo.delay(10000000);
                return;
            }
        }

        if(cga.getItemCount('小礼包')==1){
            return leo.useItemEx('小礼包')
            .then(()=>leo.waitNPCDialog(dialog => {
                cga.ClickNPCDialog(4, -1);
                return leo.delay(2000);
            }));
        }else if(cga.getItemCount('小礼包')>1){
            return leo.dropItemEx('小礼包');
        }

        var emptyIndexes = leo.getEmptyBagIndexes();
        if(emptyIndexes.length == 0){
            await leo.goto(n=>n.falan.bank)
            await leo.turnDir(0)
            await leo.saveToBankAll()
            if(leo.getEmptyBagIndexes().length == 0){
                await leo.log('银行的空间不足，请清理银行后重新执行脚本！')
                await leo.delay(10000000);
                return;
            }
        }

        var mapInfo = cga.getMapInfo();
        if(mapInfo.x == 222 && mapInfo.y == 207){
            await leo.talkNpc(0, leo.talkNpcSelectorYes)
            await leo.delay(1000)
        }else{
            await gotoNpc()
        }
    }

    leo.loop(async ()=>{
        try{
            await task();
        }catch(e){
            await delay(10000);
            console.log(leo.logTime()+'出错:'+e);
            console.log(leo.logTime()+'重新开始');
        }
    })
    
});