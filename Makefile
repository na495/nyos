ARCH = armv7-a
MCPU = cortex-a8

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

LINKER_SCRIPT = ./nyos.ld

ASM_SRCS = $(wildcard boot/*.S)
ASM_OBJS = $(patsubst boot/%.S, build/%.o, $(ASM_SRCS))

nyos = build/nyos.axf
nyos_bin = build/nyos.bin

.PHONY: all clean run debug gdb sidebar docs

all: $(nyos)

clean:
	@rm -fr build

run: $(nyos)
	qemu-system-arm -M realview-pb-a8 -kernel $(nyos)

debug: $(nyos)
	qemu-system-arm -M realview-pb-a8 -kernel $(nyos) -S -gdb tcp::1234,ipv4

gdb:
	arm-none-eabi-gdb

$(nyos): $(ASM_OBJS) $(LINKER_SCRIPT)
	$(LD) -n -T $(LINKER_SCRIPT) -o $(nyos) $(ASM_OBJS)
	$(OC) -O binary $(nyos) $(nyos_bin)

build/%.o: boot/%.S
	mkdir -p $(shell dirname $@)
	$(AS) -march=$(ARCH) -mcpu=$(MCPU) -g -o $@ $<
	
sidebar:
	python3 scripts/sidebar.py

docs: sidebar
	@echo ""
	@echo "  http://localhost:3000  "
	@echo ""
	@cd docs && python3 -m http.server 3000