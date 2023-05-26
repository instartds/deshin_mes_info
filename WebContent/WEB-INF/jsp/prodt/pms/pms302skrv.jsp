<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pms302skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 콤보 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 콤보 -->
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="Q031" /> <!-- 접수구분 -->
	<t:ExtComboStore comboType="AU" comboCode="Q023" /> <!-- 접수자 -->
	<t:ExtComboStore comboType="AU" comboCode="Q024" /> <!-- 검사자 -->

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
	Unilite.defineModel('Pms302skrvModel', {
	    fields: [  	  
	    	{name: 'DATA_TYPE'			    ,text: 'DATA_TYPE'	,type: 'string'},
		    {name: 'DIV_CODE'				,text: '<t:message code="system.label.product.division" default="사업장"/>'  	,type: 'string'},
		    {name: 'WORK_SHOP_CODE'		    ,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	,type: 'string'},
		    {name: 'TREE_NAME'				,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'   ,type: 'string'},
		    {name: 'PRODT_DATE'			    ,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'    	,type: 'uniDate'},
		    {name: 'ITEM_CODE'				,text: '<t:message code="system.label.product.item" default="품목"/>'   ,type: 'string'},
		    {name: 'ITEM_NAME'				,text: '<t:message code="system.label.product.itemname" default="품목명"/>'    	,type: 'string'},
		    {name: 'SPEC'					,text: '<t:message code="system.label.product.spec" default="규격"/>'     	,type: 'string'},
		    {name: 'PRODT_Q'				,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'    	,type: 'uniQty'},
		    {name: 'RECEIPT_DATE'			,text: '<t:message code="system.label.product.receiptdate" default="접수일"/>'   ,type: 'uniDate'},
		    {name: 'RECEIPT_PRSN'			,text: '<t:message code="system.label.product.receptionist" default="접수자"/>'    	,type: 'string' , comboType:'AU', comboCode:'Q023'},
		    {name: 'RECEIPT_Q'				,text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'    	,type: 'uniQty'},
		    {name: 'INSPEC_PRSN'			,text: '<t:message code="system.label.product.inspector" default="검사자"/>'    	,type: 'string' , comboType:'AU', comboCode:'Q024'},
		    {name: 'INSPEC_Q'				,text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'    	,type: 'uniQty'},
		    {name: 'GOOD_INSPEC_Q'			,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'    	,type: 'uniQty'},
		    {name: 'TOT_BAD_INSPEC_Q'		,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'   	,type: 'uniQty'},
		    {name: 'NOTINSPEC_Q'			,text: '<t:message code="system.label.product.noinspecqty" default="미검사량"/>'  	,type: 'uniQty'},
		    {name: 'BAD_INSPEC_CODE'		,text: '<t:message code="system.label.product.defectitemcode" default="불량품코드"/>'	,type: 'string'},
		    {name: 'BAD_INSPEC_NAME'		,text: '<t:message code="system.label.product.defectitemname" default="불량품명"/>'  	,type: 'string'},
		    {name: 'BAD_INSPEC_Q'			,text: '<t:message code="system.label.product.defectitemqty" default="불량품량"/>'	,type: 'uniQty'},
		    {name: 'INSPEC_REMARK'		 	,text: '<t:message code="system.label.product.inspecremark" default="검사비고"/>'   ,type: 'string'},
		    {name: 'MANAGE_REMARK'		 	,text: '<t:message code="system.label.product.manageremark" default="관리비고"/>'   ,type: 'string'},
		    {name: 'PRODT_NUM'				,text: '<t:message code="system.label.product.productionno" default="생산번호"/>'   ,type: 'string'},
		    {name: 'RECEIPT_NUM'			,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'   ,type: 'string'},
		    {name: 'RECEIPT_SEQ'			,text: '<t:message code="system.label.product.receiptseq" default="접수순번"/>'   ,type: 'string'},
		    {name: 'INSPEC_NUM'			    ,text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'   ,type: 'string'},
		    {name: 'INSPEC_SEQ'			    ,text: '<t:message code="system.label.product.inspecseq" default="검사순번"/>'   ,type: 'string'},
		    {name: 'LOT_NO'				    ,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'  	,type: 'string'},
		    {name: 'RECEIPT_REMARK'		    ,text: '<t:message code="system.label.product.receiptremark" default="접수비고"/>'   ,type: 'string'},
		    {name: 'INSPEC_REMARK_QMS400T'	,text: '<t:message code="system.label.product.inspecremark" default="검사비고"/>'  	,type: 'string'} 
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
	var directMasterStore1 = Unilite.createStore('pms302skrvMasterStore1',{
		model: 'Pms302skrvModel',
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
            	read: 'pms302skrvService.selectList'                	
            }
        }
		,loadStoreRecords: function()	{
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		}
	/*	,groupField: 'ITEM_NAME'*/
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            topSearch.show();
	        },
	        expand: function() {
	        	topSearch.hide();
	        }
        },
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox',
				comboType: 'BOR120' ,
				allowBlank: false,
				value : UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							topSearch.setValue('DIV_CODE', newValue);
						}
					}
			}, 
				Unilite.popup('ITEM',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					textFieldWidth:170, 
					validateBlank:false,
					valueFieldName: 'ITEM_CODE',
	        		textFieldName:'ITEM_NAME',
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								topSearch.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								topSearch.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							topSearch.setValue('ITEM_CODE', '');
							topSearch.setValue('ITEM_NAME', '');
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name:'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							topSearch.setValue('WORK_SHOP_CODE', newValue);
						}
					}
			},{ 
				fieldLabel: '<t:message code="system.label.product.productionplanscheduling" default="생산계획스케줄링내역"/>', 
				xtype: 'uniDateRangefield',  
				startFieldName: 'PRODT_DATE_FR',
	        	endFieldName:'PRODT_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(topSearch) {
							topSearch.setValue('PRODT_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(topSearch) {
				    		topSearch.setValue('PRODT_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
			},{ 
				fieldLabel: '<t:message code="system.label.product.receiptdate" default="접수일"/>', 
				xtype: 'uniDateRangefield',  
				startFieldName: 'RECEIPT_DATE_FR',
	        	endFieldName:'RECEIPT_DATE_FR_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(topSearch) {
							topSearch.setValue('RECEIPT_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(topSearch) {
				    		topSearch.setValue('RECEIPT_DATE_FR_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
			},{ 
				fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>', 
				xtype: 'uniDateRangefield',  
				startFieldName: 'INSPEC_DATE_FR',
	        	endFieldName:'INSPEC_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(topSearch) {
							topSearch.setValue('INSPEC_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(topSearch) {
				    		topSearch.setValue('INSPEC_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
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
	
    var topSearch = Unilite.createSimpleForm('topSearchForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox',
				comboType: 'BOR120' ,
				allowBlank: false,
				value : UserInfo.divCode,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}, 
				Unilite.popup('ITEM',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					textFieldWidth:170, 
					validateBlank:false,
					valueFieldName: 'ITEM_CODE',
	        		textFieldName:'ITEM_NAME',
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE', topSearch.getValue('ITEM_CODE'));
								panelSearch.setValue('ITEM_NAME', topSearch.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name:'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.product.productionplanscheduling" default="생산계획스케줄링내역"/>', 
				xtype: 'uniDateRangefield',  
				startFieldName: 'PRODT_DATE_FR',
	        	endFieldName:'PRODT_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('PRODT_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PRODT_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			},{ 
				fieldLabel: '<t:message code="system.label.product.receiptdate" default="접수일"/>', 
				xtype: 'uniDateRangefield',  
				startFieldName: 'RECEIPT_DATE_FR',
	        	endFieldName:'RECEIPT_DATE_FR_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('RECEIPT_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('RECEIPT_DATE_FR_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			},{ 
				fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>', 
				xtype: 'uniDateRangefield',  
				startFieldName: 'INSPEC_DATE_FR',
	        	endFieldName:'INSPEC_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('INSPEC_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('INSPEC_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			}]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('pms302skrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
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
/*        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],*/
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: true} 
    	],
        columns: [        
        	{dataIndex: 'DATA_TYPE'			   	, width: 100, hidden: true}, 				
			{dataIndex: 'DIV_CODE'				, width: 66, hidden: true}, 				
			{dataIndex: 'WORK_SHOP_CODE'		, width: 93}, 				
			{dataIndex: 'TREE_NAME'			   	, width: 106}, 				
			{dataIndex: 'PRODT_DATE'			, width: 93}, 				
			{dataIndex: 'ITEM_CODE'			   	, width: 106}, 				
			{dataIndex: 'ITEM_NAME'			   	, width: 133}, 				
			{dataIndex: 'SPEC'					, width: 106}, 				
			{dataIndex: 'PRODT_Q'				, width: 93  , summaryType: 'sum'}, 				
			{dataIndex: 'RECEIPT_DATE'			, width: 93}, 				
			{dataIndex: 'RECEIPT_PRSN'			, width: 93}, 				
			{dataIndex: 'RECEIPT_Q'			   	, width: 93  , summaryType: 'sum'}, 				
			{dataIndex: 'INSPEC_PRSN'			, width: 93}, 				
			{dataIndex: 'INSPEC_Q'				, width: 93  , summaryType: 'sum'}, 				
			{dataIndex: 'GOOD_INSPEC_Q'		   	, width: 93  , summaryType: 'sum'}, 				
			{dataIndex: 'TOT_BAD_INSPEC_Q'		, width: 93  , summaryType: 'sum'}, 				
			{dataIndex: 'NOTINSPEC_Q'			, width: 93}, 				
			{dataIndex: 'BAD_INSPEC_CODE'		, width: 93}, 				
			{dataIndex: 'BAD_INSPEC_NAME'		, width: 93}, 				
			{dataIndex: 'BAD_INSPEC_Q'			, width: 93}, 				
			{dataIndex: 'INSPEC_REMARK'		   	, width: 93}, 				
			{dataIndex: 'MANAGE_REMARK'		   	, width: 93}, 				
			{dataIndex: 'PRODT_NUM'			   	, width: 93}, 				
			{dataIndex: 'RECEIPT_NUM'			, width: 93}, 				
			{dataIndex: 'RECEIPT_SEQ'			, width: 93}, 				
			{dataIndex: 'INSPEC_NUM'			, width: 100}, 				
			{dataIndex: 'INSPEC_SEQ'			, width: 93}, 				
			{dataIndex: 'LOT_NO'				, width: 93}, 				
			{dataIndex: 'RECEIPT_REMARK'		, width: 100}, 				
			{dataIndex: 'INSPEC_REMARK_QMS400T'	, width: 100} 				
		] 
    });
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
 
	Unilite.Main( {
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid1, topSearch
         ]
      },
         panelSearch
      ],
		id: 'pms302skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			
			masterGrid1.getStore().loadStoreRecords();
			/*var viewNormal = masterGrid1.normalGrid.getView();
			var viewLocked = masterGrid1.lockedGrid.getView();
			
			console.log("viewNormal : ",viewNormal);
			console.log("viewLocked : ",viewLocked);
			
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/
		    UniAppManager.setToolbarButtons('excel',true);
			}
		},
		
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
};


</script>
