<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cem100skrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />	<!-- 생산구분 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
function appMain() {

	//모델 정의
    var cem100skrvModel = Unilite.defineModel('cem100skrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string'},
			{name: 'WORK_MONTH'		, text: 'WORK_MONTH'	, type: 'string'},
			{name: 'WORK_SEQ'		, text: 'WORK_SEQ'		, type: 'int'},
			{name: 'COST_POOL_CODE'	, text: 'Cost Pool'		, type: 'string'},
			{name: 'COST_POOL_NAME'	, text: 'Cost Pool명'	, type: 'string'},
			{name: 'ST_GB'			, text: '생산구분'			, type: 'string'},
			{name: 'PROD_ITEM_CODE'	, text: '품목코드'			, type: 'string'},
			{name: 'PROD_ITEM_NAME'	, text: '품목명'			, type: 'string'},
			{name: 'PROD_SPEC'		, text: '규격'			, type: 'string'},
			{name: 'PRODT_Q'		, text: '생산량'			, type: 'uniPrice'},
			{name: 'PER_UNIT_COST'	, text: '단위당원가'		, type: 'uniPrice'},
			{name: 'TOTAL_COST'		, text: '합계'			, type: 'uniPrice'},
			{name: 'MAT_DAMT_1020'	, text: '직접(반제품)'		, type: 'uniPrice'},
			{name: 'MAT_DAMT_4050'	, text: '직접(원부자재)'	, type: 'uniPrice'},
			{name: 'MAT_IAMT'		, text: '간접'			, type: 'uniPrice'},
			{name: 'MAT_AMT'		, text: '계'				, type: 'uniPrice'},
			{name: 'LABOR_DAMT'		, text: '직접'			, type: 'uniPrice'},
			{name: 'LABOR_IAMT'		, text: '간접'			, type: 'uniPrice'},
			{name: 'LABOR_AMT'		, text: '계'				, type: 'uniPrice'},
			{name: 'EXPENSE_DAMT'	, text: '직접'			, type: 'uniPrice'},
			{name: 'EXPENSE_IAMT'	, text: '간접'			, type: 'uniPrice'},
			{name: 'EXPENSE_AMT'	, text: '계'				, type: 'uniPrice'},
			{name: 'OUTPRODT_AMT'	, text: '외주가공비'		, type: 'uniPrice'}
		]
   	});
   
	//스토어 정의
	var cem100skrvStore = Unilite.createStore('Store', {	
   		model: 'cem100skrvModel',
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
				read: 'cem100skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param = panelResult.getValues();	
			
			console.log("param", param);
			this.load({
				params : param
			});
		},
   	});

	// Grid 정의
    var masterGrid = Unilite.createGrid('cem100skrvGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '품목별 원가집계표',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
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
    	store: cem100skrvStore,
        columns: [
         	{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
            {dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
            {dataIndex: 'WORK_MONTH'	, width: 100, hidden: true},
            {dataIndex: 'WORK_SEQ'		, width: 100, hidden: true},
            {dataIndex: 'COST_POOL_CODE', width: 100, locked: true,
           	 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
     			return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
          	 }},
            {dataIndex: 'COST_POOL_NAME', width: 150, locked: true},
            {dataIndex: 'ST_GB'			, width: 100},
            {dataIndex: 'PROD_ITEM_CODE', width: 120},
            {dataIndex: 'PROD_ITEM_NAME', width: 200},
            {dataIndex: 'PROD_SPEC'		, width: 200},
            {dataIndex: 'PRODT_Q'		, width: 120},
            {dataIndex: 'PER_UNIT_COST'	, width: 120},
            {dataIndex: 'TOTAL_COST'	, width: 120},
            {text: '재료비',
                columns:[
               	{dataIndex: 'MAT_DAMT_1020'	, width: 120},
   			    {dataIndex: 'MAT_DAMT_4050'	, width: 120},
   			    {dataIndex: 'MAT_IAMT'		, width: 120},
   			    {dataIndex: 'MAT_AMT'		, width: 120}
   			]},
            {text: '노무비',
                columns:[
               	{dataIndex: 'LABOR_DAMT'	, width: 120},
   			    {dataIndex: 'LABOR_IAMT'	, width: 120},
   			    {dataIndex: 'LABOR_AMT'		, width: 120}
   			]},
            {text: '경비',
	         columns:[
	            {dataIndex: 'EXPENSE_DAMT'	, width: 120},
	            {dataIndex: 'EXPENSE_IAMT'	, width: 120},
	            {dataIndex: 'EXPENSE_AMT'	, width: 120}
	        ]},
            {dataIndex: 'OUTPRODT_AMT'	, width: 120},
            {dataIndex: 'EXP_AMT'		, width: 120},
         	] 
    }); 

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
		api: {
        	load:'cem100skrvService.selectMaxSeq'
		},
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
           	layout: {type: 'uniTable', columns: 2},
           	defaultType: 'uniTextfield',
			items: [{
				name: 'DIV_CODE', 
				fieldLabel: '사업장',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				value: UserInfo.divCode,
				hidden: false,
				colspan: 2,
				allowBlank: false,
				maxLength: 20,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
						getLastWorkSeq();
					}
				}
			}, {
				name: 'WORK_MONTH',
				fieldLabel: '기준월',
				xtype: 'uniMonthfield',
				value:UniDate.get('startOfMonth'),
				hidden: false,
				colspan:2,
				allowBlank:false,
				maxLength: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_MONTH', newValue);
						getLastWorkSeq();
					}
				}
			}, {
				name: 'WORK_SEQ',
				fieldLabel: '작업회수',
		  		xtype: 'uniNumberfield',
				hidden: false,
				allowBlank: false,
				maxLength: 200,
		  		width: 150,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_SEQ', newValue);
					}
				}
			}, {
				name: 'LAST_WORK_SEQ',
				fieldLabel: '/',
				xtype: 'uniNumberfield',
				labelWidth:15,
				readOnly: true,
				hidden: false,
				maxLength: 200,
				width: 150,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('LAST_WORK_SEQ', newValue);
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
		layout: {type: 'uniTable', columns: 4},
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
					getLastWorkSeq();
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
					getLastWorkSeq();
				}
			}
		}, {
			name: 'WORK_SEQ',
		  	fieldLabel: '작업회수',
	  		xtype: 'uniNumberfield',
		  	hidden: false,
		  	allowBlank: false,
		  	maxLength: 200,
	  		width: 150,
       		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_SEQ', newValue);
				}
			}
	  	}, {
	  		name: 'LAST_WORK_SEQ',
			fieldLabel: '/',
	  		xtype: 'uniNumberfield',
	  		labelWidth:15,
			readOnly: true,
			hidden: false,
			maxLength: 200,
	  		width: 150,
       		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('LAST_WORK_SEQ', newValue);
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

	/* 품목별 원가집계표 */
    Unilite.Main( {
		id: 'cem100skrvApp',
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
		fnInitBinding: function() {
			getLastWorkSeq();
		},
		onQueryButtonDown: function() {	
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			masterGrid.getStore().loadStoreRecords();
			getLastWorkSeq();
		},
		onResetButtonDown: function() {
//			panelSearch.clearForm();
			masterGrid.reset();
//			panelResult.clearForm();
			this.fnInitBinding();
		}
	});
	
	function getLastWorkSeq(){
		var param= panelResult.getValues();	
		panelSearch.getForm().load({
			params: param,
			success:function(actionform, action) {
				console.log("action:",action);
				panelSearch.setValue("WORK_SEQ",action.result.data.WORK_SEQ);
				panelResult.setValue("WORK_SEQ",action.result.data.WORK_SEQ);
				panelSearch.setValue("LAST_WORK_SEQ",action.result.data.WORK_SEQ);
				panelResult.setValue("LAST_WORK_SEQ",action.result.data.WORK_SEQ);
				panelSearch.uniOpt.inLoading=false;
				Ext.getBody().unmask();
			},
			failure: function(batch, option) {
				console.log("option:",option);
			 	if(option.response!=null){
				 	panelSearch.setValue("LAST_WORK_SEQ",option.result.WORK_SEQ);
					panelResult.setValue("LAST_WORK_SEQ",option.result.WORK_SEQ);
			 	} else {
				 	panelSearch.setValue("WORK_SEQ",0);
					panelResult.setValue("WORK_SEQ",0);
				 	panelSearch.setValue("LAST_WORK_SEQ",0);
					panelResult.setValue("LAST_WORK_SEQ",0);
			 	}
			 	panelSearch.uniOpt.inLoading=false;
			 	Ext.getBody().unmask();					 
			 }
		});
	}
    
};
</script>