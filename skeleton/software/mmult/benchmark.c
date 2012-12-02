#include "benchmark.h"
#include "ascii.h"
#include "uart.h"

#define BUF_LEN 128

void run_and_time(uint32_t (*f)()) {
    uint32_t result, time, instructions;
    int8_t buffer[BUF_LEN];
    COUNTER_RST = 0;
    result = (*f)();
    time = CYCLE_COUNTER;
    instructions = INSTRUCTION_COUNTER;
    uwrite_int8s("R: ");
    uwrite_int8s(uint32_to_ascii_hex(result, buffer, BUF_LEN));
    uwrite_int8s("\r\nCC: ");
    uwrite_int8s(uint32_to_ascii_hex(time, buffer, BUF_LEN));
    uwrite_int8s("\r\nIC: ");
    uwrite_int8s(uint32_to_ascii_hex(instructions, buffer, BUF_LEN));
    uwrite_int8s("\r\n");
}
