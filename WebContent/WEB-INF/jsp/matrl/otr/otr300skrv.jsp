<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="otr300skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	/**
	 * Model 정의
	 */
	Unilite.defineModel('Otr300skrvModel', {
	    fields: [
	    	{name: 'ITEM_CODE',				text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>',	type:'string'},
	    	{name: 'ITEM_NAME',				text:'<t:message code="system.label.purchase.itemname" default="품목명"/>'	,	type:'string'},
	    	{name: 'SPEC',					text:'<t:message code="system.label.purchase.spec" default="규격"/>',		type:'string'},
	    	{name: 'INOUT_DATE',			text:'<t:message code="system.label.purchase.issuedate" default="출고일"/>',		type:'uniDate'},
	    	{name: 'INOUT_CODE_TYPE',		text:'<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',	type:'string'},
	    	{name: 'INOUT_CODE',			text:'<t:message code="system.label.purchase.issueplace" default="출고처"/>',		type:'string'},
	    	{name: 'CUSTOM_CODE',			text:'<t:message code="system.label.purchase.custom" default="거래처"/>',	    type:'string'},
	    	{name: 'CUSTOM_NAME',			text:'<t:message code="system.label.purchase.customname" default="거래처명"/>',	type:'string'},
	    	{name: 'INOUT_Q',				text:'<t:message code="system.label.purchase.issueqty" default="출고량"/>',		type:'uniQty'},
	    	{name: 'STOCK_UNIT',			text:'<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>',	type:'string'},
	    	{name: 'WH_CODE',				text:'<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',	type:'string'},
	    	{name: 'INOUT_PRSN',			text:'<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',	type:'string'},
	    	{name: 'INOUT_METH',			text:'<t:message code="system.label.purchase.issuemethod" default="출고방법"/>',	type:'string'},
	    	{name: 'INOUT_TYPE_DETAIL',		text:'<t:message code="system.label.purchase.issuetype" default="출고유형"/>',	type:'string'},
	    	{name: 'INOUT_NUM',				text:'<t:message code="system.label.purchase.issueno" default="출고번호"/>',	type:'string'},
	    	{name: 'DIV_CODE',				text:'<t:message code="system.label.purchase.division" default="사업장"/>',		type:'string'},
	    	{name: 'INOUT_I',				text:'<t:message code="system.label.purchase.amount" default="금액"/>',		type:'uniPrice'},
	    	{name: 'REMARK',				text:'<t:message code="system.label.purchase.remarks" default="비고"/>',		type:'string'},
	    	{name: 'PROJECT_NO',			text:'<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',	type:'string'},
	    	{name: 'ORDER_NUM',             text:'<t:message code="system.label.purchase.pono" default="발주번호"/>',    type:'string'},
	    	{name: 'ORDER_SEQ',             text:'<t:message code="system.label.purchase.poseq" default="발주순번"/>',    type:'int'}
		]
	});

	Unilite.defineModel('Otr300skrvModel2', {
	    fields: [
	    	{name: 'CUSTOM_CODE',			text:'<t:message code="system.label.purchase.custom" default="거래처"/>',	    type:'string'},
	    	{name: 'CUSTOM_NAME',			text:'<t:message code="system.label.purchase.customname" default="거래처명"/>',	type:'string'},
	    	{name: 'ITEM_CODE',				text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>',	type:'string'},
	    	{name: 'ITEM_NAME',				text:'<t:message code="system.label.purchase.itemname" default="품목명"/>'	,	type:'string'},
	    	{name: 'SPEC',					text:'<t:message code="system.label.purchase.spec" default="규격"/>',		type:'string'},
	    	{name: 'INOUT_DATE',			text:'<t:message code="system.label.purchase.issuedate" default="출고일"/>',		type:'uniDate'},
	    	{name: 'INOUT_CODE_TYPE',		text:'<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',	type:'string'},
	    	{name: 'INOUT_CODE',			text:'<t:message code="system.label.purchase.issueplace" default="출고처"/>',		type:'string'},
	    	{name: 'INOUT_Q',				text:'<t:message code="system.label.purchase.issueqty" default="출고량"/>',		type:'uniQty'},
	    	{name: 'STOCK_UNIT',			text:'<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>',	type:'string'},
	    	{name: 'WH_CODE',				text:'<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',	type:'string'},
	    	{name: 'INOUT_PRSN',			text:'<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',	type:'string'},
	    	{name: 'INOUT_METH',			text:'<t:message code="system.label.purchase.issuemethod" default="출고방법"/>',	type:'string'},
	    	{name: 'INOUT_TYPE_DETAIL',		text:'<t:message code="system.label.purchase.issuetype" default="출고유형"/>',	type:'string'},
	    	{name: 'INOUT_NUM',				text:'<t:message code="system.label.purchase.issueno" default="출고번호"/>',	type:'string'},
	    	{name: 'DIV_CODE',				text:'<t:message code="system.label.purchase.division" default="사업장"/>',		type:'string'},
	    	{name: 'INOUT_I',				text:'<t:message code="system.label.purchase.amount" default="금액"/>',		type:'uniPrice'},
	    	{name: 'REMARK',				text:'<t:message code="system.label.purchase.remarks" default="비고"/>',		type:'string'},
	    	{name: 'PROJECT_NO',			text:'<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',	type:'string'},
	    	{name: 'ORDER_NUM',             text:'<t:message code="system.label.purchase.pono" default="발주번호"/>',    type:'string'},
            {name: 'ORDER_SEQ',             text:'<t:message code="system.label.purchase.poseq" default="발주순번"/>',    type:'int'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 */
	var directMasterStore1 = Unilite.createStore('otr300skrvMasterStore1',{
			model: 'Otr300skrvModel',
			uniOpt : {
            	isMaster : true,			// 상위 버튼 연결
            	editable : false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi  : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                    read: 'otr300skrvService.selectList'
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				this.load({
					params : param
				});
			},
			groupField: 'ITEM_CODE'
	});

	var directMasterStore2 = Unilite.createStore('otr300skrvMasterStore2',{
			model: 'Otr300skrvModel2',
			uniOpt : {
            	isMaster : true,			// 상위 버튼 연결
            	editable : false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi  : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                    read: 'otr300skrvService.selectList2'
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				this.load({
					params : param
				});
			},
			groupField: 'CUSTOM_NAME'
	});

	/**
	 * 검색조건 (Search Panel)
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        width:380,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{
			title : '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
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
	        },{
	        	fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'FR_INOUT_DATE',
	        	endFieldName: 'TO_INOUT_DATE',
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	allowBlank: false,
	        	width: 315,
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_INOUT_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_INOUT_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name: 'INOUT_PRSN' ,
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				}
			},{	//202002118 추가: 조회조건 "발주번호" 추가
				fieldLabel	: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
				name		: 'ORDER_NUM',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM', newValue);
					}
				}
			}]
		},{
			title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
	            fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
	            name: 'WH_CODE',
	            xtype: 'uniCombobox',
	            store: Ext.data.StoreManager.lookup('whList')
         	},
	        Unilite.popup('CUST',{
				fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
				textFieldWidth: 170,
				valueFieldName: 'INOUT_CODE',
				textFieldName: 'INOUT_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('INOUT_CODE', newValue);
								panelResult.setValue('INOUT_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('INOUT_NAME', '');
									panelResult.setValue('INOUT_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('INOUT_NAME', newValue);
								panelResult.setValue('INOUT_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('INOUT_CODE', '');
									panelResult.setValue('INOUT_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				            	}
					}
			}),
	        {
            	fieldLabel: '<t:message code="system.label.purchase.issuetype" default="출고유형"/>',
            	name: 'INOUT_TYPE_DETAIL',
            	xtype: 'uniCombobox',
            	comboType: 'AU',
            	comboCode: 'M104'
	        },{
            	fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
            	name: 'ITEM_ACCOUNT',
            	xtype: 'uniCombobox',
            	comboType:'AU',
            	comboCode:'B020'
	        },
	            Unilite.popup('DIV_PUMOK',{
	            	fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
	            	textFieldWidth: 170,
	            	valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
	            	extParam: {'CUSTOM_TYPE':'3'},
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_CODE', '');
									}
								},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
	            })]
			}],
		    setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {return !field.validate();});
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
					}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
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
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
	        },{
	        	fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'FR_INOUT_DATE',
	        	endFieldName: 'TO_INOUT_DATE',
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	allowBlank: false,
	        	width: 315,
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_INOUT_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_INOUT_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name: 'INOUT_PRSN' ,
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INOUT_PRSN', newValue);
					}
				}
			},
			Unilite.popup('CUST',{
				fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
				textFieldWidth: 170,
				valueFieldName: 'INOUT_CODE',
				textFieldName: 'INOUT_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('INOUT_CODE', newValue);
								panelResult.setValue('INOUT_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('INOUT_NAME', '');
									panelResult.setValue('INOUT_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('INOUT_NAME', newValue);
								panelResult.setValue('INOUT_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('INOUT_CODE', '');
									panelResult.setValue('INOUT_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				            	}
					}
			}),{//202002118 추가: 조회조건 "발주번호" 추가
				fieldLabel	: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
				name		: 'ORDER_NUM',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_NUM', newValue);
					}
				}
			}]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     */
    var masterGrid = Unilite.createGrid('otr300skrvGrid1', {
        layout : 'fit',
        region:'center',
        title: '<t:message code="system.label.purchase.itemby" default="품목별"/>',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel    : true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData    : false,
				summaryExport : true
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
        columns:  [
        	{ dataIndex: 'ITEM_CODE',   		width:120, 		locked : true,
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.itemsubtotal" default="품목소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
                }
        	},
        	{ dataIndex: 'ITEM_NAME',   		width:180, 		locked : true},
        	{ dataIndex: 'SPEC',   				width:146},
        	{ dataIndex: 'INOUT_DATE',   		width:86},
        	{ dataIndex: 'INOUT_CODE_TYPE',   	width:86},
        	{ dataIndex: 'INOUT_CODE',   		width:66, 		hidden : true},
        	{ dataIndex: 'CUSTOM_NAME',   		width:133},
        	{ dataIndex: 'INOUT_Q',   			width:120,summaryType:'sum'},
        	{ dataIndex: 'STOCK_UNIT',   		width:66},
        	{ dataIndex: 'WH_CODE',   			width:106},
        	{ dataIndex: 'INOUT_PRSN',  	 	width:66},
        	{ dataIndex: 'INOUT_METH',   		width:66},
        	{ dataIndex: 'INOUT_TYPE_DETAIL',   width:66},
        	{ dataIndex: 'INOUT_NUM',   		width:130},
        	{ dataIndex: 'DIV_CODE',   			width:106, 		hidden : true},
        	{ dataIndex: 'INOUT_I',   			width:66, 		hidden : true},
        	{ dataIndex: 'REMARK',   			width:133},
        	{ dataIndex: 'PROJECT_NO',   		width:133},
        	{ dataIndex: 'ORDER_NUM',           width:133,       hidden : true},
        	{ dataIndex: 'ORDER_SEQ',           width:133,       hidden : true}
          ]
    });

    var masterGrid2 = Unilite.createGrid('otr300skrvGrid2', {
        layout : 'fit',
        region : 'center',
        title: '<t:message code="system.label.purchase.customby" default="거래처별"/>',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel    : true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData    : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow:  true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
    	store: directMasterStore2,
        columns:  [
        	{ dataIndex: 'INOUT_TYPE_DETAIL',   width:66 , locked : true,
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.customsubtotal" default="거래처소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
                }
        	},
        	{ dataIndex: 'CUSTOM_NAME',   		width:133, locked : true},
        	{ dataIndex: 'INOUT_DATE',   		width:86},
        	{ dataIndex: 'INOUT_CODE_TYPE',   	width:86},
        	{ dataIndex: 'INOUT_CODE',   		width:66,  hidden : true},
        	{ dataIndex: 'ITEM_CODE',   		width:120},
        	{ dataIndex: 'ITEM_NAME',   		width:180},
        	{ dataIndex: 'SPEC',   				width:146},
        	{ dataIndex: 'INOUT_Q',   			width:120,summaryType:'sum'},
        	{ dataIndex: 'STOCK_UNIT',   		width:66},
        	{ dataIndex: 'WH_CODE',   			width:106},
        	{ dataIndex: 'INOUT_PRSN',  	 	width:66},
        	{ dataIndex: 'INOUT_METH',   		width:66},
        	{ dataIndex: 'INOUT_NUM',   		width:130},
        	{ dataIndex: 'DIV_CODE',   			width:106, 		hidden : true},
        	{ dataIndex: 'INOUT_I',   			width:66, 		hidden : true},
        	{ dataIndex: 'REMARK',   			width:133},
        	{ dataIndex: 'PROJECT_NO',   		width:133},
        	{ dataIndex: 'ORDER_NUM',           width:133,       hidden : true},
            { dataIndex: 'ORDER_SEQ',           width:133,       hidden : true}
          ]
    });

    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid, masterGrid2
	    ],
	    listeners:  {
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
				switch(newCard.getId()) {
					case 'otr300skrvGrid1':
						break;
					case 'otr300skrvGrid2':
						break;
					default:
						break;
				}
	     	}
	     }
	});

    Unilite.Main( {
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
		id  : 'otr300skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_INOUT_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_INOUT_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_INOUT_DATE',UniDate.get('today'));
			panelResult.setValue('TO_INOUT_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'otr300skrvGrid1'){
				if(!UniAppManager.app.checkForNewDetail()){
				   return false;
			    }else{
			        masterGrid.getStore().loadStoreRecords();
			        var viewLocked = masterGrid.lockedGrid.getView();
			        var viewNormal = masterGrid.normalGrid.getView();
		            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			        UniAppManager.setToolbarButtons('excel',true);
			    }
			}else if(activeTabId == 'otr300skrvGrid2'){
				if(!UniAppManager.app.checkForNewDetail()){
				   return false;
			    }else{
			        masterGrid2.getStore().loadStoreRecords();
			        var viewLocked = masterGrid2.lockedGrid.getView();
			        var viewNormal = masterGrid2.normalGrid.getView();
		            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			        UniAppManager.setToolbarButtons('excel',true);
			    }
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        },
        onResetButtonDown:function() {
        	panelSearch.clearForm();
        	panelResult.clearForm();
        	masterGrid.reset();
        	masterGrid2.reset();
        	masterGrid.getStore().clearData();
        	masterGrid2.getStore().clearData();
        	UniAppManager.app.fnInitBinding();
        }
	});
};
</script>