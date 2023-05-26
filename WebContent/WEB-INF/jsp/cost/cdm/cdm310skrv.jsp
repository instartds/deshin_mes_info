<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cdm310skrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="CD03" />	<!-- 원가담당자 -->	
	<t:ExtComboStore comboType="AU" comboCode="CD11" />	<!-- 작업결과 -->	
	<t:ExtComboStore comboType="AU" comboCode="B010" />	<!-- 예/아니오 -->	
	<t:ExtComboStore comboType="AU" comboCode="CD01" />	<!-- 이력관리 -->	
	<t:ExtComboStore comboType="AU" comboCode="CC05" />	<!-- 적용단가 -->	
	<t:ExtComboStore comboType="AU" comboCode="CC06" />	<!-- 계정별배부방법 -->	
	<t:ExtComboStore comboType="AU" comboCode="C101" />	<!-- 간접비배부유형 -->	
	<t:ExtComboStore comboType="AU" comboCode="CD02" />	<!-- 수불금액반영 -->	
	<t:ExtComboStore comboType="AU" comboCode="CD04" />	<!-- 원가금액반영 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
function appMain() {

	//모델 정의
    var cdm310skrvModel = Unilite.defineModel('cdm310skrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'		, text: '사업장'			, type: 'string'},
			{name: 'WORK_MONTH'		, text: '작업년월'			, type: 'string'},
			{name: 'WORK_SEQ'		, text: '작업회수'			, type: 'int'},
			{name: 'COST_PRSN'		, text: '원가담당자'		, type: 'string', comboType:'AU', comboCode:'CD03'},
			{name: 'WORK_RESULT'	, text: '작업결과'			, type: 'string', comboType:'AU', comboCode:'CD11'},
			{name: 'IS_LAST'		, text: '최종작업'			, type: 'string', comboType:'AU', comboCode:'B010'},
			{name: 'DELE_FLAG'		, text: '이력관리'			, type: 'string', comboType:'AU', comboCode:'CD01'},
			{name: 'UNIT_FLAG'		, text: '적용단가'			, type: 'string', comboType:'AU', comboCode:'CC05'},
			{name: 'ACNT_FLAG'		, text: '계정별배부방법'		, type: 'string', comboType:'AU', comboCode:'CC06'},
			{name: 'DIST_FLAG'		, text: '간접비배부유형'		, type: 'string', comboType:'AU', comboCode:'C101'},
			{name: 'APLY_FLAG'		, text: '수불금액반영'		, type: 'string', comboType:'AU', comboCode:'CD02'},
			{name: 'COST_FLAG'		, text: '원가금액반영'		, type: 'string', comboType:'AU', comboCode:'CD04'},
			{name: 'IS_CLOSE'		, text: '원가마감'			, type: 'string', comboType:'AU', comboCode:'B010'}
		]
   	});
   
	//스토어 정의
	var cdm310skrvStore = Unilite.createStore('Store', {	
   		model: 'cdm310skrvModel',
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
				read: 'cdm310skrvService.selectList'
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
    var masterGrid = Unilite.createGrid('cdm310skrvGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '원가계산 작업 정보조회',
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
			showSummaryRow: false
		}],
    	store: cdm310skrvStore,
        columns: [
         	{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
            {dataIndex: 'DIV_CODE'		, width: 150},
            {dataIndex: 'WORK_MONTH'	, width: 90, align: 'center'},
            {dataIndex: 'WORK_SEQ'		, width: 90},
			{dataIndex: 'COST_PRSN'		, width: 100},
			{dataIndex: 'WORK_RESULT'	, width: 200},
			{dataIndex: 'IS_LAST'		, width: 100},
			{dataIndex: 'DELE_FLAG'		, width: 100},
			{dataIndex: 'UNIT_FLAG'		, width: 100},
			{dataIndex: 'ACNT_FLAG'		, width: 100},
			{dataIndex: 'DIST_FLAG'		, width: 100},
			{dataIndex: 'APLY_FLAG'		, width: 100},
			{dataIndex: 'COST_FLAG'		, width: 100},
			{dataIndex: 'IS_CLOSE'		, width: 100}
		] 
    }); 

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
		api: {
        	load:'cdm310skrvService.selectMaxSeq'
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
				allowBlank: true,
				maxLength: 20,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '작업년월',
                xtype: 'uniMonthRangefield',
                startFieldName: 'FR_WORK_MONTH',
                endFieldName: 'TO_WORK_MONTH',
                startDate: UniDate.get('today'),
                endDate: UniDate.get('today'),                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_WORK_MONTH',newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_WORK_MONTH',newValue);			    		
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
      		allowBlank: true,
      		maxLength: 20,
      		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel: '작업년월',
            xtype: 'uniMonthRangefield',
            startFieldName: 'FR_WORK_MONTH',
            endFieldName: 'TO_WORK_MONTH',
            startDate: UniDate.get('today'),
            endDate: UniDate.get('today'),                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelResult.setValue('FR_WORK_MONTH',newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelResult.setValue('TO_WORK_MONTH',newValue);			    		
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

	/* 원가계산 작업 정보조회 */
    Unilite.Main( {
		id: 'cdm310skrvApp',
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

		},
		onQueryButtonDown: function() {	
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		}
	});
	
};
</script>