<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/2000/svg" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="utf-8" indent="yes"/>

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

	<xsl:template match="/timeline">
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="bars">
			<defs>
				<marker id="triangle"
					viewBox="0 0 10 10" refX="0" refY="5" 
					markerUnits="strokeWidth"
					markerWidth="4" markerHeight="3"
					orient="auto">
				<path d="M 0 0 L 10 5 L 0 10 z" />
				</marker>
			</defs>
			<g>
				<xsl:for-each select="networks/network">
					<g xlink:href="#{id}" href="#{id}"><xsl:element name="line">
						<xsl:attribute name="class">bar <xsl:value-of select="region"/></xsl:attribute>
						<xsl:attribute name="data-network"><xsl:value-of select="id"/></xsl:attribute>
						<xsl:attribute name="y1"><xsl:value-of select="position() * 30 + 25"/></xsl:attribute>
						<xsl:attribute name="x1">
							<xsl:choose>
								<xsl:when test="start/month">
									<xsl:value-of select="(start/year - 1850) * 100 + ((start/month - 1) * 8.3333333)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="(start/year - 1850) * 100"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="y2"><xsl:value-of select="position() * 30 + 25"/></xsl:attribute>
						<xsl:attribute name="x2">
							<xsl:choose>
								<xsl:when test="end">
									<xsl:choose>
										<xsl:when test="end/month">
											<xsl:value-of select="(end/year - 1850) * 100 + ((end/month - 1) * 8.3333333)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="(end/year - 1850) * 100"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="(2013 - 1850) * 100"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</xsl:element></g>
				</xsl:for-each>
			</g>
			<g stroke="#444" stroke-width="2" marker-end="url(#triangle)">
				<xsl:for-each select="networks/network">
					<xsl:if test="becomes"><xsl:element name="line">
						<xsl:variable name="becomes" select="becomes"/>
						<xsl:variable name="x">
							<xsl:choose>
								<xsl:when test="end">
									<xsl:choose>
										<xsl:when test="end/month">
											<xsl:value-of select="(end/year - 1850) * 100 + ((end/month - 1) * 8.3333333)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="(end/year - 1850) * 100"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="(2013 - 1850) * 100"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:attribute name="class">arrow</xsl:attribute>
						<xsl:attribute name="data-network"><xsl:value-of select="id"/></xsl:attribute>

						<xsl:attribute name="x1"><xsl:value-of select="$x"/></xsl:attribute>
						<xsl:attribute name="y1"><xsl:value-of select="position() * 30 + 25"/></xsl:attribute>

						<xsl:attribute name="x2"><xsl:value-of select="$x"/></xsl:attribute>
						<xsl:attribute name="y2"><xsl:value-of select="(count(//networks/network[id=$becomes]/preceding-sibling::network)+1) * 30 + 10"/></xsl:attribute>

					</xsl:element></xsl:if>
				</xsl:for-each>
			</g>
			<g style="fill:#BBB; font-size:14px;">
				<xsl:for-each select="networks/network">
					<xsl:variable name="x">
						<xsl:choose>
							<xsl:when test="start/month">
								<xsl:value-of select="(start/year - 1849.88) * 100 + ((start/month - 1) * 8.3333333)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="(start/year - 1849.88) * 100"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<g><text y="{position() * 30 + 30}" x="{$x}">
						<xsl:value-of select="name"/>
					</text></g>
				</xsl:for-each>
			</g>
			<g id="events">
				<xsl:for-each select="networks/network">
					<xsl:variable name="net" select="position()"/>
					<xsl:variable name="netid" select="id"/>
					<xsl:for-each select="//events/event">
						<xsl:if test="network = $netid">
							<xsl:variable name="x">
								<xsl:choose>
									<xsl:when test="month">
										<xsl:value-of select="(year - 1850) * 100 + ((month - 1) * 8.3333333)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="(year - 1850) * 100"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="m"><xsl:if test="month">-<xsl:value-of select="month"/></xsl:if></xsl:variable>
							<g class="event" xlink:href="#{$netid}{year}{$m}" href="#{$netid}{year}{$m}">
								<circle cx="{$x}" cy="{$net * 30 + 25}" r="10"/>
								<foreignobject class="hover"  width="620" height="500" x="{(year - 1850) * 100}" y="{$net * 30 + 10}">
									<body xmlns="http://www.w3.org/1999/xhtml">
										<div class="description"><xsl:value-of select="description"/></div>
									</body>
								</foreignobject>
							</g>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</g>
		</svg>
	</xsl:template>
</xsl:stylesheet>
