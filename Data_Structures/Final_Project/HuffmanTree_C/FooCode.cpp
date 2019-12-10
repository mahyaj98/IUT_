#include <stdio.h>
#include <stdlib.h>

typedef struct TreeNode
{
	char data;
	int num;
	struct TreeNode *leftc, *rightc;
} TreeNode;

typedef struct Tree
{
	int size;
	int capacity;
	struct TreeNode **array;
	int** Codes;
	int* Elements;
	int* Sizes;
} Tree;

TreeNode* AllocOne(char data, int num)
{
	TreeNode* temp =
		(TreeNode*)malloc(sizeof(TreeNode));
	temp->leftc = temp->rightc = NULL;
	temp->data = data;
	temp->num = num;
	return temp;
}//this function allocates a new node for keeping either a leaf node information or an internal node
Tree* AllocTree(int capacity)
{
	Tree* tree = (Tree*)malloc(sizeof(Tree));
	tree->size = 0;
	tree->capacity = capacity;
	tree->array = (TreeNode**)malloc(tree->capacity * sizeof(TreeNode*));
	tree->Codes = (int**)malloc(tree->capacity * sizeof(int**));
	tree->Elements = (int*)malloc(tree->capacity * sizeof(int*));
	tree->Sizes = (int*)malloc(tree->capacity * sizeof(int*));


	return tree;
}
void swap(TreeNode** a, TreeNode** b)
{
	TreeNode* tmp = *a;
	*a = *b;
	*b = tmp;
}
void Arrange(Tree* tree, int i)
{
	int tmp = i;
	int left = 2 * i + 1;
	int right = 2 * i + 2;

	if (left < tree->size && tree->array[left]->num < tree->array[tmp]->num)
	{
		tmp = left;
	}
	if (right < tree->size && tree->array[right]->num < tree->array[tmp]->num)
		tmp = right;
	if (tmp != i)
	{
		swap(&tree->array[tmp], &tree->array[i]);
		Arrange(tree, tmp);
	}
}
bool isOne(Tree* tree)
{
	return (tree->size == 1);
}
bool leaf(TreeNode* root)
{
	return !(root->leftc) && !(root->rightc);
}
TreeNode* min(Tree* tree)
{
	TreeNode* tmp = tree->array[0];
	tree->array[0] = tree->array[tree->size - 1];
	(tree->size)--;
	Arrange(tree, 0);
	return tmp;
}
void insert(Tree* tree, TreeNode* node)
{
	(tree->size)++;
	int i = tree->size - 1;
	while (i > 0 && node->num < tree->array[(i - 1) / 2]->num)
	{
		tree->array[i] = tree->array[(i - 1) / 2];
		i = (i - 1) / 2;
	}
	tree->array[i] = node;
}

Tree* initialize(char data[], int num[], int size)
{
	Tree* tree = AllocTree(size);
	for (int i = 0; i < size; i++)
		tree->array[i] = AllocOne(data[i], num[i]);
	tree->size = size;
	for (int i = (size - 1) / 2; i >= 0; i--)
	{
		Arrange(tree, i);
	}
	for (int i = 0; i < size; i++)
	{
		tree->Elements[i] = data[i];
		tree->Sizes[i] = 0;
	}
	return tree;
}
int whatIndex(Tree* tree, int e)
{
	for (int i = 0; i < tree->capacity; i++)
	{
		if (tree->Elements[i] == e)
		{
			return i;
		}
	}
}
void PrintCodes(Tree* tree, TreeNode* root, int a[], int pos)
{
	if (root->leftc)
	{
		a[pos] = 0;
		PrintCodes(tree, root->leftc, a, pos + 1);
	}
	if (root->rightc)
	{
		a[pos] = 1;
		PrintCodes(tree, root->rightc, a, pos + 1);
	}
	if (leaf(root))
	{
		printf("%c: ", root->data);
		int j = whatIndex(tree, root->data);
		tree->Codes[j] = (int*)malloc(pos * sizeof(int));
		tree->Sizes[j] = pos;
		for (int i = 0; i < pos; ++i)
		{
			printf("%d", a[i]);
			tree->Codes[j][i] = a[i];
		}
		printf("\n");
	}
}

Tree* FooTree(char data[], int num[], int size)
{
	TreeNode *left, *right, *inter;
	Tree* tree = initialize(data, num, size);
	while (!isOne(tree))
	{
		left = min(tree);
		right = min(tree);
		inter = AllocOne('_', left->num + right->num);
		inter->leftc = left;
		inter->rightc = right;
		insert(tree, inter);
	}
	TreeNode* root = min(tree);
	int a[100], pos = 0;
	PrintCodes(tree, root, a, pos);


	return tree;
}
int DataInput(char chars[], int num[], char c, int size)
{
	int i = 0;
	while (chars[i])
	{
		if (chars[i] == c)
		{
			num[i]++;
			return size;
		}
		i++;
	}
	chars[size] = c;
	num[size]++;
	return size + 1;
}
void Decoding(int* Encoded, int os, TreeNode* root)
{
	TreeNode* cur = root;
	printf("Decoding the Encoded(!) : \n");
	for (size_t i = 0; i < os; i++)
	{
		if (Encoded[i] == 0)
		{
			cur = cur->leftc;
		}
		else
		{
			cur = cur->rightc;
		}
		if (cur->leftc == NULL && cur->rightc == NULL)
		{
			printf("%c", cur->data);
			cur = root;
		}
	}
	printf("\n");
}
int pow2(int k)
{
	int maxS = 1;
	for (int j = 0; j <k; j++)
	{
		maxS *= 2;
	}
	return maxS;
}
void PrintTree(Tree* tree, TreeNode* root)
{
	int max = 0;
	for (int i = 0; i < tree->capacity; i++)
	{
		if (tree->Sizes[i] > max)
		{
			max = tree->Sizes[i];
		}
	}
	max = max + 1;
	int maxS = pow2(max - 1);
	TreeNode** frs = (TreeNode**)malloc(maxS * sizeof(TreeNode*));
	TreeNode** sec = (TreeNode**)malloc(maxS * sizeof(TreeNode*));
	for (size_t i = 0; i < maxS; i++)
	{
		frs[i] = NULL;
		sec[i] = NULL;
	}
	int frsi = 0, seci = 0;
	frs[frsi] = root;
	frsi++;
	for (size_t i = 0; i < max; i++)
	{
		for (size_t j = 0; j <(pow2(max - i) - 1); j++)
		{
			printf("  ");
		}
		for (int l = 0; l < frsi; l++)
		{
			if (frs[l]) {
				printf("%c(%d)", frs[l]->data, frs[l]->num);
				sec[seci] = frs[l]->leftc;
				seci++;
				sec[seci] = frs[l]->rightc;
				seci++;
			}
			else
			{
				printf("  ");
				sec[seci] = NULL;
				seci++;
				sec[seci] = NULL;
				seci++;
			}
			for (size_t j = 0; j <(pow2(max - i + 1) - 1); j++)
			{
				printf("  ");
			}
		}
		for (size_t j = 0; j <(pow2(max - i) - 1); j++)
		{
			printf("  ");
		}
		for (int b = 0; b < seci; b++)
		{
			frs[b] = sec[b];
		}
		frsi = seci;
		seci = 0;
		printf("\n");
	}
}
int main()
{
	char chars[27] = {};
	int num[27] = {};
	int size = 0;
	char Address[100];
	printf("Enter File name : ");
	scanf("%s", Address);
	FILE* f = fopen(Address, "r");
	if (f == NULL)
	{
		perror("An error accured while opening the file!\n");
		exit(0);
	}
	char cur = fgetc(f);
	while (cur != EOF)
	{
		size = DataInput(chars, num, cur, size);
		cur = fgetc(f);
	}
	Tree* tree = FooTree(chars, num, size);
	printf("Final Output File Size : ");
	int S = 0;
	for (int i = 0; i < tree->capacity; i++)
	{
		S += num[i] * tree->Sizes[i];
	}
	int* Encoded = (int*)malloc(S * sizeof(int));
	printf("%d\n", S);
	TreeNode* root = min(tree);
	printf("Encoded File : \n");
	fclose(f);
	FILE* ff = fopen(Address, "r");
	if (ff == NULL)
	{
		perror("An error accured while opening the file!\n");
		exit(0);
	}
	cur = fgetc(ff);
	int k = 0;
	while (cur != EOF)
	{
		int j = whatIndex(tree, cur);
		for (int i = 0; i < tree->Sizes[j]; i++)
		{
			printf("%d", tree->Codes[j][i]);
			Encoded[k] = tree->Codes[j][i];
			k++;
		}
		cur = fgetc(ff);
	}
	printf("\n");
	Decoding(Encoded, k, root);
	//PrintTree(tree, root);
	
	//system("pause");
	fclose(ff);
	return 0;
}
