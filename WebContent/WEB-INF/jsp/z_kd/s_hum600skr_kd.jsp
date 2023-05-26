<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hum600skr_kd">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" />					<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="HX15" />                 <!-- 출력구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {

	/** Model 정의 
	 * @type 
	 */
	//1: 해당자별
	Unilite.defineModel('s_hum600skr_kdModel1', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '사업장코드'				,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'					,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'						,type: 'string'},
			{name: 'POST_CODE'			,text: '직책'						,type: 'string'		,comboType: 'AU'	,comboCode: 'H005'},
			{name: 'POST_NAME'			,text: '직위명'					,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'					,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'					,type: 'string'},
			{name: 'EMPLOY_TYPE'		,text: '직종'						,type: 'string'		,comboType: 'AU'	,comboCode: 'H024'},
			{name: 'EMPLOY_NAME'		,text: '사원구분명'				,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민등록번호'				,type: 'string'},
			{name: 'END_DATE'			,text: '임금피크제</br>적용일자'		,type: 'uniDate'},
			{name: 'AGE'				,text: '연령'						,type: 'string'},
			{name: 'REMAIN'				,text: '잔여일'					,type: 'string'},
			{name: 'REMARK'				,text: '비고'						,type: 'string'}
		]
	});
	
	//2: 만기도래현황별
	Unilite.defineModel('s_hum600skr_kdModel2', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '사업장코드'				,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'					,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'						,type: 'string'},
			{name: 'POST_CODE'			,text: '직책'						,type: 'string'		,comboType: 'AU'	,comboCode: 'H005'},
			{name: 'POST_NAME'			,text: '직위명'					,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'					,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'					,type: 'string'},
			{name: 'EMPLOY_TYPE'		,text: '직종'						,type: 'string'		,comboType: 'AU'	,comboCode: 'H024'},
			{name: 'EMPLOY_NAME'		,text: '사원구분명'				,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민번호'					,type: 'string'},
			{name: 'AGE'				,text: '연령'						,type: 'string'},
			{name: 'JOIN_DATE'			,text: '입사일자'					,type: 'uniDate'},
			{name: 'END_DATE'			,text: '임금피크제</br>만기일자'		,type: 'uniDate'},
			{name: 'REMAIN'				,text: '잔여일'					,type: 'string'},
			{name: 'RPT_TYPE'           ,text: '구분'                     ,type: 'string'},
			{name: 'REMARK'				,text: '비고'						,type: 'string'}
		]
	});

	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	//1: 해당자별		
	var masterStore1 = Unilite.createStore('s_hum600skr_kdMasterStore1',{
		model	: 's_hum600skr_kdModel1',
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
					read: 's_hum600skr_kdService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//1: 해당자별 flag
			param.WORK_GB = '1'
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				var count = masterGrid1.getStore().getCount();  
//				if(count > 0){
//					Ext.getCmp('GW1').setDisabled(false);
//				}else{
//					Ext.getCmp('GW1').setDisabled(true);
//				}
			}
		}
	});
	
	//2: 만기도래현황별	
	var masterStore2 = Unilite.createStore('s_hum600skr_kdMasterStore2',{
		model	: 's_hum600skr_kdModel2',
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
					read: 's_hum600skr_kdService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//2: 만기도래현황별	flag
			param.WORK_GB = '2'
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				var count = masterGrid2.getStore().getCount();  
//				if(count > 0){
//					Ext.getCmp('GW2').setDisabled(false);
//				}else{
//					Ext.getCmp('GW2').setDisabled(true);
//				}
			}
		}
	});
	
	
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
//		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel	: '기준일',	
				name		: 'ST_DATE', 
				xtype		: 'uniDatefield',		
				value		: new Date(),				
				allowBlank	: false,
				tdAttrs		: {width: 380},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
		 		}
			},{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				colspan     : 2,
				value		: UserInfo.divCode,
//				multiSelect	: true, 
//				typeAhead	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
		 		}
			}, 
			Unilite.popup('Employee',{
                fieldLabel        : '사원',
                valueFieldName    : 'PERSON_NUMB_FR',
                textFieldName    : 'NAME',
                validateBlank    : false,
                autoPopup        : true,
                listeners        : {
                    onSelected: {
                        fn: function(records, type) {
                        	panelResult.setValue('PERSON_NUMB_TO', panelResult.getValue('PERSON_NUMB_FR'));
                            panelResult.setValue('NAME1', panelResult.getValue('NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                    	panelResult.setValue('PERSON_NUMB_FR', '');
                        panelResult.setValue('NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }), Unilite.popup('Employee',{
                fieldLabel        : '~',
                valueFieldName    : 'PERSON_NUMB_TO',
                textFieldName    : 'NAME1',
                validateBlank    : false,
                autoPopup        : true,
                colspan : 2,
                listeners        : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                    	panelResult.setValue('PERSON_NUMB_TO', '');
                        panelResult.setValue('NAME1', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),   
            Unilite.popup('DEPT',{
                fieldLabel        : '부서',
                valueFieldName    : 'DEPT_CODE_FR',
                textFieldName    : 'DEPT_NAME',
                validateBlank    : false,                    
                tdAttrs            : {width: 380},  
                listeners        : {
                    onSelected: {
                        fn: function(records, type) {
                        	panelResult.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_FR'));
                            panelResult.setValue('DEPT_NAME1', panelResult.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                    	panelResult.setValue('DEPT_CODE_FR', '');
                        panelResult.setValue('DEPT_NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),Unilite.popup('DEPT',{
                fieldLabel        : '~',
                valueFieldName    : 'DEPT_CODE_TO',
                textFieldName    : 'DEPT_NAME1',
                validateBlank    : false,                    
                tdAttrs            : {width: 380},  
                colspan          : 2,
                listeners        : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                    	panelResult.setValue('DEPT_CODE_TO', '');
                        panelResult.setValue('DEPT_NAME1', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),
            {
                fieldLabel    : '출력구분',
                name        : 'RPT_TYPE', 
                id          : 'rpttype',
                xtype        : 'uniCombobox',
                comboType   : 'AU',
                comboCode    : 'HX15',
                hidden : true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    }
                 }
            }
		]
	});
	
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	//1: 해당자별
	var masterGrid1 = Unilite.createGrid('s_hum600skr_kdGrid1', {
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
			{ dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'POST_NAME'		, width: 110	, hidden: true},
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 110	},
			{ dataIndex: 'EMPLOY_TYPE'		, width: 110	},
			{ dataIndex: 'EMPLOY_NAME'		, width: 100	, hidden: true},
			{ dataIndex: 'REPRE_NUM'		, width: 130	},
			{ dataIndex: 'END_DATE'			, width: 100	},
			{ dataIndex: 'AGE'				, width: 90		},
			{ dataIndex: 'REMAIN'			, width: 110	},
			{ dataIndex: 'REMARK'			, flex: 1		, minWidth: 200	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	//2: 만기도래현황별
	var masterGrid2 = Unilite.createGrid('s_hum600skr_kdGrid2', {
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
			{ dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 110	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'POST_NAME'		, width: 110	, hidden: true},
			{ dataIndex: 'DEPT_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'EMPLOY_TYPE'		, width: 110	, hidden: true},
			{ dataIndex: 'EMPLOY_NAME'		, width: 100	, hidden: true},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'REPRE_NUM'		, width: 130	},
			{ dataIndex: 'AGE'				, width: 90		},
			{ dataIndex: 'JOIN_DATE'		, width: 100	},
			{ dataIndex: 'END_DATE'			, width: 100	},
			{ dataIndex: 'REMAIN'			, width: 110	},
			{ dataIndex: 'RPT_TYPE'            , width: 110    },
			{ dataIndex: 'REMARK'			, flex: 1		, minWidth: 200	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	
	
	var tab = Unilite.createTabPanel('s_hum600skr_kdTab',{		
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '해당자',
				xtype	: 'container',
				itemId	: 's_hum600skr_kdTab1',
				layout	: {type:'vbox', align:'stretch'},
				items	: [
					masterGrid1
				]
			},{
				title	: '만기도래현황',
				xtype	: 'container',
				itemId	: 's_hum600skr_kdTab2',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
//				if(newCard.getItemId() == 's_hum600skr_kdTab1')	{
//					Ext.getCmp('rpttype').setHidden(true);
//				}else {
//					Ext.getCmp('rpttype').setHidden(false);
//				}
			}
		}
	})
 
	
	
	
	Unilite.Main({
		id  : 's_hum600skr_kdApp',
		borderItems:[{
		  region:'center',
		  layout: {type: 'vbox', align: 'stretch'},
		  border: false,
		  items:[
				panelResult, tab 
		  ]}
		], 
		fnInitBinding : function() {
			//초기값 설정
			panelResult.setValue('ST_DATE'		, new Date());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('ST_DATE');
			//버튼 설정
			UniAppManager.setToolbarButtons('print'	, false);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			UniAppManager.setToolbarButtons('save'	, false);
			
//			Ext.getCmp('GW1').setDisabled(true);
//			Ext.getCmp('GW2').setDisabled(true);
		},
		
		onQueryButtonDown : function()	{
			//필수입력값 체크
			if(!this.isValidSearchForm()){
				return false;
			}
			
			//활성화 된 탭에 따른 조회로직
			var activeTab = tab.getActiveTab().getItemId();
			//1: 해당자별
			if (activeTab == 's_hum600skr_kdTab1'){
				masterStore1.loadStoreRecords();

			//2: 만기도래현황별
			} else if (activeTab == 's_hum600skr_kdTab2'){
				masterStore2.loadStoreRecords();
			}
			
			UniAppManager.setToolbarButtons('reset', true);
		},				
				
		onResetButtonDown: function() {		
			panelResult.clearForm();
			masterGrid1.getStore().loadData({});	
			masterGrid2.getStore().loadData({});
			this.fnInitBinding();	
		},
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var deptcodefr    = panelResult.getValue('DEPT_CODE_FR')
            var deptcodeto    = panelResult.getValue('DEPT_CODE_TO');
            var personnumbfr  = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto  = panelResult.getValue('PERSON_NUMB_TO');
            
            var userId      = UserInfo.userID
            var stDate      = UniDate.getDbDateStr(panelResult.getValue('ST_DATE'));
            var activeTab = tab.getActiveTab().getItemId();
            
            var gubun = "";
            //1: 연봉직
            if (activeTab == 's_hum600skr_kdTab1'){
                gubun = "1";

            //2: 연봉직 외
            } else {
                gubun = "2";
                var rpttype  = panelResult.getValue('RPT_TYPE');
            }
            
            
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HUM600SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                            + ', ' + "'" + stDate + "'" + ', ' + "'" + deptcodefr + "'" + ', ' + "'" + deptcodeto + "'" + ', ' + "'" + personnumbfr + "'" + ', ' + "'" + personnumbto + "'" 
                            + ', ' + "'" + gubun + "'"  + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
            var spCall      = encodeURIComponent(spText); 
            
            //var record = masterGrid1.getSelectedRecord();
            var activeTab = tab.getActiveTab().getItemId();
            //1: 해당자
            if (activeTab == 's_hum600skr_kdTab1'){
                var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hum600skr_1&draft_no=0&sp=EXEC " 

            //2: 만기도래현황
            } else {
                var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hum600skr_2&draft_no=0&sp=EXEC " 
            }
            
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
