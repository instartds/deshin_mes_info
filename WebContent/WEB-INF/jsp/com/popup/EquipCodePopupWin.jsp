<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	설비정보 팝업 'Unilite.app.popup.EquipCode' 
request.setAttribute("PKGNAME","Unilite.app.popup.EquipCode");
%>
<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="I802" />    // 설비구분

	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.EquipCodePopupModel', {
	    fields: [
            {name: 'COMP_CODE'               ,text:'<t:message code="system.label.common.companycode" default="법인코드"/>'               ,type: 'string'},
            {name: 'DIV_CODE'               		,text:'<t:message code="system.label.common.division" default="사업장"/>'                 ,type: 'string'},
            {name: 'EQUIP_CODE'             	,text:'<t:message code="system.label.common.facilitiescode" default="설비코드"/>'               ,type: 'string'},
            {name: 'EQUIP_NAME'              ,text:'<t:message code="system.label.common.facilitiesname" default="설비명"/>'                 ,type: 'string'},
            {name: 'EQUIP_SPEC'             	,text:'<t:message code="system.label.common.facilitiesspec" default="설비규격"/>'               ,type: 'string'},
            {name: 'EQUIP_TYPE'             	,text:'<t:message code="system.label.common.facilitiestype" default="설비구분"/>'               ,type: 'string', comboType: 'AU', comboCode: 'I802'},
            {name: 'DATE_PURCHASE'       ,text:'<t:message code="system.label.common.purchasedate" default="구입일"/>'               ,type: 'uniDate'},
            {name: 'PURCHASE_NAME'     ,text:'<t:message code="system.label.common.purchasecustom" default="구매처"/>'                 ,type: 'string'},
            {name: 'PURCHASE_AMT'        ,text:'<t:message code="system.label.common.purchaseamount" default="구매금액"/>'               ,type: 'uniPrice'},
            {name: 'MAKE_NAME'              ,text:'<t:message code="system.label.common.mfgplace" default="제조처"/>'                 ,type: 'string'},
            {name: 'DATE_MAKER'             ,text:'<t:message code="system.label.common.mfgdate" default="제조일"/>'               ,type: 'uniDate'},
            {name: 'REMARK'                 	   ,text:'<t:message code="system.label.common.remarks" default="비고"/>'                   ,type: 'string'},
            {name: 'INSERT_DB_USER'       ,text:'<t:message code="system.label.common.accntperson" default="입력자"/>'                 ,type: 'string'},
            {name: 'INSERT_DB_TIME'       ,text:'<t:message code="system.label.common.inputdate" default="입력일"/>'                 ,type: 'uniDate'},
            {name: 'UPDATE_DB_USER'     ,text:'<t:message code="system.label.common.updateuser" default="수정자"/>'                 ,type: 'string'},
            {name: 'UPDATE_DB_TIME'     ,text:'<t:message code="system.label.common.updatedate" default="수정일"/>'                 ,type: 'uniDate'},
            {name: 'PROG_WORK_CODE' ,text:'<t:message code="system.label.common.routingcode" default="공정코드"/>'               ,type: 'string'},
            {name: 'ITEM_CODE'               ,text:'<t:message code="system.label.common.itemcode" default="품목코드"/>'               ,type: 'string'}
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
                                    fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
                                    name:'DIV_CODE',
                                    xtype: 'uniCombobox',
                                    comboType:'BOR120',
                                    allowBlank:false,
                                    value: UserInfo.divCode
                                }/*,{ 
                                    fieldLabel: '구입일자',
                                    xtype: 'uniDateRangefield',
                                    startFieldName: 'DATE_PURCHASE_FR',
                                    endFieldName: 'DATE_PURCHASE_TO',
                                    startDate: UniDate.get('startOfMonth'),
                                    endDate: UniDate.get('today')
                                }*/,{
                                  fieldLabel : '<t:message code="system.label.common.searchword" default="검색어"/>',
                                  name : 'TXT_SEARCH',
                                  xtype: 'uniTextfield',
                                    listeners:{
                                        specialkey: function(field, e){
                                            if (e.getKey() == e.ENTER) {
                                               me.onQueryButtonDown();
                                            }
                                        }
                                    }
                                },{
                                  fieldLabel : '<t:message code="system.label.common.itemcode" default="품목코드"/>',
                                  name : 'ITEM_CODE',
                                  xtype: 'uniTextfield',
                                  hidden: true
                                },{
                                  fieldLabel : '<t:message code="system.label.common.routingcode" default="공정코드"/>',
                                  name : 'PROG_WORK_CODE',
                                  xtype: 'uniTextfield',
                                  hidden: true
                                }
                        ]
                    });
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
			
            store : Unilite.createStoreSimple('${PKGNAME}.EquipCodePopupMasterStore',{
							model: '${PKGNAME}.EquipCodePopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.equipCode'
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
                { dataIndex: 'COMP_CODE'                          ,           width: 80, hidden: true},
                { dataIndex: 'DIV_CODE'                           ,           width: 80, hidden: true},
                { dataIndex: 'EQUIP_CODE'                         ,           width: 100},
                { dataIndex: 'EQUIP_NAME'                         ,           width: 200},
                { dataIndex: 'EQUIP_SPEC'                         ,           width: 100},
                { dataIndex: 'EQUIP_TYPE'                         ,           width: 80, align: 'center'},
                { dataIndex: 'DATE_PURCHASE'                      ,           width: 80},
                { dataIndex: 'PURCHASE_NAME'                      ,           width: 200},
                { dataIndex: 'PURCHASE_AMT'                       ,           width: 80},
                { dataIndex: 'MAKE_NAME'                          ,           width: 200},
                { dataIndex: 'DATE_MAKER'                         ,           width: 80},
                { dataIndex: 'REMARK'                             ,           width: 200},
                { dataIndex: 'INSERT_DB_USER'                     ,           width: 80, hidden: true},
                { dataIndex: 'INSERT_DB_TIME'                     ,           width: 80, hidden: true},
                { dataIndex: 'UPDATE_DB_USER'                     ,           width: 80, hidden: true},
                { dataIndex: 'UPDATE_DB_TIME'                     ,           width: 80, hidden: true},
                { dataIndex: 'PROG_WORK_CODE'                     ,           width: 80, hidden: true},
                { dataIndex: 'ITEM_CODE'                          ,           width: 80, hidden: true}
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
			
			if(param['DIV_CODE'] && param['DIV_CODE']!='')	frm.setValue('DIV_CODE',   param['DIV_CODE']);
			if(param['EQUIP_CODE'] && param['EQUIP_CODE']!='')	frm.setValue('TXT_SEARCH', param['EQUIP_CODE']);
			if(param['EQUIP_NAME'] && param['EQUIP_NAME']!='')	frm.setValue('TXT_SEARCH', param['EQUIP_NAME']);
            if(param['ITEM_CODE'] && param['ITEM_CODE']!='')  frm.setValue('ITEM_CODE', param['ITEM_CODE']);
            if(param['PROG_WORK_CODE'] && param['PROG_WORK_CODE']!='')  frm.setValue('PROG_WORK_CODE', param['PROG_WORK_CODE']);
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