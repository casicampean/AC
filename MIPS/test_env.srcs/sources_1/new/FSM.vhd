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

entity FSM is
Port(TX_DATA:in STD_LOGIC_VECTOR(7 downto 0);
     TX_EN:in STD_LOGIC;
     RST:in STD_LOGIC;
     BAUD_EN: in STD_LOGIC;
     TX:out STD_LOGIC;
     TX_RDY:out STD_LOGIC);
end FSM;

architecture Behavioral of FSM is

type state_type is (idle, start, bitt, stop) ;
signal state :state_type;
begin

process(rst,tx_data,baud_en,tx_en)
begin
if rst='1' then
   state<=idle;
   TX<='1';
   TX_RDY<='1';
   elsif tx_en='1' then
        state<=start;
        TX<='0';
        TX_RDY<='0';
        elsif bit_cnt<=



end Behavioral;
