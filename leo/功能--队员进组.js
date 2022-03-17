require(process.env.CGA_DIR_PATH_UTF8+'/leo').then(async (cga) => {
	var teamLeader = '队长名称'; //队长名称

	await leo.log('红叶の队员进组脚本，启动~')
	await leo.log('队长名称：【'+teamLeader+'】')

	await leo.loop( async ()=>{
		if(!leo.isInTeam()){
            await leo.enterTeamBlock(teamLeader)
        }
        await leo.delay(5000)
	})
    
    await leo.log('脚本结束')
});