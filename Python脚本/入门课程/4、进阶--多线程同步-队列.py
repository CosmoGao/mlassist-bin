#用Python的线程事件对象，实现等待游戏聊天内容功能
import CGAPython
import time
import sys
import os
import logging
import asyncio
import threading
import queue


   
#日志格式
LOG_FORMAT = "%(asctime)s %(message)s"
#配置日志
logging.basicConfig(level=logging.DEBUG, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S')
#打印日志  
logging.info("测试日志")


#创建CGA访问接口
cga=CGAPython.CGA()

#连接游戏窗口
if(cga.Connect(int(sys.argv[1]))==False):       #argv第一个程序路径 第二个参数是游戏端口
   print('无法连接到本地服务端口，可能未附加到游戏或者游戏已经闪退！')
   sys.exit()   

#实现一个队列
chat_msg_queue=queue.Queue()

#创建一个聊天信息全局变量，用来传递数据
globalMsg=CGAPython.cga_chat_msg_t()   


#定义一个咱们自己的聊天回调函数，回调聊天消息
def chatCallBack(msg):  #msg是聊天信息
    #logging.info("ID："+ str(msg.unitid) + "消息:"+msg.msg + "颜色"+str(msg.color) + "范围"+ str(msg.size))
    #这里收到聊天后，把聊天数据保存到咱们的全局变量中了，其他地方可以使用
    chat_msg_queue.put(msg)
    
    
#连接成功，注册聊天消息回调函数，用于接收当前游戏聊天数据，游戏有新的聊天信息时，会调用	chatCallBack函数
cga.RegisterChatMsgNotify(chatCallBack)


#定义一个函数，先忽略前面的async关键字
async def waitSysMsgTimeout(tSecond):    
    try:
        msg=chat_msg_queue.get(timeout=tSecond)      
        #if msg is not None:
        chat_msg_queue.task_done()
        logging.info("收到聊天消息")
        logging.info("ID："+ str(msg.unitid) + "消息:"+msg.msg + "颜色"+str(msg.color) + "范围"+ str(msg.size))
    except Exception as error:
        logging.info("超时")
  

#这里写个循环，调用上面的函数，调用等待函数，等待聊天信息，3秒超时时间，超时进入下一轮
while True :
    asyncio.run(waitSysMsgTimeout(3))
    
#这个打印，就是测试程序是否在上面循环
print("test1")