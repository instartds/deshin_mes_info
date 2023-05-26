<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bsa315ukrv_wm">
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-component.x-html-editor-input.x-box-item.x-component-default {
		border-top: 1px solid #b5b8c8;
	}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js"/>'>
</script>
<script type="text/javascript" >

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 3},
		padding		: '1 1 1 1',
		border		: true,
		items		: [{
			fieldLabel	: '<t:message code="system.label.base.user" default="사용자"/>',
			name		: 'USER_ID',
			width		: 200,
			readOnly	: true
		},{
			fieldLabel	: '',
			name		: 'USER_NAME',
			readOnly	: true
		},{
			fieldLabel	: 'COMP_CODE',
			name		: 'COMP_CODE',
			hidden		: true
		}]
	});

	var detailForm = Unilite.createSearchForm('resultForm2',{
		region		: 'center',
		layout		: {type : 'uniTable', columns : 1},
		padding		: '1 1 1 1',
		api			: {
			load	: 's_bsa315ukrv_wmService.selectMaster',
			submit	: 's_bsa315ukrv_wmService.saveMaster'
		},
		items		: [{
			xtype		: 'htmleditor',
			fieldLabel	: '<t:message code="system.label.sales.content" default="내용"/>',
			name		: 'USER_SIGN',
			width		: 820,
			height		: 500,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					UniAppManager.setToolbarButtons(['save'], true);
				}
			}
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
				if(basicForm.getField('USER_SIGN').isDirty()) {
					UniAppManager.setToolbarButtons(['save'], true);
				}
			}
		}
	});

	var fileUploadForm = Unilite.createSimpleForm('fileUploadForm',{
		region	: 'south',
		disabled: false,
		border	: false,
/*		api		: {
			 load	: 's_bsa315ukrv_wmService.getFileList',		//조회 api
			 submit	: 's_bsa315ukrv_wmService.saveFile'			//저장 api
		},*/
		items	: [{
			fieldLabel	: '첨부파일',
			xtype		: 'xuploadpanel',
			itemId		: 'fileUploadPanel',
			width		: 820,
			height		: 120,
			padding		: '0 0 0 95',
			colspan		: 1,
			bbar		: ['->',{
				text	: 'upload',
				id		: 'uploadButton',
				itemId	: 'uploadButton',
				handler	: function() {
					var Ihight		= 100;
					var Iwidth		= 100;
					var fp			= fileUploadForm.down('xuploadpanel');
					var addFiles	= fp.getAddFiles();
					var removeFiles	= fp.getRemoveFiles();
					//20201110 수정:  + CPATH 추가
					var html		= '<img src="' + CHOST + CPATH + '/fileman/download/' + addFiles + '.bin'/* + '" Height= "' + Ihight + '" Width= "' + Iwidth*/ + '"/>';
					detailForm.setValue('USER_SIGN', html + '<br>' + detailForm.getValue('USER_SIGN'));
					if(detailForm.getField('USER_SIGN').isDirty()) {
						UniAppManager.setToolbarButtons(['save'], true);
					}
			fp.loadData({});
			fileUploadForm.down('#uploadButton').disable();
				}
			}],
			listeners	: {
				change: function(xup) {
					var fp			= fileUploadForm.down('xuploadpanel');
					var addFiles	= fp.getAddFiles();
					var removeFiles	= fp.getRemoveFiles();

					if(addFiles.length > 1) {
						Unilite.messageBox('하나의 파일만 등록 가능합니다.');
						fileUploadForm.down('#uploadButton').disable();
						return false;
					} else if(addFiles.length == 0) {
						fileUploadForm.down('#uploadButton').disable();
					} else {
						fileUploadForm.down('#uploadButton').enable();
					}
				},
				uploadcomplete : function(xup){
				}
			}
		}]
	});



	Unilite.Main({
		id			: 's_bsa315ukrv_wmApp',
		borderItems : [{
			region	: 'center',
			border	: true,
				autoScroll:true,
			items	: [
				panelResult,{
				region	: 'south',
				xtype	: 'container',
				layout	: {type:'vbox', align:'stretch'},
				items	: [
					detailForm, fileUploadForm
				]
			}]
		}],
		fnInitBinding : function(params) {
			this.setDefault();
		},
		setDefault: function() {
			panelResult.setValue('COMP_CODE'	, UserInfo.compCode);
			panelResult.setValue('USER_ID'		, UserInfo.userID);
			panelResult.setValue('USER_NAME'	, UserInfo.userName);
			UniAppManager.setToolbarButtons('reset', false);
			fileUploadForm.down('#uploadButton').disable();
			UniAppManager.app.onQueryButtonDown();
		},
		onQueryButtonDown: function () {
			var fp = fileUploadForm.down('#fileUploadPanel');
			fp.loadData({});
			var param = panelResult.getValues();
			detailForm.getForm().load({
				params	: param,
				success	: function(form, action) {
					UniAppManager.setToolbarButtons('save', false);
				}
			});
		},
		onSaveDataButtonDown: function (config) {
			var param = panelResult.getValues();
			detailForm.getForm().submit({
				params	: param,
				success	: function(form, action) {
					detailForm.getForm().wasDirty = false;
					detailForm.resetDirtyStatus();

					UniAppManager.setToolbarButtons('save', false);	
					UniAppManager.updateStatus(Msg.sMB011);
				}
			});
		}
	});
};
</script>