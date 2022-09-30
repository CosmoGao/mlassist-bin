#封装一些功能函数
import CGAPython
import time
import sys
import os
import math
from cga_wait_api import *
from cgaapi import *
from common import *


    
#喜闻乐见的开图环节到了
#原理步骤
#1、判断当前地图是不是迷宫类型，不是迷宫不开图
#2、获取当前地图数据，如果有2个以上迷宫出入口，并且两个迷宫出入口，都可以寻路过去，就算开图成功（不判断出入口哪个是下一层，默认）
#3、


def 取地图可移动点集合(start):
    foundedPoints=[]
    tMap=cga.GetMapCollisionTable(True)
    if tMap.x_size >= 300 or tMap.y_size >=300:
        日志("地图大于300，不进行探索")
        return 
#-- 

# #搜索迷宫
# def SearchAroundMapOpen(allMoveAblePosList,type):
    # if cga.GetMapIndex()[0]==0:
        # 日志("当前是固定地图，不进行地图全开！")
        # return False
    # curPox=取当前坐标()
	# #获取当前所有可行走区域坐标
	# auto moveAblePosList = GetMovablePoints(curPos);
	# if (moveAblePosList.size() < 1)
		# return false;
	# auto moveAbleRangePosList = GetMovablePointsEx(curPos, 13);
	# auto clipMoveAblePosList = GetMovablePointsEx(curPos, 12);
	# QList<QPoint> newMoveAblePosList = moveAbleRangePosList;
	# //这是筛出的4方向边界点
	# for (int i = 0; i < clipMoveAblePosList.size(); ++i)
	# {
		# newMoveAblePosList.removeOne(clipMoveAblePosList[i]);
	# }
	# //增加判断，当前过滤的边界点，是否有以前探索的，有的话就移除那个方向的点
	# QList<QPoint> filterMoveAblePosList = newMoveAblePosList;
	# for (auto tPos : newMoveAblePosList)
	# {
		# qDebug() << tPos;
		# //AutoMoveTo(tPos.x(),tPos.y());
		# if (allMoveAblePosList.contains(tPos))
			# filterMoveAblePosList.removeOne(tPos);
	# }
	# //合并各自方向边界点
	# auto tSearchList = MergePoint(filterMoveAblePosList);
	# if (tSearchList.size() > 0)
	# {

		# //找当前最近的没搜寻点
		# qSort(tSearchList.begin(), tSearchList.end(), [&](TSearchRectPtr a, TSearchRectPtr b)
				# {
					# auto ad = GetDistanceEx(curPos.x(), curPos.y(), a->_centrePos.x(), a->_centrePos.y());
					# auto bd = GetDistanceEx(curPos.x(), curPos.y(), b->_centrePos.x(), b->_centrePos.y());
					# return ad < bd;
				# });
		# allMoveAblePosList += clipMoveAblePosList;
		# for (auto tSearchPos : tSearchList)
		# {
			# //auto tSearchPos = tSearchList[0];
			# AutoMoveTo(tSearchPos->_centrePos.x(), tSearchPos->_centrePos.y());
			# Sleep(m_mazeSearchWaitTime);	//到达目标点 等待时间，用来防止到达点后，地图没有更新过来
			# if (type == 1)
			# {
				# if (SearchAroundMapOpen(allMoveAblePosList, type))
					# return true;
			# }
			# else if (type == 2)
			# {
				# auto entranceList = GetMazeEntranceList();
				# if (entranceList.size() >= 2)
				# {
					# bool bReachable = true;
					# for (auto tEntrance : entranceList)
					# {
						# if (!IsReachableTarget(tEntrance.x(), tEntrance.y()))
						# {
							# bReachable = false;
							# break;
						# }
					# }
					# CheckUploadMapData();
					# if (bReachable) //两个出入口可达 退出 否则继续搜索
						# return true;
				# }
				# if (SearchAroundMapOpen(allMoveAblePosList, type))
					# return true;
			# }
		# }
	# }
    # return False
    
# def distanceSortFun(tpos1,tpos2):
    # ad=计算两点距离(curPox.x,curPox.y,tpos1.x,tpos1.y)
    # bd=计算两点距离(curPox.x,curPox.y,tpos2.x,tpos2.y)
    # return ad < bd
def distanceSortFun(tpos1):
    return 计算两点距离(curPox.x,curPox.y,tpos1.x,tpos1.y) 

    
def AutoWalkMaze(isFarGate=True):
    if cga.GetMapIndex()[0]==0:
        日志("固定地图不开图")
        return False
    #进入下一层时候，有时候地图会卡主，转向两下，触发地图刷新
    转向(0)
    转向(2)
    mapInfo=cga.GetMapCollisionTable(True)
    日志(("X_b:%d , y_b:%d x_size:%d  y_size:%d filename:%s") % (mapInfo.x_bottom,mapInfo.y_bottom,mapInfo.x_size,mapInfo.y_size,mapInfo.filename))
    if mapInfo.x_size==0 or mapInfo.y_size==0:
        日志("获取地图数据失败，等待5秒重试")
        time.sleep(5)
        mapInfo=cga.GetMapCollisionTable(True)   
        if mapInfo.x_size==0 or mapInfo.y_size==0:
            日志("获取地图数据失败，返回")
            return False
    if mapInfo.x_size >= 300 or mapInfo.y_size >= 300:
        日志("地图大于300，不进行迷宫探索")
        return False
    curPox=取当前坐标()
    gateList=取所有迷宫入口()
    
    #1、如果有两个出入口，并且都可以到达，则此判断会返回，否则继续下一步
    if len(gateList) >= 2:
        bReachable=True
        for tPos in gateList:
            if 目标是否可达(tPos.x,tPos.y) == False:
                bReachable=False
                break
        if bReachable:
            #上传同步地图，这步python暂时没有，过掉
            sorted(gateList,cmp=distanceSortFun)
            if isFarGate:   #取远处迷宫
                自动寻路(gateList[1].x,gateList[1].y)                
            else:
                自动寻路(gateList[0].x,gateList[0].y)
            return True
    
    #2、此步可以增加同步地图功能，从服务器下载地图，进行寻路，这里暂时跳过
    
    #3、没有两个出入口，开始搜索迷宫
    allMoveAblePosList=[]
    #SearchAroundMapOpen(allMoveAblePosList, 2);
    inPos=CGPoint(x=0,y=0)
    if len(gateList) >= 1:
        inPos = gateList[0]	
    gateList = 取所有迷宫入口();
    nextPos=CGPoint(x=0,y=0)
    for tPos in gateList:	
        if (tPos.x != inPos.x or tPos.y !=inPos.y):		
            nextPos = tPos
            自动寻路(nextPos.x, nextPos.y)
            return True			
	#最后一层需要加个查找黑色区域，然后找附加坐标去开图
    return False
    
def 计算两点距离(x,y,tx,ty):
    if x==tx and y==ty:
        return 0
    return math.sqrt(math.pow(math.fabs(x-tx),2) + math.pow(math.fabs(y-ty),2))

gateList=取所有迷宫入口()
日志("大小%d"%(len(gateList)))
curPox=取当前坐标()
for tPos in gateList:
    日志("x:%d y:%d"%(tPos[0],tPos[1]))
    日志("x:%d y:%d"%(tPos.x,tPos.y))
    tDistance = 计算两点距离(curPox.x,curPox.y,tPos.x,tPos.y)
    日志("当前坐标：x:%d y:%d 目标坐标:x:%d y:%d 距离：%d"%(curPox.x,curPox.y,tPos.x,tPos.y,tDistance))
    #日志("x:%d y:%d"%(tPos["x"],tPos["y"]))
sorted(gateList,key=distanceSortFun,reverse=False)
for tPos in gateList:
    日志("x:%d y:%d"%(tPos[0],tPos[1]))
    日志("x:%d y:%d"%(tPos.x,tPos.y))
    tDistance = 计算两点距离(curPox.x,curPox.y,tPos.x,tPos.y)
    日志("当前坐标：x:%d y:%d 目标坐标:x:%d y:%d 距离：%d"%(curPox.x,curPox.y,tPos.x,tPos.y,tDistance))
#AutoWalkMaze()