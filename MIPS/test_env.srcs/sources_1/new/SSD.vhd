----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2018 10:18:08 AM
-- Design Name: 
-- Module Name: SSD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
   Port ( clk:in STD_LOGIC;
          digit:in STD_LOGIC_VECTOR(15 downto 0);
          an: out STD_LOGIC_VECTOR(3 downto 0);
          cat:out STD_LOGIC_VECTOR(6 downto 0));
end SSD;

architecture Behavioral of SSD is

signal counter:STD_LOGIC_VECTOR(15 downto 0);
signal counter_out:STD_LOGIC_VECTOR(1 downto 0);
signal to_hex:STD_LOGIC_VECTOR(3 downto 0);

begin

counter_out<=counter(15 downto 14);
process(clk)
begin
   if clk='1' and clk'event then
   counter<=counter+1;
   end if;
   end process;
   
    process (counter_out,digit(15 downto 0))
   begin
         case counter_out is
           when "00" => to_hex <=digit(3 downto 0);
           when "01" => to_hex <=digit(7 downto 4);
           when "10" => to_hex <=digit(11 downto 8);
           when "11" => to_hex <=digit(15 downto 12);
           end case;
   end process;    
   
process (counter_out)
   begin
      case counter_out is
         when "00" => an <="1110";
         when "01" => an <="1101";
         when "10" => an <="1011";
         when "11" => an <="0111";
         end case;
         end process;
     process (to_hex)
         begin
            case to_hex is
                     when "0001" => cat <= "1111001";
                     when "0010" => cat <= "0100100";
                     when "0011" => cat <= "0110000";
                     when "0100" => cat <= "0011001";
                     when "0101" => cat <= "0010010";
                     when "0110" => cat <= "0000010";
                     when "0111" => cat <= "1111000";
                     when "1000" => cat <= "0000000";
                     when "1001" => cat <= "0010000";
                     when "1010" => cat <= "0001000";
                     when "1011" => cat <= "0000011";
                     when "1100" => cat <= "1000110";
                     when "1101" => cat <= "0100001";
                     when "1110" => cat <= "0001110";
                     when "1111" => cat <= "0001110";
                     when others => cat <= "1000000";
                 end case;
               end process;   

end Behavioral;
