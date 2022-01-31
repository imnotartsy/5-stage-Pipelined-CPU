export ENTITY=pipelinedcpu0

ghdl -a *.vhdl

mkdir svg

for entity in $ENTITY; do
    yosys -p "ghdl $$entity; prep -top $$entity; write_json -compat-int svg.json";
    netlistsvg svg.json -o svg/$$entity.svg;
done