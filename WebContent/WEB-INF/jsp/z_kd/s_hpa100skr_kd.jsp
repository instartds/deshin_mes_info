<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa100skr_kd">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="H024" />					<!-- 사원구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {
	var gsTab1AnuRate = '';
	var gsTab1MedRate = '';
	var gsTab1LciRate = '';
	var gsTab2AnuRate = '';
	var gsTab2MedRate = '';
	var gsTab2LciRate = '';
	
	/** Model 정의 
	 * @type 
	 */
	//국민연금 Model
	Unilite.defineModel('s_hpa100skr_kdModel', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'		,type: 'string'		, comboType: 'BOR120'},
			{name: 'PERSON_NAME'		,text: '성명'				,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'			,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민등록번호'		,type: 'string'},
			{name: 'JOIN_DATE'			,text: '취득일자'			,type: 'uniDate'},
			{name: 'DED_AMOUNT_I'		,text: '각출료'			,type: 'uniPrice'},
			{name: 'REMARK'				,text: '비고'				,type: 'string'}
		]
	});
	
	//건강보험 Model
	Unilite.defineModel('s_hpa100skr_kdModel2', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'		,type: 'string'		, comboType: 'BOR120'},
			{name: 'PERSON_NAME'		,text: '성명'				,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'			,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민등록번호'		,type: 'string'},
			{name: 'JOIN_DATE'			,text: '취득일자'			,type: 'uniDate'},
			{name: 'MED_AMOUNT_I'		,text: '산출보험료'		,type: 'uniPrice'},
			{name: 'LCI_AMOUNT_I'		,text: '장기요양보험'		,type: 'uniPrice'},
			{name: 'RME_AMOUNT_I'		,text: '정산보험료'		,type: 'uniPrice'},
			{name: 'SUM_AMOUNT_I'		,text: '부과금액(계)'		,type: 'uniPrice'}
		]
	});
	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore1 = Unilite.createStore('s_hpa100skr_kdMasterStore1',{
		model	: 's_hpa100skr_kdModel',
		uniOpt	: {
			isMaster	: true,				// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi		: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {			
					read: 's_hpa100skr_kdService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//국민연금 flag
			param.WORK_GB = '1'
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid1.getStore().getCount();  
				if(count > 0){
					dataForm.setValue('MED_RATE'	, records[0].data.MED_RATE);
					dataForm.setValue('LCI_RATE'	, records[0].data.LCI_RATE);
					dataForm.setValue('ANU_RATE'	, records[0].data.ANU_RATE);
					
					Ext.getCmp('GW1').setDisabled(false);
				}else{
					dataForm.setValue('MED_RATE'	, '');
					dataForm.setValue('LCI_RATE'	, '');
					dataForm.setValue('ANU_RATE'	, '');
					
					Ext.getCmp('GW1').setDisabled(true);
				}
			}
		}
	});
	
	var masterStore2 = Unilite.createStore('s_hpa100skr_kdMasterStore2', {
		model	: 's_hpa100skr_kdModel2',
		uniOpt	: {
			isMaster	: true,				// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi		: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {		  
				read: 's_hpa100skr_kdService.selectList'				
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('panelResultForm').getValues();	
			//건강보험 flag
			param.WORK_GB = '2'		
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid2.getStore().getCount();  
				if(count > 0){
					dataForm.setValue('MED_RATE'	, records[0].data.MED_RATE);
					dataForm.setValue('LCI_RATE'	, records[0].data.LCI_RATE);
					dataForm.setValue('ANU_RATE'	, records[0].data.ANU_RATE);
					
					Ext.getCmp('GW2').setDisabled(false);
				}else{
					dataForm.setValue('MED_RATE'	, '');
					dataForm.setValue('LCI_RATE'	, '');
					dataForm.setValue('ANU_RATE'	, '');
					
					Ext.getCmp('GW2').setDisabled(true);
				}
			}
		}
	});
	
	
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
//		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2
//		, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
                fieldLabel  : '사업장',
                name        : 'DIV_CODE', 
                xtype       : 'uniCombobox',
                comboType   : 'BOR120',
                value       : UserInfo.divCode,
//              multiSelect : true, 
//              typeAhead   : false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    }
                }
            },{
                fieldLabel  : '급여년월',  
                xtype       : 'uniMonthRangefield',
                startFieldName    : 'PAY_YYYYMM_FR',
                endFieldName    : 'PAY_YYYYMM_TO',
                id          : 'frToDate',               
                value       : new Date(),               
                allowBlank  : false,    
                colspan     : 2,
                tdAttrs     : {width: 380} 
            }, 
			Unilite.popup('Employee',{
                fieldLabel      : '사원',
                valueFieldName  : 'PERSON_NUMB_FR',
                textFieldName   : 'NAME',
                validateBlank   : false,
                autoPopup       : true,
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        	panelResult.setValue('PERSON_NUMB_TO',panelResult.getValue('PERSON_NUMB_FR'));
                        	panelResult.setValue('NAME1',panelResult.getValue('NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('PERSON_NUMB_FR','');
                        panelResult.setValue('NAME','');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),Unilite.popup('Employee',{
                fieldLabel      : '~',
                valueFieldName  : 'PERSON_NUMB_TO',
                textFieldName   : 'NAME1',
                validateBlank   : false,
                autoPopup       : true,
                colspan         : 2,
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('PERSON_NUMB_TO','');
                        panelResult.setValue('NAME1','');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),
            Unilite.popup('DEPT',{
                fieldLabel      : '부서',
                valueFieldName  : 'DEPT_CODE_FR',
                textFieldName   : 'DEPT_NAME',
                validateBlank   : false,                    
                tdAttrs         : {width: 380},  
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        	panelResult.setValue('DEPT_CODE_TO',panelResult.getValue('DEPT_CODE_FR'));
                            panelResult.setValue('DEPT_NAME1',panelResult.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('DEPT_CODE_FR','');
                        panelResult.setValue('DEPT_NAME','');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),Unilite.popup('DEPT',{
                fieldLabel      : '~',
                valueFieldName  : 'DEPT_CODE_TO',
                textFieldName   : 'DEPT_NAME1',
                validateBlank   : false,                    
                tdAttrs         : {width: 380},  
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('DEPT_CODE_TO','');
                        panelResult.setValue('DEPT_NAME1','');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),
            {
                xtype: 'radiogroup',
                id   : 'sort_gb',
                fieldLabel: '정렬순서',
                items : [{
                    boxLabel: '이름순',
                    name: 'SORT_GB',
                    inputValue: '1',
                    width:95,
                    checked: true
                }, {boxLabel: '사번순',
                    name: 'SORT_GB',
                    inputValue: '2',
                    width:85
                }]              
            }
		]
	});

	var dataForm = Unilite.createSearchForm('panelDetailForm',{
		padding:'0 1 0 1',
		layout : {type : 'uniTable', columns : 4},
		border:true,
		region: 'center',
		items: [{ 
				fieldLabel	: '건강보험율',
				name		: 'MED_RATE',
				xtype		: 'uniTextfield',
				readOnly	: true,
				focusable	: false,	  	
				tdAttrs		: {width: 380},
				listeners:{
					afterrender:function(field)	{
//						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{					
//					detailForm.openCryptRepreNoPopup();
				}
			},{ 
				fieldLabel	: '요양보험율',
				name		: 'LCI_RATE',
				xtype		: 'uniTextfield',
				readOnly	: true,
				focusable	: false,	  	
				tdAttrs		: {width: 380},
				listeners:{
					afterrender:function(field)	{
//						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{					
//					detailForm.openCryptRepreNoPopup();
				}
			},{ 
				fieldLabel	: '국민보험율',
				name		: 'ANU_RATE',
				xtype		: 'uniTextfield',
				readOnly	: true,
				focusable	: false,	  	
				tdAttrs		: {width: 380},
				listeners:{
					afterrender:function(field)	{
//						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{					
//					detailForm.openCryptRepreNoPopup();
				}
			}]
	});
	
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('s_hpa100skr_kdGrid1', {
		store	: masterStore1,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {	
			expandLastColumn	: true,			//마지막 컬럼 * 사용 여부
			useRowNumberer		: true,			//첫번째 컬럼 순번 사용 여부
			useLiveSearch		: true,			//찾기 버튼 사용 여부
			useRowContext		: false,			
			onLoadSelectFirst	: true,
			filter: {							//필터 사용 여부
				useFilter	: true,
				autoCreate	: true
			}
		},
		
        tbar: [{
                itemId : 'GWBtn',
                id:'GW1',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    
                    if(!UniAppManager.app.isValidSearchForm()){
                        return false;
                    }
                
                    //param.DRAFT_NO = "0";
                    if(confirm('기안 하시겠습니까?')) {
                       UniAppManager.app.requestApprove();
                    }
                    //UniAppManager.app.onQueryButtonDown();
                }
            }
        ],
		
		features: [ 
			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid1Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 110	, hidden: true},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'REPRE_NUM'		, width: 130	},
			{ dataIndex: 'JOIN_DATE'		, width: 100	},
			{ dataIndex: 'DED_AMOUNT_I'		, width: 150	},
			{ dataIndex: 'REMARK'			, width: 230	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
 
	var masterGrid2 = Unilite.createGrid('s_hpa100skr_kdGrid2', {
		store	: masterStore2,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {	
			expandLastColumn	: true,			//마지막 컬럼 * 사용 여부
			useRowNumberer		: true,			//첫번째 컬럼 순번 사용 여부
			useLiveSearch		: true,			//찾기 버튼 사용 여부
			useRowContext		: false,			
			onLoadSelectFirst	: true,
			filter: {							//필터 사용 여부
				useFilter	: true,
				autoCreate	: true
			}
		},
		
        tbar: [{
                itemId : 'GWBtn',
                id:'GW2',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    
                    if(!UniAppManager.app.isValidSearchForm()){
                        return false;
                    }
                
                    //param.DRAFT_NO = "0";
                    if(confirm('기안 하시겠습니까?')) {
                       UniAppManager.app.requestApprove();
                    }
                    //UniAppManager.app.onQueryButtonDown();
                }
            }
        ],
		
		features: [ 
			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid1Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 110	, hidden: true},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'REPRE_NUM'		, width: 130	},
			{ dataIndex: 'JOIN_DATE'		, width: 100	},
			{ dataIndex: 'MED_AMOUNT_I'		, width: 150	},
			{ dataIndex: 'LCI_AMOUNT_I'		, width: 150	},
			{ dataIndex: 'RME_AMOUNT_I'		, width: 150	},
			{ dataIndex: 'SUM_AMOUNT_I'		, width: 150	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	
	
	var tab = Unilite.createTabPanel('s_hpa100skr_kdTab',{		
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '국민연금 명세서',
				xtype	: 'container',
				itemId	: 's_hpa100skr_kdTab1',
				layout	: {type:'vbox', align:'stretch'},
				items	: [
					masterGrid1
				]
			},{
				title	: '건강보험 명세서',
				xtype	: 'container',
				itemId	: 's_hpa100skr_kdTab2',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard == oldCard) {
					return false;
				}
				if(newCard.getItemId() == 's_hpa100skr_kdTab1')	{
					gsTab2AnuRate = dataForm.getValue('ANU_RATE');
					gsTab2MedRate = dataForm.getValue('MED_RATE');
					gsTab2LciRate = dataForm.getValue('LCI_RATE');
					
					dataForm.setValue('ANU_RATE', gsTab1AnuRate);
					dataForm.setValue('MED_RATE', gsTab1MedRate);
					dataForm.setValue('LCI_RATE', gsTab1LciRate);
					
				} else {
					gsTab1AnuRate = dataForm.getValue('ANU_RATE');
					gsTab1MedRate = dataForm.getValue('MED_RATE');
					gsTab1LciRate = dataForm.getValue('LCI_RATE');
					
					dataForm.setValue('ANU_RATE', gsTab2AnuRate);
					dataForm.setValue('MED_RATE', gsTab2MedRate);
					dataForm.setValue('LCI_RATE', gsTab2LciRate);
				}
			}
		}
	})
	
	
	
	Unilite.Main({
		id  : 's_hpa100skr_kdApp',
		borderItems:[{
		  region:'center',
		  layout: {type: 'vbox', align: 'stretch'},
		  border: false,
		  items:[
				panelResult, dataForm, tab 
		  ]}
		], 
		fnInitBinding : function() {
			//초기값 설정
			gsTab1AnuRate = '';
			gsTab1MedRate = '';
			gsTab1LciRate = '';
			gsTab2AnuRate = '';
			gsTab2MedRate = '';
			gsTab2LciRate = '';
			panelResult.setValue('PAY_YYYYMM_FR'	, new Date());
			panelResult.setValue('PAY_YYYYMM_TO' , new Date());
			panelResult.setValue('DIV_CODE_FR'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE_TO'      , UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('PAY_YYYYMM_FR');
			panelResult.onLoadSelectText('PAY_YYYYMM_TO');
			//버튼 설정
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			Ext.getCmp('GW1').setDisabled(true);
			Ext.getCmp('GW2').setDisabled(true);
		},
		
		onQueryButtonDown : function()	{
			//필수입력값 체크
			if(!this.isValidSearchForm()){
				return false;
			}
			
			//활성화 된 탭에 따른 조회로직
			var activeTab = tab.getActiveTab().getItemId();
			/* 건강보험 명세서 */
			if (activeTab == 's_hpa100skr_kdTab1'){
//				UniAppManager.setToolbarButtons(['reset'],false);
//				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				masterStore1.loadStoreRecords();

			/* 국민연금 명세서 */
			} else {
				masterStore2.loadStoreRecords();
			}
			UniAppManager.setToolbarButtons('reset', true);
		},				
				
		onResetButtonDown: function() {		
			panelResult.clearForm();	
			dataForm.clearForm();
			masterGrid1.getStore().loadData({});	
			masterGrid2.getStore().loadData({});
			this.fnInitBinding();	
		},
		requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var userId      = UserInfo.userID
            var payYYYYMMfr   = UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM_FR')).substring(0, 6);
            var payYYYYMMto   = UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM_TO')).substring(0, 6);
            
            var deptcodefr    = panelResult.getValue('DEPT_CODE_FR');
            var deptcodeto    = panelResult.getValue('DEPT_CODE_TO');
            var personnumbfr  = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto  = panelResult.getValue('PERSON_NUMB_TO');
            var sortgb        = Ext.getCmp('sort_gb').getChecked()[0].inputValue;
            
            var gubun       = '';
            
            //var record = masterGrid1.getSelectedRecord();
            var activeTab = tab.getActiveTab().getItemId();
            //1: 입사일별
            if (activeTab == 's_hpa100skr_kdTab1'){
                var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hpa100skr_1&draft_no=0&sp=EXEC " 
                var gubun    = '1'

            //2: 퇴사일별
            } else {
                var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hpa100skr_2&draft_no=0&sp=EXEC " 
                var gubun    = '2'
            }
                        
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HPA100SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                            + ', ' + "'" + payYYYYMMfr + "'" + ', ' + "'" + payYYYYMMto + "'" +', ' + "'" + personnumbfr + "'" + ', ' + "'" + personnumbto + "'" +', ' + "'" + deptcodefr + "'" 
                            + ', ' + "'" + deptcodeto + "'" +', ' + "'" + gubun + "'" +', ' + "'" + sortgb + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''" + ', ' + "''"+ ', ' + "''"+ ', ' + "''";
            var spCall      = encodeURIComponent(spText); 
            

            
            frm.action   = groupUrl + spCall/* + Base64.encode()*/;
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit();
        }
	});
};


</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
