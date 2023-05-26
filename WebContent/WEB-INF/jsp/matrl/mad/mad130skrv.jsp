<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mad130skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="mad130skrv"  /> 				<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	
	Unilite.defineModel('Mad130skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string',comboType:'BOR120'},
	    	
	    	{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
	    	{name: 'INOUT_DATE'			, text: '거래일자'		, type: 'uniDate'},
	    	{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.tranno" default="수불번호"/>'		, type: 'string'},
	    	
	    	{name: 'SUM_INOUT_Q'		, text: '<t:message code="system.label.purchase.qty" default="수량"/>'		, type: 'uniQty'},
	    	{name: 'SUM_INOUT_I'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'		, type: 'uniPrice'},
	    	{name: 'SUM_INOUT_TAX_AMT'	, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'		, type: 'uniPrice'},
	    	{name: 'TOTAL_SUM_INOUT_I'		, text: '입고합계'		, type: 'uniPrice'},
	    	
	    	{name: 'SUM_RETURN_Q'		, text: '<t:message code="system.label.purchase.qty" default="수량"/>'		, type: 'uniQty'},
	    	{name: 'SUM_RETURN_I'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'		, type: 'uniPrice'},
	    	{name: 'SUM_RETURN_TAX_AMT'	, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'		, type: 'uniPrice'},
	    	{name: 'TOTAL_SUM_RETURN_I'		, text: '반품합계'		, type: 'uniPrice'}
	    	
	    ]
	});//End of Unilite.defineModel('Mad130skrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mad130skrvMasterStore1', {
		model: 'Mad130skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'mad130skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();		
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
				
		}/*,
		groupField: 'CUSTOM_NAME'
			*/
	});//End of var directMasterStore1 = Unilite.createStore('mad130skrvMasterStore1', {
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	 var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				child:'WH_CODE',
		        value:UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
						panelResult.setValue('DIV_CODE', newValue);
						var field2 = panelResult.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
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
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>', 
				name: 'WH_CODE', 
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('INOUT_DATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INOUT_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE', 
				textFieldName: 'CUSTOM_NAME', 
				//validateBlank:false, 
				popupWidth: 710,
				extParam: {'CUSTOM_TYPE': ['1','2']},
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType: 'BOR120', 
			allowBlank: false,
			child:'WH_CODE',
	        value:UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					combo.changeDivCode(combo, newValue, oldValue, eOpts);						
					panelSearch.setValue('DIV_CODE', newValue);
					var field2 = panelSearch.getField('WH_CODE');		
					field2.getStore().clearFilter(true);
				}
			}
		},
		Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
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
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>', 
				name: 'WH_CODE', 
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				colspan: '2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WH_CODE', newValue);
					}
				}
		},{
			fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			startDate: UniDate.get('today'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('INOUT_DATE_TO',newValue);
		    	}
		    }
		},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE', 
				textFieldName: 'CUSTOM_NAME', 
				//validateBlank:false,
				popupWidth: 710,
				extParam: {'CUSTOM_TYPE': ['1','2']},
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
			})]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('mad130skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		excelTitle: '거래처별 일자별 입고현황조회',
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
    	store: directMasterStore1,
        columns: [
        	{dataIndex: 'COMP_CODE'					, width: 80,hidden:true},
		    {dataIndex: 'DIV_CODE'					, width: 90,hidden:true},
		    
        	{dataIndex: 'CUSTOM_CODE'         		, width: 120,hidden:true},
        	{dataIndex: 'CUSTOM_NAME'				, width: 150,hidden:true},
        	{dataIndex: 'INOUT_DATE'				, width: 100,
               summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
        	{dataIndex: 'INOUT_NUM'					, width: 150},
        	
			{ 
         	text:'입고',
         		columns: [
		         	{dataIndex: 'SUM_INOUT_Q'		, width: 88,summaryType: 'sum'},
		        	{dataIndex: 'SUM_INOUT_I'		, width: 120,summaryType: 'sum'},
		        	{dataIndex: 'SUM_INOUT_TAX_AMT'	, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'TOTAL_SUM_INOUT_I'		, width: 120,summaryType: 'sum'}
	         	]
			},{ 
         	text:'반품',
         		columns: [
		         	{dataIndex: 'SUM_RETURN_Q'		, width: 88,summaryType: 'sum'},
		        	{dataIndex: 'SUM_RETURN_I'		, width: 120,summaryType: 'sum'},
		        	{dataIndex: 'SUM_RETURN_TAX_AMT', width: 90,summaryType: 'sum'},
		        	{dataIndex: 'TOTAL_SUM_RETURN_I'		, width: 120,summaryType: 'sum'}
	         	]
			}],
			listeners: {
				onGridDblClick: function(grid, record, cellIndex, colName) {
					var params = {
						action: 'new',
						INOUT_DATE : record.get('INOUT_DATE'),
						DIV_CODE : panelSearch.getValue('DIV_CODE'),
						DEPT_CODE : panelSearch.getValue('DEPT_CODE'),
						DEPT_NAME : panelSearch.getValue('DEPT_NAME'),
						WH_CODE : panelSearch.getValue('WH_CODE'), 
						CUSTOM_CODE : panelSearch.getValue('CUSTOM_CODE'),
						CUSTOM_NAME : panelSearch.getValue('CUSTOM_NAME')
					}
					var rec = {data : {prgID : 'mtr111skrv'}};							
						parent.openTab(rec, '/matrl/'+'mtr111skrv'+'.do', params);	
				}
			}
    });//End of var masterGrid = Unilite.createGrid('ssd100skrvGrid1', {  
	
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
		id: 'mad130skrvApp',
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons('detail',false);
			//UniAppManager.setToolbarButtons('reset',false);
//			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INOUT_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('INOUT_DATE_TO',UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_FR',UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_TO',UniDate.get('today'));
			
			UniAppManager.app.processParams(params);
			if(params && params.CUSTOM_CODE){
				masterGrid.getStore().loadStoreRecords();	
			}
		/*	mad130skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
					
					
				}
			});*/
			
			
			
		},
		onQueryButtonDown: function() {
			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();/*
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);*/
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
        },
        processParams: function(params) {
			this.uniOpt.appParams = params;		
			if(params) {
				if(params.action == 'new') {
		//				alert('assd')
					panelSearch.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					panelSearch.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					panelResult.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					panelResult.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					panelSearch.setValue('DIV_CODE', params.DIV_CODE);
					panelResult.setValue('DIV_CODE', params.DIV_CODE);
					panelSearch.setValue('DEPT_CODE', params.DEPT_CODE);
					panelResult.setValue('DEPT_CODE', params.DEPT_CODE);
					panelSearch.setValue('DEPT_NAME', params.DEPT_NAME);
					panelResult.setValue('DEPT_NAME', params.DEPT_NAME);
					panelSearch.setValue('WH_CODE', params.WH_CODE);
					panelResult.setValue('WH_CODE', params.WH_CODE);
					panelSearch.setValue('INOUT_DATE_FR', params.INOUT_DATE_FR);
					panelResult.setValue('INOUT_DATE_FR', params.INOUT_DATE_FR);
					panelSearch.setValue('INOUT_DATE_TO', params.INOUT_DATE_TO);
					panelResult.setValue('INOUT_DATE_TO', params.INOUT_DATE_TO);
				}
			}
		}
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});
	
/*	Ext.define('chartModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 'name', 'value'],
	    
	    fields: [ 'name1', 'value'],
	    fields: [ 'name2', 'value'],
	    fields: [ 'name3', 'value'],
	    fields: [ 'name4', 'value'],
	    fields: [ 'name5', 'value'],
	    fields: [ 'name6', 'value']
	});
	var chartStore = new Ext.data.SimpleStore({
  		model:'chartModel'
	});
	
	var chart = Ext.create('Ext.chart.Chart', {
        animate: true,
        shadow: true,
        store: chartStore,
        axes: [{
            type: 'Numeric',
            position: 'bottom',
            fields: ['value'],
            label: {
                renderer: Ext.util.Format.numberRenderer('0,0')
            },
            title: '매 입 수 량',
            grid: true,
            minimum: 0
        }, {
            type: 'Category',
            position: 'left',
            fields: ['name'],
            title: '거 래 처 명'
        }],
        theme: 'Base:gradients',
        background: {
            gradient: {
                id: 'backgroundGradient',
                angle: 45,
                stops: {
                    0: {
                        color: '#ffffff'
                    },
                    100: {
                        color: '#eaf1f8'
                    }
                }
            }
        },
        series: [{
            type: 'bar',
            axis: 'bottom',
            highlight: true,
            tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('name') + ': ' + storeItem.get('value') + ' views');
                }
            },
            label: {
              display: 'insideEnd',
                  field: 'data1',
                  renderer: Ext.util.Format.numberRenderer('0'),
                  orientation: 'horizontal',
                  color: '#333',
                'text-anchor': 'middle'
            },
            xField: 'name',
            yField: ['value']
        }]
    });
	
	
    var panel1 = Ext.create('widget.window', {
	        width: 800,
	        height: 600,
	        model: true,
	        layout: 'fit',
	        items: chart,
            closeAction: 'hide',
	        tbar: [
	        	{ 
		        	text: 'Reload Data',
		            handler: function() {
		                // Add a short delay to prevent fast sequential clicks
		            	console.log('t');
		                // window.loadTask.delay(100, function() {
		                    //store1.loadData(generateData(6, 20));
		                //});
		            	//alert('1231');
		            }
	           }
	        ]
	    });
	    
	var btnChart = {
			xtype:'uniBaseButton',	iconCls: 'icon-chart',
			text : 'Chart',tooltip : 'Chart', disabled: false,
			width: 26, height: 26,
	 		itemId : 'chart',
			handler : function() {
				chartStore.removeAll();
				//directMasterStore.each(function(rec) {
				directMasterStore1.getGroups().each(function(rec) {
                        //total += rec.get('data1');
					var key = rec.key;
					var sum =0;
					Ext.Array.each(rec.records, function(sRec) {
							sum+= sRec.get('SUM_INOUT_Q');
					});
                    chartStore.add({
                    	name: key ,
                    	value: sum
                    });
                });
				panel1.show() ;
			}
	};
	UniAppManager.addButton(btnChart);*/

};


</script>
