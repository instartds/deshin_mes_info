<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa300skrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="ssa300skrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S134"/>   	<!-- 결제유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S135"/>   	<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B010"/>   	<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>   	<!-- 세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B134"/>   	<!-- 매장구분 -->
	
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;} 
.x-change-cell {
background-color: #FFC6C6;
}
</style>

<script type="text/javascript" >

function appMain() {
	/** 
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Ssa300skrvModel1', {
	    fields: [
	    		{name: 'COMP_CODE'			    ,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		,type: 'string'},
			    {name: 'DIV_CODE'			    ,text: '<t:message code="system.label.sales.division" default="사업장"/>'			,type: 'string'},
			    {name: 'BILL_TOT_NUM'			,text: '매출집계번호'	,type: 'string'},
			    {name: 'BILL_DATE'			    ,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'			,type: 'uniDate', convert:dateToString},
			    {name: 'EX_DATE'			    ,text: '결의일자'		,type: 'uniDate'},
			    {name: 'EX_NUM'			    	,text: '결의번호'		,type: 'int'},
			    {name: 'BILL_TOT_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'			,type: 'string'},
			    {name: 'DEPT_CODE'				,text: '<t:message code="system.label.sales.department" default="부서"/>'			,type: 'string'},
			    {name: 'DEPT_NAME'				,text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'			,type: 'string'},
			    {name: 'SHOP_CLASS'				,text: '매장구분'		,type: 'string', comboType:'AU', comboCode:'B134'},
			    {name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'			,type: 'string'},
			    {name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		,type: 'string'},
			    {name: 'BILL_TYPE'			    ,text: '<t:message code="system.label.sales.receiptsettype" default="결제유형"/>'		,type: 'string', comboType:'AU', comboCode:'S134'},
			    {name: 'PROOF_TYPE'			    ,text: '증빙유형'		,type: 'string', comboType:'AU', comboCode:'S135'},
			    {name: 'ITEM_ACCOUNT'			,text: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>'		,type: 'string', comboType:'AU', comboCode:'B020'},
			    {name: 'TAX_TYPE'			    ,text: '<t:message code="system.label.sales.taxtype" default="세구분"/>'			,type: 'string', comboType:'AU', comboCode:'B059'},
			    {name: 'SALE_AMT_I'			    ,text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'			,type: 'uniPrice'},
			    {name: 'TAX_AMT_I'			    ,text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'		,type: 'uniPrice'},
			    {name: 'TOT_AMT_I'			    ,text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		,type: 'uniPrice'},
			    {name: 'DISCOUNT_AMT_I'			,text: '할인액'			,type: 'uniPrice'},
			    {name: 'NET_AMT_I'				,text: '순매출액'		,type: 'uniPrice'},
			    {name: 'CONSIGNMENT_FEE'		,text: '수탁수수료'		,type: 'uniPrice'},
			    {name: 'CONSIGNMENT_GOODS'		,text: '수탁상품'		,type: 'uniPrice'},
			   
			    
			    {name: 'REMARK'			    	,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'}			    
			]
	});	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('ssa300skrvMasterStore1',{
			model: 'Ssa300skrvModel1',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ssa300skrvService.selectList'                	
                }
            }
			,loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params: param
				});
				
			},
			groupField: 'BILL_DATE'
			
	});	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
            items: [{
        		xtype: 'container',
        		layout: {type: 'uniTable', columns: 1},
        		items: [{
        			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        			name: 'DIV_CODE',
        			xtype: 'uniCombobox',
        			comboType: 'BOR120',
        			allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
        		}, { 
			    	fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
		         	xtype: 'uniDateRangefield',
		         	startFieldName: 'SALE_DATE_FR',
		         	endFieldName: 'SALE_DATE_TO',
		         	allowBlank: false,
		         	width: 315,							               
		         	colspan: 2,                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('SALE_DATE_FR',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('SALE_DATE_TO',newValue);
				    		
				    	}
				    }
				}]
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}		
	}); 
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, { 
	    	fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
         	xtype: 'uniDateRangefield',
         	startFieldName: 'SALE_DATE_FR',
         	endFieldName: 'SALE_DATE_TO',
         	allowBlank: false,
         	width: 315,							               
         	colspan: 2,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('SALE_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('SALE_DATE_TO',newValue);
		    		
		    	}
		    }
		}]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ssa300skrvGrid1', {
    	// for tab    	
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
			}
        },
    	store: directMasterStore,
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id: 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [ 				
					{ dataIndex: 'COMP_CODE'			,    width: 93, hidden: true},
					{ dataIndex: 'DIV_CODE'			    ,    width: 93, hidden: true},
					{ dataIndex: 'BILL_TOT_NUM'			,    width: 120},
					{ dataIndex: 'BILL_DATE'			,    width: 93},					
					{ dataIndex: 'BILL_TOT_SEQ'			,    width: 60, align: 'center'},
					{ dataIndex: 'DEPT_CODE'			,    width: 60},
					{ dataIndex: 'DEPT_NAME'			,    width: 120},
					{ dataIndex: 'SHOP_CLASS'			,    width: 93},	
					{ dataIndex: 'CUSTOM_CODE'			,    width: 55},
					{ dataIndex: 'CUSTOM_NAME'			,    width: 170},
					{ dataIndex: 'BILL_TYPE'			,    width: 93, 
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
	           		 	}	
	           		 },
					{ dataIndex: 'PROOF_TYPE'			,    width: 93},
					{ dataIndex: 'ITEM_ACCOUNT'			,    width: 93},
					{ dataIndex: 'TAX_TYPE'			    ,    width: 93, align: 'center'},
					{ dataIndex: 'SALE_AMT_I'			,    width: 100, summaryType: 'sum'},
					{ dataIndex: 'TAX_AMT_I'			,    width: 100, summaryType: 'sum'},
					{ dataIndex: 'TOT_AMT_I'			,    width: 100, summaryType: 'sum'},
					{ dataIndex: 'DISCOUNT_AMT_I'		,    width: 100, summaryType: 'sum'},
					{ dataIndex: 'NET_AMT_I'			,    width: 100, summaryType: 'sum'},
					{ dataIndex: 'CONSIGNMENT_FEE'		,    width: 100, summaryType: 'sum'},
					{ dataIndex: 'CONSIGNMENT_GOODS'	,    width: 100, summaryType: 'sum'},  
					{ dataIndex: 'REMARK'			    ,    width: 100},
					{ dataIndex: 'EX_DATE'			    ,    width: 93},
					{ dataIndex: 'EX_NUM'			    ,    width: 93}
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
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('SALE_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_TO',UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('SALE_DATE_FR',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_TO',UniDate.get('today'));		
			panelResult.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
			
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}		
	});
};


</script>

