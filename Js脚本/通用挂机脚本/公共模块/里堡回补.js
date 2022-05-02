var cga = global.cga;
var configTable = global.configTable;

module.exports = {
	func : (cb)=>{
		cga.travel.falan.toCastleHospital(()=>{
			setTimeout(cb, 5000);
		});
	},
	isLogBack : (map, mapindex)=>{
		return (map == '里谢里雅堡' || map == '艾尔莎岛') ? false : true;
	},
	isAvailable : (map, mapindex)=>{
		if(cga.travel.newisland.isSettled)
			return true;
		
		return (map == '里谢里雅堡' || map == '艾尔莎岛') ? true : false;
	},
	translate : (pair)=>{
		return false;
	},
	loadconfig : (obj)=>{
		return true;
	},
	inputcb : (cb)=>{
		cb(null);
	}
}