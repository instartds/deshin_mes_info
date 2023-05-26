<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpb200ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="A118" /> <!-- 소득자타입 -->
	<t:ExtComboStore comboType="AU" comboCode="HS05" /> <!-- 사업소득구분 -->
	<t:ExtComboStore comboType="AU" comboCode="HS06" /> <!-- 비거주자소득구분 -->
	<t:ExtComboStore comboType="AU" comboCode="HS02" /> <!-- 내외국인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B012" /> <!-- 거주지국가코드 -->
	<t:ExtComboStore comboType="AU" comboCode="HS03" /> <!-- 거주구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B016" /> <!-- 법인/개인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="HS07" /> <!-- 실명거래여부 -->
	<t:ExtComboStore comboType="AU" comboCode="HS10" /> <!-- 필요경비세율 -->
	
	
	<t:ExtComboStore comboType="BOR120"  pgmId="hpb200ukr" /> 			<!-- 사업장 -->	
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
	
	var gsDED_TYPE = '2';
	
	var useStore = Ext.create('Ext.data.Store', {
        id : 'comboStore',
		fields : ['name', 'value'],
        data   : [
            {name : '사용함', value: '1'},
            {name : '사용안함', value: '0'}
        ]
    });
    
    
    Unilite.defineModel('hpb200ukrGubunModel', {
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
	
	var GetGubunStore = Unilite.createStore('hpb100ukrGubunStore',{
		model:'hpb200ukrGubunModel',
        proxy: {
           type: 'direct',
            api: {			
                read: 'hpb200ukrService.getGubun'                	
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
					//detailForm.setValue('DED_CODE' , Ext.data.StoreManager.lookup('CBS_AU_HS05').getAt(0).get('value'));
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
	Unilite.defineModel('hpb200ukrModel', {
	   fields: [
			{name: 'DED_TYPE'				, text: 'DED_TYPE'			, type: 'string', allowBlank:false},
			{name: 'PERSON_NUMB'			, text: '소득자코드'			, type: 'string' , allowBlank:false},
			{name: 'NAME'					, text: '성 명'				, type: 'string' , allowBlank:false},
			{name: 'ENG_NAME'				, text: '영문성명'				, type: 'string'},
			{name: 'DEPT_CODE'				, text: '부서코드'				, type: 'string' , allowBlank:false},
			{name: 'DEPT_NAME'				, text: '부서명'				, type: 'string'},
			{name: 'DIV_CODE'				, text: '소속사업장'			, type: 'string' , allowBlank:false},
			{name: 'SECT_CODE'				, text: '신고사업장'			, type: 'string' , allowBlank:false},
			{name: 'BUSINESS_TYPE'			, text: '법인/개인'			, type: 'string' , allowBlank:false},
			{name: 'KNOWN_YN'				, text: '실명구분'				, type: 'string' , allowBlank:false},
			{name: 'FOREIGN_YN'				, text: '내·외국인'			, type: 'string', allowBlank:false},
			{name: 'NATION_CODE'			, text: '국가코드'				, type: 'string' , allowBlank:false},
			{name: 'REPRE_NUM'				, text: '주민등록번호'			, type: 'string'},
			{name: 'REPRE_NUM_EXPOS'		, text: '주민등록번호'			, type: 'string' },
			{name: 'FOREIGN_NUM'			, text: '외국인등록번호'			, type: 'string'},
			{name: 'FOREIGN_NUM_EXPOS'		, text: '외국인등록번호'			, type: 'string' },
			{name: 'RECOGN_NUM'				, text: '외국인식번호'			, type: 'string'},
			{name: 'DWELLING_YN'			, text: '거주구분'				, type: 'string' , allowBlank:false},
			{name: 'DED_CODE'				, text: '소득코드'				, type: 'string' , allowBlank:false},
			{name: 'EXPS_PERCENT'			, text: '경비세율'				, type: 'string'},
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
			{name: 'BANK_ACCOUNT_EXPOS'		, text: '계좌번호'			    , type: 'string' },
			{name: 'BANK_ACCOUNT_BEFOREUPDATE' , text: 'UPDATE시 계좌번호전값 관련' , type: 'string'},
			{name: 'USER_YN'				, text: '사용유무'				, type: 'string' , allowBlank:false},
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
	});		// End of Ext.define('Ham800ukrModel', {
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'hpb200ukrService.selectList',
        	update: 'hpb200ukrService.updateDetail',
			create: 'hpb200ukrService.insertDetail',
			destroy: 'hpb200ukrService.deleteDetail',
			syncAll: 'hpb200ukrService.saveAll'
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
	var directMasterStore = Unilite.createStore('hpb200ukrMasterStore1',{
		model: 'hpb200ukrModel',
		uniOpt: {
            isMaster: true,		// 상위 버튼 연결 
            editable: true,		// 수정 모드 사용 
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
        saveStore : function(config)    {   
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            console.log("toUpdate",toUpdate);
            var paramMaster= detailForm.getValues();   //syncAll 수정
            paramMaster.AUTO_CODE = BsaCodeInfo.gsAutoCode;
            var rv = true;
    
            
            if(inValidRecs.length == 0 )    {                                       
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
    var masterGrid = Unilite.createGrid('hpb200ukrGrid1', {
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
			{dataIndex: 'NAME'					, width: 100, flex: 1}, 				
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
			{dataIndex: 'EXPS_PERCENT'			, width: 100, hidden: true}, 	//경비세율
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
                  //    detailForm.getForm().findField('PERSON_NUMB').setReadOnly(false);
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
				value: gsDED_TYPE
			},
				Unilite.popup('DEPT',{
		    	fieldLabel: '부서', 
				validateBlank:false,
				autoPopup: false,
				//readOnly: true,
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
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
							panelSearch.setValue('DEPT_CODE', '');
                            panelSearch.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							
						}
					}
				}),
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
				//readOnly: true,
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
	
    var detailForm = Unilite.createForm('hpb200ukrDetail', {
    	disabled :false,
    	region : 'center',  
    	masterGrid: masterGrid,
    	autoScroll:true,
    	padding:'1 1 5 1',
    	flex  : 3
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
				value: gsDED_TYPE,
				readOnly: true
			},{
				fieldLabel: '소득자코드',
				id : 'PERSON_NUMB',
				name: 'PERSON_NUMB',
				xtype: 'uniTextfield',
				allowBlank:false,
				listeners: {
					blur: function(field, event, opt) {
						if (!field.readOnly && field.value != null && field.value != '') {
							console.log(field);							
							masterGrid.getSelectionModel().getSelection()[0].data.PERSON_NUMB = field.value;
							masterGrid.getView().refresh();
						}
					}
				}	
			},{
				fieldLabel: '성명',
				name: 'NAME',
				xtype: 'uniTextfield',
				allowBlank:false,
				listeners: {
					blur: function(field, event, opt) {
						if (!field.readOnly && field.value != null && field.value != '') {
							console.log(field);							
							masterGrid.getSelectionModel().getSelection()[0].data.NAME = field.value;
							masterGrid.getView().refresh();
						}
					}
				}	
			},{
				fieldLabel: '영문성명',
				name: 'ENG_NAME',
				xtype: 'uniTextfield',
				maxLength: 20
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
				value: '1',
				maxLength: 30
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
							detailForm.getForm().findField('REPRE_NUM').focus();
							detailForm.setValue('NATION_CODE' , 'KR');
							//detailForm.getField('NATION_CODE').setReadOnly(true);
							
						}
						else if(newValue == '9'){
							//masterGrid.getSelectedRecord().set('REPRE_NUM', '');
	                  	    detailForm.setValue('REPRE_NUM', '');
							detailForm.getForm().findField('FOREIGN_NUM').focus();
							detailForm.setValue('NATION_CODE' , 'KR');
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
				value: 'KR',
				maxLength: 30
			},
			{ 
				fieldLabel:'주민등록번호',
				name :'REPRE_NUM',
				xtype: 'uniTextfield'				
//				listeners:{
//					afterrender:function(field)	{
//						field.getEl().on('dblclick', field.onDblclick);
//					}
//				},
//				onDblclick:function(event, elm)	{					
//					detailForm.openCryptRepreNoPopup();
//				}
		    },
//		    {
//				fieldLabel: '주민등록번호',
//				name: 'REPRE_NUM',
//				xtype: 'uniTextfield',
//				hidden: true
//			},
			{ 
				fieldLabel:'외국인등록번호',
				name :'FOREIGN_NUM',
				xtype: 'uniTextfield'
//				listeners:{
//					afterrender:function(field)	{
//						field.getEl().on('dblclick', field.onDblclick);
//					}
//				},
//				onDblclick:function(event, elm)	{					
//					detailForm.openCryptForeignNoPopup();
//				}
			},
//			{
//				fieldLabel: '외국인등록번호',
//				name: 'FOREIGN_NUM',
//				xtype: 'uniTextfield',
//				hidden: true
//			},
				{
				fieldLabel: '거주구분',
				name: 'DWELLING_YN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'HS03',
				allowBlank:false,
				maxLength: 30,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						GetGubunStore.loadStoreRecords();	

					}
				}
			},{
				fieldLabel: '소득구분',
				name: 'DED_CODE', 
				xtype: 'uniCombobox',
				store:GetGubunStore,
				allowBlank:false,
				maxLength: 30
			},{
				fieldLabel: '경비세율',
				name: 'EXPS_PERCENT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'HS10',
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
				fieldLabel: '법인명(상호)',
				name: 'COMP_KOR_NAME',
				xtype: 'uniTextfield',
				maxLength: 20
			},{
				fieldLabel: '영문법인명',
				name: 'COMP_ENG_NAME',
				xtype: 'uniTextfield'
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
			 	margin:'0 0 0 0'
			},{
				fieldLabel: '영문사업장주소',
				name: 'COMP_ENG_ADDR',
				xtype: 'uniTextfield',
				colspan:2,
				maxLength: 100,
				width: 510
			},{
				fieldLabel: '전화번호',
				name: 'COMP_TELEPHONE',
				xtype: 'uniTextfield',
				colspan:2,
				maxLength: 20
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
			 	margin:'0 0 0 0'
			},{
				fieldLabel: '영문주소',
				name: 'ENG_ADDR',
				xtype: 'uniTextfield',
				colspan:2,
				maxLength: 100,
				width: 510
			},{
				fieldLabel: '전화번호',
				name: 'TELEPHONE',
				xtype: 'uniTextfield',
				colspan:2
			},
				Unilite.popup('BUSS_OFFICE_CODE',{
					fieldLabel: '소속지점',
					valueFieldName: 'BUSS_OFFICE_CODE',
					textFieldName: 'BUSS_OFFICE_NAME',
					validateBlank: false,
					allowBlank:false,
					colspan:2,
					name: 'BUSS_OFFICE_CODE'
			}),/*{
		  	 	fieldLabel: '상세주소',
			 	name: 'BUSS_OFFICE_NAME',
			 	hideLabel: true,
			 	width: 295,
			 	margin:'0 0 0 -50'
			},*/
				Unilite.popup('BANK',{
					fieldLabel: '급여이체은행',
					valueFieldName: 'BANK_CODE',
					textFieldName: 'BANK_NAME',
					validateBlank: false,
					colspan:2,
					name: 'BANK_CODE'
			}),
			{ 
					fieldLabel:'계좌번호',
					name :'BANK_ACCOUNT',
					xtype: 'uniTextfield'
//					listeners:{
//						afterrender:function(field)	{
//							field.getEl().on('dblclick', field.onDblclick);
//						}
//					},
//					onDblclick:function(event, elm)	{
//						detailForm.openCryptAcntNumPopup();
//					}
			 },
//			 	{
//					fieldLabel: '계좌번호',
//					name: 'BANK_ACCOUNT',
//					xtype: 'uniTextfield',
//					colspan:2,
//					hidden: true
//			},
				Unilite.popup('DEPT',{
					fieldLabel: '소속부서',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					validateBlank: false,
					allowBlank:false,
					colspan:2,
					name: 'DEPT_CODE',
					value: UserInfo.deptCode
			}),
				Unilite.popup('DEPT',{
					fieldLabel: '비용집행부서',
					valueFieldName: 'EXEDEPT_CODE',
					textFieldName: 'EXEDEPT_NAME',
					validateBlank: false,
					colspan:2,
					name: 'EXEDEPT_CODE',
					hidden:true
			}),{
				fieldLabel: '사업장',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank:false,
				name: 'DIV_CODE'
			},
			Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.human.project" default="프로젝트"/>',
				valueFieldName:'PJT_CODE',
				DBvalueFieldName: 'PJT_CODE',
				textFieldName:'PJT_NAME',
				DBtextFieldName: 'PJT_NAME',
				textFieldOnly: false,
				valueFieldWidth: 90,
				textFieldWidth: 140
			}),{
				fieldLabel: '신고사업장',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode: 'BILL',
				allowBlank:false,
				name: 'SECT_CODE'
				
			},
			//20210803 수정 - autoPopup: true 추가
			Unilite.popup('CUST', {
				autoPopup: true
			}),{
				fieldLabel: '사용여부',
				xtype: 'combobox', 
				store: useStore,
                queryMode: 'local',
            	displayField: 'name',
        		valueField: 'value',
				allowBlank:false,
				colspan:2,
				name: 'USER_YN',
				value: '1'
			},{
		  	 	fieldLabel: '비고',
			 	name: 'REMARK',
			 	colspan:2,
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
			}
//			openCryptRepreNoPopup:function(  )	{
//				var record = this;
//								
//				var params = {'REPRE_NO':this.getValue('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
//				Unilite.popupCipherComm('form', record, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
//								
//			},
//			openCryptForeignNoPopup:function(  )	{
//				var record = this;
//								
//				var params = {'FOREIGN_NUM':this.getValue('FOREIGN_NUM'), 'GUBUN_FLAG': '4', 'INPUT_YN': 'Y'};
//				Unilite.popupCipherComm('form', record, 'FOREIGN_NUM_EXPOS', 'FOREIGN_NUM', params);
//								
//			},
//			openCryptAcntNumPopup:function(  )	{
//				var record = this;
//				if(this.activeRecord)	{
//					var params = {'BANK_ACCOUNT':this.getValue('BANK_ACCOUNT'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'};
//					//Unilite.popupCryptCipherCardNo('form', record, 'CRDT_FULL_NUM_EXPOS', 'CRDT_FULL_NUM', params);
//					Unilite.popupCipherComm('form', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);
//				}
//			}
         , listeners : {
         	change: function(field, newValue, oldValue, eOpts) {
            if(!Ext.isEmpty(newValue)){
                    var grdRecord = masterGrid.getSelectedRecord();
                    grdRecord.set('NAME', field.getValue('NAME'));
                    grdRecord.set('ENG_NAME', field.getValue('ENG_NAME'));
                    grdRecord.set('BUSINESS_TYPE', field.getValue('BUSINESS_TYPE'));
                    grdRecord.set('KNOWN_YN', field.getValue('KNOWN_YN'));
                    grdRecord.set('FOREIGN_YN', field.getValue('FOREIGN_YN'));
                    grdRecord.set('NATION_CODE', field.getValue('NATION_CODE'));
                    grdRecord.set('REPRE_NUM', field.getValue('REPRE_NUM'));
                    grdRecord.set('FOREIGN_NUM', field.getValue('FOREIGN_NUM'));
                    grdRecord.set('DWELLING_YN', field.getValue('DWELLING_YN'));
                    grdRecord.set('DED_CODE', field.getValue('DED_CODE'));
                    grdRecord.set('COMP_NUM', field.getValue('COMP_NUM'));
                    grdRecord.set('RECOGN_NUM', field.getValue('RECOGN_NUM'));
                    grdRecord.set('COMP_KOR_NAME', field.getValue('COMP_KOR_NAME'));
                    grdRecord.set('COMP_ENG_NAME', field.getValue('COMP_ENG_NAME'));
                    grdRecord.set('COMP_KOR_ADDR', field.getValue('COMP_KOR_ADDR'));
                    grdRecord.set('COMP_ENG_ADDR', field.getValue('COMP_ENG_ADDR'));
                    grdRecord.set('COMP_TELEPHONE', field.getValue('COMP_TELEPHONE'));
                    grdRecord.set('KOR_ADDR', field.getValue('KOR_ADDR'));
                    grdRecord.set('ENG_ADDR', field.getValue('ENG_ADDR'));
                    grdRecord.set('TELEPHONE', field.getValue('TELEPHONE'));
                    grdRecord.set('BUSS_OFFICE_CODE', field.getValue('BUSS_OFFICE_CODE'));
                    grdRecord.set('BANK_CODE', field.getValue('BANK_CODE'));
                    grdRecord.set('BANK_NAME', field.getValue('BANK_NAME'));
                    grdRecord.set('BANK_ACCOUNT', field.getValue('BANK_ACCOUNT'));
                    grdRecord.set('DEPT_CODE', field.getValue('DEPT_CODE'));
                    grdRecord.set('DEPT_NAME', field.getValue('DEPT_NAME'));
                    grdRecord.set('DIV_CODE', field.getValue('DIV_CODE'));
                    grdRecord.set('SECT_CODE', field.getValue('SECT_CODE'));
                    grdRecord.set('USER_YN', field.getValue('USER_YN'));
                    grdRecord.set('EXPS_PERCENT', field.getValue('EXPS_PERCENT'));
                    grdRecord.set('REMARK', field.getValue('REMARK'));
                    
                    UniAppManager.setToolbarButtons('save', true);
            }else{
                UniAppManager.setToolbarButtons('save', false);
            }
           }
//				dirtychange: function( basicForm, dirty, eOpts ) {
//					console.log("onDirtyChange");
//					UniAppManager.setToolbarButtons('save', true);
//				},
//				// TODO : validate
//				beforeaction: function(basicForm, action, eOpts)	{
//					console.log("action : ",action);
//					console.log("action.type : ",action.type);
//					
//					var foreign_yn = detailForm.getForm().findField('FOREIGN_YN').getValue();
//					var repre_num = detailForm.getForm().findField('REPRE_NUM').getValue();
//					var dwelling_yn = detailForm.getForm().findField('DWELLING_YN').getValue();
//					var foreign_num = detailForm.getForm().findField('FOREIGN_NUM').getValue();
//					var business_type = detailForm.getForm().findField('BUSINESS_TYPE').getValue();
//					var comp_num = detailForm.getForm().findField('COMP_NUM').getValue();
//					var recogn_num = detailForm.getForm().findField('RECOGN_NUM').getValue();
//					var comp_eng_name = detailForm.getForm().findField('COMP_ENG_NAME').getValue();
//					var comp_eng_addr = detailForm.getForm().findField('COMP_ENG_ADDR').getValue();
//					var comp_kor_name = detailForm.getForm().findField('COMP_KOR_NAME').getValue();
//					var eng_name = detailForm.getForm().findField('ENG_NAME').getValue();
//					var eng_addr = detailForm.getForm().findField('ENG_ADDR').getValue();
//					
//					// TODO :focus
//					// 내국인인 경우
//					if (foreign_yn == '1') {
//						if (repre_num == '') {
//							detailForm.getForm().findField('REPRE_NUM').focus();
//							Ext.Msg.alert(Msg.sMB099, Msg.sMHE0007);
//							return false;
//						} else {
//				 			var param={'REPRE_NUM' : repre_num};
//				 			if(Unilite.validate('residentno', repre_num) !== true)  {
//				 				Ext.Msg.confirm(Msg.sMB099, '잘못된 주민번호를 입력하셨습니다. 잘못된 주민번호를 저장하시겠습니까?', function(btn){
//									if (btn == 'no') {
//										detailForm.getForm().findField('REPRE_NUM').setValue('');
//										return false;
//									}
//								});
//				 			}
//				 			hpb200ukrService.chkFamilyRepreNum(param, function(provider, response) {
//									if(provider.data['CNT'] != 0)	{
//										Ext.Msg.confirm(Msg.sMB099, '중복된 주민번호가 존재합니다. 계속 진행하시겠습니까? ', function(btn){
//											if (btn == 'no') {
//												detailForm.getForm().findField('REPRE_NUM').setValue('');
//												return false;
//											}
//										});
//									}
//							});
//						}
//					// 외국인인 경우
//					} else {
//						if (dwelling_yn == '1' && foreign_num == '') {
//							detailForm.getForm().findField('FOREIGN_NUM').focus();
//							Ext.Msg.alert(Msg.sMB099, Msg.sMHE0030);
//							return false;
//						}
//					}
//					// 법인인 경우
//					if (business_type == '1') {
//						if (comp_num == '' && dwelling_yn == '1') {
//							detailForm.getForm().findField('COMP_NUM').focus();
//							Ext.Msg.alert(Msg.sMB099, Msg.sMHE0009);
//							return false;
//						}
//						
//						if (comp_num != '' && dwelling_yn == '1') {
//							if(Unilite.validate('biznno', comp_num) !== true)  {
//								Ext.Msg.confirm(Msg.sMB099, Msg.sMB173+"\n"+Msg.sMB175+"\n", function(btn){
//									if (btn == 'no') {
//										detailForm.getForm().findField('COMP_NUM').setValue('');
//										return false;
//									}
//								});
//				 			}
//						}
//						// 비거주인 경우
//						if (dwelling_yn == '2') {
//							if (recogn_num == '') {
//								detailForm.getForm().findField('RECOGN_NUM').focus();
//								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0031);
//								return false;
//							}
//							if (comp_eng_name == '') {
//								detailForm.getForm().findField('COMP_ENG_NAME').focus();
//								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0032);
//								return false;
//							}
//							if (comp_eng_addr == '') {
//								detailForm.getForm().findField('COMP_ENG_ADDR').focus();
//								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0033);
//								return false;
//							}
//						// 거주인 경우
//						} else {
//							if (comp_kor_name == '') {
//								detailForm.getForm().findField('COMP_KOR_NAME').focus();
//								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0034);
//								return false;
//							}
//						}
//					// 개인인 경우	
//					} else {
//						// 비거주인 경우
//						if (dwelling_yn == '2') {
//							if (eng_name == '') {
//								detailForm.getForm().findField('ENG_NAME').focus();
//								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0036);
//								return false;
//							}
//							if (recogn_num == '') {
//								detailForm.getForm().findField('RECOGN_NUM').focus();
//								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0037);
//								return false;
//							}
//							if (eng_addr == '') {
//								detailForm.getForm().findField('ENG_ADDR').focus();
//								Ext.Msg.alert(Msg.sMB099, Msg.sMHE0038);
//								return false;
//							}
//						}
//					}
//									
//					if(action.type =='directsubmit')	{
//						var invalid = this.getForm().getFields().filterBy(function(field) {
//						            return !field.validate();
//						    });
//				        	
//			         	if(invalid.length > 0)	{
//				        	r=false;
//				        	var labelText = ''
//				        	
//				        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
//				        		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
//				        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
//				        		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
//				        	}
//				        	Ext.Msg.alert('확인', labelText+Msg.sMB083);
//				        	invalid.items[0].focus();
//				        	return false;
//			         	}
//					}
//				}	
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
		id : 'hpb200ukrApp',
		fnInitBinding : function() {
			if (!Ext.isEmpty(Ext.data.StoreManager.lookup('billDivCode').getAt(0))) {
                panelSearch.setValue('SECT_CODE',Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
                panelResult.setValue('SECT_CODE',Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
                detailForm.setValue('SECT_CODE' ,Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
            }
			detailForm.setValue('DEPT_CODE', UserInfo.deptCode);
			detailForm.setValue('DEPT_NAME', UserInfo.deptName);
			
			
			detailForm.setValue('DED_TYPE' , gsDED_TYPE);
			//detailForm.setValue('DED_CODE' , Ext.data.StoreManager.lookup('CBS_AU_HS05').getAt(0).get('value'));
			detailForm.setValue('BUSINESS_TYPE', '2');
			detailForm.setValue('KNOWN_YN' ,'1');
			detailForm.setValue('FOREIGN_YN', '1');
			detailForm.setValue('NATION_CODE', 'KR');
			detailForm.setValue('DWELLING_YN' , '1');
			detailForm.setValue('DIV_CODE', '01');
			detailForm.setValue('USER_YN', '1');
			
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('newData', true);
			// 처음 구동시 행을 추가하지 않으면 수정이 불가하도록 함
			detailForm.getForm().getFields().each(function(field) {
			      field.setReadOnly(true);
			});
			GetGubunStore.loadStoreRecords();
		},
		onQueryButtonDown : function()	{		
			directMasterStore.loadStoreRecords();				
		},
		onNewDataButtonDown : function() {
			/*if (masterGrid.getStore().isDirty()) {
				Ext.Msg.alert('확인', '한번에 한건의 데이터만 수정, 입력이 가능 합니다.');
				return false;
			} else {*/
			var param={'COMP_CODE' : UserInfo.compCode};
			hpb200ukrService.fnGetBusinessCode(param, function(provider, response) {
                if(!Ext.isEmpty(provider))  {
                    masterGrid.createRow({
                    DED_TYPE: gsDED_TYPE, 
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
                    
                    if(BsaCodeInfo.gsAutoCode == 'Y'){     //PERSON_NUMB 자동채번 관련
                        var autoPersonNumb = '';
                        var cnt = 0;
                        var recordsAll = directMasterStore.data.items;
                        
                        Ext.each(recordsAll, function(rec,i){
                            if(rec.phantom == true){
                            cnt = cnt + 1;
                            }
                        });
                        if(cnt == 1){
                            hpb100ukrService.getAutoCustomCode({}, function(provider,response){
                                if(!Ext.isEmpty(provider)){
                                    detailForm.setValue('PERSON_NUMB',provider.CUSTOM_CODE);
                                }
                                detailForm.getForm().findField('NAME').focus();
                            });
                        }else{
                            tempStore.clearData();
                            Ext.each(recordsAll, function(rec,i){
                                if(rec.phantom == true){
                                    tempStore.insert(i, rec);
                                }
                            });
                            
                            autoPersonNumb = (parseInt(tempStore.max('PERSON_NUMB'))+1).toString();
                     
                            if(autoPersonNumb.length < 6){
                                if(!Ext.isEmpty(autoPersonNumb)){
                                    var zero = ''
                                    for(var i = 0; i < 6 - autoPersonNumb.length; i++){
                                        zero += '0'
                                    }
                                    autoPersonNumb = zero + autoPersonNumb;
                                }                               
                            }
                            
                            detailForm.setValue('PERSON_NUMB',autoPersonNumb);
                        }
                        detailForm.getForm().findField('NAME').focus();
                    }else{
                        detailForm.getForm().findField('PERSON_NUMB').focus();
                    }
                    
                }else{
                    masterGrid.createRow({
                    DED_TYPE: gsDED_TYPE, 
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
                    
                    if(BsaCodeInfo.gsAutoCode == 'Y'){     //PERSON_NUMB 자동채번 관련
                        var autoPersonNumb = '';
                        var cnt = 0;
                        var recordsAll = directMasterStore.data.items;
                        
                        Ext.each(recordsAll, function(rec,i){
                            if(rec.phantom == true){
                            cnt = cnt + 1;
                            }
                        });
                        if(cnt == 1){
                            hpb100ukrService.getAutoCustomCode({}, function(provider,response){
                                if(!Ext.isEmpty(provider)){
                                    detailForm.setValue('PERSON_NUMB',provider.CUSTOM_CODE);
                                }
                                detailForm.getForm().findField('NAME').focus();
                            });
                        }else{
                            tempStore.clearData();
                            Ext.each(recordsAll, function(rec,i){
                                if(rec.phantom == true){
                                    tempStore.insert(i, rec);
                                }
                            });
                            
                            autoPersonNumb = (parseInt(tempStore.max('PERSON_NUMB'))+1).toString();
                     
                            if(autoPersonNumb.length < 6){
                                if(!Ext.isEmpty(autoPersonNumb)){
                                    var zero = ''
                                    for(var i = 0; i < 6 - autoPersonNumb.length; i++){
                                        zero += '0'
                                    }
                                    autoPersonNumb = zero + autoPersonNumb;
                                }                               
                            }
                            
                            detailForm.setValue('PERSON_NUMB',autoPersonNumb);
                        }
                        detailForm.getForm().findField('NAME').focus();
                    }else{
                        detailForm.getForm().findField('PERSON_NUMB').focus();
                    }
                }
            });
			detailForm.getForm().getFields().each(function(field) {
                if(BsaCodeInfo.gsAutoCode == 'Y'){
                    if (field.name != 'DED_TYPE' && field.name != 'PERSON_NUMB') {
                        field.setReadOnly(false);
                    }
                }else{
                    if (field.name != 'DED_TYPE' ) {
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
		checkForNewDetail:function() { 			
			return detailForm.setAllFieldsReadOnly(true);
        },
		
		onSaveDataButtonDown : function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				if(detailForm.getValue('FOREIGN_YN') == '1'){		// 내국인 체크
					if(detailForm.getValue('REPRE_NUM') == ''){
						detailForm.getForm().findField('REPRE_NUM').focus();
						if(detailForm.getValue("BUSINESS_TYPE") == "1"){
                        	Unilite.messageBox("법인등록번호를 입력하여 주십시오.");
                        } else {
                        	Unilite.messageBox("주민등록번호를 입력하여 주십시오.");
                        }
						return false;
					}
				}
				if(detailForm.getValue('FOREIGN_YN') == '9'){		// 외국인체크
					if(detailForm.getValue('FOREIGN_NUM') == ''){
						detailForm.getForm().findField('FOREIGN_NUM').focus();
						Unilite.messageBox("외국인등록번호를 입력하여주십시오.");
						return false;
					}
				}	
				if(detailForm.getValue('BUSINESS_TYPE') == '1'){	//1법인인경우(1법인,2개인)
					if(detailForm.getValue('COMP_NUM') == '' && (detailForm.getValue('DWELLING_YN') == '1')){
						detailForm.getForm().findField('COMP_NUM').focus();
						Unilite.messageBox("사업자등록번호를 입력하여 주십시오.");
						return false;
					}
					
					if(detailForm.getValue('DWELLING_YN') == '2'){	//2비거주인경우만(1거주,2비거주)
						if(detailForm.getValue('RECOGN_NUM') ==''){	
							detailForm.getForm().findField('RECOGN_NUM').focus();
							Unilite.messageBox("법인 비거주시 외국 인식 번호 항목은 입력 필수 항목입니다.");
							return false;
						}
						if(detailForm.getValue('COMP_ENG_NAME') ==''){	
							detailForm.getForm().findField('COMP_ENG_NAME').focus();
							Unilite.messageBox("법인 비거주시 영문법인명 항목은 입력 필수 항목입니다.");
							return false;
						}
						
						if(detailForm.getValue('COMP_ENG_ADDR') ==''){	
							detailForm.getForm().findField('COMP_ENG_ADDR').focus();
							Unilite.messageBox("법인 비거주시 영문사업장주소 항목은 입력 필수 항목입니다.");
							return false;
						}
					}
					else{
						if(detailForm.getValue('COMP_KOR_NAME') ==''){	
							detailForm.getForm().findField('COMP_KOR_NAME').focus();
							Unilite.messageBox("법인 거주시 법인명(상호) 항목은 입력 필수 항목입니다.");
							return false;
						}
					}
				}
				else{
					if(detailForm.getValue('DWELLING_YN') == '2'){ 	//2비거주인경우만(1거주,2비거주)
						if(detailForm.getValue('ENG_NAME') ==''){	
							detailForm.getForm().findField('ENG_NAME').focus();
							Unilite.messageBox("개인 비거주시영문성명 항목은 입력 필수 항목입니다.");
							return false;
						}
						if(detailForm.getValue('RECOGN_NUM') ==''){	
							detailForm.getForm().findField('RECOGN_NUM').focus();
							Unilite.messageBox("개인 비거주시 외국 인식 번호 항목은 입력 필수 항목입니다.");
							return false;
						}
						if(detailForm.getValue('ENG_ADDR') ==''){	
							detailForm.getForm().findField('ENG_ADDR').focus();
							Unilite.messageBox("개인 비거주시 영문주소 항목은 입력 필수 항목입니다.");
							return false;
						}
					}
				}
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
