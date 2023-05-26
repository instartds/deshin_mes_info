<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_cdr400ukrv_novis"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>  <!-- 재고단위 -->

</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >

var excelWindow;    // 엑셀참조

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_cdr400ukrv_novisService.selectList',
			create	: 's_cdr400ukrv_novisService.insertDetail',
			destroy	: 's_cdr400ukrv_novisService.deleteDetail',
			syncAll	: 's_cdr400ukrv_novisService.saveAll'
		}
	});
	
	Unilite.defineModel('detailModel', {
		fields: [
		    {name: 'ITEM_ACCOUNT'	,text: '품목계정' 	    ,type: 'string', comboType:'AU', comboCode:'B020'},			
            {name: 'ITEM_CODE'      ,text: '품목코드'      ,type: 'string'},
            {name: 'ITEM_NAME'      ,text: '품목명'       ,type: 'string'},
            {name: 'ITEM_SPEC'      ,text: '규격'        ,type: 'string'},
            {name: 'ITEM_UNIT'      ,text: '재고단위'      ,type: 'string'},
            {name: 'BASIC_Q'        ,text: '기초수량'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'BASIC_AMOUNT_I' ,text: '기초금액'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'INSTOCK_Q'      ,text: '입고수량'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'INSTOCK_I'      ,text: '입고금액'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'OUTSTOCK_Q'     ,text: '출고수량'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'OUTSTOCK_I'     ,text: '출고금액'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'STOCK_Q'        ,text: '재고수량'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'STOCK_I'        ,text: '재고금액'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'}  
		]
	});	
// 엑셀참조
    Unilite.Excel.defineModel('s_cdr400ukrv_novisModel', {
        fields: [
			{name: 'ITEM_ACCOUNT'	,text: '품목계정' 	    ,type: 'string', comboType:'AU', comboCode:'B020'},
            {name: 'ITEM_CODE'      ,text: '품목코드'      ,type: 'string'},
            {name: 'ITEM_NAME'      ,text: '품목명'       ,type: 'string'},
            {name: 'ITEM_SPEC'      ,text: '규격'      ,type: 'string'},
            {name: 'ITEM_UNIT'      ,text: '재고단위'      ,type: 'string'},
            {name: 'BASIC_Q'        ,text: '기초수량'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'BASIC_AMOUNT_I' ,text: '기초금액'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'INSTOCK_Q'      ,text: '입고수량'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'INSTOCK_I'      ,text: '입고금액'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'OUTSTOCK_Q'     ,text: '출고수량'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'OUTSTOCK_I'     ,text: '출고금액'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'STOCK_Q'        ,text: '재고수량'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'STOCK_I'        ,text: '재고금액'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'}            

        ]
    });
    
    function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';

        if(!Ext.isEmpty(excelWindow)){
            excelWindow.extParam.DIV_CODE = panelSearch.getValue('DIV_CODE');
        }
        if(!excelWindow) {
            excelWindow =  Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
                modal: false,
                excelConfigName: 's_cdr400ukrv_novis',
                extParam: {
                    'PGM_ID': 's_cdr400ukrv_novis',
                    'DIV_CODE'  : panelSearch.getValue('DIV_CODE')
                },
                grids: [{
                    itemId: 'grid01',
                    title: '원가계산수불부엑셀참조',
                    useCheckbox: false,
                    model : 's_cdr400ukrv_novisModel',
                    readApi: 's_cdr400ukrv_novisService.selectExcelUploadSheet1',
                    columns: [

                        {dataIndex: 'ITEM_ACCOUNT'     ,       width: 100},
                        {dataIndex: 'ITEM_CODE'        ,       width: 100},
                        {dataIndex: 'ITEM_NAME'        ,       width: 250},
                        {dataIndex: 'ITEM_SPEC'        ,       width: 80},
                        {dataIndex: 'ITEM_UNIT'        ,       width: 80,align:'center'},
                        {dataIndex: 'BASIC_Q'          ,       width: 100},
                        {dataIndex: 'BASIC_AMOUNT_I'   ,       width: 100},
                        {dataIndex: 'INSTOCK_Q'        ,       width: 100},
                        {dataIndex: 'INSTOCK_I'        ,       width: 100},
                        {dataIndex: 'OUTSTOCK_Q'       ,       width: 100},
                        {dataIndex: 'OUTSTOCK_I'       ,       width: 100},
                        {dataIndex: 'STOCK_Q'          ,       width: 100},
                        {dataIndex: 'STOCK_I'          ,       width: 100}                        
                    ]
                }],
                listeners: {
					beforeshow: function( panel, eOpts ) {
						this.down('#grid01').getStore().sort({property : '_EXCEL_ROWNUM', direction: 'ASC'});
					},
					beforehide: function(me, eOpt) {
						var me		= this;
						var grid	= this.down('#grid01');
						excelWindow.getEl().unmask();
						grid.getStore().removeAll();
					},
					beforeclose: function() {
						this.hide();
					}
                },
				onApply:function() {
					var flag = true
					var grid = this.down('#grid01');
					var records = grid.getStore().data.items;
					Ext.each(records, function(record,i){
						if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
							console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
							flag = false;
							return false;
						}
					});
					if(!flag){
						Unilite.messageBox("에러가 있는 행은 적용이 불가능합니다.");
					} else{
						if(UniAppManager.app._needSave())	{
							return;
						}
						detailGrid.store.loadData({});
						detailGrid.setExcelData(records);
						// grid.getStore().remove(records);
						var beforeRM = grid.getStore().count();
						grid.getStore().remove(records);
						var afterRM = grid.getStore().count();
						if (beforeRM > 0 && afterRM == 0){
							excelWindow.close();
						}
					}
				} 
             });
        }
        excelWindow.center();
        excelWindow.show();
    }
    
    
    
	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false,		// prev | next 버튼 사용
			allDeletable: true
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
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
           	load: function(store, records, successful, eOpts) {
				if(store.getCount() == 0) {
					UniAppManager.setToolbarButtons('deleteAll', false);
				}else {
					UniAppManager.setToolbarButtons('deleteAll', true);
				}           		
           	}
		}
	});

	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns : 5},
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value : UserInfo.divCode
		},{
			name: 'COST_YYYYMM',
		 	fieldLabel: '기준월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
		  	allowBlank: false,
		  	maxLength: 200,
      		width:230
		},{
			xtype:'button',
			text:'엑셀업로드',
			margin: '0 0 0 50',
            handler:function(){
           		if(!panelSearch.getInvalidMessage()) return;   //필수체크
            	openExcelWindow();
            }
		}]
	});
	
	var detailGrid = Unilite.createGrid('detailGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
//            userToolbar:false,
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		store: detailStore,
		selModel:'rowmodel',
		columns: [
			{dataIndex: 'ITEM_ACCOUNT'     ,       width: 100},
            {dataIndex: 'ITEM_CODE'        ,       width: 100},
            {dataIndex: 'ITEM_NAME'        ,       width: 250},
            {dataIndex: 'ITEM_SPEC'        ,       width: 200},
            {dataIndex: 'ITEM_UNIT'        ,       width: 80,align:'center'},
            {dataIndex: 'BASIC_Q'          ,       width: 100},
            {dataIndex: 'BASIC_AMOUNT_I'   ,       width: 100},
            {dataIndex: 'INSTOCK_Q'        ,       width: 100},
            {dataIndex: 'INSTOCK_I'        ,       width: 100},
            {dataIndex: 'OUTSTOCK_Q'       ,       width: 100},
            {dataIndex: 'OUTSTOCK_I'       ,       width: 100},
            {dataIndex: 'STOCK_Q'          ,       width: 100},
            {dataIndex: 'STOCK_I'          ,       width: 100} 
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {

				return false;
			
			}
		},
		setExcelData: function(records) {
			var grdRecord			= this.getSelectedRecord();
			var newDetailRecords	= new Array();
			var columns				= this.getColumns();
			Ext.each(records, function(record, i){
				var r = {
//					'DIV_CODE': panelSearch.getValue('DIV_CODE')
				};
				newDetailRecords[i] = detailStore.model.create( r );
				Ext.each(columns, function(column, index) {
					newDetailRecords[i].set(column.initialConfig.dataIndex, record.get(column.initialConfig.dataIndex));
				});

			});
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			panelSearch.getField('COST_YYYYMM').setReadOnly(true);
			detailStore.loadData(newDetailRecords, true);
		}
	});
	
	Unilite.Main({
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				panelSearch, detailGrid
			]
		}],
		id: 's_cdr400ukrv_novisApp',
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
			detailStore.loadStoreRecords();

		},	
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					 //신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;

						if(deletable){
							detailGrid.reset();
							detailStore.saveStore();
						}
					}
					return false;
				}
			});
			if(isNewData){							//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
			}

		},		
		onSaveDataButtonDown: function(config) {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
            
            var param = panelSearch.getValues();
			s_cdr400ukrv_novisService.checkDetail(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					
					Ext.MessageBox.show({
						msg : '기존 등록한 원가계산수불부정보가 존재합니다. 삭제후 다시 등록하시겠습니까?' ,
						icon: Ext.Msg.WARNING,
						buttons : Ext.MessageBox.OKCANCEL,
						fn : function(buttonId) {
							switch (buttonId) {
								case 'ok' :
									detailStore.saveStore();
									break;
								case 'cancel' :
									break;
							}
						},
						scope : this
					}); // MessageBox

				}else{
					detailStore.saveStore();
				}
			});            
	
			
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('COST_YYYYMM', UniDate.get('startOfMonth'));
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			panelSearch.getField('COST_YYYYMM').setReadOnly(false);
			
			UniAppManager.setToolbarButtons(['reset','query'], true);
			UniAppManager.setToolbarButtons(['print','delete','newData','save'], false);
		}
	});
	

};
</script>