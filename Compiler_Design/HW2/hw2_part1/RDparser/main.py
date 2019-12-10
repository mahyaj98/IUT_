def match():
    global i
    global string
    global la
    if i < len(string):
        la = string[i]
        i = i + 1


def S():
    global la
    if la == 'f':
        match()
        return
    else:
        A()
        B()
        C()
        S()
        D()
        E()


def A():
    global la
    if la == 'a':
        match()
        A()
    elif la == 'b' or la == 'c' or la == 'd':
        return
    else:
        global flag
        flag = False
        print("false")
        exit(0)


def B():
    global la
    if la == 'b':
        match()
        B()
    elif la == 'c' or la == 'd' or la == 'e':
        return
    else:
        global flag
        flag = False
        print("false\n")
        exit(0)


def C():
    global la
    if la == 'c':
        match()
        C()
    elif la == 'd':
        match()
        return
    else:
        global flag
        flag = False
        print("false\n")
        exit(0)


def D():
    global la
    if la == 'd':
        match()
        D()
    else:
        B()
        if la == 'e':
            match()
            return
        else:
            global flag
            flag = False
            print("false\n")
            exit(0)


def E():
    global la
    if la == 'g':
        match()
        E()
    elif la == 'b' or la == 'd' or la == 'e' or la == '$':
        return
    else:
        global flag
        flag = False
        print("false\n")
        exit(0)


while True:
    try:
        string = input()
        la = string[0]
        i = 1
        flag = True
        S()
        if flag:
            print("Accepted")
    except EOFError:
        break
    except:
        continue
