<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="biv115ukrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="biv115ukrv"/> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >
var gsPeriod 			= '${gsPeriod}';
var hideYear 			= (gsPeriod == "1" || gsPeriod == "4" ) ? true : false;
var hidePeriodFields 	= (gsPeriod != "4" ) ? true : false;
var hideMonthFields 	= (gsPeriod != "1" ) ? true : false;
var hideWorkQuad        = (gsPeriod != "2" &&  gsPeriod != "3" ) ? true : false;
function appMain() {
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('Biv115ukrvModel', {
	    fields: [
	    	{name: 'DIV_CODE' 			,text: '<t:message code="system.label.inventory.division" default="사업장"/>'			,type: 'string'},
	    	{name: 'WH_CODE' 			,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'				,type: 'string'},
	    	{name: 'LAST_YYYYMM' 		,text: '<t:message code="system.label.inventory.lastclosingyearmonth" default="최종마감년월"/>'		,type: 'string'},
	    	{name: 'CLOSE_YYYYMM' 		,text: '<t:message code="system.label.inventory.workyearmonth" default="작업년월"/>'			,type: 'string'},
			{name: 'BASIS_YYYYMM'		,text: '<t:message code="system.label.inventory.stockapplyyearmonth" default="기초재고반영년월"/>'		,type: 'string'}
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('biv115ukrvMasterStore1',{
			model: 'Biv115ukrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'biv115ukrvService.selectMaster'
                }
            },
            loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});

			},
			saveStore: function(config) {
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);
				var rv = true;
       			if(inValidRecs.length == 0 ) {
					config = {
						success: function(batch, option) {
							panelSearch.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);
						}
					};
					this.syncAllDirect(config);
				} else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners: {
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{

				}
			}
	});
	var periodStore = Unilite.createStore('periodStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'월'		, 'value':'1'},
			        {'text':'분기'	, 'value':'2'},
			        {'text':'반기'	, 'value':'3'},
			        {'text':'기간'	, 'value':'4'}
	    		]
	});
	var pStore ;
	if(gsPeriod == "2")	{
		pStore = Unilite.createStore('pStore', {
		    fields: ['text', 'value'],
			data :  [
				        {'text':'1분기'	, 'value':'1'},
				        {'text':'2분기'	, 'value':'2'},
				        {'text':'3분기'	, 'value':'3'},
				        {'text':'4분기'	, 'value':'4'}
		    		]
		});
	} else {
		pStore = Unilite.createStore('pStore', {
		    fields: ['text', 'value'],
			data :  [
				        {'text':'상반기'	, 'value':'First'},
				        {'text':'하반기'	, 'value':'Second'},
		    		]
		});
	}
	var panelSearch = Unilite.createForm('biv115ukrvForm', {
		disabled :false
        , flex:1
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					child:'WH_CODE',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							UniAppManager.app.fnYyyymmSet(newValue);
						}
					}
				},{
	            	fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
	            	name: 'WH_CODE',
	            	xtype: 'uniCombobox',
					holdable: 'hold',
					hidden: true,
	            	store: Ext.data.StoreManager.lookup('whList')
				},{
					fieldLabel: '<t:message code="system.label.inventory.lastclosingyearmonth" default="최종마감년월"/>',
					name: 'LAST_YYYYMM',
	                xtype: 'uniTextfield',
	                width : 200,
	                readOnly: true,
					fieldStyle: 'text-align: center;'
	            },{
	            	fieldLabel:'작업구분', 
	            	name  :'WORK_PERIOD', 
	            	width : 200, 
	            	xtype :'radiogroup',
	            	readOnly : true,
	            	value : gsPeriod,
	            	items : [{
				    	boxLabel: '월',
				    	name: 'WORK_PERIOD',
				    	inputValue: '1',
				    	width:35,
		            	readOnly : true,
				    	checked: (gsPeriod == "1") ? true : false
				    }, {
				    	boxLabel: '분기',
				    	name: 'WORK_PERIOD' ,
				    	inputValue: '2',
				    	width:50,
		            	readOnly : true,
				    	checked: (gsPeriod == "2") ? true : false
					}, {
				    	boxLabel: '반기',
				    	name: 'WORK_PERIOD' ,
				    	inputValue: '3',
				    	width:50,
		            	readOnly : true,
				    	checked: (gsPeriod == "3") ? true : false
					}, {
				    	boxLabel: '기간',
				    	name: 'WORK_PERIOD' ,
				    	inputValue: '4',
				    	width:50,
		            	readOnly : true,
				    	checked: (gsPeriod == "4") ? true : false
					}],
				},{
					fieldLabel : '작업연도',
					xtype : 'uniYearField',
					name : 'BASE_YEAR',
	            	width : 200, 
					value :  new Date().getFullYear(),
					hidden : hideYear,
					listeners : {
	            		change : function(field, newValue) {
	            			panelSearch.setPeriod("BASE_YEAR", newValue);
	            		}
	            	}
				},{
	            	fieldLabel:'작업기간', 
	            	name  :'WORK_QUAD', 
	            	width : 200, 
	            	xtype :'uniCombobox',
	            	store : Ext.data.StoreManager.lookup('pStore'),
	            	hidden : hideWorkQuad,
	            	listeners : {
	            		change : function(field, newValue) {
	            			panelSearch.setPeriod("WORK_QUAD", newValue);
	            		}
	            	}
				},{
					fieldLabel: '작업연월',
					name: 'CLOSE_YYYYMM',
	                xtype: 'uniMonthfield',
	                width : 200,
	                hidden : hideMonthFields,
	                listeners : {
	            		change : function(field, newValue) {
	            			panelSearch.setValue("START_YYYYMM", newValue);
	            		}
	            	}
	            },{
					fieldLabel		: '작업기간',
					xtype			: 'uniMonthRangefield',
					startFieldName	: 'START_YYYYMM',
					endFieldName	: 'P_CLOSE_YYYYMM',
					startDate		: UniDate.get('today'),// 
					endDate			: UniDate.get('today'),
					hidden          : hidePeriodFields ,
					onEndDateChange : function(field, newValue, oldValue, eOpts)  {
						var form = Ext.getCmp("biv115ukrvForm");
						//var closeYYYYMM = form.getField("CLOSE_YYYYMM");
						//closeYYYYMM.setValue(newValue);
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.stockyearmonth" default="기초재고년월"/>',
					name: 'BASIS_YYYYMM',
	                xtype: 'uniTextfield',
	                width : 200,
	                readOnly: true,
					fieldStyle: 'text-align: center;'
	            },{
					xtype: 'uniMonthfield',
					fieldLabel: '작업년월날자포멧용',
					name: 'TEMP_CLOSE_YYYYMM',
					hidden: true
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect',
				    name: 'CLOSED_RDO_YN',
	            	width : 200, 
				    fieldLabel: '<t:message code="system.label.inventory.workselection" default="작업선택"/>',
				    items : [{
				    	boxLabel: '<t:message code="system.label.inventory.closing" default="마감"/>',
				    	name: 'PROCESS_TYPE',
				    	inputValue: '1',
				    	width:60,
				    	checked: true
				    }, {
				    	boxLabel: '<t:message code="system.label.inventory.cancel" default="취소"/>',
				    	name: 'PROCESS_TYPE' ,
				    	inputValue: '2',
				    	width:60
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.getField('PROCESS_TYPE').setValue(newValue.PROCESS_TYPE);
							UniAppManager.app.fnRadioSet(newValue);
						}
					}
				},{
			    	xtype: 'container',
			    	padding: '10 0 0 0',
			    	layout: {
			    		type: 'hbox',
						align: 'center',
						pack:'center'
			    	},
			    	items:[{
			    		xtype: 'button',
			    		text: '<t:message code="system.label.inventory.execute" default="실행"/>',
		    			width: 60,
						handler : function(records) {
							if(panelSearch.getForm().isValid()) {
								if(gsPeriod == "1")	{ // 월
									if(Ext.isEmpty(panelSearch.getValue("CLOSE_YYYYMM")))	{
										Unilite.messageBox("작업연월은 필수입력 사항입니다.");
										return;
									}
									if(Ext.isEmpty(panelSearch.getValue("START_YYYYMM")))	{
										panelSearch.setValue("CLOSE_YYYYMM", "")
										Unilite.messageBox("작업연월은 필수입력 사항입니다.");
										return;
									}
								}
								if(gsPeriod == "2" || gsPeriod == "3")	{  // 분기,반기
									if(Ext.isEmpty(panelSearch.getValue("BASE_YEAR")) || panelSearch.getValue("BASE_YEAR") == 0)	{
										Unilite.messageBox("작업연도은 필수입력 사항입니다.");
										return;
									}
									if(Ext.isEmpty(panelSearch.getValue("WORK_QUAD")))	{
										Unilite.messageBox("작업기간은 필수입력 사항입니다.");
										return;
									}
									if(Ext.isEmpty(panelSearch.getValue("CLOSE_YYYYMM")))	{
										panelSearch.setValue("WORK_QUAD", "");
										Unilite.messageBox("작업기간은 필수입력 사항입니다.");
										return;
									}
									if(Ext.isEmpty(panelSearch.getValue("START_YYYYMM")))	{
										panelSearch.setValue("WORK_QUAD", "");
										Unilite.messageBox("작업기간은 필수입력 사항입니다.");
										return;
									}
								}
								if(gsPeriod == "4")	{	// 기간
									if(Ext.isEmpty(panelSearch.getValue("P_CLOSE_YYYYMM")))	{
										Unilite.messageBox("작업기간은 필수입력 사항입니다.");
										return;
									}
									if(Ext.isEmpty(panelSearch.getValue("CLOSE_YYYYMM")))	{
										panelSearch.setValue("P_CLOSE_YYYYMM", "");
										Unilite.messageBox("작업기간은 필수입력 사항입니다.");
										return;
									}
									if(Ext.isEmpty(panelSearch.getValue("START_YYYYMM")))	{
										Unilite.messageBox("작업기간은 필수입력 사항입니다.");
										return;
									}
								}
								if(confirm('<t:message code="system.message.inventory.message007" default="실행하시겠습니까?"/>')) {
									var param= panelSearch.getValues();
									var lastDate = panelSearch.getValue('LAST_YYYYMM').replace('.','');
									var basisDate = panelSearch.getValue('BASIS_YYYYMM').replace('.','');
									var me = this;
									param.LAST_YYYYMM = lastDate;
									param.BASIS_YYYYMM = basisDate;
									Ext.app.REMOTING_API['timeout'] = 1200000;// milliseconds
									biv115ukrvService.WhCodeSet(param, function(provider, response) {
										var count = provider.CNT;
										if(count == '') {
											alert('<t:message code="system.message.inventory.message016" default="해당사업장에 창고가 없습니다."/>')
										} else if(count > 1) {
											alert('<t:message code="system.message.inventory.message017" default="해당사업장의 창고들 마감정보가 일치하지 않습니다."/>');
										} else {
											panelSearch.getEl().mask('<t:message code="system.label.inventory.loading" default="로딩중..."/>','loading-indicator');
											biv115ukrvService.insertMaster(param, function(provider, response) {
												if(provider)	{
													UniAppManager.app.fnYyyymmSet();
													UniAppManager.updateStatus('<t:message code="system.message.inventory.message009" default="작업이 완료 되었습니다."/>');
												}
												panelSearch.getEl().unmask()
											});
										};
									});
								} else {

								}
							}
						}
			    }]
		}]
	    , setPeriod : function(fieldName, nValue)	{
	    	var cYear = panelSearch.getValue("BASE_YEAR");
	    	var quad = panelSearch.getValue("WORK_QUAD");
	    	if(fieldName == "BASE_YEAR")	{
	    		cYear = nValue;
	    	}
	    	if(fieldName == "WORK_QUAD")	{
	    		quad = nValue;
	    	}
	    	
			if(Ext.isEmpty(cYear))	{
				cYear = new Date().getFullYear()
			}
			if(quad == "1")	{
				panelSearch.setValue("START_YYYYMM" , cYear+"0101");
				panelSearch.setValue("CLOSE_YYYYMM" , cYear+"0331");
				panelSearch.setValue("P_CLOSE_YYYYMM" , cYear+"0331");
			} else if(quad == "2")	{
				panelSearch.setValue("START_YYYYMM" , cYear+"0401");
				panelSearch.setValue("CLOSE_YYYYMM" , cYear+"0630");
				panelSearch.setValue("P_CLOSE_YYYYMM" , cYear+"0630");
			} else if(quad == "3")	{
				panelSearch.setValue("START_YYYYMM" , cYear+"0701");
				panelSearch.setValue("CLOSE_YYYYMM" , cYear+"0930");
				panelSearch.setValue("P_CLOSE_YYYYMM" , cYear+"0930");
			} else if(quad == "4")	{
				panelSearch.setValue("START_YYYYMM" , cYear+"1001");
				panelSearch.setValue("CLOSE_YYYYMM" , cYear+"1231");
				panelSearch.setValue("P_CLOSE_YYYYMM" , cYear+"1231");
			} else if(quad == "First")	{
				panelSearch.setValue("START_YYYYMM" , cYear+"0101");
				panelSearch.setValue("CLOSE_YYYYMM" , cYear+"0630");
				panelSearch.setValue("P_CLOSE_YYYYMM" , cYear+"0630");
			} else if(quad == "Second")	{
				panelSearch.setValue("START_YYYYMM" , cYear+"0701");
				panelSearch.setValue("CLOSE_YYYYMM" , cYear+"1231");
				panelSearch.setValue("P_CLOSE_YYYYMM" , cYear+"1231");
			} 
	    }
	});

	Unilite.Main( {
		items:[panelSearch],
		id: 'biv115ukrvApp',
		fnInitBinding: function(params) {
			if(params && params.DIV_CODE)	{
				panelSearch.setValue('DIV_CODE', params.DIV_CODE);
				panelSearch.setValue('CLOSE_YYYYMM', params.CLOSE_YYYYMM);
			} else {
				panelSearch.setValue('DIV_CODE', UserInfo.divCode);
				/* panelSearch.setValue('LAST_YYYYMM', '0000.00');
				panelSearch.setValue('CLOSE_YYYYMM', UniDate.get('today'));
				panelSearch.setValue('BASIS_YYYYMM', '0000.00'); */
				UniAppManager.app.fnYyyymmSet(UserInfo.divCode);
			}
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);

		},
		fnYyyymmSet : function(divCode) {		// 사업장 선택에 따라 날짜 set
			panelSearch.setValue('LAST_YYYYMM', '');
			panelSearch.setValue('CLOSE_YYYYMM', UniDate.get('today'));
			panelSearch.setValue('P_CLOSE_YYYYMM', UniDate.get('today'));
			panelSearch.setValue('BASIS_YYYYMM', '');
			panelSearch.getField( 'PROCESS_TYPE').setValue('1');	// 마감으로 rdo 변경

			var param = {"DIV_CODE": panelSearch.getValue('DIV_CODE')};
			biv115ukrvService.YyyymmSet(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)) {
					if(param.LAST_YYYYMM = '000000') {
						panelSearch.setValue('LAST_YYYYMM', '0000.00');
					}
					var lastDate = provider.LAST_YYYYMM;
					var basisDate = provider.BASIS_YYYYMM;
					lastDate = lastDate.substring(0,4) + '.' + lastDate.substring(4,6);
					basisDate = basisDate.substring(0,4) + '.' + basisDate.substring(4,6);
					if(provider.LAST_YYYYMM != '000000') panelSearch.setValue('LAST_YYYYMM', lastDate);
					if(provider.BASIS_YYYYMM != '000000') panelSearch.setValue('BASIS_YYYYMM', basisDate);
					panelSearch.setValue('TEMP_CLOSE_YYYYMM', provider['LAST_YYYYMM']);
					panelSearch.setValue('CLOSE_YYYYMM', UniDate.add(panelSearch.getValue('TEMP_CLOSE_YYYYMM'), {months:1}));
				} else {
					panelSearch.setValue('LAST_YYYYMM', '0000.00');
					panelSearch.setValue('BASIS_YYYYMM', '0000.00');
					panelSearch.setValue('TEMP_CLOSE_YYYYMM', '0000.00');
					panelSearch.setValue('CLOSE_YYYYMM', UniDate.get('today'));
					panelSearch.getField('CLOSE_YYYYMM').setReadOnly(false);
				}
				panelSearch.getField( 'PROCESS_TYPE').setValue('1');	// 마감으로 rdo 변경
				if(panelSearch.getValue('LAST_YYYYMM') == '0000.00') {
					panelSearch.getField("CLOSED_RDO_YN").setReadOnly(true);	//최종마감일이 없을시  rdo disabled 취소선택 못하게
				} else {
					panelSearch.getField("CLOSED_RDO_YN").setReadOnly(false);
				}
			})
		},
		fnRadioSet: function(newValue) {		// radio 선택에 따라 날짜 set
			if(newValue.PROCESS_TYPE == '1') {	// 마감
				if(panelSearch.getValue('LAST_YYYYMM') == '0000.00') {
					panelSearch.getField("CLOSED_RDO_YN").setReadOnly(true);	//최종마감일이 없을시  rdo disabled 취소선택 못하게
				} else {
					panelSearch.getField("CLOSED_RDO_YN").setReadOnly(false);
					panelSearch.setValue('CLOSE_YYYYMM', UniDate.add(panelSearch.getValue('TEMP_CLOSE_YYYYMM'), {months:1}));
				}
			}
			if(newValue.PROCESS_TYPE == '2') {	// 취소
				var StrDate1 = panelSearch.getValue('LAST_YYYYMM');
				var sBasisYyyymm = panelSearch.getValue('BASIS_YYYYMM');
				if(StrDate1 <= sBasisYyyymm){
					alert('<t:message code="system.message.inventory.message018" default="기초반영년월이"/>' + ' ' + sBasisYyyymm + '<t:message code="system.message.inventory.message019" default="월이므로 취소가 불가능합니다."/>')	//기초반영월이 ?월이므로 취소가 불가능합니다.
					return false;
				}
				if(panelSearch.getValue('LAST_YYYYMM') == '0000.00') {
					//Ext.getCmp('rdo').setDisabled(true);	// 날짜가 없을시  rdodisabled
				} else {
					panelSearch.setValue('CLOSE_YYYYMM', panelSearch.getValue('LAST_YYYYMM'));
				}
			}
		}
	});

};


</script>
