<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hum560skr_kd">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" />					<!-- 사원구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {

	/** Model 정의 
	 * @type 
	 */
	//1: 입사일별
	Unilite.defineModel('s_hum560skr_kdModel1', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'JOIN_DATE'			,text: '입사일자'			,type: 'uniDate'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'			,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'				,type: 'string'},
			{name: 'POST_CODE'			,text: '직책'				,type: 'string'		,comboType: 'AU'	,comboCode: 'H005'},
			{name: 'POST_NAME'			,text: '직위명'			,type: 'string'},
			{name: 'EMPLOY_TYPE'		,text: '직종'				,type: 'string'		,comboType: 'AU'	,comboCode: 'H024'},
			{name: 'EMPLOY_NAME'		,text: '사원구분명'		,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민번호'			,type: 'string'}
		]
	});
	
	//2: 퇴사일별
	Unilite.defineModel('s_hum560skr_kdModel2', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'RETR_DATE'			,text: '퇴사일자'			,type: 'uniDate'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'			,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'				,type: 'string'},
			{name: 'POST_CODE'			,text: '직책'				,type: 'string'		,comboType: 'AU'	,comboCode: 'H005'},
			{name: 'POST_NAME'			,text: '직위명'			,type: 'string'},
			{name: 'EMPLOY_TYPE'		,text: '직종'				,type: 'string'		,comboType: 'AU'	,comboCode: 'H024'},
			{name: 'EMPLOY_NAME'		,text: '사원구분명'		,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민번호'			,type: 'string'}
		]
	});

	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	//1: 입사일별		
	var masterStore1 = Unilite.createStore('s_hum560skr_kdMasterStore1',{
		model	: 's_hum560skr_kdModel1',
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
					read: 's_hum560skr_kdService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//1: 입사일별 flag
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
					Ext.getCmp('GW1').setDisabled(false);
				}else{
					Ext.getCmp('GW1').setDisabled(true);
				}
			}
		}
	});
	
	//2: 퇴사일별	
	var masterStore2 = Unilite.createStore('s_hum560skr_kdMasterStore2',{
		model	: 's_hum560skr_kdModel2',
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
					read: 's_hum560skr_kdService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//2: 퇴사일별	flag
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
					Ext.getCmp('GW2').setDisabled(false);
				}else{
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
    			fieldLabel		: '기준일',
		        xtype			: 'uniDateRangefield',
		        startFieldName	: 'JOIN_FR_DATE',
		        endFieldName	: 'JOIN_TO_DATE',
		        startDate		: UniDate.get('startOfMonth'),
		        endDate			: UniDate.get('today'),
		        allowBlank		: false,	  	
				tdAttrs			: {width: 380}, 
//		        width			: 470,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
	        },{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
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
            })
		]
	});
	
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	//1: 입사일별
	var masterGrid1 = Unilite.createGrid('s_hum560skr_kdGrid1', {
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
                
                    if(confirm('기안 하시겠습니까?')) {
                       UniAppManager.app.requestApprove();
                    }
                }
            }
        ],
		
		features: [ 
			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid1Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'JOIN_DATE'		, width: 100	},
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'POST_NAME'		, width: 100	, hidden: true},
			{ dataIndex: 'EMPLOY_TYPE'		, width: 110	},
			{ dataIndex: 'EMPLOY_NAME'		, width: 100	, hidden: true},
			{ dataIndex: 'REPRE_NUM'		, width: 130	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	//2: 퇴사일별
	var masterGrid2 = Unilite.createGrid('s_hum560skr_kdGrid2', {
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
			{ dataIndex: 'RETR_DATE'		, width: 100	},
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'POST_NAME'		, width: 100	, hidden: true},
			{ dataIndex: 'EMPLOY_TYPE'		, width: 110	},
			{ dataIndex: 'EMPLOY_NAME'		, width: 100	, hidden: true},
			{ dataIndex: 'REPRE_NUM'		, width: 130	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	
	
	var tab = Unilite.createTabPanel('s_hum560skr_kdTab',{		
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '입사일별',
				xtype	: 'container',
				itemId	: 's_hum560skr_kdTab1',
				layout	: {type:'vbox', align:'stretch'},
				items	: [
					masterGrid1
				]
			},{
				title	: '퇴사일별',
				xtype	: 'container',
				itemId	: 's_hum560skr_kdTab2',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard.getItemId() == 'agj100ukrvTab1')	{
					
				}else {
					
				}
			}
		}
	})
 
	
	
	
	Unilite.Main({
		id  : 's_hum560skr_kdApp',
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
			panelResult.setValue('JOIN_FR_DATE'	, UniDate.get('startOfMonth'));
			panelResult.setValue('JOIN_TO_DATE'	, UniDate.get('today'));
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('JOIN_FR_DATE');
			//버튼 설정
			UniAppManager.setToolbarButtons('print'	, false);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			UniAppManager.setToolbarButtons('save'	, false);
			
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
			//1: 입사일별
			if (activeTab == 's_hum560skr_kdTab1'){
				masterStore1.loadStoreRecords();

			//2: 퇴사일별
			} else if (activeTab == 's_hum560skr_kdTab2'){
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
            var userId      = UserInfo.userID
            var joinFrDate  = UniDate.getDbDateStr(panelResult.getValue('JOIN_FR_DATE'));
            var joinToDate  = UniDate.getDbDateStr(panelResult.getValue('JOIN_TO_DATE'));
            var deptcodefr    = panelResult.getValue('DEPT_CODE_FR')
            var deptcodeto    = panelResult.getValue('DEPT_CODE_TO');
            var personnumbfr  = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto  = panelResult.getValue('PERSON_NUMB_TO');
            
            //var record = masterGrid1.getSelectedRecord();
            var activeTab = tab.getActiveTab().getItemId();
            //1: 입사일별
            if (activeTab == 's_hum560skr_kdTab1'){
                var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hum560skr_1&draft_no=0&sp=EXEC " 
                		       
                var gubun    = '1'

            //2: 퇴사일별
            } else {
                var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hum560skr_2&draft_no=0&sp=EXEC " 
                var gubun    = '2'
            }
                        
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HUM560SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                            + ', ' + "'" + joinFrDate + "'" + ', ' + "'" + joinToDate + "'" + ', ' + "'" + deptcodefr + "'" + ', ' + "'" + deptcodeto + "'"+
                            ', ' + "'" + personnumbfr + "'" + ', ' + "'" + personnumbto + "'"
                            + ', ' + "'" + gubun + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
            var spCall      = encodeURIComponent(spText); 
            
            
            
            //var groupUrl = "http://58.151.163.201:8070/ClipReport4/sample2.jsp?prg_no=hat890skr&sp=EXEC "

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
