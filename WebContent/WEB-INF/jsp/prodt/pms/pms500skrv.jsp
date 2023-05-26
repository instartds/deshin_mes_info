<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pms500skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="Q024" /> <!-- 검사담당 --> 

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
	Unilite.defineModel('Pms500skrvModel', {
	    fields: [  	 
	    	{name: 'DIV_CODE'     		,text: 'DIV_CODE'		,type:'string'},
			{name: 'VERIFY_NUM'     	,text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'		,type:'string'},
			{name: 'VERIFY_SEQ'     	,text: '<t:message code="system.label.product.seq" default="순번"/>'			,type:'string'},
			{name: 'VERIFY_DATE'     	,text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'			,type:'uniDate'},
			{name: 'TIME_GUBUN'     	,text: '<t:message code="system.label.product.daynightclass" default="주야구분"/>'		,type:'string'},
			{name: 'INCH'     			,text: 'INCH'			,type:'string'},
			{name: 'INSPEC_PRSNR'     	,text: '<t:message code="system.label.product.inspector" default="검사자"/>'			,type:'string'},
			{name: 'ITEM_CODE'     		,text: '<t:message code="system.label.product.item" default="품목"/>'		,type:'string'},
			{name: 'ITEM_NAME'     		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type:'string'},
			{name: 'SPEC'     			,text: '원단명'			,type:'string'},
			{name: 'ITEM_MAKER'     	,text: 'ITEM_MAKER'		,type:'string'},
			{name: 'ITEM_MAKER_NAME'	,text: '원단사'			,type:'string'},
			{name: 'CUSTOM_CODE'     	,text: 'CUSTOM_CODE'	,type:'string'},
			{name: 'CUSTOM_NAME'     	,text: '고객사'			,type:'string'},
			{name: 'INSPEC_Q'     		,text: 'LOT수량'		,type:'uniQty'},
			{name: 'VERIFY_Q'     		,text: '샘플량'			,type:'uniQty'},
			{name: 'GOOD_VERIFY_Q'     	,text: '적합수량'		,type:'uniQty'},
			{name: 'BAD_VERIFY_Q'     	,text: '부적합수량'		,type:'uniQty'},
			{name: 'BAD_PPM'     		,text: '부적합율(ppm)'	,type:'string'},
			{name: 'VERIFY_PRSN'     	,text: '검증담당자'		,type:'string'},
			{name: 'INSPEC_NUM'     	,text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'		,type:'string'},
			{name: 'INSPEC_SEQ'     	,text: '<t:message code="system.label.product.inspecseq" default="검사순번"/>'		,type:'string'},
			{name: 'RAW_LOT_NO'     	,text: '원단LOT NO'		,type:'string'},
			{name: 'OUT_LOT_NO'     	,text: '출하LOT NO'		,type:'string'},
			{name: 'COMP_CODE'     		,text: 'COMP_CODE'		,type:'string'},
			{name: 'MODULE_SEQ'     	,text: 'MODULE_SEQ'		,type:'string'},
			{name: 'BAD_VERIFY_Q1'     	,text: '외관불량'		,type:'string'},
			{name: 'BAD_VERIFY_Q2'     	,text: '치수불량'		,type:'string'},
			{name: 'BAD_VERIFY_Q3'     	,text: '가공불량'		,type:'string'},
			{name: 'BAD_VERIFY_Q4'     	,text: '품질불량'		,type:'string'}
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
	var directMasterStore1 = Unilite.createStore('pms500skrvMasterStore1',{
		model: 'Pms500skrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'pms500skrvService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
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
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120' ,
		        allowBlank:false,
		        value : UserInfo.divCode,
		        listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							topSearch.setValue('DIV_CODE', newValue);
						}
					}
		    },{ 
		        fieldLabel: '검증검사일', 
				xtype: 'uniDateRangefield',   
				startFieldName: 'ORDER_DATE_FR',
				endFieldName:'ORDER_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(topSearch) {
							topSearch.setValue('ORDER_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(topSearch) {
				    		topSearch.setValue('ORDER_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
			}, 
				Unilite.popup('ITEM',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank:false,
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
				fieldLabel: '출하LOT번호',
				name:'LOT_NO', 
				xtype: 'uniTextfield',
				 listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							topSearch.setValue('LOT_NO', newValue);
						}
					}
			}, 
				Unilite.popup('ITEM',{ 
					fieldLabel: '원단사', 
					validateBlank:false,
					valueFieldName: 'ITEM_CODE_TEST',
	        		textFieldName:'ITEM_NAME_TEST',
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								topSearch.setValue('ITEM_CODE_TEST', panelSearch.getValue('ITEM_CODE_TEST'));
								topSearch.setValue('ITEM_NAME_TEST', panelSearch.getValue('ITEM_NAME_TEST'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							topSearch.setValue('ITEM_CODE_TEST', '');
							topSearch.setValue('ITEM_NAME_TEST', '');
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.inspector" default="검사자"/>',
				name:'INSPEC_PRSNR', 
				xtype: 'uniCombobox',
				comboType:'Q024',
				 listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							topSearch.setValue('INSPEC_PRSNR', newValue);
						}
					}
			}, 
				Unilite.popup('CUST',{ 
					fieldLabel: '<t:message code="system.label.product.custom" default="거래처"/>', 
					validateBlank:false,
					valueFieldName: 'CUST_CODE',
	        		textFieldName:'CUST_NAME',
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								topSearch.setValue('CUST_CODE', panelSearch.getValue('CUST_CODE'));
								topSearch.setValue('CUST_NAME', panelSearch.getValue('CUST_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							topSearch.setValue('CUST_CODE', '');
							topSearch.setValue('CUST_NAME', '');
						}
					}
			})]	            			 
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
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
		        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120' ,
		        allowBlank:false,
		        value : UserInfo.divCode,
		        listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		    },{ 
		        fieldLabel: '검증검사일', 
				xtype: 'uniDateRangefield',   
				startFieldName: 'ORDER_DATE_FR',
				endFieldName:'ORDER_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ORDER_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			}, 
				Unilite.popup('ITEM',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank:false,
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
				fieldLabel: '출하LOT번호',
				name:'LOT_NO', 
				xtype: 'uniTextfield',
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('LOT_NO', newValue);
					}
				}
			}, 
				Unilite.popup('ITEM',{ 
					fieldLabel: '원단사', 
					validateBlank:false,
					valueFieldName: 'ITEM_CODE_TEST',
	        		textFieldName:'ITEM_NAME_TEST',
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE_TEST', topSearch.getValue('ITEM_CODE_TEST'));
								panelSearch.setValue('ITEM_NAME_TEST', topSearch.getValue('ITEM_NAME_TEST'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE_TEST', '');
							panelSearch.setValue('ITEM_NAME_TEST', '');
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.inspector" default="검사자"/>',
				name:'INSPEC_PRSNR', 
				xtype: 'uniCombobox',
				comboType:'Q024',
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('INSPEC_PRSNR', newValue);
					}
				}
			},{
				xtype	: 'component'
			}, 
			Unilite.popup('CUST',{ 
				fieldLabel: '<t:message code="system.label.product.custom" default="거래처"/>', 
				validateBlank:false,
				valueFieldName: 'CUST_CODE',
        		textFieldName:'CUST_NAME',
        		listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('CUST_CODE', topSearch.getValue('CUST_CODE'));
							panelSearch.setValue('CUST_NAME', topSearch.getValue('CUST_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('CUST_CODE', '');
						panelSearch.setValue('CUST_NAME', '');
					}
				}
		})]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('pms500skrvGrid1', {
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
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        columns: [        
        	{dataIndex: 'DIV_CODE'     		, width: 66, hidden: true}, 				
			{dataIndex: 'VERIFY_NUM'     	, width: 100, hidden: true}, 				
			{dataIndex: 'VERIFY_SEQ'     	, width: 40, hidden: true}, 				
			{dataIndex: 'VERIFY_DATE'     	, width: 73, locked: true}, 				
			{dataIndex: 'TIME_GUBUN'     	, width: 73, locked: true}, 				
			{dataIndex: 'INCH'     		 	, width: 60, locked: true}, 				
			{dataIndex: 'INSPEC_PRSNR'     	, width: 80, locked: true}, 				
			{dataIndex: 'ITEM_CODE'     	, width: 80, hidden: true}, 				
			{dataIndex: 'ITEM_NAME'     	, width: 146, locked: true}, 				
			{dataIndex: 'SPEC'     		 	, width: 146}, 				
			{dataIndex: 'ITEM_MAKER'     	, width: 66, hidden: true}, 				
			{dataIndex: 'ITEM_MAKER_NAME'	, width: 100}, 				
			{dataIndex: 'CUSTOM_CODE'     	, width: 66, hidden: true}, 				
			{dataIndex: 'CUSTOM_NAME'       , width: 100}, 				
			{dataIndex: 'INSPEC_Q'     		, width: 93}, 				
			{dataIndex: 'VERIFY_Q'     		, width: 80}, 				
			{dataIndex: 'GOOD_VERIFY_Q'     , width: 80, hidden: true}, 				
			{dataIndex: 'BAD_VERIFY_Q'     	, width: 85}, 				
			{dataIndex: 'BAD_PPM'     		, width: 100}, 				
			{dataIndex: 'VERIFY_PRSN'     	, width: 80, hidden: true}, 				
			{dataIndex: 'INSPEC_NUM'     	, width: 66, hidden: true}, 				
			{dataIndex: 'INSPEC_SEQ'     	, width: 66, hidden: true}, 				
			{dataIndex: 'COMP_CODE'     	, width: 100, hidden: true}, 				
			{dataIndex: 'MODULE_SEQ'     	, width: 100, hidden: true}, 				
			{dataIndex: 'BAD_VERIFY_Q1'     , width: 66}, 				
			{dataIndex: 'BAD_VERIFY_Q2'     , width: 66}, 				
			{dataIndex: 'BAD_VERIFY_Q3'     , width: 66}, 				
			{dataIndex: 'BAD_VERIFY_Q4'     , width: 66}, 				
			{dataIndex: 'RAW_LOT_NO'     	, width: 100},				
			{dataIndex: 'OUT_LOT_NO'     	, width: 100} 
		] 
    });
    
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
		id: 'pms500skrvApp',
		fnInitBinding: function() {
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
