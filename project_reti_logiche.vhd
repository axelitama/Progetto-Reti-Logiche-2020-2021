----------------------------------------------------------------------------------
-- Company: PoliMi
-- Engineer: Alex Amati
-- 
-- Design Name: project_reti_logiche
-- Module Name: project_reti_logiche
-- Project Name: project_reti_logiche
-- Target Devices: xc7a200tfbg484-1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_done : out std_logic;
        o_en : out std_logic;
        o_we : out std_logic;
        o_data : out std_logic_vector (7 downto 0)
    );
end entity project_reti_logiche;    

architecture project_reti_logiche of project_reti_logiche is
component datapath is
    Port (
        i_clk: in std_logic;
        reset: in std_logic;
        i_data: in std_logic_vector(8-1 downto 0);
        RC_load: in std_logic;
        first_mul: in std_logic;
        RR_load: in std_logic;
        RNP_load: in std_logic;
        MCP_sel: in std_logic;
        RCP_load: in std_logic;
        addr_sel: in std_logic_vector(2-1 downto 0);
        RCPV1_load: in std_logic;
        RDV_load: in std_logic;
        RSV_load: in std_logic;
        RCPV2_load: in std_logic;
        S_loadshifted: in std_logic;
        RNPV_load: in std_logic;
        stop_mul: inout std_logic;
        end_reading: out std_logic;
        o_address: out std_logic_vector (16-1 downto 0);
        o_data: out std_logic_vector (8-1 downto 0);
        
        maxmin_enable: in std_logic;
        zeroPixel: out std_logic
    );
end component datapath;
type S is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19);
signal cur_state, next_state : S;
signal rst: std_logic;
signal reset: std_logic;
signal RC_load: std_logic;
signal first_mul: std_logic;
signal RR_load: std_logic;
signal RNP_load: std_logic;
signal MCP_sel: std_logic;
signal RCP_load: std_logic;
signal addr_sel: std_logic_vector(2-1 downto 0);
signal RCPV1_load: std_logic;
signal RDV_load: std_logic;
signal RSV_load: std_logic;
signal RCPV2_load: std_logic;
signal S_loadshifted: std_logic;
signal RNPV_load: std_logic;
signal stop_mul: std_logic;
signal end_reading: std_logic;
signal maxmin_enable: std_logic;
signal zeroPixel: std_logic;
begin
    reset <= i_rst or rst;
    
    cDatapath: datapath port map (
        i_clk => i_clk,
        reset => reset,
        i_data => i_data,
        RC_load => RC_load,
        first_mul => first_mul,
        RR_load => RR_load,
        RNP_load => RNP_load,
        MCP_sel => MCP_sel,
        RCP_load => RCP_load,
        addr_sel => addr_sel,
        RCPV1_load => RCPV1_load,
        RDV_load => RDV_load,
        RSV_load => RSV_load,
        RCPV2_load => RCPV2_load,
        S_loadshifted => S_loadshifted,
        RNPV_load => RNPV_load,
        stop_mul => stop_mul,
        end_reading => end_reading,
        o_address => o_address,
        o_data => o_data,
        maxmin_enable => maxmin_enable,
        zeroPixel => zeroPixel
    );
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            cur_state <= S0;
        elsif i_clk'event and i_clk = '1' then
            cur_state <= next_state;
        end if;
    end process;
    
    process(i_clk, cur_state, i_start, zeroPixel, stop_mul, end_reading)
    begin
        next_state <= cur_state;
        case cur_state is
            when S0 =>
                if i_start = '1' then
                    next_state <= S1;
                end if;
            when S1 =>
                next_state <= S2;
            when S2 =>
                next_state <= S3;
            when S3 =>
                next_state <= S4;
            when S4 =>
                next_state <= S5;
            when S5 =>
                if zeroPixel = '1' then
                    next_state <= S19;
                elsif stop_mul = '1' then
                    next_state <= S6;
                end if;
            when S6 =>
                next_state <= S7;
            when S7 =>
                next_state <= S8;
            when S8 =>
                next_state <= S9;
            when S9 =>
                next_state <= S10;
            when S10 =>
                next_state <= S11;
            when S11 =>
                if end_reading = '0' then
                    next_state <= S6;
                elsif end_reading = '1' then
                    next_state <= S12;
                end if;
            when S12 =>
                next_state <= S13;
            when S13 =>
                next_state <= S14;
            when S14 =>
                next_state <= S15;
            when S15 =>
                next_state <= S16;
            when S16 =>
                next_state <= S17;
            when S17 =>
                next_state <= S18;
            when S18 =>
                if end_reading = '0' then
                    next_state <= S13;
                elsif end_reading = '1' then
                    next_state <= S19;
                end if;
            when S19 =>
                if i_start = '0' then
                    next_state <= S0;
                end if;
        end case;
    end process;
    
    process(cur_state)
    begin
        rst <= '0';
        RC_load <= '0';
        first_mul <= '0';
        RR_load <= '0';
        RNP_load <= '0';
        MCP_sel <= '0';
        RCP_load <= '0';
        addr_sel <= "00";
        RCPV1_load <= '0';
        RDV_load <= '0';
        RSV_load <= '0';
        RCPV2_load <= '0';
        S_loadshifted <= '0';
        RNPV_load <= '0';
        o_done <= '0';
        o_en <= '0';
        o_we <= '0';
        maxmin_enable <= '0';
        case cur_state is
            when S0 =>
            when S1 =>
                addr_sel <= "10";
                o_en <= '1';
            when S2 =>
                RC_load <= '1';
            when S3 =>
                addr_sel <= "11";
                o_en <= '1';
                RNP_load <= '1';
                RCP_load <= '1';
            when S4 =>
                first_mul <= '1';
                RR_load <= '1';
            when S5 =>
                RNP_load <= '1';
                RR_load <= '1';
            when S6 =>
                o_en <= '1';
            when S7 =>
                RCPV1_load <= '1';
            when S8 =>
                maxmin_enable <= '1';
            when S9 =>
                RDV_load <= '1';
            when S10 =>
                RSV_load <= '1';
            when S11 =>
                MCP_sel <= '1';
                RCP_load <= '1';
            when S12 =>
                RCP_load <= '1';
            when S13 =>
                o_en <= '1';
            when S14 =>
                RCPV2_load <= '1';
            when S15 =>
                S_loadshifted <= '1';
            when S16 =>
                RNPV_load <= '1';
            when S17 =>
                addr_sel <= "01";
                o_en <= '1';
                o_we <= '1';
            when S18 =>
                MCP_sel <= '1';
                RCP_load <= '1';
            when S19 =>
                rst <= '1';
                o_done <= '1';
        end case;
    end process;
end architecture project_reti_logiche;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity registry is
    generic (
        WIDTH : integer := 16;
        CLEAR : integer := 0
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        load_enable : in std_logic;
        input : in std_logic_vector (WIDTH-1 downto 0);
        output : out std_logic_vector (WIDTH-1 downto 0)
    );
end entity registry;

architecture registry of registry is
begin
    process(clk, reset, load_enable)
    begin
        if (reset = '1') then
            output <= std_logic_vector(to_unsigned(CLEAR, output'length));
        elsif (clk'event and clk = '1' and load_enable = '1') then
            output <= input;
        end if;
    end process;
end architecture registry;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shifter is
    generic (
        WIDTH : integer := 16;
        CLEAR : integer := 0
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        load_enable : in std_logic;
        shift: in std_logic_vector (WIDTH-1 downto 0);
        input : in std_logic_vector (WIDTH-1 downto 0);
        output : out std_logic_vector (WIDTH-1 downto 0)
    );
end entity shifter;

architecture shifter of shifter is
begin
    process(clk)
    begin
        if (clk'event and clk = '1') then
            if (reset = '1') then
                output <= std_logic_vector(to_unsigned(CLEAR, output'length));
            else
                if (load_enable = '1') then
                    output <= std_logic_vector(shift_left(unsigned(input), to_integer(unsigned(shift))));
                end if;
            end if;
        end if;
    end process;
end architecture shifter;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
    generic (
        IN_WIDTH : integer := 16;
        OUT_WIDTH : integer := 16
    );
    port(
        addend1, addend2 : in  std_logic_vector (IN_WIDTH-1 downto 0);
        sum : out  std_logic_vector (OUT_WIDTH-1 downto 0)
    );
end entity adder;

architecture adder of adder is
begin
    sum <= std_logic_vector(resize(unsigned(addend1) + unsigned(addend2), sum'length));
end architecture adder;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity subtractor is
    generic (
        IN_WIDTH : integer := 16;
        OUT_WIDTH : integer := 16
    );
    port(
        minuend, subtrahend : in  std_logic_vector (IN_WIDTH-1 downto 0);
        difference : out  std_logic_vector (OUT_WIDTH-1 downto 0)
    );
end entity subtractor;

architecture subtractor of subtractor is
begin
    difference <= std_logic_vector(resize(unsigned(minuend) - unsigned(subtrahend), difference'length));
end architecture subtractor;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity equal_comparator is
    generic (
        WIDTH : integer := 16
    );
    port(
        term1, term2 : in  std_logic_vector (WIDTH-1 downto 0);
        output: out std_logic
    );
end entity equal_comparator;

architecture equal_comparator of equal_comparator is
begin
    process(term1, term2)
    begin
        if (unsigned(term1) = unsigned(term2)) then
            output <= '1';
        else
            output <= '0';
        end if;
    end process;
end architecture equal_comparator;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bigger_comparator is
    generic (
        WIDTH : integer := 16
    );
    port(
        term1, term2 : in  std_logic_vector (WIDTH-1 downto 0);
        output: out std_logic
    );
end entity bigger_comparator;

architecture bigger_comparator of bigger_comparator is
begin
    process(term1, term2)
    begin
        if (unsigned(term1) > unsigned(term2)) then
            output <= '1';
        else
            output <= '0';
        end if;
    end process;
end architecture bigger_comparator;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity smaller_comparator is
    generic (
        WIDTH : integer := 16
    );
    port(
        term1, term2 : in  std_logic_vector (WIDTH-1 downto 0);
        output: out std_logic
    );
end entity smaller_comparator;

architecture smaller_comparator of smaller_comparator is
begin
    process(term1, term2)
    begin
        if (unsigned(term1) < unsigned(term2)) then
            output <= '1';
        else
            output <= '0';
        end if;
    end process;
end architecture smaller_comparator;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplexer2 is
    generic (
        IN_WIDTH : integer := 16;
        OUT_WIDTH : integer := 16
    );
    port(
        sel: in std_logic;
        in0: in std_logic_vector (IN_WIDTH-1 downto 0);
        in1: in std_logic_vector (IN_WIDTH-1 downto 0);
        output: out std_logic_vector (OUT_WIDTH-1 downto 0)
    );
end entity multiplexer2;

architecture multiplexer2 of multiplexer2 is
begin
--    process(sel, in0, in1)
--    begin
--        if IN_WIDTH < OUT_WIDTH then
--        output <= (others => '0');
--            if sel = '0' then
--                output(IN_WIDTH-1 downto 0) <= in0;
--            elsif sel = '1' then
--                output(IN_WIDTH-1 downto 0) <= in1;
--            else
--                output <= (others => 'X');
--            end if;
--        else
--            if sel = '0' then
--                output <= in0(OUT_WIDTH-1 downto 0);
--            elsif sel = '1' then
--                output <= in1(OUT_WIDTH-1 downto 0);
--            else
--                output <= (others => 'X');
--            end if;
--        end if;
--    end process;
    output <= std_logic_vector(resize(unsigned(in0), output'length)) when sel = '0' else
                std_logic_vector(resize(unsigned(in1), output'length)) when sel = '1' else
                (others => 'X');
end architecture multiplexer2;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplexer4 is
    generic (
        IN_WIDTH : integer := 16;
        OUT_WIDTH : integer := 16
    );
    port(
        sel: in std_logic_vector (1 downto 0);
        in0: in std_logic_vector (IN_WIDTH-1 downto 0);
        in1: in std_logic_vector (IN_WIDTH-1 downto 0);
        in2: in std_logic_vector (IN_WIDTH-1 downto 0);
        in3: in std_logic_vector (IN_WIDTH-1 downto 0);
        output: out std_logic_vector (OUT_WIDTH-1 downto 0)
    );
end entity multiplexer4;

architecture multiplexer4 of multiplexer4 is
begin
    output <= std_logic_vector(resize(unsigned(in0), output'length)) when sel = "00" else
                std_logic_vector(resize(unsigned(in1), output'length)) when sel = "01" else
                std_logic_vector(resize(unsigned(in2), output'length)) when sel = "10" else
                std_logic_vector(resize(unsigned(in3), output'length)) when sel = "11" else
                (others => 'X');
end architecture multiplexer4;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shiftValue_table is
    port(
        input: in std_logic_vector (8-1 downto 0);
        output: out std_logic_vector (8-1 downto 0)
    );
end entity shiftValue_table;

architecture shiftValue_table of shiftValue_table is
begin
    process(input)
    begin
    -- [ 8 - FLOOR(LOG2(delta_value +1)) ]
        case to_integer(unsigned(input)) is
            when 0 => output <= "00001000";
            when 1 to 2 => output <= "00000111";
            when 3 to 6 => output <= "00000110";
            when 7 to 14 => output <= "00000101";
            when 15 to 30 => output <= "00000100";
            when 31 to 62 => output <= "00000011";
            when 63 to 126 => output <= "00000010";
            when 127 to 254 => output <= "00000001";
            when 255 => output <= "00000000";
            when others => output <= "XXXXXXXX";
        end case;
    end process;
end architecture shiftValue_table;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
    port(
        i_clk: in std_logic;
        reset: in std_logic;
        i_data: in std_logic_vector(8-1 downto 0);
        RC_load: in std_logic;
        first_mul: in std_logic;
        RR_load: in std_logic;
        RNP_load: in std_logic;
        MCP_sel: in std_logic;
        RCP_load: in std_logic;
        addr_sel: in std_logic_vector(2-1 downto 0);
        RCPV1_load: in std_logic;
        RDV_load: in std_logic;
        RSV_load: in std_logic;
        RCPV2_load: in std_logic;
        S_loadshifted: in std_logic;
        RNPV_load: in std_logic;
        stop_mul: inout std_logic;
        end_reading: out std_logic;
        o_address: out std_logic_vector (16-1 downto 0);
        o_data: out std_logic_vector (8-1 downto 0);
        
        maxmin_enable: in std_logic;
        zeroPixel: out std_logic
    );
end entity datapath;

architecture datapath of datapath is
signal zero8: std_logic_vector(8-1 downto 0) := "00000000";
signal one8: std_logic_vector(8-1 downto 0) := "00000001";
signal twoHundredFiftyFive8: std_logic_vector(8-1 downto 0) := "11111111";
signal zero16: std_logic_vector(16-1 downto 0)  := "0000000000000000";
signal one16: std_logic_vector(16-1 downto 0)  := "0000000000000001";
signal two16: std_logic_vector(16-1 downto 0)  := "0000000000000010";
signal twoHundredFiftyFive16: std_logic_vector(16-1 downto 0)  := "0000000011111111";

signal RC_out: std_logic_vector(8-1 downto 0);
signal MC_out: std_logic_vector(16-1 downto 0);
signal RNP_in: std_logic_vector(16-1 downto 0);
signal RNP_out: std_logic_vector(16-1 downto 0);
signal RR_in: std_logic_vector(8-1 downto 0);
signal RR_out: std_logic_vector(8-1 downto 0);
signal MSub_out: std_logic_vector(8-1 downto 0);
signal SR_out: std_logic_vector(8-1 downto 0);
signal RCP_in: std_logic_vector(16-1 downto 0);
signal RCP_out: std_logic_vector(16-1 downto 0);
signal ACP_out: std_logic_vector(16-1 downto 0);
signal addressRead: std_logic_vector(16-1 downto 0);
signal addressWrite: std_logic_vector(16-1 downto 0);


signal RCPV1_out: std_logic_vector(8-1 downto 0);
signal RMAX_out: std_logic_vector(8-1 downto 0);
signal RMIN_out: std_logic_vector(8-1 downto 0);
signal RMAX_load: std_logic := '0';
signal RMIN_load: std_logic := '0';
signal RDV_in: std_logic_vector(8-1 downto 0);
signal RDV_out: std_logic_vector(8-1 downto 0);
signal RSV_in: std_logic_vector(8-1 downto 0);
signal RSV_out: std_logic_vector(8-1 downto 0);

signal RCPV2_out: std_logic_vector(8-1 downto 0);
signal SHIFT_in: std_logic_vector(16-1 downto 0);
signal SHIFT_out: std_logic_vector(16-1 downto 0);
signal MNPV_sel: std_logic;
signal RNPV_in: std_logic_vector(8-1 downto 0);
signal RNPV_out: std_logic_vector(8-1 downto 0);
signal shift: std_logic_vector(16-1 downto 0);

signal CER_in: std_logic_vector(16-1 downto 0);
signal max_en: std_logic;
signal min_en: std_logic;

signal tmp: std_logic;

signal zeroColumn: std_logic;
signal zeroRow: std_logic;
begin
    zeroPixel <= zeroColumn or zeroRow;
    crczero : entity work.equal_comparator(equal_comparator) generic map (WIDTH => 8) port map (term1 => RC_out, term2 => zero8, output => zeroColumn);
    crrzero : entity work.equal_comparator(equal_comparator) generic map (WIDTH => 8) port map (term1 => RR_out, term2 => zero8, output => zeroRow);
    
    
    rc : entity work.registry(registry) generic map (WIDTH => 8) port map (clk => i_clk, reset => reset, load_enable => RC_load, input => i_data, output => RC_out);
    mc : entity work.multiplexer2(multiplexer2) generic map (IN_WIDTH => 8) port map (sel => stop_mul, in0 => RC_out, in1 => zero8, output => MC_out);
    anp : entity work.adder(adder) port map(addend1 => MC_out, addend2 => RNP_out, sum => RNP_in);
    rnp : entity work.registry(registry) port map (clk => i_clk, reset => reset, load_enable => RNP_load, input => RNP_in, output => RNP_out);
    
    mr : entity work.multiplexer2(multiplexer2) generic map (IN_WIDTH => 8, OUT_WIDTH => 8) port map (sel => first_mul, in0 => SR_out, in1 => i_data, output => RR_in);
----------------------------
--    rr : entity work.registry(registry) generic map (WIDTH => 8) port map (clk => i_clk, reset => reset, load_enable => RR_load, input => RR_in, output => RR_out);
--    msub : entity work.multiplexer2(multiplexer2) generic map (IN_WIDTH => 8, OUT_WIDTH => 8) port map (sel => stop_mul, in0 => one8, in1 => zero8, output => MSub_out);
    tmp <= RR_load and (not stop_mul);
    rr : entity work.registry(registry) generic map (WIDTH => 8) port map (clk => i_clk, reset => reset, load_enable => tmp, input => RR_in, output => RR_out);
    msub : entity work.multiplexer2(multiplexer2) generic map (IN_WIDTH => 8, OUT_WIDTH => 8) port map (sel => '0', in0 => one8, in1 => zero8, output => MSub_out);
----------------------------
    sr : entity work.subtractor(subtractor) generic map (IN_WIDTH => 8, OUT_WIDTH => 8) port map (minuend => RR_out, subtrahend => MSub_out, difference => SR_out);
    cmul : entity work.equal_comparator(equal_comparator) generic map (WIDTH => 8) port map (term1 => SR_out, term2 => zero8, output => stop_mul);
    
    mcp : entity work.multiplexer2(multiplexer2) port map (sel => MCP_sel, in0 => zero16, in1 => ACP_out, output => RCP_in);
    rcp : entity work.registry(registry) port map (clk => i_clk, reset => reset, load_enable => RCP_load, input => RCP_in, output => RCP_out);
    acp : entity work.adder(adder) port map(addend1 => RCP_out, addend2 => one16, sum => ACP_out);
    
    ser : entity work.subtractor(subtractor) port map (minuend => RNP_out, subtrahend => one16, difference => CER_in);
    cer : entity work.equal_comparator(equal_comparator) port map (term1 => CER_in, term2 => RCP_out, output => end_reading);
    
    aar : entity work.adder(adder) port map(addend1 => RCP_out, addend2 => two16, sum => addressRead);
    aaw : entity work.adder(adder) port map(addend1 => RNP_out, addend2 => addressRead, sum => addressWrite);
    ma : entity work.multiplexer4(multiplexer4) port map (sel => addr_sel, in0 => addressRead, in1 => addressWrite, in2 => zero16, in3 => one16, output => o_address);
    
    
    rcpv1 : entity work.registry(registry) generic map (WIDTH => 8) port map (clk => i_clk, reset => reset, load_enable => RCPV1_load, input => i_data, output => RCPV1_out);
    max_en <= RMAX_load and maxmin_enable;
    min_en <= RMIN_load and maxmin_enable;
    rmax : entity work.registry(registry) generic map (WIDTH => 8) port map (clk => i_clk, reset => reset, load_enable => max_en, input => RCPV1_out, output => RMAX_out);
    rmin : entity work.registry(registry) generic map (WIDTH => 8, CLEAR => 255) port map (clk => i_clk, reset => reset, load_enable => min_en, input => RCPV1_out, output => RMIN_out);
    cmax : entity work.bigger_comparator(bigger_comparator) generic map (WIDTH => 8) port map (term1 => RCPV1_out, term2 => RMAX_out, output => RMAX_load);
    cmin : entity work.smaller_comparator(smaller_comparator) generic map (WIDTH => 8) port map (term1 => RCPV1_out, term2 => RMIN_out, output => RMIN_load);
    sdv : entity work.subtractor(subtractor) generic map (IN_WIDTH => 8, OUT_WIDTH => 8) port map (minuend => RMAX_out, subtrahend => RMIN_out, difference => RDV_in);
    rdv : entity work.registry(registry) generic map (WIDTH => 8) port map (clk => i_clk, reset => reset, load_enable => RDV_load, input => RDV_in, output => RDV_out);
    tlog : entity work.shiftValue_table(shiftValue_table) port map (input => RDV_out, output => RSV_in);
    rsv : entity work.registry(registry) generic map (WIDTH => 8) port map (clk => i_clk, reset => reset, load_enable => RSV_load, input => RSV_in, output => RSV_out);
    
    rcpv2 : entity work.registry(registry) generic map (WIDTH => 8) port map (clk => i_clk, reset => reset, load_enable => RCPV2_load, input => i_data, output => RCPV2_out);
    sshift : entity work.subtractor(subtractor) generic map (IN_WIDTH => 8) port map (minuend => RCPV2_out, subtrahend => RMIN_out, difference => SHIFT_in);
    shift <= std_logic_vector(resize(unsigned(RSV_out), 16));
    shifter : entity work.shifter(shifter) port map(clk => i_clk, reset => reset, load_enable => S_loadshifted, shift => shift, input => SHIFT_in, output => SHIFT_out);
    
    cnpv : entity work.bigger_comparator(bigger_comparator) port map (term1 => shift_out, term2 => twoHundredFiftyFive16, output => MNPV_sel);
    mnpv : entity work.multiplexer2(multiplexer2) generic map (IN_WIDTH => 8, OUT_WIDTH => 8) port map (sel => MNPV_sel, in0 => SHIFT_out(7 downto 0), in1 => twoHundredFiftyFive8, output => RNPV_in);
    rnpv : entity work.registry(registry) generic map (WIDTH => 8) port map (clk => i_clk, reset => reset, load_enable => RNPV_load, input => RNPV_in, output => o_data);
end architecture datapath;
