#封装一些功能函数
import CGAPython
import time
import sys
import os
from cga_wait_api import *
from cgaapi import *
from collections import namedtuple
from AutoMove import *

#封装元组，便于访问
CGPoint = namedtuple("CGPoint","x,y")
CGRect = namedtuple("CGRect","x,y,width,height")

    
    
def 转向(nDir):  
    mappos=cga.GetMapCoordinate()
    x=mappos.x
    y=mappos.y
    if(nDir==0):
        x = x;
        y = y - 2;
    elif(nDir==1):
        x = x + 2;
        y = y - 2;  
    elif(nDir==2):
        x = x + 2;
        y = y;  
    elif(nDir==3):
        x = x + 2;
        y = y + 2;
    elif(nDir==4):
        x = x;
        y = y + 2;
    elif(nDir==5):
        x = x - 2;
        y = y + 2;
    elif(nDir==6):
        x = x - 2;
        y = y;
    elif(nDir==7):
       	x = x - 2;
        y = y - 2;	
    cga.TurnTo(x, y)
    
#转换预定放行到CGA方向
def TransDirectionToCga(nDir):
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
#把CGA原始API包装成中文，除了个别包装的函数，其他参数不变
对话选择 = cga.ClickNPCDialog
取当前地图名 = cga.GetMapName
取当前坐标 = cga.GetMapCoordinate
自动寻路 = cga.AutoMoveTo
转向坐标 = cga.TurnTo
喊话 = cga.SayWords
取所有技能信息 = cga.GetSkillsInfo
穿墙=cga.ForceMoveTo
切图=cga.ForceMoveTo

def 取当前地图编号():          #包装下 原生是返回4个值  这里只拿地图编号
    return cga.GetMapIndex()[2]


#API 穿墙方向，步数，是否显示
def 方向穿墙(nDir,distance=1,bShow=False):
    cgaDir = TransDirectionToCga(nDir)
    while distance > 0:
        cga.ForceMove(cgaDir,bShow)
        time.sleep(0.5)
        等待空闲()
        distance=distance-1
    
def 日志(log,ntype=0):
    if ntype == 0:
        logging.info(log)
    elif ntype==1:
        cga.SayWords(log,2,3,5)

def 取技能信息(name):
    skills = cga.GetSkillsInfo()   
    for skill in skills:
        if skill.name == name:
            return skill
    return None
    


def 等待到指定地图(name,x,y):
    curMapName = 取当前地图名()
    curPoint = 取当前坐标()
    timeout = 60
    for i in range(timeout):
        curMapName = 取当前地图名()
        curPoint = 取当前坐标()
        if curMapName == sName and curPoint.x == x and curPoint.y == y:
            return True		
        time.sleep(1)
    return False
    
def 工作(name,itemName="",timeout=6500):
    skills = cga.GetSkillsInfo()
    index=-1
    for skill in skills:
        if skill.name == name:
            index=skill.index
            break
    if index<0:
        日志("没有【"+name+"】技能")
        return False
    cga.StartWork(index,0)
    
def 是否空闲():
    if cga.GetWorldStatus() == 9 and cga.GetGameStatus() == 3:
        return True 
    else: 
        return False
    
def 等待空闲(timeout):
    if timeout == 0:
        timeout = 600    
    timeoutNum = timeout #10分钟 600秒 每次Sleep 1秒
    for i in range(timeoutNum):
        if 是否空闲():
            return True
        time.sleep(1)
    return False
    
def 取所有迷宫入口():
    gateList=[]
    cells=cga.GetMapCollisionTable(True)
    objCells=cga.GetMapObjectTable(True)
    if cells.x_size ==0 and cells.y_size == 0:
        return gateList
    for y in range(cells.y_size):
        for x in range(cells.x_size):
            if x < objCells.x_size and y < objCells.y_size:
                celObj = objCells.cell[x+y*objCells.x_size]
                #日志("%d"%(celObj))
                if celObj & 0xff:
                    #日志("%d"%(celObj))
                    if celObj & 0xff == 3:   #蓝色 迷宫传送点
                        日志("x:%d y:%d %d"%(x,y,celObj))
                        #gateList.append({x:x,y:y}) 
                        #gateList.append({"x":x,"y":y})  
                        gateList.append(CGPoint(x=x,y=y))
                        #gateList.append((x,y))  
                        
                    else:       
                        pass                            #绿色 切换坐标点 传送门
            
    
    return gateList
#寻路时候，判断目标坐标点是否能到达
#返回True False
def 目标是否可达(tx,ty):
    return True

    
#def 开始遇敌():
    


#def 取包裹空格():
    

    
