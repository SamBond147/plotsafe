<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fma="http://fma.mpi.govt.nz/FMAInformation/Schema/01/06/2016/FMAInformation.xsd"
    exclude-result-prefixes="ps">
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:element name="ForestInfo" namespace="http://fma.mpi.govt.nz/FMAInformation/Schema/01/06/2016/FMAInformation.xsd">
            
            <fma:participantSchemeType>
                <xsl:value-of select="//population/properties/property[domain_name='Scheme']/property_value"/>
            </fma:participantSchemeType>
            <fma:participantName>
                <xsl:value-of select="//population/properties/property[domain_name='Client']/property_value"/>
            </fma:participantName>
            <fma:participantNzeurNumber>0</fma:participantNzeurNumber> 
            <fma:SubmitterName>
                <xsl:value-of select="//population/properties/property[domain_name='RepName']/property_value"/>
            </fma:SubmitterName>
            <fma:DatePlotsAllocated>2012-01-04</fma:DatePlotsAllocated>
            <fma:FmaInfoSuppliedFor>All plots</fma:FmaInfoSuppliedFor>
            <fma:FmaInfoType>Plot</fma:fma:FmaInfoType>

            <fma:SamplePlotList>
                <xsl:apply-templates select="//stratum"/>
            </fma:SamplePlotList>
        </xsl:element>
    </xsl:template>

    <xsl:template match="stratum">
        <xsl:for-each select="plots/plot">
            <fma:SPInfo>
                <fma:PlotID><xsl:value-of select="../../stratum_name"/></fma:PlotID>
                
                <fma:PlotArea>
                    <xsl:choose>
                        <xsl:when test="plot_type_name='0.03ha'">0.030</xsl:when>
                        <xsl:when test="plot_type_name='0.04ha'">0.040</xsl:when>
                        <xsl:when test="plot_type_name='0.06ha'">0.060</xsl:when>
                        <xsl:when test="plot_type_name='0.1ha'">0.100</xsl:when>
                        <xsl:otherwise>0.030</xsl:otherwise>
                    </xsl:choose>
                </fma:PlotArea>
                
                <fma:PlotShape>Circular</fma:PlotShape>
                <fma:PlotAverageMaxSlope><xsl:value-of select="plot_slope"/></fma:PlotAverageMaxSlope>
                
                <fma:PlotRadius>
                    <xsl:choose>
                        <xsl:when test="plot_type_name='0.03ha'">9.77</xsl:when>
                        <xsl:when test="plot_type_name='0.04ha'">11.28</xsl:when>
                        <xsl:when test="plot_type_name='0.06ha'">13.82</xsl:when>
                        <xsl:otherwise>9.77</xsl:otherwise>
                    </xsl:choose>
                </fma:PlotRadius>

                <fma:PositionNavigatedToEasting><xsl:value-of select="../../properties/property[domain_name='NavGPSE']/property_value"/></fma:PositionNavigatedToEasting>
                <fma:PositionNavigatedToNorthing><xsl:value-of select="../../properties/property[domain_name='NavGPSN']/property_value"/></fma:PositionNavigatedToNorthing>
                <fma:PlotCentrePointEasting><xsl:value-of select="../../properties/property[domain_name='GPSE']/property_value"/></fma:PlotCentrePointEasting>
                <fma:PlotCentrePointNorthing><xsl:value-of select="../../properties/property[domain_name='GPSN']/property_value"/></fma:PlotCentrePointNorthing>
                <fma:PlotCentrePointAltitude><xsl:value-of select="../../properties/property[domain_name='Altitude']/property_value"/></fma:PlotCentrePointAltitude>
                
                <fma:PlotExtendsBeyondBdry>No</fma:PlotExtendsBeyondBdry>
                <fma:PlotCentrePointRelocated>
                    <xsl:choose>
                        <xsl:when test="../../properties/property[domain_name='PlotRelocated']/property_value='NO'">No</xsl:when>
                        <xsl:otherwise>Yes</xsl:otherwise>
                    </xsl:choose>
                </fma:PlotCentrePointRelocated>
                
                <xsl:if test="../../properties/property[domain_name='PlotRelocated']/property_value != 'NO'">
                    <fma:PlotRelocatedReason>Forest land edge</fma:PlotRelocatedReason>
                </xsl:if>
                
                <fma:PlotCentrePointReestablished>No</fma:PlotCentrePointReestablished>
                <fma:DateFmaInfoCollectionStarted><xsl:value-of select="measurement_date"/></fma:DateFmaInfoCollectionStarted>

                <fma:TreeInfo>
                    <xsl:choose>
                        <xsl:when test="trees/tree">
                            <fma:TreesPresent>Yes</fma:TreesPresent>
                            <fma:IntermingledTreesPresent>
                                <xsl:choose>
                                    <xsl:when test="properties/property[domain_name='Intermingled']/property_value='YES'">Yes</xsl:when>
                                    <xsl:otherwise>No</xsl:otherwise>
                                </xsl:choose>
                            </fma:IntermingledTreesPresent>
                            <fma:PlantedTreesPresent>Yes</fma:PlantedTreesPresent>
                            <fma:PlantedStocking><xsl:value-of select="properties/property[domain_name='PlantedSPH']/property_value"/></fma:PlantedStocking>
                            <fma:PlantingYear><xsl:value-of select="properties/property[domain_name='YearEst']/property_value"/></fma:PlantingYear>
                            
                            <fma:TreeStemList>
                                <fma:MeasuredStemsList>
                                    <xsl:apply-templates select="trees/tree"/>
                                </fma:MeasuredStemsList>
                            </fma:TreeStemList>
                        </xsl:when>
                        <xsl:otherwise>
                            <fma:TreesPresent>No</fma:TreesPresent>
                            <fma:TreesAbsentReason>Trees below stem diameter or height thresholds</fma:TreesAbsentReason>
                            <fma:TreesAbsentAssignedSpeciesGroup>SGRAD</fma:TreesAbsentAssignedSpeciesGroup>
                            <fma:TreeStemList>
                                <fma:EstimatedStemsList>
                                    <fma:SGInfo>
                                        <fma:SpeciesGroupOfCollarDiameterStems>SGRAD</fma:SpeciesGroupOfCollarDiameterStems>
                                        <fma:EstabTypeOfCollarDiameterStems>Planted</fma:EstabTypeOfCollarDiameterStems>
                                        <fma:AverageCollarDiameterOfStems><xsl:value-of select="properties/property[domain_name='SeedlingDiam']/property_value"/></fma:AverageCollarDiameterOfStems>
                                        <fma:AverageHeightOfCollarDiameterStems><xsl:value-of select="properties/property[domain_name='SeedlingHt']/property_value"/></fma:AverageHeightOfCollarDiameterStems>
                                        <fma:StockingOfCollarDiameterStems><xsl:value-of select="properties/property[domain_name='SeedlingCount']/property_value"/></fma:StockingOfCollarDiameterStems>
                                    </fma:SGInfo>
                                </fma:EstimatedStemsList>
                            </fma:TreeStemList>
                        </xsl:otherwise>
                    </xsl:choose>
                </fma:TreeInfo>
            </fma:SPInfo>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="tree">
        <fma:StemInfo>
            <fma:StemID><xsl:value-of select="tree_number"/></fma:StemID>
            <fma:StemEstablishmentType>Planted</fma:StemEstablishmentType>
            <fma:StemState>
                <xsl:choose>
                    <xsl:when test="is_dead='True'">Dead</xsl:when>
                    <xsl:otherwise>Live</xsl:otherwise>
                </xsl:choose>
            </fma:StemState>
            <fma:StemSpecies>PSMEN</fma:StemSpecies>
            <fma:StemDiameter><xsl:value-of select="stems/stem/stem_diameters/stem_diameter/dob"/></fma:StemDiameter>
            <fma:StemDiameterType>DBH</fma:StemDiameterType>
            <fma:StemDiameterAtStdHeight>Yes</fma:StemDiameterAtStdHeight>
            <xsl:if test="stems/stem/stem_height">
                <fma:StemHeight><xsl:value-of select="stems/stem/stem_height"/></fma:StemHeight>
            </xsl:if>
            <fma:StemBrokenTop>
                <xsl:choose>
                    <xsl:when test="stems/stem/stem_height_status='BROKEN'">Yes</xsl:when>
                    <xsl:otherwise>No</xsl:otherwise>
                </xsl:choose>
            </fma:StemBrokenTop>
        </fma:StemInfo>
    </xsl:template>

</xsl:stylesheet>