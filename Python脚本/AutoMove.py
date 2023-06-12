#封装一些功能函数
import CGAPython
import time
import sys
import os
import math
from cga_wait_api import *
from cgaapi import *
from common import *
import copy
from functools import singledispatch,singledispatchmethod 
from enum import Enum
from AStar import *
#是否移动中
IS_MOVE_ING=False  

#本次寻路循环次数
NavigatorLoopCount=0 
 
#自动寻路 
#返回0 正常完成 1退出中断  2地图变更中断 3地图下载失败
def AutoMoveTo(x,y,timeout=100):
    if IS_MOVE_ING:
        return 0
    NavigatorLoopCount=0
    
    #如果是组队状态 并且不是队长 则退出
    return AutoMoveInternal(x, y, timeout)

#寻路内部代码    
def AutoMoveInternal(x, y, timeout=100, isLoop=True):
    logging.info("目标坐标点:x:%d,y:%d" % (x,y))
    if NavigatorLoopCount>=20:
        return 0
    curPos = cga.GetMapCoordinate()
    findPath = CalculatePath(curPos.x,curPos.y,x,y)
    if len(findPath) > 0 :
        for tPos in findPath:
            logging.info("x:%d,y:%d" %(tPos.x,tPos.y))
            cga.AutoMoveTo(tPos.x,tPos.y)
    else:
        logging.info("路径为空")

#通过A*算法，查找当前点到目标点的路径
def CalculatePath(curX, curY, targetX, targetY):
    logging.info("计算路径")
    cells=cga.GetMapCollisionTable(True)
    objCells=cga.GetMapObjectTable(True)
    if cells.x_size ==0 and cells.y_size == 0:
        return []
    logging.info("地图大小:%d %d"%(cells.x_size,cells.y_size))
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
    logging.info("构造AStart Fini")						
    frompos=PathPoint(curX - cells.x_bottom, curY - cells.y_bottom)
    topos=PathPoint(targetX - cells.x_bottom, targetY - cells.y_bottom)
    logging.info("起点:x:%d,y:%d 终点:x:%d,y:%d" % (frompos.x, frompos.y, topos.x, topos.y))
    path = aStarFindPath.FindPath(frompos.x, frompos.y, topos.x, topos.y, grid)  
    #return path 
    findPath = AStarUtil.compressPath(path)		   
    return findPath
