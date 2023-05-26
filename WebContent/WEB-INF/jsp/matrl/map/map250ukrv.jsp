<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map250ukrv"  >
   <t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
   <t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
   <t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
   <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
   /**
    *   Model 정의
    * @type
    */

	Unilite.defineModel('Map250ukrvModel', {
		fields: [
			{name: 'CHK'            	, text: '<t:message code="system.label.purchase.confirmation" default="확정"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'		, type: 'uniQty'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'		, type: 'string',comboType: 'AU',comboCode: 'M001'},
			{name: 'ORDER_UNIT_P1'		, text: '<t:message code="system.label.purchase.tempprice" default="가단가"/>'		, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.actualprice" default="진단가"/>'		, type: 'uniUnitPrice'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'		, type: 'int'},
			{name: 'ORDER_P'			, text: '<t:message code="system.label.purchase.inventoryprice" default="재고단가"/>'		, type: 'uniUnitPrice'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'		, type: 'string'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'		, type: 'uniPrice'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'		, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'		, type: 'int'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'		, type: 'string',comboType: 'AU',comboCode: 'M201'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'		, type: 'uniER'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		, type: 'string'},
			{name: 'PROJECT_NO'			, text:	'<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'COMP_CODE'			, text:	'COMP_CODE'	, type: 'string'},
			{name: 'IN_DIV_CODE'			, text:	'IN_DIV_CODE'	, type: 'string'}
		]
	});//End of Unilite.defineModel('Map250ukrvModel', {
   var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'map250ukrvService.selectList',
			update  : 'map250ukrvService.updateList',
			syncAll : 'map250ukrvService.saveAll'
		}
	});
   /**
    * Store 정의(Service 정의)
    * @type
    */
	var directMasterStore1 = Unilite.createStore('map250ukrvMasterStore1',{
		model: 'Map250ukrvModel',
		uniOpt: {
			isMaster: true,         // 상위 버튼 연결
			editable: true,         // 수정 모드 사용
			deletable:false,         // 삭제 가능 여부
			useNavi : false         // prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
	   		var toUpdate = this.getUpdatedRecords();
	   		var toDelete = this.getRemovedRecords();
	   		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.app.onQueryButtonDown();
						//UniAppManager.setToolbarButtons('save', false);
					 }
				};
				this.syncAllDirect(config);
			} else {
	            var grid = Ext.getCmp('map250ukrvGrid1');
	            grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});//End of var directMasterStore1 = Unilite.createStore('map250ukrvMasterStore1',{

   /**
    * 검색조건 (Search Panel)
    * @type
    */
    var masterForm = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
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
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
            	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				textFieldWidth: 170,
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE': '3'},
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								masterForm.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									masterForm.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								masterForm.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									masterForm.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
		                	}
					}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name: 'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M201',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			}]
		}]
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
            	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(masterForm) {
						masterForm.setValue('ORDER_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(masterForm) {
			    		masterForm.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				textFieldWidth: 170,
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE': '3'},
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								masterForm.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									masterForm.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								masterForm.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									masterForm.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
		                	}
					}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name: 'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M201',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('ORDER_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('ORDER_TYPE', newValue);
					}
				}
			}
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}

					   	alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					   	invalid.items[0].focus();
					} else {
					//	this.mask();
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('map250ukrvGrid1', {
       // for tab
		layout: 'fit',
		region: 'center',
		uniOpt:{
			useLiveSearch:true,
			expandLastColumn:false,
			onLoadSelectFirst:false
		},
		store: directMasterStore1,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false}),
		columns: [
			{dataIndex: 'CHK'            	, width: 60, locked: true, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 93, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 133, locked: true},
			{dataIndex: 'ITEM_CODE'			, width: 113, locked: true},
			{dataIndex: 'ITEM_NAME'			, width: 146, locked: true},
			{dataIndex: 'SPEC'				, width: 146},
			{dataIndex: 'ORDER_UNIT'		, width: 66},
			{dataIndex: 'ORDER_UNIT_Q'		, width: 86},
			{dataIndex: 'ORDER_TYPE'		, width: 83},
			{dataIndex: 'ORDER_UNIT_P1'		, width: 93},
			{dataIndex: 'ORDER_UNIT_P'		, width: 93},
			{dataIndex: 'TRNS_RATE'			, width: 133, hidden: true},
			{dataIndex: 'ORDER_P'			, width: 133, hidden: true},
			{dataIndex: 'MONEY_UNIT'		, width: 53,  align:'center'},
			{dataIndex: 'ORDER_O'			, width: 100},
			{dataIndex: 'ORDER_NUM'			, width: 100},
			{dataIndex: 'ORDER_SEQ'			, width: 33},
			{dataIndex: 'ORDER_PRSN'		, width: 100},
			{dataIndex: 'EXCHG_RATE_O'		, width: 133, hidden: true},
			{dataIndex: 'REMARK'			, width: 133},
			{dataIndex: 'PROJECT_NO'		, width: 133},
			{dataIndex: 'COMP_CODE'			, width: 133, hidden: true},
			{dataIndex: 'IN_DIV_CODE'			, width: 100, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.field == 'ORDER_UNIT_P'){
					return true;
				}else{
					return false;
				}
			},
			select: function(grid, record, index, eOpts ){
        		record.set('CHK', record.get("CHK") == 'false'?'true':'false');
        	},
        	deselect:  function(grid, record, index, eOpts ){
        		record.set('CHK', record.get("CHK") == 'false'?'true':'false');
        	}
		}
	});//End of var masterGrid = Unilite.createGrid('map250ukrvGrid1', {

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterGrid
			]
		},masterForm
		],
		id: 'map250ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
		},
		onQueryButtonDown: function() {
			if(!panelResult.setAllFieldsReadOnly(true)){
				return false;
			}else{
				directMasterStore1.loadStoreRecords();
			}
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});//End of Unilite.Main( {

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {

				case "ORDER_UNIT_P" ://진단가
					if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					var trnsRate = record.get('TRNS_RATE');
					var orderP = record.get('ORDER_P');
					var exchgRateO = record.get('EXCHG_RATE_O');
					var orderUnitQ = record.get('ORDER_UNIT_Q');

					record.set('ORDER_P',newValue / trnsRate);
					record.set('ORDER_P',orderP * exchgRateO);
					record.set('ORDER_O',orderUnitQ * newValue);
			}
				return rv;
						}
			});
};
</script>