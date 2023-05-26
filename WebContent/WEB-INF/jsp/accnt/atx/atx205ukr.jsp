<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx205ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A067"  />	<!-- 부가세신고구분 -->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {     
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx205ukrModel1', {
	    fields: [  	  
	    	{name: 'TYPE'				, text: '레코드구분' 			,type: 'string'},
		    {name: 'DIVI'				, text: '자료구분'				,type: 'string'},
		    {name: 'TERM_DIVI'			, text: '기구분' 				,type: 'string'},
		    {name: 'PREV_DIVI'			, text: '신고구분' 			,type: 'string'},
		    {name: 'SAFFER_TAX'			, text: '세무서' 				,type: 'string'},
		    {name: 'SEQ'				, text: '일련번호'				,type: 'string'},
		    {name: 'OWN_COMPANY_NUM'	, text: '사업자등록번호' 		,type: 'string'},
		    {name: 'COMPANY_NUM'		, text: '매출처사업자등록번호' 	,type: 'string'},
		    {name: 'CUSTOM_NAME'		, text: '매출처법인명(상호)' 		,type: 'string'},
		    {name: 'CNT'				, text: '계산서매수'			,type: 'uniPrice'},
		    {name: 'POS_NEGA'			, text: '매출금액음수표시' 		,type: 'string'},
		    {name: 'SUPPLY_AMT_I'		, text: '매출금액' 			,type: 'uniPrice'}
		    
		]          
	});
	
	Unilite.defineModel('Atx205ukrModel2', {
	    fields: [  	  
	    	{name: 'TYPE'				, text: '레코드구분' 			,type: 'string'},
		    {name: 'DIVI'				, text: '자료구분'				,type: 'string'},
		    {name: 'TERM_DIVI'			, text: '기구분' 				,type: 'string'},
		    {name: 'PREV_DIVI'			, text: '신고구분' 			,type: 'string'},
		    {name: 'SAFFER_TAX'			, text: '세무서' 				,type: 'string'},
		    {name: 'SEQ'				, text: '일련번호'				,type: 'string'},
		    {name: 'OWN_COMPANY_NUM'	, text: '사업자등록번호' 		,type: 'string'},
		    {name: 'COMPANY_NUM'		, text: '매입처사업자등록번호' 	,type: 'string'},
		    {name: 'CUSTOM_NAME'		, text: '매입처법인명(상호)' 		,type: 'string'},
		    {name: 'CNT'				, text: '계산서매수'			,type: 'uniPrice'},
		    {name: 'POS_NEGA'			, text: '매입금액음수표시' 		,type: 'string'},
		    {name: 'SUPPLY_AMT_I'		, text: '매입금액' 			,type: 'uniPrice'}
		    
		]          
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directGridStore1 = Unilite.createStore('atx205ukrGridStore1',{
		model: 'Atx205ukrModel1',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'atx205ukrService.selectList4'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directGridStore2 = Unilite.createStore('atx205ukrGridStore2',{
		model: 'Atx205ukrModel2',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'atx205ukrService.selectList6'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
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
				fieldLabel: '신고사업장',
				name:'BILL_DIV_CODE',	
				xtype: 'uniCombobox',
				comboType:'BOR120',
				comboCode	: 'BILL',
//				value: 'userInfo.divCode',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{ 
	        	fieldLabel: '계산서일',
				xtype: 'uniMonthRangefield',  
				startFieldName: 'PUB_DATE_FR',
				endFieldName: 'PUB_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				startDD: 'first',
				endDD: 'last',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PUB_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PUB_DATE_TO',newValue);			    		
			    	}
			    }
			},{
		 		fieldLabel: '작성일자',
		 		xtype: 'uniDatefield',
		 		name: 'WRITE_DATE',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WRITE_DATE', newValue);
					}
				}
			},{
				xtype: 'container',			
				tdAttrs: {align: 'center'},
				layout: {type: 'uniTable', columns: 3},
				items:[{
				   width: 110,
			       xtype: 'button',
				   text: '파일저장',	
				   tdAttrs: {align: 'left', width: 115},
				   handler : function() {
					   
				   }
			    }]
			}]
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,		
    	items: [{
			fieldLabel: '신고사업장',
			name:'BILL_DIV_CODE',	
			xtype: 'uniCombobox',
			comboType:'BOR120',
			comboCode	: 'BILL',
//			value: 'userInfo.divCode',
			allowBlank:false,
			tdAttrs: {width: 300},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				}
			}
		},{ 
        	fieldLabel: '계산서일',
			xtype: 'uniMonthRangefield',  
			startFieldName: 'PUB_DATE_FR',
			endFieldName: 'PUB_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false,
			startDD: 'first',
			endDD: 'last',
			tdAttrs: {width: 300},
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PUB_DATE_FR',newValue);			
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PUB_DATE_TO',newValue);			    		
		    	}
		    }
		},{
	 		fieldLabel: '작성일자',
	 		xtype: 'uniDatefield',
	 		name: 'WRITE_DATE',
	 		tdAttrs: {width: 350},
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WRITE_DATE', newValue);
				}
			}
		},{
			xtype: 'container',			
			tdAttrs: {align: 'right'},
			layout: {type: 'uniTable', columns: 3},
			items:[{
			   width: 110,
		       xtype: 'button',
			   text: '파일저장',	
			   tdAttrs: {align: 'left', width: 115},
			   handler : function() {
				   
			   }
		    }]
		}]
    });
	
	var detailForm1 = Unilite.createForm('atx205ukrDetail1', {
		title: '제출자',	
   		disabled :false,
        flex:1,        
        layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
        defaults: {type: 'uniTextfield', labelWidth:140, width:600, readOnly: true},
        items: [{
		    	fieldLabel: '레코드 구분',
			 	name: 'TYPE'
			},{
		    	fieldLabel: '세무서',
			 	name: 'SAFFER_TAX'
			},{
		    	fieldLabel: '제출년월일',
			 	name: 'WRITE_DATE'
			},{
		    	fieldLabel: '제출자구분',
			 	name: 'DIVI'
			},{
		    	fieldLabel: '세무대리인관리번호',
			 	name: 'MANAGE_NUM'
			},{
		    	fieldLabel: '사업자등록번호',
			 	name: 'COMPANY_NUM'
			},{
		    	fieldLabel: '법인명(상호)',
			 	name: 'DIV_NAME'
			},{
		    	fieldLabel: '주민(법인)등록번호',
			 	name: 'COMP_OWN_NO'
			},{
		    	fieldLabel: '대표자(성명)',
			 	name: 'REPRE_NAME'
		    },{
		    	fieldLabel: '소재지(우편번호)',
			 	name: 'ZIP_CODE'
		    },{
		    	fieldLabel: '소재지(주소)',
			 	name: 'ADDR'
		    },{
		    	fieldLabel: '전화번호',
			 	name: 'TELEPHON'
		    },{
		    	fieldLabel: '제출건수계',
			 	name: 'CNT'
		    },{
		    	fieldLabel: '사용한 한글코드',
			 	name: 'KSC_CODE'
		    }], 
		   api: {
         		 load: 'atx205ukrService.selectList1'				 				
			}
		});

	var detailForm2 = Unilite.createForm('atx205ukrDetail2', {
		title: '제출의무자',	
   		disabled :false,
        flex:1,        
        layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
        defaults: {type: 'uniTextfield', labelWidth:140, width:600, readOnly: true},
        items: [{
		    	fieldLabel: '레코드 구분',
			 	name: 'TYPE'			
			},{
		    	fieldLabel: '세무서',
			 	name: 'SAFFER_TAX'
			},{
		    	fieldLabel: '일련번호',
			 	name: 'SEQ'
			},{
		    	fieldLabel: '사업자등록번호',
			 	name: 'COMPANY_NUM'
			},{
		    	fieldLabel: '법인명(상호)',
			 	name: 'DIV_NAME'
			},{
		    	fieldLabel: '대표자(성명)',
			 	name: 'REPRE_NAME'
		    },{
		    	fieldLabel: '사엄장(우편번호)',
			 	name: 'ZIP_CODE'
		    },{
		    	fieldLabel: '사업소재지(주소)',
			 	name: 'ADDR'
		    }], 
		   api: {
         		 load: 'atx205ukrService.selectList2'				 				
			}
		});										
	var detailForm3 = Unilite.createForm('atx205ukrDetail3', {
		title: '제출의무자별집계(매출)',	
   		disabled :false,
        flex:1,        
        layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
        defaults: {type: 'uniTextfield', labelWidth:140, width:600, readOnly: true},
        items: [{
		    	fieldLabel: '레코드 구분',
			 	name: 'TYPE'			
			},{
		    	fieldLabel: '자료구분',
			 	name: 'DIVI'
			},{
		    	fieldLabel: '기구분',
			 	name: 'TERM_DIVI'
			},{
		    	fieldLabel: '신고구분',
			 	name: 'PREV_DIVI'
			},{
		    	fieldLabel: '세무서',
			 	name: 'SAFFER_TAX'
			},{
		    	fieldLabel: '일련번호',
			 	name: 'SEQ'
			},{
		    	fieldLabel: '사업자등록번호',
			 	name: 'COMPANY_NUM'
			},{
		    	fieldLabel: '귀속년도',
			 	name: 'REVERT_YEAR'
			},{
		    	fieldLabel: '거래기간시작년월',
			 	name: 'FR_DATE'
		    },{
		    	fieldLabel: '거래기간종료년월',
			 	name: 'TO_DATE'
		    },{
		    	fieldLabel: '작성일자',
			 	name: 'WRITE_DATE'
		    },{name:'',	xtype: 'component',  padding:'1 1 1 350',	html:'합계분'
		    },{
		    	fieldLabel: '매출처수',
			 	name: 'CUSTOM_CNT',
			 	xtype: 'uniNumberfield'
		    },{
		    	fieldLabel: '계산서매수',
			 	name: 'CNT',
			 	xtype: 'uniNumberfield'
		    },{
		    	fieldLabel: '매출(수입)금액음수표시',
			 	name: 'POS_NEGA1',
			 	xtype: 'uniNumberfield'
		    },{
		    	fieldLabel: '매출(수입)금액',
			 	name: 'SUPPLY_AMT',
			 	xtype: 'uniNumberfield'
		    },{
		    	xtype: 'container',
	   			defaultType: 'uniNumberfield',
	   			defaults: {readOnly: true},
				layout: {type: 'hbox', align:'stretch'},
				width:740,
				margin:0,
				items:[
			    	{name:'',	xtype: 'component',  padding:'1 1 1 210',  html:'사업자번호발행분'},
			    	{name:'',	xtype: 'component',  padding:'1 1 1 120',  html:'주민등록번호발행분'}
			    ]
		    },{
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
	   			defaults: {readOnly: true},
				layout: {type: 'hbox', align:'stretch'},
				width:740,
				margin:0,
				items:[{
					fieldLabel:'매출처수', 
					name: 'COMP_CUSTOM_CNT', 
					width:370, 
					labelWidth:140
				}, {
					name: 'PER_CUSTOM_CNT', 
					width:230
				}]
			},{
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
	   			defaults: {readOnly: true},
				layout: {type: 'hbox', align:'stretch'},
				width:740,
				margin:0,
				items:[{
					fieldLabel:'계산서매수', 
					name: 'COMP_SLIP_CNT', 
					width:370, 
					labelWidth:140
				}, {
					name: 'PER_SLIP_CNT', 
					width:230
				}]
			},{
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
	   			defaults: {readOnly: true},
				layout: {type: 'hbox', align:'stretch'},
				width:740,
				margin:0,
				items:[{
					fieldLabel:'매출(수입)금액음수표시', 
					name: 'POS_NEGA2', 
					width:370, 
					labelWidth:140
				}, {
					name: 'POS_NEGA3', 
					width:230
				}]
			},{
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
	   			defaults: {readOnly: true},
				layout: {type: 'hbox', align:'stretch'},
				width:740,
				margin:0,
				items:[{
					fieldLabel:'매출(수입)금액', 
					name: 'COMP_SUPPLY_AMT', 
					width:370, 
					labelWidth:140
				}, {
					name: 'PER_SUPPLY_AMT', 
					width:230
				}]
			}], 
		   api: {
         		 load: 'atx205ukrService.selectList3'				 				
			}
		});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid1 = Unilite.createGrid('atx205ukrGrid1', {
    	title: '매출처별거래명세',
    	layout : 'fit',
        store : directGridStore1, 
        uniOpt: {
		   expandLastColumn: false,
		   useRowNumberer: true,
		   useLiveSearch: true,
		      filter: {
		    useFilter: true,
		    autoCreate: true
		   }
		},
    	features: [{
    		id: 'masterGridSubTotal1',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal1', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
        	{dataIndex: 'TYPE'				, width: 75,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
            	}
            }, 				
			{dataIndex: 'DIVI'				, width: 66}, 				
			{dataIndex: 'TERM_DIVI'			, width: 66}, 				
			{dataIndex: 'PREV_DIVI'			, width: 66}, 				
			{dataIndex: 'SAFFER_TAX'		, width: 66}, 				
			{dataIndex: 'SEQ'				, width: 66, align: 'right'}, 				
			{dataIndex: 'OWN_COMPANY_NUM'	, width: 100}, 				
			{dataIndex: 'COMPANY_NUM'		, width: 133}, 				
			{dataIndex: 'CUSTOM_NAME'		, width: 200},
			{dataIndex: 'CNT'				, width: 100, summaryType: 'sum'}, 				
			{dataIndex: 'POS_NEGA'			, width: 133}, 				
			{dataIndex: 'SUPPLY_AMT_I'		, width: 133, summaryType: 'sum'}
		]
    });	
    
	var detailForm4 = Unilite.createForm('atx205ukrDetail4', {
		title: '제출의무자별집계(매입)',	
   		disabled :false,
        flex:1,        
        layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
        defaults: {type: 'uniTextfield', labelWidth:140, width:600, readOnly: true},
        items: [{
		    	fieldLabel: '레코드 구분',
			 	name: 'TYPE'			
			},{
		    	fieldLabel: '자료구분',
			 	name: 'DIVI'
			},{
		    	fieldLabel: '기구분',
			 	name: 'TERM_DIVI'
			},{
		    	fieldLabel: '신고구분',
			 	name: 'PREV_DIVI'
			},{
		    	fieldLabel: '세무서',
			 	name: 'SAFFER_TAX'
			},{
		    	fieldLabel: '일련번호',
			 	name: 'SEQ'
			},{
		    	fieldLabel: '사업자등록번호',
			 	name: 'COMPANY_NUM'
			},{
		    	fieldLabel: '귀속년도',
			 	name: 'REVERT_YEAR'
			},{
		    	fieldLabel: '거래기간시작년월일',
			 	name: 'FR_DATE'
		    },{
		    	fieldLabel: '거래기간종료년월일',
			 	name: 'TO_DATE'
		    },{
		    	fieldLabel: '작성일자',
			 	name: 'WRITE_DATE'
		    },{
		    	fieldLabel: '매입처수합계',
			 	name: 'CNT',
			 	xtype: 'uniNumberfield'
		    },{
		    	fieldLabel: '계산서매수합계',
			 	name: 'SLIP_CNT',
			 	xtype: 'uniNumberfield'
		    },{
		    	fieldLabel: '매입금액합계음수표시',
			 	name: 'POS_NEGA',
			 	xtype: 'uniNumberfield'
		    },{
		    	fieldLabel: '매입금액합계',
			 	name: 'SUPPLY_AMT_I',
			 	xtype: 'uniNumberfield'
		    }], 
		   api: {
         		 load: 'atx205ukrService.selectList5'				 				
			}
		});
   
    var masterGrid2 = Unilite.createGrid('atx205ukrGrid2', {
    	title: '매입처별거래명세',
    	layout : 'fit',
        store : directGridStore2, 
        uniOpt: {
		   expandLastColumn: false,
		   useRowNumberer: true,
		   useLiveSearch: true,
		      filter: {
		    useFilter: true,
		    autoCreate: true
		   }
		},
    	features: [{
    		id: 'masterGridSubTotal2',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal2', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
        	{dataIndex: 'TYPE'					, width: 75,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
            	} 
            }, 				
			{dataIndex: 'DIVI'					, width: 66}, 				
			{dataIndex: 'TERM_DIVI'				, width: 66}, 				
			{dataIndex: 'PREV_DIVI'				, width: 66}, 				
			{dataIndex: 'SAFFER_TAX'			, width: 66}, 				
			{dataIndex: 'SEQ'					, width: 66, align: 'right'}, 				
			{dataIndex: 'OWN_COMPANY_NUM'		, width: 100}, 				
			{dataIndex: 'COMPANY_NUM'			, width: 133}, 				
			{dataIndex: 'CUSTOM_NAME'			, width: 200},
			{dataIndex: 'CNT'					, width: 100, summaryType: 'sum'}, 				
			{dataIndex: 'POS_NEGA'				, width: 133}, 				
			{dataIndex: 'SUPPLY_AMT_I'			, width: 133, summaryType: 'sum'}
		]
    });
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         detailForm1, detailForm2, detailForm3,
	         masterGrid1, detailForm4, masterGrid2
	    ],
		listeners: {
        	tabchange: function( tabPanel, tab ) {
        		UniAppManager.app.onQueryButtonDown();
        	}
		}
    });
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
					tab, panelResult
				]
			},
			panelSearch  	
		],
		id : 'atx205ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
			panelResult.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			//첫번째 탭 조회
			var param = panelSearch.getValues();
			param.PUB_DATE_FR = panelSearch.getField('PUB_DATE_FR').getStartDate();
			param.PUB_DATE_TO = panelSearch.getField('PUB_DATE_TO').getEndDate();
			detailForm1.getForm().load({
				params: param,
				success:function()	{
				},
				failure: function(form, action){
				}
			});
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BILL_DIV_CODE');
		},
		onQueryButtonDown : function()	{		
			var activeTabId = tab.getActiveTab().getId();	
			var param = panelSearch.getValues();
			param.PUB_DATE_FR = panelSearch.getField('PUB_DATE_FR').getStartDate();
			param.PUB_DATE_TO = panelSearch.getField('PUB_DATE_TO').getEndDate();
			if(activeTabId == 'atx205ukrDetail1'){	
				Ext.getBody().mask('로딩중...','loading-indicator');
				detailForm1.getForm().load({
					params: param,
					success:function()	{
						Ext.getBody().unmask();
					},
					failure: function(form, action){
						Ext.getBody().unmask();
					}
				});
				
			}else if(activeTabId == 'atx205ukrDetail2'){	
				Ext.getBody().mask('로딩중...','loading-indicator');
				detailForm2.getForm().load({
					params: param,
					success:function()	{
						Ext.getBody().unmask();
					},
					failure: function(form, action){
						Ext.getBody().unmask();
					}
				});
			}else if(activeTabId == 'atx205ukrDetail3'){
				Ext.getBody().mask('로딩중...','loading-indicator');
				detailForm3.getForm().load({
					params: param,
					success:function()	{
						Ext.getBody().unmask();
					},
					failure: function(form, action){
						Ext.getBody().unmask();
					}
				});			
			}else if(activeTabId == 'atx205ukrGrid1'){				
				directGridStore1.loadStoreRecords();
				var view = masterGrid1.getView();
			    view.getFeature('masterGridSubTotal1').toggleSummaryRow(true);
			    view.getFeature('masterGridTotal1').toggleSummaryRow(true);
				
			}else if(activeTabId == 'atx205ukrDetail4'){
				Ext.getBody().mask('로딩중...','loading-indicator');
				detailForm4.getForm().load({
					params: param,
					success:function()	{
						Ext.getBody().unmask();
					},
					failure: function(form, action){
						Ext.getBody().unmask();
					}
				});			
			}else if(activeTabId == 'atx205ukrGrid2'){				
				directGridStore2.loadStoreRecords();
				var view = masterGrid2.getView();
			    view.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
			    view.getFeature('masterGridTotal2').toggleSummaryRow(true);				
			}
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
