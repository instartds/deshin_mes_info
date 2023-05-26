<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="scp110skrv"  >
<t:ExtComboStore comboType="BOR120"  pgmId="scp110skrv"/> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="S017"/>	<!-- 수금유형		-->
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('scp110skrvModel', {
	    fields: [	
	    	{name:'ITEM_CODE' 			, text: '품목코드'			, type: 'string'},
	    	{name:'ITEM_NAME' 			, text: '명칭'			, type: 'string'},
	    	/* 카드매출 */ 
	    	{name:'CARD_01_Q' 			, text: '수량'			, type: 'uniQty'},
	    	{name:'CARD_01_O' 			, text: '금액'			, type: 'uniPrice'},
	    	{name:'CARD_02_Q' 			, text: '수량'			, type: 'uniQty'},
	    	{name:'CARD_02_O' 			, text: '금액'			, type: 'uniPrice'},
	    	{name:'CARD_03_Q' 			, text: '수량'			, type: 'uniQty'},
	    	{name:'CARD_03_O' 			, text: '금액'			, type: 'uniPrice'},
	    	{name:'CARD_04_Q' 			, text: '수량'			, type: 'uniQty'},
	    	{name:'CARD_04_O' 			, text: '금액'			, type: 'uniPrice'},
	    	{name:'CARD_05_Q' 			, text: '수량'			, type: 'uniQty'},
	    	{name:'CARD_05_O' 			, text: '금액'			, type: 'uniPrice'},
	    	{name:'CARD_06_Q' 			, text: '수량'			, type: 'uniQty'},
	    	{name:'CARD_06_O' 			, text: '금액'			, type: 'uniPrice'},
	    	{name:'CARD_07_Q' 			, text: '수량'			, type: 'uniQty'},
	    	{name:'CARD_07_O' 			, text: '금액'			, type: 'uniPrice'},
	    	{name:'CARD_08_Q' 			, text: '수량'			, type: 'uniQty'},
	    	{name:'CARD_08_O' 			, text: '금액'			, type: 'uniPrice'},
			/* 카드자동환불 */ 
	    	//{name:'CARD_REFUND_Q' 		, text: '수량'			, type: 'uniQty'},
	    	//{name:'CARD_REFUND_O' 		, text: '금액'			, type: 'uniPrice'},
	    	/* 총 합계 */
	    	{name:'CARD_TOTAL_QTY' 		, text: '수량'			, type: 'uniQty'},
	    	{name:'CARD_TOTAL_AMT' 		, text: '금액'			, type: 'uniPrice'},
	    	/* 사이버머니 */
	    	{name:'CYBER_Q' 			, text: '수량'			, type: 'uniQty'},
	    	{name:'CYBER_O' 			, text: '금액'			, type: 'uniPrice'},	
	    	/* 사이버재적립 */
	    	{name:'CYBER_REPOINT_Q' 	, text: '수량'			, type: 'uniQty'},
	    	{name:'CYBER_REPOINT_O' 	, text: '금액'			, type: 'uniPrice'},
	    	/* 사이버자동환불*/
	    	{name:'CYBER_REFUND_Q' 		, text: '수량'			, type: 'uniQty'},
	    	{name:'CYBER_REFUND_O' 		, text: '금액'			, type: 'uniPrice'},	
	    	/* 사이버 총 합계*/
	    	{name:'CYBER_TOTAL_Q' 		, text: '수량'			, type: 'uniQty'},
	    	{name:'CYBER_TOTAL_O' 		, text: '금액'			, type: 'uniPrice'}	
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
	var MasterStore = Unilite.createStore('scp110skrvMasterStore',{
			model: 'scp110skrvModel',
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
               		read: 'scp110skrvService.selectList'
                }
            },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
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
				fieldLabel: '매출일',
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
		layout : {type : 'uniTable', columns : 4},
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
				fieldLabel: '매출일',
				colspan: 3,
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
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('scp110skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
        	expandLastColumn: false,
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
			{dataIndex:'ITEM_CODE' 			  				, width: 100, locked:true 
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
            }},
            {dataIndex:'ITEM_NAME' 				  	, width: 150, locked:true },
            {
            	text: '카드',
         		columns: [
      				{
      				text: '비씨카드',
	         		columns: [
	      				{dataIndex: 'CARD_01_Q'					, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CARD_01_O'				, width: 80, summaryType: 'sum' }
	        		]
	           	},{
	            	text: '신한카드',
	         		columns: [
	      				{dataIndex: 'CARD_02_Q'					, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CARD_02_O'				, width: 80, summaryType: 'sum' }
	        		]
	           	},{
	            	text: '삼성카드',
	         		columns: [
	      				{dataIndex: 'CARD_03_Q'					, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CARD_03_O'				, width: 80, summaryType: 'sum' }
	        		]
	           	},{
	            	text: '현대카드',
	         		columns: [
	      				{dataIndex: 'CARD_04_Q'					, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CARD_04_O'				, width: 80, summaryType: 'sum' }
	        		]
	           	},{
	            	text: '롯데카드',
	         		columns: [
	      				{dataIndex: 'CARD_05_Q'					, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CARD_05_O'				, width: 80, summaryType: 'sum' }
	        		]
	           	},{
	            	text: '국민카드',
	         		columns: [
	      				{dataIndex: 'CARD_07_Q'					, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CARD_07_O'				, width: 80, summaryType: 'sum' }
	        		]
	           	},{
	            	text: '하나카드',
	         		columns: [
	      				{dataIndex: 'CARD_08_Q'					, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CARD_08_O'				, width: 80, summaryType: 'sum' }
	        		]
	           	},/*{
	            	text: '카드자동환불',
	         		columns: [
	      				{dataIndex: 'CARD_REFUND_Q'			, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CARD_REFUND_O'			, width: 80, summaryType: 'sum' }
	        		]
	           	},*/{
	            	text: '카드총합계',
	         		columns: [
	      				{dataIndex: 'CARD_TOTAL_QTY'			, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CARD_TOTAL_AMT'			, width: 80, summaryType: 'sum' }
	        		]
	           	}]
           	},{
            	text: '사이버머니',
         		columns: [
      				{
      				text: '사이버머니',
	         		columns: [
	      				{dataIndex: 'CYBER_Q'				, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CYBER_O'				, width: 80, summaryType: 'sum' }
	        		]
	           	},{
	            	text: '사이버재적립',
	         		columns: [
	      				{dataIndex: 'CYBER_REPOINT_Q'				, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CYBER_REPOINT_O'				, width: 80, summaryType: 'sum' }
	        		]
	           	},{
	            	text: '자동환불',
	         		columns: [
	      				{dataIndex: 'CYBER_REFUND_Q'				, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CYBER_REFUND_O'				, width: 80, summaryType: 'sum' }
	        		]
	           	},{
	            	text: '사이버총합계',
	         		columns: [
	      				{dataIndex: 'CYBER_TOTAL_Q'				, width: 80, summaryType: 'sum' },
	            		{dataIndex: 'CYBER_TOTAL_O'				, width: 80, summaryType: 'sum' }
	        		]
	           	}]
           	}  	
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
		id: 'scp110skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('save',false);
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('SALE_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('SALE_DATE_TO',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('SALE_DATE_TO',UniDate.get('today'));
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
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
