library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    generic (N : integer := 32);
    port (
        clk       : in  std_logic;
        addr      : in  std_logic_vector(N-1 downto 0);
        en        : in std_logic;
        dout      : out std_logic_vector(N-1 downto 0)
    );
end rom;

architecture syn of rom is
    type rom_type is array (128 downto 0) of std_logic_vector(N-1 downto 0);
        
    signal ROM : rom_type := (

          56  => x"04200002", --
          52  => x"07A40002", -- 
          48  => x"ac200000", -- 
          44  => x"34200000", -- 
--          40  => x"0062082B", -- 
          40  => x"0102882B", -- 
--          36  => x"0062082A", -- 
          36  => x"0102882A", -- 
          32  => x"01028829", -- 
          --32  => x"00620829", -- 
          --28  => x"00620828", -- 
          28  => x"01028828", -- 
          24  => x"01028826", -- 
          --24  => x"00620826", -- 
          20  => x"01028825", --  
          16  => x"01028824", -- 
          --16  => x"00620824", -- 
          --12  => x"00620823", -- 
          12  => x"01028823", -- 
          8   => x"01028821", -- 
          --8   => x"00620821", -- 
          4   => x"8C08003F",
          0   => x"8c62000f", -- 
            
        
        others => x"00000000"

    );
begin

    process (clk)
    begin
       if (en = '1') then
          dout <= ROM(to_integer(unsigned(addr)));
       end if;
    end process;

end syn;