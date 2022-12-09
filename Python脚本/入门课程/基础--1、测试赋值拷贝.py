# 这个是测试python的赋值操作，会产生什么效应
# 把下面1和2分别屏蔽和打开，可以验证结果

from collections import namedtuple
import copy

# 定义一个元组，有两个变量x y
CGPoint = namedtuple("CGPoint", "x,y")
# 定义一个list，里面存放了3个坐标元组
moveAbleRangePosList = [CGPoint(x=1, y=1), CGPoint(x=1, y=2), CGPoint(x=1, y=3)]
# 第二个list
clipMoveAblePosList = [CGPoint(x=1, y=1), CGPoint(x=1, y=2)]

##区别在这里
# 1、引用赋值，newMoveAblePosList和moveAbleRangePosList指向同一个对象
#newMoveAblePosList = moveAbleRangePosList

# 2、深拷贝，newMoveAblePosList和moveAbleRangePosList是两个对象，并且把数据也复制过去了
newMoveAblePosList = copy.deepcopy(moveAbleRangePosList)

#3、浅拷贝，如果list里面还有list，就可以看出区别，这里先不测试这个
#newMoveAblePosList = copy.copy(moveAbleRangePosList)

# 这两个在这里数据是一样的
for i in moveAbleRangePosList:
    print("所有点moveAbleRangePosList-：%d %d" % (i.x, i.y))
for i in newMoveAblePosList:
    print("所有点newMoveAblePosList-：%d %d" % (i.x, i.y))

# 这里从newMoveAblePosList集合中删除截取点，理论剩下1,3
for i in clipMoveAblePosList:
    print("截取点：%d %d" % (i.x, i.y))
    newMoveAblePosList.remove(i)

# 再次打印点，这个是赋值的变量集合，预期剩下1,3
for i in newMoveAblePosList:
    print("筛选后点newMoveAblePosList：%d %d" % (i.x, i.y))
for i in moveAbleRangePosList:
    print("筛选后点moveAbleRangePosList：%d %d" % (i.x, i.y))

# 这个是原始的变量集合，预期是1,1 1,2 1,3所有数据都在
# 但是上述1和2两者不同方式，会导致此处结果不同
for i in moveAbleRangePosList:
    print("重新打印原始所有点：%d %d" % (i.x, i.y))

for i in clipMoveAblePosList:
    print("判断点：%d %d" % (i.x, i.y))
    if i in moveAbleRangePosList:
        print("点在集合中")