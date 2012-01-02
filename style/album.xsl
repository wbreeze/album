<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='1.0'
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="album[position()=1]" mode="head">
  <link rel="stylesheet" type="text/css" href="/style/album.css" />
</xsl:template>

<xsl:template match="image-preview">
  <div class="image-preview">
    <xsl:apply-templates select="image"/>
    <xsl:apply-templates select="previous"/>
    <xsl:apply-templates select="next"/>
    <a class="index-link">
      <xsl:attribute name="href">
        <xsl:value-of select="index/@loc"/>
      </xsl:attribute>
      <xsl:text>index</xsl:text>
    </a>
    <xsl:apply-templates select="full-size"/>
  </div>
</xsl:template>

<xsl:template match="previous">
  <div class="preview-previous-navigation">
    <a class="preview-navigation">
      <xsl:attribute name="href">
        <xsl:value-of select="@loc"/>
      </xsl:attribute>
      <xsl:apply-templates select="thumbnail"/>
    </a>
  </div>
</xsl:template>

<xsl:template match="next">
  <div class="preview-next-navigation">
    <a class="preview-navigation">
      <xsl:attribute name="href">
        <xsl:value-of select="@loc"/>
      </xsl:attribute>
      <xsl:apply-templates select="thumbnail"/>
    </a>
  </div>
</xsl:template>

<xsl:template match="thumbnail">
  <img class="thumbnail">
    <xsl:attribute name="src">
      <xsl:value-of select="@src"/>
    </xsl:attribute>
    <xsl:if test="string-length(normalize-space(text())) > 0">
      <xsl:attribute name="alt">
        <xsl:value-of select="normalize-space(text())" />
      </xsl:attribute>
    </xsl:if>
  </img>
</xsl:template>

<xsl:template match="image">
  <div class="image-preview">
    <img class="image-preview">
      <xsl:attribute name="src">
        <xsl:value-of select="@src"/>
      </xsl:attribute>
      <xsl:if test="string-length(normalize-space(text())) > 0">
        <xsl:attribute name="alt">
          <xsl:value-of select="normalize-space(text())" />
        </xsl:attribute>
      </xsl:if>
    </img>
    <div class="image-decor">
      <xsl:if test="string-length(normalize-space(text())) > 0">
        <div class="image-caption">
          <xsl:value-of select="normalize-space(text())" />
        </div>
      </xsl:if>
      <xsl:if test="not(@credit='')">
        <div class="image-credit">
          <xsl:value-of select="@credit"/>
        </div>
      </xsl:if>
    </div>
  </div>
</xsl:template>

<xsl:template match="full-size">
  <div class="full-size-link">
    <a class="full-size-link">
      <xsl:attribute name="href">
        <xsl:value-of select="@src"/>
      </xsl:attribute>
      <xsl:text>download</xsl:text>
    </a>
  </div>
</xsl:template>

<xsl:template match="album">
  <xsl:apply-templates select="parent"/>
  <div id="album_index">
    <xsl:apply-templates select="photo"/>
  </div>
</xsl:template>

<xsl:template match="photo">
  <a class="anchor">
    <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
  </a>
  <span class="preview-thumbnail">
    <a class="thumbnail-link">
      <xsl:attribute name="href">
        <xsl:value-of select="@preview-loc" />
      </xsl:attribute>
      <div class="thumbnail">
        <img class="thumbnail">
          <xsl:attribute name="src">
            <xsl:value-of select="@thumbnail" />
          </xsl:attribute>
        </img>
      </div>
      <div class="thumbnail-description">
        <xsl:if test="string-length(normalize-space(text())) > 0">
          <div class="thumbnail-caption">
            <xsl:value-of select="normalize-space(text())" />
          </div>
        </xsl:if>
        <xsl:if test="@credit">
          <div class="thumbnail-credit">
            <xsl:text> by </xsl:text>
            <xsl:value-of select="@credit" />
          </div>
        </xsl:if>
      </div>
    </a>
  </span>
</xsl:template>

</xsl:stylesheet>
