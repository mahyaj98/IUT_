
def PTSLR(cols):
    PT = {}
    for i in range(10):
        PT[i] = {}
        for c in cols:
            PT[i][c] = -1

    PT[0]['d'] = 's3'
    PT[0]['a'] = 'r3'
    PT[0]['b'] = 'r3'
    PT[0]['S'] = '1'
    PT[0]['A'] = '2'

    PT[1]['$'] = 'acc'

    PT[2]['a'] = 's5'
    PT[2]['B'] = '4'

    PT[3]['A'] = '6'
    PT[3]['d'] = 's3'
    PT[3]['a'] = 'r3'
    PT[3]['b'] = 'r3'

    PT[4]['$'] = 'r1'

    PT[5]['A'] = '7'
    PT[5]['d'] = 's3'
    PT[5]['a'] = 'r3'
    PT[5]['b'] = 'r3'

    PT[6]['a'] = 's8'

    PT[7]['a'] = 's5'
    PT[7]['b'] = 's9'

    PT[8]['a'] = 'r2'
    PT[8]['b'] = 'r2'

    PT[9]['$'] = 'r4'

    return PT


def PTLALR(cols):
    PT = {}
    for i in range(10):
        PT[i] = {}
        for c in cols:
            PT[i][c] = -1

    PT[0]['d'] = 's3'
    PT[0]['a'] = 'r3'
    PT[0]['S'] = '1'
    PT[0]['A'] = '2'

    PT[1]['$'] = 'acc'

    PT[2]['a'] = 's5'
    PT[2]['B'] = '4'

    PT[3]['A'] = '8'
    PT[3]['d'] = 's3'
    PT[3]['a'] = 'r3'

    PT[4]['$'] = 'r1'

    PT[5]['A'] = '6'
    PT[5]['d'] = 's3'
    PT[5]['b'] = 'r3'

    PT[6]['b'] = 's7'

    PT[7]['$'] = 'r4'
    PT[8]['a'] = 's9'

    PT[9]['b'] = 'r2'
    PT[9]['a'] = 'r2'

    return PT

def PTCLR(cols):
    PT = {}
    for i in range(13):
        PT[i] = {}
        for c in cols:
            PT[i][c] = -1

    PT[0]['d'] = 's3'
    PT[0]['a'] = 'r3'
    PT[0]['S'] = '1'
    PT[0]['A'] = '2'

    PT[1]['$'] = 'acc'

    PT[2]['a'] = 's5'
    PT[2]['B'] = '4'

    PT[3]['A'] = '11'
    PT[3]['d'] = 's3'
    PT[3]['a'] = 'r3'

    PT[4]['$'] = 'r1'

    PT[5]['A'] = '6'
    PT[5]['d'] = 's8'
    PT[5]['b'] = 'r3'

    PT[6]['b'] = 's7'

    PT[7]['$'] = 'r4'

    PT[8]['A'] = '9'
    PT[8]['d'] = 's3'
    PT[8]['a'] = 'r3'

    PT[9]['a'] = 's10'

    PT[10]['b'] = 'r2'

    PT[11]['a'] = 's12'

    PT[12]['a'] = 'r2'

    return PT




def main ():
    cols = ['d', 'a', 'b', '$', 'S', 'A', 'B']
    rules = [(), ('S', 'AB'), ('A', 'dAb'), ('A', ''), ('B', 'aAb')]
    mode = input()
    if mode == "SLR":
        PT = PTSLR(cols)
    elif mode == "LALR(1)":
        PT = PTLALR(cols)
    else :
        PT = PTCLR(cols)
    while True:
        try:
            string = input() + '$'
            stack = '0'
            ind = 0

            error, accept = False, False
            while not accept and not error:
                LA = string[ind]
                top = int(stack[-1])
                if PT[top][LA] == -1:
                 error = True

                elif PT[top][LA] == 'acc':
                    accept = True

                elif PT[top][LA][0] == 's':
                    stack += LA + PT[top][LA][1:]
                    ind += 1

                else:
                    num = int(PT[top][LA][1:])
                    stack = stack[:len(stack) - (2 * len(rules[num][1]))]

                    top = int(stack[-1])
                    i = PT[top][rules[num][0]]
                    if i == -1:
                        break
                    stack += rules[num][0] + i

            if accept:
                print('Parse is Complete : String got accepted!')
            else:
                print('Parse is aborted due to Syntax Error!')

        except:

            break
main()
