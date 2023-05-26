<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb800skr_KOCIS"  >

    <t:ExtComboStore comboType="AU" comboCode="A134" />            <!-- 결재상태 --> 
	<t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
    <t:ExtComboStore items="${COMBO_SAVE_CODE}" storeId="saveCode" /> <!--계좌코드-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	Unilite.defineModel('Afb800Model', {
        fields: [
            {name: 'SEQ'                , text: '순번'                , type: 'int'},
            {name: 'STATUS'             , text: '결재상태'             , type: 'string',comboType:'AU', comboCode:'A134'},
            {name: 'IN_DRAFT_NO'        , text: '수입결의번호'          , type: 'string'},
            {name: 'IN_DATE'            , text: '수입작성일'            , type: 'uniDate'},
            {name: 'TITLE'              , text: '수입건명'              , type: 'string'},
            {name: 'IN_AMT_I'          , text: '수입액'               , type: 'uniPrice'},
            {name: 'BUDG_CODE'          , text: '예산과목'              , type: 'string'},
            {name: 'BUDG_NAME'          , text: '예산과목명'              , type: 'string'},
            {name: 'INOUT_DATE'         , text: '입금일자'              , type: 'uniDate'},
            {name: 'ACCT_NO'            , text: '입금계좌'              , type: 'string', store: Ext.data.StoreManager.lookup('saveCode')},
            {name: 'BANK_NUM'       , text: '계좌번호'              , type: 'string'},
            {name: 'REMARK'             , text: '적요'                 , type: 'string'},
            {name: 'AP_STS'             , text: '승인상태'              , type: 'string'}
        ]
	});	
	  
	var masterStore = Unilite.createStore('Afb800masterStore',{
		model: 'Afb800Model',
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
                read: 's_afb800skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
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
                fieldLabel: '수입작성일',
                xtype: 'uniDateRangefield',
                startFieldName: 'IN_DATE_FR',
                endFieldName: 'IN_DATE_TO',
                allowBlank: false,                  
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('IN_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('IN_DATE_TO', newValue);                           
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
            Unilite.popup('USER', {
				fieldLabel: '기안자', 
				valueFieldName: 'DRAFTER',
	    		textFieldName: 'DRAFT_NAME', 
				listeners: {
					onValueFieldChange: function(field, newValue){
                        panelResult.setValue('DRAFTER', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('DRAFT_NAME', newValue);                
                    }
				}
            }),
			Unilite.popup('BUDG_KOCIS_NORMAL',{
                fieldLabel: '예산과목',
                valueFieldName:'BUDG_CODE',
                textFieldName:'BUDG_NAME',
                autoPopup:true,
                //validateBlank:false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue('IN_DATE_FR')).substring(0, 4)}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '1' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            }),
            { 
	    		fieldLabel: '수입건명',
			    xtype: 'uniTextfield',
			    name: 'TITLE',
			    width: 325,	
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('TITLE', newValue);
			      	}
	     		}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '상태',
				items: [{
					boxLabel: '전체', 
					width: 45,
					name: 'STATUS',
                    inputValue: '',
					checked: true  
				},{
					boxLabel: '미상신', 
					width: 60,
					name: 'STATUS',
					inputValue: '0'
				},{
					boxLabel: '결재중', 
					width: 60,
					name: 'STATUS',
					inputValue: '1'
				},{
					boxLabel: '반려', 
					width: 45,
					name: 'STATUS',
					inputValue: '5'
				},{
					boxLabel : '완결', 
					width: 45,
					name: 'STATUS',
					inputValue: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('STATUS').setValue(newValue.STATUS);					
//						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
	    		xtype: 'uniCheckboxgroup',	
	    		//padding: '0 0 0 0',
	    		fieldLabel: ' ',
	    		items: [{
	    			boxLabel: '반려제외',
	    			width: 130,
	    			name: 'STOP_CHECK',
	    			inputValue: '1',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('STOP_CHECK', newValue);
						}
					}
	    		}]
	        }]	
		}]
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
            fieldLabel: '수입작성일',
            xtype: 'uniDateRangefield',
            startFieldName: 'IN_DATE_FR',
            endFieldName: 'IN_DATE_TO',
            allowBlank: false,                  
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('IN_DATE_FR', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('IN_DATE_TO', newValue);                           
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },
        Unilite.popup('USER', {
            fieldLabel: '기안자', 
            valueFieldName: 'DRAFTER',
            textFieldName: 'DRAFT_NAME', 
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('DRAFTER', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('DRAFT_NAME', newValue);                
                }
            }
        }),
        Unilite.popup('BUDG_KOCIS_NORMAL',{
            fieldLabel: '예산과목',
            valueFieldName:'BUDG_CODE',
            textFieldName:'BUDG_NAME',
            autoPopup:true,
            //validateBlank:false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME', newValue);                
                },
                applyextparam: function(popup) {
                	popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue('IN_DATE_FR')).substring(0, 4)}),
                    popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '1' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        }),
        { 
            fieldLabel: '수입건명',
            xtype: 'uniTextfield',
            name: 'TITLE',
            width: 325, 
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('TITLE', newValue);
                }
            }
        },{
            xtype: 'container',
            layout : {type : 'uniTable'},
            items:[{
                xtype: 'radiogroup',                            
                fieldLabel: '상태',
                items: [{
                    boxLabel: '전체', 
                    width: 45,
                    name: 'STATUS',
                    inputValue: '',
                    checked: true  
                },{
                    boxLabel: '미상신', 
                    width: 60,
                    name: 'STATUS',
                    inputValue: '0'
                },{
                    boxLabel: '결재중', 
                    width: 60,
                    name: 'STATUS',
                    inputValue: '1'
                },{
                    boxLabel: '반려', 
                    width: 45,
                    name: 'STATUS',
                    inputValue: '5'
                },{
                    boxLabel : '완결', 
                    width: 45,
                    name: 'STATUS',
                    inputValue: '9'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.getField('STATUS').setValue(newValue.STATUS);                   
                        UniAppManager.app.onQueryButtonDown();
                    }
                }
            },{
                xtype: 'uniCheckboxgroup',  
//                      padding: '-2 0 0 -100',
                fieldLabel: '',
                items: [{
                    boxLabel: '반려제외',
                    width: 130,
                    name: 'STOP_CHECK',
                    inputValue: '1',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.setValue('STOP_CHECK', newValue);
                        }
                    }
                }]
            }]
        }]
	});
	
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb800Grid1', {
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
        region : 'center',
		store: masterStore,
        selModel	: 'rowmodel',
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
    		filter: {
				useFilter		: false,
				autoCreate		: false
			}
        },
        columns: [
            {dataIndex: 'SEQ'            , width: 60,hidden:true},
            {dataIndex: 'STATUS'               , width: 100},
            {dataIndex: 'IN_DRAFT_NO'          , width: 100},
            {dataIndex: 'IN_DATE'              , width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },
            {dataIndex: 'TITLE'                , width: 150},
            {dataIndex: 'IN_AMT_I'            , width: 120,summaryType:'sum'},
            {dataIndex: 'BUDG_CODE'            , width: 170,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },
            {dataIndex: 'BUDG_NAME'            , width: 150},
            {dataIndex: 'INOUT_DATE'           , width: 100},
            {dataIndex: 'ACCT_NO'            , width: 120},
            {dataIndex: 'BANK_NUM'         , width: 150},
            {dataIndex: 'REMARK'               , width: 250},
            {dataIndex: 'AP_STS'               , width: 120}
            
        ],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
                masterGrid.gotoAfb800ukr(record);
            }
			/*
	        itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}*/
		},
		
	/*	
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},*/
     /*   uniRowContextMenu:{
			items: [
	            {	text: '수입결의등록 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb800(param.record);
	            	}
	        	}
	        ]
	    },*/
		gotoAfb800ukr:function(record)	{
			if(record)	{
		    	var params = {
					'PGM_ID'       : 's_afb800skr_KOCIS',
					'IN_DRAFT_NO'  : record.data['IN_DRAFT_NO']
				}
		  		var rec1 = {data : {prgID : 's_afb800ukr_kocis', 'text':''}};							
				parent.openTab(rec1, '/z_kocis/s_afb800ukr_kocis.do', params);
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
		id : 'Afb800App',
		fnInitBinding : function() {
			
			
            UniAppManager.app.fnInitInputFields(); 
           
			
			/*var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('IN_DATE_FR');
			var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;	//예산목록
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('IN_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('IN_DATE_TO', UniDate.get('today'));
			panelResult.setValue('IN_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('IN_DATE_TO', UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);*/
		},
		onQueryButtonDown : function()	{
            if(!panelResult.getInvalidMessage()) return;   //필수체크		
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
            
            panelSearch.setValue('IN_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('IN_DATE_TO', UniDate.get('today'));
            panelResult.setValue('IN_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('IN_DATE_TO', UniDate.get('today'));
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
