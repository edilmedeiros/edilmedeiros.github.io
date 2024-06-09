---
layout: post
title: Updating MSP430 packages for MacOS embedded development
tags:
- macports
- open source
- msp430
date: 2024-06-09 03:32 -0300
---
I have mixed feelings about the [Texas Instruments' 16 bit MSP430 microcontrollers](https://www.ti.com/microcontrollers-mcus-processors/msp430-microcontrollers/overview.html) family.
One the one hand, the hardware is very well thought and documentation is great.
Their [Launchpad development boards](https://www.ti.com/design-development/embedded-development/msp430-mcus.html#hardware) are quite affordable and sweet to use.

If you use their [Code Composer Studio (CCS) IDE](https://www.ti.com/tool/CCSTUDIO)...

That's where my good feelings vanish.
First iterations of CCS were based on classic Eclipse, a clunky experience for someone used to write software using the state of the art open source developer triad: emacs + gcc + gdb.
There's a newer version based on the Eclipse Theia, based on parts of VS Code.

The MSP430 MCUs are still my go to when I need something simple and small.
It's also the platform I use on my microcontrollers course at the university.
In a world of ARM processors everywhere, I still think it's better to have a simpler architecture to explain how computers work under the hood.

The CSS IDEs come with proprietary toolchains.
But Texas Instruments provide an open source alternative based on GCC 9.3 ([circa 2020, not supported anymore](https://gcc.gnu.org/gcc-9/), but usable for hobbyists).
The open source toolchain was a partnership with Mitto Systems[^1], but seem to be a stalled project.
Yet, I sometimes want to play with their hardware, so let's update the macports packages.

[^1]: Unfortunately, [Mitto Systems was closed](https://find-and-update.company-information.service.gov.uk/company/11137150/filing-history) and Texas Instruments seem to not bother anymore about the open source toolchain.


# Updating the MSP430 Macports packages

A quick search with `port search msp` reveal that the most recent ports with the MSP430 toolchain are `msp430-elf.gcc` and `msp430-elf-binutils` which depend on `msp430-gcc-support-files`.
We will also need `mspdebug` to flash the devices (which will require some hacking to get working).
Since I'm on a Apple Silicon computer, I'll not have the benefit of using `gdb` for debugging (see [this](https://github.com/orgs/Homebrew/discussions/1114).
I could try to [use `lldb`](https://github.com/codeplaysoftware/lldb-msp430), but I'm not in the mood of putting that much effort on it.

I like to start from dependencies.

## `msp430-gcc-support-files`

The [original Portfile is here](https://github.com/macports/macports-ports/blob/ca630ab30f63d9912069f13e5b0c9a5ec0710578/cross/msp430-gcc-support-files/Portfile).

First thing I noticed is that the link on `master_sites` is broken.
This is where macports will try to download the package.
Following the `homepage` link I found the new resource called `Header and Support Files` with a link to version 1.212.
This package contain header and linker files with definitions of the many registers for each device in the MSP430 family.

Let's bump the version up and update the download link.

```
version             1.212
master_sites        https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/9.3.1.2/
```

We need to update the checksums so that macports can verify the file integrity.
Since TI provides an `md5` checksum, let's use it and update the others by download and hashing the file locally.
```
checksums           md5     1f316453879c0cdea3a83e152eac69c1 \
                    rmd1160 dc7f246ef24571a15b28e890b2fac4baf976eaef \
                    sha256  3b1a39f10a344dfefb767e60ac35becef4c065013be86993195b138a5fb0b8d6 \
                    size    22257819
```

`sudo port install` worked out of the box.
The port installs all the files in `/opt/local/msp430-elf`, which is a bit unusual.
Let's not changed that, just add a note to let the user know about it.
This information is needed to compile firmware using `msp430-elf-gcc`.
```
notes "
MSP430 support files were installed in ${prefix}/msp430-elf.
"
```

## `msp430-elf-binutils`

Next is [`msp430-elf-binutils` portfile](https://github.com/macports/macports-ports/blob/ca630ab30f63d9912069f13e5b0c9a5ec0710578/cross/msp430-elf-binutils/Portfile).
This required me to learn a new bit of macports: `PortGroup`s.
The [documentation](https://guide.macports.org/index.html#reference.portgroup) describe them as include files for portfiles.
Well, they do a lot of stuff, actually.
In the case of binutils, it will download and compile the whole package.
All I need to do here is to patch using the provided files from TI's that come in a package called `Mitto Systems GCC source file patches`.

The binutils patch is based on version 2.34.
```
crossbinutils.setup msp430-elf 2.34
set vers_patch      9.3.1.11
```

Let's update the download link and checksums.
```
master_sites-append https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/9.3.1.2/:patch

distfiles-append    ${file_patch}:patch
checksums-append    ${file_patch} \
                    md5     8f305461a3b32fc8d1155bf18685f53b \
                    rmd160  a8e5a2ddb2adf4ed9370ec632d361b2e6b2c4613 \
                    sha256  ec6472b034e11e8cfdeb3934b218e5bafbb7a03f3afc0e76536bd9c42653525b \
                    size    283677
```

Adjust the version number of the patch.
```
pre-patch {
    system -W ${worksrcpath} "/usr/bin/patch -p0 < ${workpath}/${name_patch}/binutils-2_34.patch"
}
```

This was already compiling as is.
But I noted there's a build script bundled together with the patches provided by TI.
Inspecting that, I decided to update the configure script arguments to reflect what was there.
```
configure.args-append \
                    --target=msp430-elf \
                    --enable-languages=c,c++ \
                    --disable-nls \
                    --enable-initfini-array \
                    --disable-sim \
                    --disable-gdb \
                    --disable-werror
```

## `msp430-elf-gcc`

The compiler, finally.
This one took me way more time to get working because some Apple update broke the GCC build.
And since we will use an unsupported version (9.3.0), I had to adapt the fixes myself.

First, update the version numbers.
```
crossgcc.setup      msp430-elf 9.3.0
crossgcc.setup_libc newlib 2.4.0

set vers_patch      9.3.1.11
```

Next, update the download link to the patches provided by TI.
```
master_sites-append https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/9.3.1.2/:patch

distfiles-append    ${file_patch}:patch
checksums-append    ${file_patch} \
                    md5     8f305461a3b32fc8d1155bf18685f53b \
                    rmd160  a8e5a2ddb2adf4ed9370ec632d361b2e6b2c4613 \
                    sha256  ec6472b034e11e8cfdeb3934b218e5bafbb7a03f3afc0e76536bd9c42653525b \
                    size    283677
```

Now, update the patches file names.
```
pre-patch {
    system -W ${worksrcpath} "/usr/bin/patch -p0 < ${workpath}/${name_patch}/gcc-9.3.0.patch"
    system -W ${workpath}/newlib-2.4.0 "/usr/bin/patch -p0 < ${workpath}/${name_patch}/newlib-2_4_0.patch"
}
```

Finally, update the configure flags to match the TI's build script.
```
configure.args-append \
                    --target=msp430-elf \
                    --enable-languages=c,c++ \
                    --disable-nls \
                    --enable-initfini-array \
                    --enable-target-optspace \
                    --enable-newlib-nano-formatted-io \
```

`sudo port build msp430-elf-gcc` was complaining about incompatible integer to pointer conversion when compiling newlib (the C standard library for embedded systems).
Fixed the build by disabling the errors.
```
# Required to build the patched newlib
configure.cflags-append \
                    -Wno-error=int-conversion
```

Next, the gcc build complained that `error: '__abi_tag__' attribute only applies to structs, variables, functions, and namespaces` in many places related to the file `gcc/system.h`.
After some research, I found this [ticket on the GCC Bugzilla](https://gcc.gnu.org/bugzilla/show_bug.cgi?format=multiple&id=111632) with an included patch that was merged in the supported compiler versions.
But since I'm using an old version, I had to apply the patch myself on the source files and create a new one.
```
# gcc_system.diff: See https://gcc.gnu.org/bugzilla/show_bug.cgi?format=multiple&id=111632
patchfiles          gcc_system.diff
```

The build proceeded, but failed to link with.
```
Undefined symbols for architecture arm64:
  "_host_hooks", referenced from:
  ...
```
More research lead me to [this issue in the risc-v repo](https://github.com/riscv-software-src/homebrew-riscv/issues/47).
I adapted their patch and added to my config.
```
# gcc_system.diff: See https://gcc.gnu.org/bugzilla/show_bug.cgi?format=multiple&id=111632
# gcc_config_host.diff: See https://github.com/riscv-software-src/homebrew-riscv/issues/47
patchfiles          gcc_system.diff \
                    gcc_config_host.diff
```

The build finished and I have a working gcc compiler for the MSP430. 🙌

## `mspdebug`

The `mspdebug` is used to flash the hardware.
The package seemed up to date with version 0.25 available.
But when I tried to use it I got an error.
```shell
$ mspdebug tilib
MSPDebug version 0.25 - debugging tool for MSP430 MCUs
Copyright (C) 2009-2017 Daniel Beer <dlbeer@gmail.com>
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Chip info database from MSP430.dll v3.3.1.4 Copyright (C) 2013 TI, Inc.

tilib_api: can't find libmsp430.so: dlopen(libmsp430.so, 0x0001): tried: 'libmsp430.so' (no such file), '/System/Volumes/Preboot/Cryptexes/OSlibmsp430.so' (no such file), '/usr/lib/libmsp430.so' (no such file, not in dyld cache), 'libmsp430.so' (no such file)
```

`libmsp430.so` is the TI USB driver to talk with the hardware debugger on the board.
Well, I scanned my system for this `libmsp430.so` to find nothing.
I inspected the CCS install folder and there is such a file there.
But when I tried to use, the tool complained that it was compiled for `x86_64`, not for `arm64`.
There's also no port providing this library.
So, I'll have to make my own port.

## `libmsp430`

The driver is part of [TI's MSP Debug Stack](https://www.ti.com/tool/MSPDS), currently in version 3.15.1.1.
Start from the beginning.
```
# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8::et:sw=4:ts=4:sts=4

PortSystem          1.0

name                libmsp430
version             3.15.1.1

maintainers         {@edilmedeiros gmail.com:jose.edil+marcports} \
                    openmaintainer
```

Add the link and checksums.
```
homepage            https://www.ti.com/tool/MSPDS
master_sites-append https://dr-download.ti.com/software-development/driver-or-library/MD-4vnqcP1Wk4/3.15.1.1/

distfiles           MSPDebugStack_OS_Package_3_15_1_1.zip
checksums           md5     c16ee393e6d5388e8352aed6a716b7ba \
                    rmd160  efdad29b4f2247d92adbbe0ebc44a8e37140ca7d \
                    sha256  e3a59a98c43de7a92e5814d8c3304026165e6d2551e60acaca1f08c6b1a4bac8 \
                    size    2184052
```

The package readme says it requires boost to build.
I keep boost `1.78` installed, this should be sufficient.
```
depends_lib         port:boost178 \
                    port:hidapi
```

Since this is a zip file.
```
depends_extract-append \
                    port:zip

use_zip             yes
```

Add the make arguments specified in the readme file.

```
worksrcdir          {}

use_configure       no

build.args          STATIC=1 BOOST_DIR=${prefix}/libexec/boost/1.78 PREFIX=${prefix}
```

Try to build to find the compiler complain it can't find the `hidapi` includes.
Well, patch the makefiles and try again.
Now, the linker can't find the boost files, even when passing the make correct `make` argument.

After some time investigating, I found that the boost port will not compile the single thread version required by the package.
Let's add this as a dependency to our package as well as the makefile patches.
```
PortGroup           active_variants 1.1
require_active_variants \
                    boost178 {} {no_single}
                    
patchfiles          bsl430dll_makefile.diff \
                    makefile.diff
```

Now the build works.
But I can't install the tool in the right folder.
Well, that required an upgrade to the makefile again so that it uses [the `$DESTDIR` variable](https://www.gnu.org/prep/standards/html_node/DESTDIR.html).
Change the port again to fix the destroot phase.
```
build.args          STATIC=1 BOOST_DIR=${prefix}/libexec/boost/1.78 PREFIX=${prefix}

destroot.env-append PREFIX=${prefix}
```

And it works.

## `mspdebug` again

Remember that `mspdebug` was complain about the `libmsp430.so` file?
In MacOS, dynamic libraries are supposed to have the `.dynlib` suffix.
So, I added a patch to fix that in the C source code and updated port.
```
revision            3

patchfiles          patch-Makefile.diff \
                    fix-dynlib-load.diff
```

Final piece, to run `mspdebug` we need to set the `DYLD_LIBRARY_PATH` flag so that `dlopen()` can find the shared library.
```shell
$ export DYLD_LIBRARY_PATH="/opt/local/lib"
$ mspdebug tilib

MSPDebug version 0.25 - debugging tool for MSP430 MCUs
Copyright (C) 2009-2017 Daniel Beer <dlbeer@gmail.com>
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Chip info database from MSP430.dll v3.3.1.4 Copyright (C) 2013 TI, Inc.

Using new (SLAC460L+) API
MSP430_GetNumberOfUsbIfs
MSP430_GetNameOfUsbIf
Found FET: usbmodem21201
MSP430_Initialize: usbmodem21201
Firmware version is 31501001
MSP430_VCC: 3000 mV
MSP430_OpenDevice
MSP430_GetFoundDevice
Device: MSP430F5529 (id = 0x002f)
8 breakpoints available
MSP430_EEM_Init
Chip ID data:
  ver_id:         2955
  ver_sub_id:     0000
  revision:       18
  fab:            55
  self:           5555
  config:         12
  fuses:          55
Device: MSP430F5529

Available commands:
    !               fill            power           setwatch_r
    =               gdb             prog            setwatch_w
    alias           help            read            simio
    blow_jtag_fuse  hexout          regs            step
    break           isearch         reset           sym
    cgraph          load            run             verify
    delbreak        load_raw        save_raw        verify_raw
    dis             md              set
    erase           mw              setbreak
    exit            opt             setwatch

Available options:
    color                       gdb_default_port
    enable_bsl_access           gdb_loop
    enable_fuse_blow            gdbc_xfer_size
    enable_locked_flash_access  iradix
    fet_block_size              quiet

Type "help <topic>" for more information.
Use the "opt" command ("help opt") to set options.
Press Ctrl+D to quit.

(mspdebug)
```

# Final remarks

I added myself as maintainer of these packages, even tough I'm not using these toolchain that often.
You can check the final ports on the PRs.
- [libmsp430](https://github.com/macports/macports-ports/pull/24397)
- [mspdebug](https://github.com/macports/macports-ports/pull/24398)
- [msp430-gcc-support-files](https://github.com/macports/macports-ports/pull/24399)
- [msp430-elf-binutils](https://github.com/macports/macports-ports/pull/24400)
- [msp430-elf-gcc](https://github.com/macports/macports-ports/pull/24402)

I hope they are useful for other hobbyists.
