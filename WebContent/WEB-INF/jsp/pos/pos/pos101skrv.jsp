<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pos101skrv"  >
<t:ExtComboStore items="${COMBO_POS_NO}" storeId="PosNo" /><!--POS 명-->
<t:ExtComboStore comboType="AU" comboCode="S017"/>	<!-- 수금유형		-->
<t:ExtComboStore comboType="AU" comboCode="A028"/>	<!-- 신용카드회사	-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('pos101skrvModel', {
	    fields: [
	    	{name:'DIV_CODE' 		, text: '사업장'		, type: 'string'},
	    	{name:'COMP_CODE' 		, text: '법인코드'		, type: 'string'},
	    	{name:'POS_NO'			, text: 'POS_NO'    , type: 'string' ,store:Ext.data.StoreManager.lookup('PosNo') },
	    	{name:'SALE_DATE' 		, text: '매출일자'		, type: 'uniDate'},
	    	{name:'RECEIPT_NO'  	, text: 'NO'		, type: 'string'},
	    	{name:'ITEM_CODE' 		, text: '품목코드'		, type: 'string'},
	    	{name:'ITEM_NAME' 		, text: '품명'		, type: 'string'},
	    	{name:'ORIGIN_P' 		, text: '판매가'		, type: 'uniPrice'},
	    	{name:'DISCOUNT_P' 		, text: '할인'		, type: 'uniPrice'},
	    	{name:'SALEPRICE' 		, text: '실판매가'		, type: 'uniPrice'},
	    	{name:'SALE_Q' 			, text: '수량'		, type: 'uniQty'},
	    	{name:'SALE_MONEY' 		, text: '금액'		, type: 'uniPrice'},
	    	{name:'DISCOUNT_MONEY' 	, text: '할인액'		, type: 'uniPrice'},
	    	{name:'DISRATE' 		, text: '할인율'		, type: 'float'},
	    	{name:'REMARK' 			, text: '비고'		, type: 'string'},
	    	{name:'SALE_DATE' 		, text: '거래일자'		, type: 'string'}
	    ]
	    
	});		//End of Unilite.defineModel('pos101skrvModel', {
	
	Unilite.defineModel('pos101skrvModel2', {
	    fields: [
	    	{name:'RECEIPT_NO' 			, text: 'NO'		, type: 'string'},
	    	{name:'COLLECT_TYPE' 		, text: '결제유형'		, type: 'string' ,comboType:"AU", comboCode:"S017" },
	    	{name:'COLLECT_AMT' 		, text: '금액'		, type: 'uniPrice'},
	    	{name:'CUSTOM_CODE'			, text: '고객코드'		, type:'string'},
	    	{name:'CUSTOM_NAME'			, text: '고객명'		, type:'string'},
	    	{name:'SIGN_DATA'     		, text:'Signature'	, type:'string'},
	    	{name:'CARD_ACC_NUM' 		, text: '승인번호'		, type: 'string'},
	    	{name:'APPVAL_TIME' 		, text: '승인시간'		, type: 'uniDate'},
	    	{name:'REMARK' 				, text: '비고'		, type: 'string'},
	    	{name:'COLLECT_NUM' 		, text: '수금번호'		, type: 'string'},
	    	{name:'COLLECT_SEQ' 		, text: '수금순번'		, type: 'string'},
	    	{name:'SIGN_DIV_CODE' 		, text: '사업장코드'	, type: 'string'},
	    	{name:'INF_COLLECT_TYPE' 	, text: '원본 결제 유형'	, type: 'string' ,comboType:"AU", comboCode:"S138"},
	    	{name:'INPUT_METHOD_TYPE'   , text: '신용카드 결재방법' , type: 'string'}
	    ]
	});		//End of Unilite.defineModel('pos101skrvModel2', {
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	/**
	 * Store 정의(Service 정의)
	 * 판매내역 스토어
	 * @type 
	 */
	var SaleStore = Unilite.createStore('pos101skrvSaleStore',{
			model: 'pos101skrvModel',
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
                	   read: 'pos101skrvService.selectsaleList'
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
		           		if(records[0] != null){
		           			payGrid.getStore().loadStoreRecords(records[0]);
			       	}
	          	}
           	}
			
	});		// End of var MasterStore = Unilite.createStore('pos101skrvSaleStore',{
	
	/**
	 * Store 정의(Service 정의)
	 * 결제 스토어
	 * @type 
	 */
	var PayStore = Unilite.createStore('pos101skrvSaleStore',{
			model: 'pos101skrvModel2',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'pos101skrvService.selectpayList'
                }
            },
            
            loadStoreRecords : function(record)	{
				var searchParam= Ext.getCmp('searchForm').getValues();
				if(record != null){
					var param= {'RECEIPT_NO':record.get('RECEIPT_NO'),'SALE_DATE':record.get('SALE_DATE')}
				}
				var params = Ext.merge(searchParam, param);
				console.log( param );
				this.load({
					params : params
				});
			}
            
           /* 
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			}*/
			
	});		// End of var MasterStore = Unilite.createStore('pos101skrvSaleStore',{
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
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
			title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		 		fieldLabel: '매출일자',
		 		xtype: 'uniDatefield',
		 		name: 'SALE_DATE',
		 		//value: UniDate.get('today'), // UniDate.get('today'),
		 		allowBlank:false,
		 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('SALE_DATE', newValue);
					}
				}
			},{
				fieldLabel: 'POS',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				store:Ext.data.StoreManager.lookup('PosNo'),
		        multiSelect: true, 
		        typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('POS_CODE', newValue);
					}
				}
			},{
		        fieldLabel: '영수증번호',
		        name:'RECEIPT_NO',
		        xtype: 'uniTextfield',
		        listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('RECEIPT_NO', newValue);
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
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
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
		 		fieldLabel: '매출일자',
		 		xtype: 'uniDatefield',
		 		name: 'SALE_DATE',
		 		//value: UniDate.get('today'), // UniDate.get('today'),
		 		allowBlank:false,
		 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SALE_DATE', newValue);
					}
				}
			},{
				fieldLabel: 'POS',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				store:Ext.data.StoreManager.lookup('PosNo'),
		        multiSelect: true, 
		        typeAhead: false,
				width: 400,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('POS_CODE', newValue);
						}
					}
			},{
		        fieldLabel: '영수증번호',
		        name:'RECEIPT_NO',
		        xtype: 'uniTextfield',
		        listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('RECEIPT_NO', newValue);
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
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}  
    });
    
    
    /**
     * sale Grid 정의(Grid Panel)
     * @type 
     */
    var saleGrid = Unilite.createGrid('pos101skrvsaleGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : SaleStore,
        excelTitle:'영수증별 상세현황(상단)' ,
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
			{dataIndex:'RECEIPT_NO'  		 		, width:100
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
            }},
			{dataIndex:'ITEM_CODE' 					, width:120},
			{dataIndex:'ITEM_NAME' 			 		, width:250},
			{dataIndex:'ORIGIN_P' 					, width:88 , summaryType: 'sum'},
			{dataIndex:'DISCOUNT_P' 			 	, width:88 , summaryType: 'sum'},
			{dataIndex:'SALEPRICE' 					, width:88 , summaryType: 'sum'},
			{dataIndex:'SALE_Q' 				 	, width:88 , summaryType: 'sum'},
			{dataIndex:'SALE_MONEY' 				, width:88 , summaryType: 'sum'},
			{dataIndex:'DISCOUNT_MONEY' 		 	, width:88 , summaryType: 'sum'},
			{dataIndex:'DISRATE' 					, width:120 , 
 			renderer : function(val) {
                    if (val > 0) {
                        return val + '%';
                    } else if (val < 0) {
                        return val + '%';
                    }
                    return val;
                }},
			{dataIndex:'REMARK' 				 	, width:120},
			{dataIndex:'SALE_DATE' 				 	, width:120 ,hidden:true}
			
		],
        selModel: 'rowmodel'		// 조회화면 selectionchange event 사용
		,listeners: {
		/*	selectionchangerecord:function(record , selected)	{
          		panelSearch.setValue('RECEIPT_NO',record.get('RECEIPT_NO'));
				payGrid.getStore().loadStoreRecords();
          	}*/
			
			
			
        	selectionchange:function( model1, selected, eOpts ){
        		if(selected.length > 0)	{
	        		var record = selected[0];
	        		PayStore.loadData({})
					PayStore.loadStoreRecords(record);
	        	
        		}
          	}
		}
    });		//End of var masterGrid = Unilite.createGrid('pos101skrvsaleGrid', {
    
    /**
     * pay Grid 정의(Grid Panel)
     * @type 
     */
    var payGrid = Unilite.createGrid('pos101skrvpayGrid', {
    	region:'south',
        layout : 'fit',
        store : PayStore,
        excelTitle:'영수증별 상세현황(하단)' ,
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
			{dataIndex:'RECEIPT_NO' 				, width:100
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
            }},
			{dataIndex:'COLLECT_TYPE' 		 		, width:120},
			{dataIndex:'COLLECT_AMT' 		 		, width:88  , summaryType: 'sum'},
			{dataIndex:'CUSTOM_CODE' 	 			, width:120},
			{dataIndex:'CUSTOM_NAME' 				, width:180},
			{dataIndex:'CARD_ACC_NUM' 		 		, width:120},
			{dataIndex:'APPVAL_TIME' 			 	, width:120},
			{dataIndex:'COLLECT_NUM' 			 	, width:120, hidden:true},
			{dataIndex:'COLLECT_SEQ' 			 	, width:120, hidden:true},
			{dataIndex:'SIGN_DIV_CODE' 			 	, width:120, hidden:true},
			{ text: 'Signature',
			          dataIndex: 'SIGN_DATA',
			          align: 'center',
			          xtype: 'actioncolumn',
			          width:70,
			          items: [{
		                  icon: CPATH+'/resources/css/theme_01/barcodetest.png',
		                  handler: function(grid, rowIndex, colIndex, item, e, record) {
		                  	if(record.get('COLLECT_NUM'))	{
								   var signImgWin = Ext.create('Ext.window.Window', {
										    title: 'Signature',
										    height: 200,
										    width: 400,
										    layout: 'fit',
										    items: [{  
										        xtype: 'image',
										        itemId : 'SignImg',
										        src:CPATH+'/resources/images/nameCard.jpg'
										    }],
										    setImg : function()	{
										    	this.down('#SignImg').setSrc("pos101skrvSign.do?DIV_CODE="+record.get('SIGN_DIV_CODE')+"&COLLECT_NUM="+record.get('COLLECT_NUM')+"&COLLECT_SEQ="+record.get('COLLECT_SEQ'));
										    }
										})
								    signImgWin.setImg();
								    signImgWin.show();
		                  		
		                  	}
		                  },
		                  isDisabled: function(view, rowIndex, colIndex, item, record) {
				                // Returns true if 'editable' is false (, null, or undefined)
				                return record.get('SIGN_DATA') == 'N' ;
				            }
        			}]
        			},
        		{dataIndex:'INF_COLLECT_TYPE' 			, width:120},
        		{dataIndex:'INPUT_METHOD_TYPE' 			, width:120},
        		{dataIndex:'REMARK' 				 	, width:120}
			
			
		]
    });		//End of var masterGrid = Unilite.createGrid('pos101skrvpayGrid', {
    
    
    /**
	 * Main 정의(Main 정의)
	 * @type 
	 */    
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				saleGrid, payGrid, panelResult
         	]
      },
         panelSearch
      ],
		id: 'pos101skrvApp',
		fnInitBinding : function(params) {			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',true);
			this.processParams(params);
			
			/*if(Ext.isEmpty(this.processParams(params))){
				panelSearch.setValue('SALE_DATE',UniDate.get('today'));
				panelResult.setValue('SALE_DATE',UniDate.get('today'));
			}*/
		
		},
		onQueryButtonDown: function(){
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				saleGrid.getStore().loadStoreRecords();
				//payGrid.getStore().loadStoreRecords();
				
				/*panelSearch.getField('SALE_DATE').setReadOnly( true );
				panelSearch.getField('POS_NO').setReadOnly( true );
				panelSearch.getField('POS_NAME').setReadOnly( true );
				panelSearch.getField('RECEIPT_NO').setReadOnly( true );
				
				panelResult.getField('SALE_DATE').setReadOnly( true );
				panelResult.getField('POS_NO').setReadOnly( true );
				panelResult.getField('POS_NAME').setReadOnly( true );
				panelResult.getField('RECEIPT_NO').setReadOnly( true );*/
			}
		//	return true;
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			saleGrid.getStore().loadData({});
			saleGrid.reset();
			
			payGrid.getStore().loadData({});
			payGrid.reset();
			
			panelSearch.getField('SALE_DATE').setReadOnly( false );
			panelSearch.getField('POS_CODE').setReadOnly( false );
			panelSearch.getField('RECEIPT_NO').setReadOnly( false );
			
			panelResult.getField('SALE_DATE').setReadOnly( false );
			panelResult.getField('POS_CODE').setReadOnly( false );
			panelResult.getField('RECEIPT_NO').setReadOnly( false );
			
			this.fnInitBinding();
		},
        processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params && params.SALE_DATE ) {
				if(params.action == 'excelNew') {	//품목 신규 등록(수주등록->엑셀참조에서 호출)
					var rec = masterGrid.createRow(
						{
							SALE_DATE: params.SALE_DATE,
							//POS_NO: params.POS_NO,
							//POS_NAME: params.POS_NAME,
							POS_CODE : params.POS_NO,
							RECEIPT_NO: params.RECEIPT_NO
						}
					);
			        panelSearch.loadForm(rec);
			        panelResult.loadForm(rec);
			       	
				} else {
					panelSearch.setValue('SALE_DATE',params.SALE_DATE);
					//panelSearch.setValue('POS_NO',params.POS_NO);
					//panelSearch.setValue('POS_NAME',params.POS_NAME);
					panelSearch.setValue('POS_CODE',params.POS_NO);
					panelSearch.setValue('RECEIPT_NO',params.RECEIPT_NO);
					
					panelResult.setValue('SALE_DATE',params.SALE_DATE);
					//panelResult.setValue('POS_NO',params.POS_NO);
					//panelResult.setValue('POS_NAME',params.POS_NAME);
					panelResult.setValue('POS_CODE',params.POS_NO);
					panelResult.setValue('RECEIPT_NO',params.RECEIPT_NO);
					
					saleGrid.getStore().loadStoreRecords();
					payGrid.getStore().loadStoreRecords();
					
					panelSearch.getField('SALE_DATE').setReadOnly( true );
					//panelSearch.getField('POS_NO').setReadOnly( true );
					//panelSearch.getField('POS_NAME').setReadOnly( true );
					panelSearch.getField('POS_CODE').setReadOnly( true );
					panelSearch.getField('RECEIPT_NO').setReadOnly( true );
					
					panelResult.getField('SALE_DATE').setReadOnly( true );
					//panelResult.getField('POS_NO').setReadOnly( true );
					//panelResult.getField('POS_NAME').setReadOnly( true );
					panelResult.getField('POS_CODE').setReadOnly( true );
					panelResult.getField('RECEIPT_NO').setReadOnly( true );
				}
			}
		}
	});		// End of Unilite.Main( {
};
</script>
