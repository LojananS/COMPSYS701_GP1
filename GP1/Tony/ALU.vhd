library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is

    generic(
        alu_add : std_logic_vector(2 downto 0) := "000";
        alu_sub : std_logic_vector(2 downto 0) := "001";
        alu_and : std_logic_vector(2 downto 0) := "010";
        alu_or : std_logic_vector(2 downto 0) := "011";
    );


    port (
        --ALU inputs
        clk : in std_logic;
        reset : in std_logic;
        carry : in std_logic;

        --mux
        ALU_op : in std_logic_vector(2 downto 0);
        ALU_sel1 : in std_logic_vector(1 downto 0);
        ALU_sel2 : in std_logic_vector(1 downto 0);
        
        rx : in std_logic_vector(15 downto 0);
        rz : in std_logic_vector(15 downto 0);
        ir_op : in std_logic_vector(15 downto 0);

        --ALU outputs
        ALU_result : out std_logic_vector(15 downto 0);
        Z : out std_logic; --zero
        N : out std_logic; -- negative
    );
end ALU;

architecture beh of ALU is
    signal op1 : signed(15 downto 0);
    signal op2 : signed(15 downto 0);
    signal result : signed(15 downto 0);
begin

    op1_select: process(ALU_sel1, rx, ir_op)
    begin
        case ALU_sel1 is
            when "00" => op1 <= signed(rx);
            when "01" => op1 <= signed(ir_op);
            when others => op1 <= (others => '0');
        end case;
    end process op1_select;

    op2_select: process(ALU_sel2, rz, ir_op)
    begin
        case ALU_sel2 is
            when "00" => op2 <= signed(rz);
            when "01" => op2 <= signed(ir_op);
            when others => op2 <= (others => '0');
        end case;
    end process op2_select;

    ALU: process(ALU_op, op1, op2)
    begin
        case ALU_op is
            when alu_add => result <= op2 + op1;
            when alu_sub => result <= op2 - op1;
            when alu_and => result <= op2 and op1;
            when alu_or => result <= op2 or op1;
            when others => result <= (others => '0');
        end case;
    end process ALU;

    ALU_result <= std_logic_vector(result);

    Z <= '1' when result = 0 else '0';
    N <= result(15); 
end beh;