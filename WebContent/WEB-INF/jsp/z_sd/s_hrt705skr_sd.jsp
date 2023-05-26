<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hrt705skr_sd"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H053" /> <!-- 퇴직구분 -->
    <t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 --> 
    <t:ExtComboStore comboType="AU" comboCode="H032" /> <!-- 상여연차구분 --> 
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	
	var excelWindow; 
	var excelWindow2;           
	
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 's_hrt705skr_sdService.selectList1',
//            update  : 's_hrt705skr_sdService.updateList',
            create  : 's_hrt705skr_sdService.insertList',
//            destroy : 's_hrt705skr_sdService.deleteList',
            syncAll : 's_hrt705skr_sdService.saveAll'
        }
    }); 
    
    
    // 엑셀업로드 window의 Grid Model
    Unilite.Excel.defineModel('excel.s_hrt705skr_sd.sheet01', {
        fields: [
            {name: '_EXCEL_JOBID'      , text:'EXCEL_JOBID'    , type: 'string'},
            {name: 'COMP_CODE'         , text: '법인코드'        , type: 'string'},
            {name: 'RETR_DATE'         , text: '정산일'          , type: 'string'},
            {name: 'RETR_TYPE'         , text: '구분'           , type: 'string'},
            {name: 'PERSON_NUMB'       , text: '사원번호'        , type: 'string'},
            {name: 'RETR_RESN'         , text: '퇴직사유'         , type: 'string'},
            {name: 'RETR_PENSION_KIND' , text: '퇴직연금가입구분'   , type: 'string'},
            {name: 'ENTR_DATE'         , text: '입사일'       , type: 'string'},
            {name: 'JOIN_DATE'         , text: '정산시작일'       , type: 'string'},
            {name: 'DUTY_YYYY'         , text: '근속년'          , type: 'int'},
            {name: 'LONG_MONTH'        , text: '근속월'          , type: 'int'},
            {name: 'LONG_DAY'          , text: '근속일'          , type: 'int'},
            {name: 'PAY_TOTAL_I'       , text: '급여총액'        , type: 'uniUnitPrice'  },
            {name: 'BONUS_TOTAL_I'     , text: '상여총액'        , type: 'uniUnitPrice'  , allowBlank: false},
            {name: 'YEAR_TOTAL_I'      , text: '년차총액'        , type: 'uniUnitPrice'  , allowBlank: false},
            {name: 'TOT_WAGES_I'       , text: '합계'           , type: 'uniUnitPrice'  , allowBlank: false},
            {name: 'AVG_WAGES_I'       , text: '평균임금'        , type: 'uniUnitPrice'  , allowBlank: false},
            {name: 'ORI_RETR_ANNU_I'   , text: '퇴직금'          , type: 'uniUnitPrice'  , allowBlank: false}
            
            
        ]
    });
    // 엑셀업로드 window의 Grid Model
    Unilite.Excel.defineModel('excel.s_hrt705skr_sd.sheet02', {
        fields: [
            {name: '_EXCEL_JOBID'      , text:'EXCEL_JOBID'  , type: 'string'},
            {name: 'COMP_CODE'         , text: '법인코드'        , type: 'string'},
            {name: 'RETR_TYPE'         , text: '퇴직종류'        , type: 'string'},
            {name: 'PERSON_NUMB'       , text: '사원번호'        , type: 'string'},
            {name: 'RETR_DATE'         , text: '퇴직일'         , type: 'string'},
            {name: 'BONUS_TYPE'        , text: '급상여구분'       , type: 'string' },
            {name: 'PAY_STRT_DATE'     , text: '급여시작년월일'     , type: 'string'},
            {name: 'PAY_LAST_DATE'     , text: '급여종료년월일'     , type: 'string'},
            {name: 'AMOUNT_I'          , text: '금액'        , type: 'uniUnitPrice'},
            {name: 'WAGES_DAY'         , text: '일수'          , type: 'int'},
            {name: 'RETR_RESN'         , text: '퇴직사유'        , type: 'string'},
            {name: 'ENTR_DATE'         , text: '입사일'       , type: 'string'},
            {name: 'JOIN_DATE'         , text: '정산시작일'       , type: 'string'},
            {name: 'DUTY_YYYY'         , text: '근속년'          , type: 'int'},
            {name: 'LONG_MONTH'        , text: '근속월'          , type: 'int'},
            {name: 'LONG_DAY'          , text: '근속일'          , type: 'int'},
            {name: 'PAY_TOTAL_I'       , text: '급여총액'        , type: 'uniUnitPrice'  },
            {name: 'BONUS_TOTAL_I'     , text: '상여총액'        , type: 'uniUnitPrice'  , allowBlank: false},
            {name: 'YEAR_TOTAL_I'      , text: '년차총액'        , type: 'uniUnitPrice'  , allowBlank: false},
            {name: 'TOT_WAGES_I'       , text: '합계'           , type: 'uniUnitPrice'  , allowBlank: false},
            {name: 'AVG_WAGES_I'       , text: '평균임금'        , type: 'uniUnitPrice'  , allowBlank: false},
            {name: 'ORI_RETR_ANNU_I'   , text: '퇴직금'          , type: 'uniUnitPrice'  , allowBlank: false}
            
            
        ]
    });
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hrt705skr_sdModel1', {
	    fields: [
	    	{name: 'COMP_CODE'         , text: '법인코드'     		, type: 'string'},
	    	{name: 'DIV_CODE'		   , text: '사업장'			, type: 'string', comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'		   , text: '부서'				, type: 'string'},
	    	{name: 'POST_CODE'		   , text: '직위'				, type: 'string', comboType: 'AU', comboCode: 'H005'},
	    	{name: 'NAME'			   , text: '성명'				, type: 'string'},
	    	{name: 'PERSON_NUMB'	   , text: '사번'				, type: 'string'},
	    	{name: 'RETR_TYPE'         , text: '구분'        		, type: 'string', comboType: 'AU', comboCode: 'H053'},
	    	{name: 'ENTR_DATE'		   , text: '입사일'			, type: 'uniDate'},
	    	{name: 'JOIN_DATE'		   , text: '정산시작일'		, type: 'uniDate'},
	    	{name: 'RETR_DATE'		   , text: '정산일'			, type: 'uniDate'},
	    	{name: 'RETR_PENSION_KIND' , text: '퇴직연금가입구분'	, type: 'string', comboType: 'AU', comboCode: 'H217'},
	    	//{name: 'SUPP_DATE'         , text: '지급일'       	, type: 'uniDate'},
	    	{name: 'BONUS_TYPE'        , text: '급상여구분'    	, type: 'string' },
            {name: 'PAY_STRT_DATE'     , text: '급여시작년월일' 		, type: 'string'},
            {name: 'PAY_LAST_DATE'     , text: '급여종료년월일' 		, type: 'string'},
            {name: 'AMOUNT_I'          , text: '금액'        		, type: 'uniUnitPrice'},
            {name: 'WAGES_DAY'         , text: '일수'        		, type: 'int'},
	    	{name: 'DUTY_YYYY'		   , text: '근속년'	    	, type: 'int'},
	    	{name: 'LONG_MONTH'		   , text: '근속월'	    	, type: 'int'},
	    	{name: 'LONG_DAY'		   , text: '근속일'	    	, type: 'int'},
	    	{name: 'PAY_TOTAL_I'	   , text: '급여총액'			, type: 'uniPrice'},
	    	{name: 'BONUS_TOTAL_I'	   , text: '상여총액'			, type: 'uniPrice'},
	    	{name: 'YEAR_TOTAL_I'	   , text: '년월차총액'		, type: 'uniPrice'},
	    	{name: 'TOT_WAGES_I'	   , text: '합계'	    		, type: 'uniPrice'},
	    	{name: 'AVG_WAGES_I'	   , text: '급여평균임금'		, type: 'uniPrice'},
	    	{name: 'ORI_RETR_ANNU_I'   , text: '퇴직금'			, type: 'uniPrice'}
		]
	});
	
   Unilite.defineModel('s_hrt705skr_sdModel2', {
        fields: [
            {name: 'COMP_CODE'      	, text: '법인코드'     , type: 'string'},
            {name: 'DIV_CODE'       	, text: '사업장'       , type: 'string', comboType: 'BOR120'},
            {name: 'DEPT_NAME'      	, text: '부서'        , type: 'string'},
            {name: 'POST_CODE'      	, text: '직위'        , type: 'string', comboType: 'AU'	, comboCode: 'H005'},
            {name: 'NAME'           	, text: '성명'        , type: 'string'},
            {name: 'PERSON_NUMB'    	, text: '사번'        , type: 'string'},
            {name: 'RETR_TYPE'      	, text: '구분'        , type: 'string', comboType: 'AU'	, comboCode: 'H053'},
            {name: 'FIRST_RETR_MONTH'   , text: '정산시작월'    , type: 'uniDate'},
            {name: 'LAST_RETR_MONTH'    , text: '정산일'       , type: 'uniDate'},
            {name: 'QUATER_TYPE'        , text: '정산분기'      , type: 'string'},
            {name: 'DUTY_YYYY'      	, text: '근속기간'      , type: 'string'},
            {name: 'PAY_TOTAL_I'    	, text: '급여총액'      , type: 'uniPrice'},
            {name: 'BONUS_TOTAL_I'  	, text: '상여총액'      , type: 'uniPrice'},
            {name: 'YEAR_TOTAL_I'   	, text: '년월차총액'     , type: 'uniPrice'},
            {name: 'ORI_RETR_ANNU_I'	, text: '퇴직금'        , type: 'uniPrice'},
            {name: 'QUAT_RETR_ANNU_I'	, text: '전분기퇴직금'    , type: 'uniPrice'},
            //{name: 'SUPP_DATE'       	, text: '지급일'        , type: 'uniDate'},
            {name: 'PRE_QUAT_RETR_ANNU_I' 	, text: '전분기차이금액'  , type: 'uniPrice'}
        ]
    });
    
   Unilite.defineModel('s_hrt705skr_sdModel3', {
        fields: [
            {name: 'COMP_CODE'      		, text: '법인코드'    	, type: 'string'},
            {name: 'DIV_CODE'       		, text: '사업장'      , type: 'string', comboType: 'BOR120'},
            {name: 'DEPT_NAME'      		, text: '부서'       , type: 'string'},
            {name: 'POST_CODE'      		, text: '직위'       , type: 'string', comboType: 'AU'	, comboCode: 'H005'},
            {name: 'NAME'           		, text: '성명'       , type: 'string'},
            {name: 'PERSON_NUMB'    		, text: '사번'       , type: 'string'},
            {name: 'RETR_TYPE'      		, text: '구분'       , type: 'string', comboType: 'AU'	, comboCode: 'H053'},
            {name: 'FIRST_RETR_DATE'    	, text: '정산시작일'   , type: 'uniDate'},
            {name: 'LAST_RETR_DATE'     	, text: '정산일'      , type: 'uniDate'},
            //{name: 'SUPP_DATE'       		, text: '지급일'      , type: 'uniDate'},
            {name: 'DUTY_YYYY'      		, text: '근속기간'     , type: 'string'},
            {name: 'PAY_TOTAL_I'    		, text: '급여총액'     , type: 'uniPrice'},
            {name: 'BONUS_TOTAL_I'  		, text: '상여총액'     , type: 'uniPrice'},
            {name: 'YEAR_TOTAL_I'   		, text: '년월차총액'    , type: 'uniPrice'},   
            {name: 'ORI_RETR_ANNU_I'    	, text: '퇴직금'       , type: 'uniPrice'},
            {name: 'PRE_RETR_ANNU_I'	, text: '전년도퇴직금'   , type: 'uniPrice'},
            {name: 'PRE_DIFF_RETR_ANNU_I'   		, text: '전년도차이금액'  , type: 'uniPrice'}
            
        ]
    });
		
	Unilite.defineModel('sub1Model', {
	    fields: [
	    	{name: 'PAY_YYYYMM'		, text: '급여년월'		, type: 'string'},
	    	{name: 'WAGES_NAME'		, text: '지급구분'		, type: 'string'},
	    	{name: 'AMOUNT_I'		, text: '금액'		, type: 'uniPrice'}
		]
	});
	
	Unilite.defineModel('sub2Model', {
	    fields: [
	    	{name: 'BONUS_YYYYMM'		, text: '상여년월'		, type: 'string'},
	    	{name: 'BONUS_TYPE'		, text: '상여구분'		, type: 'string'},
	    	{name: 'BONUS_I'		, text: '금액'		, type: 'uniPrice'}
		]
	});
	
	Unilite.defineModel('sub3Model', {
	    fields: [
	    	{name: 'BONUS_YYYYMM'		, text: '년월차년월'		, type: 'string'},
	    	{name: 'BONUS_TYPE'		, text: '년월차구분'		, type: 'string'},
	    	{name: 'BONUS_I'		, text: '금액'		, type: 'uniPrice'}
		]
	});
	
	Unilite.defineModel('sub4Model', {
	    fields: [
	    	{name: 'PAY_YYYYMM'		, text: '급여년월'		, type: 'string'},
	    	{name: 'WEL_NAME'		, text: '지급구분'		, type: 'string'},
	    	{name: 'GIVE_I'		, text: '금액'		, type: 'uniPrice'}
		]
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('s_hrt705skr_sdMasterStore1',{
		model: 's_hrt705skr_sdModel1',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
        autoLoad: false,
        proxy   : directProxy,
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
        saveStore : function()  {
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            
            var paramMaster = Ext.getCmp('searchForm').getValues();
            
            if(inValidRecs.length == 0 )    {
                config = {
                    params  : [paramMaster],
                    success : function(batch, option) {                             
                        panelResult.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false); 

                    } 
                };                  
                this.syncAllDirect(config);
                
            }else {
                masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }

	});
	
    var directMasterStore2 = Unilite.createStore('s_hrt705skr_sdMasterStore2',{
        model: 's_hrt705skr_sdModel2',
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable:false,            // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 's_hrt705skr_sdService.selectList2'                 
            }
        },
        loadStoreRecords: function() {
            var param = Ext.getCmp('searchForm').getValues();           
            console.log( param );
            this.load({
                params : param
            });
        }
    });
    
    var directMasterStore3 = Unilite.createStore('s_hrt705skr_sdMasterStore3',{
        model: 's_hrt705skr_sdModel3',
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable:false,            // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 's_hrt705skr_sdService.selectList3'                 
            }
        },
        loadStoreRecords: function() {
            var param = Ext.getCmp('searchForm').getValues();           
            console.log( param );
            this.load({
                params : param
            });
        }
    });
	
	
	var sub1Store = Unilite.createStore('sub1Store',{
		model: 'sub1Model',
        autoLoad: false,
        proxy: {
			type: 'direct',
			api: {			
				read: 's_hrt705skr_sdService.selectSub1'                	
			}
		},
		loadStoreRecords: function(person_numb, retr_type, retr_date) {
			//var param = masterGrid.getSelectionModel().getSelection();
		
			var param = Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			param.RETR_TYPE = retr_type;
			param.RETR_DATE = retr_date;
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var sub2Store = Unilite.createStore('sub2Store',{
		model: 'sub2Model',
        autoLoad: false,
        proxy: {
			type: 'direct',
			api: {			
				read: 's_hrt705skr_sdService.selectSub2'                	
			}
		},
		loadStoreRecords: function(person_numb, retr_type, retr_date) {
			var param = Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			param.RETR_TYPE = retr_type;
			console.log( param );
			this.load({
				params : param
			});
		}
	});	
	
	
	var sub3Store = Unilite.createStore('sub3Store',{
		model: 'sub3Model',
        autoLoad: false,
        proxy: {
			type: 'direct',
			api: {			
				read: 's_hrt705skr_sdService.selectSub3'                	
			}
		},
		loadStoreRecords: function(person_numb, retr_type, retr_date) {
			var param = Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			param.RETR_TYPE = retr_type;
			console.log( param );
			this.load({
				params : param
			});
		}
	});	
	
	var sub4Store = Unilite.createStore('sub4Store',{
		model: 'sub4Model',
        autoLoad: false,
        proxy: {
			type: 'direct',
			api: {			
				read: 's_hrt705skr_sdService.selectSub4'                	
			}
		},
		loadStoreRecords: function(person_numb, retr_type, retr_date) {
			var param = Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			param.RETR_TYPE = retr_type;
			console.log( param );
			this.load({
				params : param
			});
		}
	});	
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
   
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:UserInfo.appOption.collapseLeftSearch,
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
    		items: [
    			{
    				fieldLabel: '사업장',
    				name: 'DIV_CODE',
    				xtype: 'uniCombobox',
    				comboType: 'BOR120',
    				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
    			},
    			{
                    fieldLabel: '정산일',
                    xtype: 'uniDatefield',
                    name:'BASE_DATE',
                    allowBlank:false,
                    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BASE_DATE', newValue);
						}
					}
                },
				Unilite.popup('DEPT',{
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE1',
			    	textFieldName: 'DEPT_NAME1',
					validateBlank: false,
                    listeners: {
                        'onValueFieldChange': function(field, newValue, oldValue  ){
                                panelResult.setValue('DEPT_CODE1', newValue);
                        },
                        'onTextFieldChange':  function( field, newValue, oldValue  ){
                                panelResult.setValue('DEPT_NAME1', newValue);                                                                                                           
                        }
                    }					
				}),
				Unilite.popup('DEPT', {
			    	fieldLabel: '~',
			    	valueFieldName: 'DEPT_CODE2',
			    	textFieldName: 'DEPT_NAME2',
			    	validateBlank: false,
                    listeners: {
                        'onValueFieldChange': function(field, newValue, oldValue  ){
                                panelResult.setValue('DEPT_CODE2', newValue);
                        },
                        'onTextFieldChange':  function( field, newValue, oldValue  ){
                                panelResult.setValue('DEPT_NAME2', newValue);                                                                                                           
                        }
                    }   
			    }),
			    Unilite.popup('Employee',{ 
					fieldLabel: '성명',
					valueFieldName: 'PERSON_NUMB',
					validateBlank: false,
                    listeners: {
                        onValueFieldChange: function(field, newValue){
                            panelResult.setValue('PERSON_NUMB', newValue);                              
                        },
                        onTextFieldChange: function(field, newValue){
                            panelResult.setValue('NAME', newValue);             
                        }
                    }
				}),
				{
					fieldLabel: '퇴직구분',
					name: 'CODE_NAME',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'H053',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('CODE_NAME', newValue);
                        }
                    }
				},
				{
                xtype: 'radiogroup',                            
                fieldLabel: '분기',
                id:'quater2',
                items: [{
                    boxLabel: '1/4', 
                    width: 45, 
                    name: 'rdoSelect',
                    inputValue: '1',
                    checked: true
                },{
                    boxLabel : '2/4', 
                    width: 45,
                    name: 'rdoSelect',
                    inputValue: '2' 
                },{
                    boxLabel : '3/4', 
                    width: 45,
                    name: 'rdoSelect',
                    inputValue: '3' 
                },{
                    boxLabel : '4/4', 
                    width: 45,
                    name: 'rdoSelect',
                    inputValue: '4' 
                }],
                listeners: {
                    change : function(rb, newValue, oldValue, options) {
                        panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
                    }
                }
            }
    		]}
    	]		
	});  	
	
	
    var panelResult = Unilite.createSearchForm('resultForm', {        
        region: 'north',
        layout : {type : 'uniTable', columns :  4},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [
                {
                    fieldLabel: '사업장',
                    name: 'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType: 'BOR120',
                    listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                        }
                    }
                },
                {
                    fieldLabel: '정산일',
                    xtype: 'uniDatefield',
                    name:'BASE_DATE',
                    allowBlank:false,
                    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('BASE_DATE', newValue);
						}
					}
                },
                Unilite.popup('DEPT',{
                    fieldLabel: '부서',
                    valueFieldName: 'DEPT_CODE1',
                    textFieldName: 'DEPT_NAME1',
                    validateBlank: false,
                    listeners: {
                        'onValueFieldChange': function(field, newValue, oldValue  ){
                                panelSearch.setValue('DEPT_CODE1', newValue);
                        },
                        'onTextFieldChange':  function( field, newValue, oldValue  ){
                                panelSearch.setValue('DEPT_NAME1', newValue);                                                                                                           
                        }
                    }   
                }),
                Unilite.popup('DEPT', {
                    fieldLabel: '~',
                    labelWidth:15,
                    valueFieldName: 'DEPT_CODE2',
                    textFieldName: 'DEPT_NAME2',
                    validateBlank: false,
                    listeners: {
                        'onValueFieldChange': function(field, newValue, oldValue  ){
                                panelSearch.setValue('DEPT_CODE2', newValue);
                        },
                        'onTextFieldChange':  function( field, newValue, oldValue  ){
                                panelSearch.setValue('DEPT_NAME2', newValue);                                                                                                           
                        }
                    }  
                }),
                Unilite.popup('Employee',{ 
                    fieldLabel: '성명',
                    valueFieldName: 'PERSON_NUMB',
                    textFieldName: 'NAME',
                    validateBlank: false,
                    autoPopup:true,
                    listeners: {
                        onValueFieldChange: function(field, newValue){
                            panelSearch.setValue('PERSON_NUMB', newValue);                              
                        },
                        onTextFieldChange: function(field, newValue){
                            panelSearch.setValue('NAME', newValue);             
                        }
                    }
                }),
                {
                    fieldLabel: '퇴직구분',
                    name: 'CODE_NAME',
                    xtype: 'uniCombobox',
                    comboType: 'AU',
                    comboCode: 'H053',
 //                   colspan:2,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.setValue('CODE_NAME', newValue);
                        }
                    }                    
                },
                {
                xtype: 'radiogroup',                            
                fieldLabel: '분기',
                id:'quater1',
                items: [{
                    boxLabel: '1/4', 
                    width: 50, 
                    name: 'rdoSelect',
                    inputValue: '1',
                    checked: true
                },{
                    boxLabel : '2/4', 
                    width: 50,
                    name: 'rdoSelect',
                    inputValue: '2' 
                },{
                    boxLabel : '3/4', 
                    width: 50,
                    name: 'rdoSelect',
                    inputValue: '3' 
                },{
                    boxLabel : '4/4', 
                    width: 50,
                    name: 'rdoSelect',
                    inputValue: '4' 
                }],
                listeners: {
                    change : function(rb, newValue, oldValue, options) {
                        panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
                    }
                }
            }
            ]
    });
	
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('s_hrt705skr_sdGrid1', {
    	// for tab    
    	title: '미가입',
        layout: 'fit',
        region:'center',
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar  : [{
            text    : '퇴직금추계 업로드',
            id  : 'excelBtn',
            width   : 120,
            handler : function() {
                if(!panelResult.getInvalidMessage()) return;   //필수체크
                openExcelWindow();
            }
        },{
            text    : '평균임금 업로드',
            id  : 'excelBtn2',
            width   : 120,
            handler : function() {
                if(!panelResult.getInvalidMessage()) return;   //필수체크
                openExcelWindow2();
                if(masterGrid1.getStore().getCount() == 0){
                	sub1Store.clearData();
                	sub1Grid.reset();
                	sub2Store.clearData();
                    sub2Grid.reset();
                    sub3Store.clearData();
                    sub3Grid.reset();
                    sub4Store.clearData();
                    sub4Grid.reset();
                	
                }
            }
        }],
    	store: directMasterStore1,
        columns: [
			{dataIndex: 'COMP_CODE'       	, width: 90, hidden: true},
			{dataIndex: 'DIV_CODE'		  	, width: 120},
			{dataIndex: 'DEPT_NAME'		  	, width: 150},
			{dataIndex: 'POST_CODE'		  	, width: 120},
			{dataIndex: 'NAME'  		  	, width: 100},
			{dataIndex: 'PERSON_NUMB'	  	, width: 100},
			{dataIndex: 'RETR_TYPE'       	, width: 100},
			{dataIndex: 'ENTR_DATE'		  	, width: 100, hidden: false},
			{dataIndex: 'JOIN_DATE'		  	, width: 100},
			{dataIndex: 'RETR_DATE'		  	, width: 100},
			{dataIndex: 'RETR_PENSION_KIND'	, width: 120},
			//{dataIndex: 'SUPP_DATE'       	, width: 100, hidden: true},
			{dataIndex: 'BONUS_TYPE'      	, width: 100, hidden: true},
			{dataIndex: 'PAY_STRT_DATE'   	, width: 100, hidden: true},
			{dataIndex: 'PAY_LAST_DATE'   	, width: 100, hidden: true},
			{dataIndex: 'AMOUNT_I'        	, width: 100, hidden: true},
			{dataIndex: 'WAGES_DAY'       	, width: 100, hidden: true},
			{dataIndex: 'DUTY_YYYY'		  	, width: 100},
			{dataIndex: 'LONG_MONTH'	  	, width: 100},
			{dataIndex: 'LONG_DAY'		  	, width: 100},
			{dataIndex: 'PAY_TOTAL_I'	  	, width: 100},
			{dataIndex: 'BONUS_TOTAL_I'	  	, width: 100},
			{dataIndex: 'YEAR_TOTAL_I'	  	, width: 100},
			{dataIndex: 'TOT_WAGES_I'	  	, width: 100},
			{dataIndex: 'AVG_WAGES_I'	  	, width: 100, hidden: false},
			{dataIndex: 'ORI_RETR_ANNU_I' 	, width: 100}
		],
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
        listeners: {
            selectionchange: function(grid, selNodes ){
           	   console.log(selNodes[0]);
            	if (typeof selNodes[0] != 'undefined') {
            	  console.log("===================="+selNodes[0].data.RETR_TYPE);
                  var person_numb = selNodes[0].data.PERSON_NUMB;
                  var retr_type = selNodes[0].data.RETR_TYPE;
                  var retr_date = selNodes[0].data.RETR_DATE;
                  sub1Store.loadStoreRecords(person_numb, retr_type, retr_date);
                  sub2Store.loadStoreRecords(person_numb, retr_type, retr_date);
                  sub3Store.loadStoreRecords(person_numb, retr_type, retr_date);
                  sub4Store.loadStoreRecords(person_numb, retr_type, retr_date);
                }
            },
            onGridDblClick: function(grid, record, cellIndex, colName) {
                var params = {
                    appId: UniAppManager.getApp().id,
                    sender: this,
                    action: 'new',
                    PERSON_NUMB: record.get('PERSON_NUMB'),
                    NAME: record.get('NAME'),
                    CODE_NAME: record.get('RETR_TYPE'),
                    //SUPP_DATE: record.get('SUPP_DATE'),
                    RETR_DATE: record.get('RETR_DATE')
                }
                var rec = {data : {prgID : 'hrt506ukr', 'text':''}};                                    
                parent.openTab(rec, '/human/hrt506ukr.do', params);     
            }
        }
	});
	
	var masterGrid2 = Unilite.createGrid('s_hrt705skr_sdGrid2', {
        // for tab    
        title: 'DC형',
        layout: 'fit',
        region:'center',
        uniOpt:{    expandLastColumn: true,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },
      
        store: directMasterStore2,
        columns: [
            {dataIndex: 'COMP_CODE'        , width: 90, hidden: true},
            {dataIndex: 'DIV_CODE'         , width: 120},
            {dataIndex: 'DEPT_NAME'        , width: 150},
            {dataIndex: 'POST_CODE'        , width: 120},
            {dataIndex: 'NAME'             , width: 100},
            {dataIndex: 'PERSON_NUMB'      , width: 100},
            {dataIndex: 'RETR_TYPE'        , width: 100},
            //{dataIndex: 'SUPP_DATE'        , width: 100, hidden: true},
            {dataIndex: 'FIRST_RETR_MONTH' , width: 100, align: 'center'},
            {dataIndex: 'LAST_RETR_MONTH'  , width: 100, align: 'center'},
            {dataIndex: 'QUATER_TYPE'      , width: 100, align: 'center'},
            {dataIndex: 'DUTY_YYYY'        , width: 100},
            {dataIndex: 'PAY_TOTAL_I'      , width: 100},
            {dataIndex: 'BONUS_TOTAL_I'    , width: 100},
            {dataIndex: 'YEAR_TOTAL_I'     , width: 100},
            {dataIndex: 'ORI_RETR_ANNU_I'  , width: 100},
            {dataIndex: 'QUAT_RETR_ANNU_I' , width: 130},
            {dataIndex: 'PRE_QUAT_RETR_ANNU_I'   , width: 130}
        ],
        selModel: 'rowmodel',       // 조회화면 selectionchange event 사용
        listeners: {
            selectionchange: function(grid, selNodes ){
               console.log(selNodes[0]);
                if (typeof selNodes[0] != 'undefined') {
                  console.log("===================="+selNodes[0].data.RETR_TYPE);
                  var person_numb = selNodes[0].data.PERSON_NUMB;
                  var retr_type = selNodes[0].data.RETR_TYPE;
                  var retr_date = selNodes[0].data.RETR_DATE;
                  sub1Store.loadStoreRecords(person_numb, retr_type, retr_date);
                  sub2Store.loadStoreRecords(person_numb, retr_type, retr_date);
                  sub3Store.loadStoreRecords(person_numb, retr_type, retr_date);
                  sub4Store.loadStoreRecords(person_numb, retr_type, retr_date);
                }
            },
            onGridDblClick: function(grid, record, cellIndex, colName) {
                var params = {
                    appId: UniAppManager.getApp().id,
                    sender: this,
                    action: 'new',
                    PERSON_NUMB: panelResult.getValue('PERSON_NUMB'),
                    NAME: panelResult.getValue('NAME'),
                    CODE_NAME: record.get('RETR_TYPE'),
                    //SUPP_DATE: record.get('SUPP_DATE'),
                    RETR_DATE: record.get('RETR_DATE')
                }
                var rec = {data : {prgID : 'hrt506ukr', 'text':''}};                                    
                parent.openTab(rec, '/human/hrt506ukr.do', params);      
            }
        }
    });
	
    var masterGrid3 = Unilite.createGrid('s_hrt705skr_sdGrid3', {
        // for tab    
        title: 'DB형',
        layout: 'fit',
        region:'center',
        uniOpt:{    expandLastColumn: true,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },
      
        store: directMasterStore3,
        columns: [
            {dataIndex: 'COMP_CODE'       , width: 90, hidden: true},
            {dataIndex: 'DIV_CODE'        , width: 120},
            {dataIndex: 'DEPT_NAME'       , width: 150},
            {dataIndex: 'POST_CODE'       , width: 120},
            {dataIndex: 'NAME'            , width: 100},
            {dataIndex: 'PERSON_NUMB'     , width: 100},
            {dataIndex: 'RETR_TYPE'       , width: 100},
            //{dataIndex: 'SUPP_DATE'        , width: 100, hidden: true},
            {dataIndex: 'FIRST_RETR_DATE'       , width: 100, hidden: false},
            {dataIndex: 'LAST_RETR_DATE'       , width: 100},
            {dataIndex: 'DUTY_YYYY'       , width: 100},
            {dataIndex: 'PAY_TOTAL_I'     , width: 100},
            {dataIndex: 'BONUS_TOTAL_I'   , width: 100},
            {dataIndex: 'YEAR_TOTAL_I'    , width: 100},
            {dataIndex: 'ORI_RETR_ANNU_I'     , width: 100, hidden: false},
            {dataIndex: 'PRE_RETR_ANNU_I' , width: 100},
            {dataIndex: 'PRE_DIFF_RETR_ANNU_I'    , width: 130}
        ],
        selModel: 'rowmodel',       // 조회화면 selectionchange event 사용
        listeners: {
            selectionchange: function(grid, selNodes ){
               console.log(selNodes[0]);
                if (typeof selNodes[0] != 'undefined') {
                  console.log("===================="+selNodes[0].data.RETR_TYPE);
                  var person_numb = selNodes[0].data.PERSON_NUMB;
                  var retr_type = selNodes[0].data.RETR_TYPE;
                  var retr_date = selNodes[0].data.RETR_DATE;
                  sub1Store.loadStoreRecords(person_numb, retr_type, retr_date);
                  sub2Store.loadStoreRecords(person_numb, retr_type, retr_date);
                  sub3Store.loadStoreRecords(person_numb, retr_type, retr_date);
                  sub4Store.loadStoreRecords(person_numb, retr_type, retr_date);
                }
            },
            onGridDblClick: function(grid, record, cellIndex, colName) {
                var params = {
                    appId: UniAppManager.getApp().id,
                    sender: this,
                    action: 'new',
                    PERSON_NUMB: panelResult.getValue('PERSON_NUMB'),
                    NAME: panelResult.getValue('NAME'),
                    CODE_NAME: record.get('RETR_TYPE'),
                    //SUPP_DATE: record.get('SUPP_DATE'),
                    RETR_DATE: record.get('RETR_DATE')
                }
                var rec = {data : {prgID : 'hrt506ukr', 'text':''}};                                    
                parent.openTab(rec, '/human/hrt506ukr.do', params);       
            }
        }
    });
	
	var tab = Ext.create('Ext.tab.Panel',{
            region:'center',
//          activeTab: 0,
//          tabPosition : 'bottom',
//          dockedItems : [tbar],
            //layout:  {    type: 'vbox',  align: 'stretch' },
//          layout:  'border',                     
//          flex : 1,
            items: [
                masterGrid1,
                masterGrid2,
                masterGrid3
            ],
            listeners: {
             tabchange: function(){
                var activeTabId = tab.getActiveTab().getId();
                
                if(activeTabId == 's_hrt705skr_sdGrid1'){    
                    Ext.getCmp('quater1').disable();
                    Ext.getCmp('quater2').disable();            
                }else if(activeTabId == 's_hrt705skr_sdGrid2'){      
                    Ext.getCmp('quater1').enable();
                    Ext.getCmp('quater2').enable();       
                }else if(activeTabId == 's_hrt705skr_sdGrid3'){      
                    Ext.getCmp('quater1').disable();
                    Ext.getCmp('quater2').disable();          
                }
             }
         }
        });
        	
	var sub1Grid = Unilite.createGrid('sub1Grid', {
    	// for tab    	
        layout: 'fit',
        region:'west',
    	store: sub1Store,
        columns: [
			{dataIndex: 'PAY_YYYYMM'	, width: 80, align: 'center'},
			{dataIndex: 'WAGES_NAME'	, width: 95},
			{dataIndex: 'AMOUNT_I'		, width: 100}
		] 
	});
	
	var sub2Grid = Unilite.createGrid('sub2Grid', {
    	// for tab    	
        layout: 'fit',
        region:'center',
    	store: sub2Store,
        columns: [
			{dataIndex: 'BONUS_YYYYMM'	, width: 80, align: 'center'},
			{dataIndex: 'BONUS_TYPE'	, width: 95},
			{dataIndex: 'BONUS_I'		, width: 100}
		] 
	});
	
	var sub3Grid = Unilite.createGrid('sub3Grid', {
    	// for tab    	
        layout: 'fit',
        region:'east',
    	store: sub3Store,
        columns: [
			{dataIndex: 'BONUS_YYYYMM'	, width: 80, align: 'center'},
			{dataIndex: 'BONUS_TYPE'	, width: 95},
			{dataIndex: 'BONUS_I'		, width: 100}
		] 
	});
	
	var sub4Grid = Unilite.createGrid('sub4Grid', {
        layout: 'fit',
        region:'east',
    	store: sub4Store,
        columns: [
			{dataIndex: 'PAY_YYYYMM'	, width: 80, align: 'center'},
			{dataIndex: 'WEL_NAME'		, width: 95},
			{dataIndex: 'GIVE_I'		, width: 100}
		] 
	});
	
	
	Unilite.Main( {
		borderItems:[{
			layout:'border',
			region:'center',
			flex:1.4,
			items:[
		 		 //masterGrid1
		 		 tab
			   , panelResult
			   
		    ]
		 }, panelSearch,{
			layout: 'border',
			region: 'south',			
			flex: 0.7,
			items:[
				sub1Grid,
				sub2Grid,
				sub3Grid,
				sub4Grid
			]
		}],

		id: 's_hrt705skr_sdApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelSearch.setValue('BASE_DATE', UniDate.get('today'));
            panelResult.setValue('BASE_DATE', UniDate.get('today'));
            
            Ext.getCmp('quater1').disable();
            Ext.getCmp('quater2').disable();
			
			UniAppManager.setToolbarButtons('reset',false);
			
			var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            
          activeSForm.onLoadSelectText('BASE_DATE');
		},
		onQueryButtonDown: function() {
			
			var activeTabId = tab.getActiveTab().getId();
			//masterGrid1.getStore().loadStoreRecords();
			
			if(!this.isValidSearchForm()){
                return false;
            } else {
    			if(tab.getActiveTab().getId() == 's_hrt705skr_sdGrid1'){
    				//var person_numb = panelResult.getValue('PERSON_NUMB');
    				//var retr_type = panelResult.getValue('RETR_TYPE');
    				//var retr_date = panelResult.getValue('RETR_DATE');
    				    masterGrid1.getStore().loadStoreRecords();
    				    sub1Store.loadStoreRecords();
    				    sub2Store.loadStoreRecords();
    				    sub3Store.loadStoreRecords();
    				    sub4Store.loadStoreRecords();
                        /*var param= Ext.getCmp('searchForm').getValues();
                        panelSearch.getForm().load({
                            params : param,
                            success: function(form, action) {
                                directMasterStore.loadStoreRecords();
                            }
                        });     */        
                    } else if(tab.getActiveTab().getId() == 's_hrt705skr_sdGrid2') {
                        masterGrid2.getStore().loadStoreRecords();
                        sub1Store.loadStoreRecords();
                        sub2Store.loadStoreRecords();
                        sub3Store.loadStoreRecords();
                        sub4Store.loadStoreRecords();
                    } else if(tab.getActiveTab().getId() == 's_hrt705skr_sdGrid3') {
                        masterGrid3.getStore().loadStoreRecords();
                        sub1Store.loadStoreRecords();
                        sub2Store.loadStoreRecords();
                        sub3Store.loadStoreRecords();
                        sub4Store.loadStoreRecords();
                    }
            }
        },

        onSaveDataButtonDown: function() {
            directMasterStore1.saveStore();
            
 /*            s_hrt705skr_sdService.selectExists(param, function(provider, response)  {
       		console.log("response", response);
            	console.log("provider", provider);
            	
            	if(!Ext.isEmpty(provider)){
            		if(confirm('해당정산일에 데이터가 존재합니다. \n 기존데이터를 삭제하시고 \n 새로운 데이터를 생성하시겠습니까?')){
                         alert("생성이 AAAA."); 
                    }
            	}else{
            		directMasterStore1.saveStore();	
            	}
        		
        	}); */
            
        },
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});
    
	//엑셀업로드 윈도우 생성 함수
    function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        if(!directMasterStore1.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
            //masterStore.loadData({});
        } else {
            if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
                UniAppManager.app.onSaveDataButtonDown();
                return;
            }else {
                directMasterStore1.loadData({});
            }
        }
        /*if(!Ext.isEmpty(excelWindow)){
            excelWindow.extParam.DIV_CODE       = panelResult.getValue('DIV_CODE');
//          excelWindow.extParam.ISSUE_GUBUN    = Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//          excelWindow.extParam.APPLY_YN       = Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
        }*/
        if(!excelWindow) { 
            excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
                excelConfigName: 's_hrt705skr_sd1',
                width   : 600,
                height  : 400,
                modal   : false,
                extParam: { 
                    'PGM_ID'    : 's_hrt705skr_sd1'
                    //'DIV_CODE'  : panelResult.getValue('DIV_CODE')
                },
                grids: [{                           //팝업창에서 가져오는 그리드
                        itemId      : 'grid01',
                        title       : '엑셀업로드',                             
                        useCheckbox : false,
                        model       : 'excel.s_hrt705skr_sd.sheet01',
                        readApi     : 's_hrt705skr_sdService.selectExcelUploadSheet1',
                        columns     : [ 
                            {dataIndex: '_EXCEL_JOBID'    	, width: 80     , hidden: true},
                            {dataIndex: 'COMP_CODE'       	, width: 93     , hidden: true},
                            {dataIndex: 'RETR_DATE'      	, width: 100},
                            {dataIndex: 'RETR_TYPE'       	, width: 100},
                            {dataIndex: 'PERSON_NUMB'     	, width: 100},
                            {dataIndex: 'RETR_RESN'       	, width: 100},
                            {dataIndex: 'RETR_PENSION_KIND' , width: 120},
                            {dataIndex: 'ENTR_DATE'       	, width: 100},
                            {dataIndex: 'JOIN_DATE'       	, width: 100},
                            {dataIndex: 'DUTY_YYYY'       	, width: 100},
                            {dataIndex: 'LONG_MONTH'      	, width: 100},
                            {dataIndex: 'LONG_DAY'        	, width: 100},
                            {dataIndex: 'PAY_TOTAL_I'     	, width: 133},
                            {dataIndex: 'BONUS_TOTAL_I'   	, width: 100},
                            {dataIndex: 'YEAR_TOTAL_I'    	, width: 100},
                            {dataIndex: 'TOT_WAGES_I'     	, width: 93} ,
                            {dataIndex: 'AVG_WAGES_I'     	, width: 93} ,
                            {dataIndex: 'ORI_RETR_ANNU_I' 	, width: 100}
                        ]
                    }
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },

                onApply:function()  {
                    excelWindow.getEl().mask('로딩중...','loading-indicator');
                    var me      = this;
                    var grid    = this.down('#grid01');
                    var records = grid.getStore().getAt(0); 
                    if (!Ext.isEmpty(records)) {
                        var param   = {
                            "_EXCEL_JOBID"  : records.get('_EXCEL_JOBID')
                         /*   "PAY_YYYYMM"  : records.get('PAY_YYYYMM'),
                            "PERSON_NUMB"  : records.get('PERSON_NUMB'),
                            "SUPP_TYPE"  : records.get('SUPP_TYPE')*/
                        };
                        excelUploadFlag = "Y"
                        s_hrt705skr_sdService.selectExcelUploadSheet1(param, function(provider, response){
                            var store   = masterGrid1.getStore();
                            var records = response.result;
                            console.log("response",response);
                            
                            Ext.each(records, function(record, idx) {
                                record.SEQ  = idx + 1;
                                store.insert(i, record);
                            });
                            
                            UniAppManager.setToolbarButtons('save',true);
                            
/*                            s_hpa350ukr_ypService.updateDataHpa400(param, function(provider, response) { 
                            });
                            
                            s_hpa350ukr_ypService.updateDataHpa600(param, function(provider, response) { 
                                UniAppManager.app.onQueryButtonDown();
                                alert("완료 되었습니다.");
                            });*/
                            
                            excelWindow.getEl().unmask();
                            grid.getStore().removeAll();
                            me.hide();
                        });
                        excelUploadFlag = "N"

                    } else {
                        alert (Msg.fSbMsgH0284);
                        this.unmask();  
                    }
                    

                    //버튼세팅
                    UniAppManager.setToolbarButtons('newData',  true);
                    UniAppManager.setToolbarButtons('delete',   false);
                },
                
                //툴바 세팅
                _setToolBar: function() {
                    var me = this;
                    me.tbar = [
                    '->',
                    {
                        xtype   : 'button',
                        text    : '업로드',
                        tooltip : '업로드', 
                        width   : 60,
                        handler: function() {
                            me.jobID = null;
                            me.uploadFile();
                        }
                    },{
                        xtype   : 'button',
                        text    : '적용',
                        tooltip : '적용',  
                        width   : 60,
                        handler : function() { 
                            var grids   = me.down('grid');
                            var isError = false;
                            if(Ext.isDefined(grids.getEl()))    {
                                grids.getEl().mask();
                            }
                            Ext.each(grids, function(grid, i){   
                                var records = grid.getStore().data.items;
                                return Ext.each(records, function(record, i){   
                                    if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
                                        console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
                                        isError = true;  
                                        return false;
                                    }
                                });
                            }); 
                            if(Ext.isDefined(grids.getEl()))    {
                                grids.getEl().unmask();
                            }
                            if(!isError) {
                                me.onApply();
                            }else {
                                alert("에러가 있는 행은 적용이 불가능합니다.");
                            }
                        }
                    },{
                            xtype: 'tbspacer'   
                    },{
                            xtype: 'tbseparator'    
                    },{
                            xtype: 'tbspacer'   
                    },{
                        xtype: 'button',
                        text : '닫기',
                        tooltip : '닫기', 
                        handler: function() { 
                            var grid = me.down('#grid01');
                            grid.getStore().removeAll();
                            me.hide();
                        }
                    }
                ]}
            });
        }
        excelWindow.center();
        excelWindow.show();
    };
    
    //엑셀업로드 윈도우 생성 함수
    function openExcelWindow2() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        if(!directMasterStore1.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
            //masterStore.loadData({});
        } else {
            if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
                UniAppManager.app.onSaveDataButtonDown();
                return;
            }else {
                directMasterStore1.loadData({});
            }
        }
        /*if(!Ext.isEmpty(excelWindow)){
            excelWindow.extParam.DIV_CODE       = panelResult.getValue('DIV_CODE');
//          excelWindow.extParam.ISSUE_GUBUN    = Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//          excelWindow.extParam.APPLY_YN       = Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
        }*/
        if(!excelWindow2) { 
            excelWindow2 = Ext.WindowMgr.get(appName);
            excelWindow2 = Ext.create( appName, {
                excelConfigName: 's_hrt705skr_sd2',
                width   : 600,
                height  : 400,
                modal   : false,
                extParam: { 
                    'PGM_ID'    : 's_hrt705skr_sd2'
                    //'DIV_CODE'  : panelResult.getValue('DIV_CODE')
                },
                grids: [{                           //팝업창에서 가져오는 그리드
                        itemId      : 'grid02',
                        title       : '엑셀업로드',                             
                        useCheckbox : false,
                        model       : 'excel.s_hrt705skr_sd.sheet02',
                        readApi     : 's_hrt705skr_sdService.selectExcelUploadSheet2',
                        columns     : [ 
                            {dataIndex: '_EXCEL_JOBID'    , width: 80     , hidden: true},
                            {dataIndex: 'COMP_CODE'       , width: 93     , hidden: true},
                            {dataIndex: 'RETR_TYPE'      , width: 100},
                            {dataIndex: 'PERSON_NUMB'    , width: 100},
                            {dataIndex: 'RETR_DATE'      , width: 100},
                            {dataIndex: 'BONUS_TYPE'      , width: 100},
                            {dataIndex: 'PAY_STRT_DATE'      , width: 100},
                            {dataIndex: 'PAY_LAST_DATE'      , width: 100},
                            {dataIndex: 'WAGES_DAY'      , width: 100},
                            {dataIndex: 'AMOUNT_I'     , width: 100},
                            {dataIndex: 'RETR_RESN'      , width: 100},
                            {dataIndex: 'ENTR_DATE'      , width: 100},
                            {dataIndex: 'JOIN_DATE'      , width: 100},
                            {dataIndex: 'DUTY_YYYY'      , width: 100},
                            {dataIndex: 'LONG_MONTH'      , width: 100},
                            {dataIndex: 'LONG_DAY'      , width: 100},
                            {dataIndex: 'PAY_TOTAL_I'      , width: 100},
                            {dataIndex: 'BONUS_TOTAL_I'      , width: 100},
                            {dataIndex: 'YEAR_TOTAL_I'      , width: 100},
                            {dataIndex: 'TOT_WAGES_I'      , width: 100},
                            {dataIndex: 'AVG_WAGES_I'      , width: 100},
                            {dataIndex: 'ORI_RETR_ANNU_I'      , width: 100}                      
                        ]
                    }
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },

                onApply:function()  {
                    excelWindow2.getEl().mask('로딩중...','loading-indicator');
                    var me      = this;
                    var grid    = this.down('#grid02');
                    var records = grid.getStore().getAt(0); 
                    if (!Ext.isEmpty(records)) {
                        var param   = {
                            "_EXCEL_JOBID"  : records.get('_EXCEL_JOBID')
                         /*   "PAY_YYYYMM"  : records.get('PAY_YYYYMM'),
                            "PERSON_NUMB"  : records.get('PERSON_NUMB'),
                            "SUPP_TYPE"  : records.get('SUPP_TYPE')*/
                        };
                        excelUploadFlag = "Y"
                        s_hrt705skr_sdService.selectExcelUploadSheet2(param, function(provider, response){
                            var store   = masterGrid1.getStore();
                            var records = response.result;
                            console.log("response",response);
                            
                            Ext.each(records, function(record, idx) {
                                record.SEQ  = idx + 1;
                                store.insert(idx, record);
                            });
                            
                            UniAppManager.setToolbarButtons('save',true);
                            
/*                            s_hpa350ukr_ypService.updateDataHpa400(param, function(provider, response) { 
                            });
                            
                            s_hpa350ukr_ypService.updateDataHpa600(param, function(provider, response) { 
                                UniAppManager.app.onQueryButtonDown();
                                alert("완료 되었습니다.");
                            });*/
                            
                            excelWindow2.getEl().unmask();
                            grid.getStore().removeAll();
                            me.hide();
                        });
                        excelUploadFlag = "N"

                    } else {
                        alert (Msg.fSbMsgH0284);
                        this.unmask();  
                    }
                    

                    //버튼세팅
                    UniAppManager.setToolbarButtons('newData',  true);
                    UniAppManager.setToolbarButtons('delete',   false);
                },
                
                //툴바 세팅
                _setToolBar: function() {
                    var me = this;
                    me.tbar = [
                    '->',
                    {
                        xtype   : 'button',
                        text    : '업로드',
                        tooltip : '업로드', 
                        width   : 60,
                        handler: function() {
                            me.jobID = null;
                            me.uploadFile();
                        }
                    },{
                        xtype   : 'button',
                        text    : '적용',
                        tooltip : '적용',  
                        width   : 60,
                        handler : function() { 
                            var grids   = me.down('grid');
                            var isError = false;
                            if(Ext.isDefined(grids.getEl()))    {
                                grids.getEl().mask();
                            }
                            Ext.each(grids, function(grid, i){   
                                var records = grid.getStore().data.items;
                                return Ext.each(records, function(record, i){   
                                    if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
                                        console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
                                        isError = true;  
                                        return false;
                                    }
                                });
                            }); 
                            if(Ext.isDefined(grids.getEl()))    {
                                grids.getEl().unmask();
                            }
                            if(!isError) {
                                me.onApply();
                            }else {
                                alert("에러가 있는 행은 적용이 불가능합니다.");
                            }
                        }
                    },{
                            xtype: 'tbspacer'   
                    },{
                            xtype: 'tbseparator'    
                    },{
                            xtype: 'tbspacer'   
                    },{
                        xtype: 'button',
                        text : '닫기',
                        tooltip : '닫기', 
                        handler: function() { 
                            var grid = me.down('#grid02');
                            grid.getStore().removeAll();
                            me.hide();
                        }
                    }
                ]}
            });
        }
        excelWindow2.center();
        excelWindow2.show();
    };
};


</script>
