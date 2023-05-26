<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa940ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H032" /> <!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 사용여부 --> 
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
	Unilite.defineModel('Hpa940ukrModel', {
		fields: [
			{name: 'gubun'    		, text: '전송여부'			, type: 'string', editable: false},
			{name: 'S_COMP_CODE'    , text: '지급년월'			, type: 'string', editable: false},
// 			{name: 'PAY_YYYYMM'    	, text: '지급년월'			, type: 'uniDate'},
			{name: 'PAY_YYYYMM'    	, text: '지급년월'			, type: 'string', editable: false},
			{name: 'SUPP_TYPE'    	, text: '지급구분'			, type: 'string', editable: false},
			{name: 'DIV_CODE'    	, text: '사업장'			, type: 'string', comboType: 'BOR120' , editable: false},
			{name: 'DEPT_CODE'    	, text: '부서코드'			, type: 'string', editable: false},
			{name: 'DEPT_NAME'    	, text: '부서'			, type: 'string', editable: false},
			{name: 'POST_CODE'    	, text: '직위'			, type: 'string', comboType: 'AU', comboCode:'H005' , editable: false},
			{name: 'NAME'    		, text: '성명'			, type: 'string', editable: false},
			{name: 'PERSON_NUMB'    , text: '사번'			, type: 'string', editable: false},
			{name: 'EMAIL_ADDR'    	, text: '이메일'			, type: 'string'},
			{name: 'YEAR_YN'    	, text: '연월차여부'		, type: 'string', editable: false},
			{name: 'WORK_YN'    	, text: '근태여부'			, type: 'string', editable: false},
			{name: 'SEND_RESULT'    , text: '전송결과'			, type: 'string', editable: false},
			{name: 'SEND_MSG'    	, text: '메세지'			, type: 'string', editable: false}
			
		]
	});//End of Unilite.defineModel('Hpa940ukrModel', {
	
		
// 	Unilite.defineModel('Hpa940ukrEmailModel', {
// 		fields: [
// 			{name: 'PERSON_NUMB'    , text: '사번'			, type: 'string'},
// 			{name: 'DEPT_CODE'    	, text: '부서코드'			, type: 'string'},
// 			{name: 'DEPT_NAME'    	, text: '부서'			, type: 'string'},
// 			{name: 'NAME'    		, text: '성명'			, type: 'string'},
// 			{name: 'POST_NAME'    	, text: '직위'			, type: 'string'},
// 			{name: 'BANK_NAME'    	, text: '은행'			, type: 'string'},
// 			{name: 'BANK_ACCOUNT1'   , text: '은행'			, type: 'string'},
// 			{name: 'SUPP_TOTAL_I'    	, text: '지급년월'		, type: 'string'},
// 			{name: 'DED_TOTAL_I'    	, text: '지급구분'		, type: 'string'},
// 			{name: 'REAL_AMOUNT_I'    	, text: '사업장'		, type: 'string'},
// 			{name: 'WEEK_DAY'   , text: '은행'			, type: 'string'},
// 			{name: 'WORK_DAY'    	, text: '지급년월'		, type: 'string'},
// 			{name: 'WORK_TIME'    	, text: '지급구분'		, type: 'string'},
// 			{name: 'YEAR_CRT'    	, text: '사업장'		, type: 'string'},
// 			{name: 'YEAR_ADD'   , text: '은행'			, type: 'string'},
// 			{name: 'MONTH_CRT'    	, text: '지급년월'		, type: 'string'},
// 			{name: 'MON_YEAR_USE'    	, text: '지급구분'		, type: 'string'},
// 			{name: 'MON_YEAR_PROV'    	, text: '사업장'		, type: 'string'},
// 			{name: 'BONUS_STD_I'    	, text: '지급년월'		, type: 'string'},
// 			{name: 'BONUS_RATE'    	, text: '지급구분'		, type: 'string'},
// 			{name: 'BONUS_TOTAL_I'    	, text: '사업장'		, type: 'string'},
// 			{name: 'EMAIL_PWD'    	, text: '이메일'			, type: 'string'}
// 		]
// 	});//End of Unilite.defineModel('Hpa940ukrModel', {
	
// 	var directMasterStore2 = Unilite.createStore('hpa940ukrEmailStore1', {
// 		model: 'Hpa940ukrEmailModel',
// 		uniOpt: {
// 			isMaster: false,			// 상위 버튼 연결 
// 			editable: false,			// 수정 모드 사용 
// 			deletable: false,			// 삭제 가능 여부 
// 			useNavi: false			// prev | newxt 버튼 사용
// 		},
// 		autoLoad: false,
// 		proxy: {
// 			type: 'direct',
// 			api: {			
// 				read: 'hpa940ukrService.selectEmailList'                	
// 			}
// 		},
// 		   : function(){
// 			var param= Ext.getCmp('searchForm').getValues();			
// 			console.log(param);
// 			this.load({
// 				params: param
// 			});
// 		}
// 	});//End of var directMasterStore1 = Unilite.createStore('hpa940ukrMasterStore1', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hpa940ukrMasterStore1', {
		model: 'Hpa940ukrModel',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'hpa940ukrService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		},
		listeners:{
            load:function( store, records, successful, operation, eOpts ){
            	var param = {"S_COMP_CODE": UserInfo.compCode};
                hpa940ukrService.selectsenduser(param, function(provider, response){
                     if(!Ext.isEmpty(provider)){
                     	panelSearch.setValue('FROM_ADDR', provider);
                     	detailForm.setValue('FROM_ADDR1', provider);
                     }
                });
            }
        }
	});//End of var directMasterStore1 = Unilite.createStore('hpa940ukrMasterStore1', {

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
            id: 'search_panel1',
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items: [{
                fieldLabel: '지급년월',
                id: 'PAY_YYYYMM',
                xtype: 'uniMonthfield',
                name: 'PAY_YYYYMM',                    
                value: new Date(),                    
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('PAY_YYYYMM', newValue);
                        var datestr = UniDate.getDbDateStr(newValue);
                        panelSearch.setValue('TITLE', datestr.substring(0,4) +'.' + datestr.substring(4,6)+ ' ' + panelResult.getField('SUPP_TYPE').getRawValue()+ ' ' +'명세서입니다.');
                        detailForm.setValue('TITLE1', datestr.substring(0,4) +'.' + datestr.substring(4,6)+ ' ' + panelResult.getField('SUPP_TYPE').getRawValue()+ ' ' +'명세서입니다.');
                    }
                }
            },{
                fieldLabel: '지급구분',
                id: 'SUPP_TYPE', 
                name: 'SUPP_TYPE', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H032',
                allowBlank: false,
                value: 1,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('SUPP_TYPE', newValue);
                        var datestr = UniDate.getDbDateStr(panelSearch.getValue('PAY_YYYYMM'));
                        panelSearch.setValue('TITLE', datestr.substring(0,4) +'.' + datestr.substring(4,6)+ ' ' + panelResult.getField('SUPP_TYPE').getRawValue()+ ' ' +'명세서입니다.');
                        detailForm.setValue('TITLE1', datestr.substring(0,4) +'.' + datestr.substring(4,6)+ ' ' + panelResult.getField('SUPP_TYPE').getRawValue()+ ' ' +'명세서입니다.');
                    }
                }
                
            }, {
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },
            Unilite.treePopup('DEPTTREE',{
                            fieldLabel: '부서',
                            valueFieldName:'DEPT',
                            textFieldName:'DEPT_NAME' ,
                            valuesName:'DEPTS' ,
                            selectChildren:true,
                            DBvalueFieldName:'TREE_CODE',
                            DBtextFieldName:'TREE_NAME',
                            textFieldWidth:100,
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
                    }),{
                fieldLabel: '지급차수',
                name: 'PAY_PROV_FLAG', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H031',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('PAY_PROV_FLAG', newValue);
                    }
                }
            }]
        },{ 
            title: '추가정보',  
            itemId: 'search_panel2',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items: [{
                id:'FROM_ADDR',
                name:'FROM_ADDR',
                fieldLabel: '보내는 메일',
                xtype: 'uniTextfield',
                allowBlank: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        detailForm.setValue('FROM_ADDR1', newValue);
                    }
                }
            },{
                id :'TITLE',
                name: 'TITLE', 
                fieldLabel: '제목',
                xtype: 'uniTextfield',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        detailForm.setValue('TITLE1', newValue);
                    }
                }
            }
            ,{
                fieldLabel: '비고',
                id:'COMMENTS',
                xtype: 'textareafield',
                name: 'COMMENTS',
                height : 80,
                rowspan:2,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        detailForm.setValue('COMMENTS1', newValue);
                    }
                }
            },{
                fieldLabel: '연차내역출력',
                id :'YEAR_YN',
                name: 'YEAR_YN', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B010',
                value: 'Y',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        detailForm.setValue('YEAR_YN1', newValue);
                    }
                }
            },{
                fieldLabel: '근태내역출력',
                id :'WORK_YN',
                name: 'WORK_YN', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B010',
                value: 'Y',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        detailForm.setValue('WORK_YN1', newValue);
                    }
                }
            }
            
             ,{
                fieldLabel: '금액0 항목출력',
                id :'DETAIL_ZERO',
                name: 'DETAIL_ZERO', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B010',
                value: 'Y',
                width: 200,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        detailForm.setValue('DETAIL_ZERO1', newValue);
                    }
                }
             }
            
            ,{
                fieldLabel: '금액0 출력',
                id :'CONTAIN_ZERO',
                name: 'CONTAIN_ZERO', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B010',
                value: 'Y',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        detailForm.setValue('CONTAIN_ZERO1', newValue);
                    }
                }
             }]
			
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	 var panelResult = Unilite.createSearchForm('resultForm',{
        weight:-100,
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        hidden: false,//!UserInfo.appOption.collapseLeftSearch,
        items: [{       
            fieldLabel: '지급년월',
                //id: 'PAY_YYYYMM',
                xtype: 'uniMonthfield',
                name: 'PAY_YYYYMM',                    
                value: new Date(),                    
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('PAY_YYYYMM', newValue);
                        var datestr = UniDate.getDbDateStr(newValue);
                        panelSearch.setValue('TITLE', datestr.substring(0,4) +'.' + datestr.substring(4,6)+ ' ' + panelResult.getField('SUPP_TYPE').getRawValue()+ ' ' +'명세서입니다.');
                        detailForm.setValue('TITLE1', datestr.substring(0,4) +'.' + datestr.substring(4,6)+ ' ' + panelResult.getField('SUPP_TYPE').getRawValue()+ ' ' +'명세서입니다.');
                    }
                }
        },{
            fieldLabel: '지급구분',
                //id: 'SUPP_TYPE', 
                name: 'SUPP_TYPE', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H032',
                value: 1,
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('SUPP_TYPE', newValue);
                        var datestr = UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM'));
                        panelSearch.setValue('TITLE', datestr.substring(0,4) +'.' + datestr.substring(4,6)+ ' ' + panelResult.getField('SUPP_TYPE').getRawValue()+ ' ' +'명세서입니다.');
                        detailForm.setValue('TITLE1', datestr.substring(0,4) +'.' + datestr.substring(4,6)+ ' ' + panelResult.getField('SUPP_TYPE').getRawValue()+ ' ' +'명세서입니다.');
                    }
                }
        },{
            fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
        }
        ,Unilite.treePopup('DEPTTREE',{
                            fieldLabel: '부서',
                            valueFieldName:'DEPT',
                            textFieldName:'DEPT_NAME' ,
                            valuesName:'DEPTS' ,
                            selectChildren:true,
                            DBvalueFieldName:'TREE_CODE',
                            DBtextFieldName:'TREE_NAME',
                            textFieldWidth:130,
                            validateBlank:true,
                            width:350,
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
                    })
                    ,{
                        fieldLabel: '지급차수',
                        name: 'PAY_PROV_FLAG', 
                        xtype: 'uniCombobox',
                        comboType: 'AU',
                        comboCode: 'H031',
                        listeners: {
                      
                        change: function(field, newValue, oldValue, eOpts) {                        
                                panelSearch.setValue('PAY_PROV_FLAG', newValue);
                            }
            
                        }
                    }
        ]   
    });
    var detailForm = Unilite.createForm('detailForm',{
        region: 'center',
        layout : {type : 'uniTable', columns : 3,
            tableAttrs: { width: '100%'},
            tdAttrs: {/*style: 'border : 1px solid #ced9e7;',/*align : 'left',*/width: '100%'}
        
        },
        padding:'1 1 1 1',
        border:true,
        disabled:false,
        items: [{
            xtype:'container',
            defaultType:'uniTextfield',
            colspan:3,
            layout:{type:'hbox', align:'stretch'},
            items:[{
                id:'FROM_ADDR1',
                name:'FROM_ADDR1',
                fieldLabel: '보내는 메일',
                xtype: 'uniTextfield',
                width: 280,
                allowBlank: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('FROM_ADDR', newValue);
                    }
                }
            },{
                fieldLabel: '연차내역출력',
                id :'YEAR_YN1',
                name: 'YEAR_YN1', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B010',
                value: 'Y',
                width: 180,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('YEAR_YN', newValue);
                    }
                }
            },{
                fieldLabel: '근태내역출력',
                id :'WORK_YN1',
                name: 'WORK_YN1', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B010',
                value: 'Y',
                width: 180,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('WORK_YN', newValue);
                    }
                }
            }
            
             ,{
                fieldLabel: '금액0 항목출력',
                id :'DETAIL_ZERO1',
                name: 'DETAIL_ZERO1', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B010',
                value: 'Y',
                width: 180,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DETAIL_ZERO', newValue);
                        if(newValue == "N"){
                        	detailForm.setValue('CONTAIN_ZERO1', "N");
                        }else if(newValue == "Y"){
                        	detailForm.setValue('CONTAIN_ZERO1', "Y");
                        };
                        
                    }
                }
             }
            
            ,{
                fieldLabel: '금액0 출력',
                id :'CONTAIN_ZERO1',
                name: 'CONTAIN_ZERO1', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B010',
                value: 'Y',
                width: 180,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('CONTAIN_ZERO', newValue);
                    }
                }
             }
            
            
            ]
          },{
                id :'TITLE1',
                name: 'TITLE1', 
                fieldLabel: '제목',
                width: 1000,
                xtype: 'uniTextfield',
                colspan: 3,
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('TITLE', newValue);
                    }
                }
            },{
                fieldLabel: '비고',
                id:'COMMENTS1',
                width: 1000,
                autoScroll:true,
                xtype: 'textareafield',
                name: 'COMMENTS1',
                height : 100,
                rowspan:2,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('COMMENTS', newValue);
                    }
                }
            } 
        ]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hpa940ukrGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'south',
		
		
		
		uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true,
                    onLoadSelectFirst : false
        },
        tbar: [{
                xtype: 'button',
                text: '메일전송',
                listeners: {
                    click: function() {
                        
                        	if(Ext.isEmpty(panelSearch.getValue('TITLE'))){
                            	alert('제목은 필수입나다.');
                            	return false;
                            }
                            if(!panelSearch.getForm().isValid()){
                            var invalid = panelSearch.getForm().getFields().filterBy(
                        function(field) {
                            return !field.validate();
                        });

                        if (invalid.length > 0) {
                             r = false;
                             var labelText = ''
                
                             if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                                var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
                             } else if (Ext.isDefined(invalid.items[0].ownerCt)) {
                                var labelText = invalid.items[0].ownerCt['fieldLabel'] + '은(는)';
                             }
                
                             Ext.Msg.alert("경고", labelText + '필수입력 항목입니다.'); 
                             //Ext.Msg.alert('확인', "기준월(을) MM 형식으로 입력하십시오. ");
                             // validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
                             invalid.items[0].focus();
                          }
                        }
                        
                    	var param = new Array();
                        var selectedModel = masterGrid.getSelectionModel().getSelection();
                        //var selectedModel = masterGrid.getStore().getRange();
                        Ext.each(selectedModel, function(record,i){
                            record.data['S_COMP_CODE'] = UserInfo.compCode;
                            record.data['YEAR_YN'] = Ext.getCmp('YEAR_YN').getValue();
                            record.data['WORK_YN'] = Ext.getCmp('WORK_YN').getValue();
                            record.data['FROM_ADDR'] = Ext.getCmp('FROM_ADDR').getValue();
                            record.data['COMMENTS'] = Ext.getCmp('COMMENTS').getValue();
                            record.data['TITLE'] = Ext.getCmp('TITLE').getValue();
                            record.data['SUPP_NAME'] = Ext.getCmp('SUPP_TYPE').rawValue;
                            record.data['CONTAIN_ZERO'] = Ext.getCmp('CONTAIN_ZERO').getValue();
                            record.data['DETAIL_ZERO'] = Ext.getCmp('DETAIL_ZERO').getValue();
                            param.push(record.data);
                        });
                        
                        
                  if(confirm('이메일을 전송하시겠습니까?')) {
                  		//Ext.getBody().mask("전송중...");
                        Ext.Ajax.request({
                            // url     : CPATH+'/human/hpa940ukr_mail.do',
                           	 url     : CPATH+'/human/hpa940ukr_email_pdf.do', 
                             params: {
                                data: JSON.stringify(param)
                             },
                             method: 'post',
                             async : true /* ,
                             success: function(response){
                             	Ext.getBody().unmask();
                             	if(response && response.responseText)	{
                             		var responseText = Ext.JSON.decode(response.responseText);
                             	 	var sendList = responseText.sendList;
                             	 	Ext.each(sendList, function(result, idx){
                             	 		var record = directMasterStore1.findRecord("PERSON_NUMB", result.PERSON_NUMB);
                             	 		record.set("SEND_RESULT", result.SEND_RESULT);
                             	 		record.set("SEND_MSG", result.SEND_MSG);
                             	 	});
                             	 	alert(responseText.sendSummary);
                             	}
 
                             },
                             failure: function(response){
                             	Ext.getBody().unmask();
                                console.log(response);
                             }  */
                          });
                         Unilite.messageBox("이메일 전송이 시작되었습니다. 이메일전송 결과로 확인하세요.");
                        
                    }
                  }
                } //listner

            },{
                xtype: 'button',
                text: '이메일전송결과',
                handler: function(){
                	var param= Ext.getCmp('searchForm').getValues();
                	openResultPopup(param);
                }                    
            }],
// 		features: [{
// 			id: 'masterGridSubTotal', 
// 			ftype: 'uniGroupingsummary', 
// 			showSummaryRow: false 
// 		},{
// 			id: 'masterGridTotal', 
// 			ftype: 'uniSummary', 
// 			showSummaryRow: false
// 		}],
		store: directMasterStore1,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick: false }), 
		columns: [	
			{dataIndex: 'gubun'    	   		, width: 66, hidden: true},
			{dataIndex: 'PAY_YYYYMM'    	, width: 133, hidden: true},
			{dataIndex: 'SUPP_TYPE'     	, width: 133, hidden: true},
			{dataIndex: 'DIV_CODE'      	, width: 133},
			{dataIndex: 'DEPT_CODE'     	, width: 133, hidden: true},
			{dataIndex: 'DEPT_NAME'     	, width: 133},
			{dataIndex: 'POST_CODE'     	, width: 133},
			{dataIndex: 'NAME'    	   		, width: 133},
			{dataIndex: 'PERSON_NUMB'   	, width: 133},
			{dataIndex: 'EMAIL_ADDR'    	, width: 200},
			{dataIndex: 'SEND_RESULT'    	, width: 80, hidden: true},
			{dataIndex: 'SEND_MSG'    	, width: 200, hidden: true}
			
		],
//		 listeners: {
//	    	'selectionchangerecord': function(oldRecord,newRecord,selected) {
//	    		alert("!!!");
//	    	},
//	    	'beforeselect' : function(selModel, record, index, eOpts ){
//	    		alert(JSON.stringify(record.data));
//	    		alert("eOpts:"+JSON.stringify(eOpts));
//	    		var data = record.data;
//	    		if(data['SELECTED'] == null || SELECTED == '')
//	    			this.getStore.getAt(index).setData(true);
//	    		else this.getStore.getAt(index).setDate(!data['SELECTED']);
//	    	}
//		 },
		 _onDeselect : function( selModel, record, index, eOpts ){
	    		record.data["SELECTED"] = false;
	    	},
	    _onSelect:function( selModel, record, index, eOpts  ) {
	    		record.data["SELECTED"] = true;
			}
        
	});//End of var masterGrid = Unilite.createGr100id('hpa940ukrGrid1', {   
    
	var resultWin;
	function openResultPopup(param)	{
		
		if(!resultWin)	{
			Unilite.defineModel('resultModel',{
				fields: [
					  {name : 'PAY_YYYYMM'	 	, text : '지급년월' 	, type: 'string'}
					 ,{name : 'SUPP_TYPE'	 	, text : '지금구분' 	, type: 'string'}
					 ,{name : 'PERSON_NUMB'	 	, text : '사번' 		, type: 'string'}
					 ,{name : 'SEND_SEQ'      	, text : '순번' 		, type: 'string'}
					 ,{name : 'DIV_CODE'		, text : '사업장' 		, type: 'string', comboType: 'BOR120'}
					 ,{name : 'NAME'    		, text : '이름' 		, type: 'string'}
					 ,{name : 'POST_CODE'    	, text : '직위'		, type: 'string', comboType: 'AU', comboCode:'H005' }
					 ,{name : 'DEPT_CODE'	 	, text : '부서코드' 	, type: 'string'}
					 ,{name : 'DEPT_NAME'	 	, text : '부서명' 		, type: 'string'}
					 ,{name : 'EMAIL_ADDR'	 	, text : '이메일' 		, type: 'string'}
					 ,{name : 'SEND_RESULT'	 	, text : '결과' 		, type: 'string'}
					 ,{name : 'ERROR_MSG' 		, text : '메세지' 		, type: 'string'}
					 ,{name : 'INSERT_DB_USER'	, text : '전송자' 		, type: 'string'}
					 ,{name : 'INSERT_DB_TIME'	, text : '전송일' 		, type: 'string'}
				]
			});
			resultWin = Ext.create('widget.uniDetailWindow', {
				title: '이메일 전송 결과',
				width: 1100,
				height:600,
				
				layout: {type:'vbox', align:'stretch'},				 
				items: [{
						itemId:'search',
						xtype:'uniSearchForm',
						layout:{type:'uniTable',columns:3},
						items:[
							{       
					            fieldLabel: '지급년월',
					                xtype: 'uniMonthfield',
					                name: 'PAY_YYYYMM',
					                allowBlank: false
					        },{
					            fieldLabel: '지급구분',
					                name: 'SUPP_TYPE', 
					                xtype: 'uniCombobox',
					                comboType: 'AU',
					                comboCode: 'H032',
					                value: 1,
					                allowBlank: false
					        },{
					            fieldLabel: '사업장',
					                name:'DIV_CODE',
					                xtype: 'uniCombobox',
					                comboType:'BOR120'
					        }
					        ,Unilite.treePopup('DEPTTREE',{
					                            fieldLabel: '부서',
					                            valueFieldName:'DEPT',
					                            textFieldName:'DEPT_NAME' ,
					                            valuesName:'DEPTS' ,
					                            selectChildren:true,
					                            DBvalueFieldName:'TREE_CODE',
					                            DBtextFieldName:'TREE_NAME',
					                            textFieldWidth:130,
					                            validateBlank:true,
					                            width:350,
					                            autoPopup:true,
					                            useLike:true
					                    })
					        ,Unilite.popup('Employee')
						]
					},
					Unilite.createGrid('', {
						itemId:'grid',
						layout : 'fit',
						store: Unilite.createStoreSimple('resultStore', {
							model: 'resultModel' ,
							proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
								api: {
									read : 'hpa940ukrService.selectResultList'
								}
							}),
							loadStoreRecords : function() {
								var param= resultWin.down('#search').getValues();
								this.load({
									params: param
								});
							}
						}),
						selModel:'rowmodel',
						columns: [  
							  {dataIndex : 'PAY_YYYYMM'	 	, width : 80 , hidden : true}
							 ,{dataIndex : 'DIV_CODE'		, width : 120 }
							 ,{dataIndex : 'DEPT_NAME'	 	, width : 120 }
							 ,{dataIndex : 'POST_CODE'    	, width : 60 }
							 ,{dataIndex : 'NAME'    		, width : 70 }
							 ,{dataIndex : 'PERSON_NUMB'	, width : 70  }
							 ,{dataIndex : 'EMAIL_ADDR'	 	, width : 150 }
							 ,{dataIndex : 'SEND_SEQ'      	, width : 50  }
							 ,{dataIndex : 'SEND_RESULT'	, width : 60  }
							 ,{dataIndex : 'INSERT_DB_TIME' , width : 130 }
							 ,{dataIndex : 'ERROR_MSG'  	, width : 300 }
						]
					})
					   
				],
				tbar:  ['->',
					 {
						itemId : 'searchtBtn',
						text: '조회',
						handler: function() {
							var form = resultWin.down('#search');
							var store = Ext.data.StoreManager.lookup('resultStore');
							store.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							resultWin.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
							resultWin.down('#search').clearForm();
							resultWin.down('#grid').reset();
						},
					beforeclose: function( panel, eOpts )  {
							resultWin.down('#search').clearForm();
							resultWin.down('#grid').reset();
						},
					show: function( panel, eOpts ) {
							var form = resultWin.down('#search');
							form.clearForm();
							form.setValues(resultWin.param);
							var store = Ext.data.StoreManager.lookup('resultStore')
							store.loadStoreRecords();
						 }
					}
				});
		}
		resultWin.param = param;
		resultWin.center();	  
		resultWin.show();
	}	
		
	Unilite.Main( {
		 borderItems:[{
            region  : 'center',
            layout  : {type: 'vbox', align: 'stretch'},
            border  : false,
            items   : [ 
	 		panelResult
	 		,detailForm
	 		,masterGrid
	 		]},
	 		panelSearch
		]
	    
		,
		id: 'hpa940ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('print', false);
			var datestr = UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM'));
            panelSearch.setValue('TITLE', datestr.substring(0,4) +'.' + datestr.substring(4,6)+ ' ' + panelResult.getField('SUPP_TYPE').getRawValue()+ ' ' +'명세서입니다.');
            detailForm.setValue('TITLE1', datestr.substring(0,4) +'.' + datestr.substring(4,6)+ ' ' + panelResult.getField('SUPP_TYPE').getRawValue()+ ' ' +'명세서입니다.');
		},
		onQueryButtonDown: function() {
			
			if(panelResult.getForm().isValid()){
                directMasterStore1.loadStoreRecords();
                
                //var viewLocked = masterGrid.lockedGrid.getView();
                //var viewNormal = masterGrid.normalGrid.getView();
                //console.log("viewLocked: ", viewLocked);
                //console.log("viewNormal: ", viewNormal);
                //viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
                //viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
                //viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
                //viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
            } else {
                var invalid = panelResult.getForm().getFields().filterBy(
                        function(field) {
                            return !field.validate();
                        });

              if (invalid.length > 0) {
                 r = false;
                 var labelText = ''
    
                 if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                    var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
                 } else if (Ext.isDefined(invalid.items[0].ownerCt)) {
                    var labelText = invalid.items[0].ownerCt['fieldLabel'] + '은(는)';
                 }
    
                 Ext.Msg.alert("경고", labelText + '필수입력 항목입니다.'); 
                 //Ext.Msg.alert('확인', "기준월(을) MM 형식으로 입력하십시오. ");
                 // validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
                 //invalid.items[0].focus();
              }
            }
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onPrintButtonDown:function(){
			var param = Ext.getCmp('searchForm').getValues();
			var store = masterGrid.getStore();//masterGrid.getSelectionModel().getSelection();
			var count = store.getCount();
			 for (var i = 0; i < count; i++) {
			  	var record = store.getAt(i);
			  	param[i] = JSON.stringify(record.data);
			 }
			 param["DATA_LENGTH"] = count;
			 var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/hpa/hpa940ukrPrint.do',
				prgID: 'hpa940ukr',
				extParam: param
			});
			win.center();
			win.show();
		}
		
	});
	

};


</script>
