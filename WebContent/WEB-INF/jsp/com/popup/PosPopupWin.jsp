<%@page language="java" contentType="application/javascript; charset=utf-8"%>

	



<%
// 장비
request.setAttribute("PKGNAME","Unilite.app.popup.PosPopup");
%>
	<t:ExtComboStore useScriptTag="false" items="${COMBO_WH_LIST}" storeId="whList" />		// 창고
/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.PosPopupModel', {
    fields: [ 	 
				 {name: 'DIV_CODE' 			,text:'<t:message code="system.label.common.division" default="사업장"/>' 			,type:'string'	,comboType:"BOR120"}
				,{name: 'POS_NO' 				,text:'<t:message code="system.label.common.posno" default="장비번호"/>' 			,type:'string'	}
				,{name: 'POS_TYPE' 			,text:'<t:message code="system.label.common.postype" default="장비유형"/>' 			,type:'string'	 ,comboType:"AU", comboCode:"YP06" }
				,{name: 'POS_NAME' 		,text:'<t:message code="system.label.common.posname" default="장비유형"/>' 			,type:'string'	}
				,{name: 'WH_NAME' 			,text:'<t:message code="system.label.common.warehousename" default="창고명"/>' 			,type:'string'	}
				,{name: 'WH_CODE' 			,text:'<t:message code="system.label.common.warehousecode" default="창고코드"/>' 			,type:'string'	, store: Ext.data.StoreManager.lookup('whList')}
				,{name: 'DEPT_CODE' 		,text:'<t:message code="system.label.common.departmencode" default="부서코드"/>' 			,type:'string'	}
				,{name: 'DEPT_NAME' 		,text:'<t:message code="system.label.common.departmentname" default="부서명"/>' 			,type:'string'	}
				,{name: 'LOCATION' 			,text:'<t:message code="system.label.common.location" default="위치"/>' 				,type:'string'	}
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
		    layout : {type : 'uniTable', columns : 3, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items: [  { fieldLabel: '<t:message code="system.label.common.classfication" default="구분"/>',id:'posGubun', 	name:'POS_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'YP06', colspan:3
		    			,onStoreLoad: function(combo, store, records, successful, eOpts) {
		    				if(me.param['POS_TYPE'] != '4'){
		    					combo.setValue(me.param['POS_TYPE']);
		    				}
		    				
		    			}
		    		},
		    		  { fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>', 		name:'DIV_CODE' , hidden:true}
					 ,{ fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>', 		name:'TXT_SEARCH',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
					 ,{ fieldLabel: '<t:message code="system.label.common.useflag" default="사용유무"/>',		name:'USE_YN', hidden:true}
					 ,{ fieldLabel: '<t:message code="system.label.common.equiptype" default="장비구분"/>', 
					 	xtype: 'radiogroup', width: 230,
					 	items:[	{inputValue: '1', boxLabel:'<t:message code="system.label.common.codeinorder" default="코드순"/>', name: 'RDO', checked: t1},
					 			{inputValue: '2', boxLabel:'<t:message code="system.label.common.nameinorder" default="이름순"/>',  name: 'RDO', checked: t2} ]
					 }			   
			       /* ,{ xtype:'button', text:'빠른등록' 
			          ,handler:function()	{
			          		me.openRegWindow();
			           }
			         }*/
			]
		});  
		
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		 me.masterGrid = Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}.posPopupMasterStore',{
							model: '${PKGNAME}.PosPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'uniDirect',
					            api: {
					            	read: 'popupService.posPopup'
					            	,create : 'bcm100ukrvService.insertSimple'
									,syncAll:'bcm100ukrvService.syncAll'
					            }
					        }
					        ,
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
		           		 { dataIndex: 'DIV_CODE'		,width: 80  , locked:true}  
						,{ dataIndex: 'POS_NO'			,width: 66 , locked:true} 
						,{ dataIndex: 'POS_TYPE'		,width: 100 , hidden: true}
						,{ dataIndex: 'POS_NAME'		,width: 180} 
						,{ dataIndex: 'WH_NAME'			,width: 66 }
						,{ dataIndex: 'WH_CODE'			,width: 100 }
						,{ dataIndex: 'DEPT_CODE'		,width: 88 }
						,{ dataIndex: 'DEPT_NAME'		,width: 140 }
						,{ dataIndex: 'LOCATION'		,width: 300 }
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
		})
		config.items = [me.panelSearch,	me.masterGrid];
		me.callParent(arguments);
		
		me.regCustForm = Unilite.createForm('',{
			
		    layout : {type : 'uniTable', columns : 1},
		 	masterGrid: me.masterGrid,
		    disabled:false,
		    buttonAlign :'center',
		    fbar: [
			        {  xtype: 'button', text: '<t:message code="system.label.common.save" default="저장"/>' ,
			           handler: function()	{
			        		me.masterGrid.getStore().saveStore({					        		
			        			success: function() {		
							 				var record = me.masterGrid.getSelectedRecord();
							 				var rv = {
												status : "OK",
												data:[record.data]
											};
											me.returnData(rv);
											me.regWindow.close();
								 }
			        		})
			        	}
			        },
			        {  xtype: 'button', text: '<t:message code="system.label.common.close" default="닫기"/>' ,
			        	handler:function()	{
			        		me.masterGrid.getStore().rejectChanges();
			        		me.regWindow.hide();
			        	}
			        }
				   ],
		    items: [  { fieldLabel: '<t:message code="system.label.common.classfication" default="구분"/>', 	name:'POS_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'YP06' }
					 ,{ fieldLabel: '<t:message code="system.label.common.equipname" default="장비"/>', 	name:'POS_NAME'}
					 
			]
		});  
		
		me.regWindow = Ext.create('Ext.window.Window', {
                title: '장비 빠른 입력',
                modal: true,
                closable: false,
                width: 300,				                
                height: 130,
                items: [me.regCustForm],
                hidden:true,
                listeners : {
                			 show:function( window, eOpts)	{
                			 	me.regCustForm.reset();
                			 	me.regCustForm.body.el.scrollTo('top',0);	                			 	
                			 }
            
                		}
		});
    },
    initComponent : function(){    
    	var me  = this;
        
        me.masterGrid.focus();

    	this.callParent();    	
    },
	fnInitBinding : function(param) {
		var me = this;
		me.param = param;
		
		var frm= me.panelSearch.getForm();
		
		var rdo = frm.findField('RDO');
		var fieldTxt = frm.findField('TXT_SEARCH');
		//var customType = frm.findField('CUSTOM_TYPE');
		//var companyNum = frm.findField('COMPANY_NUM');
		frm.setValues(param);
		if( Ext.isDefined(param)) {
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				if(param['TYPE'] == 'VALUE') {
					fieldTxt.setValue(param['POS_NO']);
					rdo.setValue('1');
				} else {
					fieldTxt.setValue(param['POS_NAME']);
					rdo.setValue('2');
				}
			}
			//customType.setValue(param['CUSTOM_TYPE']);  //combo store 의 load 와 비동기로 값 설정이 안되어 setCustomTypeCombo 사용으로 변경
			//companyNum.setValue(param['COMPANY_NUM']);	
		}
		
		if(param.POS_TYPE == '4'){
			customType.setValue(param['POS_TYPE']);
			Ext.getCmp('posGubun').setReadOnly(true);
		}
		
		
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
		me.close();
	},
	openRegWindow:function()	{
		var me = this;
		console.log("openRegWindow:me", me);
		me.regWindow.show();
		var selRecord = me.masterGrid.createRow();	
		me.regCustForm.setActiveRecord(selRecord||null);
		
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


