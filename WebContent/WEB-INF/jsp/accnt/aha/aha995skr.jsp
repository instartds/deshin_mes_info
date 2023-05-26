<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aha995skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->    
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="J522" /> <!-- 원천세이관구분 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}
	
	//var gsBaseMonthHidden = true;
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aha995skrService.selectMaster',
			update: 'aha995skrService.updateMaster',
			create: 'aha995skrService.insertMaster',
			destroy: 'aha995skrService.deleteMaster',
			syncAll: 'aha995skrService.saveAll'
		}
	});	
	
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aha995skrService.selectDetail',
			update: 'aha995skrService.updateDetail',
			create: 'aha995skrService.insertDetail',
			destroy: 'aha995skrService.deleteDetail',
			syncAll: 'aha995skrService.saveAll2'
		}
	});	
	
	Unilite.defineModel('aha995skrModel1', {
	    fields: [  	  
	    	{name: 'DOC_ID'			, text: '순번'				, type: 'string'},
	    	{name: 'ORD_NUM'		, text: '차수'				, type: 'string'},
		    {name: 'PAY_YYYYMM'		, text: '지급년월'			, type: 'string'},
			{name: 'BASE_YEAR'		, text: '기준년월'			, type: 'string'},		    
		    {name: 'COMPANY_NUM'	, text: '사업자등록번호'	, type: 'string'},
		    {name: 'GUBUN'			, text: '소득구분'			, type: 'string', comboType: 'AU', comboCode: 'J522'},
		    {name: 'CNT'			, text: '인원수'			, type: 'string'},
		    {name: 'TOT_AMT'		, text: '총금액'			, type: 'uniPrice'},
		    {name: 'INC_AMT'		, text: '소득세합'			, type: 'uniPrice'},
		    {name: 'SEND_YN'		, text: '신고서전송여부'	, type: 'string'},
		    {name: 'SEND_DATE'		, text: '신고서전송시간'	, type: 'uniDate'},
		    {name: 'JOB_ID'			, text: 'JOB_ID'			, type: 'string'},
		    {name: 'BILL_DIV_CODE' , text: '신고사업장'        , type: 'string',maxLength:40,comboType:'BOR120', comboCode: 'BILL',allowBlank:false},
		    {name: 'COMP_CODE'		, text: '법인'				, type: 'string'}			    
	    ]
	}); //End of Unilite.defineModel('aha995skrModel1', {
	
	Unilite.defineModel('aha995skrModel2', {
	    fields: [  
			{name: 'DOC_ID'			, text: '순번'			, type: 'string'},
			{name: 'ORD_NUM'		, text: '차수'			, type: 'string'},
			{name: 'PAY_YYYYMM'		, text: '지급년월'		, type: 'string'},
	    	{name: 'INSERT_USER'	, text: '작업자사번'	, type: 'string'},
		    {name: 'DEPT_CODE'		, text: '부서코드'		, type: 'string'},
		    {name: 'DEPT_NAME'		, text: '부서명'		, type: 'string'},
		    {name: 'WAGES_AMT'		, text: '지급액'		, type: 'uniPrice'},
		    {name: 'JOB_ID'			, text: 'JOB_ID'		, type: 'string'},
		    {name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'}
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
	  
	var directMasterStore = Unilite.createStore('aha995skrMasterStore1',{
		model: 'aha995skrModel1',
		uniOpt: {
					isMaster: true,				// 상위 버튼 연결 
		        	editable: false,				// 수정 모드 사용 
		        	deletable: false,			// 삭제 가능 여부 
		            useNavi: false				// prev | newxt 버튼 사용
            },
         autoLoad: false,
         proxy: {
            type: 'direct',
            api: {			
                read: 'aha995skrService.selectMasterList'                	
            }
         },
         /*
         listeners: {
        	datachanged: function(store, eOpts) {	 
       		    
        		if(this.isDirty())	{
    	    		UniAppManager.setToolbarButtons('save', true);
        		}else {
        			UniAppManager.setToolbarButtons('save', false);
        		}	          		
	         }   	
		 },  */ 
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		
           		if(records[0] != null){
           			panelSearch.setValue('ORD_NUM',records[0].get('ORD_NUM'));
           			panelSearch.setValue('PAY_YYYYMM',records[0].get('PAY_YYYYMM'));
           			panelSearch.setValue('COMP_CODE',records[0].get('COMP_CODE'));
           			//panelSearch.setValue('GUBUN',records[0].get('GUBUN'));
	           		if(panelSearch.getValue('ORD_NUM') != ''){
	           				directDetailStore.loadStoreRecords(records);
	           		}
           		}else{
           			panelSearch.setValue('ORD_NUM',''); 
           			panelSearch.setValue('PAY_YYYYMM','');
           			panelSearch.setValue('COMP_CODE','');
           			//panelSearch.setValue('GUBUN','');
           			detailGrid.getStore().removeAll();
           		}
           		
           	}   	
		},		 
		 loadStoreRecords : function()	{
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		 }

	}); //End of var directMasterStore = Unilite.createStore('aha995skrMasterStore1',{
	
	var directDetailStore = Unilite.createStore('aha995skrMasterStore2',{
		model: 'aha995skrModel2',
		uniOpt: {
               isMaster: true,			// 상위 버튼 연결 
	           editable: false,			// 수정 모드 사용 
	           deletable:false,			// 삭제 가능 여부 
	           useNavi : false			// prev | newxt 버튼 사용
            },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'aha995skrService.selectDetailList'                	
            }
        },
		loadStoreRecords: function(record)	{
			var searchParam= Ext.getCmp('searchForm').getValues();
			//alert(record.get('MONEY_UNIT'));
			//var param= {'MONEY_UNIT':record.get('MONEY_UNIT')};	
			var param= '';	
			var params = Ext.merge(searchParam, param);
			console.log( param );
			this.load({
				params : params
			});
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '검색조건',
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
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [
					{
			    		fieldLabel : '사업자등록번호',
			    		name : 'COMPANY_NUM',
			    		allowBlank: false,
			    		hidden: true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('COMPANY_NUM', newValue);
							}
						}
					},
					{
		                fieldLabel: '신고사업장',
		                name:'BILL_DIV_CODE',    
		                xtype: 'uniCombobox',
		                comboType:'BOR120',
						comboCode	: 'BILL',
		                allowBlank: false,
		                listeners: {
		                    change: function(field, newValue, oldValue, eOpts) {                        
		                        panelResult.setValue('BILL_DIV_CODE', newValue);
								var params = {
									BILL_DIV_CODE: newValue
								}												
								aha995skrService.getCompNum(params, function(provider, response)	{							
									if(!Ext.isEmpty(provider)){
										panelResult.setValue('COMPANY_NUM', provider);
									}													
								});			                        
                    		}
                		} 				
					},
					{
						fieldLabel: '기준년도',
						name: 'BASE_YEAR',
						xtype: 'uniYearField',
						value: new Date().getFullYear(),
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('BASE_YEAR', newValue);
							}
						}						
			    	},
			    	{
						fieldLabel: '조회후 선택된 차수',
						name:'ORD_NUM',
						xtype: 'uniTextfield',
						hidden: true
					},
			    	{
						fieldLabel: '조회후 선택된 소득구분',
						name:'GUBUN',
						xtype: 'uniTextfield',
						hidden: true
					},					
			    	{
						fieldLabel: '조회후 선택된 지급년월',
						name:'PAY_YYYYMM',
						xtype: 'uniTextfield',
						hidden: true
					},
			    	{
						fieldLabel: '조회후 선택된 법인',
						name:'COMP_CODE',
						xtype: 'uniTextfield',
						hidden: true
					}
			    	]	            			 
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
		   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		   					}
		
						   	alert(labelText+Msg.sMB083);
						   	invalid.items[0].focus();
						} else {
							  var fields = this.getForm().getFields();
							Ext.each(fields.items, function(item) {
								if(Ext.isDefined(item.holdable) )	{
								 	if (item.holdable == 'hold') {
										item.setReadOnly(true); 
									}
								} 
								if(item.isPopupField)	{
									var popupFC = item.up('uniPopupField')	;							
									if(popupFC.holdable == 'hold') {
										popupFC.setReadOnly(true);
									}
								}
							})  
		   				}
			  		} else {
			  			var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(false);
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;	
								if(popupFC.holdable == 'hold' ) {
									item.setReadOnly(false);
								}
							}
						})
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
		items: [
				{
		    		fieldLabel : '사업자등록번호',
		    		name : 'COMPANY_NUM',
		    		allowBlank: false,
		    		hidden: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('COMPANY_NUM', newValue);
						}
					}
				},   
				{
	                fieldLabel: '신고사업장',
	                name:'BILL_DIV_CODE',    
	                xtype: 'uniCombobox',
	                comboType:'BOR120' ,
					comboCode	: 'BILL',
	                allowBlank: false,
	                listeners: {
	                    change: function(field, newValue, oldValue, eOpts) {                        
	                        panelSearch.setValue('BILL_DIV_CODE', newValue);
							var params = {
								BILL_DIV_CODE: newValue
							}												
							aha995skrService.getCompNum(params, function(provider, response)	{							
								if(!Ext.isEmpty(provider)){
//									alert(provider);
									panelSearch.setValue('COMPANY_NUM', provider);
								}
							});			                        
                		}
            		} 				
				},			
				{
					fieldLabel: '기준년도',
					name: 'BASE_YEAR',
					xtype: 'uniYearField',
					value: new Date().getFullYear(),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('BASE_YEAR', newValue);
						}
					}					
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
		   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		   					}
		
						   	alert(labelText+Msg.sMB083);
						   	invalid.items[0].focus();
						} else {
							  var fields = this.getForm().getFields();
							Ext.each(fields.items, function(item) {
								if(Ext.isDefined(item.holdable) )	{
								 	if (item.holdable == 'hold') {
										item.setReadOnly(true); 
									}
								} 
								if(item.isPopupField)	{
									var popupFC = item.up('uniPopupField')	;							
									if(popupFC.holdable == 'hold') {
										popupFC.setReadOnly(true);
									}
								}
							})  
		   				}
			  		} else {
			  			var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(false);
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;	
								if(popupFC.holdable == 'hold' ) {
									item.setReadOnly(false);
								}
							}
						})
	  				}
					return r;
	  			}	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aha995skrGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useContextMenu: false
        },
        selModel:'rowmodel',
        columns: [        
			{dataIndex: 'DOC_ID'				,         	width: 66 , hidden: true},
			{dataIndex: 'ORD_NUM'				,         	width: 46 }, 
			{dataIndex: 'PAY_YYYYMM'			,         	width: 86 }, 
			{dataIndex: 'COMPANY_NUM'			,         	width: 66 , hidden: true},
			{dataIndex: 'GUBUN'					,         	width: 66 }, 
			{dataIndex: 'CNT'					,         	width: 66 }, 
			{dataIndex: 'TOT_AMT'				,         	width: 96 }, 
			{dataIndex: 'INC_AMT'				,         	width: 96 }, 
			{dataIndex: 'SEND_YN'				,         	width: 106 }, 
			{dataIndex: 'SEND_DATE'				,         	width: 106 }, 			
			{dataIndex: 'JOB_ID'				,         	width: 66 , hidden: true},
			{dataIndex: 'COMP_CODE'				, 			width: 66, hidden: true }	
		] ,
		listeners: {									

        	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {       //Retrieves the top level element representing this component
			    	if(directDetailStore.isDirty()){                  //Returns true if the value of this Field has been changed from its originalValue. Will return false if the field is disabled or has not been rendered 
	        			//alert(Msg.sMB154);
	        			//return;
	        		}
			    	selectedGrid = girdNm
			    	//UniAppManager.setToolbarButtons(['newData', 'delete'], true);			    	
			    });
			  
			}, 			
        	beforeedit  : function( editor, e, eOpts ) {
      			
      			if(!e.record.phantom)	{
					if (UniUtils.indexOf(e.field,['ORD_NUM']))
							return false;
				}
        	},
			selectionchangerecord:function(record , selected)	{
          		panelSearch.setValue('ORD_NUM',record.get('ORD_NUM'));
          		panelSearch.setValue('PAY_YYYYMM',record.get('PAY_YYYYMM'));
          		panelSearch.setValue('COMP_CODE',record.get('COMP_CODE'));
          		//panelSearch.setValue('GUBUN',record.get('GUBUN'));
				directDetailStore.loadStoreRecords(record);
          	}
        }  
    });
    
    var detailGrid = Unilite.createGrid('aha995skrGrid2', {
		layout : 'fit',
    	region:'east',
        store : directDetailStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        selModel:'rowmodel',
   	 	columns: [        		
			{dataIndex: 'DOC_ID'			, width: 66, hidden: true },	
			{dataIndex: 'ORD_NUM'	    	, width: 66 },
			{dataIndex: 'PAY_YYYYMM'		, width: 86 },	
        	{dataIndex: 'INSERT_USER'		, width: 86 }, 	//, align:'center'			
			{dataIndex: 'DEPT_CODE'			, width: 116 }, 				
			{dataIndex: 'DEPT_NAME'			, width: 106 }, 				
			{dataIndex: 'WAGES_AMT'			, width: 106 }, 				
			{dataIndex: 'JOB_ID'			, width: 86, hidden: true }, 				 				
			{dataIndex: 'COMP_CODE'			, width: 66, hidden: true }		
		],
    	listeners: {	
    		
        	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	if(directMasterStore.isDirty()){
	        			//alert(Msg.sMB154);
	        			//return;
	        		}
			    	selectedGrid = girdNm
			    	//UniAppManager.setToolbarButtons(['newData', 'delete'], true);		    	
			    });
			  
			}
		} 
	});
    
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				{
					region : 'west',
					xtype : 'container',
					width : 680,
					layout : 'fit',
					items : [ masterGrid ]
				},
				{
					region : 'center',
					xtype : 'container',
					layout : 'fit',
					flex : 1,
					items : [ detailGrid ]
				},
				panelResult
			]
		},
			panelSearch  	
		],
		id  : 'aha995skrApp',
		fnInitBinding : function() {
			//초기값 set 안해도 됨(박재범부장님) - 그에 따른 로직 주석 처리
//			panelSearch.setValue('BILL_DIV_CODE',UserInfo.divCode);
//			panelResult.setValue('BILL_DIV_CODE',UserInfo.divCode);

//			var params = {
//				BILL_DIV_CODE: baseInfo.gsBillDivCode
//			}												
//			aha995skrService.getCompNum(params, function(provider, response)	{							
//				if(!Ext.isEmpty(provider)){
//					panelSearch.setValue('COMPANY_NUM', provider);
//					panelResult.setValue('COMPANY_NUM', provider);
//				}
//			});					
        	

		},
		onQueryButtonDown : function()	{		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			detailGrid.reset();
			masterGrid.getStore().loadStoreRecords();
			
			//UniAppManager.setToolbarButtons(['reset','newData', 'delete'],true);
		},
		onNewDataButtonDown : function()	{
			if(selectedGrid == 'aha995skrGrid1'){
				var r = {CAL_TYPE  : '1'};
	            masterGrid.createRow(r, 'MONEY_UNIT', masterGrid.getStore().getCount()-1);
				panelSearch.setAllFieldsReadOnly(true);
				UniAppManager.setToolbarButtons('save', true);
			}	
			else if(selectedGrid == 'aha995skrGrid2'){
				alert("DATA생성 버튼을 사용해 주세요"); 	
				return;
			}
				
		},
		onResetButtonDown: function() {
			
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
		
			masterGrid.reset();
			detailGrid.reset();
		
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
		},
		onSaveDataButtonDown: function(config) {
			if(directMasterStore.isDirty()) {
				directMasterStore.saveStore();
			}else if(directDetailStore.isDirty()) {
				directDetailStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {			
			if(selectedGrid == 'aha995skrGrid1'){
				var selIndex = masterGrid.getSelectedRowIndex();
				var selRow = masterGrid.getSelectedRecord();
				if(selRow.phantom != true && directDetailStore.getCount() > 0 )
				{
					if(!confirm('<t:message code="unilite.msg.sMB134"/>' + '\n' + '<t:message code="unilite.msg.sMB062"/>')) {
						return;	
					}else{
						masterGrid.deleteSelectedRow(selIndex);
						masterGrid.getStore().onStoreActionEnable();
						UniAppManager.setToolbarButtons('save', true);
					}
									
				}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow(selIndex);
					masterGrid.getStore().onStoreActionEnable();
					UniAppManager.setToolbarButtons('save', true);
				}
			}else if(selectedGrid == 'aha995skrGrid2'){
				var selIndex = detailGrid.getSelectedRowIndex();
				var selRow = detailGrid.getSelectedRecord();
								
				if(selRow.phantom == true)
					detailGrid.deleteSelectedRow();
				else if(confirm('일괄삭제됩니다.\n 삭제 하시겠습니까?')) {
					//detailGrid.deleteSelectedRow();
					directDetailStore.removeAll();
					//masterGrid.deleteSelectedRow(masterGrid.getSelectedRowIndex());
					UniAppManager.setToolbarButtons('save', true);
				}
			}	
		}
	});
};


</script>
