library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all;

entity de10lite is
port (
    CLOCK_50:	in std_logic;
    KEY: 		in std_logic_vector(1 downto 0);
    SW: 			in std_logic_vector(9 downto 0);
    LEDR:		out std_logic_vector(9 downto 0);
    HEX0:		out std_logic_vector(7 downto 0);
	 HEX1:		out std_logic_vector(7 downto 0);
	 HEX2:		out std_logic_vector(7 downto 0);
	 HEX3:		out std_logic_vector(7 downto 0);
	 HEX4:		out std_logic_vector(7 downto 0);
	 HEX5:		out std_logic_vector(7 downto 0);
	 
	 SPI_MOSI:	out std_logic;
	 SPI_MISO:	in std_logic;
	 SPI_CS:		out std_logic;
	 SPI_CLK: 	out std_logic;
	 SPI_INT1:	in	std_logic;
	 
	 TX:				out std_logic;
	 RX:				in	std_logic
);
end de10lite;

architecture behaviour of de10lite is

	constant dwidth : integer := 8;

	component gumnut_with_mem IS
		generic ( 
			IMem_file_name : string := "gasm_text.dat";
			DMem_file_name : string := "gasm_data.dat";
			debug : boolean := false
			);
		port (
			clk_i : in std_logic;
			rst_i : in std_logic;
			-- I/O port bus
			port_cyc_o : out std_logic;
			port_stb_o : out std_logic;
			port_we_o : out std_logic;
			port_ack_i : in std_logic;
			port_adr_o : out unsigned(7 downto 0);
			port_dat_o : out std_logic_vector(7 downto 0);
			port_dat_i : in std_logic_vector(7 downto 0);
			-- Interrupts
			int_req : in std_logic;
			int_ack : out std_logic
			);
	end component gumnut_with_mem;

	component bcd7seg is
		port (
			bcd	:	in std_logic_vector(7 downto 0);
			display	:	out std_logic_vector(15 downto 0)
		);
	end component bcd7seg;
	
	component carrot2led is
	port (
		carrots	:	in std_logic_vector(2 downto 0);
		display	:	out std_logic_vector(6 downto 0)
	);
	end component carrot2led;

	component uart IS
		GENERIC(
			clk_freq  :  INTEGER    := 50_000_000;  --frequency of system clock in Hertz
			baud_rate :  INTEGER    := 115_200;     --data link baud rate in bits/second
			os_rate   :  INTEGER    := 16;          --oversampling rate to find center of receive bits (in samples per baud period)
			d_width   :  INTEGER    := dwidth;           --data bus width
			parity    :  INTEGER    := 0;           --0 for no parity, 1 for parity
			parity_eo :  STD_LOGIC  := '0'        	 --'0' for even, '1' for odd parity
		);
		PORT(
			clk      :  IN   STD_LOGIC;                             --system clock
			reset_n  :  IN   STD_LOGIC;                             --ascynchronous reset
			tx_ena   :  IN   STD_LOGIC;                             --initiate transmission
			tx_data  :  IN   STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
			rx       :  IN   STD_LOGIC;                             --receive pin
			rx_busy  :  OUT  STD_LOGIC;                             --data reception in progress
			rx_error :  OUT  STD_LOGIC;                             --start, parity, or stop bit error detected
			rx_data  :  OUT  STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data received
			tx_busy  :  OUT  STD_LOGIC;                             --transmission in progress
			tx       :  OUT  STD_LOGIC                              --transmit pin
		);
	END component;
	
	component accel_driver is
		PORT (
			rst			:		in std_logic;
			clk			:		in std_logic;
			int1			:		in std_logic;
			rxDataReady	:		in	std_logic;
			go				:		out std_logic;
			pol			:		out std_logic;
			pha			:		out std_logic;
			bytes 		:		out std_logic_vector (3 downto 0);
			txData 		:		out std_logic_vector (7 downto 0);
			rxData		: 		in std_logic_vector ( 7 downto 0);
			accel_data	:		out std_logic_vector (47 downto 0);
			stateID 		:      out std_logic_vector (2 downto 0)
		);
	end component accel_driver;
	
	component spi_master is
		PORT (
			clk	: in std_logic;
			rst	: in std_logic;
			mosi	: out std_logic;
			miso 	: in std_logic;
			sclk_out : out std_logic; 
			cs_out	: out std_logic;
			int1 	: in std_logic;
			int2 	: in std_logic;
			go		: in std_logic;
			pol	: in std_logic;
			pha   : in std_logic;
			bytes : in std_logic_vector (3 downto 0);
			rxData: out std_logic_vector(7 downto 0);
			txData: in  std_logic_vector(7 downto 0);
			rxDataReady: out std_logic
		);
	end component spi_master;


-- clock signal
signal clk_i: std_logic;

-- reset signals
signal gumnut_rst_i, uart_rst_i, spi_rst_i, accel_rst_i: std_logic;

-- output signals of gumnut
signal port_cyc_o, port_stb_o, port_we_o: std_logic;

-- input signals of gumnut
signal port_ack_i: std_logic;

-- data signals of gumnut
signal port_adr_o: unsigned(7 downto 0);
signal port_dat_o, port_dat_i: std_logic_vector(7 downto 0);

-- interrupt signals of gumnut
signal int_req, int_ack: std_logic;

-- data represented in (2)7 segment displays
signal time_left: std_logic_vector(7 downto 0);
signal time_left_7seg: std_logic_vector(15 downto 0);

-- uart flags and sets
signal tx_ena, rx_busy, rx_error, tx_busy: std_logic;

-- uart signals
signal tx_buffer, rx_buffer: std_logic;

-- uart data
signal tx_data, rx_data: std_logic_vector(dwidth-1 DOWNTO 0);

signal go : std_logic;
signal pol : std_logic;
signal pha : std_logic;
signal bytes : std_logic_vector (3 downto 0);
signal rxData : std_logic_vector (7 downto 0);
signal rxDataReady	: std_logic := '0';
signal txData 		:		 std_logic_vector (7 downto 0);
signal accel_data	:		 std_logic_vector (47 downto 0);

signal sclk_buffer, sclk_out	:	std_logic;
signal mosi_buffer	:	std_logic;
signal cs_buffer	:	std_logic;
signal int1_buffer	:	std_logic;
signal stateID : std_logic_vector(2 downto 0);

signal 	acc	:	std_logic_vector(7 downto 0) := "00000000";
signal 	carrots	:	std_logic_vector(2 downto 0) := "000";

begin

clk_i <= CLOCK_50;
gumnut_rst_i <= not SW( 8 );
uart_rst_i <= SW( 8 );
spi_rst_i <= not SW( 9 );
accel_rst_i <= not SW( 9 );
port_ack_i <= '1';

-- GUMNUT COMPONENT --
gumnut :	COMPONENT gumnut_with_mem 
				PORT MAP(
					clk_i,
					gumnut_rst_i,
					port_cyc_o,
					port_stb_o,
					port_we_o,
					port_ack_i,
					port_adr_o( 7 DOWNTO 0 ),
					port_dat_o( 7 DOWNTO 0 ),
					port_dat_i( 7 DOWNTO 0 ),
					int_req,
					int_ack
				);

-- 7 SEGMENT DISPLAYS --
seg0	:	component bcd7seg
port map ( time_left, time_left_7seg );

-- LEDS --
led_carrots	:	component carrot2led
port map ( carrots, LEDR(6 downto 0) );

comm	:	component uart
				port map (
					clk		=>	clk_i,
					reset_n	=>	uart_rst_i,
					tx_ena	=>	tx_ena,
					tx_data	=>	tx_data,
					rx			=>	rx_buffer,
					rx_busy	=>	rx_busy,
					rx_error	=>	rx_error,
					rx_data	=>	rx_data,
					tx_busy	=>	tx_busy,
					tx			=>	tx_buffer
				);
				
spi	:	entity work.spi_master(FSM_1P)
		port map(
			clk	=> clk_i,
			rst	=> spi_rst_i,
			mosi	=> mosi_buffer,
			miso 	=> SPI_MISO,
			sclk_out => sclk_out,
			cs_out	=> cs_buffer,
			int1 	=> '0',
			int2 	=> '0',
			go		=> go,
			pol	=> pol,
			pha   => pha,
			bytes => bytes,
			rxData	=> rxData,
			txData	=> txData,
			rxDataReady	=> rxDataReady
	);
	
accel	:	entity work.accel_driver(FSM_1P)
		port map(
			rst			=>	accel_rst_i,
			clk			=>	clk_i,
			int1			=> int1_buffer,
			rxDataReady	=> rxDataReady,
			go				=> go,
			pol			=> pol,
			pha			=> pha,
			bytes 		=> bytes,
			txData 		=> txData,
			rxData		=> rxData,
			accel_data	=> accel_data,
			stateID 		=> stateID
	);
	
SPI_MOSI <= mosi_buffer;
SPI_CLK <= sclk_buffer;
SPI_CS <= cs_buffer;
TX <= tx_buffer;

process( clk_i )

variable count : integer := 0;
variable target : integer := 5_000_000; -- 10 veces por segundo

begin
	if ( not SW(9) = '1') then
	
		sclk_buffer <= '1';
		int1_buffer <= '1';

	elsif rising_edge( clk_i ) then
	
		sclk_buffer <= sclk_out;
		int1_buffer <= SPI_INT1;
		rx_buffer	<= RX;
	
--		LEDR(0)	<= int1_buffer;
--		LEDR(1)	<= sclk_buffer;
--		LEDR(2)	<= cs_buffer;
		
		HEX0 <= time_left_7seg(15 downto 8);
		HEX1 <= time_left_7seg(7 downto 0);
		HEX2 <= "11111111";
		HEX3 <= "11111111";
		HEX4 <= "11111111";
		HEX5 <= "11111111";
		
		if count = target then
			tx_ena <= '0'; -- activar el tx
			
			acc <= "00000000";
			
			if to_integer( unsigned( accel_data(15 downto 8) ) ) = 255 then				
				if to_integer( unsigned( accel_data(7 downto 0) ) ) <= 215 then
					acc(1) <= '1';
					acc(0) <= '0';
				end if;
			else
				if to_integer( unsigned( accel_data(7 downto 0) ) ) >= 40 then
					acc(1) <= '0';
					acc(0) <= '1';
				end if;
			end if;
			
			acc(2) <= not KEY(1);
			acc(3) <= not KEY(0);
			
			tx_data <= acc;
			
			count := 0;
		else
			count := count + 1;
			tx_ena <= '1';
		end if;
	
		if port_cyc_o = '1' and port_stb_o = '1' and port_we_o = '1' then

			-- 000[00000] en display 0 y 1
			time_left(7 downto 5) <= "000";
			time_left(4 downto 0) <= port_dat_o( 7 downto 3 );
				
			-- [000]00000 en todos los LEDs
			carrots <= port_dat_o(2 downto 0);
		
		elsif port_cyc_o = '1' and port_stb_o = '1' and port_we_o = '0' then
		
			if port_adr_o(1) = '0' and port_adr_o(0) = '0' then

				port_dat_i <= rx_data;
				
			end if;
			
		end if;
	end if;
end process;

--LEDR(9 downto 8) <= ( others => '0' );

end behaviour;
