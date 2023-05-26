<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv201skrv"  >
<t:ExtComboStore comboType="BOR120"  pgmId="biv201skrv"/> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />		<!--창고-->
<t:ExtComboStore comboType="AU" comboCode="M104" /> <!--출고유형-->

</t:appConfig>
<script type="text/javascript" >

var gsWhCode = '';		//창고코드



function appMain() {	
	
	
	/*var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'biv201skrvService.selectList',
			update: 'biv201skrvService.updateDetail',
			create: 'biv201skrvService.insertDetail',
			destroy: 'biv201skrvService.deleteDetail',
			syncAll: 'biv201skrvService.saveAll'
		}
	});	*/
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('biv201skrvModel', {
	    fields: [
	    	{name:'DEPT_CODE' 				, text: '부서코드'		, type: 'string'},
	    	{name:'DEPT_NAME' 				, text: '부서명'		, type: 'string'},
	    	{name:'WH_CODE' 				, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'		, type: 'string'},
	    	{name:'WH_NAME' 				, text: '창고명'		, type: 'string'},
	    	{name:'PROD_ITEM_CODE' 			, text: '제조품목'		, type: 'string'},
	    	{name:'PROD_ITEM_NAME' 			, text: '제조품명'		, type: 'string'},
	    	{name:'PROD_ITEM_ALIAS' 		, text: '제조품명'		, type: 'string'},
	    	{name:'SALE_Q' 					, text: '판매수량'		, type: 'uniQty'},
	    	{name:'SEQ' 					, text: '순번' 		, type: 'int'},
	    	{name:'ITEM_CODE' 				, text: '원자재품목'	, type: 'string'},
	    	{name:'ITEM_NAME' 				, text: '원자재품명'	, type: 'string'},
	    	{name:'INOUT_Q' 				, text: '순투입수량' 	, type: 'number'},
	    	{name:'CALC_INOUT_Q' 			, text: '실투입수량' 	, type: 'number'},
	    	{name:'UNIT_Q' 					, text: '원단위량'		, type: 'number'},
	    	{name:'PROD_UNIT_Q' 			, text: '모품목기준수'	, type: 'uniQty'},
	    	{name:'LOSS_RATE' 				, text: '로스율'		, type: 'uniER'}
	    ]	    
	});		//End of Unilite.defineModel
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var masterStore = Unilite.createStore('biv201skrvmasterStore',{
			model: 'biv201skrvModel',
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
					read: 'biv201skrvService.selectList'                	
				}
			},
            /*saveStore: function() {				
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
//						masterStore.loadStoreRecords();
						
					
							masterStore.loadStoreRecords();	
						
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('biv201skrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},*/
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
			
			
	});		// End of var masterStore 
	
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
				 })/*,{
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
				}*/]
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
		layout : {type : 'uniTable', columns : 3},
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
		}/*,{
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
    var masterGrid = Unilite.createGrid('biv201skrvGrid', {
    	region: 'center',
        layout : 'fit',
        excelTitle: '제조품 실적현황',
        store : masterStore,
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
      /*  selModel: Ext.create('Ext.selection.CheckboxModel', {
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			
        		},
				select: function(grid, record, index, eOpts ){					
					var records = masterGrid.getSelectedRecords();
					if(records.length > '0'){
						UniAppManager.setToolbarButtons('save',true);
						
					}
					if(record.get('FLAG')=='N'){		//출고처리여부 아니오면 플래그 1
						record.set('CHECK','1');		//체크 1이면 OPR_FLAG N 
					}else{
						record.set('CHECK','2');		//체크 2이면 OPR_FLAG D
					}
	          	},
				deselect:  function(grid, record, index, eOpts ){
					
					record.set('CHECK','');
					
					var records = masterGrid.getSelectedRecords();
					if(records.length < '1'){
						UniAppManager.setToolbarButtons('save',false);
					}
					
        		}
        	}
        }),*/
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [
        	{dataIndex:'DEPT_CODE' 				, width: 80 },
        	{dataIndex:'DEPT_NAME' 				, width: 90,align:'center' },
        	{dataIndex:'WH_CODE' 				, width: 80,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
            {dataIndex:'WH_NAME' 				, width: 90,align:'center' },
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
    		{dataIndex:'SEQ' 					, width: 80 },
        	{dataIndex:'ITEM_CODE' 				, width: 110 },
        	{dataIndex:'ITEM_NAME' 				, width: 150 },
        	{dataIndex:'INOUT_Q' 				, width: 80, summaryType:'sum',format:'0,000.000'},
        	{dataIndex:'CALC_INOUT_Q' 			, width: 80, summaryType:'sum',format:'0,000.000'},
        	{dataIndex:'UNIT_Q' 				, width: 110 ,format:'0,000.000'},
        	{dataIndex:'PROD_UNIT_Q'			, width: 110 },
        	{dataIndex:'LOSS_RATE' 				, width: 110 }
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			}
		}
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
		id: 'biv201skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset', true); 
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
		/*	biv201skrvService.userWhcode({}, function(provider, response)	{
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
			masterGrid.getStore().loadStoreRecords();
			
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {		// 초기화
//			this.suspendEvents();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.reset();
			masterGrid.reset();
			panelResult.reset();
			
			masterStore.clearData();
			this.fnInitBinding();
		},
		/*onSaveDataButtonDown: function(config) {				
			masterStore.saveStore();
		},*/
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
