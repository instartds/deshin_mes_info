<%--
'   프로그램명 : 수입검사현황조회 (구매재고)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms200skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q033" /> <!-- 최종판정 -->
	<t:ExtComboStore comboType="AU" comboCode="Q005" /> <!-- 검사유형 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsSiteCode : '${gsSiteCode}'
};

var printHiddenYn = true;
if(BsaCodeInfo.gsSiteCode == 'SHIN'){
	printHiddenYn = false;
}

function appMain() {

	/** Model 정의
	 */
	Unilite.defineModel('Mms200skrvModel', {
		fields: [
			{name: 'ORDER_TYPE'		, text: '<t:message code="system.label.purchase.poclass" default="발주유형"/>'				, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'RECEIPT_DATE'	, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'			, type: 'uniDate'},
			{name: 'INSPEC_DATE'	, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'			, type: 'uniDate'},
			{name: 'INSPEC_NUM'		, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ'		, text: '<t:message code="system.label.purchase.inspecseq" default="검사순번"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'INSPEC_TYPE'	, text: '<t:message code="system.label.purchase.inspectype" default="검사유형"/>'			, type: 'string',comboType:'AU',comboCode:'Q005'},
			{name: 'INSPEC_Q'		, text: '<t:message code="system.label.purchase.inspecqty" default="검사량"/>'				, type: 'uniQty'},
			{name: 'GOOD_INSPEC_Q'	, text: '<t:message code="system.label.purchase.gooditemqty" default="양품량"/>'			, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'	, text: '<t:message code="system.label.purchase.defectqty2" default="불량(폐기)수량"/>'		, type: 'uniQty'},
			{name: 'BAD_RATE'		, text: '<t:message code="system.label.purchase.defectratepercent" default="불량률(%)"/>'	, type: 'uniPercent'},
			{name: 'BAD_AMT'		, text: '<t:message code="system.label.purchase.defectamount" default="불량금액"/>'			, type: 'uniPrice'},
			{name: 'GOODBAD_TYPE'	, text: '<t:message code="system.label.purchase.passyn" default="합격여부"/>'  	, type: 'string',comboType: 'AU',comboCode: 'M414', allowBlank:false},
			{name: 'SELECT'			,text: '통보서 선택'					,type: 'boolean'},
			{name: 'END_DECISION'	, text: '<t:message code="system.label.purchase.finaldecision" default="최종판정"/>'		, type: 'string',comboType:'AU',comboCode:'Q033'},
			{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			
			{name: 'BAD_CODE1'		, text: '불량코드1'				, type: 'string'},
			{name: 'BAD_NAME1'		, text: '불량명1'				, type: 'string'},
			{name: 'INSPEC_REMARK1'	, text: '불량내용1'				, type: 'string'},
			{name: 'MANAGE_REMARK1'	, text: '조치내역1'				, type: 'string'},
			{name: 'BAD_Q1'			, text: '불량수량1'				, type: 'uniQty'},
			
			{name: 'BAD_CODE2'		, text: '불량코드2'				, type: 'string'},
			{name: 'BAD_NAME2'		, text: '불량명2'				, type: 'string'},
			{name: 'INSPEC_REMARK2'	, text: '불량내용2'				, type: 'string'},
			{name: 'MANAGE_REMARK2'	, text: '조치내역2'				, type: 'string'},
			{name: 'BAD_Q2'			, text: '불량수량2'				, type: 'uniQty'},
			
			{name: 'BAD_CODE3'		, text: '불량코드3'				, type: 'string'},
			{name: 'BAD_NAME3'		, text: '불량명3'				, type: 'string'},
			{name: 'INSPEC_REMARK3'	, text: '불량내용3'				, type: 'string'},
			{name: 'MANAGE_REMARK3'	, text: '조치내역3'				, type: 'string'},
			{name: 'BAD_Q3'			, text: '불량수량3'				, type: 'uniQty'},
			
			{name: 'SO_NUM'			, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SO_SEQ'			, text: '수주순번'				, type: 'string'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'ORDER_SEQ'		, text: '발주순번'				, type: 'string'},
			{name: 'PROJECT_NO'		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'}
		]
	});//End of Unilite.defineModel('Mms200skrvModel', {



	/** Store 정의(Service 정의)
	 */
	var directMasterStore1 = Unilite.createStore('mms200skrvMasterStore1', {
		model: 'Mms200skrvModel',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'mms200skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		groupField: 'INSPEC_DATE',
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
					masterGrid.setShowSummaryRow(true);
				}
			}
		}
	});//End of var directMasterStore1 = Unilite.createStore('mms200skrvMasterStore1', {



	/** 검색조건 (Search Panel)
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed:true,
		width:380,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items : [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUST_CODE',
				textFieldName: 'CUST_NAME',
				textFieldWidth: 170,
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUST_CODE', newValue);
								panelResult.setValue('CUST_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUST_NAME', '');
									panelResult.setValue('CUST_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUST_NAME', newValue);
								panelResult.setValue('CUST_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUST_CODE', '');
									panelResult.setValue('CUST_CODE', '');
								}
							}
					}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INSPEC_DATE_FR',
				endFieldName: 'INSPEC_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INSPEC_DATE_FR',newValue);

					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INSPEC_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK', {
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				textFieldWidth: 170,
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_CODE', newValue);
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME', newValue);
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE', '');
								}
							},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
					}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.finaldecision" default="최종판정"/>',
				name: 'END_DECISION',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'Q033',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('END_DECISION', newValue);
					}
				}
			},{
				name		: 'ITEM_ACCOUNT',
				fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			}]
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
							var labelText = invalid.items[0]['fieldLabel']+':';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
						}

						alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
						invalid.items[0].focus();
					} else {
					//	this.mask();
					}
				} else {
					this.unmask();
				}
				return r;
			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
			change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName: 'CUST_CODE',
			textFieldName: 'CUST_NAME',
			textFieldWidth: 170,
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUST_CODE', newValue);
							panelResult.setValue('CUST_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUST_NAME', '');
								panelResult.setValue('CUST_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUST_NAME', newValue);
							panelResult.setValue('CUST_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUST_CODE', '');
								panelResult.setValue('CUST_CODE', '');
							}
						}
				}
		}),{
			fieldLabel: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INSPEC_DATE_FR',
			endFieldName: 'INSPEC_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INSPEC_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INSPEC_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M001',
			listeners: {
			change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			colspan		: 2,
			textFieldWidth: 170,
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE', newValue);
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){	// 2021.08 표준화 작업
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
				}
		}),{
			fieldLabel: '<t:message code="system.label.purchase.finaldecision" default="최종판정"/>',
			name: 'END_DECISION',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'Q033',
			listeners: {
			change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('END_DECISION', newValue);
				}
			}
		},{
			name		: 'ITEM_ACCOUNT',
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},{
			xtype: 'button',
			text: '부적합 통보서',
			itemId: 'printButton',
			margin: '0 0 0 120',
			hidden : printHiddenYn,
			handler : function() {

				var param2 = panelResult.getValues();
				
				var aJsonArray = new Array();
				 
				var param = new Object();
				param.DIV_CODE = panelResult.getValue('DIV_CODE');
				param.inspecNumSeqList = '';
				
				var chkCount = 0;
				
				var records = directMasterStore1.data.items;
				Ext.each(records,function(record,index){
					if(record.get('SELECT') == true ){
						if(param.inspecNumSeqList == ''){
						
							param.inspecNumSeqList += record.get('INSPEC_NUM') + record.get('INSPEC_SEQ');
						}else{
							param.inspecNumSeqList += ',' + record.get('INSPEC_NUM') + record.get('INSPEC_SEQ');
						}
						
						
//						var aJson = new Object();
//						
//						aJson.INSPEC_NUM = record.get('INSPEC_NUM');
//						aJson.INSPEC_SEQ = record.get('INSPEC_SEQ');
//						
//						aJson = JSON.stringify(aJson);
//						aJsonArray.push(JSON.parse(aJson));
						
						chkCount += 1;
					}
				})
				
				//console.log(aJsonArray);
				
//				var param = new Object();
//				param.data = aJsonArray;
				
				if(chkCount > 0){
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/z_sh/s_mms200clskrv_sh.do',
						prgID: 'mms200skrv',
						extParam: param
					});
					win.center();
					win.show();
				}else{
					alert('불합격 데이터에 통보서 선택 체크박스를 선택 해주세요.');
				}
				
			}
		}]
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{



	/** Master Grid1 정의(Grid Panel)
	 */
	var masterGrid = Unilite.createGrid('mms200skrvGrid1', {
		// for tab
		layout: 'fit',
		region:'center',
		uniOpt: {
			useGroupSummary	: true,
			useLiveSearch	  : true,
			useContextMenu	 : true,
			useMultipleSorting : true,
			useRowNumberer	 : false,
			expandLastColumn   : false,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel	  : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData	  : false,
				summaryExport : true
			}
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'ORDER_TYPE'		, width: 73 , align:'center'},
			{dataIndex: 'RECEIPT_DATE'		, width: 80},
			{dataIndex: 'INSPEC_DATE'		, width: 80},
			{dataIndex: 'INSPEC_NUM'		, width: 120},
			{dataIndex: 'INSPEC_SEQ'		, width: 66, align:'center'},
			{dataIndex: 'CUSTOM_CODE'		, width: 66, align:'center'},
			{dataIndex: 'CUSTOM_NAME'		, width: 153},
			{dataIndex: 'ITEM_CODE'			, width: 133},
			{dataIndex: 'ITEM_NAME'			, width: 186},
			{dataIndex: 'SPEC'				, width: 130},
			{dataIndex: 'INSPEC_TYPE'		, width: 100 , align:'center'},
			{dataIndex: 'INSPEC_Q'			, width: 106,summaryType:'sum'},
			{dataIndex: 'GOOD_INSPEC_Q'		, width: 106,summaryType:'sum'},
			{dataIndex: 'BAD_INSPEC_Q'		, width: 106,summaryType:'sum'},
			{dataIndex: 'BAD_RATE'			, width: 100, hidden: true},
			{dataIndex: 'BAD_AMT'			, width: 66, hidden: true },
			{dataIndex: 'GOODBAD_TYPE'		, width: 66,align:"center"},
			{dataIndex: 'SELECT'            , width: 80, xtype: 'checkcolumn',align:'center', hidden : printHiddenYn,
				listeners: {    
                    checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
						UniAppManager.setToolbarButtons('save', false);
                    },
                    beforecheckchange: function( CheckColumn, rowIndex, checked, eOpts ){
                        var grdRecord = masterGrid.getStore().getAt(rowIndex);
                        if(grdRecord.get('GOODBAD_TYPE') != '02'){ // 불합격
                        	return false;
                        }
                    }
                }
			},
			{dataIndex: 'END_DECISION'		, width: 66,align:"center"},
			{dataIndex: 'REMARK'			, width: 200},
			
			{dataIndex: 'BAD_CODE1'			, width: 100,hidden:true},
			{dataIndex: 'BAD_NAME1'			, width: 100},
			{dataIndex: 'INSPEC_REMARK1'	, width: 200,hidden:true},
			{dataIndex: 'MANAGE_REMARK1'	, width: 200},
			{dataIndex: 'BAD_Q1'			, width: 100,hidden:true},
			
			{dataIndex: 'BAD_CODE2'			, width: 100,hidden:true},
			{dataIndex: 'BAD_NAME2'			, width: 100},
			{dataIndex: 'INSPEC_REMARK2'	, width: 200,hidden:true},
			{dataIndex: 'MANAGE_REMARK2'	, width: 200},
			{dataIndex: 'BAD_Q2'			, width: 100,hidden:true},
			
			{dataIndex: 'BAD_CODE3'			, width: 100,hidden:true},
			{dataIndex: 'BAD_NAME3'			, width: 100},
			{dataIndex: 'INSPEC_REMARK3'	, width: 200,hidden:true},
			{dataIndex: 'MANAGE_REMARK3'	, width: 200},
			{dataIndex: 'BAD_Q3'			, width: 100,hidden:true},
			
			{dataIndex: 'SO_NUM'			, width: 120, align:'center'},
			{dataIndex: 'SO_SEQ'			, width: 66, align:'center'},
			{dataIndex: 'ORDER_NUM'			, width: 120, align:'center'},
			{dataIndex: 'ORDER_SEQ'			, width: 66, align:'center'},
			{dataIndex: 'PROJECT_NO'		, width: 120}
		]
	});//End of var masterGrid = Unilite.createGrid('mms200skrvGrid1', {



	Unilite.Main({
		id: 'mms200skrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INSPEC_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('INSPEC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('INSPEC_DATE_TO',UniDate.get('today'));
			panelResult.setValue('INSPEC_DATE_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.reset();
				masterGrid.getStore().loadStoreRecords();
				UniAppManager.setToolbarButtons('excel',true);
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterGrid.getStore().clearData();
			UniAppManager.app.fnInitBinding();
		}
	});//End of Unilite.Main( {
};
</script>