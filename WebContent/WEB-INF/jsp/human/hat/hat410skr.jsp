<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat410skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!--근무조-->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!--직위-->
	<t:ExtComboStore items="${COMBO_DEPT_LIST}" storeId="deptList" /><!--부서-->	
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
	Unilite.defineModel('Hat410skrModel', {
	    fields: [
			{name: 'DUTY_YYYYMMDD'			, text: '<t:message code="system.label.human.dutyyyymmdd" default="근무일"/>'		, type: 'uniDate'},
			{name: 'WORK_TEAM'					, text: '<t:message code="system.label.human.workteam" default="근무조"/>'		, type: 'string'	,comboType: 'AU'	,comboCode: 'H004'},
			{name: 'DIV_CODE'						, text: '<t:message code="system.label.human.division" default="사업장"/>'		, type: 'string'	,comboType: 'BOR120'},
			{name: 'DEPT_NAME'					, text: '<t:message code="system.label.human.department" default="부서"/>'		, type: 'string'},
			{name: 'POST_CODE'						, text: '<t:message code="system.label.human.postcode" default="직위"/>'		, type: 'string'	,comboType: 'AU',	comboCode: 'H005'},
			{name: 'NAME'								, text: '<t:message code="system.label.human.name" default="성명"/>'		, type: 'string'},
			{name: 'PERSON_NUMB'				, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, type: 'string'}
	    ] 
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hat410skrMasterStore1',{
		model: 'Hat410skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hat410skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var detailform = panelSearch.getForm();
        	
        	if (detailform.isValid()) {
        		var param = detailform.getValues();			
    			console.log( param );
    			this.load({
    				params : param
    			});
        	}else{
        		var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				    	
				if(invalid.length > 0)	{
					r = false;
					var labelText = ''
					    	
					if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					
					Ext.Msg.alert('확인', labelText+Msg.sMB083);
					invalid.items[0].focus();
				}
        	}
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
	        	fieldLabel: '<t:message code="system.label.human.workprod" default="근무기간"/>',
				xtype: 'uniDateRangefield',  
				startFieldName: 'DUTY_YYYYMMDD_FROM',
				startDate: UniDate.get('today'),
				endFieldName: 'DUTY_YYYYMMDD_TO',
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank:false,                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('DUTY_YYYYMMDD_FROM', newValue);						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DUTY_YYYYMMDD_TO', newValue);				    		
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.human.workteam" default="근무조"/>',  
				name: 'WORK_TEAM', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'H004',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_TEAM', newValue);
					}
				}
	        },{ 
	        	fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
	        	name: 'DIV_CODE',
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
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
			}),			
		     	Unilite.popup('Employee',{ 
				
				validateBlank: false,
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
//					}
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					},
                    onClear: function(type) {
                        panelSearch.setValue('PERSON_NUMB', '');
                        panelSearch.setValue('NAME', '');
                        panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
                    }
				}
			})/*,{
	        	fieldLabel: '부서',
	        	name: 'TEST_DEPT',
	        	xtype:'uniCombobox',
	        	store: Ext.data.StoreManager.lookup('deptList'),
	        	width: 325,
	        	multiSelect: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TEST_DEPT', newValue);
					}
				}
	        }*/]				
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
        	fieldLabel: '<t:message code="system.label.human.workprod" default="근무기간"/>',
			xtype: 'uniDateRangefield',  
			startFieldName: 'DUTY_YYYYMMDD_FROM',
			startDate: UniDate.get('today'),
			endFieldName: 'DUTY_YYYYMMDD_TO',
			endDate: UniDate.get('today'),
			width: 315,
			allowBlank:false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DUTY_YYYYMMDD_FROM', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DUTY_YYYYMMDD_TO', newValue);				    		
		    	}
		    }
		},{
			fieldLabel: '<t:message code="system.label.human.workteam" default="근무조"/>',  
			name: 'WORK_TEAM', 
			xtype: 'uniCombobox', 
			comboType: 'AU', 
			comboCode: 'H004',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_TEAM', newValue);
				}
			}
        },{ 
        	fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
        	name: 'DIV_CODE',
        	xtype: 'uniCombobox', 
        	comboType:'BOR120',
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
		}),			
	     	Unilite.popup('Employee',{ 
			
			validateBlank: false,
			listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
//						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
//                	},
//					scope: this
//				},
//				onClear: function(type)	{
//					panelSearch.setValue('PERSON_NUMB', '');
//					panelSearch.setValue('NAME', '');
//				}
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				},
                onClear: function(type) {
                	panelSearch.setValue('PERSON_NUMB', '');
                    panelSearch.setValue('NAME', '');
                    panelResult.setValue('PERSON_NUMB', '');
                    panelResult.setValue('NAME', '');
                }
			}
		})/*,{
        	fieldLabel: '부서',
        	name: 'TEST_DEPT',
        	xtype:'uniCombobox',
        	store: Ext.data.StoreManager.lookup('deptList'),
        	width: 325,
        	multiSelect: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TEST_DEPT', newValue);
				}
			}
        }*/]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('hat410skrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
           			{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		store: directMasterStore,
        columns: [
        	{dataIndex: 'DUTY_YYYYMMDD'	 	, width: 100},
        	{dataIndex: 'WORK_TEAM'		 	, width: 120},
        	{dataIndex: 'DIV_CODE'			, width: 146},
        	{dataIndex: 'DEPT_NAME'		 	, width: 180},
        	{dataIndex: 'POST_CODE'			, width: 146},
        	{dataIndex: 'NAME'			 	, width: 120},
        	{dataIndex: 'PERSON_NUMB'	 	, minWidth: 100, flex: 1}
		]    
    });                          
    
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
		id : 'hat410skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DUTY_YYYYMMDD_FROM');
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		}
	});
};


</script>
