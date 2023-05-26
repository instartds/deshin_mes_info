<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp170ukrv_sh"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="P001"  /> 		<!-- 진행상태 -->  
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->

</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>



<script type="text/javascript" >

var BsaCodeInfo = {
	gsCoreUse		: '${gsCoreUse}'		// 코어사용여부
};
function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_pmp170ukrv_shService.selectList',
			create	: 's_pmp170ukrv_shService.insertDetail',
			update	: 's_pmp170ukrv_shService.updateDetail',
			destroy	: 's_pmp170ukrv_shService.deleteDetail',
			syncAll	: 's_pmp170ukrv_shService.saveAll'
		}
	});



	Unilite.defineModel('detailModel', {
		fields: [			
			{name: 'DIV_CODE'		, text: 'DIV_CODE'				, type: 'string'},
//			{name: 'WORK_END_YN'		, text: '<t:message code="system.label.product.status" default="상태"/>'				, type: 'string' , comboType:'AU', comboCode:'P001'},
			{name: 'STATUS_CODE'     		,text: '<t:message code="system.label.product.statuscode" default="상태코드"/>'			,type:'string' , comboType: 'AU', comboCode: 'P001'},
		
			
			{name: 'PROG_WORK_CODE'		, text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		, type: 'string'},
			{name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'string'},
			
			{name: 'SOF_CUSTOM_NAME'	,text: '수주처명'			,type:'string'},
			{name: 'SOF_ITEM_NAME'		,text: '수주제품명'			,type:'string'},
			
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'ITEM_NAME1'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>1'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	, type: 'uniDate'},
			{name: 'PRODT_END_DATE'		, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	, type: 'uniDate'},
			{name: 'EQUIP_CODE'			,text: '<t:message code="system.label.product.facilities" default="설비"/>'				,type:'string'},
			{name: 'EQUIP_NAME'			,text: '<t:message code="system.label.product.facilitiesname" default="설비명"/>'			,type:'string'},
			{name: 'MOLD_CODE'			,text: '<t:message code="system.label.product.moldcode" default="금형코드"/>'				,type:'string'},
			{name: 'MOLD_NAME'			,text: '<t:message code="system.label.product.moldname" default="금형명"/>'				,type:'string'},
	
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		, type: 'uniQty'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'REMARK1'			, text: '<t:message code="system.label.product.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'				, type: 'uniQty'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'REMARK2'			, text: '<t:message code="system.label.product.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_NAME'		, text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	, type: 'string'},
			
			{name: 'OUT_ORDER_YN'    		,text: '<t:message code="system.label.product.subcontractyn" default="외주여부"/>'			,type:'string' , comboType: 'AU', comboCode: 'P113'}

			
		]
	});	

	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: directProxy,
		autoLoad: false,
		uniOpt: {
			isMaster	: true,	// 상위 버튼 연결 
			editable	: true,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false	// prev | next 버튼 사용
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
						
						
						detailStore.clearData();
						
						detailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
				
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		},
		groupField:'EQUIP_NAME'
		
	});



	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns :3},
//			tableAttrs: {width: '100%'}
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
//		},
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name: 'DIV_CODE',
			value : UserInfo.divCode,
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE','');
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_START_DATE_FR',
			endFieldName: 'PRODT_START_DATE_TO',
			width: 315,
			startDate: UniDate.get('aMonthAgo'),
			endDate: UniDate.get('todayForMonth'),
			allowBlank: false
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:285,
			items :[{
				fieldLabel:'수주번호', 
				xtype: 'uniTextfield',
				name: 'ORDER_NUM_FR',
				width:175
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniTextfield',
				name: 'ORDER_NUM_TO', 
				width: 85
			}]
		},
		{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'W',
			allowBlank:false,
			listeners: {
				beforequery:function( queryPlan, eOpts )   {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelSearch.getValue('DIV_CODE');
						});
					}else{
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
			validateBlank:true,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('EQU_MACH_CODE',{
			fieldLabel: '설비',
			valueFieldName:'EQU_MACH_CODE',
			textFieldName:'EQU_MACH_NAME',
			validateBlank:true,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('PROG_WORK_CODE',{ 
			fieldLabel: '<t:message code="system.label.product.routingcode" default="공정코드"/>', 
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
					popup.setExtParam({'WORK_SHOP_CODE' : panelSearch.getValue('WORK_SHOP_CODE')});
				}
			}
		}),{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:285,
			items :[{
				fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>', 
				xtype: 'uniTextfield',
				name: 'WKORD_NUM_FR',
				width:175
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniTextfield',
				name: 'WKORD_NUM_TO', 
				width: 85
			}]
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '<t:message code="system.label.product.status" default="상태"/>',
			items: [{
				boxLabel: '<t:message code="system.label.product.whole" default="전체"/>', 
				width: 70, 
				name: 'STATUS_CODE',
				inputValue: '',
				checked: true 
			},{
				boxLabel : '<t:message code="system.label.product.process" default="진행"/>', 
				width: 70,
				name: 'STATUS_CODE',
				inputValue: '2'
			},{
				boxLabel : '완료', 
				width: 70,
				name: 'STATUS_CODE',
				inputValue: '9'
			},{
				boxLabel: '<t:message code="system.label.product.closing" default="마감"/>', 
				width: 70, 
				name: 'STATUS_CODE',
				inputValue: '8'
			}]
			
//			,
//			listeners: {
//				change: function(field, newValue, oldValue, eOpts) {						
//					panelResult.getField('STATUS_CODE').setValue(newValue.STATUS_CODE);
//					
//					UniAppManager.app.onQueryButtonDown();
//				}
//			}
		}
		
		
		
		
/*		,{	
			xtype: 'radiogroup',							
			fieldLabel: '   ',											
			labelWidth:90,
			items: [{
				boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
				width: 60,
				name: 'WORK_END_YN',
				inputValue: '',
				checked: true
			},{
				boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
				width: 60,
				name: 'WORK_END_YN' ,
				inputValue: 'N'
			},{
				boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
				width: 60,
				name: 'WORK_END_YN' ,
				inputValue: 'Y'
			},{
				boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
				width: 60,
				name: 'WORK_END_YN' ,
				inputValue: 'F'
			}]
		}*/
		
		
		]
	});

	var detailGrid = Unilite.createGrid('detailGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
//			userToolbar:false,
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
        tbar: [{
			xtype: 'button',
			text: '상태변경',
			width: 200,
			handler: function() {
				var selectedRecords = detailGrid.getSelectedRecords();
				if(Ext.isEmpty(selectedRecords)){
					alert('선택된 데이터가 없습니다.');	
				}
				
				var records = detailGrid.getSelectedRecords();
                Ext.each(records, function(record,i) {
                    var param= {
                        'DIV_CODE': record.get('DIV_CODE'),
                        'WKORD_NUM': record.get('WKORD_NUM'),
                        'ITEM_CODE': record.get('ITEM_CODE'),
                        'STATUS_CODE': record.get('STATUS_CODE'),
                        'OUT_ORDER_YN': record.get('OUT_ORDER_YN'),
                        'PROC_TYPE': 'CLOSE'
                    }
                    s_pmp170ukrv_shService.updateStatus(param, function(provider, response) {
                    	UniAppManager.app.onQueryButtonDown();
                    });
                });
		
				
			}
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly : true,
			toggleOnClick:false,
			mode: 'SIMPLE'
		}),
		store: detailStore,
        features: [
            {id: 'detailGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: false },
            {id: 'detailGridTotal',        ftype: 'uniSummary',            showSummaryRow: false}
        ],
		columns: [
//			{dataIndex: 'WORK_END_YN'		, width: 40	},
											
			{dataIndex: 'STATUS_CODE'      		, width: 66 },
			{dataIndex: 'PROG_WORK_CODE'	, width: 70 , hidden: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
				}
			},
			{dataIndex: 'PROG_WORK_NAME'	, width: 80},
			{dataIndex: 'EQUIP_CODE'		, width: 110, tdCls:'x-change-cell',hidden: true,
				'editor' : Unilite.popup('EQU_MACH_CODE_G',{
					textFieldName:'EQU_MACH_NAME',
					DBtextFieldName: 'EQU_MACH_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('EQUIP_CODE',records[0]['EQU_MACH_CODE']);
								grdRecord.set('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							grdRecord = detailGrid.getSelectedRecord();
							grdRecord.set('EQUIP_CODE', '');
							grdRecord.set('EQUIP_NAME', '');
						},
						applyextparam: function(popup){
							var param = panelSearch.getValues();
							popup.setExtParam({'DIV_CODE': param.DIV_CODE});
						}
					}
				})
			},
			{dataIndex: 'EQUIP_NAME'		, width: 100, tdCls:'x-change-cell',
				'editor' : Unilite.popup('EQU_MACH_CODE_G',{
					textFieldName:'EQU_MACH_NAME',
					DBtextFieldName: 'EQU_MACH_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('EQUIP_CODE',records[0]['EQU_MACH_CODE']);
								grdRecord.set('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							grdRecord = detailGrid.getSelectedRecord();
							grdRecord.set('EQUIP_CODE', '');
							grdRecord.set('EQUIP_NAME', '');
						},
						applyextparam: function(popup){
							var param = panelSearch.getValues();
							popup.setExtParam({'DIV_CODE': param.DIV_CODE});
						}
					}
				})
			},
			{dataIndex: 'MOLD_CODE'			, width: 80, tdCls:'x-change-cell',id:'moldCodeCol',
				'editor' : Unilite.popup('EQU_MOLD_CODE_G',{
					textFieldName:'EQU_MOLD_NAME',
					DBtextFieldName: 'EQU_MOLD_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('MOLD_CODE',records[0]['EQU_MOLD_CODE']);
								grdRecord.set('MOLD_NAME',records[0]['EQU_MOLD_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('MOLD_CODE', '');
							grdRecord.set('MOLD_NAME', '');
						},
						applyextparam: function(popup){
							var grdRecord = detailGrid.uniOpt.currentRecord;
							popup.setExtParam({'DIV_CODE': grdRecord.get('DIV_CODE')});
							//popup.setExtParam({'ITEM_CODE': grdRecord.get('ITEM_CODE')});
						}
					}
				})
			},
			{dataIndex: 'MOLD_NAME'			, width: 120, tdCls:'x-change-cell',id:'moldNameCol',
				'editor' : Unilite.popup('EQU_MOLD_CODE_G',{
					textFieldName:'EQU_MOLD_NAME',
					DBtextFieldName: 'EQU_MOLD_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
									var grdRecord = detailGrid.uniOpt.currentRecord;
									grdRecord.set('MOLD_CODE',records[0]['EQU_MOLD_CODE']);
									grdRecord.set('MOLD_NAME',records[0]['EQU_MOLD_NAME']);
								},
							scope: this
						},
						'onClear': function(type) {
									var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('MOLD_CODE', '');
							grdRecord.set('MOLD_NAME', '');
						},
						applyextparam: function(popup){
							var grdRecord = detailGrid.uniOpt.currentRecord;
							popup.setExtParam({'DIV_CODE': grdRecord.get('DIV_CODE')});
							//popup.setExtParam({'ITEM_CODE': grdRecord.get('ITEM_CODE')});
						}
					}
				})
			},

			{dataIndex: 'PRODT_START_DATE'	, width: 100, tdCls:'x-change-cell' 	},
			{dataIndex: 'PRODT_END_DATE'	, width: 100, tdCls:'x-change-cell' 	}, 
			{dataIndex: 'DVRY_DATE'			, width: 100, tdCls:'x-change-cell2'	},
			
			{dataIndex: 'SOF_CUSTOM_NAME'	, width: 150},
			{dataIndex: 'SOF_ITEM_NAME'	, width: 200},
			
			{dataIndex: 'WKORD_NUM'			, width: 130	},
			{dataIndex: 'ITEM_CODE'			, width: 100	},
			{dataIndex: 'ITEM_NAME'			, width: 146	},
			{dataIndex: 'ITEM_NAME1'		, width: 146, hidden: true},
			{dataIndex: 'SPEC'				, width: 100 	},
			{dataIndex: 'STOCK_UNIT'		, width: 40}, 

			{dataIndex: 'WKORD_Q'			, width: 85, summaryType: 'sum'},
			{dataIndex: 'PRODT_Q'			, width: 73, summaryType: 'sum'}, 
			{dataIndex: 'REMARK1'			, width: 130},		
			{dataIndex: 'PROJECT_NO'		, width: 100},
			{dataIndex: 'ORDER_NUM'			, width: 120},
			{dataIndex: 'ORDER_Q'			, width: 66 },
			
			{dataIndex: 'LOT_NO'			, width: 100},
			{dataIndex: 'REMARK2'			, width: 66		,hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 66		,hidden: true},
			{dataIndex: 'WORK_SHOP_NAME'	, width: 66		,hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['PRODT_START_DATE','PRODT_END_DATE','EQUIP_CODE','EQUIP_NAME','MOLD_CODE','MOLD_NAME','CORE_CODE','CORE_NAME'])) {
					return true;
				} else {
					return false;
				}
			},
			afterrender: function(grid) {
				if(BsaCodeInfo.gsCoreUse == 'Y'){
					Ext.getCmp('moldCodeCol').setConfig('editor',Unilite.popup('CORE_CODE_G',{
						textFieldName:'CORE_NAME',
						DBtextFieldName: 'CORE_NAME',
						autoPopup: true,
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									var grdRecord = detailGrid.uniOpt.currentRecord;
									grdRecord.set('MOLD_CODE',records[0]['CORE_CODE']);
									grdRecord.set('MOLD_NAME',records[0]['CORE_NAME']);
								},
								scope: this
							},
							'onClear': function(type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('MOLD_CODE', '');
								grdRecord.set('MOLD_NAME', '');
							},
							applyextparam: function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								popup.setExtParam({'DIV_CODE': grdRecord.get('DIV_CODE')});
								//popup.setExtParam({'ITEM_CODE': grdRecord.get('ITEM_CODE')});
							}
						}
					}));
					
					Ext.getCmp('moldNameCol').setConfig('editor',Unilite.popup('CORE_CODE_G',{
						textFieldName:'CORE_NAME',
						DBtextFieldName: 'CORE_NAME',
						autoPopup: true,
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									var grdRecord = detailGrid.uniOpt.currentRecord;
									grdRecord.set('MOLD_CODE',records[0]['CORE_CODE']);
									grdRecord.set('MOLD_NAME',records[0]['CORE_NAME']);
								},
								scope: this
							},
							'onClear': function(type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('MOLD_CODE', '');
								grdRecord.set('MOLD_NAME', '');
							},
							applyextparam: function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								popup.setExtParam({'DIV_CODE': grdRecord.get('DIV_CODE')});
								//popup.setExtParam({'ITEM_CODE': grdRecord.get('ITEM_CODE')});
							}
						}
					}));
				}
			}
			
			
			
			
			
		}
	});

	Unilite.Main({
		id: 's_pmp170ukrv_shApp',
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				panelSearch, detailGrid
			]
		}],
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			
			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
//			panelSearch.getField('DIV_CODE').setReadOnly(true);
			detailStore.loadStoreRecords();
		},		
		onSaveDataButtonDown: function(config) {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['print'], true);
			UniAppManager.setToolbarButtons(['save'], false);
			
			panelSearch.setValue('WORK_SHOP_CODE','WS100');
			
			
			panelSearch.setValue('PRODT_START_DATE_FR', UniDate.get('aMonthAgo'));
			panelSearch.setValue('PRODT_START_DATE_TO', UniDate.get('todayForMonth'));
			
			
		},
		onPrintButtonDown: function () {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크

			var param = panelSearch.getValues();
			param.F_DIV_NAME = panelSearch.getField("DIV_CODE").rawValue;
			param.F_WORK_SHOP_NAME = panelSearch.getField("WORK_SHOP_CODE").rawValue;
			param["USER_LANG"] = UserInfo.userLang;
			param["PGM_ID"]= PGM_ID;
			param["MAIN_CODE"] = 'P010';
			param["sTxtValue2_fileTitle"]='작업지시서 현황';
			var win = null;
			win = Ext.create('widget.ClipReport', {
				url: CPATH+'/z_sh/s_pmp170clukrv_sh.do',
				prgID: 's_pmp170ukrv_sh',
				extParam: param
			});

			win.center();
			win.show();
		}
		
	});
};
</script>