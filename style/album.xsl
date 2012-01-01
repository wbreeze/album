<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='1.0'
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="file-sep">
    /
  </xsl:param>

  <xsl:template match="sizes" mode="size-string">
    <xsl:apply-templates select="size" mode="size-string" />
  </xsl:template>

  <xsl:template match="size" mode="size-string">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="@box-size" />
    <xsl:text>"</xsl:text>
    <xsl:if test="position()!=last()">
      <xsl:text>,
   </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="image" mode="name-string">
    <xsl:text>"</xsl:text>
    <xsl:value-of select='@name' />
    <xsl:text>"</xsl:text>
    <xsl:if test="position()!=last()">
      <xsl:text>,
   </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="image[@caption]" mode="caption-string">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="@caption" />
    <xsl:text>"</xsl:text>
    <xsl:if test="position()!=last()">
      <xsl:text>,
   </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="image" mode="caption-string">
    <xsl:text>"</xsl:text>
    <xsl:apply-templates />
    <xsl:text>"</xsl:text>
    <xsl:if test="position()!=last()">
      <xsl:text>,
   </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="image" mode="credit-string">
    <xsl:text>"</xsl:text>
    <xsl:value-of select='@credit' />
    <xsl:text>"</xsl:text>
    <xsl:if test="position()!=last()">
      <xsl:text>,
   </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="album[position()=1]" mode="head">
    <script>
      <xsl:text>var image_dir = "</xsl:text>
      <xsl:value-of select="@image-loc" />
      <xsl:text>";
var image_sizes = new Array (
</xsl:text>
      <xsl:apply-templates select="sizes" mode="size-string" />
      <xsl:text>);
var image_list = new Array (
</xsl:text>
      <xsl:apply-templates select="image" mode="name-string" />
      <xsl:text>);
var image_captions = new Array (
</xsl:text>
      <xsl:apply-templates select="image" mode="caption-string" />
      <xsl:text>);
var image_credits = new Array (
</xsl:text>
      <xsl:apply-templates select="image" mode="credit-string" />
      <xsl:text>);</xsl:text>
      <xsl:text disable-output-escaping='yes'>
<![CDATA[
var image_index = 0;
var image_size = 0;
function Show_Image (index)
{
    image_index = index;
    var size_dir = ".";
    if (0 <= image_size && image_size < (image_sizes.length-1)) {
       size_dir = image_sizes[image_size];
    }
    var img = document.getElementById('img');
    var showing = document.getElementById('showing');
    var caption = document.getElementById('caption');
    var credit = document.getElementById('credit');
    img.src = image_dir + "/" + size_dir + "/" + image_list [index];
    showing_str = (index + 1) + " of " + (image_list.length) + " : " + image_list[index];
    showing.innerHTML = showing_str;
    caption.innerHTML = image_captions [index];
    credit.innerHTML = 'by ' + image_credits [index];
}

function Show_Size(index)
{
    image_size = index;
    Show_Image(image_index);
}

function Slideshow(index)
{
    Show_Image(index);
    var album_index = document.getElementById('album_index');
    var slideshow = document.getElementById('slideshow');
    album_index.style.display="none";
    slideshow.style.display="block";
}
     
function Goto_Index()
{
    var album_index = document.getElementById('album_index');
    var slideshow = document.getElementById('slideshow');
    slideshow.style.display="none";
    album_index.style.display="block";
}

function Show_Prev ()
{
    if (image_index > 0) 
    {
        image_index--;
    }
    else
    {
        image_index = image_list.length-1;
    }
    Show_Image (image_index);
}

function Show_Next ()
{
    if (image_index < image_list.length - 1)
    {
       image_index++;
    }
    else
    {
       image_index = 0;
    }
    Show_Image (image_index);
}
]]>
</xsl:text>
    </script>
    <link rel="stylesheet" type="text/css" href="/style/album.css" />
  </xsl:template>

  <xsl:template match="album">
    <DIV id="slideshow" style="display:none">
      <DIV class="controlRow">
        <A class="control" href="Javascript:Goto_Index()">Index</A>
        <SPAN id="showing" style="margin-left:20px">now showing</SPAN>
      </DIV>
      <DIV class="controlRow">
        <A class="control" href="Javascript:Show_Image (0)">First</A>
        <A class="control" href="Javascript:Show_Prev()">Prev</A>
        <A class="control" href="Javascript:Show_Next()">Next</A>
        <A class="control" href="Javascript:Show_Image (image_list.length-1)">Last</A>
      </DIV>
      <xsl:apply-templates select="sizes" mode="controls" />
      <DIV>
        <IMG class="album" id="img" />
      </DIV>
      <DIV>
        <SPAN class="image-credit" style="text-align:right;" id="credit">
          credit</SPAN>
      </DIV>
      <DIV>
        <SPAN id="caption" style="text-align:left">caption</SPAN>
      </DIV>
    </DIV>

    <DIV id="album_index">
      <P class="index-prompt">Click on a thumbnail to see an enlargement.</P>
      <xsl:apply-templates select="image" mode="index">
        <xsl:with-param name="imagedir">
          <xsl:value-of select="@image-loc" />
        </xsl:with-param>
        <xsl:with-param name="thumbdir">
          <xsl:value-of select="@thumbnail-loc" />
        </xsl:with-param>
      </xsl:apply-templates>
    </DIV>
  </xsl:template>

  <xsl:template match="sizes" mode="controls">
    <DIV class="controlRow">
      <xsl:apply-templates select="size" mode="controls" />
    </DIV>
  </xsl:template>

  <xsl:template match="size" mode="controls">
    <A class="control">
      <xsl:attribute name="href">
      <xsl:text>javascript:Show_Size(</xsl:text>
      <xsl:value-of select="position()-1" />
      <xsl:text>)</xsl:text>
    </xsl:attribute>
      <xsl:value-of select="@box-size" />
    </A>
  </xsl:template>

  <xsl:template match="image" mode="index">
    <xsl:param name="imagedir" />
    <xsl:param name="thumbdir" />
    <SPAN class="imgBlock">
      <A>
        <xsl:attribute name="href">
  <xsl:text>javascript:Slideshow(</xsl:text>
  <xsl:value-of select="position()-1" />
  <xsl:text>)</xsl:text>
  </xsl:attribute>
        <DIV class="thumbnail">
          <IMG class="thumbnail">
            <xsl:attribute name="src">
  <xsl:value-of select="$imagedir" />
  <xsl:value-of select="$file-sep" />
  <xsl:value-of select="$thumbdir" />
  <xsl:value-of select="$file-sep" />
  <xsl:value-of select="@name" />
  </xsl:attribute>
          </IMG>
        </DIV>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space(text())) > 0">
            <div class="thumbnail-caption">
              <xsl:value-of select="normalize-space(text())" />
            </div>
          </xsl:when>
          <xsl:otherwise>
            <DIV class="image-name">
              <xsl:value-of select="@name" />
            </DIV>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@credit">
          <DIV class="image-index-credit">
            <xsl:text> by </xsl:text>
            <xsl:value-of select="@credit" />
          </DIV>
        </xsl:if>
      </A>
    </SPAN>
  </xsl:template>

</xsl:stylesheet>
