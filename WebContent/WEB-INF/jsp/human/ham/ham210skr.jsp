<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham210skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
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
	//1: 부서별
	Unilite.defineModel('Ham210skrModel1', {
		fields: [
			{name: 'DIV_CODE'	,	text: '사업장'		, type: 'string', comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'	,	text: '부서'			, type: 'string'},
	    	{name: 'JOB_NAME'	,	text: '직종'			, type: 'string'},
	    	{name: 'POST_NAME'	,	text: '직위'			, type: 'string'},
	    	{name: 'ABIL_NAME'	,	text: '직책'			, type: 'string'},
	    	{name: 'NAME'		,	text: '성명'			, type: 'string'},
	    	{name: 'PERSON_NUMB',	text: '사번'			, type: 'string'},
	    	{name: 'SEX_CODE'	,	text: '성별'			, type: 'string'},
	    	{name: 'AGE'		,	text: '나이'			, type: 'int'},
	    	{name: 'JOIN_DATE'	,	text: '입사일'		, type: 'uniDate'},
	    	{name: 'RETR_DATE'	,	text: '퇴사일'		, type: 'uniDate'},    	
	    	{name: 'TELEPHON'	,	text: '전화번호'		, type: 'string'},
	    	{name: 'PHONE_NO'	,	text: '핸드폰'		, type: 'string'},
	    	{name: 'KOR_ADDR'	,	text: '주소'			, type: 'string'}
		]
	});
	
	//2: 직종별
	Unilite.defineModel('Ham210skrModel2', {
		fields: [
			{name: 'DIV_CODE'	,	text: '사업장'		, type: 'string', comboType: 'BOR120'},
			{name: 'JOB_NAME'	,	text: '직종'			, type: 'string'},
	    	{name: 'DEPT_NAME'	,	text: '부서'			, type: 'string'},
	    	{name: 'POST_NAME'	,	text: '직위'			, type: 'string'},
	    	{name: 'ABIL_NAME'	,	text: '직책'			, type: 'string'},
	    	{name: 'NAME'		,	text: '성명'			, type: 'string'},
	    	{name: 'PERSON_NUMB',	text: '사번'			, type: 'string'},
	    	{name: 'SEX_CODE'	,	text: '성별'			, type: 'string'},
	    	{name: 'AGE'		,	text: '나이'			, type: 'int'},
	    	{name: 'JOIN_DATE'	,	text: '입사일'		, type: 'uniDate'},
	    	{name: 'RETR_DATE'	,	text: '퇴사일'		, type: 'uniDate'},
	    	{name: 'TELEPHON'	,	text: '전화번호'		, type: 'string'},
	    	{name: 'PHONE_NO'	,	text: '핸드폰'		, type: 'string'},
	    	{name: 'KOR_ADDR'	,	text: '주소'			, type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ham210skrMasterStore1', {
		model: 'Ham210skrModel1',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ham210skrService.selectList1'                	
			}
		},
		loadStoreRecords: function(){
//			var param= Ext.getCmp('searchForm').getValues();			
			var param= Ext.getCmp('panelResultForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});	
		},
		groupField: 'DEPT_NAME'
	});
	
	var directMasterStore2 = Unilite.createStore('ham210skrMasterStore2', {
		model: 'Ham210skrModel2',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ham210skrService.selectList2'                	
			}
		},
		loadStoreRecords: function(){
//			var param= Ext.getCmp('searchForm').getValues();			
			var param= Ext.getCmp('panelResultForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});	
		},
		groupField: 'JOB_NAME'
	});

	
	var panelResult = Unilite.createSimpleForm('panelResultForm', {
    	//hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		//panelSearch.setValue('DIV_CODE', newValue);
			    	}
	     		}
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
//				textFieldWidth:89,
				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	//panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	//panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
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
	var masterGrid1 = Unilite.createGrid('ham210skrGrid1', {
    	store: directMasterStore1,
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
		columns: [
			{dataIndex: 'DIV_CODE'		, width: 133}, 				
			{dataIndex: 'DEPT_NAME'		, width: 160},
			{dataIndex: 'JOB_NAME'		, width: 100},
			{dataIndex: 'POST_NAME'		, width: 88 },
			{dataIndex: 'ABIL_NAME'		, width: 88},
			{dataIndex: 'NAME'			, width: 100},
			{dataIndex: 'PERSON_NUMB'	, width: 88},
			{dataIndex: 'SEX_CODE'		, width: 88, align :'center'},
			{dataIndex: 'AGE'			, width: 88, align :'center'},
			{dataIndex: 'JOIN_DATE'		, width: 100},
			{dataIndex: 'RETR_DATE'		, width: 100},
			{dataIndex: 'TELEPHON'		, width: 100},
			{dataIndex: 'PHONE_NO'		, width: 100},
			{dataIndex: 'KOR_ADDR'		, width: 400}
		] 
	});
	
	var masterGrid2 = Unilite.createGrid('ham210skrGrid2', {
    	store: directMasterStore2,
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
		columns: [
			{dataIndex: 'DIV_CODE'		, width: 133},
			{dataIndex: 'JOB_NAME'		, width: 100},
			{dataIndex: 'DEPT_NAME'		, width: 160},
			{dataIndex: 'POST_NAME'		, width: 88 },
			{dataIndex: 'ABIL_NAME'		, width: 88},
			{dataIndex: 'NAME'			, width: 100},
			{dataIndex: 'PERSON_NUMB'	, width: 88},
			{dataIndex: 'SEX_CODE'		, width: 88, align :'center'},
			{dataIndex: 'AGE'			, width: 88, align :'center'},
			{dataIndex: 'JOIN_DATE'		, width: 100},
			{dataIndex: 'RETR_DATE'		, width: 100},
			{dataIndex: 'TELEPHON'		, width: 100},
			{dataIndex: 'PHONE_NO'		, width: 100},
			{dataIndex: 'KOR_ADDR'		, width: 400}
		] 
	});
	
	var tab = Unilite.createTabPanel('ham210skrTab',{		
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '부서별',
				xtype	: 'container',
				itemId	: 'ham210skrTab1',
				layout	: {type:'vbox', align:'stretch'},
				items	: [
					masterGrid1
				]
			},{
				title	: '직종별',
				xtype	: 'container',
				itemId	: 'ham210skrTab2',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard.getItemId() == 'ham210skrTab1')	{
					directMasterStore1.loadStoreRecords();
				}else if(newCard.getItemId() == 'ham210skrTab2') {
                    directMasterStore2.loadStoreRecords();
                }
			}
		}
	})

	Unilite.Main({
		id: 'ham210skrApp',
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            	tab, panelResult
	     	]}
	    ], 
		
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DATE',UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			//UniHuman.deptAuth(UserInfo.deptAuthYn, panelResult, "deptstree", "DEPTS2");
			
			
		},
		onQueryButtonDown: function() {			
			
			var activeTabId = tab.getActiveTab().getItemId();
            if(activeTabId == 'ham210skrTab1'){
            	directMasterStore1.loadStoreRecords();
//                masterGrid.getStore().loadStoreRecords();
//                masterGrid2.reset();
            }else if(activeTabId == 'ham210skrTab2'){
            	directMasterStore2.loadStoreRecords();
//                adjustGrid.getStore().loadStoreRecords();
            }
//			if(!this.isValidSearchForm()){
//                return false;
//            }
//						
//			masterGrid1.getStore().loadStoreRecords();
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
