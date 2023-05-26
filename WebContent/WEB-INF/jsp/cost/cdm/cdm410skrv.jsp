<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cdm410skrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />	<!-- 생산구분 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
function appMain() {

	//모델 정의
    var cdm410skrvModel = Unilite.defineModel('cdm410skrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string'},
			{name: 'WORK_MONTH'		, text: 'WORK_MONTH'	, type: 'string'},
			{name: 'WORK_SEQ'		, text: 'WORK_SEQ'		, type: 'int'},
			{name: 'COST_POOL_CODE'	, text: 'Cost Pool'		, type: 'string'},
			{name: 'COST_POOL_NAME'	, text: 'Cost Pool명'	, type: 'string'},
			{name: 'DISTR_PERSON'	, text: '인원수'			, type: 'uniPrice'},
			{name: 'DISTR_PAY'		, text: '급여액'			, type: 'uniPrice'},
			{name: 'DISTR_ASST'		, text: '상각비'			, type: 'uniPrice'},
			{name: 'DISTR_PRODT'	, text: '생산량'			, type: 'uniPrice'},
			{name: 'DISTR_MANHOUR'	, text: '투입공수'			, type: 'uniPrice'},
			{name: 'DISTR_SALES'	, text: '매출액'			, type: 'uniPrice'},
			{name: 'DISTR_ACCOUNT'	, text: '품목계정'			, type: 'uniPrice'},
			{name: 'DISTR_ITEM_LEVEL',text: '품목분류'			, type: 'uniPrice'},
			{name: 'DISTR_REWORK'	, text: '재작업'			, type: 'uniPrice'}
		]
   	});
   
	//스토어 정의
	var cdm410skrvStore = Unilite.createStore('Store', {	
   		model: 'cdm410skrvModel',
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
				read: 'cdm410skrvService.selectList'
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
    var masterGrid = Unilite.createGrid('cdm410skrvGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '부문별 배부기준 집계현황',
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
    	store: cdm410skrvStore,
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
            {dataIndex: 'DISTR_PERSON'	, width: 120},
            {dataIndex: 'DISTR_PAY'		, width: 120},
            {dataIndex: 'DISTR_ASST'	, width: 120},
            {dataIndex: 'DISTR_PRODT'	, width: 120},
            {dataIndex: 'DISTR_MANHOUR'	, width: 120},
            {dataIndex: 'DISTR_SALES'	, width: 120},
            {dataIndex: 'DISTR_ACCOUNT'	, width: 120},
            {dataIndex: 'DISTR_ITEM_LEVEL', width: 120},
            {dataIndex: 'DISTR_REWORK'	, width: 120}
         	] 
    }); 

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
		api: {
        	load:'cdm410skrvService.selectMaxSeq'
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

	/* 부문별 배부기준 집계현황 */
    Unilite.Main( {
		id: 'cdm410skrvApp',
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