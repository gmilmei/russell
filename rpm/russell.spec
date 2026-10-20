Name:           russell
Version:        3.3
Release:        1%{?dist}
Summary:        Historical Russell programming language compiler

License:        LicenseRef-NonCommercial
Source0:        %{name}-%{version}.tar.gz
ExclusiveArch:  i686 i586 i486 i386

BuildRequires:  binutils
BuildRequires:  gcc
BuildRequires:  gc-devel%{?_isa}
BuildRequires:  glibc-devel%{?_isa}
BuildRequires:  libgcc%{?_isa}
BuildRequires:  make
BuildRequires:  byacc
BuildRequires:  groff
Requires:       binutils
Requires:       cpp
Requires:       gc%{?_isa}

%description
Russell is a historical programming language and compiler.  This package
contains the Linux/i386 port, using the system Boehm garbage collector.
The language is strongly typed, supports higher-order functions and
user-defined abstract data types.

%prep
%autosetup

%build
%make_build -j1
groff -me -Tpdf doc/intro.me > doc/intro.pdf

%install
%make_install prefix=%{_prefix} libdir=%{_libdir}
install -Dpm 644 man/russell.1 %{buildroot}%{_mandir}/man1/russell.1

%check
test -x %{buildroot}%{_bindir}/rc
test -x %{buildroot}%{_bindir}/rhelp
test -x %{buildroot}%{_libdir}/russell/bin/rc
test -f %{buildroot}%{_libdir}/russell/runtime/rrt0.o

%files
%doc README README.md INSTALLATION PORTING* examples emacs doc/initenv.doc doc/intro.pdf doc/Language_changes
%{_mandir}/man1/russell.1*
%license README
%{_bindir}/rc
%{_bindir}/rhelp
%{_libdir}/russell

%changelog
* Tue Oct 20 2026 Russell Linux port maintainers - 3.3-1
- Initial RPM package
