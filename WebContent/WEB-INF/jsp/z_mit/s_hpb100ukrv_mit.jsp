<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpb100ukrv_mit"  >
	<t:ExtComboStore comboType="AU" comboCode="A118" /> <!-- 소득자타입 -->
	<t:ExtComboStore items="${WORKER_CODE}" storeId="workerCode" /> <!-- 작업자코드 -->
	<t:ExtComboStore comboType="BOR120"  pgmId="s_hpb100ukrv_mit"  /> 			<!-- 사업장 -->	
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
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

var BsaCodeInfo = { 
    gsAutoCode: '${gsAutoCode}'     //PERSON_NUMB 자동채번 관련  BCM100T에INSERT 관련
}
function appMain() {     
	
	// 행 추가시 폼에 입력 될 부서 데이터
	var deptData = '${deptData}';
	console.log(deptData);
	
	var gsDED_TYPE = '1';
	
	var useStore = Ext.create('Ext.data.Store', {
        id : 'comboStore',
		fields : ['name', 'value'],
        data   : [
            {name : '사용함', value: '1'},
            {name : '사용안함', value: '0'}
        ]
    });
    
    Unilite.defineModel('s_hpb100ukrv_mitGubunModel', {
	    fields: [ 
	    	 	 {name: 'value'    			,text:'value'			,type : 'string'} 
	    	 	 ,{name: 'text'    			,text:'text'			,type : 'string'}
	    	 	 ,{name: 'option'    		,text:'option'			,type : 'string'}
	    	 	 ,{name: 'search'    		,text:'search'			,type : 'string'}
	    	 	 ,{name: 'refCode1'    		,text:'refCode1'		,type : 'string'}
	    	 	 ,{name: 'refCode2'    		,text:'refCode2'		,type : 'string'}
	    	 	 ,{name: 'refCode3'    		,text:'refCode3'		,type : 'string'}

	    	 	 ]
	 });
	var GetGubunStore = Unilite.createStore('s_hpb100ukrv_mitGubunStore',{
		model:'s_hpb100ukrv_mitGubunModel',
        proxy: {
           type: 'direct',
            api: {			
                read: 's_hpb100ukrv_mitService.getGubun'                	
            }
        },
        uniOpt: {
            isMaster: false,		// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable: false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        loadStoreRecords: function() {
			var param = detailForm.getValues();	
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
	    	load: function() {
	    		if(detailForm.getValue('DWELLING_YN') == '1'){
					//detailForm.setValue('DED_CODE' , Ext.data.StoreManager.lookup('CBS_AU_HS04').getAt(0).get('value'));
				}else if(detailForm.getValue('DWELLING_YN')== '2'){
					//detailForm.setValue('DED_CODE' , Ext.data.StoreManager.lookup('CBS_AU_HS06').getAt(0).get('value'));
				}
	    	}
	    }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hpb100ukrv_mitModel', {
	   fields: [
			{name: 'DED_TYPE'				, text: 'DED_TYPE'			, type: 'string',allowBlank:false, editable : false},
			{name: 'PERSON_NUMB'			, text: '소득자코드'			, type: 'string',allowBlank:false, editable : false},
			{name: 'NAME'					, text: '성 명'				, type: 'string',allowBlank:false, editable : false},
			{name: 'DED_CODE'				, text: '소득코드'			, type: 'string',allowBlank:false, editable : false},
			{name: 'ZIP_CODE'				, text: '개인 우편번호'		, type: 'string', editable : false},
			{name: 'KOR_ADDR'				, text: '개인 주소'			, type: 'string', editable : false},
			{name: 'TELEPHONE'				, text: '개인 전화번호'		, type: 'string', editable : false},
			{name: 'BANK_NAME'				, text: '은행명'				, type: 'string', editable : false},
			{name: 'BANK_ACCOUNT'			, text: '계좌번호'			, type: 'string', editable : false},
			{name: 'USER_YN'				, text: '사용유무'			, type: 'string', allowBlank:false, editable : false},
			{name: 'REMARK'					, text: '비고'				, type: 'string', editable : false},
			{name: 'TEMPC_01'				, text: '작업자코드'			, type: 'string', editable : false},
			{name: 'JOIN_DATE'				, text: '입사일'				, type: 'uniDate', editable : false},
			{name: 'BIRTH_DATE'				, text: '생일'				, type: 'uniDate', editable : false},
			{name: 'TEMPC_03'				, text: '생일축하금 제외'		, type: 'string', editable : false},
			                
			
	    ]
	});		// End of Ext.define('Ham800ukrModel', {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 's_hpb100ukrv_mitService.selectDetailList',
        	update: 's_hpb100ukrv_mitService.updateDetail',
			syncAll: 's_hpb100ukrv_mitService.saveAll'
        }
	});
	var tempStore = Unilite.createStore('tempStore',{
		uniOpt: {
            isMaster: false,     // 상위 버튼 연결 
            editable: false,     // 수정 모드 사용 
            deletable: false,        // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        }
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('s_hpb100ukrv_mitMasterStore1',{
		model: 's_hpb100ukrv_mitModel',
		uniOpt: {
            isMaster: true,		// 상위 버튼 연결 
            editable: true,		// 수정 모드 사용 
            deletable: false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
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
            var paramMaster= detailForm.getValues();   //syncAll 수정
            paramMaster.AUTO_CODE = BsaCodeInfo.gsAutoCode;
        	var rv = true;
			if(inValidRecs.length == 0 )	{										
				config = {
					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						//directMasterStore.loadStoreRecords();	
						Ext.getCmp('DED_TYPE').setReadOnly(true);
						Ext.getCmp('PERSON_NUMB').setReadOnly(true);
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
    var masterGrid = Unilite.createGrid('s_hpb100ukrv_mitGrid1', {
    	itemId:'masterGrid',
    	layout : 'fit',
        region : 'west',
        flex  : 1,
		store: directMasterStore,
		uniOpt: {
			expandLastColumn: false,
        	useRowNumberer: false,
            useMultipleSorting: false,
		    state: {
			    useState: false,
			    useStateList: false
		    }
        },
        columns: [        
        	{dataIndex: 'DED_TYPE'				, width: 100 , hidden :true },
        	{dataIndex: 'PERSON_NUMB'			, width: 100}, 
			{dataIndex: 'DED_CODE'				, width: 100 , hidden :true},
			{dataIndex: 'NAME'					, width: 100 , flex: 1},
			{dataIndex: 'ZIP_CODE'				, width: 100 , hidden :true },
			{dataIndex: 'KOR_ADDR'				, width: 100 , hidden :true },
			{dataIndex: 'TELEPHONE'				, width: 100 , hidden :true },
			{dataIndex: 'BANK_CODE'				, width: 100 , hidden :true },
			{dataIndex: 'BANK_NAME'				, width: 100 , hidden :true },
			{dataIndex: 'BANK_ACCOUNT'			, width: 100 , hidden :true },
			{dataIndex: 'BANK_ACCNT_DEC'		, width: 100 , hidden :true },
			{dataIndex: 'BANK_ACCOUNT_BEFOREUPDATE'  , width: 100 , hidden :true },
			{dataIndex: 'USER_YN'				, width: 100 , hidden :true },
			{dataIndex: 'BIRTH_DATE'	   		, width: 100 , hidden :true },
			{dataIndex: 'REMARK'				, width: 100 , hidden :true }
        ],
 	    listeners: {
            selectionchange: function(grid, selNodes){ 
            	if (typeof selNodes[0] != 'undefined') {
            		detailForm.setActiveRecord(selNodes[0]);
					grid.getStore().loadDetailForm(selNodes[0]);
	            	 
            		detailForm.getForm().getFields().each(function(field) {
    					if (UniUtils.indexOf(field.name, ['DED_TYPE' , 'PERSON_NUMB', 'BANK_NAME', 'BANK_ACCOUNT'] ))  {
    						field.setReadOnly(true);
    					} else {
    						field.setReadOnly(false);
    					}
    				});
    				detailForm.getForm().findField('PERSON_NUMB').setReadOnly(true);
	            	
					
            	}
            }
        }
    });
	/**
	 * 검색조건 (Search Panel)
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
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '신고사업장',
				name: 'SECT_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode: 'BILL',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SECT_CODE', newValue);
					}
				}
			},{
				fieldLabel: '소득자코드',
				name: 'DED_TYPE', 
				xtype: 'hiddenfield',
				allowBlank: false,
				value: gsDED_TYPE,
				hidden:true
			},
			Unilite.popup('EARNER',{
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
							panelSearch.setValue('PERSON_NUMB', '');
                            panelSearch.setValue('NAME', '');
                            panelResult.setValue('PERSON_NUMB', '');
                            panelResult.setValue('NAME', '');
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
							panelSearch.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
							panelResult.setValue('DEPT_CODE', '');
                            panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							
						}
					}
				})
			]
		},{	
			title: '추가정보', 	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '사용여부',
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
		}]
	});	//end panelSearch  
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '신고사업장',
				name: 'SECT_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode: 'BILL',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SECT_CODE', newValue);
					}
				}
			},{
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
							panelSearch.setValue('NAME', '');
							panelResult.setValue('PERSON_NUMB', '');
                            panelResult.setValue('NAME', '');
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
							panelResult.setValue('DEPT_CODE', '');
                            panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							
						}
					}
			}),{
				fieldLabel: '사용여부',
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
			}]
    });
    
    var detailForm = Unilite.createForm('s_hpb100ukrv_mitDetail', {
    	disabled :false,
    	masterGrid: masterGrid,
    	autoScroll:true,
    	padding:'1 1 5 1',
    	flex  : 3,
    	region : 'center'     
        , layout: {type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}}
	    , items :[{
			fieldLabel: '소득자타입',
			name: 'DED_TYPE', 
			id:'DED_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'A118',
			allowBlank:false,
			maxLength: 30,
			value:gsDED_TYPE,
			readOnly: true,
			hidden :true
		},{
			fieldLabel: '소득자코드',
			id : 'PERSON_NUMB',
			name: 'PERSON_NUMB',
			xtype: 'uniTextfield',
			allowBlank:false
		},{
			fieldLabel: '성명',
			name: 'NAME',
			xtype: 'uniTextfield',
			allowBlank:false
		},	Unilite.popup('ZIP',{
				fieldLabel: '주소',
				showValue:false,
				textFieldName:'ZIP_CODE',
				DBtextFieldName:'ZIP_CODE',
				validateBlank:false,
				name: 'ZIP_CODE',
				listeners: { 'onSelected': {
			                    fn: function(records, type  ){
			                    	masterGrid.getSelectedRecord().set('ZIP_CODE', records[0]['ZIP_CODE']);
			                    	masterGrid.getSelectedRecord().set('KOR_ADDR', records[0]['ZIP_NAME']+records[0]['ADDR2']);
			                    	detailForm.setValue('ZIP_CODE', records[0]['ZIP_CODE']);
			                    	detailForm.setValue('KOR_ADDR', records[0]['ZIP_NAME']+records[0]['ADDR2']);
			                    },
			                    scope: this
			                  },
			                  'onClear' : function(type)	{
			                  	  masterGrid.getSelectedRecord().set('ZIP_CODE', '');
			                      masterGrid.getSelectedRecord().set('KOR_ADDR', '');
			                  	  detailForm.setValue('ZIP_CODE', '');
			                	  detailForm.setValue('KOR_ADDR', '');
			                  }
						}
		}),{
	  	 	fieldLabel: '상세주소',
		 	name: 'KOR_ADDR',
		 	hideLabel: true,
		 	width: 245,
		 	margin:'0 0 0 0'
		},{
			fieldLabel: '전화번호',
			name: 'TELEPHONE',
			xtype: 'uniTextfield'
		},{
			fieldLabel: '작업자코드',
			name: 'TEMPC_01',
			xtype: 'uniCombobox',
			store:Ext.data.StoreManager.lookup("workerCode")
		},
		{ 
			fieldLabel: '급여이체은행',
			name: 'BANK_NAME',
			xtype: 'uniTextfield',
			focusable:false
		},{ 
			fieldLabel:'계좌번호',
			name :'BANK_ACCOUNT',
			xtype: 'uniTextfield',
			focusable:false
		 },
		{
			fieldLabel: '계좌번호복호화',
			name: 'BANK_ACCOUNT_DEC',
			xtype: 'uniTextfield',
			colspan:2,
			hidden: true
		},{
			fieldLabel: '사용여부',
			xtype: 'combobox', 
			store: useStore,
            queryMode: 'local',
        	displayField: 'name',
    		valueField: 'value',
			allowBlank:false,
			name: 'USER_YN'
		},{
			fieldLabel: '입사일',
			name: 'JOIN_DATE',
			xtype: 'uniDatefield'
		},{
			fieldLabel: '생일',
			name: 'BIRTH_DATE',
			xtype: 'uniDatefield'
		},{
			fieldLabel: '생일축하금 제외',
			name: 'TEMPC_03',
			inputValue : 'Y',
			xtype: 'checkboxfield'
		},{
	  	 	fieldLabel: '비고',
		 	name: 'REMARK',
		 	colspan:2,
		 	width: 510
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
		id : 's_hpb100ukrv_mitApp',
		fnInitBinding : function() {
			if (!Ext.isEmpty(Ext.data.StoreManager.lookup('billDivCode').getAt(0))) {
                panelSearch.setValue('SECT_CODE',Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
                panelResult.setValue('SECT_CODE',Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
                detailForm.setValue('SECT_CODE' ,Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
            }
			
			detailForm.setValue('DED_TYPE' , gsDED_TYPE);
			detailForm.setValue('DIV_CODE', '01');
			detailForm.setValue('USER_YN', '1');
			
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('newData', false);
			// 처음 구동시 행을 추가하지 않으면 수정이 불가하도록 함
			detailForm.getForm().getFields().each(function(field) {
			      field.setReadOnly(true);
			});
		},
		onQueryButtonDown : function()	{		
			directMasterStore.loadStoreRecords();	
		},
		checkForNewDetail:function() { 			
			return detailForm.setAllFieldsReadOnly(true);
        },
		onSaveDataButtonDown : function() {
            if(!UniAppManager.app.checkForNewDetail()){
                return false;
            }else{
                masterGrid.getStore().saveStore();
            }
		}
	});

	
};


</script>
