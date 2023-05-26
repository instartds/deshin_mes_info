<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.TaxBillSearchPopup");
%>
var gsbillConnect = '';
	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.TaxBillSearchPopupModel', {
	    fields: [ {name: 'DIV_CODE'    	     		,text:'<t:message code="system.label.common.declaredivisioncode" default="신고사업장"/>' 	,type:'string', comboType:'BOR120'}
	    		 ,{name: 'CUSTOM_CODE'    	 		,text:'<t:message code="system.label.common.salesplacecode" default="매출처코드"/>' 	,type:'string'	}
	    		 ,{name: 'CUSTOM_NAME'    	 	,text:'<t:message code="system.label.common.salesplace" default="매출처"/>' 		,type:'string'	}
	    		 ,{name: 'PUB_NUM'    		 			,text:'<t:message code="system.label.common.billno" default="계산서번호"/>' 	,type:'string'	}
	    		 ,{name: 'BILL_TYPE'          				,text:'<t:message code="system.label.common.billtypecode" default="계산서유형코드"/>' 	,type:'string'	}
	    		 ,{name: 'BUSI_TYPE'          			,text:'<t:message code="system.label.common.busitype" default="거래유형"/>' 	,type:'string'	}
	    		 ,{name: 'PROOF_KIND'          		,text:'<t:message code="system.label.common.proofkind" default="증빙유헝"/>' 	,type:'string'	}
	    		 ,{name: 'BILL_TYPE_NM'   	 		,text:'<t:message code="system.label.common.billtype2" default="계산서종류"/>' 	,type:'string'	}
	    		 ,{name: 'BILL_DATE'    	     			,text:'<t:message code="system.label.common.billdate" default="계산서일"/>' 		,type:'uniDate'	}
	    		 ,{name: 'PUB_DATE'    	     			,text:'<t:message code="system.label.common.pubdate" default="매출기간"/>' 		,type:'string'	}
	    		 ,{name: 'SALE_DIV_CODE'      		,text:'<t:message code="system.label.common.salesdivision" default="매출사업장"/>' 	,type:'string', comboType:'BOR120'	}
	    		 ,{name: 'PROJECT_NO'    	 			,text:'<t:message code="system.label.common.projectno" default="프로젝트번호"/>' 		,type:'string'	}
	    		 ,{name: 'EX_YN'              				,text:'<t:message code="system.label.common.slipyn" default="기표여부"/>' 		,type:'string'	}
	    		 ,{name: 'COLET_CUST_NM'      	,text:'<t:message code="system.label.common.collectionplace" default="수금처"/>' 		,type:'string'	}
	    		 ,{name: 'TAX_CALC_TYPE'      		,text:'<t:message code="system.label.common.taxcalculationmethod" default="세액계산법"/>' 	,type:'string'	}
	    		 ,{name: 'COLLECT_DAY'    	 		,text:'<t:message code="system.label.common.collectiondate" default="수금일"/>' 		,type:'string'	}
	    		 ,{name: 'COMPANY_NUM'    	 	,text:'<t:message code="system.label.common.businessnumber" default="사업자번호"/>' 	,type:'string'	}
	    		 ,{name: 'TOP_NAME'    	     		,text:'<t:message code="system.label.common.representativename" default="대표자명"/>' 		,type:'string'	}
	    		 ,{name: 'ADDR1'    	         			,text:'<t:message code="system.label.common.address1" default="주소1"/>' 		,type:'string'	}
	    		 ,{name: 'ADDR2'    	         			,text:'<t:message code="system.label.common.address2" default="주소2"/>' 		,type:'string'	}
	    		 ,{name: 'COMP_TYPE'    	     		,text:'<t:message code="system.label.common.businessconditions" default="업태"/>'		 	,type:'string'	}
	    		 ,{name: 'COMP_CLASS'    	 		,text:'<t:message code="system.label.common.businesstype" default="업종"/>' 			,type:'string'	}
	    		 ,{name: 'WON_CALC_BAS'       	,text:'<t:message code="system.label.common.decimalcalculation" default="원미만계산"/>' 	,type:'string'	}
	    		 ,{name: 'COLLECT_CARE'       		,text:'<t:message code="system.label.common.armanagemethod" default="미수관리방법"/>' 	,type:'string'	}
	    		 ,{name: 'COLLECTOR_CP'       		,text:'<t:message code="system.label.common.collectioncustomer" default="수금거래처"/>' 	,type:'string'	}
	    		 ,{name: 'REG_DATE'           			,text:'<t:message code="system.label.common.writtendate" default="작성일"/>' 		,type:'string'	}
	    		 ,{name: 'REG_REMARK'         		,text:'<t:message code="system.label.common.remarks" default="비고"/>' 			,type:'string'	}
	    		 ,{name: 'PUB_FR_DATE'        		,text:'<t:message code="system.label.common.pubdate" default="매출기간"/>(FROM)',type:'string'	}
	    		 ,{name: 'PUB_TO_DATE'        		,text:'<t:message code="system.label.common.pubdate" default="매출기간"/>(TO)' 	,type:'string'	}
	    		 ,{name: 'ORIGINAL_PUB_NUM'   ,text:'<t:message code="system.label.common.origintaxsearch" default="원본세금계산서검색"/>' 	,type:'string'	}
	    		 ,{name: 'SALE_AMT_O'         		,text:'<t:message code="system.label.common.amount" default="금액"/>' 			,type:'uniPrice'}
	    		 ,{name: 'TAX_AMT_O'          			,text:'<t:message code="system.label.common.taxamount" default="세액"/>' 			,type:'uniPrice'}
	    		 ,{name: 'SALE_TOT_AMT'       		,text:'<t:message code="system.label.common.totalamount1" default="합계금액"/>' 		,type:'uniPrice'}
	    		 ,{name: 'RECEIPT_PLAN_DATE'  	,text:'<t:message code="system.label.common.collectionschdate" default="수금예정일"/>' 		,type:'uniDate'	}
	    		 ,{name: 'INFO'               				,text:'<t:message code="system.label.common.revisepublicinfo" default="수정발행정보"/>' 	,type:'string'	}
	    		 ,{name: 'SALE_PRSN'          			,text:'<t:message code="system.label.common.영업담당" default="영업담당"/>' 		,type:'string'	}
	    		 ,{name: 'ISSU_ID'            				,text:'<t:message code="system.label.common.issueid" default="국세청승인번호"/>' 	,type:'string'	}
	    		 
	    		 ,{name: 'SEND_NAME'               	,text:'<t:message code="system.label.common.charger" default="담당자"/>' 		,type:'string'	}
	    		 ,{name: 'SEND_EMAIL'          		,text:'<t:message code="system.label.common.charger" default="담당자"/>EMAIL'	,type:'string'	}
	    		 ,{name: 'PRSN_NAME'            		,text:'<t:message code="system.label.common.receivingperson" default="받는 담당자"/>' 	,type:'string'	}
	    		 ,{name: 'PRSN_EMAIL'               	,text:'<t:message code="system.label.common.receivingperson" default="받는 담당자"/>EMAIL',type:'string'	}
	    		 ,{name: 'PRSN_PHONE'          		,text:'<t:message code="system.label.common.receivingpersonphone" default="받는 담당자연락처"/>',type:'string'	}
	    		 ,{name: 'PRSN_HANDPHONE'    ,text:'<t:message code="system.label.common.receivingpersonhandphone" default="받는 담당자핸드폰"/>',type:'string'	}
	    		 ,{name: 'SMS_CHECK'               	,text:'<t:message code="system.label.common.smssendcheck" default="SMS발송여부"/>' 	,type:'string'	}

			]
	});
 
    
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
	constructor : function(config){
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
        me.form = Unilite.createSearchForm('', {
                        layout : {
                            type : 'uniTable',
                            columns : 2
                        },
                        items : [Unilite.popup('AGENT_CUST',{
									fieldLabel: '<t:message code="system.label.common.client" default="고객"/>',
									textFieldWidth: 170	
								}),{
									fieldLabel: '<t:message code="system.label.common.billdate" default="계산서일"/>',
									xtype: 'uniDateRangefield',
									startFieldName: 'DATE_FR',
									endFieldName: 'DATE_TO',
									width: 350	    
								},{
							    	fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>'  ,
							    	name: 'SALE_DIV_CODE',
							    	xtype:'uniCombobox',
							    	comboType:'BOR120',
							    	value:UserInfo.divCode/*,
							    	allowBlank:false*/
							    },{
							    	fieldLabel: '<t:message code="system.label.common.billno" default="계산서번호"/>'  ,
							    	name: 'PUB_NUM',
							    	xtype:'uniTextfield'
							    },{
									xtype: 'uniTextfield',
									name: 'BILL_CONNECT',
									hidden: true
								},{
									xtype: 'uniTextfield',
									name: 'BILL_DB_USER',
									hidden: true
								},{
									xtype: 'uniTextfield',
									name: 'UPDATE_REASON',
									hidden: true
								},{
									xtype: 'uniTextfield',
									name: 'TABLE_NAME',
									hidden: true
								}
			               ]
                    });
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store : Unilite.createStoreSimple('${PKGNAME}.TaxBillSearchPopupMasterStore',{
							model: '${PKGNAME}.TaxBillSearchPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.TaxBillSearchPopup'
					            }
					        }
					}),
			uniOpt:{
                state: {
					useState: false,
					useStateList: false	
	            },
				pivot : {
					use : false
				}
		    },
			selModel:'rowmodel',
            columns : [{dataIndex : 'DIV_CODE'    	     		, width : 86},
            		   {dataIndex : 'CUSTOM_CODE'    	 		, width : 73, hidden: true},
            		   {dataIndex : 'CUSTOM_NAME'    	 		, width : 106},
            		   {dataIndex : 'PUB_NUM'    		 		, width : 120},
            		   {dataIndex : 'BILL_TYPE'          		, width : 80, hidden: true},
            		   {dataIndex : 'BILL_TYPE_NM'   	 		, width : 100},
	    		 	   {dataIndex : 'BUSI_TYPE'          		, width : 66, hidden: true	},
	    		 	   {dataIndex : 'PROOF_KIND'          		, width : 66, hidden: true	},
            		   {dataIndex : 'BILL_DATE'    	     		, width : 73},
            		   {dataIndex : 'PUB_DATE'    	     		, width : 146},
            		   {dataIndex : 'SALE_DIV_CODE'      		, width : 80},
            		   {dataIndex : 'PROJECT_NO'    	 		, width : 100},
            		   {dataIndex : 'EX_YN'              		, width : 66},
            		   {dataIndex : 'COLET_CUST_NM'      		, width : 100},
            		   {dataIndex : 'TAX_CALC_TYPE'      		, width : 66, hidden: true},
            		   {dataIndex : 'COLLECT_DAY'    	 		, width : 66, hidden: true},
            		   {dataIndex : 'COMPANY_NUM'    	 		, width : 66, hidden: true},
            		   {dataIndex : 'TOP_NAME'    	     		, width : 66, hidden: true},
            		   {dataIndex : 'ADDR1'    	         		, width : 66, hidden: true},
            		   {dataIndex : 'ADDR2'    	         		, width : 66, hidden: true},
            		   {dataIndex : 'COMP_TYPE'    	     		, width : 66, hidden: true},
            		   {dataIndex : 'COMP_CLASS'    	 		, width : 66, hidden: true},
            		   {dataIndex : 'WON_CALC_BAS'       		, width : 66, hidden: true},
            		   {dataIndex : 'COLLECT_CARE'       		, width : 66, hidden: true},
            		   {dataIndex : 'COLLECTOR_CP'       		, width : 66, hidden: true},
            		   {dataIndex : 'REG_DATE'           		, width : 66, hidden: true},
            		   {dataIndex : 'REG_REMARK'         		, width : 133, hidden: true},
            		   {dataIndex : 'PUB_FR_DATE'        		, width : 133, hidden: true},
            		   {dataIndex : 'PUB_TO_DATE'        		, width : 133, hidden: true},
            		   {dataIndex : 'ORIGINAL_PUB_NUM'   		, width : 66, hidden: true},
            		   {dataIndex : 'SALE_AMT_O'         		, width : 66, hidden: true},
            		   {dataIndex : 'TAX_AMT_O'          		, width : 66, hidden: true},
            		   {dataIndex : 'SALE_TOT_AMT'       		, width : 100/*, hidden: true*/},
            		   {dataIndex : 'RECEIPT_PLAN_DATE'  		, width : 66, hidden: true},
            		   {dataIndex : 'INFO'               		, width : 166},
            		   {dataIndex : 'SALE_PRSN'          		, width : 66, hidden: true},
            		   {dataIndex : 'ISSU_ID'            		, width : 100, hidden: true},
            		   
            		   {dataIndex : 'SEND_NAME'         		, width : 66, hidden: true},
            		   {dataIndex : 'SEND_EMAIL'        		, width : 66, hidden: true},
            		   {dataIndex : 'PRSN_NAME'        			, width : 66, hidden: true},
            		   {dataIndex : 'PRSN_EMAIL'   				, width : 66, hidden: true},
            		   {dataIndex : 'PRSN_PHONE'         		, width : 66, hidden: true},
            		   {dataIndex : 'PRSN_HANDPHONE'          	, width : 66, hidden: true},
            		   {dataIndex : 'SMS_CHECK'       			, width : 66, hidden: true}

            ],
            listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
					if(!Ext.isEmpty(record.get('INFO'))){
              			alert(Msg.fSbMsgS0210);	//수정발행 진행중인 계산서가 존재합니다.
              			return false;
              		}
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
        config.items = [me.form, me.grid];
        me.callParent(arguments);
	},  //constructor
	initComponent : function(){    
    	var me  = this;
        
        me.grid.focus();
        
    	this.callParent();    	
    },	
	fnInitBinding : function(param) {
		//var param = window.dialogArguments;
		var frm= this.form;
		
        if(param) {
			var tableName = param['TABLE_NAME'];
			if(Ext.isEmpty(tableName)) {
				tableName = 'ATX110T'
			}

			frm.setValue('CUSTOM_CODE', param['CUSTOM_CODE']);
			frm.setValue('CUSTOM_NAME', param['CUSTOM_NAME']);
			frm.setValue('DATE_TO', param['WRITE_DATE']);
			frm.setValue('DATE_FR', UniDate.get('startOfMonth', param['WRITE_DATE']));			//20200702 수정: frm.getValue('TO_DATE') -> param['WRITE_DATE']
			frm.setValue('SALE_DIV_CODE', param['SALE_DIV_CODE']);
			frm.setValue('BILL_CONNECT', param['BILL_CONNECT']);
			frm.setValue('BILL_DB_USER', param['BILL_DB_USER']);
			frm.setValue('UPDATE_REASON', param['UPDATE_REASON']);
			frm.setValue('TABLE_NAME', tableName);
		}
		this._dataLoad();
        
	},
    onSubmitButtonDown : function()	{
        var me = this;
		var selectRecord = me.grid.getSelectedRecord();
	 	var rv ;
		if(selectRecord)	{
		 	rv = {
				status : "OK",
				data:[selectRecord.data]
			};
		}
		me.returnData(rv);
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	_dataLoad : function() {
		var me = this;
		var param= this.form.getValues();
		console.log( param );
        if(param) {
        	me.isLoading = true;
			this.grid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
        }
	}
});


