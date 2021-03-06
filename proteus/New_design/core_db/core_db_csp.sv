`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
`E1OFN_M(2,11)
//`E1OFN_M(2,8)

module core_db (e1of2_11.In db8b, e1of2_11.Out datain11b);
	logic [10:0] router_data;
	logic [10:0] db_data;
	logic p1;
	logic p2;
	logic p4;
	logic [2:0] parity_bit;

	always  
		begin
			router_data = 0;
			db_data = 0;
			p1 = 0;
			p2 = 0;
			p4 = 0;
			forever begin
				// Select bit is 1, get 11-bit data from router
				db8b.Receive(router_data);
				p1 = router_data[0] ^ router_data[2] ^ router_data[4] ^ router_data[6];
				p2 = router_data[1] ^ router_data[2] ^ router_data[5] ^ router_data[6];
				p4 = router_data[3] ^ router_data[4] ^ router_data[5] ^ router_data[6];
				parity_bit = 0;
				if (p1 == 1)
				begin
					parity_bit = parity_bit + 1;
				end
				if (p2 == 1) 
				begin
					parity_bit = parity_bit + 2;
				end
				if (p4 == 1) 
				begin
					parity_bit = parity_bit + 4;
				end
				if (parity_bit != 0) 
				begin
					router_data[parity_bit-1] = ~router_data[parity_bit-1];
				end
				// Put fixed data into data bucket with 8-bits format: | 4-bit IP | 4-bit Data |
				db_data[0] = router_data[0];
				db_data[1] = router_data[1];
				db_data[2] = router_data[2];
				db_data[3] = router_data[3];
				db_data[4] = router_data[2];
				db_data[5] = router_data[4];
				db_data[6] = router_data[5];
				db_data[7] = router_data[6];
				//db_data[7:4] = {raw_data[6], raw_data[5], raw_data[4], raw_data[2]};
				datain11b.Send(db_data);
			end
		end
endmodule