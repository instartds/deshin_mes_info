<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bbs888skrv"  >
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	
	var panelResult = Unilite.createForm('actionForm',{
		weight:-100,
    	region: 'center',
		layout : {type : 'uniTable', columns : 1, tableAttrs:{cellpadding:5}},
		padding:'1 1 1 1',
		border:true,
		disabled:false,
		api:{submit:'emailBeforeSendService.sendEmail'},
		method :'POST',
		items: [{ 
				xtype:'uniTextfield',
				fieldLabel:'받을메일주소',
				name:'TO'
			},{ 
				xtype:'uniTextfield',
				fieldLabel:'보내는 사람',
				name:'FROM'
			},{ 
				xtype:'uniTextfield',
				fieldLabel : '제목',
				name:'SUBJECT'
			},{ 
				xtype:'textareafield',
				fieldLabel : '내용',
				name:'TEXT',
				width:500,
				height:500
			},{ 
				tdAttrs:{align:'center'},
				xtype:'button',
				text : '보내기',
				handler:function()	{
					panelResult.submit({success : function(form, action) {
				 		Ext.getBody().unmask();
	 					if(action.result.success === true)	{					
	            			UniAppManager.updateStatus("전송되었습니다.");
	 					}else {
	 						UniAppManager.updateStatus("전송실패"+"\n"+action.result.messge);
	 					}
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