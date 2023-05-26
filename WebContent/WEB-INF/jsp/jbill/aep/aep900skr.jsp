<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep900skr"  >

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aep900skrModel', {
	    fields: [
			{name: 'KEY'			, text: 'KEY'		, type: 'string' },
			{name: 'LOG_GUBUN'		, text: '로그구분'		, type: 'string' },
			{name: 'CTR_NUM'		, text: '관리번호'		, type: 'string' },
			{name: 'TITLE'			, text: '제목'		, type: 'string' },
			{name: 'LOG_STAT'		, text: '로그상태'		, type: 'string' },
			{name: 'REG_DATE'		, text: '등록일'		, type: 'uniDate'}
	    ] 
	});
	
	  
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aep900skrMasterStore1',{
		model	: 'aep900skrModel',
		uniOpt	: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: {
           type: 'direct',
            api: {			
                read: 'aep900skrService.selectList'                	
            }
        },
        loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
        collapsed	: UserInfo.appOption.collapseLeftSearch,//true,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items		: [{	
			title	: '기본정보', 	
   			itemId	: 'search_panel1',
           	layout	: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	            fieldLabel	: '로그구분',
	            name		: 'LOG_GUBUN',  
	            xtype		: 'uniCombobox',
	            comboType	: 'AU',
	            comboCode	: 'J647',
        		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('LOG_GUBUN', newValue);
					}
				}
        	},{
            	fieldLabel	: '로그상태',
	            name		: 'LOG_STAT',  
	            xtype		: 'uniCombobox',
	            comboType	: 'AU',
	            comboCode	: 'J682',
        		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('LOG_STAT', newValue);
					}
				}
        	},{ 
	            fieldLabel		: '로그일자',
	            xtype			: 'uniDateRangefield',
	            startFieldName	: 'LOG_DATE_FR',
	            endFieldName	: 'LOG_DATE_TO',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('LOG_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('LOG_DATE_TO', newValue);				    		
			    	}
			    }
			},{
		        fieldLabel	: 'KEY',
		        name		: 'KEY',
		        xtype		: 'uniTextfield',
		        listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('KEY', newValue);
					}
				}
		    },{
		        fieldLabel	: '관리번호',
		        name		: 'ELEC_SLIP_NO',
		        xtype		: 'uniTextfield',
		        listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ELEC_SLIP_NO', newValue);
					}
				}
		    }]				
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
	            fieldLabel	: '로그구분',
	            name		: 'LOG_GUBUN',  
	            xtype		: 'uniCombobox',
	            comboType	: 'AU',
	            comboCode	: 'J647',
	        	tdAttrs		: {width: 380}, 
        		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('LOG_GUBUN', newValue);
					}
				}
        	},{
            	fieldLabel	: '로그상태',
	            name		: 'LOG_STAT',  
	            xtype		: 'uniCombobox',
	            comboType	: 'AU',
	            comboCode	: 'J682',
        		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('LOG_STAT', newValue);
					}
				}
        	},{ 
	            fieldLabel		: '로그일자',
	            xtype			: 'uniDateRangefield',
	            startFieldName	: 'LOG_DATE_FR',
	            endFieldName	: 'LOG_DATE_TO',
	        	tdAttrs			: {width: 380},
	        	colspan			: 2,
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('LOG_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('LOG_DATE_TO', newValue);				    		
			    	}
			    }
			},{
		        fieldLabel	: 'KEY',
		        name		: 'KEY',
		        xtype		: 'uniTextfield',
	        	tdAttrs		: {width: 380},
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('KEY', newValue);
					}
				}
		    },{
		        fieldLabel	: '관리번호',
		        name		: 'ELEC_SLIP_NO',
		        xtype		: 'uniTextfield',
		        listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ELEC_SLIP_NO', newValue);
					}
				}
		    }
		]	
    });

    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aep900skrGrid1', {
		store	: directMasterStore,
    	layout	: 'fit',
        region	: 'center',
    	uniOpt	: {					
			useMultipleSorting	: true,		
		    useLiveSearch		: true,		
		    onLoadSelectFirst	: false,			
		    dblClickToEdit		: false,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: true,	
		    filter: {				
				useFilter		: true,
				autoCreate		: true
			}			
		},				
        features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
           			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
        columns: [
        	{dataIndex: 'KEY'					, width: 140},
        	{dataIndex: 'LOG_GUBUN'				, width: 200},
        	{dataIndex: 'CTR_NUM'				, width: 250},
        	{dataIndex: 'TITLE'					, width: 250},
        	{dataIndex: 'LOG_STAT'				, width: 100},
        	{dataIndex: 'REG_DATE'				, width: 120}
		]    
    });                          
    
    
	Unilite.Main({
		id 			: 'aep900skrApp',
	 	border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
		panelSearch  	
		], 
		
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('LOG_GUBUN');
			
			UniAppManager.app.fnInitInputFields();  
		},
		
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			directMasterStore.clearData();

			this.fnInitBinding();		
		},
		
        fnInitInputFields: function(){
        	panelSearch.setValue('LOG_DATE_FR'	, UniDate.get('aMonthAgo'));
            panelSearch.setValue('LOG_DATE_TO'	, UniDate.get('today'));

            panelResult.setValue('LOG_DATE_FR'	, UniDate.get('aMonthAgo'));
            panelResult.setValue('LOG_DATE_TO'	, UniDate.get('today'));
        }
	});
};
</script>
