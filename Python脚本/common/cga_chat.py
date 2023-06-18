#聊天信息缓存以及给外部提供等待接口
import CGAPython
import time
import sys
import os
import logging
import asyncio
import threading
import queue
from cgaapi import *

g_ChatMsg_Asyncs=[]

  
class ChatMsgNotifyData:
    def __init__(self,cb):
        self.time=time()
        self.callBack=cb
        self.result=False
        self.data=CGAPython.cga_chat_msg_t()   
    
    
class AsyncWaitChatMsg:
    def __init__(self):
        self.chat_msg_queue=queue.Queue()    
        g_ChatMsg_Asyncs.append(self)
    
    def putChatMsg(self,msg):
        self.chat_msg_queue.put(msg)
        logging.info("收到推送信息")
        logging.info("ID："+ str(msg.unitid) + "消息:"+msg.msg + "颜色"+str(msg.color) + "范围"+ str(msg.size))
    
    def __del__(self):
        logging.info("析构")
        #g_ChatMsg_Asyncs.remove(self)      #不能放在这 放这里 因为g_ChatMsg_Asyncs引用了它，永远调不到析构
    
    def waitSysMsgTimeout(self,tSecond):    
        try:
            msg=self.chat_msg_queue.get(timeout=tSecond)      
            #if msg is not None:
            self.chat_msg_queue.task_done()
            logging.info("收到聊天消息")
            logging.info("ID："+ str(msg.unitid) + "消息:"+msg.msg + "颜色"+str(msg.color) + "范围"+ str(msg.size))
            g_ChatMsg_Asyncs.remove(self)
            return True,msg
        except Exception as error:
            logging.info("等待聊天信息超时")     
            g_ChatMsg_Asyncs.remove(self)
            return False,None
           
        

g_ChatMsg_Caches=[]

 
#异步等待聊天消息函数 
#cb回调函数
#timeout超时时间
# def AsyncWaitChatMsg(cb,timeout):
    # if callable(cb)==False:
        # print("cb must be a function.")
        # return False
    # if timeout<0:
        # timeout=0
        
    # msgData=ChatMsgNotifyData(cb)
    # g_ChatMsg_Asyncs.put(msgData)
    # if timeout>0:
        
    
#定义一个咱们自己的聊天回调函数，回调聊天消息
def ChatMsgNotify(msg):  #msg是聊天信息
    #logging.info("ID："+ str(msg.unitid) + "消息:"+msg.msg + "颜色"+str(msg.color) + "范围"+ str(msg.size))
    #这里收到聊天后，把聊天数据保存到咱们的全局变量中了，其他地方可以使用
    logging.info("收到信息，推给类")
    for q in g_ChatMsg_Asyncs:
        q.putChatMsg(msg)
    g_ChatMsg_Asyncs.clear()
 #   chat_msg_queue.put(msg)


    
#连接成功，注册聊天消息回调函数，用于接收当前游戏聊天数据，游戏有新的聊天信息时，会调用	chatCallBack函数
cga.RegisterChatMsgNotify(ChatMsgNotify)


# #定义一个函数，先忽略前面的async关键字
def waitSysMsgTimeout(tSecond):    
    testWait = AsyncWaitChatMsg()   
    r,msg=testWait.waitSysMsgTimeout(3)
    if r:
        logging.info("异步等待")
        logging.info("ID："+ str(msg.unitid) + "消息:"+msg.msg + "颜色"+str(msg.color) + "范围"+ str(msg.size))
    #g_ChatMsg_Asyncs.remove(testWait)
  

# #这里写个循环，调用上面的函数，调用等待函数，等待聊天信息，3秒超时时间，超时进入下一轮
# while True :
    # asyncio.run(waitSysMsgTimeout(3))
    
#这个打印，就是测试程序是否在上面循环
# def localTestFun():
    # testWait = AsyncWaitChatMsg()
    # #while True :
    # #    testWait.waitSysMsgTimeout(3)
    # testWait.waitSysMsgTimeout(3)
    # testWait.waitSysMsgTimeout(3)
    # g_ChatMsg_Asyncs.remove(testWait)
# #    del testWait
# localTestFun()
# t1=threading.Thread(target=waitSysMsgTimeout,args=(3,))
# t2=threading.Thread(target=waitSysMsgTimeout,args=(3,))
# t1.start()
# t2.start()
# #asyncio.run(waitSysMsgTimeout(3))
# logging.info("test1")
# while True:
    # logging.info("1111111")
    # time.sleep(2)
  # pass