<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bcm105ukrv_yp">
	<t:ExtComboStore comboType="AU" comboCode="Z003" />					<!-- 출하회	-->
	<t:ExtComboStore comboType="AU" comboCode="Z004" />					<!-- 교육기관	-->
	<t:ExtComboStore comboType="AU" comboCode="Z005" />					<!-- 교육구분	-->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>

<script type="text/javascript" >


function appMain() {
	var SearchInfoWindow;			//검색창

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bcm105ukrv_ypService.selectList',
			update	: 's_bcm105ukrv_ypService.updateDetail',
			create	: 's_bcm105ukrv_ypService.insertDetail',
			destroy	: 's_bcm105ukrv_ypService.deleteDetail',
			syncAll	: 's_bcm105ukrv_ypService.saveAll'
		}
	});	 
	 
	 
	 
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_bcm105ukrv_ypModel', {
		// pkGen : user, system(default)
		 fields: [
			{name: 'DOC_ID'				,text:'DOC_ID'			,type:'uniNumber'},
			{name: 'COMP_CODE'			,text:'COMP_CODE'		,type:'string'	},
			{name: 'EDU_TITLE'			,text:'교육명'				,type:'string'	, allowBlank:false},
			{name: 'EDU_FR_DATE'		,text:'교육일자(fr)'		,type:'uniDate'	, allowBlank:false},
			{name: 'EDU_TO_DATE'		,text:'교육일자(to)'		,type:'uniDate'	},
			{name: 'CUSTOM_CODE'		,text:'거래처코드'			,type:'string'	, allowBlank:false},
			{name: 'CUSTOM_NAME'		,text:'거래처'				,type:'string'	, allowBlank:false},
			{name: 'EDU_CONTENTS'		,text:'교육내용'			,type:'string'	},
			{name: 'EDU_PLACE'			,text:'교육장소'			,type:'string'	},
			{name: 'EDU_OBJECT'			,text:'교육대상'			,type:'string'	},
			{name: 'EDU_TEACHER'		,text:'교육강사'			,type:'string'	},
			{name: 'EDU_GUBUN'			,text:'교육구분'			,type:'string'	, comboType:'AU',comboCode:'Z005'},
			{name: 'EDU_ORGAN'			,text:'교육기관'			,type:'string'	, comboType:'AU',comboCode:'Z004'},
			{name: 'REMARK'				,text:'비고'				,type:'string'	},
			{name: 'DELIVERY_UNION'		,text:'출하회'				,type:'string'	, comboType:'AU',comboCode:'Z003'}
		]
	});
	
	Unilite.defineModel('eduModel', {
		 fields: [
			{name: 'DOC_ID'				,text:'DOC_ID'			,type:'uniNumber'},
			{name: 'COMP_CODE'			,text:'COMP_CODE'		,type:'string'	},
			{name: 'EDU_TITLE'			,text:'교육명'				,type:'string'	, allowBlank:false},
			{name: 'EDU_FR_DATE'		,text:'교육일자(fr)'		,type:'uniDate'	, allowBlank:false},
			{name: 'EDU_TO_DATE'		,text:'교육일자(to)'		,type:'uniDate'	},
			{name: 'CUSTOM_CODE'		,text:'거래처코드'			,type:'string'	, allowBlank:false},
			{name: 'CUSTOM_NAME'		,text:'거래처'				,type:'string'	, allowBlank:false},
			{name: 'EDU_CONTENTS'		,text:'교육내용'			,type:'string'	},
			{name: 'EDU_PLACE'			,text:'교육장소'			,type:'string'	},
			{name: 'EDU_OBJECT'			,text:'교육대상'			,type:'string'	},
			{name: 'EDU_TEACHER'		,text:'교육강사'			,type:'string'	},
			{name: 'EDU_GUBUN'			,text:'교육구분'			,type:'string'	, comboType:'AU',comboCode:'Z005'},
			{name: 'EDU_ORGAN'			,text:'교육기관'			,type:'string'	, comboType:'AU',comboCode:'Z004'},
			{name: 'REMARK'				,text:'비고'				,type:'string'	},
			{name: 'DELIVERY_UNION'		,text:'출하회'				,type:'string'	, comboType:'AU',comboCode:'Z003'}
		]
	});



	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var detailDataStore = Unilite.createStore('s_bcm105ukrv_ypdetailDataStore',{
		model	: 's_bcm105ukrv_ypModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		
		proxy	: directProxy,
		
		loadStoreRecords : function()	{
			var param		= inputForm.getValues();
			
			console.log( param );
			this.load({
				params : param
			});
		},

		// 수정/추가/삭제된 내용 DB에 적용 하기 
		saveStore : function(config)	{			 
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();				
			var toDelete = this.getRemovedRecords();
			
//			var list = [].concat(toUpdate, toCreate);

			//insert, update일 경우, detailDataStore에 데이터가 하나라도 있어야 함
			if (Ext.isEmpty(toDelete) && detailDataStore.getCount() == 0) {
				alert('교육대상 정보를 입력하세요.');
				return false;
			}

			var paramMaster = inputForm.getValues();
			
			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success : function(batch, option) {
						detailDataStore.loadStoreRecords();
					},
					failure: function(batch, option) {
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_bcm105ukrv_ypdetailDataGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(detailDataStore.getCount() != 0) {
					inputForm.getField('EDU_TITLE').setReadOnly(true);
					inputForm.getField('EDU_FR_DATE').setReadOnly(true);
					inputForm.getField('EDU_TO_DATE').setReadOnly(true);
					UniAppManager.setToolbarButtons('deleteAll', true);
					
				} else {
					inputForm.clearForm();
//					inputForm.disable();
					inputForm.getField('EDU_TITLE').setReadOnly(false);
					inputForm.getField('EDU_FR_DATE').setReadOnly(false);
					inputForm.getField('EDU_TO_DATE').setReadOnly(false);
					UniAppManager.setToolbarButtons('deleteAll', false);
				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
//				inputForm.setActiveRecord(record);
			},
			metachange:function( store, meta, eOpts ){
			}
		} // listeners
	});	

	var eduStore = Unilite.createStore('eduStore', {	// 검색 팝업창
		model	: 'eduModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 's_bcm105ukrv_ypService.selectList2'
			}
		},
		loadStoreRecords: function() {
			var param		= eduSearch.getValues();
			
			console.log(param);
			this.load({
				params : param
			});
		}
	});



	/** detailDataGrid 정의(Grid Panel)
	 * @type 
	 */
	var detailDataGrid = Unilite.createGrid('s_bcm105ukrv_ypdetailDataGrid', {
		store	: detailDataStore,
		region	: 'east',
		uniOpt	:{
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: false,
			useMultipleSorting	: true
		},
		border:true,
		dockedItems	: [{			
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [/*{
				xtype	: 'uniBaseButton',
				text	: '추가',
				tooltip	: '추가',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_newData',
		 		id		: 'sub_newData',
		 		disabled: true,
				handler	: function() {}
			},{
				xtype	: 'uniBaseButton',
				text	: '삭제',
				tooltip	: '삭제',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26, 
				height	: 26,
		 		itemId	: 'sub_delete',
				handler	: function() { 
					var selRow = detailDataGrid.getSelectedRecord();
					if(selRow.phantom === true)	{
						detailDataGrid.deleteSelectedRow();
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						detailDataGrid.deleteSelectedRow();						
					}	
				}				
			}*/]
		}],
		columns:[
				{dataIndex:'DOC_ID'				,width:100		, hidden:true},
				{dataIndex:'COMP_CODE'			,width:100		, hidden:true},
				{dataIndex:'EDU_TITLE'			,width:100		, hidden:true},
				{dataIndex:'EDU_FR_DATE'		,width:100		, hidden:true},
				{dataIndex:'EDU_TO_DATE'		,width:100		, hidden:true},
				{dataIndex:'CUSTOM_CODE'		,width:130		,
					'editor': Unilite.popup('AGENT_CUST_MULTI_G',{
						textFieldName	: 'CUSTOM_CODE',
						DBtextFieldName	: 'CUSTOM_CODE',
						allowBlank		: false,
						listeners		: { 
							'onSelected': {
								fn: function(records, type  ){
									Ext.each(records, function(record,i) {
										console.log('record',record);
										if(i==0) {
											detailDataGrid.setItemData(record,false);
										} else {
											UniAppManager.app.onNewDataButtonDown();
											detailDataGrid.setItemData(record,false);
										}
									}); 
								},
								scope: this
							},
							'onClear' : function(type)	{
								var grdRecord = detailDataGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE'		,'');
								grdRecord.set('CUSTOM_NAME'		,'');
								grdRecord.set('DELIVERY_UNION'	,'');
							},
							'applyextparam': function(popup){
//								popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
//								popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
							}
						}
					})
				},
				{dataIndex:'CUSTOM_NAME'		,width:150		,
					'editor': Unilite.popup('AGENT_CUST_MULTI_G',{
						allowBlank		: false,
						listeners		: {
							'onSelected': {
								fn: function(records, type  ){
									Ext.each(records, function(record,i) {
										console.log('record',record);
										if(i==0) {
											detailDataGrid.setItemData(record, false);
										} else {
											UniAppManager.app.onNewDataButtonDown();
											detailDataGrid.setItemData(record, false);
										}
									}); 
								},
								scope: this
							},
							'onClear' : function(type)	{
								var grdRecord = detailDataGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE'		,'');
								grdRecord.set('CUSTOM_NAME'		,'');
								grdRecord.set('DELIVERY_UNION'	,'');
							},
							'applyextparam': function(popup){
//								popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
//								popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
							}
						}
					})
				},
				{dataIndex:'EDU_CONTENTS'		,width:100		, hidden:true},
				{dataIndex:'EDU_PLACE'			,width:100		, hidden:true},
				{dataIndex:'EDU_OBJECT'			,width:100		, hidden:true},
				{dataIndex:'EDU_TEACHER'		,width:100		, hidden:true},
				{dataIndex:'EDU_GUBUN'			,width:100		, hidden:true},
				{dataIndex:'EDU_ORGAN'			,width:100		, hidden:true},
				{dataIndex:'DELIVERY_UNION'		,width:130	},
				{dataIndex:'REMARK'				,flex: 1	, minWidth:130}
			], 
			listeners: {				
				beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME'])){
						return false;
					}
				}
				if (UniUtils.indexOf(e.field, ['DELIVERY_UNION'])){
						return false;
					}
				},
				selectionchangerecord:function(selected)	{
				},
				onGridDblClick:function(grid, record, cellIndex, colName) {
				},
				hide:function()	{
				}, 
				edit: function(editor, e) {
				}
			},
			setItemData: function(record, dataClear) {
				var grdRecord = this.getSelectedRecord();
				if(dataClear) {
				} else {
					grdRecord.set('CUSTOM_CODE'		,record['CUSTOM_CODE']);
					grdRecord.set('CUSTOM_NAME'		,record['CUSTOM_NAME']);
					grdRecord.set('DELIVERY_UNION'	,record['DELIVERY_UNION']);
				}
			} 
	});
	
	var eduGrid = Unilite.createGrid('spp100ukrveduGrid', { // 검색팝업창
		layout	: 'fit',	   
		store	: eduStore,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true
		},
		columns:  [
			{dataIndex:'DOC_ID'				,width:100	, hidden:true},
			{dataIndex:'COMP_CODE'			,width:100	, hidden:true},
			{dataIndex:'EDU_TITLE'			,width:220},
			{dataIndex:'EDU_FR_DATE'		,width:90},
			{dataIndex:'EDU_TO_DATE'		,width:90},
			{dataIndex:'CUSTOM_CODE'		,width:130	, hidden:true},
			{dataIndex:'CUSTOM_NAME'		,width:150	, hidden:true},
			{dataIndex:'EDU_CONTENTS'		,width:200},
			{dataIndex:'EDU_PLACE'			,width:120},
			{dataIndex:'EDU_OBJECT'			,width:120},
			{dataIndex:'EDU_TEACHER'		,width:120},
			{dataIndex:'EDU_GUBUN'			,width:100	, hidden:true},
			{dataIndex:'EDU_ORGAN'			,width:100	, hidden:true},
			{dataIndex:'DELIVERY_UNION'		,width:130	, hidden:true},
			{dataIndex:'REMARK'				,width:130	, hidden:true}
		],
		listeners: {				
			beforeedit: function( editor, e, eOpts ) {
			},	
			onGridDblClick:function(grid, record, cellIndex, colName) {
//				inputForm.enable();
				inputForm.setValue('EDU_TITLE'		, record.data['EDU_TITLE']);
				inputForm.setValue('EDU_FR_DATE'	, record.data['EDU_FR_DATE']);
				inputForm.setValue('EDU_TO_DATE'	, record.data['EDU_TO_DATE']);
				inputForm.setValue('EDU_OBJECT'		, record.data['EDU_OBJECT']);
				inputForm.setValue('EDU_TEACHER'	, record.data['EDU_TEACHER']);
				inputForm.setValue('EDU_CONTENTS'	, record.data['EDU_CONTENTS']);
				inputForm.setValue('EDU_PLACE'		, record.data['EDU_PLACE']);
				inputForm.setValue('EDU_GUBUN'		, record.data['EDU_GUBUN']);
				inputForm.setValue('EDU_ORGAN'		, record.data['EDU_ORGAN']);
				detailDataStore.loadStoreRecords();
				
				SearchInfoWindow.hide(); 
			}
		}
	});
	
	
	
	/** MAIN DATA 입력
	* @type 
	*/
	var inputForm = Unilite.createForm('inputForm', {
		region		: 'center',
		border		: true,
		autoScroll	: true,  
		disabled	: false,
		padding		: '0 0 0 1',	 
		defaults	: { labelWidth: 120},
		flex		: 1,
		minWidth	: 400,
		uniOpt		:{
//			store : detailDataStore
		},
		layout		: {type: 'uniTable', columns: 1, tableAttrs:{ cellpadding:5 }, tdAttrs: {valign:'top'}},
		defaultType	: 'uniTextfield',
		defineEvent	: function(){
//			var me = this;			
//			me.getField('CUSTOM_NAME').on ('blur', function( field, blurEvent, eOpts )	{
//				if(me.getValue('CUSTOM_FULL_NAME') == "")	
//					me.setValue('CUSTOM_FULL_NAME',this.getValue());
//			});
		},
		items : [{
				xtype	: 'component',
				height	: 13
			},{
				fieldLabel	: '교육명',
				name		: 'EDU_TITLE',
				width		: 345,
				allowBlank	: false
			},{
				fieldLabel		: '교육일자',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'EDU_FR_DATE',
				endFieldName	: 'EDU_TO_DATE',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					UniAppManager.setToolbarButtons(['save'],true);
//					inputForm.setValue('inputForm', newValue)
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					UniAppManager.setToolbarButtons(['save'],true);
				}
			},{
				fieldLabel	: '교육장소',
				name		: 'EDU_PLACE',
				width		: 345
			},{
				fieldLabel	: '교육대상',
				name		: 'EDU_OBJECT',
				width		: 345
			},{
				fieldLabel	: '교육강사',
				name		: 'EDU_TEACHER',
				width		: 345
			},{
				fieldLabel	: '교육내용'	,
				name		: 'EDU_CONTENTS', 
				xtype		: 'textareafield',
				width		: 345,
				height		: 150,
//				width		: '97.5%',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.setToolbarButtons(['save'],true);
					}
				}
			},{
				fieldLabel	: '교육구분',
				name		: 'EDU_GUBUN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z005',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if (detailDataStore.getCount() != 0) {
							var records = detailDataStore.data.items;
							Ext.each(records, function(detailrecord, i)	{
								detailrecord.set('EDU_GUBUN', newValue);
							});  
						}
					}
				}
			},{
				fieldLabel	: '교육기관',
				name		: 'EDU_ORGAN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z004',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if (detailDataStore.getCount() != 0) {
							var records = detailDataStore.data.items;
							Ext.each(records, function(detailrecord, i)	{
								detailrecord.set('EDU_ORGAN', newValue);
							});  
						}
					},
					specialkey:function(field, e){
						if (e.getKey() == e.ENTER) {
							UniAppManager.app.onNewDataButtonDown();
						}
					}
				}
			}
		]
	}); // inputForm

	var eduSearch = Unilite.createSearchForm('eduSearchForm', {	 // 검색 팝업창
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
				fieldLabel	: '교육명',
				name		: 'EDU_TITLE',
				width		: 315,
				tdAttrs		: {width: 380}
			},{
				fieldLabel		: '교육일자',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'EDU_FR_DATE',
				endFieldName	: 'EDU_TO_DATE',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			},{
				fieldLabel	: '교육대상',
				name		: 'EDU_OBJECT',
				width		: 315
			},{
				fieldLabel	: '교육내용'	,
				name		: 'EDU_CONTENTS', 
				xtype		: 'uniTextfield',
				width		: 315,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}
		]
	}); // createSearchForm
	
	
	
	
	
	Unilite.Main({
		id		: 's_bcm105ukrv_ypApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				
				{
					region		: 'west',
					xtype		: 'container',
					flex		: 1,
					minWidth	: 400,
					layout		: {type:'vbox', align:'stretch'},
					items		: [
						inputForm
					]
				},
				{
					region		: 'center',
					xtype		: 'container',
					flex		: 3,
					layout		: {type:'vbox', align:'stretch'},
					items		: [
						detailDataGrid
					]
				}
			]
		}],		
		fnInitBinding : function(params) {
			//초기화 시, 포커스 설정
//			inputForm.onLoadSelectText('EDU_TITLE');

			UniAppManager.setToolbarButtons(['reset','newData'], true);			
		},
		
		onQueryButtonDown : function()	{
			openSearchInfoWindow();
		},
		
		onResetButtonDown:function() {
			inputForm.clearForm();
//			inputForm.disable();
			detailDataGrid.getStore().loadData({});
			inputForm.getField('EDU_TITLE').setReadOnly(false);
			inputForm.getField('EDU_FR_DATE').setReadOnly(false);
			inputForm.getField('EDU_TO_DATE').setReadOnly(false);
			
			//reset 시, 포커스 설정
			inputForm.getField('EDU_TITLE').focus();
//			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		},

		onNewDataButtonDown : function()	{
			/*if (inputForm.disabled) {
				inputForm.enable();
				
			} else */{
				if (!inputForm.getInvalidMessage()) { 
					return false;
				}
				
				var eduTitle		= Ext.isEmpty(inputForm.getValue('EDU_TITLE'))		?	'' : inputForm.getValue('EDU_TITLE');
				var eduFrDate		= Ext.isEmpty(inputForm.getValue('EDU_FR_DATE'))	?	'' : inputForm.getValue('EDU_FR_DATE');
				var eduToDate		= Ext.isEmpty(inputForm.getValue('EDU_TO_DATE'))	?	'' : inputForm.getValue('EDU_TO_DATE');
				var eduContents		= Ext.isEmpty(inputForm.getValue('EDU_CONTENTS'))	?	'' : inputForm.getValue('EDU_CONTENTS');
				var eduPlace		= Ext.isEmpty(inputForm.getValue('EDU_PLACE'))		?	'' : inputForm.getValue('EDU_PLACE');
				var eduObject		= Ext.isEmpty(inputForm.getValue('EDU_OBJECT'))		?	'' : inputForm.getValue('EDU_OBJECT');
				var eduTeacher		= Ext.isEmpty(inputForm.getValue('EDU_TEACHER'))	?	'' : inputForm.getValue('EDU_TEACHER');
				var eduGubun		= Ext.isEmpty(inputForm.getValue('EDU_GUBUN'))		?	'' : inputForm.getValue('EDU_GUBUN');
				var eduOrgan		= Ext.isEmpty(inputForm.getValue('EDU_ORGAN'))		?	'' : inputForm.getValue('EDU_ORGAN');	
				
				var r = {
					COMP_CODE			:	UserInfo.compCode,
					EDU_TITLE			:	eduTitle,
					EDU_FR_DATE			:	eduFrDate,
					EDU_TO_DATE			:	eduToDate,
					EDU_CONTENTS		:	eduContents,
					EDU_PLACE			:	eduPlace,
					EDU_OBJECT			:	eduObject,
					EDU_TEACHER			:	eduTeacher,
					EDU_GUBUN			:	eduGubun,
					EDU_ORGAN			:	eduOrgan
				};
				detailDataGrid.createRow(r, null, detailDataStore.getCount() - 1);
			}
		},

		onPrevDataButtonDown:function()	{
//			detailDataGrid.selectPriorRow();
		},
		
		onNextDataButtonDown:function()	{
//			detailDataGrid.selectNextRow();
		},	
		
		onSaveDataButtonDown: function () {
			//필수 입력값 체크
			if (!inputForm.getInvalidMessage()) { 
				return false;
			}
			detailDataStore.saveStore();	
		},
		
		onDeleteDataButtonDown : function()	{
			var selRow = detailDataGrid.getSelectedRecord();					
			if(selRow.phantom == true)	{				
				detailDataGrid.deleteSelectedRow();				
								
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				detailDataGrid.deleteSelectedRow();			
			}					
		},													
													
		onDeleteAllButtonDown: function() {
			var records = detailDataStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;

				} else {								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm(Msg.sMB064)) {			//'전체삭제 하시겠습니까?'
						var deletable = true;
						if(deletable){
							detailDataGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
						isNewData = false;
					}
					return false;
				}
			});

			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				detailDataGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}

			UniAppManager.setToolbarButtons('deleteAll', false);
		}
	});	// Main
	
	
	
	function openSearchInfoWindow() {   //검색팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '거래처교육 조회',
				width	: 800,							 
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},				 
				items	: [eduSearch, eduGrid], 
				tbar	: [
					'->',{
						itemId	: 'queryBtn',
						text	: '조회',
						handler	: function() {
							eduStore.loadStoreRecords();
						},
						disabled: false
					},{
						xtype: 'tbspacer'	
					},{
						xtype: 'tbseparator'	
					},{
						xtype: 'tbspacer'	
					},{
						itemId	: 'OrderNoCloseBtn',
						text	: '닫기',
						handler	: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners: {
					beforehide: function(me, eOpt) {
						eduSearch.clearForm();
						eduGrid.reset();											  
					},
					beforeclose: function( panel, eOpts ) {
						eduSearch.clearForm();
						eduGrid.reset();
					},
					beforeshow: function( panel, eOpts )	{
//						eduSearch.setValue('EDU_FR_DATE'	, UniDate.get('startOfMonth'));
//						eduSearch.setValue('EDU_TO_DATE'	, UniDate.get('today'));
					}
				}	   
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}



	Unilite.createValidator('validator01', {
		forms	: { 'formA:': inputForm },
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
				if (detailDataStore.getCount() != 0) {
					var records = detailDataStore.data.items;
					Ext.each(records, function(detailrecord, i)	{				
						detailrecord.set(fieldName, newValue);
					});  
				}
			return rv;
		}
	}); // validator

}; // main
</script>


