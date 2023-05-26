<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="agj250skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A011" /> <!-- 입력경로 -->	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
	var dataMap;
function appMain() {
	var getStDt = ${getStDt};
	var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Agj250skrModel', {
	    fields: [{name: 'AC_DATE'		 	,text: '전표일' 		,type: 'uniDate'},	    		
				 {name: 'SLIP_NUM'		 	,text: '번호' 		,type: 'string'},	    		
				 {name: 'SLIP_SEQ'		 	,text: '순번' 		,type: 'string'},	    		
				 {name: 'DR_AMT_I'		 	,text: '차변금액' 		,type: 'uniPrice'},	    		
				 {name: 'CR_AMT_I'		 	,text: '대변금액' 		,type: 'uniPrice'},	    		
				 {name: 'MONEY_UNIT'	 	,text: '화폐' 		,type: 'string'},	    		
				 {name: 'EXCHG_RATE_O'	 	,text: '환율' 		,type: 'float' ,decimalPrecision:4, format:'0,000.0000'},	    		
				 {name: 'FOR_AMT_I'		 	,text: '외화금액' 		,type: 'float' ,decimalPrecision:3, format:'0,000.000'},	    		
				 {name: 'REMARK'		 	,text: '적요' 		,type: 'string'},	    		
				 {name: 'AC_DATA1'		 	,text: '코드1' 		,type: 'string'},	    		
				 {name: 'AC_DATA_NAME1'	 	,text: '코드명1' 		,type: 'string'},	    		
				 {name: 'AC_DATA2'		 	,text: '코드2' 		,type: 'string'},	    		
				 {name: 'AC_DATA_NAME2'	 	,text: '코드명2' 		,type: 'string'},	    		
				 {name: 'AC_DATA3'		 	,text: '코드3' 		,type: 'string'},	    		
				 {name: 'AC_DATA_NAME3'	 	,text: '코드명3' 		,type: 'string'},	    		
				 {name: 'AC_DATA4'		 	,text: '코드4' 		,type: 'string'},	    		
				 {name: 'AC_DATA_NAME4'	 	,text: '코드명4' 		,type: 'string'},	    		
				 {name: 'AC_DATA5'		 	,text: '코드5' 		,type: 'string'},	    		
				 {name: 'AC_DATA_NAME5'	 	,text: '코드명5' 		,type: 'string'},	    		
				 {name: 'AC_DATA6'		 	,text: '코드6' 		,type: 'string'},	    		
				 {name: 'AC_DATA_NAME6'	 	,text: '코드명6' 		,type: 'string'},	    		
				 {name: 'DIV_NAME'		 	,text: '사업장' 		,type: 'string'},	    		
				 {name: 'DEPT_CODE'		 	,text: '부서' 		,type: 'string'},	    		
				 {name: 'DEPT_NAME'		 	,text: '부서명' 		,type: 'string'},	    		
				 {name: 'IN_DEPT_CODE'	 	,text: '입력부서' 		,type: 'string'},	    		
				 {name: 'IN_DEPT_NAME'	 	,text: '입력부서명' 	,type: 'string'},	    		
	    		 {name: 'INPUT_PATH_NAME'	,text: '입력경로'		,type: 'string'},
				 {name: 'PEND'			 	,text: '미결' 		,type: 'string'},
				 {name: 'MOD_DIVI'			,text: '수정삭제이력'   ,type: 'string'},
				 {name: 'GUBUN'				,text: 'GUBUN' 		,type: 'string'},
				 {name: 'INPUT_DIVI'		,text: 'INPUT_DIVI' ,type: 'string'}
				 
				 
				 
			]
	});		
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('agj250skrMasterStore1',{
			model: 'Agj250skrModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'agj250skrService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
		        width: 315,
		        allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('AC_DATE_FR',newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('AC_DATE_TO',newValue);
			    	}   	
			    }
	        },		    
	        	Unilite.popup('DEPT',{
		        fieldLabel: '부서',
		        //validateBlank:false,
			    valueFieldName:'DEPT_CODE',
			    textFieldName:'DEPT_NAME',
			    validateBlank:true,
		        autoPopup:true,
	        	listeners: {
					/*onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
						panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));	
	            	},
					scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},*/
	        		onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME', newValue);				
					},
					applyextparam: function(popup){							
						popup.setExtParam({'ACCNT_DIV_CODE': panelSearch.getValue('ACCNT_DIV_CODE')});
					}
				}
		    }),{
		        fieldLabel: '사업장',
			    name:'ACCNT_DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
		    },  
		    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
				allowBlank:false,	    			
				listeners: {
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
							 * ---------------------------------------------------------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
							 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
							 *    PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
							 * */
							var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
							accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
								dataMap = provider;
								var opt = '3'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
								UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);								
								UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
								
								panelResult.down('#result_ViewPopup').setVisible(false);
								panelSearch.down('#serach_ViewPopup').setVisible(false);
								
/*
								
								for(var i = 0; i < 7 ; i++){
									colum += '0'
								}
								var acNum = colum + i 
								*/		
								if(!Ext.isEmpty(provider.AC_NAME1)){
									masterGrid.getColumn('AC_DATA1').setText(provider.AC_NAME1);
									masterGrid.getColumn('AC_DATA_NAME1').setText(provider.AC_NAME1 + '명');
								}else{
									masterGrid.getColumn('AC_DATA1').setText('코드1');
									masterGrid.getColumn('AC_DATA_NAME1').setText('코드명1');
								}
								if(!Ext.isEmpty(provider.AC_NAME2)){
									masterGrid.getColumn('AC_DATA2').setText(provider.AC_NAME2);
									masterGrid.getColumn('AC_DATA_NAME2').setText(provider.AC_NAME2 + '명');
								}else{
									masterGrid.getColumn('AC_DATA2').setText('코드2');
									masterGrid.getColumn('AC_DATA_NAME2').setText('코드명2');
								}
								if(!Ext.isEmpty(provider.AC_NAME3)){
									masterGrid.getColumn('AC_DATA3').setText(provider.AC_NAME3);
									masterGrid.getColumn('AC_DATA_NAME3').setText(provider.AC_NAME3 + '명');
								}else{
									masterGrid.getColumn('AC_DATA3').setText('코드3');
									masterGrid.getColumn('AC_DATA_NAME3').setText('코드명3');
								}
								if(!Ext.isEmpty(provider.AC_NAME4)){
									masterGrid.getColumn('AC_DATA4').setText(provider.AC_NAME4);
									masterGrid.getColumn('AC_DATA_NAME4').setText(provider.AC_NAME4 + '명');
								}else{
									masterGrid.getColumn('AC_DATA4').setText('코드4');
									masterGrid.getColumn('AC_DATA_NAME4').setText('코드명4');
								}
								if(!Ext.isEmpty(provider.AC_NAME5)){
									masterGrid.getColumn('AC_DATA5').setText(provider.AC_NAME5);
									masterGrid.getColumn('AC_DATA_NAME5').setText(provider.AC_NAME5 + '명');
								}else{
									masterGrid.getColumn('AC_DATA5').setText('코드5');
									masterGrid.getColumn('AC_DATA_NAME5').setText('코드명5');
								}
								if(!Ext.isEmpty(provider.AC_NAME6)){
									masterGrid.getColumn('AC_DATA6').setText(provider.AC_NAME6);
									masterGrid.getColumn('AC_DATA_NAME6').setText(provider.AC_NAME6 + '명');
								}else{
									masterGrid.getColumn('AC_DATA6').setText('코드6');
									masterGrid.getColumn('AC_DATA_NAME6').setText('코드명6');
								}
							});
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_CODE', '');
						panelResult.setValue('ACCNT_NAME', '');
						/**
						 * onClear시 removeField..
						 */
						UniAccnt.removeField(panelSearch, panelResult);
					},
					applyextparam: function(popup){
						
					}
				}
		    }),{
			  	xtype: 'container',
			  	//colspan:  ?,
			  	itemId: 'formFieldArea1', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			},{
			  	xtype: 'container',
			  	//colspan:  ?,
			  	itemId: 'serach_ViewPopup', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		},items:[
					Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '관리항목1',
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '관리항목2',
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '관리항목3',
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '관리항목4',
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '관리항목5',
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '관리항목6',
			    	validateBlank:false
			    })]
			 }]
		}, {	
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel: '조건',
				name: 'CHECK',
				xtype: 'uniCheckboxgroup', 
				width: 400, 
				items: [{
		        	boxLabel: '수정삭제이력표시',
		        	name: 'INCLUDE_DELETE',
		        	uncheckedValue: 'N',
	        		inputValue: 'Y'
		        }]
			},{
				fieldLabel: ' ',
				name: 'CHECK',
				xtype: 'uniCheckboxgroup', 
				width: 400, 
				items: [{
		        	boxLabel: '미결',
		        	name: 'PEND',
		        	uncheckedValue: 'N',
	        		inputValue: 'Y'
		        },{
		        	boxLabel: '각주',
		        	name: 'POSTIT_YN',
		        	uncheckedValue: 'N',
	        		inputValue: 'Y',
	        		listeners: {
       				 	change: function(field, newValue, oldValue, eOpts) {
       				 		if(panelSearch.getValue('POSTIT_YN')) {
								panelSearch.getField('POSTIT').setReadOnly(false);
       				 		} else {
								panelSearch.getField('POSTIT').setReadOnly(true);
       				 		}
						}
		        	}
				}]
			}, {
		    	xtype: 'uniTextfield',
		    	fieldLabel: '각주',
		    	width: 325,
		    	readOnly: true,
		    	name:'POSTIT'
		    }, {
    			fieldLabel: '입력경로'	,
    			name:'INPUT_PATH_NAME', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A011',
    			width:325
    		}, {
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'금액', 
					xtype: 'uniNumberfield',
					name: 'AMT_I_FR', 
					width:203
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
					name: 'AMT_I_TO', 
					width: 112
				}]
			}, {
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'외화금액', 
					xtype: 'uniNumberfield',
					name: 'FOR_AMT_I_FR', 
					width:203
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
					name: 'FOR_AMT_I_TO', 
					width: 112
				}]
			},	
	       		Unilite.popup('ACCNT_PRSN',{
		    	fieldLabel: '입력자',
		    	validateBlank:false,
		    	autoPopup:false,
		    	valueFieldName:'CHARGE_CODE',
			    textFieldName:'CHARGE_NAME'
		    }),   
	        	Unilite.popup('DEPT',{
			        fieldLabel: '입력부서',
			        //validateBlank:false,
				    valueFieldName:'IN_DEPT_CODE',
				    textFieldName:'IN_DEPT_NAME',
				    validateBlank:true,
		        	autoPopup:true,
		        	listeners: {
						applyextparam: function(popup){							
							popup.setExtParam({'ACCNT_DIV_CODE': panelResult.getValue('ACCNT_DIV_CODE')});
						}
					}
		    }),{
                xtype: 'uniTextfield',
                name: 'REMARK',
                fieldLabel: '적요',
                width: 325
            }]		
		}]
	});  

	var panelResult = Unilite.createSearchForm('panelResultForm', {		
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items : [{ 
			fieldLabel: '전표일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'AC_DATE_FR',
	        endFieldName: 'AC_DATE_TO',
	        //width: 470,
	        startDate: UniDate.get('startOfMonth'),
	        endDate: UniDate.get('today'),
	        allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('AC_DATE_FR',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('AC_DATE_TO',newValue);
			    	}   	
			    }
        },   
        	Unilite.popup('DEPT',{
	        fieldLabel: '부서',
	        //validateBlank:false,
		    valueFieldName:'DEPT_CODE',
		    textFieldName:'DEPT_NAME',
		    validateBlank:true,
		    autoPopup:true,
        	listeners: {
				/*onSelected: {
				fn: function(records, type) {
					console.log('records : ', records);
					panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
					panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));	
            	},
				scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('DEPT_CODE', '');
					panelSearch.setValue('DEPT_NAME', '');
				},*/
        		onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);				
				},
				applyextparam: function(popup){							
					popup.setExtParam({'ACCNT_DIV_CODE': panelResult.getValue('ACCNT_DIV_CODE')});
				}
			}
	    }), 
	    	Unilite.popup('ACCNT',{
			    	fieldLabel: '계정과목',
					allowBlank:false,
					listeners: {
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
									dataMap = provider;
									var opt = '3'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용						
									UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
									UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);
									
									panelResult.down('#result_ViewPopup').setVisible(false);
									panelSearch.down('#serach_ViewPopup').setVisible(false);					
												
									if(!Ext.isEmpty(provider.AC_NAME1)){
										masterGrid.getColumn('AC_DATA1').setText(provider.AC_NAME1);
										masterGrid.getColumn('AC_DATA_NAME1').setText(provider.AC_NAME1 + '명');
									}else{
										masterGrid.getColumn('AC_DATA1').setText('코드1');
										masterGrid.getColumn('AC_DATA_NAME1').setText('코드명1');
									}
									if(!Ext.isEmpty(provider.AC_NAME2)){
										masterGrid.getColumn('AC_DATA2').setText(provider.AC_NAME2);
										masterGrid.getColumn('AC_DATA_NAME2').setText(provider.AC_NAME2 + '명');
									}else{
										masterGrid.getColumn('AC_DATA2').setText('코드2');
										masterGrid.getColumn('AC_DATA_NAME2').setText('코드명2');
									}
									if(!Ext.isEmpty(provider.AC_NAME3)){
										masterGrid.getColumn('AC_DATA3').setText(provider.AC_NAME3);
										masterGrid.getColumn('AC_DATA_NAME3').setText(provider.AC_NAME3 + '명');
									}else{
										masterGrid.getColumn('AC_DATA3').setText('코드3');
										masterGrid.getColumn('AC_DATA_NAME3').setText('코드명3');
									}
									if(!Ext.isEmpty(provider.AC_NAME4)){
										masterGrid.getColumn('AC_DATA4').setText(provider.AC_NAME4);
										masterGrid.getColumn('AC_DATA_NAME4').setText(provider.AC_NAME4 + '명');
									}else{
										masterGrid.getColumn('AC_DATA4').setText('코드4');
										masterGrid.getColumn('AC_DATA_NAME4').setText('코드명4');
									}
									if(!Ext.isEmpty(provider.AC_NAME5)){
										masterGrid.getColumn('AC_DATA5').setText(provider.AC_NAME5);
										masterGrid.getColumn('AC_DATA_NAME5').setText(provider.AC_NAME5 + '명');
									}else{
										masterGrid.getColumn('AC_DATA5').setText('코드5');
										masterGrid.getColumn('AC_DATA_NAME5').setText('코드명5');
									}
									if(!Ext.isEmpty(provider.AC_NAME6)){
										masterGrid.getColumn('AC_DATA6').setText(provider.AC_NAME6);
										masterGrid.getColumn('AC_DATA_NAME6').setText(provider.AC_NAME6 + '명');
									}else{
										masterGrid.getColumn('AC_DATA6').setText('코드6');
										masterGrid.getColumn('AC_DATA_NAME6').setText('코드명6');
									}
								})
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ACCNT_CODE', '');
							panelSearch.setValue('ACCNT_NAME', '');
							/**
							 * onClear시 removeField..
							 */
							UniAccnt.removeField(panelSearch, panelResult);
						},
						applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE,
                                    'ADD_QUERY': "group_yn = 'N'"
                                }
                                popup.setExtParam(param);
                            }
                        }
					}
		    }),{
		        fieldLabel: '사업장',
			    name:'ACCNT_DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
		    },{
			  	xtype: 'container',
			  	colspan: 3,
			  	itemId: 'formFieldArea1', 
			  	layout: {
			   		type: 'table', 
			   		columns:2,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}	
			},{
				xtype:'container',
				itemId:'result_ViewPopup',
				colspan: 3,
				layout: {
					type: 'table', 
			   		columns:2,
			   		itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
					}
				},
				items:[
					Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '관리항목1',
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '관리항목2',
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '관리항목3',
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '관리항목4',
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '관리항목5',
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '관리항목6',
			    	validateBlank:false
			    })
			]
		}
	]}); 

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agj250skrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: MasterStore,
    	uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,			
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false } ],
        columns:  [ { dataIndex:'AC_DATE'		 	,		width:100	,
		        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
		            	},
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							var dateSet = UniDate.getDbDateStr(val).substring(0, 4) +'.'+ 
							              UniDate.getDbDateStr(val).substring(4, 6) +'.'+ 
							              UniDate.getDbDateStr(val).substring(6, 8)	
							
							if(record.get("MOD_DIVI") == "D"){	              
								return '<font color="red">' + dateSet + '</font>' ;
							}
							else{
								return dateSet;
							}
						}	
					},			
					{ dataIndex:'SLIP_NUM'		 	,		width:60	, align : 'center' /*, 
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					},				
					{ dataIndex:'SLIP_SEQ'		 	,		width:60	, align : 'center' /*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}, 				
					{ dataIndex:'DR_AMT_I'		 	,		width:160	, summaryType: 'sum' /*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + Ext.util.Format.number(val,'0,000'); + '</font>' ;
							}
							else{
								return Ext.util.Format.number(val,'0,000');
							}
						}*/
					}, 								
					{ dataIndex:'CR_AMT_I'		 	,		width:160	, summaryType: 'sum' /*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + Ext.util.Format.number(val,'0,000') + '</font>' ;
							}
							else{
								return Ext.util.Format.number(val,'0,000');
							}
						}*/
					}, 								
					{ dataIndex:'MONEY_UNIT'	 	,		width:60	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}, 								
					{ dataIndex:'EXCHG_RATE_O'	 	,		width:100	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + Ext.util.Format.number(val,'0,000') + '</font>' ;
							}
							else{
								return Ext.util.Format.number(val,'0,000');
							}
						}*/
					}, 				 				
					{ dataIndex:'FOR_AMT_I'		 	,		width:100	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + Ext.util.Format.number(val,'0,000') + '</font>' ;
							}
							else{
								return Ext.util.Format.number(val,'0,000');
							}
						}*/
					}, 				 				
					{ dataIndex:'REMARK'		 	,		width:350	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + Ext.util.Format.number(val,'0,000') + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}, 				 				
					{ dataIndex: 'AC_DATA1'      	,width:100,
    					renderer:function(value, metaData, record)	{
//							dataMap;
							var r = value;
							if(dataMap.AC_FORMAT1 == 'I'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT1 == 'O'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
							} else if(dataMap.AC_FORMAT1 == 'R'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
							} else if(dataMap.AC_FORMAT1 == 'P'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT1 == 'Q'){ 
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
							}
							return r;
    					}
					}, 				 				
					{ dataIndex:'AC_DATA_NAME1'	 	,		width:160	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}, 								
					{ dataIndex: 'AC_DATA2'      	,width:100,
    					renderer:function(value, metaData, record)	{
							var r = value;
							if(dataMap.AC_FORMAT2 == 'I'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT2 == 'O'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
							} else if(dataMap.AC_FORMAT2 == 'R'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
							} else if(dataMap.AC_FORMAT2 == 'P'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT2 == 'Q'){ 
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
							}
							return r;
    					}
					}, 				 				
					{ dataIndex:'AC_DATA_NAME2'	 	,		width:160	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}, 				 				
					{ dataIndex: 'AC_DATA3'      	,width:100,
    					renderer:function(value, metaData, record)	{
							var r = value;
							if(dataMap.AC_FORMAT3 == 'I'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT3 == 'O'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
							} else if(dataMap.AC_FORMAT3 == 'R'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
							} else if(dataMap.AC_FORMAT3 == 'P'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT3 == 'Q'){ 
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
							}
							return r;
    					}
					}, 				 				
					{ dataIndex:'AC_DATA_NAME3'	 	,		width:160	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}, 				 				
					{ dataIndex: 'AC_DATA4'      	,width:100,
    					renderer:function(value, metaData, record)	{
							var r = value;
							if(dataMap.AC_FORMAT4 == 'I'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT4 == 'O'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
							} else if(dataMap.AC_FORMAT4 == 'R'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
							} else if(dataMap.AC_FORMAT4 == 'P'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT4 == 'Q'){ 
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
							}
							return r;
    					}
					}, 				 				
					{ dataIndex:'AC_DATA_NAME4'	 	,		width:160	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}, 				 				
					{ dataIndex: 'AC_DATA5'      	,width:100,
    					renderer:function(value, metaData, record)	{
							var r = value;
							if(dataMap.AC_FORMAT5 == 'I'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT5 == 'O'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
							} else if(dataMap.AC_FORMAT5 == 'R'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
							} else if(dataMap.AC_FORMAT5 == 'P'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT5 == 'Q'){ 
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
							}
							return r;
    					}
					}, 				 				
					{ dataIndex:'AC_DATA_NAME5'	 	,		width:160	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}, 				 				
					{ dataIndex:'AC_DATA6'		 	,		width:100,
    					renderer:function(value, metaData, record)	{
							var r = value;
							if(dataMap.AC_FORMAT6 == 'I'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT6 == 'O'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
							} else if(dataMap.AC_FORMAT6 == 'R'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
							} else if(dataMap.AC_FORMAT6 == 'P'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT6 == 'Q'){ 
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
							}
							return r;
    					}
					}, 				 				
					{ dataIndex:'AC_DATA_NAME6'	 	,		width:160	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}, 							
					{ dataIndex:'DIV_NAME'		 	,		width:120	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}, 				 				
					{ dataIndex:'DEPT_CODE'		 	,		width:100	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}, 				 				
					{ dataIndex:'DEPT_NAME'		 	,		width:150	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}, 				 				
					{ dataIndex:'PEND'			 	,		width:120	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					},					 
					{ dataIndex:'INPUT_PATH'		,		width:120	/*,
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("MOD_DIVI") == "D"){
								return '<font color="red">' + val + '</font>' ;
							}
							else{
								return val;
							}
						}*/
					}						 
        ],
		listeners: {
	      	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
    		},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom && !Ext.isEmpty(record.data['AC_DATE'])) {
					var params = {
							action:'select',
							'PGM_ID'     : 'agj250skr',	   /* gsParam(0) */
							'AC_DATE'    : record.data['AC_DATE'],	   /* gsParam(0) */
							'AC_DATE'    : record.data['AC_DATE'],	   /* gsParam(1) */	
							'INPUT_PATH' : record.data['INPUT_PATH'],  /* gsParam(2) */	
							'SLIP_NUM'   : record.data['SLIP_NUM'],	   /* gsParam(3) */	
							'SLIP_SEQ'   : record.data['SLIP_SEQ'],	   /* gsParam(4) */	
							//''   : record.data[''],/* gsParam(5) */	
							'DIV_CODE'   : record.data['DIV_CODE']	   /* gsParam(6) */	
						}
					if(record.data['GUBUN'] == '2'){
						return false;
					}else{
						if(record.data['INPUT_DIVI'] == '2'){	
							var rec = {data : {prgID : 'agj205ukr', 'text':''}};									
							parent.openTab(rec, '/accnt/agj205ukr.do', params);
						}
						else if(record.data['INPUT_PATH'] == 'Z3'){
							var rec = {data : {prgID : 'dgj100ukr', 'text':''}};									
							parent.openTab(rec, '/accnt/dgj100ukr.do', params);
						}
						else{
							var rec = {data : {prgID : 'agj200ukr', 'text':''}};									
							parent.openTab(rec, '/accnt/agj200ukr.do', params);
						}
					}
          		}
          	}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
			var inputDivi	= record.data['INPUT_DIVI'];

			if (inputDivi == '2'){
	      		menu.down('#linkAgj200ukr').hide();
	      		menu.down('#linkDgj100ukr').hide();
	      		
				menu.down('#linkAgj205ukr').show();
			
			} else if (inputDivi == 'Z3'){
	      		menu.down('#linkAgj200ukr').hide();
	      		menu.down('#linkAgj205ukr').hide();
	      		
				menu.down('#linkDgj100ukr').show();
				
			} else {
	      		menu.down('#linkAgj205ukr').hide();
	      		menu.down('#linkDgj100ukr').hide();
	      		
				menu.down('#linkAgj200ukr').show();
			}
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
	            			'PGM_ID'		: 'agj250skr',
							'AC_DATE' 		: record.data['AC_DATE'],
							'INPUT_PATH'	: record.data['INPUT_PATH'],
							'SLIP_NUM'		: record.data['SLIP_NUM'],
							'SLIP_SEQ'		: record.data['SLIP_SEQ'],
							'DIV_CODE'		: panelSearch.getValue('DIV_CODE')
	            		};
	            		masterGrid.gotoAgj200ukr(param);
	            	}
	        	},{
	        		text: '회계전표입력(전표번호별) 보기',   
	            	itemId	: 'linkAgj205ukr',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID'		: 'agj250skr',
							'AC_DATE' 		: record.data['AC_DATE'],
							'INPUT_PATH'	: record.data['INPUT_PATH'],
							'SLIP_NUM'		: record.data['SLIP_NUM'],
							'SLIP_SEQ'		: record.data['SLIP_SEQ'],
							'DIV_CODE'		: panelSearch.getValue('DIV_CODE')
	            		};
	            		masterGrid.gotoAgj205ukr(param);
	            	}
	        	},{
	        		text: 'dgj100ukr 보기',   
	            	itemId	: 'linkDgj100ukr',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID'		: 'agj250skr',
							'AC_DATE' 		: record.data['AC_DATE'],
							'INPUT_PATH'	: record.data['INPUT_PATH'],
							'SLIP_NUM'		: record.data['SLIP_NUM'],
							'SLIP_SEQ'		: record.data['SLIP_SEQ'],
							'DIV_CODE'		: panelSearch.getValue('DIV_CODE')
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
    	}   
    });   
	
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, panelResult
			]	
		}		
		,panelSearch
		],
		id  : 'agj250skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			panelResult.setValue('AC_DATE_TO',UniDate.get('today'));
			
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE_FR');
			
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}else{
				MasterStore.loadStoreRecords();	
				UniAppManager.setToolbarButtons('reset', true);
				
				var viewNormal = masterGrid.getView();
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			}	
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			
			var viewNormal = masterGrid.getView();
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			
			this.fnInitBinding();
		}
	});

};


</script>
