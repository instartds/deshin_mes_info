<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpc952ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 										<!-- 사업장 -->	
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" /> 						<!-- 신고사업장 -->
	<t:ExtComboStore items="${getBussOfficeCode}" storeId="getBussOfficeCode" />	<!--차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var searchWindow;

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpc952ukrService.selectList',
			update	: 'hpc952ukrService.updateList',
			create	: 'hpc952ukrService.insertList',
			destroy	: 'hpc952ukrService.deleteList',
			syncAll	: 'hpc952ukrService.saveAll'
		}
	});	

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpc952ukrModel', {
		fields: [
			{name: 'COMP_CODE'			    	, text: 'COMP_CODE'		, type: 'string'},
			{name: 'SECT_CODE'             		, text: '신고사업장'			, type: 'string'},
			{name: 'RPT_YYYYMM'			    	, text: '신고연월'			, type: 'string'},
			{name: 'LOCAL_TAX_GOV_NAME'    		, text: '주민세신고'			, type: 'string'},
			{name: 'BUSS_OFFICE_CODE'	    	, text: '소속지점'			, type: 'string'},
			{name: 'BUSS_OFFICE_NAME'	    	, text: '소속지점명'			, type: 'string'},
			{name: 'CODE_GU'   			    	, text: '구분코드'			, type: 'string'},
			{name: 'CODE_GU_NAME'          		, text: '구분'			, type: 'string'},
			{name: 'INCOME_CNT'            		, text: '인원'			, type: 'int'},
			{name: 'BEF_IN_TAX_I'          		, text: '미환급소득세'		, type: 'uniPrice'},
			{name: 'BEF_LOC_TAX_I'         		, text: '미환급주민세'		, type: 'uniPrice'},
			{name: 'DEF_IN_TAX_I'          		, text: '당월발생소득세'		, type: 'uniPrice'},
			{name: 'DEF_LOC_TAX_I'         		, text: '당월발생주민세'		, type: 'uniPrice'},
			{name: 'NAP_IN_TAX_I'          		, text: '납부소득세'			, type: 'uniPrice'},
			{name: 'NAP_LOC_TAX_I'         		, text: '납부주민세'			, type: 'uniPrice'},
			{name: 'STATE_TYPE'            		, text: 'STATE_TYPE'	, type: 'string'}
		]
	});//End of Unilite.defineModel('Hpc952ukrModel', {
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hpc952ukrMasterStore1', {
		model: 'Hpc952ukrModel',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad		: false,
        proxy			:directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param,
				callback : function () {
					if (masterStore.getCount() > 0)
						Ext.getCmp('printBtn1').setDisabled(false);
						//Ext.getCmp('printBtn2').setDisabled(false);
					else
						Ext.getCmp('printBtn1').setDisabled(true);
						//Ext.getCmp('printBtn2').setDisabled(true);
						
					if (masterStore.getCount() > 0)
						//Ext.getCmp('printBtn1').setDisabled(false);
						Ext.getCmp('printBtn2').setDisabled(false);
					else
						//Ext.getCmp('printBtn1').setDisabled(true);
						Ext.getCmp('printBtn2').setDisabled(true);
				}
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
//			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
//       	var toDelete = this.getRemovedRecords();
    		
//			폴멩서 필요한 조건 가져올 경우
//    		var payYyyymm = panelSearch.getValue('RPT_YYYYMM');
//			var paramMaster = panelSearch.getValues();
//			paramMaster.RPT_YYYYMM = UniDate.getDbDateStr(payYyyymm).substring(0,6);
			
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
 		},
        listeners: {
            load: function(store, records, successful, eOpts) {
            	if(records && records.length > 0)	{
					UniAppManager.app.setDisabledForm(true);
				}
			}
        }
	});//End of var masterStore = Unilite.createStore('hpc952ukrMasterStore1', {

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
				id			: 'SECT_CODE',
				name		: 'SECT_CODE', 
				xtype		: 'uniCombobox',        
				allowBlank	: false,
				comboType	: 'BOR120',
				labelWidth	: 110,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SECT_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '신고연월',
				xtype		: 'uniMonthfield',
				name		: 'RPT_YYYYMM',                    
				id			: 'RPT_YYYYMM',
				allowBlank	: false,
				labelWidth	: 110,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RPT_YYYYMM', newValue);
						
						if (!Ext.isEmpty(newValue)) {
							var payDate = newValue;
							var payDateString = UniDate.getDbDateStr(payDate);
							var payDateDateString = (payDateString.substring(0,6) + '10');  
					 		panelSearch.setValue('PAY_DATE', payDateDateString);
					 		panelResult.setValue('PAY_DATE', payDateDateString);
						}
					}
				}
			},{
				fieldLabel	: '귀속연월',
				xtype		: 'uniMonthfield',
				name		: 'PAY_YYYYMM',
				readOnly    : true,
				labelWidth	: 110,
				listeners   : {
					change : function(field, newValue, oldValue, eOpt) {
						
						if(Ext.isDate(newValue))	{
							panelResult.setValue('PAY_YYYYMM', newValue);
						}
					}
				}
			},{
				fieldLabel	: '지급연월',
				xtype		: 'uniMonthfield',
				name		: 'SUPP_YYYYMM',
				labelWidth	: 110,
				readOnly    : true,
				listeners   : {
					change : function(field, newValue, oldValue, eOpt) {
						
						if(Ext.isDate(newValue))	{
							panelResult.setValue('SUPP_YYYYMM', newValue);
						}
					}
				}
			},{ 
				fieldLabel	: '통합생성',
				name		: 'ALL_DIV_YN',
				xtype		: 'checkbox',
				labelWidth	: 110,
				readOnly    : true,
				inputValue  : 'Y',
				listeners   : {
					change : function(field, newValue, oldValue, eOpt) {
						panelResult.setValue('ALL_DIV_YN', newValue);
					}
				}
			},{
				fieldLabel	: '마감여부',
				name		: 'CLOSE_YN',
				xtype		: 'checkbox',
				labelWidth	: 110,
				inputValue  : 'Y',
				readOnly    : true,
				listeners   : {
					change : function(field, newValue, oldValue, eOpt) {
						panelResult.setValue('CLOSE_YN', newValue);
					}
				}
			},{
				fieldLabel	: '신고구분',
				name		: 'STATE_TYPE',
				xtype		: 'uniTextfield',
				labelWidth	: 110,
				hidden      : true,
				readOnly    : true,
				value		: '0',
				tdAttrs		: {align : 'center'}
			},{
				fieldLabel	: '소속지점',
				name		: 'BUSS_OFFICE_CODE', 
				xtype		: 'uniCombobox',
//				comboType	: 'AU',
//				comboCode	: 'B010',
				store		: Ext.data.StoreManager.lookup('getBussOfficeCode'),
				labelWidth	: 110,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BUSS_OFFICE_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '납부서출력 지급일',
				xtype		: 'uniDatefield',
				name		: 'SUPP_DATE',                    
				labelWidth	: 110,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SUPP_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '납부서출력 납부일',
				xtype		: 'uniDatefield',
				name		: 'PAY_DATE',    			//해당 달의 10일 (fnInitBiniding에 처리)
				labelWidth	: 110,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_DATE', newValue);
					}
				}
			}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 7,
		tableAttrs: {/*style: 'border : 1px solid #ced9e7;', */width: '100%'}
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		scrollable : true,
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '신고사업장',
			name		: 'SECT_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',      
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SECT_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '신고연월',
			xtype		: 'uniMonthfield',
			name		: 'RPT_YYYYMM',     
			allowBlank	: false,
			colspan     : 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('RPT_YYYYMM', newValue);
					
					if (!Ext.isEmpty(newValue)) {
						var payDate = newValue;
						var payDateString = UniDate.getDbDateStr(payDate);
						var payDateDateString = (payDateString.substring(0,6) + '10');  
				 		panelSearch.setValue('PAY_DATE', payDateDateString);
				 		panelResult.setValue('PAY_DATE', payDateDateString);
					}
				}
			}
		},{
			fieldLabel	: '귀속연월',
			xtype		: 'uniMonthfield',
			name		: 'PAY_YYYYMM', 
			labelWidth	: 100,
			readOnly    : true,
			listeners   : {
				change : function(field, newValue, oldValue, eOpt) {
					
					if(Ext.isDate(newValue))	{
						panelSearch.setValue("PAY_YYYYMM", newValue);
					}
				}
			}
		},{
			fieldLabel	: '지급연월',
			xtype		: 'uniMonthfield',
			name		: 'SUPP_YYYYMM',
			labelWidth	: 100,
			readOnly    : true,
			listeners   : {
				change : function(field, newValue, oldValue, eOpt) {
					if(Ext.isDate(newValue))	{
						panelSearch.setValue("SUPP_YYYYMM", newValue);
					}
				}
			}
		},{
			xtype       : 'component',
			flex        : 1,
			html        : '&nbsp;'
		},{
			xtype : 'button',
			text  : '검색',
			tdAttrs: {width: 100, align: 'right', style : 'padding-right : 5px;'},
			width		: 90,
			handler : function(){
				openSeachWindow({});
			}
		},{
		
			fieldLabel	: '소속지점',
			name		: 'BUSS_OFFICE_CODE', 
			xtype		: 'uniCombobox',
//			comboType	: 'AU',
//			comboCode	: 'B010',
			store		: Ext.data.StoreManager.lookup('getBussOfficeCode'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BUSS_OFFICE_CODE', newValue);
				}
			}
		},{ 
			fieldLabel	: '통합생성',
			name		: 'ALL_DIV_YN',
			xtype		: 'checkbox',
			inputValue  : 'Y',
			readOnly    : true,
			listeners   : {
				change : function(field, newValue, oldValue, eOpt) {
					panelSearch.setValue("ALL_DIV_YN", newValue);
				}
			}
		},{
			fieldLabel	: '마감여부',
			name		: 'CLOSE_YN',
			xtype		: 'checkbox',
			inputValue  : 'Y',
			readOnly    : true,
			listeners   : {
				change : function(field, newValue, oldValue, eOpt) {
					panelSearch.setValue("CLOSE_YN", newValue);
				}
			}
		},{
			fieldLabel	: '신고구분',
			name		: 'STATE_TYPE',
			xtype		: 'uniTextfield',
			hidden      : true,
			value		: '0',
			readOnly    : true,
			tdAttrs		: {align : 'center'}
		},{
		
			fieldLabel	: '납부서출력 지급일',
			xtype		: 'uniDatefield',
			name		: 'SUPP_DATE',          
			labelWidth	: 100,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SUPP_DATE', newValue);
				}
			}
		},{
		
			fieldLabel	: '납부서출력 납부일',
			xtype		: 'uniDatefield',
			name		: 'PAY_DATE',    			//해당 달의 10일 (fnInitBiniding에 처리)
			labelWidth	: 100,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_DATE', newValue);
				}
			}
		},{			
			text		: '납부서 출력',
			itemId 		: 'printBtn1',
			id 			: 'printBtn1',
			xtype		: 'button',
			tdAttrs		: {width: 100, align: 'right'},
			width		: 90,
            handler:function() {
					var param = Ext.getCmp('resultForm').getValues();			// 하단 검색조건
					
					param.PRINT = '1';
					
					var suppDate = panelResult.getValue('SUPP_DATE');
					if (suppDate == '' || suppDate == null){
						Unilite.messageBox("납부서 출력 지급일은 필수입력항목입니다.");
						return;
					}
					
					var payDate = panelResult.getValue('PAY_DATE');
					if (payDate == '' || payDate == null){
						Unilite.messageBox("납부서 출력 납부일은 필수입력항목입니다.");
						return;
					}
		
			            var win = Ext.create('widget.ClipReport', {
			                url: CPATH+'/human/hpc952clrkr.do',
			                prgID: 'hpc952ukr',
			                extParam: param
			            });
			            win.center();
			            win.show(); 
		        }
			
			
			
		},{			
			text		: '계산서 출력',
			itemId 		: 'printBtn2',
			id 			: 'printBtn2',
			xtype		: 'button',
			tdAttrs: {width: 100, align: 'right', style : 'padding-right : 5px;'},
			width		: 90,
            handler:function() {
					var param = Ext.getCmp('resultForm').getValues();			// 하단 검색조건
					
					param.PRINT = '2';
					
					var suppDate = panelResult.getValue('SUPP_DATE');
					if (suppDate == '' || suppDate == null){
						Unilite.messageBox("납부서 출력 지급일은 필수입력항목입니다.");
						return;
					}
					
					var payDate = panelResult.getValue('PAY_DATE');
					if (payDate == '' || payDate == null){
						Unilite.messageBox("납부서 출력 납부일은 필수입력항목입니다.");
						return;
					}
		
			            var win = Ext.create('widget.ClipReport', {
			                url: CPATH+'/human/hpc952clrkr.do',
			                prgID: 'hpc952ukr',
			                extParam: param
			            });
			            win.center();
			            win.show(); 
		        }
		}]
	});
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hpc952ukrGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
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
			showSummaryRow: true 
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		store: masterStore,
		columns: [/*	
			{dataIndex: 'COMP_CODE'			    	  , width: 86, hidden: true},
			{dataIndex: 'SECT_CODE'             	  , width: 86, hidden: true},
			{dataIndex: 'RPT_YYYYMM'			      , width: 86, hidden: true},*/
			{dataIndex: 'LOCAL_TAX_GOV_NAME'    	  , width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.human.subtotal" default="소계"/>', '<t:message code="system.label.human.total" default="총계"/>');
				}
			},
/*			{dataIndex: 'BUSS_OFFICE_CODE'	    	  , width: 86, hidden: true},
			{dataIndex: 'BUSS_OFFICE_NAME'	    	  , width: 86, hidden: true},
			{dataIndex: 'CODE_GU'   			      , width: 86, hidden: true},*/
			{dataIndex: 'CODE_GU_NAME'          	  , width: 200},
			{dataIndex: 'INCOME_CNT'            	  , width: 86, summaryType: 'sum'},
			{dataIndex: 'BEF_IN_TAX_I'          	  , width: 113, summaryType: 'sum'},
			{dataIndex: 'BEF_LOC_TAX_I'         	  , width: 113, summaryType: 'sum'},
			{dataIndex: 'DEF_IN_TAX_I'          	  , width: 113, summaryType: 'sum'},
			{dataIndex: 'DEF_LOC_TAX_I'         	  , width: 113, summaryType: 'sum'},
			{dataIndex: 'NAP_IN_TAX_I'          	  , width: 113, summaryType: 'sum'},
			{dataIndex: 'NAP_LOC_TAX_I'         	  , width: 113, summaryType: 'sum'}/*,
			{dataIndex: 'STATE_TYPE'            	  , width: 113, hidden: true}*/
		],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(UniUtils.indexOf(e.field, ['LOCAL_TAX_GOV_NAME', 'CODE_GU_NAME'])){ 
					return false;
  				} else {
  					return true;
  				}
			}
		}
	});//End of var masterGrid = Unilite.createGr100id('hpc952ukrGrid1', {   
	var searchWinForm = Unilite.createSearchForm('SearchWinForm', {	// 검색 팝업창
		layout			: {type: 'uniTable', columns : 2},
		items			: [{
				fieldLabel	: '사업장'  ,
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				comboCode	: 'BILL',
				allowBlank	: false
			},{
				fieldLabel		: '신고연월',
				xtype			: 'uniMonthRangefield',
				startFieldName	: 'RPT_YYYYMM_FR',
				endFieldName	: 'RPT_YYYYMM_TO',
				width			: 350,
				startDate		: UniDate.add(UniDate.today(), {'months' : -6}),
				endDate			: UniDate.get('today')
			}
		]
	});
	Unilite.defineModel('hpc959ukrModel', {
		fields: [
			{name: 'DIV_CODE'				, text: '사업장'								,type: 'string', comboType :'BOR120'},
			{name: 'RPT_YYYYMM'				, text: '신고연월'								,type: 'uniMonth'},
			{name: 'SUPP_YYYYMM'			, text: '지급연월'								,type: 'uniMonth'},
			{name: 'PAY_YYYYMM'				, text: '귀속연월'								,type: 'uniMonth'},
			{name: 'ALL_DIV_YN'				, text: '통합생성여부'							,type: 'string'},
			{name: 'CLOSE_YN'				, text: '마감여부'								,type: 'string'},
			{name: 'LAST_IN_TAX_I'			, text: '전월미환급세액'						,type: 'uniPrice'},
			{name: 'NEXT_IN_TAX_I'			, text: '이월환급세액'							,type: 'uniPrice'},
			{name: 'TAX_AMOUNT'				, text: '납부세액'								,type: 'uniPrice'},
			{name: 'WORK_YN'				, text: '전자파일생성'							,type: 'string'},
			{name: 'WORK_DATE'				, text: '전자파일작성일'						,type: 'uniDate'},
			{name: 'HOMETEX_ID'				, text: '홈텍스ID'							,type: 'string'},
			{name: 'TAX_BASE_YN'			, text: '일괄납부여부'							,type: 'string'}
		]
	});
	 
	var searchWinStore = Unilite.createStore('hpc959ukrStore',{
		model : 'hpc959ukrModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'hpc950ukrService.selectSearchList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('SearchWinForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	var searchWinGrid = Unilite.createGrid('searchWinGrid', {	// 검색팝업창
		// title: '기본',
		layout : 'fit',
		store: searchWinStore,
		uniOpt:{
			useRowNumberer: false
		},
		selType : 'rowmodel',
		columns:  [
			 { dataIndex: 'RPT_YYYYMM'		   ,  width: 80, align:'center'},
			 { dataIndex: 'PAY_YYYYMM'		   ,  width: 80, align:'center'},
			 { dataIndex: 'SUPP_YYYYMM'		   ,  width: 80, align:'center'},
			 { dataIndex: 'ALL_DIV_YN'		   ,  width: 100, align:'center'},
			 { dataIndex: 'CLOSE_YN'		   ,  width: 80, align:'center'},
			 { dataIndex: 'LAST_IN_TAX_I'	   ,  width: 110},
			 { dataIndex: 'TAX_AMOUNT'		   ,  width: 100},
			 { dataIndex: 'NEXT_IN_TAX_I'	   ,  width: 100},
			 { dataIndex: 'WORK_YN'			   ,  width: 100, align:'center'},
			 { dataIndex: 'WORK_DATE'		   ,  width: 100},
			 { dataIndex: 'HOMETEX_ID'		   ,  width: 100},
			 { dataIndex: 'TAX_BASE_YN'		   ,  width: 100, align:'center'}
		  ] ,
		  listeners: {
			  onGridDblClick: function(grid, record, cellIndex, colName) {
				    searchWinGrid.returnData(record);
				  	UniAppManager.app.onQueryButtonDown();
				  	searchWindow.hide();
			  }
		  },
		  returnData: function(record)	{
		  		if(Ext.isEmpty(record))	{
		  			record = this.getSelectedRecord();
		  		}
		  		panelSearch.uniOpt.inLoading = true;
		  		panelResult.uniOpt.inLoading = true;
		  		
		  		panelSearch.setValues(record.data);
		  		panelResult.setValues(record.data);
		  		panelSearch.setValue("SECT_CODE", record.get("DIV_CODE"));
		  		panelResult.setValue("SECT_CODE", record.get("DIV_CODE"));
		  		
		  		panelSearch.uniOpt.inLoading = false
		  		panelResult.uniOpt.inLoading = false;
		  		
		  		if(record.get('ALL_DIV_YN') == 'Y')  {
		  			panelSearch.getField('ALL_DIV_YN').checked = true;
		  			panelResult.getField('ALL_DIV_YN').checked = true;
		  		} else {
		  			panelSearch.getField('ALL_DIV_YN').checked = false;
		  			panelResult.getField('ALL_DIV_YN').checked = false;
		  		}
		  		if(record.get('CLOSE_YN') == 'Y')  {
		  			panelSearch.getField('CLOSE_YN').checked = true;
		  			panelResult.getField('CLOSE_YN').checked = true;
		  		} else {
		  			panelSearch.getField('CLOSE_YN').checked = false;
		  			panelResult.getField('CLOSE_YN').checked = false;
		  		}
		  		panelSearch.getField('RPT_YYYYMM').setReadOnly(true);
		  		panelResult.getField('RPT_YYYYMM').setReadOnly(true);
		  		masterGrid.getStore().loadStoreRecords();
	   	  }
	});                     
	function doSeach() {

		if(UniAppManager.app._needSave())	{
			if(confirm("저장 할 내용이 있습니다. 저장하시겠습니까? ")) {
				UniAppManager.app.onSaveDataButtonDown();
			}
			return;
		} 
		if(panelSearch.getField("RPT_YYYYMM").readOnly)	{
			masterGrid.getStore().loadStoreRecords();
			return;
		}	
		var cparam  = {
				"DIV_CODE"      : panelSearch.getValue("SECT_CODE"),
				"RPT_YYYYMM_FR" : UniDate.getMonthStr(panelSearch.getValue("RPT_YYYYMM")),
				"RPT_YYYYMM_TO" : UniDate.getMonthStr(panelSearch.getValue("RPT_YYYYMM"))
			}
			
		hpc950ukrService.selectSearchList( cparam , function(responseText){
			if(responseText && responseText.length == 1){
				panelSearch.setValues(responseText[0]);
				panelResult.setValues(responseText[0]);
				masterGrid.getStore().loadStoreRecords();
			} else {
				openSeachWindow(cparam);
			}
		})
	}
	function openSeachWindow(config) {		
		if(UniAppManager.app._needSave())	{
			if(confirm("저장 할 내용이 있습니다. 저장하시겠습니까? ")) {
				UniAppManager.app.onSaveDataButtonDown();
			}
			return;
		} 
	
		if(!searchWindow) {
			searchWindow = Ext.create('widget.uniDetailWindow', {
				title	: '지방소득세-(주민세납부서 조회및조정) 검색',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [searchWinForm, searchWinGrid], //masterGrid],
				tbar:  ['->',
					{ itemId : 'saveBtn',
					text: '조회',
					handler: function() {
						searchWinStore.loadStoreRecords();
					},
					disabled: false
					}, {
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							searchWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {beforehide: function(me, eOpt)
					{
					    searchWinForm.clearForm();
					    searchWinGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						searchWindow.searchConfig = {};
						searchWinForm.clearForm();
						searchWinGrid.reset();
					},
					beforeshow : function()	{
						if(!Ext.isEmpty(searchWindow.searchConfig) && searchWindow.searchConfig.RPT_YYYYMM_FR)	{
							searchWinForm.setValues(searchWindow.searchConfig);
						} else {
							searchWinForm.setValue("DIV_CODE"     , panelSearch.getValue("SECT_CODE"));
							searchWinForm.setValue("RPT_YYYYMM_FR", UniDate.add(panelSearch.getValue("RPT_YYYYMM"), {'months': -12}));
							searchWinForm.setValue("RPT_YYYYMM_TO", panelSearch.getValue("RPT_YYYYMM"));
						}
					}
				}
			})
		}
		searchWindow.searchConfig = config;
		searchWindow.show();
		searchWindow.center();
		searchWinStore.loadStoreRecords();
	}
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
		id: 'hpc952ukrApp',
		
		fnInitBinding: function() {
			//초기값 세팅
			panelSearch.setValue('SECT_CODE', UserInfo.divCode);
	 		panelSearch.setValue('RPT_YYYYMM'	, UniDate.get('today'));
			//panelSearch.setValue('PAY_YYYYMM'   , UniDate.add(UniDate.today(), {'months' : -2}));
			//panelSearch.setValue('SUPP_YYYYMM'  , UniDate.add(UniDate.today(), {'months' : -1}));
			panelSearch.setValue("STATE_TYPE"	, "0");
			panelSearch.setValue('SUPP_DATE', UniDate.get('today'));

	 		panelResult.setValue('SECT_CODE', UserInfo.divCode);
			panelResult.setValue('RPT_YYYYMM'	, UniDate.get('today'));
			//panelResult.setValue('PAY_YYYYMM'   , UniDate.add(UniDate.today(), {'months' : -2}));
			//panelResult.setValue('SUPP_YYYYMM'  , UniDate.add(UniDate.today(), {'months' : -1}));
			panelResult.setValue("STATE_TYPE"	, "0");
	 		panelResult.setValue('SUPP_DATE', UniDate.get('today'));
			
	 		
			//PAY_DATE (해당 달의 10일 세팅)
	 		var payDate = panelSearch.getValue('RPT_YYYYMM');
			var payDateString = UniDate.getDbDateStr(payDate);
			var payDateDateString = (payDateString.substring(0,6) + '10');  
	 		panelSearch.setValue('PAY_DATE', payDateDateString);
	 		panelResult.setValue('PAY_DATE', payDateDateString);
	 		
	 		Ext.getCmp('printBtn1').setDisabled(true);
	 		Ext.getCmp('printBtn2').setDisabled(true);
	 		
			
			//화면 초기화 시 첫번째 필드에 포커스 가도록 설정
			var activeSForm ;	
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {	
				activeSForm = panelResult;
			}	
			activeSForm.onLoadSelectText('RPT_YYYYMM');
		},
		
		onQueryButtonDown: function() {			
			doSeach();
		},
		
		onSaveDataButtonDown: function() {
			masterStore.saveStore();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterStore.loadData({});
			this.setDisabledForm(false);
			this.fnInitBinding();
		},
		setDisabledForm : function(b) {
			panelSearch.getField("SECT_CODE").setReadOnly(b);
			panelSearch.getField("RPT_YYYYMM").setReadOnly(b);
			
			panelResult.getField("SECT_CODE").setReadOnly(b);
			panelResult.getField("RPT_YYYYMM").setReadOnly(b);
		}
	});//End of Unilite.Main( {
};


</script>
