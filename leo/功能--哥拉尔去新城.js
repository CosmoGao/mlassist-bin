require(process.env.CGA_DIR_PATH_UTF8+'/leo').then(async (cga) => {
    leo.log('红叶の哥拉尔去新城脚本，启动~');
    leo.gotoElsaFromGrahl()
    .then(()=>leo.log('已经到达新城'));
});