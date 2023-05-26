<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd320ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A140" /> <!-- 결제유형-->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> <!-- 증빙구분-->
	<t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 전표승인여부-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	var gsChargeCode = '${getChargeCode}';	
	var checkCount = 0;
	var isRdoQuery = true; //화면 처음 열릴때 또는 신규버튼 눌렀을시 쿼리 않타게 하기 위해서...
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agd320ukrModel', {
	    fields: [  	  
	    	{name: 'CHOICE'        		, text: '선택' 			,type: 'boolean'},
		    {name: 'COMP_CODE'			, text: '법인코드'			,type: 'string'},
		    {name: 'DIV_CODE'			, text: '사업장' 			,type: 'string', comboType:'BOR120'},
		    {name: 'ASST'	        	, text: '자산코드' 		,type: 'string'},
		    {name: 'ASST_NAME'     		, text: '자산명' 			,type: 'string'},
		    {name: 'ACQ_DATE'			, text: '취득일' 			,type: 'uniDate'},
		    {name: 'ACCNT'		    	, text: '계정과목' 		,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '계정명' 			,type: 'string'},
		    {name: 'ACQ_AMT_I'			, text: '취득가액' 		,type: 'uniPrice'},
		    {name: 'SET_TYPE'	    	, text: '결제유형' 		,type: 'string', comboType: 'AU',  comboCode: 'A140'},
		    {name: 'PROOF_KIND'			, text: '증빙유형' 		,type: 'string', comboType: 'AU',  comboCode: 'A022'},
		    {name: 'CUSTOM_CODE'		, text: '거래처' 			,type: 'string'},
		    {name: 'CUSTOM_NAME'		, text: '거래처명' 		,type: 'string'},
		    {name: 'DEPT_CODE'			, text: '부서코드' 		,type: 'string'},
		    {name: 'DEPT_NAME'			, text: '부서명' 			,type: 'string'},
		    {name: 'SUPPLY_AMT_I'		, text: '공급가액' 		,type: 'uniPrice'},
		    {name: 'TAX_AMT_I'			, text: '세액' 			,type: 'uniPrice'},
		    {name: 'TOTAL_AMT_I'   		, text: '합계' 			,type: 'uniPrice'},
		    {name: 'EX_DATE'      		, text: '결의전표일' 		,type: 'uniDate'},
		    {name: 'EX_NUM'				, text: '전표번호' 		,type: 'string'},
		    {name: 'AP_STS'				, text: '승인여부' 		,type: 'string', comboType: 'AU',  comboCode: 'A014'},
		    {name: 'SAVE_CODE'			, text: '통장번호' 		,type: 'string'},
		    {name: 'SAVE_NAME'			, text: '신용카드번호' 		,type: 'string'},
		    {name: 'CRDT_NUM'			, text: '불공제사유' 		,type: 'string'},
		    {name: 'CRDT_NAME'			, text: '지급예정일' 		,type: 'uniDate'},
		    {name: 'REASON_CODE'		, text: '전자발행여부' 		,type: 'string'},
		    {name: 'PAY_DATE'			, text: '입력자' 			,type: 'string'},
		    {name: 'EB_YN'				, text: '입력일' 			,type: 'uniDate'},
		    {name: 'INSERT_DB_USER'		, text: '수정자' 			,type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '수정일' 			,type: 'uniDate'},
			{name: 'UPDATE_DB_USER' 	, text: '수정자' 			,type: 'string'},
			{name: 'UPDATE_DB_TIME' 	, text: '수정일' 			,type: 'string'}
		]          
	});
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agd320ukrMasterStore1',{
		model: 'Agd320ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agd320ukrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
        listeners:{
        	load:function(store, records, successful, eOpts)	{
        		if(panelResult.down('#work').getChecked()[0].inputValue == "CANC"){
    				panelSearch.down('#cboApSts').show(); 	//전표승인여부
    				panelResult.down('#cboApSts').show();
        		}else{
        			panelSearch.down('#cboApSts').hide(); 
    				panelResult.down('#cboApSts').hide();
        		}
        		
        		if(store.count() == 0){
        			panelSearch.down('#btnAutoSlip').disable();
        			panelSearch.down('#btnAllAutoSlip').disable();
        			panelSearch.down('#btnAllSelect').disable(); 
        			panelResult.down('#btnAutoSlip').disable();
        			panelResult.down('#btnAllAutoSlip').disable();
        			panelResult.down('#btnAllSelect').disable();
        		}else{
        			panelSearch.down('#btnAutoSlip').enable();
        			panelSearch.down('#btnAllAutoSlip').enable();
        			panelSearch.down('#btnAllSelect').enable();
        			panelResult.down('#btnAutoSlip').enable();
        			panelResult.down('#btnAllAutoSlip').enable();
        			panelResult.down('#btnAllSelect').enable();
        			if(panelResult.down('#work').getChecked()[0].inputValue == "CANC"){
        				panelSearch.down('#btnViewAutoSlip').enable();
        				panelResult.down('#btnViewAutoSlip').enable();	
        			}else{
        				panelSearch.down('#btnViewAutoSlip').disable();
        				panelResult.down('#btnViewAutoSlip').disable();
        			}
        		}
        		panelResult.down('#btnAllSelect').setText('전체선택');
				panelSearch.down('#btnAllSelect').setText('전체선택');
        		panelSearch.setValue('SELECTED_AMT', 0);
        		panelResult.setValue('SELECTED_AMT', 0);
        	}
        	
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
           	layout : {type : 'uniTable', columns : 1, tableAttrs: {width: '100%'}},
           	defaultType: 'uniTextfield',
		    items: [{ 
	        	fieldLabel: '취득일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_ACQ_DATE',
				endFieldName: 'TO_ACQ_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_ACQ_DATE', newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_ACQ_DATE',newValue);
			    	}   	
			    }
			},
				Unilite.popup('ACCNT',{ 
//					validateBlank: false,
					autoPopup: true,
			    	fieldLabel: '계정과목',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
								panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ACCNT_CODE', '');
							panelResult.setValue('ACCNT_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
							popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
						}
					}
			}),{ 
	        	fieldLabel: '입력일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_INSERT_DATE',
				endFieldName: 'TO_INSERT_DATE',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_INSERT_DATE',newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_INSERT_DATE',newValue);
			    	}   	
			    }
			},
				Unilite.popup('ASSET',{ 
					autoPopup: true,
			    	fieldLabel: '자산코드', 
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ASSET_CODE', panelSearch.getValue('ASSET_CODE'));
								panelResult.setValue('ASSET_NAME', panelSearch.getValue('ASSET_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ASSET_CODE', '');
							panelResult.setValue('ASSET_NAME', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				value : UserInfo.divCode,
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				xtype: 'container',
				items:[{
					xtype:'container',
	//				hidden: true,					
					items:[{ 
						fieldLabel: '전표승인여부',
	//					hidden: true,
						itemId: 'cboApSts',
						name: 'AP_STS',
						xtype: 'uniCombobox',
						value : UserInfo.divCode,
						comboType: 'AU',
						comboCode: 'A014',					
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('AP_STS', newValue);
							}
						}
					}]
				}]
			},{
				xtype: 'container',
				tdAttrs: {align: 'center'},
				layout:{type : 'uniTable', columns : 1, tableAttrs: {width: '98%'}},
				items:[{
					xtype: 'component',
					tdAttrs: {style: 'border-bottom: 1.3px solid #cccccc;'}
				}]
			},{
				layout: {type:'hbox'},
				xtype: 'container',
				padding: '6 0 0 0',
				items: [{
					fieldLabel: '일괄기표전표일',
					xtype: 'uniDatefield',	            		
					name: 'PROC_DATE',	
			 		allowBlank:false,
					flex:2,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('PROC_DATE', newValue);
						}
					}
				},{
					xtype: 'radiogroup',
					itemId: 'dateOption',
					items: [{
						boxLabel: '취득일', 
						width: 60, 
						name: 'DATE_OPTION',						
						inputValue: '1' 
					},{
						boxLabel : '실행일', 
						width: 70,
						name: 'DATE_OPTION',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(newValue.DATE_OPTION == "1"){
								panelSearch.getField('PROC_DATE').setReadOnly(true);
								panelResult.getField('PROC_DATE').setReadOnly(true);
							}else{
								panelSearch.getField('PROC_DATE').setReadOnly(false);
								panelResult.getField('PROC_DATE').setReadOnly(false);
							}
							panelResult.getField('DATE_OPTION').setValue(newValue.DATE_OPTION);							
						}
					}
				}]
		
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '작업구분',
				itemId: 'work',
				items: [{
					boxLabel: '자동기표', 
					width: 70, 
					name: 'WORK',
					inputValue: 'PROC'
				},{
					boxLabel : '기표취소', 
					width: 70,
					name: 'WORK',
					inputValue: 'CANC'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('WORK').setValue(newValue.WORK);
						if(isRdoQuery) directMasterStore.loadStoreRecords();
						if(newValue.WORK == "PROC"){
							panelSearch.down('#btnAutoSlip').tdAttrs = {align: 'left', width: 89};
							panelSearch.down('#btnAutoSlip').setText('개별자동기표');							
							panelSearch.down('#btnAllAutoSlip').show();							
							panelResult.down('#btnAutoSlip').tdAttrs = {align: 'left', width: 89};
							panelResult.down('#btnAutoSlip').setText('개별자동기표');							
							panelResult.down('#btnAllAutoSlip').show();
						}else{
							panelSearch.down('#btnAutoSlip').tdAttrs = {align: 'left', width: 102};
							panelSearch.down('#btnAutoSlip').setText('기표취소');
							panelSearch.down('#btnAllAutoSlip').hide();
							panelResult.down('#btnAutoSlip').tdAttrs = {align: 'left', width: 102};
							panelResult.down('#btnAutoSlip').setText('기표취소');
							panelResult.down('#btnAllAutoSlip').hide();
						}
						
					}
				}
			},{
				fieldLabel: '합계',
				name:'SELECTED_AMT',	
				xtype: 'uniNumberfield',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SELECTED_AMT', newValue);
					}
				}
			}, {
//			   width: 100,
	           xtype: 'button',
			   text: '자동기표조회',	
			   itemId: 'btnViewAutoSlip',
			   tdAttrs: {align: 'left', width: 102},
			   margin: '0 0 0 245',
			   handler : function() {
			   	
			   }
	        }, {
				xtype: 'container',
				colspan: 2,
				tdAttrs: {align: 'right'},
				layout: {type: 'uniTable', columns: 3},
				items:[{
					xtype: 'button',
					text: '전체선택',
					width: 62,
					itemId: 'btnAllSelect',
					tdAttrs: {align: 'left', width: 65},
					handler : function() {
						var records = directMasterStore.data.items;
						if(records.length < 1) return false;
						var bChecked = true;						
//						alert(panelResult.down('#btnAllSelect').getText());
						if(panelResult.down('#btnAllSelect').getText() == "취소"){
							bChecked = false;
							checkCount = 0;
						}
						Ext.each(records, function(record, i){
							if(record.get('AP_STS') != "2"){
								if(Ext.isEmpty(record.get('SET_TYPE'))){
									return false;
								}
								record.set('CHOICE', bChecked);
								if(bChecked) checkCount++;
							}
						});
						if(checkCount > 0){
							panelResult.down('#btnAllSelect').setText('취소');
							panelSearch.down('#btnAllSelect').setText('취소');
						}else{
							panelResult.down('#btnAllSelect').setText('전체선택');
							panelSearch.down('#btnAllSelect').setText('전체선택');
//							UniAppManager.setToolbarButtons('save',false);
						}
						UniAppManager.app.fnCalcSelectedAmt();
						UniAppManager.setToolbarButtons('save',false);
					}
		        },{
		           xtype: 'button',
				   text: '개별자동기표',
				   itemId: 'btnAutoSlip',
				   width: 87,
				   tdAttrs: {align: 'left', width: 89},
				   handler : function() {
					
				   }
		        },{
		           xtype: 'button',
				   text: '일괄자동기표',				   
				   itemId: 'btnAllAutoSlip',
				   tdAttrs: {align: 'left', width: 102},
				   handler : function() {
				   	
				   }
		        }]
			}]
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 1, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			xtype: 'container',
			layout:{type : 'uniTable', columns : 2},
			items:[{ 
	        	fieldLabel: '취득일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_ACQ_DATE',
				endFieldName: 'TO_ACQ_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_ACQ_DATE',newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_ACQ_DATE',newValue);
			    	}   	
			    }
			},
				Unilite.popup('ACCNT',{ 
					autoPopup: true,
					labelWidth: 196,
			    	fieldLabel: '계정과목',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
								panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ACCNT_CODE', '');
							panelSearch.setValue('ACCNT_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
							popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
						}
					}
			}),{ 
	        	fieldLabel: '입력일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_INSERT_DATE',
				endFieldName: 'TO_INSERT_DATE',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_INSERT_DATE',newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_INSERT_DATE',newValue);
			    	}   	
			    }
			},
				Unilite.popup('ASSET',{ 
					autoPopup: true,
					labelWidth: 196,
			    	fieldLabel: '자산코드', 
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ASSET_CODE', panelResult.getValue('ASSET_CODE'));
								panelSearch.setValue('ASSET_NAME', panelResult.getValue('ASSET_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ASSET_CODE', '');
							panelSearch.setValue('ASSET_NAME', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				value : UserInfo.divCode,
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				xtype: 'container',
				items:[{
					xtype:'container',
	//				hidden: true,					
					items:[{ 
						fieldLabel: '전표승인여부',
						labelWidth: 196,
	//					hidden: true,
						name: 'AP_STS',
						itemId: 'cboApSts',
						xtype: 'uniCombobox',
						value : UserInfo.divCode,
						comboType: 'AU',
						comboCode: 'A014',					
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('AP_STS', newValue);
							}
						}
					}]
				}]
			}]
		},{
			xtype: 'container',
			tdAttrs: {align: 'center'},
			layout:{type : 'uniTable', columns : 1, tableAttrs: {width: '99%'}},
			items:[{
				xtype: 'component',
				tdAttrs: {style: 'border-bottom: 1.3px solid #cccccc;'}
			}]
		},{
			xtype: 'container',
			layout:{type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
			items:[{
				layout: {type : 'uniTable', columns : 2},
				tdAttrs: {width: 420},
				xtype: 'container',
				items: [{
					fieldLabel: '일괄기표전표일',
					xtype: 'uniDatefield',	            		
					name: 'PROC_DATE',					
			 		allowBlank:false,
					flex:2,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('PROC_DATE', newValue);
						}
					}
				},{
					xtype: 'radiogroup',
					itemId: 'dateOption',
					items: [{
						boxLabel: '취득일', 
						width: 60, 
						name: 'DATE_OPTION',
						inputValue: '1'  
					},{
						boxLabel : '실행일', 
						width: 70,
						name: 'DATE_OPTION',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {	
							if(newValue.DATE_OPTION == "1"){
								panelSearch.getField('PROC_DATE').setReadOnly(true);
								panelResult.getField('PROC_DATE').setReadOnly(true);
							}
							panelSearch.getField('DATE_OPTION').setValue(newValue.DATE_OPTION);
						}
					}
				}]
		
			},{
				xtype: 'radiogroup',
				tdAttrs: {align: 'left'},
				itemId: 'work',
				fieldLabel: '작업구분',
				items: [{
					boxLabel: '자동기표', 
					width: 70, 
					name: 'WORK',
					inputValue: 'PROC'
				},{
					boxLabel : '기표취소', 
					width: 70,
					name: 'WORK',
					inputValue: 'CANC'  
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('WORK').setValue(newValue.WORK);
						if(isRdoQuery) directMasterStore.loadStoreRecords();
					}
				}
			},{
//			   width: 100,
	           xtype: 'button',
			   text: '자동기표조회',	
			   itemId: 'btnViewAutoSlip',
			   tdAttrs: {align: 'left', width: 102},
			   margin: '0 5 0 0',
			   handler : function() {
			   		var record = masterGrid.getSelectedRecord();
					var params = {
						appId: UniAppManager.getApp().id,
						sender: this,
						action: 'new',
						EX_DATE: record.get('EX_DATE'),
						INOUT_PATH: '59',
						EX_NUM: record.get('EX_NUM'),
						EX_SEQ: '1',
						AP_STS: record.get('AP_STS'),
						DIV_CODE: record.get('DIV_CODE')
					}
					var rec = {data : {prgID : 'agj105ukr', 'text':''}};									
					parent.openTab(rec, '/accnt/agj105ukr.do', params)
			   }
	        },{ 
				fieldLabel: '합계',
				name:'SELECTED_AMT',	
				xtype: 'uniNumberfield',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SELECTED_AMT', newValue);
					}
				}
			}, {
				xtype: 'container',
				colspan: 2,
				tdAttrs: {align: 'right'},
				layout: {type: 'uniTable', columns: 3},
				items:[{
					xtype: 'button',
					text: '전체선택',
					width: 63,
					margin: '0 0 2 0',
					itemId: 'btnAllSelect',
					tdAttrs: {align: 'left', width: 65},
					handler : function() {
						var records = directMasterStore.data.items;
						if(records.length < 1) return false;
						var bChecked = true;						
//						alert(panelResult.down('#btnAllSelect').getText());
						if(panelResult.down('#btnAllSelect').getText() == "취소"){
							bChecked = false;
							checkCount = 0;
						}
						Ext.each(records, function(record, i){
							if(record.get('AP_STS') != "2"){
								if(Ext.isEmpty(record.get('SET_TYPE'))){
									return false;
								}
								record.set('CHOICE', bChecked);
								if(bChecked) checkCount++;
							}
						});
						if(checkCount > 0){
							panelResult.down('#btnAllSelect').setText('취소');
							panelSearch.down('#btnAllSelect').setText('취소');
						}else{
							panelResult.down('#btnAllSelect').setText('전체선택');
							panelSearch.down('#btnAllSelect').setText('전체선택');
//							UniAppManager.setToolbarButtons('save',false);
						}
						UniAppManager.app.fnCalcSelectedAmt();
						UniAppManager.setToolbarButtons('save',false);
						
					}
		        },{
		           xtype: 'button',
				   text: '개별자동기표',
				   itemId: 'btnAutoSlip',
				   width: 87,
				   margin: '0 0 2 0',
				   tdAttrs: {align: 'left', width: 89},
				   handler : function() {
					
				   }
		        },{
		           xtype: 'button',
				   text: '일괄자동기표',		
				   margin: '0 0 2 0',
				   itemId: 'btnAllAutoSlip',
				   tdAttrs: {align: 'left', width: 102},
				   handler : function() {
				   	
				   }
		        }]
			}]
		}]
			 	
    });
	
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('agd320ukrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt:{	
        	expandLastColumn: true,
			useRowNumberer: true,
            useMultipleSorting: true,
   			useRowContext : true
        },
      /*  tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],*/
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [   
        	{dataIndex: 'COMP_CODE'				, width: 100 , hidden: true},
        	{dataIndex: 'CHOICE'        		, width: 40 , xtype: 'checkcolumn', align:'center', locked: true,
        		listeners: {
        			checkchange: function(CheckColumn, rowIndex, checked, eOpts){
        				var grdRecord = masterGrid.getStore().getAt(rowIndex);
        				if(checked == true){
        					if(Ext.isEmpty(grdRecord.get('SET_TYPE'))){
        						alert('결제유형을 선택한 자료만 자동기표할 수 있습니다.');
        						grdRecord.set('CHOICE',false);
        						return false; 
        					}
        					checkCount++;
        					UniAppManager.app.fnCalcSelectedAmt();
        					
        				}else{
        					if(panelResult.down('#btnAllSelect').getText() == "취소"){
        						panelSearch.down('#btnAllSelect').setText('전체선택');
								panelResult.down('#btnAllSelect').setText('전체선택');
							}
        					checkCount--;
        					UniAppManager.app.fnCalcSelectedAmt();
        				}
        				if(checkCount == 0){
//			    			UniAppManager.setToolbarButtons('save',false);
			    		}else{
//			    			UniAppManager.setToolbarButtons('save',true);
			    		}
			    		UniAppManager.setToolbarButtons('save',false);
//			    		alert(checkCount);
        			}
        		}
        	}, 								
			{dataIndex: 'DIV_CODE'				, width: 106},
			{dataIndex: 'ASST'	        		, width: 80 },
			{dataIndex: 'ASST_NAME'     		, width: 166}, 					
			{dataIndex: 'ACQ_DATE'				, width: 80 },
			{dataIndex: 'ACCNT'		    		, width: 66},
			{dataIndex: 'ACCNT_NAME'			, width: 120}, 					
			{dataIndex: 'ACQ_AMT_I'				, width: 100},
			{dataIndex: 'SET_TYPE'	    		, width: 100},
			{dataIndex: 'PROOF_KIND'			, width: 120}, 					
			{dataIndex: 'CUSTOM_CODE'			, width: 66},
			{dataIndex: 'CUSTOM_NAME'			, width: 166},
			{dataIndex: 'DEPT_CODE'				, width: 66}, 					
			{dataIndex: 'DEPT_NAME'				, width: 133},
			{dataIndex: 'SUPPLY_AMT_I'			, width: 100},
			{dataIndex: 'TAX_AMT_I'				, width: 86}, 					
			{dataIndex: 'TOTAL_AMT_I'   		, width: 100},
			{dataIndex: 'EX_DATE'      			, width: 80},
			{dataIndex: 'EX_NUM'				, width: 66}, 					
			{dataIndex: 'AP_STS'				, width: 66},
			{dataIndex: 'SAVE_CODE'				, width: 100 , hidden: true},
			{dataIndex: 'SAVE_NAME'				, width: 100 , hidden: true}, 					
			{dataIndex: 'CRDT_NUM'				, width: 100 , hidden: true},
			{dataIndex: 'CRDT_NAME'				, width: 100 , hidden: true},
			{dataIndex: 'REASON_CODE'			, width: 100 , hidden: true}, 					
			{dataIndex: 'PAY_DATE'				, width: 100 , hidden: true},
			{dataIndex: 'EB_YN'					, width: 100 , hidden: true},
			{dataIndex: 'INSERT_DB_USER'		, width: 100 , hidden: true}, 					
			{dataIndex: 'INSERT_DB_TIME'		, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'		, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 100 , hidden: true}
		], 
		listeners: {
      		beforeedit  : function( editor, e, eOpts ) {		
				return false;
      		},
      		itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
//      		onGridDblClick: function(grid, record, cellIndex, colName) {
//				var params = {
//					appId: UniAppManager.getApp().id,
//					sender: this,
//					action: 'new',
//					ASST: record.get('ASST'),
//					ASST_NAME: record.get('ASST_NAME')
//				}
//				var rec = {data : {prgID : 'ass300ukr', 'text':''}};									
//				parent.openTab(rec, '/accnt/ass300ukr.do', params);		
//          	}
		},
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '고정자산 등록',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAss300skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAss300skr:function(record)	{
			if(record)	{
		    	var params = record;
		    	params.PGM_ID 			= 'agd320ukr';
		    	params.ASST 			=	record.get('ASST');
		    	params.ASST_NAME 		=	record.get('ASST_NAME');
			}
	  		var rec1 = {data : {prgID : 'ass300ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/ass300ukr.do', params);
    	}
    });                          

	 Unilite.Main( {
	 	border: false,
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
		id : 'agd320ukrApp',
		fnInitBinding : function() {
			isRdoQuery = false;		
			isRdoQuery = true;
			var activeSForm ;
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',true);
			
			panelSearch.uniOpt.inLoading = true;
			panelResult.uniOpt.inLoading = true;
			UniAppManager.app.setDefault();	
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_ACQ_DATE');
			panelSearch.uniOpt.inLoading = false;
			panelResult.uniOpt.inLoading = false;
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.loadData({});
			this.fnInitBinding();
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else{
				as.hide()
			}
		},
		setDefault: function(){
			panelSearch.setValue('TO_ACQ_DATE', UniDate.get('today'));
			panelSearch.setValue('FR_ACQ_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_ACQ_DATE')));
			panelSearch.setValue('PROC_DATE', UniDate.get('today'));
			panelSearch.setValue('DIV_CODE', UserInfo.divCode );
			panelSearch.getField('DATE_OPTION').setValue("1");
			panelSearch.getField('WORK').setValue("PROC");
			panelSearch.down('#btnAutoSlip').disable(true);		//개별자동기표
			panelSearch.down('#btnAllAutoSlip').disable(true);	//일괄자동기표
			panelSearch.down('#btnAllSelect').disable(true);	//전체선택
			panelSearch.down('#btnViewAutoSlip').disable(true);	//자동기표조회
			panelSearch.down('#cboApSts').hide();				//전표승인여부
			
			panelResult.setValue('TO_ACQ_DATE', UniDate.get('today'));
			panelResult.setValue('FR_ACQ_DATE', UniDate.get('startOfMonth', panelResult.getValue('TO_ACQ_DATE')));
			panelResult.setValue('PROC_DATE', UniDate.get('today'));
			panelResult.setValue('DIV_CODE', UserInfo.divCode );
			panelResult.getField('DATE_OPTION').setValue("1");
			panelResult.getField('WORK').setValue("PROC");			
			panelResult.down('#btnAutoSlip').disable(true);		//개별자동기표
			panelResult.down('#btnAllAutoSlip').disable(true);	//일괄자동기표
			panelResult.down('#btnAllSelect').disable(true);	//전체선택
			panelResult.down('#btnViewAutoSlip').disable(true);	//자동기표조회
			panelResult.down('#cboApSts').hide();				//전표승인여부
		},
		fnCalcSelectedAmt: function(){
			var records = directMasterStore.data.items;
			var dSelectedAmt = 0;
			Ext.each(records, function(record, i){
				if(record.get('CHOICE')){
					dSelectedAmt += record.get('ACQ_AMT_I'); 
				}
			});
			panelSearch.setValue('SELECTED_AMT', dSelectedAmt);
			panelResult.setValue('SELECTED_AMT', dSelectedAmt);
		}
	});
};


</script>
