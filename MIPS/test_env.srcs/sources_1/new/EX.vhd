----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2018 10:16:06 AM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
 Port(pc:in STD_LOGIC_VECTOR(15 downto 0);
      rd1:in STD_LOGIC_VECTOR(15 downto 0);
      rd2:in STD_LOGIC_VECTOR(15 downto 0);
      imm:in STD_LOGIC_VECTOR(15 downto 0);
      AluOp,func:in STD_LOGIC_VECTOR(2 downto 0);
      sa:in STD_LOGIC;
      AluSrc:in STD_LOGIC;
      AdrBranch:out STD_LOGIC_VECTOR(15 downto 0);
      AluRez:out STD_LOGIC_VECTOR(15 downto 0);
      zero:out STD_LOGIC
 );
end EX;

architecture Behavioral of EX is
signal operation:STD_LOGIC_VECTOR(2 downto 0);
signal rez,val:STD_LOGIC_VECTOR(15 downto 0);   


begin

 process(func, AluOp)
 begin
    case AluOp is
    when "000"=> case func is
                 when "000" => operation<="000";--add
                 when "001" => operation <="001";--sub
                 when "010" => operation <="010";--sll
                 when "011" => operation <="011";--slr
                 when "100" => operation <="100";--and
                 when "101" => operation <="101";--or
                 when "110" => operation <="110";--xor
                 when "111" => operation <="111";--nor
                 when others =>
                 end case;
    when "001" => operation <="000";--addi
    when "010" => operation <="000";--lw
    when "011" => operation <="000";--sw
    when "100" => operation <="001";--beq
    when "101" => operation <="100";--andi
    when "110" => operation <="101";--ori
    when "111" => operation <="001";--jump
    end case;
    end process;

val<=imm when AluSrc='1' else rd2;
    
process(operation,val,rd1,sa)
begin
    case operation is
    when "000" => rez<= val+rd1;
    when "001" => rez<= rd1-val;
    when "010" =>
    if(sa='1') then rez <= val(14 downto 0)&"0";
    end if;
    when "011" => 
    if (sa='1') then rez<="0"&val(15 downto 1);
    end if;
    when "100" => rez<= val AND rd1;
    when "101" => rez<= val OR rd1;
    when "110" => rez<= val xor rd1;
    when "111" => rez<= val nor rd1;
    when others =>
    end case;
    end process;
    
    AdrBranch<=imm+pc;
    AluRez<=rez;
    zero<= '1' when rez=x"0000" else '0';


end Behavioral;
