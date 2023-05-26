<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx360ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="A068" /> <!--대손사유-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
var outDivCode = UserInfo.divCode;
var getTaxBase =	${getTaxBase};
/*var output =''; 	// 입고내역 셋팅 값 확인 alert
for(var key in getTaxBase){
	output += key + '  :  ' + getTaxBase[key] + '\n';
}
alert(output);*/

function appMain() {
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx360ukrService.selectList',
			update: 'atx360ukrService.updateDetail',
			create: 'atx360ukrService.insertDetail',
			destroy: 'atx360ukrService.deleteDetail',
			syncAll: 'atx360ukrService.saveAll'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx360ukrService.selectList2',
			update: 'atx360ukrService.updateDetail2',
			create: 'atx360ukrService.insertDetail2',
			destroy: 'atx360ukrService.deleteDetail2',
			syncAll: 'atx360ukrService.saveAll2'
		}
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx360ukrModel', {
	    fields: [{name: 'FR_PUB_DATE'		,text: '계산서일FR'		,type: 'uniDate'},
				 {name: 'TO_PUB_DATE'		,text: '계산서일TO'		,type: 'uniDate'},
				 {name: 'BILL_DIV_CODE'		,text: '신고사업장' 		,type: 'string'},
				 {name: 'DEBT_DIVI'			,text: '대손구분' 			,type: 'string'},
				 {name: 'SEQ'				,text: '순번' 			,type: 'int'},
				 {name: 'DEBT_DATE'			,text: '대손확정년월일' 		,type: 'uniDate', allowBlank: false},
				 {name: 'SUPPLY_AMT_I'		,text: '대손금액' 			,type: 'uniPrice', allowBlank: false},
				 {name: 'SUBTRACT_RATE'		,text: '공제율' 			,type: 'string', allowBlank: false},
				 {name: 'TAX_AMT_I'			,text: '대손세액' 			,type: 'uniPrice', allowBlank: false},
				 {name: 'CUSTOM_CODE'		,text: 'CUSTOM_CODE' 	,type: 'string'},
				 {name: 'CUSTOM_NAME'		,text: '상호' 			,type: 'string', allowBlank: false},
				 {name: 'PERSON_NUM'		,text: '성명' 			,type: 'string', allowBlank: false},
				 {name: 'COMPANY_NUM'		,text: '사업자등록번호' 		,type: 'string', allowBlank: false},
				 {name: 'ADDR'				,text: '사업장소재지' 		,type: 'string'},
				 {name: 'DEBT_REASON'		,text: '대손사유' 			,type: 'string', comboType: 'AU', comboCode: 'A068'}
		]
	});
	
	Unilite.defineModel('Atx360ukrModel2', {
	    fields: [{name: 'FR_PUB_DATE'		,text: '계산서일FR' 		,type: 'uniDate'},
				 {name: 'TO_PUB_DATE'		,text: '계산서일TO' 		,type: 'uniDate'},
				 {name: 'BILL_DIV_CODE'		,text: '신고사업장' 		,type: 'string'},
				 {name: 'DEBT_DIVI'			,text: '대손구분' 			,type: 'string'},
				 {name: 'SEQ'				,text: '순번' 			,type: 'int'},
				 {name: 'DEBT_DATE'			,text: '변제년월일' 		,type: 'uniDate', allowBlank: false},
				 {name: 'SUPPLY_AMT_I'		,text: '변제금액' 			,type: 'uniPrice', allowBlank: false},
				 {name: 'SUBTRACT_RATE'		,text: '공제율' 			,type: 'string', allowBlank: false},
				 {name: 'TAX_AMT_I'			,text: '변제세액' 			,type: 'uniPrice', allowBlank: false},
				 {name: 'CUSTOM_CODE'		,text: 'CUSTOM_CODE' 	,type: 'string'},
				 {name: 'CUSTOM_NAME'		,text: '상호' 			,type: 'string', allowBlank: false},
				 {name: 'PERSON_NUM'		,text: '성명' 			,type: 'string', allowBlank: false},
				 {name: 'COMPANY_NUM'		,text: '사업자등록번호' 		,type: 'string', allowBlank: false},
				 {name: 'ADDR'				,text: '사업장소재지' 		,type: 'string'},
				 {name: 'DEBT_REASON'		,text: '변제사유' 			,type: 'string'}
		]
	});		
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('atx360ukrMasterStore1',{
			model: 'Atx360ukrModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
            loadStoreRecords : function()	{
				var startField = panelSearch.getField('FR_PUB_DATE');
				var startDateValue = startField.getStartDate();
				var endField = panelSearch.getField('TO_PUB_DATE');
				var endDateValue = endField.getEndDate();
				var billDiviCode = panelSearch.getValue('BILL_DIV_CODE');
				var param= {
					FR_PUB_DATE : startDateValue,
					TO_PUB_DATE : endDateValue,
					BILL_DIV_CODE : billDiviCode
				}
				console.log( param );
				this.load({
					params : param
				});			
			},
			saveStore : function(config)	{	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	if(inValidRecs.length == 0 )	{										
					config = {
						success: function(batch, option) {								
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);			
						 } 
					};					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
			
	});
	
	var MasterStore2 = Unilite.createStore('atx360ukrMasterStore2',{
			model: 'Atx360ukrModel2',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy2,
            loadStoreRecords : function()	{
				var startField = panelSearch.getField('FR_PUB_DATE');
				var startDateValue = startField.getStartDate();
				var endField = panelSearch.getField('TO_PUB_DATE');
				var endDateValue = endField.getEndDate();
				var billDiviCode = panelSearch.getValue('BILL_DIV_CODE');
				var param= {
					FR_PUB_DATE : startDateValue,
					TO_PUB_DATE : endDateValue,
					BILL_DIV_CODE : billDiviCode
				}
				console.log( param );
				this.load({
					params : param
				});			
			},
			saveStore : function(config)	{	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	if(inValidRecs.length == 0 )	{										
					config = {
						success: function(batch, option) {								
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);			
						 } 
					};					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
			
	});	

	/**
	 * 검색조건 (Search Panel)
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
		    items : [{
				fieldLabel: '신고기간',
	            xtype: 'uniMonthRangefield',
	            startFieldName: 'FR_PUB_DATE',
	            endFieldName: 'TO_PUB_DATE',
		        startDD: 'first',
		        endDD: 'last',
	            allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_PUB_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_PUB_DATE',newValue);
			    	}
			    }
	     	},{
				fieldLabel: '신고사업장',
				name:'BILL_DIV_CODE',	
				xtype: 'uniCombobox',
				comboType:'BOR120' ,
				comboCode	: 'BILL',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				} 
			},{
		 		fieldLabel: '신고일자',
		 		xtype: 'uniDatefield',
		 		name: 'WRITE_DATE',
		        value: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WRITE_DATE', newValue);
					}
				}
			},{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		margin: '0 0 0 120', 
//	    		id:'WRITE_DATE0',
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					UniAppManager.app.onPrintButtonDown();
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
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	}); 

	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    items :[{ 
			fieldLabel: '신고기간',
            xtype: 'uniMonthRangefield',
            startFieldName: 'FR_PUB_DATE',
            endFieldName: 'TO_PUB_DATE',
	        startDD: 'first',
	        endDD: 'last',
            allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_PUB_DATE',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_PUB_DATE',newValue);
		    	}
		    }
     	},{
			fieldLabel: '신고사업장',
			name:'BILL_DIV_CODE',	
			xtype: 'uniCombobox',
			comboType:'BOR120' ,
			comboCode	: 'BILL',
            allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				}
			} 
		},{
	 		fieldLabel: '신고일자',
	 		xtype: 'uniDatefield',
	 		name: 'WRITE_DATE',
	        value: UniDate.get('today'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WRITE_DATE', newValue);
				}
			}
		},{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		margin: '0 0 0 120', 
//	    		id:'WRITE_DATE0',
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					UniAppManager.app.onPrintButtonDown();
				}
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
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('atx360ukrGrid1', {
    	// for tab 
    	title: '대손발생',
    	layout : 'fit',
        region : 'center',
        store : MasterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true,
		 			copiedRow: true
        },
		store: MasterStore,
     	features: [{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'FR_PUB_DATE'	 	,		width: 80, hidden: true},       			
        		   { dataIndex: 'TO_PUB_DATE'	 	,		width: 80, hidden: true},       			
        		   { dataIndex: 'BILL_DIV_CODE'	 	,		width: 80, hidden: true},       			
        		   { dataIndex: 'DEBT_DIVI'		 	,		width: 80, hidden: true},       			
        		   { dataIndex: 'SEQ'			 	,		width: 80, hidden: true},       			
        		   { dataIndex: 'DEBT_DATE'		 	,		width: 110},       			
        		   { dataIndex: 'SUPPLY_AMT_I'	 	,		width: 100},       			
        		   { dataIndex: 'SUBTRACT_RATE'	 	,		width: 66},       			
        		   { dataIndex: 'TAX_AMT_I'		 	,		width: 100},       			
        		    
				   { dataIndex: 'CUSTOM_NAME'		,width: 200 ,
						'editor' : Unilite.popup('CUST_G',{
					 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
			  				autoPopup: true,
							listeners: {'onSelected': {
									fn: function(records, type) {
							    	    console.log('records : ', records);
									    Ext.each(records, function(record,i) {													                   
											if(i==0) {
												masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
											}
										}); 
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setCustData(null,true, masterGrid.uniOpt.currentRecord);
								}
							}
						}) 		
				   },       			
        		   { dataIndex: 'PERSON_NUM'	 	,		width: 100},       			
        		   { dataIndex: 'COMPANY_NUM'	 	,		width: 133},       			
        		   { dataIndex: 'ADDR'			 	,		width: 200},       			
        		   { dataIndex: 'DEBT_REASON'	 	,		width: 100}       			
        ],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(!e.record.phantom) {
	        		if(UniUtils.indexOf(e.field, ['SUBTRACT_RATE']))
				   	{
						return false;
      				} else {
      					return true;
      				}
	        	} else {
	        		if(UniUtils.indexOf(e.field, ['SUBTRACT_RATE']))
				   	{
						return false;
      				} else {
      					return true;
      				}
	        	}r
	        }
		},
		setCustData: function(record, dataClear, grdRecord) {	
       		if(dataClear) {
       			grdRecord.set('CUSTOM_CODE'			, "");
       			grdRecord.set('CUSTOM_NAME'			, "");
       			grdRecord.set('PERSON_NUM'			, "");
       			grdRecord.set('COMPANY_NUM'			, "");
       			grdRecord.set('ADDR'				, "");
				
       		} else {
       			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
       			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
       			grdRecord.set('PERSON_NUM'			, record['TOP_NAME']);
       			grdRecord.set('COMPANY_NUM'			, record['COMPANY_NUM']);
       			grdRecord.set('ADDR'				, record['ADDR1']);
       		}
		} 
    });
    
    var masterGrid2 = Unilite.createGrid('atx360ukrGrid2', {
    	// for tab 
    	title: '대손변제',
    	layout : 'fit',
        region : 'center',
        store : MasterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
		store: MasterStore2,
     	features: [{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'FR_PUB_DATE'		, 		width: 80, hidden: true},       			
        		   { dataIndex: 'TO_PUB_DATE'		, 		width: 80, hidden: true},       			
        		   { dataIndex: 'BILL_DIV_CODE'		, 		width: 80, hidden: true},       			
        		   { dataIndex: 'DEBT_DIVI'			, 		width: 80, hidden: true},       			
        		   { dataIndex: 'SEQ'				, 		width: 80, hidden: true},       			
        		   { dataIndex: 'DEBT_DATE'			, 		width: 110},       			
        		   { dataIndex: 'SUPPLY_AMT_I'		, 		width: 100},       			
        		   { dataIndex: 'SUBTRACT_RATE'		, 		width: 66},       			
        		   { dataIndex: 'TAX_AMT_I'			, 		width: 100},       			
        		   { dataIndex: 'CUSTOM_NAME'		,width: 200 ,
						'editor' : Unilite.popup('CUST_G',{
					 		extParam: {DIV_CODE: outDivCode},
			  				autoPopup: true,
							listeners: {'onSelected': {
									fn: function(record, type) {
							    	    masterGrid2.setCustData(record[0],false, masterGrid2.uniOpt.currentRecord);
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid2.setCustData(null,true, masterGrid2.uniOpt.currentRecord);
								}
							}
						}) 		
				   },       			
        		   { dataIndex: 'PERSON_NUM'		, 		width: 100},       			
        		   { dataIndex: 'COMPANY_NUM'		, 		width: 133},       			
        		   { dataIndex: 'ADDR'				, 		width: 166},       			
        		   { dataIndex: 'DEBT_REASON'		, 		width: 100}     			
        ],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(!e.record.phantom) {
	        		if(UniUtils.indexOf(e.field, ['SUBTRACT_RATE']))
				   	{
						return false;
      				} else {
      					return true;
      				}
	        	} else {
	        		if(UniUtils.indexOf(e.field, ['SUBTRACT_RATE']))
				   	{
						return false;
      				} else {
      					return true;
      				}
	        	}
	        }
		},
		setCustData: function(record, dataClear, grdRecord) {	
       		if(dataClear) {
       			grdRecord.set('CUSTOM_CODE'			, "");
       			grdRecord.set('CUSTOM_NAME'			, "");
       			grdRecord.set('HIRE_CUST_CD'			, "");
       			grdRecord.set('HIRE_CUST_NM'			, "");
       			grdRecord.set('COMPANY_NUM'				, "");
				
       		} else {
       			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
       			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
       			grdRecord.set('HIRE_CUST_CD'			, record['CUSTOM_CODE']);
       			grdRecord.set('HIRE_CUST_NM'			, record['CUSTOM_NAME']);
       			grdRecord.set('COMPANY_NUM'				, record['COMPANY_NUM']);
       		}
		}
    });    
     
     var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    region: 'center',
	    items: [
	         masterGrid, masterGrid2
	    ],
	    listeners:  {
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
	     		var newTabId = newCard.getId();
					console.log("newCard:  " + newCard.getId());
					console.log("oldCard:  " + oldCard.getId());
					
				switch(newTabId)	{
					case 'atx360ukrGrid1':
						MasterStore.loadStoreRecords();
						break;
						
					case 'atx360ukrGrid2':
						MasterStore2.loadStoreRecords();
						break;
						
					default:
						break;
				}
	     	}
	     }
     });
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				tab, panelResult
			]	
		}		
		, panelSearch
		],
		id  : 'atx360ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
			panelSearch.setValue('FR_PUB_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_PUB_DATE', UniDate.get('endOfMonth'));
			panelResult.setValue('FR_PUB_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('TO_PUB_DATE', UniDate.get('endOfMonth'));
			UniAppManager.setToolbarButtons(['reset', 'newData'], false);
		},
		onQueryButtonDown : function()	{		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'atx360ukrGrid1') {
				MasterStore.loadStoreRecords();			
			} else if(activeTabId == 'atx360ukrGrid2') {
				MasterStore2.loadStoreRecords();			
			}
			UniAppManager.setToolbarButtons(['newData', 'reset'], true); 
		},
		onNewDataButtonDown: function()	{		// 행추가
			var activeTabId = tab.getActiveTab().getId();	
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();		
			if(activeTabId == 'atx360ukrGrid1') {
				var compCode    	=	UserInfo.compCode;   
				var billDivCode 	=	panelSearch.getValue('BILL_DIV_CODE');
				var frPubDate		=	startDateValue;	    
				var toPubDate      	=	endDateValue;
				var debtDivi       	=	'1';
				var seq 			= 	MasterStore.max('SEQ');
            		if(!seq) seq = 1;
            		else seq += 1;
				var debtDate       	=	'';
				var supplyAmtI     	=	'';
				var subtractRate   	=	getTaxBase[0].SUBTRACT_RATE;
				var taxAmtI        	=	'';
				var customCode     	=	'';
				var personNum      	=	'';
				var companyNum     	=	'';
				var addr          	=	'';
				var debtReason  	=	'';
				
				var r = {
					COMP_CODE    	:	compCode,    
					BILL_DIV_CODE	:	billDivCode, 
					FR_PUB_DATE		:	frPubDate, 	
					TO_PUB_DATE		:	toPubDate,  
					DEBT_DIVI		:	debtDivi, 
					SEQ				:	seq, 
					DEBT_DATE		:	debtDate, 
					SUPPLY_AMT_I	:	supplyAmtI, 
					SUBTRACT_RATE	:	subtractRate, 
					TAX_AMT_I		:	taxAmtI, 
					CUSTOM_CODE		:	customCode, 
					PERSON_NUM		:	personNum, 
					COMPANY_NUM		:	companyNum, 
					ADDR			:	addr, 
					DEBT_REASON		:	debtReason
				};
				masterGrid.createRow(r);
			} else if(activeTabId == 'atx360ukrGrid2') {
				var compCode    	=	UserInfo.compCode;   
				var billDivCode 	=	panelSearch.getValue('BILL_DIV_CODE');
				var frPubDate		=	startDateValue;	    
				var toPubDate      	=	endDateValue;
				var debtDivi       	=	'2';
				var seq 			= 	MasterStore2.max('SEQ');
            		if(!seq) seq = 1;
            		else seq += 1;
				var debtDate       	=	'';
				var supplyAmtI     	=	'';
				var subtractRate   	=	getTaxBase[0].SUBTRACT_RATE;
				var taxAmtI        	=	'';
				var customCode     	=	'';
				var personNum      	=	'';
				var companyNum     	=	'';
				var addr          	=	'';
				var debtReason  	=	'';
				
				var r = {
					COMP_CODE    	:	compCode,    
					BILL_DIV_CODE	:	billDivCode, 
					FR_PUB_DATE		:	frPubDate, 	
					TO_PUB_DATE		:	toPubDate,  
					DEBT_DIVI		:	debtDivi, 
					SEQ				:	seq, 
					DEBT_DATE		:	debtDate, 
					SUPPLY_AMT_I	:	supplyAmtI, 
					SUBTRACT_RATE	:	subtractRate, 
					TAX_AMT_I		:	taxAmtI, 
					CUSTOM_CODE		:	customCode, 
					PERSON_NUM		:	personNum, 
					COMPANY_NUM		:	companyNum, 
					ADDR			:	addr, 
					DEBT_REASON		:	debtReason
				};
				masterGrid2.createRow(r);
			}
			UniAppManager.setToolbarButtons('reset', true); 
		},
		onDeleteDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'atx360ukrGrid1') {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow();
				}
			} else if(activeTabId == 'atx360ukrGrid2') {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid2.deleteSelectedRow();
				}
			}
		},
		onPrintButtonDown: function() {
			//测试打印报表
			var map = panelSearch.getValues();
			map['FR_PUB_DATE'] = panelSearch.getField('FR_PUB_DATE').getStartDate();
			map['TO_PUB_DATE'] = panelSearch.getField('TO_PUB_DATE').getEndDate();
			map['TAX_BASE'] = getTaxBase[0].TAX_BASE;
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/atx/atx360ukr.do',
				prgID: 'atx360ukr',
				extParam: map
				});
			win.center();
			win.show();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'atx360ukrGrid1') {
				MasterStore.saveStore();
			} else if(activeTabId == 'atx360ukrGrid2') {
				MasterStore2.saveStore();
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			this.fnInitBinding();
			MasterStore.clearData();
			MasterStore2.clearData();          
         	UniAppManager.setToolbarButtons(['save', 'newdata'], false); 
		}
		
	});
	
	Unilite.createValidator('validator01', {
		store: MasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "SUPPLY_AMT_I" :	// 대손금액
					record.set('TAX_AMT_I',(Math.floor(newValue * record.get('SUBTRACT_RATE').substring(0, 2) / record.get('SUBTRACT_RATE').substring(3, 6))));
				break;
			}
			return rv;
		}
	})
	
	Unilite.createValidator('validator02', {
		store: MasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "SUPPLY_AMT_I" :	// 변제금액
					record.set('TAX_AMT_I',(Math.floor(newValue * record.get('SUBTRACT_RATE').substring(0, 2) / record.get('SUBTRACT_RATE').substring(3, 6))));
				break;
			}
			return rv;
		}
	})
};
</script>
