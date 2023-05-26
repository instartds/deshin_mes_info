<%@page language="java" contentType="text/html; charset=utf-8"%>
<jsp:include page="_testHeader.jsp" />

    
<script type="text/javascript">

$(document).ready(function(){
	  $('input:disabled').bind('mouseover', function(){
	    $(this).css({border: '4px solid #00f'});
	  });
});

	function crgEventListner(callID) {
		alert(callID);
	}
	
	function test01() {
		//document.forms["test"].t3.valu3="3";
		 $("input[name=t3]").val("t3");
	}
</script>
<style>
	input:disabledx {
		border:1px solid #f00;
	}
	:FOCUS {
		border : 1px solid #0f0;
}
	input[disabled='disabled'], input.disabledColor {
		color:#f00;
	}
	select{
	   border:0;
	}
</style>
</head>

    <form name="test" CLASS="X">
    <up:select name="crgClass" codeGroup="CM018"  selected="${item.crgClass }" option="I" style="width:150px"/>
    	<label >Code : <input type="text" name="code" /></label> <a href="#" onclick="crgCommonCodeLookup('input[name=code]', 'CM031', 'input[name=code]', 'input[name=name]')">[CODE]</a> <br/>

    	<label >Name : <input type="text" name="name" /></label>
    	<hr/>
        <label >Company Code : <input type="text" name="cmpnyCd" /></label> <a href="#" onclick="crgCommonCompLookup('input[name=cmpnyCd]', 'F', 'input[name=cmpnyCd]', 'input[name=cmpnyNm]','')">[CODE]</a> <br/>
        <label >Company Name : <input type="text" name="cmpnyNm" /></label>
        <hr/>
        <label >Multi ICD/Terminal Code : <input type="text" name="multiCmpnyCd" /></label> <a href="#" onclick="crgCommonCompLookup('input[name=multiCmpnyCd]', 'W', 'input[name=multiCmpnyCd]', 'input[name=multiCmpnyNm]','W,T')">[W&T CODE]</a> crgCommonCompLookup('input[name=multiCmpnyCd]', 'W', 'input[name=multiCmpnyCd]', 'input[name=multiCmpnyNm]','W,T') <br/>
        <label >ICD/Terminal Name : <input type="text" name="multiCmpnyNm" /></label>
        <hr/>
        <label >All Customs Warehouse Code : <input type="text" name="allCmpnyCd" /></label> <a href="#" onclick="crgCommonCompLookup('input[name=allCmpnyCd]', 'W', 'input[name=allCmpnyCd]', 'input[name=allCmpnyNm]','', '*')">[CODE]</a> crgCommonCompLookup('input[name=allCmpnyCd]', 'W', 'input[name=allCmpnyCd]', 'input[name=allCmpnyNm]','', '*') <br/>
        <label >Warehouse Name : <input type="text" name="allCmpnyNm" /></label>

        <hr/>
    	<label >MRN : <input type="text" name="mrn1" /></label><a href="#" onclick="crgMRNLookUp('input[name=mrn1]', '12345')">&nbsp;<img src="<c:url value='/images/co/search2.gif' />" /></a>
    	<hr/>
    	<label >MRN without callID: <input type="text" name="mrn2" /></label><a href="#" onclick="crgMRNLookUp('input[name=mrn2]')">&nbsp;<img src="<c:url value='/images/co/search2.gif' />" /></a>
    	
    	
    	<label >T1<input type="text" readonly="readonly" name="t1" onfocus="this.blur()"/></label><br/>
    	<label >T2<input type="text" readonly="readonly" name="t2" title="rararar"  /></label><br/>
    	<label >T3<input type="text" readonly="readonly" name="t3" value="disableddisableddisabled" title="werwerwer" class="disabledColor"/></label> <a href="#" onclick="test01()">TT</a><br/>
    	<label >T4<input type="text" readonly="readonly" name="t4" /></label><br/>
    </form>
    
</body>
</html>
