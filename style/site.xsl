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
 method="xml" 
 version="1.0"
 encoding="UTF-8"
 doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
 doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
 indent="yes"
 media-type="text/html"/>
 
<xsl:template match="/">
<html xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html"/>
    <xsl:call-template name="head-content"/>
    <xsl:apply-templates mode="head"/>
    <xsl:if test="/node()[@style!='']">
      <link rel="stylesheet" type="text/css">
        <xsl:attribute name="href">
          <xsl:value-of select="/node()/@style"/>
        </xsl:attribute>
      </link>
    </xsl:if>
    <xsl:if test="/node()[@title!='']">
      <title>
        <xsl:value-of select="/node()/@title"/>
      </title>
    </xsl:if>
  </head>
  <body> 
    <xsl:call-template name="body-attributes"/>
    <xsl:call-template name="body-content"/>
  </body>
</html>
</xsl:template>

<xsl:template match="text()" mode="head"/>

</xsl:stylesheet>
