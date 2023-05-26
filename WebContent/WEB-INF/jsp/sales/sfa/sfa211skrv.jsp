<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sfa211skrv"  >
<t:ExtComboStore comboType="BOR120"  pgmId="sfa211skrv"/> 		<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="S017"/>				<!-- 수금유형		-->
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
function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('sfa211skrvModel', {
	    fields: [
	    	{name:'COMP_CODE' 			, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'			, type: 'string'},
	    	{name:'DIV_CODE' 			, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string'},
	    	{name:'TEAM_CODE' 			, text: '팀코드'			, type: 'string'},
	    	{name:'TEAM_NAME' 			, text: '팀명'			, type: 'string'},
	    	{name:'STORE_CODE' 			, text: '<t:message code="system.label.sales.department" default="부서"/>'			, type: 'string'},
	    	{name:'STORE_NAME' 			, text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'			, type: 'string'},
	    	{name:'SALE_AMT_O' 			, text: '총매출액'			, type: 'uniPrice'},	    	
	    	{name:'DIRECT_SALES' 		, text: '직영매출'			, type: 'uniPrice'},
	    	{name:'DISCOUNT_P' 			, text: '<t:message code="system.label.sales.discount" default="할인"/>'			, type: 'uniUnitPrice'},
	    	{name:'DIRECT_NET' 			, text: '직영순매출'		, type: 'uniPrice'},
	    	{name:'PRODUCTS_FEE1' 		, text: '수탁수수료'		, type: 'uniPrice'},
	    	{name:'PRODUCTS1' 			, text: '수탁상품'			, type: 'uniPrice'},
	    	{name:'FIRST_MONEY' 		, text: '선수금입금'		, type: 'uniPrice'},
	    	{name:'COLLECT_AMT' 		, text: '총수금액'			, type: 'uniPrice'},
	    	{name:'CASH_MONEY' 			, text: '현금'			, type: 'uniPrice'},
	    	{name:'CARD_MONEY' 			, text: '카드'			, type: 'uniPrice'},
	    	{name:'CRDIT_MONEY' 		, text: '외상'			, type: 'uniPrice'},
	    	{name:'TICKECT_MONEY' 		, text: '회수상품권'		, type: 'uniPrice'},
	    	{name:'SUBSTITUTES_MONEY' 	, text: '매출대체선수'		, type: 'uniPrice'},
	    	{name:'FIRST_O' 			, text: '선수금'			, type: 'uniPrice'},
	    	{name:'BALANCE' 			, text: '과부족'			, type: 'uniPrice'},
	    	{name:'SALE_BALANCE' 		, text: '실과부족'			, type: 'uniPrice'}
	    	


	    	
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
	var MasterStore = Unilite.createStore('sfa211skrvMasterStore',{
			model: 'sfa211skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
               		read: 'sfa211skrvService.selectList'
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
			},listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
			}
		},
			groupField: 'TEAM_CODE'
	});		// End of var MasterStore 
	
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
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
			},
				Unilite.popup('DEPT',{ 
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			})]
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
	});
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
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
			},
				Unilite.popup('DEPT',{ 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
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
			})],
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
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('sfa211skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
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
        	{dataIndex:'COMP_CODE' 			, width: 120, hidden: true },
        	{dataIndex:'DIV_CODE' 			, width: 120, hidden: true},
        	{dataIndex:'TEAM_CODE' 			, width: 70, locked: true},
        	{dataIndex:'TEAM_NAME' 			, width: 120, locked: true},
        	{dataIndex:'STORE_CODE' 		, width: 70, locked: true},
        	{dataIndex:'STORE_NAME' 		, width: 120, locked: true, 
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            	}
            },
        	{dataIndex:'SALE_AMT_O' 		, width: 120, summaryType: 'sum',tdCls:'x-change-cell2'},
        	{dataIndex:'DIRECT_SALES' 		, width: 120, summaryType: 'sum'},
        	{dataIndex:'DISCOUNT_P' 		, width: 120, summaryType: 'sum'},
        	{dataIndex:'DIRECT_NET' 		, width: 120, summaryType: 'sum'},
        	{dataIndex:'PRODUCTS_FEE1' 		, width: 120, summaryType: 'sum'},
        	{dataIndex:'PRODUCTS1' 			, width: 120, summaryType: 'sum'},
        	{dataIndex:'FIRST_MONEY' 		, width: 120, summaryType: 'sum'},
        	{dataIndex:'COLLECT_AMT' 		, width: 120, summaryType: 'sum',tdCls:'x-change-cell2', hidden: true},
        	{dataIndex:'CRDIT_MONEY' 		, width: 120, summaryType: 'sum'},
        	{dataIndex:'CARD_MONEY' 		, width: 120, summaryType: 'sum'},
        	{dataIndex:'TICKECT_MONEY' 		, width: 120, summaryType: 'sum'},
        	{dataIndex:'SUBSTITUTES_MONEY' 	, width: 120, summaryType: 'sum'},
        	{dataIndex:'CASH_MONEY' 		, width: 120, summaryType: 'sum'},
        	{dataIndex:'FIRST_O' 			, width: 120, summaryType: 'sum', hidden: true},
        	{dataIndex:'BALANCE' 			, width: 120, summaryType: 'sum',tdCls:'x-change-cell2'},
        	{dataIndex:'SALE_BALANCE' 		, width: 120, summaryType: 'sum',tdCls:'x-change-cell2', hidden: true}
        	
//			{dataIndex:'DEPT_NAME' 			  				, width: 150, locked:true 
//			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//			        return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
//            }},
//			/*{dataIndex:'DEPT_NAME2' 			  			, width: 150, locked:true },*/
//			{dataIndex:'POS_NAME' 				  			, width: 120, locked:true },
//			{dataIndex:'SALE_AMT_O' 		  				, width: 120 , summaryType: 'sum'},
//			{dataIndex:'DIRECT_SALES' 		  				, width: 100 , summaryType: 'sum'},
//			{dataIndex:'DISCOUNT_P' 			  			, width: 120 , summaryType: 'sum'},
//			{dataIndex:'DIRECT_NET' 			  			, width: 120 , summaryType: 'sum'},
//			{dataIndex:'PRODUCTS_FEE1' 		  				, width: 120 , summaryType: 'sum'},
//			{dataIndex:'PRODUCTS1' 			  				, width: 120 , summaryType: 'sum'},
//			{dataIndex:'FIRST_MONEY' 		  				, width: 120 , summaryType: 'sum'},
//			{dataIndex:'CASH_MONEY' 			  			, width: 120 , summaryType: 'sum'},
//			{dataIndex:'CARD_MONEY' 			  			, width: 120 , summaryType: 'sum'},
//			{dataIndex:'CRDIT_MONEY' 		  				, width: 120 , summaryType: 'sum'},
//			{dataIndex:'TICKECT_MONEY' 		  				, width: 120 , summaryType: 'sum'},
//			{dataIndex:'SUBSTITUTES_MONEY' 	  				, width: 120 , summaryType: 'sum'},
//			{dataIndex:'BALANCE' 			  				, width: 120 , summaryType: 'sum'}

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
		id: 'sfa211skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelSearch.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_FR', UniDate.get('today'));
//			panelSearch.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR', UniDate.get('today'));
//			panelResult.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
	
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/sfa/sfa211rkrPrint.do',
	            prgID: 'sfa211rkr',
	               extParam: {
	
	                  DIV_CODE  	: param.DIV_CODE,
	                  DEPT_CODE 	: param.DEPT_CODE,
	                  SALE_DATE_FR  : param.SALE_DATE_FR,
	                  SALE_DATE_TO  : param.SALE_DATE_TO,
	                  DEPT_NAME		: param.DEPT_NAME
	               }
	            });
	            win.center();
	            win.show();
	               
	      },
		onDetailButtonDown:function() {
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
			UniAppManager.setToolbarButtons(['print'], false);
			this.fnInitBinding();
		}
	});
};
</script>
