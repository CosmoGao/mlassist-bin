#用Python的线程事件对象，实现等待游戏聊天内容功能

import threading


#cbname回调函数名
#delay延迟时间
#*argments回调参数 不定参数
def setTimeout(cbname,delay,*argments):
    threading.Timer(delay,cbname,argments).start()
    