----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2018 10:24:04 AM
-- Design Name: 
-- Module Name: FSM - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TX_FSM is
Port(TX_DATA:in STD_LOGIC_VECTOR(7 downto 0);
     TX_EN:in STD_LOGIC;
     RST:in STD_LOGIC;
     clk,BAUD_EN: in STD_LOGIC;
     TX:out STD_LOGIC;
     TX_RDY:out STD_LOGIC);
end TX_FSM;

architecture Behavioral of TX_FSM is

type state_type is (idle, start, bitt, stop) ;
signal state :state_type:=idle;
signal BIT_CNT: integer := 0;
begin

process(clk,rst,tx_en,bit_cnt)
begin
    if rst='1' then
       state<=idle;
       bit_cnt <= 0;
       elsif rising_edge(clk) then
       if BAUD_EN = '1' then
       case state is
       when idle => if tx_en='1' then 
                        state<=start; 
                        bit_cnt <= 0; 
                        else
                             bit_cnt <= 0;
                             state <= idle;
                    end if;
       when start => state<= bitt; bit_cnt <= 0;
       when bitt => if(bit_cnt = 7) then
                       state <=stop;
                    else
                       bit_cnt <= bit_cnt +1;
                       state <= bitt;
                    end if;           
       when stop => state<= idle; bit_cnt <= 0;
       end case;
       end if;
       end if;
       end process;
       
 process(state,tx_data)
 begin
    case state is
         when idle => tx<='1'; tx_rdy<='1';
         when start => tx<='0'; tx_rdy<='0';
         when bitt => tx <= tx_data(bit_cnt); tx_rdy<='0';
         when stop => tx<='1'; tx_rdy<= '0';
         end case;
         end process;
 




end Behavioral;
