<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mtr270skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B005" /> <!-- 출고처구분 -->	
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Mtr270skrvModel', {
		fields: [
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'	, type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.purchase.issueplacecode" default="출고처코드"/>'	, type: 'string'},
			{name: 'ITEM_CODE'  	,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'	, type: 'string'},
			{name: 'ITEM_NAME'  	,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'	, type: 'string'},
			{name: 'INOUT_SUM'  	,text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'string'}
		]
	});//End of Unilite.defineModel('Mtr270skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mtr270skrvMasterStore1',{
		model: 'Mtr270skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'mtr270skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();	
			param.CUSTOM_CODE = panelResult.getValue('CUSTOM_CODE');
			console.log(param);
			this.load({
				params: param
			});
		},
			groupField: ''
	});//End of var directMasterStore1 = Unilite.createStore('mtr270skrvMasterStore1',{

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('DIV_CODE', newValue);
				}
			}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_FR_DATE',
				endFieldName: 'INOUT_TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('INOUT_FR_DATE',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INOUT_TO_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>', 
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>', 
				name: 'INOUT_CODE_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B005',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INOUT_CODE_TYPE', newValue);
					}
				}
			}, 
				Unilite.popup('', { 
					fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>', 
					name: 'CUSTOM_CODE',
					textFieldWidth: 170, 
					validateBlank: false
				})
			]	            			 
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_FR_DATE',
				endFieldName: 'INOUT_TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('INOUT_FR_DATE',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('INOUT_TO_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>', 
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>', 
				name: 'INOUT_CODE_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B005',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('INOUT_CODE_TYPE', newValue);
					}
				}
			}, 
				Unilite.popup('', { 
					fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>', 
					name: 'CUSTOM_CODE',
					textFieldWidth: 170, 
					validateBlank: false
				})]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('mtr270skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region:'center',
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
		store: directMasterStore1,
		columns:  [
			{dataIndex: 'CUSTOM_NAME'	, width: 120}, 				
			{dataIndex: 'CUSTOM_CODE'	, width: 120, hidden: true},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 133},
			{dataIndex: 'INOUT_SUM'		, width: 133}
		] 
	});//End of var masterGrid = Unilite.createGrid('mtr270skrvGrid1', {   

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
		id: 'mtr270skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
		},
		onQueryButtonDown: function(){
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
            directMasterStore1.loadStoreRecords();
        }
	});
};


</script>
