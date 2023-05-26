<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aha990ukr"  >
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A035" /> 							<!-- 완료구분-->
	<t:ExtComboStore comboType="AU" comboCode="A039" /> 							<!-- 매각구분-->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> 							<!-- 자본적지출-->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> 							<!-- 화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> 							<!-- 일괄납부여부 -->
	<t:ExtComboStore comboType="AU" comboCode="H157" /> 							<!-- 신고구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	var sTaxYM		= Ext.isEmpty(${selectDefaultTaxYM}) ? []: ${selectDefaultTaxYM} ; 
	var gsrsPayYM	= Ext.isEmpty(${selectDefaultTaxYM}) ? []: ${selectDefaultTaxYM} ; 
	
	var createCertificateData;							// 신고자료생성 팝업
	var createElectronicFilingData;						// 전자신고자료생성 팝업
	var printWindow;									// 신고서 출력 팝업
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'aha990ukrService.selectList',
			update	: 'aha990ukrService.updateList',
//			create	: 'aha990ukrService.insertList',
			destroy	: 'aha990ukrService.deleteList',
			syncAll	: 'aha990ukrService.saveAll'
		}
	});	
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'aha990ukrService.selectList2',
			update	: 'aha990ukrService.updateList2',
//			create	: 'aha990ukrService.insertList',
//			destroy	: 'aha990ukrService.deleteList2',
			syncAll	: 'aha990ukrService.saveAll2'
		}
	});	
	
	var panelFileDown = Unilite.createForm('FileDownForm', {
		url: CPATH+'/accnt/createWithholdingFile.do',
		colspan: 2,
		layout: {type: 'uniTable', columns: 1},
		height: 30,
		padding: '0 0 0 195',
		disabled:false,
		autoScroll: false,
		standardSubmit: true,  
		items:[{
			xtype: 'uniTextfield',
			name: 'DIV_CODE'
		},{
			xtype: 'uniTextfield',
			name: 'WORK_TYPE'
		},{
			xtype: 'uniMonthfield',
			name: 'HOMETAX_YYYYMM'
		},{
			xtype: 'uniMonthfield',
			name: 'BELONG_YYYYMM'
		},{
			xtype: 'uniMonthfield',
			name: 'SUPP_YYYYMM'
		},{
			xtype: 'uniMonthfield',
			name: 'PAY_YYYYMM'
		},{
	 		xtype: 'uniDatefield',
	 		name: 'WORK_DATE'
		},{
	 		xtype: 'uniTextfield',
	 		name: 'HOMETAX_ID'
		},{
	 		xtype: 'uniTextfield',
	 		name: 'ALL_YN'
		},{
	 		xtype: 'checkbox',
	 		name: 'YEAR_YN'
		}]
	});

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aha990ukrModel1', {
	    fields: [  	  
	    	{name: 'SECT_CODE'				, text: '사업장' 						,type: 'string'},
		    {name: 'PAY_YYYYMM'				, text: '년월' 							,type: 'uniDate'},
		    {name: 'INCGUBN'				, text: '구분' 							,type: 'string'},
		    {name: 'INCCODE'				, text: '코드' 							,type: 'string'},
		    {name: 'INCOME_CNT'          	, text: '1.인원' 						,type: 'uniNumber'		, maxLength: 14},
		    {name: 'INCOME_SUPP_TOTAL_I' 	, text: '2.총 지급액' 					,type: 'uniPrice'		, maxLength: 14},
		    {name: 'DEF_IN_TAX_I'			, text: '3.소득세 등' 					,type: 'uniPrice'		, maxLength: 14},
		    {name: 'DEF_SP_TAX_I'			, text: '4.농어촌특별세' 				,type: 'uniPrice'		, maxLength: 14},
		    {name: 'ADD_TAX_I'				, text: '5.가산세' 						,type: 'uniPrice'		, maxLength: 14},
		    {name: 'RET_IN_TAX_I'			, text: '6.당월조정</br>환급세액' 		,type: 'uniPrice'		, maxLength: 14},
		    {name: 'IN_TAX_I'				, text: '7.소득세 등</br>(가산세포함)' 	,type: 'uniPrice'		, maxLength: 14},
		    {name: 'SP_TAX_I'				, text: '8.농어촌특별세' 				,type: 'uniPrice'		, maxLength: 14},
		    {name: 'STATE_TYPE'				, text: '납부세액' 						,type: 'uniPrice'},
		    {name: 'COMP_CODE'				, text: 'COMP_CODE' 					,type: 'string'},
		    {name: 'ORD_NUM'				, text: '차수' 							,type: 'string'},
		    //{name: 'NOW_ORD_NUM'			, text: '현재차수' 						,type: 'string'},
		    {name: 'ADD_ORD_NUM'			, text: '생성차수' 						,type: 'string'}
		    
	    ]
	});
	
	Unilite.defineModel('aha990ukrModel2', {
		fields: [
	    	{name: 'SECT_CODE'      			, text: '사업장' 								,type: 'string'},
			{name: 'PAY_YYYYMM'     			, text: '년월' 								,type: 'string'},
			{name: 'LAST_IN_TAX_I'  			, text: 'A.전월미</br>환급세액' 					,type: 'uniPrice'		, maxLength: 14},
			{name: 'BEFORE_IN_TAX_I'			, text: 'B.기환급</br>신청한세액' 					,type: 'uniPrice'		, maxLength: 14},
			{name: 'BAL_AMT'        			, text: 'C.차감잔액</br>(A-B)' 					,type: 'uniPrice'		, maxLength: 14},
			{name: 'RET_AMT'   					, text: '1.일반환급' 							,type: 'uniPrice'		, maxLength: 14},
			{name: 'TRUST_AMT'      			, text: '2.신탁재산</br>(금융기관)' 				,type: 'uniPrice'		, maxLength: 14},
			{name: 'FIN_COMP_AMT'  				, text: '금융회사 등' 							,type: 'uniPrice'		, maxLength: 14},
			{name: 'MERGER_AMT'   				, text: '합병 등' 								,type: 'uniPrice'		, maxLength: 14},
			{name: 'ETC_AMT'      				, text: '기타'	 							,type: 'uniPrice'		, maxLength: 14},
			{name: 'ROW_IN_TAX_I'   			, text: 'E.</br>조정대상</br>환급세액</br>(C+D)' 	,type: 'uniPrice'		, maxLength: 14},
			{name: 'TOTAL_IN_TAX_I' 			, text: 'F.</br>당월조정</br>환급세액계' 			,type: 'uniPrice'		, maxLength: 14},
			{name: 'NEXT_IN_TAX_I'  			, text: 'G.</br>차월이월</br>환급세액</br>(E-F)' 	,type: 'uniPrice'		, maxLength: 14},
			{name: 'RET_IN_TAX_I'   			, text: 'H.환급신청액' 							,type: 'uniPrice'		, maxLength: 14},
			{name: 'STATE_TYPE'     			, text: 'STATE_TYPE' 						,type: 'string'},
			{name: 'UPDATE_DATE'    			, text: 'UPDATE_DATE' 						,type: 'string'},
			{name: 'UPDATE_ID'      			, text: 'UPDATE_ID' 						,type: 'string'},
			{name: 'COMP_CODE'      			, text: 'COMP_CODE' 						,type: 'string'}		   
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('aha990ukrMasterStore1',{
		model: 'aha990ukrModel1',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: true,			// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			//신고자료 생성은 해당 폼에서 API 따로 사용 (SP호출)
//			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
    		
//			폼에서 필요한 조건 가져올 경우
			var paramMaster = panelSearch.getValues();
			paramMaster.CLOSE_TYPE	= '1';
			
       		var rv = true;
       		
        	if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);

						//2번 째 그리드 변경 확인
						if(masterStore2.isDirty()){
							masterStore2.saveStore();
						}
					} 
				};					
				this.syncAllDirect(config);
				
			}else {
//				alert(Msg.sMB083);
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
 		},
		listeners: {
			load: function() {
				if (this.getCount() > 0) {
	              	UniAppManager.setToolbarButtons('deleteAll', true);
					var param = { 
						'TAX_YYYYMM'	: Ext.getCmp('TAX_YYYYMM').rawValue.split('.').join(''),
						'S_COMP_CODE'	: UserInfo.compCode
					};
					aha990ukrService.selectTaxYM(param, function(provider, response) {
						if (provider.sTaxYM != null) {
							sTaxYM = provider.sTaxYM;	
						}
					});

	              	/*Ext.Ajax.request({
						url     : CPATH+'/human/getTaxYM.do',
						params: { TAX_YYYYMM: Ext.getCmp('TAX_YYYYMM').rawValue.split('.').join(''), S_COMP_CODE: UserInfo.compCode },
						success: function(response){
							var data = Ext.decode(response.responseText);
							console.log(data);
							if (data.sTaxYM != null) {
								sTaxYM = data.sTaxYM;	
							}
							//alert(sTaxYM); // 201007 << 201008
						},
						failure: function(response){
							console.log(response);
						}
					});*/
	              	
                } else {
              	  	UniAppManager.setToolbarButtons('deleteAll', false);
                }  
			}
		}
	});	
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore2 = Unilite.createStore('aha990ukrMasterStore2',{
		model: 'aha990ukrModel2',
		uniOpt: {
            isMaster	: false,		// 상위 버튼 연결 
            editable	: true,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: directProxy2,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			//신고자료 생성은 해당 폼에서 API 따로 사용 (SP호출)
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
			
       		var rv = true;
       		
//			폼에서 필요한 조건 가져올 경우
			var paramMaster = panelSearch.getValues();

			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					} 
				};					
				this.syncAllDirect(config);
				
			}else {
//				alert(Msg.sMB083);
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
 		},
 		listeners: {
			load: function() {				
				if (this.getCount() > 0) {
	              	UniAppManager.setToolbarButtons('deleteAll', true);
                } else {
              	  	UniAppManager.setToolbarButtons('deleteAll', false);
                }  

				UniAppManager.setToolbarButtons('delete'	, false); 
			}
 		}
	});

	var createDataStore = Unilite.createStore('aha990ukrcreateDataStore',{
		proxy: {
           type: 'direct',
            api: {			
                read: 'aha990ukrService.createData'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('createDataForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
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
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
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
				fieldLabel	: '신고년월',
				id			: 'TAX_YYYYMM',
				xtype		: 'uniMonthfield',
				name		: 'TAX_YYYYMM',                    
				allowBlank	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TAX_YYYYMM', newValue);
					}
				}
			},{
            	fieldLabel	: '연말정산포함여부',
            	name		: 'STATE_TYPE',
				id			: 'STATE_TYPE',
				inputValue	: 'Y',
				xtype		: 'checkbox',
				labelWidth	: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('STATE_TYPE', newValue);
					}
				}
    		},{
				fieldLabel	: '차수'	,
				name		:'ORD_NUM', 
				xtype		: 'uniTextfield',
				fieldStyle  : 'text-align: right;',
				allowBlank	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORD_NUM', newValue);
					}
				}
	    	},{
				fieldLabel	: '생성차수'	,
				name		:'ADD_ORD_NUM', 
				labelWidth	: 30,
				xtype		: 'uniTextfield',
				hidden 		: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.setValue('ADD_ORD_NUM', newValue);
					}
				}
	    	}]				
		}]		
	});	//end panelSearch  

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
			fieldLabel	: '신고사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			comboCode	: 'BILL',
			allowBlank	: false,
	        tdAttrs		: {width: 380},  
//	        colspan		: 3,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '신고년월',
			xtype		: 'uniMonthfield',
			name		: 'TAX_YYYYMM',                    
			allowBlank	: false,
	        tdAttrs		: {width: 250},  
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TAX_YYYYMM', newValue);
				}
			}
		},{
        	fieldLabel	: '연말정산포함여부',
        	name		: 'STATE_TYPE',
			value		: 'Y',
			xtype		: 'checkbox',
			labelWidth	: 150,
			tdAttrs		: {width: 250},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('STATE_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: '차수'	,
			name		:'ORD_NUM', 
			labelWidth	: 60,
			xtype		: 'uniTextfield',
			tdAttrs		: {align : 'left'},
			fieldStyle  : 'text-align: right;',
			allowBlank	: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ORD_NUM', newValue);
				}
			}
    	}]
	});	

	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 3},		
		disabled: false,
		border:true,
		padding: '1',
		region: 'center',
		items: [{
				padding: '0 0 5 30',
				width	: 100,
				xtype: 'container',
				html: '[ 작성순서] :',
				style: {
					color: 'blue'				
				}
			},{
            	xtype	: 'container',
            	layout	: { type: 'uniTable', columns: 8},
            	defaults: { xtype: 'button' },	
            	tdAttrs	: {/*style: 'border : 1px solid #ced9e7;', flex: 1, */width : '100%', align : 'left'},
				items	: [/*{
					text	: '원천세 가져오기',
					width	: 120,
					margin	: '0 0 5 0',
					handler	: function(btn) {
						UniAppManager.app.onQueryButtonDown();
					}
				},{
					padding: '0 0 5 0',
					xtype: 'container',
					html: '&nbsp;&nbsp;&nbsp;&nbsp;->&nbsp;&nbsp;&nbsp;&nbsp;',
					style: {
						color: 'blue'				
					}
				},*/{
					text	: '신고자료생성',
					width	: 120,
					margin	: '0 0 5 0',
					id		: 'initButton',
					handler	: function(btn) {
						openCreateCertificateData();
						var TAX_YYYYMM = Ext.getCmp('TAX_YYYYMM').getValue();
						var DIV_CODE = panelSearch.getForm().findField('DIV_CODE').getValue();
						var date = new Date(TAX_YYYYMM);
						//차수 가져오기
						var ordNum = panelSearch.getForm().findField('ORD_NUM').getValue();
						var addOrdNum = panelSearch.getForm().findField('ADD_ORD_NUM').getValue();
						
						date.setMonth(date.getMonth() - 1);
						
						Ext.getCmp('createDataForm').getForm().findField('DIV_CODE').setValue(DIV_CODE);
						Ext.getCmp('createDataForm').getForm().findField('TAX_YYYYMM').setValue(TAX_YYYYMM);
						
						Ext.getCmp('createDataForm').getForm().findField('NOW_ORD_NUM').setValue(ordNum);
						Ext.getCmp('createDataForm').getForm().findField('ADD_ORD_NUM').setValue(addOrdNum);
						
						Ext.getCmp('createDataForm').getForm().getFields().each(function (field) {
							if (field.name != 'DIV_CODE' && field.name != 'TAX_YYYYMM' && field.name != 'TAX_DIV_CODE' 
								&& field.name != 'YEAR_TAX_FLAG' && field.name != 'NOW_ORD_NUM' && field.name != 'ADD_ORD_NUM') {
								field.setValue(date);
							} 
						});
					}
				},{
					padding: '0 0 5 0',
					xtype: 'container',
					html: '&nbsp;&nbsp;&nbsp;&nbsp;->&nbsp;&nbsp;&nbsp;&nbsp;',
					style: {
						color: 'blue'				
					}
				},{
					text	: '전자신고자료 생성',
					width	: 120,
					margin	: '0 0 5 0',
					handler	: function(btn) {
						openCreateElectronicFilingData();
						var TAX_YYYYMM = Ext.getCmp('TAX_YYYYMM').getValue();
						var DIV_CODE = panelSearch.getForm().findField('DIV_CODE').getValue();
						var date = new Date(TAX_YYYYMM);
						date.setMonth(date.getMonth() - 1);
						
						Ext.getCmp('createDataForm2').getForm().findField('DIV_CODE').setValue(DIV_CODE);
						Ext.getCmp('createDataForm2').getForm().findField('HOMETAX_YYYYMM').setValue(TAX_YYYYMM);
						Ext.getCmp('createDataForm2').getForm().getFields().each(function (field) {
							if (field.name == 'BELONG_YYYYMM' || field.name == 'SUPP_YYYYMM' || field.name == 'PAY_YYYYMM') {
								field.setValue(date);
							} 
					     });
					}
				}]
            }]
	});

	/* Master Grid 정의(Grid Panel)
    * @type 
    */
    var masterGrid1 = Unilite.createGrid('aha990ukrGrid1', {
    	layout	: 'fit',
        region	: 'center',
		store	: masterStore,
        flex	: 3,
		uniOpt	: {
			useMultipleSorting	: false,		
		    useLiveSearch		: false,		
		    onLoadSelectFirst	: true,			
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
		sortableColumns	: false,
		enableColumnHide: false,
        tbar:[
        	'->',
    	{
			text: '신고서출력',
			width: 100,
			hidden: false,
			handler: function(btn) {
				openPrintWindow();
				var TAX_YYYYMM = Ext.getCmp('TAX_YYYYMM').getValue();
				var DIV_CODE = panelSearch.getForm().findField('DIV_CODE').getValue();
				var date = new Date(TAX_YYYYMM);
				date.setMonth(date.getMonth() - 1);
				Ext.getCmp('printDataForm').getForm().findField('DIV_CODE').setValue(DIV_CODE);
				Ext.getCmp('printDataForm').getForm().findField('WORK_YYYYMM').setValue(panelResult.getValue('TAX_YYYYMM'));
				Ext.getCmp('printDataForm').getForm().findField('PAY_YYYYMM').setValue(UniDate.add(panelResult.getValue('TAX_YYYYMM'), {months:-1}));
				Ext.getCmp('printDataForm').getForm().findField('SUPP_YYYYMMDD').setValue(UniDate.get('today'));
				var tenDay = '';    //매월 10일 작성일 set
				if(parseInt(UniDate.getDbDateStr(UniDate.get('today')).substring(6, 8)) > 10){  //금일이 10일 이후면 다음 달의 10일을 SET
                    tenDay = UniDate.add(Ext.getCmp('printDataForm').getForm().findField('WORK_YYYYMM').getValue(), {months: +1});
				}else{
				    tenDay = UniDate.get('today');
				}
				tenDay = UniDate.getDbDateStr(tenDay).substring(0, 6) + '10';
				Ext.getCmp('printDataForm').getForm().findField('WRITE_YYYYMMDD').setValue(tenDay);
//				Ext.getCmp('printDataForm').getForm().findField('TAX_YYYYMM').setValue(TAX_YYYYMM);
//				Ext.getCmp('printDataForm').getForm().findField('PAY_INCOM_DT').setValue(date);
			}
		}],
        columns	: [
        	{dataIndex: 'SECT_CODE'						, width: 133, hidden: true},
        	{dataIndex: 'PAY_YYYYMM'					, width: 133, hidden: true},
        	{dataIndex: 'INCGUBN'						, width: 250},
        	{dataIndex: 'INCCODE'						, width: 50 , align: 'center'},
        	{text: '원 천 징 수 내 역',
          		columns: [
          			{text: '소 득 지 급</br>과세미달, 비과세 포함',
          				columns: [
        					{dataIndex: 'INCOME_CNT'         	, width: 86/*,
								renderer: function(value, metaData, record) {
									if (UniUtils.indexOf(record.data.INCCODE,	[ 'A06', 'A90' ])){
										metaData.tdCls = 'x-change-cell_light';
									}
									return Ext.util.Format.number(value,'0,000');
								}*/
        					},
        					{dataIndex: 'INCOME_SUPP_TOTAL_I'	, width: 120/*,
								renderer: function(value, metaData, record) {
									if (UniUtils.indexOf(record.data.INCCODE,	[ 'A05', 'A06', 'A69', 'A90', 'C41', 'C42'
																				, 'C43', 'C44', 'C45', 'C46', 'C50' ])){
										metaData.tdCls = 'x-change-cell_light';
									}
									return Ext.util.Format.number(value,'0,000');
								}*/
        					}
        				]
          			},{text: '징수세액',
          				columns: [
        					{dataIndex: 'DEF_IN_TAX_I'			, width: 120/*,
								renderer: function(value, metaData, record) {
									if (UniUtils.indexOf(record.data.INCCODE,	[ 'C01', 'C02', 'C03', 'C05', 'C06', 'C07'
																				, 'C08', 'C10', 'C19', 'C20', 'C23', 'C28'
																				, 'C29', 'C40', 'C76' ])){
										metaData.tdCls = 'x-change-cell_light';
									}
									return Ext.util.Format.number(value,'0,000');
								}*/
        					},
        					{dataIndex: 'DEF_SP_TAX_I'			, width: 120/*,
								renderer: function(value, metaData, record) {
									if (UniUtils.indexOf(record.data.INCCODE,	[ 'A03', 'A20', 'A21', 'A22', 'A25', 'A40'
																				, 'A41', 'A42', 'A45', 'A46', 'A47', 'A48'
																				, 'A69', 'A70', 'A80', 'C01', 'C02', 'C03'
																				, 'C05', 'C07', 'C08', 'C10', 'C20', 'C23'
																				, 'C28', 'C54', 'C55', 'C13', 'C18', 'C36'
																				, 'C37', 'C38', 'C52', 'C58', 'C39', 'C14'
																				, 'C24', 'C91', 'C92', 'C15', 'C25', 'C16'
																				, 'C26', 'C41', 'C42', 'C43', 'C44', 'C45'
																				, 'C50', 'C71', 'C72', 'C73', 'C74', 'C75'
																				, 'C76', 'C81', 'C82', 'C83', 'C84', 'C85'
																				, 'C86', 'C87', 'C88', 'C90' ])){
										metaData.tdCls = 'x-change-cell_light';
									}
									return Ext.util.Format.number(value,'0,000');
								}*/
        					},
        					{dataIndex: 'ADD_TAX_I'				, width: 120/*,
								renderer: function(value, metaData, record) {
									if (UniUtils.indexOf(record.data.INCCODE,	[ 'C01', 'C02', 'C03', 'C05', 'C07', 'C08'
																				, 'C10', 'C20', 'C23', 'C28', 'C76' ])){
										metaData.tdCls = 'x-change-cell_light';
									}
									return Ext.util.Format.number(value,'0,000');
								}*/
        					}
        				]
          			}
        		]
        	},
    		{dataIndex: 'RET_IN_TAX_I'					, width: 120/*,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.INCCODE,	[ 'A01', 'A02', 'A03', 'A04', 'A05', 'A06'
																, 'A21', 'A22', 'A25', 'A26', 'A41', 'A42'
																, 'A48', 'A45', 'A46', 'C76', 'C01', 'C02'
																, 'C03', 'C05', 'C06', 'C07', 'C08', 'C10'
																, 'C20', 'C23', 'C28', 'C40', 'C19', 'C29'
																, 'C11', 'C31', 'C33', 'C34', 'C54', 'C55'
																, 'C56', 'C57', 'C12', 'C22', 'C13', 'C18'
																, 'C36', 'C37', 'C38', 'C52', 'C58', 'C39'
																, 'C14', 'C24', 'C91', 'C92', 'C15', 'C25'
																, 'C16', 'C26', 'C41', 'C42', 'C43', 'C44'
																, 'C45', 'C46' ])){
						metaData.tdCls = 'x-change-cell_light';
					}
					return Ext.util.Format.number(value,'0,000');
				}*/
			},
        	{text: '납부세액',
          		columns: [
        			{dataIndex: 'IN_TAX_I'						, width: 120/*,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.INCCODE,	[ 'A01', 'A02', 'A03', 'A04', 'A05', 'A06'
																		, 'A25', 'A26', 'A48', 'A45', 'A46', 'C76'
																		, 'C01', 'C02', 'C03', 'C05', 'C06', 'C07'
																		, 'C08', 'C10', 'C20', 'C23', 'C28', 'C40'
																		, 'C19', 'C29', 'C11', 'C31', 'C33', 'C34'
																		, 'C54', 'C55', 'C56', 'C57', 'C12', 'C22'
																		, 'C13', 'C18', 'C36', 'C37', 'C38', 'C52'
																		, 'C58', 'C39', 'C14', 'C24', 'C91', 'C92'
																		, 'C15', 'C25', 'C16', 'C26', 'C41', 'C42'
																		, 'C43', 'C44', 'C45', 'C46' ])){
								metaData.tdCls = 'x-change-cell_light';
							}
							return Ext.util.Format.number(value,'0,000');
						}*/
					},
        			{dataIndex: 'SP_TAX_I'						, width: 120/*,
						renderer: function(value, metaData, record) {
							if (UniUtils.indexOf(record.data.INCCODE,	[ 'A01', 'A02', 'A03', 'A04', 'A05', 'A06'
																		, 'A21', 'A22', 'A20', 'A25', 'A26', 'A41'
																		, 'A42', 'A40', 'A48', 'A45', 'A46', 'A47'
																		, 'A69', 'A70', 'A80', 'C71', 'C72', 'C73'
																		, 'C74', 'C75', 'C76', 'C81', 'C82', 'C83'
																		, 'C84', 'C85', 'C86', 'C87', 'C88', 'C90'
																		, 'C01', 'C02', 'C03', 'C05', 'C06', 'C07'
																		, 'C08', 'C10', 'C20', 'C23', 'C28', 'C40'
																		, 'C19', 'C29', 'C11', 'C31', 'C33', 'C34'
																		, 'C54', 'C55', 'C56', 'C57', 'C12', 'C22'
																		, 'C13', 'C18', 'C36', 'C37', 'C38', 'C52'
																		, 'C58', 'C39', 'C14', 'C24', 'C91', 'C92'
																		, 'C15', 'C25', 'C16', 'C26', 'C41', 'C42'
																		, 'C43', 'C44', 'C45', 'C46', 'C50' ])){
								metaData.tdCls = 'x-change-cell_light';
							}
							return Ext.util.Format.number(value,'0,000');
						}*/
					}
        		]
        	},
        	{dataIndex: 'STATE_TYPE'					, width: 80, hidden: true},
        	{dataIndex: 'COMP_CODE'						, width: 6, hidden: true}
		],
		listeners: {
			beforeedit: function(editor, e, eOpts) {
				console.log(e);
				// e.record.data.INCCODE = 'A02'
				// e.field = 'DEF_SP_TAX_I'
				
				//구분, 코드는 수정 불가
				if(UniUtils.indexOf(e.field, ['INCGUBN', 'INCCODE'])){ 
					return false;
  				}
  				
  				//데이터가 존재할 때, gsrsPayYM > 201202보다 클 경우 로직 수행
				if(e.store.data.length <= 0) {
					return false
				} else if (sTaxYM != '') {
					/*******************************************************************************
						2012년 2월 원칭징수이행상황신고서
					*******************************************************************************/
					if (gsrsPayYM >= 201202) {
						if (e.field == 'INCOME_CNT'){													//인원이면
							if (UniUtils.indexOf(e.record.data.INCCODE,	[ 'A06', 'A10', 'A30', 'A40', 'A47', 'A90'
																		, 'A99', 'C30', 'C50', 'C70', 'C90'])){
								return false;									
							} else {
								return true;
							}
						}
						if (e.field == 'INCOME_SUPP_TOTAL_I'){											//총지급액이면
							if (UniUtils.indexOf(e.record.data.INCCODE,	[ 'A05', 'A06', 'A10', 'A30', 'A40', 'A47'
																		, 'A69', 'A90', 'A99', 'C30', 'C41', 'C42'
																		, 'C43', 'C44', 'C45', 'C46', 'C50', 'C70', 'C90'])){
								return false;									
							} else {
								return true;
							}
						}
						if (e.field == 'DEF_IN_TAX_I'){													//소득세이면
							if (UniUtils.indexOf(e.record.data.INCCODE,	[ 'A10', 'A30', 'A40', 'A47', 'A99', 'C01'
																		, 'C02', 'C03', 'C04', 'C05', 'C06', 'C07'
																		, 'C08', 'C09', 'C10', 'C17', 'C19', 'C20'
																		, 'C23', 'C27', 'C28', 'C29', 'C30', 'C35'
																		, 'C40', 'C50', 'C70', 'C76', 'C90'])){
								return false;									
							} else {
								return true;
							}
						}
						if (e.field == 'DEF_SP_TAX_I'){													//농어촌특별세이면
							if (UniUtils.indexOf(e.record.data.INCCODE,	[ 'A03', 'A10', 'A20', 'A21', 'A22', 'A25'
																		, 'A30', 'A40', 'A41', 'A42', 'A45', 'A46'
																		, 'A47', 'A48', 'A69', 'A70', 'A80', 'A99'
																		, 'C01', 'C02', 'C03', 'C04', 'C05', 'C07'
																		, 'C08', 'C09', 'C10', 'C13', 'C14', 'C15'
																		, 'C16', 'C17', 'C18', 'C20', 'C23', 'C24'
																		, 'C25', 'C26', 'C28', 'C30', 'C36', 'C37'
																		, 'C38', 'C39', 'C41', 'C42', 'C43', 'C44'
																		, 'C45', 'C50', 'C52', 'C53', 'C54', 'C55'
																		, 'C70', 'C71', 'C72', 'C73', 'C74', 'C75'
																		, 'C76', 'C81', 'C82', 'C83', 'C84', 'C85'
																		, 'C86', 'C87', 'C88', 'C90'])){
								return false;
							} else {
								return true;
							}
						}
						if (e.field == 'ADD_TAX_I'){													//가산세이면
							if (UniUtils.indexOf(e.record.data.INCCODE,	[ 'A10', 'A30', 'A40', 'A47', 'A99', 'C01'
																		, 'C02', 'C03', 'C04', 'C05', 'C07', 'C08'
																		, 'C09', 'C10', 'C17', 'C20', 'C23', 'C28'
																		, 'C30', 'C50', 'C70', 'C76', 'C90'])){
								return false;
							} else {
								return true;
							}
						}
						if (e.field == 'RET_IN_TAX_I' || e.field == 'IN_TAX_I'){						//당월조정환급세액 또는  소득세이면
							if (UniUtils.indexOf(e.record.data.INCCODE,	[ 'A50', 'A60', 'A69', 'A70', 'A80', 'A90'
																		, 'C30', 'C61', 'C62', 'C63', 'C64', 'C65'
																		, 'C66', 'C67', 'C68', 'C71', 'C72', 'C73'
																		, 'C74', 'C75', 'C81', 'C82', 'C83', 'C84'
																		, 'C85', 'C86', 'C87', 'C88'])){
								return true;
							} else {
								return false;
							}
						}
						if (e.field == 'SP_TAX_I'){														//농어촌특별세이면
							if (UniUtils.indexOf(e.record.data.INCCODE,	[ 'A50', 'A60', 'A90', 'C61', 'C62', 'C63'
																		, 'C64', 'C65', 'C66', 'C67', 'C68'])){
								return true;
							} else {
								return false;
							}
						}
					}/* else if (gsrsPayYM == 201107) {
						alert('201107');
						
					} else if (gsrsPayYM == 201104) {
						alert('201104');
						
					} else if (gsrsPayYM == 201007) {
						alert('201007');
						
					} else if (gsrsPayYM == 200907) {
						alert('200907');
						
					} else if (gsrsPayYM < 200907) {
						alert('< 200907');
						
					}*/
				}	        	
			}
		}
    });
    
   /* Master Grid2 정의(Grid Panel)
    * @type 
    */    
    var masterGrid2 = Unilite.createGrid('aha990ukrGrid2', {    	
    	layout		: 'fit',
    	region		: 'south',
        store		: masterStore2,
		minHeight	: 120,
		height		: 120,
//	 	split		: true,
        uniOpt		: {
			useMultipleSorting	: false,		
		    useLiveSearch		: false,		
		    onLoadSelectFirst	: true,			
		    dblClickToEdit		: true,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	
            userToolbar			: false,
		    filter: {				
				useFilter		: false,
				autoCreate		: false
			}	
		},			
		sortableColumns	: false,
		enableColumnHide: false,
        columns		: [
        	{dataIndex: 'SECT_CODE'      			, width: 133, hidden: true},
        	{dataIndex: 'PAY_YYYYMM'     			, width: 133, hidden: true},
        	{text: '전월 미환급 세액의 계산',
          		columns: [
        			{dataIndex: 'LAST_IN_TAX_I'  			, width: 100},
        			{dataIndex: 'BEFORE_IN_TAX_I'			, width: 100},
        			{dataIndex: 'BAL_AMT'        			, width: 100}
        		]
        	},{text: 'D.당월발생 환급세액',
          		columns: [
        			{dataIndex: 'RET_AMT'   				, width: 100},
        			{dataIndex: 'TRUST_AMT'      			, width: 100},
    				{text: '3.그 밖의 환급 세액',
      					columns: [
    						{dataIndex: 'FIN_COMP_AMT'      , width: 100},
    						{dataIndex: 'MERGER_AMT'   		, width: 100}
    					]
    				},
    				{text: '3.그 밖의 환급 세액',
      					columns: [
    						{dataIndex: 'ETC_AMT'      		, width: 100}
    					]
    				}
        		]
        	},
        	{dataIndex: 'MERGER_AMT'     			, width: 100, hidden: true},
        	{dataIndex: 'ROW_IN_TAX_I'   			, width: 100},
        	{dataIndex: 'TOTAL_IN_TAX_I' 			, width: 100},
        	{dataIndex: 'NEXT_IN_TAX_I'  			, width: 100},
        	{dataIndex: 'RET_IN_TAX_I'   			, width: 100},
        	{dataIndex: 'STATE_TYPE'     			, width: 100, hidden: true},
        	{dataIndex: 'UPDATE_DATE'    			, width: 100, hidden: true},
        	{dataIndex: 'UPDATE_ID'      			, width: 100, hidden: true},
        	{dataIndex: 'COMP_CODE'      			, width: 100, hidden: true}
		],
		listeners: {
//			sTaxYM
			beforeedit: function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['LAST_IN_TAX_I', 'RET_IN_TAX_I'])){ 
					return true;
  				} else {
  					return false;
  				}
			}
		}          			
    });
    
	Unilite.Main({
		borderItems	: [{
			border	: false,
			region	: 'center',
			layout: 'border',
			items	: [
				masterGrid1, masterGrid2, 
				panelResult,
				{
					region : 'north',
					xtype : 'container',
					highth: 20,
					layout : 'fit',
					items : [ addResult ]
				}
			]	
		},
		panelSearch
		],  
		id : 'aha990ukrApp',
		
		fnInitBinding : function() {
			//초기값 세팅
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
	 		panelSearch.setValue('TAX_YYYYMM', UniDate.get('today'));
	 		panelResult.setValue('TAX_YYYYMM', UniDate.get('today'));
//			var params = {
//				S_COMP_CODE: UserInfo.compCode //panelSearch.getValue('COMP_CODE') //
//				//DUTY_YYYYMMDD: dateChange(panelSearch.getValue('DUTY_YYYYMMDD')),
//				//PERSON_NUMB: records[0].PERSON_NUMB
//			}												
//			aha990ukrService.getOrdNum(params, function(provider, response)	{							
//				if(!Ext.isEmpty(provider)){
//					panelSearch.setValue('ORD_NUM', provider);
//					panelResult.setValue('ORD_NUM', provider);
//				}													
//			});
			var searchParam= Ext.getCmp('searchForm').getValues();
			var param= {
					'S_COMP_CODE' : UserInfo.compCode};	
			var params = Ext.merge(searchParam, param);	 					
			aha990ukrService.getOrdNum(params, function(provider, response)	{							
				if(!Ext.isEmpty(provider)){
                   panelSearch.setValue('ORD_NUM', provider[0].ORD_NUM);
                   panelResult.setValue('ORD_NUM', provider[0].ORD_NUM);
                   panelSearch.setValue('ADD_ORD_NUM', provider[0].ADD_ORD_NUM);
                   panelResult.setValue('ADD_ORD_NUM', provider[0].ADD_ORD_NUM);                   
				}													
			});	 		
	 		
	 		//버튼 세팅
			UniAppManager.setToolbarButtons('detail'	, false);
			UniAppManager.setToolbarButtons('reset'		, false);
			
			
//			if (gsrsPayYM < '201007') {
//				masterGrid2.getColumn('ETC_AMT').setVisible(true);
//				masterGrid2.getColumn('FIN_COMP_AMT').setVisible(false);
//				masterGrid2.getColumn('MERGER_AMT').setVisible(false);
//			} else {
//				masterGrid2.getColumn('ETC_AMT').setVisible(false);
//				masterGrid2.getColumn('FIN_COMP_AMT').setVisible(true);
//				masterGrid2.getColumn('MERGER_AMT').setVisible(true);
//			}
			
			//화면 초기화 시 첫번째 필드에 포커스 가도록 설정
			var activeSForm ;	
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {	
				activeSForm = panelResult;
			}	
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}

			masterStore.loadStoreRecords();
			masterStore2.loadStoreRecords();
		},
		
		onSaveDataButtonDown: function() {
			masterStore.saveStore();
		},
		
		onDeleteAllButtonDown : function() {
			if(confirm(Msg.sMH1353 + "\n" + Msg.sMB064)) {  
				masterGrid1.reset();
				masterGrid2.reset();
           	  	UniAppManager.setToolbarButtons('deleteAll', false);
			}
		},
		
		fnCalc_201602: function(){
			var records		= masterStore.data.items;
			var records2	= masterStore2.data.items[0].data
			var iCnt		= 0;
			var iAmount		= 0;
			var iInTax		= 0;
			var iSpTax		= 0;
			var iAddTax		= 0;
			var iA10Tax		= 0;

//			배열 예시 
//			var myArray = new Array( new Array(3), new Array(3) );
			var arrSepTemp	= new Array(	new Array(10), new Array(10), new Array(10), new Array(10), new Array(10)
										,	new Array(10), new Array(10), new Array(10), new Array(10), new Array(10)
										,	new Array(10), new Array(10), new Array(10), new Array(10), new Array(10) ); 

			for (i=0; i<4; i++){
                if(!Ext.isEmpty(records[i])){
    				iCnt	= iCnt		+ records[i].data.INCOME_CNT;						//인원
    				iAmount	= iAmount	+ records[i].data.INCOME_SUPP_TOTAL_I;				//총지급액
    				iInTax	= iInTax 	+ records[i].data.DEF_IN_TAX_I;						//소득세
    				iSpTax	= iSpTax 	+ records[i].data.DEF_SP_TAX_I;						//농어촌특별세
    				iAddTax	= iAddTax 	+ records[i].data.ADD_TAX_I;						//가산세
                }
			}
			
            if(!Ext.isEmpty(records[0]) && !Ext.isEmpty(records[1]) && 
               !Ext.isEmpty(records[2]) && !Ext.isEmpty(records[5])){
               	//소득세 합계
    			iA10Tax		= records[0].data.DEF_IN_TAX_I + records[1].data.DEF_IN_TAX_I
    						+ records[2].data.DEF_IN_TAX_I + records[5].data.DEF_IN_TAX_I
            }
            if(!Ext.isEmpty(records[6])){
    			records[6].set('INCOME_CNT'				, iCnt);
    			records[6].set('INCOME_SUPP_TOTAL_I'	, iAmount);
    			records[6].set('DEF_IN_TAX_I'			, iA10Tax);
    			records[6].set('DEF_SP_TAX_I'			, iSpTax);
    			records[6].set('ADD_TAX_I'				, iAddTax);
    			records[6].set('SP_TAX_I'				, iSpTax);
            }

			if ( iA10Tax + iAddTax <= 0) {
				if(!Ext.isEmpty(records[6])){
    				records[6].set('IN_TAX_I'			, 0);
    				records[6].set('SP_TAX_I'			, 0);
    				records[6].set('RET_IN_TAX_I'		, 0);
    				records[6].set('RET_AMT'			, 0);
				}

			} else {
				var sBalAmt 
				var sTmpAmt
				sBalAmt = records2.BAL_AMT + records2.RET_AMT;
				
				if(sBalAmt > 0) {
					if (sBalAmt > iA10Tax) {
						sTmpAmt = sBalAmt - iA10Tax
						if (sTmpAmt > iAddTax) {
							sTmpAmt = sTmpAmt - iAddTax
							if (sTmpAmt >= iSpTax) {
								if(!Ext.isEmpty(records[6])){
    								//소득세+농어촌특별세+가산세 합보다 전월미환급액이 더 큰경우 
    								records[6].set('IN_TAX_I'			, 0);
    								records[6].set('SP_TAX_I'			, 0);
    								records[6].set('RET_IN_TAX_I'		, iInTax + iAddTax + iSpTax);
    								records[6].set('RET_AMT'			, 0);
								}
								
							} else {
							    if(!Ext.isEmpty(records[6])){
    								//소득세+가산세 합보다 전월미환급액이 크고 농어촌 특별세보다 적은 경우
    								records[6].set('IN_TAX_I'			, 0);
    								records[6].set('SP_TAX_I'			, iSpTax - (sBalAmt - iA10Tax - iAddTax));
    								records[6].set('RET_IN_TAX_I'		, iA10Tax + iAddTax + (sBalAmt - iA10Tax - iAddTax));
    								records[6].set('RET_AMT'			, 0);
							    }
								
							}
						} else {
						    if(!Ext.isEmpty(records[6])){
    							//소득세보다 전월미환급액이 크고 가산세보다 적은 경우
    							records[6].set('IN_TAX_I'			, iAddTax - (iAddTax-sTmpAmt));
    							records[6].set('RET_IN_TAX_I'		, sBalAmt);
    							records[6].set('RET_AMT'			, 0);
						    }
						}
						
					} else {
						if(!Ext.isEmpty(records[6])){
    						records[6].set('IN_TAX_I'			, iInTax+iAddTax - sBalAmt);
    						records[6].set('RET_IN_TAX_I'		, sBalAmt);
    						records[6].set('RET_AMT'			, 0);
						}
					}
					
				} else {
					if(!Ext.isEmpty(records[6])){
    					records[6].set('IN_TAX_I'			, iA10Tax + iAddTax);
    					records[6].set('RET_IN_TAX_I'		, 0);
    					records[6].set('RET_AMT'			, 0);
					}
				}
			}

			
			//퇴직소득가감계
			iCnt = 0,	iAmount = 0,	iInTax = 0,    iSpTax = 0,    iAddTax = 0;
			for (i = 7; i < 9; i++){
                if(!Ext.isEmpty(records[i])){
    				iCnt    = iCnt		+ records[i].data.INCOME_CNT;
    				iAmount = iAmount	+ records[i].data.INCOME_SUPP_TOTAL_I;
    				iInTax  = iInTax	+ records[i].data.DEF_IN_TAX_I;
    				iSpTax  = iSpTax	+ records[i].data.DEF_SP_TAX_I;
    				iAddTax = iAddTax	+ records[i].data.ADD_TAX_I;
                }
			}
			if(!Ext.isEmpty(records[9])){
    			records[9].set('INCOME_CNT'				, iCnt);
    			records[9].set('INCOME_SUPP_TOTAL_I'		, iAmount);
    			records[9].set('DEF_IN_TAX_I'				, iInTax);
    			records[9].set('DEF_SP_TAX_I'				, iSpTax);
			}

			//사업소득가감계
			iCnt = 0,	iAmount = 0,	iInTax = 0,    iSpTax = 0,    iAddTax = 0;
			for (i = 10; i < 12; i++){
                if(!Ext.isEmpty(records[i])){
    				iCnt    = iCnt		+ records[i].data.INCOME_CNT;
    				iAmount = iAmount	+ records[i].data.INCOME_SUPP_TOTAL_I;
    				iInTax  = iInTax	+ records[i].data.DEF_IN_TAX_I;
    				iSpTax  = iSpTax	+ records[i].data.DEF_SP_TAX_I;
    				iAddTax = iAddTax	+ records[i].data.ADD_TAX_I;
                }
			}
			if(!Ext.isEmpty(records[12])){
    			records[12].set('INCOME_CNT'			, iCnt);
    			records[12].set('INCOME_SUPP_TOTAL_I'	, iAmount);
    			records[12].set('DEF_IN_TAX_I'			, iInTax);
    			records[12].set('DEF_SP_TAX_I'			, iSpTax);
    			records[12].set('ADD_TAX_I'				, iAddTax);
			}

			//UNILITE상(12~18)
			iCnt = 0,	iAmount = 0,	iInTax = 0,    iSpTax = 0,    iAddTax = 0,		iSpTax_j = 0;
			//'iSpTax_j 조정환급이 발생할 경우 징수세액의 농어촌 특별세와 납부세액의 농어촌특별세가 다를수 있다.
			
			if(!Ext.isEmpty(records[6]) && !Ext.isEmpty(records[9]) && !Ext.isEmpty(records[12])){
    			//근로소득 가감계 + 퇴직소득 가감계 + 사업소득 가감계
    			iCnt    = records[6].data.INCOME_CNT          + records[9].data.INCOME_CNT          + records[12].data.INCOME_CNT;
    			iAmount = records[6].data.INCOME_SUPP_TOTAL_I + records[9].data.INCOME_SUPP_TOTAL_I + records[12].data.INCOME_SUPP_TOTAL_I;
			
    			if (records[6].data.DEF_IN_TAX_I > 0) {
    				iInTax = records[6].data.DEF_IN_TAX_I + records[9].data.DEF_IN_TAX_I + records[12].data.DEF_IN_TAX_I;
    			} else {
    				iInTax = records[9].data.DEF_IN_TAX_I + records[12].data.DEF_IN_TAX_I;
    			}
			
    			iSpTax		= records[6].data.DEF_SP_TAX_I + records[9].data.DEF_SP_TAX_I + records[9].data.DEF_SP_TAX_I;
    			iAddTax		= records[6].data.ADD_TAX_I    + records[9].data.ADD_TAX_I    + records[9].data.ADD_TAX_I;
    			
    			iSpTax_j	=  records[9].data.SP_TAX_I;
			}
			
			arrSepTemp[1][4] = iSpTax_j;

			
			//기타소득가감계
			iCnt = 0,	iAmount = 0,	iInTax = 0,    iSpTax = 0,    iAddTax = 0;
			for (i = 13; i < 15; i++){
				if(!Ext.isEmpty(records[i])){
    				iCnt    = iCnt + records[i].data.INCOME_CNT;
    				iAmount = iAmount + records[i].data.INCOME_SUPP_TOTAL_I;
    				iInTax  = iInTax  + records[i].data.DEF_IN_TAX_I;
    				iSpTax  = iSpTax  + records[i].data.DEF_SP_TAX_I;
    				iAddTax = iAddTax + records[i].data.ADD_TAX_I;
				}
			}
            if(!Ext.isEmpty(records[15])){
    			records[15].set('INCOME_CNT'				, iCnt);
    			records[15].set('INCOME_SUPP_TOTAL_I'		, iAmount);
    			records[15].set('DEF_IN_TAX_I'			, iInTax);
    			records[15].set('DEF_SP_TAX_I'			, iSpTax);
    			records[15].set('ADD_TAX_I'				, iAddTax);
            }
            
            
			//연간소득가감계
			iCnt_yon = 0,	iAmount_yon = 0,	iInTax_yon = 0,    iSpTax_yon = 0,    iAddTax_yon = 0;
			for (i = 16; i < 19; i++){
                if(!Ext.isEmpty(records[i])){
    				iCnt_yon    = iCnt_yon + records[i].data.INCOME_CNT;
    				iAmount_yon = iAmount_yon + records[i].data.INCOME_SUPP_TOTAL_I;
    				iInTax_yon  = iInTax_yon  + records[i].data.DEF_IN_TAX_I;
    				iSpTax_yon  = iSpTax_yon  + records[i].data.DEF_SP_TAX_I;
    				iAddTax_yon = iAddTax_yon + records[i].data.ADD_TAX_I;
                }
			}
            if(!Ext.isEmpty(records[19])){
    			records[19].set('INCOME_CNT'			, iCnt_yon);
    			records[19].set('INCOME_SUPP_TOTAL_I'	, iAmount_yon);
    			records[19].set('DEF_IN_TAX_I'			, iInTax_yon);
    			records[19].set('DEF_SP_TAX_I'			, iSpTax_yon);
    			records[19].set('ADD_TAX_I'				, iAddTax_yon);
    			records[19].set('SP_TAX_I'				, iAmount_yon);
            }

			
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//총합계(A99)
			iCnt = 0,	iAmount = 0,	iInTax = 0,    iSpTax = 0,    iAddTax = 0,	iRetIntax = 0,	iInTaxi = 0,	iSpTax_i = 0;
			for (i = 6; i < 26; i++){
				if (i == 6 || i == 9 || i == 12 || i == 15 || i == 19 || i == 20 || i == 21 || i == 22 || i == 23 || i == 24 || i == 25){
	                if(!Ext.isEmpty(records[i])){
	    				iCnt		= iCnt + records[i].data.INCOME_CNT;
	    				
	    				if (records[i].data.INCOME_SUPP_TOTAL_I > 0) {
	    					iAmount		= iAmount + records[i].data.INCOME_SUPP_TOTAL_I;
	    				}
	    				
	    				iInTax  = iInTax  +  records[i].data.DEF_IN_TAX_I;
	    				
	    				if (records[i].data.DEF_SP_TAX_I > 0) {
	    					iSpTax		= iSpTax + records[i].data.DEF_SP_TAX_I;
	    				}
	    				if (records[i].data.SP_TAX_I > 0) {
	    					iSpTax_i	= iSpTax_i + records[i].data.SP_TAX_I;
	    				}
	    				if (records[i].data.ADD_TAX_I > 0) {
	    					iAddTax		= iAddTax + records[i].data.ADD_TAX_I;
	    				}
	    				if (records[i].data.RET_IN_TAX_I > 0) {
	    					iRetIntax	= iRetIntax + records[i].data.RET_IN_TAX_I;
	    				}
	    				records[i].set('IN_TAX_I'			, records[i].data.DEF_IN_TAX_I + records[i].data.ADD_TAX_I - records[i].data.RET_IN_TAX_I);
	    //				    records[i].data.IN_TAX_I	= records[i].data.DEF_IN_TAX_I + records[i].data.ADD_TAX_I - records[i].data.RET_IN_TAX_I; 
	    
	    			    if (records[i].data.IN_TAX_I < 0) {
	    			        records[i].set('IN_TAX_I',	0);
	    			    }
	                }
    				iInTaxi  = iInTaxi  +  records[i].data.IN_TAX_I;
				}
			}
            if(!Ext.isEmpty(records[26])){
    			records[26].set('INCOME_CNT'			, iCnt);     
    			records[26].set('INCOME_SUPP_TOTAL_I'	, iAmount);  
    			records[26].set('DEF_IN_TAX_I'			, iInTax);   
    			records[26].set('DEF_SP_TAX_I'			, iSpTax);   
    			records[26].set('ADD_TAX_I'				, iAddTax);  
    			records[26].set('RET_IN_TAX_I'			, iRetIntax);
    			records[26].set('IN_TAX_I'				, iInTaxi);  
    			records[26].set('SP_TAX_I'				, iSpTax_i); 
            }

			//급여가감계 납부세액/농특세 2006-02-24
			var arrSepTemp	= new Array(	new Array(10), new Array(10), new Array(10), new Array(10), new Array(10)
										,	new Array(10), new Array(10), new Array(10), new Array(10), new Array(10)
										,	new Array(10), new Array(10), new Array(10), new Array(10), new Array(10) );
										
            if(!Ext.isEmpty(records[6])){
    			if (records[6].data.DEF_IN_TAX_I > 0) {
    				arrSepTemp[1][2] = records[6].data.DEF_IN_TAX_I + records[6].data.ADD_TAX_I;
    				arrSepTemp[1][3] = records[6].data.DEF_SP_TAX_I;
    			} else if (records[4].data.DEF_IN_TAX_I < 0) { 
    				arrSepTemp[1][2] = records[6].data.ADD_TAX_I;
    				arrSepTemp[1][3] = records[6].data.DEF_SP_TAX_I;
    			}
            }
            if(!Ext.isEmpty(records[9])){
    			//퇴직소득   납부세액/농특세
    			arrSepTemp[2][2] = records[9].data.DEF_IN_TAX_I + records[9].data.ADD_TAX_I;
    			arrSepTemp[2][3] = records[9].data.DEF_SP_TAX_I;
            }
            if(!Ext.isEmpty(records[12])){
    			//사업소득가감계 납부세액/농특세0
    			arrSepTemp[3][2] = records[12].data.DEF_IN_TAX_I + records[12].data.ADD_TAX_I;
    			arrSepTemp[3][3] = records[12].data.DEF_SP_TAX_I;
            }
            
            if(!Ext.isEmpty(records[15])){
    			//기타소득 납부세액/농특세0
    			arrSepTemp[4][2] = records[15].data.DEF_IN_TAX_I + records[15].data.ADD_TAX_I;
    			arrSepTemp[4][3] = records[15].data.DEF_SP_TAX_I;
            }
            
            if(!Ext.isEmpty(records[19])){
    			//연금소득
    			if (records[17].data.DEF_IN_TAX_I >= 0) {
    				arrSepTemp[5][2] = records[19].data.DEF_IN_TAX_I + records[19].data.ADD_TAX_I;
    				arrSepTemp[5][3] = records[19].data.DEF_SP_TAX_I;
    			} else if (records[4].data.DEF_IN_TAX_I < 0) {
    				arrSepTemp[5][2] = records[19].data.ADD_TAX_I;
    				arrSepTemp[5][3] = records[19].data.DEF_SP_TAX_I;
    			}
            }
            
            if(!Ext.isEmpty(records[20]) && !Ext.isEmpty(records[2])){
    			//이자소득 납부세액/농특세
    			arrSepTemp[6][2] = records[20].data.DEF_IN_TAX_I + records[2].data.ADD_TAX_I;
    			arrSepTemp[6][3] = records[20].data.DEF_SP_TAX_I;
            }
            if(!Ext.isEmpty(records[21])){
    			//배당소득 납부세액/농특세
    			arrSepTemp[7][2] = records[21].data.DEF_IN_TAX_I + records[21].data.ADD_TAX_I;
    			arrSepTemp[7][3] = records[21].data.DEF_SP_TAX_I;
            }
			if(!Ext.isEmpty(records[22])){
    			//저축해지추징세액  납부세액/농특세
    			arrSepTemp[8][2] = records[22].data.DEF_IN_TAX_I + records[22].data.ADD_TAX_I;
    			arrSepTemp[8][3] = records[22].data.DEF_SP_TAX_I;
			}
			if(!Ext.isEmpty(records[24])){
    			//법인원천  납부세액/농특세
    			arrSepTemp[9][2] = records[24].data.DEF_IN_TAX_I + records[24].data.ADD_TAX_I;
    			arrSepTemp[9][3] = records[24].data.DEF_SP_TAX_I;
            }
			//수정신고(세액)/농특세 
	 		var sDef_in_tax;
	 		var sAdd_Tax;
	 		var sDef_sp_tax;
            if(!Ext.isEmpty(records[25])){
    	 		sDef_in_tax	= records[25].data.DEF_IN_TAX_I;
    	 		sAdd_Tax	= records[25].data.ADD_TAX_I;
    	 		sDef_sp_tax	= records[25].data.DEF_SP_TAX_I;
            }
	 		if (sDef_in_tax > 0) {
	 			if (sAdd_Tax > 0) {
					arrSepTemp[10][2] =  sDef_in_tax + sAdd_Tax;
	 			} else {
					arrSepTemp[10][2] =  sDef_in_tax;
	 			}
	 		} else {
	 			if (sDef_in_tax + sAdd_Tax > 0) {
					arrSepTemp[10][2] =  sAdd_Tax;
	 			} else {
					arrSepTemp[10][2] =  0;
	 			}
	 		} 

 			if (sDef_sp_tax > 0) {
				arrSepTemp[10][3] =  sDef_sp_tax;
 			} else {
				arrSepTemp[10][3] =  0;
 			}
			//여기
 			if (sDef_in_tax < 0) {
				masterStore2.data.items[0].set('RET_AMT', records2.RET_AMT + (sDef_in_tax * (-1)));
//				records2.RET_AMT = records2.RET_AMT + (sDef_in_tax * (-1));
 			}
/*			위에 구현(나중에 확인)			
			If sDef_in_tax < 0 Then
				grdSheet2.TextMatrix(3,grdSheet2.ColIndex("RET_AMT"))  = fnCdbl(grdSheet2.TextMatrix(3,grdSheet2.ColIndex("RET_AMT"))) + (sDef_in_tax*-1)
			End If*/

 			if (sAdd_Tax < 0) {
				masterStore2.data.items[0].set('RET_AMT',  records2.RET_AMT + (sAdd_Tax * (-1)));
//				records2.RET_AMT = records2.RET_AMT + (sAdd_Tax * (-1));
 			}
/*			위에 구현(나중에 확인)	
			If sAdd_Tax < 0 Then
				grdSheet2.TextMatrix(3,grdSheet2.ColIndex("RET_AMT"))  = fnCdbl(grdSheet2.TextMatrix(3,grdSheet2.ColIndex("RET_AMT"))) + (sAdd_Tax*-1)
			End If*/

 			if (sDef_sp_tax < 0) {
				masterStore2.data.items[0].set('RET_AMT',  records2.RET_AMT + (sDef_sp_tax * (-1)));
//				records2.RET_AMT = records2.RET_AMT + (sDef_sp_tax * (-1));
 			}
/*			위에 구현(나중에 확인)
 			If sDef_sp_tax < 0 Then
				grdSheet2.TextMatrix(3,grdSheet2.ColIndex("RET_AMT"))  = fnCdbl(grdSheet2.TextMatrix(3,grdSheet2.ColIndex("RET_AMT"))) + (sDef_sp_tax*-1) 
			End If */

 			if(!Ext.isEmpty(records[23])){
    			if (records[23].data.DEF_SP_TAX_I > 0) {
    				arrSepTemp[10][4] = records[23].data.DEF_SP_TAX_I;
    			} else {
    				arrSepTemp[10][4] = 0;
    			}
           }
			//조정합계
			arrSepTemp[11][2] = arrSepTemp[1][2] + arrSepTemp[2][2] + arrSepTemp[3][2] + arrSepTemp[4][2] + arrSepTemp[5][2] + arrSepTemp[6][2] + arrSepTemp[7][2] + arrSepTemp[8][2] + arrSepTemp[9][2] + arrSepTemp[10][2];
    		arrSepTemp[11][3] = arrSepTemp[1][3] + arrSepTemp[2][3] + arrSepTemp[3][3] + arrSepTemp[4][3] + arrSepTemp[5][3] + arrSepTemp[6][3] + arrSepTemp[7][3] + arrSepTemp[8][3] + arrSepTemp[9][3] + arrSepTemp[10][3];
    		arrSepTemp[11][4] = arrSepTemp[1][4] + arrSepTemp[6][4] + arrSepTemp[7][4] + arrSepTemp[8][4] + arrSepTemp[9][4] + arrSepTemp[10][4];
    		
    		var ll;
    		var ll_temp_last;
    		var ll_Total_intax;
    		var ll_Row_intax;

			//당월조정환급세액 구하기
			ll_temp_last = records2.BAL_AMT +  records2.RET_AMT;

			//2006-02-26 arrSepTemp(ll, 4) 당월조정환급세액 발생시 농어촌 특별세 처리
			if (ll_temp_last > 0) {
         		arrSepTemp[11][1] = 0,  arrSepTemp[11][2] = 0,    arrSepTemp[11][3] = 0,    arrSepTemp[11][4] = 0
				for (ll = 1; ll < 11; ll++) {
					if (ll_temp_last >= arrSepTemp[ll][2] + arrSepTemp[ll][3]) {
						arrSepTemp[ll][1] = arrSepTemp[ll][2] + arrSepTemp[ll][3];
						arrSepTemp[ll][2] = 0;
						arrSepTemp[ll][3] = 0;
						arrSepTemp[ll][4] = 0;
					} else {
						arrSepTemp[ll][1] = ll_temp_last;
						if (arrSepTemp[ll][2] - ll_temp_last > 0) {
							arrSepTemp[ll][2] = arrSepTemp[ll][2] - ll_temp_last;
							if (arrSepTemp[ll][3] - ll_temp_last > 0) {
								 ll_temp_last = ll_temp_last - arrSepTemp[ll][1];
								 if (ll_temp_last > 0) {
								 	arrSepTemp[ll][4] = arrSepTemp[ll][3] - ll_temp_last; 
								 } else {
								 	arrSepTemp[ll][4] = arrSepTemp[ll][3];
								 }
							} else {
								arrSepTemp[ll][4] = 0;
							}
						} else {
							arrSepTemp[ll][2] = 0;
							if (arrSepTemp[ll][3] - ll_temp_last > 0) {
								arrSepTemp[ll][4] = arrSepTemp[ll][3] - ll_temp_last 
							} else {
								arrSepTemp[ll][4] = 0;
							}
						}
					}
            		ll_temp_last = ll_temp_last - arrSepTemp[ll][1];
					arrSepTemp[11][1] = arrSepTemp[11][1] + arrSepTemp[ll][1];
					arrSepTemp[11][2] = arrSepTemp[11][2] + arrSepTemp[ll][2];
					arrSepTemp[11][3] = arrSepTemp[11][3] + arrSepTemp[ll][3];
					arrSepTemp[11][4] = arrSepTemp[11][4] + arrSepTemp[ll][4];
				}
				
				//당월조정환급세액계
				ll_Total_intax = arrSepTemp[11][1];
			} else {
				if (arrSepTemp[1][2] > 0) {
					ll_Total_intax = 0;
				} else {
         			arrSepTemp[11][1] = 0,  arrSepTemp[11][2] = 0,    arrSepTemp[11][3] = 0,    arrSepTemp[11][4] = 0
					ll_temp_last = records[6].data.DEF_IN_TAX_I;
					for (ll = 2; ll < 11; ll++) {
						if (ll_temp_last <= arrSepTemp[ll][2] + arrSepTemp[ll][3]) {
							arrSepTemp[ll][1] = arrSepTemp[ll][2] + arrSepTemp[ll][3];
							arrSepTemp[ll][2] = 0;
							arrSepTemp[ll][3] = 0;
							arrSepTemp[ll][4] = 0;
						}
						ll_temp_last = ll_temp_last - arrSepTemp[ll][1];
						arrSepTemp[11][1] = arrSepTemp[11][1] + arrSepTemp[ll][1]; 
						arrSepTemp[11][2] = arrSepTemp[11][2] + arrSepTemp[ll][2]; 
						arrSepTemp[11][3] = arrSepTemp[11][3] + arrSepTemp[ll][3]; 
						arrSepTemp[11][4] = arrSepTemp[11][4] + arrSepTemp[ll][4]; 

					}
					//당월조정환급세액계
					ll_Total_intax = arrSepTemp[11][1];
				}
			}
			if(!Ext.isEmpty(records[9])){
			//퇴직소득   납부세액/농특세
    			records[9].set('RET_IN_TAX_I', arrSepTemp[2][1]);
    			
    			if (Ext.isEmpty(records[9].data.RET_IN_TAX_I)) {
    				records[9].set('RET_IN_TAX_I', 0);
    			}
    			records[9].set('IN_TAX_I'	, arrSepTemp[2][2]);
    			records[9].set('SP_TAX_I'	, arrSepTemp[2][3]);
			}
			if(!Ext.isEmpty(records[12])){
    			//사업소득가감계 납부세액/농특세0
    			records[12].set('RET_IN_TAX_I', arrSepTemp[3][1]);
    			if (Ext.isEmpty(records[12].data.RET_IN_TAX_I)) {
    				records[12].set('RET_IN_TAX_I'	, 0);
    			}
    			records[12].set('IN_TAX_I'	, arrSepTemp[3][2]);
    			records[12].set('SP_TAX_I'	, arrSepTemp[3][3]);
			}
			if(!Ext.isEmpty(records[15])){
    			//기타소득 납부세액/농특세0
    			records[15].set('RET_IN_TAX_I', arrSepTemp[4][1]);
    			if (Ext.isEmpty(records[15].data.RET_IN_TAX_I)) {
    				records[15].set('RET_IN_TAX_I'	, 0);
    			}
    			records[15].set('IN_TAX_I'	, arrSepTemp[4][2]);
    			records[15].set('SP_TAX_I'	, arrSepTemp[4][3]);
			}
			if(!Ext.isEmpty(records[19])){
        		//연금소득
    			records[19].set('RET_IN_TAX_I', arrSepTemp[5][1]);
    			if (Ext.isEmpty(records[19].data.RET_IN_TAX_I)) {
    				records[19].set('RET_IN_TAX_I'	, 0);
    			}
    			records[19].set('IN_TAX_I'	, arrSepTemp[5][2]);
    			records[19].set('SP_TAX_I'	, arrSepTemp[5][3]);
			}
			if(!Ext.isEmpty(records[20])){
        		//이자소득 납부세액/농특세
    			records[20].set('RET_IN_TAX_I', arrSepTemp[6][1]);
    			if (Ext.isEmpty(records[20].data.RET_IN_TAX_I)) {
    				records[20].set('RET_IN_TAX_I'	, 0);
    			}
    			records[20].set('IN_TAX_I'	, arrSepTemp[6][2]);
    			records[20].set('SP_TAX_I'	, arrSepTemp[6][3]);
			}
			if(!Ext.isEmpty(records[21])){
        		//배당소득 납부세액/농특세
    			records[21].set('RET_IN_TAX_I'	, arrSepTemp[7][1]);
    			if (Ext.isEmpty(records[21].data.RET_IN_TAX_I)) {
    				records[21].set('RET_IN_TAX_I'	, 0);
    			}
    			records[21].set('IN_TAX_I'	, arrSepTemp[7][2]);
    			records[21].set('SP_TAX_I'	, arrSepTemp[7][3]);
			}
			if(!Ext.isEmpty(records[22])){
        		//저축해지추징세액  납부세액/농특세
    			records[22].set('RET_IN_TAX_I'	, arrSepTemp[8][1]);
    			if (Ext.isEmpty(records[22].data.RET_IN_TAX_I)) {
    				records[22].set('RET_IN_TAX_I'	, 0);
    			}
    			records[22].set('IN_TAX_I'	, arrSepTemp[8][2]);
    			records[22].set('SP_TAX_I'	, arrSepTemp[8][3]);
			}
			if(!Ext.isEmpty(records[24])){
        		//법인원천  납부세액/농특세
    			records[24].set('RET_IN_TAX_I'	, arrSepTemp[9][1]);
    			if (Ext.isEmpty(records[24].data.RET_IN_TAX_I)) {
    				records[24].set('RET_IN_TAX_I'	, 0);
    			}
    			records[24].set('IN_TAX_I'	, arrSepTemp[9][2]);
    			records[24].set('SP_TAX_I'	, arrSepTemp[9][3]);
			}
			if(!Ext.isEmpty(records[25])){
        		//수정신고(세액)/농특세
    			records[25].set('RET_IN_TAX_I'	, arrSepTemp[10][1]);
    			if (Ext.isEmpty(records[25].data.RET_IN_TAX_I)) {
    				records[25].set('RET_IN_TAX_I'	, 0);
    			}
    			records[25].set('IN_TAX_I'	, arrSepTemp[10][2]);
    			records[25].set('SP_TAX_I'	, arrSepTemp[10][4]);
			}
			if(!Ext.isEmpty(records[26])){
        		//총계(소득세등/농특세)
    			records[26].set('RET_IN_TAX_I'	, arrSepTemp[11][1]);
    			if (Ext.isEmpty(records[26].data.RET_IN_TAX_I)) {
    				records[26].set('RET_IN_TAX_I'	, 0);
    			}
    			records[26].set('IN_TAX_I'	, arrSepTemp[11][2]);
    			records[26].set('SP_TAX_I'	, arrSepTemp[11][4]);
			}
			var iiC61;
			var iiC62;
			var iiC63;
			var iiC64;
			var iiC65;
			var iiC66;
			var iiC67;
			var iiC68;
			var iiC70;
			var iA801;
			var iA802;
			
			iiC61 = 0;
			iiC62 = 0;
			iiC63 = 0;
			iiC70 = 0;
    
    		//부표의 C30 
			if (records.length > 27) {
				if(!Ext.isEmpty(records[65])){
    				records[65].data.RET_IN_TAX_I	= arrSepTemp[7][1] + arrSepTemp[6][1];
    				if (Ext.isEmpty(records[65].data.RET_IN_TAX_I)) {
    					records[65].set('RET_IN_TAX_I'	, 0);
    				}
    				records[65].set('RET_IN_TAX_I'	, arrSepTemp[7][2] + arrSepTemp[6][2]);
    				records[65].set('SP_TAX_I'		, arrSepTemp[7][3] + arrSepTemp[6][3]);
				}
				if(!Ext.isEmpty(records[24])){
    				//A90 내.외국인법인원천의 금액 부표 반영
    				iA801 = records[24].data.RET_IN_TAX_I;		// 6. 당월조정환급세액
    				iA802 = records[24].data.IN_TAX_I;			// 7. 소득세등(가산세포함)
				}
				if (iA801 != 0) {							// 6. 당월조정환급세액 이 0 이 아니면 작업
					for (ll = 82; ll < 96; ll++) {
						if(!Ext.isEmpty(records[ll])){
    						if (records[ll].data.IN_TAX_I != 0) {
    							if (iA801 > records[ll].data.IN_TAX_I) {
    								iiC61 = records[ll].data.IN_TAX_I;
    								iA801 = iA801 - iiC61;
    								iiC70 = iiC70 + iiC61;
    								
    								records[ll].set('IN_TAX_I'		, 0);
    								records[ll].set('RET_IN_TAX_I'	, iiC61);
    								iiC62 							= 0;								
    							} else {
    								iiC61 = records[ll].data.IN_TAX_I - iA801;
    								iiC62 = iiC61;
    								iiC70 = iiC70 + iA801;
    								
    								records[ll].set('IN_TAX_I'		, iiC61);
    								records[ll].set('RET_IN_TAX_I'	, iA801);
    								iA801 							= 0;
    							}
    						}
    						
    						if (records[ll].data.IN_TAX_I == 0 && records[ll].data.RET_IN_TAX_I != 0) {
    							iiC70 = iiC70 + records[ll].data.RET_IN_TAX_I;
    						}
						}
					}
					if(!Ext.isEmpty(records[96])){
    					records[96].set('IN_TAX_I'		, iiC62);
    					records[96].set('RET_IN_TAX_I'	, iiC70);
					}
					iiC63 = iiC63 + iiC70;
				}
			}

    		//당월조정환급세액
			masterStore2.data.items[0].set('TOTAL_IN_TAX_I',  ll_Total_intax);
			
    		//조정환급대상
			var dblBefTaxI;
			var dblCurrTaxI;
			
			dblBefTaxI	= records2.ROW_IN_TAX_I;
			dblCurrTaxI	= records2.BAL_AMT + records2.RET_AMT + records2.TRUST_AMT + records2.ETC_AMT + records2.FIN_COMP_AMT + records2.MERGER_AMT;
			masterStore2.data.items[0].set('ROW_IN_TAX_I',  records2.BAL_AMT + records2.RET_AMT + records2.TRUST_AMT + records2.ETC_AMT + records2.FIN_COMP_AMT + records2.MERGER_AMT);

			if (dblBefTaxI != dblCurrTaxI) {
				UniAppManager.app.fnCalc_201602();
			}
			
			//차월이월환급세액
			masterStore2.data.items[0].set('NEXT_IN_TAX_I',  records2.ROW_IN_TAX_I - records2.TOTAL_IN_TAX_I);
		},
		
		
		
		
		
		
		
		
		
		
		//2016년2월부터 시행되는 원칭징수이행상황신고서
		fnBuCalc201602: function(){
			var records		= masterStore.data.items;
			var iCnt;
			var iAmount;
			var iInTax;
			var iSpTax;
			var iAddTax;
			var iSpTax_j;
			var iRetIntax;
			var iInTaxi;
			var iSpTax_i;
			
			//거주자
			//이자.배당소득 계(C01~C26)
			iCnt = 0;	iAmount = 0;	iInTax = 0;    iSpTax = 0;    iAddTax = 0;  iRetIntax = 0;   iInTaxi = 0;   iSpTax_i = 0;
			
			for (i = 27; i < 65; i++) {
				if(!Ext.isEmpty(records[i])){
    				iCnt    = iCnt		+ records[i].data.INCOME_CNT;
    				iAmount = iAmount	+ records[i].data.INCOME_SUPP_TOTAL_I;
    				iInTax  = iInTax	+ records[i].data.DEF_IN_TAX_I;
    				iSpTax  = iSpTax	+ records[i].data.DEF_SP_TAX_I;
    				iAddTax = iAddTax	+ records[i].data.ADD_TAX_I;
				}
			}
			if(!Ext.isEmpty(records[65]) && !Ext.isEmpty(records[67])){
    			//합계액을 이자.배당소득 계(C30)에 입력  
    			records[65].set('INCOME_CNT'				, iCnt);                                   
    			records[65].set('INCOME_SUPP_TOTAL_I'		, iAmount);                                
    			records[65].set('DEF_IN_TAX_I'				, iInTax);                                 
    			records[65].set('DEF_SP_TAX_I'				, iSpTax);                                 
    			records[65].set('ADD_TAX_I'					, iAddTax);	                              
    			records[65].set('IN_TAX_I'					, iInTax - records[67].data.RET_IN_TAX_I); 
			}
			//해지추징계(C41~C45)
			iCnt = 0;	iAmount = 0;	iInTax = 0;    iSpTax = 0;    iAddTax = 0;
			for (i = 66; i < 72; i++) {
                if(!Ext.isEmpty(records[i])){
    				iCnt    = iCnt		+ records[i].data.INCOME_CNT;
    				iAmount = iAmount	+ records[i].data.INCOME_SUPP_TOTAL_I;
    				iInTax  = iInTax	+ records[i].data.DEF_IN_TAX_I;
    				iSpTax  = iSpTax	+ records[i].data.DEF_SP_TAX_I;
    				iAddTax = iAddTax	+ records[i].data.ADD_TAX_I;
                }
			}
			
            if(!Ext.isEmpty(records[72])){
    			//합계액을 해지추징세액 계(C50)에 입력
    			records[72].set('INCOME_CNT'				, iCnt);                                   
    			records[72].set('INCOME_SUPP_TOTAL_I'		, iAmount);                                
    			records[72].set('DEF_IN_TAX_I'			, iInTax);                                 
    			records[72].set('DEF_SP_TAX_I'			, iSpTax);                                 
    			records[72].set('ADD_TAX_I'				, iAddTax);	                              
            }
            
            if(!Ext.isEmpty(records[22])){
    			//(C50)의 금액을 저축해지 추징세액(A69)에 입력
    			records[22].set('INCOME_CNT'				, iCnt);                                   
    			records[22].set('INCOME_SUPP_TOTAL_I'		, iAmount);                                
    			records[22].set('DEF_IN_TAX_I'			, iInTax);                                 
    			records[22].set('DEF_SP_TAX_I'			, iSpTax);                                 
            }
	  		///////////////////////////////////////////////////////////////////////////////////////////
			//비거주자(C61~C68) 
			iCnt = 0;	iAmount = 0;	iInTax = 0;    iSpTax = 0;    iAddTax = 0;  iRetIntax = 0;   iInTaxi = 0;   iSpTax_i = 0;
			for (i = 73; i < 81; i++) {
				
                if(!Ext.isEmpty(records[i])){
    				iCnt						= iCnt		+ records[i].data.INCOME_CNT;
    				iAmount						= iAmount	+ records[i].data.INCOME_SUPP_TOTAL_I;
    				iInTax						= iInTax	+ records[i].data.DEF_IN_TAX_I;
    				iSpTax						= iSpTax	+ records[i].data.DEF_SP_TAX_I;
    				iSpTax_i					= iSpTax_i	+ records[i].data.SP_TAX_I;
    				iAddTax						= iAddTax	+ records[i].data.ADD_TAX_I;
    				iRetIntax					= iRetIntax	+ records[i].data.RET_IN_TAX_I;
    //				records[i].data.IN_TAX_I	= records[i].data.DEF_IN_TAX_I	+ records[i].data.ADD_TAX_I;
    				records[i].set('IN_TAX_I'	, records[i].data.DEF_IN_TAX_I	+ records[i].data.ADD_TAX_I);                                 
    				iInTaxi						= iInTaxi	+ records[i].data.IN_TAX_I;
                }
			}
			
            if(!Ext.isEmpty(records[81])){
    			//합계액을 비거주자 계(C70)에 입력    
    			records[81].set('INCOME_CNT'				, iCnt);                                   
    			records[81].set('INCOME_SUPP_TOTAL_I'		, iAmount);                                
    			records[81].set('DEF_IN_TAX_I'			, iInTax);                                 
    			records[81].set('DEF_SP_TAX_I'			, iSpTax);                                 
    			records[81].set('ADD_TAX_I'				, iAddTax);                                   
    			records[81].set('RET_IN_TAX_I'			, iRetIntax);                                
    			records[81].set('IN_TAX_I'				, iInTaxi);                                 
    			records[81].set('SP_TAX_I'				, iSpTax_i);                                 
            }
            if(!Ext.isEmpty(records[23]) && !Ext.isEmpty(records[78]) && !Ext.isEmpty(records[79])){
    			//비거주자 양도소득
    			//(C66 + C67)의 합계액을 양도소득(A70)에 입력
    			records[23].set('INCOME_CNT'				, records[78].data.INCOME_CNT			+ records[79].data.INCOME_CNT);                                      
    			records[23].set('INCOME_SUPP_TOTAL_I'		, records[78].data.INCOME_SUPP_TOTAL_I	+ records[79].data.INCOME_SUPP_TOTAL_I);                             
    			records[23].set('DEF_IN_TAX_I'			, records[78].data.DEF_IN_TAX_I			+ records[79].data.DEF_IN_TAX_I);                                    
    			records[23].set('ADD_TAX_I'				, records[78].data.ADD_TAX_I			+ records[79].data.ADD_TAX_I);                                       
    			records[23].set('RET_IN_TAX_I'			, records[78].data.RET_IN_TAX_I			+ records[79].data.RET_IN_TAX_I);                                       
    			records[23].set('IN_TAX_I'				, records[78].data.IN_TAX_I				+ records[79].data.IN_TAX_I);                                          
            }
	  		///////////////////////////////////////////////////////////////////////////////////////////
			//법인원천(C71~C88) 
			iCnt = 0;	iAmount = 0;	iInTax = 0;    iSpTax = 0;    iAddTax = 0;  iRetIntax = 0;   iInTaxi = 0;
			for (i = 82; i < 96; i++) {
                if(!Ext.isEmpty(records[i])){
    				iCnt						= iCnt		+ records[i].data.INCOME_CNT;
    				iAmount						= iAmount	+ records[i].data.INCOME_SUPP_TOTAL_I;
    				iInTax						= iInTax	+ records[i].data.DEF_IN_TAX_I;
    				iAddTax						= iAddTax	+ records[i].data.ADD_TAX_I;
    				iRetIntax					= iRetIntax	+ records[i].data.RET_IN_TAX_I;
    				records[i].set('IN_TAX_I', records[i].data.DEF_IN_TAX_I	+ records[i].data.ADD_TAX_I - records[i].data.RET_IN_TAX_I);
    				iInTaxi						= iInTaxi	+ records[i].data.IN_TAX_I;
                }
			}
            if(!Ext.isEmpty(records[96])){   
    			
    			//합계액을 법인세 계(C90)에 입력       
    			records[96].set('INCOME_CNT'				, iCnt);                                   
    			records[96].set('INCOME_SUPP_TOTAL_I'		, iAmount);                                
    			records[96].set('DEF_IN_TAX_I'			, iInTax);                                 
    			records[96].set('ADD_TAX_I'				, iAddTax);                                 
    			records[96].set('RET_IN_TAX_I'			, iRetIntax);                                   
    			records[96].set('IN_TAX_I'				, iInTaxi);                                
            }
            if(!Ext.isEmpty(records[24])){
    			//합계액을 내외국법인원천(A80)에 입력
    			records[24].set('INCOME_CNT'				, iCnt);                                   
    			records[24].set('INCOME_SUPP_TOTAL_I'		, iAmount);                                
    			records[24].set('DEF_IN_TAX_I'			, iInTax);                                 
    			records[24].set('ADD_TAX_I'				, iAddTax);                                 
    			records[24].set('RET_IN_TAX_I'			, iRetIntax);                                   
    			records[24].set('IN_TAX_I'				, iInTaxi);                                
            }
	  		///////////////////////////////////////////////////////////////////////////////////////////
			iCnt = 0;	iAmount = 0;	iInTax = 0;    iSpTax = 0;    iAddTax = 0;  iRetIntax = 0;   iInTaxi = 0;   iSpTax_i = 0;
			for (i = 27; i < 78; i++) {
				//이자소득에 해당하는 코드들
				if (i == 27 || i == 28 || i == 29 || i == 30 || i == 31 || i == 32 || i == 33 || i == 39 || i == 41 ||
					i == 49 || i == 51 || i == 52 || i == 59 || i == 61 || i == 63 || i == 73) {
						
                    if(!Ext.isEmpty(records[i])){
    					iCnt						= iCnt		+ records[i].data.INCOME_CNT;
    					iAmount						= iAmount	+ records[i].data.INCOME_SUPP_TOTAL_I;
    					iInTax						= iInTax	+ records[i].data.DEF_IN_TAX_I;
    				    iSpTax						= iSpTax	+ records[i].data.DEF_SP_TAX_I;
    				    iSpTax_i					= iSpTax_i	+ records[i].data.SP_TAX_I;
    					iAddTax						= iAddTax	+ records[i].data.ADD_TAX_I;
    					iRetIntax					= iRetIntax	+ records[i].data.RET_IN_TAX_I;
                    }
					
					//비거주자 개인이자(제한)
					if (i == 73) {
						
                        if(!Ext.isEmpty(records[i])){
    						records[i].set('IN_TAX_I'		, records[i].data.DEF_IN_TAX_I	+ records[i].data.ADD_TAX_I); 
    						iInTaxi						= iInTaxi	+ (records[i].data.DEF_IN_TAX_I	+ records[i].data.ADD_TAX_I);
                        }
					}
				}
			}
			
            if(!Ext.isEmpty(records[20])){
    			//합계액을 이자소득(A50)에 입력    
    			records[20].set('INCOME_CNT'				, iCnt);                                   
    			records[20].set('INCOME_SUPP_TOTAL_I'		, iAmount);                                
    			records[20].set('DEF_IN_TAX_I'			, iInTax);                                 
    			records[20].set('DEF_SP_TAX_I'			, iSpTax);                                 
    			records[20].set('ADD_TAX_I'				, iAddTax);                                 
    			records[20].set('RET_IN_TAX_I'			, iRetIntax);                                   
    			records[20].set('IN_TAX_I'				, iInTaxi);     
    			records[20].set('SP_TAX_I'				, iSpTax_i);     
            }
	  		///////////////////////////////////////////////////////////////////////////////////////////
			iCnt = 0;	iAmount = 0;	iInTax = 0;    iSpTax = 0;    iAddTax = 0;  iRetIntax = 0;   iInTaxi = 0;   iSpTax_i = 0;
			for (i = 27; i < 78; i++) {
				//배당소득에 해당하는 코드들 
				if (i == 34 || i == 35 || i == 36 || i == 37 || i == 38 || i == 40 || i == 42 || i == 43 || i == 44 || i == 45 || i == 46 || i == 47 ||
					i == 48 || i == 50 || i == 53 || i == 54 || i == 55 || i == 56 || i == 57 || i == 58 || i == 60 || i == 62 || i == 74) {
						
                    if(!Ext.isEmpty(records[i])){
    					iCnt						= iCnt		+ records[i].data.INCOME_CNT;
    					iAmount						= iAmount	+ records[i].data.INCOME_SUPP_TOTAL_I;
    					iInTax						= iInTax	+ records[i].data.DEF_IN_TAX_I;
    				    iSpTax						= iSpTax	+ records[i].data.DEF_SP_TAX_I;
    				    iSpTax_i					= iSpTax_i	+ records[i].data.SP_TAX_I;
    					iAddTax						= iAddTax	+ records[i].data.ADD_TAX_I;
    					iRetIntax					= iRetIntax	+ records[i].data.RET_IN_TAX_I;
                    }
					
					//비거주자 개인배당(제한)
					if (i == 74) {
                        if(!Ext.isEmpty(records[i])){
    						records[i].set('IN_TAX_I'		, records[i].data.DEF_IN_TAX_I	+ records[i].data.ADD_TAX_I); 
    						iInTaxi						= iInTaxi	+ (records[i].data.DEF_IN_TAX_I	+ records[i].data.ADD_TAX_I);
                        }
					}
				}
			}
			
            if(!Ext.isEmpty(records[20])){
    			//합계액을 배당소득(A60)에 입력   
    			records[20].set('INCOME_CNT'				, iCnt);                                   
    			records[20].set('INCOME_SUPP_TOTAL_I'		, iAmount);                                
    			records[20].set('DEF_IN_TAX_I'			, iInTax);                                 
    			records[20].set('DEF_SP_TAX_I'			, iSpTax);                                 
    			records[20].set('ADD_TAX_I'				, iAddTax);                                 
    			records[20].set('RET_IN_TAX_I'			, iRetIntax);                                   
    			records[20].set('IN_TAX_I'				, iInTaxi);     
    			records[20].set('SP_TAX_I'				, iSpTax_i);  
            }
		}
	});
	 
	// 자료생성 팝업을 표시함
	function openCreateCertificateData() {
		if (!createCertificateData) {
			createCertificateData = Ext.create('widget.uniDetailWindow', {
				title	: '원천징수이행상황신고서 당월 자료생성',			
				width	: 600,
				height	: 370,			
				defaultType: 'uniTextfield',
				items	: [{
				   xtype : 'uniDetailFormSimple',
				   layout: {type: 'uniTable', columns: 2},
				   id: 'createDataForm',
				   items : [{
						fieldLabel	: '신고사업장',
						name		: 'DIV_CODE',
						labelWidth	: 200,
						xtype		: 'uniCombobox',
						comboType	: 'BOR120',
						comboCode	: 'BILL',
						allowBlank	: false
					},{
						fieldLabel	: '현재차수'	,
						name		:'NOW_ORD_NUM', 
						labelWidth	: 80,
						width 		: 150,
						fieldStyle  : 'text-align: right;',
						xtype		: 'uniTextfield',
						readOnly	: true
			    	},{
						fieldLabel	: '신고년월',
						labelWidth	: 200,
						xtype		: 'uniMonthfield',
						name		: 'TAX_YYYYMM',                                 
						allowBlank	: false
					},{
						fieldLabel	: '생성차수'	,
						name		:'ADD_ORD_NUM', 
						labelWidth	: 80,
						width 		: 150,
						fieldStyle  : 'text-align: right;',
						xtype		: 'uniTextfield',
						readOnly	: true
			    	},{
						fieldLabel	: '간이세액 신고귀속년월',
						labelWidth	: 200,
			 		    xtype		: 'uniMonthRangefield',
			            startFieldName: 'PAY_INCOM_FR',
			            endFieldName: 'PAY_INCOM_TO',
						value		: new Date(),                    
						allowBlank	: false,
						colspan		: 2
					},{
						fieldLabel	: '중도퇴사 신고귀속년월',
						labelWidth	: 200,
			 		    xtype		: 'uniMonthRangefield',
			            startFieldName: 'HALF_INCOM_FR',
			            endFieldName: 'HALF_INCOM_TO',                 
						value		: new Date(),                    
						allowBlank	: false,
						colspan		: 2
					},{
						fieldLabel	: '일용근로 신고귀속년월',
						labelWidth	: 200,
			 		    xtype		: 'uniMonthRangefield',
			            startFieldName: 'ONE_INCOM_FR',
			            endFieldName: 'ONE_INCOM_TO',                  
						value		: new Date(),                    
						allowBlank	: false,
						colspan		: 2
					},{
						fieldLabel	: '퇴직소득 신고귀속년월',
						labelWidth	: 200,
			 		    xtype		: 'uniMonthRangefield',
			            startFieldName: 'RETR_INCOM_FR',
			            endFieldName: 'RETR_INCOM_TO',                     
						value		: new Date(),                    
						allowBlank	: false,
						colspan		: 2
					},{
						fieldLabel	: '사업소득 신고귀속년월',
						labelWidth	: 200,
			 		    xtype		: 'uniMonthRangefield',
			            startFieldName: 'BUSI_INCOM_FR',
			            endFieldName: 'BUSI_INCOM_TO',                     
						value		: new Date(),                    
						allowBlank	: false,
						colspan		: 2
					},{
						fieldLabel	: '급여 지급년월',
						labelWidth	: 200,
			 		    xtype		: 'uniMonthRangefield',
			            startFieldName: 'SUPP_DATE_FR',
			            endFieldName: 'SUPP_DATE_TO',                     
						value		: new Date(),                    
						allowBlank	: false,
						colspan		: 2
					},{
						fieldLabel	: '퇴직금 지급년월',
						labelWidth	: 200,
			 		    xtype		: 'uniMonthRangefield',
			            startFieldName: 'RETR_SUPP_DATE_FR',
			            endFieldName: 'RETR_SUPP_DATE_TO',                     
						value		: new Date(),                    
						allowBlank	: false,
						colspan		: 2
					},{
		            	fieldLabel	: '통합생성여부',
		            	name		: 'TAX_DIV_CODE',
						xtype		: 'checkbox',
						labelWidth	: 200,
						colspan		: 2,
						boxLabel	: '&nbsp;통합생성',
						value		: 'Y',
						uncheckedValue: 'N'
		    		},{
		            	fieldLabel	: '연말정산포함여부',
		            	name		: 'YEAR_TAX_FLAG',
						value		: 'Y', 
						xtype		: 'checkbox',
						labelWidth	: 200,
						colspan		: 2,
						boxLabel	: '&nbsp;포함'
		    		},{
		            	xtype		: 'container',
		            	layout		: {type: 'table', columns: 2},
		            	defaults	: { xtype: 'button' },
		            	margin		: '0 0 0 200',
						items:[{
							//SP 호출
							text	: '자료생성',
							width	: 100,
							margin	: '0 0 5 10',
							handler	: function(btn) {
								if(Ext.getCmp('createDataForm').getInvalidMessage()){
									if(confirm(Msg.sMB253 + "\n" + Msg.sMB063)) {  								//신고자료를 생성합니다. 실행하시겠습니까?
										var param		= Ext.getCmp('createDataForm').getValues();
										param.PAY_YM	= gsrsPayYM;
	
										createDataStore.load({
											params : param,
											callback : function(records, operation, success) {
												//waitMsg: '자료 생성중입니다...',
												if(success)	{
													if(records[0].data.errorDesc.substring(6) == 'EXIST') {
														if(confirm(Msg.sMH1292 + "\n" + Msg.sMH999)){			//해당 데이터가 있습니다. 재작업하시겠습니까?
															//다시 자료 생성
															aha990ukrService.reCreateData(param, function(provider, response) {
																if(Ext.isEmpty(provider[0].errorDesc)){
																	Ext.Msg.alert("확인","자료를 생성하였습니다.");
																} else {
																	Ext.Msg.alert("확인","자료 생성 중 오류가 발생하였습니다.");
																}
															});
															return true;
														} else {
															return false;
														}
	
													} else {
														Ext.Msg.alert("확인","자료를 생성하였습니다.");
													}
													
												} else {
													Ext.Msg.alert("확인","자료 생성 중 오류가 발생하였습니다.");
												}
											}
										});
									}else{
										return false;	
									}
								}
							}
						},{
							text	: '닫기',
							width	: 100,
							margin	: '0 0 5 10',
							handler	: function(btn) {
								createCertificateData.hide();
							}
						}]
					}]
				}]
			});
		}
		createCertificateData.center();
		createCertificateData.show();
	}

	function openCreateElectronicFilingData() {
		if (!createElectronicFilingData) {
			createElectronicFilingData = Ext.create('widget.uniDetailWindow', {
				title	: '원천징수이행상황신고서 전자신고 자료생성',			
				width	: 350,
				height	: 350,			
				defaultType: 'uniTextfield',
				items	: [{
				   xtype : 'uniDetailFormSimple',
				   layout: {type: 'uniTable', columns: 1},
				   id: 'createDataForm2',
				   items : [{
						fieldLabel	: '신고사업장',
//						id			: 'DIV_CODE',
						name		: 'DIV_CODE',
						xtype		: 'uniCombobox',
						comboType	: 'BOR120',
						comboCode	: 'BILL',
						labelWidth	: 130,
						allowBlank	: false
					},{
						fieldLabel	: '신고구분',
//						id			: 'WORK_TYPE',
						name		: 'WORK_TYPE', 
						xtype		: 'uniCombobox',
						comboType	: 'AU',
						comboCode	: 'H157',
						value		: '1',
						labelWidth	: 130,
						allowBlank	: false
					},{
						fieldLabel	: '신고년월',
//						id			: 'TAX_YYYYMM',
						xtype		: 'uniMonthfield',
						name		: 'HOMETAX_YYYYMM',             
						labelWidth	: 130,                 
						allowBlank	: false
					},{
						fieldLabel	: '귀속년월',
//						id			: 'BELONG_YYYYMM',
						xtype		: 'uniMonthfield',
						name		: 'BELONG_YYYYMM',          
						labelWidth	: 130,               
						allowBlank	: false
					},{
						fieldLabel	: '지급년월',
//						id			: 'SUPP_YYYYMM',
						xtype		: 'uniMonthfield',
						name		: 'SUPP_YYYYMM',              
						labelWidth	: 130,               
						allowBlank	: false
					},{
						fieldLabel	: '급여년월',
//						id			: 'PAY_YYYYMM',
						xtype		: 'uniMonthfield',
						name		: 'PAY_YYYYMM',         
						labelWidth	: 130,                   
						allowBlank	: false
					},{
						fieldLabel	: '작성일자',
//						id			: 'CRT_DATE',
						xtype		: 'uniDatefield',
						name		: 'WORK_DATE',                    
						value		: UniDate.get('today'), 
						labelWidth	: 130,                 
						allowBlank	: false
					},{
						fieldLabel	: '홈텍스ID',
						name		: 'HOMETAX_ID',
						xtype		: 'uniTextfield',
						labelWidth	: 130,
						allowBlank	: false
					},{
						fieldLabel	: '일괄납부여부',
						name		: 'ALL_YN', 
						xtype		: 'uniCombobox',
						comboType	: 'AU',
						comboCode	: 'B010',
						value		: 'N',
						labelWidth	: 130,
						allowBlank	: false
					},{
		            	fieldLabel	: '연말정산포함여부',
		            	name		: 'YEAR_YN',
						value		: 'Y', 
						xtype		: 'checkbox',
						labelWidth	: 130,
						colspan		: 2,
						boxLabel	: '&nbsp;포함'
		    		},{
		            	xtype		: 'container',
		            	layout		: {type: 'table', columns: 2},
		            	defaults	: { xtype: 'button' },
		            	margin		: '0 0 0 60',
						items:[{
							//SP 호출
							text	: '자료생성',
							width	: 100,
							margin	: '0 0 5 0',
							handler	: function(btn) {
								if(Ext.getCmp('createDataForm2').getInvalidMessage()){
									if(confirm(Msg.sMB253 + "\n" + Msg.sMB063)) {
										createElectronicFilingFIle();
									}else{
										return false;	
									}
								}
							}
						},{
							text	: '닫기',
							width	: 100,
							margin	: '0 0 5 10',
							handler	: function(btn) {
								createElectronicFilingData.hide();
							}
						}]
					}]
				}]
			});
		};
		createElectronicFilingData.center();
		createElectronicFilingData.show();
	};
	
	//fileDown submitForm
    var panelExcelDown = Unilite.createForm('ExcelDownForm', {
        url: CPATH+'/accnt/excelDown.do',
        colspan: 2,
        layout: {type: 'uniTable', columns: 1},
        disabled:false,
        autoScroll: false,
        standardSubmit: true,  
        items:[{                
            fieldLabel  : '신고사업장',
            name        : 'DIV_CODE',
            xtype       : 'uniCombobox',
            comboType   : 'BOR120',
            comboCode   : 'BILL',
            labelWidth  : 110,
            allowBlank  : false
        },{
            fieldLabel  : '신고년월',
            xtype       : 'uniMonthfield',
            name        : 'WORK_YYYYMM', 
            labelWidth  : 110,                 
            allowBlank  : false
        },{
            fieldLabel  : '귀속년월',
            xtype       : 'uniMonthfield',
            name        : 'PAY_YYYYMM',  
            labelWidth  : 110,                 
            allowBlank  : false
        },{
            fieldLabel  : '지급년월일',
            xtype       : 'uniDatefield',
            name        : 'SUPP_YYYYMMDD',                    
            value       : new Date(),   
            labelWidth  : 110,                 
            allowBlank  : false
        },{
            fieldLabel  : '작성일자',
            xtype       : 'uniDatefield',
            name        : 'WRITE_YYYYMMDD',                    
            value       : new Date(),  
            labelWidth  : 110,                  
            allowBlank  : false
        },{
            fieldLabel  : '연말정산포함여부',
            name        : 'YEAR_TAX_FLAG',
            inputValue       : 'Y', 
            value       : '',
            xtype       : 'checkbox',
            labelWidth  : 110,
            colspan     : 2,
            boxLabel    : '&nbsp;포함'
        }]
    });
    
	// 신고서 출력
	function openPrintWindow() {
		if (!printWindow) {
			printWindow = Ext.create('widget.uniDetailWindow', {
				title : '원천징수이행상황신고서 당월 자료생성',			
				width : 360,
				height : 230,			
				defaultType: 'uniTextfield',
				items : [{
				   xtype : 'uniDetailFormSimple',
				   id: 'printDataForm',
				   layout: {type: 'uniTable', columns: 1},
				   items : [{				
						fieldLabel	: '신고사업장',
						name		: 'DIV_CODE',
						xtype		: 'uniCombobox',
						comboType	: 'BOR120',
						comboCode	: 'BILL',
						labelWidth	: 110,
						allowBlank	: false
					},{
						fieldLabel	: '신고년월',
						xtype		: 'uniMonthfield',
						name		: 'WORK_YYYYMM', 
						labelWidth	: 110,       
						value     : new Date(),
						allowBlank	: false
					},{
						fieldLabel	: '귀속년월',
						xtype		: 'uniMonthfield',
						name		: 'PAY_YYYYMM',  
						labelWidth	: 110,       
						value     : new Date(),
						allowBlank	: false
					},{
						fieldLabel	: '지급년월일',
						xtype		: 'uniDatefield',
						name		: 'SUPP_YYYYMMDD',                    
						value		: new Date(),   
						labelWidth	: 110,                 
						allowBlank	: false
					},{
						fieldLabel	: '작성일자',
						xtype		: 'uniDatefield',
						name		: 'WRITE_YYYYMMDD',                    
						value		: new Date(),  
						labelWidth	: 110,                  
						allowBlank	: false
					},{
		            	fieldLabel	: '연말정산포함여부',
		            	name		: 'YEAR_TAX_FLAG',
						value		: 'Y', 
						xtype		: 'checkbox',
						labelWidth	: 110,
						colspan		: 2,
						boxLabel	: '&nbsp;포함'
		    		},{
		            	xtype		: 'container',
		            	layout		: {type: 'table', columns: 3},
		            	defaults	: { xtype: 'button' },
						items		: [{
							text	: '자료생성',
							width	: 100,
							margin	: '0 0 5 73',
							handler	: function(btn) {
								var form = Ext.getCmp('printDataForm');
								if(!form.getInvalidMessage()) return;
								var sendForm = panelExcelDown;
								sendForm.setValue('DIV_CODE', form.getValue('DIV_CODE'));
								sendForm.setValue('WORK_YYYYMM', form.getValue('WORK_YYYYMM'));
								sendForm.setValue('PAY_YYYYMM', form.getValue('PAY_YYYYMM'));
								sendForm.setValue('SUPP_YYYYMMDD', form.getValue('SUPP_YYYYMMDD'));
								sendForm.setValue('WRITE_YYYYMMDD', form.getValue('WRITE_YYYYMMDD'));
                                sendForm.setValue('YEAR_TAX_FLAG', form.getValue('YEAR_TAX_FLAG'));
                                var param = sendForm.getValues();
//                                window.open(CPATH+'/accnt/excelDown.do?SERVICE_YEAR='+panelSearch.getValue('SERVICE_YEAR'), "_self");
                                if(Ext.isEmpty('YEAR_TAX_FLAG')){
                                    param.YEAR_TAX_FLAG = '';                                	
                                }
                                aha990ukrService.selectExcelCnt(param, function(provider, response)   {
                                    if(provider[0].CNT != 0){
                                        sendForm.submit({
                                            params: param,
                                            success:function(comp, action)  {
                //                                Ext.getBody().unmask();
                                            },
                                            failure: function(form, action){
                //                                Ext.getBody().unmask();
                                            } 
                                        });  
                                    }else{
                                        alert(Msg.sMB025);  //자료가 존재하지 않습니다.                                        
                                    }
                                });    
                                
//								ahaExcelService.selectList(param, function(provider, response) {
//								});
							}
						}/*,{
							text	: '출력',
							width	: 100,
							margin	: '0 0 5 5',
							handler	: function(btn) {
								// TODO : do something 
							}
						}*/,{
							text	: '닫기',
							width	: 100,
							margin	: '0 0 5 5',
							handler	: function(btn) {
								printWindow.hide();
							}
						}]
					}]
				}]
			});
		}
		printWindow.center();
		printWindow.show();
	}

	function createElectronicFilingFIle() {						
		//var paramForm2= Ext.getCmp('createDataForm2').getValues();		

		var form = panelFileDown;
		form.setValue('DIV_CODE', Ext.getCmp('createDataForm2').getValue('DIV_CODE'));
		form.setValue('WORK_TYPE', Ext.getCmp('createDataForm2').getValue('WORK_TYPE'));
		form.setValue('HOMETAX_YYYYMM', Ext.getCmp('createDataForm2').getValue('HOMETAX_YYYYMM'));
		form.setValue('BELONG_YYYYMM', Ext.getCmp('createDataForm2').getValue('BELONG_YYYYMM'));
		form.setValue('SUPP_YYYYMM', Ext.getCmp('createDataForm2').getValue('SUPP_YYYYMM'));
		form.setValue('PAY_YYYYMM', Ext.getCmp('createDataForm2').getValue('PAY_YYYYMM'));
		form.setValue('WORK_DATE', Ext.getCmp('createDataForm2').getValue('WORK_DATE'));
		form.setValue('HOMETAX_ID', Ext.getCmp('createDataForm2').getValue('HOMETAX_ID'));
		form.setValue('ALL_YN', Ext.getCmp('createDataForm2').getValue('ALL_YN'));
		form.setValue('YEAR_YN', Ext.getCmp('createDataForm2').getValue('YEAR_YN'));
		
		var param = form.getValues();
		Ext.getBody().mask('로딩중...','loading-indicator');
						
		aha990ukrService.checkProcedureExec(param, function(provider, response) {
			if (response.message == 'Server Error'){
				alert(response.where);
			} else {
				if (!Ext.isEmpty(provider)) {                    

					if(provider.RETURN_VALUE == '1'){      
						/*
						Ext.Ajax.on("beforerequest", function(){
							Ext.getBody().mask('로딩중...', 'loading')
					    }, Ext.getBody());
						Ext.Ajax.on("requestcomplete", Ext.getBody().unmask, Ext.getBody());
						Ext.Ajax.on("requestexception", Ext.getBody().unmask, Ext.getBody());
						
						Ext.Ajax.request({
							url     : CPATH+'/accnt/createWithholdingFile.do',
							params: param,
							success: function(response){
			 					console.log("data:::",response.responseText);
			 					//alert(response.responseText);
			 					Ext.Msg.alert('성공', 'omegaplusAccntFile폴더에 원천징수이행상황신고파일을 생성하였습니다.');		
								
							},
							failure: function(response){
								console.log(response);
								Ext.Msg.alert('실패', response.statusText);
							}
						});
						*/
	
						form.submit({
                            params: param,
                            success:function()  {
                                //Ext.getBody().unmask();
                            },
                            failure: function(form, action){
                                //Ext.getBody().unmask();
                            }
                        });
						
					}else {
						Ext.Msg.alert('실패', '원천징수이행상황신고자료생성을 실패하였습니다.');
						//Ext.getBody().unmask();
					}
				}
			}
		});
		
		Ext.getBody().unmask();
		
    }
    
	
	Unilite.createValidator('validator01', {
		store: masterStore,
		grid: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var TempSum;
			var records		= record.obj.store.data.items;

			switch(fieldName) {
				case "INCOME_CNT" :
					Ext.each(records,function(rec, i){
						if(rec.get('INCCODE') == record.obj.data.INCCODE){
							record.obj.store.data.items[i].set(fieldName, newValue)
						}
					});
					break;

				case "INCOME_SUPP_TOTAL_I" :
					Ext.each(records,function(rec, i){
						if(rec.get('INCCODE') == record.obj.data.INCCODE){
							record.obj.store.data.items[i].set(fieldName, newValue)
						}
					});
					break;

				case "DEF_IN_TAX_I" :
					Ext.each(records,function(rec, i){
						if(rec.get('INCCODE') == record.obj.data.INCCODE){
							record.obj.store.data.items[i].set(fieldName, newValue)
						}
					});
					break;

				case "DEF_SP_TAX_I" :
					Ext.each(records,function(rec, i){
						if(rec.get('INCCODE') == record.obj.data.INCCODE){
							record.obj.store.data.items[i].set(fieldName, newValue)
						}
					});
					break;

				case "ADD_TAX_I" :
					Ext.each(records,function(rec, i){
						if(rec.get('INCCODE') == record.obj.data.INCCODE){
							record.obj.store.data.items[i].set(fieldName, newValue)
						}
					});
					break;

				case "RET_IN_TAX_I" :
					Ext.each(records,function(rec, i){
						if(rec.get('INCCODE') == record.obj.data.INCCODE){
							record.obj.store.data.items[i].set(fieldName, newValue)
						}
					});
					break;

				case "IN_TAX_I" :
					Ext.each(records,function(rec, i){
						if(rec.get('INCCODE') == record.obj.data.INCCODE){
							record.obj.store.data.items[i].set(fieldName, newValue)
						}
					});
					break;

				case "SP_TAX_I" :
					Ext.each(records,function(rec, i){
						if(rec.get('INCCODE') == record.obj.data.INCCODE){
							record.obj.store.data.items[i].set(fieldName, newValue)
						}
					});
					break;
			}
			
			if(UniUtils.indexOf(record.obj.data.INCCODE, ['C63', 'C64', 'C65', 'C68'])){
				if (newValue != oldValue){
					if(confirm(Msg.fsbMsgH0222 + "\n" + Msg.fsbMsgH0223)){
						return true;
					} else {
						return false;
					}
				}
			} else if (record.obj.data.DEF_IN_TAX_I < 0) {
				alert('A02, A04, A06, A10, A26, A30, A90' + Msg.sMH1354);
				return false;
				//record.obj.data.DEF_IN_TAX_I = oldValue;
			}
			
			if (record.obj.data.DEF_IN_TAX_I > 0) {
				TempSum = record.obj.data.DEF_IN_TAX_I;
			}
			if (record.obj.data.DEF_SP_TAX_I > 0) {
				TempSum = TempSum + record.obj.data.DEF_IN_TAX_I;
			}
			
			if (record.obj.data.ADD_TAX_I > 0) {
				if (record.obj.data.ADD_TAX_I > TempSum) {
					alert(Msg.sMH1355);
					return false;
					//record.obj.data.ADD_TAX_I = oldValue;
				}
			}
			
			if (gsrsPayYM >= '201602') {
				UniAppManager.app.fnBuCalc201602();		//부표가 작성되었을 경우 부표의 금액을 계산(2016.02부터) 
			}
			if (gsrsPayYM >= '201602') {
				UniAppManager.app.fnCalc_201602(); 
			} /*else {
				fnCalc();
			}*/

			UniAppManager.setToolbarButtons('save', true);			

			return rv;
		}
	});
	
	Unilite.createValidator('validator02', {
		store: masterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var sNextInTAxI;
			var sRetInTAxI;

			switch(fieldName) {
				case "LAST_IN_TAX_I" :
					record.obj.store.data.items[0].set(fieldName, newValue)
					break;

				case "RET_IN_TAX_I" :
					record.obj.store.data.items[0].set(fieldName, newValue)
					break;
			}

			//당월조정환급세액
			record.obj.store.data.items[0].set('BAL_AMT', record.obj.data.LAST_IN_TAX_I - record.obj.data.BEFORE_IN_TAX_I);
//			record.obj.data.BAL_AMT 		=	record.obj.data.LAST_IN_TAX_I - record.obj.data.BEFORE_IN_TAX_I;

			//조정환급대상
			record.obj.store.data.items[0].set('ROW_IN_TAX_I'	, record.obj.data.BAL_AMT + record.obj.data.RET_AMT + record.obj.data.TRUST_AMT 
											  					+ record.obj.data.ETC_AMT + record.obj.data.FIN_COMP_AMT + record.obj.data.MERGER_AMT);
//			record.obj.data.ROW_IN_TAX_I	=	record.obj.data.BAL_AMT + record.obj.data.RET_AMT + record.obj.data.TRUST_AMT 
//											  + record.obj.data.ETC_AMT + record.obj.data.FIN_COMP_AMT + record.obj.data.MERGER_AMT;

			//차월이월환급세액
			record.obj.store.data.items[0].set('NEXT_IN_TAX_I', record.obj.data.ROW_IN_TAX_I - record.obj.data.TOTAL_IN_TAX_I);
//			record.obj.data.NEXT_IN_TAX_I	=	record.obj.data.ROW_IN_TAX_I - record.obj.data.TOTAL_IN_TAX_I;

			if (gsrsPayYM >= '201602') {
				UniAppManager.app.fnCalc_201602(); 
			} /*else {
				fnCalc();
			}*/
			
			sNextInTAxI	= record.obj.data.NEXT_IN_TAX_I;
			sRetInTAxI	= record.obj.data.RET_IN_TAX_I;			
			
			if (sNextInTAxI< sRetInTAxI) {
				alert ('환급 신청액은 차월이월환급세액보다 클 수가 없습니다.');
				return false;
				//record.obj.data.NEXT_IN_TAX_I = oldValue;
			}
			
			UniAppManager.setToolbarButtons('save', true);			
			
//			alert(masterStore.data.items[12].data.RET_IN_TAX_I);
			
			return rv;
		}
	});
};

</script>
