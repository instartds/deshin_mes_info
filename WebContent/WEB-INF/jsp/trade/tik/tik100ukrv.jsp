<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="tik100ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="tes100ukrv"/><!-- 사업장    -->  
    <t:ExtComboStore comboType="AU" comboCode="T002"/>  <!-- 무역종류  -->
    <t:ExtComboStore comboType="AU" comboCode="T005"/>  <!-- 가격조건  -->
    <t:ExtComboStore comboType="AU" comboCode="T006"/>  <!-- <t:message code="system.label.trade.paymentcondition" default="결제조건"/>  -->
    <t:ExtComboStore comboType="AU" comboCode="T002"/>  <!-- 무역종류  -->
    <t:ExtComboStore comboType="AU" comboCode="S010"/>  <!-- 영업담당  -->
    <t:ExtComboStore comboType="AU" comboCode="T060"/>  <!-- 지급유형  -->
    <t:ExtComboStore comboType="AU" comboCode="B004"/>  <!-- 화폐단위  -->
    <t:ExtComboStore comboType="AU" comboCode="T109"/>  <!-- 국내외구분  -->
</t:appConfig>
<style type= "text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var detailWin;


var BsaCodeInfo = { 
	gsHiddenField: '${gsHiddenField}'
}
var referBLWindow;   //B/L 적용
function appMain() {

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('tik100ukrvModel', {
		// pkGen : user, system(default)
	    fields: [
	       {name: 'NEGO_SER_NO'        ,text:'수입대금관리번호'       ,type:'string'  },
           {name: 'DIV_CODE'           ,text:'출금사업장'              ,type:'string', allowBlank: false  },
           {name: 'PAY_DATE'           ,text:'지급일'              ,type:'uniDate'  },
           {name: 'TRADE_TYPE'         ,text:'<t:message code="system.label.trade.tradetype" default="무역종류"/>'             ,type:'string'  },
           {name: 'NATION_INOUT'       ,text:'<t:message code="system.label.trade.domesticoverseasclass" default="국내외구분"/>'            ,type:'string', allowBlank: false  },
           {name: 'PROJECT_NO'         ,text:'프로젝트번호'          ,type:'string'  },
           {name: 'PROJECT_NAME'       ,text:'프로젝트명'          ,type:'string'  },
           {name: 'PAY_NM'             ,text:'출금담당자'           ,type:'string', allowBlank: false  },
           {name: 'PAY_BANK'           ,text:'지급은행'             ,type:'string'  },
           {name: 'PAY_BANK_NM'        ,text:'지급은행명'            ,type:'string'  },
           {name: 'BANK_CODE'          ,text:'<t:message code="system.label.trade.depositcode" default="예적금코드"/>'            ,type:'string'  },
           {name: 'BANK_NAME'          ,text:'<t:message code="system.label.trade.depositname" default="예적금명"/>'            ,type:'string'  },
           {name: 'ACCOUNT_NO'         ,text:'계좌번호'             ,type:'string'  },
           {name: 'PAY_METHODE'        ,text:'PAY_METHODE'        ,type:'string'  },
           {name: 'PAY_TERMS'          ,text:'<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'             ,type:'string'  },
           {name: 'PAY_DURING'         ,text:'PAY_DURING'        ,type:'string'  },
           {name: 'TERMS_PRICE'        ,text:'<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'             ,type:'string'  },
           {name: 'COLET_TYPE'         ,text:'지급유형'             ,type:'string', allowBlank: false  },
           {name: 'IMPORTER'           ,text:'<t:message code="system.label.trade.importer" default="수입자"/>'              ,type:'string', allowBlank: false  },
           {name: 'IMPORTER_NM'        ,text:'수입자명'            ,type:'string'  },
           {name: 'EXPORTER'           ,text:'<t:message code="system.label.trade.exporter" default="수출자"/>'              ,type:'string', allowBlank: false  },
           {name: 'EXPORTER_NM'        ,text:'수출자명'             ,type:'string'  },
           {name: 'AMT_SUB_PM'         ,text:'환차손익'             ,type:'string'  },
           {name: 'BL_EXCHANGE_RATE'   ,text:'B/L환율'            ,type:'string'  },
           {name: 'BL_AMT'             ,text:'BL_AMT'           ,type:'string'  },
           {name: 'AMT_UNIT'           ,text:'<t:message code="system.label.trade.currencyunit" default="화폐단위"/>'             ,type:'string'  },
           {name: 'PAY_AMT'            ,text:'지급액'              ,type:'string', allowBlank: false  },
           {name: 'PAY_EXCHANGE_RATE'  ,text:'<t:message code="system.label.trade.exchangerate" default="환율"/>'               ,type:'string', allowBlank: false  },
           {name: 'PAY_AMT_WON'        ,text:'<t:message code="system.label.trade.exchangeamount" default="환산액 "/>'              ,type:'string'  },
           {name: 'PAY_DIVCODE'        ,text:'출금사업장'            ,type:'string'  },
           {name: 'REMARKS1'           ,text:'비고1'              ,type:'string'  },
           {name: 'REMARKS2'           ,text:'비고2'              ,type:'string'  },
           {name: 'BASIS_SER_NO'       ,text:'근거번호'             ,type:'string'  }
		]
	});

	

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'tik100ukrvService.selectDetail',
			update	: 'tik100ukrvService.updateDetail',
			create	: 'tik100ukrvService.insertDetail',
			destroy	: 'tik100ukrvService.deleteDetail',
			syncAll	: 'tik100ukrvService.saveAll'
		}
	});	 
	
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('tik100ukrvMasterStore',{
			model: 'tik100ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : true			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
            
            listeners: {
            	update:function( store, record, operation, modifiedFieldNames, eOpts )	{
					detailForm.setActiveRecord(record);
				},
				metachange:function( store, meta, eOpts ){
					
				}
            	
            }, // listeners
            
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			loadStoreRecords : function()	{
				var param= Ext.getCmp('tik100ukrvSearchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},			
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			saveStore : function(config){
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				var paramMaster= panelSearch.getValues();    //syncAll 수정
				if(inValidRecs.length == 0 ){
					config = {
                        params: [paramMaster],
                        success: function(batch, option) {
                            var master = batch.operations[0].getResultSet();
                            panelSearch.setValue("NEGO_SER_NO", master.NEGO_SER_NO);
                            panelResult.setValue("NEGO_SER_NO", master.NEGO_SER_NO);
                            
//                              var inoutNum = masterForm.getValue('INOUT_NUM');
//                              Ext.each(list, function(record, index) {
//                                  if(record.data['INOUT_NUM'] != inoutNum) {
//                                      record.set('INOUT_NUM', inoutNum);
//                                  }
//                              })
                            UniAppManager.setToolbarButtons('save', false); 
                            directMasterStore.loadStoreRecords();
                            if(directMasterStore.getCount() == 0){
                                UniAppManager.app.onResetButtonDown();
                            }

                         } 
                    };
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
            listeners: {
                load: function(store, records, successful, eOpts) {
                	if(store.count() > 0){
                	   Ext.getCmp('ChargeInput').setDisabled(false);
                	}	
                }
            }
		});	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('tik100ukrvSearchForm',{
		title: '<t:message code="system.label.trade.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		defaults: {
			autoScroll:true
	  	},
		items:[{
			title: '<t:message code="system.label.trade.basisinfo" default="기본정보"/>', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items:[{
                fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                value: UserInfo.divCode,
                tdAttrs: {width: 346},
                allowBlank: false,
                listeners: {
//                    change: function(field, newValue, oldValue, eOpts) {                       
//                        panelResult.setValue('MONEY_UNIT', newValue);
//                        UniAppManager.app.fnExchngRateO();
//                    }
                }
            },
                Unilite.popup('NEGO_INCOM_NO',{
                fieldLabel: '관리번호',
                allowBlank:false,
                listeners: {
                    applyextparam: function(popup) {
                        popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                    },
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('NEGO_INCOM_NO', panelSearch.getValue('NEGO_INCOM_NO'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('NEGO_INCOM_NO', '');
                    }
                }
            })/*,{                        
               width: 100,
               xtype: 'button',
               text: 'B/L적용',
               tdAttrs: {align: 'right'},
               margin: '0 0 2 0',
               handler : function() {
                    openReferBLWindow();
               }
            }*/]
		}]
	});	//end panelSearch    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4, tableAttrs: {width: '99.5%'}},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
            fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            labelWidth: 95,
            value: UserInfo.divCode,
            tdAttrs: {width: 340},
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                       
//                    panelSearch.setValue('AMT_UNIT', newValue);
//                    UniAppManager.app.fnExchngRateO();
                }
            }
        },
            Unilite.popup('NEGO_INCOM_NO',{
            fieldLabel: '관리번호',
            allowBlank:false,
            listeners: {
                applyextparam: function(popup) {
                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                },
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('NEGO_INCOM_NO', panelResult.getValue('NEGO_INCOM_NO'));
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('NEGO_INCOM_NO', '');
                }
            }
        }),{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 2},
            tdAttrs: {align: 'right'},
        	items:[{                        
               width: 100,
               xtype: 'button',
               text: 'B/L적용',               
               margin: '0 0 2 0',
               handler : function() {
                    openReferBLWindow();
               }
            },{ 
                text: '<t:message code="system.label.trade.expenseentry" default="경비등록"/>',
                xtype: 'button',
                id:'ChargeInput',
                margin: '0 0 2 5',
                width: 100,
                handler: function() {
                	var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
                	if(needSave ){
                	   alert(Msg.sMB154); //먼저 저장하십시오.
                	   return false;
                	}
                    var param = new Array();
                    param[0] = "S";   //진행구분
                    param[1] = panelSearch.getValue('NEGO_INCOM_NO'); //근거번호
                    param[2] = detailForm.getValue('EXPORTER');  //수출자
                    param[3] = detailForm.getValue('EXPORTER_NM');
                    param[4] = "" 
                    param[5] = detailForm.getValue('DIV_CODE');
                    param[6] = detailForm.getValue('AMT_UNIT');  //화폐단위
                    param[7] = detailForm.getValue('PAY_EXCHANGE_RATE'); //<t:message code="system.label.trade.exchangerate" default="환율"/>
                    var params = {
                        appId: UniAppManager.getApp().id,
                        arrayParam: param 
                    }
                    var rec = {data : {prgID : 'tix100ukrv', 'text':''}};                                   
                    parent.openTab(rec, '/trade/tix100ukrv.do', params, CHOST+CPATH);
                }
            }]
        }]	
    });
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('tik100ukrvGrid', {
    	region:'center',
    	store: directMasterStore,
        layout : 'fit',        
        hidden: true,
		uniOpt:{
        	expandLastColumn: false,
            useMultipleSorting: true
        },
        border:true,
//        tbar: [
//	            {
//	        	text:'상세보기',
//	        	handler: function() {
//	        		var record = masterGrid.getSelectedRecord();
//		        	if(record) {
//		        		openDetailWindow(record);
//		        	}
//	        	}
//        }],
		columns:[
            {dataIndex:'NEGO_SER_NO'        ,width:80},
            {dataIndex:'DIV_CODE'           ,width:80},
            {dataIndex:'PAY_DATE'           ,width:80},
            {dataIndex:'TRADE_TYPE'         ,width:80},
            {dataIndex:'NATION_INOUT'       ,width:80},
            {dataIndex:'PROJECT_NO'         ,width:80},
            {dataIndex:'PROJECT_NAME'       ,width:80},
            {dataIndex:'PAY_NM'             ,width:80},
            {dataIndex:'PAY_BANK'           ,width:80},
            {dataIndex:'PAY_BANK_NM'        ,width:80},
            {dataIndex:'BANK_CODE'          ,width:80},
            {dataIndex:'ACCOUNT_NO'         ,width:80},
            {dataIndex:'PAY_METHODE'        ,width:80},
            {dataIndex:'PAY_TERMS'          ,width:80},
            {dataIndex:'PAY_DURING'         ,width:80},
            {dataIndex:'TERMS_PRICE'        ,width:80},
            {dataIndex:'COLET_TYPE'         ,width:80},
            {dataIndex:'IMPORTER'           ,width:80},
            {dataIndex:'IMPORTER_NM'        ,width:80},
            {dataIndex:'EXPORTER'           ,width:80},
            {dataIndex:'EXPORTER_NM'        ,width:80},
            {dataIndex:'AMT_SUB_PM'         ,width:80},
            {dataIndex:'BL_EXCHANGE_RATE'   ,width:80},
            {dataIndex:'BL_AMT'             ,width:80},
            {dataIndex:'MONEY_UNIT'         ,width:80},
            {dataIndex:'PAY_AMT'            ,width:80},
            {dataIndex:'PAY_EXCHANGE_RATE'  ,width:80},
            {dataIndex:'PAY_AMT_WON'        ,width:80},
            {dataIndex:'PAY_DIVCODE'        ,width:80},
            {dataIndex:'REMARKS1'           ,width:80}, 
            {dataIndex:'REMARKS2'           ,width:80},
            {dataIndex:'BASIS_SER_NO'       ,width:80}
		], 
         listeners: {          	
          	selectionchangerecord:function(selected)	{
          		detailForm.setActiveRecord(selected)
          	},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'CUSTOM_CODE' :
							masterGrid.hide();
							break;		
					default:
							break;
	      			}
          		}
          	},
			hide:function()	{
				detailForm.show();
			}
          },           
//          {name: 'NEGO_SER_NO'        ,text:'수입대금관리번호'       ,type:'string'  },
//           {name: 'DIV_CODE'           ,text:'<t:message code="system.label.trade.division" default="사업장"/>'              ,type:'string'  },
//           {name: 'PAY_DATE'           ,text:'지급일'              ,type:'string'  },
//           {name: 'TRADE_TYPE'         ,text:'<t:message code="system.label.trade.tradetype" default="무역종류"/>'             ,type:'string'  },
//           {name: 'NATION_INOUT'       ,text:'<t:message code="system.label.trade.domesticoverseasclass" default="국내외구분"/>'            ,type:'string'  },
//           {name: 'PROJECT_NO'         ,text:'프로젝트번호'          ,type:'string'  },
//           {name: 'PROJECT_NAME'       ,text:'프로젝트번호'          ,type:'string'  },
//           {name: 'PAY_NM'             ,text:'출금담당자'           ,type:'string'  },
//           {name: 'PAY_BANK'           ,text:'지급은행'             ,type:'string'  },
//           {name: 'PAY_BANK_NM'        ,text:'지급은행명'            ,type:'string'  },
//           {name: 'BANK_CODE'          ,text:'<t:message code="system.label.trade.depositcode" default="예적금코드"/>'            ,type:'string'  },
//           {name: 'BANK_NAME'          ,text:'<t:message code="system.label.trade.depositname" default="예적금명"/>'            ,type:'string'  },
//           {name: 'ACCOUNT_NO'         ,text:'계좌번호'             ,type:'string'  },
//           {name: 'PAY_METHODE'        ,text:'PAY_METHODE'        ,type:'string'  },
//           {name: 'PAY_TERMS'          ,text:'<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'             ,type:'string'  },
//           {name: 'PAY_DURING'         ,text:'PAY_DURING'        ,type:'string'  },
//           {name: 'TERMS_PRICE'        ,text:'<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'             ,type:'string'  },
//           {name: 'COLET_TYPE'         ,text:'지급유형'             ,type:'string'  },
//           {name: 'IMPORTER'           ,text:'<t:message code="system.label.trade.importer" default="수입자"/>'              ,type:'string'  },
//           {name: 'IMPORTER_NM'        ,text:'수입자명'            ,type:'string'  },
//           {name: 'EXPORTER'           ,text:'<t:message code="system.label.trade.exporter" default="수출자"/>'              ,type:'string'  },
//           {name: 'EXPORTER_NM'        ,text:'수출자명'             ,type:'string'  },
//           {name: 'AMT_SUB_PM'         ,text:'환차손익'             ,type:'string'  },
//           {name: 'BL_EXCHANGE_RATE'   ,text:'B/L<t:message code="system.label.trade.exchangerate" default="환율"/>'            ,type:'string'  },
//           {name: 'BL_AMT'             ,text:'BL_AMT'           ,type:'string'  },
//           {name: 'AMT_UNIT'           ,text:'<t:message code="system.label.trade.currencyunit" default="화폐단위"/>'             ,type:'string'  },
//           {name: 'PAY_AMT'            ,text:'지급액'              ,type:'string'  },
//           {name: 'PAY_EXCHANGE_RATE'  ,text:'<t:message code="system.label.trade.exchangerate" default="환율"/>'               ,type:'string'  },
//           {name: 'PAY_AMT_WON'        ,text:'<t:message code="system.label.trade.exchangeamount" default="환산액 "/>'              ,type:'string'  },
//           {name: 'PAY_DIVCODE'        ,text:'출금사업장'            ,type:'string'  },
//           {name: 'REMARKS1'           ,text:'비고1'              ,type:'string'  },
//           {name: 'REMARKS2'           ,text:'비고2'              ,type:'string'  },
//           {name: 'BASIS_SER_NO'       ,text:'근거번호'             ,type:'string'  }
          setBLData:function(params){           
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('PAY_DATE',              UniDate.get('today'));
            grdRecord.set('PAY_AMT',              0);
            grdRecord.set('PAY_EXCHANGE_RATE',              0);
            grdRecord.set('PAY_AMT_WON',              0);
            grdRecord.set('AMT_SUB_PM',              0);
            grdRecord.set('BL_EXCHANGE_RATE',              0);            
            
            grdRecord.set('NEGO_SER_NO',              params.BL_SER_NO);
            grdRecord.set('IMPORTER',              params.IMPORTER);
            grdRecord.set('IMPORTER_NM',              params.IMPORTER_NM);
            grdRecord.set('EXPORTER',              params.EXPORTER);
            grdRecord.set('EXPORTER_NM',              params.EXPORTER_NM);
            grdRecord.set('BL_AMT',              params.BL_AMT - params.RECEIVE_AMT);
            grdRecord.set('AMT_UNIT',              params.AMT_UNIT);
            grdRecord.set('BL_EXCHANGE_RATE',              params.EXCHANGE_RATE);
            grdRecord.set('PAY_AMT_WON',              params.BL_AMT_WON);
            grdRecord.set('PAY_TERMS',              params.PAY_TERMS);
            grdRecord.set('PAY_DURING',              params.PAY_DURING);
            grdRecord.set('TERMS_PRICE',              params.TERMS_PRICE);
            grdRecord.set('PAY_METHODE',              params.PAY_METHODE);
            grdRecord.set('DIV_CODE',              params.DIV_CODE);
            grdRecord.set('TRADE_TYPE',              params.TRADE_TYPE);
            grdRecord.set('NATION_INOUT',              params.NATION_INOUT);
            grdRecord.set('PROJECT_NO',              params.PROJECT_NO);
            grdRecord.set('PROJECT_NAME',              params.PROJECT_NAME);
             
            grdRecord.set('PAY_AMT',              params.BL_AMT - params.RECEIVE_AMT);
            grdRecord.set('PAY_EXCHANGE_RATE',              params.EXCHANGE_RATE);
            grdRecord.set('BASIS_SER_NO',              params.BL_SER_NO);
            
//            grdRecord.set('NEGO_AMT',              params.BL_AMT);
//            grdRecord.set('AMT_UNIT',              params.AMT_UNIT);
//            grdRecord.set('PAY_EXCHANGE_RATE',              params.EXCHANGE_RATE);
//            grdRecord.set('BL_EXCHANGE_RATE',              params.EXCHANGE_RATE);
//            grdRecord.set('PAY_EXCHANGE_RATE',              params.EXCHANGE_RATE);
//            grdRecord.set('EXCHANGE_RATE',              params.EXCHANGE_RATE);
//            grdRecord.set('PAY_AMT',              params.BL_AMT);
//            var dNegoAmt = params.BL_AMT
//            var dNegoExchR = params.EXCHANGE_RATE 
//            var dPayAmt = params.BL_AMT
//            var dPayExchR = params.EXCHANGE_RATE
//            
//            grdRecord.set('NEGO_AMT_WON',              dNegoAmt * dNegoExchR);
//            grdRecord.set('PAY_AMT_WON',              dPayAmt * dPayExchR);
//            grdRecord.set('RE_AMT',              dNegoAmt - dPayAmt);
//            
//            grdRecord.set('PAY_TERMS',              params.PAY_TERMS);            
//            grdRecord.set('PAY_DURING',              params.PAY_DURING);
//            grdRecord.set('TERMS_PRICE',              params.TERMS_PRICE);
//            grdRecord.set('PAY_METHODE',              params.PAY_METHODE);
//            grdRecord.set('DIV_CODE',              params.DIV_CODE);
//            grdRecord.set('TRADE_TYPE',              params.TRADE_TYPE);
//            grdRecord.set('NATION_INOUT',              params.NATION_INOUT);
//            grdRecord.set('PROJECT_NO',              params.PROJECT_NO);
//            grdRecord.set('PROJECT_NAME',              params.PROJECT_NAME);            
        }          
    });
   
    /**
     * 상세 조회(Detail Form Panel)
     * @type 
     */
    var detailForm = Unilite.createForm('detailForm', {
//      region:'south',
//    	weight:-100,
//    	height:400,
//    	split:true,
    	disabled: false,
    	hidden: false,
    	masterGrid: masterGrid,
        autoScroll:true,
        border: false,
        padding: '0 0 0 1',       
        uniOpt:{
        	store : directMasterStore
        },
	    //for Form      
	    layout: {
	    	type: 'uniTable',
	    	columns: 3,
	    	tableAttrs:{cellpadding:5},
	    	tdAttrs: {valign:'top'}
	    },
	    masterGrid: masterGrid,
	    items : [{                 
            xtype: 'uniTextfield',
            name: 'NEGO_SER_NO',
            fieldLabel: '관리번호',
            readOnly: true
        },{
            fieldLabel: '지급일',
            name: 'PAY_DATE',
            xtype: 'uniDatefield',
            value: new Date(),
            allowBlank: false,
            colspan: 2
        },{
            xtype: 'uniCombobox',
            name: 'DIV_CODE',
            fieldLabel: 'OFFER사업장',
            comboType: 'BOR120',
            readOnly: true
        },{
            
            layout: {type:'uniTable', column:2},
            xtype: 'container',
            colspan: 2,
            items: [{
                xtype: 'uniTextfield',
                name: 'PROJECT_NO',
                fieldLabel: '프로젝트 NO',
                colspan: 2,
                readOnly: true
            },{
                xtype: 'uniTextfield',
                name: 'PROJECT_NAME',
                colspan: 2,
                readOnly: true
            }]
        },{
            fieldLabel: '<t:message code="system.label.trade.tradetype" default="무역종류"/>',
            name: 'TRADE_TYPE',
            xtype: 'uniCombobox',               
            comboType: 'AU',
            comboCode: 'T002',
            readOnly: true
        },{
            fieldLabel: '<t:message code="system.label.trade.domesticoverseasclass" default="국내외구분"/>',
            name: 'NATION_INOUT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'T109',
            allowBlank:false,
            holdable: 'hold',
            readOnly: true,
            colspan: 2,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                }
            }
        },{
            fieldLabel: '출금담당자',
            name: 'PAY_NM',
            xtype: 'uniCombobox',               
            comboType: 'AU',
            comboCode: 'S010',
            allowBlank: false
        },{
            fieldLabel: '출금사업장',
            name: 'PAY_DIVCODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            allowBlank: false,
            colspan: 2
        },{
            fieldLabel: '지급유형',
            name: 'COLET_TYPE',
            xtype: 'uniCombobox',               
            comboType: 'AU',
            comboCode: 'T060',
            allowBlank: false
        },
            Unilite.popup('BANK_BOOK',{
            fieldLabel: '<t:message code="system.label.trade.depositcode" default="예적금코드"/>',
            valueFieldName:'BANK_CODE',
            textFieldName:'BANK_NAME',
            validateBlank: false,
            colspan: 2,
            listeners: {
                applyextparam: function(popup) {
                    
                }
            }
        }),
            Unilite.popup('BANK',{
            fieldLabel: '지급은행',
            valueFieldName:'PAY_BANK',
            textFieldName:'PAY_BANK_NM',
            validateBlank: false,
            listeners: {
                applyextparam: function(popup) {
                    
                }
            }
        }),{                 
            xtype: 'uniTextfield',
            name: 'ACCOUNT_NO',
            fieldLabel: '계좌번호',
            colspan: 2
        },
            Unilite.popup('CUST',{
            fieldLabel: '<t:message code="system.label.trade.importer" default="수입자"/>',            
            validateBlank: false, 
            allowBlank: false,
            valueFieldName:'IMPORTER',
            textFieldName:'IMPORTER_NM',
            extParam: {'CUSTOM_TYPE':'1,2,3'},
            readOnly: true,
            listeners: {
                applyextparam: function(popup) {
                    popup.setExtParam({'CUSTOM_TYPE':'1,2,3'});
                }
            }
        }),
            Unilite.popup('CUST',{
            fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',            
            validateBlank: false, 
            valueFieldName:'EXPORTER',
            textFieldName:'EXPORTER_NM',
            extParam: {'CUSTOM_TYPE':'1,2,3'},
            allowBlank: false,
            readOnly: true,
            colspan: 2,
            listeners: {
                applyextparam: function(popup) {
                    popup.setExtParam({'CUSTOM_TYPE':'1,2,3'});
                }
            }
        }),{ 
            name: 'TERMS_PRICE',         
            fieldLabel: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>',      
            xtype:'uniCombobox',   
            comboType:'AU', 
            comboCode:'T005',
            readOnly: true
        },{
            
            layout: {type:'uniTable', column:2},
            xtype: 'container',
            colspan: 2,
            items: [{
                    name: 'PAY_TERMS',         
                    fieldLabel: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>',      
                    xtype:'uniCombobox',   
                    comboType:'AU', 
                    comboCode:'T006',
                    flex: 2,
                    readOnly: true
                },{                 
                    xtype: 'uniTextfield',
                    name: 'PAY_DURING',
                    flex: 1,
                    width: 79,
                    suffixTpl: 'Days',
                    readOnly: true
                }
            ]
        },{
            
            layout: {type:'uniTable', column:2},
            xtype: 'container',
            items: [{
                    name: 'PAY_AMT',
                    fieldLabel: '지급액',
                    xtype:'uniNumberfield',
                    flex: 2,
                    value: 0,
                    allowBlank:false
                },{
                    xtype:'uniCombobox',
                    name: 'AMT_UNIT',
                    comboType:'AU', 
                    comboCode:'B004',
                    flex: 1,
                    width: 50,
                    displayField: 'value',
                    fieldStyle: 'text-align: center;',
                    readOnly: true
                }
            ]
        }, {
            fieldLabel: '<t:message code="system.label.trade.exchangerate" default="환율"/>',
            name: 'PAY_EXCHANGE_RATE',
            xtype: 'uniNumberfield',
            holdable: 'hold',
            decimalPrecision: 4,
            value: 1,
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                       
                    panelResult.setValue('EXCHANGE_RATE', newValue);
                }
            }
        }, {
            fieldLabel: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>',
            name: 'PAY_AMT_WON',
            xtype: 'uniNumberfield',
            value: 0,
            readOnly: true
        }, {
            fieldLabel: '환차손익',
            name: 'AMT_SUB_PM',
            xtype: 'uniNumberfield',
            value: 0,
            readOnly: true
        }, {
            fieldLabel: 'B/L <t:message code="system.label.trade.exchangerate" default="환율"/>',
            name: 'BL_EXCHANGE_RATE',
            xtype: 'uniNumberfield',
            value: 0,
            decimalPrecision: 4,
            colspan: 2,
            readOnly: true
        },{
            fieldLabel: '비고1',
            xtype:'uniTextfield',
            name: 'REMARKS1',
            width: 730,
            colspan: 3
        },{
            fieldLabel: '비고2',
            xtype:'uniTextfield',
            name: 'REMARKS2',
            width: 730,
            colspan: 3
        },{
            fieldLabel: '근거번호',
            name: 'BASIS_SER_NO',
            xtype:'uniTextfield',
            readOnly: true
        }],
		listeners:{
			hide:function()	{
					masterGrid.show();
					if(panelSearch.getCollapsed()){		//panelSearch가 닫혀 있으면..
						panelResult.show();
					}
				}

   		}
	});
	
	    // B/L적용(참조) 폼
    var blSearch = Unilite.createSearchForm('issueForm', {
        
            layout :  {type : 'uniTable', columns : 2},
            items :[{
                fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>'  ,
                name: 'DIV_CODE',
                xtype:'uniCombobox',
                comboType:'BOR120',
                holdable: 'hold'
            }, {
                fieldLabel: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>',
                xtype: 'uniTextfield',
                name: 'BL_SER_NO'            
            }, {
                fieldLabel: 'B/L일',
                xtype: 'uniDateRangefield',
                startFieldName: 'BL_DATE_FR',
                endFieldName: 'BL_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },
                Unilite.popup('AGENT_CUST',{
                fieldLabel:'<t:message code="system.label.trade.exporter" default="수출자"/>'
            })]
    });

    // B/L적용(참조) 모델
                            

    Unilite.defineModel('tik100ukrvRefBLModel', {   
        fields: [           
            {name: 'DIV_CODE'              ,text: '<t:message code="system.label.trade.division" default="사업장"/>'              , type: 'string', comboType: "BOR120"},
            {name: 'BL_SER_NO'             ,text: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>'          , type: 'string'},
            {name: 'BL_NO'                 ,text: '<t:message code="system.label.trade.blno" default="B/L번호"/>'             , type: 'string'},
            {name: 'BL_DATE'               ,text: 'B/L일'              , type: 'uniDate'},
            {name: 'IMPORTER'              ,text: 'IMPORTER'          , type: 'string'},
            {name: 'IMPORTER_NM'           ,text: 'IMPORTER_NM'        , type: 'string'},
            {name: 'EXPORTER'              ,text: '<t:message code="system.label.trade.exporter" default="수출자"/>'              , type: 'string'},
            {name: 'EXPORTER_NM'           ,text: '수출자명'             , type: 'string'},
            {name: 'EXCHANGE_RATE'         ,text: 'EXCHANGE_RATE'      , type: 'string'},
            {name: 'AMT_UNIT'              ,text: 'AMT_UNIT'           , type: 'string'},
            {name: 'PAY_TERMS'             ,text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'             , type: 'string', comboType:'AU', comboCode:'T006'},
            {name: 'PAY_METHODE'           ,text: 'PAY_METHODE'        , type: 'string'},
            {name: 'TERMS_PRICE'           ,text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'             , type: 'string', comboType:'AU', comboCode:'T005'},
            {name: 'PAY_DURING'            ,text: 'PAY_DURING'         , type: 'string'},
            {name: 'SO_SER_NO'             ,text: 'SO_SER_NO'          , type: 'string'},
            {name: 'LC_SER_NO'             ,text: 'LC_SER_NO'          , type: 'string'},
            {name: 'VESSEL_NAME'           ,text: 'VESSEL_NAME'        , type: 'string'},
            {name: 'VESSEL_NATION_CODE'    ,text: 'VESSEL_NATION_CODE' , type: 'string'},
            {name: 'DEST_PORT'             ,text: 'DEST_PORT'          , type: 'string'},
            {name: 'DEST_PORT_NM'          ,text: 'DEST_PORT_NM'       , type: 'string'},
            {name: 'SHIP_PORT'             ,text: 'SHIP_PORT'          , type: 'string'},
            {name: 'SHIP_PORT_NM'          ,text: 'SHIP_PORT_NM'       , type: 'string'},
            {name: 'PACKING_TYPE'          ,text: 'PACKING_TYPE'       , type: 'string'},
            {name: 'GROSS_WEIGHT'          ,text: 'GROSS_WEIGHT'       , type: 'string'},
            {name: 'WEIGHT_UNIT'           ,text: 'WEIGHT_UNIT'        , type: 'string'},
            {name: 'DATE_SHIPPING'         ,text: 'DATE_SHIPPING'      , type: 'string'},
            {name: 'BL_AMT'                ,text: 'BL_AMT'             , type: 'string'},
            {name: 'BL_AMT_WON'            ,text: 'BL_AMT_WON'         , type: 'string'},
            {name: 'TRADE_TYPE'            ,text: 'TRADE_TYPE'         , type: 'string'},
            {name: 'NATION_INOUT'          ,text: 'NATION_INOUT'       , type: 'string'},
            {name: 'PROJECT_NO'            ,text: '프로젝트번호'       , type: 'string'},
            {name: 'RECEIVE_AMT'           ,text: 'RECEIVE_AMT'        , type: 'string'},
            {name: 'PROJECT_NAME'          ,text: 'PROJECT_NAME'       , type: 'string'},
            {name: 'EXPENSE_FLAG'          ,text: 'EXPENSE_FLAG'       , type: 'string'},
            {name: 'INVOICE_NO'            ,text: 'INVOICE_NO'         , type: 'string'},
            {name: 'CUSTOMS'               ,text: 'CUSTOMS'            , type: 'string'},
            {name: 'EP_TYPE'               ,text: 'EP_TYPE'            , type: 'string'},
            {name: 'LC_NO'                 ,text: 'LC_NO'              , type: 'string'}
        ]
    });

    // B/L적용(참조) 스토어
    var blStore = Unilite.createStore('tik100ukrvRefBLStore', {
            model: 'tik100ukrvRefBLModel',
            autoLoad: false,
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read    : 'tik100ukrvService.selectBLList'                   
                }
            },
            listeners:{
                load:function(store, records, successful, eOpts)    {
                    if(successful)  {
                    	
                    }
                }
            }
            ,loadStoreRecords : function()  {
                var param= blSearch.getValues();         
                console.log( param );
                this.load({
                    params : param
                });
            }
//            groupField: 'SO_SER_NO'
    });

    // B/L적용(참조) 그리드
    var blGrid = Unilite.createGrid('tik100ukrvRefBLGrid', {
        // title: '기본',
        layout : 'fit',
        store: blStore,
        selModel:'rowmodel',
        columns:  [                     
                 { dataIndex: 'DIV_CODE'              ,  width:120},
                 { dataIndex: 'BL_SER_NO'             ,  width:120},
                 { dataIndex: 'BL_NO'                 ,  width:120},
                 { dataIndex: 'BL_DATE'               ,  width:120},
                 { dataIndex: 'IMPORTER'              ,  width:120, hidden: true},
                 { dataIndex: 'IMPORTER_NM'           ,  width:120, hidden: true},
                 { dataIndex: 'EXPORTER'              ,  width:120, hidden: true},
                 { dataIndex: 'EXPORTER_NM'           ,  width:120},
                 { dataIndex: 'EXCHANGE_RATE'         ,  width:120, hidden: true},
                 { dataIndex: 'AMT_UNIT'              ,  width:120, hidden: true},
                 { dataIndex: 'PAY_TERMS'             ,  width:120},
                 { dataIndex: 'PAY_METHODE'           ,  width:120, hidden: true},
                 { dataIndex: 'TERMS_PRICE'           ,  width:120},
                 { dataIndex: 'PAY_DURING'            ,  width:120, hidden: true},
                 { dataIndex: 'SO_SER_NO'             ,  width:120, hidden: true},
                 { dataIndex: 'LC_SER_NO'             ,  width:120, hidden: true},
                 { dataIndex: 'VESSEL_NAME'           ,  width:120, hidden: true},
                 { dataIndex: 'VESSEL_NATION_CODE'    ,  width:120, hidden: true},
                 { dataIndex: 'DEST_PORT'             ,  width:120, hidden: true},
                 { dataIndex: 'DEST_PORT_NM'          ,  width:120, hidden: true},
                 { dataIndex: 'SHIP_PORT'             ,  width:120, hidden: true},
                 { dataIndex: 'SHIP_PORT_NM'          ,  width:120, hidden: true},
                 { dataIndex: 'PACKING_TYPE'          ,  width:120, hidden: true},
                 { dataIndex: 'GROSS_WEIGHT'          ,  width:120, hidden: true},
                 { dataIndex: 'WEIGHT_UNIT'           ,  width:120, hidden: true},
                 { dataIndex: 'DATE_SHIPPING'         ,  width:120, hidden: true},
                 { dataIndex: 'BL_AMT'                ,  width:120, hidden: true},
                 { dataIndex: 'BL_AMT_WON'            ,  width:120, hidden: true},
                 { dataIndex: 'TRADE_TYPE'            ,  width:120, hidden: true},
                 { dataIndex: 'NATION_INOUT'          ,  width:120, hidden: true},
                 { dataIndex: 'PROJECT_NO'            ,  width:120, hidden: true},
                 { dataIndex: 'RECEIVE_AMT'           ,  width:120, hidden: true},
                 { dataIndex: 'PROJECT_NAME'          ,  width:120, hidden: true},
                 { dataIndex: 'EXPENSE_FLAG'          ,  width:120, hidden: true},
                 { dataIndex: 'INVOICE_NO'            ,  width:120, hidden: true},
                 { dataIndex: 'CUSTOMS'               ,  width:120, hidden: true},
                 { dataIndex: 'EP_TYPE'               ,  width:120, hidden: true},
                 { dataIndex: 'LC_NO'                 ,  width:120, hidden: true}
          ] 
       ,listeners: {    
                onGridDblClick:function(grid, record, cellIndex, colName) {
                    masterGrid.reset(); 
                    blGrid.returnData();
                    referBLWindow.hide();
                }
            }
        ,returnData: function() {
            var records = this.getSelectedRecords();
            
            Ext.each(records, function(record,i){
//              if(!UniAppManager.app.fnRefCreditCheck()) {
//                  directMasterStore.removeAt(0);
//                  return false;
//              }
                UniAppManager.app.onNewDataButtonDown(); //알림창 없는 함수
                masterGrid.setBLData(record.data);               
            }); 
//            directMasterStore.fnSaleAmtSum();
//            UniAppManager.app.fnCreditCheck(); //여신액 체크
            this.deleteSelectedRow();
        }
         
    });
    
    // B/L적용(참조) 메인
    function openReferBLWindow() {
        if(!referBLWindow) {
            referBLWindow = Ext.create('widget.uniDetailWindow', {
                title: 'B/L적용(참조)',
                width: 950,                             
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                
                items: [blSearch, blGrid],
                tbar:  ['->',
                                        {   itemId : 'saveBtn',
                                            text: '<t:message code="system.label.trade.inquiry" default="조회"/>',
                                            handler: function() {
                                                blStore.loadStoreRecords();
                                            },
                                            disabled: false
                                        }, 
                                        {   itemId : 'confirmBtn',
                                            text: 'B/L적용',
                                            handler: function() {
                                                blGrid.returnData();
                                            },
                                            disabled: false
                                        },
                                        {   itemId : 'confirmCloseBtn',
                                            text: 'B/L적용 후 닫기',
                                            handler: function() {
                                                blGrid.returnData();
                                                referBLWindow.hide();
                                            },
                                            disabled: false
                                        },{
                                            itemId : 'closeBtn',
                                            text: '<t:message code="system.label.trade.close" default="닫기"/>',
                                            handler: function() {
                                                if(directMasterStore.getCount() == 0){
//                                                    panelSearch.setAllFieldsReadOnly(false);
//                                                    panelResult.setAllFieldsReadOnly(false);
                                                }
                                                referBLWindow.hide();
                                            },
                                            disabled: false
                                        }
                                ]
                            ,
                listeners : {beforehide: function(me, eOpt) {
                                             blSearch.clearForm();
                                             blGrid.reset();
                                        },
                             beforeclose: function( panel, eOpts )  {
                                             blSearch.clearForm();
                                             blGrid.reset();
                                        },
                             beforeshow: function ( me, eOpts ) {
//                                if(!UniAppManager.app.fnCreditCheck()) return false;
                                blSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
                                blSearch.setValue('BL_DATE_FR', UniDate.get('startOfMonth'));
                                blSearch.setValue('BL_DATE_TO', UniDate.get('today'));
                                blStore.loadStoreRecords();
                             }
                }
            })
        }
        referBLWindow.center();
        referBLWindow.show();
    }
    
    
    Unilite.Main({
    	id  : 'tik100ukrvApp',
		borderItems : [
			panelSearch,
			panelResult,
			{	region:'center',
				//layout : 'border',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				autoScroll:true,
				tools: [
//					{
//						type: 'hum-grid',					            
//			            handler: function () {
//			            	detailForm.hide();
//			                //masterGrid.show();
//			            	//panelResult.show();
//			            }
//					},{
//			
//						type: 'hum-photo',					            
//			            handler: function () {
//			            	/*
//			            	var edit = masterGrid.findPlugin('cellediting');
//							if(edit && edit.editing)	{
//								setTimeout("edit.completeEdit()", 1000);
//							}
//							*/
//			                masterGrid.hide();
//			                panelResult.hide();
//			                //detailForm.show();
//			            }
//					}
				],
				items:[					
					masterGrid, 
					detailForm					
				]
			}
		],		
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['reset', 'detail'],true);		
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			detailForm.setValue('NEGO_DATE', UniDate.get('today'));
			detailForm.setValue('BL_EXCHANGE_RATE', '1');
			detailForm.setValue('PAY_EXCHANGE_RATE', '1');
			detailForm.setValue('EXCHANGE_RATE', '1');		
			
			Ext.getCmp('ChargeInput').setDisabled(true);
		},
		
		onSaveAsExcelButtonDown: function() {
			var masterGrid = Ext.getCmp('tik100ukrvGrid');
			 masterGrid.downloadExcelXml();
		},
		
		onQueryButtonDown : function()	{
//			detailForm.clearForm ();
			if(!panelSearch.getInvalidMessage()) return;
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			masterGrid.createRow();
//			openDetailWindow(null, true);	
		},	
		onSaveDataButtonDown: function (config) {
			
			directMasterStore.saveStore(config);
							
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			detailForm.clearForm();
			UniAppManager.app.fnInitBinding();
//			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		},
		fnAmtSub: function(){
		
		}
	});	// Main
	
	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(fieldName == "PAY_AMT") { 			// 지급액
				if(newValue < 0 ) {
					rv = Msg.sMB076;
				}
				record.set('PAY_AMT_WON', newValue * record.get('PAY_EXCHANGE_RATE'));
				var dAmtSubPm = 0;  //환차손익
				dAmtSubPm = (record.get('PAY_EXCHANGE_RATE') - record.get('BL_EXCHANGE_RATE')) * newValue;  
				record.set('AMT_SUB_PM', dAmtSubPm);
			}else if(fieldName == "PAY_EXCHANGE_RATE"){ // <t:message code="system.label.trade.exchangerate" default="환율"/>
                if(newValue < 0 ) {
                    rv = Msg.sMB076;
                }
                record.set('PAY_AMT_WON', record.get('PAY_AMT') * newValue);
                var dAmtSubPm = 0;  //환차손익
                dAmtSubPm = (newValue - record.get('BL_EXCHANGE_RATE')) * record.get('PAY_AMT');  
                record.set('AMT_SUB_PM', dAmtSubPm);
			}
				
			return rv;
		}
	}); // validator
	
	
}; // main


</script>


