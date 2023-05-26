<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb130rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo =  {
	
};
var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수
var gsChargeCode = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode} ;				//ChargeCode 관련 전역변수
var drAmtI	= 0;
var crAmtI	= 0;
var janAmtI	= 0;
var forAmtI	= 0;
var postitWindow;

function appMain() {   
	var panelSearch = Unilite.createSearchForm('agb130rkrForm', {
		region: 'center',
		disabled :false,
		border: false,
		flex:1,
		layout: {
			type: 'uniTable',
			columns:1
		},
		defaults:{
			width:325,
			labelWidth:90
		},
		defaultType: 'uniTextfield',
		padding:'20 0 0 0',
		width:400,
		items : [{
			fieldLabel: '전표일',
			xtype: 'uniDateRangefield',
			startFieldName: 'AC_DATE_FR',
			endFieldName: 'AC_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false
		},
		Unilite.popup('ACCNT',{
			fieldLabel: '계정과목',
			validateBlank:true,
			allowBlank: false, 
			valueFieldName: 'ACCNT_CODE',
			textFieldName: 'ACCNT_NAME',
			extParam: {	'CHARGE_CODE': gsChargeCode[0].SUB_CODE,
						'ADD_QUERY': "(SPEC_DIVI = 'A')"},
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue) {
					if(newValue == '') {
						panelSearch.setValue('ACCNT_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue) {
					if(newValue == '') {
						panelSearch.setValue('ACCNT_CODE', '');
					}
				},
				onSelected: {
					fn: function(records, type) {
						if(!Ext.isEmpty(panelSearch.getValue('ACCNT_CODE'))) {
							UniAppManager.app.fnGetAccntInfo(panelSearch.getValue('ACCNT_CODE'));
						}
						else {
							panelSearch.down('#formFieldArea1').show();
							panelSearch.down('#formFieldArea2').show();
							panelSearch.down('#conArea1').show();
							panelSearch.down('#conArea2').show();
						}
						/**
						 * 계정과목 동적 팝업
						 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
						 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
						 *  valueFieldName    textFieldName 		valueFieldName     textFieldName		 	valueFieldName    textFieldName
						 *    PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	   BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
						 * -------------------------------------------------------------------------------------------------------------------------
						 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
						 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
						 *    PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
						 * */
//						var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
//						accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
//							var dataMap = provider;
//							var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
//							UniAccnt.addMadeFields(panelSearch, dataMap, null, opt);
//							panelSearch.down('#conArea1').show();
//							panelSearch.down('#conArea2').show();
//							panelSearch.down('#formFieldArea1').show();
//							panelSearch.down('#formFieldArea2').show();
//							
//							panelSearch.down('#serach_ViewPopup1').hide();
//							panelSearch.down('#serach_ViewPopup2').hide();
//						});
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.down('#serach_ViewPopup1').show();
					panelSearch.down('#serach_ViewPopup2').show();
					// onClear시 removeField..
					panelSearch.down('#conArea1').hide();
					panelSearch.down('#conArea2').hide();
				}
			}
		}),{
			xtype: 'container',
			colspan: 1,
			itemId: 'serach_ViewPopup1', 
			layout: {
				type: 'table', 
				columns:1,
				itemCls:'table_td_in_uniTable',
				tdAttrs: {
					width: 350
				}
			},
			items:[
				Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
					fieldLabel: '계정항목1',
					validateBlank:false
				})
			]
		},{
			xtype: 'container',
			colspan: 1,
			itemId: 'serach_ViewPopup2',
			layout: {
				type: 'table', 
				columns:1,
				itemCls:'table_td_in_uniTable',
				tdAttrs: {
					width: 350
				}
			},
			items:[
				Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
					fieldLabel: '계정항목2',
					validateBlank:false
				})
			]
		},{
			xtype: 'container',
			itemId: 'conArea1',
			items:[{
				xtype: 'container',
				colspan: 1,
				itemId: 'formFieldArea1', 
				layout: {
					type: 'table', 
					columns:1,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
					}
				}
			}]
		},{
			xtype: 'container',
			itemId: 'conArea2',
			items:[{
				xtype: 'container',
				colspan: 1,
				itemId: 'formFieldArea2', 
				layout: {
					type: 'table', 
					columns:1,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
					}
				}
			}]
		},
		Unilite.popup('ACCNT',{
			fieldLabel: '상대계정',
//			validateBlank:false,	 
			valueFieldName: 'P_ACCNT_CD',
			textFieldName: 'P_ACCNT_NM',
			autoPopup:true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
//						panelResult.setValue('P_ACCNT_CD', panelSearch.getValue('P_ACCNT_CD'));
//						panelResult.setValue('P_ACCNT_NM', panelSearch.getValue('P_ACCNT_NM'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
//					panelResult.setValue('P_ACCNT_CD', '');
//					panelResult.setValue('P_ACCNT_NM', '');
				}
			}
		}),{ 
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			multiSelect: true, 
			typeAhead: false,
			value : UserInfo.divCode,
			comboType: 'BOR120'
		},{
			fieldLabel: '당기시작년월',
			name: 'START_DATE',
			xtype: 'uniMonthfield',
			allowBlank:false,
			width:250
		},
		Unilite.popup('ACCNT_PRSN',{
			fieldLabel: '입력자',
			valueFieldName:'CHARGE_CODE',
			textFieldName:'CHARGE_NAME',
			validateBlank:false
		}),{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:600,
			items :[{
				fieldLabel:'금액', 
				xtype: 'uniNumberfield',
				name: 'AMT_FR', 
				width: 203
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniNumberfield',
				name: 'AMT_TO', 
				width: 113
			}]
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:600,
			items :[{
				fieldLabel:'외화금액', 
				xtype: 'uniNumberfield',
				name: 'FOR_AMT_FR', 
				width: 203
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniNumberfield',
				name: 'FOR_AMT_TO', 
				width: 113
			}]
		},
		Unilite.popup('REMARK',{
			fieldLabel: '적요',
			name: 'REMARK',
			validateBlank:false
		}),
		Unilite.popup('DEPT',{
			fieldLabel: '~',
			valueFieldName:'DEPT_CODE_TO',
			textFieldName:'DEPT_NAME_TO',
			autoPopup: true,
//			validateBlank:false,						//autoPopup: true, 추가하면서 주석처리
			extParam:{'CUSTOM_TYPE':'3'}
		}),{
			fieldLabel: '출력조건',
			name: '',
			xtype: 'checkboxgroup', 
			width: 400, 
			items: [{
				boxLabel: '수정삭제이력표시',
				name: 'CHECK_DELETE',
				width: 150,
				uncheckedValue: 'N',
				inputValue: 'Y'
			},{
				boxLabel: '각주',
				name: 'CHECK_POST_IT',
				width: 100,
//				uncheckedValue: 'N',
				inputValue: 'Y',
				listeners: {
				 	change: function(field, newValue, oldValue, eOpts) {
				 		if(panelSearch.getValue('CHECK_POST_IT')) {
							panelSearch.getField('POST_IT').setReadOnly(false);
				 		} else {
							panelSearch.getField('POST_IT').setReadOnly(true);
				 		}
					}
				}
			}]
		},{
			xtype: 'uniTextfield',
			fieldLabel: '각주',
			width: 325,
			name:'POST_IT',
			readOnly: true
		},
		{
			xtype: 'radiogroup',    
			colspan: 4,
			fieldLabel: '출력형식',
			id: 'RPT_SIZE_RADIO',
			items: [{
				boxLabel: '가로', 
				width: 82, 
				name: 'RPT_SIZE', 
				inputValue: '1'
			},{
				boxLabel: '세로', 
				width: 82, 
				name: 'RPT_SIZE', 
				inputValue: '2',
				checked : true
			}]
		},{
			xtype:'button',
			text:'출    력',
			width:235,
			tdAttrs:{'align':'left', style:'padding-left:95px'},
			handler:function()	{
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});
	
	Unilite.Main({
		border: false,
		items:[
			panelSearch
		],
		id : 'agb130rkrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
//			panelSearch.down('#formFieldArea1').hide();
//			panelSearch.down('#formFieldArea2').hide();
//			panelSearch.down('#conArea1').hide();
//			panelSearch.down('#conArea2').hide();
			//당기시작년월 세팅
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			//상단 툴바버튼 세팅
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',false);
			
			if(!Ext.isEmpty(params.AC_DATE_FR)){
				this.processParams(params);
			}
		},
		//링크로 넘어오는 params 받는 부분 
		processParams: function(param) {
			//agb130skr.jsp(현금출납장)에서 링크걸려옴
			panelSearch.setValue('AC_DATE_FR'	, param.AC_DATE_FR);
			panelSearch.setValue('AC_DATE_TO'	, param.AC_DATE_TO);
			panelSearch.setValue('ACCNT_CODE'	, param.ACCNT_CODE);
			panelSearch.setValue('ACCNT_NAME'	, param.ACCNT_NAME);
			panelSearch.setValue('DIV_CODE'		, param.DIV_CODE);
			panelSearch.setValue('P_ACCNT_CD'	, param.P_ACCNT_CD);
			panelSearch.setValue('P_ACCNT_NM'	, param.P_ACCNT_NM);
			panelSearch.setValue('CHECK_DELETE'	, param.CHECK_DELETE);
			panelSearch.setValue('CHECK_POST_IT', param.CHECK_POST_IT);
			panelSearch.setValue('POST_IT'		, param.POST_IT);
			panelSearch.setValue('START_DATE'	, param.START_DATE);
			panelSearch.setValue('CHARGE_CODE'	, param.CHARGE_CODE);
			panelSearch.setValue('CHARGE_NAME'	, param.CHARGE_NAME);
			panelSearch.setValue('AMT_FR'		, param.AMT_FR);
			panelSearch.setValue('AMT_TO'		, param.AMT_TO);
			panelSearch.setValue('REMARK_CODE'	, param.REMARK_CODE);
			panelSearch.setValue('REMARK_NAME'	, param.REMARK_NAME);
			panelSearch.setValue('REMARK'		, param.REMARK);
			panelSearch.setValue('FOR_AMT_FR'	, param.FOR_AMT_FR);
			panelSearch.setValue('FOR_AMT_TO'	, param.FOR_AMT_TO);
			panelSearch.setValue('DEPT_CODE_FR'	, param.DEPT_CODE_FR);
			panelSearch.setValue('DEPT_NAME_FR'	, param.DEPT_NAME_FR);
			panelSearch.setValue('DEPT_CODE_TO'	, param.DEPT_CODE_TO);
			panelSearch.setValue('DEPT_NAME_TO'	, param.DEPT_NAME_TO);
			
			if(!Ext.isEmpty(param.ACCNT_CODE)) {
				UniAppManager.app.fnGetAccntInfo(param.ACCNT_CODE);
			}
			else {
				panelSearch.down('#formFieldArea1').show();
				panelSearch.down('#formFieldArea2').show();
				panelSearch.down('#conArea1').show();
				panelSearch.down('#conArea2').show();
			}
		},
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			var param= panelSearch.getValues();
			
			param["sTxtValue2_fileTitle"]='현급출납장';	
			
			//param.ACCNT_DIV_CODE = panelSearch.getValue('DIV_CODE').join(",");
			param.DIV_CODE = panelSearch.getValue('DIV_CODE').join(",");
			param.ACCNT_DIV_NAME = panelSearch.getField('DIV_CODE').getRawValue();
			
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/accnt/agb130clrkr.do',
				prgID: 'agb130rkr',
				extParam: param
			});
			win.center();
			win.show();
		},
		fnGetAccntInfo: function(accnt) {
			/**
			 * 계정과목 동적 팝업
			 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
			 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
			 *  valueFieldName    textFieldName 		valueFieldName     textFieldName		 	valueFieldName    textFieldName
			 *    PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	   BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
			 * -------------------------------------------------------------------------------------------------------------------------
			 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
			 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
			 *    PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
			 * */
			var param = {ACCNT_CD : accnt};
			accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
				var dataMap = provider;
				var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
				
				UniAccnt.addMadeFields(panelSearch, dataMap, null, opt);
				
				panelSearch.down('#conArea1').show();
				panelSearch.down('#conArea2').show();
				panelSearch.down('#formFieldArea1').show();
				panelSearch.down('#formFieldArea2').show();
				
				panelSearch.down('#serach_ViewPopup1').hide();
				panelSearch.down('#serach_ViewPopup2').hide();
			});
		}
	});
};

</script>
