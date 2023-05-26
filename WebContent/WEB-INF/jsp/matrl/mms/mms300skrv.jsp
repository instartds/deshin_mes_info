<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms300skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mms300skrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q031" /> <!-- 조회구분(접수구분) -->
	<t:ExtComboStore comboType="AU" comboCode="Q033" /> <!-- 최종판정 -->
	<t:ExtComboStore comboType="AU" comboCode="Q021" /> <!-- 접수담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 사용여부 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var BsaCodeInfo = {
	gsReceiptPrsn: '${gsReceiptPrsn}'
};
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/
function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Mms300skrvModel1', {
		fields: [
			{name: 'COMP_CODE'    	        , text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'    	        , text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string' ,comboType: 'BOR120'},
			{name: 'INOUT_YN'    	        , text: '입고여부'	    , type: 'string' ,comboType: 'AU' ,comboCode: 'B010'},
			{name: 'CUSTOM_CODE'    	    , text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'	, type: 'string'},
			{name: 'CUSTOM_NAME'    	    , text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'    	        , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'    	        , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'    	        	, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		, type: 'string'},
			{name: 'RECEIPT_DATE'    	    , text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
			{name: 'RECEIPT_Q'    	        , text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'		, type: 'uniQty'},
			{name: 'RECEIPT_NUM'    	    , text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'RECEIPT_SEQ'    	    , text: '<t:message code="system.label.purchase.seq" default="순번"/>'		, type: 'int'},
			{name: 'WH_CODE'    	        , text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'		, type: 'string' ,store: Ext.data.StoreManager.lookup('whList')},
			{name: 'RECEIPT_PRSN'    	    , text: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>'		, type: 'string' ,comboType: 'AU' ,comboCode: 'Q021'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mms300skrvMasterStore1', {
		model: 'Mms300skrvModel1',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'mms300skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();	
		/*	var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}*/
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
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
				child:'WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('RECEIPT_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						var field2 = panelResult.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					}
				}
			}, 
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
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
//							var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						if(authoInfo == "A"){	//자기사업장	
//								popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
//								popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}else if(authoInfo == "5"){		//부서권한
//								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
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
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '입고여부',
				name: 'INOUT_YN', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B010',
				width: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INOUT_YN', newValue);
					}
				}
			},			
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE', 
				textFieldName: 'CUSTOM_NAME', 
				popupWidth: 710,
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
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'RECEIPT_DATE_FR',
				endFieldName: 'RECEIPT_DATE_TO',
				startDate: UniDate.get('yesterday'),
				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('RECEIPT_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('RECEIPT_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>',
				name:'RECEIPT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'Q021',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode4', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode4', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('RECEIPT_PRSN', newValue);
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
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout: {type : 'uniTable', columns : 4},
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType: 'BOR120', 
			allowBlank: false,
			value: UserInfo.divCode,
			child: 'WH_CODE',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
						var field = panelSearch.getField('RECEIPT_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelSearch.setValue('DIV_CODE', newValue);
						var field2 = panelSearch.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					}
				}
		}, 
		Unilite.popup('DEPT', { 
			fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
						panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
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
//					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					if(authoInfo == "A"){	//자기사업장	
//						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
//						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}else if(authoInfo == "5"){		//부서권한
//						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
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
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel: '입고여부',
			name:'INOUT_YN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B010',
			width: 200,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('INOUT_YN', newValue);
				}
			}
		},			
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName: 'CUSTOM_CODE', 
			textFieldName: 'CUSTOM_NAME', 
			popupWidth: 710,
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
		}),
		{
			fieldLabel: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'RECEIPT_DATE_FR',
			endFieldName: 'RECEIPT_DATE_TO',
			startDate: UniDate.get('yesterday'),
			endDate: UniDate.get('today'),
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('RECEIPT_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('RECEIPT_DATE_TO',newValue);
		    	}
		    }
		},{
			fieldLabel: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>',
			name:'RECEIPT_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'Q021',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('RECEIPT_PRSN', newValue);
				}
			}
		}]
    });		
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('mms300skrvGrid1', {
		layout: 'fit',
		region:'center',
		excelTitle: '부서별접수현황조회',
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
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'COMP_CODE'   				, width: 100,hidden:true},
			{dataIndex: 'DIV_CODE'    				, width: 100},
			{dataIndex: 'INOUT_YN'    				, width: 70 ,align: 'center'},
			{dataIndex: 'CUSTOM_CODE' 				, width: 100},
			{dataIndex: 'CUSTOM_NAME' 				, width: 200},
			{dataIndex: 'ITEM_CODE'   				, width: 120},
			{dataIndex: 'ITEM_NAME'   				, width: 200},
			{dataIndex: 'SPEC'    	 				, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
            		return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
			{dataIndex: 'RECEIPT_DATE'				, width: 80},
			{dataIndex: 'RECEIPT_Q'   				, width: 80, summaryType: 'sum'},
			{dataIndex: 'RECEIPT_NUM' 				, width: 120},
			{dataIndex: 'RECEIPT_SEQ' 				, width: 50},
			{dataIndex: 'WH_CODE'    				, width: 80},
			{dataIndex: 'RECEIPT_PRSN'				, width: 100}
		] 
	});   

	Unilite.Main({
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
		id: 'mms300skrvApp',
		fnInitBinding: function(){
			this.setDefault();
			UniAppManager.setToolbarButtons('save', false);
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('RECEIPT_DATE_FR'	,UniDate.get('yesterday'));
			panelSearch.setValue('RECEIPT_DATE_TO'	,UniDate.get('today'));
			panelResult.setValue('RECEIPT_DATE_FR'	,UniDate.get('yesterday'));
			panelResult.setValue('RECEIPT_DATE_TO'	,UniDate.get('today'));
			panelSearch.setValue('RECEIPT_PRSN'		,BsaCodeInfo.gsReceiptPrsn);
			panelResult.setValue('RECEIPT_PRSN'		,BsaCodeInfo.gsReceiptPrsn);
			/*mms300skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});*/
		},
		setDefault: function() {
			var field = panelSearch.getField('RECEIPT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('RECEIPT_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
		},
		onQueryButtonDown: function(){
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
			var viewNormal = masterGrid.getView();
			console.log("viewNormal: ",viewNormal);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		}
	});
};

</script>
