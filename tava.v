module main

import tavamod
import os

fn main() {
	path_file := os.input("[  ??  ] Masukkan path source list ? ")
	tavamod.check(path_file)
}
