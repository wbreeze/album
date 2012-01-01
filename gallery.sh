#!/bin/bash

PREVIEW_SUBDIR='preview'
PREVIEW_SIZE='800'
PREVIEW_FORMAT='jpg'
THUMB_SUBDIR='thumbnail'
THUMB_SIZE='200'
INDEX_NAME='index'
ALBUM_THUMBNAIL_NAME='album_thumbnail.jpg'

if [ ! -d "$1" -o ! -d "$2" -o ! -d "$3" ]; then
  echo 'Specify the root directory of the web (absolute, or relative to cwd)'
  echo 'Specify a source directory relative to the root of the web' 
  echo 'Specify a destination directory relative to the root of the web'
  exit 1
fi

ROOT_DIR="$1"
SRC_REL_DIR="$2"
DEST_REL_DIR="$3"
SOURCE_DIR="${ROOT_DIR}/${SRC_REL_DIR}"
DEST_DIR="${ROOT_DIR}/${DEST_REL_DIR}"
PREVIEW_DIR="${DEST_DIR}/${PREVIEW_SUBDIR}"
THUMB_DIR="${DEST_DIR}/${THUMB_SUBDIR}"

echo converting from "$SOURCE_DIR" to "$DEST_DIR"
[ -e "$DEST_DIR" ] || mkdir "$DEST_DIR"
[ -e "$PREVIEW_DIR" ] || mkdir "$PREVIEW_DIR"
[ -e "$THUMB_DIR" ] || mkdir "$THUMB_DIR"
PHOTO_COUNT=0
if [ -d "$PREVIEW_DIR" -a -d "$THUMB_DIR" ]; then
  IFS="|"
  # make preview and thumbnail images
  for f in $(find "$SOURCE_DIR" -maxdepth 1 \( -iname '*.jpg' \
     -o -iname '*.jpeg' \
     -o -iname '*.png' \) \
     -a -type f -printf "%f|")
  do
    SRC_IMAGE="$SOURCE_DIR/$f"
    DEST_PREVIEW="$PREVIEW_DIR/$f"
    DEST_THUMB="$THUMB_DIR/$f"
    [ "$SRC_IMAGE" -nt "$DEST_PREVIEW" ] && convert "$SRC_IMAGE" \
      -auto-orient \
      -resize ${PREVIEW_SIZE}x${PREVIEW_SIZE} \
      "$DEST_PREVIEW"
    [ "$SRC_IMAGE" -nt "$DEST_THUMB" ] && convert "$SRC_IMAGE" \
      -auto-orient \
      -resize ${THUMB_SIZE}x${THUMB_SIZE} \
      "$DEST_THUMB"
    PHOTO_LIST[$PHOTO_COUNT]=$f
    PHOTO_COUNT=$((PHOTO_COUNT+1))
  done

  # make album thumbnail
  if [ 0 -lt $((PHOTO_COUNT-1)) ]; then
    SRC_IMAGE="$SOURCE_DIR/${PHOTO_LIST[0]}"
    DEST_IMAGE="$DEST_DIR/$ALBUM_THUMBNAIL_NAME"
    [ "$SRC_IMAGE" -nt "$DEST_IMAGE" ] && convert "$SRC_IMAGE" \
      -auto-orient \
      -resize ${THUMB_SIZE}x${THUMB_SIZE} \
      "$DEST_IMAGE"
  fi

  # make sub-albums
  DIR_COUNT=0
  for DIR in $(find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f|"); 
  do
    $0 "$ROOT_DIR" "$SRC_REL_DIR/$DIR" "$DEST_REL_DIR/$DIR" "$SRC_REL_DIR"
    DIR_LIST[$DIR_COUNT]="$DIR"
    DIR_COUNT=$((DIR_COUNT+1))
  done

  # output preview pages
  CUR_PHOTO=0
  while [ $CUR_PHOTO -lt $PHOTO_COUNT ]; do
    CUR_PHOTO_NAME=${PHOTO_LIST[$CUR_PHOTO]}
    SRC_IMAGE="/$SRC_REL_DIR/$CUR_PHOTO_NAME"
    DEST_PREVIEW="$PREVIEW_SUBDIR/$CUR_PHOTO_NAME"
    DEST_THUMB="$THUMB_SUBDIR/$CUR_PHOTO_NAME"
    NAME=${CUR_PHOTO_NAME%.*}
    PREVIEW_XML=$DEST_DIR/$NAME.xml
    cat > $PREVIEW_XML <<EOF
      <? xml version='1.0' ?>
      <image-preview>
        <thumbnail src="$DEST_THUMB"/>
        <image src="$DEST_PREVIEW"/>
        <full-size src="$SRC_IMAGE"/>
        <index loc="$INDEX_NAME.html"/>
EOF
    if [ $CUR_PHOTO -gt 0 ]; then
      PREVIOUS=${PHOTO_LIST[(($CUR_PHOTO-1))]}
      cat >> $PREVIEW_XML <<EOF
        <previous loc="${PREVIOUS%.*}.html">
          <thumbnail src="$THUMB_SUBDIR/$PREVIOUS"/>
        </previous>
EOF
    fi
    if [ $CUR_PHOTO -lt $((PHOTO_COUNT-1)) ]; then
      NEXT=${PHOTO_LIST[(($CUR_PHOTO+1))]}
      cat >> $PREVIEW_XML <<EOF
        <next loc="${NEXT%.*}.html">
          <thumbnail src="$THUMB_SUBDIR/$NEXT"/>
        </next>
EOF
    fi
    cat >> $PREVIEW_XML <<EOF
      </image-preview>
EOF
  CUR_PHOTO=$((CUR_PHOTO+1))
  done

  # output index page
  INDEX_XML=$DEST_DIR/$INDEX_NAME.xml
  cat > $INDEX_XML <<EOF
    <? xml version='1.0' ?>
    <album>
EOF
  CUR_DIR=0
  while [ $CUR_DIR -lt $DIR_COUNT ]; do
    CUR_DIR_NAME=${DIR_LIST[$CUR_DIR]}
    cat >> $INDEX_XML <<EOF
      <sub-album loc="$CUR_DIR_NAME/$INDEX_NAME.html">
        <thumbnail src="$CUR_DIR_NAME/$ALBUM_THUMBNAIL_NAME"/>
        $CUR_DIR_NAME
      </sub-album>
EOF
    CUR_DIR=$((CUR_DIR+1))
  done
  CUR_PHOTO=0
  while [ $CUR_PHOTO -lt $PHOTO_COUNT ]; do
    CUR_PHOTO_NAME=${PHOTO_LIST[$CUR_PHOTO]}
    DEST_THUMB="$THUMB_SUBDIR/$CUR_PHOTO_NAME"
    NAME=${CUR_PHOTO_NAME%.*}
    PREVIEW_NAME="$NAME.html"
    cat >> $INDEX_XML <<EOF
      <photo
        thumbnail="$DEST_THUMB"
        preview-loc="$PREVIEW_NAME">
        $NAME
      </photo>
EOF
    CUR_PHOTO=$((CUR_PHOTO+1))
  done
  cat >> $INDEX_XML <<EOF
    </album>
EOF

else
  echo 'failed to create scaled image directory. file in the way?'
fi
