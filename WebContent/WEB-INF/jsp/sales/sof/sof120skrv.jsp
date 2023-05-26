<%--
'   프로그램명 : 수주현황조회 (영업)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof120skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sof120skrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S148"/>  					<!-- 주문구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333; font-weight: normal; padding: 1px 2px;}
</style>
<script type="text/javascript" >
var faxWindow;
var emailWindow;
var gsCurRecord;

function appMain() {
	Unilite.defineModel('Sof120skrvModel', {
	    fields: [
			{name: 'ORDER_NUM'		 		, text:'<t:message code="system.label.sales.sono" default="수주번호"/>' 						, type:'string'},
			{name: 'ORDER_DATE'     			, text: '<t:message code="system.label.sales.sodate" default="수주일"/>'      				, type: 'uniDate'},
			{name: 'DVRY_DATE'     			, text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'      		, type: 'uniDate'},
			{name: 'CUSTOM_CODE'		 	, text:'<t:message code="system.label.sales.custom" default="거래처코드"/>'   			, type:'string'},
			{name: 'CUSTOM_NAME'			, text:'<t:message code="system.label.sales.customname" default="거래처"/>'			, type:'string'},
			{name: 'ITEM_NAME'		 		, text:'<t:message code="system.label.sales.itemname" default="품목명"/>' 				, type:'string'},
			{name: 'SALES_AMT_O'    			, text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'	, type: 'uniPrice'},
			{name: 'ORDER_TAX_O'			, text:'<t:message code="system.label.sales.vatamount" default="부가세액"/>'			, type: 'uniPrice'		, allowBlank: true 	, defaultValue: 0},
			{name: 'AMT_O'    						, text: '총액'						, type: 'uniPrice'},
			{name: 'COUNT_NO'    				, text: 'COUNT_NO'		, type: 'int'},
			{name: 'FAX_NO'	, text: 'FAX_NO'				, type: 'string'},
			{name: 'TO_EMAIL'	, text: 'TO_EMAIL'				, type: 'string'},
			{name: 'FROM_EMAIL'	, text: 'FROM_EMAIL'				, type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('sof120skrvMasterStore1', {
		model: 'Sof120skrvModel',
		uniOpt: {
           	isMaster: false,			// 상위 버튼,상태바 연결
           	editable: false,		// 수정 모드 사용
           	deletable:false,		// 삭제 가능 여부
            useNavi: false			// prev | next 버튼 사용
		},
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {
            	read: 'sof120skrvService.selectList1'
		    }
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			this.load({
				params: param
			});
		},
        listeners: {
            load: function(store, records, successful, eOpts) {
            	/* if(!Ext.isEmpty(records)){
            		Ext.getCmp('btnPrint1').enable();
                	Ext.getCmp('btnPrint2').enable();
            	} */
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {

            }
        }
	});

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				xtype: 'uniDateRangefield',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);

			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
		        xtype: 'uniDatefield',
		        name: 'DVRY_DATE',
		        value: UniDate.get('today'),
		        listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DVRY_DATE', newValue);
					}
				}
	        },Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				allowBlank: false,
				extParam: {'CUSTOM_TYPE':['1','3']},
				autoPopup: true,
				validateBlank	: true,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':['1','3']});
					}
				}
			}),{
				fieldLabel: '출력양식',
				name: 'DEAL_REPORT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'S148',
				allowBlank: false,
				value: '10',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DEAL_REPORT_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '출력일',
		        xtype: 'uniDatefield',
		        name: 'PRINT_DATE',
		        value: UniDate.get('today'),
		        listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('PRINT_DATE', newValue);
					}
				}
	        },{
		         	xtype:'button',
		         	text:'거래명세서출력',
		         	id: 'btnPrint1',
		         	width: 150,
 		         	margin : '0 0 0 95',
 		         	handler:function()	{
 		         		var param = new Object;
		  				  var selectedDetails = masterGrid.getSelectedRecords();
			  				param.PGM_ID = PGM_ID;
							param.MAIN_CODE = 'S036';
		                   	param["DIV_CODE"]= panelResult.getValue('DIV_CODE');
		                  	param["ORDER_DATE_FR"]= UniDate.getDateStr(panelResult.getValue('ORDER_DATE_FR'))
		                 	param["ORDER_DATE_TO"]= UniDate.getDateStr(panelResult.getValue('ORDER_DATE_TO'))
		                	param["CUSTOM_CODE"]= panelResult.getValue('CUSTOM_CODE');
		              		param["DEAL_REPORT_TYPE"]= panelResult.getValue('DEAL_REPORT_TYPE');
		              		param["PRINT_DATE"]= UniDate.getDateStr(panelResult.getValue('PRINT_DATE'));
		              		param["DVRY_DATE"]= UniDate.getDateStr(panelResult.getValue('DVRY_DATE'));
		                   	param.ORDER_NUM =  panelResult.getValue('ORDER_NUM');

		                   if(panelResult.getValue('DEAL_REPORT_TYPE') == '15'){
		  					var win = Ext.create('widget.ClipReport', {
		  						url: CPATH+'/sales/sof120clskrv_5.do',
		  						prgID: 'sof120skrv_5',
		  						extParam: param
		  						});
		  						win.center();
		  						win.show();
		  				}else{
		  					var win = Ext.create('widget.ClipReport', {
		  						url: CPATH+'/sales/sof120clskrv.do',
		  						prgID: 'sof120skrv',
		  						extParam: param
		  						});
		  						win.center();
		  						win.show();
		  				}
	         			}
	         },{
	             fieldLabel: 'ORDER_NUM',
	             xtype: 'uniTextfield',
	             name: 'ORDER_NUM',
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}
				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});

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
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
		        xtype: 'uniDatefield',
		        name: 'DVRY_DATE',
		        value: UniDate.get('today'),
		        colspan: 2,
		        listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('DVRY_DATE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				extParam: {'CUSTOM_TYPE':['1','3']},
				allowBlank: false,
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				autoPopup: true,
				validateBlank	: true,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':['1','3']});
					}
				}
			}),{
				fieldLabel: '출력양식',
				name: 'DEAL_REPORT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'S148',
				allowBlank: false,
				width: 315,
				value: '10',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('DEAL_REPORT_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '출력일',
		        xtype: 'uniDatefield',
		        name: 'PRINT_DATE',
		        value: UniDate.get('today'),
		        listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('PRINT_DATE', newValue);
					}
				}
	        },{
	             fieldLabel: 'ORDER_NUM',
	             xtype: 'uniTextfield',
	             name: 'ORDER_NUM',
	             hidden: true
	         },{
			    	xtype:'container',
			    	layout:{type:'uniTable',columns:3},
			    	items:[,{
	 		         	xtype:'button',
	 		         	text:'거래명세서출력',
	 		         	id: 'btnPrint2',
	 		         	margin: '0 0 4 10',
	 		    		handler:function()	{
	 		    			  var param = new Object;
	 		  				  var selectedDetails = masterGrid.getSelectedRecords();
		 		  				param.PGM_ID = PGM_ID;
		 						param.MAIN_CODE = 'S036';
	 		                   	param["DIV_CODE"]= panelResult.getValue('DIV_CODE');
	 		                  	param["ORDER_DATE_FR"]= UniDate.getDateStr(panelResult.getValue('ORDER_DATE_FR'))
	 		                 	param["ORDER_DATE_TO"]= UniDate.getDateStr(panelResult.getValue('ORDER_DATE_TO'))
	 		                	param["CUSTOM_CODE"]= panelResult.getValue('CUSTOM_CODE');
	 		              		param["DEAL_REPORT_TYPE"]= panelResult.getValue('DEAL_REPORT_TYPE');
	 		              		param["PRINT_DATE"]= UniDate.getDateStr(panelResult.getValue('PRINT_DATE'));
	 		              		param["DVRY_DATE"]= UniDate.getDateStr(panelResult.getValue('DVRY_DATE'))
	 		                   	param.ORDER_NUM =  panelResult.getValue('ORDER_NUM');

	 		                   if(panelResult.getValue('DEAL_REPORT_TYPE') == '15'){
		 		  					var win = Ext.create('widget.ClipReport', {
		 		  						url: CPATH+'/sales/sof120clskrv_5.do',
		 		  						prgID: 'sof120skrv_5',
		 		  						extParam: param
		 		  						});
		 		  						win.center();
		 		  						win.show();
	 		  				  }else{
		 		  					var win = Ext.create('widget.ClipReport', {
		 		  						url: CPATH+'/sales/sof120clskrv.do',
		 		  						prgID: 'sof120skrv',
		 		  						extParam: param
		 		  						});
		 		  						win.center();
		 		  						win.show();
	 		  				  }
		         		}
		      	   },{
						xtype	: 'button',
						id : 'btnSalesFax',
						text	: 'FAX',
						hidden: false,
						margin: '0 0 4 13',
						width	: 80,
						handler : function() {
							openFaxWindow();
						}
					 },{
						xtype	: 'button',
						id : 'btnSalesEmail',
						text	: 'E-MAIL',
						width	: 80,
						hidden: false,
						margin: '0 0 4 16',
						handler : function() {
							openEmailWindow();
						}
					 }]
				}
		]
    });

	/**
     * Master Grid1 정의(Grid Panel),
     * @type
     */
    var masterGrid = Unilite.createGrid('sof120skrvGrid1', {
    	layout: 'fit',
    	region:'center',
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                    if(Ext.isEmpty(panelResult.getValue('ORDER_NUM'))) {
                        panelResult.setValue('ORDER_NUM', selectRecord.get('ORDER_NUM'));
                    } else {
                        var orderNums = panelResult.getValue('ORDER_NUM');
                        orderNums = orderNums + ',' + selectRecord.get('ORDER_NUM');
                        panelResult.setValue('ORDER_NUM', orderNums);
                    }
                    if(Ext.isEmpty(panelResult.getValue('ORDER_NUM'))){
                    	Ext.getCmp('btnPrint1').disable();
            			Ext.getCmp('btnPrint2').disable();
            			Ext.getCmp('btnSalesFax').disable();
            			Ext.getCmp('btnSalesEmail').disable();
                    }else{
                    	Ext.getCmp('btnPrint1').enable();
            			Ext.getCmp('btnPrint2').enable();
            			Ext.getCmp('btnSalesFax').enable();
            			Ext.getCmp('btnSalesEmail').enable();
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                    var orderNums     = panelResult.getValue('ORDER_NUM');
                    var deselectedNum0  = selectRecord.get('ORDER_NUM') + ',';
                    var deselectedNum1  = ',' + selectRecord.get('ORDER_NUM');
                    var deselectedNum2  = selectRecord.get('ORDER_NUM');
                    orderNums = orderNums.split(deselectedNum0).join("");
                    orderNums = orderNums.split(deselectedNum1).join("");
                    orderNums = orderNums.split(deselectedNum2).join("");
                    panelResult.setValue('ORDER_NUM', orderNums);
                    if(Ext.isEmpty(panelResult.getValue('ORDER_NUM'))){
                    	Ext.getCmp('btnPrint1').disable();
            			Ext.getCmp('btnPrint2').disable();
            			Ext.getCmp('btnSalesFax').disable();
            			Ext.getCmp('btnSalesEmail').disable();
                    }else{
                    	Ext.getCmp('btnPrint1').enable();
            			Ext.getCmp('btnPrint2').enable();
            			Ext.getCmp('btnSalesFax').enable();
            			Ext.getCmp('btnSalesEmail').enable();
                    }
                }
            }
        }),
        uniOpt: {
        	expandLastColumn: true,
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useRowContext 		: true,
			onLoadSelectFirst: false,
            filter: {
                useFilter: false,
                autoCreate: false
            }

        },
    	store: directMasterStore,
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],

        columns: [
			{dataIndex: 'ORDER_NUM'			, width: 140,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
            }
			},
			{dataIndex: 'ORDER_DATE'			, width: 110},
			{dataIndex: 'DVRY_DATE'			, width: 110},
			{dataIndex: 'CUSTOM_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 180},
			{dataIndex: 'ITEM_NAME'		 		, width: 180},
			{dataIndex: 'SALES_AMT_O'    		, width: 130, summaryType: 'sum'},
			{dataIndex: 'ORDER_TAX_O'	 	, width: 130, summaryType: 'sum'},
			{dataIndex: 'AMT_O'    					, width: 130, summaryType: 'sum'},
			/* { text:'프로세스' , dataIndex:'service', width: 128,
 			   renderer:function(value,cellmeta){
 				   return "<input type='button'  style= 'background-color: #ececec; border-style: groove; border-color: #f1f1f1; width: 116px;' value='거래명세서 출력' >"
 				},
                	listeners:{
                   	click:function(val,metaDate,record,rowIndex,colIndex,store,view){
                 		var params = store;
							masterGrid.printBtn(params);
                    	}
 				}
            },
            {dataIndex: 'DEAL_REPORT_TYPE'    		, width: 120}, */
            {dataIndex: 'COUNT_NO'    		, width: 120 , hidden: true},
            {dataIndex: 'FAX_NO', width: 120, hidden: true},
            {dataIndex: 'TO_EMAIL', width: 120, hidden: true},
            {dataIndex: 'FROM_EMAIL', width: 120, hidden: true}
		],
		 listeners: {
	        	beforeedit: function( editor, e, eOpts ) {
					/* if(!e.record.phantom) {
						if(UniUtils.indexOf(e.field, ['DEAL_REPORT_TYPE']))
						{
							return true;
		  				} else {
		  					return false;
		  				}
					} else {
						if(UniUtils.indexOf(e.field, ['DEAL_REPORT_TYPE']))
					   	{
							return true;
		  				} else {
		  					return false;
		  				}
					} */
				},cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
					//beforeRowIndex = rowIndex;
				}
			 }/* ,
        printBtn:function(record){
				var param= record.data;
				if(record.data.DEAL_REPORT_TYPE == '15'){
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/sales/sof120clskrv_5.do',
						prgID: 'sof120skrv_5',
						extParam: param
						});
						win.center();
						win.show();
				}else{
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/sales/sof120clskrv.do',
						prgID: 'sof120skrv',
						extParam: param
						});
						win.center();
						win.show();
				}
        }  */
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
		id: 'sof120skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));
			panelSearch.setValue('DEAL_REPORT_TYPE',10);
			panelSearch.setValue('ORDER_NUM','');
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));
			panelResult.setValue('DEAL_REPORT_TYPE',10);
			panelResult.setValue('ORDER_NUM','');
			Ext.getCmp('btnPrint1').disable();
			Ext.getCmp('btnPrint2').disable();
			Ext.getCmp('btnSalesFax').disable();
			Ext.getCmp('btnSalesEmail').disable();

		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		}
	});

    //fax전송 창
    function openFaxWindow() {
  		//if(!UniAppManager.app.checkForNewDetail()) return false;
	   if(!faxWindow) {
			faxWindow = Ext.create('widget.uniDetailWindow', {
                title: 'FAX',
                width: 370,
                height: 182,
                resizable:false,
                layout:{type:'vbox', align:'stretch'},
                items: [faxSearch],
                listeners : {beforehide: function(me, eOpt)	{
                					faxSearch.clearForm();
                				},
                			 	beforeclose: function( panel, eOpts )	{
                			 		faxSearch.clearForm();
                			 	},
                			 	beforeshow: function ( me, eOpts )	{
                			 		var amtO = 0;
                			 		var records = masterGrid.getSelectedRecords();
                			 		Ext.each(records, function(record,i) {
                			 			if(i==0){
                			 				faxSearch.setValue('FAX_NO', record.get('FAX_NO'));
                			 			}
                			 			amtO = amtO + record.get('AMT_O');
                			 		});
                			 		faxSearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
                			 		faxSearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
                			 		faxSearch.setValue('TXT_AMOUNT', amtO);
                			 	}
                }
			})
		}
		faxWindow.center();
		faxWindow.show();
    }
  //fax전송 폼
	 var faxSearch = Unilite.createSearchForm('faxForm', {

		layout :  {type : 'uniTable', columns : 1},
		items :[Unilite.popup('AGENT_CUST', {
					fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName: 'CUSTOM_CODE',
					textFieldName: 'CUSTOM_NAME',
					extParam: {'CUSTOM_TYPE':['1','3']},
					allowBlank: false,
					validateBlank	: true,
					readOnly: true,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								faxSearch.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								faxSearch.setValue('CUSTOM_CODE', '');
							}
						}
					}
				}),{
	    				fieldLabel: '<t:message code="system.label.sales.amount" default="금액"/>',
	    				name: 'TXT_AMOUNT',
	    				xtype:'uniNumberfield',
	    				decimalPrecision: 0,
	    				value: 1,
	    				hidden:false,
	    				readOnly:true,
	                    listeners: {
	                        change: function(field, newValue, oldValue, eOpts) {

	                        }
	                    }
	    			},{
	    				fieldLabel: '<t:message code="system.label.sales.salesreceivesubject" default="받을대상"/>',
	    				xtype: 'uniTextfield',
	    				name: 'SEND_TO',
	    				allowBlank: false,
	    				holdable: 'hold'
	    			},{
	    				fieldLabel: '<t:message code="system.label.sales.faxno" default="팩스번호"/>',
	    				xtype: 'uniTextfield',
	    				name: 'FAX_NO',
	    				allowBlank: false,
	    				holdable: 'hold'
	    			},{
				    	xtype:'container',
				    	defaultType:'uniTextfield',
				    	layout:{type:'hbox', align:'middle', pack: 'center' },
				    	items:[{
									xtype	: 'button',
									name	: 'btnSendFax',
									text	: '전송',
									width	: 50,
									hidden: false,
									handler : function() {
										   if(!faxSearch.getInvalidMessage()) return;   //필수체크
										   var param = faxSearch.getValues();
					 		                    param["PGM_ID"]= PGM_ID;
					 		                    param.MAIN_CODE = 'S036';
					 		                   	param["DIV_CODE"]= panelResult.getValue('DIV_CODE');
					 		                  	param["ORDER_DATE_FR"]= UniDate.getDateStr(panelResult.getValue('ORDER_DATE_FR'))
					 		                 	param["ORDER_DATE_TO"]= UniDate.getDateStr(panelResult.getValue('ORDER_DATE_TO'))
					 		                	param["CUSTOM_CODE"]= panelResult.getValue('CUSTOM_CODE');
					 		              		param["DEAL_REPORT_TYPE"]= panelResult.getValue('DEAL_REPORT_TYPE');
					 		              		param["PRINT_DATE"]= UniDate.getDateStr(panelResult.getValue('PRINT_DATE'));
					 		              		param["DVRY_DATE"]= UniDate.getDateStr(panelResult.getValue('DVRY_DATE'))
					 		                   	param.ORDER_NUM =  panelResult.getValue('ORDER_NUM');

					 		              	  if(panelResult.getValue('DEAL_REPORT_TYPE') == '15'){
					 		              		 Ext.Ajax.request({
								    				    url     : CPATH+'/sales/sof120clskrv_5_fax.do',
								    				    params  : param,
								    				    async   : false,
								    				    success : function(response){
															if(!Ext.isEmpty(response)){
																Unilite.messageBox('전송되었습니다.');
															}
								    				    },
								    				    callback: function()	{
								    				    	Ext.getBody().unmask();
								    				    }
								    				});
					 		              	  }else{
					 		              		 Ext.Ajax.request({
								    				    url     : CPATH+'/sales/sof120clskrv_fax.do',
								    				    params  : param,
								    				    async   : false,
								    				    success : function(response){
															if(!Ext.isEmpty(response)){
																Unilite.messageBox('전송되었습니다.');
															}
								    				    },
								    				    callback: function()	{
								    				    	Ext.getBody().unmask();
								    				    }
								    				});
					 		              	  }

										faxWindow.hide();
										faxWindow = '';
									}
						    	},
								{
									xtype	: 'button',
									name	: 'btnCancel',
									text	: '취소',
									width	: 50,
									hidden: false,
									handler : function() {
										faxWindow.hide();
										faxWindow = '';
								}
							}]
					},{
				    	xtype:'container',
				    	height:2
					}]

	 });

	 //email전송 창
	    function openEmailWindow() {
	  		//if(!UniAppManager.app.checkForNewDetail()) return false;
		   if(!emailWindow) {
			   emailWindow = Ext.create('widget.uniDetailWindow', {
	                title: 'E-MAIL',
	                width: 370,
	                height: 512,
	                resizable:false,
	                layout:{type:'vbox', align:'stretch'},
	                items: [emailSearch],
	                listeners : {beforehide: function(me, eOpt)	{
	                					emailSearch.clearForm();
	                				},
	                			 	beforeclose: function( panel, eOpts )	{
	                			 		emailSearch.clearForm();
	                			 	},
	                			 	beforeshow: function ( me, eOpts )	{
	                			 		var amtO = 0;
	                			 		var records = masterGrid.getSelectedRecords();
	                			 		Ext.each(records, function(record,i) {
	                			 			if(i==0){
	                			 				emailSearch.setValue('TO_EMAIL', record.get('TO_EMAIL'));
	                			 				emailSearch.setValue('FROM_EMAIL', record.get('FROM_EMAIL'));
	                			 			}
	                			 			amtO = amtO + record.get('AMT_O');
	                			 		});
	                			 		emailSearch.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
	                			 		emailSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
	                			 		emailSearch.setValue('TXT_AMOUNT', amtO);

	                			 	}
	                }
				})
			}
			emailWindow.center();
			emailWindow.show();
	    }

	  //email전송 폼
		 var emailSearch = Unilite.createSearchForm('emailForm', {

			layout :  {type : 'uniTable', columns : 1},
			items :[Unilite.popup('AGENT_CUST', {
						fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
						valueFieldName: 'CUSTOM_CODE',
						textFieldName: 'CUSTOM_NAME',
						labelWidth: 50,
						valueFieldWidth: 90,
						textFieldWidth: 180,
						extParam: {'CUSTOM_TYPE':['1','3']},
						allowBlank: false,
						validateBlank	: true,
						readOnly: true,
						listeners: {
							onValueFieldChange: function(field, newValue, oldValue){
								if(!Ext.isObject(oldValue)) {
									emailSearch.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){
								if(!Ext.isObject(oldValue)) {
									emailSearch.setValue('CUSTOM_CODE', '');
								}
							}
						}
					}),{
		    				fieldLabel: '<t:message code="system.label.sales.amount" default="금액"/>',
		    				name: 'TXT_AMOUNT',
		    				labelWidth: 50,
		    				width: 325,
		    				xtype:'uniNumberfield',
		    				decimalPrecision: 0,
		    				value: 1,
		    				hidden:false,
		    				readOnly:true,
		                    listeners: {
		                        change: function(field, newValue, oldValue, eOpts) {

		                        }
		                    }
		    			},{
		    				fieldLabel: '<t:message code="system.label.sales.receiver" default="수신자"/>',
		    				xtype: 'uniTextfield',
		    				name: 'TO_EMAIL',
		    				labelWidth: 50,
		    				width: 325,
		    				allowBlank: false,
		    				holdable: 'hold'
		    			},{
		    				fieldLabel: '<t:message code="system.label.sales.sender" default="발신자"/>',
		    				xtype: 'uniTextfield',
		    				name: 'FROM_EMAIL',
		    				labelWidth: 50,
		    				width: 325,
		    				allowBlank: false,
		    				holdable: 'hold'
		    			},{
		    				fieldLabel: '<t:message code="system.label.sales.title" default="제목"/>',
		    				xtype: 'uniTextfield',
		    				name: 'TITLE',
		    				labelWidth: 50,
		    				width: 325,
		    				allowBlank: false,
		    				holdable: 'hold'
		    			},{
		    				fieldLabel: '<t:message code="system.label.sales.content" default="내용"/>',
		    				xtype: 'textarea',
		    				labelWidth: 50,
		    				name: 'TEXT',
		    				width: 325,
		    				height: 300,
		    				allowBlank: false,
		    				holdable: 'hold'
		    			},{
					    	xtype:'container',
					    	defaultType:'uniTextfield',
					    	padding: '0 0 0 20',
					    	layout:{type:'hbox', align:'middle', pack: 'center' },
					    	items:[{
										xtype	: 'button',
										name	: 'btnEmail',
										text	: '전송',
										width	: 60,
										hidden: false,
										handler : function() {
											 if(!emailSearch.getInvalidMessage()) return;   //필수체크
												  var  param = emailSearch.getValues();
												    param["PGM_ID"]= PGM_ID;
												    param.MAIN_CODE = 'S036';
						 		                   	param["DIV_CODE"]= panelResult.getValue('DIV_CODE');
						 		                  	param["ORDER_DATE_FR"]= UniDate.getDateStr(panelResult.getValue('ORDER_DATE_FR'))
						 		                 	param["ORDER_DATE_TO"]= UniDate.getDateStr(panelResult.getValue('ORDER_DATE_TO'))
						 		                	param["CUSTOM_CODE"]= panelResult.getValue('CUSTOM_CODE');
						 		              		param["DEAL_REPORT_TYPE"]= panelResult.getValue('DEAL_REPORT_TYPE');
						 		              		param["PRINT_DATE"]= UniDate.getDateStr(panelResult.getValue('PRINT_DATE'));
						 		              		param["DVRY_DATE"]= UniDate.getDateStr(panelResult.getValue('DVRY_DATE'))
						 		                   	param.ORDER_NUM =  panelResult.getValue('ORDER_NUM');

						 		              	  if(panelResult.getValue('DEAL_REPORT_TYPE') == '15'){
						 		              		 Ext.Ajax.request({
									    				    url     : CPATH+'/sales/sof120clskrv_5_email.do',
									    				    params  : param,
									    				    async   : false,
									    				    success : function(response){
																if(!Ext.isEmpty(response)){
																	Unilite.messageBox('전송되었습니다.');
																}
									    				    },
									    				    callback: function()	{
									    				    	Ext.getBody().unmask();
									    				    }
									    				});
						 		              	  }else{
						 		              		 Ext.Ajax.request({
									    				    url     : CPATH+'/sales/sof120clskrv_email.do',
									    				    params  : param,
									    				    async   : false,
									    				    success : function(response){
																if(!Ext.isEmpty(response)){
																	Unilite.messageBox('전송되었습니다.');
																}
									    				    },
									    				    callback: function()	{
									    				    	Ext.getBody().unmask();
									    				    }
									    				});
						 		              	  }

						 		              	emailWindow.hide();
						 		              	emailWindow = '';
										}
							    	},
									{
										xtype	: 'button',
										name	: 'btnCancel',
										text	: '취소',
										width	: 60,
										hidden: false,
										handler : function() {
											emailWindow.hide();
											emailWindow = '';
									}
								}]
						},{
					    	xtype:'container',
					    	height:2
						}]

	 	 });
};
</script>
