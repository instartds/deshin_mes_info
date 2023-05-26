<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa996ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H148" /> 							<!-- 세액환급소득코드 --> 
	<t:ExtComboStore comboType="AU" comboCode="H159" /> 							<!-- 소득종류 --> 
	<t:ExtComboStore comboType="BOR120"  /> 										<!-- 사업장 -->	
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa996ukrService.selectList',
			update	: 'hpa996ukrService.updateList',
			create	: 'hpa996ukrService.insertList',
			destroy	: 'hpa996ukrService.deleteList',
			syncAll	: 'hpa996ukrService.saveAll'
		}
	});	

	// 콤보박스 생성 (동적콤보 구현 후 삭제해야 함~~~)
	var DetailStore = Unilite.createStore('DetailStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'근로소득 간이세액'			, 'value':'A01'},
			        {'text':'근로소득 중도퇴사'			, 'value':'A02'},
			        {'text':'근로소득 일용근로'			, 'value':'A03'},
			        {'text':'근로소득 연말정산'			, 'value':'A04'},
			        {'text':'퇴직소득 연금계좌'			, 'value':'A21'},
			        {'text':'퇴직소득 그외'			, 'value':'A22'},
			        {'text':'사업소득 매월징수'			, 'value':'A25'},
			        {'text':'사업소득 연말정산'			, 'value':'A26'},
			        {'text':'기타소득 연금계좌'			, 'value':'A41'},
			        {'text':'기타소득 그외'			, 'value':'A42'},
			        {'text':'연금소득 공적연금(매월)'		, 'value':'A45'},
			        {'text':'연금소득 연말정산'			, 'value':'A46'},
			        {'text':'연금소득 연금계좌'			, 'value':'A48'},
			        {'text':'이자소득'				, 'value':'A50'},
			        {'text':'배당소득'				, 'value':'A60'},
			        {'text':'저축해지 추징세액 등'		, 'value':'A69'},
			        {'text':'비거주자 양도소득'			, 'value':'A70'},
			        {'text':'내,외국인법인원천'		, 'value':'A80'},
			        {'text':'수정신고(세액)'			, 'value':'A90'},
			        {'text':'총합계'				, 'value':'A99'}
	    		]
	});

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hpa996ukrModel', {
	   fields: [
			{name: 'COMP_CODE'			    , text: 'COMP_CODE'		, type: 'string'},
			{name: 'SECT_CODE'          	, text: '신고사업장'			, type: 'string'},
			{name: 'PAY_YYYYMM'			  	, text: '신고년월'			, type: 'string'},
			{name: 'TAX_CODE'				, text: '소득의종류코드'		, type: 'string', comboType:'AU', comboCode:'H159'},
			{name: 'DETAIL_CODE'			, text: '세목코드'			, type: 'string', comboType:'AU', store: Ext.data.StoreManager.lookup('DetailStore')},
			{name: 'INCOME_CNT'				, text: '인원'			, type: 'uniQty'},
			{name: 'INCOME_SUPP_TOTAL_I'	, text: '소득지급액'			, type: 'uniPrice'},
			{name: 'DEF_IN_TAX_I'			, text: '결정세액'			, type: 'uniPrice'},
			{name: 'TOT_IN_TAX_I'			, text: '계'				, type: 'uniPrice'},
			{name: 'CU_DEF_IN_TAX_I'		, text: '기납부세액(주,현)'	, type: 'uniPrice'},
			{name: 'P1_DEF_IN_TAX_I'		, text: '기납부세액(종,전)'	, type: 'uniPrice'},
			{name: 'BAL_IN_TAX_I'			, text: '차감납부세액'		, type: 'uniPrice'},
			{name: 'DIVISION_IN_TAX_I'		, text: '분납금액'		, type: 'uniPrice'},
			{name: 'ROW_IN_TAX_I'			, text: '조정환급세액'		, type: 'uniPrice'},
			{name: 'RET_IN_TAX_I'			, text: '환급신청액'			, type: 'uniPrice'},
			{name: 'REFUND_PAY_YYYYMM'		, text: '환급년월'			, type: 'string'}
	    ]
	});		// End of Ext.define('hpa996ukrModel', {
	  
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hpa996MasterStore',{
		model: 'hpa996ukrModel',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: true,			// 수정 모드 사용 
            deletable	: true,			// 삭제 가능 여부 
	        useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy			:directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
    		var list = [].concat( toUpdate );
    		
//			폴멩서 필요한 조건 가져올 경우
//    		var payYyyymm = panelSearch.getValue('PAY_YYYYMM');
//			var paramMaster = panelSearch.getValues();
//			paramMaster.PAY_YYYYMM = UniDate.getDbDateStr(payYyyymm).substring(0,6);
			
			console.log("list:", list);
			
       		var rv = true;
       		
        	if(inValidRecs.length == 0 )	{
				config = {
//					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					} 
				};					
				this.syncAllDirect(config);
				
			}else {
//				alert(Msg.sMB083);
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
 		}
	});
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
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
			title		: '기본정보', 	
	   		itemId		: 'search_panel1',
	        layout		: {type: 'uniTable', columns: 1},
	        defaultType	: 'uniTextfield',
			items: [{
				fieldLabel	: '신고사업장',
				id			: 'SECT_CODE',
				name		: 'SECT_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SECT_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '신고년월',
				xtype		: 'uniMonthfield',
				name		: 'PAY_YYYYMM',                    
				id			: 'PAY_YYYYMM',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
			}]
		}]
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2,
		tableAttrs: {/*style: 'border : 1px solid #ced9e7;', */width: '100%'}
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '신고사업장',
			name		: 'SECT_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
	        tdAttrs		: {width: 350},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SECT_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '신고년월',
			xtype		: 'uniMonthfield',
			name		: 'PAY_YYYYMM',                    
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_YYYYMM', newValue);
				}
			}
		}]
	});

    /* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hpa996Grid1', {
    	layout : 'fit',
        region : 'center',
		store: masterStore,
		uniOpt: {
			useMultipleSorting	: true,		
		    useLiveSearch		: false,		
		    onLoadSelectFirst	: false,			
		    dblClickToEdit		: true,		
		    useGroupSummary		: true,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
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
        columns: [
			{dataIndex: 'TAX_CODE'				, width: 120},
			{dataIndex: 'DETAIL_CODE'			, width: 180},
			{dataIndex: 'INCOME_CNT'			, width: 120},
			{dataIndex: 'INCOME_SUPP_TOTAL_I'	, width: 120},
			{dataIndex: 'DEF_IN_TAX_I'			, width: 120},
			{text: '기간부 원천징수세액', 
            	columns:[
					{dataIndex: 'TOT_IN_TAX_I'				, width: 120, editable: false},
					{dataIndex: 'CU_DEF_IN_TAX_I'			, width: 120},
					{dataIndex: 'P1_DEF_IN_TAX_I'			, width: 120}
			]},
			{dataIndex: 'BAL_IN_TAX_I'			, width: 120, editable: false},
			{dataIndex: 'DIVISION_IN_TAX_I'		, width: 120},
			{dataIndex: 'ROW_IN_TAX_I'			, width: 120},
			{dataIndex: 'RET_IN_TAX_I'			, width: 120},
			{dataIndex: 'SECT_CODE'				, width: 120, hidden: true},
			{dataIndex: 'REFUND_PAY_YYYYMM'		, width: 120, hidden: true},
			{dataIndex: 'PAY_YYYYMM'			, width: 120, hidden: true}
		],
		listeners:{	
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(UniUtils.indexOf(e.field, ['TOT_IN_TAX_I', 'BAL_IN_TAX_I', 'RET_IN_TAX_I'])){ 
					return false;
  				} else {
  					return true;
  				}
			},
			
			edit: function(){
				fnAccntTaxI();
				fnTotalAmt();
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
				masterGrid, panelResult
			]	
		}		
		,panelSearch
		], 
		id: 'hpa996ukrApp',
		
		fnInitBinding : function(params) {
			if(!Ext.isEmpty(params && params.PGM_ID)){
				panelSearch.setValue('SECT_CODE', params.DIV_CODE);
				panelSearch.setValue('PAY_YYYYMM', params.TAX_YYYYMM);
				panelResult.setValue('SECT_CODE', params.DIV_CODE);
				panelResult.setValue('PAY_YYYYMM', params.TAX_YYYYMM);
			} else {
				//초기값 세팅
		 		panelSearch.setValue('PAY_YYYYMM', UniDate.get('today'));
		 		panelResult.setValue('PAY_YYYYMM', UniDate.get('today'));
				panelSearch.setValue('SECT_CODE', UserInfo.divCode);
				panelResult.setValue('SECT_CODE', UserInfo.divCode);
			}
			
	 		//버튼 세팅
			UniAppManager.setToolbarButtons('reset'		,true);
			UniAppManager.setToolbarButtons('newData'	,true);

			//화면 초기화 시 첫번째 필드에 포커스 가도록 설정
			var activeSForm ;	
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {	
				activeSForm = panelResult;
			}	
			activeSForm.onLoadSelectText('SECT_CODE');
		},
		onQueryButtonDown : function()	{		
			masterStore.loadStoreRecords();
			//그리드 세목 콤보목록 동적으로 세팅
			
			//데이터가 없을 때, 그리드 행 추가하여 생성
			
			//버튼 세팅
			UniAppManager.setToolbarButtons('reset'		,true);
			UniAppManager.setToolbarButtons('newData'	,true);
			UniAppManager.setToolbarButtons('deleteAll'	,true);
		},
		onNewDataButtonDown : function() {			
			masterGrid.createRow({ 
				PAY_YYYYMM : Ext.Date.format(Ext.getCmp('PAY_YYYYMM').value,'Ym'),
				SECT_CODE : Ext.getCmp('SECT_CODE').value,
				REFUND_PAY_YYYYMM : Ext.Date.format(Ext.getCmp('PAY_YYYYMM').value,'Ym')
			});			
			UniAppManager.setToolbarButtons('reset'		,true);
			UniAppManager.setToolbarButtons('newData'	,true);
			UniAppManager.setToolbarButtons('save'		, true);			
			UniAppManager.setToolbarButtons('deleteAll'	,true);
		},
		
		onSaveDataButtonDown : function(){
			Ext.getCmp('hpa996Grid1').getStore().syncAll();			
		},
		
		onDeleteDataButtonDown : function()	{
			if(confirm(Msg.sMB062)) {
				masterGrid.deleteSelectedRow();
				UniAppManager.setToolbarButtons('save',true);	
			}
		}
	});
	
	
	
	// 용도 : 하단의 토탈 금액 구하기
	function fnTotalAmt(){
		var dINCOME_CNT;
		var dINCOME_SUPP_TOTAL_I;
		var dDEF_IN_TAX_I;
		var dCU_DEF_IN_TAX_I;
		var dP1_DEF_IN_TAX_I;
		var dROW_IN_TAX_I;
		var dRET_IN_TAX_I;
	    
		var TotINCOME_CNT = 0;
		var TotINCOME_SUPP_TOTAL_I = 0;
		var TotDEF_IN_TAX_I = 0;
		var TotCU_DEF_IN_TAX_I = 0;
		var TotP1_DEF_IN_TAX_I = 0;
		var TotROW_IN_TAX_I = 0;
		var TotRET_IN_TAX_I = 0;
		
		var records = masterGrid.getSelectionModel().getSelection();
		var record_range = masterGrid.getStore().getRange();
		
		Ext.each(record_range, function(record,i){			
			if((record_range.length-1) > i){
				dINCOME_CNT 				= record_range[i].data.INCOME_CNT;
	 	        dINCOME_SUPP_TOTAL_I 	= record_range[i].data.INCOME_SUPP_TOTAL_I;
	 	        dDEF_IN_TAX_I 				= record_range[i].data.DEF_IN_TAX_I;
	 	        dCU_DEF_IN_TAX_I 			= record_range[i].data.CU_DEF_IN_TAX_I;
	 	        dP1_DEF_IN_TAX_I 			= record_range[i].data.P1_DEF_IN_TAX_I;
	 	        dROW_IN_TAX_I 				= record_range[i].data.ROW_IN_TAX_I;
	 	        dRET_IN_TAX_I 				= record_range[i].data.RET_IN_TAX_I;
			
				TotINCOME_CNT 				= TotINCOME_CNT + dINCOME_CNT;
	            TotINCOME_SUPP_TOTAL_I = TotINCOME_SUPP_TOTAL_I + dINCOME_SUPP_TOTAL_I;
	            TotDEF_IN_TAX_I 			= TotDEF_IN_TAX_I + dDEF_IN_TAX_I;
	            TotCU_DEF_IN_TAX_I 		= TotCU_DEF_IN_TAX_I + dCU_DEF_IN_TAX_I;
	            TotP1_DEF_IN_TAX_I 		= TotP1_DEF_IN_TAX_I + dP1_DEF_IN_TAX_I;
	            TotROW_IN_TAX_I 			= TotROW_IN_TAX_I + dROW_IN_TAX_I;
	            TotRET_IN_TAX_I 			= TotRET_IN_TAX_I + dRET_IN_TAX_I;
			}else if((record_range.length-1) == i){
            	record.set("INCOME_CNT", TotINCOME_CNT);
        		record.set("INCOME_SUPP_TOTAL_I", TotINCOME_SUPP_TOTAL_I);
        		record.set("DEF_IN_TAX_I", TotDEF_IN_TAX_I);
        		record.set("CU_DEF_IN_TAX_I", TotCU_DEF_IN_TAX_I);
        		record.set("P1_DEF_IN_TAX_I", TotP1_DEF_IN_TAX_I);
        		record.set("ROW_IN_TAX_I", TotROW_IN_TAX_I);
        		record.set("RET_IN_TAX_I", TotRET_IN_TAX_I);
        		
            }
	    });		
	}
	
	// 용도 : 세액계산
	function fnAccntTaxI(){
		var sDefInTaxICU;	//기납부세액(주,현)
		var sDefInTaxIP1; 	//기납부세액(종,전)
		var sRowInTaxI;		//조정환급세액
		var sTotInTaxI;		//기납부 원천지수세액계
		var sBalInTaxI;		//차감납부세액
		var sRetInTaxI		//환급신청액
		
		var records = masterGrid.getSelectionModel().getSelection();
		Ext.each(records, function(record,i){
			sDefInTaxICU = record.data.CU_DEF_IN_TAX_I;
			sDefInTaxIP1 = record.data.P1_DEF_IN_TAX_I;
			sRowInTaxI = record.data.ROW_IN_TAX_I;
			
			//기납부 원천지수세액계 = 기납부세액(주,현) + 기납부세액(종,전)
			record.set("TOT_IN_TAX_I",sDefInTaxICU + sDefInTaxIP1);
									
			//차감납부세액 = 결정세액 - 기납부 원천지수세액계
			sTotInTaxI = record.data.TOT_IN_TAX_I;
			sBalInTaxI = record.data.DEF_IN_TAX_I - sTotInTaxI;
			record.set("BAL_IN_TAX_I", sBalInTaxI);
			
			//환급신청액 = 차감납부세액 - 조정환급세액
			sRetInTaxI = sBalInTaxI + sRowInTaxI;
			if(sRetInTaxI<0){
				sRetInTaxI = sRetInTaxI * (-1);
			}else{
				sRetInTaxI = 0;
			}
			record.set("RET_IN_TAX_I", sRetInTaxI);
		});
	}

};


</script>