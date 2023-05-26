<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 전자세금 계산서 담당자 팝업
request.setAttribute("PKGNAME","Unilite.app.popup.CustBillPrsnPopupMultiWin");
%>
<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S051" />	// '품목계정
/**
 *   Model 정의
 * @type
 */

Unilite.defineModel('${PKGNAME}.CustBillPrsnPopupMultiModel', {
    fields: [
    			 {name: 'SEQ' 								,text:'<t:message code="system.label.common.seq" default="순번"/>' 				,type:'string'	}
    			,{name: 'PRSN_NAME' 				,text:'<t:message code="system.label.common.chargername" default="담당자명"/>' 			,type:'string'	}
				,{name: 'DEPT_NAME' 				,text:'<t:message code="system.label.common.departmentname" default="부서명"/>' 				,type:'string'	}
				,{name: 'HAND_PHON' 			,text:'<t:message code="system.label.common.cellphone" default="핸드폰"/>' 				,type:'string'	}
				,{name: 'TELEPHONE_NUM1' 	,text:'<t:message code="system.label.common.telephone" default="전화번호"/>1' 			,type:'string'	}
				,{name: 'TELEPHONE_NUM2' 	,text:'<t:message code="system.label.common.telephone" default="전화번호"/>2' 			,type:'string'	}
				,{name: 'FAX_NUM' 					,text:'<t:message code="system.label.common.faxno" default="팩스번호"/>' 			,type:'string'	}
				,{name: 'MAIL_ID' 						,text:'E-MAIL' 				,type:'string'	}
				,{name: 'BILL_TYPE' 					,text:'<t:message code="system.label.common.electronicdocumentdivision" default="전자문서구분"/>' 		,type:'string'	}
				,{name: 'MAIN_BILL_YN' 			,text:'<t:message code="system.label.common.electronicdocumentmainyn" default="전자문서주담당여부"/>' 	,type:'string'	}
				,{name: 'REMARK' 						,text:'<t:message code="system.label.common.remarks" default="비고"/>' 				,type:'string'	}
		]
});



/**
 * 검색조건 (Search Panel)
 * @type
 */
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    //param: this.param,
    constructor : function(config) {
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
	    /**
	     * 검색조건 (Search Panel)
	     * @type
	     */
	    var wParam = this.param;
	    var t1= false, t2 = false;
	    if( Ext.isDefined(wParam)) {
	        if(wParam['TYPE'] == 'VALUE') {
	            t1 = true;
	            t2 = false;

	        } else {
	            t1 = false;
	            t2 = true;

	        }
	    }
		me.panelSearch = Unilite.createSearchForm('',{
		    layout : {type : 'uniTable', columns : 2, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items: [
		    	{ fieldLabel: '검색', 	name:'SEARCH_TEXT',
                    listeners:{
                        specialkey: function(field, e){
                            if (e.getKey() == e.ENTER) {
                               me.onQueryButtonDown();
                            }
                        }
                    }
                } ,
        		{ fieldLabel: '',
    			 	xtype: 'radiogroup', width: 230,
    			 	items:[	{inputValue: '1', boxLabel:'<t:message code="system.label.common.codeinorder" default="코드순"/>', name: 'RDO', checked: t1},
    			 			{inputValue: '2', boxLabel:'<t:message code="system.label.common.nameinorder" default="이름순"/>',  name: 'RDO', checked: t2} ]
    			},
    			{ fieldLabel: '<t:message code="system.label.common.custom" default="거래처"/>', 	name:'CUSTOM_CODE', hidden:true} ,
    			{ fieldLabel: '<t:message code="system.label.common.sendingyn" default="전송구분"/>', 	name:'SEARCH_TYPE', hidden:true} , // 담당자:BILLPRSN, 이메일:REMAIL
    			{ fieldLabel: '<t:message code="system.label.common.invoiceclass" default="계산서구분"/>', name:'BILL_TYPE', hidden:true, xtype: 'uniCombobox' , comboType:'AU', multiSelect: true ,comboCode:'S051'} ,
    			{ xtype: 'uniTextfield', name:'ADD_QUERY', hidden: true}
			]
		});


		/**
		 * Master Grid 정의(Grid Panel)
		 * @type
		 */
		 var masterGridConfig = {
			store: Unilite.createStoreSimple('${PKGNAME}.custBillPrsnPopupMasterMultiStore',{
								model: '${PKGNAME}.CustBillPrsnPopupMultiModel',
						        autoLoad: false,
						        proxy: {
						                type: 'direct',
						                api: {
						                	read: 'popupService.custBillPrsnPopup'
						                }
						            },listeners	: {
													load: function(store, records, successful, eOpts) {
														me.masterGrid.focus();


													}
												}
						}),
            uniOpt:{
				useRowNumberer: false,
				onLoadSelectFirst : false,
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
		           	 { dataIndex: 'SEQ'				,width: 60 }
		           	,{ dataIndex: 'PRSN_NAME'		,width: 80 }
					,{ dataIndex: 'DEPT_NAME'		,width: 100 }
					,{ dataIndex: 'HAND_PHON'		,width: 100 }
					,{ dataIndex: 'TELEPHONE_NUM1'	,width: 80 }
					,{ dataIndex: 'TELEPHONE_NUM2'	,width: 100, hidden:true }
					,{ dataIndex: 'FAX_NUM'			,width: 100, hidden:true }
					,{ dataIndex: 'MAIL_ID'			,width: 120 }
					,{ dataIndex: 'BILL_TYPE'		,width: 80 }
					,{ dataIndex: 'MAIN_BILL_YN'	,width: 80, hidden:true  }
					,{ dataIndex: 'REMARK'			,width: 120 }
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
		};

		masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
		me.masterGrid = Unilite.createGrid('', masterGridConfig);
		config.items = [me.panelSearch, me.masterGrid];

		me.callParent(arguments);
    },
    initComponent : function(){
    	var me  = this;

        me.masterGrid.focus();

    	this.callParent();
    },
	fnInitBinding : function(param) {
		var me = this,
			masterGrid = me.masterGrid,
			panelSearch = me.panelSearch;

		var rdo = panelSearch.getForm().findField('RDO');
		console.log("param:", param);
		if( Ext.isDefined(param)) {
			panelSearch.setValue('SEARCH_TEXT','');
			panelSearch.setValue('CUSTOM_CODE', param['CUSTOM_CODE']);
			panelSearch.setValue('SEARCH_TYPE', param['SEARCH_TYPE']);
			panelSearch.setValue('BILL_TYPE', param['BILL_TYPE']);
			panelSearch.setValue('ADD_QUERY', param['ADD_QUERY']);
		}
		panelSearch.setValues(param);
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        	var me = this,
			masterGrid = me.masterGrid,
			panelSearch = me.panelSearch;
		var selectRecords = masterGrid.getSelectedRecords();
		var rvRecs= new Array();
		Ext.each(selectRecords, function(record, i)	{
			rvRecs[i] = record.data;
		})
	 	var rv ;
		if(selectRecords)	{
		 	rv = {
				status : "OK",
				data:rvRecs
			};
		};

		//me.returnValue = rv;
		me.returnData(rv);
		me.close();
	},
	_dataLoad : function() {
			var me = this,
			masterGrid = me.masterGrid,
			panelSearch = me.panelSearch;
			var param= panelSearch.getValues();
			console.log( "_dataLoad: ", param );
			me.isLoading = true;
			masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
	}
});


