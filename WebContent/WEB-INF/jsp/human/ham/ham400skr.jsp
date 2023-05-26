<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham400skr"  >
<t:ExtComboStore comboType="BOR120" pgmId="ham400skr" /> 			<!-- 사업장 -->
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
	Unilite.defineModel('Ham400skrModel', {
		fields: [
			{name: 'YEAR'			, text: '년도'			, type: 'string'},
			{name: 'MONTH'			, text: '월'				, type: 'string'},
			{name: 'CONT_MAN'		, text: '계속근무인원-남'	, type: 'int'},
			{name: 'CONT_FEM'		, text: '계속근무인원-여'	, type: 'int'},
			{name: 'CONT_SUM'		, text: '계속근무인원-합계'	, type: 'int'},
			{name: 'INNE_MAN'		, text: '입사인원-남'		, type: 'int'},
			{name: 'INNE_FEM'		, text: '입사인원-여'		, type: 'int'},
			{name: 'INNE_SUM'		, text: '입사인원-합계'		, type: 'int'},
			{name: 'OUTE_MAN'		, text: '퇴사인원-남'		, type: 'int'},
			{name: 'OUTE_FEM'		, text: '퇴사인원-여'		, type: 'int'},
			{name: 'OUTE_SUM'		, text: '퇴사인원-'		, type: 'int'},
			{name: 'FINE_MAN'		, text: '월말인원-남'		, type: 'int'},
			{name: 'FINE_FEM'		, text: '월말인원-여'		, type: 'int'},
			{name: 'FINE_SUM'		, text: '월말인원-합계'		, type: 'int'}
		]
	});//End of Unilite.defineModel('Ham400skrModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ham400skrMasterStore1', {
			model: 'Ham400skrModel',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
			},
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ham400skrService.selectList'                	
                }
            },
			loadStoreRecords: function() {
				var param= Ext.getCmp('searchForm').getValues();			
				console.log(param);
				this.load({
					params: param
				});	
			}
			
	});//End of var directMasterStore1 = Unilite.createStore('ham400skrMasterStore1', {

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
    			fieldLabel: '기준년월',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'DATE',
		        endFieldName: 'DATE2',
		        width: 325,
		        //startDate: UniDate.get('startOfMonth'),
		        //endDate: UniDate.get('today'),
		        allowBlank: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DATE', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DATE2', newValue);				    		
			    	}
			    }
	        },{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
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
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
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
			})]                 	            	           			 
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	var panelResult = Unilite.createSimpleForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{ 
	    			fieldLabel: '기준년월',
			        xtype: 'uniMonthRangefield',
			        startFieldName: 'DATE',
			        endFieldName: 'DATE2',
			        width: 325,
			        colspan:3,
			        //startDate: UniDate.get('startOfMonth'),
			        //endDate: UniDate.get('today'),
			        allowBlank: false,                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
							panelSearch.setValue('DATE', newValue);						
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelSearch) {
				    		panelSearch.setValue('DATE2', newValue);				    		
				    	}
				    }
		        },{
					fieldLabel: '사업장',
					name:'DIV_CODE', 
					xtype: 'uniCombobox',
			        multiSelect: true, 
			        typeAhead: false,
			        comboType:'BOR120',
					width: 325,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},
	        	Unilite.treePopup('DEPTTREE',{
					fieldLabel: '부서',
					valueFieldName:'DEPT',
					textFieldName:'DEPT_NAME' ,
					valuesName:'DEPTS' ,
					DBvalueFieldName:'TREE_CODE',
					DBtextFieldName:'TREE_NAME',
					selectChildren:true,
					textFieldWidth:89,
					validateBlank:true,
					width:300,
					autoPopup:true,
					useLike:true,
					colspan:2,
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
				})]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('ham400skrGrid1', {
    	// for tab    	
		layout: 'fit',
		region:'center',
		uniOpt:{	
        	expandLastColumn: true,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: false,			
			onLoadSelectFirst	: true,
			useMultipleSorting	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
    	features: [{
			id: 'masterGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'masterGridTotal',		
			ftype: 'uniSummary',			
			showSummaryRow: false
			}
    	],
        features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
    	store: directMasterStore1,
        columns: [{ 
        	dataIndex:'YEAR' 	 		, width: 100 , align: 'center'
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
 			{dataIndex:'MONTH' 			, width: 88 , align: 'center'},
        	{text: '계속근무인원',
					columns:[
						{dataIndex: 'CONT_MAN',  width: 88,   text: '남자'  , summaryType: 'sum'},
                		{dataIndex: 'CONT_FEM',  width: 88,   text: '여자'  , summaryType: 'sum'},
                		{dataIndex: 'CONT_SUM',  width: 88,   text: '합계'  , summaryType: 'sum'}
                	]
            },{text: '입사인원',
                	columns:[ 	 
                		{dataIndex: 'INNE_MAN',  width: 88,   text: '남자',  summaryType: 'sum'},
                		{dataIndex: 'INNE_FEM',  width: 88,   text: '여자',  summaryType: 'sum'},
                		{dataIndex: 'INNE_SUM',  width: 88,   text: '합계',  summaryType: 'sum'}
                	]
            },{text: '퇴사인원',
                	columns:[ 	
                		{dataIndex: 'OUTE_MAN',  width: 88,   text: '남자',  summaryType: 'sum'},
                		{dataIndex: 'OUTE_FEM',  width: 88,   text: '여자',  summaryType: 'sum'},
                		{dataIndex: 'OUTE_SUM',  width: 88,   text: '합계',  summaryType: 'sum'}
                	 ]
            },{text: '월말인원',
                	columns:[ 	 
                		{dataIndex: 'FINE_MAN',  width: 88,   text: '남자', summaryType:'sum'},
                		{dataIndex: 'FINE_FEM',  width: 88,   text: '여자', summaryType:'sum'},
                		{dataIndex: 'FINE_SUM',  width: 88,   text: '합계', summaryType:'sum'}
                	]
			}
		]
	});//End of var masterGrid = Unilite.createGrid('ham400skrGrid1', {   

	 Unilite.Main({
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
		id: 'ham400skrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DATE',UniDate.get('today'));
			panelResult.setValue('DATE',UniDate.get('today'));
			panelSearch.setValue('DATE2',UniDate.get('today'));
			panelResult.setValue('DATE2',UniDate.get('today'));
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DATE');
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			var viewNormal = masterGrid.getView();
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
				
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},/*,
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			
			this.fnInitBinding();
		},*/
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});//End of Unilite.Main( {
};


</script>
