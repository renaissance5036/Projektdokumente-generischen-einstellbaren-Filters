-------------------------------------------------------
-- Titel       : SPI-Slave
-------------------------------------------------------
-- Projekt     : Design eines generischen, einstellbaren Filters für die digitale Verarbeitung biologischer Signale
-- Filename    : spi_slave.vhdl
-- Autor       : Stefan Foltrauer
-- Letze Änderungen : 17.10.2026
-------------------------------------------------------
-- Beschreibung: 
-- SPI-Slave für den Empfang von Daten über die SPI-Schnittstelle
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_slave is
    port (
        clk        : in  std_logic;     -- SPI clock
        rst_n      : in  std_logic;     -- Active low reset
        mosi       : in  std_logic;     -- Master Out Slave In
        miso       : out std_logic;     -- Master In Slave Out
        data_out   : out std_logic_vector(15 downto 0); -- Received data
        data_rdy : out std_logic      -- High for one clock
    );
end entity;

architecture test of spi_slave is
    signal s_shift_reg : std_logic_vector(15 downto 0);
    signal s_count : unsigned(3 downto 0);
begin
    miso <= '0';
    spi_process:process(clk, rst_n)
    begin
        if rst_n = '0' then
            s_shift_reg <= (others => '0');
            s_count <= (others => '0');
            data_out    <= (others => '0');
            data_rdy  <= '0';

        elsif rising_edge(clk) then

            data_rdy <= '0';
            s_shift_reg <= s_shift_reg(14 downto 0) & mosi;-- Shift received bit into register

            if s_count >= 15 then --all bits are received

                data_out <= s_shift_reg(14 downto 0) & mosi;
                data_rdy <= '1';
                s_count <= (others => '0');

            else

                s_count <= s_count + 1;

            end if;
        end if;
    end process;
end architecture;