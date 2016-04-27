
//import SystemVerilogCSP::*;

`include "svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,7)
`E1OFN_M(2,4)

module bitSlicer_csp_gold (interface in, interface dataOut, interface addressOut);
	logic [10:0] inData;
	logic [6:0] data;
	logic [3:0] address;
	always
	begin
		inData = 0;
		data = 0;
		address = 0;
		forever begin
			in.Receive(inData);
			address = inData[3:0];
			data = inData[10:4];
			dataOut.Send(data);
			addressOut.Send(address);
		end
	end
endmodule