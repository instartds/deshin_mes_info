<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tix110skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="tix110skrv" /> 				<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="T071" opts= 'B;O;P;S'/> <!--진행구분-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}'
};
function appMain() {

	Unilite.defineModel('tix110skrvModel', {
	    fields: [
	    	{name: 'TRADE_DIV'		        , text: '<t:message code="system.label.trade.tradeclass" default="무역구분"/>'  , type: 'string'},
	    	{name: 'CHARGE_TYPE'			, text: '경비구분'	, type: 'string', comboType: 'AU', comboCode: 'T071'},
	    	{name: 'OFFER_NO'				, text: 'OFFER 번호'	, type: 'string'},
	    	{name: 'BASIC_PAPER_NO'			, text: '근거번호'	, type: 'string'},
			{name: 'BL_NO'					, text: 'BL NO'	, type: 'string'},
	    	{name: 'OCCUR_DATE'				, text: '발생일자'	, type: 'uniDate'},
            {name: 'CHARGE_CODE'			, text: '<t:message code="system.label.trade.expensecode" default="경비코드"/>'	, type: 'string'}, 
	    	{name: 'CHARGE_NAME'			, text: '<t:message code="system.label.trade.expensename" default="경비명"/>'	, type: 'string'},
            {name: 'TRADE_CUSTOM_CODE'		, text: '수입처'	, type: 'string'},
	    	{name: 'TRADE_CUSTOM_NAME'		, text: '수입처명'	, type: 'string'},
	    	{name: 'CUST_CODE'				, text: '지급처'	, type: 'string'},
	    	{name: 'CUSTOM_NAME'			, text: '지급처명'	, type: 'string'},
	    	{name: 'PAY_TYPE'       		, text: '지급유형'	, type: 'string', comboType: 'AU', comboCode: 'T072'},
	    	{name: 'SAVE_CODE'       		, text: '<t:message code="system.label.trade.depositcode" default="예적금코드"/>', type: 'string'},
	    	{name: 'SAVE_NAME'       		, text: '<t:message code="system.label.trade.depositname" default="예적금명"/>'	, type: 'string'},
	    	{name: 'AMT_UNIT'      			, text: '<t:message code="system.label.trade.currency" default="화폐 "/>'		, type: 'string', comboType: 'AU', comboCode: 'B004', displayField: 'value'},
	    	{name: 'CHARGE_AMT'             , text: '경비금액'	, type: 'uniUnitPrice'},
	    	{name: 'EXCHANGE_RATE'          , text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'		, type: 'uniER'},
	    	{name: 'CHARGE_AMT_WON'       	, text: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>'	, type: 'uniPrice'},
	    	{name: 'TAX_CLS'           		, text: '계산서종류', type: 'string', comboType: 'AU', comboCode: 'A022'},
	    	{name: 'VAT_AMT'        		, text: '부가세액'	, type: 'uniPrice'},
	    	{name: 'VAT_COMP_CODE'          , text: '신고사업장', type: 'string'},
	    	{name: 'CUST_CODE'           	, text: '거래처'	, type: 'string'},
	    	{name: 'CUSTOM_NAME'            , text: '거래처명'	, type: 'string'},
	    	{name: 'COST_DIV'           	, text: '배분대상여부', type: 'string', comboType: 'AU', comboCode: 'T107'},
	    	{name: 'REMARKS'           		, text: '비고'		, type: 'string'},
	    	{name: 'BANK_CODE'           	, text: '<t:message code="system.label.trade.bankcode" default="은행코드"/>'	, type: 'string'}
	    ]
	});
	
	/**
	 * Store 정의(Service 정의)
	 */					
	var directMasterStore = Unilite.createStore('tix110skrvMasterStore', {
		model: 'tix110skrvModel',
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
				read: 'tix110skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('resultForm').getValues();
			debugger;
			var chargeType = panelResult.getValue("CHARGE_TYPE");
			
			if(chargeType =="O") {
                param["BASIS_NO"] = panelResult.getValue("INCOM_OFFER");
            } else if(chargeType =="B") {
                param["BASIS_NO"] = panelResult.getValue("INCOM_BL");
            } else if(chargeType =="P") {
                param["BASIS_NO"] = panelResult.getValue("PASS_INCOM_NO");
            } else if(chargeType =="S") {
                param["BASIS_NO"] = panelResult.getValue("NEGO_INCOM_NO");
            } else {
            	param["BASIS_NO"] = panelResult.getValue("BASIC_PAPER_NO");
            }
			
//			param["BASIS_NO"] = chargeType?panelResult.getValue("BASIS_NO_"+chargeType):panelResult.getValue("BASIS_NO_B")
			this.load({
				params: param
			});
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 */
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
			value:UserInfo.divCode
		},{
                fieldLabel: '진행구분', 
                name: 'CHARGE_TYPE', 
                xtype: 'uniCombobox', 
                comboType: 'AU', 
                comboCode: 'T071',
                listeners: {
//                    blur: function( field, The, eOpts ){
                	change: function(field, newValue, oldValue, eOpts) {                   
                        var charge_type= panelResult.getValue("CHARGE_TYPE");
                        panelResult.setValue('BASIC_PAPER_NO', '');
                        if(Ext.isEmpty(charge_type)){
                           alert("진행구분을 선택 하세요.");
                           panelResult.getField('BASIC_PAPER_NO').show();
                           Ext.getCmp('INCOM_OFFER2').setVisible(false);
                           Ext.getCmp('INCOM_BL2').setVisible(false);
                           Ext.getCmp('PASS_INCOM_NO2').setVisible(false);
                           Ext.getCmp('NEGO_INCOM_NO2').setVisible(false);
                        }else{
                            switch(charge_type){
                                case "O": //수입OFFER
                                   panelResult.getField('BASIC_PAPER_NO').setVisible(false);
                                   Ext.getCmp('INCOM_OFFER2').setVisible(true);
                                   Ext.getCmp('INCOM_BL2').setVisible(false);
                                   Ext.getCmp('PASS_INCOM_NO2').setVisible(false);
                                   Ext.getCmp('NEGO_INCOM_NO2').setVisible(false);
                                break;                                  
                                case "B": //B/L선적
                                   panelResult.getField('BASIC_PAPER_NO').setVisible(false);
                                   Ext.getCmp('INCOM_OFFER2').setVisible(false);
                                   Ext.getCmp('INCOM_BL2').setVisible(true);
                                   Ext.getCmp('PASS_INCOM_NO2').setVisible(false);
                                   Ext.getCmp('NEGO_INCOM_NO2').setVisible(false);
                                break;
                                case "P": //수입통관
                                   panelResult.getField('BASIC_PAPER_NO').setVisible(false);
                                   Ext.getCmp('INCOM_OFFER2').setVisible(false);
                                   Ext.getCmp('INCOM_BL2').setVisible(false);
                                   Ext.getCmp('PASS_INCOM_NO2').setVisible(true);
                                   Ext.getCmp('NEGO_INCOM_NO2').setVisible(false);
                                break;
                                case "S": //수입대금
                                   panelResult.getField('BASIC_PAPER_NO').setVisible(false);
                                   Ext.getCmp('INCOM_OFFER2').setVisible(false);
                                   Ext.getCmp('INCOM_BL2').setVisible(false);
                                   Ext.getCmp('PASS_INCOM_NO2').setVisible(false);
                                   Ext.getCmp('NEGO_INCOM_NO2').setVisible(true);
                                break;
                            }                            
                        }
                    }
                }
            },{
                fieldLabel: '근거번호', 
                name: 'BASIC_PAPER_NO',
                textFieldName: 'BASIC_PAPER_NO',
                xtype: 'uniTextfield'
            },Unilite.popup('INCOM_OFFER', {     //수입 OFFER 관리번호
                fieldLabel: '근거번호',
                id: 'INCOM_OFFER2',
                textFieldName: 'INCOM_OFFER',
                popupWidth: 710,
                hidden: true,
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
                    }
                }
            })
            ,Unilite.popup('INCOM_BL', {        //수입 B/L 관리번호
                fieldLabel: '근거번호',
                id: 'INCOM_BL2',
                textFieldName: 'INCOM_BL',
                hidden: true,
                popupWidth: 710,
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
                    }
                }
            })
            ,Unilite.popup('PASS_INCOM_NO', {   //수입통관 관리번호
                fieldLabel: '근거번호',
                id: 'PASS_INCOM_NO2',
                textFieldName: 'PASS_INCOM_NO',
                hidden: true,
                popupWidth: 710,
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
                    }
                }
            })
            ,Unilite.popup('NEGO_INCOM_NO', {   //수입대금 관리번호
                fieldLabel: '근거번호',
                id: 'NEGO_INCOM_NO2',
                textFieldName: 'NEGO_INCOM_NO',
                hidden: true,
                popupWidth: 710,
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
                    }
                }
            }),{
				fieldLabel: '발생일',
				xtype: 'uniDateRangefield',
				startFieldName: 'OCCUR_DATE_FR',
				endFieldName: 'OCCUR_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false
			},{
				//20191209 추가
				fieldLabel	: 'OFFER 번호',
				name		: 'OFFER_SER_NO',
				xtype		: 'uniTextfield',
				colspan:2,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('OFFER_SER_NO', newValue);
					}
				}
			}
            ,Unilite.popup('AGENT_CUST', {
				fieldLabel: '수입처',
				validateBlank:false,				
				valueFieldName:'IMPORTER',
		    	textFieldName:'IMPORTER_NAME',
				listeners: {
					onValueFieldChange:function( elm, newValue, oldValue) {							
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('IMPORTER_NAME', '');
						}
					},
					onTextFieldChange:function( elm, newValue, oldValue) {						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('IMPORTER', '');
						}
					},					
					applyextparam: function(popup){
						popup.setExtParam({'CUSTOM_TYPE': ['1','2']});
					}	
				}
			}),Unilite.popup('AGENT_CUST', {
				fieldLabel: '지급처',
				validateBlank:false,
				valueFieldName:'PAY_CUST',
		    	textFieldName:'PAY_CUST_NAME',
				listeners: {
					onValueFieldChange:function( elm, newValue, oldValue) {							
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('PAY_CUST_NAME', '');
						}
					},
					onTextFieldChange:function( elm, newValue, oldValue) {						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('PAY_CUST', '');
						}
					},						
					applyextparam: function(popup){
						popup.setExtParam({'CUSTOM_TYPE': ['1','2']});
					}	
				}
			}),{
				fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
				name: 'TAX_DIV_CODE',
				xtype: 'uniTextfield',
				hidden: true
				//value:UserInfo.divCode
			}
		],
		setAllFieldsReadOnly: setAllFieldsReadOnly
    });		
	
    /**
     * Master Grid1 정의(Grid Panel)
     */
	var masterGrid = Unilite.createGrid('tix110skrvGrid1', {
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
    	store: directMasterStore,
        columns: [
        
        	{dataIndex: 'TRADE_DIV'			, width: 86 ,hidden: true,locked:true},
			{dataIndex: 'CHARGE_TYPE'		, width: 86,locked:true },
			{dataIndex: 'OFFER_NO'	, width: 120 ,locked:true},
        	{dataIndex: 'BASIC_PAPER_NO'	, width: 120 ,locked:true},
			{dataIndex: 'BL_NO'				, width: 120 ,locked:true},
        	{dataIndex: 'OCCUR_DATE'		, width: 86  ,locked:true},
			{dataIndex: 'CHARGE_CODE'		, width: 120 ,locked:true},
        	{dataIndex: 'CHARGE_NAME'		, width: 150 ,locked:true},
			{dataIndex: 'TRADE_CUSTOM_CODE'	, width: 120 },
			{dataIndex: 'TRADE_CUSTOM_NAME'	, width: 150 },
			{dataIndex: 'CUST_CODE'			, width: 120 },
			{dataIndex: 'CUSTOM_NAME'		, width: 150 },
			{dataIndex: 'PAY_TYPE'			, width: 86  },
			{dataIndex: 'SAVE_CODE'			, width: 120 },
			{dataIndex: 'SAVE_NAME'			, width: 150 },
			{dataIndex: 'AMT_UNIT'			, width: 86, align: 'center' },
			{dataIndex: 'CHARGE_AMT'		, width: 100,summaryType:'sum'},
			{dataIndex: 'EXCHANGE_RATE'		, width: 100},
			{dataIndex: 'CHARGE_AMT_WON'	, width: 100,summaryType:'sum'},
			{dataIndex: 'TAX_CLS'			, width: 86},
			{dataIndex: 'VAT_AMT'			, width: 100,summaryType:'sum'},
			{dataIndex: 'VAT_COMP_CODE'		, width: 86 },
			{dataIndex: 'COST_DIV'			, width: 86  },
			{dataIndex: 'REMARKS'			, width: 166 },
			{dataIndex: 'BANK_CODE'			, width: 120 ,hidden: true}
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
		}],
		id: 'tix110skrvApp',
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
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
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelResult.setAllFieldsReadOnly(true);
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
