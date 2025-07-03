def count_additions(file_path):
    two_input_count = 0
    three_input_count = 0
    four_input_count = 0
    num = 0
    try:
        with open(file_path, 'r') as file:
            for line in file:
                line = line.strip()
                if line:
                    if line != '0':
                        num += 1
                    parts = line.split('^')
                    num_parts = len(parts)
                    if num_parts == 2:
                        two_input_count += 1
                    elif num_parts == 3:
                        three_input_count += 1
                    elif num_parts == 4:
                        four_input_count += 1

    except FileNotFoundError:
        print(f"错误：文件 {file_path} 未找到。")
        return None
    except Exception as e:
        print(f"发生未知错误：{e}")
        return None

    return two_input_count, three_input_count, four_input_count, num


if __name__ == "__main__":
    file_path = './mid_res/384_stage_7_8'
    result = count_additions(file_path)
    if result is not None:
        two_input, three_input, four_input, total_num = result
        print(f"当前级总共需要触发器的数量：{total_num}")
        print(f"异或总数：{two_input+three_input*2+four_input*3}")
        print(f"二输入加法数量: {two_input}")
        print(f"三输入加法数量: {three_input}")
        print(f"四输入加法数量: {four_input}")

    