-- IIR filter, 10th order, direct form I
-- 16-bit signed input/output, 24-bit signed Q13.10 coefficients
-- One shared SEQUENTIAL shift-add multiplier; no VHDL '*' operator.
-- No dedicated input register, output register or coefficient memory.
-- NOTE: x_in must remain stable while busy='1'.
-- NOTE: coeff_data must be combinationally available for coeff_addr.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iir10_shift_add is
    port (
        clk        : in  std_logic;
        rst_n      : in  std_logic;
        start      : in  std_logic;
        x_in       : in  signed(15 downto 0);
        coeff_addr : out unsigned(4 downto 0);
        coeff_data : in  signed(23 downto 0);
        y_out      : out signed(15 downto 0);
        busy       : out std_logic;
        done       : out std_logic
    );
end entity;

architecture rtl of iir10_shift_add is
    constant ORDER      : integer := 10;
    constant FRAC_BITS  : integer := 10;
    constant ACC_WIDTH  : integer := 48;

    -- Required filter delay memory; NOT extra input/output registers.
    type history_t is array (0 to ORDER-1) of signed(15 downto 0);
    signal x_hist : history_t := (others => (others => '0'));
    signal y_hist : history_t := (others => (others => '0'));

    type state_t is (IDLE, SHIFT_ADD, ACCUMULATE);
    signal state     : state_t := IDLE;
    signal tap       : integer range 0 to 20 := 0;
    signal bit_index : integer range 0 to 23 := 0;

    signal operand   : signed(15 downto 0);
    signal partial   : signed(ACC_WIDTH-1 downto 0) := (others => '0');
    signal acc       : signed(ACC_WIDTH-1 downto 0) := (others => '0');
    signal done_reg  : std_logic := '0';

    function saturate16(v : signed(ACC_WIDTH-1 downto 0))
        return signed is
        variable scaled : signed(ACC_WIDTH-1 downto 0);
    begin
        scaled := shift_right(v, FRAC_BITS);
        if scaled > to_signed(32767, ACC_WIDTH) then
            return to_signed(32767, 16);
        elsif scaled < to_signed(-32768, ACC_WIDTH) then
            return to_signed(-32768, 16);
        else
            return scaled(15 downto 0);
        end if;
    end function;

begin
    -- Coefficient order: b0..b10, followed by a1..a10.
    -- a0 = 1 is assumed. IIR feedback terms are subtracted.
    coeff_addr <= to_unsigned(tap, 5);

    -- Input multiplexer: current x[n], delayed x[n-k] or y[n-k].
    process (tap, x_in, x_hist, y_hist)
    begin
        if tap = 0 then
            operand <= x_in;
        elsif tap <= ORDER then
            operand <= x_hist(tap-1);
        else
            operand <= y_hist(tap-ORDER-1);
        end if;
    end process;

    -- Output has NO output register; valid when done='1' (and until next start).
    y_out <= saturate16(acc);
    busy  <= '1' when state /= IDLE else '0';
    done  <= done_reg;

    process (clk)
        variable term : signed(ACC_WIDTH-1 downto 0);
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                x_hist    <= (others => (others => '0'));
                y_hist    <= (others => (others => '0'));
                partial   <= (others => '0');
                acc       <= (others => '0');
                tap       <= 0;
                bit_index <= 0;
                state     <= IDLE;
                done_reg  <= '0';
            else
                done_reg <= '0';
                case state is
                    when IDLE =>
                        if start = '1' then
                            acc       <= (others => '0');
                            partial   <= (others => '0');
                            tap       <= 0;
                            bit_index <= 0;
                            state     <= SHIFT_ADD;
                        end if;

                    when SHIFT_ADD =>
                        -- 24 clock cycles, one coefficient bit per cycle.
                        -- The sign bit (bit 23) has NEGATIVE binary weight.
                        -- IIR feedback uses the opposite sign of a[k].
                        term := shift_left(resize(operand, ACC_WIDTH), bit_index);
                        if coeff_data(bit_index) = '1' then
                            if ((tap <= ORDER) and (bit_index < 23)) or
                               ((tap > ORDER) and (bit_index = 23)) then
                                partial <= partial + term;
                            else
                                partial <= partial - term;
                            end if;
                        end if;

                        if bit_index = 23 then
                            state <= ACCUMULATE;
                        else
                            bit_index <= bit_index + 1;
                        end if;

                    when ACCUMULATE =>
                        acc <= acc + partial;
                        if tap = 20 then
                            -- Save the current sample only to the DELAY LINE.
                            -- x_in must still be stable at this edge.
                            for i in ORDER-1 downto 1 loop
                                x_hist(i) <= x_hist(i-1);
                                y_hist(i) <= y_hist(i-1);
                            end loop;
                            x_hist(0) <= x_in;
                            y_hist(0) <= saturate16(acc + partial);
                            done_reg <= '1';
                            state <= IDLE;
                        else
                            tap <= tap + 1;
                            bit_index <= 0;
                            partial <= (others => '0');
                            state <= SHIFT_ADD;
                        end if;
                end case;
            end if;
        end if;
    end process;
end architecture;
