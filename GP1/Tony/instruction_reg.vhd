library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_register is
    port(
        -- IR inputs
        clk : in std_logic;
        reset : in std_logic;
        ir_write : in std_logic;
        check_am : in std_logic;
        ir_in : in std_logic_vector(15 downto 0);

        -- IR outputs
        ir_op : out std_logic_vector(15 downto 0);
        ir_rx : out std_logic_vector(3 downto 0);
        ir_rz : out std_logic_vector(3 downto 0);
        ir_opcode : out std_logic_vector(5 downto 0);
        ir_am : out std_logic_vector(1 downto 0)
    );
end instruction_register;

architecture beh of instruction_register is
    signal instr_reg : std_logic_vector(31 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            instr_reg <= (others => '0');
        elsif rising_edge(clk) then
            if ir_write = '1' then
                if check_am = '0' then
                    instr_reg(19 downto 16) <= ir_in(3 downto 0);    -- Rx
                    instr_reg(23 downto 20) <= ir_in(7 downto 4);    -- Rz
                    instr_reg(29 downto 24) <= ir_in(13 downto 8);   -- Opcode
                    instr_reg(31 downto 30) <= ir_in(15 downto 14);  -- AM
                else
                    instr_reg(15 downto 0) <= ir_in; -- op
                end if;
            end if;
        end if;
    end process;

    ir_op <= instr_reg(15 downto 0);
    ir_rx <= instr_reg(19 downto 16);
    ir_rz <= instr_reg(23 downto 20);
    ir_opcode <= instr_reg(29 downto 24);
    ir_am <= instr_reg(31 downto 30);
end beh;
