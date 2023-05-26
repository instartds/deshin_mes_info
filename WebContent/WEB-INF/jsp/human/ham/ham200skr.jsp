<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham200skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ham200skr" /> 			<!-- 사업장 -->
	
	<t:ExtComboStore items="${COMBO_DEPTS2}" storeId="authDeptsStore" /> <!--권한부서-->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ham200skrModel', {
		fields: [ 
			{name: 'DIV_NAME'	,	text: '사업장'		, type: 'string'},
	    	{name: 'DEPT_NAME'	,	text: '부서'			, type: 'string'},
	    	{name: 'POST_NAME'	,	text: '직위'			, type: 'string'},
	    	{name: 'NAME'		,	text: '성명'			, type: 'string'},
	    	{name: 'PERSON_NUMB',	text: '사번'			, type: 'string'},
	    	{name: 'JOIN_DATE'	,	text: '입사일'		, type: 'uniDate'},
	    	{name: 'RETR_DATE'	,	text: '퇴사일'		, type: 'uniDate'},
	    	{name: 'ABIL_CODE'	,	text: '직책'			, type: 'string'},
	    	{name: 'JOB_CODE'	,	text: '담당업무'		, type: 'string'},
	    	{name: 'TELEPHON'	,	text: '전화번호'		, type: 'string'},
	    	{name: 'PHONE_NO'	,	text: '핸드폰'		, type: 'string'},
	    	{name: 'KOR_ADDR'	,	text: '주소'			, type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ham200skrMasterStore1', {
		model: 'Ham200skrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ham200skrService.selectList'                	
			}
		},
		loadStoreRecords: function(){
//			var param= Ext.getCmp('searchForm').getValues();			
			var param= Ext.getCmp('panelResultForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});	
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
//		var panelSearch = Unilite.createSearchPanel('searchForm', {		
//		title: '검색조건',		
//        defaultType: 'uniSearchSubPanel',
//        collapsed: UserInfo.appOption.collapseLeftSearch,
//        listeners: {
//	        collapse: function () {
//	        	panelResult.show();
//	        },
//	        expand: function() {
//	        	panelResult.hide();
//	        }
//	    },
//		items: [{	
//			title: '기본정보', 	
//			id: 'search_panel1',
//   			itemId: 'search_panel1',
//           	layout: {type: 'uniTable', columns: 1},
//           	defaultType: 'uniTextfield',
//			items: [{
//				fieldLabel: '사업장',
//				name:'DIV_CODE', 
//				xtype: 'uniCombobox',
//		        multiSelect: true, 
//		        typeAhead: false,
//		        comboType:'BOR120',
//				width: 325,
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {						
//						panelResult.setValue('DIV_CODE', newValue);
//					}
//				}
//			},
////			Unilite.treePopup('DEPTTREE',{
////				fieldLabel: '부서',
////				valueFieldName:'DEPT',
////				textFieldName:'DEPT_NAME' ,
////				valuesName:'DEPTS' ,
////				DBvalueFieldName:'TREE_CODE',
////				DBtextFieldName:'TREE_NAME',
////				selectChildren:true,
////				textFieldWidth:89,
////				validateBlank:true,
////				width:300,
////				autoPopup:true,
////				useLike:true,
////				listeners: {
////	                'onValueFieldChange': function(field, newValue, oldValue  ){
////	                    	panelResult.setValue('DEPT',newValue);
////	                },
////	                'onTextFieldChange':  function( field, newValue, oldValue  ){
////	                    	panelResult.setValue('DEPT_NAME',newValue);
////	                },
////	                'onValuesChange':  function( field, records){
////	                    	var tagfield = panelResult.getField('DEPTS') ;
////	                    	tagfield.setStoreData(records)
////	                }
////				}
////			}),
//			{
//                fieldLabel: '부서',
//                name: 'DEPTS2',
//                xtype: 'uniCombobox',
//                width:300,
//                multiSelect: true,
//                store:  Ext.data.StoreManager.lookup('authDeptsStore'),
//                disabled:true,
//                hidden:true,
//                allowBlank:false,
//                listeners: {
//                    'onValueFieldChange': function(field, newValue, oldValue  ){
//                            panelResult.setValue('DEPT',newValue);
//                    },
//                    'onTextFieldChange':  function( field, newValue, oldValue  ){
//                            panelResult.setValue('DEPT_NAME',newValue);
//                    },
//                    'onValuesChange':  function( field, records){
//                            var tagfield = panelResult.getField('DEPTS') ;
//                            tagfield.setStoreData(records)
//                    }
//                }
//                
//            },
//            Unilite.treePopup('DEPTTREE',{
//                itemId : 'deptstree',
//                fieldLabel: '부서',
//                valueFieldName:'DEPT',
//                textFieldName:'DEPT_NAME' ,
//                valuesName:'DEPTS' ,
//                DBvalueFieldName:'TREE_CODE',
//                DBtextFieldName:'TREE_NAME',
//                selectChildren:true,
//                textFieldWidth:89,
//                validateBlank:true,
//                width:300,
//                autoPopup:true,
//                useLike:true
//            }),	
//					
//						
//            {
//				fieldLabel: '기준일',
//				name: 'DATE',
//				xtype: 'uniDatefield',
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {						
//						panelResult.setValue('DATE', newValue);
//					}
//				}
//			}]
//	            			            			 
//		}]	
//	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	var panelResult = Unilite.createSimpleForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
//						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},
//        	Unilite.treePopup('DEPTTREE',{
//				fieldLabel: '부서',
//				valueFieldName:'DEPT',
//				textFieldName:'DEPT_NAME' ,
//				valuesName:'DEPTS' ,
//				DBvalueFieldName:'TREE_CODE',
//				DBtextFieldName:'TREE_NAME',
//				selectChildren:true,
//				textFieldWidth:89,
//				validateBlank:true,
//				width:300,
//				autoPopup:true,
//				useLike:true,
//				colspan:2,
//				listeners: {
//	                'onValueFieldChange': function(field, newValue, oldValue  ){
//	                    	panelSearch.setValue('DEPT',newValue);
//	                },
//	                'onTextFieldChange':  function( field, newValue, oldValue  ){
//	                    	panelSearch.setValue('DEPT_NAME',newValue);
//	                },
//	                'onValuesChange':  function( field, records){
//	                    	var tagfield = panelSearch.getField('DEPTS') ;
//	                    	tagfield.setStoreData(records)
//	                }
//				}
//			}),
			{
                fieldLabel: '부서',
                name: 'DEPTS2',
                xtype: 'uniCombobox',
                width:300,
                multiSelect: true,
                store:  Ext.data.StoreManager.lookup('authDeptsStore'),
                disabled:true,
                hidden:true,
                allowBlank:false
                
            },
            Unilite.treePopup('DEPTTREE',{
                itemId : 'deptstree',
                fieldLabel: '부서',
                valueFieldName:'DEPT',
                textFieldName:'DEPT_NAME' ,
                valuesName:'DEPTS' ,
                DBvalueFieldName:'TREE_CODE',
                DBtextFieldName:'TREE_NAME',
                selectChildren:true,
                textFieldWidth:89,
                validateBlank:true,
                width:300,
                autoPopup:true,
                useLike:true
                
            }), 	
					
			{
			fieldLabel: '기준일',
			name: 'DATE',
			xtype: 'uniDatefield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
//					panelSearch.setValue('DATE', newValue);
				}
			}
		}]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('ham200skrGrid1', {
    	// for tab    	
		layout: 'fit',
		region:'center',
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: false,			
			onLoadSelectFirst	: true,
			useMultipleSorting	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
    	features: [{
			id: 'masterGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'masterGridTotal',		
			ftype: 'uniSummary',			
			showSummaryRow: false
			}
    	],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'DIV_NAME'		, width: 133}, 				
			{dataIndex: 'DEPT_NAME'		, width: 160},
			{dataIndex: 'POST_NAME'		, width: 88 },
			{dataIndex: 'NAME'			, width: 100},
			{dataIndex: 'PERSON_NUMB'	, width: 88},
			{dataIndex: 'JOIN_DATE'		, width: 100},
			{dataIndex: 'RETR_DATE'		, width: 100},
			{dataIndex: 'ABIL_CODE'		, width: 88},
			{dataIndex: 'JOB_CODE'		, width: 100},
			{dataIndex: 'TELEPHON'		, width: 100},
			{dataIndex: 'PHONE_NO'		, width: 100},
			{dataIndex: 'KOR_ADDR'		, width: 400}
		] 
	});//End of var masterGrid = Unilite.createGrid('ham200skrGrid1', {   

	Unilite.Main({
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            	masterGrid, panelResult
	     	]
	     }
//	         panelSearch
	    ], 
		id: 'ham200skrApp',
		fnInitBinding: function() {
//			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
//			panelSearch.setValue('DATE',UniDate.get('today'));
			panelResult.setValue('DATE',UniDate.get('today'));
			
			
//			var activeSForm ;
//			if(!UserInfo.appOption.collapseLeftSearch)	{
//				activeSForm = panelSearch;
//			}else {
//				activeSForm = panelResult;
//			}
//			activeSForm.onLoadSelectText('DIV_CODE');
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
//			UniHuman.deptAuth(UserInfo.deptAuthYn, panelSearch, "deptstree", "DEPTS2");
			UniHuman.deptAuth(UserInfo.deptAuthYn, panelResult, "deptstree", "DEPTS2");
			
			
		},
		onQueryButtonDown: function() {			
			
			if(!this.isValidSearchForm()){
                return false;
            }
						
			masterGrid.getStore().loadStoreRecords();
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}/*,
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			
			this.fnInitBinding();
		}*/
	});//End of Unilite.Main( {
};


</script>
