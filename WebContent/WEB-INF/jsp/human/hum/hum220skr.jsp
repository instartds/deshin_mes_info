<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum220skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H173" /><!--  직렬             -->
	<t:ExtComboStore comboType="AU" comboCode="H072" /><!--  직종      -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /><!--  직위      -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /><!--  직책      -->
	<t:ExtComboStore comboType="AU" comboCode="H094" /><!--  발령코드      -->

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
	Unilite.defineModel('Hum220skrModel', {
	    fields: [
			{name: 'DIV_CODE'					, text: '<t:message code="system.label.human.division" default="사업장"/>'		, type: 'string'},
			{name: 'DEPT_NAME'				, text: '<t:message code="system.label.human.department" default="부서"/>'		, type: 'string'},
			{name: 'POST_CODE'					, text: '<t:message code="system.label.human.postcode" default="직위"/>'		, type: 'string' , comboType: 'AU',comboCode: 'H005' },
			{name: 'NAME'							, text: '<t:message code="system.label.human.name" default="성명"/>'		, type: 'string'},
			{name: 'PERSON_NUMB'			, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, type: 'string'},
			{name: 'ANNOUNCE_DATE'		, text: '<t:message code="system.label.human.announcedate" default="발령일자"/>'		, type: 'uniDate'},
			{name: 'ANNOUNCE_CODE'	, text: '<t:message code="system.label.human.announcecode" default="발령코드"/>'		, type: 'string' , comboType: 'AU',comboCode: 'H094'},
			{name: 'BE_DIV_NAME'				, text: '<t:message code="system.label.human.bedivname" default="발령전 사업장"/>'	, type: 'string'},
			{name: 'AF_DIV_NAME'				, text: '<t:message code="system.label.human.afdivname" default="발령후 사업장"/>'	, type: 'string'},
			{name: 'BE_DEPT_NAME'			, text: '<t:message code="system.label.human.bedeptname" default="발령전 부서명"/>'	, type: 'string'},
			{name: 'AF_DEPT_NAME'			, text: '<t:message code="system.label.human.afdeptname" default="발령후 부서명"/>'	, type: 'string'},
			{name: 'POST_CODE2'				, text: '<t:message code="system.label.human.postcode" default="직위"/>'		, type: 'string' , comboType: 'AU' , comboCode: 'H005' },
			{name: 'AF_POST_CODE'              , text: '<t:message code="system.label.human.postcode" default="직위"/>'      , type: 'string' , comboType: 'AU' , comboCode: 'H005' },
			{name: 'ABIL_CODE'					, text: '<t:message code="system.label.human.abil" default="직책"/>'		, type: 'string' , comboType: 'AU' , comboCode: 'H006'},
			{name: 'AF_ABIL_CODE'                   , text: '<t:message code="system.label.human.abil" default="직책"/>'      , type: 'string' , comboType: 'AU' , comboCode: 'H006'},
			//{name: 'ANNUAL_SALARY_I'	, text: '<t:message code="system.label.human.annualsalaryi" default="연봉"/>'		, type: 'uniPrice'},
			{name: 'ANNOUNCE_REASON', text: '<t:message code="system.label.human.announcereason" default="발령사유"/>'		, type: 'string'},    
			{name: 'AFFIL_CODE', text: '<t:message code="system.label.human.serial" default="직렬"/>'               , type: 'string', comboType: 'AU' , comboCode: 'H173'},
			{name: 'AF_AFFIL_CODE', text: '<t:message code="system.label.human.serial" default="직렬"/>'               , type: 'string', comboType: 'AU' , comboCode: 'H173'},
			{name: 'KNOC', text: '<t:message code="system.label.human.ocpt" default="직종"/>'                 , type: 'string', comboType: 'AU', comboCode: 'H072'},
			{name: 'AF_KNOC', text: '<t:message code="system.label.human.ocpt" default="직종"/>'                 , type: 'string', comboType: 'AU', comboCode: 'H072'},
			{name: 'PAY_GRADE_01', text: '<t:message code="system.label.human.paygrade01" default="호봉(급)"/>'                 , type: 'string'},
			{name: 'PAY_GRADE_02', text: '<t:message code="system.label.human.paygrade02" default="호봉(호)"/>'                 , type: 'string'},
			{name: 'AF_PAY_GRADE_01', text: '<t:message code="system.label.human.paygrade01" default="호봉(급)"/>'                 , type: 'string'},
			{name: 'AF_PAY_GRADE_02', text: '<t:message code="system.label.human.paygrade02" default="호봉(호)"/>'                 , type: 'string'}
	    ]
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hum220skrMasterStore1',{
		model: 'Hum220skrModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hum220skrService.selectDataList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
                load: function(store, records, successful, eOpts) {
                    Ext.each(records, function(record, rowIndex){
                    	
                        if(record.get('BE_DIV_NAME') == record.get('AF_DIV_NAME')){
                            record.set('BE_DIV_NAME' , record.get('BE_DIV_NAME'));
                            record.set('AF_DIV_NAME' , '');
                        }else{
                        	record.set('BE_DIV_NAME' , record.get('BE_DIV_NAME'));
                            record.set('AF_DIV_NAME' , record.get('AF_DIV_NAME'));
                        }
                        
                        if(record.get('BE_DEPT_NAME') == record.get('AF_DEPT_NAME')){
                            record.set('BE_DEPT_NAME' , record.get('BE_DEPT_NAME'));
                            record.set('AF_DEPT_NAME' , '');
                        }else{
                            record.set('BE_DEPT_NAME' , record.get('BE_DEPT_NAME'));
                            record.set('AF_DEPT_NAME' , record.get('AF_DEPT_NAME'));
                        }
                        
                        if(record.get('POST_CODE2') == record.get('AF_POST_CODE')){
                            record.set('POST_CODE2' , record.get('POST_CODE2'));
                            record.set('AF_POST_CODE' , '');
                        }else{
                            record.set('POST_CODE2' , record.get('POST_CODE2'));
                            record.set('AF_POST_CODE' , record.get('AF_POST_CODE'));
                        }
                        
                        if(record.get('ABIL_CODE') == record.get('AF_ABIL_CODE')){
                            record.set('ABIL_CODE' , record.get('ABIL_CODE'));
                            record.set('AF_ABIL_CODE' , '');
                        }else{
                            record.set('ABIL_CODE' , record.get('ABIL_CODE'));
                            record.set('AF_ABIL_CODE' , record.get('AF_ABIL_CODE'));
                        }
                        
                        if(record.get('AFFIL_CODE') == record.get('AF_AFFIL_CODE')){
                            record.set('AFFIL_CODE' , record.get('AFFIL_CODE'));
                            record.set('AF_AFFIL_CODE' , '');
                        }else{
                            record.set('AFFIL_CODE' , record.get('AFFIL_CODE'));
                            record.set('AF_AFFIL_CODE' , record.get('AF_AFFIL_CODE'));
                        }
                        
                        if(record.get('KNOC') == record.get('AF_KNOC')){
                            record.set('KNOC' , record.get('KNOC'));
                            record.set('AF_KNOC' , '');
                        }else{
                            record.set('KNOC' , record.get('KNOC'));
                            record.set('AF_KNOC' , record.get('AF_KNOC'));
                        }
                        
                        //directMasterStore.remove(record);
                        directMasterStore.commitChanges();
                        
                    });
                }
		}
	});
	var panelResult = Unilite.createSearchForm('resultForm', {    
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        
            items: [{ 
                fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
                name: 'DIV_CODE', 
                xtype: 'uniCombobox', 
                comboType:'BOR120',
                value :'01'         
            },
                Unilite.popup('DEPT',{ 
                        fieldLabel: '<t:message code="system.label.human.department" default="부서"/>', 
                        valueFieldName:'DEPT_CODE_FROM',
                        textFieldName:'DEPT_NAME_FROM',
                        textFieldWidth: 170, 
                        validateBlank: false, 
                        popupWidth: 400
                }),     
                    Unilite.popup('DEPT',{ 
                        fieldLabel: '~', 
                        valueFieldName:'DEPT_CODE_TO',
                        textFieldName:'DEPT_NAME_TO',
                        textFieldWidth: 170, 
                        validateBlank: false, 
                        popupWidth: 400
                }),
                    Unilite.popup('Employee',{ 
                         
                        textFieldWidth: 170, 
                        validateBlank: false, 
                        popupWidth: 400
                }),
                /*
                    Unilite.popup('Employee',{ 
                         
                        textFieldWidth: 170, 
                        validateBlank: false, 
                        popupWidth: 400
                    })
                */
                {
                    fieldLabel: '<t:message code="system.label.human.announcedate" default="발령일자"/>',
                    xtype: 'uniDateRangefield',
                    startFieldName: 'ANNOUNCE_DATE_FROM',
                    startDate: UniDate.get(''),
                    endFieldName: 'ANNOUNCE_DATE_TO',
                    endDate: UniDate.get(''),
                    width: 315,
                    startDate: UniDate.get(''),
                    textFieldWidth:170
                },{
                    fieldLabel: '<t:message code="system.label.human.announcecode" default="발령코드"/>',  
                    name: 'ANNOUNCE_CODE', 
                    xtype: 'uniCombobox', 
                    comboType:'AU', 
                    comboCode:'H094' 
                },{
                    xtype: 'radiogroup',                            
                    fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',           
                    items: [{
                        boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
                        width: 70, 
                        name: 'RDO_TYPE',
                        inputValue: ''  
                    },{
                        boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>', 
                        width: 70,
                        name: 'RDO_TYPE',
                        inputValue: 'z',
                        checked: true
                    },{
                        boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
                        width: 70, 
                        name: 'RDO_TYPE',
                        inputValue: '00000000'  
                    }]
                },{
                    xtype: 'radiogroup',                            
                    fieldLabel: '<t:message code="system.label.human.sexcode" default="성별"/>',                    
                    items: [{
                        boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
                        width: 70, 
                        name: 'SEX_CODE',
                        inputValue: '',
                        checked: true  
                    },{
                        boxLabel : '<t:message code="system.label.human.male" default="남"/>', 
                        width: 70,
                        name: 'SEX_CODE',
                        inputValue: 'M'
                    },{
                        boxLabel: '<t:message code="system.label.human.female" default="여"/>', 
                        width: 70, 
                        name: 'SEX_CODE',
                        inputValue: 'F' 
                }]
            }
                ]      
    }); //end panelResult  
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
        listeners: {
            collapse: function () {
                panelResult.show();
            },
            expand: function() {
                panelResult.hide();
            }
        },
		items: [{	
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{ 
	        	fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
	        	id: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	value :'01'      	
        	},
			    Unilite.popup('DEPT',{ 
					    fieldLabel: '<t:message code="system.label.human.department" default="부서"/>', 
					    valueFieldName:'DEPT_CODE_FROM',
					    textFieldName:'DEPT_NAME_FROM',
					    textFieldWidth: 170, 
					    validateBlank: false, 
					    popupWidth: 400
				}),   	
					Unilite.popup('DEPT',{ 
					    fieldLabel: '~', 
					    valueFieldName:'DEPT_CODE_TO',
					    textFieldName:'DEPT_NAME_TO',
					    textFieldWidth: 170, 
					    validateBlank: false, 
					    popupWidth: 400
				}),
					Unilite.popup('Employee',{ 
					     
					    textFieldWidth: 170, 
					    validateBlank: false, 
					    popupWidth: 400
				})
				/*
					Unilite.popup('Employee',{ 
					     
					    textFieldWidth: 170, 
					    validateBlank: false, 
					    popupWidth: 400
					})
				*/
				]},{
				title:'<t:message code="system.label.human.addinfo" default="추가정보"/>',
   				id: 'search_panel2',
				itemId:'search_panel2',
        		defaultType: 'uniTextfield',
        		layout : {type : 'uniTable', columns : 1},
        		defaultType: 'uniTextfield',
        		
        		items:[{
		        	fieldLabel: '<t:message code="system.label.human.announcedate" default="발령일자"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'ANNOUNCE_DATE_FROM',
					startDate: UniDate.get(''),
					endFieldName: 'ANNOUNCE_DATE_TO',
					endDate: UniDate.get(''),
					width: 315,
					startDate: UniDate.get(''),
					textFieldWidth:170
				},{
	           		fieldLabel: '<t:message code="system.label.human.announcecode" default="발령코드"/>',  
	           		name: 'ANNOUNCE_CODE', 
	           		xtype: 'uniCombobox', 
	           		comboType:'AU', 
	           		comboCode:'H094' 
	           	},{
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',						            		
					id: 'rdoSelect',
					items: [{
						boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
						width: 70, 
						name: 'RDO_TYPE',
						inputValue: ''  
					},{
						boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>', 
						width: 70,
						name: 'RDO_TYPE',
						inputValue: 'z',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
						width: 70, 
						name: 'RDO_TYPE',
						inputValue: '00000000'	
					}]
				},{
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.human.sexcode" default="성별"/>',						            		
					id: 'rdoSelect1',
					items: [{
						boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
						width: 70, 
						name: 'SEX_CODE',
						inputValue: '',
						checked: true  
					},{
						boxLabel : '<t:message code="system.label.human.male" default="남"/>', 
						width: 70,
						name: 'SEX_CODE',
						inputValue: 'M'
					},{
						boxLabel: '<t:message code="system.label.human.female" default="여"/>', 
						width: 70, 
						name: 'SEX_CODE',
						inputValue: 'F'	
				}]
			}]				
		}]		
	});	//end panelSearch 
	
	
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('hum220skrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: false,
                    useMultipleSorting: false,
                    onLoadSelectFirst: false,
                    state: {
            			useState: false,
            			useStateList: false
            		}
        },
		store: directMasterStore,
        columns: [        
            {dataIndex: 'DIV_CODE'			, width: 80	, locked:true  },               
            {dataIndex: 'DEPT_NAME'			, width: 80	, locked:true  },
            {dataIndex: 'POST_CODE'			, width: 80	, text: '<t:message code="system.label.human.postcode" default="직위"/>',    locked:true  },
            {dataIndex: 'NAME'				, width: 80	, text: '<t:message code="system.label.human.name" default="성명"/>',   locked:true  },
            {dataIndex: 'PERSON_NUMB'		, width: 80	, text: '<t:message code="system.label.human.personnumb" default="사번"/>',    locked:true },
            
            {dataIndex: 'ANNOUNCE_DATE'		, width: 80	, text: '<t:message code="system.label.human.announcedate" default="발령일자"/>' },
            {dataIndex: 'ANNOUNCE_CODE'		, width: 80	, text: '<t:message code="system.label.human.announcecode" default="발령코드"/>' },
            
            	
            {text: '<t:message code="system.label.human.division" default="사업장"/>',
            	columns:[ 	 
            		{dataIndex: 'BE_DIV_NAME', width: 80	, text: '<t:message code="system.label.human.bedept" default="발령전"/>',height:25},
            		{dataIndex: 'AF_DIV_NAME', width: 80	, text: '<t:message code="system.label.human.afdept" default="발령후"/>',height:25}
            	]
            },
            {text: '<t:message code="system.label.human.department" default="부서"/>',
            	columns:[ 	 
            		{dataIndex: 'BE_DEPT_NAME',  width: 80	, text: '<t:message code="system.label.human.bedept" default="발령전"/>'},
            		{dataIndex: 'AF_DEPT_NAME',  width: 80	, text: '<t:message code="system.label.human.afdept" default="발령후"/>'}
            	]
            },
            {text: '<t:message code="system.label.human.postcode" default="직위"/>',
                columns:[    
                    {dataIndex: 'POST_CODE2', width: 80    , text: '<t:message code="system.label.human.bedept" default="발령전"/>',height:25},
                    {dataIndex: 'AF_POST_CODE', width: 80    , text: '<t:message code="system.label.human.afdept" default="발령후"/>',height:25}
                ]
            },
            {text: '<t:message code="system.label.human.abil" default="직책"/>',
                columns:[    
                    {dataIndex: 'ABIL_CODE', width: 80    , text: '<t:message code="system.label.human.bedept" default="발령전"/>',height:25},
                    {dataIndex: 'AF_ABIL_CODE', width: 80    , text: '<t:message code="system.label.human.afdept" default="발령후"/>',height:25}
                ]
            },
            {text: '<t:message code="system.label.human.serial" default="직렬"/>',
                columns:[    
                    {dataIndex: 'AFFIL_CODE', width: 80    , text: '<t:message code="system.label.human.bedept" default="발령전"/>',height:25},
                    {dataIndex: 'AF_AFFIL_CODE', width: 80    , text: '<t:message code="system.label.human.afdept" default="발령후"/>',height:25}
                ]
            },
            {text: '<t:message code="system.label.human.ocpt" default="직종"/>',
                columns:[    
                    {dataIndex: 'KNOC', width: 80    , text: '<t:message code="system.label.human.bedept" default="발령전"/>',height:25},
                    {dataIndex: 'AF_KNOC', width: 80    , text: '<t:message code="system.label.human.afdept" default="발령후"/>',height:25}
                ]
            },
            {text: '급 호',
                columns:[    
                    {dataIndex: 'PAY_GRADE_01', width: 80    , text: '<t:message code="system.label.human.bedept" default="발령전"/>',height:25},
                    {dataIndex: 'PAY_GRADE_02', width: 80    , text: '<t:message code="system.label.human.bedept" default="발령전"/>',height:25},
                    {dataIndex: 'AF_PAY_GRADE_01', width: 80    , text: '<t:message code="system.label.human.afdept" default="발령후"/>',height:25},
                    {dataIndex: 'AF_PAY_GRADE_02', width: 80    , text: '<t:message code="system.label.human.afdept" default="발령후"/>',height:25}
                ]
            },
//            {text: '<t:message code="system.label.human.paygrade02" default="호봉(호)"/>',
//                columns:[    
//                    
//                ]
//            },
            //{dataIndex: 'ANNUAL_SALARY_I'			,  width: 80	, text: '<t:message code="system.label.human.annualsalaryi" default="연봉"/>'},
            {dataIndex: 'ANNOUNCE_REASON'	,  width: 300	, text: '<t:message code="system.label.human.announcereason" default="발령사유"/>'}
            
         ]  
    });                          
    
	 Unilite.Main( {
	 	border: false,
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
		id : 'hum220skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			directMasterStore.loadStoreRecords();
		}
	});
};


</script>
