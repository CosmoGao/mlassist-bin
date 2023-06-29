#封装一些功能函数
import time
import sys
import os
import math
import copy
from functools import singledispatch,singledispatchmethod 
from enum import Enum
from functools import cmp_to_key
from collections import namedtuple
import logging

#日志格式
LOG_FORMAT = "%(asctime)s %(message)s"
#配置日志
logging.basicConfig(level=logging.DEBUG, format=LOG_FORMAT,datefmt='%Y-%m-%d %H:%M:%S')

#封装元组，便于访问
PathPoint = namedtuple("PathPoint","x,y")

#枚举 障碍设置
class DiagonalMovement(Enum):
    IsNone=0
    Always = 1
    Never = 2
    IfAtMostOneObstacle = 3
    OnlyWhenNoObstacles = 4

#寻路算法
class AStar():
    #类构造函数
    def __init__(self,bAllowDiagonal=False,bDontCrossCorners=False):
        self._bAllowDiagonal=bAllowDiagonal
        self._bDontCrossCorners=bDontCrossCorners
        #logging.info("_bAllowDiagonal=%d,_bDontCrossCorners=%d" % (self._bAllowDiagonal,self._bDontCrossCorners))
        self._nWeight=1.0
        self._nDiagonalMovement=DiagonalMovement.IsNone
        self.m_pFun=AStarUtil.manhattan

        if self._nDiagonalMovement==DiagonalMovement.IsNone:
            if self._bAllowDiagonal==False:
                self._nDiagonalMovement=DiagonalMovement.Never
            else:
                if self._bDontCrossCorners:
                    self._nDiagonalMovement=DiagonalMovement.OnlyWhenNoObstacles
                else:
                    self._nDiagonalMovement=DiagonalMovement.IfAtMostOneObstacle
        if self._nDiagonalMovement==DiagonalMovement.Never:
            self.m_pFun=AStarUtil.manhattan
            logging.info("pFun manhattan")
        else:
            self.m_pFun=AStarUtil.octile
    #比较函数，注意，不要返回True False，python的0 认为不交换 False是0
    def GreaterSort(nodeA,nodeB):
        if nodeA == None or nodeB == None:
            return False
        #logging.info("GreaterSort：%d , %d" % (nodeA.f,nodeB.f))
        return -1 if nodeA.f > nodeB.f else 1       

    def FindPath(self,startX, startY, endX, endY, grid):
        openList=[]
        startNode=grid.GetNodeAt(startX, startY)
        endNode = grid.GetNodeAt(endX, endY)
        if startNode==None or endNode==None:
            return []
        neighbors=[]
        neighbor=None
        x=y=0
        ng=0.0
        tmpPath=[]
        startNode.g = 0.0
        startNode.f = 0.0

        # push the start node into the open list
        openList.append(startNode)
        startNode.opened = True
        node=None
        # 从起点开始遍历
        while len(openList) > 0:                    
            node=openList.pop()
            node.closed = True		    #标记已经计算过       
            if (node == endNode):		#如果已经到了终点，回溯路线并返回  并回溯最佳路线
                return AStarUtil.backTrace(endNode)

            #获取当前坐标周围的坐标
            neighbors = grid.GetNeighbors(node, self._nDiagonalMovement)           
            for i in range(len(neighbors)):     #遍历附近的节点 
                neighbor = neighbors[i]
                if (neighbor.closed):	        #已经走过  已经结算过的就忽略了
                    continue

                x = neighbor.x
                y = neighbor.y

                #获取当前节点和周围节点的距离 g(n), 实际距离, 实际上是 Euclidean distance
                #计算代价
                if (x - node.x ==  0 or y - node.y == 0):
                    ng = node.g + 1                     #左右上下 消耗代价1
                else:   
                    ng = node.g +  math.sqrt(2)         #斜角线   消耗代价 1.4

                # 检查周围的节点 最小代价
                # 可达目标 挑选其中最小代价
                # 两种情况需要计算:
                # 1. 这是一个新的节点
                # 2. 这个节点当前计算的 g(n) 更优
                if (not neighbor.opened or ng < neighbor.g):    #没有搜寻过 并且记录的代价小于此代价
                    neighbor.g = ng					            #从起点到这里的目标得分 goal score 更新到当前节点的得分
                    # h = 权重 * 启发函数的计算结果				
                    if neighbor.h > 0:                          #预计要付出的代价大于0 则不处理    
                        neighbor.h = neighbor.h
                    else:
                        neighbor.h = self._nWeight * self.m_pFun(abs(x - endX), abs(y - endY))  #预计要付出的代价小于0 说明没加入计算过 调用权重算临近点和目标点的值
                    neighbor.f = neighbor.g + neighbor.h        #总共付出代价=已经付出的代价 + 预计要付出的代价
                    neighbor.parent = node                      #到父节点的链接, 方便结果回溯

                    # 更新到结果集
                    if (not neighbor.opened):
                        neighbor.opened = True;		#判断条件 已经加入过寻路列表
                        openList.append(neighbor)               #加入开放列表 下次去搜索当前节点的附近节点
                        openList.sort(key=cmp_to_key(AStar.GreaterSort)) #根据节点的总代价 排序结果                        
                    else:                     
                        openList.sort(key=cmp_to_key(AStar.GreaterSort)) 
        #没有找到路径
        return []

#迷宫地图
class AStarGrid():
    #构造函数
    def __init__(self,width,height) -> None:
        self.m_rowCount=height
        self.m_columnCount=width
        self.m_pChildNode=[]
        self.buildNodes(width,height)       
        pass
    
    #设置迷宫地图大小
    def SetGridWH(self,width,height):
        self.m_pChildNode.clear()
        self.m_rowCount=height
        self.m_columnCount=width
        self.buildNodes(width,height)   

    #清除迷宫节点数据
    def ClearNodes(self):
        self.m_pChildNode.clear()

    #重置迷宫节点状态
    def ResetNodeState(self):
        for pNode in self.m_pChildNode:
            pNode.f=0.0
            pNode.g = 0.0
            pNode.h = 0.0
            pNode.opened = False
            pNode.closed = False
            pNode.parent = None

    #计算坐标存储的index
    def ChildIndex(self,x,y):
        if (x < 0) or (y < 0) or (x >= self.ColumnCount()) or (y >= self.RowCount()):
            return -1
        return (y * self.ColumnCount()) + x

    #取迷宫地图指定坐标的节点
    def GetNodeAt(self,x,y):
        index = self.ChildIndex(x,y)
        if index == -1:
            return None
        return self.m_pChildNode[index]
        
    #迷宫地图坐标是否可通行
    def IsWalkableAt(self,x,y):
        return self.IsInside(x, y) and self.GetNodeAt(x, y).IsWalkAble()

    #坐标是否在迷宫范围内
    def IsInside(self,x,y):
        return (x >= 0 and x < self.m_columnCount) and (y >= 0 and y < self.m_rowCount)

    #设置节点是否可通行
    def SetWalkableAt(self,x,y,walkable):
        pNode=self.GetNodeAt(x,y)
        if pNode!=None:
            pNode.SetWalkAble(walkable)
    
    #获取节点周围节点
    def GetNeighbors(self,node,nDiagonalMovement):
        neighbors=[]
        x = node.x
        y = node.y
        s0 = s1 = s2 = s3 = d0 = d1 = d2 = d3 = False		
        #↑
        if self.IsWalkableAt(x, y - 1):
            neighbors.append(self.GetNodeAt(x, y - 1))
            s0 = True
	    #→
        if self.IsWalkableAt(x + 1, y):
            neighbors.append(self.GetNodeAt(x + 1, y))
            s1 = True
        
        # ↓
        if self.IsWalkableAt(x, y + 1):
            neighbors.append(self.GetNodeAt(x, y + 1))
            s2 = True
 
        # ←
        if (self.IsWalkableAt(x - 1, y)):
            neighbors.append(self.GetNodeAt(x - 1, y))
            s3 = True

        if nDiagonalMovement == DiagonalMovement.Never:
            return neighbors

        if nDiagonalMovement == DiagonalMovement.OnlyWhenNoObstacles:
            d0 = s3 and s0 #←和↑能穿越 则可以↖
            d1 = s0 and s1
            d2 = s1 and s2
            d3 = s2 and s3
        elif nDiagonalMovement == DiagonalMovement.IfAtMostOneObstacle:
            d0 = s3 or s0
            d1 = s0 or s1
            d2 = s1 or s2
            d3 = s2 or s3
        elif nDiagonalMovement == DiagonalMovement.Always:
            d0 = True
            d1 = True
            d2 = True
            d3 = True
        else:
            pass#raise ValueError('Incorrect value of diagonalMovement')

        # ↖
        if (d0 and self.IsWalkableAt(x - 1, y - 1)):
            neighbors.append(self.GetNodeAt(x - 1, y - 1))
        # ↗
        if (d1 and self.IsWalkableAt(x + 1, y - 1)):
            neighbors.append(self.GetNodeAt(x + 1, y - 1))
        # ↘
        if (d2 and self.IsWalkableAt(x + 1, y + 1)):
            neighbors.append(self.GetNodeAt(x + 1, y + 1))
        # ↙
        if (d3 and self.IsWalkableAt(x - 1, y + 1)):
            neighbors.append(self.GetNodeAt(x - 1, y + 1))
        return neighbors

    #获取迷宫高度
    def RowCount(self):
        return self.m_rowCount

    #获取迷宫宽度
    def ColumnCount(self):
        return self.m_columnCount

    #创建迷宫地图节点
    def buildNodes(self,width,height):
        for i in range(height):     #高就是表格的行
            for j in range(width):  #宽就是表格的列
                pNode = AStarNode(j,i)
                self.m_pChildNode.append(pNode)


#地图坐标点以及附带属性
class AStarNode():
    def __init__(self,x,y,walkAble=False) -> None:
        self.bWalkAble=walkAble
        self.parent=None
        self.f = 0.0	
        self.g = 0.0          #已经付出的代价
        self.h = 0.0		    #预计要付出的代价
        self.opened = False #开放
        self.closed = False #关闭
        self.x = x          #x坐标
        self.y = y          #y坐标
       
    #是否可通行
    def IsWalkAble(self):
        return self.bWalkAble

    #设置是否可通行
    def SetWalkAble(self,bAble):
        self.bWalkAble=bAble

class AStarUtil():
    def __init__(self) -> None:
        pass
    
    #曼哈顿
    def manhattan(dx,dy):
        return dx + dy

    def euclidean(dx,dy):
        return math.sqrt(dx * dx + dy * dy)

    def octile(dx,dy):
        F = math.sqrt(2) - 1
        return F * dx + dy if  (dx < dy) else F * dy + dx
        #tVal =  F * dx + dy if  (dx < dy) else F * dy + dx
        # tVal=0
        # if dx < dy:
        #     tVal = F * dx + dy
        # else:
        #     tVal = F * dy + dx
        # logging.info("x:%d,y%d,Val:%d" % (dx,dy,tVal))
        # return tVal

    def chebyshev(dx,dy):
        return math.max(dx, dy)

    #回溯节点
    def backTrace(node:AStarNode):
        path=[]
        path.append(PathPoint(x=node.x, y=node.y))
        while node.parent != None:         
            node = node.parent
            path.append(PathPoint(x=node.x, y=node.y))             
        return list(reversed(path))
    
    #拼接回溯路径
    def biBacktrace(nodeA,nodeB):
        pathA = AStarUtil.backTrace(nodeA)
        pathB = AStarUtil.backTrace(nodeB)
        pathB.reverse()
        pathA.extend(pathB)
        return pathA

    #计算路径距离值
    def pathLength(path):
        sum = 0 
        for i in range(1,len(path)):
            a = path[i - 1]
            b = path[i]
            dx = a.x - b.x
            dy = a.y - b.y
            sum += math.sqrt(dx * dx + dy * dy)      
        return sum

    #插值
    def interpolate(x0,y0,x1,y1):
        line=[]       

        dx = abs(x1 - x0)
        dy = abs(y1 - y0)

        sx = 1 if x0 < x1 else -1
        sy = 1 if y0 < y1 else -1

        err = dx - dy

        while True:
            line.append(PathPoint(x0, y0))
            if x0 == x1 and y0 == y1:            
                break
            e2 = 2 * err
            if (e2 > -dy): 
                err = err - dy
                x0 = x0 + sx            
            if (e2 < dx):
                err = err + dx
                y0 = y0 + sy            
        return line

    #扩展路径
    def expandPath(path):
        expanded=[]
        pathLen = len(path)        
        interpolated=[]       
        if (pathLen < 2):        
            return expanded      

        for i in range (pathLen-1):       
            coord0 = path[i]
            coord1 = path[i + 1]

            interpolated = AStarUtil.interpolate(coord0.x, coord0.y, coord1.x, coord1.y)
            interpolatedLen = len(interpolated)
            for j  in range(interpolatedLen - 1) : 
                expanded.push_back(interpolated[j])    
        
        expanded.append(path[len - 1])
        return expanded

    #平滑路径
    def smoothenPath(grid:AStarGrid,path):
        pathLen = len(path)
        if (pathLen < 2):
            return []       
        x0 = path[0].x        # path start x
        y0 = path[0].y        # path start y
        x1 = path[len - 1].x  # path end x
        y1 = path[len - 1].y  # path end y
        #	sx, sy,                 # current start coordinate
        #    ex, ey;                 # current end coordinate
        newPath=[]      
        line=[]
        blocked = False
        sx = x0
        sy = y0
        newPath.append({"x":sx, "y":sy})

        for i in range(2,pathLen): 
            coord = path[i]
            ex = coord.x
            ey = coord.y
            line = AStarUtil.interpolate(sx, sy, ex, ey)
            blocked = False
            for j in range(1,len(line)):
                testCoord = line[j]
                if (not grid.IsWalkableAt(testCoord[x], testCoord[y])):
                    blocked = True
                    break
                
            
            if (blocked): 
                lastValidCoord = path[i - 1]
                newPath.append(lastValidCoord)
                sx = lastValidCoord.x
                sy = lastValidCoord.y
        newPath.append({"x":x1,"y":y1})
        return newPath

    #压缩路径
    def compressPath(path):
        if (len(path) < 3): 
            return path
        compressed=[]
        sx = path[0].x      # start x
        sy = path[0].y      # start y
        px = path[1].x  # second point x
        py = path[1].y  # second point y
        dx = px - sx    # direction between the two points
        dy = py - sy    # direction between the two points

        sq = math.sqrt(dx * dx + dy * dy)
        dx /= sq
        dy /= sq

        # start the new path
        compressed.append(PathPoint(sx,sy))

        for i in range(2,len(path)):
            # store the last point
            lx = px
            ly = py

            # store the last direction
            ldx = dx
            ldy = dy

            # next point
            px = path[i].x
            py = path[i].y

            # next direction
            xDis = dx = px - lx
            yDis = dy = py - ly

            # normalize
            sq = math.sqrt(dx * dx + dy * dy)
            dx /= sq
            dy /= sq

            # if the direction has changed, store the point
            if (dx != ldx or dy != ldy):
                compressed.append(PathPoint(lx,ly))
            elif (xDis > 7 or yDis > 7):    #新增两点之间差值判断，距离过远增加进去
                compressed.append(PathPoint(lx, ly))
            else: #判断最后一次压缩点坐标 和当前坐标距离 判断有问题，如果点差太多 应该把前面的也要加上
                lastPos = compressed[len(compressed)-1]	
                xDis = abs( lx - lastPos.x)	#判断之前点坐标
                yDis = abs( ly - lastPos.y)
                if (xDis > 7 or yDis > 7):
                    compressed.append(PathPoint(lx, ly))
                else:			#判断最新点坐标            
                    xDis = abs(px - lastPos.x)
                    yDis = abs(py - lastPos.y)
                    if (xDis > 7 or yDis > 7):                   
                        compressed.append(PathPoint(lx, ly))           
        # store the last point
        compressed.append(PathPoint(px, py))
        return compressed

# def cmpFun(a,b):
#     if a>b:
#         return 1
#     else:
#         return -1
# def main():
#     tVals = [15,14,13,16,14]
#     print(tVals)
#     tVals.sort(key=cmp_to_key(cmpFun))
#     print(tVals)
#     newTVals=sorted(tVals,key=cmp_to_key(cmpFun))
#     print(newTVals)
    # aStarFindPath = AStar(True,True)
    # grid = AStarGrid(100,100)
    # for i in range(100):
    #     for y in range(100):
    #         grid.SetWalkableAt(i,y,True)
    # path = aStarFindPath.FindPath(0, 0, 60, 50, grid)
    # findPath = AStarUtil.compressPath(path)
    # if len(findPath)>0:
    #     for i in findPath:
    #         print("x:%d,y:%d" % (i.x,i.y))

# if __name__ == '__main__':
#     main()