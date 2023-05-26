<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cdm305skrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />	<!-- 생산구분 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
function appMain() {

	//모델 정의
    var cdm305skrvModel = Unilite.defineModel('cdm305skrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string'},
			{name: 'WORK_MONTH'		, text: 'WORK_MONTH'	, type: 'string'},
			{name: 'WORK_SEQ'		, text: 'WORK_SEQ'		, type: 'int'},
			{name: 'COST_POOL_CODE'	, text: 'Cost Pool'		, type: 'string'},
			{name: 'COST_POOL_NAME'	, text: 'Cost Pool명'	, type: 'string'},
			{name: 'EXEC_STEP'		, text: '실행단계'			, type: 'string'},
			{name: 'EXEC_DESC'		, text: '실행설명'			, type: 'string'},
			{name: 'START_TIME'		, text: '시작시간'			, type: 'string'},
			{name: 'END_TIME'		, text: '종료시간'			, type: 'string'},
			{name: 'PROCESS_TIME'	, text: '진행시간(초)'		, type: 'string'},
			{name: 'EXECUTE_TIME'	, text: '처리시간(초)'		, type: 'string'},
			{name: 'SQL_COUNT'		, text: '처리행수'			, type: 'int'}
		]
   	});
   
	//스토어 정의
	var cdm305skrvStore = Unilite.createStore('Store', {	
   		model: 'cdm305skrvModel',
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
				read: 'cdm305skrvService.selectList'
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
    var masterGrid = Unilite.createGrid('cdm305skrvGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '원가계산 LOG 정보조회',
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
    	store: cdm305skrvStore,
        columns: [
         	{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
            {dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
            {dataIndex: 'WORK_MONTH'	, width: 100, hidden: true},
            {dataIndex: 'WORK_SEQ'		, width: 100, hidden: true},
			{dataIndex: 'EXEC_STEP'		, width: 120},
            {dataIndex: 'EXEC_DESC'		, width: 500},
            {dataIndex: 'START_TIME'	, width: 120},
            {dataIndex: 'END_TIME'		, width: 120},
            {dataIndex: 'PROCESS_TIME'	, width: 120},
            {dataIndex: 'EXECUTE_TIME'	, width: 120},
            {dataIndex: 'SQL_COUNT'		, width: 120}
         	] 
    }); 

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
		api: {
        	load:'cdm305skrvService.selectMaxSeq'
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

	/* 원가계산 LOG 정보조회 */
    Unilite.Main( {
		id: 'cdm305skrvApp',
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
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
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