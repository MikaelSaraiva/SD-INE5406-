library ieee;
use ieee.std_logic_1164.all;

entity portaoGaragem is
	port(
		-- sinais de controle de entrada 
		clk, reset: in std_logic;
		-- sinais de dados de entrada
		SA, SF, SO, CR: in std_logic;
		-- sinais de dados de saida
		M: out std_logic_vector(1 downto 0)
	);
end entity;

architecture formaCononica of portaoGaragem is
	type InternalState is (ABERTO, ABRINDO, FECHADO, FECHANDO); -- mudar conforme o estado interno
	signal next_state, state_reg: InternalState;
begin
	-- next-state logic (combinatorial)
	process(SA, SF, SO, CR)
	begin
	
	next_state <= state_reg;
	case state_reg is 
		when ABERTO =>
			if CR = '1' then
				next_state <= FECHANDO;
			end if;
		when ABRINDO =>
			if SA = '1' then 
				next_state <= ABERTO;
			end if;
		when FECHADO =>		
			if CR = '1' then
				next_state <= ABRINDO;
			end if;
		when FECHANDO =>
			if SO = '1' then
				next_state <= ABRINDO;
			elsif SF = '1' then
				next_state <= FECHADO;
			end if;				
	end case;
	end process;
	-- memory element -- internal state
	process(clk, reset)
	begin
		if reset='1' then
			state_reg <= FECHANDO; --
		elsif rising_edge(clk) then
			state_reg <= next_state;
		end if;
	end process;
	
	-- output-logic (combinatorial)
	with state_reg select
	M <= 	"01" when ABRINDO,
			"10" when FECHANDO,
			"00" when others;
end architecture;





