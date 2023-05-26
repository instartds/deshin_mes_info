<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	금형정보 팝업 'Unilite.app.popup.MoldCode' 
request.setAttribute("PKGNAME","Unilite.app.popup.MoldCode");
%>
<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="WB04" />    // 차종  
<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="WB07" />    // 금형구분

	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.MoldCodePopupModel', {
	    fields: [
            {name: 'COMP_CODE'              ,text:'<t:message code="system.label.common.companycode" default="법인코드"/>'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'<t:message code="system.label.common.division" default="사업장"/>'                 ,type: 'string'},
            {name: 'MOLD_CODE'              ,text:'<t:message code="system.label.common.moldcode" default="금형코드"/>'               ,type: 'string'},
            {name: 'MOLD_NAME'              ,text:'<t:message code="system.label.common.moldname" default="금형명"/>'                 ,type: 'string'},
            {name: 'MOLD_TYPE'              ,text:'<t:message code="system.label.common.moldtype" default="금형구분"/>'               ,type: 'string', comboType: 'AU', comboCode: 'WB08'},
            {name: 'MOLD_MTL'               ,text:'<t:message code="system.label.common.moldmtl" default="금형소재"/>'               ,type: 'string', comboType: 'AU', comboCode: 'I803'},
            {name: 'MOLD_STRC'               ,text:'금형구조'               ,type: 'string'},
            {name: 'OEM_ITEM_CODE'          ,text:'<t:message code="system.label.common.oemitemcode" default="품번(OEM)"/>'                   ,type: 'string'},
            {name: 'CAR_TYPE'               ,text:'<t:message code="system.label.common.cartype" default="차종"/>'                   ,type: 'string', comboType:'AU', comboCode:'WB04'},
            {name: 'DATE_INST'              ,text:'<t:message code="system.label.common.installdate" default="설치일"/>'               ,type: 'uniDate'},
            {name: 'ST_LOCATION'            ,text:'<t:message code="system.label.common.locationstatus" default="위치상태"/>'               ,type: 'string', comboType: 'AU', comboCode: 'WB09'},
            {name: 'MAX_DEPR'               ,text:'<t:message code="system.label.common.maxdepreciation" default="최대상각"/>'               ,type: 'int'},
            {name: 'CHK_DEPR'               ,text:'<t:message code="system.label.common.checkdepreciation" default="점검상각"/>'               ,type: 'int'},
            {name: 'NOW_DEPR'               ,text:'<t:message code="system.label.common.newdepreciation" default="현상각"/>'                 ,type: 'int'},
            {name: 'PROG_WORK_CODE'         ,text:'<t:message code="system.label.common.routingcode" default="공정코드"/>'               ,type: 'string'},
            {name: 'ITEM_CODE'              ,text:'<t:message code="system.label.common.itemcode" default="품목코드"/>'               ,type: 'string'}
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
                                    startFieldName: 'DATE_INST_FR',
                                    endFieldName: 'DATE_INST_TO',
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
                                  fieldLabel : '<t:message code="system.label.common.oemitemcode" default="품번(OEM)"/>',
                                  name : 'OEM_ITEM_CODE',
                                  xtype: 'uniTextfield'
                                },{
                                  fieldLabel : '<t:message code="system.label.common.itemcode" default="품목코드"/>',
                                  name : 'ITEM_CODE',
                                  xtype: 'uniTextfield',
                                  hidden: true
                                },{
                                  fieldLabel : '<t:message code="system.label.common.routing" default="공정"/>',
                                  name : 'PROG_WORK_CODE',
                                  xtype: 'uniTextfield',
                                  hidden: true
                                }
                        ]
                    });
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
			
            store : Unilite.createStoreSimple('${PKGNAME}.MoldCodePopupMasterStore',{
							model: '${PKGNAME}.MoldCodePopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.moldCode'
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
                { dataIndex: 'COMP_CODE'                             ,           width: 80, hidden: true},
                { dataIndex: 'DIV_CODE'                              ,           width: 80, hidden: true},
                { dataIndex: 'MOLD_CODE'                             ,           width: 110},
                { dataIndex: 'MOLD_NAME'                             ,           width: 200},
                { dataIndex: 'MOLD_TYPE'                             ,           width: 80},
                { dataIndex: 'MOLD_MTL'                              ,           width: 80},
                { dataIndex: 'MOLD_STRC'                              ,           width: 80},
                { dataIndex: 'OEM_ITEM_CODE'                         ,           width: 100},
                { dataIndex: 'CAR_TYPE'                              ,           width: 80},
                { dataIndex: 'DATE_INST'                             ,           width: 80},
                { dataIndex: 'ST_LOCATION'                           ,           width: 100},
                { dataIndex: 'MAX_DEPR'                              ,           width: 80},
                { dataIndex: 'CHK_DEPR'                              ,           width: 80},
                { dataIndex: 'NOW_DEPR'                              ,           width: 80},
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
			if(param['MOLD_CODE'] && param['MOLD_CODE']!='')	frm.setValue('TXT_SEARCH', param['MOLD_CODE']);
			if(param['MOLD_NAME'] && param['MOLD_NAME']!='')	frm.setValue('TXT_SEARCH', param['MOLD_NAME']);
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