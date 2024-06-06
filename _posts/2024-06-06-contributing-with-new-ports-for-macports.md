---
layout: post
title: Contributing with new ports for Macports
tags:
- macports
- open source
date: 2024-06-06 00:28 -0300
---
[Macports](https://www.macports.org/) is the missing package manager for MacOS.
It's not as popular these days as [Brew](https://brew.sh/), but I still think it better reflects the UNIX philosophy.
The problem of lack of popularity is that sometimes we need to update or implement stuff ourselves for some packages lack maintainers to keep them updated.

For instructions on how to get Macports running and how to install packages with it, please refer to the [official documentation](https://guide.macports.org/#development.creating-portfile).
This text is a reminder to myself of the basic information needed to add new packages to the manager.


# Macports basics

Macports automates the common `./configure; make; make install` steps required to compile and install stuff on UNIX systems.
The actual phases are:

1. **fetch**: download the package.
2. **checksum**: verify the files integrity.
3. **extract**: unzipo and untar files to get the source files.
4. **patch**: apply optional patches to modify source code files.
5. **configure**: well, `./configure`, you know.
6. **build**: compile the source code with `make` or other build tool.
7. **test**: run test suites included with a port (not so common).
8. **destroot**: essentially `make install DESTDIR=${destroot}`.
9. **install**: archive a port's destrooted files.
10. **activate**: extract the port's files from the archive to their final installed locations.

It's fairly complicated, but the whole process is abstracted under the `port install` command.
To include a new package, one has to provide a *Portfile*.
The nice part is that Macports implement a lot of sensible defaults, so the Portfile writer only has to provide information about what falls off default cases.

Let's build a port from scratch to understand the steps required.
I'll use the [GNU hello](https://www.gnu.org/software/hello/) program as example.
First, create a folder to house the new ports.
```bash
mkdir ~/ports
cd ~/ports
```

Tell macports about the new location by editing the file `/opt/local/etc/macports/sources.conf`.
Adapt `<USER>` to your user name.
```
file:///Users/<USER>/ports
rsync://rsync.macports.org/macports/release/tarballs/ports.tar [default]
```
Local files locations should appear before the default location since macports look for stuff in the order they appear in the config file.

Next, fix macports permissions so we don't need root access for indexing the ports.
Edit the file `/etc/local/etc/macports/macports.conf` and uncomment the line that refers to `macportsuser`.
```
# User to run operations as when MacPorts drops privileges.
macportsuser            macports
```

Each portfile should live in a subfolder that reflects its category.
Since a `hello` port already exists in the `mail` category, I'll call my port `hello-tutorial`.
```bash
mkdir -p mail/hello-tutorial
cd mail/hello-tutorial
```

A port file should always be called `Portfile`.
```bash
touch Portfile
```

(Optional) If your port need to patch source code, create a `files` subfolder.
```bash
mkdir files
```

Now write the port. 
Refer to [Macports documentation](https://guide.macports.org/#development.creating-portfile) for a comprehensive guide.


# Creating a Portfile
Edit the `Portfile` you just created.
The first line of the port file can be an optional modeline.
It sets the correct editing options for vim and emacs.
```
# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
```

The first non-comment line of every port should specify the required `PortSystem` field.
It defines which version of the Portfile interpreter will be used (only version 1.0 is supported at the time of this writing).
```
PortSystem          1.0
```

Next, define some fields that describe the package.
```
name                hello-tutorial
version             2.12.1
revision            0

categories          mail
platforms           darwin
license             GPL-3

maintainers         {@edilmedeiros gmail.com:jose.edil+hello-tutorial} \
                    openmaintainer

description         Utility for saying hello and reading email.

long_description    The GNU hello program produces a familiar, friendly greeting. \
                    It allows nonprogrammers to use a classic computer science tool \
                    which would otherwise be unavailable to them.  Because it is \
                    protected by the GNU General Public License, users are free to \
                    share and change it.

homepage            https://www.gnu.org/software/hello/
```

The `name` and `categories` fields should match the subfolders where the Portfile live.
The `version` and `revision` fields are used to identify new versions of packages and update them.
By default, `platforms` will be `darwin` for MacOS; others include `linux` and `freebsd` if your port is compatible with those kind of systems.
The `license` field should reflect the package's license.

The `maintainers` field should be set to you.
Use the format `{github_username domain:email}` to refer to your github username and email in a way to prevent bots to look for your email.

*TIP*: if you use gmail you can create aliases by using `email+alias@gmail.com` .
You get your mail in your regular inbox without any special configuration, but can later filter that address out if spam bots happen to find you.
More info in the [Google blog](https://gmail.googleblog.com/2008/03/2-hidden-ways-to-get-more-from-your.html).

The `description` and `long_description` fields are strings that appear in the website and when searching for ports via `port search`.
In the `homepage` field, add the link to the package website.

Now we tell Macports where to download the source files with the `master_sites` field.
```
master_sites        gnu
master_sites.mirror_subdir \
                    hello
distname            hello-${version}
```
By using `gnu` we're telling Macports to use the GNU mirrors.
By default, it will look for the file `${name}/${name}-${version}.tar.gz` in the `${master_sites}`.
Since we aren't naming the port the same as the package, we should indicate which `mirror_subdir` to access and the base name for the file with `distname`.

Next, we add checksums for the files.
```
checksums           rmd160  3c4a263a0c42e5e07b63f1ac9cf91432839c8a87 \
                    sha256  8d99142afd92576f30b0cd7cb42a8dc6809998bc5d607d88761f512e26c7db20 \
                    size    1033297
```
If the package developer provide checksums, I use them.
When it's not the case, I download and hash the files myself with something like `openssl dgst -rmd160 hello-2.12.1.tar.gz`.
We can get the file `size` with `ls -l`.

This package in particular will require [`libiconv`](https://www.gnu.org/software/libiconv/) to compile.
There's a port for that.
```
depends_lib         port:libiconv
configure.ldflags-append \
                    -liconv
```

The end result looks like this.
```
# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

PortSystem          1.0

name                hello-tutorial
version             2.12.1

categories          mail
platforms           darwin

maintainers         {@edilmedeiros gmail.com:jose.edil+hello-tutorial} \
                    openmaintainer

description         Utility for saying hello and reading email.
long_description    The GNU hello program produces a familiar, friendly greeting. \
                    It allows nonprogrammers to use a classic computer science tool \
                    which would otherwise be unavailable to them.  Because it is \
                    protected by the GNU General Public License, users are free to \
                    share and change it.

homepage            https://www.gnu.org/software/hello/

master_sites        gnu
master_sites.mirror_subdir \
                    hello
distname            hello-${version}

checksums           rmd160  3c4a263a0c42e5e07b63f1ac9cf91432839c8a87 \
                    sha256  8d99142afd92576f30b0cd7cb42a8dc6809998bc5d607d88761f512e26c7db20 \
                    size    1033297

depends_lib         port:libiconv

configure.ldflags-append \
                    -liconv
```


# Installing the local port

We need to create index files so that Macports can find the ports we create.
Use the `portindex` command.
```bash
cd ~/ports
portindex
```

Our port should be visible in the search.
```bash
$ port search hello-tutorial
hello-tutorial @2.12.1 (mail)
    Utility for saying hello and reading email.
```

Install it with `port install`.
```bash
$ sudo port install hello-tutorial
--->  Computing dependencies for hello-tutorial
--->  Fetching distfiles for hello-tutorial
--->  Attempting to fetch hello-2.12.1.tar.gz from https://distfiles.macports.org/hello-tutorial
--->  Attempting to fetch hello-2.12.1.tar.gz from ftp://ftp.unicamp.br/pub/gnu/hello
--->  Verifying checksums for hello-tutorial
--->  Extracting hello-tutorial
--->  Configuring hello-tutorial
Warning: Configuration logfiles contain indications of -Wimplicit-function-declaration; check that features were not accidentally disabled:
  MIN: found in hello-2.12.1/config.log
  __fpending: found in hello-2.12.1/config.log
--->  Building hello-tutorial
--->  Staging hello-tutorial into destroot
--->  Installing hello-tutorial @2.12.1_0
--->  Activating hello-tutorial @2.12.1_0
--->  Cleaning hello-tutorial
--->  Scanning binaries for linking errors
--->  No broken files found.
--->  No broken ports found.
```

We should have a `hello` program available now.
```bash
$ hello
Hello, world!
```

# Uninstalling and cleaning the port

During new port development, we'll probably uninstall and clean broken packages many times.
```
$ sudo port uninstall hello-tutorial
--->  Deactivating hello-tutorial @2.12.1_0
--->  Cleaning hello-tutorial
--->  Uninstalling hello-tutorial @2.12.1_0
--->  Cleaning hello-tutorial
```

Uninstalling does not delete intermediate files from previous installs or from broken packages.
Use `port clean` for that.
```bash
$ sudo port clean --all hello-tutorial
--->  Cleaning hello-tutorial
```

Instead of installing, we can ask Macports to run specific build phases to make easier to see what's happening and find problems.
For example, to just download the files:
```
$ sudo port fetch hello-tutorial
--->  Fetching distfiles for hello-tutorial
--->  Attempting to fetch hello-2.12.1.tar.gz from https://distfiles.macports.org/hello-tutorial
--->  Attempting to fetch hello-2.12.1.tar.gz fromr/pub/gnu/hello
```

This will download files to `/opt/local/var/macports/distfiles/hello-tutorial`.
```bash
$ ls /opt/local/var/macports/distfiles/hello-tutorial
hello-2.12.1.tar.gz
```

# Contributing your new port

If you come to write or update a port, submit it as a PR to https://github.com/macports/macports-ports.
The whole community appreciates.

*PS*: Another great reference I found after writing this: https://krithikrao.com/articles/2019/06/30/developing-and-contributing-a-macport/
