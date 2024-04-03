<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='1.0'
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="image-preview">
  <div class="preview">
    <div class="controls">
      <xsl:apply-templates select="previous"/>
      <xsl:apply-templates select="next"/>
      <div class='preview-control'>
        <xsl:apply-templates select="index"/>
        <xsl:apply-templates select="full-size"/>
      </div>
    </div>
    <xsl:apply-templates select="image"/>
  </div>
</xsl:template>

<xsl:template name="navigation">
  <a class="preview-navigation">
    <xsl:attribute name="href">
      <xsl:value-of select="@loc"/>
    </xsl:attribute>
    <xsl:apply-templates select="thumbnail"/>
  </a>
</xsl:template>

<xsl:template match="previous">
  <div class="preview-previous-navigation">
    <xsl:call-template name="navigation"/>
  </div>
</xsl:template>

<xsl:template match="next">
  <div class="preview-next-navigation">
    <xsl:call-template name="navigation"/>
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
  <div class="thumbnail-description">
    <xsl:if test="string-length(normalize-space(text())) > 0">
      <div class="thumbnail-caption">
        <xsl:value-of select="normalize-space(text())" />
      </div>
    </xsl:if>
    <xsl:text> </xsl:text>
    <xsl:if test="@credit">
      <div class="thumbnail-credit">
        <xsl:text> by </xsl:text>
        <xsl:value-of select="@credit" />
      </div>
    </xsl:if>
  </div>
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

<xsl:template match="index">
  <a class="index-link">
    <xsl:attribute name="href">
      <xsl:value-of select="@loc"/>
    </xsl:attribute>
    <xsl:text>index</xsl:text>
  </a>
</xsl:template>

<xsl:template match="full-size">
  <a target="full-size" class="full-size-link">
    <xsl:attribute name="href">
      <xsl:value-of select="@src"/>
    </xsl:attribute>
    <xsl:text>download</xsl:text>
  </a>
</xsl:template>

<xsl:template match="album">
  <xsl:apply-templates select="parent"/>
  <div class="album-index">
    <xsl:apply-templates select="sub-album"/>
    <xsl:apply-templates select="preview"/>
  </div>
</xsl:template>

<xsl:template match="preview">
  <div class="preview-thumbnail">
    <a class="thumbnail-link">
      <xsl:attribute name="name">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="@loc" />
      </xsl:attribute>
      <div class="thumbnail">
        <xsl:apply-templates select="thumbnail"/>
      </div>
    </a>
  </div>
</xsl:template>

<xsl:template match="sub-album">
  <div class="directory-thumbnail">
    <a class="thumbnail-link">
      <xsl:attribute name="href">
        <xsl:value-of select="@loc" />
      </xsl:attribute>
      <div class="thumbnail">
        <xsl:apply-templates select="thumbnail"/>
      </div>
    </a>
  </div>
</xsl:template>

</xsl:stylesheet>
