<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa971ukr"  >
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" /> 						<!-- 신고사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	//소득구분
	var txtpStore = Ext.create('Ext.data.Store',	{
		storeId :'txtpStore',
		fields:[
			{name:'value', type:'string'},
			{name:'text', type:'string'}
		],
		data:[
			{'value':'11', 'text':'이자'},
			{'value':'12', 'text':'배당'},
			{'value':'13', 'text':'사업'},
			{'value':'14', 'text':'근로'},
			{'value':'16', 'text':'기타'},
			{'value':'21', 'text':'퇴직'},
			{'value':'31', 'text':'외국법인'},
			{'value':'33', 'text':'내국법인'},
			{'value':'34', 'text':'가감세액(조정액)'}
		]
	})
	
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa971ukrService.selectList1'
		}
	});	

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hpa971ukrModel1', {
		fields: [
			{name:'DATA_DIV'    	, text:'자료구분'					, type:'string'},
			{name:'DOC_COD'    		, text:'서식코드'					, type:'string'},
			{name:'SIDO_COD'    	, text:'사업장소재지 시도코드'		, type:'string'},
			{name:'SGG_COD'    		, text:'사업장소재지 시군구코드'	, type:'string'},
			{name:'LDONG_COD'    	, text:'사업장소재지 법정동코드'	, type:'string'},
			{name:'TAX_ITEM'    	, text:'세목코드'					, type:'string'},
			{name:'TAX_YYMM'    	, text:'과세년월'					, type:'uniDate'},
			{name:'TAX_DIV'    		, text:'과세구분'					, type:'string'},
			{name:'REQ_DIV'    		, text:'납부구분'					, type:'string'},
			{name:'TAX_DT'    		, text:'신고일자'					, type:'uniDate'},
			{name:'TPR_COD'    		, text:'개인/법인구분'				, type:'string'},
			{name:'REG_NO'    		, text:'주민(법인)등록번호'			, type:'string'},
			{name:'REG_NM'    		, text:'성명(법인명)'				, type:'string'},
			{name:'BIZ_NO'    		, text:'사업자등록번호'				, type:'string'},
			{name:'CMP_NM'    		, text:'상호'						, type:'string'},
			{name:'BIZ_ZIP_NO'    	, text:'사업장소재지 우편번호'		, type:'string'},
			{name:'BIZ_ADDR'    	, text:'사업장 주소'				, type:'string'},
			{name:'BIZ_TEL'    		, text:'전화번호'					, type:'string'},
			{name:'MO_TEL'    		, text:'핸드폰번호'					, type:'string'},
			{name:'SUP_YYMM'    	, text:'지급연월'					, type:'string'},
			{name:'RVSN_YYMM'    	, text:'귀속연월'					, type:'string'},
			{name:'F_DUE_DT'    	, text:'당초납기일자'				, type:'uniDate'},
			{name:'DUE_DT'    		, text:'납기일자'					, type:'uniDate'},
			{name:'TAX_RT'    		, text:'세율'						, type:'float'	, format:'0,000.0'},
			{name:'TOT_STD_AMT'    	, text:'과세표준합계'				, type:'uniPrice'},
			{name:'PAY_RSTX'    	, text:'지방소득세합계'				, type:'uniPrice'},
			{name:'ADTX_YN'    		, text:'가산세유무'					, type:'string'},
			{name:'ADTX_AM'    		, text:'가산세1정액'				, type:'uniPrice'},
			{name:'DLQ_ADTX'    	, text:'가산세2지연기간'			, type:'int'},
			{name:'DLQ_CNT'    		, text:'납부지연일수'				, type:'int'},
			{name:'PAY_ADTX'    	, text:'가산세'						, type:'uniPrice'},
			{name:'MEMO'    		, text:'비고'						, type:'string'},
			{name:'ADD_MM_RTN'    	, text:'당월기타환급액'				, type:'uniPrice'},
			{name:'ADD_MM_AAMT'    	, text:'당월추가납부액'				, type:'uniPrice'},
			{name:'ADD_YY_TRTN'    	, text:'연말정산환급액'				, type:'uniPrice'},
			{name:'ADD_YY_TAMT'    	, text:'연말정산추가납부액'			, type:'uniPrice'},
			{name:'ADD_ETC_RTN'    	, text:'중도퇴사자환급액'			, type:'uniPrice'},
			{name:'ADD_RDT_ADTX'    , text:'가산세대상추가납부액'		, type:'uniPrice'},
			{name:'ADD_RDT_AADD'    , text:'가산세대상추가가산세'		, type:'uniPrice'},
			{name:'ADD_SUM_RTN'    	, text:'환급합계금액'				, type:'uniPrice'},
			{name:'ADD_SUM_AAMT'    , text:'추가납부합계금액'			, type:'uniPrice'},
			{name:'ADD_OUT_AMT'    	, text:'가감조정금액'				, type:'uniPrice'},
			{name:'ADD_TOT_AMT'    	, text:'납부총금액'					, type:'uniPrice'},
			{name:'INTX'    		, text:'납부할 지방소득세'			, type:'uniPrice'},
			{name:'TOT_ADTX'    	, text:'납부할 가산세'				, type:'uniPrice'},
			{name:'ADD_OUT_SAMT'	, text:'차감후환급잔액'				, type:'uniPrice'},
			{name:'MINU_YN'    		, text:'가감조정금액음수값여부'		, type:'uniPrice'},
			{name:'RPT_REG_NO'    	, text:'세무대리인주민등록번호'		, type:'string'},
			{name:'RPT_NM'    		, text:'세무대리인성명'				, type:'string'},
			{name:'RPT_BIZ_NO'    	, text:'세무대리인사업자등록번호'	, type:'string'},
			{name:'RPT_TEL'    		, text:'세무대리인전화번호'			, type:'string'},
			{name:'TAX_PRO_CD'    	, text:'세무프로그램코드'			, type:'string'},
			{name:'A_SPACE'    		, text:'공란'						, type:'string'}	
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore1 = Unilite.createStore('hpa971ukrMasterStore1', {
		model: 'hpa971ukrModel1',
		uniOpt: {
			isMaster	: false,			// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad		: false,
        proxy			: directProxy1,
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa971ukrService.selectList2'
		}
	});	

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hpa971ukrModel2', {
		fields: [
			{name:'DATA_DIV'    	, text:'자료구분'	, type:'string'},
			{name:'DOC_COD'    		, text:'서식코드'	, type:'string'},
			{name:'TXTP_CD'    		, text:'소득구분'	, type:'string', store:Ext.StoreManager.lookup('txtpStore')},
			{name:'TXTP_EMP'    	, text:'인원'		, type:'int'},
			{name:'TXTP_STD'    	, text:'과세표준액'	, type:'uniPrice'},
			{name:'TXTP_INTX'    	, text:'지방소득세'	, type:'uniPrice'}
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore2 = Unilite.createStore('hpa971ukrMasterStore2', {
		model: 'hpa971ukrModel2',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad		: false,
        proxy			: directProxy2,
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		}
	});
	
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa971ukrService.selectList3'
		}
	});	

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hpa971ukrModel3', {
		fields: [
			{name:'DATA_DIV'    	, text:'자료구분'						, type:'string'},
			{name:'DOC_COD'    		, text:'서식코드'						, type:'string'},
			{name:'SEQ'    			, text:'일련번호'						, type:'string'},
         	{name:'TXTP_CD'    		, text:'소득구분코드'					, type:'string', store:Ext.StoreManager.lookup('txtpStore')},
         	{name:'D_JING'    		, text:'징수연월일'						, type:'uniDate'},
         	{name:'REG_NM'    		, text:'납세의무자 성명'				, type:'string'},
         	{name:'REG_NO'    		, text:'납세의무자 주민/법인등록번호'	, type:'string'},
         	{name:'TAX_STD'    		, text:'과세표준'						, type:'uniPrice'},
         	{name:'CALCUL_TX'    	, text:'산출세액'						, type:'uniPrice'},
         	{name:'ADJ_TAX'    		, text:'조정액(환급액)'					, type:'uniPrice'},
         	{name:'PAY_TAX'    		, text:'납부액'							, type:'uniPrice'},
         	{name:'DTL_NOTE'    	, text:'비고'							, type:'string'}
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore3 = Unilite.createStore('hpa971ukrMasterStore3', {
		model: 'hpa971ukrModel3',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad		: false,
        proxy			: directProxy3,
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		}
	});
	
	

	/* 검색조건 (Search Panel)
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
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel	: '신고사업장',
				name		: 'BILL_DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				comboCode	: 'BILL',
				labelWidth	: 110,
				allowBlank	: false,
				value		: UserInfo.divCode
			},{
				fieldLabel	: '귀속연월',
				xtype		: 'uniMonthfield',
				name		: 'PAY_DATE',                    
				value		: UniDate.get('today'),     
				labelWidth	: 110,               
				allowBlank	: false
			},{
				fieldLabel	: '지급년월',
				xtype		: 'uniMonthfield',
				name		: 'SUPP_DATE',                    
				value		: UniDate.get('today'),     
				labelWidth	: 110,               
				allowBlank	: false
			},{
				fieldLabel	: '신고일자',
				xtype		: 'uniDatefield',
				name		: 'REPORT_DATE',                    
				value		: UniDate.get('today'),   
				labelWidth	: 110,                 
				allowBlank	: false
			}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel	: '신고사업장',
				name		: 'BILL_DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				comboCode	: 'BILL',
				labelWidth	: 110,
				allowBlank	: false,
				value		: UserInfo.divCode
			},{
				fieldLabel	: '귀속연월',
				xtype		: 'uniMonthfield',
				name		: 'PAY_DATE',                    
				value		: UniDate.get('today'),     
				labelWidth	: 110,               
				allowBlank	: false
			},{
				fieldLabel	: '지급년월',
				xtype		: 'uniMonthfield',
				name		: 'SUPP_DATE',                    
				value		: UniDate.get('today'),     
				labelWidth	: 110,               
				allowBlank	: false
			},{
				fieldLabel	: '신고일자',
				xtype		: 'uniDatefield',
				name		: 'REPORT_DATE',                    
				value		: UniDate.get('today'),   
				labelWidth	: 110,                 
				allowBlank	: false
			}]
	});
	
    /* Master Grid 정의(Grid Panel)
     * @type 
     */
	var masterGrid1 = Unilite.createGrid('hpa971ukrGrid1', {
    	// for tab    	
		layout: 'fit',
		title:'납부서(Header)',

		uniOpt:{
			useMultipleSorting	: true,		
		    useLiveSearch		: false,		
		    onLoadSelectFirst	: false,			
		    dblClickToEdit		: true,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	
		    filter: {				
				useFilter		: false,
				autoCreate		: false
			}			
	
		},
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: masterStore1,
		columns: [
			{dataIndex:'DATA_DIV'		, width:100},
			{dataIndex:'DOC_COD'		, width:100},
			{dataIndex:'SIDO_COD'		, width:100},
			{dataIndex:'SGG_COD'		, width:100},
			{dataIndex:'LDONG_COD'		, width:100},
			{dataIndex:'TAX_ITEM'		, width:100},
			{dataIndex:'TAX_YYMM'		, width:100},
			{dataIndex:'TAX_DIV'		, width:100},
			{dataIndex:'REQ_DIV'		, width:100},
			{dataIndex:'TAX_DT'			, width:100},
			{dataIndex:'TPR_COD'		, width:100},
			{dataIndex:'REG_NO'			, width:100},
			{dataIndex:'REG_NM'			, width:100},
			{dataIndex:'BIZ_NO'			, width:100},
			{dataIndex:'CMP_NM'			, width:100},
			{dataIndex:'BIZ_ZIP_NO'		, width:100},
			{dataIndex:'BIZ_ADDR'		, width:100},
			{dataIndex:'BIZ_TEL'		, width:100},
			{dataIndex:'MO_TEL'			, width:100},
			{dataIndex:'SUP_YYMM'		, width:100	, align: 'center'	,
				renderer: function(value, meta, record) {
					if(!Ext.isEmpty(value)) {
				 		value = value.substring(0, 4) + '.' + value.substring(4, 6);
				 	}
				 	return value;
				}
			},
			{dataIndex:'RVSN_YYMM'		, width:100	, align: 'center'	,
				renderer: function(value, meta, record) {
					if(!Ext.isEmpty(value)) {
				 		value = value.substring(0, 4) + '.' + value.substring(4, 6);
				 	}
				 	return value;
				}
			},
			{dataIndex:'F_DUE_DT'		, width:100},
			{dataIndex:'DUE_DT'			, width:100},
			{dataIndex:'TAX_RT'			, width:100},
			{dataIndex:'TOT_STD_AMT'	, width:100},
			{dataIndex:'PAY_RSTX'		, width:100},
			{dataIndex:'ADTX_YN'		, width:100},
			{dataIndex:'ADTX_AM'		, width:100},
			{dataIndex:'DLQ_ADTX'		, width:100},
			{dataIndex:'DLQ_CNT'		, width:100},
			{dataIndex:'PAY_ADTX'		, width:100},
			{dataIndex:'MEMO'			, width:100},
			{dataIndex:'ADD_MM_RTN'		, width:100},
			{dataIndex:'ADD_MM_AAMT'	, width:100},
			{dataIndex:'ADD_YY_TRTN'	, width:100},
			{dataIndex:'ADD_YY_TAMT'	, width:100},
			{dataIndex:'ADD_ETC_RTN'	, width:100},
			{dataIndex:'ADD_RDT_ADTX'	, width:100},
			{dataIndex:'ADD_RDT_AADD'	, width:100},
			{dataIndex:'ADD_SUM_RTN'	, width:100},
			{dataIndex:'ADD_SUM_AAMT'	, width:100},
			{dataIndex:'ADD_OUT_AMT'	, width:100},
			{dataIndex:'ADD_TOT_AMT'	, width:100},
			{dataIndex:'INTX'			, width:100},
			{dataIndex:'TOT_ADTX'		, width:100},
			{dataIndex:'ADD_OUT_SAMT'	, width:100},
			{dataIndex:'MINU_YN'		, width:100},
			{dataIndex:'RPT_REG_NO'		, width:100},
			{dataIndex:'RPT_NM'			, width:100},
			{dataIndex:'RPT_BIZ_NO'		, width:100},
			{dataIndex:'RPT_TEL'		, width:100},
			{dataIndex:'TAX_PRO_CD'		, width:100},
			{dataIndex:'A_SPACE'		, width:100}
		]
	});
	
	var masterGrid2 = Unilite.createGrid('hpa971ukrGrid2', {
    	// for tab    	
		layout: 'fit',
		title:'납부세액 명세서',

		uniOpt:{
			useMultipleSorting	: true,		
		    useLiveSearch		: false,		
		    onLoadSelectFirst	: false,			
		    dblClickToEdit		: true,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	
		    filter: {				
				useFilter		: false,
				autoCreate		: false
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
		store: masterStore2,
		columns: [
			{dataIndex:'DATA_DIV'	, width:100},
			{dataIndex:'DOC_COD'	, width:100},
			{dataIndex:'TXTP_CD'    , width:100},
			{dataIndex:'TXTP_EMP'   , width:100},
			{dataIndex:'TXTP_STD'   , width:100},
			{dataIndex:'TXTP_INTX'  , width:100}
		]
	});
	
	var masterGrid3 = Unilite.createGrid('hpa971ukrGrid3', {
    	// for tab    	
		layout: 'fit',
		title:'계산서 및 명세서',
		uniOpt:{
			useMultipleSorting	: true,		
		    useLiveSearch		: false,		
		    onLoadSelectFirst	: false,			
		    dblClickToEdit		: true,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	
		    filter: {				
				useFilter		: false,
				autoCreate		: false
			}			
	
		},
		features: [{
			id: 'masterGridSubTotal3', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal3', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: masterStore3,
		columns: [
			{dataIndex:'DATA_DIV'		, width:100},
			{dataIndex:'DOC_COD'		, width:100},
			{dataIndex:'SEQ'    		, width:100},
			{dataIndex:'TXTP_CD'   		, width:100},
			{dataIndex:'D_JING'   		, width:100},
			{dataIndex:'REG_NM'   		, width:100},
			{dataIndex:'REG_NO'  		, width:100},
			{dataIndex:'TAX_STD'  		, width:100},
			{dataIndex:'CALCUL_TX'  	, width:100},
			{dataIndex:'ADJ_TAX'  		, width:100},
			{dataIndex:'PAY_TAX'  		, width:100},
			{dataIndex:'DTL_NOTE'  		, width:100}
		]
	});
    var tab = Ext.create('Ext.tab.Panel', {
					itemId:'contentTab',
					region: 'center',
					items:[
						masterGrid1,
						masterGrid2,
						masterGrid3
					],
					listeners:{
						tabchange:function(tabPanel, newCard, oldCard, eOpts){
							if(oldCard){
								if(oldCard.getId() == "hpa971ukrGrid1")	{
									masterStore1.loadData({});
									masterStore1.commitChanges();
								} else if(oldCard.getId() == "hpa971ukrGrid2")	{
									masterStore2.loadData({});
									masterStore2.commitChanges();
								} else if(oldCard.getId() == "hpa971ukrGrid3")	{
									masterStore3.loadData({});
									masterStore3.commitChanges();
								}
								UniAppManager.app.onQueryButtonDown();
							}
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
				panelResult,
				tab
			]	
		}		
		//,panelSearch
		], 
		id: 'hpa971ukrApp',
		
		fnInitBinding: function() {
				
			panelResult.onLoadSelectText('BILL_DIV_CODE');
		},
		
		onQueryButtonDown: function() {			
			var activeTab = tab.getActiveTab();
			if(activeTab)	{
				if(panelResult.isValid())	{
					if(activeTab.getId() == "hpa971ukrGrid1")	{
						masterStore1.loadStoreRecords();
					} else if(activeTab.getId() == "hpa971ukrGrid2")	{
						masterStore2.loadStoreRecords();
					} else if(activeTab.getId() == "hpa971ukrGrid3")	{
						masterStore3.loadStoreRecords();
					}
				}
			}
		},
		
		onResetButtonDown: function() {
			
		}
	});//End of Unilite.Main( {
};


</script>
