<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hum530skr_kd">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="HX01" />                    <!-- 상벌구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hum530skr_kdModel', {
		fields: [
			{name: 'COMP_CODE'			,text: 'COMP_CODE'					,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'						,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'						,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'						,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'							,type: 'string'},
			{name: 'NAME_PRIZE_PENALTY'	,text: '구분'							,type: 'string'},
			{name: 'OCCUR_DATE'			,text: '상벌일자'						,type: 'string'},
			{name: 'REASON'				,text: '상벌내용'						,type: 'string'},
			{name: 'RELATION_ORGAN'		,text: '시행처'						,type: 'string'},
			{name: 'PRIZE_BASIS'		,text: '상벌근거'						,type: 'string'},
			{name: 'REMARK'				,text: '비고'							,type: 'string'}
		]
	});
	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('s_hum530skr_kdMasterStore1',{
		model	: 's_hum530skr_kdModel',
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
					read: 's_hum530skr_kdService.selectList'
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
		items	: [{
                fieldLabel  : '사업장',
                name        : 'DIV_CODE', 
                xtype       : 'uniCombobox',
                comboType   : 'BOR120',
                value       : UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    }
                }
            },{
                fieldLabel  : '상벌기간',
                xtype       : 'uniDateRangefield',       
                startFieldName: 'ST_DATE_FR',
                endFieldName: 'ST_DATE_TO',
                startDate: UniDate.get('today'), 
                endDate: UniDate.get('today'),             
                allowBlank  : false,
                tdAttrs     : {width: 380},
                colspan     : 2,
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
                fieldLabel    : '상벌구분',
                name        : 'KIND_PRIZE_PENALTY',
                xtype        : 'uniCombobox',
                comboType   : 'AU',
                comboCode    : 'HX01',
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
	var masterGrid = Unilite.createGrid('s_hum530skr_kdGrid1', {
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
        selModel: 'rowmodel',
        
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
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'			, width: 110	, hidden: true},
			{ dataIndex: 'DEPT_CODE'			, width: 110	},
			{ dataIndex: 'DEPT_NAME'			, width: 110	},
			{ dataIndex: 'PERSON_NUMB'			, width: 110	},
			{ dataIndex: 'PERSON_NAME'			, width: 110	},
			{ dataIndex: 'NAME_PRIZE_PENALTY'	, width: 80		},
			{ dataIndex: 'OCCUR_DATE'			, width: 90		},
			{ dataIndex: 'REASON'				, width: 150	},
			{ dataIndex: 'RELATION_ORGAN'		, width: 100	},
			{ dataIndex: 'PRIZE_BASIS'			, width: 150	},
			{ dataIndex: 'REMARK'				, width: 200	}
		],
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	

	
	
	
	Unilite.Main({
		id  		: 's_hum530skr_kdApp',
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
            var userId      = UserInfo.userID
            var personnumbfr  = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto  = panelResult.getValue('PERSON_NUMB_TO');
            var deptcodefr    = panelResult.getValue('DEPT_CODE_FR');
            var deptcodeto    = panelResult.getValue('DEPT_CODE_TO');
            var stdatefr    = UniDate.getDbDateStr(panelResult.getValue('ST_DATE_FR'));
            var stdateto    = UniDate.getDbDateStr(panelResult.getValue('ST_DATE_TO'));
            
            var kindprizepenalty    = panelResult.getValue('KIND_PRIZE_PENALTY');
            if(kindprizepenalty == null){
            	kindprizepenalty = '';
            }
            var gubun       = Ext.getCmp('workGb').getChecked()[0].inputValue

            var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hum530skr&draft_no=0&sp=EXEC " 
                        
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HUM530SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                            + ', ' + "'" + stdatefr + "'" +', ' + "'" + stdateto + "'" +', ' + "'" + deptcodefr + "'" +', ' + "'" + deptcodeto + "'" + ', ' + "'" + personnumbfr + "'"+ ', ' + "'" + personnumbto + "'"  
                            + ', ' + "'" + gubun + "'" + ', ' + "'" + kindprizepenalty + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
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
