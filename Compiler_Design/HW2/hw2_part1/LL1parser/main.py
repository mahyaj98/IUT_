vars = ['A', 'B', 'C', 'D', 'E', 'S']
terms = [chr(x) for x in range(ord('a'), ord('h'))]
terms.append('$')

rules = ['', 'f', 'ABCSDE', 'aA', '', 'bB', '', 'cC', 'd', 'dD', 'Be', 'gE', '']

PT = {}
for row in vars:
    PT[row] = {}
    for col in terms:
        PT[row][col] = -1

PT['S']['a'] = PT['S']['b'] = PT['S']['c'] = PT['S']['d'] = 1
PT['S']['f'] = 2

PT['A']['a'] = 3
PT['A']['b'] = PT['A']['c'] = PT['A']['d'] = 4

PT['B']['b'] = 5
PT['B']['c'] = PT['B']['d'] = PT['B']['e'] = 6

PT['C']['c'] = 7
PT['C']['d'] = 8

PT['D']['d'] = 9
PT['D']['b'] = PT['D']['e'] = 10

PT['E']['g'] = 11
PT['E']['b'] = PT['E']['d'] = PT['E']['e'] = PT['E']['$'] = 12


PT['C']['a'] = PT['C']['b'] = PT['C']['f'] = 0
PT['D']['$'] = PT['D']['g'] = 0
PT['S']['e'] = PT['S']['$'] = 0


while True:
    try:
        string = input()
        stack = '$S'

        ind = 0
        LA = string[ind]

        missing_char, additional_char, accept = False, False, False
        while not accept:
            top = stack[-1]

            if top.islower() or top == '$':
                if top == LA and top == '$':
                    accept = True

                elif top == LA and top != '$':
                    stack = stack[:-1]
                    ind += 1
                    LA = string[ind]


                elif top != LA:
                    stack = stack[:-1]
                    missing_char = True


            else:
                if PT[top][LA] > 0:
                    stack = stack[:-1]
                    stack += rules[PT[top][LA]][::-1]

                
                elif PT[top][LA] == -1:
                    additional_char = True

                    if LA == '$':
                        stack = '$'
                    else:
                        ind += 1
                        LA = string[ind]


                elif PT[top][LA] == 0:
                    if len(stack) == 2:
                        while PT[top][LA] <= 0:
                            ind += 1
                            LA = string[ind]
                    else:
                        stack = stack[:-1]
                    additional_char = True


        if not missing_char and not additional_char:
            print("accepted :)")

        else:
            print("failed :(  syntax error")
           

        print('---------------------------------------')
    except:
        break
