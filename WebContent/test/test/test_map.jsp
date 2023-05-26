<%@page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>Fusion Charts Demo</TITLE>
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/redmond/jquery-ui-1.8.16.custom.css'/>" />
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/extjs/ext-all.css'/>" />

<script language="JavaScript"
	src="<c:url value='/js/jquery/jquery.js"'/>"></script>
<script language="JavaScript"
	src="<c:url value='/js/jquery/jquery-ui.js"'/>"></script>
<script language="JavaScript"
	src="<c:url value='/js/extjs/ext-all.js"'/>"></script>

<script language="JavaScript" src="<c:url value='/js/FusionCharts.js'/>"></script>
<script language="JavaScript" src="<c:url value='/js/FusionMaps.js'/>"></script>
<script type="text/javascript">
var stringXml = "<map animation='0' showShadow='0' showBevel='0' showMarkerLabels='1' includeNameInLabels='0' fillColor='F1f1f1' borderColor='000000' baseFont='Verdana' baseFontSize='10' markerBorderColor='000000' markerBgColor='FF5904' markerRadius='6' legendPosition='bottom' useHoverColor='1' showMarkerToolTip='1'  >"
		+ "	<data>"
		+ "<entity id='NA' value='150' displayValue='북미' toolText='북미'  />"
		+ "<entity id='SA' value='250' displayValue='남미' toolText='남미'  />"
		+ "<entity id='EU' displayValue='유럽' toolText='유럽'  />"
		+ "<entity id='AS' displayValue='아시아' toolText='아시아'  />"
		+ "<entity id='AF' displayValue='아프리카' toolText='아프리카'  />"
		+ "<entity id='AU' displayValue='호주' toolText='호주'  />"
		+ "</data>"
		+ "</map>"	;
</script>
</head>
<body>
	<table>

		<tr>
			<td>
				<img src="<c:url value='/images/map/worldmap.gif'/>" />
				<div id="mEU" style="position: fixed; top:70px; left:50px; ">[]</div>
				<div id="mHQ" style="position: fixed; top:100px; left:250px">[ ]</div>
				<div id="mAM" style="position: fixed; top:100px; left:550px">[ ]</div>
				<div id="mID" style="position: fixed; top:200px; left:150px">[ ]</div>
				<script	type="text/javascript">
						var chartObj1 = new FusionCharts({
							swfUrl: "<c:url value='/charts/Column3D.swf'/>",
							width: "150", height: "100",			           
							dataSource: "data/Col3D1.xml",
							dataFormat: FusionChartsDataFormats.XMLURL,				           
							renderAt: 'mEU'
				        }).render();

						var chartObj2 = new FusionCharts({
							swfUrl: "<c:url value='/charts/Column3D.swf'/>",
							width: "150", height: "100",			           
							dataSource: "data/Col3D1.xml",
							dataFormat: FusionChartsDataFormats.XMLURL,				           
							renderAt: 'mHQ'
				        }).render();
						var chartObj3 = new FusionCharts({
							swfUrl: "<c:url value='/charts/Column3D.swf'/>",
							width: "150", height: "100",			           
							dataSource: "data/Col3D1.xml",
							dataFormat: FusionChartsDataFormats.XMLURL,				           
							renderAt: 'mAM'
				        }).render();
						var chartObj4 = new FusionCharts({
							swfUrl: "<c:url value='/charts/Column3D.swf'/>",
							width: "150", height: "100",			           
							dataSource: "data/Col3D1.xml",
							dataFormat: FusionChartsDataFormats.XMLURL,				           
							renderAt: 'mID'
				        }).render();

						chartObj1.setTransparent(true);
						chartObj2.setTransparent(true);
						chartObj3.setTransparent(true);
						chartObj4.setTransparent(true);
				</script>
			</td>
		</tr>
		<tr>
			<td>

				<div id="mapDiv" align="center" ></div> 
				<script	type="text/javascript">
					var map = new FusionMaps(
							"<c:url value='/charts/Maps/FCMap_World.swf'/>",
							"Map_Id", 750, 500, "0", "0");
					map.setDataXML(stringXml);
					map.render("mapDiv");
				</script></td>
		</tr>
	</table>

</body>
</html>