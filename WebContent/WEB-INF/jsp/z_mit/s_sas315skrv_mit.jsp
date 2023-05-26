<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sas315skrv_mit"  >
	<t:ExtComboStore comboType="AU" comboCode="B266" /> 				<!-- 대리점 -->
	<t:ExtComboStore items="${COMBO_DIV_CODE}" storeId="divComboStore" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S164"/>								<!-- 수리랭크 -->
	<t:ExtComboStore comboType="AU" comboCode="S168"/>								<!-- 위치 -->
	<t:ExtComboStore comboType="AU" comboCode="S169"/>								<!-- 증상 -->
	<t:ExtComboStore comboType="AU" comboCode="S170"/>								<!-- 원인 -->
	<t:ExtComboStore comboType="AU" comboCode="S171"/>								<!-- 해결 -->
	<t:ExtComboStore comboType="AU" comboCode="S162"/>	                            <!-- 구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_sas315skrv_mitService.selectList'
		}
	});	
	
	Unilite.defineModel('s_sas315skrv_mitModel', {
	    fields: [  	    
	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.sales.division" default="사업장"/>'		    	, type: 'string', comboType: 'BOR120'},
			{name: 'REPAIR_DATE'			, text: '<t:message code="system.label.sales.repairdate" default="수리일"/>'				, type: 'uniDate'},
			{name: 'REPAIR_NUM'				, text: '<t:message code="system.label.sales.repairnum" default="수리번호"/>'				, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'MACHINE_TYPE'			, text: '구분'			, type: 'string'												, type: 'string', comboType: 'AU', comboCode: 'S162'},
			{name: 'SERIAL_NO'				, text: 'S/N'			, type: 'string'},
			{name: 'IN_DATE'				, text: '입고일'			, type: 'uniDate'},
			{name: 'SALE_DATE'				, text: '판매일'			, type: 'uniDate'},
			{name: 'WARR_DATE'				, text: '보증일'          , type: 'uniDate'},
			{name: 'WARR_DATE_FR'			, text: '제품보증시작일'	, type: 'uniDate'},
			{name: 'WARR_DATE_TO'			, text: '제품보증종료일'	, type: 'uniDate'},
			{name: 'RECEIPT_NUM'			, text: '관리번호'			, type: 'string'},
			{name: 'RECEIPT_DATE'			, text: '접수일'			, type: 'uniDate'},
			{name: 'RECEIPT_PRSN'			, text: '입고담당자'		, type: 'string'},
			{name: 'RECEIPT_REMARK'			, text: '병원요구사항'		, type: 'string'},
			{name: 'RECEIPT_FDA_Q1_YN'		, text: '접수 FDA 질문1'	, type: 'string'},
			{name: 'RECEIPT_FDA_Q2_YN'		, text: '접수 FDA 질문2'	, type: 'string'},
			{name: 'RECEIPT_FDA_Q3_YN'		, text: '접수 FDA 질문3'	, type: 'string'},
			{name: 'IN_CHK_DATE'			, text: '입고검사일'		, type: 'uniDate'},//견적일
			{name: 'IN_CHK_PRSN'			, text: '입고검사자'		, type: 'string'},
			{name: 'QUOT_DATE'				, text: '견적일'			, type: 'uniDate'},
			{name: 'QUOT_PRSN'				, text: '견적담당자'		, type: 'string'},
			{name: 'QUOT_REMARK'			, text: '견적담당자코멘트'	, type: 'string'},
			{name: 'QUOT_FDA_Q1_YN'		    , text: '견적 FDA 질문1'	, type: 'string'},
			{name: 'QUOT_FDA_Q2_YN'		    , text: '견적 FDA 질문2'	, type: 'string'},
			{name: 'QUOT_FDA_Q3_YN'		    , text: '견적 FDA 질문3'	, type: 'string'},
			{name: 'BAD_LOC_CODE'			, text: '위치코드1'		, type: 'string'},
			{name: 'BAD_CONDITION_CODE'	    , text: '증상코드1'		, type: 'string'},
			{name: 'BAD_REASON_CODE'		, text: '원인코드1'		, type: 'string'},
			{name: 'SOLUTION_CODE'		    , text: '해결코드1'		, type: 'string'},
			{name: 'BAD_LOC_NAME'			, text: '위치1'			, type: 'string', comboType: 'AU', comboCode: 'S168'},
			{name: 'BAD_CONDITION_NAME'	    , text: '증상1'			, type: 'string', comboType: 'AU', comboCode: 'S169'},
			{name: 'BAD_REASON_NAME'		, text: '원인1'			, type: 'string', comboType: 'AU', comboCode: 'S170'},
			{name: 'SOLUTION_NAME'		    , text: '해결1'			, type: 'string', comboType: 'AU', comboCode: 'S171'},
			{name: 'BAD_LOC_CODE2'			, text: '위치코드2'		, type: 'string'},
			{name: 'BAD_CONDITION_CODE2'	, text: '증상코드2'		, type: 'string'},
			{name: 'BAD_REASON_CODE2'		, text: '원인코드2'		, type: 'string'},
			{name: 'SOLUTION_CODE2'		    , text: '해결코드2'		, type: 'string'},
			{name: 'BAD_LOC_NAME2'			, text: '위치2'			, type: 'string', comboType: 'AU', comboCode: 'S168'},
			{name: 'BAD_CONDITION_NAME2'	, text: '증상2'			, type: 'string', comboType: 'AU', comboCode: 'S169'},
			{name: 'BAD_REASON_NAME2'		, text: '원인2'			, type: 'string', comboType: 'AU', comboCode: 'S170'},
			{name: 'SOLUTION_NAME2'		    , text: '해결2'			, type: 'string', comboType: 'AU', comboCode: 'S171'},
			{name: 'BAD_LOC_CODE3'			, text: '위치코드3'		, type: 'string'},
			{name: 'BAD_CONDITION_CODE3'	, text: '증상코드3'		, type: 'string'},
			{name: 'BAD_REASON_CODE3'		, text: '원인코드3'		, type: 'string'},
			{name: 'SOLUTION_CODE3'		    , text: '해결코드3'		, type: 'string'},
			{name: 'BAD_LOC_NAME3'			, text: '위치3'			, type: 'string', comboType: 'AU', comboCode: 'S168'},
			{name: 'BAD_CONDITION_NAME3'	, text: '증상3'			, type: 'string', comboType: 'AU', comboCode: 'S169'},
			{name: 'BAD_REASON_NAME3'		, text: '원인3'			, type: 'string', comboType: 'AU', comboCode: 'S170'},
			{name: 'SOLUTION_NAME3'		    , text: '해결3'			, type: 'string', comboType: 'AU', comboCode: 'S171'},
			{name: 'BAD_LOC_CODE4'			, text: '위치코드4'		, type: 'string'},
			{name: 'BAD_CONDITION_CODE4'	, text: '증상코드4'		, type: 'string'},
			{name: 'BAD_REASON_CODE4'		, text: '원인코드4'		, type: 'string'},
			{name: 'SOLUTION_CODE4'		    , text: '해결코드4'		, type: 'string'},
			{name: 'BAD_LOC_NAME4'			, text: '위치4'			, type: 'string', comboType: 'AU', comboCode: 'S168'},
			{name: 'BAD_CONDITION_NAME4'	, text: '증상4'			, type: 'string', comboType: 'AU', comboCode: 'S169'},
			{name: 'BAD_REASON_NAME4'		, text: '원인4'			, type: 'string', comboType: 'AU', comboCode: 'S170'},
			{name: 'SOLUTION_NAME4'		    , text: '해결4'			, type: 'string', comboType: 'AU', comboCode: 'S171'},
			{name: 'ITEM_CODE1'				, text: '부품번호1'		, type: 'string'},
			{name: 'SERIAL_NO1'				, text: 'Serial1'		, type: 'string'},
			{name: 'ITEM_CODE2'				, text: '부품번호2'		, type: 'string'},
			{name: 'SERIAL_NO2'				, text: 'Serial2'		, type: 'string'},
			{name: 'ITEM_CODE3'				, text: '부품번호3'		, type: 'string'},
			{name: 'SERIAL_NO3'				, text: 'Serial3'		, type: 'string'},
			{name: 'ITEM_CODE4'				, text: '부품번호4'		, type: 'string'},
			{name: 'SERIAL_NO4'				, text: 'Serial4'		, type: 'string'},
			{name: 'ITEM_CODE5'				, text: '부품번호5'		, type: 'string'},
			{name: 'SERIAL_NO5'				, text: 'Serial5'		, type: 'string'},
			{name: 'REPAIR_RANK'			, text: '수리랭크'			, type: 'string', comboType: 'AU', comboCode: 'S164'},
			{name: 'COST_YN'				, text: '수리종류'			, type: 'string', type: 'string', comboType: 'AU', comboCode: 'S802'},
			{name: 'AS_AMT'					, text: '수리금액'			, type: 'uniPrice'},
			{name: 'REPAIR_PRSN'			, text: '수리담당자'		, type: 'string'},
			{name: 'INSPEC_DATE'			, text: '출고검사일'		, type: 'uniDate'},
			{name: 'INSPEC_PRSN'			, text: '출고검사담당자'	, type: 'string'},
			{name: 'OUT_DATE'				, text: '출고일'			, type: 'uniDate'},
			{name: 'OUT_PRSN'				, text: '출고담당자'		, type: 'string'},
			{name: 'PRE_REPAIR_NUM'			, text: '이전수리관리번호'	, type: 'string'},
			{name: 'PRE_REPAIR_DATE'		, text: '이전수리일'	, type: 'uniDate'},
		]
	});
	
	var directMasterStore = Unilite.createStore('s_sas315skrv_mitMasterStore',{
		model: 's_sas315skrv_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
        	var serialNo = panelResult.getValue("SERIAL_NO");
        	var receiptDateFr = UniDate.getDbDateStr( panelResult.getValue("RECEIPT_DATE_FR"));
        	var receiptDateTo = UniDate.getDbDateStr( panelResult.getValue("RECEIPT_DATE_TO"));
        	if(Ext.isEmpty(serialNo) && (Ext.isEmpty(receiptDateFr) || Ext.isEmpty(receiptDateTo)))	{
        		Unilite.messageBox("접수일 또는 S/N 두 항목 중 하나는 입력해야 합니다.")
        		return;
        	}
        	if(panelResult.getInvalidMessage())	{
				var param= Ext.getCmp('resultForm').getValues();			
				this.load({
					params : param
				});
        	}
		},
		
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '대리점',
			name: 'COMP_CODE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B266',
			allowBlank: false,
			autoSelect : true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					var divCombofield = panelResult.getField("DIV_CODE");
					divCombofield.store.clearFilter(true);
					divCombofield.store.filter("option", newValue);
					if(divCombofield.store.getData().items)	{
						divCombofield.select(divCombofield.store.getData().items[0]);
					}
						
				}
			}
		},
		{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('divComboStore'),
			allowBlank: false,
			autoSelect : true
		},{
			fieldLabel		: '<t:message code="system.label.sales.receiptdate2" default="접수일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'RECEIPT_DATE_FR',
			endFieldName	: 'RECEIPT_DATE_TO',
			labelWidth       : 90,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		}
		,Unilite.popup('CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>',
			width:350,
			labelWidth       : 90
		})
		,Unilite.popup('DIV_PUMOK',{
			fieldLabel:'제품',
			width:350,
			labelWidth       : 90
		 })
	   ,Unilite.popup('DIV_PUMOK',{
			fieldLabel:'부품',
			valueFieldName   : 'PARTS_CODE',
			textFieldName    : 'PARTS_NAME',
			width:350,
			labelWidth       : 90
		 }) 
		]
	});	
	
    var masterGrid = Unilite.createGrid('s_sas315skrv_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			onLoadSelectFirst: true,
			copiedRow:true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        columns:  [
        	{dataIndex: 'DIV_CODE'				, width :100   },
			{dataIndex: 'REPAIR_DATE'			, width :100   },
			{dataIndex: 'REPAIR_NUM'			, width :120   },
			{dataIndex: 'ITEM_CODE'				, width :100   },
			{dataIndex: 'ITEM_NAME'				, width :100   },
			{dataIndex: 'CUSTOM_CODE'			, width :100   },
			{dataIndex: 'CUSTOM_NAME'			, width :130   },
			{dataIndex: 'MACHINE_TYPE'			, width :60   },
			{dataIndex: 'SERIAL_NO'				, width :100   },
			{dataIndex: 'IN_DATE'				, width :80   },
			{dataIndex: 'SALE_DATE'				, width :80   },
			{dataIndex: 'WARR_DATE_FR'			, width :100   },
			{dataIndex: 'WARR_DATE_TO'			, width :100   },
			{dataIndex: 'RECEIPT_NUM'			, width :120   },
			{dataIndex: 'RECEIPT_DATE'			, width :80   },
			{dataIndex: 'RECEIPT_PRSN'			, width :100   },
			{dataIndex: 'RECEIPT_REMARK'		, width :200   },
			{dataIndex: 'RECEIPT_FDA_Q1_YN'		, width :100   },
			{dataIndex: 'RECEIPT_FDA_Q2_YN'		, width :100   },
			{dataIndex: 'RECEIPT_FDA_Q3_YN'		, width :100   },
			{dataIndex: 'IN_CHK_DATE'			, width :80   },
			{dataIndex: 'IN_CHK_PRSN'			, width :100   },
			{dataIndex: 'QUOT_DATE'				, width :80   },
			{dataIndex: 'QUOT_PRSN'				, width :100   },
			{dataIndex: 'QUOT_REMARK'			, width :200   },
			{dataIndex: 'QUOT_FDA_Q1_YN'		, width :100   },
			{dataIndex: 'QUOT_FDA_Q2_YN'		, width :100   },
			{dataIndex: 'QUOT_FDA_Q3_YN'		, width :100   },
			{dataIndex: 'BAD_LOC_CODE'			, width :80   },
			{dataIndex: 'BAD_LOC_NAME'			, width :200   },
			{dataIndex: 'BAD_CONDITION_CODE'	, width :80   },
			{dataIndex: 'BAD_CONDITION_NAME'	, width :200   },
			{dataIndex: 'BAD_REASON_CODE'		, width :80   },
			{dataIndex: 'BAD_REASON_NAME'		, width :200   },
			{dataIndex: 'SOLUTION_CODE'		    , width :80   },
			{dataIndex: 'SOLUTION_NAME'			, width :200   },
			{dataIndex: 'BAD_LOC_CODE2'			, width :80   },
			{dataIndex: 'BAD_LOC_NAME2'			, width :200   },
			{dataIndex: 'BAD_CONDITION_CODE2'	, width :80   },
			{dataIndex: 'BAD_CONDITION_NAME2'	, width :200   },
			{dataIndex: 'BAD_REASON_CODE2'		, width :80   },
			{dataIndex: 'BAD_REASON_NAME2'		, width :200   },
			{dataIndex: 'SOLUTION_CODE2'		, width :80   },
			{dataIndex: 'SOLUTION_NAME2'		, width :200   },
			{dataIndex: 'BAD_LOC_CODE3'			, width :80   },
			{dataIndex: 'BAD_LOC_NAME3'			, width :200   },
			{dataIndex: 'BAD_CONDITION_CODE3'	, width :80   },
			{dataIndex: 'BAD_CONDITION_NAME3'	, width :200   },
			{dataIndex: 'BAD_REASON_CODE3'		, width :80   },
			{dataIndex: 'BAD_REASON_NAME3'		, width :200   },
			{dataIndex: 'SOLUTION_CODE3'		, width :80   },
			{dataIndex: 'SOLUTION_NAME3'		, width :200   },
			{dataIndex: 'BAD_LOC_CODE4'			, width :80   },
			{dataIndex: 'BAD_LOC_NAME4'			, width :200   },
			{dataIndex: 'BAD_CONDITION_CODE4'	, width :80   },
			{dataIndex: 'BAD_CONDITION_NAME4'	, width :200   },
			{dataIndex: 'BAD_REASON_CODE4'		, width :80   },
			{dataIndex: 'BAD_REASON_NAME4'		, width :200   },
			{dataIndex: 'SOLUTION_CODE4'		, width :80   },
			{dataIndex: 'SOLUTION_NAME4'		, width :200   },
			{dataIndex: 'ITEM_CODE1'		    , width :100   },
			{dataIndex: 'SERIAL_NO1'			, width :100   },
			{dataIndex: 'ITEM_CODE2'			, width :100   },
			{dataIndex: 'SERIAL_NO2'			, width :100   },
			{dataIndex: 'ITEM_CODE3'			, width :100   },
			{dataIndex: 'SERIAL_NO3'			, width :100   },
			{dataIndex: 'ITEM_CODE4'			, width :100   },
			{dataIndex: 'SERIAL_NO4'			, width :100   },
			{dataIndex: 'ITEM_CODE5'			, width :100   },
			{dataIndex: 'SERIAL_NO5'			, width :100   },
			{dataIndex: 'REPAIR_RANK'			, width :80   },
			{dataIndex: 'COST_YN'				, width :80   },
			{dataIndex: 'AS_AMT'				, width :80   },
			{dataIndex: 'REPAIR_PRSN'			, width :100   },
			{dataIndex: 'INSPEC_DATE'			, width :100   },
			{dataIndex: 'INSPEC_PRSN'			, width :100   },
			{dataIndex: 'OUT_DATE'				, width :80   },
			{dataIndex: 'OUT_PRSN'				, width :100   },
			{dataIndex: 'PRE_REPAIR_NUM'		, width :150   },
			{dataIndex: 'PRE_REPAIR_DATE'		, width :100   }
		]
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_sas315skrv_mitApp',
		fnInitBinding : function() {
			panelResult.getField('COMP_CODE').select(panelResult.getField('COMP_CODE').store.getData().items[0]);
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {		
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore.clearData();
			this.fnInitBinding();
		}
	});
};


</script>
