#登入点去东门银行脚本
# coding=utf-8

import CGAPython        #封装的游戏窗口通信API 有它才能和游戏窗口通信
#这些都是python的库，你也可以网上找相关库，然后导入进来
import time             #时间库 用来打印时间 计时等等
import sys              #python代码和python解释器打交道的库
import os               #使用操作系统功能的函数库
import logging          #日志库，嫌弃python自带print功能单一，可以用这个打印

#日志格式 
LOG_FORMAT = "%(asctime)s %(message)s"
#配置日志打印格式，这个就是logging包的语法了，设置格式
logging.basicConfig(level=logging.DEBUG, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S')
#打印日志  
logging.info("测试日志")

#创建CGA访问接口
cga=CGAPython.CGA()

#连接游戏窗口，sys.argv[1]是固定格式，是启动当前脚本传递过来的参数
#argv第一个程序路径 第二个参数是游戏端口
if(cga.Connect(int(sys.argv[1]))==False):  #判断连接本机电脑上的，指定端口的游戏窗口是否成功      
    print('无法连接到本地服务端口，可能未附加到游戏或者游戏已经闪退！')      #系统自带的打印日志
    sys.exit()                                              #连接失败 退出当前python脚本，成功就继续下面代码
   

#连接成功了，可以获取游戏信息了，你可以来打印一些角色信息


#咱们目的是去东门银行，那么首先需要知道自己当前位置

#获取当前地图名称
mapName=cga.GetMapName()
logging.info("当前地图名：" + mapName)       #打印一下，拼接字符串 + 
while True :                                 #写个循环 判断当前位置，直到到达银行结束
    mapName=cga.GetMapName()
    if(mapName=="艾尔莎岛"):
        cga.AutoMoveTo(140,105)     #移动到登入点
        cga.TurnTo(141,104)         #人物面朝指定坐标 进行对话 
        cga.ClickNPCDialog(4,0)     #对话选择 是
    elif mapName=="里谢里雅堡":
        cga.AutoMoveTo(65,53)
    elif mapName=="银行":
        logging.info("到达东门银行，脚本结束")
        break           
    elif mapName=="法兰城":
        cga.AutoMoveTo(238,111)     #移动到银行                    
    else:
        cga.LogBack()
    time.sleep(1)                #每次循环 等待1秒，防止过快，游戏没有响应完成    