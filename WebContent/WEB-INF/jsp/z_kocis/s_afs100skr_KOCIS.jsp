<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afs100skr_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    <t:ExtComboStore comboType="AU" comboCode="A112" /> <!-- 계좌구분 -->
	<t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('Afs100skrModel', {
	   fields:[
          {name: 'COMP_CODE',text: '법인코드'              ,type: 'string'},
          {name: 'A'        ,text: '계좌'                 ,type: 'string'},
          {name: 'B'        ,text: '계좌구분'              ,type: 'string',comboType:'AU', comboCode:'A112'},
          {name: 'C'        ,text: '예산과목'              ,type: 'string'},
          {name: 'D'        ,text: '예산과목명'             ,type: 'string'},
          {name: 'E'        ,text: '화폐단위'              ,type: 'string',comboType:'AU', comboCode:'B004'},
          {name: 'F'        ,text: '계좌잔액(외화)'         ,type: 'uniPrice'},
          {name: 'G'        ,text: '계좌잔액(현지화)'        ,type: 'uniPrice'}
	   ]	  
	});
	  
			
	var directMasterStore = Unilite.createStore('Afs100skrdirectMasterStore',{
		model: 'Afs100skrModel',
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
                read: 's_afs100skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
//			param.budgNameInfoList = budgNameList;	// 예산목록
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
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                allowBlank:false,
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
                fieldLabel: '계좌구분',
                name: 'AC_MONTH_FR',
                comboType: 'AU',
                comboCode: 'A112',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_MONTH_FR', newValue);
                    }
                }
            }]	
		}]
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },{
            xtype: 'uniYearField',
            fieldLabel: '회계년도',
            name: 'AC_YEAR',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_YEAR', newValue);
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
            xtype: 'uniCombobox',
            fieldLabel: '계좌구분',
            name: 'AC_MONTH_FR',
            comboType: 'AU',
            comboCode: 'A112',
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
    var masterGrid = Unilite.createGrid('Afs100skrGrid', {
    	features: [{
			id: 'masterGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false, enableGroupingMenu:false
		},{
			id: 'masterGridTotal',		
			ftype: 'uniSummary',			
			showSummaryRow: true,
            dock:'bottom'
		}],
        region: 'center',
		store: directMasterStore,
        selModel: 'rowmodel',
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
            { dataIndex: 'COMP_CODE'           ,width:100,hidden:true},
    	    { dataIndex: 'A'                   ,width:120,
    	       summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
    	    },
            { dataIndex: 'B'                   ,width:120},
            { dataIndex: 'C'                   ,width:150},
            { dataIndex: 'D'                   ,width:200},
            { dataIndex: 'E'                   ,width:100},
            { dataIndex: 'F'                   ,width:150,summaryType:'sum'},
            { dataIndex: 'G'                   ,width:150,summaryType:'sum'}
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
		id : 'Afs100skrApp',
		fnInitBinding : function() {
			var param= Ext.getCmp('searchForm').getValues();
			
            UniAppManager.app.fnInitInputFields(); 
		},
		onQueryButtonDown : function()	{
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
        fnInitInputFields: function(){
  /*          var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('FR_AC_DATE');*/
            
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
