<%@page language="java" contentType="text/html; charset=utf-8"%>
var photoForm = Unilite.createForm('gac100ukrvPhotoForm', {
	    	 			 fileUpload: true,
						 url:  CPATH+'/fileman/upload.do',
				    	 defaultType: 'uniFieldset',
				    	 disabled:false,
				    	 overflow:false,
				    	 autoScroll:false,
				    	 flex:1,
	    	 			 layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
						 items: [ { xtype: 'filefield',
									buttonOnly: false,
									fieldLabel: '사진',
									flex:1,
									name: 'fileUpload',
									buttonText: '파일선택',
									width: 270,
									labelWidth: 70,
									listeners: {change : function( filefield, value, eOpts )	{
															if(value !='' )	{
																UniAppManager.app.setToolbarButtons('save',true);
															}
														}
									}
								  },
								  {xtype:'container',
								  flex:1,
								  border:true,
								  items:[
								 	{ xtype: 'image', id:'gac100ukrvBCImage',  hidden:true}
					             ]}
					 	]
					   , setImage : function (fid)	{
						    	 	var image = Ext.getCmp('gac100ukrvBCImage');
						    	 	var src = '';
						    	 	console.log("image fid;",fid)
						    	 	if(Ext.isDefined(fid))	{
							         	//src = CPATH+'/fileman/download.do?fid='+fid+'&inline=Y';
							         	src= CPATH+'/fileman/view/'+fid;
							         	image.setSrc(src);
								        image.show();
						    	 	}else {
						    	 		image.hide();
						    	 	}
							        
						    	 }
					  
	});
	var photos =	 {		         
	        title: '사진',	
	        itemId: 'accidentPhoto',
	        id:'gac100ukrvPhoto',
			layout:{type:'vbox', align:'stretch'},
			autoScroll:true,	
			xtype:'uniDetailForm',			
			api:{
				'load' : 'gac100ukrvService.select'
			},
			flex:1,
			padding:0,
	        items:[ 
	        	photoForm,
	    		{fieldLabel:'사업장', name:'DIV_CODE', hidden:true},
				{fieldLabel:'사고번호', name:'ACCIDENT_NUM', hidden:true},  
				{fieldLabel:'파일번호', name:'DOC_NO', hidden:true}  
			],
		listeners:{
			uniOnChange:function( form, dirty, eOpts ) {
				console.log("onDirtyChange");
				UniAppManager.setToolbarButtons('save', true);
			}
		},
		loadData:function(param)	{
			var me = Ext.getCmp('gac100ukrvPhoto');;
			me.getForm().wasDirty = false;
			me.resetDirtyStatus();
			
			me.uniOpt.inLoading = true;
			me.getEl().mask();
			me.getForm().load({
					params: param,
					success:function(form, action)	{
						me.uniOpt.inLoading = false;
						me.getEl().unmask();
						var fileForm = Ext.getCmp('gac100ukrvPhotoForm');
						fileForm.setImage(action.result.data['DOC_NO']);
					}
			})
		},
		saveData:function()	{
			var me = Ext.getCmp('gac100ukrvPhoto');
			var fileForm = Ext.getCmp('gac100ukrvPhotoForm');
			if(me.isDirty())		{
				me.setValue('DIV_CODE',panelSearch.getValue("DIV_CODE"));
				me.getEl().mask();
				fileForm.getForm().submit({
					waitMsg: 'Uploading...',
					success:function(form, action)	{
						me.getEl().unmask();
						me.setValue('DOC_NO', action.result.fid);
						fileForm.setImage(action.result.fid);
						var param = me.getForm().getValues();
						gac100ukrvService.saveImageNo(param, function(provider, response) {
							if(response.result.success)	{
								UniAppManager.updateStatus(Msg.sMB011);
								UniAppManager.setToolbarButtons('save', false);
								fileForm.clearForm();
								me.getForm().wasDirty = false;
								me.resetDirtyStatus();
								fileForm.getForm().wasDirty = false;
								fileForm.resetDirtyStatus();
								
							} 
						} )
					}
				})
				
			}
		},
		newData:function()	{
			var me = this;
			if(me.isDirty())	{
				if(confirm('저장할 내용이 있습니다. 저장하시겠습니까?')){
					if(AppManager.app.findInvalidField(me))	{
						AppManager.app.onSaveDataButtonDown();
					}
					return;
				}
			}
			me.clearForm();
			me.setDisabled( false );
		},
		deleteData:function()	{
			
		},
		rejectChanges:function()	{
			var me = Ext.getCmp('gac100ukrvPhoto');
			me.clearForm();
		}	        	
	};