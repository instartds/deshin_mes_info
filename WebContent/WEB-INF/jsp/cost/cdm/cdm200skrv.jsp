<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cdm200skrv"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->     
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 발주형태 -->     
	<t:ExtComboStore items="${COMBO_WH_LIST}" 	  storeId="whList" /><!--창고-->
	<t:ExtComboStore items="${COMBO_WS_LIST}" 	  storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="Level1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="Level2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="Level3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	Unilite.defineModel('Cdm200skrvModel1', {
	    fields: [  	 
	    	{name: 'IN_DIVI',				text: '입고구분',		type: 'string'},
	    	{name: 'PROD_ITEM_CODE',		text: '품목코드',		type: 'string'},
	    	{name: 'ITEM_NAME',				text: '품명',		    type: 'string'},
	    	{name: 'SPEC',					text: '규격',			type: 'string'},
	    	{name: 'STOCK_UNIT',			text: '단위',		    type: 'string'},
	    	{name: 'PRODT_Q',				text: '생산입고수량',	type: 'uniQty'}
		]
	});	
	
	Unilite.defineModel('Cdm200skrvModel2', {
	    fields: [  	 
		    {name: 'ITEM_CODE',				text: '품목코드',		type: 'string'},
	    	{name: 'ITEM_NAME',				text: '품명',		    type: 'string'},
	    	{name: 'SPEC',					text: '규격',			type: 'string'},
	    	{name: 'STOCK_UNIT',			text: '단위',		    type: 'string'},
	    	{name: 'INOUT_Q',				text: '수량',		    type: 'uniQty'},
	    	{name: 'UNIT_COST',				text: '단가',			type: 'uniPrice'},
	    	{name: 'D_AMT',					text: '재료비',			type: 'uniPrice'},
	    	{name: 'ID_AMT',				text: '간접재료비',		type: 'uniPrice'},
	    	{name: 'T_AMT',					text: '총 재료비',		type: 'uniPrice'}
		]
	});	
	
	Unilite.defineModel('Cdm200skrvModel3', {
	    fields: [  	 
	    	{name: 'ACC_CODE',				text: '계정코드',		type: 'string'},
	    	{name: 'ACC_NAME',				text: '계정명',			type: 'string'},
	    	{name: 'DEPT_CODE',				text: '부서코드',	    type: 'string'},
	    	{name: 'DEPT_NAME',				text: '부서명',			type: 'string'},
	    	{name: 'ID_GB',					text: '직간접구분',		type: 'string'},
	    	{name: 'AMT',					text: '금액',			type: 'uniPrice'}
		]
	});
	
	Unilite.defineModel('Cdm200skrvModel4', {
	    fields: [  	 
	    	{name: 'ACC_CODE',				text: '계정코드',		type: 'string'},
	    	{name: 'ACC_NAME',				text: '계정명',			type: 'string'},
	    	{name: 'DEPT_CODE',				text: '부서코드',	    type: 'string'},
	    	{name: 'DEPT_NAME',				text: '부서명',			type: 'string'},
	    	{name: 'ID_GB',					text: '직간접구분',		type: 'string'},
	    	{name: 'AMT',					text: '금액',			type: 'uniPrice'}
		]
	});
	
	Unilite.defineModel('Cdm200skrvModel5', {
	    fields: [  	 
		    {name: 'ITEM_ACCOUNT',			text: '품목계정',		type: 'string'},
		    {name: 'ITEM_CODE',				text: '품목코드',		type: 'string'},
	    	{name: 'ITEM_NAME',				text: '품명',		    type: 'string'},
	    	{name: 'SPEC',					text: '규격',			type: 'string'},
	    	{name: 'STOCK_UNIT',			text: '단위',		    type: 'string'},
	    	{name: 'CUSTOM_NAME',			text: '거래처',		    type: 'string'},
	    	{name: 'INOUT_Q',				text: '수량',		    type: 'uniQty'},
	    	{name: 'UNIT_COST',				text: '단가',			type: 'uniPrice'},
	    	{name: 'AMT',					text: '금액',			type: 'uniPrice'}
		]
	});	
	
	Unilite.defineModel('Cdm200skrvModel6', {
	    fields: [  	 
	    	{name: 'WORK_SHOP_CD',			text: '작업장코드',		type: 'string'},
	    	{name: 'WORK_SHOP_NAME',		text: '작업장명',		type: 'string'},
	    	{name: 'ITEM_CODE',				text: '품목코드',		type: 'string'},
	    	{name: 'ITEM_NAME',				text: '품목명',		    type: 'string'},
	    	{name: 'SPEC',					text: '규격',			type: 'string'},
	    	{name: 'STOCK_UNIT',			text: '단위',		    type: 'string'},
	    	{name: 'INOUT_Q',				text: '수량',		    type: 'uniQty'},
	    	{name: 'AMT',					text: '금액',			type: 'uniPrice'}
		]
	});	
	
	var directMasterStore1 = Unilite.createStore('cdm200skrvMasterStore1',{
		model: 'Cdm200skrvModel1',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'cdm200skrvService.selectList1'                	
            }
        },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param["tabFlag"] = "1";
			this.load({
				params : param,
				callback : function(records,options,success){
					if(success)	{
						cdm200skrvService.selectMaxSeq(param, function(provider, response)	{
							if(provider){
								panelResult.setValue("WORK_SEQ_TO", provider["WORK_SEQ"])
								panelSearch.setValue("WORK_SEQ_TO", provider["WORK_SEQ"])
							}else{
								panelResult.setValue("WORK_SEQ_TO", 0)
								panelSearch.setValue("WORK_SEQ_TO", 0)
							}
						});
					}
				}
			});
		}
	});
	
	var directMasterStore2 = Unilite.createStore('cdm200skrvMasterStore2',{
		model: 'Cdm200skrvModel2',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'cdm200skrvService.selectList2'                	
            }
        },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param["tabFlag"] = "2";
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore3 = Unilite.createStore('cdm200skrvMasterStore3',{
		model: 'Cdm200skrvModel3',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'cdm200skrvService.selectList3'                	
            }
        },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param["tabFlag"] = "3";
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore4 = Unilite.createStore('cdm200skrvMasterStore4',{
		model: 'Cdm200skrvModel4',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'cdm200skrvService.selectList4'                	
            }
        },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param["tabFlag"] = "4";
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore5 = Unilite.createStore('cdm200skrvMasterStore5',{
		model: 'Cdm200skrvModel5',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'cdm200skrvService.selectList5'                	
            }
        },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param["tabFlag"] = "5";
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore6 = Unilite.createStore('cdm200skrvMasterStore6',{
		model: 'Cdm200skrvModel6',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'cdm200skrvService.selectList6'
            }
        },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param["tabFlag"] = "6";
			this.load({
				params : param
			});
		}
	});

    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        width:380,
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
	        	fieldLabel: '사업장',
	        	name: 'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType: 'BOR120',
	        	allowBlank: false,
	        	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	        },{ name: 'WORK_DATE',
	            fieldLabel: '기준월', 
	            xtype: 'uniMonthfield',
	            value:UniDate.get('startOfMonth'),
	            hidden: false, 
	            allowBlank:false, 
	            maxLength: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_DATE', newValue);
					}
				}
	        },{
        		fieldLabel: '작업회수',
        		name:'WORK_SEQ_FR',
        		xtype:'uniNumberfield',
        		allowBlank:false, 
        		maxLength:3,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SEQ_FR', newValue);
					}
				}
        		//suffixTpl:'&nbsp;이상'
    		}, {
        		fieldLabel: '/',
        		name:'WORK_SEQ_TO',
        		xtype:'uniNumberfield',
        		readOnly:true,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_SEQ_TO', newValue);
					}
				}
    		},{
	    		fieldLabel: '품목계정',
	    		name: 'ITEM_ACCOUNT', 
	    		xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
		    	name: 'ITEM_LEVEL1',
    			fieldLabel: '대분류',
    			xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('Level1Store'),
                child: 'ITEM_LEVEL2',
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
            }, {
              	name: 'ITEM_LEVEL2',
              	fieldLabel: '중분류',
              	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('Level2Store'),
                child: 'ITEM_LEVEL3',
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
             }, {
             	name: 'ITEM_LEVEL3',
             	fieldLabel: '소분류',
             	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('Level3Store'),
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
            },
            Unilite.popup('DIV_PUMOK',{ 
				fieldLabel: '품목코드',
				textFieldWidth: 170,
				itemId:'ITEM_CODE',
				valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					},
	                applyExtParam:{
	                    scope:this,
	                    fn:function(popup){
	                        popup.setExtParam({"CUSTOM_TYPE":'3'});
	                    }
	                }
				}
			}),
			Unilite.popup('ACCNT',{
				fieldLabel: '계정코드', 
				itemId:'ACCNT_CODE',
				valueFieldName:'ACCNT_CODE',
			    textFieldName:'ACCNT_NAME', 
			    hidden:true,
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
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'ADD_QUERY' : "A.ACCNT_DIVI = N'5'"
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
			}),
			Unilite.popup('DEPT',{
                fieldLabel: '부서코드', 
                itemId:'DEPT_CODE',
                hidden:true,
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'DEPT_CODE',
                textFieldName:'DEPT_NAME',
                listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					}
				}
            }),
            Unilite.popup('CUST',{ 
				fieldLabel: '거래처',
				hidden:true,
				itemId:'CUSTOM_CODE',
				textFieldWidth: 170,
				valueFieldName: 'CUSTOM_CODE', 
				textFieldName: 'CUSTOM_NAME', 
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					},
	                applyExtParam:{
	                    scope:this,
	                    fn:function(popup){
	                        popup.setExtParam({"CUSTOM_TYPE":['1','2']});
	                    }
	                }
				}
			})]
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        	fieldLabel: '사업장',
	        	name: 'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType: 'BOR120',
	        	allowBlank: false,
	        	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
	        },{ name: 'WORK_DATE',
	            fieldLabel: '기준월', 
	            xtype: 'uniMonthfield',
	            value:UniDate.get('startOfMonth'),
	            hidden: false, 
	            allowBlank:false, 
	            maxLength: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WORK_DATE', newValue);
					}
				}
	        },{
        		fieldLabel: '작업회수',
        		name:'WORK_SEQ_FR',
        		xtype:'uniNumberfield',
        		allowBlank:false,
        		maxLength:3,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WORK_SEQ_FR', newValue);
					}
				}
        		//suffixTpl:'&nbsp;이상'
    		}, {
        		fieldLabel: '/',
        		labelWidth:20,
        		name:'WORK_SEQ_TO',
        		xtype:'uniNumberfield',
        		readOnly:true,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WORK_SEQ_TO', newValue);
					}
				}
    		},{
	    		fieldLabel: '품목계정',
	    		name: 'ITEM_ACCOUNT', 
	    		itemId:'ITEM_ACCOUNT',
	    		xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
		    	name: 'ITEM_LEVEL1',
    			fieldLabel: '대분류',
    			itemId:'ITEM_LEVEL1',
    			xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('Level1Store'),
                child: 'ITEM_LEVEL2',
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL1', newValue);
					}
				}
            }, {
              	name: 'ITEM_LEVEL2',
              	fieldLabel: '중분류',
              	itemId:'ITEM_LEVEL2',
              	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('Level2Store'),
                child: 'ITEM_LEVEL3',
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL2', newValue);
					}
				}
             }, {
             	name: 'ITEM_LEVEL3',
             	fieldLabel: '소분류',
             	itemId:'ITEM_LEVEL3',
             	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('Level3Store'),
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL3', newValue);
					}
				}
            },
            Unilite.popup('DIV_PUMOK',{ 
				fieldLabel: '품목코드',
				itemId:'ITEM_CODE',
				textFieldWidth: 170, 
				valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
					},
	                applyExtParam:{
	                    scope:this,
	                    fn:function(popup){
	                        popup.setExtParam({"CUSTOM_TYPE":'3'});
	                    }
	                }
				}
			}),
			Unilite.popup('ACCNT',{
				fieldLabel: '계정코드', 
				itemId:'ACCNT_CODE',
				valueFieldName:'ACCNT_CODE',
			    textFieldName:'ACCNT_NAME',
			    hidden:true,
			    listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelResult.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_CODE', '');
						panelResult.setValue('ACCNT_NAME', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'ADD_QUERY' : "A.ACCNT_DIVI = N'5'"
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
			}),
			Unilite.popup('DEPT',{
                fieldLabel: '부서코드', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                hidden:true,
                itemId:'DEPT_CODE',
                valueFieldName:'DEPT_CODE',
                textFieldName:'DEPT_NAME',
                listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
					}
				}
            }),
            Unilite.popup('CUST',{ 
				fieldLabel: '거래처',
				hidden:true,
				textFieldWidth: 170,
				itemId:'CUSTOM_CODE',
				valueFieldName: 'CUSTOM_CODE', 
				textFieldName: 'CUSTOM_NAME', 
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
							panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('CUSTOM_CODE', '');
						panelSearch.setValue('CUSTOM_NAME', '');
					},
	                applyExtParam:{
	                    scope:this,
	                    fn:function(popup){
	                        popup.setExtParam({"CUSTOM_TYPE":['1','2']});
	                    }
	                }
				}
			})],
		setAllFieldsReadOnly: setAllFieldsReadOnly
    });
	
    var masterGrid1 = Unilite.createGrid('cdm200skrvGrid1', {
        layout : 'fit',
        region : 'center',
        title  : '원가품목내역',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : true,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel    : true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData    : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
        	id: 'masterGridTotal', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true
        }],
    	store: directMasterStore1,
        columns: [  
        	{ dataIndex: 'IN_DIVI',    			    width: 86},
        	{ dataIndex: 'PROD_ITEM_CODE',    		width: 120},
        	{ dataIndex: 'ITEM_NAME',    			width: 150},
        	{ dataIndex: 'SPEC',    				width: 166},
        	{ dataIndex: 'STOCK_UNIT',    			width: 66, align:"center"},
        	{ dataIndex: 'PRODT_Q',    				width: 100,summaryType:'sum'}
          ] 
    });
    
    var masterGrid2 = Unilite.createGrid('cdm200skrvGrid2', {
        layout : 'fit',
        region : 'center',
        title  : '재료비내역',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : true,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel    : true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData    : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
        	id: 'masterGridTotal', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true
        }],
    	store: directMasterStore2,
        columns: [  
        	{ dataIndex: 'ITEM_CODE',    			width: 120},
        	{ dataIndex: 'ITEM_NAME',    			width: 150},
        	{ dataIndex: 'SPEC',    				width: 166},
        	{ dataIndex: 'STOCK_UNIT',    			width: 66, align:"center"},
        	{ dataIndex: 'INOUT_Q',    				width: 100,summaryType:'sum'},
        	{ dataIndex: 'UNIT_COST',    			width: 100,
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
        	    	var data = metaData.record.data;
        	    	var summaryUnitCost = Ext.util.Format.number(data['D_AMT']/data['INOUT_Q'],UniFormat.Price);
        	    	if(!summaryUnitCost){
        	    		summaryUnitCost = Ext.util.Format.number(0,UniFormat.Price);
        	    	}
			        return "<div align='right'>"+summaryUnitCost+"</div>"
                }
        	},
        	{ dataIndex: 'D_AMT',    				width: 100, summaryType:'sum'},
        	{ dataIndex: 'ID_AMT',    				width: 100, hidden:true},
        	{ dataIndex: 'T_AMT',    				width: 110, hidden:true}
          ] 
    });

    
    var masterGrid3 = Unilite.createGrid('cdm200skrvGrid3', {
        layout : 'fit',
        region : 'center',
        title  : '노무비내역',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : true,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel    : true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData    : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
        	id: 'masterGridTotal', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true
        }],
    	store: directMasterStore3,
        columns: [  
        	{ dataIndex: 'ACC_CODE',    			width: 120},
        	{ dataIndex: 'ACC_NAME',    			width: 150},
        	{ dataIndex: 'DEPT_CODE',    			width: 120, hidden:true},
        	{ dataIndex: 'DEPT_NAME',    			width: 150, hidden:true},
        	{ dataIndex: 'ID_GB',    				width: 100},
        	{ dataIndex: 'AMT',    					width: 110,summaryType:'sum'}
          ] 
    });
    
    var masterGrid4 = Unilite.createGrid('cdm200skrvGrid4', {
        layout : 'fit',
        region : 'center',
        title  : '경비내역',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : true,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel    : true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData    : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
        	id: 'masterGridTotal', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true
        }],
    	store: directMasterStore4,
        columns: [  
        	{ dataIndex: 'ACC_CODE',    			width: 120},
        	{ dataIndex: 'ACC_NAME',    			width: 150},
        	{ dataIndex: 'DEPT_CODE',    			width: 120,hidden:true},
        	{ dataIndex: 'DEPT_NAME',    			width: 150,hidden:true},
        	{ dataIndex: 'ID_GB',    				width: 100},
        	{ dataIndex: 'AMT',    					width: 110,summaryType:'sum'}
          ] 
    });
    
    var masterGrid5 = Unilite.createGrid('cdm200skrvGrid5', {
        layout : 'fit',
        region : 'center',
        title  : '외주가공비내역',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : true,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel    : true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData    : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
        	id: 'masterGridTotal', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true
        }],
    	store: directMasterStore5,
        columns: [  
        	{ dataIndex: 'ITEM_ACCOUNT',    		width: 86},
        	{ dataIndex: 'ITEM_CODE',    			width: 120},
        	{ dataIndex: 'ITEM_NAME',    			width: 150},
        	{ dataIndex: 'SPEC',    				width: 166},
        	{ dataIndex: 'STOCK_UNIT',    			width: 66,align:'center'},
        	{ dataIndex: 'CUSTOM_NAME',    			width: 120},
        	{ dataIndex: 'INOUT_Q',    				width: 100, summaryType:'sum'},
        	{ dataIndex: 'UNIT_COST',    			width: 100, summaryType:'sum',
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
        	    	var data = metaData.record.data;
        	    	var summaryUnitCost = Ext.util.Format.number(data['AMT']/data['INOUT_Q'],UniFormat.Price);
        	    	if(!summaryUnitCost){
        	    		summaryUnitCost = Ext.util.Format.number(0,UniFormat.Price);
        	    	}
			        return "<div align='right'>"+summaryUnitCost+"</div>"
                }
        	},
        	{ dataIndex: 'AMT',    					width: 110, summaryType:'sum'}
          ] 
    });
    
    var masterGrid6 = Unilite.createGrid('cdm200skrvGrid6', {
        layout : 'fit',
        region : 'center',
        title  : '공통재료비내역',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : true,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel    : true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData    : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
        	id: 'masterGridTotal', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true
        }],
    	store: directMasterStore6,
        columns: [  
        	{ dataIndex: 'WORK_SHOP_CD',    		width: 100},
        	{ dataIndex: 'WORK_SHOP_NAME',    		width: 120},
        	{ dataIndex: 'ITEM_CODE',    			width: 120},
        	{ dataIndex: 'ITEM_NAME',    			width: 150},
        	{ dataIndex: 'SPEC',    				width: 166},
        	{ dataIndex: 'STOCK_UNIT',    			width: 66,align:'center'},
        	{ dataIndex: 'INOUT_Q',    				width: 100, summaryType:'sum'},
        	{ dataIndex: 'AMT',    					width: 100, summaryType:'sum'}
          ] 
    });
    
    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid1, masterGrid2, masterGrid3, masterGrid4, masterGrid5, masterGrid6
	    ],
	    listeners:  {
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
				switch(newCard.getId()) {
					case 'cdm200skrvGrid1':
						panelResult.getField("ITEM_ACCOUNT").setHidden(false)
						panelResult.getField("ITEM_LEVEL1").setHidden(false)
						panelResult.getField("ITEM_LEVEL2").setHidden(false)
						panelResult.getField("ITEM_LEVEL3").setHidden(false)
						panelResult.down("#ITEM_CODE").setHidden(false)
						panelResult.down("#ACCNT_CODE").setHidden(true)
						panelResult.down("#DEPT_CODE").setHidden(true)
						panelResult.down("#CUSTOM_CODE").setHidden(true)
						
						panelSearch.getField("ITEM_ACCOUNT").setHidden(false)
						panelSearch.getField("ITEM_LEVEL1").setHidden(false)
						panelSearch.getField("ITEM_LEVEL2").setHidden(false)
						panelSearch.getField("ITEM_LEVEL3").setHidden(false)
						panelSearch.down("#ITEM_CODE").setHidden(false)
						panelSearch.down("#ACCNT_CODE").setHidden(true)
						panelSearch.down("#DEPT_CODE").setHidden(true)
						panelSearch.down("#CUSTOM_CODE").setHidden(true)
						
						panelResult.setValue("ACCNT_CODE","");
						panelResult.setValue("ACCNT_NAME","");
						panelResult.setValue("DEPT_CODE","");
						panelResult.setValue("DEPT_NAME","");
						panelResult.setValue("CUSTOM_CODE","");
						panelResult.setValue("CUSTOM_NAME","");
						
						panelSearch.setValue("ACCNT_CODE","");
						panelSearch.setValue("ACCNT_NAME","");
						panelSearch.setValue("DEPT_CODE","");
						panelSearch.setValue("DEPT_NAME","");
						panelSearch.setValue("CUSTOM_CODE","");
						panelSearch.setValue("CUSTOM_NAME","");
						
						UniAppManager.app.onQueryButtonDown(newCard.getId());
						//UniAppManager.app.onResetButtonDown();
						break;
					case 'cdm200skrvGrid2':
					    panelResult.getField("ITEM_ACCOUNT").setHidden(false)
						panelResult.getField("ITEM_LEVEL1").setHidden(false)
						panelResult.getField("ITEM_LEVEL2").setHidden(false)
						panelResult.getField("ITEM_LEVEL3").setHidden(false)
						panelResult.down("#ITEM_CODE").setHidden(false)
						panelResult.down("#ACCNT_CODE").setHidden(true)
						panelResult.down("#DEPT_CODE").setHidden(true)
						panelResult.down("#CUSTOM_CODE").setHidden(true)
						
						panelSearch.getField("ITEM_ACCOUNT").setHidden(false)
						panelSearch.getField("ITEM_LEVEL1").setHidden(false)
						panelSearch.getField("ITEM_LEVEL2").setHidden(false)
						panelSearch.getField("ITEM_LEVEL3").setHidden(false)
						panelSearch.down("#ITEM_CODE").setHidden(false)
						panelSearch.down("#ACCNT_CODE").setHidden(true)
						panelSearch.down("#DEPT_CODE").setHidden(true)
						panelSearch.down("#CUSTOM_CODE").setHidden(true)
						
						panelResult.setValue("ACCNT_CODE","");
						panelResult.setValue("ACCNT_NAME","");
						panelResult.setValue("DEPT_CODE","");
						panelResult.setValue("DEPT_NAME","");
						panelResult.setValue("CUSTOM_CODE","");
						panelResult.setValue("CUSTOM_NAME","");
						
						panelSearch.setValue("ACCNT_CODE","");
						panelSearch.setValue("ACCNT_NAME","");
						panelSearch.setValue("DEPT_CODE","");
						panelSearch.setValue("DEPT_NAME","");
						panelSearch.setValue("CUSTOM_CODE","");
						panelSearch.setValue("CUSTOM_NAME","");
						
						UniAppManager.app.onQueryButtonDown(newCard.getId());
						//UniAppManager.app.onResetButtonDown();
						break;
					case 'cdm200skrvGrid3':
					 	panelResult.getField("ITEM_ACCOUNT").setHidden(true)
						panelResult.getField("ITEM_LEVEL1").setHidden(true)
						panelResult.getField("ITEM_LEVEL2").setHidden(true)
						panelResult.getField("ITEM_LEVEL3").setHidden(true)
						panelResult.down("#ITEM_CODE").setHidden(true)
						panelResult.down("#ACCNT_CODE").setHidden(false)
						panelResult.down("#DEPT_CODE").setHidden(false)
						panelResult.down("#CUSTOM_CODE").setHidden(true)
						
						panelSearch.getField("ITEM_ACCOUNT").setHidden(true)
						panelSearch.getField("ITEM_LEVEL1").setHidden(true)
						panelSearch.getField("ITEM_LEVEL2").setHidden(true)
						panelSearch.getField("ITEM_LEVEL3").setHidden(true)
						panelSearch.down("#ITEM_CODE").setHidden(true)
						panelSearch.down("#ACCNT_CODE").setHidden(false)
						panelSearch.down("#DEPT_CODE").setHidden(false)
						panelSearch.down("#CUSTOM_CODE").setHidden(true)
						
						panelResult.setValue("ITEM_ACCOUNT","");
						panelResult.setValue("ITEM_LEVEL1","");
						panelResult.setValue("ITEM_LEVEL2","");
						panelResult.setValue("ITEM_LEVEL3","");
						panelResult.setValue("ITEM_CODE","");
						panelResult.setValue("ITEM_NAME","");
						panelResult.setValue("CUSTOM_CODE","");
						panelResult.setValue("CUSTOM_NAME","");
						
						panelSearch.setValue("ITEM_ACCOUNT","");
						panelSearch.setValue("ITEM_LEVEL1","");
						panelSearch.setValue("ITEM_LEVEL2","");
						panelSearch.setValue("ITEM_LEVEL3","");
						panelSearch.setValue("ITEM_CODE","");
						panelSearch.setValue("ITEM_NAME","");
						panelSearch.setValue("CUSTOM_CODE","");
						panelSearch.setValue("CUSTOM_NAME","");
						
						UniAppManager.app.onQueryButtonDown(newCard.getId());
						//UniAppManager.app.onResetButtonDown();
						break;
					case 'cdm200skrvGrid4':
					 	panelResult.getField("ITEM_ACCOUNT").setHidden(true)
						panelResult.getField("ITEM_LEVEL1").setHidden(true)
						panelResult.getField("ITEM_LEVEL2").setHidden(true)
						panelResult.getField("ITEM_LEVEL3").setHidden(true)
						panelResult.down("#ITEM_CODE").setHidden(true)
						panelResult.down("#ACCNT_CODE").setHidden(false)
						panelResult.down("#DEPT_CODE").setHidden(false)
						panelResult.down("#CUSTOM_CODE").setHidden(true)
						
						panelSearch.getField("ITEM_ACCOUNT").setHidden(true)
						panelSearch.getField("ITEM_LEVEL1").setHidden(true)
						panelSearch.getField("ITEM_LEVEL2").setHidden(true)
						panelSearch.getField("ITEM_LEVEL3").setHidden(true)
						panelSearch.down("#ITEM_CODE").setHidden(true)
						panelSearch.down("#ACCNT_CODE").setHidden(false)
						panelSearch.down("#DEPT_CODE").setHidden(false)
						panelSearch.down("#CUSTOM_CODE").setHidden(true)
						
						panelResult.setValue("ITEM_ACCOUNT","");
						panelResult.setValue("ITEM_LEVEL1","");
						panelResult.setValue("ITEM_LEVEL2","");
						panelResult.setValue("ITEM_LEVEL3","");
						panelResult.setValue("ITEM_CODE","");
						panelResult.setValue("ITEM_NAME","");
						panelResult.setValue("CUSTOM_CODE","");
						panelResult.setValue("CUSTOM_NAME","");
						
						panelSearch.setValue("ITEM_ACCOUNT","");
						panelSearch.setValue("ITEM_LEVEL1","");
						panelSearch.setValue("ITEM_LEVEL2","");
						panelSearch.setValue("ITEM_LEVEL3","");
						panelSearch.setValue("ITEM_CODE","");
						panelSearch.setValue("ITEM_NAME","");
						panelSearch.setValue("CUSTOM_CODE","");
						panelSearch.setValue("CUSTOM_NAME","");
						
						UniAppManager.app.onQueryButtonDown(newCard.getId());
						//UniAppManager.app.onResetButtonDown();
						break;
					case 'cdm200skrvGrid5':
					 	panelResult.getField("ITEM_ACCOUNT").setHidden(false)
						panelResult.getField("ITEM_LEVEL1").setHidden(false)
						panelResult.getField("ITEM_LEVEL2").setHidden(false)
						panelResult.getField("ITEM_LEVEL3").setHidden(false)
						panelResult.down("#ITEM_CODE").setHidden(false)
						panelResult.down("#ACCNT_CODE").setHidden(true)
						panelResult.down("#DEPT_CODE").setHidden(true)
						panelResult.down("#CUSTOM_CODE").setHidden(false)
						
						panelSearch.getField("ITEM_ACCOUNT").setHidden(false)
						panelSearch.getField("ITEM_LEVEL1").setHidden(false)
						panelSearch.getField("ITEM_LEVEL2").setHidden(false)
						panelSearch.getField("ITEM_LEVEL3").setHidden(false)
						panelSearch.down("#ITEM_CODE").setHidden(false)
						panelSearch.down("#ACCNT_CODE").setHidden(true)
						panelSearch.down("#DEPT_CODE").setHidden(true)
						panelSearch.down("#CUSTOM_CODE").setHidden(false)
						
						panelResult.setValue("ACCNT_CODE","");
						panelResult.setValue("ACCNT_NAME","");
						panelResult.setValue("DEPT_CODE","");
						panelResult.setValue("DEPT_NAME","");
						panelResult.setValue("CUSTOM_CODE","");
						panelResult.setValue("CUSTOM_NAME","");
						
						panelSearch.setValue("ACCNT_CODE","");
						panelSearch.setValue("ACCNT_NAME","");
						panelSearch.setValue("DEPT_CODE","");
						panelSearch.setValue("DEPT_NAME","");
						panelSearch.setValue("CUSTOM_CODE","");
						panelSearch.setValue("CUSTOM_NAME","");
						
						UniAppManager.app.onQueryButtonDown(newCard.getId());
						//UniAppManager.app.onResetButtonDown();
						break;
					case 'cdm200skrvGrid6':
					 	panelResult.getField("ITEM_ACCOUNT").setHidden(false)
						panelResult.getField("ITEM_LEVEL1").setHidden(false)
						panelResult.getField("ITEM_LEVEL2").setHidden(false)
						panelResult.getField("ITEM_LEVEL3").setHidden(false)
						panelResult.down("#ITEM_CODE").setHidden(false)
						panelResult.down("#ACCNT_CODE").setHidden(true)
						panelResult.down("#DEPT_CODE").setHidden(true)
						panelResult.down("#CUSTOM_CODE").setHidden(true)
						
						panelSearch.getField("ITEM_ACCOUNT").setHidden(false)
						panelSearch.getField("ITEM_LEVEL1").setHidden(false)
						panelSearch.getField("ITEM_LEVEL2").setHidden(false)
						panelSearch.getField("ITEM_LEVEL3").setHidden(false)
						panelSearch.down("#ITEM_CODE").setHidden(false)
						panelSearch.down("#ACCNT_CODE").setHidden(true)
						panelSearch.down("#DEPT_CODE").setHidden(true)
						panelSearch.down("#CUSTOM_CODE").setHidden(true)
						
						panelResult.setValue("ACCNT_CODE","");
						panelResult.setValue("ACCNT_NAME","");
						panelResult.setValue("DEPT_CODE","");
						panelResult.setValue("DEPT_NAME","");
						panelResult.setValue("CUSTOM_CODE","");
						panelResult.setValue("CUSTOM_NAME","");
						
						panelSearch.setValue("ACCNT_CODE","");
						panelSearch.setValue("ACCNT_NAME","");
						panelSearch.setValue("DEPT_CODE","");
						panelSearch.setValue("DEPT_NAME","");
						panelSearch.setValue("CUSTOM_CODE","");
						panelSearch.setValue("CUSTOM_NAME","");
						
						UniAppManager.app.onQueryButtonDown(newCard.getId());
						//UniAppManager.app.onResetButtonDown();
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
		},panelSearch],	
		id  : 'cdm200skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('WORK_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('WORK_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('WORK_SEQ_FR',0);
			panelResult.setValue('WORK_SEQ_FR',0);
			panelSearch.setValue('WORK_SEQ_TO',0);
			panelResult.setValue('WORK_SEQ_TO',0);
			
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown : function(activeId)	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				var grid = this.getCurrentGrid(activeId);
				grid.getStore().loadStoreRecords();
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        onResetButtonDown:function() {
        	panelSearch.clearForm();
        	panelResult.clearForm();
        	masterGrid1.reset();
        	masterGrid1.getStore().clearData();
        	masterGrid2.reset();
        	masterGrid2.getStore().clearData();
        	masterGrid3.reset();
        	masterGrid3.getStore().clearData();
        	masterGrid4.reset();
        	masterGrid4.getStore().clearData();
        	masterGrid5.reset();
        	masterGrid5.getStore().clearData();
        	masterGrid6.reset();
        	masterGrid6.getStore().clearData();
        	UniAppManager.app.fnInitBinding();
        },
        getCurrentGrid:function(activeId){
        	var activeTabId = tab.getActiveTab().getId();
        	if(activeId){
        		activeTabId = activeId;
        	}
        	if(activeTabId == 'cdm200skrvGrid1'){
				return masterGrid1
			}else if(activeTabId == 'cdm200skrvGrid2'){
				return masterGrid2
			}else if(activeTabId == 'cdm200skrvGrid3'){
				return masterGrid3
			}else if(activeTabId == 'cdm200skrvGrid4'){
				return masterGrid4
			}else if(activeTabId == 'cdm200skrvGrid5'){
				return masterGrid5
			}else if(activeTabId == 'cdm200skrvGrid6'){
				return masterGrid6
			}
        }
	});
	
	function setAllFieldsReadOnly(b){
		var r= true
		if(b) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
				if(field.name == 'WORK_SEQ_FR' && field.getValue() == 0){
					return false;
				}
				return !field.validate() ;
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
			//	this.mask();		    
			}
  		} else {
			this.unmask();
		}
		return r;
	}
};
</script>