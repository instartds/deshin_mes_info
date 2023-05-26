<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum300ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B012" /> <!-- 거주지국가코드 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H012" /> <!-- 입사방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H112" /> <!-- 퇴직계산분류 -->
	<t:ExtComboStore comboType="BOR120"  pgmId="hum300ukr"  /> 			<!-- 사업장 -->	
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
</script>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum300ukrModel', {
	   fields: [
			{name: 'PERSON_NUMB'			, text: '소득자코드'			, type: 'string',allowBlank:false},
			{name: 'NAME'					, text: '성 명'				, type: 'string',allowBlank:false},
			{name: 'DIV_CODE'				, text: '사업장'				, type: 'string',allowBlank:false  , comboCode:'BOR120'},
			{name: 'POST_CODE'				, text: '직위'				, type: 'string',allowBlank:false, comboType :'AU' , comboCode:'H005'},
			{name: 'DEPT_CODE'				, text: '부서코드'				, type: 'string',allowBlank:false},
			{name: 'DEPT_NAME'				, text: '부서명'				, type: 'string'},
			{name: 'EMPLOY_TYPE'			, text: '사원구분'				, type: 'string' , comboType :'AU' , comboCode:'H024' },
			{name: 'JOIN_DATE'				, text: '입사일'				, type: 'uniDate',allowBlank:false},
			{name: 'JOIN_CODE'				, text: '입사방식'				, type: 'string', comboType :'AU' , comboCode:'H012'},
			{name: 'PAY_GUBUN'				, text: '고용형태'				, type: 'string' , comboType :'AU' , comboCode:'H011' , defaultValue : '2'},
			{name: 'PAY_GUBUN2'				, text: '고용형태2'			, type: 'string' , comboType :'AU' , comboCode:'H011' , defaultValue : '1'},
			{name: 'NATION_CODE'			, text: '국적'				, type: 'string',allowBlank:false, comboType :'AU' , comboCode:'B012'},
			{name: 'LIVE_CODE'				, text: '거주지국'				, type: 'string',allowBlank:false, comboType :'AU' , comboCode:'B012'},
			{name: 'REPRE_NUM'				, text: '주민등록번호'			, type: 'string'},
			{name: 'REPRE_NUM_EXPOS'		, text: '주민등록번호'			, type: 'string' , defaultVale : '***************'},
			{name: 'FOREIGN_NUM'			, text: '외국인등록번호'		, type: 'string'},
			{name: 'FOREIGN_NUM_EXPOS'		, text: '외국인등록번호'		, type: 'string' , defaultVale : '***************'},
			{name: 'SEX_CODE'				, text: '성별'				, type: 'string' },
			{name: 'RETR_OT_KIND'			, text: '퇴직계산분류'			, type: 'string', comboType :'AU' , comboCode:'H112'},
			{name: 'ZIP_CODE'				, text: '개인 우편번호'			, type: 'string'},
			{name: 'KOR_ADDR'				, text: '개인 주소'			, type: 'string'},
			{name: 'TELEPHONE'				, text: '개인 전화번호'			, type: 'string'},
			{name: 'BANK_CODE2'				, text: '은행코드'				, type: 'string'},
			{name: 'BANK_NAME2'				, text: '은행명'				, type: 'string'},
			{name: 'BANK_ACCOUNT2'			, text: '계좌번호'				, type: 'string'},
			{name: 'BANK_ACCOUNT2_EXPOS'	, text: '계좌번호'				, type: 'string' },
			{name: 'SECT_CODE'				, text: '신고사업장'			, type: 'string',allowBlank:false,comboCode:'BOR120', comboCode:"BILL"}
			
	    ]
	});		// End of Ext.define('Ham800ukrModel', {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'hum300ukrService.selectList',
        	update: 'hum300ukrService.updateList',
			create: 'hum300ukrService.insertList',
			destroy: 'hum300ukrService.deleteList',
			syncAll: 'hum300ukrService.saveAll'
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
	var directMasterStore = Unilite.createStore('hum300ukrMasterStore1',{
		model: 'hum300ukrModel',
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
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);
            var paramMaster= detailForm.getValues();   //syncAll 수정
        	var rv = true;
			if(inValidRecs.length == 0 )	{										
				config = {
					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						//directMasterStore.loadStoreRecords();	
						detailForm.getField('PERSON_NUMB').setReadOnly(true);
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
	    		} else {
	    			detailForm.clearForm();
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
    var masterGrid = Unilite.createGrid('hum300ukrGrid1', {
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
        	  {dataIndex: 'PERSON_NUMB'			, width : 100      }
        	, {dataIndex: 'NAME'				, width : 200      }
        	, {dataIndex: 'DEPT_CODE'			, width : 100      , hidden : true}
        	, {dataIndex: 'DEPT_NAME'			, width : 100      , hidden : true}
        	, {dataIndex: 'DIV_CODE'			, width : 100      , hidden : true}
        	, {dataIndex: 'POST_CODE'			, width : 100      , hidden : true}
        	, {dataIndex: 'REPRE_NUM'			, width : 100      , hidden : true}
        	, {dataIndex: 'FOREIGN_NUM'			, width : 100      , hidden : true}
        	, {dataIndex: 'SEX_CODE'			, width : 100      , hidden : true}
        	, {dataIndex: 'PAY_GUBUN'			, width : 100      , hidden : true}
        	, {dataIndex: 'PAY_GUBUN2'			, width : 100      , hidden : true}
        	, {dataIndex: 'EMPLOY_TYPE'			, width : 100      , hidden : true}
        	, {dataIndex: 'NATION_CODE'			, width : 100      , hidden : true}
        	, {dataIndex: 'JOIN_DATE'			, width : 100      , hidden : true}
        	, {dataIndex: 'JOIN_CODE'			, width : 100      , hidden : true}
        	, {dataIndex: 'RETR_OT_KIND'		, width : 100      , hidden : true}
        	, {dataIndex: 'ZIP_CODE'			, width : 100      , hidden : true}
        	, {dataIndex: 'KOR_ADDR'			, width : 100      , hidden : true}
        	, {dataIndex: 'TELEPHONE'			, width : 100      , hidden : true}
        	, {dataIndex: 'BANK_NAME'			, width : 100      , hidden : true}
        	, {dataIndex: 'BANK_ACCOUNT2'		, width : 100      , hidden : true}
        	, {dataIndex: 'BANK_ACCOUNT2_DEC'	, width : 100      , hidden : true}
        	, {dataIndex: 'BANK_ACCOUNT2_EXPOS'	, width : 100      , hidden : true}
        	, {dataIndex: 'SECT_CODE'			, width : 100      , hidden : true}
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
 	    		
 	    		
          		detailForm.setActiveRecord(selected);
				if(selected.phantom)	{
					detailForm.getField('PERSON_NUMB').setReadOnly(false);
				} else {
					detailForm.getField('PERSON_NUMB').setReadOnly(true);
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
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SECT_CODE', newValue);
					}
				}
			},
			Unilite.popup('ParttimeEmployee',{
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
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SECT_CODE', newValue);
					}
				}
			},
			Unilite.popup('ParttimeEmployee',{
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
		})]
    });
    
    var detailForm = Unilite.createForm('hum300ukrDetail', {
    	disabled :false,
    	masterGrid: masterGrid,
    	autoScroll:true,
    	padding:'1 1 5 1',
    	flex  : 3,
    	region : 'center' ,    
        layout: {type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}},
	    items :[{
			fieldLabel: '소득자코드',
			name: 'PERSON_NUMB',
			xtype: 'uniTextfield',
			allowBlank:false
		},{
			fieldLabel: '성명',
			name: 'NAME',
			xtype: 'uniTextfield',
			allowBlank:false
		},{
			fieldLabel: '사업장',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank:false,
			name: 'DIV_CODE'
		},{
	  	 	fieldLabel: '직위',
		 	name:'POST_CODE' ,
		 	allowBlank:false,
		 	xtype: 'uniCombobox',
		 	comboType: 'AU',
		 	comboCode: 'H005'
		},
		Unilite.popup('DEPT',{
			fieldLabel: '부서',
			valueFieldName: 'DEPT_CODE',
			textFieldName: 'DEPT_NAME',
			validateBlank: false,
			allowBlank:false
		}),{
			fieldLabel: '사원구분',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode:'H024',
			allowBlank:false,
			name: 'EMPLOY_TYPE'
		},{
			fieldLabel: '입사일',
			name: 'JOIN_DATE',
			xtype: 'uniDatefield'
		},{
            fieldLabel: '입사방식',
            name:'JOIN_CODE' ,
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'H012',
            allowBlank:false
        },{        
            fieldLabel: '고용형태',
            name: 'PAY_GUBUN',
            xtype: 'uniCombobox',
            comboType: 'AU',
			comboCode:'H011',
			allowBlank:false,
			readOnly : true
        },{
            fieldLabel: '국적',
            name:'NATION_CODE' ,
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B012',
            allowBlank:false,
            listeners : {
            	change : function(field, newValue, oldValue) {
            		if(newValue != oldValue && newValue == "KR")	{
            			detailForm.getField("FOREIGN_NUM_EXPOS").setReadOnly(true);
            			detailForm.getField("REPRE_NUM_EXPOS").setReadOnly(false);
            			detailForm.setValue("FOREIGN_NUM", "");
            		} else if(newValue != oldValue && newValue != "KR"){
            			detailForm.getField("FOREIGN_NUM_EXPOS").setReadOnly(false);
            			detailForm.getField("REPRE_NUM_EXPOS").setReadOnly(true);
            			detailForm.setValue("REPRE_NUM", "");
            		}
            	}
            }
        },{        
            fieldLabel: ' ',
            name: 'PAY_GUBUN2',
            xtype: 'uniRadiogroup',
			readOnly : true,
            items:[
                    {
                       boxLabel:'<t:message code="system.label.human.dailyworkers" default="일용"/>',
                       name: 'PAY_GUBUN2',
           				readOnly : true,
                       inputValue:'1'
                    },{
                       boxLabel:'<t:message code="system.label.human.nomal" default="일반"/>',
                       name: 'PAY_GUBUN2',
           				readOnly : true,
                       inputValue:'2'
                    }
            ]
        },{
            fieldLabel: '거주지국',
            name:'LIVE_CODE' ,
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B012',
            allowBlank:false
        },{
			fieldLabel:'주민등록번호',
			name :'REPRE_NUM_EXPOS',
			xtype: 'uniTextfield',
			allowBlank	: true,
			listeners:{
				blur: function(field, event, eOpts ){
					
					if(!Ext.isEmpty(field.lastValue)){
						var newValueChk = field.getValue().replace(/-/g ,'');
						var newValue = newValueChk.replace(/\*/g ,'');

						if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
					 		Unilite.messageBox('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
					 		this.setValue(field.originalValue);
					 		return ;
					 	}								
						
						if(field.lastValue != field.originalValue){
							
		  					if(Unilite.validate('residentno',newValue) != true && !Ext.isEmpty(newValue))	{
						 		if(!confirm("잘못된 주민등록번호를 입력하셨습니다."+"\n"+"잘못된 주민등록번호를 저장하시겠습니까?"))	{
						 			field.setValue(field.originalValue);
						 			return;
						 		}
						 	}
							var param = {
								"DECRYP_WORD" : field.lastValue
							};
							humanCommonService.encryptField(param, function(provider, response)  {
			                    if(!Ext.isEmpty(provider)){
		                        	detailForm.setValue('REPRE_NUM',provider);
			                    }else{
			                    	detailForm.setValue('REPRE_NUM_EXPOS',"");
			                    	detailForm.setValue('REPRE_NUM',"");
			                    }
		                        field.originalValue = field.lastValue; 
		                        
		                        
		                        
		                        if(field.lastValue.length > 6) {
		                            field.lastValue = field.lastValue.replace('-','');
		                            var birth = field.lastValue.substring(0,6);
		                            var checkNo = field.lastValue.substring(6,7);
		                            var sexCheck = field.lastValue.substring(6,7);
		                            var formPanel = detailForm;
		                            
		                            if(checkNo == '1' || checkNo == '2' ||checkNo == '5' || checkNo == '6'){
		                                birth = '19' + birth;
		                            }else if(checkNo == '3' || checkNo == '4' || checkNo == "7" || checkNo == "8" ){
		                                birth = '20' + birth;
		                            }
		                            
		                            if(sexCheck%2==0){
		                            	formPanel.setValue('SEX_CODE','F');
		                            }else{
		                            	formPanel.setValue('SEX_CODE','M');
		                            }
		                        }
		                        
							});
						}
					}else{
						detailForm.setValue('REPRE_NUM',"");
					}
				},
                afterrender:function(field) {
                    field.getEl().on('dblclick', field.onDblclick);
                }
            },
            onDblclick:function(event, elm) {
                var formPanel = detailForm;
				var params = {'INCRYP_WORD':formPanel.getValue('REPRE_NUM')};
                Unilite.popupDecryptCom(params);
            }
		},{ 
			fieldLabel:'외국인등록번호',
			name :'FOREIGN_NUM_EXPOS',
			xtype: 'uniTextfield',
			listeners:{
				blur: function(field, event, eOpts ){
					
					if(!Ext.isEmpty(field.lastValue)){
						var newValueChk = field.getValue().replace(/-/g ,'');
						var newValue = newValueChk.replace(/\*/g ,'');

						if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
					 		Unilite.messageBox('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
					 		this.setValue(field.originalValue);
					 		return ;
					 	}								
						
						if(field.lastValue != field.originalValue){
							
							var param = {
								"DECRYP_WORD" : field.lastValue
							};
							humanCommonService.encryptField(param, function(provider, response)  {
			                    if(!Ext.isEmpty(provider)){
		                        	detailForm.setValue('FOREIGN_NUM',provider);
			                    }else{
			                    	detailForm.setValue('FOREIGN_NUM_EXPOS',"");
			                    	detailForm.setValue('FOREIGN_NUM',"");
			                    }
		                        field.originalValue = field.lastValue; 
		            
							});
						}
					}else{
						detailForm.setValue('FOREIGN_NUM',"");
					}
				},
                afterrender:function(field) {
                    field.getEl().on('dblclick', field.onDblclick);
                }
            },
            onDblclick:function(event, elm) {
                var formPanel = detailForm;
				var params = {'INCRYP_WORD':formPanel.getValue('FOREIGN_NUM')};
                Unilite.popupDecryptCom(params);
            }
		},{
			fieldLabel:'주민등록번호',
			name :'REPRE_NUM',
			xtype: 'uniTextfield',
			hidden : true
		},{
			fieldLabel:'성별',
			name :'SEX_CODE',
			xtype: 'uniTextfield',
			hidden : true
		},{ 
			fieldLabel:'외국인등록번호',
			name :'FOREIGN_NUM',
			xtype: 'uniTextfield',
			hidden : true
		},
			Unilite.popup('ZIP',{
				fieldLabel: '주소',
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
		}),Unilite.popup('BANK',{
			fieldLabel: '급여이체은행',
			valueFieldName: 'BANK_CODE2',
			textFieldName: 'BANK_NAME2',
			validateBlank: false
		}),{
	  	 	fieldLabel: ' ',
		 	name: 'KOR_ADDR',
		 	//hideLabel: true,
		 	width: 345,
		 	margin:'0 0 0 0'
		},{ 
			fieldLabel:'계좌번호',
			name :'BANK_ACCOUNT2_EXPOS',
			xtype: 'uniTextfield',
			listeners:{
				blur: function(field, event, eOpts ){
					
					if(!Ext.isEmpty(field.lastValue)){
						var newValueChk = field.getValue().replace(/-/g ,'');
						var newValue = newValueChk.replace(/\*/g ,'');
						if(field.lastValue != field.originalValue){
							
							var param = {
								"DECRYP_WORD" : field.lastValue
							};
							humanCommonService.encryptField(param, function(provider, response)  {
			                    if(!Ext.isEmpty(provider)){
		                        	detailForm.setValue('BANK_ACCOUNT2',provider);
			                    }else{
			                    	detailForm.setValue('BANK_ACCOUNT2_EXPOS',"");
			                    	detailForm.setValue('BANK_ACCOUNT2',"");
			                    }
		                        field.originalValue = field.lastValue; 
		            
							});
						}
					}else{
						detailForm.setValue('BANK_ACCOUNT2',"");
					}
				},
                afterrender:function(field) {
                    field.getEl().on('dblclick', field.onDblclick);
                }
            },
            onDblclick:function(event, elm) {
                var formPanel = detailForm;
				var params = {'INCRYP_WORD':formPanel.getValue('BANK_ACCOUNT2')};
                Unilite.popupDecryptCom(params);
            }
		},{
			fieldLabel: '계좌번호',
			name: 'BANK_ACCOUNT2',
			xtype: 'uniTextfield',
			hidden : true
		},{
			fieldLabel: '전화번호',
			name: 'TELEPHONE',
			xtype: 'uniTextfield'
		},{
			fieldLabel: '신고사업장',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode: 'BILL',
			allowBlank:false,
			name: 'SECT_CODE'
		},{
            fieldLabel: '<t:message code="system.label.human.retrotkind2" default="퇴직계산분류"/>',
            name:'RETR_OT_KIND',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'H112',
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
		id : 'hum300ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('SECT_CODE', UserInfo.divCode);
			panelResult.setValue('SECT_CODE', UserInfo.divCode);
			
			UniAppManager.setToolbarButtons(['detail'], false);
			UniAppManager.setToolbarButtons(['newData'], true);
		},
		onQueryButtonDown : function()	{		
			directMasterStore.loadStoreRecords();	
		},
		checkForNewDetail:function() { 			
			return detailForm.setAllFieldsReadOnly(true);
        },

		onResetButtonDown: function() {
			detailForm.uniOpt.inLoading = true;
			detailForm.clearForm();
			directMasterStore.loadData({});
			detailForm.getField("FOREIGN_NUM_EXPOS").setReadOnly(false);
			detailForm.getField("REPRE_NUM_EXPOS").setReadOnly(false);
			detailForm.uniOpt.inLoading = false;
			UniAppManager.setToolbarButtons(['delete','deleteAll','save'], false);
			
			panelSearch.clearForm();
		},
		onNewDataButtonDown : function() {
			 var newRecord = masterGrid.createRow({
				    JOIN_DATE : UniDate.get('today'),
                    FOREIGN_YN: 'N', 
                    NATION_CODE: 'KR', 
                    SECT_CODE: '01', 
                    DIV_CODE : UserInfo.divCode,
                    PAY_GUBUN:  '2',						
					PAY_GUBUN2: '1'}, null);    
            detailForm.getForm().findField('PERSON_NUMB').focus();
		},
		onDeleteDataButtonDown: function() {
			if (masterGrid.getStore().getCount == 0) return;
			var selRow = masterGrid.getSelectionModel().getSelection()[0];
			if (selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			} else {
				Unilite.messageBox("등록된 소득자는 삭제할 수 없습니다.");	
			}/* else {
			
				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
					if (btn == 'yes') {
						masterGrid.deleteSelectedRow();
					}
				});
			} */
		},
		onSaveDataButtonDown : function() {
            if(!UniAppManager.app.checkForNewDetail()){
                return false;
            }else{
                if(detailForm.getValue('FOREIGN_YN') == '9'){       // 외국인체크
                    if(detailForm.getValue('FOREIGN_NUM') == '' && detailForm.getValue('REPRE_NUM') == '' ){
                        detailForm.getForm().findField('REPRE_NUM').focus();
                        Unilite.messageBox("주민등록번호나 외국인등록번호를 입력하여주십시오.");
                        return false;
                    }
                }   
                masterGrid.getStore().saveStore();
            }
		}
	});

	
};


</script>
