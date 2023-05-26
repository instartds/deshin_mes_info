<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mba032ukrv"  >	
	<t:ExtComboStore comboType="BOR120" /> 			<!-- 사업장 -->  
</t:appConfig>
<script type="text/javascript" >
///// 최종마감일이 없을시  rdo disabled처리 해야함 mba032ukrv.htm  283줄
function appMain() { 
	var gsMonth = '';
	var orgInfo = '';
	

	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '',		
        defaultType: 'uniSearchSubPanel',
//        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
//        listeners: {
//	        collapse: function () {
//	        	panelResult.show();
//	        },
//	        expand: function() {
//	        	panelResult.hide();
//	        }
//	    },        
	  	listeners: {
	  		afterrender: function( panel, eOpts ) {
	  			panel.expand();
	  		}
	  	},
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
           	defaults: {labelWidth: 115},
	    	items: [{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts){
						UniAppManager.app.fnSetArEnvironm(newValue);						
					}
				} 
			}, {
				xtype: 'uniTextfield',
				fieldLabel: ' ',
				name: 'ORG_INFO',
				readOnly: true
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '최종마감년월',
				name: 'END_DATE',
				readOnly: true,
				value: '0000.00',
				fieldStyle: 'text-align: center;'
			}, {
				xtype: 'uniMonthfield',
				fieldLabel: '이월작업년월',
				name: 'WORK_DATE',
				allowBlank: false
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '기초잔액반영년월',
				name: 'REAL_BASIS_DATE',
				readOnly: true,
				value: '0000.00',
				fieldStyle: 'text-align: center;'
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '최초잔액반영년월',
				name: 'BASIS_DATE',
				readOnly: true,
				value: '0000.00',
				fieldStyle: 'text-align: center;'
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '최종이월년월',
				name: 'AR_LAST_MONTH',
				readOnly: true,
				value: '0000.00',
				fieldStyle: 'text-align: center;'
			}, {
				xtype: 'uniMonthfield',
				fieldLabel: '이월작업년월날자포멧용..',
				name: 'TEMP_WORK_DATE',
				hidden: true
			}, {
				xtype: 'uniMonthfield',
				fieldLabel: '최종마감년월날자포멧용',
				name: 'TEMP_END_DATE',
				hidden: true
			}, {
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '작업선택',	
	    		id: 'rdo',
	    		name: 'CLOSED_RDO_YN',
	    		items: [{
	    			boxLabel: '마감',
	    			width: 80,
	    			name: 'CLOSED_YN',
	    			inputValue: 'F',
	    			checked: true
	    		}, {
	    			boxLabel: '취소',
	    			width: 80,
	    			name: 'CLOSED_YN',
	    			inputValue: 'B'
	    		}],
	    		listeners: {
					change: function(field, newValue, oldValue, eOpts){
						UniAppManager.app.fnChangeclosedYN(newValue);						
					}
				} 
	        },{
	        	xtype: 'uniTextfield',
	        	name: 'COMP_CODE',
	        	value: UserInfo.compCode,
	        	hidden: true	        	
	        },{
	        	xtype: 'uniTextfield',
	        	name: 'USER_ID',
	        	value: UserInfo.userID,
	        	hidden: true	        	
	        },{
	        	margin: '0 0 0 23',
				xtype: 'button',
				id: 'startButton',
				text: '실행',	
	        	width: 300,
	        	tdAttrs:{'align':'center'},							   	
				handler : function() {
					if(!panelSearch.setAllFieldsReadOnly(true)){
			    		return false;
			    	}
			    	var sWorkDt = UniDate.getDbDateStr(panelSearch.getValue('WORK_DATE')).substring(0, 6);
			    	sWorkDt = sWorkDt.substring(0,4) + '.' + sWorkDt.substring(4,6);
			    	var sBaseDate = panelSearch.getValue('BASIS_DATE');
			    	var sRealBaseDate = panelSearch.getValue('REAL_BASIS_DATE');
			    	if(!panelSearch.getValue('CLOSED_YN') && Ext.isEmpty(sRealBaseDate) &&
			    		(UniDate.getDbDateStr(sWorkDt).substring(0, 6) == sBaseDate) && 
			    		sBaseDate != "000000" && !Ext.isEmpty(sBaseDate)){
			    		if(!confirm(Msg.sMS367 + '\n' + Msg.sMS368 + '\n' + Msg.sMS369)){
			    			return false;	
			    		}
			    		
			    	}
			    	
					if(UniAppManager.app.fnDateDIffCal()){						
						var param = panelSearch.getValues();
						
						var endDate = panelSearch.getValue('END_DATE').replace('.','');
						var workDate = UniDate.getDbDateStr(panelSearch.getValue('WORK_DATE')).substring(0, 6);
						var basisDate = panelSearch.getValue('BASIS_DATE').replace('.','');
						param.END_DATE = endDate
						param.WORK_DATE = workDate
						param.BASIS_DATE = basisDate
						var me = this
						me.setDisabled(true);
						mba032ukrvService.insertMaster(param, function(provider, response)	{							
							UniAppManager.app.fnSetArEnvironm();
							
						me.setDisabled(false);
						});
						
					}
   				}
			}
//			, {
//				xtype: 'uniMonthfield',
//				fieldLabel: '월달력..',
//				name: 't1'
//			}, {
//				xtype: 'uniDatefield',
//				fieldLabel: '날달력..',
//				name: 't2'
//			}
			],		
		    setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});
	   				if(invalid.length > 0) {
						r=false;
	   					var labelText = ''
	   	
						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					}
		  		}
				return r;
	  		}	
   		}]
	});

    Unilite.Main({
		borderItems:[/*{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid1, panelResult
			]
		},*/
			panelSearch  	
		],
		id: 'mba032ukrvApp',
		fnInitBinding: function() {
//			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['query', 'detail', 'reset'],false);			
			panelSearch.setValue('WORK_DATE', UniDate.get('today'));
			panelSearch.getField("CLOSED_RDO_YN").setReadOnly(true);
			
//			panelSearch.setValue('t1', '201503');
//			panelSearch.setValue('t2', '20150302');
//			panelSearch.getValue('t1');
//			panelSearch.getValue('t2');
//			panelSearch.setValue('WORK_DATE', '201502');
//			alert(panelSearch.getValue('WORK_DATE'));
//			UniAppManager.app.fnSetArEnvironm();			
//			var combo 	= panelSearch.getField('ORDER_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);
			
		},
		fnSetArEnvironm: function(divCode){	//초기화, 사업장 변경시 폼에 각 날짜 set
			panelSearch.setValue('END_DATE', '');
//			panelSearch.setValue('WORK_DATE', '');
			panelSearch.setValue('BASIS_DATE', '');
			panelSearch.setValue('REAL_BASIS_DATE', '');
			panelSearch.setValue('AR_LAST_MONTH', '');
			
					
			
			var param = panelSearch.getValues();
			mba032ukrvService.selectMaster1(param, function(provider1, response)	{	//잔액이월Control에서 월마감(최종마감,기초잔액)년월 조회				
				mba032ukrvService.selectMaster2(param, function(provider2, response)	{	//채권누계테이블에서 해당 사업장의 최종마감월과 최초마감월 조회
					
					var sArLastYM = provider2.data.LAST_ARMONTH;		//'sar200t에서의 최종마감월(미존재시:'000000')
					var sArFirstYM = provider2.data.FIRST_ARMONTH;	//sar200t에서의 최초마감월(미존재시:'000000')
					
					if(Ext.isEmpty(provider1)){
						panelSearch.setValue('END_DATE', '0000.00')						
						if(sArFirstYM == '000000' || sArFirstYM == ''){
							panelSearch.setValue('WORK_DATE', UniDate.get('today'));							
						}else{
							panelSearch.setValue('TEMP_WORK_DATE', sArFirstYM);
							panelSearch.setValue('WORK_DATE', UniDate.add(panelSearch.getValue('TEMP_WORK_DATE'), {months:-1}));	//한달전으로set							
						}
						panelSearch.setValue('BASIS_DATE', '0000.00')
						panelSearch.setValue('REAL_BASIS_DATE', '0000.00')						
						gsMonth = UniDate.getDbDateStr(panelSearch.getValue('WORK_DATE')).substring(0, 6)
					}else{
						var endDate = provider1.data.LAST_YYYYMM;
						var basisDate = provider1.data.BASIS_YYYYMM;
						var realBasisDate = provider1.data.REAL_BASIS_YYYYMM; 201501
						endDate = endDate.substring(0,4) + '.' +endDate.substring(4,6);
						basisDate = basisDate.substring(0,4) + '.' + basisDate.substring(4,6);
						realBasisDate = realBasisDate.substring(0,4) + '.' + realBasisDate.substring(4,6);
						
//						if(provider1.data.LAST_YYYYMM != '000000') panelSearch.setValue('END_DATE', Ext.Date.format(UniDate.extParseDate(provider1.data.LAST_YYYYMM + '01'), 'Y.m'));
						if(provider1.data.LAST_YYYYMM != '000000') panelSearch.setValue('END_DATE', endDate);	//최종마감일
						if(provider1.data.LAST_YYYYMM != '000000') panelSearch.setValue('TEMP_END_DATE', provider1.data.LAST_YYYYMM);	//날짜 포멧을 위해 SET
						if(provider1.data.BASIS_YYYYMM != '000000') panelSearch.setValue('BASIS_DATE', basisDate);					//최초잔액반영일
						if(provider1.data.REAL_BASIS_YYYYMM != '000000') panelSearch.setValue('REAL_BASIS_DATE', realBasisDate);	//기초잔액반영일
						panelSearch.setValue('WORK_DATE', UniDate.add(panelSearch.getValue('TEMP_END_DATE'), {months:1}));  //마감일 한달후로
						gsMonth = UniDate.getDbDateStr(panelSearch.getValue('WORK_DATE')).substring(0, 6)
					}
					
					if(sArLastYM != '000000') {
						sArLastYM = sArLastYM.substring(0,4) + '.' +sArLastYM.substring(4,6);
						panelSearch.setValue('AR_LAST_MONTH', sArLastYM);
					}
					panelSearch.getField( 'CLOSED_YN').setValue('F');	//마감으로 rdo 변경	
					if(panelSearch.getValue('END_DATE') == '0000.00'){
						panelSearch.getField("CLOSED_RDO_YN").setReadOnly(true);
					}else{
						panelSearch.getField("CLOSED_RDO_YN").setReadOnly(false);
					}					
					mba032ukrvService.selectOrgInfo(param, function(provider, response)	{	//사업자번호 조회
						if(!Ext.isEmpty(provider)){
							var result = '';
							orgInfo = provider.data.COMPANY_NUM;
							if(orgInfo.length == 10){
								result = orgInfo.substring(0,3) + '-' + orgInfo.substring(3,5) + '-' +orgInfo.substring(5,10);
							}else{
								result = orgInfo;
							}
							panelSearch.setValue('ORG_INFO', result);
						}
					});
						
				});				
			});	
		},		
				fnChangeclosedYN: function(newValue){	//작업선택 radio 변경시
			
			if(newValue.CLOSED_YN == 'F'){	//마감
				if(panelSearch.getValue('END_DATE') == '0000.00'){
					panelSearch.getField("CLOSED_RDO_YN").setReadOnly(true);//최종마감일이 없을시  rdo disabled 취소선택 못하게
				}else{
					panelSearch.getField("CLOSED_RDO_YN").setReadOnly(false);
					panelSearch.setValue('WORK_DATE', UniDate.add(panelSearch.getValue('TEMP_END_DATE'), {months:1}));  //마감일 한달후로
					gsMonth = UniDate.getDbDateStr(panelSearch.getValue('WORK_DATE')).substring(0, 6)
				}
				
			}else{			//취소
				var StrDate = '0000.00'; 
				var StrDate1 = panelSearch.getValue('END_DATE');
				var StrDate2 = panelSearch.getValue('BASIS_DATE')	//UniDate.getDbDateStr(panelSearch.getValue('BASIS_DATE')).substring(0, 7);
				var sRealBaseDate = panelSearch.getValue('REAL_BASIS_DATE');
				
				if(StrDate1 < sRealBaseDate){
					alert(Msg.sMB108 + ' ' + sRealBaseDate + Msg.sMB109)	//기초반영월이 ?월이므로 취소가 불가능합니다. 
					panelSearch.setValue('WORK_DATE', panelSearch.getValue('REAL_BASIS_DATE'));	////000000으로 셋 안됨  
					gsMonth =UniDate.getDbDateStr(panelSearch.getValue('WORK_DATE')).substring(0, 6)				
					panelSearch.getField( 'CLOSED_YN').setValue('F');
					return false;
				}				
				
				if(panelSearch.getValue('END_DATE') == StrDate){	//rdo disable시키면 어차피 접근 안됨..
					panelSearch.setValue('WORK_DATE', '000000');			////000000으로 셋 안됨
				}else{
					if(UniDate.getDbDateStr(panelSearch.getValue('WORK_DATE')).substring(0, 6) != StrDate2.replace('.','')){ //작업월,최초잔액반영월 다를시 최종마감월 set해줌..
						var workDate =  UniDate.getDbDateStr(panelSearch.getValue('END_DATE').replace('.',''));
						panelSearch.setValue('WORK_DATE', workDate);
					}
					gsMonth = UniDate.getDbDateStr(panelSearch.getValue('WORK_DATE')).substring(0, 6)
				}
			}
		},		
		fnDateDIffCal: function(){	
			var sBDate = panelSearch.getValue('BASIS_DATE');
			var sRealBaseDate = panelSearch.getValue('REAL_BASIS_DATE'); 
			var sWorkDate = UniDate.getDbDateStr(panelSearch.getValue('WORK_DATE')).substring(0, 6);
			sWorkDate = sWorkDate.substring(0,4) + '.' + sWorkDate.substring(4,6);
			var sEndDate = panelSearch.getValue('END_DATE');
			var sArEndDate = panelSearch.getValue('AR_LAST_MONTH');
			var StrDate = '0000.00';
			
			if(!Ext.isEmpty(sRealBaseDate)){
				if(sRealBaseDate > sWorkDate){	//기초잔액년월 >이월작업년월
					alert(Msg.sMS328);//이월작업년월은 기초잔액반영년월보다 작을 수 없습니다.
					panelSearch.setValue('WORK_DATE', gsMonth);
					return false;
				}				
			}
			
			if(sEndDate != StrDate){	//'최종마감년월과 시작월이 다를 경우.
				if(!panelSearch.getValue('CLOSED_YN')){		//취소일경우
					if(sWorkDate != sBDate){	//이월작업년월 != 최초잔액반영월
						if(sWorkDate > sEndDate){	//이월작업년월 > 최종마감년월
							alert(Msg.sMS331);	//이월취소작업시 이월작업년월은 최종마감년월보다 클 수 없습니다.
							panelSearch.setValue('WORK_DATE', gsMonth);
							return false;
						}						
					}
				}else{	//마감일 경우
					if(sWorkDate < sEndDate){	//이월작업년월 < 최종마감년월
						alert(Msg.sMS332);	//이월작업시 이월작업년월은 최종마감년월보다 작을 수 없습니다.
						panelSearch.setValue('WORK_DATE', gsMonth);
						return false;
					}
				}				
			}
			
			if(!Ext.isEmpty(panelSearch.getValue('AR_LAST_MONTH'))){
				if(sWorkDate > sArEndDate){	//이월작업년월 > 최종채권마감년월
					alert(Msg.sMS330);	//이월작업년월은 채권최종이월년월보다 클 수 없습니다.
					panelSearch.setValue('WORK_DATE', gsMonth);
					return false;
				}
			}
			
			if(!panelSearch.getValue('CLOSED_YN')){	//취소일경우
				if(sWorkDate == sBDate){	//이월작업년월 == 최초잔액반영일 (마지막 취소일 경우)
					sWorkDate = UniDate.getDbDateStr(UniDate.add(panelSearch.getValue('WORK_DATE'), {months:-1})).substring(0, 6);
					sWorkDate = sWorkDate.substring(0,4) + '.' + sWorkDate.substring(4,6);
				}
			}
			var today = UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6);
			today = today.substring(0,4) + '.' + today.substring(4,6);
			if(sWorkDate > today){
				alert(Msg.sMS329);	//이월작업년월은 현재년월보다 클 수 없습니다.
				panelSearch.setValue('WORK_DATE', gsMonth);
				return false;
			}
			
			return true;
			
		}
	});
	
		Unilite.createValidator('formValidator', {
		forms: {'formA:':panelSearch},		
		validate: function( type, fieldName, newValue, oldValue) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {	
				case "WORK_DATE" :
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
						UniAppManager.app.fnDateDIffCal();
					}										
				break;
			}
			return rv;
		}
	}); 
};
</script>
