<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afc100ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >
var getStDt = ${getStDt};

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afc100ukrService.selectList',
			update: 'afc100ukrService.updateDetail',
//			create: 'afc100ukrService.insertDetail',
//			destroy: 'afc100ukrService.deleteDetail',
			syncAll: 'afc100ukrService.saveAll'
		}
	});	
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Afc100ukrModel', {
	    fields: [
    		{name: 'ACCNT'				 	,text: '계정코드' 				,type: 'string'},
    		{name: 'ACCNT_NAME'			 	,text: '계정과목명' 				,type: 'string'},
    		{name: 'PROFIT_DIVI'	 		,text: 'PROFIT_DIVI' 		,type: 'string'},
    		{name: 'AMT_I1'				 	,text: 'AMT_I1' 			,type: 'uniPrice'},
    		{name: 'AMT_I2'				 	,text: 'AMT_I2' 			,type: 'uniPrice'},
    		{name: 'AMT_I3'				 	,text: 'AMT_I3' 			,type: 'uniPrice'},
    		{name: 'AMT_I4'				 	,text: 'AMT_I4' 			,type: 'uniPrice'},
    		{name: 'JAN_DIVI'			 	,text: 'JAN_DIVI' 			,type: 'string'},
    		{name: 'GUBUN'				 	,text: 'GUBUN' 				,type: 'string'},
    		{name: 'EDIT_YN'				,text: 'EDIT_YN' 			,type: 'string'},
    		{name: 'UPDATE_DB_USER'	 		,text: 'UPDATE_DB_USER' 	,type: 'string'},
    		{name: 'UPDATE_DB_TIME'	 		,text: 'UPDATE_DB_TIME' 	,type: 'uniDate'},
    		{name: 'COMP_CODE'	  	 		,text: 'COMP_CODE' 			,type: 'string'},
    		{name: 'AC_DATE'				,text: 'AC_DATE' 			,type: 'string'}
	    ]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('afc100ukrMasterStore',{
		model: 'Afc100ukrModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();	
			
			var choiceYear = UniDate.getDbDateStr(panelSearch.getValue('START_MONTH')).substring(0,4);
			var choiceMonth = UniDate.getDbDateStr(panelSearch.getValue('START_MONTH')).substring(4,6);
			
			param.START_MONTH_1 = choiceYear-4 + choiceMonth,
			param.START_MONTH_2 = choiceYear-3 + choiceMonth,
			param.START_MONTH_3 = choiceYear-2 + choiceMonth,
			param.START_MONTH_4 = choiceYear-1 + choiceMonth,
			
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
			var rv = true;
			
			if(inValidRecs.length == 0 ) {
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
				if (!Ext.isEmpty(panelSearch.getValue('START_MONTH'))) {
					var choiceYear = UniDate.getDbDateStr(panelSearch.getValue('START_MONTH')).substring(0, 4);
					var choiceMonth = UniDate.getDbDateStr(panelSearch.getValue('START_MONTH')).substring(4, 6);
					masterGrid.down('#AMT_I1_CHANGE').setText(choiceYear-4 + '년' + choiceMonth + '월');
					masterGrid.down('#AMT_I2_CHANGE').setText(choiceYear-3 + '년' + choiceMonth + '월');
					masterGrid.down('#AMT_I3_CHANGE').setText(choiceYear-2 + '년' + choiceMonth + '월');
					masterGrid.down('#AMT_I4_CHANGE').setText(choiceYear-1 + '년' + choiceMonth + '월');
				}
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
    			fieldLabel: '당기시작년월',
				xtype: 'uniMonthfield',
				name:'START_MONTH',
//				value: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
				width: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('START_MONTH', newValue);
					},
					blur: function(field, event, eOpts ) {
						var newValue = panelSearch.getValue('START_MONTH');
						if (Ext.isDate(newValue)) {
							var choiceYear = UniDate.getDbDateStr(newValue).substring(0, 4);
							var choiceMonth = UniDate.getDbDateStr(newValue).substring(4, 6);
							
							if (choiceYear + choiceMonth > getStDt[0].STDT.substring(0, 6)) {
								Unilite.messageBox(getStDt[0].STDT.substring(0, 4) + "년 " + getStDt[0].STDT.substring(4, 6) + "월을 초과할 수 없습니다.");
								panelSearch.setValue('START_MONTH', field.originalValue);
								panelResult.setValue('START_MONTH', field.originalValue);
								return false;
							}
						}
					}
				}
			},{					
    			fieldLabel: '사업장',
    			name:'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType:'BOR120',
    			allowBlank:false,
    			holdable: 'hold',
    			listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
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
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
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
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '당기시작년월',
			xtype: 'uniMonthfield',
			name:'START_MONTH',
//			value: UniDate.get('today'),
			allowBlank: false,
			holdable: 'hold',
			width: 200,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('START_MONTH', newValue);
				},
				blur: function(field, event, eOpts ) {
					var newValue = panelResult.getValue('START_MONTH');
					if (Ext.isDate(newValue)) {
						var choiceYear = UniDate.getDbDateStr(newValue).substring(0, 4);
						var choiceMonth = UniDate.getDbDateStr(newValue).substring(4, 6);
						
						if (choiceYear + choiceMonth > getStDt[0].STDT.substring(0, 6)) {
							Unilite.messageBox(getStDt[0].STDT.substring(0, 4) + "년 " + getStDt[0].STDT.substring(4, 6) + "월을 초과할 수 없습니다.");
							panelSearch.setValue('START_MONTH', field.originalValue);
							panelResult.setValue('START_MONTH', field.originalValue);
							return false;
						}
					}
				}
			}
		},{					
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
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
    
	var masterGrid = Unilite.createGrid('afc100ukrGrid', {
		layout : 'fit',
		region: 'center',
		excelTitle: '전년도실적입력',
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: true,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		store: directMasterStore,
		features: [ 
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false, enableGroupingMenu:false },
			{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  	 showSummaryRow: false}
		],
		columns: [
			{ dataIndex: 'ACCNT'							, 	width:100},
			{ dataIndex: 'ACCNT_NAME'						, 	width:293},
			{ dataIndex: 'PROFIT_DIVI'						, 	width:66,  hidden: true},
			{ itemId: 'AMT_I1_CHANGE', dataIndex: 'AMT_I1'	, 	width:150},
			{ itemId: 'AMT_I2_CHANGE', dataIndex: 'AMT_I2'	, 	width:150},
			{ itemId: 'AMT_I3_CHANGE', dataIndex: 'AMT_I3'	, 	width:150},
			{ itemId: 'AMT_I4_CHANGE', dataIndex: 'AMT_I4'	, 	width:150},
			{ dataIndex: 'JAN_DIVI'							, 	width:50,  hidden: true},
			{ dataIndex: 'GUBUN'							, 	width:50,  hidden: true},
			{ dataIndex: 'EDIT_YN'							, 	width:50,  hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'					, 	width:50,  hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'					, 	width:50,  hidden: true},
			{ dataIndex: 'COMP_CODE'						, 	width:50,  hidden: true},
			{ dataIndex: 'AC_DATE'							, 	width:100, hidden: true}
		],
		listeners: {
			beforeedit : function(editor, e, eOpts) {
				var choiceYear = UniDate.getDbDateStr(panelSearch.getValue('START_MONTH')).substring(0, 4);
				var choiceMonth = UniDate.getDbDateStr(panelSearch.getValue('START_MONTH')).substring(4, 6);
				var AMT_I1_CHANGE = choiceYear - 4 + choiceMonth;
				var AMT_I2_CHANGE = choiceYear - 3 + choiceMonth;
				var AMT_I3_CHANGE = choiceYear - 2 + choiceMonth;
				var AMT_I4_CHANGE = choiceYear - 1 + choiceMonth;
				
				if (e.record.data.AC_DATE != '' && e.record.data.AC_DATE != null) {
					if (e.record.data.AC_DATE <= AMT_I1_CHANGE) {
						if (UniUtils.indexOf(e.field,['AMT_I1']))
						return false;
					}
					if (e.record.data.AC_DATE <= AMT_I2_CHANGE) {
						if (UniUtils.indexOf(e.field,['AMT_I2']))
						return false;
					}
					if (e.record.data.AC_DATE <= AMT_I3_CHANGE) {
						if (UniUtils.indexOf(e.field,['AMT_I3']))
						return false;
					}
					if (e.record.data.AC_DATE <= AMT_I4_CHANGE) {
						if (UniUtils.indexOf(e.field,['AMT_I4']))
						return false;
					}
				}
				
				if (e.record.data.EDIT_YN == 'Y'){
					if (UniUtils.indexOf(e.field,
						['AMT_I1','AMT_I2','AMT_I3','AMT_I4']))
						{
						return true;
					} else {
						return false;
					}
				} else {
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
		id: 'afc100ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save', false);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('START_MONTH',getStDt[0].STDT);
			panelResult.setValue('START_MONTH',getStDt[0].STDT);
			
			var choiceYear = UniDate.getDbDateStr(panelSearch.getValue('START_MONTH')).substring(0,4);
			var choiceMonth = UniDate.getDbDateStr(panelSearch.getValue('START_MONTH')).substring(4,6);
			masterGrid.down('#AMT_I1_CHANGE').setText(choiceYear-4 + '년' + choiceMonth + '월');
   			masterGrid.down('#AMT_I2_CHANGE').setText(choiceYear-3 + '년' + choiceMonth + '월');
   			masterGrid.down('#AMT_I3_CHANGE').setText(choiceYear-2 + '년' + choiceMonth + '월');
   			masterGrid.down('#AMT_I4_CHANGE').setText(choiceYear-1 + '년' + choiceMonth + '월');
				
   			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('START_MONTH');
		},
		onQueryButtonDown : function()	{			
			if(!this.checkForForm()) {
				return false;
			}else{
				directMasterStore.loadStoreRecords();	
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
//			if(checkSave == 'N'){
//				var param = {"F_CLOSE_DATE": panelSearch.getValue('F_CLOSE_DATE')};
//				aba160ukrService.checkBeforeInsert(param, function(provider, response)	{
//					if(!Ext.isEmpty(provider)){
//						if(provider['CNT'] > 0 ){
//							if(confirm('이미 데이터가 존재합니다.\n다시 생성하시면 기존데이터가 삭제됩니다.\n그래도 생성하시겠습니까?')) {
//							
//								directMasterStore1.saveStore();
//							}
//						}else{
//							directMasterStore1.saveStore();	
//						}
//					}
//				});
//			}else{
				directMasterStore.saveStore();	
//			}
			
			
		},
		checkForForm:function() { 
			return panelSearch.setAllFieldsReadOnly(true);
//				   panelResult.setAllFieldsReadOnly(true);
        }
	});
};


</script>
