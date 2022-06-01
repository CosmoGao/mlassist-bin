import CGAPython
import time
import sys
import os
import logging

LOG_FORMAT = "%(asctime)s %(message)s"
logging.basicConfig(level=logging.DEBUG, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S')
  
logging.info("测试日志")

cga=CGAPython.CGA()


msg = CGAPython.cga_chat_msg_t()
def charCallBack(msg):
	print(msg.unitid)
	print(msg.msg)
	print(msg.color)
	print(msg.size)

cga=CGAPython.CGA()
if(cga.Connect(int(sys.argv[1]))==False):       #第一个程序路径 第二个参数是游戏端口
   print('无法连接到本地服务端口，可能未附加到游戏或者游戏已经闪退！')

mapName=cga.GetMapName()
if(mapName=="艾尔莎岛"):
    cga.WalkTo(140,105)     #暂时没有A*算法寻路 所以需要10个坐标以内 写一次  还要判断到达目的地
    cga.TurnTo(141,105)     #转向  这里没有等待对话框返回 需要调用以后加一个
    cga.ClickNPCDialog(4,0) #对话选择
    
print(cga.IsConnected())

	
cga.RegisterChatMsgNotify(charCallBack)
print(cga.IsInGame())
print(cga.GetWorldStatus())
print(cga.GetGameStatus())
print(cga.GetBGMIndex())
#cga.GetWorldStatus()
#cga.GetGameStatus()
#cga.GetBGMIndex()
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
petskills=cga.GetPetSkillsInfo(0)
#print(len(petskills))
print(petskills[0].name)
#for i, k in enumerate(petskills, start=1):
#    print(k.name)
mapinfo = cga.GetMapIndex()
print(mapinfo)
print(mapinfo[0])
print(mapinfo[1])
print(mapinfo[2])
print(mapinfo[3])
mappos=cga.GetMapXY()
print(mappos)
print(mappos['x'])
print(mappos['y'])
craftInfo=cga.GetCraftInfo(0,0)
print(craftInfo.name)
print(craftInfo.info)
print(craftInfo.materials)
cga.ChangeTitleName(1)
#cga.WalkTo(145,98)
cga.SayWords("Hello World",1,2,3)
mapUnits=cga.GetMapUnits()
#print(mapUnits)
#sys.stdout.flush()
for unit in mapUnits:
	print(("%s %d %d %d") % (unit.item_name, unit.model_id, unit.xpos, unit.ypos))
	#print(unit.item_name)
#time.sleep(100)