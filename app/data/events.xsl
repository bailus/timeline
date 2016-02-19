<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="utf-8" indent="yes"/>

<xsl:variable name="vmonths">
   <m>January</m>
   <m>February</m>
   <m>March</m>
   <m>April</m>
   <m>May</m>
   <m>June</m>
   <m>July</m>
   <m>August</m>
   <m>September</m>
   <m>October</m>
   <m>November</m>
   <m>December</m>
</xsl:variable>
<xsl:variable name="months" select="document('')/*/xsl:variable[@name='vmonths']/*"/>

<xsl:template match="month">
	<div class="month"><xsl:value-of select="$months[number(current())]"/></div>
</xsl:template>
<xsl:template match="becomes">
	<li data-href="#{current()}"><p><a class="becomes" href="#{current()}"><xsl:value-of select="//networks/network[id=current()]/name"/></a> &gt; </p></li>
</xsl:template>
<xsl:template match="id">
	<li><p> &lt; <a class="from" href="#{current()}"><xsl:value-of select="//networks/network[id=current()]/name"/></a></p></li>
</xsl:template>
<xsl:template match="img">
	<img src="images/{@src}"/>
</xsl:template>
<xsl:template match="cite">
	<p><cite><xsl:choose>
		<xsl:when test="@href"><a href="{@href}"><xsl:value-of select="current()"/></a></xsl:when>
		<xsl:otherwise><xsl:value-of select="current()"/></xsl:otherwise>
	</xsl:choose></cite></p>
</xsl:template>
<xsl:template match="event">
	<xsl:variable name="m"><xsl:if test="month">-<xsl:value-of select="month"/></xsl:if></xsl:variable>
	<li data-network="{network}" data-year="{year}" data-month="{month}" data-href="#{network}{year}{$m}">
		<div class="date"><xsl:apply-templates select="month"/> <xsl:value-of select="year"/></div>
		<xsl:apply-templates select="img"/>
		<xsl:if test="not(longdesc)"><p><xsl:value-of select="description"/></p></xsl:if>
		<xsl:if test="longdesc"><p><xsl:value-of select="longdesc"/></p></xsl:if>
		<xsl:apply-templates select="cite"/>
	</li>
</xsl:template>
<xsl:template match="network">
	<xsl:variable name="id" select="id"/>
	<li id="{id}" class="hide">
		<div class="header">
		<a class="name" id="{id}"><xsl:value-of select="name"/></a>
		<p><xsl:value-of select="description"/></p>
		</div>
		<ul class="events">
			<!--<xsl:apply-templates select="//networks/network[becomes=$id]/id"/>-->
			<xsl:for-each select="//events/event[network=$id]">
				<xsl:variable name="m"><xsl:if test="month">-<xsl:value-of select="month"/></xsl:if></xsl:variable>
				<li data-network="{$id}" data-year="{year}" data-month="{month}" data-href="#{$id}{year}{$m}">
					<div class="date"><xsl:apply-templates select="month"/> <xsl:value-of select="year"/></div>
					<xsl:apply-templates select="img"/>
					<xsl:if test="not(longdesc)"><p><xsl:value-of select="description"/></p></xsl:if>
					<xsl:if test="longdesc"><p><xsl:value-of select="longdesc"/></p></xsl:if>
					<xsl:apply-templates select="cite"/>
				</li>
			</xsl:for-each>
			<!--<xsl:apply-templates select="becomes"/>-->
		</ul>
	</li>
</xsl:template>

<xsl:template match="/timeline">
	<ul id="networks">
		<xsl:apply-templates select="networks/network"/>
	</ul>
</xsl:template>

</xsl:stylesheet>


