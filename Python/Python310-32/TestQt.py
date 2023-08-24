from PySide2.QtWidgets import QApplication, QMainWindow, QPushButton,  QPlainTextEdit

def TestQt():
    app = QApplication([])

    window = QMainWindow()
    window.resize(500, 400)
    window.move(300, 310)
    window.setWindowTitle('薪资统计')

    textEdit = QPlainTextEdit(window)
    textEdit.setPlaceholderText("请输入薪资表")
    textEdit.move(10,25)
    textEdit.resize(300,350)

    button = QPushButton('统计', window)
    button.move(380,80)

    window.show()

    app.exec_()

class GInfo():
    tData=123
    def __init__(self) -> None:
        self.data=4444
        pass


def testFun2():
    return GInfo()

def testFun():
    return {"a":1,"b":2}

def main():
    testData = {"gid":testFun()["a"],"ttt":testFun2().data}
    print(testData["gid"])
    print(testData["ttt"])
    testSwitch="2"
    match(testSwitch):
        case("gid"):print(testData[testSwitch])
        case _:
            print("Un Match")

if __name__ == '__main__':
    main()
