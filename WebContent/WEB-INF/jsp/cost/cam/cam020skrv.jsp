<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cam020skrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />	<!-- 생산구분 -->	
	<t:ExtComboStore comboType="AU" comboCode="B018" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var yearEvaluationYN = '${YEAR_EVALUATION_YN}';
var workMonthFr 	 = '${WORK_MONTH_FR}';
function appMain() {

	//모델 정의
    var cam020skrvModel = Unilite.defineModel('cam020skrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string'},
			{name: 'WORK_MONTH'		, text: 'WORK_MONTH'	, type: 'string'},
			{name: 'COST_POOL_CODE'	, text: '부문'			, type: 'string'},
			{name: 'COST_POOL_NAME'	, text: '부문명'			, type: 'string'},
			{name: 'DISTR_PERSON'	, text: '인원'			, type: 'uniPrice'},
			{name: 'DISTR_PAY'		, text: '급여액'			, type: 'uniPrice'},
			{name: 'DISTR_ASST'		, text: '상각비'			, type: 'uniPrice'},
			{name: 'DISTR_PRODT'	, text: '생산량'			, type: 'uniPrice'},
			{name: 'DISTR_MANHOUR'	, text: '표준공수*생산량'		, type: 'uniPrice'},
			{name: 'DISTR_SALES'	, text: '매출액'			, type: 'uniPrice'},
			{name: 'DISTR_SALES_QTY', text: '매출량'			, type: 'uniPrice'},
			{name: 'DISTR_ACCOUNT'	, text: '품목계정'		, type: 'uniPrice'},
			{name: 'DISTR_ITEM_LEVEL',text: '품목분류'		, type: 'uniPrice'},
			{name: 'AMT'			, text: '제조간접비'			, type: 'uniPrice'},
			{name: 'UNIT_AMT'		, text: '시간당배부액'			, type: 'uniPrice'},
			{name: 'APPORTION_YN'	, text: '배부여부'		, type: 'string', comboType:'AU' ,comboCode:'B018'}
		]
   	});
   
	//스토어 정의
	var cam020skrvStore = Unilite.createStore('Store', {	
   		model: 'cam020skrvModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable:false,		// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'cam020skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param = panelResult.getValues();	
			
			console.log("param", param);
			this.load({
				params : param
			});
		}
   	});

	// Grid 정의
    var masterGrid = Unilite.createGrid('cam020skrvGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '부문별 배부기준 집계현황',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: cam020skrvStore,
        columns: [
            {dataIndex: 'COST_POOL_CODE', width: 100,
           	 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
     			return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
          	 }},
            {dataIndex: 'COST_POOL_NAME', width: 150},
//             {dataIndex: 'DISTR_PERSON'	, width: 120},
            {dataIndex: 'DISTR_PRODT'	, width: 120	, summaryType: 'sum'},
            {dataIndex: 'DISTR_MANHOUR'	, width: 150	, summaryType: 'sum'},

            {dataIndex: 'DISTR_SALES'	, width: 120    , summaryType: 'sum'},
            {dataIndex: 'DISTR_SALES_QTY', width: 120    , summaryType: 'sum'},
            {dataIndex: 'DISTR_ASST'    , width: 120    , summaryType: 'sum'},
            {dataIndex: 'DISTR_PAY'     , width: 120    , summaryType: 'sum'},
            {dataIndex: 'AMT'			, width: 120	, summaryType: 'sum'},
            {dataIndex: 'UNIT_AMT'		, width: 120},
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
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				name: 'DIV_CODE', 
				fieldLabel: '사업장',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				value: UserInfo.divCode,
				hidden: false,
				allowBlank: false,
				maxLength: 20,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
						UniAppManager.app.setWorkMonthFrText(newValue, panelSearch.getValue("WORK_MONTH"));
					}
				}
			}, {
				name: 'WORK_MONTH',
				fieldLabel: '기준월',
				xtype: 'uniMonthfield',
				value:UniDate.get('startOfMonth'),
				hidden: false,
				allowBlank:false,
				maxLength: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_MONTH', newValue);
						UniAppManager.app.setWorkMonthFrText(panelSearch.getValue("DIV_CODE"), newValue);
					}
				}
			},{
				xtype:'component',
				itemId : 'workMonthFrComponent',
				style:{'padding-left':'95px'},
				html:'(시작년월 : '+workMonthFr+')',
				hidden : (yearEvaluationYN == 'Y' && workMonthFr !='') ? false : true
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
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}

				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
				//	this.mask();		    
   				}
	  		} else {
 					this.unmask();
 			}
			return r;
 		}
	});	

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout: {type: 'uniTable', columns: 3},
		padding: '1 1 1 1',
		border: true,
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			name: 'DIV_CODE',
			fieldLabel: '사업장',
			xtype: 'uniCombobox',
      		comboType: 'BOR120',
      		value:UserInfo.divCode,
      		hidden: false,
      		allowBlank: false,
      		maxLength: 20,
      		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					UniAppManager.app.setWorkMonthFrText(newValue, panelSearch.getValue("WORK_MONTH"));
				}
			}
        }, {
			name: 'WORK_MONTH',
		 	fieldLabel: '기준월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
		  	hidden: false,
		  	allowBlank: false,
		  	maxLength: 200,
       		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_MONTH', newValue);
					UniAppManager.app.setWorkMonthFrText(panelSearch.getValue("DIV_CODE"), newValue);
				}
			}
		},{
			xtype:'component',
			itemId : 'workMonthFrComponent',
			html:'(시작년월 : '+workMonthFr+')',
			style:{'padding-left' :'10px'},
			hidden : (yearEvaluationYN == 'Y' && workMonthFr != '') ? false : true
		} ],
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
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}

				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
				//	this.mask();		    
   				}
	  		} else {
 					this.unmask();
 			}
			return r;
 		}
    });		

	/* 부문별 배부기준 집계현황 */
    Unilite.Main( {
		id: 'cam020skrvApp',
		borderItems:[{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		fnInitBinding: function(param) {
			if(param && param.DIV_CODE)	{
				panelResult.setValue("DIV_CODE",param.DIV_CODE);
				panelResult.setValue("WORK_MONTH",param.WORK_MONTH);
				panelSearch.setValue("DIV_CODE",param.DIV_CODE);
				panelSearch.setValue("WORK_MONTH",param.WORK_MONTH);
			}
		},
		onQueryButtonDown: function() {	
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
		},
        setWorkMonthFrText : function(divCode, workMonth )	{
        	var com1 = panelSearch.down('#workMonthFrComponent');
			var com2 = panelResult.down('#workMonthFrComponent');
			var comArray = [com1, com2];
			if(Ext.isEmpty(workMonth))	{
				workMonth =  panelSearch.getValue("WORK_MONTH");
			}
        	UniCost.setMorhFrText(divCode,workMonth, comArray)
        }
	});
	
};
</script>