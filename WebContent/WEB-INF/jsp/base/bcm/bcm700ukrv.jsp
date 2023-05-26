<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm700ukr"  >
<t:ExtComboStore comboType="AU" comboCode="S051" /> 	<!-- 전자문서구분 -->
<t:ExtComboStore comboType="AU" comboCode="S053" /> 	<!--전자문서주담당자여부-->
<t:ExtComboStore comboType="AU" comboCode="B010" />	 <!--사용여부-->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('bcm700ukrModel1', {
		fields: [
			{name: 'CUSTOM_CODE'	,text: '거래처코드'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '거래처명'		,type: 'string'}, 
			{name: 'COMPANY_NUM'	,text: '사업자등록번호'	,type: 'string'} 
		]
	});
	
	Unilite.defineModel('bcm700ukrModel2', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.base.division" default="사업장"/>'	,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '거래처코드'			,type: 'string'},
			{name: 'SEQ'			,text: '<t:message code="system.label.base.seq" default="순번"/>'			,type: 'int', allowBlank: false},
			{name: 'PRSN_NAME'		,text: '담당자명'			,type: 'string', allowBlank: false},
			{name: 'DEPT_NAME'		,text: '부서명'			,type: 'string'},
			{name: 'HAND_PHON'		,text: '핸드폰번호'			,type: 'string'},
			{name: 'TELEPHONE_NUM1'	,text: '전화번호1'			,type: 'string', allowBlank: false},
			{name: 'TELEPHONE_NUM2'	,text: '전화번호2'			,type: 'string'},
			{name: 'FAX_NUM'		,text: '팩스번호'			,type: 'string'},
			{name: 'MAIL_ID'		,text: 'E-MAIL주소'		,type: 'string', allowBlank: false},
			{name: 'BILL_TYPE'		,text: '전자문서구분'			,type: 'string', comboType:'AU', comboCode:'S051'},
			{name: 'MAIN_BILL_YN'	,text: '전자문서주담당자여부'	,type: 'string', allowBlank: false, comboType:'AU', comboCode:'B010'},
			{name: 'REMARK'			,text: '<t:message code="system.label.base.remarks" default="비고"/>'		,type: 'string'},
			{name: 'INSERT_DB_USER'	,text: '입력자'			,type: 'string'},
			{name: 'INSERT_DB_TIME'	,text: '입력일'			,type: 'uniDate'},
			{name: 'UPDATE_DB_USER'	,text: '수정자'			,type: 'string'},
			{name: 'UPDATE_DB_TIME'	,text: '수정일'			,type: 'uniDate'}
		]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'bcm700ukrvService.selectMaster2',
			update: 'bcm700ukrvService.updateDetail',
			create: 'bcm700ukrvService.insertDetail',
			destroy: 'bcm700ukrvService.deleteDetail',
			syncAll: 'bcm700ukrvService.saveAll'
		}
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bcm700ukrMasterStore1',{
			model: 'bcm700ukrModel1',
			uniOpt : {
				isMaster: true,			// 상위 버튼 연결 
				editable: false,			// 수정 모드 사용 
				deletable:false,			// 삭제 가능 여부 
				useNavi : false			// prev | next 버튼 사용
			},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {read: 'bcm700ukrvService.selectMaster'}
			}								
			,loadStoreRecords : function()	{
				var param= panelResult.getValues();
				console.log( param );
				this.load({
						params : param,
						callback : function(records, operation, success) {
							if(success)	{
								
							}
						}
					}
				);
			}
	});
	
	var directMasterStore2 = Unilite.createStore('bcm700ukrMasterStore1',{
			model: 'bcm700ukrModel2',
			uniOpt : {
				isMaster: true,			// 상위 버튼 연결 
				editable: true,			// 수정 모드 사용 
				deletable:true,			// 삭제 가능 여부 
				useNavi : false			// prev | next 버튼 사용
			},
			autoLoad: false,
			proxy: directProxy,
			listeners: {
				write: function(proxy, operation){
					if (operation.action == 'destroy') {
						Ext.getCmp('panelResult').reset();
					}				
				}
			
			}
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
				
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기
			,saveStore : function(config)	{	
// var paramMaster= [];
// var app = Ext.getCmp('bpr100ukrvApp');
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
				var toUpdate = this.getUpdatedRecords();
				console.log("toUpdate",toUpdate);

				var rv = true;
		
				if(inValidRecs.length == 0 )	{
					config = {
// params: [paramMaster],
							success: function(batch, option) {
								panelResult.resetDirtyStatus();
								UniAppManager.setToolbarButtons('save', false);
							 } 
					};	
					this.syncAllDirect(config);
				}else {
					masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
// panelResult.setActiveRecord(record);
				}	
			}
	});
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {
		width: '-100',		
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		region: 'west',
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
				Unilite.popup('AGENT_CUST',{
						fieldLabel: '거래처코드',
						valueFieldName:'CUSTOM_CODE',
						textFieldName:'CUSTOM_NAME',
						validateBlank:false,
						//extParam:{'CUSTOM_TYPE':'3'},
						listeners: {
							onValueFieldChange: function(field, newValue){
								panelResult.setValue('CUSTOM_CODE', newValue);
							},
							onTextFieldChange: function(field, newValue){
								panelResult.setValue('CUSTOM_NAME', newValue);
							}
/*							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
									panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}*/
						}
				}),{					
					fieldLabel: '<t:message code="system.label.base.seq" default="순번"/>',
					name:'SEQ',
					xtype: 'hiddenfield'
				}
			]
		}],
		setAllFieldsReadOnly: function(b) { 
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				}); 
				/*
				 * if(invalid.length > 0) { r=false; var labelText = ''
				 * if(Ext.isDefined(invalid.items[0]['fieldLabel'])) { var
				 * labelText = invalid.items[0]['fieldLabel']+'은(는)'; } else
				 * if(Ext.isDefined(invalid.items[0].ownerCt)) { var labelText =
				 * invalid.items[0].ownerCt['fieldLabel']+'은(는)'; }
				 * Unilite.messageBox(labelText+Msg.sMB083); invalid.items[0].focus(); } else
				 */ {
					// this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;   
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				// this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ; 
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	}); 
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '거래처코드',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				validateBlank:false,
				//extParam:{'CUSTOM_TYPE':'3'},
				listeners: {
					onValueFieldChange: function(field, newValue){
						masterForm.setValue('CUSTOM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						masterForm.setValue('CUSTOM_NAME', newValue);
					}
/*					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
							masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						masterForm.setValue('CUSTOM_CODE', '');
						masterForm.setValue('CUSTOM_NAME', '');
					}*/
				}
			})
		],
		setAllFieldsReadOnly: function(b) { 
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				}); 
				/*
				 * if(invalid.length > 0) { r=false; var labelText = ''
				 * if(Ext.isDefined(invalid.items[0]['fieldLabel'])) { var
				 * labelText = invalid.items[0]['fieldLabel']+'은(는)'; } else
				 * if(Ext.isDefined(invalid.items[0].ownerCt)) { var labelText =
				 * invalid.items[0].ownerCt['fieldLabel']+'은(는)'; }
				 * Unilite.messageBox(labelText+Msg.sMB083); invalid.items[0].focus(); } else
				 */ {
					// this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;   
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				// this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ; 
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});  
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('bcm700ukrGrid1', {
		// for tab		
		layout : 'fit',
		region: 'west',
		flex: 1,
		store: directMasterStore1,
		uniOpt: {	
			expandLastColumn: false,
			useRowNumberer: false,
			useMultipleSorting: true
		},
		columns: [
			{ dataIndex: 'CUSTOM_CODE'					, width: 88 },
			{ dataIndex: 'CUSTOM_NAME'					, width: 120 },
			{ dataIndex: 'COMPANY_NUM'					, width: 180 }
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					masterForm.setValue('CUSTOM_CODE',record.get('CUSTOM_CODE'));
					directMasterStore2.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
			}
		}
	});
	
	var masterGrid2 = Unilite.createGrid('bcm700ukrGrid2', {
		// for tab		
		layout : 'fit',
		region:'center',
		flex: 3,
		uniOpt:{	
			expandLastColumn: true,
			useRowNumberer: false,
			useMultipleSorting: true
		},
		store: directMasterStore2,
		columns:  [
			{ dataIndex: 'COMP_CODE'					, width: 33 ,hidden:true},
			{ dataIndex: 'CUSTOM_CODE'					, width: 66 ,hidden:true},
			{ dataIndex: 'SEQ'							, width: 80 },
			{ dataIndex: 'PRSN_NAME'					, width: 100 },
			{ dataIndex: 'DEPT_NAME'					, width: 150 },
			{ dataIndex: 'HAND_PHON'					, width: 113 },
			{ dataIndex: 'TELEPHONE_NUM1'				, width: 113 },
			{ dataIndex: 'TELEPHONE_NUM2'				, width: 113 },
			{ dataIndex: 'FAX_NUM'						, width: 113 },
			{ dataIndex: 'MAIL_ID'						, width: 170 },
			{ dataIndex: 'BILL_TYPE'					, width: 113 },
			{ dataIndex: 'MAIN_BILL_YN'					, width: 133 },
			{ dataIndex: 'REMARK'						, width: 166 },
			{ dataIndex: 'INSERT_DB_USER'				, width: 66 ,hidden:true},
			{ dataIndex: 'INSERT_DB_TIME'				, width: 66 ,hidden:true},
			{ dataIndex: 'UPDATE_DB_USER'				, width: 66 ,hidden:true},
			{ dataIndex: 'UPDATE_DB_TIME'				, width: 66 ,hidden:true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == true) {
					return true;
				} else {
					if(UniUtils.indexOf(e.field, ['SEQ']))
					{
						return false;
					} else {
						return true;
					}
				}
			} 	
		}
	});
		
	Unilite.Main({
		borderItems:[{
				layout: 'border',
				region: 'center',
				items: [masterGrid1, masterGrid2, panelResult]
			},
			masterForm
		],
		id  : 'bcm700ukrApp',
		fnInitBinding : function() {
			//masterForm.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['detail','reset','save'],false);
		},
		onQueryButtonDown : function() {
			//directMasterStore1.loadStoreRecords();
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(masterForm.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore1.loadStoreRecords();
			beforeRowIndex = -1;
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('newData', true);
		},
		setDefault: function() {		// 기본값
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false); 
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			masterForm.clearForm();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterForm.setAllFieldsReadOnly(false);
			masterGrid1.reset();
			directMasterStore1.clearData();
			masterGrid2.reset();
			directMasterStore2.clearData();
			this.fnInitBinding();
			masterForm.getField('CUSTOM_CODE').focus();
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow1 = masterGrid2.getSelectedRecord();
			if(selRow1.phantom === true)	{
				masterGrid2.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid2.deleteSelectedRow();
			}
		},
		onNewDataButtonDown: function()	{		// 행추가
			var seq = directMasterStore2.max('SEQ');
				if(!seq) seq = 1;
				else  seq += 1;
			var  compCode = UserInfo.compCode; 
			var customCode 		= masterForm.getValue('CUSTOM_CODE');   
			var prsnName		= '';
			var deptName		= '';
			var handPhon		= '';
			var telephonNum1	= '';
			var telephonNum2	= '';
			var taxNum			= '';
			var mailId			= '';
			var billType		= '3';
			var mainBillYn		= 'N';
			var remark 			= '';
			
			var r = {
				COMP_CODE:		compCode,
				CUSTOM_CODE:	customCode,
				SEQ:			seq,
				PRSN_NAME:		prsnName,
				DEPT_NAME:		deptName,
				HAND_PHON:		handPhon,
				TELEPHONE_NUM1: telephonNum1,
				TELEPHONE_NUM2: telephonNum2,
				TAX_NUM:		taxNum,
				MAIL_ID:		mailId,
				BILL_TYPE:		billType,
				MAIN_BILL_YN:	mainBillYn,
				REMARK:		remark
			};
			masterGrid2.createRow(r, 'ITEM_CODE', seq-2);
			masterForm.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onSaveDataButtonDown: function (config) {
			directMasterStore2.saveStore(config);
		}
	});
};

</script>
