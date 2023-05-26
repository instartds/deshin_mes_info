<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="esa100skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="esa100skrv" /> 			<!-- 사업장 -->
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

	   
	Unilite.defineModel('esa100skrvModel1', {
	    fields: [
				 {name: 'AS_CUSTOMER_CD'				,text: '고객'			,type: 'string'},
				 {name: 'AS_CUSTOMER_NAME'				,text: '고객명'			,type: 'string'},
				 {name: 'ADDR2'							,text: '현장'			,type: 'string'},
				 {name: 'ORDER_NUM'						,text: '수주번호'		,type: 'string'},
			 	 {name: 'AS_CUSTOMER_NM'					,text: '요청자'			,type: 'string'},
				 {name: 'FINISH_REQ_DATE'				,text: '완료요청일'		,type: 'uniDate'},
				 {name: 'AS_NUM'						,text: '접수번호'		,type: 'string'},
				 {name: 'ACCEPT_DATE'					,text: '접수일'			,type: 'uniDate'},
				 {name: 'ACCEPT_GUBUN'					,text: '접수구분'		,type: 'string'},
				 {name: 'FINISH_YN'						,text: '진행구분'		,type: 'string'},
				 {name: 'ACCEPT_REMARK'					,text: '요청사항'		,type: 'string'},
			]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */	
	var directMasterStore = Unilite.createStore('esa100skrvMasterStore1',{
			model: 'esa100skrvModel1',
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
                	   read: 'esa100skrvService.selectList'                	
                }
            }
			,loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});				
			},
			groupField: 'ORDER_NUM'			
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
	            ,
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
		items: [{ 
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
    
    var masterGrid = Unilite.createGrid('esa100skrvGrid1', {
    	// for tab
    	region: 'center',
        layout: 'fit',
    	store: directMasterStore,
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id: 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [
                { dataIndex: 'AS_CUSTOMER_CD'				,    	width: 60, locked: false}, 
                { dataIndex: 'AS_CUSTOMER_NAME'				,    	width: 133, locked: false}, 
          		{ dataIndex: 'ADDR2'						,    	width: 150}, 
				{ dataIndex: 'ORDER_NUM'					,    	width: 100}, 
				{ dataIndex: 'AS_CUSTOMER_NM'				,    	width: 110}, 
				{ dataIndex: 'FINISH_REQ_DATE'				,    	width: 80, align:'center'}, 
				{ dataIndex: 'AS_NUM'						,    	width: 120}, 
				{ dataIndex: 'ACCEPT_DATE'					,    	width: 80, align:'center'}, 
				{ dataIndex: 'ACCEPT_GUBUN'					,    	width: 80, align:'center'}, 
				{ dataIndex: 'FINISH_YN'					,    	width: 60, align:'center'}, 
				{ dataIndex: 'ACCEPT_REMARK'				,    	width: 500} 
          ] 
    });
    var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
        layout: {type: 'uniTable', columns : 3},
        trackResetOnLoad: true,
        items: [{
            fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>'  ,
            name: 'DIV_CODE',   
            xtype:'uniCombobox', 
            comboType:'BOR120', 
            value:UserInfo.divCode, 
            allowBlank:false,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    combo.changeDivCode(combo, newValue, oldValue, eOpts);                      
                    var field = orderNoSearch.getField('ORDER_PRSN');
                    field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..                       
                }
            }
        }, {
                fieldLabel: '<t:message code="unilite.msg.sMS122" default="수주일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_ORDER_DATE',
                endFieldName: 'TO_ORDER_DATE',
                width: 350,
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                colspan:2
            }, {
                fieldLabel: '<t:message code="unilite.msg.sMS573" default="sMS669"/>'       ,
                name: 'ORDER_PRSN', 
                xtype:'uniCombobox',
                comboType:'AU', 
                comboCode:'S010',
                onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
                    if(eOpts){
                        combo.filterByRefCode('refCode1', newValue, eOpts.parent);
                    }else{
                        combo.divFilterByRefCode('refCode1', newValue, divCode);
                    }
                }
            },  
            Unilite.popup('AGENT_CUST',{fieldLabel:'<t:message code="unilite.msg.sMSR213" default="거래처"/>' , validateBlank: false,colspan:2,
                listeners:{
                    applyextparam: function(popup){
                        popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
                        popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
                    }                
                }}),
//            Unilite.popup('AGENT_CUST',{fieldLabel:'프로젝트' , valueFieldName:'PROJECT_NO', textFieldName:'PROJECT_NAME', validateBlank: false}),
            Unilite.popup('DIV_PUMOK',{
                colspan:2,
                listeners: {
                    applyextparam: function(popup){                         
                        popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
                    }
                }               
            }),
            {fieldLabel: '<t:message code="unilite.msg.sMS832" default="판매유형"/>'        , name: 'ORDER_TYPE',   xtype:'uniCombobox',comboType:'AU', comboCode:'S002'},
            {fieldLabel: '<t:message code="unilite.msg.sMSR281" default="PO번호"/>'           , name: 'PO_NUM'},
            {
                fieldLabel: '조회구분'  ,
                xtype: 'uniRadiogroup',
                allowBlank: false,
                width: 235,
                name:'RDO_TYPE',
                items: [
                    {boxLabel:'마스터', name:'RDO_TYPE', inputValue:'master', checked:true},
                    {boxLabel:'디테일', name:'RDO_TYPE', inputValue:'detail'}
                ],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        if(newValue.RDO_TYPE=='detail') {
                            if(orderNoMasterGrid) orderNoMasterGrid.hide();
                            if(orderNoDetailGrid) orderNoDetailGrid.show();
                        } else {
                            if(orderNoDetailGrid) orderNoDetailGrid.hide();
                            if(orderNoMasterGrid) orderNoMasterGrid.show();
                        }
                    }
                }
            }/*,
            Unilite.popup('DEPT', { 
                fieldLabel: '부서', 
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                listeners: {                
                    applyextparam: function(popup){                         
                        var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                        var deptCode = UserInfo.deptCode;   //부서정보
                        var divCode = '';                   //사업장
                        
                        if(authoInfo == "A"){   //자기사업장 
                            popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                            
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                            popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
                            
                        }else if(authoInfo == "5"){     //부서권한
                            popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
                }
            })*/
        ]
    }); // createSearchForm
    
    //검색 모델(마스터)
    Unilite.defineModel('orderNoMasterModel', {
        fields: [
            {name: 'COMP_CODE'      , text: 'COMP_CODE'                                                 , type: 'string'},
            {name: 'DIV_CODE'       , text: '<t:message code="unilite.msg.sMS631" default="사업장"/>'              , type: 'string', comboType:'BOR120'}, 
            {name: 'CUSTOM_CODE'    , text: '<t:message code="unilite.msg.sMSR213" default="거래처"/>' , type: 'string'}, 
            {name: 'CUSTOM_NAME'    , text: '<t:message code="unilite.msg.sMSR279" default="거래처명"/>'    , type: 'string'}, 
            {name: 'ORDER_DATE'     , text: '<t:message code="unilite.msg.sMS122" default="수주일"/>'      , type: 'uniDate'}, 
            {name: 'ORDER_NUM'      , text: '<t:message code="unilite.msg.sMS533" default="수주번호"/>' , type: 'string'}, 
            {name: 'ORDER_TYPE'     , text: '<t:message code="unilite.msg.sMS832" default="판매유형"/>' , type: 'string', comboType: 'AU', comboCode: 'S002'}, 
            {name: 'ORDER_PRSN'     , text: '<t:message code="unilite.msg.sMS669" default="수주담당"/>' , type: 'string', comboType: 'AU', comboCode: 'S010'}, 
            {name: 'PJT_CODE'       , text: '프로젝트코드'                                                    , type: 'string'}, 
            {name: 'PJT_NAME'       , text: '프로젝트'                                                  , type: 'string'}, 
            {name: 'ORDER_Q'        , text: '<t:message code="unilite.msg.sMS543" default="수주량"/>'     , type: 'uniQty'}, 
            {name: 'ORDER_O'        , text: '수주금액'                                                  , type: 'uniPrice'},
            {name: 'NATION_INOUT'   , text: '국내외구분'                                                  , type: 'string'},    
            {name: 'OFFER_NO'       , text: 'OFFER번호'                                                  , type: 'string'},    
            {name: 'DATE_DELIVERY'  , text: '납기일'                                                  , type: 'string'}, 
            {name: 'MONEY_UNIT'     , text: '화폐'                                                  , type: 'string'}, 
            {name: 'EXCHANGE_RATE'  , text: '환율'                                                  , type: 'string'}, 
            {name: 'RECEIPT_SET_METH'  , text: '결제방법'                                           , type: 'string'}
        ]
    });
    //검색 스토어(마스터)
    var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
            model: 'orderNoMasterModel',
            autoLoad: false,
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read    : 'sof100ukrvService.selectOrderNumMasterList'
                }
            }
            ,loadStoreRecords : function()  {
                var param= orderNoSearch.getValues();   
                var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                var deptCode = UserInfo.deptCode;   //부서코드
                if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
                    param.DEPT_CODE = deptCode;
                }
                console.log( param );
                this.load({
                    params : param
                });
            }
    });
    //검색 그리드(마스터)
    var orderNoMasterGrid = Unilite.createGrid('sof100ukrvOrderNoMasterGrid', {
        // title: '기본',
        layout : 'fit',       
        store: orderNoMasterStore,
        uniOpt:{
                    useRowNumberer: false
        },
        columns:  [ 
                     { dataIndex: 'DIV_CODE',  width: 80 } 
                    ,{ dataIndex: 'CUSTOM_NAME',  width: 150 } 
                    ,{ dataIndex: 'ORDER_DATE',  width: 80 } 
                    ,{ dataIndex: 'ORDER_NUM',  width: 120 } 
                    ,{ dataIndex: 'ORDER_TYPE',  width: 80 } 
                    ,{ dataIndex: 'ORDER_PRSN',  width: 80 } 
                    ,{ dataIndex: 'PJT_NAME',  width: 150 } 
                    ,{ dataIndex: 'ORDER_Q',  width: 110 } 
                    ,{ dataIndex: 'ORDER_O',  width: 120 }              
                        
          ] ,
          listeners: {  
              onGridDblClick: function(grid, record, cellIndex, colName) {
                    orderNoMasterGrid.returnData(record);
                    SearchInfoWindow.hide();
              }
          } // listeners
          ,returnData: function(record) {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelSearch.setValues({'ORDER_NUM':record.get('ORDER_NUM')});
            panelSearch.setValues({'AS_CUSTOMER_CD':record.get('CUSTOM_CODE')});
            panelResult.setValues({'COMPANY_NUM':record.get('ORDER_NUM')});
            panelResult.setValues({'AS_CUSTOMER_CD':record.get('CUSTOM_CODE')});
          }
    });
    //검색 모델(디테일)
    Unilite.defineModel('orderNoDetailModel', {
        fields: [
                    
                     { name: 'DIV_CODE'     ,text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'            ,type: 'string' ,comboType:'BOR120'} 
                    ,{ name: 'ITEM_CODE'    ,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>'       ,type: 'string' } 
                    ,{ name: 'ITEM_NAME'    ,text:'<t:message code="unilite.msg.sMR349" default="품명"/>'     ,type: 'string' } 
                    ,{ name: 'SPEC'         ,text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'    ,type: 'string' } 
                    
                    ,{ name: 'ORDER_DATE'   ,text:'<t:message code="unilite.msg.sMS122" default="수주일"/>'        ,type: 'uniDate'} 
                    ,{ name: 'DVRY_DATE'    ,text:'<t:message code="unilite.msg.sMS123" default="납기일"/>'        ,type: 'uniDate'} 
                    
                    ,{ name: 'ORDER_Q'      ,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'        ,type: 'uniQty' } 
                    ,{ name: 'ORDER_TYPE'   ,text:'<t:message code="unilite.msg.sMS832" default="판매유형"/>'       ,type: 'string' ,comboType:'AU', comboCode:'S002'} 
                    ,{ name: 'ORDER_PRSN'   ,text:'<t:message code="unilite.msg.sMS669" default="수주담당"/>'       ,type: 'string' ,comboType:'AU', comboCode:'S010'} 
                    ,{ name: 'PO_NUM'       ,text:'<t:message code="unilite.msg.sMSR281" default="PO번호"/>'      ,type: 'string' }
                    ,{ name: 'PROJECT_NO'   ,text:'<t:message code="unilite.msg.sMR161" default="프로젝트번호"/>'       ,type: 'string' }
                    ,{ name: 'ORDER_NUM'    ,text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>'       ,type: 'string' } 
                    ,{ name: 'SER_NO'       ,text:'<t:message code="unilite.msg.sMS783" default="수주순번"/>'       ,type: 'string' }
                    ,{ name: 'CUSTOM_CODE'  ,text:'<t:message code="unilite.msg.sMSR213" default="거래처"/>'       ,type: 'string' } 
                    ,{ name: 'CUSTOM_NAME'  ,text:'<t:message code="unilite.msg.sMSR279" default="거래처명"/>'      ,type: 'string' } 
                    ,{ name: 'COMP_CODE'    ,text:'COMP_CODE'       ,type: 'string' } 
                    ,{ name: 'PJT_CODE'     ,text:'프로젝트코드'                                                  ,type: 'string' } 
                    ,{ name: 'PJT_NAME'     ,text:'프로젝트'                                                        ,type: 'string' } 
                   
                ]
    });
    //검색 스토어(디테일)
    var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
            model: 'orderNoDetailModel',
            autoLoad: false,
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read    : 'sof100ukrvService.selectOrderNumDetailList'
                }
            }
            ,loadStoreRecords : function()  {
                var param= orderNoSearch.getValues();
                var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                var deptCode = UserInfo.deptCode;   //부서코드
                if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
                    param.DEPT_CODE = deptCode;
                }
                console.log( param );
                this.load({
                    params : param
                });
            }
    });
    //검색 그리드(디테일)
    var orderNoDetailGrid = Unilite.createGrid('sof100ukrvOrderNoDetailGrid', {
        layout : 'fit',       
        store: orderNoDetailStore,
        uniOpt:{
                    useRowNumberer: false
        },
        hidden : true,
        columns:  [ 
                     { dataIndex: 'DIV_CODE',  width: 80 } 
                    ,{ dataIndex: 'ITEM_CODE',  width: 120 } 
                    ,{ dataIndex: 'ITEM_NAME',  width: 150 } 
                    ,{ dataIndex: 'SPEC',  width: 150 } 
                    ,{ dataIndex: 'ORDER_DATE',  width: 80 } 
                    ,{ dataIndex: 'DVRY_DATE',  width: 80 , hidden:true} 
                    ,{ dataIndex: 'ORDER_Q',  width: 80 } 
                    ,{ dataIndex: 'ORDER_TYPE',  width: 90 } 
                    ,{ dataIndex: 'ORDER_PRSN',  width: 90 , hidden:true} 
                    ,{ dataIndex: 'PO_NUM',  width: 100 } 
                    ,{ dataIndex: 'PROJECT_NO',  width: 90 } 
                    ,{ dataIndex: 'ORDER_NUM',  width: 120 } 
                    ,{ dataIndex: 'SER_NO',  width: 70 , hidden:true} 
                    ,{ dataIndex: 'CUSTOM_CODE',  width: 120 , hidden:true} 
                    ,{ dataIndex: 'CUSTOM_NAME',  width: 200 } 
                    ,{ dataIndex: 'COMP_CODE',  width: 80 ,hidden:true} 
                    ,{ dataIndex: 'PJT_CODE',  width: 120 , hidden:true} 
                    ,{ dataIndex: 'PJT_NAME',  width: 200 } 
          ] ,
          listeners: {
              onGridDblClick:function(grid, record, cellIndex, colName) {
                    orderNoDetailGrid.returnData(record)
                    SearchInfoWindow.hide();
              }
          } // listeners
          ,returnData: function(record) {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelSearch.setValues({'COMPANY_NUM':record.get('ORDER_NUM')});
            panelSearch.setValues({'AS_CUSTOMER_CD':record.get('CUSTOM_CODE')});
            panelSearch.setValues({'AS_CUSTOMER_NAME':record.get('CUSTOM_NAME')});
            panelResult.setValues({'COMPANY_NUM':record.get('ORDER_NUM')});
            panelResult.setValues({'AS_CUSTOMER_CD':record.get('CUSTOM_CODE')});
            panelResult.setValues({'AS_CUSTOMER_NAME':record.get('CUSTOM_NAME')});
    
          }
    });
function openSearchInfoWindow() {
        
        if(!SearchInfoWindow) {
            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '수주번호검색',
                width: 830,                             
                height: 580,
                layout: {type:'vbox', align:'stretch'},                 
                items: [orderNoSearch, orderNoMasterGrid, orderNoDetailGrid],
                tbar:  [
                                        {   itemId : 'searchBtn',
                                            text: '조회',
                                            handler: function() {
                                                var rdoType = orderNoSearch.getValue('RDO_TYPE');
                                                console.log('rdoType : ',rdoType)
                                                if(rdoType.RDO_TYPE=='master')  {
                                                    orderNoMasterStore.loadStoreRecords();
                                                }else {
                                                    orderNoDetailStore.loadStoreRecords();
                                                }
                                            },
                                            disabled: false
                                        }, '->',{
                                            itemId : 'closeBtn',
                                            text: '닫기',
                                            handler: function() {
                                                SearchInfoWindow.hide();
                                            },
                                            disabled: false
                                        }
                                ],
                listeners : {beforehide: function(me, eOpt) {
                                            orderNoSearch.clearForm();
                                            orderNoMasterGrid.reset();
                                            orderNoDetailGrid.reset();                                              
                                        },
                             beforeclose: function( panel, eOpts )  {
                                            orderNoSearch.clearForm();
                                            orderNoMasterGrid.reset();
                                            orderNoDetailGrid.reset();
                                        },
                             show: function( panel, eOpts ) {
                             }
                }       
            })
        }
        SearchInfoWindow.center();
        SearchInfoWindow.show();
    }
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
		id: 'esa100skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function(){			
			masterGrid.getStore().loadStoreRecords();
		}
	});

};


</script>
