<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="esa999skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="esa999skrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	
</t:appConfig>
<script type="text/javascript" >
var SearchInfoWindow;
function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	   
	Unilite.defineModel('esa999skrvModel1', {
	    fields: [
				  
                     { name: 'T_C1'     ,text:'테스트1'            ,type: 'string'} 
                    ,{ name: 'T_C2'    ,text:'테스트2'       ,type: 'string' } 
                    ,{ name: 'T_C3'    ,text:'테스트3'     ,type: 'string' } 
			]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */	
	var directMasterStore = Unilite.createStore('esa999skrvMasterStore1',{
			model: 'esa999skrvModel1',
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
                	   read: 'esa999skrvService.selectList'                	
                }
            }
			,loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});				
			},
			
			listeners: {
           	load: function(store, records, successful, eOpts) {
//           		UniAppManager.app.cellProcess(masterGrid,0);
           	}
		}
			
			
			
			
//			groupField: 'ORDER_NUM'			
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="omegaplus.system.label.base.searchCondition"	    default="검색조건" />',         
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
			layout: {type: 'vbox', align: 'stretch'},
        	items: [{	
        		xtype: 'container',
        		layout: {type: 'uniTable', columns: 1},
        		items: [{
        			
        				
        			 
    				fieldLabel: '사업장',
    				name: 'DIV_CODE',
    				xtype: 'uniCombobox',
    				comboType: 'BOR120',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
    			}, Unilite.popup('AS_NUM', {
					fieldLabel: '접수번호',
					valueFieldName:'AS_NUM',
	                textFieldName:'AS_NUM',
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								panelResult.setValue("AS_NUM",records[0].AS_NUM);
							},
							scope: this
						},
						'onClear': function(type) {
							panelResult.setValue("AS_NUM","");
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				}),{
					fieldLabel: '접수일',
	 		        width: 315,
	                xtype: 'uniDateRangefield',
	                startFieldName: 'FR_DATE',
	                endFieldName: 'TO_DATE',
	                startDate: UniDate.get('startOfMonth'),
	                endDate: UniDate.get('today'),                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_DATE', newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TO_DATE', newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
	            },
	            {
					fieldLabel: '완료예정일',
	 		        width: 315,
	                xtype: 'uniDateRangefield',
	                startFieldName: 'FR_DATE2',
	                endFieldName: 'TO_DATE2',
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_DATE2', newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TO_DATE2', newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
	            },
	            {
	    			fieldLabel: '수주번호',
	    			name: 'ORDER_NUM',
//	    			padding:5,
	    			xtype: 'uniTextfield',
	    			listeners: {
	    				change: function(field, newValue, oldValue, eOpts) {						
	    					//panelResult.getField('RDO').setValue({RDO: newValue});
	    					panelResult.getField('ORDER_NUM').setValue(newValue);
	    				}
	    			}
/* 	    			,
	    			listeners:{
	    				render: function(p) { 
	    				     p.getEl().on('click', function(p){ 
	    				                //处理点击事件代码 
	    				    	 openSearchInfoWindow();     
	    				      }); 
	    				}
	    				,change: function(field, newValue, oldValue, eOpts) {	
	    						panelResult.setValue('ORDER_NUM', newValue);
	    				}
	    			} */
	    		}
	    		,Unilite.popup('CUST',{
                    fieldLabel: '고객',
                    valueFieldName:'AS_CUSTOMER_CD',
                    textFieldName:'AS_CUSTOMER_NAME',
                    listeners: {
    					onSelected: {
    						fn: function(records, type) {
    							panelResult.getField('AS_CUSTOMER_CD').setValue(panelSearch.getValue("AS_CUSTOMER_CD"));
    							panelResult.getField('AS_CUSTOMER_NAME').setValue(panelSearch.getValue("AS_CUSTOMER_NAME"));
    	                	},
    						scope: this
    					},
    					onClear: function(type)	{
    						panelResult.getField('AS_CUSTOMER_CD').setValue("");
							panelResult.getField('AS_CUSTOMER_NAME').setValue("");
    					}
                    }
                })
                ,{
					fieldLabel: '접수구분',
					name: 'ACCEPT_GUBUN',
					xtype:'uniCombobox',
					comboType:'AU', 
//					padding:5,
					comboCode:'S801',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('RDO').setValue({RDO: newValue});
							panelResult.getField('ACCEPT_GUBUN').setValue(newValue);
						}
					}
				}
				,
				{
					fieldLabel: '진행상태',
					name: 'FINISH_YN',
					xtype:'uniCombobox',
					comboType:'AU', 
//					padding:5,
					comboCode:'B046',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('RDO').setValue({RDO: newValue});
							panelResult.getField('FINISH_YN').setValue(newValue);
						}
					}
				}
				
                ]            			 
			}]
		}]
    });
    
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
        		{
        			xtype:'button',
        			text:'테스트',
        			handler: function() {
        				UniAppManager.app.cellProcess(masterGrid,0);
					}
        			
        		},{ 
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},Unilite.popup('AS_NUM', {
			fieldLabel: '접수번호',
			valueFieldName:'AS_NUM',
            textFieldName:'AS_NUM',
			listeners: {
				'onSelected': {
					fn: function(records, type) {
						panelSearch.setValue("AS_NUM",records[0].AS_NUM);
					},
					scope: this
				},
				'onClear': function(type) {
					panelSearch.setValue("AS_NUM","");
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}), {
			fieldLabel: '접수일',
		        width: 315,
            xtype: 'uniDateRangefield',
            startFieldName: 'FR_DATE',
            endFieldName: 'TO_DATE',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
            		panelSearch.setValue('FR_DATE', newValue);
					//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE', newValue);
		    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
        },
        {
			fieldLabel: '완료예정일',
		        width: 315,
            xtype: 'uniDateRangefield',
            startFieldName: 'FR_DATE2',
            endFieldName: 'TO_DATE2',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
            		panelSearch.setValue('FR_DATE2', newValue);
					//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE2', newValue);
		    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
        },
        {
			fieldLabel: '수주번호',
			name: 'ORDER_NUM',
//			padding:5,
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelResult.getField('RDO').setValue({RDO: newValue});
					panelSearch.getField('ORDER_NUM').setValue(newValue);
				}
			}
/* 			
			listeners:{
				render: function(p) { 
				     p.getEl().on('click', function(p){ 
				                //处理点击事件代码 
				    	 openSearchInfoWindow();     
				      }); 
				}
				,change: function(field, newValue, oldValue, eOpts) {	
						panelSearch.setValue('ORDER_NUM', newValue);
				}
			} */
		}
		,Unilite.popup('CUST',{
            fieldLabel: '고객',
            valueFieldName:'AS_CUSTOMER_CD',
            textFieldName:'AS_CUSTOMER_NAME',
            listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.getField('AS_CUSTOMER_CD').setValue(panelResult.getValue("AS_CUSTOMER_CD"));
						panelSearch.getField('AS_CUSTOMER_NAME').setValue(panelResult.getValue("AS_CUSTOMER_NAME"));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.getField('AS_CUSTOMER_CD').setValue("");
					panelSearch.getField('AS_CUSTOMER_NAME').setValue("");
				}
            }
        })
        ,{
			fieldLabel: '접수구분',
			name: 'ACCEPT_GUBUN',
			xtype:'uniCombobox',
			comboType:'AU', 
//			padding:5,
			comboCode:'S801',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelResult.getField('RDO').setValue({RDO: newValue});
					panelSearch.getField('ACCEPT_GUBUN').setValue(newValue);
				}
			}
		}
		,
		{
			fieldLabel: '진행상태',
			name: 'FINISH_YN',
			xtype:'uniCombobox',
			comboType:'AU', 
//			padding:5,
			comboCode:'B046',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelResult.getField('RDO').setValue({RDO: newValue});
					panelSearch.getField('FINISH_YN').setValue(newValue);
				}
			}
		}]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('esa999skrvGrid1', {
    	// for tab
    	region: 'center',
        layout: 'fit',
    	store: directMasterStore,
    	uniOpt: {
            expandLastColumn: false,
            useRowNumberer: false,
            useMultipleSorting: false,
            state: {
                useState: false,
                useStateList: false
            }
        },
        selModel: 'rowmodel',
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id: 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [
                { dataIndex: 'T_C1'				,    	width: 100},
                { dataIndex: 'T_C2'				,    	width: 100},
                { dataIndex: 'T_C3'				,    	width: 100}
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
		},
			panelSearch  	
		],
		id: 'esa999skrvApp',
		fnInitBinding: function() {
		},
		onQueryButtonDown: function(){			
			masterGrid.getStore().loadStoreRecords();
			
		},
		
		cellProcess : function (grid, target) {
	        var gridView = grid.getView();
	        var cnt=0;
	        var prevData = "";
	        var flagCell = "";
	        
	        Ext.each(gridView.getNodes(), function(items){
	            var curData = items.childNodes[target].textContent;
	            if(prevData != curData) {
	        		flagCell = items.childNodes[target];
	        		prevData = curData;
	        		cnt=0;
        		} else {
	        		cnt++;
	        		Ext.get(items.childNodes[target]).destroy();
	       		}
	       		if(cnt !=0) {
        			Ext.get(flagCell).set({rowspan: cnt+1});
	        	}                             
			});
        
		}
	
	});
	
	
	

};


</script>
