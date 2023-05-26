<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aga361ukr">
	<t:ExtComboStore items="${COMBO_APP_TYPE}"	storeId="aga361ukrAppTypeStore" />	<!-- 어플리케이션 ID -->
	<t:ExtComboStore items="${COMBO_GUBUN_1}"	storeId="aga361ukrGubun1Store" />	<!-- 구분1 -->
	<t:ExtComboStore items="${COMBO_GUBUN_2}"	storeId="aga361ukrGubun2Store" />	<!-- 구분2 -->
	<t:ExtComboStore items="${COMBO_GUBUN_3}"	storeId="aga361ukrGubun3Store" />	<!-- 구분3 -->
	<t:ExtComboStore items="${COMBO_GUBUN_4}"	storeId="aga361ukrGubun4Store" />	<!-- 구분4 -->
	<t:ExtComboStore items="${COMBO_GUBUN_5}"	storeId="aga361ukrGubun5Store" />	<!-- 구분5 -->
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >


function appMain() {   

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read	: 'aga361ukrService.selectList',
        	update	: 'aga361ukrService.updateList',
			create	: 'aga361ukrService.insertList',
			destroy	: 'aga361ukrService.deleteList',
			syncAll	: 'aga361ukrService.saveAll'
        }
	});

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aga361ukrModel', {
	   fields: [
			{name: 'parentId' 			, text: '상위소속'			, type: 'string'		, editable: false},
			{name: 'LVL' 				, text: 'LVL' 			, type: 'string' },
			{name: 'LEVEL_CODE' 		, text: '분류코드' 		, type: 'string'		, allowBlank: false		, isPk:true		, maxLength:10},
	   		{name: 'COMP_CODE'			, text: '법인'			, type: 'string' },
			{name: 'APP_TYPE'			, text: '어플리케이션ID'	, type: 'string' },
			{name: 'GUBUN_1'			, text: '구분1'			, type: 'string' },
			{name: 'GUBUN_2'			, text: '구분2'			, type: 'string' },
			{name: 'GUBUN_3'			, text: '구분3'			, type: 'string' },
			{name: 'GUBUN_4'			, text: '구분4'			, type: 'string' },
			{name: 'GUBUN_5'			, text: '구분5'			, type: 'string' },
			{name: 'NAME'				, text: '구분명'			, type: 'string'		, allowBlank: false},
			{name: 'REMARK_1'			, text: '비고1'			, type: 'string' },
			{name: 'REMARK_2'			, text: '비고2'			, type: 'string' },
			{name: 'REMARK_3'			, text: '비고3'			, type: 'string' },
			{name: 'INSERT_DB_USER'		, text: '입력자'			, type: 'string' },
			{name: 'INSERT_DB_TIME'		, text: '입력일'			, type: 'uniDate'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'			, type: 'string' },
			{name: 'UPDATE_DB_TIME'		, text: '수정일'			, type: 'uniDate'},
			{name: 'TEMPC_01'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPC_02'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPC_03'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPN_01'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPN_02'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPN_03'			, text: '여유컬럼'			, type: 'string' }
	    ]
	});
	  
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createTreeStore('aga361ukrmasterStore',{
		model		: 'aga361ukrModel',
        proxy		: directProxy,
        autoLoad	: false,
        folderSort	: true,
		uniOpt		: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 	
			deletable	: true,			// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		
		saveStore : function()	{	
			var me = this;
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				var toCreate = me.getNewRecords();
        		var toUpdate = me.getUpdatedRecords();
        		var toDelete = me.getRemovedRecords();
        		var list = [].concat( toCreate );
				
				console.log("list:", list);
				Ext.each(list, function(node, index) {
					var pid = node.get('parentId');
					var depth = node.getDepth();
					
					if(depth=='7')	{
						node.set('parentId'	, node.get('GUBUN_4'));
						node.set('APP_TYPE'	, node.parentNode.get('APP_TYPE'));
						node.set('GUBUN_1'	, node.parentNode.get('GUBUN_1'));
						node.set('GUBUN_2'	, node.parentNode.get('GUBUN_2'));
						node.set('GUBUN_3'	, node.parentNode.get('GUBUN_3'));
						node.set('GUBUN_4'	, node.parentNode.get('GUBUN_4'));
						node.set('GUBUN_5'	, node.get('LEVEL_CODE'));
					
					} else if(depth=='6')	{
						node.set('parentId'	, node.get('GUBUN_3'));
						node.set('APP_TYPE'	, node.parentNode.get('APP_TYPE'));
						node.set('GUBUN_1'	, node.parentNode.get('GUBUN_1'));
						node.set('GUBUN_2'	, node.parentNode.get('GUBUN_2'));
						node.set('GUBUN_3'	, node.parentNode.get('GUBUN_3'));
						node.set('GUBUN_4'	, node.get('LEVEL_CODE'));
						node.set('GUBUN_5'	, '*');
					
					} else if(depth=='5')	{
						node.set('parentId'	, node.get('GUBUN_2'));
						node.set('APP_TYPE'	, node.parentNode.get('APP_TYPE'));
						node.set('GUBUN_1'	, node.parentNode.get('GUBUN_1'));
						node.set('GUBUN_2'	, node.parentNode.get('GUBUN_2'));
						node.set('GUBUN_3'	, node.get('LEVEL_CODE'));
						node.set('GUBUN_4'	, '*');
						node.set('GUBUN_5'	, '*');
						
					} else if(depth=='4')	{
						node.set('parentId'	, node.get('GUBUN_1'));
						node.set('APP_TYPE'	, node.parentNode.get('APP_TYPE'));
						node.set('GUBUN_1'	, node.parentNode.get('GUBUN_1'));
						node.set('GUBUN_2'	, node.get('LEVEL_CODE'));
						node.set('GUBUN_3'	, '*');
						node.set('GUBUN_4'	, '*');
						node.set('GUBUN_5'	, '*');
						
					} else if(depth=='3') 	{
						node.set('parentId'	, node.get('APP_TYPE'));
						node.set('APP_TYPE'	, node.parentNode.get('APP_TYPE'));
						node.set('GUBUN_1'	, node.get('LEVEL_CODE'));
						node.set('GUBUN_2'	, '*');
						node.set('GUBUN_3'	, '*');
						node.set('GUBUN_4'	, '*');
						node.set('GUBUN_5'	, '*');
						
					} else if(depth=='2')	{
						node.set('parentId'	, 'rootData');
						node.set('APP_TYPE'	, node.get('LEVEL_CODE'));
						node.set('GUBUN_1'	, '*');
						node.set('GUBUN_2'	, '*');
						node.set('GUBUN_3'	, '*');
						node.set('GUBUN_4'	, '*');
						node.set('GUBUN_5'	, '*');
					}
				});
				
				config = {
					success: function(batch, option) {
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
						
						if (masterStore.count() == 0) {   
//							UniAppManager.app.onResetButtonDown();
							
						}else{
//							UniAppManager.app.onQueryButtonDown();
						}
					 } 
				};
				this.syncAllDirect(config);
				/*this.syncAll({success : function()	{
						UniAppManager.app.onQueryButtonDown();
					}
				});*/
				
			} else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	
           	add: function(store, records, index, eOpts) {
           	},
           	
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});

	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title	: '기본정보', 	
	   		itemId	: 'search_panel1',
	        layout	: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items	: [{ 
				fieldLabel	: '어플리케이션',
				name		: 'APP_TYPE', 
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('aga361ukrAppTypeStore'),
				allowBlank	: false,
				listeners	: {
					specialkey: function(field, event){
						if(event.getKey() == event.ENTER){
							UniAppManager.app.onQueryButtonDown();
						}
					},
					
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('APP_TYPE', newValue);
					}
				}
			}]
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items: [{ 
			fieldLabel	: '어플리케이션',
			name		: 'APP_TYPE', 
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('aga361ukrAppTypeStore'),
			allowBlank	: false,
			listeners	: {
				specialkey: function(field, event){
					if(event.getKey() == event.ENTER){
						UniAppManager.app.onQueryButtonDown();
					}
				},
				
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('APP_TYPE', newValue);
				}
			}
		}]
	});

	
	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createTreeGrid('aga361ukrGrid', {
		store	: masterStore,
    	layout	: 'fit',
        region	: 'center',
    	maxDepth: 6,
    	features: [
    		{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
    		{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
    	],
    	uniOpt	: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: true,		
		    dblClickToEdit		: true,	
		    useGroupSummary		: false,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,
			copiedRow			: true, 	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
        columns	: [{
                xtype		: 'treecolumn', //this is so we know which column will show the tree
                text		: '분류',
                dataIndex	: 'NAME',
                width		: 300,
                sortable	: true,
                editable	: false 
        	},
			{dataIndex: 'parentId'			, width: 140		, hidden: true}, 				
			{dataIndex: 'COMP_CODE'			, width: 100		, hidden: true}, 				
			{dataIndex: 'LEVEL_CODE'		, width: 140}, 				
			{dataIndex: 'APP_TYPE'			, width: 120		, hidden: true}, 			
			{dataIndex: 'GUBUN_1'			, width: 100		, hidden: true}, 				
			{dataIndex: 'GUBUN_2'			, width: 100		, hidden: true}, 				
			{dataIndex: 'GUBUN_3'			, width: 100		, hidden: true}, 				
			{dataIndex: 'GUBUN_4'			, width: 100		, hidden: true}, 				
			{dataIndex: 'GUBUN_5'			, width: 100		, hidden: true}, 				
			{dataIndex: 'NAME'				, width: 200}, 				
			{dataIndex: 'REMARK_1'			, width: 200}, 				
			{dataIndex: 'REMARK_2'			, width: 200}, 				
			{dataIndex: 'REMARK_3'			, width: 200}, 				
			{dataIndex: 'INSERT_DB_USER'	, width: 100		, hidden: true}, 				
			{dataIndex: 'INSERT_DB_TIME'	, width: 100		, hidden: true}, 				
			{dataIndex: 'UPDATE_DB_USER'	, width: 100		, hidden: true}, 				
			{dataIndex: 'UPDATE_DB_TIME'	, width: 100		, hidden: true}, 				
			{dataIndex: 'TEMPC_01'			, width: 100		, hidden: true}, 				
			{dataIndex: 'TEMPC_02'			, width: 100		, hidden: true}, 				
			{dataIndex: 'TEMPC_03'			, width: 100		, hidden: true}, 				
			{dataIndex: 'TEMPN_01'			, width: 100		, hidden: true}, 				
			{dataIndex: 'TEMPN_02'			, width: 100		, hidden: true}, 				
			{dataIndex: 'TEMPN_03'			, width: 100		, hidden: true}
		] ,
        listeners: {
			beforeedit  : function( editor, e, eOpts ) { 
				if(e.record.data.parentId =='root')	{									
					return false;
				}
				if (e.record.phantom) {					//신규행이면 모두 수정 가능
					return true;
					
				} else {								//신규행이 아니면 비고만 수정 가능
	  				if (UniUtils.indexOf(e.field, ['REMARK_1', 'REMARK_2', 'REMARK_3'])){
	  					return true;
	  					
					}else{
					 	return false;
					}
				}
       		}
		}
    });    
    
    
	Unilite.Main( {
		id			: 'aga361ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
		panelSearch  	
		], 
		
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('save'		, false);
			UniAppManager.setToolbarButtons('reset'		, true);
			UniAppManager.setToolbarButtons('newData'	, true);
			
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('APP_TYPE');	
		},

		onQueryButtonDown : function()	{	
			if(!this.isValidSearchForm()){			//조회전 필수값 입력 여부 체크
				return false;
			}
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);
		},
		
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			this.fnInitBinding();
		},
		
		onNewDataButtonDown : function()	{        	 
			var selectNode	= masterGrid.getSelectionModel().getLastSelected();			
	        var newRecord	= masterGrid.createRow( );
	        if (newRecord)	{
				newRecord.set('APP_TYPE', selectNode.get('APP_TYPE'));
				newRecord.set('GUBUN_1'	, selectNode.get('GUBUN_1'));
				newRecord.set('GUBUN_2'	, selectNode.get('GUBUN_2'));
				newRecord.set('GUBUN_3'	, selectNode.get('GUBUN_3'));
				newRecord.set('GUBUN_4'	, selectNode.get('GUBUN_4'));
				newRecord.set('GUBUN_5'	, selectNode.get('GUBUN_5'));
	        }
		},

		onDeleteDataButtonDown : function()	{
			var delRecord = masterGrid.getSelectionModel().getLastSelected();
			
			if(delRecord.childNodes.length > 0)	{
				alert(Msg.sMB123);											//하위레벨부터 삭제하십시오.
				return false;
			}
			
			if(delRecord.phantom == true)	{				
				masterGrid.deleteSelectedRow();
				
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {			//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
					masterGrid.deleteSelectedRow();
			}
		},
		
		onSaveDataButtonDown: function () {
			masterStore.saveStore();
		}
	});
};
</script>
