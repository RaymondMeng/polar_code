import numpy as np
import infobits_pos

zero_num = []
single_num = []
add_num = []

u = []
for i in range(1024):
    u.append(f'u{i}')


# def generate_polar_code_expressions_step_one(N, u):
#     u_out = []
#     add_num_temp = 0
#     single_num_temp = 0
#     zero_num_temp = 0
#     for ii in range(int(N/2)):
#         if (2*ii in infobits_pos.info_bits_pos_256) and (2*ii+1 in infobits_pos.info_bits_pos_256):
#             u_out.append(f'x{2*ii}+x{2*ii+1}')
#             u_out.append(f'x{2*ii+1}')
#             add_num_temp += 1
#             single_num_temp +=1
#         elif 2*ii in infobits_pos.info_bits_pos_256:
#             u_out.append(f'x{2*ii}')
#             u_out.append('0')
#             single_num_temp += 1
#             zero_num_temp += 1
#         elif 2*ii+1 in infobits_pos.info_bits_pos_256:
#             u_out.append(f'x{2*ii+1}')
#             u_out.append(f'x{2*ii+1}')
#             single_num_temp += 2
#         else:
#             u_out.append('0')
#             u_out.append('0')
#             zero_num_temp += 2

#     zero_num.append(zero_num_temp) 
#     single_num.append(single_num_temp)
#     add_num.append(add_num_temp)

#     return u_out
    

def generate_polar_code_expressions_step_one(N, u):
    u_out = []
    add_num_temp = 0
    single_num_temp = 0
    zero_num_temp = 0
    for ii in range(int(N/2)):
        if (2*ii in infobits_pos.info_bits_pos_384) and (2*ii+1 in infobits_pos.info_bits_pos_384):
            u_out.append(f'x{2*ii}^x{2*ii+1}')
            u_out.append(f'x{2*ii+1}')
            add_num_temp += 1
            single_num_temp +=1
        elif 2*ii in infobits_pos.info_bits_pos_384:
            u_out.append(f'x{2*ii}')
            u_out.append('0')
            single_num_temp += 1
            zero_num_temp += 1
        elif 2*ii+1 in infobits_pos.info_bits_pos_384:
            u_out.append(f'x{2*ii+1}')
            u_out.append(f'x{2*ii+1}')
            single_num_temp += 2
        else:
            u_out.append('0')
            u_out.append('0')
            zero_num_temp += 2

    zero_num.append(zero_num_temp) 
    single_num.append(single_num_temp)
    add_num.append(add_num_temp)

    return u_out


def generate_polar_code_expressions_step(N, last_res, step, info_bits_num):
    u_res = [0] * N
    block_num = int(N/(2**step))
    bit_each_block = int(N/block_num)
    dist = 2**(step-1)

    single_num_temp = 0
    add_num_temp = 0
    zero_num_temp = 0

    for i in range(block_num):
        for j in range(int(bit_each_block/2)):
            if last_res[i*bit_each_block+j] != '0' and last_res[i*bit_each_block+j+dist] != '0':
                u_res[i*bit_each_block+j] = f'x{i*bit_each_block+j}^x{i*bit_each_block+j+dist}'
                u_res[i*bit_each_block+j+dist] = f'x{i*bit_each_block+j+dist}'
                single_num_temp += 1
                add_num_temp += 1
            elif last_res[i*bit_each_block+j] != '0':
                u_res[i*bit_each_block+j] = f'x{i*bit_each_block+j}'
                u_res[i*bit_each_block+j+dist] = '0'
                single_num_temp += 1
                zero_num_temp += 1 
            elif last_res[i * bit_each_block + j + dist] != '0':
                u_res[i * bit_each_block + j] = f'x{i * bit_each_block + j + dist}'
                u_res[i * bit_each_block + j + dist] = f'x{i * bit_each_block + j + dist}'
                single_num_temp += 2
            else:
                u_res[i * bit_each_block + j] = '0'
                u_res[i * bit_each_block + j + dist] = '0'
                zero_num_temp += 2 

    zero_num.append(zero_num_temp)
    single_num.append(single_num_temp)
    add_num.append(add_num_temp)

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


u_out = generate_polar_code_expressions_step_one(1024, u)
save_expressions_to_file(u_out, "./stage_res/polar_code_384_step_1.txt")
u_res2 = generate_polar_code_expressions_step(1024, u_out, 2, 384)
u_res3 = generate_polar_code_expressions_step(1024, u_res2, 3, 384)
u_res4 = generate_polar_code_expressions_step(1024, u_res3, 4, 384)
u_res5 = generate_polar_code_expressions_step(1024, u_res4, 5, 384)
u_res6 = generate_polar_code_expressions_step(1024, u_res5, 6, 384)
u_res7 = generate_polar_code_expressions_step(1024, u_res6, 7, 384)
u_res8 = generate_polar_code_expressions_step(1024, u_res7, 8, 384)
u_res9 = generate_polar_code_expressions_step(1024, u_res8, 9, 384)
u_res10 = generate_polar_code_expressions_step(1024, u_res9, 10, 384)

save_deeper_info(zero_num, single_num, add_num, "./xor_num/384_statics.txt")
