<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa994ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 										<!-- 사업장 -->	
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" /> 						<!-- 신고사업장 -->
	<t:ExtComboStore items="${getBussOfficeCode}" storeId="getBussOfficeCode" />	<!--차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa994ukrService.selectList',
			update	: 'hpa994ukrService.updateList',
			create	: 'hpa994ukrService.insertList',
			destroy	: 'hpa994ukrService.deleteList',
			syncAll	: 'hpa994ukrService.saveAll'
		}
	});	

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa994ukrModel', {
		fields: [
			{name: 'COMP_CODE'			    	, text: 'COMP_CODE'		, type: 'string'},
			{name: 'SECT_CODE'             		, text: '신고사업장'			, type: 'string'},
			{name: 'PAY_YYYYMM'			    	, text: '신고년월'			, type: 'string'},
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
	});//End of Unilite.defineModel('Hpa994ukrModel', {
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hpa994ukrMasterStore1', {
		model: 'Hpa994ukrModel',
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
//    		var payYyyymm = panelSearch.getValue('PAY_YYYYMM');
//			var paramMaster = panelSearch.getValues();
//			paramMaster.PAY_YYYYMM = UniDate.getDbDateStr(payYyyymm).substring(0,6);
			
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
 		/*,
        listeners: {
            load: function(store, records, successful, eOpts) {
				if (store.getCount() > 0)
					Ext.getCmp('printBtn1').enabled();
				else
					Ext.getCmp('printBtn1').disable();
			}
        }*/
	});//End of var masterStore = Unilite.createStore('hpa994ukrMasterStore1', {

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
				fieldLabel	: '신고년월',
				xtype		: 'uniMonthfield',
				name		: 'PAY_YYYYMM',                    
				id			: 'PAY_YYYYMM',
				allowBlank	: false,
				labelWidth	: 110,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
			},{
				fieldLabel	: '신고사업장',
				id			: 'SECT_CODE',
				name		: 'SECT_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				labelWidth	: 110,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SECT_CODE', newValue);
					}
				}
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
		layout : {type : 'uniTable', columns : 4,
		tableAttrs: {/*style: 'border : 1px solid #ced9e7;', */width: '100%'}
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '신고년월',
			xtype		: 'uniMonthfield',
			name		: 'PAY_YYYYMM',                    
			allowBlank	: false,
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_YYYYMM', newValue);
				}
			}
		},{
			fieldLabel	: '납부서출력 지급일',
			xtype		: 'uniDatefield',
			name		: 'SUPP_DATE',                    
			tdAttrs		: {align: 'right'},
			labelWidth	: 100,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SUPP_DATE', newValue);
				}
			}
		},{			
			text		: '납부서 출력',
			itemId 		: 'printBtn1',
			id 			: 'printBtn1',
			xtype		: 'button',
			tdAttrs		: {width: 130, align: 'right'},
			width		: 100,
            handler:function() {
					var param = Ext.getCmp('resultForm').getValues();			// 하단 검색조건
					
					param.PRINT = '1';
					
					var suppDate = panelResult.getValue('SUPP_DATE');
					if (suppDate == '' || suppDate == null){
						alert("납부서 출력 지급일은 필수입력항목입니다.");
						return;
					}
					
					var payDate = panelResult.getValue('PAY_DATE');
					if (payDate == '' || payDate == null){
						alert("납부서 출력 납부일은 필수입력항목입니다.");
						return;
					}
		
			            var win = Ext.create('widget.ClipReport', {
			                url: CPATH+'/human/hpa994clrkr.do',
			                prgID: 'hpa994ukr',
			                extParam: param
			            });
			            win.center();
			            win.show(); 
		        }
			
			
			
		},{
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
			fieldLabel	: '소속지점',
			name		: 'BUSS_OFFICE_CODE', 
			xtype		: 'uniCombobox',
//			comboType	: 'AU',
//			comboCode	: 'B010',
			store		: Ext.data.StoreManager.lookup('getBussOfficeCode'),
	        tdAttrs		: {width: 350},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BUSS_OFFICE_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '납부서출력 납부일',
			xtype		: 'uniDatefield',
			name		: 'PAY_DATE',    			//해당 달의 10일 (fnInitBiniding에 처리)
			tdAttrs		: {align: 'right'},
			labelWidth	: 100,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_DATE', newValue);
				}
			}
		},{			
			text		: '계산서 출력',
			itemId 		: 'printBtn2',
			id 			: 'printBtn2',
			xtype		: 'button',
			tdAttrs: {width: 130, align: 'right'},
			width		: 100,
            handler:function() {
					var param = Ext.getCmp('resultForm').getValues();			// 하단 검색조건
					
					param.PRINT = '2';
					
					var suppDate = panelResult.getValue('SUPP_DATE');
					if (suppDate == '' || suppDate == null){
						alert("납부서 출력 지급일은 필수입력항목입니다.");
						return;
					}
					
					var payDate = panelResult.getValue('PAY_DATE');
					if (payDate == '' || payDate == null){
						alert("납부서 출력 납부일은 필수입력항목입니다.");
						return;
					}
		
			            var win = Ext.create('widget.ClipReport', {
			                url: CPATH+'/human/hpa994clrkr.do',
			                prgID: 'hpa994ukr',
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
	var masterGrid = Unilite.createGrid('hpa994ukrGrid1', {
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
			{dataIndex: 'PAY_YYYYMM'			      , width: 86, hidden: true},*/
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
	});//End of var masterGrid = Unilite.createGr100id('hpa994ukrGrid1', {   
                                                 
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
		id: 'hpa994ukrApp',
		
		fnInitBinding: function() {
			//초기값 세팅
	 		panelSearch.setValue('PAY_YYYYMM', UniDate.get('today'));
	 		panelResult.setValue('PAY_YYYYMM', UniDate.get('today'));
	 		
	 		panelSearch.setValue('SUPP_DATE', UniDate.get('today'));
	 		panelResult.setValue('SUPP_DATE', UniDate.get('today'));
	 		
			//PAY_DATE (해당 달의 10일 세팅)
	 		var payDate = panelSearch.getValue('PAY_YYYYMM');
			var payDateString = UniDate.getDbDateStr(payDate);
			var payDateDateString = (payDateString.substring(0,6) + '10');  
	 		panelSearch.setValue('PAY_DATE', payDateDateString);
	 		panelResult.setValue('PAY_DATE', payDateDateString);
	 		
	 		Ext.getCmp('printBtn1').setDisabled(true);
	 		Ext.getCmp('printBtn2').setDisabled(true);
	 		
	 		//버튼 세팅
			UniAppManager.setToolbarButtons('reset', false);
			
			//화면 초기화 시 첫번째 필드에 포커스 가도록 설정
			var activeSForm ;	
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {	
				activeSForm = panelResult;
			}	
			activeSForm.onLoadSelectText('PAY_YYYYMM');
		},
		
		onQueryButtonDown: function() {			
			masterGrid.getStore().loadStoreRecords();
// 			var viewLocked = masterGrid.lockedGrid.getView();
// 			var viewNormal = masterGrid.normalGrid.getView();
// 			console.log("viewLocked: ", viewLocked);
// 			console.log("viewNormal: ", viewNormal);
// 		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
// 		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
// 		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
// 		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		
		onSaveDataButtonDown: function() {
			masterStore.saveStore();
		}
	});//End of Unilite.Main( {
};


</script>
