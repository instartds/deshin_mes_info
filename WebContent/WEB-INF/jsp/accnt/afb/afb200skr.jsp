<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb200skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb200skr" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A003"  /> 		<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> 		<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매입일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매출일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 부가세조정입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A156" />			<!-- 부가세생성경로 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;

function appMain() {

	/* Model 정의 @type
	 */
	Unilite.defineModel('Afb200Model', {
	   fields: [
			{name: 'DEPT_CODE'		, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'		, text: '부서명'			, type: 'string'},
			{name: 'ACCNT'			, text: '계정코드'			, type: 'string'},
			{name: 'ACCNT_NAME'		, text: '계정과목명'		, type: 'string'},
			{name: 'BUDG_I'			, text: '예산금액'			, type: 'uniPrice'},
			{name: 'EX_AMT_I'		, text: '결의실적'			, type: 'uniPrice'},
			{name: 'AC_AMT_I'		, text: '회계실적'			, type: 'uniPrice'},
			{name: 'CHA_AMT'		, text: '차액'			, type: 'uniPrice'},
			{name: 'ACHIEVE_RATE'	, text: '달성률'			, type: 'uniER'},
			{name: 'SUBJECT_DIVI'	, text: '과목구분'			, type: 'string'}
	    ]
	});		// End of Ext.define('Afb200skrModel', {
	
	Unilite.defineModel('Afb200Model2', {
	   fields: [
			{name: 'DEPT_CODE'		, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'		, text: '부서명'			, type: 'string'},
			{name: 'ACCNT'			, text: '계정코드'			, type: 'string'},
			{name: 'ACCNT_NAME'		, text: '계정과목명'		, type: 'string'},
			{name: 'BUDG_I'			, text: '예산금액'			, type: 'uniPrice'},
			{name: 'EX_AMT_I'		, text: '결의실적'			, type: 'uniPrice'},
			{name: 'AC_AMT_I'		, text: '회계실적'			, type: 'uniPrice'},
			{name: 'CHA_AMT'		, text: '차액'			, type: 'uniPrice'},
			{name: 'ACHIEVE_RATE'	, text: '달성률'			, type: 'uniER'},
			{name: 'SUBJECT_DIVI'	, text: '과목구분'			, type: 'string'}
	    ]
	});		// End of Ext.define('Afb200skrModel2', {
	  
	/* Store 정의(Service 정의) @type
	 */					
	var MasterStore = Unilite.createStore('afb200MasterStore',{
		model: 'Afb200Model',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb200skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'DEPT_CODE'
	});
	
	var MasterStore2 = Unilite.createStore('afb200MasterStore2',{
		model: 'Afb200Model2',
		uniOpt: {
            isMaster:	true,			// 상위 버튼 연결
            editable:	false,			// 수정 모드 사용
            deletable:	false,			// 삭제 가능 여부
	        useNavi:	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb200skrService.selectList2'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ACCNT'
	});
	
	/* 검색조건 (Search Panel) @type
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
			items: [{
	    		fieldLabel: '예산년월', 
	    		xtype: 'uniMonthfield',
	    		name: 'BUDG_YYYYMM',
	    		value: UniDate.get('today'),
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelResult.setValue('BUDG_YYYYMM', newValue);
			     	}
			    }
	    	},
	    	Unilite.popup('DEPT', {
					fieldLabel: '부서', 
					valueFieldName: 'DEPT_CODE_FR',
		    		textFieldName: 'DEPT_NAME_FR', 
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE_FR', panelSearch.getValue('DEPT_CODE_FR'));
								panelResult.setValue('DEPT_NAME_FR', panelSearch.getValue('DEPT_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE_FR', '');
							panelResult.setValue('DEPT_NAME_FR', '');
						}
					}
			}),   	
			Unilite.popup('DEPT', {
					fieldLabel: '~', 
					valueFieldName: 'DEPT_CODE_TO',
		    		textFieldName: 'DEPT_NAME_TO', 
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE_TO', panelSearch.getValue('DEPT_CODE_TO'));
								panelResult.setValue('DEPT_NAME_TO', panelSearch.getValue('DEPT_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE_TO', '');
							panelResult.setValue('DEPT_NAME_TO', '');
						}
					}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목구분',	
				items: [{
					boxLabel: '과목', 
					width: 70, 
					name: 'ACCNT_DIVI',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel : '세목', 
					width: 70,
					name: 'ACCNT_DIVI',
	    			inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('ACCNT_DIVI').setValue(newValue.ACCNT_DIVI);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},		    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
		    	valueFieldName: 'ACCNT_FR',
		    	textFieldName: 'ACCNT_NAME_FR',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_FR', panelSearch.getValue('ACCNT_FR'));
							panelResult.setValue('ACCNT_NAME_FR', panelSearch.getValue('ACCNT_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_FR', '');
						panelResult.setValue('ACCNT_NAME_FR', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
		    }),	    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel: '~',
				valueFieldName: 'ACCNT_TO',
		    	textFieldName: 'ACCNT_NAME_TO',  			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_TO', panelSearch.getValue('ACCNT_TO'));
							panelResult.setValue('ACCNT_NAME_TO', panelSearch.getValue('ACCNT_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_TO', '');
						panelResult.setValue('ACCNT_NAME_TO', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
	    	})]	
		}],
	
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
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
	    		fieldLabel: '예산년월', 
	    		xtype: 'uniMonthfield', 
	    		name: 'BUDG_YYYYMM',
	    		value: UniDate.get('today'),
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelSearch.setValue('BUDG_YYYYMM', newValue);
			     	}
			    }
	    	},
	    	Unilite.popup('DEPT', {
					fieldLabel: '부서', 
					valueFieldName: 'DEPT_CODE_FR',
		    		textFieldName: 'DEPT_NAME_FR', 
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE_FR', panelResult.getValue('DEPT_CODE_FR'));
								panelSearch.setValue('DEPT_NAME_FR', panelResult.getValue('DEPT_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DEPT_CODE_FR', '');
							panelSearch.setValue('DEPT_NAME_FR', '');
						}
					}
			}),   	
			Unilite.popup('DEPT', {
				fieldLabel: '~', 
				labelWidth: 15,
				valueFieldName: 'DEPT_CODE_TO',
	    		textFieldName: 'DEPT_NAME_TO', 
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_TO'));
							panelSearch.setValue('DEPT_NAME_TO', panelResult.getValue('DEPT_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('DEPT_CODE_TO', '');
						panelSearch.setValue('DEPT_NAME_TO', '');
					}
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목구분',						            		
				// id: 'rdoSelect',
				items: [{
					boxLabel: '과목', 
					width: 70, 
					name: 'ACCNT_DIVI',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel : '세목', 
					width: 70,
					name: 'ACCNT_DIVI',
	    			inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('ACCNT_DIVI').setValue(newValue.ACCNT_DIVI);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},		    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
		    	valueFieldName: 'ACCNT_FR',
		    	textFieldName: 'ACCNT_NAME_FR',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_FR', panelResult.getValue('ACCNT_FR'));
							panelSearch.setValue('ACCNT_NAME_FR', panelResult.getValue('ACCNT_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_FR', '');
						panelSearch.setValue('ACCNT_NAME_FR', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
		    }),		    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel: '~',
				labelWidth: 15,
				valueFieldName: 'ACCNT_TO',
		    	textFieldName: 'ACCNT_NAME_TO',  		
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_TO', panelResult.getValue('ACCNT_TO'));
							panelSearch.setValue('ACCNT_NAME_TO', panelResult.getValue('ACCNT_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_TO', '');
						panelSearch.setValue('ACCNT_NAME_TO', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
	    	})
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
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('afb200Grid1', {
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: true
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: true
    		}
    	],
    	layout : 'fit',
        title: '부서별',
        region : 'center',
		store: MasterStore,
        columns: [        
        	{dataIndex: 'DEPT_CODE'			, width: 66,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '부서계', '총계');
            	}
            }, 				
			{dataIndex: 'DEPT_NAME'			, width: 133}, 				
			{dataIndex: 'ACCNT'				, width: 66}, 				
			{dataIndex: 'ACCNT_NAME'		, width: 133}, 				
			{dataIndex: 'BUDG_I'			, width: 126, summaryType: 'sum'}, 				
			{dataIndex: 'EX_AMT_I'			, width: 126, summaryType: 'sum'}, 				
			{dataIndex: 'AC_AMT_I'			, width: 126, summaryType: 'sum'}, 				
			{dataIndex: 'CHA_AMT'			, width: 126, summaryType: 'sum'}, 				
			{dataIndex: 'ACHIEVE_RATE'		, width: 80, summaryType: 'sum'}, 				
			{dataIndex: 'SUBJECT_DIVI'		, width: 80, hidden: true}
		],
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('SUBJECT_DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
			}
		},
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts) {
				if (record.get('SUBJECT_DIVI') == '2'){
					view.ownerGrid.setCellPointer(view, item);
				}
			},
			onGridDblClick :function( grid, record, cellIndex, colName) {
				masterGrid.gotoAgb110(record);
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event) {
			if (record.get('SUBJECT_DIVI') == '2'){
				return true;
			}
		},
		uniRowContextMenu:{
			items: [{
				text: '보조부',
				handler: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgb110(param.record);
				}
			}]
		},
		gotoAgb110:function(record)	{
			if(record)	{
				var frDt = UniDate.getMonthStr(panelSearch.getValue('BUDG_YYYYMM')) + '01';
				var stDt = UniDate.getDbDateStr(frDt.substring(0, 4) +  UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				var params = {
					action:'select',
					'PGM_ID'			: 'afb200skr',
					'FR_DATE'			: frDt,
					'TO_DATE'			: UniDate.get('endOfMonth', frDt),
					'ST_DATE'			: stDt,
					'ACCNT_CODE'		: record.data['ACCNT'],
					'ACCNT_NAME'		: record.data['ACCNT_NAME'],
					'DEPT_CODE'			: record.data['DEPT_CODE'],
					'DEPT_NAME'			: record.data['DEPT_NAME']
				};
				if (record.get('SUBJECT_DIVI') == '2'){
					var rec1 = {data : {prgID : 'agb110skr', 'text':''}};
					parent.openTab(rec1, '/accnt/agb110skr.do', params);
				}
			}
		}
	});

    var masterGrid2 = Unilite.createGrid('afb200Grid2', {
    	layout : 'fit',
        title: '계정과목별',
        region : 'center',
		store: MasterStore2,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
        columns: [         				
			{dataIndex: 'ACCNT'				, width: 66,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '계정과목계', '총계');
            	}
            }, 				
			{dataIndex: 'ACCNT_NAME'		, width: 133}, 
        	{dataIndex: 'DEPT_CODE'			, width: 66}, 				
			{dataIndex: 'DEPT_NAME'			, width: 133},				
			{dataIndex: 'BUDG_I'			, width: 126, summaryType: 'sum'}, 				
			{dataIndex: 'EX_AMT_I'			, width: 126, summaryType: 'sum'}, 				
			{dataIndex: 'AC_AMT_I'			, width: 126, summaryType: 'sum'}, 				
			{dataIndex: 'CHA_AMT'			, width: 126, summaryType: 'sum'}, 				
			{dataIndex: 'ACHIEVE_RATE'		, width: 80, summaryType: 'sum'}, 				
			{dataIndex: 'SUBJECT_DIVI'		, width: 80, hidden: true}
		],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('SUBJECT_DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    }
    }); 
    
    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid,
	         masterGrid2
	    ],
	     listeners:  {
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
	     		var newTabId = newCard.getId();
					console.log("newCard:  " + newCard.getId());
					console.log("oldCard:  " + oldCard.getId());
					
				switch(newTabId)	{
					case 'afb200Grid1':
						MasterStore.loadStoreRecords();
						
						break;
						
					case 'afb200Grid2':
						MasterStore2.loadStoreRecords();
						
						break;
						
					default:
						break;
				}
	     	}
	     }
    });
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
			panelSearch  	
		], 
		id : 'afb200App',
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			if(params && params.PGM_ID) {
				this.processParams(params);
			}

		},
		onQueryButtonDown : function()	{		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'afb200Grid1'){	
				MasterStore.loadStoreRecords();				
			}
			if(activeTabId == 'afb200Grid2'){	
				MasterStore2.loadStoreRecords();				
			}
/*
 * var viewLocked = tab.getActiveTab().lockedGrid.getView(); var viewNormal =
 * tab.getActiveTab().normalGrid.getView(); console.log("viewLocked :
 * ",viewLocked); console.log("viewNormal : ",viewNormal);
 * viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
 * viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
 * viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
 * viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
 */
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},        
		//링크로 넘어오는 params 받는 부분
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'afb220skr') {
				panelSearch.setValue('BUDG_YYYYMM'	,params.BUDG_YYYYMM);
				panelSearch.setValue('DEPT_CODE_FR'	,params.DEPT_CODE_FR);
				panelSearch.setValue('DEPT_CODE_TO'	,params.DEPT_CODE_TO);
				panelSearch.setValue('DEPT_NAME_FR'	,params.DEPT_NAME_FR);
				panelSearch.setValue('DEPT_NAME_TO'	,params.DEPT_NAME_TO);
				panelSearch.setValue('ACCNT_FR'		,params.ACCNT_FR);
				panelSearch.setValue('ACCNT_TO'		,params.ACCNT_TO);
				panelSearch.setValue('ACCNT_NAME_FR',params.ACCNT_NAME_FR);
				panelSearch.setValue('ACCNT_NAME_TO',params.ACCNT_NAME_TO);
				panelSearch.setValue('ACCNT_DIVI'	,params.ACCNT_DIVI.rdoSelect);
				
				panelResult.setValue('BUDG_YYYYMM'	,params.BUDG_YYYYMM);
				panelResult.setValue('DEPT_CODE_FR'	,params.DEPT_CODE_FR);
				panelResult.setValue('DEPT_CODE_TO'	,params.DEPT_CODE_TO);
				panelResult.setValue('DEPT_NAME_FR'	,params.DEPT_NAME_FR);
				panelResult.setValue('DEPT_NAME_TO'	,params.DEPT_NAME_TO);
				panelResult.setValue('ACCNT_FR'		,params.ACCNT_FR);
				panelResult.setValue('ACCNT_TO'		,params.ACCNT_TO);
				panelResult.setValue('ACCNT_NAME_FR',params.ACCNT_NAME_FR);
				panelResult.setValue('ACCNT_NAME_TO',params.ACCNT_NAME_TO);
				panelResult.setValue('ACCNT_DIVI'	,params.ACCNT_DIVI.rdoSelect);
				UniAppManager.app.onQueryButtonDown();
			}
        }
	});
};


</script>
