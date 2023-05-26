<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm100ukrv"  >
</t:appConfig>
<script type="text/javascript">
	
Ext.onReady(function() {
	Unilite.defineModel('Mms510ukrvModel1', {
		fields: [
	    	{name: 'ITEM_CODE' 	          	, text: '품목코드'					, type: 'string', allowBlank: false},
	    	{name: 'ITEM_NAME' 	        	, text: '품목명'					, type: 'string'},
	    	
		]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mms510ukrvService.selectList',
			update: 'mms510ukrvService.updateDetail',
			create: 'mms510ukrvService.insertDetail',
			destroy: 'mms510ukrvService.deleteDetail',
			syncAll: 'mms510ukrvService.saveAll'
		}
	});	
	var directMasterStore1 = Unilite.createStore('mms510ukrvMasterStore1', {
		model: 'Mms510ukrvModel1',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		
		
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
           	
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		console.log("directMasterStore1 updated : ",record);
           	}
		}

	});

	var masterGrid = Unilite.createGrid('mms510ukrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
		store: directMasterStore1,
		columns: [
			
			{dataIndex: 'ITEM_CODE' 	        , width:120,/*locked: true,*/
				editor: Unilite.popup('DIV_PUMOK_G', {		
			 							textFieldName: 'ITEM_CODE',
			 							DBtextFieldName: 'ITEM_CODE',
			 							extParam: {SELMODEL: 'MULTI', DIV_CODE: '01', POPUP_TYPE: 'GRID_CODE'},
			 							//validateBlank: false,
			 							useBarcodeScanner: true,
										listeners: {'onSelected': {
														fn: function(records, type) {
																console.log('records : ', records);
																console.log("BBBBBBBBBBBB : ");
															},
														scope: this
														
														
														},
													'onClear': function(type) {
																	var a = masterGrid.uniOpt.currentRecord.get('ITEM_CODE');
																	console.log("AAAAAAAAAAAAA : ", a);
																	if(a != ''){
																		alert("미등록상품입니다.");
																		
																	}
																	masterGrid.uniOpt.currentRecord.set('ITEM_CODE',a);
															
																}
										}
								})
			},
			{dataIndex: 'ITEM_NAME' 	        , width:120}
		],
		listeners:{
			edit:function( editor, context, eOpts )	{
				console.log("editor : ", editor, "context:", context);
			}
		}
	});
		var app = Ext.create('Unilite.com.BaseApp', {
			items : [ masterGrid ],
			onQueryButtonDown:function() {
				var form = Ext.getCmp('searchForm');
	            console.log(form.getValues());
			},
			fnInitBinding: function(){
				UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			},
			onNewDataButtonDown: function()	{
				masterGrid.createRow();
			},
            onSaveDataButtonDown: function (config) {
	            
	        }
		});

	});
	
    

</script>