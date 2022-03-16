require(process.env.CGA_DIR_PATH_UTF8+'/leo').then(async (cga) => {
	var waitPos = [11, 8]; 
	await leo.log('红叶の银行全存脚本，启动~');
	if(leo.getMapInfo().name != '银行'){
		await leo.loop(async()=>{
			if(leo.getMapInfo().name == '银行') {
				return leo.reject();
			}
			try{
				await leo.goto(n => n.falan.bank)			
			}catch(e){
				console.log(leo.logTime()+'出错，e:' + e);
			}
			await leo.delay(1000)
		})
	}
	if(leo.getMapInfo().name == '银行'){
		await leo.autoWalk(waitPos)
	}
	await leo.turnDir(0)
	await leo.saveToBankAll()
	await leo.log('红叶の银行全存脚本，已完成')
	
});