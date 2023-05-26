<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.util.*" %>
<%@page import="foren.unilite.modules.com.combo.ComboItemModel" %>
<%@ taglib prefix="t" uri="/WEB-INF/tld/tLab.tld"%>



<script type="text/javascript">

	function openModalC(sUrl, sParam, sWithd, sHeight, sFeatures) {
	    var returnVal = new Array();
	
	    var xPos = (screen.availWidth - sWithd) / 2;
	    var yPos = (screen.availHeight - sHeight ) / 2 ;
	
	    if(sFeatures == null || sFeatures == "") {
	        sFeatures ="help:0;scroll:0;status:0;";
	    }
	    console.log("Parameters : ", sParam);
	    var features = ";dialogTop="+yPos + "px" +
	            ";dialogLeft="+xPos +"px" +
	            ";dialogWidth="+sWithd +"px" +
	            ";dialogHeight="+sHeight+"px" ;
	
	    returnVal = window.showModalDialog(sUrl, sParam, sFeatures+features);
	
	    return returnVal;
	}
	
	
	function openPopup( popupType ) {
		var param = {
			popupType:'CUSTOMER'
		}
		var rv = openModalC("popup_win.jsp?popupType=CUSTOMER", param, 500,300);
		console.log("retuen value: ", rv);
	}
	
	
	Ext.onReady(function() {
		/*
		var custFieldSet = {
			xtype: 'uniCustPopupField',
            listeners: {
                'onSelected': {
                    fn: function(records, type  ){
                        console.log('SELECTED2:', type , records);
                    },
                    scope: this
                }
            }
		};
		var custColumnSet = {
			xtype: 'uniCustPopupColumn',
            listeners: {
                'onSelected': {
                    fn: function(records, type ){
                        console.log('SELECTED:', type , records);
                    },
                    scope: this
                }
            }
		};
		*/
		var panelSearch = {
			xtype : 'uniSearchForm',
			id : 'searchForm',
	        layout : {type : 'table', columns : 4,
	        			tableAttrs: {
                      		style: {
                          		width: '100%'
                      		}
                  		}},
			items : [ Unilite.popup('CUST',{listeners: {
						                'onSelected': {
						                    fn: function(records, type  ){
						                        console.log('SELECTED :', records[0]['CUSTOM_FULL_NAME']);
						                        var rec= records[0];
												var form = Ext.getCmp('searchForm');
						                        form.setValues(rec);
						                        form.setValue('COMPANY_NUM',  rec['COMPANY_NUM']);
						                    },
						                    scope: this
						                }
						            }
								}), 
					Unilite.popup('CUST_G'),
					Unilite.popup('CUSTOMER'), 
                    Unilite.popup('CUSTOMER_G'),
                    
                    Unilite.popup('DIV_PUMOK',{extParam:{ DIV_CODE:'01'}}), 
                    Unilite.popup('DIV_PUMOK_G',{extParam:{SELMODEL:'MULTI', DIV_CODE:'01'}}),
                    
					{fieldLabel: 'COMP_CLASS', name: 'COMP_CLASS'},
					{fieldLabel: 'COMPANY_NUM', name: 'COMPANY_NUM'},
					{fieldLabel: 'BANK_NAME', name: 'BANK_NAME'},
					{fieldLabel: 'TOP_NAME', name: 'TOP_NAME'},
					
					Unilite.popup('ITEM_GROUP'),			//품목코드(대표모델)
					Unilite.popup('DIV_ITEM_GROUP'),		//사업장별 품목코드(대표모델)
					Unilite.popup('Employee'),
					Unilite.popup('Employee_G'),
					Unilite.popup('DEPT'),
					Unilite.popup('DEPT_G'),
					Unilite.popup('BANK'),
					Unilite.popup('BANK_G'),
					Unilite.popup('DIV_ITEM_GROUP'),		//사업장별 품목코드(대표모델)	
					Unilite.popup('DIV_ITEM_GROUP_G'),		
					Unilite.popup('ITEM_GROUP'),			//품목코드(대표모델)
					Unilite.popup('ITEM_GROUP_G'),
					Unilite.popup('ITEM'),					//품목코드
					Unilite.popup('ITEM_G'),
					Unilite.popup('ITEM2'),					//품목코드
					Unilite.popup('ITEM2_G'),
					Unilite.popup('SAFFER_TAX'),
					Unilite.popup('SAFFER_TAX_G'),
					Unilite.popup('ZIP'),
					Unilite.popup('ZIP_G'),
					Unilite.popup('CUST'),
					Unilite.popup('CUST_G'),
					Unilite.popup('CUSTOMER'),
					Unilite.popup('CUSTOMER_G'),
					Unilite.popup('CLIENT_PROJECT'),
					Unilite.popup('CLIENT_PROJECT_G'),
					Unilite.popup('CLIENT_PROJECT2'),
					{xtype:'hiddenfield', hidden:false},
					Unilite.popup('USER'),
					Unilite.popup('USER_G'),
					Unilite.popup('PROJECT'),
					Unilite.popup('VEHICLE')
				]
		};
		
		var panel = {
			xtype:'panel',
			contentEl:'test'
		}
		var app = Ext.create('Unilite.com.BaseApp', {
			items : [ panelSearch , panel]
			,onQueryButtonDown:function() {
				var form = Ext.getCmp('searchForm');
	            console.log(form.getValues());
			}
		});

	});
	
</script>
<div id="test">
가비아 / J0079 <br/>
<a href="#" onclick="openPopup()"> [ CUST POPUP ] </a>
</div>