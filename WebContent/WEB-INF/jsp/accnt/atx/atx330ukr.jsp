<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx330ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A092"  /> 		<!-- 제출사유 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var resetButtonFlag = '';
var excelWindow;    // 엑셀참조

function appMain() { 
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx330ukrService.selectList',
			update: 'atx330ukrService.updateDetail',
			create: 'atx330ukrService.insertDetail',
			destroy: 'atx330ukrService.deleteDetail',
			syncAll: 'atx330ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx330Model', {
	   fields: [
			{name: 'FR_PUB_DATE'		, text: 'FR_PUB_DATE'		, type: 'uniDate',allowBlank: false},
			{name: 'TO_PUB_DATE' 		, text: 'TO_PUB_DATE'		, type: 'uniDate',allowBlank: false},
			{name: 'BILL_DIV_CODE' 		, text: 'BILL_DIV_CODE'		, type: 'string',allowBlank: false},
			{name: 'SEQ'	    		, text: 'SEQ'				, type: 'int',editable:false,allowBlank: false},
			{name: 'DISP_SEQ'	    	, text: '일련번호'				, type: 'int',editable:false},
			{name: 'DOCU_NAME' 			, text: '서류명'				, type: 'string',allowBlank: false},
			{name: 'DOCU_PERSON'		, text: '발급자'				, type: 'string',allowBlank: false},
			{name: 'DOCU_DATE'			, text: '발급일자'				, type: 'uniDate',allowBlank: false},
			{name: 'SHIP_DATE'			, text: '선적일자'				, type: 'uniDate'},
			{name: 'MONEY_UNIT'			, text: '통화코드'				, type: 'string',allowBlank: false},
			{name: 'EXCHG_RATE_O'		, text: '환율'				, type: 'float',decimalPrecision:4, format:'0,000.0000'},
			{name: 'SUBMIT_FOR_AMT'		, text: '제출외화'				, type: 'uniFC'},
			{name: 'SUBMIT_AMT' 		, text: '제출원화'				, type: 'uniPrice', format:'0,000'},
			{name: 'DECL_FOR_AMT'		, text: '신고외화'				, type: 'uniFC'},
			{name: 'DECL_AMT'			, text: '신고원화'				, type: 'uniPrice', format:'0,000'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'				, type: 'uniDate'},
			{name: 'REASON' 			, text: '제출사유'				, type: 'string',comboType:'AU', comboCode:'A092',allowBlank: false},
			{name: 'COMP_CODE' 			, text: 'COMP_CODE'			, type: 'string',allowBlank: false}
	    ]
	});		// End of Ext.define('Atx330ukrModel', {
	  
    Unilite.Excel.defineModel('excel.atx330.sheet01', {
        fields: [
            {name: 'DOCU_NAME'		,text: '서류명'	,type: 'string'},
            {name: 'DOCU_PERSON'	,text: '발급자'	,type: 'string'},
            {name: 'DOCU_DATE'		,text: '발급일자'	,type: 'string'},
            {name: 'SHIP_DATE'		,text: '선적일자'	,type: 'string'},
            {name: 'MONEY_UNIT'		,text: '통화코드'	,type: 'string'},
            {name: 'EXCHG_RATE_O'	,text: '환율'		,type: 'float',		decimalPrecision: 4,	format:'0,000.0000'},
            {name: 'SUBMIT_FOR_AMT'	,text: '제출외화'	,type: 'float',		decimalPrecision: 2,	format:'0,000.00'},
            {name: 'SUBMIT_AMT'		,text: '제출원화'	,type: 'uniPrice'},
            {name: 'DECL_FOR_AMT'	,text: '신고외화'	,type: 'float',		decimalPrecision: 2,	format:'0,000.00'},
            {name: 'DECL_AMT'		,text: '신고원화'	,type: 'uniPrice'},
            {name: 'REASON'			,text: '제출사유'	,type: 'string'}

        ]
    });

	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';

		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.BILL_DIV_CODE = panelResult.getValue('BILL_DIV_CODE');
		}
		
		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				modal: false,
				excelConfigName: 'atx330ukr',
				extParam: {
					'PGM_ID'		: 'atx330ukr',
					'BILL_DIV_CODE'	: panelResult.getValue('BILL_DIV_CODE')
				},
				grids: [{
					itemId: 'grid01',
					title: '영세율첨부서류제출명세서 엑셀참조',
					useCheckbox: true,
					model : 'excel.atx330.sheet01',
					readApi: 'atx330ukrService.selectExcelUploadSheet',
					columns: [
								{dataIndex: 'DOCU_NAME'		, width: 100},
								{dataIndex: 'DOCU_PERSON'	, width: 150},
								{dataIndex: 'DOCU_DATE'		, width: 120},
								{dataIndex: 'SHIP_DATE'		, width: 120},
								{dataIndex: 'MONEY_UNIT'	, width: 80},
								{dataIndex: 'EXCHG_RATE_O'	, width: 130},
								{dataIndex: 'SUBMIT_FOR_AMT', width: 130},
								{dataIndex: 'SUBMIT_AMT'	, width: 130},
								{dataIndex: 'DECL_FOR_AMT'	, width: 130},
								{dataIndex: 'DECL_AMT'		, width: 130},
								{dataIndex: 'REASON'		, width: 200}
					]
				}],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function()  {
					var grid = this.down('#grid01');
					var records = grid.getSelectionModel().getSelection();
					Ext.each(records, function(record,i){
						UniAppManager.app.onNewDataButtonDown();
						masterGrid.setExcelData(record.data);
					});
					grid.getStore().removeAll();
					this.hide();
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
	var directMasterStore = Unilite.createStore('atx330MasterStore1',{
		model: 'Atx330Model',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();	
			param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			paramMaster.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			paramMaster.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
							directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		var viewNormal = masterGrid.getView();
           		if(store.getCount() > 0){
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				}else{
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
				}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
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
				fieldLabel: '신고기간',
	 		    width: 315,
	            xtype: 'uniMonthRangefield',
	            startFieldName: 'FR_PUB_DATE',
	            endFieldName: 'TO_PUB_DATE',
	            startDD:'first',
		        endDD:'last',
		        holdable: 'hold',
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
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode	: 'BILL',
				holdable: 'hold',
	            allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel:'파일경로',
				name: 'excelupload',
				xtype: 'uniFilefield',
				hidden:true,
				width: 300
			},{
            	fieldLabel: '제출사유',
            	name: 'REASON',
            	xtype: 'uniCombobox',
            	comboType: 'AU',
            	comboCode: 'A092',
            	width: 330,
            	listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('REASON', newValue);
					}
				}
			},{
	    		fieldLabel: '작성일자', 
	    		name:'WRITE_DATE',
	    		xtype: 'uniDatefield',
				hidden:true,
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
	    		handler : function() {
					var me = this;
					UniAppManager.app.onPrintButtonDown();
				}
	    	},{
	    		xtype: 'button',
	    		text: '빈파일저장',
	    		width: 100,
	    		margin: '0 0 0 120', 
				hidden:true,
	    		handler : function() {
					var param = panelSearch.getValues();
					var form = panelFileDown;
					form.submit({
						params: param,
						success:function(comp, action)  {
						},
						failure: function(form, action){
						}                   
					});
				}
	    	},{
	    		xtype: 'button',
	    		text: '파일 UpLoad',
	    		width: 100,
	    		margin: '0 0 0 120',
	    		handler : function() {
					var me = this;
					var param = panelSearch.getValues();
					
					openExcelWindow();
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
	
    //fileDown submitForm
    var panelFileDown = Unilite.createForm('FileDownForm', {
        url: CPATH+"/fileman/exceldown/atx330ukr/xls",
        colspan: 2,
        layout: {type: 'uniTable', columns: 1},
        height: 30,
        padding: '0 0 0 195',
        disabled:false,
        autoScroll: false,
        standardSubmit: true,  
        items:[]
    });
    
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4,
			tableAttrs: { width: '100%'},
			tdAttrs: {/*style:'border : 1px solid #ced9e7;',*/ width: 200}
		},
		padding:'1 1 1 1',
		border:true,
//		defaults:{width: 200},
		items: [{
				fieldLabel: '신고기간',
	 		    width: 315,
	            xtype: 'uniMonthRangefield',
	            startFieldName: 'FR_PUB_DATE',
	            endFieldName: 'TO_PUB_DATE',
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('endOfMonth'),
	            startDD:'first',
		        endDD:'last',
		        holdable: 'hold',
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
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode	: 'BILL',
				colspan:2,
				holdable: 'hold',
	            allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelSearch.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		tdAttrs: { align : 'center'},
	    		handler : function() {
	    			var me = this;
	    			UniAppManager.app.onPrintButtonDown();
				}
	    	},{
				fieldLabel:'파일경로',
				name: 'excelupload',
				xtype: 'uniFilefield',
//				labelWidth:200,
				hidden:true,
				width: 350
			},{
            	fieldLabel: '제출사유',
            	name: 'REASON',
            	xtype: 'uniCombobox',
            	comboType: 'AU',
            	comboCode: 'A092',
				colspan:3,
            	width: 330,
            	listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelSearch.setValue('REASON', newValue);
					}
				}
			},{
	    		fieldLabel: '작성일자', 
	    		name:'WRITE_DATE',
	    		xtype: 'uniDatefield',
				hidden:true,
	    		value: UniDate.get('today'),
	    		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WRITE_DATE', newValue);
					}
				}
	    	},{
	    		xtype: 'button',
	    		text: '빈파일저장',
	    		width: 100,
				hidden:true,
	    		tdAttrs: { align : 'center'},
	    		handler : function() {
					var param = panelSearch.getValues();
					var form = panelFileDown;
					form.submit({
						params: param,
						success:function(comp, action)  {
						},
						failure: function(form, action){
						}                   
					});
				}
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:600,
				colspan:3,
				hidden:true,
				items :[
					{ xtype: 'component',  html:'※작성방법&nbsp;&nbsp;&nbsp;1. 먼저 [빈파일저장] 버튼을 눌러 파일을 작성합니다.',width:380,
						 style: {
				           marginTop: '3px !important',
				           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
				           color: 'blue'
						}
					},
			    	{ xtype: 'component',  html:'2. 계산서일과 신고사업장을 선택하고 조회합니다.',width:300,
			    		style: {
				    		marginTop: '3px !important',
				    		font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
				    		color: 'blue'
						}
			    	},
			    	{ xtype: 'component',  html:'3. [파일 UpLoad] 버튼을 눌러 확인 후 저장합니다.',width:300,
			    		style: {
				    		marginTop: '3px !important',
				    		font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
				    		color: 'blue'
						}	
			    	}
				]
		   	},{
	    		xtype: 'button',
	    		text: '파일 UpLoad',
	    		width: 100,
	    		tdAttrs: { align : 'center'},
	    		colspan:2,
	    		handler : function() {
					var me = this;
					var param = panelSearch.getValues();
					
					openExcelWindow();
				}
	    	}
	    ],
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
    
    var masterGrid = Unilite.createGrid('atx330Grid1', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
		excelTitle: '영세율첨부서류제출명세서',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			onLoadSelectFirst: true,
			copiedRow:false,
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
    		dock : 'top',
    		showSummaryRow: true
    	}],
        columns: [        
        	{dataIndex: 'FR_PUB_DATE'		, width: 66, hidden: true}, 				
			{dataIndex: 'TO_PUB_DATE' 		, width: 66, hidden: true}, 				
			{dataIndex: 'BILL_DIV_CODE' 	, width: 66, hidden: true}, 				
			{dataIndex: 'SEQ'	    		, width: 60, hidden: true}, 				
			{dataIndex: 'DISP_SEQ'	    	, width: 80,align:'center'}, 				
			{dataIndex: 'DOCU_NAME' 		, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
			}, 				
			{dataIndex: 'DOCU_PERSON'		, width: 150}, 				
			{dataIndex: 'DOCU_DATE'			, width: 120}, 				
			{dataIndex: 'SHIP_DATE'			, width: 120}, 				
			{dataIndex: 'MONEY_UNIT'		, width: 80,align:'center',
				editor: Unilite.popup('MONEY_UNIT_G',{
	        		textFieldName: 'MONEY_UNIT',
					DBtextFieldName: 'MONEY_UNIT',
			  		autoPopup: true,
	        		listeners:{ 
						'onSelected': {
	                    	fn: function(records, type  ){
	                    		var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('MONEY_UNIT',records[0]['MONEY_UNIT']);
	                    	},
	                		scope: this
	      	   			},
						'onClear' : function(type)	{
	                  		var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('MONEY_UNIT','');
	                  	}
					}
	        	})
			}, 				
			{dataIndex: 'EXCHG_RATE_O'		, width: 130}, 				
			{dataIndex: 'SUBMIT_FOR_AMT'	, width: 130,summaryType: 'sum'}, 				
			{dataIndex: 'SUBMIT_AMT' 		, width: 130,summaryType: 'sum'}, 				
			{dataIndex: 'DECL_FOR_AMT'		, width: 130,summaryType: 'sum'}, 				
			{dataIndex: 'DECL_AMT'			, width: 130,summaryType: 'sum'}, 				
			{dataIndex: 'UPDATE_DB_USER'	, width: 26, hidden: true}, 				
			{dataIndex: 'UPDATE_DB_TIME'	, width: 26, hidden: true}, 				
			{dataIndex: 'REASON' 			, width: 200}, 				
			{dataIndex: 'COMP_CODE' 		, width: 66, hidden: true}
		],
		setExcelData: function(record) {    //엑셀 업로드 참조
			var grdRecord = this.getSelectedRecord();
			var seq = directMasterStore.max('SEQ');
            var dispSeq = directMasterStore.max('DISP_SEQ');
			
			if(!seq)
				seq = 1;
			else
				seq += 1;
			
			if(!dispSeq)
				dispSeq = 1;
			else
				dispSeq += 1;
			
			grdRecord.set('FR_PUB_DATE'		, panelSearch.getField('FR_PUB_DATE').getStartDate());
			grdRecord.set('TO_PUB_DATE'		, panelSearch.getField('TO_PUB_DATE').getEndDate());
			grdRecord.set('BILL_DIV_CODE'	, panelResult.getValue('BILL_DIV_CODE'));
			grdRecord.set('SEQ'				, seq);
			grdRecord.set('DISP_SEQ'		, dispSeq);
			
			grdRecord.set('DOCU_NAME'		, record['DOCU_NAME']);
			grdRecord.set('DOCU_PERSON'		, record['DOCU_PERSON']);
			grdRecord.set('DOCU_DATE'		, record['DOCU_DATE']);
			grdRecord.set('SHIP_DATE'		, record['SHIP_DATE']);
			grdRecord.set('MONEY_UNIT'		, record['MONEY_UNIT']);
			grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
			grdRecord.set('SUBMIT_FOR_AMT'	, record['SUBMIT_FOR_AMT']);
			grdRecord.set('SUBMIT_AMT'		, record['SUBMIT_AMT']);
			grdRecord.set('DECL_FOR_AMT'	, record['DECL_FOR_AMT']);
			grdRecord.set('DECL_AMT'		, record['DECL_AMT']);
			grdRecord.set('REASON'			, panelResult.getValue('REASON'));
		}
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
		id : 'atx330App',
		fnInitBinding : function() {
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			this.setDefault();
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				UniAppManager.setToolbarButtons(['newData','reset','deleteAll'],true);
				directMasterStore.loadStoreRecords();	
				
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			var compCode	= UserInfo.compCode;
			
			var frPubDate   = panelSearch.getField('FR_PUB_DATE').getStartDate();
			var toPubDate   = panelSearch.getField('TO_PUB_DATE').getEndDate();
			var billDivCode = panelSearch.getValue('BILL_DIV_CODE');
			var seq = directMasterStore.max('SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
            var dispSeq = directMasterStore.max('DISP_SEQ');
            	 if(!dispSeq){
            	 	dispSeq = 1;
            	 }else{
            	 	dispSeq += 1;
            	 }
			
			
            var r = {
        	 	COMP_CODE   : compCode,
        	 	FR_PUB_DATE : frPubDate,
        	 	TO_PUB_DATE : toPubDate,
        	 	BILL_DIV_CODE : billDivCode,
        	 	SEQ : seq,
        	 	DISP_SEQ : dispSeq
	        };
				masterGrid.createRow(r,'DOCU_NAME');
				
		},
		onResetButtonDown: function() {	
			resetButtonFlag = 'Y';
//			panelSearch.clearForm();
			masterGrid.reset();
//			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {			
			if(confirm('전체삭제 하시겠습니까?')) {
				masterGrid.reset();	
				UniAppManager.app.onSaveDataButtonDown();	
			}
		},
		onPrintButtonDown: function() {
			var param = panelResult.getValues();
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();
			param['FR_PUB_DATE'] = startDateValue;
			param['TO_PUB_DATE'] = endDateValue;
			
//			var win = Ext.create('widget.PDFPrintWindow', {
//				url: CPATH+'/atx/atx330ukr.do',
//				prgID: 'atx330ukr',
//				extParam: param
//			});
			
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/accnt/atx330clukr.do',
				prgID: 'atx330ukr',
				extParam: param
			});			
			
			win.center();
			win.show();
		},
		setDefault: function() {
			if(resetButtonFlag != 'Y'){
				panelSearch.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
		    	panelSearch.setValue('TO_PUB_DATE',UniDate.get('endOfMonth'));
		    	panelSearch.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
		    	panelSearch.setValue('WRITE_DATE',UniDate.get('today'));
		    	panelSearch.setValue('REASON','01');
		    	
		    	panelResult.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
		    	panelResult.setValue('TO_PUB_DATE',UniDate.get('endOfMonth'));
		    	panelResult.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
		    	panelResult.setValue('WRITE_DATE',UniDate.get('today'));
		    	panelResult.setValue('REASON','01');
			}
			
			UniAppManager.setToolbarButtons(['deleteAll','reset','newData','save'],false);
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        calcAmt: function() {
			
        }
	});
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "EXCHG_RATE_O":
					record.set('SUBMIT_AMT',newValue * record.get('SUBMIT_FOR_AMT'));
					
					record.set('DECL_FOR_AMT',record.get('SUBMIT_FOR_AMT'));
			
					record.set('DECL_AMT', record.get('SUBMIT_AMT'));
					break;
				case "SUBMIT_FOR_AMT":
					record.set('SUBMIT_AMT',newValue * record.get('EXCHG_RATE_O'));
					
					record.set('DECL_FOR_AMT',newValue);
			
					record.set('DECL_AMT', record.get('SUBMIT_AMT'));
					break;
					
				case "DECL_FOR_AMT":
					record.set('DECL_AMT',newValue * record.get('EXCHG_RATE_O'));
					
					break;
				
			}
			return rv;
		}
	});	
};


</script>
