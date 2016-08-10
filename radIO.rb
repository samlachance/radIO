require 'rubygems'
require 'serialport'
require 'net-telnet'

class Radio
  attr_accessor :frequency, :strength, :mode, :tn

  def initialize
    @tn = self.telnet_connect
    @frequency  = tn.cmd("f")
    @mode       = tn.cmd("m")
    @strength   = tn.cmd("l")
  end

  def telnet_connect
    Net::Telnet::new("Host" => "localhost",
                     "Port" => 7356,
                     "Prompt" => /\n/)
  end

  def serial_connect 
    SerialPort.new("/dev/ttyUSB0", 9600, 8, 1, SerialPort::NONE)
  end

  def refresh
    freq = tn.cmd("f").chomp
    if freq.length == 8
      freq = "  " + freq
      @frequency = self.beautify(freq)
    elsif freq.length == 9 
      freq = " " + freq
      @frequency = self.beautify(freq)
    else
      @frequency = self.beautify(freq)
    end

    str = tn.cmd("l").chomp
    if str.length == 4
      str = " " + str
      @strength = str
    else
      @strength = str
    end

    @mode = tn.cmd("m").chomp
  end

  def beautify(ugly)
    "#{ugly[0,4]}.#{ugly[4,3]}.#{ugly[7,3]} MHz"
  end

end

radio = Radio.new

ser = radio.serial_connect
while true do
  while (i = ser) do
    radio.refresh
    i.write "#{radio.frequency}#{radio.strength} dB  #{radio.mode}        \n"
    sleep(0.3) # Update interval
  end
end