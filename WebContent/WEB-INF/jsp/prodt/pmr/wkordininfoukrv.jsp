<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="wkordininfoukrv"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" />		<!-- 창고-->
	<t:ExtComboStore comboType="WU" />		<!-- 작업장  -->

</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >

function appMain() {
	var gubunStore = Unilite.createStore('gubunComboStore', {  
        fields: ['text', 'value'],
        data :  [
            {'text':'<t:message code="system.label.purchase.confirm" default="확인"/>'  , 'value':'Y'},
            {'text':'<t:message code="system.label.purchase.notconfirm" default="미확인"/>'  , 'value':'N'}
        ]
    });
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'wkordininfoukrvService.selectList',
//			create	: 'wkordininfoukrvService.insertDetail',
			update	: 'wkordininfoukrvService.updateDetail',
//			destroy	: 'wkordininfoukrvService.deleteDetail',
			syncAll	: 'wkordininfoukrvService.saveAll'
		}
	});
	
	Unilite.defineModel('detailModel', {
		fields: [
			{name: 'DIV_CODE'			,text: '사업장' 			,type: 'string',comboType:'BOR120'},
			{name: 'WORK_SHOP_CODE'		,text: '작업장코드' 		,type: 'string'},
			{name: 'WORK_SHOP_NAME'		,text: '작업장' 			,type: 'string'},
			{name: 'PROG_WORK_CODE'		,text: '공정코드' 			,type: 'string'},
			{name: 'PROG_WORK_NAME'		,text: '공정명' 			,type: 'string'},
			{name: 'WKORD_NUM'			,text: '작업지시번호' 		,type: 'string'},
			{name: 'ITEM_CODE'			,text: '품목' 			,type: 'string'},
			{name: 'ITEM_NAME'			,text: '품명' 			,type: 'string'},
			{name: 'SPEC'				,text: '규격' 			,type: 'string'},
			{name: 'PRODT_START_DATE'	,text: '착수예정일' 		,type: 'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '완료예정일' 		,type: 'uniDate'},
			{name: 'REMARK'				,text: '비고' 			,type: 'string'}
		]
	});	

	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						detailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
				
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			metachange:function( store, meta, eOpts ){
			}
		}
	});

	var detailGrid = Unilite.createGrid('detailGrid', {
		store: detailStore,
		region: 'center',
		layout: 'fit',
		uniOpt: {
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: false,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		columns: [
			{ dataIndex: 'DIV_CODE'				, width: 120},
			{ dataIndex: 'WORK_SHOP_CODE'		, width: 120},
			{ dataIndex: 'WORK_SHOP_NAME'		, width: 120},
			{ dataIndex: 'PROG_WORK_CODE'		, width: 120},
			{ dataIndex: 'PROG_WORK_NAME'		, width: 120},
			{ dataIndex: 'WKORD_NUM'			, width: 120,
				editor : Unilite.popup('WKORD_NUM_G',{						            
    				textFieldName:'WKORD_NUM',
    				autoPopup:true,
    				listeners: {
		                'onSelected':  function(records, type  ){
	                    	var grdRecord = detailGrid.uniOpt.currentRecord;
	                    	grdRecord.set('WKORD_NUM',records[0]['WKORD_NUM']);
		                },
		                'onClear':  function( type  ){
	                    	var grdRecord = detailGrid.uniOpt.currentRecord;
	                    	grdRecord.set('WKORD_NUM','');
		                },
		                applyextparam: function(popup){				
	                    	var grdRecord = detailGrid.uniOpt.currentRecord;			
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							popup.setExtParam({'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE')});
							popup.setExtParam({'PROG_WORK_CODE': grdRecord.get('PROG_WORK_CODE')});
						}
		                
		            }
				})
			},
			{ dataIndex: 'ITEM_CODE'			, width: 120},
			{ dataIndex: 'ITEM_NAME'			, width: 250},
			{ dataIndex: 'SPEC'					, width: 120},
			{ dataIndex: 'PRODT_START_DATE'		, width: 120},
			{ dataIndex: 'PRODT_END_DATE'		, width: 120},
			{ dataIndex: 'REMARK'				, width: 120}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['WKORD_NUM'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});
	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns : 2},
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                	panelSearch.setValue('WORK_SHOP_CODE','');
                }
            }
		},{
			fieldLabel: '작업장',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'WU',
			allowBlank: false,
			listeners:{
                beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                    store.clearFilter();
                    if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                        store.filterBy(function(record){
                            return record.get('option') == panelSearch.getValue('DIV_CODE');
                        })
                    }else{
                        store.filterBy(function(record){
                            return false;
                        })
                    }
                }
			}
		}]
	});
	
	Unilite.Main({
		id			: 'wkordininfoukrvApp',
		border		: false,
		borderItems	: [{
			id		: 'pageAll',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch, detailGrid
			]
		}],
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			
			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			panelSearch.getField('WORK_SHOP_CODE').setReadOnly(true);
			detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
		
			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			panelSearch.setValue("DIV_CODE", UserInfo.divCode);
			
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			panelSearch.getField('WORK_SHOP_CODE').setReadOnly(false);
			
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','delete','save'], false);
		}
	});
};
</script>