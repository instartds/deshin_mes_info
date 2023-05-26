<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="asc110skr"  >
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수

	Unilite.defineModel('asc110skrModel', {		
	    fields: [
			{name: 'ASST',					text: '자산코드'		,type: 'string'},			  
			{name: 'ASST_NAME',				text: '자산명'			,type: 'string'},			  
			{name: 'DPR_YYMM',				text: '상각년월'		,type: 'string'},
			{name: 'PM_BALN_AMT',			text: '전월미상각잔액'		,type: 'uniPrice'},
			{name: 'TM_DPR_I',				text: '당월상각액'		,type: 'uniPrice'},			  
			{name: 'TM_REDUCE_I',			text: '당월상각감소분'		,type: 'uniPrice'},
			{name: 'TM_DPR_TOT',			text: '당월말상각누계액'	,type: 'uniPrice'},
			{name: 'DPR_AMT',				text: '당기간상각비'		,type: 'uniPrice'},			  
			{name: 'TM_BALN_AMT',			text: '당월말미상각잔액'	,type: 'uniPrice'},
			{name: 'TM_CAPI_AMT',			text: '당월자본적지출액'	,type: 'uniPrice'},
			{name: 'TM_SALE_AMT',			text: '당월매각/폐기금액'	,type: 'uniPrice'},			  
			{name: 'DPR_STS',				text: '상각상태'		,type: 'string'},
			{name: 'EX_DATE',				text: '결의일자'		,type: 'uniDate'},
			{name: 'EX_NUM',				text: '번호'			,type: 'string'},			  
			{name: 'COST_POOL_NAME',		text: 'Cost Pool'	,type: 'string'},
			{name: 'COST_DIRECT',			text: 'Cost Pool 직과',type: 'string'},
			{name: 'ITEMLEVEL1_NAME',		text: '대분류'			,type: 'string'},			  
			{name: 'ITEMLEVEL2_NAME',		text: '중분류'			,type: 'string'},
			{name: 'ITEMLEVEL3_NAME',		text: '소분류'			,type: 'string'}/*,				// 쿼리 '' AS REMARK 된 컬럼은 삭제하고 expandLastColumn: true로 대체
	    	{name: 'REMARK',				text: '비고' 			,type: 'string'}*/
		]
	});

	var MasterStore = Unilite.createStore('asc110skrMasterStore',{
		model: 'asc110skrModel',
		uniOpt : {
        	isMaster:	true,			// 상위 버튼 연결 
        	editable:	false,			// 수정 모드 사용 
        	deletable:	false,			// 삭제 가능 여부 
            useNavi:	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'asc110skrService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
          	load: function(store, records, successful, eOpts) {
				//조회된 데이터가 있을 때, 그리드에 포커스 가도록 변경
				if(store.getCount() > 0){
		    		masterGrid.focus();
				//조회된 데이터가 없을 때, 패널의 첫번째 필드에 포커스 가도록 변경
	    		}else{
					var activeSForm ;		
					if(!UserInfo.appOption.collapseLeftSearch)	{	
						activeSForm = panelSearch;	
					}else {		
						activeSForm = panelResult;	
					}		
					activeSForm.onLoadSelectText('DPR_YYMM_FR');	
				}
			}          		
      	}
		//groupField: 'CUSTOM_NAME'
	});

	/* panetSearch
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
				fieldLabel: '상각년월',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'DPR_YYMM_FR',
		        endFieldName: 'DPR_YYMM_TO',
		        allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('DPR_YYMM_FR',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DPR_YYMM_TO',newValue);
			    	}
			    }
	        },
				Unilite.popup('ASSET',{ 
				    fieldLabel: '자산코드', 
					valueFieldName: 'ASST', 
					textFieldName: 'ASST_NAME', 
				    validateBlank: false, 
		  		    allowBlank: false,
		  		    autoPopup: true,
//				    popupWidth: 710,
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('ASST', panelSearch.getValue('ASST'));
								panelResult.setValue('ASST_NAME', panelSearch.getValue('ASST_NAME'));
								
								panelSearch.setValue('ACCNT',		records[0].ACCNT);     
								panelSearch.setValue('ACCNT_NAME',	records[0].ACCNT_NAME);	
								panelSearch.setValue('ACP_DATE',	records[0].AC_DATE); 
								panelSearch.setValue('DRB_YEAR',	records[0].DRB_YEAR);	
								panelSearch.setValue('DRB_RATE',	records[0].DEPRECTION); 
								panelSearch.setValue('ACQ_AMT_I',	records[0].AC_AMT_I);	
	                                                                
								panelResult.setValue('ACCNT',		records[0].ACCNT);      
								panelResult.setValue('ACCNT_NAME',	records[0].ACCNT_NAME);	
								panelResult.setValue('ACP_DATE',	records[0].AC_DATE);      
								panelResult.setValue('DRB_YEAR',	records[0].DRB_YEAR);	
								panelResult.setValue('DRB_RATE',	records[0].DEPRECTION);      
								panelResult.setValue('ACQ_AMT_I',	records[0].AC_AMT_I);	
			            	},
							scope: this
							},
						onClear: function(type)	{
							panelResult.setValue('ASST', '');
							panelResult.setValue('ASST_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}/*,
						specialkey: function(elm, e){
							lastFieldSpacialKey(elm, e);
						}*/
					}
			}),{
		 	 	xtype: 'container',
	   			defaultType: 'uniTextfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'계정코드', name: 'ACCNT', width:155,
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT', newValue);
						}
					}
				}, {
					name: 'ACCNT_NAME', width:170,
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT_NAME', newValue);
						}
					}
				}] 
			},{
				fieldLabel: '취득일',
				name: 'ACP_DATE',	
				xtype: 'uniDatefield',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACP_DATE', newValue);
					}
				}
			},{
		 	 	xtype: 'container',
	   			defaultType: 'uniTextfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'내용년수', name: 'DRB_YEAR', width:155,
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DRB_YEAR', newValue);
						}
					}
				}, {
					name: 'DRB_RATE', width:170,
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DRB_RATE', newValue);
						}
					}
				}] 
			},{
				fieldLabel: '취득가액',
				name:'ACQ_AMT_I',	
				xtype: 'uniNumberfield',
				readOnly: true,
				width:325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACQ_AMT_I', newValue);
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
					//this.mask();		    
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{	
			fieldLabel: '상각년월',
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'DPR_YYMM_FR',
	        endFieldName: 'DPR_YYMM_TO',
	        allowBlank: false,
	        autoPopup: true,
			tdAttrs: {width: 380},  
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DPR_YYMM_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DPR_YYMM_TO',newValue);
		    	}
		    }
        },
			Unilite.popup('ASSET',{ 
			    fieldLabel: '자산코드', 
				valueFieldName: 'ASST', 
				textFieldName: 'ASST_NAME', 
			    validateBlank: false, 
	       		allowBlank: false,
	  		    autoPopup: true,
	        	listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelSearch.setValue('ASST', panelResult.getValue('ASST'));
							panelSearch.setValue('ASST_NAME', panelResult.getValue('ASST_NAME'));	
	
							panelSearch.setValue('ACCNT',		records[0].ACCNT);     
							panelSearch.setValue('ACCNT_NAME',	records[0].ACCNT_NAME);	
							panelSearch.setValue('ACP_DATE',	records[0].AC_DATE); 
							panelSearch.setValue('DRB_YEAR',	records[0].DRB_YEAR);	
							panelSearch.setValue('DRB_RATE',	records[0].DEPRECTION); 
							panelSearch.setValue('ACQ_AMT_I',	records[0].AC_AMT_I);	
	                                                            
							panelResult.setValue('ACCNT',		records[0].ACCNT);      
							panelResult.setValue('ACCNT_NAME',	records[0].ACCNT_NAME);	
							panelResult.setValue('ACP_DATE',	records[0].AC_DATE);      
							panelResult.setValue('DRB_YEAR',	records[0].DRB_YEAR);	
							panelResult.setValue('DRB_RATE',	records[0].DEPRECTION);      
							panelResult.setValue('ACQ_AMT_I',	records[0].AC_AMT_I);	
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ASST', '');
						panelSearch.setValue('ASST_NAME', '');
					},
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}/*,
					specialkey: function(elm, e){
						lastFieldSpacialKey(elm, e);
					}*/
				}
		}),{
	 	 	xtype: 'container',
   			defaultType: 'uniTextfield',
			layout: {type: 'hbox', align:'stretch'},
			width:325,
			editable: false,
			items:[{
				fieldLabel:'계정코드', name: 'ACCNT', width:155,
				tdAttrs: {align : 'center'},
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ACCNT', newValue);
					}
				}
			}, {
				name: 'ACCNT_NAME', width:170,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ACCNT_NAME', newValue);
					}
				}
			}] 
		},{
			fieldLabel: '취득일',
			name: 'ACP_DATE',	
			xtype: 'uniDatefield',
			readOnly: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ACP_DATE', newValue);
				}
			}
		},{
	 	 	xtype: 'container',
   			defaultType: 'uniTextfield',
			layout: {type: 'hbox', align:'stretch'},
			items:[{
				fieldLabel:'내용년수', name: 'DRB_YEAR', width:155,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DRB_YEAR', newValue);
					}
				}
			}, {
				name: 'DRB_RATE', width:170,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DRB_RATE', newValue);
					}
				}
			}] 
		},{
			fieldLabel: '취득가액',
			name:'ACQ_AMT_I',	
			xtype: 'uniNumberfield',
			readOnly: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ACQ_AMT_I', newValue);
				}
			}
		}]
	});
	
	var masterGrid = Unilite.createGrid('asc110skrGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        flex: 3,
    	store: MasterStore,
		selModel	: 'rowmodel',
    	uniOpt:{
			useMultipleSorting	: true,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: true,			
	    	filter: {
				useFilter		: true,		
				autoCreate		: true		
			}
		},
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'DPR_YYMM', 		width: 100, 	align: 'center'},
        		   { dataIndex: 'PM_BALN_AMT', 		width: 130},
        		   { dataIndex: 'TM_DPR_I', 		width: 130},
        		   { dataIndex: 'TM_REDUCE_I',		width: 130},
        		   { dataIndex: 'TM_DPR_TOT', 		width: 130},
        		   { dataIndex: 'DPR_AMT', 			width: 130},
        		   { dataIndex: 'TM_BALN_AMT', 		width: 130},
        		   { dataIndex: 'TM_CAPI_AMT', 		width: 130},
        		   { dataIndex: 'TM_SALE_AMT', 		width: 130},
        		   { dataIndex: 'DPR_STS', 			width: 66, 		align: 'center'},
        		   { dataIndex: 'EX_DATE', 			width: 100},
        		   { dataIndex: 'EX_NUM', 			width: 53},
        		   { dataIndex: 'COST_POOL_NAME', 	width: 100},
        		   { dataIndex: 'COST_DIRECT', 		width: 100},
        		   { dataIndex: 'ITEMLEVEL1_NAME', 	width: 100},
        		   { dataIndex: 'ITEMLEVEL2_NAME', 	width: 100},
        		   { dataIndex: 'ITEMLEVEL3_NAME', 	width: 100}/*,							// 쿼리 '' AS REMARK 된 컬럼은 삭제하고 expandLastColumn: true로 대체
				   { dataIndex: 'REMARK',			width:100}*/
        ] 
    });

    /**
	 * main app
	 */
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
		 id  : 'asc110skrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('DPR_YYMM_FR',[getStDt[0].STDT]);
			panelSearch.setValue('DPR_YYMM_TO',[getStDt[0].TODT]);

			panelResult.setValue('DPR_YYMM_FR',[getStDt[0].STDT]);
			panelResult.setValue('DPR_YYMM_TO',[getStDt[0].TODT]);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('DPR_YYMM_FR');	
			
			this.processParams(params);
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.reset();
				MasterStore.clearData();
				masterGrid.getStore().loadStoreRecords();
			}
		},
        //링크로 넘어오는 params 받는 부분 (Asc105skr)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'asc105skr') {
				panelSearch.setValue('ASST',params.ASST);
				panelSearch.setValue('ASST_NAME',params.ASST_NAME);
				panelSearch.setValue('DPR_YYMM_FR',params.DVRY_DATE_FR);
				panelSearch.setValue('DPR_YYMM_TO',params.DVRY_DATE_TO);
				
				panelResult.setValue('ASST',params.ASST);
				panelResult.setValue('ASST_NAME',params.ASST_NAME);
				panelResult.setValue('DPR_YYMM_FR',params.DVRY_DATE_FR);
				panelResult.setValue('DPR_YYMM_TO',params.DVRY_DATE_TO);;
				
				
				//ASST에 따른 세부 정보 세팅
				var param = Ext.getCmp('searchForm').getValues();
				asc110skrService.getDetail(param, function(provider, response) {
					var records = response.result;
					panelSearch.setValue('ACCNT',		records[0].ACCNT);     
					panelSearch.setValue('ACCNT_NAME',	records[0].ACCNT_NAME);	
					panelSearch.setValue('ACP_DATE',	records[0].AC_DATE); 
					panelSearch.setValue('DRB_YEAR',	records[0].DRB_YEAR);	
					panelSearch.setValue('DRB_RATE',	records[0].DEPRECTION); 
					panelSearch.setValue('ACQ_AMT_I',	records[0].AC_AMT_I);	
	                                                    
					panelResult.setValue('ACCNT',		records[0].ACCNT);      
					panelResult.setValue('ACCNT_NAME',	records[0].ACCNT_NAME);	
					panelResult.setValue('ACP_DATE',	records[0].AC_DATE);      
					panelResult.setValue('DRB_YEAR',	records[0].DRB_YEAR);	
					panelResult.setValue('DRB_RATE',	records[0].DEPRECTION);      
					panelResult.setValue('ACQ_AMT_I',	records[0].AC_AMT_I);	

					if(!UniAppManager.app.checkForNewDetail()){
						return false;
					} else{
						masterGrid.reset();
						MasterStore.clearData();
						masterGrid.getStore().loadStoreRecords();
					}
				});
			}
		}
	});
/*
	function lastFieldSpacialKey(elm, e)	{
		if( e.getKey() == Ext.event.Event.ENTER)	{
			if(elm.isExpanded)	{
    			var picker = elm.getPicker();
    			if(picker)	{
    				var view = picker.selectionModel.view;
    				if(view && view.highlightItem)	{
    					picker.select(view.highlightItem);
    				}
    			}
			}else {
				if((hideDivCode && elm.name == 'INPUT_PATH') || elm.name == 'DIV_CODE'){
					var grid = UniAppManager.app.getActiveGrid();
					var record = grid.getStore().getAt(0);
					if(record)	{
						e.stopEvent();
						grid.editingPlugin.startEdit(record,grid.getColumn('AC_DAY'))
					}else {
						UniAppManager.app.onQueryButtonDown();
					}
				}else {
                	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
                		Unilite.focusPrevField(elm, true, e);
                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
                		Unilite.focusNextField(elm, true, e);
                	}
            	}
			}
		}
	}*/
};
</script>
