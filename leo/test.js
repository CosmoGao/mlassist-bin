require('./common').then(async (cga) => {
	var playerinfo = cga.GetPlayerInfo();
	console.log('宠物ID： '+playerinfo.petid);
    leo.baseInfoPrint();                    //显示基础信息
});