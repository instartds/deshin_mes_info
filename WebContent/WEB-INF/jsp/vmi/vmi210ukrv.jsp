<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="vmi210ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" />		<!-- 창고-->
	<t:ExtComboStore comboType="WU" />		<!-- 작업장  -->

	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 발주상태 -->

</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >

var getVmiUserLevel = '${getVmiUserLevel}';
var PGM_TITLE = "납품등록";
var searchInfoWindow;
var referOrderWindow;
var labelPrintWindow;//라벨출력
var gsSelRecord;
var labelPrintHiddenYn = true;
var BsaCodeInfo = {
		gsSiteCode          : '${gsSiteCode}'
	};
if(BsaCodeInfo.gsSiteCode == 'SHIN'){
	labelPrintHiddenYn = false;
}
var SAVE_AUTH = "true";

function appMain() {
	var gubunStore = Unilite.createStore('gubunComboStore', {
        fields: ['text', 'value'],
        data: [
            {'text':'<t:message code="system.label.purchase.confirm" default="확인"/>'  , 'value':'Y'},
            {'text':'<t:message code="system.label.purchase.notconfirm" default="미확인"/>'  , 'value':'N'}
        ]
    });

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read: 'vmi210ukrvService.selectList',
			create: 'vmi210ukrvService.insertDetail',
			update: 'vmi210ukrvService.updateDetail',
			destroy: 'vmi210ukrvService.deleteDetail',
			syncAll: 'vmi210ukrvService.saveAll'
		}
	});

	Unilite.defineModel('detailModel', {
		fields: [
			{name: 'DIV_CODE'	 		,text: 'DIV_CODE' 																, type: 'string'},
			{name: 'CUSTOM_CODE'		,text: 'CUSTOM_CODE' 															, type: 'string'},
			{name: 'ISSUE_SEQ'	 		,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 			, type: 'int'},
			{name: 'ISSUE_NUM'	 		,text: 'ISSUE_NUM' 																, type: 'string'},
			{name: 'ORDER_NUM'	 		,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>' 			, type: 'string'},
			{name: 'ORDER_SEQ'	 		,text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>' 																	,type: 'string'},
			{name: 'ITEM_CODE'	 		,text: '<t:message code="system.label.purchase.item" default="품목"/>' 			, type: 'string'},
			{name: 'ITEM_NAME'	 		,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>' 		, type: 'string'},
			{name: 'SPEC'	 	 		,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 			, type: 'string'},
			{name: 'ORDER_UNIT'	 		,text: '<t:message code="system.label.purchase.unit" default="단위"/>' 																	,type: 'string'},
			{name: 'ORDER_DATE'	 		,text: '<t:message code="system.label.purchase.podate" default="발주일"/>' 		, type: 'uniDate'},
			{name: 'DVRY_DATE'	 		,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>' 	, type: 'uniDate'},
			{name: 'DVRY_ESTI_DATE'		,text: '<t:message code="system.label.purchase.dvryestidate" default="납품예정일"/>', type: 'uniDate'},
			{name: 'TOTAL_ISSUE_Q'		,text: '납품예정량' 																	, type: 'uniQty'},
			{name: 'ORDER_Q'	 		,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>' 			, type: 'uniQty'},
			{name: 'UN_Q'	 			,text: '<t:message code="system.label.purchase.undeliveryqty" default="미납량"/>' 																	,type: 'uniQty'},
    		{name: 'PACK_UNIT_Q'		,text:'<t:message code="system.label.sales.packunitq" default="BOX입수"/>'    	, type: 'uniQty'},
    		{name: 'BOX_Q'				,text:'<t:message code="system.label.sales.boxq" default="BOX수"/>'      		, type: 'uniQty'},
    		{name: 'EACH_Q'				,text:'<t:message code="system.label.sales.eachq" default="낱개"/>'      			, type: 'uniQty'},
    		{name: 'LOSS_Q'				,text:'<t:message code="system.label.sales.lossq" default="LOSS여분"/>'      		, type: 'uniQty'},
			{name: 'ISSUE_Q'			,text:'<t:message code="system.label.sales.issueqty" default="출고량"/>'	  		, type: 'uniQty'},
			{name: 'ISSUE_DATE'	 		,text: 'ISSUE_DATE' 															, type: 'uniDate'},
			{name: 'DVRY_TIME'	 		,text: '<t:message code="system.label.purchase.deliverytime4" default="납품시간"/>'	, type:'uniTime' , format:'Hi'},
			{name: 'SO_NUM'	 	 		,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>' 		 	, type: 'string'},
			{name: 'SO_SEQ'	 			,text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>' 	 	, type: 'int'},
			{name: 'SOF_CUSTOM_NAME'	,text: '수주처'			,type:'string'},
			{name: 'SOF_ITEM_NAME'		,text: '수주품명'			,type:'string'},
			{name: 'REMARK'		,text: '비고'			,type:'string'}
		]
	});

	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var isErr = false;
			Ext.each(list, function(record, index) {

				if(record.get('ISSUE_Q')== 0){//출고량이 0인 경우
					var msg = '';
						msg += '\n<t:message code="system.message.purchase.message105" default="출고량에는 0보다 큰 수를 입력해야 합니다."/>';

					if(msg != ''){
						Unilite.messageBox((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + msg);
						isErr = true;
						return false;
					}
				}

			});

			if(isErr) {
				return false;
			}
			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						if(!Ext.isEmpty(master.ISSUE_NUM)) {
							panelSearch.setValue("ISSUE_NUM", master.ISSUE_NUM);
						}

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
				if(store.getCount() > 0){
					panelSearch.down('#printButton').setDisabled(false);
            	}else{
					panelSearch.down('#printButton').setDisabled(true);
            	}
			}
		}
	});

	var detailGrid = Unilite.createGrid('detailGrid', {
		store	: detailStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: true,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			state: {
				useState	: true,
				useStateList: true
			}
		},
		tbar: [{
			itemId : 'refBtn',
			text:'<div style="color: blue"><t:message code="system.label.purchase.porefer" default="발주참조"/></div>',
			handler: function() {
            	if(!panelSearch.getInvalidMessage()) return;   //필수체크
				openReferOrderWindow();
			}
   		},'-'],
		columns: [

			{ dataIndex: 'ISSUE_SEQ'	, width: 60,align:'center',tdCls:'x-change-cell'},
			{ dataIndex: 'SO_NUM'	 	  , width: 100, hidden: true},
			{ dataIndex: 'SO_SEQ'	  	  , width: 80, hidden: true},

			{ dataIndex: 'SOF_CUSTOM_NAME'	, width: 150, hidden: true},
			{ dataIndex: 'SOF_ITEM_NAME'	, width: 200, hidden: true},

			{ dataIndex: 'ORDER_NUM'	, width: 120},
			{ dataIndex: 'ORDER_SEQ'	, width: 80,align:'center'},
			{ dataIndex: 'ITEM_CODE'	, width: 120},
			{ dataIndex: 'ITEM_NAME'	, width: 250},
			{ dataIndex: 'SPEC'	 	 	, width: 120},
			{ dataIndex: 'ORDER_UNIT'	, width: 60,align:'center'},

			{ dataIndex: 'ORDER_DATE'	, width: 90},
			{ dataIndex: 'DVRY_DATE'	, width: 90},
			{ dataIndex: 'DVRY_ESTI_DATE' , width: 90},
			{ dataIndex: 'DVRY_TIME'	, width: 90, align: 'center'
				,editor: {
					xtype: 'timefield',
					format: 'H:i',
				//	submitFormat: 'Hi', //i tried with and without this config
					increment: 10
		 			}
			},
			{ dataIndex: 'TOTAL_ISSUE_Q', width: 100},
			{ dataIndex: 'ORDER_Q'	 	, width: 100},
			{ dataIndex: 'UN_Q'	 		, width: 100},

			{ dataIndex: 'PACK_UNIT_Q'	, width: 100,tdCls:'x-change-cell'},
			{ dataIndex: 'BOX_Q'		, width: 100,tdCls:'x-change-cell'},
			{ dataIndex: 'EACH_Q'		, width: 100,tdCls:'x-change-cell'},
			{ dataIndex: 'LOSS_Q'		, width: 100,tdCls:'x-change-cell'},
			{ dataIndex: 'ISSUE_Q'		, width: 100,tdCls:'x-change-cell'},
			{   text: '라벨',
	            width: 120,
	            xtype: 'widgetcolumn',
	            hidden: labelPrintHiddenYn,
	            widget: {
	                xtype: 'button',
	                text: '라벨 출력',
	                listeners: {
	                	buffer:1,
	                	click: function(button, event, eOpts) {
		                        gsSelRecord = event.record.data;
		                        openLabelPrintWindow(gsSelRecord);
	                	}
	                }
	            }
	       },
			{ dataIndex: 'REMARK' , width: 300}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['PACK_UNIT_Q', 'BOX_Q','EACH_Q','LOSS_Q','ISSUE_Q', 'DVRY_TIME','REMARK'])) {
					return true;
				} else {
					return false;
				}
			}
		},
		setIssueNumData:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('ORDER_DATE'			, record['ORDER_DATE']);
			grdRecord.set('DVRY_DATE'			, record['DVRY_DATE']);
			grdRecord.set('DVRY_ESTI_DATE'		, record['DVRY_ESTI_DATE']);
			grdRecord.set('UN_Q'				, record['UN_Q']);
			
			grdRecord.set('REMARK'				, record['REMARK']);
		}
	});
	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns : 4},
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			readOnly: false
		},{
			fieldLabel: '<t:message code="system.label.purchase.issuedate2" default="납품일"/>',
		    xtype: 'uniDatefield',
			name: 'ISSUE_DATE',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					/* if(UniDate.get('today') > UniDate.getDbDateStr(newValue)){
						panelSearch.setValue('ISSUE_DATE', UniDate.get('today'));
						Unilite.messageBox('당일 이전 날짜로는 선택할 수 없습니다.');
					} */
				},
				blur: function(field, The, eOpts){
					if(UniDate.get('today') > UniDate.getDbDateStr(field.value)){
						panelSearch.setValue('ISSUE_DATE', UniDate.get('today'));
						Unilite.messageBox('당일 이전 날짜로는 선택할 수 없습니다.');
						panelSearch.getField('ISSUE_DATE').focus();
						return false;
					}
				}
			}
		},{
            fieldLabel: '납품시간',
            name:'DVRY_TIME',
            xtype:'timefield',
            format: 'H:i',
            increment: 10,
            holdable: 'hold',
            readOnly: false,
            fieldStyle: 'text-align: center;',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				},blur: function(field, event, eOpts ) {

				}
			}
		},{
			xtype: 'button',
			text: '<t:message code="system.label.sales.specificationprint" default="거래명세서출력"/>',
			itemId: 'printButton',
			margin: '0 0 0 120',
			handler : function() {
				var param = panelSearch.getValues();

					param["GUBUN"]= BsaCodeInfo.gsSiteCode;

				var win = Ext.create('widget.ClipReport', {
					url: CPATH+'/vmi/vmi210clukrv.do',
					prgID: 'vmi210ukrv',
					extParam: param
				});
				win.center();
				win.show();
			}
		},
        Unilite.popup('AGENT_CUST', {
            fieldLabel: '<t:message code="system.label.purchase.partners" default="협력사"/>',
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME',
			allowBlank: false
        }),
        {
			xtype:'uniTextfield',
			fieldLabel:'<t:message code="system.label.purchase.issuenum" default="납품번호"/>',
			name:'ISSUE_NUM',
			colspan:2,
			readOnly:true
//			listeners: {
//                change: function(field, newValue, oldValue, eOpts) {
//                	if(!Ext.isEmpty(newValue)){
//						panelSearch.down('#printButton').setDisabled(false);
//                	}else{
//						panelSearch.down('#printButton').setDisabled(true);
//                	}
//                }
//            }
		}/*,{
			fieldLabel: '<t:message code="system.label.purchase.charger" default="담당자"/>',
			name: 'ISSUE_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:''
		}*/]
	});
function fn_date(){
	panelSearch.setValue('ISSUE_DATE', UniDate.get('today'));
}
	var issueNumSearch = Unilite.createSearchForm('issueNumSearchForm', {
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			readOnly:true,
			hidden:true
//			colspan:2
		},
        Unilite.popup('AGENT_CUST', {
            fieldLabel: '<t:message code="system.label.purchase.partners" default="협력사"/>',
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME',
			allowBlank: false,
			readOnly:true
        }),
		{
			fieldLabel: '<t:message code="system.label.purchase.issuedate2" default="납품일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ISSUE_DATE_FR',
			endFieldName: 'ISSUE_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			allowBlank: false
		},{
			xtype:'uniTextfield',
			fieldLabel:'<t:message code="system.label.purchase.issuenum" default="납품번호"/>',
			name:'ISSUE_NUM'
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			width: 325,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		{
			fieldLabel: '<t:message code="system.label.sales.inquiryclass" default="조회구분"/>',
			xtype: 'uniRadiogroup',
			name: 'RDO_TYPE',
			allowBlank: false,
			width: 235,
			items: [
				{boxLabel:'<t:message code="system.label.sales.master" default="마스터"/>', name:'RDO_TYPE', inputValue:'master', checked:true},
				{boxLabel:'<t:message code="system.label.sales.detail" default="디테일"/>', name:'RDO_TYPE', inputValue:'detail'}
			],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					searchInfoMasterGrid.reset();
					searchInfoMasterStore.clearData();
					searchInfoDetailGrid.reset();
					searchInfoDetailStore.clearData();
					if(newValue.RDO_TYPE=='detail') {
						if(searchInfoMasterGrid) searchInfoMasterGrid.hide();
						if(searchInfoDetailGrid) searchInfoDetailGrid.show();
					} else {
						if(searchInfoDetailGrid) searchInfoDetailGrid.hide();
						if(searchInfoMasterGrid) searchInfoMasterGrid.show();
					}
				}
			}
		}]
	});
	Unilite.defineModel('searchInfoMasterModel', {
		fields: [
			{name: 'ISSUE_NUM'	 	,text: '<t:message code="system.label.purchase.issuenum" default="납품번호"/>' 		,type: 'string'},
			{name: 'DIV_CODE'	 	,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 		,type: 'string',comboType:'BOR120' },
			{name: 'CUSTOM_CODE'	,text: 'CUSTOM_CODE' 		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.purchase.partners" default="협력사"/>' 		,type: 'string'},
			{name: 'ISSUE_DATE'	 	,text: '<t:message code="system.label.purchase.issuedate2" default="납품일"/>' 		,type: 'uniDate'},
			{name: 'ISSUE_Q'		,text:'<t:message code="system.label.sales.issueqty" default="출고량"/>'	  		, type: 'uniQty'}
		]
	});
	//검색창 스토어 정의
	var searchInfoMasterStore = Unilite.createStore('searchInfoMasterStore', {
		model: 'searchInfoMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'vmi210ukrvService.selectSearchInfoMasterList'
			}
		},
		loadStoreRecords : function()	{
			var param= issueNumSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var searchInfoMasterGrid = Unilite.createGrid('searchInfoMasterGrid', {
		layout : 'fit',
		store: searchInfoMasterStore,
		uniOpt:{
			useRowNumberer: true
		},
		selModel:'rowmodel',
		columns:  [
			{ dataIndex: 'ISSUE_NUM'				, width: 120 },
			{ dataIndex: 'DIV_CODE'					, width: 120 },
			{ dataIndex: 'CUSTOM_NAME'				, width: 200 },
			{ dataIndex: 'ISSUE_DATE'				, width: 90 },
			{ dataIndex: 'ISSUE_Q'					, width: 100 }
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			  	searchInfoMasterGrid.returnData(record);
			  	searchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record)	{
		  	panelSearch.setValue('ISSUE_NUM', record.get('ISSUE_NUM'));
			setTimeout(function(){
				UniAppManager.app.onQueryButtonDown();
			}, 50);
		}
	});

	Unilite.defineModel('searchInfoDetailModel', {
		fields: [
			{name: 'ISSUE_NUM'	 	,text: '<t:message code="system.label.purchase.issuenum" default="납품번호"/>' 		,type: 'string'},
			{name: 'DIV_CODE'	 	,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 		,type: 'string',comboType:'BOR120' },
			{name: 'CUSTOM_CODE'	,text: 'CUSTOM_CODE' 		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.purchase.partners" default="협력사"/>' 		,type: 'string'},
			{name: 'ISSUE_DATE'	 	,text: '<t:message code="system.label.purchase.issuedate2" default="납품일"/>' 		,type: 'uniDate'},
			{name: 'ORDER_NUM'		,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>' 		,type: 'string'},
			{name: 'ORDER_SEQ'		,text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>' 		,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.purchase.item" default="품목"/>' 		,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>' 		,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 		,type: 'string'},
			{name: 'ORDER_DATE'		,text: '<t:message code="system.label.purchase.podate" default="발주일"/>' 		,type: 'string'},
			{name: 'ISSUE_Q'		,text:'<t:message code="system.label.sales.issueqty" default="출고량"/>'	  		, type: 'uniQty'}
		]
	});

	var searchInfoDetailStore = Unilite.createStore('searchInfoDetailStore', {
		model: 'searchInfoDetailModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'vmi210ukrvService.selectSearchInfoDetailList'
			}
		},
		loadStoreRecords : function()	{
			var param= issueNumSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색창 detail그리드 정의
	var searchInfoDetailGrid = Unilite.createGrid('searchInfoDetailGrid', {
		layout : 'fit',
		store: searchInfoDetailStore,
		uniOpt:{
			useRowNumberer: false
		},
		hidden : true,
		selModel:'rowmodel',
		columns:  [
			{ dataIndex: 'ISSUE_NUM'				, width: 120 },
			{ dataIndex: 'DIV_CODE'					, width: 120 },
			{ dataIndex: 'CUSTOM_NAME'				, width: 200 },
			{ dataIndex: 'ISSUE_DATE'				, width: 90 },
			{ dataIndex: 'ORDER_NUM'				, width: 120 },
			{ dataIndex: 'ORDER_SEQ'				, width: 80,align:'center' },
			{ dataIndex: 'ITEM_CODE'				, width: 120 },
			{ dataIndex: 'ITEM_NAME'				, width: 250 },
			{ dataIndex: 'SPEC'						, width: 120 },
			{ dataIndex: 'ORDER_DATE'				, width: 90 },
			{ dataIndex: 'ISSUE_Q'					, width: 100 }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				searchInfoDetailGrid.returnData(record);
				searchInfoWindow.hide();
			}
		},
		returnData: function(record)	{
		  	panelSearch.setValue('ISSUE_NUM', record.get('ISSUE_NUM'));
			setTimeout(function(){
				UniAppManager.app.onQueryButtonDown();
			}, 50);
		}
	});

	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.issuenum2search" default="납품번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [issueNumSearch, searchInfoMasterGrid, searchInfoDetailGrid],
				tbar:  [ '->',
					{	itemId : 'searchBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							searchInfoMasterStore.loadStoreRecords();
							searchInfoDetailStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							searchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						issueNumSearch.clearForm();
						searchInfoMasterGrid.reset();
						searchInfoMasterStore.clearData();
						searchInfoDetailGrid.reset();
						searchInfoDetailStore.clearData();
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts ) {
						issueNumSearch.setValue('DIV_CODE'		,panelSearch.getValue('DIV_CODE'));
						issueNumSearch.setValue('CUSTOM_CODE'	,panelSearch.getValue('CUSTOM_CODE'));
						issueNumSearch.setValue('CUSTOM_NAME'	,panelSearch.getValue('CUSTOM_NAME'));

						issueNumSearch.setValue('ISSUE_DATE_FR'	,panelSearch.getValue('ISSUE_DATE'));
						issueNumSearch.setValue('ISSUE_DATE_TO'	,panelSearch.getValue('ISSUE_DATE'));
						panelSearch.getField('ISSUE_DATE').setReadOnly(true);

						issueNumSearch.getField('RDO_TYPE').setValue('master');
					}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}

	var referOrderSearch = Unilite.createSearchForm('referOrderForm', {
		layout :  {type : 'uniTable', columns : 2},
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			readOnly:true,
			hidden:true
//			colspan:2
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			width: 325,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315
		},{
			xtype:'uniTextfield',
			fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>',
			name:'ORDER_NUM'
		},{
			fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'DVRY_DATE_FR',
			endFieldName: 'DVRY_DATE_TO',
			width: 315
		},
        Unilite.popup('AGENT_CUST', {
            fieldLabel: '<t:message code="system.label.purchase.partners" default="협력사"/>',
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME',
			allowBlank: false,
			readOnly:true
        }),
        {
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:300,
			items :[{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.purchase.postatus" default="발주상태"/>',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: ''
				},{
					boxLabel: '<t:message code="system.label.purchase.closing" default="마감"/>',
					width: 70,
					name: 'CONTROL_STATUS',
					inputValue: '9'
				},{
					boxLabel: '<t:message code="system.label.purchase.proceeding" default="진행중"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '1',
					checked: true
				}]
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {
//						setTimeout(function(){
//							referOrderStore.loadStoreRecords();
//						}, 50);
//					}
//				}
			}]
		}]
	});
	Unilite.defineModel('referOrderModel', {
		fields: [

			{name: 'DIV_CODE'	 	,text: 'DIV_CODE' 		,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: 'CUSTOM_CODE' 	,type: 'string'},
			{name: 'ORDER_NUM'		,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'ORDER_SEQ'		,text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'string'},
			{name: 'ORDER_DATE'		,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			, type: 'uniDate'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.purchase.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'			, type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'TOTAL_ISSUE_Q'	,text: '납품예정량'				, type: 'uniQty'},
			{name: 'ORDER_Q'		,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				, type: 'uniQty'},
			{name: 'DVRY_DATE'		,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'DVRY_ESTI_DATE'	,text: '<t:message code="system.label.purchase.dvryestidate" default="납품예정일"/>'	, type: 'uniDate'},
			{name: 'UN_Q'			,text: '<t:message code="system.label.purchase.undeliveryqty" default="미납량"/>'		, type: 'uniQty'},
			{name: 'WH_CODE'		,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>', type: 'string', comboType:'AU', comboCode:'M002'},
			{name: 'REMARK'			,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},

			{name: 'SO_NUM'	 	 	,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>' 		 			,type: 'string'},
			{name: 'SO_SEQ'	 		,text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>' 	 			,type: 'int'},

			{name: 'SOF_CUSTOM_NAME'		,text: '수주처'			,type:'string'},
			{name: 'SOF_ITEM_NAME'		,text: '수주품명'			,type:'string'}
		]
	});

	var referOrderStore = Unilite.createStore('referOrderStore', {
		model: 'referOrderModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'vmi210ukrvService.selectReferOrderiList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)	{
				   var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
				   var deleteRecords = new Array();
				   if(masterRecords.items.length > 0)	{
				   Ext.each(records,
			   			function(item, i)	{
							Ext.each(masterRecords.items, function(record, i)	{
									if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
										&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ'])
										){
											deleteRecords.push(item);
									}
							});
			   			});
				   store.remove(deleteRecords);
				   }
				}
			}
		},
		loadStoreRecords : function()	{
			var param= referOrderSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	var referOrderGrid = Unilite.createGrid('referOrderGrid', {
		layout : 'fit',
		store: referOrderStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE' }),
		uniOpt:{
			onLoadSelectFirst : false,
			useRowNumberer: false
		},
		columns:  [
			{ dataIndex: 'SO_NUM'	 	  , width: 100, hidden: true},
			{ dataIndex: 'SO_SEQ'	  	  , width: 80, hidden: true},
			{ dataIndex: 'SOF_CUSTOM_NAME'	, width: 150, hidden: true},
			{ dataIndex: 'SOF_ITEM_NAME'	, width: 200, hidden: true},
			{ dataIndex: 'ORDER_NUM'		,  width: 120 },
			{ dataIndex: 'ORDER_SEQ'		,  width: 60,align:'center'},
			{ dataIndex: 'ORDER_DATE'		,  width: 90 },
			{ dataIndex: 'ITEM_CODE'		,  width: 120 },
			{ dataIndex: 'ITEM_NAME'		,  width: 250 },
			{ dataIndex: 'SPEC'				,  width: 120 },
			{ dataIndex: 'TOTAL_ISSUE_Q'	,  width: 100 },
			{ dataIndex: 'ORDER_Q'			,  width: 100 },
			{ dataIndex: 'DVRY_DATE'		,  width: 90 },
			{ dataIndex: 'DVRY_ESTI_DATE'	,  width: 90 },
			{ dataIndex: 'UN_Q'				,  width: 100 },
			{ dataIndex: 'WH_CODE'			,  width: 120 },
			{ dataIndex: 'REMARK'			,  width: 300 }
		]
	   ,listeners: {
	  		onGridDblClick:function(grid, record, cellIndex, colName) {

			}
   		}
	   	,returnData: function()	{
       		var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
	        	UniAppManager.app.onNewDataButtonDown();
	        	detailGrid.setIssueNumData(record.data);
		    });
			this.getStore().remove(records);
       	}

	});

	function openReferOrderWindow() {
		if(!referOrderWindow) {
			referOrderWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.porefer" default="발주참조"/>',
				width: 1080,
				height: 570,
				layout:{type:'vbox', align:'stretch'},
				items: [referOrderSearch, referOrderGrid],
				tbar:  ['->',
					{	itemId : 'searchBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							referOrderStore.loadStoreRecords();
						},
						disabled: false
					},
					{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.apply" default="적용"/>',
						handler: function() {
							referOrderGrid.returnData();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.afterapplyclose" default="적용 후 닫기"/>',
						handler: function() {
							referOrderGrid.returnData();
							referOrderWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							referOrderWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						referOrderSearch.clearForm();
						referOrderGrid.reset();
						referOrderStore.clearData();
					},
					beforeclose: function( panel, eOpts )	{
					},
					beforeshow: function ( me, eOpts )	{
						panelSearch.getField('ISSUE_DATE').setReadOnly(true);
						referOrderSearch.setValue('DIV_CODE'		,panelSearch.getValue('DIV_CODE'));
						referOrderSearch.setValue('ORDER_DATE_FR'	,UniDate.get('startOfMonth'));
						referOrderSearch.setValue('ORDER_DATE_TO'	,UniDate.get('today'));

						referOrderSearch.getField('CONTROL_STATUS').setValue('1');
						referOrderSearch.setValue('CUSTOM_CODE'		,panelSearch.getValue('CUSTOM_CODE'));
						referOrderSearch.setValue('CUSTOM_NAME'		,panelSearch.getValue('CUSTOM_NAME'));
					}
				}
			})
		}
		referOrderWindow.center();
		referOrderWindow.show();
	}

    /***************************
     *라벨 출력 코드
     *2019-12-09
     ***************************/

   	var labelPrintSearch = Unilite.createSearchForm('labelPrintForm', {
   		//layout		: {type:'vbox', align:'center', pack: 'center' },
   		layout	: {type : 'uniTable', columns : 1},
   		border:true,
   		items	: [{	fieldLabel	: '<t:message code="system.label.purchase.oemitemcode" default="품번"/>',
			   			name		: 'LABEL_ITEM_CODE',
			   			xtype		: 'uniTextfield',
			   			margin  	: '0 0 0 0',
			   			hidden		: false,
			   			readOnly	: true,
			   			fieldStyle: 'text-align: center;',
			   			listeners	: {
			   				change: function(field, newValue, oldValue, eOpts) {
			   				}
			   			}
			   		},{
			          	fieldLabel: '입고일',
							xtype: 'uniDatefield',
							name: 'DVRY_ESTI_DATE',
							value:UniDate.get('today'),
				//			fieldStyle: 'text-align: center;background-color: yellow; background-image: none;',
							readOnly : false,
							allowBlank:false
					},{
			          	fieldLabel: 'ORDER_NUM',
						xtype: 'uniTextfield',
						name: 'ORDER_NUM',
						hidden: true,
						readOnly : false,
						allowBlank:false
					},{
			          	fieldLabel: 'ORDER_SEQ',
						xtype: 'uniNumberfield',
						name: 'ORDER_SEQ',
						hidden: true,
						readOnly : false,
						allowBlank:false
					},{
			  			fieldLabel	: '<t:message code="system.label.sales.packunitq" default="BOX입수"/>',
			  			xtype		: 'uniNumberfield',
			  			name		: 'PACK_UNIT_Q',
			  			value		: 1,
			  			allowBlank	: true,
			  			hidden	: false,
			  			fieldStyle: 'text-align: center;'
			  			//holdable	: 'hold'
  					},{
			  			fieldLabel	: '<t:message code="system.label.sales.boxq" default="BOX수"/>',
			  			xtype		: 'uniNumberfield',
			  			name		: 'BOX_Q',
			  			value		: 1,
			  			allowBlank	: true,
			  			hidden	: false,
			  			fieldStyle: 'text-align: center;'
			  			//holdable	: 'hold'
  					},{
			  			fieldLabel	: '<t:message code="system.label.sales.eachq" default="낱개"/>',
			  			xtype		: 'uniNumberfield',
			  			name		: 'EACH_Q',
			  			value		: 1,
			  			allowBlank	: true,
			  			hidden	: false,
			  			fieldStyle: 'text-align: center;'
			  			//holdable	: 'hold'
  					},{
			  			fieldLabel	: '<t:message code="system.label.product.qty" default="수량"/>',
			  			xtype		: 'uniNumberfield',
			  			name		: 'ISSUE_QTY',
			  			value		: 1,
			  			allowBlank	: true,
			  			hidden	: false,
			  			fieldStyle: 'text-align: center;'
			  			//holdable	: 'hold'
  					},{
			  			fieldLabel	: '<t:message code="system.label.purchase.printqty" default="출력매수"/>',
			  			xtype		: 'uniNumberfield',
			  			name		: 'LABEL_QTY',
			  			margin  	: '0 0 0 0',
			  			value		: 1,
			  			allowBlank	: true,
			  			hidden	: false,
			  			fieldStyle: 'text-align: center;'
			  			//holdable	: 'hold'
  					}, {
		                xtype: 'radiogroup',
		                fieldLabel: '구분',
		                id: 'PRINT_GUBUN',
		                items: [{
		                    boxLabel: '라벨',
		                    width: 70,
		                    name: 'PRINT_GUBUN',
		                    inputValue: 'A',
		                    checked: true
		                }, {
		                    boxLabel: 'A4',
		                    width: 70,
		                    inputValue: 'B',
		                    name: 'PRINT_GUBUN'
		                }]
		            },{	xtype		: 'container',
						defaultType	: 'uniTextfield',
						margin		: '0 0 0 60',
						layout		: {type : 'uniTable', columns : 2,align:'center', pack: 'center'},
						items		: [{	xtype	: 'button',
							 				name	: 'labelPrint',
							 				text	: '<t:message code="system.label.product.labelprint" default="라벨출력"/>',
							 				width	: 80,
							 				hidden	: false,
							 				handler : function() {

									              var param = panelSearch.getValues();
									            	  param["ORDER_NUM"]= labelPrintSearch.getValue('ORDER_NUM');
									            	  param["ORDER_SEQ"]= labelPrintSearch.getValue('ORDER_SEQ');
									            	  param["PRINT_CNT"]= labelPrintSearch.getValue('LABEL_QTY');
									            	  if(labelPrintSearch.getValue('BOX_Q') > 0){//박스 입수, 수량을 사용했을 경우
									            		  param["ISSUE_QTY"]= labelPrintSearch.getValue('PACK_UNIT_Q');
									            		  if(labelPrintSearch.getValue('EACH_Q') == 0){
									            			  param["LAST_QTY"]= labelPrintSearch.getValue('PACK_UNIT_Q');
									            		  }else{
									            			  param["LAST_QTY"]= labelPrintSearch.getValue('EACH_Q');
									            		  }

									            	  }else{
									            		  param["ISSUE_QTY"]= labelPrintSearch.getValue('ISSUE_QTY');
									            		  param["LAST_QTY"]= labelPrintSearch.getValue('ISSUE_QTY');
									            	  }

									            	  param["DVRY_ESTI_DATE"]= UniDate.getDbDateStr(labelPrintSearch.getValue('DVRY_ESTI_DATE'));

									            	  param["PRINT_GUBUN"]= labelPrintSearch.getValue('PRINT_GUBUN').PRINT_GUBUN;

									              param["sTxtValue2_fileTitle"]='라벨 출력';
									              param["RPT_ID"]='vmi210clukrv';
									              param["PGM_ID"]='vmi210ukrv';
									              param["MAIN_CODE"]='M030';
												  if(BsaCodeInfo.gsSiteCode == 'SHIN'){
													  param["GUBUN"]='SHIN';
												  }else{
													  param["GUBUN"]='STANDARD';
												  }
									              var win  = Ext.create('widget.ClipReport', {
									 		                url: CPATH+'/vmi/vmi210clukrv_label.do',
									 		                prgID: 'vmi210ukrv',
									 		                extParam: param
									 		            });
								 					win.center();
								 					win.show();
							 				}
							 			},{
							 				xtype	: 'button',
							 				name	: 'btnCancel',
							 				text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
							 				width	: 80,
							 				hidden	: false,
							 				handler	: function() {
							 					labelPrintSearch.clearForm();
							 					labelPrintWindow.hide();
							 					labelPrintWindow = '';
							 				}
							 }]
 			}]
   	});

   	function openLabelPrintWindow( gsSelRecord ) {
 		//if(!UniAppManager.app.checkForNewDetail()) return false;
 		if(!labelPrintWindow) {
 			labelPrintWindow = Ext.create('widget.uniDetailWindow', {
 				title		: '<t:message code="system.label.purchase.label" default="라벨"/><t:message code="system.label.purchase.print" default="출력"/>',
 				width		: 300,
 				height		: 285,
 		 		resizable	: false,
 				layout		:{type:'vbox', align:'stretch'},
 				items		: [labelPrintSearch],
 				listeners	: {
 					beforehide	: function(me, eOpt) {
 						labelPrintSearch.clearForm();
 					},
 					beforeclose: function( panel, eOpts ) {

 					},
 					beforeshow: function ( me, eOpts ) {
 						//var selectedDetailRecord = detailGrid.getSelectedRecord();
 						labelPrintSearch.setValue('LABEL_ITEM_CODE', gsSelRecord.ITEM_CODE );
 						labelPrintSearch.setValue('ORDER_NUM', 	 gsSelRecord.ORDER_NUM );
 						labelPrintSearch.setValue('ORDER_SEQ', 	 gsSelRecord.ORDER_SEQ );
 						labelPrintSearch.setValue('PACK_UNIT_Q', gsSelRecord.PACK_UNIT_Q );
 						labelPrintSearch.setValue('BOX_Q', 		 gsSelRecord.BOX_Q );
 						labelPrintSearch.setValue('EACH_Q', 	 gsSelRecord.EACH_Q );
 						labelPrintSearch.setValue('ISSUE_QTY', 	 gsSelRecord.ISSUE_Q );
 						if(gsSelRecord.BOX_Q > 0){
 							fn_printQtyCal();
 						}else{
 							labelPrintSearch.setValue('LABEL_QTY', 1);
 						}
 						if(Ext.isEmpty(gsSelRecord.DVRY_ESTI_DATE)){
 							labelPrintSearch.setValue('DVRY_ESTI_DATE', UniDate.get('today') );
 						}else{
 							labelPrintSearch.setValue('DVRY_ESTI_DATE', gsSelRecord.DVRY_ESTI_DATE );
 						}

 					},
					show: function(me, eOpts) {

					}
 				}
 			})
 		}
 		labelPrintWindow.center();
 		labelPrintWindow.show();
 	}

   	function fn_printQtyCal(){
		var packUnitQ = 0; //박스입수
		var boxQ 	  = 0; //박스수
		var eachQ 	  = 0; //낱개
		//var issueQty  = 0; //총수량
		var labelQty  = 0; //라벨출력매수
		packUnitQ = labelPrintSearch.getValue('PACK_UNIT_Q');
		boxQ 	  = labelPrintSearch.getValue('BOX_Q');
		eachQ 	  = labelPrintSearch.getValue('EACH_Q');
		labelQty  =  boxQ;
		if(eachQ > 0){
			labelQty =  labelQty + 1;
		}
		//labelPrintSearch.setValue('ISSUE_QTY', issueQty);
		labelPrintSearch.setValue('LABEL_QTY', labelQty);
   	}
	Unilite.Main({
		id: 'vmi210ukrvApp',
		border: false,
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
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
			var issueNum = panelSearch.getValue('ISSUE_NUM');
			if(Ext.isEmpty(issueNum)) {
				openSearchInfoWindow()
			} else {
				detailStore.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function()	{
			var seq = detailStore.max('ISSUE_SEQ');
        	if(!seq){
        		seq = 1;
        	}else{
        		seq += 1;
        	}
			var r = {
				DIV_CODE : panelSearch.getValue('DIV_CODE'),
				CUSTOM_CODE : panelSearch.getValue('CUSTOM_CODE'),
				ISSUE_SEQ : seq,
				ISSUE_DATE : panelSearch.getValue('ISSUE_DATE'),
				DVRY_TIME : panelSearch.getValue('DVRY_TIME')

			}
			detailGrid.createRow(r);
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)){
				if(selRow.phantom === true)	{
					detailGrid.deleteSelectedRow();
				}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid.deleteSelectedRow();
				}
			}
		},
		onSaveDataButtonDown: function(config) {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크

			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			UniAppManager.setPageTitle(PGM_TITLE);
			MODIFY_AUTH = true;
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('CUSTOM_CODE', UserInfo.customCode);
			panelSearch.setValue('CUSTOM_NAME', UserInfo.customName);
			panelSearch.setValue('ISSUE_DATE', UniDate.get('today'));

			if(getVmiUserLevel == '0'){
				panelSearch.getField('CUSTOM_CODE').setReadOnly(false);
				panelSearch.getField('CUSTOM_NAME').setReadOnly(false);
			}else{
				panelSearch.getField('CUSTOM_CODE').setReadOnly(true);
				panelSearch.getField('CUSTOM_NAME').setReadOnly(true);
			}
			panelSearch.getField('ISSUE_DATE').setReadOnly(false);
			panelSearch.down('#printButton').setDisabled(true);

			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','save'], false);
		}
	});


	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			switch(fieldName) {
				case "ISSUE_Q" :

					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						break;
					}
					if(newValue > record.get('UN_Q')){
						record.set('LOSS_Q',newValue - record.get('UN_Q'));
					}else{
						record.set('LOSS_Q',0);
					}
					record.set('PACK_UNIT_Q',0);
					record.set('BOX_Q',0);
					record.set('EACH_Q',0);

					break;

				case "PACK_UNIT_Q" :		//BOX 입수
					if(newValue * record.get('BOX_Q') + record.get('EACH_Q') > record.get('UN_Q')){			//출고수량 > 미납량
						record.set('ISSUE_Q',newValue * record.get('BOX_Q') + record.get('EACH_Q'));	//출고량
						record.set('LOSS_Q',newValue * record.get('BOX_Q') + record.get('EACH_Q') - record.get('UN_Q'));//LOSS여분 = 출고수량 - 미납량
					}else{
						record.set('ISSUE_Q',newValue * record.get('BOX_Q') + record.get('EACH_Q'));	//출고량
						record.set('LOSS_Q',0);
					}
					break;

				case "BOX_Q" :				//BOX 수
					if(record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') > record.get('UN_Q')){			//출고수량 > 미납량
						record.set('ISSUE_Q',record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q'));	//출고량
						record.set('LOSS_Q',record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') - record.get('UN_Q'));//LOSS여분 = 출고수량 - 미납량
					}else{
						record.set('ISSUE_Q',record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q'));	//출고량
						record.set('LOSS_Q',0);
					}
					break;

				case "EACH_Q" :				//낱개
					if(record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue > record.get('UN_Q')){			//출고수량 > 미납량
						record.set('ISSUE_Q',record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue);	//출고량
						record.set('LOSS_Q',record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue - record.get('UN_Q'));//LOSS여분 = 출고수량 - 미납량
					}else{
						record.set('ISSUE_Q',record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue);	//출고량
						record.set('LOSS_Q',0);
					}
					break;

				case "LOSS_Q" :				//LOSS여분

					break;
			}
			return rv;
		}
	});

};
</script>