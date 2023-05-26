<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ass700skr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120"  /> 								<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="A091" />						<!--처분구분-->  
	<t:ExtComboStore comboType="AU" comboCode="ZA14" /> 					<!--10품종-->
	<t:ExtComboStore comboType="AU" comboCode="A392" /> 					<!-- 처리구분-->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> 	<!--기관-->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('s_ass700skr_KOCISModel', {
	    fields: [
	   		{name: 'ASST'			 			,text: '자산코드' 			,type: 'string'},
	   		{name: 'ASST_NAME'		 			,text: '자산명' 			,type: 'string'},
	   		{name: 'ITEM_NM'		 			,text: '품명' 				,type: 'string'},
	   		{name: 'DEPT_CODE'		 			,text: '기관'	 			,type: 'string'},
	   		{name: 'DEPT_NAME'		 			,text: '기관'	 			,type: 'string'},
	   		{name: 'DRB_YEAR'		 			,text: '내용연수' 			,type: 'int'},
	   		{name: 'ACQ_DATE'		 			,text: '취득일자' 			,type: 'uniDate'},
	   		{name: 'ALTER_DATE'					,text: '처분일자' 			,type: 'uniDate'},
	   		{name: 'PROCESS_GUBUN'	 			,text: '처분구분' 			,type: 'string'		, comboType: "AU"	, comboCode: "A392"},
	   		{name: 'PROCESS_USER'	 			,text: '처분담당자id'		,type: 'string'		,  editable: false},
	   		{name: 'USER_NAME'	 				,text: '처분담당자'			,type: 'string'		,  editable: false},
	   		{name: 'ACQ_AMT_I'	 				,text: '취득가격' 			,type: 'uniPrice'}
		]
	});


	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('s_ass700skr_KOCISMasterStore1',{
		model: 's_ass700skr_KOCISModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,		// 수정 모드 사용 
        	deletable:false,		// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
			type: 'direct',
            api: {			
				read: 's_ass700skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
//		groupField: 'PROCESS_GUBUNNM',
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
//           		var viewNormal = masterGrid.normalGrid.getView();
//				var viewLocked = masterGrid.lockedGrid.getView();
//           		if(store.getCount() > 0){
//					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
//					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//				}else{
//					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
//					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
//				}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});


	
	/** 검색조건 (Search Panel)
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
		items		: [{	
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
           	layout		: {type: 'uniTable', columns: 1},
           	defaultType	: 'uniTextfield',
		    items		: [{ 
    			fieldLabel		: '처분일자',
		        xtype			: 'uniDateRangefield',
		        startFieldName	: 'ALTER_DATE_FR',
		        endFieldName	: 'ALTER_DATE_TO',
		        startDate		: UniDate.get('startOfMonth'),
		        endDate			: UniDate.get('today'),
		        allowBlank		: false,
		        width			: 470,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('ALTER_DATE_FR',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ALTER_DATE_TO',newValue);
			    	}
			    }
	        },{
    			fieldLabel	: '처분구분'	,
    			name		: 'PROCESS_GUBUN', 
    			xtype		: 'uniCombobox', 
    			comboType	: 'AU',
    			comboCode	: 'A392',
    			listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('PROCESS_GUBUN', newValue);
					}
				} 
    		},{
    			fieldLabel	: '10품종'	,
    			name		: 'ITEM_CD', 
    			xtype		: 'uniCombobox', 
    			comboType	: 'AU',
    			comboCode	: 'ZA14',
    			listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('ITEM_CD', newValue);
					}
				} 
    		},
			Unilite.popup('ASSET', {
				fieldLabel		: '자산코드', 
				valueFieldName	: 'ASSET_CODE', 
				textFieldName	: 'ASSET_NAME', 
				autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE', panelSearch.getValue('ASSET_CODE'));
							panelResult.setValue('ASSET_NAME', panelSearch.getValue('ASSET_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE', '');
						panelResult.setValue('ASSET_NAME', '');
					}
				}
			}),
			Unilite.popup('ASSET',{ 
				fieldLabel		: '~', 
				valueFieldName	: 'ASSET_CODE2', 
				textFieldName	: 'ASSET_NAME2', 
				popupWidth		: 710,
				autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE2', panelSearch.getValue('ASSET_CODE2'));
							panelResult.setValue('ASSET_NAME2', panelSearch.getValue('ASSET_NAME2'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE2', '');
						panelResult.setValue('ASSET_NAME2', '');
					}
				}
			})]
    	},{
			title		: '추가정보',
   			itemId		: 'search_panel2',
           	layout		: {type: 'uniTable', columns: 1},
           	defaultType	: 'uniTextfield',
		    items		: [{
				fieldLabel	: '기관',
				name		: 'DEPT_CODE', 
				xtype		: 'uniCombobox',
                store		: Ext.data.StoreManager.lookup('deptKocis')
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
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
    	hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 3	, tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'}},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
			fieldLabel		: '처분일자',
	        xtype			: 'uniDateRangefield',
	        startFieldName	: 'ALTER_DATE_FR',
	        endFieldName	: 'ALTER_DATE_TO',
	        startDate		: UniDate.get('startOfMonth'),
	        endDate			: UniDate.get('today'),
	        allowBlank		: false,
	        width			: 380,
			tdAttrs			: {width: 380},
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('ALTER_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('ALTER_DATE_TO',newValue);
		    	}
		    }
        },{
			fieldLabel	: '처분구분'	,
			name		: 'PROCESS_GUBUN', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'A392',
			tdAttrs		: {width: 380},
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {	
					panelSearch.setValue('PROCESS_GUBUN', newValue);
				}
			} 
		},{
			fieldLabel	: '10품종'	,
			name		: 'ITEM_CD', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'ZA14',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {	
					panelSearch.setValue('ITEM_CD', newValue);
				}
			} 
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:500,
			colspan:3,
			items :[
				Unilite.popup('ASSET', {
					fieldLabel: '자산코드', 
					valueFieldName: 'ASSET_CODE', 
					textFieldName: 'ASSET_NAME', 
					popupWidth: 710,
					validateBlank:false, 
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('ASSET_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('ASSET_NAME', newValue);				
						}
					}
				}),
				Unilite.popup('ASSET',{ 
					fieldLabel: '~', 
					valueFieldName: 'ASSET_CODE2', 
					textFieldName: 'ASSET_NAME2', 
					labelWidth:20,
					popupWidth: 710,
					validateBlank:false, 
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('ASSET_CODE2', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('ASSET_NAME2', newValue);				
						}
					}
				})]
	    	}/*.
			Unilite.popup('ASSET', {
				fieldLabel		: '자산코드', 
				valueFieldName	: 'ASSET_CODE', 
				textFieldName	: 'ASSET_NAME', 
				autoPopup		: true,
		        width			: 380,
				tdAttrs			: {width: 380},
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ASSET_CODE', panelResult.getValue('ASSET_CODE'));
							panelSearch.setValue('ASSET_NAME', panelResult.getValue('ASSET_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ASSET_CODE', '');
						panelSearch.setValue('ASSET_NAME', '');
					}
				}
			}),
			Unilite.popup('ASSET',{ 
				fieldLabel		: '~', 
				valueFieldName	: 'ASSET_CODE2', 
				textFieldName	: 'ASSET_NAME2', 
				autoPopup		: true,
				width			: 380,
				tdAttrs			: {width: 380},
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ASSET_CODE2', panelResult.getValue('ASSET_CODE2'));
							panelSearch.setValue('ASSET_NAME2', panelResult.getValue('ASSET_NAME2'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ASSET_CODE2', '');
						panelSearch.setValue('ASSET_NAME2', '');
					}
				}
			})*/
		],
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
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});	
	
	
	
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_ass700skr_KOCISGrid1', {
        region		: 'center',
    	store		: masterStore, 
        excelTitle	: '자산변동내역조회',
        uniOpt		: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
    		filter: {
				useFilter		: false,
				autoCreate		: false
			}
        },
    	features	: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
    	           		{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
        columns		:  [        
			{ dataIndex: 'ASST'				, width: 100},
			{ dataIndex: 'ASST_NAME'		, width: 120},
			{ dataIndex: 'ITEM_NM'			, width: 110},
			{ dataIndex: 'DEPT_CODE'		, width: 80			, hidden: true},
			{ dataIndex: 'DEPT_NAME'		, width: 110},
			{ dataIndex: 'DRB_YEAR'			, width: 100		, align: 'center'},
			{ dataIndex: 'ACQ_DATE'			, width: 100},
			{ dataIndex: 'ALTER_DATE'		, width: 100},
			{ dataIndex: 'PROCESS_GUBUN'	, width: 100},
			{ dataIndex: 'PROCESS_USER'		, width: 150		, hidden: true}, 
			{ dataIndex: 'USER_NAME'		, width: 150},
			{ dataIndex: 'ACQ_AMT_I'		, width: 150}
        ] 
    });   
	
    Unilite.Main( {
		id			: 's_ass700skr_KOCISApp',
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
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ALTER_DATE_FR');
			
//			var viewNormal = masterGrid.normalGrid.getView();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
//			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
//			
			this.setDefault();
		},
		
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
				
			}else{
				masterGrid.getStore().loadStoreRecords();
//				var viewLocked = masterGrid.lockedGrid.getView();
//				var viewNormal = masterGrid.normalGrid.getView();
//				console.log("viewLocked: ", viewLocked);
//				console.log("viewNormal: ", viewNormal);
//			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
//			    UniAppManager.setToolbarButtons('reset',true);
			}
		},
		
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();

			this.fnInitBinding();
		},
		
		setDefault: function() {
        	panelSearch.setValue('ALTER_DATE_FR', UniDate.get('startOfMonth'));
        	panelSearch.setValue('ALTER_DATE_TO', UniDate.get('today'));
        	panelSearch.setValue('DEPT_CODE'	, UserInfo.deptCode);
        	
        	panelResult.setValue('ALTER_DATE_FR', UniDate.get('startOfMonth'));
        	panelResult.setValue('ALTER_DATE_TO', UniDate.get('today'));
		
            if(!Ext.isEmpty(UserInfo.deptCode)){
				if(UserInfo.deptCode == '01') {
					panelSearch.getField('DEPT_CODE').setReadOnly(false);
					
				} else {
					panelSearch.getField('DEPT_CODE').setReadOnly(true);
				}			
				
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                //부서정보가 없을 경우, 조회버튼 비활성화
			    UniAppManager.setToolbarButtons('query',false);
            }
		},
		
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
};
</script>
