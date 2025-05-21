import re


def process_file_d(input_file, output_file, n):
    # 读取输入文件
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"错误：输入文件 {input_file} 不存在")
        return
    except Exception as e:
        print(f"读取文件时发生错误：{e}")
        return

    # 处理每一行
    result_lines = []
    for line in lines:
        # 去除换行符
        line = line.strip()
        if not line:
            continue
        # 查找所有 d 后跟的数字
        numbers = re.findall(r'\bd(\d+)\b', line)
        # 替换每个数字为 n - i
        new_line = line
        for num in numbers:
            i = int(num)
            new_num = n - i
            # 使用正则表达式替换，确保只匹配完整的 d{num}
            pattern = r'\bd' + str(num) + r'\b'
            new_line = re.sub(pattern, f'd{new_num}', new_line)
        result_lines.append(new_line)

    # 反转行列表
    result_lines = result_lines[::-1]

    # 写入输出文件
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            for line in result_lines:
                f.write(line + '\n')
        print(f"处理完成，文件已保存到 {output_file}")
    except Exception as e:
        print(f"写入文件时发生错误：{e}")


def process_file_x(input_file, output_file, n):
    # 读取输入文件
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"错误：输入文件 {input_file} 不存在")
        return
    except Exception as e:
        print(f"读取文件时发生错误：{e}")
        return

    # 处理每一行
    result_lines = []
    for line in lines:
        # 去除换行符
        line = line.strip()
        if not line:
            continue
        # 查找所有 x 后跟的数字
        numbers = re.findall(r'\bx(\d+)\b', line)
        # 替换每个数字为 n - i
        new_line = line
        for num in numbers:
            i = int(num)
            new_num = n - i
            # 使用正则表达式替换，确保只匹配完整的 x{num}
            pattern = r'\bx' + str(num) + r'\b'
            new_line = re.sub(pattern, f'x{new_num}', new_line)
        result_lines.append(new_line)

    # 反转行列表
    result_lines = result_lines[::-1]

    # 写入输出文件
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            for line in result_lines:
                f.write(line + '\n')
        print(f"处理完成，结果已保存到 {output_file}")
    except Exception as e:
        print(f"写入文件时发生错误：{e}")


# 示例用法
if __name__ == "__main__":
    stage_1_2_addr = './map_in2out/stage_1_2.txt'  # 输出文件路径
    stage_3_4_addr = './map_in2out/stage_3_4.txt'  # 输出文件路径
    stage_5_6_addr = './map_in2out/stage_5_6.txt'  # 输入文件路径
    stage_7_8_addr = './map_in2out/stage_7_8.txt'
    stage_9_addr = './stage_res/polar_code_384_step_9.txt'
    stage_10_addr = './stage_res/polar_code_384_step_10.txt'

    stage_1_2_addr_out = './map_in2out_0/stage_1_2.txt'  # 输出文件路径
    stage_3_4_addr_out = './map_in2out_0/stage_3_4.txt'  # 输出文件路径
    stage_5_6_addr_out = './map_in2out_0/stage_5_6.txt'  # 输入文件路径
    stage_7_8_addr_out = './map_in2out_0/stage_7_8.txt'
    stage_9_addr_out = './map_in2out_0/stage_9.txt'
    stage_10_addr_out = './map_in2out_0/stage_10.txt'

    process_file_d(stage_1_2_addr, stage_1_2_addr_out, 383)
    process_file_d(stage_3_4_addr, stage_3_4_addr_out, 495)
    process_file_d(stage_5_6_addr, stage_5_6_addr_out, 655)
    process_file_d(stage_7_8_addr, stage_7_8_addr_out, 831)
    # process_file_x(stage_9_addr, stage_9_addr_out, 1023)
    # process_file_x(stage_10_addr, stage_10_addr_out, 1023)
