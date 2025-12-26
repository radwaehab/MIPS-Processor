/*`timescale 1ns/1ps

module tb_MIPS_processor;

    // ===== Testbench signals =====
    reg clk;
    reg rst;

    // ===== DUT =====
    MIPS_processor DUT (
        .clk(clk),
        .rst(rst)
    );

    // ===== Clock Generation =====
    always #5 clk = ~clk;   // 10 ns clock period

    // ===== Test Sequence =====
    initial begin
        // Initialize
        clk = 0;
        rst = 1;

        // Hold reset for a few cycles
        #20;
        rst = 0;

        // Run simulation
        #500;

        // Finish
        $stop;
    end

    // ===== Optional Monitoring =====
    initial begin
        $monitor(
            "Time=%0t | PC=%h | Instr=%h | ALU=%h | Zero=%b",
            $time,
            DUT.PC,
            DUT.instruction,
            DUT.ALU_result,
            DUT.Zero
        );
    end

endmodule
*/
`timescale 1ns/1ps

module MIPS_processor_tb();
    reg clk;
    reg rst;

    // Instantiate the Top Module
    MIPS_processor dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        
        $display("Starting Simulation...");
        $display("Time | PC | Instr | ALU_Result | RegWriteData");
        
        // Reset for 2 cycles
        #12 rst = 0;

        // Monitor signals
        $monitor("%t | %h | %h | %h | %h", 
                 $time, dut.PC, dut.instruction, dut.ALU_result, dut.RegWrite_Data);

        // Run for 100ns
        #100;
        
        $display("Simulation Finished.");
        $finish;
    end
endmodule