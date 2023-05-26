<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa510skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B007" /> <!--업무구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B003" /> <!-- 프로그램 사용권한 --> 
	<t:ExtComboStore comboType="AU" comboCode="B006" /> <!-- 파일저장 사용권한 -->      
	<t:ExtComboStore comboType="AU" comboCode="BS04" /> <!-- 권한범위 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Bsa510skrvModel', {
	    fields: [{name: 'USER_ID' 		,text:'<t:message code="system.label.base.userid" default="사용자ID"/>' 			,type:'string'},
    			 {name: 'USER_NAME' 	,text:'<t:message code="system.label.base.username" default="사용자명"/>' 			,type:'string'},
				 {name: 'PGM_ID' 		,text:'<t:message code="system.label.base.programid" default="프로그램ID"/>' 		,type:'string'},
    			 {name: 'PGM_NAME' 		,text:'<t:message code="system.label.base.programname" default="프로그램명"/>' 			,type:'string'},	
    			 {name: 'PGM_SEQ' 		,text:'<t:message code="system.label.base.businessclassification" default="업무구분"/>' 			,type:'string',	comboType:'AU', comboCode:'B007'},
    			 {name: 'PGM_LEVEL' 	,text:'<t:message code="system.label.base.datamodify" default="자료수정"/>' 			,type:'string',	comboType:'AU', comboCode:'B003'},
    			 {name: 'PGM_LEVEL2' 	,text:'<t:message code="system.label.base.filesave" default="파일저장"/>' 			,type:'string',	comboType:'AU', comboCode:'B006'},
				 {name: 'AUTHO_USER' 	,text:'<t:message code="system.label.base.authouser" default="자료권한"/>' 			,type:'string'},
				 {name: 'UPDATE_MAN' 	,text:'<t:message code="system.label.base.updateuser" default="수정자"/>' 			,type:'string'},
				 {name: 'UODATE_DATE' 	,text:'<t:message code="system.label.base.updatedate" default="수정일"/>' 			,type:'uniDate'},
				 {name: 'AUTHO_TYPE' 	,text:'<t:message code="system.label.base.authotype" default="권한형태"/>' 			,type:'string'},
				 {name: 'AUTHO_PGM' 	,text:'<t:message code="system.label.base.authopgm" default="권한정의"/>' 			,type:'string'},
				 {name: 'REF_CODE' 		,text:'<t:message code="system.label.base.refcode" default="참조코드"/>' 			,type:'string'},
				 {name: 'AUTHO_ID' 		,text:'<t:message code="system.label.base.authotypenumb" default="권한형태(번호)"/>' 		,type:'string'}
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bsa510skrvMasterStore',{
			model: 'Bsa510skrvModel',
			uniOpt: {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'bsa510skrvService.selectList'                	
                }
            }
			,loadStoreRecords: function()	{
				var param= Ext.getCmp('resultForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});
			},
	        listeners: {
	            load: function(store, records, successful, eOpts) {
	                var count = masterGrid.getStore().getCount(); 
	                if(count == 0) {
	                	Unilite.messageBox('<t:message code="system.message.base.lookupbox.emptyText" default="조회된 결과가 없습니다."/>');
	                }
	            }
	        }

	});

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
/*
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
		defaultType: 'uniSearchSubPanel',
		items: [{     
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			items: [ 
				Unilite.popup('USER',{
				allowBlank:true,
				textFieldWidth:170,
				fieldLabel: '사용자 ID',
				valueFieldName:'USER_ID',
		    	textFieldName:'USER_NAME',
				validateBlank:false, 
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('USER_ID', panelSearch.getValue('USER_ID'));
							panelResult.setValue('USER_NAME', panelSearch.getValue('USER_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('USER_ID', '');
						panelResult.setValue('USER_NAME', '');
					}
				}				
			}),{
				fieldLabel: '프로그램 ID',
				name:'PGM_ID',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PGM_ID', newValue);
					}
				}				
			}, {
				fieldLabel: '<t:message code="system.label.base.businessclassification" default="업무구분"/>'	,
				name:'PGM_SEQ',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B007',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PGM_SEQ', newValue);
					}
				}				
			}, {
				fieldLabel: '프로그램명' ,
				name:'PGM_NAME',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PGM_NAME', newValue);
					}
				}				
			}]
		}]
	});
*/
   	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,	
		items: [ 
				Unilite.popup('USER',{
				allowBlank:true,
				textFieldWidth:170,
				fieldLabel: '<t:message code="system.label.base.userid" default="사용자ID"/>',
				valueFieldName:'USER_ID',
		    	textFieldName:'USER_NAME',
				validateBlank:false, 
				popupWidth: 710,
				listeners: {
/*
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('USER_ID', panelResult.getValue('USER_ID'));
							panelSearch.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('USER_ID', '');
						panelSearch.setValue('USER_NAME', '');
					}
*/
				}				
			}),{
				fieldLabel: '<t:message code="system.label.base.programid" default="프로그램ID"/>',
				name:'PGM_ID',
				xtype: 'uniTextfield',
				listeners: {
/*
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PGM_ID', newValue);
					}
*/
				}				
			}, {
				fieldLabel: '<t:message code="system.label.base.businessclassification" default="업무구분"/>'	,
				name:'PGM_SEQ',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B007',
				listeners: {
/*
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PGM_SEQ', newValue);
					}
*/
				}				
			}, {
				fieldLabel: '<t:message code="system.label.base.programname" default="프로그램명"/>' ,
				name:'PGM_NAME',
				xtype: 'uniTextfield',
				listeners: {
/*
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PGM_NAME', newValue);
					}
*/
				}				
			}]	
 	});		// end of var panelResul	
 	
 	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('bsa510skrvGrid', {    
    	region: 'center',
        layout: 'fit',
        uniOpt:{
        	store: directMasterStore
        },
	    // grid용 
    	store: directMasterStore,
        columns: [{ dataIndex: 'USER_ID' ,			width: 86  }, 				
				  { dataIndex: 'USER_NAME', 		width: 120 }, 	
				  { dataIndex: 'PGM_ID',			width: 100 },				
				  { dataIndex: 'PGM_NAME', 			width: 220 }, 				
				  { dataIndex: 'PGM_SEQ', 			width: 133 },				
				  { dataIndex: 'PGM_LEVEL', 		width: 100, align:'center' }, 
				  { dataIndex: 'PGM_LEVEL2', 		width: 100, align:'center' },				
				  { dataIndex: 'AUTHO_USER', 	  	width: 66  }, 				
				  { dataIndex: 'UPDATE_MAN', 		width: 66, hidden: true },				
				  { dataIndex: 'UODATE_DATE', 		width: 66, hidden: true }, 	
				  { dataIndex: 'AUTHO_TYPE',	  	width: 66, hidden: true },				
				  { dataIndex: 'AUTHO_PGM', 	  	width: 66, hidden: true }, 				
				  { dataIndex: 'REF_CODE', 			width: 66, hidden: true },				
				  { dataIndex: 'AUTHO_ID', 			width: 66, hidden: true } 	
          ] 
    });
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region: 'center',
			layout: 'border',
			items:[
				masterGrid, panelResult
			]
		}	 
		//,panelSearch
		],		
		id: 'bsa510skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function()	{			
			directMasterStore.loadStoreRecords();
				//masterGrid.getStore().loadStoreRecords();			
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};
</script>
