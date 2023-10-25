# A knotplot qr code generator

This is an addon script for Rob Scharein's great knot drawing tool [knotplot](https://www.knotplot.com/). Rob has recently included the [Lua](https://www.lua.org) scripting engine into knotplot allowing for some fairly advanced interactions with knotplot.

This script uses the knotplot's celtic knot drawing tools to draw "LR" codes (qr codes but made of links). Some examples:

![knotplot](https://github.com/Joecstarr/knotplot_qr/blob/main/examples/qr_httpswww.knotplot.com.svg?sanitize=true)
![joe-starr](https://github.com/Joecstarr/knotplot_qr/blob/main/examples/qr_httpsjoe-starr.com.svg?sanitize=true)
![wikipedia.org/wiki/QR_code](https://github.com/Joecstarr/knotplot_qr/blob/main/examples/qr_httpsen.wikipedia.orgwikiQRcode.svg?sanitize=true)

## How to use

The script runs entirely in knotplot so you need to purchase and install knotplot. The script currently depends on a beta version of knotplot which will be wildly available soon.

### Git pull

Start by pulling this repo into your knotplot workspace.

```sh
git pull https://github.com/Joecstarr/knotplot_qr.git
```

### Git update submodule

The script uses the [luaqrcode](https://github.com/speedata/luaqrcode) library. The library is referenced as a git submodule which can be pulled by running

```sh
git submodule update --init --recursive
```
### Run script

Run the script in knotplot by using the lua run command. The first argument is interpreted as the string to convert to QR code.

```
lua run knotplot_qr/knotplot_qr.lua <string>
```

## Post processing

The output of the script is an postscript (```.eps```) file. This can be turned into an image by using [inkscape](https://inkscape.org/) or [imagemagick](https://imagemagick.org/index.php).

