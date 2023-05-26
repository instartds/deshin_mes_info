<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpb300ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="HS12" /> <!-- 사업소득구분 -->
	<t:ExtComboStore comboType="AU" comboCode="HS06" /> <!-- 비거주자소득구분 -->
	<t:ExtComboStore comboType="AU" comboCode="HS02" /> <!-- 내외국인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B012" /> <!-- 거주지국가코드 -->
	<t:ExtComboStore comboType="AU" comboCode="HS03" /> <!-- 거주구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B016" /> <!-- 법인/개인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="HS07" /> <!-- 실명거래여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B018" /> <!-- 신탁이익여부 -->
	<t:ExtComboStore comboType="BOR120"  pgmId="hpb300ukr"/> 			<!-- 사업장 -->	
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
	var deptData = ${deptData};
	console.log(deptData);
	
	var gsDED_TYPE = '10';
	
	var useStore = Ext.create('Ext.data.Store', {
        id : 'comboStore',
		fields : ['name', 'value'],
        data   : [
            {name : '사용함', value: '1'},
            {name : '사용안함', value: '0'}
        ]
    });
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hpb300ukrModel', {
	   fields: [
			{name: 'DED_TYPE'				, text: 'DED_TYPE'			, type: 'string',allowBlank:false},
			{name: 'PERSON_NUMB'			, text: '소득자코드'			, type: 'string',allowBlank:true},
			{name: 'NAME'					, text: '성 명'				, type: 'string',allowBlank:false},
			{name: 'ENG_NAME'				, text: '영문성명'				, type: 'string'},
			{name: 'DEPT_CODE'				, text: '부서코드'				, type: 'string',allowBlank:false},
			{name: 'DEPT_NAME'				, text: '부서명'				, type: 'string'},
			{name: 'DIV_CODE'				, text: '소속사업장'			, type: 'string',allowBlank:false},
			{name: 'SECT_CODE'				, text: '신고사업장'			, type: 'string',allowBlank:false},
			{name: 'BUSINESS_TYPE'			, text: '법인/개인'			, type: 'string',allowBlank:false},
			{name: 'KNOWN_YN'				, text: '실명구분'				, type: 'string',allowBlank:false},
			{name: 'FOREIGN_YN'				, text: '내·외국인'			, type: 'string',allowBlank:false},
			{name: 'NATION_CODE'			, text: '국가코드'				, type: 'string',allowBlank:false},
			{name: 'REPRE_NUM'				, text: '주민등록번호'			, type: 'string'},
			{name: 'REPRE_NUM_EXPOS'		, text: '주민등록번호'			, type: 'string' , defaultValue: '*************'},
			{name: 'FOREIGN_NUM'			, text: '외국인등록번호'			, type: 'string'},
			{name: 'FOREIGN_NUM_EXPOS'		, text: '외국인등록번호'			, type: 'string' , defaultValue: '*************'},
			{name: 'RECOGN_NUM'				, text: '외국인식번호'			, type: 'string'},
			{name: 'DWELLING_YN'			, text: '거주구분'				, type: 'string',allowBlank:false},
			{name: 'DED_CODE'				, text: '소득코드'				, type: 'string',allowBlank:false},
			{name: 'COMP_NUM'				, text: '사업자등록번호'			, type: 'string'},
			{name: 'COMP_KOR_NAME'			, text: '상호'				, type: 'string'},
			{name: 'COMP_KOR_ADDR'			, text: '회사 주소'				, type: 'string'},
			{name: 'COMP_ZIP_CODE'			, text: '회사 우편번호'			, type: 'string'},
			{name: 'COMP_TELEPHONE'			, text: '회사 전화번호'			, type: 'string'},
			{name: 'COMP_ENG_NAME'			, text: '회사 영문법인명'			, type: 'string'},
			{name: 'COMP_ENG_ADDR'			, text: '회사 영문주소'			, type: 'string'},
			{name: 'ZIP_CODE'				, text: '개인 우편번호'			, type: 'string'},
			{name: 'KOR_ADDR'				, text: '개인 주소'				, type: 'string'},
			{name: 'ENG_ADDR'				, text: '개인 영문주소'			, type: 'string'},
			{name: 'TELEPHONE'				, text: '개인 전화번호'			, type: 'string'},
			{name: 'BANK_CODE'				, text: '은행코드'				, type: 'string'},
			{name: 'BANK_NAME'				, text: '은행명'				, type: 'string'},
			{name: 'BANK_ACCOUNT'			, text: '계좌번호'				, type: 'string'},
			{name: 'BANK_ACCOUNT_DEC'		, text: '계좌번호(복호)'		, type: 'string'},
			{name: 'BANK_ACCOUNT_EXPOS'		, text: '계좌번호'			    , type: 'string' , defaultValue:'*************'},			
			{name: 'USER_YN'				, text: '사용유무'				, type: 'string',allowBlank:false},
			{name: 'BUSS_OFFICE_NAME'		, text: '소속지점명'			, type: 'string'},
			{name: 'BUSS_OFFICE_CODE'		, text: '소속지점'				, type: 'string',allowBlank:false},
			{name: 'EXEDEPT_CODE'	    	, text: '비용집행부서'			, type: 'string'},
			{name: 'EXEDEPT_NAME'	    	, text: '비용집행부서명'			, type: 'string'},
			{name: 'BIRTH_DATE'	    		, text: '생년월일'				, type: 'uniDate'},
			{name: 'TRUST_PROFIT_YN'		, text: '신탁이익여부'			, type: 'string'},
			{name: 'COMP_CODE'				, text: 'COMP_COMP'			, type: 'string'},
			{name: 'INPUT_PGMID'			, text: '입력경로'				, type: 'string'},
			{name: 'REMARK'					, text: '비고'				, type: 'string'},
			{name: 'PJT_CODE'               , text: '프로젝트코드'       	, type: 'string'},
			{name: 'PJT_NAME'               , text: '프로젝트명'       		, type: 'string'},
			{name: 'CUSTOM_CODE'            , text: '거래처코드'       		, type: 'string'},
			{name: 'CUSTOM_NAME'            , text: '거래처명'       		, type: 'string'}
	    ]
	});	
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'hpb300ukrService.selectList',
        	update: 'hpb300ukrService.updateDetail',
			create: 'hpb300ukrService.insertDetail',
			destroy: 'hpb300ukrService.deleteDetail',
			syncAll: 'hpb300ukrService.saveAll'
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
	var directMasterStore = Unilite.createStore('hpb300ukrMasterStore1',{
		model: 'hpb300ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,		// 삭제 가능 여부 
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
            var paramMaster= detailForm.getValues();   
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
						//UniAppManager.app.fnInputClear();////
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
    var masterGrid = Unilite.createGrid('hpb300ukrGrid1', {
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
        	{dataIndex: 'DED_TYPE'				, width: 100, hidden: true}, 				
			{dataIndex: 'PERSON_NUMB'			, width: 120},
			{dataIndex: 'DED_CODE'				, width: 100, hidden: true}, 
			{dataIndex: 'NAME'					, flex: 1}, 				
			{dataIndex: 'ENG_NAME'				, width: 100, hidden: true}, 				
			{dataIndex: 'DEPT_CODE'				, width: 100, hidden: true}, 				
			{dataIndex: 'DEPT_NAME'				, width: 100, hidden: true}, 				
			{dataIndex: 'DIV_CODE'				, width: 100, hidden: true}, 				
			{dataIndex: 'SECT_CODE'				, width: 100, hidden: true}, 				
			{dataIndex: 'BUSINESS_TYPE'			, width: 100, hidden: true}, 				
			{dataIndex: 'KNOWN_YN'				, width: 100, hidden: true}, 				
			{dataIndex: 'FOREIGN_YN'			, width: 100, hidden: true}, 				
			{dataIndex: 'NATION_CODE'			, width: 100, hidden: true}, 				
			{dataIndex: 'REPRE_NUM'				, width: 100, hidden: true}, 				
			{dataIndex: 'FOREIGN_NUM'			, width: 100, hidden: true}, 				
			{dataIndex: 'RECOGN_NUM'			, width: 100, hidden: true}, 				
			{dataIndex: 'DWELLING_YN'			, width: 100, hidden: true}, 				
			{dataIndex: 'COMP_NUM'				, width: 100, hidden: true}, 				
			{dataIndex: 'COMP_KOR_NAME'			, width: 100, hidden: true}, 				
			{dataIndex: 'COMP_KOR_ADDR'			, width: 100, hidden: true}, 
			{dataIndex: 'COMP_ZIP_CODE'			, width: 100, hidden: true}, 				
			{dataIndex: 'COMP_TELEPHONE'		, width: 100, hidden: true}, 				
			{dataIndex: 'COMP_ENG_NAME'			, width: 100, hidden: true}, 				
			{dataIndex: 'COMP_ENG_ADDR'			, width: 100, hidden: true}, 				
			{dataIndex: 'ZIP_CODE'				, width: 100, hidden: true}, 				
			{dataIndex: 'KOR_ADDR'				, width: 100, hidden: true}, 				
			{dataIndex: 'ENG_ADDR'				, width: 100, hidden: true}, 				
			{dataIndex: 'TELEPHONE'				, width: 100, hidden: true}, 				
			{dataIndex: 'BANK_CODE'				, width: 100, hidden: true}, 				
			{dataIndex: 'BANK_NAME'				, width: 100, hidden: true}, 				
			{dataIndex: 'BANK_ACCOUNT'			, width: 100, hidden: true}, 				
			{dataIndex: 'USER_YN'				, width: 100, hidden: true}, 				
			{dataIndex: 'BUSS_OFFICE_NAME'		, width: 100, hidden: true}, 				
			{dataIndex: 'BUSS_OFFICE_CODE'		, width: 100, hidden: true}, 				
			{dataIndex: 'EXEDEPT_CODE'	   		, width: 100, hidden: true},
			{dataIndex: 'EXEDEPT_NAME'	   		, width: 100, hidden: true}, 				
			{dataIndex: 'BIRTH_DATE'	   		, width: 100, hidden: true}, 				
			{dataIndex: 'TRUST_PROFIT_YN'		, width: 100, hidden: true}, 				
			{dataIndex: 'COMP_CODE'				, width: 100, hidden: true}, 				
			{dataIndex: 'INPUT_PGMID'			, width: 100, hidden: true}, 				
			{dataIndex: 'REMARK'				, width: 100, hidden: true}
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
          	},
            selectionchange: function(grid, selNodes){ 
            	if (typeof selNodes[0] != 'undefined') {
					// 행 추가 후 선택이 변할 경우 저장하지 않은 데이터를 저장 할지 확인 함						
						grid.getStore().loadDetailForm(selNodes[0]);
		            	if (selNodes[0].phantom) {
                            if(BsaCodeInfo.gsAutoCode == 'Y'){
                                    detailForm.getForm().getFields().each(function(field) {
                                        if (field.name != 'DED_TYPE' && field.name != 'PERSON_NUMB' ) {
                                            field.setReadOnly(false);
                                        }
                                    });
                                detailForm.getForm().findField('PERSON_NUMB').setReadOnly(true);
                                }else{
                                    detailForm.getForm().findField('PERSON_NUMB').setReadOnly(false);
                                }
//                          detailForm.getForm().findField('PERSON_NUMB').setReadOnly(false);
                        } else {
		            		detailForm.getForm().getFields().each(function(field) {
		    					if (field.name != 'DED_TYPE' && field.name != 'PERSON_NUMB') {
		    						field.setReadOnly(false);
		    					}
		    				});
		    				detailForm.getForm().findField('PERSON_NUMB').setReadOnly(true);
		            	}
					
            		//주민등록번호, 법인등록번호 Label변경
            		UniAppManager.app.fnSetRepreLabel(selNodes[0].get("BUSINESS_TYPE"));
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
				fieldLabel: '소득자타입',
				name: 'DED_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'HS12',
				allowBlank: false,
				value: gsDED_TYPE,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DED_TYPE', newValue);
						UniAppManager.app.onQueryButtonDown();
						detailForm.setValue('DED_TYPE', newValue);
					}
				}
			},{
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
							panelResult.setValue('PERSON_NUMB', '');
							panelResult.setValue('NAME', '');
							panelSearch.setValue('PERSON_NUMB', '');
                            panelSearch.setValue('NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
							popup.setExtParam({'SECT_CODE': panelSearch.getValue('SECT_CODE')});			//신고사업장
						}
					}
				})]
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
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '소득자타입',
				name: 'DED_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'HS12',
				allowBlank: false,
				value:gsDED_TYPE,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DED_TYPE', newValue);
						UniAppManager.app.onQueryButtonDown();
						detailForm.setValue('DED_TYPE', newValue);
					}
				}
			},{
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
			},
			Unilite.popup('EARNER',{
		    	fieldLabel: '소득자', 
				validateBlank:false,
				autoPopup: false,
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
	
    
    var detailForm = Unilite.createForm('hpb300ukrDetail', {
    	disabled :false,
    	masterGrid: masterGrid,
    	autoScroll:true,
    	padding:'1 1 5 1',
    	flex  : 3,
    	region : 'center'  
        , layout: {type: 'uniTable', columns: 3,tdAttrs: {valign:'top'}}
	    , items :[{
				fieldLabel: '소득자타입',
				name: 'DED_TYPE',
				id:'DED_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'HS12',
				allowBlank:false,
				maxLength: 30,
				value: gsDED_TYPE,
				readOnly: true
			},{
				fieldLabel: '소득자코드',
				id : 'PERSON_NUMB',
				name: 'PERSON_NUMB',
				xtype: 'uniTextfield',
				allowBlank:false,
				colspan:2,
				listeners: {
//					blur: function(field, event, opt) {
//						if (!field.readOnly && field.value != null && field.value != '') {
//							console.log(field);							
//							masterGrid.getSelectionModel().getSelection()[0].data.PERSON_NUMB = field.value;
//							masterGrid.getView().refresh();
//						}
//					}
				}	
			},{
				fieldLabel: '성명',
				name: 'NAME',
				xtype: 'uniTextfield',
				allowBlank:false,
				listeners: {
//					blur: function(field, event, opt) {
//						if (!field.readOnly && field.value != null && field.value != '') {
//							console.log(field);							
//							masterGrid.getSelectionModel().getSelection()[0].data.NAME = field.value;
//							masterGrid.getView().refresh();
//						}
//					}
				}	
			},{
				fieldLabel: '영문성명',
				name: 'ENG_NAME',
				xtype: 'uniTextfield',
				maxLength: 20
			},{
				xtype:'container',
				html: '&nbsp&nbsp※여권영문성명 전부기재 ',
				style: {
					color: 'blue'				
				}
			},{
				fieldLabel: '법인/개인 구분',
				name: 'BUSINESS_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B016',
				allowBlank:false,
				maxLength: 30,
				listeners:{
					change:function(field, newValue, oldValue)	{
						if(!detailForm.uniOpt.inLoading)	{
							//주민등록번호, 법인등록번호 Label변경
							UniAppManager.app.fnSetRepreLabel(newValue);
						} 
						
					}
				}
			},{
				fieldLabel: '실명여부',
				name: 'KNOWN_YN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'HS07',
				allowBlank:false,
				maxLength: 30,
				colspan:2
			},{
				fieldLabel: '외국인여부',
				name: 'FOREIGN_YN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'HS02',
				allowBlank:false,
				maxLength: 30,
				listeners :{
					change: function(field, newValue, oldValue, eOpts) {						
						if(newValue == '1'){
							//masterGrid.getSelectedRecord().set('FOREIGN_NUM', '');
	                  	    detailForm.setValue('FOREIGN_NUM', '');
	                  	    detailForm.setValue('NATION_CODE' , 'KR');
							detailForm.getForm().findField('REPRE_NUM').focus();
							//detailForm.getField('NATION_CODE').setReadOnly(true);
							
						}
						else if(newValue == '9'){
							//masterGrid.getSelectedRecord().set('REPRE_NUM', '');
	                  	    detailForm.setValue('REPRE_NUM', '');
	                  	    detailForm.setValue('NATION_CODE' , 'KR');
							detailForm.getForm().findField('FOREIGN_NUM').focus();
							//detailForm.getField('NATION_CODE').setReadOnly(false);
						}
					}
				}
			},{
				fieldLabel: '국가코드',
				name: 'NATION_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B012',// TODO : replace it!
				allowBlank:false,
				maxLength: 30,
				colspan:2
			},{ 
				fieldLabel:'주민등록번호',
				name :'REPRE_NUM_EXPOS',
				xtype: 'uniTextfield',
				readOnly:true,
				hidden: true,
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
				name: 'REPRE_NUM',
				xtype: 'uniTextfield'
			},
			{ 
				fieldLabel:'외국인등록번호',
				name :'FOREIGN_NUM_EXPOS',
				xtype: 'uniTextfield',
				readOnly:true,
				focusable:false,
				hidden: true,
				colspan:2,
				listeners:{
					afterrender:function(field)	{
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{					
					detailForm.openCryptForeignNoPopup();
				}
			},{
				fieldLabel: '외국인등록번호',
				name: 'FOREIGN_NUM',
				id  : 'FOREIGN_NUM',
				xtype: 'uniTextfield',
				colspan:2
			},{
				fieldLabel: '거주구분',
				name: 'DWELLING_YN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'HS03',
				allowBlank:false,
				maxLength: 30
			},
			Unilite.popup('SAUP_POPUP_SINGLE',{
				fieldLabel: '소득자구분',
				textFieldName: 'DED_CODE',
				//textFieldName: 'DED_NAME',
				validateBlank: false,
				colspan:2,
				allowBlank:false,
				listeners: {
					'onSelected': {
						fn: function(records, type) {
								console.log('records : ', records);
								
								var newValue = records[0].SAUP_POPUP_CODE; 
								
								if(detailForm.getValue('BUSINESS_TYPE') == 2 && (newValue == '211' || newValue == '222')){
									alert('법인/개인 구분을 확인하세요.');	
									detailForm.setValue('DED_CODE', '');
									detailForm.getForm().findField('DED_CODE').focus();
							        return;
								}
								else if(detailForm.getValue('BUSINESS_TYPE') == 1 && (newValue == '111' || newValue == '112' || newValue == '121' 
							        || newValue == '122' || newValue == '131' || newValue == '141' )){
						        	alert('법인/개인 구분을 확인하세요.');   	
						        	detailForm.setValue('DED_CODE', '');
						        	detailForm.getForm().findField('DED_CODE').focus();
							        return;	
						        }
							},
						scope: this
					},
					applyextparam: function(popup){							
						popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
						popup.setExtParam({'PARAM_MAIN_CODE': 'HC01'});							//사업소득자 공통코드
					}
				}
			}),{
				fieldLabel: '생년월일',
				name: 'BIRTH_DATE',
				xtype: 'uniDatefield'
			},{
				fieldLabel: '신탁이익여부',
				name: 'TRUST_PROFIT_YN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B018',
				allowBlank:false,
				colspan:2
			},{
				fieldLabel: '사업자등록번호',
				name: 'COMP_NUM',
				xtype: 'uniTextfield',
				maxLength: 12
			},{
				fieldLabel: '외국 인식번호',
				name: 'RECOGN_NUM',
				xtype: 'uniTextfield'
			},{
				xtype:'container',
				colspan:2,
				html: '&nbsp&nbsp※여권번호, 투자등록번호, 납세번호중 입력',
				style: {
					color: 'blue'				
				}
			},{
				fieldLabel: '법인명(상호)',
				name: 'COMP_KOR_NAME',
				xtype: 'uniTextfield',
				maxLength: 20
			},{
				fieldLabel: '영문법인명',
				name: 'COMP_ENG_NAME',
				xtype: 'uniTextfield'
			},{
				xtype:'container',
				colspan:2,
				html: '&nbsp&nbsp※머리글자 아닌 정식명칭 전부기재',
				style: {
					color: 'blue'				
				}
			},
				Unilite.popup('ZIP',{
					fieldLabel: '사업장주소',
					showValue:false,
					textFieldName:'COMP_ZIP_CODE',
					DBtextFieldName:'COMP_ZIP_CODE',
					validateBlank:false,
					name: 'COMP_ZIP_CODE',
					listeners: { 'onSelected': {
			                    fn: function(records, type  ){
			                    	masterGrid.getSelectedRecord().set('COMP_ZIP_CODE', records[0]['ZIP_CODE']);
			                    	masterGrid.getSelectedRecord().set('COMP_KOR_ADDR', records[0]['ZIP_NAME']/*+records[0]['ADDR2']*/);
			                    	detailForm.setValue('COMP_ZIP_CODE', records[0]['ZIP_CODE']);
			                    	detailForm.setValue('COMP_KOR_ADDR', records[0]['ZIP_NAME']/*+records[0]['ADDR2']*/);
			                    },
			                    scope: this
			                  },
			                  'onClear' : function(type)	{
			                  	  masterGrid.getSelectedRecord().set('COMP_ZIP_CODE', '');
			                      masterGrid.getSelectedRecord().set('COMP_KOR_ADDR', '');
			                  	  detailForm.setValue('COMP_ZIP_CODE', '');
			                	  detailForm.setValue('COMP_KOR_ADDR', '');
			                  }
						}
			}),{
    	  	 	fieldLabel: '상세주소',
			 	name: 'COMP_KOR_ADDR',
			 	hideLabel: true,
			 	width: 245,
			 	margin:'0 0 0 0',
			 	colspan:2
			},{
				fieldLabel: '영문사업장주소',
				name: 'COMP_ENG_ADDR',
				xtype: 'uniTextfield',
				colspan:3,
				maxLength: 100,
				width: 510,
				colspan:3
			},{
				fieldLabel: '전화번호',
				name: 'COMP_TELEPHONE',
				xtype: 'uniTextfield',
				colspan:2,
				maxLength: 20,
				colspan:3
			},
				Unilite.popup('ZIP',{
					fieldLabel: '개인주소',
					showValue:false,
					textFieldName:'ZIP_CODE',
					DBtextFieldName:'ZIP_CODE',
					validateBlank:false,
					name: 'ZIP_CODE',
					listeners: { 'onSelected': {
				                    fn: function(records, type  ){
				                    	masterGrid.getSelectedRecord().set('ZIP_CODE', records[0]['ZIP_CODE']);
				                    	masterGrid.getSelectedRecord().set('KOR_ADDR', records[0]['ZIP_NAME']/*+records[0]['ADDR2']*/);
				                    	detailForm.setValue('ZIP_CODE', records[0]['ZIP_CODE']);
				                    	detailForm.setValue('KOR_ADDR', records[0]['ZIP_NAME']/*+records[0]['ADDR2']*/);
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
			 	margin:'0 0 0 0',
			 	colspan:2
			},{
				fieldLabel: '영문주소',
				name: 'ENG_ADDR',
				xtype: 'uniTextfield',
				colspan:2,
				maxLength: 100,
				width: 510,
				colspan:3
			},{
				fieldLabel: '전화번호',
				name: 'TELEPHONE',
				xtype: 'uniTextfield',
				colspan:3
			},
				Unilite.popup('BUSS_OFFICE_CODE',{
					fieldLabel: '소속지점',
					valueFieldName: 'BUSS_OFFICE_CODE',
					textFieldName: 'BUSS_OFFICE_NAME',
					validateBlank: false,
					allowBlank:false,
					colspan:3,
					name: 'BUSS_OFFICE_CODE'
			}),
				Unilite.popup('BANK',{
					fieldLabel: '급여이체은행',
					valueFieldName: 'BANK_CODE',
					textFieldName: 'BANK_NAME',
					validateBlank: false,
					colspan:3,
					name: 'BANK_CODE'
			}),
			{ 
					fieldLabel:'계좌번호',
					name :'BANK_ACCOUNT_EXPOS',
					xtype: 'uniTextfield',
					readOnly:true,
					hidden: true,
					focusable:false,
					//hideLabel:true,
					listeners:{
						afterrender:function(field)	{
							field.getEl().on('dblclick', field.onDblclick);
						}
					},
					onDblclick:function(event, elm)	{
						detailForm.openCryptAcntNumPopup();
					}
			},{
				fieldLabel: '계좌번호',
				name: 'BANK_ACCOUNT',
				xtype: 'uniTextfield'
			},{
				xtype:'container',
				colspan:2,
				html: '&nbsp&nbsp※주주번호,채권관리고유번호,전표번호등 입력가능 ',
				style: {
					color: 'blue'				
				}
			},
				Unilite.popup('DEPT',{
					fieldLabel: '소속부서',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					validateBlank: false,
					colspan:3,
					name: 'DEPT_CODE',
					value: UserInfo.deptCode
			}),
				Unilite.popup('DEPT',{
					fieldLabel: '비용집행부서',
					valueFieldName: 'EXEDEPT_CODE',
					textFieldName: 'EXEDEPT_NAME',
					validateBlank: false,
					colspan:3,
					name: 'EXEDEPT_CODE',
                    hidden:true
			}),{
				fieldLabel: '사업장',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank:false,
				name: 'DIV_CODE'
			},Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.human.project" default="프로젝트"/>',
				valueFieldName:'PJT_CODE',
				DBvalueFieldName: 'PJT_CODE',
				textFieldName:'PJT_NAME',
				DBtextFieldName: 'PJT_NAME',
				textFieldOnly: false,
				valueFieldWidth: 90,
				textFieldWidth: 140,
				colspan : 2
			}),{
				fieldLabel: '신고사업장',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode: 'BILL',
				allowBlank:false,
				name: 'SECT_CODE'
			},
			//20210803 수정 - autoPopup: true 추가
			Unilite.popup('CUST',{
				autoPopup	: true,
				colspan		: 2
			}),{
				fieldLabel: '사용여부',
				xtype: 'combobox', 
				store: useStore,
                queryMode: 'local',
            	displayField: 'name',
        		valueField: 'value',
				allowBlank:false,
				colspan:3,
				name: 'USER_YN',
				value: '1'
			},{
		  	 	fieldLabel: '비고',
			 	name: 'REMARK',
			 	colspan:3,
			 	width: 490
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
			},
			openCryptRepreNoPopup:function(  )	{
				var record = this;
								
				var params = {'REPRE_NO':this.getValue('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
				Unilite.popupCipherComm('form', record, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
								
			},
			openCryptForeignNoPopup:function(  )	{
				var record = this;
								
				var params = {'FOREIGN_NUM':this.getValue('FOREIGN_NUM'), 'GUBUN_FLAG': '4', 'INPUT_YN': 'Y'};
				Unilite.popupCipherComm('form', record, 'FOREIGN_NUM_EXPOS', 'FOREIGN_NUM', params);
								
			},
			openCryptAcntNumPopup:function(  )	{
				var record = this;
				if(this.activeRecord)	{
					var params = {'BANK_ACCOUNT':this.getValue('BANK_ACCOUNT'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'};
					//Unilite.popupCryptCipherCardNo('form', record, 'CRDT_FULL_NUM_EXPOS', 'CRDT_FULL_NUM', params);
					Unilite.popupCipherComm('form', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);
				}
			}
			/*
			listeners : {
				dirtychange: function( basicForm, dirty, eOpts ) {
					console.log("onDirtyChange");
					UniAppManager.setToolbarButtons('save', true);
				},
				// TODO : validate
				beforeaction: function(basicForm, action, eOpts)	{
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
							Ext.Msg.alert(Msg.sMB099, Msg.sMHE0007);
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
				 			hpb300ukrService.chkFamilyRepreNum(param, function(provider, response) {
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
							Ext.Msg.alert(Msg.sMB099, Msg.sMHE0030);
							return false;
						}
					}
					// 법인인 경우
					if (business_type == '1') {
						if (comp_num == '' && dwelling_yn == '1') {
							detailForm.getForm().findField('COMP_NUM').focus();
							Ext.Msg.alert(Msg.sMB099, Msg.sMHE0009);
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
								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0031);
								return false;
							}
							if (comp_eng_name == '') {
								detailForm.getForm().findField('COMP_ENG_NAME').focus();
								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0032);
								return false;
							}
							if (comp_eng_addr == '') {
								detailForm.getForm().findField('COMP_ENG_ADDR').focus();
								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0033);
								return false;
							}
						// 거주인 경우
						} else {
							if (comp_kor_name == '') {
								detailForm.getForm().findField('COMP_KOR_NAME').focus();
								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0034);
								return false;
							}
						}
					// 개인인 경우	
					} else {
						// 비거주인 경우
						if (dwelling_yn == '2') {
							if (eng_name == '') {
								detailForm.getForm().findField('ENG_NAME').focus();
								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0036);
								return false;
							}
							if (recogn_num == '') {
								detailForm.getForm().findField('RECOGN_NUM').focus();
								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0037);
								return false;
							}
							if (eng_addr == '') {
								detailForm.getForm().findField('ENG_ADDR').focus();
								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0038);
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
				        	Ext.Msg.alert('확인', labelText+Msg.sMB083);
				        	invalid.items[0].focus();
				        	return false;
			         	}
					}
				}
		}*/	
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
		id : 'hpb300ukrApp',
		fnInitBinding : function() {
			if (!Ext.isEmpty(Ext.data.StoreManager.lookup('billDivCode').getAt(0))) {
                panelSearch.setValue('SECT_CODE',Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
                panelResult.setValue('SECT_CODE',Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
                detailForm.setValue('SECT_CODE' ,Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
            }
			detailForm.setValue('DED_TYPE' , panelSearch.getValue('DED_TYPE'));
			detailForm.setValue('BUSINESS_TYPE', '2');
			detailForm.setValue('KNOWN_YN' ,'1');
			detailForm.setValue('FOREIGN_YN', '1');
			detailForm.setValue('NATION_CODE', 'KR');
			detailForm.setValue('DWELLING_YN' , '1');
			detailForm.setValue('DIV_CODE', '01');
			detailForm.setValue('USER_YN', '1');
			detailForm.setValue('TRUST_PROFIT_YN', '2');
			
			
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('newData', true);
			// 처음 구동시 행을 추가하지 않으면 수정이 불가하도록 함
			detailForm.getForm().getFields().each(function(field) {
			      field.setReadOnly(true);
			});
			
		},
		onQueryButtonDown : function()	{	
			if(!panelResult.getInvalidMessage()) return; 
			directMasterStore.loadStoreRecords();				
		},
		checkForNewDetail:function() { 			
			return detailForm.setAllFieldsReadOnly(true);
        },
        fnInputClear:function() {
        	
        	var param={'COMP_CODE' : UserInfo.compCode};
			hpb100ukrService.fnGetBusinessCode(param, function(provider, response) {
				if(provider)	{
					detailForm.setValue('PERSON_NUMB' , '');
					Ext.getCmp('PERSON_NUMB').setReadOnly(false);
		        	detailForm.setValue('NAME' , '');
		        	detailForm.setValue('ENG_NAME' , '');
        			detailForm.setValue('KNOWN_YN' , '1');
        			detailForm.setValue('FOREIGN_YN' , '1');
        			detailForm.setValue('NATION_CODE' , 'KR');
        			detailForm.setValue('REPRE_NUM' , '');
        			
        			Ext.getCmp('FOREIGN_NUM').setReadOnly(false);
        			detailForm.setValue('RECOGN_NUM' , '');
        			detailForm.setValue('DWELLING_YN' , '1');
        			detailForm.setValue('BIRTH_DATE' , '');
        			detailForm.setValue('TRUST_PROFIT_YN' , '2');
        			detailForm.setValue('DED_CODE' , '');
        			detailForm.setValue('COMP_NUM' , '');
        			detailForm.setValue('RECOGN_NUM' , '');
        			
        			detailForm.setValue('COMP_KOR_NAME' , '');
        			detailForm.setValue('COMP_ENG_NAME' , '');
        			detailForm.setValue('COMP_ZIP_CODE' , '');
        			detailForm.setValue('COMP_KOR_ADDR' , '');
        			detailForm.setValue('COMP_ENG_ADDR' , '');
        			detailForm.setValue('COMP_TELEPHONE' , '');
        			detailForm.setValue('ZIP_CODE' , '');
        			detailForm.setValue('KOR_ADDR' , '');
        			detailForm.setValue('ENG_ADDR' , '');
        			detailForm.setValue('TELEPHONE' , '');
        			
        			
        			detailForm.setValue('BUSS_OFFICE_CODE' , '');
        			detailForm.setValue('BUSS_OFFICE_NAME' , '');
        			detailForm.setValue('BANK_CODE' , '');
        			detailForm.setValue('BANK_NAME' , '');
        			detailForm.setValue('BANK_ACCCOUNT' , '');
        			detailForm.setValue('EXEDEPT_CODE' , '');
        			detailForm.setValue('EXEDEPT_NAME' , '');
        			detailForm.setValue('FOREIGN_NUM' , '');
        			detailForm.setValue('DEPT_CODE' , '');
        			
        			detailForm.setValue('DEPT_NAME' , '');
        			detailForm.setValue('USER_YN' , '1');
        			detailForm.setValue('REMARK' , '');
        			
				}
			});
		},
		onNewDataButtonDown : function() {
			if(!panelResult.getInvalidMessage()) return; 
			/*if (masterGrid.getStore().isDirty()) {
				Ext.Msg.alert('확인', '한번에 한건의 데이터만 수정, 입력이 가능 합니다.');
				return false;
			} else {*/
				var param={'COMP_CODE' : UserInfo.compCode};
				hpb100ukrService.fnGetBusinessCode(param, function(provider, response) {
                    if(!Ext.isEmpty(provider))  {
                        masterGrid.createRow({
                        DED_TYPE: panelResult.getValue('DED_TYPE'), 
                        BUSINESS_TYPE: provider[0].SUB_CODE, 
                        KNOWN_YN: 1, 
                        FOREIGN_YN: 1, 
                        NATION_CODE: 'KR', 
                        DWELLING_YN: 1,
                        //DED_CODE: Ext.data.StoreManager.lookup('CBS_AU_HS04').getAt(0).get('value'), //940100,  소득구분 (거주구분1 - 국내 /2 - 해외) 기능필요
                        
                        DEPT_CODE: !Ext.isEmpty(deptData) ? deptData[0].DEPT_CODE : '', 
                        DEPT_NAME: !Ext.isEmpty(deptData) ? deptData[0].DEPT_NAME : '', 
                        
                        SECT_CODE: '01', 
                        DIV_CODE : UserInfo.divCode,
                        COMP_CODE: UserInfo.compCode,
                        USER_YN: 1});
                        
                        //주민등록번호, 법인등록번호 Label변경
    					UniAppManager.app.fnSetRepreLabel(provider[0].SUB_CODE);
                        
                        //자동채번은 서버에서 하도록 변경..
//                        if(BsaCodeInfo.gsAutoCode == 'Y'){     //PERSON_NUMB 자동채번 관련
//                            var autoPersonNumb = '';
//                            var cnt = 0;
//                            var recordsAll = directMasterStore.data.items;
//                            
//                            Ext.each(recordsAll, function(rec,i){
//                                if(rec.phantom == true){
//                                cnt = cnt + 1;
//                                }
//                            });
//                            if(cnt == 1){
//                                hpb100ukrService.getAutoCustomCode({}, function(provider,response){
//                                    if(!Ext.isEmpty(provider)){
//                                        detailForm.setValue('PERSON_NUMB',provider.CUSTOM_CODE);
//                                    }
//                                    detailForm.getForm().findField('NAME').focus();
//                                });
//                            }else{
//                                tempStore.clearData();
//                                Ext.each(recordsAll, function(rec,i){
//                                    if(rec.phantom == true){
//                                        tempStore.insert(i, rec);
//                                    }
//                                });
//                                
//                                autoPersonNumb = (parseInt(tempStore.max('PERSON_NUMB'))+1).toString();
//                         
//                                if(autoPersonNumb.length < 6){
//                                    if(!Ext.isEmpty(autoPersonNumb)){
//                                        var zero = ''
//                                        for(var i = 0; i < 6 - autoPersonNumb.length; i++){
//                                            zero += '0'
//                                        }
//                                        autoPersonNumb = zero + autoPersonNumb;
//                                    }                               
//                                }
//                                
//                                detailForm.setValue('PERSON_NUMB',autoPersonNumb);
//                            }
//                            detailForm.getForm().findField('NAME').focus();
//                        }else{
//                            detailForm.getForm().findField('PERSON_NUMB').focus();
//                        }
                    }else{
                        masterGrid.createRow({
                        DED_TYPE: panelResult.getValue('DED_TYPE'), 
                        BUSINESS_TYPE: '', 
                        KNOWN_YN: 1, 
                        FOREIGN_YN: 1, 
                        NATION_CODE: 'KR', 
                        DWELLING_YN: 1,
                        //DED_CODE: Ext.data.StoreManager.lookup('CBS_AU_HS04').getAt(0).get('value'), //940100,  소득구분 (거주구분1 - 국내 /2 - 해외) 기능필요
                        
                        DEPT_CODE: !Ext.isEmpty(deptData) ? deptData[0].DEPT_CODE : '', 
                        DEPT_NAME: !Ext.isEmpty(deptData) ? deptData[0].DEPT_NAME : '', 
                        
                        SECT_CODE: '01', 
                        DIV_CODE : UserInfo.divCode,
                        COMP_CODE: UserInfo.compCode,
                        USER_YN: 1});
                        //자동채번은 서버에서 하도록 변경..
//                        if(BsaCodeInfo.gsAutoCode == 'Y'){     //PERSON_NUMB 자동채번 관련
//                            var autoPersonNumb = '';
//                            var cnt = 0;
//                            var recordsAll = directMasterStore.data.items;
//                            
//                            Ext.each(recordsAll, function(rec,i){
//                                if(rec.phantom == true){
//                                cnt = cnt + 1;
//                                }
//                            });
//                            if(cnt == 1){
//                                hpb100ukrService.getAutoCustomCode({}, function(provider,response){
//                                    if(!Ext.isEmpty(provider)){
//                                        detailForm.setValue('PERSON_NUMB',provider.CUSTOM_CODE);
//                                    }
//                                    detailForm.getForm().findField('NAME').focus();
//                                });
//                            }else{
//                                tempStore.clearData();
//                                Ext.each(recordsAll, function(rec,i){
//                                    if(rec.phantom == true){
//                                        tempStore.insert(i, rec);
//                                    }
//                                });
//                                
//                                autoPersonNumb = (parseInt(tempStore.max('PERSON_NUMB'))+1).toString();
//                         
//                                if(autoPersonNumb.length < 6){
//                                    if(!Ext.isEmpty(autoPersonNumb)){
//                                        var zero = ''
//                                        for(var i = 0; i < 6 - autoPersonNumb.length; i++){
//                                            zero += '0'
//                                        }
//                                        autoPersonNumb = zero + autoPersonNumb;
//                                    }                               
//                                }
//                                
//                                detailForm.setValue('PERSON_NUMB',autoPersonNumb);
//                            }
//                            detailForm.getForm().findField('NAME').focus();
//                        }else{
//                            detailForm.getForm().findField('PERSON_NUMB').focus();
//                        }
                    }
                });
				detailForm.getForm().getFields().each(function(field) {
                if(BsaCodeInfo.gsAutoCode == 'Y'){
                    if (field.name != 'DED_TYPE' && field.name != 'PERSON_NUMB' && field.name != 'REPRE_NUM_EXPOS' &&  field.name != 'FOREIGN_NUM_EXPOS' &&  field.name != 'BANK_ACCOUNT_EXPOS') {
                        field.setReadOnly(false);
                    }
                }else{
                    if (field.name != 'DED_TYPE' && field.name != 'REPRE_NUM_EXPOS' &&  field.name != 'FOREIGN_NUM_EXPOS' &&  field.name != 'BANK_ACCOUNT_EXPOS') {
                        field.setReadOnly(false);
                    }
                }
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
				
                //alert('저장된 데이터는 삭제할수 없습니다.');
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
		
		/*isOccupied : function() {
			
			isOccupied = false;
			

			if(detailForm.getValue('DWELLING_YN') == ''){	
				detailForm.getForm().findField('DWELLING_YN').focus();
				alert(Msg.sMHE0022);		// 거주구분은 입력필수 항목입니다.
				return false;
			}
			if(detailForm.getValue('DED_CODE') == ''){	
				detailForm.getForm().findField('DED_CODE').focus();
				alert(Msg.sMHE0025);		// 소득구분은 입력필수 항목입니다.
				return false;
			}
			if(detailForm.getValue('TRUST_PROFIT_YN') == ''){	
				detailForm.getForm().findField('TRUST_PROFIT_YN').focus();
				alert(Msg.fsbMsgH0368);		// 신탁이익여부는 입력필수 항목입니다.
				return false;
			}
			if(detailForm.getValue('PERSON_NUMB') == ''){
				detailForm.getForm().findField('PERSON_NUMB').focus();
				alert(Msg.sMHE0026);		// 소득자 코드는 입력필수 항목입니다.
				return false;
			}
			if(detailForm.getValue('NAME') == ''){
				detailForm.getForm().findField('NAME').focus();
				alert(Msg.sMHE0027);		// 성명은 입력필수 항목입니다.
				return false;
			}
			if(detailForm.getValue('BUSINESS_TYPE') == ''){
				detailForm.getForm().findField('BUSINESS_TYPE').focus();
				alert(Msg.sMA0017);		// 법인/개인구분을 입력하십시오.  (Unilite 는 sMHE0021 으로 되어 있음 오타로 예상됨 by.구본선)
				return false;
			}
			if(detailForm.getValue('KNOWN_YN') == ''){
				detailForm.getForm().findField('KNOWN_YN').focus();
				alert(Msg.sMHE0028);		// 실명여부는 입력 필수 항목입니다.
				return false;
			}
			if(detailForm.getValue('FOREIGN_YN') == ''){
				detailForm.getForm().findField('FOREIGN_YN').focus();
				alert(Msg.sMHE0029);		// 외국인여부는 입력 필수 항목입니다.
				return false;
			}
			if(detailForm.getValue('NATION_CODE') == ''){
				detailForm.getForm().findField('NATION_CODE').focus();
				alert(Msg.sMHE0024);		// 국가코드는 입력필수 항목입니다.
				return false;
			}
			if(detailForm.getValue('FOREIGN_YN') == '1'){	// 내국인 경우만
				if(detailForm.getValue('REPRE_NUM') == ''){
					detailForm.getForm().findField('REPRE_NUM').focus();
					alert(Msg.sMHE0007);		// 주민등록번호를 입력하여 주십시오.
					return false;
				}
			}else{
				if(detailForm.getValue('DWELLING_YN') == '1'){	// 외국인 일때
					if(detailForm.getValue('FOREIGN_NUM') == ''){
						detailForm.getForm().findField('FOREIGN_NUM').focus();
						alert(Msg.sMHE0007);		// 외국인등록번호를 입력하여주십시오.
						return false;
					}
				}
			}
			//if(){} // 주민번호 체크 로직 필요
			
			
			if(detailForm.getValue('BUSINESS_TYPE') == '1'){
				if(detailForm.getValue('COMP_NUM') == '' && (detailForm.getValue('DWELLING_YN') == '1')){
					detailForm.getForm().findField('COMP_NUM').focus();
					alert(Msg.sMHE0007);		// 법인등록번호를 입력하여 주십시오.
					return false;
				}
				if(detailForm.getValue('DWELLING_YN') == '2'){	// 비거주 인 경우 ( 1거주 , 2비거주)
					if(detailForm.getValue('RECOGN_NUM') == ''){
						detailForm.getForm().findField('RECOGN_NUM').focus();
						alert(Msg.sMHE0031);		// 법인 비거주시 외국 인식 번호 항목은 입력 필수 항목입니다.
						return false;
					}
					if(detailForm.getValue('COMP_ENG_NAME') == ''){
						detailForm.getForm().findField('COMP_ENG_NAME').focus();
						alert(Msg.sMHE0032);		// 법인 비거주시 영문법인명 항목은 입력 필수 항목입니다.
						return false;
					}
					if(detailForm.getValue('COMP_ENG_ADDR') == ''){
						detailForm.getForm().findField('COMP_ENG_ADDR').focus();
						alert(Msg.sMHE0033);		// 법인 비거주시 영문사업장주소 항목은 입력 필수 항목입니다.
						return false;
					}
				}
				else{
					if(detailForm.getValue('COMP_KOR_NAME') == ''){		// 거주일 경우
						detailForm.getForm().findField('COMP_KOR_NAME').focus();
						alert(Msg.sMHE0034);		// 법인 거주시 법인명(상호) 항목은 입력 필수 항목입니다.
						return false;
					}
					if(detailForm.getValue('COMP_KOR_ADDR') == ''){
						detailForm.getForm().findField('COMP_KOR_ADDR').focus();
						alert(Msg.sMHE0035);		// 법인 거주시 사업장주소 항목은 입력 필수 항목입니다.
						return false;
					}
				}
			}
			if(detailForm.getValue('BUSINESS_TYPE') == '2'){		// 개인일 경우
				if(detailForm.getValue('DWELLING_YN') == '2'){
					if(detailForm.getValue('ENG_NAME') == ''){
						detailForm.getForm().findField('ENG_NAME').focus();
						alert(Msg.sMHE0036);		// 개인 비거주시영문성명 항목은 입력 필수 항목입니다.
						return false;
					}
					if(detailForm.getValue('RECOGN_NUM') == ''){
						detailForm.getForm().findField('RECOGN_NUM').focus();
						alert(Msg.sMHE0037);		// 개인 비거주시 외국 인식 번호 항목은 입력 필수 항목입니다.
						return false;
					}
					if(detailForm.getValue('ENG_ADDR') == ''){
						detailForm.getForm().findField('ENG_ADDR').focus();
						alert(Msg.sMHE0038);		// 개인 비거주시 영문주소 항목은 입력 필수 항목입니다.
						return false;
					}
				}else{
					if(detailForm.getValue('KOR_ADDR') == ''){
						detailForm.getForm().findField('KOR_ADDR').focus();
						alert(Msg.sMHE0039);		// 개인 거주시 개인주소 항목은 입력 필수 항목입니다.
						return false;
					}
				}
			}
			else{
				if(detailForm.getValue('DWELLING_YN') == '2'){
					if(detailForm.getValue('BIRTH_DATE') == ''){
						detailForm.getForm().findField('BIRTH_DATE').focus();
						alert(Msg.fsbMsgH0369);		// 기타개인이면서 비거주자인 경우에는 생년월일을 입력하셔야 합니다
						return false;
					}
				}
			}
			if(detailForm.getValue('SECT_CODE') == ''){
				detailForm.getForm().findField('SECT_CODE').focus();
				alert(Msg.sMB264);		// 신고사업장은 필수 입력항목입니다.
				return false;
			}
			
			var businessType  = detailForm.getValue('BUSINESS_TYPE');
			var saupPopupCode = detailForm.getValue('DED_CODE');
			
			if(businessType == '2' && (saupPopupCode == '211' || saupPopupCode == '222')){
				detailForm.getForm().findField('DED_CODE').focus();
				alert(Msg.sMH1459);
				return false;
			}
			if(businessType == '1' && (saupPopupCode == '111' || saupPopupCode == '112'  || saupPopupCode == '121' 
									|| saupPopupCode == '122' || saupPopupCode == '131'  || saupPopupCode == '141')){
				detailForm.getForm().findField('DED_CODE').focus();
				alert(Msg.sMH1459);
				return false;
			}
			
			isOccupied = true;

		},*/
		
		
		onSaveDataButtonDown : function() {
			
		  if(!UniAppManager.app.checkForNewDetail()){
                return false;
          }else{
           
			if(detailForm.getValue('BUSINESS_TYPE') == '3'){ //기타개인일 시만 주민번호 체크..
			    if(detailForm.getValue('FOREIGN_YN') == '1'){   // 내국인 경우만
                    if(detailForm.getValue('REPRE_NUM') == ''){
                        detailForm.getForm().findField('REPRE_NUM').focus();
                        Unilite.messageBox("주민등록번호를 입력하여 주십시오.");        // 주민등록번호를 입력하여 주십시오.
                        return false;
                    }
                }else{
                    if(detailForm.getValue('DWELLING_YN') == '1'){  // 외국인 일때
                        if(detailForm.getValue('FOREIGN_NUM') == ''){
                            detailForm.getForm().findField('FOREIGN_NUM').focus();
                            Unilite.messageBox("외국인등록번호를 입력하여주십시오.");        // 외국인등록번호를 입력하여주십시오.
                            return false;
                        }
                    }
                }
			}
			
			
			if(detailForm.getValue('BUSINESS_TYPE') == '1'){
				if(detailForm.getValue('COMP_NUM') == '' && (detailForm.getValue('DWELLING_YN') == '1')){
					detailForm.getForm().findField('COMP_NUM').focus();
					Unilite.messageBox("사업자등록번호를 입력하여 주십시오.");		// 법인등록번호를 입력하여 주십시오.
					return false;
				}
				if(detailForm.getValue('DWELLING_YN') == '2'){	// 비거주 인 경우 ( 1거주 , 2비거주)
					if(detailForm.getValue('RECOGN_NUM') == ''){
						detailForm.getForm().findField('RECOGN_NUM').focus();
						Unilite.messageBox("법인 비거주시 외국 인식 번호 항목은 입력 필수 항목입니다.");		// 법인 비거주시 외국 인식 번호 항목은 입력 필수 항목입니다.
						return false;
					}
					if(detailForm.getValue('COMP_ENG_NAME') == ''){
						detailForm.getForm().findField('COMP_ENG_NAME').focus();
						Unilite.messageBox("법인 비거주시 영문법인명 항목은 입력 필수 항목입니다.");		// 법인 비거주시 영문법인명 항목은 입력 필수 항목입니다.
						return false;
					}
					if(detailForm.getValue('COMP_ENG_ADDR') == ''){
						detailForm.getForm().findField('COMP_ENG_ADDR').focus();
						Unilite.messageBox("법인 비거주시 영문사업장주소 항목은 입력 필수 항목입니다.");		// 법인 비거주시 영문사업장주소 항목은 입력 필수 항목입니다.
						return false;
					}
				}
				else{
					if(detailForm.getValue('COMP_KOR_NAME') == ''){		// 거주일 경우
						detailForm.getForm().findField('COMP_KOR_NAME').focus();
						Unilite.messageBox("법인 거주시 법인명(상호) 항목은 입력 필수 항목입니다.");		// 법인 거주시 법인명(상호) 항목은 입력 필수 항목입니다.
						return false;
					}
					if(detailForm.getValue('COMP_KOR_ADDR') == ''){
						detailForm.getForm().findField('COMP_KOR_ADDR').focus();
						Unilite.messageBox("법인 거주시 사업장주소 항목은 입력 필수 항목입니다.");		// 법인 거주시 사업장주소 항목은 입력 필수 항목입니다.
						return false;
					}
				}
			}
			if(detailForm.getValue('BUSINESS_TYPE') == '2'){		// 개인일 경우
				if(detailForm.getValue('DWELLING_YN') == '2'){
					if(detailForm.getValue('ENG_NAME') == ''){
						detailForm.getForm().findField('ENG_NAME').focus();
						Unilite.messageBox("개인 비거주시영문성명 항목은 입력 필수 항목입니다.");		// 개인 비거주시영문성명 항목은 입력 필수 항목입니다.
						return false;
					}
					if(detailForm.getValue('RECOGN_NUM') == ''){
						detailForm.getForm().findField('RECOGN_NUM').focus();
						Unilite.messageBox("개인 비거주시 외국 인식 번호 항목은 입력 필수 항목입니다.");		// 개인 비거주시 외국 인식 번호 항목은 입력 필수 항목입니다.
						return false;
					}
					if(detailForm.getValue('ENG_ADDR') == ''){
						detailForm.getForm().findField('ENG_ADDR').focus();
						Unilite.messageBox("개인 비거주시 영문주소 항목은 입력 필수 항목입니다.");		// 개인 비거주시 영문주소 항목은 입력 필수 항목입니다.
						return false;
					}
				}else{
					if(detailForm.getValue('KOR_ADDR') == ''){
						detailForm.getForm().findField('KOR_ADDR').focus();
						Unilite.messageBox("개인 거주시 개인주소 항목은 입력 필수 항목입니다.");		// 개인 거주시 개인주소 항목은 입력 필수 항목입니다.
						return false;
					}
				}
			}
			else{
				if(detailForm.getValue('DWELLING_YN') == '2'){
					if(detailForm.getValue('BIRTH_DATE') == ''){
						detailForm.getForm().findField('BIRTH_DATE').focus();
						Unilite.messageBox("기타개인이면서 비거주자인 경우에는 생년월일을 입력하셔야 합니다");		// 기타개인이면서 비거주자인 경우에는 생년월일을 입력하셔야 합니다
						return false;
					}
				}
			}
			if(detailForm.getValue('SECT_CODE') == ''){
				detailForm.getForm().findField('SECT_CODE').focus();
				Unilite.messageBox("신고사업장은 필수 입력항목입니다.");		// 신고사업장은 필수 입력항목입니다.
				return false;
			}			
			/*var businessType  = detailForm.getValue('BUSINESS_TYPE');
			var saupPopupCode = detailForm.getValue('DED_CODE');
			
			if(businessType == '2' && (saupPopupCode == '211' || saupPopupCode == '222')){
				
				
				detailForm.getForm().findField('DED_CODE').focus();
				return false;
				alert(Msg.sMH1459);
			}
			if(businessType == '1' && (saupPopupCode == '111' || saupPopupCode == '112'  || saupPopupCode == '121' 
									|| saupPopupCode == '122' || saupPopupCode == '131'  || saupPopupCode == '141')){
				detailForm.setValue('DED_CODE' , '');
				detailForm.getForm().findField('DED_CODE').focus();	
				return false;
				alert(Msg.sMH1459);
			}*/
			masterGrid.getStore().saveStore();
           }
		},
		fnSetRepreLabel:function(businessType)	{
			if(businessType == "1"){
				detailForm.getField("REPRE_NUM").setFieldLabel("법인등록번호");
			} else {
				detailForm.getField("REPRE_NUM").setFieldLabel("주민등록번호");
			}
		}
	});
	
};


</script>
