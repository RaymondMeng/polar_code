import numpy as np


def generate_polar_code_expressions(N):
    """
    生成N阶极化码的编码表达式

    参数:
    N: 码长，必须是2的幂

    返回:
    expressions: 包含N个编码表达式的列表
    """
    # 检查N是否为2的幂
    if N & (N - 1) != 0 or N <= 0:
        raise ValueError("N必须是2的幂")

    # 生成N×N生成矩阵
    n = int(np.log2(N))
    G_2 = np.array([[1, 0], [1, 1]])
    G_N = np.array([[1]])

    for _ in range(n):
        G_N = np.kron(G_N, G_2)

    # 生成表达式
    expressions = []
    for i in range(N):
        terms = []
        for j in range(N):
            if G_N[i, j] == 1:
                terms.append(f"u{j + 1}")

        if terms:
            expressions.append(f"x{i + 1} = {' ^ '.join(terms)}")
        else:
            expressions.append(f"x{i + 1} = 0")

    return expressions


def save_expressions_to_file(expressions, filename):
    """将表达式保存到文件中"""
    with open(filename, 'w') as f:
        for expr in expressions:
            f.write(expr + '\n')


# 生成N=4的极化码表达式示例
expressions_4 = generate_polar_code_expressions(4)
print("N=4的极化码表达式:")
for expr in expressions_4:
    print(expr)

# 生成N=8的极化码表达式示例
expressions_8 = generate_polar_code_expressions(8)
print("\nN=8的极化码表达式:")
for expr in expressions_8:
    print(expr)

# 生成N=1024的极化码表达式并保存到文件
expressions_1024 = generate_polar_code_expressions(1024)
save_expressions_to_file(expressions_1024, "polar_code_N1024_expressions.txt")
print("\nN=1024的表达式已保存到文件: polar_code_N1024_expressions.txt")

# # 打印N=1024的前几个和最后几个表达式
# print("\nN=1024的部分表达式示例:")
# for i in range(5):  # 前5个
#     print(expressions_1024[i])
# print("...")
# for i in range(1019, 1024):  # 最后5个
#     print(expressions_1024[i])