<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="tpl104ukrv"  >  
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 사용여부 -->    
</t:appConfig>

<script type="text/javascript" >
function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */
	 
	Unilite.defineModel('tpl104ukrvModel', {
		/**	   		 
   		 * type:
   		 * 		uniQty		   -      수량
		 *		uniUnitPrice   -      단가
		 *		uniPrice	   -      금액(자사화폐)
		 *		uniPercent	   -      백분율(00.00)
		 *		uniFC          -      금액(외화화폐)
		 *		uniER          -      환율
		 *		uniDate        -      날짜(2999.12.31)
		 * maxLength: 입력가능한 최대 길이
		 * editable: true	수정가능 여부
   		 * allowBlank: 필수 여부
   		 * defaultValue: 기본값
   		 * comboType:'AU', comboCode:'B014' : 그리드 콤보 사용시
		*/
		// pkGen : user, system(default)
	    fields: [{name: 'parentId' 		,text:'상위소속' 		,type:'string',	editable:false}
    			,{name: 'LVL' 			,text:'LVL' 		,type:'string'		}
    			,{name: 'LEVEL1' 		,text:'대분류' 		,type:'string'		}
    			,{name: 'LEVEL2' 		,text:'중분류' 		,type:'string'		}
    			,{name: 'LEVEL3' 		,text:'소분류' 		,type:'string'		}
    			,{name: 'LEVEL_NAME' 	,text:'항목명' 		,type:'string', maxLength:20}
    			,{name: 'LEVEL_CODE' 	,text:'분류코드' 		,type:'string',	allowBlank:false, isPk:true, maxLength:5}
    			,{name: 'USE_YN' 		,text:'사용여부' 		,type:'string',  comboType:'AU', comboCode:'B010'		}
    			,{name: 'REMARK' 		,text:'비고' 			,type:'string'		}
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createTreeStore('tpl104ukrvMasterStore',{
			model: 'tpl104ukrvModel',
            autoLoad: false,
            folderSort: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },            
            proxy: {
                type: 'direct',
                api: {
	                read: 'templateService.selectTree',			//조회
					update: 'templateService.updateDetail',			//수정
					create: 'templateService.insertDetail',			//입력
					destroy: 'templateService.deleteDetail',		//삭제
					syncAll: 'templateService.saveAll'				//저장
                }
            }            
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();	//조회폼 파라미터 수집				
				console.log( param );
				this.load({											//그리드에 Load..
					params : param
				});
				
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			,saveStore : function()	{	
				var me = this;
				var inValidRecs = this.getInvalidRecords();					//필수값 입력여부 체크
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					var toCreate = me.getNewRecords();						//createRow
            		var toUpdate = me.getUpdatedRecords();					//updateRow            		
            		var toDelete = me.getRemovedRecords();					//deleteRow
            		
            		var list = [].concat( toUpdate, toCreate);				//변동 record 합치기
					
					console.log("list:", list);
					Ext.each(list, function(node, index) {	//depth에 따른 LEVEL 값 set
						var pid = node.get('parentId');
						console.log("node.getDepth() ", node.getDepth());
						console.log("node :  ", node);
						var depth = node.getDepth();						
							if(depth=='4')	{
								node.set('parentId',  node.get('LEVEL2'));
								node.set('LEVEL1',  node.parentNode.get('LEVEL1'));
								node.set('LEVEL2',  node.parentNode.get('LEVEL2'));
								node.set('LEVEL3',  node.get('LEVEL_CODE'));
							} else if(depth=='3') 	{
								node.set('parentId',  node.get('LEVEL1'));
								node.set('LEVEL1',  node.parentNode.get('LEVEL1'));
								node.set('LEVEL2',  node.get('LEVEL_CODE'));
								node.set('LEVEL3',  '*');
							} else if(depth=='2')	{
								node.set('parentId', 'rootData');
								node.set('LEVEL1',  node.get('LEVEL_CODE'));
								node.set('LEVEL2',  '*');
								node.set('LEVEL3',  '*');
							}						
					});					
					this.syncAll({					//저장 로직 실행	
						success : function()	{	//저장후 실행될 로직
							UniAppManager.app.onQueryButtonDown();
						}
					});
				}else {
					alert(Msg.sMB083);
				}
			}            
		});	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
		
	var panelSearch = Unilite.createSearchForm('searchForm',{
        layout : {type : 'uniTable' , columns: 4 },		//4열 종대형 테이블 레이아웃
        items: [{
        	fieldLabel: '대분류',
        	name: 'LEVEL1' ,
        	xtype: 'uniCombobox' ,
//        	store: Ext.data.StoreManager.lookup('itemLeve1Store') ,			//사용 할 콤보Store 
        	child: 'LEVEL2'
        },{
        	fieldLabel: '중분류',
        	name: 'LEVEL2' ,
        	xtype: 'uniCombobox' ,
//        	store: Ext.data.StoreManager.lookup('itemLeve2Store') ,			//사용 할 콤보Store
        	child: 'LEVEL3'
        },{
        	fieldLabel: '소분류',
        	name: 'LEVEL3' ,
        	xtype: 'uniCombobox' ,
//        	store: Ext.data.StoreManager.lookup('itemLeve3Store'),			//사용 할 콤보Store
        	parentNames:['LEVEL1','LEVEL2'],
        	levelType:'ITEM'
        },{
        	fieldLabel: '사용유무',
        	name: 'USE_YN' ,
        	xtype: 'uniCombobox' ,
        	comboType:'AU',				  //AU: 미사용 포함
        	comboCode:'B010'              //사용할 공통코드  
        }]		            
    });  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */

    var masterGrid = Unilite.createTreeGrid('tpl104ukrvGrid', {
    	store: directMasterStore,
    	maxDepth : 3,
		columns:[{
	                xtype: 'treecolumn', //this is so we know which column will show the tree
	                text: '분류',
	                width:250,
	                sortable: true,
	                dataIndex: 'LEVEL_NAME', editable: false 
		         }				 
				,{dataIndex:'LEVEL_CODE'	,width:130 }
				,{dataIndex:'LEVEL_NAME'	,width:530	}
				,{dataIndex:'USE_YN'		,width:70}
				,{dataIndex:'REMARK'		,flex:1}		//flex: 자리 차지하는 비율
          ] 
         ,listeners : {
     		beforeedit  : function( editor, e, eOpts ) {	//수정전 editable 처리..
				if(e.record.data.parentId =='root')	{		//root는 수정 불가.								
					return false;
				}
			}         
         }          
    });
    
  	Unilite.Main({
		items : [/*panelSearch,*/ 	masterGrid],
		id  : 'tpl104ukrvApp',
		fnInitBinding : function() {
			/**
			 * 화면 오픈시 UserInfo정보
			 *  singleton: true,
		     *  userID: 		"misoon",
		     *  userName: 		"홍길동",
		     *  personNumb: 	"1999041900",
		     *  divCode: 		"01",
		     *  deptCode: 		"0101",
		     *  deptName: 		"관리부",
		     *  compCode: 		"MASTER",
		     *  currency:  		'KRW',
		     *  userLang:		'KR',
		     *  compCountry:	'KR',
			 *  appOption.collapseLeftSearch: 좌측폼 collapse 여부 
			*/
			UniAppManager.setToolbarButtons(['reset','newData'],true);	//main 버튼 활성화 여부
			
		},
		onQueryButtonDown : function() {			//조회버튼 클릭시    
			directMasterStore.loadStoreRecords();	//Store 조회 함수 호출	
		},
//		onSaveAndQueryButtonDown : function()	{
//			this.onSaveDataButtonDown();
//		},
		onNewDataButtonDown : function()	{	         
			var selectNode = masterGrid.getSelectionModel().getLastSelected();			
	        var newRecord = masterGrid.createRow( );
	        
	        if(newRecord)	{	//행 생성시 default값 세팅
				newRecord.set('LEVEL1',selectNode.get('LEVEL1'));
				newRecord.set('LEVEL2',selectNode.get('LEVEL2'));
				newRecord.set('LEVEL3',selectNode.get('LEVEL3'));
	        	newRecord.set('USE_YB','Y');
	        }
		},
		
		onSaveDataButtonDown: function () {		//저장버튼 클릭시
			directMasterStore.saveStore();				
		},
		onDeleteDataButtonDown : function()	{	//삭제버튼 클릭시
			var delRecord = masterGrid.getSelectionModel().getLastSelected();			
			if(delRecord.childNodes.length > 0)	{
				var msg ='';
				if(delRecord.getDepth() == '3')	msg=Msg.sMB155; 		//소분류부터 삭제하십시오.
				else if(delRecord.getDepth() == '2')	msg=Msg.sMB156; //중분류부터 삭제하십시오.
				alert(msg);
				return;
			}
			
			if(confirm(Msg.sMB062))	{
				masterGrid.deleteSelectedRow();	
			}
		},
		onResetButtonDown:function() {		//신규버튼 클릭시
			var masterGrid = Ext.getCmp('tpl104ukrvGrid');
			Ext.getCmp('searchForm').getForm().reset();	//조회조건 폼 reset
			masterGrid.reset();	//그리드 reset
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);	//main 버튼 활성화 여부
		}

	});	
}; 

</script>
