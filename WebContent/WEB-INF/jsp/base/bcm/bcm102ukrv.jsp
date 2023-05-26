<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm102ukrv" >
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

	Unilite.defineModel('Bcm102ukrvModel', {
	    fields: [
	    	{name: 'CHOICE'        			, text: '선택'		, type: 'string'},
	    	{name: 'SEQ'           			, text: '<t:message code="system.label.base.seq" default="순번"/>'		, type: 'string'},
	    	{name: 'COMP_CODE'     			, text: 'COMP_CODE'	, type: 'string'},
	    	{name: 'DOC_ID'        			, text: 'DOC_ID'	, type: 'string'},
	    	{name: 'CUSTOM_NAME'   			, text: '회사명'		, type: 'string'},
	    	{name: 'COMP_PRSN'     			, text: '담당자'		, type: 'string'},
	    	{name: 'M_DATE'					, text: '일자'		, type: 'uniDate'},
	    	{name: 'M_DESC'					, text: '내용'		, type: 'string'},
	    	{name: 'REMARK'					, text: '<t:message code="system.label.base.remarks" default="비고"/>'		, type: 'string'},
	    	{name: 'CUSTOM_CODE'			, text: '거래처코드'	, type: 'string'},
	    	{name: 'COMPANY_NAME'			, text: '거래처'		, type: 'string'},
	    	{name: 'INSERT_DB_USER'			, text: '등록자'		, type: 'string'},
	    	{name: 'INSERT_DB_TIME'			, text: '등록일'		, type: 'uniDate'}
	    ]
	});//End of Unilite.defineModel('Bcm102ukrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bcm102ukrvMasterStore1', {
		model: 'Bcm102ukrvModel',
		uniOpt: {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'bcm102ukrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
				
		},
		groupField: ''
			
	});//End of var directMasterStore1 = Unilite.createStore('bcm102ukrvMasterStore1', {
	
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
           	defaultType: 'uniTextfield',
			items: [
				{					
	    			fieldLabel: '회사명',
	    			name:'',
	    			xtype: 'uniTextfield'
	    		},{					
	    			fieldLabel: '담당자',
	    			name:'',
	    			xtype: 'uniTextfield'
	    		},{					
	    			fieldLabel: '내용',
	    			name:'',
	    			xtype: 'uniTextfield'
	    		},
	    			Unilite.popup('CUST',{
						fieldLabel: '거래처', 
						textFieldWidth: 70
					}),
					Unilite.popup('CUST',{
						fieldLabel: '거래처', 
						textFieldWidth: 70,
						allowBlank:false
					})
		]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('bcm102ukrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		uniOpt: {
			expandLastColumn: true
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
    	store: directMasterStore1,
        columns: [
        	{dataIndex: 'CHOICE'        				, width: 40},
        	{dataIndex: 'SEQ'           				, width: 53},
        	{dataIndex: 'COMP_CODE'     				, width: 120,hidden:true},
        	{dataIndex: 'DOC_ID'        				, width: 100,hidden:true},
        	{dataIndex: 'CUSTOM_NAME'   				, width: 166},
        	{dataIndex: 'COMP_PRSN'     				, width: 100},
        	{dataIndex: 'M_DATE'						, width: 100},
        	{dataIndex: 'M_DESC'						, width: 266},
        	{dataIndex: 'REMARK'						, width: 466},
        	{dataIndex: 'CUSTOM_CODE'					, width: 86},
        	{dataIndex: 'COMPANY_NAME'					, width: 133},
        	{dataIndex: 'INSERT_DB_USER'				, width: 100},
        	{dataIndex: 'INSERT_DB_TIME'				, width: 100}
		] 
    });//End of var masterGrid = Unilite.createGrid('bcm102ukrvGrid1', {  
	
	Unilite.Main( {
		borderItems:[ 
	 		 masterGrid,
			panelSearch
		],  	
		id: 'bcm102ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function() {			
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
