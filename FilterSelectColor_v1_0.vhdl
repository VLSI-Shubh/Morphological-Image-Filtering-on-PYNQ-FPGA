library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FilterSelect_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXIS
		C_S00_AXIS_TDATA_WIDTH	: integer	:= 32;

		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M00_AXIS_START_COUNT	: integer	:= 32
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line
        sw_0: in std_logic;
        sw_1: in std_logic;

		-- Ports of Axi Slave Bus Interface S00_AXIS
		s00_axis_aclk	: in std_logic;
		s00_axis_aresetn	: in std_logic;
		s00_axis_tready	: out std_logic;
		s00_axis_tdata	: in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
		s00_axis_tstrb	: in std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		s00_axis_tlast	: in std_logic;
		s00_axis_tvalid	: in std_logic;

		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_aclk	: in std_logic;
		m00_axis_aresetn	: in std_logic;
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		m00_axis_tstrb	: out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m00_axis_tlast	: out std_logic;
		m00_axis_tready	: in std_logic
	);
end FilterSelect_v1_0;

architecture arch_imp of FilterSelect_v1_0 is



--Color R
component FilterSelectColorR IS
PORT (
    clk		:	IN STD_LOGIC;
    rst		: 	IN STD_LOGIC;
--    load	: 	IN  STD_LOGIC;
    run		:  IN	STD_LOGIC;
    x_inputR  :  IN SIGNED(8 DOWNTO 0);
    --coef_input	: 	IN SIGNED(8 DOWNTO 0);
    switch_0 : IN STD_LOGIC;
    switch_1 : IN STD_LOGIC;

    yR			: 	OUT SIGNED(8 DOWNTO 0)
);
END component;


--Color G

component FilterSelectColorG IS
PORT (
    clk		:	IN STD_LOGIC;
    rst		: 	IN STD_LOGIC;
--    load	: 	IN  STD_LOGIC;
    run		:  IN	STD_LOGIC;
    x_inputG  :  IN SIGNED(8 DOWNTO 0);
    --coef_input	: 	IN SIGNED(8 DOWNTO 0);
    switch_0 : IN STD_LOGIC;
    switch_1 : IN STD_LOGIC;

    yG			: 	OUT SIGNED(8 DOWNTO 0)
);
END component;

--Color B

component FilterSelectColorB IS
PORT (
    clk		:	IN STD_LOGIC;
    rst		: 	IN STD_LOGIC;
--    load	: 	IN  STD_LOGIC;
    run		:  IN	STD_LOGIC;
    x_inputB  :  IN SIGNED(8 DOWNTO 0);
    --coef_input	: 	IN SIGNED(8 DOWNTO 0);
    switch_0 : IN STD_LOGIC;
    switch_1 : IN STD_LOGIC;

    yB			: 	OUT SIGNED(8 DOWNTO 0)
);
END component;

----------------------------
-- INTERNAL SIGNALS:
signal run: std_logic;
--signal coef_input_signed_horizontal	: signed(8 downto 0) := "000000000";
--signal coef_input_signed_vertical : signed(8 downto 0) := "000000000";
signal sobel_inR :  signed(8 DOWNTO 0) := "000000000";
signal sobel_inG :  signed(8 DOWNTO 0) := "000000000";
signal sobel_inB :  signed(8 DOWNTO 0) := "000000000";

Signal TempR:  signed(7 DOWNTO 0);
Signal TempG:  signed(7 DOWNTO 0);
Signal TempB:  signed(7 DOWNTO 0);

signal out_dataR :  signed(8 DOWNTO 0);
signal out_dataG :  signed(8 DOWNTO 0);
signal out_dataB :  signed(8 DOWNTO 0);

signal data_sobelR : std_logic_vector(8 downto 0);
signal data_sobelG : std_logic_vector(8 downto 0);
signal data_sobelB : std_logic_vector(8 downto 0);

signal data_outR: STD_LOGIC_VECTOR(7 downto 0);
signal data_outG: STD_LOGIC_VECTOR(7 downto 0);
signal data_outB: STD_LOGIC_VECTOR(7 downto 0);

signal switch_0: std_logic;
signal switch_1: std_logic;


-------------------------------

begin


--MorphFIlterR
Morph_FilterR : FilterSelectColorR 
port map (
    clk=>s00_axis_aclk,
    rst=>s00_axis_aresetn,
    run=>run,
--    load=>load,
    x_inputR=>sobel_inR(8 downto 0),
    switch_0=>switch_0,
    switch_1=>switch_1,
--    x_input  => sobel_in,  -- testing vertical 
 --   coef_input=>coef_input_signed_vertical,
    yR=>out_dataR
    );

--MorphFIlterG	
Morph_FilterG : FilterSelectColorG
port map (
    clk=>s00_axis_aclk,
    rst=>s00_axis_aresetn,
    run=>run,
--    load=>load,
    x_inputG=>sobel_inG(8 downto 0),
    switch_0=>switch_0,
    switch_1=>switch_1,
--    x_input  => sobel_in,  -- testing vertical 
 --   coef_input=>coef_input_signed_vertical,
    yG=>out_dataG
    );

--MorphFIlterB	
Morph_FilterB : FilterSelectColorB
port map (
    clk=>s00_axis_aclk,
    rst=>s00_axis_aresetn,
    run=>run,
--    load=>load,
    x_inputB=>sobel_inB(8 downto 0),
    switch_0=>switch_0,
    switch_1=>switch_1,
--    x_input  => sobel_in,  -- testing vertical 
 --   coef_input=>coef_input_signed_vertical,
    yB=>out_dataB
    );

--- connecting filter inputs and outputs to Stream data components
switch_0 <= sw_0;
switch_1 <= sw_1;
TempB<=SIGNED(s00_axis_tdata(7 downto 0));
TempG<=SIGNED(s00_axis_tdata(15 downto 8));
TempR<=SIGNED(s00_axis_tdata(23 downto 16));

sobel_inB<= "0" & TempB;
sobel_inG<= "0" & TempG;
sobel_inR<= "0" & TempR;

data_sobelR<=STD_LOGIC_VECTOR(out_dataR);
data_sobelG<=STD_LOGIC_VECTOR(out_dataG);
data_sobelB<=STD_LOGIC_VECTOR(out_dataB);

data_outR <= data_sobelR(7 downto 0);
data_outG <= data_sobelG(7 downto 0);
data_outB <= data_sobelB(7 downto 0);

m00_axis_tdata <= "00000000" & data_outR & data_outG & data_outB;

--- run signal comes from tvalid on the slave (input) 
run<=s00_axis_tvalid;

-- connect through the other AXIS signals from Slave to Master:
m00_axis_tvalid <= s00_axis_tvalid;
m00_axis_tstrb <= s00_axis_tstrb;
m00_axis_tlast <= s00_axis_tlast;
s00_axis_tready <= m00_axis_tready;
	-- User logic ends


end arch_imp;