<%@page language="java" contentType="text/html; charset=utf-8"%>
<script type="text/javascript" charset="UTF-8" src='/g3erp/app/Unilite/locale/Message-ko.js' ></script>
<script type="text/javascript">
		function changeColData() 
		{
			var vbSource = document.form1.colData.value;
			var splitData = vbSource.split("\n");
			var result = "";
			for(var i=0 ; i < splitData.length; i++)	{	
				splitData[i] = splitData[i].trim();
				if(splitData[i].lastIndexOf("'") < 0 ) splitData[i]=splitData[i]+" '";
				if(splitData[i].lastIndexOf("'") > 0)	{
					splitData[i] = splitData[i].substr(0, splitData[i].lastIndexOf("'"))+",text:'"+splitData[i].substr(splitData[i].lastIndexOf("'")+1,splitData[i].length);
					splitData[i] = splitData[i].replace('.ColData(.ColIndex("',",{name: '");
					
					if(splitData[i].indexOf("NUM") > 0)	{
						splitData[i] = splitData[i]+"	,type : 'int'";
					}else if(splitData[i].indexOf("STR") > 0)	{
						splitData[i] = splitData[i]+"	,type : 'string'" ;
					}else {
						splitData[i] = splitData[i]+"	,type : ''";
					}
					
					if(splitData[i].indexOf('"NN"') > 0 || splitData[i].indexOf('"PK"')>0)	{
						splitData[i] = splitData[i].substr(0, splitData[i].indexOf('"'))+"'    "+splitData[i].substr(splitData[i].lastIndexOf(",text:'"),splitData[i].length)+", allowBlank:false ";
					}else {
						splitData[i] = splitData[i].substr(0, splitData[i].indexOf('"'))+"'    "+splitData[i].substr(splitData[i].lastIndexOf(",text:'"),splitData[i].length);
					}

			 		result = result+splitData[i]+"} \n";
				}
			document.form1.modelData.value = result;
				
			}
			
		}
		// .ColWidth(.ColIndex("CUSTOM_CODE"))         = 1000  '  거래처
		//  ==> ,{ dataIndex: 'CUSTOM_CODE',  width: 100,  text: '거래처', style: 'text-align:center'} 
		
		function changeGrd() 
		{
			var vbSource = document.form1.colWidth.value;
			var splitData = vbSource.split("\n");
			var result = "";
			for(var i=0 ; i < splitData.length; i++)	{	
				if(splitData[i].lastIndexOf("'") < 0 ) splitData[i]=splitData[i]+" '";
				if(splitData[i].lastIndexOf("'") > 0)	{
					splitData[i] = splitData[i].substr(0, splitData[i].lastIndexOf("'"));
					splitData[i] = splitData[i].replace('.ColWidth(.ColIndex("',",{ dataIndex: '");
					splitData[i] = splitData[i].replace("00","0");
					splitData[i] = splitData[i].substr(0, splitData[i].indexOf('"'))+"',  width:"+splitData[i].substr(splitData[i].lastIndexOf("=")+1,splitData[i].length);
					
					while(splitData[i].indexOf("' ") > 0) {
						splitData[i] = splitData[i].replace("' ","'");
					}
			 		result = result+splitData[i]+"} \n";
				}
			document.form1.grdColumns.value = result;
				
			}
			
		}
		
		function changeHeader() 
		{
			var vbSource = document.form1.header.value.replace(/& _/g,'');
			vbSource = vbSource.replace(/\n/g,'');
			vbSource = vbSource.replace(/\t/g,'');
			vbSource = vbSource.replace(/vbtab/g,'');
			vbSource = vbSource.replace(/ /g,'');
			var splitData = vbSource.split('&');
			var result = "";
			for(var i=0 ; i < splitData.length; i++)	{		
					splitData[i] = splitData[i].replace(/&/g,'');
					//result = result+'<'+splitData[i]+'>\n'
					if(splitData[i] !='')	{
						var msgCode = '';
						try{
							msgCode=eval('Msg.'+splitData[i]);
						}catch(e){
							msgCode=splitData[i];
						}
			 			result = result+'<'+'t:message code="unilite.msg.'+splitData[i]+'" default="'+msgCode+'"/> \n';
					}
			}
			document.form1.grdHeaders.value = result;
			
		}
</script>
<form name="form1">
<table width="100%">
	<tr>
		<th height="30" colspan="3" style="background-color:#cccccc;"> ColData</th>
	</tr>
	<tr>
		<th>VB Source</th>
		<th align="right"></th>
		<th>ExtJs - Model</th>
	</tr>
	<tr>
		<td  width="50%"><textarea name = "colData" style="width : 100%" rows= "20">		.ColData(.ColIndex("COMP_CODE"))         = "PK" & Chr(7) & "STR"  '  법인코드
		.ColData(.ColIndex("CLIENT_ID"))         = "EX" & Chr(7) & "NUM"  '  고객 ID
		.ColData(.ColIndex("CLIENT_NAME"))       = "NN" & Chr(7) & "STR"  '  고객명
		.ColData(.ColIndex("CLIENT_TYPE"))       = "  " & Chr(7) & "STR"  '  고객구분
		.ColData(.ColIndex("CUSTOM_CODE"))       = "NN" & Chr(7) & "STR"  '  고객업체
		.ColData(.ColIndex("CUSTOM_NAME"))       = "EX" & Chr(7) & "STR"  '  고객업체		</textarea></td>
		<td align="center"><input type="button" value=" 변환 >>" onclick="changeColData()"></td>
		<td width="50%"><textarea name = "modelData" style="width : 100%" rows= "20" readOnly></textarea></td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<th height="30" colspan="3" style="background-color:#cccccc;"> ColWidth</th>
	</tr>
	
	<tr>
		<th>VB Source</th>
		<th>&nbsp;</th>
		<th >ExtJs - Grid</th>
	</tr>
	<tr>
		<td><textarea name = "colWidth"  style="width : 100%" rows= "20">		.ColWidth(.ColIndex("COMP_CODE"))         = 1000  '  법인코드
		.ColWidth(.ColIndex("CLIENT_ID"))         = 1000  '  고객 ID
		.ColWidth(.ColIndex("CLIENT_NAME"))       = 1400  '  고객명
		.ColWidth(.ColIndex("CLIENT_TYPE"))       = 1200  '  고객구분
		.ColWidth(.ColIndex("CUSTOM_CODE"))       = 1000  '  고객업체</textarea></td>
		<td align="center"><input type="button" value=" 변환 >> " onclick = "changeGrd()" ></td>
		<td><textarea name = "grdColumns"  style="width : 100%" rows= "20" readOnly></textarea></td>
	</tr>
		<tr>
		<th height="30" colspan="3" style="background-color:#cccccc;"> Table Header</th>
	</tr>
	<tr>
		<th>VB Source</th>
		<th align="right"></th>
		<th>ExtJs </th>
	</tr>
	<tr>
		<td><textarea name = "header"  style="width : 100%" rows= "20">		& vbtab & sMB183 & vbtab & sMR004 & vbtab & sMR005  & vbtab & sMR349 & "1" & vbtab & sMR349 & "2" & vbtab & _
		         sMR006 & vbtab  & sMR350 & vbtab & sMR391 & vbtab & sMR355 & vbCrLf & sMR392</textarea></td>
		<td align="center"><input type="button" value=" 변환 >> " onclick = "changeHeader()" ></td>
		<td><textarea name = "grdHeaders"  style="width : 100%" rows= "20" readOnly></textarea></td>
	</tr>
</table>
</form>

</body>
</html>
