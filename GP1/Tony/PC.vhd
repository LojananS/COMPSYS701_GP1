library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is 
    port(
        -- PC inputs
        clk : in std_logic;
        reset : in std_logic;
        pc_write : in std_logic;
        
        -- mux
        mux_sel : in std_logic_vector(1 downto 0);
        rx : in std_logic_vector(15 downto 0);
        ir_op : in std_logic_vector(15 downto 0);

        -- PC output
        pc_out : out std_logic_vector(15 downto 0);
    );
end PC;

architecture beh of PC is
    signal pc_reg : std_logic_vector(15 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');
        elsif rising_edge(clk) then
            if pc_write = '1' then
                case mux_sel is
                    when "00" => pc_reg <= rx;
                    when "01" => pc_reg <= ir_op;
                    when "10" => pc_reg <= std_logic_vector(unsigned(pc_reg) + 1);
                    when others => pc_reg <= pc_reg;
                end case;
            end if;
        end if;
    end process;
end beh;


