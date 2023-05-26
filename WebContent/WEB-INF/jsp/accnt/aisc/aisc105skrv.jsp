<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aisc105skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="aisc105skrv" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A035" /> 		<!-- 완료여부-->
	<t:ExtComboStore comboType="AU" comboCode="A004" /> 		<!-- 상각여부-->
	<t:ExtComboStore comboType="AU" comboCode="B031" /> 		<!-- 수불생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="CBM600" /> 		<!-- Cost Pool-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
//국고보조금사용여부
var gsGovGrandCont = '${gsGovGrandCont}'

var useGovGrantCont = false;
if(gsGovGrandCont == "1"){
	useGovGrantCont = true;
}

function appMain() {

var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aisc105skrvModel', {
	    fields: [
	    	{name: 'GUBUN' 					,text: 'GUBUN' 										,type: 'string'},
	    	{name: 'ACCNT_DIVI' 			,text: 'ACCNT_DIVI' 								,type: 'string'},
	    	{name: 'ACCNT' 					,text: '계정코드' 									,type: 'string'},
	    	{name: 'ACCNT_NAME' 			,text: '계정과목' 									,type: 'string'},
	    	{name: 'ASST' 					,text: '자산코드' 									,type: 'string'},
	    	{name: 'ASST_NAME' 				,text: '자산명' 										,type: 'string'},
	    	{name: 'ACQ_AMT_I' 				,text: '최초취득가액' 								,type: 'uniPrice'},
	    	{name: 'ACQ_DATE' 				,text: '취득일' 										,type: 'uniDate'},
	    	{name: 'DEP_CTL' 				,text: '상각방법' 									,type: 'string'},
	    	{name: 'DRB_YEAR' 				,text: '내용년수' 									,type: 'string'},
	    	{name: 'DPR_STS2' 				,text: '상각여부' 									,type: 'string'},
	    	{name: 'ACQ_Q' 					,text: '취득수량' 									,type: 'uniQty'},
	    	{name: 'BA_BALN_I' 				,text: '전기말취득원가' 								,type: 'uniPrice'},
	    	{name: 'CT_INCREASE_I' 			,text: '당기증가액'     	    						,type: 'uniPrice'},
	    	{name: 'CT_REDUCE_I' 			,text: '매각금액' 			 					   	,type: 'uniPrice'},
	    	{name: 'CT_DISPOSAL_I' 			,text: '당기자산처분액' 								,type: 'uniPrice'},
	        {name: 'ASST_VARI_AMT_I' 		,text: '재평가후자산증감' 							,type: 'uniPrice'},
	    	{name: 'CT_BALN_I' 				,text: '당기상각대상원가'  	  						,type: 'uniPrice'},
	    	{name: 'PT_DPR_TOT_I' 			,text: '전기말상각누계액' 							,type: 'uniPrice'},
	    	{name: 'CT_DPR_I' 				,text: '당기상각액' 									,type: 'uniPrice'},
	    	{name: 'CT_DPR_REDUCE_I' 		,text: '당기상각감소액' 								,type: 'uniPrice'},
	    	{name: 'CT_DPR_TOT_I' 			,text: '당기말상각누계액' 							,type: 'uniPrice'},
	        {name: 'CT_DMGLOS_TOT_I' 		,text: '당기말손상차손누계액' 						,type: 'uniPrice'}, 
	    	{name: 'FL_BALN_I' 				,text: '미상각잔액' 									,type: 'uniPrice'},
	    	{name: 'WASTE_YYYYMM' 			,text: 'WASTE_YYYYMM' 								,type: 'string'},
	    	{name: 'COST_POOL_NAME' 		,text: 'Cost Pool' 									,type: 'string'},
	    	{name: 'COST_DIRECT' 			,text: 'Cost Pool 직과' 								,type: 'string'},
	    	{name: 'ITEMLEVEL1_NAME' 		,text: '대분류' 										,type: 'string'},
	    	{name: 'ITEMLEVEL2_NAME' 		,text: '중분류' 										,type: 'string'},
	    	{name: 'ITEMLEVEL3_NAME' 		,text: '소분류' 										,type: 'string'},
	    	{name: 'SALE_MANAGE_COST' 		,text: '판관(%)' 									,type: 'int'},
	    	{name: 'SALE_MANAGE_DEPT_NAME' 	,text: '판관귀속부서' 								,type: 'string'},
	    	{name: 'PRODUCE_COST' 			,text: '제조(%)' 									,type: 'int'},
	    	{name: 'PRODUCE_DEPT_NAME' 		,text: '제조귀속부서' 								,type: 'string'},
	    	{name: 'SALE_COST' 				,text: '경상(%)' 									,type: 'int'},
	    	{name: 'SALE_DEPT_NAME' 		,text: '경상귀속부서' 								,type: 'string'},
	    	{name: 'SUBCONTRACT_COST' 		,text: '도급(%)' 									,type: 'int'},
	    	{name: 'SUBCONTRACT_DEPT_NAME' 	,text: '도급귀속부서' 								,type: 'string'},
	    	{name: 'CALTOSALEMAG' 			,text: '판관배부상각액' 								,type: 'uniPrice'},
	    	{name: 'CALTOPROD' 				,text: '제조배부상각액' 								,type: 'uniPrice'},
	    	{name: 'CALTOSALE' 				,text: '경상배부상각액' 								,type: 'uniPrice'},
	    	{name: 'CALTOSUBCON' 			,text: '도급배부상각액' 								,type: 'uniPrice'},
	    	{name: 'GOV_GRANT_ACCNT'		,text: '국고보조금<br/>계정코드'						,type: 'string'},
			{name: 'GOV_GRANT_ACCNT_NAME'	,text: '국고보조금<br/>계정명'						,type: 'string'},
			{name: 'GOV_GRANT_AMT_I'		,text: '국고보조금'									,type: 'uniPrice'},
			{name: 'PT_GOV_GRANT_DPR_TOT_I'	,text: '국고보조금<br/>전기말차감누계액'				,type: 'uniPrice'},
			{name: 'CT_GOV_GRANT_DPR_I'		,text: '국고보조금<br/>당기차감액'					,type: 'uniPrice'},
			{name: 'CT_GOV_GRANT_DPR_TOT_I'	,text: '국고보조금<br/>당기말차감누계액'				,type: 'uniPrice'},
			{name: 'GOV_GRANT_BALN_I'		,text: '국고보조금<br/>미차감잔액'					,type: 'uniPrice'},
			//20201230 추가   
			{name: 'GOV_GRANT_DPR_TOT_I'	,text: '국고보조금<br/>차감누계액'					,type: 'uniPrice'},
			{name: 'PT_YRDPRI_GOV_DPR_TOT_I',text: '전기말상각누계액<br/>-국고전기차감누계액'		,type: 'uniPrice'},
			{name: 'CT_YRDPRI_GOV_DPR_I'	,text: '당기상각액<br/>-국고당기차감누계액'			,type: 'uniPrice'},
			{name: 'CT_YRDPRI_GOV_DPR_TOT_I',text: '당기말상각누계액<br/>-국고당기말차감누계액'	,type: 'uniPrice'},
			{name: 'BALNDPRI_GOV_BALN_I'	,text: '미상각잔액<br/>-국고미차감잔액'				,type: 'uniPrice'}
		
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('aisc105skrvmasterStore',{
		model: 'aisc105skrvModel',
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
            	   read: 'aisc105skrvService.selectList'                	
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
				var viewNormal = masterGrid.getView();
				//조회된 데이터가 있을 때, 합계 보이게 설정 / 그리드에 포커스 가도록 변경
				if(store.getCount() > 0){
//		   	 		viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		   	 		viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    		viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

		    		masterGrid.focus();
				//조회된 데이터가 없을 때, 합계 안 보이게 설정 / 패널의 첫번째 필드에 포커스 가도록 변경
	    		}else{
//					viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
//					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
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
			    autoPopup : true,
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
			    autoPopup : true,
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
//			    popupWidth: 710
			}),   	
				Unilite.popup('AC_PROJECT',{ 
				fieldLabel: '~',
				valueFieldName: 'PJT_CODE_TO', 
				textFieldName: 'PJT_NAME_FR', 
//				popupWidth: 710
			}),		    
	        	Unilite.popup('DEPT',{
		        fieldLabel: '부서',
			    valueFieldName:'DEPT_CODE_FR',
			    textFieldName:'DEPT_NAME_FR'
		    }),		    
	        	Unilite.popup('DEPT',{
		        fieldLabel: '~',
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
			    autoPopup : true,
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
			    autoPopup : true,
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
    var masterGrid = Unilite.createGrid('aisc105skrvGrid1', {
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
		tbar:[{
			text:'출    력',
			handler: function() {
				UniAppManager.app.onPrintButtonDown();
			}
		}],
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
					{dataIndex: 'ACCNT' 		    , width:100,		locked: false,	align: 'center',       //원하는 컬럼 위치에 소계, 총계 타이틀 넣는다.
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
						}
					},
					{dataIndex: 'ACCNT_NAME' 	    , width:100,	locked: false},
					{dataIndex: 'GOV_GRANT_ACCNT' 			, width:100,	locked: false, hidden : !useGovGrantCont},
					{dataIndex: 'GOV_GRANT_ACCNT_NAME' 	    , width:100,	locked: false, hidden : !useGovGrantCont},
					{dataIndex: 'ASST' 			    , width:106,	locked: false},
					{dataIndex: 'ASST_NAME' 	    , width:220,	locked: false},
					{dataIndex: 'ACQ_AMT_I' 	    , width:106,	locked: false,	summaryType: 'sum'},
					{dataIndex: 'GOV_GRANT_AMT_I' 	, width:106,	locked: false,	summaryType: 'sum', hidden : !useGovGrantCont},
					{dataIndex: 'ACQ_DATE' 		    , width:100},
					{dataIndex: 'DEP_CTL' 		    , width:80,		align: 'center'},
					{dataIndex: 'DRB_YEAR' 		    , width:80,		align: 'center'},
					{dataIndex: 'DPR_STS2' 		    , width:80,		align: 'center'},
					{dataIndex: 'ACQ_Q' 		    , width:80},
					{dataIndex: 'BA_BALN_I' 		, width:120, 	summaryType: 'sum'},
					{dataIndex: 'CT_INCREASE_I' 	, width:110, 	summaryType: 'sum'},
					{dataIndex: 'CT_REDUCE_I' 		, width:110, 	summaryType: 'sum'},
					{dataIndex: 'CT_DISPOSAL_I' 	, width:110, 	summaryType: 'sum'},
					{dataIndex: 'ASST_VARI_AMT_I' 	, width:120,hidden:true 	/*summaryType: 'sum'*/},
					{dataIndex: 'CT_BALN_I' 		, width:120, 	summaryType: 'sum'},
					{dataIndex: 'PT_DPR_TOT_I' 	   	, width:120, 	summaryType: 'sum'},
					{dataIndex: 'PT_GOV_GRANT_DPR_TOT_I' 	, width:120, 	summaryType: 'sum', hidden : !useGovGrantCont},
					{dataIndex: 'PT_YRDPRI_GOV_DPR_TOT_I' 	, width:140, 	summaryType: 'sum', hidden : !useGovGrantCont},
					
					{dataIndex: 'CT_DPR_I' 		  	, width:100, 	summaryType: 'sum'},
					{dataIndex: 'CT_GOV_GRANT_DPR_I', width:100, 	summaryType: 'sum', hidden : !useGovGrantCont},
					{dataIndex: 'CT_YRDPRI_GOV_DPR_I', width:140, 	summaryType: 'sum', hidden : !useGovGrantCont},
					
					{dataIndex: 'CT_DPR_REDUCE_I'   , width:110, 	summaryType: 'sum'},
					{dataIndex: 'CT_DPR_TOT_I' 	   	, width:120, 	summaryType: 'sum'},
					{dataIndex: 'GOV_GRANT_DPR_TOT_I', width:120, 	summaryType: 'sum', hidden : !useGovGrantCont},
					{dataIndex: 'CT_GOV_GRANT_DPR_TOT_I' 	, width:120, 	summaryType: 'sum', hidden : !useGovGrantCont},
					{dataIndex: 'CT_YRDPRI_GOV_DPR_TOT_I' 	, width:160, 	summaryType: 'sum', hidden : !useGovGrantCont},
					
					{dataIndex: 'CT_DMGLOS_TOT_I'   	, width:150, 	summaryType: 'sum'},
					{dataIndex: 'FL_BALN_I' 			, width:100, 	summaryType: 'sum'},
					{dataIndex: 'GOV_GRANT_BALN_I' 		, width:100, 	summaryType: 'sum', hidden : !useGovGrantCont},
					{dataIndex: 'BALNDPRI_GOV_BALN_I' 		, width:140, 	summaryType: 'sum', hidden : !useGovGrantCont},
					
//					{dataIndex: 'WASTE_YYYYMM' 	   	, width:100, 	summaryType: 'sum'},
					{dataIndex: 'COST_POOL_NAME'    	, width:100,hidden:true},
					{dataIndex: 'COST_DIRECT' 	    	, width:100,hidden:true},
					{dataIndex: 'ITEMLEVEL1_NAME'   	, width:100,hidden:true},
					{dataIndex: 'ITEMLEVEL2_NAME'  	 	, width:100,hidden:true},
					{dataIndex: 'ITEMLEVEL3_NAME'   	, width:100,hidden:true},
					{dataIndex: 'SALE_MANAGE_COST' 		, width:80},
					{dataIndex: 'CALTOSALEMAG' 			, width:110},
			    	{dataIndex: 'SALE_MANAGE_DEPT_NAME' , width:100},
			    	{dataIndex: 'PRODUCE_COST' 			, width:80},
			    	{dataIndex: 'CALTOPROD' 			, width:110},
			    	{dataIndex: 'PRODUCE_DEPT_NAME' 	, width:100},
			    	{dataIndex: 'SALE_COST' 			, width:80},
			    	{dataIndex: 'CALTOSALE' 			, width:110},
			    	{dataIndex: 'SALE_DEPT_NAME' 		, width:100},
			    	{dataIndex: 'SUBCONTRACT_COST' 		, width:80},
			    	{dataIndex: 'CALTOSUBCON' 			, width:110},
			    	{dataIndex: 'SUBCONTRACT_DEPT_NAME' , width:100}
			    	
        ] ,
		listeners: {
	      	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
    		},
    		onGridDblClick:function(grid, record, cellIndex, colName, td)   {
    			grid.ownerGrid.gotoAisc110skrv(record);
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
            		var record	= masterGrid.getSelectedRecord();
					
            		masterGrid.gotoAisc110skrv(record);
            	}
        	}]
	    },
		gotoAisc110skrv:function(record)	{
			if(record)	{
				var params	= {
					'PGM_ID'			: 	'aisc105skrv',
					'ASST'				:	record.get('ASST'),
					'ASST_NAME'			:	record.get('ASST_NAME'),
					'ACCNT'				:	record.get('ACCNT'),
					'ACCNT_NAME'		:	record.get('ACCNT_NAME'),
					'DPR_STS2'			:	record.get('DPR_STS2'),
					//월까지만 넘기고, 상세내역조회에서도 월로 받아 조회
					'DVRY_DATE_FR'		:	panelSearch.getValue('DVRY_DATE_FR'),
					'DVRY_DATE_TO'		:	panelSearch.getValue('DVRY_DATE_TO'),
					'ACCNT_DIV_CODE'	:	panelSearch.getValue('ACCNT_DIV_CODE'),
					'ACCNT_DIV_CODE'	:	panelSearch.getValue('ACCNT_DIV_CODE')
				};
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
		id  : 'aisc105skrvApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DVRY_DATE_FR',[getStDt[0].STDT]);
			panelSearch.setValue('DVRY_DATE_TO',[getStDt[0].TODT]);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DVRY_DATE_FR',[getStDt[0].STDT]);
			panelResult.setValue('DVRY_DATE_TO',[getStDt[0].TODT]);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);

			//초기화 시 이월금액 행 안 보이게 설정
			/* var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false); */

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
			/* var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false); */

			masterGrid.reset();
			masterStore.clearData();
			
			//viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			
			masterGrid.getStore().loadStoreRecords();
		},/*//조회프로그램은 UNILITE에 신규 버튼이 활성화 안되면, Reset 버튼 비활성화
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},*/

		//링크로 넘어오는 params 받는 부분 (Aisc125skrv)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			//넘어온 params에 값이 있을때만 아래 내용 적용 (params 중 항상 값이 있는 것으로 조건식 만들기)
			if(params.PGM_ID == 'aisc125skrv') {
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
			}
		},
			onPrintButtonDown: function() {
				var param = panelSearch.getValues();
				
				var win = Ext.create('widget.ClipReport', {
					url: CPATH+'/accnt/aisc105clskrv.do',
					prgID: 'aisc105skrv',
					extParam: param
				})
				win.center();
				win.show();
			}
	});
};

</script>
