
import b #导入时候 就执行了

#a.py 和 b.py
#1、主要用来测试，python对于两个文件都有main函数的处理
#   按网上和测试的说法，说明只有主要运行的那个文件，__name__测试__main__
#   导入的b.py即使有if __name__ == '__main__'  也不会执行，因为它是import 进入b的，默认__name__其实是b
#2、测试对于外部声明的变量，在本文件的函数内更改，需要golbal修饰，在其他文件修改，不用加

print("a run")
def main():
    print("a.main")
    print(b.hp,b.mp)
    b.main()
    print(b.hp,b.mp)
    b.hp=333
    b.mp=444
    print(b.hp,b.mp)
    b.useGlobal()
    print(b.hp,b.mp)
if __name__ == '__main__':
    main()

#打印结果
'''
b run
a run
a.main
100 200
b.main
100 200
333 444
123 234
'''