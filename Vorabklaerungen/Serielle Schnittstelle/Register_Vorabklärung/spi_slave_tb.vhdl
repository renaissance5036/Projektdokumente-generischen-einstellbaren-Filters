-------------------------------------------------------
-- Titel       : Testbench für den SPI-Slave
-------------------------------------------------------
-- Projekt     : Design eines generischen, einstellbaren Filters für die digitale Verarbeitung biologischer Signale
-- Filename    : spi_slave_tb.vhdl
-- Autor       : Stefan Foltrauer
-- Letze Änderungen : 17.10.2026
-------------------------------------------------------
-- Beschreibung: 
-- TB zum kontrollieren des SPI-Slave und des Einleseregisters für Koeffizienten
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end entity;

architecture Testbench of top_tb is
    signal sClk      : std_logic := '0';
    signal sStop     : std_logic := '0';
    signal sReset    : std_logic := '0';
    signal sMosi     : std_logic := '0';
    signal sMiso     : std_logic;
    signal sDataOut  : std_logic_vector(15 downto 0);
    signal sDataRdy  : std_logic;
    signal sCoeff0   : std_logic_vector(15 downto 0);
    signal sCoeff1   : std_logic_vector(15 downto 0);
    signal sCoeff2   : std_logic_vector(15 downto 0);
    signal sCoeff3   : std_logic_vector(15 downto 0);
    signal sCoeff4   : std_logic_vector(15 downto 0);
    signal sFull     : std_logic;
    signal sSendData : std_logic_vector(15 downto 0);
begin

    DUT : entity work.top(test)
        port map (
            clk      => sClk,
            rst_n    => sReset,
            mosi     => sMosi,
            miso     => sMiso,
            data_out => sDataOut,
            data_rdy => sDataRdy,
            coeff_0  => sCoeff0,
            coeff_1  => sCoeff1,
            coeff_2  => sCoeff2,
            coeff_3  => sCoeff3,
            coeff_4  => sCoeff4,
            full     => sFull
        );


    clk_gen : process
    begin
        while sStop = '0' loop

            sClk <= '0';
            wait for 2 ns;

            sClk <= '1';
            wait for 2 ns;

        end loop;

        wait;

    end process;


    Test : process

    begin

        sReset <= '0';
        sMosi  <= '0';
        wait for 11 ns;
        sReset <= '1';

        -- Erstes Wort senden: 0x1111
        sSendData <= x"1111";
        wait for 1 ns;
        for i in 15 downto 0 loop
            sMosi <= sSendData(i);
            wait until rising_edge(sClk);
        end loop;

        -- Zweites Wort senden: 0x2222
        sSendData <= x"2222";
        wait for 1 ns;
        for i in 15 downto 0 loop
            sMosi <= sSendData(i);
            wait until rising_edge(sClk);
        end loop;

        -- Drittes Wort senden: 0x3333 
        sSendData <= x"3333";
        wait for 1 ns;
        for i in 15 downto 0 loop
            sMosi <= sSendData(i);
            wait until rising_edge(sClk);
        end loop;

        -- Viertes Wort senden: 0x4444
        sSendData <= x"4444";
        wait for 1 ns;
        for i in 15 downto 0 loop
            sMosi <= sSendData(i);
            wait until rising_edge(sClk);
        end loop;

        -- Fünftes Wort senden: 0x5555
        sSendData <= x"5555";
        wait for 1 ns;
        for i in 15 downto 0 loop
            sMosi <= sSendData(i);
            wait until rising_edge(sClk);
        end loop;

        --Test 5
        wait until sDataRdy = '1';
        wait for 10 ns;
        assert sCoeff0 = x"1111" report "Test 5 failed" severity error;
        assert sCoeff1 = x"2222" report "Test 5 failed" severity error;
        assert sCoeff2 = x"3333" report "Test 5 failed" severity error;
        assert sCoeff3 = x"4444" report "Test 5 failed" severity error;
        assert sCoeff4 = x"5555" report "Test 5 failed" severity error;


        report "Test finished"severity note;
        sStop <= '1';
        wait;
    end process;
end architecture;