<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cam010skrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="WU"/> 
	<t:ExtComboStore comboType="AU" comboCode="C101" />
	<t:ExtComboStore comboType="AU" comboCode="CA06" />						<!-- 구분-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var yearEvaluationYN = '${YEAR_EVALUATION_YN}';
var workMonthFr 	 = '${WORK_MONTH_FR}';

function appMain() {

	//모델 정의
    var cam010skrvModel = Unilite.defineModel('cam010skrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'		, text: '사업장'			, type: 'string'},
			{name: 'WORK_MONTH'		, text: '작업년월'		, type: 'string'},
			{name: 'GROUPFIELD'		, text: '배부기준-작업장'		, type: 'string'},
			{name: 'DEVI_BASE'		, text: '배부기준'		, type: 'string', comboType:'AU', comboCode:'C101'},
			{name: 'WORK_SHOP_CD'	, text: '작업장'			, type: 'string'	, comboType:'WU'},
			{name: 'WKORD_NUM'		, text: '작업지시번호'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '품목코드'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '품목명'			, type: 'string'},
			{name: 'WIP_GUBUN'		, text: '구분'			, type: 'string', comboType:'AU', comboCode:'CA09'},
			{name: 'DEVI_DATA'		, text: '배부데이터'		, type: 'uniQty'},
			{name: 'DEVI_DATA2'		, text: '배부데이터2'		, type: 'uniQty'}
			
		]
   	});
   
	//스토어 정의
	var cam010skrvStore = Unilite.createStore('Store', {	
   		model: 'cam010skrvModel',
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
				read: 'cam010skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param = panelResult.getValues();	
			
			console.log("param", param);
			this.load({
				params : param
			});
		},
		groupField:'GROUPFIELD'
   	});

	// Grid 정의
    var masterGrid = Unilite.createGrid('cam010skrvGrid', {
		layout: 'fit',
		region: 'center',
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
			},
			excel: {
				useExcel: true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData:false,
				summaryExport:true,
				exportGridData:false
			}
        },
    	store: cam010skrvStore,
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
	           		  {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns: [	
            {dataIndex: 'WORK_MONTH' 		       , width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }
			},
			
			{dataIndex: 'GROUPFIELD', width: 150,hidden:true},
            {dataIndex: 'DEVI_BASE', width: 150},
            {dataIndex: 'WORK_SHOP_CD'	, width: 120},
            {dataIndex: 'WKORD_NUM'		, width: 120},
            {dataIndex: 'ITEM_CODE'	, width: 120},
            {dataIndex: 'ITEM_NAME'	, width: 120},
            {dataIndex: 'WIP_GUBUN'	, width: 100},
            {dataIndex: 'DEVI_DATA'	, width: 120, summaryType: 'sum'},
            {dataIndex: 'DEVI_DATA2', width: 120, summaryType: 'sum'}
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
			}, {
					name: 'WORK_SHOP_CD',
					fieldLabel: '작업장',
					xtype: 'uniCombobox',
					comboType:'WU',
					maxLength: 200,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('WORK_SHOP_CD', newValue);
						}
					}
			}, {
				name: 'DEVI_BASE',
				fieldLabel: '배부기준',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'C101',
				maxLength: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_SHOP_CD', newValue);
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
		layout: {type: 'uniTable', columns: 5},
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
		} , {
			name: 'WORK_SHOP_CD',
			fieldLabel: '작업장',	
			xtype: 'uniCombobox',
			comboType:'WU',
			maxLength: 200,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_SHOP_CD', newValue);
				}
			}
		}, {
			name: 'DEVI_BASE',
			fieldLabel: '배부기준',
			xtype: 'uniCombobox',
			colspan:2,
			comboType:'AU',
			comboCode:'C101',
			maxLength: 200,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DEVI_BASE', newValue);
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
		id: 'cam010skrvApp',
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