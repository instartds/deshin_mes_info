<%@page language="java" contentType="text/html; charset=utf-8"%>

<script type="text/javascript" >
            
// Ext.onReady(function() {});
var PGM_ID = 'bsa100ukrv';
var STATE_INFO = new Object();
var SHT_INFO = '';
var PGM_TITLE = '엑셀업로드 Example';
var EXT_PGM_ID = 'bsa100ukrv';
var MANUAL_YN = 'N';
if(typeof UniAppManager !== 'undefined') UniAppManager.setPageTitle(PGM_TITLE);
// module : 11
Ext.define('UniFormat', {
	singleton: true,
	Qty:'0,000.00',
	UnitPrice:'0,000.000',
	Price:'0,000',
	FC:'0,000.00',
	ER:'0,000.0000',
	Percent:'0,000.00',
	FDATE: 'Y.m.d',
	FYM: 'Y.m'
}
);
var excelWindow;
function appMain() {
	//console.log('appMain');
	var excelConfigData = {
			name :'excelConfig',		
			desc :"수주정보",  
			validateService : "sof100ukrvService.excelValidate",
			sheet : {
				seq:"0",
				name:"수주정보",
				startRow:"1", 
				sqlId:"sof100ukrvServiceImpl.insertExcelSof112t", 
				validateFormName:"excelConfig",
				fields:[
					{
						name : "ITEM_CODE", 
						title : "ITEM_CODE",
						type : "string", 	//string|number|integer|date
						check : "true",
						comments: "Item No",
						samples:["A2U01-00002","A2U01-00004","위 2~3행 데이터는 예제데이타입니다. 작업시 2~3행 데이터는 삭제하시고 작업하세요"]
					},
					{
						name:"QTY",
						title:"수량", 
						type:"integer",  
						required:"true",	//true/false
						comments: "수량을 입력해 주세요",
						samples:["100","200"]
					},{
						name:"ITEM_NAME", 
						title:"품목명", 
						type:"string"
					},{
						name:"OUT_WH_CODE", 
						title:"창고코드", 
						type:"string"
					},{
						name:"NEW_CODE", 
						title:"test코드", 
						type:"string"
					}
				]
			}
		};
	var formValidateData = {
		name:"excelConfig",
		fields:[
			{
				name:'ITEM_CODE',
				required:'true',
				type:'string' //string|number|integer|date
			},{
				name:'QTY',
				required:'true',
				type:'integer'
			}
		]
	};
	var testForm = Ext.create('Unilite.com.form.UniDetailForm', {
		disabled : false,
		url:'/excel/samples/customSample.do',
		method:'POST',
        items: [
        	 {
				xtype: 'uniTextfield',
				fieldLabel:'Excel Type',
				name: 'type',
				hidden:true,
				value:"xlsx"
			},{
				xtype: 'uniTextfield',
				fieldLabel:'프로그램 ID',
				allowBlank:true,
				name: 'pgmId', // 고정 Name
				hidden:true,
				value:"excelConfig"
			},{
				xtype: 'textarea',
				name: 'excelConfig', // 고정 Name
				width:500,
				height:200,
				value:excelConfigData,
				allowBlank:true,
				hidden:true
			}, {
				xtype: 'textarea',
				name: 'validateConfig', // 고정 Name
				width:500,
				height:100,
				value:formValidateData,
				allowBlank:true,
				hidden:true
			}, {			
	        	xtype: 'button',
				id: 'sample',
				width: 200,
				text: 'Excel Upload',						   	
				handler : function() {
						var form = this.up('uniDetailForm');
						form.setValue('excelConfig',Ext.encode(excelConfigData)); // Ext.encode(jJsonData));
						form.setValue('validateConfig',Ext.encode(formValidateData)); // Ext.encode(jJsonData));
						
						Ext.Ajax.request({
						    url:  CPATH+'/excel/customConfig.do',//CPATH+'/excel/customSample.do',
						    params:form.getValues(),
						    success: function(response, opts) {
						    	var resJson = JSON.parse(response.responseText);
						    		openUploadWin(resJson.configId);  // configId : 생성된 Config xml
					        }

						});
						//form.submit();	
					
				}
			}
	     ]
	}); //testForm
	
	function openUploadWin(excelConfigName)	{
		var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';

        
        if(!excelWindow) {
            excelWindow =  Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
                    modal: false,
                    excelConfigName: excelConfigName,
                    extParam: { 
                        'DIV_CODE': '01',
                        'CUSTOM_CODE': '000000',
                        'MONEY_UNIT': 'KRW',
                        'ORDER_DATE': '20170101'
                    },
                    grids: [
                         {
                            itemId: 'grid01',
                            title: '수주정보',                              
                            useCheckbox: true,
                            model : 'excel.sof100.sheet01',
                            readApi: 'sof100ukrvService.selectExcelUploadSheet1',
                            columns: [
                                         { dataIndex: 'ITEM_CODE',          width: 120      } 
                                        ,{ dataIndex: 'QTY',                width: 80       } 
                                        ,{ dataIndex: 'ITEM_NAME',          width: 120      } 
                                        ,{ dataIndex: 'SPEC',               width: 120      } 
                                        ,{ dataIndex: 'PRICE',              width: 80       } 
                                        ,{ dataIndex: 'ORDER_UNIT',         width: 80       } 
                                        ,{ dataIndex: 'TRNS_RATE',          width: 80       } 
                                        ,{ dataIndex: 'ITEM_ACCOUNT',       width: 100      } 
                                        ,{ dataIndex: 'OUT_WH_CODE',        width: 100      } 
                                        ,{ dataIndex: 'WH_CODE',            width: 100      }                                    
                            ],
                            listeners: {
                                afterrender: function(grid) {   
                                    var me = this;
                                    
                                        this.contextMenu = Ext.create('Ext.menu.Menu', {});
                                        this.contextMenu.add(
                                            {   
                                                text: '상품정보 등록',   iconCls : '',
                                                handler: function(menuItem, event) {    
                                                    var records = grid.getSelectionModel().getSelection();
                                                    var record = records[0];
                                                    var params = {
                                                        appId: UniAppManager.getApp().id,
                                                        sender: me,
                                                        action: 'excelNew',
                                                        _EXCEL_JOBID: excelWindow.jobID,            //SOF112T Key1
                                                        _EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'), //SOF112T Key2
                                                        ITEM_CODE: record.get('ITEM_CODE'),
                                                        DIV_CODE: '01'
                                                    }
                                                    var rec = {data : {prgID : 'bpr101ukrv', 'text':''}};                                   
                                                    parent.openTab(rec, '/base/bpr101ukrv.do', params);                                                     
                                                }
                                            }
                                        );
                                        
                                        this.contextMenu.add(
                                            {   
                                                text: '도서정보 등록',   iconCls : '',
                                                handler: function(menuItem, event) {    
                                                    var records = grid.getSelectionModel().getSelection();
                                                    var record = records[0];
                                                    var params = {
                                                        appId: UniAppManager.getApp().id,
                                                        sender: me,
                                                        action: 'excelNew',
                                                        _EXCEL_JOBID: excelWindow.jobID,            //SOF112T Key1
                                                        _EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'), //SOF112T Key2
                                                        ITEM_CODE: record.get('ITEM_CODE'),
                                                        DIV_CODE: masterForm.getValue('DIV_CODE')
                                                    }
                                                    var rec = {data : {prgID : 'bpr102ukrv', 'text':''}};                                   
                                                    parent.openTab(rec, '/base/bpr102ukrv.do', params);                                                     
                                                }
                                            }
                                        );
                                        
                                        me.on('cellcontextmenu', function( view, cell, cellIndex, record, row, rowIndex, event ) {
                                            event.stopEvent();
                                            if(record.get('_EXCEL_HAS_ERROR') == 'Y')
                                                me.contextMenu.showAt(event.getXY());
                                        });
                                    
                                    
                                }
                            }
                            
                        }
                    ],
                    listeners: {
                        close: function() {
                            this.hide();
                        }
                    },
                    onApply:function()  {
                        var grid = this.down('#grid01');
                        var records = grid.getSelectionModel().getSelection();              
                        Ext.each(records, function(record,i){   
                                                    UniAppManager.app.onNewDataButtonDown();
                                                    detailGrid.setExcelData(record.data);                                       
                                                }); 
                        grid.getStore().remove(records);
                    }
             });
        }
        excelWindow.center();
        excelWindow.show();

    
	};
	Unilite.Excel.defineModel('excel.sof100.sheet01', {
        fields: [
                 {name: 'ITEM_CODE',    text:'품목코드',            type: 'string'},
                 {name: 'QTY',          text:'판매수량',            type: 'uniQty'},
                 {name: 'ITEM_NAME',    text:'품목명',             type: 'string'},
                 {name: 'SPEC',         text:'규격',              type: 'string'},
                 {name: 'PRICE',        text:'판매단가',            type: 'uniPrice'},
                 {name: 'ORDER_UNIT',   text:'판매단위',            type: 'string', displayField: 'value'},
                 {name: 'TRNS_RATE',    text:'입수',              type: 'string'},
                 {name: 'ITEM_ACCOUNT', text:'품목계정',            type: 'string'},
                 {name: 'OUT_WH_CODE',  text:'출고창고',            type: 'string'},
                 {name: 'WH_CODE',      text:'주창고',             type: 'string'},
                 {name: 'STOCK_UNIT',   text:'재고단위',            type: 'string', displayField: 'value'},
                 {name: 'STOCK_CARE_YN',text:'재고관리대상여부',        type: 'string'},                 
                 {name: 'WGT_UNIT',     text:'중량단위',            type: 'string'}, 
                 {name: 'UNIT_WGT',     text:'단위중량',            type: 'string'}, 
                 {name: 'VOL_UNIT',     text:'부피단위',            type: 'string'}, 
                 {name: 'UNIT_VOL',     text:'단위부피',            type: 'string'}        
        ]
    });
	Unilite.Main({
		items : [testForm]
	});  //Unilite.Main
}
</script>

      