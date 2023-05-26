<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa710skr_kd">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="H005" />					<!-- 직위코드 --> 
	<t:ExtComboStore comboType="AU" comboCode="HX14" />                    <!-- 출력구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {

	//////////////////단, SP 안만들어짐 : 1. 스펙에 있는 대로 호출하도록 설정 (사원번호 SP 호출부에 누락) - 박재범 부장님 확인 필요
    //////////////////				  2. 그리드 컬럼명 확인 필요 - 박재범 부장님 확인 필요
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hpa710skr_kdModel', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사번'				,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'POST_CODE'			,text: '직위'				,type: 'string'	, comboType : 'AU', comboCode : 'H005'},
			{name: 'POST_NAME'			,text: '직위명'			,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'				,type: 'string'},
			{name: 'JOIN_DATE'			,text: '입사일자'			,type: 'string'},
			{name: 'DUTY_CNT'			,text: '표준일수'			,type: 'uniNumber'},
			{name: 'DUTY_21_CNT'		,text: '결근일수'			,type: 'uniNumber'},
			{name: 'DUTY_NUM'			,text: '실근무일수'		,type: 'uniNumber'},
			{name: 'DUTY_61_CNT'		,text: '연차기준일수'		,type: 'uniNumber'},
			{name: 'DUTY_PERCENT'		,text: '적용율'			,type: 'uniPercent'},
			{name: 'YEAR_DIFF'			,text: '근속년수'			,type: 'uniNumber'},
			{name: 'OVER_DUTY'			,text: '추가일수'  		,type: 'uniNumber'},
			{name: 'LAST_YEAR_USE'		,text: '전년 사용일수'		,type: 'uniNumber'},
			{name: 'YEAR_PREV'			,text: '연차 이월일수'		,type: 'uniNumber'},
			{name: 'REMARK'				,text: '비고'				,type: 'string'}
		]
	});
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	var masterStore = Unilite.createStore('s_hpa710skr_kdmasterStore',{
		model	: 's_hpa710skr_kdModel',
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
					read: 's_hpa710skr_kdService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();  
				if(count > 0){
					Ext.getCmp('GW').setDisabled(false);
				}else{
					Ext.getCmp('GW').setDisabled(true);
				}

			}
		}
	});
	
	
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel	: '기준일',	
				name		: 'ST_YYYY', 
				xtype		: 'uniDatefield',
				value		: new Date(),				
				allowBlank	: false,	  	
				tdAttrs		: {width: 380} 
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
			{
                fieldLabel  : '출력구분',
                name        : 'REPORT_TYPE', 
                xtype       : 'uniCombobox',
                comboType   : 'AU',
                comboCode   : 'HX14',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	
                    }, 
                    afterrender: {
                        fn: function (combo) {
                           var store = combo.getStore()
                           var rec = { value: '', text: '' };
                           store.insert(0,rec);
                        }
                     }
                }
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
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),Unilite.popup('Employee',{
                fieldLabel      : '~',
                valueFieldName  : 'PERSON_NUMB_TO',
                textFieldName   : 'NAME',
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
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),Unilite.popup('DEPT',{
                fieldLabel      : '~',
                valueFieldName  : 'DEPT_CODE_TO',
                textFieldName   : 'DEPT_NAME',
                validateBlank   : false,                    
                tdAttrs         : {width: 380},  
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            })
//            	{	    
//				fieldLabel	: '재직구분',
//				name		: 'WORK_GB',
//				id			: 'workGb',
//				xtype		: 'uniRadiogroup',
//				width		: 300,
//				items		: [{
//					boxLabel	: '전체',
//					name		: 'WORK_GB',
//					inputValue	: ''							
//				},{
//					boxLabel	: '재직',
//					name		: 'WORK_GB',
//					inputValue	: '1'								
//				},{
//					boxLabel	: '퇴직',
//					name		: 'WORK_GB',
//					inputValue	: '2'
//				}],	
//				value		: '1'
//			}
		]
	});
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_hpa710skr_kdGrid', {
		store	: masterStore,
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
                id:'GW',
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
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		 	, width: 110	, hidden: true},
			{ dataIndex: 'PERSON_NUMB'			, width: 110	},
			{ dataIndex: 'DEPT_NAME'			, width: 110	},
			{ dataIndex: 'POST_CODE'			, width: 100	},
			{ dataIndex: 'POST_NAME'			, width: 110	, hidden: true},
			{ dataIndex: 'PERSON_NAME'			, width: 110	},
			{ dataIndex: 'JOIN_DATE'			, width: 100	},
			{ dataIndex: 'DUTY_CNT'				, width: 100	},
			{ dataIndex: 'DUTY_21_CNT'			, width: 100	},
			{ dataIndex: 'DUTY_NUM'				, width: 100	},
			{ dataIndex: 'DUTY_61_CNT'			, width: 100	},
			{ dataIndex: 'DUTY_PERCENT'			, width: 100	},
			{ dataIndex: 'YEAR_DIFF'			, width: 100	},
			{ dataIndex: 'OVER_DUTY'			, width: 100	},
			{ dataIndex: 'LAST_YEAR_USE'		, width: 100	},
			{ dataIndex: 'YEAR_PREV'			, width: 100	},
			{ dataIndex: 'REMARK'				, width: 200	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	
	
	
	Unilite.Main({
		id  : 's_hpa710skr_kdApp',
		borderItems:[{
		  region: 'center',
		  layout: {type: 'vbox', align: 'stretch'},
		  border: false,
		  items:[
				panelResult, masterGrid 
		  ]}
		], 
		fnInitBinding : function() {
			//초기값 설정
			panelResult.setValue('ST_YYYY'		, new Date());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('ST_YYYY');
			//버튼 설정
			UniAppManager.setToolbarButtons('print'	, false);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			UniAppManager.setToolbarButtons('save'	, false);
			
			Ext.getCmp('GW').setDisabled(true);
		},
		
		onQueryButtonDown : function()	{
			//필수입력값 체크
			if(!this.isValidSearchForm()){
				return false;
			}
			
			masterStore.loadStoreRecords();
			
			UniAppManager.setToolbarButtons('reset', true);
		},				
				
		onResetButtonDown: function() {		
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();	
		}, 
		requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');
            
            var frm           = document.f1;
            var compCode      = UserInfo.compCode;
            var divCode       = panelResult.getValue('DIV_CODE');
            var userId        = UserInfo.userID
            var year          = UniDate.getDbDateStr(panelResult.getValue('ST_YYYY')).substring(0, 4)
            var deptcodefr    = panelResult.getValue('DEPT_CODE_FR');
            var deptcodeto    = panelResult.getValue('DEPT_CODE_TO');
            var personnumbfr  = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto  = panelResult.getValue('PERSON_NUMB_TO');
            
            var rpttype       = panelResult.getValue('REPORT_TYPE');

            var groupUrl    = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hpa710skr&draft_no=0&sp=EXEC " 
            
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HPA710SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                            + ', ' + "'" + deptcodefr + "'" + ', ' + "'" + deptcodeto + "'" 
                            + ', ' + "'" + personnumbfr + "'" +', ' + "'" + personnumbto + "'" + ', ' + "'" + rpttype + "'" 
                            + ', ' + "'" + year + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
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
