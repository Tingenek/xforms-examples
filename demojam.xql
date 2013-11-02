xquery version "1.0";

declare namespace http="http://expath.org/ns/webapp";
declare namespace ev="http://www.w3.org/2001/xml-events"; 
declare namespace xs="http://www.w3.org/2001/XMLSchema"; 
declare namespace xf="http://www.w3.org/2002/xforms";

declare variable $http:input external;

let $form :=
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<title>Geovation Demo</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.6.4/leaflet.css" />
	<link type="text/css" href="/lux/lux/ari/resources/css/itest.css" rel="stylesheet" />

<xf:model id="test"  xmlns="">

<xf:instance id="query" xmlns="">
<data>
<q>id:[700 TO *]</q>
<facet>true</facet>
<rows>1000</rows>
<sort>id desc</sort>
<start>0</start>
<facet.field>trust_t</facet.field>
<facet.field>area</facet.field>
<facet.field>status</facet.field>
<facet.mincount>1</facet.mincount>
<fq id='0'>location:[50.84757295365389,-5.09765625 TO 54.18815548107151,2.373046875]</fq>

<fl>id,title,trust_t,image,status,created,group,email,location</fl>
</data>
</xf:instance>

<xf:instance id="results" xmlns="">
<data/>
</xf:instance>

<xf:instance id="facets" xmlns="">
<data>
<facet id="trust_t">Trust</facet>
<facet id="status">Status</facet>
<facet id="area">Area</facet>
</data>
</xf:instance>


<xf:instance id="control" xmlns="">
<data>
<fq></fq>
</data>
</xf:instance>

<xf:instance id="viewport" xmlns="">
<data>
	<latitude/>
	<longitude/>
</data>
</xf:instance>

		<xf:submission id="solr"  method="get" replace="instance"
		instance="results" ref="instance('query')" action="http://localhost:8080/lux/collection1/select">
		<xf:action ev:event="xforms-submit-done">
			<xf:load resource="javascript:rePlot()"/>
		</xf:action>
		</xf:submission>  
	
	 <xf:action ev:event="callbackevent">
 	 <xf:setvalue ref="instance('query')/fq[@id='0']" value="concat('location:[',event('latitude'), ' TO ', event('longitude'), ']')"/>
     <xf:send submission="solr"/>
 </xf:action>
	
	<xf:action ev:observer="query"  ev:event="xforms-insert">
 	<xf:setvalue ref="instance('query')/start" value="0"/> 
 	 <xf:send submission="solr"/>
    </xf:action>
    
    <xf:action ev:observer="query"  ev:event="xforms-delete"> 
    <xf:setvalue ref="instance('query')/start" value="0"/> 
 	 <xf:send submission="solr"/>
    </xf:action>
    
    	
	  <xf:action ev:event="xforms-ready">
   		<xf:send submission="solr"/>
 	</xf:action>


</xf:model>

	</head>
	<body>
		<div id="page">
			<div id="header">
				<div id="menunav">
					<div id="search">
					</div>
				</div>
				<div id="banner">
					<h2>Geovation</h2>
					<img id="bannerimg" src="/lux/lux/ari/resources/img/header-building.jpg"
						alt="Intranet" />

					<div id="globalnav">
						<xf:input ref='q' incremental='false'>
						</xf:input>
	 					<xf:trigger>
						<xf:label>Search</xf:label>
						<xf:action ev:event="DOMActivate">
						<xf:setvalue ref="instance('query')/start" value="'0'"/>
							<xf:send submission="solr" />
						</xf:action>
						</xf:trigger>
					</div>
				
				</div>
			</div>
			<div id="localnav">		
				<xf:group ref="instance('results')">
				<xf:repeat nodeset="lst[@name='facet_counts']/lst[@name='facet_fields']/lst" id="solr-facets1">
				<div class="facet">
					<h3><xf:output value="instance('facets')/facet[@id=context()/@name]" /></h3>
					<hr/>					
						<ul class="localnav">
						<xf:repeat nodeset="int" id="solr-facets11">
						<li>
							<xf:trigger appearance="minimal">
								<xf:label><xf:output value="@name"/>&#160;<span>(<xf:output value="." />)</span></xf:label>
								<xf:action ev:event="DOMActivate">
								<xf:setvalue ref="instance('control')/fq" value="concat('{{!term f=',context()/../@name,'}}',context()/@name)"/>
								<xf:insert context="instance('query')" origin="instance('control')/fq" />
               
								</xf:action>
								</xf:trigger>
						</li>		
						</xf:repeat>
						</ul>								
				</div>		
							
				</xf:repeat>
			
				</xf:group>
				
				
			</div>
			
			<div id="content">
			<xf:group ref="instance('results')">
						<h3>Results: <xf:output value="result[@name='response']@numFound"/></h3>
			</xf:group>
				<xf:group ref="instance('query')">
				<xf:repeat nodeset="fq[not(@id='0')]" id="solr-query1">
				<xf:trigger appearance="minimal">
				<xf:label><span>X</span>&#160;<xf:output value="substring-after(.,'}}')"/></xf:label>
				<xf:action ev:event="DOMActivate">
				 <xf:delete nodeset="instance('query')/fq[not(@id='0')]" at="index('solr-query1')"/>
				</xf:action>
				</xf:trigger>
				</xf:repeat>

				</xf:group>
				<hr/>
						<xf:trigger>
						<xf:label>Zoom In</xf:label>
						<xf:action ev:event="DOMActivate">
						<xf:load resource="javascript:centermap()"/>
						</xf:action>
						</xf:trigger>
						Debug: <xf:output value="instance('query')/fq[@id='0']"/>
				<xf:group ref="instance('results')/result[@name='response']">
				<div>
					<div class="hidden"><ul id="reslist">
					<xf:repeat nodeset="doc"> 				
    				<li loc="{{str[@name='location']}}"><xf:output value="str[@name='location']"/></li>			
					</xf:repeat>
					</ul>
				</div>
			</div>
				</xf:group>			
	
			</div>
			
			<div id="map" style="float:right; width: 680px; height: 500px"></div>
			<!-- This clearing element should immediately follow the div#content in 
				order to force div#page to contain all child floats -->
			<div id="footer">
			</div>
			
		</div>
	
	<script src="http://cdn.leafletjs.com/leaflet-0.6.4/leaflet.js"></script>
	<script src="/lux/lux/ari/resources/script/maps.js"></script>
			
			
	
	</body>
</html>





let $xslt-pi := processing-instruction xml-stylesheet {'type="text/xsl" href="/lux/lux/ari/resources/xsltforms_580/xsltforms.xsl"'}
let $css := processing-instruction css-conversion {'no'} 
return ($xslt-pi,$css,'<!DOCTYPE html>',$form)
