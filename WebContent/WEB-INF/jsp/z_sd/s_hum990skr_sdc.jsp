<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_hum990skr_sdc">
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
</t:appConfig>
<script type="text/javascript">

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hum990skr_sdcModel', {
		fields: [
			{name: 'COMP_CODE'		,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'	,type:'string'},
			{name: 'PERSON_NUMB'	,text:'<t:message code="system.label.human.personnumb" default="사번"/>'	,type:'string'},
			{name: 'NAME'			,text:'<t:message code="system.label.human.name" default="성명"/>'		,type:'string'},
			{name: 'POST_CODE'		,text:'<t:message code="system.label.human.postcode" default="직위"/>'	,type:'string'	,comboType:'AU'	,comboCode:'H005'}, 
			{name: 'POST_NAME'		,text:'<t:message code="system.label.human.postcode" default="직위"/>'	,type:'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('s_hum990skr_sdcMasterStore',{
		model: 's_hum990skr_sdcModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,		// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable:false,		// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'uniDirect',
			api: {
				read   : 's_hum990skr_sdcService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{
			title: '기본정보',   
			itemId: 'search_panel1',
			layout : {type : 'uniTable', columns : 1},
			items:[{
				fieldLabel: '기준년도',
				name: 'BASE_YYYY',
				xtype: 'uniTextfield',
				allowBlank: false,
				maxLength: 4,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BASE_YYYY', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
	    items: [{
			fieldLabel: '기준년도',
			name: 'BASE_YYYY',
			xtype: 'uniTextfield',
			allowBlank: false,
			maxLength: 4,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BASE_YYYY', newValue);
				}
			}
		}]
    });
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_hum990skr_sdcGrid', {
		region: 'center',
		layout: 'fit',
		uniOpt: {
			expandLastColumn: true,
			useRowNumberer: true,
			useMultipleSorting: true
		},
		selModel: 'rowmodel',
		store: directMasterStore,
		columns: [
			{dataIndex: 'COMP_CODE'		, width:  60	,hidden:true},
			{dataIndex: 'PERSON_NUMB'	, width: 100},
			{dataIndex: 'NAME'			, width: 100},
			{dataIndex: 'POST_CODE'		, width: 100	,hidden:true},
			{dataIndex: 'POST_NAME'		, width: 100}
		]
	});
	
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
	    ], 
		id  : 's_hum990skr_sdcApp',
		fnInitBinding : function() {
			panelSearch.setValue('BASE_YYYY', UniDate.get('today').substring(0, 4));
			panelResult.setValue('BASE_YYYY', UniDate.get('today').substring(0, 4));
			
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		}
	});
};

</script>
