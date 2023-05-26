<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv200skrv"  >
<t:ExtComboStore comboType="BOR120"  pgmId="biv200skrv"/> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />		<!--창고-->
<t:ExtComboStore comboType="AU" comboCode="M104" /> <!--출고유형-->

</t:appConfig>
<script type="text/javascript" >

var gsWhCode = '';		//창고코드

function appMain() {	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('biv200skrvModel', {
	    fields: [
	    	{name:'DEPT_CODE' 				, text: '부서코드'		, type: 'string'},
	    	{name:'DEPT_NAME' 				, text: '부서명'		, type: 'string'},
	    	{name:'WH_CODE' 				, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'		, type: 'string'},
	    	{name:'WH_NAME' 				, text: '창고명'		, type: 'string'},
	    	{name:'PROD_ITEM_CODE' 			, text: '제조품목'		, type: 'string'},
	    	{name:'PROD_ITEM_NAME' 			, text: '제조품명'		, type: 'string'},
	    	{name:'PROD_ITEM_ALIAS' 		, text: '제조품명'		, type: 'string'},
	    	{name:'SALE_Q' 					, text: '판매수량'		, type: 'uniQty'},
	    	{name:'ITEM_CODE' 				, text: '원자재품목'	, type: 'string'},
	    	{name:'ITEM_NAME' 				, text: '원자재품명'	, type: 'string'},
	    	{name:'INOUT_Q' 				, text: '투입수량' 	    , type: 'uniQty'},
	    	{name:'END_STOCK_Q' 			, text: '월말재고량'	, type: 'uniQty'},
	    	{name:'STOCK_Q' 				, text: '현재고량' 	    , type: 'uniQty'},
	    	{name:'INOUT_TYPE_DETAIL' 		, text: '출고유형'		, type: 'string', comboType:'AU', comboCode:'M104'},
	    	{name:'INOUT_DATE' 				, text: '출고일'  	    , type: 'uniDate'},
	    	{name:'INOUT_NUM' 				, text: '출고번호' 	    , type: 'string'},
	    	{name:'INOUT_SEQ' 				, text: '순번'   		, type: 'string'},
	    	{name:'INSERT_DB_TIME' 			, text: '등록일자' 	    , type: 'uniDate'},
	    	{name:'INSERT_DB_USER' 			, text: '등록자ID'   	, type: 'string'},	    		
	    	{name:'LOT_NO' 					, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'	    , type: 'string'},
	    	{name:'SEQ' 					, text: '처리순번' 	    , type: 'string'}
	    ]	    
	});		//End of Unilite.defineModel
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var MasterStore = Unilite.createStore('biv200skrvMasterStore',{
			model: 'biv200skrvModel',
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
               		read: 'biv200skrvService.selectList'
                }
            },
			loadStoreRecords: function(){
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
			},
			groupField: 'PROD_ITEM_ALIAS'
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
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				child:'WH_CODE',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				} 
			}, {
				xtype: 'uniMonthfield',
				fieldLabel: '매출년월',
				name: 'BASIS_YYMM',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {						
						panelResult.setValue('BASIS_YYMM', newValue);
					}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '부서', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
							gsWhCode = records[0]['WH_CODE'];
							var whStore = panelSearch.getField('WH_CODE').getStore();							
							console.log("whStore : ",whStore);							
							whStore.clearFilter(true);
							whStore.filter([
								 {property:'option', value:panelSearch.getValue('DIV_CODE')}
								,{property:'value', value: records[0]['WH_CODE']}
							]);
							panelSearch.getField('WH_CODE').setValue(records[0]['WH_CODE']);
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
						
						if(authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),{
				name: 'WH_CODE',
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>', 
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{ 
		        	fieldLabel: '제조품목',
		        	valueFieldName: 'PROD_ITEM_CODE', 
					textFieldName: 'PROD_ITEM_NAME', 
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('PROD_ITEM_CODE', panelSearch.getValue('PROD_ITEM_CODE'));
								panelResult.setValue('PROD_ITEM_NAME', panelSearch.getValue('PROD_ITEM_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('PROD_ITEM_CODE', '');
							panelResult.setValue('PROD_ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
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

				   	alert(labelText+Msg.sMB083);
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
			fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			child:'WH_CODE',
			allowBlank: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			} 
		}, {
			xtype: 'uniMonthfield',
			fieldLabel: '매출년월',
			name: 'BASIS_YYMM',
			allowBlank: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BASIS_YYMM', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{ 
	        	fieldLabel: '제조품목',
	        	valueFieldName: 'PROD_ITEM_CODE', 
				textFieldName: 'PROD_ITEM_NAME', 
	        	listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelSearch.setValue('PROD_ITEM_CODE', panelResult.getValue('PROD_ITEM_CODE'));
							panelSearch.setValue('PROD_ITEM_NAME', panelResult.getValue('PROD_ITEM_NAME'));	
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PROD_ITEM_CODE', '');
						panelSearch.setValue('PROD_ITEM_NAME', '');
					},
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		 }),
		Unilite.popup('DEPT', { 
			fieldLabel: '부서', 
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
						gsWhCode = records[0]['WH_CODE'];
						var whStore = panelResult.getField('WH_CODE').getStore();							
						console.log("whStore : ",whStore);							
						whStore.clearFilter(true);
						whStore.filter([
							 {property:'option', value:panelResult.getValue('DIV_CODE')}
							,{property:'value', value: records[0]['WH_CODE']}
						]);
						panelResult.getField('WH_CODE').setValue(records[0]['WH_CODE']);
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
					
					if(authoInfo == "A"){	//자기사업장	
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),{
			name: 'WH_CODE',
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>', 
			xtype:'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList'),
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		}]
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('biv200skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
        	
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [
        	{dataIndex:'DEPT_CODE' 				, width: 80 },
        	{dataIndex:'DEPT_NAME' 				, width: 105 },
        	{dataIndex:'WH_CODE' 				, width: 90,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
            {dataIndex:'WH_NAME' 				, width: 150 },
        	{dataIndex:'PROD_ITEM_CODE' 		, width: 120 },
        	{dataIndex:'PROD_ITEM_NAME' 		, width: 150 },
        	{dataIndex:'PROD_ITEM_ALIAS' 		, width: 150,hidden: true },
        	{dataIndex:'SALE_Q' 				, width: 80, summaryType:'sum',
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {    		
    			if(record.get('SALE_Q') == 0){
                    return '';
    			}else{
    				return Ext.util.Format.number(val,'0,000');
    			}
    		}},
        	{dataIndex:'ITEM_CODE' 				, width: 110 },
        	{dataIndex:'ITEM_NAME' 				, width: 150 },
        	{dataIndex:'INOUT_Q' 				, width: 80, summaryType:'sum' },
        	{dataIndex:'END_STOCK_Q' 			, width: 80 },
        	{dataIndex:'STOCK_Q' 				, width: 80, hidden: true },
        	{dataIndex:'INOUT_TYPE_DETAIL' 		, width: 100 },
        	{dataIndex:'INOUT_DATE' 			, width: 80 },
        	{dataIndex:'INOUT_NUM' 				, width: 120 },
        	{dataIndex:'INOUT_SEQ' 				, width: 60 },
        	{dataIndex:'INSERT_DB_TIME' 			, width: 90 },
        	{dataIndex:'INSERT_DB_USER' 			, width: 90 },        	
        	{dataIndex:'LOT_NO' 				, width: 105, hidden: true },
        	{dataIndex:'SEQ' 					, width: 80, hidden: true }
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
		id: 'biv200skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('BASIS_YYMM', UniDate.get('today'));
			panelResult.setValue('BASIS_YYMM', UniDate.get('today'));
			biv200skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true); 
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.reset();
			masterGrid.reset();
			panelResult.reset();
			this.fnInitBinding();
			MasterStore.clearData();
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
