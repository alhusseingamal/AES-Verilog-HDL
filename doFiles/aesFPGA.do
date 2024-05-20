delete wave *
restart
radix -hexadecimal
add wave *
force -freeze sim:/AES/KEY3 0 0, 1 {1 ps} -r 2
force -freeze sim:/AES/SW 0 0
run 1ps
force -freeze sim:/AES/SW 1 0
run 55ps