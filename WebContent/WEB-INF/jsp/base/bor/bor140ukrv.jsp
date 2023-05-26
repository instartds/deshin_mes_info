<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bor140ukrv"  >
    <t:ExtComboStore comboType="AU" comboCode="A236" /> <!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B012" /> <!-- 국가코드 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")	{
	  document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
  	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >

function appMain() {     
	
	// 행 추가시 폼에 입력 될 부서 데이터
	//var deptData = ${deptData};
	//console.log(deptData);
	
	//var gsDED_TYPE = '1';
	
	var useStore = Ext.create('Ext.data.Store', {
        id : 'comboStore',
		fields : ['name', 'value'],
        data   : [
            {name : '사용함', value: '1'},
            {name : '사용안함', value: '0'}
        ]
    });
    
    Unilite.defineModel('bor140ukrvGubunModel', {
	    fields: [ 
	    	 	  {name: 'value'    		,text:'value'			,type : 'string'} 
	    	 	 ,{name: 'text'    			,text:'text'			,type : 'string'}
	    	 	 ,{name: 'option'    		,text:'option'			,type : 'string'}
	    	 	 ,{name: 'search'    		,text:'search'			,type : 'string'}
	    	 	 ,{name: 'refCode1'    		,text:'refCode1'		,type : 'string'}
	    	 	 ,{name: 'refCode2'    		,text:'refCode2'		,type : 'string'}
	    	 	 ,{name: 'refCode3'    		,text:'refCode3'		,type : 'string'}

	    	 	 ]
	 });
//	var GetGubunStore = Unilite.createStore('bor140ukrvGubunStore',{
//		model:'bor140ukrvGubunModel',
//        proxy: {
//           type: 'direct',
//            api: {			
//                read: 'bor140ukrvService.getGubun'                	
//            }
//        },
//        uniOpt: {
//            isMaster: false,		// 상위 버튼 연결 
//            editable: false,		// 수정 모드 사용 
//            deletable: false,		// 삭제 가능 여부 
//	        useNavi : false			// prev | next 버튼 사용
//        },
//        loadStoreRecords: function() {
//			var param = detailForm.getValues();	
//			console.log( param );
//			this.load({
//				params : param
//			});
//		},
//		listeners:{
//	    	load: function() {
//	    		if(detailForm.getValue('DWELLING_YN') == '1'){
//					//detailForm.setValue('DED_CODE' , Ext.data.StoreManager.lookup('CBS_AU_HS04').getAt(0).get('value'));
//				}else if(detailForm.getValue('DWELLING_YN')== '2'){
//					//detailForm.setValue('DED_CODE' , Ext.data.StoreManager.lookup('CBS_AU_HS06').getAt(0).get('value'));
//				}
//	    	}
//	    }
//	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('bor140ukrvModel', {
	   fields: [
			{name: 'COMP_CODE'				, text: '법인'					, type: 'string'},
			{name: 'COMP_NAME'				, text: '회사명'				, type: 'string'},
			{name: 'COMP_ENG_NAME'			, text: '회사영문명'			, type: 'string'},
			{name: 'REPRE_NAME'				, text: '대표자명'				, type: 'string'},
			{name: 'REPRE_ENG_NAME'			, text: '대표자영문명'			, type: 'string'},
			{name: 'REPRE_NO'				, text: '주민등록번호'			, type: 'string'},
			{name: 'REPRE_NUM_EXPOS'		, text: '주민등록번호'			, type: 'string' , defaultValue: '*************'},
			{name: 'COMPANY_NUM'			, text: '사업자등록번호'		, type: 'string'},
			{name: 'COMP_OWN_NO'			, text: '법인등록번호'			, type: 'string'},
			{name: 'COMP_KIND'				, text: '법인구분'				, type: 'string'},
			{name: 'COMP_CLASS'				, text: '업종'					, type: 'string'},
			{name: 'COMP_TYPE'				, text: '업태'					, type: 'string'},
			{name: 'SESSION'				, text: '회기'					, type: 'uniNumber'},
			{name: 'FN_DATE'				, text: '회기기간'				, type: 'uniDate'},
			{name: 'TO_DATE'				, text: '회기기간(To)'			, type: 'uniDate'},
			{name: 'ESTABLISH_DATE'			, text: '설립일'				, type: 'uniDate'},
			{name: 'CAPITAL'				, text: '자본금'				, type: 'uniNumber'},
			{name: 'ZIP_CODE'				, text: '우편번호'				, type: 'string'},
			{name: 'ADDR'					, text: '주소'					, type: 'string'},
			{name: 'ENG_ADDR'				, text: '영문주소'				, type: 'string'},
			{name: 'TELEPHON'				, text: '대표전화번호'			, type: 'string'},
			{name: 'FAX_NUM'				, text: '대표FAX번호'			, type: 'string'},	
			{name: 'HTTP_ADDR'				, text: '회사 홈페이지주소'		, type: 'string'},
			{name: 'EMAIL'					, text: 'E-mail주소'			, type: 'string'},			
			{name: 'CURRENCY'				, text: '자사화폐'				, type: 'string'},
			{name: 'NATION_CODE'			, text: '국가코드'				, type: 'string'},
			{name: 'DOMAIN'					, text: '도메인'				, type: 'string'},
			//{name: 'PL_BASE'				, text: '손익작성기준'			, type: 'string'},
			{name: 'MAP_COMP_CODE'			, text: 'MAP_COMP_CODE'			, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '자사거래처코드'			, type: 'string'},
			{name: 'CMS_ID'					, text: 'CMS ID'				, type: 'string'},
			{name: 'PAY_SYS_GUBUN'			, text: '경비처리시스템구분'	, type: 'string'},
			{name: 'USE_STATUS'				, text: '<t:message code="system.label.base.useyn" default="사용여부"/>'				, type: 'string'},
			{name: 'GROUP_CODE'				, text: 'GROUP_CODE'			, type: 'string'}
			
	    ]
	});		// End of Ext.define('Ham800ukrModel', {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read 	: 'bor140ukrvService.selectDetailList',
        	update	: 'bor140ukrvService.updateDetail',
			create	: 'bor140ukrvService.insertDetail',
			destroy	: 'bor140ukrvService.deleteDetail',
			syncAll	: 'bor140ukrvService.saveAll'
        }
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bor140ukrvMasterStore1',{
		model: 'bor140ukrvModel',
		uniOpt: {
            isMaster: true,		// 상위 버튼 연결 
            editable: true,		// 수정 모드 사용 
            deletable: true,		// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
	    loadDetailForm: function(node) {
	    	if(!Ext.isEmpty(node)) {
	    		var data = node.getData();
		     	if(!Ext.isEmpty(data)) {
		     	   detailForm.setValues(data);
		     	}    
		    } 
	    },
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	
			if(inValidRecs.length == 0 )	{										
				config = {
						success: function(batch, option) {								
							panelResult.resetDirtyStatus();
							directMasterStore.loadStoreRecords();	
							Ext.getCmp('COMP_CODE').setReadOnly(true);
							Ext.getCmp('COMP_NAME').setReadOnly(true);
							UniAppManager.setToolbarButtons('save', false);		
						 } 
				};					
				this.syncAllDirect(config);
				
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
	    listeners:{
	    	load: function(store) {
	    		if (store.getCount() > 0) {
	    			UniAppManager.setToolbarButtons('delete', true);
	    		} else {
	    			UniAppManager.setToolbarButtons('delete', false);
	    			detailForm.clearForm();
	    			masterGrid.reset();
		    		detailForm.getForm().getFields().each(function(field) {
					    field.setReadOnly(true);
					});
	    		}
	    	}
	    }
	});
	
	 /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('bor140ukrvGrid1', {
    	itemId:'masterGrid',
    	layout : 'fit',
        region : 'west',
        flex  : 1,
		store: directMasterStore,
		uniOpt: {
			expandLastColumn: false,
        	useRowNumberer: true,
            useMultipleSorting: false,
		    state: {
			    useState: false,
			    useStateList: false
		    }
        },   
        columns: [        
	    	{dataIndex: 'COMP_CODE'			    	, width: 100 }, 	
			{dataIndex: 'COMP_NAME'			  	, flex: 1  },               
			{dataIndex: 'COMP_ENG_NAME'	    	, width: 120  , hidden :true  },  
			{dataIndex: 'REPRE_NAME'			  		, width: 100 , hidden :true }, 				              
			{dataIndex: 'REPRE_ENG_NAME'		, width: 100 , hidden :true }, 	
			{dataIndex: 'REPRE_NO'						, width: 100 , hidden :true }, 	
			{dataIndex: 'COMPANY_NUM'		  	, width: 100 , hidden :true }, 	
			{dataIndex: 'COMP_OWN_NO'		    	, width: 100 , hidden :true }, 	
			{dataIndex: 'COMP_KIND'			    	, width: 100 , hidden :true }, 	
			{dataIndex: 'COMP_CLASS'			  	, width: 100 , hidden :true },
			{dataIndex: 'COMP_TYPE'			  	, width: 100 , hidden :true }, 	
			{dataIndex: 'SESSION'				    	, width: 100 , hidden :true }, 	
			{dataIndex: 'FN_DATE'				  , width: 100 , hidden :true }, 	
			{dataIndex: 'TO_DATE'				  , width: 100 , hidden :true }, 	
			{dataIndex: 'ESTABLISH_DATE'	, width: 100 , hidden :true }, 	
			{dataIndex: 'CAPITAL'				  		, width: 100 , hidden :true }, 	
			{dataIndex: 'ZIP_CODE'				, width: 100 , hidden :true }, 	
			{dataIndex: 'ADDR'					, width: 100 , hidden :true }, 	
			{dataIndex: 'ENG_ADDR'					, width: 100 , hidden :true },
			{dataIndex: 'TELEPHON'					, width: 100 , hidden :true },
			{dataIndex: 'FAX_NUM'				  , width: 100 , hidden :true },
			{dataIndex: 'HTTP_ADDR'			  	, width: 100 , hidden :true },
			{dataIndex: 'EMAIL'					  	, width: 100 , hidden :true },
			{dataIndex: 'CURRENCY'				, width: 100 , hidden :true },
			{dataIndex: 'NATION_CODE'		    	, width: 100 , hidden :true }, 	
			{dataIndex: 'DOMAIN'					, width: 100 , hidden :true }, 	
			{dataIndex: 'PL_BASE'				  , width: 100 , hidden :true }, 	
			{dataIndex: 'MAP_COMP_CODE'		    	, width: 100 , hidden :true }, 	
			{dataIndex: 'CUSTOM_CODE'					, width: 100 , hidden :true }, 	
			{dataIndex: 'CMS_ID'				  , width: 100 , hidden :true }, 
			{dataIndex: 'PAY_SYS_GUBUN'			  , width: 100 , hidden :true }, 
			{dataIndex: 'USE_STATUS'				, width: 100 , hidden :true },
			{dataIndex: 'GROUP_CODE'				, width: 100 , hidden :true }			
        ],
 	    listeners: {
 	    	beforeedit  : function( editor, e, eOpts ) {	// 
	        	if(!e.record.phantom) {                     // 
	        		if(UniUtils.indexOf(e.field))           // 
					{                                       // 
						return false;                       // 
      				} else {                                // 
      					return false;                       // 
      				}                                       // 
	        	} else {                                    // 
	        		if(UniUtils.indexOf(e.field))           // 
					{                                       // 
						return false;                       // 
      				} else {                                // 
      					return false;                       // 
      				}                                       // 
	        	}                                           // 
	        },
 	    	selectionchangerecord:function(selected)	{
          		detailForm.setActiveRecord(selected)
/*          		if(!Ext.isEmpty(selected.data.REPRE_NO)){
          			detailForm.setValue('REPRE_NUM_EXPOS', '***************');
          		}else{
          			detailForm.setValue('REPRE_NUM_EXPOS', '');
          		} */         		
          	},
            selectionchange: function(grid, selNodes){ 
            	if (typeof selNodes[0] != 'undefined') {
					// 행 추가 후 선택이 변할 경우 저장하지 않은 데이터를 저장 할지 확인 함
            		if (grid.getStore().isDirty()) {
						if (detailForm.getForm().isDirty()) {
							if(UniAppManager.app._needSave()) {
								Ext.Msg.confirm(Msg.sMB099, Msg.sMB017 + "\n" + Msg.sMB061, function(btn){
									if (btn == 'yes') {
										UniAppManager.app.onSaveDataButtonDown();
									}
								});
							}
						} else {
							grid.getStore().loadDetailForm(selNodes[0]);
			            	if (selNodes[0].phantom) {
			            		
			            		detailForm.getForm().findField('COMP_NAME').setReadOnly(false);
			            	} else {
			            		detailForm.getForm().getFields().each(function(field) {
			    					if (field.name != 'COMP_CODE' && field.name != 'COMP_NAME') {
			    						field.setReadOnly(false);
			    					}
			    				});
			    				detailForm.getForm().findField('COMP_NAME').setReadOnly(true);
			            	}
						}
					} else {
						
						grid.getStore().loadDetailForm(selNodes[0]);
		            	if (selNodes[0].phantom) {
		            		detailForm.getForm().findField('COMP_NAME').setReadOnly(false);
		            	} else {
		            		detailForm.getForm().getFields().each(function(field) {
		    					if (field.name != 'COMP_CODE' && field.name != 'COMP_NAME') {
		    						field.setReadOnly(false);
		    					}
		    				});
		    				detailForm.getForm().findField('COMP_NAME').setReadOnly(true);
		            	}
					}
            	}
            }
        }
    });
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
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
				fieldLabel: '회사',
				name: 'COMP_CODE', 
				xtype: 'uniCombobox',
				//comboType: 'BOR120',
				//comboCode: 'BILL',
				//allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COMP_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>'	,
				name:'USE_STATUS', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A236',
                value: 'Y',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('USE_STATUS', newValue);
					}
				}
			}/*,{
				fieldLabel: '소득자코드',
				name: 'DED_TYPE', 
				xtype: 'hiddenfield',
				allowBlank: false,
				value: gsDED_TYPE
			},*/
			
				
			/*Unilite.popup('EARNER',{
		    	fieldLabel: '소득자', 
				validateBlank:false,
				autoPopup: false,
				valueFieldName:'PERSON_NUMB',
        		textFieldName:'NAME', 
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('NAME', newValue);				
						},
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
								panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('PERSON_NUMB', '');
							panelResult.setValue('ACCNT_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
							popup.setExtParam({'SECT_CODE': panelSearch.getValue('SECT_CODE')});			//신고사업장
						}
					}
				}),*/
				/*Unilite.popup('DEPT',{
		    	fieldLabel: '부서', 
				validateBlank:false,
				autoPopup: false,
				valueFieldName:'DEPT_CODE',
        		textFieldName:'DEPT_NAME', 
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_NAME', newValue);				
						},
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_NAME', '');
							panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							
						}
					}
				})*/
			]
		}/*,{	
			title: '<t:message code="system.label.base.additionalinfo" default="추가정보"/>', 	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>',
				name: 'USER_YN', 
				xtype: 'combobox', 
				store: useStore,
                queryMode: 'local',
            	displayField: 'name',
        		valueField: 'value',
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('USER_YN', newValue);
					}
				}
			}]
		}*/]
	});	//end panelSearch  
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '회사',
				name: 'COMP_CODE', 
				xtype: 'uniCombobox',
				//comboType: 'BOR120',
				//comboCode: 'BILL',
				//allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('COMP_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>'	,
				name:'USE_STATUS', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A236',
				value: 'Y',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('USE_STATUS', newValue);
					}
				}
			}/*,{
				fieldLabel: '소득자코드',
				name: 'DED_TYPE', 
				xtype: 'hiddenfield',
				allowBlank: false,
				value: gsDED_TYPE
			},
			
			Unilite.popup('EARNER',{
		    	fieldLabel: '소득자', 
				validateBlank:false,
				autoPopup: false,
				
		    	colspan:2,
				valueFieldName:'PERSON_NUMB',
        		textFieldName:'NAME', 
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('NAME', newValue);				
						},
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
								panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('PERSON_NUMB', '');
							panelSearch.setValue('ACCNT_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
							popup.setExtParam({'SECT_CODE': panelSearch.getValue('SECT_CODE')});			//신고사업장
						}
					}
			}),
				Unilite.popup('DEPT',{
		    	fieldLabel: '부서', 
				validateBlank:false,
				autoPopup: false,
				valueFieldName:'DEPT_CODE',
        		textFieldName:'DEPT_NAME', 
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('DEPT_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('DEPT_NAME', newValue);				
						},
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
								panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>',
				name: 'USER_YN', 
				xtype: 'combobox', 
				store: useStore,
                queryMode: 'local',
            	displayField: 'name',
        		valueField: 'value',
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('USER_YN', newValue);
					}
				}
			}*/]
    });
    
    var detailForm = Unilite.createForm('bor140ukrvDetail', {
    	disabled :false,
    	masterGrid: masterGrid,
    	autoScroll:true,
    	padding:'1 1 5 1',
    	flex  : 3,
    	region : 'center'     
        , layout: {type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}}
	    , items :[{
				fieldLabel: '회사코드',
				name: 'COMP_CODE', 
				id:'COMP_CODE',
				//xtype: 'uniCombobox',
				//comboType: 'AU',
				//comboCode: 'A118',
				allowBlank:false,
				maxLength: 30,
				//value:gsDED_TYPE,
				readOnly: true
			},{
				fieldLabel: '회사명',
				id : 'COMP_NAME',
				name: 'COMP_NAME',
				xtype: 'uniTextfield',
				widht: 50,
				allowBlank:false
			},{
				fieldLabel: '회사영문명',
				name: 'COMP_ENG_NAME',
				xtype: 'uniTextfield'
				//allowBlank:false	
			},{
				fieldLabel: '대표자명',
				name: 'REPRE_NAME',
				xtype: 'uniTextfield',
				maxLength: 20
			},{
				fieldLabel: '대표자영문명',
				name: 'REPRE_ENG_NAME', 
				xtype: 'uniTextfield',
				maxLength: 30
			},{ 
				fieldLabel:'주민등록번호',
				name :'REPRE_NUM_EXPOS',
				xtype: 'uniTextfield',
				readOnly:true,
				focusable:false,
				listeners:{
					afterrender:function(field)	{
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{					
					detailForm.openCryptRepreNoPopup();
				}
			},{
				fieldLabel: '주민등록번호',
				name: 'REPRE_NO',
				xtype: 'uniTextfield',
				hidden: true
			}/*,{
				fieldLabel: '사업자등록번호',
				name: 'COMPANY_NUM',
				xtype: 'uniTextfield',
				maxLength: 12
			}*/,{
				fieldLabel: '사업자등록번호',
				name: 'COMPANY_NUM',    	
				xtype: 'uniTextfield',
				maxLength:21,
			  	listeners : { blur: function( field, The, eOpts )	{
			  					var newValue = field.getValue().replace(/-/g,'');		
			  					if(!Ext.isNumeric(newValue))	{	
			  						Unilite.messageBox(Msg.sMB074);
						 			detailForm.setValue('COMPANY_NUM', field.originalValue);
						 			return;
								 }
			  					if(!Ext.isEmpty(newValue) && !(field.originalValue == field.getValue()) )	{
				  					if(Ext.isNumeric(newValue)) {
										var a = newValue;
										var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
										if(a.length == 10){
											detailForm.setValue('COMPANY_NUM',i);
										}else{
											detailForm.setValue('COMPANY_NUM',a);
										}
										
								 	}
				  					
				  					if(Unilite.validate('bizno', newValue) != true)	{
								 		if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{									 		 
								 			detailForm.setValue('COMPANY_NUM', field.originalValue);
								 		}
								 	}
			  					}
							 	
			  				}
			  			 } 
			},{
				fieldLabel: '법인등록번호',
				name: 'COMP_OWN_NO',
				xtype: 'uniTextfield',
				maxLength: 20
			}/*{ fieldLabel: '법인등록번호',
			    name: 'COMP_OWN_NO',
			    xtype: 'uniTextfield',
			    maxLength:21,
				listeners : { blur: function( field, The, eOpts )	{
								var newValue = field.getValue().replace(/-/g,'');
								if(!Ext.isEmpty(newValue) && field.originalValue != field.getValue())	{
									if(Ext.isNumeric(newValue) == true) {
										var a = newValue;
										var i = (a.substring(0,6)+ "-"+ a.substring(6,13));
										detailForm.setValue('COMP_OWN_NO',i);
								 	}
				  					if(Ext.isNumeric(newValue) != true)	{
								 		if(!confirm(Msg.sMB074)) {									 		 
								 			detailForm.setValue('COMP_OWN_NO', field.originalValue);
								 		}
								 	}
								}
							 	
						}
				}
			}*/,{
				fieldLabel: '법인구분',
				name: 'COMP_KIND', 
				id:'COMP_KIND',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B002',
				allowBlank:false,
				//maxLength: 30,
				readOnly: true
			},{
				fieldLabel: '업종',
				name: 'COMP_CLASS',
				xtype: 'uniTextfield'
				//maxLength: 50
			},{
				fieldLabel: '업태',
				name: 'COMP_TYPE',
				xtype: 'uniTextfield'
				//maxLength: 50
			},{
				fieldLabel: '회기',
				name: 'SESSION',
				xtype: 'uniNumberfield',
				allowBlank:false
			},{	fieldLabel: '회계기간'
				,xtype: 'uniDateRangefield'
			    ,startFieldName: 'FN_DATE'
			    ,endFieldName: 'TO_DATE'	
			    ,width: 470
			    ,startDate: UniDate.get('startOfMonth')
			    ,endDate: UniDate.get('today')
			    ,allowBlank:false
		     },{
				fieldLabel: '설립일',
				name: 'ESTABLISH_DATE',
				xtype: 'uniDatefield'
				//maxLength: 50
			},{
				fieldLabel: '자본금',
				name: 'CAPITAL',
				xtype: 'uniNumberfield'
				//maxLength: 50
			},{	
				fieldLabel: '국가코드',
				name: 'NATION_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B012'// TODO : replace it!
				//allowBlank:false
				//maxLength: 30
			},{	
				fieldLabel: '자사화폐',
				name: 'CURRENCY', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',// TODO : replace it!
				fieldStyle: 'text-align: center;', 
				displayField: 'value',
				colspan: 2
				//maxLength: 30
			},
			Unilite.popup('ZIP',{
				fieldLabel: '사업장주소',
				showValue:false,
				textFieldName:'ZIP_CODE',
				DBtextFieldName:'ZIP_CODE',
				validateBlank:false,
				//name: 'ZIP_CODE',
				popupHeight:580,
				listeners: { 'onSelected': {
		                    fn: function(records, type  ){
		                    	masterGrid.getSelectedRecord().set('ZIP_CODE', records[0]['ZIP_CODE']);
		                    	masterGrid.getSelectedRecord().set('ADDR', records[0]['ZIP_NAME']+records[0]['ADDR2']);
		                    	detailForm.setValue('ZIP_CODE', records[0]['ZIP_CODE']);
		                    	detailForm.setValue('ADDR', records[0]['ZIP_NAME']+records[0]['ADDR2']);
		                    },
		                    scope: this
		                  },
		                  'onClear' : function(type)	{
		                  	  masterGrid.getSelectedRecord().set('ZIP_CODE', '');
		                      masterGrid.getSelectedRecord().set('ADDR', '');
		                  	  detailForm.setValue('ZIP_CODE', '');
		                	  detailForm.setValue('ADDR', '');
		                  }
					}
			}),{
    	  	 	fieldLabel: '상세주소',
			 	name: 'ADDR',
			 	hideLabel: true,
			 	width: 400,
			 	margin:'0 0 0 -205'
			},{
				fieldLabel: '영문사업장주소',
				name: 'ENG_ADDR',
				xtype: 'uniTextfield',
				colspan:2,
				maxLength: 100,
				width: 510
			},{
				fieldLabel: '대표전화번호',
				name: 'TELEPHON',
				xtype: 'uniTextfield',
				colspan:2
			},{
				fieldLabel: '대표FAX번호',
				name: 'FAX_NUM',
				xtype: 'uniTextfield',
				colspan:2
			},{
				fieldLabel: '홈페이지주소',
				name: 'HTTP_ADDR',
				xtype: 'uniTextfield',
				colspan:2
			},{
				fieldLabel: 'mail주소',
				name: 'EMAIL',
				xtype: 'uniTextfield',
				colspan:2
			},{
				fieldLabel: '도메인',
				name: 'DOMAIN',
				xtype: 'uniTextfield',
				colspan:2
			},{
				fieldLabel: '손익작성기준',
				name: 'PL_BASE',
				xtype: 'uniTextfield',
				colspan:2,
				hidden: true
			}/*,{	
				fieldLabel: '손익작성기준',
				name: 'PL_BASE', 
				xtype: 'uniCombobox',
				//allowBlank:false,
				store: Ext.data.StoreManager.lookup('bor101ukrvPlBaseOptStore'),
				colspan:2
				//maxLength: 30
			}*/,{
				fieldLabel: 'MAP_COMP_CODE',
				name: 'MAP_COMP_CODE',
				xtype: 'uniTextfield',
				colspan:2,
				hidden: true
			},	
			Unilite.popup('AGENT_CUST',{ 
		    	fieldLabel: '자사거래처코드', 
		    	//allowBlank:false,
		    	popupWidth: 600,
		    	valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				colspan:2
			}),/*{
				fieldLabel: '자사거래처코드',
				name: 'CUSTOM_CODE',
				xtype: 'uniTextfield',
				colspan:2
			},*/{
				fieldLabel: 'CMS ID',
				name: 'CMS_ID',
				xtype: 'uniTextfield',
				colspan:2
			},{
    	  	 	fieldLabel: '경비처리시스템구분',
    	  	 	id: 'PAY_SYS_GUBUN',
			 	name:'PAY_SYS_GUBUN'  ,
//			 	allowBlank:false,
//			 	hideLabel:true,
			 	xtype: 'uniRadiogroup',
			 	colspan:2,
			 	width: 200,
			 	margin: '0 0 0 5',
				items: [
 					{boxLabel:'MIS', name:'PAY_SYS_GUBUN', inputValue:'1'},
 					{boxLabel:'SAP', name:'PAY_SYS_GUBUN', inputValue:'2'}
  				]
			},{
				fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>',
				name: 'USE_STATUS', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A236',// TODO : replace it!
				allowBlank:false,
				colspan:2
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
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			},
			loadForm: function(record)	{
				// window 오픈시 form에 Data load
				var count = masterGrid.getStore().getCount();
				if(count > 0) {
					this.reset();
					this.setActiveRecord(record[0] || null);   
					this.resetDirtyStatus();			
				}
			},
			openCryptRepreNoPopup:function(  )	{
				var record = this;
								
				var params = {'REPRE_NO':this.getValue('REPRE_NO'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
				Unilite.popupCipherComm('form', record, 'REPRE_NUM_EXPOS', 'REPRE_NO', params);
								
			},			
         /*,api: {
         		 load: 'bor140ukrvService.selectList',
				 submit: 'bor140ukrvService.submitList'				
				}*/
			listeners : {
				dirtychange: function( basicForm, dirty, eOpts ) {
					console.log("onDirtyChange");
					//UniAppManager.setToolbarButtons('save', true);
				}
				// TODO : validate
				/*beforeaction: function(basicForm, action, eOpts)	{
					console.log("action : ",action);
					console.log("action.type : ",action.type);
					
					var foreign_yn = detailForm.getForm().findField('FOREIGN_YN').getValue();
					var repre_num = detailForm.getForm().findField('REPRE_NUM').getValue();
					var dwelling_yn = detailForm.getForm().findField('DWELLING_YN').getValue();
					var foreign_num = detailForm.getForm().findField('FOREIGN_NUM').getValue();
					var business_type = detailForm.getForm().findField('BUSINESS_TYPE').getValue();
					var comp_num = detailForm.getForm().findField('COMP_NUM').getValue();
					var recogn_num = detailForm.getForm().findField('RECOGN_NUM').getValue();
					var comp_eng_name = detailForm.getForm().findField('COMP_ENG_NAME').getValue();
					var comp_eng_addr = detailForm.getForm().findField('COMP_ENG_ADDR').getValue();
					var comp_kor_name = detailForm.getForm().findField('COMP_KOR_NAME').getValue();
					var eng_name = detailForm.getForm().findField('ENG_NAME').getValue();
					var eng_addr = detailForm.getForm().findField('ENG_ADDR').getValue();
					
					// TODO :focus
					// 내국인인 경우
					if (foreign_yn == '1') {
						if (repre_num == '') {
							detailForm.getForm().findField('REPRE_NUM').focus();
							Unilite.messageBox(Msg.sMHE0007);
							return false;
						} else {
				 			var param={'REPRE_NUM' : repre_num};
				 			if(Unilite.validate('residentno', repre_num) !== true)  {
				 				Ext.Msg.confirm(Msg.sMB099, '잘못된 주민번호를 입력하셨습니다. 잘못된 주민번호를 저장하시겠습니까?', function(btn){
									if (btn == 'no') {
										detailForm.getForm().findField('REPRE_NUM').setValue('');
										return false;
									}
								});
				 			}
				 			hum100ukrService.chkFamilyRepreNum(param, function(provider, response) {
									if(provider.data['CNT'] != 0)	{
										Ext.Msg.confirm(Msg.sMB099, '중복된 주민번호가 존재합니다. 계속 진행하시겠습니까? ', function(btn){
											if (btn == 'no') {
												detailForm.getForm().findField('REPRE_NUM').setValue('');
												return false;
											}
										});
									}
							});
						}
					// 외국인인 경우
					} else {
						if (dwelling_yn == '1' && foreign_num == '') {
							detailForm.getForm().findField('FOREIGN_NUM').focus();
							Unilite.messageBox(Msg.sMHE0030);
							return false;
						}
					}
					// 법인인 경우
					if (business_type == '1') {
						if (comp_num == '' && dwelling_yn == '1') {
							detailForm.getForm().findField('COMP_NUM').focus();
							Unilite.messageBox(Msg.sMHE0009);
							return false;
						}
						
						if (comp_num != '' && dwelling_yn == '1') {
							if(Unilite.validate('biznno', comp_num) !== true)  {
								Ext.Msg.confirm(Msg.sMB099, Msg.sMB173+"\n"+Msg.sMB175+"\n", function(btn){
									if (btn == 'no') {
										detailForm.getForm().findField('COMP_NUM').setValue('');
										return false;
									}
								});
				 			}
						}
						// 비거주인 경우
						if (dwelling_yn == '2') {
							if (recogn_num == '') {
								detailForm.getForm().findField('RECOGN_NUM').focus();
								Unilite.messageBox(Msg.sMHE0031);
								return false;
							}
							if (comp_eng_name == '') {
								detailForm.getForm().findField('COMP_ENG_NAME').focus();
								Unilite.messageBox(Msg.sMHE0032);
								return false;
							}
							if (comp_eng_addr == '') {
								detailForm.getForm().findField('COMP_ENG_ADDR').focus();
								Unilite.messageBox(Msg.sMHE0033);
								return false;
							}
						// 거주인 경우
						} else {
							if (comp_kor_name == '') {
								detailForm.getForm().findField('COMP_KOR_NAME').focus();
								Unilite.messageBox(Msg.sMHE0034);
								return false;
							}
						}
					// 개인인 경우	
					} else {
						// 비거주인 경우
						if (dwelling_yn == '2') {
							if (eng_name == '') {
								detailForm.getForm().findField('ENG_NAME').focus();
								Unilite.messageBox(Msg.sMHE0036);
								return false;
							}
							if (recogn_num == '') {
								detailForm.getForm().findField('RECOGN_NUM').focus();
								Unilite.messageBox(Msg.sMHE0037);
								return false;
							}
							if (eng_addr == '') {
								detailForm.getForm().findField('ENG_ADDR').focus();
								Unilite.messageBox(Msg.sMHE0038);
								return false;
							}
						}
					}
									
					if(action.type =='directsubmit')	{
						var invalid = this.getForm().getFields().filterBy(function(field) {
						            return !field.validate();
						    });
				        	
			         	if(invalid.length > 0)	{
				        	r=false;
				        	var labelText = ''
				        	
				        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
				        		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
				        		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				        	}
				        	Unilite.messageBox( labelText+Msg.sMB083);
				        	invalid.items[0].focus();
				        	return false;
			         	}
					}
				}	*/
		}
	});		
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				 masterGrid, detailForm, panelResult
			]	
		},
			panelSearch
		],
		id : 'bor140ukrvApp',
		fnInitBinding : function() {
//			panelSearch.setValue('SECT_CODE',Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
//			panelResult.setValue('SECT_CODE',Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
//				
//			detailForm.setValue('DEPT_CODE', UserInfo.deptCode);
//			detailForm.setValue('DEPT_NAME', UserInfo.deptName);
//			
//			
//			detailForm.setValue('SECT_CODE' , Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
//			detailForm.setValue('DED_TYPE' , gsDED_TYPE);
			//detailForm.setValue('DED_CODE' , Ext.data.StoreManager.lookup('CBS_AU_HS04').getAt(0).get('value'));
//			detailForm.setValue('BUSINESS_TYPE', '2');
//			detailForm.setValue('KNOWN_YN' ,'1');
//			detailForm.setValue('FOREIGN_YN', '1');
//			detailForm.setValue('NATION_CODE', 'KR');
//			detailForm.setValue('DWELLING_YN' , '1');
//			detailForm.setValue('DIV_CODE', '01');
//			detailForm.setValue('USE_STATUS', '1');
			
			
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('newData', true);
			// 처음 구동시 행을 추가하지 않으면 수정이 불가하도록 함
			detailForm.getForm().getFields().each(function(field) {
			      field.setReadOnly(true);
			});
			//GetGubunStore.loadStoreRecords();
		},
		onQueryButtonDown : function()	{		
			directMasterStore.loadStoreRecords();	
		},
		checkForNewDetail:function() { 			
			return detailForm.setAllFieldsReadOnly(true);
        },
		onNewDataButtonDown : function() {
			var r = {				

			};			
			masterGrid.createRow(r); 
			detailForm.getForm().findField('COMP_CODE').focus();
			
			/*if (masterGrid.getStore().isDirty()) {
				Unilite.messageBox( '한번에 한건의 데이터만 수정, 입력이 가능 합니다.');
				return false;
			} else {*/
/*				var param={'COMP_CODE' : UserInfo.compCode};
				bor140ukrvService.fnGetBusinessCode(param, function(provider, response) {
					if(provider)	{
						masterGrid.createRow({
					    DED_TYPE: gsDED_TYPE, 
					    BUSINESS_TYPE: provider[0].SUB_CODE, 
					    KNOWN_YN: 1, 
					    FOREIGN_YN: 1, 
					    NATION_CODE: 'KR', 
					    DWELLING_YN: 1,
						//DED_CODE: Ext.data.StoreManager.lookup('CBS_AU_HS04').getAt(0).get('value'), //940100,  소득구분 (거주구분1 - 국내 /2 - 해외) 기능필요
						DEPT_CODE: deptData[0].DEPT_CODE, 
						DEPT_NAME: deptData[0].DEPT_NAME, 
						SECT_CODE: '01', 
						DIV_CODE : UserInfo.divCode,
						COMP_CODE: UserInfo.compCode,
						USER_YN: 1});
						detailForm.getForm().findField('PERSON_NUMB').focus();
					}
				});*/
				detailForm.getForm().getFields().each(function(field) {
					//if (field.name != 'COMP_CODE') {
						field.setReadOnly(false);
					//}
				});
			//}
			UniAppManager.setToolbarButtons('delete', true);
		},
		onDeleteDataButtonDown: function() {
			if (masterGrid.getStore().getCount == 0) return;
			var selRow = masterGrid.getSelectionModel().getSelection()[0];
			if (selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			} else {
				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
					if (btn == 'yes') {
						masterGrid.deleteSelectedRow();
						UniAppManager.app.setToolbarButtons('save', true);
					}
				});
			}
			if (masterGrid.getStore().getCount() == 0) {
				UniAppManager.setToolbarButtons('delete', false);
			}
		},
		onSaveDataButtonDown : function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}
			else{/*
				if(detailForm.getValue('FOREIGN_YN') == '1'){		// 내국인 체크
					if(detailForm.getValue('REPRE_NUM') == ''){
						detailForm.getForm().findField('REPRE_NUM').focus();
						Unilite.messageBox(Msg.sMHE0007);
						return false;
					}
				}
				if(detailForm.getValue('FOREIGN_YN') == '9'){		// 외국인체크
					if(detailForm.getValue('FOREIGN_NUM') == ''){
						detailForm.getForm().findField('FOREIGN_NUM').focus();
						Unilite.messageBox(Msg.sMHE0030);
						return false;
					}
				}	
				if(detailForm.getValue('BUSINESS_TYPE') == '1'){	//1법인인경우(1법인,2개인)
					if(detailForm.getValue('COMP_NUM') == '' && (detailForm.getValue('DWELLING_YN') == '1')){
						detailForm.getForm().findField('COMP_NUM').focus();
						Unilite.messageBox(Msg.sMHE0009);
						return false;
					}
					
					if(detailForm.getValue('DWELLING_YN') == '2'){	//2비거주인경우만(1거주,2비거주)
						if(detailForm.getValue('RECOGN_NUM') ==''){	
							detailForm.getForm().findField('RECOGN_NUM').focus();
							Unilite.messageBox(Msg.sMHE0031);
							return false;
						}
						
						if(detailForm.getValue('COMP_ENG_NAME') ==''){	
							detailForm.getForm().findField('COMP_ENG_NAME').focus();
							Unilite.messageBox(Msg.sMHE0032);
							return false;
						}
						
						if(detailForm.getValue('COMP_ENG_ADDR') ==''){	
							detailForm.getForm().findField('COMP_ENG_ADDR').focus();
							Unilite.messageBox(Msg.sMHE0033);
							return false;
						}
					}
					else{
						if(detailForm.getValue('COMP_KOR_NAME') ==''){	
							detailForm.getForm().findField('COMP_KOR_NAME').focus();
							Unilite.messageBox(Msg.sMHE0034);
							return false;
						}
					}
				}
				else{
					if(detailForm.getValue('DWELLING_YN') == '2'){ 	//2비거주인경우만(1거주,2비거주)
						if(detailForm.getValue('ENG_NAME') ==''){	
							detailForm.getForm().findField('ENG_NAME').focus();
							Unilite.messageBox(Msg.sMHE0036);
							return false;
						}
						if(detailForm.getValue('RECOGN_NUM') ==''){	
							detailForm.getForm().findField('RECOGN_NUM').focus();
							Unilite.messageBox(Msg.sMHE0037);
							return false;
						}
						if(detailForm.getValue('ENG_ADDR') ==''){	
							detailForm.getForm().findField('ENG_ADDR').focus();
							Unilite.messageBox(Msg.sMHE0038);
							return false;
						}
					}
				}*/
				masterGrid.getStore().saveStore();
			}
		}
	});
	
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var repre_num		= detailForm.getForm().findField('REPRE_NO').getValue();
			var comp_eng_name	= detailForm.getForm().findField('COMP_ENG_NAME').getValue();
			var comp_eng_addr	= detailForm.getForm().findField('ENG_ADDR').getValue();
			var comp_kor_addr	= detailForm.getForm().findField('ADDR').getValue();
			var eng_name		= detailForm.getForm().findField('REPRE_ENG_NAME').getValue();
			var comp_num		= detailForm.getForm().findField('COMPANY_NUM').getValue();
			comp_num			= comp_num.replace(/-/g,'');

			switch(fieldName) {
				/*case fieldName :
					UniAppManager.setToolbarButtons('save', true);
				 	break;*/
				case "REPRE_NO" : // 주민번호

					if (repre_num == '') {
						detailForm.getForm().findField('REPRE_NO').focus();
						Unilite.messageBox(Msg.sMHE0007);
						return false;
					} /*else {
			 			var param={'REPRE_NO' : repre_num};
			 			if(Unilite.validate('residentno', repre_num) !== true)  {
			 				Ext.Msg.confirm(Msg.sMB099, '잘못된 주민번호를 입력하셨습니다. 잘못된 주민번호를 저장하시겠습니까?', function(btn){
								if (btn == 'no') {
									detailForm.getForm().findField('REPRE_NO').setValue('');
									return false;
								}
							});
			 			}
			 			hum100ukrService.chkFamilyRepreNum(param, function(provider, response) {
								if(provider.data['CNT'] != 0)	{
									Ext.Msg.confirm(Msg.sMB099, '중복된 주민번호가 존재합니다. 계속 진행하시겠습니까? ', function(btn){
										if (btn == 'no') {
											detailForm.getForm().findField('REPRE_NO').setValue('');
											return false;
										}
									});
								}
						});
					}*/

				break;
				
/*				case "COMPANY_NUM" :	// 사업자등록번호

					if (comp_num == '' ) {
							detailForm.getForm().findField('COMPANY_NUM').focus();
							Unilite.messageBox(Msg.sMHE0009);
							return false;
					} else  {
						if(Unilite.validate('biznno', comp_num) !== true)  {
							Ext.Msg.confirm(Msg.sMB099, Msg.sMB173+"\n"+Msg.sMB175+"\n", function(btn){
								if (btn == 'no') {
									detailForm.getForm().findField('COMPANY_NUM').setValue('');
									return false;
								}
							});
			 			}
					}

				break;*/
				
				case "COMP_ENG_NAME" :	//영문 법인명

					if(comp_eng_name == ''){
						detailForm.getForm().findField('COMP_ENG_NAME').focus();
						Unilite.messageBox(Msg.sMHE0032);
						return false;
					}

				break;
				
				case "ENG_ADDR" :	//영문 사업장 주소

					if(comp_eng_addr == ''){
						detailForm.getForm().findField('ENG_ADDR').focus();
						Unilite.messageBox(Msg.sMHE0033);
						return false;
					}

				break;
				
				case "ADDR" :	// 사업장 주소

					if(comp_kor_addr == ''){
						detailForm.getForm().findField('ADDR').focus();
						Unilite.messageBox(Msg.sMHE0034);
						return false;
					}

				break;
				
				case "REPRE_ENG_NAME" : // 영문 대표자명

					if(eng_name == ''){
						detailForm.getForm().findField('REPRE_ENG_NAME').focus();
						Unilite.messageBox(Msg.sMHE0036);
						return false;
					}

				break;

			}
			return rv;
		}
	}); // validator
	
	
};


</script>
