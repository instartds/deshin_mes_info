<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="biv150ukrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="biv150ukrv"/> 		<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B024" /> 			<!-- 수불 담당자 -->
//<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> 	<!--창고-->
<t:ExtComboStore comboType="OU" storeId="whList" />   			<!--창고(사용여부 Y) -->
<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" /><!--창고Cell-->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	gsSumTypeLot:		'${gsSumTypeLot}',
	gsSumTypeCell:		'${gsSumTypeCell}'
};

/*var output ='';
	for(var key in BsaCodeInfo){
 		output += key + '  :  ' + BsaCodeInfo[key] + '\n';
	}
	alert(output);*/

var outDivCode = UserInfo.divCode;

function appMain() {
	var SumTypeCell = false;
	if(BsaCodeInfo.gsSumTypeCell =='N')	{
		SumTypeCell = true;
	}


	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Biv150ukrvModel', {
		fields: [
			{name: 'DIV_CODE' 		,text: '<t:message code="system.label.inventory.division" default="사업장"/>'			,type: 'string'},
			{name: 'WH_CELL_CODE'	,text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'	,type: 'string'},
			{name: 'WH_CODE'		,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'			,type: 'string'},
			{name: 'COUNT_DATE'		,text: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>'	,type: 'string'},
			{name: 'INOUT_PRSN'		,text: '<t:message code="system.label.inventory.trancharger" default="수불담당자"/>'		,type: 'string'},
			{name: 'COUNT_FLAG'		,text: '<t:message code="system.label.inventory.classfication" default="구분"/>'		,type: 'string'}
		]
	});


	/** Store 정의(Service 정의)
	 * @type
	 */
	var panelSearch = Unilite.createForm('searchForm', {
		disabled: false,
		flex	: 1,
		layout	: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		items	: [{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank: false,
			child:'WH_CODE',
			holdable: 'hold'
		},{
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			holdable: 'hold',
			allowBlank: false,
			child        : 'WH_CELL_CODE',
			store: Ext.data.StoreManager.lookup('whList'),
			holdable: 'hold'
		},{
			fieldLabel: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',
			name: 'WH_CELL_CODE',
			xtype: 'uniCombobox',
			hidden: SumTypeCell,
			store: Ext.data.StoreManager.lookup('whCellList')
		},
		Unilite.popup('COUNT_DATE', {
			fieldLabel: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
			textFieldWidth: 150,
			//fieldStyle: 'text-align: center;',
			//align: 'center',
			//alignPicker('center'),
			//alignTo: 'center',
			validateBlank: false,
			allowBlank: false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
						countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
						panelSearch.setValue('COUNT_DATE', countDATE);
						panelSearch.setValue('WH_CODE', records[0]['WH_CODE']);
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('COUNT_DATE', '');
					//panelResult.setValue('COUNT_DATE', '');
					panelSearch.setValue('WH_CODE', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					popup.setExtParam({'WH_CODE': panelSearch.getValue('WH_CODE')});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.inventory.trancharger" default="수불담당자"/>',
			name:'INOUT_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B024'
		},{
			xtype: 'container',
			padding: '10 0 0 0',
			layout: {
				type: 'hbox',
				align: 'center',
				pack:'center'
			},
			items:[{
				xtype: 'button',
				text: '<t:message code="system.label.inventory.execute" default="실행"/>',
				width: 60,
				handler : function(records) {
					var rv = true;
					if(confirm('<t:message code="system.message.inventory.message007" default="실행하시겠습니까?"/>')) {
						var param= panelSearch.getValues();

						var me = this;
						Biv150ukrvService.selectMaster(param, function(provider, response) {
							var param= Ext.getCmp('searchForm').getValues();
							var cOUNTdATE = panelSearch.getValue('COUNT_DATE').replace('.','');
							var countdateReplace = cOUNTdATE.replace('.','');
							param.COUNT_DATE = countdateReplace;
							if(provider[0].COUNT_FLAG == 'C') {
								alert('<t:message code="system.message.inventory.message010" default="이미 실사조정을 하셨습니다. 조정할 수 없습니다."/>');
							} else {
								panelSearch.getEl().mask('<t:message code="system.label.inventory.loading" default="로딩중..."/>','loading-indicator');
								Ext.apply(param, {'WORK_FLAG':'E'});  // 실행 Flag
								Biv150ukrvService.excuteStockAdjust(param, function(provider, response) {
									if(provider != null) {
										alert('<t:message code="system.message.inventory.message009" default="작업이 완료 되었습니다."/>');
									}
		 							panelSearch.getEl().unmask();
								});
							}
						});
					} else {
					}
					return rv;
				}
			},{
				xtype: 'button',
				text: '<t:message code="system.label.inventory.cancel" default="취소"/>',
				margin: '0 0 2 20',
				width: 60,
				handler : function(records) {
					var rv = true;
					if(confirm('<t:message code="system.message.inventory.message007" default="실행하시겠습니까?"/>')) {
						var param= panelSearch.getValues();

						var me = this
						me.setDisabled(true);
						panelSearch.getEl().mask('<t:message code="system.label.inventory.loading" default="로딩중..."/>','loading-indicator');
						Biv150ukrvService.selectMaster(param, function(provider, response) {
							var param= Ext.getCmp('searchForm').getValues();
							var cOUNTdATE = panelSearch.getValue('COUNT_DATE').replace('.','');
							var countdateReplace = cOUNTdATE.replace('.','');
							param.COUNT_DATE = countdateReplace;
							if(provider[0].COUNT_FLAG != 'C') {
								alert('<t:message code="system.message.inventory.message012" default="삭제할 자료가 없습니다."/>');
								me.setDisabled(false);
							} else {
								Ext.apply(param, {'WORK_FLAG':'C'});  // 취소 Flag
								Biv150ukrvService.excuteStockAdjust(param, function(provider, response) {
									if(provider != null) {
										alert('<t:message code="system.message.inventory.message009" default="작업이 완료 되었습니다."/>');
									}
									me.setDisabled(false);
								});
							}
						});
 						panelSearch.getEl().unmask();
					} else {
					}
					return rv;
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});


	var directMasterStore = Unilite.createStore('biv150ukrvMasterStore1',{
		model: 'Biv150ukrvModel',
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct'
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});


	Unilite.Main({
		id		: 'biv150ukrvApp',
		items	: [panelSearch],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		fnYyyymmSet : function(whCode) {		// 창고 선택에 따라 날짜 set
			panelSearch.setValue('COUNT_DATE', '');
			panelSearch.setValue('INOUT_PRSN', '');

			var param =  panelSearch.getValues();
			Biv150ukrvService.YyyymmSet(param, function(provider, response)	{
				if(provider.COUNT_DATE == '' || provider.COUNT_DATE == '00000000') {
					alert('<t:message code="system.message.inventory.message013" default="해당자료가 없습니다."/>');
				} else {
					panelSearch.setValue('COUNT_DATE', provider['COUNT_DATE']);
					panelSearch.setValue('INOUT_PRSN', provider['INOUT_PRSN']);
				}
			})
		}
	});
};
</script>
