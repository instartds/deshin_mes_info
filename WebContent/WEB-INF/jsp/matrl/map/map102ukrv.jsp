<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map102ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map102ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B038" /> <!-- 결제조건 --> 
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->	
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002" /> <!-- 품질대상여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" opts= '${gsList1}' /> <!-- 계산서유형 -->
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;	//조회버튼 누르면 나오는 조회창
var referInoutWindow;	//입고내역참조

var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}',
	gsOrderPrsnYN: '${gsOrderPrsnYN}',
	gsList1: '${gsList1}',
	gsCreditCard : '${gsCreditCard}',
	gsCashReceipt : '${gsCashReceipt}',
	AccountType : ${AccountType},
	BillType: ${BillType}
};

var CustomCodeInfo = {
	gsUnderCalBase: ''
};

/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/


var outDivCode = UserInfo.divCode;
var aa = 0;


function appMain() {   
	
var allowBlankCheck = false;
/*var allowBlankCheck1 = false;	
//	if(masterForm.getValue('BILL_TYPE') == '53')	{
//		allowBlankCheck1 = true;
//	}
var allowBlankCheck2 = false;	
	if(BsaCodeInfo.BillType == 'E')	{
		allowBlankCheck2 = true;
	}*/
	
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'map102ukrvService.purchaseRequest',
			update: 'map102ukrvService.updateDetail',
			create: 'map102ukrvService.insertDetail',
			destroy: 'map102ukrvService.deleteDetail',
			syncAll: 'map102ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Map102ukrvModel', {
	    fields: [  	 	
	    	{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			,type: 'string'},
	    	{name: 'SEQ'				,text: '<t:message code="system.label.purchase.seq" default="순번"/>'				,type: 'int'},
	    	{name: 'INOUT_DATE'			,text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'			,type: 'uniDate'},
	    	{name: 'INOUT_NUM'			,text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'			,type: 'string'},
	    	{name: 'INOUT_TYPE'			,text: '수불구분'			,type: 'string'},
	    	{name: 'TOTAL_INOUT_Q'		,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'			,type: 'uniQty'},
	    	{name: 'TOTAL_AMOUNT_I'		,text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'			,type: 'uniPrice'},
	    	{name: 'TOTAL_VAT_AMOUNT_O'	,text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'			,type: 'uniPrice'},
	    	{name: 'TOTAL_INOUT_I'		,text: '총입고금액'			,type: 'uniPrice'}
			
		]  
	});		//End of Unilite.defineModel('Map102ukrvModel', {
	
	Unilite.defineModel('buyslipNoMasterModel', {		//조회버튼 누르면 나오는 조회창
	    fields: [
	    	{name: 'CUSTOM_NAME'			   , text: '<t:message code="system.label.purchase.custom" default="거래처"/>'    	, type: 'string'},
	    	{name: 'CHANGE_BASIS_DATE'  	   , text: '<t:message code="system.label.purchase.exdate" default="결의일"/>'    	, type: 'uniDate'},
	    	{name: 'MONEY_UNIT'		    	   , text: '<t:message code="system.label.purchase.currency" default="화폐"/>'    		, type: 'string'},
	    	{name: 'AMOUNT_I'		    	   , text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'    	, type: 'uniPrice'},
	    	{name: 'BILL_NUM'		    	   , text: '<t:message code="system.label.purchase.billno" default="계산서번호"/>'    , type: 'string'},
	    	{name: 'BILL_DATE'		    	   , text: '<t:message code="system.label.purchase.billdate" default="계산서일"/>'    , type: 'uniDate'},
	    	{name: 'CHANGE_BASIS_NUM'   	   , text: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>'    	, type: 'string'},
	    	{name: 'DIV_CODE'	        	   , text: '<t:message code="system.label.purchase.division" default="사업장"/>'   	, type: 'string',comboType:'BOR120'},
	    	{name: 'BILL_DIV_CODE'	    	   , text: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>'    , type: 'string',comboType:'BOR120'},
	    	{name: 'CUSTOM_CODE'			   , text: '<t:message code="system.label.purchase.custom" default="거래처"/>'    	, type: 'string'},
	    	{name: 'COMPANY_NUM'			   , text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>'    , type: 'string'},
	    	{name: 'BILL_TYPE'		    	   , text: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>'    , type: 'string'},
	    	{name: 'RECEIPT_TYPE'	    	   , text: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>'    	, type: 'string'},
	    	{name: 'ORDER_TYPE'		    	   , text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'    	, type: 'string'},
	    	{name: 'VAT_RATE'		    	   , text: '<t:message code="system.label.purchase.vatrate" default="부가세율"/>'    	, type: 'string'},
	    	{name: 'VAT_AMOUNT_O'	    	   , text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'    	, type: 'uniPrice'},
	    	{name: 'DEPT_CODE'		    	   , text: '<t:message code="system.label.purchase.department" default="부서"/>'    		, type: 'string'},
	    	{name: 'EX_DATE'				   , text: '<t:message code="system.label.purchase.purchasepostdate" default="매입기표일"/>'   , type: 'uniDate'},
	    	{name: 'EX_NUM'			    	   , text: '<t:message code="system.label.purchase.slipno" default="전표번호"/>'    	, type: 'int'},
	    	{name: 'AGREE_YN'		    	   , text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'    	, type: 'string'},
	    	{name: 'DRAFT_YN'		    	   , text: '<t:message code="system.label.purchase.drafting" default="기안여부"/>'    	, type: 'string'},
	    	{name: 'DEPT_NAME'		    	   , text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'    	, type: 'string'},
	    	{name: 'ISSUE_EXPECTED_DATE'	   , text: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>'    , type: 'uniDate'},
	    	{name: 'ACCOUNT_TYPE'	    	   , text: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>'    	, type: 'string'},
	    	{name: 'PROJECT_NO'		    	   , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'    	, type: 'string'}
		]
	});
	Unilite.defineModel('map102ukrvINOUTModel', {	//입고내역참조 
	    fields: [
	    	{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	,type: 'string'},
	    	{name: 'INOUT_DATE'			,text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'	,type: 'uniDate'},
	    	{name: 'INOUT_NUM'			,text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'	,type: 'string'},
	    	{name: 'INOUT_TYPE'			,text: '수불구분'	,type: 'string'},
	    	{name: 'TOTAL_INOUT_Q'		,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'	,type: 'uniQty'},
	    	{name: 'TOTAL_AMOUNT_I'		,text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'	,type: 'uniPrice'},
	    	{name: 'TOTAL_VAT_AMOUNT_O'	,text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'	,type: 'uniPrice'},
	    	{name: 'TOTAL_INOUT_I'		,text: '입고금액'	,type: 'uniPrice'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('map102ukrvMasterStore1',{
		model: 'Map102ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: true,			// 삭제 가능 여부 
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
			
		proxy: directProxy,
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();	
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(masterForm.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			
			var paramMaster= masterForm.getValues();
			
				var inValidRecs = this.getInvalidRecords();
            	
            	var rv = true;
            	
				if(inValidRecs.length == 0 )	{
					config = {
							params: [paramMaster]
					};
				this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});		// End of var directMasterStore1 = Unilite.createStore('map102ukrvMasterStore1',{
	var buyslipNoMasterStore = Unilite.createStore('buyslipNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model: 'buyslipNoMasterModel',
        autoLoad: false,
        uniOpt: {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable: false,			// 삭제 가능 여부
            useNavi: false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'map100ukrvService.selectOrderNumMasterList'
            }
        },
        loadStoreRecords : function()	{
			var param= buyslipNoSearch.getValues();	
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(buyslipNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var inoutStore = Unilite.createStore('map102ukrvInoutStore', {//입고내역참조
		model: 'map102ukrvINOUTModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: true,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'map102ukrvService.salesHistory'                	
            }
        },
		listeners:{
        	load:function(store, records, successful, eOpts) {
				if(successful)	{
    			   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);  
    			   var salesRecords = new Array();
    			   if(masterRecords.items.length > 0)	{
    			   		console.log("store.items :", store.items);
    			   		console.log("records", records);
        			   	Ext.each(records, 
        			   		function(item, i)	{           			   								
	   							Ext.each(masterRecords.items, function(record, i)	{
	   								console.log("record :", record);
	   							
	   									if( (record.data['ITEM_CODE'] == item.data['ITEM_CODE']) 
	   											&& (record.data['CUSTOM_NAME'] == item.data['CUSTOM_NAME'])
	   									  ) 
	   									{
	   										salesRecords.push(item);
	   									}
	   							});		
        			   		});
        			   store.remove(salesRecords);
    			   }
        		}
        	}
        },
		loadStoreRecords: function()	{
			var param= inoutSearch.getValues();		
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(inoutSearch.getValue('DEPT_CODE'))){
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
				fieldLabel: '매입사업장', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				textFieldWidth: 170, 
				validateBlank: false,
				allowBlank: false,
				holdable: 'hold',
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
						
						if(authoInfo == "A"){	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': masterForm.getValue('BILL_DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),
			Unilite.popup('CUST', {
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName: 'CUSTOM_CODE',
			    	textFieldName: 'CUSTOM_NAME',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					allowBlank: false,
					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
								CustomCodeInfo.gsTaxInclude = records[0]["TAX_TYPE"];
								CustomCodeInfo.gsTaxCalcType = records[0]["TAX_CALC_TYPE"];
								CustomCodeInfo.gsBillType = records[0]["BILL_TYPE"];
								
			/*				alert(CustomCodeInfo.gsUnderCalBase);
							alert(CustomCodeInfo.gsTaxInclude);
							alert(CustomCodeInfo.gsTaxCalcType);
							alert(CustomCodeInfo.gsBillType);*/
							
								masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
								masterForm.setValue('BILL_TYPE', Unilite.nvl(records[0]["BILL_TYPE"],'51'));
								
								panelResult.setValue('BILL_TYPE', Unilite.nvl(records[0]["BILL_TYPE"],'51'));
								panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							CustomCodeInfo.gsUnderCalBase = '';
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					}
				}),
			{ 
				fieldLabel: '확정일(결의일)',
				name: 'CHANGE_BASIS_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CHANGE_BASIS_DATE', newValue);
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.purchase.billno" default="계산서번호"/>',
				name: 'BILL_NUM',
				xtype: 'uniTextfield',
//				readOnly: isAutoInoutNum2,
			//	holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_NUM', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				name:'BILL_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('endOfLastMonth'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DATE', newValue);
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>',
				name: 'CHANGE_BASIS_NUM',
				xtype: 'uniTextfield'
//				readOnly: isAutoInoutNum1
		//		holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>', 
				name: 'MONEY_UNIT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B004',
				allowBlank: false,
				displayField: 'value',
				fieldStyle: 'text-align: center;',
				holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>', 
				name: 'ACCOUNT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M302',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						UniAppManager.app.fnGetAccountType(newValue);
						panelResult.setValue('ACCOUNT_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>', 
				name: 'BILL_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'A022',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						panelResult.setValue('BILL_TYPE', newValue);
						UniAppManager.app.fnGetBillType(newValue);
						panelResult.setValue('CRDT_NUM', '');
						panelResult.setValue('CRDT_NAME', '');
						masterForm.setValue('CRDT_NUM', '');
						masterForm.setValue('CRDT_NAME', '');
					}
				}
			},Unilite.popup('CREDIT_CARD2', {
					fieldLabel: '법인카드',
					id:'CUSTOM_CODE_SE1',
					valueFieldName: 'CRDT_NUM',
			    	textFieldName: 'CRDT_NAME',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CRDT_NUM', masterForm.getValue('CRDT_NUM'));
								panelResult.setValue('CRDT_NAME', masterForm.getValue('CRDT_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CRDT_NUM', '');
							panelResult.setValue('CRDT_NAME', '');
						}
					}
			}),Unilite.popup('CREDIT_CARD2', {
					fieldLabel: '법인카드',
					id:'CUSTOM_CODE_SE',
					valueFieldName: 'CRDT_NUM',
			    	textFieldName: 'CRDT_NAME',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					allowBlank: false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CRDT_NUM', masterForm.getValue('CRDT_NUM'));
								panelResult.setValue('CRDT_NAME', masterForm.getValue('CRDT_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CRDT_NUM', '');
							panelResult.setValue('CRDT_NAME', '');
						}
					}
			}),{
				fieldLabel: '현금영수증번호',
				name: 'CREDIT_NUM',
				xtype: 'uniTextfield',
				id:'CREDIT_NUM_SE',
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasepostdate" default="매입기표일"/>',
				name: 'EX_DATE',
				xtype: 'uniDatefield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>',
				name: 'ISSUE_EXPECTED_DATE',
	            xtype: 'uniDatefield',
	            width: 200,
	            holdable: 'hold'
	        },{
				fieldLabel: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>', 
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>',
				name: 'COMPANY_NUM',
				xtype: 'uniTextfield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.slipno" default="전표번호"/>',
				name: 'EX_NUM',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>', 
				name: 'ORDER_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M001',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '결제방법', 
				name: 'RECEIPT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B038',
				holdable: 'hold'
			},{
				fieldLabel: '총매입금액[(1)+(2)]',
				name: 'AMOUNTTOT',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.vatrate" default="부가세율"/>',
				name: 'VAT_RATE',
				xtype: 'uniNumberfield',
				holdable: 'hold'
			},{
				fieldLabel: '총부가세액(1)',
				name: 'VATAMOUNTO',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: '총공급가액(2)',
				name: 'AMOUNTI',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: 'DRAFT_YN',
				name: 'DRAFT_YN',
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
    });		// End of var masterForm = Unilite.createSearchForm('searchForm',{    
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '매입사업장', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				textFieldWidth: 170, 
				validateBlank: false,
				allowBlank: false,
				holdable: 'hold',
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
						
						if(authoInfo == "A"){	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('BILL_DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),
			Unilite.popup('CUST', {
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName: 'CUSTOM_CODE',
			    	textFieldName: 'CUSTOM_NAME',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					allowBlank: false,
					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
								CustomCodeInfo.gsTaxInclude = records[0]["TAX_TYPE"];
								CustomCodeInfo.gsTaxCalcType = records[0]["TAX_CALC_TYPE"];
								CustomCodeInfo.gsBillType = records[0]["BILL_TYPE"];
								
			/*				alert(CustomCodeInfo.gsUnderCalBase);
							alert(CustomCodeInfo.gsTaxInclude);
							alert(CustomCodeInfo.gsTaxCalcType);
							alert(CustomCodeInfo.gsBillType);*/
							
								panelResult.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
								panelResult.setValue('BILL_TYPE', Unilite.nvl(records[0]["BILL_TYPE"],'51'));
								
								masterForm.setValue('BILL_TYPE', Unilite.nvl(records[0]["BILL_TYPE"],'51'));
								masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							CustomCodeInfo.gsUnderCalBase = '';
							masterForm.setValue('CUSTOM_CODE', '');
							masterForm.setValue('CUSTOM_NAME', '');
						}
					}
				}),
			{ 
				fieldLabel: '확정일(결의일)',
				name: 'CHANGE_BASIS_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('CHANGE_BASIS_DATE', newValue);
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.purchase.billno" default="계산서번호"/>',
				name: 'BILL_NUM',
				xtype: 'uniTextfield',
//				readOnly: isAutoInoutNum2,
			//	holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BILL_NUM', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				name:'BILL_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('endOfLastMonth'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BILL_DATE', newValue);
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>',
				name: 'CHANGE_BASIS_NUM',
				xtype: 'uniTextfield'
//				readOnly: isAutoInoutNum1
		//		holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>', 
				name: 'MONEY_UNIT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B004',
				allowBlank: false,
				displayField: 'value',
				fieldStyle: 'text-align: center;',
				holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>', 
				name: 'ACCOUNT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M302',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.fnGetAccountType(newValue);
						masterForm.setValue('ACCOUNT_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>', 
				name: 'BILL_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'A022',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BILL_TYPE', newValue);
						UniAppManager.app.fnGetBillType(newValue);
						panelResult.setValue('CRDT_NUM', '');
						panelResult.setValue('CRDT_NAME', '');
						masterForm.setValue('CRDT_NUM', '');
						masterForm.setValue('CRDT_NAME', '');
////
					}
				}
			},Unilite.popup('CREDIT_CARD2', {
					fieldLabel: '법인카드',
					id:'CUSTOM_CODE_RE1',
					valueFieldName: 'CRDT_NUM',
			    	textFieldName: 'CRDT_NAME',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					colspan:2,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('CRDT_NUM', panelResult.getValue('CRDT_NUM'));
								masterForm.setValue('CRDT_NAME', panelResult.getValue('CRDT_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							masterForm.setValue('CRDT_NUM', '');
							masterForm.setValue('CRDT_NUM', '');
						}
					}
			}),Unilite.popup('CREDIT_CARD2', {
					fieldLabel: '법인카드',
					id:'CUSTOM_CODE_RE',
					valueFieldName: 'CRDT_NUM',
			    	textFieldName: 'CRDT_NAME',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					allowBlank: false,
					colspan:2,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('CRDT_NUM', panelResult.getValue('CRDT_NUM'));
								masterForm.setValue('CRDT_NAME', panelResult.getValue('CRDT_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							masterForm.setValue('CRDT_NUM', '');
							masterForm.setValue('CRDT_NUM', '');
						}
					}
			}),{
				fieldLabel: '현금영수증번호',
				allowBlank: false,
				name: 'CREDIT_NUM',
				xtype: 'uniTextfield',
				id:'CREDIT_NUM_RE',
				colspan:2
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasepostdate" default="매입기표일"/>',
				name: 'EX_DATE',
				xtype: 'uniDatefield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>',
				name: 'ISSUE_EXPECTED_DATE',
	            xtype: 'uniDatefield',
	            width: 200,
	            holdable: 'hold'
	        },{
				fieldLabel: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>', 
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>',
				name: 'COMPANY_NUM',
				xtype: 'uniTextfield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.slipno" default="전표번호"/>',
				name: 'EX_NUM',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>', 
				name: 'ORDER_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M001',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '결제방법', 
				name: 'RECEIPT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B038',
				holdable: 'hold'
			},{
				fieldLabel: '총매입금액[(1)+(2)]',
				name: 'AMOUNTTOT',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.vatrate" default="부가세율"/>',
				name: 'VAT_RATE',
				xtype: 'uniNumberfield',
				holdable: 'hold'
			},{
				fieldLabel: '총부가세액(1)',
				name: 'VATAMOUNTO',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: '총공급가액(2)',
				name: 'AMOUNTI',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: 'DRAFT_YN',
				name: 'DRAFT_YN',
				xtype: 'uniTextfield',
				hidden: true
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
	var buyslipNoSearch = Unilite.createSearchForm('buyslipNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns: 2},
	    trackResetOnLoad: true,
	    items: [
			{
				fieldLabel: '매입사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				colspan: 2
			},
				Unilite.popup('CUST',{ 
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					textFieldWidth: 170, 
					validateBlank: false
				}),
				Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
					textFieldWidth: 170, 
					validateBlank: false,
					listeners: {
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
				}),
			{
				fieldLabel: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'CHANGE_BASIS_DATE_FR',
				endFieldName: 'CHANGE_BASIS_DATE_TO',
				width: 315
			},{
				fieldLabel: '<t:message code="system.label.purchase.billno" default="계산서번호"/>',
				name: 'BILL_NUM',
				xtype: 'uniNumberfield'
			},{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'BILL_DATE_FR',
				endFieldName: 'BILL_DATE_TO',
				width: 315
			},
				Unilite.popup('', { 
					fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>', 
					textFieldWidth: 170, 
					validateBlank: false
				})
		]
    }); // createSearchForm
    var inoutSearch = Unilite.createSearchForm('salesForm', {//입고내역참조
		layout: {type : 'uniTable', columns : 3},
		items :[
			{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank: false
			},
			Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
					textFieldWidth: 170, 
					validateBlank: false,
					allowBlank: false,
					listeners: {
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
				}),
			{
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank: false
			},{
				fieldLabel: '입고기간',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALES_DATE_FR',
				endFieldName: 'SALES_DATE_TO',
				startDate: UniDate.get('today')-1,
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('MPO060ukrvLevel1Store'), 
				child: 'ITEM_LEVEL2'
			},{
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('MPO060ukrvLevel2Store'), 
				child: 'ITEM_LEVEL3'
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
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid= Unilite.createGrid('map102ukrvGrid', {
    	region: 'center' ,
        layout: 'fit',
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
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'salesBtn',
					text: '입고내역참조',
					handler: function() {
						if(masterForm.setAllFieldsReadOnly(true) == false){
								return false;
							}
						openInoutWindow();
					}
				}/*, {
					itemId: 'excelBtn',
					text: '엑셀참조',
		        	handler: function() {
			        		openExcelWindow();
			        }
				}*/]
			})
		},{
			xtype: 'splitbutton',
           	itemId:'procTool',
			text: '프로세스...',  iconCls: 'icon-link',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'refLinkBtn',
					text: '<t:message code="system.label.purchase.purchaserordercontrol" default="구매오더조정/확정"/>',
					handler: function() {
						var params = {
							//'ORDER_NUM' : masterForm.getValue('ORDER_NUM')
						}
						var rec = {data : {prgID : 'mpo201ukrv', 'text':'<t:message code="system.label.purchase.purchaserordercontrol" default="구매오더조정/확정"/>'}};							
						parent.openTab(rec, '/matrl/mpo201ukrv.do', params);	
						
					}
				}]
			})
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
        columns: [
        	{dataIndex:'COMP_CODE'			, width: 88 ,hidden: true},
        	{dataIndex:'SEQ'							, width: 88 },
        	{dataIndex:'INOUT_DATE'						, width: 88 },
        	{dataIndex:'INOUT_NUM'						, width: 88 },
        	{dataIndex:'INOUT_TYPE'						, width: 88 },
        	{dataIndex:'TOTAL_INOUT_Q'					, width: 88 },
        	{dataIndex:'TOTAL_AMOUNT_I'					, width: 88 },
        	{dataIndex:'TOTAL_VAT_AMOUNT_O'				, width: 88 },
        	{dataIndex:'TOTAL_INOUT_I'					, width: 88 }
        ],
        listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(e.record.phantom == false){
					if(UniUtils.indexOf(e.field, ['CUSTOM_CODE','CUSTOM_NAME','ORDER_REQ_Q','REMARK'])){
						return true;
					}else{
						return false;
					}
				}else{
					
					if(UniUtils.indexOf(e.field, ['CUSTOM_CODE','CUSTOM_NAME','ITEM_CODE','ITEM_NAME','ORDER_REQ_Q','REMARK'])){
						return true;
					}else{
						return false;
					}
					
				}
			}
		},
		disabledLinkButtons: function(b) {
       		this.down('#procTool').menu.down('#refLinkBtn').setDisabled(b);
		},
		setItemData: function(record, dataClear) {
       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'			, "");
       			grdRecord.set('ITEM_NAME'			, "");
				
		//		grdRecord.set('STOCK_Q'				, "");
		//		grdRecord.set('GOOD_STOCK_Q'		, "");
		//		grdRecord.set('BAD_STOCK_Q'			, "");
       		} else {
       			 
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('ITEM_LEVEL1'	, record['ITEM_LEVEL1']);
       			grdRecord.set('ITEM_LEVEL2'	, record['ITEM_LEVEL2']);
       			
       			var param = {"ITEM_CODE": record['ITEM_CODE']};
					map102ukrvService.fnAuthPubli(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
					grdRecord.set('AUTHOR1', provider['AUTHOR1']);
					grdRecord.set('PUBLISHER', provider['PUBLISHER']);
					}
				});
				
				var param = {"ITEM_CODE": record['ITEM_CODE'],
							"DIV_CODE": record['DIV_CODE']};
					map102ukrvService.fnCustom(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
					grdRecord.set('CUSTOM_CODE', provider['CUSTOM_CODE']);
					grdRecord.set('CUSTOM_NAME', provider['CUSTOM_NAME']);
					}
				});
       			
       			
			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ2, UserInfo.compCode, masterForm.getValue('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );
       		}
		},
		setSalesData:function(record) {
       		var grdRecord = this.getSelectedRecord();
       		//alert(grdRecord);
       		grdRecord.set('COMP_CODE'			, record['COMP_CODE']);
       		grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
       	    grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ORDER_REQ_Q'			, record['ORDER_REQ_Q']);
			grdRecord.set('ITEM_LEVEL1'			, record['ITEM_LEVEL1']);
			grdRecord.set('ITEM_LEVEL2'			, record['ITEM_LEVEL2']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('AUTHOR1'				, record['AUTHOR1']);
			grdRecord.set('PUBLISHER'			, record['PUBLISHER']);
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('WH_CODE'				, record['WH_CODE']);
			grdRecord.set('STOCK_Q'				, record['STOCK_Q']);
			grdRecord.set('ORDER_REQ_Q'			, record['ORDER_REQ_Q']);
			grdRecord.set('REMARK'				, record['REMARK']);
			
			
		}
    });		// End of masterGrid= Unilite.createGrid('map102ukrvGrid', {
     var buyslipNoMasterGrid = Unilite.createGrid('map100ukrvbuyslipNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
        // title: '기본',
        layout: 'fit',       
		store: buyslipNoMasterStore,
		uniOpt: {	
					expandLastColumn: false,
					useRowNumberer: false
		},
        columns:  [ 
			{ dataIndex: 'CUSTOM_NAME'			    	,  width:153},
			{ dataIndex: 'CHANGE_BASIS_DATE'  	    	,  width:93},
			{ dataIndex: 'MONEY_UNIT'		    	    ,  width:53,align:'center', hidden:true},
			{ dataIndex: 'AMOUNT_I'		    	    	,  width:126},
			{ dataIndex: 'BILL_NUM'		    	    	,  width:100},
			{ dataIndex: 'BILL_DATE'		    	    ,  width:93},
			{ dataIndex: 'CHANGE_BASIS_NUM'   	    	,  width:130},
			{ dataIndex: 'DIV_CODE'	        	    	,  width:66, hidden:true},
			{ dataIndex: 'BILL_DIV_CODE'	    	    ,  width:66, hidden:true},
			{ dataIndex: 'CUSTOM_CODE'			    	,  width:53, hidden:true},
			{ dataIndex: 'COMPANY_NUM'			    	,  width:80, hidden:true},
			{ dataIndex: 'BILL_TYPE'		    	    ,  width:93,align:'center', hidden:true},
			{ dataIndex: 'RECEIPT_TYPE'	    	    	,  width:60,align:'center', hidden:true},
			{ dataIndex: 'ORDER_TYPE'		    	    ,  width:60,align:'center', hidden:true},
			{ dataIndex: 'VAT_RATE'		    	    	,  width:60, hidden:true},
			{ dataIndex: 'VAT_AMOUNT_O'	    	    	,  width:80, hidden:true},
			{ dataIndex: 'DEPT_CODE'		    	    ,  width:80, hidden:true},
			{ dataIndex: 'EX_DATE'				    	,  width:80, hidden:true},
			{ dataIndex: 'EX_NUM'			    	    ,  width:86, hidden:true},
			{ dataIndex: 'AGREE_YN'		    	    	,  width:80, hidden:true},
			{ dataIndex: 'DRAFT_YN'		    	    	,  width:80, hidden:true},
			{ dataIndex: 'DEPT_NAME'		    	    ,  width:80, hidden:true},
			{ dataIndex: 'ISSUE_EXPECTED_DATE'	    	,  width:80, hidden:true},
			{ dataIndex: 'ACCOUNT_TYPE'	    	    	,  width:80, hidden:true},
			{ dataIndex: 'PROJECT_NO'		    	    ,  width:86}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				buyslipNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
        },
        returnData: function(record)	{
          	if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	masterForm.setValues({
          		'DIV_CODE':record.get('DIV_CODE'),
          		'CHANGE_BASIS_NUM':record.get('CHANGE_BASIS_NUM'),
          		'CUSTOM_CODE':record.get('CUSTOM_CODE'),
          		'CUSTOM_NAME':record.get('CUSTOM_NAME'),
          		'DEPT_CODE':record.get('DEPT_CODE'),
          		'DEPT_NAME':record.get('DEPT_NAME'),
          		//'BILL_NUM':record.get('BILL_NUM'),
         	 	//'BILL_DATE':record.get('BILL_DATE'),
          		//'CHANGE_BASIS_DATE':record.get('CHANGE_BASIS_DATE'),
        	  	'BILL_TYPE':record.get('BILL_TYPE'),
          		'MONEY_UNIT':record.get('MONEY_UNIT'),
          		'ACCOUNT_TYPE':record.get('ACCOUNT_TYPE'),
          		'BILL_DIV_CODE':record.get('BILL_DIV_CODE'),
          		'COMPANY_NUM':record.get('COMPANY_NUM'),
          		//'EX_DATE':record.get('EX_DATE'),
          		'ISSUE_EXPECTED_DATE':record.get('ISSUE_EXPECTED_DATE'),
          		'ORDER_TYPE':record.get('ORDER_TYPE'),
          		//'EX_NUM':record.get('EX_NUM'),
          		'PROJECT_NO':record.get('PROJECT_NO')
          		//'VAT_RATE':record.get('VAT_RATE')
          	});
          	
          	panelResult.setValues({
          		'DIV_CODE':record.get('DIV_CODE'),
          		'CUSTOM_CODE':record.get('CUSTOM_CODE'),
          		'CUSTOM_NAME':record.get('CUSTOM_NAME'),
          		'DEPT_CODE':record.get('DEPT_CODE'),
          		'DEPT_NAME':record.get('DEPT_NAME')
          	})
          }
    });
	var inoutGrid = Unilite.createGrid('map102ukrvInoutGrid', {//입고내역참조
//		layout: 'fit',
    	store: inoutStore,
    	selModel:   Ext.create('Ext.selection.CheckboxModel', {/*mode : "SIMPLE",*/ checkOnly : true, toggleOnClick:false }), 
        columns: [  
        	{dataIndex:'COMP_CODE'				, width: 88,hidden:true},
        	{dataIndex:'INOUT_DATE'				, width: 88},
        	{dataIndex:'INOUT_NUM'				, width: 88},
        	{dataIndex:'INOUT_TYPE'				, width: 88},
        	{dataIndex:'TOTAL_INOUT_Q'			, width: 120},
        	{dataIndex:'TOTAL_AMOUNT_I'			, width: 138,hidden:true},
        	{dataIndex:'TOTAL_VAT_AMOUNT_O'		, width: 88,hidden:true},
        	{dataIndex:'TOTAL_INOUT_I'			, width: 88}
		],
		uniOpt:{
            onLoadSelectFirst : false
        },
		listeners: {	
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['ORDER_REQ_Q'])){
					return true;
				}else{
					return false;
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
				
			}
		/*	beforeselect: function(rowSelection, record, index, eOpts) {
    			if(record.get('ORDER_REQ_Q') != 0){
//    				this.select(record);
    				return true;
    			}else{
    				return false;
				}
			}*/
		},
		returnData: function()	{
          	var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){	
	        	UniAppManager.app.onNewDataButtonDown();
	        	masterGrid.setSalesData(record.data);
	        	
/*	        	masterForm.setValues({
          		'INOUT_DATE':record.get('INOUT_DATE'), 
          		'INOUT_NUM':record.get('INOUT_NUM'),
          		'WH_CODE':record.get('WH_CODE'),
          		'CUSTOM_CODE':record.get('INOUT_CODE'),
          		'CUSTOM_NAME':record.get('INOUT_NAME'),
          		'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
          		'MONEY_UNIT':record.get('MONEY_UNIT'),
          		'INOUT_PRSN':record.get('INOUT_PRSN')
          		});
          		
          		panelResult.setValues({
          		'INOUT_DATE':record.get('INOUT_DATE'), 
          		'INOUT_NUM':record.get('INOUT_NUM'),
          		'WH_CODE':record.get('WH_CODE'),
          		'CUSTOM_CODE2':record.get('INOUT_CODE'),
          		'CUSTOM_NAME2':record.get('INOUT_NAME'),
          		'INOUT_PRSN':record.get('INOUT_PRSN'),
          		'WH_CODE':record.get('WH_CODE'),
          		'INOUT_DATE':record.get('INOUT_DATE'),
          		'INOUT_NUM':record.get('INOUT_NUM')
          		});*/
		    }); 
			this.getStore().remove(records);
			
          			
		}
	});
    
    function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '매입전표번호검색',
                width: 830,				                
                height: 580,
                layout: {type:'vbox', align:'stretch'},	                
                items: [buyslipNoSearch, buyslipNoMasterGrid],
                tbar: ['->',
			        {	
			        	itemId: 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							buyslipNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId: 'OrderNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
			    ],
				listeners: {
					beforehide: function(me, eOpt)	{
						buyslipNoSearch.clearForm();
						buyslipNoMasterGrid.reset();
						//buyslipNoDetailGrid.reset();	                							
					},
        			beforeclose: function( panel, eOpts )	{
						buyslipNoSearch.clearForm();
						buyslipNoMasterGrid.reset();
						//buyslipNoDetailGrid.reset();
		 			},
        			show: function( panel, eOpts )	{
        			 	buyslipNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
			    		buyslipNoSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
			    		buyslipNoSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
			    		buyslipNoSearch.setValue('DEPT_CODE',masterForm.getValue('DEPT_CODE'));
			    		buyslipNoSearch.setValue('DEPT_NAME',masterForm.getValue('DEPT_NAME'));
			    		buyslipNoSearch.setValue('BILL_NUM',masterForm.getValue('BILL_NUM'));

			    		buyslipNoSearch.setValue('CHANGE_BASIS_DATE_FR', UniDate.get('startOfMonth', masterForm.getValue('CHANGE_BASIS_DATE')));
			    		buyslipNoSearch.setValue('CHANGE_BASIS_DATE_TO',masterForm.getValue('CHANGE_BASIS_DATE'));
						buyslipNoSearch.setValue('BILL_DATE_FR', UniDate.get('startOfMonth', masterForm.getValue('BILL_DATE')));
			    		buyslipNoSearch.setValue('BILL_DATE_TO',masterForm.getValue('BILL_DATE'));
        			}
                }		
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
    }
     function openInoutWindow() {    		//입고내역참조
		if(!referInoutWindow) {
			referInoutWindow = Ext.create('widget.uniDetailWindow', {
                title: '입고내역참조',
                width: 1450,			                
                height: 350,
                layout: {type:'vbox', align:'stretch'},
                items: [inoutSearch, inoutGrid],
                tbar: ['->',
					{	
						itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							if(!UniAppManager.app.checkForNewDetail2()){
								return false;
							}else if(UniAppManager.app.checkForNewDetail2()){
								inoutStore.loadStoreRecords();
							}
						},
						disabled: false
					},{	
						itemId : 'confirmBtn',
						text: '요청적용',
						handler: function() {
							inoutGrid.returnData();
							masterForm.setValue('DEPT_CODE',inoutSearch.getValue('DEPT_CODE'));
							masterForm.setValue('DEPT_NAME',inoutSearch.getValue('DEPT_NAME'));
							masterForm.setValue('WH_CODE',inoutSearch.getValue('WH_CODE'));
							masterForm.setValue('ITEM_LEVEL1',inoutSearch.getValue('ITEM_LEVEL1'));
							masterForm.setValue('ITEM_LEVEL2',inoutSearch.getValue('ITEM_LEVEL2'));
							panelResult.setValue('DEPT_CODE',inoutSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME',inoutSearch.getValue('DEPT_NAME'));
							panelResult.setValue('WH_CODE',inoutSearch.getValue('WH_CODE'));
							panelResult.setValue('ITEM_LEVEL1',inoutSearch.getValue('ITEM_LEVEL1'));
							panelResult.setValue('ITEM_LEVEL2',inoutSearch.getValue('ITEM_LEVEL2'));
						},
						disabled: false
					},{	
						itemId : 'confirmCloseBtn',
						text: '요청적용 후 닫기',
						handler: function() {
							inoutGrid.returnData();
							referInoutWindow.hide();
							inoutGrid.reset();
							masterForm.setValue('DEPT_CODE',inoutSearch.getValue('DEPT_CODE'));
							masterForm.setValue('DEPT_NAME',inoutSearch.getValue('DEPT_NAME'));
							masterForm.setValue('WH_CODE',inoutSearch.getValue('WH_CODE'));
							masterForm.setValue('ITEM_LEVEL1',inoutSearch.getValue('ITEM_LEVEL1'));
							masterForm.setValue('ITEM_LEVEL2',inoutSearch.getValue('ITEM_LEVEL2'));
							panelResult.setValue('DEPT_CODE',inoutSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME',inoutSearch.getValue('DEPT_NAME'));
							panelResult.setValue('WH_CODE',inoutSearch.getValue('WH_CODE'));
							panelResult.setValue('ITEM_LEVEL1',inoutSearch.getValue('ITEM_LEVEL1'));
							panelResult.setValue('ITEM_LEVEL2',inoutSearch.getValue('ITEM_LEVEL2'));
							inoutSearch.clearForm();
							
							
							
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							inoutGrid.reset();
							inoutSearch.clearForm();
							referInoutWindow.hide();
						},
						disabled: false
					}
				],
                listeners: {
					beforehide: function(me, eOpt)	{
	    							//inoutSearch.clearForm();
	    							//otherorderGrid,reset();
	    			},
	    			beforeclose: function( panel, eOpts )	{
									//inoutSearch.clearForm();
	    							//otherorderGrid,reset();
	    			},
	    			beforeshow: function ( me, eOpts )	{
	    				//inoutStore.loadStoreRecords();
	    				inoutSearch.setValue('DEPT_CODE',masterForm.getValue('DEPT_CODE'));
	    				inoutSearch.setValue('DEPT_NAME',masterForm.getValue('DEPT_NAME'));
	    				inoutSearch.setValue('SALES_DATE_FR',UniDate.get('today')-1);
						inoutSearch.setValue('SALES_DATE_TO',UniDate.get('today'));
						inoutSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));
	    				inoutSearch.setValue('ITEM_LEVEL1',masterForm.getValue('ITEM_LEVEL1'));
	    				inoutSearch.setValue('ITEM_LEVEL2',masterForm.getValue('ITEM_LEVEL2'));
	    				inoutSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
	    			}
                }
			})
		}
		referInoutWindow.center();
		referInoutWindow.show();
	}

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
		id: 'map102ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('ORDER_REQ_DATE',UniDate.get('today'));
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ORDER_REQ_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			masterGrid.disabledLinkButtons(false);
			
			var viewCustomCodeSE = Ext.getCmp('CUSTOM_CODE_SE');
			var viewCustomCodeSE1 = Ext.getCmp('CUSTOM_CODE_SE1');
        	var viewCreditNumSE = Ext.getCmp('CREDIT_NUM_SE');
        	
        	var viewCustomCodeRE = Ext.getCmp('CUSTOM_CODE_RE');
        	var viewCustomCodeRE1 = Ext.getCmp('CUSTOM_CODE_RE1');
        	var viewCreditNumRE = Ext.getCmp('CREDIT_NUM_RE');

    		viewCustomCodeSE1.setVisible(true);
    		viewCustomCodeSE.setVisible(false);
    		viewCreditNumSE.setVisible(false);
    		
    		viewCustomCodeRE1.setVisible(true);
    		viewCustomCodeRE.setVisible(false);
    		viewCreditNumRE.setVisible(false);

			
			this.setDefault();
			
			masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			masterForm.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);
			panelResult.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);

			
			map102ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
						
					
				}
			})
		},
		onQueryButtonDown: function()	{
			masterForm.setAllFieldsReadOnly(false);
			var cbNo = masterForm.getValue('CHANGE_BASIS_NUM');
			if(Ext.isEmpty(cbNo)) {
				openSearchInfoWindow() 
			} else {
				var param= masterForm.getValues();
				masterForm.uniOpt.inLoading=true;
				masterForm.getForm().load({
					params: param,
					success: function()	{
						masterForm.setAllFieldsReadOnly(true)
//						if(BsaCodeInfo.gsDraftFlag == 'Y' && masterForm.getValue('STATUS') != '1') 	{
//							checkDraftStatus = true;							
//						}
						masterForm.uniOpt.inLoading=false;
					},
					failure: function(form, action) {
                        masterForm.uniOpt.inLoading=false;
                    }
				})
				directMasterStore1.loadStoreRecords();	
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				
				 var seq = directMasterStore1.max('SEQ');
            	 if(!seq) seq = 1;
            	 else  seq += 1;
            	 var r = {
					SEQ: seq
		        };
		         var itemLevel1 = masterForm.getValue('ITEM_LEVEL1');
		         var itemLevel2 = masterForm.getValue('ITEM_LEVEL2');
		         var whCode = masterForm.getValue('WH_CODE');
		         var divCode = masterForm.getValue('DIV_CODE');
		         
		     var r = {
		        ITEM_LEVEL1:	itemLevel1,
		        ITEM_LEVEL2:	itemLevel2,
		        WH_CODE:		whCode,
		        DIV_CODE:		divCode
		     };
				masterGrid.createRow(r,'ITEM_CODE');
				masterForm.setAllFieldsReadOnly(true);
			},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	
			if(!directMasterStore1.isDirty())	{
				if(masterForm.isDirty())	{
					masterForm.saveForm();
				}
			}else {
				directMasterStore1.saveStore();
			}
			
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				
					masterGrid.deleteSelectedRow();
				
			}
		},
		setDefault: function() {
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		cbStockQ2: function(provider, params)	{  
	    	var rtnRecord = params.rtnRecord;
			
			var dStockQ = provider['STOCK_Q'];
	    	var dGoodStockQ = provider['GOOD_STOCK_Q'];
	    	var dBadStockQ = provider['BAD_STOCK_Q'];
	    	rtnRecord.set('STOCK_Q', dStockQ);
			rtnRecord.set('GOOD_STOCK_Q', dGoodStockQ);
			rtnRecord.set('BAD_STOCK_Q', dBadStockQ);
	    },
		checkForNewDetail:function() { 
			return masterForm.setAllFieldsReadOnly(true);
        },
        checkForNewDetail2:function() { 
			return inoutSearch.setAllFieldsReadOnly(true);

        },
        
        fnGetAccountType: function(subCode){	
        	var fRecord ='';
        	Ext.each(BsaCodeInfo.AccountType, function(item, i)	{
        		if(item['codeNo'] == subCode) {
        			fRecord = item['refCode2'];
        		}
        	});
        	masterForm.setValue('BILL_TYPE', fRecord);
        	panelResult.setValue('BILL_TYPE', fRecord);

        },
        
        fnGetBillType: function(subCode){	
        	var bRecord ='';
        	Ext.each(BsaCodeInfo.BillType, function(item, i)	{
        		if(item['codeNo'] == subCode) {
        			bRecord = item['refCode1'];
        		}
        	});
        	
        	var viewCustomCodeSE = Ext.getCmp('CUSTOM_CODE_SE');
        	var viewCustomCodeSE1 = Ext.getCmp('CUSTOM_CODE_SE1');
        	var viewCreditNumSE = Ext.getCmp('CREDIT_NUM_SE');
        	
        	var viewCustomCodeRE = Ext.getCmp('CUSTOM_CODE_RE');
        	var viewCustomCodeRE1 = Ext.getCmp('CUSTOM_CODE_RE1');
        	var viewCreditNumRE = Ext.getCmp('CREDIT_NUM_RE');
 			
        	if(bRecord == 'E'){		
				allowBlankCheck = false;
        		viewCustomCodeSE.setVisible(true);
        		viewCustomCodeSE1.setVisible(false);
        		viewCreditNumSE.setVisible(false);
        		
        		viewCustomCodeRE1.setVisible(false);
        		viewCustomCodeRE.setVisible(true);	
        		viewCreditNumRE.setVisible(false);
        		
        	}
        	else if(bRecord == 'F'){
        		allowBlankCheck = false;
        		
        		viewCustomCodeSE.setVisible(false);
        		viewCustomCodeSE1.setVisible(false);
        		viewCreditNumSE.setVisible(true);
        		
        		viewCustomCodeRE.setVisible(false);
        		viewCustomCodeRE1.setVisible(false);
        		viewCreditNumRE.setVisible(true);

        	}
        	else {
        		viewCustomCodeSE.setVisible(false);
				viewCustomCodeSE1.setVisible(true);
        		viewCreditNumSE.setVisible(false);   		
        		
        		viewCustomCodeRE.setVisible(false);
        		viewCustomCodeRE1.setVisible(true);
        		viewCreditNumRE.setVisible(false);
        	}
        }
        
		
		
	});		// End of Unilite.Main({
	Unilite.createValidator('validator01', {
		store: inoutStore,
		grid: inoutGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_REQ_Q" :
					var sm = this.grid.getSelectionModel();
					if(newValue != 0){						
						var selRecords = this.grid.getSelectionModel().getSelection();
						//selRecords.push(this.grid.uniOpt.currentRecord)
						var currRec = this.grid.getStore().findBy(function(rec,id){
							if( (rec.get("BILL_NUM") ==  record.get("BILL_NUM")) && (rec.get("BILL_SEQ") ==  record.get("BILL_SEQ")) ){
								return rec;
							}
						})
						selRecords.push(this.grid.getStore().getAt(currRec));
						sm.select(selRecords);
					}else{
						var currRec = this.grid.getStore().findBy(function(rec,id){
							if( (rec.get("BILL_NUM") ==  record.get("BILL_NUM")) && (rec.get("BILL_SEQ") ==  record.get("BILL_SEQ")) ){
								return rec;
							}
						})
//						selRecords.push(this.grid.uniOpt.currentRecord);
						sm.deselect(this.grid.getStore().getAt(currRec));
					}
					break;
		
					
			}
				return rv;
						}
			});
};
</script>
