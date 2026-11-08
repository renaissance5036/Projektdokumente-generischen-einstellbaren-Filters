-------------------------------------------------------
-- Titel       : Top-Level Entity für den SPI-Slave und das Einleseregister
-------------------------------------------------------
-- Projekt     : Design eines generischen, einstellbaren Filters für die digitale Verarbeitung biologischer Signale
-- Filename    : top_level.vhdl
-- Autor       : Stefan Foltrauer
-- Letze Änderungen : 17.10.2026
-------------------------------------------------------
-- Beschreibung: 
-- Top-Level Entity für den SPI-Slave und das Einleseregister
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity top is
    port (
        clk        : in  std_logic;
        rst_n      : in  std_logic;
        mosi       : in  std_logic;
        miso       : out std_logic;
        data_out   : out std_logic_vector(15 downto 0);
        data_rdy   : out std_logic;
        coeff_0    : out std_logic_vector(15 downto 0);
        coeff_1    : out std_logic_vector(15 downto 0);
        coeff_2    : out std_logic_vector(15 downto 0);
        coeff_3    : out std_logic_vector(15 downto 0);
        coeff_4    : out std_logic_vector(15 downto 0);
        full       : out std_logic
    );
end entity;

architecture test of top is

    signal s_data_out : std_logic_vector(15 downto 0);
    signal s_data_rdy : std_logic;

begin

    data_out <= s_data_out;
    data_rdy <= s_data_rdy;

    spi_slave_inst : entity work.spi_slave
        port map (
            clk      => clk,
            rst_n    => rst_n,
            mosi     => mosi,
            miso     => miso,
            data_out => s_data_out,
            data_rdy => s_data_rdy
        );

    coe_register_inst : entity work.coe_register
        port map (
            clk      => clk,
            rst_n    => rst_n,
            data_in  => s_data_out,
            data_rdy => s_data_rdy,
            coeff_0  => coeff_0,
            coeff_1  => coeff_1,
            coeff_2  => coeff_2,
            coeff_3  => coeff_3,
            coeff_4  => coeff_4,
            full     => full
        );
end architecture;