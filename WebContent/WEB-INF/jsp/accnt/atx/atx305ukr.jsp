<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="atx305ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="B002" /> <!-- 법인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B012" /> <!-- 국가코드 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 자사화폐 -->
	<t:ExtComboStore items="${BILL_DIV_CODE}" storeId="billDivCode" /> <!-- 신고사업장 -->
	

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.x-change-cell-grey {color: #747474;}
</style>
</t:appConfig>
<script type="text/javascript" >

var getTaxBase = '${getTaxBase}';
var getBillDivCode = '${getBillDivCode}';

function appMain() {
	
	Unilite.defineModel('Atx305ukrModel', {
		fields: [
		    {name: 'SEQ'		    ,text: '순번'					    ,type: 'int'},
			{name: 'CODE_NAME'		,text: '파일생성서류'					,type: 'string'},
			{name: 'EXIST_YN'	    ,text: '첨부여부'					,type: 'string'}

		]
	});	
	
	
	var directMasterStore = Unilite.createStore('atx305ukrMasterStore', {
		model	: 'Atx305ukrModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼,상태바 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 'atx305ukrService.selectMasterCodeList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params: param
			});
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
			}
		}
	});	
	
	Ext.create('Ext.data.Store',{
		storeId: "reportTypeStore",
		data:[
			{text: '정기신고', value: '01'},
			{text: '수정신고', value: '02'}
		]
	});
	
	var panelFileDown = Unilite.createForm('FileDownForm', {
		url: CPATH+'/accnt/fileDown2.do',
		colspan: 2,
		layout: {type: 'uniTable', columns: 1},
		height: 30,
		padding: '0 0 0 195',
		disabled:false,
		autoScroll: false,
		standardSubmit: true,  
		items:[{
			xtype: 'uniTextfield',
			name: 'PUB_DATE_FR'
		},{
			xtype: 'uniTextfield',
			name: 'PUB_DATE_TO'
		},{
			xtype: 'uniTextfield',
			name: 'BILL_DIV_CODE'
		},{
			xtype: 'uniTextfield',
			name: 'HOMETAX_ID'
		},{
			xtype: 'uniDatefield',
			name: 'WRITE_DATE'
		},{
			xtype: 'uniTextfield',
			name: 'RDO_INCLUDE'
		},{
			xtype: 'uniTextfield',
			name: 'AC_DATE_FR'
		},{
			xtype: 'uniTextfield',
			name: 'AC_DATE_TO'
		},{
			xtype: 'uniTextfield',
			name: 'REPORT_TYPE'
		},{
			xtype: 'uniTextfield',
			name: 'DEGREE'
		}]
	});
	
	var panelSearch = Unilite.createForm('searchForm', {
		disabled :false,
		region : 'west',
//		flex:1,
		layout: {type: 'uniTable', columns: 3, tdAttrs: {valign:'top'}},
		defaults: {labelWidth: 80},
		items: [{
				fieldLabel: '과세기간',
				xtype: 'uniMonthRangefield',  
				startFieldName: 'PUB_DATE_FR',
				endFieldName: 'PUB_DATE_TO',
				width: 470,
				startDD: 'first',
				endDD: 'last',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == '2'){
							panelSearch.setValue('AC_DATE_FR', newValue);
						}
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == '2'){
							panelSearch.setValue('AC_DATE_TO', newValue);
						}
					}
				}
			},{
				fieldLabel	: '신고구분',
				name		:'REPORT_TYPE',	
				xtype		: 'uniCombobox',
				value		: '01',
				allowBlank	: false,
				store		: Ext.data.StoreManager.lookup('reportTypeStore'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue == "01"){ 
							panelSearch.setValue('DEGREE', '');
						} else {
							panelSearch.setValue('DEGREE', '1');
						}
					}
				}
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: '차수',
				name		: 'DEGREE',
				readOnly	: true
			},{
				fieldLabel: '신고사업장',
				name:'BILL_DIV_CODE',
				xtype: 'uniCombobox',
				allowBlank: false,
				multiSelect: true, 
				typeAhead: false,
				colspan: 3,
				store: Ext.data.StoreManager.lookup('billDivCode'),
				listeners: {
					afterrender: function(field) {
						if(getTaxBase == '5'){
							panelSearch.setValue('BILL_DIV_CODE', getBillDivCode);
						}
					}
				}
			},{
				fieldLabel: '홈택스 ID',
				name: 'HOMETAX_ID',
				xtype: 'uniTextfield',
				colspan: 3,
				allowBlank: false
			},{
				fieldLabel: '신고일자',
				id:'frToDate',
				xtype: 'uniDatefield',
				name: 'WRITE_DATE',
				value: UniDate.get('today'),
				colspan: 3,
				allowBlank:false
			},{
				xtype: 'container',
				colspan: 3,
				layout: {type: 'uniTable', columns: 2},
				items:[{					
					xtype: 'radiogroup',
					fieldLabel: '계산서합계표\n 포함여부',
					labelWidth: 80,
					id: 'rdoSelect',
					items : [{
						boxLabel: '미포함',
						width:80 ,
						name: 'RDO_INCLUDE',
						inputValue: '1'
					}, {
						boxLabel: '포함', 
						width:50 ,
						name: 'RDO_INCLUDE' ,
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(newValue.RDO_INCLUDE == "1"){
								panelSearch.setValue('AC_DATE_FR', '');
								panelSearch.setValue('AC_DATE_TO', '');
								panelSearch.getField('AC_DATE_FR').setReadOnly(true);
								panelSearch.getField('AC_DATE_TO').setReadOnly(true);
							}else{
								panelSearch.getField('AC_DATE_FR').setReadOnly(false);
								panelSearch.getField('AC_DATE_TO').setReadOnly(false);
								panelSearch.setValue('AC_DATE_FR', panelSearch.getValue('PUB_DATE_FR'));
								panelSearch.setValue('AC_DATE_TO', panelSearch.getValue('PUB_DATE_TO'));
							}					
						}
					}
				},{
					fieldLabel: '',
					xtype: 'uniMonthRangefield',  
					startFieldName: 'AC_DATE_FR',
					endFieldName: 'AC_DATE_TO',
					startDD: 'first',
					endDD: 'last',
					width: 470
				}]
			},{
				xtype: 'button',
				text: '파일생성',
				width: 110,
				colspan: 3,
				margin: '5 0 0 150',
				handler : function() {
					var form = panelFileDown;
					if(!panelSearch.getInvalidMessage()){
						return false;
					}
					if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == '2' && (Ext.isEmpty(panelSearch.getValue('AC_DATE_FR')) || Ext.isEmpty(panelSearch.getValue('AC_DATE_TO')))){
						alert(Msg.sMA0062);
						panelSearch.getField('AC_DATE_FR').focus();
						return false;
					}
					form.setValue('PUB_DATE_FR', panelSearch.getField('PUB_DATE_FR').getStartDate());
					form.setValue('PUB_DATE_TO', panelSearch.getField('PUB_DATE_TO').getEndDate());
					form.setValue('BILL_DIV_CODE', panelSearch.getValue('BILL_DIV_CODE'));
					form.setValue('HOMETAX_ID', panelSearch.getValue('HOMETAX_ID'));
					form.setValue('WRITE_DATE', panelSearch.getValue('WRITE_DATE'));
					form.setValue('RDO_INCLUDE', Ext.getCmp('rdoSelect').getChecked()[0].inputValue);
					form.setValue('AC_DATE_FR', panelSearch.getField('AC_DATE_FR').getStartDate());
					form.setValue('AC_DATE_TO', panelSearch.getField('AC_DATE_TO').getEndDate());
					form.setValue('REPORT_TYPE', panelSearch.getValue('REPORT_TYPE'));
					form.setValue('DEGREE', panelSearch.getValue('DEGREE'));
					
					var param = form.getValues();
					atx305ukrService.fnGetFileCheck(param, function(provider, response) {
						console.log("provider : ", provider);
						if(provider){
							form.submit({
								params: param  
							}); 
						}
					});
				}
		},{xtype: 'container',	
			padding: '0 0 5 0',
			colspan: 3,
			html: '</br><b>※ 부가세전자신고 파일생성 서류</b></br>',
			style: {
				color: 'blue'
			},
			tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'left'}
				
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''

					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField') ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});
	
	/** Master Grid1 정의(Grid Panel),
	 * @type
	 */
	var masterGrid = Unilite.createGrid('atx305ukrGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		autoScroll:true,
		region	: 'center',
		tbar: [{
				itemId: 'inquiryBtn',
				text: '<div style="color: blue"><t:message code="system.label.base.inquiry" default="조회"/></div>',
				handler: function() {
					if(Ext.isEmpty(panelSearch.getValue('PUB_DATE_FR'))|| Ext.isEmpty(panelSearch.getValue('PUB_DATE_TO'))){
					Unilite.messageBox('과세기간은 필수입력 항목입니다.');
					panelSearch.getField('PUB_DATE_FR').focus();
					return false;	
					}
					if(Ext.isEmpty(panelSearch.getValue('BILL_DIV_CODE'))){
					Unilite.messageBox('신고사업장은 필수입력 항목입니다.');
					panelSearch.getField('BILL_DIV_CODE').focus();
					return false;	
					}							
					masterGrid.getStore().loadStoreRecords();	
				}
				}],		
		uniOpt	: {
	    	expandLastColumn: false,
	        useRowNumberer: true,
	        useMultipleSorting: false
		},
		columns: [
			{dataIndex: 'SEQ'			, width: 80 , hidden:true },
			{dataIndex: 'CODE_NAME'		, width: 300 },
			{dataIndex: 'EXIST_YN'	    , flex:1 , align: 'center'}

		],
		listeners:{
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';

				if((record.get('SEQ') > 11) && (record.get('EXIST_YN') == '')){
					cls = 'x-change-cell-grey';
				}
				return cls;
			}
		}		
	});	

	
	Unilite.Main({
				items : [ panelSearch, {
					xtype : 'container',
					flex : 1,
					layout : 'border',
					defaults : {
						collapsible : false,
						split : true
					},
					items : [ {
						region : 'center',
						xtype : 'container',
						layout : 'fit',
						items : [ masterGrid ]
					}, {
						region : 'east',
						xtype : 'container',
						layout : 'fit',
						flex : 2,
						items : [{
									padding: '5 5 5 10',
									xtype: 'container',
									colspan: 3,
									html: '</br><b>※ 부가세전자신고 파일생성 방법</b></br></br>'+
										  ' 1) 신고할 사업장 정보(사업자번호, 업태, 종목, 대표자 이름, 주소, 전화번호)가 등록되어 있는지 확인하십시오.</br>'+
										  '&nbsp&nbsp&nbsp&nbsp기준정보-조직정보관리-사업장정보등록 메뉴에서 확인합니다.</br></br>'+
										  ' 2) 회계관리-부가세관리 하위 메뉴 중 첨부서류 메뉴를 모두 작성하십시오.</br></br>'+
										  ' 3) 회계관리-부가세관리-부가세신고서 메뉴에서 각 사업장의 부가세신고서를 작성하십시오.</br>'+
										  '&nbsp&nbsp&nbsp&nbsp부가세 신고서의 [설정] 버튼을 눌러 주업종 업태, 주업종 종목, 주업종 코드를 반드시 입력하십시오.</br></br>'+
										  ' 4) 영세율첨부서류제출명세서는 특별소비세 신고시 이미 영세율 첨부서류를 제출한 사업자가 부가가치세 신고시</br>'+
										  '&nbsp&nbsp&nbsp&nbsp그 명세만 제출하기 위하여 첨부하는 서식입니다. 이 경우 외에는 첨부하여 신고할 수 없습니다.</br></br>'+
										  ' 5) 화면에서 과세기간을 입력하십시오.(예 : 2004.01 ~ 2004.03)</br></br>'+
										  ' 6) 화면에서 신고사업장을 입력하십시오. 모든 사업장을 신고할 경우는 신고사업장 정보를 삭제하고 생성하면 한 파일에 같이 생성됩니다.</br>'+
										  '&nbsp&nbsp&nbsp&nbsp신고사업장을 여러 개 선택하고자 할 경우는 popup을 띄워 선택하십시오. 선택한 신고사업장만 한 파일에 같이 생성됩니다.</br></br>'+
										  ' 7) 분기별로 계산서합계표를 신고할 때는 포함을 선택한 후 기간을 입력하십시오.</br>'+
										  '&nbsp&nbsp&nbsp&nbsp1년에 한번 신고할 때는 4분기 신고할 때만 포함을 선택한 후 기간을 입력하십시오.</br></br>'+
										  ' 8) [파일생성] 버튼을 눌러 저장 경로를 선택하여 파일을 생성하십시오.</br></br>'+
										  ' 9) 홈텍스사이트(http://www.hometax.go.kr)에 접속한 후 암호화 변환프로그램을 다운받아 설치하십시오.</br>'+
										  '&nbsp&nbsp&nbsp&nbsp(자료실에서 암호화로 검색하여 "[전자신고] 변환방식 전자신고파일의 보안강화 조치(2012.1월부터 적용)"</br> ' +
										  '&nbsp&nbsp&nbsp&nbsp 부분을 참고하여 프로그램을 설치하여 변환을 해야 합니다.)</br></br>'+
										  ' 10) 암호화 변환이 완료되면 홈텍스사이트에서 파일 변환하여 검증 후 접수시킵니다.</br>',
						
									style: {
										color: 'blue'
									},
									tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'left'}
								}]
					}]
	
				} ],	
			
		id  : 'atx305ukrApp',

		fnInitBinding : function() {
			panelSearch.getField('RDO_INCLUDE').setValue('2');
			UniAppManager.setToolbarButtons(['detail', 'reset', 'query'],false);
			panelSearch.onLoadSelectText('PUB_DATE_FR');
		}
	});

};

</script>
