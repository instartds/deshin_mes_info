<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ppl102ukrv_novis"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
	
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 재고단위 -->
	<t:ExtComboStore comboType="AU" comboCode="ZS01" /> <!-- 공정 -->
	<t:ExtComboStore comboType="AU" comboCode="ZS02" /> <!-- 상태 -->
	
</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >

function appMain() {
	
	var fields		= createModelField();
	var columns		= createGridColumn();
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read: 's_ppl102ukrv_novisService.selectList1',
			create: 's_ppl102ukrv_novisService.insertDetail1',
			update: 's_ppl102ukrv_novisService.updateDetail1',
			destroy: 's_ppl102ukrv_novisService.deleteDetail1',
			syncAll: 's_ppl102ukrv_novisService.saveAll1'
		}
	});
	Unilite.defineModel('detailModel', {
		fields: fields
		
		
		
/*		[
			{name: 'DIV_CODE'			,text: '사업장' 		,type: 'string',comboType:'BOR120', allowBlank:false},
			{name: 'ITEM_CODE'			,text: '품목코드' 		,type: 'string', allowBlank:false},
			{name: 'ITEM_NAME'			,text: '품목명' 		,type: 'string'},
			{name: 'SPEC'				,text: '규격' 		,type: 'string'},
			
			{name: 'CUSTOM_CODE'		,text: '거래처코드' 	,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '거래처명' 		,type: 'string'},
			{name: 'WK_PLAN_Q'			,text: '생산계획량'		,type: 'uniQty', allowBlank:false},
			{name: 'STOCK_UNIT'			,text: '단위' 		,type: 'string', comboType: 'AU', comboCode: 'B013', displayField: 'value'},
			
			{name: 'PROG_CODE1'			,text: '공정' 		,type: 'string', comboType: 'AU', comboCode: 'ZS01'},
			{name: 'PROG_STATUS1'		,text: '상태' 		,type: 'string', comboType: 'AU', comboCode: 'ZS02'},
			{name: 'PRODT_PLAN_DATE1'	,text: '계획일자' 		,type: 'uniDate', allowBlank:false,editable:false},
			{name: 'PRODT_DATE1'		,text: '완료일자' 		,type: 'uniDate'},
			{name: 'WK_PLAN_NUM1'		,text: 'WK_PLAN_NUM1' 		,type: 'string',editable:false},
			
			{name: 'PROG_CODE2'			,text: '공정' 		,type: 'string', comboType: 'AU', comboCode: 'ZS01'},
			{name: 'PROG_STATUS2'		,text: '상태' 		,type: 'string', comboType: 'AU', comboCode: 'ZS02'},
			{name: 'PRODT_PLAN_DATE2'	,text: '계획일자' 		,type: 'uniDate', allowBlank:false,editable:false},
			{name: 'PRODT_DATE2'		,text: '완료일자' 		,type: 'uniDate'},
			{name: 'WK_PLAN_NUM2'		,text: 'WK_PLAN_NUM2' 		,type: 'string',editable:false},
			
			{name: 'PROG_CODE3'			,text: '공정' 		,type: 'string', comboType: 'AU', comboCode: 'ZS01'},
			{name: 'PROG_STATUS3'		,text: '상태' 		,type: 'string', comboType: 'AU', comboCode: 'ZS02'},
			{name: 'PRODT_PLAN_DATE3'	,text: '계획일자' 		,type: 'uniDate', allowBlank:false,editable:false},
			{name: 'PRODT_DATE3'		,text: '완료일자' 		,type: 'uniDate'},
			{name: 'WK_PLAN_NUM3'		,text: 'WK_PLAN_NUM3' 		,type: 'string',editable:false},
			
			{name: 'PROG_CODE4'			,text: '공정' 		,type: 'string', comboType: 'AU', comboCode: 'ZS01'},
			{name: 'PROG_STATUS4'		,text: '상태' 		,type: 'string', comboType: 'AU', comboCode: 'ZS02'},
			{name: 'PRODT_PLAN_DATE4'	,text: '계획일자' 		,type: 'uniDate', allowBlank:false,editable:false},
			{name: 'PRODT_DATE4'		,text: '완료일자' 		,type: 'uniDate'},
			{name: 'WK_PLAN_NUM4'		,text: 'WK_PLAN_NUM4' 		,type: 'string',editable:false},
						
			{name: 'PROG_CODE5'			,text: '공정' 		,type: 'string', comboType: 'AU', comboCode: 'ZS01'},
			{name: 'PROG_STATUS5'		,text: '상태' 		,type: 'string', comboType: 'AU', comboCode: 'ZS02'},
			{name: 'PRODT_PLAN_DATE5'	,text: '계획일자' 		,type: 'uniDate', allowBlank:false,editable:false},
			{name: 'PRODT_DATE5'		,text: '완료일자' 		,type: 'uniDate'},
			{name: 'WK_PLAN_NUM5'		,text: 'WK_PLAN_NUM5' 		,type: 'string',editable:false},
			
			{name: 'PROG_CODE6'			,text: '공정' 		,type: 'string', comboType: 'AU', comboCode: 'ZS01'},
			{name: 'PROG_STATUS6'		,text: '상태' 		,type: 'string', comboType: 'AU', comboCode: 'ZS02'},
			{name: 'PRODT_PLAN_DATE6'	,text: '계획일자' 		,type: 'uniDate', allowBlank:false,editable:false},
			{name: 'PRODT_DATE6'		,text: '완료일자' 		,type: 'uniDate'},
			{name: 'WK_PLAN_NUM6'		,text: 'WK_PLAN_NUM6' 		,type: 'string',editable:false},
			
			{name: 'PROG_CODE7'			,text: '공정' 		,type: 'string', comboType: 'AU', comboCode: 'ZS01'},
			{name: 'PROG_STATUS7'		,text: '상태' 		,type: 'string', comboType: 'AU', comboCode: 'ZS02'},
			{name: 'PRODT_PLAN_DATE7'	,text: '계획일자' 		,type: 'uniDate', allowBlank:false,editable:false},
			{name: 'PRODT_DATE7'		,text: '완료일자' 		,type: 'uniDate'},
			{name: 'WK_PLAN_NUM7'		,text: 'WK_PLAN_NUM7' 		,type: 'string',editable:false},
			
			{name: 'PROG_CODE8'			,text: '공정' 		,type: 'string', comboType: 'AU', comboCode: 'ZS01'},
			{name: 'PROG_STATUS8'		,text: '상태' 		,type: 'string', comboType: 'AU', comboCode: 'ZS02'},
			{name: 'PRODT_PLAN_DATE8'	,text: '계획일자' 		,type: 'uniDate', allowBlank:false,editable:false},
			{name: 'PRODT_DATE8'		,text: '완료일자' 		,type: 'uniDate'},
			{name: 'WK_PLAN_NUM8'		,text: 'WK_PLAN_NUM8' 		,type: 'string',editable:false},
			
			{name: 'PROG_CODE9'			,text: '공정' 		,type: 'string', comboType: 'AU', comboCode: 'ZS01'},
			{name: 'PROG_STATUS9'		,text: '상태' 		,type: 'string', comboType: 'AU', comboCode: 'ZS02'},
			{name: 'PRODT_PLAN_DATE9'	,text: '계획일자' 		,type: 'uniDate', allowBlank:false,editable:false},
			{name: 'PRODT_DATE9'		,text: '완료일자' 		,type: 'uniDate'},
			{name: 'WK_PLAN_NUM9'		,text: 'WK_PLAN_NUM9' 		,type: 'string',editable:false},
			
			{name: 'PROG_CODE10'		,text: '공정' 		,type: 'string', comboType: 'AU', comboCode: 'ZS01'},
			{name: 'PROG_STATUS10'		,text: '상태' 		,type: 'string', comboType: 'AU', comboCode: 'ZS02'},
			{name: 'PRODT_PLAN_DATE10'	,text: '계획일자' 		,type: 'uniDate', allowBlank:false,editable:false},
			{name: 'PRODT_DATE10'		,text: '완료일자' 		,type: 'uniDate'},
			{name: 'WK_PLAN_NUM10'		,text: 'WK_PLAN_NUM10' 		,type: 'string',editable:false},
			
			{name: 'PROG_CODE11'		,text: '공정' 		,type: 'string', comboType: 'AU', comboCode: 'ZS01'},
			{name: 'PROG_STATUS11'		,text: '상태' 		,type: 'string', comboType: 'AU', comboCode: 'ZS02'},
			{name: 'PRODT_PLAN_DATE11'	,text: '계획일자' 		,type: 'uniDate', allowBlank:false,editable:false},
			{name: 'PRODT_DATE11'		,text: '완료일자' 		,type: 'uniDate'},
			{name: 'WK_PLAN_NUM11'		,text: 'WK_PLAN_NUM11' 		,type: 'string',editable:false}
		]
		
		*/
	});
	
	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: directProxy,
		autoLoad: false,
		uniOpt: {
			isMaster: true,	// 상위 버튼 연결 
			editable: true,		// 수정 모드 사용 
			deletable: true,		// 삭제 가능 여부 
			useNavi: false		// prev | next 버튼 사용
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
						detailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
				
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load:function(store, records, successful, eOpts) {
           	},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function( store, eOpts ) {
			}
		}
	});
	
	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns :2},
			
//			tableAttrs: {width: '100%'}
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
//		},
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
		 	fieldLabel: '기준일',
		 	xtype: 'uniDatefield',
		 	name: 'BASIS_DATE',
			value: UniDate.get('today'),
			allowBlank: false,
			listeners:{
				
				change: function(field, newValue, oldValue, eOpts) {
					if(UniDate.getDbDateStr(newValue) != UniDate.getDbDateStr(oldValue)){
	            		var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
																return !field.validate();
															});				   															
						if(invalid.length > 0) {
						   	invalid.items[0].focus();
						   	return false;
						}
						
//						var beforeValue = panelSearch.getValue('BASIS_DATE');
						
						if(detailStore.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
							
							if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
								panelSearch.setValue('BASIS_DATE',oldValue);
//								UniAppManager.app.onSaveDataButtonDown();
								return;
							}
						}
						
						
						
						var param = {
							BASIS_DATE: UniDate.getDbDateStr(newValue)
						}
						s_ppl102ukrv_novisService.getPlanDay(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								
								for(var i = 1; i<12; i++){
									var nameString = 'DAY_'+i;
									Ext.getCmp(nameString).setConfig('text',provider[nameString]);
								}
							}
							
						})
						
						detailGrid.reset();
						detailStore.clearData();
						detailStore.commitChanges();
						UniAppManager.setToolbarButtons('save', false);
						
					}
				}
				/*blur: function(field, event, eOpts ){
					
					if(field.lastValue != field.originalValue){
						var param = {
							BASIS_DATE: UniDate.getDbDateStr(field.lastValue)
						}
						s_ppl102ukrv_novisService.getPlanDay(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								
								for(var i = 1; i<12; i++){
									var nameString = 'DAY_'+i;
									Ext.getCmp(nameString).setConfig('text',provider[nameString]);
								}
							}
							
						})
					}
				}*/
			}
			
			
			
		},
		Unilite.popup('DIV_PUMOK',{
        	fieldLabel: '품목',
        	valueFieldName: 'ITEM_CODE', 
			textFieldName: 'ITEM_NAME', 
        	listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
   		}),
		Unilite.popup('CUST',{
        	fieldLabel: '거래처',
        	valueFieldName: 'CUSTOM_CODE', 
			textFieldName: 'CUSTOM_NAME'
		})]
	});

	var detailGrid = Unilite.createGrid('detailGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
//            userToolbar:false,
			expandLastColumn: false,
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
		columns: columns,
		setItemData: function(record, dataClear, grdRecord) {
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'			, "");
       			grdRecord.set('ITEM_NAME'			, "");
       			grdRecord.set('SPEC'				, ""); 
				grdRecord.set('STOCK_UNIT'			, "");
				
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('SPEC'				, record['SPEC']); 
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			
       		}
		},
/*		[
		
			{ dataIndex: 'DIV_CODE'				, width: 100},
			{ dataIndex: 'ITEM_CODE'				, width: 100},
			{ dataIndex: 'ITEM_NAME'				, width: 100},
			{ dataIndex: 'SPEC'					, width: 100},
			{ dataIndex: 'CUSTOM_CODE'			, width: 100},
			{ dataIndex: 'CUSTOM_NAME'			, width: 100},
			{ dataIndex: 'WK_PLAN_Q'				, width: 100},
			{ dataIndex: 'STOCK_UNIT'				, width: 100}
		
		
			
			
			
		],	*/
		listeners: {
          	selectionchangerecord:function(selected) {
          		
//				subForm.clearForm();
				/*
				setTimeout( function() {
          		subForm.setActiveRecord(selected);
					
	          		detailStore2.loadStoreRecords(selected);
   				}, 50 );*/
          	},
/*			render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					if(detailStore2.isDirty()){
						alert('먼저 저장하십시오');
						return false;
					}else {
				    	var oldGrid = Ext.getCmp('detailGrid2');
				    	grid.changeFocusCls(oldGrid);
						selectedGrid = girdNm;
						
						if(!Ext.isEmpty(detailGrid.getSelectedRecord())){
							subForm.getForm().getFields().each(function(field) {
	                            field.setReadOnly(false);
							});
						}
						
						if(grid.getStore().getCount() > 0)  {
							UniAppManager.setToolbarButtons('delete', true);
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
					}

				});

			},*/
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['DIV_CODE','SPEC','STOCK_UNIT'])) {
					return false;
				} else {
					return true;
				}
			}
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
		id: 's_ppl102ukrv_novisApp',
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			
			this.fnInitInputFields();
			
			detailGrid.reset();
			detailStore.clearData();
		},
		onQueryButtonDown: function() {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
			
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			detailStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('newData', true);
		},
		onNewDataButtonDown: function()	{
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
			var r = {
				DIV_CODE: panelSearch.getValue('DIV_CODE')
				
				
//				PRODT_PLAN_DATE1: Ext.getCmp('DAY_1').config.text,
//				PRODT_PLAN_DATE2: Ext.getCmp('DAY_2').config.text,
//				PRODT_PLAN_DATE3: Ext.getCmp('DAY_3').config.text,
//				PRODT_PLAN_DATE4: Ext.getCmp('DAY_4').config.text,
//				PRODT_PLAN_DATE5: Ext.getCmp('DAY_5').config.text,
//				PRODT_PLAN_DATE6: Ext.getCmp('DAY_6').config.text,
//				PRODT_PLAN_DATE7: Ext.getCmp('DAY_7').config.text,
//				PRODT_PLAN_DATE8: Ext.getCmp('DAY_8').config.text,
//				PRODT_PLAN_DATE9: Ext.getCmp('DAY_9').config.text,
//				PRODT_PLAN_DATE10: Ext.getCmp('DAY_10').config.text,
//				PRODT_PLAN_DATE11: Ext.getCmp('DAY_11').config.text
				
				
				/*ITEM_CODE: param.NEW_ITEM_CODE,
				
				USE_YN:'Y',
				SALE_UNIT:provider.SALE_UNIT,
				TAX_TYPE:provider.TAX_TYPE,
				ORDER_UNIT:provider.ORDER_UNIT,
				SUPPLY_TYPE:provider.SUPPLY_TYPE,
				ROUT_TYPE:'100',
				WORK_SHOP_CODE:provider.WORK_SHOP_CODE,
				OUT_METH:'2',
				WH_CODE:provider.WH_CODE,
				RESULT_YN:'2',
				ORDER_PLAN:provider.ORDER_PLAN,
				ORDER_METH:'2',
				ITEM_ACCOUNT:'20',
				USE_BY_DATE:'24',
				
				REGISTER_NO : panelSearch.getValue('REGISTER_NO')*/
				
			}
			detailGrid.createRow(r);
		
		},

		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)){
				if(selRow.phantom === true)	{
					detailGrid.deleteSelectedRow();
				}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid.deleteSelectedRow();
				}
			}
		},
		onSaveDataButtonDown: function(config) {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
            
			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			
			panelSearch.setValue('BASIS_DATE',UniDate.get('today'));
		
			var basisDate = UniDate.getDbDateStr(panelSearch.getValue('BASIS_DATE'));
			var param = {
				BASIS_DATE: Ext.isEmpty(basisDate) ? UniDate.getDbDateStr(UniDate.get('today')) : basisDate
			}
			s_ppl102ukrv_novisService.getPlanDay(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					
					for(var i = 1; i<12; i++){
						var nameString = 'DAY_'+i;
						Ext.getCmp(nameString).setConfig('text',provider[nameString]);
					}
				}
				
			})
			
			
//			createGridColumn(UniDate.getDbDateStr(panelSearch.getValue('BASIS_DATE')));
			
//			masterGrid.setColumnInfo(masterGrid, columns1, fields);
//			detailGrid.setColumnInfo(detailGrid, columns, fields);
			
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','save'], false);
		}
	});
	
/*	function createModelField(getPlanDay) {
		var fields = [  	  
	    	
			{name: 'DIV_CODE'			,text: '사업장' 		,type: 'string',comboType:'BOR120', allowBlank:false},
			{name: 'ITEM_CODE'			,text: '품목코드' 		,type: 'string', allowBlank:false},
			{name: 'ITEM_NAME'			,text: '품목명' 		,type: 'string', allowBlank:false},
			{name: 'SPEC'				,text: '규격' 		,type: 'string'},
			
			{name: 'CUSTOM_CODE'		,text: '거래처코드' 	,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '거래처명' 		,type: 'string'},
			{name: 'WK_PLAN_Q'			,text: '생산계획량'		,type: 'uniQty'},
			{name: 'STOCK_UNIT'			,text: '단위' 		,type: 'string', comboType: 'AU', comboCode: 'B013', displayField: 'value'}
		] ;
					
		Ext.each(deptList, function(item, index) {
			fields.push({name: 'BUDG_' + item.DEPT_CODE, text:'예산', type:'uniPrice'})
			fields.push({name: 'AMT_' + item.DEPT_CODE, text:'실적', type:'uniPrice'})
			fields.push({name: 'DIFF_' + item.DEPT_CODE, text:'차액', type:'uniPrice'})
			fields.push({name: 'RATE_' + item.DEPT_CODE, text:'달성률', type:'uniPercent'})
		});
		return fields;
	};
	*/
	
	function createModelField() {
		//필드 생성
		var fields = [
			{name: 'DIV_CODE'			,text: '사업장' 		,type: 'string',comboType:'BOR120', allowBlank:false},
			{name: 'ITEM_CODE'			,text: '품목코드' 		,type: 'string', allowBlank:false},
			{name: 'ITEM_NAME'			,text: '품목명' 		,type: 'string'},
			{name: 'SPEC'				,text: '규격' 		,type: 'string'},
			
			{name: 'CUSTOM_CODE'		,text: '거래처코드' 	,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '거래처명' 		,type: 'string'},
			{name: 'WK_PLAN_Q'			,text: '생산계획량'		,type: 'uniQty'},
			{name: 'STOCK_UNIT'			,text: '단위' 		,type: 'string', comboType: 'AU', comboCode: 'B013', displayField: 'value'}
			
		];
		for(var i = 1; i<12; i++){
			fields.push(
				{name: 'PROG_CODE'+i			,text: '공정' 		,type: 'string', comboType: 'AU', comboCode: 'ZS01'},
				{name: 'PROG_STATUS'+i		,text: '상태' 		,type: 'string', comboType: 'AU', comboCode: 'ZS02'},
				{name: 'PRODT_PLAN_DATE'+i	,text: '계획일자' 		,type: 'uniDate',editable:false},
				{name: 'PRODT_DATE'+i		,text: '완료일자' 		,type: 'uniDate'},
				{name: 'WK_PLAN_NUM'+i		,text: '계획번호' 		,type: 'string',editable:false}
			);
		}
		return fields;
	}
	
	
	function createGridColumn() {
		var columns = [
			{ dataIndex: 'DIV_CODE'				, width: 100,hidden:true},
			{ dataIndex: 'ITEM_CODE'			, width: 100,
				editor: Unilite.popup('DIV_PUMOK_G', {
                    textFieldName: 'ITEM_CODE',
                    DBtextFieldName: 'ITEM_CODE',
	                autoPopup: true,
                    listeners: {
                        'onSelected': {
                            fn: function(records, type) {
                                Ext.each(records, function(record,i) {
                                    if(i==0) {
                                        detailGrid.setItemData(record,false,detailGrid.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        detailGrid.setItemData(record,false,detailGrid.getSelectedRecord());
                                    }
                                });
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            detailGrid.setItemData(null,true,detailGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'SELMODEL': 'MULTI'});
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue("DIV_CODE")});
                        }
                    }
                })
			
			},
			{ dataIndex: 'ITEM_NAME'			, width: 200,
				editor: Unilite.popup('DIV_PUMOK_G', {
                    textFieldName: 'ITEM_CODE',
                    DBtextFieldName: 'ITEM_CODE',
	                autoPopup: true,
                    listeners: {
                        'onSelected': {
                            fn: function(records, type) {
                                Ext.each(records, function(record,i) {
                                    if(i==0) {
                                        detailGrid.setItemData(record,false,detailGrid.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        detailGrid.setItemData(record,false,detailGrid.getSelectedRecord());
                                    }
                                });
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            detailGrid.setItemData(null,true,detailGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'SELMODEL': 'MULTI'});
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue("DIV_CODE")});
                        }
                    }
                })
            },
			{ dataIndex: 'SPEC'					, width: 150},
			{ dataIndex: 'CUSTOM_CODE'			, width: 100,
				editor : Unilite.popup('CUST_G',{						            
    				textFieldName:'CUSTOM_CODE',
    				autoPopup:true,
    				listeners: {
		            	'onSelected':  function(records, type  ){
							var grdRecord = detailGrid.uniOpt.currentRecord;
	                    	grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
	                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                }
		                ,'onClear':  function( type  ){
	                    	var grdRecord = detailGrid.uniOpt.currentRecord;
	                    	grdRecord.set('CUSTOM_CODE','');
	                    	grdRecord.set('CUSTOM_NAME','');
		                }
		            }
				})
			},
			{ dataIndex: 'CUSTOM_NAME'			, width: 200,
				editor : Unilite.popup('CUST_G',{						            
    				textFieldName:'CUSTOM_CODE',
    				autoPopup:true,
    				listeners: {
		                'onSelected':  function(records, type  ){
	                    	var grdRecord = detailGrid.uniOpt.currentRecord;
	                    	grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
	                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                }
		                ,'onClear':  function( type  ){
	                    	var grdRecord = detailGrid.uniOpt.currentRecord;
	                    	grdRecord.set('CUSTOM_CODE','');
	                    	grdRecord.set('CUSTOM_NAME','');
		                }
		            }
				})
			},
			{ dataIndex: 'WK_PLAN_Q'			, width: 100},
			{ dataIndex: 'STOCK_UNIT'			, width: 80,align:'center'}
			
			
		];
		
//		var param = {
//			BASIS_DATE: Ext.isEmpty(basisDate) ? UniDate.getDbDateStr(UniDate.get('today')) : basisDate
//		}
//		s_ppl102ukrv_novisService.getPlanDay(param, function(provider, response){
//			if(!Ext.isEmpty(provider)){
//		
				
				
				for(var i = 1; i<12; i++){
					var nameString = 'DAY_'+i;
					columns.push(
						{text: nameString, id:nameString,
							columns:[
								{ dataIndex: 'PROG_CODE'+i			, width: 100},
								{ dataIndex: 'PROG_STATUS'+i			, width: 100},
								{ dataIndex: 'PRODT_PLAN_DATE'+i	, width: 100},
								{ dataIndex: 'PRODT_DATE'+i			, width: 100},
								{ dataIndex: 'WK_PLAN_NUM'+i			, width: 150,hidden:true}
			                ]
						}
					)
				}
//			}
			return columns;
//		})
		
		
		
	};
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			
			for(var i = 1; i<12; i++){			
				switch(fieldName) {
					
					case "PROG_CODE"+i :
						if(!Ext.isEmpty(newValue)){
							record.set('PROG_STATUS'+i,'1');
							
							if(Ext.isEmpty(record.get('PRODT_PLAN_DATE'+i))){
								record.set('PRODT_PLAN_DATE'+i, Ext.getCmp('DAY_'+i).config.text);
							}
							
						}else{
							record.set('PROG_STATUS'+i, '');
							record.set('PRODT_PLAN_DATE'+i, '');
							record.set('PRODT_DATE'+i, '');
							
						}
						break;
						
					case "PROG_STATUS"+i :
						if(newValue == '3'){
							record.set('PRODT_DATE'+i,UniDate.get('today'));
						}
					
						break;
				}
			}
			
			
			return rv;
		}
	});
	
};
</script>