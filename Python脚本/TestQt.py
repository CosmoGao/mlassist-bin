from PySide2.QtWidgets import QApplication, QMainWindow, QPushButton,  QPlainTextEdit,QLabel,QLineEdit,QMessageBox
from PySide2.QtCore import (QThread, Signal, Slot)
from multiprocessing import Process
import CGAPython
from common import *
import time             #时间库 用来打印时间 计时等等
import sys              #python代码和python解释器打交道的库
import os               #使用操作系统功能的函数库
import logging          #日志库，嫌弃python自带print功能单一，可以用这个打印
from threading import Thread
import asyncio

class MyThread(QThread):
    #signal_tuple = Signal(tuple)
    def __init__(self, x,y):
    #def __init__(self):
        super().__init__()
       # self.func = func
        self.x = x     
        self.y = y

    def run(self):
        logging.info("MyThread执行线程函数")
        cga.AutoMoveTo(self.x,self.y)
        logging.info("MyThread线程执行完成")
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
    #thread_ = MyThread(tgtX, tgtY)
    #thread_ = MyThread()
    #thread_.signal_tuple.connect(self.thread_finished)
    #thread_.start()
    #p.start()
    logging.info("start线程函数")
    #QApplication.processEvents()
    #asyncio.run(MoveThreadFunc(tgtX, tgtY))
def MoveFunc2():
    tgtX1 = int(lineEditX1.text())
    tgtY1 = int(lineEditY1.text())
    logging.info("移动到目标坐标"+"{},{}".format(str(tgtX1),str(tgtY1))) 
    thread = Thread(target = MoveThreadFunc,args= (tgtX1, tgtY1))   #python自带线程 也会阻塞界面
    thread.start()  
    logging.info("start线程函数")

def GetPosFunc():
    mappos=cga.GetMapCoordinate()    
    QMessageBox.about(window,"移动到目标坐标","{},{}".format(str(mappos.x),str(mappos.y)))
        
def MoveThreadFunc(x,y):
    logging.info("执行线程函数")
    #cga.WalkTo(x,y)
    AutoMoveInternal(x,y)
    #QApplication.processEvents()
    #cga.AutoMoveTo(x,y)        #c++封装的pyd 算是一个单独模块，线程调用它时候，发现会一直阻塞在这    用for循环测试是
    # for n in range(20):
        # logging.info(str(n))
        # time.sleep(1)        
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
lineEditX.setText("20")

labelY = QLabel(window)
labelY.setText("坐标Y")
labelY.move(10,70)
lineEditY = QLineEdit(window)
lineEditY.move(50,70)
lineEditY.setText("7")

labelX1 = QLabel(window)
labelX1.setText("T坐标X")
labelX1.move(180,25)
lineEditX1 = QLineEdit(window)
lineEditX1.move(230,25)
lineEditX1.setText("14")

labelY1 = QLabel(window)
labelY1.setText("T坐标Y")
labelY1.move(180,70)
lineEditY1 = QLineEdit(window)
lineEditY1.move(230,70)
lineEditY1.setText("18")


button = QPushButton('移动', window)
button.move(100,150)
button.clicked.connect(MoveFunc)

button2 = QPushButton('T移动', window)
button2.move(200,150)
button2.clicked.connect(MoveFunc2)


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
    sys.exit()  
# #单独用工具测试可以用把上面屏蔽了，用下面，4403是游戏端口，可以通过魔改信息界面看端口                                            #连接失败 退出当前python脚本，成功就继续下面代码
# if(cga.Connect(4403)==False):       #argv第一个程序路径 第二个参数是游戏端口
#    print('无法连接到本地服务端口，可能未附加到游戏或者游戏已经闪退！')
#    sys.exit()

#cga.Connect(4396)
#连接成功了，可以获取游戏信息了，你可以来打印一些角色信息


#咱们目的是去东门银行，那么首先需要知道自己当前位置

#获取当前地图名称
mapName=cga.GetMapName()
logging.info("当前地图名：" + mapName)       #打印一下，拼接字符串 + 

#创建一个线程 传递2个参数  这个线程放这里目的是让它的生命周期在整个程序运行范围内
#如果把此创建线程 放入函数，那么函数执行完成，线程释放时候，程序会异常结束
thread_ = MyThread(181,141)
cga.EnableFlags(6,0)
#创建新的进程
#p = Process(target=MoveThreadFunc, args=(int(lineEditX.text()),int(lineEditY.text())))
#p.start()#启动进程
#p.join()#等待进程结束

app.exec_()