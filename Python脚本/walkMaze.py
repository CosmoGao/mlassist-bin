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

    
#喜闻乐见的开图环节到了
#原理步骤
#1、判断当前地图是不是迷宫类型，不是迷宫不开图
#2、获取当前地图数据，如果有2个以上迷宫出入口，并且两个迷宫出入口，都可以寻路过去，就算开图成功（不判断出入口哪个是下一层，默认）
#3、

class TRect:
    def __init__(self,x=0,y=0,width=0,height=0):
        self._x=x
        self._y=y
        self._width=width
        self._height=height
   
    def contains(self, pos):
        if pos.x >= self.x and pos.x <= (self.x + self._width) and pos.y >= self.y and pos.y <= (self.y + self._height):
            return True
        return False
    def x(self):
        return self._x
    def y(self):
        return self._y
    def width(self):
        return self._width
    def height(self):
        return self._height
        
    

class TSearchRect:
    def __init__(self, centerPos, rect):
        self._rect = rect
        self._centerPos = centerPos
    def rect():
        return self._rect
    def centerPos():
        return self._centerPos
        


#合并中心点 posList需要合并的点集合  nDis合并范围，默认值10
def MergePoint(posList, nDis= 10):
	if len(posList) < 1):
		return []	
	alreadyPosList=[] #已经合并过的坐标集合
	tmpPosList = copy.deepcopy(posList)
	searchRectPosList=[]    #以10为半径的所有矩形的中心点的集合
	#依次取坐标
	while len(tmpPosList) > 0:
		centrePos = tmpPosList.pop(0)		
		if centrePos in alreadyPosList:
			continue
		'''if (g_pGameCtrl->GetExitGame() || g_pGameFun->m_bStop)
		{
			qDebug() << "已停止搜索 MergePoint";
			return searchRectPosList;
		}'''
		leftPos = CGPoint(centrePos.x-10,centrePos.y - 10)
		rightPos = CGPoint(centrePos.x+10,centrePos.y + 10)
		TRect tmpRect(leftPos, rightPos);
		alreadyPosList.push_back(centrePos)

		TSearchRectPtr tSearchPtr(new TSearchRect)
		tSearchPtr->_rect = tmpRect
		tSearchPtr->_centrePos = centrePos
		tSearchPtr->_rectPosList.append(centrePos)		
		searchRectPosList.append(tSearchPtr)

		auto lastPosList = tmpPosList;
		for (QPoint tmpRectPos : lastPosList)
		{
			if (alreadyPosList.contains(tmpRectPos))
				continue;
			if (tmpRectPos == QPoint(52, 8))
				qDebug() << "52,8";
			if (tmpRect.contains(tmpRectPos))
			{
				tmpPosList.removeOne(tmpRectPos);
				alreadyPosList.push_back(tmpRectPos);
				tSearchPtr->_rectPosList.append(tmpRectPos);
				if (tmpRectPos == QPoint(52, 8))
				{
					qDebug() << "52,8" << tSearchPtr->_centrePos.x() << tSearchPtr->_centrePos.y() << tSearchPtr->_rect.topLeft() << tSearchPtr->_rect.bottomRight();
				}
				//				tSearchPtr->_cvRectPosList.push_back(cv::Point(tmpRectPos.x(), tmpRectPos.y()));
			}
		}
	}
	return searchRectPosList;


#从CGPoint集合中是否包含指定点
#返回 True False
def IsContainCGPoint(points,point):
    for tPos in points:	
        if tPos.x == point.x and tPos.y ==point.y:		
            return True
    return False
            

#判断坐标点是否可行走
def IsMoveAble(mapCell,gamePos,foundedPoints,nextPoints,tRect):
    if gamePos.x > tRect.x and gamePos.x < tRect.width and gamePos.y > tRect.y and gamePos.y < tRect.height:
        if mapCell.cell[gamePos.x+gamePos.y*mapCell.x_size] == 0:
            if not IsContainCGPoint(foundedPoints,gamePos):
                foundedPoints.append(gamePos)                
                nextPoints.append(gamePos)               
    


#地图数据 中心点 已搜过点 地图大小 范围
def FindByNextPoints(mapCell,tmpCenter,foundedPoints,tRect):
    nextPoints=[]
    #四个方向遍历点
    IsMoveAble(mapCell,CGPoint(x=tmpCenter.x+1,y=tmpCenter.y),foundedPoints,nextPoints,tRect)
    IsMoveAble(mapCell,CGPoint(x=tmpCenter.x,y=tmpCenter.y+1),foundedPoints,nextPoints,tRect)
    IsMoveAble(mapCell,CGPoint(x=tmpCenter.x-1,y=tmpCenter.y),foundedPoints,nextPoints,tRect)
    IsMoveAble(mapCell,CGPoint(x=tmpCenter.x,y=tmpCenter.y-1),foundedPoints,nextPoints,tRect)
    for tmpPos in nextPoints:
        FindByNextPoints(mapCell,tmpPos,foundedPoints,tRect)

#获取坐标限定范围内可移动点
def GetMovablePointsEx(start,tRange):
    foundedPoints=[]
    mapInfo=cga.GetMapCollisionTable(True)
    minx=start.x - tRange
    miny=start.y - tRange
    maxx=start.x + tRange
    maxy=start.y + tRange
    if minx < mapInfo.x_bottom:
        minx = mapInfo.x_bottom
    if miny < mapInfo.y_bottom:
        miny = mapInfo.y_bottom
    if maxx > mapInfo.x_size:
        minx = mapInfo.x_size
    if maxy < mapInfo.y_size:
        maxy = mapInfo.y_size
    tRect=CGRect(x=minx,y=miny,width=maxx,height=maxy)
    FindByNextPoints(mapInfo, start, foundedPoints, tRect)
    return foundedPoints
    
    

def 取地图可移动点集合(start):
    foundedPoints=[]
    tMap=cga.GetMapCollisionTable(True)
    if tMap.x_size >= 300 or tMap.y_size >=300:
        日志("地图大于300，不进行探索")
        return 
    tRect=CGRect(x=tMap.x_bottom,y=tMap.y_bottom,width=tMap.x_size,height=tMap.y_size)
    日志("范围：%d %d %d %d"%(tRect.x,tRect.y,tRect.width,tRect.height))
    FindByNextPoints(tMap, start, foundedPoints,tRect);
    return foundedPoints
#-- 

# #搜索迷宫 
#allMoveAblePosList经过的点
#searchType 搜索类型 物品 npc 
def SearchAroundMapOpen(allMoveAblePosList,searchType):
    if cga.GetMapIndex()[0]==0:
        日志("当前是固定地图，不进行地图全开！")
        return False
    curPox=取当前坐标()
	#获取当前所有可行走区域坐标
    moveAblePosList = 取地图可移动点集合(curPos)
    if (moveAblePosList.size() < 1):
        return false;
    #筛选搜索点,分别取13和12范围内可行走点，相减即为最外层可走点
    moveAbleRangePosList = GetMovablePointsEx(curPos, 13)
    clipMoveAblePosList = GetMovablePointsEx(curPos, 12)
    newMoveAblePosList = copy.deepcopy(moveAbleRangePosList)    
	#这是筛出的4方向边界点    
    for i in clipMoveAblePosList:
        newMoveAblePosList.remove(i)	
	# 增加判断，当前过滤的边界点，是否有以前探索的，有的话就移除那个方向的点
    filterMoveAblePosList = copy.deepcopy(newMoveAblePosList)
    for tPos in newMoveAblePosList:
        if tPos in allMoveAblePosList:
            filterMoveAblePosList.remove(tPos)
	
	# //合并各自方向边界点
	tSearchList = MergePoint(filterMoveAblePosList)
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
    SearchAroundMapOpen(allMoveAblePosList, 2);
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

'''
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
ableMovePos=取地图可移动点集合(curPox)
日志("可移动点集合")
for tPos in ableMovePos:
    日志("x:%d y:%d"%(tPos.x,tPos.y))
'''
AutoWalkMaze()


'''
moveAbleRangePosList = [CGPoint(x=1,y=1),CGPoint(x=1,y=2),CGPoint(x=1,y=3)]
clipMoveAblePosList = [CGPoint(x=1,y=1),CGPoint(x=1,y=2)]
newMoveAblePosList = moveAbleRangePosList
for i in newMoveAblePosList:
     日志("筛选前点-：%d %d" %(i.x,i.y))
for i in clipMoveAblePosList:
    日志("筛选前点：%d %d" %(i.x,i.y))
    newMoveAblePosList.remove(i)
for i in newMoveAblePosList:
    日志("筛选后点：%d %d" %(i.x,i.y))
    
for i in clipMoveAblePosList:
     日志("判断点：%d %d" %(i.x,i.y))
     if moveAbleRangePosList.find(i) >= 0:
        日志("点在集合中")
'''