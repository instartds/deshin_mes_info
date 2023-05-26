<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx110ukr"  >
	<t:ExtComboStore comboType="BOR120" />											<!-- 사업장    -->  
    <t:ExtComboStore items="${DIV_CODE_USE}" storeId="comboDivCode" /> 				<!-- 전체사업장-->
    <t:ExtComboStore items="${SALE_DIV_CODE}" storeId="comboSaleDivCode" />			<!-- 매출사업장 -->
	<t:ExtComboStore comboType="AU" 	comboCode="S096" /> 						<!-- 세금계산서구분	-->
	<t:ExtComboStore comboType="AU" 	comboCode="S095" /> 						<!-- 국세청수정사유	-->
	<t:ExtComboStore comboType="AU" 	comboCode="S010" /> 						<!-- 영업담당자		-->	
	<t:ExtComboStore comboType="AU" 	comboCode="A020" />							<!-- 예/아니오	-->
	<t:ExtComboStore comboType="AU" 	comboCode="A012" opts= '${gsListA012}'/>	<!-- 거래유형(매출)	-->
	<t:ExtComboStore comboType="AU" 	comboCode="A022" />	<!-- 증빙유형(매출)	-->
</t:appConfig>

<script type="text/javascript">

var searchInfoWindow;											//searchInfoWindow : 검색창

var BsaCodeInfo = {
	gsBillYn		: '${gsBillYn}',
	gsBillDbUser	: '${gsBillDbUser}',
	gsBillConnect	: '${gsBillConnect}'
//	gsAutoType		: '${gsAutoType}'									//자동채번 여부
//	gsVatRate		: '${gsVatRate}',									//부가세율
//	gsMoneyUnit		: '${gsMoneyUnit}',
//	gsAutoreg		: '${gsAutoreg}',
//	gsPjtCodeYN		: '${gsPjtCodeYN}',	
//	salePrsn		: '${salePrsn}',
//	gsCustomGubun	: '${gsCustomGubun}',
//	gsBusiPrintPgm	: '${gsBusiPrintPgm}',
//	gsBillPrsnEssYN	: '${gsBillPrsnEssYN}'
//	gsCollectDayFlg	: '${gsCollectDayFlg}'
};

var CustomCodeInfo = {	 
	gsTaxCalcType	: '',		//세액계산법
	gsUnderCalBase	: '',		//원미만계산
	gsCollector		: '',		//수금거래처
	gsColetCare		: '',		//미수관리법
	gsBillDivChgYN	: ''		//신고사업장 여부?
//	gsCollectDay : '',			//수금예정일
};
//var output ='';
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);


/*//자동채번 사용 여부 - 회계에서는 사용하지 않음
var AutoType = false;
if(BsaCodeInfo.gsAutoType == "Y"){
	AutoType = true;
}
var pjtCodeYN = false;
if(BsaCodeInfo.gsAutoType == "N"){
	pjtCodeYN = true;
}*/
var outDivCode	= UserInfo.divCode;
var gbTaxEdit	= '';
var deletable	= '';
var innerText	= Msg.sMS113;
var delfag 		= '';
var linkFlag	= false;
//var fnUpdateChanges		= '';
//20161026 매출일 필드 삭제
//var beforeFrSaleDate	= '';
//var beforeToSaleDate	= '';
//var resetButtonFlag		= '';

function appMain() {	
/*	//자동채번 여부 - 회계에서는 사용하지 않음
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoOrderNum = true;
	}*/
	
	var gsAcDate = '';
	var gsPjtCode = '';
	var gsDivCode = '';
	var gsStatusM = '';
	var sSaleAmt = 0;
	var sTaxAmt = 0;
	var gsBeforePubNum	= '';			//계산서발행번호
	var gsOriginalPubNum=  '';			//원본계산서발행번호
	var gsSaveRefFlag	= 'N';			//검색후에만 수정 가능하게 조회버튼 활성화..
	var busiTypeFlag	= true;			//거래유형에 따른 증빙유형 변경되는 로직 실행/미실행 flag
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'atx110ukrService.selectDetailList',
			update	: 'atx110ukrService.updateDetail',
			create	: 'atx110ukrService.insertDetail',
			destroy	: 'atx110ukrService.deleteDetail',
			syncAll	: 'atx110ukrService.saveAll'
		}
	});
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'atx110ukrService.runProcedure',
            syncAll	: 'atx110ukrService.callProcedure'
		}
	});	

/*	ATX110T SEND_NAME으로 변경
	*//** 영업담당 콤보 Store 정의
	 * @type 
	 *//*					
	var salePrsnStore = Unilite.createStore('atx110ukrSalePrsnStore',{
        proxy: {
           type: 'direct',
            api: {			
                read: 'atx110ukrService.getSalePrsn'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('atx110ukrPanelSearch').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
*/	
    var buttonStore = Unilite.createStore('Atx110UkrButtonStore',{      
        uniOpt		: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,            // 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy		: directButtonProxy,
        saveStore	: function(buttonFlag) {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

            var paramMaster = panelSearch.getValues();
            paramMaster.OPR_FLAG	= buttonFlag;
			paramMaster.PROC_DATE	= UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'));

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        //return 값 저장
                        var master = batch.operations[0].getResultSet();
                        
                        //매출기표/취소 작업 후 메세지
//                        if (paramMaster.OPR_FLAG == 'D') {
//                        	alert (Msg.sMH1040);														//"취소작업작업이 완료되었습니다."
//                        	
//                        } else {
//                        	alert (Msg.sMA0328);														//"자동기표가 완료되었습니다."
//                        }
                        
                        UniAppManager.app.onQueryButtonDown();
                        buttonStore.clearData();

						//전자세금계산서 관련 버튼 세팅
						if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))) {
							if (panelSearch.getValue('BILL_SEND_YN') == 'Y') {
								Ext.getCmp('btnEtax').setDisabled(true);
								Ext.getCmp('btnViewEtax').setDisabled(false);
								
							} else {
								Ext.getCmp('btnEtax').setDisabled(false);
								Ext.getCmp('btnViewEtax').setDisabled(true);
							}
						}

                     },

                     failure: function(batch, option) {
                        buttonStore.clearData();
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('atx110ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners	: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
    });
	var panelSearch = Unilite.createSearchForm('atx110ukrPanelSearch',{		
    	region		: 'center', 
    	autoScroll	: true,
    	border		: true,
    	padding		: '1 0 1 1',
    	flex		: 3,
    	minWidth	: 1060,
    	layout		: {type : 'uniTable', columns : 2, tableAttrs :{width :'100%', border :0}},
    	items		: [{
    		layout	: {type : 'uniTable', columns : 5},
			padding	: '1 1 1 1',			
			xtype	: 'container',
			defaults: {margin: '5 0 0 0'},
			items	: [{
				fieldLabel	: '일련번호',
				name		:'PUB_NUM', 	
				xtype		: 'uniTextfield',
				labelWidth	: 110
//				readOnly	: AutoType,
//				tdAttrs		: {style: 'border-bottom: 1px solid #cccccc; padding-top: 0px; padding-bottom: 4px'  }
				
			}, { 
				fieldLabel	: '매출사업장',
				name		: 'SALE_DIV_CODE',
				xtype		: 'uniCombobox',
//				labelWidth	: 110,
				width		: 250,
				store		: Ext.data.StoreManager.lookup('comboSaleDivCode'),
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change	: function(combo, newValue, oldValue, eOpts) {
						UniAppManager.app.fnRecordComBo();
					}
				}
//				tdAttrs		: {style: 'border-bottom: 1px solid #cccccc; padding-top: 0px; padding-bottom: 4px'  }
			}, {//20161026 매출일 필드 삭제 (PANEL 디자인 때문에 삭제하지 않고 주석처리)
				fieldLabel	: ' ',
				xtype		: 'component',
//				fieldLabel	: '매출일',
//				labelWidth	: 123,
//				xtype		: 'uniDateRangefield',
//				startFieldName: 'FR_DATE',
//				endFieldName: 'TO_DATE',
				width		: 385,
//				startDate	: UniDate.get('startOfMonth'),
//				endDate		: UniDate.get('today'),
//				allowBlank	: false,
//				tdAttrs		: {style: 'border-bottom: 1px solid #cccccc; padding-top: 0px; padding-bottom: 4px'  },
				holdable	: 'hold'
			},{
				xtype: 'container',
				layout : {type : 'uniTable'},
//				colspan:3,
				items:[{
		        	xtype		: 'button',
					text		: 'E-Tax 전송',
					id			: 'btnEtax',
					hidden      : true,
					handler		: function() {
						var param =  panelSearch.getValues();
						param.OPR_FLAG		= 'T';
	            		param.LANG_TYPE		= UserInfo.userLang;
						atx110ukrService.sendEtax(param, function(provider, response)	{	
							if (provider) {
//								alert(Msg.fsbMsgB0076);
								Ext.Msg.alert('확인', Msg.fsbMsgB0076);						//"전송이 완료되었습니다."
								UniAppManager.app.onQueryButtonDown();
							}
						});		
					}				
		        }, {
		        	xtype		: 'button',
					text		: '상세보기',
					id			: 'btnViewEtax',
					hidden      : true,
					handler		: function() {
						if (!Ext.isEmpty(panelSearch.getValue('ISSU_ID'))) {	
							window.open('https://web.taxbill365.com/jsp/corp/comm/comm_0001_02.jsp?SCH_GB=2&ISSU_ID=' + panelSearch.getValue('ISSU_ID'), '_blank'); 
//							window.location = 'https://devweb.taxbill365.com/jsp/corp/comm/comm_0001_02.jsp?SCH_GB=2&ISSU_ID=2016090541000026a010092k'
//							window.location = 'https://web.taxbill365.com/jsp/corp/comm/comm_0001_02.jsp?SCH_GB=2&ISSU_ID=' + record.data.ISSU_ID;
//							'<a href="https://devweb.taxbill365.com/jsp/corp/comm/comm_0001_02.jsp?SCH_GB=2&ISSU_ID=' + record.data.ISSU_ID + '" target="_blank"></a>';
						} else {
							alert ('국세청 신고된 계산서만 상세내역을 볼 수 있습니다.')
						}
					}				
		        }]
			}/*,{	        	
	        	xtype: 'component',
				width: 45
//				tdAttrs: {style: 'border-bottom: 1px solid #cccccc; padding-top: 0px; padding-bottom: 4px'  }				
	        }*/]
    	},{
    		xtype: 'container',
    		tdAttrs:{align:'right'},
    		layout : {type:'uniTable', columns:3, tdAttrs:{align:'right',style:'padding-right:5px;'}},
    		items:[
    			{
    	        	xtype		: 'button',
    				text		: '매출기표',
    				disabled	: true,
    				itemId			: 'btnAccnt',
    				handler		: function() {
    					
    					var param = {
    							BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE'),
    							PUB_NUM : 		panelSearch.getValue('PUB_NUM')
    						}
    						Ext.getBody().mask();
    						atx110ukrService.selectMasterList(param, function(provider, response) {
    							Ext.getBody().unmask();
    							var exDate = UniDate.getDbDateStr(provider.EX_DATE);
    							var exNum = provider.EX_NUM;
    							var agree_yn = provider.AGREE_YN;
    							if(!Ext.isEmpty(exDate)&& !Ext.isEmpty(exNum) && exNum != 0) {
    								Unilite.messageBox("이미 전표가 등록되었습니다.");
    								panelSearch.down('#btnAccnt').setDisabled(true);
    								panelSearch.down('#btnCancel').setDisabled(false);
    								panelSearch.setValue('EX_DATE', exDate);
    								panelSearch.setValue('EX_NUM', exNum);
    								return
    							} else {
    								var params = {
    									'PGM_ID'		: 'atx110ukr',
    									'sGubun'		: '34',
    									'DIV_CODE' 		: panelSearch.getValue("SALE_DIV_CODE"),
    									'PUB_DATE'  	: UniDate.getDateStr(panelSearch.getValue("WRITE_DATE")),
    									'BILL_PUB_NUM'	: panelSearch.getValue("PUB_NUM")
    								}
    								var rec = {data : {prgID : 'agj260ukr', 'text':''}};
									parent.openTab(rec, '/accnt/agj260ukr.do', params, CHOST+CPATH);
    							} 

    						});
    				}				
    	        },{
    	        	xtype		: 'button',
    				text		: '기표취소',
    				itemId		: 'btnCancel',
    				disabled	: true,
    				handler		: function() {
    					
    					var param = {
    							BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE'),
    							PUB_NUM : 		panelSearch.getValue('PUB_NUM')
    						}
    						Ext.getBody().mask();
    						atx110ukrService.selectMasterList(param, function(provider, response) {
    							Ext.getBody().unmask();
    							var exDate = UniDate.getDbDateStr(provider.EX_DATE);
    							var exNum = provider.EX_NUM;
    							var agree_yn = provider.AGREE_YN;
    							if(Ext.isEmpty(exDate) || Ext.isEmpty(exNum) || exNum == 0) {
    								Unilite.messageBox('기표된 전표가 없습니다.');
    								return;
    							} else if(agree_yn == 'Y')	{
    								Unilite.messageBox('승인된 전표는 취소할 수 없습니다.');
    								return;
    							} else {
    								var param = {
    								'DIV_CODE' 		: panelSearch.getValue("SALE_DIV_CODE"),
    								'PUB_DATE'  	: UniDate.getDateStr(panelSearch.getValue("WRITE_DATE")),
    								'BILL_PUB_NUM'	: panelSearch.getValue("PUB_NUM")
    								}
    								agj260ukrService.cancelAutoSlip34(param,function(responseText, response) {
    									if(!Ext.isEmpty(responseText.ERROR_DESC) ) {
    										if(responseText.EBYN_MESSAGE=="FALSE") {
    											console.log(responseText.ERROR_DESC);
    										}
    									}else {
    										UniAppManager.updateStatus('기표 취소되었습니다');
    										UniAppManager.app.onQueryButtonDown();
    									}
    								});
    							}

    						});
    				}				
    	        }, {
		        	xtype		: 'button',
					text		: '거래처등록',
					id			: 'btnCustom',
					handler		: function() {
						var params = {
	//							 : record.get(''),
							}
							var rec = {data : {prgID : 'bcm100ukrv', 'text':''}};							
							parent.openTab(rec, '/base/'+'bcm100ukrv'+'.do', params);	
					}				
		        }
    		]
    	}, {
    		
    		colspan: 2,
    		layout	: {type : 'uniTable', columns : 4, tdAttrs: {width: '100%'}},
			padding	: '1 1 1 1',			
			xtype	: 'container',
//			defaults: {margin: '5 0 0 0'},
			items	: [{
				xtype: 'uniDatefield',
				name: 'WRITE_DATE',
				fieldLabel: '작성일',
				allowBlank: false,
				labelWidth: 110,
				width: 264,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {			
	//								UniAppManager.app.fnRcptDateCal(CustomCodeInfo.gsCollectDay);
					}
				}
			},{
				fieldLabel	: 'ISSU_ID',
				xtype		: 'uniTextfield',
				name		: 'ISSU_ID',
//				labelWidth	: 110,
				width		: 250,
				tdAttrs		: {align: 'left'},
				readOnly	: true
			
			},{
				xtype	: 'component',
				width	: 185
			},{
				xtype: 'container',
				layout : {type : 'uniTable'},
		    	items:[{
		    		xtype: 'radiogroup',		            		
					fieldLabel: '발행구분',
					labelWidth: 110,						            		
					id: 'rdoSelect',
					tdAttrs: {align: 'left'},
					items: [{
						boxLabel: '정발행', 
						width: 70, 
						name: 'BILL_PUBLISH_TYPE',
		    			inputValue: '1'
//						checked: true  
					},{
						boxLabel : '역발행', 
						width: 70,
						name: 'BILL_PUBLISH_TYPE',
		    			inputValue: '2'
					},{
						boxLabel : '위수탁발행', 
						width: 90,
						name: 'BILL_PUBLISH_TYPE',
		    			inputValue: '3'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
				    		if(newValue.BILL_PUBLISH_TYPE == '1'){
//				    			UniAppManager.app.onResetButtonDown();
			       				Ext.getCmp('fieldset1').setTitle('공급자');
			       				Ext.getCmp('fieldset2').setTitle('공급받는자');
			       				Ext.getCmp('atx110ukrAddSearch').setHidden(true);
			       				
								addSearch.clearForm();			
								masterGrid.getStore().loadData({});
	
								addSearch.getField('BROK_CUST_COM_NUM').setConfig('allowBlank'	, true);
								addSearch.getField('BROK_CUSTOM_CODE').setConfig('allowBlank'	, true);
								addSearch.getField('BROK_CUSTOM_NAME').setConfig('allowBlank'	, true);
								addSearch.getField('BROK_CUST_TOP_NAME').setConfig('allowBlank'	, true);
								addSearch.getField('BROK_PRSN_EMAIL').setConfig('allowBlank'	, true);
			
			   				} else if(newValue.BILL_PUBLISH_TYPE == '2') {
//				    			UniAppManager.app.onResetButtonDown();
			       				Ext.getCmp('fieldset1').setTitle('공급받는자');
			       				Ext.getCmp('fieldset2').setTitle('공급자');
			       				Ext.getCmp('atx110ukrAddSearch').setHidden(true);
			       				
								addSearch.clearForm();			
								masterGrid.getStore().loadData({});
								
								addSearch.getField('BROK_CUST_COM_NUM').setConfig('allowBlank'	, true);
								addSearch.getField('BROK_CUSTOM_CODE').setConfig('allowBlank'	, true);
								addSearch.getField('BROK_CUSTOM_NAME').setConfig('allowBlank'	, true);
								addSearch.getField('BROK_CUST_TOP_NAME').setConfig('allowBlank'	, true);
								addSearch.getField('BROK_PRSN_EMAIL').setConfig('allowBlank'	, true);
	
			   				} else if(newValue.BILL_PUBLISH_TYPE == '3') {				//위수탁 발행일 경우, 해당 패널 SHOW {
//				    			UniAppManager.app.onResetButtonDown();
			       				Ext.getCmp('fieldset1').setTitle('공급자');
			       				Ext.getCmp('fieldset2').setTitle('공급받는자');
			       				Ext.getCmp('atx110ukrAddSearch').setHidden(false);
			       				
								addSearch.clearForm();			
								masterGrid.getStore().loadData({});
								
								addSearch.getField('BROK_CUST_COM_NUM').setConfig('allowBlank'	, false);
								addSearch.getField('BROK_CUSTOM_CODE').setConfig('allowBlank'	, false);
								addSearch.getField('BROK_CUSTOM_NAME').setConfig('allowBlank'	, false);
								addSearch.getField('BROK_CUST_TOP_NAME').setConfig('allowBlank'	, false);
								addSearch.getField('BROK_PRSN_EMAIL').setConfig('allowBlank'	, false);
	
			   				}
						}
					}
				}]
			}]
    	},{
    		xtype	: 'container',
    		colspan : 2,
    		layout	: {type : 'uniTable', columns : 1},
	    	border	: true,
			padding	: '1 1 1 1',
	    	items	: [{
	    		xtype	: 'container',
	    		margin	: '0 0 0 0',
	    		layout	: {type : 'uniTable', columns : 4},			
				items	: [{
					xtype: 'component',
					width: 10
				}, {
					title	: '공급자',
		        	xtype	: 'fieldset',
		        	id		: 'fieldset1',
		        	padding	: '0 10 10 10',
		        	margin	: '0 0 0 0',
		        	height  : 165,
		 		    defaults: {readOnly: true, xtype: 'uniTextfield'},
		 		    layout	: {type: 'uniTable' , columns: 2},
		        	items: [{
						fieldLabel: '등록번호',
						name:'OWN_COM_NUM', 	
						colspan: 2
					}, { 
						xtype	: 'uniCombobox',
						fieldLabel: '상호(법인명)',
						name	: 'BILL_DIV_CODE',
						store	: Ext.data.StoreManager.lookup('comboDivCode'),
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
//								salePrsnStore.loadStoreRecords();
							}
						}   
						
					}, {
						fieldLabel: '성명(대표자)',
						name:'OWN_TOP_NAME' 	
					}, {
						fieldLabel: '사업장주소',
						name:'OWN_ADDRESS', 	
						width: 490, 	
						colspan: 2
					}, {
						fieldLabel: '업태',
						name:'OWN_COMP_TYPE' 	
					}, {
						fieldLabel: '종목',
						name:'OWN_COMP_CLASS' 	
					}, {
						fieldLabel: '종사업자번호',
						name:'OWN_SERVANT_NUM'	
					}]
				}, {
					xtype: 'component',
					width: 10
				}, {
					title	: '공급받는자',
					padding	: '0 10 10 10',
					margin	: '0 0 0 0',
		        	xtype	: 'fieldset',
		        	id		: 'fieldset2',
		        	height  : 165,
		 		    defaults: {readOnly: true, xtype: 'uniTextfield'},
		 		    layout	: {type: 'uniTable' , columns: 2},
		        	items	: [{
						fieldLabel: '등록번호',
						name:'CUST_COM_NUM'
					},
						Unilite.popup('AGENT_CUST_SINGLE2',{	
						fieldLabel	: '고객코드',
						allowBlank	: false,
						validateBlank: false,
						textFieldName:'CUSTOM_CODE',
						DBtextFieldName: 'CUSTOM_CODE',
						readOnly	: false,
           				extParam	: {'CUSTOM_TYPE': ['1','3']},  
						holdable	: 'hold',
						listeners	: {
							applyextparam: function(popup){
								popup.setExtParam({'SINGLE_CODE': true});							
							},
							onSelected: {
								fn: function(records, type) {
									 panelSearch.setValue('CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
									 if(Ext.isEmpty(records[0]["TAX_CALC_TYPE"]) ||  records[0]["TAX_CALC_TYPE"] == "2"){
									 	CustomCodeInfo.gsTaxCalcType = "2";
									 	
									 } else {
									 	CustomCodeInfo.gsTaxCalcType = "1";
									 }
//									 CustomCodeInfo.gsCollectDay = records[0]["COLLECT_DAY"];	//수금예정일
//									 UniAppManager.app.fnRcptDateCal(CustomCodeInfo.gsCollectDay);	
									
									if(!Ext.isEmpty(records[0]["COMPANY_NUM"]) && records[0]["COMPANY_NUM"].length == 10){	//사업자번호
										rsComNum =  records[0]["COMPANY_NUM"];
										comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
										panelSearch.setValue('CUST_COM_NUM', comNum);
									} else {
										comNum = records[0]["COMPANY_NUM"];
										panelSearch.setValue('CUST_COM_NUM', comNum);
									}
									
									panelSearch.setValue('TOP_NAME'		, records[0]["TOP_NAME"]);	//대표자
									panelSearch.setValue('TOP_NUM', records[0]["TOP_NUM"]);	//주민등록번호
									panelSearch.setValue('ADDR'			, records[0]["ADDR1"] + ' ' + records[0]["ADDR2"]);	//주소
									panelSearch.setValue('COMP_TYPE'	, records[0]["COMP_TYPE"]);	//업태
									panelSearch.setValue('COMP_CLASS'	, records[0]["COMP_CLASS"]);	//업종
									panelSearch.setValue('CUST_SERVANT_NUM', records[0]["SERVANT_COMPANY_NUM"]);	//종사업장번호
									
									CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"]	//원미계산
									if(Ext.isEmpty(records[0]["COLLECTOR_CP"])){//수금거래처
										CustomCodeInfo.gsCollector = records[0]["CUSTOM_CODE"];
									} else {
										CustomCodeInfo.gsCollector = records[0]["COLLECTOR_CP"];
									}

									if(Ext.isEmpty(records[0]["BILL_DIV_CODE"])){
										CustomCodeInfo.gsBillDivChgYN = 'N'
										UniAppManager.app.fnRecordComBo();	//신고사업장 가져오기
									} else {
										CustomCodeInfo.gsBillDivChgYN = 'Y'
										panelSearch.setValue('BILL_DIV_CODE', records[0]["BILL_DIV_CODE"]);
										UniAppManager.app.billDivCode_onChange();									
									}
									
									//담당자 정보 있을 때는 입력하고
									if (!Ext.isEmpty(records[0]["PRSN_NAME"])) {
										panelSearch.setValue('PRSN_NAME', records[0]["PRSN_NAME"]);				//공급받는 자 명
										panelSearch.setValue('PRSN_EMAIL', records[0]["PRSN_EMAIL"]);			//공급받는 자 이메일
										panelSearch.setValue('PRSN_PHONE', records[0]["PRSN_PHONE"]);			//공급받는 자 연락처
										panelSearch.setValue('PRSN_HANDPHONE', records[0]["PRSN_HANDPHONE"]);			//공급받는 자 핸드폰 번호
										
									//없을 때는 가장 최근 발행한 계산서의 담당자 명 입력 
									} else {
										var param = {
											'DIV_CODE'		: panelSearch.getValue('SALE_DIV_CODE'),
											'CUSTOM_CODE'	: panelSearch.getValue('CUSTOM_CODE')
										}
										atx110ukrService.getPersonInfo(param, function(provider, response)	{
											if(!Ext.isEmpty(provider)) {
												panelSearch.setValue('PRSN_NAME'		, provider.data.PRSN_NAME);
												panelSearch.setValue('PRSN_EMAIL'		, provider.data.PRSN_EMAIL);
												panelSearch.setValue('PRSN_PHONE'		, provider.data.PRSN_PHONE);
												panelSearch.setValue('PRSN_HANDPHONE'	, provider.data.PRSN_HANDPHONE);
											}
										});		
									}
			                     },
							scope: this
							},
							onClear: function(type)	{		////onClear가 먹지 않음
								panelSearch.setValue('CUSTOM_NAME'		, '')
								panelSearch.setValue('TOP_NAME'			, '')	//대표자
								panelSearch.setValue('ADDR'				, '')	//주소
								panelSearch.setValue('COMP_TYPE'		, '')	//업태
								panelSearch.setValue('COMP_CLASS'		, '')	//업종
								panelSearch.setValue('CUST_SERVANT_NUM'	, '')	//종사업장번호
								panelSearch.setValue('CUST_COM_NUM'		, '')
								panelSearch.setValue('PRSN_NAME'		, '')	//공급받는 자 명
								panelSearch.setValue('PRSN_EMAIL'		, '')	//공급받는 자 이메일
								panelSearch.setValue('PRSN_PHONE'		, '')
								panelSearch.setValue('PRSN_HANDPHONE'		, '')
							},
							onTextFieldChange: function(field, newValue){
								if (Ext.isEmpty(newValue)) {
									panelSearch.setValue('CUSTOM_NAME'		, '')
									panelSearch.setValue('TOP_NAME'			, '')	//대표자
									panelSearch.setValue('ADDR'				, '')	//주소
									panelSearch.setValue('COMP_TYPE'		, '')	//업태
									panelSearch.setValue('COMP_CLASS'		, '')	//업종
									panelSearch.setValue('CUST_SERVANT_NUM'	, '')	//종사업장번호
									panelSearch.setValue('CUST_COM_NUM'		, '')
									panelSearch.setValue('PRSN_NAME'		, '')	//공급받는 자 명
									panelSearch.setValue('PRSN_EMAIL'		, '')	//공급받는 자 이메일
									panelSearch.setValue('PRSN_PHONE'		, '')
									panelSearch.setValue('PRSN_HANDPHONE'		, '')
								}
							}
						}				
					}),
						Unilite.popup('AGENT_CUST_SINGLE2',{	
						fieldLabel: '상호(법인명)',
						allowBlank: false,
						validateBlank: false,
						textFieldName:'CUSTOM_NAME',
						DBtextFieldName: 'CUSTOM_NAME',
						readOnly: false,
						holdable: 'hold',
						listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'SINGLE_CODE': false});							
							},
							onSelected: {
								fn: function(records, type) {
									 panelSearch.setValue('CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
									 if(Ext.isEmpty(records[0]["TAX_CALC_TYPE"]) ||  records[0]["TAX_CALC_TYPE"] == "2"){
									 	CustomCodeInfo.gsTaxCalcType = "2";
									 } else {
									 	CustomCodeInfo.gsTaxCalcType = "1";
									 }
//									 CustomCodeInfo.gsCollectDay = records[0]["COLLECT_DAY"];	//수금예정일
//									 UniAppManager.app.fnRcptDateCal(CustomCodeInfo.gsCollectDay);
									
									if(!Ext.isEmpty(records[0]["COMPANY_NUM"]) && records[0]["COMPANY_NUM"].length == 10){	//사업자번호
										rsComNum =  records[0]["COMPANY_NUM"];
										comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
										panelSearch.setValue('CUST_COM_NUM', comNum);
									} else {
										comNum = records[0]["COMPANY_NUM"];
										panelSearch.setValue('CUST_COM_NUM', comNum);
									}
									
									panelSearch.setValue('TOP_NAME', records[0]["TOP_NAME"]);	//대표자
									panelSearch.setValue('TOP_NUM', records[0]["TOP_NUM"]);	//주민등록번호
									panelSearch.setValue('ADDR', records[0]["ADDR1"] + ' ' + records[0]["ADDR2"]);	//주소
									panelSearch.setValue('COMP_TYPE', records[0]["COMP_TYPE"]);	//업태
									panelSearch.setValue('COMP_CLASS', records[0]["COMP_CLASS"]);	//업종
									panelSearch.setValue('CUST_SERVANT_NUM', records[0]["SERVANT_COMPANY_NUM"]);	//종사업장번호
									
									CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"]	//원미계산
									if(Ext.isEmpty(records[0]["COLLECTOR_CP"])){//수금거래처
										CustomCodeInfo.gsCollector = records[0]["CUSTOM_CODE"];
									} else {
										CustomCodeInfo.gsCollector = records[0]["COLLECTOR_CP"];
									}

									if(Ext.isEmpty(records[0]["BILL_DIV_CODE"])){
										CustomCodeInfo.gsBillDivChgYN = 'N'
										UniAppManager.app.fnRecordComBo();	//신고사업장 가져오기
									} else {
										CustomCodeInfo.gsBillDivChgYN = 'Y'
										panelSearch.setValue('BILL_DIV_CODE', records[0]["BILL_DIV_CODE"]);
										UniAppManager.app.billDivCode_onChange();									
									}
									panelSearch.setValue('PRSN_NAME', records[0]["PRSN_NAME"]);				//공급받는 자 명
									panelSearch.setValue('PRSN_EMAIL', records[0]["PRSN_EMAIL"]);			//공급받는 자 이메일
									panelSearch.setValue('PRSN_PHONE', records[0]["PRSN_PHONE"]);			//공급받는 자 연락처
									panelSearch.setValue('PRSN_HANDPHONE', records[0]["PRSN_HANDPHONE"]);			//공급받는 자 핸드폰 번호

			                     },
							scope: this
							},
							onClear: function(type)	{		////onClear가 먹지 않음
								panelSearch.setValue('CUSTOM_NAME'		, '')
								panelSearch.setValue('TOP_NAME'			, '')	//대표자
								panelSearch.setValue('ADDR'		, '')	//주소
								panelSearch.setValue('COMP_TYPE'	, '')	//업태
								panelSearch.setValue('COMP_CLASS'	, '')	//업종
								panelSearch.setValue('CUST_SERVANT_NUM'	, '')	//종사업장번호
								panelSearch.setValue('CUST_COM_NUM'		, '')
								panelSearch.setValue('PRSN_NAME'		, '')	//공급받는 자 명
								panelSearch.setValue('PRSN_EMAIL'		, '')	//공급받는 자 이메일
								panelSearch.setValue('PRSN_PHONE'		, '')
								panelSearch.setValue('PRSN_HANDPHONE'		, '')
							},
							onTextFieldChange: function(field, newValue){
								if (Ext.isEmpty(newValue)) {
									panelSearch.setValue('CUSTOM_CODE'		, '')
									panelSearch.setValue('TOP_NAME'			, '')	//대표자
									panelSearch.setValue('ADDR'		, '')	//주소
									panelSearch.setValue('COMP_TYPE'	, '')	//업태
									panelSearch.setValue('COMP_CLASS'	, '')	//업종
									panelSearch.setValue('CUST_SERVANT_NUM'	, '')	//종사업장번호
									panelSearch.setValue('CUST_COM_NUM'		, '')
									panelSearch.setValue('PRSN_NAME'		, '')	//공급받는 자 명
									panelSearch.setValue('PRSN_EMAIL'		, '')	//공급받는 자 이메일
									panelSearch.setValue('PRSN_PHONE'		, '')
									panelSearch.setValue('PRSN_HANDPHONE'		, '')
								}
							}	
						}				
					}),{
						fieldLabel: '성명(대표자)',
						name:'TOP_NAME',
						allowBlank: false
					}, {
						fieldLabel: '사업장주소',
						name:'ADDR', 	
						width: 490, 	
						colspan: 2
					}, {
						fieldLabel: '업태',
						name:'COMP_TYPE' 	
					}, {
						fieldLabel: '종목',
						name:'COMP_CLASS' 	
					}, {
						fieldLabel: '종사업자번호',
						name:'CUST_SERVANT_NUM',
						readOnly	: false
					},{
						fieldLabel: '주민번호', 
						name: 'TOP_NUM',
						hidden: true
					}, {
						fieldLabel: '주민등록번호',
						name:'CUST_TOP_NUM',
						readOnly:true,
						focusable:false,
		                maxLength: 14,
		                value	: '**************',
		                listeners:{
		                    afterrender:function(field) {
		                        field.getEl().on('dblclick', field.onDblclick);
		                    }
		                },
		                onDblclick:function(event, elm) {                   
		                    panelSearch.openCryptRepreNoPopup();
		                }
					}, {
						xtype: 'container',
						items:[{
							fieldLabel: '당초승인번호',
							xtype: 'uniTextfield',
							name:'BF_ISSUE',
							readOnly: true,
							id: 'bfIssue'
						}]
					}]
				}]
	    	}, {
	    		xtype: 'container',
	    		margin: '0 0 0 0',
	    		xtype: 'container',
	    		layout : {type : 'uniTable', columns : 2},
				border:true,
				items: [{
					margin: '0 0 0 0',
					xtype: 'container',
					layout : {type : 'uniTable', columns : 2},
					items:[{
						xtype: 'uniNumberfield',
						name: 'SALE_AMT_O',
						fieldLabel: '공급가액',
						labelWidth: 110,
						readOnly: true
					},{
						xtype: 'uniNumberfield',
						name: 'TAX_AMT_O',
						fieldLabel: '세액',
						readOnly: true
					},{
			    		padding:'1 1 1 1',
						layout : {type : 'uniTable', columns : 2
//						, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
						},
						border:true,
						xtype: 'container',
						items:[{
							xtype: 'uniDatefield',
							fieldLabel: '결의전표일/번호',
							name: 'EX_DATE',
							width: 215,
							maxLength :10,
							labelWidth: 110,
							readOnly: true
						}, {
							xtype: 'uniNumberfield',
//							fieldLabel: '',
							hideLabel: true,
							name: 'EX_NUM',
							value: 0,
							width: 50, 
							readOnly: true,
							listeners	: {
								change: function(field, newValue, oldValue, eOpts) {		//폼에서 비고 입력시 그리드 적요컬럼 변경??					
									if (Ext.isEmpty(newValue)){
										panelSearch.setValue('EX_NUM', 0);
									}
								}
							}
				        }]
					},{
						fieldLabel	: '전자문서번호',
						xtype		: 'uniTextfield',
						name		: 'EB_NUM',
						readOnly	: true
					}]
				},{
					margin: '0 0 0 0',
					xtype: 'textareafield',
					name: 'REMARK',
					fieldLabel: '비고',
					labelWidth: 123,
					width: 524,
					grow: true,
					height: 47,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {		//폼에서 비고 입력시 그리드 적요컬럼 변경??					
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
						},
						blur: function(field, event, eOpts ) {						//비고에 입력된 글자수가 1000이 넘으면 FALSE		
							if(field.value.length > 1000) {
								alert(Msg.sMS219);									//"입력할 수 있는 자릿수를 초과하였습니다."
								panelSearch.getField('REMARK').focus();
							}
						}
					}
				}/*,{
					xtype: 'uniDatefield',		
					name: 'TEMP_COL_DATE',
					fieldLabel: '거래처수금예정일(temp)',
					hidden: true
				}*/]   	
	    	}]
    	
    	},{
    		padding:'1 1 1 1',
    		colspan : 2,
			layout : {type : 'uniTable', columns : 1},
			border:true,
			xtype: 'container',
			items:[{
				xtype: 'container',
				layout : {type : 'uniTable', columns : 6
//					tableAttrs: {style: 'border : 1px solid #ced9e7;'/*,width: '100%'*/},
//					tdAttrs: {style: 'border : 1px solid #ced9e7;'}
				},
				items: [
					Unilite.popup('PROJECT',{	
					fieldLabel: '사업코드',
					validateBlank: false, 
					valueFieldName:'PROJECT_NO',
                	textFieldName:'PROJECT_NO',
                	textFieldOnly: true, 
					itemId:'project',
//					valueFieldWidth: 90,
                	textFieldWidth: 160,
					labelWidth: 110,
//					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
									gsSaveRefFlag = "Y";
								}
	                    	},
							scope: this
						},
						onClear: function(type) {
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'BPARAM0': 3});
							popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
						}
					},
					tdAttrs: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }				
				}),{
					fieldLabel: '세금계산서구분',
					name: 'BILL_TYPE',
					id: 'billType',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'S096',	
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts){
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
							
							if(newValue == '1'){	//정상발행							
								Ext.getCmp('bfIssue').hide();
								panelSearch.getField('REMARK').allowBlank = true;	//// 폼의 allowBlank통제 하려면?
								//수정사유  readOnly, allowBlank 세팅 
								panelSearch.setValue('UPDATE_REASON', '');
								panelSearch.getField('UPDATE_REASON').setReadOnly(true);	
								panelSearch.getField('UPDATE_REASON').allowBlank = true;
								Ext.getCmp('labelText').setText('');
								
							} else if(newValue == '2'){	//수정발행 '2'							
								Ext.getCmp('bfIssue').show();
								panelSearch.getField('REMARK').allowBlank = false;
								//수정사유  readOnly, allowBlank 세팅
								panelSearch.getField('UPDATE_REASON').setReadOnly(false);	
								panelSearch.getField('UPDATE_REASON').allowBlank = false;
							}
						}
					},
					tdAttrs: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				},{
					fieldLabel	: '전송자',
					name		: 'SEND_NAME',
					xtype		: 'uniTextfield',	
					allowBlank	: false,
					labelWidth	: 113,
//					xtype		: 'uniCombobox',
//					store		: salePrsnStore,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
						}
					},
					tdAttrs		: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				}, {
					fieldLabel	: '전송자 이메일',
					name		: 'SEND_EMAIL',
					xtype		: 'uniTextfield',	
					allowBlank	: false,
//					labelWidth	: 110,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
						}
					},
					tdAttrs		: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				}, {	        	
		        	xtype		: 'component',
					width		: 10,
					tdAttrs		: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }				
		        }]
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 4
//					tableAttrs: {style: 'border : 1px solid #ced9e7;'/*,width: '100%'*/},
//					tdAttrs: {style: 'border : 1px solid #ced9e7;'}
				},
				items	: [
					Unilite.popup('DEPT', { 
					fieldLabel: '귀속부서', 
					labelWidth: 110,
					valueFieldWidth: 60,
				    textFieldWidth: 100,
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
					allowBlank: false,
					listerners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
						}
					}
					/*listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('WH_CODE',records[0]["WH_CODE"]);
								panelResult2.setValue('WH_CODE',records[0]["WH_CODE"]);
								panelResult2.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
								panelResult2.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult2.setValue('DEPT_CODE', '');
							panelResult2.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							} else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							} else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}*/
				}),{
					fieldLabel: '수정사유',
					name: 'UPDATE_REASON',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'S095',				
//					labelWidth: 110,
		            listeners:{
						change:function(field, eOpts)	{
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
							if(linkFlag) {
								linkFlag = false;
								return false;
								
							} else {
			              		if(Ext.isEmpty(field.getValue())){
			              			field.fireEvent('onClear');	
			              		} else {
			              			field.openPopup();
			              		}
							}
		              	},
		              	onSelected:function(record, type)	{
		              		masterGrid.reset();
							masterStore.clearData();
		              		record = record[0];
		              		panelSearch.down('#btnAccnt').setDisabled(true);
							panelSearch.down('#btnCancel').setDisabled(true);
		              		panelSearch.setValue('SALE_AMT_O', 0);										//금액
		              		panelSearch.setValue('TAX_AMT_O', 0);										//세액
		              		panelSearch.setAllFieldsReadOnly(false);
		              		panelSearch.setValue('CUSTOM_CODE', record.CUSTOM_CODE);					//거래처
		              		panelSearch.setValue('CUSTOM_NAME', record.CUSTOM_NAME);					//거래처명
		              		if(Ext.isEmpty(record.TAX_CALC_TYPE) || record.TAX_CALC_TYPE == "2"){
		              			CustomCodeInfo.gsTaxCalcType = '2';	              		
		              		} else {
		              			CustomCodeInfo.gsTaxCalcType = '1';
		              		}
//		              		CustomCodeInfo.gsCollectDay = record.COLLECT_DAY;	              		
//		              		UniAppManager.app.fnRcptDateCal(CustomCodeInfo.gsCollectDay);
		              		
		              		if(!Ext.isEmpty(record.COMPANY_NUM) && record.COMPANY_NUM.length == 10){	//사업자번호set
								rsComNum =  record.COMPANY_NUM;
								comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
								panelSearch.setValue('CUST_COM_NUM', comNum);
							} else {
								comNum = record.COMPANY_NUM;
								panelSearch.setValue('CUST_COM_NUM', comNum);
							}
							panelSearch.setValue('TOP_NAME', record.TOP_NAME);						//대표자
							panelSearch.setValue('ADDR', record.ADDR1 + record.ADDR2 );			//주소
							panelSearch.setValue('COMP_TYPE', record.COMP_TYPE);					//업태
							panelSearch.setValue('COMP_CLASS', record.COMP_CLASS);					//업종
							CustomCodeInfo.gsUnderCalBase = record.WON_CALC_BAS;						//원미만계산
							if(Ext.isEmpty(record.COLLECTOR_CP)){										//수금거래처
								CustomCodeInfo.gsCollector = record.CUSTOM_CODE;
							} else {
								CustomCodeInfo.gsCollector = record.COLLECTOR_CP;
							}

							panelSearch.setValue('WRITE_DATE', record.REG_DATE);						//작성일
							panelSearch.setValue('REMARK', record.REG_REMARK);							//비고
							if(record.BILL_TYPE == "11"){												//계산서유형
								panelSearch.getField('TAX_BILL').setValue('1');
							} else if(record.BILL_TYPE == "20"){
								panelSearch.getField('TAX_BILL').setValue('2');
							} else if(record.BILL_TYPE == "12"){
								panelSearch.getField('TAX_BILL').setValue('3');
							}
							panelSearch.setValue('SALE_DIV_CODE', record.SALE_DIV_CODE);
							gsDivCode = record.SALE_DIV_CODE;
							UniAppManager.app.fnRecordComBo();
							panelSearch.setValue('BILL_DIV_CODE', record.DIV_CODE);
							panelSearch.setValue('SEND_NAME'	, record.SEND_NAME);					//전송자
							panelSearch.setValue('BUSI_TYPE'	, record.BUSI_TYPE);					//거래유형
							panelSearch.setValue('PROOF_KIND'	, record.PROOF_KIND);					//증빙유형
							panelSearch.setValue('BF_ISSUE'		, record.ISSU_ID);						//당초승인번호

							panelSearch.setValue('SEND_NAME'		, record.SEND_NAME);				//전송 담당자
							panelSearch.setValue('SEND_EMAIL'		, record.SEND_EMAIL);			//전송 이메일
							panelSearch.setValue('PRSN_NAME'		, record.PRSN_NAME);				//받는 담당자
							panelSearch.setValue('PRSN_EMAIL'		, record.PRSN_EMAIL);			//받는 이메일
							panelSearch.setValue('PRSN_PHONE'		, record.PRSN_PHONE);			//받는 연락처
							panelSearch.setValue('PRSN_HANDPHONE'	, record.PRSN_HANDPHONE);		//받는 연락처
							panelSearch.setValue('SMS_CHECK'		, record.SMS_CHECK);		//받는 연락처
							
							var updateReason = panelSearch.getValue('UPDATE_REASON');
							switch(updateReason) {
								case "01" :
									panelSearch.getField('WRITE_DATE').setReadOnly(true);
//20161026 매출일 필드 삭제
//									panelSearch.setValue('FR_DATE', record.PUB_FR_DATE);
//									panelSearch.setValue('TO_DATE', record.PUB_TO_DATE);
									panelSearch.setValue('SALE_AMT_O', record.SALE_AMT_O);				//금액  
		              				panelSearch.setValue('TAX_AMT_O', record.TAX_AMT_O);					//세액
		              				sSaleAmt = record.SALE_AMT_O;
									sTaxAmt = record.TAX_AMT_O;
		              				amtForm.setValue('SALE_LOC_TOT_DIS', record.SALE_TOT_AMT);
		              				panelSearch.setAllFieldsReadOnly(true);
//									panelSearch.setValue('RECEIPT_PLAN_DATE', record.RECEIPT_PLAN_DATE);
//									panelSearch.getField('RECEIPT_PLAN_DATE').setReadOnly(true);
									panelSearch.down('#project').setReadOnly(true);
//									panelSearch.getField('SEND_NAME').setReadOnly(true);
									gsStatusM = "N"
									Ext.getCmp('labelText').setText('※ 매출내역 변동이 없으므로 내역 없이 수정발행 저장시 자동으로 2부 발행');
									UniAppManager.setToolbarButtons('newData', false);
									UniAppManager.setToolbarButtons('save', true);
									break;
								
								case "02" :	
									panelSearch.getField('WRITE_DATE').setReadOnly(false);
									Ext.getCmp('labelText').setText('※ 증감분에 대하여 수불 또는 매출부터 추가 등록 후 1부만 발행');
									UniAppManager.setToolbarButtons('newData', true);
									break;							
									
								case "03" :	
									panelSearch.getField('WRITE_DATE').setReadOnly(false);
									Ext.getCmp('labelText').setText('※ 환입된 금액분에 대하여 수불 또는 매출부터 추가 등록 후 1부만 발행');
									UniAppManager.setToolbarButtons('newData', true);
									break;
									
								case "04" :	
									panelSearch.getField('WRITE_DATE').setReadOnly(false);
//20161026 매출일 필드 삭제
//									panelSearch.setValue('FR_DATE', record.PUB_FR_DATE);
//									panelSearch.setValue('TO_DATE', record.PUB_TO_DATE);
									panelSearch.setValue('SALE_AMT_O', record.SALE_AMT_O);				//금액
		              				panelSearch.setValue('TAX_AMT_O', record.TAX_AMT_O);					//세액
		              				sSaleAmt = record.SALE_AMT_O;
									sTaxAmt = record.TAX_AMT_O;
		              				amtForm.setValue('SALE_LOC_TOT_DIS', record.SALE_TOT_AMT);
		              				panelSearch.setAllFieldsReadOnly(true);
//									panelSearch.getField('RECEIPT_PLAN_DATE').setReadOnly(true);
									panelSearch.down('#project').setReadOnly(true);
//									panelSearch.getField('SEND_NAME').setReadOnly(true);
									gsStatusM = "N"
									Ext.getCmp('labelText').setText('※ 부(-)의 세금계산서 1부만 발행');
									panelSearch.getField('WRITE_DATE').setReadOnly(false);
									UniAppManager.setToolbarButtons('newData', false);
									UniAppManager.setToolbarButtons('save', true);
									break;							
									
								case "05" :	
									panelSearch.getField('WRITE_DATE').setReadOnly(true);
//20161026 매출일 필드 삭제
//									panelSearch.setValue('FR_DATE', record.PUB_FR_DATE);
//									panelSearch.setValue('TO_DATE', record.PUB_TO_DATE);
									Ext.getCmp('labelText').setText('※ 부(-)의 세금계산서 1부unilite.msg.영세율 세금계산서 1부씩 발행');
									UniAppManager.setToolbarButtons('newData', true);
									break;							
									
								case "06" :	
									panelSearch.getField('WRITE_DATE').setReadOnly(false);
//20161026 매출일 필드 삭제
//									panelSearch.setValue('FR_DATE', record.PUB_FR_DATE);
//									panelSearch.setValue('TO_DATE', record.PUB_TO_DATE);
									panelSearch.setValue('SALE_AMT_O', record.SALE_AMT_O);				//금액
		              				panelSearch.setValue('TAX_AMT_O', record.TAX_AMT_O);					//세액
		              				sSaleAmt = record.SALE_AMT_O;
									sTaxAmt = record.TAX_AMT_O;
		              				amtForm.setValue('SALE_LOC_TOT_DIS', record.SALE_TOT_AMT);
		              				panelSearch.setAllFieldsReadOnly(false);
//									panelSearch.getField('RECEIPT_PLAN_DATE').setReadOnly(true);
									panelSearch.down('#project').setReadOnly(true);
//									panelSearch.getField('SEND_NAME').setReadOnly(true);
									gsStatusM = "N"
									Ext.getCmp('labelText').setText('※ 원 세금계산서의 반대 세금계산서 1부만 발행');
									UniAppManager.setToolbarButtons('newData', true);
									break;
							}
							amtForm.setConfig('readOnly', true);
							gsBeforePubNum = record.PUB_NUM;
							gsOriginalPubNum = record.ORIGINAL_PUB_NUM;
							UniAppManager.setToolbarButtons('deleteAll', true);
		              	},
		              	onclear:function(record, type)	{
		              	}
					},
						app: 'Unilite.app.popup.TaxBillSearchPopup',
						api: 'popupService.TaxBillSearchPopup',
						openPopup: function() {
	   			      		var me = this;
					        var param = {};	
					        param['TYPE'] 			= 'TEXT';   
					        param['pageTitle']		= me.pageTitle;
					        param['TABLE_NAME'] 	= 'ATX110T';
					        param['CUSTOM_CODE']	= panelSearch.getValue('CUSTOM_CODE');
					        param['CUSTOM_NAME']	= panelSearch.getValue('CUSTOM_NAME');
					        param['WRITE_DATE'] 	= UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'));
					        param['SALE_DIV_CODE']	= panelSearch.getValue('SALE_DIV_CODE');
					        param['UPDATE_REASON']	= panelSearch.getValue('UPDATE_REASON');
					        param['BILL_CONNECT']	= BsaCodeInfo.gsBillConnect;
					        param['BILL_DB_USER']	= BsaCodeInfo.gsBillDbUser;				        

					        if(me.app) { 
					     		var fn = function() {
					                var oWin =  Ext.WindowMgr.get(me.app);
					                if(!oWin) {
					                    oWin = Ext.create( me.app, {
					                            id: me.app, 
					                            callBackFn: me.processResult, 
					                            callBackScope: me, 
					                            popupType: 'TEXT',
					                            width: 750,
					                            height:450,
					                            title: '원본세금계산서 검색',
					                            param: param
					                     });
					                }
					                oWin.fnInitBinding(param);
					                oWin.center();
					                oWin.show();
						    	}
					     	}
					     Unilite.require(me.app, fn, this, true);
				    },
				    processResult: function(result, type) {
				        var me = this, rv;
				        console.log("Result: ", result);
				        if(result){
				        	if(Ext.isDefined(result) && result.status == 'OK') {
				            me.fireEvent('onSelected', result.data); 
				        	}
				        } else {
							panelSearch.setValue('UPDATE_REASON', '');
							panelSearch.setValue('REMARK', '');
						}
					}
//				},{
//					fieldLabel	: '받는 담당자',
//					name		: 'PRSN_NAME',
//					xtype		: 'uniTextfield',
////					xtype		: 'uniCombobox',
////					comboType	: 'AU',			CUST_BILL_PRSN_SINGLE
////					comboCode	: 'S095',				
//					labelWidth	: 113,	
//					allowBlank	: false,
//					listeners	: {
//						change: function(field, newValue, oldValue, eOpts) {						
//							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
//								gsSaveRefFlag = "Y";
//							}
//						}
//					}
				},					
				Unilite.popup('CUST_BILL_PRSN_SINGLE', { 
					fieldLabel: '담당자', 
					valueFieldName: 'SEQ',
			   	 	textFieldName: 'PRSN_NAME',
					allowBlank: false,
					validateBlank:false,
					autoPopup:false,
					labelWidth: 113,
				    textFieldWidth: 149,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('PRSN_NAME'		, Ext.isEmpty(records[0]["PRSN_NAME"])		? '' : records[0]["PRSN_NAME"]);				//공급받는 자 명
								panelSearch.setValue('PRSN_EMAIL'		, Ext.isEmpty(records[0]["MAIL_ID"])		? '' : records[0]["MAIL_ID"]);			//공급받는 자 이메일
								panelSearch.setValue('PRSN_PHONE'		, Ext.isEmpty(records[0]["TELEPHONE_NUM1"])	? '' : records[0]["TELEPHONE_NUM1"]);			//공급받는 자 연락처
								panelSearch.setValue('PRSN_HANDPHONE'	, Ext.isEmpty(records[0]["HAND_PHON"]) 		? '' : records[0]["HAND_PHON"]);			//공급받는 자 핸드폰 번호

		                     },
							scope: this
						},
						change: function(field, newValue, oldValue, eOpts) {
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
						},
						applyextparam: function(popup){
							if(!Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))) {
								popup.setExtParam({'ADD_QUERY': 'A.CUSTOM_CODE =' + "'"+panelSearch.getValue('CUSTOM_CODE')+"'"});			//WHERE절 추가 쿼리
							}else{
								popup.setExtParam({'ADD_QUERY': 'A.CUSTOM_CODE = NULL'});			//WHERE절 추가 쿼리
							}
						},
						onTextFieldChange: function(field, newValue){
							if (Ext.isEmpty(newValue)) {
							}
						}
					}
				}),{
					fieldLabel	: '받는 이메일',
					name		: 'PRSN_EMAIL',
					xtype		: 'uniTextfield',	
					allowBlank	: false,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
						}
					}
//					readOnly: true
				},{
					fieldLabel	: '거래유형',
					name		: 'BUSI_TYPE',
					id			: 'BUSI_TYPE',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'A012',	
					labelWidth	: 110,
					allowBlank	: false,
					listeners	: {
						change	: function(combo, newValue, oldValue, eOpts) {
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}

//							fnSetPropertiesbyProofKind();
						}
					}
				},{
					fieldLabel	: '증빙유형',
					name		: 'PROOF_KIND',
					id			: 'PROOF_KIND',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'A022',	
					allowBlank	: false,
					listeners	: {
						beforequery:function(queryPlan, eOpts)	{
							var store = queryPlan.combo.store;
							store.filter('refCode3', '2');
						},
						change: function(field, newValue, oldValue, eOpts) {						
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
							
							var store			= Ext.StoreManager.lookup("CBS_AU_A022");
							var selRecordIdx	= store.findBy(function(record){return (record.get("value") == newValue)});
							var selRecord		= store.getAt(selRecordIdx);
							//선택된 값에 따라 과세구분 변경
							if (!Ext.isEmpty(selRecord)) {
								if (selRecord.data.refCode1+selRecord.data.refCode2 == 'A0' ||
									selRecord.data.refCode1+selRecord.data.refCode2 == 'D0') {
									panelSearch.getField('TAX_BILL').setValue('3')
									
								} else if (selRecord.data.refCode1+selRecord.data.refCode2 == 'B0') {
									panelSearch.getField('TAX_BILL').setValue('2')
								
								} else {
									panelSearch.getField('TAX_BILL').setValue('1')
								}
							}
							//변경된 값 확인
//							var test =Ext.getCmp('rdoTaxType0').getChecked()[0].inputValue;
//							alert('test= '+test)
						}
					}
				},{
					fieldLabel	: '받는 연락처',
					name		: 'PRSN_PHONE',
					xtype		: 'uniTextfield',			
//					allowBlank	: false,
					labelWidth	: 113,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
							if(isNaN(newValue)){
								Ext.Msg.alert('확인','숫자만 입력가능합니다.');
								panelSearch.setValue('PRSN_PHONE','');
							}
						}
					}
//					readOnly: true
				},{
					fieldLabel	: '받는 핸드폰',
					name		: 'PRSN_HANDPHONE',
					xtype		: 'uniTextfield',	
					allowBlank	: true,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
							if(isNaN(newValue)){
								Ext.Msg.alert('확인','숫자만 입력가능합니다.');
								panelSearch.setValue('PRSN_HANDPHONE','');
							}
						}
					}
//					readOnly: true
				},{
				    xtype		: 'radiogroup',	
			    	id			: 'rdoTaxType0',		
//				    holdable	: 'hold',
				    hidden		: true,
				    fieldLabel	: '과세구분',	
				    items		: [{
				    	boxLabel	: '과세',
				    	name		: 'TAX_BILL' ,
				    	inputValue	: '1',
				    	id			: 'rdoTaxType1',
				    	width		: 45
				    }, {boxLabel	: '면세',
				    	name		: 'TAX_BILL',
				    	inputValue	: '2',
				    	id			: 'rdoTaxType2',
				    	width		: 45
				    }, {boxLabel	: '영세율',
				    	name		: 'TAX_BILL',
				    	id			: 'rdoTaxType3',
				    	inputValue	: '3',
				    	width		: 65
				    }],
//					tdAttrs: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  },
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							var records = masterStore.data.items;
				        	Ext.each(records, function(record,i){
								if(panelSearch.getField('TAX_BILL').getValue('1')){
									record.set('TAX_AMT_O', Math.floor(record.get('SALE_AMT_O') / 10));
								} else {
									record.set('TAX_AMT_O',0);
								}
				        	});
						}
					}
				},{
					fieldLabel	: '전송상태', 
					name		: 'BILL_SEND_YN', 
					xtype		: 'uniCombobox',
					comboType	: 'AU', 
					comboCode	: 'B087',
					readOnly	: true,
					value		: '',
					width		: 240,	
					labelWidth	: 110,
					listeners:{
					}
				},{
					fieldLabel	: '오류메세지',
					xtype		: 'uniTextfield',
					name		: 'ERR_MSG',
					colspan		: 2,
					width		: 514,
					readOnly	: true
				},{
					xtype: 'container',
					layout	: {type : 'uniTable', columns : 2},
					items:[{	            		
			    		fieldLabel	: 'SMS전송',
			    		xtype		: 'uniCheckboxgroup',	
			    		items		: [{
			    			boxLabel	: '',
			    			width		: 10,
			    			name		: 'SMS_CHECK',
			    			inputValue	: 'Y',
			    			uncheckedValue: 'N'
			    		}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
									gsSaveRefFlag = "Y";
								}
								if (newValue.SMS_CHECK == 'Y') {
									panelSearch.getField('PRSN_HANDPHONE').setConfig('allowBlank', false);
	
								} else {
									panelSearch.getField('PRSN_HANDPHONE').setConfig('allowBlank', true);
								}
							}
						}
			        },{	            		
			    		fieldLabel	: '생성경로',
						xtype		: 'uniTextfield',
						name		: 'INPUT_PATH',
						labelWidth	: 70,
						width		:130,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))){
									gsSaveRefFlag = "Y";
								}
							}
						}
			        }]				
				}/*,{	            		
		    		fieldLabel	: 'SMS전송',
		    		xtype		: 'uniCheckboxgroup',	
		    		items		: [{
		    			boxLabel	: '',
		    			width		: 150,
		    			name		: 'SMS_CHECK',
		    			inputValue	: 'Y',
		    			uncheckedValue: 'N'
		    		}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if (newValue.SMS_CHECK == 'Y') {
								panelSearch.getField('PRSN_HANDPHONE').setConfig('allowBlank', false);

							} else {
								panelSearch.getField('PRSN_HANDPHONE').setConfig('allowBlank', true);
							}
						}
					}
		        }*/,{
					xtype: 'container',
					colspan:6,
					items:[{
						xtype	: 'label',
						name	: ' ',
						id		: 'labelText',					
						border	: false,
						margin	: '0 0 0 10',
						text	: '',
						width	: 550,
						style	: {
							color: 'red'				
						}
					}]				
				}]
			}]
    	}],	
		api: {
			submit: 'atx110ukrService.syncForm'				
		},
		listeners: {
	        uniOnChange: function(basicForm, dirty, eOpts) {
	        	if(UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
		        	if(gsSaveRefFlag == "Y" && basicForm.isDirty()) {
	                    UniAppManager.setToolbarButtons('save', true);
	                    
	                } else {
	                    UniAppManager.setToolbarButtons('save', false);
	                }
	        	}
			}
		 },
   		openCryptRepreNoPopup:function(  )	{
			var record = this;
			var params = {'REPRE_NO':this.getValue('TOP_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'N'};
			Unilite.popupCipherComm('form', record, 'CUST_TOP_NUM', 'TOP_NUM', params);				
		},
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
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
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
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
  		},
  		setLoadRecord: function()	{
			var me = this;			
			me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});

	var addSearch = Unilite.createSearchForm('atx110ukrAddSearch', {													//수탁사업자 부분
        region		: 'east',
        autoScroll	: true,
    	border		: true,
    	padding		: '1 1 1 0',
        flex		: 2.3,
	    layout		: {type: 'uniTable' , columns: 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
//		hidden		: true,
//      width		: 530,
//		collapsed	: true,
        listeners: {
	        collapse: function () {
	        },
	        expand: function() {
	        }
	    },
		items: [{
			xtype	: 'component',
			height	: 75,
			colspan	: 3
		},{
			xtype	: 'component',
			width	: 10
		},{
			title	: '수탁사업자',
			padding	: '0 10 10 10',
			margin	: '0 0 0 0',
        	xtype	: 'fieldset',
        	id		: 'fieldset3',
			colspan	: 2,
 		    defaults: {readOnly: true, xtype: 'uniTextfield'},
 		    layout	: {type: 'uniTable' , columns: 2},
        	items	: [{
				fieldLabel: '등록번호',
				name:'BROK_CUST_COM_NUM'
			},
				Unilite.popup('AGENT_CUST_SINGLE2',{	
				fieldLabel: '고객코드',
				validateBlank: false,
				textFieldName:'BROK_CUSTOM_CODE',
				DBtextFieldName: 'CUSTOM_CODE',
				readOnly: false,
   				extParam	: {'CUSTOM_TYPE': ['1','3']},  
				holdable: 'hold',
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'SINGLE_CODE': true});							
					},
					onSelected: {
						fn: function(records, type) {
							 addSearch.setValue('BROK_CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
							 if(Ext.isEmpty(records[0]["TAX_CALC_TYPE"]) ||  records[0]["TAX_CALC_TYPE"] == "2"){
//							 	CustomCodeInfo.gsTaxCalcType = "2";
							 } else {
//							 	CustomCodeInfo.gsTaxCalcType = "1";
							 }
							
							if(!Ext.isEmpty(records[0]["COMPANY_NUM"]) && records[0]["COMPANY_NUM"].length == 10){	//사업자번호
								rsComNum =  records[0]["COMPANY_NUM"];
								comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
								addSearch.setValue('BROK_CUST_COM_NUM', comNum);
							} else {
								comNum = records[0]["COMPANY_NUM"];
								addSearch.setValue('BROK_CUST_COM_NUM', comNum);
							}
							
							addSearch.setValue('BROK_CUST_TOP_NAME', records[0]["TOP_NAME"]);	//대표자
							addSearch.setValue('BROK_CUST_ADDRESS', records[0]["ADDR1"] + ' ' + records[0]["ADDR2"]);	//주소
							addSearch.setValue('BROK_CUST_COMP_TYPE', records[0]["COMP_TYPE"]);	//업태
							addSearch.setValue('BROK_CUST_COMP_CLASS', records[0]["COMP_CLASS"]);	//업종
							addSearch.setValue('BROK_CUST_SERVANT_NUM', records[0]["SERVANT_COMPANY_NUM"]);	//종사업장번호
							
//							CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"]	//원미계산
							if(Ext.isEmpty(records[0]["COLLECTOR_CP"])){//수금거래처
//								CustomCodeInfo.gsCollector = records[0]["CUSTOM_CODE"];
							} else {
//								CustomCodeInfo.gsCollector = records[0]["COLLECTOR_CP"];
							}

							if(Ext.isEmpty(records[0]["BILL_DIV_CODE"])){
//								CustomCodeInfo.gsBillDivChgYN = 'N'
								UniAppManager.app.fnRecordComBo();	//신고사업장 가져오기
							} else {
//								CustomCodeInfo.gsBillDivChgYN = 'Y'
								addSearch.setValue('BROK_BILL_DIV_CODE', records[0]["BILL_DIV_CODE"]);
								UniAppManager.app.billDivCode_onChange();									
							}
							addSearch.setValue('BROK_PRSN_NAME', records[0]["PRSN_NAME"]);				//공급받는 자 명
							addSearch.setValue('BROK_PRSN_EMAIL', records[0]["PRSN_EMAIL"]);			//공급받는 자 이메일
							addSearch.setValue('BROK_PRSN_PHONE', records[0]["PRSN_HANDPHONE"]);			//공급받는 자 핸드폰 번호

	                     },
					scope: this
					},
					onClear: function(type)	{		////onClear가 먹지 않음
						addSearch.setValue('BROK_CUSTOM_NAME', '');								
					},
					onTextFieldChange: function(field, newValue){
						if (Ext.isEmpty(newValue)) {
							addSearch.setValue('BROK_CUSTOM_NAME'		, '')
							addSearch.setValue('BROK_CUST_TOP_NAME'		, '')	//대표자
							addSearch.setValue('BROK_CUST_ADDRESS'		, '')	//주소
							addSearch.setValue('BROK_CUST_COMP_TYPE'	, '')	//업태
							addSearch.setValue('BROK_CUST_COMP_CLASS'	, '')	//업종
							addSearch.setValue('BROK_CUST_SERVANT_NUM'	, '')	//종사업장번호
							addSearch.setValue('BROK_CUST_COM_NUM'		, '')
							addSearch.setValue('BROK_PRSN_NAME'			, '')	//공급받는 자 명
							addSearch.setValue('BROK_PRSN_EMAIL'		, '')	//공급받는 자 이메일
							addSearch.setValue('BROK_PRSN_PHONE'		, '')
						}
					}
				}				
			}),
				Unilite.popup('AGENT_CUST_SINGLE2',{	
				fieldLabel: '상호(법인명)',
				validateBlank: false,
				textFieldName:'BROK_CUSTOM_NAME',
				DBtextFieldName: 'CUSTOM_NAME',
				readOnly: false,
				holdable: 'hold',
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'SINGLE_CODE': false});							
					},
					onSelected: {
						fn: function(records, type) {
							 addSearch.setValue('BROK_CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
							 if(Ext.isEmpty(records[0]["TAX_CALC_TYPE"]) ||  records[0]["TAX_CALC_TYPE"] == "2"){
//							 	CustomCodeInfo.gsTaxCalcType = "2";
							 } else {
//							 	CustomCodeInfo.gsTaxCalcType = "1";
							 }
							
							if(!Ext.isEmpty(records[0]["COMPANY_NUM"]) && records[0]["COMPANY_NUM"].length == 10){		//사업자번호
								rsComNum =  records[0]["COMPANY_NUM"];
								comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
								addSearch.setValue('BROK_CUST_COM_NUM', comNum);
							} else {
								comNum = records[0]["COMPANY_NUM"];
								addSearch.setValue('BROK_CUST_COM_NUM', comNum);
							}
							
							addSearch.setValue('BROK_CUST_TOP_NAME', records[0]["TOP_NAME"]);							//대표자
							addSearch.setValue('BROK_CUST_ADDRESS', records[0]["ADDR1"] + ' ' + records[0]["ADDR2"]);	//주소
							addSearch.setValue('BROK_CUST_COMP_TYPE', records[0]["COMP_TYPE"]);							//업태
							addSearch.setValue('BROK_CUST_COMP_CLASS', records[0]["COMP_CLASS"]);						//업종
							addSearch.setValue('BROK_CUST_SERVANT_NUM', records[0]["SERVANT_COMPANY_NUM"]);				//종사업장번호
							
							CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"]									//원미계산
							if(Ext.isEmpty(records[0]["COLLECTOR_CP"])){//수금거래처
//								CustomCodeInfo.gsCollector = records[0]["CUSTOM_CODE"];
							} else {
//								CustomCodeInfo.gsCollector = records[0]["COLLECTOR_CP"];
							}
							if(Ext.isEmpty(records[0]["BILL_DIV_CODE"])){
//								CustomCodeInfo.gsBillDivChgYN = 'N'
								UniAppManager.app.fnRecordComBo();	//신고사업장 가져오기
							} else {
//								CustomCodeInfo.gsBillDivChgYN = 'Y'
								addSearch.setValue('BROK_BILL_DIV_CODE', records[0]["BILL_DIV_CODE"]);
								UniAppManager.app.billDivCode_onChange();									
							}
							addSearch.setValue('BROK_PRSN_NAME', records[0]["PRSN_NAME"]);				//공급받는 자 명
							addSearch.setValue('BROK_PRSN_EMAIL', records[0]["PRSN_EMAIL"]);			//공급받는 자 이메일
							addSearch.setValue('BROK_PRSN_PHONE', records[0]["PRSN_PHONE"]);			//공급받는 자 핸드폰 번호

	                     },
					scope: this
					},
					onClear: function(type)	{		////onClear가 먹지 않음
						addSearch.setValue('BROK_CUSTOM_CODE', '');								
					},
					onTextFieldChange: function(field, newValue){
						if (Ext.isEmpty(newValue)) {
							addSearch.setValue('BROK_CUSTOM_NAME'		, '')
							addSearch.setValue('BROK_CUST_TOP_NAME'		, '')	//대표자
							addSearch.setValue('BROK_CUST_ADDRESS'		, '')	//주소
							addSearch.setValue('BROK_CUST_COMP_TYPE'	, '')	//업태
							addSearch.setValue('BROK_CUST_COMP_CLASS'	, '')	//업종
							addSearch.setValue('BROK_CUST_SERVANT_NUM'	, '')	//종사업장번호
							addSearch.setValue('BROK_CUST_COM_NUM'		, '')
							addSearch.setValue('BROK_PRSN_NAME'			, '')	//공급받는 자 명
							addSearch.setValue('BROK_PRSN_EMAIL'		, '')	//공급받는 자 이메일
							addSearch.setValue('BROK_PRSN_PHONE'		, '')
						}
					}
				}				
			}),{
				fieldLabel: '성명(대표자)',
				name:'BROK_CUST_TOP_NAME' 	
			}, {
				fieldLabel: '사업장주소',
				name:'BROK_CUST_ADDRESS', 	
				width: 490, 	
				colspan: 2
			}, {
				fieldLabel: '업태',
				name:'BROK_CUST_COMP_TYPE' 	
			}, {
				fieldLabel: '종목',
				name:'BROK_CUST_COMP_CLASS' 	
			}, {
				fieldLabel: '종사업자번호',
				name:'BROK_CUST_SERVANT_NUM'	
			}]
		},{
			xtype	: 'component',
			width	: 10
		},{
			fieldLabel	: '수탁 담당자',
			name		: 'BROK_PRSN_NAME',			
			labelWidth	: 100,
			xtype		: 'uniTextfield',
            listeners	: {
            }
		},{
			fieldLabel	: '수탁 이메일',
			name		: 'BROK_PRSN_EMAIL',
			xtype		: 'uniTextfield'
		},{
			xtype	: 'component',
			width	: 10
		},{
			fieldLabel	: '수탁 연락처',
			name		: 'BROK_PRSN_PHONE',
			xtype		: 'uniTextfield',		
			labelWidth	: 100
		}]
	});	
	
	var amtForm = Unilite.createSearchForm('atx110ukrAmtForm',{															//합계폼
    	region	: 'center',
//    	flex:1,
		layout	: {type : 'uniTable'},
		padding	: '1 1 1 1',
		height	: 70,
		border	: true,
		defaults: {xtype: 'uniNumberfield', width: 120, labelAlign: 'top', readOnly: true, margin: '5 10 0 10'/*, labelStyle: 'text-align: center;'*/},
		items	: [{
			fieldLabel: '합계금액',
			name:'SALE_LOC_TOT_DIS'
		},{
			xtype: 'component',
			width: 35			
		},{
			fieldLabel: '현금',
			name:'' 				
		},{
			xtype: 'component',
			width: 35			
		},{
			fieldLabel: '수표',
			name:'' 				
		},{
			xtype: 'component',
			width: 35			
		},{
			fieldLabel: '어음',
			name:'' 				
		},{
			xtype: 'component',
			width: 35			
		},{
			fieldLabel: '외상미수금',
			name:'' 				
		},{
			xtype: 'component',
			width: 35			
		},{
			xtype: 'component',
			html: '이   금액을',
			width: 90
		},{
			xtype: 'radiogroup',
			layout: {/*type: 'uniTable', */columns: 1},
			name: 'RDO_CLAIM_YN',	
			id : 'billGubun',
			items:[{
				xtype: 'radiofield',
				boxLabel: '영수',
				name: 'CLAIM_YN',
				inputValue: '1',
				width: 70,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(gsStatusM != 'N') {							//확인해야하는 부분
							gsStatusM = 'U';
						}
						UniAppManager.setToolbarButtons('save', true);
//						alert('dddd');
					}
				}
//				id: 'rdoIn'
			},{
				xtype: 'radiofield',
				boxLabel: '청구 함.',
				name: 'CLAIM_YN',
				inputValue: '2',
				width: 90,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(gsStatusM != 'N') {							//확인해야하는 부분
							gsStatusM = 'U';
						}
						UniAppManager.setToolbarButtons('save', true);
//						alert('dddd');
					}
				}
			}]
		}],
  		setLoadRecord: function()	{
			var me = this;			
			me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});

	
	/**
	 * 수주의 디테일 정보를 가지고 있는 Grid
	 */
	//마스터 모델 정의
	Unilite.defineModel('atx110ukrDetailModel', {
	    fields: [
	    	{name: 'COMP_CODE'					,text: '법인코드'			,type: 'string'  },
	    	{name: 'DIV_CODE'					,text: '사업장코드'			,type: 'string'  },
	    	{name: 'SEQ'						,text: '순번'				,type: 'int'	 },
	    	{name: 'PUB_NUM'					,text: '세금계산서번호'		,type: 'string'  },
	    	{name: 'REMARK'						,text: '적요'				,type: 'string'  },
	    	{name: 'SALE_LOC_AMT_I'				,text: '환산금액'			,type: 'uniPrice'},
	    	{name: 'SALE_AMT_O'					,text: '공급가액'			,type: 'uniPrice'},
	    	{name: 'TAX_AMT_O'					,text: '세액'				,type: 'uniPrice'},
	    	{name: 'CUSTOM_CODE'				,text: '고객코드'			,type: 'string'  },
	    	{name: 'PROJECT_NO'					,text: '관리번호'			,type: 'string'  },
	    	{name: 'SALE_PROFIT'				,text: '사업부'			,type: 'string'  },
	    	{name: 'SALE_DIV_CODE'				,text: '매출사업장'			,type: 'string'  },
	    	{name: 'EX_DATE'					,text: '결의전표일'			,type: 'uniDate' },
	    	{name: 'EX_NUM'						,text: '결의전표번호'		,type: 'int'     },
	    	{name: 'AC_DATE'					,text: '회계전표일'			,type: 'uniDate' },
	    	{name: 'AC_NUM'						,text: '회계전표번호'		,type: 'string'  },
	    	{name: 'AGREE_YN'					,text: '승인여부'			,type: 'string'  },
	    	{name: 'CLOSING_YN'					,text: '마감여부'			,type: 'string'  },
	    	{name: 'BIGO'						,text: '비고'				,type: 'string'  }
	    ]
	});

	//임시저장 store
	var tempStore = Unilite.createStore('atx110ukrTempStore',{
		uniOpt : {
        	isMaster	: false,		// 상위 버튼 연결 
        	editable	: false,		// 수정 모드 사용 
        	deletable	: false,		// 삭제 가능 여부 
            useNavi		: false			// prev | newxt 버튼 사용
        }
	})

	//마스터 스토어 정의
	var masterStore = Unilite.createStore('atx110ukrmasterStore', {
		model	: 'atx110ukrDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy	: directProxy,
		loadStoreRecords: function() {
			var param = {
	      		BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE'),
	      		PUB_NUM : 		panelSearch.getValue('PUB_NUM')
          	}			
			this.load({
				params : param,
				callback : function(records, options, success)	{
					if(success)	{
						panelSearch.setLoadRecord();
						//조회되었을 때, EX_DATE가 있으면 "매출기표" 활성화, 없으면 "기표취소" 활성화
						if (Ext.isEmpty(panelSearch.getValue('EX_DATE'))){
				      		panelSearch.down('#btnAccnt').setDisabled(false);
				      		panelSearch.down('#btnCancel').setDisabled(true);
						} else {
							panelSearch.down('#btnAccnt').setDisabled(true);
				      		panelSearch.down('#btnCancel').setDisabled(false);
						}
						if (!Ext.isEmpty(records)) {
							if (records[0].data.BILL_PUBLISH_TYPE == '3') {				//위수탁 발행일 경우, 해당 패널 SHOW {
								popupService.agentCustPopup({CUSTOM_NAME : records[0].data.BROK_CUSTOM_CODE}, function(provider, response)	{
									addSearch.setValue('BROK_CUST_COM_NUM'		, provider[0].COMPANY_NUM);
									addSearch.setValue('BROK_CUSTOM_NAME'		, provider[0].CUSTOM_NAME);
									addSearch.setValue('BROK_CUST_TOP_NAME'		, provider[0].TOP_NAME);
									addSearch.setValue('BROK_CUST_ADDRESS'		, provider[0].ADDR1 + provider[0].ADDR2);
									addSearch.setValue('BROK_CUST_COMP_CLASS'	, provider[0].COMP_CLASS);			//업종
									addSearch.setValue('BROK_CUST_COMP_TYPE'	, provider[0].COMP_TYPE);			//업태
									addSearch.setValue('BROK_CUST_SERVANT_NUM'	, provider[0].SERVANT_COMPANY_NUM);
								});
							}
						}
					}
				}
			});
		},
		saveStore: function() {	
			var inValidRecs = this.getInvalidRecords();			
			var paramMaster = {};
			if(!masterStore.isDirty())	{
				//수정발행 (기재사항 착오/수정) 일 경우는 저장로직 다르게 한다.
				if(panelSearch.getValue('BILL_TYPE') == "2" && panelSearch.getValue('UPDATE_REASON') == "01"){	//수정발행, 기제사항착오
					UniAppManager.app.fnModifyUpdatechange();
					return false;

				//수정, 정상발행 마스터만 저장할 때..
				} else {	 
/*					//SP에서 처리되어 주석 처리(필요시 주석 제거)
					if(!UniAppManager.app.fnGetBillSendUseYNChk()){
						if(!UniAppManager.app.fnGetBillSendCloseChk()){
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.fstMsgS0079 + "\n" + Msg.fstMsgS0080 + "\n" +  Msg.fstMsgS0081,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	console.log(res);
							     	if (res === 'yes' ) {
		//					     		me.onSaveAndResetButtonDown();
							     		
							     	} else if(res === 'no') {
							     		UniAppManager.app.onQueryButtonDown();
							     	}
							     }
							});				
						}
					}*/
					if (gsStatusM == 'D') {
						var dtotTaxI = Ext.isNumeric(tempStore.sum('TAX_AMT_O')) ? tempStore.sum('TAX_AMT_O') : 0;
					} else {
						var dtotTaxI = Ext.isNumeric(masterStore.sum('TAX_AMT_O')) ? masterStore.sum('TAX_AMT_O') : 0;
					}
					if(dtotTaxI != sTaxAmt){
						alert(Msg.sMS444 + "\n" + Msg.sMSR298 + ": " + sTaxAmt + "\n" + Msg.sMSR299 + ": " + dtotTaxI);
						UniAppManager.app.onQueryButtonDown();
						return false;
					}
					
					paramMaster = UniAppManager.app.fnGetParamMaster();
					UniAppManager.app.fnMasterSave(paramMaster);
				}

			//정상발행 마스터 디테일 모두 저장시..
			} else {			
/*				//SP에서 처리되어 주석 처리(필요시 주석 제거)
				if(!UniAppManager.app.fnGetBillSendUseYNChk()){
					if(!UniAppManager.app.fnGetBillSendCloseChk()){
							Ext.Msg.show({
								title:'확인',
								msg: Msg.fstMsgS0079 + "\n" + Msg.fstMsgS0080 + "\n" +  Msg.fstMsgS0081,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									console.log(res);
									if (res === 'yes' ) {
		//					     		me.onSaveAndResetButtonDown();
							     	} else if(res === 'no') {
							     		UniAppManager.app.onQueryButtonDown();
							     	}
							     }
							});				
			
					} else {
						alert (Msg.fsbMsgS0217);
						return false;
					}
				}
*/			
				if (gsStatusM == 'D') {
					var dtotTaxI = Ext.isNumeric(tempStore.sum('TAX_AMT_O')) ? tempStore.sum('TAX_AMT_O') : 0;
				} else {
					var dtotTaxI = Ext.isNumeric(masterStore.sum('TAX_AMT_O')) ? masterStore.sum('TAX_AMT_O') : 0;
				}
				if(dtotTaxI != sTaxAmt){
					alert(Msg.sMS444 + "\n" + Msg.sMSR298 + ": " + sTaxAmt + "\n" + Msg.sMSR299 + ": " + dtotTaxI);
					UniAppManager.app.onQueryButtonDown();
					return false;
				}
				
				paramMaster = UniAppManager.app.fnGetParamMaster();
				paramMaster.MODE = 'update'

				if(inValidRecs.length == 0) {				
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								//2.마스터 정보(Server 측 처리 시 가공)
								var master = batch.operations[0].getResultSet();
								panelSearch.setValue("PUB_NUM", master.PUB_NUM);
								
								//3.기타 처리
								panelSearch.getForm().wasDirty = false;
								panelSearch.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);
								
								//전자세금계산서 관련 버튼 세팅
								if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))) {
									if (panelSearch.getValue('BILL_SEND_YN') == 'Y') {
										Ext.getCmp('btnEtax').setDisabled(true);
										Ext.getCmp('btnViewEtax').setDisabled(false);
										
									} else {
										Ext.getCmp('btnEtax').setDisabled(false);
										Ext.getCmp('btnViewEtax').setDisabled(true);
									}
								}
								//전체삭제할 경우 폼 리셋
								if (gsStatusM == 'D') {
									UniAppManager.app.onResetButtonDown();
								}
								if(Ext.isEmpty(panelSearch.getValue('EX_DATE')))	{
									panelSearch.down('#btnAccnt').setDisabled(false);
									panelSearch.down('#btnCancel').setDisabled(true);
								} else {
									panelSearch.down('#btnAccnt').setDisabled(true);
									panelSearch.down('#btnCancel').setDisabled(false);
								}
							 } ,
	
		                     failure: function(reponse) {	//안 먹음
		                     	UniAppManager.app.onQueryButtonDown();
		                     }
					};
					this.syncAllDirect(config);
					
				} else {                
	                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}	
			tempStore.clearData();
			gsSaveRefFlag = 'N';
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(records.length == 0) {
           			//수정세금계산서 기재사항 착오/수정의 경우, 전체삭제 버튼 활성화
           			if (panelSearch.getValue('BILL_TYPE') == '2' && panelSearch.getValue('UPDATE_REASON') == '01'){
           				UniAppManager.setToolbarButtons('deleteAll', true);
           				gsStatusM = 'Q';
           			
           			} else {
           				this.fnOrderAmtSum();
           				UniAppManager.setToolbarButtons('deleteAll', false);
       				}

       			//조회된 데이터가 있을 경우, 전체삭제 버튼 활성화
           		} else if(records.length > 0) {
           			this.fnOrderAmtSum();
           			gsStatusM = 'Q';
           			UniAppManager.setToolbarButtons('deleteAll', true);
					panelSearch.getField('PUB_NUM').setReadOnly(true);	
       			}
				gsSaveRefFlag = 'N';
           	},
           	add: function(store, records, index, eOpts) {
           		
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		this.fnOrderAmtSum();
           	},
           	remove: function(store, record, index, isMove, eOpts) {
				
           	}
		},
		
		fnMasterSet: function(provider) {
			if(Ext.isEmpty(provider)) {
				return false;
			}
			panelSearch.setValue('PUB_NUM', provider.PUB_NUM);
			panelSearch.setValue('SALE_DIV_CODE', provider.SALE_DIV_CODE);
//20161026 매출일 필드 삭제
//			panelSearch.setValue('FR_DATE', provider.PUB_FR_DATE);
//			panelSearch.setValue('TO_DATE', provider.PUB_TO_DATE);
			
			if(!Ext.isEmpty(provider.OWN_COMNUM) && provider.OWN_COMNUM.length == 10){		//좌측 등록번호 set
				rsComNum =  provider.OWN_COMNUM;
				comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
				panelSearch.setValue('OWN_COM_NUM', comNum);
			} else {
				comNum = provider.OWN_COMNUM;
				panelSearch.setValue('OWN_COM_NUM', comNum);
			}			
			panelSearch.setValue('OWN_TOP_NAME', provider.OWN_TOPNAME );
			panelSearch.setValue('OWN_ADDRESS', provider.OWN_ADDR );
			panelSearch.setValue('OWN_COMP_CLASS', provider.OWN_COMCLASS);
			panelSearch.setValue('OWN_COMP_TYPE', provider.OWN_COMTYPE);
			panelSearch.setValue('OWN_SERVANT_NUM', provider.OWN_SERVANTNUM);
			panelSearch.setValue('CUSTOM_CODE', provider.CUSTOM_CODE);
			panelSearch.setValue('CUSTOM_NAME', provider.CUSTOM_NAME);
			
			if(!Ext.isEmpty(provider.CUST_COMNUM) && provider.CUST_COMNUM.length == 10){		//우측 등록번호 set
				rsComNum =  provider.CUST_COMNUM;
				comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
				panelSearch.setValue('CUST_COM_NUM', comNum);
			} else {
				comNum = provider.CUST_COMNUM;
				panelSearch.setValue('CUST_COM_NUM', comNum);
			}
			panelSearch.setValue('TOP_NAME'			, provider.CUST_TOPNAME);
			panelSearch.setValue('ADDR'				, provider.CUST_ADDR);
			panelSearch.setValue('COMP_CLASS'		, provider.CUST_COMCLASS);
			panelSearch.setValue('COMP_TYPE'		, provider.CUST_COMTYPE);
			panelSearch.setValue('CUST_SERVANT_NUM'	, provider.CUST_SERVANTNUM);
			panelSearch.setValue('BF_ISSUE'			, provider.BFO_ISSU_ID);			
			
			UniAppManager.app.fnRecordComBo();
			panelSearch.setValue('BILL_DIV_CODE', provider.DIV_CODE);
			panelSearch.setValue('BILL_TYPE', provider.BILL_FLAG);
			panelSearch.setValue('SEND_NAME', provider.SEND_NAME);
			panelSearch.setValue('SEND_EMAIL', provider.SEND_EMAIL);
			panelSearch.setValue('PRSN_NAME', provider.PRSN_NAME);
			panelSearch.setValue('PRSN_EMAIL', provider.PRSN_EMAIL);
			panelSearch.setValue('PRSN_PHONE', provider.PRSN_PHONE);
			panelSearch.setValue('PRSN_HANDPHONE', provider.PRSN_HANDPHONE);
			panelSearch.setValue('INPUT_PATH', provider.INPUT_PATH);
			
			if(panelSearch.getValue('BILL_TYPE') != '1'){
				panelSearch.setValue('UPDATE_REASON', provider.MODI_REASON);
				Ext.getCmp('bfIssue').show();
				panelSearch.getField('REMARK').allowBlank = false;
				panelSearch.getField('UPDATE_REASON').allowBlank = false;
				//수정사유  readOnly, allowBlank 세팅
				panelSearch.getField('UPDATE_REASON').setReadOnly(true);
			} else {				
				Ext.getCmp('bfIssue').hide();
				panelSearch.getField('REMARK').allowBlank = true;
				panelSearch.getField('UPDATE_REASON').allowBlank = true;	
				//수정사유  readOnly, allowBlank 세팅 
				panelSearch.setValue('UPDATE_REASON', '');
				panelSearch.getField('UPDATE_REASON').setReadOnly(true);	
			}
			panelSearch.setValue('EB_NUM', provider.EB_NUM);
			panelSearch.setValue('ISSU_ID', provider.ISSU_ID);
			panelSearch.setValue('BILL_SEND_YN', provider.BILL_SEND_YN);
			panelSearch.setValue('WRITE_DATE',provider.BILL_DATE);
			panelSearch.setValue('REMARK',provider.REMARK);
			panelSearch.setValue('PROJECT_NO', provider.PROJECT_NO);

			panelSearch.setValue('EX_NUM', provider.EX_NUM)
			gsAcDate = provider.AC_DATE;

			if(Ext.isEmpty(provider.EX_DATE)){
				panelSearch.setValue('EX_DATE', '');
				panelSearch.down('#btnAccnt').setDisabled(false);
				panelSearch.down('#btnCancel').setDisabled(true);
			} else {
				panelSearch.setValue('EX_DATE', provider.EX_DATE);
				if(Ext.isEmpty(gsAcDate)){
					panelSearch.down('#btnAccnt').setDisabled(false);
					panelSearch.down('#btnCancel').setDisabled(true);
				} else {
					panelSearch.down('#btnAccnt').setDisabled(true);
					panelSearch.down('#btnCancel').setDisabled(false);
				}
			}
			
			if(provider.PROOF_KIND == "11"){
				panelSearch.getField('TAX_BILL').setValue('1');
//				Ext.getCmp('rdoTaxType2').setReadOnly(true);
//				Ext.getCmp('rdoTaxType3').setReadOnly(true);

			} else if(provider.PROOF_KIND == "20"){
				panelSearch.getField('TAX_BILL').setValue('2');
//				Ext.getCmp('rdoTaxType1').setReadOnly(true);
//				Ext.getCmp('rdoTaxType3').setReadOnly(true);

			} else if(provider.PROOF_KIND == "12"){
//				Ext.getCmp('rdoTaxType1').setReadOnly(true);
//				Ext.getCmp('rdoTaxType2').setReadOnly(true);
				panelSearch.getField('TAX_BILL').setValue('3');
			}
			
			CustomCodeInfo.gsTaxCalcType = provider.TAX_CALC_TYPE;
			gsPjtCode = provider.PJT_CODE;
			amtForm.setValue('SALE_LOC_TOT_DIS', provider.SALE_TOT_AMT)
			
			panelSearch.setValue('SALE_AMT_O', provider.SALE_AMT_O);
			panelSearch.setValue('TAX_AMT_O', provider.TAX_AMT_O);
			
			panelSearch.setValue('DEPT_CODE', provider.DEPT_CODE);
			panelSearch.setValue('DEPT_NAME', provider.DEPT_NAME);
			panelSearch.setValue('BUSI_TYPE', provider.BUSI_TYPE);
			panelSearch.setValue('PROOF_KIND', provider.PROOF_KIND);

			addSearch.setValue('BROK_CUSTOM_CODE', provider.BROK_CUSTOM_CODE);
			addSearch.setValue('BROK_PRSN_NAME', provider.BROK_PRSN_NAME);
			addSearch.setValue('BROK_PRSN_EMAIL', provider.BROK_PRSN_EMAIL);

			//전자세금계산서 관련 버튼 세팅
			if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))) {
				if (panelSearch.getValue('BILL_SEND_YN') == 'Y') {
					Ext.getCmp('btnEtax').setDisabled(true);
					Ext.getCmp('btnViewEtax').setDisabled(false);
					
				} else {
					Ext.getCmp('btnEtax').setDisabled(false);
					Ext.getCmp('btnViewEtax').setDisabled(true);
				}
			}
			amtForm.setValue('CLAIM_YN', provider.BILL_GUBUN)
			
			gsSaveRefFlag = 'Y';
			
//			panelSearch.setAllFieldsReadOnly(true);
			//조회 시 필수체크 수동으로 적용
			if (Ext.isEmpty(panelSearch.getValue('SALE_DIV_CODE'))) {
				alert('매출사업장은 필수 입력사항 입니다.');
				return false;
			}
			if (Ext.isEmpty(panelSearch.getValue('WRITE_DATE'))) {
				alert('작성일은 필수 입력사항 입니다.');
				return false;
			}
			return true;
		},

		fnOrderAmtSum: function() {
			var dtotSaleTI = 0;
			var dtotTaxI = 0;
			
			dtotSaleTI	= Ext.isNumeric(this.sum('SALE_AMT_O'))	? this.sum('SALE_AMT_O'): 0;	
			dtotTaxI	= Ext.isNumeric(this.sum('TAX_AMT_O'))	? this.sum('TAX_AMT_O') : 0;
			sSaleAmt	= dtotSaleTI;
			sTaxAmt		= dtotTaxI;

			amtForm.setValue('SALE_LOC_TOT_DIS', dtotSaleTI + dtotTaxI);
        	panelSearch.setValue('SALE_AMT_O', dtotSaleTI);
        	panelSearch.setValue('TAX_AMT_O', dtotTaxI);
		}
	});

 	//마스터 그리드 정의
    var masterGrid = Unilite.createGrid('atx110ukrGrid', {
        layout	: 'fit',
        region	: 'center',
		uniOpt	: {						
			useMultipleSorting	: false,			 	
		   	useLiveSearch		: true,			
		    onLoadSelectFirst	: true,		//체크박스모델은 false로 변경		
		    dblClickToEdit		: true,			
		    useGroupSummary		: false,			
			useContextMenu		: false,			
			useRowNumberer		: true,			
			expandLastColumn	: false,				
			useRowContext		: false,	// rink 항목이 있을경우만 true		
			copiedRow			: true,			
			filter: {					
				useFilter	: false,			
				autoCreate	: false			
			}					
		},
    	store: masterStore,
        tbar: [/*{
        	text:'세금계산서출력',
        	id: 'btnPrint',
        	handler: function() {
				var params = {
				}
        		//전송
          		var rec1 = {data : {prgID : 'atx110rkr', 'text':''}};							
				parent.openTab(rec1, '/accnt/atx110rkr.do', params);	
        	}
        }*/],				
		columns: [
			{ dataIndex: 'COMP_CODE'		         		            , width: 80		,hidden: true},        
			{ dataIndex: 'DIV_CODE'		         		                , width: 80		,hidden: true},        
			{ dataIndex: 'SEQ'			         		                , width: 80		,hidden: true},        
			{ dataIndex: 'PUB_NUM'		         		                , width: 100	,hidden: true},        
			{ dataIndex: 'REMARK'			         		            , width: 400/*,
				editor:Unilite.popup('REMARK_G',{
					textFieldName:'REMARK',
        			validateBlank:false,
        			listeners:{
        				'onSelected':function(records, type)	{
        					var selectedRec = masterGrid.getSelectedRecord();// masterGrid1.uniOpt.currentRecord;
        					selectedRec.set('REMARK', records[0].REMARK_NAME);
        					
        				},
        				'onClear':function(type)	{
        					var selectedRec = masterGrid.getSelectedRecord();
        					//selectedRec.set('REMARK', '');
        				}        				
        			}        			
        		})
			*/},        
			{ dataIndex: 'SALE_LOC_AMT_I'	         		            , width: 120	,hidden: true},        
			{ dataIndex: 'SALE_AMT_O'		         		            , width: 200 },        
			{ dataIndex: 'TAX_AMT_O'		         		            , width: 200 },        
			{ dataIndex: 'CUSTOM_CODE'	         		                , width: 80		,hidden: true},        
			{ dataIndex: 'PROJECT_NO'		         		            , width: 80		,hidden: true},        
			{ dataIndex: 'SALE_PROFIT'	         		                , width: 120	,hidden: true},        
			{ dataIndex: 'SALE_DIV_CODE'	         		            , width: 80		,hidden: true},        
			{ dataIndex: 'EX_DATE'		         		                , width: 100	,hidden: true},        
			{ dataIndex: 'EX_NUM'			         		            , width: 100	,hidden: true},        
			{ dataIndex: 'AC_DATE'		         		                , width: 100	,hidden: true},        
			{ dataIndex: 'AC_NUM'			         		            , width: 100	,hidden: true},        
			{ dataIndex: 'AGREE_YN'		         		                , width: 80		,hidden: true},        
			{ dataIndex: 'CLOSING_YN'		         		            , width: 80		,hidden: true},        
			{ dataIndex: 'BIGO'			         		                , flex: 1 }
		],
	/*	setItemData: function(record, dataClear, grdRecord) {
//       		var grdRecord = this.uniOpt.currentRecord;
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'		, "");
       			grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, ""); 
       			grdRecord.set('SALE_UNIT'		, "");
       			grdRecord.set('TRANS_RATE'		, "1");
       			grdRecord.set('WH_CODE'			, "");       			
       			grdRecord.set('UNIT_WGT'		, 0);
       			grdRecord.set('WGT_UNIT'		, "");
       			grdRecord.set('UNIT_VOL'		, 0);
       			grdRecord.set('VOL_UNIT'		, "");       			
       			grdRecord.set('SALE_Q'        	, 0);
       			grdRecord.set('SALE_P'        	, 0);
       			grdRecord.set('SALE_AMT_O'    	, 0);
       			grdRecord.set('TAX_AMT_O'     	, 0);
       			grdRecord.set('SALE_WGT_Q'    	, 0);
       			grdRecord.set('SALE_FOR_WGT_P'	, 0);
       			grdRecord.set('SALE_WGT_P'    	, 0);
       			grdRecord.set('SALE_VOL_Q'    	, 0);
       			grdRecord.set('SALE_FOR_VOL_P'	, 0);
       			grdRecord.set('SALE_VOL_P'    	, 0);
       		} else {
       			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']); 
       			grdRecord.set('SALE_UNIT'		, record['SALE_UNIT']);
       			grdRecord.set('TRANS_RATE'		, record['TRNS_RATE']);
       			grdRecord.set('WH_CODE'			, record['WH_CODE']);       			
       			grdRecord.set('UNIT_WGT'		, record['UNIT_WGT']);
       			grdRecord.set('WGT_UNIT'		, record['WGT_UNIT']);
       			grdRecord.set('UNIT_VOL'		, record['UNIT_VOL']);
       			grdRecord.set('VOL_UNIT'		, record['VOL_UNIT']);       			
       			grdRecord.set('SALE_Q'        	, 0);
       			grdRecord.set('SALE_P'        	, 0);
       			grdRecord.set('SALE_AMT_O'    	, 0);
       			grdRecord.set('TAX_AMT_O'     	, 0);
       			grdRecord.set('SALE_WGT_Q'    	, 0);
       			grdRecord.set('SALE_FOR_WGT_P'	, 0);
       			grdRecord.set('SALE_WGT_P'    	, 0);
       			grdRecord.set('SALE_VOL_Q'    	, 0);
       			grdRecord.set('SALE_FOR_VOL_P'	, 0);
       			grdRecord.set('SALE_VOL_P'    	, 0);
       		}
		},*/
		/*setReferData:function(record) {
       		var grdRecord = this.getSelectedRecord();
       		
       		grdRecord.set('PUB_NUM'				, panelSearch.getValue('PUB_NUM')); 
       		grdRecord.set('DIV_CODE'  				, record['DIV_CODE'  ]);
       		grdRecord.set('BILL_NUM'  				, record['BILL_NUM'  ]);
       		grdRecord.set('BILL_SEQ'  				, record['BILL_SEQ'  ]);
       		grdRecord.set('ITEM_CODE' 				, record['ITEM_CODE' ]);
       		grdRecord.set('ITEM_NAME' 				, record['ITEM_NAME' ]);
       		grdRecord.set('SPEC'      				, record['SPEC'      ]);
       		grdRecord.set('SALE_Q'    				, record['SALE_Q'    ]);
       		grdRecord.set('SALE_P'    				, record['SALE_P'    ]);
       		grdRecord.set('SALE_AMT_O'				, record['SALE_AMT_O']);
       		grdRecord.set('TAX_TYPE'  				, record['TAX_TYPE'  ]);
       		grdRecord.set('TAX_AMT_O' 				, record['TAX_AMT_O' ]);
       		grdRecord.set('REMARK'					, panelSearch.getValue('REMARK'));
       		grdRecord.set('RECEIPT_PLAN_DATE'		, panelSearch.getValue('RECEIPT_PLAN_DATE'));
       		grdRecord.set('PROJECT_NO'				, panelSearch.getValue('PROJECT_NO'));
       		grdRecord.set('PJT_CODE'				, record['PJT_CODE']);
       		grdRecord.set('PJT_NAME'				, record['PJT_NAME']);
       		grdRecord.set('BILL_DIV_CODE'			, panelSearch['BILL_DIV_CODE']);
       		grdRecord.set('COMP_CODE'				, UserInfo.compCode);
       		grdRecord.set('INOUT_NUM'        		, record['INOUT_NUM'        ]);
       		grdRecord.set('INOUT_SEQ'        		, record['INOUT_SEQ'        ]);
       		grdRecord.set('INOUT_TYPE'       		, record['INOUT_TYPE'       ]);
       		grdRecord.set('INOUT_TYPE_DETAIL'		, record['INOUT_TYPE_DETAIL']);
       		grdRecord.set('SALE_UNIT'        		, record['SALE_UNIT'        ]);
       		grdRecord.set('TRANS_RATE'       		, record['TRANS_RATE'       ]);
       		grdRecord.set('WH_CODE'          		, record['WH_CODE'          ]);
       		grdRecord.set('PRICE_YN'         		, record['PRICE_YN'         ]);
       		grdRecord.set('CUSTOM_CODE'      		, record['CUSTOM_CODE'      ]);
       		grdRecord.set('ORDER_PRSN'       		, record['ORDER_PRSN'       ]);
       		grdRecord.set('OUT_DIV_CODE'     		, record['OUT_DIV_CODE'     ]);
       		grdRecord.set('PRICE_TYPE'       		, record['PRICE_TYPE'       ]);
       		grdRecord.set('UNIT_WGT'         		, record['UNIT_WGT'         ]);
       		grdRecord.set('WGT_UNIT'         		, record['WGT_UNIT'         ]);
       		grdRecord.set('UNIT_VOL'         		, record['UNIT_VOL'         ]);
       		grdRecord.set('VOL_UNIT'         		, record['VOL_UNIT'         ]);
       		grdRecord.set('SALE_WGT_Q'       		, record['SALE_WGT_Q'       ]);
       		grdRecord.set('SALE_FOR_WGT_P'   		, record['SALE_FOR_WGT_P'   ]);
       		grdRecord.set('SALE_WGT_P'       		, record['SALE_WGT_P'       ]);
       		grdRecord.set('SALE_VOL_Q'       		, record['SALE_VOL_Q'       ]);
       		grdRecord.set('SALE_FOR_VOL_P'   		, record['SALE_FOR_VOL_P'   ]);
       		grdRecord.set('SALE_VOL_P'       		, record['SALE_VOL_P'       ]);
       		
       		gsPjtCode = record['PJT_CODE']	
		}, */
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {     				
  				if (UniUtils.indexOf(e.field, ['REMARK', 'SALE_AMT_O', 'TAX_AMT_O', 'BIGO'])){
  					return true;
				} else {
				 	return false;
				}
       		}
		}
    });

    
    /**
	 * 계산서정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//검색창 폼 정의
  	var billNosearch = Unilite.createSearchForm('atx110ukrBillNosearchForm', {
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [
			Unilite.popup('AGENT_CUST',{
	    	valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,			
		    fieldLabel		: '거래처'
		}),{
			fieldLabel: '계산서일',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_DATE',
			endFieldName: 'TO_DATE',
//			startDate	: UniDate.get('startOfMonth'),
//			endDate		: UniDate.get('today'),
			width: 350
		},{ 
			fieldLabel: '매출사업장',
			name: 'SALE_DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			listeners: {
				onTextSpecialKey: function(elm, e){
                    if (e.getKey() == e.ENTER) {
						billNosearch.getField('PROJECT_NO').focus();					//ENTER KEY FOCUS 이동
                    }
                }	
			}			
		},
		Unilite.popup('PROJECT',{	
			fieldLabel		: '사업코드',
			validateBlank	: true, 
			textFieldName	: 'PROJECT_NO',
			itemId			: 'project',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0': 3});
					popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('SALE_CUSTOM_CODE')});
				},
				onTextSpecialKey: function(elm, e){
                    if (e.getKey() == e.ENTER) {
						billNoMasterStore.loadStoreRecords();
                    }
                }	
			}				
		}),{
    		xtype: 'radiogroup',		            		
			fieldLabel: '발행구분',
			tdAttrs: {align: 'left'},
			items: [{
				boxLabel: '전체', 
				width: 60, 
				name: 'BILL_PUBLISH_TYPE',
    			inputValue: '',
				checked: true  
			},{
				boxLabel: '정발행', 
				width: 70, 
				name: 'BILL_PUBLISH_TYPE',
    			inputValue: '1'
			},{
				boxLabel : '역발행', 
				width: 70,
				name: 'BILL_PUBLISH_TYPE',
    			inputValue: '2'
			},{
				boxLabel : '위수탁발행', 
				width: 90,
				name: 'BILL_PUBLISH_TYPE',
    			inputValue: '3'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					billNoMasterStore.loadStoreRecords();
				}
			}
		}]
    });
       
    // createSearchForm
	//검색창 모델 정의
	Unilite.defineModel('billNoMasterModel', {
	    fields: [{name: 'DIV_NAME'    		    ,text: '신고사업장'				, type: 'string'},      
				 {name: 'CUSTOM_NAME'  	       	,text: '매출처'				, type: 'string'},  
				 {name: 'PUB_NUM'    		    ,text: '계산서번호'				, type: 'string'},      
				 {name: 'BILL_FLAG'    	       	,text: '계산서구분'				, type: 'string'		, comboType: 'AU', comboCode: 'S096'},      
				 {name: 'BILL_TYPE'    	       	,text: '계산서종류'				, type: 'string'},      
				 {name: 'BILL_DATE'    	       	,text: '계산서일'				, type: 'uniDate'},  
				 {name: 'PUB_DATE'    		    ,text: '매출기간'				, type: 'string'},  
				 {name: 'SALE_DIV_CODE'	       	,text: '매출사업장'				, type: 'string'		, comboType: 'BOR120'},      
				 {name: 'PROJECT_NO'   	       	,text: '관리번호'				, type: 'string'},  
				 {name: 'EX_YN'        	       	,text: '기표여부'				, type: 'string'		, comboType: 'AU'		, comboCode: 'A020'},  
				 {name: 'COLET_CUST_CD'	       	,text: '수금처'				, type: 'string'},  
				 {name: 'DIV_CODE'    		    ,text: '신고사업장'				, type: 'string'		, comboType: 'BOR120'},      
				 {name: 'CUSTOM_CODE'  	       	,text: '매출처'				, type: 'string'},  
				 {name: 'SEND_NAME'    	       	,text: '영업담당'				, type: 'string'},  
				 {name: 'MODI_REASON'  	       	,text: '수정사유'				, type: 'string'},
				 {name: 'BILL_PUBLISH_TYPE'    	,text: '신고사업장'				, type: 'string'},      
				 {name: 'BROK_CUSTOM_CODE'  	,text: '매출처'				, type: 'string'},  
				 {name: 'BROK_PRSN_NAME'    	,text: '영업담당'				, type: 'string'},  
				 {name: 'BROK_PRSN_EMAIL'  	    ,text: '수정사유'				, type: 'string'},				 
				 {name: 'BROK_PRSN_PHONE'  	    ,text: '수정사유'				, type: 'string'},				 
				 {name: 'INPUT_PATH'	  	    ,text: '생성경로'				, type: 'string'},				 
				 {name: 'ERR_MSG'  	   			,text: '에러메세지'				, type: 'string'}
		]
	});
	
	//검색창 스토어 정의
	var billNoMasterStore = Unilite.createStore('atx110ukrBillNoMasterStore', {
		model	: 'billNoMasterModel',
        autoLoad: false,
        uniOpt	: {
        	isMaster	: false,			// 상위 버튼 연결
        	editable	: false,			// 수정 모드 사용
        	deletable	: false,			// 삭제 가능 여부
            useNavi		: false				// prev | newxt 버튼 사용
        },
        proxy	: {
            type	: 'direct',
            api		: {
            	read : 'atx110ukrService.selectBillNoMasterList'
            }
		},
        loadStoreRecords : function()	{
			var param= billNosearch.getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(records.length == 0) {
					if(panelSearch.getValue('BILL_TYPE') == '2' && panelSearch.getValue('UPDATE_REASON') == '01'){
           				UniAppManager.setToolbarButtons('deleteAll', true);
           				UniAppManager.setToolbarButtons('save', false);
					}
           		}
   				gsStatusM = 'Q';
           	},

           	add: function(store, records, index, eOpts) {
           		
           	},
           	
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	
           	remove: function(store, record, index, isMove, eOpts) {
				
           	}
		}
	});

	//검색창 그리드 정의
	var billNoMasterGrid = Unilite.createGrid('atx110ukrBillNoMasterGrid', {
        // title: '기본',
		layout	: 'fit',       
		store	: billNoMasterStore,
		uniOpt	: {
			useRowNumberer: false
		},
		columns:  [{ dataIndex: 'DIV_NAME'    		    , width: 100 },  
        		   { dataIndex: 'CUSTOM_NAME'  	       	, width: 120 },  
        		   { dataIndex: 'PUB_NUM'    		    , width: 120 },  
        		   { dataIndex: 'BILL_FLAG'    	       	, width: 73 },  
        		   { dataIndex: 'BILL_TYPE'    	       	, width: 100 },  
        		   { dataIndex: 'BILL_DATE'    	       	, width: 73 },  
        		   { dataIndex: 'PUB_DATE'    		    , width: 146	, hidden:true },  
        		   { dataIndex: 'SALE_DIV_CODE'	       	, width: 120 },  
        		   { dataIndex: 'PROJECT_NO'   	       	, width: 100 },  
        		   { dataIndex: 'EX_YN'        	       	, width: 66 },  
        		   { dataIndex: 'COLET_CUST_CD'	       	, width: 120 },  
        		   { dataIndex: 'DIV_CODE'    		    , width: 73		, hidden:true },  
        		   { dataIndex: 'CUSTOM_CODE'  	       	, width: 73		, hidden:true },  
        		   { dataIndex: 'SEND_NAME'    	       	, width: 73		, hidden:true },  
        		   { dataIndex: 'MODI_REASON'  	       	, width: 100 },
        		   { dataIndex: 'BILL_PUBLISH_TYPE'    	, width: 100	, hidden:true },
        		   { dataIndex: 'BROK_CUSTOM_CODE'	    , width: 120	, hidden:true  },  
        		   { dataIndex: 'BROK_PRSN_NAME'   	    , width: 100	, hidden:true  },  
        		   { dataIndex: 'BROK_PRSN_EMAIL'       , width: 66		, hidden:true  },  
        		   { dataIndex: 'BROK_PRSN_PHONE'	    , width: 120	, hidden:true  },  
        		   { dataIndex: 'INPUT_PATH'		    , width: 120	, hidden:true  },  
        		   { dataIndex: 'ERR_MSG'	    		, width: 120	, hidden:true  },
        		   
        		   {dataIndex : 'SEND_NAME'         	, width : 66, hidden: true},
        		   {dataIndex : 'SEND_EMAIL'        	, width : 66, hidden: true},
        		   {dataIndex : 'PRSN_NAME'        		, width : 66, hidden: true},
        		   {dataIndex : 'PRSN_EMAIL'   			, width : 66, hidden: true},
        		   {dataIndex : 'PRSN_PHONE'         	, width : 66, hidden: true},
        		   {dataIndex : 'PRSN_HANDPHONE'        , width : 66, hidden: true},
        		   {dataIndex : 'SMS_CHECK'       		, width : 66, hidden: true}  

		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				billNoMasterGrid.returnData(record);
				fnGetMasterData();
				searchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record)	{
			panelSearch.setValue('SALE_DIV_CODE'	, record.get('SALE_DIV_CODE'));
//          UniAppManager.app.fnSaleDivCode_onChange();
			UniAppManager.app.fnRecordComBo();
			panelSearch.setValue('BILL_DIV_CODE'	, record.get('DIV_CODE'));
			panelSearch.setValue('PUB_NUM'			, record.get('PUB_NUM'));
			panelSearch.setValue('SEND_NAME'		, record.get('SEND_NAME'));				//전송 담당자
			panelSearch.setValue('SEND_EMAIL'		, record.get('SEND_EMAIL'));			//전송 이메일
			panelSearch.setValue('PRSN_NAME'		, record.get('PRSN_NAME'));				//받는 담당자
			panelSearch.setValue('PRSN_EMAIL'		, record.get('PRSN_EMAIL'));			//받는 이메일
			panelSearch.setValue('PRSN_PHONE'		, record.get('PRSN_PHONE'));			//받는 연락처
			panelSearch.setValue('PRSN_HANDPHONE'	, record.get('PRSN_HANDPHONE'));		//받는 연락처
			panelSearch.setValue('SMS_CHECK'		, record.get('SMS_CHECK'));		//받는 연락처
			panelSearch.setValue('BILL_PUBLISH_TYPE', record.get('BILL_PUBLISH_TYPE'));
			panelSearch.setValue('ERR_MSG'			, record.get('ERR_MSG'));
			panelSearch.setValue('CUST_SERVANT_NUM'	, record.get('SERVANT_COMPANY_NUM'));
			panelSearch.setValue('INPUT_PATH'		, record.get('INPUT_PATH'));

			if(record.get('BILL_PUBLISH_TYPE') == '1') {
   				Ext.getCmp('fieldset1').setTitle('공급자');
   				Ext.getCmp('fieldset2').setTitle('공급받는자');
   				Ext.getCmp('atx110ukrAddSearch').setHidden(true);
   				
				addSearch.clearForm();			
				masterGrid.getStore().loadData({});

				addSearch.getField('BROK_CUST_COM_NUM').setConfig('allowBlank'	, true);
				addSearch.getField('BROK_CUSTOM_CODE').setConfig('allowBlank'	, true);
				addSearch.getField('BROK_CUSTOM_NAME').setConfig('allowBlank'	, true);
				addSearch.getField('BROK_CUST_TOP_NAME').setConfig('allowBlank'	, true);
				addSearch.getField('BROK_PRSN_EMAIL').setConfig('allowBlank'	, true);

			} else if(record.get('BILL_PUBLISH_TYPE') == '2') {
   				Ext.getCmp('fieldset1').setTitle('공급받는자');
   				Ext.getCmp('fieldset2').setTitle('공급자');
   				Ext.getCmp('atx110ukrAddSearch').setHidden(true);
   				
				addSearch.clearForm();			
				masterGrid.getStore().loadData({});

				addSearch.getField('BROK_CUST_COM_NUM').setConfig('allowBlank'	, true);
				addSearch.getField('BROK_CUSTOM_CODE').setConfig('allowBlank'	, true);
				addSearch.getField('BROK_CUSTOM_NAME').setConfig('allowBlank'	, true);
				addSearch.getField('BROK_CUST_TOP_NAME').setConfig('allowBlank'	, true);
				addSearch.getField('BROK_PRSN_EMAIL').setConfig('allowBlank'	, true);

			} else if (record.get('BILL_PUBLISH_TYPE') == '3') {
   				Ext.getCmp('fieldset1').setTitle('공급자');
   				Ext.getCmp('fieldset2').setTitle('공급받는자');
   				Ext.getCmp('atx110ukrAddSearch').setHidden(false);
   				
				addSearch.clearForm();			
				masterGrid.getStore().loadData({});
				
				addSearch.getField('BROK_CUST_COM_NUM').setConfig('allowBlank'	, false);
				addSearch.getField('BROK_CUSTOM_CODE').setConfig('allowBlank'	, false);
				addSearch.getField('BROK_CUSTOM_NAME').setConfig('allowBlank'	, false);
				addSearch.getField('BROK_CUST_TOP_NAME').setConfig('allowBlank'	, false);
				addSearch.getField('BROK_PRSN_EMAIL').setConfig('allowBlank'	, false);
			}

			gsOriginalPubNum = record.get('ORIGINAL_PUB_NUM');
		}
	});
    
	//검색창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '계산서번호검색',
                width: 930,				                
                height: 580,
                layout: {type:'vbox', align:'stretch'},	                
                items: [billNosearch, billNoMasterGrid],
                tbar:  ['->',{
					itemId : 'searchBtn',
					text: '조회',
					handler: function() {
						billNoMasterStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId : 'closeBtn',
					text: '닫기',
					handler: function() {
						searchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						billNosearch.clearForm();
						billNoMasterGrid.reset();                							
					},
					beforeclose: function( panel, eOpts )	{
						billNosearch.clearForm();
						billNoMasterGrid.reset();
		 			},
					show: function( panel, eOpts )	{
					 	billNosearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
					 	billNosearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));                			 	
					 	billNosearch.setValue('FR_DATE',UniDate.get('startOfMonth', panelSearch.getValue('WRITE_DATE')));
					 	billNosearch.setValue('TO_DATE',panelSearch.getValue('WRITE_DATE'));                			 	
					 	billNosearch.setValue('SALE_DIV_CODE',panelSearch.getValue('SALE_DIV_CODE'));
					 	billNosearch.setValue('BILL_DIV_CODE',panelSearch.getValue('BILL_DIV_CODE'));

						billNosearch.getField('CUSTOM_CODE').focus();					//초기 포커스 사업장 필드로 설정
						billNoMasterStore.loadStoreRecords();
					}
				}		
			});
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
    }
    
	
    /**
	 * main app
	 */
    Unilite.Main({
		id			: 'atx110ukrApp',
		borderItems	: [{
			region	: 'center',
            layout	: {type:'vbox', align:'stretch'},
			border	: false,
            autoScroll: true,
			items	: [{
				region	: 'north',
				xtype	: 'container',
				layout	: {type: 'hbox', align: 'stretch' },
				items	: [ panelSearch, addSearch]
			},{
                region:'center',
                xtype:'container',
                layout:{type:'vbox', align:'stretch'},
        		minHeight: 200,
                flex: 4,
                items:[
                    masterGrid
                ]
            },{
                region:'south',
                xtype:'container',
        		minHeight: 70,
                layout:{type:'vbox', align:'stretch'},
                items:[
                    amtForm 
                ]
            }]	
		}],

		fnInitBinding: function(params) {
			linkFlag = false;
			UniAppManager.setToolbarButtons('reset'		, true);
			UniAppManager.setToolbarButtons('newData'	, true);

			this.setDefault();
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
				if(params.PGM_ID == 'atx115skr' || params.PGM_ID == 'agd170ukr') {
					var param = {CUSTOM_NAME : panelSearch.getValue('CUSTOM_CODE')};
					popupService.agentCustPopup(param, function(provider, response)	{
						panelSearch.setValue('CUST_COM_NUM'			, provider[0].COMPANY_NUM);
						panelSearch.setValue('CUSTOM_NAME'			, provider[0].CUSTOM_NAME);
						panelSearch.setValue('TOP_NAME'				, provider[0].TOP_NAME);
						panelSearch.setValue('ADDR'					, provider[0].ADDR1 + provider[0].ADDR2);
						panelSearch.setValue('COMP_CLASS'			, provider[0].COMP_CLASS);			//업종
						panelSearch.setValue('COMP_TYPE'			, provider[0].COMP_TYPE);			//업태
						panelSearch.setValue('CUST_SERVANT_NUM'		, provider[0].SERVANT_COMPANY_NUM);
						panelSearch.setValue('DEPT_CODE'			, UserInfo.deptCode);
						
						fnGetMasterData();
					});
				}
			};
		},
		
		onQueryButtonDown: function() {
			delfag = '';
			busiTypeFlag = false;
			var pubNum = panelSearch.getValue('PUB_NUM');
			if(Ext.isEmpty(pubNum)) {				
				openSearchInfoWindow() 
			} else {
				fnGetMasterData();
			}
		},
		
		onNewDataButtonDown: function()	{
			delfag = '';
			if(!this.isValidSearchForm()){			//작업 전 필수값 입력 여부 체크
				return false;
			}
			if(!addSearch.getInvalidMessage()){			//작업 전 필수값 입력 여부 체크
				return false;
			}
			if(!Ext.isEmpty(panelSearch.getValue('EX_DATE'))){
				alert(Msg.sMS322);					//"회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다."
				return false;
			}
			var compCode = UserInfo.compCode;
			var divCode  = panelSearch.getValue('BILL_DIV_CODE');
			var seq = masterStore.max('SEQ');
			if(!seq){
				seq = 1;
			} else {
				seq += 1;
			}
        	var customCode = panelSearch.getValue('CUSTOM_CODE');
			var saleProfit = '*';
			var saleDivCode = panelSearch.getValue('SALE_DIV_CODE');
			var projectNo = panelSearch.getValue('PROJECT_NO');
			var exNum = '0';
        	var acNum = '0'; 
        	
			gsStatusM = 'N';
        	gbTaxEdit = false; 
			var r = {
				COMP_CODE	: compCode,	
				DIV_CODE	: divCode,		 
				SEQ			: seq,		 
				CUSTOM_CODE	: customCode, 
				SALE_PROFIT	: saleProfit, 
				SALE_DIV_CODE: saleDivCode,
				PROJECT_NO	: projectNo,
				EX_NUM		: exNum,		
				AC_NUM		: acNum
	        };
			masterGrid.createRow(r);
			if(gsStatusM != 'N') {
				gsStatusM = 'U';
			}
			UniAppManager.setToolbarButtons('save', true);	
			UniAppManager.setToolbarButtons('delete', true);	

			panelSearch.setAllFieldsReadOnly(true);
		},
		
		onResetButtonDown: function() {
      		panelSearch.down('#btnAccnt').setDisabled(true);
			panelSearch.down('#btnCancel').setDisabled(true);
//			resetButtonFlag = 'Y';
//20161026 매출일 필드 삭제
//			beforeFrSaleDate = UniDate.getDbDateStr(panelSearch.getValue('FR_DATE'));
//			beforeToSaleDate = UniDate.getDbDateStr(panelSearch.getValue('TO_DATE'));
			
			panelSearch.clearForm();			
			panelSearch.setAllFieldsReadOnly(false);			
			addSearch.clearForm();			
			masterGrid.reset();	
			masterStore.clearData();
			this.fnInitBinding();
//			panelSearch.getField('CUSTOM_CODE').focus();
		},
		
		onSaveDataButtonDown: function(config) {		
			if(!this.isValidSearchForm()){			//작업 전 필수값 입력 여부 체크
				return false;
			}
			
			if (delfag == 'del') {
				//저장 시... 수정세금계산서(기재사항 착오/수정)가 아니고 detail data가 모두 삭제(스토어 카운트가 0)되면... 전체삭제 로직 수행
				if (!(panelSearch.getValue('BILL_TYPE') == '2' && panelSearch.getValue('UPDATE_REASON') == '01')) {	
					if (masterStore.getCount() == 0) {
						if (confirm ("세금계산서를 완전히 삭제하시겠습니까?")) {
							gsStatusM = 'D';
							
						} else {
							UniAppManager.app.onQueryButtonDown();
							return false;
						}
					}	
				}
			}
			masterStore.saveStore();
			delfag = '';
		},
		
		onDeleteDataButtonDown: function() {
			if (!Ext.isEmpty(panelSearch.getValue('EX_DATE'))){
				alert(Msg.sMS322);													//"회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다."
				return false;
			};
			
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
				
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();			
			}
			
			UniAppManager.setToolbarButtons('deleteAll', false);	
			masterStore.fnOrderAmtSum();
			delfag = 'del';
		},
		
		onDeleteAllButtonDown: function() {
			delfag = 'del';
			var records = masterStore.data.items;
			var isNewData = false;													//신규 여부에 대한 flag
			
			//수정세금계산서 기재사항 착오/수정일 경우
			if(panelSearch.getValue('BILL_TYPE') == '2' && panelSearch.getValue('UPDATE_REASON') == '01'){
				if(gsStatusM == 'N') {
					UniAppManager.setToolbarButtons('save', false);	
					UniAppManager.app.onResetButtonDown();	
					return false;
	
				} else {
					gsStatusM = 'D';
					if(confirm(Msg.sMB064)) {										//전체삭제 하시겠습니까?
						UniAppManager.app.fnModifyUpdatechange();		
						return false;
						
					} 
				}
			}
			//수정세금계산서 기재사항 착오/수정 외의 경우
			//회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다.
			if (!Ext.isEmpty(panelSearch.getValue('EX_DATE'))){
				alert(Msg.sMS322);													//"회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다."
				return false;
			} 
			
			if(gsStatusM =='N') {
				UniAppManager.setToolbarButtons('save', false);	
				UniAppManager.app.onResetButtonDown();	
				return false;
			
			} else if(records.length > 0) {
				Ext.each(records, function(record,i) {
					if(confirm(Msg.sMB064)) {										//전체삭제 하시겠습니까?
						if(record.phantom){											//신규 레코드일시 isNewData에 true를 반환
							isNewData = true;
		
						} else {								//신규 레코드가 아닌 data가 중간에 나오면 전체 삭제후 저장 로직 실행
							deletable = true;
							if(deletable){
								gsStatusM = 'D';
								var records = masterStore.getData().items;
								tempStore.add(records);
								masterGrid.reset();
								UniAppManager.app.onSaveDataButtonDown();	
							}
							isNewData = false;							
							return false;
						}
					}
				});			
				if(isNewData){										//신규 레코드들만 있을시 그리드 리셋		   
					masterGrid.reset();
					UniAppManager.app.onResetButtonDown();			//삭제후 RESET..
					return false;
				}
			}
		},
		
		onDetailButtonDown: function() {
			var as = Ext.getCmp('atx110ukrAdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		
		setDefault: function() {
			delfag = '';
			amtForm.setConfig('readOnly', false);
			Ext.getCmp('atx110ukrAddSearch').setHidden(true);

			panelSearch.setValue('BILL_PUBLISH_TYPE', '1');
			Ext.getCmp('fieldset1').setTitle('공급자');
			Ext.getCmp('fieldset2').setTitle('공급받는자');
			Ext.getCmp('atx110ukrAddSearch').setHidden(true);
			
			addSearch.clearForm();			
			masterGrid.getStore().loadData({});

			addSearch.getField('BROK_CUST_COM_NUM').setConfig('allowBlank'	, true);
			addSearch.getField('BROK_CUSTOM_CODE').setConfig('allowBlank'	, true);
			addSearch.getField('BROK_CUSTOM_NAME').setConfig('allowBlank'	, true);
			addSearch.getField('BROK_CUST_TOP_NAME').setConfig('allowBlank'	, true);
			addSearch.getField('BROK_PRSN_EMAIL').setConfig('allowBlank'	, true);

			panelSearch.getField('PUB_NUM').setReadOnly(true);				//일련번호 
			panelSearch.setValue('SALE_DIV_CODE'	, UserInfo.divCode);
//			UniAppManager.app.fnSaleDivCode_onChange();

//20161026 매출일 필드 삭제
//			if(resetButtonFlag == 'Y'){
//				panelSearch.setValue('FR_DATE'	, beforeFrSaleDate);
//				panelSearch.setValue('TO_DATE'	, beforeToSaleDate);
//
//			} else {
//				panelSearch.setValue('FR_DATE'	, UniDate.get('startOfMonth', panelSearch.getValue('TO_DATE')));
//				panelSearch.setValue('TO_DATE'	, new Date());
//			}
			panelSearch.setValue('SALE_AMT_O'	, 0);
			panelSearch.setValue('TAX_AMT_O'	, 0);
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);			//귀속부서코드
			panelSearch.setValue('SEND_NAME', UserInfo.userName);			//전송자
			var param = {
				USER_NAME	: UserInfo.userName,
				PERSON_NUMB	: UserInfo.personNumb
			};
			atx110ukrService.getEmail(param, function(provider, response)	{	//전송자이메일
				if(!Ext.isEmpty(provider)) {
					panelSearch.setValue('SEND_EMAIL'	, provider.data.EMAIL_ADDR);
				}
			});		
			
			var param = {TREE_CODE : panelSearch.getValue('DEPT_CODE')};
			popupService.deptPopup(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
				    panelSearch.setValue('DEPT_NAME'			, provider[0].TREE_NAME);
				}
			});
			panelSearch.setValue('BILL_TYPE', '1');							//세금계산서구분
			gsBillDivChgYN = 'N'											//신고사업장 변경여부
			panelSearch.setValue('WRITE_DATE',new Date());					//작성일
			if(BsaCodeInfo.gsBillYn == 'Y'){
				Ext.getCmp('billType').setReadOnly(true);
			} else {
				Ext.getCmp('billType').setReadOnly(false);
			}
			Ext.getCmp('bfIssue').hide();									//당초승인번호
			panelSearch.getField('UPDATE_REASON').setReadOnly(true);		//수정사유 
			amtForm.setValue('SALE_LOC_TOT_DIS', 0);
			panelSearch.getField('TAX_BILL').setValue('1');					//과세구분
			amtForm.getField('CLAIM_YN').setValue('2');						// 영수,청구 선택 
//			panelSearch.getField("RDO_CLAIM_YN").setReadOnly(true);  영수,청구 READONLY	////테스트후 풀것
			
			panelSearch.down('#btnAccnt').setDisabled(true);
			panelSearch.down('#btnCancel').setDisabled(true);
			UniAppManager.app.fnRecordComBo();								//신고사업장 가져오기
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();					
			
			Ext.getCmp('rdoTaxType1').setReadOnly(false);
			Ext.getCmp('rdoTaxType2').setReadOnly(false);
			Ext.getCmp('rdoTaxType3').setReadOnly(false);
			
			//전자세금계산서 관련 버튼 
			Ext.getCmp('btnEtax').setDisabled(true);
			Ext.getCmp('btnViewEtax').setDisabled(true);
			
			panelSearch.setAllFieldsReadOnly(false);	
			
//			Ext.getCmp('rdoIn').setReadOnly(true);
			UniAppManager.setToolbarButtons('save', false);	
			Ext.getCmp('labelText').setText('');
			gsStatusM = "N"
			gsSaveRefFlag = 'N';
			panelSearch.getField('REMARK').setConfig('allowBlank', true);	//// 폼의 allowBlank통제 하려면?
			//수정사유  readOnly, allowBlank 세팅 
			panelSearch.setValue('UPDATE_REASON', '');
			panelSearch.getField('UPDATE_REASON').setReadOnly(true);	
			panelSearch.getField('UPDATE_REASON').allowBlank = true;

			
			panelSearch.onLoadSelectText('SALE_DIV_CODE');					//초기 포커스 사업장 필드로 설정
		},

		fnRecordComBo: function(){											//신고사업장 가져오기
			if(BsaCodeInfo.gsBillDivChgYN == "Y") return false;				//신고사업장 변경여부가 '아니오'일 경우만 자동으로 변경함
			
			var param = panelSearch.getValues();
			atx110ukrService.selectBillDivList(param, function(provider, response)	{
				if(Ext.isEmpty(provider)) return false;
				panelSearch.setValue('BILL_DIV_CODE', provider.data.BILL_DIV_CODE);
				UniAppManager.app.billDivCode_onChange();					//사업장정보 쿼리 조회후 set
			});
		},
		
		billDivCode_onChange: function(){									//신고사업장 정보 가져오기
			if(Ext.isEmpty(panelSearch.getValue('BILL_DIV_CODE'))){
				panelSearch.setValue('OWN_COM_NUM', '');
				panelSearch.setValue('OWN_TOP_NAME', '');
				panelSearch.setValue('OWN_ADDRESS', '');
				panelSearch.setValue('OWN_COMP_TYPE', '');
				panelSearch.setValue('OWN_COMP_CLASS', '');
				panelSearch.setValue('OWN_SERVANT_NUM', '');
				return false;
			}
					
			var param = panelSearch.getValues();
			atx110ukrService.selectBillDivInfo(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					var comNum = '';
					if(Ext.isEmpty(provider.data.COMPANY_NUM)){
						panelSearch.setValue('OWN_COM_NUM', '');
					} else {
						if(!Ext.isEmpty(provider.data.COMPANY_NUM) && provider.data.COMPANY_NUM.length == 10){
							rsComNum =  provider.data.COMPANY_NUM;
							comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
							panelSearch.setValue('OWN_COM_NUM', comNum);
						} else {
							comNum = provider.data.COMPANY_NUM;
							panelSearch.setValue('OWN_COM_NUM', comNum);
						}
					}					
					panelSearch.setValue('OWN_TOP_NAME', 	provider.data.REPRE_NAME);
					panelSearch.setValue('OWN_ADDRESS', 	provider.data.ADDR);
					panelSearch.setValue('OWN_COMP_TYPE', 	provider.data.COMP_TYPE);
					panelSearch.setValue('OWN_COMP_CLASS', 	provider.data.COMP_CLASS);
					panelSearch.setValue('OWN_SERVANT_NUM', provider.data.SUB_DIV_NUM);
				}
			});
		},
		
		fnGetBillSendUseYNChk: function(){									//국세청전송완료체크 전 사용유무파악
			if(BsaCodeInfo.gsBillYn == "Y"){
				return true;
				
			} else {
				return false;
			}
		},
		

		fnGetParamMaster: function(){
			var taxInPutFormParams = panelSearch.getValues();				//param.TAX_BILL 가져오려고..getvalue로 못가져옴..
			var taxBill = '';
			if(taxInPutFormParams.TAX_BILL == "1"){				
				taxBill	= '11';		
			} else if(taxInPutFormParams.TAX_BILL == "2"){
				taxBill	= '20';
			} else if(taxInPutFormParams.TAX_BILL == "3"){
				taxBill	= '12';
			}
			var beforePubNum = panelSearch.getValue('BILL_TYPE') == "1" ? "" : gsBeforePubNum; 
			var originPubNum = panelSearch.getValue('BILL_TYPE') == "1" ? "" : gsOriginalPubNum ; 

			var paramMaster = panelSearch.getValues();
				paramMaster.FLAG 			= gsStatusM,               
				paramMaster.BILL_TYPE		= taxBill                 
				paramMaster.BILL_DATE		= UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'))
				paramMaster.SALE_AMT_O		= sSaleAmt               
				paramMaster.SALE_LOC_AMT_I	= sSaleAmt             
				paramMaster.TAX_AMT_O		= sTaxAmt                 
				paramMaster.COLET_CUST_CD	= CustomCodeInfo.gsCollector               
				paramMaster.UPDATE_DB_USER	= UserInfo.userID             
				paramMaster.TAX_CALC_TYPE	= CustomCodeInfo.gsTaxCalcType               
				paramMaster.SALE_PROFIT		= '*'                 
				paramMaster.COMP_CODE		= UserInfo.compCode                    
				paramMaster.PJT_CODE 		= gsPjtCode
				paramMaster.BEFORE_PUB_NUM 	= beforePubNum
				paramMaster.ORIGIN_PUB_NUM 	= originPubNum
				paramMaster.BFO_ISSU_ID		= panelSearch.getValue('BF_ISSUE')                 
				paramMaster.DIV_CODE		= panelSearch.getValue('BILL_DIV_CODE')                  
				paramMaster.PUB_NUM			= panelSearch.getValue('PUB_NUM')                    
				paramMaster.PROJECT_NO		= panelSearch.getValue('PROJECT_NO')                  
				paramMaster.BILL_FLAG		= panelSearch.getValue('BILL_TYPE')                  
				paramMaster.MODI_REASON		= panelSearch.getValue('UPDATE_REASON')                 
				paramMaster.BROK_CUSTOM_CODE= addSearch.getValue('BROK_CUSTOM_CODE');
				paramMaster.BROK_PRSN_NAME	= addSearch.getValue('BROK_PRSN_NAME');
				paramMaster.BROK_PRSN_EMAIL	= addSearch.getValue('BROK_PRSN_EMAIL');
				paramMaster.BROK_PRSN_PHONE	= addSearch.getValue('BROK_PRSN_PHONE');
				paramMaster.PUB_FR_DATE		= UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'));
				paramMaster.PUB_TO_DATE		= UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'));
				paramMaster.SERVANT_COMPANY_NUM = panelSearch.getValue('CUST_SERVANT_NUM') 
				paramMaster.RECEIVE_PRSN_EMAIL	= panelSearch.getValue('PRSN_EMAIL');
				paramMaster.RECEIVE_PRSN_MOBL	= panelSearch.getValue('PRSN_HANDPHONE');
				paramMaster.RECEIVE_PRSN_NAME	= panelSearch.getValue('PRSN_NAME');
				paramMaster.RECEIVE_PRSN_TEL	= panelSearch.getValue('PRSN_PHONE');
//20161026 매출일 필드 삭제  (위 내용으로 대체)
//				paramMaster.PUB_FR_DATE		= UniDate.getDbDateStr(panelSearch.getValue('FR_DATE'))               
//				paramMaster.PUB_TO_DATE		= UniDate.getDbDateStr(panelSearch.getValue('TO_DATE'))                
//				paramMaster.RECEIPT_PLAN_DATE : UniDate.getDbDateStr(panelSearch.getValue('RECEIPT_PLAN_DATE'))           
			return paramMaster;
		},
		
		fnModifyUpdatechange: function(){									//수정발행
			fnModifyUpdatechange = false;

			var pubNum = '';
			if(gsStatusM =="D"){
				pubNum = panelSearch.getValue('PUB_NUM');
			} else {
				pubNum = gsBeforePubNum;
			}
			var beforePubNum = panelSearch.getValue('BILL_TYPE') == "1" ? "" : gsBeforePubNum; 
			var originPubNum = panelSearch.getValue('BILL_TYPE') == "1" ? "" : gsOriginalPubNum ; 
			
			var param 					= panelSearch.getValues(); 
			param.FLAG					= gsStatusM;
		    param.COMP_CODE				= UserInfo.compCode;
			param.PUB_NUM				= pubNum;
			param.USER_ID				= UserInfo.userID;
			param.MODE					= 'modifyUpdate';
			param.BILL_DATE				= UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'))
			param.BEFORE_PUB_NUM		= beforePubNum
			param.ORIGIN_PUB_NUM		= originPubNum
//			param.ORIGIN_PUB_NUM		= gsOriginalPubNum; 
			param.BFO_ISSU_ID			= panelSearch.getValue('BF_ISSUE')                 
			param.DIV_CODE				= panelSearch.getValue('BILL_DIV_CODE')                  
			param.PROJECT_NO			= panelSearch.getValue('PROJECT_NO')                  
			param.BILL_FLAG				= panelSearch.getValue('BILL_TYPE')                  
			param.MODI_REASON			= panelSearch.getValue('UPDATE_REASON')                 
			param.BROK_CUSTOM_CODE		= addSearch.getValue('BROK_CUSTOM_CODE');
			param.BROK_PRSN_NAME		= addSearch.getValue('BROK_PRSN_NAME');
			param.BROK_PRSN_EMAIL		= addSearch.getValue('BROK_PRSN_EMAIL');
			param.BROK_PRSN_PHONE		= addSearch.getValue('BROK_PRSN_PHONE');
			param.PUB_FR_DATE			= UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'));
			param.PUB_TO_DATE			= UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'));
			param.SERVANT_COMPANY_NUM	= panelSearch.getValue('CUST_SERVANT_NUM');
			param.RECEIVE_PRSN_EMAIL	= panelSearch.getValue('PRSN_EMAIL');
			param.RECEIVE_PRSN_MOBL		= panelSearch.getValue('PRSN_HANDPHONE');
			param.RECEIVE_PRSN_NAME		= panelSearch.getValue('PRSN_NAME');
			param.RECEIVE_PRSN_TEL		= panelSearch.getValue('PRSN_PHONE');
			param.BILL_GUBUN			= Ext.getCmp('billGubun').getChecked()[0].inputValue;

			panelSearch.submit({
				params: param,
				success:function(comp, action)	{
					if(gsStatusM == 'N') {
						panelSearch.setValue('PUB_NUM', action.result.PUB_NUM);
						panelSearch.down('#btnAccnt').setDisabled(false);
						panelSearch.down('#btnCancel').setDisabled(true);
						Ext.getCmp('billType').setReadOnly(true);
						panelSearch.getField('UPDATE_REASON').setReadOnly(true);
		              	gsStatusM = 'Q';
					}

					if(gsStatusM == 'D') {
						UniAppManager.app.onResetButtonDown();
					}
					fnModifyUpdatechange = true;
					glAffectedCnt = 0;
					UniAppManager.setToolbarButtons('save', false);

					//전자세금계산서 관련 버튼 세팅
					if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))) {
						if (panelSearch.getValue('BILL_SEND_YN') == 'Y') {
							Ext.getCmp('btnEtax').setDisabled(true);
							Ext.getCmp('btnViewEtax').setDisabled(false);
							
						} else {
							Ext.getCmp('btnEtax').setDisabled(false);
							Ext.getCmp('btnViewEtax').setDisabled(true);
						}
					}
					alert('작업이 완료 되었습니다.');
				},
				
				failure: function(form, action){
					fnModifyUpdatechange = false;
					alert(Msg.sMB007);										//"자료저장중 오류가 발생하였습니다."
				}
			});			
		},
		
		fnMasterSave: function(paramMaster){								//수정발행			
			var taxInPutFormParams = panelSearch.getValues();				//param.TAX_BILL 가져오려고..getvalue로 못가져옴..
			var taxBill = '';
			if(taxInPutFormParams.TAX_BILL == "1"){				
				taxBill	= '11';		
			} else if(taxInPutFormParams.TAX_BILL == "2"){
				taxBill	= '20';
			} else if(taxInPutFormParams.TAX_BILL == "3"){
				taxBill	= '12';
			}
			var beforePubNum = panelSearch.getValue('BILL_TYPE') == "1" ? "" : gsBeforePubNum; 
			var originPubNum = panelSearch.getValue('BILL_TYPE') == "1" ? "" : gsOriginalPubNum ; 
			
			var param = panelSearch.getValues();
			param.FLAG					= gsStatusM                  
			param.BILL_TYPE				= taxBill                 
			param.BILL_DATE				= UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'))
			param.SALE_AMT_O			= sSaleAmt
			param.SALE_LOC_AMT_I		= sSaleAmt
			param.TAX_AMT_O				= sTaxAmt                 
			param.COLET_CUST_CD			= CustomCodeInfo.gsCollector               
			param.UPDATE_DB_USER		= UserInfo.userID             
			param.TAX_CALC_TYPE			= CustomCodeInfo.gsTaxCalcType               
			param.SALE_PROFIT			= '*'                 
			param.COMP_CODE				= UserInfo.compCode                    
			param.PJT_CODE				= gsPjtCode                     
			param.BEFORE_PUB_NUM		= beforePubNum
			param.ORIGIN_PUB_NUM		= originPubNum
			param.MODE 					= ''
			param.BFO_ISSU_ID			= panelSearch.getValue('BF_ISSUE')                 
			param.DIV_CODE				= panelSearch.getValue('BILL_DIV_CODE')                  
			param.PUB_NUM				= panelSearch.getValue('PUB_NUM')                    
			param.PROJECT_NO			= panelSearch.getValue('PROJECT_NO')                  
			param.BILL_FLAG				= panelSearch.getValue('BILL_TYPE')                  
			param.MODI_REASON			= panelSearch.getValue('UPDATE_REASON')                 
			param.BROK_CUSTOM_CODE		= addSearch.getValue('BROK_CUSTOM_CODE');
			param.BROK_PRSN_NAME		= addSearch.getValue('BROK_PRSN_NAME');
			param.BROK_PRSN_EMAIL		= addSearch.getValue('BROK_PRSN_EMAIL');
			param.BROK_PRSN_PHONE		= addSearch.getValue('BROK_PRSN_PHONE');
			param.PUB_FR_DATE			= UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'));
			param.PUB_TO_DATE			= UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'));
			param.SERVANT_COMPANY_NUM	= panelSearch.getValue('CUST_SERVANT_NUM');
			param.RECEIVE_PRSN_EMAIL	= panelSearch.getValue('PRSN_EMAIL');
			param.RECEIVE_PRSN_MOBL		= panelSearch.getValue('PRSN_HANDPHONE');
			param.RECEIVE_PRSN_NAME		= panelSearch.getValue('PRSN_NAME');
			param.RECEIVE_PRSN_TEL		= panelSearch.getValue('PRSN_PHONE');
			param.BILL_GUBUN			= Ext.getCmp('billGubun').getChecked()[0].inputValue;
//20161026 매출일 필드 삭제  (위 내용으로 대체)
//			param.PUB_FR_DATE			= UniDate.getDbDateStr(panelSearch.getValue('FR_DATE'))               
//			param.PUB_TO_DATE			= UniDate.getDbDateStr(panelSearch.getValue('TO_DATE'))                
			
			panelSearch.submit({
				params: param,
				success:function(comp, action)	{
//					panelSearch.setValue('PUB_NUM', action.result.PUB_NUM);
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.updateStatus(Msg.sMB011);

					//전자세금계산서 관련 버튼 세팅
					if (!Ext.isEmpty(panelSearch.getValue('PUB_NUM'))) {
						if (panelSearch.getValue('BILL_SEND_YN') == 'Y') {
							Ext.getCmp('btnEtax').setDisabled(true);
							Ext.getCmp('btnViewEtax').setDisabled(false);
							
						} else {
							Ext.getCmp('btnEtax').setDisabled(false);
							Ext.getCmp('btnViewEtax').setDisabled(true);
						}
					}
				},
				failure: function(form, action){
					
				}
			});	
		},
		
        //링크로 넘어오는 params 받는 부분 
        processParams: function(params) {
        	linkFlag = true;
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'atx115skr' || params.PGM_ID == 'agd170ukr') {
				panelSearch.setValue('PUB_NUM'			, params.PUB_NUM);
				panelSearch.setValue('SALE_DIV_CODE'	, params.SALE_DIV_CODE);
//20161026 매출일 필드 삭제
//				panelSearch.setValue('FR_DATE'			, params.BILL_DATE);
//				panelSearch.setValue('TO_DATE'			, params.BILL_DATE);
				panelSearch.setValue('CUSTOM_CODE'		, params.CUSTOM_CODE);
				panelSearch.setValue('BILL_DIV_CODE'	, params.DIV_CODE);
				panelSearch.setValue('BILL_PUBLISH_TYPE', params.BILL_PUBLISH_TYPE);
				
				if(params.BILL_PUBLISH_TYPE == '1') {
       				Ext.getCmp('fieldset1').setTitle('공급자');
       				Ext.getCmp('fieldset2').setTitle('공급받는자');
       				Ext.getCmp('atx110ukrAddSearch').setHidden(true);
       				
					addSearch.clearForm();			
					masterGrid.getStore().loadData({});

					addSearch.getField('BROK_CUST_COM_NUM').setConfig('allowBlank'	, true);
					addSearch.getField('BROK_CUSTOM_CODE').setConfig('allowBlank'	, true);
					addSearch.getField('BROK_CUSTOM_NAME').setConfig('allowBlank'	, true);
					addSearch.getField('BROK_CUST_TOP_NAME').setConfig('allowBlank'	, true);
					addSearch.getField('BROK_PRSN_EMAIL').setConfig('allowBlank'	, true);

				} else if(params.BILL_PUBLISH_TYPE == '2') {
       				Ext.getCmp('fieldset1').setTitle('공급받는자');
       				Ext.getCmp('fieldset2').setTitle('공급자');
       				Ext.getCmp('atx110ukrAddSearch').setHidden(true);
       				
					addSearch.clearForm();			
					masterGrid.getStore().loadData({});

					addSearch.getField('BROK_CUST_COM_NUM').setConfig('allowBlank'	, true);
					addSearch.getField('BROK_CUSTOM_CODE').setConfig('allowBlank'	, true);
					addSearch.getField('BROK_CUSTOM_NAME').setConfig('allowBlank'	, true);
					addSearch.getField('BROK_CUST_TOP_NAME').setConfig('allowBlank'	, true);
					addSearch.getField('BROK_PRSN_EMAIL').setConfig('allowBlank'	, true);

				} else if(params.BILL_PUBLISH_TYPE == '3') {				//위수탁 발행일 경우, 해당 패널 SHOW
       				Ext.getCmp('fieldset1').setTitle('공급자');
       				Ext.getCmp('fieldset2').setTitle('공급받는자');
       				Ext.getCmp('atx110ukrAddSearch').setHidden(false);
       				
					addSearch.clearForm();			
					masterGrid.getStore().loadData({});
					
					addSearch.getField('BROK_CUST_COM_NUM').setConfig('allowBlank'	, false);
					addSearch.getField('BROK_CUSTOM_CODE').setConfig('allowBlank'	, false);
					addSearch.getField('BROK_CUSTOM_NAME').setConfig('allowBlank'	, false);
					addSearch.getField('BROK_CUST_TOP_NAME').setConfig('allowBlank'	, false);
					addSearch.getField('BROK_PRSN_EMAIL').setConfig('allowBlank'	, false);
				}
			}	
		}	
	});		
		
	function fnSetPropertiesbyProofKind(){
		var param = {
			ADD_QUERY1	: "ISNULL(REF_CODE2,'') REF_CODE2, ISNULL(REF_CODE3,'') REF_CODE3",
			ADD_QUERY2	: '',
			MAIN_CODE	: 'A012',
			SUB_CODE	: panelSearch.getValue('BUSI_TYPE')
		}
		accntCommonService.fnGetRefCodes(param, function(provider, response)	{
			if(busiTypeFlag && !Ext.isEmpty(provider.REF_CODE2)){
				panelSearch.setValue('PROOF_KIND', provider.REF_CODE2)
			
			} else if(busiTypeFlag) {
				panelSearch.setValue('PROOF_KIND', panelSearch.getValue('PROOF_KIND'))
			}
			busiTypeFlag = true;
		});
	}
	
	function fnGetMasterData() {
		var param = {
			BILL_DIV_CODE	: panelSearch.getValue('BILL_DIV_CODE'),
			PUB_NUM			: panelSearch.getValue('PUB_NUM')
		}
		Ext.getBody().mask();
		atx110ukrService.selectMasterList(param, function(provider, response)	{
			Ext.getBody().unmask();
			if (masterStore.fnMasterSet(provider)) {
				masterStore.loadStoreRecords();
			}
		});	
	}

	function fnMakeLogTable(buttonFlag) {														//매출자동기표 data생성
		//조건에 맞는 내용은 적용 되는 로직
		records = masterGrid.getSelectedRecords();
		buttonStore.clearData();																//buttonStore 클리어
		Ext.each(records, function(record, index) {
			record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;												//자동기표 flag
			record.data.WORK_DATE	= UniDate.getDbDateStr(panelSearch.getValue('TO_DATE'));	//일괄자동기표일 때 전표일자 처리용(실행일자)
            buttonStore.insert(index, record);
			
			if (records.length == index +1) {
                buttonStore.saveStore(buttonFlag);
			}
		});
	}
	
	
	
    /**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;			
			switch(fieldName) {
				case "SALE_AMT_O" :	
//					if(newValue <= 0 && !Ext.isEmpty(newValue))	{
//						rv=Msg.sMB076;
//						break;
//					}
					if(panelSearch.getField('TAX_BILL').getValue('1')){
						record.set('TAX_AMT_O', Math.floor(newValue * 0.1));	
					} else {
						record.set('TAX_AMT_O', 0);
					}
					record.set('SALE_LOC_AMT_I', newValue);
					
					break;	
				
//				case "TAX_AMT_O" :	
//					if(newValue <= 0 && !Ext.isEmpty(newValue))	{
//						rv=Msg.sMB076;
//						break;
//					}
//					break;				
			}
			return rv;
		}
	}); // validator
	
	
	
/*		//금액보정(AU) 유무 체크하여 [추가]버튼 활성화 처리
		fnSetEnableNewBtn: function(sAuTypeCheck, lAuTypeCnt, records){	
			if(!Ext.isEmpty(panelSearch.getValue('EX_DATE'))) return false;
			if(gsColetAmt > 0) return false;
			//this.getTopToolbar().getComponent('save').isDisabled( )
			if(sAuTypeCheck == "N"){
				lAuTypeCnt = 0;
				Ext.each(records, function(record,i){
	        		if(record.get('INOUT_TYPE_DETAIL') == "AU"){
	        			lAuTypeCnt = lAuTypeCnt + 1;
	        		}     	
			    });
			}
			if(lAuTypeCnt == 0){
				if(UniAppManager.app.getTopToolbar().getComponent('newData').isDisabled( )){
					UniAppManager.setToolbarButtons('newData', true);
				}				
			} else {
				if(!UniAppManager.app.getTopToolbar().getComponent('newData').isDisabled( )){
					UniAppManager.setToolbarButtons('newData', false);
				}				
			}
		},*/
/*		//수금예정일 관련 로직은 회계에서는 사용하지 않음
		fnRcptDateCal: function(gsCollectDay){
			if(!Ext.isEmpty(gsCollectDay)){
				if(!Ext.isEmpty(panelSearch.getValue('WRITE_DATE'))){
					var sYearMonth = UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE')).substring(0, 6);
					var sDay = UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE')).substring(6, 8);
					if(BsaCodeInfo.gsCollectDayFlg == "1"){					
						if(sDay >= gsCollectDay){
							panelSearch.setValue('TEMP_COL_DATE', sYearMonth + gsCollectDay);//text를 날짜형식으로 set해주기 위해
							panelSearch.setValue('RECEIPT_PLAN_DATE', UniDate.add(panelSearch.getValue('TEMP_COL_DATE'), {months:+1}));
						} else {
							panelSearch.setValue('TEMP_COL_DATE', sYearMonth + gsCollectDay);//text를 날짜형식으로 set해주기 위해
							panelSearch.setValue('RECEIPT_PLAN_DATE', panelSearch.getValue('TEMP_COL_DATE'));
						}	
					} else if(BsaCodeInfo.gsCollectDayFlg == "2"){				
							panelSearch.setValue('TEMP_COL_DATE', panelSearch.getValue('WRITE_DATE'));//text를 날짜형식으로 set해주기 위해
							panelSearch.setValue('RECEIPT_PLAN_DATE', UniDate.add(panelSearch.getValue('TEMP_COL_DATE'), {days:+parseInt(gsCollectDay)}));
					}
				}
			}		
		},*/
/*		//국세청전송완료건 체크(필요시 추가 : 단, 비동기 방식으로 프로그램 실행되는 것 유의하여 사용
		fnGetBillSendCloseChk: function(){									//
			var param = {
				SALE_DIV_CODE	: panelSearch.getValue("SALE_DIV_CODE"),
				BILL_SEQ		: panelSearch.getValue("EB_NUM") 
			};
			atx110ukrService.getBillSendCloseChk(param, function(provider, response)	{
				if(Ext.isEmpty(provider)){
					return false;
				} else {
					var gsBillChk = provider['REPORT_STAT'];
					
					if(!Ext.isEmpty(gsBillChk)){
						return true;
					} else {
						return false;
					}
				}
			});
		},
 */
};
</script>