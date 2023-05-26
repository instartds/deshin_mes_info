<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//프로그램 정보등록
request.setAttribute("PKGNAME","Unilite_app_bsa402ukrv");
%>
<t:appConfig pgmId="bsa402ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B009" /><!-- 유형 -->  
	<t:ExtComboStore comboType="AU" comboCode="B008" /><!-- 위치 -->        
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 사용여부 -->         
	<t:ExtComboStore comboType="AU" comboCode="BS02" /><!-- 권한형태 -->         
	<t:ExtComboStore comboType="AU" comboCode="B007" /><!-- 업무구분 -->  
</t:appConfig>

<script type="text/javascript" >
function appMain() {
	var useYnStore = Unilite.createStore('${PKGNAME}UseYnStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'<t:message code="system.label.base.use" 	default="사용"/>'		, 'value':'1'},
			        {'text':'<t:message code="system.label.base.unused" default="미사용"/>'	, 'value':'0'}
			        //ColIndex("USE_YN"))  = sMBc03  |#1;사용|#0;미사용
	    		]
	});

	var useYnStore = Unilite.createStore('${PKGNAME}StatusYnStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'미확인'		, 'value':'1'},
			        {'text':'사용'		, 'value':'2'},
			        {'text':'사이트'		, 'value':'3'},
			        {'text':'미사용'		, 'value':'4'}
	    		]
	});

	var useYnStore = Unilite.createStore('${PKGNAME}ProcessTypeStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'목록제외'		, 'value':'0'},
			        {'text':'미개발'		, 'value':'1'},
			        {'text':'개발중'		, 'value':'2'},
			        {'text':'개발완료'		, 'value':'3'},
			        {'text':'테스트중'		, 'value':'4'},
			        {'text':'품질완료'		, 'value':'5'}
	    		]
	});
	
	/**
	 * Model 정의 
	 * @type 
	 */

	Unilite.defineModel('${PKGNAME}Model', {
		// pkGen : user, system(default)
	    fields: [ 	 {name: 'parentId' 		    ,text:'상위소속' 			,type:'string'	 ,editable:false   }
	    			,{name: 'PGM_ID' 		    ,text:'PGM_ID' 			,type:'string'	 ,allowBlank:false 	,isPk:true	}
	    			,{name: 'PGM_NAME' 		    ,text:'프로그램명' 			,type:'string'	 ,allowBlank:false }
	    			,{name: 'PGM_NAME_EN' 	    ,text:'프로그램명(영어)' 	,type:'string'	}
	    			,{name: 'PGM_NAME_CN' 	    ,text:'프로그램명(중국어)' 	,type:'string'	}
	    			,{name: 'PGM_NAME_JP' 	    ,text:'프로그램명(일본어)' 	,type:'string'	}
	    			,{name: 'PGM_NAME_VI' 	    ,text:'프로그램명(베트남어)' 	,type:'string'	}
	    			,{name: 'TYPE' 			    ,text:'유형' 				,type:'string'	 ,comboType:'AU', comboCode:'B009'}
	    			,{name: 'LOCATION' 		    ,text:'위치' 				,type:'string'	 ,comboType:'AU', comboCode:'B008'}
	    			,{name: 'USE_YN' 		    ,text:'<t:message code="system.label.base.useyn" default="사용여부"/>'	,type:'string' 	 ,store: Ext.data.StoreManager.lookup('${PKGNAME}UseYnStore')}
	    			,{name: 'PGM_ARNG_SEQ' 	    ,text:'<t:message code="system.label.base.seq" default="순번"/>' 		,type:'integer'	}
	    			,{name: 'CUSTOM_01' 	    ,text:'유양'	 			,type:'string'	,store: Ext.data.StoreManager.lookup('${PKGNAME}StatusYnStore')}
	    			,{name: 'CUSTOM_02' 	    ,text:'극동' 				,type:'string'	,store: Ext.data.StoreManager.lookup('${PKGNAME}StatusYnStore')}
	    			,{name: 'CUSTOM_03' 	    ,text:'제이월드' 			,type:'string'	,store: Ext.data.StoreManager.lookup('${PKGNAME}StatusYnStore')}
	    			,{name: 'CUSTOM_04' 	    ,text:'양평' 				,type:'string'	,store: Ext.data.StoreManager.lookup('${PKGNAME}StatusYnStore')}
	    			,{name: 'CUSTOM_05' 	    ,text:'성남' 				,type:'string'	,store: Ext.data.StoreManager.lookup('${PKGNAME}StatusYnStore')}
	    			,{name: 'CUSTOM_06' 	    ,text:'코베아' 			,type:'string'	,store: Ext.data.StoreManager.lookup('${PKGNAME}StatusYnStore')}
	    			,{name: 'CUSTOM_07' 	    ,text:'포렌' 				,type:'string'	,store: Ext.data.StoreManager.lookup('${PKGNAME}StatusYnStore')}
	    			,{name: 'CUSTOM_08' 	    ,text:'고객사08' 			,type:'string'	,store: Ext.data.StoreManager.lookup('${PKGNAME}StatusYnStore')}
	    			,{name: 'CUSTOM_09' 	    ,text:'고객사09' 			,type:'string'	,store: Ext.data.StoreManager.lookup('${PKGNAME}StatusYnStore')}
	    			,{name: 'CUSTOM_10' 	    ,text:'고객사10' 			,type:'string'	,store: Ext.data.StoreManager.lookup('${PKGNAME}StatusYnStore')}
	    			,{name: 'PROCESS_TYPE' 	    ,text:'진행상태' 			,type:'string'	,store: Ext.data.StoreManager.lookup('${PKGNAME}ProcessTypeStore')}
	    			,{name: 'SP_NAME' 		    ,text:'관련SP'			,type:'string'	}
	    			,{name: 'AUTHO_TYPE' 	    ,text:'권한형태' 			,type:'string'	 ,editable:false ,comboType:'AU', comboCode:'BS02'}
	    			,{name: 'AUTHO_PGM' 	    ,text:'권한정의' 			,type:'string'	 ,editable:false  }
	    			,{name: 'PGM_SEQ' 		    ,text:'<t:message code="system.label.base.businessclassification" default="업무구분"/>' 			,type:'string'	 ,allowBlank:false}
	    			,{name: 'PGM_LEVEL' 	    ,text:'레벨' 				,type:'string'	 ,allowBlank:false}
	    			,{name: 'PGMMER' 		    ,text:'개발자' 			,type:'string'	}
	    			,{name: 'PGM_DATE' 		    ,text:'개발일' 			,type:'uniDate' }
	    			,{name: 'REMARK' 		    ,text:'<t:message code="system.label.base.remarks" default="비고"/>' 				,type:'string'	}
	    			,{name: 'AUTHO_CD' 		    ,text:'권한정의(번호)' 		,type:'string'	}
	    			,{name: 'UP_PGM_DIV'	    ,text:'상위소속'			,type:'string'	}
	    			,{name: 'MANUAL_DISPLAY_YN'	,text:'도움말 여부'			,type:'string'	,comboType:'AU', comboCode:'B010'}
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */				
	
	var directMasterStore = Unilite.createTreeStore('${PKGNAME}MasterStore',{
			model: '${PKGNAME}Model',
            autoLoad: false,
            folderSort: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: /*directProxy*/{
                type: EXTVERSION == '4.2.2' ? 'direct':'uniDirect',
                api: {
	                read : 'bsa402ukrvService.selectList'
	                ,update : 'bsa402ukrvService.updatePrograms'
					,create : 'bsa402ukrvService.insertPrograms'
					,destroy: 'bsa402ukrvService.deletePrograms'
					,syncAll: EXTVERSION == '4.2.2' ? 'bsa402ukrvService.syncAll':'bsa402ukrvService.saveAll'
                	
                }
            }
            
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('${PKGNAME}searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			,saveStore : function()	{	
				var me = this;
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					var toCreate = me.getNewRecords();
            		var toUpdate = me.getUpdatedRecords();
            		
            		var toDelete = me.getRemovedRecords();
            		var list = [].concat( toUpdate, toCreate   );
					var checkType = true;
					console.log("list:", list);
					Ext.each(list, function(node, index) {
						
						var pid = node.get('parentId');
						
						//유형은 모듈메뉴에서는 입력값으 없으므로 필수입력사항에서 제외시킨다.
						if( pid != 'root' && Ext.isEmpty(node.get("TYPE"))) {
							Unilite.messageBox("유형은 필수 입력값입니다.");
							checkType = false;
						}
						node.set('UP_PGM_DIV', node.parentNode.get('PGM_ID'));
						
						node.set('parentId',  node.parentNode.get('PGM_SEQ')+node.parentNode.get('PGM_ID'));
						
						console.log("list:", node.get('UP_PGM_DIV') + " / " + node.parentNode.get('PGM_ID'));
						
					});
					
					if(checkType)	{
						var config = {
							//params:[panelSearch.getValues()],	
							success : function()	{
								UniAppManager.app.onQueryButtonDown();
							}
						  }
						EXTVERSION == '4.2.2' ?  this.syncAll(config):this.syncAllDirect();
					}
					//UniAppManager.setToolbarButtons('save', false);
				}else {					
                	masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		});


	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('${PKGNAME}searchForm',{
        layout : {type : 'uniTable' , columns: 4 },
        items: [  {fieldLabel: '<t:message code="system.label.base.businessclassification" default="업무구분"/>'		,name : 'PGM_SEQ', xtype:'uniCombobox'	,comboType:'AU',comboCode:'B007'	,
        			listeners:{
        				select: function( combo, records, eOpts )	{
        					console.log("select event combo", combo);
        				}
        				,
        				beforedestroy: function( combo, eOpts )	{
        					console.log("beforedestroy event combo", combo);
        				}
        			}
        		  }
        		 ,{fieldLabel: '프로그램ID'	,name : 'PGM_ID'	}
        		 ,{fieldLabel: '프로그램명'		,name : 'PGM_NAME'	}
        		 ,{fieldLabel: '전체언어'		,xtype:'checkboxfield'	
        		    ,items:[
    		    		{name:'LANGUAGE', inputValue:'A'
        		    }]
        		   ,listeners : {
    		   			change: function( checkbox, newValue, oldValue, eOpts )	{
	   						console.log("checkbox.getValue() : ", checkbox.getValue());
		   					if(checkbox.getValue())	{
		   						masterGrid.columns[3].setVisible( true );
		   						masterGrid.columns[4].setVisible( true );
		   						masterGrid.columns[5].setVisible( true );
		   						masterGrid.columns[6].setVisible( true );
		   					}else {
		   						masterGrid.columns[3].setVisible( false );
		   						masterGrid.columns[4].setVisible( false );
		   						masterGrid.columns[5].setVisible( false );
		   						masterGrid.columns[6].setVisible( false );
		   						
		   					}
	   					}
		    	}
        	}
		]		            
    });  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createTreeGrid('${PKGNAME}Grid', {
    	store: directMasterStore,
    	
    	maxDepth : 3,
		columns:[{
		                xtype: 'treecolumn', //this is so we know which column will show the tree
		                text: '프로그램명',
		                width:250,
		                sortable: true,
		                dataIndex: 'PGM_NAME', editable: false 
		         }				 
				,{dataIndex:'PGM_ID'			,width:90	}
				,{dataIndex:'PGM_NAME'			,width:250}	
				,{dataIndex:'PGM_NAME_EN'		,width:250	,hidden:true}
				,{dataIndex:'PGM_NAME_CN'		,width:250	,hidden:true}
				,{dataIndex:'PGM_NAME_JP'		,width:250	,hidden:true}
				,{dataIndex:'PGM_NAME_VI'		,width:250	,hidden:true}
				,{dataIndex:'TYPE'				,width:50}
				,{dataIndex:'LOCATION'			,width:120	,hidden:true}
				,{dataIndex:'USE_YN'			,width:70}
				,{dataIndex:'PGM_ARNG_SEQ'		,width:40}
    			,{dataIndex:'PROCESS_TYPE' 		,width:80 	}
    			,{dataIndex:'SP_NAME' 			,width:120 	}
				,{dataIndex:'REMARK'			,width:300	}
    			,{dataIndex:'CUSTOM_01' 		,width:80	}
    			,{dataIndex:'CUSTOM_02' 		,width:80 	}
    			,{dataIndex:'CUSTOM_03' 		,width:80 	}
    			,{dataIndex:'CUSTOM_04' 		,width:80 	}
    			,{dataIndex:'CUSTOM_05' 		,width:80 	}
    			,{dataIndex:'CUSTOM_06' 		,width:80 	}
    			,{dataIndex:'CUSTOM_07' 		,width:80 	}
    			,{dataIndex:'CUSTOM_08' 		,width:80 	,hidden:true}
    			,{dataIndex:'CUSTOM_09' 		,width:80 	,hidden:true}
    			,{dataIndex:'CUSTOM_10' 		,width:80 	,hidden:true}
				,{dataIndex:'AUTHO_TYPE'		,width:70	,hidden:true}
				,{dataIndex:'AUTHO_PGM'			,width:80	,hidden:true}
				,{dataIndex:'MANUAL_DISPLAY_YN'	,width:100	,hidden:true}
				,{dataIndex:'PGM_SEQ'			,width:80	,hidden:true}
				,{dataIndex:'PGM_LEVEL'			,width:80	,hidden:true}
				,{dataIndex:'PGMMER'			,width:80	,hidden:true}
				,{dataIndex:'PGM_DATE'			,width:80	,hidden:true}
				,{dataIndex:'AUTHO_CD'			,width:100	,hidden:true}
				,{dataIndex:'UP_PGM_DIV'		,width:100	,hidden:true}
          ] 
          ,listeners : {
          		beforeedit  : function( editor, e, eOpts ) {
          			if(e.record.data.PGM_LEVEL == '1'){
          				return false;
          			}
          			if(e.record.data.TYPE == '9'){
          				if (UniUtils.indexOf(e.field, 
									['LOCATION','USE_YN','PGM_ARNG_SEQ','AUTHO_TYPE','AUTHO_PGM','PGM_SEQ',
									 'PGM_LEVEL','UP_PGM_DIV','PGMMER','PGM_DATE',
									 'REMARK','AUTHO_CD','COMP_CODE', 'MANUAL_DISPLAY_YN']) )
						return false;
          			}
          		}
			}
    });
    
  	Unilite.Main({
		items : [panelSearch, 	masterGrid],
		id  : 'bsa402ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
		},
		onQueryButtonDown : function() {	
			directMasterStore.loadStoreRecords();		
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		},
		onNewDataButtonDown : function()	{	         
			var selectNode = masterGrid.getSelectionModel().getLastSelected();
			
	        var newRecord = masterGrid.createRow( );
	        
	        if(newRecord)	{
	        	newRecord.set('LOCATION',selectNode.get('LOCATION'));
	        	newRecord.set('USE_YN','1');
	        	
	        	if(Ext.isEmpty(selectNode.get('TYPE')))	{
	        		newRecord.set('TYPE','9');
	        	} else {
	        		newRecord.set('TYPE',selectNode.get('TYPE'));
	        	}
	        	
				if(selectNode.get('PGM_LEVEL') == '1')	{
					newRecord.set('PGM_ARNG_SEQ',1);
				}else if(selectNode.get('TYPE') == '')	{
					newRecord.set('PGM_ARNG_SEQ',1);
				}else if(selectNode.get('PGM_ARNG_SEQ') == '')	{
					newRecord.set('PGM_ARNG_SEQ',1);
				}else {
					var seq = selectNode.get('PGM_ARNG_SEQ')+1;
					newRecord.set('PGM_ARNG_SEQ',seq);
				}
	        	newRecord.set('PGM_SEQ',selectNode.get('PGM_SEQ'));
	        	newRecord.set('PGM_LEVEL',newRecord.getDepth());
	        	//newRecord.set('UP_PGM_DIV',selectNode.get('PGM_ID'));
	        }
		},
		
		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('${PKGNAME}Grid');
			directMasterStore.saveStore();				
		},
		onDeleteDataButtonDown : function()	{
			var delRecord = masterGrid.getSelectionModel().getLastSelected();
			
			if(delRecord.get('parentId')=='root')	{
				Unilite.messageBox(Msg.sMB158);
				return;
			}
			if(delRecord.childNodes.length > 0)	{
				Unilite.messageBox(Msg.sMB163);
				return;
			}
			if(confirm(Msg.sMB062))	{
				masterGrid.deleteSelectedRow();	
			}
		},
		onResetButtonDown:function() {
			var masterGrid = Ext.getCmp('${PKGNAME}Grid');
			Ext.getCmp('${PKGNAME}searchForm').getForm().reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		}
	});
}; 
</script>
