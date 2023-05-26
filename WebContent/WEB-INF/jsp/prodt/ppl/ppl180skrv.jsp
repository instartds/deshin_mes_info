<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl180skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 		<!-- 사업장 -->       
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
	Unilite.defineModel('Ppl180skrvModel', {
	    fields: [
	    	{name: 'GUBUN'	, text: '<t:message code="system.label.product.classfication" default="구분"/>'	, type: 'string'},
	    	{name: 'MON'	, text: '월요일'	, type: 'string'},
	    	{name: 'TUE'  	, text: '화요일'	, type: 'string'},
	    	{name: 'WED'  	, text: '수요일'	, type: 'string'},
	    	{name: 'THU'  	, text: '목요일'	, type: 'string'},
	    	{name: 'FRI'  	, text: '금요일'	, type: 'string'},
	    	{name: 'SAT'  	, text: '<font color="blue">토요일</font>'		, type: 'string'},
	    	{name: 'SUN'  	, text: '<font color="red">일요일</font>'		, type: 'string'},
	    	{name: 'WIN'  	, text: '주별합계'	, type: 'string'}
	    ]
	});		// End of Unilite.defineModel('Ppl180skrvModel', {
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('ppl180skrvMasterStore',{
			model: 'Ppl180skrvModel',
			uniOpt: {
            	isMaster:	true,			// 상위 버튼 연결 
            	editable:	false,			// 수정 모드 사용 
            	deletable:	false,			// 삭제 가능 여부 
	            useNavi:	false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ppl180skrvService.selectList'                	
                }
            },
            loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});			
			}
//			groupField: 'ITEM_NAME'		
	});		//End of var directMasterStore1 = Unilite.createStore('ppl180skrvMasterStore1',{
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		    	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		    	name: 'DIV_CODE', 
		    	xtype: 'uniCombobox',
		    	comboType: 'BOR120',
		    	allowBlank: false,
		    	value: UserInfo.divCode,
		    	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
		    },{
		    	fieldLabel: '<t:message code="system.label.product.basismonth" default="기준월"/>',
		    	xtype: 'uniMonthfield',
		    	name: 'FR_DATE',
		    	value: UniDate.get('today'),
		    	allowBlank:false,
		    	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('FR_DATE', newValue);
						}
					}
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					valueFieldName:'ITEM_CODE',
					textFieldName:'ITEM_NAME',
					validateBlank: false,
					textFieldWidth:170, 
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				})
			]},{
				title:'<t:message code="system.label.product.reference2" default="참고사항"/>',
   				id: 'search_panel2',
				itemId:'search_panel2',
        		defaultType: 'uniTextfield',
        		layout : {type : 'uniTable', columns : 1},
        		defaultType: 'uniTextfield',
        		
        		items:[{
				 	fieldLabel: '총계획량',
				 	xtype: 'uniTextfield',
				 	name: '',
				 	readOnly: true
				},{
				 	fieldLabel: '총지시량',
				 	xtype: 'uniTextfield',
				 	name: '',
				 	readOnly: true	
				},{
				 	fieldLabel: '총실적량',
				 	xtype: 'uniTextfield',
				 	name: '',
				 	readOnly: true	
				},{
				 	fieldLabel: '달성률(%)',
				 	xtype: 'uniTextfield',
				 	name: '',
				 	readOnly: true	
				}
			]
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
	
					   	Unilite.messageBox(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});
    
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
		    	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		    	name: 'DIV_CODE', 
		    	xtype: 'uniCombobox',
		    	comboType: 'BOR120',
		    	allowBlank: false,
		    	value: UserInfo.divCode,
		    	listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		    },{
		    	fieldLabel: '<t:message code="system.label.product.basismonth" default="기준월"/>',
		    	xtype: 'uniMonthfield',
		    	name: 'FR_DATE',
		    	value: UniDate.get('today'),
		    	allowBlank:false,
		    	listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('FR_DATE', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					valueFieldName:'ITEM_CODE',
					textFieldName:'ITEM_NAME',
					validateBlank: false,
					textFieldWidth:170, 
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}				
				})]
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('ppl180skrvGrid', {
    	layout : 'fit',
    	region:'center',
        store : MasterStore,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [
        	{dataIndex: 'GUBUN'	, width: 75 , locked: true},
        	{dataIndex: 'MON'  	, width: 111},
        	{dataIndex: 'TUE'  	, width: 111},
        	{dataIndex: 'WED'  	, width: 111},
        	{dataIndex: 'THU'  	, width: 111},
        	{dataIndex: 'FRI'  	, width: 111},
        	{dataIndex: 'SAT'  	, width: 111},
        	{dataIndex: 'SUN'  	, width: 111},
        	{dataIndex: 'WIN'  	, width: 171}
        ] 
    });		//End of var masterGrid1 = Unilite.createGrid('ppl180skrvGrid1', {
	
    Unilite.Main( {
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
		id : 'ppl180skrvApp',
		fnInitBinding: function(){
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{	
			
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			
			console.log("viewLocked : ", viewLocked);
			console.log("viewNormal : ", viewNormal);
			
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});		//End of Unilite.Main({
};
</script>

