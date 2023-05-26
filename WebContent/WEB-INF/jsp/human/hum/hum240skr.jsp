<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum240skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H095" /> <!-- 고과구분 -->
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
	Unilite.defineModel('Hum240skrModel', {
	    fields: [
			{name: 'DIV_CODE'				, text: '사업장'		, type:'string', comboType:'AU', comboCode:'B001'},
	     	 {name: 'DEPT_NAME'				, text: '부서'		, type:'string'},
	     	 {name: 'POST_CODE'				, text: '직위'		, type:'string', comboType:'AU', comboCode:'H005'},
	     	 {name: 'NAME'					, text: '성명'		, type:'string'},
	     	 {name: 'PERSON_NUMB'			, text: '사번'		, type:'string'},
	     	 {name: 'PAY_GRADE_01'			, text: '급'			, type:'string'},
	     	 {name: 'PAY_GRADE_02'			, text: '호'			, type:'string'},
	     	 {name: 'MERITS_YEARS'			, text: '고과년도'		, type:'string'},
	     	 {name: 'MERITS_GUBUN'			, text: '고과구분'		, type:'string', comboType:'AU', comboCode:'H095'},
	     	 {name: 'DEPT_NAME2'			, text: '근무부서'		, type:'string'},
	     	 {name: 'MERITS_CLASS'			, text: '등급'		, type:'string'},
	     	 {name: 'MERITS_GRADE'			, text: '점수'		, type:'string'},
	     	 {name: 'GRADE_PERSON_NAME'		, text: '평가자성명'	, type:'string'},
	     	 {name: 'GRADE_PERSON_NUMB'		, text: '평가자사번'	, type:'string'}
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
	var directMasterStore = Unilite.createStore('hum240skrMasterStore1',{
		model: 'Hum240skrModel',
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
                read: 'hum240skrService.selectDataList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
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
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [
			{
	        	xtype: 'fieldcontainer',
	            defaultType: 'uniYearField',// uniYearPicker - uniYearField
	            fieldLabel: '고과년도',
	            layout: {
	            	type: 'table',
	            	columns: 3
	            },
	            flex: 1,
	            items: [
	                {
	                	id: 'MERITS_YEARS_FROM',
						name: 'MERITS_YEARS_FROM',
						width: 60,
						maxLength: 4						
				    },
				    {
				    	xtype: 'displayfield',
				    	value: '&nbsp;~&nbsp;'
				    },
				    {
						name: 'MERITS_YEARS_TO',
						width: 60,
						maxLength: 4
				    }
	            ]	            
	        },
			{ 
	        	fieldLabel: '사업장',
	        	name: 'DIV_CODE', 
	        	id: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	value :'01'      	
        	},
			    Unilite.popup('DEPT',{ 
				    fieldLabel: '부서', 
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
			]},{
				title:'추가정보',
   				id: 'search_panel2',
				itemId:'search_panel2',
        		defaultType: 'uniTextfield',
        		layout : {type : 'uniTable', columns : 1},
        		defaultType: 'uniTextfield',
        		
        		items:[{
		            xtype: 'fieldcontainer',
	                fieldLabel: '급호',
	                colspan : 1,
	                combineErrors: true,
	                msgTarget : 'side',
	                layout: {
	                	type : 'table', 
	                	columns : 2
	            },
	                defaults: {
	                	flex: 1, 
	                	hideLabel: true
				},
	                defaultType: 'textfield',
	                items: [
	                	Unilite.popup('PAY_GRADE',{ 
	                		fieldLabel: '급', 
	                		textFieldWidth:85, 
	                		validateBlank:false
	                	})
				]},{
					fieldLabel: '고과구분',  
					name: 'MERITS_GUBUN', 
					xtype: 'uniCombobox', 
					comboType:'AU', 
					comboCode:'H095'
				},{
					xtype: 'radiogroup',		            		
					fieldLabel: '재직구분',						            		
					id: 'rdoSelect',
					items: [{
						boxLabel: '전체', 
						width: 70, 
						name: 'RDO_TYPE',
						inputValue: ''  
					},{
						boxLabel : '재직', 
						width: 70,
						name: 'RDO_TYPE',
						inputValue: 'z',
						checked: true
					},{
						boxLabel: '퇴사', 
						width: 70, 
						name: 'RDO_TYPE',
						inputValue: '00000000'	
					}]
				},{
					xtype: 'radiogroup',		            		
					fieldLabel: '성별',						            		
					id: 'rdoSelect1',
					items: [{
						boxLabel: '전체', 
						width: 70, 
						name: 'SEX_CODE',
						inputValue: '',
						checked: true  
					},{
						boxLabel : '남', 
						width: 70,
						name: 'SEX_CODE',
						inputValue: 'M'
					},{
						boxLabel: '여', 
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
    
    var masterGrid = Unilite.createGrid('hum240skrGrid1', {
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
            {dataIndex: 'DIV_CODE'		, width: 150	, text: '사업장'	,locked: true},            
            {dataIndex: 'DEPT_NAME'		, width: 80		, text: '부서'		,locked: true},
            {dataIndex: 'POST_CODE'		, width: 150	, text: '직위'		,locked: true},
            {dataIndex: 'NAME'			, width: 170	, text: '성명'		,locked: true},
            {dataIndex: 'PERSON_NUMB'	, width: 150	, text: '사번'		,locked: true},
            {dataIndex: 'PAY_GRADE_01'	, width: 100	, text: '급'},
            {dataIndex: 'PAY_GRADE_02'	, width: 100	, text: '호'},
            {dataIndex: 'MERITS_YEARS'	, width: 150	, text: '고과연도'},
            {dataIndex: 'MERITS_GUBUN'	, width: 150	, text: '고과구분'},
            {dataIndex: 'DEPT_NAME2'	, width: 150	, text: '근무부서'},
            {text: '고과결과',
                columns:[ 	 
                	{dataIndex: 'MERITS_CLASS'	, width: 150	, text: '등급'},
                	{dataIndex: 'MERITS_GRADE'	, width: 150	, text: '점수'}
               	]
            },
            {text: '평가자',
                columns:[ 	 
                	{dataIndex: 'GRADE_PERSON_NAME'	, width: 150	, text: '성명'},
                	{dataIndex: 'GRADE_PERSON_NUMB'	, width: 150	, text: '사번'}
               	]
            },
            {text: '평가자2',
                columns:[ 	 
                	{dataIndex: 'GRADE_PERSON_NAME2'	, width: 150	, text: '성명'},
                	{dataIndex: 'GRADE_PERSON_NUMB2'	, width: 150	, text: '사번'}
               	]
            },
            {dataIndex: 'SYNTHETIC_EVAL'	, width: 150	, text: '종합평가'}
            ]   
    });                          
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[ 
		 		 masterGrid
				,panelSearch
		], 
		id : 'hum240skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			var meritsYearsFrom = panelSearch.getValue('MERITS_YEARS_FROM');
			var meritsYearsTo   = panelSearch.getValue('MERITS_YEARS_TO');
			
			if(meritsYearsFrom && meritsYearsTo && meritsYearsFrom != '' && meritsYearsTo != ''){
				if(meritsYearsFrom > meritsYearsTo){
					Ext.Msg.alert(Msg.sMB099, Msg.sMB084, function(){
						panelSearch.down('[name=MERITS_YEARS_FROM]').focus();
					});
					
					return;
				}
			}
			
			directMasterStore.loadStoreRecords();
		}
	});
};

</script>
