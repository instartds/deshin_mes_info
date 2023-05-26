<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cdm420skrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var costCenterList = ${COST_CENTER_LIST};

function appMain() {

	//모델 정의
	var cdm420ModelFields = [
   		{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
   		{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string'},
   		{name: 'WORK_MONTH'		, text: 'WORK_MONTH'	, type: 'string'},
   		{name: 'WORK_SEQ'		, text: 'WORK_SEQ'		, type: 'int'	},
    	{name: 'ACCNT'		    , text: '계정코드'    		, type: 'string'},
    	{name: 'ACCNT_NAME'		, text: '계정명'    		, type: 'string'}
    ];
    
	//모델 정의-cost center 추가
	cdm420ModelFields.push({name: 'SUM_AMT'	, text: '합계'	, type: 'uniPrice'});
	Ext.each(costCenterList, function(item){
    	cdm420ModelFields.push({name: "COST_CENTER_"+item.COST_CENTER_CODE	, text: item.COST_CENTER_NAME	, type: 'uniPrice'});
    })
    
    var cdm420skrvModel = Unilite.defineModel('cdm420skrvModel', {
		fields: cdm420ModelFields
   	});
   
	//스토어 정의
	var cdm420skrvStore = Unilite.createStore('Store', {	
   		model: 'cdm420skrvModel',
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
				read: 'cdm420skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param = panelResult.getValues();	
			
			console.log("param", param);
			this.load({
				params : param
			});
		},
		groupField:'SUM_AMT'
   	});

	// Grid 정의
	var masterGridColumns = [
		{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
    	{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
    	{dataIndex: 'WORK_MONTH'	, width: 100, hidden: true},
    	{dataIndex: 'WORK_SEQ'		, width: 100, hidden: true},
     	{dataIndex: 'ACCNT'		    , width: 100, locked: true,
    	 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
     	 }},
     	{dataIndex: 'ACCNT_NAME'	, width: 150, locked: true},
	] 
	 
	// Grid 정의-cost center 추가
	var costCenterColumns = [{dataIndex:'SUM_AMT'	, width: 120, summaryType: 'sum' }];
    Ext.each(costCenterList, function(item){
    	costCenterColumns.push({dataIndex: "COST_CENTER_"+item.COST_CENTER_CODE	, width: 130, summaryType: 'sum'});
    })
    if(costCenterList.length > 0)	{
	    var costCenterColumn = {
	    	text:'Cost Center',
	    	columns :costCenterColumns
	    }
	    masterGridColumns.push(costCenterColumn);
    }

    var masterGrid = Unilite.createGrid('cdm420skrvGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '제조경비 집계현황',
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
    	store: cdm420skrvStore,
        columns: masterGridColumns
    }); 

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
		api: {
        	load:'cdm420skrvService.selectMaxSeq'
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

	/* 제조경비 집계현황 */
    Unilite.Main( {
		id: 'cdm420skrvApp',
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