<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 거래처팝업
request.setAttribute("PKGNAME","Unilite.app.popup.GridConfigPopup");
%>
/**
 *   Model 정의 
 * @type 
 */
 var isAdmin = "${isAdmin}";
Unilite.defineModel('${PKGNAME}.GridConfigPopupModel', {
    fields: [	 {name: 'USER_ID' 			,text:'USERID' 	,type:'string', allowBlank:false	}
    			,{name: 'PGM_ID' 			,text:'<t:message code="system.label.common.programid" default="프로그램ID"/>' 	,type:'string', allowBlank:false	}
    			,{name: 'SHT_ID' 			,text:'GridID' 	,type:'string', allowBlank:false	}
    			,{name: 'SHT_SEQ' 			,text:'<t:message code="system.label.common.settings" default="설정"/>SEQ' 	,type:'string', allowBlank:false	}
    			,{name: 'SHT_NAME' 			,text:'<t:message code="system.label.common.settings" default="설정"/>' 	,type:'string',	allowBlank:false	}
				,{name: 'SHT_DESC' 			,text:'<t:message code="system.label.common.desc" default="설명"/>' 	,type:'string'	}
				,{name: 'SHT_TYPE' 			,text:'<t:message code="system.label.common.type" default="유형"/>' 	,type:'string'	, comboType:'AU',comboCode:'B125' , defaultValue: 'P'}
				,{name: 'SHT_INFO' 			,text:'<t:message code="system.label.common.shtinfo" default="설정정보"/>' 	,type:'string'	}
				,{name: 'DEFAULT_YN' 		,text:'<t:message code="system.label.common.basicsetting" default="기본설정"/>' 	,type:'string'	, comboType:'AU',comboCode:'B010' , defaultValue: 'Y'}
				,{name: 'QLIST_YN' 			,text:'<t:message code="system.label.common.quicklist" default="빠른목록"/>' 	,type:'string'	, comboType:'AU',comboCode:'B010' , defaultValue: 'Y'}
				
		]
});

/**
 * 검색조건 (Search Panel)
 * @type 
 */
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupGridApp',    
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
		console.log("wParam :", wParam);
		me.detailForm = Unilite.createSimpleForm( '', {
		    layout: {
	            type: 'uniTable',
	            columns: 3
			},	
			hidden:true,
			items: [  					  
					  { fieldLabel: '<t:message code="system.label.common.type" default="유형"/>', 		name:'SHT_TYPE',  	xtype: 'uniCombobox', comboType:'AU',comboCode:'B125' ,allowBlank:false}
					 ,{ fieldLabel: '<t:message code="system.label.common.basicsetting" default="기본설정"/>', 	name:'DEFAULT_YN',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B010' ,allowBlank:false}					 
					 ,{ fieldLabel: '<t:message code="system.label.common.quicklist" default="빠른목록"/>', 	name:'QLIST_YN',  	xtype: 'uniCombobox', comboType:'AU',comboCode:'B010' ,allowBlank:false}
					 ,{ fieldLabel: '<t:message code="system.label.common.settingsname" default="설정명"/>', 		name:'SHT_NAME', 	allowBlank:false, width: 490, colspan:3}
					 ,{ fieldLabel: '<t:message code="system.label.common.desc" default="설명"/>', 		name:'SHT_DESC', 	width: 490,	colspan:3}
					 ,{ fieldLabel: 'USERID', 	name:'USER_ID', 	allowBlank:false, hidden:true}
					 ,{ fieldLabel: '<t:message code="system.label.common.programid" default="프로그램ID"/>', 	name:'PGM_ID', 		allowBlank:false, hidden:true}
					 ,{ fieldLabel: '<t:message code="system.label.common.gridid" default="그리드ID"/>', 	name:'SHT_ID', 		allowBlank:false, hidden:true}
					 ,{ fieldLabel: '<t:message code="system.label.common.settings" default="설정"/>SEQ', 	name:'SHT_SEQ', 	    value:0 ,hidden:true}
					 ,{ fieldLabel: '<t:message code="system.label.common.gridinfo" default="그리드정보"/>', 	name:'SHT_INFO', 	allowBlank:false, hidden:true}
					 ,{ fieldLabel: '<t:message code="system.label.common.popupusage" default="팝업용도"/>', 	name:'MODE', 	allowBlank:false, value: wParam.MODE ,hidden:true} // MODE == 'save' 그리드 수정 팝업
			]
		});  
		
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		 me.masterGrid = Unilite.createGrid('', {
		 	param : wParam,
		 	uniOpt: {
		 		state: {
					useState: false,
					useStateList: false
				},
				pivot : {
					use : false
				}
		 	},
			store: Unilite.createStore('GridConfigPopupMasterStore',{
							model: '${PKGNAME}.GridConfigPopupModel',
					        autoLoad: false,
					        uniOpt: {
					            isMaster: true,         // 상위 버튼 연결
					            editable: (wParam.MODE=="save")? true:false,         // 수정 모드 사용
					            deletable: true,        // 삭제 가능 여부
					            allDeletable: true,     // 전체 삭제 가능 여부
					            useNavi : false         // prev | next 버튼 사용
					        },
					        proxy: {
					            type: 'uniDirect',
					            api: {
					            	read: 'extJsStateProviderService.selectStateList',
					            	update:'extJsStateProviderService.updateOne',
					            	destroy:'extJsStateProviderService.deleteOne',
					            	syncAll:'extJsStateProviderService.saveAll'
					            }
					        }
					}),
			selModel:'rowmodel',
		    columns:  [        
		           		  
						 { dataIndex: 'SHT_NAME'		,width: 120 } 						
						,{ dataIndex: 'SHT_TYPE'		,width: 80}  
						,{ dataIndex: 'DEFAULT_YN'		,width: 80}
						,{ dataIndex: 'QLIST_YN'		,width: 80}
						,{ dataIndex: 'SHT_DESC'		,width: 120 , flex:1 }
				
		      ] ,
			listeners: {
				beforeedit:function(editor, context, eOpts)	{
	        		if(context.field == "SHT_TYPE" )	{
	        			return false;
	        		}
					if(isAdmin == "false" && context.record.get("SHT_TYPE") == "C")	{
						return false;
					}
				},
				onGridDblClick:function(grid, record, cellIndex, colName) {
					if(me.masterGrid.param.MODE != "save")	{
						me.returnData(record.data);
					}
		        },
				onGridKeyDown: function(grid, keyCode, e) {
					if(me.masterGrid.param.MODE != "save")	{
						if(e.getKey() == Ext.EventObject.ENTER) {
				        	var selectRecord = grid.getSelectedRecord();
							me.returnData(selectRecord.data);
			        	}
					}
				}
			}
		})
		config.items = [me.detailForm,	me.masterGrid];
		me.callParent(arguments);
		
    },
    initComponent : function(){    
    	var me  = this;
        me.masterGrid.store.winToolbar = this.toolbar,
        me.masterGrid.focus();

    	this.callParent();    	
    },
	fnInitBinding : function(param) {
		var me = this;
		var detailForm = me.detailForm;
					
		detailForm.setValue('USER_ID', 	UserInfo.userID);
		detailForm.setValue('PGM_ID', 	param.PGM_ID);
		detailForm.setValue('SHT_ID', 	param.SHT_ID);
		
		if(param.MODE == 'save') {
			me.setToolbarButtons(['save','delete'],true);
			me.setToolbarButtons(['reset'],false);
			this._dataLoad();
		}else {
			me.setToolbarButtons(['save','reset'],false);
			me.setToolbarButtons(['save','delete'],true);
			me.masterGrid.store.uniOpt.isMaster = true;
			me.masterGrid.store.uniOpt.editable=false;
			me.masterGrid.store.uniOpt.deletable=true;
			me.masterGrid.store.uniOpt.allDeletable=false;
			
			this._dataLoad();
		}
	},
	onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
		var selectRecord = me.masterGrid.getSelectedRecord();
		if(selectRecord)	{
			me.returnData(selectRecord.data);
		} else {
			me.returnData(null);
		}
	},
	onSaveDataButtonDown: function () {
		console.log('Save');
        var me = this;
        var store = me.masterGrid.store;		
        var userId = UserInfo.userID;
        
        var inValidRecs = store.getInvalidRecords();
   		var rv = true;
        var toUpdate = store.getUpdatedRecords();        		
   		var toDelete = store.getRemovedRecords();
   		var changedRec = [].concat(toDelete).concat(toUpdate);
   		
   		if(changedRec.length == 0)	{
   			alert("저장할 데이타가 없습니다.");
   			Ext.getBody().unmask();
   			return;
   		}
   		/*
   		Ext.each(changedRec, function(rec){
   			if(rec.get("USER_ID") != userId)	{
   				alert("다른 사용자의 설정 정보를 변경할 수 없습니다.");
   				rv = false;
   				return;
   			}
   		});*/
   		// 기본설정 갯수 체크
   		var persnalData = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('SHT_TYPE')== "P" && record.get('DEFAULT_YN')== "Y") } ).items);
   		if(persnalData.length > 1)	{
   			alert("기본설정은 1개만 할 수 있습니다.");
   			rv = false;
   		}
		if(isAdmin == "true")	{
			var adminData = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('SHT_TYPE')== "C" && record.get('DEFAULT_YN')== "Y") } ).items);
			if(adminData.length > 1)	{
	   			alert("기본설정은 1개만 할 수 있습니다.");
	   			rv = false;
	   		}
		}
   		if(!rv){
   			return;
   		}
   		
    	if(inValidRecs.length == 0 )	{		
			store.syncAllDirect();
		}
		
	},
	_dataLoad : function() {
			var me = this;
			var param= me.detailForm.getValues();
			
			console.log( "_dataLoad: ", param );
			me.isLoading = true;
			me.masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
	},
	onDeleteDataButtonDown: function()	{
		var me = this;
		var record = me.masterGrid.getSelectedRecord();
		var userId = UserInfo.userID;
		
        if(record) {
			if(confirm(Msg.sMB062)) {		
				me.masterGrid.deleteSelectedRow();
			}
		}
	}
});