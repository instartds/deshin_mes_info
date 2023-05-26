<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="cpa110skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="YP11" /> <!-- 구분 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var CustomCodeInfo = {
	gsUnderCalBase: '',
	gsTaxInclude: '',
	gsTaxCalcType: '',
	gsBillType: ''
};

/*alert(CustomCodeInfo.gsUnderCalBase);
alert(CustomCodeInfo.gsTaxInclude);
alert(CustomCodeInfo.gsTaxCalcType);*/

/*
var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/
function appMain() {
   /**
    *   Model 정의 
    * @type 
    */	
	Unilite.defineModel('Cpa110skrvModel', {
		fields: [
			{name: 'COMP_CODE' 			, text: '법인코드'			, type: 'string'},
			{name: 'COOPTOR_ID' 		, text: '조합원ID'		, type: 'string'},
			{name: 'COOPTOR_NAME' 		, text: '조합원명'			, type: 'string'},
			{name: 'COOPTOR_TYPE' 		, text: '조합원구분'		, type: 'string',comboType:'AU', comboCode:'YP11'},	
	    	{name: 'INVEST_POINT'	,text: '출자포인트'			,type: 'uniPrice'},
	    	{name: 'ADD_POINT'		,text: '누적포인트'			,type: 'uniPrice'},
	    	{name: 'USE_POINT'		,text: '사용포인트'			,type: 'uniPrice'}
		]
	});//End of Unilite.defineModel('Cpa110skrvModel', {
	
   	Unilite.defineModel('Cpa110skrvModel2', {
	    fields: [  	 	
	    	{name: 'COMP_CODE'		,text: '법인코드'			,type: 'string'},
	    	{name: 'SALE_DATE'		,text: '실적일자'			,type: 'uniDate'},
	    	{name: 'SALE_AMT_O'		,text: '결제금액'			,type: 'uniPrice'},
	    	{name: 'SAVE_POINT'		,text: '포인트'			,type: 'uniPrice'},
	    	{name: 'DEPT_NAME'		,text: '사용매장'			,type: 'string'},
	    	{name: 'REMARK'			,text: '비고'				,type: 'string'}
	    ]  	
	});		//End of Unilite.defineModel('Cpa110skrvModel2', {
	
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
	var directMasterStore1 = Unilite.createStore('cpa110skrvMasterStore1',{
		model: 'Cpa110skrvModel',
		uniOpt: {
			isMaster: true,         // 상위 버튼 연결 
			editable: false,         // 수정 모드 사용 
			deletable: false,         // 삭제 가능 여부 
			useNavi: false         // prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'cpa110skrvService.selectList'                	
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {

           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params : param
			});
		}

	});//End of var directMasterStore1 = Unilite.createStore('cpa110skrvMasterStore1',{
	var directMasterStore2 = Unilite.createStore('cpa110skrvMasterStore2', {
		model: 'Cpa110skrvModel2',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'cpa110skrvService.selectList2'                	
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params : param
			});
		}
	});//End of var directMasterStore2 = Unilite.createStore('cpa110skrvMasterStore1', {

   /**
    * 검색조건 (Search Panel)
    * @type 
    */
    var masterForm = Unilite.createSearchPanel('searchForm', {		
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
			items: [{
				fieldLabel: '구분', 
				name: 'COOPTOR_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'YP11',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COOPTOR_TYPE', newValue);
					}
				}
			},
			Unilite.popup('', { 
				fieldLabel: '조합원ID', 
				valueFieldName: 'COOPTOR_ID',
		   	 	textFieldName: 'COOPTOR_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('COOPTOR_ID', masterForm.getValue('COOPTOR_ID'));
							panelResult.setValue('COOPTOR_NAME', masterForm.getValue('COOPTOR_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelResult.setValue('COOPTOR_ID', '');
								panelResult.setValue('COOPTOR_NAME', '');
					}
				}
			}),{
				fieldLabel: '실적일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('SALE_DATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SALE_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel:'조합원ID',
				name:'COOPTOR_ID_F',
				xtype:'uniTextfield',
				readOnly:true
			},{
				fieldLabel:'성명',
				name:'COOPTOR_NAME_F',
				xtype:'uniTextfield',
				readOnly:true
			},{
				fieldLabel:'총포인트',
				name:'TOT_POINT',
				xtype:'uniNumberfield',
				readOnly:true
			},{
				fieldLabel:'출자포인트',
				name:'INVEST_POINT',
				xtype:'uniNumberfield',
				readOnly:true
			},{
				fieldLabel:'누적포인트',
				name:'ADD_POINT',
				xtype:'uniNumberfield',
				readOnly:true
			},{
				fieldLabel:'사용포인트',
				name:'USE_POINT',
				xtype:'uniNumberfield',
				readOnly:true
			}]	
		}],
		/*api: {
			load: 'cpa110skrvService.selectForm',
			submit: 'cpa110skrvService.syncForm'				
		},	*/	
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
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '구분', 
				name: 'COOPTOR_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'YP11',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('COOPTOR_TYPE', newValue);
					}
				}
			},
			Unilite.popup('', { 
				fieldLabel: '조합원ID', 
				valueFieldName: 'COOPTOR_ID',
		   	 	textFieldName: 'COOPTOR_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('COOPTOR_ID', panelResult.getValue('COOPTOR_ID'));
							masterForm.setValue('COOPTOR_NAME', panelResult.getValue('COOPTOR_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								masterForm.setValue('COOPTOR_ID', '');
								masterForm.setValue('COOPTOR_NAME', '');
					}
				}
			}),{
				fieldLabel: '실적일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				colspan:2,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(masterForm) {
						masterForm.setValue('SALE_DATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(masterForm) {
			    		masterForm.setValue('SALE_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel:'조합원ID',
				name:'COOPTOR_ID_F',
				xtype:'uniTextfield',
				readOnly:true
			},{
				fieldLabel:'성명',
				name:'COOPTOR_NAME_F',
				xtype:'uniTextfield',
				colspan:3,
				readOnly:true
			},{
				fieldLabel:'총포인트',
				name:'TOT_POINT',
				xtype:'uniNumberfield',
				readOnly:true
			},{
				fieldLabel:'출자포인트',
				name:'INVEST_POINT',
				xtype:'uniNumberfield',
				readOnly:true
			},{
				fieldLabel:'누적포인트',
				name:'ADD_POINT',
				xtype:'uniNumberfield',
				readOnly:true
			},{
				fieldLabel:'사용포인트',
				name:'USE_POINT',
				xtype:'uniNumberfield',
				readOnly:true
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('cpa110skrvGrid1', {
       // for tab       
		layout: 'fit',
		region:'center',
		flex:0.5,
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
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'COMP_CODE' 		 , width: 93,hidden:true},
			{dataIndex: 'COOPTOR_ID' 	 	 , width: 150},
			{dataIndex: 'COOPTOR_NAME'  	 , width: 100},
			{dataIndex: 'COOPTOR_TYPE'  	 , width: 100},
			{dataIndex: 'INVEST_POINT'			,width:80,hidden:true},
			{dataIndex: 'ADD_POINT'				,width:80,hidden:true},
			{dataIndex: 'USE_POINT'				,width:80,hidden:true}
		],
	listeners: {
		/*selectionchange: function(){
				var records = masterGrid2.getSelectedRecords();
				if(records.length > '0'){
					
					
					UniAppManager.setToolbarButtons('save',true);
				}else if(records.length < '1'){
					UniAppManager.setToolbarButtons('save',false);
				}
			},*/
		
		cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					masterForm.setValue('COOPTOR_ID_F',record.get('COOPTOR_ID'));
					masterForm.setValue('COOPTOR_NAME_F',record.get('COOPTOR_NAME'));
					panelResult.setValue('COOPTOR_ID_F',record.get('COOPTOR_ID'));
					panelResult.setValue('COOPTOR_NAME_F',record.get('COOPTOR_NAME'));
					
					masterForm.setValue('INVEST_POINT',record.get('INVEST_POINT'));
					masterForm.setValue('ADD_POINT',record.get('ADD_POINT'));
					masterForm.setValue('USE_POINT',record.get('USE_POINT'));
					panelResult.setValue('INVEST_POINT',record.get('INVEST_POINT'));
					panelResult.setValue('ADD_POINT',record.get('ADD_POINT'));
					panelResult.setValue('USE_POINT',record.get('USE_POINT'));

					masterForm.setValue('TOT_POINT',record.get('INVEST_POINT')+record.get('ADD_POINT')-record.get('USE_POINT'));
					panelResult.setValue('TOT_POINT',record.get('INVEST_POINT')+record.get('ADD_POINT')-record.get('USE_POINT'));
					directMasterStore2.loadStoreRecords(record);
					
				}
				
				beforeRowIndex = rowIndex;
			}
	}
/*		disabledLinkButtons: function(b) {
       		this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
       		this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
       		this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
		},*/
	});//End of var masterGrid = Unilite.createGrid('cpa110skrvGrid1', {   

	var masterGrid2 = Unilite.createGrid('cpa110skrvGrid2', {
		layout: 'fit',
		region: 'east',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
	        onLoadSelectFirst : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
	/*	features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],*/
		store: directMasterStore2,
		columns: [
				{dataIndex: 'COMP_CODE'				,width:80,hidden:true},
				{dataIndex: 'SALE_DATE'				,width:80},
				{dataIndex: 'SALE_AMT_O'			,width:80},
				{dataIndex: 'SAVE_POINT'			,width:80,align : 'center'},
				{dataIndex: 'DEPT_NAME'				,width:100,align : 'center'},
				{dataIndex: 'REMARK'				,width:120}
		]
	});//End of var masterGrid = Unilite.createGrid('cpa110skrvGrid1', {

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,masterGrid2, panelResult
			]	
		},
			masterForm  	
		],	    	
		id: 'cpa110skrvApp',
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons('save',false);
			this.setDefault();
		},
		setDefault: function() {
        	UniAppManager.setToolbarButtons('save',false);
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();			
			
			masterForm.setValue('SALE_DATE_FR',UniDate.get('startOfMonth'));
			masterForm.setValue('SALE_DATE_TO',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('SALE_DATE_TO',UniDate.get('today'));
		},
		onQueryButtonDown: function(){
			directMasterStore1.loadStoreRecords();	
			masterGrid2.reset();
			beforeRowIndex = -1;	
			
			masterForm.setValue('COOPTOR_ID_F','');
			masterForm.setValue('COOPTOR_NAME_F','');
			panelResult.setValue('COOPTOR_ID_F','');
			panelResult.setValue('COOPTOR_NAME_F','');
			masterForm.setValue('INVEST_POINT','');
			masterForm.setValue('ADD_POINT','');
			masterForm.setValue('USE_POINT','');
			masterForm.setValue('TOT_POINT','');
			panelResult.setValue('INVEST_POINT','');
			panelResult.setValue('ADD_POINT','');
			panelResult.setValue('USE_POINT','');
			panelResult.setValue('TOT_POINT','');
			
		},
		
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterGrid2.reset();
			this.fnInitBinding();
		}

	});//End of Unilite.Main( {
	
};
</script>