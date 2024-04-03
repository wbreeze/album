<?xml version="1.0" encoding="UTF-8"?>
<!--
Stylesheet brings various markup supporting stylesheets together to make-up
the site.  Invoke this one against site markup.  It provides a basic
html document structure.  Use the layout stylesheet to customize the head
content and any internal structure of the body.
-->
<xsl:stylesheet version='1.0' 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="lineage.xsl"/>
<xsl:import href="album.xsl"/>
<xsl:import href="layout.xsl"/>

<xsl:output 
 method="html"
 version="1.0"
 indent="yes"
 media-type="text/html"/>

<xsl:template match="/">
  <xsl:text>---
layout: home
---
</xsl:text>
    <xsl:call-template name="body-attributes"/>
    <xsl:call-template name="body-content"/>
</xsl:template>

<xsl:template match="text()" mode="head"/>

</xsl:stylesheet>
