<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.PlanNumPopup");
%>

/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.PlanNumPopupModel', {
    fields: [
            {name: 'COMP_CODE'              , text: '<t:message code="system.label.common.companycode" default="법인코드"/>'      ,type: 'string'},
            {name: 'DIV_CODE'               , text: '<t:message code="system.label.common.division" default="사업장"/>'        ,type: 'string', comboType:'BOR120'},
            {name: 'PLAN_NUM'               , text: '<t:message code="system.label.common.planno" default="계획번호"/>'      ,type: 'string'},
            {name: 'PLAN_DATE'              , text: '<t:message code="system.label.common.writtendate" default="작성일"/>'      ,type: 'uniDate'},
            {name: 'ITEM_CODE'              , text: '<t:message code="system.label.common.itemcode" default="품목코드"/>'      ,type: 'string'},
            {name: 'ITEM_NAME'              , text: '<t:message code="system.label.common.itemname" default="품목명"/>'        ,type: 'string'},
            {name: 'SPEC'                   , text: '<t:message code="system.label.common.spec" default="규격"/>'          ,type: 'string'},
            {name: 'OEM_ITEM_CODE'          , text: '<t:message code="system.label.common.oemitemcode" default="품번(OEM)"/>'          ,type: 'string'},
            {name: 'CAR_TYPE'               , text: '<t:message code="system.label.common.cartype" default="차종"/>'          ,type: 'string'},
            {name: 'MAKE_DATE'              , text: '<t:message code="system.label.common.makedate" default="양산시점"/>'      ,type: 'uniDate'}
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
                    name:'DIV_CODE',
                    allowBlank: false,
                    xtype: 'uniCombobox',
                    comboType:'BOR120',
                    value: UserInfo.divCode
               },{
                    fieldLabel: '<t:message code="system.label.common.writtendate" default="작성일"/>',
                    xtype: 'uniDateRangefield',
                    allowBlank: false,
                    startFieldName: 'PLAN_DATE_FR',
                    endFieldName: 'PLAN_DATE_TO',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today')
                },{
                    fieldLabel: '<t:message code="system.label.common.planno" default="계획번호"/>',
                    name:'PLAN_NUM',  
                    xtype: 'uniTextfield'
                },
                Unilite.popup('DIV_PUMOK',{ 
                        fieldLabel: '<t:message code="system.label.common.itemcode" default="품목코드"/>',
                        valueFieldName: 'ITEM_CODE', 
                        textFieldName: 'ITEM_NAME', 
                        listeners: {
                            applyextparam: function(popup){                         
                                popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                            }
                        }
                })
            ]
		}); 
/**
 * Master Grid 정의(Grid Panel)
 * @type 
 */
		 me.masterGrid = Unilite.createGrid('', {
			store: Unilite.createStore('${PKGNAME}.planNumPopupMasterStore',{
							model: '${PKGNAME}.PlanNumPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'uniDirect',
					            api: {
					            	read: 'popupService.planNumPopup'
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
                { dataIndex: 'COMP_CODE'                ,       width: 80, hidden: true},            
                { dataIndex: 'DIV_CODE'                 ,       width: 80},            
                { dataIndex: 'PLAN_NUM'                 ,       width: 100},            
                { dataIndex: 'PLAN_DATE'                ,       width: 80},             
                { dataIndex: 'ITEM_CODE'                ,       width: 110},                         
                { dataIndex: 'ITEM_NAME'                ,       width: 200},                         
                { dataIndex: 'SPEC'                     ,       width: 100},                         
                { dataIndex: 'OEM_ITEM_CODE'            ,       width: 100},                         
                { dataIndex: 'CAR_TYPE'                 ,       width: 100},                         
                { dataIndex: 'MAKE_DATE'                ,       width: 80} 
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
			var fieldTxt = frm.findField('PLAN_NUM');
			//me.panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			me.panelSearch.setValue('DIV_CODE', param.DIV_CODE);
			me.panelSearch.setValue('PLAN_DATE_FR', UniDate.get('startOfMonth'));
			me.panelSearch.setValue('PLAN_DATE_TO', UniDate.get('today'));
            me.panelSearch.setValue('PLAN_NUM', param.PLAN_NUM);
			
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
