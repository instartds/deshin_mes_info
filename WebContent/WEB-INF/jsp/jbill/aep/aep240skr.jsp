<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep240skr"  >

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
	Unilite.defineModel('aep240skrModel', {
	    fields: [
			{name: 'TEST1'				, text: '거래처'		, type: 'string'},
			{name: 'TEST2'				, text: '거래처명'		, type: 'string'},
			{name: 'ELEC_SLIP_TYPE'		, text: '전표유형명'	, type: 'string'},
			{name: 'ORA_SLIP_NO'		, text: '전표번호'		, type: 'string'},
			{name: 'REMARK'				, text: '적요'		, type: 'string'},
			{name: 'TEST6'				, text: '전기일'		, type: 'uniDate'},
			{name: 'TEST7'				, text: '청구금액'		, type: 'uniPrice'},
			{name: 'TEST8'				, text: '지급금액'		, type: 'uniPrice'},
			{name: 'TEST9'				, text: '만기기준일'	, type: 'uniDate'},
			{name: 'TEST10'				, text: '지급일자'		, type: 'uniDate'}
			
	    ] 
	});
	

	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aep240skrMasterStore1',{
		model	: 'aep240skrModel',
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
                read: 'aep240skrService.selectList'                	
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
		    items: [
		    	Unilite.popup('CUST',{
//				extParam : {'CUSTOM_TYPE': ['1','2','3']},
				fieldLabel		: '거래처', 
				valueFieldName	: 'CUSTOM_CODE',
			    textFieldName	: 'CUSTOM_NAME',
			    listeners		: {
			    	onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);				
					}
				}
			}),
				Unilite.popup('DEPT',{
					fieldLabel		: '발생부서',
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
					xtype	: 'container',
					layout	: {type : 'uniTable', columns : 2},
					width	: 450,
					items :[{
						xtype		: 'radiogroup',		            		
						fieldLabel	: '조회구분',
						items		: [{
							boxLabel: '전체', 
							name	: 'CONF_YN',
							width	: 60,
							inputValue: '',
							checked: true  
						},{
							boxLabel: '미지급(미결)', 
							name	: 'CONF_YN',
							width	: 100,
							inputValue: '1' 
						},{
							boxLabel: '지급완료',
							name	: 'CONF_YN', 
							width	: 100,
							inputValue: '2'
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.getField('CONF_YN').setValue(newValue.CONF_YN);					
							}
						}
					}
				]},{ 
		    		fieldLabel	: '등록일자',
				    xtype		: 'uniDateRangefield',
				    startFieldName: 'REG_DATE_FR',
				    endFieldName: 'REG_DATE_TO',
		            onStartDateChange: function(field, newValue, oldValue, eOpts) {
		            	if(panelSearch) {
							panelResult.setValue('REG_DATE_FR', newValue);
						}
		            },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelSearch) {
				    		panelResult.setValue('REG_DATE_TO', newValue);				    		
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
		items	: [
			Unilite.popup('CUST',{
//				extParam : {'CUSTOM_TYPE': ['1','2','3']},
				fieldLabel		: '거래처', 
				valueFieldName	: 'CUSTOM_CODE',
			    textFieldName	: 'CUSTOM_NAME',
			    listeners		: {
			    	onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);				
					}
				}
			}),
				Unilite.popup('DEPT',{
					fieldLabel		: '발생부서',
				  	valueFieldName	: 'DEPT_CODE',
				    textFieldName	: 'DEPT_NAME',
					validateBlank	: false,
					autoPopup		: true,
					listeners: {
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
					xtype	: 'container',
					layout	: {type : 'uniTable', columns : 2},
					width	: 450,
					items	: [{
						xtype		: 'radiogroup',		            		
						fieldLabel	: '조회구분',
						items		: [{
							boxLabel: '전체', 
							name	: 'CONF_YN',
							width	: 60,
							inputValue: '',
							checked	: true  
						},{
							boxLabel: '미지급(미결)', 
							name	: 'CONF_YN',
							width	: 100,
							inputValue: '1' 
						},{
							boxLabel: '지급완료', 
							name	: 'CONF_YN',
							width	: 100,
							inputValue: '2'
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.getField('CONF_YN').setValue(newValue.CONF_YN);					
							}
						}
					}
				]},{ 
		    		fieldLabel	: '등록일자',
				    xtype		: 'uniDateRangefield',
				    startFieldName: 'REG_DATE_FR',
				    endFieldName: 'REG_DATE_TO',
		            onStartDateChange: function(field, newValue, oldValue, eOpts) {
		            	if(panelResult) {
							panelSearch.setValue('REG_DATE_FR', newValue);
						}
		            },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelSearch.setValue('REG_DATE_TO', newValue);				    		
				    	}
				    }
			}
		]	
    });
	
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aep240skrGrid1', {
		store	: directMasterStore,
    	layout	: 'fit',
        region	: 'center',
        store	: directMasterStore, 
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
        	{dataIndex: 'TEST1'			, width: 100},
        	{dataIndex: 'TEST2'			, width: 100},
        	{dataIndex: 'ELEC_SLIP_TYPE'			, width: 100},
        	{dataIndex: 'ORA_SLIP_NO'	, width: 100},
        	{dataIndex: 'REMARK'		, width: 250},
        	{dataIndex: 'TEST6'			, width: 100,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '부서계', '합계');
            	}
            },
        	{dataIndex: 'TEST7'			, width: 100		, summaryType: 'sum'},
        	{dataIndex: 'TEST8'			, width: 100		, summaryType: 'sum'},
        	{dataIndex: 'TEST9'			, width: 100},
        	{dataIndex: 'TEST10'		, width: 100}      	
		]    
    });                          
    
	 Unilite.Main( {
		id			: 'aep240skrApp',
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
			activeSForm.onLoadSelectText('CUSTOM_CODE');
			
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
			panelSearch.getField('CONF_YN').setValue('');					
			panelSearch.setValue('DEPT_CODE'	, UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME'	, UserInfo.deptName);
            panelSearch.setValue('REG_DATE_FR'	, UniDate.get('startOfMonth'));
            panelSearch.setValue('REG_DATE_TO'	, UniDate.get('today'));

			panelResult.getField('CONF_YN').setValue('');
			panelResult.setValue('DEPT_CODE'	, UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME'	, UserInfo.deptName);
			panelResult.setValue('REG_DATE_FR'	, UniDate.get('startOfMonth'));
            panelResult.setValue('REG_DATE_TO'	, UniDate.get('today'));
        }
	});
};


</script>
