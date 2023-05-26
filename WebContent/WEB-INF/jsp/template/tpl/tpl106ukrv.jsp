<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tpl106ukrv"  >	
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
//	↑ 파일uplod용 plupload.full.js파일 include
</script>

<script type="text/javascript" >
function appMain() { 
	var panelSearch = Unilite.createSimpleForm('tpl106ukrvDetail', {		
    	  disabled :false
    	, id: 'searchForm'
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'center'}}
        , defaults: {labelWidth: 100}
	    , items :[{
			xtype: 'uniFieldset',
			title: '파일 업로드',
			collapsible: false,
			layout: {
			    type: 'uniTable',
			    columns: 1				//1열 종대형 테이블 layout
			},
			items :[{				
				fieldLabel: '제목',
				name:'',
				colspan : 3,
				width : 754,
				maxLength:200,
				readOnly: true
			}, {
				fieldLabel: '내용',
				name:'',
				xtype: 'textareafield',
				grow : true,
				colspan : 3,
				width : 754,
				height : 170,
				readOnly: true
			}, {
     			xtype: 'xuploadpanel',
		    	height: 150,
		    	flex: 0,
		    	padding: '0 0 8 0',
		    	listeners : {
		    		change: function() {
		    			UniAppManager.app.setToolbarButtons('save', true);	//파일 추가or삭제시 저장버튼 on
		    		}
		    	}
	    	} ,{
	    		fieldLabel: 'FILE_NO',			
	    		name:'FILE_NO',
	    		value: '000000',				//임시 파일 번호
	    		readOnly:true,
	    		hidden:true
	    	} ,{
	    		fieldLabel: '삭제파일FID'	,		//삭제 파일번호를 set하기 위한 hidden 필드
	    		name:'DEL_FID',
	    		readOnly:true,
	    		hidden:true
	    	},{
	    		fieldLabel: '등록파일FID'	,		//등록 파일번호를 set하기 위한 hidden 필드
	    		name:'ADD_FID',
	    		readOnly:true,
	    		hidden:true
            }]
	    }],
        api: {
			 load: 'templateService.getFileList',	//조회 api
			 submit: 'templateService.syncAll'		//저장 api
		}
	});

    Unilite.Main({
		items 	: [ panelSearch],
		id: 'tpl106ukrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset',false);	
		},
		onSaveDataButtonDown: function (config) {
			var fp = panelSearch.down('xuploadpanel');	
			var addFiles = fp.getAddFiles();				
			var removeFiles = fp.getRemoveFiles();
			panelSearch.setValue('ADD_FID', addFiles);					//추가 파일 담기
			panelSearch.setValue('DEL_FID', removeFiles);				//삭제 파일 담기
			var param= panelSearch.getValues();
			panelSearch.getEl().mask('로딩중...','loading-indicator');	//mask on
			panelSearch.getForm().submit({								//폼 submit 함수 호출
				 params : param,
				 success : function(form, action) {
				 	UniAppManager.updateStatus(Msg.sMB011);				//저장되었습니다.(message) 
					UniAppManager.setToolbarButtons('save',false);		//저장버튼 비활성화
					panelSearch.getEl().unmask();						//mask off
			 	 }	
			});
		},
		onQueryButtonDown: function(){
			var fp = panelSearch.down('xuploadpanel');					//mask on
			fp.getEl().mask('로딩중...','loading-indicator');
			var fileNO = panelSearch.getValue('FILE_NO');
			templateService.getFileList({DOC_NO : fileNO},				//파일조회 메서드  호출(param - 파일번호) 
				function(provider, response) {							
					fp.loadData(response.result);						//업로드 파일 load해서 보여주기
					fp.getEl().unmask();								//mask off
					UniAppManager.setToolbarButtons('save',false);		//저장버튼 비활성화
				}
			 )
		}
	});
};
</script>
