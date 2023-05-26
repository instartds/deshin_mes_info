<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr570ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="M105" /> <!-- 사급구분 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Bpr570ukrvModel', {
	    fields: [{name: 'COMP_CODE'       		,text:'<t:message code="system.label.base.companycode" default="법인코드"/>' 			,type:'string'},
				 {name: 'DIV_CODE'        		,text:'<t:message code="system.label.base.division" default="사업장"/>' 			,type:'string'},
				 {name: 'PROD_ITEM_CODE'  		,text:'모품목코드' 		,type:'string'},
				 {name: 'CHILD_ITEM_CODE' 		,text:'자품목코드' 		,type:'string'},
				 {name: 'SEQ'             		,text:'<t:message code="system.label.base.seq" default="순번"/>' 				,type:'string'},
				 {name: 'UNIT_Q'          		,text:'원단위량' 			,type:'string'},
				 {name: 'PROD_UNIT_Q'     		,text:'모품목량' 			,type:'string'},
				 {name: 'LOSS_RATE'       		,text:'LOSS율' 			,type:'string'},
				 {name: 'START_DATE'      		,text:'시작일' 			,type:'string'},
				 {name: 'STOP_DATE'       		,text:'종료일' 			,type:'string'},
				 {name: 'USE_YN'          		,text:'<t:message code="system.label.base.useyn" default="사용여부"/>' 			,type:'string'},
				 {name: 'BOM_YN'          		,text:'BOM구성여부' 		,type:'string'},
				 {name: 'UNIT_P1'         		,text:'자품목단가1' 		,type:'string'},
				 {name: 'UNIT_P2'         		,text:'자품목단가2' 		,type:'string'},
				 {name: 'UNIT_P3'         		,text:'자품목단가3' 		,type:'string'},
				 {name: 'MAN_HOUR'        		,text:'표준공수' 			,type:'string'},
				 {name: 'GRANT_TYPE'		 	,text:'<t:message code="system.label.base.remarks" default="비고"/>' 				,type:'string'},
				 {name: 'REMARK'          		,text:'사급구분' 			,type:'string'},
				 {name: 'UPDATE_DB_USER'  		,text:'수정자' 			,type:'string'},
				 {name: 'UPDATE_DB_TIME'  		,text:'수정일' 			,type:'string'}
				 			
					
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bpr570ukrvMasterStore',{
			model: 'Bpr570ukrvModel',
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
                	   read: 'bpr570ukrvService.selectList'                	
                }
            }
			,loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});
				
			}
			
	});

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
		defaultType: 'uniSearchSubPanel',
		items: [{     
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			items: [{
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name: 'DIV_CODE',
				comboType: 'BOR120',
				xtype: 'uniCombobox',
				allowBlank: false
			},{
		        xtype: 'filefield',
		        name: '',
		        fieldLabel: 'EXCEL파일',
		        msgTarget: 'side',
		        allowBlank: false,
		        buttonText: '찾아보기...',
		        width: 320
		    }]
		}]
	});
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('bpr570ukrvGrid', {    
    	region: 'center',
        layout: 'fit',
        uniOpt:{
        	store: directMasterStore
        },
	    // grid용 
    	store: directMasterStore,
        columns: [{ dataIndex: 'COMP_CODE'       		,		width: 66, hidden: true   },
         		  { dataIndex: 'DIV_CODE'        		,		width: 66, hidden: true   },
         		  { dataIndex: 'PROD_ITEM_CODE'  		,		width: 100  },
         		  { dataIndex: 'CHILD_ITEM_CODE' 		,		width: 100  },
         		  { dataIndex: 'SEQ'             		,		width: 33   },
         		  { dataIndex: 'UNIT_Q'          		,		width: 66   },
         		  { dataIndex: 'PROD_UNIT_Q'     		,		width: 66   },
         		  { dataIndex: 'LOSS_RATE'       		,		width: 66   },
         		  { dataIndex: 'START_DATE'      		,		width: 73   },
         		  { dataIndex: 'STOP_DATE'       		,		width: 73   },
         		  { dataIndex: 'USE_YN'          		,		width: 66   },
         		  { dataIndex: 'BOM_YN'          		,		width: 100   },
         		  { dataIndex: 'UNIT_P1'         		,		width: 86   },
         		  { dataIndex: 'UNIT_P2'         		,		width: 86   },
         		  { dataIndex: 'UNIT_P3'         		,		width: 86   },
         		  { dataIndex: 'MAN_HOUR'        		,		width: 66, hidden: true   },
         		  { dataIndex: 'GRANT_TYPE'		 		,		width: 66, hidden: true   }, 
         		  { dataIndex: 'REMARK'          		,		width: 166  },
         		  { dataIndex: 'UPDATE_DB_USER'  		,		width: 66, hidden: true   },
         		  { dataIndex: 'UPDATE_DB_TIME'  		,		width: 66, hidden: true   }
         		  
        ] 
    });
  
	
    Unilite.Main( {
		borderItems:[ 
	 		masterGrid,
			panelSearch
		],
		id: 'bpr570ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function()	{			
			
				masterGrid.getStore().loadStoreRecords();			
			
		}
	});

};


</script>
