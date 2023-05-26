<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr530skrv" >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {   
	
	var BsaCodeInfo={
		'gsBomPathYN'   :'${gsBomPathYN}',		  //BOM PATH 관리여부(B082)
		'gsExchgRegYN'  :'${gsExchgRegYN}',		 //대체품목 등록여부(B081)
		'gsItemCheck'   :'PROD'					 //품목구분(PROD:모품목, CHILD:자품목)
	}



	/** Model 정의 
	 * @type  
	 */
	Unilite.defineModel('Bpr530skrvModel', {
		fields: [
			{name: 'DIV_CODE'		,text:'<t:message code="system.label.base.division" default="사업장"/>'				,type:'string'},
			{name: 'PROD_ITEM_CODE'	,text:'<t:message code="system.label.base.parentitemcode" default="모품목코드"/>'		,type:'string'},
			{name: 'ITEM_CODE'		,text:'<t:message code="system.label.base.itemcode" default="품목코드"/>'				,type:'string'},
			{name: 'ITEM_NAME'		,text:'<t:message code="system.label.base.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'			,text:'<t:message code="system.label.base.spec" default="규격"/>'						,type:'string'},
			{name: 'STOCK_UNIT'		,text:'<t:message code="system.label.base.inventoryunit" default="재고단위"/>'			,type:'string'},
			{name: 'UNIT_Q'			,text:'<t:message code="system.label.base.originunitqty" default="원단위량"/>'			,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'PROD_UNIT_Q'	,text:'<t:message code="system.label.base.parentitembaseqty" default="모품목기준수"/>'	,type:'uniQty'},
			{name: 'LOSS_RATE'		,text:'<t:message code="system.label.base.lossrate" default="LOSS율"/>'				,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'SEQ'			,text:'<t:message code="system.label.base.seq" default="순번"/>'						,type:'string'}
		]
	});
	
	
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bpr530skrvMasterStore1', {
		model	: 'Bpr530skrvModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'bpr530skrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: ''
	});

	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
				name		: 'DIV_CODE',
				value		: UserInfo.divCode,
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.base.parentitem" default="모품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				allowBlank		: false,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			 }),{
				 xtype		: 'uniCombobox',
				 fieldLabel	: '<t:message code="system.label.base.useyn" default="사용여부"/>',
				 name		: 'USE_YN',
				 comboType	: 'AU',
				 comboCode	: 'B010',
				 listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('USE_YN', newValue);
					}
				 }
			 }, {
				fieldLabel	: '<t:message code="system.label.base.itemsearch" default="품목검색"/>',
				xtype		: 'radiogroup',
				items		: [{
					boxLabel	: '<t:message code="system.label.base.currentapplieditem" default="현재적용품목"/>',
					name		: 'ITEM_SEARCH', 
					width		: 120,
					inputValue	: 'C',
					checked		: true
				}, {
					boxLabel	: '<t:message code="system.label.base.whole" default="전체"/>',
					name		: 'ITEM_SEARCH', 
					width		: 60,
					inputValue	: 'A'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelResult.getField('RDO').setValue({RDO: newValue});
						panelResult.getField('ITEM_SEARCH').setValue(newValue.ITEM_SEARCH);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				xtype		: 'uniRadiogroup',
				fieldLabel	: '<t:message code="system.label.base.standardpathyn" default="표준Path 여부"/>',
				name		: 'StPathY',
				comboType	: 'AU',
				comboCode	: 'A020',
				width		: 240,
				allowBlank	: false,
				value		: 'Y',
				hidden		: BsaCodeInfo.gsBomPathYN =='Y' ? false:true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('StPathY').setValue(newValue.StPathY);
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
					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
					
				} else {
					  var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )   {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)   {
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
					if(Ext.isDefined(item.holdable) )   {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});
		
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{ 
			fieldLabel		: '<t:message code="system.label.base.parentitem" default="모품목"/>',
			valueFieldName	: 'ITEM_CODE', 
			textFieldName	: 'ITEM_NAME', 
			allowBlank		: false,
			colspan			: 2,
			listeners		: {
				onSelected	: {
					fn: function(records, type) {
						console.log('records : ', records);
						panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('ITEM_CODE', '');
					panelSearch.setValue('ITEM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			 xtype		: 'uniCombobox',
			 fieldLabel	: '<t:message code="system.label.base.useyn" default="사용여부"/>',
			 name		: 'USE_YN',
			 comboType	: 'AU',
			 comboCode	: 'B010',
			 listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('USE_YN', newValue);
				}
			 }
		}, {
			fieldLabel	: '<t:message code="system.label.base.itemsearch" default="품목검색"/>',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '<t:message code="system.label.base.currentapplieditem" default="현재적용품목"/>',
				name		: 'ITEM_SEARCH',
				width		:	 100, 
				inputValue	: 'C',
				checked: true
			}, {
				boxLabel	: '<t:message code="system.label.base.whole" default="전체"/>',
				name		: 'ITEM_SEARCH',
				width		: 100, 
				inputValue	: 'A'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelSearch.getField('RDO').setValue({RDO: newValue});
					panelSearch.getField('ITEM_SEARCH').setValue(newValue.ITEM_SEARCH);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},{
			xtype		: 'uniRadiogroup',
			fieldLabel	: '<t:message code="system.label.base.standardpathyn" default="표준Path 여부"/>',
			name		: 'StPathY',
			comboType	: 'AU',
			comboCode	: 'A020',
			width		: 240,
			hidden		: BsaCodeInfo.gsBomPathYN =='Y' ? false:true,
			allowBlank	: false,
			value		: 'Y',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('StPathY').setValue(newValue.StPathY);
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
						var labelText = invalid.items[0]['fieldLabel']+':';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
					}

					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					  var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )   {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)   {
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
					if(Ext.isDefined(item.holdable) )   {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)   {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});
		
		
		
	/** Master Grid1 정의(Grid Panel),
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('bpr530skrvGrid1', {
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		store	: directMasterStore1,
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	showSummaryRow: false}],
		columns	: [
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 250},
			{dataIndex: 'SPEC'			, width: 250},
			{dataIndex: 'STOCK_UNIT'	, width: 80,	align: 'center'},
			{dataIndex: 'UNIT_Q'		, width: 100}
		] 
	});



	Unilite.Main( {
		id			: 'bpr530skrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid1, panelResult
			]
		},
		panelSearch	 
		], 	
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid1.getStore().loadStoreRecords();
		}
	});
};

/*
,{
			//추가검색
			xtype: 'container',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 3},
			hidden: true,
			id: 'AdvanceSerch',
			items: [
					{
				fieldLabel: '영업담당',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S010'
			}, {
				fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>',
				name: 'TXTLV_L1', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'TXTLV_L2'
			}, {
				fieldLabel: '수주량',
				name:'FR_ORDER_QTY', 
				suffixTpl:'&nbsp;이상', 
				labelWidth:120
			}, {
				fieldLabel: '거래처분류',
				name:'AGENT_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B055'  
			}, {
				fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
				name: 'TXTLV_L2', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'TXTLV_L3'
			}, {
				fieldLabel: '~',
				name:'TO_ORDER_QTY', 
				suffixTpl:'&nbsp;이하', 
				labelWidth:120
			}, {
				fieldLabel: '지역',
				name:'AREA_TYPE', 	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B056'  
			}, {
				fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
				name: 'TXTLV_L3', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
				colspan: 2
			}, {
				fieldLabel: '판매유형',
				name:'ORDER_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S002'  
			},
				Unilite.popup('ITEM2',{ fieldLabel: '<t:message code="system.label.base.repmodelcode" default="대표모델코드"/>', textFieldWidth:170, validateBlank:false, popupWidth: 710, colspan: 2}),
			  {
		 	 	xtype: 'container',
				defaultType: 'uniTextfield',
 				layout: {type: 'uniTable', columns: 3},
 				width:325,
 				items:[{
 					fieldLabel:'수주번호', suffixTpl:'&nbsp;~&nbsp;', name: 'FR_ORDER_NUM', width:218
 				}, {
 					name: 'TO_ORDER_NUM', width:107
 				}] 
			}, { 
				fieldLabel: '납기일',
			 	xtype: 'uniDateRangefield',
			 	startFieldName: 'DVRY_DATE_FR',
			 	endFieldName: 'DVRY_DATE_TO',	
			 	width: 315,
			 	colspan: 2
			}, {
				fieldLabel: '생성경로',
				name:'TXT_CREATE_LOC', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B031'
			}, {
				xtype: 'radiogroup',
				fieldLabel: '마감여부',
				id: 'ORDER_STATUS',
				items: [{
					boxLabel: '전체', width: 50, name: 'ORDER_STATUS', inputValue: '%', checked: true
				}, {
					boxLabel: '마감', width: 60, name: 'ORDER_STATUS', inputValue: 'Y'
				}, {
					boxLabel: '미마감', width: 80, name: 'ORDER_STATUS', inputValue: 'N'
				}]
			}, {
				fieldLabel: '상태',
				xtype: 'radiogroup',
				id: 'rdoSelect2',
				labelWidth:120,
				items: [{
					boxLabel: '전체', width: 50,  name: 'rdoSelect2', inputValue: 'A', checked: true
				}, {
					boxLabel: '미승인', width: 60, name: 'rdoSelect2', inputValue: 'N'
				}, {
					boxLabel: '승인(완료)', width: 80, name: 'rdoSelect2', inputValue: '6'
				}, {
					boxLabel: '반려', width: 60, name: 'rdoSelect2', inputValue: '5'
				}]
			}]		 
*/
</script>
