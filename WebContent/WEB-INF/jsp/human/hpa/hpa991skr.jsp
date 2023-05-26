<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa991skr"  >
		<t:ExtComboStore comboType="AU" comboCode="H011" /> 							<!-- 고용구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H024" />								<!-- 사원구분 -->
		<t:ExtComboStore comboType="BOR120"  />											<!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa991skrModel', {		
	    fields: [{name: 'COMP_CODE'   				,text: 'COMP_CODE' 			,type: 'string'},	    		
				 {name: 'AMOUNT_I_NAME'   	 		,text: '소분류'				,type: 'string'},
				 {name: 'TYPE_CODE'	 				,text: '코드' 				,type: 'string'},	    		
				 {name: 'SUPP_DATE'	 				,text: '지급일' 				,type: 'string'},	    		
				 {name: 'SUPP_TYPE'   				,text: '지급구분'				,type: 'string'},	    		
				 {name: 'PERSON_NUMB'  				,text: '사번' 				,type: 'string'},	    		
				 {name: 'NAME'	 					,text: '성명' 				,type: 'string'},	    		
				 {name: 'PAY_YYYYMM'	 			,text: '지급년월' 				,type: 'string'},	    		
				 {name: 'SUPP_TOT_AMT'   			,text: '소득지급'				,type: 'uniPrice'},	    		
				 {name: 'PAY_TAX_AMT'  				,text: '소득세' 				,type: 'uniPrice'},	    		
				 {name: 'LOC_TAX_AMT'	 			,text: '주민세' 				,type: 'uniPrice'},	    		
				 {name: 'SP_TAX_I'   				,text: '농특세'				,type: 'uniPrice'},	    		
				 {name: 'LIMIT_PAY_SUPP_I'  		,text: '비과세' 				,type: 'uniPrice'},	    		
				 {name: 'SUPP_LIMIT_TOTAL_AMT'	 	,text: '급여총지급'		 		,type: 'uniPrice'}	    		
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hpa991skrMasterStore',{
		model: 'Hpa991skrModel',
		uniOpt: {
           	isMaster	: true,				// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi		: false				// prev | newxt 버튼 사용
	            	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'hpa991skrService.selectList'                	
            }
        },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			
			var flag = Ext.getCmp('searchForm').getForm().findField('YEAR_TAX_FLAG').value;     //연말정산포함여부 (Y-포함, 1-미포함)
                                                                
            if (flag == true) {
                param.YEAR_TAX_FLAG = 'Y';         
            } else {
                param.YEAR_TAX_FLAG = '1';      
            }     
            
			console.log( param );
			this.load({
				params : param
			});
		}
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
			title: '기본정보',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	        items: [{ 
    			fieldLabel: '신고년월',
    			name:'PAY_YYYYMM',
				xtype: 'uniMonthfield',
				value: UniDate.get('today'),
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_YYYYMM', newValue);			
					}
				}
			},{
		        fieldLabel: '신고사업장',
			    name:'DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: false, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				allowBlank:false,
			    listeners: {
			      change: function(field, newValue, oldValue, eOpts) {      
			       panelResult.setValue('DIV_CODE', newValue);
			      }
	     		}
			},{
                fieldLabel  : '연말정산포함',
                name        : 'YEAR_TAX_FLAG',
                value       : 'Y',
                xtype       : 'checkbox'
              }]
        }]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 5
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '신고년월',
			name:'PAY_YYYYMM',
			xtype: 'uniMonthfield',
			value: UniDate.get('today'),
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_YYYYMM', newValue);
				}
			}
		},{
			xtype: 'component',
			width : 100
		},{
	        fieldLabel: '신고사업장',
		    name:'DIV_CODE', 
		    xtype: 'uniCombobox',
			multiSelect: false, 
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
			allowBlank:false,
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
					panelSearch.setValue('DIV_CODE', newValue);
		      }
     		}
		},{
            xtype: 'component',
            width : 100
        },{
            fieldLabel: '연말정산포함여부',
            name: 'YEAR_TAX_FLAG',
            value: 'Y',
            xtype: 'checkbox',
            labelWidth: 100,
            tdAttrs: {align : 'center'},
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('YEAR_TAX_FLAG', newValue);
              }
            }
        }]
	});

	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hpa991skrGrid1', {
    	region		: 'center',
    	store: masterStore,
        selModel	: 'rowmodel',
        uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
    		filter: {
				useFilter		: false,
				autoCreate		: false
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
        }],
        columns:  [ 
					{ dataIndex:'COMP_CODE'   				, width: 100	, hidden: true},
					{ dataIndex:'AMOUNT_I_NAME'   	 		, width: 100	, locked: true},
					{ dataIndex:'TYPE_CODE'	 				, width: 100	, locked: true},
					{ dataIndex:'SUPP_DATE'	 				, width: 100	, locked: true},
					{ dataIndex:'SUPP_TYPE'   				, width: 100	, locked: true},
					{ dataIndex:'PERSON_NUMB'  				, width: 100	, locked: true},
					{ dataIndex:'NAME'	 					, width: 100},
					{ dataIndex:'PAY_YYYYMM'	 			, width: 100},
					{ dataIndex:'SUPP_TOT_AMT'   			, width: 100},
					{ dataIndex:'PAY_TAX_AMT'  				, width: 100},
					{ dataIndex:'LOC_TAX_AMT'	 			, width: 100},
					{ dataIndex:'SP_TAX_I'   				, width: 100},
					{ dataIndex:'LIMIT_PAY_SUPP_I'  		, width: 100},
					{ dataIndex:'SUPP_LIMIT_TOTAL_AMT'	 	, width: 100}
        ],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
        	
	          	if(record.get('GUBUN') == '4'){
					cls = 'x-change-cell_dark';
				} 
				return cls;
	        }
	    }
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
		}		
		,panelSearch
		], 
		id : 'hpa991skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('PAY_YYYYMM', UniDate.get('today'));
			panelResult.setValue('PAY_YYYYMM', UniDate.get('today'));
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);

			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{			
			masterGrid.reset();
			masterStore.clearData();
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save',false);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},
		onPrintButtonDown : function() {
			//do something!!
		}
	});
};
</script>
