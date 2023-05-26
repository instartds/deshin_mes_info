<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
	<title>TRA Cargo Management System (Import Declaration)</title>
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="pragma" content="no-cache" />
	<script type="text/javascript" src="/js/jquery/jquery-1.6.2.js" ></script>

    <script type="text/javascript" src="/js/co/miya_validator.js"></script>
<style>
fieldset {
	border-width: 1px;
	border-color: #e0e0e0;
	margin-bottom: 10px;
}

legend {
	font-weight: bold;
	font-size: 12px;
	background-color: #ffffff;
}

</style>
<script type="text/javascript">
// <![CDATA[
function checkForm(form) {
    var v = new MiyaValidator(form);
    v.add(["nm","no1","no2"], { required:true } );
    
    v.add("nm", {
        minbyte: 3,
        maxbyte: 10
    });
    v.add("no1", {
    	option: "number",
    	min:10
    });    
      
        
    v.add(["no2","no21"], {
    	option: "float"
    });
  
    v.add("no3", {
    	option: "numericonly"
    });  
    
    v.add("_param1_date", {
    	required: true,
    	option: "isdate"
    });    

    
    v.add("frmSelect", {
    	required: true
    });
    
    v.add(["no41","no42"], {
    	option: "float"
    });
    
    v.add("no41", {
    	morethen:"no42"
    });
    
    
    // 둘중 하나가 있어야 함.    
    var mc1 = new MiyaCondition("grpa1", {
        required: true
    }, null, document.forms["form"]);
    var mc2 = new MiyaCondition("grpa2", {
        required: true
    }, null, document.forms["form"]);

    
    var result = false;
    //try {
    	result = v.validate();
    //} catch(e) {alert(e); }

    if (!result) {
        alert("Error : " + v.getErrorMessage());
        v.focus();
        return false;
    } else {
        if(confirm("수정하시겠습니까?")) {
        	return true;
        } else {
        	return false;
        }
    };
    
};
// ]]>
</script>
<script>

function test() {
	var frm = document.forms["frm"];
	checkForm(frm);
}
</script>
</head>
<body>

<a href="javascript:test()">[Validate]</a>

<span id="test_span"></span>
<form onsubmit="return checkForm(this);" id="frm" name="frm">

<fieldset><legend>Validation Sample</legend>
<table class="tblEdit" width="100%">
	<tr>
		<td colspan="2" align="center"><input type="submit"></td>
	</tr>
	<tr>
		<th><label for="frmSelect">frmSelect</label></th>
		<td><select name="frmSelect" id="frmSelect" >
		<option value="">All</option>
		<option value="1">1</option>
		<option value="2">2</option>
		<option value="3">3</option>
		</select></td>
	</tr>

	<tr>
		<th><g:label code="tlms_trngsprvsn" required="true" for="nm"/></th>
		<td><input type="text" name="nm" id="nm" value="13"/> minbyte : 3, Maxbytes : 10</td>
	</tr>
	<tr>
		<th><label for="no1">정수(number)</label></th>
		<td><input type="text" name="no1" id="no1" value="0"  class="mask_number"/>masked</td>
	</tr>
	<tr>
		<th><label for="no2">실수(float,포함)</label></th>
		<td><input type="text" name="no2" id="no2" value="123.01" class="mask_float" /> float</td>
	</tr>
	<tr>
		<th><label for="no21">실수(float,포함)</label></th>
		<td><input type="text" name="no21" value="0"  class="mask_float"/></td>
	</tr>	
	<tr>
		<th><label for="no3">Numeric Only</label></th>
		<td><input type="text" name="no3" id="no3" value="123"  /></td>
	</tr>	
	<tr>
		<th><label for="no41" class="required">Numeric Only(less)</label></th>
		<td><input type="text" name="no41" value="1000"  />~<input type="text" name="no42" value="2,236.00"  /></td>
	</tr>		
	<tr>
		<th><uts:Label name="AUTH_GRP_CD" value="AUTH_GRP_CD" cssClass="xx" for="grpa1" required="true" /></th>
		<td><input type="text" name="grpa1" value=""  /><input type="text" name="grpa2" value=""  /></td>
	</tr>
	<tr>
		<th><label for="grpb1">그룹b1</label></th>
		<td><input type="text" name="grpb1" value=""  />
		<input type="text" name="grpb2" value=""  />
		<input type="text" name="grpb3" value=""  /></td>
	</tr>
	
	<tr>
		<th><label for="grpc1">그룹c1(xor)</label></th>
		<td><input type="text" name="grpc1" value=""  />
		<input type="text" name="grpc2" value=""  />
		<input type="text" name="grpc3" value=""/>

</td>
	</tr>	
	<tr>
		<th><label for="no3">숫자만3</label></th>
		<td><input type="text" name="no3" value="x123"  /></td>
	</tr>	
	<tr>
		<th><label for="_param1_date">날자</label></th>
		<td><input type="text" name="_param1_date" value="2009-02-14"/>
			<input name="image" type="image" />
		</td>
	</tr>	

	<tr>
		<th><label for="_param1_content22">내용</label></th>
		<td>
			<textarea rows="3" cols="70" id="_param1_content22" name="_param1_content22" class="input" 
			onkeyup="gls.byteLimit(this, 10,'byteLengthSpan')"></textarea>
			<span id="byteLengthSpan" style="width: 90"></span>
		</td>
	</tr>
	<tr>
		<th><label for="_param1_content33">내용</label></th>
		<td>
			<textarea rows="3" cols="70" id="_param1_content33" name="_param1_content33" class="input" 
			onkeyup="gls.byteLimit(this, 20,'byteLengthSpan2')"></textarea>
			<span id="byteLengthSpan2" style="width: 90"></span>
		</td>
	</tr>		
	<tr>
		<td colspan="2" align="center"><input type="submit"></td>
	</tr>
</table>

</fieldset>
</form>
</body>
</html>