<%@page language="java" contentType="text/html; charset=utf-8"%>
<c:set var='defaultWidth' value='980' />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="mobile-web-app-capable" content="yes" />
<meta name="viewport" content="user-scalable=yes, height=device-height, width=${defaultWidth}, initial-scale=.5, maximum-scale=4, minimum-scale=.5" /> 
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="pragma" content="no-cache" />

<title>OMEGA Plus Mobile Test</title>

<script type="text/javascript" charset="UTF-8" src='mobile.js'></script>


<style>
    .mbox {
        width:${defaultWidth}px;
        border: 1px solid #f00;
    }
</style>
</head>
<body >
default width = ${defaultWidth}<br/>
<div class='mbox'>
    <a href='test1.jsp'>device width test</a>
    <br /><br /><br />
    <a href='http://www.quirksmode.org/mobile/metaviewport/' target='_blank'>info</a>
    <hr/>
    <script type="text/javascript" >
        var size = fnGetWidthHeight()
        out('width x height = ' + size.width + ' x ' + size.height);
        
        if (isMobile()) {
            out('You are using mobile mode');
            out('orientation : ' + getOrientation());
        } else {
            out('You are using desktop mode');
        }

        out( 'UserAgent: '+navigator.userAgent);
</script>
</div>
</body>
</html>