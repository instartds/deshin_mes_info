<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_hum991ukr_sdc">
	<t:ExtComboStore comboType="BOR120" pgmId="s_hpa340ukr_sdc" />		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" />					<!-- 직책코드 -->
	<t:ExtComboStore comboType="AU" comboCode="H008" />					<!-- 담당업무 -->
</t:appConfig>

<style type="text/css">
    .x-grid-colored-cell  {background-color:#FFCCCC;}
    .x-grid-colored-cell2 {background-color:#FFFF33;}
</style>

<script type="text/javascript" >
var histWin;

function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hum991ukr_sdcModel', {
		fields: [
			{name: 'COMP_CODE'		,text:'<t:message code="system.label.human.compcode"	default="법인코드"/>'	,type:'string'},
			{name: 'BASE_YYYYMM'	,text:'<t:message code="system.label.human.basisdate"	default="기준일"/>'	,type:'string'},
			{name: 'DEPT_CODE'		,text:'<t:message code="system.label.human.deptcode"	default="부서코드"/>'	,type:'string'},
			{name: 'DEPT_NAME'		,text:'<t:message code="system.label.human.deptname"	default="부서명"/>'	,type:'string'},
			{name: 'ABIL_CODE'		,text:'<t:message code="system.label.human.abil"		default="직책"/>'		,type:'string'	,comboType:'AU'	,comboCode:'H006'},
			{name: 'KNOC'			,text:'<t:message code="system.label.human.ocpt"		default="직종"/>'		,type:'string'	,comboType:'AU'	,comboCode:'H008'},
			{name: 'TLB_OF_ORG'		,text:'<t:message code=""								default="정원"/>'		,type:'uniPrice'},
			{name: 'CUR_OF_ORG'		,text:'<t:message code=""								default="현원"/>'		,type:'uniPrice'},
			{name: 'IF_OVER'		,text:'<t:message code=""								default="과부족"/>'	,type:'uniPrice'},
			{name: 'RMK'			,text:'<t:message code="system.label.human.remark"		default="비고"/>'		,type:'string'}
		]
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
			fieldLabel		: '<t:message code="system.label.human.basisdate" default="기준일"/>', 
			xtype			: 'uniDatefield',
			name 			: 'BASE_YYYYMM',
			allowBlank		: false,
			holdable		: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('BASE_YYYYMM', newValue);
				}
			}
		},{
			xtype			: 'button',
			text			: '이력',
			width			: 200,
			tdAttrs			: {'align':'center', style:'padding-left:50px;'},
			holdable		: 'hold',
			handler:function(){
				UniAppManager.app.fnOpenHistoryPopup();
			}
		}],
		setAllFieldsReadOnly: function(b) { 
			var r = true;
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
				}
				return false;
			}
			
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) ) {
					if (item.holdable == 'hold') {
						item.setReadOnly(b); 
					}
				} 
				if(item.isPopupField) {
					var popupFC = item.up('uniPopupField') ;       
					if(popupFC.holdable == 'hold') {
						popupFC.setReadOnly(true);
					}
				}
			});
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2,
				   tdAttrds : {style:'vertical-align: top;'}
				  },
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel		: '<t:message code="system.label.human.basisdate" default="기준일"/>', 
			xtype			: 'uniDatefield',
			name 			: 'BASE_YYYYMM',
			allowBlank		: false,
			holdable		: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASE_YYYYMM', newValue);
				}
			}
		},{
			xtype			: 'button',
			text			: '이력',
			width			: 120,
			tdAttrs			: {'align':'center', style:'vertical-align: top;padding-left:20px;'},
			holdable		: 'hold',
			handler:function(){
				UniAppManager.app.fnOpenHistoryPopup();
			}
		}],
		setAllFieldsReadOnly: function(b) { 
			var r = true;
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
				}
				return false;
			}
			
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) ) {
					if (item.holdable == 'hold') {
						item.setReadOnly(b); 
					}
				} 
				if(item.isPopupField) {
					var popupFC = item.up('uniPopupField') ;       
					if(popupFC.holdable == 'hold') {
						popupFC.setReadOnly(true);
					}
				}
			});
			return r;
		}
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('s_hum991ukr_sdcMasterStore',{
		model: 's_hum991ukr_sdcModel',
		autoLoad: false,
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: true,		// 수정 모드 사용
			deletable:true,		// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'uniDirect',
			api: {
				read   : 's_hum991ukr_sdcService.selectList',
				create : 's_hum991ukr_sdcService.insert',
				update : 's_hum991ukr_sdcService.update',
				destroy: 's_hum991ukr_sdcService.delete',
				syncAll: 's_hum991ukr_sdcService.syncAll'
			}
		},
		loadStoreRecords : function()	{
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				var config = {
					//params:[panelResult.getValues()],
					success : function() {
						directMasterStore.loadStoreRecords();
					}
				}
				this.syncAllDirect(config);			
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store) {
				UniAppManager.setToolbarButtons(['newData'], true);
			}
		}
	});
	
	/**
	 * Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_hum991ukr_sdcMasterGrid', {
		region: 'center',
		layout: 'fit',
		uniOpt: {
			expandLastColumn: true,
			useRowNumberer: true,
			useMultipleSorting: true,
			importData :{	// 엑셀에서 복사한 내용 붙여넣기 설정	
				useData :true, 
				configId: "s_hum991ukr_sdcG1",
				createOption: "customFn",
				columns:['DEPT_CODE', 'DEPT_NAME', 'ABIL_CODE', 'KNOC', 'TLB_OF_ORG', 'RMK']
			}
		},
		selModel: 'rowmodel',
		store: directMasterStore,
		columns: [
			{dataIndex: 'COMP_CODE'		, width:  60	, hidden: true},
			{dataIndex: 'BASE_YYYYMM'	, width: 100	, hidden: true},
			{dataIndex: 'DEPT_CODE'		, width: 100	,
				editor:Unilite.popup('DEPT_G',{
					textFieldName	: 'DEPT_CODE',
					DBtextFieldName	: 'TREE_CODE',
					validateBlank	: false,
					autoPopup		: true,
					listeners		: {
						scope:this,
						onSelected:{
							fn:function(records, type) {
								var record = records[0];
								var grdRecord = masterGrid.uniOpt.currentRecord;
								
								grdRecord.set('DEPT_CODE', record.TREE_CODE);
								grdRecord.set('DEPT_NAME', record.TREE_NAME);
							}
						},
						onClear:function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							
							grdRecord.set('DEPT_CODE', '');
							grdRecord.set('DEPT_NAME', '');
						}
					}
				}),
				renderer: function(value, meta, record) {
					if(value != '' && record.get('DEPT_NAME') == '') {
						meta.tdCls = 'x-grid-colored-cell';
					}
					return value;
				}
			},
			{dataIndex: 'DEPT_NAME'		, width: 200	, editable: false,
				renderer: function(value, meta, record) {
					if(value == '' && record.get('DEPT_CODE') != '') {
						meta.tdCls = 'x-grid-colored-cell';
					}
					return value;
				}
			},
			{dataIndex: 'ABIL_CODE'		, width: 100},
			{dataIndex: 'KNOC'			, width: 100},
			{dataIndex: 'TLB_OF_ORG'	, width: 100,
				renderer: function(value, meta, record) {
					meta.tdCls = 'x-grid-colored-cell2';
					return Ext.util.Format.number(value, UniFormat.Price);
				}
			},
			{dataIndex: 'CUR_OF_ORG'	, width: 100	, editable: false},
			{dataIndex: 'IF_OVER'		, width: 100	, editable: false},
			{dataIndex: 'RMK'			, width: 100	, hidden: true}
		],
		//엑셀 붙여넣기
		loadImportData:function(copiedRows) {
			var tranCnt = 0;
			var inTran = true;
			
			var me = this;
			var compCode = UserInfo.compCode;
			var baseYM = panelSearch.getValues().BASE_YYYYMM;
			var cnt = me.store.count();
			
			masterGrid.mask('붙여넣기 작업중입니다.');
			
			Ext.each(copiedRows, function(record, idx){
				tranCnt++;
				
				var r = {
					 'COMP_CODE' 		: compCode
					,'BASE_YYYYMM' 		: baseYM
					,'DEPT_CODE' 		: record.DEPT_CODE
					,'ABIL_CODE'		: record.ABIL_CODE
					,'KNOC' 			: record.KNOC
					,'TLB_OF_ORG' 		: record.TLB_OF_ORG
					,'CUR_OF_ORG' 		: 0
					,'IF_OVER'		 	: 0
					,'RMK'		 		: record.RMK
				}
				//me.createRow(r, null, cnt+idx );
				var newRow = me.createRow(r, null, cnt+idx );
				
				var param = {
					TXT_SEARCH	: record.DEPT_CODE
				};
				
				popupService.deptPopup(param, function(provider, response) {
					if(provider && provider.length > 0) {
						var deptInfo = provider[0];
						
						if(deptInfo.TREE_CODE == record.DEPT_CODE) {
							newRow.set('DEPT_NAME', provider[0].TREE_NAME);
						}
						else {
							newRow.set('DEPT_NAME', '');
						}
					}
					else {
						newRow.set('DEPT_NAME', '');
					}
					tranCnt--;
					
					if(tranCnt == 0 && !inTran) {
						masterGrid.unmask();
					}
				});
			});
			
			inTran = false;
		}
	});
	
	Unilite.Main({
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
		id  : 's_hum991ukr_sdcApp',
		fnInitBinding : function() {
			panelSearch.setValue('BASE_YYYYMM', UniDate.get('today'));
			panelResult.setValue('BASE_YYYYMM', UniDate.get('today'));
			
			tranCnt = 0;
			
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.getInvalidMessage()){
				return false;
			}
			
			panelResult.setAllFieldsReadOnly(true);
			panelSearch.setAllFieldsReadOnly(true);
			
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown : function()	{
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.setAllFieldsReadOnly(false);
			
			panelResult.clearForm();
			panelSearch.clearForm();
			
			panelSearch.setValue('BASE_YYYYMM', UniDate.get('today'));
			panelResult.setValue('BASE_YYYYMM', UniDate.get('today'));
			
			Ext.getCmp('s_hum991ukr_sdcMasterGrid').reset();
			
			UniAppManager.setToolbarButtons(['newData', 'delete', 'save'], false);
		},
		onNewDataButtonDown : function() {
			if(!panelSearch.getInvalidMessage()){
				return false;
			}
			
			var record = {
				COMP_CODE		: UserInfo.compCode,
				BASE_YYYYMM		: UniDate.getDbDateStr(panelSearch.getValue('BASE_YYYYMM')),
				DEPT_CODE		: '',
				ABIL_CODE		: '',
				KNOC			: '',
				TLB_OF_ORG		: 0,
				CUR_OF_ORG		: 0,
				IF_OVER			: 0,
				RMK				: ''
			};
			masterGrid.createRow(record, null);
		},
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow && selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			}
			else {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow();
				}
			}
		},
		onSaveDataButtonDown : function() {
			directMasterStore.saveStore();
		},
		selectCurPersonCnt : function(record) {
			var param = {
				BASE_YYYYMM	: UniDate.getDbDateStr(panelSearch.getValue('BASE_YYYYMM')),
				DEPT_CODE	: record.get('DEPT_CODE'),
				ABIL_CODE	: record.get('ABIL_CODE'),
				KNOC		: record.get('KNOC')
			};
			
			s_hum991ukr_sdcService.selectCurPersonCnt(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					//record.set('CUR_OF_ORG', provider.CUR_PERSON_CNT);
				}
			});
		},
		fnOpenHistoryPopup : function() {
			if(!panelSearch.isValid()) {
				return;
			}
			var paramData = {
				BASE_YYYY : UniDate.getDbDateStr(panelSearch.getValue('BASE_YYYYMM'))
			};
			
			if(!histWin) {
				Unilite.defineModel('s_hum991ukr_sdcHistModel', {
					fields: [
						{name: 'COMP_CODE'		, text: '<t:message code="system.label.human.compcode"	default="법인코드"/>'		, type: 'string'},
						{name: 'BASE_YYYYMM'	, text: '<t:message code="system.label.human.basisdate"	default="기준일"/>'		, type: 'uniDate'}
					]
				});
				
				var histStore = Unilite.createStore('s_hum991ukr_sdcHistStore', {
					model: 's_hum991ukr_sdcHistModel',
					uniOpt: {
						isMaster  : false,	// 상위 버튼 연결
						editable  : false,	// 수정 모드 사용
						deletable : false,	// 삭제 가능 여부
						useNavi   : false	// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 's_hum991ukr_sdcService.selectHistList'
						}
					},
					loadStoreRecords: function(){
						var param = histWin.paramData;
						console.log( param );
						this.load({
							params: param
						});
					}
				});
				
				histWin = Ext.create('widget.uniDetailWindow', {
					title : '정원/현원 관리 이력',
					width : 400,
					height: 600,
					layout: {type:'vbox', align:'stretch'},
					items : [{
						xtype : 'container',
						flex  : 1,
						layout: {type:'vbox', align:'stretch'},
						items : [
							Unilite.createGrid('s_hum991ukr_sdcHistGrid', {
								layout: 'fit',
								store : histStore,
								uniOpt: {
									expandLastColumn: false,	//마지막 컬럼 * 사용 여부
									useRowNumberer	: false,	//첫번째 컬럼 순번 사용 여부
									useLiveSearch	: false,	//찾기 버튼 사용 여부
									filter: {					//필터 사용 여부
										useFilter	: false,
										autoCreate	: false
									},
									state : {
										useState	: false,	//그리드 설정 버튼 사용 여부
										useStateList: false		//그리드 설정 목록 사용 여부
									}
								},
								columns: [
									{dataIndex: 'COMP_CODE'		, width: 100	, hidden: true},
									{dataIndex: 'BASE_YYYYMM'	, width: 200	, align: 'center'}
								],
								listeners:{
									onGridDblClick:function(grid, record, cellIndex, colName) {
										var rv = record.get('BASE_YYYYMM');
										panelSearch.setValue('BASE_YYYYMM', rv);
										panelResult.setValue('BASE_YYYYMM', rv);
										
										histWin.hide();
									}
								}
							})
						]
					}],
					bbar:{
						layout: {
							pack: 'center',
							type: 'hbox'
						},
						dock  :'bottom',
						items : [{
							itemId : 'btnOk',
							text: '확인',
							width:100,
							handler: function() {
								var record = Ext.getCmp('s_hum991ukr_sdcHistGrid').getSelectedRecord();
								var rv = record.get('BASE_YYYYMM');
								panelSearch.setValue('BASE_YYYYMM', rv);
								panelResult.setValue('BASE_YYYYMM', rv);
								
								histWin.hide();
							},
							disabled: false
						},{
							itemId : 'btnCancel',
							text: '닫기',
							width:100,
							handler: function() {
								histWin.hide();
							},
							disabled: false
						}]
					},
					listeners : {
						beforehide: function(me, eOpt) {
                        },
						beforeclose: function( panel, eOpts ) {
						},
						beforeshow: function( panel, eOpts ) {
							histStore.loadStoreRecords();
						}
					}
				});
			}
			
			histWin.paramData = paramData;
			histWin.changes = false;
			histWin.center();
			histWin.show();
		}
	});
		
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {
				
				case "DEPT_CODE" :	// 부서코드
				case "ABIL_CODE" :	// 직책
				case "KNOC" :		// 직종
					var deptCode = record.get('DEPT_CODE');
					var abilCode = record.get('ABIL_CODE');
					var knoc	 = record.get('KNOC');
					
					if(fieldName == "DEPT_CODE") {
						deptCode = newValue;
					}
					else if(fieldName == "ABIL_CODE") {
						abilCode = newValue;
					}
					else if(fieldName == "KNOC") {
						knoc = newValue;
					}
					
					if(Ext.isEmpty(deptCode) || Ext.isEmpty(abilCode) || Ext.isEmpty(knoc)) {
						record.set('CUR_OF_ORG'	, 0);
						record.set('IF_OVER'	, 0);
					}
					else {
						record.set(fieldName, newValue);
						UniAppManager.app.selectCurPersonCnt(record);
					}
					break;
				
				case "TLB_OF_ORG" :
					var tlbOfOrg = newValue;
					var curOfOrg = record.get('CUR_OF_ORG');
					
					record.set('IF_OVER'	, tlbOfOrg - curOfOrg);
			}
			return rv;
		}
		
	});
};
</script>