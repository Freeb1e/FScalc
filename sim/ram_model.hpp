#include <vector>
#include <string>
#include <cstdint>

// [新增] 用于表示 256 位数据的结构体
struct RData256 {
    uint64_t d0; // 低 64 位 [63:0]
    uint64_t d1; // [127:64]
    uint64_t d2; // [191:128]
    uint64_t d3; // 高 64 位 [255:192]
};

class RamModel {
public:
    RamModel();
    ~RamModel();

    bool init_from_bin(const std::string &filename);
    
    // 原有接口
    uint64_t eval(bool clk, uint64_t addr, bool wen, uint64_t wdata);
    void eval_dual(bool clk, 
                   uint64_t addr_a, bool wen_a, uint64_t wdata_a,
                   uint64_t addr_b, bool wen_b, uint64_t wdata_b,
                   uint64_t &rdata_a, uint64_t &rdata_b);

    // [新增] 256位 读端口接口
    // 注意：这里模拟的是宽位宽 RAM，输入 addr=0 取出内部 0~3，addr=1 取出 4~7
    void eval_read_256(bool clk, uint64_t addr, RData256 &rdata);

    void dump_to_txt(const std::string &filename);
    void dump_decimal_matrix(const std::string &filename);
    void dump_to_bin(const std::string &filename);

private:
    std::vector<uint64_t> memory;
    bool last_clk;
    
    uint64_t output_reg_a;
    uint64_t output_reg_b;
    
    // [新增] 256位输出寄存器（模拟硬件锁存）
    RData256 output_reg_256; 
};