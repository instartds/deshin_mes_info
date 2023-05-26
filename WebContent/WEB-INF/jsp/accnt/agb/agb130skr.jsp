<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb130skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->   
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수
var gsChargeCode = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode} ;				//ChargeCode 관련 전역변수
var drAmtI	= 0;
var crAmtI	= 0;
var janAmtI	= 0;
var forAmtI	= 0;
var postitWindow;						// 각주팝업

function appMain() {
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb130skrModel', {
	    fields: [{name: 'AC_DATE'			,text: '전표일' 			,type: 'uniDate'},	    		
				 {name: 'SLIP_NUM'			,text: '번호' 			,type: 'string'},	    		
				 {name: 'SLIP_SEQ'			,text: '순번' 			,type: 'string'},	    		
				 {name: 'REMARK'			,text: '적요' 			,type: 'string'},	    		
				 {name: 'P_ACCNT_NAME'		,text: '상대계정' 			,type: 'string'},	    		
				 {name: 'DR_AMT_I'			,text: '입금액' 			,type: 'uniPrice'},	    		
				 {name: 'CR_AMT_I'			,text: '출금액' 			,type: 'uniPrice'},	    		
				 {name: 'JAN_AMT_I'			,text: '잔액' 			,type: 'uniPrice'},	    		
				 {name: 'MONEY_UNIT'		,text: '화폐' 			,type: 'string'},	    		
				 {name: 'FOR_AMT_I'		 	,text: '외화금액' 			,type: 'uniFC'},			 
				 {name: 'GUBUN' 			,text: '구분' 			,type: 'string'},	    		
				 {name: 'AUTO_NUM' 			,text: 'AUTO_NUM' 		,type: 'string'},	    		
				 {name: 'POSTIT_YN' 		,text: 'POSTIT_YN' 		,type: 'string'},	    		
				 {name: 'POSTIT' 			,text: 'POSTIT' 		,type: 'string'},	    		
				 {name: 'POSTIT_USER_ID' 	,text: 'POSTIT_USER_ID' ,type: 'string'},	    		
				 {name: 'INPUT_PATH' 		,text: 'INPUT_PATH' 	,type: 'string'},	    		
				 {name: 'MOD_DIVI' 			,text: 'MOD_DIVI' 		,type: 'string'},	    		
				 {name: 'INPUT_DIVI' 		,text: 'INPUT_DIVI' 	,type: 'string'},	    		
				 {name: 'DIV_CODE' 			,text: '사업장' 			,type: 'string'}
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('agb130skrMasterStore',{
			model: 'Agb130skrModel',
			uniOpt : {
            	isMaster:	true,			// 상위 버튼 연결 
            	editable:	false,			// 수정 모드 사용 
            	deletable:	false,			// 삭제 가능 여부 
	            useNavi:	false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'agb130skrService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},
			listeners: {
	          	load: function(store, records, successful, eOpts) {
/*	          		Ext.each(records, function(record, rowIndex){ 
	          			//차변 구하기
						if(Ext.isEmpty(record.get('GUBUN'))){
							drAmtI	= record.get('DR_AMT_I');
							drAmtI1	= record.get('DR_AMT_I');
						} else if(record.get('GUBUN') == '1') {
							drAmtI	= drAmtI + record.get('DR_AMT_I')
						} else if(record.get('GUBUN') == '3') {
							record.set('DR_AMT_I', drAmtI);								
						}
	          			//대변 구하기
						if(Ext.isEmpty(record.get('GUBUN'))){
							crAmtI	= record.get('CR_AMT_I');
							crAmtI1	= record.get('CR_AMT_I');
						} else if(record.get('GUBUN') == '1') {
							crAmtI	= crAmtI + record.get('CR_AMT_I')
						} else if(record.get('GUBUN') == '3') {
							record.set('CR_AMT_I', crAmtI);								
						}
	          			//잔액 구하기
						if(Ext.isEmpty(record.get('GUBUN'))){
							janAmtI	= record.get('JAN_AMT_I');
							janAmtI1	= record.get('JAN_AMT_I');
						} else if(record.get('GUBUN') == '1') {
							janAmtI	= janAmtI + record.get('JAN_AMT_I')
							record.set('JAN_AMT_I', janAmtI);								
						} else if(record.get('GUBUN') == '4') {
							record.set('JAN_AMT_I', null);								
						} else if(record.get('GUBUN') == '3') {
							record.set('JAN_AMT_I', janAmtI);								
						}
						//필요없는 데이터 숨기기 (소계/합계의 전표일, 번호, 외화금액)
						if(record.get('GUBUN') == '2' || record.get('GUBUN') == '3' || record.get('GUBUN') == '4') {
							record.set('AC_DATE', null);								
							record.set('SLIP_NUM', null);								
							record.set('FOR_AMT_I', null);								
						}
						//summaryRow로 대체한 첫 번째 이월금액 그리드 삭제
						if(Ext.isEmpty(record.get('GUBUN'))){
		          			masterStore.remove(record);
						}
	          		})
					masterStore.commitChanges();*/
					UniAppManager.setToolbarButtons('save', false);
					
					//조회된 데이터가 있을 때, 합계 보이게 설정 변경
//					var viewNormal = masterGrid.getView();
//					if(store.getCount() > 0){
//			    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
//					}else{
//			    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);	
//					}
					drAmtI	= 0;
					crAmtI	= 0;
					janAmtI	= 0;
					forAmtI	= 0;
					//summaryRow에 쿼리에서 조회한 데이터 입력 후, 대체한 첫 번째 이월금액 그리드 삭제
					Ext.each(records, function(record, rowIndex){ 
						if(record.get('REMARK')== '이월금액'){
							drAmtI		= record.get('DR_AMT_I');
							crAmtI		= record.get('CR_AMT_I');
							janAmtI		= record.get('JAN_AMT_I');
							//화폐단위가 선택되었을 때만 외화금액 관련 일월금액 구함
							if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))){
								forAmtI	= record.get('FOR_AMT_I');
							}
//							masterStore.remove(record);
						}
	          		});
	          		
	          		var count = masterGrid.getStore().getCount();  
					//조회된 데이터가 있을 때, 그리드에 포커스 가도록 변경
					if(store.getCount() > 0){
			    		masterGrid.focus();
					//조회된 데이터가 없을 때, 패널의 첫번째 필드에 포커스 가도록 변경
		    		}else{
						var activeSForm ;		
						if(!UserInfo.appOption.collapseLeftSearch)	{	
							activeSForm = panelSearch;	
						}else {		
							activeSForm = panelResult;	
						}		
						activeSForm.onLoadSelectText('AC_DATE_FR');	
					}
	          		
				}          		
          	}
	});

	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',         
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{ 
    			fieldLabel: '전표일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'AC_DATE_FR',
		        endFieldName: 'AC_DATE_TO',
//		        width: 470,
		        allowBlank: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('AC_DATE_FR', newValue);						
						UniAppManager.app.fnSetStDate(newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('AC_DATE_TO', newValue);				    		
			    	}
			    }
	        },{
		        fieldLabel: '사업장',
			    name:'ACCNT_DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
//			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('ACCNT',{
				fieldLabel: '계정과목',
				validateBlank:true,
				allowBlank: false, 
				valueFieldName: 'ACCNT_CODE',
				textFieldName: 'ACCNT_NAME',
				extParam: {	'CHARGE_CODE': gsChargeCode[0].SUB_CODE,
							'ADD_QUERY': "(SPEC_DIVI = 'A')"},
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue) {
						if(newValue == '') {
							panelSearch.setValue('ACCNT_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue) {
						if(newValue == '') {
							panelSearch.setValue('ACCNT_CODE', '');
						}
					},
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
							panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));	
							/**
							 * 계정과목 동적 팝업
							 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
							 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
							 *  valueFieldName    textFieldName 		valueFieldName     textFieldName		 	valueFieldName    textFieldName
							 *    PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	   BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
							 * -------------------------------------------------------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
							 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
							 *    PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
							 * */
							var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
							accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
								var dataMap = provider;
								var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
								UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);
								UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
								panelSearch.down('#conArea1').show();
								panelSearch.down('#conArea2').show();
								panelResult.down('#conArea1').show();
								panelResult.down('#conArea2').show();
								panelSearch.down('#formFieldArea1').show();
								panelSearch.down('#formFieldArea2').show();
								panelResult.down('#formFieldArea1').show();
								panelResult.down('#formFieldArea2').show();
								
								panelResult.down('#result_ViewPopup1').hide();
								panelSearch.down('#serach_ViewPopup1').hide();
								panelResult.down('#result_ViewPopup2').hide();
								panelSearch.down('#serach_ViewPopup2').hide();
							})
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_CODE', '');
						panelResult.setValue('ACCNT_NAME', '');
						panelSearch.down('#serach_ViewPopup1').show();
						panelResult.down('#result_ViewPopup1').show();
						panelSearch.down('#serach_ViewPopup2').show();
						panelResult.down('#result_ViewPopup2').show();
						// onClear시 removeField..
						UniAccnt.removeField(panelSearch, panelResult);
						panelSearch.down('#conArea1').hide();
						panelSearch.down('#conArea2').hide();
						panelResult.down('#conArea1').hide();
						panelResult.down('#conArea2').hide();
					}
				}
			}),
		    	Unilite.popup('ACCNT',{
		    	fieldLabel: '상대계정',
	//	    	validateBlank:false,	 
				valueFieldName: 'P_ACCNT_CD',
		    	textFieldName: 'P_ACCNT_NM',  			
		    	autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue) {
						if(newValue == '') {
							panelSearch.setValue('P_ACCNT_NM', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue) {
						if(newValue == '') {
							panelSearch.setValue('P_ACCNT_CD', '');
						}
					},
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('P_ACCNT_CD', panelSearch.getValue('P_ACCNT_CD'));
							panelResult.setValue('P_ACCNT_NM', panelSearch.getValue('P_ACCNT_NM'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('P_ACCNT_CD', '');
						panelResult.setValue('P_ACCNT_NM', '');
					}
				}
	    	}),{
			  	xtype: 'container',
			  	colspan: 1,
			  	itemId: 'serach_ViewPopup1', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		},
		  		items:[
					Unilite.popup('ACCNT_PRSN',{
						readOnly:true,
				    	fieldLabel: '계정항목1',
				    	validateBlank:false
			    	})
			    ]
			 },{
			  	xtype: 'container',
			  	colspan: 1,
			  	itemId: 'serach_ViewPopup2', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		},
		  		items:[
				    Unilite.popup('ACCNT_PRSN',{
						readOnly:true,
				    	fieldLabel: '계정항목2',
				    	validateBlank:false
				    })
				]
			},{
		    	xtype: 'container',
		    	itemId: 'conArea1',
		    	items:[{
				  	xtype: 'container',
				  	colspan: 1,
				  	itemId: 'formFieldArea1', 
				  	layout: {
				   		type: 'table', 
				   		columns:1,
				   		itemCls:'table_td_in_uniTable',
				   		tdAttrs: {
				    		width: 350
				   		}
			  		}
				}]
		    },{
		    	xtype: 'container',
		    	itemId: 'conArea2',
		    	items:[{
				  	xtype: 'container',
				  	colspan: 1,
				  	itemId: 'formFieldArea2', 
				  	layout: {
				   		type: 'table', 
				   		columns:1,
				   		itemCls:'table_td_in_uniTable',
				   		tdAttrs: {
				    		width: 350
				   		}
			  		}
				}]
		    }]
		}, {	
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			    items : [{
					fieldLabel: '조건',
					name: '',
					xtype: 'checkboxgroup', 
					width: 400, 
					items: [{
			        	boxLabel: '수정삭제이력표시',
			        	name: 'CHECK_DELETE',
						width: 150,
						uncheckedValue: 'N',
			        	inputValue: 'Y'
			        }, {
						boxLabel: '각주',
			        	name: 'CHECK_POST_IT',
						width: 100,
//						uncheckedValue: 'N',
			        	inputValue: 'Y',
		        		listeners: {
		   				 	change: function(field, newValue, oldValue, eOpts) {
		   				 		if(panelSearch.getValue('CHECK_POST_IT')) {
									panelSearch.getField('POST_IT').setReadOnly(false);
		   				 		} else {
									panelSearch.getField('POST_IT').setReadOnly(true);
		   				 		}
							}
		        		}
					}]
				}, {
			    	xtype: 'uniTextfield',
			    	fieldLabel: '각주',
			    	width: 325,
			    	name:'POST_IT',
			    	readOnly: true
			    },{
					fieldLabel: '당기시작년월',
					name: 'START_DATE',
					xtype: 'uniMonthfield',
					allowBlank: false
				},		    
			    	Unilite.popup('ACCNT_PRSN',{
			    	fieldLabel: '입력자',
				    valueFieldName:'CHARGE_CODE',
				    textFieldName:'CHARGE_NAME',
			    	validateBlank:false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue) {
							if(newValue == '') {
								panelSearch.setValue('CHARGE_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue) {
							if(newValue == '') {
								panelSearch.setValue('CHARGE_CODE', '');
							}
						},
						onClear: function(type)	{
							panelResult.setValue('CHARGE_CODE', '');
							panelResult.setValue('CHARGE_NAME', '');
						}
					}
			    }),{
					xtype: 'container',
					layout: {type : 'uniTable', columns : 3},
					width:600,
					items :[{
						fieldLabel:'금액', 
						xtype: 'uniNumberfield',
						name: 'AMT_FR', 
						width: 203
					},{
						xtype:'component', 
						html:'~',
						style: {
							marginTop: '3px !important',
							font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
						}
					},{
						fieldLabel:'', 
						xtype: 'uniNumberfield',
						name: 'AMT_TO', 
						width: 113
					}]
				},{
					xtype: 'container',
					layout: {type : 'uniTable', columns : 3},
					width:600,
					items :[{
						fieldLabel:'외화금액', 
						xtype: 'uniNumberfield',
						name: 'FOR_AMT_FR', 
						width: 203
					},{
						xtype:'component', 
						html:'~',
						style: {
							marginTop: '3px !important',
							font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
						}
					},{
						fieldLabel:'', 
						xtype: 'uniNumberfield',
						name: 'FOR_AMT_TO', 
						width: 113
					}]
				},		    
			    	Unilite.popup('REMARK',{
			    	fieldLabel: '적요',
					name: 'REMARK',
			    	validateBlank:false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue) {
							if(newValue == '') {
								panelSearch.setValue('REMARK_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue) {
							if(newValue == '') {
								panelSearch.setValue('REMARK_CODE', '');
							}
						}
					}
			    }),  
			        Unilite.popup('DEPT',{
			        fieldLabel: '부서',
				    valueFieldName:'DEPT_CODE_FR',
				    textFieldName:'DEPT_NAME_FR',
			        validateBlank:false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue) {
							if(newValue == '') {
								panelSearch.setValue('DEPT_NAME_FR', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue) {
							if(newValue == '') {
								panelSearch.setValue('DEPT_CODE_FR', '');
							}
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE_FR', '');
							panelResult.setValue('DEPT_NAME_FR', '');
						}
					}
			    }),
			      	Unilite.popup('DEPT',{
			        fieldLabel: '~',
				    valueFieldName:'DEPT_CODE_TO',
				    textFieldName:'DEPT_NAME_TO',
			        validateBlank:false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue) {
							if(newValue == '') {
								panelSearch.setValue('DEPT_NAME_TO', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue) {
							if(newValue == '') {
								panelSearch.setValue('DEPT_CODE_TO', '');
							}
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE_TO', '');
							panelResult.setValue('DEPT_NAME_TO', '');
						}
					}
				})
			]		
		}]
	});   
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '전표일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'AC_DATE_FR',
	        endFieldName: 'AC_DATE_TO',
			allowBlank: false,                	
	        tdAttrs: {width: 380},  
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('AC_DATE_FR', newValue);						
					UniAppManager.app.fnSetStDate(newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('AC_DATE_TO', newValue);				    		
		    	}
		    }
        },{
	        fieldLabel: '사업장',
		    name:'ACCNT_DIV_CODE', 
		    xtype: 'uniCombobox',
			multiSelect: true, 
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
//		    width: 325,
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
				panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
     		}
		},		    
	    	Unilite.popup('ACCNT',{
	    	fieldLabel: '계정과목',
//	    	validateBlank:false,	 
	    	allowBlank: false, 
	    	valueFieldName: 'ACCNT_CODE',
	    	textFieldName: 'ACCNT_NAME',
  			extParam: {	'CHARGE_CODE': gsChargeCode[0].SUB_CODE,
						'ADD_QUERY': "(SPEC_DIVI = 'A')"},
//			extParam: {'CHARGE_CODE': gsChargeCode[0].SUB_CODE},  
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue) {
					if(newValue == '') {
						panelResult.setValue('ACCNT_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue) {
					if(newValue == '') {
						panelResult.setValue('ACCNT_CODE', '');
					}
				},
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
						panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));	
						/**
						 * 계정과목 동적 팝업
						 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
						 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
						 *  valueFieldName    textFieldName 		valueFieldName     textFieldName		 	valueFieldName    textFieldName
						 *    PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	   BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
						 * -------------------------------------------------------------------------------------------------------------------------
						 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
						 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
						 *    PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
						 * */
						var param = {ACCNT_CD : panelResult.getValue('ACCNT_CODE')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
							var dataMap = provider;
							var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용						
							UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
							UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);
							panelSearch.down('#conArea1').show();
							panelSearch.down('#conArea2').show();
							panelResult.down('#conArea1').show();
							panelResult.down('#conArea2').show();
							panelSearch.down('#formFieldArea1').show();
							panelSearch.down('#formFieldArea2').show();
							panelResult.down('#formFieldArea1').show();
							panelResult.down('#formFieldArea2').show();
							
							panelResult.down('#result_ViewPopup1').hide();
							panelSearch.down('#serach_ViewPopup1').hide();
							panelResult.down('#result_ViewPopup2').hide();
							panelSearch.down('#serach_ViewPopup2').hide();
						})		 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ACCNT_CODE', '');
					panelSearch.setValue('ACCNT_NAME', '');
					panelSearch.down('#serach_ViewPopup1').show();
					panelResult.down('#result_ViewPopup1').show();
					panelSearch.down('#serach_ViewPopup2').show();
					panelResult.down('#result_ViewPopup2').show();
					// onClear시 removeField..
					UniAccnt.removeField(panelSearch, panelResult);
					panelSearch.down('#conArea1').hide();
					panelSearch.down('#conArea2').hide();
					panelResult.down('#conArea1').hide();
					panelResult.down('#conArea2').hide();
				}
			}
 		}),{
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'result_ViewPopup1', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정과목1',
			    	validateBlank:false
			    })
			]
		},{
	    	xtype: 'container',
	    	itemId: 'conArea1',
	    	colspan: 2,
	    	items:[{
			  	xtype: 'container',
			  	itemId: 'formFieldArea1', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    },		    
	    	Unilite.popup('ACCNT',{
	    	fieldLabel: '상대계정',
//	    	validateBlank:false,	 
	    	valueFieldName: 'P_ACCNT_CD',
	    	textFieldName: 'P_ACCNT_NM',
			extParam: {'CHARGE_CODE': gsChargeCode[0].SUB_CODE},
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue) {
					if(newValue == '') {
						panelResult.setValue('P_ACCNT_NM', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue) {
					if(newValue == '') {
						panelResult.setValue('P_ACCNT_CD', '');
					}
				},
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('P_ACCNT_CD', panelResult.getValue('P_ACCNT_CD'));
						panelSearch.setValue('P_ACCNT_NM', panelResult.getValue('P_ACCNT_NM'));	
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('P_ACCNT_CD', '');
					panelSearch.setValue('P_ACCNT_NM', '');
				}
			}
 		}),{
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'result_ViewPopup2', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정과목2',
			    	validateBlank:false
			    })
		]},{
	    	xtype: 'container',
	    	itemId: 'conArea2',
	    	colspan: 2,
	    	items:[{
			  	xtype: 'container',			  	
			  	itemId: 'formFieldArea2', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    }]	
    });
    
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agb130skrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: masterStore,
		selModel: 'rowmodel',
    	uniOpt:{
			useMultipleSorting	: true,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: true,			
	    	filter: {
				useFilter		: true,		
				autoCreate		: true		
			},
			excel: {
				useExcel: true,			//엑셀 다운로드 사용 여부
				exportGroup : false, 		//group 상태로 export 여부
				onlyData:false,
				summaryExport:false
			}
		},
        tbar: [{
        	text:'현금출납장출력',
        	handler: function() {
				var params = {
//					action:'select',
					'AC_DATE_FR'	: panelSearch.getValue('AC_DATE_FR'),
					'AC_DATE_TO'	: panelSearch.getValue('AC_DATE_TO'),
					'DIV_CODE'		: panelSearch.getValue('ACCNT_DIV_CODE'),
					'ACCNT_CODE'	: panelSearch.getValue('ACCNT_CODE'),
					'ACCNT_NAME'	: panelSearch.getValue('ACCNT_NAME'),
					'P_ACCNT_CD'	: panelSearch.getValue('P_ACCNT_CD'),
					'P_ACCNT_NM'	: panelSearch.getValue('P_ACCNT_NM'),
					'CHECK_DELETE'	: panelSearch.getValue('CHECK_DELETE'),
					'CHECK_POST_IT'	: panelSearch.getValue('CHECK_POST_IT'),
					'POST_IT'		: panelSearch.getValue('POST_IT'),
					'START_DATE'	: panelSearch.getValue('START_DATE'),
					'CHARGE_CODE'	: panelSearch.getValue('CHARGE_CODE'),
					'CHARGE_NAME'	: panelSearch.getValue('CHARGE_NAME'),
					'AMT_FR'		: panelSearch.getValue('AMT_FR'),
					'AMT_TO'		: panelSearch.getValue('AMT_TO'),
					'REMARK_CODE'	: panelSearch.getValue('REMARK_CODE'),
					'REMARK_NAME'   : panelSearch.getValue('REMARK_NAME'),
					'FOR_AMT_FR'	: panelSearch.getValue('FOR_AMT_FR'),
					'FOR_AMT_TO'	: panelSearch.getValue('FOR_AMT_TO'),
					'DEPT_CODE_FR'	: panelSearch.getValue('DEPT_CODE_FR'),
					'DEPT_NAME_FR'	: panelSearch.getValue('DEPT_NAME_FR'),
					'DEPT_CODE_TO'	: panelSearch.getValue('DEPT_CODE_TO'),
					'DEPT_NAME_TO'	: panelSearch.getValue('DEPT_NAME_TO')
				}
        		//전송
          		var rec1 = {data : {prgID : 'agb130rkr', 'text':''}};
				parent.openTab(rec1, '/accnt/agb130rkr.do', params);
        	}
        }],
    	features: [ {
    		id : 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',	
    		showSummaryRow: false 
    	},{
    		id : 'masterGridTotal',
    		itemID:	'test',
    		ftype: 'uniSummary',
			dock : 'top',
    		showSummaryRow: false
    	}],
        columns:  [ /*//hidden 컬럼 주석 처리
        			{ dataIndex: 'GUBUN' 			, width:80		,hidden: true	},	    		
				 	{ dataIndex: 'AUTO_NUM' 		, width:80		,hidden: true	},
				 	{ dataIndex: 'POSTIT_YN' 		, width:80		,hidden: true	},
				 	{ dataIndex: 'POSTIT' 			, width:80		,hidden: true	},	    		
				 	{ dataIndex: 'POSTIT_USER_ID' 	, width:80		,hidden: true	},	    		
				 	{ dataIndex: 'INPUT_PATH' 		, width:80		,hidden: true	},	    		
					{ dataIndex: 'MOD_DIVI' 		, width:80		,hidden: true	},	    		
				 	{ dataIndex: 'INPUT_DIVI' 		, width:80		,hidden: true	},	    		
				 	{ dataIndex: 'DIV_CODE' 		, width:80		,hidden: true	}, */  
        			{ dataIndex: 'GUBUN' 			, width:80	,hidden: true		},	
					{ dataIndex: 'AC_DATE'			, width: 80},
					{ dataIndex: 'SLIP_NUM'			, width: 60		,align: 'center'},
					{ dataIndex: 'SLIP_SEQ'			, width: 60		,align: 'center'},
					{ dataIndex: 'REMARK'			, width: 300,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '이월금액');
		            	},
    					renderer:function(value, metaData, record)	{
							var r = value;
							if(record.get('POSTIT_YN') == 'Y') r ='<img src="'+CPATH+'/resources/images/PostIt.gif"/>'+value
							if(Ext.isEmpty(record.get('DIV_CODE'))) r ='<div align="center">'+value
							return r;
    					}
		            },
					{ dataIndex: 'P_ACCNT_NAME'		, width: 120},
					{ dataIndex: 'DR_AMT_I'			, width: 120	,align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '소계','<div align="right">'+ Ext.util.Format.number(drAmtI,'0,000')+'</div>');
		            	}
		            },
					{ dataIndex: 'CR_AMT_I'			, width: 120	,align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '소계','<div align="right">'+ Ext.util.Format.number(crAmtI,'0,000')+'</div>');
		            	}
		            },
					{ dataIndex: 'JAN_AMT_I'		, width: 120	,align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '소계','<div align="right">'+ Ext.util.Format.number(janAmtI,'0,000')+'</div>');
		            	}
		            },
					{ dataIndex: 'MONEY_UNIT'		, width: 60},
					{ dataIndex: 'FOR_AMT_I'		, width: 120,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '소계','<div align="right">'+ Ext.util.Format.number(forAmtI,'0.000')+'</div>');
		            	}
		            }        		   
        ],
		listeners: {
	      	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	if(record.get('GUBUN') != '2' && record.get('GUBUN') != '3' && record.get('GUBUN') != '4') {
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
	        	
	        	/*  else if(record.get('GUBUN') != '3') {
	        		view.ownerGrid.setCellPointer(view, item);
	        	} else if(record.get('GUBUN') != '4') {
	        		view.ownerGrid.setCellPointer(view, item);
	        	} */
    		},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
            	if(record.get('GUBUN') != '2' && record.get('GUBUN') != '3' && record.get('GUBUN') != '4' && record.get('GUBUN') != '0'){
	                if(grid.grid.contextMenu) {
	                    var menuItem = grid.grid.contextMenu.down('#linkAgj200ukr');
	                    if(menuItem) {
	                        menuItem.handler();
                    	}
                	}
            	}
            },
    		render:function(grid, eOpt)	{
    			grid.getEl().on('click', function(e, t, eOpt) {
			    	activeGrid = grid.getItemId();
			    });
//			    var b = isTbar;
			    var i=0;
//			    if(b)	{
//			    	i=0;
//			    }
    			var tbar = grid._getToolBar();
    			tbar[0].insert(i++,{
		        	xtype: 'uniBaseButton',
		        	iconCls: 'icon-postit',
		        	width: 26, height: 26,
		        	tooltip:'각주',
		        	handler:function()	{
		        		openPostIt(grid);
		        	}
		        });
    		}
		},	
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
//			var inputDivi	= record.data['INPUT_DIVI'];
//
//			if (inputDivi == '2'){
	      		menu.down('#linkAgj200ukr').hide();
//	      		menu.down('#linkDgj100ukr').hide();
//	      		
//				menu.down('#linkAgj205ukr').show();
//			
//			} else if (inputDivi == 'Z3'){
//	      		menu.down('#linkAgj200ukr').hide();
//	      		menu.down('#linkAgj205ukr').hide();
//	      		
//				menu.down('#linkDgj100ukr').show();
//				
//			} else {
//	      		menu.down('#linkAgj205ukr').hide();
//	      		menu.down('#linkDgj100ukr').hide();
//	      		
//				menu.down('#linkAgj200ukr').show();
//			}
  		//menu.showAt(event.getXY());
  		return true;
  		},
        uniRowContextMenu:{
			items: [{
	        		text: '회계전표입력 보기',   
	            	itemId	: 'linkAgj200ukr',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID'		: 'agb130skr',
							'AC_DATE' 		: record.data['AC_DATE'],
							'INPUT_PATH'	: record.data['INPUT_PATH'],
							'SLIP_NUM'		: record.data['SLIP_NUM'],
							'SLIP_SEQ'		: record.data['SLIP_SEQ'],
							'DIV_CODE'		: panelSearch.getValue('ACCNT_DIV_CODE')
	            		};
	            		masterGrid.gotoAgj200ukr(param);
	            	}
	        	},{
	        		text: '회계전표입력(전표번호별) 보기',   
	            	itemId	: 'linkAgj205ukr',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID'		: 'agb130skr',
							'AC_DATE' 		: record.data['AC_DATE'],
							'INPUT_PATH'	: record.data['INPUT_PATH'],
							'SLIP_NUM'		: record.data['SLIP_NUM'],
							'SLIP_SEQ'		: record.data['SLIP_SEQ'],
							'DIV_CODE'		: panelSearch.getValue('ACCNT_DIV_CODE')
	            		};
	            		masterGrid.gotoAgj205ukr(param);
	            	}
	        	},{
	        		text: 'dgj100ukr 보기',   
	            	itemId	: 'linkDgj100ukr',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID'		: 'agb130skr',
							'AC_DATE' 		: record.data['AC_DATE'],
							'INPUT_PATH'	: record.data['INPUT_PATH'],
							'SLIP_NUM'		: record.data['SLIP_NUM'],
							'SLIP_SEQ'		: record.data['SLIP_SEQ'],
							'DIV_CODE'		: panelSearch.getValue('ACCNT_DIV_CODE')
	            		};
	            		masterGrid.gotoDgj100ukr(param);
	            	}
	        	}
	        ]
	    },
		gotoAgj200ukr:function(record)	{
			if(record)	{
		    	var params = record
			}
	  		var rec1 = {data : {prgID : 'agj200ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj200ukr.do', params);
    	},
		gotoAgj205ukr:function(record)	{
			if(record)	{
		    	var params = record
			}
	  		var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj205ukr.do', params);
    	},
		gotoDgj100ukr:function(record)	{
			if(record)	{
		    	var params = record
			}
	  		var rec1 = {data : {prgID : 'dgj100ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/dgj100ukr.do', params);
    	},
		returnCell: function(record){
        	var AC_DATE			= record.get("AC_DATE");
        	var SLIP_NUM		= record.get("SLIP_NUM");
        	var EX_NUM			= record.get("EX_NUM");
        	var AP_DATE			= record.get("AP_DATE");
        	var INPUT_PATH		= record.get("INPUT_PATH");
			panelSearch.setValues({'AC_DATE_MASTER':AC_DATE});
            panelSearch.setValues({'SLIP_NUM_MASTER':SLIP_NUM});
            panelSearch.setValues({'EX_NUM_MASTER':EX_NUM});
            panelSearch.setValues({'AP_DATE':AP_DATE});
            panelSearch.setValues({'INPUT_PATH_MASTER':INPUT_PATH});
		},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
//	          	if(Ext.isEmpty(record.get('GUBUN'))){
//					cls = 'x-change-cell_dark';
//				}
	          	if(record.get('GUBUN') == '2'){
					cls = 'x-change-cell_light';
				}
	          	else if(record.get('GUBUN') == '3'){
					cls = 'x-change-cell_normal';
				}
				else if(record.get('GUBUN') == '4') {
					cls = 'x-change-cell_dark';
				}
				if(record.get('MOD_DIVI') == 'D'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    } 
    });   

	function openPostIt(grid)	{
		var record = grid.getSelectedRecord();
		if(record && record.get('GUBUN') == '1'){
		    if(!postitWindow) {
				postitWindow = Ext.create('widget.uniDetailWindow', {
	                title: '각주',
	                width: 350,				                
	                height:100,
	            	
	                layout: {type:'vbox', align:'stretch'},	                
	                items: [{
	                	itemId:'remarkSearch',
	                	xtype:'uniSearchForm',
	                	items:[{	
                			fieldLabel:'각주',
                			labelWidth:60,
                			name : 'POSTIT',
                			width:300
                		}]
               		}],
	                tbar:  [
				         '->',{
							itemId : 'submitBtn',
							text: '확인',
							handler: function() {
								var postIt = postitWindow.down('#remarkSearch').getValue('POSTIT');
								var aGrid =grid;
								var record = aGrid.getSelectedRecord();
								var param = {
					 				SLIP_DIVI	: panelSearch.getValue('SLIP_DIVI'),
						 			AUTO_NUM	: record.get('AUTO_NUM'),
									EX_NUM		: record.get('SLIP_NUM'),
									EX_SEQ		: record.get('SLIP_SEQ'),
									SLIP_NUM	: record.get('SLIP_NUM'),
									SLIP_SEQ	: record.get('SLIP_SEQ'),
									EX_DATE	: UniDate.getDbDateStr(record.get('AC_DATE')),
									POSTIT		: postIt
								};
								agb110skrService.updatePostIt(param, function(provider, response){});
								postitWindow.hide();
								UniAppManager.app.onQueryButtonDown();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								postitWindow.hide();
							},
							disabled: false
						},{
							itemId : 'deleteBtn',
							text: '삭제',
							handler: function() {
								var aGrid =grid;
								var record = aGrid.getSelectedRecord();
								var param = {
					 				SLIP_DIVI	: '1',						//회계
							 		AUTO_NUM	: record.get('AUTO_NUM'),
									EX_NUM		: record.get('SLIP_NUM'),
									EX_SEQ		: record.get('SLIP_SEQ'),
									SLIP_NUM	: record.get('SLIP_NUM'),
									SLIP_SEQ	: record.get('SLIP_SEQ'),
									EX_DATE	: UniDate.getDbDateStr(record.get('AC_DATE'))
								};
								agb110skrService.deletePostIt(param, function(provider, response){});
								postitWindow.hide();
								UniAppManager.app.onQueryButtonDown();
							},
							disabled: false
						}
				    ],
					listeners : {
						beforehide: function(me, eOpt)	{
							postitWindow.down('#remarkSearch').clearForm();
	        			},
	        			beforeclose: function( panel, eOpts )	{
							postitWindow.down('#remarkSearch').clearForm();
	        			},
	        			show: function( panel, eOpts )	{
	        			 	var aGrid = grid
							var record = aGrid.getSelectedRecord();
							var param = {
					 			SLIP_DIVI	: '1',						//회계
					 			AUTO_NUM	: record.get('AUTO_NUM'),
								EX_NUM		: record.get('SLIP_NUM'),
								EX_SEQ		: record.get('SLIP_SEQ'),
								SLIP_NUM	: record.get('SLIP_NUM'),
								SLIP_SEQ	: record.get('SLIP_SEQ'),
								EX_DATE	: UniDate.getDbDateStr(record.get('AC_DATE'))
							};
							agb110skrService.getPostIt(param, function(provider, response){
						
								var form = postitWindow.down('#remarkSearch');
								form.setValue('POSTIT', provider['POSTIT']);
//								form.setValue('POSTIT_YN', provider['POSTIT_YN']);
//								form.setValue('POSTIT_USER_ID', provider['POSTIT_USER_ID']);
							});
	        			}
					}		
				});
			}	
			postitWindow.center();
			postitWindow.show();
		}
	}
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'agb130skrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('AC_DATE_TO',UniDate.get('today'));
			
			panelSearch.down('#formFieldArea1').hide();
			panelSearch.down('#formFieldArea2').hide();
			panelResult.down('#formFieldArea1').hide();
			panelResult.down('#formFieldArea2').hide();
			
			panelSearch.down('#conArea1').hide();
			panelSearch.down('#conArea2').hide();
			panelResult.down('#conArea1').hide();
			panelResult.down('#conArea2').hide();
			
			//당기시작년월 세팅
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			//상단 툴바버튼 세팅
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			//초기화 시 이월금액 행 안 보이게 설정
//			var viewNormal = masterGrid.getView();
//			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);

			//초기화 시 전표일로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE_FR');

			//20210521 추가: 링크 받는 로직 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				if(params.PGM_ID == 's_ssa700skrv_wm') {
					panelSearch.setValue('ACCNT_DIV_CODE'	, params.DIV_CODE);
					panelResult.setValue('ACCNT_DIV_CODE'	, params.DIV_CODE);
					panelSearch.setValue('AC_DATE_FR'		, params.BASIS_DATE);
					panelResult.setValue('AC_DATE_FR'		, params.BASIS_DATE);
					panelSearch.setValue('AC_DATE_TO'		, params.BASIS_DATE);
					panelResult.setValue('AC_DATE_TO'		, params.BASIS_DATE);
					
					panelSearch.setValue('ACCNT_CODE'		, '10100');
					panelResult.setValue('ACCNT_CODE'		, '10100');
					panelSearch.setValue('ACCNT_NAME'		, '현금');
					panelResult.setValue('ACCNT_NAME'		, '현금');
					var param = {ACCNT_CD : panelResult.getValue('ACCNT_CODE')};
					accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
						var dataMap = provider;
						var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용						
						UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
						UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);
						panelSearch.down('#conArea1').show();
						panelSearch.down('#conArea2').show();
						panelResult.down('#conArea1').show();
						panelResult.down('#conArea2').show();
						panelSearch.down('#formFieldArea1').show();
						panelSearch.down('#formFieldArea2').show();
						panelResult.down('#formFieldArea1').show();
						panelResult.down('#formFieldArea2').show();
						
						panelResult.down('#result_ViewPopup1').hide();
						panelSearch.down('#serach_ViewPopup1').hide();
						panelResult.down('#result_ViewPopup2').hide();
						panelSearch.down('#serach_ViewPopup2').hide();
						UniAppManager.app.onQueryButtonDown();
					})
				}
			}
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
/*			drAmtI	= 0;				//차변 누계 초기화
			crAmtI	= 0;				//대변 누계 초기화
			janAmtI	= 0;				//잔액 초기화
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
*/			masterStore.loadStoreRecords();
		},
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var params = Ext.getCmp('searchForm').getValues();
	         var record      = masterGrid.getSelectedRecord();
			 var divName     = '';
	         
			 if(panelSearch.getValue('ACCNT_DIV_CODE') == '' || panelSearch.getValue('ACCNT_DIV_CODE') == null ){
			 	divName = Msg.sMAW002;  // 전체
			 }else{
			 	divName = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			 }
		         
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/agb/agb130rkrPrint.do',
	            prgID: 'agb130rkr',
	               extParam: {
	                  COMP_CODE		 		: UserInfo.compCode,
	                  AC_DATE_FR  			: params.AC_DATE_FR,		/* 전표일 FR */
	                  AC_DATE_TO			: params.AC_DATE_TO,		/* 전표일 TO */
	                  P_ACCNT_CD			: params.P_ACCNT_CD,        /* 상대계정*/
	                  ACCNT_DIV_CODE		: params.ACCNT_DIV_CODE,	/* 사업장 CODE*/
	                  ACCNT_DIV_NAME		: divName,					/* 사업장 NAME */   
	                  START_DATE			: params.START_DATE,		/* 당기시작년월 */
	                  
	                  CHARGE_CODE			: params.CHARGE_CODE,       /* 입력자	*/
	                  	
	                  AMT_FR				: params.AMT_FR,			/* 금액 FR*/
	                  AMT_TO				: params.AMT_TO,			/* 금액 TO */
	                  
	                  FOR_AMT_FR			: params.FOR_AMT_FR,		/* 외화금액 FR*/
	                  FOR_AMT_TO			: params.FOR_AMT_TO,		/* 외화금액 TO*/
	                  
	                  REMARK				: params.REMARK,			/* 적요	*/

	                  PGM_ID				: 'agb130rkr'
	               	}
	            });
	            win.center();
	            win.show();
	               
	    },
		//당기시작월 세팅
		fnSetStDate: function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        }
	});

};


</script>
