--重新加载模块脚本，修改公共模块后，可以点击界面按钮重新加载模块

function reload( moduleName )  
	package.loaded[moduleName] = nil  
	return require(moduleName)  
end
--把需要重新加载的模块加入下面就行，就几个，不写列表了
common=reload("common")
