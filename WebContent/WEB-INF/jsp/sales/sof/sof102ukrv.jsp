<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof102ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" />		<!-- 창고-->
	<t:ExtComboStore comboType="WU" />		<!-- 작업장  -->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="T109"/>  <!-- 국내외 -->
	<t:ExtComboStore comboType="AU" comboCode="S024"/>  <!-- 부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S003"/>  <!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>  <!-- 세 구분 -->

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
			read	: 'sof102ukrvService.selectList',
			create	: 'sof102ukrvService.insertDetail',
//			update	: 'sof102ukrvService.updateDetail',
//			destroy	: 'sof102ukrvService.deleteDetail',
			syncAll	: 'sof102ukrvService.saveAll'
		}
	});
	
	Unilite.defineModel('detailModel', {
		fields: [
			{name: 'CUST_NO'			,text: '거래처groupby1' 		,type: 'int'},
			{name: 'CUST_SEQ'			,text: '거래처groupby2' 		,type: 'int'},
			{name: 'DIV_CODE'		,text: '사업장' 		,type: 'string', comboType:'BOR120'},
			{name: 'OUT_DIV_CODE'		,text: '출고사업장' 		,type: 'string', comboType:'BOR120'},
			{name: 'ITEM_LEVEL'		,text: '대분류' 		,type: 'string'},
			{name: 'ORDER_NUM'		,text: '수주번호' 		,type: 'string'},
			{name: 'SER_NO'			,text: '수주순번' 		,type: 'string'},
			{name: 'PO_NUM'			,text: '발주번호' 		,type: 'string'},
			{name: 'PO_SEQ'			,text: '항번' 		,type: 'int'},
			{name: 'ITEM_CODE'		,text: '품목' 		,type: 'string'},
			{name: 'ITEM_NAME'		,text: '품목명' 		,type: 'string'},
			{name: 'ORDER_Q'		,text: '수량' 		,type: 'uniQty'},
			{name: 'PO_DATE'		,text: '발주일' 		,type: 'uniDate'},
			{name: 'DVRY_DATE'		,text: '납품예정일' 	,type: 'uniDate'},
			{name: 'WEEK_NUM'		,text: '계획주차' 		,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '거래처' 		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '거래처명' 		,type: 'string'},
			{name: 'DVRY_CUST_CD'	,text: '납품처' 		,type: 'string'},
			{name: 'DVRY_CUST_NM'	,text: '납품처명' 		,type: 'string'},
			{name: 'ORDER_UNIT'		,text: '단위' 		,type: 'string'},
			{name: 'MONEY_UNIT'		,text: '화폐단위' 		,type: 'string'},
			{name: 'ORDER_O'		,text: '금액' 		,type: 'uniPrice'},
			{name: 'ORDER_P'		,text: '단가' 		,type: 'uniUnitPrice'},
			{name: 'NATION_INOUT'	,text: '내/외자구분' 	,type: 'string', comboType:'AU', comboCode:'T109'},
			{name: 'ORDER_TYPE'		,text: '공장구분' 		,type: 'string', comboType:'AU', comboCode:'S002'},
			{name: 'REMARK'			,text: '비고' 		,type: 'string'}
		]
	});	
// 엑셀참조
    Unilite.Excel.defineModel('excel.sof102.sheet01', {
        fields: [
			{name: 'CUST_NO'			,text: '거래처groupby1' 		,type: 'int'},
			{name: 'CUST_SEQ'			,text: '거래처groupby2' 		,type: 'int'},
            {name: 'OUT_DIV_CODE'      ,text: '출고사업장'      ,type: 'string',comboType: 'BOR120'},
            {name: 'PO_NUM'      ,text: '발주번호'      ,type: 'string'},
            {name: 'PO_SEQ'      ,text: '발주항번'      ,type: 'int'},
            {name: 'ITEM_CODE'      ,text: '품목코드'      ,type: 'string'},
            {name: 'ITEM_NAME'      ,text: '품목명'      ,type: 'string'},
            {name: 'ORDER_Q'      ,text: '품목수량'      ,type: 'uniQty'},
            {name: 'PO_DATE'      ,text: '발주일'      ,type: 'uniDate'},
            {name: 'DVRY_DATE'      ,text: '납품요청일'      ,type: 'uniDate'},
            {name: 'CUSTOM_CODE'      ,text: '회사'      ,type: 'string'},
            {name: 'CUSTOM_NAME'      ,text: '회사명'      ,type: 'string'},
            {name: 'DVRY_CUST_CD'      ,text: '납품처'      ,type: 'string'},
            {name: 'DVRY_CUST_NM'      ,text: '납품처명'      ,type: 'string'},
            {name: 'ORDER_UNIT'      ,text: '단위'      ,type: 'string'},
            {name: 'MONEY_UNIT'      ,text: '통화'      ,type: 'string'},
            {name: 'ORDER_O'      ,text: '금액'      ,type: 'uniPrice'},
            {name: 'ORDER_P'      ,text: '단가'      ,type: 'uniUnitPrice'},
            {name: 'REMARK'      ,text: '비고'      ,type: 'string'}

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
                excelConfigName: 'sof102ukrv',
                extParam: {
                    'PGM_ID': 'sof102ukrv',
                    'DIV_CODE'  : panelSearch.getValue('DIV_CODE')
                },
                grids: [{
                    itemId: 'grid01',
                    title: '수주일괄등록엑셀참조',
                    useCheckbox: true,
                    model : 'excel.sof102.sheet01',
                    readApi: 'sof102ukrvService.selectExcelUploadSheet1',
                    columns: [
//								{ dataIndex: 'CUST_NO'			, width: 120},
//								{ dataIndex: 'CUST_SEQ'			, width: 120},
                        {dataIndex: 'PO_NUM'           ,       width: 100},
                        {dataIndex: 'PO_SEQ'           ,       width: 80,align:'center'},
                        {dataIndex: 'OUT_DIV_CODE'     ,       width: 100},
                        {dataIndex: 'ITEM_CODE'        ,       width: 100},
                        {dataIndex: 'ITEM_NAME'        ,       width: 250},
                        {dataIndex: 'ORDER_Q'          ,       width: 100},
                        {dataIndex: 'PO_DATE'          ,       width: 100},
                        {dataIndex: 'DVRY_DATE'        ,       width: 100},
                        {dataIndex: 'CUSTOM_CODE'      ,       width: 100},
                        {dataIndex: 'CUSTOM_NAME'      ,       width: 200},
                        {dataIndex: 'DVRY_CUST_CD'     ,       width: 100},
                        {dataIndex: 'DVRY_CUST_NM'     ,       width: 200},
                        {dataIndex: 'ORDER_UNIT'       ,       width: 80,align:'center'},
                        {dataIndex: 'MONEY_UNIT'       ,       width: 80,align:'center'},
                        {dataIndex: 'ORDER_O'          ,       width: 100},
                        {dataIndex: 'ORDER_P'          ,       width: 100},
                        {dataIndex: 'REMARK'           ,       width: 250}
                    ]
                }],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },
                onApply:function()  {

					detailGrid.reset();
					detailStore.clearData();

	                var grid = this.down('#grid01');
	                var records = grid.getSelectionModel().getSelection();
	                Ext.each(records, function(record,i){
	                    UniAppManager.app.onNewDataButtonDown();
	                    detailGrid.setExcelData(record.data);
	                });
	                grid.getStore().removeAll();
	                this.hide();
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
						var master = batch.operations[0].getResultSet();
						panelSearch.setValue("ORDER_NUM", master.orderNums);
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
		},/*{
            fieldLabel: '<t:message code="system.label.sales.deliveryweek" default="납기주차"/>',
            name: 'DVRY_DATE',
            xtype: 'uniDatefield',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                	
                },
                blur : function (field, event, eOpts) {
                	if(Ext.isEmpty(field.value)){
                    	panelSearch.setValue('WEEK_NUM','');
                	}else{
	                	var param = {
	                		'OPTION_DATE' : UniDate.getDbDateStr(field.value),
	                		'CAL_TYPE' : '3' //주단위
	                	}
	                	prodtCommonService.getCalNo(param, function(provider, response) {
	                        if(!Ext.isEmpty(provider.CAL_NO)){
	                        	panelSearch.setValue('WEEK_NUM',provider.CAL_NO);
	                        }else{
	                        	panelSearch.setValue('WEEK_NUM','');
	                        }
	                	})
                	}
                }
            }
        },{
			fieldLabel: '',
			xtype:'uniTextfield',
			name:'WEEK_NUM',
			width: 60
		},*/{
			fieldLabel: '수주번호',
			xtype:'uniTextfield',
			name:'ORDER_NUM',
			hidden:true
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
//			{ dataIndex: 'CUST_NO'			, width: 120},
//			{ dataIndex: 'CUST_SEQ'			, width: 120},
			{ dataIndex: 'DIV_CODE'			, width: 120},
			{ dataIndex: 'OUT_DIV_CODE'			, width: 120},
			{ dataIndex: 'ITEM_LEVEL'		, width: 120},
			{ dataIndex: 'ORDER_NUM'		, width: 120},
			{ dataIndex: 'SER_NO'			, width: 80,align:'center'},
			{ dataIndex: 'PO_NUM'			, width: 120},
			{ dataIndex: 'PO_SEQ'			, width: 60,align:'center'},
			{ dataIndex: 'ITEM_CODE'		, width: 120},
			{ dataIndex: 'ITEM_NAME'		, width: 250},
			{ dataIndex: 'ORDER_Q'			, width: 120},
			{ dataIndex: 'PO_DATE'			, width: 100},
			{ dataIndex: 'DVRY_DATE'		, width: 100},
			{ dataIndex: 'WEEK_NUM'			, width: 80,align:'center'},
			{ dataIndex: 'CUSTOM_CODE'		, width: 120},
			{ dataIndex: 'CUSTOM_NAME'		, width: 200},
			{ dataIndex: 'DVRY_CUST_CD'		, width: 120},
			{ dataIndex: 'DVRY_CUST_NM'		, width: 200},
			{ dataIndex: 'ORDER_UNIT'		, width: 80,align:'center'},
			{ dataIndex: 'MONEY_UNIT'		, width: 80,align:'center'},
			{ dataIndex: 'ORDER_O'			, width: 120},
			{ dataIndex: 'ORDER_P'			, width: 120},
			{ dataIndex: 'NATION_INOUT'		, width: 100,align:'center'},
			{ dataIndex: 'ORDER_TYPE'		, width: 100,align:'center'},
			{ dataIndex: 'REMARK'			, width: 150}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['ORDER_Q','ORDER_O','ORDER_P'])) {
					return true;
				} else {
					return false;
				}
			}
		},
		setExcelData: function(record) {    //엑셀 업로드 참조
            var grdRecord = this.getSelectedRecord();
            
            grdRecord.set('CUST_NO'      , record['CUST_NO']);
            grdRecord.set('CUST_SEQ'      , record['CUST_SEQ']);

            grdRecord.set('PO_NUM'      , record['PO_NUM']);
            grdRecord.set('PO_SEQ'      , record['PO_SEQ']);
            grdRecord.set('OUT_DIV_CODE'   , record['OUT_DIV_CODE']);
            grdRecord.set('ITEM_CODE'   , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'   , record['ITEM_NAME']);
            grdRecord.set('ORDER_Q'     , record['ORDER_Q']);
            grdRecord.set('PO_DATE'     , record['PO_DATE']);
            grdRecord.set('DVRY_DATE'   , record['DVRY_DATE']);
            grdRecord.set('CUSTOM_CODE' , record['CUSTOM_CODE']);
            grdRecord.set('CUSTOM_NAME' , record['CUSTOM_NAME']);
            grdRecord.set('DVRY_CUST_CD', record['DVRY_CUST_CD']);
            grdRecord.set('DVRY_CUST_NM', record['DVRY_CUST_NM']);
            grdRecord.set('ORDER_UNIT'  , record['ORDER_UNIT']);
            grdRecord.set('MONEY_UNIT'  , record['MONEY_UNIT']);
            grdRecord.set('ORDER_O'     , record['ORDER_O']);
            grdRecord.set('ORDER_P'     , record['ORDER_P']); 
            grdRecord.set('REMARK'      , record['REMARK']);
            
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
		id: 'sof102ukrvApp',
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			
			this.fnInitInputFields();
		},
/*		onQueryButtonDown: function() {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			detailStore.loadStoreRecords();
		},*/
		onNewDataButtonDown: function() {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
            
             var r = {
             	
                DIV_CODE: panelSearch.getValue('DIV_CODE'),
                NATION_INOUT: '1',
                ORDER_TYPE: '20'
                
            };
            detailGrid.createRow(r);
        },
		onSaveDataButtonDown: function(config) {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
		
			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','delete','save','query'], false);
		}
	});
	
	
/*	Unilite.createValidator('validator01', {
        store: detailStore,
        grid: detailGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "ORDER_Q":
					record.set('ORDER_O', newValue * record.get('ORDER_P'));
                   
                break;
                
                case "ORDER_P":
					record.set('ORDER_O', newValue * record.get('ORDER_Q'));
                   
                break;
                
                case "ORDER_O":
					record.set('ORDER_P', newValue / record.get('ORDER_Q'));

                break;
            }
            return rv;
        }
    });*/
};
</script>