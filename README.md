Shell script reads a directory tree of images, creates a parallel tree of
thumbnail images, preview images, and static html page views all linked
together.  The script actually generates XML pages.  Use provided XSL and CSS
stylesheets to generate and style the HTML.

The www directory contains a few odd sample pictures for testing.

## Usage:

Invoke gallery.sh with three arguments-
- the first is the common root for the (existing) directory of photos and
  the (existing or to be) directory of gallery files
- the second is the source directory of images, relative to first
- the third is the destination directory name, relative to the first

For example, `./gallery.sh www photos album`

Next, run an XSL transform of the XML files in the result, album
directory.  Use
- the build.xml script if you have ant
- the transform.sh script if you have Xalan Java
- the c-transform.sh script if you have Xalan C

For example, `./c_transform.sh style/site.xsl www album`

Finally, point your browser to `www/album/index.html`

## Trouble:

### Can't locate Escape.pm

```
Can't locate URI/Escape.pm in @INC (@INC contains: ...
```

If you get this message, your shell cannot find the perl script used to escape
file names that contain special characters.  Resolve it as follows:

1. launch Perl’s CPAN:
   `sudo perl -MCPAN -e shell`
2. Once CPAN launches, install the URI/Escape Perl module:
   `cpan> install URI::Escape`
3. Exit CPAN:
   `cpan> exit`

### Missing CSS stylesheets
Find sample CSS stylesheets in the `www/style` directory.

You can change the stylesheet references in
`style/layout.xsl` and `style/album.xsl` to find these stylesheets
in whatever location you would like, wherever you would like to put them.

## Xalan and Xerces
You will need an XSL Transform engine, such as Xalan.  
Xalan in turn requires the XML parser Xerces.
These short notes will help you find and install Xerces and Xalan.  

### Xerces installation:
On Mac OS the [hombrew](https://brew.sh/) package manager can
install Xerces: `brew install xerces`. It installs the C implementation.

Otherwise, the following might help

[Xerces documentation at Apache.org](http://xerces.apache.org/xerces-c/)

Download, verify, extract.
Follow the build instructions.
On a Linux host, the following might work well:

```
cd xerces-c-3.11
./configure --prefix=$HOME/Xerces
make
make install
```

You ought to have populated lib and bin directories in `$HOME/Xerces`.

### Xalan installation:
On Mac OS the [hombrew](https://brew.sh/) package manager can
install Xalan: `brew install xalan`. It installs the C implemention.

Otherwise, the following might help:

[Xalan documentation at Apache.org](https://xalan.apache.org/xalan-c/)

Download, verify, extract.
Follow the build instructions.  On a Linux host, the following might work well

```
cd xalan-c-1.11/c
export XERCESCROOT=$HOME/Xerces
export XALANCROOT=`pwd`
./runConfigure -p linux -c gcc -x g++ -P $HOME/Xalan
make
make install
```

You ought to have populated lib and bin directories in `$HOME/Xalan`.

In order to execute Xalan:

```
export XERCESCROOT=$HOME/Xerces
export XALANCROOT=$HOME/Xalan
export LD_LIBRARY_PATH=$HOME/Xerces/lib:$HOME/Xalan/lib:$LD_LIBRARY_PATH
export PATH=$HOME/Xalan/bin:$HOME
Xalan
```
