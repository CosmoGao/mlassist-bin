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
import enum
import requests
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
class GameInfo:
   def __init__(self) -> None:
      self.name=""
      self.hp=0
      self.maxhp=0
      self.mp=0
      self.maxmp=0
      self.xp=0
      self.maxxp=0
      self.health=0
      self.id=0
      self.showname=""
      self.realname=""
      self.level=0
class GameTeamPlayer(GameInfo):
   def __init__(self) -> None:         
      self.nick_name=""
      self.title_name=""
      self.injury=0         
      self.is_me=False         
      self.x=0
      self.y=0
      self.unit_id=0      
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


TCharacter_Action_PK = 1			      #PK
TCharacter_Action_JOINTEAM = 3		   #加入队伍
TCharacter_Action_EXCAHNGECARD = 4     #交换名片
TCharacter_Action_TRADE = 5		      #交易
TCharacter_Action_KICKTEAM = 11	      #剔除队伍
TCharacter_Action_LEAVETEAM = 12	   #离开队伍
TCharacter_Action_TRADE_CONFIRM = 13  #交易确定
TCharacter_Action_TRADE_REFUSE = 14   #交易取消
TCharacter_Action_TEAM_CHAT = 15	   #队聊
TCharacter_Action_REBIRTH_ON = 16	   #开始摆摊
TCharacter_Action_REBIRTH_OFF = 17	   #停止摆摊
TCharacter_Action_Gesture = 18		   #人物动作

TPET_STATE_NONE = 0
TPET_STATE_READY = 1  #待命
TPET_STATE_BATTLE = 2 #战斗
TPET_STATE_REST = 3   #休息
TPET_STATE_WALK = 16  #散步

MOVE_DIRECTION_Origin = 0	   #原地
MOVE_DIRECTION_North = 0	   #MOVE_DIRECTION_North			北
MOVE_DIRECTION_NorthEast = 1 #MOVE_DIRECTION_NorthEast		东北
MOVE_DIRECTION_East = 2	   #MOVE_DIRECTION_RIGH				东
MOVE_DIRECTION_SouthEast = 3 #MOVE_DIRECTION_SouthEast		东南
MOVE_DIRECTION_South = 4	   #MOVE_DIRECTION_South			南
MOVE_DIRECTION_SouthWest = 5 #MOVE_DIRECTION_WestDOWN			西南
MOVE_DIRECTION_West = 6	   #MOVE_DIRECTION_West				西
MOVE_DIRECTION_NorthWest = 7 #MOVE_DIRECTION_WestUP			西北

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

   g_gui_port=0
   g_game_port=0


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
      self.g_gui_port = os.getenv("CGA_GUI_PORT")
      self.g_game_port = os.getenv("CGA_GAME_PORT")
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

   
   def getFriendServerLine(self,friendName):
      if(friendName == None):
         return 0
      friendCards = self.GetCardsInfo()
      for friendCard in friendCards:
         if friendCard.name == friendName:
            return friendCard.server
      return 0
   def changeLineFollowLeader(self,leaderName):
      if(leaderName==None):
         return
      if(self.GetPlayerInfo().name == leaderName):
         return
      leaderServerLine = self.getFriendServerLine(leaderName)
      if(leaderServerLine==0):
         return
      curLine=super().GetMapIndex()[1]
      if(curLine == 0):
         return
      if(leaderServerLine != curLine):         
         requests.post("http://127.0.0.1:"+self.g_gui_port+'/cga/LoadAccount',{"server":leaderServerLine} ,json=True)
         self.LogOut()	
         #登录游戏()	#--如果有自动登录 这步不需要
                
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
   
   def TurnAboutPointDir(self,x,y):
      nDir = self.GetOrientation(x, y)
      self.TurnAbout(nDir)

   def GetOrientation(self,tx, ty):
      p = self.GetMapCoordinate()
      return self.GetDirection(p.x, p.y, tx, ty)

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
   def GetMapNumber(self):          #包装下 原生是返回4个值  这里只拿地图编号
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
   def WaitForMap(self,name):
      self.Nowhile(name)
   def WaitForMapEx(self,name,x,y):
      self.NowhileEx(name,x,y)
   #等待到指定地图-地图名称，x坐标，y坐标
   def Nowhile(self,name):
      timeout = 60
      if type(name) == int:
         for i in range(timeout):
            if self.g_stop:
               return False  
            curMapIndex = self.GetMapNumber()
            if self.IsInNormalState() and curMapIndex == name:
               return True		
            time.sleep(1)
      elif type(name) == str:         
         for i in range(timeout):
            if self.g_stop:
               return False
            curMapName = self.GetMapName()         
            if self.IsInNormalState() and curMapName == name:
               return True		
            time.sleep(1)
      return False


   #等待到指定地图-地图名称，x坐标，y坐标
   def NowhileEx(self,name,x,y): 
      timeout = 60
      if type(name) == int:
         for i in range(timeout):
            if self.g_stop:
               return False           
            curPoint = self.GetMapCoordinate()
            curMapIndex = self.GetMapNumber()
            if self.IsInNormalState() and curMapIndex == name and curPoint.x == x and curPoint.y == y:
               return True		
            time.sleep(1)
      elif type(name) == str:         
         for i in range(timeout):
            if self.g_stop:
               return False
            curMapName = self.GetMapName()
            curPoint = self.GetMapCoordinate()           
            if self.IsInNormalState() and curMapName == name and curPoint.x == x and curPoint.y == y:
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
            curMapNum = self.GetMapNumber()
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
      curMapIndex = self.GetMapNumber()
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
               if (curMapIndex != self.GetMapNumber() or curMapName != self.GetMapName()):
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
                  if (curMapIndex == self.GetMapNumber() and curMapName == self.GetMapName() and isLoop):
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
                              if curMapIndex != self.GetMapNumber() or curMapName != self.GetMapName():
                                 self.WaitInNormalState()
                                 if self.IsInRandomMap():
                                       time.sleep(self.g_mazeWaitTime)
                                 return True
                              elif curMapIndex == self.GetMapNumber() and curMapName != self.GetMapName() and (curPos.x != tarX or curPos.y != tarY):
                                 self.WaitInNormalState()
                                 return True
                              elif curMapIndex == self.GetMapNumber() and curMapName != self.GetMapName() and (curPos.x != tarX or curPos.y != tarY):
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
                              if curMapIndex != self.GetMapNumber() or curMapName != self.GetMapName():
                                 self.WaitInNormalState()
                                 if self.IsInRandomMap():
                                       time.sleep(self.g_mazeWaitTime)
                                 return True
                              elif curMapIndex == self.GetMapNumber() and curMapName != self.GetMapName() and (curPos.x != tarX or curPos.y != tarY):
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

   #API
   def WaitRecvChatMsg(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_chatMsg_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def WaitRecvNpcDialog(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_npcDialog_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def WaitRecvWorkingResult(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_workingResult_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def WaitRecvTradeDialog(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_tradeDialog_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def WaitRecvTradeStuffs(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_tradeStuffs_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def WaitRecvTradeState(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_tradeState_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def WaitRecvPlayerMenu(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_playerMenu_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def WaitRecvUnitMenu(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_unitMenu_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def WaitRecvBattleAction(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_battleAction_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def WaitRecvConnectionState(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_connectionState_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def WaitRecvGameWndKeyDown(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_gameWndKeyDown_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def WaitRecvDownloadMap(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_downMap_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   #API
   def WaitRecvServerShutdown(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_serverShutdonw_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   
   #是否目标坐标附近
   def IsNearTarget(self,x,y,dis=1):
      curPos = self.GetMapCoordinate()
      if(abs(curPos.x) - x ) <= dis and (abs(curPos.y)-y) <= dis:
         self.debug_log("目标附近")
         return True
      self.debug_log("不在目标附近")
      return False

   def IsNearTargetEx(selx,srcx, srcy,tgtx, tgty, dis=1):
      if (abs(srcx - tgtx) <= dis and abs(srcy - tgty) <= dis):
         return True
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
         dlg = self.WaitRecvNpcDialog()
         talkCount=talkCount-1
      bTalkNpc = self.TalkNpcClicked(dlg,4)
      count=count-1
      while (count and not self.g_stop and bTalkNpc):
         dlg = self.WaitRecvNpcDialog()
         bTalkNpc = self.TalkNpcClicked(dlg,4)
         count=count-1
      return bTalkNpc

   def GetCoordinateDirectionPos(self,x,y,nDir,nVal): 
      if(nDir==0):
         x = x
         y = y - nVal
      elif(nDir==1):
         x = x + nVal
         y = y - nVal
      elif(nDir==2):
         x = x + nVal
         y = y
      elif(nDir==3):
         x = x + nVal
         y = y + nVal
      elif(nDir==4):
         x = x
         y = y + nVal
      elif(nDir==5):
         x = x - nVal
         y = y + nVal
      elif(nDir==6):
         x = x - nVal
         y = y
      elif(nDir==7):
         x = x - nVal
         y = y - nVal
      return CGPoint(x,y)      

   def GetDirection(self,x,y,tx, ty):
      if (x == tx and y == ty):
         return MOVE_DIRECTION_Origin
      dy = ty - y
      dx = tx - x
      if ((x - tx) == 0 or (y - ty) == 0):
         if ((x - tx) == 0):
            if (ty > y): #魔力反的 在下
               return MOVE_DIRECTION_South
            else:
               return MOVE_DIRECTION_North		
         else:
            if (tx > x):
               return MOVE_DIRECTION_East
            else:
               return MOVE_DIRECTION_West
      else:
         if (dy > 0 and dx > 0):
            return MOVE_DIRECTION_SouthEast
         elif (dx > 0 and dy < 0): #//第二象限
            return MOVE_DIRECTION_NorthEast
         elif (dx < 0 and dy < 0):# //第三象限
            return MOVE_DIRECTION_NorthWest
         elif (dx < 0 and dy > 0):# //第四象限
            return MOVE_DIRECTION_SouthWest


   def GetDirectionPos(self,nDir,nVal=1):
      mapPos=self.GetMapCoordinate()	
      return self.GetCoordinateDirectionPos(mapPos.x, mapPos.y, nDir, nVal)

   def TalkNpcPosSelectYes(self,x,y,count=32):
      if not (self.IsNearTarget(x,y,1)):
         self.MoveToNpcNear(x,y)
      return self.TalkNpcSelectYes(x,y,count)

   def TalkNpcPosSelectYesEx(self,nDir,count=32):
      dirPos=self.GetDirectionPos(nDir, 2)
      return self.TalkNpcSelectYes(dirPos.x, dirPos.y, count)


   #--法兰传送一次
   def FaLanStoreWarpOne(self):
      mapPos=self.GetMapCoordinate()
      mapName=self.GetMapName()		
      if (mapPos.x==72 and mapPos.y==123 ):#		#-- 西2登录点
         self.TurnAbout(2)			# 东	
         self.WaitForMapEx("法兰城",233,78)	
      elif (mapPos.x==233 and mapPos.y==78 ):#	# 东2登录点
         self.TurnAbout(0)			# 北	
         self.WaitForMapEx("市场一楼 - 宠物交易区", 46, 16)		
      elif (mapPos.x==162 and mapPos.y==130 ):#	# 南2登录点
         self.TurnAbout(2)	
         self.WaitForMapEx("法兰城",72,123)	
      elif (mapPos.x==63 and mapPos.y==79 ):#	# 西1登录点
         self.TurnAbout(0)			# 北	
         self.WaitForMapEx("法兰城", 242, 100)
      elif (mapPos.x==242 and mapPos.y==100 ):#	# 东1登录点
         self.TurnAbout(2)			# 北	
         self.WaitForMapEx("市场三楼 - 修理专区", 46, 16)	
      elif (mapPos.x==141 and mapPos.y==148 ):#	# 南1登录点
         self.TurnAbout(0)			# 北	
         self.WaitForMapEx("法兰城", 63, 79)	
      elif (mapName=="市场三楼 - 修理专区" and mapPos.x==46 and mapPos.y==16 ):#	# t3
         self.TurnAbout(0)			# 北	
         self.WaitForMapEx("法兰城", 141, 148)		
      elif (mapName=="市场一楼 - 宠物交易区" and mapPos.x==46 and mapPos.y==16 ):#	# t1
         self.TurnAbout(0)			# 北	
         self.WaitForMapEx("法兰城", 162, 130)	     
      return

   #开始遇敌
   def begin_auto_action(self):
      self.debug_log("开始遇敌")
      self.m_bAutoEncounterEnemy=True
      t=threading.Thread(target=self.AutoEncounterEnemyThread)
      t.start()

   def AutoEncounterEnemyThread(self):
      bMoveNext=False
      startPoint = self.GetMapCoordinate()
      preMapName = self.GetMapName()
      nDir = self.m_nAutoEncounterDir
      targetPos = self.GetDirectionPos(nDir, 1)
      while self.m_bAutoEncounterEnemy:
         if (bMoveNext):
            self.ForceMoveTo(targetPos.x(), targetPos.y(), self.m_bIsShowAutoEncounterEnemy)
         else:
            self.ForceMoveTo(startPoint.x(), startPoint.y(), self.m_bIsShowAutoEncounterEnemy)
      
   def end_auto_action(self):
      self.debug_log("停止遇敌")
      self.m_bAutoEncounterEnemy=False

   def GetBattlePet(self):
      pets=self.GetPetsInfo()
      for pet in pets:
         if pet.battle_flags == TPET_STATE_BATTLE:
            return pet
      return None

   def recallSoul(self):
      tryCount=0
      petinfo = self.GetBattlePet()
      charInfo = self.GetPlayerInfo()
      while tryCount < 3:
         if charInfo.souls > 0:
            self.chat_log("人物掉魂：登出招魂")
            self.outCastle("n")#出城堡北门	
            self.AutoMoveToEx(154, 29,"大圣堂的入口")				
            self.AutoMoveToEx(14, 7,"礼拜堂")		
            self.AutoMoveTo(12, 19)	
            self.TalkNpcPosSelectYesEx(0)
            if tryCount > 3 : 
               return          
            tryCount = tryCount+1
            charInfo = self.GetPlayerInfo()
            if charInfo.souls > 0  :			
               self.chat_log("没钱招魂了，去看看银行有没钱")
               self.checkGold(人物("灵魂")*30000,1000001,200000)


   def MoveToNpcNear(self, x, y, dis=1):
      dis = dis if dis > 0 else 1
      pos = self.GetRandomSpace(x, y, dis)
      if (self.IsTargetExistWall(pos.x, pos.y) != 0):
         self.debug_log("目标为墙")
         return False
      self.AutoMoveTo(pos.x, pos.y)
      if (self.GetMapCoordinate() == pos):
         return True
      return False

   def healPlayer(self,doctorName):
      charInfo = self.GetPlayerInfo()
      if charInfo.health == 0 :
         return	
      self.chat_log("人物受伤：登出治伤")
      tryNum=0
      filterName=["星落护士","谢谢惠顾☆","司徒启绒","毋然溟","喻天磊","段干澎乔"]
      if(doctorName != None and type(doctorName) == str):
         filterName.append(doctorName)
      elif(doctorName != None and type(doctorName) == list):		
         filterName += doctorName
      self.toCastle()      
      self.AutoMoveTo(34, 89)
      time.sleep(2)
      self.Renew(1)		
      while True:
         self.AutoMoveTo(29, 85)
         charInfo = self.GetPlayerInfo()
         if charInfo.health == 0 :
            self.LeaveTeammate()
            return		
         units=self.GetMapUnits()     
         doctor=None		
         for u in units:
            if ((u.flags & 256)!=0 and filterName.find(u.unit_name)!=-1) :
               doctor = u
               break	 			
         if doctor ==None :#找周围医生
            for u in units:
               # if ((u.flags & 256)!=0) :
                  # #日志(u.unit_name.."icon:"..u.icon.."flags"..(u.flags & 256))
               # 
               if ((u.flags & 256)!=0 and (u.title_name.find("医")!=-1 )) :
                  doctor = u
                  break						
         if doctor !=None :
            self.MoveToNpcNear(doctor.x,doctor.y,1)	#最后一个距离
            oldHealth=charInfo.health
            healTryNum=0
            self.AddTeammate(doctor.unit_name)
            if(self.GetTeammatesCount() > 1):
               while(healTryNum < 4):
                  if self.GetPlayerInfo().health == 0 :
                     self.LeaveTeammate()
                     return				
                  time.sleep(8)	#等待8秒 还受伤 重新加队
   #					if( oldHealth == 人物("健康")) : #医生水平太差没治好 或者是医德太差 站着不治疗
   #						break
   #					
                  healTryNum = healTryNum+1               
               if self.GetPlayerInfo().health > 0 :				
                  self.LeaveTeammate()	#重新找医生
                  filterName.remove(doctor.unit_name)						
         if tryNum >= 10 :
            return      
         tryNum = tryNum+1
    
   def healPet(self):
      if self.GetBattlePet().health== 0:
         return
      #宠物受伤 登出治伤
      self.chat_log("宠物受伤：登出治伤")
      self.gotoFaLanCity("e2")
      self.AutoMoveToEx(221,83,"医院")
      self.AutoMoveTo(12, 18)
      tryNum=0
      while True:
         self.TurnAbout(10,18)
         self.WaitRecvNpcDialog()
         self.ClickNPCDialog(-1,6)
         if self.GetBattlePet().health== 0:
            self.LogBack()
            return
         if tryNum>=10:
            return
         tryNum = tryNum+1


   def checkHealth(self,doctorName):     
      petinfo = self.GetBattlePet()
      charInfo = self.GetPlayerInfo()
      if( charInfo.health > 0 or charInfo.souls > 0 or (petinfo and petinfo.health > 0)):
         #登出 去治疗 招魂
         self.toCastle()
         self.recallSoul()	
         self.healPlayer(doctorName)
         self.healPet()
   #前往法兰城 6个点
   #"s2","w2","e2","t1"	t1市场一楼 t3市场三楼
   #"s1","w1","e1","t3"
   def gotoFaLanCity(self,storeName):            
      def liBao():
         if(self.GetMapName() != "里谢里雅堡"):
            time.sleep(2)
            return    
         self.AutoMoveToEx(41,98,"法兰城")	
         self.AutoMoveTo(153, 130)		
         if(storeName=="" or storeName=="s"):
            return          
      def faLan():
         warpList={
            "w2":{"x":72,"y":123,"name":"法兰城"},    #西2登录点
            "w1":{"x":63,"y":79,"name":"法兰城"},		#西1登录点
            "e1":{"x":242,"y":100,"name":"法兰城"},   #东1登录点
            "e2":{"x":233,"y":78,"name":"法兰城"},		#东2登录点
            "s1":{"x":141,"y":148,"name":"法兰城"},	#南1登录点
            "s2":{"x":162,"y":130,"name":"法兰城"},	#南2登录点
            "t3":{"x":46,"y":16,"name":"市场三楼 - 修理专区"},		#市场三楼
            "t1":{"x":46,"y":16,"name":"市场一楼 - 宠物交易区"},	#市场1楼
            "whospital":{"x":82,"y":83,"name":"医院"}		#西医院		            
         }
         warp1={"s2","w2","e2","t1"}
         warp2={"s1","w1","e1","t3"}
         #西二 东二 南二 市场一楼宠物交易区
         tmpWarpList={}         
         isFind = True if storeName in warp1 else False
         if isFind : #找最近传送点
            tmpWarpList= warp1	
         else:
            isFind = True if storeName in warp2 else False
            if isFind : #找最近传送点
               tmpWarpList= warp2		         
         mapPos=self.GetMapCoordinate()	
         if isFind : #找最近传送点
            data = warpList[storeName]
            nearPos={}
            minDistance=99999
            for warpName in tmpWarpList:
               warpData = warpList[warpName]
               tDis = self.GetDistanceEx(mapPos.x,mapPos.y,warpData["x"],warpData["y"])
               if(minDistance > tDis):
                  nearPos = warpData
                  minDistance=tDis               
             
            self.AutoMoveTo(nearPos["x"],nearPos["y"])
            tryNum=0
            while True:
               mapPos=self.GetMapCoordinate()	
               if self.GetMapName() == data["name"] and mapPos.x==data["x"] and mapPos.y==data["y"]:
                  return
               else:
                  self.FaLanStoreWarpOne()               
               if(tryNum > 10):
                  self.debug_log("前往法兰城坐标错误！")
                  return               
               tryNum = tryNum+1	
      while True:
         self.WaitInNormalState()
         mapName = self.GetMapName()
         if (mapName=="艾尔莎岛" ):			
            self.AutoMoveTo(140,105)				
            self.TurnAbout(1)
            self.WaitRecvNpcDialog()
            self.ClickNPCDialog(4,0)	            
         elif (mapName=="里谢里雅堡" ):	
            liBao()
         elif (mapName=="法兰城" ):	
            faLan()
            return
         elif (mapName=="召唤之间" ):	#登出 bank
            self.AutoMoveTo( 3, 7)	
            self.WaitForMap("里谢里雅堡")	 
         elif (mapName=="芙蕾雅" ):
            return
         else:
            self.LogBack() 
         time.sleep(1)

   def outFaLan(self,sDir):
      if sDir == "e":
         self.gotoFaLanCity("e1")
         self.AutoMoveTo(281,88)
      elif sDir=="s":
         self.gotoFaLanCity("s")
         self.AutoMoveTo(154, 241)
      elif sDir=="w":
         self.gotoFaLanCity("w1")
         self.AutoMoveTo(22,88)	

   def outCastle(self,sDir):
      while True:
         self.WaitInNormalState()  
         mapName = self.GetMapName()
         if mapName=="艾尔莎岛":
            self.TurnAbout(1)
            self.WaitRecvNpcDialog()
            self.ClickNPCDialog(4,0)
            self.WaitForMap("里谢里雅堡")
         elif mapName=="召唤之间":
            self.AutoMoveTo(3,7)
            self.WaitForMap("里谢里雅堡")
         elif mapName=="里谢里雅堡":
            if(sDir=="e"):
               self.AutoMoveTo(65,53)
            elif(sDir == "s"):
               self.AutoMoveTo(41,98)
            elif(sDir == "w"):
               self.AutoMoveTo(17,53)
            elif(sDir == "n"):
               self.AutoMoveTo(41,14)
            return
         else:
            self.LogBack()
         time.sleep(1)
   def gotoFalanBankTalkNpc(self):
      if self.GetMapNumber() != 1121:
         self.gotoFaLanCity("e1")
         self.WaitForMap("法兰城")
         self.AutoMoveTo(238,111,"银行")	
      self.AutoMoveTo(11,8)
      self.TurnAbout(2)
      self.WaitRecvNpcDialog()
   #去银行和职员对话
   def gotoBankTalkNpc(self):            
      def star1():
         self.AutoMoveTo(157,94)	
         self.TurnAboutEx(158,93)		
         self.WaitForMap("艾夏岛")	
         self.AutoMoveTo(114,105)	
         self.AutoMoveTo(114,104,"银行")	
         self.AutoMoveTo(49,30)
         self.TurnAbout(2)
         self.WaitRecvNpcDialog()   
      def star2():
         self.AutoMoveTo(41,98,"法兰城")	
         self.AutoMoveTo(162, 130)		         
      def faLan():
         self.gotoFaLanCity("e1")		
         self.WaitForMap("法兰城")	
         self.AutoMoveTo(238,111,"银行")	
         self.AutoMoveTo(11,8)
         self.TurnAbout(2)
         self.WaitRecvNpcDialog()   
      while True:
         self.WaitInNormalState()  
         mapName = self.GetMapName()
         if mapName=="艾尔莎岛":
            star1()
            return
         elif mapName=="法兰城":
            faLan()
            return
         elif mapName=="里谢里雅堡":
            star2()
            return
         elif mapName=="召唤之间":
            self.AutoMoveTo( 3, 7)	
            self.WaitForMap("里谢里雅堡")	 
         elif mapName=="银行":
            if self.GetMapNumber() == 59548:
               self.AutoMoveTo(49,30)
               self.TurnAbout(2)
               self.WaitRecvNpcDialog()   
            elif self.GetMapNumber() == 1121:
               self.AutoMoveTo(11,8)
               self.TurnAbout(2)
               self.WaitRecvNpcDialog()   
            return
         else:
            self.LogBack()
         time.sleep(1)       
      
   def GetTeamPlayers(self):
      #GameTeamPlayer
      teaminfo=self.GetTeamPlayerInfo()
      units=self.GetMapUnits()
      playerinfo=self.GetPlayerInfo()
      pTeamInfoList=[]
      for tmpTeam in teaminfo:
         newTeam=GameTeamPlayer()
         newTeam.name = tmpTeam.name
         newTeam.hp = tmpTeam.hp
         newTeam.maxhp = tmpTeam.maxhp
         newTeam.mp = tmpTeam.mp
         newTeam.maxmp = tmpTeam.maxmp
         newTeam.x = tmpTeam.xpos
         newTeam.y = tmpTeam.ypos
         newTeam.unit_id = tmpTeam.unit_id
         pTeamInfoList.append(newTeam)
      for tmpTeam in pTeamInfoList:
         for unit in units:
            if unit.type == 8 and unit.unit_id == tmpTeam.unit_id:			
               tmpTeam.name = unit.unit_name
               tmpTeam.nick_name = unit.nick_name
               tmpTeam.title_name = unit.title_name
               tmpTeam.x = unit.xpos
               tmpTeam.y = unit.ypos
               tmpTeam.injury = unit.injury
               tmpTeam.level = unit.level
               break		
         if playerinfo.unitid == tmpTeam.unit_id:         
            tmpTeam.name = playerinfo.name
            tmpTeam.level = playerinfo.level
            tmpTeam.injury = 1 if playerinfo.health > 0 else 0
            tmpTeam.is_me = True         
      return pTeamInfoList
   #获取队伍人数
   def GetTeammatesCount(self):
      playerInfos=self.GetTeamPlayerInfo()
      return len(playerInfos)
   
   def DoCharacterAction(self,nType):
      self.DoRequest(nType)

   def FindPlayerUnit(self,szName):
      units=self.GetMapUnits()
      for mapUnit in units:
         if mapUnit.valid and mapUnit.type == 8 and mapUnit.model_id != 0 and (mapUnit.flags & 256) != 0 and mapUnit.unit_name == szName:
            return  mapUnit
      return None
   def MakeTeam(self,teamCount,teammateList,timeout):
      if(teamCount == None and teammateList == None):
         self.log("队伍人数和队员列表为空，建立队伍失败！",1)
         return     
      if(timeout==None):
         timeout=100 	#	--100秒
      else:
         if(timeout < 0):
            timeout = 100
         elif(timeout<1):
            timeout = 1			
      waitNum=timeout
      tryNum=0
      
      while tryNum<=waitNum  do		
         if(队伍("人数") >= teamCount) then	--数量不足 等待
            --日志("队伍人数达标")
            break
         end		
         等待(1000)
         tryNum=tryNum+1
      end
      if(tryNum > waitNum)then	--超时退出
         return
      end
      if(teammateList == nil)then		--不判断队友
         goto goEnd
      else							--判断是否是设置队员 
         common.kickTeam(teammateList)
         if(队伍("人数") < teamCount) then	--重新等待组队 
            goto begin
         end
      end
      ::goEnd::

   def AddTeammate(self,sName:str,timeout=180):
      if (len(sName) == 0): #没有队长名称 直接加队返回
         self.DoCharacterAction(TCharacter_Action_JOINTEAM)
         return True
      if (self.GetTeammatesCount() > 0 and self.IsTeamLeader(sName)):
         return True
      else:
         self.DoCharacterAction(TCharacter_Action_LEAVETEAM)   #离队
      
      orgPos = self.GetMapCoordinate()
      dwStartTime = time.time()
      while (not self.g_stop):
         #3分钟 还没组队成功 返回
         if ((time.time() - dwStartTime) > timeout):
            return False
         teamLeaderUnit = self.FindPlayerUnit(sName)
         if (teamLeaderUnit == None):
            #没有找到队长 返回
            time.sleep(2)
            continue
         curPos = self.GetMapCoordinate()
         if (curPos.x == teamLeaderUnit.xpos and curPos.y == teamLeaderUnit.ypos):
			   #//Sleep(2000); //和队长重叠坐标 返回
            if (self.GetTeammatesCount() > 0 and self.IsTeamLeader(sName)):
               return True
            else:
               self.DoCharacterAction(TCharacter_Action_LEAVETEAM)   #离队
            self.MoveToNpcNear(teamLeaderUnit.xpos, teamLeaderUnit.ypos)
		
         curPos = self.GetMapCoordinate()
         if (not self.IsNearTargetEx(curPos.x, curPos.y, teamLeaderUnit.xpos, teamLeaderUnit.ypos)):
			   #Sleep(2000); //距离队长过远 跳过
            if (self.GetTeammatesCount() > 0 and self.IsTeamLeader(sName)):
               return True
            else:
               self.DoCharacterAction(TCharacter_Action_LEAVETEAM)#离队
            self.MoveToNpcNear(teamLeaderUnit.xpos, teamLeaderUnit.ypos)
         self.TurnAboutEx(teamLeaderUnit.xpos, teamLeaderUnit.ypos)
         #第一次发送后 对话框没回弹回来，发两次
         self.debug_log("组队请求")
         time.sleep(1)  #等1秒
         self.DoCharacterAction(TCharacter_Action_JOINTEAM)        
         dlg=self.WaitRecvNpcDialog(3)
         stripper = "你要和谁组成队伍？"
         bResult = False        
         if (dlg and len(dlg.message)> 0 and dlg.message.find(stripper) != -1):
            self.debug_log(dlg.message)
            self.debug_log("index:%d,len:%d"%(dlg.message.find(stripper),len(stripper)))
            strip = dlg.message[dlg.message.find(stripper)+len(stripper):]
            #self.debug_log(strip)
            sMatch = strip.split("\n")            
            #self.debug_log(sMatch)     
            #self.debug_log("Count:%d"%(len(sMatch)))  
            #sMatch.remove("")
            sMatch=list(filter(lambda s:s!='',sMatch))
            #self.debug_log("Count:%d"%(len(sMatch)))  
            #for tmpMatch in sMatch:
            #   self.debug_log(tmpMatch)     
            #	qDebug() << match;
            for j in range(0,len(sMatch)):
               if (sMatch[j] == sName):        
                  self.ClickNPCDialog(0, j)
                  time.sleep(1.5)
                  break         
         else:
            self.debug_log("dlg == None")
         teamPlayers = self.GetTeamPlayers()
         if (len(teamPlayers) > 0 and teamPlayers[0].name == sName):
            #self.debug_log("队伍数量%d,队长名称：%s"%(len(teamPlayers),teamPlayers[0].name))   
            return True
         else:
            #self.debug_log("离队")  
            self.DoCharacterAction(TCharacter_Action_LEAVETEAM)#离队
         time.sleep(1)
         #//坐标归位
         self.AutoMoveTo(orgPos.x, orgPos.y)	         

   #离开队伍
   def LeaveTeammate(self):      
      if self.GetTeammatesCount() > 0:
         return self.DoCharacterAction(TCharacter_Action_LEAVETEAM)  #离队
      return False

   #取钱 1存 2取 3扔
   #银行("取钱", 金额)
   #将钱从银行取出，当金额为负数时表示取出钱后身上的金币数，当金额大于银行钱数时则全部取出，
   #银行("取钱", 100000) //取出10万金币，如果银行不足则全部取出
   #银行("取钱", -10000) //取出金币后身上有1万金币
   def WithdrawGold(self,nVal):
      bankGold = self.GetBankGold()
      if (bankGold <= 0):
         self.debug_log( "银行没有钱，取钱失败！")
         return False
      pCharacter = self.GetPlayerInfo()
      realGold = nVal #实际取钱数
      if (realGold < 0):      
         if (abs(realGold) >= pCharacter.gold):
            realGold = (abs(realGold) - pCharacter.gold)         
         else: #身上已经有这么多钱 则取钱失败         
            self.debug_log( "银行没有那么多钱了，取钱失败！")
            return False
      if ((realGold + pCharacter.gold) > 1000000):#身上最多100万
         realGold = (1000000 - pCharacter.gold)
      
      if (realGold > bankGold):
         realGold = bankGold
      return self.MoveGold(realGold, 2)


   #去银行取钱      
   def getMoneyFromBank(self,money):
      self.WaitInNormalState()
      if self.GetTeammatesCount() > 1:
         self.LeaveTeammate()      
      self.gotoBankTalkNpc()
      self.WithdrawGold(money) #没有取钱金额判断

   def DepositPetPos(self,nPos):
      bankPets=self.GetBankPetsInfo()
      if len(bankPets) >= 5:
         self.debug_log("银行宠物满了")
         return False
      petPos = nPos
      if (petPos == -1):
         self.debug_log("身上指定位置没有宠物!")
         return False     
      bRes = False
      bankPetIndex=[]
      for bankPet in bankPets:
         bankPetIndex.push_back(bankPet.index)      
      for i in range(100,105):
         if i not in bankPetIndex:         
            return self.MovePet(petPos, i)         
      return False
   #把非作战宠物全存银行
   
   def depositNoBattlePetToBank(self):
      self.WaitInNormalState()
      if(self.GetTeammatesCount()>1):
         self.LeaveTeammate()
      self.gotoBankTalkNpc()
      allPets = self.GetPetsInfo()		
	   #除了作战宠物 其余全存
      for pet in allPets:
         if(pet.battle_flags!=2):	
            self.DepositPetPos(pet.index)
            time.sleep(2)       
      		
      allPets = self.GetPetsInfo()		
      for pet in allPets:
         if(pet.battle_flags!=2):
            self.DepositPetPos(pet.index)		

   def Renew(self,nDir):
      dirPos = self.GetDirectionPos(nDir, 2)
      self.RenewEx(dirPos.x, dirPos.y)

   def RenewEx(self,x, y):
      self.TurnAboutEx(x, y)
      #选择回复人物
      nCount = 10
      bNeedRenew = True
      while (nCount>0 and not self.g_stop and bNeedRenew):      
         dlg = self.WaitRecvNpcDialog()
         bNeedRenew = self.RenewNpcClicked(dlg)
         nCount=nCount-1

   def NeedHPSupply(self,pl):
      return  True if (pl.hp < pl.maxhp) else False

   def NeedMPSupply(self,pl):
      return True if(pl.mp < pl.maxmp) else False

   def NeedPetSupply(self,pets):
      for pet in pets:
         if (pet.hp < pet.maxhp or pet.mp < pet.maxmp):
            return True      
      return False

   def RenewNpcClicked(self,dlg):
      result = False
      if (dlg and dlg.type == 2 and dlg.message.find("要回复吗")!=-1 ):     
         playerinfo = self.GetPlayerInfo()
         if (playerinfo):
            bNeedHP = self.NeedHPSupply(playerinfo)
            bNeedMP = self.NeedMPSupply(playerinfo)
            #如果身上金钱<加魔钱 只加血
            if (bNeedHP and (not bNeedMP and playerinfo.gold < playerinfo.maxmp - playerinfo.mp)):            
               self.ClickNPCDialog(0, 2, result)
               return True            
            elif (bNeedMP and playerinfo.gold >= playerinfo.maxmp - playerinfo.mp):# //加魔钱够 回复魔和血
               self.ClickNPCDialog(0, 0, result)
               return True
            #人物不需要回复 则回复宠物
            petsinfo = self.GetPetsInfo()
            if (not result and petsinfo):
               if (self.NeedPetSupply(petsinfo)):# //回复宠物            
                  self.ClickNPCDialog(0, 4, result)
                  return True
      elif (dlg and dlg.type == 0):      
         if (dlg.options == 12): #//是   
            self.ClickNPCDialog(4, -1, result)# //4 是 8否 32下一步 1确定
            return True        
         if (dlg.options == 1):# //确定
            self.ClickNPCDialog(1, -1, result)
            return True             
      return False
   def WaitSupplyFini(self,timeout):
      for i in range(0,timeout):
         if (self.g_bStop):
            return False
         playerinfo=self.GetPlayerInfo()
         petsinfo=self.GetPetsInfo()
         if (playerinfo):
            bNeedHP = self.NeedHPSupply(playerinfo)
            bNeedMP = self.NeedMPSupply(playerinfo)           
            bNeedPet = self.NeedPetSupply(petsinfo)
            if (bNeedHP and bNeedMP and bNeedPet):         
               return True
         time.sleep(1)
      return True

   def IsTeamLeader(self,sName=None):
      if self.GetTeammatesCount() <= 1:
         self.debug_log("队伍人数等于1，当前是队长")
         return True
      else:
         teamInfos = self.GetTeamPlayers()
         if sName==None:
            if len(teamInfos)>0 and teamInfos[0].is_me:
               return True
         else:
            if len(teamInfos)>0 and teamInfos[0].name == sName:
               self.debug_log("队伍人数等于%d，当前是队长：%s"%(len(teamInfos),teamInfos[0].name))
               return True
      return False

   def toTeleRoomTemplate(self,warpData):
      tryCount=0
      while True:
         mapPos = self.GetMapCoordinate()
         当前地图名 = self.GetMapName()
         if (当前地图名=="艾尔莎岛" ):	
            self.AutoMoveTo(140,105)	
            self.TurnAbout(1)
            self.WaitRecvNpcDialog()	
            self.ClickNPCDialog(4,0)	           
         elif (当前地图名=="里谢里雅堡" ):           	
            self.AutoMoveToEx(41,50,"里谢里雅堡 1楼")
         elif (当前地图名=="里谢里雅堡 1楼" ):
            self.AutoMoveToEx(45,20,"启程之间")	
         elif (当前地图名=="启程之间" ):	
            #self.AutoMoveTo(25, 27) 	
            if (self.IsTeamLeader()):
               self.AutoMoveTo(warpData[0]["x"],warpData[0]["y"])
               self.AutoMoveTo(warpData[1]["x"],warpData[1]["y"])
               self.AutoMoveTo(warpData[0]["x"],warpData[0]["y"])
               self.AutoMoveTo(warpData[1]["x"],warpData[1]["y"])
               self.AutoMoveTo(warpData[0]["x"],warpData[0]["y"])	
            else:
               self.AutoMoveTo(warpData[0]["x"],warpData[0]["y"])	    
            self.TurnAboutEx(warpData[2]["x"],warpData[2]["y"])
            dlg=self.WaitRecvNpcDialog()
            #self.debug_log(dlg.message)
            if dlg and (dlg.message.find("此传送点的资格")!=-1 or dlg.message.find("不能使用这个传送石")!=-1):
               #执行脚本(warpData[4].script)		
               return True
            elif(dlg.message==""):
               tryCount=tryCount+1
               if(tryCount >= 5):#	--尝试5次，还卡对话框退出
                  return False   
               continue
            #self.debug_log("Select Yes")
            self.ClickNPCDialog(8,0)
            self.WaitRecvNpcDialog()
            self.ClickNPCDialog(1,0)
            self.TalkNpcPosSelectYes(warpData[2]["x"],warpData[2]["y"])	
            return True
         else:
            self.toCastle()           
   def toCastle(self,warpPos=None):
      while True:
         self.WaitInNormalState()
         当前地图名 = self.GetMapName()
         if (当前地图名=="艾尔莎岛" ):			
            self.AutoMoveTo(140,105)				
            转向(1)
            等待服务器返回()
            对话选择(4,0)
            等待到指定地图("里谢里雅堡")           
         elif (当前地图名=="里谢里雅堡" ):	
            if(warpPos == None):
               self.AutoMoveTo(27,82)	#--艾岛上来传送点
               return
            if(warpPos == "c"):#	--clock打卡处
               self.AutoMoveTo(58, 83)	
            elif(warpPos == "召唤之间"):#--召唤之间
               self.AutoMoveToEx(47,85,"召唤之间")
            elif(warpPos == "回廊"):#--回廊
               self.AutoMoveToEx(47,85,"召唤之间")		
               self.AutoMoveToEx(27,8,"回廊")	
            elif(warpPos == "灵堂"):#--灵堂
               self.AutoMoveToEx(47,85,"召唤之间")		
               self.AutoMoveToEx(27,8,"回廊")		
               self.AutoMoveToEx(23,19,"灵堂")
            elif(warpPos == "f1"):#--里堡1层
               self.AutoMoveToEx(41,50,"里谢里雅堡 1楼")			
            elif(warpPos == "f2"):#--里堡1层
               self.AutoMoveToEx(41,50,"里谢里雅堡 1楼")	
               self.AutoMoveToEx(74,19,"里谢里雅堡 2楼")
            elif(warpPos == "f3"):#--谒见之间
               self.AutoMoveToEx(41,50,"里谢里雅堡 1楼")	
               self.AutoMoveToEx(74,19,"里谢里雅堡 2楼")	
               self.AutoMoveToEx(49,22,"谒见之间")	
            elif(warpPos == "l"):#--图书室
               self.AutoMoveToEx(41,50,"里谢里雅堡 1楼")	
               self.AutoMoveToEx(74,19,"里谢里雅堡 2楼")	
               self.AutoMoveToEx(0, 74,"图书室")
            return
         elif (当前地图名=="法兰城" ):		
            self.gotoFaLanCity("s1")
            self.AutoMoveToEx(153,100,"里谢里雅堡")           
         elif (当前地图名=="召唤之间" ):#	--登出 bank
            self.AutoMoveToEx( 3, 7)	
            self.WaitForMap("里谢里雅堡")		 
         else:
            self.LogBack()
         time.sleep(2)    
	

   def toTeleRoom(self,villageName=""):
      warpList={
         "亚留特村":[{"x":43,"y":23},{"x":43, "y":22},{"x":44,"y":22},{"script":"./Python脚本/直通车/★开传送-亚留特村.python"}],
         "伊尔村":[{"x":43,"y":33},{"x":43, "y":32},{"x":44,"y":32},{"script":"./Python脚本/直通车/★开传送-伊尔村.python"}],
         "圣拉鲁卡村":[{"x":43,"y":44},{"x":43, "y":43},{"x":44,"y":43},{"script":"./Python脚本/直通车/★开传送-圣拉鲁卡村.python"}],
         "维诺亚村":[{"x":9,"y":22},{"x":9, "y":23},{"x":8,"y":22},{"script":"./Python脚本/直通车/★开传送-维诺亚村.python"}],
         "奇利村":[{"x":9,"y":33},{"x":8, "y":33},{"x":8,"y":32},{"script":"./Python脚本/直通车/★开传送-奇利村.python"}],
         "加纳村":[{"x":9,"y":44},{"x":8, "y":44},{"x":8,"y":43},{"script":"./Python脚本/直通车/★开传送-加纳村.python"}],
         "杰诺瓦镇":[{"x":15,"y":4},{"x":15, "y":5},{"x":16,"y":4},{"script":"./Python脚本/直通车/★开传送-杰诺瓦镇.python"}],
         "阿巴尼斯村":[{"x":37,"y":4},{"x":37, "y":5},{"x":38,"y":4},{"script":"./Python脚本/直通车/★开传送-阿巴尼斯村.python"}],
         "蒂娜村":[{"x":25,"y":4},{"x":25, "y":5},{"x":26,"y":4},{"script":"./Python脚本/直通车/★开传送-蒂娜村.python"}],
         }
      def jiecun():
         self.toTeleRoom("杰诺瓦镇")
         self.WaitForMap("杰诺瓦镇的传送点")
         self.AutoMoveToEx(14, 6,"村长的家")
         self.AutoMoveToEx(1, 9,"杰诺瓦镇")
         self.AutoMoveToEx(24, 40,"莎莲娜")
         self.AutoMoveToEx(196, 443,"莎莲娜海底洞窟 地下1楼")	
         self.AutoMoveToEx(14, 41,"莎莲娜海底洞窟 地下2楼")
         self.AutoMoveTo(32, 21)
         self.TrunAbout(5)
         self.WaitRecvNpcDialog()	
         self.chat_log("咒术",0,0,0)	
         self.WaitRecvNpcDialog()
         self.ClickNPCDialog(1, 0)
         self.WaitForMapEx("莎莲娜海底洞窟 地下2楼",31,22)	
         self.AutoMoveToEx(38, 37,"咒术师的秘密住处")		
      if villageName in warpList:
         data = warpList[villageName]
         self.toTeleRoomTemplate(data)	  
      elif(villageName == "魔法大学"):
         data = warpList["阿巴尼斯村"]
         self.toTeleRoomTemplate(data)
         self.AutoMoveToEx(5, 4, 4313)
         self.AutoMoveToEx(6, 13, 4312)
         self.AutoMoveToEx(6, 13, "阿巴尼斯村")
         self.AutoMoveToEx(37, 71,"莎莲娜")
         self.AutoMoveToEx(118, 100,"魔法大学")
      elif(villageName == "咒术师的秘密住处"):		
         self.toCastle("f1")
         self.AutoMoveToEx(45,20,"启程之间")	
         self.AutoMoveTo(15, 4)	
         self.LeaveTeammate()
         self.TurnAbout(2)
         dlg=self.WaitRecvNpcDialog()
         if dlg and (dlg.message.find("此传送点的资格")!=-1 or dlg.message.find("不能使用这个传送石")!=-1):			
            exec(open("./脚本/直通车/★开传送-杰诺瓦镇.py").read())			
            jiecun()         	
         self.TurnAbout(2)
         self.WaitRecvNpcDialog()
         self.ClickNPCDialog(4,0)
         jiecun()
      else:
         self.chat_log("未知地图名称！",1)
	


#返回单例对象
cg = CGAPI()
人物 = cg.GetCharacterData
日志 = cg.chat_log
取当前地图编号 = cg.GetMapNumber
取当前地图名 = cg.GetMapName
def 等待(nTime):
   time.sleep(nTime*0.001)
回城 = cg.LogBack
转向 = cg.TurnAbout
对话选择 = cg.ClickNPCDialog
#对话选是 = cg.TalkNpcPosSelectYes
def 对话选是(*args):
   if len(args) == 1:
      cg.TalkNpcPosSelectYesEx(args[0],100)
   elif len(args)>=2:
      cg.TalkNpcPosSelectYes(args[0],args[1],100)

等待空闲 = cg.WaitInNormalState
#自动寻路 = cg.AutoMoveTo
def 自动寻路(*args):
   if len(args) == 2:
      cg.AutoMoveTo(args[0],args[1])
   elif len(args)>=3:
      cg.AutoMoveToEx(args[0],args[1])
等待到指定地图 = cg.Nowhile
等待服务器返回 = cg.WaitRecvNpcDialog
等待聊天信息返回 = cg.WaitRecvChatMsg
等待工作返回 = cg.WaitRecvWorkingResult
等待交易对话框 = cg.WaitRecvTradeDialog
等待交易信息返回=cg.WaitRecvTradeStuffs
等待交易状态返回=cg.WaitRecvTradeState
等待菜单返回=cg.WaitRecvPlayerMenu
等待菜单项返回=cg.WaitRecvUnitMenu
等待战斗返回=cg.WaitRecvBattleAction
等待连接状态返回=cg.WaitRecvConnectionState
等待窗口按键返回=cg.WaitRecvGameWndKeyDown
等待下载地图返回=cg.WaitRecvDownloadMap
等待窗口关闭返回=cg.WaitRecvServerShutdown
def 回复(*args):
   if len(args) == 1:
      cg.Renew(args[0])
   elif len(args)>=2:
      cg.RenewEx(args[0],args[1])

出法兰城 = cg.outFaLan
出里谢里亚堡=cg.outCastle
取队伍人数=cg.GetTeammatesCount
加入队伍=cg.AddTeammate
离开队伍=cg.LeaveTeammate