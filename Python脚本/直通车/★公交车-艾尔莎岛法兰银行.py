#from common.func import *
from cgaapi import *
import sys


#主函数
def main():    
    print(sys.getfilesystemencoding())
    #获取当前地图名称
    mapName = cg.GetMapName()
    cg.log(mapName)                 #测试打印日志 辅助窗口可看
    cg.chat(mapName,2,3,5)          #测试游戏喊话 
    cg.chat_log(mapName)            #游戏窗口喊话+ 辅助窗口可看
    cg.g_debug_log=True             #打开内部日志调试 可打印日志辅助调试
    #cg.AutoMoveTo(197,152)

    #方法1：
    #   通过字典和地图名称，进行地图调用
    #方法2：
    #   通过if语句判断
    #如果地图比较多，写的比较少效率比较高的话，用法1，其他地图少就用法2就行
    mapNameForFun={}
    mapNameForFun={"艾尔莎岛":aiersa,"里谢里雅堡":libao,"法兰城":falan}
    while True:
        mapName = cg.GetMapName()
        if mapName in mapNameForFun:        
            mapNameForFun[mapName]()
        elif mapName == "银行": 
            return
    # if mapName == "艾尔莎岛":
    #     aiersa()

#艾尔莎岛执行函数
def aiersa():
    cg.Nowhile("艾尔莎岛")
    cg.AutoMoveTo(140,105)
    cg.TurnAbout(1)
    dlg= 等待服务器返回()
    if dlg:
        cg.log(dlg.message)
    cg.ClickNPCDialog(4,0)
    time.sleep(1)

#里堡执行函数
def libao():
    cg.Nowhile("里谢里雅堡")	
    cg.AutoMoveToEx(40,98,"法兰城")
	#回复(1)	
    #cg.AutoMoveToEx(41,50,"里谢里雅堡 1楼")	
    #cg.AutoMoveToEx(45,20,"启程之间")

#法兰城执行函数
def falan():
    cg.Nowhile("法兰城")
    cg.AutoMoveToEx(141,148,"法兰城")
    cg.TurnAbout(0)
    cg.NowhileEx("法兰城",63,79)
    cg.TurnAbout(0)
    cg.NowhileEx("法兰城",242,100)
    cg.AutoMoveToEx(238,111,"银行")

if __name__ == '__main__':
    main()
