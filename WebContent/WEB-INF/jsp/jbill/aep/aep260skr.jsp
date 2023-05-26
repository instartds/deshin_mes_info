<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep260skr"  >

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
	Unilite.defineModel('aep260skrModel', {
	    fields: [
			{name: 'TEST1'		, text: '출력'		, type: 'string'},
			{name: 'TEST2'		, text: '증빙'		, type: 'string'},
			{name: 'TEST3'		, text: '전표번호'		, type: 'string'},
			{name: 'TEST4'		, text: '결재라인'		, type: 'string'},
			{name: 'TEST5'		, text: '진행상태'		, type: 'string'},
			{name: 'TEST6'		, text: '전표유형'		, type: 'string'},
			{name: 'TEST99'		, text: '증빙일자'		, type: 'string'},
			{name: 'TEST7'		, text: '회계일자'		, type: 'string'},
			{name: 'TEST8'		, text: '총금액'		, type: 'string'},
			{name: 'TEST9'		, text: '거래처'		, type: 'string'},
			{name: 'TEST10'		, text: '사용내역'		, type: 'string'},
			{name: 'TEST11'		, text: '작성부서'		, type: 'string'},
			{name: 'TEST12'		, text: '작성자'		, type: 'string'},
			{name: 'TEST13'		, text: '작성일자'		, type: 'string'},
			{name: 'TEST14'		, text: '관리번호'		, type: 'string'},
			{name: 'TEST15'		, text: '원천세유형'	, type: 'string'},
			{name: 'TEST16'		, text: '결제번호'		, type: 'string'}
			
	    ] 
	});
	

	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aep260skrMasterStore1',{
		model	: 'aep260skrModel',
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
                read: 'aep260skrService.selectList'                	
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
	    		fieldLabel		: '회계일자',
			    xtype			: 'uniDateRangefield',
			    startFieldName	: 'AC_DATE_FR',
			    endFieldName	: 'AC_DATE_TO',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('AC_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('AC_DATE_TO', newValue);				    		
			    	}
			    }
			},{
		        fieldLabel	: '전표번호',
		        name		: 'SLIP_NUM',
		        xtype		: 'uniTextfield',
		        listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SLIP_NUM', newValue);
					}
				}
		    },
		    Unilite.popup('Employee',{
				fieldLabel		: '담당자',
			  	valueFieldName	: 'PERSON_NUMB',
			    textFieldName	: 'NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners		: {
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
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			})
		    ]				
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
    		fieldLabel		: '회계일자',
		    xtype			: 'uniDateRangefield',
		    startFieldName	: 'AC_DATE_FR',
		    endFieldName	: 'AC_DATE_TO',
	        tdAttrs			: {width: 380},  
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('AC_DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('AC_DATE_TO', newValue);				    		
		    	}
		    }
		},{
	        fieldLabel	: '전표번호',
	        name		: 'SLIP_NUM',
	        xtype		: 'uniTextfield',
	        listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SLIP_NUM', newValue);
				}
			}
	    },
    	Unilite.popup('Employee',{
			fieldLabel		: '담당자',
		  	valueFieldName	: 'PERSON_NUMB',
		    textFieldName	: 'NAME',
			validateBlank	: false,
			autoPopup		: true,
			listeners		: {
				onSelected	: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		})]	
    });
	
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aep260skrGrid1', {
		store	: directMasterStore,
    	layout	: 'fit',
        region	: 'center',
    	uniOpt	: {					
			useMultipleSorting	: true,		
		    useLiveSearch		: true,		
		    onLoadSelectFirst	: false,			
		    dblClickToEdit		: false,		
		    useGroupSummary		: true,		
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
           			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
			}
        }),
        tbar: [{
			itemId	: 'silpBtn',
			text	: '전표일괄인쇄',
        	handler	: function() {
	        }
		},{
			itemId	: 'buyBtn',
			text	: '품위서일괄인쇄',
        	handler	: function() {
	        }
		}],
        columns: [{
			    xtype	: 'rownumberer',        
			    align	: 'center  !important',                                                            
			    width	: 35, 
			    sortable: false,         
			    resizable: true                                                                        
			},                                                                                         
        	{dataIndex: 'TEST1'		, width: 100},                                                     
        	{dataIndex: 'TEST2'		, width: 100},                                                     
        	{dataIndex: 'TEST3'		, width: 100},                                                     
        	{dataIndex: 'TEST4'		, width: 300},                                                     
        	{dataIndex: 'TEST5'		, width: 100},                                                     
        	{dataIndex: 'TEST6'		, width: 100,                                                      
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {                       
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');                
            }},                                                                                        
        	{dataIndex: 'TEST99'		, width: 100	, summaryType: 'sum'},                                             
        	{dataIndex: 'TEST7'			, width: 100},                                             
        	{dataIndex: 'TEST8'			, width: 100},                                             
        	{dataIndex: 'TEST9'			, width: 100},                        
        	{dataIndex: 'TEST10'  		, width: 100},                                                 
        	{dataIndex: 'TEST11'  		, width: 100},
        	{dataIndex: 'TEST12'  		, width: 100},
        	{dataIndex: 'TEST13'  		, width: 100},
        	{dataIndex: 'TEST14'  		, width: 100},
        	{dataIndex: 'TEST15'  		, width: 100},
        	{dataIndex: 'TEST16'  		, width: 100}      	
		]    
    });                          
    
	 Unilite.Main( {
		id			: 'aep260skrApp',
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
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE_FR');

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
            panelSearch.setValue('AC_DATE_FR'	, UniDate.get('twoMonthsAgo'));
            panelSearch.setValue('AC_DATE_TO'	, UniDate.get('twoWeeksLater'));
			panelSearch.setValue('PERSON_NUMB'	, UserInfo.personNumb);
			panelSearch.setValue('NAME'			, UserInfo.userName);

			panelResult.setValue('AC_DATE_FR'	, UniDate.get('twoMonthsAgo'));
            panelResult.setValue('AC_DATE_TO'	, UniDate.get('twoWeeksLater'));
			panelResult.setValue('PERSON_NUMB'	, UserInfo.personNumb);
			panelResult.setValue('NAME'			, UserInfo.userName);
        }
	});
};


</script>
