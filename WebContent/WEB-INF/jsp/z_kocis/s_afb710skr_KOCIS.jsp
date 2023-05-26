<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb710skr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_afb710skr_KOCIS" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 --> 
	
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
	<t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
    <t:ExtComboStore items="${COMBO_SAVE_CODE}" storeId="saveCode" /> <!--계좌코드-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	
	Unilite.defineModel('Afb710skrModel', {
	   fields:[
	       {name: 'COMP_CODE'                  , text: '법인코드'          , type: 'string'},
           {name: 'PAY_DRAFT_NO'               , text: '지출번호'          , type: 'string'},
           {name: 'DEPT_CODE'                  , text: '기관'             , type: 'string'},
           {name: 'PAY_DATE'                   , text: '일자'             , type: 'uniDate'},
           {name: 'AC_GUBUN'                   , text: '회계구분'          , type: 'string',comboType:'AU', comboCode:'A390'},
           {name: 'AC_TYPE'                    , text: '원인행위'          , type: 'string',comboType:'AU', comboCode:'A391'},
           {name: 'AAA'                        , text: '문서번호'          , type: 'string'},
           {name: 'BUDG_CODE'                  , text: '예산과목'          , type: 'string'},
           {name: 'BUDG_NAME_1'                , text: '부문'             , type: 'string'},
           {name: 'BUDG_NAME_4'                , text: '세부사업'          , type: 'string'},
           {name: 'BUDG_NAME_6'                , text: '세목'             , type: 'string'},
           {name: 'BANK_NUM'                   , text: '계좌'             , type: 'string'},
           {name: 'TOT_AMT_I'                  , text: '지출금액'          , type: 'uniPrice'},
           {name: 'REMARK'                     , text: '적요'             , type: 'string'},
           {name: 'CUSTOM_CODE'                , text: '거래처코드'         , type: 'string'},
           {name: 'CUSTOM_NAME'                , text: '거래처명'          , type: 'string'}
	   ]
	   
	});		// End of Ext.define('afb710skrModel', {
	  
			
	var directMasterStore = Unilite.createStore('Afb710skrdirectMasterStore',{
		model: 'Afb710skrModel',
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
                read: 's_afb710skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
      groupField:'BUDG_NAME_6',
		listeners: {
           	load: function(store, records, successful, eOpts) {
				
/*				if(directMasterStore.count() != 0){
	           		var record = directMasterStore.data.items[0];
	           		if(record.data.GUBUN == '1'){
	           			
	           			
	           			directMasterStore.remove(record);
	           		}
           		}*/
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
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
                fieldLabel: '일자기준',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_AC_DATE',
                endFieldName: 'TO_AC_DATE',
                allowBlank: false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('FR_AC_DATE', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('TO_AC_DATE', newValue);
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
                fieldLabel: '원인행위',
                name: 'AC_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'A391',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('AC_TYPE', newValue);
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
                        popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue('FR_AC_DATE')).substring(0, 4)}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            })]	
		}]
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
            fieldLabel: '일자기준',
            xtype: 'uniDateRangefield',
            startFieldName: 'FR_AC_DATE',
            endFieldName: 'TO_AC_DATE',
            allowBlank: false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('FR_AC_DATE', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('TO_AC_DATE', newValue);
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
                    panelSearch.setValue('AC_GUBUN', newValue);
                }
            }
        },{
            fieldLabel: '원인행위',
            name: 'AC_TYPE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'A391',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('AC_TYPE', newValue);
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
                    popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue('FR_AC_DATE')).substring(0, 4)}),
                    popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        })]
	});
	
    /*
	 * Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb710skrGrid', {
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: true, enableGroupingMenu:false
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: true
    		}
    	],
//    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
        selModel	: 'rowmodel',
		uniOpt: {
			useMultipleSorting	: false,
    		useLiveSearch		: false,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        columns:[
            {dataIndex: 'COMP_CODE'                   , width: 100,hidden:true},
            {dataIndex: 'PAY_DRAFT_NO'                , width: 100,hidden:true},
            {dataIndex: 'DEPT_CODE'                   , width: 100,hidden:true},
            
            {dataIndex: 'PAY_DATE'                     , width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },
            {dataIndex: 'AC_GUBUN'                    , width: 100},
            {dataIndex: 'AC_TYPE'                     , width: 100},
            {dataIndex: 'AAA'                         , width: 100},
            {dataIndex: 'BUDG_CODE'                   , width: 170,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },
            {dataIndex: 'BUDG_NAME_1'                 , width: 150},
            {dataIndex: 'BUDG_NAME_4'                 , width: 150},
            {dataIndex: 'BUDG_NAME_6'                 , width: 150},
            
            {dataIndex: 'BANK_NUM'                    , width: 150},
            {dataIndex: 'TOT_AMT_I'                   , width: 130,summaryType:'sum'},
            {dataIndex: 'REMARK'                      , width: 250},
            {dataIndex: 'CUSTOM_CODE'                 , width: 100, hidden:true},
            {dataIndex: 'CUSTOM_NAME'                 , width: 120}
        ],
        uniRowContextMenu:{
			items: [{	
				text: '지출결의등록 보기',   
				id:'linkAfb700ukr',
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		masterGrid.gotoAfb700ukr(param.record);
            	}
	        },{	
        		text: '수입결의등록 보기',   
        		id:'linkAfb800ukr',
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		masterGrid.gotoAfb800ukr(param.record);
            	}
        	}
	        ]
	    },
		viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
				if(record.get('GUBUN') == '3' || record.get('GUBUN') == '4'){
					return 'x-change-cell_Background_light_Text_blue';	
				}else if(record.get('GUBUN') == '5'){
					return 'x-change-cell_Background_normal_Text_blue';	
				}
	        }
	    },
		listeners: {
	        itemmouseenter:function(view, record, item, index, e, eOpts )	{  
	        	if(record.get('GUBUN') == '2'){
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
        	}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{ 
			if(record.get('GUBUN') == '2'){
      			if(record.get('BUDG_TYPE') == '1'){
					menu.down('#linkAfb700ukr').hide();
					menu.down('#linkAfb800ukr').show();
				}else if(record.get('BUDG_TYPE') == '2'){
					menu.down('#linkAfb800ukr').hide();
					menu.down('#linkAfb700ukr').show();
				}
      			return true;
			}
      	},
		gotoAfb700ukr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 's_afb710skr_KOCIS',
					'PAY_PAY_DRAFT_NO' : record.data['PAY_DRAFT_NO']
					//파라미터 추후 추가
				}
		  		var rec1 = {data : {prgID : 'afb700ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb700ukr.do', params);
			}
    	},
    	gotoAfb800ukr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 's_afb710skr_KOCIS',
					'PAY_PAY_DRAFT_NO' : record.data['PAY_DRAFT_NO']
					//파라미터 추후 추가
				}
		  		var rec1 = {data : {prgID : 'afb800ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb800ukr.do', params);
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
		id : 'Afb710skrApp',
		fnInitBinding : function() {
			var param= Ext.getCmp('searchForm').getValues();
			
            UniAppManager.app.fnInitInputFields(); 
		},
		onQueryButtonDown : function()	{
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            
				directMasterStore.loadStoreRecords();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked: ", viewLocked);
//			console.log("viewNormal: ", viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        fnInitInputFields: function(){
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('FR_AC_DATE');
            
            panelSearch.setValue('FR_AC_DATE', UniDate.get('startOfMonth'));
            panelSearch.setValue('TO_AC_DATE', UniDate.get('today'));
            panelResult.setValue('FR_AC_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_AC_DATE', UniDate.get('today'));
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
