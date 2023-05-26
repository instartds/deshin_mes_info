<%@page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>System Status</TITLE>
<script type="text/javascript" charset="utf-8"	src="<c:url value='/resources/js/jquery/jquery.js' />"></script>
<style>
	/*--Main Wide Banner --*/
	.bnrMain_view {position:relative; height:187px; width:970px;}
	.visualWindow {height:187px; width:970px; overflow:hidden; position:relative;}
	.image_reel {position:absolute; top:0; left:0;}
	.image_reel img {margin-bottom:0px;}
	 
	.mpaging {position:absolute; top:165px; right:10px; height:11px; z-index:100; text-align:right; line-height:10px; display:none;}
	.mpaging a {width:12px; height:11px; margin:0 1px; text-decoration:none; color:#fff; display:block; float:left; 
					background-image:url("../resources/images/main/banner-mapping.png"); background-repeat:no-repeat; background-position:left top;}
	.mpaging a.bnrActive {background-position:-17px top;}
	.mpaging a:hover {background-position:-17px top;}
</style>
<script type="text/javascript">
$(function(){
	/* main wide banner control
	============================================================ */
	$(".mpaging").show();
	$(".mpaging a:first").addClass("bnrActive");
		
	var imageHeight = $(".visualWindow").height();
	var imageSum = $(".image_reel img").size();
	var imageReelHeight = imageHeight * imageSum;
	
	$(".image_reel").css({'height' : imageReelHeight});
	var ImgRotate = new Object();
	ImgRotate.rotate = function(){	
		var triggerID = $active.attr("rel") - 1;
		var image_reelPosition = triggerID * imageHeight;
 		//alert(image_reelPosition);
		$(".mpaging a").removeClass('bnrActive');
		$active.addClass('bnrActive');
		
		//Slider Animation
		$(".image_reel").animate({ 
			top: -image_reelPosition
		}, 500 );		
	}; 
		
	ImgRotate.rotateSwitch = function(){		
		play = setInterval(function(){
			$active = $('.mpaging a.bnrActive').next();
			if ( $active.length === 0) {
				$active = $('.mpaging a:first');
			}
			ImgRotate.rotate();
		}, 3500);
	};	
	ImgRotate.rotateSwitch();
	
	//On Hover
	$(".image_reel a").hover(function() {
		clearInterval(play);
	}, function() {
		ImgRotate.rotateSwitch();
	});	
	
	//On Click
	$(".mpaging a").click(function() {	
		$active = $(this);
		clearInterval(play); 
		ImgRotate.rotate();
		ImgRotate.rotateSwitch();
		return false;
	});	
});
</script>
</head>
<body>
<div class="bnrMain_view">
	<div class="mpaging">
		<a href="#" rel="1"></a>
		<a href="#" rel="2"></a>
		<!-- 갯수가 늘어나면  rel +1 하면서 추가하면 됩니다. -->
	</div>
	<div class="visualWindow">
		<div class="image_reel">
			<img src='<c:url value="/gadgets/main_banner_wide1.jpg"/>' alt='' />
			<img src='<c:url value="/gadgets/main_banner_wide2.jpg"/>' alt='' />
			<!-- 갯수가 늘어나면  추가하면 됩니다. -->
		</div>
	</div>
</div>
</body>
</html>