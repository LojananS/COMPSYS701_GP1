LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY prog_mem IS
	PORT(
		address	:	IN STD_LOGIC_VECTOR(9 DOWNTO 0);	-- 1024 address locations stated by Zoran
		clock	:	IN STD_LOGIC	:= '1';
		q	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0)	-- 32 bits for Program Memory output to IR
	);
END ENTITY prog_mem;

ARCHITECTURE SYN OF prog_mem IS
	
	SIGNAL sub_wire	:	STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	COMPONENT altsyncram
	GENERIC(
		clock_enable_input_a	: STRING;
		clock_enable_output_a	: STRING;
		init_file		: STRING;
		intended_device_family	: STRING;
		lpm_hint		: STRING;
		lpm_type		: STRING;
		maximum_depth		: NATURAL;
		numwords_a		: NATURAL;
		operation_mode		: STRING;
		outdata_aclr_a		: STRING;
		outdata_reg_a		: STRING;
		ram_block_type		: STRING;
		widthad_a		: NATURAL;
		width_a			: NATURAL;
		width_byteena_a		: NATURAL
	);
	
	PORT(
		address_a	: IN STD_LOGIC_VECTOR(9 DOWNTO 0);	-- 10 bits (1024) for address locations
		clock0		: IN STD_LOGIC;
		q_a		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)	-- 32 bits for output to IR
	);
	END COMPONENT;
BEGIN

	q <= sub_wire(31 DOWNTO 0);

	ram_component : altsyncram					-- Memory IP core from Intel FPGA Quartus
	GENERIC MAP(
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "",					-- Specify the program mif file to initialize
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		maximum_depth => 1024,					-- Changed to 1024 since 1024 address locations
		numwords_a => 32768,					-- idk if I should change this? Leave it for now
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		ram_block_type => "M4K",
		widthad_a => 10,					-- Address width is 10 bits because 2^10 is 1024
		width_a => 32,						-- Data width is 32 bits
		width_byteena_a => 1
	)

	PORT MAP(
		address_a => address,
		clock0 => clock,
		q_a => sub_wire
	);

END ARCHITECTURE SYN;