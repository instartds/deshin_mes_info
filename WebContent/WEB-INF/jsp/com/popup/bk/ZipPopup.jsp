<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
/**
*	우편번호 팝업 
*
*/
%>

<t:appConfig pgmId="crm.pop.ZipPopup"  />
<script type="text/javascript" >
function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('ZipPopupModel', {
	    fields: [ 	 {name: 'ZIP_CODE' 			,text:'우편번호' 	,type:'string'	}
					,{name: 'ZIP_NAME' 			,text:'지명' 		,type:'string'	}
					,{name: 'ZIP_CODE1_NAME' 	,text:'시도' 		,type:'string'	}
					,{name: 'ZIP_CODE2_NAME' 	,text:'시군구' 		,type:'string'	}
					,{name: 'ZIP_CODE3_NAME' 	,text:'읍면동' 		,type:'string'	}
					,{name: 'ZIP_CODE5_NAME' 	,text:'지번' 		,type:'string'	}
					,{name: 'ZIP_CODE4_NAME' 	,text:'도로명' 		,type:'string'	}
					,{name: 'ZIP_CODE7_NAME' 	,text:'다량배달처' 	,type:'string'	}
					,{name: 'LAW_DONG' 			,text:'법정동' 	,type:'string'	}
					,{name: 'ADDR2' 			,text:'주소2' 		,type:'string'	}
			]
	});
	
  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('zipPopupMasterStore',{
			model: 'ZipPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'popupService.zipPopup'
                }
            }
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	
	var panelSearch = Unilite.createSearchForm('searchForm',{
        layout : {type : 'uniTable', columns : 2},
        items: [  { hideLabel:true, name: 'ADDR_TYPE',width:130, xtype: 'uniRadiogroup', comboType:'AU',comboCode:'B232', value:'A'  , allowBlank:false}
        		 ,{ fieldLabel: '읍/면/동/도로', 	name:'TXT_SEARCH', id:'TXT_SEARCH', allowBlank:false} ]
    });  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
     var masterGrid = Unilite.createGrid('ZipPopupGrid', {
    	store: directMasterStore,    	
        columns:  [  { dataIndex: 'ZIP_CODE'		,width: 60 }     
        			,{ dataIndex: 'ZIP_NAME'		,width: 300 }   
               		,{ dataIndex: 'ZIP_CODE1_NAME'		,width: 100, hidden:true }  
					,{ dataIndex: 'ZIP_CODE2_NAME'		,width: 100, hidden:true } 
					,{ dataIndex: 'ZIP_CODE3_NAME'		,width: 100, hidden:true } 
					,{ dataIndex: 'ZIP_CODE5_NAME'		,width: 100, hidden:true} 
					,{ dataIndex: 'ZIP_CODE4_NAME'		,width: 100, hidden:true } 
					,{ dataIndex: 'ZIP_CODE7_NAME'		,width: 100, hidden:true  } 
					,{ dataIndex: 'LAW_DONG'		,width: 80 } 
					,{ dataIndex: 'ADDR2' 			,width: 100, hidden:true 	}
          ] 
          ,listeners: {	
          				select: function( grid, record, item, index, e, eOpts ) {
					        var param2= Ext.getCmp('ZipPopupDetail').getValues();	
					        var addr2 ='';
					        if(param2['BUILDING'].trim()!='' || param2['DONG'].trim()!='' || param2['HO'].trim()!='')	{					        	
								addr2= param2['BUILDING']+' '+param2['DONG']+'동 '+ param2['HO']+'호';
									
					        } else if(param2['ADDR2'].trim()!='') {
					        	addr2= param2['ADDR2'];
					        }
					        record.set('ADDR2',addr2);
		                }
          
		         , onGridDblClick:function(grid, record, cellIndex, colName) {
		          	var rv = {
						status : "OK",
						data:[record.data]
					};
					window.returnValue = rv;
					window.close();
		          }
          } //listeners
          
    });
    
    var detailForm = Unilite.createForm('ZipPopupDetail', {
	    layout: {type: 'uniTable', columns: 4},
	    defaultType: 'uniTextfield',
	    masterGrid: masterGrid,	     
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
        					
    
     	Unilite.PopupMain({
		items : [panelSearch, 	masterGrid, detailForm],
		id  : 'ZipPopupApp',
		fnInitBinding : function() {
			
		},
		 onQueryButtonDown : function()	{
		 	var form = Ext.getCmp('searchForm')
		 	if(form.isValid( ))	{
				this._dataLoad();
		 	}else {
		 		form.findField('TXT_SEARCH').focus();
		 	}
		},
		onSubmitButtonDown : function()	{
			var selectRecord = masterGrid.getSelectedRecord();
		 	var rv = {
				status : "OK",
				data:[selectRecord.data]
			};
			window.returnValue = rv;
			window.close();
		},
		_dataLoad : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			masterGrid.getStore().load({
				params : param
			});
		}
	});
	
	function fnBlurField (field) {
				var formValues = Ext.getCmp('ZipPopupDetail').getForm().getValues();
				var addr2 = '';
				var grd = Ext.getCmp('ZipPopupGrid');
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

};


</script>
