
import heapq
class BaseNode:
    weight = 0

class LeafNode (BaseNode):
    Element = ''
    def isLeaf(self):
        return True

    def __init__(self,w,e):
        self.weight=w
        self.Element=e

class InternalNode(BaseNode):
    RightChild = BaseNode()
    LeftChild = BaseNode()
    def isLeaf(self):
        return False
    def __init__(self,rc , lc ):
        self.RightChild = rc
        self.LeftChild = lc
        self.weight = rc.weight + lc.weight

class FooTree:
    NodesList = []
    def __init__(self,dict):
        for i in dict:
            self.NodesList.append( LeafNode(dict[i], i))
        i = int ( (len ( self.NodesList ) - 1) / 2 )
        for j in range(i+1):
            self.Arrange(i - j)

    def Min(self):
        tmp = self.NodesList[0]
        self.NodesList[0]=self.NodesList[len(self.NodesList)- 1]
        del self.NodesList[len(self.NodesList)- 1]
        self.Arrange(0)
        return tmp

    def Arrange(self, i):
        tmp =i
        l = 2 * i + 1
        r = 2 * i + 2
        if l < len(self.NodesList) and self.NodesList[l].weight < self.NodesList[tmp].weight:
            tmp = l
        if r < len(self.NodesList) and self.NodesList[r].weight < self.NodesList[tmp].weight:
            tmp = r
        if tmp != i:
            tmp2 = self.NodesList[tmp]
            self.NodesList[tmp]=self.NodesList[i]
            self.NodesList[i]=tmp2
            self.Arrange(tmp)

    def FooTree(self):
        while True:
            left = self.Min()
            right = self.Min()
            tmp = InternalNode(right, left)
            self.NodesList.append(tmp)
            self.Arrange(len(self.NodesList)-1)
            if len(self.NodesList) == 1:
                break

        root = self.Min()
        lis = []
        self.PrintCodes(lis, 0, root)


    def PrintCodes(self, lis, pos, root):
        if root.isLeaf()!= True:
            if root.RightChild.weight != 0 :
                if pos >= len(lis) :
                    lis.append(1)
                else:
                    lis[pos] = 1
                self.PrintCodes(lis , pos+1 , root.RightChild)
            if root.LeftChild.weight != 0 :
                if pos >= len(lis):
                    lis.append(0)
                else :
                    lis[pos] = 0
                self.PrintCodes(lis, pos+1, root.LeftChild)
        else :
            print(root.Element,end=" : " )#+ for i in range(pos): lis[i])

            for i in range(pos):
               print(lis[i],end="")

            print("\n")

def Main():
    path = input("Enter File Name:")
    file = open(path)
    string = file.read()
    dict={}
    for i in string:
        if (i in dict.keys())!= True:
            dict.update({i: 1})
        else:
            dict.update({i: dict[i]+1})

    FooCode = FooTree(dict)
    FooCode.FooTree()

Main()




