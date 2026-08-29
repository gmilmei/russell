# Russell Compiler 3.3 for Linux

[Deutsche Fassung](README.de.md)

This repository contains the historical Russell Compiler 3.3 and a port to
Linux/i386. The compiler produces 32-bit ELF programs and uses the system's
Boehm garbage collector.

The original documentation remains available in [README](README) and
[INSTALLATION](INSTALLATION). The SunOS and a.out installation procedure
described there is normally not needed for this Linux port.

## Requirements

The port requires an x86 Linux environment with 32-bit development files:

- GNU Make, GCC, and Binutils
- the 32-bit C library and GCC runtime
- Boehm GC with its 32-bit development files
- `qemu-i386` or native support for Linux i386 programs

On Fedora, the required packages can be installed with:

```sh
sudo dnf install gcc make binutils glibc-devel.i686 libgcc.i686 gc-devel.i686 qemu-user
```

QEMU is not required on a system that can run ELF32/i386 programs natively.
On such a system, run the ABI check without a runner:

```sh
make I386_RUNNER=
```

## Building

From the repository root, run:

```sh
make
```

The build checks the target ABI first. A successful check prints:

```text
Russell target ABI: Linux i386, 8-bit bytes, 32-bit words
```

The `rc` compiler driver, the `src/Rc` bootstrap compiler, and the required
tools are then available in the source tree.

For a complete rebuild:

```sh
make clean
make
```

The absolute repository path is embedded in `rc` during the build. Do not move
the source tree afterwards. Instead of copying `rc`, create a symbolic link in
your personal binary directory:

```sh
mkdir -p "$HOME/.local/bin"
ln -s "$(pwd)/rc" "$HOME/.local/bin/rc"
```

Add `~/.local/bin` to `PATH` if necessary.

## Compiling a Russell program

The simplest invocation compiles and links a source file as `a.out`:

```sh
./rc examples/fact.r
./a.out
```

The example repeatedly asks for a number. It prints `120` for the input `5`.
On a machine without native i386 execution, run the resulting program through
QEMU:

```sh
qemu-i386 ./a.out
```

Use `-o` to select an output name:

```sh
./rc -o fact examples/fact.r
./fact
```

## Useful options

- `-S`: produce assembly, but do not assemble or link it
- `-c`: produce an object file, but do not link an executable
- `-G`: produce only Russell Intermediate Code in a `.G` file
- `-O`: enable the historical local optimizer
- `-o NAME`: select the name of the linked output file

Examples:

```sh
./rc -S examples/fact.r       # produces examples/fact.s
./rc -c examples/fact.r       # produces examples/fact.o
./rc -G examples/fact.r       # produces examples/fact.G
```

Static optimization with `-OO`, demand loading, and the old direct machine-code
backends are not part of the current Linux port.

## Cleaning

```sh
make clean
```

This removes the compiler, helper programs, object files, libraries, and the
top-level `a.out`. It deliberately does not remove every `.G`, `.c`, `.s`, or
`.o` file produced by `rc` next to a Russell source file, because those may be
user files.

## Further information

- [PORTING.md](PORTING.md) records technical decisions and the status of the
  Linux port.
- [PORTING_WITH_CODEX.md](PORTING_WITH_CODEX.md) describes the assistance
  provided by OpenAI Codex.
- [INSTALLATION](INSTALLATION) contains the historical installation guide.
- `doc/` contains the original language and user documentation.

## License notice

The original compiler is subject in particular to the non-commercial-use
restriction stated in the historical [README](README). Additional terms apply
to the DEC/INRIA BigNum package; see `runtime/BigNum/doc/bnbody.tex`. Read the
original notices in full before using or redistributing the software.
