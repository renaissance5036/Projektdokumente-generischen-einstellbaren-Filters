-------------------------------------------------------
-- Titel       : TB für die Filter
-------------------------------------------------------
-- Projekt     : Vorabklärung TB
-- Filename    : tb_fir_filter.vhdl
-- Autor       : Stefan Foltrauer
-- Letze Änderungen : 17.10.2026
-------------------------------------------------------
-- Beschreibung: 
-- Testbench für den FIR-Filter. Sie liesst erwarteten Ausgangssignale von Python ein und vergleicht die Ergebnisse mit jenen von VHDL.
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all; --benötigt für die Ein- und Ausgabe von Textdateien

entity tb_fir_filter is
end entity;


architecture sim of tb_fir_filter is
    signal clock    : std_logic := '0';
    signal reset    : std_logic := '1';
    signal data_in  : std_logic_vector(15 downto 0);
    signal data_out : std_logic_vector(15 downto 0);
begin
    clock <= not clock after 2.5 ms;-- Sampling frequency = 200 Hz => T = 5 ms

    dut : entity work.fir_filter--Filter
        port map (
            clock    => clock,
            reset    => reset,
            data_in  => data_in,
            data_out => data_out
        );

    process
        file input_file :text open read_mode is "input_signal.txt";--Einlesen des Eingangssignals von Python

        file expected_file :text open read_mode is "python_output.txt";--Einlesen des erwarteten Python-Outputs

        variable input_line    : line;
        variable expected_line : line;
        variable input_value    : integer;
        variable expected_value : integer;
        variable tests_executed : integer := 0;

    begin

        data_in <= (others => '0');

        wait for 10 ms;
        reset <= '0';


        while not endfile(input_file) and not endfile(expected_file) loop

            readline(input_file, input_line);
            read(input_line, input_value);

            readline(expected_file, expected_line);
            read(expected_line, expected_value);

            data_in <= std_logic_vector(to_signed(input_value, 16));

            -- Process one sample
            wait until rising_edge(clock);

            -- Wait for output update
            wait for 1 ns;

            -- Compare VHDL output with Python result
            -- python und VHDL habe eine andere Rundung, weshalb ich eine Toleranz von 1 einführe mit
            --assert abs(to_integer(signed(data_out)) - expected_value) <= 1
            assert (abs(to_integer(signed(data_out)) - expected_value) <= 1) report"FIR mismatch: input=" &integer'image(input_value) &", expected=" &integer'image(expected_value) &", got=" &integer'image(to_integer(signed(data_out)))severity error;
            tests_executed := tests_executed + 1;
        end loop;


        report "Test finished. Number of executed tests: " &integer'image(tests_executed)severity note;
        wait;

    end process;

end architecture;