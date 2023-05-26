<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="map101ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map101ukrv"  />          <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" opts= '${gsList1}' /> <!-- 계산서유형 -->
	<t:ExtComboStore comboType="AU" comboCode="M302" /> <!-- 매입유형 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B035" /> <!-- 수불구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!-- 과세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
		
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell1 {
background-color: #fcfac5;
}
.x-change-cell2 {
background-color: #fed9fe;
}
</style>
<script type="text/javascript" >
//var SearchInfoWindow;	//조회버튼 누르면 나오는 조회창
var BsaCodeInfo = {	
	gsAdvanUseYn: '${gsAdvanUseYn}',
	gsDefaultMoney: '${gsDefaultMoney}',
	gsList1: '${gsList1}'
};

var CustomCodeInfo = {
	gsUnderCalBase: '',
	gsTaxInclude: '',
	gsTaxCalcType: '',
	gsBillType: ''
};

/*alert(CustomCodeInfo.gsUnderCalBase);
alert(CustomCodeInfo.gsTaxInclude);
alert(CustomCodeInfo.gsTaxCalcType);*/


/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/

function appMain() {
   /**
    *   Model 정의 
    * @type 
    */

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'map101ukrvService.selectList',
			update: 'map101ukrvService.updateDetail',
			create: 'map101ukrvService.insertDetail',
			destroy: 'map101ukrvService.deleteDetail',
			syncAll: 'map101ukrvService.saveAll'
		}
	});	
	
	Unilite.defineModel('Map101ukrvModel', {
		fields: [
			{name: 'COMP_CODE' 			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE' 			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string',comboType:'BOR120'},
			{name: 'CHECK' 				, text: '체크확인'			, type: 'string'},
			{name: 'CHECK_NAME' 		, text: '확정/취소'		, type: 'string'},
			{name: 'SEQ' 				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'			, type: 'int'},
			{name: 'CUSTOM_NAME' 		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
			
			{name: 'INOUT_DATE' 		, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'			, type: 'uniDate'},
			{name: 'INOUT_NUM' 			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'			, type: 'string'},
//			{name: 'WH_CODE' 			, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'			, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'BILL_DATE'			, text: '<t:message code="system.label.purchase.billdate" default="계산서일"/>'			, type: 'uniDate', allowBlank: false},
			{name: 'BILL_NUM' 			, text: '<t:message code="system.label.purchase.billno" default="계산서번호"/>'		, type: 'string'},
			{name: 'CHANGE_BASIS_NUM' 	, text: '<t:message code="system.label.purchase.purchaseslipno" default="매입전표번호"/>'		, type: 'string'},
			{name: 'INOUT_TYPE' 		, text: '수불구분'			, type: 'string',comboType:'AU', comboCode:'B035'},
			{name: 'TAX_TYPE' 			, text: '세구분'			, type: 'string',comboType:'AU', comboCode:'B059'},
			{name: 'BILL_TYPE_G' 		, text: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>'		, type: 'string'},
			{name: 'SUM_INOUT_I' 		, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'			, type: 'uniPrice'},
			{name: 'SUM_INOUT_TAX_AMT' 	, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'			, type: 'uniPrice'},
			{name: 'TOTAL_INOUT_I' 		, text: '총금액'			, type: 'uniPrice'},
			
			{name: 'INOUT_CODE' 		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'}
		]
	});//End of Unilite.defineModel('Map101ukrvModel', {
	
   	Unilite.defineModel('Map101ukrvModel2', {
	    fields: [  	 	
	    	{name: 'COMP_CODE'		,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			,type: 'string'},
	    	{name: 'DIV_CODE'		,text: '<t:message code="system.label.purchase.division" default="사업장"/>'			,type: 'string'},
			{name: 'INOUT_SEQ'		,text: '입고순번'			,type: 'int'},
			{name: 'WH_CODE' 			, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'			, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'ITEM_CODE'		,text: '품번'				,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'				,type: 'string'},
			{name: 'ORDER_UNIT'		,text: '<t:message code="system.label.purchase.unit" default="단위"/>'				,type: 'string'},
			{name: 'INOUT_Q'		,text: '<t:message code="system.label.purchase.qty" default="수량"/>'				,type: 'uniQty'},
			{name: 'INOUT_P'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'				,type: 'uniUnitPrice'},
			{name: 'TAX_TYPE' 		,text: '과세구분'			,type: 'string',comboType:'AU',comboCode:'B059'},
			{name: 'INOUT_I'		,text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'			,type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'	,text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'			,type: 'uniPrice'},
			{name: 'TOTAL_INOUT_I'	,text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'			,type: 'uniPrice'}
		]  
	});		//End of Unilite.defineModel('Map101ukrvModel2', {
	
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
	var directMasterStore1 = Unilite.createStore('map101ukrvMasterStore1',{
		model: 'Map101ukrvModel',
		uniOpt: {
			isMaster: true,         // 상위 버튼 연결 
			editable: true,         // 수정 모드 사용 
			deletable: false,         // 삭제 가능 여부 
			useNavi: false         // prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,	
		
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore1.loadStoreRecords();
						masterGrid2.reset();
						beforeRowIndex = -1;
						/*var master = batch.operations[0].getResultSet();
						masterForm.setValue("CHANGE_BASIS_NUM", master.CHANGE_BASIS_NUM);
						
						masterForm.setValue("BILL_NUM", master.BILL_NUM);
						panelResult.setValue("BILL_NUM", master.BILL_NUM);
						var cbNum = masterForm.getValue('CHANGE_BASIS_NUM');
						var bNum = masterForm.getValue('BILL_NUM');
						Ext.each(list, function(record, index) {
							if(record.data['CHANGE_BASIS_NUM'] != cbNum && record.data['BILL_NUM'] != bNum) {
								record.set('CHANGE_BASIS_NUM', cbNum);
								record.set('BILL_NUM', bNum);
							}
						})
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);	*/	
					 } 
				};
				this.syncAllDirect(config);
			} else {
              
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
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
			if(authoInfo == "5" && Ext.isEmpty(masterForm.getValue('SEARCH_DEPT_CODE'))){
				param.SEARCH_DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		groupField: 'CUSTOM_NAME'

	});//End of var directMasterStore1 = Unilite.createStore('map101ukrvMasterStore1',{
	var directMasterStore2 = Unilite.createStore('map101ukrvMasterStore2', {
		model: 'Map101ukrvModel2',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'map101ukrvService.selectList2'                	
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params : param
			});
		}
		/*saveStore : function()	{	
				var inValidRecs = this.getInvalidRecords();
            	
            	var rv = true;
            	
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}*/
	});//End of var directMasterStore2 = Unilite.createStore('map101ukrvMasterStore1', {

   /**
    * 검색조건 (Search Panel)
    * @type 
    */
    var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        trackResetOnLoad: false,
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
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(oldValue)){//화면 로드시에는 change안타게 하기위해
							masterForm.setValue('DEPT_CODE', '');
							masterForm.setValue('DEPT_NAME', '');
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');		
						}										
						panelResult.setValue('DIV_CODE', newValue);
						var param = {"DIV_CODE": masterForm.getValue('DIV_CODE')};
						map101ukrvService.billDivCode(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
								panelResult.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
							}
						});
					}
				}
			},			
				Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
					valueFieldName: 'SEARCH_DEPT_CODE',
			   	 	textFieldName: 'SEARCH_DEPT_NAME',
//					validateBlank: false,
					/*allowBlank: false,
					holdable: 'hold',*/
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('SEARCH_DEPT_CODE', masterForm.getValue('SEARCH_DEPT_CODE'));
								panelResult.setValue('SEARCH_DEPT_NAME', masterForm.getValue('SEARCH_DEPT_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
									panelResult.setValue('SEARCH_DEPT_CODE', '');
									panelResult.setValue('SEARCH_DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	
								popup.setExtParam({'SEARCH_DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'SEARCH_DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'SEARCH_DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('INOUT_DATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INOUT_DATE_TO',newValue);
			    	}
			    }
			},
				Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE', 
				textFieldName: 'CUSTOM_NAME', 
				//validateBlank:false, 
				popupWidth: 710,
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
			}),
			
			{
				fieldLabel: '지불일자',
				name: 'COLLECT_DAY',
				xtype: 'uniTextfield',
				fieldStyle: 'text-align: right;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COLLECT_DAY', newValue);
					}
				}
			},			
			{
				fieldLabel: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>', 
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120',
				allowBlank: false,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				name:'CHANGE_BASIS_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('endOfMonth'),
	            allowBlank: false,
	            width: 200,
//	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CHANGE_BASIS_DATE', newValue);
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>', 
				name: 'BILL_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'A022',
				allowBlank: false,
//				holdable: 'hold',
				value:'51',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_TYPE', newValue);
						
						UniAppManager.app.onQueryButtonDown();
						if(newValue == '51' || newValue == '57' ){
							panelResult.setValue('ACCOUNT_TYPE', '10');
						}else if(newValue == '53' ){
							panelResult.setValue('ACCOUNT_TYPE', '20');
						}else if(newValue == '62' ){
							panelResult.setValue('ACCOUNT_TYPE', '30');
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>', 
				name: 'ACCOUNT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M302',
				allowBlank: false,
//				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACCOUNT_TYPE', newValue);
						if(newValue == '10' ){
							panelResult.setValue('BILL_TYPE', '51');
						}else if(newValue == '20' ){
							panelResult.setValue('BILL_TYPE', '53');
						}else if(newValue == '30' ){
							panelResult.setValue('BILL_TYPE', '62');
						}
					}
				}
			},
				Unilite.popup('DEPT', { 
					fieldLabel: '결의부서', 
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
//					validateBlank: false,
					allowBlank: false,
//					holdable: 'hold',
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
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
				fieldLabel: '고객분류', 
				name: 'AGENT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B055',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AGENT_TYPE', newValue);
						}
					}				
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>', 
				name: 'ORDER_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M001',
				allowBlank: false
//				holdable: 'hold'
			},{
				fieldLabel:'<t:message code="system.label.purchase.receiptno" default="입고번호"/>',
				name:'INOUT_NUM',
				xtype:'uniTextfield',
				hidden:true	
			},{
				fieldLabel:'<t:message code="system.label.purchase.customcode" default="거래처코드"/>',
				name:'G_INOUT_CODE',
				xtype:'uniTextfield',
				hidden:true	
			},{
				fieldLabel:'<t:message code="system.label.purchase.purchaseslipno" default="매입전표번호"/>',
				name:'G_CHANGE_BASIS_NUM',
				xtype:'uniTextfield',
				hidden:true	
			},{
				fieldLabel:'과세구분',
				name:'G_TAX_TYPE',
				xtype:'uniTextfield',
				hidden:true	
			},{
				fieldLabel: '전자발행여부', 
				name: 'BILL_SEND_YN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'A149',
				allowBlank: false,
//				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_SEND_YN', newValue);
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
								panelResult.getField('CHECKING').setValue(newValue.CHECKING);
							}
						}
				}
			
			
			
			
			]	
		}],
		/*api: {
			load: 'map101ukrvService.selectForm',
			submit: 'map101ukrvService.syncForm'				
		},	*/	
		setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});   	
	   				if(invalid.length > 0) {   	
						if(invalid.items[0]['fieldLabel'] == '매입사업장'){
							var labelText = invalid.items[0]['fieldLabel']+':';
							alert(labelText+Msg.sMB083);
	   						r=false;
						}else if(invalid.items[0]['name'] == 'INOUT_DATE_FR' ||  invalid.items[0]['name'] == 'INOUT_DATE_TO' ) {	   					
	   						alert('입고일은(는)'+Msg.sMB083);
	   						r=false;
	   					}
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
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(oldValue)){	//화면 로드시에는 change안타게 하기위해
							masterForm.setValue('DEPT_CODE', '');
							masterForm.setValue('DEPT_NAME', '');
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');		
						}
						masterForm.setValue('DIV_CODE', newValue);
						var param = {"DIV_CODE": masterForm.getValue('DIV_CODE')};
						map101ukrvService.billDivCode(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
								panelResult.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
							}
						});
					}
				}
			},			
				Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
					valueFieldName: 'SEARCH_DEPT_CODE',
			   	 	textFieldName: 'SEARCH_DEPT_NAME',
//					validateBlank: false,
					/*allowBlank: false,
					holdable: 'hold',*/
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('SEARCH_DEPT_CODE', panelResult.getValue('SEARCH_DEPT_CODE'));
								masterForm.setValue('SEARCH_DEPT_NAME', panelResult.getValue('SEARCH_DEPT_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
									masterForm.setValue('SEARCH_DEPT_CODE', '');
									masterForm.setValue('SEARCH_DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	
								popup.setExtParam({'SEARCH_DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'SEARCH_DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'SEARCH_DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(masterForm) {
						masterForm.setValue('INOUT_DATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(masterForm) {
			    		masterForm.setValue('INOUT_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE', 
				textFieldName: 'CUSTOM_NAME', 
				//validateBlank:false, 
				popupWidth: 710,
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
				fieldLabel: '지불일자',
				name: 'COLLECT_DAY',
				xtype: 'uniTextfield',
				fieldStyle: 'text-align: right;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('COLLECT_DAY', newValue);
					}
				}
			  },{
				fieldLabel: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>', 
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120',
				allowBlank: false,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BILL_DIV_CODE', newValue);
					}
				}
			 },{ 
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				name:'CHANGE_BASIS_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('endOfMonth'),
	            allowBlank: false,
	            width: 200,
//	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('CHANGE_BASIS_DATE', newValue);
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>', 
				name: 'BILL_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'A022',
				allowBlank: false,
//				holdable: 'hold',
				value:'51',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('BILL_TYPE', newValue);
					UniAppManager.app.onQueryButtonDown();
					
					if(newValue == '51' || newValue == '57' ){
							masterForm.setValue('ACCOUNT_TYPE', '10');
						}else if(newValue == '53' ){
							masterForm.setValue('ACCOUNT_TYPE', '20');
						}else if(newValue == '62' ){
							masterForm.setValue('ACCOUNT_TYPE', '30');
						}
					}
				}
			},
			  {
				fieldLabel: '고객분류', 
				name: 'AGENT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('AGENT_TYPE', newValue);
					}
				}
			  },/* {
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
		     }, */
		       {
				fieldLabel: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>', 
				name: 'ACCOUNT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M302',
				allowBlank: false,
//				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ACCOUNT_TYPE', newValue);
						if(newValue == '10' ){
							masterForm.setValue('BILL_TYPE', '51');
						}else if(newValue == '20' ){
							masterForm.setValue('BILL_TYPE', '53');
						}else if(newValue == '30' ){
							masterForm.setValue('BILL_TYPE', '62');
						}
					}
				}
			},
			Unilite.popup('DEPT', { 
					fieldLabel: '결의부서', 
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
//					validateBlank: false,
					allowBlank: false,
//					holdable: 'hold',
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
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),
			{
				fieldLabel: '전자발행여부', 
				name: 'BILL_SEND_YN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'A149',
				allowBlank: false,
//				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BILL_SEND_YN', newValue);
					}
				}
			},{
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.purchase.classfication" default="구분"/>',						            		
					labelWidth:90,
					colspan:3,
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
				xtype:'container',
				width:500,
				items: {
					border:false,
			 		html:"<div id='' class='x-hide-display' align='right' style='margin-top:5px'><div style='font-weight:bold; font-size:13px; color:red;'>※ 세금계산서 발행금액이 아닙니다.</div>"
				}
			}],
	    setAllFieldsReadOnly: function(b) {	////readOnly 안먹음..
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
						//this.mask();
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
  					//this.unmask();
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
	var masterGrid = Unilite.createGrid('map101ukrvGrid1', {
       // for tab       
		layout: 'fit',
		region:'center',
//		split:true,
		excelTitle: '일괄 매입지급결의 확정',
		selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false,
        	listeners: {        
        		
        	/*	beforeselect: function(rowSelection, record, index, eOpts) {
        			
        		},*/
			/*	select: function(grid, record, index, eOpts ){		
					
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
					
        		}*/
        		
        		
//			select: function(grid, record, index, eOpts ){		
        		
			selectionchange: function( grid, selected, eOpts ){
				var records = masterGrid.getSelectedRecords();
					if(records.length > 0){
						UniAppManager.setToolbarButtons('save',true);
					}
					
					Ext.each(selected, function(record, index){
						if(record.get('BILL_NUM') == '' && record.get('CHANGE_BASIS_NUM') == ''){
							record.set('CHECK','1');	//확정
							record.set('CHECK_NAME', '확정');
						}else{
							record.set('CHECK','2'); //취소
							record.set('CHECK_NAME', '취소');
						}
					})
					
					},	
        		
/*        	beforeselect: function( grid, record, index, eOpts ){
//				var records = masterGrid.getSelectedRecords();
//					if(records.length > 0){
//						UniAppManager.setToolbarButtons('save',true);
//					}
					
					
						if(record.get('BILL_NUM') == '' && record.get('CHANGE_BASIS_NUM') == ''){
							record.set('CHECK','1');	//확정
							record.set('CHECK_NAME', '<t:message code="system.label.purchase.confirmation" default="확정"/>');
						}else{
//							record.set('CHECK','2'); //취소
//							record.set('CHECK_NAME', '취소');
						}
					
					
					},*/
					
		/*	체크로직 비활성화	var sm = masterGrid.getSelectionModel();
					var selRecords = masterGrid.getSelectionModel().getSelection();
					
					 Ext.each(directMasterStore1.data.items, function(rec, index) {
								if( (rec.get('INOUT_CODE') ==  record.get('INOUT_CODE')) 
								&& (UniDate.getDateStr(rec.get('BILL_DATE')) ==  UniDate.getDateStr(record.get('BILL_DATE'))) 
								&& (rec.get('BILL_NUM') == '')
								&& (rec.get('CHANGE_BASIS_NUM') == '')){
									selRecords.push(rec);
								}				
					});
					sm.select(selRecords);*/
	          
				deselect:  function(grid, record, index, eOpts ){
					record.set('CHECK','');
					record.set('CHECK_NAME','');
					
					var records = masterGrid.getSelectedRecords();
					if(records.length < 1){
						UniAppManager.setToolbarButtons('save',false);
					}
        		}
        	}
        }),
		uniOpt: {
			onLoadSelectFirst: false,  
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
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
			showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'COMP_CODE' 		 , width: 93,hidden:true},
			{dataIndex: 'DIV_CODE' 			 , width: 93,hidden:true},
			{dataIndex: 'CHECK' 			 , width: 93,hidden:true},
			{dataIndex: 'CHECK_NAME' 		 , width: 66,align:'center'},
			{dataIndex: 'SEQ' 				 , width: 40},
			{dataIndex: 'CUSTOM_NAME' 		 , width: 135,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            	}
			},
			{dataIndex: 'INOUT_DATE' 		 , width: 80},
			{dataIndex: 'INOUT_NUM' 		 , width: 120},
//			{dataIndex: 'WH_CODE' 		 	 , width: 100,align:'center'},
			{dataIndex: 'BILL_DATE'	 		 , width: 80,tdCls:'x-change-cell1'},
			{dataIndex: 'BILL_NUM' 	 	 	 , width: 120},
			{dataIndex: 'CHANGE_BASIS_NUM' 	 , width: 120},
			{dataIndex: 'INOUT_TYPE' 		 , width: 70,align:'center'},
			{dataIndex: 'TAX_TYPE'	 		 , width: 70,align:'center'},
			{dataIndex: 'BILL_TYPE_G'	     , width: 70,hidden:true},
			
			{dataIndex: 'SUM_INOUT_I' 		 , width: 90,summaryType: 'sum'},
			{dataIndex: 'SUM_INOUT_TAX_AMT'	 , width: 90,summaryType: 'sum'},
			{dataIndex: 'TOTAL_INOUT_I' 	 , width: 90,summaryType: 'sum',tdCls:'x-change-cell2'},			
			{dataIndex: 'INOUT_CODE' 		 , width: 70}
		],
	listeners: {
		/*selectionchange: function(){
				var records = masterGrid2.getSelectedRecords();
				if(records.length > '0'){
					
					
					UniAppManager.setToolbarButtons('save',true);
				}else if(records.length < '1'){
					UniAppManager.setToolbarButtons('save',false);
				}
			},*/
		
		cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					masterForm.setValue('INOUT_NUM',record.get('INOUT_NUM'));
					masterForm.setValue('G_INOUT_CODE',record.get('INOUT_CODE'));
					masterForm.setValue('G_CHANGE_BASIS_NUM',record.get('CHANGE_BASIS_NUM'));
					masterForm.setValue('G_TAX_TYPE',record.get('TAX_TYPE'));
					directMasterStore2.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.BILL_NUM == ''){
					if(UniUtils.indexOf(e.field, ['BILL_DATE'])){
						return true;
					}else{
						return false;	
					}
				}else{
					return false;
				}
    		}
	}
/*		disabledLinkButtons: function(b) {
       		this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
       		this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
       		this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
		},*/
	});//End of var masterGrid = Unilite.createGrid('map101ukrvGrid1', {   

	var masterGrid2 = Unilite.createGrid('map101ukrvGrid2', {
		layout: 'fit',
		region: 'east',
		split:true,
		excelTitle: '일괄 매입지급결의 확정(detail)',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
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
			showSummaryRow: true
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		store: directMasterStore2,
		columns: [
				{dataIndex: 'COMP_CODE'				,width:80,hidden:true},
				{dataIndex: 'DIV_CODE'				,width:80,hidden:true},
				{dataIndex: 'INOUT_SEQ'				,width:60},
				{dataIndex: 'WH_CODE' 		 	 , width: 100,align:'center'},
				{dataIndex: 'ITEM_CODE'				,width:100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            	}},
				{dataIndex: 'ITEM_NAME'				,width:200},
				{dataIndex: 'ORDER_UNIT'			,width:50,align:'center'},
				{dataIndex: 'INOUT_Q'				,width:60,summaryType: 'sum'},
				{dataIndex: 'INOUT_P'				,width:60,summaryType: 'sum'},
				{dataIndex: 'TAX_TYPE' 		   		,width:80,align:'center'},
				{dataIndex: 'INOUT_I'				,width:80,summaryType: 'sum'},
				{dataIndex: 'INOUT_TAX_AMT'			,width:80,summaryType: 'sum'},
				{dataIndex: 'TOTAL_INOUT_I'			,width:80,summaryType: 'sum'}
				
		]
	});//End of var masterGrid = Unilite.createGrid('map101ukrvGrid1', {

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,masterGrid2, panelResult
			]	
		},
			masterForm  	
		],	    	
		id: 'map101ukrvApp',
		fnInitBinding: function(){
			masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME',UserInfo.deptName);
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
//			masterForm.setValue('BILL_DIV_CODE',UserInfo.divCode);
			var param = {"DIV_CODE": masterForm.getValue('DIV_CODE')};
				map101ukrvService.billDivCode(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						masterForm.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
						panelResult.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
					}
				});
			
			masterForm.setValue('ORDER_TYPE','1');
			masterForm.setValue('ACCOUNT_TYPE','10');
			masterForm.setValue('BILL_TYPE','51');
			masterForm.setValue('CHANGE_BASIS_DATE', UniDate.get('endOfMonth'));
			masterForm.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
			masterForm.setValue('INOUT_DATE_TO', UniDate.get('today'));
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			//panelResult.setValue('ORDER_TYPE','1');
			panelResult.setValue('ACCOUNT_TYPE','10');
			panelResult.setValue('BILL_TYPE','51');
			panelResult.setValue('CHANGE_BASIS_DATE', UniDate.get('endOfMonth'));
			panelResult.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));
			masterForm.setValue('BILL_SEND_YN','Y');
			panelResult.setValue('BILL_SEND_YN','Y');
//			masterForm.setValue('SEARCH_DEPT_CODE',UserInfo.deptCode);
//			masterForm.setValue('SEARCH_DEPT_NAME',UserInfo.deptName);
//			panelResult.setValue('SEARCH_DEPT_CODE',UserInfo.deptCode);
//			panelResult.setValue('SEARCH_DEPT_NAME',UserInfo.deptName);
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			this.setDefault();
		},
		setDefault: function() {
			
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function(){
			if(!masterForm.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore1.loadStoreRecords();	
			masterGrid2.reset();
			beforeRowIndex = -1;
			
/*			masterForm.setAllFieldsReadOnly(false);
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
			}*/
/*			
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	*/			
		},
		
		onResetButtonDown: function() {
//			masterForm.clearForm();
//			panelResult.clearForm();
			masterForm.reset();
			panelResult.reset();
//			masterForm.setAllFieldsReadOnly(false);
//			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterGrid2.reset();
			directMasterStore1.clearData();
			directMasterStore2.clearData();
			this.fnInitBinding();
			
		},
		
		onSaveDataButtonDown: function(config) {	
			//폼전체 필드 필수 체크
			if(!panelResult.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore1.saveStore();
			
			masterForm.setValue('INOUT_NUM','');
			
		}

	});//End of Unilite.Main( {
	
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "BILL_DATE" :
					var sm = this.grid.getSelectionModel();
						var selRecords = this.grid.getSelectionModel().getSelection();
						selRecords.push(this.grid.uniOpt.currentRecord)
						sm.select(selRecords);
					break;
					
			}
				return rv;
						}
			});	

};
</script>