<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="B015" />  <!--  거래처구분    -->  
<t:ExtComboStore comboType="AU" comboCode="B010" />  <!--  거래처구분    -->  

</t:appConfig>
<script type="text/javascript" >
var tV = {'startYear':2011, 'endYear':2012};
var lHidden = true;
var toolbar = {
	        xtype: 'toolbar',
	        dock: 'top',
	        items: [{
	            text: 'Form2 Show & Hide'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm2');
					if(lHidden) {
						frm.show();
						frm.getEl().moveTo(this.x+60,this.y+50);
					} else {
						frm.hide();
					}
	            	lHidden = !lHidden;
	            }
	        }
	        
	        ]
        };
	            
	            
Ext.onReady(function() {
	Unilite.defineModel('bcm100ukrvModel', {
	    fields: [ 	 {name: 'startYear' 		,text:'시작년도' 		,type:'uniYear'	,defaultValue:'2012'	,allowBlank:false}
					,{name: 'endYear' 			,text:'종료년도' 		,type:'uniYear'	,defaultValue:'2015' , comboType:'AU',comboCode:'B015' ,allowBlank: false}
					,{name: 'timein' 			,text:'Time In' 		,type:'uniTime'	,allowBlank:false, defaultValue:'0100'}
					,{name: 'un' 				,text:'uniNumber' 		,type:'uniNumber'	,defaultValue:123}
					,{name: 'uniPercent' 				,text:'uniPercent' 		,type:'uniPercent'	,defaultValue:123}
					,{name: 'un2' 				,text:'number' 			,type:'number'	}
					,{name: 'ut' 				,text:'uniTextfield' 	,type:'string'	,defaultValue:'기본'}
					,{name: 'txtName' 			,text:'텍스트' 	,type:'string'	,allowBlank:false}
					,{name: 'txtName2' 			,text:'텍스트2' 	,type:'string'	,allowBlank:false}
					,{name: 'endDate' 			,text:'endDate' 	,type:'uniDate'	,allowBlank:false}
					,{name: 'com1' 		,text:'구분' 		,type:'string'	,comboType:'AU',comboCode:'B015', defaultValue:'1'}
					,{name: 'rdo1' 		,text:'rdo1' 		,type:'string'	,comboType:'AU',comboCode:'B015', defaultValue:"2"}
					,{name: 'rdo2' 		,text:'rdo2' 		,type:'string'	,comboType:'AU',comboCode:'B015', defaultValue:'3'}
					,{name: 'chk1' 		,text:'chk1' 		,type:'string'	,comboType:'AU',comboCode:'B015'}
					],
        validations: [
            {type: 'presence', field: 'CUSTOM_CODE'}
        ]
	});//define model
	
	var testForm = Ext.create('Unilite.com.form.UniDetailForm', {
		id:'testForm',
		title: 'Title',
		disabled :false,
		animCollapse : true,
		width:600,
        renderTo: Ext.getBody(),
        layout: { type: 'uniTable',
				columns : 2
		},
		tools:[
			{
				xtype:'button',
	            text: 'Form1 collapse & expand'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm');
					if(lHidden) {
						frm.collapse();
					} else {
						frm.expand();
					}
	            	lHidden = !lHidden;
	            }
	        }
		],
        dockedItems :[toolbar],
        items: [{
	              xtype: 'uniYearField',
	              name: 'startYear',
	              id: 'startYear',
	              fieldLabel: '시작년도',
	              // value: new Date().getFullYear()-1,
	              vtype: 'yearRange',
		    	  endYearField: 'endYear',
	              validateOnChange: false,
	              validateOnBlur : false
	         },
	         {
	              xtype: 'uniYearField',
	              name: 'endYear',
	              id: 'endYear',
	              fieldLabel: '종료년도',
	              value: new Date().getFullYear(),
	              vtype: 'yearRange',
		    	  startYearField: 'startYear'
	         },
	         {
	              xtype: 'uniTimefield',
	              name: 'timein',
	              fieldLabel: 'timein',
	              minValue: '6:00 AM',
	              maxValue: '8:00 PM',
	              increment: 30,
	              allowBlank:false
	          },
	          {
	              xtype: 'uniNumberfield',
	              name: 'un',
	              fieldLabel: 'uniNumber',
	              value:12345.67,
	              allowBlank:false,
	              validateOnChange: false,
	              validateOnBlur : false,
	              suffixTpl:'원'
	          },
	          {
	              xtype: 'numberfield',
	              name: 'un2',
	              fieldLabel: 'number',
	              value:12345.67,
	              allowBlank:false,
	              validateOnChange: false,
	              validateOnBlur : false
	          },
	          {
	              xtype: 'uniNumberfield',
	              name: 'uniPercent',
	              decimalPrecision: 2,
	              fieldLabel: 'uniPercent',
	              value: 35.34,
	              allowBlank:false,
	              validateOnChange: false,
	              validateOnBlur : false,
	              suffixTpl:'%'
	          },
	          {
	              xtype: 'uniTextfield',
	              name: 'ut',
	              fieldLabel: 'uniTextfield',
	              value:'12345.67',
	              renderer : Ext.util.Format.numberRenderer('0,000.00'),
	              listeners: {
	              	change : function () {
	              		console.log("change");
	              	}
	              }
	          },
	          {
	              xtype: 'uniTextfield',
	              name: 'txtName',
	              fieldLabel:'텍스트',
	              allowBlank:false,
	              suffixTpl:'원'
	          }	]
	      });
	 var testForm2 = Ext.create('Unilite.com.form.UniDetailForm', {
		id:'testForm2',
		disabled :false,
		border:true,
		floating :true,
		hidden:true,
		width:600,
		layout: { type: 'uniTable',
				columns : 2
		},
		fieldDefaults : {
			labelAlign : 'right',
			labelWidth : 90,
			labelSeparator : "",
		    validateOnChange: false,
	        autoFitErrors: true   //false  //화면 깨짐 
		}	,	
        renderTo: Ext.getBody(),
      
        items: [{
	              xtype: 'uniYearField',
	              name: 'startYear',
	              id: 'startYear2',
	              fieldLabel: '시작년도',
	              // value: new Date().getFullYear()-1,
	              vtype: 'yearRange',
		    	  endYearField: 'endYear2',
	              validateOnChange: false,
	              validateOnBlur : false
	         },
	         {
	              xtype: 'uniYearField',
	              name: 'endYear',
	              id: 'endYear2',
	              fieldLabel: '종료년도',
	              value: new Date().getFullYear(),
	              vtype: 'yearRange',
		    	  startYearField: 'startYear2'
	         },
	         {
	              xtype: 'uniTimefield',
	              name: 'timein',
	              fieldLabel: 'timein',
	              minValue: '6:00 AM',
	              maxValue: '8:00 PM',
	              increment: 30,
	              allowBlank:false
	          },
	          {
	              xtype: 'uniNumberfield',
	              name: 'un',
	              fieldLabel: 'uniNumber',
	              value:12345.67,
	              allowBlank:false,
	              validateOnChange: false,
	              validateOnBlur : false,
	              suffixTpl:'원'
	          },
	          {
	              xtype: 'numberfield',
	              name: 'un2',
	              fieldLabel: 'number',
	              value:12345.67,
	              allowBlank:false,
	              validateOnChange: false,
	              validateOnBlur : false
	          },
	          {
	              xtype: 'uniNumberfield',
	              name: 'uniPercent',
	              decimalPrecision: 2,
	              fieldLabel: 'uniPercent',
	              value: 35.34,
	              allowBlank:false,
	              validateOnChange: false,
	              validateOnBlur : false,
	              suffixTpl:'%'
	          },
	          {
	              xtype: 'uniTextfield',
	              name: 'ut',
	              fieldLabel: 'uniTextfield',
	              value:'12345.67',
	              renderer : Ext.util.Format.numberRenderer('0,000.00'),
	              listeners: {
	              	change : function () {
	              		console.log("change");
	              	}
	              }
	          },
	          {
	              xtype: 'uniTextfield',
	              name: 'txtName',
	              fieldLabel:'텍스트',
	              allowBlank:false,
	              suffixTpl:'원'
	          }		       			 
	         ]
	      });     
	      
	 
}) // onReady

</script>
