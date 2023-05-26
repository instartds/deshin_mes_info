<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="ten200ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="tes100ukrv"/><!-- 사업장    -->  
    <t:ExtComboStore comboType="AU" comboCode="T002"/>  <!-- 무역종류  -->
    <t:ExtComboStore comboType="AU" comboCode="T005"/>  <!-- 가격조건 -->
    <t:ExtComboStore comboType="AU" comboCode="T006"/>  <!-- 결제조건  -->
    <t:ExtComboStore comboType="AU" comboCode="T002"/>  <!-- 무역종류  -->
    <t:ExtComboStore comboType="AU" comboCode="S010"/>  <!-- 영업담당  -->
    <t:ExtComboStore comboType="AU" comboCode="T060"/>  <!-- 입금유형  -->
    <t:ExtComboStore comboType="AU" comboCode="B004"/>  <!-- 화폐단위       -->
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
	Unilite.defineModel('ten200ukrvModel', {
		// pkGen : user, system(default)
	    fields: [
	       {name: 'NEGO_SER_NO'      ,text:'<t:message code="system.label.trade.negomanageno" default="NEGO 관리번호"/>'          ,type:'string'  },
           {name: 'NEGO_DATE'        ,text:'<t:message code="system.label.trade.depositdate" default="입금일"/>'            ,type:'uniDate', allowBlank: false  },
           {name: 'DIV_CODE'         ,text:'OFFER사업장'       ,type:'string'  },
           {name: 'TRADE_TYPE'       ,text:'<t:message code="system.label.trade.tradetype" default="무역종류"/>'          ,type:'string'  },
           {name: 'PROJECT_NO'       ,text:'프로젝트번호'      ,type:'string'  },
           {name: 'PROJECT_NAME'     ,text:'프로젝트명'       ,type:'string'  },
           {name: 'NEGO_NM'          ,text:'입금담당'          ,type:'string', allowBlank: false  },
           {name: 'PAY_DIV'          ,text:'입금사업장'        ,type:'string', allowBlank: false  },
           {name: 'COLET_TYPE'       ,text:'<t:message code="system.label.trade.deposittype" default="입금유형"/>'          ,type:'string', allowBlank: false  },
           {name: 'BANK_BOOK_CODE'   ,text:'<t:message code="system.label.trade.depositcode" default="예적금코드"/>'            ,type:'string'  },
           {name: 'BANK_BOOK_NAME'   ,text:'<t:message code="system.label.trade.depositname" default="예적금명"/>'          ,type:'string'  },
           {name: 'BANK_CODE'        ,text:'매입은행'          ,type:'string'  },
           {name: 'BANK_NAME'        ,text:'매입은행명'        ,type:'string'  },
           {name: 'ACCOUNT_NO'       ,text:'계좌번호'          ,type:'string'  },
           {name: 'IMPORTER'         ,text:'<t:message code="system.label.trade.importer" default="수입자"/>'            ,type:'string'  },
           {name: 'IMPORTER_NM'      ,text:'수입자명'          ,type:'string'  },
           {name: 'EXPORTER'         ,text:'<t:message code="system.label.trade.exporter" default="수출자"/>'            ,type:'string'  },
           {name: 'EXPORTER_NM'      ,text:'수출자명'          ,type:'string'  },
           {name: 'TERMS_PRICE'      ,text:'<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'          ,type:'string'  },
           {name: 'PAY_TERMS'        ,text:'<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'          ,type:'string'  },
           {name: 'PAY_DURING'       ,text:'day'               ,type:'string'  },
           {name: 'PAY_AMT'          ,text:'입금액'            ,type:'uniPrice', allowBlank: false  },
           {name: 'PAY_EXCHANGE_RATE',text:'<t:message code="system.label.trade.exchangerate" default="환율"/>'              ,type:'string', allowBlank: false  },
           {name: 'PAY_AMT_WON'      ,text:'<t:message code="system.label.trade.exchangeamount" default="환산액 "/>'            ,type:'uniPrice'  },
           {name: 'AMT_SUB_PM'       ,text:'환차손익'          ,type:'uniPrice'  },
           {name: 'BL_EXCHANGE_RATE' ,text:'<t:message code="system.label.trade.blexchangerate" default="B/L환율"/>'          ,type:'string'  },
           {name: 'REMARKS1'         ,text:'비고1'             ,type:'string'  },
           {name: 'REMARKS2'         ,text:'비고2'             ,type:'string'  },
           {name: 'BASIS_SER_NO'     ,text:'근거번호'          ,type:'string'  },
           {name: 'NATION_INOUT'     ,text:'국내외'            ,type:'string'  },           
           {name: 'NEGO_AMT'         ,text:'NEGO_AMT'          ,type:'uniPrice'  },
           {name: 'AMT_UNIT'         ,text:'AMT_UNIT'          ,type:'string'  },
           {name: 'NEGO_AMT_WON'     ,text:'NEGO_AMT_WON'      ,type:'uniPrice'  },
           {name: 'RE_AMT'           ,text:'RE_AMT'            ,type:'uniPrice'  },
           {name: 'PAY_METHODE'      ,text:'PAY_METHODE'       ,type:'string'  },
           {name: 'EXCHANGE_RATE'    ,text:'EXCHANGE_RATE'     ,type:'string'  }
		]
	});

	

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ten200ukrvService.selectDetail',
			update	: 'ten200ukrvService.updateDetail',
			create	: 'ten200ukrvService.insertDetail',
			destroy	: 'ten200ukrvService.deleteDetail',
			syncAll	: 'ten200ukrvService.saveAll'
		}
	});	 
	
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('ten200ukrvMasterStore',{
			model: 'ten200ukrvModel',
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
				var param= panelSearch.getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},			
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				var paramMaster= panelSearch.getValues();    //syncAll 수정
				if(inValidRecs.length == 0 )	{
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
			}
		});	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
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
                Unilite.popup('NEGO_SER_NO',{
                fieldLabel: '관리번호',
                allowBlank:false,
                listeners: {
                    applyextparam: function(popup) {
                        
                    },
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('NEGO_SER_NO', panelSearch.getValue('NEGO_SER_NO'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('NEGO_SER_NO', panelSearch.getValue('NEGO_SER_NO'));
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
		layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '99.5%'}},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
            fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            value: UserInfo.divCode,
            tdAttrs: {width: 340},
            labelWidth: 95,
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                       
//                    panelSearch.setValue('AMT_UNIT', newValue);
//                    UniAppManager.app.fnExchngRateO();
                }
            }
        },
            Unilite.popup('NEGO_SER_NO',{
            fieldLabel: '관리번호',
            allowBlank:false,
            listeners: {
                applyextparam: function(popup) {
                    
                },
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('NEGO_SER_NO', panelResult.getValue('NEGO_SER_NO'));
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('NEGO_SER_NO', panelResult.getValue('NEGO_SER_NO'));
                }
            }
        }),{                        
           width: 100,
           xtype: 'button',
           text: 'B/L적용',
           tdAttrs: {align: 'right'},
           margin: '0 0 2 0',
           handler : function() {
                openReferBLWindow();
           }
        }]	
    });
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('ten200ukrvGrid', {
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
            {dataIndex:'NEGO_SER_NO'      ,width:80, hideable:false},
            {dataIndex:'NEGO_DATE'        ,width:80, hideable:false},
            {dataIndex:'DIV_CODE'         ,width:80, hideable:false},
            {dataIndex:'TRADE_TYPE'       ,width:80, hideable:false},
            {dataIndex:'PROJECT_NO'       ,width:80, hideable:false},
            {dataIndex:'NEGO_NM'          ,width:80, hideable:false},
            {dataIndex:'PAY_DIV'          ,width:80, hideable:false},
            {dataIndex:'COLET_TYPE'       ,width:80, hideable:false},
            {dataIndex:'BANK_BOOK_CODE'   ,width:80, hideable:false},
            {dataIndex:'BANK_BOOK_NAME'   ,width:80, hideable:false},
            {dataIndex:'BANK_CODE'        ,width:80, hideable:false},
            {dataIndex:'BANK_NAME'        ,width:80, hideable:false},
            {dataIndex:'ACCOUNT_NO'       ,width:80, hideable:false},
            {dataIndex:'IMPORTER'         ,width:80, hideable:false},
            {dataIndex:'IMPORTER_NM'      ,width:80, hideable:false},
            {dataIndex:'EXPORTER'         ,width:80, hideable:false},
            {dataIndex:'EXPORTER_NM'      ,width:80, hideable:false},
            {dataIndex:'TERMS_PRICE'      ,width:80, hideable:false},
            {dataIndex:'PAY_TERMS'        ,width:80, hideable:false},
            {dataIndex:'PAY_DURING'       ,width:80, hideable:false},
            {dataIndex:'PAY_AMT'          ,width:80, hideable:false},
            {dataIndex:'PAY_EXCHANGE_RATE',width:80, hideable:false},
            {dataIndex:'PAY_AMT_WON'      ,width:80, hideable:false},
            {dataIndex:'AMT_SUB_PM'       ,width:80, hideable:false},
            {dataIndex:'BL_EXCHANGE_RATE' ,width:80, hideable:false},
            {dataIndex:'REMARKS1'         ,width:80, hideable:false},
            {dataIndex:'REMARKS2'         ,width:80, hideable:false},
            {dataIndex:'BASIS_SER_NO'     ,width:80, hideable:false},
            {dataIndex:'NATION_INOUT'     ,width:80, hideable:false},     
            
            {dataIndex:'NEGO_AMT'         ,width:80, hideable:false},
            {dataIndex:'AMT_UNIT'         ,width:80, hideable:false},
            {dataIndex:'NEGO_AMT_WON'     ,width:80, hideable:false},
            {dataIndex:'RE_AMT'           ,width:80, hideable:false},
            {dataIndex:'PAY_METHODE'      ,width:80, hideable:false},
            {dataIndex:'EXCHANGE_RATE'    ,width:80, hideable:false}
            
            
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
          setBLData:function(params){
          	detailForm.clearForm();
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            detailForm.setValue('NEGO_DATE', UniDate.get('today'));
            detailForm.setValue('BL_EXCHANGE_RATE', '1');
            detailForm.setValue('PAY_EXCHANGE_RATE', '1');
            detailForm.setValue('EXCHANGE_RATE', '1');
            
            var grdRecord = this.getSelectedRecord();
//            grdRecord.set('NEGO_SER_NO',              params.BL_SER_NO);
            grdRecord.set('IMPORTER',              params.IMPORTER);
            grdRecord.set('IMPORTER_NM',              params.IMPORTER_NM);
            grdRecord.set('EXPORTER',              params.EXPORTER);
            grdRecord.set('EXPORTER_NM',              params.EXPORTER_NM);
            grdRecord.set('NEGO_AMT',              params.BL_AMT);
            grdRecord.set('AMT_UNIT',              params.AMT_UNIT);
            grdRecord.set('PAY_EXCHANGE_RATE',              params.EXCHANGE_RATE);
            grdRecord.set('BL_EXCHANGE_RATE',              params.EXCHANGE_RATE);
            grdRecord.set('PAY_EXCHANGE_RATE',              params.EXCHANGE_RATE);
            grdRecord.set('EXCHANGE_RATE',              params.EXCHANGE_RATE);
            grdRecord.set('PAY_AMT',              params.BL_AMT);
            var dNegoAmt = params.BL_AMT
            var dNegoExchR = params.EXCHANGE_RATE 
            var dPayAmt = params.BL_AMT
            var dPayExchR = params.EXCHANGE_RATE
            
            grdRecord.set('NEGO_AMT_WON',              dNegoAmt * dNegoExchR);
            grdRecord.set('PAY_AMT_WON',              dPayAmt * dPayExchR);
            grdRecord.set('RE_AMT',              dNegoAmt - dPayAmt);
            
            grdRecord.set('PAY_TERMS',              params.PAY_TERMS);            
            grdRecord.set('PAY_DURING',              params.PAY_DURING);
            grdRecord.set('TERMS_PRICE',              params.TERMS_PRICE);
            grdRecord.set('PAY_METHODE',              params.PAY_METHODE);
            grdRecord.set('DIV_CODE',              params.DIV_CODE);
            grdRecord.set('TRADE_TYPE',              params.TRADE_TYPE);
            grdRecord.set('NATION_INOUT',              params.NATION_INOUT);
            grdRecord.set('PROJECT_NO',              params.PROJECT_NO);
            grdRecord.set('PROJECT_NAME',              params.PROJECT_NAME);    
            grdRecord.set('BASIS_SER_NO',              params.BL_SER_NO);    
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
            fieldLabel: '<t:message code="system.label.trade.depositdate" default="입금일"/>',
            name: 'NEGO_DATE',
            xtype: 'uniDatefield',
            value: new Date(),
            allowBlank: false,
            colspan: 2
        },{
            xtype: 'uniCombobox',
            name: 'DIV_CODE',
            fieldLabel: 'OFFER사업장',
            comboType: 'BOR120',
            colspan: 3,
            readOnly: true
        },{
            fieldLabel: '<t:message code="system.label.trade.tradetype" default="무역종류"/>',
            name: 'TRADE_TYPE',
            xtype: 'uniCombobox',               
            comboType: 'AU',
            comboCode: 'T002',
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
            fieldLabel: '입금담당',
            name: 'NEGO_NM',
            xtype: 'uniCombobox',               
            comboType: 'AU',
            comboCode: 'S010',
            allowBlank: false
        },{
            fieldLabel: '입금사업장',
            name: 'PAY_DIV',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            allowBlank: false,
            colspan: 2
        },{
            fieldLabel: '<t:message code="system.label.trade.deposittype" default="입금유형"/>',
            name: 'COLET_TYPE',
            xtype: 'uniCombobox',               
            comboType: 'AU',
            comboCode: 'T060',
            allowBlank: false
        },
            Unilite.popup('BANK_BOOK',{
            fieldLabel: '<t:message code="system.label.trade.depositcode" default="예적금코드"/>',
            valueFieldName:'BANK_BOOK_CODE',
            textFieldName:'BANK_BOOK_NAME',
            validateBlank: false,
            colspan: 2,
            listeners: {
                applyextparam: function(popup) {
                    
                }
            }
        }),
            Unilite.popup('BANK',{
            fieldLabel: '매입은행',
            valueFieldName:'BANK_CODE',
            textFieldName:'BANK_NAME',
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
                    fieldLabel: '입금액',
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
        },{
            fieldLabel: '국내외',
            name: 'NATION_INOUT',
            xtype:'uniTextfield',
            hidden: true
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
                fieldLabel: '<t:message code="system.label.trade.writtendate" default="작성일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'BL_DATE_FR',
                endFieldName: 'BL_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },
                Unilite.popup('AGENT_CUST',{
                fieldLabel:'<t:message code="system.label.trade.importer" default="수입자"/>'
            })]
    });

    // B/L적용(참조) 모델
    Unilite.defineModel('ten200ukrvRefBLModel', {   
        fields: [           
            {name: 'DIV_CODE'	            ,text: '<t:message code="system.label.trade.division" default="사업장"/>'               , type: 'string', comboType: "BOR120"},
            {name: 'BL_SER_NO'              ,text: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>'           , type: 'string'},
            {name: 'BL_NO'    	            ,text: '<t:message code="system.label.trade.blno" default="B/L번호"/>'              , type: 'string'},
            {name: 'BL_DATE'		        ,text: 'B/L발행일'            , type: 'uniDate'},
            {name: 'IMPORTER_NM'            ,text: '<t:message code="system.label.trade.importer" default="수입자"/>'               , type: 'string'},
            {name: 'PAY_TERMS'              ,text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'              , type: 'string', comboType:"AU", comboCode:"T006"},
            {name: 'TERMS_PRICE'            ,text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'              , type: 'string', comboType:"AU", comboCode:"T005"}, 
            {name: 'TRADE_TYPE'	            ,text: 'TRADE_TYPE'	        , type: 'string'},
            {name: 'NATION_INOUT'	        ,text: 'NATION_INOUT'	    , type: 'string'},
            {name: 'PROJECT_NO'	            ,text: 'PROJECT_NO'	        , type: 'string'},
            {name: 'PROJECT_NAME'	        ,text: 'PROJECT_NAME'	    , type: 'string'},
            {name: 'PASS_SER_NO'	        ,text: 'PASS_SER_NO'	    , type: 'string'},
            {name: 'PAY_METHODE'	        ,text: 'PAY_METHODE'	    , type: 'string'},
            {name: 'PAY_DURING'	            ,text: 'PAY_DURING'	        , type: 'string'},
            {name: 'SO_SER_NO'		        ,text: 'SO_SER_NO'		    , type: 'string'},
            {name: 'LC_SER_NO'		        ,text: 'LC_SER_NO'		    , type: 'string'},
            {name: 'IMPORTER' 		        ,text: 'IMPORTER' 		    , type: 'string'},
            {name: 'EXPORTER_NM' 	        ,text: 'EXPORTER_NM' 	    , type: 'string'},
            {name: 'EXPORTER' 		        ,text: 'EXPORTER' 		    , type: 'string'},
            {name: 'BL_AMT' 		        ,text: 'BL_AMT' 		    , type: 'string'},
            {name: 'AMT_UNIT' 		        ,text: 'AMT_UNIT' 		    , type: 'string'},
            {name: 'EXCHANGE_RATE'          ,text: 'EXCHANGE_RATE'      , type: 'string'},
            {name: 'BL_AMT_WON' 	        ,text: 'BL_AMT_WON' 	    , type: 'string'}
        ]
    });

    // B/L적용(참조) 스토어
    var blStore = Unilite.createStore('ten200ukrvRefBLStore', {
            model: 'ten200ukrvRefBLModel',
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
                    read    : 'ten200ukrvService.selectBLList'                   
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
    var blGrid = Unilite.createGrid('ten200ukrvRefBLGrid', {
        // title: '기본',
        layout : 'fit',
        store: blStore,
        selModel:'rowmodel',
        columns:  [                      
                 { dataIndex: 'DIV_CODE'	           ,  width:120},
                 { dataIndex: 'BL_SER_NO'              ,  width:100},
                 { dataIndex: 'BL_NO'    	           ,  width:100},
                 { dataIndex: 'BL_DATE'		           ,  width:100},
                 { dataIndex: 'IMPORTER_NM'            ,  width:100},
                 { dataIndex: 'PAY_TERMS'              ,  width:100},
                 { dataIndex: 'TERMS_PRICE'            ,  width:100},
                 { dataIndex: 'TRADE_TYPE'	           ,  width:100, hidden: true},
                 { dataIndex: 'NATION_INOUT'	       ,  width:100, hidden: true},
                 { dataIndex: 'PROJECT_NO'	           ,  width:100, hidden: true},
                 { dataIndex: 'PROJECT_NAME'	       ,  width:100, hidden: true},
                 { dataIndex: 'PASS_SER_NO'	           ,  width:100, hidden: true},
                 { dataIndex: 'PAY_METHODE'	           ,  width:100, hidden: true},
                 { dataIndex: 'PAY_DURING'	           ,  width:100, hidden: true},
                 { dataIndex: 'SO_SER_NO'		       ,  width:100, hidden: true},
                 { dataIndex: 'LC_SER_NO'		       ,  width:100, hidden: true},
                 { dataIndex: 'IMPORTER' 		       ,  width:100, hidden: true},
                 { dataIndex: 'EXPORTER_NM' 	       ,  width:100, hidden: true},
                 { dataIndex: 'EXPORTER' 		       ,  width:100, hidden: true},
                 { dataIndex: 'BL_AMT' 		           ,  width:100, hidden: true},
                 { dataIndex: 'AMT_UNIT' 		       ,  width:100, hidden: true},
                 { dataIndex: 'EXCHANGE_RATE'          ,  width:100, hidden: true},
                 { dataIndex: 'BL_AMT_WON' 	           ,  width:100, hidden: true}                                              
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
    	id  : 'ten200ukrvApp',
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
		},
		
		onSaveAsExcelButtonDown: function() {
			var masterGrid = Ext.getCmp('ten200ukrvGrid');
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


