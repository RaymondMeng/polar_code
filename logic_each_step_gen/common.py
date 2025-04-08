def generate_polar_code_expressions_step_one(n, infobits_pos, is_save=0):
    """
    按照0-1023顺序对输入编码
    """
    u_out = []
    for ii in range(int(n/2)):
        if (2*ii in infobits_pos) and (2*ii+1 in infobits_pos):
            u_out.append(f'x{2*ii}^x{2*ii+1}')
            u_out.append(f'x{2*ii+1}')
        elif 2*ii in infobits_pos:
            u_out.append(f'x{2*ii}')
            u_out.append('0')
        elif 2*ii+1 in infobits_pos:
            u_out.append(f'x{2*ii+1}')
            u_out.append(f'x{2*ii+1}')
        else:
            u_out.append('0')
            u_out.append('0')

    if is_save:
        save_expressions_to_file(u_out, f"./stage_res/polar_code_{len(infobits_pos)}_step_1.txt")
    return u_out


def generate_polar_code_expressions_step(n, last_res, step, info_bits_num, is_save=0):
    u_res = [0] * n
    block_num = int(n/(2**step))
    bit_each_block = int(n/block_num)
    dist = 2**(step-1)

    for i in range(int(block_num)):
        for j in range(int(bit_each_block/2)):
            if last_res[i*bit_each_block+j] != '0' and last_res[i*bit_each_block+j+dist] != '0':
                u_res[i*bit_each_block+j] = f'x{i*bit_each_block+j}^x{i*bit_each_block+j+dist}'
                u_res[i*bit_each_block+j+dist] = f'x{i*bit_each_block+j+dist}'
            elif last_res[i*bit_each_block+j] != '0':
                u_res[i*bit_each_block+j] = f'x{i*bit_each_block+j}'
                u_res[i*bit_each_block+j+dist] = '0'
            elif last_res[i * bit_each_block + j + dist] != '0':
                u_res[i * bit_each_block + j] = f'x{i * bit_each_block + j + dist}'
                u_res[i * bit_each_block + j + dist] = f'x{i * bit_each_block + j + dist}'
            else:
                u_res[i * bit_each_block + j] = '0'
                u_res[i * bit_each_block + j + dist] = '0'

    if is_save:
        save_expressions_to_file(u_res, f"./stage_res/polar_code_{info_bits_num}_step_{step}.txt")
    return u_res


def save_expressions_to_file(expressions, filename):
    """将表达式保存到文件中"""
    with open(filename, 'w') as f:
        for expr in expressions:
            f.write(expr + '\n')


def save_deeper_info(zero, single, add, filename):
    with open(filename, 'w') as f:
        for i in range(10):
            f.write(f"step{i}\n")
            f.write(f"zero:{zero[i]}\n")
            f.write(f"single:{single[i]}\n")
            f.write(f"add:{add[i]}\n\n")