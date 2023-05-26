//@charset UTF-8
/**
 * 회계 모듈용 공통 함수 모음
 * @class Unilite.module.UniSales
 * @singleton
 */
var dynamicId = 'dynamicPopup';
var cnt = 1;
var gsBankValueFieldName = '';
var gsBankTextFieldName = '';
/**
 * 회계모듈 공통 함수
 */
Ext.define('Unilite.module.UniAccnt', {	
    alternateClassName: 'UniAccnt',
    /**
     * singleton
     */
    singleton: true, 
    /**
     * 관리항목 필드 생성
     * @param acCode  관리항목 코드
     * @param acName  관리항목 라밸
     * @param fName   항목 필드 명
     * @param fDataName	필드데이타명
     * @param acType 	관리항목 타입
     * @param acPopup   팝업필드여부
     * @param acLen     데이타 길이
     * @param acCtl     필수입력 여부
     * @param acFormat  데이타 포멧(숫자)
     * @param fieldKind 범위일 필드일 경우 (frField/toGield)
     * @param form 관리항목 폼
     * @param otherForm 관련데이타가 입력되야 할 폼
     * @param extParam  팝업의 경우 추가변수
     * @param record    입력 데이타 Record
     * 
     */
	makeItem: function( acCode,  acName,  fName, fDataName, acType, acPopup, acLen, acCtl, acFormat, fieldKind, form, otherForm, extParam, record)	{
		if(!Ext.isEmpty(fieldKind)){
			if(fieldKind == 'frField'){
				fName = 'DYNAMIC_CODE_FR';
				fDataName = 'DYNAMIC_NAME_FR';
			}else{
				fName = 'DYNAMIC_CODE_TO';
				fDataName = 'DYNAMIC_NAME_TO';
				acName = '~';
			}
		}
		
		var field = {};
		// acType
		if(acPopup == 'Y')	{
			switch(acCode)	{
    			case 'A2': Ext.apply(field, Unilite.popup('DEPT',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));		//부서
    				break;
    			case 'A3': gsBankValueFieldName = fName; gsBankTextFieldName = fDataName; Ext.apply(field, Unilite.popup('BANK',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));		//은행
    				break;
    			case 'A4': var aBankBookColNm, aBankColNm;
    					   if(record)	{
    						var idx = this.findAcCode(record, "O2");
    					     aBankBookColNm = "AC_DATA"+idx;
    					     aBankColNm = "AC_DATA_NAME"+idx;
    					   }
    					   Ext.apply(field, 
    					   		Unilite.popup('CUST',{
    					   			autoPopup:true,
	    					   		fieldLabel:acName, 
	    					   		valueFieldName: fName, 
	    					   		textFieldName: fDataName, 
	    					   		extParam:{"CUSTOM_TYPE":['1','2','3']},
	    					   		listeners: {
	    					   			onValueFieldChange: function(field, newValue){
                                            if(!otherForm) return false; 
                                            otherForm.setValue(fName, form.getValue(fName));                              
                                        },
                                        onTextFieldChange: function(field, newValue){
                                            if(!otherForm) return false;    
                                            otherForm.setValue(fDataName, form.getValue(fDataName));
                                        },
	    					   			'onSelected': { 
	    					   				fn: function(records, type) {
	    					   					var agjRecord = record;
	    					   					console.log("aBankBookColNm : ", aBankBookColNm);
	    					   					if(agjRecord)	{
	    					   						agjRecord.set("CUSTOM_CODE",records[0]['CUSTOM_CODE']);
	    					   						agjRecord.set("CUSTOM_NAME",records[0]['CUSTOM_NAME']);
	    					   					}
	    					   					if(!otherForm) return false; 
	    					   					otherForm.setValue(fName, form.getValue(fName)); 
	    					   					otherForm.setValue(fDataName, form.getValue(fDataName));
	    					   					
	    					   					var bankBookColNm = aBankBookColNm, bankColNm = aBankColNm;
	    					   					if(!Ext.isEmpty(bankBookColNm))	{
	    					   						//otherForm.getField(bankBookColNm).getEl().dom.innerHTML = otherForm.getField(bankBookColNm).getEl().dom.innerHTML + records[0].BANK_NAME;
	    					   						otherForm.setValue(bankBookColNm, records[0].BOOK_CODE);	 
	    					   						console.log(" #######   bankColNm : ", bankColNm)
	    					   						console.log(" #######   records[0].BOOK_NAME : ", records[0].BOOK_NAME)
	    					   						otherForm.setValue(bankColNm, records[0].BOOK_NAME);	
	    				
	    					   					}
	    					   				}, 
	    					   				scope: this}, 
	    					   			'onClear': function(type){
	    					   				if(!otherForm) return false; 
	    					   				otherForm.setValue(fName, ''); 
	    					   				otherForm.setValue(fDataName, '');
	    					   				var bankBookColNm = aBankBookColNm;
	    					   				if(!Ext.isEmpty(bankBookColNm))	{
	    					   						otherForm.setValue(bankBookColNm, "");	    	
	    					   				}
	    					   			}
	    					   		}
    					   		})
    					   	);		//거래처
    				break;
    			case 'A6': Ext.apply(field, Unilite.popup('Employee',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));	//사번
    				break;
    			case 'A7': Ext.apply(field, Unilite.popup('CUST',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//예산코드
    				break;
    			case 'A9': Ext.apply(field, Unilite.popup('COST_POOL',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, extParam:extParam, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//Cost Pool
    				break;
    			case 'B1': Ext.apply(field, Unilite.popup('DIV_PUMOK',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, extParam:extParam, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//사업장별 품목팝업
    				break;
    			case 'C2': var aBankCd, aBankNm, aCustCd, aCustNm, aExpDate;	//어음번호
    						var sAllowImput = false
    					   if(record)	{
    						var bankIdx = this.findAcCode(record, "A3");
    					     aBankCd = "AC_DATA"+bankIdx;
    					     aBankNm = "AC_DATA_NAME"+bankIdx;
    					     
    					    var custIdx = this.findAcCode(record, "A4");
    					     aCustCd = "AC_DATA"+custIdx;
    					     aCustNm = "AC_DATA_NAME"+custIdx;
    					   
    					    var expDateIdx = this.findAcCode(record, "C3");
    					     aExpDate = "AC_DATA"+expDateIdx;
    					     
    					     if(record.get('SPEC_DIVI') == "D1" && record.get("DR_CR")=="1") {
    					     	sAllowImput = true;
    					     }
    					     if(record.get('SPEC_DIVI') == "D3" && record.get("DR_CR")=="2") {
    					     	sAllowImput = true;
    					     }
    					   }
    					   Ext.apply(field, 
    					   		Unilite.popup('NOTE_NUM',{
    					   			autoPopup:true,
    					   			fieldLabel:acName, 
    					   			valueFieldName: fName, 
    					   			textFieldName: fName, 
    					   			DBtextFieldName : 'NOTE_NUM_CODE',
    					   			DBValueFieldName : 'NOTE_NUM_CODE',
    					   			dataRecord : record,
    					   			autoPopup:false,
    					   			allowInputData:sAllowImput,
    					   			extParam:{'EXT_TYPE':'AGJ'},
    					   			listeners: {
    					   				onSelected: { 
    					   					fn: function(records, type){
    					   						if(!otherForm) return false; 
    					   						otherForm.setValue(fName, form.getValue(fName)); 
    					   						otherForm.setValue(fDataName, form.getValue(fDataName));
    					   						
    					   						//var bankCd=aBankCd, bankNm=aBankNm, custCd=aCustCd, custNm=aCustNm, expDate=aExpDate;
    					   						var rRecord = record;
    					   						var chkAmt = true;
    					   						if(rRecord != null && Ext.isFunction(UniAppManager.app.fnCheckNoteAmt))	{
    					   							var rfieldName = rRecord.get("DR_CR") =="1" ? "DR_AMT_I" : "CR_AMT_I";
    					   							chkAmt = UniAppManager.app.fnCheckNoteAmt( null, rRecord, rRecord.get("AMT_I"),   rRecord.get("AMT_I"));
    					   						}
    					   						//if(chkAmt)	{
    					   							if(aBankCd) otherForm.setValue(aBankCd, records[0].BANK_CODE);
	    					   						if(aBankNm) otherForm.setValue(aBankNm, records[0].BANK_NAME);
	    					   						if(aCustCd) otherForm.setValue(aCustCd, records[0].CUSTOM_CODE);
	    					   						if(aCustNm) otherForm.setValue(aCustNm, records[0].CUSTOM_NAME);
	    					   						if(aExpDate) otherForm.setValue(aExpDate, records[0].EXP_DATE);
    					   						//}else {
    					   						//	otherForm.setValue(fName, ""); 
    					   						//}
    					   					}, 
    					   					scope: this
    					   				}
    					   				, onClear: function(type){
    					   					if(!otherForm) return false; 
    					   					//otherForm.setValue(fName, ''); 
    					   					//otherForm.setValue(fDataName, '');
    					   					
    					   					if(aBankCd) otherForm.setValue(aBankCd, "");
					   						if(aBankNm) otherForm.setValue(aBankNm, "");
					   						if(aCustCd) otherForm.setValue(aCustCd, "");
					   						if(aCustNm) otherForm.setValue(aCustNm, "");
					   						if(aExpDate) otherForm.setValue(aExpDate, "");
    					   				},
    					   				applyExtParam:function(popup)	{
    					   					var extParam = popup.extParam;
    					   					//20161118 - 팝업 오픈 시, null 참조인 'get' 속성을 가져올 수 없습니다. (오류)
    					   					if (!Ext.isEmpty(popup.dataRecord)){
	    					   					extParam.DR_CR = popup.dataRecord.get("DR_CR");
	    					   					extParam.SPEC_DIVI = popup.dataRecord.get("SPEC_DIVI");
	    					   					extParam.TYPE =  "AGJ";
												popup.setExtParam(extParam);
    					   					}
									 	}
    					   			}
    					   		})
    					   	);			//어음번호
    				break;
    			case 'C7': var aBankCd, aBankNm, aPubDate;	//수표번호
    					   if(record)	{
    						var bankIdx = this.findAcCode(record, "A3");
    					     aBankCd = "AC_DATA"+bankIdx;
    					     aBankNm = "AC_DATA_NAME"+bankIdx;
    					    var pubDateIdx = this.findAcCode(record, "C4");
    					     aPubDate = "AC_DATA"+pubDateIdx;
    					   } 
    						Ext.apply(field, 
    							Unilite.popup('CHECK_NUM',{
    								autoPopup:true,
    								fieldLabel:acName, 
    								valueFieldName: fName, 
    								textFieldName: fDataName, 
    								listeners: {
    									onSelected: { 
    										fn: function(records, type){
    											if(!otherForm) return false; 
    											otherForm.setValue(fName, form.getValue(fName)); 
    											otherForm.setValue(fDataName, form.getValue(fDataName));
    											
    											if(aBankCd) otherForm.setValue(aBankCd, records[0].BANK_CODE);
    					   						if(aBankNm) otherForm.setValue(aBankNm, records[0].BANK_NAME);
    					   						if(aPubDate) otherForm.setValue(aPubDate, records[0].PUB_DATE);
    										}, 
    										scope: this
    									}, 
    									onClear: function(type){
    										if(!otherForm) return false; 
    										otherForm.setValue(fName, ''); 
    										otherForm.setValue(fDataName, '');
    										
    										if(aBankCd) otherForm.setValue(aBankCd, "");
					   						if(aBankNm) otherForm.setValue(aBankNm, "");
					   						if(aPubDate) otherForm.setValue(aPubDate, "");
    									}
    								}
    							})
    						);			//수표번호
    				break;
    			case 'D5': Ext.apply(field, Unilite.popup('EX_LCNO',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//L/C번호(수출)
    				break;
    			case 'D6': Ext.apply(field, Unilite.popup('IN_LCNO',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//L/C번호(수입)
    				break;
    			case 'D7': Ext.apply(field, Unilite.popup('EX_BLNO',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//B/L번호(수출)
    				break;
    			case 'D8': Ext.apply(field, Unilite.popup('IN_BLNO',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//B/L번호(수입)
    				break;
    			case 'DA': Ext.apply(field, Unilite.popup('PASS_SER_NO',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fName, allowInputData:true, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//B/L번호(수입)
					break;
    			case 'DC': var aIssuDateField;
				   		   if(record)	{
				   			   var idx = this.findAcCode(record, "DD");
				   			   aIssuDateField = "AC_DATA"+idx;
				   		  }
				   		  Ext.apply(field, Unilite.popup('PURCH_DOC_NO',
    									{
    										autoPopup:true,
    										fieldLabel:acName,
    										valueFieldName: fName,
    										textFieldName: fName,
    										allowInputData:true,
    										listeners: {
    											onSelected: {
    												fn: function(records, type){
    													if(!otherForm) return false; 
    													otherForm.setValue(fName, form.getValue(fName)); 
    													otherForm.setValue(fDataName, form.getValue(fDataName))
    													otherForm.setValue(aIssuDateField, records[0].ISSUE_DATE); 
    												;}, 
    												scope: this
    											}, 
    											onClear: function(type){
    												if(!otherForm) return false; 
    												otherForm.setValue(fName, ''); 
    												otherForm.setValue(fDataName, '');
    												otherForm.setValue(aIssuDateField, ''); 
    											}
    										}
    								 }));			//구매확인서번호
					break;
    			case 'E1': Ext.apply(field, Unilite.popup('AC_PROJECT',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//프로젝트
    				break;
    			case 'E2': Ext.apply(field, Unilite.popup('ACCNT',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//계정과목
    				break; 
    			case 'E3': Ext.apply(field, Unilite.popup('COM_ABA210',
    									{
    										autoPopup:true,
					    					fieldLabel:acName, 
					    					valueFieldName: fName,
					    					textFieldName: fDataName, 
					    					extParam:{'SUB_CODE':acCode},
					    					listeners: {
					    						onSelected: { 
					    							fn: function(records, type){
					    								if(!otherForm) return false; 
					    								otherForm.setValue(fName, form.getValue(fName)); 
					    								otherForm.setValue(fDataName, form.getValue(fDataName));
					    							}, 
					    							scope: this}, 
					    						onClear: function(type){
					    							if(!otherForm) return false; 
					    							otherForm.setValue(fName, ''); 
					    							otherForm.setValue(fDataName, '');
					    						},
		    					   				applyExtParam:function(popup)	{
		    					   					var extParam = popup.extParam;
		    					   					popup.extParam.SUB_CODE='E3';
													popup.setExtParam(extParam);
											 
											 	}
					    					}
					    				})
					    	);			//관리항목
    				break; 
    			case 'G5': Ext.apply(field, Unilite.popup('CREDIT_NO',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//증빙유형
    				break;
    			case 'M1': var aBankCd, aBankNm;	//자산코드
    					   if(record)	{
    						var bankIdx = this.findAcCode(record, "A3");
    					     aBankCd = "AC_DATA"+bankIdx;
    					     aBankNm = "AC_DATA_NAME"+bankIdx;
    					   } 
    						Ext.apply(field, 
    							Unilite.popup('ASSET',{
    								autoPopup:true,
    								fieldLabel:acName, 
    								valueFieldName: fName, 
    								textFieldName: fDataName, 
    								listeners: {
    									onSelected: { 
    										fn: function(records, type){
    											if(!otherForm) return false; 
    											otherForm.setValue(fName, form.getValue(fName)); 
    											otherForm.setValue(fDataName, form.getValue(fDataName));
    											
    											if(aBankCd) otherForm.setValue(aBankCd, records[0].BANK_CODE);
    					   						if(aBankNm) otherForm.setValue(aBankNm, records[0].BANK_NAME);
    					   						
    										}, 
    										scope: this
    									},
    									onClear: function(type){
    										if(!otherForm) return false; 
    										otherForm.setValue(fName, ''); 
    										otherForm.setValue(fDataName, '');
    										
    										if(aBankCd) otherForm.setValue(aBankCd, "");
					   						if(aBankNm) otherForm.setValue(aBankNm, "");
					   						
    									}
    								}
    							})
    						);			//자산코드
    				break;
    			case 'O1': Ext.apply(field, Unilite.popup('BANK_BOOK',{autoPopup:true,fieldLabel:acName
    																, valueFieldName: fName
    																, textFieldName: fDataName
    																, extParam:extParam
    																, listeners: {
    																	onSelected: { 
    																		fn: function(records, type){
    																			form.setValue(gsBankValueFieldName, records[0].BANK_CD); 
    																			form.setValue(gsBankTextFieldName, records[0].BANK_NM); 
    																			if(!otherForm) return false; 
    																			otherForm.setValue(gsBankValueFieldName, records[0].BANK_CD); 
    																			otherForm.setValue(gsBankTextFieldName, records[0].BANK_NM); 
    																			otherForm.setValue(fName, form.getValue(fName)); 
    																			otherForm.setValue(fDataName, form.getValue(fDataName));}, 
    																		scope: this
    																	}
    																 , onClear: function(type){ 
    																 			form.setValue('BANK_CODE', ''); 
    																 			form.setValue('BANK_NAME', '');
    																 			if(!otherForm) return false;
    																 			otherForm.setValue(fName, ''); 
    																 			otherForm.setValue(fDataName, '');
    																 	}
    																 ,applyExtParam:function(popup)	{
																			popup.setExtParam(extParam);
    																 
    																 	}
    																 }
    																 
    																 }));			//Deposit
    				break;
    			case 'O2': 
    					   Ext.apply(field, Unilite.popup('BOOK_CODE',{autoPopup:true,fieldLabel:acName
    																, valueFieldName: fName
    																, textFieldName: fDataName
    																, dataRecord : record
    																,listeners: {
    																	onSelected: { 
    																		fn: function(records, type){
    																			if(!otherForm) return false; 
    																			otherForm.setValue(fName, form.getValue(fName)); 
    																			otherForm.setValue(fDataName, form.getValue(fDataName));}, 
    																		scope: this
    																	}
    																 , onClear: function(type){ 
    																 			if(!otherForm) return false;
    																 			otherForm.setValue(fName, ''); 
    																 			otherForm.setValue(fDataName, '');
    																 	}
    																 ,applyExtParam:function(popup)	{
    																 		extParam.CUSTOM_CODE = popup.dataRecord.get('CUSTOM_CODE');
    																 		console.log("extParam : ", extParam)
																			popup.setExtParam(extParam);
    																 
    																 	}
    																 }
    																 
    																 }));			
    				break;
    			case 'P2': Ext.apply(field, Unilite.popup('DEBT_NO',{autoPopup:true,fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//차입금번호
    				break; 		
    			case 'I5': Ext.apply(field, 
									  Unilite.popup('COMMON',{
									  		autoPopup:true,
											itemId: dynamicId + cnt, 
											fieldBsaCode: 'A022', 
											usePopup: 'common', 
											valueFieldName: fName, 
											textFieldName: fDataName, 
											listeners: {
												onSelected: { 
													fn: function(records, type){
														var agjRecord = record;
			    					   					if(agjRecord)	{
			    					   						agjRecord.set("PROOF_KIND",records[0]['COMMON_CODE']);
			    					   						agjRecord.set("PROOF_KIND_NM",records[0]['COMMON_NAME']);
			    					   						agjRecord.set("REASON_CODE", '');
															agjRecord.set("CREDIT_NUM", '');
															agjRecord.set("CREDIT_NUM_EXPOS", '');
															if(Ext.isFunction(UniAppManager.app.fnProofKindPopUp)) UniAppManager.app.fnProofKindPopUp(agjRecord, records[0]['COMMON_CODE']);
															if(Ext.isFunction(UniAppManager.app.fnSetTaxAmt)) UniAppManager.app.fnSetTaxAmt(agjRecord, null, records[0]['COMMON_CODE']);
															if(Ext.isFunction(UniAppManager.app.fnSetDefaultAcCodeI7)) UniAppManager.app.fnSetDefaultAcCodeI7(agjRecord, records[0]['COMMON_CODE']);
			    					   					}
														if(!otherForm) return false; 
														otherForm.setValue(fName, form.getValue(fName)); 
														otherForm.setValue(fDataName, form.getValue(fDataName));}, 
													scope: this
												}, 
												onClear: function(type){
													if(!otherForm) return false; 
													otherForm.setValue(fName, ''); 
													otherForm.setValue(fDataName, '');
												},
									  			applyextparam:function(field)	{
									  				var sBsaCode = 'A022', sAcName= acName; 
									  				field.extParam={'BSA_CODE':sBsaCode, 'HEADER':sAcName};
									  			}
											}
									})
							); 
    			default:	//동적 팝업  (공통코드, 사용자 정의 팝업)
    				var bsaCode = '';
					if(UniUtils.indexOf(acCode, ["B5", "C0", "D2", "I4", "I7", "Q1", "A8", "E4"])){		//공통코드 팝업 생성						
						switch(acCode){
							case "B5" :
								bsaCode = 'B013'							
							break;
							case "C0" :
								bsaCode = 'A058'
							break;
							case "D2" :
								bsaCode = 'B004'
							break;
							case "I4" :
								bsaCode = 'A003'
							break;
							case "I7" :
								bsaCode = 'A149'
							break;
							case "Q1" :
								bsaCode = 'A171'
							break;
							case "A8" :
								bsaCode = 'A170'
							break;
							case "E4" :
								bsaCode = 'A238'
							break;
						}						
						if(fieldKind == 'toField'){
							Ext.apply(field, 
									  Unilite.popup('COMMON',{
									  		autoPopup:true,
											itemId: dynamicId + cnt, 
											fieldBsaCode: bsaCode, 
											usePopup: 'common', 
											valueFieldName: fName, 
											textFieldName: fDataName, 
											listeners: {
												onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, 
												onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');},
									  			applyextparam:function(field)	{var sBsaCode = bsaCode, sAcName= acName; field.extParam={'BSA_CODE':sBsaCode, 'HEADER':sAcName};}
											}
									})
							); // 빈팝업 생성						
						}else{
							Ext.apply(field, 
									  Unilite.popup('COMMON',{
									  		autoPopup:true,
									  		itemId: dynamicId+ cnt, 
									  		fieldBsaCode: bsaCode, 
									  		usePopup: 'common', 
									  		valueFieldName: fName, 
									  		textFieldName: fDataName, 
									  		extParam:{'BSA_CODE':bsaCode, 'HEADER':acName},
									  		listeners: {
									  			onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, 
									  			onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');},
									  			applyextparam:function(field)	{var sBsaCode = bsaCode, sAcName= acName; field.extParam={'BSA_CODE':sBsaCode, 'HEADER':sAcName};}
									  		}
									  })
							); // 빈팝업 생성	DYNAMIC_CODE_TO	
						}
						
						
					}else if(UniUtils.indexOf(acCode, ["R1", "Z0", "Z1", "Z2", "Z3", "Z4", "Z5", "Z6", "Z7", "Z8", "Z9",	//사용자 정의 팝업 생성
														   "Z10","Z11","Z12","Z13","Z14","Z15","Z16","Z17","Z18","Z19","Z20",
														   "Z21","Z22","Z23","Z24","Z25","Z26","Z27","Z28","Z29", "Z34", "Z35"])){				
						if(fieldKind == 'toField'){
							Ext.apply(field, 
									  Unilite.popup('USER_DEFINE',{
									  		autoPopup:true,
									  		itemId: dynamicId + cnt, 
									  		usePopup: 'userDefine', 
									  		valueFieldName: fName, 
									  		textFieldName: fDataName, 
									  		extParam:{'AC_CD':acCode, 'HEADER':acName},
									  		listeners: {
									  			onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, 
									  			onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');},
									  			applyextparam:function(field)	{var sAcCode = acCode, sAcName= acName; field.extParam={'AC_CD':sAcCode, 'HEADER':sAcName}}
									  		}
									  	})
							); // 빈팝업 생성
						}else{
							Ext.apply(field, 
									  Unilite.popup('USER_DEFINE',{
									  		autoPopup:true,
									  		itemId: dynamicId + cnt, 
									  		usePopup: 'userDefine', 
									  		valueFieldName: fName, 
									  		textFieldName: fDataName, 
									  		extParam:{'AC_CD':acCode, 'HEADER':acName},
									  		listeners: {
									  			onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, 
									  			onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');},
									  			applyextparam:function(field)	{var sAcCode = acCode, sAcName= acName; field.extParam={'AC_CD':sAcCode, 'HEADER':sAcName}}
									  		}
									  	})
							); // 빈팝업 생성
						}
						
					}
    				break;
    		}
		}else {
    		switch(acType)	{
    			case 'A': 
    				if(acCode == 'O2' && acPopup != 'Y') {
    					Ext.apply(field, 
    							 {
    								xtype:'fieldcontainer',
    								fieldLabel:acName, 
    								tdAttrs:{style : {'margin-top':'0px'}},
    								layout:{type:'table', columns:2, tableAttrs:{cellpadding:0, cellspacing:0, border:0}}, 
    								items:[{
    								  	xtype:'uniTextfield', 
    								  	name:fName, 
    								  	maxLength: acLen, 
    								  	enforceMaxLength: true, 
    								  	listeners: { 
    								  		change: function(combo, newValue, oldValue, eOpts){if(!otherForm) return ; otherForm.setValue(fName, form.getValue(fName));}
    								  	}
    								},{
    								  	xtype:'displayfield',
    								  	name:fDataName,
    								  	value:''
    								}]
    							}
    					);
    				}else {
    					Ext.apply(field, {fieldLabel:acName, xtype:'uniTextfield', name:fName, maxLength: acLen, enforceMaxLength: true, listeners: { change: function(combo, newValue, oldValue, eOpts){if(!otherForm) return ; otherForm.setValue(fName, form.getValue(fName));}}});
    				}
    				break;
    			case 'N': 
    				if(acCode == 'I1' || acCode == 'I6') {
    					Ext.apply(field, {fieldLabel:acName, xtype:'uniNumberfield', name:fName, maxLength: acLen, enforceMaxLength: true, 
    										listeners: {
    											'afterrender': function( field, eOpts ) 	{
    												setTimeout(function(){field.showVAT(field, record);},500);
    											},
    											'blur': function(field, event, eOpts ){
    												field.showVAT(field, record);
												},
												'change' : function( field, newValue,oldValue, eOpts )	{
													field.showVAT(field, record, newValue);
												}
    										},
    										showVAT:function(field, record, value)	{
    											var price = 0, tax = 0;
												if(record){
    												for(var i=1;i <=6 ;i++)	{
    													if(record.get('AC_CODE'+i) == 'I1') {
    														if('AC_DATA'+i == field.name){
    															price = (value == null) ? field.lastValue : value;//record.get('AC_DATA'+i) ;
    														}else{
    															price = record.get('AC_DATA'+i);
    														}
    													}else if(record.get('AC_CODE'+i) == 'I6'){
    														if('AC_DATA'+i == field.name){
    															tax = (value == null) ? field.lastValue : value;//record.get('AC_DATA'+i) ;
    														}else{
    															tax = record.get('AC_DATA'+i);
    														}
    													}
    												}
    												var sum = parseFloat(Unilite.nvl(price,0)) + parseFloat(Unilite.nvl(tax,0));
    												var cmp = form.down('#acItem8');			//20200702 수정: 관리항목이 6개일 때, 합계 금액 표시 위해 변경(acItem5 -> acItem8)
    												if(cmp && cmp.getEl() && cmp.getEl().dom) cmp.getEl().dom.innerHTML = '<div style="text-align:right">VAT 포함: '+Ext.util.Format.number(sum,UniFormat.Price)+'원</div>';
    												
												}
    										}
    									});
    						
    				}else {
    					Ext.apply(field, {fieldLabel:acName, xtype:'uniNumberfield', name:fName, maxLength: acLen, enforceMaxLength: true, listeners: { change: function(combo, newValue, oldValue, eOpts){if(!otherForm) return ; otherForm.setValue(fName, form.getValue(fName));}}});
    				}
    				break;
    			case 'D': Ext.apply(field, {fieldLabel:acName, xtype:'uniDatefield', name:fName, formatText: Unilite.dateFormat,
    										listeners: { 
    											change: function(field, newValue, oldValue, eOpts){
    												if(Ext.isDate(field.getValue()))	{
	    												if(!otherForm) return ; 
	    												otherForm.setValue(fName, UniDate.getDateStr(field.getValue()));
	    												
    													var grdRecord = record;
	    												if(grdRecord)	{
	    													grdRecord.set(fName, UniDate.getDateStr(field.getValue()));
	    												}
    												}
    											},
    											blur:function(field,  eOpts){
    												var grdRecord = record;
    												if(grdRecord)	{
    													grdRecord.set(fName, UniDate.getDateStr(field.getValue()));
    												}
    											}
    										}
    									  });
    				break;
    			default:
    				break;
    		}
		}
		if(acType=='N')	{
			switch(acFormat)	{
    			case 'Q': Ext.apply(field, {uniType:'uniQty'		, type:'uniQty'});	
    				break;
    			case 'P': Ext.apply(field, {uniType:'uniUnitPrice'	, type:'uniUnitPrice'}); 
    				break;
    			case 'I': Ext.apply(field, {uniType:'uniPrice'		, type:'uniPrice'});
    				break;
    			case 'O': Ext.apply(field, {uniType:'uniFC'			, type:'uniFC'});
    				break;
    			case 'R': Ext.apply(field, {uniType:'uniER'			, type:'uniER'});
    				break;
    			default:
    				break;
    		}
		}
		if(acCtl == 'Y')	{
			Ext.apply(field, {allowBlank: false, labelClsExtra :'required_field_label'});
		}
		cnt++;
		return field;		
	},
	
	/**
	 * 관리항목 입력 폼 생성시 공백 cell 생성
	 */
	makeBlankField: function(itemId)	{
		var field={xtype:'component'};
		if(itemId)  Ext.apply(field, {'itemId':itemId,  html:"<span style='line-height:22px;'>&nbsp;</span>"});
		return field;
	},	
	
	/**
	 * 6개 관리항목 중 항목코드에 맞는 index 반환
	 */
	findAcCode:function(record, acCode)	{
		var r ="";
		for(var i=1; i <= 6 ; i++)	{
			if(acCode == record.get('AC_CODE'+i.toString()))	{
				r = i.toString();
			}
		}
		return r;
	},
	
	/**
	 * 계정잔액 index 반환 함수 
	 * BOOK_CODE1/BOOK_CODE2 의 1,2 반환
	 * @param record  데이타모델 
	 * @param acCode  관리항목 코드
	 * @param prefix  {prefix}_CODE{index} = "BOOK"+"_CODE"+"1"
	 * 
	 * @example UniAccnt.findAcCodeByPrefix(record, "A3", "BOOK")
	 */
	findAcCodeByPrefix:function(record, acCode, prefix)	{
		var r ="";
		for(var i=1; i <= 6 ; i++)	{
			if(acCode == record.get(prefix+"_CODE"+i.toString()))	{
				r = i.toString();
			}
		}
		return r;
	},
	
	/**
	 * 결의/회계 전표의 관리항목 form field 생성
	 * @param form  생성된 필드가 표시된 form
	 * @param dataMap 관리항목 설정 정보 데이타 Object
	 * @param otherForm 관리항목 생성시 같이
	 * @param opt  관리항목 설정 정보 데이타 옵션( 1 : 미결 항목용,  2:계정잔액1,2용)
	 * @param record 선택 레코드
	 * @param prevRecord 이전 레코드
	 */
	addMadeFields : function( form, dataMap, otherForm,  opt, record, prevRecord)	{
    	var fName, acCode, acName, acType, acPopup, acLen, acCtl, acFormat;
    	var field1, field3, field5	//필드간의 간격 조정위해 앞에 필드들이 팝업필드인지 일반필드인지 확인
		console.log('dataMap: ',dataMap)
		
		if(form.down('#formFieldArea2')){
			form.down('#formFieldArea1').removeAll();
			form.down('#formFieldArea2').removeAll();		
		}else{
			form.down('#formFieldArea1').removeAll();
		}
		
//		form.on('add', function(form, component){
//			if(!component.allowBlank){
//				component.labelClsExtra = 'required_field_label'
//			}
//		})
		
		if(opt == '1'){		//미결 항목용
			acCode= dataMap['PEND_CODE'];
			if(!Ext.isEmpty(acCode) && dataMap['PEND_YN'] == "Y"){
				fName = 'PEND_CODE';
				fDataName = 'PEND_NAME';
				acName = dataMap['PEND_NAME'];
				acType = dataMap['PEND_TYPE'];
				acPopup = dataMap['PEND_POPUP'];
				acLen = dataMap['PEND_LEN'];
//				acCtl = dataMap['AC_CTL1'];
//				acFormat = dataMap['AC_FORMAT1'];
				var field = UniAccnt.makeItem(acCode,  acName,	fName,	fDataName,	acType, acPopup, acLen, acCtl, acFormat, '', form, otherForm)
				if(Ext.isEmpty(field.fieldLabel)) return false;
				field1 = field;
				if(!Ext.isEmpty(field.usePopup)){
					form.down('#formFieldArea1').add(field);
					UniAccnt.setDynamicPopup(field, form, acCode, acName);
				}else{
					form.down('#formFieldArea1').add(field);
				}			
			}else {
				form.down('#formFieldArea1').removeAll();
			}
		}else if(opt == '2'){	//계정잔액1,2용
			acCode= dataMap['BOOK_CODE1'];
			var i;
			for(i=1; i<7; i++){
				if(acCode  == dataMap['AC_CODE'  + (i)]){
					acType  = dataMap['AC_TYPE'  + (i)];
					acPopup = dataMap['AC_POPUP' + (i)];
					acLen   = dataMap['AC_LEN'   + (i)];
				}
			}
			if(!Ext.isEmpty(acCode)){
				fName = 'BOOK_CODE1';
				fDataName = 'BOOK_NAME1';
				acName = dataMap['BOOK_NAME1'];
//				acCtl = dataMap['AC_CTL1'];
//				acFormat = dataMap['AC_FORMAT1'];
				
					var extParam = {};
					if(acCode=='O1')	{		//통장팝업
						var accnt = dataMap['ACCNT'];
						if(!Ext.isEmpty(accnt))	{
							extParam = {'ACCNT':accnt}
						}
					}
					if(acCode=='O2')	{		//통장코드
						extParam = {'CUSTOM_CODE':dataMap['CUSTOM_CODE']}
					}
					if(acCode=='B1')	{		//품목코드
						extParam = {'DIV_CODE':dataMap['DIV_CODE']}
					}
					if(acCode=='A9')	{		//COST POOL
						extParam = {'DIV_CODE':dataMap['DIV_CODE']}
					}
					/*if(acCode=='G5')	{		//신용카드 - 계정코드
						extParam = {'ACCNT':dataMap['ACCNT']}
					}*/
					
				var field = UniAccnt.makeItem(acCode,  acName,	fName,	fDataName,	acType, acPopup, acLen, acCtl, acFormat, '', form, otherForm, extParam);
				if(Ext.isEmpty(field.fieldLabel)) return false;
				field1 = field;
				if(!Ext.isEmpty(field.usePopup)){
					form.down('#formFieldArea1').add(field);
					UniAccnt.setDynamicPopup(field, form, acCode, acName);
				}else{
					form.down('#formFieldArea1').add(field);
				}			
				
			}else {
				form.down('#formFieldArea1').add(UniAccnt.makeBlankField());	
			}
			
			acCode= dataMap['BOOK_CODE2'];
			for(i=1; i<7; i++){
				if(acCode  == dataMap['AC_CODE'  + (i)]){
					acType  = dataMap['AC_TYPE'  + (i)];;
					acPopup = dataMap['AC_POPUP' + (i)];;
					acLen   = dataMap['AC_LEN'   + (i)];
				}
			}
			if(!Ext.isEmpty(acCode))	{
				fName = 'BOOK_CODE2';
				fDataName = 'BOOK_NAME2';
				acName = dataMap['BOOK_NAME2'];
//				acCtl = dataMap['AC_CTL1'];
//				acFormat = dataMap['AC_FORMAT1'];
				
					var extParam = {};
					if(acCode=='O1')	{		//통장팝업
						var accnt = dataMap['ACCNT'];
						if(!Ext.isEmpty(accnt))	{
							extParam = {'ACCNT':accnt}
						}
					}
					if(acCode=='O2')	{		//통장코드
						extParam = {'CUSTOM_CODE':dataMap['CUSTOM_CODE']}
					}
					if(acCode=='B1')	{		//품목코드
						extParam = {'DIV_CODE':dataMap['DIV_CODE']}
					}
					if(acCode=='A9')	{		//COST POOL
						extParam = {'DIV_CODE':dataMap['DIV_CODE']}
					}
					/*if(acCode=='G5')	{		//신용카드 - 계정코드
						extParam = {'ACCNT':dataMap['ACCNT']}
					}*/
					
				var field = UniAccnt.makeItem(acCode,  acName,	fName,	fDataName,	acType, acPopup, acLen, acCtl, acFormat, '', form, otherForm, extParam);
				if(Ext.isEmpty(field.fieldLabel)) return false;
				field1 = field;
				if(!Ext.isEmpty(field.usePopup)){
					if(form.down('#formFieldArea2')){
						form.down('#formFieldArea2').add(field);
					}else{
						form.down('#formFieldArea1').add(field);
					}					
					UniAccnt.setDynamicPopup(field, form, acCode, acName);
				}else{
					if(form.down('#formFieldArea2')){
						form.down('#formFieldArea2').add(field);
					}else{
						form.down('#formFieldArea1').add(field);
					}
				}			
			}else {
				if(form.down('#formFieldArea2')){
					form.down('#formFieldArea2').removeAll();
				}			
			}
		}else{	//관리항목 1~6용
			//20200702 수정: 관리항목이 6개일 때, 합계 금액 표시 위해 변경(1 ~ 6 -> 1 ~ 9)
//			var acNumArr = ['1','4','2','5','3','6'];
			var acNumArr = ['1','4','7','2','5','8','3','6','9'];
			form.prevRecord = prevRecord;
			for(var i=0; i < 9; i++)	{
				var j = acNumArr[i];
				acCode= dataMap['AC_CODE'+j];
				if(!Ext.isEmpty(acCode))	{
					fName = 'AC_DATA'+j;
					fDataName = 'AC_DATA_NAME'+j;
					acName = dataMap['AC_NAME'+j];
					acType = dataMap['AC_TYPE'+j];
					acPopup = dataMap['AC_POPUP'+j];
					acLen = dataMap['AC_LEN'+j];
					acCtl = dataMap['AC_CTL'+j];
					acFormat = dataMap['AC_FORMAT'+j];
					
					var extParam = {};
					if(acCode=='O1')	{		//통장팝업
						var accnt = dataMap['ACCNT'];
						if(!Ext.isEmpty(accnt))	{
							extParam = {'ACCNT':accnt}
						}
					}
					if(acCode=='O2')	{		//통장코드
						extParam = {'CUSTOM_CODE':dataMap['CUSTOM_CODE']}
					}
					if(acCode=='B1')	{		//품목코드
						extParam = {'DIV_CODE':dataMap['DIV_CODE']}
					}
					if(acCode=='A9')	{		//COST POOL
						extParam = {'DIV_CODE':dataMap['DIV_CODE']}
					}
					/*if(acCode=='G5')	{		//신용카드 - 계정코드
						extParam = {'ACCNT':dataMap['ACCNT']}
					}*/
					
					var field = UniAccnt.makeItem(acCode,  acName,	fName,	fDataName,	acType, acPopup, acLen, acCtl, acFormat, '',        form, otherForm, extParam, record)
					if(Ext.isEmpty(field.fieldLabel)) return false;
					if(acPopup == 'Y') {
						if(!field.listeners)	{
							Ext.apply(field, {listeners:{'onTextSpecialKey': function(elm, e){ UniAccnt.onSpecialKey(elm, e, dataMap); }
														 ,'onValueSpecialKey':function(elm, e){ UniAccnt.onSpecialKey(elm, e, dataMap); }
														 }
											 }
							);
						}else {
							Ext.Object.merge(field.listeners, {'onTextSpecialKey': function(elm, e){ UniAccnt.onSpecialKey(elm, e, dataMap); }
														 ,'onValueSpecialKey':function(elm, e){ UniAccnt.onSpecialKey(elm, e, dataMap); }
														 }
							);
						}
					} else {
						if(!field.listeners)	{
							Ext.apply(field, {listeners:{'specialkey': function(elm, e){ UniAccnt.onSpecialKey(elm, e, dataMap); }}});
						}else {
							Ext.Object.merge(field.listeners, {'specialkey': function(elm, e){ UniAccnt.onSpecialKey(elm, e, dataMap); }});
						}
					}
					field1 = field;
					
					if(!Ext.isEmpty(field.usePopup)){
						form.down('#formFieldArea1').add(field);
						UniAccnt.setDynamicPopup(field, form, acCode, acName);
					}else{
						
						form.down('#formFieldArea1').add(field);
					}	
					
				}else {
					form.down('#formFieldArea1').add(UniAccnt.makeBlankField('acItem'+i));	
				}
			}
			
		}
		
		//form.masterGrid.addChildForm(form);
		form._onAfterRenderFunction(form);
		 
		console.log('form:', form);
	},	
	
	/**
	 * 관리항목 Dynamic field enteryKey event로 다음 필드에 포커스 이동
	 * @param field
	 * @param selectText
	 * @param e
	 * @param dataMap
	 */
	focusNextField: function (field, selectText, e,dataMap) {
		var form = field.up('form');
		var focusable, targetField;
		var acNumArr = ['AC_DATA1','AC_DATA2','AC_DATA3','AC_DATA4','AC_DATA5','AC_DATA6'];
		
		if(Ext.isDefined(field.triggerBlur))
				field.triggerBlur();
			else
				field.blur();
			
		if(field.isPopupField ) {
			if(Ext.isEmpty(field.triggers.popup) )	{
				focusable = form.getField('AC_DATA_NAME'+(acNumArr.indexOf(field.name)+1));
			}else {
				var fieldName = 'AC_DATA'+(parseInt(field.name.replace('AC_DATA_NAME',''))+1);
				if(acNumArr.indexOf(fieldName) != 5 && Ext.isDefined(dataMap[acNumArr[acNumArr.indexOf(fieldName)+1]]) )	{
					focusable = form.getField(fieldName);
				}
			}
		}
		
		if(!focusable && acNumArr.indexOf(field.name) > -1)	{
			if(acNumArr.indexOf(field.name) == 5 || !Ext.isDefined(dataMap[acNumArr[acNumArr.indexOf(field.name)+1]] ) )	{
				focusable = null;
			}else {
				focusable = form.getField(acNumArr[acNumArr.indexOf(field.name)+1]);
			}
		}
		if(focusable ) {
			
			if(focusable.xtype == 'uniTagfield')	{
				targetField = focusable.el.down('.x-tagfield-input-field');
			}else {
				targetField = Ext.isEmpty(focusable.el.down('.x-form-cb-input')) ? focusable.el.down('.x-form-field'):focusable.el.down('.x-form-cb-input');
			}
			if(targetField) {
					
				targetField.focus(10);	
				if(selectText) {
					if(!focusable.el.down('.x-form-cb-input')) {
						targetField.dom.select();
					}
				}
			}
			
		}else{
			// 마지막 필드인 경우
			var grid = UniAppManager.app.getActiveGrid();
			var navi = grid.getView().getNavigationModel();
			var columnIndex, rowIndex = grid.getStore().indexOf(form.activeRecord)
			var columns = grid.getVisibleColumns();
			
			Ext.each(columns, function(column, idx) {
				if(column.dataIndex && column.dataIndex == 'DIV_CODE')	{
					columnIndex = idx;
				}
			});
			
			navi.setPosition(rowIndex, columnIndex);
		}
	
	},
	
	/**
	 * 관리항목 Dynamic field 특수 문자 key event 에서 사용
	 * @param field
	 * @param e
	 * @param dataMap
	 */
	onSpecialKey: function (elm, e, dataMap){
		var form = elm.up('form');
		switch( e.getKey() ) {
            case Ext.EventObjectImpl.ENTER:
            	if(elm && elm.getXType() == 'uniCombobox')	{
            		if(elm.isExpanded)	{
            			e.stopEvent();
            			var picker = elm.getPicker();
            			if(picker)	{
            				var view = picker.selectionModel.view;
            				if(view && view.highlightItem)	{
            					picker.select(view.highlightItem);
            				}
            			}
    
            		} else {
            			if(Ext.isEmpty(elm.getValue()) 
            				&& form.activeRecord.phantom 
            				&& !Ext.isEmpty(form.prevRecord) 
            				&& form.prevRecord.get('AC_DAY') == form.activeRecord.get('AC_DAY')
            				&& form.prevRecord.get('SLIP_NUM') == form.activeRecord.get('SLIP_NUM')
            				&& !Ext.isEmpty(form.prevRecord.get('ACCNT')) 
            				&& !Ext.isEmpty(form.activeRecord.get('ACCNT')) 
            				&& form.prevRecord.get('ACCNT') == form.activeRecord.get('ACCNT') ) 
            			{
            					elm.setValue(form.prevRecord.get(elm.name))
            			}
            			if(e.shiftKey && !e.ctrlKey && !e.altKey) {
	                		Unilite.focusPrevField(elm, true, e);
	                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
	                		UniAccnt.focusNextField(elm, true, e,dataMap);
	                	}
            		}
            	}else {
            		if(Ext.isEmpty(elm.getValue()) 
        				&& form.activeRecord.phantom 
        				&& !Ext.isEmpty(form.prevRecord) 
        				&& form.prevRecord.get('AC_DAY') == form.activeRecord.get('AC_DAY')
        				&& form.prevRecord.get('SLIP_NUM') == form.activeRecord.get('SLIP_NUM')
        				&& !Ext.isEmpty(form.prevRecord.get('ACCNT')) 
        				&& !Ext.isEmpty(form.activeRecord.get('ACCNT')) 
        				&& form.prevRecord.get('ACCNT') == form.activeRecord.get('ACCNT') ) 
            		{
            			elm.setValue(form.prevRecord.get(elm.name))
            		}
                	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
                		Unilite.focusPrevField(elm, true, e);
                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
                		UniAccnt.focusNextField(elm, true, e,dataMap);
                	}
            	}
            	break;
             case Ext.EventObjectImpl.TAB:
            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
            		Unilite.focusPrevField(elm, false, e);
            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
            		Unilite.focusNextField(elm, false, e);
            	}
            	break;
            case Ext.EventObjectImpl.LEFT:
            	//console.log('getCaretPosition()->' + elm.getCaretPosition(elm));
            	var pos = elm.getCaretPosition(elm);
            	if(pos < 1) {
            		Unilite.focusPrevField(elm, false, e);
            	}
            	break;
            case Ext.EventObjectImpl.RIGHT:
            	//console.log('getCaretPosition()->' + elm.getCaretPosition(elm));
            	var pos = elm.getCaretPosition(elm);
            	var len = 0;
            	if(Ext.isFunction(elm.getRawValue)) {
            		len = (Ext.isEmpty(elm.getRawValue()) ? 0 : (typeof(elm.getRawValue()) === "string" ?  elm.getRawValue().length : 0));
            	}
            	if(pos >= len) {
            		Unilite.focusNextField(elm, false, e);
            	}
            	break;	
  		}      		
 	},
 	
	changeFields : function( form, dataMap, otherForm )	{		
		var acCode, acName, acType, acPopup, acLen, acFormat;
		form.down('#formFieldArea1').removeAll();
		
		acCode   = dataMap['AC_CD'];			//동적팝업 change key            
		acName   = dataMap['AC_NAME'];			//팝업타이틀 및 컬럼헤더 용도            
		acType   = dataMap['DT_TYPE'];			//데이타 타입 - 문자 A: 일자: D 숫자: N 
		acPopup  = dataMap['DT_POPUP']; 		//팝업 사용 유무                   
		acLen    = dataMap['DT_LEN'];			//데이터maxLength               
		acFormat = dataMap['DT_FMT'];			//데이터 타입 숫자일시 포맷팅		
		if(acPopup == "Y"){
			//FR 필드			
			var frField = UniAccnt.makeItem(acCode, acName, '', '', acType, acPopup, acLen, '', acFormat, 'frField', form, otherForm,{'USE_YN':''});
			if(Ext.isEmpty(frField.fieldLabel)) return false;
			//			if (form.layout.columns > 1) frField.width = 350;
			form.down('#formFieldArea1').add(frField);
			var popupField = form.down('#' + dynamicId +(cnt-1));
			if(frField.usePopup == 'common'){
				popupField.DBvalueFieldName 			= 'COMMON_CODE';
				popupField.DBtextFieldName 			= 'COMMON_NAME';
//				popupField.valueFieldName 				= 'DYNAMIC_CODE_FR';
//				popupField.textFieldName 				= 'DYNAMIC_NAME_FR';
				popupField.api 						= 'popupService.commonPopup';
				popupField.app 						= 'Unilite.app.popup.CommonPopup';
				popupField.pageTitle					= acName;
				popupField.popupWidth					= 579;
				popupField.popupHeight					= 407;
				popupField.extParam.useyn				= '';
				popupField.extParam.HEADER   			= acName;
				popupField.extParam.BSA_CODE			= frField.fieldBsaCode
				popupField.setFieldLabel(acName);	
				var proxy = popupField.store.getProxy();	
				proxy.setConfig('api', {read: popupService.commonPopup });	//proxy set
			
			}else if(frField.usePopup == 'userDefine'){
				popupField.DBvalueFieldName 		= 'USER_DEFINE_CODE';
				popupField.DBtextFieldName 		= 'USER_DEFINE_NAME';
//				popupField.valueFieldName 			= 'DYNAMIC_CODE_FR';
//				popupField.textFieldName 			= 'DYNAMIC_NAME_FR';
				popupField.api 					= 'popupService.userDefinePopup';
				popupField.app 					= 'Unilite.app.popup.UserDefinePopup';
				popupField.pageTitle				= acName;
				popupField.popupWidth				= 725;
				popupField.popupHeight				= 455;
				popupField.extParam.useyn			= '';
				popupField.extParam.AC_CD	 		= acCode;
				popupField.extParam.HEADER  		= acName;
				popupField.setFieldLabel(acName);
				var proxy = popupField.store.getProxy();
				proxy.setConfig('api', {read: popupService.userDefinePopup });
			}
			
			//TO 필드
			var toField = UniAccnt.makeItem(acCode, acName, '', '', acType, acPopup, acLen, '', acFormat, 'toField', form, otherForm,{'USE_YN':''});			
			if(Ext.isEmpty(toField.fieldLabel)) return false;
			form.down('#formFieldArea1').add(toField);
			if(toField.usePopup == 'common'){
				popupField.DBvalueFieldName 			= 'COMMON_CODE';
				popupField.DBtextFieldName 			= 'COMMON_NAME';
//				popupField.valueFieldName 				= 'DYNAMIC_CODE_TO';
//				popupField.textFieldName 				= 'DYNAMIC_NAME_TO';
				popupField.api 						= 'popupService.commonPopup';
				popupField.app 						= 'Unilite.app.popup.CommonPopup';
				popupField.pageTitle					= acName;
				popupField.popupWidth					= 579;
				popupField.popupHeight					= 407;
				popupField.extParam.useyn				= '';
				popupField.extParam.HEADER   			= acName;
				popupField.extParam.BSA_CODE			= toField.fieldBsaCode
				popupField.setFieldLabel('~');	
				var proxy = popupField.store.getProxy();	
				proxy.setConfig('api', {read: popupService.commonPopup });	//proxy set
			
			}else if(toField.usePopup == 'userDefine'){
				popupField.DBvalueFieldName 		= 'USER_DEFINE_CODE';
				popupField.DBtextFieldName 		= 'USER_DEFINE_NAME';
//				popupField.valueFieldName 			= 'DYNAMIC_CODE_TO';
//				popupField.textFieldName 			= 'DYNAMIC_NAME_TO';
				popupField.api 					= 'popupService.userDefinePopup';
				popupField.app 					= 'Unilite.app.popup.UserDefinePopup';
				popupField.pageTitle				= acName;
				popupField.popupWidth				= 725;
				popupField.popupHeight				= 455;
				popupField.extParam.useyn				= '';
				popupField.extParam.AC_CD	 		= acCode;
				popupField.extParam.HEADER  		= acName;
				popupField.setFieldLabel('~');
				var proxy = popupField.store.getProxy();
				proxy.setConfig('api', {read: popupService.userDefinePopup });
			}
			
		}else{
			var frField = UniAccnt.makeItem(acCode, acName, '', '', acType, acPopup, acLen, '', acFormat, 'frField', form, otherForm);
			if(Ext.isEmpty(frField.fieldLabel)) return false;
			form.down('#formFieldArea1').add(frField);
			var toField = UniAccnt.makeItem(acCode, acName, '', '', acType, acPopup, acLen, '', acFormat, 'toField', form, otherForm);
			if(Ext.isEmpty(toField.fieldLabel)) return false;
			form.down('#formFieldArea1').add(toField);
		}
	},
 	
	changeOneField : function( form, dataMap, otherForm )	{		
		var acCode, acName, acType, acPopup, acLen, acFormat;
		form.down('#formFieldArea1').removeAll();
		
		acCode   = dataMap['AC_CD'];			//동적팝업 change key            
		acName   = dataMap['AC_NAME'];			//팝업타이틀 및 컬럼헤더 용도            
		acType   = dataMap['DT_TYPE'];			//데이타 타입 - 문자 A: 일자: D 숫자: N 
		acPopup  = dataMap['DT_POPUP']; 		//팝업 사용 유무                   
		acLen    = dataMap['DT_LEN'];			//데이터maxLength               
		acFormat = dataMap['DT_FMT'];			//데이터 타입 숫자일시 포맷팅		
		if(acPopup == "Y"){
			//FR 필드			
			var frField = UniAccnt.makeItem(acCode, acName, '', '', acType, acPopup, acLen, '', acFormat, 'frField', form, otherForm);
			if(Ext.isEmpty(frField.fieldLabel)) return false;
			//			if (form.layout.columns > 1) frField.width = 350;
			form.down('#formFieldArea1').add(frField);
			var popupField = form.down('#' + dynamicId +(cnt-1));
			if(frField.usePopup == 'common'){
				popupField.DBvalueFieldName 			= 'COMMON_CODE';
				popupField.DBtextFieldName 				= 'COMMON_NAME';
//				popupField.valueFieldName 				= 'DYNAMIC_CODE_FR';
//				popupField.textFieldName 				= 'DYNAMIC_NAME_FR';
				popupField.api 							= 'popupService.commonPopup';
				popupField.app 							= 'Unilite.app.popup.CommonPopup';
				popupField.pageTitle					= acName;
				popupField.popupWidth					= 579;
				popupField.popupHeight					= 407;
				popupField.extParam.HEADER   			= acName;
				popupField.extParam.BSA_CODE			= frField.fieldBsaCode
				popupField.setFieldLabel(acName);	
				var proxy = popupField.store.getProxy();	
				proxy.setConfig('api', {read: popupService.commonPopup });	//proxy set
			
			}else if(frField.usePopup == 'userDefine'){
				popupField.DBvalueFieldName 		= 'USER_DEFINE_CODE';
				popupField.DBtextFieldName 			= 'USER_DEFINE_NAME';
//				popupField.valueFieldName 			= 'DYNAMIC_CODE_FR';
//				popupField.textFieldName 			= 'DYNAMIC_NAME_FR';
				popupField.api 						= 'popupService.userDefinePopup';
				popupField.app 						= 'Unilite.app.popup.UserDefinePopup';
				popupField.pageTitle				= acName;
				popupField.popupWidth				= 725;
				popupField.popupHeight				= 455;
				popupField.extParam.AC_CD	 		= acCode;
				popupField.extParam.HEADER  		= acName;
				popupField.setFieldLabel(acName);
				var proxy = popupField.store.getProxy();
				proxy.setConfig('api', {read: popupService.userDefinePopup });
			}

		}else{
			var frField = UniAccnt.makeItem(acCode, acName, '', '', acType, acPopup, acLen, '', acFormat, 'frField', form, otherForm);
			if(Ext.isEmpty(frField.fieldLabel)) return false;
			form.down('#formFieldArea1').add(frField);
		}
	},
	
	setDynamicPopup : function( field, form, acCode, acName )	{
		var popupField = form.down('#' + dynamicId +(cnt-1));
		if(field.usePopup == 'common'){
			popupField.DBvalueFieldName 			= 'COMMON_CODE';
			popupField.DBtextFieldName 			= 'COMMON_NAME';
			popupField.api 						= 'popupService.commonPopup';
			popupField.app 						= 'Unilite.app.popup.CommonPopup';
			popupField.pageTitle					= acName;
			popupField.popupWidth					= 579;
			popupField.popupHeight					= 407;
			//popupField.extParam.HEADER   			= acName;
			//popupField.extParam.BSA_CODE			= field.fieldBsaCode
			popupField.setFieldLabel(acName);	
			var proxy = popupField.store.getProxy();	
			proxy.setConfig('api', {read: popupService.commonPopup });	//proxy setㅑ
		
		}else if(field.usePopup == 'userDefine'){
			popupField.DBvalueFieldName 		= 'USER_DEFINE_CODE';
			popupField.DBtextFieldName 		= 'USER_DEFINE_NAME';
			popupField.api 					= 'popupService.userDefinePopup';
			popupField.app 					= 'Unilite.app.popup.UserDefinePopup';
			popupField.pageTitle				= acName;
			popupField.popupWidth				= 725;
			popupField.popupHeight				= 455;
			//popupField.extParam.AC_CD	 		= acCode;
			//popupField.extParam.HEADER  		= acName;
			popupField.setFieldLabel(acName);
			var proxy = popupField.store.getProxy();
			proxy.setConfig('api', {read: popupService.userDefinePopup });
		}
	},
	removeField : function(form, otherForm){
		
		if(form.down('#formFieldArea2')){
			form.down('#formFieldArea1').removeAll();
			form.down('#formFieldArea2').removeAll();
			if(!otherForm) return false; 
			otherForm.down('#formFieldArea1').removeAll();
			otherForm.down('#formFieldArea2').removeAll();
		}else{
			form.down('#formFieldArea1').removeAll();
			if(!otherForm) return false; 
			otherForm.down('#formFieldArea1').removeAll();
		}
	},
	
	fnGetExistSlipNum: function(fnCallback, record, sGubun, sDate, sNum, oldNum)	{
		var sStr = []
		var fSDate = Ext.isDate(sDate) ? UniDate.getDateStr(sDate) : sDate;
		if(fSDate && fSDate.indexOf(':') > -1) {
			sStr = fSDate.split(":");
		}
		var slipType ;
		if(sStr != null && sStr.length == 2)	{
			fSDate = sStr[0];
			slipType = sStr[1]
		}
		var param = {
			'GUBUN': sGubun,
			'SDATE': fSDate,
			'SNUM':sNum
		}
		if(slipType)	{
			param.SLIP_TYPE = slipType;
		}
		Ext.getBody().mask();
		accntCommonService.fnGetExistSlipNum(param, function(provider, response) {	
			var rRecord = record;
			var rOldNum = oldNum;
			var rSNum = sNum;
			fnCallback.call(this, provider, null, rSNum, rOldNum, rRecord);
			Ext.getBody().unmask();
		})
	}
	
	,fnGetAccntBasicInfo: function(fnCallback,   sCol)	{		
		var param = {'COL': sCol}
		Ext.getBody().mask();
		accntCommonService.fnGetAccntBasicInfo_a(param, function(provider, response) {			
			fnCallback.call(this, provider);
			Ext.getBody().unmask();
		})
	}
	,fnIsCostAccnt:function(accnt, isMasked)	{
		if(!isMasked) Ext.getBody().mask();
		// 회계기준설정으로부터 '경비계정의 대변입력시 메세지처리 여부' 설정값을 읽어온다.  
		
    	accntCommonService.fnIsCostAccnt({'ACCNT_CD':accnt}, function(provider, response){
    		var accnt_cd = accnt;
    		if( provider && provider.length > 0 && provider.MSG != "" ) {
    			Unilite.messageBox(provider.MSG);
    		}else if(provider)	{
    			for(var i=0; i < provider.length; i++)	{
	    			if(accnt_cd >= provider[i].START.ACCNT && sAccnt <= provider[i].END.ACCNT)	{
	    				Unilite.messageBox(Msg.sMA0310)
	    				if(!isMasked)	{
			    			Ext.getBody().unmask();
			    		}
	    				return;
	    			}
    			}
    		}
    		if(isMasked)	{
    			Ext.getBody().unmask();
    		}
    	})
		
	},
	fnGetNoteAmt:function(fnCallback,noteNum, dOcAmtI, dJAmtI, profKind, newValue, oldValue, record , fieldName)	{
		// taxRate도 함계 가져옴, callback function에서 이용가능.
		Ext.getBody().mask();
		accntCommonService.fnGetNoteAmt({'NOTE_NUM':noteNum, 'PROOF_KIND': profKind}, function(provider, response){
			var r ;
			if(!Ext.isEmpty(provider))	{
				r = {'NOTE_AMT':1, 'OC_AMT_I':provider.OC_AMT_I, 'J_AMT_I':provider.J_AMT_I, 'TAX_RATE':provider.TAX_RATE};
			} else {
				r = {'NOTE_AMT':0, 'OC_AMT_I':dOcAmtI, 'J_AMT_I':dJAmtI};
			}
			fnCallback.call(this, r, newValue, oldValue, record, fieldName);
			Ext.getBody().unmask();
			
		})
	},
	fnGetTaxRate:function(fnCallback,record)	{
		var profKind = record.get('PROOF_KIND');
		if(profKind)	{
			Ext.getBody().mask();
			accntCommonService.fnGetTaxRate({'PROOF_KIND':profKind}, function(provider, response) {
				fnCallback.call(this, provider.TAX_RATE, record);
				Ext.getBody().unmask();
				
			})
		}
	}
	,
	fnGetBillDivCode:function(fnCallback,record, newValue)	{
		var divCode = newValue !=null ? newValue:record.get('DIV_CODE');
		if(divCode)	{
			Ext.getBody().mask();
			accntCommonService.fnGetBillDivCode({'DIV_CODE':divCode}, function(provider, response) {
				if(provider)	{
					fnCallback.call(this, provider.BILL_DIV_CODE, record);
				}
				Ext.getBody().unmask();
				
			})
		}
	},
	isNumberString:function(str)	{
		var numStr = "0123456789";
		if(str != null)	{
			for(var i=0; i< str.length; i++)	{
				if(numStr.indexOf(str.substring(i,1)) < 0)	{
					Unilite.messageBox(Msg.sMA0076);
					return false;
				}
			}
		}
		return true;
	},
	/**
	 * Combobox refcode 값 가져오기, 해당 공통코드는 페이지에 정의되어 있어야 함.
	 * @param {} param
	 * 	param = {
	 * 	'MAIN_CODE':'A001'
	 *  'SUB_CODE':'01'
	 *  'field':'refCode1'
	 *  'storeId':'CustomStore'
	 * }
	 * @return {}
	 */
	fnGetRefCode:function(param)	{
		var store ;
		if(param.storeId)	{
			store = Ext.StoreManager.lookup(param.storeId);
		}else {
			store = Ext.StoreManager.lookup("CBS_AU_"+param.MAIN_CODE);
		}
		var r ;
		if(store)	{
			var selRecordIdx = store.findBy(function(record){return (record.get("value") == param.SUB_CODE)});
			if(selRecordIdx > -1){
				var selRecord = store.getAt(selRecordIdx);
				if(param.field) r = selRecord.get(param.field);
			}
		}
		return r;
		
	},
	
	/**
	 * 공통코드의 grid hidden column 용 팝업
	 * @comCodeWin :전역변수로 선언된 window 
	 * @returnRecord : 입력중인 grid record
	 * @codeColumnName : 공통코드값 필드명
	 * @nameColumnName : 공통코드명 필드명
	 * @title : window title
	 * @comboType 
	 * @comboCode
	 * @rdoType : 'VALUE', 'TEXT'
	 */
	comCodePopup: function (comCodeWin, returnRecord, codeColumnName, nameColumnName ,title, comboType, comboCode, rdoType)	{ 

	    if(!comCodeWin) {
	    		Unilite.defineModel('comCodeModel', {
				    fields: [
								 { name: 'value'			, text:'코드' 		,type : 'string' } 
								,{ name: 'text'		, text:'코드명' 	,type : 'string' } 
								,{ name: 'refCode1'		, text:'참조1' 	,type : 'string' } 
								,{ name: 'refCode2'		, text:'참조2' 	,type : 'string' } 
								,{ name: 'refCode3'		, text:'참조3' 	,type : 'string' } 
								,{ name: 'refCode4'		, text:'참조4' 	,type : 'string' } 
								,{ name: 'refCode5'		, text:'참조5' 	,type : 'string' } 
								,{ name: 'refCode6'		, text:'참조6' 	,type : 'string' } 
								,{ name: 'refCode7'		, text:'참조7' 	,type : 'string' } 
								,{ name: 'refCode8'		, text:'참조8' 	,type : 'string' } 
								,{ name: 'refCode9'		, text:'참조9' 	,type : 'string' } 
								,{ name: 'refCode10'		, text:'참조10' 	,type : 'string' } 
							]
				});
	    		var comCodeStore = Unilite.createStore('comCodeStore', {
						model: 'comCodeModel'  
						//,data : Ext.data.StoreManager.lookup('CBS_'+comboType+'_'+comboCode).data.items
			            ,loadStoreRecords : function()	{
							var param= comCodeWin.down('#comCodeSearch').getValues();	
							var store = Ext.data.StoreManager.lookup('CBS_'+comCodeWin.comboType+'_'+comCodeWin.comboCode);
							var data = [];
							if(param.TXT_SEARCH)	{
								data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('value')== param.TXT_SEARCH || record.get('text').indexOf(param.TXT_SEARCH) > -1) } ).items);
							} else {
								data = store.data.items
							}
							this.loadData(data);				
						}
				});
	    
				comCodeWin = Ext.create('widget.uniDetailWindow', {
	                title: title,
	                width: 400,				                
	                height:400,
	            	'returnRecord':returnRecord,
	            	'comboType':comboType,
	            	'comboCode':comboCode,
	            	'codeColumnName':codeColumnName,
	            	'nameColumnName':nameColumnName,
	            	'rdoType':rdoType,
	                layout: {type:'vbox', align:'stretch'},	                
	                items: [{
		                	itemId:'comCodeSearch',
		                	xtype:'uniSearchForm',
		                	layout:{type:'uniTable',columns:2},
		                	items:[
		                		{	
		                			fieldLabel:'검색어',
		                			labelWidth:60,
		                			name :'TXT_SEARCH',
		                			width:250
		                		},{
		                			
		                			hideLabel:true,
		                			xtype: 'radiogroup',
		                			width: 150,
								 	items:[	{inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: true},
								 			{inputValue: '2', boxLabel:'이름순',  name: 'RDO'} 
								 	]
		                		}
		                		
		                	]
	               		},
						Unilite.createGrid('', {
							itemId:'comCodeGrid',
					        layout : 'fit',
					    	store: comCodeStore,
					    	selModel:'rowmodel',
							uniOpt:{
					        	onLoadSelectFirst : false
					        },
					        columns:  [  
					        		 {dataIndex:'value'	, width:100}
					        		,{dataIndex:'text'	, flex:1}
					        ]
					         ,listeners: {	
					          		onGridDblClick:function(grid, record, cellIndex, colName) {
					  					grid.ownerGrid.returnData();
					  					comCodeWin.hide();
					  				}
					       		}
					       	,returnData: function()	{
					       		var record = this.getSelectedRecord();  
					       		if(!Ext.isEmpty(record)){
    					       		if(comCodeWin.codeColumnName)	{
    					       			comCodeWin.returnRecord.set(comCodeWin.codeColumnName, record.get("value"))
    					       		}
    					       		if(comCodeWin.nameColumnName)	{
    					       			comCodeWin.returnRecord.set(comCodeWin.nameColumnName, record.get("text"))
    					       		}
					       		}
					       	}
					       	
						})
					       
					],
	                tbar:  [
	               		 {
							itemId : 'searchtBtn',
							text: '조회',
							handler: function() {
								var form = comCodeWin.down('#comCodeSearch');
								var store = Ext.data.StoreManager.lookup('comCodeStore')
								comCodeStore.loadStoreRecords(form,  comCodeWin.comboType, comCodeWin.comboCode);
							},
							disabled: false
						},
				         '->',{
							itemId : 'submitBtn',
							text: '확인',
							handler: function() {
								comCodeWin.down('#comCodeGrid').returnData()
								comCodeWin.hide();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								comCodeWin.hide();
							},
							disabled: false
						}
				    ],
					listeners : {beforehide: function(me, eOpt)	{
									comCodeWin.down('#comCodeSearch').clearForm();
	                			},
	                			 beforeclose: function( panel, eOpts )	{
									comCodeWin.down('#comCodeSearch').clearForm();
	                			},
	                			 show: function( panel, eOpts )	{
									var form = comCodeWin.down('#comCodeSearch');
									form.setValue('TXT_SEATCH', comCodeWin.returnRecord.get(comCodeWin.nameColumnName));
									if(comCodeWin.rdoType == "TEXT") {
										form.setValue('RDO', '2');
	                			 	}else {
	                			 		form.setValue('RDO', '1');
	                			 	}
									Ext.data.StoreManager.lookup('comCodeStore').loadStoreRecords();
	                			 }
	                }		
				});
	    }	
	    comCodeWin.returnRecord = returnRecord;
	    
	    comCodeWin.codeColumnName = codeColumnName; 
	    comCodeWin.nameColumnName = nameColumnName;
		comCodeWin.comboType = comboType; 
		comCodeWin.comboCode = comboCode;
		comCodeWin.rdoType = rdoType;
		comCodeWin.center();		
		comCodeWin.show();
		return comCodeWin;
	},
	
	 /**	Unilite : fnRound 함수
     * Excel round / roundup / rounddown 함수 
     * roundup 과 rounddown은 ceil과 floor와 약간 다름 
     * roundup : 0 에서 먼 수
     * rounddown : 0 에서 가까운 수
     * 음수 round의 경우 abs 기준 round 사용 !!! 즉 -3.5 는 -4 임.
     * @param {number} dAmount
     * @param {String} sUnderCalBase 1: roundup, 2:rounddown, 기타 : round
     * @param {Integer} numDigit
     */
    fnAmtWonCalc: function(dAmt, sAmtPoint, numDigit)	{
			var absAmt = 0, wasMinus = false;
			var numDigit = (numDigit == undefined) ? 0 : numDigit ;
			
			if( dAmt >= 0 ) {
				absAmt = dAmt;
			} else {
				absAmt = Math.abs(dAmt);
				wasMinus = true;
			}
			
			if(sAmtPoint && typeof sAmtPoint == "number")	{
				sAmtPoint = sAmtPoint.toString();
			}
			
			var mn = Math.pow(10,numDigit);
			switch (sAmtPoint) {
				case  "1" : //cut : 0에서 가까와짐, 아래 자리수 버림.
					absAmt = Math.floor(absAmt * mn) / mn;
					break;	
				case  "2" :	//up : 0에서 멀어짐.
					absAmt = Math.ceil(absAmt * mn) / mn;
					break;
				default:						//round
					absAmt = Math.round(absAmt * mn) / mn;
			}
			// 음수 였다면 -1을 곱하여 복원.
			return (wasMinus) ? absAmt * (-1) : absAmt;

    }
    
    ,getAcCodeEditor:function(record, config, fieldConfig)	{
    	var editField = UniAccnt.setColumnEditor(record, config);
    	var editor = Ext.create('Ext.grid.CellEditor', {
        	ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
			autoCancel : false,
			selectOnFocus:true,
            field: editField
            //(record.get("BOOK_CODE_NAME1") == "은행코드")? {xtype:'uniNumberfield', decimalPrecision: 3}:{xtype:'uniDatefield', format: Unilite.dateFormat }
        });
        return editor;
    },
    
    
    setColumnEditor: function(record, config) {
		if(! Ext.isDefined(record) && ! Ext.isDefined(record.get("ACCNT")) ) {
			return null;
		}
		var fNPrefix = config.fieldInfo.prefix , fnIndex = config.fieldInfo.index;
		var	fName= 		Ext.isDefined(config.fieldInfo.data) 		? config.fieldInfo.data 		:fNPrefix+"_DATA"		+fnIndex,//입력될 데이타의 코드	
			fDataName= 	Ext.isDefined(config.fieldInfo.dataName) 	? config.fieldInfo.dataName 	:fNPrefix+"_DATA_NAME"	+fnIndex;//입력될 데이타의 이름		
		var acCode = 	record.get(Ext.isDefined(config.fieldInfo.code) 		? config.fieldInfo.code 		:fNPrefix+"_CODE"		+fnIndex),//관리항목코드
			acName= 	record.get(Ext.isDefined(config.fieldInfo.name) 		? config.fieldInfo.name 		:fNPrefix+"_CODE_NAME"	+fnIndex),//관리항목명
			acType= 	record.get(Ext.isDefined(config.fieldInfo.type) 		? config.fieldInfo.type 		:fNPrefix+"_TYPE"		+fnIndex),//타입(A/N/D : 문자타입/숫자타입/날짜타입) 
			acPopup= 	record.get(Ext.isDefined(config.fieldInfo.popup) 		? config.fieldInfo.popup 		:fNPrefix+"_POPUP"		+fnIndex),//팝업여부(Y/N)
			acLen= 		record.get(Ext.isDefined(config.fieldInfo.maxLangth) 	? config.fieldInfo.maxLangth 	:fNPrefix+"_LEN"		+fnIndex),//데이타 길이
			acCtl= 		record.get(Ext.isDefined(config.fieldInfo.allowBlank)	? config.fieldInfo.allowBlank 	:fNPrefix+"_CTL"		+fnIndex),//필수여부
			acFormat= 	record.get(Ext.isDefined(config.fieldInfo.format) 	 	? config.fieldInfo.format 		:fNPrefix+"_FORMAT"		+fnIndex),//데이타포멧
			
			extParam,
				
			bankBook,	bankBookNm ,
			aBankCd,	aBankNm,
			aCustCd,	aCustNm,
			aExpDate,
			aPubDate;
				
		
					   
		var lAllowBlank = (record.get(config.fieldInfo.allowBlank) == 'Y') ? false : true;
		
		var field = {'allowBlank' : lAllowBlank};
				
		if(acPopup == "Y")	{
			field = this.getPopupFieldForGrid(field, record, fName, fDataName, acCode, fNPrefix, config.isNameField);
		}else {
		
			var fieldType = UniAccnt.getFieldType(acType);
			
			if(acType) {
				var editListeners = {};
				
				if(record.get(config.fieldInfo.maxLength)) {
					Ext.applyIf(field, {'maxLength': record.get(config.fieldInfo.maxLength), 'enforceMaxLength': record.get(config.fieldInfo.maxLength) });
				}
				
				Ext.applyIf(field, {xtype : fieldType});
				if( acType ==  'N') {
					var muduleFormat = UniFormat[config.format.replace('uni','')];
					var deP = muduleFormat.indexOf('.') > -1 ? muduleFormat.length-1 - muduleFormat.indexOf('.') : 0;
					Ext.applyIf(field, { decimalPrecision:config.format, maxLength:deP==0? 39:46, enforceMaxLength: deP==0? 39:46});
				} else if( acType ==  'D') {
					Ext.applyIf(col, {align: 'center', xtype: 'uniDateColumn' });
					Ext.applyIf(field, {
						xtype : 'uniDatefield',
					    format: Unilite.dateFormat 
					 });
				} 
			} 
		}
		return field;
		
	},
	
	getFieldType : function(acType)	{
				var type = acType;
				if(type == 'N' )	return 'uniNumberfield'
				else if(type == 'D' )	return 'uniDatefield'
	    		else return 'textfield'		
	},
	
	getPopupFieldForGrid : function(field, record, fName, fDataName, acCode, fNPrefix, isNameField)	{
		var dbFName = isNameField ?  fDataName : fName , dbFDataName = isNameField ? fName : fDataName  ;
		var extParam = {};
		if(acCode=='O1')	{		//통장팝업
			extParam = {'ACCNT':record.get('ACCNT')};
		}
		if(record)	{
			var bankBookIdx = this.findAcCodeByPrefix(record, "O2", fNPrefix);
		    aBankBookColNm = fNPrefix+"_DATA"+bankBookIdx;
		    aBankColNm = fNPrefix+"_DATA_NAME"+bankBookIdx;
		    
			var bankIdx = this.findAcCodeByPrefix(record, "A3", fNPrefix);
		    aBankCd = fNPrefix+"_DATA"+bankIdx;
		    aBankNm = fNPrefix+"_DATA_NAME"+bankIdx;
		     
		    var custIdx = this.findAcCodeByPrefix(record, "A4", fNPrefix);
		    aCustCd = fNPrefix+"_DATA"+custIdx;
		    aCustNm = fNPrefix+"_DATA_NAME"+custIdx;
		   
		    var expDateIdx = this.findAcCodeByPrefix(record, "C3", fNPrefix);
		    aExpDate = fNPrefix+"_DATA"+expDateIdx;
		    
		    var pubDateIdx = this.findAcCodeByPrefix(record, "C4", fNPrefix);
    		aPubDate = fNPrefix+"_DATA"+pubDateIdx;
		}
				
			switch(acCode)	{
    			case 'A2': Ext.apply(field, Unilite.popup('DEPT_G',{ valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["TREE_CODE"]);editRecord.set(dbFDataName, records[0]["TREE_NAME"]);}, scope: this}, onClear: function(type){var editRecord = record;}}}));		//부서
    				break;
    			case 'A3': Ext.apply(field, Unilite.popup('BANK_G',{valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["BANK_CODE"]);editRecord.set(dbFDataName, records[0]["BANK_NAME"]);}, scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');}}}));		//은행
    				break;
    			case 'A4': Ext.apply(field, 
    					   		Unilite.popup('CUST_G',{
	    					   		valueFieldName: fName, 
	    					   		textFieldName: fDataName, 
	    					   		extParam:{"CUSTOM_TYPE":['1','2','3']},
	    					   		listeners: {
	    					   			'onSelected': { 
	    					   				fn: function(records, type) {
	    					   					var editRecord = record; 
	    					   					editRecord.set(dbFName, records[0]["CUSTOM_CODE"]);
												editRecord.set(dbFDataName, records[0]["CUSTOM_NAME"]);	
												
	    					   					var bankBookColNm = aBankBookColNm, bankColNm = aBankColNm;
	    					   					if(!Ext.isEmpty(bankBookColNm))	{
	    					   						
	    					   						editRecord.set(bankBookColNm, records[0].BANKBOOK_NUM);	 
	    					   						editRecord.set(bankColNm, records[0].BANK_NAME);	
	    					   					}
	    					   				}, 
	    					   				scope: this}, 
	    					   			'onClear': function(type){
	    					   				var editRecord = record; 
	    					   				editRecord.set(dbFName, '');
	    					   				var bankBookColNm = aBankBookColNm, bankColNm = aBankColNm;;
	    					   				if(!Ext.isEmpty(bankBookColNm))	{
	    					   						record.set(bankBookColNm, "");	    
	    					   						record.set(bankColNm, "");	
	    					   				}
	    					   			}
	    					   		}
    					   		})
    					   	);		//거래처
    				break;
    			case 'A6': Ext.apply(field, Unilite.popup('Employee_G',{valueFieldName: fName, textFieldName: fDataName, 	listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["PERSON_NUMB"]);editRecord.set(dbFDataName, records[0]["NAME"]);}, 		scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}}));	//사번
    				break;
    			case 'A7': Ext.apply(field, Unilite.popup('CUST_G',{ valueFieldName: fName, textFieldName: fDataName, 		listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["CUSTOM_CODE"]);editRecord.set(dbFDataName, records[0]["CUSTOM_NAME"]);}, 		scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}}));			//예산코드
    				break;
    			case 'A9': Ext.apply(field, Unilite.popup('COST_POOL_G',{ valueFieldName: fName, textFieldName: fDataName, 	listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["COST_POOL_CODE"]);editRecord.set(dbFDataName, records[0]["COST_POOL_NAME"]);}, 	scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}}));			//Cost Pool
    				break;
    			case 'B1': Ext.apply(field, Unilite.popup('DIV_PUMOK_G',{ valueFieldName: fName, textFieldName: fDataName, 	listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["ITEM_CODE"]);editRecord.set(dbFDataName, records[0]["ITEM_NAME"]);}, 		scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}}));			//사업장별 품목팝업
    				break;
//    			case 'C2': Ext.apply(field, 
//    					   		Unilite.popup('NOTE_NUM_G',{
//    					   			 
//    					   			valueFieldName: fName, 
//    					   			textFieldName: fDataName, 
//    					   			listeners: {
//    					   				onSelected: { 
//    					   					fn: function(records, type){
//    					   						var editRecord = record; 
//	    					   					editRecord.set(dbFName, records[0]["NOTE_NUM_CODE"]);
//												editRecord.set(dbFDataName, records[0]["NOTE_NUM_NAME"]);	
//    					   						
//    					   						//var bankCd=aBankCd, bankNm=aBankNm, custCd=aCustCd, custNm=aCustNm, expDate=aExpDate;
//    					   						
//    					   						if(aBankCd) editRecord.set(aBankCd, records[0].BANK_CODE);
//    					   						if(aBankNm) editRecord.set(aBankNm, records[0].BANK_NAME);
//    					   						if(aCustCd) editRecord.set(aCustCd, records[0].CUSTOM_CODE);
//    					   						if(aCustNm) editRecord.set(aCustNm, records[0].CUSTOM_NAME);
//    					   						if(aExpDate) editRecord.set(aExpDate, records[0].EXP_DATE);
//    					   					}, 
//    					   					scope: this
//    					   				}
//    					   				, onClear: function(type){
//    					   					var editRecord = record; 
//	    					   					editRecord.set(dbFName, '');
//    					   					
//    					   					if(aBankCd) editRecord.set(aBankCd, "");
//					   						if(aBankNm) editRecord.set(aBankNm, "");
//					   						if(aCustCd) editRecord.set(aCustCd, "");
//					   						if(aCustNm) editRecord.set(aCustNm, "");
//					   						if(aExpDate) editRecord.set(aExpDate, "");
//    					   				}
//    					   			}
//    					   		})
//    					   	);			//어음번호
//    				break;
    			case 'C7':Ext.apply(field, 
    							Unilite.popup('CHECK_NUM_G',{
    								 
    								valueFieldName: fName, 
    								textFieldName: fDataName, 
    								listeners: {
    									onSelected: { 
    										fn: function(records, type){
    											var editRecord = record; 
	    					   					editRecord.set(dbFName, records[0]["CHECK_NUM_CODE"]);
												editRecord.set(dbFDataName, records[0]["CHECK_NUM_NAME"]);	
    											
    											if(aBankCd) editRecord.set(aBankCd, records[0].BANK_CODE);
    					   						if(aBankNm) editRecord.set(aBankNm, records[0].BANK_NAME);
    					   						if(aPubDate) editRecord.set(aPubDate, records[0].PUB_DATE);
    										}, 
    										scope: this
    									}, 
    									onClear: function(type){
    										var editRecord = record; 
	    					   					editRecord.set(dbFName, '');
    										
    										if(aBankCd) editRecord.set(aBankCd, "");
					   						if(aBankNm) editRecord.set(aBankNm, "");
					   						if(aPubDate) editRecord.set(aPubDate, "");
    									}
    								}
    							})
    						);			//수표번호
    				break;
    			case 'D5': Ext.apply(field, Unilite.popup('EX_LCNO_G',{ valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["EX_LCNO_CODE"]);editRecord.set(dbFDataName, records[0]["EX_LCNO_NAME"]);}, scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}}));			//L/C번호(수출)
    				break;
    			case 'D6': Ext.apply(field, Unilite.popup('IN_LCNO_G',{ valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["IN_LCNO_CODE"]);editRecord.set(dbFDataName, records[0]["IN_LCNO_NAME"]);}, scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}}));			//L/C번호(수입)
    				break;
    			case 'D7': Ext.apply(field, Unilite.popup('EX_BLNO_G',{ valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["EX_BLNO_CODE"]);editRecord.set(dbFDataName, records[0]["EX_BLNO_NAME"]);}, scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}}));			//B/L번호(수출)
    				break;
    			case 'D8': Ext.apply(field, Unilite.popup('IN_BLNO_G',{ valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["IN_BLNO_CODE"]);editRecord.set(dbFDataName, records[0]["IN_BLNO_NAME"]);}, scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}}));			//B/L번호(수입)
    				break;
    			case 'E1': Ext.apply(field, Unilite.popup('AC_PROJECT_G',{ valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["AC_PROJECT_CODE"]);editRecord.set(dbFDataName, records[0]["AC_PROJECT_NAME"]);}, scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}}));			//프로젝트
    				break;
    			case 'G5': Ext.apply(field, Unilite.popup('CREDIT_NO_G',{ valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["CREDIT_NO_CODE"]);editRecord.set(dbFDataName, records[0]["CREDIT_NO_NAME"]);}, scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}}));			//증빙유형
    				break;
    			case 'M1': Ext.apply(field, 
    							Unilite.popup('ASSET_G',{
    								 
    								valueFieldName: fName, 
    								textFieldName: fDataName, 
    								listeners: {
    									onSelected: { 
    										fn: function(records, type){
    											var editRecord = record; 
	    					   					editRecord.set(dbFName, records[0]["ASSET_CODE"]);
												editRecord.set(dbFDataName, records[0]["ASSET_NAME"]);	    					   					
    											
    											if(aBankCd) editRecord.set(aBankCd, records[0].BANK_CODE);
    					   						if(aBankNm) editRecord.set(aBankNm, records[0].BANK_NAME);
    					   						
    										}, 
    										scope: this
    									},
    									onClear: function(type){
    										var editRecord = record; 
	    					   					editRecord.set(dbFName, '');
    										
    										if(aBankCd) editRecord.set(aBankCd, "");
					   						if(aBankNm) editRecord.set(aBankNm, "");
					   						
    									}
    								}
    							})
    						);			//자산코드 
    				break;
    			case 'O1': Ext.apply(field, 
    							Unilite.popup('BANK_BOOK_G',{
    								
									valueFieldName: fName, textFieldName: fDataName, 
									listeners: {
										onSelected: { 
											fn: function(records, type){
												var editRecord = record; 
													editRecord.set(dbFName, records[0]["BANK_BOOK_CODE"]);
													editRecord.set(dbFDataName, records[0]["BANK_BOOK_NAME"]);
				
												editRecord.set(aBankCd, records[0].BANK_CD); 
												editRecord.set(aBankNm, records[0].BANK_NM); 
												
												
											},	
											scope: this
										}
									 , onClear: function(type){ 
									 			var editRecord = record; 
	    					   					editRecord.set(dbFName, '');
	    					   					
									 			editRecord.set(aBankCd, ''); 
									 			editRecord.set(aBankNm, '');
									 			
									 	}
									 ,applyExtParam:function(popup)	{
											popup.setExtParam(extParam);
									 
									 	}
									 }
									 
									 }));			//Deposit
    				break;
    			case 'P2': Ext.apply(field, Unilite.popup('DEBT_NO_G',{ valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["DEBT_NO_CODE"]);editRecord.set(dbFDataName, records[0]["DEBT_NO_NAME"]);}, scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}}));			//차입금번호
    				break;
    			  				
    			default:	//동적 팝업  (공통코드, 사용자 정의 팝업)
    				var bsaCode = '';
					if(UniUtils.indexOf(acCode, ["B5", "C0", "D2", "I4", "I5", "I7", "Q1", "A8"])){		//공통코드 팝업 생성						
						switch(acCode){
							case "B5" :
								bsaCode = 'B013'							
							break;
							case "C0" :
								bsaCode = 'A058'
							break;
							case "D2" :
								bsaCode = 'B004'
							break;
							case "I4" :
								bsaCode = 'A003'
							break;
							case "I5" :
								bsaCode = 'A022'
							break;
							case "I7" :
								bsaCode = 'A149'
							break;
							case "Q1" :
								bsaCode = 'A171'
							break;
							case "A8" :
								bsaCode = 'A170'
							break;
						}						
						
						Ext.apply(field, Unilite.popup('COMMON_G',{itemId: dynamicId+ cnt, fieldBsaCode: bsaCode, usePopup: 'common', valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["value"]);editRecord.set(dbFDataName, records[0]["text"]);}, scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}})); // 빈팝업 생성	DYNAMIC_CODE_TO	
						
						
						
					}else if(UniUtils.indexOf(acCode, ["R1", "Z0", "Z1", "Z2", "Z3", "Z4", "Z5", "Z6", "Z7", "Z8", "Z9",	//사용자 정의 팝업 생성
														   "Z10","Z11","Z12","Z13","Z14","Z15","Z16","Z17","Z18","Z19","Z20",
														   "Z21","Z22","Z23","Z24","Z25","Z26","Z27","Z28","Z29", "Z34", "Z35"])){				
						
						Ext.apply(field, Unilite.popup('USER_DEFINE_G',{itemId: dynamicId + cnt, usePopup: 'userDefine', valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){var editRecord = record; editRecord.set(dbFName, records[0]["value"]);editRecord.set(dbFDataName, records[0]["text"]);}, scope: this}, onClear: function(type){var editRecord = record; editRecord.set(dbFName, '');editRecord.set(fDataName, '');}}})); // 빈팝업 생성
						
					}
    				break;
    		}
    		return field;
			
	},
	
	//원화 절사 함수
	getCalWon: function(won)	{
		if(won != null && won != undefined)	{
			won = won * 10 - 5;
			won = Math.round(won/10);
		}
		return won;
	},
	
	fnRound:function(dAmt, sAmtPoint, sFormat)  {
	    var absAmt, dFloat;
	    var i = dAmt >= 0 ? 1 : -1;
	    var decimalPrecision = sFormat.indexOf('.') > -1 ? sFormat.length-1 - sFormat.indexOf('.'):0;
	    
	    absAmt = parseFloat(dAmt); 
	        switch(sAmtPoint)   {
	            case "1" :    //cut
	    			absAmt = Math.round(i*Math.abs(absAmt * Math.pow(10, decimalPrecision)-0.5))/Math.pow(10, decimalPrecision);
	                break;
	            case "2" :   //up
	                absAmt = Math.round(i*Math.abs(absAmt * Math.pow(10, decimalPrecision)+0.5))/Math.pow(10, decimalPrecision);
	                break;
	            default:
	                absAmt = Math.round(i*Math.abs(absAmt));
	                break;
	                
	        }
	    return absAmt;
   
 	}
    
}); 



