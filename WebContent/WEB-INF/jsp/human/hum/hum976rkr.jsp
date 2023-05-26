<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum976rkr"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">

var certi_Num = ''; // 증명번호 마지막 번호

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.human.printselection" default="출력선택"/>',
				id: 'optPrintGb',
				labelWidth: 90,
				items: [
				{
					boxLabel: '<t:message code="system.label.human.careercertificate" default="경력증명서"/>',
					width: 120,
					name: 'optPrint',
					inputValue: '0'
				},
				{
					boxLabel: '<t:message code="system.label.human.incumbentcertificate" default="재직증명서"/>',
					width: 120,
					name: 'optPrint',
					inputValue: '1',
					checked: true
				},
				{
					boxLabel: '<t:message code="system.label.human.retrcertificate" default="퇴직증명서"/>',
					width: 120,
					name: 'optPrint',
					inputValue: '2'
				}/*,
				{
					boxLabel: '<t:message code="system.label.human.certificateledger" default="증명서대장"/>',
					width: 120,
					name: 'optPrint',
					inputValue: '3',
					disabled :true
				}*/],
				listeners: {
					change: function(radiogroup, newValue, oldValue, eOpts) {
						//증명번호 가져오기
						var param = {"S_COMP_CODE": UserInfo.compCode,
									 "CERTI_TYPE": newValue.optPrint};
						hum976rkrService.fnHum970ini(param, function(provider, response){			// 증명번호 최신화
							if(!Ext.isEmpty(provider)){
								panelResult2.setValue('PROF_NUM' , provider);
							}
						});
						
						if(Ext.getCmp('optPrintGb').getValue().optPrint == '3') {
							Ext.getCmp('PERSON_NUMB').setReadOnly(true);
							Ext.getCmp('DIV_CODE').setReadOnly(true);
							Ext.getCmp('DATE').setReadOnly(true);
						} else {
							Ext.getCmp('PERSON_NUMB').setReadOnly(false);
							Ext.getCmp('DIV_CODE').setReadOnly(false);
							Ext.getCmp('DATE').setReadOnly(false);
						}
					},
					onTextSpecialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							panelResult2.getField('NAME').focus();
						}
					}
				}
			}]
	});	
	
	var panelResult2 = Unilite.createSearchForm('resultForm2',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'west',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [
			Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
				valueFieldName:'PERSON_NUMB',
				textFieldName:'NAME',
				validateBlank:true,
				autoPopup:true,
				allowBlank: false,
				id : 'PERSON_NUMB', 
				listeners: {
					'onSelected': {
						fn: function(records, type) {
							panelResult2.setValue('PERSON_NUMB', records[0].PERSON_NUMB);
							panelResult2.setValue('NAME', 		 records[0].NAME);
							panelResult2.setValue('DIV_CODE',	 records[0].DIV_CODE);
							panelResult2.setValue('ANN_FR_DATE', records[0].JOIN_DATE);
							panelResult2.setValue('RETR_DATE'  , records[0].RETR_DATE);
							//RETR_DATE
							
							if(records[0].RETR_DATE == '' || records[0].RETR_DATE == '00000000'){
								panelResult2.setValue('ANN_TO_DATE', UniDate.get('today'));
							}else{
								panelResult2.setValue('ANN_TO_DATE', records[0].RETR_DATE);
							}
						},
						scope: this
					},
					'onClear': function(type) {
						panelResult2.setValue('PERSON_NUMB','');
						panelResult2.setValue('NAME','');
						panelResult2.setValue('DIV_CODE','');
						panelResult2.setValue('ANN_FR_DATE','');
						panelResult2.setValue('ANN_TO_DATE','');
						panelResult2.setValue('RETR_DATE','');
					},
					applyextparam: function(popup){	
						popup.setExtParam({'BASE_DT': '00000000'});
						popup.setExtParam({'PAY_GUBUN': ''});
					}
 				}
			}),{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
				name:'DIV_CODE', 
				id : 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank: false
			},{ 
				fieldLabel: '<t:message code="system.label.human.workprod" default="근무기간"/>',
				xtype: 'uniDateRangefield',
				id : 'DATE',
				startFieldName: 'ANN_FR_DATE',
				endFieldName: 'ANN_TO_DATE',
				width: 325,
				allowBlank: false
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				width:600,
				items :[{
					fieldLabel: '<t:message code="system.label.human.certificatenum" default="증명번호"/>',
					name:'PROF_NUM',
					xtype: 'uniTextfield',
					allowBlank: false
				},{
					fieldLabel: '정상출력',
					labelWidth: 60,
					name: 'CHK_PRINT',
					xtype: 'checkboxfield'
				}]
			},{
				fieldLabel: '<t:message code="system.label.human.issuedate" default="발급일"/>',
				xtype: 'uniDatefield',
				name: 'ISS_DATE',
				value: UniDate.get('today'),
				allowBlank: false
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:600,
				items :[{
					fieldLabel:'<t:message code="system.label.human.applynum" default="신청통수"/>',
					xtype: 'uniTextfield',
					name: 'SEQ_FR',
					width:198
				},{
					xtype:'component',
					html:'/',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
	 				fieldLabel:'',
					xtype: 'uniTextfield',
					name: 'SEQ_TO',
					width:113
				}]
			},{
				fieldLabel: '<t:message code="system.label.human.usage" default="용도"/>',
				xtype: 'uniTextfield',
				name: 'USE',
				width: 405
			},{
				fieldLabel: '<t:message code="system.label.human.submitplace" default="제출처"/>',
				xtype: 'uniTextfield',
				name: 'SUBMIT_PLACE',
				width: 405
			},{
				fieldLabel: '<t:message code="system.label.human.jobcode1" default="담당업무"/>',
				xtype: 'uniTextfield',
				name: 'JOB_CODE',
				width: 405
			},{
				xtype: 'radiogroup',
				id: 'rdoEncrypt',
				fieldLabel: '<t:message code="system.label.human.socialsecuritynumberencryption" default="주민번호 암호화"/>',
				labelWidth: 90,
				items: [{
					boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
					width: 50, 
					name: 'rdoEncrypt',
					inputValue: 'Y',
					checked: true  
				},{
					boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',  
					width: 70, 
					name: 'rdoEncrypt',
					inputValue: 'N'
				}]
			},{
				fieldLabel: '<t:message code="system.label.human.retrdate" default="퇴사일"/>',
				name:'RETR_DATE',
				xtype: 'uniTextfield',
				hidden : true
			},{
				fieldLabel: '직인출력',
				name: 'PRINT_STAMP',
				xtype: 'checkboxfield',
				value : true
			},{
				margin:'15 0 0 20',
				xtype:'container',
				html: '<b>※ <t:message code="system.label.human.precaution" default="주의사항"/></b>',
				style: {
					color: 'blue'
				}
			},{
				xtype:'container',
				html: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <t:message code="system.message.human.message138" default="정상출력에 체크가 되어있는 경우에만 증명번호가 카운팅 됩니다."/>' + '</br>',
				style: {
					color: 'blue'
				}
			},{
				xtype:'button',
				text:'<t:message code="system.label.human.print" default="출력"/>',
				width:235,
				tdAttrs:{'align':'left', style:'padding-left:95px'},
				handler:function()	{
					UniAppManager.app.onPrintButtonDown();
				}
			}]
	});
	
	Unilite.Main({
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, panelResult2
			]
		}
		],
		id: 'hum976rkrApp',
		fnInitBinding : function() {
			
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
			
			var param = {"S_COMP_CODE": UserInfo.compCode,
						 "CERTI_TYPE": '1'}; //재직증명서 inputValue 강제지정
			hum976rkrService.fnHum970ini(param, function(provider, response){			// 증명번호 최신화
				if(!Ext.isEmpty(provider)){
					panelResult2.setValue('PROF_NUM' , provider);
				}
			});
		},
		onPrintButtonDown: function() {
			var chk_print = panelResult2.getValue('CHK_PRINT');
			var doc_Kind = Ext.getCmp('optPrintGb').getValue().optPrint;
			var printChk = panelResult2.getValue('RETR_DATE');
			
			if(doc_Kind == '1'){
				if(printChk != '' || printChk == '00000000'){
					Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>','<t:message code="system.message.human.message028" default="퇴직 한 사원은 재직증명서를 발급할 수 없습니다."/>');
					return false;
				}
			}
			
			if(doc_Kind == '2'){
				if(printChk == ''){
					Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>','<t:message code="system.message.human.message029" default="현재 재직 중인 사원은 퇴직증명서를 발급할 수 없습니다."/>');
					return false;
				}
			}
			
			if(doc_Kind != '3'){
				if(!panelResult2.getInvalidMessage()) return;
			}
			
			var annFrDate = panelResult2.getValue('ANN_FR_DATE');
			var annToDate = panelResult2.getValue('ANN_TO_DATE');
			annFrDate = UniDate.getDbDateStr(annFrDate);
			annToDate = UniDate.getDbDateStr(annToDate);
			
			if( annFrDate > annToDate ){		// 근무기간 Check
				return false;
			}
			
			var title_Doc	= '';
			var text_Doc	= '';
			var use_Doc		= '';
			var seq_to		= 1;
			
			if(doc_Kind == '0'){
				title_Doc = '경력증명서';
				text_Doc  = '상기와 같이 재직하였음을 증명합니다.';
				
			} else if(doc_Kind == '1' ){
				title_Doc = '재직증명서';
				text_Doc  = '상기인은 현재 재직중에 있음을 증명합니다.';
				
			} else if(doc_Kind == '2'){
				title_Doc = '퇴직증명서';
				text_Doc  = '상기인은 현재 퇴직 하였음을 증명합니다.';
				
			} else if(doc_Kind == '3'){
				title_Doc = ' 증명서 대장';
				text_Doc  = 'empty';
			}
			
			var param  = Ext.getCmp('resultForm').getValues();			// 상단 증명서 종류
			var param2 = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건 
			
			if(Ext.isEmpty(param2.USE)){
				use_Doc = '';
			} else {
				use_Doc = param2.USE;
			}
			
			if(!Ext.isEmpty(param2.SEQ_TO)) {
				seq_to = Number(param2.SEQ_TO);
			}
			
			var param = {
				// 경력증명서 : 0, 재직증명서 : 1 , 퇴직증명서 : 2,  증명서 대장 : 3
				DOC_KIND		: Ext.getCmp('optPrintGb').getValue().optPrint,					// bParam(0)  증명서 종류 
				PERSON_NUMB		: param2.PERSON_NUMB,											// bParam(1)
				ISS_DATE		: param2.ISS_DATE,												// bParam(2)
				PROF_NUM		: param2.PROF_NUM,												// bParam(3)
				ANN_FR_DATE		: param2.ANN_FR_DATE,											// bParam(4)
				ANN_TO_DATE		: param2.ANN_TO_DATE,											// bParam(5) 
				DIV_CODE		: param2.DIV_CODE,												// bParam(7)
				COMP_CODE		: UserInfo.compCode,											// bParam(8)  도장이미지 포함
				SYS_DATE		: UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4),	// bParam(9)
				ENCRYPT			: Ext.getCmp('rdoEncrypt').getChecked()[0].inputValue,			// bParam(10) 암호화
				
				// 레포트로 파라미터 넘기기 매개변수 (조회와 관련 없음)
				TITLE			: title_Doc,													// 제목
				TEXT			: text_Doc,														// 내용
				SEQ_COUNT		: param2.SEQ_FR + "  " + Msg.sMH1225 + "  /  " + param2.SEQ_TO + "  " + Msg.sMH1225,	// 신청통수 
				SEQ_TO			: seq_to,														// 신청통수 
				USE				: use_Doc,														// 용도
				SUBMIT_PLACE	: param2.SUBMIT_PLACE,											// 제출처
				JOB_CODE		: param2.JOB_CODE,												// 담당업무
				PRINT_STAMP		: (panelResult2.getValue('PRINT_STAMP') ? 'Y' : 'N'),			// 직인출력여부
				PGM_ID			: PGM_ID,
				MAIN_CODE		: 'H240'														// 인사
			}
			
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/human/hum976clrkrv.do',
				prgID: 'hum976rkr',
				extParam: param
			});
			win.center();
			win.show();
			
			if(doc_Kind != '3' && chk_print == true){
				UniAppManager.app.fnUpdateChanges(doc_Kind);
			}
		},
		fnUpdateChanges : function(doc_Kind) {
			var param = Ext.getCmp('resultForm2').getValues();
			var bParam0 = Ext.getCmp('optPrintGb').getValue().optPrint;
			var bParam4 = '1'	// 한글
			
			if(bParam0 == '1'){
				bParam0 = '1';
			}else if(bParam0 == '2'){
				bParam0 = '2';
			}else{
				bParam0 = '0';
			}
			
			param.CERTI_TYPE	= doc_Kind;
			param.optPrint		= bParam0;
			param.bParam4		= bParam4;
			
			hum976rkrService.insertDetail(param, function(provider, response){
				hum976rkrService.fnHum970ini(param, function(provider2, response){
					if(!Ext.isEmpty(provider2)){
						panelResult2.setValue('PROF_NUM', provider2);
					}
				});
			});
		}
	}); //End of 	Unilite.Main( {
	
	Unilite.createValidator('validator01', {
		forms: {'formA:':panelResult2},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "SEQ_FR" : // 신청통수 FR
					if(isNaN(newValue)) {
						alert(Msg.sMB074);		//숫자만 입력 가능합니다.
						return;
						break;
					}
					break;
				case "SEQ_TO" : // 신청통수 TO
					if(isNaN(newValue)) {
						alert(Msg.sMB074);		//숫자만 입력 가능합니다.
						return;
						break;
					}
				break;
			}
			return rv;
		}
	}); // validator
};

</script>
