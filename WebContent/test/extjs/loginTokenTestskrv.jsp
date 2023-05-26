<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bbs888skrv"  >
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	
	var panelResult = Unilite.createForm('actionForm',{
		weight:-100,
    	region: 'center',
		layout : {type : 'uniTable', columns : 2, tableAttrs:{cellpadding:5}},
		padding:'1 1 1 1',
		border:true,
		disabled:false,
		items: [{ 
				xtype:'uniTextfield',
				fieldLabel : 'LOGIN_TOKEN',
				name:'LOGIN_TOKEN'
			},{ 
				xtype:'uniTextfield',
				fieldLabel:'USER_ID',
				name:'USER_ID'
			},{ 
				xtype:'button',
				text : 'Create Token',
				tdAttrs:{align:'center'},
				handler:function()	{
					 Ext.Ajax.request({
					     url: '/login/loginToken.do',
					     success: function(response, opts) {
					         var obj = Ext.decode(response.responseText);
					         panelResult.setValue('LOGIN_TOKEN', obj.loginToken);
					         console.dir(obj);
					         
					     },
					     failure: function(response, opts) {
					         console.log('server-side failure with status code ' + response.status);
					     }
					 });
				}
			},{ 
				xtype:'button',
				text : 'Parse Token',
				tdAttrs:{align:'center'},
				handler:function()	{
					  var token = panelResult.getValue("LOGIN_TOKEN");
			          Ext.Ajax.request({
					     url: '/login/decryptToken.do',
					     params :{'loginToken':token},
					     success: function(response, opts) {
					         var obj = Ext.decode(response.responseText);
					         panelResult.setValue('USER_ID', obj.userId);
					         console.dir(obj);
					     },
					     failure: function(response, opts) {
					         console.log('server-side failure with status code ' + response.status);
					     }
					 });
					     
				}
			}]
	});   
    
    
    Unilite.Main( {
		borderItems:[
		panelResult
		],
		id  : 'bsa9999ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);

		},
		onQueryButtonDown : function()	{
			
				
		},
		onNewDataButtonDown: function()	{
		
				
		},
		onResetButtonDown: function() {
			
		},
		onSaveDataButtonDown: function(config) {
				
		},
		onDeleteDataButtonDown: function() {
			
		},
		rejectSave: function() {	// 저장
			
		},
		confirmSaveData: function(config)	{
			
		},
		onDetailButtonDown:function() {
		}
	});
	

}
</script>
<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" name="orgnCd" id="orgnCd" value ="00000001">
<input type=hidden name="orgnNm" id="orgnNm" value ="재외한국문화원">
<input type="hidden" name="year" id="year" value ="2017">
<input type="hidden" name="month" id="month" value ="01">
</form>