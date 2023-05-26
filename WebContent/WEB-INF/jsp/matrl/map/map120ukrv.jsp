<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map120ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map120ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->	
	<t:ExtComboStore comboType="AU" comboCode="A022" opts= '${gsList1}' /> <!-- 계산서유형 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.x-change-cell3 {
background-color: #fcfac5;
}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {	
	gsList1: '${gsList1}'
};

function appMain() {
	
var checkCount = 0;	

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'map120ukrvService.selectList',
			update: 'map120ukrvService.updateDetail',
//			create: 'map120ukrvService.insertDetail',
//			destroy: 'map120ukrvService.deleteDetail',
			syncAll: 'map120ukrvService.saveAll'
		}
	});	

	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Map120ukrvModel', {
		fields: [
//			{name: 'CHECK'				, text: '체크'		, type: 'string'},
//	    	{name: 'SELECT'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'		, type: 'boolean'},
//	    	{name: 'CHECK_NAME'			, text: '확정여부'		, type: 'string'},
//	    	{name: 'CHECK_NAME_DUMMY'	, text: '확정여부DUM'		, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'		, type: 'string'},
			{name: 'BILL_NUM'				, text: '<t:message code="system.label.purchase.billno" default="계산서번호"/>'	, type: 'string'},
			{name: 'BILL_DATE'				, text: '<t:message code="system.label.purchase.billdate" default="계산서일"/>'		, type: 'uniDate'},
			{name: 'BILL_ISSUE_DATE'		, text: '발행일'		, type: 'uniDate'},
			{name: 'BILL_ISSUE_DATE_DUMMY'	, text: '발행일DUM'	, type: 'uniDate'},
			{name: 'BILL_TYPE'				, text: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>'	, type: 'string'},
			{name: 'BEFORE_AMOUNT_I'		, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I'				, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'		, type: 'uniPrice'},
			{name: 'VAT_AMOUNT_O'			, text: 'VAT'		, type: 'uniPrice'},
			{name: 'TOTAL'					, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniPrice'},
			{name: 'CHANGE_BASIS_DATE'		, text: '지출결의일'	, type: 'uniDate'},
			{name: 'EX_DATE'				, text: '<t:message code="system.label.purchase.exdate" default="결의일"/>'		, type: 'uniDate'},
			{name: 'EX_NUM'					, text: '번호'		, type: 'string'}
		]
	});//End of Unilite.defineModel('Map120ukrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('map120ukrvMasterStore1', {
		model: 'Map120ukrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
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
							directMasterStore1.loadStoreRecords();
							
						}
							
					};
					this.syncAllDirect(config);
				
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
		//,groupField: 'CUSTOM_NAME'
	});//End of var directMasterStore1 = Unilite.createStore('map120ukrvMasterStore1', {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '매입사업장', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120',
				value: UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'BILL_FR_DATE',
				endFieldName: 'BILL_TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('BILL_FR_DATE',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('BILL_TO_DATE',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
			}, 
				Unilite.popup('CUST', { 
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName: 'CUST_CODE', 
					textFieldName: 'CUST_NAME', 
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUST_CODE', panelSearch.getValue('CUST_CODE'));
								panelResult.setValue('CUST_NAME', panelSearch.getValue('CUST_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUST_CODE', '');
							panelResult.setValue('CUST_NAME', '');
						}
					}
				}),{
					fieldLabel: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>', 
					name: 'BILL_TYPE', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'A022',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BILL_TYPE', newValue);
//							UniAppManager.app.onQueryButtonDown();
							
						}
					}
				},{
				fieldLabel: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'EX_FR_DATE',
				endFieldName: 'EX_TO_DATE',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('EX_FR_DATE',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('EX_TO_DATE',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			},{
					fieldLabel: '고객분류', 
					name: 'AGENT_TYPE', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'B055',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AGENT_TYPE', newValue);
						}
					}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '자동기표여부',						            		
				itemId: 'rdo',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>', 
					width: 60, 
					name: 'rdoSelect', 
					inputValue: 'A', 
					checked: true
				},{
					boxLabel: '기표', 
					width: 60, 
					name: 'rdoSelect', 
					inputValue: 'Y'
				},{
					boxLabel: '미기표', 
					width: 60, 
					name: 'rdoSelect', 
					inputValue: 'N'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '매입사업장', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120',
				value: UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
						}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'BILL_FR_DATE',
				endFieldName: 'BILL_TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('BILL_FR_DATE',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
					
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('BILL_TO_DATE',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			}, 
				Unilite.popup('CUST', { 
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
					valueFieldName: 'CUST_CODE', 
					textFieldName: 'CUST_NAME', 
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUST_CODE', panelResult.getValue('CUST_CODE'));
								panelSearch.setValue('CUST_NAME', panelResult.getValue('CUST_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('CUST_CODE', '');
							panelSearch.setValue('CUST_NAME', '');
						}
					}
				}),{
					fieldLabel: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>', 
					name: 'BILL_TYPE', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'A022',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('BILL_TYPE', newValue);
//							UniAppManager.app.onQueryButtonDown();
							
						}
					}
				},{
				fieldLabel: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'EX_FR_DATE',
				endFieldName: 'EX_TO_DATE',
				width: 315,
				 onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('EX_FR_DATE',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('EX_TO_DATE',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			},{
					fieldLabel: '고객분류', 
					name: 'AGENT_TYPE', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'B055',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('AGENT_TYPE', newValue);
						}
					}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '자동기표여부',						            		
				itemId: 'rdo2',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>', 
					width: 60, 
					name: 'rdoSelect', 
					inputValue: 'A', 
					checked: true
				},{
					boxLabel: '기표', 
					width: 60, 
					name: 'rdoSelect', 
					inputValue: 'Y'
				},{
					boxLabel: '미기표', 
					width: 60, 
					name: 'rdoSelect', 
					inputValue: 'N'
				}],
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
					UniAppManager.setToolbarButtons('save',false);
					panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
				}
			}
		}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('map120ukrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region:'center',
		excelTitle: '외상매입집계현황 조회',
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
        tbar: [{
			xtype: 'button',
			text: '전체선택',
			handler: function() {	
				var records = directMasterStore1.data.items;  
					Ext.each(records,  function(record, index, records){
						record.set('BILL_ISSUE_DATE', record.get('BILL_DATE'));
					/*	if(record.get('CHECK_NAME') == '<t:message code="system.label.purchase.confirmation" default="확정"/>'){
							record.set('SELECT', true);
							
							record.set('CHECK', '2'); //확정
							record.set('CHECK_NAME', '취소');
							
							record.set('BILL_ISSUE_DATE', '');
							checkCount++;
						}else if(record.get('CHECK_NAME') == '<t:message code="system.label.purchase.noconfirm" default="미확정"/>'){
							record.set('SELECT', true);
							
							record.set('CHECK', '1'); //확정
							record.set('CHECK_NAME', '<t:message code="system.label.purchase.confirmation" default="확정"/>');
							
							record.set('BILL_ISSUE_DATE', record.get('BILL_DATE'));
							checkCount++;	
						}*/
					});
					
					/*if(checkCount > 0){
		    			UniAppManager.setToolbarButtons('save',true);
		    		}else if(checkCount < 1){
		    			UniAppManager.setToolbarButtons('save',false);
		    		}*/
			}
		},{
			xtype: 'button',
			text: '전체취소',
			handler: function() {	
				var records = directMasterStore1.data.items;  
					Ext.each(records,  function(record, index, records){
						record.set('BILL_ISSUE_DATE', record.get('BILL_ISSUE_DATE_DUMMY'));
						
						
					/*	record.set('SELECT', false);
						
					if(record.get('CHECK') == '1' ){
						record.set('CHECK','');
						record.set('CHECK_NAME',record.get('CHECK_NAME_DUMMY'));
						record.set('BILL_ISSUE_DATE', '');
					}else if(record.get('CHECK') == '2' ){
						record.set('CHECK','');
						record.set('CHECK_NAME',record.get('CHECK_NAME_DUMMY'));
						record.set('BILL_ISSUE_DATE', record.get('BILL_ISSUE_DATE_DUMMY'));
					}
						checkCount--;
						*/
					});
					
					/*if(checkCount > 0){
		    			UniAppManager.setToolbarButtons('save',true);
		    		}else if(checkCount < 1){
		    			UniAppManager.setToolbarButtons('save',false);
		    		}*/
				}
		}],
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		store: directMasterStore1,
		columns: [
//			{dataIndex: 'CHECK'					, width: 70,hidden:true},
//		    {dataIndex: 'SELECT'  				, width: 88, xtype: 'checkcolumn',align:'center'
		   /* listeners: {    
		    	checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
		    		
		    		var grdRecord = masterGrid.getStore().getAt(rowIndex);
		    	
		    		if(checked == true){
		    			if(grdRecord.get('CHECK_NAME') == '<t:message code="system.label.purchase.noconfirm" default="미확정"/>'){
		    			grdRecord.set('CHECK','1');
		    			grdRecord.set('CHECK_NAME', '<t:message code="system.label.purchase.confirmation" default="확정"/>');
		    			grdRecord.set('BILL_ISSUE_DATE',grdRecord.get('BILL_DATE'));
		    			}else if(grdRecord.get('CHECK_NAME') == '<t:message code="system.label.purchase.confirmation" default="확정"/>'){
		    				grdRecord.set('CHECK','2');
		    			grdRecord.set('CHECK_NAME', '취소');
		    			grdRecord.set('BILL_ISSUE_DATE','BILL_ISSUE_DATE_DUMMY');
		    			}
		    				checkCount++;
		    		if(checkCount > 0){
		    			UniAppManager.setToolbarButtons('save',true);
		    		}else if(checkCount < 1){
		    			UniAppManager.setToolbarButtons('save',false);
		    		}
		    		}else{
		    			if(grdRecord.get('CHECK') == '1' ){
							grdRecord.set('CHECK','');
							grdRecord.set('CHECK_NAME',grdRecord.get('CHECK_NAME_DUMMY'));
							grdRecord.set('BILL_ISSUE_DATE', 'BILL_ISSUE_DATE_DUMMY');
						}else if(grdRecord.get('CHECK') == '2' ){
							grdRecord.set('CHECK','');
							grdRecord.set('CHECK_NAME',grdRecord.get('CHECK_NAME_DUMMY'));
							grdRecord.set('BILL_ISSUE_DATE', 'BILL_ISSUE_DATE_DUMMY');

						
		    		}
		    			checkCount--;
		    		if(checkCount > 0){
		    			UniAppManager.setToolbarButtons('save',true);
		    		}else if(checkCount < 1){
		    			UniAppManager.setToolbarButtons('save',false);
		    		}
		    	}
        	}
		    }*/
//		    },
//		    {dataIndex: 'CHECK_NAME'			, width: 70,align:'center'},
//			{dataIndex: 'CHECK_NAME_DUMMY'		, width: 70,align:'center'},
		
			{dataIndex: 'CUSTOM_CODE'			, width: 88, hidden: true}, 				
			{dataIndex: 'CUSTOM_NAME'			, width: 250,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.customtotal" default="거래처계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
			{dataIndex: 'BILL_NUM'				, width: 150},
			{dataIndex: 'BILL_DATE'				, width: 86},
			{dataIndex: 'BILL_ISSUE_DATE'		, width: 86},
			{dataIndex: 'BILL_ISSUE_DATE_DUMMY'	, width: 86,hidden:true},
			{dataIndex: 'BILL_TYPE'				, width: 106,align:'center'},
			{dataIndex: 'BEFORE_AMOUNT_I'		, width: 120,summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I'				, width: 120,tdCls:'x-change-cell3',summaryType: 'sum'},
			{dataIndex: 'VAT_AMOUNT_O'			, width: 80,summaryType: 'sum'},
			{dataIndex: 'TOTAL'					, width: 120,summaryType: 'sum'},
			{dataIndex: 'CHANGE_BASIS_DATE'		, width: 86, hidden: true},
			{dataIndex: 'EX_DATE'				, width: 86},
			{dataIndex: 'EX_NUM'				, width: 40}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
					if (UniUtils.indexOf(e.field, ['BILL_ISSUE_DATE','AMOUNT_I'/*,'VAT_AMOUNT_O'*/]))	{	
						return true;
					}else{
						return false;
					}					
				}
			}
		
	});//End of var masterGrid = Unilite.createGrid('map120ukrvGrid1', {   

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
		id: 'map120ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('BILL_FR_DATE',UniDate.get('today'));
			panelSearch.setValue('BILL_TO_DATE',UniDate.get('today'));
			panelResult.setValue('BILL_FR_DATE',UniDate.get('today'));
			panelResult.setValue('BILL_TO_DATE',UniDate.get('today'));
			panelSearch.setValue('rdoSelect','A');
			panelResult.setValue('rdoSelect','A');
//			panelSearch.setValue('GUBUN','1');
//			panelResult.setValue('GUBUN','1');
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('reset', true);
		},
		onQueryButtonDown: function(){			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
/*			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/
			UniAppManager.setToolbarButtons('excel',true);
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		}
	});//End of Unilite.Main( {
	
	Unilite.createValidator('validator03', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				/*case "BILL_ISSUE_DATE" : 
					if(record.get('CHECK_NAME') == '<t:message code="system.label.purchase.confirmation" default="확정"/>'){
						record.set('SELECT', true);
						
						record.set('CHECK', '1'); //확정
						record.set('CHECK_NAME', '수정');
						
						
						checkCount++;
					}else if(record.get('CHECK_NAME') == '<t:message code="system.label.purchase.noconfirm" default="미확정"/>'){
						record.set('SELECT', true);
						
						record.set('CHECK', '1'); //확정
						record.set('CHECK_NAME', '<t:message code="system.label.purchase.confirmation" default="확정"/>');
						
						
						checkCount++;	
					}
					
					if(checkCount > 0){
						UniAppManager.setToolbarButtons('save',true);
					}else if(checkCount < 1){
						UniAppManager.setToolbarButtons('save',false);
		    		}
		    		break;*/
				case "AMOUNT_I" :
					if( newValue > record.get('TOTAL')){
						rv='<t:message code = "입력된 공급가액이 합계금액보다 큽니다."/>'
						break;
					}else{
						record.set('VAT_AMOUNT_O',record.get('TOTAL') - newValue);
					}
					break;
				case "VAT_AMOUNT_O" :
					record.set('AMOUNT_I',record.get('TOTAL') - newValue);
					break;			
			}
				return rv;
			}
	});	
};


</script>
