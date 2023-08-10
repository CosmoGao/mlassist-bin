#基础包，用于连接游戏窗口，其他python文件引用此包即可
import CGAPython
import time
import sys
import os
import logging
import glob
import math
import functools
from collections import namedtuple
import asyncio
import threading
import queue
from AStar import *

#封装元组，便于访问
CGPoint = namedtuple("CGPoint","x,y")
CGRect = namedtuple("CGRect","x,y,width,height")
#from common.func import *

#日志格式
LOG_FORMAT = "%(asctime)s %(message)s"
#配置日志
logging.basicConfig(level=logging.DEBUG, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S')

#单例模式类
def singleton(cls):
    """
    将一个类作为单例
    来自 https://wiki.python.org/moin/PythonDecoratorLibrary#Singleton
    """

    cls.__new_original__ = cls.__new__

    @functools.wraps(cls.__new__)
    def singleton_new(cls, *args, **kw):
        it = cls.__dict__.get('__it__')
        if it is not None:
            return it

        cls.__it__ = it = cls.__new_original__(cls, *args, **kw)
        it.__init_original__(*args, **kw)
        return it

    cls.__new__ = singleton_new
    cls.__init_original__ = cls.__init__
    cls.__init__ = object.__init__

    return cls

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
            return msg
        except Exception as error:      
            if self in self._global_wait_list:
                self._global_wait_list.remove(self)  
            return None  

@singleton
class CGAPI(CGAPython.CGA):   
   
   #是否停止-寻路、技能、遇敌等等
   g_stop=False
      
   #是否移动中--自动寻路时用
   g_is_moveing=False  

   #本次寻路循环次数--自动寻路时用
   g_navigatorLoopCount=0 

   #迷宫等待时间
   g_mazeWaitTime=5            #5秒

   #是否打印调试日志
   g_debug_log=False


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


   #构造函数
   def __init__(self):
      super().__init__()
      self.log=logging.info
      self.init_data()
      #self.debug_init_data(4397)      #如果要自己调试 打开这行代码 屏蔽上一行代码，把游戏端口号填入括号即可调试

   #打印日志
   def debug_log(self,txt):
      if(self.g_debug_log):
         logging.info(txt)

   #初始化数据-指定调试端口
   def debug_init_data(self,port):
      print(len(sys.argv))
      print(sys.argv[0])      
      if(self.Connect(int(port))==False):       #argv第一个程序路径 第二个参数是游戏端口
         print('无法连接到本地服务端口，可能未附加到游戏或者游戏已经闪退！')
         sys.exit() 
      self.registerCallBackFuns()

   #初始化数据
   def init_data(self):     
      print(len(sys.argv))
      print(sys.argv[0])
      if len(sys.argv) <= 1:
         self.log("参数错误！")
         sys.exit()
      if(self.Connect(int(sys.argv[1]))==False):       #argv第一个程序路径 第二个参数是游戏端口
         print('无法连接到本地服务端口，可能未附加到游戏或者游戏已经闪退！')
         sys.exit() 
      self.debug_log(sys.argv[0])
      self.debug_log(sys.argv[1])
      self.debug_log(os.getenv("CGA_DIR_PATH"))
      CGADirPath = os.getenv("CGA_DIR_PATH")
      pythonScriptPath = CGADirPath + "/Python脚本/"
      pythonScriptFiles = glob.glob(pythonScriptPath+"/官方脚本/*")
      sys.path.append(pythonScriptPath+'./common/') 
      for tFile in pythonScriptFiles:
         self.debug_log(tFile)
         sys.path.append(tFile)
      self.registerCallBackFuns()

   #注册回调函数，接收游戏通知信息
   def registerCallBackFuns(self):
      #注册回调函数
      self.RegisterChatMsgNotify(self.ChatMsgNotify)
      self.RegisterServerShutdownNotify(self.ServerShutdownNotify)
      self.RegisterGameWndKeyDownNotify(self.GameWndKeyDownNotify)
      self.RegisterBattleActionNotify(self.BattleActionNotify)
      self.RegisterPlayerMenuNotify(self.PlayerMenuNotify)
      self.RegisterNPCDialogNotify(self.NPCDialogNotify)
      self.RegisterWorkingResultNotify(self.WorkingResultNotify)
      self.RegisterTradeStuffsNotify(self.TradeStuffsNotify)
      self.RegisterTradeDialogNotify(self.TradeDialogNotify)
      self.RegisterTradeStateNotify(self.TradeStateNotify)
      self.RegisterDownloadMapNotify(self.DownloadMapNotify)
      self.RegisterConnectionStateNotify(self.ConnectionStateNotify)
      self.RegisterUnitMenuNotify(self.UnitMenuNotify)      
      
   #游戏喊话
   def chat(self,log,v1,v2,v3):     
      self.SayWords(str(log),v1,v2,v3)

   #日志+喊话
   def chat_log(self,log,v1=2,v2=3,v3=5):      
      self.log(log) 
      self.chat(log,v1,v2,v3)

   #获取人物职业
   def GetCharacterProfession(self):
      pass

   #获取人物信息
   def GetCharacterData(self,sType):
      playerinfo = self.GetPlayerInfo()
      match(sType):
         case("职业"):return self.GetCharacterProfession()
         case("名称"):return playerinfo.name
         case("name"):return playerinfo.name
         case("血"):return playerinfo.hp
         case("hp"):return playerinfo.hp
         case("魔"):return playerinfo.mp
         case("mp"):return playerinfo.hp
         case("等级"):return playerinfo.level
         case("level"):return playerinfo.level

   #人物转向
   def TurnAbout(self,nDir):  
      mappos=self.GetMapCoordinate()
      x=mappos.x
      y=mappos.y
      if(nDir==0):
         x = x
         y = y - 2
      elif(nDir==1):
         x = x + 2
         y = y - 2
      elif(nDir==2):
         x = x + 2
         y = y
      elif(nDir==3):
         x = x + 2
         y = y + 2
      elif(nDir==4):
         x = x
         y = y + 2
      elif(nDir==5):
         x = x - 2
         y = y + 2
      elif(nDir==6):
         x = x - 2
         y = y
      elif(nDir==7):
         x = x - 2
         y = y - 2
      self.TurnTo(x, y)

   def TurnAboutEx(self,x,y):
      self.TurnTo(x,y)

   #转换预定放行到self方向
   def TransDirectionToCGA(self,nDir):
      if nDir==0: 
         return 6
      elif nDir==1: 
         return 7
      elif nDir== 2: 
         return 0
      elif nDir== 3: 
         return 1
      elif nDir== 4: 
         return 2
      elif nDir== 5: 
         return 3
      elif nDir== 6: 
         return 4
      elif nDir== 7: 
         return 5	
      return nDir

   #获取地图编号
   def GetMapIndex(self):          #包装下 原生是返回4个值  这里只拿地图编号
      return super().GetMapIndex()[2]

   #强制移动-穿墙方向，步数，是否显示
   def ForceMoveToEx(self,nDir,distance=1,bShow=False):
      cgaDir = self.TransDirectionToCGA(nDir)
      while distance > 0:
         self.ForceMove(cgaDir,bShow)
         time.sleep(0.5)
         self.WaitInNormalState()
         distance=distance-1

   #获取指定技能-技能名称
   def FindPlayerSkillEx(self,name):
      skills = self.GetSkillsInfo()   
      for skill in skills:
         if skill.name == name:
               return skill
      return None

   #获取指定技能下标-技能名称
   def FindPlayerSkillIndex(self,name):
      skills = self.GetSkillsInfo()   
      for skill in skills:
         if skill.name == name:
               return skill.index
      return -1

   #等待到指定地图-地图名称，x坐标，y坐标
   def Nowhile(self,name):
      curMapName = self.GetMapName()
      curPoint = self.GetMapCoordinate()
      timeout = 60
      for i in range(timeout):
         curMapName = self.GetMapName()
         curPoint = self.GetMapCoordinate()
         if curMapName == name:
            return True		
         time.sleep(1)
      return False


   #等待到指定地图-地图名称，x坐标，y坐标
   def NowhileEx(self,name,x,y):
      curMapName = self.GetMapName()
      curPoint = self.GetMapCoordinate()
      timeout = 60
      for i in range(timeout):
         curMapName = self.GetMapName()
         curPoint = self.GetMapCoordinate()
         if curMapName == name and curPoint.x == x and curPoint.y == y:
            return True		
         time.sleep(1)
      return False
    
   #合成制造-技能名称，物品名称，超时时间
   def Work(self,name,itemName="",timeout=6.5):
      skills = self.GetSkillsInfo()
      index=-1
      for skill in skills:
         if skill.name == name:
               index=skill.index
               break
      if index<0:
         self.log("没有【"+name+"】技能")
         return False
      self.StartWork(index,0)
      
   #是否空闲状态
   def IsInNormalState(self):
      #self.debug_log("%d %d"%(self.GetWorldStatus(),self.GetGameStatus()))
      if self.GetWorldStatus() == 9 and self.GetGameStatus() == 3:
         return True 
      else: 
         return False

   #等待空闲状态
   def WaitInNormalState(self,timeout=10):
      if timeout == 0:
         timeout = 600    
      timeoutNum = timeout #10分钟 600秒 每次Sleep 1秒
      for i in range(timeoutNum):
         if self.g_stop:
               return False
         if self.IsInNormalState():
               return True
         time.sleep(1)
      return False

   #取迷宫所有出入口
   def GetMazeEntranceList(self):
      gateList=[]
      cells=self.GetMapCollisionTable(True)
      objCells=self.GetMapObjectTable(True)
      if cells.x_size ==0 and cells.y_size == 0:
         return gateList
      cellData = cells.cell
      ObjData = objCells.cell
      for y in range(cells.y_size):
         for x in range(cells.x_size):
               if x < objCells.x_size and y < objCells.y_size:
                  celObj = ObjData[x+y*objCells.x_size]
                  #日志("%d"%(celObj))
                  if celObj & 0xff:
                     #日志("%d"%(celObj))
                     if celObj & 0xff == 3:   #蓝色 迷宫传送点
                           #日志("x:%d y:%d %d"%(x,y,celObj))
                           #gateList.append({x:x,y:y}) 
                           #gateList.append({"x":x,"y":y})  
                           gateList.append(CGPoint(x=x,y=y))
                           #gateList.append((x,y))  
                           
                     else:       
                           pass                            #绿色 切换坐标点 传送门     
      return gateList
   #def 开始遇敌():

   #def 取包裹空格():

   #取当前地图可传送坐标点
   def GetMapEntranceList(self):
      gateList=[]
      cells=self.GetMapCollisionTable(True)
      objCells=self.GetMapObjectTable(True)
      if cells.x_size ==0 and cells.y_size == 0:
         return gateList
      ObjData = objCells.cell
      for y in range(cells.y_size):
         for x in range(cells.x_size):            
               celObj = ObjData[x+y*objCells.x_size]
               #日志("%d"%(celObj))
               if celObj & 0xff:
                  #日志("%d"%(celObj))           
                  #日志("x:%d y:%d %d"%(x,y,celObj))
                  #gateList.append({x:x,y:y}) 
                  #gateList.append({"x":x,"y":y})  
                  gateList.append(CGPoint(x=x,y=y))
                  #gateList.append((x,y))  
      return gateList

   #原坐标到目标坐标是否可达
   def IsReachableTargetEx(self,sx,sy,tx,ty):
      findPath = self.CalculatePath(sx, sy, tx, ty)
      if len(findPath) < 1:       #后期这里可以加离线寻路
         return False
      return True


   #寻路时候，判断目标坐标点是否能到达 返回True False
   def IsReachableTarget(self,tx,ty):
      curPos = self.GetMapCoordinate()
      return self.IsReachableTargetEx(curPos.x,curPos.y,tx,ty)

   #判断目标坐标是否可通行
   def judgePosIsWalkAble(self,x,y,cells,warpPosList,judgeReachTgt):
      bAble=False
      if cells.cell[x + y * cells.x_size] == 0 and CGPoint(x,y) not in warpPosList:
         bAble = True
      if bAble and judgeReachTgt:
         return self.IsReachableTarget(x, y)
      return bAble

   #获取指定坐标周围指定范围空位，judgeReachTgt是否判断坐标点可到达，防止坐标人过不去
   def GetRandomSpace(self,x,y,distance=1,judgeReachTgt=False):
      nTempX=nTempY=0
      warpPosList = self.GetMapEntranceList()  #传送点
      cells=self.GetMapCollisionTable(True)
      if x > cells.x_size or y > cells.y_size:
         return CGPoint(x=0,y=0)
      
      while True:
         nTempX=x-distance
         nTempY=y
         if self.judgePosIsWalkAble(nTempX, nTempY,cells,warpPosList,judgeReachTgt):
               break
         nTempX = x + distance
         nTempY = y
         if (self.judgePosIsWalkAble(nTempX, nTempY,cells,warpPosList,judgeReachTgt)):
               break
         nTempX = x
         nTempY = y - distance
         if (self.judgePosIsWalkAble(nTempX, nTempY,cells,warpPosList,judgeReachTgt)):
               break
         nTempX = x
         nTempY = y + distance
         if (self.judgePosIsWalkAble(nTempX, nTempY,cells,warpPosList,judgeReachTgt)):
               break
         nTempX = x + distance
         nTempY = y + distance
         if (self.judgePosIsWalkAble(nTempX, nTempY,cells,warpPosList,judgeReachTgt)):
               break
         nTempX = x - distance
         nTempY = y + distance
         if (self.judgePosIsWalkAble(nTempX, nTempY,cells,warpPosList,judgeReachTgt)):
               break
         nTempX = x + distance
         nTempY = y - distance
         if (self.judgePosIsWalkAble(nTempX, nTempY,cells,warpPosList,judgeReachTgt)):
               break
         nTempX = x - distance
         nTempY = y - distance
         if (self.judgePosIsWalkAble(nTempX, nTempY,cells,warpPosList,judgeReachTgt)):
               break
         break
      return CGPoint(nTempX, nTempY)
   #获取人物信息 类型
   def GetCharacterData(sType):
       playerinfo = self.GetPlayerInfo()
       match(sType):
           case("gid"):return playerinfo.gid
               
       

   #是否在迷宫地图
   def IsInRandomMap(self):
      #index1  0固定地图 否则随机地图  index2 当前线路 index3地图编号 filemap地图文件名
      if super().GetMapIndex()[0] == 0:
         return False
      return True
   
   #获取当前坐标距目标坐标的距离
   def GetDistance(self,x,y):
      curPos = self.GetMapCoordinate()
      if curPos.x == x and curPos.y == y:
         return 0
      return math.sqrt(math.pow(abs(curPos.x-x),2) + math.pow(abs(curPos.y-y),2))

   #获取源目标和目的坐标距离
   def GetDistanceEx(self,sx,sy,tx,ty):
      return math.sqrt(math.pow(abs(sx-tx),2) + math.pow(abs(sy-ty),2))

   #自动寻路 
   #返回0 正常完成 1退出中断  2地图变更中断 3地图下载失败
   def AutoMoveTo(self,x,y,timeout=100):
      if self.g_is_moveing:
         return 0
      self.g_navigatorLoopCount=0      
      #如果是组队状态 并且不是队长 则退出
      return self.AutoMoveInternal(x, y, timeout)

   def AutoMoveToEx(self,x,y,mapName="",timeout=100):
      if len(mapName)==0:
         return self.AutoMoveTo(x,y,timeout)
      else:     
         tryNum=0
         while tryNum < 3:
            self.AutoMoveTo(x,y,timeout)
            curMapName = self.GetMapName()
            curMapNum = self.GetMapIndex()
            if (len(mapName) > 0):
               if (self.IsInNormalState() and (curMapName == mapName or (mapName.isdigit() and curMapNum == int(mapName)))):              
                  #到达目标地 返回1  否则尝试3次后返回0
                  return 1
               
            tryNum=tryNum+1
         self.log("尝试3次后，到达目标地图失败%s %d %d "%(mapName,x,y))
      return 0
   

   #寻路内部代码   返回0 正常完成 1退出中断  2地图变更中断 3地图下载失败 
   def AutoMoveInternal(self,x, y, timeout=100, isLoop=True):
      self.debug_log("目标坐标点:x:%d,y:%d" % (x,y))
      if self.g_navigatorLoopCount>=20:
         return 0
      curPos = self.GetMapCoordinate()
      if curPos.x == x and curPos.y == y :
         warpPosList = self.GetMapEntranceList()
         if CGPoint(x=x,y=y) in warpPosList:
               self.debug_log("AutoMoveTo 坐标一样 目标为传送点，重新进入！")
               tmpPos = self.GetRandomSpace(x, y, 1)
               self.WalkTo(tmpPos.x, tmpPos.y)
               time.sleep(2)
               self.WalkTo(x, y)
         self.debug_log("AutoMoveTo 坐标一样 返回！")
         return 1
      self.g_is_moveing=True
      self.WaitInNormalState()
      isOffLineMap = False
      curPos = self.GetMapCoordinate()
      findPath = self.CalculatePath(curPos.x,curPos.y,x,y)
      tRet=0
      if len(findPath) > 0 :      
         tRet=self.AutoNavigator(findPath,isOffLineMap, isLoop)
      else:
         self.debug_log("路径为空")    #可以增加离线地图寻路
      self.g_is_moveing=False
      return tRet

   #寻路判断逻辑
   def AutoNavigator(self,path,isSyncMap=False,isLoop=True):
      if len(path) < 1:
         return False      
      self.g_navigatorLoopCount=self.g_navigatorLoopCount+1
      backPath = path
      curX=curY=tarX=tarY=lastX=lastY=0
      curMapIndex = self.GetMapIndex()
      curMapName = self.GetMapName()
      dwTimeoutTryCount = dwCurTime = dwLastTime=0
      isNormal=True
      warpPosList=self.GetMapEntranceList()
      startPos=self.GetMapCoordinate()
      if path[0].x == startPos.x and path[0].y == startPos.y:
         path=path[1:]
      for coor in path:
         if self.g_stop:
               break
         tarX = coor.x
         tarY = coor.y
         self.debug_log("目标：%d %d"%(coor.x,coor.y))
         walkprePos =self.GetMapCoordinate()         #记录下移动前坐标
         self.WalkTo(coor.x,coor.y)
         dwLastTime=dwTimeoutTryCount=0
         while not self.g_stop:
               #//1、判断战斗和切图
               while not self.IsInNormalState() and not self.g_stop: #战斗或者切图 等待完毕
                  isNormal = False
                  time.sleep(1)
               #//2、判断地图是否发送变更 例如：迷宫送出来，登出，切到下个图
               if (curMapIndex != self.GetMapIndex() or curMapName != self.GetMapName()):
                  self.debug_log("当前地图更改，寻路判断！")
                  lastWarpMap202=0
                  while (self.GetGameStatus() == 202):
                     if lastWarpMap202==0:
                           lastWarpMap202=lastWarpMap202+1
                     elif lastWarpMap202>=5:
                           self.FixMapWarpStuck(0)
                           lastWarpMap202=lastWarpMap202+1
                           self.debug_log("切换地图 卡住 fix warp")
                     time.sleep(1)
                  self.WaitInNormalState()
                  #再次判断 有些会卡回原图，这里再次判断
                  if (curMapIndex == self.GetMapIndex() and curMapName == self.GetMapName() and isLoop):
                  #//重新执行一次重新寻路
                     self.debug_log( "还在原图：重新查找路径 进行寻路")
                     tgtPos = backPath.end()
                     return self.AutoMoveInternal(tgtPos.x, tgtPos.y, False)
                  else:				
                     self.debug_log("地图更改，寻路结束！")
                     if (self.IsInRandomMap()):
                           time.sleep(self.g_mazeWaitTime)
                     return False
            #调换顺序 战斗或者切图后，还在本地图，再次执行 有问题 就是同一个地图 但是是个传送点
               if not isNormal:    #刚才战斗和切图了 现在重新执行最后一次坐标点任务
                  self.debug_log("战斗/切图等待，再次寻路！%d %d" % (tarX,tarY))
                  if self.GetDistance(tarX, tarY) > 11:
                     self.debug_log("战斗/切图等待，再次寻路 距离大于11 刚才可能为传送 返回!%d %d" % (tarX,tarY))
                     curPos = self.GetMapCoordinate()
                     findPath = self.CalculatePath(curPos.x, curPos.y, tarX, tarY)
                     if len(findPath) > 0 and isLoop:
                           self.AutoNavigator(findPath, isSyncMap, False)
                     else:
                           self.debug_log("战斗/切图等待，再次寻路失败！%d %d" % (tarX,tarY))
                  else:
                     if not self.IsReachableTarget(walkprePos.x, walkprePos.y):#用移动前点判断 不能到 说明换图成功，特别是ud这个图
                           self.debug_log( "原坐标不可达，移动至目标点成功，寻路结束！")
                           self.WaitInNormalState()
                           return True
                     else:
                           self.WalkTo(tarX,tarY)

                  dwLastTime = 0
                  isNormal = True
               #//3、判断是否到达目的地
               curPos = self.GetMapCoordinate()
               if curPos.x == tarX and curPos.y == tarY:
                  if CGPoint(tarX,tarY) in warpPosList:
                     self.debug_log("目标为传送点,判断地图切换：%d %d" % (tarX,tarY))
                     tryNum=0
                     fixWarpTime = time.time()
                     while tryNum < 3:
                           if time.time() - fixWarpTime > 5000:
                              while (self.GetGameStatus() == 202):
                                 if lastWarpMap202==0:
                                       lastWarpMap202=lastWarpMap202+1
                                 elif lastWarpMap202>=5:
                                       self.FixMapWarpStuck(0)
                                       lastWarpMap202=lastWarpMap202+1
                                       self.debug_log("切换地图 卡住 fix warp")
                                 time.sleep(1) 
                              self.WaitInNormalState()
                              tryNum=tryNum+1
                              fixWarpTime = time.time()
                              curPos = self.GetMapCoordinate()
                              if curMapIndex != self.GetMapIndex() or curMapName != self.GetMapName():
                                 self.WaitInNormalState()
                                 if self.IsInRandomMap():
                                       time.sleep(self.g_mazeWaitTime)
                                 return True
                              elif curMapIndex == self.GetMapIndex() and curMapName != self.GetMapName() and (curPos.x != tarX or curPos.y != tarY):
                                 self.WaitInNormalState()
                                 return True
                              elif curMapIndex == self.GetMapIndex() and curMapName != self.GetMapName() and (curPos.x != tarX or curPos.y != tarY):
                                 if not self.IsReachableTarget(walkprePos.x, walkprePos.y):#用移动前点判断 不能到 说明换图成功，特别是ud这个图
                                       self.debug_log( "原坐标不可达，移动至目标点成功，寻路结束！")
                                       self.WaitInNormalState()
                                       return True
                                 self.debug_log( "到达目标点，目标为传送点，地图卡住，切回地图,重新寻路%d %d"%(tarX,tarY))
                                 self.FixMapWarpStuck(1)
                                 curPos = self.GetMapCoordinate()
                                 if not isLoop:
                                       self.WalkTo(tarX,tarY)
                                       return True
                                 else:
                                       bTryRet= False
                                       if curPos.x == tarX and curPos.y==tarY:
                                          tmpPos=self.GetRandomSpace(curPos.x,curPos.y,1)
                                          self.AutoMoveInternal(tmpPos.x,tmpPos.y,False)
                                          bTryRet = self.AutoMoveInternal(tarX, tarY, False)
                                       else:
                                          bTryRet = self.AutoMoveInternal(tarX, tarY, False)
                                       return bTryRet
                              tryNum=tryNum+1
                           else:
                              curPos = self.GetMapCoordinate()
                              if curMapIndex != self.GetMapIndex() or curMapName != self.GetMapName():
                                 self.WaitInNormalState()
                                 if self.IsInRandomMap():
                                       time.sleep(self.g_mazeWaitTime)
                                 return True
                              elif curMapIndex == self.GetMapIndex() and curMapName != self.GetMapName() and (curPos.x != tarX or curPos.y != tarY):
                                 self.WaitInNormalState()
                                 return True
                           time.sleep(1)
                     if not IsReachableTarget(walkprePos.x, walkprePos.y):   #用移动前点判断 不能到 说明换图成功，特别是ud这个图
                           self.debug_log( "原坐标不可达，移动至目标点成功，寻路结束！")
                           self.WaitInNormalState()
                           return True
                     else:
                           self.debug_log("当前为传送点，但原坐标可达，重新移动至目标点，不判断目标点，寻路结束！%d %d"%(tarX,tarY))
                           self.WalkTo(tarX,tarY)
                           self.WaitInNormalState()
                           return True
                  break
               #//4、判断玩家有没有自己点击坐标移动 有的话 等游戏人物不动时，重新执行最后一次移动
               dwCurTime=time.time()
               if lastX == curPos.x and lastY == curPos.y:
                  if dwLastTime == 0:
                     dwLastTime= dwCurTime
                  else:
                     if dwLastTime - dwCurTime > 10:
                           dwTimeoutTryCount=dwTimeoutTryCount+1
                           if dwTimeoutTryCount>=3:
                              return False
                           dwLastTime= dwCurTime
                           self.WaitInNormalState()
                           curPos = self.GetMapCoordinate()
                           findPath = self.CalculatePath(curPos.x, curPos.y, tarX, tarY)
                           if len(findPath) == 1 or  not isLoop:
                              self.WalkTo(tarX,tarY)
                           elif len(findPath) > 1 and isLoop:
                              if self.AutoMoveInternal(tarX,tarY,False) == False:
                                 return False
                              dwLastTime=dwCurTime                            
                           else:
                              self.debug_log("目标不可达，返回！！%d %d" % (tarX,tarY))
                              return False
               lastX = curPos.x
               lastY = curPos.y
               time.sleep(0.01)
      self.WaitInNormalState()
      return True


                                 













   #通过A*算法，查找当前点到目标点的路径
   def CalculatePath(self,curX, curY, targetX, targetY):
      self.debug_log("计算路径")
      cells=self.GetMapCollisionTable(True)
      objCells=self.GetMapObjectTable(True)
      if cells.x_size ==0 and cells.y_size == 0:
         return []
      self.debug_log("地图大小:%d %d"%(cells.x_size,cells.y_size))
      #如果不定义局部变量 以c++方式在for循环取值，慢的要死
      cellData = cells.cell
      objData = objCells.cell
      aStarFindPath = AStar(True,True)
      grid = AStarGrid(cells.x_size, cells.y_size)
      for y in range(cells.y_size):
         for x in range(cells.x_size):    
               index=x+y*cells.x_size            
               cellObj = objData[x+y*cells.x_size]
               cellWall = cellData[x+y*cells.x_size]
               if cellWall == 1:#不可通行
                  grid.SetWalkableAt(x, y, False)          #灰色 不可行
               else:
                  grid.SetWalkableAt(x, y, True)					
                  if (cellObj & 0xff):                         #路径上有传送门之类的 并且坐标不是目的坐标 跳过
                     if (x != targetX or y != targetY):
                           grid.SetWalkableAt(x, y, False)         #灰色 不可行                        
      self.debug_log("构造AStart Fini")						
      frompos=PathPoint(curX - cells.x_bottom, curY - cells.y_bottom)
      topos=PathPoint(targetX - cells.x_bottom, targetY - cells.y_bottom)
      self.debug_log("起点:x:%d,y:%d 终点:x:%d,y:%d" % (frompos.x, frompos.y, topos.x, topos.y))
      path = aStarFindPath.FindPath(frompos.x, frompos.y, topos.x, topos.y, grid)  
      #return path 
      findPath = AStarUtil.compressPath(path)		   
      return findPath




   #聊天信息回调通知函数
   def ChatMsgNotify(self,msg):  #msg是聊天信息
      for q in self.g_chatMsg_asyncs:
         q.put_chat_msg(msg)
      self.g_chatMsg_asyncs.clear()

   #对话框回调通知函数
   def NPCDialogNotify(self,dlg):
      for q in self.g_npcDialog_asyncs:
         q.put_chat_msg(dlg)
      self.g_npcDialog_asyncs.clear()
      

   def ServerShutdownNotify(self,val):
      for q in self.g_serverShutdonw_asyncs:
         q.put_chat_msg(val)
      self.g_serverShutdonw_asyncs.clear()

   def GameWndKeyDownNotify(self,val):
      for q in self.g_gameWndKeyDown_asyncs:
         q.put_chat_msg(val)
      self.g_gameWndKeyDown_asyncs.clear()

   def BattleActionNotify(self,val):
      for q in self.g_battleAction_asyncs:
         q.put_chat_msg(val)
      self.g_battleAction_asyncs.clear()

   def PlayerMenuNotify(self,val):
      for q in self.g_playerMenu_asyncs:
         q.put_chat_msg(val)
      self.g_playerMenu_asyncs.clear()

   def WorkingResultNotify(self,val):
      for q in self.g_workingResult_asyncs:
         q.put_chat_msg(val)
      self.g_workingResult_asyncs.clear()

   def TradeStuffsNotify(self,val):
      for q in self.g_tradeStuffs_asyncs:
         q.put_chat_msg(val)
      self.g_tradeStuffs_asyncs.clear()

   def TradeDialogNotify(self,val):
      for q in self.g_tradeDialog_asyncs:
         q.put_chat_msg(val)
      self.g_tradeDialog_asyncs.clear()

   def TradeStateNotify(self,val):
      for q in self.g_tradeState_asyncs:
         q.put_chat_msg(val)
      self.g_tradeState_asyncs.clear()

   def DownloadMapNotify(self,val):
      for q in self.g_downMap_asyncs:
         q.put_chat_msg(val)
      self.g_downMap_asyncs.clear()

   def ConnectionStateNotify(self,val):
      for q in self.g_connectionState_asyncs:
         q.put_chat_msg(val)
      self.g_connectionState_asyncs.clear()

   def UnitMenuNotify(self,val):
      for q in self.g_unitMenu_asyncs:
         q.put_chat_msg(val)
      self.g_unitMenu_asyncs.clear()


   def 等待聊天消息返回(self,tSecond=10):        
    testWait = AsyncWaitNotify(self.g_chatMsg_asyncs)       
    return testWait.wait_msg_timeout(tSecond)
   #API
   def 等待服务器返回(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_npcDialog_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def 等待工作返回(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_workingResult_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def 等待交易对话框返回(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_tradeDialog_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def 等待交易信息返回(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_tradeStuffs_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def 等待交易状态返回(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_tradeState_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def 等待菜单返回(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_playerMenu_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def 等待菜单项返回(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_unitMenu_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def 等待战斗返回(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_battleAction_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def 等待连接状态返回(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_connectionState_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def 等待窗口按键返回(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_gameWndKeyDown_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def 等待下载地图返回(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_downMap_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def 等待窗口关闭返回(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_serverShutdonw_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   
   #是否目标坐标附近
   def IsNearTarget(self,x,y,dis=1):
      curPos = self.GetMapCoordinate()
      if(abs(curPos.x) - x ) <= dis and (abs(curPos.y)-y) <= dis:
         #self.debug_log("目标附近")
         return True
      #self.debug_log("不在目标附近")
      return False

   #目标坐标是否存在墙
   def IsTargetExistWall(self,x,y):
      cells = self.GetMapCollisionTable(True)
      if x > cells.x_size or y > cells.y_size:
         self.debug_log("坐标超出地图范围:x:%d,y:%d" % (x,y))
         return -1
      
      cellData = cells.cell
      if cellData[x+y*cells.x_size] == 0:
         return 0
      else:
         return 1
       

   #移动到坐标附近
   def MoveToNpcNear(self,x,y,dis=1):
      if dis<1:
         dis = 1
      pos = self.GetRandomSpace(x,y,dis)
      #self.debug_log("空地%d,%d"%(pos.x,pos.y))
      if (self.IsTargetExistWall(pos.x,pos.y)):
         return False
      self.AutoMoveTo(pos.x,pos.y)
      if(self.GetMapCoordinate() == pos):
         return True
      return False

   def TalkNpcClicked(self,dlg,selectVal):
      if dlg==None:
         return False
      match(dlg.options):
         case 12:
            self.ClickNPCDialog(selectVal, -1)
            return True
         case 32:
            self.ClickNPCDialog(32, -1)
            return True
         case 1:
            self.ClickNPCDialog(1, -1)
            return True
         case 2:
            self.ClickNPCDialog(2, -1)
            return True
         case 3:
            self.ClickNPCDialog(1, -1)
            return True
         case 4:
            self.ClickNPCDialog(4, -1)
            return True
         case 8:
            self.ClickNPCDialog(8, -1)
            return True
         case 0:
            return True
         case _:
            return False
      return False
   def TalkNpcSelectYes(self,x,y,count=32):
      talkCount=3
      dlg=None
      while(talkCount and not self.g_stop and not dlg):
         self.TurnTo(x,y)
         dlg = self.等待服务器返回()
         talkCount=talkCount-1
      bTalkNpc = self.TalkNpcClicked(dlg,4)
      count=count-1
      while (count and not self.g_stop and bTalkNpc):
         dlg = self.等待服务器返回()
         bTalkNpc = self.TalkNpcClicked(dlg,4)
         count=count-1
      return bTalkNpc

   def TalkNpcPosSelectYes(self,x,y,count=32):
      if not (self.IsNearTarget(x,y,1)):
         self.MoveToNpcNear(x,y)
      return self.TalkNpcSelectYes(x,y,count)


#返回单例对象
cg = CGAPI()
人物 = cg.GetCharacterData
日志 = cg.chat_log
取当前地图编号 = cg.GetMapIndex
取当前地图名 = cg.GetMapName
等待 = time.sleep
回城 = cg.LogBack
转向 = cg.TurnAbout
对话选是 = cg.TalkNpcPosSelectYes