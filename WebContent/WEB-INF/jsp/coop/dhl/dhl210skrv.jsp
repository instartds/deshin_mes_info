<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="dhl210skrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="dhl210skrv"  /> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="YP14"/>	<!-- 결제구분 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP22"/>	<!-- 접수구분 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP23"/>	<!-- 소포구분	-->
	<t:ExtComboStore comboType="AU" comboCode="YP24"/>	<!-- 선불구분 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP25"/>	<!-- 접수담당 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP26"/>	<!-- 픽업 NO 	-->
	<t:ExtComboStore comboType="AU" comboCode="B010"/>	<!-- 사용여부 	-->

</t:appConfig>
<script type="text/javascript" >


function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('dhl210skrvModel', {
	    fields: [
	    	{name: 'RECEIPT_DATE'			, text: '접수일자'			, type: 'uniDate'},
	    	{name: 'RECEIPT_NO'				, text: '접수번호'			, type: 'string'},
	    	{name: 'INVOICE_NO'				, text: '송장번호'			, type: 'string'},
	    	{name: 'SENDER'					, text: '발송인'			, type: 'string'},
	    	{name: 'PAYMENT_TYPE'			, text: '선불구분'			, type: 'string' , comboType:"AU", comboCode:"YP24"},
	    	{name: 'WEIGHT'					, text: '무게(KG)'		, type: 'number'},
	    	{name: 'COLLECT_TYPE'			, text: '결제구분'			, type: 'string' , comboType:"AU", comboCode:"YP14"},
	    	{name: 'CHARGE_AMT'				, text: '요금'			, type: 'uniPrice'},
	    	{name: 'RECIPIENT'				, text: '수신지'			, type: 'string'},
	    	{name: 'ITEM_NAME'				, text: '취급품목'			, type: 'string'},
	    	{name: 'RECEIPT_USER'			, text: '접수담당'			, type: 'string' , comboType:"AU", comboCode:"YP25"},
	    	{name: 'RECEIPT_TIME'			, text: '접수시간'			, type: 'string'},
	    	{name: 'REMARK'					, text: '비고'			, type: 'string'},
	    	
	    	{name: 'TOTAL_COUNT'			, text: '총접수건수'		, type: 'uniQty'},
	    	{name: 'CASH_AMT'				, text: '현금'			, type: 'uniPrice'},
	    	{name: 'CARD_AMT'				, text: '카드'			, type: 'uniPrice'},
	    	{name: 'TOTAL_AMT'				, text: '요금합계'			, type: 'uniPrice'},
	    	
	    	/* 2015.08.12 외상거래 추가 */
			{name: 'CUSTOM_CODE' 			,text:'외상거래처코드' 		,type:'string'	},
			{name: 'CUSTOM_NAME' 			,text:'외상거래처명' 		,type:'string'	}
			
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
	var MasterStore = Unilite.createStore('dhl210skrvMasterStore',{
			model: 'dhl210skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
               		read: 'dhl210skrvService.selectList'
                }
            },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		this.fnOrderAmtSum();
	           		
	           		var count = masterGrid.getStore().getCount();
						if(count > 0) {	
							UniAppManager.setToolbarButtons(['print'], true);
						}
	           	}
			},
			fnOrderAmtSum: function() {
				
				var cash = 0;
				var card = 0;
				var credit = 0;
				var total = 0;
				var test = MasterStore.getCount();
				
				var results1 = this.sumBy(function(record, id){
										return record.get('COLLECT_TYPE') == '2';}, 
											['CHARGE_AMT']);						
					cash = results1.CHARGE_AMT;						
											
				var results2 = this.sumBy(function(record, id){
										return record.get('COLLECT_TYPE') == '1';}, 
											['CHARGE_AMT']);						
					card = results2.CHARGE_AMT;																
				
				panelResult.setValue('TOTAL_COUNT',test); 	   				// 현금	
				panelResult.setValue('CASH_AMT',cash); 	   					// 현금
				panelResult.setValue('CARD_AMT',card);     					// 카드
				panelResult.setValue('CREDIT_AMT',credit);					// 외상
				panelResult.setValue('TOTAL_AMT',cash + card + credit );    // 현금 + 카드 + 외상
				
				
			}
	});		// End of var MasterStore 
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
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
			title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},{
				fieldLabel: '접수구분',
				name: 'RECEIPT_TYPE' ,
				xtype: 'uniCombobox' ,
        		allowBlank: false,
				comboType: 'AU',
				comboCode: 'YP22',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RECEIPT_TYPE', newValue);
					}
				}
			},{
	    		fieldLabel: '픽업일자',
		 		xtype: 'uniDatefield',
        		allowBlank: false,
		 		name: 'PICKUP_DATE',
		 		value: UniDate.get('today'),
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('PICKUP_DATE', newValue);
						}
					}
			},{
				fieldLabel: '픽업NO',
        		allowBlank: false,
				name: 'PICKUP_NO' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'YP26',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PICKUP_NO', newValue);
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
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},{
				fieldLabel: '접수구분',
				name: 'RECEIPT_TYPE' ,
				xtype: 'uniCombobox' ,
				colspan: 4,
        		allowBlank: false,
				comboType: 'AU',
				comboCode: 'YP22',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('RECEIPT_TYPE', newValue);
					}
				}
			},{
	    		fieldLabel: '픽업일자',
		 		xtype: 'uniDatefield',
        		allowBlank: false,
		 		name: 'PICKUP_DATE',
		 		value: UniDate.get('today'),
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('PICKUP_DATE', newValue);
						}
					}
			},{
				fieldLabel: '픽업NO',
        		allowBlank: false,
				name: 'PICKUP_NO' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'YP26',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PICKUP_NO', newValue);
					}
				}
			},{
				fieldLabel: '총접수건수',	
        		colspan: 3,
				name: 'TOTAL_COUNT' ,
				xtype: 'uniNumberfield',
				readOnly:true
			},{
				fieldLabel: '현금',
				name: 'CASH_AMT' ,
				xtype: 'uniNumberfield',
				readOnly:true
			},{
				fieldLabel: '카드',
				name: 'CARD_AMT' ,
				xtype: 'uniNumberfield',
				readOnly:true
			},{
				fieldLabel: '외상',
				name: 'CREDIT_AMT' ,
				xtype: 'uniNumberfield',
				readOnly:true
			},{
				fieldLabel: '요금합계',
				name: 'TOTAL_AMT' ,
				xtype: 'uniNumberfield',
				readOnly:true
			}], 
			/*api: {
         		 load: 'dhl210krvService.selectMaster'
         		},*/
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
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('dhl210skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: true,
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
			{dataIndex:'RECEIPT_DATE'	 	, width: 100
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
            	}
            },
			{dataIndex:'RECEIPT_NO'	 		, width: 125},
			{dataIndex:'INVOICE_NO'	 		, width: 100},
			{dataIndex:'SENDER'	 			, width: 100},
			{dataIndex:'PAYMENT_TYPE'	 	, width: 100},
			{dataIndex:'WEIGHT'	 			, width: 100 ,format:'0,000.0',editor:{format:'0,000.0'}},
			{dataIndex:'COLLECT_TYPE'	 	, width: 100},
			
			{dataIndex:'CUSTOM_CODE'	 	, width: 100},
			{dataIndex:'CUSTOM_NAME'	 	, width: 100},
			
			{dataIndex:'CHARGE_AMT'	 		, width: 100  , summaryType: 'sum'},
			{dataIndex:'RECIPIENT'	 		, width: 100},
			{dataIndex:'ITEM_NAME'	 		, width: 100},
        	{dataIndex:'RECEIPT_USER'	 	, width: 100  },
        	{dataIndex:'RECEIPT_TIME'		, width: 100  ,align : "center"},
        	{dataIndex:'REMARK'				, width: 100  }

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
		id: 'dhl210skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('save',false);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);

			panelSearch.setValue('PICKUP_DATE',UniDate.get('today'));
			panelResult.setValue('PICKUP_DATE',UniDate.get('today'));

		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
			UniAppManager.setToolbarButtons(['print'], false);
		},
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('panelResultForm').getValues();
	
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/dhl/dhl210rkrPrint.do',
	            prgID: 'dhl210rkr',
	               extParam: {
	                  
	               	// 사업장, 픽업일자, 접수구분, 픽업NO, 총접수건수, 현금, 카드, 외상, 요금합계
	                  DIV_CODE  	: param.DIV_CODE, 
	                  RECEIPT_TYPE  : param.RECEIPT_TYPE,
	                  PICKUP_DATE   : param.PICKUP_DATE,
	                  PICKUP_NO     : param.PICKUP_NO
	               }
	            });
	            win.center();
	            win.show();
	               
	    },
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			//var param= panelResult.getValues();
			
			masterGrid.getStore().loadStoreRecords();
			//panelResult.getForm().load({ params: param });
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};
</script>
