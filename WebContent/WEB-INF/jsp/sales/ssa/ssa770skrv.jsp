<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="ssa770skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa770skrv"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */	    			
	Unilite.defineModel('ssa770skrvModel1', {
	    fields: [{name: 'DEPT_CODE'	    	,text: '<t:message code="system.label.sales.department" default="부서"/>'		,type: 'string'},
	    		 {name: 'DEPT_NAME'	    	,text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'		,type: 'string'},
	    		 {name: 'ITEM_LEVEL1'	    ,text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'		,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store') ,child:'ITEM_LEVEL2'},
	    		 {name: 'ITEM_LEVEL2'	    ,text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'		,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store') ,child:'ITEM_LEVEL3'},
	    		 {name: 'ITEM_LEVEL3'	    ,text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'		,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve3Store')},
	    		 {name: 'SALE_LOC_EXP_I'	,text: '면세매출액'	,type: 'uniPrice'},
	    		 {name: 'SALE_LOC_AMT_I'	,text: '과세매출액'	,type: 'uniPrice'},
	    		 {name: 'TAX_AMT_O'	    	,text: '<t:message code="system.label.sales.vat" default="부가세"/>'		,type: 'uniPrice'},
	    		 {name: 'SALE_LOC_AMT_TOTAL',text: '과세합계'		,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_TOTAL'	,text: '총합계'		,type: 'uniPrice'}	    		 
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa770skrvMasterStore1',{
		model: 'ssa770skrvModel1',
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
            	   read: 'ssa770skrvService.selectList1'                	
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
		},_onStoreDataChanged: function( store, eOpts )	{
	    	
	    }
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
        		layout: {type: 'uniTable', columns:1},
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
        		},{
					fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
	 		        width: 315,
					allowBlank: false,
	                xtype: 'uniDateRangefield',
	                startFieldName: 'SALE_DATE_FR',
	                endFieldName: 'SALE_DATE_TO',
	                startDate: UniDate.get('today'),
           			endDate: UniDate.get('today'),
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
	            },
				Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
					
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
		                	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
				}),{
					fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
					name: 'ITEM_LEVEL1', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
					child: 'ITEM_LEVEL2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_LEVEL1', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
					name: 'ITEM_LEVEL2', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
					child: 'ITEM_LEVEL3',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_LEVEL2', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
					name: 'ITEM_LEVEL3', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve3Store'),
					parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
		            levelType:'ITEM', 
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_LEVEL3', newValue);
						}
					}
				},{
					xtype: 'radiogroup',		            		
					fieldLabel: '분류',						            		
					items: [{
						boxLabel: '부서별', 
						width: 70, 
						name: 'GUBUN',
						inputValue: '1',
						checked: true
					},{
						boxLabel : '<t:message code="system.label.sales.itemgroupby" default="품목분류별"/>', 
						width: 90,
						name: 'GUBUN',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterGrid.reset();
							panelResult.getField('GUBUN').setValue(newValue.GUBUN);
							if (newValue.GUBUN == '1' ){  
								masterGrid.getColumn('DEPT_CODE').setVisible(true);
								masterGrid.getColumn('DEPT_NAME').setVisible(true);
															
								masterGrid.getColumn('ITEM_LEVEL1').setVisible(false);
								masterGrid.getColumn('ITEM_LEVEL2').setVisible(false);
								masterGrid.getColumn('ITEM_LEVEL3').setVisible(false);
							}else if(newValue.GUBUN == '2' ){
								masterGrid.getColumn('DEPT_CODE').setVisible(false);
								masterGrid.getColumn('DEPT_NAME').setVisible(false);
								
								masterGrid.getColumn('ITEM_LEVEL1').setVisible(true);
								masterGrid.getColumn('ITEM_LEVEL2').setVisible(true);
								masterGrid.getColumn('ITEM_LEVEL3').setVisible(true);
							}
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
		layout : {type : 'uniTable', columns : 4},
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
    		},{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
 		        width: 315,
				allowBlank: false,
                xtype: 'uniDateRangefield',
                startFieldName: 'SALE_DATE_FR',
                endFieldName: 'SALE_DATE_TO',
                startDate: UniDate.get('today'),
           		endDate: UniDate.get('today'),      
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
            },
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
				
				colspan: 2,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM', 
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL3', newValue);
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '분류',						            		
				items: [{
					boxLabel: '부서별', 
					width: 70, 
					name: 'GUBUN',
					inputValue: '1',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.sales.itemgroupby" default="품목분류별"/>', 
					width: 90,
					name: 'GUBUN',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterGrid.reset();						
						panelSearch.getField('GUBUN').setValue(newValue.GUBUN);
						if (newValue.GUBUN == '1' ){  
							masterGrid.getColumn('DEPT_CODE').setVisible(true);
							masterGrid.getColumn('DEPT_NAME').setVisible(true);
														
							masterGrid.getColumn('ITEM_LEVEL1').setVisible(false);
							masterGrid.getColumn('ITEM_LEVEL2').setVisible(false);
							masterGrid.getColumn('ITEM_LEVEL3').setVisible(false);
						}else if(newValue.GUBUN == '2' ){
							masterGrid.getColumn('DEPT_CODE').setVisible(false);
							masterGrid.getColumn('DEPT_NAME').setVisible(false);
														
							masterGrid.getColumn('ITEM_LEVEL1').setVisible(true);
							masterGrid.getColumn('ITEM_LEVEL2').setVisible(true);
							masterGrid.getColumn('ITEM_LEVEL3').setVisible(true);
						}
					}
				}
			}]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ssa770skrvGrid1', {
    	// for tab
    	region: 'center',
        //layout: 'fit',    
		syncRowHeight: false,   
		uniOpt: {
		 	expandLastColumn: true,
		 	useRowNumberer: false,
		 	useContextMenu: true
        },
    	store: directMasterStore1,
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id: 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false} ],
        columns:  [  
					{ dataIndex: 'DEPT_CODE'	    	,		   	width: 80,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
                    }},	
					{ dataIndex: 'DEPT_NAME'	    	,		   	width: 180},	
					{ dataIndex: 'ITEM_LEVEL1'	    	,		   	width: 180,hidden:true,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
                    }},	
					{ dataIndex: 'ITEM_LEVEL2'	    	,		   	width: 180,hidden:true},	
					{ dataIndex: 'ITEM_LEVEL3'	    	,		   	width: 180,hidden:true},	
					{ dataIndex: 'SALE_LOC_EXP_I'		,		   	width: 120, summaryType: 'sum'},	
					{ dataIndex: 'SALE_LOC_AMT_I'		,		   	width: 120, summaryType: 'sum'},	
					{ dataIndex: 'TAX_AMT_O'	    	,		   	width: 120, summaryType: 'sum'},	
					{ dataIndex: 'SALE_LOC_AMT_TOTAL'	,		   	width: 120, summaryType: 'sum'},	
					{ dataIndex: 'SALE_AMT_TOTAL'		,		   	width: 120, summaryType: 'sum'}
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
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
//        	panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelResult.setValue('DEPT_NAME', UserInfo.deptName);
        	
        	panelSearch.setValue('SALE_DATE_FR',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_TO',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_TO',UniDate.get('today'));
			
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore1.loadStoreRecords();
//			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.getView();
//			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);			
	
		},		
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
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
