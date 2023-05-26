<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map040skrv"  >
<t:ExtComboStore comboType="AU" comboCode="B015"/>	<!-- 거래처구분		-->
<t:ExtComboStore comboType="BOR120" pgmId="map040skrv" /> 			<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('map040skrvModel', {
	    fields: [
	    	{name:'DEPT_CODE' 		, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'			, type: 'string'},
	    	{name:'DEPT_NAME' 		, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'			, type: 'string'},
	    	{name:'CUSTOM_CODE' 	, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'},
	    	{name:'CUSTOM_NAME' 	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
	    	{name:'IWAL_OUT_AMT_I' 	, text: '매출이월금액'		, type: 'uniPrice'},
	    	{name:'OUT_DR_AMT_I' 	, text: '매출액'			, type: 'uniPrice'},
	    	{name:'OUT_CR_AMT_I' 	, text: '입금'			, type: 'uniPrice'},
	    	{name:'OUT_JAN_AMT_I' 	, text: '매출잔액'			, type: 'uniPrice'},
	    	{name:'IWAL_IN_AMT_I' 	, text: '매입이월금액'		, type: 'uniPrice'},
	    	{name:'IN_CR_AMT_I' 	, text: '매입액'			, type: 'uniPrice'},
	    	{name:'IN_DR_AMT_I' 	, text: '출금'			, type: 'uniPrice'},
	    	{name:'IN_JAN_AMT_I' 	, text: '매입잔액'			, type: 'uniPrice'}
	    	
	    ]	    
	});		//End of Unilite.defineModel
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var MasterStore = Unilite.createStore('map040skrvMasterStore',{
			model: 'map040skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
               		read: 'map040skrvService.selectList'
                }
            },
			loadStoreRecords: function() {
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
	});		// End of var MasterStore 
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
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
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		holdable: 'hold',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
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
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('BILL_DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
				fieldLabel: '전표일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
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
			}, 
			 Unilite.popup('CUST',{
		        fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
		        extParam: {'CUSTOM_TYPE': ['1','2']},
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
				fieldLabel: '거래처구분',
				name:'CUSTOM_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B015',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CUSTOM_TYPE', newValue);
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
	});
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
        		fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		holdable: 'hold',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
				fieldLabel: '전표일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_DATE',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_DATE',newValue);			    		
			    	}
			    }
			},
			
				Unilite.popup('CUST',{
		        fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
		        colspan:2,
		        extParam: {'CUSTOM_TYPE': ['1','2']},
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
				fieldLabel: '거래처구분',
				name:'CUSTOM_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B015',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CUSTOM_TYPE', newValue);
					}
				}
			}
		],
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
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('map040skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
        excelTitle: '거래처별 매입매출잔액 조회',
        store : MasterStore,
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
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [
			{dataIndex:'DEPT_CODE' 	 				, width: 80
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
			//{dataIndex:'SALE_DATE' 	 				, width: 150},
			{dataIndex:'DEPT_NAME' 	 				, width: 150},
			{dataIndex:'CUSTOM_CODE' 	 			, width: 150},
			{dataIndex:'CUSTOM_NAME' 	 			, width: 150},
			{dataIndex:'IWAL_OUT_AMT_I'  			, width: 100  , summaryType: 'sum'},
			{dataIndex:'OUT_DR_AMT_I'  				, width: 100  , summaryType: 'sum'},
			{dataIndex:'OUT_CR_AMT_I'  				, width: 100  , summaryType: 'sum'},
			{dataIndex:'OUT_JAN_AMT_I'  			, width: 100  , summaryType: 'sum'},
			{dataIndex:'IWAL_IN_AMT_I' 				, width: 100  , summaryType: 'sum'},
			{dataIndex:'IN_CR_AMT_I' 				, width: 100  , summaryType: 'sum'},
			{dataIndex:'IN_DR_AMT_I' 				, width: 100  , summaryType: 'sum'},
			{dataIndex:'IN_JAN_AMT_I' 				, width: 100  , summaryType: 'sum'}
		]
    });		//End of var masterGrid 
    
    /**
	 * Main 정의(Main 정의)
	 * @type 
	 */
    Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		masterGrid, panelResult
         	]	
      	},
      	panelSearch     
      	],
		id: 'map040skrvApp',
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			//UniAppManager.setToolbarButtons('reset',false);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			
			
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
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
