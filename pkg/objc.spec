Summary: Portable Object Compiler
Name: objc
Version: 3.3.11
Release: 1%{?dist}
Group: Applications/File
License: GPLv2+
Source: http://users.pandora.be/stes/objc-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
The Portable Object Compiler, a language and a runtime library for producing C programs that operate by the runtime conventions of Smalltalk 80 in a UNIX environment, as described in Brad Cox's book on Objective-C.  Smalltalk and Objective-C offer Object Oriend Programming in which data, and the programs which may access it, are designed, built and maintained as inseparable units called objects.  The precompiler is backed by a library which supports Smalltalk 80's interpretation of messaging; binding of a message to its target routine is done at run time.  The library also contains a growing number of primitive class definitions, such as an Object class whose abilities are inherited by every object in the system and features such as Blocks, enclosures like in Smalltalk 80.

%prep
%setup -q
./configure OBJCDIR=%{_prefix} --prefix=$RPM_BUILD_ROOT%{_prefix}

%build

make compiler

%install

rm -rf $RPM_BUILD_ROOT
mkdir $RPM_BUILD_ROOT

make install

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_bindir}/objc
%{_bindir}/objc1
%{_bindir}/cvtimport
%{_bindir}/postlink
%{_libdir}/objcrt.a
%{_libdir}/objpak.a
%{_libdir}/cakit.a
%{_libdir}/_prelink.o
%{_libdir}/_predll.o
%{_libdir}/objchelp.txt
%{_libdir}/objcdlso.ld
%{_prefix}/include/objcrt/OutOfMem.h
%{_prefix}/include/objcrt/Object.h
%{_prefix}/include/objcrt/objc.h
%{_prefix}/include/objcrt/Exceptn.h
%{_prefix}/include/objcrt/Message.h
%{_prefix}/include/objcrt/Block.h
%{_prefix}/include/objcrt/objcrt.h
%{_prefix}/include/cakit/cfloat.h
%{_prefix}/include/cakit/term.h
%{_prefix}/include/cakit/ccltn.h
%{_prefix}/include/cakit/matrix.h
%{_prefix}/include/cakit/polynom.h
%{_prefix}/include/cakit/cseq.h
%{_prefix}/include/cakit/intmodp.h
%{_prefix}/include/cakit/integer.h
%{_prefix}/include/cakit/ccomplex.h
%{_prefix}/include/cakit/monomial.h
%{_prefix}/include/cakit/cobject.h
%{_prefix}/include/cakit/symbol.h
%{_prefix}/include/cakit/cakit.h
%{_prefix}/include/cakit/vector.h
%{_prefix}/include/cakit/fraction.h
%{_prefix}/include/ppi/vectors.h
%{_prefix}/include/ppi/IPSequence.h
%{_prefix}/include/ppi/OrdCltn.h
%{_prefix}/include/ppi/String.h
%{_prefix}/include/ppi/SortCltn.h
%{_prefix}/include/ppi/Filer.h
%{_prefix}/include/ppi/IdArray.h
%{_prefix}/include/ppi/IntArray.h
%{_prefix}/include/ppi/Graph.h
%{_prefix}/include/ppi/Sequence.h
%{_prefix}/include/ppi/Array.h
%{_prefix}/include/ppi/mivarargs.h
%{_prefix}/include/ppi/StringCl.h
%{_prefix}/include/ppi/ICpak101.h
%{_prefix}/include/ppi/Assoc.h
%{_prefix}/include/objpak/set.h
%{_prefix}/include/objpak/outofbnd.h
%{_prefix}/include/objpak/rectangl.h
%{_prefix}/include/objpak/bag.h
%{_prefix}/include/objpak/array.h
%{_prefix}/include/objpak/ascfiler.h
%{_prefix}/include/objpak/idarray.h
%{_prefix}/include/objpak/cltn.h
%{_prefix}/include/objpak/unknownt.h
%{_prefix}/include/objpak/ordcltn.h
%{_prefix}/include/objpak/badvers.h
%{_prefix}/include/objpak/runarray.h
%{_prefix}/include/objpak/sortcltn.h
%{_prefix}/include/objpak/point.h
%{_prefix}/include/objpak/txtattr.h
%{_prefix}/include/objpak/ocstring.h
%{_prefix}/include/objpak/intarray.h
%{_prefix}/include/objpak/octext.h
%{_prefix}/include/objpak/paragrph.h
%{_prefix}/include/objpak/sequence.h
%{_prefix}/include/objpak/stack.h
%{_prefix}/include/objpak/dictnary.h
%{_prefix}/include/objpak/notfound.h
%{_prefix}/include/objpak/typeinc.h
%{_prefix}/include/objpak/objpak.h
%{_prefix}/include/objpak/txtstyle.h
%{_mandir}/man1/cvtimport.1.gz
%{_mandir}/man1/objc.1.gz
%{_mandir}/man1/postlink.1.gz
%{_mandir}/man1/vici.1.gz
%{_mandir}/man3/Array.3.gz
%{_mandir}/man3/AsciiFiler.3.gz
%{_mandir}/man3/BadVersion.3.gz
%{_mandir}/man3/Bag.3.gz
%{_mandir}/man3/BigInt.3.gz
%{_mandir}/man3/Block.3.gz
%{_mandir}/man3/CAObject.3.gz
%{_mandir}/man3/Cltn.3.gz
%{_mandir}/man3/Complex.3.gz
%{_mandir}/man3/Dictionary.3.gz
%{_mandir}/man3/Exception.3.gz
%{_mandir}/man3/Float.3.gz
%{_mandir}/man3/Fraction.3.gz
%{_mandir}/man3/IdArray.3.gz
%{_mandir}/man3/IntArray.3.gz
%{_mandir}/man3/IntegerModp.3.gz
%{_mandir}/man3/Matrix.3.gz
%{_mandir}/man3/Message.3.gz
%{_mandir}/man3/Monomial.3.gz
%{_mandir}/man3/NotFound.3.gz
%{_mandir}/man3/Object.3.gz
%{_mandir}/man3/OrdCltn.3.gz
%{_mandir}/man3/OutOfBounds.3.gz
%{_mandir}/man3/OutOfMemory.3.gz
%{_mandir}/man3/Paragraph.3.gz
%{_mandir}/man3/Point.3.gz
%{_mandir}/man3/Polynomial.3.gz
%{_mandir}/man3/Rectangle.3.gz
%{_mandir}/man3/RunArray.3.gz
%{_mandir}/man3/Sequence.3.gz
%{_mandir}/man3/Set.3.gz
%{_mandir}/man3/SortCltn.3.gz
%{_mandir}/man3/Stack.3.gz
%{_mandir}/man3/String.3.gz
%{_mandir}/man3/Symbol.3.gz
%{_mandir}/man3/Term.3.gz
%{_mandir}/man3/Text.3.gz
%{_mandir}/man3/TextAttribute.3.gz
%{_mandir}/man3/TextStyle.3.gz
%{_mandir}/man3/TypeInconsistency.3.gz
%{_mandir}/man3/UnknownType.3.gz
%{_mandir}/man3/Vector.3.gz
%doc Beos.txt Books.txt Changes.txt Ibmvac.txt Install.txt Intro.txt Lcc.txt License.txt Mpw.txt Platform.txt Readme.txt Visual.txt Vms.txt Watcom.txt

%changelog
* Wed Mar 13 2019 David Stes <stes@telenet.be> 3.3.11
Update for 3.3.11

* Sun Dec 25 2016 David Stes <stes@telenet.be> 3.3.5
Update for 3.3.5

* Sat Aug 27 2016 David Stes <stes@telenet.be> 3.3.4
Update for 3.3.4

* Fri Dec 25 2015 David Stes <stes@telenet.be> 3.3.1
Update for 3.3.1

* Sat Sep 26 2015 David Stes <stes@telenet.be> 3.2.13
Copy spec file from example

