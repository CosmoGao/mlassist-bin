from PySide2.QtWidgets import QApplication, QMainWindow, QPushButton,  QPlainTextEdit,QLabel,QLineEdit,QMessageBox
from PySide2.QtCore import (QThread, Signal, Slot)
import CGAPython
import time             #时间库 用来打印时间 计时等等
import sys              #python代码和python解释器打交道的库
import os               #使用操作系统功能的函数库
import logging          #日志库，嫌弃python自带print功能单一，可以用这个打印
from threading import Thread
import asyncio

class MyThread(QThread):
    signal_tuple = Signal(tuple)
    def __init__(self, func, x,y):
        super().__init__()
        self.func = func
        self.x = x     
        self.y = y

    def run(self):
        logging.info("执行线程函数")
        cga.AutoMoveTo(self.x,self.y)
        logging.info("线程执行完成")
        #result = self.func(self.x,self.y)          
        # 任务完成后发出信号
        #self.signal_tuple.emit( result)
def MoveFunc():
    tgtX = int(lineEditX.text())
    tgtY = int(lineEditY.text())
    #QMessageBox.about(window,"移动到目标坐标","{},{}".format(str(tgtX),str(tgtY)))
    logging.info("移动到目标坐标"+"{},{}".format(str(tgtX),str(tgtY)))
    #cga.AutoMoveTo(tgtX,tgtY)     #移动到银行   界面会卡顿  放入线程执行
    thread = Thread(target = MoveThreadFunc,args= (tgtX, tgtY))   #python自带线程 也会阻塞界面
    thread.start()
    #thread_ = MyThread(MoveThreadFunc,tgtX, tgtY)
    #thread_.signal_tuple.connect(self.thread_finished)
    #thread_.start()
    logging.info("start线程函数")
    QApplication.processEvents()
    #asyncio.run(MoveThreadFunc(tgtX, tgtY))

def GetPosFunc():
    mappos=cga.GetMapCoordinate()    
    QMessageBox.about(window,"移动到目标坐标","{},{}".format(str(mappos.x),str(mappos.y)))
        
def MoveThreadFunc(x,y):
    logging.info("执行线程函数")
    #QApplication.processEvents()
    cga.AutoMoveTo(x,y)
    logging.info("线程执行完成")

app = QApplication([])

window = QMainWindow()
window.resize(500, 400)
window.move(300, 310)
window.setWindowTitle('启用')

labelX = QLabel(window)
labelX.setText("坐标X")
labelX.move(10,25)
lineEditX = QLineEdit(window)
lineEditX.move(50,25)
labelY = QLabel(window)
labelY.setText("坐标X")
labelY.move(10,70)
lineEditY = QLineEdit(window)
lineEditY.move(50,70)


button = QPushButton('移动', window)
button.move(380,80)
button.clicked.connect(MoveFunc)

button1 = QPushButton('获取坐标', window)
button1.move(380,120)
button1.clicked.connect(GetPosFunc)
window.show()

LOG_FORMAT = "%(asctime)s %(message)s"
#配置日志打印格式，这个就是logging包的语法了，设置格式
logging.basicConfig(level=logging.DEBUG, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S')
cga=CGAPython.CGA()

#连接游戏窗口，sys.argv[1]是固定格式，是启动当前脚本传递过来的参数
#argv第一个程序路径 第二个参数是游戏端口
if(cga.Connect(int(sys.argv[1]))==False):  #判断连接本机电脑上的，指定端口的游戏窗口是否成功      
    print('无法连接到本地服务端口，可能未附加到游戏或者游戏已经闪退！')      #系统自带的打印日志
    sys.exit()                                              #连接失败 退出当前python脚本，成功就继续下面代码
   
#cga.Connect(4396)
#连接成功了，可以获取游戏信息了，你可以来打印一些角色信息


#咱们目的是去东门银行，那么首先需要知道自己当前位置

#获取当前地图名称
mapName=cga.GetMapName()
logging.info("当前地图名：" + mapName)       #打印一下，拼接字符串 + 

    

app.exec_()