<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat880skr_kd">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="H004" />					<!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> 				<!-- 직책 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hat880skr_kdModel', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'			,type: 'string'},
			{name: 'QUERY_SEQ'			,text: 'SEQ'				,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'				,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'					,type: 'string'},
			{name: 'POST_CODE'			,text: '직위'					,type: 'string'		, comboType: "AU"	, comboCode: "H005"},
			{name: 'DUTY_TO_H'			,text: '퇴근시간'				,type: 'string'},
			{name: 'OVERTIME_3_H'		,text: '야간근무'				,type: 'string'},
			{name: 'OVERTIME_2_H'		,text: '추가연장'				,type: 'string'},
			{name: 'OVERTIME_1_H'		,text: '기본연장'				,type: 'string'},
			{name: 'CONFIRM'			,text: '본인확인'				,type: 'string'},
			{name: 'REMARK'				,text: '비고'					,type: 'string'},
			{name: 'WORK_TEAM'			,text: '근무조'				,type: 'string'},
			{name: 'DUTY_DATE'			,text: '근태일자'				,type: 'string'}

		]
	});
	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('s_hat880skr_kdMasterStore1',{
		model	: 's_hat880skr_kdModel',
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
					read: 's_hat880skr_kdService.selectList'
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
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel	: '근태일',	
				name		: 'DUTY_DATE', 
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
				value		: UserInfo.divCode,
				colspan		: 2,
//				multiSelect	: true, 
//				typeAhead	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
		 		}
			}, 
			Unilite.popup('Employee',{
				fieldLabel		: '사원',
				valueFieldName	: 'PERSON_NUMB_FR',
				textFieldName	: 'NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB_TO', panelResult.getValue('PERSON_NUMB_FR'));
							panelResult.setValue('NAME1', panelResult.getValue('NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
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
                autoPopup       : true,
                colspan     : 2,
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
				fieldLabel		: '부서',
				valueFieldName	: 'DEPT_CODE_FR',
				textFieldName	: 'DEPT_NAME',
				validateBlank	: false,					
				tdAttrs			: {width: 380},  
				listeners		: {
					onSelected: {
						fn: function(records, type) {
                            panelResult.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_FR'));
                            panelResult.setValue('DEPT_NAME1', panelResult.getValue('DEPT_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
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
                tdAttrs         : {width: 380},  
                colspan     : 2,
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
//                          dataForm.setValue('S_DEPT_CODE', records[0].DEPT_CODE);
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
                fieldLabel  : '확정여부',
                name        : 'APPLY_YN',
                id          : 'apply_yn',
                xtype       : 'uniRadiogroup',
                width       : 300,
                items       : [{
                    boxLabel    : '확정',
                    name        : 'APPLY_YN',
                    inputValue  : '1'                               
                },{
                    boxLabel    : '전체',
                    name        : 'APPLY_YN',
                    inputValue  : '2'
                }], 
                value       : '2'
            },{       
                fieldLabel  : '구분',
                name        : 'WORK_GB',
                id          : 'work_gb',
                xtype       : 'uniRadiogroup',
                width       : 300,
                items       : [{
                    boxLabel    : '주간',
                    name        : 'WORK_GB',
                    inputValue  : '1'                               
                },{
                    boxLabel    : '야간',
                    name        : 'WORK_GB',
                    inputValue  : '2'
                },{
                    boxLabel    : '전체',
                    name        : 'WORK_GB',
                    inputValue  : '3'
                }], 
                value       : '3'
            }
		]
	});
	
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_hat880skr_kdGrid1', {
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
                
                    //param.DRAFT_NO = "0";
                    if(confirm('기안 하시겠습니까?')) {
                       UniAppManager.app.requestApprove();
                    }
                    //UniAppManager.app.onQueryButtonDown();
                }
            }
        ],
		
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} 
		],
	    
	    selModel:'rowmodel',
		
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'QUERY_SEQ'		, width: 110	, hidden: true},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'POST_CODE'		, width: 90		},
			{ dataIndex: 'DUTY_TO_H'		, width: 100	},
			{ dataIndex: 'OVERTIME_3_H'		, width: 100	},
			{ dataIndex: 'OVERTIME_2_H'		, width: 100	},
			{ dataIndex: 'OVERTIME_1_H'		, width: 100	},
			{ dataIndex: 'CONFIRM'			, width: 90		},
			{ dataIndex: 'REMARK'			, width: 200	},
			{ dataIndex: 'WORK_TEAM'		, width: 110	, hidden: true},
			{ dataIndex: 'DUTY_DATE'		, width: 110	, hidden: true}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
 
	
	
	
	Unilite.Main({
		id  : 's_hat880skr_kdApp',
		borderItems:[{
		  region:'center',
		  layout: {type: 'vbox', align: 'stretch'},
		  border: false,
		  items:[
				panelResult, masterGrid 
		  ]}
		], 
		fnInitBinding : function() {
			//초기값 설정
			panelResult.setValue('DUTY_DATE'	, new Date());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DUTY_DATE');
			//버튼 설정
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
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
            var userId      = UserInfo.userID
                        
            var deptcodefr    = panelResult.getValue('DEPT_CODE_FR');
            var deptcodeto    = panelResult.getValue('DEPT_CODE_TO');
            var personnumbfr  = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto  = panelResult.getValue('PERSON_NUMB_TO');
            
            var dutyDate      = UniDate.getDbDateStr(panelResult.getValue('DUTY_DATE'));
            
            var applyyn       = Ext.getCmp('apply_yn').getChecked()[0].inputValue
            var workgb        = Ext.getCmp('work_gb').getChecked()[0].inputValue

            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HAT880SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + dutyDate + "'" 
                            + ', ' + "'" + divCode + "'" + ', ' + "'" + deptcodefr + "'" +', ' + "'" + deptcodeto + "'" 
                            + ', ' + "'" + personnumbfr + "'"   + ', ' + "'" + personnumbto + "'"
                            + ', ' + "'" + applyyn + "'" + ', ' + "'" + workgb + "'" + ', ' + "''"
                            + ', '+ "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
            var spCall      = encodeURIComponent(spText); 
            
            var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hat880skr&draft_no=0&sp=EXEC " 

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