<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep230skr"  >

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {   
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aep230skrModel', {
	    fields: [
			{name: 'VENDOR_ID'			, text: '사원 Vendor'		, type: 'string'},
			{name: 'EMP_ID'				, text: '사원명'			, type: 'string'},
			{name: 'ELEC_SLIP_TYPE'		, text: '전표유형명'		, type: 'string'},
			{name: 'ORA_SLIP_NO'		, text: '전표번호'			, type: 'string'},
			{name: 'REMARK'				, text: '적요'			, type: 'string'},
			{name: 'TEST1'				, text: '전기일'			, type: 'uniDate'},
			{name: 'TEST2'				, text: '청구금액'			, type: 'uniPrice'},
			{name: 'TEST3'				, text: '지급금액'			, type: 'uniPrice'},
			{name: 'TEST4'				, text: '만기기준일'		, type: 'uniDate'},
			{name: 'TEST5'				, text: '지급일자'			, type: 'uniDate'}	
	    ] 
	});
	

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aep230skrMasterStore1',{
		model	: 'aep230skrModel',
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
                read: 'aep230skrService.selectList'                	
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
			    Unilite.popup('Employee',{
					fieldLabel		: '사원정보',
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
		    		fieldLabel	: '지급일자',
				    xtype		: 'uniDateRangefield',
				    startFieldName: 'PAY_DATE_FR',
				    endFieldName: 'PAY_DATE_TO',
		            onStartDateChange: function(field, newValue, oldValue, eOpts) {
		            	if(panelSearch) {
							panelResult.setValue('PAY_DATE_FR', newValue);
						}
		            },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelSearch) {
				    		panelResult.setValue('PAY_DATE_TO', newValue);				    		
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
		items	: [
			Unilite.popup('Employee',{
				fieldLabel		: '사원정보',
			  	valueFieldName	: 'PERSON_NUMB',
			    textFieldName	: 'NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners		: {
					onSelected: {
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
			}),{
	            fieldLabel	: '전표유형',
	            name		: 'ELEC_SLIP_TYPE_CD',  
	            xtype		: 'uniCombobox',
	            comboType	: 'AU',
	            comboCode	: 'J647',
        		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ELEC_SLIP_TYPE_CD', newValue);
					}
				}
        	},{
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
	    		fieldLabel	: '지급일자',
			    xtype		: 'uniDateRangefield',
			    startFieldName: 'PAY_DATE_FR',
			    endFieldName: 'PAY_DATE_TO',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelSearch.setValue('PAY_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('PAY_DATE_TO', newValue);				    		
			    	}
			    }
			}
		]	
    });


    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aep230skrGrid1', {
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
        	{dataIndex: 'VENDOR_ID'			, width: 100},
        	{dataIndex: 'EMP_ID'			, width: 100},
        	{dataIndex: 'ELEC_SLIP_TYPE'	, width: 120},
        	{dataIndex: 'ORA_SLIP_NO'		, width: 100},
        	{dataIndex: 'REMARK'			, width: 250},
        	{dataIndex: 'TEST1'				, width: 100,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '부서계', '합계');
            	}
            },
        	{dataIndex: 'TEST2'				, width: 100		, summaryType: 'sum'},
        	{dataIndex: 'TEST3'				, width: 100		, summaryType: 'sum'},
        	{dataIndex: 'TEST4'				, width: 100},
        	{dataIndex: 'TEST5'				, width: 100}
		]    
    });                          
    
    
	Unilite.Main({
		id			: 'aep230skrApp',
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
			
			/*panelSearch.setValue('PERSON_NUMB','${chargeCode}');
			panelSearch.setValue('NAME','${chargeName}');
			
			panelResult.setValue('PERSON_NUMB','${chargeCode}');
			panelResult.setValue('NAME','${chargeName}');
			*/
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PERSON_NUMB');
			
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
			panelSearch.setValue('PERSON_NUMB'	, UserInfo.personNumb);
			panelSearch.setValue('NAME'			, UserInfo.userName);
            panelSearch.setValue('PAY_DATE_FR'	, UniDate.get('aMonthAgo'));
            panelSearch.setValue('PAY_DATE_TO'	, UniDate.get('today'));

			panelResult.getField('CONF_YN').setValue('');
			panelResult.setValue('PERSON_NUMB'	, UserInfo.personNumb);
			panelResult.setValue('NAME'			, UserInfo.userName);
			panelResult.setValue('PAY_DATE_FR'	, UniDate.get('aMonthAgo'));
            panelResult.setValue('PAY_DATE_TO'	, UniDate.get('today'));
        }
	});
};


</script>
