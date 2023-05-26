<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="pos110skrv"  >
<t:ExtComboStore items="${COMBO_POS_NO}" storeId="PosNo" /><!--POS 명-->
<t:ExtComboStore comboType="BOR120" pgmId="pos110skrv"/> 						<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('pos110skrvModel', {
	    fields: [
	    	{name:'POS_NUM' 	, text: 'POS'		, type: 'string'},
	    	{name:'POS_NAME' 	, text: 'POS명'		, type: 'string'},
	    	{name:'POS_CODE' 	, text: 'POS'		, type: 'string' ,store:Ext.data.StoreManager.lookup('PosNo')},
	    	{name:'GUBUN' 		, text: '구분'		, type: 'string'},
	    	{name:'SUMMARY' 	, text: '합계'		, type: 'uniPrice'},
	    	{name:'C08' 		, text: '08~09'		, type: 'uniPrice'},
	    	{name:'C09' 		, text: '09~10'		, type: 'uniPrice'},
	    	{name:'C10' 		, text: '10~11'		, type: 'uniPrice'},
	    	{name:'C11' 		, text: '11~12'		, type: 'uniPrice'},
	    	{name:'C12' 		, text: '12~13'		, type: 'uniPrice'},
	    	{name:'C13' 		, text: '13~14'		, type: 'uniPrice'},
	    	{name:'C14' 		, text: '14~15'		, type: 'uniPrice'},
	    	{name:'C15' 		, text: '15~16'		, type: 'uniPrice'},
	    	{name:'C16' 		, text: '16~17'		, type: 'uniPrice'},
	    	{name:'C17' 		, text: '17~18'		, type: 'uniPrice'},
	    	{name:'C18' 		, text: '18~19'		, type: 'uniPrice'},
	    	{name:'C19' 		, text: '19~24'		, type: 'uniPrice'},
	    	{name:'SALE_DATE' 	, text: '매출일'		, type: 'uniDate'},
	    	{name:'SALE_TIME' 	, text: '매출시간'		, type: 'uniDate'}
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
	var MasterStore = Unilite.createStore('pos110skrvMasterStore',{
			model: 'pos110skrvModel',
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
               		read: 'pos110skrvService.selectList'
                }
            },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			},
			groupField: 'POS_NUM',
			listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
			}
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
        	},
        		Unilite.popup('DEPT',{
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
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
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('BILL_DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
				fieldLabel: 'POS',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				store:Ext.data.StoreManager.lookup('PosNo'),
		        multiSelect: true, 
		        typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('POS_CODE', newValue);
					},
					beforequery: function(queryPlan, eOpts ) {
				        var pValue = panelSearch.getValue('DIV_CODE');
				        var store = queryPlan.combo.getStore();
				        if(!Ext.isEmpty(pValue)) {
				        	store.clearFilter(true);
				        	queryPlan.combo.queryFilter = null;    
				         	store.filter('option', pValue);
				        }else {
					         store.clearFilter(true);
					         queryPlan.combo.queryFilter = null; 
					         store.loadRawData(store.proxy.data);
				        }
				     }
				}
			},{
				fieldLabel: '매출일',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
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
			}
			/*,{
				xtype: 'checkbox',  
				name: 'ITEM_ACCOUNT', 
				inputValue :'Y', 				
				fieldLabel:'수탁상품',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			}*/
			]
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
					} else {}
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
        	},
        		Unilite.popup('DEPT',{
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
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
						},
						beforequery: function(queryPlan, eOpts ) {
					        var pValue = panelSearch.getValue('DIV_CODE');
					        var store = queryPlan.combo.getStore();
					        if(!Ext.isEmpty(pValue)) {
					        	store.clearFilter(true);
					        	queryPlan.combo.queryFilter = null;    
					         	store.filter('option', pValue);
					        }else {
						         store.clearFilter(true);
						         queryPlan.combo.queryFilter = null; 
						         store.loadRawData(store.proxy.data);
					        }
					     }
					}
			},{
				fieldLabel: '매출일',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				colspan:2,
				width: 350,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('SALE_DATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('SALE_DATE_TO',newValue);		    		
			    	}
			    }
			}
/*			,{
				xtype: 'checkbox',  
				name: 'ITEM_ACCOUNT', 
				inputValue :'Y', 				
				fieldLabel:'수탁상품',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			}*/
			]
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('pos110skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore,
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
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
        columns:  [
			{dataIndex:'POS_NUM'  	 	, width: 60, locked: true},
			{dataIndex:'POS_NAME'	 	, width: 140, locked: true},                                      
			{dataIndex:'GUBUN' 		 	, width: 85, locked: true},      
			{dataIndex:'SUMMARY' 	 	, width: 150},    
			{dataIndex:'C08' 	 		, width: 85},                                       	
			{dataIndex:'C09' 	 		, width: 85},                                       	
			{dataIndex:'C10' 	 		, width: 85},                                       	
			{dataIndex:'C11' 	 		, width: 85},
			{dataIndex:'C12' 	 		, width: 85},
			{dataIndex:'C13' 	 		, width: 85},
			{dataIndex:'C14' 	 		, width: 85},
			{dataIndex:'C15' 	 		, width: 85},
			{dataIndex:'C16' 	 		, width: 85},
			{dataIndex:'C17' 	 		, width: 85},
			{dataIndex:'C18' 	 		, width: 85},
			{dataIndex:'C19' 	 		, width: 85}
		]
    });		//End of var masterGrid 
	
    /*Ext.define('chartModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 'name', 'value']
	});
    
	var chartStore = new Ext.data.SimpleStore({
  		model:'chartModel'
	});

    var chartGird = {
	    	xtype: 'chart',
	    	region: 'south' ,
	        width: '80%',
	        height: '40%',
	        padding: '5 0 0 0',
	        animate: true,
	        shadow: false,
            style: 'background: #fff;',
            legend: {
                position: 'right'
            },
            store: chartStore,
            axes: [{
                type: 'Numeric',
                fields: ['data1', 'data2', 'data3', 'data4' ,"SALE_TIME" ],
                position: 'left',
                grid: true,
                minimum: 0
            }, {
                type: 'Category',
                fields: 'name',
                position: 'bottom',
                grid: true,
                label: {
                    rotate: {
                        degrees: -45   // 기울기 45
                    }
                }
            }],
            series: [{
                type: 'line',
                axis: 'left',
                field: 'value',
                title: '하얀샘',
                xField: 'name',
                yField: 'data1',
                style: {
                    'stroke-width': 4
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('POS_NO') + ': ' + storeItem.get(item.series.yField));
                    }
                }
            }, {
                type: 'line',
                axis: 'left',
                title: '솟을샘',
                xField: 'name',
                yField: 'data2',
                style: {
                    'stroke-width': 4
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('SALE_TIME') + ': ' + storeItem.get(item.series.yField));
                    }
                }
            }, {
                type: 'line',
                axis: 'left',
                title: '한울샘',
                xField: 'name',
                yField: 'data3',
                style: {
                    'stroke-width': 2
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('SALE_TIME') + ': ' + storeItem.get(item.series.yField));
                    }
                }
            }, {
                type: 'line',
                axis: 'left',
                title: '이슬샘',
                xField: 'name',
                yField: 'data4',
                style: {
                    'stroke-width': 2
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('SALE_TIME') + ': ' + storeItem.get(item.series.yField));
                    }
                }
           }]
    };
    
       var itemCol = {
	        items: [{
	           title: '시간대별매출현황',
	           layout: 'fit',
	           items: [chartGird]
	        }]
	    };*/
    
    
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
           		masterGrid , panelResult
         	]	
      	},
      	panelSearch     
      	],
		id: 'pos110skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('save',false);
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			/*panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME', UserInfo.deptName);*/
			
			panelSearch.setValue('SALE_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_TO',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_TO',UniDate.get('today'));
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			UniAppManager.setToolbarButtons(['print'], false);
			this.fnInitBinding();
		},
		
		onPrintButtonDown: function() {
	         var param= Ext.getCmp('searchForm').getValues();
	
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/pos/pos110rkrPrint.do',
	            prgID: 'pos110rkr',
	               extParam: {
	                  DIV_CODE  	: param.DIV_CODE,
	                  DEPT_CODE 	: param.DEPT_CODE,
	                  POS_CODE		: param.POS_CODE,
	                  SALE_DATE_FR  : param.SALE_DATE_FR,
	                  SALE_DATE_TO	: param.SALE_DATE_TO
	               }
	            });
	            win.center();
	            win.show();
          
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
