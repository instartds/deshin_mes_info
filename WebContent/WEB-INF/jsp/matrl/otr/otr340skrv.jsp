<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="otr340skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	/**
	 * Model 정의
	 */
	Unilite.defineModel('Otr340skrvModel', {
	    fields: [
	    	{name: 'CUSTOM_CODE'			,text:'<t:message code="system.label.purchase.subcontractorcode" default="외주처코드"/>'		,type:'string'},
	    	{name: 'CUSTOM_NAME'			,text:'<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>'		,type:'string'},
	    	{name: 'INOUT_DATE'			    ,text:'<t:message code="system.label.purchase.issuedate" default="출고일"/>'				,type:'uniDate'},
	    	{name: 'ITEM_CODE'				,text:'<t:message code="system.label.purchase.receipthalffinished" default="입고반제품"/>'	,type:'string'},
	    	{name: 'ITEM_NAME'				,text:'<t:message code="system.label.purchase.receipthalffinished" default="입고반제품"/>'	,type:'string'},
	    	{name: 'MATR_ITEM_CODE'		    ,text:'<t:message code="system.label.purchase.materialitemcode" default="자재 품목코드"/>'	,type:'string'},
	    	{name: 'MATR_ITEM_NAME'		    ,text:'<t:message code="system.label.purchase.materialitem" default="자재 품명"/>'			,type:'string'},
	    	{name: 'INOUT_Q'				,text:'<t:message code="system.label.purchase.prdissuedqty" default="생산출고량"/>'			,type:'uniQty'},
	    	{name: 'INOUT_P'				,text:'<t:message code="system.label.purchase.price" default="단가"/>'					,type:'uniUnitPrice'},
	    	{name: 'INOUT_I'				,text:'<t:message code="system.label.purchase.amount" default="금액"/>'					,type: 'float', decimalPrecision: 1, format: '0,000,000'},
	    	{name: 'INOUT_NUM'				,text:'<t:message code="system.label.purchase.tranno" default="수불번호"/>'					,type:'string'},
	    	{name: 'INOUT_SEQ'              ,text:'<t:message code="system.label.purchase.seq" default="순번"/>'						,type:'integer'}
		]
	});


	/**
	 * Store 정의(Service 정의)
	 */
	var directMasterStore1 = Unilite.createStore('otr340skrvMasterStore1',{
			model: 'Otr340skrvModel',
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
                    read: 'otr340skrvService.selectList'
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				this.load({
					params : param
				});
			},
			listeners:{
				load:function( store, records, successful, operation, eOpts ) {
					if(records && records.length > 0){
						masterGrid.setShowSummaryRow(true);
					}
				}
			}
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
	        	allowBlank: true,
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
				                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				            	}
					}
			}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_CODE', newValue);
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME', newValue);
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE', '');
								}
							},
						applyextparam: function(popup){	// 2021.08 표준화 작업
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}), {
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.purchase.sssss" default=" "/>',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width: 60,
					name: 'CREATE_LOC',
					inputValue: 'A'
				},{
					boxLabel: '<t:message code="system.label.purchase.prdissuedqty" default="생산출고"/>',
					width: 80,
					name: 'CREATE_LOC',
					inputValue: 'P',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.purchase.subcounting" default="외주실사"/>',
					width: 80,
					name: 'CREATE_LOC',
					inputValue: 'C'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('CREATE_LOC').setValue(newValue.CREATE_LOC);
					}
				}

			}
			]
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
	});

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
	        	allowBlank: true,
	        	width: 315,
	        	colspan: 3,
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
				                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				            	}
					}
			}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_CODE', newValue);
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME', newValue);
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE', '');
								}
							},
						applyextparam: function(popup){	// 2021.08 표준화 작업
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}), {
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.purchase.sssss" default=" "/>',
				colspan: 2,
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width: 60,
					name: 'CREATE_LOC',
					inputValue: 'A'
				},{
					boxLabel: '<t:message code="system.label.purchase.prdissuedqty" default="생산출고"/>',
					width: 80,
					name: 'CREATE_LOC',
					inputValue: 'P',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.purchase.subcounting" default="외주실사"/>',
					width: 80,
					name: 'CREATE_LOC',
					inputValue: 'C'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('CREATE_LOC').setValue(newValue.CREATE_LOC);
					}
				}

			}
			]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     */
    var masterGrid = Unilite.createGrid('otr340skrvGrid1', {
    	store: directMasterStore1,
        layout : 'fit',
        region:'center',
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
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: false
		}],
        columns:  [
        	{ dataIndex: 'CUSTOM_CODE',   		width:100},
        	{ dataIndex: 'CUSTOM_NAME',   		width:200},
        	{ dataIndex: 'INOUT_DATE',   		width:130,
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.total" default="총계"/>');
                }        	},
        	{ dataIndex: 'ITEM_CODE',   		width:100, 		hidden: true},
        	{ dataIndex: 'ITEM_NAME',   		width:220},
        	{ dataIndex: 'MATR_ITEM_CODE',   	width:120},
        	{ dataIndex: 'MATR_ITEM_NAME',   	width:220},
        	{ dataIndex: 'INOUT_Q',   			width:110,	summaryType:'sum',
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '', '<div style="text-align:right">'+Ext.util.Format.number(value, '9,990.00')+'</div>');
                }
        	},
        	{ dataIndex: 'INOUT_P',   			width:130},
        	{ dataIndex: 'INOUT_I',   			width:150, align:'right',	summaryType:'sum',
        		 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '', '<div style="text-align:right">'+Ext.util.Format.number(value, '9,990')+'</div>');
                }
            },
        	{ dataIndex: 'INOUT_NUM',  	 		width:120},
        	{ dataIndex: 'INOUT_SEQ',   		width:70, 		align:'center'}

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
		id  : 'otr340skrvApp',
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
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();

		},
        onResetButtonDown:function() {
        	panelSearch.clearForm();
        	panelResult.clearForm();
        	masterGrid.reset();
        	masterGrid.getStore().clearData();
        	UniAppManager.app.fnInitBinding();
        }
	});
};
</script>