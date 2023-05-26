<%@page language="java" contentType="text/html; charset=utf-8"%>
    <%
        String aaa = request.getParameter("aaa");

    %>

  	var param = {ORDER_NUM: masterRec.get('ORDER_NUM'), CREATE_LOC: masterRec.get('CREATE_LOC'), DIV_CODE: masterRec.get('DIV_CODE')}
        	mpo150skrvService.selectList_yp(param, function(provider, response)  {
        	    var formatDate = UniAppManager.app.getTodayFormat();
                var requestMsg =              '<!doctype html>';
                    requestMsg +=  '<html lang=\"ko\">';
                    requestMsg +=  '<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">';
                    requestMsg +=  '<title>Untitled Document</title>';
                    requestMsg +=  '<table border=0 width=900px cellpadding=0 cellspacing=0><tr><td>';
                    requestMsg +=  '<table style="border-collapse:collapse; border:0px gray solid; margin:20px 0 20px 0; font-size: 12px; font-family:돋움" border="0" width= "100%" align="center">';
                    requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg +=  '    <td style="border:0px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis; font-size: 30px;" colspan="6" height= "100px">&nbsp;발&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서&nbsp;</td>';
                    requestMsg +=  '  </tr>';


// 발주번호를 바코드로 표현함..   위치 조정 필요
//                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
//                    requestMsg = requestMsg + '<td style="border:0px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;"></td>';
//                    requestMsg = requestMsg + '<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; font-family:Code39AzaleaWide2; font-size : 30px;">*'+ provider[0].ORDER_NUM +'*</td>';
//                    requestMsg = requestMsg + '</tr>';



                    requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg +=  '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="1"><b>발주번호: <ins>' + provider[0].ORDER_NUM + '</ins></b></td>';
                    requestMsg +=  '    <td style="border:0px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" rowspan="2"></td>';
                    requestMsg +=  '    <td style="border:0px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis; font-family:Code39AzaleaWide2; font-size : 40px; " colspan="5" rowspan="2">*'+ provider[0].ORDER_NUM +'*</td>';
                    requestMsg +=  '  </tr>';
                    requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    if(Ext.isEmpty(provider[0].RESPONSIBILITY_PHONE)){
                    	requestMsg +=  '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="1"><b>구매담당: <ins>'+ provider[0].ORDER_PRSN +'</ins></b></td>';
                    }else{
                    	requestMsg +=  '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="1"><b>구매담당: <ins>'+ provider[0].ORDER_PRSN + '(' + provider[0].RESPONSIBILITY_PHONE + ')' + '</ins></b></td>';
                    }
                    requestMsg +=  '  </tr>';
                    requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg +=  '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;"  width= "45%"><b>발주일자:&nbsp;'+ UniDate.getDbDateStr(provider[0].ORDER_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(provider[0].ORDER_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(provider[0].ORDER_DATE).substring(6, 8) +'</td></b>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" rowspan="5" bgcolor ="#F6F6F6" >발<br><br>주<br><br>자</td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">등&nbsp;록&nbsp;번&nbsp;호</td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" colspan="3">'+ provider[0].MY_COMPANY_NUM +'</td>';
                    requestMsg +=  '  </tr>';
                    requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg +=  '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;"><b><ins>'+ provider[0].CUSTOM_FULL_NAME +'&nbsp;&nbsp;&nbsp;&nbsp;貴中</ins></b></td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" width="70px">상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호</td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].MY_CUSTOM_NAME +'</td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" width="70px">대&nbsp;&nbsp;표&nbsp;&nbsp;자</td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].MY_TOP_NAME;
                    requestMsg +=  '  </tr>';
                    requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg +=  '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" ><b>다음과 같이 발주합니다.</td></b>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소</td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="3">'+ provider[0].MY_ADDR +'</td>';
                    requestMsg +=  '  </tr>';
                    requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg +=  '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" ><b>TEL:&nbsp;'+ provider[0].CUST_TEL_PHON +'</td></b>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">업&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;태</td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].COMP_TYPE +'</td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">종&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].COMP_CLASS +'</td>';
                    requestMsg +=  '  </tr>';
                    requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg +=  '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" ><b>FAX:&nbsp;'+ provider[0].CUST_FAX_NUM +'</td></b>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">전&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;화</td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].TELEPHON +'</td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">팩&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;스</td>';
                    requestMsg +=  '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].FAX_NUM +'</td>';
                    requestMsg +=  '  </tr>';
                    requestMsg +=  '</table>';

                    requestMsg +=  '</td></tr>';

                    requestMsg +=  '<tr><td>';
                    requestMsg +=  '	<table style="border-collapse:collapse; border:0px gray solid; margin:-20px 0 0px 0; font-size: 12px; font-family:돋움" >';
                    requestMsg +=  '		<tr><td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;"  ><b>입고장소:&nbsp;'  + provider[0].IN_DIV_NAME + '</td></b>';
                    requestMsg +=  '  	  	  <td style="border:0px gray solid;padding: 5px 10px ; text-align:left; text-overflow: ellipsis;"><b>입고사업장 주소:&nbsp;' + provider[0].IN_DIV_ADDR + '</td></b>';
                    requestMsg +=  '		</tr>';
                    requestMsg +=  '  </table>';
                    requestMsg +=  '</td></tr>';

                    requestMsg +=  '<tr><td hegiht="3px">';
                 //단가, 금액 사용여부 (기본은 N)
				if(Ext.getCmp('radioUnitPriceYn').getChecked()[0].inputValue ==  'Y'){
					    requestMsg +=  '<table style="border-collapse:collapse; border:1px gray solid; margin:20px 0 20px 0; font-size: 12px; font-family:돋움" width= "100%" align="center">';
	                    requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "6%">';
	                    requestMsg +=        '번호';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "10%">';
	                    requestMsg +=        '<t:message code="system.label.purchase.itemcode" default="품목코드"/>';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "20%">';
	                    requestMsg +=        '품&nbsp;&nbsp;&nbsp;&nbsp;명';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
	                    requestMsg +=        '규&nbsp;&nbsp;&nbsp;&nbsp;격';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
	                    requestMsg +=        '수&nbsp;&nbsp;&nbsp;&nbsp;량';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
	                    requestMsg +=        '단&nbsp;&nbsp;&nbsp;&nbsp;위';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
	                    requestMsg +=        '단&nbsp;&nbsp;&nbsp;&nbsp;가';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
	                    requestMsg +=        '금&nbsp;&nbsp;&nbsp;&nbsp;액';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "10%">';
	                    requestMsg +=        '납&nbsp;기&nbsp;일';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
	                    requestMsg +=        '비&nbsp;&nbsp;&nbsp;&nbsp;고';
	                    requestMsg +=    '</th>';
	                    requestMsg +=  '</tr>';

//	                    var totRecord = directMasterStore2.data.items;
	                    var amount = 0;
	                    Ext.each(provider, function(rec, i){
	                        requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" height= "30" >';
	                        requestMsg +=        rec.ORDER_SEQ;
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
	                        requestMsg +=        rec.ITEM_CODE;
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
	                        requestMsg +=        rec.ITEM_NAME;
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
	                        requestMsg +=        rec.SPEC;
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
	                        requestMsg +=        Ext.util.Format.number(rec.ORDER_UNIT_Q,'0,000.00');
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" align="right">';
	                        requestMsg +=        rec.ORDER_UNIT;
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
	                        requestMsg +=        Ext.util.Format.number(rec.ORDER_UNIT_P,'0,000');
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
	                        requestMsg +=        Ext.util.Format.number(rec.ORDER_O,'0,000');
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
	                        requestMsg +=        UniDate.getDbDateStr(rec.DVRY_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(6, 8);
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
	                        requestMsg +=        rec.REMARK;
	                        requestMsg +=    '</td>';
	                        requestMsg +=  '</tr>';
	                        amount +=  rec.ORDER_O;
	                        if(provider.length == i + 1){
	                            requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
	                            requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "20%" colspan=10>';
	                            requestMsg +=        'T O T A L&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + Ext.util.Format.number(amount,'0,000') + '&nbsp;원';
	                            requestMsg +=    '</th>';
	                            requestMsg +=  '</tr>';

	                            requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
	                            requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px;text-align:left; vertical-align:top;" height= "100" width = "20%" colspan=10>';
	                            requestMsg +=        '<b>비고(REMARK) :</b>' + rec.M_REMARK;
	                            requestMsg +=        '<br><br>※ 품질검수 마감 : 15:30 입수검사 마감으로 이전 시간 입고 할 것.';
	                            requestMsg +=        '<br>※ 나무팔레트를 금지하며, 수출용 팔레트 1100*1100 사용 할 것.';
	                            requestMsg +=        '<br>※ 박스 및 거래명세서에 자재코드/ 품명/ 입고일/ 입고수량/ LOSS 필히 기재 할 것.(거래명세표 주차 표기)';
	                            requestMsg +=        '<br>※ LOSS 용기 해당사항 :ex)오더 10,000→가산발주 2% :10,200 →LOSS2% :(오더*2%)+가산발주2%)=10,400';
	                            requestMsg +=        '<br>※ 상기 사항이 무단으로 이행되지 않았을 경우 반품 조치하도록 하겠습니다.';
	                            requestMsg +=    '</td>';
	                            requestMsg +=  '</tr>';




	                        }
	                    });
				}else{
					    requestMsg +=  '<table style="border-collapse:collapse; border:1px gray solid; margin:20px 0 20px 0; font-size: 12px; font-family:돋움" width= "100%" align="center">';
	                    requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "6%">';
	                    requestMsg +=        '번호';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "10%">';
	                    requestMsg +=        '<t:message code="system.label.purchase.itemcode" default="품목코드"/>';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "29%">';
	                    requestMsg +=        '품&nbsp;&nbsp;&nbsp;&nbsp;명';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
	                    requestMsg +=        '규&nbsp;&nbsp;&nbsp;&nbsp;격';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
	                    requestMsg +=        '수&nbsp;&nbsp;&nbsp;&nbsp;량';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
	                    requestMsg +=        '단&nbsp;&nbsp;&nbsp;&nbsp;위';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "10%">';
	                    requestMsg +=        '납&nbsp;기&nbsp;일';
	                    requestMsg +=    '</th>';
	                    requestMsg +=    '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "18%">';
	                    requestMsg +=        '비&nbsp;&nbsp;&nbsp;&nbsp;고';
	                    requestMsg +=    '</th>';
	                    requestMsg +=  '</tr>';

//	                    var totRecord = directMasterStore2.data.items;
	                    var amount = 0;
	                    Ext.each(provider, function(rec, i){
	                        requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" height= "30" >';
	                        requestMsg +=        rec.ORDER_SEQ;
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
	                        requestMsg +=        rec.ITEM_CODE;
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
	                        requestMsg +=        rec.ITEM_NAME;
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
	                        requestMsg +=        rec.SPEC;
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
	                        requestMsg +=        Ext.util.Format.number(rec.ORDER_UNIT_Q,'0,000.00');
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" align="right">';
	                        requestMsg +=        rec.ORDER_UNIT;
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
	                        requestMsg +=        UniDate.getDbDateStr(rec.DVRY_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(6, 8);
	                        requestMsg +=    '</td>';
	                        requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
	                        requestMsg +=        rec.REMARK;
	                        requestMsg +=    '</td>';
	                        requestMsg +=  '</tr>';
	                        amount = amount + rec.ORDER_O;
	                        if(provider.length == i + 1){
	                            requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
	                            requestMsg +=    '<td style="border:1px gray solid;padding: 5px 10px;text-align:left; vertical-align:top;" height= "100" width = "20%" colspan=10>';
	                            requestMsg +=        '<b>비고(REMARK) :</b>' + rec.M_REMARK;
	                            requestMsg +=        '<br><br>※ 품질검수 마감 : 15:30 입수검사 마감으로 이전 시간 입고 할 것.';
	                            requestMsg +=        '<br>※ 나무팔레트를 금지하며, 수출용 팔레트 1100*1100 사용 할 것.';
	                            requestMsg +=        '<br>※ 박스 및 거래명세서에 자재코드/ 품명/ 입고일/ 입고수량/ LOSS 필히 기재 할 것.(거래명세표 주차 표기)';
	                            requestMsg +=        '<br>※ LOSS 용기 해당사항 :ex)오더 10,000→가산발주 2% :10,200 →LOSS2% :(오더*2%)+가산발주2%)=10,400';
	                            requestMsg +=        '<br>※ 상기 사항이 무단으로 이행되지 않았을 경우 반품 조치하도록 하겠습니다.';
	                            requestMsg +=    '</td>';
	                            requestMsg +=  '</tr>';
	                        }
	                    });
				}


                    requestMsg += '</table>';
                    requestMsg += '<table style=" border:0px gray solid; margin:0 0 0 0; font-size: 12px; font-family:돋움" border="0" width= "100%" align="right">' ;
                    requestMsg += 	'<tr style="border:0px gray solid;padding: 0px 0 0 0px;">';
                    requestMsg +=    	'<td style="border:0px gray solid;padding: 0px 0px 0 0; text-align:left;  font-size: 12px;"  height= "30px" width= "33%">KD-E-05-01</td>' ;
                    requestMsg +=     	'<td style="border:0px gray solid;margin: 0px 0px 0 50; text-align:center;  font-size: 12px;"  height= "30px" width= "34%">(주)코디</td>' ;
                    requestMsg +=     	'<td style="border:0px gray solid;padding: 0px 0px 0 0; text-align:right;  font-size: 12px;"  height= "30px"width= "33%">A4(210*297mm)</td>' ;
                	requestMsg +=	' </tr></table>' ;
                    requestMsg += ' <br/><A href="http://121.170.176.11:8080/home/common/Barcode_Code39Azalea_Fonts.zip">바코드FONT다운로드</A>';
                    requestMsg += '</td></tr></table>';
                    requestMsg += '</body>';
                    requestMsg += '</html>';

                    masterRec.set('CONTENTS', requestMsg);
                    masterRec.set('SUBJECT', masterRec.get('MAIL_SUBJECT'));
	              //20190603 보내는 사람 메일 구매담당자 공통코드의 ref_code2의 값에 해당하는 id의 메일주소(bas300t)로 세팅, 값이 없으면 기존대로.
	                masterRec.set('FROM_EMAIL', masterRec.data.EMAIL_ADDR);
	                masterRec.set('CC', '');
	                masterRec.set('BCC', '');
	                masterRec.set('FROM_NAME', inputTable.getValue('FROM_NAME'));
	                masterRec.set('FROM_PRSN', inputTable.getValue('FROM_NAME'));

                var param = masterRec.data;
                /************20190715발주서 pdf첨부***************/
                param.PGM_ID = 'mpo502ukrv';  //프로그램ID
           		param.MAIN_CODE = 'M030'; //해당 모듈의 출력정보를 가지고 있는 공통코드
                param.sTxtValue2_fileTitle = '발 주 서';
				param.CUSTOM_FORM = BsaCodeInfo.gsCustomFormYn;
				param.UNIT_PRICE_YN = Ext.getCmp('radioUnitPriceYn').getChecked()[0].inputValue;
				param.MAIL_FORMAT = Ext.getCmp('formGubun').getChecked()[0].inputValue;
				/*******************************************/

				// 메일 전송
				sendMail(param, masterRec);
        	});



