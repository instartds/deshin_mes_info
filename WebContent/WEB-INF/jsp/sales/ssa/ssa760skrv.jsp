<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="ssa760skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa760skrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->    
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--국내:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S118" /> <!--해외:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/> <!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--부가세유형-->
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
	Unilite.defineModel('ssa760skrvModel1', {
	    fields: [
	    	{name: 'SALE_DATE'	    	,text: '확정일자'			,type: 'uniDate'},
	    	{name: 'CUSTOM_CODE'	    ,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			,type: 'string'},
	    	{name: 'CUSTOM_NAME'	    ,text: '<t:message code="system.label.sales.salesplacename" default="매출처명"/>'			,type: 'string'},
	    	{name: 'SALE_Q'	    		,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'},
	    	{name: 'DISCOUNT_AMT'	    ,text: '<t:message code="system.label.sales.discount" default="할인"/>'				,type: 'uniPrice'},
	    	{name: 'SALE_AMT_O'	    	,text: '<t:message code="system.label.sales.sellingamount" default="판매금액"/>'			,type: 'uniPrice'},
	    	{name: 'TAX_AMT_O'	    	,text: '<t:message code="system.label.sales.vat" default="부가세"/>'			,type: 'uniPrice'},
	    	{name: 'SALE_AMT_TOT'	    ,text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'			,type: 'uniPrice'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa760skrvMasterStore1',{
		model: 'ssa760skrvModel1',
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
            	   read: 'ssa760skrvService.selectList1'                	
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
	                startDate: UniDate.get('startOfMonth'),
	                endDate: UniDate.get('today'),                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('SALE_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('SALE_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
	            },
				Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
					
					holdable: 'hold',
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
				}),
				Unilite.popup('AGENT_CUST', {
						fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>', 
						valueFieldName: 'CUSTOM_CODE',
			    		textFieldName: 'CUSTOM_NAME', 
						 
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
									panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						}
				}),{
					xtype: 'radiogroup',		            		
					fieldLabel: ' ',						            		
					items: [{
						boxLabel: '<t:message code="system.label.sales.salesplaceby" default="매출처별"/>', 
						width: 100, 
						name: 'GUBUN',
						inputValue: '1',
						checked: true 
						
					},{
						boxLabel: '합계표', 
						width: 70, 
						name: 'GUBUN',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {				
							panelResult.getField('GUBUN').setValue(newValue.GUBUN);
							if (newValue.GUBUN == '1' ){  
								masterGrid.getColumn('CUSTOM_CODE').setVisible(false);
								masterGrid.getColumn('SALE_DATE').setVisible(true);
							} else if(newValue.GUBUN == '2' ){
								masterGrid.getColumn('CUSTOM_CODE').setVisible(true);
								masterGrid.getColumn('SALE_DATE').setVisible(false);
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
    		},{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
 		        width: 315,
				allowBlank: false,
                xtype: 'uniDateRangefield',
                startFieldName: 'SALE_DATE_FR',
                endFieldName: 'SALE_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('SALE_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('SALE_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
            },
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				
				holdable: 'hold',
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
			}),
			Unilite.popup('AGENT_CUST', {
						fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>', 
						valueFieldName: 'CUSTOM_CODE',
			    		textFieldName: 'CUSTOM_NAME', 
						 
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
									panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('CUSTOM_CODE', '');
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: ' ',						            		
				items: [{
					boxLabel: '<t:message code="system.label.sales.salesplaceby" default="매출처별"/>', 
					width: 100, 
					name: 'GUBUN',
					inputValue: '1',
					checked: true 
					
				},{
					boxLabel: '합계표', 
					width: 170, 
					name: 'GUBUN',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {				
						panelSearch.getField('GUBUN').setValue(newValue.GUBUN);
						if (newValue.GUBUN == '1' ){  
							masterGrid.getColumn('CUSTOM_CODE').setVisible(false);
							masterGrid.getColumn('SALE_DATE').setVisible(true);
						} else if(newValue.GUBUN == '2' ){
							masterGrid.getColumn('CUSTOM_CODE').setVisible(true);
							masterGrid.getColumn('SALE_DATE').setVisible(false);
						}
					}
				}
			}]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ssa760skrvGrid1', {
    	// for tab
    	region: 'center',
        uniOpt: {
			expandLastColumn: true,
		 	useRowNumberer: false,
		 	useContextMenu: true
        },    
		syncRowHeight: false,   
    	store: directMasterStore1,
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id: 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false} ],
        columns:  [        
        	{ dataIndex: 'SALE_DATE'	 		,		width: 100, locked: true,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.totalamount" default="합계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            }},	
			{ dataIndex: 'CUSTOM_CODE'			,		width: 120, locked: true,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.totalamount" default="합계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            }},	 
			{ dataIndex: 'CUSTOM_NAME'			,		width: 200, locked: true}, 
			{ dataIndex: 'SALE_Q'	    		,		width: 70, summaryType:'sum' }, 
			{ dataIndex: 'DISCOUNT_AMT'			,		width: 80, summaryType:'sum' }, 
			{ dataIndex: 'SALE_AMT_O'	 		,		width: 100, summaryType:'sum' }, 
			{ dataIndex: 'TAX_AMT_O'	 		,		width: 100, summaryType:'sum' }, 
			{ dataIndex: 'SALE_AMT_TOT'			,		width: 150, summaryType:'sum' }
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
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
        	panelSearch.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
        	
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//        	panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelResult.setValue('DEPT_NAME', UserInfo.deptName);
        	panelSearch.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
			
			masterGrid.getColumn('CUSTOM_CODE').hidden = true;
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore1.loadStoreRecords();		
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	
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
