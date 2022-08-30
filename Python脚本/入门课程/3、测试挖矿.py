import CGAPython
import time
import sys
import os
import logging
sys.path.append('../')          #下面的common在上级目录，这里把路径加进来

from common import *


findSkill=None
skills = cga.GetSkillsInfo()
for skill in skills:
    logging.info(skill.name + " Lv:" +str(skill.lv) + " maxLv:"+ str(skill.maxlv) + " xp:" + str(skill.xp)
    + " maxxp:" + str(skill.maxxp)+ " id:" + str(skill.skill_id)+ " type:" + str(skill.type)+ " pos:" + str(skill.pos)+ " index:" + str(skill.index)+ " slotsize:" + str(skill.slotsize))
    if skill.name=="挖矿":
        findSkill=skill
if findSkill == None:
    日志("没有找到挖矿技能",1)
    sys.exit()

   
#测试战斗
# while True:
    # if 是否空闲() == False:
        # r,res=等待战斗返回()
        # if r:
            # 日志(res)
    
#优化的话，可以考虑python的字典，通过key调用对应操作
while True :
    mapName=取当前地图名()
    mapNum= 取当前地图编号()
    if(mapName=="艾尔莎岛"):
        自动寻路(140, 105)    
        转向(1)  
        等待服务器返回(3)
        对话选择(4,0)  
        
    elif mapName=="里谢里雅堡":
        自动寻路(17,53,"法兰城")
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
        自动寻路(22,88,"芙蕾雅")      
    elif mapNum == 59511:
        自动寻路(19,21)    
    elif mapName == "法兰城遗迹":
        自动寻路(98, 138)   
    elif mapName == "盖雷布伦森林":
        自动寻路(124, 168)      
    elif mapName == "温迪尔平原":
        自动寻路(264, 108)
    elif mapNum == 11013:
        while True:  
            工作("挖掘","",6500)	#技能名 物品名 延时时间
            r,res=等待工作返回(6500)
            if r:  
                日志(res.name + " success:" + str(res.success)+ " levelup:" + str(res.levelup)+ " xp:" + str(res.xp)+ " count:" + str(res.count)+ " endurance:" + str(res.endurance)+ " skillful:" + str(res.skillful)+ " intelligence:" + str(res.intelligence))
        end 
    elif mapNum == 100:
        自动寻路(351, 145)	
    else:
        pass
        #cga.LogBack()
    time.sleep(1.5)
#break
#喊话
cga.SayWords("定居新城脚本完成",1,2,3)

