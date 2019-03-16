----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2018 08:40:52 PM
-- Design Name: 
-- Module Name: RX_FSM - Behavioral
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

entity RX_FSM is
Port(baud_en:in STD_LOGIC;
     rst:in STD_LOGIC;
     rx,clk:in STD_LOGIC;
     rx_data:out STD_LOGIC_VECTOR(7 downto 0);
     rx_rdy: out STD_LOGIC);
end RX_FSM;

architecture Behavioral of RX_FSM is


type state_type is (idle, start, bitt, stop,waitt) ;
signal state :state_type;
signal BIT_CNT, BAUD_CNT: integer := 0;

begin
process(clk,rst,rx,bit_cnt,baud_cnt)
begin
    if rst='1' then
       state<=idle;
       bit_cnt <= 0;
       baud_cnt <= 0; 
       elsif rising_edge(clk) then
       if BAUD_EN = '1' then
       case state is
       when idle => if rx='0' then 
                        state<=start; 
                        bit_cnt <= 0;
                        baud_cnt <= 0; 
                        else 
                             bit_cnt <= 0;
                             state <= idle;
                             baud_cnt <= 0;
                    end if;
       when start => if rx='1' then 
                        state<= idle;
                        bit_cnt<=0;
                     else if baud_cnt < 7 then
                        state<= start;
                        baud_cnt <= baud_cnt + 1;
                        bit_cnt<=0;
                     else --if rx='0' and baud_cnt = 7 then
                        state<= bitt;
                        bit_cnt<=0;
                        baud_cnt <= 0;
                    -- end if;
                     end if;
                     end if;
       when bitt => if bit_cnt < 7 then 
                        state<=bitt;
                        bit_cnt <= bit_cnt + 1;
                    else if baud_cnt < 15 then
                        baud_cnt <= baud_cnt + 1;
                        state<=bitt;
                    --else if baud_cnt = 15 then
                    --   baud_cnt<=0;
                    else if bit_cnt = 7 and baud_cnt=15 then 
                        state<= stop;
                        bit_cnt<=0;
                        baud_cnt<=0;
                        rx_data(bit_cnt)<=rx;
                    end if; 
                    end if; 
                    --end if;
                    end if;             
       when stop => if baud_cnt < 15 then
                       state<=stop;
                       bit_cnt<=0;
                       baud_cnt <= baud_cnt + 1;
                    else if baud_cnt=15 then 
                       state<=waitt;
                    end if;
                    end if;
       when waitt => if baud_cnt < 7 then
                        state<= waitt;
                        bit_cnt<=0;
                        baud_cnt <= baud_cnt + 1;
                     else 
                        state<=idle;
                        baud_cnt<=0;
                     end if;
      
                        
       end case;
       end if;
       end if;
       end process;
       
 process(state,rx)
 begin
    case state is
         when idle => rx_rdy<='0';
         when start => rx_rdy<='0';
         when bitt =>  rx_rdy<='0';
         when stop => rx_rdy<='0';
         when waitt => rx_rdy<='1';
         end case;
         end process;

end Behavioral;
