<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="B015" />

</t:appConfig>
<script type="text/javascript" >

Ext.onReady(function() {
	
	
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
        items: [{
	              xtype: 'uniCombobox',
	              name: 'DEPT_NAME',
	              fieldLabel: '부서코드',
	              comboType:'AU',
	              comboCode:'B015',
	              listeners:{
	              	change:function(field, eOpts)	{
	              		if(Ext.isEmpty(field.getValue())){
	              			field.fireEvent('onClear',  type);	
	              		}else {
	              			field.openPopup();
	              		}
	              	},
	              	onSelected:function(record, type)	{
	              		console.log("popup record:",record);
	              	}
	              	
	              },
				  app: 'Unilite.app.popup.DeptPopup',
	              openPopup: function() {
   			      		var me = this;

				        var param = {};
				        
					    
			           param['DEPT_NAME'] = '연구소'   ;
			        
			        
				        param['TYPE'] = 'TEXT';   
				        param['pageTitle'] = me.pageTitle;
				        
				     if(me.app) { 
				     	 var fn = function() {
			                var oWin =  Ext.WindowMgr.get(me.app);
			                if(!oWin) {
			                    oWin = Ext.create( me.app, {
			                            id: me.app, 
			                            callBackFn: me.processResult, 
			                            callBackScope: me, 
			                            popupType: 'TEXT',
			                            width: 300,
			                            height:300,
			                            title: '부서코드',
			                            param: param
			                     });
			                }
			                oWin.fnInitBinding(param);
			                oWin.center();
			               
			                oWin.show();
					     	
					     }
				     }
				     Unilite.require(me.app, fn, this, true);
			        
			    },
			    processResult: function(result, type) {
			        var me = this, rv;
			        console.log("Result: ", result);
			        if(Ext.isDefined(result) && result.status == 'OK') {
			            me.fireEvent('onSelected',  result.data, type); 
			        }
			        
			    }
	              
	         }]
	      });
	 
	      
	 
}) // onReady

</script>
