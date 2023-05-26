<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx500ukr"  >
	<t:ExtComboStore comboType="BOR120"		comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="A" 			comboCode="A164" /> 						<!--내국신용장.구매확인서 전자발급명세서-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var excelWindow; //업로드 선언
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'atx500ukrService.selectList',
			update	: 'atx500ukrService.updateDetail',
			create	: 'atx500ukrService.insertDetail',
			destroy	: 'atx500ukrService.deleteDetail',
			syncAll	: 'atx500ukrService.saveAll'
		}
	});	
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx500ukrModel', {
	    fields: [
			{name: 'COMP_CODE'			,text: '법인코드'				,type: 'string'},
	    	{name: 'FR_PUB_DATE'		,text: '시작월'				,type: 'uniDate'},
	    	{name: 'TO_PUB_DATE'  		,text: '종료월'				,type: 'uniDate'},
	    	{name: 'BILL_DIV_CODE'		,text: '신고사업장'				,type: 'string'},
	    	{name: 'SEQ'				,text: '순번'					,type: 'int',		allowBlank: false},
	    	{name: 'GUBUN'				,text: '구분'					,type: 'string',	allowBlank: false,	comboType: "A", comboCode: "A164"},
	    	{name: 'DOCU_NUM'			,text: '서류번호'				,type: 'string',	allowBlank: false},
	    	{name: 'DOCU_DATE'			,text: '발급일자'				,type: 'uniDate',	allowBlank: false},
	    	{name: 'COMPANY_NUM'		,text: '공급받는자사업자번호'		,type: 'string',	allowBlank: false,	maxLength: 10},
	    	{name: 'AMT_I'				,text: '금액(원)'				,type: 'uniPrice',	allowBlank: false},
	    	{name: 'REMARK'				,text: '비고'					,type: 'string'},
	    	{name: 'INSERT_DB_USER' 	,text: 'INSERT_DB_USER'		,type: 'string'},
	    	{name: 'INSERT_DB_TIME' 	,text: 'INSERT_DB_TIME'		,type: 'uniDate'},
	    	{name: 'UPDATE_DB_USER' 	,text: 'UPDATE_DB_USER' 	,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME' 	,type: 'uniDate'}
		]
	});

	// 엑셀참조
	Unilite.Excel.defineModel('excel.atx500ukr.sheet01', {
		fields: [
	    	{name: '_EXCEL_JOBID' 	, text:'EXCEL_JOBID'	,type: 'string'},
			{name: 'GUBUN'			, text: '구분'			, type: 'string'	, allowBlank: false },
			{name: 'DOCU_NUM'		, text: '서류번호'			, type: 'string'	, allowBlank: false },
			{name: 'DOCU_DATE'		, text: '발급일자'			, type: 'string'	, allowBlank: false	/*, type: 'uniDate'*/	},
			{name: 'COMPANY_NUM'	, text: '공급받는자사업자번호'	, type: 'string'	, allowBlank: false	},
			{name: 'AMT_I'			, text: '금액(원)'			, type: 'uniPrice'	, allowBlank: false	},
			{name: 'REMARK'			, text: '비고'			, type: 'string'}
		]
	});

	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('atx500ukrMasterStore1',{
		model: 'Atx500ukrModel',
		uniOpt : {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: true,			// 삭제 가능 여부 
        	allDeletable: true,
            useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();	
			
			var FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			var TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			
			param.FR_PUB_DATE = FR_PUB_DATE;
			param.TO_PUB_DATE = TO_PUB_DATE;
			
			this.load({
				params : param
			});
		},
		
		saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
	   		var toUpdate = this.getUpdatedRecords();        		
	   		var toDelete = this.getRemovedRecords();
	   		var list = [].concat(toUpdate, toCreate);
        	var rv = true;

			//1. 마스터 정보 파라미터 구성
			var paramMaster			= panelSearch.getValues();	
			paramMaster.FR_PUB_DATE	= panelSearch.getField('FR_PUB_DATE').getStartDate();
			paramMaster.TO_PUB_DATE	= panelSearch.getField('TO_PUB_DATE').getEndDate();

			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
					} 
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ){
				//
				if(store.getCount() > 0) {
					var param= Ext.getCmp('searchForm').getValues();	
					
					
					param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
					param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
					
					atx500ukrService.selectList1(param, function(provider, response){
						
						summaryTable.setValue('TOT_CNT',		provider[0].TOT_CNT);
						summaryTable.setValue('TOT_AMT',		provider[0].TOT_AMT);
						summaryTable.setValue('NAEGUK_CNT',		provider[0].NAEGUK_CNT);
						summaryTable.setValue('NAEGUK_AMT',		provider[0].NAEGUK_AMT);
						summaryTable.setValue('GUMAE_CNT',		provider[0].GUMAE_CNT);
						summaryTable.setValue('GUMAE_AMT',		provider[0].GUMAE_AMT);
					});
				} else {
					//합계 테이블 초기화함수 호출
					fnIntSummary();
					
					UniAppManager.setToolbarButtons('reset',	true);
					UniAppManager.setToolbarButtons('newData',	true);
					
					UniAppManager.app.addReference();
					//alert(Msg.sMB015);
					
				}
			},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		//합계계산 함수 호출
           		fnCompute();
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           		//합계계산 함수 호출
           		fnCompute();
           	}
		}
	});

	/* 검색조건 (Search Panel)
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
			title	: '기본정보', 	
   			itemId	: 'search_panel1',
           	layout	: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items	: [{ 
    			fieldLabel	: '계산서일',
		        xtype		: 'uniMonthRangefield',
		        startFieldName: 'FR_PUB_DATE',
		        endFieldName: 'TO_PUB_DATE',
		        startDate	: UniDate.get('startOfMonth'),
		        endDate		: UniDate.get('today'),
		        startDD		: 'first',
		        endDD		: 'last',
		        allowBlank	: false,
		        holdable	:'hold',
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
				fieldLabel	: '신고사업장',
				id			: 'DIV_CODE',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				comboCode	: 'BILL',
				allowBlank	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{					
				xtype	: 'container',				
				tdAttrs	: {align: 'center'},				
				layout	: {type : 'uniTable', columns : 1, tableAttrs: {width: '90%'}},				
				items	: [{				
					xtype	: 'component',		
					margin	: '15 0 10 30',	
					tdAttrs	: {style: 'border-bottom: 1.4px solid #cccccc;'}			
				}]				
			},{
				xtype	: 'component',
				border	: false,
				name	: '',
				margin	: '0 0 2 10',
				style: {color: 'blue'},
				html	: "<br>" +
					"&nbsp;※ 작성방법<br/><br/>" +
					"&nbsp;&nbsp;1. 먼저 [엑셀참조] 버튼을 눌러 파일을 받은 후,<br/>&nbsp;&nbsp;&nbsp;&nbsp;작성합니다. <br>" +
					"&nbsp;&nbsp;2. [엑셀참조] 버튼을 눌러 데이터를 업로드하고 <br/>&nbsp;&nbsp;&nbsp;&nbsp;확인 후, 저장합니다.<br>"
			}]		
		}]
	});   
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{ 
			fieldLabel: '계산서일',
	        xtype		: 'uniMonthRangefield',
	        startFieldName: 'FR_PUB_DATE',
	        endFieldName: 'TO_PUB_DATE',
	        startDate	: UniDate.get('startOfMonth'),
	        endDate		: UniDate.get('today'),
	        startDD		: 'first',
	        endDD		: 'last',
	        allowBlank	: false,
	        holdable	:'hold',
	        tdAttrs		: {width: 380},  
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if (panelSearch) {
					panelSearch.setValue('FR_PUB_DATE',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if (panelSearch) {
		    		panelSearch.setValue('TO_PUB_DATE',newValue);
		    	}
		    }
        },{
			fieldLabel	: '신고사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			comboCode	: 'BILL',
			allowBlank	: false,
	        tdAttrs		: {width: 380},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
    		xtype	: 'button',
    		text	: '출력',
    		width	: 100,
    		margin	: '0 0 2 0',			
    		tdAttrs	: {align : 'right'},
    		handler	: function() {
    			UniAppManager.app.onPrintButtonDown();
			}
    	}/*,{
			xtype	: 'component'
		} ,{
			xtype	: 'component',
			border	: false,
			name	: '',
			margin	: '0 0 2 30',
			width	: 430,
			colspan	: 3,
			html	: "<br>" +
				"<font size='1.5px' color='blue'>&nbsp;※ 작성방법<br>" 
		},{
			xtype	: 'component',
			border	: false,
			name	: '',
			margin	: '0 0 2 30',
			width	: 430,
			html	: 
				"<font size='1.7' color='blue'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. 먼저 [엑셀참조] 버튼을 눌러 파일을 받은 후, 작성합니다. <br>" //+
		},{
			xtype	: 'component',
			border	: false,
			name	: '',
			margin	: '0 0 2 10',
			width	: 360,
			html	: 
				"<font size='1.7' color='blue'>&nbsp;&nbsp;&nbsp;2. [엑셀참조] 버튼을 눌러 데이터를 업로드하고 확인 후, 저장합니다.<br>"        		 
		} ,{					
			xtype	: 'container',					
			layout	: {type : 'uniTable', columns : 2, tdAttrs: {width: '99%', align : 'right'}},				
			items	: [{
	    		xtype	: 'button',
	    		text	: '엑셀참조',
	    		width	: 100,
	    		margin	: '0 0 2 0',			
	    		tdAttrs	: {align : 'right'},
	    		handler	: function() {
					openExcelWindow();
				}
	    	},{
	    		xtype	: 'button',
	    		text	: '출력',
	    		width	: 100,
	    		margin	: '0 0 2 0',			
	    		tdAttrs	: {align : 'right'},
	    		handler	: function() {
	    			UniAppManager.app.onPrintButtonDown();
				}
	    	}]				
		}*/]
    }); 
	
	var summaryTable = Unilite.createForm('detailForm', { 															//createForm (합계 표시용)
        
		disabled: false,
		xtype	: 'container',
		bodyPadding: 0,
		width   : 800,
		height  : 130,
		region	: 'center',
	    layout	: {type: 'uniTable', columns: 4, 
			tableAttrs	: {style: 'border : 1px solid #ced9e7;', width: '100%'},
    		tdAttrs		: {style: 'border : 1px solid #ced9e7;', align : 'center', height:25}
    	},
	    items: [
			{ xtype: 'component',		html: '구 분',		width: 100},
			{ xtype: 'component',		html: '건 수'},
			{ xtype: 'component',		html: '금 액 (원)'},
			{ xtype: 'component',		html: '비 고'},
			
			{ xtype: 'component',		html: '&nbsp;(9) 합계 (10) + (11)&nbsp;'},					//구 분		
			{ xtype: 'uniNumberfield',	name: 'TOT_CNT',		value:'0',	readOnly:true},		//건 수 
			{ xtype: 'uniNumberfield',	name: 'TOT_AMT',		value:'0',	readOnly:true},		//금 액 (원)
			{ xtype: 'uniTextfield',	name: 'TOT_REMARK',		value:'',	readOnly:true},		//비 고 
			
			{ xtype: 'component',		html: '&nbsp;(10) 내 국 신 용 장&nbsp;'},						//구 분		
			{ xtype: 'uniNumberfield',	name: 'NAEGUK_CNT',		value:'0',	readOnly:true},		//건 수    
			{ xtype: 'uniNumberfield',	name: 'NAEGUK_AMT',		value:'0',	readOnly:true},		//금 액 (원)
			{ xtype: 'uniTextfield',	name: 'NAEGUK_REMARK',	value:'',	readOnly:true},		//비 고    
			
			{ xtype: 'component',		html: '&nbsp;(11) 구 매 확 인 서&nbsp;'},						//구 분		
			{ xtype: 'uniNumberfield',	name: 'GUMAE_CNT',		value:'0',	readOnly:true},		//건 수    
			{ xtype: 'uniNumberfield',	name: 'GUMAE_AMT',		value:'0',	readOnly:true},		//금 액 (원)
			{ xtype: 'uniTextfield',	name: 'GUMAE_REMARK',	value:'',	readOnly:true}		//비 고    
		]
	});

    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('atx500ukrGrid1', {
        layout	: 'fit',
        region	: 'center',
        flex	: 1,
    	store	: masterStore,
    	title	: '3. 내국신용장·구매확인서에 의한 공급실적 명세서',
    	excelTitle: '내국신용장 구매확인 전자발급명세서',
		uniOpt	: {						
			useMultipleSorting	: true,			 	
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: true,		//체크박스모델은 false로 변경		
		    dblClickToEdit		: true,			
		    useGroupSummary		: false,			
			useContextMenu		: false,			
			useRowNumberer		: true,			
			expandLastColumn	: false,				
			useRowContext		: false,	// rink 항목이 있을경우만 true		
			copiedRow			: true,			
			filter: {					
				useFilter	: false,			
				autoCreate	: false			
			}					
        },
        tbar : [{
    		xtype	: 'button',
    		text	: '엑셀참조',
    		handler	: function() {
				openExcelWindow();
			}
    	},{
    		xtype	: 'button',
    		text	: '재참조',	
    		handler	: function() {
    			var param = panelResult.getValues();
    			param.FR_PUB_DATE	= panelResult.getField('FR_PUB_DATE').getStartDate();
    			param.TO_PUB_DATE	= panelResult.getField('TO_PUB_DATE').getEndDate();
    			atx500ukrService.selectCount(param, function(responseText, respnse){
    				if(responseText && responseText.CNT > 0 )	{
    					if(confirm("저장된 데이터가 있습니다. 삭제하시겠습니까?")){	
    						summaryTable.clearForm();
							var items = masterStore.getData().items;
							masterStore.remove(items);
    						UniAppManager.app.addReference();
    					}
    				}
    			});
			}
    	}]	,
    	features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
    	           	{id : 'masterGridTotal',	ftype: 'uniSummary', 	  		showSummaryRow: false} ],
        columns:  [        
       		{ dataIndex: 'COMP_CODE',		width: 53, hidden: true},        
       		{ dataIndex: 'FR_PUB_DATE',		width: 53, hidden: true},        
       		{ dataIndex: 'TO_PUB_DATE',		width: 53, hidden: true},
       		{ dataIndex: 'BILL_DIV_CODE',	width: 53, hidden: true},   
       		{ dataIndex: 'SEQ',				width: 80, align:'center'},        
       		{ dataIndex: 'GUBUN',			width: 120},        
       		{ dataIndex: 'DOCU_NUM',		width: 166},        
       		{ dataIndex: 'DOCU_DATE',		width: 100},        
       		{ dataIndex: 'COMPANY_NUM',		width: 146/*,
	        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
	        		if (val.length == 10) {
	        			return (val.substring(0,3) + '-' + val.substring(3,5) + '-' + val.substring(5,10));
	        		} else {
	        			return val;
	        		}
	        	}*/
        	},        
       		{ dataIndex: 'AMT_I',			width: 120},        
       		{ dataIndex: 'REMARK',			flex: 1},        
       		{ dataIndex: 'INSERT_DB_USER',	width: 53, hidden: true},        
       		{ dataIndex: 'INSERT_DB_TIME',	width: 53, hidden: true},        
       		{ dataIndex: 'UPDATE_DB_USER',	width: 53, hidden: true},        
       		{ dataIndex: 'UPDATE_DB_TIME',	width: 53, hidden: true}
        ],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['SEQ'])){
					return false;	
				}
			}
		} 
    });   
	
	Unilite.Main({
		borderItems:[{
			border	: false,
			region	: 'center',
			layout	: 'border',
			items	: [
				panelResult, ,
				 {
					layout	: {type: 'hbox', align: 'stretch'},
					region	: 'north',
					title	: '2. 내국신용장·구매확인서에 의한 공급실적 합계',
					items: [summaryTable
					 	,{
						region : 'east',
						flex: 0.5,
						border	: false,
						layout :'vbox',
						items:[
							{
								xtype	: 'component',
								border	: false,
								name	: '',
								style: {color: 'blue'},
								html	: "<br>" +
									"&nbsp;※ 작성방법<br/><br/>" 
							},{
								xtype	: 'component',
								border	: false,
								name	: '',
								style: {color: 'blue'},
								html	: 
									"&nbsp;&nbsp;&nbsp;1. 먼저 [엑셀참조] 버튼을 눌러 파일을 받은 후, 작성합니다. <br>" //+
							},{
								xtype	: 'component',
								border	: false,
								style: {color: 'blue'},
								html	: 
									"&nbsp;&nbsp;&nbsp;2. [엑셀참조] 버튼을 눌러 데이터를 업로드하고 확인 후, 저장합니다.<br>"        		 
							}
						]
					}]				
				}, 
				masterGrid
			]	
		},
			panelSearch
		],
		id: 'atx500ukrApp',
		
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('query',	true);
			UniAppManager.setToolbarButtons('save',		false);
			UniAppManager.setToolbarButtons('reset',	true);
			UniAppManager.setToolbarButtons('newData',	false);
			UniAppManager.setToolbarButtons('deleteAll',false);
			UniAppManager.setToolbarButtons('print'    ,false);
			this.setDefault();
			
        	panelSearch.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
        	panelSearch.setValue('TO_PUB_DATE',UniDate.get('today'));
			panelSearch.setValue('DIV_CODE',baseInfo.gsBillDivCode);

        	panelResult.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
        	panelResult.setValue('TO_PUB_DATE',UniDate.get('today'));
			panelResult.setValue('DIV_CODE',baseInfo.gsBillDivCode);
        	
		},
		onPrintButtonDown: function() {
			var billDiviCode = panelSearch.getValue('DIV_CODE');
			var from_date = panelSearch.getField('FR_PUB_DATE').getStartDate();
			var to_date   = panelSearch.getField('TO_PUB_DATE').getEndDate();
			var param= {
				FR_PUB_DATE : from_date,
				TO_PUB_DATE : to_date,
				DIV_CODE : billDiviCode
			};
			param.ACCNT_DIV_NAME = panelSearch.getField('DIV_CODE').getRawValue();
			param.sTxtValue2_fileTitle = '내국신용장ㆍ구매확인서 전자발급명세서';
//			var win = Ext.create('widget.PDFPrintWindow', {
//				url: CPATH+'/atx/atx500ukrPrint.do',
//				prgID: 'atx500ukr',
//				extParam: param
//				});
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/accnt/atx500clrkrv.do',
				prgID: 'atx500ukr',
				extParam: param
			});
			win.center();
			win.show();
		},
		onQueryButtonDown : function()	{	
			if(!this.isValidSearchForm()){
				return false;
			}
			summaryTable.clearForm();
			masterStore.clearData();
			masterStore.loadStoreRecords();
			
			//조회 후에는 패널에 있는 필드 값 변경 안 됨
			panelSearch.getField('FR_PUB_DATE').setReadOnly(true);
			panelSearch.getField('TO_PUB_DATE').setReadOnly(true);
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			
			panelResult.getField('FR_PUB_DATE').setReadOnly(true);
			panelResult.getField('TO_PUB_DATE').setReadOnly(true);
			panelResult.getField('DIV_CODE').setReadOnly(true);	
		},
		
		onNewDataButtonDown: function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			if (masterStore.getCount() > 0) {
				var seq = masterStore.max('SEQ') + 1;
			} else {
				var seq = 1
			}
            	 
			var r = {
            	SEQ : seq
	        };
			masterGrid.createRow(r);
			
			UniAppManager.setToolbarButtons('delete',	true);
			UniAppManager.setToolbarButtons('deleteAll',true);

		},
		
		onResetButtonDown: function() {	
			//panelSearch.clearForm();
			masterGrid.reset();
			//panelResult.clearForm();
			summaryTable.clearForm();
			masterStore.clearData();
			this.setDefault();
			
			UniAppManager.setToolbarButtons(['delete', 'deleteAll', 'save', 'newData'],	false);
		},
		
		onSaveDataButtonDown: function(config) {				
			masterStore.saveStore();
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
			var records = masterStore.data.items;
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

			//합계 테이블 초기화함수 호출
			fnIntSummary();
		
			UniAppManager.setToolbarButtons('deleteAll', false);
		},
		
		setDefault: function() {
			//전체 페이지 초기화 값 설정
			//초기화 시 패널에 있는 필드 값 변경 가능하도록 설정
			panelSearch.getField('FR_PUB_DATE').setReadOnly(false);
			panelSearch.getField('TO_PUB_DATE').setReadOnly(false);
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			
			panelResult.getField('FR_PUB_DATE').setReadOnly(false);
			panelResult.getField('TO_PUB_DATE').setReadOnly(false);
			panelResult.getField('DIV_CODE').setReadOnly(false);	

			//합계 테이블 초기화함수 호출
			fnIntSummary();
		},
		addReference:function()	{
			var param =  panelResult.getValues();
			param.FR_PUB_DATE	= panelResult.getField('FR_PUB_DATE').getStartDate();
			param.TO_PUB_DATE	= panelResult.getField('TO_PUB_DATE').getEndDate();
			atx500ukrService.selectReference(param, function(records){
				Ext.getBody().unmask();
				if(records)	{
					Ext.each(records, function(record, i){
						masterGrid.createRow(record, i);
					})
					fnCompute();
				}
			});
			
		}
	});
	
	function openExcelWindow() {
	    var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';
        
        if(!excelWindow) { 
        	excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
				modal: false,
            	excelConfigName: 'atx500ukr',
        		extParam: { 
//        			'DIV_CODE': panelSearch.getValue('DIV_CODE')
        		},
                grids: [{							//팝업창에서 가져오는 그리드
                		itemId		: 'grid01',
                		title		: '내국신용장,구매확인 전자발급명세서',                        		
                		useCheckbox	: false,
                		model		: 'excel.atx500ukr.sheet01',
                		readApi		: 'atx500ukrService.selectExcelUploadSheet1',
                		columns		: [	
							{dataIndex: '_EXCEL_JOBID',		width: 80,	hidden: true},
		               		{dataIndex: 'GUBUN',			width: 120},        
		               		{dataIndex: 'DOCU_NUM',			width: 166},        
		               		{dataIndex: 'DOCU_DATE',		width: 100},        
		               		{dataIndex: 'COMPANY_NUM',		width: 146},        
		               		{dataIndex: 'AMT_I',			width: 120},        
		               		{dataIndex: 'REMARK',			flex: 1,	minWidth: 80}        
                		]
                	}
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },
                onApply:function()	{
                	excelWindow.getEl().mask('로딩중...','loading-indicator');
                	var me		= this;
                	var grid	= this.down('#grid01');
        			var records	= grid.getStore().getAt(0);	
        			if (!Ext.isEmpty(records)) {
			        	var param	= {
			        		"_EXCEL_JOBID"	: records.get('_EXCEL_JOBID')
			        	};
			        	excelUploadFlag = "Y"
						atx500ukrService.selectExcelUploadSheet1(param, function(provider, response){
					    	var store	= masterGrid.getStore();
					    	var records	= response.result;
					    	console.log("response",response);
					    	
							var param2		= Ext.getCmp('searchForm').getValues();	
							var pubDateFr = param2.FR_PUB_DATE + '01';
							var pubDateTo = param2.TO_PUB_DATE + '31';
							
							param2.FR_PUB_DATE = pubDateFr;
							param2.TO_PUB_DATE = pubDateTo;

							atx500ukrService.fnDocuChk(param2, function(provider, response){				//중복되는 데이터 체크
						    	if (provider.length > 0) {													//데이터가 있을 때는 업로드 하지 않는다.
						    		alert ('기존 자료가 존재합니다. \n기존자료를 삭제하고 다시 올려주시기 바랍니다.')
						    		excelWindow.getEl().unmask();
									grid.getStore().removeAll();
									me.hide();
									
						    	} else {
									Ext.each(records, function(record, idx) {
										record.SEQ	= idx + 1;
										record.COMP_CODE	= UserInfo.compCode;
										record.DIV_CODE		= UserInfo.divCode;
										record.FR_PUB_DATE	= panelSearch.getField('FR_PUB_DATE').getStartDate();
										record.TO_PUB_DATE	= panelSearch.getField('TO_PUB_DATE').getEndDate();
			
										store.insert(i, record);
									});
					           		//합계계산 함수 호출
									fnCompute();
									excelWindow.getEl().unmask();
									grid.getStore().removeAll();
									me.hide();
						    	}
							});
					    });
						excelUploadFlag = "N"
		        	} else {
		        		alert (Msg.fSbMsgH0284);
		        		this.unmask();  
		        	}

		        	//버튼세팅
       				UniAppManager.setToolbarButtons('newData',	true);
       				UniAppManager.setToolbarButtons('delete',	false);
        		}
			});
		}
        excelWindow.center();
        excelWindow.show();
	};
	
	Unilite.createValidator('validator01', {							// 내국신용장.구매확인서에 의한 공급실적명세서(masterGrid) afterEdit
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var record = masterGrid.getSelectedRecord();

			switch(fieldName) {
				case "AMT_I"		:
					if(record.data.AMT_I < 0) {
						rv= Msg.sMB076;	
						break;
					} 
			}
			return rv;
		}
	});

	//합계계산 함수 ("3.내국신용장.구매확인서에 의한 공급실적 명세서" 입력 시, "2.내국신용장.구매확인서에 의한 공급실적 합계"를 구하는 식)
	function fnCompute() {
		//TABLE 초기화 후, 건수 및 금액 계산하여 계산된 값 입력
		//1. TABLE 초기화
		//합계 테이블 초기화함수 호출
		fnIntSummary();

		//2. 건수 및 금액 계산
	    var	sTotCnt = 0, sTotAmt = 0, sNaegukCnt = 0, sNaegukAmt = 0, sGumaeCnt = 0, sGumaeAmt = 0; 
		var records = masterGrid.getStore().data.items;
    	Ext.each(records, function(record, i){
			if(record.get('GUBUN') == 'L'){
				summaryTable.setValue('NAEGUK_CNT', summaryTable.getValue('NAEGUK_CNT') + 1);
				summaryTable.setValue('NAEGUK_AMT', summaryTable.getValue('NAEGUK_AMT') + record.get('AMT_I'));
			
			} else if(record.get('GUBUN') == 'A'){
				summaryTable.setValue('GUMAE_CNT', summaryTable.getValue('GUMAE_CNT') + 1);
				summaryTable.setValue('GUMAE_AMT', summaryTable.getValue('GUMAE_AMT') + record.get('AMT_I'));

			}
		});
		//3. 계산된 결과 값 TABLE에 입력
    	summaryTable.setValue('TOT_CNT', summaryTable.getValue('NAEGUK_CNT') + summaryTable.getValue('GUMAE_CNT'));
    	summaryTable.setValue('TOT_AMT', summaryTable.getValue('NAEGUK_AMT') + summaryTable.getValue('GUMAE_AMT'));
	};
	
	function fnIntSummary() {
		summaryTable.setValue('TOT_CNT',		0);
    	summaryTable.setValue('TOT_AMT',		0);
    	summaryTable.setValue('TOT_REMARK',		'');
    	summaryTable.setValue('NAEGUK_CNT',		0);
    	summaryTable.setValue('NAEGUK_AMT',		0);
    	summaryTable.setValue('NAEGUK_REMARK',	'');
    	summaryTable.setValue('GUMAE_CNT',		0);
    	summaryTable.setValue('GUMAE_AMT',		0);
    	summaryTable.setValue('GUMAE_REMARK',	'');
	}

};

</script>
