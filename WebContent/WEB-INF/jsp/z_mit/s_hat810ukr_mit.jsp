<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat810ukr_mit"  >
<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="B030" /> <!-- 세액구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H147" /> <!-- 입퇴사구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A043" /> <!-- 지급/공제구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 -->
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B027" /> <!-- 구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	var excelWindow1;

	    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 's_hat810ukr_mitService.selectList',
            update  : 's_hat810ukr_mitService.updateList',
            create  : 's_hat810ukr_mitService.insertList',
            destroy : 's_hat810ukr_mitService.deleteList',
            syncAll : 's_hat810ukr_mitService.saveAll'
        }
    });

	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('s_hat810ukr_mitModel', {
		fields: [
			{name : 'DUTY_YYMM'			, text : '연차월'				, type : 'string'   	},
			{name : 'MAKE_SALE'			, text : '구분'				, type : 'string'	, comboType : 'AU', comboCode:'B027' , editable : false},
			{name : 'DEPT_CODE'			, text : '부서코드'			, type : 'string'	, editable : false},
			{name : 'DEPT_NAME'			, text : '부서명'				, type : 'string'	, editable : false},
			{name : 'PJT_CODE'			, text : '프로젝트'			, type : 'string'	, editable : false},
			{name : 'PJT_NAME'			, text : '프로젝트명'			, type : 'string'	, editable : false},
			{name : 'NAME'				, text : '성명'				, type : 'string'	, editable : false},
			{name : 'PERSON_NUMB'		, text : '사번'				, type : 'string'	, editable : false},
			{name : 'JOIN_DATE'			, text : '입사일'		    	, type : 'uniDate'	, editable : true},
			{name : 'IWALL_SAVE'       	, text : '전년이월연차'        	, type : 'float'    , editable : true	, format:'0,000.00'	, decimalPrecision : 2},
			{name : 'LONG_YEAR'         , text : '근속년수'           	, type : 'int'      , editable : true	, format:'0,000'	, decimalPrecision : 0},
			{name : 'YEAR_SAVE'         , text : '발생연차'           	, type : 'float'    , editable : true	, format:'0,000.00'	, decimalPrecision : 2},
			{name : 'YEAR_NUM'          , text : '이월반영'           	, type : 'float'    , editable : false	, format:'0,000.00'	, decimalPrecision : 2},
			{name : 'JOIN_YEAR_SAVE'    , text : '1년미만입사자 발생연차' , type : 'float'    , editable : true	, format:'0,000.00' , decimalPrecision : 2},
			{name : 'YEAR_USE'          , text : '사용연차'           	, type : 'float'    , editable : true	, format:'0,000.00'	, decimalPrecision : 2},
			{name : 'YEAR_PROV'         , text : '정산연차수'          , type : 'float'    , editable : false	, format:'0,000.00'	, decimalPrecision : 2},
			{name : 'AMOUNT_I'          , text : '통상임금(일급)'       , type : 'int'      , editable : true	, format:'0,000'	, decimalPrecision : 0},
			{name : 'AMTTOPAY'          , text : '지급금액'           	, type : 'int'      , editable : false	, format:'0,000'	, decimalPrecision : 0},
			{name : 'NEXT_IWALL_SAVE'   , text : '차년이월연차'        	, type : 'float'    , editable : false	, format:'0,000.00' , decimalPrecision : 2},
			{name : 'FLAG'              , text : '비고'              	, type : 'string'   , editable : false}
			
		]
	});		//End of Unilite.defineModel('s_hat810ukr_mitModel', {


	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_hat810ukr_mitMasterStore1', {
		model: 's_hat810ukr_mitModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,			// 삭제 가능 여부
			allDeletable: true,
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy   : directProxy,
		loadStoreRecords: function(){
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params: param,
				callback: function(records, operation, success) {
					if(success){
						Ext.each(records, function(record, idx)	{
							if(record.get("FLAG") == "S")	{
								record.set("FLAG", "신규");
							}
						});
					}
				}
			});
		},
		saveStore : function()  {
            var inValidRecs = this.getInvalidRecords();

            if(inValidRecs.length == 0 )    {
                
                this.syncAllDirect();

            }else {
                masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
	});//End of var directMasterStore1 = Unilite.createStore('s_hat810ukr_mitMasterStore1', {

	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns :	3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '조회월',
//			xtype: 'uniTextfield',
			xtype: 'uniMonthfield',
			name: 'DUTY_YYMM',
			value: new Date().getFullYear(),
			allowBlank: false
		},{
			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		},
        Unilite.treePopup('DEPTTREE',{
			fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true
		}),
	     	Unilite.popup('Employee',{
			autoPopup:true,
			validateBlank: false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelResult.setValue('NAME', panelResult.getValue('NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('PERSON_NUMB', '');
                    panelResult.setValue('NAME', '');
				}
			}
		}),{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
			items: [{
				boxLabel: '<t:message code="system.label.human.whole" default="전체"/>',
				width: 70,
				name: 'rdoSelect',
				inputValue: 'ALL',
				checked: true
			},{
				boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>',
				width: 70,
				name: 'rdoSelect',
				inputValue: 'Y'
			},{
				boxLabel : '퇴직',
				width: 70,
				name: 'rdoSelect',
				inputValue: 'N'
			}]
		}]
    });

	var masterGrid = Unilite.createGrid('s_hat810ukr_mitGrid1', {
    	// for tab
    	region: 'center',
    	flex:1,
    	store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal1',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	},{
    		id: 'masterGridTotal1',
    		ftype: 'uniSummary',
    		showSummaryRow: true
    	}],
		columns: [
			  {dataIndex: 'DUTY_YYMM'				, width: 60      , align : 'center', hidden : true}
			, {dataIndex: 'MAKE_SALE'			, width: 60,
				   summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '합계');
			  }}
			, {dataIndex: 'DEPT_CODE'			, width: 100  , hidden: true}
			, {dataIndex: 'DEPT_NAME'			, width: 140}
			, {dataIndex: 'PJT_CODE'			, width: 100  , hidden: true}
			, {dataIndex: 'PJT_NAME'			, width: 140}
			, {dataIndex: 'PERSON_NUMB'			, width: 90   , hidden: true}
			, {dataIndex: 'NAME'				, width: 100}
			, {dataIndex: 'JOIN_DATE'			, width: 90}
			, {dataIndex : 'IWALL_SAVE'         , width : 110  , summaryType : 'sum', summaryRenderer:function(value, summaryData, dataIndex, metaData ) {	return Ext.util.Format.number(value, '0,000.00');} }
			, {dataIndex : 'LONG_YEAR'        	, width : 80  }
			, {dataIndex : 'YEAR_SAVE'       	, width : 80  , summaryType : 'sum' , summaryRenderer:function(value, summaryData, dataIndex, metaData ) {	return Ext.util.Format.number(value, '0,000.00');} }
			, {dataIndex : 'YEAR_NUM'         	, width : 80  , summaryType : 'sum' , summaryRenderer:function(value, summaryData, dataIndex, metaData ) {	return Ext.util.Format.number(value, '0,000.00');} }
			, {dataIndex : 'JOIN_YEAR_SAVE'   	, width : 180 , summaryType : 'sum' , summaryRenderer:function(value, summaryData, dataIndex, metaData ) {	return Ext.util.Format.number(value, '0,000.00');} }
			, {dataIndex : 'YEAR_USE'         	, width : 80  , summaryType : 'sum' , summaryRenderer:function(value, summaryData, dataIndex, metaData ) {	return Ext.util.Format.number(value, '0,000.00');} }
			, {dataIndex : 'YEAR_PROV'        	, width : 100 , summaryType : 'sum' , summaryRenderer:function(value, summaryData, dataIndex, metaData ) {	return Ext.util.Format.number(value, '0,000.00');} }
			, {dataIndex : 'AMOUNT_I'         	, width : 120 , summaryType : 'sum' , summaryRenderer:function(value, summaryData, dataIndex, metaData ) {	return Ext.util.Format.number(value, '0,000');} }
			, {dataIndex : 'AMTTOPAY'       	, width : 100 , summaryType : 'sum' , summaryRenderer:function(value, summaryData, dataIndex, metaData ) {	return Ext.util.Format.number(value, '0,000');} }
			, {dataIndex : 'NEXT_IWALL_SAVE'    , width : 110 , summaryType : 'sum' , summaryRenderer:function(value, summaryData, dataIndex, metaData ) {	return Ext.util.Format.number(value, '0,000.00');} }
			, {dataIndex : 'FLAG'               , flex :  1}
		]
	});//End of var masterGrid = Unilite.createGr100id('s_hat810ukr_mitGrid1', {

	Unilite.Main( {
		borderItems:[
			masterGrid, 
			panelResult
		],
		id: 's_hat810ukr_mitApp',
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DUTY_YYMM',UniDate.get('today'));

			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons(['save','newData'],false);
			panelResult.onLoadSelectText('DUTY_YYMM');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onSaveDataButtonDown: function(selector) {
			directMasterStore.saveStore();
		},
		onResetButtonDown: function() {		
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			if(panelResult.getInvalidMessage())	{
				if(confirm("저장된 데이터가 삭제됩니다. 그래도 하시겠습니까?’"))	{
					var param = panelResult.getValues();
					s_hat810ukr_mitService.deleteAll(param, function(responseText, response){
						if(responseText)	{
							UniAppManager.updateStatus("삭제되었습니다.");
							UniAppManager.app.onResetButtonDown();
						}
				    })
				}
			}
		},
		setAnnualLeave : function(record, iwallSave, yearSave, joinYearSave, yearUse, amountI )	{

			var rec = record.obj;
			var yearNum = 0.0 , yearProv = 0.0 , amtToPay = 0.0  , nextIwallSave = 0.0;
			/*이월반영 = 전년이월연차 + 발생연차 */
			yearNum = parseFloat(iwallSave) + parseFloat(yearSave);
			
			/*정산연차수 = 전년이월연차+발생연차 + 1년미만입사자발생연차-사용연차 */
			yearProv = yearNum + parseFloat(joinYearSave) - parseFloat(yearUse);
			
			/*지급금액 = 정산연차수*통상임금 */
			amtToPay = Unilite.multiply(yearProv , amountI);
			
			/*차년이월연차 = 정산연차수가 (-)인 경우 표시 */
			if(yearProv < 0 )	{
				nextIwallSave = yearProv;
			}
			
			rec.set('YEAR_NUM', yearNum);
			rec.set('YEAR_PROV',yearProv);
			rec.set('AMTTOPAY',amtToPay);
			rec.set('NEXT_IWALL_SAVE',nextIwallSave);
		}
	});//End of Unilite.Main( {
		
	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue)	{
				return true;
			}
			var rv = true;
			switch(fieldName)	{
				case 'JOIN_DATE':
						var iwallSave, yearSave, joinYearSave, yearUse, amountI;
						iwallSave = record.get("IWALL_SAVE"), yearSave = record.get("YEAR_SAVE"), joinYearSave = record.get("JOIN_YEAR_SAVE"), yearUse = record.get("YEAR_USE"), amountI = record.get("AMOUNT_I")
						Ext.getBody().mask();
						s_hat800ukr_mitService.getLongYearSave_mit({'DUTY_DATE' : record.get("DUTY_YYMM"), 'JOIN_DATE': UniDate.getDbDateStr(newValue)}, function(responseText){
							Ext.getBody().unmask();
							if(responseText)	{
								record.obj.set("LONG_YEAR" , responseText.LONG_YEAR);
								joinYearSave = responseText.JOIN_YEAR_SAVE;
								record.obj.set('JOIN_YEAR_SAVE', joinYearSave);
								UniAppManager.app.setAnnualLeave(record, iwallSave, yearSave, joinYearSave, yearUse, amountI);
							}
						})
					break;
				case 'IWALL_SAVE':
						var iwallSave, yearSave, joinYearSave, yearUse, amountI;
						iwallSave = newValue, yearSave = record.get("YEAR_SAVE"), joinYearSave = record.get("JOIN_YEAR_SAVE"), yearUse = record.get("YEAR_USE"), amountI = record.get("AMOUNT_I");
						UniAppManager.app.setAnnualLeave(record, iwallSave, yearSave, joinYearSave, yearUse, amountI);
					break;
				case 'YEAR_SAVE':
						var iwallSave, yearSave, joinYearSave, yearUse, amountI;
						iwallSave = record.get("IWALL_SAVE"), yearSave = newValue, joinYearSave =  record.get("JOIN_YEAR_SAVE"), yearUse = record.get("YEAR_USE"), amountI = record.get("AMOUNT_I");
						UniAppManager.app.setAnnualLeave(record, iwallSave, yearSave, joinYearSave, yearUse, amountI);
					break;
				case 'JOIN_YEAR_SAVE':
						var iwallSave, yearSave, joinYearSave, yearUse, amountI;
						iwallSave = record.get("IWALL_SAVE"), yearSave = record.get("YEAR_SAVE"), joinYearSave = newValue, yearUse = record.get("YEAR_USE"), amountI = record.get("AMOUNT_I");
						UniAppManager.app.setAnnualLeave(record, iwallSave, yearSave, joinYearSave, yearUse, amountI);
					break;
				case 'YEAR_USE':
						var iwallSave, yearSave, joinYearSave, yearUse, amountI;
						iwallSave = record.get("IWALL_SAVE"), yearSave = record.get("YEAR_SAVE"), joinYearSave = record.get("JOIN_YEAR_SAVE"), yearUse = newValue, amountI = record.get("AMOUNT_I");
						UniAppManager.app.setAnnualLeave(record, iwallSave, yearSave, joinYearSave, yearUse, amountI);
					break;
				case 'AMOUNT_I':
						var iwallSave, yearSave, joinYearSave, yearUse, amountI;
						iwallSave = record.get("IWALL_SAVE"), yearSave = record.get("YEAR_SAVE"), joinYearSave = record.get("JOIN_YEAR_SAVE"), yearUse = record.get("YEAR_USE"), amountI = newValue;
						UniAppManager.app.setAnnualLeave(record, iwallSave, yearSave, joinYearSave, yearUse, amountI);
					break;
				default:
					break;
			}
			return rv;
			
		}
	});
};


</script>
