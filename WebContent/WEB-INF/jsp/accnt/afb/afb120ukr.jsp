<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="afb120ukr"  >

	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="A025" /> <!--전용구분-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
var getStDt = ${getStDt};
var gsStMonth = (getStDt[0].STDT).substring(0,6);
var beforeRowIndex = '';
var gsAccnt = '';

var sOldAcntCD = '';
var sOldDeptCD = '';
var sOldDvrtDV = '';
var dOldBudget = 0;

var deleteFlag = '';
//var bDivi;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb120ukrService.selectDetailList',
			update: 'afb120ukrService.updateDetail',
			create: 'afb120ukrService.insertDetail',
			destroy: 'afb120ukrService.deleteDetail',
			syncAll: 'afb120ukrService.saveAll'
		}
	});	
	Unilite.defineModel('Afb120ukrMasterModel', {
	    fields: [
			{name: 'AC_YYYY'					 ,text: '(AC_YYYY)' 	    ,type: 'string'},
			{name: 'DEPT_CODE'					 ,text: '(DEPT_CODE)' 	    ,type: 'string'},
			{name: 'DEPT_NAME'					 ,text: '(DEPT_NAME)' 	    ,type: 'string'},
			{name: 'BUDGET_OLD'					 ,text: '(BUDGET_OLD)' 	    ,type: 'uniPrice'},
			{name: 'ACCNT'					 	 ,text: '코드'				,type: 'string'},
			{name: 'ACCNT_NAME'					 ,text: '계정과목' 	    	,type: 'string'},
			{name: 'BUDGET_I'					 ,text: '전용가능금액' 	    	,type: 'uniPrice'},
			{name: 'EDIT_YN'					 ,text: '(EDIT_YN)' 	    ,type: 'string'}
		]
	});
	function monthFormat(value){
			if(value)	{
				var strTmp = value.replace('.','');
				var arrTmp = new Array();
				arrTmp[0] = strTmp.substring(0,4);
				arrTmp[1] = strTmp.substring(4,strTmp.length);
				if(parseInt(arrTmp[1]) < 0 || parseInt(arrTmp[1]) > 12 )	{
					return '';
				} else if(arrTmp[1].length == 1)	{
					arrTmp[1] ='0'+arrTmp[1];
				} else if(arrTmp[1].length == 3)	{
					arrTmp[1] =arrTmp[1].substring(0,2);
				}
				return Ext.util.Format.format('{0}.{1}', arrTmp[0],arrTmp[1]);
			}
			return value;
		
	}
	Unilite.defineModel('Afb120ukrDetailModel', {
	    fields: [
			{name: 'AC_YYYY'					,text: '(AC_YYYY)' 	    	,type: 'string'},
			{name: 'ACCNT'					 	,text: '(ACCNT)' 	    	,type: 'string'},
			{name: 'ACCNT_NAME'					,text: '(ACCNT_NAME)' 	    ,type: 'string'},
			{name: 'DEPT_CODE'					,text: '(DEPT_CODE)' 	    ,type: 'string'},
			{name: 'DEPT_NAME'					,text: '(DEPT_NAME)' 	    ,type: 'string'},
			{name: 'UPDATE_DB_USER'				,text: '(UPDATE_DB_USER)' 	,type: 'string'},
			{name: 'UPDATE_DB_TIME'				,text: '(UPDATE_DB_TIME)' 	,type: 'string'},
			{name: 'BUDG_YYYYMM'				,text: '예산년월' 	    		,type: 'string',maxLength:7,allowBlank:false
				, convert:monthFormat
			},//그리드 년월필드 필요
			{name: 'DIVERT_DIVI'				,text: '전용구분' 	    		,type: 'string',comboType:'AU', comboCode:'A025',allowBlank:false},
			{name: 'DIVERT_YYYYMM'				,text: '전용년월' 	    		,type: 'string',maxLength:7, convert:monthFormat},//그리드 년월필드 필요
			{name: 'DIVERT_ACCNT'				,text: '전용과목' 	    		,type: 'string'},
			{name: 'DIVERT_ACCNT_NAME'			,text: '계정과목' 	    		,type: 'string'},
			{name: 'DIVERT_DEPT_CODE'			,text: '전용부서' 	   			,type: 'string'},
			{name: 'DIVERT_DEPT_NAME'			,text: '부서명' 	   			,type: 'string'},
			{name: 'DIVERT_BUDG_I'				,text: '전용금액' 	    		,type: 'uniPrice'},
			{name: 'REMARK'					 	,text: '비고' 	    		,type: 'string'},
			{name: 'EDIT_YN'					,text: '(EDIT_YN)' 	    	,type: 'string'},
			{name: 'COMP_CODE'					,text: '(COMP_CODE)' 	    ,type: 'string'}		
		]
	});
	
	var directMasterStore = Unilite.createStore('afb120ukrMasterStore',{
		model: 'Afb120ukrMasterModel',
		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'afb120ukrService.selectMasterList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('resultForm').getValues();	
			
			var tempDate = panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6) + '01';
				tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
			var transDate = new Date(tempDate);
			var sToMonth = '';
				sToMonth = UniDate.add(transDate, {months: + 11});
			
			param.sFrMonth = panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6);
			param.sToMonth = UniDate.getDbDateStr(sToMonth).substring(0,6);
			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directDetailStore = Unilite.createStore('afb120ukrDetailStore',{
		model: 'Afb120ukrDetailModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        saveStore : function()	{	
			var paramMaster= panelResult.getValues();
			var tempDate = panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6) + '01';
				tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
			var transDate = new Date(tempDate);
			var sToMonth = '';
				sToMonth = UniDate.add(transDate, {months: + 11});
			
			paramMaster.sFrMonth = panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6);
			paramMaster.sToMonth = UniDate.getDbDateStr(sToMonth).substring(0,6);
			
			
//			paramMaster.saveMonth = saveMonth;
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
//						directDetailStore.loadStoreRecords();
						
						directMasterStore.commitChanges();
						
					}
				};
				this.syncAllDirect(config);
			}else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('resultForm').getValues();
			
			var tempDate = panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6) + '01';
				tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
			var transDate = new Date(tempDate);
			var sToMonth = '';
				sToMonth = UniDate.add(transDate, {months: + 11});
			
			param.sFrMonth = panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6);
			param.sToMonth = UniDate.getDbDateStr(sToMonth).substring(0,6);
			

			
			param.ACCNT = gsAccnt;
			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		UniAppManager.app.fnRememberData('');

           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		if(record.phantom == true){
           			UniAppManager.app.fnCalculation(true, 'N');
           		}
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           		UniAppManager.app.fnRememberData('');
           		UniAppManager.app.fnCalculation(false, 'Y');
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
			layout : {type : 'vbox', align : 'stretch'},
	    	items : [{
	    		xtype:'container',
	    		layout : {type : 'uniTable', columns : 1},
	    		items:[{ 
	    			fieldLabel: '예산년도',
			        xtype: 'uniYearField',	
			        value: new Date().getFullYear(),
			        name: 'AC_YYYY',
			        allowBlank: false,
			        holdable:'hold',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AC_YYYY', newValue);
						}
					}
		        },
				Unilite.popup('DEPT', { 
					fieldLabel: '부서', 
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					holdable:'hold',
			        allowBlank: false,
			        autoPopup:true,
					listeners: {
				    	onValueFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_CODE', newValue);	
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_NAME', newValue);	
						}
					}
				})]	
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
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '예산년도',
	        xtype: 'uniYearField',	
	        value: new Date().getFullYear(),
	        name: 'AC_YYYY',
	        allowBlank: false,
	        holdable:'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('AC_YYYY', newValue);
					
//					alert('dddd');
				}/*,
				blur: function(field, event, eOpts )	{
					alert('ssss');
        		}*/
			}
        },
        Unilite.popup('DEPT', { 
			fieldLabel: '부서', 
			valueFieldName: 'DEPT_CODE',
			textFieldName: 'DEPT_NAME',
			holdable:'hold',
	        allowBlank: false,
	        autoPopup:true,
			listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);	
				}
			}
		})/*,
		{
			xtype:'button',
			text:'포커스테스트',
			handler : function() {
				 masterGrid.getSelectionModel().select(0, true);
			}
		}*/
		
		],
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
  
    
	var masterGrid = Unilite.createGrid('afb120ukrMasterGrid', { 	
      	flex:1.5,
        layout : 'fit',
        region:'center',
    	store: directMasterStore,
//    	excelTitle: '',
    	selModel:'rowmodel',
    	uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: false,
    		onLoadSelectFirst	: true, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			state: {
				useState: true,			
				useStateList: true		
			}
        },
    	features: [{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
			{ dataIndex: 'AC_YYYY'		,		width: 100,hidden:true},
			{ dataIndex: 'DEPT_CODE'	,		width: 100,hidden:true},
			{ dataIndex: 'DEPT_NAME'	,		width: 100,hidden:true},
			{ dataIndex: 'BUDGET_OLD'	,		width: 100,hidden:true},
			{ dataIndex: 'ACCNT'		,		width: 100},
			{ dataIndex: 'ACCNT_NAME'	,		width: 200},
			{ dataIndex: 'BUDGET_I'		,		flex:1/*width: 180*/},
			{ dataIndex: 'EDIT_YN'		,		width: 100,hidden:true}
        ],
        
        listeners:{
        	/*beforeselect: function(rowSelection, record, index, eOpts) {
    			if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	if (res === 'yes' ) {
						     		
									UniAppManager.app.onSaveDataButtonDown();
						     		
						     	} else if(res === 'no') {
						     		
						     		gsAccnt = selected[0].data.ACCNT;
					         		directDetailStore.loadStoreRecords();
					         		
					         		UniAppManager.setToolbarButtons('newData',true);
						     	}
						     }
						});
						
						
         				Ext.Msg.confirm(
         					Msg.sMB099,
         					Msg.sMB017 + "\n" + Msg.sMB061,
         					function(button){
         						if(button == "yes"){
         							UniAppManager.app.onSaveDataButtonDown();
		         					gsAccnt = selected[0].data.ACCNT;
					         		directDetailStore.loadStoreRecords();
					         		
					         		UniAppManager.setToolbarButtons('newData',true);
         						}else{
         							return false;
//         							UniAppManager.app.onResetButtonDown();         					
//         							UniAppManager.app.onQueryButtonDown();
         						}
         					}
         				)
         				
         				
         				
         				
         				
         				
         				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
         					UniAppManager.app.onSaveDataButtonDown();
         					gsAccnt = selected[0].data.ACCNT;
			         		directDetailStore.loadStoreRecords();
			         		
			         		UniAppManager.setToolbarButtons('newData',true);	
         				}else{
//         					UniAppManager.app.fnCalculation(false, 'Y');
         					UniAppManager.app.onResetButtonDown();         					
         					UniAppManager.app.onQueryButtonDown();
							gsAccnt = selected[0].data.ACCNT;
			         		directDetailStore.loadStoreRecords();
			         		
			         		UniAppManager.setToolbarButtons('newData',true);	
						}
					}
    		},*/
         	selectionchange:function( grid, selected, eOpts ){
         		if(!Ext.isEmpty(selected)){
         			
         			if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
         				Ext.Msg.confirm(
         					Msg.sMB099,
         					Msg.sMB017 + "\n" + Msg.sMB061,
         					function(button){
         						if(button == "yes"){
         							UniAppManager.app.onSaveDataButtonDown();
         							
         							detailGrid.reset();
									directDetailStore.clearData();
		         					gsAccnt = selected[0].data.ACCNT;
					         		directDetailStore.loadStoreRecords();
					         		
					         		UniAppManager.setToolbarButtons('newData',true);
         						}else{
         							UniAppManager.app.onResetButtonDown();         					
         							UniAppManager.app.onQueryButtonDown();
//         							var selectRowIndex = '';
//         							var grdRecord = masterGrid.getStore().getAt(rowIndex);  
////         							
//         							masterGrid.getSelectionModel().select(0, true);
         						}
         					}
         				)
         				
					} else {
						gsAccnt = selected[0].data.ACCNT;
		         		directDetailStore.loadStoreRecords();
		         		
		         		UniAppManager.setToolbarButtons('newData',true);
					}
         			
         			
         			
	         		
         		}
         	},
         	cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//				alert('abc');
         		
         		UniAppManager.setToolbarButtons('delete',false);
			}
        }
    });   
    
    var detailGrid = Unilite.createGrid('afb120ukrDetailGrid', {
    	// for tab    
    	split:true,
    	flex:3,
        layout : 'fit',
        region:'east',
    	store: directDetailStore,
    	uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: false,
    		onLoadSelectFirst	: true, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: true,
			state: {
				useState: true,			
				useStateList: true		
			}
        },
    	features: [{id : 'detailGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'detailGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
			{ dataIndex: 'AC_YYYY'				,		width: 100,hidden:true},
			{ dataIndex: 'ACCNT'				,		width: 100,hidden:true},
			{ dataIndex: 'ACCNT_NAME'			,		width: 100,hidden:true},
			{ dataIndex: 'DEPT_CODE'			,		width: 100,hidden:true},
			{ dataIndex: 'DEPT_NAME'			,		width: 100,hidden:true},
			{ dataIndex: 'UPDATE_DB_USER'		,		width: 100,hidden:true},
			{ dataIndex: 'UPDATE_DB_TIME'		,		width: 100,hidden:true},
			{ dataIndex: 'BUDG_YYYYMM'			,		width: 100},
			{ dataIndex: 'DIVERT_DIVI'			,		width: 100,align:'center'},
			{ dataIndex: 'DIVERT_YYYYMM'		,		width: 100},
			{ dataIndex: 'DIVERT_ACCNT'			,		width: 100,
				editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var detailGridSelectRecord = detailGrid.uniOpt.currentRecord;
							detailGridSelectRecord.set('DIVERT_ACCNT', records[0].ACCNT_CODE);
							detailGridSelectRecord.set('DIVERT_ACCNT_NAME', records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var detailGridSelectRecord = detailGrid.uniOpt.currentRecord;
							detailGridSelectRecord.set('DIVERT_ACCNT', '');
							detailGridSelectRecord.set('DIVERT_ACCNT_NAME', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
//									'CHARGE_CODE':gsChargeCode,
									'ADD_QUERY':"SLIP_SW = 'Y' AND BUDG_YN = 'Y' AND GROUP_YN = 'N'"
								}
								popup.setExtParam(param);
							}
						}
					}
					
				})
			},
			{ dataIndex: 'DIVERT_ACCNT_NAME'	,		width: 150,
				editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var detailGridSelectRecord = detailGrid.uniOpt.currentRecord;
							detailGridSelectRecord.set('DIVERT_ACCNT', records[0].ACCNT_CODE);
							detailGridSelectRecord.set('DIVERT_ACCNT_NAME', records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var detailGridSelectRecord = detailGrid.uniOpt.currentRecord;
							detailGridSelectRecord.set('DIVERT_ACCNT', '');
							detailGridSelectRecord.set('DIVERT_ACCNT_NAME', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
//									'CHARGE_CODE':gsChargeCode,
									'ADD_QUERY':"SLIP_SW = 'Y' AND BUDG_YN = 'Y' AND GROUP_YN = 'N'"
								}
								popup.setExtParam(param);
							}
						}
					}
					
				})
			},
			{ dataIndex: 'DIVERT_DEPT_CODE'		,		width: 100,
				editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					DBtextFieldName: 'TREE_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var detailGridSelectRecord = detailGrid.uniOpt.currentRecord;
							detailGridSelectRecord.set('DIVERT_DEPT_CODE', records[0].TREE_CODE);
							detailGridSelectRecord.set('DIVERT_DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var detailGridSelectRecord = detailGrid.uniOpt.currentRecord;
							detailGridSelectRecord.set('DIVERT_DEPT_CODE', '');
							detailGridSelectRecord.set('DIVERT_DEPT_NAME', '');
						}
					}
				})
			},
			{ dataIndex: 'DIVERT_DEPT_NAME'		,		width: 150,
				editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var detailGridSelectRecord = detailGrid.uniOpt.currentRecord;
							detailGridSelectRecord.set('DIVERT_DEPT_CODE', records[0].TREE_CODE);
							detailGridSelectRecord.set('DIVERT_DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var detailGridSelectRecord = detailGrid.uniOpt.currentRecord;
							detailGridSelectRecord.set('DIVERT_DEPT_CODE', '');
							detailGridSelectRecord.set('DIVERT_DEPT_NAME', '');
						}
					}
				})
			},
			{ dataIndex: 'DIVERT_BUDG_I'		,		width: 150},
			{ dataIndex: 'REMARK'				,		width: 150},
			{ dataIndex: 'EDIT_YN'				,		width: 100,hidden:true},
			{ dataIndex: 'COMP_CODE'			,		width: 100,hidden:true}
        ],
        listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(e.record.data.EDIT_YN == 'N'){
					return false;
				}else{
					if(e.record.phantom == false){
						if(UniUtils.indexOf(e.field, ['REMARK'])){
							return true;
						}else{
							return false;
						}
					}
					
					if(e.record.data.DIVERT_DIVI == '2'){
						if(UniUtils.indexOf(e.field, ['DIVERT_ACCNT', 'DIVERT_ACCNT_NAME', 'DIVERT_DEPT_CODE', 'DIVERT_DEPT_NAME', 'DIVERT_YYYYMM'])){
							return false;
						}else{
							return true;
						}
					}else{
						return true;
					}
				}
			},
			selectionchange:function( grid, selected, eOpts ){
				
				
//				UniAppManager.app.fnRememberData('');
         	}
         	/*cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//				alert('abc');
         		UniAppManager.setToolbarButtons('delete',true);
			}*/
//			select: function(grid, record, index, eOpts ){	
//				UniAppManager.setToolbarButtons('delete',true);
//			}
//			beforeselect: function(rowSelection, record, index, eOpts) {
//    			UniAppManager.setToolbarButtons('delete',true);
//    		}
		} 
    });   
		
	
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, detailGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'afb120ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons(['newData','save'],false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_YYYY');
			this.setDefault();
			
			
		},
		onQueryButtonDown : function()	{			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{		
				directMasterStore.loadStoreRecords();
				panelSearch.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			
			var selectRecord = masterGrid.getSelectedRecord();
			
			if(selectRecord.get('EDIT_YN') == 'N'){
				Ext.Msg.alert(Msg.sMB099,Msg.sMB119);
				return false;
			}
			
			if(!panelResult.getInvalidMessage()) return false;
			
			
			var acYyyy			= selectRecord.get('AC_YYYY');
			var accnt			= selectRecord.get('ACCNT');
			var accntName		= selectRecord.get('ACCNT_NAME');
			var deptCode		= selectRecord.get('DEPT_CODE');
			var deptName		= selectRecord.get('DEPT_NAME');
			var budgYyyymm		= panelResult.getValue('AC_YYYY') + UniDate.getDbDateStr(UniDate.get('today')).substring(4,6);
			var divertYyyymm    = '';
			var divertDivi      = '';
			var divertAccnt     = '';
			var divertAccntName	= '';
			var divertDeptCode  = '';
			var divertDeptName  = '';
			var divertBudgI     = 0;
			var remark          = '';
			var compCode        = UserInfo.compCode;
			
            var r = {
            	AC_YYYY 			: acYyyy,			
				ACCNT 				: accnt,			
				ACCNT_NAME 			: accntName,		
				DEPT_CODE 			: deptCode,		
				DEPT_NAME 			: deptName,		
				BUDG_YYYYMM 		: budgYyyymm,		
				DIVERT_YYYYMM 		: divertYyyymm,   
				DIVERT_DIVI 		: divertDivi,     
				DIVERT_ACCNT 		: divertAccnt,    
				DIVERT_ACCNT_NAME 	: divertAccntName,
				DIVERT_DEPT_CODE 	: divertDeptCode, 
				DIVERT_DEPT_NAME 	: divertDeptName, 
				DIVERT_BUDG_I 		: divertBudgI,    
				REMARK 				: remark,         
            	COMP_CODE 			: compCode
				
	        };

	        detailGrid.createRow(r);
	        UniAppManager.app.fnRememberData('');
//			UniAppManager.setToolbarButtons('delete',true);	
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
//				UniAppManager.app.fnCalculation(false, 'Y');
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
//				UniAppManager.app.fnCalculation(false, 'Y');
				detailGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown: function() {
			
//			panelSearch.clearForm();
//			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			directMasterStore.clearData();
			detailGrid.reset();
			directDetailStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directDetailStore.saveStore();
					
		},
		setDefault: function(){
		
		},
		checkForNewDetail:function() { 			
			return panelResult.setAllFieldsReadOnly(true);
        },
        
        fnRememberData: function(df) {
        	var selectRecord = detailGrid.getSelectedRecord();
        	if(Ext.isEmpty(selectRecord) || df == 'Y'){
        		sOldAcntCD = "";
				sOldDeptCD = "";
				sOldDvrtDV = "";
				dOldBudget = 0; 
        	}else{
        		sOldAcntCD = selectRecord.get('DIVERT_ACCNT');
				sOldDeptCD = selectRecord.get('DIVERT_DEPT_CODE');
				sOldDvrtDV = selectRecord.get('DIVERT_DIVI');
				dOldBudget = selectRecord.get('DIVERT_BUDG_I');
        	}
        },
        
        fnCalculation: function(bDivi, deleteFlag){
        	var masterGridSelectRecord = masterGrid.getSelectedRecord();
        	var detailGridSelectRecord = detailGrid.getSelectedRecord();
        	
        	var sCurAcntCD = detailGridSelectRecord.get('DIVERT_ACCNT');
			var sCurDeptCD = detailGridSelectRecord.get('DIVERT_DEPT_CODE');
			var sCurDvrtDV = detailGridSelectRecord.get('DIVERT_DIVI');	
			var dCurBudget = detailGridSelectRecord.get('DIVERT_BUDG_I');	
			
			if(bDivi == true){
				if(sOldDvrtDV == '1'){ //전용
					if(!Ext.isEmpty(sOldAcntCD) && !Ext.isEmpty(sOldDeptCD) && !Ext.isEmpty(sOldDvrtDV)){
						masterGridSelectRecord.set('BUDGET_I', masterGridSelectRecord.get('BUDGET_I') + dOldBudget);
						
						Ext.each(directMasterStore.data.items, function(masterRecord,i){
							if(sOldDeptCD == panelResult.getValue('DEPT_CODE')){
								if(masterRecord.get('ACCNT') == sOldAcntCD){
									masterRecord.set('BUDGET_I', masterRecord.get('BUDGET_I') - dOldBudget);
								}
							}
						});
					}
				}else if(sOldDvrtDV == '2'){ //추경
					masterGridSelectRecord.set('BUDGET_I', masterGridSelectRecord.get('BUDGET_I') - dOldBudget);
				}
				
				
				if(deleteFlag != 'Y'){
					if(sCurDvrtDV == '1'){
						if(!Ext.isEmpty(sCurAcntCD) && !Ext.isEmpty(sCurDeptCD) && !Ext.isEmpty(sCurDvrtDV)){
							masterGridSelectRecord.set('BUDGET_I', masterGridSelectRecord.get('BUDGET_I') - dCurBudget);
							
							if(sCurDeptCD == panelResult.getValue('DEPT_CODE')){
								Ext.each(directMasterStore.data.items, function(masterRecord,i){
									if(masterRecord.get('ACCNT') == sCurAcntCD){
										masterRecord.set('BUDGET_I', masterRecord.get('BUDGET_I') + dCurBudget);
									}
								});
							}
						}
					}else if(sCurDvrtDV == '2'){
						masterGridSelectRecord.set('BUDGET_I', masterGridSelectRecord.get('BUDGET_I') + dCurBudget);	
					}
				}
				
				UniAppManager.app.fnRememberData('');
			}else{
				if(sOldDvrtDV == '1'){	
					if(!Ext.isEmpty(sOldAcntCD) && !Ext.isEmpty(sOldDeptCD) && !Ext.isEmpty(sOldDvrtDV)){
						masterGridSelectRecord.set('BUDGET_I', masterGridSelectRecord.get('BUDGET_I') + dCurBudget);	
					}
					
					Ext.each(directMasterStore.data.items, function(masterRecord,i){
						if(sOldDeptCD == panelResult.getValue('DEPT_CODE')){
							if(masterRecord.get('ACCNT') == sOldAcntCD){
								masterRecord.set('BUDGET_I', masterRecord.get('BUDGET_I') - dCurBudget);
							}
						}
					});
				}else if(sOldDvrtDV == '2'){
					masterGridSelectRecord.set('BUDGET_I', masterGridSelectRecord.get('BUDGET_I') - dCurBudget);	
				}
				
				UniAppManager.app.fnRememberData('Y');
			}
        	
			deleteFlag = 'N';
        }
	});
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			var tempDate = panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6) + '01';
				tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
			var transDate = new Date(tempDate);
			var sToMonth = '';
				sToMonth = UniDate.add(transDate, {months: + 11});
			
//			param.sFrMonth = panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6);
//			param.sToMonth = UniDate.getDbDateStr(sToMonth).substring(0,6);
			
			switch(fieldName) {
				case "BUDG_YYYYMM" :
					if(newValue.length < 5 && newValue.length > 7 )	{
						rv = 'YYYY.MM(년.월) 형식으로 입력해 주세요.';	
					}
					
					var checkValue = monthFormat(newValue).replace(".","");
					if(checkValue < panelResult.getValue('AC_YYYY') +gsStMonth.substring(4,6) || 
					   checkValue > UniDate.getDbDateStr(sToMonth).substring(0,6)){
//						rv='<t:message code = "unilite.msg.sMA0105"/>';  코드화필요
					   	rv='예산년월은 예산년도의 예산년월(From~To) 사이에서 입력하십시오.';
					}
					
					break;
				case "DIVERT_DIVI" :
					if(newValue == '2'){
						record.set('DIVERT_YYYYMM',		'');
						record.set('DIVERT_ACCNT',		'');
						record.set('DIVERT_ACCNT_NAME',	'');
						record.set('DIVERT_DEPT_CODE',	'');
						record.set('DIVERT_DEPT_NAME',	'');
					}
//				var record1 = detailGrid.getSelectedRecord();
//					alert(record1.get('DIVERT_DIVI'));
					break;
				case "DIVERT_YYYYMM" :
					if(newValue.length < 5 && newValue.length > 7 )	{
						rv = 'YYYY.MM(년.월) 형식으로 입력해 주세요.';	
					}
					var checkValue = newValue.replace(".","");
					if(checkValue < panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6) || 
					   checkValue > UniDate.getDbDateStr(sToMonth).substring(0,6)){
//						rv='<t:message code = "unilite.msg.sMA0115"/>';  코드화필요
					   	rv='전용년월은 예산년도의 예산년월(From~To) 사이에서 입력하십시오.';
					}
					break;
				case "DIVERT_BUDG_I" :
					if(Ext.isEmpty(record.get('DIVERT_DIVI'))){
						rv='전용구분을 입력하십시오.';	
						break;
					}else{
						if(record.get('DIVERT_DIVI') == '1'){
							if(Ext.isEmpty(record.get('DIVERT_ACCNT'))){
								rv='전용과목을 입력하십시오.';	
								break;
							}
							if(Ext.isEmpty(record.get('DIVERT_DEPT_CODE'))){
								rv='전용부서를 입력하십시오.';
								break;
							}
						}
					}
					
					
					
					
				
					break;
			}
				return rv;
		}
	});	
	/*Unilite.createValidator('validator02', {
		forms: {'formA:':panelSearch,
				'formB:':panelResult},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case "AC_YYYY" : 
					alert('ddd');
					break;
						
			}
			return rv;
		}
	});	*/
};


</script>
