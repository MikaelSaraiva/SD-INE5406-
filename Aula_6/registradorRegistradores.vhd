library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registradorRegistradores is
	generic(
		NumBitsEnderReg: positive := 5;
		Largurareg: positive := 32
	);
	port(
		-- sinais de controle de entrada 
		clk, reset: in std_logic;
		EscReg: in std_logic;
		-- sinais de dados de entrada
		Reg_ser_lido_1, Reg_ser_lido_2, Reg_ser_escrito: in std_logic_vector(NumBitsEnderReg-1 downto 0);
		Dado_escrita: in std_logic_vector(Largurareg-1 downto 0);
		-- sinais de dados de saida
		Dado_lido_1, Dado_lido_2: out std_logic_vector(Largurareg-1 downto 0)
	
	);
end entity;

architecture formaCononica of registradorRegistradores is
	type InternalState is array(0 to 2**NumBitsEnderReg-1) of std_logic_vector(Largurareg-1 downto 0);
	signal next_state, state_reg: InternalState;
begin
	-- next-state logic (combinatorial)
	laco: for i in next_state'range generate
			next_state(i) <= 	Dado_escrita when EscReg = '1' and unsigned(Reg_ser_escrito) = i else
							state_reg(i);
			end generate;
	
	-- memory element -- internal state
	process(clk, reset)
	begin
		if reset='1' then
			laco_reset: for i in state_reg'range loop
			state_reg(i) <= (others =>'0'); --
		end loop;
		elsif rising_edge(clk) then
			state_reg <= next_state;
		end if;
	end process;
	
	-- output-logic (combinatorial)
	Dado_lido_1 <= state_reg(to_integer(unsigned(Reg_ser_lido_1)));
	Dado_lido_2 <= state_reg(to_integer(unsigned(Reg_ser_lido_2)));
	
end architecture;