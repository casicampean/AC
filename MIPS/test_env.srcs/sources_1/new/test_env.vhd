-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           rx: in STD_LOGIC;
           tx:out STD_LOGIC);
end test_env;

architecture Behavioral of test_env is

type RAM_type is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal RAM:RAM_type:=(
0=>x"0001",
1=>x"0002",
2=>x"0003",
others=>x"0000");

signal count,count_rx,count2,rd1,rd2,ext_imm:STD_LOGIC_VECTOR(15 downto 0);
signal buton, buton1,buton2,wrReg, BAUD_EN,fsm_en,TX_EN,rst,tx_rdy:STD_LOGIC:='0';
signal BAUD_EN_rx,rx_rdy:STD_LOGIC:='0';
signal rx_data:STD_LOGIC_VECTOR(7 downto 0);
signal data2:STD_LOGIC_VECTOR(15 downto 0);
signal sum,rd,mux,data,rez:STD_LOGIC_VECTOR(15 downto 0);
signal JAdr,Branch,dig,instr:STD_LOGIC_VECTOR(15 downto 0);
signal rdd1,rdd2,rdd3:STD_LOGIC_VECTOR(15 downto 0);
signal br,wr,zero,regDest,regWrite,MemWr,PcSrc,AluSrc,memRead,memToReg,AluOp,Jump,ext_op,sa:STD_LOGIC:='0';
signal opcode,func:STD_LOGIC_VECTOR(2 downto 0);
signal address:STD_LOGIC_VECTOR(3 downto 0);
signal id_ex_instr, ex_mem_instr,mem_wb_instr:STD_LOGIC_VECTOR(15 downto 0);
signal if_id_pc, if_id_instr,id_ex_pc,id_ex_rd1,id_ex_rd2,id_ex_imm:STD_LOGIC_VECTOR(15 downto 0);
signal ex_mem_branch,id_ex_branch, ex_mem_rez, ex_mem_rd2,mem_wb_rd,mem_wb_rez:STD_LOGIC_VECTOR(15 downto 0);
signal id_ex_ex:STD_LOGIC_VECTOR(4 downto 0);
signal id_ex_wb, id_ex_m,ex_mem_wb,mem_wb_wb ,ex_mem_m:STD_LOGIC_VECTOR(1 downto 0);
signal id_ex_func, id_ex_rt,id_ex_rd:STD_LOGIC_VECTOR(2 downto 0);
signal ex_mem_zero,id_ex_sa:STD_LOGIC;

component MPG
Port(en:out STD_LOGIC;
     input:in STD_LOGIC;
     clk:in STD_LOGIC);    
end component;

component SSD 
   Port ( clk:in STD_LOGIC;
          digit:in STD_LOGIC_VECTOR(15 downto 0);
          an: out STD_LOGIC_VECTOR(3 downto 0);
          cat:out STD_LOGIC_VECTOR(6 downto 0));
end component;
component reg_file 
Port(clk:in STD_LOGIC;
     reg1:in STD_LOGIC_VECTOR(3 downto 0);
     reg2:in STD_LOGIC_VECTOR(3 downto 0);
     wa:in STD_LOGIC_VECTOR(3 downto 0);
     wd : in std_logic_vector (15 downto 0);
     wen : in std_logic;
     rd1 : out std_logic_vector (15 downto 0);
     rd2 : out std_logic_vector (15 downto 0));
end component;

component Instr_Fetch is
    Port(buton:in STD_LOGIC;
         clk:in STD_LOGIC;
         PcSrc:in STD_LOGIC;
         Jump:in STD_LOGIC;
         BrAdr : in STD_LOGIC_VECTOR (15 downto 0);
         JumpAdr : in STD_LOGIC_VECTOR (15 downto 0);
         Instr:out STD_LOGIC_VECTOR (15 downto 0);
         count2:out STD_LOGIC_VECTOR (15 downto 0));
end component;


component ID is
   Port(clk:in STD_LOGIC;
       instr:in STD_LOGIC_VECTOR(15 downto 0);
       wd:in STD_LOGIC_VECTOR(15 downto 0);
       regWrite:in STD_LOGIC;
       regDest:in STD_LOGIC;
       extOpt:in STD_LOGIC;
       rd1:out STD_LOGIC_VECTOR(15 downto 0);
       rd2:out STD_LOGIC_VECTOR(15 downto 0);
       ext_imm:out STD_LOGIC_VECTOR(15 DOWNTO 0);
       opcode:out STD_LOGIC_VECTOR(2 downto 0);
       func:out STD_LOGIC_VECTOR(2 downto 0);
       sa:out STD_LOGIC);
end component;

component EX is
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
end component;
component RAM_mem is
port ( clk : in std_logic;
       wr : in std_logic;
       adr : in std_logic_vector(3 downto 0);
       wd : in std_logic_vector(15 downto 0);
       rd : out std_logic_vector(15 downto 0));
end component;

component TX_FSM is
Port(TX_DATA:in STD_LOGIC_VECTOR(7 downto 0);
     TX_EN:in STD_LOGIC;
     RST:in STD_LOGIC;
     clk,BAUD_EN: in STD_LOGIC;
     TX:out STD_LOGIC;
     TX_RDY:out STD_LOGIC);
end component;

component RX_FSM is
Port(baud_en:in STD_LOGIC;
     rst:in STD_LOGIC;
     rx,clk:in STD_LOGIC;
     rx_data:out STD_LOGIC_VECTOR(7 downto 0);
     rx_rdy: out STD_LOGIC);
end component;

begin

--led<=sw;
--an<=btn;
--cat<=(others=>'0');
--sum<=rd1+rd2;
--address<=ex_mem_rez(3 downto 0);
--wr<=buton and memWr;
--wrReg<=buton and  mem_wb_wb(0);
----data<=mem_wb_rd when mem_wb_wb(1)='1' else mem_wb_rez;
--PCSrc<=ex_mem_m(0) and ex_mem_zero;
--JAdr<="000"&if_id_instr(12 downto 0);

pp1:MPG port map(fsm_en,btn(0),clk);
mpg1:MPG port map(rst,btn(1),clk);

--tx_fsm1: TX_FSM port map(sw(7 downto 0),tx_en,rst,clk,baud_en, tx, tx_rdy);
rx_fsm1: RX_FSM port map(baud_en,rst,rx,clk,rx_data,rx_rdy);
pp2:SSD port map(clk,data2,an,cat);

data2<="00000000"&rx_data;
--pp4:Instr_Fetch port map(buton,clk,PcSrc,Jump,ex_mem_branch,JAdr,instr,count2);
--pp5:ID port map(clk,if_id_instr,data,wrReg,RegDest,ext_op,rd1,rd2,ext_imm,opcode,func,sa);
--pp6:EX port map(id_ex_pc,id_ex_rd1,id_ex_rd2,id_ex_imm,id_ex_ex(4 downto 2),id_ex_func,id_ex_sa,id_ex_ex(1),Branch,Rez,zero);
--pp7:RAM_mem port map(clk,memWr,address,ex_mem_rd2,rd);
--process(clk,buton)
--begin
    --if rising_edge(clk) then
     -- if buton='1' then

      --     count<=count+1;
      --end if;
   -- end if;
  --end process;
  
  --dig<=ROM(conv_integer(count));
  --dig<=rdd3(13 downto 0)&"00";
  --dig<=dig2 when sw(7)='0' else count2;
  
  
    --000    R
    --001    ADDI 
    --010    LW
    --011    SW
    --100    BEQ
    --101    AND
    --110    OR
    --111    J    

--led(7) <= zero;led(6) <= Jump;led(5) <= RegDest; led(4) <= regWrite; led(3) <= PcSrc; led(2) <= MemWr; led(1) <= AluSrc; led(0) <= memToReg;
--  process(if_id_instr(15 downto 13))
--  begin
--  case if_id_instr(15 downto 13) is
--  when "000" => RegDest <= '1';regWrite<='1';br<='0';Jump<='0';ext_op<='0';MemWr<='0';AluSrc<='0';memToReg<='0';
--  when "001" => RegDest <= '0';regWrite<='1';br<='0';Jump<='0';ext_op<='0';MemWr<='0';AluSrc<='1';memToReg<='0';
--  when "010" => RegDest <= '0';regWrite<='1';br<='0';Jump<='0';ext_op<='0';MemWr<='0';AluSrc<='1';memToReg<='1';
--  when "011" => RegDest <= '0';regWrite<='0';br<='0';Jump<='0';ext_op<='0';MemWr<='1';AluSrc<='1';memToReg<='0';
--  when "100" => RegDest <= '0';regWrite<='0';br<='1';Jump<='0';ext_op<='0';MemWr<='0';AluSrc<='0';memToReg<='0';
--  when "101" => RegDest <= '0';regWrite<='1';br<='0';Jump<='0';ext_op<='0';MemWr<='0';AluSrc<='1';memToReg<='0';
--  when "110" => RegDest <= '0';regWrite<='1';br<='0';Jump<='0';ext_op<='0';MemWr<='0';AluSrc<='1';memToReg<='0';
--  when "111" => RegDest <= '0';regWrite<='0';br<='0';Jump<='1';ext_op<='0';MemWr<='0';AluSrc<='0';memToReg<='0';
--  when others=>
--  end case;
--  end process;
  
--process(sw(2 downto 0),rd1,rd2,instr,count2,sum,ext_imm)
--  begin
--     case sw(2 downto 0) is
--     when "000" => mux<=count2;
--     when "001" => mux<=instr;
--     when "010" => mux<=rd1;
--     when "011" => mux<=rd2;
--     when "100" => mux<=ext_imm;
--     when "101" => mux<=Rez;
--     when "110" => mux<=data;
--     when "111" => mux<=rd;
--    end case;
  
--  end process; 

-- process(clk)
-- begin 
-- if rising_edge(clk) then
-- --if buton='1' then
 
--   -- Reg IF/ID
 
-- if_id_pc<=count2;
-- if_id_instr<=instr;

-- --Reg ID_EX
 
-- id_ex_instr<=if_id_instr;
-- id_ex_wb(1)<=memToReg;
-- id_ex_wb(0)<=regWrite;
-- id_ex_m(1)<=MemWr;
-- id_ex_m(0)<=br;
-- id_ex_ex(4 downto 2)<=opcode;
-- id_ex_ex(1)<=AluSrc;
-- --id_ex_ex(0)<=RegDest;
-- id_ex_pc<=if_id_pc;
-- id_ex_rd1<=rd1;
-- id_ex_rd2<=rd2;
-- id_ex_imm<=ext_imm;--vine din ExtOpt care este out ID 
-- id_ex_func<=if_id_instr(2 downto 0);
-- id_ex_rt<=if_id_instr(9 downto 7);
-- id_ex_rd<=if_id_instr(6 downto 4);
-- id_ex_sa<=if_id_instr(3);
 
-- -- Reg EX/MEM

-- ex_mem_instr<=id_ex_instr;
-- ex_mem_wb<=id_ex_wb;
-- ex_mem_m<=id_ex_m;
-- ex_mem_branch<=Branch;
-- ex_mem_zero<=zero;
-- ex_mem_rez<=Rez;
-- ex_mem_rd2<=id_ex_rd2;

-- -- Reg MEM/WB

-- mem_wb_instr<=id_ex_instr;
-- mem_wb_wb<=ex_mem_wb;
-- mem_wb_rd<=rd;
-- mem_wb_rez<=ex_mem_rez;
-- end if;
---- end if;
-- end process;
 
 
 
 
  
  
  
  
  
--  process(clk)
--         begin
--             if rising_edge(clk) then
--             if count = "0010100010101111" then -- 10416-1
--                 BAUD_EN <= '1';
--                 count <= (others => '0');
                 
--             else count <= count + 1;
--                   BAUD_EN <= '0';
--             end if;
--             end if;
--     end process;
     
       process(clk)
            begin
                if rising_edge(clk) then
                if count_rx = "1010001011" then -- 651
                    BAUD_EN <= '1';
                    count_rx <= (others => '0');
                    
                else count_rx <= count_rx + 1;
                      BAUD_EN <= '0';
                end if;
                end if;
        end process;
  
  
     process (clk, BAUD_EN, fsm_en)
          begin
          
              if rising_edge(clk) then
                  if (BAUD_EN = '1') then 
                      TX_EN <= '0';
                  elsif (fsm_en = '1') then
                      TX_EN <= '1';
                  end if;
          end if;
      end process;
  
  --led <= sw;
  --cat <= "1111111";
  --an <= "1111";

--process(count)
--begin
--     case count is
--         when "00"=> rez(7 downto 0)<=sw(15 downto 8)+sw(7 downto 0);
--         when "01"=> rez(7 downto 0)<=sw(15 downto 8)-sw(7 downto 0);
--         when "10"=> rez<=sw(13 downto 0)&"00";
--         when "11"=> rez<="00"&sw(15 downto 2);
--     end case;
--end process;
end Behavioral;