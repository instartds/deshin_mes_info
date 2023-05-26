<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb730skr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_afb730skr_KOCIS" /> 	<!-- 사업장 -->
	
	
    <t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('Afb730skrModel', {
        fields:[
			{name: 'TRANS_DATE'				, text: '지급일'			, type: 'uniDate'},
			{name: 'DRAFT_DATE'				, text: '기안(추산)일'		, type: 'uniDate'},
			{name: 'AC_GUBUN'               , text: '회계구분'         ,type: 'string',comboType:'AU', comboCode:'A390'},
            {name: 'AC_TYPE'                , text: '원인행위'         ,type: 'string',comboType:'AU', comboCode:'A391'},
			{name: 'DRAFT_TITLE'			, text: '기안(추산)건명'	, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '거래처명'			, type: 'string'},
			{name: 'BUDG_CONF_I'			, text: '예산액'			, type: 'uniPrice'},
			{name: 'DRAFT_AMT'				, text: '기안(추산)금액'	, type: 'uniPrice'},
			{name: 'DRAFT_REMIND_AMT'		, text: '기안(추산)잔액'	, type: 'uniPrice'},
			{name: 'TRANS_AMT'				, text: '지급액'			, type: 'uniPrice'}
//			{name: 'REMARK'					, text: '비고'			, type: 'string'}
	   
        ]
	});		// End of Ext.define('afb730skrModel', {
	  
			
	var directMasterStore = Unilite.createStore('Afb730skrdirectMasterStore',{
		model: 'Afb730skrModel',
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
                read: 's_afb730skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
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
            Unilite.popup('BUDG_KOCIS', {
                fieldLabel: '예산과목', 
                valueFieldName: 'BUDG_CODE',
                textFieldName: 'BUDG_NAME', 
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue("FR_AC_DATE")).substring(0,4)});
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
		     	}
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
        Unilite.popup('BUDG_KOCIS', {
            fieldLabel: '예산과목', 
            valueFieldName: 'BUDG_CODE',
            textFieldName: 'BUDG_NAME', 
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME', newValue);                
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue("FR_AC_DATE")).substring(0,4)});
                }
            }
        })],	
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
		     	} 
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
    /*
	 * Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb730skrGrid', {
        region : 'center',
		store: directMasterStore,
//        selModel	: 'rowmodel',
		features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: false
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',
    			dock:'bottom',
    			showSummaryRow: false
    		}
    	],
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
				if(record.get('TYPE_FLAG') == 'S'){
					return 'x-change-cell_Background_normal_Text_blue';	
				}
	        }
	    },
        columns:[
        	{dataIndex: 'TRANS_DATE'						, width: 88,align:'center'},
        	{dataIndex: 'DRAFT_DATE'						, width: 88},
        	{dataIndex: 'AC_GUBUN'                          , width: 100},
        	{dataIndex: 'AC_TYPE'                           , width: 100},
        	{dataIndex: 'DRAFT_TITLE'						, width: 300},
        	{dataIndex: 'CUSTOM_NAME'						, width: 200},
        	{dataIndex: 'BUDG_CONF_I'						, width: 120},
        	{dataIndex: 'DRAFT_AMT'							, width: 120},
        	{dataIndex: 'DRAFT_REMIND_AMT'					, width: 120},
        	{dataIndex: 'TRANS_AMT'							, width: 120}
//        	{dataIndex: 'REMARK'							, width: 88}
        ]
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
		id : 'Afb730skrApp',
		fnInitBinding : function() {
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
