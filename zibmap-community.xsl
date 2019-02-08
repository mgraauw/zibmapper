<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Author: Marc de Graauw 2013
    Copyright: to be decided, until then all rights reserved 
    
    Output: 
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="lang" select="'nl-NL'"/>
    <xsl:variable name="mode" select="'simple'"/>
    <!-- detail or simple -->

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$mode = 'simple'">
                <xsl:call-template name="simple"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="detail"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="simple">
        <prototype>
            <data type="zib2017type" label="zib 2017" datatype="enum">
                <xsl:for-each select="//dataset[@statusCode = 'final']">
                    <xsl:sort select="concept/name[@language = $lang]"/>
                    <xsl:apply-templates mode="simple"/>
                </xsl:for-each>
            </data>
            <!-- Do details for a few specializable groups. Just for items, no groups. -->
            <xsl:for-each
                select="//dataset[@statusCode = 'final']//concept[@statusCode = 'final'][name = ('Verrichting', 'Probleem', 'AlgemeneMeting', 'LaboratoriumUitslag')]">
                <xsl:apply-templates mode="detail"/>
            </xsl:for-each>
            <data type="zib2017value" label="zib 2017 value" datatype="enum">
                <enumValue>ValueSetFromConcept</enumValue>
                <enumValue>ValueFromConcept</enumValue>
                <enumValue>UnitFromConcept</enumValue>
                <enumValue>TerminologyAssociationFromConcept</enumValue>
                <enumValue>NP</enumValue>
                <enumValue>OTH</enumValue>
                <enumValue>UNK</enumValue>
                <enumValue>FIXED</enumValue>
            </data>
            <data type="zib2017fixed" label="zib 2017 fixed" datatype="string"> </data>
        </prototype>
    </xsl:template>

    <xsl:template name="detail">
        <prototype>
            <xsl:for-each select="//dataset[@statusCode = 'final']">
                <xsl:sort select="concept/name[@language = $lang]"/>
                <xsl:apply-templates mode="detail"/>
            </xsl:for-each>
        </prototype>
    </xsl:template>

    <xsl:template match="concept[name][@statusCode = 'final'][valueDomain]" mode="detail">
        <xsl:variable name="naam" select="string-join(ancestor-or-self::concept/name[@language = $lang]/string(), '.')"/>
        <data type="{$naam}" label="{$naam}" datatype="enum">
            <enumValue>ValueSetFromConcept</enumValue>
            <enumValue>ValueFromConcept</enumValue>
            <enumValue>UnitFromConcept</enumValue>
            <enumValue>TerminologyAssociationFromConcept</enumValue>
            <enumValue>NP</enumValue>
            <enumValue>OTH</enumValue>
            <enumValue>UNK</enumValue>
            <xsl:if test="valueDomain[@type = 'code']">
                <xsl:variable name="concList" select="valueDomain/conceptList/@id/string()"/>
                <xsl:variable name="termAssoc" select="//terminologyAssociation[@conceptId = $concList]"/>
                <xsl:variable name="valueSet" select="//valueSet[@statusCode = 'final'][@id = $termAssoc/@valueSet]"/>
                <xsl:for-each select="$valueSet/completeCodeSystem">
                    <enumValue>
                        <xsl:value-of select="./@codeSystemName/string()"/>
                    </enumValue>
                </xsl:for-each>
                <xsl:for-each select="$valueSet/conceptList/(concept | exception)">
                    <xsl:choose>
                        <xsl:when test="designation[@language = $lang]">
                            <enumValue>=<xsl:value-of select="designation[@language = $lang]/@displayName/string()"/></enumValue>
                        </xsl:when>
                        <xsl:otherwise>
                            <enumValue>=<xsl:value-of select="./@displayName/string()"/></enumValue>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
        </data>
        <xsl:apply-templates mode="detail"/>
    </xsl:template>

    <xsl:template match="concept[name][@statusCode = 'final']" mode="simple">
        <enumValue>
            <xsl:value-of
                select="
                    concat(string-join(ancestor-or-self::concept/name[@language = $lang]/string(), '.'), if (valueDomain) then
                        ''
                    else
                        ' (groep)')"
            />
        </enumValue>
        <xsl:apply-templates mode="simple"/>
    </xsl:template>

    <xsl:template match="@* | node()" mode="detail"/>


    <xsl:template match="@* | node()" mode="simple"/>

</xsl:stylesheet>
