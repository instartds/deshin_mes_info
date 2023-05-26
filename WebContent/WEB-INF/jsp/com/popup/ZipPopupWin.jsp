<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 우편번호 팝업
request.setAttribute("PKGNAME","Unilite.app.popup.ZipPopup");
%>
/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.ZipPopupModel', {
    fields: [ 	 {name: 'ZIP_CODE' 			,text:'<t:message code="system.label.common.zipcode" default="우편번호"/>' 	,type:'string'	}
				,{name: 'ZIP_NAME' 			,text:'<t:message code="system.label.common.zipname" default="지명"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE1_NAME' 	,text:'<t:message code="system.label.common.do" default="시도"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE2_NAME' 	,text:'<t:message code="system.label.common.gu" default="시군구"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE3_NAME' 	,text:'<t:message code="system.label.common.town" default="읍면동"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE5_NAME' 	,text:'<t:message code="system.label.common.lotnum" default="지번"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE4_NAME' 	,text:'<t:message code="system.label.common.roadname" default="도로명"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE7_NAME' 	,text:'<t:message code="system.label.common.massdelivery" default="다량배달처"/>' 	,type:'string'	}
				,{name: 'LAW_DONG' 			,text:'<t:message code="system.label.common.lawdong" default="법정동"/>' 	,type:'string'	}
				,{name: 'ADDR2' 			,text:'<t:message code="system.label.common.address2" default="주소2"/>' 		,type:'string'	}
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
	    /*var t1= false, t2 = false;
	    if( Ext.isDefined(wParam)) {
	        if(wParam['ADDR_TYPE'] == 'B') {
	            t1 = true;
	            t2 = false;			            
	        } else {
	            t1 = false;
	            t2 = true;			            
	        }
	    }*/

		me.panelSearch = Unilite.createSearchForm('',{
		    layout : {type : 'uniTable', columns : 2},
		    items: [  { hideLabel:true, name: 'ADDR_TYPE',width:130, xtype: 'uniRadiogroup', comboType:'AU',comboCode:'B232', value:wParam['ADDR_TYPE'], allowBlank:false}
		    		 ,{ fieldLabel: '<t:message code="system.label.common.addrdetail" default="읍/면/동/도로"/>', 	name:'TXT_SEARCH', allowBlank:false,
		    		     listeners:{
		    		  		blur:function()	{
		    		  			if(me && me.panelSearch )me.panelSearch.setValue('ZIP_CODE','');
		    		  		}
		    		     }
		    		  }
		    		 ,{ fieldLabel: '<t:message code="system.label.common.zipcode" default="우편번호"/>', 		name:'ZIP_CODE', hidden:true}]
		});  
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		me.masterGrid = Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}.zipPopupMasterStore',{
							model: '${PKGNAME}.ZipPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.zipPopup'
					            }
					        }
					}), 
		 	uniOpt:{	
		 		expandLastColumn: false,
	        	useRowNumberer: false,
	            useMultipleSorting: false,
	            state: {
					useState: false,
					useStateList: false	
	            },
				pivot : {
					use : false
				}  
	        },
	        selModel:'rowmodel',
		    columns:  [  { dataIndex: 'ZIP_CODE'		,width: 70 }     
		    			,{ dataIndex: 'ZIP_NAME'		,flex:1 }   
		           		,{ dataIndex: 'ZIP_CODE1_NAME'		,width: 100, hidden:true }  
						,{ dataIndex: 'ZIP_CODE2_NAME'		,width: 100, hidden:true } 
						,{ dataIndex: 'ZIP_CODE3_NAME'		,width: 100, hidden:true } 
						,{ dataIndex: 'ZIP_CODE5_NAME'		,width: 100, hidden:true} 
						,{ dataIndex: 'ZIP_CODE4_NAME'		,width: 100, hidden:true } 
						,{ dataIndex: 'ZIP_CODE7_NAME'		,width: 100, hidden:true } 
						,{ dataIndex: 'LAW_DONG'		,width: 80 } 
						,{ dataIndex: 'ADDR2' 			,width: 100, hidden:true 	}
		    ], 
		    listeners: {	
		     	select: function( grid, record, item, index, e, eOpts ) {
			        var param2= me.detailForm.getValues();	
			        var addr2 ='';
			        if(param2['BUILDING'].trim()!='' || param2['DONG'].trim()!='' || param2['HO'].trim()!='')	{					        	
						addr2= param2['BUILDING']+' '+param2['DONG']+'동 '+ param2['HO']+'호';
							
			        } else if(param2['ADDR2'].trim()!='') {
			        	addr2= param2['ADDR2'];
			        }
			        record.set('ADDR2',addr2);
                },		      
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
		    } //listeners
		      
		});
		me.detailForm = Unilite.createForm('', {
	    layout: {type: 'uniTable', columns: 4},
	    defaultType: 'uniTextfield',
	    masterGrid: me.masterGrid,	     
	    disabled : false,
		items :[	  {name : 'rdoSel', xtype: 'radiofield', width:100, hideLabel:true, boxLabel: '아파트(동,호)', inputValue:'A', checked: true
						, listeners : {	change : function(field) { fnBlurField(field); 	}} 
					  }
					 ,{hideLabel:true, fieldLabel: '아파트',  name: 'BUILDING' ,allowBlank: false, width:100, suffixTpl:'&nbsp;'
							, listeners : {	change : function(field) { fnBlurField(field); 	}} 
					  } // field
					 ,{hideLabel:true,  name: 'DONG' ,suffixTpl:'&nbsp;동&nbsp;' , width:100
							, listeners : {	change : function(field) { fnBlurField(field); 	}} 
					  }
					 ,{hideLabel:true,  name: 'HO' ,suffixTpl:'&nbsp;호' , width:100
							, listeners : {	change : function(field) { fnBlurField(field); 	}} 
					  }
					 ,{name : 'rdoSel',  xtype: 'radiofield', hideLabel:true, boxLabel: '아파트 이외', value:'N'
						, listeners : {	change : function(field) { fnBlurField(field); 	}} 
					  }
					 ,{hideLabel:true, name: 'ADDR2',colspan : 3 , width:285
							, listeners : {	change : function(field) { fnBlurField(field); 	}} 
					  } 
				]
		});
		config.items = [me.panelSearch,	me.masterGrid, me.detailForm ];
		me.callParent(arguments);
		
		function fnBlurField (field) {
			var formValues = me.detailForm.getForm().getValues();
			var addr2 = '';	
			var grd = me.masterGrid;
			var grdRecord = grd.getSelectedRecord();
			if(grd.getSelectedRowIndex() >= 0)	{						
				if(formValues['rdoSel'] == 'A') {
				 	addr2 = formValues['BUILDING']+' '+ formValues['DONG']+'동 '+ formValues['DONG']+'호';					
				}else {
					addr2 = formValues['ADDR2'];
				}
				grdRecord.set('ADDR2',addr2);
			}
		} 
    },
	initComponent : function(){    
    	var me  = this;
        
        me.masterGrid.focus();
        
    	this.callParent();    	
    },    
	fnInitBinding : function(param) {
			var me  = this;
			var frm = me.panelSearch;
			
			if(param['ZIP_CODE']) 	frm.setValue('ZIP_CODE', param['ZIP_CODE']);
			if(param['ADDR']) 		frm.setValue('TXT_SEARCH', param['ADDR']);
			//if(param['ADDR_TYPE'])  frm.setValue('ADDR_TYPE', param['ADDR_TYPE']);
			if(frm.getForm().isValid( ))	{
				me._dataLoad();
			}
	},
	 onQueryButtonDown : function()	{
	 	var me = this;
	 	var form = me.panelSearch.getForm();
	 	if(form.isValid( ))	{
			me._dataLoad();
	 	}
	},
	onSubmitButtonDown : function()	{
        var me=this;
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
		console.log( param );
		me.isLoading = true;
		me.masterGrid.getStore().load({
			params : param,
			callback:function()	{
				me.isLoading = false;
			}
		});
	}
});

