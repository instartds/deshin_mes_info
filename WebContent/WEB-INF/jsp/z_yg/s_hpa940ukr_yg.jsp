<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa940ukr_yg"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H032" /> <!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 사용여부 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hpa940ukr_ygModel', {
		fields: [
			{name: 'gubun'    		, text: '전송여부'			, type: 'string' , editable: false},
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
			{name: 'WORK_YN'    	, text: '근태여부'			, type: 'string', editable: false}
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
// 		loadStoreRecords: function(){
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
	var directMasterStore1 = Unilite.createStore('s_hpa940ukr_ygMasterStore1', {
		model: 's_hpa940ukr_ygModel',
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
				read: 's_hpa940ukr_ygService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
			
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
      			var count = masterGrid.getStore().getCount();  
           		if(count > 0){
	           		//UniAppManager.setToolbarButtons(['print'], true);
	           	}
           	}
		}
		
	});//End of var directMasterStore1 = Unilite.createStore('hpa940ukrMasterStore1', {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	/*var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
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
				allowBlank: false
			},{
				fieldLabel: '지급구분',
				id: 'SUPP_TYPE', 
				name: 'SUPP_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H032',
				allowBlank: false
			}, {
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120'
			},
			Unilite.popup('DEPT',{
				fieldLabel: '부서',
				valueFieldName: 'DEPT_CODE1',
		    	textFieldName: 'DEPT_NAME1',
				textFieldWidth: 170,
				validateBlank: false,
				popupWidth: 710
			}),
			    Unilite.popup('DEPT', {
			    	fieldLabel: '~',
			    	valueFieldName: 'DEPT_CODE2',
			    	textFieldName: 'DEPT_NAME2',
			    	textFieldWidth: 170,
			    	validateBlank: false,
			    	popupWidth: 710
			}),{
				fieldLabel: '지급차수',
				name: 'PAY_PROV_FLAG', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031'
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
				allowBlank: true
			},{
				id :'TITLE',
				name: 'TITLE', 
				fieldLabel: '제목',
				xtype: 'uniTextfield',
				allowBlank: false
			}
			,{
			 	fieldLabel: '비고',
			 	id:'COMMENTS',
			 	xtype: 'textareafield',
			 	name: 'COMMENTS',
			 	height : 80,
			 	rowspan:2
			},{
				fieldLabel: '년월차내역출력여부',
				id :'YEAR_YN',
				name: 'YEAR_YN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B010',
				value: 'Y'
			},{
				fieldLabel: '근태내역출력여부',
				id :'WORK_YN',
				name: 'WORK_YN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B010',
				value: 'Y'
			},{
				xtype: 'button',
	    		text: '메일전송',
	    		listeners: {
	    	        click: function() {
	    	        	var param = new Array();
	    	        	var selectedModel = masterGrid.getSelectionModel().getSelection();

						Ext.each(selectedModel, function(record,i){
							record.data['S_COMP_CODE'] = UserInfo.compCode;
							record.data['YEAR_YN'] = Ext.getCmp('YEAR_YN').getValue();
							record.data['WORK_YN'] = Ext.getCmp('WORK_YN').getValue();
							record.data['FROM_ADDR'] = Ext.getCmp('FROM_ADDR').getValue();
							record.data['COMMENTS'] = Ext.getCmp('COMMENTS').getValue();
							record.data['TITLE'] = Ext.getCmp('TITLE').getValue();
							record.data['SUPP_NAME'] = Ext.getCmp('SUPP_TYPE').rawValue;
							param.push(record.data);
						});
						
						
						
						Ext.Ajax.request({
			                 url     : CPATH+'/human/hpa940ukr_mail.do',
			                 params: {
			                    data: JSON.stringify(param)
			                 },
			                 method: 'post',
			                 success: function(response){
			                	 alert("success");
 
			                 },
			                 failure: function(response){
			                    console.log(response);
			                 }
			              });
	    	        	
	    	    	}
	    		}

	    		 
	    		
	    		
	    	        
	    	}]
			
		}]
	});*/
	
	
	
	
	
	
	
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
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('SUPP_TYPE', newValue);
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
                allowBlank: true
            },{
                id :'TITLE',
                name: 'TITLE', 
                fieldLabel: '제목',
                xtype: 'uniTextfield',
                allowBlank: false
            }
            ,{
                fieldLabel: '비고',
                id:'COMMENTS',
                xtype: 'textareafield',
                name: 'COMMENTS',
                height : 80,
                rowspan:2
            },{
                fieldLabel: '년월차내역출력여부',
                id :'YEAR_YN',
                name: 'YEAR_YN', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B010',
                hidden  : true,
                value: 'Y'
            },{
                fieldLabel: '근태내역출력',
                id :'WORK_YN',
                name: 'WORK_YN', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B010',
                value: 'Y'
            },{
                xtype: 'button',
                text: '메일전송',
                tdAttrs : {align : 'center'},
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
                             //invalid.items[0].focus();
                             return false;
                             
                             
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
                            param.push(record.data);
                        });
                        
                        
                        
                        Ext.Ajax.request({
                             url     : CPATH+'/z_yg/s_hpa940ukr_ygmail.do',
                             params: {
                                data: JSON.stringify(param)
                             },
                             method: 'post',
                             success: function(response){
                                 alert("success");
                             
//                              data = Ext.decode(response.responseText);
//                              console.log(data);
 
                             },
                             failure: function(response){
                                console.log(response);
                             }
                          });
                        //console.log(selectedRecord);
                        //alert('I was clicked!');
                    }
                } //listner

                 
                
                
                    
            }]
            
        }]
    });
    
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
                    }
                }
        },{
            fieldLabel: '지급구분',
                //id: 'SUPP_TYPE', 
                name: 'SUPP_TYPE', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H032',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('SUPP_TYPE', newValue);
                    }
                }
        },{
            fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('CUSTOM_TYPE', newValue);
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('s_hpa940ukr_ygGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		
		
		
		uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true,
                    useLiveSearch:true,
                    animatedScroll : false,
                    onLoadSelectFirst : false
        },
        tbar: [{
                xtype: 'button',
                text: '메일전송',
                tdAttrs : {align : 'center'},
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
                            param.push(record.data);
                        });
                        
                        
                        
                        Ext.Ajax.request({
                             url     : CPATH+'/z_yg/s_hpa940ukr_ygmail.do',
                             params: {
                                data: JSON.stringify(param)
                             },
                             method: 'post',
                             success: function(response){
                                 alert("success");
                             
//                              data = Ext.decode(response.responseText);
//                              console.log(data);
 
                             },
                             failure: function(response){
                                console.log(response);
                             }
                          });
                        //console.log(selectedRecord);
                        //alert('I was clicked!');
                    }
                } //listner

                 
                
                
                    
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
			{dataIndex: 'EMAIL_ADDR'    	, width: 250}
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
                                                 
	Unilite.Main( {
		 borderItems:[ 
	 		 masterGrid
	 		 ,panelResult
			,panelSearch
		],
		id: 's_hpa940ukr_ygApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('print', true);
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
