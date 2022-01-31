ENTITY=top alu counter

simulate:
	ghdl -a *.vhdl

svg:
	@$(MAKE) simulate
	-mkdir svg
	for en in $(ENTITY); do \
		yosys -p "ghdl $$en; prep -top $$en; write_json -compat-int svg.json"; \
		netlistsvg svg.json -o svg/$$en.svg; \
	done