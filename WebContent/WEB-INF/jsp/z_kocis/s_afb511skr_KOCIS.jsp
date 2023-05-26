<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb511ukr_KOCIS"  >
	
    <t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
    Unilite.defineModel('Afb511Model1', {
        fields: [
            {name: 'A'                 , text: '예산과목'          , type: 'string'},
            {name: 'B'                 , text: '부문'             , type: 'string'},
            {name: 'C'                 , text: '세부사업'          , type: 'string'},
            {name: 'D'                 , text: '세목'             , type: 'string'},
            {name: 'E'                 , text: '년차예산'          , type: 'uniPrice'}
        ]
    }); 
	  		
	var masterStore = Unilite.createStore('Afb511masterStore',{
		model: 'Afb511Model1',
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
                read: 's_afb511skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
    	width: 380,
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
                fieldLabel: '사업년도',
                name: 'AC_YEAR',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_YEAR', newValue);
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
            }),
            Unilite.popup('BUDG_KOCIS', {
                fieldLabel: '~', 
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
            }),	
            {
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
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
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
            fieldLabel: '사업년도',
            name: 'AC_YEAR',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_YEAR', newValue);
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
                    popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue("FR_AC_DATE")).substring(0,4)});
                }
            }
        }), 
        {
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
            fieldLabel: '~', 
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
                    popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue("FR_AC_DATE")).substring(0,4)});
                }
            }
        })
        ]
	});

    var masterGrid = Unilite.createGrid('Afb511Grid1', {
    	features: [{
			id: 'masterGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'masterGridTotal',		
			ftype: 'uniSummary',			
			showSummaryRow: true
		}],
    	layout : 'fit',
        region : 'center',
		store: masterStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: false,
			useRowContext 		: false,
			expandLastColumn	: true,
			onLoadSelectFirst 	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true
		},
        columns:[
            {dataIndex: 'A'    , width: 150},       
            {dataIndex: 'B'    , width: 150},         
            {dataIndex: 'C'    , width: 150},         
            {dataIndex: 'D'    , width: 150},         
            {dataIndex: 'E'    , width: 120}
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
		id : 'Afb511App',
		fnInitBinding : function() {
            UniAppManager.app.fnInitInputFields(); 
			
		},
		onQueryButtonDown : function()	{	
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            masterStore.clearData();
            this.fnInitInputFields();
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
