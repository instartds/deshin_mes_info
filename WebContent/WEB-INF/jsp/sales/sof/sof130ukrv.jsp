<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof130ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" />		<!-- 창고-->
	<t:ExtComboStore comboType="WU" />		<!-- 작업장  -->

</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >

function appMain() {
	var gubunStore = Unilite.createStore('gubunComboStore', {  
		fields: ['text', 'value'],
		data :  [
			{'text':'<t:message code="system.label.purchase.confirm" default="확인"/>'		, 'value':'Y'},
			{'text':'<t:message code="system.label.purchase.notconfirm" default="미확인"/>'	, 'value':'N'}
		]
	});



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'sof130ukrvService.selectList',
//			create	: 'sof130ukrvService.insertDetail',
			update	: 'sof130ukrvService.updateDetail',
//			destroy	: 'sof130ukrvService.deleteDetail',
			syncAll	: 'sof130ukrvService.saveAll'
		}
	});



	Unilite.defineModel('detailModel', {
		fields: [
			 { name: 'DIV_CODE'			,text:'<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string' ,comboType:'BOR120'}
			,{ name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.sales.custom" default="거래처"/>'			,type: 'string' }
			,{ name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'	,type: 'string' }
			,{ name: 'PO_NUM'			,text:'발주번호'	,type: 'string' }
			//20190709 발주항번 -> 발주순번으로 변경
			,{ name: 'PO_SEQ'			,text:'발주순번'	,type: 'int' }
			,{ name: 'ITEM_CODE'		,text:'<t:message code="system.label.sales.itemcode" default="품목코드"/>'		,type: 'string' }
			,{ name: 'ITEM_NAME'		,text:'<t:message code="system.label.sales.itemname2" default="품명"/>'		,type: 'string' }
			,{ name: 'SPEC'				,text:'<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string' }
			,{ name: 'ORDER_NUM'		,text:'<t:message code="system.label.sales.sono" default="수주번호"/>'			,type: 'string' }
			,{ name: 'SER_NO'			,text:'<t:message code="system.label.sales.soseq" default="수주순번"/>'			,type: 'int' }
			,{ name: 'ORDER_DATE'		,text:'<t:message code="system.label.sales.sodate" default="수주일"/>'			,type: 'uniDate'}
			,{ name: 'ORDER_Q'			,text:'<t:message code="system.label.sales.soqty" default="수주량"/>'			,type: 'uniQty' }
			,{ name: 'INIT_DVRY_DATE'	,text:'최초납기일'	,type: 'uniDate' }
			,{ name: 'DVRY_DATE'		,text:'변경납기일'	,type: 'uniDate',allowBlank:false}
			,{ name: 'WEEK_NUM'			,text:'납기주차'	,type: 'string',allowBlank:false }
			,{ name: 'REASON'			,text:'납기변경사유'	,type: 'string',allowBlank:false }
		]
	});	



	var detailStore = Unilite.createStore('detailStore',{
		model	: 'detailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
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
			load: function(store, records, successful, eOpts) {
			}
		}
	});



	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region	: 'north',
		layout	: {type : 'uniTable', columns :3
//			tableAttrs: {width: '100%'}
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		}, {
			fieldLabel	: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			xtype		: 'uniDateRangefield',
			startFieldName: 'FR_ORDER_DATE',
			endFieldName: 'TO_ORDER_DATE',
			width		: 350,
			startDate	: UniDate.get('threeMonthsAgo'),
			endDate		: UniDate.get('today')
		},{
			fieldLabel	: '<t:message code="system.label.sales.pono" default="발주번호"/>', 
			xtype		: 'uniTextfield',
			name		: 'PO_NUM'
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			value		: '',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>' ,
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			xtype		: 'uniTextfield',
			name		: 'ORDER_NUM'
		},{
			fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>', 
			name		: 'ORDER_TYPE',   
			xtype		: 'uniCombobox',
			comboType	: 'AU', 
			comboCode	: 'S002'
		},
		Unilite.popup('DIV_PUMOK',{
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			//20190618 조회조건 추가
			fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
			name		: 'OUT_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}]
	});



	var detailGrid = Unilite.createGrid('detailGrid', {
		store: detailStore,
		layout: 'fit',
		region:'center',
		uniOpt: {
//			userToolbar:false,
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: true,
			filter: {
				useFilter: false,
				autoCreate: false
			}
			//20190709 그리드 설정 저장을 위해서 주석
//			state: {
//				useState: false,
//				useStateList: false
//			}
		},
		columns: [
			{ dataIndex: 'DIV_CODE'			, width: 100 },
			{ dataIndex: 'CUSTOM_CODE'		, width: 100 },
			{ dataIndex: 'CUSTOM_NAME'		, width: 200 },
			{ dataIndex: 'PO_NUM'			, width: 100 },
			{ dataIndex: 'PO_SEQ'			, width: 80 },
			{ dataIndex: 'ITEM_CODE'		, width: 100 },
			{ dataIndex: 'ITEM_NAME'		, width: 250 },
			{ dataIndex: 'SPEC'				, width: 100 },
			{ dataIndex: 'ORDER_NUM'		, width: 120 },
			{ dataIndex: 'SER_NO'			, width: 80 },
			{ dataIndex: 'ORDER_DATE'		, width: 100 },
			{ dataIndex: 'ORDER_Q'			, width: 100 },
			{ dataIndex: 'INIT_DVRY_DATE'	, width: 100 },
			{ dataIndex: 'DVRY_DATE'		, width: 100 },
			{ dataIndex: 'WEEK_NUM'			, width: 100 },
			{ dataIndex: 'REASON'			, width: 300 }
  		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['DVRY_DATE','WEEK_NUM','REASON'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});



	Unilite.Main({
		id: 'sof130ukrvApp',
		borderItems: [{
			id		: 'pageAll',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
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
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
		
			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			//20190709 from 날짜 3개월 전으로 변경
			panelSearch.setValue('FR_ORDER_DATE', UniDate.get('threeMonthsAgo'));
			panelSearch.setValue('TO_ORDER_DATE', UniDate.get('today'));
			
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','delete','save'], false);
		}
	});



	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				
				case "DVRY_DATE" :
					var param = {
						'OPTION_DATE' : UniDate.getDbDateStr(newValue),
						'CAL_TYPE' : '3' //주단위
					}
					prodtCommonService.getCalNo(param, function(provider, response) {
						if(!Ext.isEmpty(provider.CAL_NO)){
							record.set('WEEK_NUM',provider.CAL_NO);
						}else{
							record.set('WEEK_NUM','');
						}
					});
				break;
			}
			return rv;
		}
	}); // validator
	
};
</script>