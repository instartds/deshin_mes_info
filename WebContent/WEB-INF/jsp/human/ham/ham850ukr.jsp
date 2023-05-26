<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham850ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H037" /> <!-- 상여구분자 -->
	<t:ExtComboStore comboType="AU" comboCode="B030" /> <!-- 세액구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H147" /> <!-- 입퇴사구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A043" /> <!-- 지급/공제구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="A074" /> <!-- 지급분기 -->
	<t:ExtComboStore comboType="BOR120" pgmId="ham850ukr"  /> 			<!-- 사업장 -->
	
	
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'ham850ukrService.selectList',
            update: 'ham850ukrService.updateDetail',        
      	    destroy: 'ham850ukrService.deleteDetail',
			syncAll: 'ham850ukrService.saveAll'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ham850ukrModel', {
	   fields: [
			{name: 'N_GUBUN'			 , text: '구분'				, type: 'string'  },
			{name: 'NAME'				 , text: '성명'				, type: 'string'  },
			{name: 'PERSON_NUMB'		 , text: '사번'				, type: 'string' , allowBlank: false , maxLength : 10},
			{name: 'REPRE_NUM'           , text: '주민번호'			, type: 'string'  },
            {name: 'REPRE_NUM_EXPOS'     , text: '주민번호'         , type: 'string', defaultValue:'*************'},    
			{name: 'JOIN_DATE'			 , text: '입사일'			, type: 'uniDate' },
			{name: 'RETR_DATE'			 , text: '퇴사일'			, type: 'uniDate' },
			{name: 'PAY_YYYY'            , text: '귀속년도'			, type: 'string'  },
			{name: 'QUARTER_TYPE'        , text: '귀속분기'			, type: 'string'    , allowBlank: false , comboType:'AU', comboCode:'A074' , maxLength : 1},
			{name: 'PAY_YYYYMM'          , text: '급여년월'			, type: 'string'    , allowBlank: false ,maxLength:7},
			{name: 'SUPP_YYYYMM'		 , text: '지급년월'			, type: 'string'    , allowBlank: false ,maxLength:7},
			{name: 'WORK_MM'			 , text: '근무월'			, type: 'string'    , allowBlank: false   ,maxLength:2},
			{name: 'WORK_DAY'  			 , text: '근무일수'			, type: 'uniNumber' /*, allowBlank: false*/ ,maxLength:2},
			{name: 'SUPP_TOTAL_I'		 , text: '과세소득'			, type: 'uniPrice'  , allowBlank: false , maxLength : 10},
			{name: 'TAX_EXEMPTION_I'	 , text: '비과세소득'		, type: 'uniPrice' /* , allowBlank: false */ , maxLength : 10},
			{name: 'IN_TAX_I'            , text: '소득세'			, type: 'uniPrice' /* , allowBlank: false */ , maxLength : 10},
			{name: 'LOCAL_TAX_I'		 , text: '주민세'			, type: 'uniPrice' /* , allowBlank: false */ , maxLength : 10},
			{name: 'P_SUPP_TOTAL_I'		 , text: '기지급액'			, type: 'uniPrice'},
			{name: 'P_TAX_EXEMPTION_I'	 , text: '기비과세소득'		, type: 'uniPrice'},
			{name: 'P_IN_TAX_I'		     , text: '기소득세'			, type: 'uniPrice'},
			{name: 'P_LOCAL_TAX_I'		 , text: '기주민세'			, type: 'uniPrice'},
			{name: 'INSERT_DB_USER'		 , text: '입력자'			, type: 'string'  },
			{name: 'INSERT_DB_TIME'		 , text: '입력시간'			, type: 'string'  }
	    ]
	});		// End of Ext.define('Ham850ukrModel', {
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('ham850MasterStore1',{
		model: 'Ham850ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var isErro = false;
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords(); 
       		
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
									 
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
		items: [{	
			title: '기본정보', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '귀속년도',				
				xtype: 'uniYearField',
				name: 'PAY_YYYY',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_YYYY', newValue);
					}
				}
			},{
				fieldLabel: '지급분기',
				name: 'QUARTER_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A074',
				value: '1',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('QUARTER_TYPE', newValue);
					}
				}
			},				
				Unilite.popup('ParttimeEmployee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
						panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					},
					applyextparam: function(popup){		
						//popup.setExtParam({'PAY_GUBUN'  : '2'});
		 			}
				}
            }), {               
                //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                name:'DEC_FLAG', 
                xtype: 'uniTextfield',
                hidden: true
            }]
		}]
	});	//end panelSearch  
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '귀속년도',				
				xtype: 'uniYearField',
				name: 'PAY_YYYY',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PAY_YYYY', newValue);
					}
				}
			},{
				fieldLabel: '지급분기',
				name: 'QUARTER_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A074',
				value: '1',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('QUARTER_TYPE', newValue);
					}
				}
			},
			Unilite.popup('ParttimeEmployee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				colspan:2,
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
						panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
					},
					
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);				
					},
					applyextparam: function(popup){		
						popup.setExtParam({'PAY_GUBUN'  : '2'});
		 			}
				}
			})]
    });
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ham850Grid1', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
		uniOpt: {
			expandLastColumn: true,
        	useRowNumberer: true,
            useMultipleSorting: true
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
//			{dataIndex: 'N_GUBUN'			          , width: 40  },
			{dataIndex: 'NAME'				          , width: 100,
			'editor' : Unilite.popup('ParttimeEmployee_G',{
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected': {
		 							fn: function(records, type) {
		 								UniAppManager.app.fnHumanCheck(records);	
		 							},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								var grdRecord = Ext.getCmp('ham850Grid1').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
									},
									applyextparam: function(popup){		
										popup.setExtParam({'PAY_GUBUN'  : '2'});
						 			}
			 					}
						}),
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
			{dataIndex: 'PERSON_NUMB'		          , width: 100,
			'editor' : Unilite.popup('ParttimeEmployee_G',{
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected': {
		 							fn: function(records, type) {
		 								UniAppManager.app.fnHumanCheck(records);	
		 							},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								var grdRecord = Ext.getCmp('ham850Grid1').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
									},
									applyextparam: function(popup){		
										popup.setExtParam({'PAY_GUBUN'  : '2'});
						 			}
			 					}
						})
			},
			{dataIndex: 'REPRE_NUM'                   , width: 100       , hidden: true},
            {dataIndex: 'REPRE_NUM_EXPOS'             , width: 133},  			
			{dataIndex: 'JOIN_DATE'			          , width: 100 }, 				
			{dataIndex: 'RETR_DATE'			          , width: 93  },				
// 			{dataIndex: 'PAY_YYYY'                    , width: 93  },
			{dataIndex: 'QUARTER_TYPE'                , width: 88  ,align : 'center'}, 				
			{dataIndex: 'PAY_YYYYMM'                  , width: 100 ,align : 'center'}, 				
			{dataIndex: 'SUPP_YYYYMM'		          , width: 100 ,align : 'center'}, 				
			{dataIndex: 'WORK_MM'			          , width: 77  ,align : 'right'}, 				
			{dataIndex: 'WORK_DAY'  			      , width: 77},
			{dataIndex: 'SUPP_TOTAL_I'		          , width: 120, summaryType:'sum'}, 				
			{dataIndex: 'TAX_EXEMPTION_I'	          , width: 120, summaryType:'sum'}, 				
			{dataIndex: 'IN_TAX_I'                    , width: 120, summaryType:'sum'}, 				
			{dataIndex: 'LOCAL_TAX_I'		          , width: 120, summaryType:'sum'}			
//			{dataIndex: 'P_SUPP_TOTAL_I'		      , width: 100}, 				
//			{dataIndex: 'P_TAX_EXEMPTION_I'	          , width: 100} 				
//			{dataIndex: 'P_IN_TAX_I'		          , width: 86, hidden: true}, 				
//			{dataIndex: 'P_LOCAL_TAX_I'		          , width: 86, hidden: true}, 				
//			{dataIndex: 'INSERT_DB_USER'		      , width: 86, hidden: true}, 				
//			{dataIndex: 'INSERT_DB_TIME'		      , width: 86, hidden: true}
		],
		listeners: {
    		beforeedit: function( editor, e, eOpts ) {

	        	/*if(!e.record.phantom == true) { // 신규가 아닐 때
	        		if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB'])) {
						return false;
					}
	        	}*/
	        	if(!e.record.phantom == true || e.record.phantom == true) { 	// 신규이던 아니던
	        		if(UniUtils.indexOf(e.field, ['REPRE_NUM_EXPOS', 'JOIN_DATE', 'RETR_DATE'])) {
						return false;
					}
	        	}
	        },
            onGridDblClick:function(grid, record, cellIndex, colName, td)   {
                if (colName =="REPRE_NUM_EXPOS") {
                    grid.ownerGrid.openRepreNumPopup(record);
                }   
            },
	        edit: function(editor, e) {
	        	var fieldName = e.field;
	        	var num_check = /[0-9]/;
				var date_check01 = /^(19|20)\d{2}.(0[1-9]|1[012])$/;
				var date_check02 = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
				
	        	switch (fieldName) {
						
					
					case 'IN_TAX_I':   // 소득세
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMB075);
							e.record.set(fieldName, e.originalValue);
							return false;
						}else{
							if(e.record.data.IN_TAX_I < 1000){
								e.record.set('IN_TAX_I', 0);
								e.record.set('LOCAL_TAX_I', 0);
								e.record.set('P_IN_TAX_I', 0);
								e.record.set('P_LOCAL_TAX_I', 0);
							}
							else{
								e.record.set('LOCAL_TAX_I',   Math.floor(e.record.data.IN_TAX_I * 0.1));
								e.record.set('P_LOCAL_TAX_I', Math.floor(e.record.data.IN_TAX_I * 0.1));
							}
						}
						break;	
						
					case 'SUPP_YYYYMM' :  // 지급년월
						if (e.record.data.SUPP_YYYYMM != null && e.record.data.SUPP_YYYYMM != '' ) {
							if (!date_check01.test(e.value)) {
								Ext.Msg.alert('확인', '날짜형식이 잘못되었습니다.');
								e.record.set(fieldName, e.originalValue);
								return false;
							} else {
								var quarter = panelSearch.getValue('QUARTER_TYPE');
								var payYyyy = panelSearch.getValue('PAY_YYYY');
								
								var suppYyyymm = e.record.data.SUPP_YYYYMM;
								
								var yyyy  = parseInt(suppYyyymm.substr(0 , 4)); 
								var month = parseInt(suppYyyymm.substr(5 , 2)); 
								
								if(payYyyy != yyyy){
									alert('<t:message code="unilite.msg.fsbMsgH0218"/>');
									//급여지급년월은 조회된 귀속년도 혹은 귀속분기에 포함되어야 합니다.
									e.record.set(fieldName, e.originalValue);
									return false;
								}else{
									if(quarter == '1'){
										if(month < 1 || month > 3){
											alert('<t:message code="unilite.msg.fsbMsgH0218"/>');
											//급여지급년월은 조회된 귀속년도 혹은 귀속분기에 포함되어야 합니다.
											e.record.set(fieldName, e.originalValue);
											return false;
										}
									}else if(quarter == '2'){
										if(month < 4 || month > 6){
											alert('<t:message code="unilite.msg.fsbMsgH0218"/>');
											//급여지급년월은 조회된 귀속년도 혹은 귀속분기에 포함되어야 합니다.
											e.record.set(fieldName, e.originalValue);
											return false;
										}
									}else if(quarter == '3'){
										if(month < 7 || month > 9){
											alert('<t:message code="unilite.msg.fsbMsgH0218"/>');
											//급여지급년월은 조회된 귀속년도 혹은 귀속분기에 포함되어야 합니다.
											e.record.set(fieldName, e.originalValue);
											return false;
										}
									}else if(quarter == '4'){
										if(month < 10 || month > 12){
											alert('<t:message code="unilite.msg.fsbMsgH0218"/>');
											//급여지급년월은 조회된 귀속년도 혹은 귀속분기에 포함되어야 합니다.
											e.record.set(fieldName, e.originalValue);
											return false;
										}
									}
								}	
								e.record.set('SUPP_YYYYMM', e.record.data.SUPP_YYYYMM);	
							}
						}
						break;
					case 'PAY_YYYYMM' :  // 급여년월
						if (e.record.data.PAY_YYYYMM != null && e.record.data.PAY_YYYYMM != '' ) {
							if (!date_check01.test(e.value)) {
								Ext.Msg.alert('확인', '날짜형식이 잘못되었습니다.');
								e.record.set(fieldName, e.originalValue);
								return false;
							} else {
								
								var quarter = panelSearch.getValue('QUARTER_TYPE');
								var payYyyy = panelSearch.getValue('PAY_YYYY');
								
								var payYyyymm = e.record.data.PAY_YYYYMM;
								var yyyy  = parseInt(payYyyymm.substr(0 , 4)); 
								var month = parseInt(payYyyymm.substr(5 , 2)); 
								
								
								if(payYyyy < yyyy){
									alert('<t:message code="unilite.msg.fsbMsgH0219"/>');
									//급여년월은 조회된 귀속년도의 귀속분기보다 작거나 같아야 합니다.
									e.record.set(fieldName, e.originalValue);
									return false;
									if(quarter == '1'){
										if(month > 3){
											alert('<t:message code="unilite.msg.fsbMsgH0219"/>');
											//급여년월은 조회된 귀속년도의 귀속분기보다 작거나 같아야 합니다.
											e.record.set(fieldName, e.originalValue);
											return false;
										}
									}else if(quarter == '2'){
										if(month > 6){
											alert('<t:message code="unilite.msg.fsbMsgH0219"/>');
											//급여년월은 조회된 귀속년도의 귀속분기보다 작거나 같아야 합니다.
											e.record.set(fieldName, e.originalValue);
											return false;
										}
									}else if(quarter == '3'){
										if(month > 9){
											alert('<t:message code="unilite.msg.fsbMsgH0219"/>');
											//급여년월은 조회된 귀속년도의 귀속분기보다 작거나 같아야 합니다.
											e.record.set(fieldName, e.originalValue);
											return false;
										}
									}else if(quarter == '4'){
										if(month > 12){
											alert('<t:message code="unilite.msg.fsbMsgH0219"/>');
											//급여년월은 조회된 귀속년도의 귀속분기보다 작거나 같아야 합니다.
											e.record.set(fieldName, e.originalValue);
											return false;
										}
									}
								}
								e.record.set('PAY_YYYYMM', e.record.data.PAY_YYYYMM);
							}
						}
						break;	
						
					case 'WORK_MM':   // 근무월
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMB075);
							e.record.set(fieldName, e.originalValue);
							return false;
						}else{
							var workMm  = parseInt(e.record.data.WORK_MM); 		
							var strWorkMm = e.record.data.WORK_MM;
							
							if(strWorkMm.length != 2){
								alert('<t:message code="unilite.msg.fsbMsgH0220"/>');
								//근무월은 MM형태의 2자리로 입력하십시오.
								e.record.set(fieldName, e.originalValue);
								return false;
							}
							
							else if(workMm < 1 || workMm > 12){
								alert('<t:message code="unilite.msg.fsbMsgH0221"/>');
								//월은 1월과 12월 사이만 입력가능합니다.
								e.record.set(fieldName, e.originalValue);
								return false;
							}
							e.record.set('WORK_MM', e.record.data.WORK_MM);
						}
						break;	
						
					case 'WORK_DAY':   // 근무일수
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMB075);
							e.record.set(fieldName, e.originalValue);
							return false;
						}else{
							var workDay  = parseInt(e.record.data.WORK_DAY); 	

							if(workDay > 31){
								alert('<t:message code="unilite.msg.sMB335"/>');
								// 0 에서 31일 사이의 날짜를 입력하십시오.
								e.record.set(fieldName, e.originalValue);
								return false;
							}else{
								if(e.originalValue > 0){
									if(e.record.data.WORK_DAY < 1){
										alert('<t:message code="unilite.msg.sMH1116"/>');
										// 0 보다 커야합니다.
										e.record.set(fieldName, e.originalValue);
										return false;
									}else{
										var totalAmountI = e.record.data.SUPP_TOTAL_I;
										fnCalTax(e.record , totalAmountI);
									}
								}
							}
						}
						break;	
					case 'SUPP_TOTAL_I':   // 지급총액
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMB075);
							e.record.set(fieldName, e.originalValue);
							return false;
						}else{
							if(e.originalValue > 0){
								if(e.record.data.WORK_DAY < 1){
									alert('<t:message code="unilite.msg.sMH1116"/>');
									// 0 보다 커야합니다.
									e.record.set(fieldName, e.originalValue);
									return false;
								}
								else if(e.record.data.WORK_DAY > 0){
									var totalAmountI = e.record.data.SUPP_TOTAL_I;
									fnCalTax(e.record , totalAmountI);
								}
							}
						}
						break;
						
					case 'TAX_EXEMPTION_I':   // 지급총액
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMB075);
							e.record.set(fieldName, e.originalValue);
							return false;
						}else{
							//if(e.record.data.P_TAX_EXEMPTION_I == e.record.dataTAX_EXEMPTION_I){
								
								var workDays = e.record.data.WORK_DAY;
								var totalAmountI = (e.record.data.SUPP_TOTAL_I) - (e.record.data.TAX_EXEMPTION_I);
								fnCalTax(e.record , totalAmountI);
							//}
						}
						break;	
					
					default:
						break;
	        		
	        	}
	        }
	    },   
        openRepreNumPopup:function( record )    {
            if(record)  {
                var params = {'REPRE_NO': record.get('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'N'}
                Unilite.popupCipherComm('grid', record, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
            }
                
        }
    });  

    
    //복호화 버튼 정의
    var decrypBtn = Ext.create('Ext.Button',{
        text:'복호화',
        width: 80,
        handler: function() {
            var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
            if(needSave){
               alert(Msg.sMB154); //먼저 저장하십시오.
               return false;
            }
            panelSearch.setValue('DEC_FLAG', 'Y');
            UniAppManager.app.onQueryButtonDown();
            panelSearch.setValue('DEC_FLAG', '');
        }
    });

    
    
	 Unilite.Main({
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
		id  : 'ham850ukrApp',
		fnInitBinding : function() {
			
			UniAppManager.setToolbarButtons(['detail', 'newData'],false);
			
			
			if(UniDate.getDbDateStr(UniDate.get('today')).substring(4, 8) <= '0228'){
				panelSearch.setValue('PAY_YYYY', (new Date().getFullYear() - 1));
				panelResult.setValue('PAY_YYYY', (new Date().getFullYear() - 1));
			}else{
				panelSearch.setValue('PAY_YYYY', new Date().getFullYear());
				panelResult.setValue('PAY_YYYY', new Date().getFullYear());
			}
			
            //복호화버튼 그리드 툴바에 추가가
            var tbar = masterGrid._getToolBar();
            tbar[0].insert(tbar.length + 2, decrypBtn);
			
		},
		onQueryButtonDown : function()	{
			
			
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();		
			panelSearch.getField('PAY_YYYY').setReadOnly(true);
			panelResult.getField('PAY_YYYY').setReadOnly(true);
			
			panelSearch.getField('QUARTER_TYPE').setReadOnly(true);
			panelResult.getField('QUARTER_TYPE').setReadOnly(true);
			
			
 			var viewLocked = masterGrid.getView();
 			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
 			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		
		onSaveDataButtonDown: function (config) {
			directMasterStore.saveStore(config);
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			
			
			if(UniDate.getDbDateStr(UniDate.get('today')).substring(4, 8) <= '0228'){
				panelSearch.setValue('PAY_YYYY', (new Date().getFullYear() - 1));
				panelResult.setValue('PAY_YYYY', (new Date().getFullYear() - 1));
			}else{
				panelSearch.setValue('PAY_YYYY', new Date().getFullYear());
				panelResult.setValue('PAY_YYYY', new Date().getFullYear());
			}
			
			panelSearch.setValue('QUARTER_TYPE', 1);
			panelResult.setValue('QUARTER_TYPE', 1);
			
			panelSearch.getField('PAY_YYYY').setReadOnly(false);
			panelResult.getField('PAY_YYYY').setReadOnly(false);
			
			panelSearch.getField('QUARTER_TYPE').setReadOnly(false);
			panelResult.getField('QUARTER_TYPE').setReadOnly(false);
			
			
			var viewLocked = masterGrid.getView();
 			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
 			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
			
			this.fnInitBinding();
		},
		onDeleteDataButtonDown : function()	{
			if(confirm(Msg.sMB062)) {
				masterGrid.deleteSelectedRow();
				UniAppManager.setToolbarButtons('save',true);	
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		fnHumanCheck: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
			grdRecord.set('NAME', record.NAME);
			grdRecord.set('JOIN_DATE', record.JOIN_DATE);
			grdRecord.set('RETR_DATE', record.RETR_DATE);
			grdRecord.set('REPRE_NUM', record.REPRE_NUM);

		}
	});
	
	/*
	 * 용           : 소득세, 주민세 자동계산
	 * 산      식  : (((지급총액 / 근무일수) - 100000) * 0.08 ) - (((지급총액 / 근무일수) - 100000) * 0.08 * 0.55) * 근무일수
	 * 비      고  : 소득세가 0원이하 이거나 1일 수당이 10만원 이하이면 0원처리한다.
	 * */
	
	function fnCalTax(e, totalAmountI) {
		
		var totalAmountI = totalAmountI;
		var workDays     = e.data.WORK_DAY;
		
		if((totalAmountI / workDays) - 100000 > 0){
			inTaxI = ((((totalAmountI / workDays) - 100000) * 0.08 ) - (((totalAmountI / workDays) - 100000) * 0.08 * 0.55)) * workDays;
			localTaxI = Math.floor(inTaxI * 0.1);
			inTaxI = Math.floor(inTaxI);
			if(inTaxI < 0){
				inTaxI = 0;
				localTaxI = 0;
			}		
		}else{
			inTaxI = 0;
			localTaxI = 0;
		}

		if(inTaxI < 1000){
			inTaxI = 0;
			localTaxI = 0;
		}
		e.set('IN_TAX_I' 		, inTaxI);
		e.set('LOCAL_TAX_I' 	, localTaxI);
		e.set('P_IN_TAX_I' 		, inTaxI);
		e.set('P_LOCAL_TAX_I' 	, localTaxI);
	}
};


</script>
