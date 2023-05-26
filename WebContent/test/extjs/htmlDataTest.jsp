<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tpl106ukrv"  >	
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
//	↑ 파일uplod용 plupload.full.js파일 include
</script>

<script type="text/javascript" >
function appMain() { 
	Unilite.defineModel('tModel', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'		,type : 'string', comboType:'BOR120'} 
					,{name: 'MAIN_CODE'    			,text:'종합코드'	,type : 'string'} 
					,{name: 'SUB_CODE'    			,text:'상세코드'	,type : 'string'} 
					,{name: 'CODE_NAME'    			,text:'상세코드명'	,type : 'string'} 
					,{name: 'REF_CODE1'    			,text:'관련코드1'	,type : 'string'} 
					,{name: 'REF_CODE2'    			,text:'관련코드2'	,type : 'string'} 
					,{name: 'REF_CODE3'    			,text:'관련코드3'	,type : 'string'} 
					,{name: 'REF_CODE4'    			,text:'관련코드4'	,type : 'string'}
		]})
	Unilite.defineModel('tModel2', {
	    fields: [
					 {name: 'html_document'   			,text:'html'		,type : 'string'} 
					
	]})
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read : bsa100ukrvService.selectMasterCodeList
		}
	});
    var masterStore =  Unilite.createStore('tStore',{
        model: 'tModel',
         autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy,
			loadStoreRecords: function()	{
				var param= {};
				this.load({params: param});
			}
		});
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read : templateService.getHtml
		}
	});
    var htmlStore =  Unilite.createStore('tStore',{
        model: 'tModel2',
         autoLoad: true	,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy2,
			loadStoreRecords: function()	{
				var param= {};
				this.load({params: param});
			}
		});
	var masterGrid = Unilite.createGrid('tGrid', {
        region:'center',
        flex:.5,
        margins: 0,
    	store: masterStore,
    	uniOpt: {
			expandLastColumn: true,
			useRowNumberer: false
        },
        columns:  [ 
        	{dataIndex:'MAIN_CODE' ,width:80},
        	{dataIndex:'CODE_NAME' ,width:120},
        	{dataIndex:'SUB_CODE' ,width:80} ,
        	{dataIndex:'REF_CODE1' ,width:100} ,
        	{dataIndex:'REF_CODE2' ,width:100},
        	{dataIndex:'REF_CODE3' ,width:100} ,
        	{dataIndex:'REF_CODE4' ,width:100}   
        ]
    });	
	var fileForm = Unilite.createSimpleForm('', {
		region:'south'
    	, height:170
    	, width:'100%'
    	, disabled :false
    	, id: 'searchForm'
        , layout: {type: 'uniTable', columns: 1, tableAttrs:{width:'100%'},tdAttrs: {valign:'center',width:'100%'}}
        , defaults: {labelWidth: 100}
	    , items :[{
			xtype: 'uniFieldset',
			//title: '파일 업로드',
			border:false,
			collapsible: false,
			layout: {
			    type: 'uniTable',
			    columns: 1				//1열 종대형 테이블 layout
			},
			items :[{
     			xtype: 'xuploadpanel',
		    	height: 150,
		    	width:1000,
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
	var htmlView = Ext.create('Ext.view.View', {
		region:'south',
		flex:1,
		tpl: '<tpl for=".">'+
			 '<div class="data-source" ><div class="x-view-item-focused x-item-selected">' +	                 	
              '{html_document}</div></div>'+
        	  '</tpl>',
        itemSelector: 'div.data-source ',
        
        store: htmlStore
    });
    Unilite.Main({
		items 	: [ masterGrid, fileForm, htmlView],
		id: 'tApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset',false);	
		},
		onSaveDataButtonDown: function (config) {
			
		},
		onQueryButtonDown: function(){
			var fp = fileForm.down('xuploadpanel');					//mask on
			fp.getEl().mask('로딩중...','loading-indicator');
			var fileNO = fileForm.getValue('FILE_NO');
			templateService.getFileList({DOC_NO : fileNO},				//파일조회 메서드  호출(param - 파일번호) 
				function(provider, response) {							
					fp.loadData(response.result);						//업로드 파일 load해서 보여주기
					fp.getEl().unmask();								//mask off
					UniAppManager.setToolbarButtons('save',false);		//저장버튼 비활성화
				}
			 )
			 masterStore.loadStoreRecords();
			 htmlStore.loadStoreRecords();
		}
	});
};
</script>
