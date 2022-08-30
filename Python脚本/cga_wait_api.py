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


g_chatMsg_asyncs=[]             #聊天回调
g_npcDialog_asyncs=[]           #对话框回调
g_serverShutdonw_asyncs=[]      #游戏窗口关闭通知
g_gameWndKeyDown_asyncs=[]      #游戏窗口按键通知
g_battleAction_asyncs=[]        #战斗状态变化通知
g_playerMenu_asyncs=[]          #菜单选择通知
g_workingResult_asyncs=[]       #工作状态通知
g_tradeStuffs_asyncs=[]         #交易物品变更
g_tradeDialog_asyncs=[]         #交易对话框通知
g_tradeState_asyncs=[]          #交易状态变更
g_downMap_asyncs=[]             #下载地图通知
g_connectionState_asyncs=[]     #连接状态变更
g_unitMenu_asyncs=[]            #菜单项通知
    


#定义一个咱们自己的聊天回调函数，回调聊天消息

#聊天信息回调通知函数
def ChatMsgNotify(msg):  #msg是聊天信息
    for q in g_chatMsg_asyncs:
        q.put_chat_msg(msg)
    g_chatMsg_asyncs.clear()

#对话框回调通知函数
def NPCDialogNotify(dlg):
    for q in g_npcDialog_asyncs:
        q.put_chat_msg(dlg)
    g_npcDialog_asyncs.clear()
    

def ServerShutdownNotify(val):
    for q in g_serverShutdonw_asyncs:
        q.put_chat_msg(val)
    g_serverShutdonw_asyncs.clear()

def GameWndKeyDownNotify(val):
    for q in g_gameWndKeyDown_asyncs:
        q.put_chat_msg(val)
    g_gameWndKeyDown_asyncs.clear()
def BattleActionNotify(val):
    for q in g_battleAction_asyncs:
        q.put_chat_msg(val)
    g_battleAction_asyncs.clear()
def PlayerMenuNotify(val):
    for q in g_playerMenu_asyncs:
        q.put_chat_msg(val)
    g_playerMenu_asyncs.clear()
def WorkingResultNotify(val):
    for q in g_workingResult_asyncs:
        q.put_chat_msg(val)
    g_workingResult_asyncs.clear()
def TradeStuffsNotify(val):
    for q in g_tradeStuffs_asyncs:
        q.put_chat_msg(val)
    g_tradeStuffs_asyncs.clear()
def TradeDialogNotify(val):
    for q in g_tradeDialog_asyncs:
        q.put_chat_msg(val)
    g_tradeDialog_asyncs.clear()
def TradeStateNotify(val):
    for q in g_tradeState_asyncs:
        q.put_chat_msg(val)
    g_tradeState_asyncs.clear()
def DownloadMapNotify(val):
    for q in g_downMap_asyncs:
        q.put_chat_msg(val)
    g_downMap_asyncs.clear()
def ConnectionStateNotify(val):
    for q in g_connectionState_asyncs:
        q.put_chat_msg(val)
    g_connectionState_asyncs.clear()
def UnitMenuNotify(val):
    for q in g_unitMenu_asyncs:
        q.put_chat_msg(val)
    g_unitMenu_asyncs.clear()


#注册回调函数
cga.RegisterChatMsgNotify(ChatMsgNotify)
cga.RegisterServerShutdownNotify(ServerShutdownNotify)
cga.RegisterGameWndKeyDownNotify(GameWndKeyDownNotify)
cga.RegisterBattleActionNotify(BattleActionNotify)
cga.RegisterPlayerMenuNotify(PlayerMenuNotify)
cga.RegisterNPCDialogNotify(NPCDialogNotify)
cga.RegisterWorkingResultNotify(WorkingResultNotify)
cga.RegisterTradeStuffsNotify(TradeStuffsNotify)
cga.RegisterTradeDialogNotify(TradeDialogNotify)
cga.RegisterTradeStateNotify(TradeStateNotify)
cga.RegisterDownloadMapNotify(DownloadMapNotify)
cga.RegisterConnectionStateNotify(ConnectionStateNotify)
cga.RegisterUnitMenuNotify(UnitMenuNotify)

    
#同步等待信息的类，队列实现
class AsyncWaitNotify:
    def __init__(self,global_wait_list):
        self._async_wait_queue=queue.Queue()    
        self._global_wait_list = global_wait_list
        self._global_wait_list.append(self)
    
    def put_chat_msg(self,msg):
        self._async_wait_queue.put(msg)        
    
    def __del__(self):
        pass                            
        #logging.info("析构")    
    
    def wait_msg_timeout(self,tSecond):    
        try:
            msg=self._async_wait_queue.get(timeout=tSecond)             
            self._async_wait_queue.task_done()
            if self in self._global_wait_list:
                self._global_wait_list.remove(self)
            return True,msg
        except Exception as error:      
            if self in self._global_wait_list:
                self._global_wait_list.remove(self)  
            return False,None          
        
        


# #定义一个函数，先忽略前面的async关键字
def 测试等待聊天消息(tSecond):    
    logging.info("数量%d"%(len(g_chatMsg_asyncs)))
    testWait = AsyncWaitNotify(g_chatMsg_asyncs)   
    logging.info("数量%d"%(len(g_chatMsg_asyncs)))
    r,msg=testWait.waitSysMsgTimeout(tSecond)
    if r:
        logging.info("等待成功")
        logging.info("ID："+ str(msg.unitid) + "消息:"+msg.msg + "颜色"+str(msg.color) + "范围"+ str(msg.size))
    else:
        logging.info("等待失败")
    logging.info("数量%d"%(len(g_chatMsg_asyncs)))
#API
def 等待聊天消息返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_chatMsg_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
#API
def 等待服务器返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_npcDialog_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
#API
def 等待工作返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_workingResult_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
#API
def 等待交易对话框返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_tradeDialog_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
#API
def 等待交易信息返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_tradeStuffs_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
#API
def 等待交易状态返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_tradeState_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
#API
def 等待菜单返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_playerMenu_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
#API
def 等待菜单项返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_unitMenu_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
#API
def 等待战斗返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_battleAction_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
#API
def 等待连接状态返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_connectionState_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
#API
def 等待窗口按键返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_gameWndKeyDown_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
#API
def 等待下载地图返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_downMap_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
#API
def 等待窗口关闭返回(tSecond=10):        
    testWait = AsyncWaitNotify(g_serverShutdonw_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
