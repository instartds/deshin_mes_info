<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afs100ukr_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /> <!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A112" /> <!-- 계좌구분 -->
	<t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
	<t:ExtComboStore items="${COMBO_SAVE_CODE}" storeId="saveCode" /> <!--계좌코드-->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_afs100ukrService_KOCIS.selectList',
			update: 's_afs100ukrService_KOCIS.updateDetail',
			create: 's_afs100ukrService_KOCIS.insertDetail',
			destroy: 's_afs100ukrService_KOCIS.deleteDetail',
			syncAll: 's_afs100ukrService_KOCIS.saveAll'
		}
	});	
	/**
	 * Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('Afs100ukrModel', {
	    fields: [  	  
//	    	{name: 'COMP_CODE'		      	  , text: '법인코드'		 	  ,type: 'string',editable:false},  
//            {name: 'DEPT_CODE'                , text: '기관코드'         ,type: 'string',editable:false},
            {name: 'SAVE_CODE'                , text: '계좌코드'             ,type: 'string',editable:false},
            {name: 'AC_GUBUN'                 , text: '회계구분'             ,type: 'string',comboType:'AU', comboCode:'A390',allowBlank:false}, 
             
            {name: 'SAVE_NAME'                , text: '계좌명'              ,type: 'string',allowBlank:false}, 
            {name: 'MONEY_UNIT'               , text: '화폐구분'             ,type: 'string', comboType:'AU', comboCode:'B004',allowBlank:false}, 
            {name: 'SAVE_TYPE'                , text: '계좌구분'             ,type: 'string',comboType:'AU', comboCode:'A112',allowBlank:false}, 
            {name: 'BANK_ACCOUNT'             , text: '계좌번호'             ,type: 'string',allowBlank:false}, 
            {name: 'USE_YN'                   , text: '사용여부'             ,type: 'string',comboType:'AU', comboCode:'A004',allowBlank:false}, 
            {name: 'REMARK'                   , text: '계좌적요'             ,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	var directMasterStore = Unilite.createStore('afs100ukrMasterStore1',{
		model: 'Afs100ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable: true,			// 삭제 가능 여부
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('panelResult').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
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
	
	/**
	 * 검색조건 (Search Panel)
	 * 
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('panelSearch', {		
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
                xtype: 'uniCombobox',
                fieldLabel: '계좌코드',
                name:'SAVE_CODE',   
                store: Ext.data.StoreManager.lookup('saveCode'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('SAVE_CODE', newValue);
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
            }]		
		}]
	});	  
	
	var panelResult = Unilite.createSearchForm('panelResult',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
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
        },{
            xtype: 'uniCombobox',
            fieldLabel: '계좌코드',
            name:'SAVE_CODE',  
            store: Ext.data.StoreManager.lookup('saveCode'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('SAVE_CODE', newValue);
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
        }]
	});	
		
    var masterGrid = Unilite.createGrid('afs100ukrGrid', {
        region:'center',
    	store: directMasterStore,
    	excelTitle: '계좌정보등록',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: true,
			onLoadSelectFirst: true,
//			copiedRow:true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false , enableGroupingMenu:false},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
//        	{dataIndex: 'COMP_CODE'				     ,		width: 100, hidden:true},
//            {dataIndex: 'DEPT_CODE'                  ,       width: 100, hidden:true},
            {dataIndex: 'SAVE_CODE'                  ,       width: 100,hidden:true},
            
            {dataIndex: 'AC_GUBUN'                   ,       width: 100},
            
            {dataIndex: 'SAVE_NAME'                  ,       width: 150},
            {dataIndex: 'MONEY_UNIT'                 ,       width: 120},
            {dataIndex: 'SAVE_TYPE'                  ,       width: 120},
            {dataIndex: 'BANK_ACCOUNT'               ,       width: 200},
            {dataIndex: 'USE_YN'                     ,       width: 100},
            {dataIndex: 'REMARK'                     ,       width: 250}
		],
		listeners:{
			beforeedit : function( editor, e, eOpts ) {	
//				if(e.record.phantom == true){
//					if(UniUtils.indexOf(e.field, ['UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE'])){
//						return false;
//					}
//				}else{
//					if(UniUtils.indexOf(e.field, ['SAVE_CODE','UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE'])){
//						return false;
//					}
//				}
			},	
			afterrender:function()	{
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
			}
		}
    });  
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,panelResult
			]	
		},
			panelSearch  	
		],
		id: 'afs100ukrApp',
		fnInitBinding : function() {
			
            UniAppManager.app.fnInitInputFields();
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
	
		},
		onNewDataButtonDown: function()	{
			var compCode   = UserInfo.compCode;
            var useYn      = 'Y';
            var r = {
        	 	COMP_CODE    : compCode,
        	 	USE_YN 	     : useYn
	        };
			masterGrid.createRow(r);
				
		},
		onResetButtonDown: function() {		
			panelSearch.clearForm();
			panelResult.clearForm();
            masterGrid.reset();
			directMasterStore.clearData();
            UniAppManager.app.fnInitInputFields();
		},
		onSaveDataButtonDown: function(config) {				
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		fnInitInputFields: function(){
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
            
            UniAppManager.setToolbarButtons(['reset','newData'],true);
            UniAppManager.setToolbarButtons(['save'],false);
            
        }
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
// case "BANK_ACCOUNT_CP" : // 계좌번호디스플레이
// if(isNaN(newValue)){
// rv = Msg.sMB074; //숫자만 입력가능합니다.
// break;
// }
// if(newValue){
// //var bankAccount = record.get('BANK_ACCOUNT');
// //var bankAccountDisp = record.get('BANK_ACCOUNT_DISP');
// record.set('BANK_ACCOUNT',newValue);
// }
// break;
			}
			return rv;
		}
	});	
	
};



</script>
