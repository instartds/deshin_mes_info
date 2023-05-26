<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssd130skrv" >
<t:ExtComboStore comboType="BOR120" pgmId="ssd130skrv"/> 				<!-- 사업장 -->
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
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="ssd130skrvLevel1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="ssd130skrvLevel2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="ssd130skrvLevel3Store" />
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

	
	Unilite.defineModel('ssd130skrvModel1', {
	    fields: [
	    	{name: 'COMP_CODE'			, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		, type: 'string'},
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'		, type: 'string'},
	    
	    	{name: 'DEPT_CODE'			, text: '<t:message code="system.label.sales.department" default="부서"/>'		, type: 'string'},
	    	{name: 'DEPT_NAME'			, text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'		, type: 'string'},
	    	{name: 'ITEM_LEVEL1'		, text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'		, type: 'string',store: Ext.data.StoreManager.lookup('ssd130skrvLevel1Store')},
	    	{name: 'ITEM_LEVEL2'		, text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'		, type: 'string',store: Ext.data.StoreManager.lookup('ssd130skrvLevel2Store')},
	    	{name: 'ITEM_LEVEL3'		, text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'		, type: 'string',store: Ext.data.StoreManager.lookup('ssd130skrvLevel3Store')},
	    	
	    	{name: 'SALE_Q1'			, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'DISCOUNT_AMT1'		, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'		, type: 'uniPrice'},
	    	{name: 'SALE_AMT_O1'		, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		, type: 'uniPrice'},
	    	{name: 'TAX_AMT_O1'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		, type: 'uniPrice'},
	    	{name: 'SALE_TAX_AMT1'		, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		, type: 'uniPrice'},
	    	
	    	{name: 'SALE_Q2'			, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'DISCOUNT_AMT2'		, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'		, type: 'uniPrice'},
	    	{name: 'SALE_AMT_O2'		, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		, type: 'uniPrice'},
	    	{name: 'TAX_AMT_O2'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		, type: 'uniPrice'},
	    	{name: 'SALE_TAX_AMT2'		, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		, type: 'uniPrice'},
	    	
	    	
	    	{name: 'SUM_SALE_Q'			, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'SUM_DISCOUNT_AMT'	, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'		, type: 'uniPrice'},
	    	{name: 'SUM_SALE_AMT_O'		, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		, type: 'uniPrice'},
	    	{name: 'SUM_TAX_AMT_O'		, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		, type: 'uniPrice'},
	    	{name: 'SUM_SALE_TAX_AMT'	, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		, type: 'uniPrice'}
	    ]
	});//End of Unilite.defineModel('ssd130skrvModel', {
	
	Unilite.defineModel('ssd130skrvModel2', {
	    fields: [
	    	{name: 'COMP_CODE'				, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		, type: 'string'},
	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.sales.division" default="사업장"/>'		, type: 'string'},
	    
	    	{name: 'ITEM_CODE'				, text: '<t:message code="system.label.sales.item" default="품목"/>'		, type: 'string'},
	    	{name: 'ITEM_NAME'				, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		, type: 'string'},
//	    	{name: 'STOCK_Q'				, text: '<t:message code="system.label.sales.onhandqty" default="현재고량"/>'		, type: 'uniQty'},
	    	
	    	{name: 'CON_Q'					, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'CON_DISCOUNT_AMT'		, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'		, type: 'uniPrice'},
	    	{name: 'CON_SALE_AMT'			, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		, type: 'uniPrice'},
	    	{name: 'CON_TAX_AMT'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		, type: 'uniPrice'},
	    	{name: 'CON_TOT_AMT'			, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		, type: 'uniPrice'},
	    	
	    	{name: 'CASH_Q'					, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'CASH_DISCOUNT_AMT'		, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'		, type: 'uniPrice'},
	    	{name: 'CASH_SALE_AMT'			, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		, type: 'uniPrice'},
	    	{name: 'CASH_TAX_AMT'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		, type: 'uniPrice'},
	    	{name: 'CASH_TOT_AMT'			, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		, type: 'uniPrice'},
	    	
	    	
	    	{name: 'TOT_Q'					, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'TOT_DISCOUNT_AMT'		, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'		, type: 'uniPrice'},
	    	{name: 'TOT_SALE_AMT'			, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		, type: 'uniPrice'},
	    	{name: 'TOT_TAX_AMT'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		, type: 'uniPrice'},
	    	{name: 'TOT_AMT_SUM'			, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		, type: 'uniPrice'}
	    ]
	});//End of Unilite.defineModel('Ssd130skrvModel2', {
	
	Unilite.defineModel('ssd130skrvModel3', {
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
	var directMasterStore1 = Unilite.createStore('ssd130skrvMasterStore1', {
		model: 'ssd130skrvModel1',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {	read: 'ssd130skrvService.selectList1' }
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();	
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
				
		}, groupField: 'DEPT_CODE'
			
	});//End of var directMasterStore1 = Unilite.createStore('ssd130skrvMasterStore1', {
	
	
	var directMasterStore2 = Unilite.createStore('ssd130skrvMasterStore2', {
		model: 'ssd130skrvModel2',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {  read: 'ssd130skrvService.selectList2' }
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();	
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
				
		}
			
	});//End of var directMasterStore1 = Unilite.createStore('ssd120skrvMasterStore1', {
	
	var directMasterStore3 = Unilite.createStore('ssd130skrvMasterStore3',{
		model: 'ssd130skrvModel3',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {	read: 'ssd130skrvService.selectList3' }
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
        collapsed:true,
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>', 
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
        	Unilite.popup('DEPT', { 
			   		fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
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
			     		onClear: function(type) {
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
			    	}
		   }),{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
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
			},{ 
				name: 'ITEM_LEVEL1',  			
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				xtype:'uniCombobox',
				id:  'ssd130skrvChangeSearch1',
				store: Ext.data.StoreManager.lookup('ssd130skrvLevel1Store'), 
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL2',  			
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				xtype:'uniCombobox', 
				id:  'ssd130skrvChangeSearch2',
				store: Ext.data.StoreManager.lookup('ssd130skrvLevel2Store'), 
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL3',  			
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				xtype:'uniCombobox', 
				id:  'ssd130skrvChangeSearch3',
				store: Ext.data.StoreManager.lookup('ssd130skrvLevel3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
			},
				Unilite.popup('AGENT_CUST', {
					fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>', 
					valueFieldName: 'CUSTOM_CODE',
		    		textFieldName: 'CUSTOM_NAME', 
					id:  'ssd130skrvChangeSearch4', 
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
				id:  'ssd130skrvChangeSearch5',
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
							masterGrid3.getColumn('CUSTOM_CODE').setVisible(false);
							masterGrid3.getColumn('SALE_DATE').setVisible(true);
							masterGrid3.reset();
							UniAppManager.app.onQueryButtonDown();
						} else if(newValue.GUBUN == '2' ){
							masterGrid3.getColumn('CUSTOM_CODE').setVisible(true);
							masterGrid3.getColumn('SALE_DATE').setVisible(false);
							masterGrid3.reset();
							UniAppManager.app.onQueryButtonDown();
						}
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
					   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
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
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('DEPT', { 
	   		fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
	   		valueFieldName: 'DEPT_CODE',
	        textFieldName: 'DEPT_NAME',
	    	
	    	colspan:3,
	    	listeners: {
	     		onSelected: {
	      			fn: function(records, type) {
	       				panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
	       				panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
	                },
	      			scope: this
	     		},
	     		onClear: function(type) {
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
			fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'SALE_DATE_FR',
			endFieldName: 'SALE_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
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
		},{ 
				name: 'ITEM_LEVEL1',  			
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				xtype:'uniCombobox', 
				id:  'ssd130skrvChangePanel1',
				store: Ext.data.StoreManager.lookup('ssd130skrvLevel1Store'), 
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL2',  			
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				xtype:'uniCombobox', 
				id:  'ssd130skrvChangePanel2',
				store: Ext.data.StoreManager.lookup('ssd130skrvLevel2Store'), 
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL3',  			
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				xtype:'uniCombobox', 
				id:  'ssd130skrvChangePanel3',
				store: Ext.data.StoreManager.lookup('ssd130skrvLevel3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL3', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
					fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>', 
					valueFieldName: 'CUSTOM_CODE',
		    		textFieldName: 'CUSTOM_NAME', 
					id:  'ssd130skrvChangePanel4', 
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
				id:  'ssd130skrvChangePanel5',
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
							masterGrid3.getColumn('CUSTOM_CODE').setVisible(false);
							masterGrid3.getColumn('SALE_DATE').setVisible(true);
							UniAppManager.app.onQueryButtonDown();
						} else if(newValue.GUBUN == '2' ){
							masterGrid3.getColumn('CUSTOM_CODE').setVisible(true);
							masterGrid3.getColumn('SALE_DATE').setVisible(false);	
							UniAppManager.app.onQueryButtonDown();
						}
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
					   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
	var masterGrid1 = Unilite.createGrid('ssd130skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		title: '분류별',
		excelTitle: '분류별 매출현황',
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
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id: 'masterGridTotal',    ftype: 'uniSummary',  showSummaryRow: true} ],		
    	store: directMasterStore1,
    
        columns: [
        	{dataIndex: 'COMP_CODE'			, width: 80,hidden:true},
        	{dataIndex: 'DIV_CODE'			, width: 80,hidden:true},
        
        	{dataIndex: 'DEPT_CODE'			, width: 80,
   							summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	       					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            				}
            											},
        	{dataIndex: 'DEPT_NAME'			, width: 100},
        	{dataIndex: 'ITEM_LEVEL1'		, width: 150},
        	{dataIndex: 'ITEM_LEVEL2'		, width: 130},
        	{dataIndex: 'ITEM_LEVEL3'		, width: 110},
			{ 
         	text:'위탁',
         		columns: [
		         	{dataIndex: 'SALE_Q1'			, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'DISCOUNT_AMT1'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SALE_AMT_O1'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'TAX_AMT_O1'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SALE_TAX_AMT1'		, width: 100,summaryType: 'sum'}
	         	]
			},{ 
	      	text:'현매',
     			columns: [
		        	{dataIndex: 'SALE_Q2'			, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'DISCOUNT_AMT2'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SALE_AMT_O2'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'TAX_AMT_O2'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SALE_TAX_AMT2'		, width: 100,summaryType: 'sum'}
	        	]
			},{ 
    	 	text:'<t:message code="system.label.sales.totalamount" default="합계"/>',
	     		columns: [
		        	{dataIndex: 'SUM_SALE_Q'			, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SUM_DISCOUNT_AMT'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SUM_SALE_AMT_O'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SUM_TAX_AMT_O'			, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SUM_SALE_TAX_AMT'		, width: 100,summaryType: 'sum'}
	        	]
    	 }] 
    });//End of var masterGrid = Unilite.createGrid('ssd130skrvGrid1', {  
    
    
    var masterGrid2 = Unilite.createGrid('ssd130skrvGrid2', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		title: '제품별',
		excelTitle: '제품별 매출현황',
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
        features: [ {id: 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id: 'masterGridTotal2',    ftype: 'uniSummary',  showSummaryRow: true} ],	
    	store: directMasterStore2,
        columns: [
        	{dataIndex: 'COMP_CODE'				, width: 80,hidden:true},
        	{dataIndex: 'DIV_CODE'				, width: 80,hidden:true},	
        	{dataIndex: 'ITEM_CODE'			, width: 120,locked:true,
        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
        	{dataIndex: 'ITEM_NAME'			, width: 250,locked:true},
//        	{dataIndex: 'STOCK_Q'			, width: 60},
			{ 
         	text:'위탁',
         		columns: [
		         	{dataIndex: 'CON_Q'		, width: 60,summaryType: 'sum'},
		        	{dataIndex: 'CON_DISCOUNT_AMT'		, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'CON_SALE_AMT'		, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'CON_TAX_AMT'		, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'CON_TOT_AMT'	, width: 100,summaryType: 'sum'}
	         	]
			},{ 
	      	text:'현매',
     			columns: [
		        	{dataIndex: 'CASH_Q'		, width: 60,summaryType: 'sum'},
		        	{dataIndex: 'CASH_DISCOUNT_AMT'		, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'CASH_SALE_AMT'		, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'CASH_TAX_AMT'		, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'CASH_TOT_AMT'	, width: 100,summaryType: 'sum'}
	        	]
			},{ 
    	 	text:'<t:message code="system.label.sales.totalamount" default="합계"/>',
	     		columns: [
		        	{dataIndex: 'TOT_Q'			, width: 60,summaryType: 'sum'},
		        	{dataIndex: 'TOT_DISCOUNT_AMT'			, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'TOT_SALE_AMT'			, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'TOT_TAX_AMT'			, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'TOT_AMT_SUM'	, width: 100,summaryType: 'sum'}
	        	]
    	 }] 
    });//End of var masterGrid = Unilite.createGrid('ssd130skrvGrid2', {  
    
    var masterGrid3 = Unilite.createGrid('ssd130skrvGrid3', {
    	layout: 'fit',
		region: 'center',
		title: '<t:message code="system.label.sales.salesplaceby" default="매출처별"/>',
		excelTitle: '매출처별 매출현황',
        uniOpt: {
			expandLastColumn: true,
		 	useRowNumberer: false,
		 	useContextMenu: true
        },    
		syncRowHeight: false,   
    	store: directMasterStore3,
    	features: [ {id: 'masterGridSubTotal3', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id: 'masterGridTotal3', 	ftype: 'uniSummary',  showSummaryRow: true} ],
        columns:  [        
        	{ dataIndex: 'SALE_DATE'	 		,		width: 100, locked: true},
					
			{ dataIndex: 'CUSTOM_CODE'			,		width: 120, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            }},	
			{ dataIndex: 'CUSTOM_NAME'			,		width: 200, locked: true}, 
			{ dataIndex: 'SALE_Q'	    		,		width: 70, summaryType:'sum' }, 
			{ dataIndex: 'DISCOUNT_AMT'			,		width: 80, summaryType:'sum' }, 
			{ dataIndex: 'SALE_AMT_O'	 		,		width: 100, summaryType:'sum' }, 
			{ dataIndex: 'TAX_AMT_O'	 		,		width: 100, summaryType:'sum' }, 
			{ dataIndex: 'SALE_AMT_TOT'			,		width: 150, summaryType:'sum' }
		] 
    });   
    
	var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid1,
	         masterGrid2,
	         masterGrid3
	    ],
	     listeners:  {
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
	     		var newTabId = newCard.getId();
					console.log("newCard:  " + newCard.getId());
					console.log("oldCard:  " + oldCard.getId());
					
				switch(newTabId)	{
					case 'ssd130skrvGrid1':
						var poSearch  = Ext.getCmp('ssd130skrvChangeSearch1');		/* 대분류 */
						var poSearch2 = Ext.getCmp('ssd130skrvChangeSearch2');		/* 중분류	*/
						var poSearch3 = Ext.getCmp('ssd130skrvChangeSearch3');		/* 소분류 */
						var poSearch4 = Ext.getCmp('ssd130skrvChangeSearch4');		/* 거래처	*/
						var poSearch5 = Ext.getCmp('ssd130skrvChangeSearch5');		/* 매출처별 / 합계표 선택 */
					    poSearch.setVisible(true);
					    poSearch2.setVisible(true);
					    poSearch3.setVisible(true);
					    poSearch4.setVisible(false);
					    poSearch5.setVisible(false);
					    var poSearch6 = Ext.getCmp('ssd130skrvChangePanel1');
					    var poSearch7 = Ext.getCmp('ssd130skrvChangePanel2');
					    var poSearch8 = Ext.getCmp('ssd130skrvChangePanel3');
					    var poSearch9 = Ext.getCmp('ssd130skrvChangePanel4');
					    var poSearch10 = Ext.getCmp('ssd130skrvChangePanel5');
						poSearch6.setVisible(true);
						poSearch7.setVisible(true);
						poSearch8.setVisible(true);
						poSearch9.setVisible(false);
						poSearch10.setVisible(false);
						break;
						
					case 'ssd130skrvGrid2':
						var poSearch  = Ext.getCmp('ssd130skrvChangeSearch1');
						var poSearch2 = Ext.getCmp('ssd130skrvChangeSearch2');
						var poSearch3 = Ext.getCmp('ssd130skrvChangeSearch3');
						var poSearch4 = Ext.getCmp('ssd130skrvChangeSearch4');
						var poSearch5 = Ext.getCmp('ssd130skrvChangeSearch5');
					    poSearch.setVisible(true);
					    poSearch2.setVisible(true);
					    poSearch3.setVisible(true);
					    poSearch4.setVisible(false);
					    poSearch5.setVisible(false);
					    var poSearch6 = Ext.getCmp('ssd130skrvChangePanel1');
					    var poSearch7 = Ext.getCmp('ssd130skrvChangePanel2');
					    var poSearch8 = Ext.getCmp('ssd130skrvChangePanel3');
					    var poSearch9 = Ext.getCmp('ssd130skrvChangePanel4');
					    var poSearch10 = Ext.getCmp('ssd130skrvChangePanel5');
						poSearch6.setVisible(true);
						poSearch7.setVisible(true);
						poSearch8.setVisible(true);
						poSearch9.setVisible(false);
						poSearch10.setVisible(false);
						break;
						
					case 'ssd130skrvGrid3':
						
						var poSearch  = Ext.getCmp('ssd130skrvChangeSearch1');
						var poSearch2 = Ext.getCmp('ssd130skrvChangeSearch2');
						var poSearch3 = Ext.getCmp('ssd130skrvChangeSearch3');
						var poSearch4 = Ext.getCmp('ssd130skrvChangeSearch4');
						var poSearch5 = Ext.getCmp('ssd130skrvChangeSearch5');
					    poSearch.setVisible(false);
					    poSearch2.setVisible(false);
					    poSearch3.setVisible(false);
					    poSearch4.setVisible(true);
					    poSearch5.setVisible(true);
					    var poSearch6 = Ext.getCmp('ssd130skrvChangePanel1');
					    var poSearch7 = Ext.getCmp('ssd130skrvChangePanel2');
					    var poSearch8 = Ext.getCmp('ssd130skrvChangePanel3');
					    var poSearch9 = Ext.getCmp('ssd130skrvChangePanel4');
					    var poSearch10 = Ext.getCmp('ssd130skrvChangePanel5');
						poSearch6.setVisible(false);
						poSearch7.setVisible(false);
						poSearch8.setVisible(false);
						poSearch9.setVisible(true);
						poSearch10.setVisible(true);
						
						break;
					default:
						break;
				}
	     	}
	     }
	});
    
    
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
			panelSearch  	
		],
		id: 'ssd130skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save',false);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('SALE_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('SALE_DATE_TO',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('SALE_DATE_TO',UniDate.get('today'));

			var poSearch  = Ext.getCmp('ssd130skrvChangeSearch1');		/* 대분류 */
			var poSearch2 = Ext.getCmp('ssd130skrvChangeSearch2');		/* 중분류	*/
			var poSearch3 = Ext.getCmp('ssd130skrvChangeSearch3');		/* 소분류 */
			var poSearch4 = Ext.getCmp('ssd130skrvChangeSearch4');		/* 거래처	*/
			var poSearch5 = Ext.getCmp('ssd130skrvChangeSearch5');		/* 매출처별 / 합계표 선택 */
		    poSearch.setVisible(true);
		    poSearch2.setVisible(true);
		    poSearch3.setVisible(true);
		    poSearch4.setVisible(false);
		    poSearch5.setVisible(false);
		    var poSearch6 = Ext.getCmp('ssd130skrvChangePanel1');
		    var poSearch7 = Ext.getCmp('ssd130skrvChangePanel2');
		    var poSearch8 = Ext.getCmp('ssd130skrvChangePanel3');
		    var poSearch9 = Ext.getCmp('ssd130skrvChangePanel4');
		    var poSearch10 = Ext.getCmp('ssd130skrvChangePanel5');
			poSearch6.setVisible(true);
			poSearch7.setVisible(true);
			poSearch8.setVisible(true);
			poSearch9.setVisible(false);
			poSearch10.setVisible(false);
			
			
		},
		onQueryButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			
			if(activeTabId == 'ssd130skrvGrid1'){		/* 분류별 */
				if(!UniAppManager.app.checkForNewDetail()){
					return false;
				}else{
					directMasterStore1.loadStoreRecords();
				}
			}
			else if(activeTabId == 'ssd130skrvGrid2'){	/* 제품별 */
				if(!UniAppManager.app.checkForNewDetail()){
					return false;
				}else{
					directMasterStore2.loadStoreRecords();
				}
			} 
			else if(activeTabId == 'ssd130skrvGrid3'){	/* 매출처별 */
				if(!UniAppManager.app.checkForNewDetail()){
					return false;
				}else{
					directMasterStore3.loadStoreRecords();
				}
			}
			UniAppManager.setToolbarButtons('reset', true); 
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			var activeTabId = tab.getActiveTab().getId();
			
			if(activeTabId == 'ssd130skrvGrid1'){		/* 분류별 */
				masterGrid1.reset();
				directMasterStore1.clearData();
			}
			else if(activeTabId == 'ssd130skrvGrid2'){	/* 제품별 */
				masterGrid2.reset();
				directMasterStore3.clearData();
			} 
			else if(activeTabId == 'ssd130skrvGrid3'){	/* 매출처별 */
				masterGrid3.reset();
				directMasterStore3.clearData();
			}
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
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});

};


</script>
