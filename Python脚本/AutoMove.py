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
import datetime
#是否移动中
g_is_moveing=False  

#本次寻路循环次数
g_navigatorLoopCount=0 
g_mazeWaitTime=5            #5秒
#自动寻路 
#返回0 正常完成 1退出中断  2地图变更中断 3地图下载失败
def AutoMoveTo(x,y,timeout=100):
    if g_is_moveing:
        return 0
    g_navigatorLoopCount=0
    
    #如果是组队状态 并且不是队长 则退出
    return AutoMoveInternal(x, y, timeout)

#寻路内部代码   返回0 正常完成 1退出中断  2地图变更中断 3地图下载失败 
def AutoMoveInternal(x, y, timeout=100, isLoop=True):
    logging.info("目标坐标点:x:%d,y:%d" % (x,y))
    if g_navigatorLoopCount>=20:
        return 0
    curPos = cga.GetMapCoordinate()
    if curPos.x == x and curPos.y == y :
        warpPosList = GetMapEntranceList()
        if CGPoint(x=x,y=y) in warpPosList:
            logging.info("AutoMoveTo 坐标一样 目标为传送点，重新进入！")
            tmpPos = GetRandomSpace(x, y, 1)
            cga.WalkTo(tmpPos.x, tmpPos.y)
            time.sleep(2)
            cga.WalkTo(x, y)
        logging.info("AutoMoveTo 坐标一样 返回！")
        return 1
    g_is_moveing=True
    WaitInNormalState()
    isOffLineMap = False
    curPos = cga.GetMapCoordinate()
    findPath = CalculatePath(curPos.x,curPos.y,x,y)
    tRet=0
    if len(findPath) > 0 :      
        tRet=AutoNavigator(findPath,isOffLineMap, isLoop)
    else:
        logging.info("路径为空")    #可以增加离线地图寻路
    g_is_moveing=False
    return tRet
#寻路判断逻辑
def AutoNavigator(path,isSyncMap=False,isLoop=True):
    if len(path) < 1:
        return False
    global g_navigatorLoopCount
    g_navigatorLoopCount=g_navigatorLoopCount+1
    backPath = path
    curX=curY=tarX=tarY=lastX=lastY=0
    curMapIndex = GetMapIndex()
    curMapName = cga.GetMapName()
    dwTimeoutTryCount = dwCurTime = dwLastTime=0
    isNormal=True
    warpPosList=GetMapEntranceList()
    startPos=cga.GetMapCoordinate()
    if path[0].x == startPos.x and path[0].y == startPos.y:
        path=path[1:]
    for coor in path:
        if g_stop:
            break
        tarX = coor.x
        tarY = coor.y
        logging.info("目标：%d %d"%(coor.x,coor.y))
        walkprePos =cga.GetMapCoordinate()         #记录下移动前坐标
        cga.WalkTo(coor.x,coor.y)
        dwLastTime=dwTimeoutTryCount=0
        while not g_stop:
            #//1、判断战斗和切图
            while not IsInNormalState() and not g_stop: #战斗或者切图 等待完毕
                isNormal = False
                time.sleep(1)
            #//2、判断地图是否发送变更 例如：迷宫送出来，登出，切到下个图
            if (curMapIndex != GetMapIndex() or curMapName != cga.GetMapName()):
                logging.info("当前地图更改，寻路判断！")
                lastWarpMap202=0
                while (cga.GetGameStatus() == 202):
                    if lastWarpMap202==0:
                        lastWarpMap202=lastWarpMap202+1
                    elif lastWarpMap202>=5:
                        cga.FixMapWarpStuck(0)
                        lastWarpMap202=lastWarpMap202+1
                        logging.info("切换地图 卡住 fix warp")
                    time.sleep(1)
                WaitInNormalState()
                #再次判断 有些会卡回原图，这里再次判断
                if (curMapIndex == GetMapIndex() and curMapName == cga.GetMapName() and isLoop):
    				#//重新执行一次重新寻路
                    logging.info( "还在原图：重新查找路径 进行寻路")
                    tgtPos = backPath.end()
                    return AutoMoveInternal(tgtPos.x, tgtPos.y, False)
                else:				
                    logging.info("地图更改，寻路结束！")
                    if (IsInRandomMap()):
                        time.sleep(g_mazeWaitTime)
                    return False
			#调换顺序 战斗或者切图后，还在本地图，再次执行 有问题 就是同一个地图 但是是个传送点
            if not isNormal:    #刚才战斗和切图了 现在重新执行最后一次坐标点任务
                logging.info("战斗/切图等待，再次寻路！%d %d" % (tarX,tarY))
                if GetDistance(tarX, tarY) > 11:
                    logging.info("战斗/切图等待，再次寻路 距离大于11 刚才可能为传送 返回!%d %d" % (tarX,tarY))
                    curPos = cga.GetMapCoordinate()
                    findPath = CalculatePath(curPos.x, curPos.y, tarX, tarY)
                    if len(findPath) > 0 and isLoop:
                        AutoNavigator(findPath, isSyncMap, False)
                    else:
                        logging.info("战斗/切图等待，再次寻路失败！%d %d" % (tarX,tarY))
                else:
                    if not IsReachableTarget(walkprePos.x, walkprePos.y):#用移动前点判断 不能到 说明换图成功，特别是ud这个图
                        logging.info( "原坐标不可达，移动至目标点成功，寻路结束！")
                        WaitInNormalState()
                        return True
                    else:
                        cga.WalkTo(tarX,tarY)

                dwLastTime = 0
                isNormal = True
            #//3、判断是否到达目的地
            curPos = cga.GetMapCoordinate()
            if curPos.x == tarX and curPos.y == tarY:
                if CGPoint(tarX,tarY) in warpPosList:
                    logging.info("目标为传送点,判断地图切换：!%d %d" % (tarX,tarY))
                    tryNum=0
                    fixWarpTime = time.time()
                    while tryNum < 3:
                        if time.time() - fixWarpTime > 5000:
                            while (cga.GetGameStatus() == 202):
                                if lastWarpMap202==0:
                                    lastWarpMap202=lastWarpMap202+1
                                elif lastWarpMap202>=5:
                                    cga.FixMapWarpStuck(0)
                                    lastWarpMap202=lastWarpMap202+1
                                    logging.info("切换地图 卡住 fix warp")
                                time.sleep(1) 
                            WaitInNormalState()
                            tryNum=tryNum+1
                            fixWarpTime = time.time()
                            curPos = cga.GetMapCoordinate()
                            if curMapIndex != GetMapIndex() or curMapName != cga.GetMapName():
                                WaitInNormalState()
                                if IsInRandomMap():
                                    time.sleep(g_mazeWaitTime)
                                return True
                            elif curMapIndex == GetMapIndex() and curMapName != cga.GetMapName() and (curPos.x != tarX or curPos.y != tarY):
                                WaitInNormalState()
                                return True
                            elif curMapIndex == GetMapIndex() and curMapName != cga.GetMapName() and (curPos.x != tarX or curPos.y != tarY):
                                if not IsReachableTarget(walkprePos.x, walkprePos.y):#用移动前点判断 不能到 说明换图成功，特别是ud这个图
                                    logging.info( "原坐标不可达，移动至目标点成功，寻路结束！")
                                    WaitInNormalState()
                                    return True
                                logging.info( "到达目标点，目标为传送点，地图卡住，切回地图,重新寻路%d %d"%(tarX,tarY))
                                cga.FixMapWarpStuck(1)
                                curPos = cga.GetMapCoordinate()
                                if not isLoop:
                                    cga.WalkTo(tarX,tarY)
                                    return True
                                else:
                                    bTryRet= False
                                    if curPos.x == tarX and curPos.y==tarY:
                                        tmpPos=GetRandomSpace(curPos.x,curPos.y,1)
                                        AutoMoveInternal(tmpPos.x,tmpPos.y,False)
                                        bTryRet = AutoMoveInternal(tarX, tarY, False)
                                    else:
                                        bTryRet = AutoMoveInternal(tarX, tarY, False)
                                    return bTryRet
                            tryNum=tryNum+1
                        else:
                            curPos = cga.GetMapCoordinate()
                            if curMapIndex != GetMapIndex() or curMapName != cga.GetMapName():
                                WaitInNormalState()
                                if IsInRandomMap():
                                    time.sleep(g_mazeWaitTime)
                                return True
                            elif curMapIndex == GetMapIndex() and curMapName != cga.GetMapName() and (curPos.x != tarX or curPos.y != tarY):
                                WaitInNormalState()
                                return True
                        time.sleep(1)
                    if not IsReachableTarget(walkprePos.x, walkprePos.y):   #用移动前点判断 不能到 说明换图成功，特别是ud这个图
                        logging.info( "原坐标不可达，移动至目标点成功，寻路结束！")
                        WaitInNormalState()
                        return True
                    else:
                        logging.info("当前为传送点，但原坐标可达，重新移动至目标点，不判断目标点，寻路结束！%d %d"%(tarX,tarY))
                        cga.WalkTo(tarX,tarY)
                        WaitInNormalState()
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
                        WaitInNormalState()
                        curPos = cga.GetMapCoordinate()
                        findPath = CalculatePath(curPos.x, curPos.y, tarX, tarY)
                        if len(findPath) == 1 or  not isLoop:
                            cga.WalkTo(tarX,tarY)
                        elif len(findPath) > 1 and isLoop:
                            if AutoMoveInternal(tarX,tarY,False) == False:
                                return False
                            dwLastTime=dwCurTime                            
                        else:
                            logging.info("目标不可达，返回！！%d %d" % (tarX,tarY))
                            return False
            lastX = curPos.x
            lastY = curPos.y
            time.sleep(0.01)
    WaitInNormalState()
    return True


                                













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
