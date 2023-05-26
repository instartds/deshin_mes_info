<%--
'   프로그램명 : 주차별 입고내역 조회 (구매자재)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo230skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo230skrv" /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="YP42" /> 					<!--발송결과-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}'
};
function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	 Unilite.defineModel('Mpo230skrvModel', {
		fields: [
			{name: 'PROJECT_NO'      		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'PJT_NAME'     			, text: '<t:message code="system.label.purchase.projectname" default="프로젝트명"/>'			, type: 'string'},
			{name: 'REMARK'      			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>' 				, type: 'string'},
			{name: 'ITEM_CODE'          	, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 			, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>' 				, type: 'string'},
			{name: 'SPEC'         			, text: '<t:message code="system.label.purchase.spec" default="규격"/>' 				, type: 'string'},
			{name: 'ORDER_DATE'         	, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>' 			, type: 'uniDate'},
			{name: 'ORDER_Q'         		, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>' 			, type: 'uniQty'},
			{name: 'ORDER_P'         		, text: '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>' 			, type: 'uniUnitPrice'},
			{name: 'ORDER_O'         		, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>' 			, type: 'uniPrice'},
			{name: 'WEEK_DAY'         		, text: '<t:message code="system.label.purchase.week" default="주차"/>' 				, type: 'string'},
			{name: 'ORDER_DATE1'        	, text: '<t:message code="system.label.purchase.currentmonth" default="당월"/>' 				, type: 'string'},
			{name: 'CUSTOM_NAME'        	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>' 			, type: 'string'}
			
		]                           
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo230skrvService.selectList',
			update: 'mpo230skrvService.updateDetail',
			syncAll: 'mpo230skrvService.saveAll'
		}
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('mpo230skrvMasterStore1', {
		model: 'Mpo230skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});				
		},			
		groupField: 'PROJECT_NO'
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value:UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
		 		fieldLabel: '<t:message code="system.label.purchase.basisyearmonth" default="기준년월"/>',
		 		xtype: 'uniMonthfield',
		 		name: 'ORDER_DATE1',
		 		value: UniDate.get('today'),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_DATE1', newValue);
					}
				}
			},{
		 		fieldLabel: '<t:message code="system.label.purchase.week" default="주차"/>',
		 		xtype: 'uniNumberfield',
		 		name: 'WEEK_DAY',
		 		allowBlank:false,
		 		value: '01'
			}]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			value:UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
	 		fieldLabel: '<t:message code="system.label.purchase.basisyearmonth" default="기준년월"/>',
	 		xtype: 'uniMonthfield',
	 		name: 'ORDER_DATE1',
	 		value: UniDate.get('today'),
	 		allowBlank:false,
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_DATE1', newValue);
				}
			}
		},{
	 		fieldLabel: '<t:message code="system.label.purchase.week" default="주차"/>',
	 		xtype: 'uniTextfield',
	 		name: 'WEEK_DAY',
	 		allowBlank:false,
	 		value: '01',
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WEEK_DAY', newValue);
				}
			}
		}]
    });		
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('mpo230skrvGrid1', {
		layout: 'fit',
		region: 'center',
		uniOpt: {
    		useGroupSummary: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst : false,
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
    	store: directMasterStore,
        columns: [        
        	{dataIndex: 'PROJECT_NO'      		, width: 100,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              		return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
                }},
			{dataIndex: 'PJT_NAME'     			, width: 150},
			{dataIndex: 'REMARK'      			, width: 150},
			{dataIndex: 'ITEM_CODE'          	, width: 100},
			{dataIndex: 'ITEM_NAME'				, width: 150},
			{dataIndex: 'SPEC'         			, width: 120},
			{dataIndex: 'ORDER_DATE'         	, width: 80 , align:'center' },
			{dataIndex: 'ORDER_Q'         		, width: 100,summaryType: 'sum'},
			{dataIndex: 'ORDER_P'         		, width: 120},
			{dataIndex: 'ORDER_O'         		, width: 120,summaryType: 'sum'},
			{dataIndex: 'WEEK_DAY'         		, width: 60 , align:'center' },
			{dataIndex: 'ORDER_DATE1'        	, width: 60 , align:'center' },
			{dataIndex: 'CUSTOM_NAME'        	, width: 120}
		] 
    });
	
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		id: 'mpo230skrvApp',
		fnInitBinding: function(params) {
			var param = {
				"WEEK_DAY" : '02'
			}
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('WEEK_DAY', param.WEEK_DAY);
			panelResult.setValue('WEEK_DAY', param.WEEK_DAY);
			
			UniAppManager.setToolbarButtons('reset',true);
			
            this.processParams(params);
		},
		processParams: function(params) {
            if(!Ext.isEmpty(params)){
                this.uniOpt.appParams = params;
                if(params.PGM_ID == 'mpo210skrv') {
                    
                    panelSearch.setValue('DIV_CODE',params.DIV_CODE);
                    panelSearch.setValue('ORDER_DATE1',params.FR_DATE);
                    panelSearch.setValue('WEEK_DAY',params.WEEK_DAY);
                    
                    panelResult.setValue('WORK_SHOP_CODE',params.DIV_CODE);
                    panelResult.setValue('ORDER_DATE1',params.FR_DATE);
                    panelResult.setValue('WEEK_DAY',params.WEEK_DAY);
                  
                    this.onQueryButtonDown();
                }
            }
        },
		onQueryButtonDown: function() {	
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
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
