<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	프로젝트정보 팝업 'Unilite.app.popup.PjtPopup' 
request.setAttribute("PKGNAME","Unilite.app.popup.PjtPopup");
%>
	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.PjtPopupModel', {
	    fields: [ 	 {name: 'COMP_CODE'      	,text:'<t:message code="system.label.common.companycode" default="법인코드"/>' 		,type:'string'	}
					,{name: 'DIV_CODE'	   				,text:'<t:message code="system.label.common.division" default="사업장"/>' 		,type:'string'	}
					,{name: 'PJT_CODE'					,text:'<t:message code="system.label.common.projectcode" default="프로젝트코드"/>' 	,type:'string'	}
					,{name: 'PJT_NAME'	   				,text:'<t:message code="system.label.common.projectname" default="프로젝트명"/>' 		,type:'string'	}
	    			,{name: 'BUSI_FR_DATE'  			,text:'<t:message code="system.label.common.businessstartdate" default="사업시작일"/>' 		,type:'uniDate'	}
	    			,{name: 'BUSI_TO_DATE'			,text:'<t:message code="system.label.common.businessenddate" default="사업종료일"/>' 		,type:'uniDate'	}
					,{name: 'CUSTOM_CODE'   		,text:'<t:message code="system.label.common.customcode" default="거래처코드"/>' 		,type:'string'	}
					,{name: 'CUSTOM_NAME'    		,text:'<t:message code="system.label.common.customname" default="거래처명"/>' 		,type:'string'  }
					,{name: 'PJT_AMT'        				,text:'<t:message code="system.label.common.totalpjtamount" default="총사업비"/>' 		,type:'uniPrice'}
	    			,{name: 'CONTRACT_AMT'   	,text:'<t:message code="system.label.common.contractamount" default="계약금액"/>' 		,type:'uniPrice'}
	    			,{name: 'BUSI_DIVI'      				,text:'<t:message code="system.label.common.businessdivi" default="사업구분"/>' 		,type:'string'	, comboType:"AU", comboCode:'R001'}
	    			,{name: 'BUSI_TYPE'      				,text:'<t:message code="system.label.common.businesstype2" default="사업분야"/>' 		,type:'string'	, comboType:"AU", comboCode:'R002'}
	    			,{name: 'PROCESS_STATUS' 		,text:'<t:message code="system.label.common.processstatus" default="진행상태"/>' 		,type:'string'	, comboType:"AU", comboCode:'R003'}
					,{name: 'BUILD_DATE'     			,text:'<t:message code="system.label.common.completedate" default="준공일"/>' 		,type:'uniDate'	}
					,{name: 'REG_DATE'	   				,text:'<t:message code="system.label.common.writtendate" default="작성일"/>' 		,type:'uniDate' }
					,{name: 'BUILD_CUSTOM'			,text:'<t:message code="system.label.common.constructorcode" default="시공사코드"/>' 		,type:'string'	}
	    			,{name: 'BUILD_NAME'     			,text:'<t:message code="system.label.common.constructor" default="시공사"/>' 		,type:'string'	}
	    			,{name: 'CAPACITY'	   				,text:'<t:message code="system.label.common.capacity" default="시설용량"/>' 		,type:'string'	}
	    			,{name: 'PROC_TYPE'      			,text:'<t:message code="system.label.common.customname" default="거래처명"/>' 		,type:'string'	}
	    			,{name: 'PROCESS_DESC'   		,text:'<t:message code="system.label.common.processdesc" default="처리형태"/>' 		,type:'string'	}
					,{name: 'DEPT_CODE'      			,text:'<t:message code="system.label.common.departmencode" default="부서코드"/>' 		,type:'string'	}
					,{name: 'DEPT_NAME'      			,text:'<t:message code="system.label.common.departmentname" default="부서명"/>' 		,type:'string'  }
					,{name: 'IN_REMARK'      			,text:'<t:message code="system.label.common.remark2" default="특이사항"/>(<t:message code="system.label.common.facility" default="시설"/>)' 	,type:'string'	}
	    			,{name: 'SALES_REMARK'			,text:'<t:message code="system.label.common.salesremark" default="영업비고"/>' 		,type:'string'	}
	    			,{name: 'PRO_REMARK'	    		,text:'<t:message code="system.label.common.remark2" default="특이사항"/>' 		,type:'string'	}
	    			,{name: 'INSERT_DB_USER' 		,text:'<t:message code="system.label.common.accntperson" default="입력자"/>' 		,type:'string'	}
	    			,{name: 'INSERT_DB_TIME' 		,text:'<t:message code="system.label.common.inputdate" default="입력일"/>' 		,type:'uniDate'	}
					,{name: 'UPDATE_DB_USER' 		,text:'<t:message code="system.label.common.updateuser" default="수정자"/>' 		,type:'string'	}
					,{name: 'UPDATE_DB_TIME' 		,text:'<t:message code="system.label.common.updatedate" default="수정일"/>' 		,type:'uniDate' }

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
                        layout : {type : 'uniTable', columns : 3 },
                        items : [{
			        		fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
			        		name: 'DIV_CODE',
			        		value : UserInfo.divCode,
			        		xtype: 'uniCombobox',
			        		comboType: 'BOR120',
			        		allowBlank: false,
			        		colspan:2
			        	},{
			        		fieldLabel: '<t:message code="system.label.common.businessdivi" default="사업구분"/>',
			        		name: 'BUSI_DIVI',
			        		xtype: 'uniCombobox',
			        		comboType: 'AU',
			        		comboCode: 'R001'
			        	},{
				        	fieldLabel: '<t:message code="system.label.common.businessperiod" default="사업기간"/>', 
				            xtype: 'uniDateRangefield',   
				            startFieldName: 'BUSI_FR_DATE_FR',
							endFieldName: 'BUSI_FR_DATE_TO',
				            width: 315
				            
						},{
							xtype: 'radiogroup',		            		
							fieldLabel: '',
							items: [{
								boxLabel: '<t:message code="system.label.common.startdate" default="시작일"/>', 
								width: 70, 
								name: 'CHECKED',
								inputValue: 'START',
								checked : true
							},{
								boxLabel : '<t:message code="system.label.common.finisheddate" default="완료일"/>', 
								width: 70,
								name: 'CHECKED',
								inputValue: 'END'
							}]
					   },{
			        		fieldLabel: '<t:message code="system.label.common.businesstype2" default="사업분야"/>',
			        		name: 'BUSI_TYPE',
			        		xtype: 'uniCombobox',
			        		comboType: 'AU',
			        		comboCode: 'R002'
			        	},{
			        		fieldLabel: '<t:message code="system.label.common.projectcode" default="프로젝트코드"/>',
			        		name: 'PJT_CODE',
			        		xtype: 'uniTextfield'
			        	},{
			        		fieldLabel: '<t:message code="system.label.common.projectname" default="프로젝트명"/>',
			        		name: 'PJT_NAME',
			        		xtype: 'uniTextfield'
			        	},{
			        		fieldLabel: '<t:message code="system.label.common.processstatus" default="진행상태"/>',
			        		name: 'PROCESS_STATUS',
			        		xtype: 'uniCombobox',
			        		comboType: 'AU',
			        		comboCode: 'R003'
			        	}
                        
                        
                       
                        ]
                    });
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
			
            store : Unilite.createStoreSimple('${PKGNAME}.PjtPopupMasterStore',{
							model: '${PKGNAME}.PjtPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.pjtPopup'
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
		           		 { dataIndex: 'COMP_CODE'     		,width: 100 ,hidden:true}  
						,{ dataIndex: 'DIV_CODE'	   		,width: 100 ,hidden:true}
						,{ dataIndex: 'PJT_CODE'			,width: 100 }
						,{ dataIndex: 'PJT_NAME'	   		,width: 100 }
						,{ dataIndex: 'BUSI_FR_DATE'  		,width: 100 }
						,{ dataIndex: 'BUSI_TO_DATE'		,width: 100 }
						,{ dataIndex: 'CUSTOM_CODE'   		,width: 100 ,hidden:true}
						,{ dataIndex: 'CUSTOM_NAME'   		,width: 100 }
						,{ dataIndex: 'PJT_AMT'       		,width: 100 }
						,{ dataIndex: 'CONTRACT_AMT'  		,width: 100 }
						,{ dataIndex: 'BUSI_DIVI'     		,width: 100 }
						,{ dataIndex: 'BUSI_TYPE'     		,width: 100 }
						,{ dataIndex: 'PROCESS_STATUS'		,width: 100 }
						,{ dataIndex: 'BUILD_DATE'    		,width: 100 }
						,{ dataIndex: 'REG_DATE'	   		,width: 100 ,hidden:true}
						,{ dataIndex: 'BUILD_CUSTOM'		,width: 100 ,hidden:true}
						,{ dataIndex: 'BUILD_NAME'    		,width: 100 ,hidden:true}
						,{ dataIndex: 'CAPACITY'	   		,width: 100 ,hidden:true}
						,{ dataIndex: 'PROC_TYPE'     		,width: 100 ,hidden:true}
						,{ dataIndex: 'PROCESS_DESC'  		,width: 100 ,hidden:true}
						,{ dataIndex: 'DEPT_CODE'     		,width: 100 ,hidden:true}
						,{ dataIndex: 'DEPT_NAME'     		,width: 100 ,hidden:true}
						,{ dataIndex: 'IN_REMARK'     		,width: 100 ,hidden:true}
						,{ dataIndex: 'SALES_REMARK'		,width: 100 ,hidden:true}
						,{ dataIndex: 'PRO_REMARK'			,width: 100 ,hidden:true}
						,{ dataIndex: 'INSERT_DB_USER'		,width: 100 ,hidden:true}
						,{ dataIndex: 'INSERT_DB_TIME'		,width: 100 ,hidden:true}
						,{ dataIndex: 'UPDATE_DB_USER'		,width: 100 ,hidden:true}
						,{ dataIndex: 'UPDATE_DB_TIME'		,width: 100 ,hidden:true}
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
			//frm.setValue('BPARAM0', param['BPARAM0']);
			if(param['PJT_CODE'] && param['PJT_CODE']!='')	frm.setValue('TXT_SEARCH', param['PJT_CODE']);
			if(param['PJT_NAME'] && param['PJT_NAME']!='')	frm.setValue('TXT_SEARCH', param['PJT_NAME']);
			if(param['DIV_CODE'] && param['DIV_CODE']!='')		frm.setValue('DIV_CODE',   param['DIV_CODE']);
			if(param['WORK_SHOP_CODE'] && param['WORK_SHOP_CODE']!='')		frm.setValue('WORK_SHOP_CODE',   param['WORK_SHOP_CODE']);
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