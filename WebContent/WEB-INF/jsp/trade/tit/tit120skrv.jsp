<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tit120skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="tit120skrv" /> 				<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}'
};
function appMain() {

	Unilite.defineModel('tit120skrvModel', {
	    fields: [
	    	{name: 'PASS_SER_NO'		, text: '통관관리번호'  , type: 'string'},
	    	{name: 'INVOICE_NO'			, text: '송장번호'	, type: 'string'},
	    	{name: 'ED_DATE'			, text: '<t:message code="system.label.trade.reportdate" default="신고일"/>'	, type: 'uniDate'},
	    	{name: 'INVOICE_DATE'		, text: '통관일'	, type: 'uniDate'},
            {name: 'ED_NO'				, text: '<t:message code="system.label.trade.reportno" default="신고번호"/>'	, type: 'string'}, 
			{name: 'BL_NO'				, text: 'BL NO'	, type: 'string'},
	    	{name: 'EXPORTER'			, text: '수출자코드', type: 'string'},
            {name: 'EXPORTER_NM'		, text: '<t:message code="system.label.trade.exporter" default="수출자"/>'	, type: 'string'},
	    	{name: 'PASS_AMT_UNIT'		, text: '<t:message code="system.label.trade.currency" default="화폐 "/>'		, type: 'string'},
	    	{name: 'PASS_AMT'			, text: '통관액'	, type: 'uniPrice'},
	    	{name: 'PASS_EXCHANGE_RATE'	, text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'		, type: 'uniER'},
	    	{name: 'PASS_AMT_WON'       , text: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>'	, type: 'uniPrice'},
	    	{name: 'DEST_PORT_NM'       , text: '<t:message code="system.label.trade.arrivalport" default="도착항"/>'	, type: 'string'},
	    	{name: 'SHIP_PORT_NM'       , text: '<t:message code="system.label.trade.shipmentport" default="선적항"/>'	, type: 'string'},
	    	{name: 'SHIP_FIN_DATE'      , text: '<t:message code="system.label.trade.shipmentdate" default="선적일"/>'	, type: 'uniDate'},
	    	{name: 'EP_DATE'            , text: '면허일'	, type: 'uniDate'},
	    	{name: 'EP_NO'              , text: '면허번호'	, type: 'string'},
	    	{name: 'DEVICE_PLACE'       , text: '장치장소'	, type: 'string'},
	    	{name: 'CUSTOMS'            , text: '세관'		, type: 'string'},
	    	{name: 'TERMS_PRICE'        , text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'	, type: 'string', comboType: 'AU', comboCode: 'T005'},
	    	{name: 'PAY_TERMS'          , text: '<t:message code="system.label.trade.payingterm" default="결제방법"/>'	, type: 'string', comboType: 'AU', comboCode: 'T006'},
	    	{name: 'DIV_CODE'           , text: '<t:message code="system.label.trade.division" default="사업장"/>'	, type: 'string', comboType:'BOR120'}
	    ]
	});

	
	/**
	 * Store 정의(Service 정의)
	 */					
	var directMasterStore = Unilite.createStore('tit120skrvMasterStore', {
		model: 'tit120skrvModel',
		uniOpt: {
        	isMaster  : true,	// 상위 버튼 연결 
        	editable  : false,	// 수정 모드 사용 
        	deletable : false,	// 삭제 가능 여부 
            useNavi   : false	// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'tit120skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();	
			this.load({
				params: param
			});
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.trade.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.trade.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value:UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '통관관리번호',
				name: 'PASS_SER_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PASS_SER_NO', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.reportno" default="신고번호"/>',
				name: 'ED_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ED_NO', newValue);
					}
				}
			},{
                fieldLabel: '<t:message code="system.label.trade.offerno" default="OFFER 번호 "/>',
                name: 'SO_SER_NO',
                xtype: 'uniTextfield',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('SO_SER_NO', newValue);
                    }
                }
            },{
				fieldLabel: '통관일',
				xtype: 'uniDateRangefield',
				startFieldName: 'INVOICE_DATE_FR',
				endFieldName: 'INVOICE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('INVOICE_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INVOICE_DATE_TO',newValue);
			    	}
			    }
			},Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
				validateBlank:false,
				valueFieldName:'EXPORTER',
		    	textFieldName:'EXPORTER_NM',
				listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelResult.setValue('EXPORTER', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('EXPORTER_NM', '');
								panelSearch.setValue('EXPORTER_NM', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('EXPORTER_NM', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('EXPORTER', '');
								panelSearch.setValue('EXPORTER', '');
							}
						}
				}
			}),{
				fieldLabel: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>', 
				name: 'PAY_METH',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'T006',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_METH', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>', 
				name: 'TERMS_PRICE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'T005',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TERMS_PRICE', newValue);
					}
				}
			},{
			   xtype:'button'
			 , margin:'0 0 0 97'
			 , text:'상세내역'
			 , handler:function(){
			        var record = masterGrid.getSelectedRecord();
	        		if(record){
	        			var param = {
	        			    'PASS_SER_NO'		: record.get("PASS_SER_NO"),
						    'INVOICE_DATE'      : record.get("INVOICE_DATE"),
						    'EXPORTER'   		: record.get("EXPORTER"),
						    'EXPORTER_NM'		: record.get("EXPORTER_NM"),
						    'TERMS_PRICE'		: record.get("TERMS_PRICE"),
						    'PAY_TERMS'	        : record.get("PAY_TERMS"),
						    'PASS_EXCHANGE_RATE': record.get("PASS_EXCHANGE_RATE"),
						    'PASS_AMT_UNIT'	    : record.get("PASS_AMT_UNIT"),
						    'DIV_CODE'	        : record.get("DIV_CODE")
	        		    };
	                    var rec1 = {data : {prgID : 'tit121skrv', 'text':''}};							
		                parent.openTab(rec1, '/trade/tit121skrv.do', param);
	        		}
			  }
			}]
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value:UserInfo.divCode,
			colspan:3,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '통관관리번호',
			name: 'PASS_SER_NO',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PASS_SER_NO', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.trade.reportno" default="신고번호"/>',
			name: 'ED_NO',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ED_NO', newValue);
				}
			}
		},{
            fieldLabel: '<t:message code="system.label.trade.offerno" default="OFFER 번호 "/>',
            name: 'SO_SER_NO',
            xtype: 'uniTextfield',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('SO_SER_NO', newValue);
                }
            }
        },{
			fieldLabel: '통관일',
			xtype: 'uniDateRangefield',
			startFieldName: 'INVOICE_DATE_FR',
			endFieldName: 'INVOICE_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('INVOICE_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('INVOICE_DATE_TO',newValue);
		    	}
		    }
		},Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
			validateBlank:false,
			valueFieldName:'EXPORTER',
	    	textFieldName:'EXPORTER_NM',
	    	colspan:2,
			listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('EXPORTER', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('EXPORTER_NM', '');
								panelSearch.setValue('EXPORTER_NM', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('EXPORTER_NM', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('EXPORTER', '');
								panelSearch.setValue('EXPORTER', '');
							}
						}
			}
		}),{
			fieldLabel: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>', 
			name: 'PAY_METH',
			xtype : 'uniCombobox',
			comboType:'AU',
			comboCode:'T006',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_METH', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>', 
			name: 'TERMS_PRICE',
			xtype : 'uniCombobox',
			comboType:'AU',
			comboCode:'T005',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TERMS_PRICE', newValue);
				}
			}
		},{
		   xtype:'button'
		 , text:'상세내역'
		 , margin:'0 0 0 200'
		 , handler:function(){
		        var record = masterGrid.getSelectedRecord();
        		if(record){
        			var param = {
        			    'PASS_SER_NO'		: record.get("PASS_SER_NO"),
					    'INVOICE_DATE'      : record.get("INVOICE_DATE"),
					    'EXPORTER'   		: record.get("EXPORTER"),
					    'EXPORTER_NM'		: record.get("EXPORTER_NM"),
					    'TERMS_PRICE'		: record.get("TERMS_PRICE"),
					    'PAY_TERMS'	        : record.get("PAY_TERMS"),
					    'PASS_EXCHANGE_RATE': record.get("PASS_EXCHANGE_RATE"),
					    'PASS_AMT_UNIT'	    : record.get("PASS_AMT_UNIT"),
					    'DIV_CODE'	        : record.get("DIV_CODE")
        		    };
                    var rec1 = {data : {prgID : 'tit121skrv', 'text':''}};							
	                parent.openTab(rec1, '/trade/tit121skrv.do', param);
        		}
		  }
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
    });		
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('tit120skrvGrid1', {
		layout: 'fit',
		region: 'center',
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
        	showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
			menu.down('#linkTit121skrv').show();
			return true;
  		},
        uniRowContextMenu:{
        	items: [{
	        		text: 'tit121skrv 통관 대장출력',   
	            	itemId	: 'linkTit121skrv',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		if(record){
	            			var param = {
	            			    'PASS_SER_NO'		: record.get("PASS_SER_NO"),
							    'INVOICE_DATE'      : record.get("INVOICE_DATE"),
							    'EXPORTER'   		: record.get("EXPORTER"),
							    'EXPORTER_NM'		: record.get("EXPORTER_NM"),
							    'TERMS_PRICE'		: record.get("TERMS_PRICE"),
							    'PAY_TERMS'	        : record.get("PAY_TERMS"),
							    'PASS_EXCHANGE_RATE': record.get("PASS_EXCHANGE_RATE"),
							    'PASS_AMT_UNIT'	    : record.get("PASS_AMT_UNIT"),
							    'DIV_CODE'	        : record.get("DIV_CODE")
	            		    };
		                    var rec1 = {data : {prgID : 'tit121skrv', 'text':''}};							
			                parent.openTab(rec1, '/trade/tit121skrv.do', param);
	            		}
	            	}
	        	}]
        },
    	store: directMasterStore,
        columns: [
        	{dataIndex: 'PASS_SER_NO'		, width: 120 },
			{dataIndex: 'INVOICE_NO'		, width: 120 },
        	{dataIndex: 'ED_DATE'			, width: 86 ,hidden: true},
        	{dataIndex: 'INVOICE_DATE'		, width: 86 },
			{dataIndex: 'ED_NO'		 		, width: 120 },
			{dataIndex: 'BL_NO'		 		, width: 120 },
        	{dataIndex: 'EXPORTER'			, width: 100 ,hidden: true},
			{dataIndex: 'EXPORTER_NM'		, width: 150 },
			{dataIndex: 'PASS_AMT_UNIT'		, width: 86,align:'center'},
			{dataIndex: 'PASS_AMT'			, width: 100},
			{dataIndex: 'PASS_EXCHANGE_RATE', width: 100},
			{dataIndex: 'PASS_AMT_WON'		, width: 100 ,summaryType:'sum'},
			{dataIndex: 'DEST_PORT_NM'		, width: 150 },
			{dataIndex: 'SHIP_PORT_NM'		, width: 150 },
			{dataIndex: 'SHIP_FIN_DATE'		, width: 86 },
			{dataIndex: 'EP_DATE'			, width: 86},
			{dataIndex: 'EP_NO'				, width: 120},
			{dataIndex: 'DEVICE_PLACE'		, width: 120},
			{dataIndex: 'CUSTOMS'			, width: 120},
			{dataIndex: 'TERMS_PRICE'		, width: 100 ,hidden: true},
			{dataIndex: 'PAY_TERMS'			, width: 100 ,hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 86 }
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
		},panelSearch],
		id: 'tit120skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('INVOICE_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('INVOICE_DATE_TO',UniDate.get('today'));
			panelResult.setValue('INVOICE_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('INVOICE_DATE_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown: function() {			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
	
	function setAllFieldsReadOnly(b) {
		var r= true
		if(b) {
			var invalid = this.getForm().getFields().filterBy(function(field) {return !field.validate();});
			if(invalid.length > 0) {
				r=false;
				var labelText = ''

				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}

			   	alert(labelText+Msg.sMB083);
			   	invalid.items[0].focus();
			} else {
			}
  		} else {
			this.unmask();
		}
		return r;
	}
};
</script>
