<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx480ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A209" /> <!-- 제출구분 -->
	</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

function appMain() {
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx480ukrService.selectList',
			update: 'atx480ukrService.updateDetail',
			create: 'atx480ukrService.insertDetail',
			destroy: 'atx480ukrService.deleteDetail',
			syncAll: 'atx480ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Atx480ukrModel', {
	    fields: [
			{name: 'COMP_CODE'	   			 ,text: 'COMP_CODE' 		,type: 'string'},
			{name: 'FR_PUB_DATE'			 ,text: 'FR_PUB_DATE' 		,type: 'uniDate'},
    		{name: 'TO_PUB_DATE'			 ,text: 'TO_PUB_DATE' 		,type: 'uniDate'},
    		
    		{name: 'BILL_DIV_CODE' 			 ,text: '신고사업장' 			,type: 'string'},
    		{name: 'AC_YYYYMM'				 ,text: '월별' 				,type: 'string'},
    		{name: 'ITEM_NAME'	   			 ,text: '품명' 				,type: 'string'},
    		{name: 'GUBUN'	   			 	 ,text: '제출구분' 			,type: 'string',comboType:'AU', comboCode:'A209'},
    		{name: 'SALE_Q'	       			 ,text: '수량' 				,type: 'uniQty'},
    		{name: 'SALE_AMT'      			 ,text: '판매가액' 			,type: 'uniPrice'},
    		{name: 'REMARK'		   			 ,text: '비고' 				,type: 'string'},
    		{name: 'INSERT_DB_USER'			 ,text: '입력자' 				,type: 'string'},
    		{name: 'INSERT_DB_TIME'			 ,text: '입력시간' 			,type: 'uniDate'},
    		{name: 'UPDATE_DB_USER'			 ,text: '수정자' 				,type: 'string'},
    		{name: 'UPDATE_DB_TIME'			 ,text: '수정시간' 			,type: 'uniDate'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('atx480ukrMasterStore1',{
		model: 'Atx480ukrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();	
			param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
	   		var toUpdate = this.getUpdatedRecords();        		
	   		var toDelete = this.getRemovedRecords();
	   		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= panelSearch.getValues();
			paramMaster.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			paramMaster.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
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
           		var viewNormal = masterGrid.getView();
           		if(store.getCount() > 0){
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				}else{
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
				}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		if(record.get('GUBUN') == '01'){
					record.set('SALE_Q',0);	
				}
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    
    
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
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
		    items : [{ 
    			fieldLabel: '계산서일',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'FR_PUB_DATE',
		        endFieldName: 'TO_PUB_DATE',
		        width: 470,
		        startDD:'first',
		        endDD:'last',
		        holdable: 'hold',
		        allowBlank: false,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
		        	if(panelResult) {
						panelResult.setValue('FR_PUB_DATE',newValue);
		        	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_PUB_DATE',newValue);
			    	}
			    }
	        },{
				fieldLabel: '신고사업장', 
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode	: 'BILL',
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '작성일자',
				name: 'WRITE_DATE', 
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				width: 200,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('WRITE_DATE', newValue);
					}
				}
			},{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		margin: '0 0 0 120', 
//	    		id:'WRITE_DATE0',
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					UniAppManager.app.onPrintButtonDown();
				}
	    	}]		
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});   
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '계산서일',
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'FR_PUB_DATE',
	        endFieldName: 'TO_PUB_DATE',
	        width: 470,
	        startDD:'first',
	        endDD:'last',
	        holdable: 'hold',
	        allowBlank: false,
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	        	if(panelSearch) {
					panelSearch.setValue('FR_PUB_DATE',newValue);
	        	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_PUB_DATE',newValue);
		    	}
		    }
        },{
			fieldLabel: '신고사업장', 
			name: 'BILL_DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode	: 'BILL',
			colspan:2,
			holdable: 'hold',
			allowBlank: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				}
			}
		},{
    		xtype: 'button',
    		text: '출력',
    		width: 100,
    		margin: '0 0 0 110',
//    		id:'WRITE_DATE0',
    		handler : function() {
				var me = this;
				panelSearch.getEl().mask('로딩중...','loading-indicator');
				UniAppManager.app.onPrintButtonDown();
			}
    	},{
			fieldLabel: '작성일자',
			name: 'WRITE_DATE', 
			xtype: 'uniDatefield',
			value: UniDate.get('today'),
			width: 200,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					panelSearch.setValue('WRITE_DATE', newValue);
				}
			}
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
    }); 
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('atx480ukrGrid1', {
        layout : 'fit',
        region:'center',
    	store: directMasterStore,
    	excelTitle: '월별판매액합계표',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: true,
			copiedRow:true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns:  [        
			{ dataIndex: 'COMP_CODE'	   		, 				width: 66, hidden: true},        
			{ dataIndex: 'FR_PUB_DATE'			, 				width: 66, hidden: true},        
			{ dataIndex: 'TO_PUB_DATE'			, 				width: 66, hidden: true},
			
			{ dataIndex: 'BILL_DIV_CODE' 		, 				width: 66, hidden: true},        
			{ dataIndex: 'AC_YYYYMM'			, 				width: 120},        
			{ dataIndex: 'ITEM_NAME'	   		, 				width: 200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			   		return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{ dataIndex: 'GUBUN'	   			, 				width: 200},
			{ dataIndex: 'SALE_Q'	    		, 				width: 133,summaryType: 'sum'},        
			{ dataIndex: 'SALE_AMT'      		, 				width: 133,summaryType: 'sum'},        
			{ dataIndex: 'REMARK'				, 				width: 240},        
			{ dataIndex: 'INSERT_DB_USER'		, 				width: 66, hidden: true},        
			{ dataIndex: 'INSERT_DB_TIME'		, 				width: 66, hidden: true},        
			{ dataIndex: 'UPDATE_DB_USER'		, 				width: 66, hidden: true},        
			{ dataIndex: 'UPDATE_DB_TIME'		, 				width: 66, hidden: true}
        ],
        listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['AC_YYYYMM','ITEM_NAME','GUBUN','SALE_Q','SALE_AMT','REMARK'])){
					return true;
				}else{
					return false;
				}
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
		id  : 'atx480ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['newData','reset'],false);
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			this.setDefault();
		},
		onQueryButtonDown : function()	{			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore.loadStoreRecords();
				UniAppManager.setToolbarButtons(['newData','reset'],true);
				return panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
			var compCode = UserInfo.compCode;
			var frPubDate = panelSearch.getField('FR_PUB_DATE').getStartDate();
			var toPubDate = panelSearch.getField('TO_PUB_DATE').getEndDate();
			var billDivCode = panelSearch.getValue('BILL_DIV_CODE');
			

        	 var r = {
        	 	COMP_CODE : compCode,
        	 	FR_PUB_DATE : frPubDate,
        	 	TO_PUB_DATE : toPubDate,
        	 	BILL_DIV_CODE : billDivCode
        	 	
        	 	
	        };
			masterGrid.createRow(r,'AC_YYYYMM');
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {	
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {				
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
//				if(selRow.get('ACCOUNT_Q') != 0)
//				{
//					alert('<t:message code="unilite.msg.sMM008"/>');
//				}else{
					masterGrid.deleteSelectedRow();
//				}
			}
		},
		onPrintButtonDown: function() {
			//测试打印报表
			var map = panelSearch.getValues();
			map['FR_PUB_DATE'] = panelSearch.getField('FR_PUB_DATE').getStartDate();
			map['TO_PUB_DATE'] =panelSearch.getField('TO_PUB_DATE').getEndDate();
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/atx/atx480ukr.do',
				prgID: 'atx480ukr',
				extParam: map
				});
			win.center();
			win.show();
		},
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						
						var deletable = true;
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;	
							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
        	panelSearch.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
        	panelSearch.setValue('TO_PUB_DATE',UniDate.get('endOfMonth'));
        	panelSearch.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
        	panelSearch.setValue('WRITE_DATE',UniDate.get('today'));
        	panelResult.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
        	panelResult.setValue('TO_PUB_DATE',UniDate.get('endOfMonth'));
        	panelResult.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
        	panelResult.setValue('WRITE_DATE',UniDate.get('today'));
        	
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
	Unilite.createValidator('validator01', {
			store: directMasterStore,
			grid: masterGrid,
			validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
				var rv = true;
				switch(fieldName) {
					case "GUBUN" : 
						if(newValue == '01'){
							record.set('SALE_Q',0);	
						}
						break;
					case "SALE_Q" :
						if(record.get('GUBUN') == '01'){
							record.set('SALE_Q',0);	
							break;
						}
						break;
				}
					return rv;
			}
		});	
};


</script>
