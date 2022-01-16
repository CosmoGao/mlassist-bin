require('./common').then(async (cga) => {
    
	//leo.baseInfoPrint();
	console.log('红叶の琥珀之卵任务重置脚本，启动~');

	var words = ['安登','贝尔达','朵拉','爱蜜儿','弗里德里希'];

	if(cga.GetMapName()!='冒险者旅馆'){
		if(cga.GetMapName()!='艾尔莎岛'){
	        await leo.logBack()
	        await leo.delay(1000)
	        if(cga.GetMapName()!='艾尔莎岛'){
	            return leo.log('必须先定居新城【艾尔莎岛】');
	        }
	    }
	    await leo.autoWalk([157,93])
	    await leo.turnDir(0)
	    await leo.delay(1000)
	    await leo.autoWalkList([
	        [102,115,'冒险者旅馆']
	    ])
	}
	await leo.autoWalk([30,21])
	await leo.turnDir(6)
    var index = 0;
    await leo.loop(async ()=>{
    	if(index >= words.length){
    		return leo.reject()
    	}
    	index++;
	    await leo.say(words[index])
	    await leo.talkNpc(-1,-1,leo.talkYes)
    })
    await leo.log('完成')

});