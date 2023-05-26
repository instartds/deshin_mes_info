<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm300ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B075" /> <!-- 시/도 구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bcm300ukrvService.selectList',
			update: 'bcm300ukrvService.updateDetail',
			create: 'bcm300ukrvService.insertDetail',
			destroy: 'bcm300ukrvService.deleteDetail',
			syncAll: 'bcm300ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('bcm300ukrvModel', {
	    fields: [  	  
	    	{name: 'ZIP_CODE'					,text: '우편번호'				,type: 'string'},
		    {name: 'ZIP_CODE1_NAME'				,text: '시/도명'				,type: 'string'},
		    {name: 'ZIP_CODE2_NAME'				,text: '시/군/구명'				,type: 'string'},
		    {name: 'ZIP_CODE3_NAME'				,text: '읍/면/동/건물명'		,type: 'string'},
		    {name: 'ZIP_CODE4_NAME'				,text: '번지/아파트동.호수'		,type: 'string'},
		    {name: 'ZIP_CODE5_NAME'				,text: '상세주소'				,type: 'string'},
		    {name: 'ZIP_CODE6_NAME'				,text: '상세주소'				,type: 'string'},
		    {name: 'ZIP_NAME'					,text: '지명'					,type: 'string'},
		    {name: 'ZIP_CODE1'					,text: '대도시코드'				,type: 'string'},
		    {name: 'ZIP_CODE2'					,text: '시군구코드'				,type: 'string'},
		    {name: 'ZIP_CODE3'					,text: '읍면동코드'				,type: 'string'} 
		]
	}); //End of Unilite.defineModel('bcm300ukrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bcm300ukrvMasterStore1',{
		model: 'bcm300ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true	,		// 수정 모드 사용 
            deletable: true,		// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();	
			if(panelSearch.isValid())	{
				param.ZIP_CODE1_NAME = panelSearch.getField('ZIP_CODE1_NAME').getRawValue();
				console.log( param );
				this.load({
					params : param
				});
			}
		},
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect();
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	        	fieldLabel: '시/도 구분',
	        	name: 'ZIP_CODE1_NAME', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'AU',
	        	comboCode:'B075',
	        	allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ZIP_CODE1_NAME', newValue);
					}
				}
	        },{
				fieldLabel: '우편번호',
				name:'ZIP_CODE',	
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ZIP_CODE', newValue);
					}
				}
			},{
				fieldLabel: '주소',
				name:'ZIP_NAME',	
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ZIP_NAME', newValue);
					}
				}
			}]
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   	   			if(invalid.length > 0) {
					r=false;
	  				var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   				}
			   		Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();		    
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
        	fieldLabel: '시/도 구분',
        	name: 'ZIP_CODE1_NAME', 
        	xtype: 'uniCombobox', 
        	comboType: 'AU',
        	comboCode:'B075',
        	allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ZIP_CODE1_NAME', newValue);
				}
			}
        },{
			fieldLabel: '우편번호',
			name:'ZIP_CODE',	
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ZIP_CODE', newValue);
				}
			}
		},{
			fieldLabel: '주소',
			name:'ZIP_NAME',	
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ZIP_NAME', newValue);
				}
			}
		}]	,
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   	   			if(invalid.length > 0) {
					r=false;
	  				var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   				}
			   		Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();		    
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('bcm300ukrvGrid1', {
    	layout : 'fit',
    	region:'center',
        uniOpt: {
    		useLiveSearch: true,
			useMultipleSorting: true,
			expandLastColumn: false,
			state: {
				useState: false,   //그리드 설정 (우측)버튼 사용 여부
				useStateList: false  //그리드 설정 (죄측)목록 사용 여부
			}
        },
    	store: directMasterStore,
        columns: [        			 
			{dataIndex: 'ZIP_CODE'				, width: 70,
			renderer : function(val,metaDate,record,rowIndex,colIndex,store,view){
                if (val) {
                
                	return val.substring(0,3) + '-' + val.substring(3,6);
                }
            }},
			{dataIndex: 'ZIP_CODE1_NAME'		, width: 106 ,hidden: true},
			{dataIndex: 'ZIP_CODE2_NAME'		, width: 120}, 
			{dataIndex: 'ZIP_CODE3_NAME'		, width: 133},
			{dataIndex: 'ZIP_CODE4_NAME'		, width: 266},
			{dataIndex: 'ZIP_CODE5_NAME'		, width: 133}, 
			{dataIndex: 'ZIP_CODE6_NAME'		, width: 500},
			{dataIndex: 'ZIP_NAME'				, width: 233 ,hidden: true},
			{dataIndex: 'ZIP_CODE1'				, width: 100 ,hidden: true}, 
			{dataIndex: 'ZIP_CODE2'				, width: 100 ,hidden: true},
			{dataIndex: 'ZIP_CODE3'				, width: 100 ,hidden: true}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(e.record.phantom){
					if (UniUtils.indexOf(e.field, 
							['ZIP_CODE','ZIP_CODE2_NAME','ZIP_CODE3_NAME','ZIP_CODE4_NAME','ZIP_CODE5_NAME','ZIP_CODE6_NAME']))
							{	
								return true;
							}else{
								return false;
							}					
				}else{
					if(UniUtils.indexOf(e.field, ['ZIP_CODE2_NAME','ZIP_CODE3_NAME','ZIP_CODE4_NAME','ZIP_CODE5_NAME','ZIP_CODE6_NAME']))
						{	
							return true;
						}else{
							return false;
						}
				}
			}
		}
    });	//End of   var masterGrid = Unilite.createGrid('bcm300ukrvGrid1', {

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
		id: 'bcm300ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('newData','reset',true);
		},
		onQueryButtonDown : function() {	
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore.loadStoreRecords();	
		},
		onNewDataButtonDown: function()	{
				var zipCode1Name = panelSearch.getField('ZIP_CODE1_NAME').getRawValue();
            	 var r = {
            	 	ZIP_CODE1_NAME:	zipCode1Name
		        };
				masterGrid.createRow(r);
				
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore(config);
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
//				if(selRow.get('ITEM_CODE') > 1)
//				{
//					Unilite.messageBox('<t:message code="unilite.msg.sMM435"/>');
//				}else{
					masterGrid.deleteSelectedRow();
//				}
			}
		}
	}); //End of Unilite.Main( {
};

</script>
