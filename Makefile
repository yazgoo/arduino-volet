MAIN=irled
SERIAL_DEVICE=/dev/ttyACM0
MICROCONTROLER=atmega328p
CHIPSET=arduino
ARDUINO_ROOT=/home/yazgoo/Dévelopement/arduino/arduino-1.0
CC=avr-gcc
CXX=avr-g++
AR=avr-ar
SERIAL_BUFFER_SIZE=255
AVRDUDE=${ARDUINO_ROOT}/hardware/tools/avrdude
AVRDUDE_CONF=${AVRDUDE}.conf
OBJCOPY=avr-objcopy
MAIN_O=${MAIN}.main.o
MAIN_EEP=${MAIN}.eep
MAIN_HEX=${MAIN}.hex
ARDUINO_SRC=${ARDUINO_ROOT}/hardware/arduino
ARDUINO_CORES=${ARDUINO_SRC}/cores/arduino
ARDUINO_STANDARD=${ARDUINO_SRC}/variants/standard
CC_OPTS=-g -Os -Wall -fno-exceptions -ffunction-sections -DARDUINO=100\
		-fdata-sections -mmcu=atmega328p -DF_CPU=16000000L 
CCO_OPTS=-c ${CC_OPTS} -I${ARDUINO_CORES} -I${ARDUINO_STANDARD}
CCO=${CC} ${CCO_OPTS}
CXXO=${CXX} ${CCO_OPTS}
DEPENDENCIES=wiring_analog.c.o WInterrupts.c.o wiring_digital.c.o \
	     wiring_shift.c.o wiring_pulse.c.o wiring.c.o IPAddress.cpp.o \
	     Stream.cpp.o Tone.cpp.o main.cpp.o CDC.cpp.o WMath.cpp.o \
	     WString.cpp.o Print.cpp.o USBCore.cpp.o new.cpp.o HID.cpp.o \
		 HardwareSerial.cpp.o
build: ${MAIN_ELF} ${MAIN_HEX}
%.hex: %.elf
	${OBJCOPY} -O ihex -R .eeprom $^ $@
%.eep: %.elf
	${OBJCOPY} -O ihex -j .eeprom \
		--set-section-flags=.eeprom=alloc,load \
		--no-change-warnings --change-section-lma .eeprom=0 $^ $@
%.elf: %.main.o archive 
	${CC} -Os -Wl,--gc-sections -mmcu=${MICROCONTROLER} -o $@ $^ -L. -lm
archive: ${MAIN_O} dependencies
	${AR} rcs $@ $< ${DEPENDENCIES}
clean:
	rm -f *.o *.eep *.elf *.hex archive
dependencies: ${DEPENDENCIES}
%.main.o: %.cpp 
	${CXXO} $^ -o$@ 
%.c.o: ${ARDUINO_CORES}/%.c
	${CCO} $^ -o$@ 
%.cpp.o: ${ARDUINO_CORES}/%.cpp
	${CCO} $^ -o$@ 
upload: build
	${AVRDUDE} -C${AVRDUDE_CONF} -v -v -v -v -p${MICROCONTROLER} \
		-c${CHIPSET} -P${SERIAL_DEVICE} -b115200 -D \
		-Uflash:w:${MAIN_HEX}:i
serial:
	stty -F ${SERIAL_DEVICE} ispeed 9600 ospeed 9600 -ignpar cs8 \
		-cstopb -echo; cat ${SERIAL_DEVICE}
