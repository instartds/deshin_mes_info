<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biz100ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
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

	Unilite.defineModel('Biz100ukrvModel', {
		
	    fields: [
	    	{name: 'DIV_CODE' 				      ,text: '<t:message code="system.label.inventory.division" default="사업장"/>' 			,type: 'string'},
	    	{name: 'CUSTOM_CODE' 			      ,text: '외주처코드' 			,type: 'string'},
	    	{name: 'ITEM_CODE' 				      ,text: '<t:message code="system.label.inventory.item" default="품목"/>' 			,type: 'string'},
	    	{name: 'ITEM_NAME' 				      ,text: '품명' 				,type: 'string'},
	    	{name: 'SPEC'		    		      ,text: '<t:message code="system.label.inventory.spec" default="규격"/>' 				,type: 'string'},
	    	{name: 'STOCK_UNIT' 			      ,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>' 			,type: 'string'},
	    	{name: 'STOCK_Q' 				      ,text: '기초재고량' 			,type: 'uniQty'},
	    	{name: 'AVERAGE_P' 				      ,text: '단가' 				,type: 'uniUnitPrice'},
	    	{name: 'STOCK_I' 				      ,text: '기초금액' 			,type: 'uniPrice'},
	    	{name: 'BASIS_YYYYMM' 			      ,text: '<t:message code="system.label.inventory.applyyearmonth" default="반영년월"/>' 			,type: 'uniDate'},
	    	{name: 'UPDATE_DB_USER' 			  ,text: '<t:message code="system.label.inventory.writer" default="작성자"/>' 			,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'				  ,text: '작성시간' 			,type: 'uniDate'},
	    	{name: 'COMP_CODE' 				      ,text: 'COMP_CODE' 		,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('biz100ukrvMasterStore1',{
			model: 'Biz100ukrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'biz100ukrvService.selectList'                	
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
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false
			},
				Unilite.popup('',{
					fieldLabel: '외주처', 
					textFieldWidth: 70,
					allowBlank:false
				}),
			{ 
    			fieldLabel: '기초년월',
				xtype: 'uniTextfeild',
				allowBlank:false,
				width: 200
				
			},
				Unilite.popup('ITEM',{
					fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>', 
					textFieldWidth: 70
				}),
			{ 
    			fieldLabel: 'EXCEL파일',
				xtype: 'uniTextfeild',
				allowBlank:false,
				width: 200
			}]	
		}]
	});    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('biz100ukrvGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	store: directMasterStore1,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
               		 { dataIndex: 'DIV_CODE' 				     , 	width:100},
               		 { dataIndex: 'CUSTOM_CODE' 			     , 	width:100},
               		 { dataIndex: 'ITEM_CODE' 				     , 	width:113},
               		 { dataIndex: 'ITEM_NAME' 				     , 	width:133},
               		 { dataIndex: 'SPEC'		    		     , 	width:133},
               		 { dataIndex: 'STOCK_UNIT' 				     , 	width:66},
               		 { dataIndex: 'STOCK_Q' 				     , 	width:100},
               		 { dataIndex: 'AVERAGE_P' 				     , 	width:100},
               		 { dataIndex: 'STOCK_I' 				     , 	width:100},
               		 { dataIndex: 'BASIS_YYYYMM' 			     , 	width:66},
               		 { dataIndex: 'UPDATE_DB_USER' 			     , 	width:0},
               		 { dataIndex: 'UPDATE_DB_TIME'			     , 	width:0},
               		 { dataIndex: 'COMP_CODE' 				     , 	width:66}
        ] 
    });   
	
    Unilite.Main( {
		borderItems:[ 
	 		 masterGrid1,
			panelSearch
		],
		id  : 'biz100ukrvApp',
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
