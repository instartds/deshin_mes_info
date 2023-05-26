<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sfa200skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="sfa200skrv" /> 			<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */

	    			
	Unilite.defineModel('Sfa200skrvModel', {
	    fields: [   	
	    	{name: 'ORDER_TYPE'		,text: '오더구분'	,type: 'string'},
		    {name: 'LOT_NO'			,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'		,type: 'string'},
		    {name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'	,type: 'string'},
		    {name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
		    {name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'		,type: 'string'},
		    {name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'},
		    {name: 'ORDER_CUST_CD'	,text: '오더처'		,type: 'string'},
		    {name: 'ORDER_CUST_NM'	,text: '오더처'		,type: 'string'},
		    {name: 'LOT_DATE'		,text: 'LOT부여일'	,type: 'uniDate'},
		    {name: 'ORDER_NUM'		,text: '오더번호'	,type: 'string'},
		    {name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'},
		    {name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'	,type: 'string'},
		    {name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
		    {name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'		,type: 'string'},
		    {name: 'LOT_NO'			,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'		,type: 'string'},
		    {name: 'TRANS_DATE'		,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'		,type: 'uniDate'},
		    {name: 'TRANS_NUM'		,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'	,type: 'string'},
		    {name: 'TRANS_QTY'		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'		,type: 'uniQty'},
		    {name: 'PLAN_NUM'		,text: '<t:message code="system.label.sales.manageno" default="관리번호"/>'	,type: 'string'}
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
	  
	var directMasterStore1 = Unilite.createStore('sfa200skrvMasterStore1',{
		model: 'Sfa200skrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false				// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'sfa200skrvService.selectList1'                	
            }
        }
		,loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ITEM_NAME'
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
			items: [{		    
				xtype: 'container',
		        layout: {type: 'uniTable', columns: 1},
		        items:[{
		        	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
		        	name:'DIV_CODE', 
		        	xtype: 'uniCombobox', 
		        	comboType:'BOR120', 
		        	allowBlank:false ,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
			    },
			    Unilite.popup('DIV_PUMOK',{ 
		        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
		        	valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('ITEM_CODE', masterForm.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', masterForm.getValue('ITEM_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		  	 	}),{
			        fieldLabel: 'LOT_NO',
			        name: 'LOT_NUM',
			        xtype: 'uniTextfield',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('LOT_NUM', newValue);
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
        	name:'DIV_CODE', 
        	xtype: 'uniCombobox', 
        	comboType:'BOR120', 
        	allowBlank:false ,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
	    },
	    Unilite.popup('DIV_PUMOK',{ 
	        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
	        	valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
	        	listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							masterForm.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							masterForm.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));	
                    	},
						scope: this
					},
					onClear: function(type)	{
						masterForm.setValue('ITEM_CODE', '');
						masterForm.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
	   }),{
	        fieldLabel: 'LOT_NO',
	        name: 'LOT_NUM',
	        xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('LOT_NUM', newValue);
				}
			}
	    }]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */    
    var masterGrid1 = Unilite.createGrid('sfa200skrvGrid1', {
    	region: 'north',
		layout: 'fit',
		store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal1',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal1', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    		}],
        columns: [        
	        {dataIndex: 'ORDER_TYPE'	, width: 66},			
			{dataIndex: 'LOT_NO'		, width: 113},			
			{dataIndex: 'ITEM_CODE'		, width: 113},			
			{dataIndex: 'ITEM_NAME'		, width: 140},			
			{dataIndex: 'SPEC'			, width: 140},			
			{dataIndex: 'DIV_CODE'		, width: 86},		
			{dataIndex: 'ORDER_CUST_CD'	, width: 66	, hidden: true},			
			{dataIndex: 'ORDER_CUST_NM'	, width: 133},			
			{dataIndex: 'LOT_DATE'		, width: 80},			
			{dataIndex: 'ORDER_NUM'		, width: 100}			
		] 
    });
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
  var masterGrid2 = Unilite.createGrid('sfa200skrvGrid2', {
  		region: 'center',
    	layout: 'fit', 
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal2', 
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal2', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
            {dataIndex: 'DIV_CODE'		,width: 66, hidden: true},
            {dataIndex: 'ITEM_CODE'		,width: 133},
			{dataIndex: 'ITEM_NAME'		,width: 166},
			{dataIndex: 'SPEC'			,width: 166},
			{dataIndex: 'LOT_NO'		,width: 100},
			{dataIndex: 'TRANS_DATE'	,width: 86},
			{dataIndex: 'TRANS_NUM'		,width: 106},
			{dataIndex: 'TRANS_QTY'		,width: 100},
			{dataIndex: 'PLAN_NUM'		,width: 100}
		] 
    });   
        
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterGrid1, masterGrid2
			]
		},
			panelSearch  	
		],
		id: 'sfa200skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore1.loadStoreRecords();				
			
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
