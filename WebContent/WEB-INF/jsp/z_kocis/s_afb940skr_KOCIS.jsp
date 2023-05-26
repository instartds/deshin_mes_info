<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb940skr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_afb940skr_KOCIS" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 --> 
	
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    
	<t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
var draftNo = '';
var inI = '';
var outI ='';
var accrueI = '';


function appMain() {
	Unilite.defineModel('Afb940skrModel', {
	   fields:[
          {name: 'BUDG_CODE1'       ,text: '세부사업'              ,type: 'string'},
          {name: 'BUDG_CODE2'       ,text: '목/세목'              ,type: 'string'},
          {name: 'PAY_DATE'         ,text: '지출일자'              ,type: 'string'},
          {name: 'TITLE'            ,text: '적요'                ,type: 'string'},
          {name: 'TOT_AMT_I'        ,text: '지출금액(현지화)'       ,type: 'uniPrice'},
          {name: 'REMARK'           ,text: '비고'                ,type: 'string'}
	   ]
	});		// End of Ext.define('afb940skrModel', {
	  
	var directMasterStore = Unilite.createStore('Afb940skrdirectMasterStore',{
		model: 'Afb940skrModel',
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
                read: 's_afb940skrService_KOCIS.selectList'                	
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
		}, groupField: 'BUDG_CODE2'
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
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },{
                xtype: 'uniYearField',
                fieldLabel: '회계년도',
                name: 'AC_YEAR',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_YEAR', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '발생월',
                name: 'AC_MONTH_FR',
                comboType: 'AU',
                comboCode: 'HE24',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_MONTH_FR', newValue);
                    }
                }
            }]	
		}]
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('panelResult',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
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
        {
            xtype: 'uniYearField',
            fieldLabel: '회계년도',
            name: 'AC_YEAR',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_YEAR', newValue);
                    
                    panelSearch.setValue('BUDG_CODE_LV1', '');
                    panelResult.setValue('BUDG_CODE_LV1', '');
                    panelSearch.setValue('BUDG_CODE_LV4', '');
                    panelResult.setValue('BUDG_CODE_LV4', '');
                    panelSearch.setValue('BUDG_CODE_LV6', '');
                    panelResult.setValue('BUDG_CODE_LV6', '');
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '발생월',
            name: 'AC_MONTH_FR',
            comboType: 'AU',
            comboCode: 'HE24',
            width:200,
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_MONTH_FR', newValue);
                }
            }
        }]
	});
	
    /*
	 * Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb940skrGrid', {
    	title:'목별지출명세서',
        features: [ {
            id : 'masterGridSubTotal', 
            ftype: 'uniGroupingsummary',    
            showSummaryRow: true 
        },{
            id : 'masterGridTotal',
//            itemID: 'test',
            ftype: 'uniSummary',
//            dock : 'top',
            showSummaryRow: true
        }],
//    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
        selModel : 'rowmodel',
		tbar:[/*{
            xtype: 'button',
            text: '출납계산서 표지출력',
            handler: function() {
            }
        },'-',*/{
            xtype: 'button',
            text: '인쇄',
            handler: function() {/*
                var records = directSearchStore.data.items;
                Ext.each(records,  function(record, index, records){
                    record.set('SELECT', false);
                    
                    searchGrid.down("#checkListSum").setValue(0);
                });
            */}
        },'-'
        ],
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
        columns: [
            { dataIndex: 'BUDG_CODE1'                   ,width:150},
            { dataIndex: 'BUDG_CODE2'                   ,width:150},
            { dataIndex: 'PAY_DATE'                     ,width:110, align : 'center',
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
    	    },
            { dataIndex: 'TITLE'                        ,width:250},
            { dataIndex: 'TOT_AMT_I'                    ,width:150, summaryType: 'sum'},
            { dataIndex: 'REMARK'                       ,width:200}
        ],
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store){
                var cls = '';
                
//              if(Ext.isEmpty(record.get('GUBUN'))){
//                  cls = 'x-change-cell_dark';
//              }
                if(record.get('BUDG_CODE1') == '소계'){
                    cls = 'x-change-cell_light';
                }
                else if(record.get('BUDG_CODE1') == '합계'){
                    cls = 'x-change-cell_normal';
                }
                /*else if(record.get('GUBUN') == '4') {
                    cls = 'x-change-cell_dark';
                }
                if(record.get('MOD_DIVI') == 'D'){
                    cls = 'x-change-celltext_red';  
                }*/
                return cls;
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
		id : 'Afb940skrApp',
		fnInitBinding : function() {
			var param= Ext.getCmp('searchForm').getValues();
			
            UniAppManager.app.fnInitInputFields(); 
		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
                return false;
            }else{
                masterGrid.getStore().loadStoreRecords();
            }
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
            this.fnInitInputFields();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        fnInitInputFields: function(){
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
