library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Antirrebote is
	Port (
		inicio: in std_logic;
		clock: in std_logic;
		sensor: in std_logic;
		F: in std_logic;
		ledchek0,ledchek1: out std_logic;
		Z: out std_logic;
		E: out std_logic;
		C: out std_logic
		);
end Antirrebote;

architecture behavioral of Antirrebote is

	type nombres_estados is (FP, FN, B, A);
	signal estado: nombres_estados;
	signal entrada_aux: std_logic_vector (1 downto 0);

begin

	entrada_aux <= sensor & F;
	
process(inicio,clock,entrada_aux,estado)
begin
	if inicio='0' then --inicio es una senial de reset
		estado<=A;
	elsif rising_edge(clock) then --ck es el clock de la maquina de estados
		case estado is
			when FP =>
				case entrada_aux is
					when "00" => estado<=A;
					when "01" => estado<=A;
					when "10" => estado<=FP;
					when "11" => estado<=B;
				end case;
			when FN =>
				case entrada_aux is
					when "00" => estado<=FN;
					when "01" => estado<=A;
					when "10" => estado<=B;
					when "11" => estado<=B; 
				end case;
			when B =>
				case entrada_aux is
					when "00" => estado<=FN;
					when "01" => estado<=FN;
					when "10" => estado<=B;
					when "11" => estado<=B;
				end case;
			when A =>
				case entrada_aux is
					when "00" => estado<=A;
					when "01" => estado<=A;
					when "10" => estado<=FP;
					when "11" => estado<=FP;
				end case;
		end case;
	end if;
end process;

process(estado, entrada_aux)
begin
case estado is
		when FP =>
			ledchek0<='1';
			ledchek1<='1';
			case entrada_aux is
				when "00" =>
					Z<='0';
					E<='0';
					C<='0';
				when "01" =>
					Z<='0';
					E<='0';
					C<='0';
				when "10" =>
					Z<='0';
					E<='1';
					C<='0';
				when "11" =>
					Z<='1';
					E<='0';
					C<='0';
			end case;
		when FN =>
		ledchek0<='1';
		ledchek1<='0';
			case entrada_aux is
				when "10" =>
					Z<='0';
					E<='0';
					C<='0';
				when "01" =>
					Z<='0';
					E<='0';
					C<='0';
				when "00" =>
					Z<='0';
					E<='1';
					C<='0';
				when "11" =>
					Z<='0';
					E<='0';
					C<='0';
			end case;
		when B =>
		ledchek0<='0';
		ledchek1<='0';
			case entrada_aux is
				when "00" =>
					Z<='0';
					E<='1';
					C<='0';
				when "01" =>
					Z<='0';
					E<='1';
					C<='0';
				when "10" =>
					Z<='0';
					E<='0';
					C<='1';
				when "11" =>
					Z<='0';
					E<='0';
					C<='1';
			end case;
		when A =>
		ledchek0<='0';
		ledchek1<='1';
			case entrada_aux is
				when "10" =>
					Z<='0';
					E<='1';
					C<='0';
				when "11" =>
					Z<='0';
					E<='1';
					C<='0';
				when "00" =>
					Z<='0';
					E<='0';
					C<='1';
				when "01" =>
					Z<='0';
					E<='0';
					C<='1';
		end case;
	end case;
end process;
end behavioral;