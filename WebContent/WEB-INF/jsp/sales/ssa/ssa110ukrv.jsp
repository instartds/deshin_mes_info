<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa110ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5'/> <!--생성경로 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!-- 영업담당 -->      
	<t:ExtComboStore comboType="BOR120" pgmId="ssa110ukrv"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->       
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!--지역-->
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

	Unilite.defineModel('Ssa110ukrvModel', {
		
	    fields: [{name: 'INOUT_CODE'			,text: '수불처코드' 		,type: 'string'},    		
				 {name: 'INOUT_NAME'			,text: '<t:message code="system.label.sales.tranplace" default="수불처"/>' 			,type: 'string'},    		
				 {name: 'SALE_CUSTOM_CODE'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>' 			,type: 'string'},    		
				 {name: 'SALE_CUSTOM_NAME'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>' 			,type: 'string'},    		
				 {name: 'CHOICE'				,text: '<t:message code="system.label.sales.selection" default="선택"/>' 			,type: 'string'},    		
				 {name: 'CHANGE_CUSTOM_CODE'	,text: '변경할 매출처코드'	,type: 'string'},    		
				 {name: 'CHANGE_CUSTOM_NAME'	,text: '변경할 매출처' 		,type: 'string'},    		
				 {name: 'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>' 			,type: 'string'},    		
				 {name: 'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>' 			,type: 'string'},    		
				 {name: 'SPEC'			   		,text: '<t:message code="system.label.sales.spec" default="규격"/>' 			,type: 'string'},    		
				 {name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>' 			,type: 'string', displayField: 'value'},    		
				 {name: 'ORDER_UNIT_Q'			,text: '<t:message code="system.label.sales.qty" default="수량"/>' 			,type: 'string'},    		
				 {name: 'ORDER_UNIT_P'			,text: '<t:message code="system.label.sales.price" default="단가"/>' 			,type: 'string'},    		
				 {name: 'ORDER_UNIT_O'			,text: '<t:message code="system.label.sales.amount" default="금액"/>' 			,type: 'string'},    		
				 {name: 'INOUT_DATE'			,text: '<t:message code="system.label.sales.transdate" default="수불일"/>' 			,type: 'string'},    		
				 {name: 'SALE_PRSN'				,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>' 			,type: 'string'},    		
				 {name: 'DVRY_DATE'				,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>' 			,type: 'string'},    		
				 {name: 'DVRY_TIME'				,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>' 			,type: 'string'},    		
				 {name: 'COMP_CODE'				,text: 'COMP_CODE'		,type: 'string'},    		
				 {name: 'DIV_CODE'				,text: 'DIV_CODE' 		,type: 'string'},    		
				 {name: 'INOUT_NUM'				,text: '<t:message code="system.label.sales.tranno" default="수불번호"/>' 			,type: 'string'},    		
				 {name: 'INOUT_SEQ'				,text: '<t:message code="system.label.sales.transeq" default="수불순번"/>' 			,type: 'string'},    		
				 {name: 'ORDER_NUM'				,text: '<t:message code="system.label.sales.sono" default="수주번호"/>' 			,type: 'string'},    		
				 {name: 'ORDER_SEQ'				,text: '<t:message code="system.label.sales.soseq" default="수주순번"/>' 			,type: 'string'}		
				 
			]
	});

	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa110ukrvMasterStore1',{
			model: 'Ssa110ukrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ssa110ukrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'CUSTOM_NAME'
			
	});
	

	

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    
    
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',		
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{					
    			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
    			name:'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType:'BOR120',
    			allowBlank:false
    		},
		        Unilite.popup('AGENT_CUST',{
		        fieldLabel: '<t:message code="system.label.sales.issueplace" default="출고처"/>',
		        validateBlank:false,
		        
    			allowBlank:false
		    }),{ 
    			fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'DVRY_DATE_FR',
		        endFieldName: 'DVRY_DATE_TO',
		        width: 470,
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today')
	        }, {
    			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
    			name:'ORDER_PRSN', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'S010'
    		} ,
			    Unilite.popup('DIV_PUMOK',{ 
	        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
	        	valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
	        	
	        	listeners: {
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		   }),{
		    	xtype: 'uniTextfield',
		    	fieldLabel: '<t:message code="system.label.sales.issueno" default="출고번호"/>',
		    	name: ''
		    },
		        Unilite.popup('AGENT_CUST',{
		        fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>',
		        validateBlank:false,
		        
		    })]		
		}]
	});    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('ssa110ukrvGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: directMasterStore1,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'INOUT_CODE'			,	width:100, hidden: true},
   				   { dataIndex: 'INOUT_NAME'			,	width:200, locked: true},
   				   { dataIndex: 'SALE_CUSTOM_CODE'		,	width:100, hidden: true},
   				   { dataIndex: 'SALE_CUSTOM_NAME'		,	width:200, locked: true},
   				   { dataIndex: 'CHOICE'				,	width:33},
   				   { dataIndex: 'CHANGE_CUSTOM_CODE'	,	width:100, hidden: true},
   				   { dataIndex: 'CHANGE_CUSTOM_NAME'	,	width:200},
   				   { dataIndex: 'ITEM_CODE'				,	width:100},
   				   { dataIndex: 'ITEM_NAME'				,	width:166},
   				   { dataIndex: 'SPEC'			   		,	width:100},
   				   { dataIndex: 'ORDER_UNIT'			,	width:80},
   				   { dataIndex: 'ORDER_UNIT_Q'			,	width:93},
   				   { dataIndex: 'ORDER_UNIT_P'			,	width:93},
   				   { dataIndex: 'ORDER_UNIT_O'			,	width:93},
   				   { dataIndex: 'INOUT_DATE'			,	width:80},
   				   { dataIndex: 'SALE_PRSN'				,	width:80},
   				   { dataIndex: 'DVRY_DATE'				,	width:80},
   				   { dataIndex: 'DVRY_TIME'				,	width:80, hidden: true},
   				   { dataIndex: 'COMP_CODE'				,	width:100, hidden: true},
   				   { dataIndex: 'DIV_CODE'				,	width:100, hidden: true},
   				   { dataIndex: 'INOUT_NUM'				,	width:100},
   				   { dataIndex: 'INOUT_SEQ'				,	width:100},
   				   { dataIndex: 'ORDER_NUM'				,	width:100},
   				   { dataIndex: 'ORDER_SEQ'				,	width:100}   				   
   		]
        });   
	
	
    Unilite.Main( {
		borderItems:[ 
	 		 masterGrid1,
			panelSearch
		],
		id  : 'ssa110ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{				
			masterGrid1.getStore().loadStoreRecords();
			var viewLocked = masterGrid1.lockedGrid.getView();
			var viewNormal = masterGrid1.normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
