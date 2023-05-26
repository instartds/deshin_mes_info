<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map070skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="map070skrv"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B034" /> <!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP36" /> <!-- 계산서 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
	
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell1 {
background-color: #ffddb4;
}
.x-change-cell2 {
background-color: #fed9fe;
}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	
	Unilite.defineModel('map070skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string',comboType:'BOR120'},
	    	{name: 'CUSTOM_CODE'		, text: '매입처'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '매입처명'		, type: 'string'},
	    	{name: 'COLLECT_DAY'		, text: '지불일'		, type: 'string'},
	    	{name: 'RECEIPT_DAY'		, text: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>'		, type: 'string',comboType:'AU', comboCode:'B034'},
	    	{name: 'BILL_TYPE'			, text: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>'		, type: 'string',comboType:'AU', comboCode:'YP36'},	
	    	{name: 'IWAL_IN_AMT_I'		, text: '이월잔액'		, type: 'uniPrice'},
	    	{name: 'IN_CR_AMT_I'		, text: '매입액'		, type: 'uniPrice'},
	    	{name: 'SALE_AMT_I'			, text: '매출액'		, type: 'uniPrice'},
	    	{name: 'IN_DR_AMT_I'		, text: '지불액'		, type: 'uniPrice'},
	    	{name: 'IN_JAN_AMT_I'		, text: '기말잔액'		, type: 'uniPrice'},
	    	{name: 'END_STOCK_I'		, text: '기말재고액'	, type: 'uniPrice'},
	    	{name: 'SPACE_STOCK_I'		, text: '공간금액'		, type: 'uniPrice'},
	    	{name: 'SC_STOCK_I'			, text: '지불예정금액'	, type: 'uniPrice'},
	    	{name: 'TOP_NAME'			, text: '대표자명'		, type: 'string'},
	    	{name: 'ADDR1'				, text: '<t:message code="system.label.purchase.address" default="주소"/>'		, type: 'string'},
	    	{name: 'TELEPHON'			, text: '<t:message code="system.label.purchase.phoneno" default="전화번호"/>'		, type: 'string'},
	    	{name: 'TOT_CREDIT_AMT'		, text: '한도금액'		, type: 'uniPrice'}
	    	
	    ]
	});//End of Unilite.defineModel('map070skrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('map070skrvMasterStore1', {
		model: 'map070skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'map070skrvService.selectList'                	
			}
		},
		loadStoreRecords : function()	{
			var param= masterForm.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			
			console.log( param );
			this.load({
				params : param
			});
		}
		//groupField: 'CUSTOM_NAME'
			
	});//End of var directMasterStore1 = Unilite.createStore('map070skrvMasterStore1', {
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			/*Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
//				allowBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
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
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
				}
			}),	*/
					
			{
				fieldLabel: '실적일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
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
			},{
	    		fieldLabel: '지불일자',
		 		xtype: 'uniNumberfield',
		 		name: 'COLLECT_DAY',
		 		enforceMaxLength: true,
		 		maxLength: '2',
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('COLLECT_DAY', newValue);
						}
					}
			},
			Unilite.popup('CUST', { 
					fieldLabel: '매입처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
						}
					}
			}),{
				fieldLabel: '고객분류', 
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>', 
				name: 'RECEIPT_DAY',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B034',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RECEIPT_DAY', newValue);
					}
				}
			},{
            	fieldLabel: '만단위 절사여부',
            	name: 'FLOOR',
//				id: 'FLOOR',
				value: 'Y',
				xtype: 'checkbox',
				labelWidth: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FLOOR', newValue);
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},
			/*Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
//				allowBlank: false,
				
				listeners: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							masterForm.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						masterForm.setValue('DEPT_CODE', '');
						masterForm.setValue('DEPT_NAME', '');
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
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
				}
			})
			,*/{
				fieldLabel: '실적일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(masterForm) {
						masterForm.setValue('FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(masterForm) {
			    		masterForm.setValue('TO_DATE',newValue);
			    	}
			    }
			},{
	    		fieldLabel: '지불일자',
		 		xtype: 'uniNumberfield',
		 		name: 'COLLECT_DAY',
		 		enforceMaxLength: true,
		 		maxLength: '2',
		 	    ///colspan:2,
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('COLLECT_DAY', newValue);
						}
					}
			},
			Unilite.popup('CUST', { 
					fieldLabel: '매입처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								masterForm.setValue('CUSTOM_CODE', '');
								masterForm.setValue('CUSTOM_NAME', '');
						}
					}
			}),{
				fieldLabel: '고객분류', 
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('AGENT_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>', 
				name: 'RECEIPT_DAY', 
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B034',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('RECEIPT_DAY', newValue);
					}
				}
			},{
            	fieldLabel: '만단위 절사여부',
            	name: 'FLOOR',
//				id: 'FLOOR',
				value: 'Y',
				xtype: 'checkbox',
				labelWidth: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('FLOOR', newValue);
					}
				}
    		}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('map070skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		excelTitle: '매입처별 지불예정명세서',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: directMasterStore1,
        columns: [
		    {dataIndex: 'COMP_CODE'				, width: 90,hidden:true},
		    {dataIndex: 'DIV_CODE'				, width: 90,hidden:true},
		    {dataIndex: 'CUSTOM_CODE'			, width: 90},
		    {dataIndex: 'CUSTOM_NAME'			, width: 150,
		    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            	}
		    },
		    {dataIndex: 'COLLECT_DAY'			, width: 66,align:'center'},
		    {dataIndex: 'RECEIPT_DAY'			, width: 66,align:'center'},
		    {dataIndex: 'BILL_TYPE'				, width: 90,align:'center'},
		    {dataIndex: 'IWAL_IN_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'IN_CR_AMT_I'			, width: 120,tdCls:'x-change-cell1',summaryType: 'sum'},
		    {dataIndex: 'SALE_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'IN_DR_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'IN_JAN_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'END_STOCK_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'SPACE_STOCK_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'SC_STOCK_I'			, width: 120,tdCls:'x-change-cell2',summaryType: 'sum'},
		    {dataIndex: 'TOP_NAME'				, width: 90,align:'center'},
		    {dataIndex: 'ADDR1'					, width: 120},
		    {dataIndex: 'TELEPHON'				, width: 120},
		    {dataIndex: 'TOT_CREDIT_AMT'		, width: 120,summaryType: 'sum'}
		    
		] 
    });//End of var masterGrid = Unilite.createGrid('ssd100skrvGrid1', {  
	
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			masterForm  	
		],
		id: 'map070skrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('FR_DATE',UniDate.get('today'));
			masterForm.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('FR_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			/*masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);*/
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			
			
			
			masterGrid.getStore().loadStoreRecords();/*
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);*/
			}
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return masterForm.setAllFieldsReadOnly(true);
        }
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});
	
};


</script>
