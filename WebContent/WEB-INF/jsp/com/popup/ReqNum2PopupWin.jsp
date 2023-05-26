<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.ReqNum2Popup");
%>

/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.ReqNum2PopupModel', {
    fields: [
            {name: 'COMP_CODE'            	,text:'<t:message code="system.label.common.companycode" default="법인코드"/>'                 ,type: 'string'},
            {name: 'DIV_CODE'					,text:'<t:message code="system.label.common.division" default="사업장"/>'                   ,type: 'string'},
            {name: 'REQ_NUM'              		,text:'<t:message code="system.label.common.requestnum" default="의뢰서번호"/>'               ,type: 'string'},
            {name: 'REQ_DATE'             		,text:'<t:message code="system.label.common.requestdate2" default="의뢰일"/>'                   ,type: 'string'},
            {name: 'CUSTOM_CODE'          ,text:'<t:message code="system.label.common.customcode" default="거래처코드"/>'               ,type: 'string'},
            {name: 'CUSTOM_NAME'         ,text:'<t:message code="system.label.common.customfullname" default="거래처전명"/>'                 ,type: 'string'},
            {name: 'REQ_GUBUN'            	,text:'<t:message code="system.label.common.requestmaterialtype" default="외주/자재구분"/>'            ,type: 'string', comboType:'AU', comboCode:'WZ08'},
            {name: 'ITEM_CODE'            	,text:'<t:message code="system.label.common.itemcode" default="품목코드"/>'                 ,type: 'string'},
            {name: 'ITEM_NAME'            ,text:'<t:message code="system.label.common.popup.item" default="품목"/>'                   ,type: 'string'},
            {name: 'DEPT_CODE'            	,text:'<t:message code="system.label.common.departmencode" default="부서코드"/>'                 ,type: 'string'},
            {name: 'DEPT_NAME'           ,text:'<t:message code="system.label.common.department" default="부서"/>'                 ,type: 'string'},
            {name: 'PERSON_NUMB'     ,text:'<t:message code="system.label.common.employeecode" default="사원코드"/>'                 ,type: 'string'},
            {name: 'PERSON_NAME'     ,text:'<t:message code="system.label.common.employeename" default="사원명"/>'                   ,type: 'string'},
            {name: 'REMARK'                 ,text:'<t:message code="system.label.common.remarks" default="비고"/>'                     ,type: 'string'}
        ]
});


/**
 * 검색조건 (Search Panel)
 * @type 
 */
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
	    
	    me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'table', columns : 3},
		    items: [{
                    fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
                    name:'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType:'BOR120',
                    allowBlank:false,
                    value: UserInfo.divCode
                },{
                    fieldLabel: '<t:message code="system.label.common.requestdate2" default="의뢰일"/>',
                    startFieldName: 'REQ_DATE_FR',
                    endFieldName: 'REQ_DATE_TO',
                    xtype: 'uniDateRangefield',
                    allowBlank: false,
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today')
                },{
                    fieldLabel: '<t:message code="system.label.common.requestnum" default="의뢰서번호"/>',
                    name:'REQ_NUM',   
                    xtype: 'uniTextfield'
                },{                 
                    fieldLabel: '<t:message code="system.label.common.requestmaterialtype" default="외주/자재구분"/>',
                    name:'REQ_GUBUN',
                    xtype: 'uniCombobox',
                    comboCode:'WZ08',
                    comboType:'AU'
                },
                Unilite.popup('AGENT_CUST', {
                        fieldLabel:'<t:message code="system.label.common.custom" default="거래처"/>', 
                        valueFieldName: 'CUSTOM_CODE',
                        textFieldName: 'CUSTOM_NAME'
                }),{
                    fieldLabel: '<t:message code="system.label.common.remarks" default="비고"/>',
                    name:'REMARK',  
                    xtype: 'uniTextfield'
                }
            ]
		}); 
/**
 * Master Grid 정의(Grid Panel)
 * @type 
 */
		 me.masterGrid = Unilite.createGrid('', {
			store: Unilite.createStore('${PKGNAME}.reqNumPopupMasterStore',{
							model: '${PKGNAME}.ReqNum2PopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'uniDirect',
					            api: {
					            	read: 'popupService.reqNum2Popup'
					            }
					        },
					        saveStore : function(config)	{				
								var inValidRecs = this.getInvalidRecords();
								if(inValidRecs.length == 0 )	{
									//this.syncAll(config);
									this.syncAllDirect(config);
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
                {dataIndex : 'COMP_CODE'              , width : 100, hidden: true},
                {dataIndex : 'DIV_CODE'               , width : 100, hidden: true},
                {dataIndex : 'REQ_NUM'                , width : 100},
                {dataIndex : 'REQ_DATE'               , width : 100},
                {dataIndex : 'CUSTOM_CODE'            , width : 110},
                {dataIndex : 'CUSTOM_NAME'            , width : 200},
                {dataIndex : 'REQ_GUBUN'              , width : 100},
                {dataIndex : 'ITEM_CODE'              , width : 100},
                {dataIndex : 'ITEM_NAME'              , width : 200},
                {dataIndex : 'DEPT_CODE'              , width : 100, hidden: true},
                {dataIndex : 'DEPT_NAME'              , width : 100, hidden: true},
                {dataIndex : 'PERSON_NUMB'            , width : 100, hidden: true},
                {dataIndex : 'PERSON_NAME'            , width : 100, hidden: true},
                {dataIndex : 'REMARK'                 , width : 100}          
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
		    config.items = [me.panelSearch, me.masterGrid];
		    me.callParent(arguments);
	    },
		initComponent : function(){    
	    	var me  = this;
//	        me.masterGrid.focus();
	        this.callParent();    	
	    },    
		fnInitBinding : function(param) {
			var me = this;
			me.param = param;
			var frm= me.panelSearch.getForm();
			var fieldTxt = frm.findField('REQ_NUM');
			//me.panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			me.panelSearch.setValue('DIV_CODE', param.DIV_CODE);
			me.panelSearch.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
			me.panelSearch.setValue('REQ_DATE_TO', UniDate.get('today'));
			
			frm.findField('DIV_CODE').setReadOnly(true);
//			frm.findField('TYPE').setReadOnly(true);

			this._dataLoad();
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
