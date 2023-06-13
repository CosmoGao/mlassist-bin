#基础包，用于连接游戏窗口，其他python文件引用此包即可
import CGAPython
import time
import sys
import os
import logging

#日志格式
LOG_FORMAT = "%(asctime)s %(message)s"
#配置日志
logging.basicConfig(level=logging.DEBUG, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S')


#创建CGA访问接口
cga=CGAPython.CGA()


#连接游戏窗口
if(cga.Connect(int(sys.argv[1]))==False):       #argv第一个程序路径 第二个参数是游戏端口
   print('无法连接到本地服务端口，可能未附加到游戏或者游戏已经闪退！')
   sys.exit()   
#单独用工具测试可以用把上面屏蔽了，用下面，4403是游戏端口，可以通过魔改信息界面看端口
# if(cga.Connect(4403)==False):       #argv第一个程序路径 第二个参数是游戏端口
#    print('无法连接到本地服务端口，可能未附加到游戏或者游戏已经闪退！')
#    sys.exit()
   
def test():
    logging.info("test")