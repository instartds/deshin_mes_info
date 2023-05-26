<%--
'   프로그램명 : 작업지시별 투입공수 집계 (생산)
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
<t:appConfig pgmId="pmr810skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo080ukrv" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
	<t:ExtComboStore comboType="W"  /> <!-- 작업장 -->	
</t:appConfig>
<style type="text/css">

.x-change-cell {
background-color: #FFFFC6;
}
.x-change-cell2 {
background-color: #FDE3FF;
}
</style>
<script type="text/javascript" >

function appMain() {
 
	Unilite.defineModel('pmr810skrvModel1', {
	    fields: [  	 
			{name: 'CODE_NAME'       	,text: '상태'	,type: 'string'},
			{name: 'WKORD_NUM'       	,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	,type: 'string'},
			{name: 'WORK_SHOP_CODE'       	,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	,type: 'string'},
			{name: 'TREE_NAME'       	,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	,type: 'string'},
			{name: 'ITEM_CODE'       	,text: '<t:message code="system.label.product.item" default="품목"/>'		,type: 'string'},
			{name: 'ITEM_NAME'       	,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'            	,text: '<t:message code="system.label.product.spec" default="규격"/>'			,type: 'string'},
			{name: 'STOCK_UNIT'      	,text: '<t:message code="system.label.product.unit" default="단위"/>'			,type: 'string'},
			{name: 'WKORD_Q'         	,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type: 'uniQty'},
			{name: 'WORK_Q'         	,text: '<t:message code="system.label.product.workqty" default="작업량"/>'		,type: 'uniQty'},
			{name: 'PRODT_Q'         	,text: '<t:message code="system.label.product.productionqty" default="양품생산량"/>'		,type: 'uniQty'},
			{name: 'LOT_NO'       		,text: 'LOT NO'	,type: 'string'},
			{name: 'PRODT_WKORD_DATE'	,text: '작업지시일'	,type: 'uniDate'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	,type: 'uniDate'},
			{name: 'PRODT_END_DATE'  	,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	,type: 'uniDate'},
			{name: 'MAN_HOUR'         	,text: '<t:message code="system.label.product.inputtimesum" default="투입공수합계"/>'			,type:'uniQty'},
			{name: 'REMARK'         	,text: '<t:message code="system.label.product.remarks" default="비고"/>'			,type: 'string'}
			
		]  
	});	

	
	var MasterStore1 = Unilite.createStore('pmr810skrvMasterStore1',{
			model: 'pmr810skrvModel1',
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
                	   read: 'pmr810skrvService.selectList1'                	
                }
            },
			loadStoreRecords: function(record){
				var param= panelSearch.getValues();	
				
	        	this.load({
						params : param
	         	});
			},
			listeners: {
           	load: function(store, records, successful, eOpts) {
           		
           	},
           	add: function(store, records, index, eOpts) {
           		
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		
           	},
           	remove: function(store, record, index, isMove, eOpts) {	
           	}
		}
			
			
	});		
			
	var panelSearch = Unilite.createSearchForm('searchForm', {
		region: 'north',
            layout: {
                type: 'uniTable',
                columns: 3
            },
            padding:'1 1 1 1',
			border:true,
            items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name:'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120',
	        	allowBlank: false,
	        	value: UserInfo.divCode,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE','');
					}
        		}
	        },{
                fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'PRODT_START_DATE',
                endFieldName: 'PRODT_END_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                width: 315
            },{
				xtype: 'radiogroup',		            		
				fieldLabel: '   ',
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>', 
					width:130, 
					name: 'OPT', 
					inputValue: '1', 
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>', 
					width:130, 
					name: 'OPT', 
					inputValue: '2'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>', 
					width:130, 
					name: 'OPT', 
					inputValue: '3'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>', 
					width:130, 
					name: 'OPT', 
					inputValue: '4'
				}]
				
			},{
					fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
					name: 'WORK_SHOP_CODE', 
					xtype: 'uniCombobox', 
					comboType:'W',
					listeners: {
	                    beforequery:function( queryPlan, eOpts )   {
	                        var store = queryPlan.combo.store;
	                        store.clearFilter();
	                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
	                            store.filterBy(function(record){
	                                return record.get('option') == panelSearch.getValue('DIV_CODE');
	                            });
	                        }else{
	                            store.filterBy(function(record){
	                                return false;   
	                            });
	                        }
	                    }
					}
			}, 
			Unilite.popup('ITEM',{ // 20210827 추가: 품목 조회조건 정규화
				fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
						}
					}
				}
			})]
        });

    var masterGrid1 = Unilite.createGrid('pmr810skrvGrid1', {
        store : MasterStore1,
        region:'center',
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [
			{dataIndex: 'CODE_NAME' , width: 66, align: 'center'},
        	{dataIndex: 'WKORD_NUM' , width: 120},
			{dataIndex: 'WORK_SHOP_CODE' , width: 100,hidden:true},
			{dataIndex: 'TREE_NAME' , width: 100},
			{dataIndex: 'ITEM_CODE' , width: 125},
			{dataIndex: 'ITEM_NAME' , width: 250},
			{dataIndex: 'SPEC' , width: 80},
			{dataIndex: 'STOCK_UNIT' , width: 80, align: 'center'},
			{dataIndex: 'WKORD_Q' , width: 110, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'WORK_Q' , width: 100,hidden:true, summaryType: 'sum'},
			{dataIndex: 'PRODT_Q' , width: 110, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'LOT_NO' , width: 100, align: 'center'},
			{dataIndex: 'PRODT_WKORD_DATE' , width: 100},
			{dataIndex: 'PRODT_START_DATE' , width: 100},
			{dataIndex: 'PRODT_END_DATE' , width: 100},
			{dataIndex: 'MAN_HOUR' , width: 100, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'REMARK' , width: 200}
		]
       		
    });		
	 Unilite.Main({
    	borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid1,  panelSearch
         ]
      }],
		id: 'pmr810skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('save',false);
			panelSearch.setValue('PRODT_START_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('PRODT_END_DATE', UniDate.get('today'));
			panelSearch.getField("OPT").value = '1';
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.getInvalidMessage()){
				MasterStore1.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {	
			
			panelSearch.reset();
			masterGrid1.reset();
			this.fnInitBinding();
		}
	});		
};
</script>

