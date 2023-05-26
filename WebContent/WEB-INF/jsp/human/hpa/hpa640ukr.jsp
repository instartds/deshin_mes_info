<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa640ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
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
	Unilite.defineModel('Hpa640ukrModel', {
		fields: [
			{name: 'FLAG'		 							, text: 'FLAG'				, type: 'string', editable:false},
			{name: 'DIV_CODE'						, text: '<t:message code="system.label.human.division" default="사업장"/>'				, type: 'string', comboCode: "BOR120", editable:false},
			{name: 'DEPT_CODE'						, text: '<t:message code="system.label.human.department" default="부서"/>'				, type: 'string', editable:false},
			{name: 'DEPT_NAME'					, text: '<t:message code="system.label.human.deptname" default="부서명"/>'				, type: 'string', editable:false},
			{name: 'POST_CODE'						, text: '<t:message code="system.label.human.postcode" default="직위"/>'				, type: 'string', comboType: "AU", comboCode: "H005", editable:false},
			{name: 'NAME'								, text: '<t:message code="system.label.human.name" default="성명"/>'				, type: 'string', editable:false},
			{name: 'PERSON_NUMB'				, text: '<t:message code="system.label.human.personnumb" default="사번"/>'				, type: 'string', editable:false},
			{name: 'DUTY_YYYY'						, text: '<t:message code="system.label.human.basisyear" default="기초년"/>'				, type: 'string', editable:false},
			{name: 'DUTY_YYYYMM'				, text: '<t:message code="system.label.human.basicyearmonth" default="기초년월"/>'				, type: 'string', editable:false},
			{name: 'YEAR_REST_NUM'			, text: '<t:message code="system.label.human.yearrestnums" default="사용하고남은년차수"/>'		, type: 'float', format:'0,000.00', decimalPrecision:2}
			//{name: 'MONTH_REST_NUM'		, text: '<t:message code="system.label.accnt.monthrestnum" default="사용하고남은월차수"/>'		, type: 'int', maxLength: 5}
		]
	});//End of Unilite.defineModel('Hpa640ukrModel', {
		
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {				
			read: 'hpa640ukrService.selectList',
			update: 'hpa640ukrService.updateDetail',
			destroy: 'hpa640ukrService.deleteDetail',
			syncAll: 'hpa640ukrService.saveAll'
		}
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hpa640ukrMasterStore1', {
		model: 'Hpa640ukrModel',
		uniOpt: {
			isMaster: true,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,		// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
	    saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect();					
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
        },
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		}

	});//End of var directMasterStore1 = Unilite.createStore('hpa640ukrMasterStore1', {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	 var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.human.basicyearmonth" default="기초년월"/>',
		        xtype: 'uniMonthfield',	
		    	name: 'DUTY_YYYYMM',
		    	allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DUTY_YYYYMM', newValue);
					}
				}
		    	
			},{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	value :'01',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
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
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			})]
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.human.basicyearmonth" default="기초년월"/>',
	        xtype: 'uniMonthfield',	
	    	name: 'DUTY_YYYYMM',
	    	allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DUTY_YYYYMM', newValue);
				}
			}
	    	
		},{
			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
        	name: 'DIV_CODE', 
        	xtype: 'uniCombobox', 
        	comboType:'BOR120',
        	value :'01',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
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
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true,
			listeners: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT',newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT_NAME',newValue);
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}
		})]	
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hpa640ukrGrid1', {
		layout: 'fit',
		region: 'center',
    	uniOpt: {
//		 	useRowNumberer: true
//		 	copiedRow: true
//		 	useContextMenu: true,
        },
		store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		columns: [ 
			{dataIndex: 'FLAG'		 				, width:  60, hidden: true},
			{dataIndex: 'DIV_CODE'					, width: 140, hidden: true},
			{dataIndex: 'DEPT_CODE'					, width: 140, hidden: true},
			{dataIndex: 'DEPT_NAME'					, width: 140},
			{dataIndex: 'POST_CODE'					, width: 140},
			{dataIndex: 'NAME'						, width: 140},
			{dataIndex: 'PERSON_NUMB'				, width: 140},
			{dataIndex: 'DUTY_YYYY'					, width: 140, hidden: true},
			{dataIndex: 'DUTY_YYYYMM'				, width: 140, hidden: true},
			{dataIndex: 'YEAR_REST_NUM'				, width: 140}
			//{dataIndex: 'MONTH_REST_NUM'			, width: 140}
		]
        ,
        listeners: {
          	beforeedit: function(editor, e) {
//          		console.log(e);
//          		if (e.field == 'YEAR_REST_NUM'||e.field == 'MONTH_REST_NUM') {
//          			return false;
//          		}
//			
//          		if (!e.record.phantom) {
//					//update					
//					if (e.field == 'YEAR_REST_NUM' || e.field == 'MONTH_REST_NUM') return false;
//				}
				var fieldName = e.field;
				if (fieldName == 'YEAR_REST_NUM' || fieldName == 'MONTH_REST_NUM') {
					if (e.record.data.FLAG == '') {
//							Ext.Msg.alert('확인', '년차가 생성자료가 존재합니다. 입력 불가능 합니다.');
//							e.record.set(fieldName, e.originalValue);
//							UniAppManager.setToolbarButtons('save', false);
							return false;
					}
				}
			} ,  edit: function(editor, e) {
				
				if (e.originalValue != e.value) {
//					UniAppManager.setToolbarButtons('save', true);
				} 
			},
				 selectionchange: function(grid, selNodes ){
//		             UniAppManager.setToolbarButtons('delete', true);
	             }
		        
          }
	});//End of var masterGrid = Unilite.createGrid('hpa640ukrGrid1', {   

	Unilite.Main( {
		border: false,
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
		id: 'hpa640ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DUTY_YYYYMM',UniDate.get('today'));
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);			
			panelResult.setValue('DUTY_YYYYMM',UniDate.get('today'));			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DUTY_YYYYMM');
			
		},
		onQueryButtonDown: function() {			
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onDeleteDataButtonDown : function()	{
			/* 	if(masterGrid.getStore().isDirty()) {
			masterGrid.getStore().saveStore();
			
		} */
		var selRow = masterGrid.getSelectionModel().getSelection()[0];
		if(selRow.get('FLAG') == 'N')	{
			masterGrid.deleteSelectedRow();
		}else if(confirm('<t:message code="system.message.human.message032" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
			masterGrid.deleteSelectedRow();
//				detailForm.clearForm();		//넣으면 폼 깨짐
		}
//		if(selRow.phantom === true)	{
//			masterGrid.deleteSelectedRow();
//		}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
//			if(selRow.data.FLAG == 'N') {
//				alert('년월차기초자료가 없습니다 삭제불가능합니다.');
//			}else{
//				masterGrid.deleteSelectedRow();
//			}
//		}
		// fnOrderAmtSum 호출(grid summary 이용)
		},
		onSaveDataButtonDown: function() {
			if(masterGrid.getStore().isDirty()) {
				masterGrid.getStore().saveStore();
				
			}
		},
		onDeleteAllButtonDown : function() {
			/* Ext.Msg.confirm('삭제', '전체행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					directMasterStore1.removeAll();
					
					masterGrid.getStore().sync({						
							success: function(response) {
 								masterGrid.getView().refresh();
				            },
				            failure: function(response) {
 								masterGrid.getView().refresh();
				            }
					});
				}
			}); */			
		}
	});//End of Unilite.Main( {
};


</script>
