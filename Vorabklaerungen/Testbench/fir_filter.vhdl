-------------------------------------------------------
-- Titel       : FIR-Filter 
-------------------------------------------------------
-- Projekt     : Vorabklärung TB
-- Filename    : fir_filter.vhdl
-- Autor       : Stefan Foltrauer
-- Letze Änderungen : 17.10.2026
-------------------------------------------------------
-- Beschreibung: 
-- Einfacher Versuchsfilter welcher noch nicht synthetisierbar ist.
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_filter is
    port (
        clock    : in  std_logic;
        reset    : in  std_logic;
        data_in  : in  std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(15 downto 0)
    );
end entity fir_filter;


architecture rtl of fir_filter is

    type t_coefficients is array (0 to 2) of real;
    constant Num : t_coefficients := (0.25, 0.50, 0.25); --Filter coefficients for a simple FIR filter
    signal s_x1 : signed(15 downto 0);
    signal s_x2 : signed(15 downto 0);

begin

    process(clock, reset)
        variable v_result : real;
        variable v_output : integer;
    begin
        if reset = '1' then
            s_x1 <= (others => '0');
            s_x2 <= (others => '0');
            data_out <= (others => '0');
        elsif rising_edge(clock) then
            -- Der Filter wird mit der Formel y[n] = b0*x[n] + b1*x[n-1] + b2*x[n-2] implementiert als Impulsantwort.
            -- Das ist ein Versuchsfilter und es spielt noch keine Rolle ob der Filter synthetisierbar ist. 
            -- Das Ziel ist es die TB auszutesten und die Ergebnisse mit Python zu vergleichen.
            v_result :=real(to_integer(signed(data_in))) * Num(0) +real(to_integer(s_x1))* Num(1) +real(to_integer(s_x2))            * Num(2);
            v_output := integer(v_result);
            data_out <= std_logic_vector(to_signed(v_output, 16));

            s_x2 <= s_x1;
            s_x1 <= signed(data_in);

        end if;
    end process;
end architecture rtl;