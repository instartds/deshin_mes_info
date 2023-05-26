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
	            text: 'Show&Hide(uniDisplay)'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm');
	            	var field = frm.getField('startYear');
	            	field.uniSetDisplayed(lHidden);
	            	lHidden = !lHidden;
	            }
	        },{
	            text: 'Fire Event'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm');
					var rv = false;
					rv = frm.fireEvent('dirtychange','01');
					console.log("fireEvent : ", rv);
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
		title: 'Time Card',
		layout: { type: 'uniTable',
				columns : 3,
				tableAttrs: {style: {width:1000}},
				tdAttrs : { style: {'border':'1px solid #f00' }}
		},
		fieldDefaults : {
			labelAlign : 'right',
			labelWidth : 90,
			labelSeparator : "",
		    validateOnChange: false,
	        autoFitErrors: true   //false  //화면 깨짐 
		}	,	
        renderTo: Ext.getBody(),
        
        listeners: {
        	create : function() {
        		
        	},
        	afterrender : function() {
        		this.setDisabled( false );
        	},
        	dirtychange: function( form, dirty, eOpts) {
        		var res = ssa450skrvService.selectList1({DIV_CODE:'01'});
        		console.log(">>> form dirtychange dirty = " , dirty, "<<<<<", res);
        		return false;
        	}
        },
        dockedItems :[toolbar],
        items: [{
	              xtype: 'uniYearField',
	              name: 'startYear',
	              id: 'startYear',
	              fieldLabel: '시작년도',
	              // value: new Date().getFullYear()-1,
	              vtype: 'yearRange',
	              anchor: '100%',
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
	              anchor: '100%',
		    	  startYearField: 'startYear'
	         }					            
						       			 
	         ]
	      });
	
	

}) // onReady



	
</script>
