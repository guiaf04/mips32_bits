library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_mips.all;

entity datapath is
  Port ( 
    clk, rst : std_logic;
    instruction : in reg32;
    d_address : out reg32;
    uins : in microinstruction;
    data : inout reg32;
    zero, carry : out std_logic;
    ram_in: out std_logic_vector(31 downto 0);
    ram_out: in std_logic_vector(31 downto 0)
  );
end datapath;

architecture Behavioral of datapath is
    signal R1, R2, result, reg_dest, op2, ext32 : reg32;
    signal instR: std_logic;
    signal adD : std_logic_vector(4 downto 0);
begin
    -- Detector de instruções do tipo R
    instR <= '1' when uins.i=ADDU or uins.i=SUBU or uins.i=AAND or 
                      uins.i=OOR  or uins.i=XXOR or uins.i=NNOR or 
                      uins.i=SSHL or uins.i=SSHR or uins.i=RROL or uins.i=RROR else '0';
    -- Multiplexador 1
    M1 : adD <= instruction(15 downto 11) when instR='1' else instruction(20 downto 16);
    
    REGS : entity work.bancoRegistradores
        port map(
            clk=>clk, 
            rst=>rst, 
            ce=>uins.wreg,
            AdRP1=>instruction(25 downto 21), 
            AdRP2=>instruction(20 downto 16), 
            AdWP=>adD,
            DataWP=>reg_dest,
            DataRP1=>R1, 
            DataRP2=>R2);
            
    -- Multiplexador 2
    M2 : ext32 <= x"FFFF" & instruction(15 downto 0) when (instruction(15)='1' and
                  (uins.i=LW or uins.i=SW)) else
                  x"0000" & instruction(15 downto 0);
    -- Multiplexador 3
    M3 : op2 <= R2 when instR='1' else ext32;
    
    inst_ula : entity work.ula
        port map(
            op1=>R1, 
            op2=>op2,
            outula=>result,
            zero=>zero,
            carry =>carry,
            op_ula=>uins.i
        );
    -- Multiplexador 4
    d_address <= result;
    
    WMem : data <= R2 when uins.rw='0' and uins.ce='1' else ext32 when uins.i=LW else 
          ram_out when uins.i=POP else(others=>'Z'); 
    
    M4 : reg_dest <= data when uins.i=LW  or uins.i=POP else result;
    
    ram_in <= data;
end Behavioral;
