-------------------------------------------------------
-- Titel       : TB für die Filter Version 1
-------------------------------------------------------
-- Projekt     : Vorabklärung TB
-- Filename    : tb_fir_filter_V1.vhdl
-- Autor       : Stefan Foltrauer
-- Letze Änderungen : 17.10.2026
-------------------------------------------------------
-- Beschreibung: 
-- Testbench für den FIR-Filter. Sie liesst Eingangssignale von Python ein und schreibt die Ergebnisse in eine Ausgabedatei, die von Python gelesen wird.
-- Wurde für das Testen der TB in Python erstellt. Die TB vergleicht die Ergebnisse nicht mit den erwarteten Werten.
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all; --benötigt für die Ein- und Ausgabe von Textdateien

entity tb_fir_filter_V1 is
end entity;


architecture sim of tb_fir_filter_V1 is
    signal clock    : std_logic := '0';
    signal reset    : std_logic := '1';
    signal data_in  : std_logic_vector(15 downto 0);
    signal data_out : std_logic_vector(15 downto 0);
begin
    clock <= not clock after 2.5 ms;-- Sampling frequency = 200 Hz => T = 5 ms

    dut : entity work.fir_filter --Filter
        port map (
            clock    => clock,
            reset    => reset,
            data_in  => data_in,
            data_out => data_out
        );

    process
        file input_file : text open read_mode is "input_signal.txt";--Einlesen des Eingangssignals von Python

        file output_file :text open write_mode is "vhdl_output.txt";--schreiben auf die Ausgabedatei, die von Python gelesen wird

        variable input_line  : line;--spezieller Datentyp von use std.textio.all
        variable output_line : line;
        variable input_value : integer;

    begin

        data_in <= (others => '0');

        wait for 10 ms;
        reset <= '0';


        while not endfile(input_file) loop
            readline(input_file, input_line);
            read(input_line, input_value);-- Read one sample

            -- Put sample on filter input
            data_in <= std_logic_vector(to_signed(input_value, 16));

            -- One sample per clock cycle
            wait until rising_edge(clock);

            -- Wait until output is updated
            wait for 1 ns;

            -- Write filter result
            write(output_line,to_integer(signed(data_out)));
            writeline(output_file,output_line);
        end loop;

        report "Simulation finished." severity note;

        wait;

    end process;

end architecture sim;