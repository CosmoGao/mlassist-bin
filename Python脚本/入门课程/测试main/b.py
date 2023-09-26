
print("b run")

hp=100
mp=200
def main():
    print("b.main")
    hp=123
    mp=234
def useGlobal():
    global hp,mp
    hp=123
    mp=234
if __name__ == '__main__':
    main()