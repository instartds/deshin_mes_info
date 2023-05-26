<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr830ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmr830ukrv"/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P505"/> 				<!-- 작업자 -->
	<t:ExtComboStore comboType="AU" comboCode="B079"/> 				<!-- 작업그룹 -->
	<t:ExtComboStore comboType="W"/>								<!-- 작업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('pmr830ukrvModel', {
	    fields: [  	  
	    	{name: 'COMP_CODE'   		,text: '법인코드'				,type: 'string'},
		    {name: 'DIV_CODE'			,text: '사업장'				,type: 'string'},
		    //{name: 'WORK_SHOP_CODE' 	,text: '작업장'				,type: 'string', comboType: 'W', allowBlank: false},
		    {name: 'WORK_SHOP_CODE' 	,text: '작업장'				,type: 'string', comboType:'AU', comboCode:'B079',  allowBlank: false},
		    {name: 'CHECK_DATE' 		,text: '점검일자'				,type: 'uniDate', allowBlank: false},
		    {name: 'FR_TIME'  			,text: '점검시간(시작)'			,type: 'string' , format:'Hi', allowBlank: false},
		    {name: 'TO_TIME'			,text: '점검시간(종료)'			,type: 'string' , format:'Hi', allowBlank: false},
		    {name: 'WORKER' 			,text: '작업자'				,type: 'string', allowBlank: false},
		    {name: 'CHECK_DESC'			,text: '점검내용'				,type: 'string'},
		    
		    {name: 'INSERT_DB_USER'		, text: '입력자'				,type: 'string', defaultValue: UserInfo.userID, editable: false},
			{name: 'INSERT_DB_TIME'		, text: 'INSERT_DB_TIME'	,type: 'string'}

		    //{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.base.updateuser" default="수정자"/>'			,type: 'string'},
		    //{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.base.updatedate" default="수정일"/>'			,type: 'uniDate'} 
		]
	}); //End of Unilite.defineModel('bcm200ukrvModel', {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmr830ukrvService.selectDetailList',
			update: 'pmr830ukrvService.updateDetail',
			create: 'pmr830ukrvService.insertDetail',
			destroy: 'pmr830ukrvService.deleteDetail',
			syncAll: 'pmr830ukrvService.saveAll'
		}
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('pmr830ukrvMasterStore',{
		model: 'pmr830ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
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
						UniAppManager.app.onQueryButtonDown();
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
					child		: 'WH_CODE',
					holdable	: 'hold',
					allowBlank	: false,
					value		: UserInfo.divCode,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {							
							panelResult.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
				},
				{
					fieldLabel		: '생산일',
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
				{
					fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
					name		: 'WORK_SHOP_CODE',
					xtype		: 'uniCombobox',
					multiSelect	: true,
					//comboType	: 'W',
					comboType	: 'AU', 
					comboCode	: 'B079',					
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WORK_SHOP_CODE', newValue);
						}
/*						,
						beforequery:function( queryPlan, eOpts ) {
							var store = queryPlan.combo.store;
							var prStore = panelResult.getField('WORK_SHOP_CODE').store;
							store.clearFilter();
							prStore.clearFilter();
							if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
								store.filterBy(function(record){
									return record.get('option') == panelSearch.getValue('DIV_CODE');
								});
								prStore.filterBy(function(record){
									return record.get('option') == panelSearch.getValue('DIV_CODE');
								});
							}else{
								store.filterBy(function(record){
									return false;
								});
								prStore.filterBy(function(record){
									return false;
								});
							}
						}*/
					}
				}
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
							panelResult.setValue('WORK_SHOP_CODE','');
						}
					}
				},
				{
					fieldLabel		: '생산일',
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
				{
					fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
					name		: 'WORK_SHOP_CODE',
					xtype		: 'uniCombobox',
					multiSelect	: true,
					//comboType	: 'W',
					comboType	: 'AU', 
					comboCode	: 'B079',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('WORK_SHOP_CODE', newValue);
						}
/*						,
						beforequery:function( queryPlan, eOpts ) {
							var store = queryPlan.combo.store;
							var psStore = panelSearch.getField('WORK_SHOP_CODE').store;
							store.clearFilter();
							psStore.clearFilter();
							if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
								store.filterBy(function(record){
									return record.get('option') == panelResult.getValue('DIV_CODE');
								});
								psStore.filterBy(function(record){
									return record.get('option') == panelResult.getValue('DIV_CODE');
								});
							}else{
								store.filterBy(function(record){
									return false;
								});
								psStore.filterBy(function(record){
									return false;
								});
							}
						}*/
					}
				}
			]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('pmr830ukrvGrid', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
		
        columns: [        			 
			{ dataIndex: 'COMP_CODE'		, width: 100, align: 'center', hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 130,
			listeners:{
					render:function(elm){ 
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
					 		var store		= queryPlan.combo.store;
							var selRecord	=  masterGrid.uniOpt.currentRecord;
							store.clearFilter();
							if(!Ext.isEmpty(selRecord.get('DIV_CODE'))){
								store.filterBy(function(record){
									return record.get('option') == selRecord.get('DIV_CODE');
								});
							} else {
								store.filterBy(function(record){
									return false;
								});
							}
						})
					}
				}
			},
			{ dataIndex: 'CHECK_DATE'		, width: 100, align: 'center'},
			{ dataIndex: 'FR_TIME'			, width: 110, align: 'center'
				,editor: {
							xtype: 'timefield',
							format: 'H:i',
						//	submitFormat: 'Hi', //i tried with and without this config
							increment: 10
					 }
			},
			{ dataIndex: 'TO_TIME'			, width: 110, align: 'center'
				,editor: {
							xtype: 'timefield',
							format: 'H:i',
						//	submitFormat: 'Hi', //i tried with and without this config
							increment: 10
					 }
			},
			{ dataIndex: 'WORKER'			, width: 100},
			{ dataIndex: 'CHECK_DESC'		, width: 190},
		
			{ dataIndex: 'INSERT_DB_USER'	, width: 100},
			{ dataIndex: 'INSERT_DB_TIME'	, width: 80		, align: 'center', 	hidden: true}
			
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				//if(e.field == 'WORK_SHOP_CODE', 'CHECK_DATE', 'CHECK_DATE', 'FR_TIME','TO_TIME'){
				if(e.record.phantom){
		  			return true;
					
				} else {
	      			if (UniUtils.indexOf(e.field, ['WORK_SHOP_CODE', 'CHECK_DATE', 'CHECK_DATE', 'FR_TIME', 'TO_TIME'])){
						return false;
					}
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
		id: 'pmr830ukrvApp',
		fnInitBinding : function() {			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);			
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE', UniDate.get('today'));
			panelSearch.setValue('WORK_SHOP_CODE','');	

			panelResult.setValue('DIV_CODE',UserInfo.divCode);			
			panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
			panelResult.setValue('WORK_SHOP_CODE','');
			
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			panelResult.getField('DIV_CODE').setReadOnly(false);
			
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('newData',true);
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
		},
		onNewDataButtonDown : function(additemCode)	{
			panelResult.getField('DIV_CODE').setReadOnly(true);
			panelSearch.getField('DIV_CODE').setReadOnly(true);

    	 	var r = {

        	 	COMP_CODE   : UserInfo.compCode,
				CHECK_DATE	: UniDate.get('today'),
				DIV_CODE	: panelSearch.getValue('DIV_CODE')

	        };	        
			masterGrid.createRow(r);

		}
	}); //End of Unilite.Main( {
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			
				case "FR_TIME" :
					if(!Ext.isEmpty(UniDate.getHHMI(record.get('TO_TIME')))){
						if(newValue > record.get('TO_TIME')){

							rv='작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.';
							break;
						}

					}
					break;

				case "TO_TIME" :

					if(!Ext.isEmpty(UniDate.getHHMI(record.get('FR_TIME')))){
						if(record.get('FR_TIME') > newValue){

							rv='작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.';
							break;
						}

					}
					break;


			}
			return rv;
		}
	}); // validator
	
};

</script>
