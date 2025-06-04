import infobits_pos
import common


def generate_polar_code_stage_mid_res(n, stage_num, u_begin, stage, info_bits_num, is_save=0):
    """
    用于生成极化码编码过程按流水线划分后，每级的运算关系
    :param is_save: 是否保存标志位
    :param n: 极化码码长
    :param stage: 起始阶数
    :param stage_num: 打包阶数
    :param u_begin: 起始向量
    :param info_bits_num: 信息比特位数
    :return:
    """
    stage_temp = stage
    u_temp = u_begin

    for _ in range(stage_num-1):
        block_num = int(n / (2 ** stage_temp))
        bit_each_block = int(n/block_num)
        dist = 2**(stage_temp-1)
        u_res = ['0']*n
        for j in range(block_num):
            for k in range(int(bit_each_block/2)):
                if u_temp[j*bit_each_block+k] != '0' and u_temp[j*bit_each_block+k+dist] != '0':
                    u_res[j*bit_each_block+k] = u_temp[j*bit_each_block+k] + "^" + u_temp[j*bit_each_block+k+dist]
                    u_res[j*bit_each_block+k+dist] = u_temp[j*bit_each_block+k+dist]
                elif u_temp[j*bit_each_block+k] != '0':
                    u_res[j*bit_each_block+k] = u_temp[j*bit_each_block+k]
                    u_res[j*bit_each_block+k+dist] = '0'
                elif u_temp[j*bit_each_block+k+dist] != '0':
                    u_res[j*bit_each_block+k] = u_temp[j*bit_each_block+k+dist]
                    u_res[j*bit_each_block+k+dist] = u_temp[j*bit_each_block+k+dist]
                else:
                    u_res[j*bit_each_block+k] = '0'
                    u_res[j*bit_each_block+k+dist] = '0'
        u_temp = u_res
        stage_temp = stage_temp + 1

    if is_save:
        common.save_expressions_to_file(u_temp, f"./mid_res/{info_bits_num}_stage_{stage-1}_{stage-2+stage_num}")
    return u_temp


if __name__ == "__main__":
    u = []
    for i in range(1024):
        u.append(f'u{i}')
    #获取极化码生成过程中每一步的表达式（384）
    u_1 = common.generate_polar_code_expressions_step_one(1024, infobits_pos.info_bits_pos_384, is_save=1)
    u_2 = common.generate_polar_code_expressions_step(1024, u_1, 2, 384, is_save=1)
    u_3 = common.generate_polar_code_expressions_step(1024, u_2, 3, 384, is_save=1)
    u_4 = common.generate_polar_code_expressions_step(1024, u_3, 4, 384, is_save=1)
    u_5 = common.generate_polar_code_expressions_step(1024, u_4, 5, 384, is_save=1)
    u_6 = common.generate_polar_code_expressions_step(1024, u_5, 6, 384, is_save=1)
    u_7 = common.generate_polar_code_expressions_step(1024, u_6, 7, 384, is_save=1)
    u_8 = common.generate_polar_code_expressions_step(1024, u_7, 8, 384, is_save=1)
    u_9 = common.generate_polar_code_expressions_step(1024, u_8, 9, 384, is_save=1)
    u_10 = common.generate_polar_code_expressions_step(1024, u_9, 10, 384, is_save=1)

    # 生成划分流水线阶数后的表达式 TODO: 生成各xor的个数
    s_1 = generate_polar_code_stage_mid_res(1024, 2, u_1, 2, info_bits_num=384, is_save=1)
    s_2 = generate_polar_code_stage_mid_res(1024, 2, u_3, 4, info_bits_num=384, is_save=1)
    s_3 = generate_polar_code_stage_mid_res(1024, 2, u_5, 6, info_bits_num=384, is_save=1)
    s_4 = generate_polar_code_stage_mid_res(1024, 2, u_7, 8, info_bits_num=384, is_save=1)

    #获取极化码生成过程中每一步的表达式（256）
    u_1 = common.generate_polar_code_expressions_step_one(1024, infobits_pos.info_bits_pos_256, is_save=1)
    u_2 = common.generate_polar_code_expressions_step(1024, u_1, 2, 256, is_save=1)
    u_3 = common.generate_polar_code_expressions_step(1024, u_2, 3, 256, is_save=1)
    u_4 = common.generate_polar_code_expressions_step(1024, u_3, 4, 256, is_save=1)
    u_5 = common.generate_polar_code_expressions_step(1024, u_4, 5, 256, is_save=1)
    u_6 = common.generate_polar_code_expressions_step(1024, u_5, 6, 256, is_save=1)
    u_7 = common.generate_polar_code_expressions_step(1024, u_6, 7, 256, is_save=1)
    u_8 = common.generate_polar_code_expressions_step(1024, u_7, 8, 256, is_save=1)
    u_9 = common.generate_polar_code_expressions_step(1024, u_8, 9, 256, is_save=1)
    u_10 = common.generate_polar_code_expressions_step(1024, u_9, 10, 256, is_save=1)

    # 生成划分流水线阶数后的表达式 TODO: 生成各xor的个数
    s_1 = generate_polar_code_stage_mid_res(1024, 2, u_1, 2, info_bits_num=256, is_save=1)
    s_2 = generate_polar_code_stage_mid_res(1024, 2, u_3, 4, info_bits_num=256, is_save=1)
    s_3 = generate_polar_code_stage_mid_res(1024, 2, u_5, 6, info_bits_num=256, is_save=1)
    s_4 = generate_polar_code_stage_mid_res(1024, 2, u_7, 8, info_bits_num=256, is_save=1)

