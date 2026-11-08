-------------------------------------------------------
-- Titel       : Einleseregister für Koeffizienten
-------------------------------------------------------
-- Projekt     : Design eines generischen, einstellbaren Filters für die digitale Verarbeitung biologischer Signale
-- Filename    : register.vhdl
-- Autor       : Stefan Foltrauer
-- Letze Änderungen : 17.10.2026
-------------------------------------------------------
-- Beschreibung: 
-- Einleseregister für Koeffizienten für den SPI-Slave
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity coe_register is
    port (
        clk        : in  std_logic;
        rst_n      : in  std_logic;
        data_in    : in  std_logic_vector(15 downto 0);
        data_rdy   : in  std_logic;
        coeff_0    : out std_logic_vector(15 downto 0);
        coeff_1    : out std_logic_vector(15 downto 0);
        coeff_2    : out std_logic_vector(15 downto 0);
        coeff_3    : out std_logic_vector(15 downto 0);
        coeff_4    : out std_logic_vector(15 downto 0);
        full       : out std_logic
    );
end entity;

architecture test of coe_register is
    type t_coefficients is array (0 to 4) of std_logic_vector(15 downto 0);
    signal s_coefficients : t_coefficients;
    signal s_count        : unsigned(2 downto 0);
    signal s_full         : std_logic;
begin
    coeff_0 <= s_coefficients(0);
    coeff_1 <= s_coefficients(1);
    coeff_2 <= s_coefficients(2);
    coeff_3 <= s_coefficients(3);
    coeff_4 <= s_coefficients(4);
    full <= s_full;

    coe_register_process : process(clk, rst_n)
    begin
        if rst_n = '0' then
            s_coefficients <= (others => (others => '0'));
            s_count        <= (others => '0');
            s_full           <= '0';

        elsif rising_edge(clk) then
            if data_rdy = '1' and full = '0' then
                if s_count = 0 then
                    s_coefficients(0) <= data_in;
                    s_count <= s_count + 1;

                elsif s_count = 1 then
                    s_coefficients(1) <= data_in;
                    s_count <= s_count + 1;

                elsif s_count = 2 then
                    s_coefficients(2) <= data_in;
                    s_count <= s_count + 1;

                elsif s_count = 3 then
                    s_coefficients(3) <= data_in;
                    s_count <= s_count + 1;

                elsif s_count >= 4 then
                    s_coefficients(4) <= data_in;
                    s_full <= '1';
                end if;
            end if;
        end if;
    end process;
end architecture;