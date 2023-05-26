<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	작업지시정보 팝업 'Unilite.app.popup.wkordNum'
request.setAttribute("PKGNAME","Unilite.app.popup.WkordNum");
%>
    <t:ExtComboStore useScriptTag="false" comboType="BOR120" />             // 사업장
    <t:ExtComboStore useScriptTag="false" comboType="WU" />
	/**
	 *   Model 정의
	 */
	 Unilite.defineModel('${PKGNAME}.wkordNumPopupModel', {
	    fields: [
					 {name: 'WKORD_NUM'	 				,text:'<t:message code="system.label.common.wkordnum" default="작업지시번호"/>' 		  ,type:'string'	}
					,{name: 'ITEM_CODE'	 				,text:'<t:message code="system.label.common.popup.item" default="품목"/>'   		  ,type:'string'	}
					,{name: 'ITEM_NAME'	 				,text:'<t:message code="system.label.common.itemname" default="품목명"/>' 		  	  ,type:'string'	}
					,{name: 'SPEC'	 					,text:'<t:message code="system.label.common.spec" default="규격"/>' 	  			  ,type:'string'	}
					,{name: 'PRODT_WKORD_DATE'	 		,text:'<t:message code="system.label.common.workorderdate" default="작업지시일"/>' 	  ,type:'uniDate'	}
					,{name: 'PRODT_START_DATE'			,text:'<t:message code="system.label.common.plannedstartdate" default="착수예정일"/>' ,type:'uniDate'	}
					,{name: 'PRODT_END_DATE'	 		,text:'<t:message code="system.label.common.completiondate" default="완료예정일"/>' 	  ,type:'uniDate'	}
					,{name: 'WKORD_Q'	 				,text:'<t:message code="system.label.common.ordersqty" default="지시량"/>'   		  ,type:'uniQty'	}
					,{name: 'WK_PLAN_NUM'	 			,text:'<t:message code="system.label.common.planno" default="계획번호"/>' 		  	  ,type:'string'	}
					,{name: 'DIV_CODE'	 				,text:'<t:message code="system.label.common.division" default="사업장"/>' 	  		  ,type:'string'	}
					,{name: 'WORK_SHOP_CODE'	 		,text:'<t:message code="system.label.common.workcenter" default="작업장"/>' 		  ,type:'string'	}
					,{name: 'WORK_SHOP_CODE_NM'	 		,text:'<t:message code="system.label.base.workcentername" default="작업장명"/>' 	  ,type:'string'	}
					,{name: 'ORDER_NUM'	 				,text:'<t:message code="system.label.common.sono" default="수주번호"/>' 			  ,type:'string'	}
					,{name: 'ORDER_Q'	 				,text:'<t:message code="system.label.common.soqty" default="수주량"/>' 			  ,type:'uniQty'	}
					,{name: 'REMARK'	 				,text:'<t:message code="system.label.common.remarks" default="비고"/>' 			  ,type:'string'	}
					,{name: 'PRODT_Q'	 				,text:'<t:message code="system.label.common.productionqty" default="생산량"/>' 	  ,type:'uniQty'	}
					,{name: 'DVRY_DATE'	 				,text:'<t:message code="system.label.common.deliverydate" default="납기일"/>' 		  ,type:'uniDate'	}
					,{name: 'STOCK_UNIT'	 			,text:'<t:message code="system.label.common.unit" default="단위"/>' 				  ,type:'string'	}
					,{name: 'PROJECT_NO'		 		,text:'<t:message code="system.label.common.projectno" default="프로젝트번호"/>' 		  ,type:'string'	}
					,{name: 'PJT_CODE'	 				,text:'<t:message code="system.label.common.projectno" default="프로젝트번호"/>' 		  ,type:'string'	}
					,{name: 'LOT_NO'	 				,text:'LOT_NO' 																	  ,type:'string'	}

			]
	});


Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    autoScroll : true,
	constructor : function(config){
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
        me.form = Unilite.createSearchForm('', {
                        layout : {type : 'uniTable', columns : 2 },
                        items : [{
                                  fieldLabel : '<t:message code="system.label.common.companycode" default="법인코드"/>',
                                  name : 'COMP_CODE',
                                  xtype: 'uniTextfield',
                                  value:UserInfo.compCode,
                                  hidden: true

                               },{
                                  fieldLabel : '<t:message code="system.label.common.division" default="사업장"/>',
                                  name : 'DIV_CODE',
                                  xtype: 'uniTextfield',
                                  hidden: true
                               },{
                                  fieldLabel : '<t:message code="system.label.common.wkordnum" default="작업지시번호"/>',
                                  name : 'WKORD_NUM',
                                  xtype: 'uniTextfield',
                                  hidden: false
                               },{
                                  fieldLabel : '<t:message code="system.label.common.workcenter" default="작업장"/>',
                                  name : 'WORK_SHOP_CODE',
                                  xtype: 'uniCombobox',
								  comboType : 'WU'
                               },{
					        	  fieldLabel: '<t:message code="system.label.common.plannedstartdate" default="착수예정일"/>',
					        	  xtype: 'uniDateRangefield',
					        	  startFieldName: 'FR_PRODT_DATE',
					        	  endFieldName:'TO_PRODT_DATE',
					        	  startDate: UniDate.get('startOfMonth'),
					        	  endDate: UniDate.get('today')
					           },
						          Unilite.popup('DIV_PUMOK',{
										fieldLabel: '<t:message code="system.label.common.itemcode" default="품목코드"/>',
						        		listeners: {
											applyextparam: function(popup){
												popup.setExtParam({'DIV_CODE': me.form.getValue('DIV_CODE')});
											}
										}
									})
								,{
                                  fieldLabel : '<t:message code="system.label.common.lotno" default="LOT번호"/>',
                                  name : 'LOT_NO',
                                  xtype: 'uniTextfield'
								},{
                                  fieldLabel : '공정코드',
                                  name : 'PROG_WORK_CODE',
                                  xtype: 'uniTextfield',
                                  hidden: true
                               }
                        ]
                    });
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{

            store : Unilite.createStoreSimple('${PKGNAME}.wkordNumPopupMasterStore',{
							model: '${PKGNAME}.wkordNumPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.wkordNum'
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
            columns:  [
		           		 { dataIndex: 'WKORD_NUM'	 		   		,width: 120 }
						,{ dataIndex: 'ITEM_CODE'	 		   		,width: 110 }
						,{ dataIndex: 'ITEM_NAME'	 				,width: 150 }
						,{ dataIndex: 'SPEC'	 			   		,width: 120 }
						,{ dataIndex: 'PRODT_WKORD_DATE'			,width: 100 ,hidden: true}
						,{ dataIndex: 'PRODT_START_DATE'	   		,width: 88  }
						,{ dataIndex: 'PRODT_END_DATE'				,width: 88  }
						,{ dataIndex: 'WKORD_Q'	 		   			,width: 130  }
						,{ dataIndex: 'WK_PLAN_NUM'	 				,width: 100 ,hidden: true}
						,{ dataIndex: 'DIV_CODE'	 		   		,width: 100 ,hidden: true}
						,{ dataIndex: 'WORK_SHOP_CODE'				,width: 100 ,hidden: true}
						,{ dataIndex: 'WORK_SHOP_CODE_NM'			,width: 100 ,hidden: true}
						,{ dataIndex: 'ORDER_NUM'	 		   		,width: 100 ,hidden: true}
						,{ dataIndex: 'ORDER_Q'	 					,width: 100 ,hidden: true}
						,{ dataIndex: 'REMARK'	 		   			,width: 100 }
						,{ dataIndex: 'PRODT_Q'	 					,width: 100 ,hidden: true}
						,{ dataIndex: 'DVRY_DATE'	 		   		,width: 100 ,hidden: true}
						,{ dataIndex: 'STOCK_UNIT'	 				,width: 100 ,hidden: true}
						,{ dataIndex: 'PROJECT_NO'		   			,width: 100 }
						,{ dataIndex: 'PJT_CODE'	 				,width: 100, hidden: true }
						,{ dataIndex: 'LOT_NO'	 					,width: 130 }
		    ] ,
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

			if(param['DIV_CODE'] && param['DIV_CODE']!='')				frm.setValue('DIV_CODE',   param['DIV_CODE']);
			if(param['WORK_SHOP_CODE'] && param['WORK_SHOP_CODE']!='')	frm.setValue('WORK_SHOP_CODE',   param['WORK_SHOP_CODE']);
			if(param['PROG_WORK_CODE'] && param['PROG_WORK_CODE']!='')	frm.setValue('PROG_WORK_CODE',   param['PROG_WORK_CODE']);

			if(param['FR_PRODT_DATE'] && param['FR_PRODT_DATE']!='')	frm.setValue('FR_PRODT_DATE',   param['FR_PRODT_DATE']);
			if(param['TO_PRODT_DATE'] && param['TO_PRODT_DATE']!='')	frm.setValue('TO_PRODT_DATE',   param['TO_PRODT_DATE']);

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