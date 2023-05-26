<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aisc106skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="aisc106skrv" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A035" /> 		<!-- 완료여부-->
	<t:ExtComboStore comboType="AU" comboCode="A004" /> 		<!-- 상각여부-->
	<t:ExtComboStore comboType="AU" comboCode="B031" /> 		<!-- 수불생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="CBM600" /> 		<!-- Cost Pool-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {

var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aisc106skrvModel', {
	    fields: [
	    	{name: 'GUBUN' 					,text: 'GUBUN' 				,type: 'string'},
	    	{name: 'ACCNT_DIVI' 			,text: 'ACCNT_DIVI' 		,type: 'string'},
	    	{name: 'ACCNT' 					,text: '계정코드' 				,type: 'string'},
	    	{name: 'ACCNT_NAME' 			,text: '계정과목' 				,type: 'string'},
	    	{name: 'ASST' 					,text: '자산코드' 				,type: 'string'},
	    	{name: 'ASST_NAME' 				,text: '자산명' 				,type: 'string'},
	    	{name: 'DEP_CTL' 				,text: '상각방법' 				,type: 'string'},
	    	{name: 'DRB_YEAR' 				,text: '내용년수' 				,type: 'string'},
	    	{name: 'DPR_STS2' 				,text: '상각여부' 				,type: 'string'},
	    	{name: 'ACQ_AMT_I' 				,text: '실취득가액' 			,type: 'uniPrice'},
	    	
	    	
	    	
            {name: 'ACQ_Q'                  ,text: '취득수량'              ,type: 'int'},
            {name: 'ACQ_DATE'               ,text: '취득일'               ,type: 'uniDate'},
            
            
            /* 상각대상금액 ↓
             * BA_BALN_I
             * CT_INCREASE_I
             * CT_REDUCE_I 
             * PT_DPR_TOT_I 
             * PT_DMGLOS_TOT_I
             * CT_BALN_I       
             */
            {name: 'BA_BALN_I'              ,text: '취득가액(a)'           ,type: 'uniPrice'},
	    	{name: 'CT_INCREASE_I' 			,text: '당기증가액(b)' 			,type: 'uniPrice'},
	    	{name: 'CT_REDUCE_I' 			,text: '당기감소액(c)' 			,type: 'uniPrice'},
	    	{name: 'ASST_VARI_AMT_I'        ,text: '재평가후자산증감'        ,type: 'uniPrice'},
	    	
//	    	{name: 'CT_DISPOSAL_I' 			,text: '당기자산처분액' 			,type: 'uniPrice'},
//	        {name: 'ASST_VARI_AMT_I' 		,text: '재평가후자산증감' 		,type: 'uniPrice'},
//	    	{name: 'CT_BALN_I' 				,text: '기말잔액' 				,type: 'uniPrice'},
	    	{name: 'PT_DPR_TOT_I' 			,text: '충당금누계액(d)' 		 ,type: 'uniPrice'},
	    	{name: 'PT_DMGLOS_TOT_I'        ,text: '손상차손누계액(e)'        ,type: 'uniPrice'},
	    	{name: 'CT_BALN_I'              ,text: '미상각액(f=a+b-c-d-e)'  ,type: 'uniPrice'}, //취득가액 + 당기증가액 - 당기감소액 - 충당금누계액 
	    	
	    	
	    	/* 상각액 ↓
	    	 * CT_DPR_I
	    	 * CT_DPR_TOT_I
	    	 * CT_DMGLOS_TOT_I
	    	 * FL_BALN_I
	    	 */
	    	{name: 'CT_DPR_I' 				,text: '당기상각액(g)' 			,type: 'uniPrice'},
//	    	{name: 'CT_DPR_REDUCE_I' 		,text: '당기상각감소액' 			,type: 'uniPrice'},
	    	{name: 'CT_DPR_TOT_I' 			,text: '당기말충당금(h=d+g)' 		,type: 'uniPrice'},
	        {name: 'CT_DMGLOS_TOT_I' 		,text: '당기말손상차손누계액(i)' 	,type: 'uniPrice'}, 
	    	{name: 'FL_BALN_I' 				,text: '차기이월액(j=a+b-c-h-i)' 	,type: 'uniPrice'},
	    	
	    	
	    	
	    	{name: 'WASTE_YYYYMM' 			,text: 'WASTE_YYYYMM' 		,type: 'string'},
	    	{name: 'COST_POOL_NAME' 		,text: 'Cost Pool' 			,type: 'string'},
	    	{name: 'COST_DIRECT' 			,text: 'Cost Pool 직과' 		,type: 'string'},
	    	{name: 'ITEMLEVEL1_NAME' 		,text: '대분류' 				,type: 'string'},
	    	{name: 'ITEMLEVEL2_NAME' 		,text: '중분류' 				,type: 'string'},
	    	{name: 'ITEMLEVEL3_NAME' 		,text: '소분류' 				,type: 'string'}/*,				// 쿼리 '' AS REMARK 된 컬럼은 삭제하고 expandLastColumn: true로 대체
	    	{name: 'REMARK' 				,text: '비고' 			,type: 'string'}*/
			]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('aisc106skrvmasterStore',{
		model: 'aisc106skrvModel',
		uniOpt : {
        	isMaster:	true,			// 상위 버튼 연결 
        	editable:	false,			// 수정 모드 사용 
        	deletable:	false,			// 삭제 가능 여부 
            useNavi:	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'aisc106skrvService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
          	load: function(store, records, successful, eOpts) {
				var viewNormal = masterGrid.normalGrid.getView();
				var viewLocked = masterGrid.lockedGrid.getView();  
            
				//조회된 데이터가 있을 때, 합계 보이게 설정 / 그리드에 포커스 가도록 변경
				if(store.getCount() > 0){
		   	 		viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		   	 		viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    		viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

		    		masterGrid.focus();
				//조회된 데이터가 없을 때, 합계 안 보이게 설정 / 패널의 첫번째 필드에 포커스 가도록 변경
	    		}else{
					viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
		    		viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);	
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
					
					var activeSForm ;		
					if(!UserInfo.appOption.collapseLeftSearch)	{	
						activeSForm = panelSearch;	
					}else {		
						activeSForm = panelResult;	
					}		
					activeSForm.onLoadSelectText('DVRY_DATE_FR');	
				}
          	}          		
      	},
		groupField: 'ACCNT'
	});

	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
		    items : [{ 
    			fieldLabel: '상각년월',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'DVRY_DATE_FR',
		        endFieldName: 'DVRY_DATE_TO',
//		        width: 470,
		        allowBlank:false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
							panelResult.setValue('DVRY_DATE_FR',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DVRY_DATE_TO',newValue);
			    	}
			    }
	        },{
		        fieldLabel: '사업장',
			    name:'ACCNT_DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
//			    width: 325,
			    colspan:2,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
		    },		    
	    	Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
		    	valueFieldName: 'ACCNT',
		    	textFieldName: 'ACCNT_NAME', 
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT', panelSearch.getValue('ACCNT'));
							panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT', '');
						panelResult.setValue('ACCNT_NAME', '');
					},
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                  'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE,
                                  'ADD_QUERY': "SPEC_DIVI = 'K'"
                                }
                                popup.setExtParam(param);
                            }
                        }
                    
				}
		    }),{
				fieldLabel: '상각완료여부',
				xtype: 'uniCombobox',
				name: 'DPR_STS',
				comboType: 'AU',
				comboCode: 'A035',
//				width: 325,
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DPR_STS', newValue);
					}
				}
			},		    
	    	Unilite.popup('IFRS_ASSET',{
		    	fieldLabel: '자산코드',
		    	valueFieldName: 'ASSET_CODE_FR',
		    	textFieldName: 'ASSET_NAME_FR', 
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE_FR', panelSearch.getValue('ASSET_CODE_FR'));
							panelResult.setValue('ASSET_NAME_FR', panelSearch.getValue('ASSET_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE_FR', '');
						panelResult.setValue('ASSET_NAME_FR', '');
					}
				}
		    }),		    
	    	Unilite.popup('IFRS_ASSET',{
		    	fieldLabel: '~',
		    	valueFieldName: 'ASSET_CODE_TO',
		    	textFieldName: 'ASSET_NAME_TO', 
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE_TO', panelSearch.getValue('ASSET_CODE_TO'));
							panelResult.setValue('ASSET_NAME_TO', panelSearch.getValue('ASSET_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE_TO', '');
						panelResult.setValue('ASSET_NAME_TO', '');
					}
				}
		    })]		
	},{
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [
		    	Unilite.popup('AC_PROJECT',{ 
			    fieldLabel: '사업코드', 
				valueFieldName: 'PJT_CODE_FR', 
				textFieldName: 'PJT_NAME_FR', 
			    validateBlank: false 
//			    popupWidth: 710
			}),   	
				Unilite.popup('AC_PROJECT',{ 
				fieldLabel: '~',
				valueFieldName: 'PJT_CODE_TO', 
				textFieldName: 'PJT_NAME_FR', 
				validateBlank: false 
//				popupWidth: 710
			}),		    
	        	Unilite.popup('DEPT',{
		        fieldLabel: '부서',
		        validateBlank:false,
			    valueFieldName:'DEPT_CODE_FR',
			    textFieldName:'DEPT_NAME_FR'
		    }),		    
	        	Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        validateBlank:false,
		        extParam:{'CUSTOM_TYPE':'3'},
			    valueFieldName:'DEPT_CODE_TO',
			    textFieldName:'DEPT_NAME_TO'
		    }),{
				fieldLabel: 'Cost Pool',
				xtype: 'uniCombobox',
				name: 'COST_POOL_NAME',
				comboType: 'AU',
				comboCode:'CBM600'
//				width: 325
			}]
		}],
			setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
						return !field.validate();
					});
   	
	   				if(invalid.length > 0) {
						r=false;
	   					var labelText = ''
	   	
						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
		region: 'north',
		layout : {type : 'uniTable', columns : 4 
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items : [{ 
    			fieldLabel: '상각년월',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'DVRY_DATE_FR',
		        endFieldName: 'DVRY_DATE_TO',
//			    width: 400,
		        allowBlank:false,
				tdAttrs: {width: 380},  
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('DVRY_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('DVRY_DATE_TO',newValue);
			    	}
			    }
	        },{
		        fieldLabel: '사업장',
			    name:'ACCNT_DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				colspan: 3,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
					panelSearch.setValue('ACCNT_DIV_CODE', newValue);
					}
	     		}
			},		    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
		    	valueFieldName: 'ACCNT',
		    	textFieldName: 'ACCNT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT', panelResult.getValue('ACCNT'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                  'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE,
                                  'ADD_QUERY': "SPEC_DIVI = 'K'"
                                }
                                popup.setExtParam(param);
                            }
                        }
                    
				}
		    }),{
				fieldLabel: '상각완료여부',
				xtype: 'uniCombobox',
				name: 'DPR_STS',
				comboType: 'AU',
				comboCode:'A035',
//				width: 325,
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DPR_STS', newValue);
					}
				}
			},		    
	    	Unilite.popup('IFRS_ASSET',{
		    	fieldLabel: '자산코드',
		    	valueFieldName: 'ASSET_CODE_FR',
		    	textFieldName: 'ASSET_NAME_FR', 
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ASSET_CODE_FR', panelResult.getValue('ASSET_CODE_FR'));
							panelSearch.setValue('ASSET_NAME_FR', panelResult.getValue('ASSET_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ASSET_CODE_FR', '');
						panelSearch.setValue('ASSET_NAME_FR', '');
					}
				}
		    }),		    
	    	Unilite.popup('IFRS_ASSET',{
		    	fieldLabel: '~',
		    	valueFieldName: 'ASSET_CODE_TO',
		    	textFieldName: 'ASSET_NAME_TO',
		    	labelWidth: 15,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ASSET_CODE_TO', panelResult.getValue('ASSET_CODE_TO'));
							panelSearch.setValue('ASSET_NAME_TO', panelResult.getValue('ASSET_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ASSET_CODE_TO', '');
						panelSearch.setValue('ASSET_NAME_TO', '');
					}
				}
		    })
		]
	});
    
	/* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aisc106skrvGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: masterStore,
		selModel	: 'rowmodel',
    	uniOpt:{
			useMultipleSorting	: true,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: true,		
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
//        tbar:[
//        	'->',
//    	{
//        	xtype:'button',
//        	text:'출력',
//        	handler:function()	{
//        		if(masterGrid.getSelectedRecords().length > 0 ){
//        				UniAppManager.app.onPrintButtonDown();
//		    		}
//		    		else{
//		    			alert("선택된 자료가 없습니다.");
//		    		}
//        		}
//    	}],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary',	showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  		showSummaryRow: true} ],
		columns:  [ /*{dataIndex: 'GUBUN' 		    , width:66,		hidden:true},
					{dataIndex: 'ACCNT_DIVI' 	    , width:66,		hidden:true},*/
		
		            
					{dataIndex: 'ACCNT' 		    , width:100,locked:true,       //원하는 컬럼 위치에 소계, 총계 타이틀 넣는다.
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
						}
					},
					{dataIndex: 'ACCNT_NAME' 	    , width:120,locked:true	},
					{dataIndex: 'ASST' 			    , width:106,locked:true	},
					{dataIndex: 'ASST_NAME' 	    , width:220,locked:true },
					{dataIndex: 'DEP_CTL' 		    , width:80,		align: 'center'},
					{dataIndex: 'DRB_YEAR' 		    , width:80,		align: 'center'},
					{dataIndex: 'DPR_STS2' 		    , width:80,		align: 'center'},
					{dataIndex: 'ACQ_AMT_I' 		, width:100, hidden:true},
					
					{dataIndex: 'ACQ_Q'             , width:80},
                    {dataIndex: 'ACQ_DATE'          , width:100},
					/* 상각대상금액 ↓
                     * BA_BALN_I
                     * CT_INCREASE_I
                     * CT_REDUCE_I 
                     * PT_DPR_TOT_I 
                     * PT_DMGLOS_TOT_I
                     * CT_BALN_I       
                     */
					{   
                        text:'상 각 대 상 금 액',
                        columns:[
                            {dataIndex: 'BA_BALN_I'         , width:120,    summaryType: 'sum'},
                            {dataIndex: 'CT_INCREASE_I'     , width:120,    summaryType: 'sum'},
                            {dataIndex: 'CT_REDUCE_I'       , width:120,    summaryType: 'sum'},
                            {dataIndex: 'ASST_VARI_AMT_I'   , width:120,hidden:true  },
                            
                            {dataIndex: 'PT_DPR_TOT_I'      , width:120,    summaryType: 'sum'},
                            {dataIndex: 'PT_DMGLOS_TOT_I'   , width:130,    summaryType: 'sum'},
                            {dataIndex: 'CT_BALN_I'         , width:160,    summaryType: 'sum'}
					   ]
					},
//                  {dataIndex: 'CT_DISPOSAL_I'     , width:110,    summaryType: 'sum'},
//                  {dataIndex: 'ASST_VARI_AMT_I'   , width:120,    summaryType: 'sum'},
//                  {dataIndex: 'CT_BALN_I'         , width:100,    summaryType: 'sum'},
                    
					/* 상각액 ↓
                     * CT_DPR_I
                     * CT_DPR_TOT_I
                     * CT_DMGLOS_TOT_I
                     * FL_BALN_I
                     */
                    {   
                        text:'상 각 액',
                        columns:[
                            {dataIndex: 'CT_DPR_I'          , width:120,    summaryType: 'sum'},
                            {dataIndex: 'CT_DPR_TOT_I'      , width:140,    summaryType: 'sum'},
                            {dataIndex: 'CT_DMGLOS_TOT_I'   , width:170,    summaryType: 'sum'},
                            {dataIndex: 'FL_BALN_I'         , width:170,    summaryType: 'sum'}
                       ]
                    },
					
//					{dataIndex: 'CT_DPR_REDUCE_I'   , width:110, 	summaryType: 'sum'},

					
					
//					{dataIndex: 'WASTE_YYYYMM' 	   	, width:100, 	summaryType: 'sum'},
					{dataIndex: 'COST_POOL_NAME'    , width:100, hidden:true},
					{dataIndex: 'COST_DIRECT' 	    , width:100, hidden:true},
					{dataIndex: 'ITEMLEVEL1_NAME'   , width:100, hidden:true},
					{dataIndex: 'ITEMLEVEL2_NAME'   , width:100, hidden:true},
					{dataIndex: 'ITEMLEVEL3_NAME'   , width:100, hidden:true}							// 쿼리 '' AS REMARK 된 컬럼은 삭제하고 expandLastColumn: true로 대체
//					{dataIndex: 'REMARK' 		    , width:100}
					
        ] ,
		listeners: {
	      	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
    		},
            onGridDblClick:function(grid, record, cellIndex, colName) {
                masterGrid.gotoAisc110skrv(record);
            }
		},
	
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
  			return true;
  		},
        uniRowContextMenu:{
			items: [{
            	text: '감가상각비상세내역조회  보기',   
            	itemId	: 'linkAisc110skrv',
            	handler: function(menuItem, event) {
                    var param = menuItem.up('menu');
                    masterGrid.gotoAisc110skrv(param.record);
                }
        	}]
	    },
		gotoAisc110skrv:function(record)	{
			if(record)   {
//                var record  = masterGrid.getSelectedRecord();
                var params = {
                    action:'select',
                    'PGM_ID'            :   'aisc106skrv',
                    'ASST'              :   record.data['ASST'],
                    'ASST_NAME'         :   record.data['ASST_NAME'],
                    'ACCNT'             :   record.data['ACCNT'],
                    'ACCNT_NAME'        :   record.data['ACCNT_NAME'],
                    'DPR_STS2'          :   record.data['DPR_STS2'],
                    'DVRY_DATE_FR'      :   panelSearch.getValue('DVRY_DATE_FR'),
                    'DVRY_DATE_TO'      :   panelSearch.getValue('DVRY_DATE_TO'),
                    'ACCNT_DIV_CODE'    :   panelSearch.getValue('ACCNT_DIV_CODE'),
                    'ACCNT_DIV_CODE'    :   panelSearch.getValue('ACCNT_DIV_CODE')
                }
            }
            var rec1 = {data : {prgID : 'aisc110skrv', 'text':''}};                         
            parent.openTab(rec1, '/accnt/aisc110skrv.do', params);
        }   
    });   
	
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, panelResult
			]	
		}		
		,panelSearch
		],
		id  : 'aisc106skrvApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DVRY_DATE_FR',[getStDt[0].STDT]);
			panelSearch.setValue('DVRY_DATE_TO',[getStDt[0].TODT]);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DVRY_DATE_FR',[getStDt[0].STDT]);
			panelResult.setValue('DVRY_DATE_TO',[getStDt[0].TODT]);
			UniAppManager.setToolbarButtons(['detail','reset','save'],false);

			//초기화 시 이월금액 행 안 보이게 설정
			var viewNormal = masterGrid.normalGrid.getView();
			var viewLocked = masterGrid.lockedGrid.getView();  
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);  

			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('DVRY_DATE_FR');	

			this.processParams(params);
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			var viewNormal = masterGrid.normalGrid.getView();
			var viewLocked = masterGrid.lockedGrid.getView();  
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false); 

			masterGrid.reset();
			masterStore.clearData();
			
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true); 
			
			masterGrid.getStore().loadStoreRecords();
		},/*//조회프로그램은 UNILITE에 신규 버튼이 활성화 안되면, Reset 버튼 비활성화
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},*/

		//링크로 넘어오는 params 받는 부분 (Aisc126skrv)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			//넘어온 params에 값이 있을때만 아래 내용 적용 (params 중 항상 값이 있는 것으로 조건식 만들기)
			if(params.PGM_ID == 'aisc126skrv') {
				panelSearch.setValue('ACCNT',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelSearch.setValue('DVRY_DATE_FR',params.DVRY_DATE_FR);
				panelSearch.setValue('DVRY_DATE_TO',params.DVRY_DATE_TO);
				
				panelResult.setValue('ACCNT',params.ACCNT);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('DVRY_DATE_FR',params.DVRY_DATE_FR);
				panelResult.setValue('DVRY_DATE_TO',params.DVRY_DATE_TO);;

				this.onQueryButtonDown();

				//masterGrid1.getStore().loadStoreRecords();
			}}
	});
};

</script>
