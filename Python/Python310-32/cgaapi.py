#基础包，用于连接游戏窗口，其他python文件引用此包即可
import CGAPython  #c++层封装的python包
import time       #python时间模块
import sys        #python sys(system)系统模块
import os         #python os(operating system)操作系统模块
import logging    #python进阶日志模块
import logging.handlers #python日志模块handlers部分，可以日志保存本地 网络 控制台等等
import glob       #python文件和目录操作模块
import math       #python数学模块
import random     #python随机数模块
import functools  #python高阶函数模块
from collections import namedtuple  #python容器模块，这里只导入了namedtuple 坐标返回值用的它
import asyncio    #python协程 异步 并发模块
import threading  #python线程模块 遇敌函数使用了线程
import queue      #python队列模块 注册回调用了此
import enum       #python枚举模块 
import requests   #python 网络http请求模块
import json       #python json模块，字典和json互转用的它 
from CGData_pb2 import *         #自定义的grpc数据结构包，和MLAssistTool搭配使用，可以向MLAssistTool查询当前其他角色数据
from CGData_pb2_grpc import *    #自定义的grpc API，上报角色数据，查询角色数据 可以在游戏名片挂了时候用来同步队伍线路
import socketio   #python网络通信模块-封装了收发接口类似js的Socket.IO
import eventlet   #python网络通信事件模块
from configparser import ConfigParser  #配置文件解析模块，ini格式读取/写入使用此模块
from AStar import *  #自定义的A*算法库，源码在本目录，游戏寻路算法使用此
import socket     #python网络通信基础模块
from paho.mqtt import client as mqtt_client
#封装元组，便于访问
CGPoint = namedtuple("CGPoint","x,y")
CGRect = namedtuple("CGRect","x,y,width,height")

#日志格式
LOG_FORMAT = "%(asctime)s %(message)s"
#配置日志 放到initLog接口了
#logging.basicConfig(level=logging.INFO, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S')

#单例模式类 python官方推荐
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

#游戏基础信息类
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
#人物角色信息类-继承GameInfo，复用变量
class GameTeamPlayer(GameInfo):
   def __init__(self) -> None:         
      self.nick_name=""
      self.title_name=""
      self.injury=0         
      self.is_me=False         
      self.x=0
      self.y=0
      self.unit_id=0      
#游戏道具信息类-CGAPI基础上，增加了解析后的耐久度变量
class GameItem:
   def __init__(self) -> None:       
      self.name=""   #				//名称
      self.maybeName=""			   #//没鉴定时 数据库查询可能名称
      self.info=""#				//物品介绍
      self.attr=""				#物品属性
      self.image_id = 0			#图片id
      self.count = -1				#数量
      self.pos = -1				#位置
      self.itemid = -1				#id
      self.type = -1				#物品类型
      self.level = 0				#等级
      self.assessed = False		#是否已鉴定
      self.assess_flags=0			#标志 可丢 可交易 可宠邮等
      self.exist = False			#存在
      self.maxCount = -1			#物品堆叠上限
      self.isDrop = False		#是否扔
      self.isPile = False		#是否叠加
      self.isSale = False		#是否卖
      self.isPick = False		#是否捡
      self.nCurDurability = 0		#当前耐久度
      self.nMaxDurability = 0		#最大耐久度
      self.nDurabilityRate = 0 #当前耐久率
      self.isDropInterval = False#是否扔区间
      self.dropMinCode = 0		#扔区间最小值			
      self.dropMaxCode = 0		#扔区间最大值
#游戏宠物信息类-继承GameInfo，复用变量，在CGAPI基础上，扩充了档次
class GamePet(GameInfo):
   def __init__(self) -> None:         
      self.index=""
      self.index = -1 
      self.flags = 0
      self.battle_flags = 0
      self.loyality = 0			 
      self.default_battle = False 
      #GameSkillList skills		 
      self.detail=None#=CGAPython.cga_playerpet_detail_info_t
      self.exist = False			 
      self.state = 0
      self.grade = -1 
      self.lossMinGrade = -1
      self.lossMaxGrade = -1
      self.bCalcGrade = True 
      self.race = 0			
      self.skillslots = 0 

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

#没用枚举，这里直接定义了
#人物动作
TCharacter_Action_PK = 1			      #PK
TCharacter_Action_JOINTEAM = 3		   #加入队伍
TCharacter_Action_EXCAHNGECARD = 4     #交换名片
TCharacter_Action_TRADE = 5		      #交易
TCharacter_Action_KICKTEAM = 11	      #剔除队伍
TCharacter_Action_LEAVETEAM = 12	      #离开队伍
TCharacter_Action_TRADE_CONFIRM = 13   #交易确定
TCharacter_Action_TRADE_REFUSE = 14    #交易取消
TCharacter_Action_TEAM_CHAT = 15	      #队聊
TCharacter_Action_REBIRTH_ON = 16	   #开始摆摊
TCharacter_Action_REBIRTH_OFF = 17	   #停止摆摊
TCharacter_Action_Gesture = 18		   #人物动作

#宠物状态
TPET_STATE_NONE = 0
TPET_STATE_READY = 1  #待命
TPET_STATE_BATTLE = 2 #战斗
TPET_STATE_REST = 3   #休息
TPET_STATE_WALK = 16  #散步

#人物面朝方向
MOVE_DIRECTION_Origin = 0	   #原地
MOVE_DIRECTION_North = 0	   #北
MOVE_DIRECTION_NorthEast = 1  #东北
MOVE_DIRECTION_East = 2	      #东
MOVE_DIRECTION_SouthEast = 3  #东南
MOVE_DIRECTION_South = 4	   #南
MOVE_DIRECTION_SouthWest = 5  #西南
MOVE_DIRECTION_West = 6	      #西
MOVE_DIRECTION_NorthWest = 7  #西北

#游戏API类
@singleton
class CGAPI(CGAPython.CGA):   
   
   #API版本
   g_version="2023.9.10.1.1"

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

   #GRPC连接MLAssistTool使用
   g_channel = None
   g_stub=None

   #游戏注册回调数据队列
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
   g_mqtt_msg_asyncs=[]            #mqtt订阅事件发布通知

   #游戏辅助程序端口http通信用
   g_gui_port=0

   #游戏注入Hook端口
   g_game_port=0

   #辅助路径
   g_fz_Path=""

   #socketio网络通信
   g_socket=None

   #config.ini配置程序使用
   g_config=None

   #电信服务器列表
   g_serverTelecoms=["221.122.119.111","221.122.119.112","221.122.119.113","221.122.119.114","221.122.119.115"]
	#网通服务器列表
   g_serverNetcom=["221.122.119.117","221.122.119.119","221.122.119.120","221.122.119.166","221.122.119.167"]

   #称号预定义
   g_sPrestigeMap={"恶人":-3,	
   "受忌讳的人": -2,
	"受挫折的人": -1,
	"无名的旅人": 0,
	"路旁的落叶": 1,
	"水面上的小草": 2,
	"呢喃的歌声": 3,
	"地上的月影": 4,
	"奔跑的春风": 5,
	"苍之风云": 6,
	"摇曳的金星": 7,
	"欢喜的慈雨": 8,
	"蕴含的太阳": 9,
	"敬畏的寂静": 10,
	"无尽星空": 11,
	"迈步前进者": 1,
	"追求技巧的人": 2,
	"刻于新月之铭": 3,
	"掌上的明珠": 4,
	"敬虔的技巧": 5,
	"踏入神的领域": 6,
	"贤者": 7,
	"神匠": 8,
	"摘星的技巧": 9,
	"万物创造者": 10,
	"持石之贤者": 11}

   #构造函数
   def __init__(self):
      super().__init__()
      self.log=logging.info
      self.init_data()
      #self.debug_init_data(4397)      #如果要自己调试 打开这行代码 屏蔽上一行代码，把游戏端口号填入括号即可调试

   #打印日志
   def debug_log(self,txt):   
      logging.debug(txt)        

   #初始化数据-指定调试端口
   def debug_init_data(self,port):
      #self.debug_log(len(sys.argv))
      #self.debug_log(sys.argv[0])      
      if(self.Connect(int(port))==False):       #argv第一个程序路径 第二个参数是游戏端口
         self.log('无法连接到本地服务端口，可能未附加到游戏或者游戏已经闪退！')
         sys.exit() 
      self.registerCallBackFuns()

   #初始化数据
   def init_data(self):     
      #self.debug_log(len(sys.argv))
      #self.debug_log(sys.argv[0])
      if len(sys.argv) <= 1:
         #self.log("参数错误！",flush=True)
         self.debug_log("参数错误！")
         sys.exit()
      if(self.Connect(int(sys.argv[1]))==False):       #argv第一个程序路径 第二个参数是游戏端口
         self.debug_log('无法连接到本地服务端口，可能未附加到游戏或者游戏已经闪退！')
         sys.exit() 
      # self.debug_log(sys.argv[0])
      # self.debug_log(sys.argv[1])
      # self.debug_log(os.getenv("CGA_DIR_PATH"))
      self.g_gui_port = os.getenv("CGA_GUI_PORT")
      self.g_game_port = os.getenv("CGA_GAME_PORT")
      self.g_fz_Path = os.getenv("CGA_DIR_PATH")
      # self.debug_log("CGA_GUI_PORT:" + self.g_gui_port )
      # self.debug_log("CGA_GAME_PORT:" + self.g_game_port )
      # self.debug_log("CGA_DIR_PATH:" + self.g_fz_Path )
      pythonScriptPath = self.g_fz_Path + "/Python脚本/"
      pythonScriptFiles = glob.glob(pythonScriptPath+"/官方脚本/*")
      sys.path.append(pythonScriptPath+'./common/') 
      #读取配置文件
      self.g_config = ConfigParser()  # 需要实例化一个ConfigParser对象
      self.g_config.read(self.g_fz_Path+'/config.ini',"utf-8")   
      for tFile in pythonScriptFiles:
         #self.debug_log(tFile)
         sys.path.append(tFile)
      petDatas = self.g_config.items("PETS")
      #print(petDatas,flush=True)
      initPetCalcDatas=[]
      for petInfo in petDatas:
         initPetCalcDatas.append(petInfo[1])
      #print(initPetCalcDatas,flush=True)
      self.InitCaclPetData(initPetCalcDatas)      
      self.registerCallBackFuns()
      self.init_mqtt()

   def init_log(self):
      #配置日志
      sLogState = self.g_config["Log"]["open"]
      if sLogState.find(";") != -1:
         sLogState = sLogState[0:sLogState.find(";")]
         sLogState=sLogState.strip()
      #print(f"日志开关：{sLogState}",flush=True)
      if sLogState == "true" or sLogState == "1":
         logPath=self.g_fz_Path+f"//log//{self.GetPlayerInfo().name}.log"
         #print(logPath,flush=True)  

         #logging.basicConfig(filemode="a",filename=".",level=logging.DEBUG, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S',force=True)
         #logging.basicConfig(filemode="a",filename=logPath,level=logging.INFO, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S')
         #写文件 最大10M 最多5个 循环写
         #logging.getLogger("").removeHandler
         tmpHandles = []
         self.g_fileHandler = logging.handlers.RotatingFileHandler(filename=logPath, maxBytes=10*1024*1024, backupCount=5)
         handlerFormatter = logging.Formatter('%(asctime)s %(message)s')
         self.g_fileHandler.setFormatter(handlerFormatter)        
         self.g_fileHandler.setLevel(logging.DEBUG)
         logging.getLogger("").addHandler(self.g_fileHandler)    
         tmpHandles.append(self.g_fileHandler)

         #控制台 辅助会读取此信息 这里日期只到秒就够 上面的写文件到毫秒
         self.g_consoleHandler = logging.StreamHandler()
         self.g_consoleHandler.setLevel(logging.INFO)
         consoleFormatter = logging.Formatter('%(asctime)s %(message)s',datefmt='%Y-%m-%d %H:%M:%S')
         self.g_consoleHandler.setFormatter(consoleFormatter)
         logging.getLogger("").addHandler(self.g_consoleHandler)   
         tmpHandles.append(self.g_consoleHandler) 
         logging.basicConfig(handlers=tmpHandles,level=logging.DEBUG, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S',force=True)
         self.g_fileHandler.setLevel(logging.DEBUG)
         self.g_consoleHandler.setLevel(logging.INFO)

      else:
         #logging.basicConfig(level=logging.INFO, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S',force=True)
         logging.basicConfig(level=logging.INFO, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S')
      self.debug_log(f"****************Api version:{self.g_version}**************")

   def init_grpc(self):
      sToolIp = self.g_config["server"]["ip"]
      nPort = self.g_config["server"]["port"]
      if sToolIp.find(";") != -1:
         sToolIp = sToolIp[0:sToolIp.find(";")]
         sToolIp=sToolIp.strip()
      if len(sToolIp) < 1:
         sToolIp = "127.0.0.1"
      if nPort.find(";") != -1:
         nPort = nPort[0:nPort.find(";")]
         nPort=nPort.strip()
      if len(nPort) < 1:
         nPort = "50051"
      if self.g_channel == None:#配置文件读取ip，暂时设本地
         self.g_channel =grpc.insecure_channel(sToolIp + ":" + nPort)
         self.g_stub = CGRpcServiceStub(self.g_channel)

   def get_client_id(self):
      if self.g_client_id == None:
         self.g_client_id = random.randint(1000, 1000000)
      else:
         return self.g_client_id
      
   def init_mqtt(self):
      sMqttIp = self.g_config["server"]["mqttip"]
      nMqttPort = self.g_config["server"]["mqttport"]
      if sMqttIp.find(";") != -1:
         sMqttIp = sMqttIp[0:sMqttIp.find(";")]
         sMqttIp=sMqttIp.strip()
      if len(sMqttIp) < 1:
         sMqttIp = "127.0.0.1"
      if nMqttPort.find(";") != -1:
         nMqttPort = nMqttPort[0:nMqttPort.find(";")]
         nMqttPort=nMqttPort.strip()
      if len(nMqttPort) < 1:
         nMqttPort = "1883"
      if self.g_mqtt_client == None:#配置文件读取ip，暂时设本地        
         self.g_mqtt_client = mqtt_client.Client(self.get_client_id())
         self.g_mqtt_client.on_connect=self.on_mqtt_connect
         self.g_mqtt_client.on_message=self.on_mqtt_message
         self.g_mqtt_client.connect(sMqttIp,int(nMqttPort))
         self.g_mqtt_client.loop_start()
   #mqtt连接状态回调
   def on_mqtt_connect(self,client,userData,flags,rc):
      if rc==0:
         self.debug_log("Connected To Mqtt successed")
      else:
         self.debug_log(f"Connected Mqtt Failed:{rc}")
   #mqtt接收消息回调
   def on_mqtt_message(self,client, userdata, msg):
      self.debug_log(f"Received `{msg.payload.decode()}` from `{msg.topic}` topic")
      recvData = json.loads(msg.payload.decode())      
      self.MqttPublishNotify(msg)

   #订阅主题
   def AddNewMqttSubscribeTopic(self,topic):
      if self.g_mqtt_client == None:
         self.init_mqtt()
      self.g_mqtt_client.subscribe(topic)

   #发布主题
   def PublishNewTopicData(self,topic,msg):
      if self.g_mqtt_client == None:
         self.init_mqtt()
      msgData=None
      if type(msg) == str:
         msgData = msg
      elif type(msg) == dict:
         msgData = json.loads(msg)
      result = self.g_mqtt_client.publish(topic, msgData)
      status = result[0]
      if status == 0:
         self.debug_log(f"Send `{msg}` to topic `{topic}`")
      else:
         self.debug_log(f"Failed to send message to topic {topic}")

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
      #self.log(log,flush=True) 
      self.log(log)      
      self.chat(log,v1,v2,v3)
   #获取打卡时长
   def GetPunchClockStr(self,a, b):
      a = a / 1000
      h = str(math.floor((a / 3600) < 10) and '0') + str(math.floor(a / 3600) or math.floor(a / 3600))
      m = str(math.floor((a / 60 % 60)) < 10 and '0') + str(math.floor((a / 60 % 60)) or math.floor((a / 60 % 60)))
      s = str(math.floor((a % 60)) < 10 and '0') + str(math.floor((a % 60)) or math.floor((a % 60)))
      sText = h + ":" + m + ":" + s
      if (b!=0):
         sText = sText + " (已打卡)"
      else: 
         sText = sText + " (未打卡)"
      return sText
   #保存两位数
   def KeepDecimalTest(self,num, n):    
      if not (type(num) == int or type(num) == float):
         return num          
      return round(num,n)

   def GetRatio(self,a, b):
      if (b == 0):
         return 0
      else:
         return self.KeepDecimalTest((a / b),2)
   #宠物信息打印
   def PetInfoPrint(self):
      pets=self.GetPetsInfo()
      for pet in pets:
         self.log("宠物位置%d : Lv%d  %s (%s)"%(pet.index,pet.level,pet.realname,pet.name))
       
   #装备信息
   def GetPlayereEquipData(self):
      itemsInfo = self.GetItemsInfo()
      equipInfo=[]
      for itemInfo in itemsInfo:
         if itemInfo.pos >= 0 and itemInfo.pos < 8:
            equipInfo.append(itemInfo) 
      return equipInfo

   #信息打印
   def BaseInfoPrint(self):
      playerinfo =self.GetPlayerInfo()
      self.log("人物信息： Lv" + str(playerinfo.level)+"【 "+playerinfo.name+"】【 "+ playerinfo.job + " 】")
      self.log("生命： %d/%d (%.2f)"%(playerinfo.hp,playerinfo.maxhp,self.GetRatio(playerinfo.hp, playerinfo.maxhp)))
      self.log("魔法： %d/%d (%.2f)"%(playerinfo.mp,playerinfo.maxmp,self.GetRatio(playerinfo.mp, playerinfo.maxmp)))
      self.log("健康： " + str(playerinfo.health) + "  掉魂： " + str(playerinfo.souls))
      self.log("金钱： " + str(playerinfo.gold) + "  卡时： " + self.GetPunchClockStr(playerinfo.punchclock, playerinfo.usingpunchclock))
      #--装备信息
      self.log("装备信息： ")
      items = self.GetPlayereEquipData()
      for item in items:	
         nCur,nMax = self.ParseItemDurabilityEx(item.attr)	
         self.log("穿戴位置"+str(item.pos) + "： Lv" + str(item.level) + " " + item.name + "  (" + str(nCur) + "/" + str(nMax) + ")")
       
      
      # #--出战宠物
      petinfo = self.GetPetInfo(playerinfo.petid)
      self.log("出战宠物： Lv" + str(petinfo.level) + " " + petinfo.realname + "  (" + petinfo.name + ")")
      self.log("生命： %d/%d (%.2f)"%(petinfo.hp,petinfo.maxhp,self.GetRatio(petinfo.hp, petinfo.maxhp)))
      self.log("魔法： %d/%d (%.2f)"%(petinfo.mp,petinfo.maxmp,self.GetRatio(petinfo.mp, petinfo.maxmp)))  
      self.log("健康： " + str(petinfo.health))
      #--宠物信息
      self.log("宠物信息： ")
      self.PetInfoPrint()
   #统计练级信息
   def Statistics(self,beginTime,oldXp,oldPetXp,oldGold):   
      playerinfo = self.GetPlayerInfo()
      nowTime = time.time() 
      sTime = math.floor((nowTime - beginTime)/60) #--已持续练级时间
      if(sTime == 0):
         sTime=1
      
      nowLevel = playerinfo.level
      nowXp = playerinfo.xp
      nowMaxXp = playerinfo.maxxp
      if(nowLevel==0 or nowXp == 0 or nowMaxXp==0):
         self.log("获取人物信息错误，统计失败")
         return      
      getXp = math.floor((nowXp - oldXp)/10000)
      avgXp = math.floor(60 * getXp/sTime)
      nextXp = 0
      if(nowLevel != 160):	
         nextXp=math.floor((nowMaxXp-nowXp)/10000)      
      levelUpTime=0
      if(avgXp > 0):
         levelUpTime = math.floor(60 * nextXp/avgXp)      
      goldContent =""
      if(oldGold!=None):
         nowGold = playerinfo.gold
         getGold = nowGold - oldGold
         avgGold = math.floor(60 * getGold/sTime)
         goldContent = "，总消耗【"+str(getGold)+"】金币，平均每小时消耗【"+str(avgGold)+"】金币"
      
      content ="已持续练级【"+str(sTime)+"】分钟，人物共获得【"+str(getXp)+"万】经验，平均每小时【"+str(avgXp)+"万】经验，当前等级【"+str(nowLevel)+"】，距离下一级还差【"+str(nextXp)+"万】经验，大约需要【"+str(levelUpTime)+"】分钟 "+str(goldContent)
      if(oldPetXp==None):
         if(nowLevel==160):
            return ""#--满级不打印信息
         else:
            self.chat_log(content)
            return content
      curPet = self.GetBattlePet()
      nowPetLevel = curPet.level
      nowPetXp = curPet.xp
      nowMaxPetXp = curPet.maxxp
      getPetXp = math.floor((nowPetXp - oldPetXp)/10000)
      avgPetXp = math.floor(60 * getPetXp/sTime)
      nextPetXp = 0
      if(nowPetLevel!=160):	
         nextPetXp=math.floor((nowMaxPetXp-nowPetXp)/10000)
      	
      petLevelUpTime =0
      if(avgPetXp > 0):
         petLevelUpTime = math.floor(60 * nextPetXp/avgPetXp)
      petcontent ="，宠物共获得【%d万】经验，平均每小时【%d万】经验，当前等级【%d】，距离下一级还差【%d万】经验，大约需要【%d】分钟"%(getPetXp,avgPetXp,nowPetLevel,nextPetXp,petLevelUpTime)
      allContent=content+petcontent
      self.log(allContent)  #--字符串太长 崩溃
      return allContent

   #统计金币
   def StatisticsTime(self,beginTime,oldGold):
      nowTime = time.time() 
      lastTime = math.floor((nowTime - beginTime)/60)#--已持续练级时间
      if(lastTime == 0):
         lastTime=1
      goldContent =""
      if(oldGold!=None):
         nowGold = self.GetCharacterData("金币")
         getGold = nowGold - oldGold
         avgGold = math.floor(60 * getGold/lastTime)
         goldContent = "总消耗【"+ str(getGold) + "】金币，平均每小时消耗【"+str(avgGold)+"】金币"
      
      content ="脚本已持续【"+str(lastTime)+"】分钟，"+str(goldContent	)
      self.chat_log(content)  #--字符串太长 崩溃
      return content

   #获取好友服务器线路
   def getFriendServerLine(self,friendName):
      if(friendName == None):
         return 0
      friendCards = self.GetCardsInfo()
      for friendCard in friendCards:
         if friendCard.name == friendName:
            return friendCard.server
      return 0
   #通过名片获取队长线路跟随换线 默认使用名片 如果名片炸了，选tool工具同步即可
   def ChangeLineFollowLeader(self,leaderName,useTool=None):
      if(leaderName==None):
         return
      if(self.GetPlayerInfo().name == leaderName):
         return
      leaderServerLine=0
      if useTool == None:
         leaderServerLine = self.getFriendServerLine(leaderName)
      else:
         leaderInfo = self.g_stub.SelectCharacterData(CGData__pb2.SelectCharacterDataRequest(char_name=leaderName,big_line=self.GetGameServerType()))
         if leaderInfo!=None and leaderInfo.online!=0:
            leaderServerLine = leaderInfo.character_data.server_line #当前线路
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
      sJob = self.GetCharacterData("职称")
      professions=None
      #self.debug_log(sJob)
      #self.debug_log(os.path.abspath('.'))
      #self.debug_log(os.path.abspath(__file__))
      #self.debug_log(self.g_fz_Path)
      with open(self.g_fz_Path+'//profession.json',"r", encoding='utf-8' ) as f:
         professions = json.load(f)
      #self.debug_log(professions)
      if professions == None:
         return sJob
      for tmpProfession in professions:
         titles = tmpProfession["titles"]
         #self.debug_log(titles)
         if sJob in titles:
            return tmpProfession["name"]
      return ""
   #获取职称等级
   def GetCharacterRank(self,sJob=None):
      if sJob == None:
         sJob = self.GetCharacterData("职称")
      professions=None
      #self.debug_log(sJob)
      #self.debug_log(os.path.abspath('.'))
      #self.debug_log(os.path.abspath(__file__))
      #self.debug_log(self.g_fz_Path)
      with open(self.g_fz_Path+'//profession.json',"r", encoding='utf-8' ) as f:
         professions = json.load(f)
      #self.debug_log(professions)
      if professions == None:
         return sJob
      for tmpProfession in professions:
         titles = tmpProfession["titles"]
         #self.debug_log(titles)
         if sJob in titles:
            return titles.index(sJob)
      return ""
   #获取声望
   def GetCharacterPrestige(self,titles):
      sTitleKeys=self.g_sPrestigeMap.keys()
      for sTitle in titles:
         if sTitle in sTitleKeys:
            return sTitle
      return ""
   #获取声望等级
   def GetCharacterPrestigeLv(self,titles):
      sTitleKeys=self.g_sPrestigeMap.keys()
      for sTitle in titles:
         if sTitle in sTitleKeys:
            return self.g_sPrestigeMap[sTitle]
      return 0

   #获取人物信息
   def GetCharacterData(self,sType):
      playerinfo = self.GetPlayerInfo()
      match(sType):        
         case("名称"):return playerinfo.name
         case("name"):return playerinfo.name
         case("血"):return playerinfo.hp
         case("hp"):return playerinfo.hp
         case("魔"):return playerinfo.mp
         case("mp"):return playerinfo.hp
         case("等级"):return playerinfo.level
         case("level"):return playerinfo.level
         case("最大血"):return playerinfo.maxhp
         case("maxhp"):return playerinfo.maxhp
         case("最大魔"):return playerinfo.maxmp
         case("maxmp"):return playerinfo.maxhp
         case("健康"):return playerinfo.health
         case("health"):return playerinfo.health
         case("经验"):return playerinfo.exp
         case("下一级经验"):return playerinfo.maxexp
         case("宠物数量"):return len(self.GetPetsInfo())
         case("几线"):return super().GetMapIndex()[1]
         case("大线"):return super().GetMapIndex()[0]
         case("灵魂"):return playerinfo.souls
         case("gid"):return playerinfo.gid
         case("坐标"):
            mapPos=self.GetMapCoordinate()
            return mapPos.x,mapPos.y
         case("4转属组"):return playerinfo.x
         case("性别"):return playerinfo.x
         case("外观"):return playerinfo.image_id
         case("角色"):return playerinfo.player_index
         case("金币"):return playerinfo.gold
         case("银行金币"):return self.GetBankGold()
         case("卡时"):return playerinfo.punchclock
         case("打卡状态"):return playerinfo.usingpunchclock
         case("职业"):return self.GetCharacterProfession()
         case("职称"):return playerinfo.job
         case("职称等级"):return self.GetCharacterRank()
         case("声望"):return self.GetCharacterPrestige(playerinfo.titles)
         case("称号"):return self.GetCharacterPrestige(playerinfo.titles)         
         case("声望等级"):return self.GetCharacterPrestigeLv(playerinfo.titles)
         case("称号等级"):return self.GetCharacterPrestigeLv(playerinfo.titles)
   
   #获取宠物信息
   def GetBattlePetData(self,sType,*args):
      pet=self.GetBattlePet()      
      self.debug_log(f"获取宠物信息:{sType}宠物{pet}")
      match(sType):
         case("名称"):return pet.name if pet != None else ""
         case("name"):return pet.name if pet != None else ""
         case("血"):return pet.hp if pet != None else -1
         case("hp"):return pet.hp if pet != None else -1
         case("魔"):return pet.mp if pet != None else -1
         case("mp"):return pet.hp if pet != None else -1
         case("等级"):return pet.level if pet != None else -1
         case("level"):return pet.level if pet != None else -1
         case("最大血"):return pet.maxhp if pet != None else -1
         case("maxhp"):return pet.maxhp if pet != None else -1
         case("最大魔"):return pet.maxmp if pet != None else -1
         case("maxmp"):return pet.maxhp if pet != None else -1
         case('健康'):return pet.health if pet != None else -1
         case("health"):return pet.health if pet != None else -1
         case("经验"):return pet.exp if pet != None else -1
         case("最大经验"):return pet.maxexp if pet != None else -1
         case("档次"):return -1#pet.maxexp  if pet != None else -1
         case("忠诚"):return pet.loyality  if pet != None else -1
         case("状态"):return pet.battle_flags if pet != None else -1
         case("检查图鉴"):
            if len(args) == 0:
               return False
            elif len(args)>=1:
               tgtPetName = args[0]
               books = self.GetPicBooksInfo()
               for petBook in books:
                  if petBook.name == tgtPetName:
                     return True
            return False
         case("改状态"):
            if len(args) == 0:
               return -1
            tgtPetVal=0
            if type(args[0]) == str:
               if args[0] == "待命":
                  tgtPetVal = 1
               elif (args[0] == "战斗"):
                  tgtPetVal = 2
               elif (args[0]  == "休息"):
                  tgtPetVal = 3
               elif (args[0]  == "散步"):
                  tgtPetVal = 16
            else:
               tgtPetVal=args[0]
            if (tgtPetVal != 1 and tgtPetVal != 2 and tgtPetVal != 3 and tgtPetVal != 16):
               return pet.battle_flags if pet != None else -1
            else:
               petIndex = -1
               petList =self.GetPetsInfo()
               if (len(args) <= 1):
                  petIndex =  pet.index if pet != None else -1
               else:
                  petIndex = args[1]                 
                  pPet=None
                  if (petIndex == 5):# //等级高
                     nLv = 0
                     for battlePet in petList:                     
                        if (battlePet.level > nLv):
                           nLv = battlePet.level
                           pPet = battlePet                      
                     if (nLv != 0 and pPet != None):
                        petIndex = pPet.index                  
                  elif (petIndex == 6):# //等级低                  
                     nLv = 200
                     for battlePet in petList:  
                        if (battlePet.level < nLv):                        
                           nLv = battlePet.level
                           pPet = battlePet
                     if (nLv != 200 and pPet!=None):                     
                        petIndex = pPet.index              
               if (petIndex < 0):
                  return -1
               if (tgtPetVal == TPET_STATE_BATTLE) :#//必须把当前战斗宠物设置为其余状态
                  for battlePet in petList:                 
                     if (battlePet.battle_flags == TPET_STATE_BATTLE):# //默认出战宠物                   
                        self.ChangePetState(battlePet.index, TPET_STATE_READY)
                        time.sleep(1)
                        break     
               self.ChangePetState(petIndex, tgtPetVal)
               return 0

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
   #转向坐标
   def TurnAboutEx(self,x,y):
      self.TurnTo(x,y)
   
   #转向目标方向
   def TurnAboutPointDir(self,x,y):
      nDir = self.GetOrientation(x, y)
      self.TurnAbout(nDir)

   #获取目标在当前坐标的方向
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
   #等待到达指定地图
   def WaitForMap(self,name):
      self.Nowhile(name)
   #等到到达指定地图-指定坐标
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
         #print(name,"is str",flush=True)
         if name.isdigit():
            #print(name,"is isdigit",flush=True)
            for i in range(timeout):
               if self.g_stop:
                  return False  
               curMapIndex = self.GetMapNumber()
               if self.IsInNormalState() and curMapIndex == int(name):
                  return True		
               time.sleep(1)
         else:
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
      if self.GetTeammatesCount() > 0 and not self.IsTeamLeader():
         self.debug_log("AutoMoveTo 队伍人数>0 或者 自己不是队长")
         return 0
      return self.AutoMoveInternal(x, y, timeout)

   #自动寻路到指定地图
   def AutoMoveToEx(self,x,y,mapName=None,timeout=100):
      if mapName==None:
         return self.AutoMoveTo(x,y,timeout)
      else:     
         tryNum=0
         if type(mapName)==str:
            while tryNum < 3:
               self.AutoMoveTo(x,y,timeout)
               curMapName = self.GetMapName()
               curMapNum = self.GetMapNumber()
               if (len(mapName) > 0):
                  if (self.IsInNormalState() and (curMapName == mapName or (mapName.isdigit() and curMapNum == int(mapName)))):              
                     #到达目标地 返回1  否则尝试3次后返回0
                     self.debug_log("目的地到达，返回1")
                     return 1                  
               tryNum=tryNum+1
            self.debug_log("尝试3次后，到达目标地图失败%s %d %d "%(mapName,x,y))
         elif type(mapName)==int:
            while tryNum < 3:
               self.AutoMoveTo(x,y,timeout)
               curMapName = self.GetMapName()
               curMapNum = self.GetMapNumber()
               if (mapName > 0):
                  if (self.IsInNormalState() and  curMapNum == int(mapName)):              
                     #到达目标地 返回1  否则尝试3次后返回0
                     return 1
                  
               tryNum=tryNum+1
            self.debug_log("尝试3次后，到达目标地图失败%s %d %d "%(mapName,x,y))
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
                     return self.AutoMoveInternal(tgtPos.x, tgtPos.y,100, False)
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
                        self.debug_log(f"战斗/切图等待，再次寻路!WalkTo {tarX},{tarY}")
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
                           if time.time() - fixWarpTime > 5:
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
                                          self.AutoMoveInternal(tmpPos.x,tmpPos.y,100, False)
                                          bTryRet = self.AutoMoveInternal(tarX, tarY,100,  False)
                                       else:
                                          bTryRet = self.AutoMoveInternal(tarX, tarY,100,  False)
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
                     if not self.IsReachableTarget(walkprePos.x, walkprePos.y):   #用移动前点判断 不能到 说明换图成功，特别是ud这个图
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
                  #self.debug_log(f"坐标未变，判断时间{dwLastTime},{dwCurTime}")
                  if dwLastTime == 0:                     
                     dwLastTime= dwCurTime
                     #self.debug_log(f"坐标未变，第一次进入，记录时间{dwLastTime},{dwCurTime}")
                  else:
                     if dwCurTime -dwLastTime   > 10:
                           dwTimeoutTryCount=dwTimeoutTryCount+1
                           if dwTimeoutTryCount>=3:
                              self.debug_log(f"短坐标自动寻路次数超3次，返回！{tarX},{tarY}")
                              return False
                           dwLastTime= dwCurTime
                           self.debug_log(f"卡墙，短坐标自动寻路！{tarX},{tarY}")
                           self.WaitInNormalState()
                           curPos = self.GetMapCoordinate()
                           findPath = self.CalculatePath(curPos.x, curPos.y, tarX, tarY)
                           if len(findPath) == 1 or  not isLoop:
                              self.debug_log(f"卡墙：WalkTo{tarX},{tarY}")
                              self.WalkTo(tarX,tarY)
                           elif len(findPath) > 1 and isLoop:
                              self.debug_log(f"卡墙：AutoMoveInternal{tarX},{tarY}")
                              if self.AutoMoveInternal(tarX,tarY,100, False) == False:
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
      self.debug_log("计算路径Fini")	   
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
      
   #游戏退出通知
   def ServerShutdownNotify(self,val):
      for q in self.g_serverShutdonw_asyncs:
         q.put_chat_msg(val)
      self.g_serverShutdonw_asyncs.clear()
   #游戏按键通知
   def GameWndKeyDownNotify(self,val):
      for q in self.g_gameWndKeyDown_asyncs:
         q.put_chat_msg(val)
      self.g_gameWndKeyDown_asyncs.clear()
   #战斗通知
   def BattleActionNotify(self,val):
      for q in self.g_battleAction_asyncs:
         q.put_chat_msg(val)
      self.g_battleAction_asyncs.clear()
   #人物菜单通知
   def PlayerMenuNotify(self,val):
      for q in self.g_playerMenu_asyncs:
         q.put_chat_msg(val)
      self.g_playerMenu_asyncs.clear()
   #工作结果通知
   def WorkingResultNotify(self,val):
      for q in self.g_workingResult_asyncs:
         q.put_chat_msg(val)
      self.g_workingResult_asyncs.clear()
   #交易物品通知
   def TradeStuffsNotify(self,val):
      for q in self.g_tradeStuffs_asyncs:
         q.put_chat_msg(val)
      self.g_tradeStuffs_asyncs.clear()
   #交易对话框通知
   def TradeDialogNotify(self,val):
      for q in self.g_tradeDialog_asyncs:
         q.put_chat_msg(val)
      self.g_tradeDialog_asyncs.clear()
   #交易状态通知
   def TradeStateNotify(self,val):
      for q in self.g_tradeState_asyncs:
         q.put_chat_msg(val)
      self.g_tradeState_asyncs.clear()
   #下载地图通知
   def DownloadMapNotify(self,val):
      for q in self.g_downMap_asyncs:
         q.put_chat_msg(val)
      self.g_downMap_asyncs.clear()
   #连接状态通知
   def ConnectionStateNotify(self,val):
      for q in self.g_connectionState_asyncs:
         q.put_chat_msg(val)
      self.g_connectionState_asyncs.clear()
   #聊天信息通知
   def UnitMenuNotify(self,val):
      for q in self.g_unitMenu_asyncs:
         q.put_chat_msg(val)
      self.g_unitMenu_asyncs.clear()
   #mqtt发布事件通知
   def MqttPublishNotify(self,msg):
      for q in self.g_mqtt_msg_asyncs:
         q.put_chat_msg(msg)
      self.g_mqtt_msg_asyncs.clear()

   #API
   def WaitRecvMqttMsg(self,tSecond=10):        
      testWait = AsyncWaitNotify(self.g_mqtt_msg_asyncs)       
      return testWait.wait_msg_timeout(tSecond)
   
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
      #self.debug_log(f"当前坐标:{curPos.x},{curPos.y} 目标坐标:{x},{y}")
      if abs(curPos.x - x ) <= dis and abs(curPos.y-y) <= dis:
         #self.debug_log("目标附近")
         return True
      #self.debug_log("不在目标附近")
      return False
   #是否目标坐标附近
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
       
   #对话选择指定值
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
   #对话选是
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
   #获取指定方向指定距离坐标
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
   #获取指定目标在坐标方向
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
   #参数1：遇敌方向0-7  
   #参数2：遇敌间隔毫秒，不要太小，太小即使遇敌快，也会卡战斗
   #参数3：是否可见
   def begin_auto_action(self,nDir=0,encounterInterval=50,bVisible=False):
      self.debug_log("开始遇敌")
      self.m_bIsShowAutoEncounterEnemy=bVisible#是否可见
      self.m_bAutoEncounterEnemy=True
      self.m_nAutoEncounterDir=nDir
      self.m_nEncounterInterval=encounterInterval/1000
      t=threading.Thread(target=self.AutoEncounterEnemyThread)
      t.start()

   #自动遇敌线程
   def AutoEncounterEnemyThread(self):
      self.debug_log("开始自动遇敌线程,间隔："+str(self.m_nEncounterInterval))
      bMoveNext=False
      startPoint = self.GetMapCoordinate()
      preMapName = self.GetMapName()
      nDir = self.m_nAutoEncounterDir
      targetPos = self.GetDirectionPos(nDir, 1)
      recordTime = time.perf_counter()
      while self.m_bAutoEncounterEnemy:
         if (time.perf_counter() - recordTime) > 5:
            recordTime=time.perf_counter()
            if preMapName != self.GetMapName():
               self.debug_log("地图变更，遇敌结束")
               break
         if (bMoveNext):
            self.ForceMoveTo(targetPos.x, targetPos.y, self.m_bIsShowAutoEncounterEnemy)
         else:
            self.ForceMoveTo(startPoint.x, startPoint.y, self.m_bIsShowAutoEncounterEnemy)
         if not self.IsInNormalState():
            self.WaitInNormalState()
         bMoveNext=not bMoveNext
         time.sleep(self.m_nEncounterInterval)   #间隔
      curPoint = self.GetMapCoordinate()
      if (curPoint.x == startPoint.x and curPoint.y == startPoint.y):
         self.debug_log("结束自动遇敌 起点一致 返回")
         return
      else: #回到原点
         if (self.IsInNormalState()):
            if (self.m_bIsShowAutoEncounterEnemy):
               self.WalkTo(startPoint.x, startPoint.y())
            else:
               self.ForceMoveTo(startPoint.x, startPoint.y, False)	
      self.debug_log("结束自动遇敌线程")
      
   def end_auto_action(self):
      self.debug_log("停止遇敌")
      self.m_bAutoEncounterEnemy=False

   def GetPetCalcBpData(self,pet):
      petData=[]
      if pet!=None:
         petData.append(str(pet.realname))
         petData.append(str(pet.maxhp))
         petData.append(str(pet.maxmp))
         petData.append(str(pet.detail.value_attack))
         petData.append(str(pet.detail.value_defensive))
         petData.append(str(pet.detail.value_agility))
         petData.append(str(pet.detail.value_spirit))
         petData.append(str(pet.detail.value_recovery))
         petData.append(str(pet.detail.points_endurance))
         petData.append(str(pet.detail.points_strength))
         petData.append(str(pet.detail.points_defense))
         petData.append(str(pet.detail.points_agility))
         petData.append(str(pet.detail.points_magical))
      #print(petData,flush=True)
      return petData
   #获取身上宠物信息 包含算档信息
   def GetGamePets(self):
      pets=self.GetPetsInfo()
      tmpPets=[]
      for pet in pets:
         tmpPet = GamePet()       
         tmpPet.name = pet.name
         tmpPet.realname = pet.realname   
         tmpPet.hp = pet.hp
         tmpPet.maxhp = pet.maxhp
         tmpPet.mp = pet.mp
         tmpPet.maxmp = pet.maxmp       
         tmpPet.xp = pet.xp   
         tmpPet.maxxp = pet.maxxp   
         tmpPet.index = pet.index   
         tmpPet.state = pet.state   
         tmpPet.battle_flags = pet.battle_flags   
         tmpPet.skillslots = pet.skillslots   
         tmpPet.loyality = pet.loyality   
         tmpPet.race = pet.race   
         tmpPet.flags = pet.flags   
         tmpPet.level = pet.level   
         tmpPet.health = pet.health   
         tmpPet.detail = pet.detail   
         calcData = self.GetPetCalcBpData(pet)
         minGrade,maxGarde=self.ParsePetGrade(calcData)
         tmpPet.grade=minGrade
         tmpPet.lossMinGrade=minGrade
         tmpPet.lossMaxGrade=maxGarde
         tmpPets.append(tmpPet)
      return tmpPets

   def GetBattlePet(self):
      pets=self.GetPetsInfo()
      for pet in pets:
         if pet.battle_flags == TPET_STATE_BATTLE:
            return pet
      return None

   #招魂
   def RecallSoul(self):
      tryCount=0
      charInfo = self.GetPlayerInfo()
      if charInfo.souls <= 0:
         return
      while tryCount < 3:
         if charInfo.souls > 0:
            self.chat_log("人物掉魂：登出招魂")
            self.OutCastle("n")#出城堡北门	
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
               self.CheckGold(人物("灵魂")*30000,1000001,200000)
         else:
            return
   #哥拉尔检查状态
   def GleCheckHealth(self,doctorName):   
      playerinfo = self.GetPlayerInfo()
      if( playerinfo.health > 0 or playerinfo.souls > 0 or self.GetPlayerInfo().health > 0):
         #--登出 去治疗 招魂
         self.ToGle()
         self.GleRecallSoul()	
         self.GleHealPlayer(doctorName)		

   def ToGle(self):
      mapPos=self.GetMapCoordinate()		
      if (self.GetMapName()=="哥拉尔镇" and mapPos.x==120 ):
         return 
      self.LogBack()
      time.sleep(3)

   def GleRecallSoul(self):
      if( self.GetPlayerInfo().souls > 0 ):
         self.chat_log("触发登出补给:人物掉魂")
         self.ToGle()
         self.TurnAbout(0)
         time.Sleep(1)
         self.AutoMoveToEx(140,214,"白之宫殿")
         self.AutoMoveToEx(47, 36, 43210)
         self.AutoMoveTo(61, 46)
         self.TalkNpcPosSelectYesEx(2)
         time.Sleep(1)

   def GleSupply(self):
      needSupply = self.IsNeedSupply()	
      if(needSupply == False):
         return      
      if (self.GetMapName()!="哥拉尔镇" ):
         self.ToGle()
      self.AutoMoveToEx(165,91,"医院")
      self.AutoMoveTo(29,26)	
      self.RenewEx(30,26)	

   def GleHealPlayer(self,doctorName):
      petinfo = self.GetBattlePet()
      if( self.GetPlayerInfo().health > 0  or (petinfo and petinfo.health > 0)):
         self.ToGle()
         self.chat_log("人物受伤")
         self.AutoMoveToEx(165,91,"医院")
         self.AutoMoveTo(29,15)
         self.TurnAbout(2)
         self.WaitRecvNpcDialog()
         self.ClickNPCDialog(-1,6)
         self.AutoMoveTo(29,26)
         self.RenewEx(30,26)	

   #检查身上金币
   def CheckGold(self,minGold,maxGold,bagGold):      
      oldGold=self.GetPlayerInfo().gold
      if(oldGold < minGold):
         self.chat_log("人物现有金币【" + str(oldGold)+"】小于设定的最少值【"+(minGold)+"】,去银行取钱",1)
         self.GotoBankTalkNpc()
         self.WithdrawGold(-bagGold)
         time.sleep(1)
         nowGold=self.GetPlayerInfo().gold
         if(nowGold != oldGold):
            self.chat_log("取钱成功，现有金币：" + str(nowGold))         
      elif(oldGold > maxGold):
         self.chat_log("人物现有金币【"+ str(oldGold)+"】大于设定的最大值【"+str(maxGold)+"】,去银行存钱",1)
         self.GotoBankTalkNpc()
         self.DepositPetPos
         self.DepositGold(-bagGold)
         time.sleep(1)
         nowGold=self.GetPlayerInfo().gold
         if(nowGold == oldGold): #-银行满了 存少点
            self.chat_log("银行金币满了，尝试存部分金币")
            bankGold = self.GetBankGold()
            if(bagGold > 1000000):	
               self.DepositGold(10000000-bankGold)
            else:
               self.DepositGold(1000000-bankGold)            
            time.sleep(1)
            nowGold=self.GetPlayerInfo().gold
            if(nowGold != oldGold):
               self.chat_log("存钱成功，现有金币："+ str(nowGold))            
         else:
            self.chat_log("存钱成功，现有金币："+ str(nowGold))   
         


   #移动到目标坐标附近
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
   #人物治疗
   def HealPlayer(self,doctorName=None):
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
      self.debug_log(f"医生信息:{filterName}")
      self.ToCastle()      
      if self.IsNeedSupply():
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
            if ((u.flags & 256)!=0 and u.unit_name in filterName) :
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
            self.MoveToNpcNear(doctor.xpos,doctor.ypos,1)	#最后一个距离
            oldHealth=charInfo.health
            healTryNum=0
            self.AddTeammate(doctor.unit_name)
            if(self.GetTeammatesCount() > 1):
               while(healTryNum < 30):
                  if self.GetPlayerInfo().health == 0 :
                     self.LeaveTeammate()
                     return				                 		
                  healTryNum = healTryNum+1      
                  time.sleep(1)	#等待30秒 还受伤 重新加队	         
               if self.GetPlayerInfo().health > 0 :				
                  self.LeaveTeammate()	#重新找医生
                  filterName.remove(doctor.unit_name)						
         if tryNum >= 10 :
            return      
         tryNum = tryNum+1
   #宠物治伤
   def HealPet(self):
      if self.GetBattlePet().health== 0:
         return
      #宠物受伤 登出治伤
      self.chat_log("宠物受伤：登出治伤")
      self.GotoFaLanCity("e2")
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

   #检查健康状态 招魂-治疗
   def CheckHealth(self,doctorName=None):     
      petinfo = self.GetBattlePet()
      charInfo = self.GetPlayerInfo()
      if( charInfo.health > 0 or charInfo.souls > 0 or (petinfo and petinfo.health > 0)):
         #登出 去治疗 招魂
         self.ToCastle()
         self.RecallSoul()	
         self.HealPlayer(doctorName)
         self.HealPet()

   #使用物品，重载基类函数，增加类型判断
   def UseItem(self,itemName):
      if type(itemName) == int:
         super().UseItem(itemName)
      else:
         itemsInfo=self.GetItemsInfo()
         for itemInfo in itemsInfo:
            if itemInfo.name == itemName or (itemName.isdigit() and itemInfo.itemid == int(itemName)):
               super().UseItem(itemInfo.pos)
               return
   #解析物品耐久
   def ParseItemDurability(self,pItem):
      if (not pItem or not pItem.exist or len(pItem.attr) < 1):
         return
      sAttr = pItem.attr
      if (sAttr.find("耐久") == -1):
         return
      sAttr = sAttr[sAttr.find("耐久"):]
      #print(sAttr)
      sAttr = sAttr[0:sAttr.find("$")]
      #print("$------",sAttr)
      sAttr=sAttr.replace("耐久","")
      #print("$------",sAttr)
      matchResult = sAttr.split("/")
      #print(matchResult)
      #print(pItem.attr,matchResult)
      if (len(matchResult) == 2):
         pItem.nCurDurability = int(matchResult[0])
         pItem.nMaxDurability = int(matchResult[1])
         if (pItem.nMaxDurability > 0):
            pItem.nDurabilityRate = pItem.nCurDurability / pItem.nMaxDurability
   #装备耐久
   def ParseItemDurabilityEx(self,sItemAttr):
      sAttr = sItemAttr
      if (sAttr.find("耐久") == -1):
         return
      sAttr = sAttr[sAttr.find("耐久"):]
      #print(sAttr)
      sAttr = sAttr[0:sAttr.find("$")]
      #print("$------",sAttr)
      sAttr=sAttr.replace("耐久","")
      #print("$------",sAttr)
      matchResult = sAttr.split("/")
      #print(matchResult)
      #print(pItem.attr,matchResult)
      if (len(matchResult) == 2):
         nCurDurability = int(matchResult[0])
         nMaxDurability = int(matchResult[1])
         return nCurDurability,nMaxDurability
      else:
         return -1,-1

   #获取物品信息，带耐久
   def GetGameItems(self):
      newItemList=[]
      itemsinfo=self.GetItemsInfo()   
      for  iteminfo in itemsinfo:       
         item = GameItem()
         item.name = iteminfo.name
         item.attr = iteminfo.attr
         item.info =iteminfo.info
         item.itemid = iteminfo.itemid
         item.image_id = iteminfo.image_id
         item.type = iteminfo.type
         item.count = iteminfo.count
         item.pos = iteminfo.pos
         item.assessed = iteminfo.assessed
         item.level = iteminfo.level
         item.exist = True
         self.ParseItemDurability(item)
         #ITObjectDataMgr::getInstance().StoreServerItemData(item)
         #/qDebug() << QString::fromStdString(iteminfo.name) << QString::fromStdString(iteminfo.attr) << iteminfo.itemid << iteminfo.type << iteminfo.count << iteminfo.pos << iteminfo.assessed << iteminfo.level;
         newItemList.append(item)     
      return newItemList
   def CheckCrystal(self,crystalName=None,equipsProtectValue=None):
      if(equipsProtectValue==None):
         equipsProtectValue =100
      if(crystalName == None):
         crystalName = "水火的水晶（5：5）"
      itemList =  self.GetGameItems()
      crystal = None
      for item in itemList:
         if(item.pos == 7):
            crystal = item
            break
      #--当前水晶不需要更换
      #--喊话(crystal.name.."耐久"..crystal.durability.."设置值"..equipsProtectValue)
      if(crystal!=None and crystal.name == crystalName and crystal.nCurDurability > equipsProtectValue):
         return      
      crystal=None
      #--需要更换 检查身上是否有备用水晶
      for item in itemList:
         if(item.pos > 7 and item.name == crystalName and item.nCurDurability > equipsProtectValue):
            crystal = item
            break
      if(crystal!=None ):
         self.MoveItem(crystal.pos,7,-1)
         return      
      #买水晶
      self.BuyCrystal(crystalName)
      self.DropItem(7)#--扔旧的
      time.sleep(1)	#等待刷新
      self.UseItem(crystalName)

   #购买平民装备
   def BuyPopulaceEquip(self,equipName,buyCount):
      self.GotoFaLanCity()
      sWeapon="平民剑|平民斧|平民枪|平民弓|平民回力镖|平民小刀|平民杖"
      if(sWeapon.find(equipName) != -1):
         #--自动寻路(40, 98,"法兰城")	
         self.AutoMoveTo(150, 123)
         self.TurnAbout(0)
         self.WaitRecvNpcDialog()
         self.BuyDstItem(equipName,buyCount)	
      else:
         self.AutoMoveTo(156, 123)
         self.TurnAbout(0)
         self.WaitRecvNpcDialog()
         self.BuyDstItem(equipName,buyCount)	

   #检查装备耐久
   def CheckEquipDurable(self,equipPos,equipName,equipProtectValue=None):
      if(equipProtectValue==None):
         equipProtectValue =20  
      itemList = self.GetGameItems()
      tgtEquip = None
      for item in itemList:
         if(item.pos == equipPos):
            tgtEquip = item
            break        
      #--当前水晶不需要更换
      #--喊话(crystal.name.."耐久"..crystal.durability.."设置值"..equipsProtectValue)
      if(tgtEquip!=None and tgtEquip.name == equipName and tgtEquip.nCurDurability > equipProtectValue):
         return      
      tgtEquip=None
      #--需要更换 检查身上是否有备用水晶
      for item in itemList:
         if(item.pos > 7 and item.name == equipName and item.nCurDurability > equipProtectValue):
            tgtEquip = item
            break  
      if(tgtEquip!=None ):
         self.MoveItem(tgtEquip.pos,equipPos,-1)
         return      
      #买水晶
      self.BuyPopulaceEquip(equipName,1)
      self.DropItem(equipPos)   #--扔旧的
      time.sleep(1)	   #--等待刷新
      self.UseItem(equipName)
   
   #城堡打卡
   def ToCastleBeginWork(self):
      self.ToCastle("c")	
      if(self.GetCharacterData("卡时") == 0):
         日志("没有卡时，无法打卡")
         return      
      self.TalkNpcPosSelectYes(58,84)

   #取包裹空格
   def GetInventoryEmptySlotCount(self):
      nCount = 0
      posExist=[]
      itemsinfo = self.GetItemsInfo()     
      for iteminfo in itemsinfo:         
         if (iteminfo.pos > 7):
            posExist.append(iteminfo.pos)
      for i in range(8,28):
         if (i not in posExist):
            nCount+=1      
      return nCount

   #解析商店购买列表
   def ParseBuyStoreMsg(self,msg):
      obj={}
      if (len(msg) < 1):
         return obj    
      sMatch = msg.split("|")
      if (len(sMatch) < 5):
         return obj
      storeItemCount = (len(sMatch) - 5) / 6
      obj["storeid"]=sMatch[0]
      obj["name"]=sMatch[1]
      obj["welcome"]=sMatch[2]
      obj["insuff_funds"]=sMatch[3]
      obj["insuff_inventory"]= sMatch[4]
      itemList=[]      
      for i in range(int(storeItemCount)):   
         itemMap={}
         itemMap["name"]=sMatch[5 + 6 * i + 0]
         itemMap["image_id"]= sMatch[5 + 6 * i + 1]
         itemMap["cost"]= sMatch[5 + 6 * i + 2]
         itemMap["attr"]= sMatch[5 + 6 * i + 3]
         itemMap["unk1"]= sMatch[5 + 6 * i + 4]
         itemMap["max_buy"]= sMatch[5 + 6 * i + 5]
         itemList.append(itemMap)      
      obj["items"]=itemList
      return obj

   #买
   def Shopping(self,index,count):
      items = []
      subItem = CGAPython.cga_buy_item_t()
      subItem.index = index
      subItem.count = count
      items.append(subItem)
      self.BuyNPCStore(items )

   #商店购买指定物品
   def BuyDstItem(self,itemName=None,buyCount=None):
      if(itemName == None): 
         self.chat_log("购买物品名为空，返回")
         return 
      if(buyCount==None):
         buyCount=1
      self.ClickNPCDialog(0,0)# --第二个参数0 0买 1卖 2不用了
      dlg = self.WaitRecvNpcDialog()
      if(dlg == None):
         return False
      buyData = self.ParseBuyStoreMsg(dlg.message)
      itemList = buyData["items"]
      dstItem = None
      for i in range(len(itemList)):
         if( itemList[i]["name"] == itemName):
            dstItem={"index":i,"count":buyCount}			         
      
      if (dstItem != None):
         self.Shopping(dstItem["index"],dstItem["count"])
         time.sleep(1)
         self.ClickNPCDialog(-1,0)
         return True
      else:
         self.chat_log("购买道具" + itemName + "失败！")
         return False      
      return False

   #买水晶
   def BuyCrystal(self,crystalName=None,buyCount=None):
      self.chat_log("买水晶")
      if(buyCount==None):
         buyCount=1
      if(crystalName == None):
         crystalName = "水火的水晶（5：5）"
      if(self.GetInventoryEmptySlotCount() < 1):
         self.LogBack()
         self.SellCastle()		

      if(self.GetInventoryEmptySlotCount() < 1):
         self.chat_log("背包没有空格，买水晶中断！")
         self.LogBack()
         return
      
      if(self.GetInventoryEmptySlotCount() < buyCount):
         self.chat_log("背包空格数量不够，买水晶中断！")
         self.LogBack()
         return      
      mapNumber = self.GetMapNumber()
      if mapNumber != 1041:
         self.GotoFaLanCity("w1")
         self.AutoMoveToEx(94,78,"达美姊妹的店")	
      self.AutoMoveTo(17,18)
      time.sleep(1)
      self.TurnAbout(2)
      self.WaitRecvNpcDialog()	
      return self.BuyDstItem(crystalName,buyCount)	

   #前往法兰城 6个点
   #"s2","w2","e2","t1"	t1市场一楼 t3市场三楼
   #"s1","w1","e1","t3"
   def GotoFaLanCity(self,storeName=None):            
      def liBao():
         if(self.GetMapName() != "里谢里雅堡"):
            time.sleep(2)
            return    
         self.AutoMoveToEx(41,98,"法兰城")	
         self.AutoMoveTo(153, 130)		
         if(storeName==None or storeName=="" or storeName=="s"):
            return          
      def faLan():
         if(storeName==None or storeName=="" ):
            return     
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

   def OutFaLan(self,sDir):
      if sDir == "e":
         self.GotoFaLanCity("e1")
         self.AutoMoveTo(281,88)
      elif sDir=="s":
         self.GotoFaLanCity("s")
         self.AutoMoveTo(154, 241)
      elif sDir=="w":
         self.GotoFaLanCity("w1")
         self.AutoMoveTo(22,88)	

   def OutCastle(self,sDir):
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
   #去法兰银行对话NPC
   def GotoFalanBankTalkNpc(self):
      if self.GetMapNumber() != 1121:
         self.GotoFaLanCity("e1")
         self.WaitForMap("法兰城")
         self.AutoMoveTo(238,111,"银行")	
      self.AutoMoveTo(11,8)
      self.TurnAbout(2)
      self.WaitRecvNpcDialog()
   #去银行和职员对话
   def GotoBankTalkNpc(self):            
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
         self.GotoFaLanCity("e1")		
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
   
   #获取队伍信息
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
         #self.debug_log(f"name:{tmpTeam.name},unit:{tmpTeam.unit_id}")
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
               #self.debug_log(f"nick_name:{unit.nick_name},title_name:{unit.title_name},unit_name:{unit.unit_name},unit_id:{unit.unit_id}")
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
   
   #人物动作
   def DoCharacterAction(self,nType):
      self.DoRequest(nType)

   #查找附近指定名称单位
   def FindPlayerUnit(self,szName):
      units=self.GetMapUnits()
      for mapUnit in units:
         if mapUnit.valid and mapUnit.type == 8 and mapUnit.model_id != 0 and (mapUnit.flags & 256) != 0 and mapUnit.unit_name == szName:
            return  mapUnit
      return None

   #查找周围迷宫
   def FindAroundMaze(self):
      units = self.GetMapUnits()
      for mapUnit in units:	
         if (mapUnit.flags & 4096)!=0 and mapUnit.model_id > 0:	
            return mapUnit
      return None

   #查找周围迷宫，有名字则自动寻路进入
   def FindAroundMazeEx(self,mazeName,modelid=None):
      units = self.GetMapUnits()		
      for mapUnit in units:	
         if (mapUnit.flags & 4096)!=0 and mapUnit.model_id > 0:	
            if(modelid==None or (modelid!=None and mapUnit.model_id == modelid)):
               self.AutoMoveTo(mapUnit.xpos,mapUnit.ypos)
               self.WaitInNormalState()
               if(self.GetMapName() == mazeName):
                  return True
               else:#--出去
                  curPos=self.GetMapCoordinate()
                  tPoint=self.GetRandomSpace(curPos.x,curPos.y,1)#取当前坐标指定距离范围内 空地
                  self.AutoMoveTo(tPoint.x,tPoint.y)
                  self.AutoMoveTo(curPos.x,curPos.y)		
                  self.WaitInNormalState()	
      return False

   #队长进行组队等待
   def MakeTeam(self,teamCount,teammateList,timeout=100):
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
      self.debug_log("组队等待中...")
      while True:
         while tryNum<=waitNum:		
            if(self.GetTeammatesCount() >= teamCount):#	--数量不足 等待
               self.debug_log("队伍人数达标")
               break         		
            time.sleep(1)
            tryNum=tryNum+1      
         if(tryNum > waitNum):	#--超时退出
            return      
         if(teammateList == None):	#	--不判断队友
            return
         else:							#判断是否是设置队员 
            self.kickTeam(teammateList)
            if(self.GetTeammatesCount() < teamCount): #	--重新等待组队 
               self.debug_log("剔除人员，人数不够，继续等待")
               continue
            else:
               self.debug_log("队伍人数达标，返回")
               return
      
   #--剔除不在队员列表里的队员
   def kickTeam(self,teammateList):
      self.debug_log("剔除不在名单的人")
      if(teammateList==None):
         return
      teamPlayers = self.GetTeamPlayers()
      self.debug_log("GetTeamPlayers")
      for teamPlayer in teamPlayers :
         self.debug_log(teamPlayer.name)
         if teamPlayer.is_me:
            continue
         if(teamPlayer.name not in teammateList):   #不在列表 踢
            self.DoCharacterAction(TCharacter_Action_KICKTEAM) 	
            dlg=self.WaitRecvNpcDialog()
            if(dlg != None):
               teamMsg=dlg.message
               self.debug_log(teamMsg)
               msgIndexEnd=teamMsg.find("你要把谁踢出队伍？\n")
               if(msgIndexEnd != -1):
                  teamMsg=teamMsg[msgIndexEnd+len("你要把谁踢出队伍？\n"):]
                  #self.debug_log(teamMsg)
                  kickIndex=-1
                  teamNameList = teamMsg.split("\n")
                  for i in range(len(teamNameList)):
                     tName = teamNameList[i]
                     #self.debug_log("split:"+tName)
                     if(tName.find("|") != -1):
                        #self.debug_log("|" + tName + teamPlayer.name)
                        kickIndex=kickIndex+1
                        if(tName.find(teamPlayer.name) != -1):
                           self.ClickNPCDialog(0,kickIndex)
                           self.debug_log("剔除队伍：" + tName+ str(kickIndex))
                           time.sleep(1.5)   #等1.5秒哈，不然命令还没过去，下一个代码就执行了
                           break
   #判断队长名称是否一致
   def JudgeTeamLeader(self,leaderName):
      teamPlayers = self.GetTeamPlayers()
      if (len(teamPlayers) > 0 and teamPlayers[0].name == leaderName):         
         return True
      else:
         return False

   #加入队伍
   def AddTeammate(self,sName:str,timeout=180):
      self.debug_log(f"加入队伍函数,队长名称：{sName},超时时间:{timeout}")
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
            self.ClickNPCDialog(32, -1)
         else:
            self.debug_log("dlg == None")
         teamPlayers = self.GetTeamPlayers()
         if (len(teamPlayers) > 0 and teamPlayers[0].name == sName):
            self.debug_log("队伍数量%d,队长名称：%s"%(len(teamPlayers),teamPlayers[0].name))   
            return True
         else:
            self.debug_log("离队")  
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
   #存钱
   def DepositGold(self,nVal):
      pCharacter = self.GetPlayerInfo()
      realGold = nVal   #实际存入钱
      if (realGold < 0):
         if (pCharacter.gold > abs(realGold)):         
            realGold = pCharacter.gold - abs(realGold)
         else:         
            self.chat_log("身上没有那么多钱了，存储失败！")
            return False     
      if (realGold > pCharacter.gold):
         realGold = pCharacter.gold
      #//存储不判断银行金额 因为有些大客户可以存1000 万
      self.MoveGold(realGold, 1)

   #去银行取钱      
   def GetMoneyFromBank(self,money):
      self.WaitInNormalState()
      if self.GetTeammatesCount() > 1:
         self.LeaveTeammate()      
      self.GotoBankTalkNpc()
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
   def DepositNoBattlePetToBank(self):
      self.WaitInNormalState()
      if(self.GetTeammatesCount()>1):
         self.LeaveTeammate()
      self.GotoBankTalkNpc()
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

   def IsNeedSupply(self):
      needSupply = False
      playerinfo=self.GetPlayerInfo()
      petsinfo=self.GetPetsInfo() 
      if(self.NeedHPSupply(playerinfo) or self.NeedMPSupply(playerinfo)):
         needSupply=True      
      if(self.NeedPetSupply(petsinfo)):#所有宠
         needSupply=True
      
      return needSupply
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
               result = self.ClickNPCDialog(0, 2)
               return True            
            elif (bNeedMP and playerinfo.gold >= playerinfo.maxmp - playerinfo.mp):# //加魔钱够 回复魔和血
               result = self.ClickNPCDialog(0, 0)
               return True
            #人物不需要回复 则回复宠物
            petsinfo = self.GetPetsInfo()
            if (not result and petsinfo):
               if (self.NeedPetSupply(petsinfo)):# //回复宠物            
                  result = self.ClickNPCDialog(0, 4)
                  return True
      elif (dlg and dlg.type == 0):      
         if (dlg.options == 12): #//是   
            result = self.ClickNPCDialog(4, -1)# //4 是 8否 32下一步 1确定
            return True        
         if (dlg.options == 1):# //确定
            result = self.ClickNPCDialog(1, -1)
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

   def SupplyCastle(self):
      needSupply = self.IsNeedSupply()	
      if(needSupply == False):
         return
      self.WaitInNormalState()
      self.ToCastle()
      self.AutoMoveTo(34,89)
      self.Renew(1)

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

   def ToTeleRoomTemplate(self,warpData):
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
            self.ToCastle()          

   '''去里堡 空参:34,89 
   --"c" 里堡打卡点
   --"f1"里堡1层
   --"f2"里堡2层
   --"f3"谒见之间
   --"s"召唤之间
   --"l"图书室
   '''
   def ToCastle(self,warpPos=None):
      while True:
         self.WaitInNormalState()
         curMapName = self.GetMapName()
         if (curMapName=="艾尔莎岛" ):			
            self.AutoMoveTo(140,105)				
            self.TurnAbout(1)
            self.WaitRecvNpcDialog()
            self.ClickNPCDialog(4,0)
            self.WaitForMap("里谢里雅堡")           
         elif (curMapName=="里谢里雅堡" ):	
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
         elif (curMapName=="法兰城" ):		
            self.GotoFaLanCity("s1")
            self.AutoMoveToEx(153,100,"里谢里雅堡")           
         elif (curMapName=="召唤之间" ):#	--登出 bank
            self.AutoMoveToEx( 3, 7)	
            self.WaitForMap("里谢里雅堡")		 
         else:
            self.LogBack()
         time.sleep(2)    
	

   def ToTeleRoom(self,villageName=""):
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
         self.ToTeleRoom("杰诺瓦镇")
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
         self.ToTeleRoomTemplate(data)	  
      elif(villageName == "魔法大学"):
         data = warpList["阿巴尼斯村"]
         self.ToTeleRoomTemplate(data)
         self.AutoMoveToEx(5, 4, 4313)
         self.AutoMoveToEx(6, 13, 4312)
         self.AutoMoveToEx(6, 13, "阿巴尼斯村")
         self.AutoMoveToEx(37, 71,"莎莲娜")
         self.AutoMoveToEx(118, 100,"魔法大学")
      elif(villageName == "咒术师的秘密住处"):		
         self.ToCastle("f1")
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

   def PileItem(self,name,count):
      itemsInfo=self.GetItemsInfo()
      for pItem in itemsInfo:
         if  pItem.name == name and pItem.count < count:
            for pOtherItem in itemsInfo:
               if pOtherItem.name == pItem.name and pOtherItem != pItem and pOtherItem.count < count:
                  self.MoveItem(pItem.pos, pOtherItem.pos, -1)
                  break
   def SellPilePos(self,x,y,saleItem,count=20,maxCount=40):
      loopCount=0      
      while loopCount < 2:         
         apiSaleItems=[]
         bagItems = self.GetItemsInfo()
         for v in bagItems:
            if(v.pos > 7 and v.name == saleItem and v.count>=count):
               apiSaleItem=CGAPython.cga_sell_item_t()#{"id":v.itemid,"pos":v.pos,"count":v.count/count}
               apiSaleItem.itemid=v.itemid
               apiSaleItem.itempos=v.pos
               apiSaleItem.count=v.count/count
               apiSaleItems.append(apiSaleItem)	         
         self.TrunAboutEx(x,y)
         self.WaitRecvNpcDialog()		
         self.ClickNPCDialog(-1,0)#	--这边没有类型判断 直接-1了
         self.WaitRecvNpcDialog()
         self.SellNPCStore(apiSaleItems)
         self.PileItem(saleItem,maxCount)
         time.sleep(3)
         loopCount=loopCount+1
	#卖堆叠物
   def SellPileDir(self,saleItem,count=20,maxCount=40):     
      loopCount=0      
      while loopCount < 2:         
         apiSaleItems=[]
         bagItems = self.GetItemsInfo()
         for v in bagItems:
            if(v.pos > 7 and v.name == saleItem and v.count>=count):
               apiSaleItem=CGAPython.cga_sell_item_t()#{"id":v.itemid,"pos":v.pos,"count":v.count/count}
               apiSaleItem.itemid=v.itemid
               apiSaleItem.itempos=v.pos
               apiSaleItem.count=v.count/count
               apiSaleItems.append(apiSaleItem)	         
         self.TrunAbout(dir)
         self.WaitRecvNpcDialog()		
         self.ClickNPCDialog(-1,0)#	--这边没有类型判断 直接-1了
         self.WaitRecvNpcDialog()
         self.SellNPCStore(apiSaleItems)
         self.PileItem(saleItem,maxCount)
         time.sleep(3)
         loopCount=loopCount+1
   #取身上物品数量
   def GetAllItemCount(self,itemName):
      itemsInfo = self.GetItemsInfo()
      nCount=0
      if type(itemName) == str:
         for iteminfo in itemsInfo:
            if (iteminfo.name == itemName.toStdString() ):
               nCount += 1
      else:
         for iteminfo in itemsInfo:
            if (iteminfo.itemid == itemName):
               nCount += 1	
      return nCount
   #取背包物品数量
   def GetBagItemCount(self,itemName):
      itemsInfo = self.GetItemsInfo()
      nCount=0
      if type(itemName) == str:
         for iteminfo in itemsInfo:
            if (iteminfo.pos > 7 and iteminfo.name == itemName ):
               nCount += 1
      else:
         for iteminfo in itemsInfo:
            if (iteminfo.pos > 7 and iteminfo.itemid == itemName):
               nCount += 1	
      return nCount
   #取银行物品数量
   def GetBankItemCount(self,itemName):
      itemsInfo = self.GetBankItemsInfo()
      nCount=0     
      for iteminfo in itemsInfo:
         if ( iteminfo.name == itemName):
            nCount += 1      
      return nCount
   
   #取背包物品叠加数量
   def GetBagItemPileCount(self,itemName):
      itemsInfo = self.GetItemsInfo()
      nCount=0
      if type(itemName) == str:
         for iteminfo in itemsInfo:
            if (iteminfo.pos > 7 and iteminfo.name == itemName.toStdString() ):
               nCount += iteminfo.count
      else:
         for iteminfo in itemsInfo:
            if (iteminfo.pos > 7 and iteminfo.itemid == itemName):
               nCount += iteminfo.count			
      return nCount
   #取身上物品叠加总数
   def GetAllItemPileCount(self,itemName):
      itemsInfo = self.GetItemsInfo()
      nCount=0
      if type(itemName) == str:
         for iteminfo in itemsInfo:
            if (iteminfo.name == itemName.toStdString() ):
               nCount += iteminfo.count
      else:
         for iteminfo in itemsInfo:
            if (iteminfo.itemid == itemName):
               nCount += iteminfo.count			
      return nCount
   #取银行物品叠加数量
   def GetBankItemPileCount(self,itemName):
      itemsInfo = self.GetBankItemsInfo()
      nCount=0
      if type(itemName) == str:
         for iteminfo in itemsInfo:
            if (iteminfo.name == itemName.toStdString() ):
               nCount += iteminfo.count
      # else:
      #    for iteminfo in itemsInfo:
      #       if (and iteminfo.itemid == itemName):
      #          nCount += iteminfo.count			
      return nCount
   #城堡卖
   def SellCastle(self,saleItems):
      saleList=["魔石","锥形水晶","卡片？","锹型虫的卡片","水晶怪的卡片","哥布林的卡片","红帽哥布林的卡片","迷你蝙蝠的卡片","绿色口臭鬼的卡片","锥形水晶"]
      if type(saleList) == list:
         saleList+=saleItems
      else:
         saleList.append(saleItems)
      needSale=False
      for itemName in saleList:
         if self.GetBagItemCount(itemName) > 0 :
            needSale=True
            break
      if needSale==False:
         return 
      self.WaitInNormalState()
      mapName = self.GetMapName()
      if mapName == "工房":
         if(self.IsNearTarget(21,23,1)==True):
            for item in saleList:
               if(self.GetBagItemCount(itemName) > 0):
                  self.Sale(21,23,item)
            for item in saleList:
               if(self.GetBagItemCount(itemName) > 0):
                  self.Sale(21,23,item)
      else:
         self.ToCastle()
         self.AutoMoveTo(31,77)		
         for item in saleList:
            if(self.GetBagItemCount(itemName) > 0):
               self.SaleEx(6,item)
         for item in saleList:
            if(self.GetBagItemCount(itemName) > 0):
               self.SaleEx(6,item)

   #城堡卖叠加物
   def SellCastlePile(self,saleItem,count=20,maxCount=40):	
      needSale=False	
      if(self.GetBagItemPileCount(saleItem) >= count):
         needSale = True		
      if(needSale == False): 
         return
   
      self.WaitInNormalState()
      mapName = self.GetMapName()
      if (mapName=="工房" ):			
         if(self.IsNearTarget(21,23,1)):
            self.SellPilePos(21,23,saleItem,count,maxCount)	
      else:
         self.ToCastle()
         self.AutoMoveTo(31,77)		
         self.SellPileDir(6,saleItem,count,maxCount)	
   #卖
   def Sale(self,x,y,itemName):
      if not self.IsNearTarget(x, y, 2):
         return False
      sSaleItems = []
      if itemName.find("|") != -1:
         sSaleItems = itemName.split("|")
      else:
         sSaleItems.append(itemName)
      itemsInfo=self.GetItemsInfo()
      pExistItemList=[]	#重复判断
      cgaSaleItems=[]
      for itemInfo in itemsInfo:
         if itemInfo.pos > 7 and  itemInfo.name in sSaleItems:
            if itemInfo in pExistItemList:
               continue
            cgaItem = CGAPython.cga_sell_item_t()
            cgaItem.itemid = itemInfo.itemid
            cgaItem.itempos = itemInfo.pos
            cgaItem.count = 1    #堆叠物自己改
            #//不清楚最少卖的数量的话，卖东西会失败
            cgaSaleItems.append(cgaItem)
            pExistItemList.append(itemInfo)
      if len(cgaSaleItems) < 1:
         self.debug_log("没有要卖的物品")
         return False
      self.TurnAboutEx(x,y)
      dlg = self.WaitRecvNpcDialog()
      self.debug_log(dlg.message)
      self.debug_log(dlg.message[(len(dlg.message) - 1)])
      self.debug_log("-----")
      if dlg != None and dlg.type==5:
         self.ClickNPCDialog(-1, 1  if dlg.message[(len(dlg.message) - 1)] == "3" else 0)
      dlg = self.WaitRecvNpcDialog()
      if dlg != None and dlg.type==7:
         self.SellNPCStore(cgaSaleItems)
      self.WaitRecvNpcDialog()
      return True
   #卖
   def SaleEx(self,nDir,itemName):
      dirPos = self.GetDirectionPos(nDir, 2)
      return self.Sale(dirPos.x, dirPos.y, itemName)
   #法兰城卖叠加物品
   def SellFaLanPile(self,saleItem):
      self.GotoFaLanCity()
	   #--自动寻路(40, 98,"法兰城")	
      self.AutoMoveTo(150, 123)
      self.SaleEx(0,saleItem)		

   #创建服务-ip为空时，则为本机，port为空时，则自动递增获取
   #只启动服务，使用由外部自己定义
   def CreateServer(self,ip=None,port=None):
      sio = socketio.Server()
      self.sio=sio
      self.app = socketio.WSGIApp(sio)
      # @self.sio.event
      # def connect(sid, environ):
      #    print('connect ', sid,flush=True)

      # @self.sio.on('client')
      # def another_event(sid, data):
      #    print('serve received a message!', data)

      @self.sio.event
      def disconnect(sid):
         print('disconnect ', sid,flush=True)      
      self.g_socket=eventlet.listen(("127.0.0.1", 0))
      host, port =self.g_socket.getsockname()
      #上报端口
      self.init_grpc()
      if self.g_stub:#暂时ip用回环
         self.g_stub.UploadCharcterServer(CGData__pb2.SelectCharacterServerResponse(char_name=self.GetPlayerInfo().name,big_line=cg.GetMapIndex()[0],ip="127.0.0.1",port=port,online=cg.IsInGame()))
      
      
   def StartServer(self):
      def ServerListen(): 
         self.debug_log(f"listen socket{self.g_socket} ")
         eventlet.wsgi.server(self.g_socket, self.app)
         self.debug_log("listen socket线程退出")     
      t=threading.Thread(target=ServerListen)
      t.start()

   def CreateMulticastSocket(self,tgtHost,tgtPort,multicastGroupIp):
      
      # 创建UDP socket
      self.g_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
      # 允许端口复用
      self.g_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
      # 绑定监听多播数据包的端口
      self.g_socket .bind((tgtHost, tgtPort))
      # 声明该socket为多播类型
      self.g_socket.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, 255)
      # 加入多播组，组地址由第三个参数制定
      self.g_socket.setsockopt(
         socket.IPPROTO_IP,
         socket.IP_ADD_MEMBERSHIP,
         socket.inet_aton(multicastGroupIp) + socket.inet_aton(tgtHost)
      )
      self.g_multicastIp=multicastGroupIp
      self.g_multicastPort=tgtPort
      self.g_socket.setblocking(False)
   
   #发送数据到组播
   def SendToMulticastGroup(self,msg):
      if self.g_socket == None:
         self.debug_log("组播socket为空，请先CreateMulticastSocket")
         return
      if type(msg) == str:
         self.g_socket.sendto(msg.encode(), (self.g_multicastIp, self.g_multicastPort))
      elif type(msg) == dict:
         transMsg = json.dumps(msg)
         self.g_socket.sendto(transMsg.encode(), (self.g_multicastIp, self.g_multicastPort))

   #接收组播数据
   def RecvFromMulticastGroup(self):
      if self.g_socket == None:
         self.debug_log("组播socket为空，请先CreateMulticastSocket")
         return
      try:
         data, address = self.g_socket.recvfrom(2048)     
         data = data.decode()
         return data  #外层自己去翻译
      except Exception as e:
         return None

   def SetPlayerInfo(self,*args):
      if len(args)<=1:
         return None
      if args[0] == "玩家称号" and len(args)>=2:
         self.ChangeNickName(args[1])
      elif args[0]=="简介":
         if len(args)<9:
            return None
         changeBits = args[1]
         sellIcon = args[2]
         sellString = args[3]
         buyIcon = args[4]
         buyString = args[5]
         wantIcon = args[6]
         wantString = args[7]
         descString = args[8]
         desc=CGAPython.cga_pers_desc_t()
         desc.sellIcon = sellIcon
         desc.sellString = sellString
         desc.buyIcon = buyIcon
         desc.buyString = buyString
         desc.wantIcon = wantIcon
         desc.wantString = wantString
         desc.descString = descString
         if (sellIcon):
            changeBits |= 1
         if (len(sellString) > 0):
            changeBits |= 2
         if (buyIcon):
            changeBits |= 4
         if (len(buyString) > 0):
            changeBits |= 8
         if (wantIcon):
            changeBits |= 0x10
         if (len(wantString) > 0):
            changeBits |= 0x20
         if (len(descString) > 0):
            changeBits |= 0x40
         desc.changeBits = changeBits
         self.ChangePersDesc(desc)
   def DropItem(self,itemName):
      if type(itemName) == str:
         itemsInfo = self.GetItemsInfo()
         for itemInfo in itemsInfo:
            if itemInfo.name == itemName or (itemName.isdigit() and itemInfo.itemid==int(itemName)):
               super().DropItem(itemInfo.pos)               
      elif type(itemName) == int:
         super().DropItem(itemName)
   #获取游戏大区-电信或网通
   def GetGameServerType(self):
      serverInfo=CGAPython.cga_game_server_info_t()
      if(self.GetGameServerInfo(serverInfo)):
         if serverInfo.ip in self.g_serverTelecoms:
            return 13
         elif serverInfo.ip in self.g_serverNetcom:
            return 14
      return -1
   #指定方向移动一格
   def MoveGo(self,nDir):
      tgtPos = self.GetDirectionPos(nDir, 1)
	   #不进行移动遇敌判断 这些了
      self.WalkTo(tgtPos.x, tgtPos.y)


#返回单例对象
cg = CGAPI()
cg.init_log()
人物 = cg.GetCharacterData
宠物 = cg.GetBattlePetData
# def 宠物(*args):
#    if len(args)<1:
#       return 0
#    return cg.GetBattlePetData(args[0],args)
#    return
#    if len(args) == 1:
#       cg.Renew(args[0])
#    elif len(args)>=2:
#       cg.RenewEx(args[0],args[1])
#说明：如果自己定义函数，需要游戏程序看到的错误信息，用日志()打印，不需要用户看到，但自己后续错误定位的日志，用调试日志()打印
#调整控制台日志级别，调试日志()和日志都可以看到
def 打开调试():
   cg.g_consoleHandler.setLevel(logging.DEBUG)
#调整控制台日志级别，调试日志()看不到，只有日志()输出的可以看到
def 关闭调试():
   cg.g_consoleHandler.setLevel(logging.INFO)
调试日志=cg.debug_log
调试=cg.debug_log
#日志 = cg.chat_log
喊话 = cg.chat_log
def 日志(*args):
   if len(args)>=2:
      if args[1] == 1:
         cg.chat_log(args[0])
      else:
         cg.log(args[0])
   else:
      cg.log(args[0])
取当前地图编号 = cg.GetMapNumber
取当前地图名 = cg.GetMapName
取当前坐标 = cg.GetMapCoordinate
def 等待(nTime):
   time.sleep(nTime*0.001)
回城 = cg.LogBack
转向 = cg.TurnAbout
def 对话选择(*args):
   tArgs=[]
   for i in range(len(args)):
      if args[i] == "":
         tArgs.append(0)
      else:
         tArgs.append(int(args[i]))
   
   cg.ClickNPCDialog(tArgs[0],tArgs[1])
#对话选是 = cg.TalkNpcPosSelectYes
def 对话选是(*args):
   if len(args) == 1:
      cg.TalkNpcPosSelectYesEx(args[0],100)
   elif len(args)>=2:
      cg.TalkNpcPosSelectYes(args[0],args[1],100)

等待空闲 = cg.WaitInNormalState
是否空闲中=cg.IsInNormalState
#自动寻路 = cg.AutoMoveTo
def 自动寻路(*args):
   if len(args) == 2:
      cg.AutoMoveTo(args[0],args[1])
   elif len(args)>=3:
      cg.AutoMoveToEx(args[0],args[1],args[2])
def 等待到指定地图(*args):
   if len(args) == 1:
      cg.Nowhile(args[0])
   elif len(args)>=3:
      cg.NowhileEx(args[0],args[1],args[2])
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

出法兰城 = cg.OutFaLan
出里谢里亚堡=cg.OutCastle
取队伍人数=cg.GetTeammatesCount
加入队伍=cg.AddTeammate
离开队伍=cg.LeaveTeammate

创建服务=cg.CreateServer
启动服务=cg.StartServer
信息打印=cg.BaseInfoPrint
统计信息=cg.StatisticsTime
检查健康=cg.CheckHealth
检查水晶=cg.CheckCrystal
取包裹空格=cg.GetInventoryEmptySlotCount
取物品数量=cg.GetBagItemCount
装备信息=cg.GetPlayereEquipData
队伍信息=cg.GetTeamPlayers
是否目标附近=cg.IsNearTarget
开始遇敌=cg.begin_auto_action
停止遇敌=cg.end_auto_action
转向坐标=cg.TurnAboutEx
检查金币=cg.CheckGold
去银行对话=cg.GotoBankTalkNpc
def 银行(*args):
   if len(args) == 1:
      cg.Renew(args[0])
   elif len(args)==3:
      if args[0] == "取物":
         cg.WithdrawGold()
def 队伍(*args):
   if len(args)==1:
      if args[0] == "人数":
         return cg.GetTeammatesCount()
是否队长=cg.JudgeTeamLeader
移动到目标附近=cg.MoveToNpcNear
目标是否可达=cg.IsReachableTarget
扔=cg.DropItem
扔宠=cg.DropPet
使用物品=cg.UseItem
全部宠物信息=cg.GetGamePets
设置个人简介=cg.SetPlayerInfo
创建组播服务=cg.CreateMulticastSocket
发送信息到组播=cg.SendToMulticastGroup
从组播接收信息=cg.RecvFromMulticastGroup
菜单选择 = cg.PlayerMenuSelect
移动一格=cg.MoveGo
def 设置(*args):
   if len(args)==2:
      if args[0] == "移动速度":
         cg.SetMoveSpeed(int(args[1]))