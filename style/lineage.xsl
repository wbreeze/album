<?xml version="1.0" encoding="UTF-8"?>
<!--
Stylesheet creates trace of levels in heading format up the lineage of site pages,
assuming hierarchal structure of the site.
Matches markup as follows:
<parent link="../aeroblog.html" title="Stories">
 <parent link="../aero.html" title="Aviation and Aerobatics">
  <parent link="index.html" title="WBreeze"/>
 </parent>
</parent>
where the farthest ancestor is the most deeply nested, to produce:
<h1>WBreeze : Aviation and Aerobatics : Stories : Title</h1>
(with appropriate links).
The Title comes from the title attribute of the first element in the document.
-->
<xsl:stylesheet version='1.0' xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="parent">
  <h1>
   <xsl:apply-templates select="." mode="breadcrumb"/>
   <xsl:value-of select="/*[position()=1]/@title"/>
  </h1>
</xsl:template>

<xsl:template match="parent" mode="breadcrumb">
  <xsl:apply-templates select="parent" mode="breadcrumb"/>
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="@link"/>
    </xsl:attribute>
    <xsl:value-of select="@title"/>
  </a>
  <xsl:text> : </xsl:text>
</xsl:template>

</xsl:stylesheet>
