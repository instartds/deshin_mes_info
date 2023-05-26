<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str300ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="A071" /> <!-- 반제유형 -->
	<t:ExtComboStore comboType="BOR120" pgmId="str300ukrv"/>		<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	
	var excelWindow;	//SECOM 파일 업로드
	
	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.str300ukrv.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'	, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'DATE_SHIPPING'	, text: '선적일'	 	 	, type: 'uniDate'},			
			{name: 'BOOKING_NUM'	, text: '부킹번호'	 	 	, type: 'string'},
			{name: 'CONTAINER_NO'	, text: '컨테이너 번호'	 	 	, type: 'string'},
			{name: 'SEAL_NO'		, text: '실넘버'	 	 	, type: 'string'},
			{name: 'INOUT_CODE'		, text: '거래처코드'	 	, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '거래처명'	  		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '품목코드'	 	 	, type: 'string'},
			{name: 'ITEM_NAME'		, text: '품명'	 	 	, type: 'string'},
			{name: 'LOT_NO'			, text: 'LOT번호'	 	 	, type: 'string'},
			{name: 'INOUT_Q'		, text: '수량'	 	 	, type: 'uniQty'},			
			{name: 'ORDER_UNIT'		, text: '단위'	 	 	, type: 'string'},
			{name: 'ORDER_NUM'		, text: '수주번호' 	 	, type: 'string'},
			{name: 'ORDER_SEQ'		, text: '수주순번' 		, type: 'int'},
			{name: 'PO_NUM'			, text: 'PO번호' 			, type: 'string'},
			{name: 'INOUT_NUM'		, text: '출고번호' 		, type: 'string'},
			{name: 'INOUT_SEQ'		, text: '출고순번' 		, type: 'int'}

						
		]
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('str300ukrvModel', {
	    fields: [  	  
	    	{name: 'COMP_CODE'		,text: 'COMP_CODE'			,type: 'string'},
	    	{name: 'DIV_CODE'		,text: 'DIV_CODE'			,type: 'string'},
	    	{name: 'DATE_SHIPPING'   	,text: '선적일'			,type: 'uniDate'},
		    {name: 'BOOKING_NUM'		,text: '부킹번호'			,type: 'string'},
		    {name: 'CONTAINER_NO' 		,text: '컨테이너 번호'		,type: 'string'},
		    {name: 'SEAL_NO' 			,text: '실넘버'			,type: 'string'},
		    {name: 'INOUT_CODE'  		,text: '거래처코드'		,type: 'string'},
		    {name: 'CUSTOM_NAME'		,text: '거래처명'			,type: 'string'},
		    {name: 'ITEM_CODE' 			,text: '품목코드'			,type: 'string'},
		    {name: 'ITEM_NAME'			,text: '품명'				,type: 'string'},
		    {name: 'LOT_NO'				,text: 'LOT번호'			,type: 'string'},
		    
		    {name: 'INOUT_Q'			,text: '수량'				,type: 'uniQty'},
		    {name: 'ORDER_UNIT'			,text: '단위'				,type: 'string'},
		    {name: 'ORDER_NUM'			,text: '수주번호'			,type: 'string'},
		    {name: 'ORDER_SEQ'			,text: '수주순번'			,type: 'int'},
		    {name: 'PO_NUM'				,text: 'PO번호'			,type: 'string'},
		    {name: 'INOUT_NUM'			,text: '출고번호'			,type: 'string'},
		    {name: 'INOUT_SEQ'			,text: '출고순번'			,type: 'int'}
		    
		    //{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.base.updateuser" default="수정자"/>'			,type: 'string'},
		    //{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.base.updatedate" default="수정일"/>'			,type: 'uniDate'} 
		]
	}); //End of Unilite.defineModel('bcm200ukrvModel', {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'str300ukrvService.selectDetailList',
			update: 'str300ukrvService.updateDetail',
			create: 'str300ukrvService.insertDetail',
			destroy: 'str300ukrvService.deleteDetail',
			syncAll: 'str300ukrvService.saveAll'
		}
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('str300ukrvMasterStore',{
		model: 'str300ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
		proxy: directProxy,
        loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{	
//				var paramMaster= [];
//				var app = Ext.getCmp('bpr101ukrvApp');
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	
			if(inValidRecs.length == 0 )	{					
				config = {
					success: function(batch, option) {								
//						detailForm.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [
		    	{
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: false,
					value		: UserInfo.divCode,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {							
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},
				{
					fieldLabel		: '출고일',
					width			: 315,
					xtype			: 'uniDateRangefield',
					startFieldName	: 'FR_DATE',
					endFieldName	: 'TO_DATE',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					allowBlank		: false,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_DATE',newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_DATE',newValue);
						}
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					validateBlank	: false,
					autoPopup		: true,
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER': ['1', '3']});
							popup.setExtParam({'CUSTOM_TYPE': ['1', '3']});
						}
					}
				})
			]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
	    		{
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					value		: UserInfo.divCode,
					allowBlank	: false,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {							
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},
				{
					fieldLabel		: '출고일',
					width			: 315,
					xtype			: 'uniDateRangefield',
					allowBlank		: false,
					startFieldName	: 'FR_DATE',
					endFieldName	: 'TO_DATE',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelSearch) {
							panelSearch.setValue('FR_DATE',newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelSearch) {
							panelSearch.setValue('TO_DATE',newValue);
						}
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					autoPopup		: true,
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('CUSTOM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('CUSTOM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER': ['1', '3']});
							popup.setExtParam({'CUSTOM_TYPE': ['1', '3']});
						}
					}
				})
				/*,{
					xtype:'container',
					html: '※ 조회한 데이터를 엑셀다운로드 한 후, 컨테이너번호와 실넘버를 입력하고 엑셀업로드 해 주세요.',
					padding: '10 0 10 45',
					colspan:3,
					style: {
						color: 'red'				
					}
				}*/
			]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('str300ukrvGrid', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
		tbar: [{
			//xtype:'button',
			text:'엑셀 업로드',
			id  : 'excelBtn',
			handler:function()	{
				if(confirm('컨테이너번호와 실넘버는 삭제되고 새로운 데이터가 업로드 됩니다.')) {
					openExcelWindow();
				}
			}
		}],
        columns: [        			 
	    	{ dataIndex: 'COMP_CODE'		, width: 100	, align: 'center'	, hidden: true},
	    	{ dataIndex: 'DIV_CODE'			, width: 100	, align: 'center' 	, hidden: true},
			{ dataIndex: 'DATE_SHIPPING'	, width: 100	, align: 'center'},
			{ dataIndex: 'BOOKING_NUM'		, width: 120},
			{ dataIndex: 'CONTAINER_NO'		, width: 120},
			{ dataIndex: 'SEAL_NO'			, width: 120},
			{ dataIndex: 'INOUT_CODE'		, width: 100},
			{ dataIndex: 'CUSTOM_NAME'		, width: 150},
			
			{ dataIndex: 'ITEM_CODE'		, width: 100},
			{ dataIndex: 'ITEM_NAME'		, width: 130},
			{ dataIndex: 'LOT_NO'			, width: 120},
			{ dataIndex: 'INOUT_Q'			, width: 100	, align: 'right'},
			{ dataIndex: 'ORDER_UNIT'		, width: 80		, align: 'center'},
			{ dataIndex: 'ORDER_NUM'		, width: 120},
			{ dataIndex: 'ORDER_SEQ'		, width: 80		, align: 'center'},
			{ dataIndex: 'PO_NUM'			, width: 100},
			{ dataIndex: 'INOUT_NUM'		, width: 120},			
			{ dataIndex: 'INOUT_SEQ'		, width: 80		, align: 'center'}
			
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,[
					'CONTAINER_NO','SEAL_NO'
				])){
					return true;
				}else{
					return false;
				}
				
			}
		}
    });	//End of   var masterGrid = Unilite.createGrid('bcm200ukrvGrid', {

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
		id: 'str300ukrvApp',
		fnInitBinding : function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			//panelSearch.setValue('TO_DATE', UniDate.get('today'));
			//panelSearch.setValue('FR_DATE', UniDate.get('today'));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			//panelResult.setValue('TO_DATE', UniDate.get('today'));
			//panelResult.setValue('FR_DATE', UniDate.get('today'));
			
			//UniAppManager.setToolbarButtons('newData',true);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {       // 초기화
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            directMasterStore.clearData();
            this.fnInitBinding();
        },
		onNewDataButtonDown : function(additemCode)	{        	 
//        	 var moneyUnit = UserInfo.currency;
//        	 var saleDate = UniDate.get('today');
//        	 var itemCode = '';
//        	 if(!Ext.isEmpty(additemCode)){
//        	 	itemCode = additemCode
//        	 }
        	 var r = {
//				MONEY_UNIT: moneyUnit,
//				SALE_DATE: saleDate,
//				DIV_CODE: panelSearch.getValue('DIV_CODE'),
//				ITEM_CODE: itemCode
	        };	        
			masterGrid.createRow(r);
			//openDetailWindow(null, true);
		},
		/**
		 *  삭제
		 *	@param 
		 *	@return
		 */
		 onDeleteDataButtonDown: function() {
			if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		/**
		 *  저장
		 *	@param 
		 *	@return
		 */
		onSaveDataButtonDown: function (config) {
//			var rtnrecord = masterGrid.getSelectedRecord();
//			if(!Ext.isEmpty(rtnrecord)){
//				if(Ext.isEmpty(rtnrecord.get('SALE_DATE'))){
//					rtnrecord.set('SALE_DATE', UniDate.get('today'))
//				}
//			}			
			directMasterStore.saveStore(config);			
		}/*,
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}*/
	}); //End of Unilite.Main( {
	
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		
		var appName = 'Unilite.com.excel.ExcelUpload';
		
		var record = masterGrid.getSelectedRecord();
		
		if (!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create(appName, {
				modal : false,
				excelConfigName: 'str300ukrv',
				extParam: { 
                    'PGM_ID'    : 'str300ukrv',
                    'DIV_CODE'     : panelSearch.getValue('DIV_CODE')
        		},
				
				grids: [{							//팝업창에서 가져오는 그리드
                		itemId		: 'grid01',
                		xtype       : 'uniGridPanel',
                		title		: '컨테이너번호 업로드',                        		
                		useCheckbox	: false,
                		model		: 'excel.str300ukrv.sheet01',
                		readApi		: 'str300ukrvService.selectExcelUploadSheet',
                		columns		: [	
                			{dataIndex: '_EXCEL_JOBID'			, width: 80,	hidden: true},
							{dataIndex: 'DATE_SHIPPING'  		, width: 100},
							{dataIndex: 'BOOKING_NUM'			, width: 120},
							{dataIndex: 'CONTAINER_NO'			, width: 120},
							{dataIndex: 'SEAL_NO'				, width: 120},
							{dataIndex: 'INOUT_CODE'			, width: 100},
							{dataIndex: 'CUSTOM_NAME'			, width: 150},
							{dataIndex: 'ITEM_CODE'				, width: 100},
							{dataIndex: 'ITEM_NAME'				, width: 130},
							{dataIndex: 'LOT_NO'				, width: 140},
							{dataIndex: 'INOUT_Q'				, width: 100, align: 'right'},
							{dataIndex: 'ORDER_UNIT'			, width: 80,  align: 'center'},
							{dataIndex: 'ORDER_NUM'				, width: 120},
							{dataIndex: 'ORDER_SEQ'				, width: 80,  align: 'center'},
							{dataIndex: 'PO_NUM'				, width: 120},
							{dataIndex: 'INOUT_NUM'				, width: 120},
							{dataIndex: 'INOUT_SEQ'				, width: 80,  align: 'center'}						
                		]
                	}
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    }
/*                    ,
                    beforeShow: function() {
                    	var tabPanel = this.items.getAt(1);
                    	
                    	if(tabPanel.xtype == 'tabpanel') {
                    		tabPanel.items.each(function(tab){
                    	if(tab.title == 'Help') {
                    		tabPanel.remove(tab);
                    		}
                    	});
                    	}
                    }*/
                },
                onApply:function()	{
                	excelWindow.getEl().mask('로딩중...','loading-indicator');
                	var me		= this;
                	var grid	= this.down('#grid01');
        			var records	= grid.getStore().getAt(0);	
        			if (!Ext.isEmpty(records)) {
			        	var param	= {
			        		"_EXCEL_JOBID" : records.get('_EXCEL_JOBID'),
			        		"DIV_CODE"     : panelSearch.getValue('DIV_CODE')
			        	};
			        	excelUploadFlag = "Y"
			        	//alert(panelSearch.getValue('DIV_CODE'));
			        	masterGrid.reset();
						directMasterStore.clearData();
						
						str300ukrvService.selectExcelUploadSheet(param, function(provider, response){
					    	var store	= masterGrid.getStore();
					    	var records	= response.result;
					    	
					    	store.insert(0, records);
					    	console.log("response",response)
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
					    });
						excelUploadFlag = "N"
		        	} else {
		        		alert (Msg.fSbMsgH0284);
		        		this.unmask();  
		        	}
        		}
			});
		}
		excelWindow.center();
		excelWindow.show();
	}
};

</script>
