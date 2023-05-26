<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="w_sof301ukrv_yp"  >
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="BOR120" pgmId="w_sof301ukrv_yp"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->	
	<t:ExtComboStore comboType="AU" comboCode="S046" /> <!--상태   -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!--판매단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S014" /> <!--계산서대상-->
	<t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S011" /> <!--강제마감 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript">
var ReturnWindow;	//반려창
var beforeRowIndex;		//마스터그리드 같은row중복 클릭시 다시 load되지 않게
function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('W_sof301ukrv_ypModel1', {
	    fields: [{name: 'STATUS'			,text:'상태'				,type:'string', comboType: 'AU', comboCode: 'S046'},
				 {name: 'COMP_CODE'   	   	,text:'COMP_CODE'		,type:'string'},
				 {name: 'DIV_CODE'		   	,text:'사업장'			,type:'string', comboType: 'BOR120'},
				 {name: 'ORDER_NUM'		   	,text:'주문번호'			,type:'string'},
				 {name: 'ORDER_DATE'		,text:'주문일'			,type:'uniDate'},
				 {name: 'CUSTOM_CODE'	   	,text:'CUSTOM_CODE'		,type:'string'},
				 {name: 'CUSTOM_NAME'	   	,text:'거래처명'			,type:'string'},
				 {name: 'ORDER_TYPE'		,text:'판매유형'			,type:'string', comboType: 'AU', comboCode:'S002', allowBlank: false},
				 {name: 'ORDER_PRSN'		,text:'수주담당'			,type:'string', comboType: 'AU', comboCode:'S010', allowBlank: false},
				 {name: 'ORDER_O'		   	,text:'수주액'			,type:'uniPrice'},
				 {name: 'PJT_NAME'		   	,text:'관리명'			,type:'string'},
				 {name: 'APP_STEP'		   	,text:'총단계'			,type:'string'},
				 {name: 'NOW_STEP'		   	,text:'현단계'			,type:'string'},
				 {name: 'APP_1_ID'		   	,text:'APP_1_ID'		,type:'string'},
				 {name: 'APP_1_NM'		   	,text:'확정자'			,type:'string'},
				 {name: 'APP_1_DATE'		,text:'확정일'			,type:'uniDate'},
				 {name: 'AGREE_1_YN'		,text:'AGREE_1_YN'		,type:'string'},
//				 {name: 'APP_2_ID'		   	,text:'APP_2_ID'		,type:'string'},
//				 {name: 'APP_2_NM'		   	,text:'2차승인자'			,type:'string'},
//				 {name: 'APP_2_DATE'		,text:'2차승인일'			,type:'uniDate'},
//				 {name: 'AGREE_2_YN'		,text:'AGREE_2_YN'		,type:'string'},
//				 {name: 'APP_3_ID'   	   	,text:'APP_3_ID'		,type:'string'},
//				 {name: 'APP_3_NM' 		   	,text:'3차승인자'			,type:'string'},
//				 {name: 'APP_3_DATE' 	   	,text:'3차승인일'			,type:'uniDate'},
//				 {name: 'AGREE_3_YN'		,text:'AGREE_3_YN'		,type:'string'},
				 {name: 'RETURN_MSG'		,text:'RETURN_MSG'		,type:'string'},
				 {name: 'EDITABLE_YN'	   	,text:'EDITABLE_YN'		,type:'string'},
				 {name: 'SAVE_FLAG'         ,text:'SAVE_FLAG'       ,type:'string', defaultValue: 'N'},
				 {name: 'UPDATE_DB_USER'   	,text:'UPDATE_DB_USER'	,type:'string'},
				 {name: 'UPDATE_DB_TIME'   	,text:'UPDATE_DB_TIME'	,type:'string'}				 
			]
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
        	read: 'w_sof301ukrv_ypService.selectList',
            update: 'w_sof301ukrv_ypService.updateDetail',
            syncAll: 'w_sof301ukrv_ypService.saveAll'  
        }
    });
	var masterStore = Unilite.createStore('w_sof301ukrv_ypMasterStore1',{
			model: 'W_sof301ukrv_ypModel1',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: directProxy
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});	
				
			},
			listeners: {
               	load: function(store, records, successful, eOpts) {
               		if(!Ext.isEmpty(records)){
               			detailStore.loadStoreRecords(records[0]);
               		}else{
               			detailStore.loadData({});
               		}
               	}
    		},
            saveStore: function() {
                var inValidRecs = this.getInvalidRecords();
                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();                
                var toDelete = this.getRemovedRecords();
                var list = [].concat(toUpdate, toCreate);
    
                var isErr = false;
                Ext.each(list, function(record, index) {
                    if(record.data['SAVE_FLAG'] == 'Y' && (record.data['STATUS'] == '6' && record.data['ORDER_TYPE'] == '95')) {
                        alert('판매유형을 선택하십시오.');
                        isErr = true;
                        return false;
                    }                    
                });
                if(isErr) return false;
                var paramMaster= panelSearch.getValues();    //syncAll 수정
                
                if(inValidRecs.length == 0) {
                        config = {
                                params: [paramMaster],
                                success: function(batch, option) {
                                	masterStore.loadStoreRecords();
                                } 
                        };
                    this.syncAllDirect(config);
                }else{
                    detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
	});	
	
	Unilite.defineModel('W_sof301ukrv_ypModel2', {
	    fields: [{name: 'DIV_CODE'           		,text:'사업장'			    ,type:'string'},	    			
				 {name: 'ORDER_NUM'          		,text:'수주번호'			,type:'string'},	    			
				 {name: 'SER_NO'             		,text:'순번'				,type:'int'},	    			
				 {name: 'OUT_DIV_CODE'       		,text:'출고사업장'			,type:'string', comboType: 'BOR120' },	    			
				 {name: 'ITEM_CODE'          		,text:'품목코드'			,type:'string'},	    			
				 {name: 'ITEM_NAME'          		,text:'품명'				,type:'string'},	    			
				 {name: 'ITEM_ACCOUNT'       		,text:'ITEM_ACCOUNT'	    ,type:'string'},	    			
				 {name: 'SPEC'               		,text:'규격'				,type:'string'},	    			
				 {name: 'ORDER_UNIT'         		,text:'판매단위'			,type:'string', displayField: 'value'},	    			
				 {name: 'TRANS_RATE'         		,text:'입수'				,type:'uniQty'},	    			
				 {name: 'ORDER_Q'            		,text:'수주량'			    ,type:'uniQty'},	    			
				 {name: 'ORDER_P'            		,text:'단가'				,type:'uniUnitPrice'},	    			
				 {name: 'ORDER_O'            		,text:'금액'				,type:'uniPrice'},	    			
				 {name: 'TAX_TYPE'           		,text:'과세구분'			,type:'string', comboType: 'AU', comboCode:'B059'},	    			
				 {name: 'ORDER_TAX_O'        		,text:'부가세액'			,type:'uniPrice'},	    			
				 {name: 'ORDER_O_TAX_O'      		,text:'수주계'			    ,type:'uniPrice'},	    			
				 {name: 'DVRY_DATE'          		,text:'납기일'			    ,type:'uniDate'},	    			
				 {name: 'DISCOUNT_RATE'      		,text:'할인율(%)'			,type:'uniPercent'},	    			
				 {name: 'ACCOUNT_YNC'        		,text:'매출대상'			,type:'string', comboType: 'AU', comboCode:'S014'},	    			
				 {name: 'SALE_CUST_CD'       		,text:'매출처'			    ,type:'string'},	    			
				 {name: 'CUSTOM_NAME'        		,text:'매출처'			    ,type:'string'},	    			
				 {name: 'PRICE_YN'           		,text:'단가구분'			,type:'string', comboType: 'AU', comboCode:'S003'},	    			
//				 {name: 'STOCK_Q'            		,text:'재고수량'			,type:'uniQty'},	    			
				 {name: 'PROD_SALE_Q'        		,text:'생산요청량'			,type:'uniQty'},	    			
				 {name: 'PROD_Q'             		,text:'생산요청량(재고단위)',type:'uniQty'},	    			
				 {name: 'PROD_END_DATE'      		,text:'생산완료일'			,type:'uniDate'},	    			
				 {name: 'DVRY_CUST_CD'       		,text:'배송처'			    ,type:'string'},	    			
				 {name: 'DVRY_CUST_NAME'     		,text:'배송처'			    ,type:'string'},	    			
				 {name: 'ORDER_STATUS'       		,text:'강제마감'			,type:'string', comboType: 'AU', comboCode:'S011'},	    			
				 {name: 'PO_NUM'             		,text:'P/O NO'			    ,type:'string'},	    			
				 {name: 'PO_SEQ'             		,text:'P/O 순번'			,type:'string'},	    			
				 {name: 'PROJECT_NO'         		,text:'프로젝트번호'		,type:'string'},	    			
				 {name: 'ESTI_NUM'           		,text:'견적번호'			,type:'string'},	    			
				 {name: 'ESTI_SEQ'           		,text:'견적순번'			,type:'int'},	    			
				 {name: 'COMP_CODE'          		,text:'COMP_CODE'		    ,type:'string'},	    			
				 {name: 'REMARK'             		,text:'비고'				,type:'string'} 
			]
	});
	
	var detailStore = Unilite.createStore('w_sof301ukrv_ypMasterStore1',{
			model: 'W_sof301ukrv_ypModel2',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
            	   read: 'w_sof301ukrv_ypService.detailList'              	   
                }
            }
			,loadStoreRecords : function(record){
				this.load({
					params : record.data
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
			layout : {type : 'vbox', align : 'stretch'},
        	items : [{	
        		xtype:'container',
        		layout: {type : 'uniTable', columns : 1},
        		items:[{
        			fieldLabel: '사업장',
        			name:'DIV_CODE',
        			xtype: 'uniCombobox',
        			comboType:'BOR120',
	    			allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
        		}, {
        			fieldLabel: '주문일',
				    xtype: 'uniDateRangefield',
				    startFieldName: 'ORDER_DATE_FR',
				    endFieldName: 'ORDER_DATE_TO',
				    startDate: UniDate.get('startOfMonth'),
				    endDate: UniDate.get('today'),
				    width:315,
				    onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('ORDER_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('ORDER_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
				}, {
        			fieldLabel: '영업담당'	,
        			name:'ORDER_PRSN',
        			xtype: 'uniCombobox',
        			comboType:'AU',
        			comboCode:'S010',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ORDER_PRSN', newValue);
						}
					}
        		}, 
					Unilite.popup('AGENT_CUST',{
					fieldLabel: '거래처',
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
				}),{
        			fieldLabel: '판매유형'	,
        			name:'ORDER_TYPE',
        			xtype: 'uniCombobox',
        			comboType:'AU',
        			comboCode:'S002',
        			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ORDER_TYPE', newValue);
						}
					}
        		}, {
        	  		xtype: 'radiogroup',		            		
				    fieldLabel: '상태',						            							            		
				    items : [{
				    	boxLabel: '전체',
				    	width: 45,
				    	name: 'status',
				    	inputValue: 'A'
				    } ,{
				    	boxLabel: '미확정',
				    	width: 55,
				    	name: 'status',
				    	inputValue: '1',
				    	checked: true
				    } ,{
				    	boxLabel: '확정',
				    	width: 55,
				    	name: 'status' ,
				    	inputValue: '6'
				    } ],
				    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('status').setValue(newValue.status);
						}
					}
				}]
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
				}
	  		}
			return r;
  		}
	}); 

	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
        		items:[{
					fieldLabel: '사업장',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
        		}, {
        			fieldLabel: '주문일',
				    xtype: 'uniDateRangefield',
				    startFieldName: 'ORDER_DATE_FR',
				    endFieldName: 'ORDER_DATE_TO',
				    startDate: UniDate.get('startOfMonth'),
				    endDate: UniDate.get('today'),
				    width:315,
				    onStartDateChange: function(field, newValue, oldValue, eOpts) {
		            	if(panelSearch) {
							panelSearch.setValue('ORDER_DATE_FR',newValue);
							//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
							
		            	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelSearch) {
				    		panelSearch.setValue('ORDER_DATE_TO',newValue);
				    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
				}, {
        			fieldLabel: '영업담당'	,
        			name:'ORDER_PRSN',
        			xtype: 'uniCombobox',
        			comboType:'AU',
        			comboCode:'S010',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ORDER_PRSN', newValue);
						}
					}
        		}, 
					Unilite.popup('AGENT_CUST',{
					fieldLabel: '거래처',
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
				}),{
        			fieldLabel: '판매유형'	,
        			name:'ORDER_TYPE',
        			xtype: 'uniCombobox',
        			comboType:'AU',
        			comboCode:'S002',
        			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ORDER_TYPE', newValue);
						}
					}
        		}, {
        	  		xtype: 'radiogroup',                           
                    fieldLabel: '상태',                                                                                   
                    items : [{
                        boxLabel: '전체',
                        width: 45,
                        name: 'status',
                        inputValue: 'A'
                    } ,{
                        boxLabel: '미확정',
                        width: 55,
                        name: 'status',
                        inputValue: '1',
                        checked: true
                    } ,{
                        boxLabel: '확정',
                        width: 55,
                        name: 'status' ,
                        inputValue: '6'
                    } ],
				    listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('status').setValue(newValue.status);
					}
				}
			}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('w_sof301ukrv_ypGrid1', {
    	// for tab    	
        layout : 'fit',
        region: 'center',
        uniOpt:{
         expandLastColumn: false,
         onLoadSelectFirst: false,
		 useRowNumberer: false,
        state: {
            useState: false,         //그리드 설정 버튼 사용 여부
            useStateList: false      //그리드 설정 목록 사용 여부
        }
        },
//        tbar: [{
//	    	itemId : 'estimateBtn', iconCls : 'icon-referance'	,
//			text:'반려',
//			handler: function() {
//				var record = masterGrid.getSelectedRecord();
//				if(!Ext.isEmpty(record)){
//	    			if(record.get('STATUS') == "6"){
//	    				alert('이미 완결처리된 건입니다.');	//fSbMsgS0016
//	    			}else{
//	    				openReturnWindow();
//	    				////오픈된후 반려 저장 로직 넣어야함
//	    			}
//	    				    		
//	    		}
//			}
//       	}],
        selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false,
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
//        			if(record.get('EDITABLE_YN') != 'Y'){
//						return false;        			        				
//        			}
        		},
				select: function(grid, record, index, eOpts ){					
					if(record.get('STATUS') == "1"){   //미확정일시
					   record.set('STATUS', "6");
					   record.set('APP_1_DATE', UniDate.get('today'));
                       record.set('APP_1_NM', UserInfo.userID);
					}else if(record.get('STATUS') == "6"){   //확정일시
                       record.set('STATUS', "1");
//                       record.set('APP_1_DATE', '');
//                       record.set('APP_1_NM', '');
                    }
                    record.set('SAVE_FLAG', "Y");
	          	},
				deselect:  function(grid, record, index, eOpts ){
					if(record.get('STATUS') == "1"){   //미확정일시
                       record.set('STATUS', "6"); 
//                       record.set('APP_1_DATE', UniDate.get('today'));
//                       record.set('APP_1_NM', UserInfo.userID);
                    }else if(record.get('STATUS') == "6"){   //확정일시
                       record.set('STATUS', "1");
                       record.set('APP_1_DATE', '');
                       record.set('APP_1_NM', '');
                    }
                    record.set('SAVE_FLAG', "N");
        		}
        	}
        }),
    	store: masterStore,
        columns:  [{ dataIndex: 'STATUS'			,   		width: 53 },
        		   { dataIndex: 'COMP_CODE'   	   	,   		width: 66, hidden: true },
        		   { dataIndex: 'DIV_CODE'		   	,   		width: 96 },
        		   { dataIndex: 'ORDER_NUM'		   	,   		width: 103 },
        		   { dataIndex: 'ORDER_DATE'		,   		width: 96 },
        		   { dataIndex: 'CUSTOM_CODE'	   	,   		width: 80, hidden: true },
        		   { dataIndex: 'CUSTOM_NAME'	   	,   		width: 160 },
        		   { dataIndex: 'ORDER_TYPE'		,   		width: 100 },
        		   { dataIndex: 'ORDER_PRSN'		,   		width: 100 },
        		   { dataIndex: 'ORDER_O'		   	,   		width: 100 },
//        		   { dataIndex: 'PJT_NAME'		   	,   		width: 120 },
        		   { dataIndex: 'APP_STEP'		   	,   		width: 66, align: 'center', hidden: true },
        		   { dataIndex: 'NOW_STEP'		   	,   		width: 66, align: 'center', hidden: true },
        		   { dataIndex: 'APP_1_ID'		   	,   		width: 66, hidden: true },
        		   { dataIndex: 'APP_1_NM'		   	,   		width: 100 },
        		   { dataIndex: 'APP_1_DATE'		,   		width: 100 },
        		   { dataIndex: 'AGREE_1_YN'		,   		width: 66, hidden: true },
//        		   { dataIndex: 'APP_2_ID'		   	,   		width: 66, hidden: true },
//        		   { dataIndex: 'APP_2_NM'		   	,   		width: 86 },
//        		   { dataIndex: 'APP_2_DATE'		,   		width: 86 },
//        		   { dataIndex: 'AGREE_2_YN'		,   		width: 66, hidden: true },
//        		   { dataIndex: 'APP_3_ID'   	   	,   		width: 66, hidden: true },
//        		   { dataIndex: 'APP_3_NM' 		   	,   		width: 86 },
//        		   { dataIndex: 'APP_3_DATE' 	   	,   		width: 86 },
//        		   { dataIndex: 'AGREE_3_YN'		,   		width: 66, hidden: true },
        		   { dataIndex: 'RETURN_MSG'		,   		width: 66, hidden: true },
        		   { dataIndex: 'EDITABLE_YN'	   	,   		width: 66, hidden: true },
        		   { dataIndex: 'SAVE_FLAG'         ,           width: 66, hidden: true },
        		   { dataIndex: 'UPDATE_DB_USER'   	,   		width: 66, hidden: true },
        		   { dataIndex: 'UPDATE_DB_TIME'   	,   		width: 66, hidden: true }
       ],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (!UniUtils.indexOf(e.field, 
                    ['ORDER_TYPE','ORDER_PRSN'])){
                        return false;                 
                 }else{
                    if(!masterGrid.getSelectionModel().isSelected(e.record)){
                          return false;
                    } 
                 }
            },
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					detailStore.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
//				var selModel = view.getSelectionModel();
//				if(selModel.isSelected()){
//          			detailStore.loadStoreRecords(record);
//				}
				
   		  	////ROW더블클릭시 수주등록으로 데이터 전송및 조회되게 하는 부분 해야함.
			}
       }       
    }); 
    
    var detailGrid = Unilite.createGrid('w_sof301ukrv_ypGrid2', {
    	// for tab    	
        layout : 'fit',
        region: 'south',
        uniOpt:{
         expandLastColumn: false,
		 useRowNumberer: false
        },
    	store: detailStore,
        columns:  [{ dataIndex: 'DIV_CODE'           		,   		width: 66, hidden: true}, 			
				   { dataIndex: 'ORDER_NUM'          		,   		width: 66, hidden: true}, 			
				   { dataIndex: 'SER_NO'             		,   		width: 66, locked: true}, 			
				   { dataIndex: 'OUT_DIV_CODE'       		,   		width: 100, locked: true}, 			
				   { dataIndex: 'ITEM_CODE'          		,   		width: 120, locked: true}, 			
				   { dataIndex: 'ITEM_NAME'          		,   		width: 120, locked: true}, 			
				   { dataIndex: 'ITEM_ACCOUNT'       		,   		width: 120, hidden: true}, 			
				   { dataIndex: 'SPEC'               		,   		width: 120}, 			
				   { dataIndex: 'ORDER_UNIT'         		,   		width: 66}, 			
				   { dataIndex: 'TRANS_RATE'         		,   		width: 66}, 			
				   { dataIndex: 'ORDER_Q'            		,   		width: 80}, 			
				   { dataIndex: 'ORDER_P'            		,   		width: 73}, 			
				   { dataIndex: 'ORDER_O'            		,   		width: 86}, 			
				   { dataIndex: 'TAX_TYPE'           		,   		width: 80, align: 'center'}, 			
				   { dataIndex: 'ORDER_TAX_O'        		,   		width: 93}, 			
				   { dataIndex: 'ORDER_O_TAX_O'      		,   		width: 100}, 			
				   { dataIndex: 'DVRY_DATE'          		,   		width: 80}, 			
				   { dataIndex: 'DISCOUNT_RATE'      		,   		width: 80}, 			
				   { dataIndex: 'ACCOUNT_YNC'        		,   		width: 80}, 			
				   { dataIndex: 'SALE_CUST_CD'       		,   		width: 66, hidden: true}, 			
				   { dataIndex: 'CUSTOM_NAME'        		,   		width: 100}, 			
				   { dataIndex: 'PRICE_YN'           		,   		width: 66}, 			
//				   { dataIndex: 'STOCK_Q'            		,   		width: 93}, 			
				   { dataIndex: 'PROD_SALE_Q'        		,   		width: 93}, 			
				   { dataIndex: 'PROD_Q'             		,   		width: 140}, 			
				   { dataIndex: 'PROD_END_DATE'      		,   		width: 80}, 			
				   { dataIndex: 'DVRY_CUST_CD'       		,   		width: 100, hidden: true}, 			
				   { dataIndex: 'DVRY_CUST_NAME'     		,   		width: 100}, 			
				   { dataIndex: 'ORDER_STATUS'       		,   		width: 66}, 			
				   { dataIndex: 'PO_NUM'             		,   		width: 100}, 			
				   { dataIndex: 'PO_SEQ'             		,   		width: 66}, 			
				   { dataIndex: 'PROJECT_NO'         		,   		width: 113}, 			
				   { dataIndex: 'ESTI_NUM'           		,   		width: 100}, 			
				   { dataIndex: 'ESTI_SEQ'           		,   		width: 80}, 			
				   { dataIndex: 'COMP_CODE'          		,   		width: 66, hidden: true}, 			
				   { dataIndex: 'REMARK'             		,   		width: 200}		
				   
       ] 
    });
    
    function openReturnWindow() {
    	ReturnWindow = Ext.create('widget.uniDetailWindow', {
            title: '반려',
            width: 530,				                
            height: 180,
            layout:{type:'uniTable', columns: 1}, 
            xtype: 'container',
            region: 'center',
            items: [{
	            xtype: 'fieldset',
	            defaultType: 'textfield',
	            defaults: {
	                anchor: '100%'
	            },
	            width: 400,
	            margin: '25 15 15 60',
	            items: [{
					xtype: 'container',
					html: '반려사유를 입력하십시오.',
					padding: '10 10 5 10'
	            },{
	            	name: 'RETURN_REMARK',
	            	whidth: 350,
	            	padding: '5 10 10 10'
	            }]
        	}]            
            ,
            bbar:  ['->',{
        		itemId : 'confirmBtn',
				text: '확인',
				handler: function() {
				},
				disabled: false,
				region:'center'
			}, {
				itemId : 'cancelBtn',
				text: '취소',
				handler: function() {
					ReturnWindow.hide()
				},
				disabled: false,
				region:'center'				
            }]
						,
            listeners : {beforehide: function(me, eOpt)	{
            							orderReferSearch.clearForm();
            							orderReferGrid.reset();
            						},
            			 beforeclose: function( panel, eOpts )	{
										orderReferSearch.clearForm();
            							orderReferGrid.reset();
            			 			},
            			 beforeshow: function ( me, eOpts )	{
//            			 	orderReferStore.loadStoreRecords();
            			 }
            }
		})
		ReturnWindow.center();
		ReturnWindow.show();
    }
    
    Unilite.Main( {
    	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			items:[
				masterGrid, detailGrid
			]	
		},
			panelSearch
		],		
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterGrid, detailGrid
			]	
		}		
		,panelSearch 
		],  
		id  : 'w_sof301ukrv_ypApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
            panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));
            panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
            panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));
            
            panelSearch.setValue('CUSTOM_CODE', '${gsCustomCode}');
            panelSearch.setValue('CUSTOM_NAME', '${gsCustomName}');
            panelSearch.setValue('ORDER_PRSN', '${gsBusiPrsn}');
            panelSearch.setValue('ORDER_TYPE', '95');
            panelResult.setValue('CUSTOM_CODE', '${gsCustomCode}');
            panelResult.setValue('CUSTOM_NAME', '${gsCustomName}');
            panelResult.setValue('ORDER_PRSN', '${gsBusiPrsn}');
            panelResult.setValue('ORDER_TYPE', '95');
            
            panelSearch.getField('CUSTOM_CODE').setReadOnly(true);
            panelSearch.getField('CUSTOM_NAME').setReadOnly(true);
            panelResult.getField('CUSTOM_CODE').setReadOnly(true);
            panelResult.getField('CUSTOM_NAME').setReadOnly(true);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			beforeRowIndex = -1;
			masterGrid.getStore().loadStoreRecords();;				
		},
        onSaveDataButtonDown: function(config) {
        	masterStore.saveStore();
        }
	});
};


</script>
