<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb230skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A025"  /> 		<!-- 예산전용구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A081" /> 		<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B042"  /> 		<!-- 금액단위 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >


function appMain() {     

var getStDt			= Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;			//당기시작월 관련 전역변수
	budgetYY		= getStDt[0].STDT.substring(0,4);
	gsChargeCode	= Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};	//ChargeCode 관련 전역변수
	gsChargeDivi	= fnGetRefCode();										//부서 확인 - 현업부서의 경우 다른부서 조회 불가
	
	gsTodayYear     = UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4);
//	gsChargeDiviCo	= '';

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afb230skrModel', {
	   fields: [
			{name: 'DEPT_CODE'				, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'				, text: '부서'			, type: 'string'},
			{name: 'ACCNT'					, text: '계정과목코드'		, type: 'string'},
			{name: 'ACCNT_NAME'	   			, text: '계정과목'			, type: 'string'},
			{name: 'BUDG_YYYYMM'	   		, text: '예산년월'			, type: 'string'},
			{name: 'DIVERT_DIVI'	   		, text: '구분'			, type: 'string',	comboType: "AU", comboCode: "A025"},
			{name: 'DIVERT_BUDG_I'			, text: '금액'			, type: 'uniPrice'},
			{name: 'DIVERT_YYYYMM'			, text: '전용월'			, type: 'string'},
			{name: 'DIVERT_ACCNT'			, text: '전용계정코드'		, type: 'string'},
			{name: 'DIVERT_ACCNT_NAME'		, text: '전용계정'			, type: 'string'},
			{name: 'DIVERT_DEPT_CODE' 		, text: '전용부서코드'		, type: 'string'},
			{name: 'DIVERT_DEPT_NAME' 		, text: '전용부서'			, type: 'string'},
			{name: 'REMARK'	       			, text: '비고'			, type: 'string'}
	    ]
	});		// End of Ext.define('Afb230skrModel', {
	  
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('afb230MasterStore1',{
		model: 'Afb230skrModel',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb230skrService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			//로그인사용자가 현업부서일 경우 부서를 set하게 됨 -> DEPTS 누락되어 수동 처리
			if(Ext.isEmpty(param.DEPTS) && !Ext.isEmpty(param.DEPT)) {
				param.DEPTS = [panelSearch.getValue('DEPT')];
			}
			this.load({
				params : param
			});
		}/*,
		groupField: 'ITEM_NAME'*/
	});
	
	/* 검색조건 (Search Panel)
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
			title	: '기본정보', 	
	   		itemId	: 'search_panel1',
	        layout	: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items	: [{
	    		fieldLabel	: '예산년도', 
	    		name		: 'BUDGET_YY',
	    		xtype		: 'uniYearField',
	    		value		: gsTodayYear,
	    		allowBlank	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BUDGET_YY', newValue);
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
//				textFieldWidth:89,
				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
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
			}),		    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel		: '계정과목',
		    	valueFieldName	: 'ACCNT_FR',
		    	textFieldName	: 'ACCNT_NM_FR',
		    	autoPopup		: true,
			    extParam		: {'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
			    				/*, 'ADD_QUERY': ""*/},  
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_FR'		, panelSearch.getValue('ACCNT_FR'));
							panelResult.setValue('ACCNT_NM_FR'	, panelSearch.getValue('ACCNT_NM_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_FR'		, '');
						panelResult.setValue('ACCNT_NM_FR'	, '');
					}
				}
		    }),	    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel		: '~',
				valueFieldName	: 'ACCNT_TO',
		    	textFieldName	: 'ACCNT_NM_TO',  	
		    	autoPopup		: true,
			    extParam		: {'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
		    					/*, 'ADD_QUERY': ""*/},  
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_TO'		, panelSearch.getValue('ACCNT_TO'));
							panelResult.setValue('ACCNT_NM_TO'	, panelSearch.getValue('ACCNT_NM_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_TO'		, '');
						panelResult.setValue('ACCNT_NM_TO'	, '');
					}
				}
	    	})
		]},{
			title: '추가정보', 	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [  
				Unilite.popup('DEPT',{
					fieldLabel		: '전용부서',
					valueFieldName	: 'DIVERSION_DEPT_CODE',
					textFieldName	: 'DIVERSION_DEPT_NAME'
				}),
				Unilite.popup('ACCNT',{
					fieldLabel		: '전용과목',
					valueFieldName	: 'DIVERSION_ACCNT',
					textFieldName	: 'DIVERSION_ACCNT_NM',
				    extParam		: {'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
				    				/*, 'ADD_QUERY': ""*/}
			    })
			]
		}]/*,
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}*/
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region		: 'north',
		layout		: {type : 'uniTable', columns : 2/*,
		tableAttrs	: {style: 'border : 1px solid #ced9e7;', width: '100%'},
		tdAttrs		: {style: 'border : 1px solid #ced9e7;', align : 'center'}*/
		},		
		padding		:'1 1 1 1',
		border		:true,
		hidden		: !UserInfo.appOption.collapseLeftSearch,
		items		: [{
    		fieldLabel	: '예산년도', 
    	 	name		: 'BUDGET_YY',
    		xtype		: 'uniYearField',
    		value		: gsTodayYear,           	
	        tdAttrs		: {width: 300},
    		allowBlank	: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BUDGET_YY', newValue);
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
//			textFieldWidth:89,
			textFieldWidth: 159,
			validateBlank:true,
//			width:300,
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
		}),{
			xtype	: 'component',
			width	: 300
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
//			padding	: '0 0 2 0',
			items	:[
				Unilite.popup('ACCNT',{
			    	fieldLabel		: '계정과목',
			    	valueFieldName	: 'ACCNT_FR',
			    	textFieldName	: 'ACCNT_NM_FR',
			    	autoPopup		: true,
				    extParam		: {'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
				    				/*, 'ADD_QUERY': ""*/},  
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ACCNT_FR'		, panelResult.getValue('ACCNT_FR'));
								panelSearch.setValue('ACCNT_NM_FR'	, panelResult.getValue('ACCNT_NM_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ACCNT_FR'		, '');
							panelSearch.setValue('ACCNT_NM_FR'	, '');
						}
					}
			    }),	    
			    	Unilite.popup('ACCNT',{
			    	fieldLabel		: '~',
					valueFieldName	: 'ACCNT_TO',
			    	textFieldName	: 'ACCNT_NM_TO',
				    labelWidth		: 15,  	
			    	autoPopup		: true,
				    extParam		: {'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
			    					/*, 'ADD_QUERY': ""*/},  
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ACCNT_TO'		, panelResult.getValue('ACCNT_TO'));
								panelSearch.setValue('ACCNT_NM_TO'	, panelResult.getValue('ACCNT_NM_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ACCNT_TO'		, '');
							panelSearch.setValue('ACCNT_NM_TO'	, '');
						}
					}
		    	})
		    ]
		}]/*,
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}*/
	});
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('afb230Grid1', {
    	layout	: 'fit',
        region	: 'center',
		store	: masterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	uniOpt : {						
			useMultipleSorting	: true,			
		    useLiveSearch		: true,			
		    onLoadSelectFirst	: false,				
		    dblClickToEdit		: false,			
		    useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: false,			
			useRowContext		: true,		
		    filter: {					
				useFilter		: true,	
				autoCreate		: true	
			}				
		},					
        columns: [        
/*        	{dataIndex: 'DEPT_CODE'				, width: 133	, hidden: true},*/ 				
			{dataIndex: 'DEPT_NAME'				, width: 133}, 				
/*			{dataIndex: 'ACCNT'					, width: 133	, hidden: true},*/ 				
			{dataIndex: 'ACCNT_NAME'	   		, width: 200}, 				
			{dataIndex: 'BUDG_YYYYMM'	   		, width: 100	, align: 'center'}, 				
			{dataIndex: 'DIVERT_DIVI'	   		, width: 100}, 				
			{dataIndex: 'DIVERT_BUDG_I'			, width: 100}, 				
			{dataIndex: 'DIVERT_YYYYMM'			, width: 100	, align: 'center'}, 				
/*			{dataIndex: 'DIVERT_ACCNT'			, width: 133	, hidden: true},*/ 				
			{dataIndex: 'DIVERT_ACCNT_NAME'		, width: 150}, 				
/*			{dataIndex: 'DIVERT_DEPT_CODE' 		, width: 133	, hidden: true},*/ 				
			{dataIndex: 'DIVERT_DEPT_NAME' 		, width: 150}, 				
			{dataIndex: 'REMARK'	       		, flex: 1}
		] 
    });    
    
	 Unilite.Main( {
		borderItems	:[{
			region	:'center',
			layout	: 'border',
			border	: false,
			items	:[
				masterGrid, panelResult
			]
		},
		panelSearch  	
		], 
		id : 'afb230skrApp',
		
		fnInitBinding : function() {
//			panelSearch.setValue('BUDGET_YY', getStDt[0].STDT);
//			panelResult.setValue('BUDGET_YY', getStDt[0].STDT);

			//초기화 시 예산년도로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BUDGET_YY');
			
			//버튼 초기화
			UniAppManager.setToolbarButtons('reset',false);

		},
		
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();				
		}
	});
	
	function fnGetRefCode(REF_CODE2){
				
		var param = {
			ADD_QUERY1	: "ISNULL(REF_CODE2,'') AS REF_CODE2",
			ADD_QUERY2	: '',
			MAIN_CODE	: 'A009',
			SUB_CODE	: gsChargeCode[0].SUB_CODE
		}
		accntCommonService.fnGetRefCodes(param, function(provider, response)	{
			if (provider.REF_CODE2 == '2') {
				panelSearch.setValue('DEPT'		, UserInfo.deptCode)
				panelSearch.setValue('DEPT_NAME', UserInfo.deptName)
				panelSearch.getField('DEPT').setReadOnly(true);
				panelSearch.getField('DEPT_NAME').setReadOnly(true);
				
				panelResult.setValue('DEPT'		, UserInfo.deptCode)
				panelResult.setValue('DEPT_NAME', UserInfo.deptName)
				panelResult.getField('DEPT').setReadOnly(true);
				panelResult.getField('DEPT_NAME').setReadOnly(true);
				
				return provider.REF_CODE2;
			}
//			gsChargeDiviCo = gsAuParam(0);
		});
		
	}
};


</script>

