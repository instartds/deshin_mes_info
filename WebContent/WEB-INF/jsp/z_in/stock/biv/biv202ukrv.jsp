<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv202ukrv"  >
<t:ExtComboStore comboType="BOR120"  pgmId="biv202ukrv"/> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />		<!--창고-->
<t:ExtComboStore comboType="AU" comboCode="M104" /> <!--출고유형-->
<t:ExtComboStore comboType="AU" comboCode="B017" /> <!--원미만계산-->

</t:appConfig>
<script type="text/javascript" >

var gsWhCode = '';		//창고코드



function appMain() {	
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'biv202ukrvService.selectList2',
			update: 'biv202ukrvService.updateDetail',
			create: 'biv202ukrvService.insertDetail',
			destroy: 'biv202ukrvService.deleteDetail',
			syncAll: 'biv202ukrvService.saveAll'
		}
	});	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('biv202ukrvModel', {
	    fields: [
	    	
	    	{name:'DEPT_CODE' 				, text: '부서코드'		, type: 'string'},
	    	{name:'DEPT_NAME' 				, text: '부서명'		, type: 'string'},
	    	{name:'WH_CODE' 				, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'		, type: 'string'},
	    	{name:'WH_NAME' 				, text: '창고명'		, type: 'string'},
	    	{name:'PROD_ITEM_CODE' 			, text: '제조품목'		, type: 'string'},
	    	{name:'PROD_ITEM_NAME' 			, text: '제조품명'		, type: 'string'},
	    	{name:'PROD_ITEM_ALIAS' 		, text: '제조품명'		, type: 'string'},
	    	{name:'SALE_Q' 					, text: '판매수량'		, type: 'uniQty'}
	    ]	    
	});		
	Unilite.defineModel('biv202ukrvModel2', {
	    fields: [  
	    	{name:'CHECK' 					, text: 'CHECK' 	          , type: 'string'},
	    	{name:'FLAG' 					, text: 'FLAG' 		          , type: 'string'},
	    	{name:'CONFIRM_FLAG' 			, text: '확정/미확정' 	      , type: 'string'},
	    	{name:'CONFIRM_FLAG_DUMMY' 		, text: 'CONFIRM_FLAG_DUMMY'  , type: 'string'},
	    	{name:'ITEM_CODE' 				, text: '원자재품목'	      , type: 'string'},
	    	{name:'ITEM_NAME' 				, text: '원자재품명'	      , type: 'string'},
	    	{name:'INOUT_Q' 				, text: '순투입수량' 	      , type: 'number'},
	    	{name:'CALC_INOUT_Q' 			, text: '실투입수량' 	      , type: 'number'},
	    	{name:'END_STOCK_Q' 			, text: '월말재고량'	      , type: 'uniQty'},
	    	{name:'STOCK_Q' 				, text: '현재고량' 	          , type: 'uniQty'},
	    	{name:'INOUT_TYPE_DETAIL' 		, text: '출고유형'		      , type: 'string', comboType:'AU', comboCode:'M104'},
	    	{name:'INOUT_DATE' 				, text: '출고일'  	          , type: 'uniDate'},
	    	{name:'INOUT_NUM' 				, text: '출고번호' 	          , type: 'string'},
	    	{name:'INOUT_SEQ' 				, text: '순번'   		      , type: 'int'},
	    	{name:'INSERT_DB_TIME' 			, text: '등록일자' 	          , type: 'uniDate'},
	    	{name:'INSERT_DB_USER' 			, text: '등록자ID'   	      , type: 'string'},	    		
	    	{name:'LOT_NO' 					, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'	          , type: 'string'},
	    	{name:'SEQ' 					, text: '처리순번' 	          , type: 'int'},
	    	{name:'LEVEL' 					, text: 'LEVEL' 	          , type: 'string'},
	    	{name:'SALE_Q' 					, text: '판매수량' 	          , type: 'uniQty'}
		]  
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var masterStore = Unilite.createStore('biv202ukrvmasterStore',{
			model: 'biv202ukrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
				type: 'direct',
				api: {			
					read: 'biv202ukrvService.selectList'                	
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
			groupField: 'DEPT_NAME'
			
	});		
	var masterStore2 = Unilite.createStore('biv202ukrvmasterStore2',{
			model: 'biv202ukrvModel2',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
            saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		

							masterStore2.loadStoreRecords();	
						
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('biv202ukrvGrid2');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
			}
			
			
	});		
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
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				child:'WH_CODE',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				} 
			},{
				fieldLabel: '매출일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('SALE_DATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult && panelResult) {
			    		panelResult.setValue('SALE_DATE_TO',newValue);
			    		panelResult.setValue('INOUT_DATE', newValue);
			    		panelSearch.setValue('INOUT_DATE', newValue);
			    	}
			    }
			    
			},{
				xtype: 'uniDatefield',
				fieldLabel: '출고일자',
				name: 'INOUT_DATE',
				value: UniDate.get('today'),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {						
						panelResult.setValue('INOUT_DATE', newValue);
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
				 }),
			{
				fieldLabel: '원미만계산',
				name: 'WON_CALC_BAS',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B017',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WON_CALC_BAS', newValue);
					}
				}
			},
				 
				 
				 
				 /*{
					xtype: 'radiogroup',		            		
					fieldLabel: '출고처리여부',						            		
					labelWidth:90,
//					colspan:2,
					items : [{
						boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
						width: 60,
						name: 'CHECKING',
						inputValue: 'N',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
						width: 60,
						name: 'CHECKING',
						inputValue: 'Y'
					}],
					listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								panelResult.getField('CHECKING').setValue(newValue.CHECKING);
							}
						}
				},*/{
					fieldLabel:'그리드_부서코드',
					xtype:'uniTextfield',
					name: 'DEPT_CODE_G',
					hidden: true
				},{
					fieldLabel:'그리드_창고코드',
					xtype:'uniTextfield',
					name: 'WH_CODE_G',
					hidden: true
				},{
					fieldLabel:'그리드_제조품목',
					xtype:'uniTextfield',
					name: 'PROD_ITEM_CODE_G',
					hidden: true
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
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
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			child:'WH_CODE',
			allowBlank: false,
			holdable: 'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			} 
		},{
				fieldLabel: '매출일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('SALE_DATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch && panelResult) {
			    		panelSearch.setValue('SALE_DATE_TO',newValue);
			    		panelSearch.setValue('INOUT_DATE', newValue);	
			    		panelResult.setValue('INOUT_DATE', newValue);
			    	}
			    }
			},{
				xtype: 'uniDatefield',
				fieldLabel: '출고일자',
				name: 'INOUT_DATE',
				value: UniDate.get('today'),
				holdable: 'hold',
				allowBlank: false,
				colspan:2,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {						
						panelSearch.setValue('INOUT_DATE', newValue);
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
		},
		{
				fieldLabel: '원미만계산',
				name: 'WON_CALC_BAS',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B017',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WON_CALC_BAS', newValue);
					}
				}
			}/*{
					xtype: 'radiogroup',		            		
					fieldLabel: '출고처리여부',						            		
					labelWidth:90,
//					colspan:2,
					items : [{
						boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
						width: 60,
						name: 'CHECKING',
						inputValue: 'N',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
						width: 60,
						name: 'CHECKING',
						inputValue: 'Y'
					}],
					listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								panelSearch.getField('CHECKING').setValue(newValue.CHECKING);
							}
						}
				}*/],
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
    var masterGrid = Unilite.createGrid('biv202ukrvGrid', {
    	region: 'center',
        store : masterStore,
        excelTitle: '제조품실적처리(master)',
        uniOpt:{
        	onLoadSelectFirst: false, 
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
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
    		}}
        	
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					panelSearch.setValue('DEPT_CODE_G',record.get('DEPT_CODE'));
					panelSearch.setValue('WH_CODE_G',record.get('WH_CODE'));
					panelSearch.setValue('PROD_ITEM_CODE_G',record.get('PROD_ITEM_CODE'));
					
					masterStore2.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
			},
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			}
		}
    });		
    var masterGrid2 = Unilite.createGrid('biv202ukrvGrid2', {
    	region: 'east',
    	split:true,
        store : masterStore2,
        excelTitle: '제조품실적처리(detail)',
        uniOpt:{
        	onLoadSelectFirst: false, 
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', {
//        	suppressEvent : true,
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			
        		},
				select: function(grid, record, index, eOpts ){					
					var records = masterGrid.getSelectedRecords();
					if(records.length > 0){
						UniAppManager.setToolbarButtons('save',true);
						
					}
					if(record.get('FLAG')=='N'){		//출고처리여부 아니오면 플래그 1
						record.set('CHECK','1');		//체크 1이면 OPR_FLAG N 
						record.set('CONFIRM_FLAG','확정');
					}else{
						record.set('CHECK','2');		//체크 2이면 OPR_FLAG D
						record.set('CONFIRM_FLAG','취소');
					}
	          	},
				deselect:  function(grid, record, index, eOpts ){
					
					record.set('CHECK','');
					record.set('CONFIRM_FLAG',record.get('CONFIRM_FLAG_DUMMY'));
					
					
					var records = masterGrid.getSelectedRecords();
					if(records.length < 1){
						UniAppManager.setToolbarButtons('save',false);
					}
					
        		}
        	}
        }),
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [  
        	{dataIndex:'CHECK' 					, width: 80,hidden:true },
        	{dataIndex:'FLAG' 					, width: 80,hidden:true },
        	{dataIndex:'CONFIRM_FLAG' 			, width: 80 ,align:'center'},
        	{dataIndex:'CONFIRM_FLAG_DUMMY' 	, width: 80,hidden:true },
        	{dataIndex:'ITEM_CODE' 				, width: 110 },
        	{dataIndex:'ITEM_NAME' 				, width: 150 },
        	{dataIndex:'INOUT_Q' 				, width: 80, summaryType:'sum',format:'0,000.000'},
        	{dataIndex:'CALC_INOUT_Q' 			, width: 80, summaryType:'sum',format:'0,000.000'},
        	{dataIndex:'END_STOCK_Q' 			, width: 80, hidden: true },
        	{dataIndex:'STOCK_Q' 				, width: 80, hidden: true },
        	{dataIndex:'INOUT_TYPE_DETAIL' 		, width: 100,align:'center' },
        	{dataIndex:'INOUT_DATE' 			, width: 80 },
        	{dataIndex:'INOUT_NUM' 				, width: 120 },
        	{dataIndex:'INOUT_SEQ' 				, width: 60 },
        	{dataIndex:'INSERT_DB_TIME' 		, width: 90 },
        	{dataIndex:'INSERT_DB_USER' 		, width: 90 },        	
        	{dataIndex:'LOT_NO' 				, width: 105, hidden: true },
        	{dataIndex:'SEQ' 					, width: 80, hidden: true },
        	{dataIndex:'LEVEL' 					, width: 80, hidden: true },
        	{dataIndex:'SALE_Q' 				, width: 80, hidden: true }
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			}
		}
    });
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
           		masterGrid,masterGrid2, panelResult
         	]	
      	},
      	panelSearch     
      	],
		id: 'biv202ukrvApp',
		fnInitBinding: function() {
			
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('save', false);
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			
			panelSearch.setValue('SALE_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('SALE_DATE_TO', UniDate.get('today'));
			
			panelSearch.setValue('INOUT_DATE', UniDate.get('today'));
			panelResult.setValue('INOUT_DATE', UniDate.get('today'));
			
			panelSearch.setValue('WON_CALC_BAS', '3');
			panelResult.setValue('WON_CALC_BAS', '3');
		/*	biv202ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})*/
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterStore.loadStoreRecords();
			beforeRowIndex = -1;
			
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {		// 초기화
//			this.suspendEvents();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.reset();
			masterGrid.reset();
			masterGrid2.reset();
			panelResult.reset();
			
			masterStore.clearData();
			masterStore2.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {				
			masterStore2.saveStore();
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
