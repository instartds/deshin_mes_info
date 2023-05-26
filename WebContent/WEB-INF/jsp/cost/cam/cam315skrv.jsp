<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cam315skrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var costPoolList = ${COST_POOL_LIST};

var yearEvaluationYN = '${YEAR_EVALUATION_YN}';
var workMonthFr 	 = '${WORK_MONTH_FR}';

function appMain() {

	//모델 정의
	var cam315ModelFields = [
   		{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
   		{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string'},
   		{name: 'WORK_MONTH'		, text: 'WORK_MONTH'	, type: 'string'},
    	{name: 'ACCNT'		    , text: '계정코드'    		, type: 'string'},
    	{name: 'ACCNT_NAME'		, text: '계정명'    		, type: 'string'}
    ];
    
	
	//모델 정의-cost pool 총계 추가
	cam315ModelFields.push({name: 'COMP_CODE_CP'	, text: 'COMP_CODE_CP'	, type: 'string'});
	cam315ModelFields.push({name: 'DIV_CODE_CP'		, text: 'DIV_CODE_CP'	, type: 'string'});
	cam315ModelFields.push({name: 'WORK_MONTH_CP'	, text: 'WORK_MONTH_CP'	, type: 'string'});
	cam315ModelFields.push({name: 'ACCNT_CP'		, text: 'ACCNT_DIRECT'	, type: 'string'});
	cam315ModelFields.push({name: 'SUM_COST_POOL'	, text: '합계'			, type: 'uniPrice'});
	Ext.each(costPoolList, function(item){
    	cam315ModelFields.push({name: "COST_POOL_"+item.COST_POOL_CODE	, text: item.COST_POOL_NAME	, type: 'uniPrice'});
    })

	//모델 정의-cost pool 직과배부계 추가
	cam315ModelFields.push({name: 'COMP_CODE_DIRECT'	, text: 'COMP_CODE_DIRECT'	, type: 'string'});
	cam315ModelFields.push({name: 'DIV_CODE_DIRECT'		, text: 'DIV_CODE_DIRECT'	, type: 'string'});
	cam315ModelFields.push({name: 'WORK_MONTH_DIRECT'	, text: 'WORK_MONTH_DIRECT'	, type: 'string'});
	cam315ModelFields.push({name: 'ACCNT_DIRECT'		, text: 'ACCNT_DIRECT'		, type: 'string'});
	cam315ModelFields.push({name: 'SUM_COST_DIRECT'		, text: '합계'				, type: 'uniPrice'});
	Ext.each(costPoolList, function(item){
    	cam315ModelFields.push({name: 'COST_DIRECT_'+item.COST_POOL_CODE	, text: item.COST_POOL_NAME	, type: 'uniPrice'});
    })

	//모델 정의-cost pool 공통배부계 추가
	cam315ModelFields.push({name: 'COMP_CODE_DISTR'		, text: 'COMP_CODE_DISTR'	, type: 'string'});
	cam315ModelFields.push({name: 'DIV_CODE_DISTR'		, text: 'DIV_CODE_DISTR'	, type: 'string'});
	cam315ModelFields.push({name: 'WORK_MONTH_DISTR'	, text: 'WORK_MONTH_DISTR'	, type: 'string'});
	cam315ModelFields.push({name: 'ACCNT_DISTR'			, text: 'ACCNT_DISTR'		, type: 'string'});
	cam315ModelFields.push({name: 'SUM_COST_DISTR'		, text: '합계'				, type: 'uniPrice'});
	Ext.each(costPoolList, function(item){
    	cam315ModelFields.push({name: 'COST_DISTR_'+item.COST_POOL_CODE	, text: item.COST_POOL_NAME	, type: 'uniPrice'});
    })
    
    var cam315skrvModel = Unilite.defineModel('cam315skrvModel', {
		fields: cam315ModelFields
   	});
   
	//스토어 정의
	var cam315skrvStore = Unilite.createStore('Store', {	
   		model: 'cam315skrvModel',
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
				read: 'cam315skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			if(!costPoolList || costPoolList.length == 0)	{
        		alert("등록된 부문이 없습니다.")
        		return;
        	} else {
        		var checkCnt = 0
        		Ext.each(costPoolList , function(item){
        			if(item.DIV_CODE == panelResult.getValue("DIV_CODE"))	{
        				checkCnt = 1;
        			}
        		})
        		if(checkCnt == 0)	{
        			alert("해당 사업장에 등록된 부문이 없습니다.")
        			return;
        		}
        	}
			var param = panelResult.getValues();	
			masterGrid.loadCostPoolColumns(panelResult.getValue("DIV_CODE"));
			console.log("param", param);
			this.load({
				params : param
				
			});
		}
   	});

	// Grid 정의
	var masterGridColumns = [
		{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
    	{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
    	{dataIndex: 'WORK_MONTH'	, width: 100, hidden: true},
     	{dataIndex: 'ACCNT'		    , width: 100, locked: true,
    	 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
     	 }},
     	{dataIndex: 'ACCNT_NAME'	, width: 150, locked: true}
	] 
	 
/*	// Grid 정의-cost center 추가
	var costCenterColumns = [{dataIndex:'SUM_COST_CENTER'	, width: 120, summaryType: 'sum' }];
    Ext.each(costCenterList, function(item){
    	costCenterColumns.push({dataIndex: "COST_CENTER_"+item.COST_CENTER_CODE	, width: 120, summaryType: 'sum'});
    })
    if(costCenterList.length > 0)	{
	    var costCenterColumn = {
	    	text:'Cost Center',
	    	columns :costCenterColumns
	    }
	    masterGridColumns.push(costCenterColumn);
    }*/

	// Grid 정의-cost pool 총계 추가
	var costPoolColumns = [{dataIndex: 'COMP_CODE_CP'	, width: 100, hidden: true}];
	costPoolColumns.push({dataIndex: 'DIV_CODE_CP'		, width: 100, hidden: true});
	costPoolColumns.push({dataIndex: 'WORK_MONTH_CP'	, width: 100, hidden: true});
	costPoolColumns.push({dataIndex: 'ACCNT_CP'			, width: 100, hidden: true});
	costPoolColumns.push({dataIndex: 'SUM_COST_POOL'	, width: 120, summaryType: 'sum'});
	Ext.each(costPoolList, function(item){
		costPoolColumns.push({dataIndex: "COST_POOL_"+item.COST_POOL_CODE	, width: 120, summaryType: 'sum'});
    })
  
    if(costPoolList.length > 0)	{
	    var costPoolColumn = {
	    	text:'제조경비 배부총계',
	    	columns :costPoolColumns
	    }
	    masterGridColumns.push(costPoolColumn);
    }

	// Grid 정의-cost pool 직과배부계 추가
	var costPoolDirectColumns = [{dataIndex: 'COMP_CODE_DIRECT'	, width: 100, hidden: true}];
	costPoolDirectColumns.push({dataIndex: 'DIV_CODE_DIRECT'	, width: 100, hidden: true});
	costPoolDirectColumns.push({dataIndex: 'WORK_MONTH_DIRECT'	, width: 100, hidden: true});
	costPoolDirectColumns.push({dataIndex: 'ACCNT_DIRECT'		, width: 100, hidden: true});
	costPoolDirectColumns.push({dataIndex: 'SUM_COST_DIRECT'	, width: 120, summaryType: 'sum'});
	Ext.each(costPoolList, function(item){
		costPoolDirectColumns.push({dataIndex: "COST_DIRECT_"+item.COST_POOL_CODE	, width: 120, summaryType: 'sum'});
    });
      
    if(costPoolList.length > 0)	{
	    var costPoolDirectColumn = {
	    	text:'제조부문 1차 직과계',
	    	columns :costPoolDirectColumns
	    }
	    masterGridColumns.push(costPoolDirectColumn);
    }

	// Grid 정의-cost pool 공통배부계 추가
	var costPoolDistrColumns = [{dataIndex: 'COMP_CODE_DISTR'	, width: 100, hidden: true}];
	costPoolDistrColumns.push({dataIndex: 'DIV_CODE_DISTR'		, width: 100, hidden: true});
	costPoolDistrColumns.push({dataIndex: 'WORK_MONTH_DISTR'	, width: 100, hidden: true});
	costPoolDistrColumns.push({dataIndex: 'ACCNT_DISTR'			, width: 100, hidden: true});
	costPoolDistrColumns.push({dataIndex: 'SUM_COST_DISTR'		, width: 120, summaryType: 'sum'});
	Ext.each(costPoolList, function(item){
		costPoolDistrColumns.push({dataIndex: "COST_DISTR_"+item.COST_POOL_CODE	, width: 120, summaryType: 'sum'});
    });
    if(costPoolList.length > 0)	{
	    var costPoolDistrColumn = {
	    	text:'보조부문 2차 배부계',
	    	columns :costPoolDistrColumns
	    }
	    masterGridColumns.push(costPoolDistrColumn);
    }

    var masterGrid = Unilite.createGrid('cam315skrvGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '부문별 제조경비 집계현황',
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
        	showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: cam315skrvStore,
        columns: masterGridColumns,
        listeners:{
        	render:function(grid){
        		this.loadCostPoolColumns(UserInfo.divCode);
        	}	
        },
		loadCostPoolColumns:function(divCode)	{
			var me = this;
			
			Ext.each(costPoolList, function(item){
				if(item.DIV_CODE == divCode )	{
					me.getColumn("COST_POOL_"+item.COST_POOL_CODE).show();
					me.getColumn("COST_DISTR_"+item.COST_POOL_CODE).show();
					me.getColumn("COST_DIRECT_"+item.COST_POOL_CODE).show();
				} else {
					me.getColumn("COST_POOL_"+item.COST_POOL_CODE).hide();
					me.getColumn("COST_DISTR_"+item.COST_POOL_CODE).hide();
					me.getColumn("COST_DIRECT_"+item.COST_POOL_CODE).hide();
				}
		    })
			
		}
    }); 

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
		api: {
        	load:'cam315skrvService.selectMaxSeq'
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

	/* 부문별 제조경비 집계 현황	*/
    Unilite.Main( {
		id: 'cam315skrvApp',
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