<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb520skr_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="A132" />         <!-- 수지구분 -->
    <t:ExtComboStore comboType="AU" comboCode="B042" />         <!-- 금액단위 -->
    <t:ExtComboStore comboType="AU" comboCode="A390" />         <!-- 회계구분 -->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('Afb510Model1', {
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'				, type: 'string'},
			{name: 'BUDG_CODE'					, text: '예산과목'				, type: 'string'},
			{name: 'BUDG_NAME'					, text: '예산과목'				, type: 'string'},
			{name: 'BUDG_I_TOT'					, text: '예산'				, type: 'uniPrice'},
			{name: 'AC_I_TOT'					, text: '실적'				, type: 'uniPrice'},
			{name: 'CHANGE_I_TOT'				, text: '증감액'				, type: 'uniPrice'},
			{name: 'CHANGE_RATE'				, text: '증감비'				, type: 'uniPrice'},
			{name: 'BUDG_I_TOT_LAST'			, text: '예산'				, type: 'uniPrice'},
			{name: 'AC_I_TOT_LAST'				, text: '실적'				, type: 'uniPrice'},
			{name: 'CHANGE_I_TOT_LAST'			, text: '증감액'				, type: 'uniPrice'},
			{name: 'CHANGE_RATE_LAST'			, text: '증감비'				, type: 'uniPrice'},
			{name: 'BUDG_TYPE'					, text: '수지구분'				, type: 'string', comboType: 'AU', comboCode: 'A132'}
	    ]
	});
	
	var masterStore = Unilite.createStore('Afb510masterStore',{
		model: 'Afb510Model1',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_afb520skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
    	width: 360,
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
                xtype: 'uniYearField',
                fieldLabel: '예산년도',
                name: 'AC_YEAR',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_YEAR', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name: 'AC_GUBUN',
                comboType: 'AU',
                comboCode: 'A390',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_GUBUN', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                name: 'BUDG_TYPE',
                comboType:'AU',
                comboCode:'A132',
                value: '2',
                fieldLabel: '수지구분',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('BUDG_TYPE', newValue);
                    }
                }
             },{
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },
            Unilite.popup('BUDG',{
                fieldLabel: '예산과목',
                valueFieldName:'BUDG_CODE_FR',
                textFieldName:'BUDG_NAME_FR',
                //validateBlank:false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE_FR', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME_FR', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue("FR_AC_DATE")).substring(0,4)});
                    }
                }
            }),
            Unilite.popup('BUDG',{
                fieldLabel: '~',
                valueFieldName:'BUDG_CODE_TO',
                textFieldName:'BUDG_NAME_TO',
                //validateBlank:false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE_TO', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME_TO', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue("FR_AC_DATE")).substring(0,4)});
                    }
                }
            }),
            {
                xtype: 'uniCombobox',
                name: 'MONEY_UNIT',
                comboType:'AU',
                comboCode:'B042',
                value: '1',
                fieldLabel: '금액단위',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('MONEY_UNIT', newValue);
                    }
                }
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '집계구분',
//                id: 'RDO_SELECT',
                items: [{
                    boxLabel: '부서/예산과목', 
                    width: 115,
                    name: 'RDO',
                    inputValue: '1',
                    checked: true  
                },{
                    boxLabel: '예산과목', 
                    width: 70,
                    name: 'RDO',
                    inputValue: '2'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.getField('RDO').setValue(newValue.RDO); 
//                        UniAppManager.app.setHiddenColumn();
                        UniAppManager.app.onQueryButtonDown();
                    }
                }
            },{
                
                xtype: 'uniCheckboxgroup',  
                fieldLabel: '예산실적집계',
                items: [{
                    boxLabel: '본예산',
                    width: 60,
                    name: 'BUDG_GUBUN1',
                    inputValue: '1',
                    uncheckedValue: '0',
                    checked: true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('BUDG_GUBUN1', newValue);
                        }
                    }
                },{
                    boxLabel: '이월예산',
                    width: 130,
                    name: 'BUDG_GUBUN2',
                    inputValue: '2',
                    uncheckedValue: '0',
                    checked: true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('BUDG_GUBUN2', newValue);
                        }
                    }
                }]
            }]	
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
            xtype: 'uniYearField',
            fieldLabel: '예산년도',
            name: 'AC_YEAR',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelResult.setValue('AC_YEAR', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            name: 'AC_GUBUN',
            comboType: 'AU',
            comboCode: 'A390',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelResult.setValue('AC_GUBUN', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            name: 'BUDG_TYPE',
            comboType:'AU',
            comboCode:'A132',
            value: '2',
            fieldLabel: '수지구분',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelResult.setValue('BUDG_TYPE', newValue);
                }
            }
         },{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelResult.setValue('DEPT_CODE', newValue);
                }
            }
        },
        Unilite.popup('BUDG',{
            fieldLabel: '예산과목',
            valueFieldName:'BUDG_CODE_FR',
            textFieldName:'BUDG_NAME_FR',
            //validateBlank:false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelResult.setValue('BUDG_CODE_FR', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelResult.setValue('BUDG_NAME_FR', newValue);                
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue("FR_AC_DATE")).substring(0,4)});
                }
            }
        }),
        Unilite.popup('BUDG',{
            fieldLabel: '~',
            valueFieldName:'BUDG_CODE_TO',
            textFieldName:'BUDG_NAME_TO',
            labelWidth:15,
            //validateBlank:false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelResult.setValue('BUDG_CODE_TO', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelResult.setValue('BUDG_NAME_TO', newValue);                
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue("FR_AC_DATE")).substring(0,4)});
                }
            }
        }),
        {
            xtype: 'uniCombobox',
            name: 'MONEY_UNIT',
            comboType:'AU',
            comboCode:'B042',
            value: '1',
            fieldLabel: '금액단위',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelResult.setValue('MONEY_UNIT', newValue);
                }
            }
        },{
            xtype: 'radiogroup',                            
            fieldLabel: '집계구분',
            id: 'RDO_SELECT',
            items: [{
                boxLabel: '부서/예산과목', 
                width: 115,
                name: 'RDO',
                inputValue: '1',
                checked: true  
            },{
                boxLabel: '예산과목', 
                width: 70,
                name: 'RDO',
                inputValue: '2'
            }],
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelResult.getField('RDO').setValue(newValue.RDO); 
//                    UniAppManager.app.setHiddenColumn();
                    UniAppManager.app.onQueryButtonDown();
                }
            }
        },{
            xtype: 'uniCheckboxgroup',  
            fieldLabel: '예산실적집계',
            items: [{
                boxLabel: '본예산',
                width: 60,
                name: 'BUDG_GUBUN1',
                inputValue: '1',
                uncheckedValue: '0',
                checked: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('BUDG_GUBUN1', newValue);
                    }
                }
            },{
                boxLabel: '이월예산',
                width: 130,
                name: 'BUDG_GUBUN2',
                inputValue: '2',
                uncheckedValue: '0',
                checked: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('BUDG_GUBUN2', newValue);
                    }
                }
            }]
        }]
	});
    var masterGrid = Unilite.createGrid('Afb510Grid1', {
    	features: [{
			id: 'masterGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'masterGridTotal',		
			ftype: 'uniSummary',			
			showSummaryRow: false
		}],
    	layout : 'fit',
        region : 'center',
		store: masterStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: false,
			useRowContext 		: false,
			expandLastColumn	: false,
			onLoadSelectFirst 	: false,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false
		},
        columns: [
        	{dataIndex: 'COMP_CODE'										, width: 66, hidden: true},
        	{dataIndex: 'BUDG_CODE'										, width: 133},
        	{dataIndex: 'BUDG_NAME'										, width: 200},
        	{dataIndex: 'CODE_LEVEL'									, width: 66, hidden: true},
        	{text: '당기',
				columns:[
		        	{dataIndex: 'BUDG_I_TOT'									, width: 115,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I_TOT');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'AC_I_TOT'										, width: 115,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('AC_I_TOT');
								}
							});			 	
						 	return sumData;
					 	}
		            }
		        ]
        	},
        	{text: '예산대비실적 증감',
				columns:[
		        	{dataIndex: 'CHANGE_I_TOT'									, width: 115,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('CHANGE_I_TOT');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'CHANGE_RATE'									, width: 115,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('CHANGE_RATE');
								}
							});			 	
						 	return sumData;
					 	}
		            }
		        ]
        	},
        	{text: '전기',
				columns:[
		        	{dataIndex: 'BUDG_I_TOT_LAST'								, width: 115,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I_TOT_LAST');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'AC_I_TOT_LAST'									, width: 115,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('AC_I_TOT_LAST');
								}
							});			 	
						 	return sumData;
					 	}
		            }
		        ]
        	},
        	{text: '전기대비실적 증감',
				columns:[
		        	{dataIndex: 'CHANGE_I_TOT_LAST'								, width: 115,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('CHANGE_I_TOT_LAST');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'CHANGE_RATE_LAST'								, width: 115,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('CHANGE_RATE_LAST');
								}
							});			 	
						 	return sumData;
					 	}
		            }
		        ]
        	},
        	{text: '구분',
				columns:[
        			{dataIndex: 'BUDG_TYPE'										, width: 80}
        		]
        	}
        ],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '예산집행상세내역조회',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb555(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb555:function(record)	{
			if(record)	{
		    	var params = {/*
					action:'select',
					'PGM_ID'			: 'afb600ukr',
					'AC_DATE' 			: record.data['AC_DATE'],
					'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE'),
					'ACCNT' 			: record.data['ACCNT'],	
					'ACCNT_NAME' 		: record.data['ACCNT_NAME'],
					'START_DATE'		: panelSearch.getValue('START_DATE')
				*/}
		  		var rec1 = {data : {prgID : 'afb555ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb555ukr.do', params);
			}
    	}
    });   
    
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
		id : 'Afb510App',
		fnInitBinding : function() {
            UniAppManager.app.fnInitInputFields(); 
		},
		onQueryButtonDown : function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            masterStore.loadStoreRecords();
        },
        //링크로 넘어오는 params 받는 부분 (Agj100skr)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'afb500skr') {
				panelSearch.setValue('AC_YYYY',params.AC_YYYY);
				panelSearch.setValue('BUDG_CODE',params.BUDG_CODE);
				//panelSearch.setValue('BUDG_NAME',params.BUDG_NAME);
				panelSearch.setValue('BUDG_CODE',params.BUDG_CODE);
				//panelSearch.setValue('BUDG_NAME',params.BUDG_NAME);
				panelSearch.setValue('DEPT_CODE',params.DEPT_CODE);
				panelSearch.setValue('DEPT_NAME',params.DEPT_NAME);
				panelSearch.setValue('BUDG_TYPE',params.BUDG_TYPE);
				panelSearch.setValue('RDO',params.RDO);
				panelSearch.setValue('MONEY_UNIT',params.MONEY_UNIT);
				panelSearch.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);	
				panelSearch.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);	
				panelResult.setValue('AC_YYYY',params.AC_YYYY);
				panelResult.setValue('BUDG_CODE',params.BUDG_CODE);
				//panelResult.setValue('BUDG_NAME',params.BUDG_NAME);
				panelResult.setValue('BUDG_CODE',params.BUDG_CODE);
				//panelResult.setValue('BUDG_NAME',params.BUDG_NAME);
				panelResult.setValue('DEPT_CODE',params.DEPT_CODE);
				panelResult.setValue('DEPT_NAME',params.DEPT_NAME);
				panelResult.setValue('BUDG_TYPE',params.BUDG_TYPE);
				panelResult.setValue('RDO',params.RDO);
				panelResult.setValue('MONEY_UNIT',params.MONEY_UNIT);
				panelResult.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);	
				panelResult.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);	
			}
			masterStore.loadStoreRecords();
        },
        fnInitInputFields: function(){
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
//            activeSForm.onLoadSelectText('FR_AC_DATE');
            
//            panelSearch.setValue('AC_YEAR', UniDate.get('today'));
//            panelResult.setValue('AC_YEAR', UniDate.get('today'));
            
            
            
//            panelSearch.setValue('FR_AC_DATE', UniDate.get('startOfMonth'));
//            panelSearch.setValue('TO_AC_DATE', UniDate.get('today'));
//            panelResult.setValue('FR_AC_DATE', UniDate.get('startOfMonth'));
//            panelResult.setValue('TO_AC_DATE', UniDate.get('today'));
            UniAppManager.setToolbarButtons('save',false);
            UniAppManager.setToolbarButtons('reset',true);
            
            panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
            panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
            
            if(!Ext.isEmpty(UserInfo.deptCode)){
                if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                    panelResult.getField('DEPT_CODE').setReadOnly(false);
                }else{
                    panelSearch.getField('DEPT_CODE').setReadOnly(true);
                    panelResult.getField('DEPT_CODE').setReadOnly(true);
                }
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
            }
        }
	});
};
</script>
