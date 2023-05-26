<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qms701skrv"  >
	<t:ExtComboStore comboType="BOR120" comboCode="B001"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="Q036" /> 				<!-- 검사담당 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!--창고-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */

	    			
	Unilite.defineModel('Qms701skrvModel', {
	    fields: [
	    	{name: 'ITEM_CODE',			text: '<t:message code="system.label.inventory.item" default="품목"/>',	 type: 'string'},
	    	{name: 'ITEM_NAME',			text: '품명',		 type: 'string'},
	    	{name: 'SPEC',				text: '<t:message code="system.label.inventory.spec" default="규격"/>',		 type: 'string'},
	    	{name: 'INSPEC_Q',			text: '총검사량',	 type: 'uniQty'},
	    	{name: 'GOOD_INSPEC_Q',		text: '양품검사량',	 type: 'uniQty'},
	    	{name: 'BAD_INSPEC_Q',		text: '불량검사량',	 type: 'uniQty'},
	    	{name: 'TOT_OUT_Q',			text: '출고량',		 type: 'uniQty'},
	    	{name: 'TOT_IN_Q',			text: '입고량',		 type: 'uniQty'},
	    	{name: 'GOOD_IN_Q',			text: '양품입고량',	 type: 'uniQty'},
	    	{name: 'BAD_IN_Q',			text: '불량입고량',	 type: 'uniQty'},
	    	{name: 'OUT_WH_CODE',		text: '출고창고',	 type: 'string'},
	    	{name: 'OUT_WH_NAME',		text: '출고창고명',	 type: 'string'},
	    	{name: 'IN_WH_CODE',		text: '입고창고',	 type: 'string'},
	    	{name: 'IN_WH_NAME',		text: '입고창고명',	 type: 'string'},
	    	{name: 'INSPEC_DATE',		text: '검사일',		 type: 'uniDate'},
	    	{name: 'INSPEC_PRSN',		text: '검사담당',	 type: 'string'},
	    	{name: 'INSPEC_PRSN_NM',	text: '검사담당자명',type: 'string'},
	    	{name: 'INSPEC_NUM',		text: '검사번호',	 type: 'string'},
	    	{name: 'INSPEC_SEQ',		text: '검사순번',	 type: 'string'},
	    	{name: 'INOUT_NUM',			text: '수불번호',	 type: 'string'},
	    	{name: 'INOUT_SEQ',			text: '수불순번',	 type: 'string'},
	    	{name: 'BAD_INSPEC_CODE',	text: '검사코드',	 type: 'string'},
	    	{name: 'BAD_INSPEC_NAME',	text: '검사항목',	 type: 'string'},
	    	{name: 'BAD_INSPEC_Q',		text: '불량수량',	 type: 'uniQty'},
	    	{name: 'INSPEC_REMARK',		text: '불량내용',	 type: 'string'},
	    	{name: 'MANAGE_REMARK',		text: '조치내용',	 type: 'string'},
	    	{name: 'MEASURED_VALUE',	text: '측청치',		 type: 'string'},
	    	{name: 'MEASURED_SPEC',		text: '<t:message code="system.label.inventory.spec" default="규격"/>',		 type: 'string'},
	    	{name: 'GUBUN',				text: 'GUBUN',		 type: 'string'}
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
	var directMasterStore1 = Unilite.createStore('qms701skrvMasterStore1',{
			model: 'Qms701skrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'qms701skrvService.selectList'               	
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
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '검색조건',         
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
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			    items: [{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120', comboCode:'B001',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '검사담당',
					name:'INSPEC_PRSN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'Q036',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('INSPEC_PRSN', newValue);
						}
					}
				},{
					fieldLabel: '검사일', 
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_DATE',
					endFieldName: 'TO_DATE',	
					width: 315,
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_DATE',newValue);						
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TO_DATE',newValue);			    		
				    	}
				    }
				},
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME', 
						validateBlank: false,
        				listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
									panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						}
				}),{
					fieldLabel: '입고창고',
					name: 'IN_WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('IN_WH_CODE', newValue);
						}
					}
				},{
					fieldLabel: '검사번호',
					xtype: 'uniTextfield',
					name : 'INSPEC_NUM',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('INSPEC_NUM', newValue);
						}
					}
				}]
			}]
    });    
	
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120', comboCode:'B001',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '검사담당',
					name:'INSPEC_PRSN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'Q036',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('INSPEC_PRSN', newValue);
						}
					}
				},{
					fieldLabel: '검사일', 
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_DATE',
					endFieldName: 'TO_DATE',	
					width: 315,
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelSearch.setValue('FR_DATE',newValue);						
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelSearch.setValue('TO_DATE',newValue);			    		
				    	}
				    }
				},
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME', 
						validateBlank: false,
        				listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						}
				}),{
					fieldLabel: '입고창고',
					name: 'IN_WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('IN_WH_CODE', newValue);
						}
					}
				},{
					fieldLabel: '검사번호',
					xtype: 'uniTextfield',
					name : 'INSPEC_NUM',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('INSPEC_NUM', newValue);
						}
					}
				}]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('qms701skrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
        store : directMasterStore1, 
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
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [ 		
			{dataIndex: 'ITEM_CODE',        width: 86,  locked: true}, 				
			{dataIndex: 'ITEM_NAME',        width: 120, locked: true}, 				
			{dataIndex: 'SPEC',         	width: 120},  				
			{dataIndex: 'INSPEC_Q',         width: 100},  				
			{dataIndex: 'GOOD_INSPEC_Q',    width: 100},  				
			{dataIndex: 'BAD_INSPEC_Q',     width: 100},  				
			{dataIndex: 'TOT_OUT_Q',        width: 100},  				
			{dataIndex: 'TOT_IN_Q',         width: 100},  				
			{dataIndex: 'GOOD_IN_Q',        width: 100},  				
			{dataIndex: 'BAD_IN_Q',         width: 100},  				
			{dataIndex: 'OUT_WH_CODE',      width: 100, hidden: true},  				
			{dataIndex: 'OUT_WH_NAME',      width: 120},  				
			{dataIndex: 'IN_WH_CODE',       width: 100, hidden: true},  				
			{dataIndex: 'IN_WH_NAME',       width: 120},  				
			{dataIndex: 'INSPEC_DATE',      width: 100},  				
			{dataIndex: 'INSPEC_PRSN',      width: 100, hidden: true},  				
			{dataIndex: 'INSPEC_PRSN_NM',   width: 100},  				
			{dataIndex: 'INSPEC_NUM',       width: 146},  				
			{dataIndex: 'INSPEC_SEQ',       width: 100},  				
			{dataIndex: 'INOUT_NUM',        width: 146},  				
			{dataIndex: 'INOUT_SEQ',        width: 100},  				
			{dataIndex: 'BAD_INSPEC_CODE',  width: 80},  				
			{dataIndex: 'BAD_INSPEC_NAME',  width: 133},  				
			{dataIndex: 'BAD_INSPEC_Q',     width: 100},  				
			{dataIndex: 'INSPEC_REMARK',    width: 100},  				
			{dataIndex: 'MANAGE_REMARK',    width: 100},  				
			{dataIndex: 'MEASURED_VALUE',   width: 100},  				
			{dataIndex: 'MEASURED_SPEC',    width: 100},  				
			{dataIndex: 'GUBUN',         	width: 100, hidden: true} 			
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
		id  : 'qms701skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
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
