Installing
----------

First, replace ARDUINO\_ROOT with the path where you've uncompressed arduino IDE.
Then, create your project with a makefile like this:

Creating a project
------------------

<pre><code>
MAIN=ethernet
DEPENDENCIES=wiring_analog.c WInterrupts.c wiring_digital.c \
wiring_shift.c wiring_pulse.c wiring.c IPAddress.cpp \
Stream.cpp Tone.cpp main.cpp CDC.cpp WMath.cpp \
WString.cpp Print.cpp USBCore.cpp new.cpp HID.cpp \
HardwareSerial.cpp
LIBRARIES=Ethernet_EthernetServer Ethernet_EthernetClient \
       Ethernet_Ethernet SPI_SPI Ethernet_utility_w5100 \
       Ethernet_utility_socket Ethernet_EthernetUdp Ethernet_Dns
include /path/to/main/Makefile
</code></pre>

Here, I want to use Ethernet::Ethernet\* libraries, so I add them.
I set the include to my main Makefile.
My MAIN cpp file is ethernet.cpp, which contains something like:

<pre><code>
#include "Arduino.h"
#include <SPI.h>
#include <Ethernet.h>
void setup()
{
}
void loop()
{
}
</code></pre>

Using the Makefile
------------------

To build it, just run:
<pre><code>make</code></pre>
To build it and upload it, just run:
<pre><code>make upload</code></pre>
To run a serial console, use:
<pre><code>make serial</code></pre>
