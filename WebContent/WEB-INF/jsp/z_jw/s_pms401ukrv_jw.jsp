<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pms401ukrv_jw"  >
	<t:ExtComboStore comboType="BOR120"  />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A" />				<!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" />				<!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M414" />				<!-- 합격여부 -->
	<t:ExtComboStore comboType="AU" comboCode="Q024" />				<!-- 검사담당 -->
	<t:ExtComboStore comboType="AU" comboCode="Q007" />				<!-- 검사유형 -->
	<t:ExtComboStore comboType="AU" comboCode="T011" />				<!-- 검사방식 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 --> 
	<t:ExtComboStore comboType="WU" />								<!-- 작업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}  
</style>
<script type="text/javascript" >


//Controller에서 넘겨받는 값 선언
var BsaCodeInfo = {
	gsAutoInputFlag		: '${gsAutoInputFlag}',		//출하검사 후 자동입고여부(P000, 2)
	gsLotNoInputMethod	: '${gsLotNoInputMethod}'	//생산실적과 출하검사 LOT 연계 여부(B090.REF_CODE1)
};
//팝업윈도우 선언
var searchInfoWindow;								//searchInfoWindow : 조회창
var referSeeReception;								//접수참조
var CheckItemWindow; 								//검사항목 추가
//전역변수 선언
var selectedMasterGrid	= 's_pms401ukrv_jwGrid';
var masterSelectIdx		= 0;
var outDivCode			= UserInfo.divCode;
var checkDraftStatus	= false;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pms401ukrv_jwService.selectMaster',
			update	: 's_pms401ukrv_jwService.updateDetail',
			create	: 's_pms401ukrv_jwService.insertDetail',
			destroy	: 's_pms401ukrv_jwService.deleteDetail',
			syncAll	: 's_pms401ukrv_jwService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pms401ukrv_jwService.selectDetail',
			update	: 's_pms401ukrv_jwService.updateDetail2',
			create	: 's_pms401ukrv_jwService.insertDetail2',
			destroy	: 's_pms401ukrv_jwService.deleteDetail2',
			syncAll	: 's_pms401ukrv_jwService.saveAll2'
		}
	});



	var masterForm = Unilite.createSearchPanel('s_pms401ukrv_jwMasterForm', {
		title		: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		defaultType	: 'uniSearchSubPanel',
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{	
			title		: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				value		: outDivCode,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype		: 'uniDatefield',
				name		: 'INSPEC_DATE',
				value		: UniDate.get('today'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_DATE', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
//					validateBlank	: false,
					valueFieldName	: 'ITEM_CODE',
					textFieldName	:'ITEM_NAME',
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('ITEM_CODE', masterForm.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', masterForm.getValue('ITEM_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
			}),{
				fieldLabel	: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>',
				name		: 'INSPEC_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Q024',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_PRSN', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.inspectype" default="검사유형"/>',
				name		: 'INSPEC_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Q007',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.inspecno" default="검사번호"/>',
				name		: 'INSPEC_NUM',
				xtype		: 'uniTextfield',
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_NUM', newValue);
					}
				}
			},{
				fieldLabel	: '검사번호Grid용',
				name		: 'INSPEC_NUM_TEMP',
				xtype		: 'uniTextfield',
				readOnly	: true,
				hidden		: true
			},{
				fieldLabel	: '순번Grid용',
				name		: 'INSPEC_SEQ_TEMP',
				xtype		: 'uniTextfield',
				readOnly	: true,
				hidden		: true
			},{
				fieldLabel	: '아이템코드Grid용',
				name		: 'ITEM_CODE_TEMP',
				xtype		: 'uniTextfield',
				readOnly	: true,
				hidden		: true
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
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

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		items	: [{
			xtype		: 'container',
			padding		: '0 5 5 5',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns : 3},
			items		: [{
				fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox', 
				comboType	: 'BOR120' ,
				allowBlank	: false,
				value		: outDivCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype		: 'uniDatefield',
				name		: 'INSPEC_DATE',
				value		: UniDate.get('today'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('INSPEC_DATE', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
//					validateBlank: false,
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								masterForm.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
								masterForm.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							masterForm.setValue('ITEM_CODE', '');
							masterForm.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
			}),{
				fieldLabel	: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>',
				name		: 'INSPEC_PRSN', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU' ,
				comboCode	: 'Q024',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('INSPEC_PRSN', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.inspectype" default="검사유형"/>',
				name		: 'INSPEC_TYPE', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU' ,
				comboCode	: 'Q007',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('INSPEC_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.inspecno" default="검사번호"/>',
				name		: 'INSPEC_NUM',
				xtype		: 'uniTextfield',
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('INSPEC_NUM', newValue);
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
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
	
	//검사항목 추가버튼 팝업
	var checkItemSearch = Unilite.createSearchForm('otherorderForm', {
		layout	:  {type : 'uniTable', columns : 2},
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.search" default="검색"/>' ,
			name		: '',
			xtype		: 'uniTextfield' 
		},{ 
			fieldLabel	: ' ',
			xtype		: 'radiogroup', width: 230, name: 'rdoRadio',
			items		: [{
				boxLabel	: '<t:message code="system.label.product.codeinorder" default="코드순"/>',
				name		: 'RDO',
				inputValue	: '1'
			},{
				boxLabel	: '<t:message code="system.label.product.nameinorder" default="이름순"/>',
				name		: 'RDO',
				inputValue	: '2'
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ; 
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});



	/** main Model 정의
	 * @type
	 */
	Unilite.defineModel('s_pms401ukrv_jwDetailModel', {
		fields: [
			{name:'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type:'string'},
			{name:'INSPEC_NUM'			,text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'					,type:'string'},
			{name:'INSPEC_SEQ'			,text: '<t:message code="system.label.product.seq" default="순번"/>'							,type:'int'},
			{name:'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'							,type:'string'},
			{name:'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'					,type:'string'},
			{name:'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'							,type:'string'},
			{name:'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'							,type:'string'},
			{name:'PRODT_Q'				,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'				,type:'uniQty'},
			{name:'INSPEC_TYPE'			,text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'					,type:'string' , comboType:'AU' , comboCode:'Q007', allowBlank: false},
			{name:'INSPEC_METHOD'		,text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'					,type:'string' , comboType:'AU' , comboCode:'T011'},
			{name:'GOODBAD_TYPE'		,text: '<t:message code="system.label.product.passyn" default="합격여부"/>'						,type:'string' , comboType:'AU' , comboCode:'M414'},
			{name:'RECEIPT_Q'			,text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'					,type:'uniQty'},
			{name:'INSPEC_Q'			,text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'					,type:'uniQty' , allowBlank: false},
			{name:'GOOD_INSPEC_Q'		,text: '<t:message code="system.label.product.passqty" default="합격수량"/>'					,type:'uniQty'},
			{name:'BAD_INSPEC_Q'		,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'					,type:'uniQty'},
			{name:'INSTOCK_Q'			,text: '<t:message code="system.label.product.receiptqty" default="입고량"/>'					,type:'uniQty'},
			{name:'INSPEC_PRSN'			,text: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>'		,type:'string' , comboType:'AU' , comboCode:'Q024', allowBlank: false},
			{name:'RECEIPT_NUM'			,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'					,type:'string'},
			{name:'RECEIPT_SEQ'			,text: '<t:message code="system.label.product.receiptseq" default="접수순번"/>'					,type:'string'},
			{name:'INSPEC_DATE'			,text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'					,type:'uniDate'},
			{name:'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'						,type:'string'},
			{name:'PRODT_NUM'			,text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'		,type:'string'},
			{name:'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				,type:'string'},
			{name:'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				,type:'string'},
			{name:'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				,type:'string'},
			{name:'REMARK'				,text: '<t:message code="system.label.product.remarks" default="비고"/>'						,type:'string'},
			{name:'ITEM_ACCOUNT'		,text: '<t:message code="system.label.product.itemaccount" default="품목계정"/>'				,type:'string'},

			{name:'COMP_CODE'			,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'					,type:'string'},
			{name:'GOOD_WH_CODE'		,text: '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>'		,type:'string'},
			{name:'GOOD_PRSN'			,text: '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>'		,type:'string'},
			{name:'BAD_WH_CODE'			,text: '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>'	,type:'string'},
			{name:'BAD_PRSN'			,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'	,type:'string'}
		]
	});
	
	Unilite.defineModel('s_pms401ukrv_jwDetailModel2', {
		fields: [
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type:'string'},
			{name: 'INSPEC_NUM'			,text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'				,type:'string'},
			{name: 'INSPEC_SEQ'			,text: '<t:message code="system.label.product.inspecseq" default="검사순번"/>'				,type:'int'},
			{name: 'BAD_INSPEC_CODE'	,text: '<t:message code="system.label.product.inspectcode" default="검사코드"/>'			,type:'string'},
			{name: 'BAD_INSPEC_NAME'	,text: '<t:message code="system.label.product.inspectsubject" default="검사항목"/>'			,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'						,type:'string'},
			{name: 'MEASURED_VALUE'		,text: '<t:message code="system.label.product.mesuredvalue" default="측정치"/>'			,type:'string'},
			{name: 'BAD_INSPEC_Q'		,text: '<t:message code="system.label.product.defectinspecqty" default="불량검사량"/>'		,type:'uniQty', allowBlank: false},
			{name: 'INSPEC_REMARK'		,text: '<t:message code="system.label.product.inspeccontents" default="검사내용"/>'			,type:'string'},
			{name: 'MANAGE_REMARK'		,text: '<t:message code="system.label.product.actioncontents" default="조치내용"/>'			,type:'string'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'				,type:'string'},
			{name: 'GUBUN'				,text: '<t:message code="system.label.product.detailsclassification" default="내역구분"/>'	,type:'string'}
		]
	});
	
	Unilite.defineModel('s_pms401ukrv_jwDetailModel3', {
		fields: [
			{name: 'MAIN_CODE'		,text: 'MAIN_CODE'		,type:'string'},
			{name: 'SUB_CODE'		,text: '<t:message code="system.label.product.code" default="코드"/>'			,type:'string'},
			{name: 'CODE_NAME'		,text: '<t:message code="system.label.product.codename" default="코드명"/>'	,type:'string'},
			{name: 'BAD_INSPEC_Q'	,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'	,type:'uniQty'},
			{name: 'REF_CODE1'		,text: 'REF_CODE1'		,type:'string'},
			{name: 'REF_CODE2'		,text: 'REF_CODE2'		,type:'string'},
			{name: 'REF_CODE3'		,text: 'REF_CODE3'		,type:'string'},
			{name: 'REF_CODE4'		,text: 'REF_CODE4'		,type:'string'},
			{name: 'REF_CODE5'		,text: 'REF_CODE5'		,type:'string'},
			{name: 'REF_CODE6'		,text: 'REF_CODE6'		,type:'string'},
			{name: 'REF_CODE7'		,text: 'REF_CODE7'		,type:'string'},
			{name: 'REF_CODE8'		,text: 'REF_CODE8'		,type:'string'},
			{name: 'REF_CODE9'		,text: 'REF_CODE9'		,type:'string'},
			{name: 'REF_CODE10'		,text: 'REF_CODE10'		,type:'string'}
		]
	});



	var detailStore = Unilite.createStore('s_pms401ukrv_jwDetailStore', {
		model	: 's_pms401ukrv_jwDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	//상위 버튼 연결
			editable	: true,		//수정 모드 사용
			deletable	: true,		//삭제 가능 여부
			useNavi		: false		//prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);

			var inspecNum = masterForm.getValue('INSPEC_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['INSPEC_NUM'] != inspecNum) {
					record.set('INSPEC_NUM', orderNum);
				}
			})
			console.log("inValidRecords : ", inValidRecs);
			console.log("inValidRecords : ", inValidRecs);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("INSPEC_NUM", master.INSPEC_NUM);
						panelResult.setValue("INSPEC_NUM", master.INSPEC_NUM);
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						detailStore.loadStoreRecords();
						if(detailStore.getCount() != 0){
							Ext.getCmp('CheckItemButton').setDisabled(false);
						}else{
							UniAppManager.app.onResetButtonDown();
						}
						
						UniAppManager.setToolbarButtons('save', false);
					 } 
				};
				this.syncAllDirect(config);
				
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				//alert(Msg.sMB083);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var store = detailGrid.getStore();
				if(store.getCount() > 0) {
					Ext.getCmp('CheckItemButton').setDisabled(false);
//					Ext.getCmp('ItemDeleteButton').setDisabled(false);
					
					masterForm.setValue("INSPEC_PRSN"	, records[0].get('INSPEC_PRSN'));
					panelResult.setValue("INSPEC_PRSN"	, records[0].get('INSPEC_PRSN'));
					
				} else {
					Ext.getCmp('CheckItemButton').setDisabled(true);
//					Ext.getCmp('ItemDeleteButton').setDisabled(true);
				}
				if(records != null && records.length > 0 ){
					UniAppManager.setToolbarButtons(['delete','deleteAll'], true);
				}
				detailGrid.getSelectionModel().select(masterSelectIdx);
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);	  
			},
			datachanged : function(store,  eOpts) {
				if( detailStore2.isDirty() || store.isDirty() ){
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			},
			remove : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				if(store.getCount() == 0) {
					UniAppManager.setToolbarButtons(['delete','deleteAll'], false);
				}
			}
		}
	});
	
	var detailStore2 = Unilite.createStore('s_pms401ukrv_jwDetailStore2', {
		model	: 's_pms401ukrv_jwDetailModel2',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	//상위 버튼 연결
			editable	: true,		//수정 모드 사용
			deletable	: true,		//삭제 가능 여부
			useNavi		: false		//prev | next 버튼 사용
		},
		loadStoreRecords: function(record) {
			var param = record.data;
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);

			var inspecNum = masterForm.getValue('INSPEC_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['INSPEC_NUM'] != inspecNum) {
					record.set('INSPEC_NUM', orderNum);
				}
			})
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);	
						detailStore.loadStoreRecords();
					 } 
				};
				this.syncAllDirect(config);
				
			} else {
				detailGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
				//alert(Msg.sMB083);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records != null && records.length > 0 ){
					UniAppManager.setToolbarButtons(['delete','deleteAll'], true);
				}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
				if( detailStore.isDirty() || store.isDirty() ){
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			},
			remove : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				if(store.getCount() == 0) {
					UniAppManager.setToolbarButtons(['delete','deleteAll'], false);
				}
			}
		}
	});
	
	var checkItemStore = Unilite.createStore('s_pms401ukrv_jwDetailStore3', {//이동요청
		model: 's_pms401ukrv_jwDetailModel3',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	//상위 버튼 연결
			editable	: true,		//수정 모드 사용
			deletable	: false,	//삭제 가능 여부
			useNavi		: false		//prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 's_pms401ukrv_jwService.selectCheckItem'
			}
		},
		loadStoreRecords : function()	{
			var param= checkItemSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	var detailGrid = Unilite.createGrid('s_pms401ukrv_jwGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			useContextMenu		: true,
			onLoadSelectFirst	: false
		},
		tbar: [{
			xtype	: 'splitbutton',
			itemId	: 'refTool',
			text	: '<t:message code="system.label.product.reference" default="참조..."/>',
			iconCls	: 'icon-referance',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId	: 'requestBtn',
					text	: '<t:message code="system.label.product.receiptrefer" default="접수참조"/>',
					handler	: function() {
						if(masterForm.setAllFieldsReadOnly(true)){
							openProductionWindow();
						}
					}
				}]
			})
		}],
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 100 , hidden: true},
			{dataIndex: 'INSPEC_NUM'		, width: 66  , hidden: true},
			{dataIndex: 'INSPEC_SEQ'		, width: 55},
			{dataIndex: 'ITEM_CODE'			, width: 80},
			{dataIndex: 'ITEM_NAME'			, width: 146},
			{dataIndex: 'SPEC'				, width: 166},
			{dataIndex: 'STOCK_UNIT'		, width: 40},
			{dataIndex: 'PRODT_Q'			, width: 80},
			{dataIndex: 'INSPEC_TYPE'		, width: 93},
			{dataIndex: 'INSPEC_METHOD'		, width: 93  , hidden: true},
			{dataIndex: 'GOODBAD_TYPE'		, width: 93},
			{dataIndex: 'RECEIPT_Q'			, width: 80},
			{dataIndex: 'INSPEC_Q'			, width: 80},
			{dataIndex: 'GOOD_INSPEC_Q'		, width: 80},
			{dataIndex: 'BAD_INSPEC_Q'		, width: 80},
			{dataIndex: 'INSTOCK_Q'			, width: 66},
			{dataIndex: 'INSPEC_PRSN'		, width: 90},
			{dataIndex: 'RECEIPT_NUM'		, width: 106},
			{dataIndex: 'RECEIPT_SEQ'		, width: 80},
			{dataIndex: 'INSPEC_DATE'		, width: 80  , hidden: true},
			{dataIndex: 'LOT_NO'			, width: 100,
				editor: Unilite.popup('LOTNO_G', {
					textFieldName	: 'LOTNO_CODE',
					DBtextFieldName	: 'LOTNO_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var rtnRecord;
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord = detailGrid.uniOpt.currentRecord
									}else{
										rtnRecord = detailGrid.getSelectedRecord()
									}
									rtnRecord.set('LOT_NO', record['LOT_NO']);
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							var record1 = detailGrid.getSelectedRecord();
							record1.set('LOT_NO', '');
						},
						applyextparam: function(popup){
							var record		= detailGrid.getSelectedRecord();
							var divCode		= masterForm.getValue('DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var whCode		= record.get('WH_CODE');
							popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode});
						}
					}
				})
			},
			{dataIndex: 'PRODT_NUM'			, width: 106},
			{dataIndex: 'WKORD_NUM'			, width: 106},
			{dataIndex: 'PROJECT_NO'		, width: 106},
//			{dataIndex: 'PJT_CODE'			, width: 106},
			{dataIndex: 'REMARK'			, width: 133},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 66  , hidden: true},
			
			{dataIndex: 'COMP_CODE'			, width: 66  , hidden: true},
			{dataIndex: 'GOOD_WH_CODE'		, width: 66  , hidden: true},
			{dataIndex: 'GOOD_PRSN'			, width: 66  , hidden: true},
			{dataIndex: 'BAD_WH_CODE'		, width: 66  , hidden: true},
			{dataIndex: 'BAD_PRSN'			, width: 66  , hidden: true}
		], 
		listeners: {
//			select: function() {
//				selectedGrid = 's_pms401ukrv_jwGrid';
//				selectedMasterGrid = 's_pms401ukrv_jwGrid';
//				UniAppManager.setToolbarButtons(['delete'], true);
//			}, 
			cellclick: function() {
				selectedGrid		= 's_pms401ukrv_jwGrid';
				selectedMasterGrid	= 's_pms401ukrv_jwGrid';
				
				if( detailStore.isDirty() || detailStore2.isDirty() ){
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
				if(detailStore.getCount() > 0)  {
					UniAppManager.setToolbarButtons(['delete','deleteAll'], true);
				}else {
					UniAppManager.setToolbarButtons(['delete','deleteAll'], false);
				}
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
				masterSelectIdx = index;
//				detailSelectIdx = 0;
			},
			beforeedit  : function( editor, e, eOpts ) {
//				if(selectedMasterGrid == 's_pms401ukrv_jwGrid2' && UniAppManager.app._needSave())  {
//				alert('검사내역을 먼저 저장하셔야 선택이 가능합니다.');
//				return false;
//				}
				if(checkDraftStatus)	{
					return false;
					
				} else if(e.record.phantom) {
					if (UniUtils.indexOf(e.field, 
									['DIV_CODE','INSPEC_NUM', 'GOODBAD_TYPE','INSPEC_SEQ','ITEM_CODE','ITEM_NAME','SPEC','STOCK_UNIT',
									 'PRODT_Q','RECEIPT_Q','GOOD_INSPEC_Q','BAD_INSPEC_Q','INSTOCK_Q','RECEIPT_NUM',
									 'RECEIPT_SEQ','INSPCE_DATE,','PRODT_NUM','WKORD_NUM','PROJECT_NO','PJT_CODE','ITME_ACCOUNT']))
					return false;
				}
				
				if(!e.record.phantom){
					if(e.record.data.INSTOCK_Q == e.record.data.INSPEC_Q) {
						return false;
					}
					else if(e.record.data.INSTOCK_Q != e.record.data.INSPEC_Q) {
						if (UniUtils.indexOf(e.field, 
									['DIV_CODE', 'INSPEC_NUM', 'INSPEC_SEQ', 'ITEM_CODE', 'ITEM_NAME', 'SPEC', 'STOCK_UNIT',
									 'PRODT_Q', 'RECEIPT_Q'/*, 'GOOD_INSPEC_Q', 'BAD_INSPEC_Q'*/, 'RECEIPT_NUM', 'RECEIPT_SEQ','INSPCE_DATE',
									 'PRODT_NUM', 'WKORD_NUM', 'PROJECT_NO', 'PJT_CODE', 'ITME_ACCOUNT']))
							return false;
					}
				}
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0) {
					var record = selected[0];
					if(record.phantom) return false;
					var param			= masterForm.getValues();
					param.ITEM_CODE		= record.get('ITEM_CODE');
					param.INSPEC_NUM	= record.get('INSPEC_NUM');
					param.INSPEC_SEQ	= record.get('INSPEC_SEQ');
					param.DIV_CODE		= record.get('DIV_CODE');
					detailStore2.loadStoreRecords(record);
				}
				
				var record1 = detailGrid.getSelectedRecord();
				if(selected.length > 0)	{
					var record = selected[0];
					this.returnCell(record);  
					detailStore2.loadData({})
					detailStore2.loadStoreRecords(record);
				} else {
					
				}
			}
		},
		returnCell: function(record){
			var inspecNum		= record.get("INSPEC_NUM");
			var inspecSeq		= record.get("INSPEC_SEQ");
			var itemCode		= record.get("ITEM_CODE");
			masterForm.setValues({'INSPEC_NUM_TEMP'	: inspecNum});
			masterForm.setValues({'INSPEC_SEQ_TEMP'	: inspecSeq});
			masterForm.setValues({'ITEM_CODE_TEMP'	: itemCode});
		},
		disabledLinkButtons: function(b) {
		},
		setEstiData:function(record) {
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('COMP_CODE'		, UserInfo.compCode);
			grdRecord.set('INSPEC_NUM'		, masterForm.getValue('INSPEC_NUM'));
			grdRecord.set('DIV_CODE'		, masterForm.getValue('DIV_CODE'));	
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);	
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);	
			grdRecord.set('SPEC'			, record['SPEC']);	
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);

			grdRecord.set('INSPEC_TYPE'		, record['INSPEC_METH_PRODT']);
			grdRecord.set('GOODBAD_TYPE'	, '01');
//			grdRecord.set('INSPEC_PRSN'		, record['INSPEC_PRSN']);

			grdRecord.set('PRODT_Q'			, record['PRODT_Q']);
			grdRecord.set('RECEIPT_Q'		, record['NOT_INSPEC_Q']);
			grdRecord.set('INSPEC_Q'		, record['NOT_INSPEC_Q']);

			grdRecord.set('RECEIPT_NUM'		, record['RECEIPT_NUM']);
			grdRecord.set('RECEIPT_SEQ'		, record['RECEIPT_SEQ']);
			grdRecord.set('LOT_NO'			, record['LOT_NO']);

			grdRecord.set('PRODT_NUM'		, record['PRODT_NUM']);
			grdRecord.set('WKORD_NUM'		, record['WKORD_NUM']);
			grdRecord.set('PROJECT_NO'		, record['PROJECT_NO']);
			grdRecord.set('PJT_CODE'		, record['PJT_CODE']);
			grdRecord.set('INSPEC_DATE'		, masterForm.getValue('INSPEC_DATE'));
			grdRecord.set('GOOD_INSPEC_Q'	, record['NOT_INSPEC_Q']);
			grdRecord.set('BAD_INSPEC_Q'	, 0);
			grdRecord.set('INSTOCK_Q'		, 0);
			grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
		}
	});

	var detailGrid2 = Unilite.createGrid('s_pms401ukrv_jwGrid2', {
		store	: detailStore2,
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		tbar: [{
			xtype	: 'button',
			name	: 'CheckItem',
			id		: 'CheckItemButton',
			text	: '<t:message code="system.label.product.inspectsubjectadd" default="검사항목추가"/>',
			width	: 110,
			handler	: function(){
				openCheckItemWindow();
			}
		}],
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 66 ,hidden: true},
			{dataIndex: 'INSPEC_NUM'		, width: 66 ,hidden: true},
			{dataIndex: 'INSPEC_SEQ'		, width: 40 ,hidden: true},
			{dataIndex: 'BAD_INSPEC_CODE'	, width: 66},
			{dataIndex: 'BAD_INSPEC_NAME'	, width: 100},
			{dataIndex: 'SPEC'				, width: 166},
			{dataIndex: 'MEASURED_VALUE'	, width: 166},
			{dataIndex: 'BAD_INSPEC_Q'		, width: 100},
			{dataIndex: 'INSPEC_REMARK'		, width: 266},
			{dataIndex: 'MANAGE_REMARK'		, width: 266},
			{dataIndex: 'COMP_CODE'			, width: 266,hidden: true},
			{dataIndex: 'GUBUN'				, width: 66 ,hidden: true}
		],
		listeners: { 
//			select: function() {
//				selectedGrid = 's_pms401ukrv_jwGrid2';
//				selectedMasterGrid = 's_pms401ukrv_jwGrid2';
//				UniAppManager.setToolbarButtons(['delete'], false);
//			}, 
			cellclick: function() {
				selectedGrid = 's_pms401ukrv_jwGrid2';
				selectedMasterGrid = 's_pms401ukrv_jwGrid2';
				
				if( detailStore.isDirty() || detailStore2.isDirty() ){
					UniAppManager.setToolbarButtons('save', true);  
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
				if(detailStore.getCount() > 0)  {
					UniAppManager.setToolbarButtons(['delete','deleteAll'], true);
				}else {
					UniAppManager.setToolbarButtons(['delete','deleteAll'], false);
				}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(detailStore.isDirty())  {
				alert('<t:message code="system.message.product.message040" default="검사내역을 먼저 저장하셔야 선택이 가능합니다."/>');
				return false;
				}
				if (UniUtils.indexOf(e.field, 
					['BAD_INSPEC_CODE', 'BAD_INSPEC_NAME']))
				return false;
			}
		},
		disabledLinkButtons: function(b) {
//			this.down('#procTool').menu.down('#temporarySaveBtn').setDisabled(b);
//			this.down('#procTool').menu.down('#selectAllBtn').setDisabled(b);
//			this.down('#choice').menu.down('#pass').setDisabled(b);
//			this.down('#choice').menu.down('#return').setDisabled(b);
		},	
		setCheckItemData: function(record) {						//검사항목
			var grdRecord = this.getSelectedRecord();  
//			var records = detailStore2.data.items;
//			if(records.BAD_INSPEC_CODE != record['SUB_CODE']) {		//레코드에 있는 값이면 빼고 SET됨.
			grdRecord.set('DIV_CODE'		, masterForm.getValue('DIV_CODE'));
			grdRecord.set('INSPEC_NUM'		, masterForm.getValue('INSPEC_NUM'));
			grdRecord.set('INSPEC_SEQ'		, masterForm.getValue('INSPEC_SEQ_TEMP'));
			grdRecord.set('BAD_INSPEC_CODE'	, record['SUB_CODE']);
			grdRecord.set('BAD_INSPEC_NAME'	, record['CODE_NAME']);
			grdRecord.set('BAD_INSPEC_Q'	, record['BAD_INSPEC_Q']);
			grdRecord.set('SPEC'			, '');
			grdRecord.set('MEASURED_VALUE'	, '');
			grdRecord.set('INSPEC_REMARK'	, '');
			grdRecord.set('MANAGE_REMARK'	, '');
			grdRecord.set('COMP_CODE'		, UserInfo.compCode);
			grdRecord.set('GUBUN'			, '');
			selectedMasterGrid = 's_pms401ukrv_jwGrid2';
//			}
		},
		checkDupleCode: function(record) {
			var isSuccess = true;
			var records = detailStore2.data.items;

			Ext.each(records, function(record2,i) {	
				if(record.data['SUB_CODE'] == record2.data['BAD_INSPEC_CODE'] ) {
					isSuccess = false;
					return isSuccess;
				}
			}); 
			if(isSuccess){
				return true;
			}else{
				return false;
			}
		}
	});

	var checkItemGrid = Unilite.createGrid('s_pms401ukrv_jwGrid3', {	//검사항목 팝업 그리드
		store	: checkItemStore,
		layout	: 'fit',
//		selModel:Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns: [  
			 { dataIndex: 'MAIN_CODE'	, width: 80		, hidden: true},
			 { dataIndex: 'SUB_CODE'	, width: 80},
			 { dataIndex: 'CODE_NAME'	, width: 250},
			 { dataIndex: 'BAD_INSPEC_Q', width: 120},
			 { dataIndex: 'REF_CODE1'	, width: 80		, hidden: true},
			 { dataIndex: 'REF_CODE2'	, width: 80		, hidden: true},
			 { dataIndex: 'REF_CODE3'	, width: 80		, hidden: true},
			 { dataIndex: 'REF_CODE4'	, width: 80		, hidden: true},
			 { dataIndex: 'REF_CODE5'	, width: 80		, hidden: true},
			 { dataIndex: 'REF_CODE6'	, width: 80		, hidden: true},
			 { dataIndex: 'REF_CODE7'	, width: 80		, hidden: true},
			 { dataIndex: 'REF_CODE8'	, width: 80		, hidden: true},
			 { dataIndex: 'REF_CODE9'	, width: 80		, hidden: true},
			 { dataIndex: 'REF_CODE10'	, width: 80		, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {},
			beforeedit  : function( editor, e, eOpts ) {
				//불량수량만 입력 가능
				if (UniUtils.indexOf(e.field,['BAD_INSPEC_Q'])) {
					return true;
					
				} else {
					return false;
				}
			}
		},
		returnData: function(record) {
			var records = checkItemStore.data.items;
			Ext.each(records, function(record,i) {
				var isSuccess = detailGrid2.checkDupleCode(record);
				
				//불량수량이 입력된 행만 detailGrid2에 set
				if(isSuccess && record.get('BAD_INSPEC_Q') != 0){
//					checkItemStore.remove(record);
					UniAppManager.app.onNewDataButtonDown2();
					detailGrid2.setCheckItemData(record.data);
				}
			});
		}
	});



	//검사항목 추가 팝업
	function openCheckItemWindow() {
		if(!CheckItemWindow) {
			CheckItemWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.product.inspectsubject" default="검사항목"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [checkItemSearch, checkItemGrid],
				tbar	:  ['->', {
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.product.inquiry" default="조회"/>',
					handler	: function() {
						checkItemStore.loadStoreRecords();
						if(checkItemSearch.setAllFieldsReadOnly(true) == false){
							return false;
						}
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
					handler	: function() {
						
						checkItemGrid.returnData();
						CheckItemWindow.hide();
						UniAppManager.setToolbarButtons('reset', true)
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.product.close" default="닫기"/>',
					handler	: function() {
						CheckItemWindow.hide();
						UniAppManager.setToolbarButtons('reset', true)
					},
					disabled: false
				}],
				listeners : {
					beforeshow: function ( me, eOpts ) {
						checkItemStore.loadStoreRecords();
					},
					beforehide: function(me, eOpt)	{
						checkItemSearch.clearForm();
						checkItemGrid.reset();
					},
					 beforeclose: function( panel, eOpts )	{
						checkItemSearch.clearForm();
						checkItemGrid.reset();
					}
				}
			})
		}
		CheckItemWindow.show();
		CheckItemWindow.center();
	}



	//조회창 폼 정의
	var checkNoSearch = Unilite.createSearchForm('checkNoSearchForm', {
		layout	: {type: 'uniTable', columns : 2},
		items	: [{
				fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox', 
				comboType	: 'BOR120',
				allowBlank	: false
			},{ 
				fieldLabel		: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype			: 'uniDateRangefield',  
				startFieldName	: 'INSPEC_DATE_FR',
				endFieldName	:'INSPEC_DATE_TO',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				width			: 315
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank	: false, 
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME'
			}),{
				fieldLabel	: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
				xtype		: 'uniTextfield',
				name		: 'LOT_NO',
				width		: 315
			},{
				fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'WU'
			}]
	}); //createSearchForm
	//조회창 모델 정의
	Unilite.defineModel('checkNoMasterModel', {
		fields: [
			{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.product.seq" default="순번"/>'						, type: 'int'},
			{name: 'INSPEC_DATE'		, text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'				, type: 'uniDate'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'					, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'					, type: 'string'},
			{name: 'INSPEC_Q'			, text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'				, type: 'uniQty'},
			{name: 'GOOD_INSPEC_Q'		, text: '<t:message code="system.label.product.passqty" default="합격수량"/>'				, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'		, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'				, type: 'uniQty'},
			{name: 'INSPEC_TYPE'		, text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'			, type: 'string'  , comboType:'AU' , comboCode:'Q007'},
			{name: 'INSPEC_PRSN'		, text: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>'	, type: 'string'  , comboType:'AU' , comboCode:'Q024'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'PRODT_NUM'			, text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'PJT_CODE'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			, type: 'string'}
		]
	});
	//조회창 스토어 정의
	var checkNoMasterStore = Unilite.createStore('checkNoMasterStore', {
		model	: 'checkNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	//상위 버튼 연결
			editable	: false,	//수정 모드 사용
			deletable	: false,	//삭제 가능 여부
			useNavi		: false		//prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 's_pms401ukrv_jwService.selectOrderNumMasterList'
			}
		},
		loadStoreRecords : function()	{
			var param= checkNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//조회창 그리드 정의
	var checkNoMasterGrid = Unilite.createGrid('s_pms401ukrv_jwcheckNoMasterGrid', {
		store	: checkNoMasterStore,
		layout	: 'fit',
		uniOpt	:{
			expandLastColumn: false,
			useRowNumberer: false
		},
		columns:  [{ dataIndex: 'INSPEC_NUM'	, width: 106 },
				{ dataIndex: 'INSPEC_SEQ'		, width: 33  },
				{ dataIndex: 'INSPEC_DATE'		, width: 80  },
				{ dataIndex: 'ITEM_CODE'		, width: 80  },
				{ dataIndex: 'ITEM_NAME'		, width: 146 },
				{ dataIndex: 'SPEC'				, width: 100 },
				{ dataIndex: 'STOCK_UNIT'		, width: 46  },
				{ dataIndex: 'INSPEC_Q'			, width: 73  },
				{ dataIndex: 'GOOD_INSPEC_Q'	, width: 73  },
				{ dataIndex: 'BAD_INSPEC_Q'		, width: 73  },
				{ dataIndex: 'INSPEC_TYPE'		, width: 66  },
				{ dataIndex: 'INSPEC_PRSN'		, width: 66  },
				{ dataIndex: 'LOT_NO'			, width: 106 },
				{ dataIndex: 'PRODT_NUM'		, width: 100 },
				{ dataIndex: 'WKORD_NUM'		, width: 100 },
				{ dataIndex: 'PROJECT_NO'		, width: 100 }
//				{ dataIndex: 'PJT_CODE'			, width: 100 }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				checkNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				searchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			masterForm.setValues({'INSPEC_DATE':record.get('INSPEC_DATE'), 'INSPEC_NUM':record.get('INSPEC_NUM')});
		}
	});
	//조회창 팝업 윈도우
	function opensearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.product.inspecnoinquiry" default="검사번호검색"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [checkNoSearch, checkNoMasterGrid],
				tbar	: ['->',{
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.product.inquiry" default="조회"/>',
					handler	: function() {
						checkNoMasterStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.product.close" default="닫기"/>',
					handler	: function() {
						searchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						checkNoSearch.clearForm();
						checkNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						checkNoSearch.clearForm();
						checkNoMasterGrid.reset();
					},
					show: function( panel, eOpts )	{
						checkNoSearch.setValue('DIV_CODE'		, masterForm.getValue('DIV_CODE'));
						checkNoSearch.setValue('INSPEC_DATE_FR'	, UniDate.get('startOfMonth', masterForm.getValue('INSPEC_DATE')));
						checkNoSearch.setValue('INSPEC_DATE_TO'	, masterForm.getValue('INSPEC_DATE'));
						checkNoSearch.setValue('ITEM_CODE'		, masterForm.getValue('ITEM_CODE'));
						checkNoSearch.setValue('ITEM_NAME'		, masterForm.getValue('ITEM_NAME'));
						checkNoSearch.setValue('LOT_NO'			, masterForm.getValue('LOT_NO'));
						checkNoSearch.setValue('WORK_SHOP_CODE'	, masterForm.getValue('WORK_SHOP_CODE'));
					}
				}
			})
		}
		searchInfoWindow.show();
		searchInfoWindow.center();
	}



	//접수 참조 폼 정의
	var productionSearch = Unilite.createSearchForm('productionForm', {
		layout	:  {type : 'uniTable', columns : 2},
		items	:[{
			fieldLabel		: '<t:message code="system.label.product.receiptdate" default="접수일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'RECEIPT_DATE_FR',
			endFieldName	: 'RECEIPT_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			width			: 350
		},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
				validateBlank	: false,
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME'
		}),{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU'
		},{
			fieldLabel	: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
			xtype		: 'uniTextfield',
			name		: 'LOT_NO'
		},{
			fieldLabel	: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
			xtype		: 'uniTextfield',
			name		: 'PROJECT_NO'
		}]
	});
	//접수 참조 모델 정의
	Unilite.defineModel('s_pms401ukrv_jwProductionModel', {
		fields: [
			{name: 'CHK'				,text: '<t:message code="system.label.product.selection" default="선택"/>'				,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'						,type:'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'						,type:'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.classfication" default="구분"/>'			,type:'string'},
			{name: 'RECEIPT_DATE'		,text: '<t:message code="system.label.product.receiptdate" default="접수일"/>'				,type:'uniDate'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type:'uniQty'},
			{name: 'INSPEC_Q'			,text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'				,type:'uniQty'},
			{name: 'NOT_INSPEC_Q'		,text: '<t:message code="system.label.product.noinspecqty" default="미검사량"/>'			,type:'uniQty'},
			{name: 'INSPEC_METH_PRODT'	,text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'				,type:'string' , comboType:'AU' , comboCode:'Q007'},
			{name: 'RECEIPT_NUM'		,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'				,type:'string'},
			{name: 'RECEIPT_SEQ'		,text: '<t:message code="system.label.product.receiptseq" default="접수순번"/>'				,type:'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				,type:'string'},
			{name: 'PRODT_NUM'			,text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'	,type:'string'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.product.itemaccount" default="품목계정"/>'			,type:'string'}
		]
	});	
	//접수 참조 스토어 정의
	var productionStore = Unilite.createStore('s_pms401ukrv_jwProductionStore', {
		model: 's_pms401ukrv_jwProductionModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	//상위 버튼 연결
			editable	: false,	//수정 모드 사용
			deletable	: false,	//삭제 가능 여부
			useNavi		: false		//prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read : 's_pms401ukrv_jwService.selectEstiList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful)	{
					var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
					var estiRecords = new Array();

					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						
						Ext.each(records, 
							function(item, i) {
								Ext.each(masterRecords.items, function(record, i)	{
									console.log("record :", record);
									
									if( (record.data['ESTI_NUM'] == item.data['ESTI_NUM'])
										&& (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ']))
									{
										estiRecords.push(item);
									}
								});
							});
						store.remove(estiRecords);
					}
				}
			}
		},
		loadStoreRecords : function()	{
			var param= productionSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//접수 참조  그리드 정의
	var productionGrid = Unilite.createGrid('s_pms401ukrv_jwproductionGrid', {
		store	: productionStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false }), 
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns: [
			{dataIndex: 'CHK'				, width: 33 ,hidden:true},
			{dataIndex: 'ITEM_CODE'			, width: 93},
			{dataIndex: 'ITEM_NAME'			, width: 120},
			{dataIndex: 'SPEC'				, width: 120},
			{dataIndex: 'STOCK_UNIT'		, width: 40},
			{dataIndex: 'RECEIPT_DATE'		, width: 80},
			{dataIndex: 'PRODT_Q'			, width: 86},
			{dataIndex: 'INSPEC_Q'			, width: 86},
			{dataIndex: 'NOT_INSPEC_Q'		, width: 86},
			{dataIndex: 'INSPEC_METH_PRODT'	, width: 86},
			{dataIndex: 'RECEIPT_NUM'		, width: 93},
			{dataIndex: 'RECEIPT_SEQ'		, width: 66},
			{dataIndex: 'LOT_NO'			, width: 93},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100},
			{dataIndex: 'PRODT_NUM'			, width: 106},
			{dataIndex: 'WKORD_NUM'			, width: 106},
			{dataIndex: 'PROJECT_NO'		, width: 106},
//			{dataIndex: 'PJT_CODE'			, width: 106},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 66 , hidden: true}
		],
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {}
		},
		returnData: function()	{
			var records = this.getSelectedRecords();
			
			Ext.each(records, function(record,i){	
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setEstiData(record.data);
			}); 
			this.getStore().remove(records);
		}
	});
	//접수 참조  팝업 윈도우
	function openProductionWindow() {
		productionSearch.setValue('ITEM_CODE'		, masterForm.getValue('ITEM_CODE'));
		productionSearch.setValue('ITEM_NAME'		, masterForm.getValue('ITEM_NAME'));
		productionSearch.setValue('WORK_SHOP_CODE'	, masterForm.getValue('WORK_SHOP_CODE'));
		productionSearch.setValue('LOT_NO'			, masterForm.getValue('LOT_NO'));
		productionSearch.setValue('PROJECT_NO'		, masterForm.getValue('PROJECT_NO'));
		
		if(!referSeeReception) {
			referSeeReception = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.product.receiptrefer" default="접수참조"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [productionSearch, productionGrid],
				tbar	: ['->', {
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.product.inquiry" default="조회"/>',
					handler	: function() {
						productionStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.product.apply" default="적용"/>',
					handler	: function() {
						productionGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
					handler	: function() {
						productionGrid.returnData();
						referSeeReception.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.product.close" default="닫기"/>',
					handler	: function() {
						referSeeReception.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						//requestSearch.clearForm();
						//requestGrid,reset();
					},
					beforeclose: function( panel, eOpts )	{
						//requestSearch.clearForm();
						//requestGrid,reset();
					},
					beforeshow: function ( me, eOpts )	{
						productionStore.loadStoreRecords();
					}
				}
			})
		}
		referSeeReception.show();
		referSeeReception.center();
	}



	Unilite.Main({
		id			: 's_pms401ukrv_jwApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	:[
				detailGrid, detailGrid2, panelResult
			]
		},
			masterForm
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			Ext.getCmp('CheckItemButton').setDisabled(true);
			detailGrid.disabledLinkButtons(false);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			masterForm.setAllFieldsReadOnly(false);
			var orderNo = masterForm.getValue('INSPEC_NUM');
			if(Ext.isEmpty(orderNo)) {
				opensearchInfoWindow()
			} else {
				var param= masterForm.getValues();
				masterSelectIdx = 0;
				detailStore.loadStoreRecords();	
			}
		},
		onNewDataButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}

			var inspec_num = masterForm.getValue('INSPEC_NUM');
			var inspecType = masterForm.getValue('INSPEC_TYPE');
			if(Ext.isEmpty(inspecType)){
				inspecType = '01'
			}
			var inspecPrsn = masterForm.getValue('INSPEC_PRSN');
			var seq = detailStore.max('INSPEC_SEQ');
			if(!seq) seq = 1;
			else  seq += 1;

			var r = { 
				INSPEC_NUM	: inspec_num,
				INSPEC_SEQ	: seq,
				INSPEC_TYPE	: inspecType,
				INSPEC_PRSN	: inspecPrsn
//				GOODBAD_TYPE: '01'
			};
			detailGrid.createRow(r);
			masterForm.setAllFieldsReadOnly(false);
		},
		onNewDataButtonDown2: function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			
			var divCode			= masterForm.getValue('DIV_CODE');
			var inspecNum		= masterForm.getValue('INSPEC_NUM');
			var inspecSeq		= masterForm.getValue('INSPEC_SEQ');
			var badInspecCode	= '';
			var badInspecName	= '';
			var Spec			= '';
			var measuredValue	= '';
			var badInspecQ		= '0';
			var inspecRemark	= '';
			var manageRemark	= '';
			var compCode		= UserInfo.compCode;
			var Gubun			= '';
			
			var r = { 
				DIV_CODE		: divCode,
				INSPEC_NUM		: inspecNum,
				INSPEC_SEQ		: inspecSeq,
				BAD_INSPEC_CODE	: badInspecCode,
				BAD_INSPEC_NAME	: badInspecName,
				SPEC			: Spec,
				MEASURED_VALUE	: measuredValue,
				BAD_INSPEC_Q	: badInspecQ,
				INSPEC_REMARK	: inspecRemark,
				MANAGE_REMARK	: manageRemark,
				COMP_CODE		: compCode,
				GUBUN			: Gubun
			};
			detailGrid2.createRow(r);
			masterForm.setAllFieldsReadOnly(false);
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailGrid2.reset();
			detailStore.clearData();
			detailStore2.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(detailStore.isDirty()) {	
				detailStore.saveStore();
			} else if(detailStore2.isDirty()) {
				detailStore2.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			if(selectedMasterGrid == 's_pms401ukrv_jwGrid'){
				var selRow = detailGrid.getSelectedRecord();
				if(selRow && detailStore2.getCount() == 0) {
					if(selRow.phantom === true) {
						detailGrid.deleteSelectedRow();
					} else {
						if(selRow.get('INSTOCK_Q') > '1') {
							alert('<t:message code="system.message.product.message041" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
						} else {
							if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
								detailGrid.deleteSelectedRow();
							}
						}
					}
				} else{
					alert('<t:message code="system.message.product.message042" default="불량검사 내역이 존재합니다."/>');
					return false;
				}
			} else{
				var selRow = detailGrid2.getSelectedRecord();
				if(selRow) {
					if(selRow.phantom === true) {
						detailGrid2.deleteSelectedRow();
					} else {
						if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
							detailGrid2.deleteSelectedRow();
						}
					}
				}
			}
		},
		onDeleteAllButtonDown: function() {
			if(confirm('<t:message code="system.message.product.confirm002" default="전체삭제 하시겠습니까?"/>')) {
				detailGrid.reset();
				detailGrid2.reset();
				UniAppManager.app.onSaveDataButtonDown('no');
				UniAppManager.app.onResetButtonDown();
			}
		},
		setDefault: function() {
			masterForm.setValue('DIV_CODE'		, outDivCode);
			masterForm.setValue('INSPEC_DATE'	, new Date());
			panelResult.setValue('DIV_CODE'		, outDivCode);
			panelResult.setValue('INSPEC_DATE'	, new Date());

			masterForm.getForm().wasDirty = false;
			panelResult.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		}
	});



	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "INSPEC_Q" :													//검사량
					if(newValue < 1 ){
						rv='<t:message code="system.message.product.message056" default="접수량이 1보다 작거나 데이터가 없습니다."/>';
						break;
					}
					
					if(Ext.isNumeric(record.get('RECEIPT_Q'))) {
						var receiptQ = record.get('RECEIPT_Q');

						if(receiptQ < newValue ){
							rv='<t:message code="system.message.product.message057" default="검사수량은 잔량보다 적어야 합니다."/>';		//검사수량은 잔량(접수량)보다 적어야 합니다.
							break;
						}
					}

					record.set('GOOD_INSPEC_Q'	, newValue);
					record.set('BAD_INSPEC_Q'	, 0);
					
//					if(record.obj.phantom == false) {									//검사된 수량이 있는지 점검 한다. //'신규가 아닐때 [보완필요]
//						var divCode		= masterForm.getValue('DIV_CODE');
//						var inspecNum	= record.get('INSPEC_NUM');
//						var inspecSeq	= record.get('INSPEC_SEQ');
//						UniAppManager.app.fnInspecQtyCheck(record, fieldName, oldValue, divCode, receiptNum, receiptSeq );
//					}
					break;
					
				case "GOODBAD_TYPE" :												//합격여부
//					record.set('GOOD_INSPEC_Q', 0);
//					record.set('BAD_INSPEC_Q', 0);
//					record.set('INSPEC_Q', 0);
					break;
					
				case "INSPEC_TYPE" :												//검사유형
					if(newValue == "02"){ //샘플검사
						record.set('GOODBAD_TYPE', "01");
					} else {
						record.set('GOODBAD_TYPE' , "");
					}
					break;
				//case "LOT_NO" : //LOT_NO 공통처리가 되어있는지 확인 필요
					
				case "GOOD_INSPEC_Q" : //합격수량
					var inspecQ		= record.get('INSPEC_Q');
					var goodInspecQ	= newValue;
					
					if(inspecQ < goodInspecQ ){
						rv='<t:message code="system.message.product.message043" default="불량수량이 검사수량보다 많을 수 없습니다."/>';
						record.set('GOOD_INSPEC_Q', oldValue);
						break;
					}
					record.set('GOOD_INSPEC_Q', newValue);
					record.set('BAD_INSPEC_Q', inspecQ - newValue);
					break;
					
				case "BAD_INSPEC_Q" : //불량수량
					var inspecQ		= record.get('INSPEC_Q');
					var badInspecQ	= newValue;
					
					if(inspecQ < badInspecQ ){
						rv='<t:message code="system.message.product.message043" default="불량수량이 검사수량보다 많을 수 없습니다."/>';
						record.set('BAD_INSPEC_Q', oldValue);
						break;
					}
					record.set('GOOD_INSPEC_Q', inspecQ - newValue);
					record.set('BAD_INSPEC_Q', newValue);
					break;
			}
			return rv;
		}
	}); //validator

	Unilite.createValidator('validator01', {
		store	: detailStore2,
		grid	: detailGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "BAD_INSPEC_Q" : //검사량
						var receiptQ = detailGrid.getSelectedRecord().get('INSPEC_Q');
						record.set('BAD_INSPEC_Q', newValue);
						var results = detailStore2.sumBy(function(record, id){
													return true;}, 
												['BAD_INSPEC_Q']);
						badInspecQ = results.BAD_INSPEC_Q;
						
						if(receiptQ < badInspecQ ){
							rv='<t:message code="system.message.product.message043" default="불량수량이 검사수량보다 많을 수 없습니다."/>';
							record.set('BAD_INSPEC_Q', oldValue);
							break;
							//검사수량은 잔량(접수량)보다 적어야 합니다.
						}
						
						//합격,불합격에따라 합격수량불량수량 변경
					
//						var GOODBAD_TYPE = detailGrid.getSelectedRecord().get('GOODBAD_TYPE');
//						
//						alert('GOODBAD_TYPE' + GOODBAD_TYPE);
						
					
				//case "LOT_NO" : //LOT_NO 공통처리가 되어있는지 확인 필요
//				  case "INSPEC_Q" : //검사량
////						 var GOODBAD_TYPE = detailGrid.getSelectedRecord().get('GOODBAD_TYPE');
//						
////						alert('GOODBAD_TYPE' + GOODBAD_TYPE);
//						
//				  break;
			}
			return rv;
		}
	}); //validator
}
</script>
