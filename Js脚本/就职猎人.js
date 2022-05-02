require("./leo/common.js").then(async (cga) => {
        await leo.logBack()
                    .then(()=>leo.goto(n=>n.falan.eout))
                    .then(()=>leo.autoWalkList([
                        [681,343,'伊尔村'],[48,75]
                    ])).then(() => leo.learnPlayerSkill(48,76))
                    .then(()=>
            leo.autoWalkList([
                [45, 31, '芙蕾雅'],
                [649, 228]
            ])).then(() => Promise.resolve(cga.findPlayerSkill('狩猎体验')))
            .then((skill) => {
                return leo.loop(() => {
                    var count = cga.getItemCount('传说的鹿皮');
                    if (count > 0) {
                        return leo.reject()
                    }
                    cga.StartWork(skill.index, 0);
                    return leo.waitWorkResult()
                        .then(() => leo.pile(true))
                        .then(() => leo.delay(500));
                })
            })
            .then(() =>
                leo.autoWalkList([
                    [681, 343, '伊尔村'],
                    [48, 77]
                ]))
            .then(() => leo.talkNpc(0, leo.talkNpcSelectorYes))
            .then(() => leo.autoWalkList([
                    [35, 25, '装备店'],
                    [13, 17]
            ]))
           .then(() => leo.talkNpc(13, 16, (dialog) => {
                    cga.ClickNPCDialog(0, 0);
                    return false;
                }))

});