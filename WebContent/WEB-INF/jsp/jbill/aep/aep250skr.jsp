<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep250skr"  >
<t:ExtComboStore comboType="AU" comboCode="J647"/>	<!-- 전자전표유형코드	-->

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
	Unilite.defineModel('aep250skrModel', {
	    fields: [
			{name: 'COMP_CODE'				, text: 'COMP_CODE'		, type: 'string'},
			{name: 'ELEC_SLIP_TYPE_CD'		, text: '전표유형(숨김)'	, type: 'string'},
			{name: 'EMP_ID'					, text: '사번(숨김)'		, type: 'string'},
			{name: 'TREE_NAME'				, text: '부서명'			, type: 'string'},
			{name: 'NAME'					, text: '사원명'			, type: 'string'},
			{name: 'DETAIL_NM'				, text: '전표유형'			, type: 'string'},
			{name: 'CNT_AMT'				, text: '이용내용 건수'		, type: 'int'},
			{name: 'INV_AMT'				, text: '이용내역 금액'		, type: 'uniPrice'},
			{name: 'CNT_NOT_ING'			, text: '미처리 건수'		, type: 'int'},
			{name: 'CNT_ING'				, text: '처리진행중'		, type: 'int'},
			{name: 'CNT_FIN'				, text: '처리완료 건수'		, type: 'int'}
	    ]          	
	});           
	

	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aep250skrMasterStore1',{
		model	: 'aep250skrModel',
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
                read: 'aep250skrService.selectList'                	
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
			},Unilite.popup('DEPT',{
					fieldLabel		: '작성부서',
				  	valueFieldName	: 'DEPT_CODE',
				    textFieldName	: 'DEPT_NAME',
					validateBlank	: false,
					autoPopup		: true,
					listeners		: {
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
						},
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_NAME', newValue);				
						}
					}
				}),{
	        		fieldLabel	: '전표유형',
	        		name		: 'ELEC_SLIP_TYPE_CD',
	        		xtype		: 'uniCombobox',
	        		comboType	: 'AU',
	        		comboCode	: 'J647',
	        		listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ELEC_SLIP_TYPE_CD', newValue);
						}
					}
	        	},{
					fieldLabel	: '전표전기',
					name		: 'INCLUDE_YN',				
					xtype		: 'checkbox',
					boxLabel	: '전기완료 포함',
//					hideLabel	: true,
					inputValue	: 'Y',		
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('INCLUDE_YN', newValue);
						}
					}
				}	
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
		},
		Unilite.popup('DEPT',{
			fieldLabel		: '작성부서',
		  	valueFieldName	: 'DEPT_CODE',
		    textFieldName	: 'DEPT_NAME',
			validateBlank	: false,
			autoPopup		: true,
			listeners		: {
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
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);				
				}
			}
		}),{
    		fieldLabel	: '전표유형',
    		name		: 'ELEC_SLIP_TYPE_CD',
    		xtype		: 'uniCombobox',
    		comboType	: 'AU',
    		comboCode	: 'J647',
	        tdAttrs		: {width: 380},  
    		listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ELEC_SLIP_TYPE_CD', newValue);
				}
			}
    	},{
			fieldLabel	: '전표전기',
			name		: 'INCLUDE_YN',			
			xtype		: 'checkbox',
			boxLabel	: '전기완료 포함',
			//hideLabel: true,
			inputValue	: 'Y',			
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('INCLUDE_YN', newValue);
				}
			}
		}]	
    });
	
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aep250skrGrid1', {
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
        columns: [
        	{dataIndex: 'TREE_NAME'		, width: 100},
        	{dataIndex: 'NAME'			, width: 100},
        	{dataIndex: 'DETAIL_NM'		, width: 100,
        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            }},
        	{dataIndex: 'CNT_AMT'		, width: 100 , summaryType: 'sum'},
        	{dataIndex: 'INV_AMT'		, width: 100 , summaryType: 'sum'},
        	{dataIndex: 'CNT_NOT_ING'	, width: 100 , summaryType: 'sum'},
        	{dataIndex: 'CNT_ING'		, width: 100 , summaryType: 'sum'},
        	{dataIndex: 'CNT_FIN'		, width: 100 , summaryType: 'sum'}  	
		]    
    });                          
    
	 Unilite.Main( {
		id			: 'aep250skrApp',
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

			panelResult.setValue('AC_DATE_FR'	, UniDate.get('twoMonthsAgo'));
            panelResult.setValue('AC_DATE_TO'	, UniDate.get('twoWeeksLater'));
        }
	});
};


</script>
