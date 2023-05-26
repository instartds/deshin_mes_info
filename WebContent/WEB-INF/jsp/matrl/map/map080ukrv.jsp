<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map080ukrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="map080ukrv"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B034" /> <!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP36" /> <!-- 계산서 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="YP35" /> <!-- 지불일자 -->
	<t:ExtComboStore items="${COMBO_COLLECT_DAY}" storeId="collectDayList" /><!--차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell1 {
background-color: #ffddb4;
}
.x-change-cell2 {
background-color: #fed9fe;
}
.x-change-cell3 {
background-color: #fcfac5;
}
</style>
<script type="text/javascript" >

function appMain() {

var checkCount = 0;	

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'map080ukrvService.selectList',
			update: 'map080ukrvService.updateDetail',
			create: 'map080ukrvService.insertDetail',
//			destroy: 'map080ukrvService.deleteDetail',
			syncAll: 'map080ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('map080ukrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string',comboType:'BOR120'},
	    	{name: 'CHECK'				, text: '체크'		, type: 'string'},
	    	{name: 'SELECT'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'		, type: 'boolean'},
	    	{name: 'CHECK_NAME'			, text: '확정여부'		, type: 'string'},
	    	{name: 'CUSTOM_CODE'		, text: '매입처'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '매입처명'		, type: 'string'},
	    	{name: 'COLLECT_DAY'		, text: '지불일'		, type: 'string'},
	    	{name: 'RECEIPT_DAY'		, text: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>'		, type: 'string',comboType:'AU', comboCode:'B034'},
	    	
	    	{name: 'BILL_TYPE'			, text: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>'		, type: 'string',comboType:'AU', comboCode:'YP36'},	
	    	{name: 'IWAL_IN_AMT_I'		, text: '이월잔액'		, type: 'uniPrice'},
	    	{name: 'IN_CR_AMT_I'		, text: '매입액'		, type: 'uniPrice'},
	    	{name: 'SALE_AMT_I'			, text: '매출액'		, type: 'uniPrice'},
	    	{name: 'SALE_COST'			, text: '매출원가'		, type: 'uniPrice'},
	    	{name: 'IN_DR_AMT_I'		, text: '지불액'		, type: 'uniPrice'},
	    	{name: 'IN_JAN_AMT_I'		, text: '기말잔액'		, type: 'uniPrice'},
	    	{name: 'END_STOCK_I'		, text: '기말재고액'	, type: 'uniPrice'},
	    	{name: 'SPACE_STOCK_I'		, text: '공간금액'		, type: 'uniPrice'},
	    	{name: 'SC_STOCK_I'			, text: '지불예정금액'	, type: 'uniPrice'},
	    	{name: 'PAY_AMT'			, text: '지불확정금액'	, type: 'uniPrice'},
	    	{name: 'BILL_DATE' 			, text: '<t:message code="system.label.purchase.billdate" default="계산서일"/>'	, type: 'uniDate'},
	    	{name: 'BILL_DATE_DUMMY' 	, text: '기존계산서일자'	, type: 'uniDate'},
	    	{name: 'TAX_AMT'			, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'		, type: 'uniPrice'},
	    	{name: 'TOP_NAME'			, text: '대표자명'		, type: 'string'},
	    	{name: 'ADDR1'				, text: '<t:message code="system.label.purchase.address" default="주소"/>'		, type: 'string'},
	    	{name: 'TELEPHON'			, text: '<t:message code="system.label.purchase.phoneno" default="전화번호"/>'		, type: 'string'},
	    	{name: 'TOT_CREDIT_AMT'		, text: '한도금액'		, type: 'uniPrice'},
	    	{name: 'AGENT_TYPE'			, text: '고객분류'		, type: 'string'},
	    	{name: 'EX_DATE'			, text: '<t:message code="system.label.purchase.exslipdate" default="결의전표일"/>'	, type: 'string'},
	    	{name: 'PAY_YYYYMM_CHECK'	, text: '지불년월'		, type: 'string'},
	    	{name: 'COMPARE_PAY'		, text: '확정금액확인'	, type: 'string'},
	    	{name: 'CHECK_NAME_DUMMY'	, text: '확정여부확인'	, type: 'string'},
	    	{name: 'COMPANY_NUM'		, text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>'	, type: 'string', editable: false},
	    	{name: 'BANK_CODE'			, text: '은행코드'		, type: 'string', editable: false},
	    	{name: 'BANK_NAME'			, text: '은행명'		, type: 'string', editable: false},
	    	{name: 'BANKBOOK_NUM'		, text: '계좌번호'		, type: 'string', editable: false},
	    	{name: 'BANKBOOK_NAME'		, text: '예금주'		, type: 'string', editable: false},
	    	{name: 'RECEIPT_DAY_REF'	, text: '결제조건ref'	, type: 'string'},
	    	{name: 'AGENT_TYPE_REF'		, text: '고객분류ref'	, type: 'string'},
	    	{name: 'COLLECT_DAY_MAP050_G'		, text: '차수'	, type: 'string'}
	    	
	    ]
	});//End of Unilite.defineModel('map080ukrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('map080ukrvMasterStore1', {
		model: 'map080ukrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable: false,		// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= masterForm.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
      
           		
           		var count = masterGrid.getStore().getCount();  
           		if(count > 0){
	           		Ext.each(records, function(record,i)  {
	           			if(record.get('CHECK_NAME') == '<t:message code="system.label.purchase.confirmation" default="확정"/>'){
	           				UniAppManager.setToolbarButtons(['print'], true);
	           			}
	           		})
           		}
           	}
		},
		saveStore : function()	{	
			
			var paramMaster= masterForm.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
        	
			if(inValidRecs.length == 0 )	{
				config = {
							params: [paramMaster],
						success: function(batch, option) {
							directMasterStore1.loadStoreRecords();
							
							
						/*	UniliteComboServiceImpl.getCollectDay({}, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.data.StoreManager.lookup('collectDayList').loadData(provider);
								}
							});*/
							
							
							var param = {"DIV_CODE": masterForm.getValue('DIV_CODE'),
							 			"PAY_YYYYMM": UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6)
										};
							map080ukrvService.getCollectDay(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									masterForm.setValue('COLLECT_DAY_MAX',provider['COLLECT_DAY']);
								}
							});	
						}
							
					};
					this.syncAllDirect(config);
				
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
		//groupField: 'CUSTOM_NAME'
			
	});//End of var directMasterStore1 = Unilite.createStore('map080ukrvMasterStore1', {
	
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
				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('COLLECT_DAY_MAP050', '');
						panelResult.setValue('COLLECT_DAY_MAP050', '');
						if(Ext.isEmpty(newValue) || Ext.isEmpty(panelResult.getValue('PAY_YYYYMM'))){
							return false;
						}
						panelResult.setValue('DIV_CODE', newValue);
						
						var param = {"DIV_CODE": newValue,
			 				"PAY_YYYYMM": UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6)
						};
						map080ukrvService.getCollectDay(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('COLLECT_DAY_MAX',provider['COLLECT_DAY']);
							}
						});	
					}
				}
			},
		/*	Unilite.popup('DEPT', { 
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
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
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
				fieldLabel: '지불년월',
				name: 'PAY_YYYYMM',
	            xtype: 'uniMonthfield',
//	            value: UniDate.get('today'),
	            allowBlank: false,
	            holdable: 'hold',
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('COLLECT_DAY_MAP050', '');
						panelResult.setValue('COLLECT_DAY_MAP050', '');
						if(Ext.isEmpty(newValue) || Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							return false;
						}
						panelResult.setValue('PAY_YYYYMM', newValue);
						
						var param = {"DIV_CODE": masterForm.getValue('DIV_CODE'),
			 				"PAY_YYYYMM": UniDate.getDbDateStr(newValue).substring(0, 6)
						};
						map080ukrvService.getCollectDay(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('COLLECT_DAY_MAX',provider['COLLECT_DAY']);
							}
						});	
					}
				}
	        },{
	    		fieldLabel: '차수',
	    		name: 'COLLECT_DAY_MAP050',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('collectDayList'),
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('COLLECT_DAY_MAP050', newValue);
						},
						expand: function(field,eOpts) {
							var maskedCombo = field.getPicker();
							
							maskedCombo.mask('loading...');
							var param = {"DIV_CODE": masterForm.getValue('DIV_CODE'),
			 					"PAY_YYYYMM": UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6)
							};
							map080ukrvService.getNewCollectDay(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.data.StoreManager.lookup('collectDayList').loadData(provider);
									maskedCombo.unmask();
								}
							});	
							
							
							/*UniliteComboServiceImpl.getCollectDay({}, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.data.StoreManager.lookup('collectDayList').loadData(provider);
									maskedCombo.unmask();
								}
							});*/
						},
						beforequery: function(queryPlan, eOpts ) {
//					        var pValue = masterForm.getValue('DIV_CODE') + '-' + UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6);
					        
					        queryPlan.combo.bindStore(Ext.data.StoreManager.lookup('collectDayList'));
					        
					       /* var store = queryPlan.combo.getStore();
					        if(!Ext.isEmpty(pValue)) {
					        	store.clearFilter(true);
					        	queryPlan.combo.queryFilter = null;    
					         	store.filter('option', pValue);
					        }*//*else {
						         store.clearFilter(true);
						         queryPlan.combo.queryFilter = null; 
						         store.loadRawData(store.proxy.data);
					        }*/
					     }
				}
			},{
	    		fieldLabel: 'PAY_DATE',
	    		name: 'PAY_DATE',
	    		xtype:'uniTextfield',
	    		hidden:true
			},/*{ 
				fieldLabel: '지불확정일자',
				xtype: 'uniTextfield',
		 		name: 'PAY_YYYYMM',
		 		enforceMaxLength: true,
		 		maxLength: '6',
		 		allowBlank: false,
				holdable: 'hold',
				name: 'PAY_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            holdable: 'hold',
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_DATE', newValue);
						
						masterForm.setValue('BILL_DATE', newValue);
						panelResult.setValue('BILL_DATE', newValue);
						if(newValue == null){
							return false;
						}else{
							masterForm.setValue('S_PAY_YYYYMM', UniDate.getDbDateStr(newValue).substring(0, 6));
							masterForm.setValue('S_COLLECT_DAY', UniDate.getDbDateStr(newValue).substring(6, 8));
						}
					}
				}
	        },*/{
	    		fieldLabel: '지불일자',
		 		/*xtype: 'uniTextfield',
		 		name: 'COLLECT_DAY',
		 		allowBlank: false,
				holdable: 'hold',
		 		enforceMaxLength: true,
		 		maxLength: '2',
		 		allowBlank: false,
				holdable: 'hold',*/
	    		name: 'COLLECT_DAY',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'YP35',
//		 		allowBlank: false,
//				holdable: 'hold',
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('COLLECT_DAY', newValue);
						/*if(newValue == null){
						return false;
						}else{	
							if(masterForm.getValue('PAY_YYYYMM') != null){
								if(newValue.length == 2 ){
									masterForm.setValue('PAY_DATE', UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6) + newValue);
								}else if(newValue.length == 1){
									masterForm.setValue('PAY_DATE', UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6) + '0' +newValue);
								}else if(newValue == ''){
									masterForm.setValue('PAY_DATE','');
								}
							}
						}*/
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
    		}/*,{
				fieldLabel:'지불확정일자',
				name:'PAY_DATE',
				xtype: 'uniTextfield',
				hidden: true
			}*/,{
	        	fieldLabel:'저장용 차수(map050t collect_day)',
	        	name:'COLLECT_DAY_MAX',
	        	xtype:'uniTextfield',
	        	hidden: true
	        },{
				fieldLabel:'저장용지불년월',
				name:'S_PAY_YYYYMM',
				xtype: 'uniTextfield',
				hidden: true
			},{
				fieldLabel:'저장용지불일자',
				name:'S_COLLECT_DAY',
				xtype: 'uniTextfield',
				hidden: true
			},{
				fieldLabel:'<t:message code="system.label.purchase.departmencode" default="부서코드"/>',
				name:'DEPT_CODE',
				xtype: 'uniTextfield',
				hidden: true
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.purchase.classfication" default="구분"/>',						            		
				labelWidth:90,
//					colspan:2,
				items : [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width: 60,
					name: 'CHECKING',
					inputValue: 'A',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.purchase.confirmation" default="확정"/>',
					width: 60,
					name: 'CHECKING' ,
					inputValue: 'B'
				},{
					boxLabel: '<t:message code="system.label.purchase.noconfirm" default="미확정"/>',
					width: 60,
					name: 'CHECKING' ,
					inputValue: 'C'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelResult.getField('CHECKING').setValue(newValue.CHECKING);
						}
					}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				name: 'BILL_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DATE', newValue);
					}
				}
	        },{
				xtype: 'radiogroup',		            		
				fieldLabel: '출력조건',						            		
				labelWidth:90,
//					colspan:2,
				items : [{
					boxLabel: '기본',
					width: 60,
					name: 'OUTPUT',
					inputValue: 'A',
					checked: true
				},{
					boxLabel: '매입기준',
					width: 80,
					name: 'OUTPUT' ,
					inputValue: 'B'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelResult.getField('OUTPUT').setValue(newValue.OUTPUT);
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
				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('COLLECT_DAY_MAP050', '');
						panelResult.setValue('COLLECT_DAY_MAP050', '');
						if(Ext.isEmpty(newValue) || Ext.isEmpty(panelResult.getValue('PAY_YYYYMM'))){
							return false;
						}
						masterForm.setValue('DIV_CODE', newValue);
						
						var param = {"DIV_CODE": newValue,
			 				"PAY_YYYYMM": UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6)
						};
						map080ukrvService.getCollectDay(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('COLLECT_DAY_MAX',provider['COLLECT_DAY']);
							}
						});
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
			})*/
			{
				fieldLabel: '실적일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
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
				fieldLabel: '지불년월',
				name: 'PAY_YYYYMM',
	            xtype: 'uniMonthfield',
//	            value: UniDate.get('today'),
	            allowBlank: false,
	            holdable: 'hold',
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('COLLECT_DAY_MAP050', '');
						panelResult.setValue('COLLECT_DAY_MAP050', '');
						if(Ext.isEmpty(newValue) || Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							return false;
						}
						masterForm.setValue('PAY_YYYYMM', newValue);
						
						
					var param = {"DIV_CODE": panelResult.getValue('DIV_CODE'),
			 			"PAY_YYYYMM": UniDate.getDbDateStr(newValue).substring(0, 6)
						};
					map080ukrvService.getCollectDay(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
							masterForm.setValue('COLLECT_DAY_MAX',provider['COLLECT_DAY']);
						}
					});	
					}
				}
	        },{
	    		fieldLabel: '차수',
	    		name: 'COLLECT_DAY_MAP050',
				xtype: 'uniCombobox',
//				store: Ext.data.StoreManager.lookup('collectDayList'),
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('COLLECT_DAY_MAP050', newValue);
						},
						expand: function(field,eOpts) {
							var maskedCombo = field.getPicker();
							
							maskedCombo.mask('loading...');
							var param = {"DIV_CODE": panelResult.getValue('DIV_CODE'),
			 					"PAY_YYYYMM": UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6)
							};
							map080ukrvService.getNewCollectDay(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.data.StoreManager.lookup('collectDayList').loadData(provider);
									maskedCombo.unmask();
								}
							});	
							
							
							/*UniliteComboServiceImpl.getCollectDay({}, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.data.StoreManager.lookup('collectDayList').loadData(provider);
									maskedCombo.unmask();
								}
							});*/
						},
						beforequery: function(queryPlan, eOpts ) {
//					        var pValue = panelResult.getValue('DIV_CODE') + '-' + UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6);
					        queryPlan.combo.bindStore(Ext.data.StoreManager.lookup('collectDayList'));
					        
					      /*  var store = queryPlan.combo.getStore();
					        if(!Ext.isEmpty(pValue)) {
					        	store.clearFilter(true);
					        	queryPlan.combo.queryFilter = null;    
					         	store.filter('option', pValue);
					        }else {
						         store.clearFilter(true);
						         queryPlan.combo.queryFilter = null; 
						         store.loadRawData(store.proxy.data);
					        }*/
					     }
				}
			},/*{ 
				fieldLabel: '지불확정일자',
				xtype: 'uniTextfield',
		 		name: 'PAY_YYYYMM',
		 		enforceMaxLength: true,
		 		maxLength: '6',
		 		allowBlank: false,
				holdable: 'hold',
				name: 'PAY_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            holdable: 'hold',
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('PAY_DATE', newValue);
						
						masterForm.setValue('BILL_DATE', newValue);
						panelResult.setValue('BILL_DATE', newValue);
						if(newValue == null){
							return false;
						}else{	
							masterForm.setValue('S_PAY_YYYYMM', UniDate.getDbDateStr(newValue).substring(0, 6));
							masterForm.setValue('S_COLLECT_DAY', UniDate.getDbDateStr(newValue).substring(6, 8));
						}
					}
				}
	        },*/{
	    		fieldLabel: '지불일자',
		 		/*xtype: 'uniTextfield',
		 		name: 'COLLECT_DAY',
		 		enforceMaxLength: true,
		 		maxLength: '2',
		 		allowBlank: false,
				holdable: 'hold',*/
	    		name: 'COLLECT_DAY',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'YP35',
//		 		allowBlank: false,
//				holdable: 'hold',
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('COLLECT_DAY', newValue);
					/*		
					if(newValue == null){
						return false;
					}else{
						if(panelResult.getValue('PAY_YYYYMM') != null){
							if(newValue.length == 2 ){
								masterForm.setValue('PAY_DATE', UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6) + newValue);
							}else if(newValue.length == 1){
								masterForm.setValue('PAY_DATE', UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6) + '0' +newValue);
							}else if(newValue == ''){
								masterForm.setValue('PAY_DATE','');
							}
						}
					}*/
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
    		},{
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.purchase.classfication" default="구분"/>',						            		
					labelWidth:90,
//					colspan:2,
					items : [{
						boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
						width: 60,
						name: 'CHECKING',
						inputValue: 'A',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.purchase.confirmation" default="확정"/>',
						width: 60,
						name: 'CHECKING' ,
						inputValue: 'B'
					},{
						boxLabel: '<t:message code="system.label.purchase.noconfirm" default="미확정"/>',
						width: 60,
						name: 'CHECKING' ,
						inputValue: 'C'
					}],
					listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								masterForm.getField('CHECKING').setValue(newValue.CHECKING);
							}
						}
				},{ 
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				name: 'BILL_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BILL_DATE', newValue);
					}
				}
	        },{
				xtype: 'radiogroup',		            		
				fieldLabel: '출력조건',						            		
				labelWidth:90,
//					colspan:2,
				items : [{
					boxLabel: '기본',
					width: 60,
					name: 'OUTPUT',
					inputValue: 'A',
					checked: true
				},{
					boxLabel: '매입기준',
					width: 80,
					name: 'OUTPUT' ,
					inputValue: 'B'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							masterForm.getField('OUTPUT').setValue(newValue.OUTPUT);
						}
					}
			}/*,{	
				text: '전체선택',
				id: 'AllSelectbtn',
				name : 'AllSelectbtn',
				xtype: 'button',
//				disabled: true,
				colspan:4,
				handler: function() {	
					var records = directMasterStore1.data.items;  
						Ext.each(records,  function(record, index, records){
							if(record.get('CHECK_NAME') != '<t:message code="system.label.purchase.confirmation" default="확정"/>' && record.get('SC_STOCK_I') != 0){
								record.set('SELECT', true);
								
								record.set('CHECK', '1'); //확정
								record.set('CHECK_NAME', '<t:message code="system.label.purchase.confirmation" default="확정"/>');
								record.set('PAY_AMT', record.get('SC_STOCK_I'));
								checkCount++;
							}
							
						});
						
						if(checkCount > 0){
			    			UniAppManager.setToolbarButtons('save',true);
			    		}else if(checkCount < 1){
			    			UniAppManager.setToolbarButtons('save',false);
			    		}
					}
			},{	
				text: '전체취소',
				id: 'AllDeselectbtn',
				name : 'AllDeselectbtn',
				xtype: 'button',
//				disabled: true,
				handler: function() {	
					var records = directMasterStore1.data.items;  
						Ext.each(records,  function(record, index, records){
							record.set('SELECT', false);
							
							
						if(record.get('CHECK') == '1' ){
							record.set('CHECK','');
							record.set('CHECK_NAME',record.get('CHECK_NAME_DUMMY'));
							record.set('PAY_AMT', '');
						}else if(record.get('CHECK') == '2' ){
							record.set('CHECK','');
							record.set('CHECK_NAME',record.get('CHECK_NAME_DUMMY'));
						}else if(record.get('CHECK') == '3' ){
							record.set('CHECK','');
							record.set('CHECK_NAME',record.get('CHECK_NAME_DUMMY'));
							record.set('PAY_AMT',record.get('COMPARE_PAY'));
						}
							checkCount--;
							
						});
						
						if(checkCount > 0){
			    			UniAppManager.setToolbarButtons('save',true);
			    		}else if(checkCount < 1){
			    			UniAppManager.setToolbarButtons('save',false);
			    		}
					}
			}*/],
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('map080ukrvGrid1', {
    	// for tab    	
//		layout: 'fit',
		region: 'center',
		excelTitle: '지불예정명세서등록',
	/*	selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false,
        	listeners: {        
        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			
        		},
				select: function(grid, record, index, eOpts ){		
					
					var records = masterGrid.getSelectedRecords();
					if(records.length > '0'){
						UniAppManager.setToolbarButtons('save',true);
						
					}
					if(record.get('CHANGE_BASIS_NUM')==''){
						record.set('CHECK','2');	//신규라고 알려주기 위해 임의로 컬럼 생성
					}else{
						record.set('CHECK','');
					}
					
					
	          	},
				deselect:  function(grid, record, index, eOpts ){
					
					record.set('CHECK','');
					
					var records = masterGrid.getSelectedRecords();
					if(records.length < '1'){
						UniAppManager.setToolbarButtons('save',false);
					}
					
        		}
        		
        		
			select: function(grid, record, index, eOpts ){					
				
				var records = masterGrid.getSelectedRecords();
					if(records.length > '0'){
						UniAppManager.setToolbarButtons('save',true);
					}
					
				if(record.get('PAY_AMT') == '' 
				&& record.get('EX_DATE') == ''
				&& record.get('PAY_YYYYMM_CHECK') == ''){
					
					record.set('CHECK', '1'); //확정
					record.set('CHECK_NAME', '<t:message code="system.label.purchase.confirmation" default="확정"/>');
					record.set('PAY_AMT', record.get('SC_STOCK_I'));
				   
				}else if(record.get('PAY_AMT') != '' 
				&& record.get('EX_DATE') == ''
				&& record.get('PAY_YYYYMM_CHECK') != ''){
					
					record.set('CHECK', '2'); //취소
					record.set('CHECK_NAME', '취소');
					
				}else if(record.get('EX_DATE') != ''){
					alert("기표된자료");
				}
				
					
				보류	if(record.get('PAY_AMT') == ''){
						record.set('CHECK','1');	//확정
						record.set('CHECK_NAME', '<t:message code="system.label.purchase.confirmation" default="확정"/>');
						record.set('PAY_AMT',record.get('SC_STOCK_I'));
						
						
					}else if(record.get('PAY_AMT') == '' && record.get('PAY_YYYYMM_CHECK') == ''){
						record.set('CHECK','1');	//금액수정
						record.set('CHECK_NAME', '<t:message code="system.label.purchase.confirmation" default="확정"/>');
					}
					
					
					else if(record.get('PAY_YYYYMM_CHECK') != ''){
					if(record.get('EX_DATE') == ''){
						record.set('CHECK','2'); //취소
						record.set('CHECK_NAME', '취소');
						}else{
							alert("기표된자료");
						}
					}
					
			체크로직 비활성화	var sm = masterGrid.getSelectionModel();
					var selRecords = masterGrid.getSelectionModel().getSelection();
					
					 Ext.each(directMasterStore1.data.items, function(rec, index) {
								if( (rec.get('INOUT_CODE') ==  record.get('INOUT_CODE')) 
								&& (UniDate.getDateStr(rec.get('BILL_DATE')) ==  UniDate.getDateStr(record.get('BILL_DATE'))) 
								&& (rec.get('BILL_NUM') == '')
								&& (rec.get('CHANGE_BASIS_NUM') == '')){
									selRecords.push(rec);
								}				
					});
					sm.select(selRecords);
	          	},
				deselect:  function(grid, record, index, eOpts ){
					
					if(record.get('CHECK') == '1' ){
						record.set('CHECK','');
						record.set('CHECK_NAME','');
						record.set('PAY_AMT', '');
					}else if(record.get('CHECK') == '2' ){
						record.set('CHECK','');
						record.set('CHECK_NAME','');
					}
					
					else if(record.get('CHECK') == '3'){	금액필드 수정후 체크박스 deselect시 관련	보류
						record.set('CHECK','');
						record.set('CHECK_NAME','');
						//record.set('PAY_AMT',); 확정금액에 예전금액으로 돌림 필요	
					}
					
					
					
					var records = masterGrid.getSelectedRecords();
					if(records.length < '1'){
						UniAppManager.setToolbarButtons('save',false);
					}
        		}
        	}
        }),*/
        uniOpt: {
        	onLoadSelectFirst: false, 
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        tbar: [{
			xtype: 'button',
			text: '전체선택',
			handler: function() {	
				var records = directMasterStore1.data.items;  
					Ext.each(records,  function(record, index, records){
						if(record.get('CHECK_NAME') != '<t:message code="system.label.purchase.confirmation" default="확정"/>' && record.get('SC_STOCK_I') != 0){
							record.set('SELECT', true);
							
							record.set('CHECK', '1'); //확정
							record.set('CHECK_NAME', '<t:message code="system.label.purchase.confirmation" default="확정"/>');
							record.set('PAY_AMT', record.get('SC_STOCK_I'));
							if(record.get('RECEIPT_DAY_REF') == 'Y' && record.get('AGENT_TYPE_REF') == '3'){
							record.set('BILL_DATE', masterForm.getValue('BILL_DATE'));
							}
							checkCount++;
						}
					});
					
					if(checkCount > 0){
		    			UniAppManager.setToolbarButtons('save',true);
		    		}else if(checkCount < 1){
		    			UniAppManager.setToolbarButtons('save',false);
		    		}
			}
		},{
			xtype: 'button',
			text: '전체취소',
			handler: function() {	
				var records = directMasterStore1.data.items;  
					Ext.each(records,  function(record, index, records){
						record.set('SELECT', false);
						
					if(record.get('CHECK') == '1' ){
						record.set('CHECK','');
						record.set('CHECK_NAME',record.get('CHECK_NAME_DUMMY'));
						record.set('PAY_AMT', '');
						if(record.get('RECEIPT_DAY_REF') == 'Y' && record.get('AGENT_TYPE_REF') == '3'){
							record.set('BILL_DATE', '');
							}
					}else if(record.get('CHECK') == '2' ){
						record.set('CHECK','');
						record.set('CHECK_NAME',record.get('CHECK_NAME_DUMMY'));
					}else if(record.get('CHECK') == '3' ){
						record.set('CHECK','');
						record.set('CHECK_NAME',record.get('CHECK_NAME_DUMMY'));
						record.set('PAY_AMT',record.get('COMPARE_PAY'));
					}
						checkCount--;
						
					});
					
					if(checkCount > 0){
		    			UniAppManager.setToolbarButtons('save',true);
		    		}else if(checkCount < 1){
		    			UniAppManager.setToolbarButtons('save',false);
		    		}
				}
		}],
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
		    {dataIndex: 'CHECK'					, width: 70,hidden:true},
		    {dataIndex: 'SELECT'  				, width: 88, xtype: 'checkcolumn',align:'center',locked: true,
		    listeners: {    
		/*onHeaderClick: function(headerCt, header, e, el) {
	        var me = this,
	            grid = headerCt.grid;
	
	        if (!me.checked) {
	            me.fireEvent('selectall', grid.getStore(), header, true);
	            header.getEl().down('img').addCls(Ext.baseCSSPrefix + 'grid-checkcolumn-checked');
	            me.checked = true;
	        } else {
	            me.fireEvent('selectall', grid.getStore(), header, false);
	            header.getEl().down('img').removeCls(Ext.baseCSSPrefix + 'grid-checkcolumn-checked');
	            me.checked = false;
	        }
    },
*/
/*    onSelectAll: function(store, column, checked) {
        var dataIndex = column.dataIndex;
        for(var i = 0; i < store.getCount(); i++) {
            var record = store.getAt(i);
            if (checked) {
                record.set(dataIndex, true);
            } else {
                record.set(dataIndex, false);
            }
        }
    },  */
		    	checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
		    		
		    		var grdRecord = masterGrid.getStore().getAt(rowIndex);
		    	
		    		if(checked == true){
//	    				var records = masterGrid.getSelectedRecords();
//						if(records.length > 0){
//							UniAppManager.setToolbarButtons('save',true);
//						}
						
						if(grdRecord.get('PAY_AMT') == '' 
						&& grdRecord.get('EX_DATE') == ''
						&& grdRecord.get('PAY_YYYYMM_CHECK') == ''){
							
							/*if(grdRecord.get('RECEIPT_DAY') == '3'){
								grdRecord.set('PAY_AMT',grdRecord.get('IN_CR_AMT_I'));
							}else if(grdRecord.get('RECEIPT_DAY') == '1' && grdRecord.get('AGENT_TYPE') != '3'){
								grdRecord.set('PAY_AMT',grdRecord.get('SPACE_STOCK_I'));
							}else{*/
								if(grdRecord.get('SC_STOCK_I') == 0){
									alert("확정금액에 0을 입력할 수 없습니다.");
									grdRecord.set('SELECT',false);
								}else{
									
									grdRecord.set('CHECK', '1'); //확정
									grdRecord.set('CHECK_NAME', '<t:message code="system.label.purchase.confirmation" default="확정"/>');
									grdRecord.set('PAY_AMT', grdRecord.get('SC_STOCK_I'));
									
									if(grdRecord.get('RECEIPT_DAY_REF') == 'Y' && grdRecord.get('AGENT_TYPE_REF') == '3'){
										grdRecord.set('BILL_DATE', masterForm.getValue('BILL_DATE'));
									}
									checkCount++;
								}
//							}
						}else if(grdRecord.get('PAY_AMT') != '' 
						&& grdRecord.get('EX_DATE') == ''
						&& grdRecord.get('PAY_YYYYMM_CHECK') != ''){
							
							grdRecord.set('CHECK', '2'); //취소
							grdRecord.set('CHECK_NAME', '취소');
							checkCount++;
						}else if(grdRecord.get('EX_DATE') != ''){
							alert("지불자동기표가 완료된 자료는 수정/삭제가 불가능합니다.");
							grdRecord.set('SELECT',false);
						}
		    		}else{
		    			if(grdRecord.get('CHECK') == '1' ){
							grdRecord.set('CHECK','');
							grdRecord.set('CHECK_NAME',grdRecord.get('CHECK_NAME_DUMMY'));
							grdRecord.set('PAY_AMT', '');
							grdRecord.set('BILL_DATE', '');
						}else if(grdRecord.get('CHECK') == '2' ){
							grdRecord.set('CHECK','');
							grdRecord.set('CHECK_NAME',grdRecord.get('CHECK_NAME_DUMMY'));
						}else if(grdRecord.get('CHECK') == '3' ){
							grdRecord.set('CHECK','');
							grdRecord.set('CHECK_NAME',grdRecord.get('CHECK_NAME_DUMMY'));
							grdRecord.set('PAY_AMT',grdRecord.get('COMPARE_PAY'));
						}
						
						
//		    			var records = masterGrid.getSelectedRecords();
//						if(records.length < 1){
//							UniAppManager.setToolbarButtons('save',false);
//						}
						checkCount--;
		    		}
		    		if(checkCount > 0){
		    			UniAppManager.setToolbarButtons('save',true);
		    		}else if(checkCount < 1){
		    			UniAppManager.setToolbarButtons('save',false);
		    		}
		    	}
/*		    	
			select: function(grid, record, index, eOpts ){					
				
				var records = masterGrid.getSelectedRecords();
					if(records.length > '0'){
						UniAppManager.setToolbarButtons('save',true);
					}
					
				if(record.get('PAY_AMT') == '' 
				&& record.get('EX_DATE') == ''
				&& record.get('PAY_YYYYMM_CHECK') == ''){
					
					record.set('CHECK', '1'); //확정
					record.set('CHECK_NAME', '<t:message code="system.label.purchase.confirmation" default="확정"/>');
					record.set('PAY_AMT', record.get('SC_STOCK_I'));
				   
				}else if(record.get('PAY_AMT') != '' 
				&& record.get('EX_DATE') == ''
				&& record.get('PAY_YYYYMM_CHECK') != ''){
					
					record.set('CHECK', '2'); //취소
					record.set('CHECK_NAME', '취소');
					
				}else if(record.get('EX_DATE') != ''){
					alert("기표된자료");
				}
	          	},
				deselect:  function(grid, record, index, eOpts ){
					
					if(record.get('CHECK') == '1' ){
						record.set('CHECK','');
						record.set('CHECK_NAME','');
						record.set('PAY_AMT', '');
					}else if(record.get('CHECK') == '2' ){
						record.set('CHECK','');
						record.set('CHECK_NAME','');
					}
					
					else if(record.get('CHECK') == '3'){	금액필드 수정후 체크박스 deselect시 관련	보류
						record.set('CHECK','');
						record.set('CHECK_NAME','');
						//record.set('PAY_AMT',); 확정금액에 예전금액으로 돌림 필요	
					}
        		}*/
        	}
		    },
		    {dataIndex: 'CHECK_NAME'			, width: 70, locked: true,align:'center'},
		    {dataIndex: 'CUSTOM_CODE'			, width: 70, locked: true},
		    {dataIndex: 'CUSTOM_NAME'			, width: 150, locked: true,
		    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            	}
		    },
		    {dataIndex: 'COLLECT_DAY'			, width: 66,align:'center'},
		    {dataIndex: 'COLLECT_DAY_MAP050_G'	, width: 66,align:'center',hidden:true},
		    {dataIndex: 'RECEIPT_DAY'			, width: 66,align:'center'},
		    {dataIndex: 'BILL_TYPE'				, width: 66,align:'center'},
		    {dataIndex: 'IWAL_IN_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'IN_CR_AMT_I'			, width: 120,tdCls:'x-change-cell1',summaryType: 'sum'},
		    {dataIndex: 'SALE_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'SALE_COST'				, width: 120,summaryType: 'sum', hidden:true},
		    {dataIndex: 'IN_DR_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'IN_JAN_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'END_STOCK_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'SPACE_STOCK_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'SC_STOCK_I'			, width: 120,tdCls:'x-change-cell2',summaryType: 'sum'},
		    {dataIndex: 'PAY_AMT'				, width: 120,tdCls:'x-change-cell3',summaryType: 'sum'},
		    {dataIndex: 'BILL_DATE'				, width: 90/*,
		    renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
	        			if(record.get('BILL_DATE') == null){
	                        return '';
	        			}else{
	        				return UniDate.getDbDateStr(val).substring(0, 6);
	        			}
	                }*/
		    },
		    {dataIndex: 'BILL_DATE_DUMMY'		, width: 90,hidden:true},
		    {dataIndex: 'TAX_AMT'				, width: 80},
		    {dataIndex: 'TOP_NAME'				, width: 90,align:'center'},
		    {dataIndex: 'ADDR1'					, width: 120},
		    {dataIndex: 'TELEPHON'				, width: 120},
		    {dataIndex: 'TOT_CREDIT_AMT'		, width: 90,summaryType: 'sum'},
		    {dataIndex: 'AGENT_TYPE'			, width: 90,hidden:true},
		    {dataIndex: 'EX_DATE'				, width: 90,hidden:true},
		    {dataIndex: 'PAY_YYYYMM_CHECK'		, width: 90,hidden:true},
		    {dataIndex: 'COMPANY_NUM'			, width: 90},
		    {dataIndex: 'BANK_CODE'				, width: 90},
		    {dataIndex: 'BANK_NAME'				, width: 90},
		    {dataIndex: 'BANKBOOK_NUM'			, width: 90},
		    {dataIndex: 'BANKBOOK_NAME'			, width: 90},
		    {dataIndex: 'RECEIPT_DAY_REF'		, width: 90,hidden:true},
		    {dataIndex: 'AGENT_TYPE_REF'		, width: 90,hidden:true}
		    
		    
		],
		listeners: {
        	
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.CUSTOM_CODE == null){
					return false;
				}else {
				if(UniUtils.indexOf(e.field, ['PAY_AMT','BILL_DATE','TAX_AMT'])){
						return true;
					}else{
						return false;
					}
				}
			}
		}
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
		id: 'map080ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('FR_DATE',UniDate.get('startOfMonth'));
			masterForm.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			masterForm.setValue('PAY_DATE',UniDate.get('today'));
//			masterForm.setValue('PAY_DATE',UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6) + masterForm.getValue('COLLECT_DAY_MAP050'));
//			panelResult.setValue('PAY_DATE',UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6) + panelResult.getValue('COLLECT_DAY_MAP050'));
			
			
			masterForm.setValue('BILL_DATE',UniDate.get('today'));
			panelResult.setValue('BILL_DATE',UniDate.get('today'));
			
			
			
			masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			masterForm.setValue('PAY_YYYYMM',UniDate.get('today'));
			panelResult.setValue('PAY_YYYYMM',UniDate.get('today'));
			
		
			this.setDefault();
//			
//			masterForm.setValue('S_PAY_YYYYMM', UniDate.getDbDateStr(masterForm.getValue('PAY_DATE')).substring(0, 6));
//			masterForm.setValue('S_COLLECT_DAY', UniDate.getDbDateStr(masterForm.getValue('PAY_DATE')).substring(6, 8));

			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
			return panelResult.setAllFieldsReadOnly(true);
			/*
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
		setDefault: function() {
				var param = {"DIV_CODE": masterForm.getValue('DIV_CODE'),
			 			"PAY_YYYYMM": UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6)
				};
			map080ukrvService.getCollectDay(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('COLLECT_DAY_MAX',provider['COLLECT_DAY']);
				}
			});
			
			
			},
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore1.clearData();
			UniAppManager.setToolbarButtons(['print'], false);
			
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			var colDay = masterForm.getValue('COLLECT_DAY_MAP050');
			if(!Ext.isEmpty(colDay)){
				masterForm.setValue('COLLECT_DAY_MAX', colDay);
			}
			directMasterStore1.saveStore();
		},
		checkForNewDetail:function() { 			
			return masterForm.setAllFieldsReadOnly(true);
        },
        
        onPrintButtonDown: function() {
	         //var records = masterForm.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
		         var win = Ext.create('widget.PDFPrintWindow', {
		            url: CPATH+'/map/map080rkrPrint.do',
		            prgID: 'map080rkr',
		               extParam: {
		               	  
		                  DIV_CODE  	: param.DIV_CODE,
		                  DEPT_CODE		: param.DEPT_CODE,
		                  FR_DATE		: param.FR_DATE,
		                  TO_DATE		: param.TO_DATE,
	//	                  PAY_DATE		: param.PAY_DATE,
		                  PAY_YYYYMM	: param.PAY_YYYYMM,
		                  COLLECT_DAY   : param.COLLECT_DAY,
		                  CUSTOM_CODE	: param.CUSTOM_CODE,
		                  CUSTOM_NAME	: param.CUSTOM_NAME,
		                  AGENT_TYPE    : param.AGENT_TYPE,
		                  RECEIPT_DAY   : param.RECEIPT_DAY,
		                  FLOOR			: param.FLOOR,
	//	                  S_PAY_YYYYMM  : param.S_PAY_YYYYMM,
	//	                  S_COLLECT_DAY : param.S_COLLECT_DAY 
		                  CHECKING		: param.CHECKING,
		                  COLLECT_DAY_MAP050 : param.COLLECT_DAY_MAP050,
		                  OUTPUT		: param.OUTPUT
		                  
		               }
		            });
	            win.center();
	            win.show();
	    },
        onSaveAsExcelButtonDown: function() {
        	var masterGrid = Ext.getCmp('map080ukrvGrid1');
			 masterGrid.downloadExcelXml();
		}
	});
/*	Unilite.createValidator('validator01', {
		forms: {'formA:':masterForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {				
				case "PAY_YYYYMM" :
				
				if(masterForm.getValue('COLLECT_DAY') != null){
					if(newValue != null){
						if(masterForm.getValue('COLLECT_DAY').length == 2 ){
							masterForm.setValue('PAY_DATE', UniDate.getDbDateStr(newValue).substring(0, 6) + masterForm.getValue('COLLECT_DAY'));
						}else if(masterForm.getValue('COLLECT_DAY').length == 1){
							masterForm.setValue('PAY_DATE', UniDate.getDbDateStr(newValue).substring(0, 6) + '0' + masterForm.getValue('COLLECT_DAY'));
						}
					}
				}
				break;
			}
			return rv;
		}
	});		*/
/*	Unilite.createValidator('validator02', {
		forms: {'formB:':panelResult},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {				
				case "PAY_YYYYMM" :
				
				if(panelResult.getValue('COLLECT_DAY') != null){
					if(newValue != null){
					
						if(panelResult.getValue('COLLECT_DAY').length == 2 ){
							masterForm.setValue('PAY_DATE', UniDate.getDbDateStr(newValue).substring(0, 6) + panelResult.getValue('COLLECT_DAY'));
						}else if(panelResult.getValue('COLLECT_DAY').length == 1){
							masterForm.setValue('PAY_DATE', UniDate.getDbDateStr(newValue).substring(0, 6) + '0' + panelResult.getValue('COLLECT_DAY'));
						}
					}
				}
				break;
				
			}
			return rv;
		}
	});*/
	Unilite.createValidator('validator03', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				/*case "SELECT" :
					if(newValue != ''){
						UniAppManager.setToolbarButtons('save',true);	
						break;
					}else if(newValue == null){
						UniAppManager.setToolbarButtons('save',false);
						break;
					}
					break;*/
				case "PAY_AMT" :
				if(newValue == 0 || Ext.isEmpty(newValue)){   
					rv='<t:message code = "확정금액에 0을 입력할 수 없습니다."/>';
					break;
				}else if(record.get('EX_DATE') != ''){
					rv='<t:message code = "지불자동기표가 완료된 자료는 수정/삭제가 불가능합니다."/>';	
					break;
				}
					if(record.get('EX_DATE') == '' 
					&& oldValue != ''
					&& record.get('PAY_YYYYMM_CHECK') != ''
					&& newValue != 0){
						/*var currRec = this.grid.uniOpt.currentRecord;
					var compareValue = Ext.isDefined(currRec.previousValues) && Ext.isDefined(currRec.previousValues['PAY_AMT']) ? currRec.previousValues['PAY_AMT'] : oldValue;
						if(newValue != compareValue){*/
						if(newValue != record.get('COMPARE_PAY')){
//							var sm = this.grid.getSelectionModel();
//							var selRecords = this.grid.getSelectionModel().getSelection();
//							selRecords.push(this.grid.uniOpt.currentRecord)
//							sm.select(selRecords);
							
							record.set('SELECT',true);
							
							record.set('CHECK','3');
							record.set('CHECK_NAME','금액수정');
							
							checkCount++;
							if(checkCount > 0){
				    			UniAppManager.setToolbarButtons('save',true);
				    		}else if(checkCount < 1){
				    			UniAppManager.setToolbarButtons('save',false);
				    		}
							break;
						}else if(newValue == record.get('COMPARE_PAY')){
//							var sm = this.grid.getSelectionModel();
//							var selRecords = this.grid.getSelectionModel().getSelection();
//							selRecords.push(this.grid.uniOpt.currentRecord)
//							sm.deselect(this.grid.uniOpt.currentRecord,true);
							record.set('SELECT',false);
							
							record.set('CHECK','');
							record.set('CHECK_NAME',record.get('CHECK_NAME_DUMMY'));
							
							checkCount--;
//							record.set('PAY_AMT',oldValue);
							if(checkCount > 0){
				    			UniAppManager.setToolbarButtons('save',true);
				    		}else if(checkCount < 1){
				    			UniAppManager.setToolbarButtons('save',false);
				    		}
							break;
						}
						break;
						
					}else if(record.get('EX_DATE') == '' 
//					&& oldValue == ''
					&& record.get('PAY_YYYYMM_CHECK') == ''
//					&& newValue != 0
					){
						if(newValue != 0){
//							var sm = this.grid.getSelectionModel();
//							var selRecords = this.grid.getSelectionModel().getSelection();
//							selRecords.push(this.grid.uniOpt.currentRecord)
//							sm.select(selRecords);
							record.set('SELECT',true);
							
							record.set('CHECK','1');
							record.set('CHECK_NAME','<t:message code="system.label.purchase.confirmation" default="확정"/>');
							
							checkCount++;
							if(checkCount > 0){
				    			UniAppManager.setToolbarButtons('save',true);
				    		}else if(checkCount < 1){
				    			UniAppManager.setToolbarButtons('save',false);
				    		}
							break;
						}else if(newValue == 0 || Ext.isEmpty(newValue)){
//							var sm = this.grid.getSelectionModel();
//							var selRecords = this.grid.getSelectionModel().getSelection();
//							selRecords.push(this.grid.uniOpt.currentRecord)
//							sm.deselect(this.grid.uniOpt.currentRecord, true);
							record.set('SELECT',false);
							
							record.set('CHECK','');
							record.set('CHECK_NAME',record.get('CHECK_NAME_DUMMY'));
							
							checkCount--;
//							record.set('PAY_AMT',oldValue);
							
							if(checkCount > 0){
				    			UniAppManager.setToolbarButtons('save',true);
				    		}else if(checkCount < 1){
				    			UniAppManager.setToolbarButtons('save',false);
				    		}
							break;
						}
						
						break;
						
					}
					
			case "BILL_DATE" :
			
				if(record.get('EX_DATE') != ''){
					rv='<t:message code = "지불자동기표가 완료된 자료는 수정/삭제가 불가능합니다."/>';	
					break;
				}
				
					if(record.get('EX_DATE') == '' 
					&& record.get('PAY_AMT') != ''
					&& record.get('PAY_YYYYMM_CHECK') != ''
					&& newValue != ''){
						record.set('SELECT',true);
						record.set('CHECK','3');
						record.set('CHECK_NAME','계산서일자수정');
						
						checkCount++;
							if(checkCount > 0){
				    			UniAppManager.setToolbarButtons('save',true);
				    		}else if(checkCount < 1){
				    			UniAppManager.setToolbarButtons('save',false);
				    		}
					break;
					}else if(record.get('EX_DATE') == '' 
					&& record.get('PAY_AMT') != ''
					&& record.get('PAY_YYYYMM_CHECK') != ''
					&& newValue == ''){
						record.set('SELECT',false);	
						record.set('CHECK','');
						record.set('CHECK_NAME',record.get('CHECK_NAME_DUMMY'));
						record.set('BILL_DATE',record.get('BILL_DATE_DUMMY'));
						
						checkCount--;
							if(checkCount > 0){
				    			UniAppManager.setToolbarButtons('save',true);
				    		}else if(checkCount < 1){
				    			UniAppManager.setToolbarButtons('save',false);
				    		}
				    break;
					}
					
			}
				return rv;
			}
	});	
};


</script>
