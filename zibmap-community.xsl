<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Author: Marc de Graauw 2013
    Copyright: to be decided, until then all rights reserved 
    
    Output: 
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="lang" select="'nl-NL'"/>
    
    <xsl:template match="/">
        <prototype>
            <data type="zib2017type" label="zib 2017" datatype="enum">
                <xsl:for-each select="//dataset[@statusCode='final']">
                    <xsl:sort select="concept/name[@language=$lang]"/>
                    <xsl:apply-templates/>
                </xsl:for-each>
            </data>
            <data type="zib2017value" label="zib 2017 value" datatype="enum">
                <enumValue>ValueSetFromConcept</enumValue>
                <enumValue>ValueFromConcept</enumValue>
                <enumValue>UnitFromConcept</enumValue>
                <enumValue>NP</enumValue>
                <enumValue>OTH</enumValue>
                <enumValue>UNK</enumValue>
                <enumValue>FIXED</enumValue>
            </data>
            <data type="zib2017fixed" label="zib 2017 fixed" datatype="string">
            </data>
        </prototype>
    </xsl:template>
    
<!--    <xsl:template match="concept[@statusCode='final']">
        <data type="{name[@language=$lang]/string()}" label="{string-join(ancestor-or-self::concept/name[@language=$lang]/string(), '.')}" datatype="enum">
            <enumValue>ValueSetFromConcept</enumValue>
            <enumValue>ValueFromConcept</enumValue>
            <enumValue>UnitFromConcept</enumValue>
            <enumValue>NP</enumValue>
            <enumValue>OTH</enumValue>
            <enumValue>UNK</enumValue>
            <xsl:if test="valueDomain[@type='code']">
                <xsl:variable name="concList" select="valueDomain/conceptList/@id/string()"/>
                <xsl:variable name="termAssoc" select="//terminologyAssociation[@conceptId=$concList]"/>
                <xsl:variable name="valueSet" select="//valueSet[@statusCode='final'][@id=$termAssoc/@valueSet]"/>
                <xsl:for-each select="$valueSet/completeCodeSystem">
                    <enumValue><xsl:value-of select="./@codeSystemName/string()"/></enumValue>
                </xsl:for-each>
                <xsl:for-each select="$valueSet/conceptList/(concept | exception)">
                    <xsl:choose>
                        <xsl:when test="designation[@language=$lang]">
                            <enumValue>=<xsl:value-of select="designation[@language=$lang]/@displayName/string()"/></enumValue>
                        </xsl:when>
                        <xsl:otherwise>
                            <enumValue>=<xsl:value-of select="./@displayName/string()"/></enumValue>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
        </data>
        <xsl:apply-templates/>
    </xsl:template>
-->
    <xsl:template match="concept[name][@statusCode='final']">
        <enumValue><xsl:value-of select="string-join(ancestor-or-self::concept/name[@language=$lang]/string(), '.')"/></enumValue>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="@*|node()">
    </xsl:template>
</xsl:stylesheet>