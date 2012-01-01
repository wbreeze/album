#!/bin/bash
#

VERSION=5

PICSIZE='600'
PICFMT='png'
THUMBSIZE='200'

umask 022

[[ -d "$2" ]] && cd "$2"
[[ -f gallery.txt ]] && GALLERY=$(cat gallery.txt)

echo "Processing: $(pwd)"

PICNUM=0
for IMAGE in $(find -maxdepth 1 \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -a \! -name '*.*.*' -printf "'%f'\n" | sort ); do
  chmod 0644 "$IMAGE"
  NAME=${IMAGE%.*}
  THUMB="$NAME.thumb.$PICFMT"
  PICTURE="$NAME.$PICSIZE.$PICFMT"
  PICTURES[$PICNUM]="$IMAGE"
  PICNUM=$((PICNUM+1))
  if [ ! -f "$THUMB" ]; then
    convert \"$IMAGE\" \
      -auto-orient \
      -thumbnail "${THUMBSIZE}x${THUMBSIZE}>" \
      -unsharp 0x.5 \
      -quality 95 \
      "$THUMB"
  fi
  if [ ! -f "$PICTURE" ]; then
    convert \"$IMAGE\" \
      -auto-orient \
      -scale "${PICSIZE}x${PICSIZE}>" \
      -unsharp 0x.5 \
      -quality 95 \
      "$PICTURE"
  fi
done

DIRNUM=0
for DIR in $(find -mindepth 1 -maxdepth 1 -type d | sort); do
  if [ "$1" == "-r" -a -f "$DIR/gallery.txt" ]; then
    $0 "$GALLERY" "$DIR"
    DIRS[$DIRNUM]="$DIR"
    DIRNUM=$((DIRNUM+1))
  fi
done

PICCNT=$PICNUM
PICNUM=0

DIRCNT=$DIRNUM
DIRNUM=0

if [ "$PICCNT" == 0 -a "$DIRCNT" == 0 ]; then
  echo 'no pics found'
  exit 0;
fi


if [ -n "$1" -a "$1" != "-r" ]; then
  CAPTION="<a href='../'>$1</a> - $GALLERY"
  GALLERY="$1 - $GALLERY"
else
  CAPTION="$GALLERY"
fi
if [ -f './.css' ]; then
  CSS='<link rel="stylesheet" type="text/css" href="./.css">'
elif [ "$1" == "-r" ]; then
  [[ -f '../.css' ]] && CSS='<link rel="stylesheet" type="text/css" href="../.css">'
fi

ZIP=`echo "$GALLERY" | sed -e "s/%20/_/g" -e "s/\./_/g" -e "s/ /_/g"`;
ZIP=`echo "$ZIP" | sed -e "s/[^A-Za-z0-9_-]//g"`
ZIP="$ZIP.zip"
zip "$ZIP" ${PICTURES[@]}
ZIPSIZE=$(du -h "$ZIP" | cut -f 1)

IMAGE=${PICTURES[0]}
NAME=${IMAGE%.*}

cat > index.html <<EOF
<html>
<head>
  <title>$GALLERY</title>
  <link rel="stylesheet" type="text/css" href="/.css">
  $CSS
  <script src="/.js" type="text/javascript"></script>
  <script type="text/javascript">
    function onLoad(){
      document.getElementById('play').style.display = 'inline' ;
    }
  </script>
</head>
<body onLoad="onLoad()">
<h1>$CAPTION</h1>
EOF

if [ "$PICCNT" != 0 ]; then
cat >> index.html <<EOF
<div id="MenuCont">
  <div id="Menu">
    <a id='play' href="$NAME.html?slide=1"><img src="/pix/play.png" name="play" title="Play Sideshow" /></a>
    <a href='./$ZIP'><img src="/pix/down.png" alt="download" title="Download Gallery ($ZIPSIZE)" /></a>
  </div>
</div>
EOF
fi

while [ $DIRNUM -lt $DIRCNT ]; do
  DIR=${DIRS[$DIRNUM]}
  COMMENT=$(cat $DIR/gallery.txt)
  THUMB=$(ls $DIR/*.thumb.$PICFMT | head -1)
  identify -ping -format "<div id=\"thumb\"><a href=\"$DIR/index.html\"><img src=\"%i\" title=\"$COMMENT\" width=\"%w\" height=\"%h\" /></a></div>" $THUMB >> index.html
  DIRNUM=$((DIRNUM+1))
done

while [ $PICNUM -lt $PICCNT ]; do
  JS=''
  MENU=''
  COMMENT=''
  IMAGE=${PICTURES[$PICNUM]}
  NAME=${IMAGE%.*}
  THUMB="$NAME.thumb.$PICFMT"
  PICTURE="$NAME.$PICSIZE.$PICFMT"
  THUMB="$NAME.thumb.$PICFMT"
  if [ $PICNUM -gt 0 ]; then
    PREV=${PICTURES[$((PICNUM-1))]%.*}
    JS="loadImage('$PREV.$PICSIZE.$PICFMT');"
  else
    PREV='./index'
  fi
  MENU="<a id='prev' href='$PREV.html'><img title='Previous Image' src="/pix/prev.png" /></a>"
  MENU="$MENU<a id='play' href='$NAME.html'><img src="/pix/play.png" name="play" title="Play" /></a>"
  if [ $PICNUM -lt $((PICCNT-1)) ]; then
    NEXT=${PICTURES[$((PICNUM+1))]%.*}
    JS="$JS loadImage('$NEXT.$PICSIZE.$PICFMT');"
  else
    NEXT='./index'
  fi
  MENU="$MENU<a id='next' href='$NEXT.html'><img title='Next Image' src="/pix/next.png" /></a>"
  IMGSIZE=$(du -h "$IMAGE" | cut -f 1)
  MENU="$MENU<a href='$IMAGE'><img title='Download Image ($IMGSIZE)' src="/pix/down.png" /></a>"
  if [ -f "$NAME.txt" ]; then
    COMMENT=$(cat "$NAME.txt")
    TITLE="$GALLERY - $COMMENT"
  else
    TITLE="$GALLERY"
  fi
  CURRENT=$(identify -ping -format "<a id=\"current\"
  href=\"./index.html#$(basename "$NAME")\"><img id=\"TheImage\" title=\"$COMMENT\" src=\"%i\" alt=\"%f\"></a>" $NAME.$PICSIZE.$PICFMT)
cat > $NAME.html <<EOF
<html>
<head>
  <title>$TITLE</title>
  <link rel="stylesheet" type="text/css" href="/.css">
  $CSS
  <script src="/.js" type="text/javascript"></script>
  <script type="text/javascript">
    function onLoad(){
      document.getElementById("TheImage").style.maxHeight = window.innerHeight - 80;
      $JS
      initSlideshow();
    }
  </script>
</head>
<body onLoad="onLoad()">
<div>$CURRENT</div><div id="Comment">$COMMENT</div>
<div id="MenuCont">
<div id="Menu">$MENU</div>
</div>
</body>
</html>
EOF
  identify -ping -format "<div id=\"thumb\"><a name=\"$(basename $NAME)\" href=\"$NAME.html\"><img src=\"%i\" title=\"$COMMENT\" width=\"%w\" height=\"%h\" /></a></div>" $THUMB >> index.html
  PICNUM=$((PICNUM+1))
done

cat >> index.html <<EOF
<div style="clear: both;" />
</body>
</html>
EOF

