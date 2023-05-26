<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<script>
Ext.onReady(function() {
	
	Ext.create('Ext.form.Panel', {
	    alias: 'uniSearchForm',
		bodyPadding : '5 5 0 5',
		border : 0,
		width : '100%',
	   
	    layout: {
	            type: 'table',
	            columns: 4
	        },
	    renderTo: Ext.getBody(),
	    bodyPadding: 5,
	    defaultType: 'textfield',
	     
	    fieldDefaults: {
	            msgTarget: 'under',
	            labelAlign: 'right',
	            labelSeparator : "",
	            labelWidth : 100,
	        },
	    
	    
	    items: [ /*Text Field, hidden field */
	             {fieldLabel: '고객명',    name: 'txtResultClientCd'}, {fieldLabel: '고객CD',     name: 'txtResultClientNm',  xtype: 'hiddenfield'}, {fieldLabel: '고객etc',     name: 'txtEtcClientNm', xtype: 'hidden'}
	    		 /*Date Field*/
	             ,{fieldLabel: '실행일자',  name: 'txtResultDate' ,xtype: 'datefield',format: 'Y m d ',altFormats: 'Y,m,d|Y.m.d',value : new Date(), allowBlank : false}
	    		 /*Label 없는 경우 */
	    		 ,{hideLabel :true,  name : 'btnResultDate', xtype: 'textfield' } //btnResultDate
	    		 /*Combo*/
	    		,{fieldLabel: '영업유형',  name: 'txtSaleType', allowBlank : false}		 //btnSaleType
	    		
	    		
	    		/*Textarea Field*/	    		
	            ,{fieldLabel: '내용', name: 'txtContentStr', xtype: 'textareafield', grow : true, colspan : 4, width : 917, height : 100} 
	    		
	    		
	            /*Code popup */
	            ,{fieldLabel: '거래처',  name: 'txtCustomCode'},{isFieldLabelable :false,  name : 'txtCustomName', xtype: 'textfield' }
	            /* Number Field*/
	            ,{fieldLabel: '시간',  name: 'hours', xtype: 'numberfield'}, {xtype: 'displayfield',value: '&nbsp;hours', hideLabel: true}
	            
	            
	            ,{fieldLabel: '단위',  name: 'Unit', colspan : 4, xtype: 'combobox', store:          Ext.create('Ext.data.ArrayStore', {
                                    fields : ['name', 'value'],
                                    data   : [
                                        {name : '개',   value: 'EA'},
                                        {name : '박스',  value: 'BOX'},
                                        {name : '팩', value: 'Pack'}
                                    ]
                                })
                   , valueField: 'value',
                    displayField: 'state',
                    typeAhead: true,
                    queryMode: 'local',
                    emptyText: '단위 선택'
	            }
	            ,{ xtype: 'textfield', 		name: 'password1',		fieldLabel: 'Password ', 	inputType: 'password' }
	           	,{ xtype: 'filefield',		name: 'file1',			fieldLabel: 'File upload' }
	            ,{ xtype: 'numberfield', 	name: 'numberfield1', 	fieldLabel: 'Number field', value: 5, minValue: 0, maxValue: 50}
				,{ xtype: 'checkboxfield',  name: 'checkbox1', 		fieldLabel: 'Checkbox', 	boxLabel: 'box label'}
				,{ xtype: 'radiofield', 	name: 'radio1', 		fieldLabel: 'Radio buttons',value: 'radiovalue1', boxLabel: 'radio 1'}
				,{ xtype: 'radiofield', 	name: 'radio1', 		fieldLabel: '', 			value: 'radiovalue2',  labelSeparator: '', hideEmptyLabel: false, boxLabel: 'radio 2'}
				,{ xtype: 'datefield', 		name: 'date1', 			fieldLabel: 'Date Field'}
				,{ xtype: 'timefield', 		name: 'time1', 			fieldLabel: 'Time Field', 	minValue: '1:30 AM', maxValue: '9:15 PM'}
				
	            ,
	            /* Field Container*/
	            ,{fieldLabel: 'Time', xtype: 'fieldcontainer', colspan : 4, 
	            	 layout: {
                        type: 'hbox',
                        defaultMargins: {top: 0, right: 5, bottom: 0, left: 0}
                    },
	            	defaults: {hideLabel: true , width: '100%',
                    labelWidth: 89,
                    anchor: '100%'},      
                  	items: [	{name : 'hours',  xtype: 'numberfield',allowBlank: false}, {xtype: 'displayfield',value: 'hours'},
                      			{name : 'minutes',xtype: 'numberfield',allowBlank: false}, {xtype: 'displayfield',value: 'mins'}
                    	   	  ]
                  }
	            
	           ]
	});

});
</script>