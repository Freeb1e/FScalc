import numpy as np
import os

def generate_frodokem_data():
    # --- 1. 参数配置 ---
    rows_A, cols_A = 4, 1344
    rows_S, cols_S = 8, 1344
    
    q_mod = 65536
    s_min, s_max = -12, 12 

    # --- 2. 目录准备 ---
    bin_dir = "./bin"
    txt_dir = "./txt"
    os.makedirs(bin_dir, exist_ok=True)
    os.makedirs(txt_dir, exist_ok=True)
    print(f"输出目录: {bin_dir}, {txt_dir}")

    np.random.seed(42)

    # --- 3. 生成基础数据 ---
    print(f"正在生成基础矩阵...")
    # A: uint16
    matrix_A = np.random.randint(0, q_mod, size=(rows_A, cols_A), dtype=np.uint16)
    # S: int8 [-12, 12]
    matrix_S = np.random.randint(s_min, s_max + 1, size=(rows_S, cols_S), dtype=np.int8)

    # 计算 Golden Result (验证用)
    res_temp = np.dot(matrix_A.astype(np.int64), matrix_S.T.astype(np.int64))
    matrix_Res = (res_temp % q_mod).astype(np.uint16)

    # --- 4. 保存完整文件 (A, S, Result) ---
    # 保存 A 完整版
    matrix_A.tofile(os.path.join(bin_dir, "A_buffer.bin"))
    with open(os.path.join(txt_dir, "A_buffer.txt"), "w") as f:
        for row in matrix_A:
            f.write(" ".join([f"{int(x):04X}" for x in row]) + "\n")

    # 保存 S 原值完整版
    matrix_S.tofile(os.path.join(bin_dir, "S.bin"))
    with open(os.path.join(txt_dir, "S.txt"), "w") as f:
        for row in matrix_S:
            f.write(" ".join([f"{int(x) & 0xFF:02X}" for x in row]) + "\n")

    # 保存 Result 完整版
    matrix_Res.tofile(os.path.join(bin_dir, "Result.bin"))
    with open(os.path.join(txt_dir, "Result.txt"), "w") as f:
        for row in matrix_Res:
            f.write(" ".join([f"{int(x):04X}" for x in row]) + "\n")

    # --- 5. [新增] 将 A 按行拆分为独立文件 (模拟 4 个 RAM) ---
    print(f"正在拆分 A 矩阵 (4 Lines -> 4 Files)...")
    for i in range(rows_A):
        row_data = matrix_A[i] # 提取第 i 行, shape=(1344,)
        
        # 保存 Bin
        fname_bin = f"A_line{i}.bin"
        row_data.tofile(os.path.join(bin_dir, fname_bin))
        
        # 保存 Txt
        fname_txt = f"A_line{i}.txt"
        with open(os.path.join(txt_dir, fname_txt), "w") as f:
            # 单行存储，方便 $readmemh 读取
            hex_str = " ".join([f"{int(x):04X}" for x in row_data])
            f.write(hex_str) # 这里就不换行了，或者换行也可以，取决于你的习惯
            
        print(f"  -> 生成: {fname_bin} / {fname_txt}")

    # --- 6. 生成压缩位切片文件 (Packed Bit-slicing for S) ---
    print(f"正在生成 S 的压缩位切片文件...")
    slices = [("Sbit0", 0), ("Sbit1", 1), ("Sbit2", 2), ("Sbit3", 3), ("Sbitsign", 4)]
    
    for name, shift in slices:
        # 提取 bit 并转为 uint8
        bits_unpacked = ((matrix_S >> shift) & 1).astype(np.uint8)
        # 压缩: 8 bits -> 1 byte
        bits_packed = np.packbits(bits_unpacked, axis=1)
        
        # Bin 保存
        bits_packed.tofile(os.path.join(bin_dir, f"{name}.bin"))
        
        # Txt 保存 (未压缩的 0/1 字符串)
        with open(os.path.join(txt_dir, f"{name}.txt"), "w") as f:
            for row in bits_unpacked:
                f.write("".join([str(x) for x in row]) + "\n")
                
        print(f"  -> 生成: {name}.bin")

    print(f"\n[全部完成]")
    print(f"A 的分行文件 (A_line0~3) 已生成。")
    print(f"S 的位切片文件 (Sbit0~3, Sbitsign) 已生成。")

if __name__ == "__main__":
    generate_frodokem_data()