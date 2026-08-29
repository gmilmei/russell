# Russell Compiler 3.3 für Linux

[English version](README.md)

Dieses Repository enthält den historischen Russell-Compiler 3.3 und eine
Portierung auf Linux/i386. Der Compiler erzeugt 32-Bit-ELF-Programme und
verwendet den Boehm Garbage Collector des Systems.

Die originale Dokumentation liegt weiterhin in [README](README) und
[INSTALLATION](INSTALLATION). Die dort beschriebene Installation für SunOS
und a.out-Systeme ist für diese Linux-Portierung normalerweise nicht nötig.

## Voraussetzungen

Die Portierung setzt eine x86-Linux-Umgebung mit 32-Bit-Entwicklungsdateien
voraus. Benötigt werden:

- GNU Make, GCC und Binutils
- 32-Bit-C-Bibliothek und 32-Bit-GCC-Laufzeit
- Boehm GC einschließlich der 32-Bit-Entwicklungsdateien
- `qemu-i386` oder native Unterstützung für Linux-i386-Programme

Auf Fedora lassen sich die benötigten Pakete beispielsweise so installieren:

```sh
sudo dnf install gcc make binutils glibc-devel.i686 libgcc.i686 gc-devel.i686 qemu-user
```

Auf einem System, das ELF32/i386 nativ ausführen kann, ist QEMU nicht
erforderlich. In diesem Fall kann der ABI-Test ohne Runner gestartet werden:

```sh
make I386_RUNNER=
```

## Bauen

Im Wurzelverzeichnis des Repositories genügt:

```sh
make
```

Der Build prüft zuerst die Ziel-ABI. Eine erfolgreiche Prüfung meldet:

```text
Russell target ABI: Linux i386, 8-bit bytes, 32-bit words
```

Danach befinden sich der Compiler-Treiber `rc`, der Bootstrap-Compiler
`src/Rc` und die benötigten Werkzeuge im Quellbaum.

Für einen vollständigen Neuaufbau:

```sh
make clean
make
```

Der absolute Pfad zum Repository wird beim Build in `rc` eingebettet. Der
Quellbaum sollte deshalb nach dem Build nicht verschoben werden. Statt `rc`
zu kopieren, empfiehlt sich ein symbolischer Link in ein persönliches
Bin-Verzeichnis:

```sh
mkdir -p "$HOME/.local/bin"
ln -s "$(pwd)/rc" "$HOME/.local/bin/rc"
```

Falls nötig, anschließend `~/.local/bin` zu `PATH` hinzufügen.

## Ein Russell-Programm übersetzen

Der einfachste Aufruf übersetzt und linkt eine Quelldatei zu `a.out`:

```sh
./rc examples/fact.r
./a.out
```

Das Beispiel fragt wiederholt nach einer Zahl. Für die Eingabe `5` gibt es
`120` aus. Auf einem Rechner ohne native i386-Ausführung kann das fertige
Programm über QEMU gestartet werden:

```sh
qemu-i386 ./a.out
```

Ein bestimmter Ausgabename wird mit `-o` gewählt:

```sh
./rc -o fact examples/fact.r
./fact
```

## Nützliche Optionen

- `-S`: bis zur Assemblerdatei übersetzen, aber nicht assemblieren oder linken
- `-c`: eine Objektdatei erzeugen, aber kein ausführbares Programm linken
- `-G`: nur Russell Intermediate Code in einer `.G`-Datei erzeugen
- `-O`: die historische lokale Optimierung einschalten
- `-o NAME`: Namen der gelinkten Ausgabedatei festlegen

Beispiele:

```sh
./rc -S examples/fact.r       # erzeugt examples/fact.s
./rc -c examples/fact.r       # erzeugt examples/fact.o
./rc -G examples/fact.r       # erzeugt examples/fact.G
```

Die statische Optimierung mit `-OO`, Demand Loading und die alten direkten
Maschinencode-Backends gehören nicht zum derzeitigen Linux-Port.

## Aufräumen

```sh
make clean
```

Das entfernt den Compiler, Hilfsprogramme, Objektdateien, Bibliotheken und das
Top-Level-`a.out`. Von `rc` neben einer Russell-Quelldatei erzeugte `.G`, `.c`,
`.s` oder `.o`-Dateien werden nicht pauschal gelöscht, damit keine eigenen
Dateien verloren gehen.

## Weitere Informationen

- [PORTING.md](PORTING.md) dokumentiert technische Entscheidungen und den
  Stand der Linux-Portierung.
- [PORTING_WITH_CODEX.md](PORTING_WITH_CODEX.md) beschreibt die Unterstützung
  durch OpenAI Codex.
- [INSTALLATION](INSTALLATION) enthält die historische Installationsanleitung.
- `doc/` enthält die ursprüngliche Sprach- und Benutzerdokumentation.

## Lizenzhinweis

Für den ursprünglichen Compiler gilt insbesondere die im historischen
[README](README) genannte Beschränkung auf nichtkommerzielle Nutzung. Für das
DEC/INRIA-BigNum-Paket gelten zusätzliche Bedingungen in
`runtime/BigNum/doc/bnbody.tex`. Vor einer Weitergabe oder Nutzung sollten
diese Originalhinweise vollständig gelesen werden.
