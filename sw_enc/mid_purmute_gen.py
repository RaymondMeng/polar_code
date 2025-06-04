import re
import infobits_pos
import common


# 读取文件内容
def read_file(file_path):
    with open(file_path, 'r') as file:
        return file.readlines()


# 将x_i映射到d_i
def map_x_to_d(s, u):
    # 正则表达式匹配所有的x_i
    pattern = r'x(\d+)'
    # 获取字符串中的所有x_i的数字部分
    matches = re.findall(pattern, s)

    # 替换每个x_i为d_i
    for match in matches:
        i = u.index(int(match))  # 解析出x_i中的数字
        s = s.replace(f'x{match}', f'in[{i}]')

    return s


# 获得两级之间的映射
def map_in2out(u):
    res = []
    for i, temp in enumerate(u):
        if temp != '0':
            res.append(i)
    return res


# 写入文件
def write_to_file(file_path, data):
    with open(file_path, 'w') as file:
        file.writelines(data)


def stage_1_4_generate_hardware_code(input_path, output_path, u):
    # 读取文件内容
    lines = read_file(input_path)
    filtered_lines = []
    i = 0

    # 对每一行进行处理
    processed_lines = [map_x_to_d(line.strip(), u) + '\n' for line in lines]
    for line in processed_lines :
        if line.strip() != "0" and line.strip() != "":
            filtered_lines.append(f"assign out[{i}]=" + line.strip() + ";\n")
            i = i+1
    # 将处理后的结果写入新文件，直接作为硬件流水线每一级的代码
    write_to_file(output_path, filtered_lines)


def stage_5_6_generate_hardware_code(input_path, output_path, u):
    # 读取文件内容
    lines = read_file(input_path)
    filtered_lines = []
    i = 0

    # 正则表达式匹配所有的x_i
    pattern = r'x(\d+)'
    # 获取字符串中的所有x_i的数字部分
    

    # 对每一行进行处理
    for line in lines :
        if line.strip() != "0" and line.strip() != "":
            line = re.sub(pattern, lambda m: f"in[{m.group(1)}]", line)
            filtered_lines.append(f"assign out[{i}]=" + line.strip() + ";\n")
            i = i+1
    # 将处理后的结果写入新文件，直接作为硬件流水线每一级的代码
    write_to_file(output_path, filtered_lines)

# 示例：处理文件
if __name__ == "__main__":
    infobits_pos_384 = infobits_pos.info_bits_pos_384
    infobits_pos_384.sort()

    u_1 = common.generate_polar_code_expressions_step_one(1024, infobits_pos.info_bits_pos_384)
    u_2 = common.generate_polar_code_expressions_step(1024, u_1, 2, 384)
    u_3 = common.generate_polar_code_expressions_step(1024, u_2, 3, 384)
    u_4 = common.generate_polar_code_expressions_step(1024, u_3, 4, 384)
    u_5 = common.generate_polar_code_expressions_step(1024, u_4, 5, 384)
    u_6 = common.generate_polar_code_expressions_step(1024, u_5, 6, 384)
    u_7 = common.generate_polar_code_expressions_step(1024, u_6, 7, 384)
    u_8 = common.generate_polar_code_expressions_step(1024, u_7, 8, 384)
    u_9 = common.generate_polar_code_expressions_step(1024, u_8, 9, 384)
    u_10 = common.generate_polar_code_expressions_step(1024, u_9, 10, 384)

    stage_1_2_addr = './mid_res/384_stage_1_2'  # 输入文件路径
    stage_3_4_addr = './mid_res/384_stage_3_4'  # 输入文件路径
    stage_5_6_addr = './mid_res/384_stage_5_6'  # 输入文件路径
    stage_7_8_addr = './mid_res/384_stage_7_8'  # 输入文件路径
    stage_9_addr = './stage_res/polar_code_384_step_9.txt' # 输入文件路径
    stage_10_addr = './stage_res/polar_code_384_step_10.txt'# 输入文件路径
    stage_1_2_addr_out = './export_to_hardware/stage_1.txt'  # 输出文件路径
    stage_3_4_addr_out = './export_to_hardware/stage_2.txt'  # 输出文件路径
    stage_5_6_addr_out = './export_to_hardware/stage_3.txt'  # 输出文件路径
    stage_7_8_addr_out = './export_to_hardware/stage_4.txt'  # 输出文件路径
    stage_9_addr_out = './export_to_hardware/stage_5.txt'    # 输出文件路径
    stage_10_addr_out = './export_to_hardware/stage_6.txt'   # 输出文件路径
    map_2to3 = map_in2out(u_2)
    map_4to5 = map_in2out(u_4)
    map_6to7 = map_in2out(u_6)
    stage_1_4_generate_hardware_code(stage_1_2_addr, stage_1_2_addr_out, infobits_pos_384)
    stage_1_4_generate_hardware_code(stage_3_4_addr, stage_3_4_addr_out, map_2to3)
    stage_1_4_generate_hardware_code(stage_5_6_addr, stage_5_6_addr_out, map_4to5)
    stage_1_4_generate_hardware_code(stage_7_8_addr, stage_7_8_addr_out, map_6to7)
    stage_5_6_generate_hardware_code(stage_9_addr, stage_9_addr_out, u_9)
    stage_5_6_generate_hardware_code(stage_10_addr, stage_10_addr_out, u_10)
