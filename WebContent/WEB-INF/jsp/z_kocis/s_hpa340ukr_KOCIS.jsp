<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_hpa340ukr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" opts= '${gsList1}' />			<!-- 지급구분 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var gsList1 = '${gsList1}';					//지급구분 '1'인 것만 콤보에서 보이도록 설정
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createForm('searchForm', {		
		disabled :false,
    	flex:1,
    	layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		items: [{
    		fieldLabel		: '급여년월', 
    		xtype			: 'uniMonthfield',
    		value			: UniDate.get('today'),
    		name 			: 'PAY_YYYYMM',
        	id 				: 'PAY_YYYYMM',
    		allowBlank		: false
    	},{
			fieldLabel		: '지급일',
			id				: 'SUPP_DATE',
			xtype			: 'uniDatefield',
			name			: 'SUPP_DATE',                  
			allowBlank		: false
		},{
			fieldLabel		: '지급구분',
			id				: 'SUPP_TYPE',
			name			: 'SUPP_TYPE', 
			xtype 			: 'uniCombobox',
			comboType 		: 'AU',
			comboCode 		: 'H032',
			allowBlank 		: false,
			value 			: '1'
		},{
			fieldLabel		: '기관',
			name			: 'DIV_CODE', 
			xtype			: 'uniCombobox',
			comboType		: 'BOR120'
		}/*,
			Unilite.treePopup('DEPTTREE',{
			fieldLabel		: '부서',
			valueFieldName	: 'DEPT',
			textFieldName	: 'DEPT_NAME' ,
			valuesName		: 'DEPTS' ,
			DBvalueFieldName: 'TREE_CODE',
			DBtextFieldName	: 'TREE_NAME',
			selectChildren	: true,
//			textFieldWidth:89,
//			textFieldWidth: 159,
		    autoPopup		: true,
			validateBlank	: false,
			useLike			: true
		})*/,{
			fieldLabel		: '급여지급방식',
			name			: 'PAY_CODE', 
			xtype			: 'uniCombobox',
			comboType		: 'AU',
			comboCode		: 'H028'
		},{
			fieldLabel		: '지급차수',
			name			: 'PROV_PAY_FLAG', 
			xtype			: 'uniCombobox',
			comboType		: 'AU',
			comboCode		: 'H031'
		},
	      	Unilite.popup('Employee',{
	      	fieldLabel 		: '직원',
		    valueFieldName	: 'PERSON_NUMB',
		    textFieldName	: 'NAME',
		    autoPopup		: true,
			validateBlank	: false,
			listeners:{
				onTextSpecialKey: function(elm, e){
                    if (e.getKey() == e.ENTER) {
                    	panelSearch.getField('PERSON_NUMB').focus();  
                	}
                }
			}
//		    valueFieldWidth: 79,
  		}),{
	    	xtype: 'container',
//	    	padding: '10 0 0 0',
	    	layout: {
	    		type	: 'vbox',
				align	: 'center',
				pack	: 'center'
	    	},
	    	items:[{
	    		xtype	: 'button',
	    		text	: '실행',
	    		width	: 100,
	    		handler	: function(){
                    if(!panelSearch.getInvalidMessage()){
		                return false;
		            }
                    
        			var param= Ext.getCmp('searchForm').getValues();
        			param.BASEDATA_YN	= 'Y';
        			param.CALC_HIR 		= 'N'
					panelSearch.getEl().mask('급여계산 중...','loading-indicator');
					s_hpa340ukrService_KOCIS.spCalcPay(param, function(provider, response)	{
	        			console.log("response", response);
	        			console.log("provider", provider);
	        			if(!Ext.isEmpty(provider))	{
        					alert(Msg.sMH892)										//급여작업이 완료되었습니다.
	        			}
	        			panelSearch.getEl().unmask();						
					});
	    		}
	    	}]
	    }]
	});
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    /*var masterGrid1 = Unilite.createGrid('hpa340ukrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: directMasterStore1,
    	uniOpt:{	useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex:	'WORK_TYPE' 		, width: 100},
        		   { dataIndex:	'WORK_START_TIME'	, width: 170},
        		   { dataIndex:	'WORK_END_TIME'		, width: 170},
        		   { dataIndex:	'WORK_TOTAL_TIME'	, width: 170},
        		   { dataIndex:	'WORK_CONTENT'		, width: 250},
        		   { dataIndex:	'WORK_REMARK'		, width: 250}        		   
        ] 
    });  */ 
	
    Unilite.Main( {
		id				: 'hpa340ukrApp',
		items			: [ panelSearch ],

		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);

			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('reset',false);
			
            if(UserInfo.divCode == "01") {
                panelSearch.getField('DIV_CODE').setReadOnly(false);
            }
            else {
                panelSearch.getField('DIV_CODE').setReadOnly(true);
            }
            
			//초기화 시 전표일로 포커스 이동
			panelSearch.onLoadSelectText('PAY_YYYYMM');
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		
        //링크로 넘어오는 params 받는 부분 
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 's_hpa330ukr_KOCIS') {
				panelSearch.setValue('PAY_YYYYMM',	params.PAY_YYYYMM);
				panelSearch.setValue('NAME',		params.NAME);
				panelSearch.setValue('PERSON_NUMB',	params.PERSON_NUMB);
				panelSearch.setValue('SUPP_TYPE',	params.SUPP_TYPE);
				
			} else if(params.PGM_ID == 'agc110skr') {
			
			
			} else if(params.PGM_ID == 'agb150skr'){
			
			}	
		}
	});

};


</script>
