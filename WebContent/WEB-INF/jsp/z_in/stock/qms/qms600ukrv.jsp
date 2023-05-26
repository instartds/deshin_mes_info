<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qms600ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="Q024" /> <!-- 검사담당 -->
	<t:ExtComboStore comboType="AU" comboCode="Q007" /> <!-- 검사유형 -->
	<t:ExtComboStore comboType="AU" comboCode="M414" /> <!-- 합격여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A" />	<!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="T011" /> <!-- 검사방식 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 --> 
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!-- 창고Cell-->
	<t:ExtComboStore comboType="WU" />		<!-- 작업장-->
	<t:ExtComboStore comboType="OU" />		<!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}  
</style>
<script type="text/javascript" >

var searchInfoWindow;	// searchInfoWindow : 조회창
var referSeeReception;	// 접수참조
var CheckItemWindow;	// 검사항목 추가
var selectedMasterGrid = 'qms600ukrvGrid'; 
var masterSelectIdx = 0;
var BsaCodeInfo = {
	gsAutoInputFlag	: '${gsAutoInputFlag}',
	grsManageLotNo	: '${grsManageLotNo}',
	gsSumTypeCell	: '${gsSumTypeCell}'	//20200423 추가: 재고합산유형 - 창고 Cell 합산
};

var sumtypeCell = true;	//20200423 추가: 재고합산유형-: 창고 Cell 합산에 따라 컬럼설정
if(BsaCodeInfo.gsSumTypeCell =='Y') {
	sumtypeCell = false;
}
var outDivCode = UserInfo.divCode;
var checkDraftStatus = false;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'qms600ukrvService.selectMaster',
			update: 'qms600ukrvService.updateDetail',
			create: 'qms600ukrvService.insertDetail',
			destroy: 'qms600ukrvService.deleteDetail',
			syncAll: 'qms600ukrvService.saveAll'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'qms600ukrvService.selectDetail',
			update: 'qms600ukrvService.updateDetail2',
			create: 'qms600ukrvService.insertDetail2',
			destroy: 'qms600ukrvService.deleteDetail2',
			syncAll: 'qms600ukrvService.saveAll2'
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('qms600ukrvSearchForm', {
		ollapsed: UserInfo.appOption.collapseLeftSearch,
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',	
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType:'BOR120' ,
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	  
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype: 'uniDatefield',
				name: 'INSPEC_DATE',
				value: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	  
						panelResult.setValue('INSPEC_DATE', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
//					validateBlank: false,
					valueFieldName:'ITEM_CODE',
					textFieldName:'ITEM_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));	
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>',
				name:'INSPEC_PRSN', 
				xtype: 'uniCombobox', 
				comboType:'AU' ,
				comboCode:'Q024',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	  
						panelResult.setValue('INSPEC_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.inspectype" default="검사유형"/>',
				name:'INSPEC_TYPE', 
				xtype: 'uniCombobox', 
				comboType:'AU' ,
				comboCode:'Q007',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	  
						panelResult.setValue('INSPEC_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.inspecno" default="검사번호"/>',
				name: 'INSPEC_NUM',
				xtype: 'uniTextfield',
				readOnly : true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	  
						panelResult.setValue('INSPEC_NUM', newValue);
					}
				}
			},{
				fieldLabel: '검사번호Grid용',
				name: 'INSPEC_NUM_TEMP',
				xtype: 'uniTextfield',
				readOnly : true,
				hidden: true
			},{
				fieldLabel: '순번Grid용',
				name: 'INSPEC_SEQ_TEMP',
				xtype: 'uniTextfield',
				readOnly : true,
				hidden: true
			},{
				fieldLabel: '아이템코드Grid용',
				name: 'ITEM_CODE_TEMP',
				xtype: 'uniTextfield',
				readOnly : true,
				hidden: true
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
					// this.mask();
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
				// this.unmask();
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
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		items: [{	
			xtype:'container',
			padding:'0 5 5 5',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns : 3},
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType:'BOR120' ,
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	  
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype: 'uniDatefield',
				name: 'INSPEC_DATE',
				value: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	  
						panelSearch.setValue('INSPEC_DATE', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
//					validateBlank: false,
					valueFieldName:'ITEM_CODE',
					textFieldName:'ITEM_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
								panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));	
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>',
				name:'INSPEC_PRSN', 
				xtype: 'uniCombobox', 
				comboType:'AU' ,
				comboCode:'Q024',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	  
						panelSearch.setValue('INSPEC_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.inspectype" default="검사유형"/>',
				name:'INSPEC_TYPE', 
				xtype: 'uniCombobox', 
				comboType:'AU' ,
				comboCode:'Q007',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	  
						panelSearch.setValue('INSPEC_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.inspecno" default="검사번호"/>',
				name: 'INSPEC_NUM',
				xtype: 'uniTextfield',
				readOnly : true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	  
						panelSearch.setValue('INSPEC_NUM', newValue);
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
					// this.mask();
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
				// this.unmask();
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
	
	var checkItemSearch = Unilite.createSearchForm('otherorderForm', {		// 검사항목
			layout :  {type : 'uniTable', columns : 2},
			items :[
				{ 
					fieldLabel: '<t:message code="system.label.product.search" default="검색"/>' ,
					name:''  ,
					xtype: 'uniTextfield' 
				},{ 
					fieldLabel: ' ',
					xtype: 'radiogroup', width: 230, name: 'rdoRadio',
					items:[{inputValue: '1', boxLabel: '<t:message code="system.label.product.codeinorder" default="코드순"/>', name: 'RDO'},
						   {inputValue: '2', boxLabel: '<t:message code="system.label.product.nameinorder" default="이름순"/>', name: 'RDO'} 
					]
			   }
			],
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
					// this.mask();
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
				// this.unmask();
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
	
	/**
	 * main Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('qms600ukrvDetailModel', {
		fields: [	 
			{name:'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type:'string'},
			{name:'INSPEC_NUM'		,text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'					,type:'string'},
			{name:'INSPEC_SEQ'		,text: '검사순번'			,type:'int'},
			{name:'ITEM_CODE'		,text: '<t:message code="system.label.product.item" default="품목"/>'							,type:'string'},
			{name:'ITEM_NAME'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'					,type:'string'},
			{name:'SPEC'			,text: '<t:message code="system.label.product.spec" default="규격"/>'							,type:'string'},
			{name:'STOCK_UNIT'		,text: '<t:message code="system.label.product.unit" default="단위"/>'							,type:'string'},
			{name:'PRODT_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'				,type:'uniQty'},
			{name:'INSPEC_TYPE'		,text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'					,type:'string' , comboType:'AU' , comboCode:'Q007', allowBlank: false},
			{name:'INSPEC_GUBUN'	,text: '검사구분'			,type:'string' , comboType:'AU' , comboCode:'Q037'},
			{name:'GOODBAD_TYPE'	,text: '<t:message code="system.label.product.passyn" default="합격여부"/>'						,type:'string' , comboType:'AU' , comboCode:'M414'},
			{name:'RECEIPT_Q'		,text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'					,type:'uniQty'},
			{name:'INSPEC_Q'		,text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'					,type:'uniQty', allowBlank: false},
			{name:'GOOD_INSPEC_Q'	,text: '<t:message code="system.label.product.passqty" default="합격수량"/>'					,type:'uniQty'},
			{name:'BAD_INSPEC_Q'	,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'					,type:'uniQty'},
			{name:'INSTOCK_Q'		,text: '<t:message code="system.label.product.receiptqty" default="입고량"/>'					,type:'uniQty'},
			{name:'INSPEC_PRSN'		,text: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>'		,type:'string' , comboType:'AU' , comboCode:'Q024', allowBlank: false},
			{name:'RECEIPT_NUM'		,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'					,type:'string'},
			{name:'RECEIPT_SEQ'		,text: '<t:message code="system.label.product.receiptseq" default="접수순번"/>'					,type:'string'},
			{name:'INSPEC_DATE'		,text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'					,type:'uniDate'},
			{name:'LOT_NO'			,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'						,type:'string'},
			{name:'PRODT_NUM'		,text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'		,type:'string'},
			{name:'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				,type:'string'},
			{name:'PROJECT_NO'		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				,type:'string'},
			{name:'PJT_CODE'		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				,type:'string'},
			{name:'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'						,type:'string'},
			{name:'ITEM_ACCOUNT'	,text: '<t:message code="system.label.product.itemaccount" default="품목계정"/>'				,type:'string'},
			{name:'COMP_CODE'		,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'					,type:'string'},
			{name:'GOOD_WH_CODE'	,text: '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>'		,type:'string'},
			{name:'GOOD_PRSN'		,text: '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>'		,type:'string'},
			{name:'BAD_WH_CODE'		,text: '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>'	,type:'string'},
			{name:'BAD_PRSN'		,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'	,type:'string'},
			{name: 'INOUT_NUM'		,text: '<t:message code="system.label.product.inoutnum" default="출고번호"/>'					,type:'string'},
			{name: 'IN_WH_CODE'		,text: '입고창고'			,type:'string'  , comboType:'OU'/*, allowBlank: sumtypeCell*/},										//20200423 추가: , allowBlank: sumtypeCell, 20200427 수정: allowBlank 주석 - 저장시 개별 체크
			{name: 'ISNULL_WH_CODE'	,text: 'ISNULL_WH_CODE'	,type:'string'},
			{name: 'REMAIN_STOCK_Q'	,text: '잔여수량'			,type:'uniQty'},
			{name: 'INOUT_SEQ'		,text: '<t:message code="system.label.product.seq" default="순번"/>'			,type:'int'},
			//20200422 추가
			{name: 'IN_WH_CELL_CODE',text: '입고창고CELL'		,type:'string'  , store: Ext.data.StoreManager.lookup('whCellList')/*, allowBlank: sumtypeCell*/},	//20200423 추가: , allowBlank: sumtypeCell, 20200427 수정: allowBlank 주석 - 저장시 개별 체크
			{name: 'BTR_REMARK'		,text: '자동'				,type:'string'}
		]
	});
	
	Unilite.defineModel('qms600ukrvDetailModel2', {
		fields: [	 
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type:'string'},
			{name: 'INSPEC_NUM'			,text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'				,type:'string'},
			{name: 'INSPEC_SEQ'			,text: '<t:message code="system.label.product.inspecseq" default="검사순번"/>'				,type:'int'},
			{name: 'BAD_INSPEC_CODE'		,text: '<t:message code="system.label.product.inspectcode" default="검사코드"/>'				,type:'string'},
			{name: 'BAD_INSPEC_NAME'		,text: '<t:message code="system.label.product.inspectsubject" default="검사항목"/>'				,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'					,type:'string'},
			{name: 'MEASURED_VALUE'		,text: '<t:message code="system.label.product.mesuredvalue" default="측정치"/>'				,type:'string'},
			{name: 'BAD_INSPEC_Q'		,text: '<t:message code="system.label.product.defectinspecqty" default="불량검사량"/>'				,type:'uniQty', allowBlank: false},
			{name: 'INSPEC_REMARK'		,text: '<t:message code="system.label.product.inspeccontents" default="검사내용"/>'				,type:'string'},
			{name: 'MANAGE_REMARK'		,text: '<t:message code="system.label.product.actioncontents" default="조치내용"/>'				,type:'string'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'				,type:'string'},
			{name: 'GUBUN'				,text: '<t:message code="system.label.product.detailsclassification" default="내역구분"/>'				,type:'string'}
		]
	});
	
	Unilite.defineModel('qms600ukrvDetailModel3', {
		fields: [	 
			{name: 'MAIN_CODE'			,text: 'MAIN_CODE'				,type:'string'},
			{name: 'SUB_CODE'			,text: '<t:message code="system.label.product.code" default="코드"/>'						,type:'string'},
			{name: 'CODE_NAME'			,text: '<t:message code="system.label.product.codename" default="코드명"/>'					,type:'string'},
			{name: 'REF_CODE1'			,text: 'REF_CODE1'				,type:'string'},
			{name: 'REF_CODE2'			,text: 'REF_CODE2'				,type:'string'},
			{name: 'REF_CODE3'			,text: 'REF_CODE3'				,type:'string'},
			{name: 'REF_CODE4'			,text: 'REF_CODE4'				,type:'string'},
			{name: 'REF_CODE5'			,text: 'REF_CODE5'				,type:'string'},
			{name: 'REF_CODE6'			,text: 'REF_CODE6'				,type:'string'},
			{name: 'REF_CODE7'			,text: 'REF_CODE7'				,type:'string'},
			{name: 'REF_CODE8'			,text: 'REF_CODE8'				,type:'string'},
			{name: 'REF_CODE9'			,text: 'REF_CODE9'				,type:'string'},
			{name: 'REF_CODE10'			,text: 'REF_CODE10'				,type:'string'}
		]
	});
	
	var detailStore = Unilite.createStore('qms600ukrvDetailStore', {
		model: 'qms600ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		
		loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var store = detailGrid.getStore();				
				if(store.getCount() > 0) {
					Ext.getCmp('CheckItemButton').setDisabled(false);
//					Ext.getCmp('ItemDeleteButton').setDisabled(false);
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
				if( detailStore2.isDirty() || store.isDirty() )   {
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
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			var check = true;
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();				
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var inspecNum = panelSearch.getValue('INSPEC_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['INSPEC_NUM'] != inspecNum) {
					record.set('INSPEC_NUM', orderNum);
				}
				if(!Ext.isEmpty(record.data['GOODBAD_TYPE']) && record.data['GOODBAD_TYPE'] == '01') {
					if(Ext.isEmpty(record.data['IN_WH_CODE'])) {
						alert('입고창고를 지정하세요');
						check = false;
					}
					if(Ext.isEmpty(record.data['IN_WH_CELL_CODE'])) {
						alert('입고창고CELL을 지정하세요');
						check = false;
					}
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0&&check == true) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.setValue("INSPEC_NUM", master.INSPEC_NUM);
						panelResult.setValue("INSPEC_NUM", master.INSPEC_NUM);
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
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
				//}
				//this.syncAll(config);
				this.syncAllDirect(config);
			} else {
				if(!Ext.isEmpty(inValidRecs)){
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					// alert(Msg.sMB083);
				}
			}
		}
	});
	
	var detailStore2 = Unilite.createStore('qms600ukrvDetailStore2', {
		model: 'qms600ukrvDetailModel2',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy2,
		loadStoreRecords: function(record) {
//			var param= param.data.items[0];			
			var param = record.data;
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();				
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var inspecNum = panelSearch.getValue('INSPEC_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['INSPEC_NUM'] != inspecNum) {
					record.set('INSPEC_NUM', orderNum);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			// 1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	// syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);	
						detailStore.loadStoreRecords();
					 } 
				};
				// }
				// this.syncAll(config);
				this.syncAllDirect(config);
			} else {
				detailGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert(Msg.sMB083);
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
				if( detailStore.isDirty() || store.isDirty() )   {
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
	
	var checkItemStore = Unilite.createStore('qms600ukrvDetailStore3', {// 이동요청
																		// 참조
			model: 'qms600ukrvDetailModel3',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | next 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read: 'qms600ukrvService.selectCheckItem'				
				}
			}/*
				 * , listeners:{ load:function(store, records, successful,
				 * eOpts) { if(successful) { var masterRecords =
				 * directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
				 * var refRecords = new Array(); if(masterRecords.items.length >
				 * 0) { console.log("store.items :", store.items);
				 * console.log("records", records); Ext.each(records,
				 * function(item, i) { Ext.each(masterRecords.items,
				 * function(record, i) { console.log("record :", record);
				 * if((record.data['BASIS_NUM'] == item.data['INOUT_NUM']) &&
				 * (record.data['BASIS_SEQ'] == item.data['INOUT_SEQ']) ){
				 * refRecords.push(item); } }); } ); store.remove(refRecords); } } } }
				 */,
			loadStoreRecords : function()	{
				var param= checkItemSearch.getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	
	var detailGrid = Unilite.createGrid('qms600ukrvGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			useContextMenu: true,
			onLoadSelectFirst: false
		},
		tbar: [{
			xtype: 'button',
			itemId:'refTool',
			text: '<div style="color: blue"><t:message code="system.label.product.receiptrefer" default="접수참조"/></div>',
			handler: function() {
				if(panelSearch.setAllFieldsReadOnly(true)){
					openProductionWindow();
				}
			}
		}],
		store: detailStore,
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 100 , hidden: true},
			{dataIndex: 'INSPEC_NUM'		, width: 66  , hidden: true},
			{dataIndex: 'INSPEC_SEQ'		, width: 55 , hidden: true},
			{dataIndex: 'ISNULL_WH_CODE'	, width: 80 , hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 80},
			{dataIndex: 'ITEM_NAME'			, width: 146}, 
			{dataIndex: 'SPEC'				, width: 166},
			{dataIndex: 'LOT_NO'			, width: 100,
				editor: Unilite.popup('LOTNO_G', {
						textFieldName: 'LOTNO_CODE',
						DBtextFieldName: 'LOTNO_CODE',
						autoPopup: true,
						listeners: {
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
										/*
										 * rtnRecord.set('PURCHASE_TYPE',
										 * record['PURCHASE_TYPE']);
										 * rtnRecord.set('SALES_TYPE',
										 * record['SALES_TYPE']);
										 * rtnRecord.set('PURCHASE_RATE',
										 * record['PURCHASE_RATE']);
										 * rtnRecord.set('PURCHASE_P',
										 * record['PURCHASE_P']);
										 * rtnRecord.set('SALE_P',
										 * record['SALE_BASIS_P']);
										 */	
									}); 
								},
								scope: this
							},
							'onClear': function(type) {
								var record1 = detailGrid.getSelectedRecord();
								record1.set('LOT_NO', '');
								/*
								 * record1.set('PURCHASE_TYPE', '');
								 * record1.set('SALES_TYPE', '');
								 * record1.set('PURCHASE_RATE', '');
								 * record1.set('PURCHASE_P', '');
								 * record1.set('SALE_P', '');
								 */
							},
							applyextparam: function(popup){
								var record = detailGrid.getSelectedRecord();
								var divCode = panelSearch.getValue('DIV_CODE');
								var itemCode = record.get('ITEM_CODE');
								var itemName = record.get('ITEM_NAME');
								var whCode = record.get('WH_CODE');
								popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode});
							}
						}
				})
			},				 
			{dataIndex: 'STOCK_UNIT'		, width: 40},
			{dataIndex: 'INSPEC_GUBUN'		, width: 93},
			{dataIndex: 'INSPEC_TYPE'		, width: 93},
			{dataIndex: 'GOODBAD_TYPE'		, width: 93},
			{dataIndex: 'IN_WH_CODE'		, width: 93},
			//20200422추가
			{dataIndex: 'IN_WH_CELL_CODE'	, width: 93, hidden: sumtypeCell,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filterBy(function(item){
						return item.get('option') == record.get('IN_WH_CODE')
					})
				}
			},		//20200423 추가: , hidden: sumtypeCell
			{dataIndex: 'INSPEC_Q'			, width: 80},
			{dataIndex: 'GOOD_INSPEC_Q'		, width: 80},
			{dataIndex: 'BAD_INSPEC_Q'		, width: 80},
			{dataIndex: 'REMAIN_STOCK_Q'	, width: 93},
			{dataIndex: 'INSPEC_PRSN'		, width: 90},
			{dataIndex: 'INOUT_NUM'			, width: 130},
			{dataIndex: 'INOUT_SEQ'			, width: 55},
			{dataIndex: 'REMARK'			, width: 133},
			//20200422추가
			{dataIndex: 'BTR_REMARK'		, width: 150, hidden: true} 
		], 
		listeners: {
//			select: function() {
//				selectedGrid = 'qms600ukrvGrid';
//				selectedMasterGrid = 'qms600ukrvGrid';
//				UniAppManager.setToolbarButtons(['delete'], true);
//			}, 
			cellclick: function() {
				selectedGrid = 'qms600ukrvGrid';
				selectedMasterGrid = 'qms600ukrvGrid';
				
				if( detailStore.isDirty() || detailStore2.isDirty() )   {
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
//				if(selectedMasterGrid == 'qms600ukrvGrid2' && UniAppManager.app._needSave())  {
//				   alert('검사내역을 먼저 저장하셔야 선택이 가능합니다.');
//				   return false;
//				}
				if(Ext.isEmpty(e.record.data.GOODBAD_TYPE)&&UniUtils.indexOf(e.field,'IN_WH_CODE')){
					if(!Ext.isEmpty(e.record.data.ISNULL_WH_CODE)){
						alert('합격여부 먼저 선택하세요');
					}
					return false;
				}
				if(e.record.data.ISNULL_WH_CODE == 'N'&&UniUtils.indexOf(e.field,['IN_WH_CODE', 'IN_WH_CELL_CODE'])){		//20200427 추가: , 'IN_WH_CELL_CODE'
					return false;
				}
				
					if(checkDraftStatus)	{
					return false;
				}else if(e.record.phantom) {
					if (UniUtils.indexOf(e.field, 
									['DIV_CODE','INSPEC_NUM'/*, 'GOODBAD_TYPE'*/,'INSPEC_SEQ','ITEM_CODE','ITEM_NAME','SPEC','STOCK_UNIT',
									 'PRODT_Q','RECEIPT_Q','GOOD_INSPEC_Q','BAD_INSPEC_Q','INSTOCK_Q','RECEIPT_NUM',
									 'RECEIPT_SEQ','INSPCE_DATE,','PRODT_NUM','WKORD_NUM','PROJECT_NO','PJT_CODE','ITME_ACCOUNT','LOT_NO','INOUT_NUM','REMAIN_STOCK_Q']))
					return false;
				}
				
				if(!e.record.phantom){
					if(e.record.data.INSTOCK_Q == e.record.data.INSPEC_Q) {
						return false;
					}
					else if(e.record.data.INSTOCK_Q != e.record.data.INSPEC_Q) {
						if (UniUtils.indexOf(e.field, 
									['DIV_CODE', 'INSPEC_NUM', 'INSPEC_SEQ', 'ITEM_CODE', 'ITEM_NAME', 'SPEC', 'STOCK_UNIT',
									 'PRODT_Q', 'RECEIPT_Q', 'GOOD_INSPEC_Q', 'BAD_INSPEC_Q', 'RECEIPT_NUM', 'RECEIPT_SEQ','INSPCE_DATE',
									 'PRODT_NUM', 'WKORD_NUM', 'PROJECT_NO', 'PJT_CODE', 'ITME_ACCOUNT','LOT_NO','INOUT_NUM','REMAIN_STOCK_Q']))
							return false;
					}
				}
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0) {
					var record = selected[0];
					if(record.phantom) return false;
					var param= panelSearch.getValues();	
					param.ITEM_CODE = record.get('ITEM_CODE');   
					param.INSPEC_NUM = record.get('INSPEC_NUM');   
					param.INSPEC_SEQ = record.get('INSPEC_SEQ');   
					param.DIV_CODE = record.get('DIV_CODE');
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
			panelSearch.setValues({'INSPEC_NUM_TEMP':inspecNum});
			panelSearch.setValues({'INSPEC_SEQ_TEMP':inspecSeq});
			panelSearch.setValues({'ITEM_CODE_TEMP':itemCode});
		},
		disabledLinkButtons: function(b) {
		},
		setEstiData:function(record) {
			var grdRecord = this.getSelectedRecord();	
	   
			grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			grdRecord.set('INSPEC_NUM'			, panelSearch.getValue('INSPEC_NUM'));
			grdRecord.set('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));	
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);	
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);	
			grdRecord.set('SPEC'				, record['SPEC']);	
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			
//			grdRecord.set('INSPEC_PRSN'			, record['INSPEC_PRSN']);
			grdRecord.set('PRODT_Q'				, record['PRODT_Q']);
			grdRecord.set('RECEIPT_Q'			, record['NOT_INSPEC_Q']);
			grdRecord.set('INSPEC_Q'			, record['NOT_INSPEC_Q']);
			grdRecord.set('INOUT_NUM'			, record['INOUT_NUM']);
			grdRecord.set('RECEIPT_SEQ'			, record['RECEIPT_SEQ']);
			grdRecord.set('INSPEC_DATE'			, panelSearch.getValue('INSPEC_DATE'));
			grdRecord.set('GOOD_INSPEC_Q'		, record['NOT_INSPEC_Q']);
			grdRecord.set('BAD_INSPEC_Q'		, 0);
			grdRecord.set('INSTOCK_Q'			, 0);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('REMAIN_STOCK_Q'		, record['REMAIN_STOCK_Q']);
			grdRecord.set('INSPEC_SEQ'		, record['INSPEC_SEQ']);
			grdRecord.set('INOUT_SEQ'		, record['INOUT_SEQ']);
			
			grdRecord.set('INSPEC_GUBUN'			, '02');
			grdRecord.set('INSPEC_TYPE'			,  '02');
			
		}
	}); 
	
	var detailGrid2 = Unilite.createGrid('qms600ukrvGrid2', {
		layout: 'fit',
		region:'south',
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
		},
		tbar: [{
			name: 'CheckItem',
			id: 'CheckItemButton',
			xtype:'button',
			text : '<t:message code="system.label.product.inspectsubjectadd" default="검사항목추가"/>',
			width: 110,
			handler : function(){
				openCheckItemWindow();
			}
		}/*,{
			name: 'ItemDelete',
			id: 'ItemDeleteButton',
			xtype:'button',
			text : '검사항목 삭제',
			width: 110,
			handler : function(){
				var selRow = detailGrid2.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid2.deleteSelectedRow();
				}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					detailGrid2.deleteSelectedRow();
				}
			}
		
		}*//*,{xtype  : 'container', html: "<div style='font-weight:bold; color:black;'> 판정결과 접수량 일괄처리 :</div>"	}
		,{
			name: 'Accept',
			id: 'AcceptButton',
			xtype:'button',
			text : '합격',
			width: 85,
			handler : function(){
				
			}
		},{
			name: 'Reject',
			id: 'RejectButton',
			xtype:'button',
			text : '불합격',
			width: 85,
			handler : function() {
				
			}
		}*/],
		store: detailStore2,
		columns: [						
			{dataIndex: 'DIV_CODE'			, width: 66 ,hidden: true},							
			{dataIndex: 'INSPEC_NUM'			, width: 66 ,hidden: true},							
			{dataIndex: 'INSPEC_SEQ'			, width: 40 ,hidden: true},								
			{dataIndex: 'BAD_INSPEC_CODE'		, width: 66},												
			{dataIndex: 'BAD_INSPEC_NAME'		, width: 100},							
			{dataIndex: 'SPEC'				, width: 166},							
			{dataIndex: 'MEASURED_VALUE'		, width: 166},								
			{dataIndex: 'BAD_INSPEC_Q'		, width: 100},		
			{dataIndex: 'INSPEC_REMARK'		, width: 266},							
			{dataIndex: 'MANAGE_REMARK'		, width: 266},							
			{dataIndex: 'COMP_CODE'			, width: 266,hidden: true},								
			{dataIndex: 'GUBUN'				, width: 66 ,hidden: true}
		],
		listeners: { 
//			select: function() {
//				selectedGrid = 'qms600ukrvGrid2';
//				selectedMasterGrid = 'qms600ukrvGrid2';
//				UniAppManager.setToolbarButtons(['delete'], false);
//			}, 
			cellclick: function() {
				selectedGrid = 'qms600ukrvGrid2';
				selectedMasterGrid = 'qms600ukrvGrid2';
				
				if( detailStore.isDirty() || detailStore2.isDirty() )   {
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
		setCheckItemData: function(record) {						// 검사항목
			var grdRecord = this.getSelectedRecord();  
//			var records = detailStore2.data.items;
//			if(records.BAD_INSPEC_CODE != record['SUB_CODE']) {	//////////////////////////////////////// 레코드에 있는 값이면 빼고 SET됨.
			grdRecord.set('DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('INSPEC_NUM'		, panelSearch.getValue('INSPEC_NUM'));
			grdRecord.set('INSPEC_SEQ'		, panelSearch.getValue('INSPEC_SEQ_TEMP'));
			grdRecord.set('BAD_INSPEC_CODE'	, record['SUB_CODE']);
			grdRecord.set('BAD_INSPEC_NAME'	, record['CODE_NAME']);
			grdRecord.set('SPEC'			, '');
			grdRecord.set('MEASURED_VALUE'	, '');
			grdRecord.set('BAD_INSPEC_Q'	, '0');
			grdRecord.set('INSPEC_REMARK'	, '');
			grdRecord.set('MANAGE_REMARK'	, '');
			grdRecord.set('COMP_CODE'		, UserInfo.compCode);
			grdRecord.set('GUBUN'			, '');
			selectedMasterGrid = 'qms600ukrvGrid2';
			
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
	
	var checkItemGrid = Unilite.createGrid('qms600ukrvGrid3', {	// 검사항목 팝업
		// title: '기본',
		layout : 'fit',
		store: checkItemStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns: [  
			 { dataIndex: 'MAIN_CODE'	, width: 80, hidden: true},
			 { dataIndex: 'SUB_CODE'	, width: 80},
			 { dataIndex: 'CODE_NAME'	, width: 250},
			 { dataIndex: 'REF_CODE1'	, width: 80, hidden: true},
			 { dataIndex: 'REF_CODE2'	, width: 80, hidden: true},
			 { dataIndex: 'REF_CODE3'	, width: 80, hidden: true},
			 { dataIndex: 'REF_CODE4'	, width: 80, hidden: true},
			 { dataIndex: 'REF_CODE5'	, width: 80, hidden: true},
			 { dataIndex: 'REF_CODE6'	, width: 80, hidden: true},
			 { dataIndex: 'REF_CODE7'	, width: 80, hidden: true},
			 { dataIndex: 'REF_CODE8'	, width: 80, hidden: true},
			 { dataIndex: 'REF_CODE9'	, width: 80, hidden: true},
			 { dataIndex: 'REF_CODE10'	, width: 80, hidden: true}
	   ],
	   listeners: {	
				onGridDblClick:function(grid, record, cellIndex, colName) {}
	   },
	   returnData: function(record) {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i) {
				var isSuccess = detailGrid2.checkDupleCode(record);
				if(isSuccess){
//					checkItemStore.remove(record);
					UniAppManager.app.onNewDataButtonDown2();
					detailGrid2.setCheckItemData(record.data);
				}
			}); 
		}
	});
	
	function openCheckItemWindow() {		// 검사항목 추가
		if(!CheckItemWindow) {
			CheckItemWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.inspectsubject" default="검사항목"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				
				items: [checkItemSearch, checkItemGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.product.inquiry" default="조회"/>',
						handler: function() {
							checkItemStore.loadStoreRecords();
							if(checkItemSearch.setAllFieldsReadOnly(true) == false){
								return false;
							}
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
						handler: function() {
							
							checkItemGrid.returnData();
							CheckItemWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							CheckItemWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
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
	
	/**
	 * 작업지시를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	 // 조회창 폼 정의
	var checkNoSearch = Unilite.createSearchForm('checkNoSearchForm', {
		layout: {type: 'uniTable', columns : 2},
//		trackResetOnLoad: true,
		items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType:'BOR120',
				allowBlank:false 
			},{ 
				fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype: 'uniDateRangefield',  
				startFieldName: 'INSPEC_DATE_FR',
				endFieldName:'INSPEC_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				textFieldWidth:170
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank: false, 
					valueFieldName:'ITEM_CODE',
					textFieldName:'ITEM_NAME'
			}),{
				fieldLabel: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
				xtype: 'uniTextfield',
				name:'LOT_NO',
				width:315
			} ,{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'WU'
			}]
	}); // createSearchForm
	
	// 조회창 모델 정의
	Unilite.defineModel('checkNoMasterModel', {
		fields: [{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'			, type: 'string'},		 
				 {name: 'INSPEC_SEQ'	, text: '<t:message code="system.label.product.seq" default="순번"/>'				, type: 'int'},		 
				 {name: 'INSPEC_DATE'	, text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'			, type: 'uniDate'},		 
				 {name: 'ITEM_CODE'		, text: '<t:message code="system.label.product.item" default="품목"/>'			, type: 'string'},		 
				 {name: 'ITEM_NAME'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},		 
				 {name: 'SPEC'			, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},		 
				 {name: 'STOCK_UNIT'	, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'},		 
				 {name: 'INSPEC_Q'		, text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'			, type: 'uniQty'},		 
				 {name: 'GOOD_INSPEC_Q'	, text: '<t:message code="system.label.product.passqty" default="합격수량"/>'			, type: 'uniQty'},		 
				 {name: 'BAD_INSPEC_Q'	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'			, type: 'uniQty'},		 
				 {name: 'INSPEC_TYPE'	, text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'			, type: 'string'  , comboType:'AU' , comboCode:'Q007'},		 
				 {name: 'INSPEC_PRSN'	, text: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>'		, type: 'string'  , comboType:'AU' , comboCode:'Q024'},		 
				 {name: 'LOT_NO'		, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			, type: 'string'},		 
				 {name: 'PRODT_NUM'		, text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'			, type: 'string'},		 
				 {name: 'WKORD_NUM'		, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		, type: 'string'},		 
				 {name: 'PROJECT_NO'	, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},		 
				 {name: 'PJT_CODE'		, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
				 {name: 'INOUT_NUM'		,text: '<t:message code="system.label.product.inoutnum" default="출고번호"/>'			,type:'string'}
		]
	});
	// 조회창 스토어 정의
	var checkNoMasterStore = Unilite.createStore('checkNoMasterStore', {
		model: 'checkNoMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'qms600ukrvService.selectOrderNumMasterList'
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
	
	var checkNoMasterGrid = Unilite.createGrid('qms600ukrvcheckNoMasterGrid', {
		// title: '기본',
		layout : 'fit',	   
		store: checkNoMasterStore,
		uniOpt:{
					expandLastColumn: false,
					useRowNumberer: false
		},
		columns:  [{ dataIndex: 'INSPEC_NUM'	, width: 106 },
				   { dataIndex: 'INSPEC_SEQ'	, width: 55  },
				   { dataIndex: 'INSPEC_DATE'	, width: 80  },
				   { dataIndex: 'ITEM_CODE'		, width: 80  },
				   { dataIndex: 'ITEM_NAME'		, width: 146 },
				   { dataIndex: 'SPEC'			, width: 100 },
				   { dataIndex: 'STOCK_UNIT'	, width: 46  },
				   { dataIndex: 'INSPEC_Q'		, width: 73  },
				   { dataIndex: 'GOOD_INSPEC_Q'	, width: 73  },
				   { dataIndex: 'BAD_INSPEC_Q'	, width: 73  },
				   { dataIndex: 'INSPEC_TYPE'	, width: 66  },
				   { dataIndex: 'INSPEC_PRSN'	, width:80  },
				   { dataIndex: 'LOT_NO'		, width: 106 },
				   { dataIndex: 'PRODT_NUM'		, width: 100 },
				   { dataIndex: 'WKORD_NUM'		, width: 100 },
				   { dataIndex: 'PROJECT_NO'	, width: 100 }
		  ] ,
		  listeners: {
			  onGridDblClick: function(grid, record, cellIndex, colName) {
					checkNoMasterGrid.returnData(record);
					UniAppManager.app.onQueryButtonDown();
					searchInfoWindow.hide();
			  }
		  } // listeners
		  ,returnData: function(record)	{
			if(Ext.isEmpty(record))	{
				record = this.getSelectedRecord();
			}
			panelSearch.setValues({
				'INSPEC_DATE':record.get('INSPEC_DATE'), 
				'INSPEC_NUM':record.get('INSPEC_NUM'),
				'INSPEC_PRSN':record.get('INSPEC_PRSN')
				});
		  }
	});
	
	// 조회창 메인
	function opensearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.inspecnoinquiry" default="검사번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [checkNoSearch, checkNoMasterGrid],
				tbar:  ['->',
						{	itemId : 'searchBtn',
							text: '<t:message code="system.label.product.inquiry" default="조회"/>',
							handler: function() {
								checkNoMasterStore.loadStoreRecords();
							},
							disabled: false
						}, {
							itemId : 'closeBtn',
							text: '<t:message code="system.label.product.close" default="닫기"/>',
							handler: function() {
								searchInfoWindow.hide();
							},
							disabled: false
						}
				],
				listeners : {beforehide: function(me, eOpt)	{
											checkNoSearch.clearForm();
											checkNoMasterGrid.reset();
										},
							 beforeclose: function( panel, eOpts )	{
											checkNoSearch.clearForm();
											checkNoMasterGrid.reset();
										},
							 show: function( panel, eOpts )	{
								checkNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
								checkNoSearch.setValue('INSPEC_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('INSPEC_DATE')));
								checkNoSearch.setValue('INSPEC_DATE_TO',panelSearch.getValue('INSPEC_DATE'));
								checkNoSearch.setValue('ITEM_CODE',panelSearch.getValue('ITEM_CODE'));
								checkNoSearch.setValue('ITEM_NAME',panelSearch.getValue('ITEM_NAME'));
								checkNoSearch.setValue('LOT_NO',panelSearch.getValue('LOT_NO'));
								checkNoSearch.setValue('WORK_SHOP_CODE',panelSearch.getValue('WORK_SHOP_CODE'));
							 }
				}		
			})
		}
		searchInfoWindow.show();
		searchInfoWindow.center();
	}
	
	// 접수 참조 폼 정의
	 var productionSearch = Unilite.createSearchForm('productionForm', {
			layout :  {type : 'uniTable', columns : 2},
			items :[{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType:'BOR120' ,
				allowBlank:false,
				value: UserInfo.divCode
			},{
				fieldLabel: '<t:message code="system.label.product.inspecoutdate" default="검사출고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'RECEIPT_DATE_FR',
				endFieldName: 'RECEIPT_DATE_TO',	
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
		   },
				Unilite.popup('DIV_PUMOK',{
				fieldLabel:'<t:message code="system.label.product.item" default="품목"/>' , 
				validateBlank: false,
				valueFieldName:'ITEM_CODE',
				textFieldName:'ITEM_NAME'
			}),/* {
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'WU'
			}, */{
				fieldLabel: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
				xtype: 'uniTextfield',
				name:'LOT_NO'
		   }/* ,{
				fieldLabel: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
				xtype: 'uniTextfield',
				name:'PROJECT_NO'
		   } */]
	});
	
	
	// 접수 참조 모델 정의
	Unilite.defineModel('qms600ukrvProductionModel', {
		fields: [	 
			{name: 'CHK'				,text: '<t:message code="system.label.product.selection" default="선택"/>'					,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'				,type:'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'					,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'					,type:'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.classfication" default="구분"/>'					,type:'string'},
			{name: 'RECEIPT_DATE'		,text: '<t:message code="system.label.product.receiptdate" default="접수일"/>'				,type:'uniDate'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'					,type:'uniQty'},
			{name: 'INSPEC_Q'			,text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'					,type:'uniQty'},
			{name: 'NOT_INSPEC_Q'		,text: '<t:message code="system.label.product.noinspecqty" default="미검사량"/>'				,type:'uniQty'},
			{name: 'INSPEC_METH_PRODT'	,text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'				,type:'string' , comboType:'AU' , comboCode:'Q007'},
			{name: 'RECEIPT_NUM'		,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'				,type:'string'},
			{name: 'RECEIPT_SEQ'		,text: '<t:message code="system.label.product.receiptseq" default="접수순번"/>'				,type:'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'					,type:'string'},
			{name: 'PRODT_NUM'			,text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'			,type:'string'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.product.itemaccount" default="품목계정"/>'				,type:'string'},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.product.inspecoutdate" default="검사출고일"/>'				,type:'uniDate'},
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.product.inoutnum" default="출고번호"/>'			,type:'string'},
			{name: 'INOUT_SEQ'			,text: '출고순번'			,type:'string'},
			{name: 'REMAIN_STOCK_Q'		,text: '잔여수량'			,type:'uniQty'}
		]
	});	
	
	// 접수 참조 스토어 정의
	var productionStore = Unilite.createStore('qms600ukrvProductionStore', {
		model: 'qms600ukrvProductionModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'qms600ukrvService.selectEstiList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)	{
					var estiRecords = new Array();
					var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);  

					if(masterRecords.items.length > 0)	{
					console.log("store.items :", store.items);
					console.log("records", records);
					Ext.each(records, function(item, i){
						Ext.each(masterRecords.items, function(record, i){
							console.log("record :", record);
							if( (record.data['INOUT_NUM'] == item.data['INOUT_NUM'])	&& (record.data['ITEM_CODE'] == item.data['ITEM_CODE']))	
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
	
	var productionGrid = Unilite.createGrid('qms600ukrvproductionGrid', {
		layout : 'fit',
		store: productionStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
			uniOpt:{
				onLoadSelectFirst : false
			},
		columns: [
			{dataIndex: 'CHK'				, width: 33 ,hidden:true},
			{dataIndex: 'ITEM_CODE'			, width: 93},
			{dataIndex: 'ITEM_NAME'			, width: 120},
			{dataIndex: 'SPEC'				, width: 120},
			{dataIndex: 'LOT_NO'			, width: 93},
			{dataIndex: 'STOCK_UNIT'		, width: 40},
			{dataIndex: 'INOUT_DATE'		, width: 100},
			{dataIndex: 'INSPEC_Q'			, width: 86},
			{dataIndex: 'NOT_INSPEC_Q'		, width: 86},
			{dataIndex: 'INOUT_NUM'			, width: 33 ,hidden:true},
			{dataIndex: 'INOUT_SEQ'			, width: 33 ,hidden:true},
			{dataIndex: 'REMAIN_STOCK_Q'	, width: 93}
		],
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {}
		}
		,returnData: function()	{
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){	
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setEstiData(record.data);
									}); 
			// this.deleteSelectedRow();
			this.getStore().remove(records);
		}
	});
	
	function openProductionWindow() {
		productionSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
		productionSearch.setValue('ITEM_CODE',panelSearch.getValue('ITEM_CODE'));
		productionSearch.setValue('ITEM_NAME',panelSearch.getValue('ITEM_NAME'));
		productionSearch.setValue('WORK_SHOP_CODE',panelSearch.getValue('WORK_SHOP_CODE'));
		productionSearch.setValue('LOT_NO',panelSearch.getValue('LOT_NO'));
		productionSearch.setValue('PROJECT_NO',panelSearch.getValue('PROJECT_NO'));	
		
		if(!referSeeReception) {
			referSeeReception = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.receiptrefer" default="접수참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				
				items: [productionSearch, productionGrid],
				tbar: ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.product.inquiry" default="조회"/>',
						handler: function() {
							productionStore.loadStoreRecords();
						},
						disabled: false
					}, 
					{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.product.apply" default="적용"/>',
						handler: function() {
							productionGrid.returnData();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
						handler: function() {
							productionGrid.returnData();
							referSeeReception.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							referSeeReception.hide();
						},
						disabled: false
					}
				],
				listeners : {beforehide: function(me, eOpt)	{
											// requestSearch.clearForm();
											// requestGrid,reset();
										},
							 beforeclose: function( panel, eOpts )	{
											// requestSearch.clearForm();
											// requestGrid,reset();
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
		id: 'qms600ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailGrid, detailGrid2, panelResult
			]
		}
		,panelSearch
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			Ext.getCmp('CheckItemButton').setDisabled(true);
//			Ext.getCmp('ItemDeleteButton').setDisabled(true);
//			Ext.getCmp('AcceptButton').setDisabled(true);
//			Ext.getCmp('RejectButton').setDisabled(true);
			detailGrid.disabledLinkButtons(false);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			var orderNo = panelSearch.getValue('INSPEC_NUM');
			if(Ext.isEmpty(orderNo)) {
				opensearchInfoWindow() 
			} else {
				var param= panelSearch.getValues();
				masterSelectIdx = 0;
				detailStore.loadStoreRecords();	
//				Ext.getCmp('AcceptButton').setDisabled(false);
//				Ext.getCmp('RejectButton').setDisabled(false);
			}
		},
		onNewDataButtonDown: function()	{
			//if(!this.checkForNewDetail()) return false;
			 var inspec_num = panelSearch.getValue('INSPEC_NUM');
			 var inspecType = panelSearch.getValue('INSPEC_TYPE');
			 if(Ext.isEmpty(inspecType)){
				inspecType = '01'
			 }
			 var inspecPrsn = panelSearch.getValue('INSPEC_PRSN');
			 var seq = detailStore.max('INSPEC_SEQ');
			 if(!seq) seq = 1;
			 else  seq += 1;
			 
			 var r = { 
				INSPEC_NUM : inspec_num,
				INSPEC_SEQ : seq,
				INSPEC_TYPE: inspecType,
				INSPEC_PRSN: inspecPrsn
//				GOODBAD_TYPE: '01'
			 };
			detailGrid.createRow(r);
			panelSearch.setAllFieldsReadOnly(false);
		},
		onNewDataButtonDown2: function()	{
			//if(!this.checkForNewDetail()) return false;
			var divCode			= panelSearch.getValue('DIV_CODE');
			var inspecNum		= panelSearch.getValue('INSPEC_NUM');
			var inspecSeq		= panelSearch.getValue('INSPEC_SEQ');
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
			panelSearch.setAllFieldsReadOnly(false);
		},
		onResetButtonDown: function() {
			var inspecPrsn = panelResult.getValue('INSPEC_PRSN');
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailGrid2.reset();
			detailStore.clearData();
			detailStore2.clearData();
			panelResult.setValue('INSPEC_PRSN',inspecPrsn);
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
			if(selectedMasterGrid == 'qms600ukrvGrid')   {
				var selRow = detailGrid.getSelectedRecord();
				if(selRow && detailStore2.getCount() == 0) {
					if(selRow.phantom === true) {
						detailGrid.deleteSelectedRow();
					}else {
						if(selRow.get('INSTOCK_Q') > '1') {
							alert('<t:message code="system.message.product.message041" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
						} else {
							if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
								detailGrid.deleteSelectedRow();
							}
						}
					}
				}else{
					alert('<t:message code="system.message.product.message042" default="불량검사 내역이 존재합니다."/>');
					return false;
				}
			}else{
				var selRow = detailGrid2.getSelectedRecord();
				if(selRow) {
					if(selRow.phantom === true) {
						detailGrid2.deleteSelectedRow();
					}else {
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
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INSPEC_DATE',new Date());
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('INSPEC_DATE',new Date());
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);	
		}
	});
		
	/**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "INSPEC_Q" : // 검사량
				
					if(newValue < 1 ){
						rv='<t:message code="system.message.product.message056" default="접수량이 1보다 작거나 데이터가 없습니다."/>';
						break;
					}
					
					
					
//					//검사량에따라 합격수량,불합격수량 변경
//					if (record.get('GOODBAD_TYPE') == '01'){
//						record.set('GOOD_INSPEC_Q', newValue);
//						record.set('BAD_INSPEC_Q', 0);
//						
//					}else  if (record.get('GOODBAD_TYPE') == '02'){
//						record.set('GOOD_INSPEC_Q', 0);
//						record.set('BAD_INSPEC_Q', newValue);
//						
//					}else  if (record.get('GOODBAD_TYPE') == '03'){
////						alert('보류 수량은 : ' + newValue);
//					}else {
////						alert('미선택 수량은 : ' + newValue);
//					}
					
//					var receiptQ = record.get('RECEIPT_Q'); //접수량
//					var InspecQ = record.get('INSPEC_Q'); //검사량
//					var goodInspecQ = record.get('GOOD_INSPEC_Q'); //합격수량

					var badInspecQ = record.get('BAD_INSPEC_Q'); //불량수량
					record.set('GOOD_INSPEC_Q', newValue - badInspecQ);
					
					
					if(Ext.isNumeric(record.get('RECEIPT_Q')))
					{
						var receiptQ = record.get('RECEIPT_Q');

						if(receiptQ < newValue ){
							rv='<t:message code="system.message.product.message057" default="검사수량은 잔량보다 적어야 합니다."/>';
							// 검사수량은 잔량(접수량)보다 적어야 합니다.
						}
						break;
					}
					
					if(record.phantom == false)	   // 검사된 수량이 있는지 점검 한다.
														// '신규가 아닐때 [보완필요]
					{
						var divCode = panelSearch.getValue('DIV_CODE');
						var inspecNum = record.get('INSPEC_NUM');
						var inspecSeq = record.get('INSPEC_SEQ');
						UniAppManager.app.fnInspecQtyCheck(record, fieldName, oldValue, divCode, receiptNum, receiptSeq );
					}
					
					break;
					
					
				case "GOODBAD_TYPE" : //합격여부
				  if(Ext.isEmpty(newValue)&&record.get('ISNULL_WH_CODE')!='N'){
						record.set('IN_WH_CODE', '');
				  }
//					record.set('GOOD_INSPEC_Q', 0);
//					record.set('BAD_INSPEC_Q', 0);
//					record.set('INSPEC_Q', 0);
					
					break;
					
				case "INSPEC_PRSN" :  // 검사유형
						panelSearch.setValue('INSPEC_PRSN',newValue);
				
				/*	if(newValue == "02")  // 샘플검사
					{
						record.set('GOODBAD_TYPE', "01");
					}
					else
					{
						record.set('GOODBAD_TYPE' , "");
					} */
					
				// case "LOT_NO" : // LOT_NO 공통처리가 되어있는지 확인 필요
			}
			return rv;
		}
	}); // validator

	/**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore2,
		grid: detailGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "BAD_INSPEC_Q" : // 검사량
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
							// 검사수량은 잔량(접수량)보다 적어야 합니다.
						}
						//합격,불합격에따라 합격수량불량수량 변경
//						var GOODBAD_TYPE = detailGrid.getSelectedRecord().get('GOODBAD_TYPE');
//						alert('GOODBAD_TYPE' + GOODBAD_TYPE);
						
					
				// case "LOT_NO" : // LOT_NO 공통처리가 되어있는지 확인 필요
//				  case "INSPEC_Q" : // 검사량
////						 var GOODBAD_TYPE = detailGrid.getSelectedRecord().get('GOODBAD_TYPE');
//						
////						alert('GOODBAD_TYPE' + GOODBAD_TYPE);
//						
//				  break;
			}
			return rv;
		}
	}); // validator
}
</script>