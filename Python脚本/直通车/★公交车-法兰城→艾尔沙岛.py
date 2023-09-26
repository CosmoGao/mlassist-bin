#超级便民公交车##法兰城至艾尔沙岛  

from cgaapi import *

喊话("欢迎使用 超级便民公交车”之“法兰城→艾尔沙岛",2,3,5)
def main():
    while True:
        curPos=取当前坐标()
        x=curPos.x
        y=curPos.y	
        if(取当前地图名() == "艾尔莎岛"):
             DingJu()
             return
        elif(取当前地图名() == "里谢里雅堡") :
             libao()
        elif (x==72 and y==123 ):	# 西2登录点
              w2()
        elif (x==233 and y==78 ):	# 东2登录点
              e2()
        elif (x==162 and y==130 ):	# 南2登录点
              s2()
        elif (x==63 and y==79 ):	# 西1登录点
              w1()
        elif (x==242 and y==100 ):	# 东1登录点
              e1()
        elif (x==141 and y==148 ):	# 南1登录点
              s1()     
        else:
            回城()
        等待(1000)       

def w2():# 西2登录点
	转向(2)	
	等待到指定地图("法兰城",233,78)	

def e2():	# 东2登录点
	转向(0)	
	等待到指定地图("市场一楼 - 宠物交易区", 46, 16)	
	转向(0)

def s2():	# 南2登录点
	等待到指定地图("法兰城",162,130)	
	自动寻路(153,130)
	Go()

def w1():	# 西1登录点
	转向(0, "")	
	等待到指定地图("法兰城", 242, 100)
	

def e1():	# 东1登录点
	转向(2, "")
	等待到指定地图("市场三楼 - 修理专区", 46, 16)
	转向(0, "")

def s1():	# 南1登录点	
	等待到指定地图("法兰城",141,148)
	自动寻路(153,148)
def Go():
	自动寻路(153,102)
	自动寻路(153,100)
	等待到指定地图("里谢里雅堡")	
def libao():
	自动寻路(41,93)
	自动寻路(28,93)	
	自动寻路(28,88)
	等待服务器返回()	
	对话选择(32, 0)
	等待服务器返回()	
	对话选择(32, 0)
	等待服务器返回()	
	对话选择(32, 0)
	等待服务器返回()	
	对话选择(32, 0)
	等待服务器返回()
	对话选择(4, 0)
	等待到指定地图("？")	
	自动寻路(19, 20)
	移动一格(4)	
	等待到指定地图("法兰城遗迹")		
	自动寻路(98, 138,"盖雷布伦森林")		
	自动寻路(124, 168,"温迪尔平原")		
	自动寻路(264, 108,"艾尔莎岛")	
def DingJu():
	自动寻路(141, 106)	
	转向(1)
	等待服务器返回()
	对话选择(4, 0)
	自动寻路(140, 105)
	喊话("到达目的地，定居完成！",2,3,5)

if __name__ == '__main__':
    #main()
     #检查健康()
    # petData="麒麟,96,114,40,33,36,102,101,3,6,2,7,6"
    # petDatas=petData.split(",")
    # minGrade,maxGrde=cg.ParsePetGrade(petDatas)
    # print(f"最小档次：{minGrade},最大档次：{maxGrde}",flush=True)
    for i in range(40):
        日志(f"{i}:{str(i%11)}")
    # allPets=cg.GetGamePets()
    # for pet in allPets:
    #     日志(f"宠物：{pet.realname},档次：{pet.grade} 最小：{pet.lossMinGrade} 最大:{pet.lossMaxGrade}")
    # logging.info('This is a info.')
    # logging.debug('This is a debug info.')
    # logging.warning('This is a warning info.')
    # logging.error('This is a error info.')
    # logging.critical('This is a critical info.')
    # for pet in allPets:
    #     调试日志(f"宠物：{pet.realname},档次：{pet.grade} 最小：{pet.lossMinGrade} 最大:{pet.lossMaxGrade}")
    # 打开调试()
    # 调试日志("打开调试")
    # for pet in allPets:
    #     日志(f"宠物：{pet.realname},档次：{pet.grade} 最小：{pet.lossMinGrade} 最大:{pet.lossMaxGrade}")
    # 关闭调试()
    # 调试日志("关闭调试")
    # for pet in allPets:
    #     日志(f"宠物：{pet.realname},档次：{pet.grade} 最小：{pet.lossMinGrade} 最大:{pet.lossMaxGrade}")
    # 日志("欢迎使用星落狩猎脚本",1)
    # 日志("当前职业："+人物("职业"),1)
    # 日志("当前职称："+人物("职称"),1)
    # 信息打印()