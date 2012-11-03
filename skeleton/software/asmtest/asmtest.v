module asmtest(input clk, input rst, input [29:0] addr, output reg [31:0] inst);
reg [29:0] addr_r;
always @(posedge clk)
begin
addr_r <= (rst) ? (30'b0) : (addr);
end
always @(*)
begin
case(addr_r)
30'h00000000: inst = 32'h24170000;
30'h00000001: inst = 32'h3c168000;
30'h00000002: inst = 32'h3c158000;
30'h00000003: inst = 32'h36b50004;
30'h00000004: inst = 32'h3c148000;
30'h00000005: inst = 32'h36940008;
30'h00000006: inst = 32'h3c138000;
30'h00000007: inst = 32'h3673000c;
30'h00000008: inst = 32'h3c118000;
30'h00000009: inst = 32'h36310008;
30'h0000000a: inst = 32'h3c121000;
30'h0000000b: inst = 32'h3652100f;
30'h0000000c: inst = 32'h24170000;
30'h0000000d: inst = 32'h26f70001;
30'h0000000e: inst = 32'h3c101234;
30'h0000000f: inst = 32'h36105678;
30'h00000010: inst = 32'h3c081234;
30'h00000011: inst = 32'h35085678;
30'h00000012: inst = 32'h1510009b;
30'h00000013: inst = 32'h00000000;
30'h00000014: inst = 32'h00000000;
30'h00000015: inst = 32'h26f70001;
30'h00000016: inst = 32'h24100078;
30'h00000017: inst = 32'h3c081234;
30'h00000018: inst = 32'h35085678;
30'h00000019: inst = 32'ha6480000;
30'h0000001a: inst = 32'h00000000;
30'h0000001b: inst = 32'h92480000;
30'h0000001c: inst = 32'h00000000;
30'h0000001d: inst = 32'h15100090;
30'h0000001e: inst = 32'h00000000;
30'h0000001f: inst = 32'h00000000;
30'h00000020: inst = 32'h26f70001;
30'h00000021: inst = 32'h24105678;
30'h00000022: inst = 32'h3c081234;
30'h00000023: inst = 32'h35085678;
30'h00000024: inst = 32'ha6480000;
30'h00000025: inst = 32'h00000000;
30'h00000026: inst = 32'h96480000;
30'h00000027: inst = 32'h00000000;
30'h00000028: inst = 32'h15100085;
30'h00000029: inst = 32'h00000000;
30'h0000002a: inst = 32'h00000000;
30'h0000002b: inst = 32'h26f70001;
30'h0000002c: inst = 32'h24105678;
30'h0000002d: inst = 32'h3c081234;
30'h0000002e: inst = 32'h35085678;
30'h0000002f: inst = 32'ha6480000;
30'h00000030: inst = 32'h00000000;
30'h00000031: inst = 32'h8e480000;
30'h00000032: inst = 32'h00000000;
30'h00000033: inst = 32'h1510007a;
30'h00000034: inst = 32'h00000000;
30'h00000035: inst = 32'h00000000;
30'h00000036: inst = 32'h26f70001;
30'h00000037: inst = 32'h24100001;
30'h00000038: inst = 32'h24080002;
30'h00000039: inst = 32'h2d08ffff;
30'h0000003a: inst = 32'h15100073;
30'h0000003b: inst = 32'h00000000;
30'h0000003c: inst = 32'h00000000;
30'h0000003d: inst = 32'h26f70001;
30'h0000003e: inst = 32'h3410edcb;
30'h0000003f: inst = 32'h24081234;
30'h00000040: inst = 32'h3908ffff;
30'h00000041: inst = 32'h1510006c;
30'h00000042: inst = 32'h00000000;
30'h00000043: inst = 32'h00000000;
30'h00000044: inst = 32'h26f70001;
30'h00000045: inst = 32'h3c100234;
30'h00000046: inst = 32'h36105670;
30'h00000047: inst = 32'h3c081234;
30'h00000048: inst = 32'h35085678;
30'h00000049: inst = 32'h00084100;
30'h0000004a: inst = 32'h15100063;
30'h0000004b: inst = 32'h00000000;
30'h0000004c: inst = 32'h00000000;
30'h0000004d: inst = 32'h26f70001;
30'h0000004e: inst = 32'h3c100123;
30'h0000004f: inst = 32'h36104567;
30'h00000050: inst = 32'h3c081234;
30'h00000051: inst = 32'h35085678;
30'h00000052: inst = 32'h24090004;
30'h00000053: inst = 32'h01094006;
30'h00000054: inst = 32'h15100059;
30'h00000055: inst = 32'h00000000;
30'h00000056: inst = 32'h080000af;
30'h00000057: inst = 32'h00000000;
30'h00000058: inst = 32'h24100020;
30'h00000059: inst = 32'h24080020;
30'h0000005a: inst = 32'h15100053;
30'h0000005b: inst = 32'h26f70009;
30'h0000005c: inst = 32'h24100050;
30'h0000005d: inst = 32'h24080000;
30'h0000005e: inst = 32'h00000000;
30'h0000005f: inst = 32'h01104021;
30'h00000060: inst = 32'h1510004d;
30'h00000061: inst = 32'h2417000a;
30'h00000062: inst = 32'h24100030;
30'h00000063: inst = 32'h24090050;
30'h00000064: inst = 32'h24080020;
30'h00000065: inst = 32'h00000000;
30'h00000066: inst = 32'h01284023;
30'h00000067: inst = 32'h15100046;
30'h00000068: inst = 32'h2417000b;
30'h00000069: inst = 32'h24100001;
30'h0000006a: inst = 32'h24080001;
30'h0000006b: inst = 32'h00000000;
30'h0000006c: inst = 32'h24090001;
30'h0000006d: inst = 32'h00000000;
30'h0000006e: inst = 32'h01284024;
30'h0000006f: inst = 32'h1510003e;
30'h00000070: inst = 32'h2417000c;
30'h00000071: inst = 32'h24080000;
30'h00000072: inst = 32'h00000000;
30'h00000073: inst = 32'h24091010;
30'h00000074: inst = 32'h00000000;
30'h00000075: inst = 32'h01284024;
30'h00000076: inst = 32'h15000037;
30'h00000077: inst = 32'h2417000d;
30'h00000078: inst = 32'h24100001;
30'h00000079: inst = 32'h24080000;
30'h0000007a: inst = 32'h00000000;
30'h0000007b: inst = 32'h24091111;
30'h0000007c: inst = 32'h00000000;
30'h0000007d: inst = 32'h01094025;
30'h0000007e: inst = 32'h1510002f;
30'h0000007f: inst = 32'h2417000e;
30'h00000080: inst = 32'h24080000;
30'h00000081: inst = 32'h24090000;
30'h00000082: inst = 32'h00000000;
30'h00000083: inst = 32'h01094025;
30'h00000084: inst = 32'h15000029;
30'h00000085: inst = 32'h2417000f;
30'h00000086: inst = 32'h24170010;
30'h00000087: inst = 32'h24100001;
30'h00000088: inst = 32'h24080001;
30'h00000089: inst = 32'h24090000;
30'h0000008a: inst = 32'h01284026;
30'h0000008b: inst = 32'h15100022;
30'h0000008c: inst = 32'h00000000;
30'h0000008d: inst = 32'h24170011;
30'h0000008e: inst = 32'h24100001;
30'h0000008f: inst = 32'h00004027;
30'h00000090: inst = 32'h1608001d;
30'h00000091: inst = 32'h00000000;
30'h00000092: inst = 32'h24170012;
30'h00000093: inst = 32'h00174027;
30'h00000094: inst = 32'h14080019;
30'h00000095: inst = 32'h00000000;
30'h00000096: inst = 32'h24170013;
30'h00000097: inst = 32'h24100001;
30'h00000098: inst = 32'h2008ff9c;
30'h00000099: inst = 32'h24090001;
30'h0000009a: inst = 32'h0109402a;
30'h0000009b: inst = 32'h16080012;
30'h0000009c: inst = 32'h00000000;
30'h0000009d: inst = 32'h24100000;
30'h0000009e: inst = 32'h24170014;
30'h0000009f: inst = 32'h2008ff9c;
30'h000000a0: inst = 32'h24090001;
30'h000000a1: inst = 32'h0128402a;
30'h000000a2: inst = 32'h1608000b;
30'h000000a3: inst = 32'h00000000;
30'h000000a4: inst = 32'h24100001;
30'h000000a5: inst = 32'h24170015;
30'h000000a6: inst = 32'h24080001;
30'h000000a7: inst = 32'h0008402b;
30'h000000a8: inst = 32'h16080005;
30'h000000a9: inst = 32'h00000000;
30'h000000aa: inst = 32'h26f70016;
30'h000000ab: inst = 32'h0000402b;
30'h000000ac: inst = 32'h15000001;
30'h000000ad: inst = 32'h00000000;
30'h000000ae: inst = 32'ha2370000;
30'h000000af: inst = 32'ha2200000;
default:      inst = 32'h00000000;
endcase
end
endmodule
