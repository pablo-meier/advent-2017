# Unrolled the build from camlbuild since I need regexes in this one proper

run: build
	./part1.byte

build:
	ocamlbuild -use-ocamlfind -pkg core -pkg re2 -tag "ppx(ppx-jane -as-ppx)" -tag thread -tag debug -tag bin_annot -tag short_paths -cflags "-w A-4-33-40-41-42-43-34-44" -cflags -strict-sequence "part1.byte"

clean:
	rm -rf part1.byte part1.native _build

