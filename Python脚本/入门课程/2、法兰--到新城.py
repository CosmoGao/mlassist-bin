#法兰城到艾尔莎岛定居脚本
import CGAPython
import time
import sys
import os
import logging

sys.path.append('../')          #下面的common在上级目录，这里把路径加进来

#import common
from common import *

#优化的话，可以考虑python的字典，通过key调用对应操作
while True :
    mapName=取当前地图名()
    mapNum= 取当前地图编号()
    if(mapName=="艾尔莎岛"):
        自动寻路(141, 106)    
        转向坐标(142,105)  
        等待服务器返回(3)
        对话选择(4,0)  
        break
    elif mapName=="里谢里雅堡":
        自动寻路(28,88)
        等待服务器返回()        
        对话选择(32,0) 
        等待服务器返回()  
        对话选择(32,0) 
        等待服务器返回()  
        对话选择(32,0) 
        等待服务器返回()
        对话选择(32,0) 
        等待服务器返回()
        对话选择(4,0) 
    elif mapName=="法兰城":
        自动寻路(153,100)      
    elif mapNum == 59511:
        自动寻路(19,21)    
    elif mapName == "法兰城遗迹":
        自动寻路(98, 138)   
    elif mapName == "盖雷布伦森林":
        自动寻路(124, 168)      
    elif mapName == "温迪尔平原":
        自动寻路(264, 108)  
    else:
        pass
        #cga.LogBack()
    time.sleep(1.5)
    
#喊话
cga.SayWords("定居新城脚本完成",1,2,3)

