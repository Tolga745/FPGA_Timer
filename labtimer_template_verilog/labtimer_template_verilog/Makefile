BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

all: top.fs

# Synthesis
top.json: labtimer.v top.v
	yosys -p "read_verilog labtimer.v top.v; synth_gowin -top top -json top.json"

# Place and Route
top_pnr.json: top.json
	nextpnr-gowin --json top.json --write top_pnr.json --freq 27 --device ${DEVICE} --family ${FAMILY} --cst ${BOARD}.cst

# Generate Bitstream
top.fs: top_pnr.json
	gowin_pack -d ${FAMILY} -o top.fs top_pnr.json

# Program Board
load: top.fs
	openFPGALoader -b ${BOARD} top.fs -f

# Cleanup build artifacts
clean:
	rm top.vcd top.fs

.PHONY: load clean test
.INTERMEDIATE: top_pnr.json top.json
