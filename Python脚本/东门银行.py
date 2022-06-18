import CGAPython
import time
import sys
import os
import logging

#日志格式
LOG_FORMAT = "%(asctime)s %(message)s"
#配置日志
logging.basicConfig(level=logging.DEBUG, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S')
#打印日志  
logging.info("测试日志")

#创建CGA访问接口
cga=CGAPython.CGA()

#创建CGA聊天信息变量
msg = CGAPython.cga_chat_msg_t()

#定义聊天回调函数，回调聊天消息
def charCallBack(msg):
    logging.info("ID："+ str(msg.unitid) + "消息:"+msg.msg + "颜色"+str(msg.color) + "范围"+ str(msg.size))
    # logging.info(msg.msg)
    # logging.info(msg.color)
    # logging.info(msg.size)
	# print(msg.unitid,flush=True)
	# print(msg.msg,flush=True)
	# print(msg.color,flush=True)
	# print(msg.size,flush=True)



#连接游戏窗口
if(cga.Connect(int(sys.argv[1]))==False):       #argv第一个程序路径 第二个参数是游戏端口
   print('无法连接到本地服务端口，可能未附加到游戏或者游戏已经闪退！')
   

#获取当前地图名称


while True :
    mapName=cga.GetMapName()
    if(mapName=="艾尔莎岛"):
        cga.AutoMoveTo(140,105)     #暂时没有A*算法寻路 所以需要10个坐标以内 写一次  还要判断到达目的地
        cga.TurnTo(141,105)     #转向  这里没有等待对话框返回 需要调用以后加一个
        cga.ClickNPCDialog(4,0) #对话选择
    elif mapName=="里谢里雅堡":
        cga.AutoMoveTo(65,53)
    elif mapName=="法兰城":
        cga.AutoMoveTo(238,111)
        break
    else:
        cga.LogBack()
    
print(cga.IsConnected())

#注册聊天消息回调函数，用于接收当前游戏聊天数据	
cga.RegisterChatMsgNotify(charCallBack)
print(cga.IsInGame())
print(cga.GetWorldStatus())
print(cga.GetGameStatus())
print(cga.GetBGMIndex())
#cga.GetWorldStatus()
#cga.GetGameStatus()
#cga.GetBGMIndex()

#获取游戏人物角色信息
info=cga.GetPlayerInfo()
print(info.hp)
print(info.maxhp)
print(info.level)
print(info.gold)
print(info.name,flush=True)
print(info.job)
print(info.detail.points_endurance)
print(info.titles[0])
#petskills=CGAPython.cga_pet_skills_info_t()

#获取第一个宠物技能信息
petskills=cga.GetPetSkillsInfo(0)
#print(len(petskills))
print(petskills[0].name)
#for i, k in enumerate(petskills, start=1):
#    print(k.name)

#获取当前服务器地图信息
mapinfo = cga.GetMapIndex()
print(mapinfo)
print(mapinfo[0])       #
print(mapinfo[1])
print(mapinfo[2])
print(mapinfo[3])

#获取当前人物坐标
mappos=cga.GetMapXY()
print(mappos)
print(mappos['x'])
print(mappos['y'])

#获取人物第1个技能的第一个子技能 合成物品信息
# craftInfo=cga.GetCraftInfo(0,0)
# print(craftInfo.name)
# print(craftInfo.info)
# print(craftInfo.materials)

#更改玩家自定义称号
cga.ChangeTitleName(1)
#cga.WalkTo(145,98)

#喊话
cga.SayWords("Hello World",1,2,3)

#获取地图单元信息
mapUnits=cga.GetMapUnits()
#print(mapUnits)
sys.stdout.flush()

#遍历打印地图信息
for unit in mapUnits:
	print(("%s %d %d %d") % (unit.item_name, unit.model_id, unit.xpos, unit.ypos),flush=True)
	#print(unit.item_name)
time.sleep(100)