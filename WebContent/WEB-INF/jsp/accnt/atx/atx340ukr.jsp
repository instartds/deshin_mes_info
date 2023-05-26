<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx340ukr"  >
<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 --> 
<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
<t:ExtComboStore comboType="AU" comboCode="A092"  /> 		<!-- 제출사유 -->
<t:ExtComboStore comboType="AU" comboCode="S024" /> 		<!-- 부가세유형 -->
<t:ExtComboStore comboType="AU" comboCode="A149" />			<!-- 전자발행여부 -->
<t:ExtComboStore comboType="AU" comboCode="M302" />			<!-- 매입유형 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var outDivCode = UserInfo.divCode;

var excelWindow;	// 엑셀참조

function appMain() {   
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx340ukrService.selectDetail',
			update: 'atx340ukrService.updateDetail',
			create: 'atx340ukrService.insertDetail',
			destroy: 'atx340ukrService.deleteDetail',
			syncAll: 'atx340ukrService.saveAll'
		}
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx340Model', {
	   fields: [
			{name: 'FR_PUB_DATE'		, text: 'FR_PUB_DATE'			, type: 'uniDate'},
			{name: 'TO_PUB_DATE' 		, text: 'TO_PUB_DATE'			, type: 'uniDate'},
			{name: 'BILL_DIV_CODE' 		, text: 'BILL_DIV_CODE'			, type: 'string'},
			{name: 'SEQ'	    		, text: '(12)일련번호'					, type: 'int'},
			{name: 'EXPORT_NUM' 		, text: '(13)수출신고번호'				, type: 'string', allowBlank: false, maxLength: 16},
			{name: 'SHIP_DATE'			, text: '(14)선(기)적일자'				, type: 'uniDate', allowBlank: false},
			{name: 'MONEY_UNIT'			, text: '(15)통화코드'				, type: 'string', allowBlank: false},
			{name: 'EXCHG_RATE_O'		, text: '(16)환율'				, type: 'uniER'},
			{name: 'FOR_AMT_I'			, text: '(17)외화금액'				, type: 'uniFC'},
			{name: 'AMT_I' 				, text: '(18)원화금액'				, type: 'uniPrice', convert:UniAccnt.getCalWon},
			{name: 'UPDATE_DB_USER'		, text: '수정자'					, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'					, type: 'uniDate'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'				, type: 'string'}
	    ]
	});		// End of Ext.define('Atx340ukrModel', {

	// 엑셀참조
	Unilite.Excel.defineModel('excel.atx340.sheet01', {
	    fields: [
			{name: 'FR_PUB_DATE'		, text: 'FR_PUB_DATE'			, type: 'uniDate'},
			{name: 'TO_PUB_DATE' 		, text: 'TO_PUB_DATE'			, type: 'uniDate'},
			{name: 'BILL_DIV_CODE' 		, text: 'BILL_DIV_CODE'			, type: 'string'},
			{name: 'SEQ'	    		, text: '(12)일련번호'					, type: 'int'},
			{name: 'EXPORT_NUM' 		, text: '(13)수출신고번호'				, type: 'string'},
			{name: 'SHIP_DATE'			, text: '(14)선(기)적일자'				, type: 'uniDate'},
			{name: 'MONEY_UNIT'			, text: '(15)통화코드'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '(16)환율'				, type: 'uniER'},
			{name: 'FOR_AMT_I'			, text: '(17)외화금액'				, type: 'uniFC'},
			{name: 'AMT_I' 				, text: '(18)원화금액'				, type: 'uniPrice', convert:UniAccnt.getCalWon},
			{name: 'UPDATE_DB_USER'		, text: '수정자'					, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'					, type: 'uniDate'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'				, type: 'string'}
	    ]
	});
	
	function openExcelWindow() {
		
			var me = this;
	        var appName = 'Unilite.com.excel.ExcelUploadWin';

            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'atx340',
                        grids: [{
                        		itemId: 'grid01',
                        		title: '수출실적명세서',                        		
                        		useCheckbox: false,
                        		model : 'excel.atx340.sheet01',
                        		readApi: 'atx340ukrService.selectExcelUploadSheet1',
                        		columns: [        
						        	{dataIndex: 'FR_PUB_DATE'		, width: 66, hidden: true}, 				
									{dataIndex: 'TO_PUB_DATE' 		, width: 66, hidden: true}, 				
									{dataIndex: 'BILL_DIV_CODE' 	, width: 66, hidden: true}, 				
									{dataIndex: 'SEQ'	    		, width: 80, hidden: true}, 				
									{dataIndex: 'EXPORT_NUM' 		, width: 133}, 				
									{dataIndex: 'SHIP_DATE'			, width: 133}, 				
									{dataIndex: 'MONEY_UNIT'		, width: 100}, 				
									{dataIndex: 'EXCHG_RATE_O'		, width: 173}, 				
									{dataIndex: 'FOR_AMT_I'			, width: 173}, 				
									{dataIndex: 'AMT_I' 			, width: 173}, 				
									{dataIndex: 'UPDATE_DB_USER'	, width: 0, hidden: true}, 				
									{dataIndex: 'UPDATE_DB_TIME'	, width: 0, hidden: true}, 				
									{dataIndex: 'COMP_CODE'			, width: 0, hidden: true}			
										
								]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
                        	var me = this;
                        	var grid = this.down('#grid01');
                        	
                        	if(grid.getStore().getCount() < 1) {
                        		alert('업로드된 데이터가 없습니다.');
                        		return;
                        	}
                        	
                			var records = grid.getStore().getAt(0);	
				        	var startField = panelSearch.getField('FR_PUB_DATE');
							var startDateValue = startField.getStartDate();
							var endField = panelSearch.getField('TO_PUB_DATE');
							var endDateValue = endField.getEndDate();
							var billDiviCode = panelSearch.getValue('BILL_DIV_CODE');
							var param= {
								FR_PUB_DATE : startDateValue,
								TO_PUB_DATE : endDateValue,
								BILL_DIV_CODE : billDiviCode,
								"_EXCEL_JOBID": records.get('_EXCEL_JOBID')
							};
                        	excelWindow.getEl().mask('로딩중...','loading-indicator');
//				        	inputTable.getForm().load({
//				        		params : param,
//								success: function(form, action) {
									atx340ukrService.selectExcelUploadSheet1(param, function(provider, response){
								    	var store = masterGrid.getStore();
								    	var records = response.result;
								    	console.log("response",response)
										excelWindow.getEl().unmask();
										
										var startField = panelSearch.getField('FR_PUB_DATE');
										var startDateValue = startField.getStartDate();
										var endField = panelSearch.getField('TO_PUB_DATE');
										var endDateValue = endField.getEndDate();
										var billDivCode 	=	panelSearch.getValue('BILL_DIV_CODE');
										var frPubDate		=	startDateValue;	    
										var toPubDate      	=	endDateValue;
							       		
										var seq1 = masterGrid.getStore().max("SEQ");
										
										if(seq1 == null)
											seq1 = 0;
										
										for(var i=0; i<records.length; i++) { 
											records[i].BILL_DIV_CODE = panelSearch.getValue('BILL_DIV_CODE');
											records[i].FR_PUB_DATE   = frPubDate;
											records[i].TO_PUB_DATE   = toPubDate;
											records[i].SEQ			 = records[i].SEQ  + seq1;
											masterGrid.createRow(records[i]);
										} 
										grid.getStore().removeAll();
										me.hide();
								    });
//								}
//				        	});
                		}
                 });
            }
            excelWindow.center();
            excelWindow.show();
	}
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('atx340MasterStore1',{
		model: 'Atx340Model',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
            allDeletable: true,
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
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
						
						inputTable.resetDirtyStatus();
			            UniAppManager.updateStatus(Msg.sMB011, true);// "저장되었습니다.
		            	//UniAppManager.app.onQueryButtonDown();	
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load:function( store, records ){
				if(records.length > 0){
					UniAppManager.app.setInputTable(false);
				} else {
					UniAppManager.app.addReference()
				}
			},
			add:function( store, records )	{
				UniAppManager.app.setInputTable(true);
			},	
			remove:function( store, records )	{
				UniAppManager.app.setInputTable(true);
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
				UniAppManager.app.setInputTable(true);
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
	        	fieldLabel: '계산서일',
				xtype: 'uniMonthRangefield',  
				startFieldName: 'FR_PUB_DATE',
				endFieldName: 'TO_PUB_DATE',
		        startDD: 'first',
		        endDD: 'last',
		        holdable: 'hold',
				allowBlank:false,
				width: 315,
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
				comboType:'BOR120',
				comboCode	: 'BILL',
		        holdable: 'hold',
				value: 'userInfo.divCode',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
		 		fieldLabel: '작성일자',
		 		xtype: 'uniDatefield',
		 		name: 'WRITE_DATE',
		        holdable: 'hold',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WRITE_DATE', newValue);
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
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
    	items: [{ 
        	fieldLabel: '계산서일',
			xtype: 'uniMonthRangefield',  
			startFieldName: 'FR_PUB_DATE',
			endFieldName: 'TO_PUB_DATE',
			allowBlank:false,
	        holdable: 'hold',
			width: 315,
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
			comboType:'BOR120',
			comboCode	: 'BILL',
	        holdable: 'hold',
			value: 'userInfo.divCode',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				}
			}
		},{
	 		fieldLabel: '작성일자',
	 		xtype: 'uniDatefield',
	 		name: 'WRITE_DATE',
	        holdable: 'hold',
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WRITE_DATE', newValue);
				}
			}
		},{
        	margin		: '0 0 0 41',
        	xtype		: 'button',
			text		: '출력',
			width		: 100,
			id			: 'btnCustom',
			handler		: function() {
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
				var win = Ext.create('widget.PDFPrintWindow', {
					url: CPATH+'/atx/atx340rkrPrint.do',
					prgID: 'atx340rkr',
					extParam: param
					});
				win.center();
				win.show();  
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
	
	var inputTable = Unilite.createForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 3},
		disabled: false,
        border:true,
        padding:'1 1 1 1',
		region: 'center',
		items: [{
			disabled: false,
			flex: 1.5,
			xtype: 'container',
			bodyPadding: 10,
			//region: 'north',
		    layout: {
		    	type: 'uniTable', columns: 5, 
		    	tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
	    		tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		    },
		    defaults: {width: 140},
		    items: [
		    	{ xtype: 'component',  html:'구 분'},
		    	{ xtype: 'component',  html:'건수'},
		    	{ xtype: 'component',  html:'외화금액'},
		    	{ xtype: 'component',  html:'원화금액'},
		    	{ xtype: 'component',  html:'비고'},
		
				{ xtype: 'component',  html:'(9)합    계'},
		    	{ xtype: 'uniNumberfield', value:'0', name:'OTHER_NUM1', readOnly:true},
		    	{ xtype: 'uniNumberfield', value:'0', name:'FOR_OTHER_AMT1', readOnly:true, type:'uniFC'},
		    	{ xtype: 'uniNumberfield', value:'0', name:'OTEHR_AMT1', readOnly:true},
		    	{ xtype: 'uniTextfield', name:'REMARK1'	 },
		
				{ xtype: 'component',  html:'(10)수출재화(=(12)합계)'},
		    	{ xtype: 'uniNumberfield', value:'0', name:'OTHER_NUM2', readOnly:true},       
		    	{ xtype: 'uniNumberfield', value:'0', name:'FOR_OTHER_AMT2', readOnly:true, type:'uniFC'},   
		    	{ xtype: 'uniNumberfield', value:'0', name:'OTEHR_AMT2', readOnly:true},       
		    	{ xtype: 'uniTextfield', name:'REMARK2'  	 },
		
				{ xtype: 'component',  html:'(11)기타영세율 적용'},
		    	{ xtype: 'uniNumberfield', name:'OTHER_NUM3', value:'0',
	 				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							inputTable.setValue('OTHER_NUM1', newValue + inputTable.getValue('OTHER_NUM2'));
						}
					}  
				},
		    	{ xtype: 'uniNumberfield', name:'FOR_OTHER_AMT3', value:'0',  type:'uniFC',
	 				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							inputTable.setValue('FOR_OTHER_AMT1', newValue + inputTable.getValue('FOR_OTHER_AMT2'));
						}
					}  
				},
		    	{ xtype: 'uniNumberfield', name:'OTEHR_AMT3', value:'0',
	 				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							inputTable.setValue('OTEHR_AMT1', newValue + inputTable.getValue('OTEHR_AMT2'));
						}
					}  
				},
		    	{ xtype: 'uniTextfield', name:'REMARK3' 	 }
			]
		},{
			xtype:'container',
			padding: '0 0 0 10',
				html: '<b>※ 작성방법 </b><br/><br/> 1. 엑셀참조를 클릭합니다. </br> 2. 엑셀을 다운로드하고 파일을 양식에 맞춰 작성합니다.</br> 3. [업로드] 버튼을 눌러 팝업창에 데이터를 업로드합니다. <br/> 4. [적용]버튼을 눌러 데이터를 확인하고 저장합니다.',
			style: {
				color: 'blue'				
			}
		}],
		api: {
	 		load: 'atx340ukrService.selectMaster',
			submit: 'atx340ukrService.syncMaster'		
		},
		listeners:{
			dirtychange : function ( form, dirty, eOpts )	{
				 if(!inputTable.uniOpt.inLoading && dirty)	{
					 UniAppManager.setToolbarButtons('save',true);
				 }
			},
			validitychange  : function ( form, valid, eOpts )	{
				 if(!inputTable.uniOpt.inLoading)	{
					 UniAppManager.setToolbarButtons('save',true);
				 }
			}
		}
	});
		
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('atx340Grid1', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	
    		dock: 'top',
    		showSummaryRow: true
    	}],
    	tbar: [{
				xtype: 'button',
				text: '엑셀참조',
	        	handler: function() {
	        		//UniAppManager.app.onQueryButtonDown();
		        	openExcelWindow();
		        }
			},{
				xtype: 'button',
				text: '재참조',
				handler: function() {
					UniAppManager.app.setClearRefresh();
				}
		}],
        columns: [        
        	{dataIndex: 'FR_PUB_DATE'		, width: 66, hidden: true}, 				
			{dataIndex: 'TO_PUB_DATE' 		, width: 66, hidden: true}, 				
			{dataIndex: 'BILL_DIV_CODE' 	, width: 66, hidden: true}, 				
			
			{dataIndex: 'SEQ'				, width: 100}, 				
			{dataIndex: 'EXPORT_NUM' 		, width: 150,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '[합계]');
            	}
            }, 				
			{dataIndex: 'SHIP_DATE'			, width: 133}, 				
			{dataIndex: 'MONEY_UNIT'		, width: 100,
			 	'editor' : Unilite.popup('MONEY_UNIT_G',{		
			 		textFieldName: 'MONEY_UNIT',
			 		DBtextFieldName: 'MONEY_UNIT',
			 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
			  		autoPopup: true,
					listeners: {'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid.setMoneUnit(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setMoneUnit(record,false, masterGrid.uniOpt.currentRecord);
									}
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setMoneUnit(null,true, masterGrid.uniOpt.currentRecord);
						}
					}
				}) 		
			 }, 				
			{dataIndex: 'EXCHG_RATE_O'		, width: 173}, 				
			{dataIndex: 'FOR_AMT_I'			, width: 173, summaryType: 'sum'}, 				
			{dataIndex: 'AMT_I' 			, width: 173, summaryType: 'sum'}, 				
			{dataIndex: 'UPDATE_DB_USER'	, width: 80, hidden: true}, 				
			{dataIndex: 'UPDATE_DB_TIME'	, width: 80, hidden: true}, 				
			{dataIndex: 'COMP_CODE'			, width: 80, hidden: true}			
				
		],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(!e.record.phantom) {
	        		if(UniUtils.indexOf(e.field,['SEQ'])) 
					{ 
						return false;
      				} else {
      					return true
      				}
	        	} else {
	        	 	return true;
	        	}
	        }
		},
		setMoneUnit: function(record, dataClear, grdRecord) {	
       		if(dataClear) {
       			grdRecord.set('MONEY_UNIT'			, "");
				
       		} else {
       			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
       		}
		}
    });    
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[
					{
						region : 'center',
						xtype : 'container',
						layout : 'fit',
						items : [ masterGrid ]
					},
					panelResult,
					{
						region : 'north',
						xtype : 'container',
						highth: 20,
						layout : 'fit',
						items : [ inputTable ]
					}
				]
		},
		panelSearch  	
		],
		id : 'atx340App',
		fnInitBinding : function() {
			panelSearch.setValue('BILL_DIV_CODE', baseInfo.gsBillDivCode);
			panelResult.setValue('BILL_DIV_CODE', baseInfo.gsBillDivCode);
			panelSearch.setValue('FR_PUB_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('FR_PUB_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_PUB_DATE', UniDate.get('endOfMonth'));
			panelResult.setValue('TO_PUB_DATE', UniDate.get('endOfMonth'));
			panelSearch.setValue('WRITE_DATE', UniDate.get('today'));
			panelResult.setValue('WRITE_DATE', UniDate.get('today'));
			UniAppManager.setToolbarButtons(['detail','newData'],false);
			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons('deleteAll',false);
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}	
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
			
			inputTable.getForm().load({
				params : param,
				success: function(form, action) {
					if(action && action.result && action.result.data && action.result.data.EMPTY_DATA) {
						//저장된 명세서가 없는 경우 기타영세율의 경우 부가세정보(proof_kind = '41/기타수출(영세율)')에서 조회하여 신규 입력가능 하도록 함
						atx340ukrService.fnGetReferenceEtc(param, function(provider, response){	
							if(provider != null) {
								var record = provider[0];
								if(record != null && record.OTHER_NUM3 > 0 )	{
									inputTable.setValue('OTHER_NUM3'	 , record.OTHER_NUM3);
									inputTable.setValue('FOR_OTHER_AMT3' , record.FOR_OTHER_AMT3);
									inputTable.setValue('OTEHR_AMT3'	 , record.OTEHR_AMT3);
									UniAppManager.updateStatus("기타영세율 값이 참조 되었습니다.");
									UniAppManager.setToolbarButtons(['save'], true);
								}
							}
						});
					} else {
						directMasterStore.loadStoreRecords();
					}
					
				}
			});
			UniAppManager.setToolbarButtons(['newData'], true);
		},
		onNewDataButtonDown: function()	{		// 행추가
			var count = masterGrid.getStore().getCount();
        	inputTable.setValue('OTHER_NUM2', count+1);
        	inputTable.setValue('OTHER_NUM1', inputTable.getValue('OTHER_NUM2') + inputTable.getValue('OTHER_NUM3'));
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();		
			var compCode    	=	UserInfo.compCode;   
			var billDivCode 	=	panelSearch.getValue('BILL_DIV_CODE');
			var frPubDate		=	startDateValue;	    
			var toPubDate      	=	endDateValue;
        	var seq				=	parseInt(Unilite.nvl(directMasterStore.max('SEQ'), 0)) + 1;
        	var shipDate		=	'';
        	var exportNum      	=	'';
        	var moneyUnit      	=	'';
        	var exchgRateO     	=	'';
        	var forAmtI        	=	'0';
        	var amtI           	=	'0';
			
			var r = {
				COMP_CODE    	:	compCode,    
				BILL_DIV_CODE	:	billDivCode, 
				FR_PUB_DATE		:	frPubDate, 	
				TO_PUB_DATE		:	toPubDate,  
				SEQ				:	seq,  
				SHIP_DATE		:	shipDate,
				EXPORT_NUM		:	exportNum, 
				MONEY_UNIT		:	moneyUnit, 
				EXCHG_RATE_O	:	exchgRateO, 
				FOR_AMT_I		:	forAmtI, 
				AMT_I			:	amtI
			};
			masterGrid.createRow(r);
			UniAppManager.setToolbarButtons('deleteAll',true);
		},
		onSaveDataButtonDown: function (config) {			
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
			inputTable.getForm().submit({
				params : param,
				success : function(form, action) {
		 			inputTable.getForm().wasDirty = false;
		 			if(!directMasterStore.isDirty())	{
		   				inputTable.resetDirtyStatus();
			            UniAppManager.updateStatus(Msg.sMB011, true);// "저장되었습니다.
			            UniAppManager.setToolbarButtons('save', false); 
		            	//UniAppManager.app.onQueryButtonDown();	
		   			} else {
		   				directMasterStore.saveStore();
		   			}
					//inputTable.resetDirtyStatus();											
					//UniAppManager.setToolbarButtons('save', false);	
		            //UniAppManager.updateStatus(Msg.sMB011, true);// "저장되었습니다.
	            	//UniAppManager.app.onQueryButtonDown();
				}	
			});
		},
		onDeleteDataButtonDown: function() {
			var count = masterGrid.getStore().getCount();
        	inputTable.setValue('OTHER_NUM2', count-1);
        	inputTable.setValue('OTHER_NUM1', inputTable.getValue('OTHER_NUM2') + inputTable.getValue('OTHER_NUM3'));
			var record = masterGrid.getSelectedRecord();
			masterGrid.deleteSelectedRow();
		},
		setInputTable: function(pInLoading) {
        	var count = masterGrid.getStore().getCount();
        	inputTable.setValue('OTHER_NUM2', count);
        	inputTable.setValue('OTHER_NUM1', count + inputTable.getValue('OTHER_NUM3'));	// 건수
        	
			var results = directMasterStore.sumBy(function(record, id) {
				return true;
			}, 
			['FOR_AMT_I', 'AMT_I']);
			forOtherAmt = results.FOR_AMT_I;			
			otherAmt = results.AMT_I;
			inputTable.uniOpt.inLoading = pInLoading;
			inputTable.setValue('FOR_OTHER_AMT2', forOtherAmt); 
			inputTable.setValue('FOR_OTHER_AMT1', forOtherAmt + inputTable.getValue('FOR_OTHER_AMT3')); 	// 외화금액
			
			inputTable.setValue('OTEHR_AMT2', otherAmt); 
			inputTable.setValue('OTEHR_AMT1', otherAmt + inputTable.getValue('OTEHR_AMT3')); 	// 원화금액
			if(Ext.isEmpty(inputTable.getValue("OTHER_NUM3")))	{
				inputTable.setValue("OTHER_NUM3", 0);
			}
			if(Ext.isEmpty(inputTable.getValue("FOR_OTHER_AMT3")))	{
				inputTable.setValue("FOR_OTHER_AMT3", 0);
			}
			if(Ext.isEmpty(inputTable.getValue("OTEHR_AMT3")))	{
				inputTable.setValue("OTEHR_AMT3", 0);
			}
			inputTable.uniOpt.inLoading = false;
		},
		setClearRefresh: function() {
			
			var param = {
				FR_PUB_DATE : panelSearch.getField('FR_PUB_DATE').getStartDate(),
				TO_PUB_DATE : panelSearch.getField('TO_PUB_DATE').getEndDate(),
				BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE')
			}
			atx340ukrService.selectCheckList(param, function(record)	{
				if(record && record.CNT > 0)	{
					if(confirm("저장된 데이터가 있습니다. 삭제하시겠습니까?")){
						inputTable.uniOpt.inLoading = true;
						inputTable.clearForm();
						setTimeout(function(){
								inputTable.uniOpt.inLoading = false;
							},10);
						directMasterStore.loadData({});			
						Ext.getBody().mask();
						atx340ukrService.deleteForReference(param, function(responseText){
							Ext.getBody().unmask();
							if(responseText && responseText.result == "success")	{
								Ext.getBody().mask();
								atx340ukrService.fnGetReferenceEtc(param, function(provider, response){	
									Ext.getBody().unmask();
									if(provider != null) {
										var record = provider[0];
										if(record != null && record.OTHER_NUM3 > 0 )	{
											inputTable.setValue('OTHER_NUM3'	 , record.OTHER_NUM3);
											inputTable.setValue('FOR_OTHER_AMT3' , record.FOR_OTHER_AMT3);
											inputTable.setValue('OTEHR_AMT3'	 , record.OTEHR_AMT3);
											UniAppManager.setToolbarButtons(['save'], true);
										}
									}
									UniAppManager.app.addReference();
								});
								
							}
						})
					} 
				}else {
					UniAppManager.app.addReference();
				}
			})
		},
		addReference:function()	{
			var param = {
				FR_PUB_DATE : panelSearch.getField('FR_PUB_DATE').getStartDate(),
				TO_PUB_DATE : panelSearch.getField('TO_PUB_DATE').getEndDate(),
				BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE')
			}
			Ext.getBody().mask();
			atx340ukrService.selectReference(param, function(records){
				Ext.getBody().unmask();
				if(records)	{
					Ext.each(records, function(record, idx){
						masterGrid.createRow(record, idx);
					});
				}
			});
			
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			//panelSearch.clearForm();
			//panelResult.clearForm();
			inputTable.uniOpt.inLoading = true;
			inputTable.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore.loadData({});
			//this.fnInitBinding();
			
			UniAppManager.setToolbarButtons(['detail','deleteAll','newData'],false);
			UniAppManager.setToolbarButtons(['reset'],true);

			setTimeout(function(){
				inputTable.uniOpt.inLoading = false;
			},10);
		},
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
					
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;	
					}
					return false;
				}
			});
			
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}


		
			UniAppManager.setToolbarButtons('deleteAll', false);
		}
	});
	
	 Unilite.createValidator('validator01', {
			store: directMasterStore,
			grid: masterGrid,
			validate: function( type, fieldName, newValue, oldValue, record, eopt) {
				console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
				var rv = true;
				switch(fieldName) {
					case "EXCHG_RATE_O" :	// 환율
						record.set('AMT_I', newValue * record.get('FOR_AMT_I'));
					break;
					
					case "FOR_AMT_I" :	// 외화금액
						record.set('AMT_I', newValue * record.get('EXCHG_RATE_O'));
					break;
				}
				return rv;
			}
		});
	

};


</script>