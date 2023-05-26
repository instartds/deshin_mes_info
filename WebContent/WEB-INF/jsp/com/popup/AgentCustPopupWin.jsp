<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 거래처(거래처분류조건포함)
request.setAttribute("PKGNAME","Unilite.app.popup.AgentCustPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B015"/>	// '거래처구분
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B016"/>				// 사업자구분
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B055"/>				// 거래처분류
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B056"/>				// 지역
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S010"/>				// 영업담당
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B010"/>

	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B004"/>				// 화폐단위
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="BO57"/>				// 미수관리방법
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B030"/>				// 세액포함여부
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B051"/>				// 세액계산법
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B017"/>				// 원미만계산





	 Unilite.defineModel('${PKGNAME}.AgentPopupModel', {
		fields: [
			{name: 'CUSTOM_CODE'			,text:'<t:message code="system.label.common.customcode" default="거래처코드"/>'					,type:'string'},
			{name: 'CUSTOM_NAME'			,text:'<t:message code="system.label.common.customname" default="거래처명"/>'					,type:'string'},
			{name: 'COMPANY_NUM'			,text:'<t:message code="system.label.common.businessnumber" default="사업자번호"/>'				,type:'string'},
			{name: 'TOP_NAME'				,text:'<t:message code="system.label.common.representativename" default="대표자명"/>'			,type:'string'	 },
			{name: 'BUSINESS_TYPE'			,text:'<t:message code="system.label.common.businessdivisiontype" default="사업자구분"/>'		,type:'string'	, comboType:'AU',comboCode:'B016'},
			{name: 'COMP_CLASS'				,text:'<t:message code="system.label.common.businesstype" default="업종"/>'					,type:'string'},
			{name: 'COMP_TYPE'				,text:'<t:message code="system.label.common.businessconditions" default="업태"/>'				,type:'string'},
			{name: 'ADDR1'					,text:'<t:message code="system.label.common.address1" default="주소1"/>'						,type:'string'},
			{name: 'ADDR2'					,text:'<t:message code="system.label.common.address2" default="주소2"/>'						,type:'string'},
			{name: 'TELEPHON'				,text:'<t:message code="system.label.common.telephone" default="전화번호"/>'					,type:'string'},
			{name: 'FAX_NUM'				,text:'<t:message code="system.label.common.faxno" default="팩스번호"/>'						,type:'string'},
			{name: 'MAIL_ID'				,text:'<t:message code="system.label.common.emailaddr" default="이메일주소"/>'					,type:'string'},
			{name: 'WON_CALC_BAS'			,text:'<t:message code="system.label.common.decimalcalculation" default="원미만계산"/>'			,type:'string'	, comboType:'AU',comboCode:'B017'},
			{name: 'TO_ADDRESS'				,text:'<t:message code="system.label.common.sendaddress" default="송신주소"/>'					,type:'string'},
			{name: 'TAX_CALC_TYPE'			,text:'<t:message code="system.label.common.taxcalculationmethod" default="세액계산법"/>'		,type:'string'	, comboType:'AU',comboCode:'B051'},
			{name: 'TRANS_CLOSE_DAY'		,text:'<t:message code="system.label.common.customclosingdate" default="거래처마감일"/>'			,type:'string'},
			{name: 'RECEIPT_DAY'			,text:'<t:message code="system.label.common.apprperiod" default="결재기간"/>'					,type:'string'},
			{name: 'TAX_TYPE'				,text:'<t:message code="system.label.common.taxincludedflag" default="세액포함여부"/>'			,type:'string'	, comboType:'AU',comboCode:'B030'},
			{name: 'VAT_RATE'				,text:'<t:message code="system.label.common.taxrate" default="세율"/>'						,type:'string'},
			{name: 'MONEY_UNIT'				,text:'<t:message code="system.label.common.currency" default="화폐 "/>'						,type:'string'},
			{name: 'BILL_TYPE'				,text:'<t:message code="system.label.common.billtype" default="계산서유형"/>'					,type:'string'},
			{name: 'SET_METH'				,text:'<t:message code="system.label.common.payingterm" default="결제방법"/>'					,type:'string'},
			{name: 'AGENT_TYPE'				,text:'<t:message code="system.label.common.customclass" default="거래처분류"/>'					,type:'string'	, comboType:'AU',comboCode:'B055'},
			{name: 'AREA_TYPE'				,text:'<t:message code="system.label.common.areatype" default="지역분류"/>'						,type:'string'	, comboType:'AU',comboCode:'B056'},
			{name: 'CREDIT_YN'				,text:'<t:message code="system.label.common.creditmanageyn" default="여신관리여부"/>'				,type:'string'	, comboType:'AU',comboCode:'B010'},
			{name: 'TOT_CREDIT_AMT'			,text:'<t:message code="system.label.common.creditamount2" default="여신액"/>'					,type:'string'},
			{name: 'CREDIT_AMT'				,text:'<t:message code="system.label.common.additionalcreditamount" default="추가여신액"/>'		,type:'string'},
			{name: 'CREDIT_YMD'				,text:'<t:message code="system.label.common.additionalcreditduedate" default="추가여신만기일"/>'	,type:'uniDate'},
			{name: 'BUSI_PRSN'				,text:'<t:message code="system.label.common.mainsalescharger" default="주영업담당자"/>'			,type:'string', comboType:'AU',comboCode:'S010'},
			{name: 'COLLECTOR_CP'			,text:'<t:message code="system.label.common.collectioncustomer" default="수금거래처"/>'			,type:'string'},
			{name: 'COLLECTOR_NM'			,text:'<t:message code="system.label.common.collectioncustomername" default="수금거래처명"/>'		,type:'string'},
			{name: 'COLLECT_DAY'			,text:'<t:message code="system.label.common.collectionschdate" default="수금예정일"/>'			,type:'string'},
			{name: 'COLLECT_CARE'			,text:'<t:message code="system.label.common.armanagemethod" default="미수관리방법"/>'				,type:'string' , comboType:'AU',comboCode:'B057'},
			{name: 'REMARK'					,text:'<t:message code="system.label.common.remarks" default="비고"/>'						,type:'string'},
			{name: 'TOP_NUM'				,text:'<t:message code="system.label.common.representativenumber" default="대표자주민번호"/>'		,type:'string'},
			{name: 'CREDIT_OVER_YN'			,text:'<t:message code="system.label.common.creditoverdeliveryyn" default="여신초과여부"/>'		,type:'string'	, comboType:'AU',comboCode:'B010'},
			{name: 'BILL_DIV_CODE'			,text:'<t:message code="system.label.common.declaredivisioncode" default="신고사업장"/>'			,type:'string'},
			{name: 'SERVANT_COMPANY_NUM'	,text:'<t:message code="system.label.common.bureaubusinessnumber" default="종사업장번호"/>'		,type:'string'},
			{name: 'PRSN_NAME'				,text:'<t:message code="system.label.common.receivingperson" default="받는 담당자"/>'			,type:'string'},
			{name: 'PRSN_EMAIL'				,text:'<t:message code="system.label.common.receivingemail" default="받는 이메일"/>'				,type:'string'},
			{name: 'PRSN_PHONE'				,text:'<t:message code="system.label.common.receivingphone" default="받는 연락처"/>'				,type:'string'},
			{name: 'CHANNEL'				,text:'CHANNEL'				,type:'string'},
			{name: 'BILL_CUSTOM_CODE'		,text:'BILL_CUSTOM_CODE'	,type:'string'},
			{name: 'BILL_CUSTOM_NAME'		,text:'BILL_CUSTOM_NAME'	,type:'string'},
			{name: 'PAY_TERMS'				,text:'<t:message code="system.label.common.paycondition" default="결제조건"/>'					,type:'string'},
			{name: 'PAY_DURING'				,text:'PAY_DURING'			,type:'string'},
			{name: 'PAY_METHODE1'			,text:'<t:message code="system.label.common.payingmethod" default="대금결제방법"/>'				,type:'string'},
			{name: 'TERMS_PRICE'			,text:'<t:message code="system.label.common.pricecondition" default="가격조건"/>'				,type:'string'},
			{name: 'COND_PACKING'			,text:'<t:message code="system.label.common.packingmethod" default="포장방법"/>'				,type:'string'},
			{name: 'METH_CARRY'				,text:'<t:message code="system.label.common.transportmethod" default="운송방법"/>'				,type:'string'},
			{name: 'METH_INSPECT'			,text:'<t:message code="system.label.common.inspecmethod" default="검사방법"/>'					,type:'string'},
			{name: 'DEST_PORT'				,text:'<t:message code="system.label.common.arrivalport" default="도착항"/>'					,type:'string'},
			{name: 'SHIP_PORT'				,text:'<t:message code="system.label.common.shipmentport" default="선적항"/>'					,type:'string'},
			{name: 'AGENT_CODE'				,text:'<t:message code="system.label.common.agent" default="대행자"/>'							,type:'string'},
			{name: 'AGENT_NAME'				,text:'<t:message code="system.label.common.agent" default="대행자"/>'							,type:'string'},
			{name: 'UPN_CHECK'				,text:'<t:message code="system.label.sales.upncheckyn" default="UPN 체크여부"/>'				,type:'string'},
			//20210202 추가
			{name: 'REPRE_NUM'				,text:'REPRE_NUM'				,type:'string'},
			{name: 'REPRE_NUM_EXPOS'		,text:'REPRE_NUM_EXPOS'			,type:'string'},
			{name: 'BANK_ACCOUNT'			,text:'BANK_ACCOUNT'			,type:'string'},
			{name: 'BANK_ACCOUNT_EXPOS'		,text:'BANK_ACCOUNT_EXPOS'		,type:'string'},
			{name: 'BANK_NAME'				,text:'BANK_NAME'				,type:'string'}
		]
	});



Ext.define('${PKGNAME}', {
	extend: 'Unilite.com.BaseJSPopupApp',
	constructor : function(config) {
	var me = this;
	if (config) {
		Ext.apply(me, config);
	}
	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
//	var wParam = this.param;
//	var t1= false, t2 = false;
//	if( Ext.isDefined(wParam)) {
//		if(wParam['TYPE'] == 'VALUE') {
//			t1 = true;
//			t2 = false;
//
//		} else {
//			t1 = false;
//			t2 = true;
//
//		}
//	}
	me.panelSearch = Unilite.createSearchForm('',{
		layout: {
			type: 'uniTable',
			columns: 2,
			tableAttrs: {
				style: {
					width: '100%'
				}
			}
		},
		items: [ { fieldLabel: '<t:message code="system.label.common.classfication" default="구분"/>',	name:'CUSTOM_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B015' ,
					listeners:{
							beforequery: function(queryPlan, eOpts )	{
								var fValue = me.panelSearch.getValue('AGENT_CUST_FILTER');
								var store = queryPlan.combo.getStore();
								if(!Ext.isEmpty(fValue) )	{
									store.clearFilter(true);
									queryPlan.combo.queryFilter = null;
									console.log("fValue :",fValue);
									store.filterBy(function(record, id){
										console.log("record :",record.get('value'),fValue.indexOf(record.get('value')));
										return fValue.indexOf(record.get('value')) > -1 ? record:null;
									});
								} else {
									store.clearFilter(true);
									queryPlan.combo.queryFilter = null;
									store.loadRawData(store.proxy.data);
								}
							}
						}
					}
				 ,{ fieldLabel: '<t:message code="system.label.common.businessnumber" default="사업자번호"/>',	name:'COMPANY_NUM', xtype: 'uniTextfield'}
				 ,{ fieldLabel: '<t:message code="system.label.common.customclass" default="거래처분류"/>',	name:'AGENT_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B055' }
				 ,{ fieldLabel: '<t:message code="system.label.common.areatype" default="지역분류"/>',	 name:'AREA_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B056' }
				 ,{ fieldLabel: '<t:message code="system.label.common.agentcustomfilter" default="검색제외"/>', 	name:'AGENT_CUST_FILTER' , hidden:true}
//				 ,{  fieldLabel: '<t:message code="system.label.common.useflag" default="사용유무"/>',	name:'USE_YN',  xtype: 'uniRadiogroup', comboType:'AU',comboCode:'B010' , allowBlank:false, width:230}
//				 , {
//					xtype: 'radiogroup',
//					fieldLabel: '사용유무',
//					items: [{
//						boxLabel: '사용중',
//						width: 63,
//						name: 'USE_YN',
//						inputValue: 'Y'
//					}, {
//						boxLabel: '전체',
//						name: 'USE_YN',
//						inputValue: 'N'
//				}]
//			}
				 ,{ fieldLabel: '<t:message code="system.label.common.useflag" default="사용유무"/>',		name:'USE_YN', hidden:true}
				 ,{ fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',	 name:'TXT_SEARCH', width:350,focusable:true,
						listeners:{
							specialkey: function(field, e){
								if (e.getKey() == e.ENTER) {
								   me.onQueryButtonDown();
								}
							}
						}
					}
					,{ xtype:'button', text:'<t:message code="system.label.common.quickregist" default="빠른등록"/>', margin: '0 0 5 95', width: 110, hidden:true
						,handler:function() {
								me.openRegWindow();
						   }
					 }
					,{ fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',		  name:'DIV_CODE',   xtype: 'uniTextfield', hidden: true}
					,{ fieldLabel: '추가쿼리관련1',	 name:'ADD_QUERY1',   xtype: 'uniTextfield', hidden: true}
					,{ fieldLabel: '추가쿼리관련2',	 name:'ADD_QUERY2',   xtype: 'uniTextfield', hidden: true}
					,{ fieldLabel: '추가쿼리관련3',	 name:'ADD_QUERY3',   xtype: 'uniTextfield', hidden: true}
//				 ,{ fieldLabel: '<t:message code="system.label.common.businessdivisiontype" default="사업자구분"/>',
//					xtype: 'radiogroup', width: 230, id:'rdoRadio',
//					items:[ {inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
//							{inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
//				 }

		]
	});
	me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
			store: Unilite.createStoreSimple('${PKGNAME}.custPopupStore',{
							model: '${PKGNAME}.AgentPopupModel',
							autoLoad: false,
							proxy: {
								type: 'direct',
								api: {
									 read: 'popupService.agentCustPopup'
									,create : 'bcm100ukrvService.insertSimple'
									,syncAll:'bcm100ukrvService.syncAll'
								}
							},
							saveStore : function(config)	{
									var inValidRecs = this.getInvalidRecords();
									if(inValidRecs.length == 0 )	{
										this.syncAll(config);
//									  this.syncAllDirect(config);
									}else {
										alert(Msg.sMB083);
									}
							}
					}),
			uniOpt:{
						 expandLastColumn: false
						,useRowNumberer: false,
						state: {
							useState: false,
							useStateList: false
						},
						pivot : {
							use : false
						}
			},
			selModel:'rowmodel',
			columns:  [
						 { dataIndex: 'CUSTOM_CODE',  width: 80 }
						,{ dataIndex: 'CUSTOM_NAME',  width: 250 }
						,{ dataIndex: 'COMPANY_NUM',  width: 100 }
						,{ dataIndex: 'TOP_NAME',  width: 135 }
						,{ dataIndex: 'BUSINESS_TYPE',  width: 100 }
						,{ dataIndex: 'COMP_CLASS',  width: 100 }
						,{ dataIndex: 'COMP_TYPE',  width: 100 }
						,{ dataIndex: 'ADDR1',  width: 250 }
						,{ dataIndex: 'ADDR2',  width: 250 }
						,{ dataIndex: 'TELEPHON',  width: 100 }
						,{ dataIndex: 'FAX_NUM',  width: 100 }
						,{ dataIndex: 'MAIL_ID',  width: 100 }
						,{ dataIndex: 'WON_CALC_BAS',  width: 100   }
						,{ dataIndex: 'TO_ADDRESS',  width: 100 }
						,{ dataIndex: 'TAX_CALC_TYPE',  width: 100 }
						,{ dataIndex: 'TRANS_CLOSE_DAY',  width: 100	}
						,{ dataIndex: 'RECEIPT_DAY',  width: 100	}
						,{ dataIndex: 'TAX_TYPE',  width: 80   }
						,{ dataIndex: 'VAT_RATE',  width: 66 }
						,{ dataIndex: 'MONEY_UNIT',  width: 66 }
						,{ dataIndex: 'BILL_TYPE',  width: 100  }
						,{ dataIndex: 'SET_METH',  width: 100   }
						,{ dataIndex: 'AGENT_TYPE',  width: 100 }
						,{ dataIndex: 'AREA_TYPE',  width: 100  }
						,{ dataIndex: 'CREDIT_YN',  width: 100  }
						,{ dataIndex: 'TOT_CREDIT_AMT',  width: 100 }
						,{ dataIndex: 'CREDIT_AMT',  width: 100 }
						,{ dataIndex: 'CREDIT_YMD',  width: 100 }
						,{ dataIndex: 'BUSI_PRSN',  width: 100  }
						,{ dataIndex: 'COLLECTOR_CP',  width: 100   }
						,{ dataIndex: 'COLLECTOR_NM',  width: 250   }
						,{ dataIndex: 'COLLECT_DAY',  width: 100	}
						,{ dataIndex: 'COLLECT_CARE',  width: 100   }
						,{ dataIndex: 'REMARK',  width: 100 }
						,{ dataIndex: 'TOP_NUM',  width: 120	}
						,{ dataIndex: 'CREDIT_OVER_YN',  width: 100  }
						,{ dataIndex: 'BILL_DIV_CODE',  width: 100  }
						,{ dataIndex: 'SERVANT_COMPANY_NUM',  width: 100}
						,{ dataIndex: 'PAY_TERMS'		,width:100	, hidden:true}
						,{ dataIndex: 'PAY_DURING'		,width:100	, hidden:true}
						,{ dataIndex: 'PAY_METHODE1'	,width:100	, hidden:true}
						,{ dataIndex: 'TERMS_PRICE'	,width:100	, hidden:true}
						,{ dataIndex: 'COND_PACKING'	,width:100	, hidden:true}
						,{ dataIndex: 'METH_CARRY'		,width:100	, hidden:true}
						,{ dataIndex: 'METH_INSPECT'	,width:100	, hidden:true}
						,{ dataIndex: 'DEST_PORT'		,width:100	, hidden:true}
						,{ dataIndex: 'SHIP_PORT'		,width:100	, hidden:true}
						,{ dataIndex: 'AGENT_CODE'		,width:100	, hidden:true}
						,{ dataIndex: 'AGENT_NAME'	,width:100	, hidden:true}

			],
			listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
					var rv = {
						status : "OK",
						data:[record.data]
					};
					me.returnData(rv);
				},
				onGridKeyDown: function(grid, keyCode, e) {
					if(e.getKey() == Ext.EventObject.ENTER) {
						var selectRecord = grid.getSelectedRecord();
						var rv = {
							status : "OK",
							data:[selectRecord.data]
						};
						me.returnData(rv);
					}
				}
			}
		});

		config.items = [me.panelSearch, 	me.masterGrid];
	  	me.callParent(arguments);
	  	me.regCustForm = Unilite.createForm('',{

			layout : {type : 'uniTable', columns : 1},
			masterGrid: me.masterGrid,

			disabled:false,
			buttonAlign :'center',
			fbar: [
					{  xtype: 'button', text: '<t:message code="system.label.common.save" default="저장"/>' ,
					   handler: function()  {
							if(!me.regCustForm.getInvalidMessage()) return;
							var r = {
								COMPANY_NUM: me.regCustForm.getValue('COMPANY_NUM').replace(/-/gi, ''),
								CUSTOM_CODE: me.regCustForm.getValue('CUSTOM_CODE'),
								CUSTOM_NAME: me.regCustForm.getValue('CUSTOM_NAME'),
								CUSTOM_TYPE: me.regCustForm.getValue('CUSTOM_TYPE'),
								AGENT_TYPE: me.regCustForm.getValue('AGENT_TYPE')
							}
							me.masterGrid.createRow(r);
							var record = me.masterGrid.getSelectedRecord();
							me.masterGrid.getStore().saveStore({
								success: function() {

									me.panelSearch.setValue("COMPANY_NUM",r.COMPANY_NUM);
									me.panelSearch.setValue("TXT_SEARCH",r.CUSTOM_CODE);
									me.panelSearch.setValue("CUSTOM_TYPE",r.CUSTOM_TYPE);
									me.panelSearch.setValue("AGENT_TYPE",r.AGENT_TYPE);
									me._dataLoad();
									/*var rv = {
										status : "OK",
										data:[record.data]
									};*/
									//me.returnData(rv);
								 }
							})
							//me.returnData({});
							me.regWindow.hide();
						}
					},
					{  xtype: 'button', text: '<t:message code="system.label.common.close" default="닫기"/>' ,
						handler:function()  {
//						  me.masterGrid.getStore().rejectChanges();
							me.regWindow.hide();
						}
					}
				   ],
			items: [  { fieldLabel: '<t:message code="system.label.common.businessnumber" default="사업자번호"/>',	name:'COMPANY_NUM', allowBlank: false, enforceMaxLength: true, maxLength: 12,
						   listeners : {
								blur: function(field, The, eOpts)   {
									var newValue = field.getValue();
									if(Ext.isEmpty(newValue))   return;
									if(Ext.isNumeric(newValue) != true) {
										alert(Msg.sMB074);
										field.setValue('');
										return;
									}else if(Unilite.validate('bizno', newValue) != true)   {
										if(!Ext.isEmpty(newValue) && newValue.length != 10 ){
											alert('자릿수를 확인하십시오.');
											field.setValue('');
											return;
										}else if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))  {
											field.setValue('');
											return;
										}
									}
									if(Ext.isNumeric(newValue) == true) {
										var a = newValue;
										var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
										field.setValue(i);
									}
								}
							}
					  }
					 ,{ fieldLabel: '<t:message code="system.label.common.customcode" default="거래처코드"/>',	name:'CUSTOM_CODE', enforceMaxLength: true, maxLength: 8}
					 ,{ fieldLabel: '<t:message code="system.label.common.customname" default="거래처명"/>',	  name:'CUSTOM_NAME', allowBlank: false, enforceMaxLength: true, maxLength: 50}
					 ,{ fieldLabel: '<t:message code="system.label.common.classfication" default="구분"/>',		name:'CUSTOM_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B015', allowBlank: false, value: '1'}
					 ,{ fieldLabel: '<t:message code="system.label.common.customclass" default="거래처분류"/>',	name:'AGENT_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B055', allowBlank: false, value: '1'}

			]
		});
		me.regWindow = Ext.create('Ext.window.Window', {
				title: '<t:message code="system.label.common.customfasterinput" default="거래처 빠른 입력"/>',
				modal: true,
				closable: false,
				width: 300,
				height: 200,
				alwaysOnTop:89000,
				items: [me.regCustForm],
				hidden:true,
				listeners : {
							 show:function( window, eOpts)  {
								me.regCustForm.reset();
								me.regCustForm.body.el.scrollTo('top',0);
							 }

						}
		});
	},
	initComponent : function(){
		var me  = this;

		me.masterGrid.focus();

		this.callParent();
	},
	fnInitBinding : function(param) {
		var me = this;

		var frm= me.panelSearch.getForm();
		me.panelSearch.onLoadSelectText('TXT_SEARCH');
//		var rdo = frm.findField('rdoRadio');
		var fieldTxt = frm.findField('TXT_SEARCH');
//		frm.setValues(param);
		me.panelSearch.setValues(param);
		if( Ext.isDefined(param)) {
			if(Ext.isDefined(fieldTxt)) {
//				if(param['TYPE'] == 'VALUE') {
//					fieldTxt.setValue(param['CUSTOM_CODE']);
////					rdo.RDO.setValue('1');
////					frm.setValue('RDO', '1');
//					rdo.setValue({ RDO : '1'});
//				} else {
//					if(param['SINGLE_CODE']){	//싱글폼전용 코드일시
//						fieldTxt.setValue(param['CUSTOM_CODE']);
////						rdo.RDO.setValue('1');
////						frm.setValue('RDO', '1');
//						rdo.setValue({ RDO : '1'});
//					}else{
//						fieldTxt.setValue(param['CUSTOM_NAME']);
////						rdo.RDO.setValue('2');
////						frm.setValue('RDO', '2');
//						rdo.setValue({ RDO : '2'});
//					}
//				}
				if(param['TYPE'] == 'VALUE') {
					if(!Ext.isEmpty(param['CUSTOM_CODE'])){
						fieldTxt.setValue(param['CUSTOM_CODE']);
					}
				}else{
					if(!Ext.isEmpty(param['CUSTOM_CODE'])){
						fieldTxt.setValue(param['CUSTOM_CODE']);
					}
					if(!Ext.isEmpty(param['CUSTOM_NAME'])){
						fieldTxt.setValue(param['CUSTOM_NAME']);
					}
				}
				if(param['AGENT_TYPE'] == '4'){	//직영점
					me.panelSearch.setValue('AGENT_TYPE', param['AGENT_TYPE']);
					frm.findField('AGENT_TYPE').setReadOnly(true);
				}

				if(param['AGENT_TYPE'] == '2'){	//교내 처래처
					me.panelSearch.setValue('AGENT_TYPE', param['AGENT_TYPE']);
					frm.findField('AGENT_TYPE').setReadOnly(true);
				}
			}
		}
		//팝업 열릴 때 구분값 set되지 않게
		me.panelSearch.setValue('CUSTOM_TYPE', '');
		//조회 조건이 있을 때만 팝업 열리면서 조회 되도록
		if (!Ext.isEmpty(me.panelSearch.getValue('TXT_SEARCH'))) {
			this._dataLoad();
		}
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
		var me = this;
		var selectRecord = me.masterGrid.getSelectedRecord();
		var rv ;
		if(selectRecord)	{
		 	rv = {
				status : "OK",
				data:[selectRecord.data]
			};
		}
		me.returnData(rv);
	},
	openRegWindow:function()   {
		var me = this;
		console.log("openRegWindow:me", me);
		me.regWindow.show();
//	  var selRecord = me.masterGrid.createRow();
//	  me.regCustForm.setActiveRecord(selRecord||null);

	},
	_dataLoad : function() {
		var me = this;
		var param= me.panelSearch.getValues();
		console.log( "_dataLoad: ", param );
		me.isLoading = true;
		me.masterGrid.getStore().load({
			params : param,
			callback:function()	{
				me.isLoading = false;
			}
		});
	}
});