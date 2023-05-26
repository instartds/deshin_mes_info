<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hum540skr_kd">
	<t:ExtComboStore comboType="BOR120" /> 							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H094" />                 <!-- 발령코드 -->
	<t:ExtComboStore items="${COMBO_ANLIST}" storeId="COMBO_ANLIST"/>   		   <!--  Cost Pool        -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >


function appMain() {

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_hum540skr_kdModel', {
		fields: [
			{name: 'COMP_CODE'				,text: 'COMP_CODE'					,type: 'string'},
			{name: 'PERSON_NUMB'			,text: '사원번호'						,type: 'string'},
			{name: 'PERSON_NAME'			,text: '성명'							,type: 'string'},
			{name: 'DEPT_CODE'				,text: '부서코드'						,type: 'string'},
			{name: 'DEPT_NAME'				,text: '부서명'						,type: 'string'},
			{name: 'POST_CODE'				,text: 'POST_CODE'					,type: 'string'},
			{name: 'POST_NAME'				,text: 'POST_NAME'					,type: 'string'},
			{name: 'ANNOUNCE_CODE'			,text: '발령코드'						,type: 'string'},
			{name: 'ANNOUNCE_NAME'			,text: '발령명'						,type: 'string'},
			{name: 'ANNOUNCE_DATE'			,text: '발령일자'						,type: 'string'},
			{name: 'AF_PAY_GRADE_01_NAME'	,text: '급수'							,type: 'string'},
			{name: 'AF_PAY_GRADE_02'		,text: '호봉'							,type: 'string'},
			{name: 'AF_PAY_GRADE_03_NAME'	,text: '직책'							,type: 'string'},
			{name: 'AF_PAY_GRADE_04_NAME'	,text: '기술'							,type: 'string'},
			{name: 'WAGES_AMT_01'			,text: '기본급'  						,type: 'uniPrice'},
			{name: 'WAGES_AMT_02'			,text: '시간외'						,type: 'uniPrice'},
			{name: 'WAGES_AMT_03'			,text: '직책수당'						,type: 'uniPrice'},
			{name: 'WAGES_AMT_04'			,text: '기술수당'						,type: 'uniPrice'},
			{name: 'WAGES_AMT_05'			,text: '가족수당'						,type: 'uniPrice'},
			{name: 'WAGES_AMT_06'			,text: '생산장려'						,type: 'uniPrice'},
			{name: 'WAGES_AMT_07'			,text: '반장수당'						,type: 'uniPrice'},
			{name: 'WAGES_AMT_08'			,text: '연구수당'						,type: 'uniPrice'},
			{name: 'WAGES_AMT_09'			,text: '기타수당1'						,type: 'uniPrice'},
			{name: 'WAGES_AMT_10'			,text: '기타수당2'						,type: 'uniPrice'},
			{name: 'WAGES_AMT_11'			,text: '운전수당'						,type: 'uniPrice'},
			{name: 'WAGES_AMT_12'			,text: '연수수당'						,type: 'uniPrice'},
			{name: 'WAGES_AMT_TOT'			,text: '합계'							,type: 'uniPrice'},
			{name: 'REMARK'					,text: '비고'							,type: 'string'}

		]
	});




	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('s_hum540skr_kdMasterStore1',{
		model	: 's_hum540skr_kdModel',
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
					read: 's_hum540skr_kdService.selectList'
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
		},
		group: 'DEPT_CODE'
	});




	var panelResult = Unilite.createSearchForm('panelResultForm', {
//		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [
			{
                fieldLabel  : '발령일자',
                xtype       : 'uniDateRangefield',
                startFieldName: 'ST_DATE_FR',
                endFieldName: 'ST_DATE_TO',
                startDate: UniDate.get('today'),
                endDate: UniDate.get('today'),
                allowBlank  : false,
                tdAttrs     : {width: 380},
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    }
                }
            },{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				colspan		: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
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
                        	panelResult.setValue('PERSON_NUMB_TO', panelResult.getValue('PERSON_NUMB_FR'));
                            panelResult.setValue('NAME1', panelResult.getValue('NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('PERSON_NUMB_FR', '');
                        panelResult.setValue('NAME', '');
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
                fieldLabel      : '부서',
                valueFieldName  : 'DEPT_CODE_FR',
                textFieldName   : 'DEPT_NAME',
                validateBlank   : false,
                tdAttrs         : {width: 380},
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        	panelResult.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_FR'));
                            panelResult.setValue('DEPT_NAME1', panelResult.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('DEPT_CODE_FR', '');
                        panelResult.setValue('DEPT_NAME', '');
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
                colspan         : 2,
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('DEPT_CODE_TO', '');
                        panelResult.setValue('DEPT_NAME1', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),{
				fieldLabel	: '재직구분',
				name		: 'WORK_GB',
				id			: 'workGb',
				xtype		: 'uniRadiogroup',
				width		: 300,
				items		: [{
					boxLabel	: '전체',
					name		: 'WORK_GB',
					inputValue	: ''
				},{
					boxLabel	: '재직',
					name		: 'WORK_GB',
					inputValue	: '1'
				},{
					boxLabel	: '퇴직',
					name		: 'WORK_GB',
					inputValue	: '2'
				}],
				value		: '1'
			},{
                fieldLabel    : '발령구분',
                name        : 'ANNOUNCE_CODE',
                xtype        : 'uniCombobox',
                comboType   : 'AU',
                store:Ext.data.StoreManager.lookup("COMBO_ANLIST"),
                colspan     :2,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    }
                 }
            },{
                fieldLabel  : '출력구분',
                name        : 'RPT_TYPE',
                id          : 'rpttype',
                xtype       : 'uniRadiogroup',

                width       : 300,
                items       : [{
                    boxLabel    : '부서',
                    name        : 'RPT_TYPE',
                    inputValue  : '1'
                },{
                    boxLabel    : '직책',
                    name        : 'RPT_TYPE',
                    inputValue  : '2'
                }],
                value       : '1'
            }

		]
	});




	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_hum540skr_kdGrid1', {
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

        selModel: 'rowmodel',
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'				, width: 110	, hidden: true},
			{ dataIndex: 'PERSON_NUMB'				, width: 110	},
			{ dataIndex: 'PERSON_NAME'				, width: 110	},
			{ dataIndex: 'DEPT_CODE'				, width: 110	, hidden: true},
			{ dataIndex: 'DEPT_NAME'				, width: 110	, hidden: true},
			{ dataIndex: 'POST_CODE'				, width: 110	, hidden: true},
			{ dataIndex: 'POST_NAME'				, width: 110	, hidden: true},
			{ dataIndex: 'ANNOUNCE_CODE'			, width: 80		},
			{ dataIndex: 'ANNOUNCE_NAME'			, width: 80		},
			{ dataIndex: 'ANNOUNCE_DATE'			, width: 110	, align: 'center'},
			{ dataIndex: 'AF_PAY_GRADE_01_NAME'		, width: 110	},
			{ dataIndex: 'AF_PAY_GRADE_02'			, width: 110	},
			{ dataIndex: 'AF_PAY_GRADE_03_NAME'		, width: 110	},
			{ dataIndex: 'AF_PAY_GRADE_04_NAME'		, width: 110	},
			{ dataIndex: 'WAGES_AMT_01'				, width: 120	},
			{ dataIndex: 'WAGES_AMT_02'				, width: 120	},
			{ dataIndex: 'WAGES_AMT_03'				, width: 120	},
			{ dataIndex: 'WAGES_AMT_04'				, width: 120	},
			{ dataIndex: 'WAGES_AMT_05'				, width: 120	},
			{ dataIndex: 'WAGES_AMT_06'				, width: 120	},
			{ dataIndex: 'WAGES_AMT_07'				, width: 120	},
			{ dataIndex: 'WAGES_AMT_08'				, width: 120	},
			{ dataIndex: 'WAGES_AMT_09'				, width: 120	},
			{ dataIndex: 'WAGES_AMT_10'				, width: 120	},
			{ dataIndex: 'WAGES_AMT_11'				, width: 120	},
			{ dataIndex: 'WAGES_AMT_12'				, width: 120	},
			{ dataIndex: 'WAGES_AMT_TOT'			, width: 120	},
			{ dataIndex: 'REMARK'					, width: 150	}
		],
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});




	Unilite.Main({
		id  		: 's_hum540skr_kdApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],
		fnInitBinding : function() {
			//초기값 설정
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('ST_DATE_FR', new Date());
			panelResult.setValue('ST_DATE_TO', new Date());
			Ext.getCmp('workGb').setValue('1');

			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('PERSON_NUMB_FR');
			//버튼 설정
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
			//초기화 버튼 활성화
			UniAppManager.setToolbarButtons('reset', true);
		},

		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},

		requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var stdatefr      = UniDate.getDbDateStr(panelResult.getValue('ST_DATE_FR'));
            var stdateto      = UniDate.getDbDateStr(panelResult.getValue('ST_DATE_TO'));
            var userId      = UserInfo.userID
            var deptcodefr  = panelResult.getValue('DEPT_CODE_FR');
            var deptcodeto  = panelResult.getValue('DEPT_CODE_TO');
            var personnumbfr = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto = panelResult.getValue('PERSON_NUMB_TO');
            var rpttype =      Ext.getCmp('rpttype').getChecked()[0].inputValue;
            var announcecode = panelResult.getValue('ANNOUNCE_CODE');
            if(announcecode == null){
                announcecode = '';
            }
            var gubun       = Ext.getCmp('workGb').getChecked()[0].inputValue;


            //var record = masterGrid.getSelectedRecord();
            var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hum540skr&draft_no=0&sp=EXEC "


            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HUM540SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'"+ ', ' + "'" + stdatefr + "'"+ ', ' + "'" + stdateto + "'"
                            + ', ' + "'" + deptcodefr + "'"+ ', ' + "'" + deptcodeto + "'" + ', ' + "'" + personnumbfr + "'" + ', ' + "'" + personnumbto + "'"
                            + ', ' + "'" + gubun + "'"+ ', ' + "'" + rpttype + "'"+ ', ' + "'" + announcecode + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
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
