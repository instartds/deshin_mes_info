<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr401skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="YP08" /><!-- 매입조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09" /><!-- 판매형태 -->
	<t:ExtComboStore comboType="BOR120" pgmId="bpr401skrv" /> <!-- 사업장 -->       
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Bpr401skrvModel', {
	    fields: [{name: 'CUSTOM_CODE' 		,text:'거래처코드' 	,type:'string'},
				 {name: 'CUSTOM_NAME' 		,text:'거래처명' 		,type:'string'},
		    	 {name: 'ITEM_CODE' 		,text:'<t:message code="system.label.base.itemcode" default="품목코드"/>' 		,type:'string'},
		    	 {name: 'ITEM_NAME' 		,text:'<t:message code="system.label.base.itemname2" default="품명"/>' 			,type:'string'},
		    	 {name: 'SPEC' 				,text:'<t:message code="system.label.base.spec" default="규격"/>' 			,type:'string'},
		    	 {name: 'MONEY_UNIT' 		,text:'화폐단위' 		,type:'string',	comboType:'BU', comboCode:'B004', displayField: 'value'},
				 {name: 'ORDER_UNIT' 		,text:'단위' 			,type:'string'},
				 {name: 'PURCHASE_RATE' 	,text:'매입율' 		,type:'uniPercent'},
				 {name: 'PURCHASE_TYPE' 	,text:'매입조건' 		,type:'string', comboType:'AU', comboCode:'YP08'},
				 {name: 'SALES_TYPE' 		,text:'판매형태' 		,type:'string', comboType:'AU', comboCode:'YP09'},
				 {name: 'ITEM_P' 			,text:'단가' 			,type:'uniUnitPrice'},
				 {name: 'APLY_START_DATE' 	,text:'적용시작일' 		,type:'uniDate'},
				 {name: 'STOCK_UNIT' 		,text:'<t:message code="system.label.base.inventoryunit" default="재고단위"/>' 		,type:'string'},
				 {name: 'CUSTOM_UNIT' 		,text:'단위' 			,type:'string'},
				 {name: 'CUSTOM_P' 			,text:'단가' 			,type:'uniUnitPrice'},
				 {name: 'ITEM_ACCOUNT' 		,text:'<t:message code="system.label.base.itemaccount" default="품목계정"/>' 		,type:'string', comboType:'0U', comboCode:'B020' },
				 {name: 'TRNS_RATE' 		,text:'입수' 			,type:'string'},
				 {name: 'TYPE' 				,text:'<t:message code="system.label.base.classfication" default="구분"/>' 			,type:'string'},
				 {name: 'CUSTOM_ITEM_CODE' 	,text:'거래처품목코드' 	,type:'string'},
				 {name: 'CUSTOM_ITEM_NAME' 	,text:'거래처품명' 	,type:'string'},
				 {name: 'CUSTOM_ITEM_SPEC' 	,text:'거래처품목규격' 	,type:'string'},
				 {name: 'CUSTOM_TRNS_RATE' 	,text:'거래처입수' 	,type:'string'}
					
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bpr401skrvMasterStore1',{
			model: 'Bpr401skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'bpr401skrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			}
			
	});
    
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
	    title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			layout : {type : 'uniTable', columns : 1},
	        items : [{
	        	fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType:'BOR120',
	        	allowBlank:false,
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	        },{ 
				fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020',
				readOnly: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			}/*,
	        	Unilite.popup('ITEM',{
	        	fieldLabel: '거래처품목',
	        	valueFieldName: 'CUST_ITEM_CODE',
	        	textFieldName:'CUST_ITEM_NAME',
	        	readOnly:true,
	        	textFieldWidth:170,
	        	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUST_ITEM_CODE', panelSearch.getValue('CUST_ITEM_CODE'));
								panelResult.setValue('CUST_ITEM_NAME', panelSearch.getValue('CUST_ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUST_ITEM_CODE', '');
							panelResult.setValue('CUST_ITEM_NAME', '');
						}
					}
	        })*/,
	        	Unilite.popup('CUST',{
	        	fieldLabel: '거래처',
	        	valueFieldName: 'CUSTOM_CODE',
	        	textFieldName:'CUSTOM_NAME',
	        	textFieldWidth:170,
	        	width:400,
	        	id:'bpr401ukrvCustPopup',
	        	extParam:{'CUSTOM_TYPE':'2'},
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
	        	Unilite.popup('ITEM',{
	        	fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
	        	valueFieldName: 'ITEM_CODE',
	        	textFieldName:'ITEM_NAME',
	        	textFieldWidth:170,
	        	width:400,
	        	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					}
	        }),{
	    		xtype: 'radiogroup'		
	    		,fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>'
	    		,items : [{
	    			boxLabel:'매출',
	    			width: 100,  
	    			name: 'TYPE',
	    			inputValue: '2' 
	    		}, {
	    			boxLabel:'매입',
	    			width: 100,
	    			name: 'TYPE',
	    			inputValue: '1',
	    			checked : true
	    		}]
	    		,listeners : {change : function( radioGroup, newValue, oldValue, eOpts) {
	    								
	    								var custPopup = Ext.getCmp('bpr401ukrvCustPopup');
	    								var value = {};
	    								if(newValue.TYPE == '1')	{
	    									value = {'CUSTOM_TYPE' : '2'}
	    								}else if(newValue.TYPE == '2')	{
	    									value = {'CUSTOM_TYPE' : '3'}
	    								}
	    								custPopup.setExtParam(value);
	    								panelResult.getField('TYPE').setValue(newValue.TYPE);
	    					} 
	    			}	
			}, {
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '단가검색',
	    		id : 'aptPrice',
	    		items : [{
	    			boxLabel:'현재 적용단가',
	    			width: 100,
	    			name: 'OPT_APT_PRICE',
	    			id: 'optAptPrice',
	    			inputValue: 'C',
	    			checked: true  
	    		}, {
	    			boxLabel: '전체', 
	    			width: 100,
	    			name: 'OPT_APT_PRICE',
	    			inputValue: 'A'
	    		}],
	    		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('OPT_APT_PRICE').setValue(newValue.OPT_APT_PRICE);
					}
				}
	    	}]                 
		}], setAllFieldsReadOnly: function(b) {
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

				   	Unilite.messageBox(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
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
	        	fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType:'BOR120',
	        	allowBlank:false,
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
	        },{ 
					fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
					name: 'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B020',
					readOnly: false,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
			}/*,
	        	Unilite.popup('ITEM',{
	        	fieldLabel: '거래처품목',
	        	valueFieldName: 'CUST_ITEM_CODE',
	        	textFieldName:'CUST_ITEM_NAME',
	        	readOnly:true,
	        	textFieldWidth:170,
	        	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUST_ITEM_CODE', panelResult.getValue('CUST_ITEM_CODE'));
								panelSearch.setValue('CUST_ITEM_NAME', panelResult.getValue('CUST_ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('CUST_ITEM_CODE', '');
							panelSearch.setValue('CUST_ITEM_NAME', '');
						}
					}
	        })*/,
	        	Unilite.popup('CUST',{
	        	fieldLabel: '거래처',
	        	valueFieldName: 'CUSTOM_CODE',
	        	textFieldName:'CUSTOM_NAME',
	        	textFieldWidth:170,
	        	width:400,
	        	id:'bpr401ukrvCustPopup1',
	        	extParam:{'CUSTOM_TYPE':'2'},
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
	        	Unilite.popup('ITEM',{
	        	fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
	        	valueFieldName: 'ITEM_CODE',
	        	textFieldName:'ITEM_NAME',
	        	textFieldWidth:170,
	        	width:400,
	        	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
								panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
						}
					}
	        }),{
	    		xtype: 'radiogroup'		
	    		,fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>'	    		
	    		,items : [{
	    			boxLabel:'매출',
	    			width: 100,  
	    			name: 'TYPE',
	    			inputValue: '2' 
	    		}, {
	    			boxLabel:'매입',
	    			width: 100,
	    			name: 'TYPE',
	    			inputValue: '1',
	    			checked : true
	    		}]
	    		,listeners : {change : function( radioGroup, newValue, oldValue, eOpts) {
	    								
	    								var custPopup = Ext.getCmp('bpr401ukrvCustPopup1');
	    								var value = {};
	    								if(newValue.TYPE == '1')	{
	    									value = {'CUSTOM_TYPE' : '2'}
	    								}else if(newValue.TYPE == '2')	{
	    									value = {'CUSTOM_TYPE' : '3'}
	    								}
	    								custPopup.setExtParam(value);
	    								panelSearch.getField('TYPE').setValue(newValue.TYPE);
	    					} 
	    			}	
			}, {
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '단가검색',
	    		id : 'aptPrice1',
	    		items : [{
	    			boxLabel:'현재 적용단가',
	    			width: 100,
	    			name: 'OPT_APT_PRICE',
	    			id: 'optAptPrice1',
	    			inputValue: 'C',
	    			checked: true  
	    		}, {
	    			boxLabel: '전체', 
	    			width: 100,
	    			name: 'OPT_APT_PRICE',
	    			inputValue: 'A'
	    		}],
	    		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('OPT_APT_PRICE').setValue(newValue.OPT_APT_PRICE);
					}
				}
	    	}]
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('bpr401skrvGrid1', {
    	// for tab
    	region: 'center',
        layout : 'fit', 
    	store: directMasterStore,
        columns:  [{dataIndex: 'TYPE', 							width: 66, hidden: true}, 	// 구분
				   {dataIndex: 'CUSTOM_CODE',  					width: 80 },				// 고객코드
				   {dataIndex: 'CUSTOM_NAME',  					width: 166 }, 				// 고객명
				   {dataIndex: 'ITEM_CODE',  					width: 105 },				// 품목코드
				   {dataIndex: 'ITEM_NAME',  					width: 166 }, 				// 품명
				   {dataIndex: 'SPEC',		  					width: 120 }, 				// 규격 					
				   {text: '판매/구매단가',
					   columns:[{dataIndex: 'MONEY_UNIT',		width: 100, hidden:true, align: 'center'}, // 화폐단위
								{ dataIndex: 'ORDER_UNIT',		width: 100}, // 단위
							    { dataIndex: 'ITEM_P',			width: 100 }, // 단가
								{ dataIndex: 'APLY_START_DATE',  width: 100 } 	 // 적용시작일
						]},
				   {text: '<t:message code="system.label.base.iteminfo" default="품목정보"/>',
					   columns:[{dataIndex: 'STOCK_UNIT',		width: 100 }, // 재고단위
							    {dataIndex: 'CUSTOM_UNIT',		width: 100 }, 	 // 단위
								{dataIndex: 'CUSTOM_P',			width: 100 }, 	 // 단가
								{dataIndex: 'ITEM_ACCOUNT',		width: 100 }, 	 // 품목계정
								{dataIndex: 'TRNS_RATE',		width: 100 } // 입수
						]
					},
				   {dataIndex: 'PURCHASE_RATE',  					width: 100 },
				   {dataIndex: 'PURCHASE_TYPE',  					width: 100 },
				   {dataIndex: 'SALES_TYPE', 	  					width: 100 }						
          ] 
    }); 
	   
    Unilite.Main( {
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
		fnInitBinding : function() {			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{	
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore.loadStoreRecords();
		}
	});

};


</script>
