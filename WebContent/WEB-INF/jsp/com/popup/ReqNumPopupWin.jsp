<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.ReqNumPopup");
%>

/**
 *   Model 정의
 * @type
 */
Unilite.defineModel('${PKGNAME}.ReqNumPopupModel', {
    fields: [
             {name: 'SER_NO'            			,text:'<t:message code="system.label.common.requestseq" default="의뢰순번"/>'          ,type:'string'}
            ,{name: 'P_REQ_NUM'         		,text:'<t:message code="system.label.common.prequestnum" default="의뢰번호"/>'      ,type:'string'}
            ,{name: 'P_REQ_DATE'        		,text:'<t:message code="system.label.common.requestdate2" default="의뢰일"/>'      ,type:'uniDate'}
            ,{name: 'APLY_START_DATE'		,text:'<t:message code="system.label.common.applydate" default="적용일"/>'      ,type:'uniDate'}
            ,{name: 'TYPE'              				,text:'<t:message code="system.label.common.classfication" default="구분"/>'          ,type:'string', comboType:'AU', comboCode:'A003'}
            ,{name: 'TREE_CODE'         		,text:'<t:message code="system.label.common.departmencode" default="부서코드"/>'      ,type:'string'}
            ,{name: 'TREE_NAME'         		,text:'<t:message code="system.label.common.departmentname" default="부서명"/>'        ,type:'string'}
            ,{name: 'MONEY_UNIT'       		,text:'<t:message code="system.label.common.currency" default="화폐 "/>'      ,type:'string'}
            ,{name: 'PERSON_NUMB'       	,text:'<t:message code="system.label.common.personnumb" default="사번"/>'      ,type:'string'}
            ,{name: 'PERSON_NAME'       	,text:'<t:message code="system.label.common.employeename" default="사원명"/>'        ,type:'string'}
            ,{name: 'CUSTOM_CODE'        	,text:'<t:message code="system.label.common.custom" default="거래처"/>'          ,type:'string'}
            ,{name: 'CUSTOM_NAME'        ,text:'<t:message code="system.label.common.customname" default="거래처명"/>'          ,type:'string'}
            ,{name: 'ITEM_P'             			,text:'<t:message code="system.label.common.applyprice" default="적용단가"/>'          ,type:'float', format:'0,000.000000',decimalPrecision:6}
            ,{name: 'PRICE_TYPE'        			,text:'<t:message code="system.label.common.priceclass" default="단가구분"/>'          ,type:'string'}
            ,{name: 'PAY_TERMS'        		,text:'<t:message code="system.label.common.paycondition" default="결제조건"/>'          ,type:'string'}
            ,{name: 'ITEM_NAME'        		,text:'<t:message code="system.label.common.itemname" default="품목명"/>'          ,type:'string'}
            ,{name: 'SPEC'              				,text:'<t:message code="system.label.common.spec" default="규격"/>'          ,type:'string'}
            ,{name: 'ORDER_UNIT'        		,text:'<t:message code="system.label.common.unit" default="단위"/>'          ,type:'string'}
            ,{name: 'MAKER_NAME'        	,text:'<t:message code="system.label.common.mfgplace" default="제조처"/>'          ,type:'string'}
            ,{name: 'DIV_CODE'          			,text:'<t:message code="system.label.common.division" default="사업장"/>'        ,type:'string'}
            ,{name: 'GW_FLAG'          			,text:'<t:message code="system.label.common.drafting" default="기안여부"/>'      ,type:'string', comboType:'AU', comboCode:'WB17'}
            ,{name: 'CONFIRM_YN'        		,text:'<t:message code="system.label.common.confirmedpending" default="확정여부"/>'      ,type:'string', comboType:'AU', comboCode:'B010'}
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
		    layout : {type : 'table', columns : 2},
		    items: [{
                    fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
                    name: 'DIV_CODE',
                    holdable: 'hold',
                    xtype: 'uniCombobox',
                    comboType: 'BOR120',
                    allowBlank:false
                },{
                    fieldLabel: '<t:message code="system.label.common.requestdate2" default="의뢰일"/>',
                    startFieldName: 'P_REQ_DATE_FR',
                    endFieldName: 'P_REQ_DATE_TO',
                    xtype: 'uniDateRangefield',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today'),
                    allowBlank:false
                },{
                    fieldLabel: '<t:message code="system.label.common.classfication" default="구분"/>',
                    name:'TYPE',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'A003'
                },{
                    fieldLabel: '<t:message code="system.label.common.applydate" default="적용일"/>',
                    startFieldName: 'APLY_START_DATE_FR',
                    endFieldName: 'APLY_START_DATE_TO',
                    xtype: 'uniDateRangefield',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today')
                },{
                    fieldLabel: '<t:message code="system.label.common.prequestnum" default="의뢰번호"/>',
                    xtype:'uniTextfield',
                    name: 'P_REQ_NUM'
                }
            ]
		});
/**
 * Master Grid 정의(Grid Panel)
 * @type
 */
		 me.masterGrid = Unilite.createGrid('', {
			store: Unilite.createStore('${PKGNAME}.reqNumPopupMasterStore',{
							model: '${PKGNAME}.ReqNumPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'uniDirect',
					            api: {
					            	read: 'popupService.reqNumPopup'
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
							},
							groupField: 'P_REQ_NUM'
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
			features:  [ {id:  'masterGridSubTotal', ftype:  'uniGroupingsummary', showSummaryRow:  false },
					 {id:  'masterGridTotal'   , ftype:  'uniSummary'		, showSummaryRow:  false} ],
			selModel:'rowmodel',
		    columns:  [
                {dataIndex : 'P_REQ_DATE'             , width : 80},
                {dataIndex : 'P_REQ_NUM'              , width : 100},
                {dataIndex : 'SER_NO'                 , width : 70},
                {dataIndex : 'TYPE'                   , width : 50},
                {dataIndex : 'ITEM_NAME'             , width : 120},
                {dataIndex : 'SPEC'             , width : 120},
                {dataIndex : 'ORDER_UNIT'             , width : 50},
                {dataIndex : 'ITEM_P'             , width : 100},
                {dataIndex : 'MONEY_UNIT'             , width : 50},
                {dataIndex : 'APLY_START_DATE'        , width : 80},
//                {dataIndex : 'TREE_CODE'              , width : 100},
//                {dataIndex : 'TREE_NAME'              , width : 150},
//                {dataIndex : 'PERSON_NUMB'            , width : 100},
//                {dataIndex : 'PERSON_NAME'            , width : 150},
                {dataIndex : 'CUSTOM_CODE'             , width : 60, hidden: false},
                {dataIndex : 'CUSTOM_NAME'             , width : 100, hidden: false},
                {dataIndex : 'PRICE_TYPE'             , width : 100, hidden: true},
                {dataIndex : 'PAY_TERMS'             , width : 100, hidden: true},
                {dataIndex : 'MAKER_NAME'             , width : 100, hidden: true},
                {dataIndex : 'DIV_CODE'               , width : 80, hidden: true},
                {dataIndex : 'GW_FLAG'                , width : 80, hidden: true},
                {dataIndex : 'CONFIRM_YN'             , width : 80, hidden: true}
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
			var fieldTxt = frm.findField('P_REQ_NUM');
			//me.panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			me.panelSearch.setValue('DIV_CODE', param.DIV_CODE);
			me.panelSearch.setValue('P_REQ_DATE_FR', UniDate.get('startOfMonth'));
			me.panelSearch.setValue('P_REQ_DATE_TO', UniDate.get('today'));
			me.panelSearch.setValue('TYPE', param.TYPE);
			me.panelSearch.setValue('APLY_START_DATE_FR', UniDate.get('startOfMonth'));
			me.panelSearch.setValue('APLY_START_DATE_TO', UniDate.get('today'));
            me.panelSearch.setValue('P_REQ_NUM', param.P_REQ_NUM);

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
