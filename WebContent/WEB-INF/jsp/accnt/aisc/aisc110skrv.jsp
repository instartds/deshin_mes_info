<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="aisc110skrv"  >
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

	Unilite.defineModel('aisc110skrvModel', {		
	    fields: [
	    	{name: 'ASST',					text: '자산코드'				,type: 'string'},
	    	{name: 'ASST_NAME',				text: '자산명'				,type: 'string'},
	    	{name: 'DPR_YYMM',				text: '상각년월'				,type: 'string'},
	    	{name: 'PM_BALN_I',				text: '전월미상각잔액'			,type: 'uniPrice'},
	    	{name: 'TM_DPR_I',				text: '당월상각액'				,type: 'uniPrice'},
	    	{name: 'TM_REDUCE_I',			text: '당월상각감소액'			,type: 'uniPrice'},
	    	{name: 'TM_DPR_TOT_I',			text: '당월말상각누계액'			,type: 'uniPrice'},
	    	{name: 'CT_DPR_I',				text: '당기간상각비'			,type: 'uniPrice'},
	    	{name: 'TM_DMGLOS_EX_I',		text: '당월손상차손'			,type: 'uniPrice'},
	    	{name: 'TM_DMGLOS_IN_I',		text: '당월손상차손환입'			,type: 'uniPrice'},
	    	{name: 'TM_DMGLOS_TOT_I',		text: '당월손상차손누계액'		,type: 'uniPrice'},
	    	{name: 'TM_BALN_I',				text: '당월말미상각잔액'			,type: 'uniPrice'},
	    	{name: 'TM_CPT_I',				text: '자본적지출액'			,type: 'uniPrice'},
	    	{name: 'TM_SALE_I',				text: '매각/폐기금액'			,type: 'uniPrice'},
	    	{name: 'TM_REVAL_I',			text: '재평가액'				,type: 'uniPrice'},
	    	{name: 'ASST_VARI_AMT_I_YYMM',	text: '당월재평가액'				,type: 'uniPrice'},
	    	{name: 'ASST_VARI_AMT_I',		text: '재평가누계액'				,type: 'uniPrice'},
	    	{name: 'DPR_STS',				text: '상각완료여부'			,type: 'string'},
	    	{name: 'ACQ_DATE',				text: '취득일'				,type: 'uniDate'},
	    	{name: 'ACQ_AMT_I',				text: '취득가액'				,type: 'uniPrice'},
	    	{name: 'DRB_YEAR',				text: '내용년수'				,type: 'uniQty'},
	    	{name: 'DEP_CTL',				text: '상각방법'				,type: 'string'},
	    	{name: 'EX_DATE',				text: '결의일자'				,type: 'uniDate'},
	    	{name: 'EX_NUM',				text: '결의번호'				,type: 'int'},
	    	{name: 'COST_POOL_NAME',		text: 'Cost Pool'			,type: 'string'},
	    	{name: 'COST_DIRECT',			text: 'Cost Pool 직과'		,type: 'string'},
	    	{name: 'ITEMLEVEL1_NAME',		text: '대분류'				,type: 'string'},
	    	{name: 'ITEMLEVEL2_NAME',		text: '중분류'				,type: 'string'},
	    	{name: 'ITEMLEVEL3_NAME',		text: '소분류'				,type: 'string'},
	    	
			{name: 'GOV_GRANT_AMT_I'		,text: '국고보조금'					,type: 'uniPrice'},
			{name: 'PM_GOV_GRANT_BALN_I'	,text: '국고보조금<br/>전월미차감잔액'		,type: 'uniPrice'},
			{name: 'TM_GOV_GRANT_DPR_I'		,text: '국고보조금<br/>당월차감액'		,type: 'uniPrice'},
			{name: 'TM_GOV_GRANT_DPR_TOT_I'	,text: '국고보조금<br/>당월말차감누계액'	,type: 'uniPrice'},
			{name: 'TM_GOV_GRANT_BALN_I'	,text: '국고보조금<br/>당월말미차감잔액'	,type: 'uniPrice'},
			
			{name: 'BL_PM_GOV_GRANT_BALN_I'	,text: '전월미상각잔액<br/>-국고전월미차감잔액'		,type: 'uniPrice'},
			{name: 'BL_TM_GOV_GRANT_DPR_I'	,text: '당월상각액<br/>-국고당월차감액'		,type: 'uniPrice'},
			{name: 'BL_TM_GOV_GRANT_DPR_TOT_I'	,text: '당월말상각누계액<br/>-국고당월말차감누계액'	,type: 'uniPrice'},
			{name: 'BL_TM_GOV_GRANT_BALN_I'	,text: '당월말미상각잔액<br/>-국고당월말미차감잔액'	,type: 'uniPrice'},
			
	    	{name: 'REMARK',				 text: '비고'					,type: 'string'}
		]
	});
	
	var MasterStore = Unilite.createStore('aisc110skrvMasterStore',{
		model: 'aisc110skrvModel',
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
            	   read: 'aisc110skrvService.selectList'                	
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
				//조회된 데이터가 있을 때, 그리드에 포커스 가도록 변경
				if(store.getCount() > 0){
		    		masterGrid.focus();
				//조회된 데이터가 없을 때, 패널의 첫번째 필드에 포커스 가도록 변경
	    		}else{
					var activeSForm ;		
					if(!UserInfo.appOption.collapseLeftSearch)	{	
						activeSForm = panelSearch;	
					}else {		
						activeSForm = panelResult;	
					}		
					activeSForm.onLoadSelectText('DVRY_DATE_FR');	
				}
			}          		
      	}
		//groupField: 'CUSTOM_NAME'
	});

	/* panetSearch
	 * 
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
		    	validateBlank: true,
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
		    	validateBlank: true,
			    autoPopup : true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE_FR', records[0]['ASSET_CODE']);
							panelResult.setValue('ASSET_NAME_FR', records[0]['ASSET_NAME']);				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE_FR', '');
						panelResult.setValue('ASSET_NAME_FR', '');
						panelSearch.setValue('ASSET_CODE_FR', '');
						panelSearch.setValue('ASSET_NAME_FR', '');
					}
				}
		    }),		    
	    	Unilite.popup('IFRS_ASSET',{
		    	fieldLabel: '~',
		    	valueFieldName: 'ASSET_CODE_TO',
		    	textFieldName: 'ASSET_NAME_TO', 
		    	validateBlank: true,
			    autoPopup : true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE_TO', records[0]['ASSET_CODE']);
							panelResult.setValue('ASSET_NAME_TO', records[0]['ASSET_NAME']);				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE_TO', '');
						panelResult.setValue('ASSET_NAME_TO', '');
						panelSearch.setValue('ASSET_CODE_TO', '');
						panelSearch.setValue('ASSET_NAME_TO', '');
					}
				}
		    })]		
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
					//this.mask();		    
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
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
		    	validateBlank: true,
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
		    	validateBlank: true,
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
						panelResult.setValue('ASSET_CODE_FR', '');
						panelResult.setValue('ASSET_NAME_FR', '');
					}
				}
		    }),		    
	    	Unilite.popup('IFRS_ASSET',{
		    	fieldLabel: '~',
		    	valueFieldName: 'ASSET_CODE_TO',
		    	textFieldName: 'ASSET_NAME_TO',
		    	validateBlank: true,
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
						panelResult.setValue('ASSET_CODE_TO', '');
						panelResult.setValue('ASSET_NAME_TO', '');
					}
				}
		    })
		]
	});
	
	var masterGrid = Unilite.createGrid('aisc110skrvGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        flex: 3,
    	store: MasterStore,
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
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
        	{ dataIndex: 'ASST',					width: 100},
        	{ dataIndex: 'ASST_NAME',				width: 170},
        	{ dataIndex: 'DPR_YYMM',				width: 80, 	align: 'center'},
        	{ dataIndex: 'PM_BALN_I',				width: 120},
        	{ dataIndex: 'PM_GOV_GRANT_BALN_I',		width: 120, hidden : !useGovGrantCont},
        	{ dataIndex: 'BL_PM_GOV_GRANT_BALN_I',		width: 140, hidden : !useGovGrantCont},
        	
        	{ dataIndex: 'TM_DPR_I',				width: 120},
        	{ dataIndex: 'TM_GOV_GRANT_DPR_I',		width: 120, hidden : !useGovGrantCont},
        	{ dataIndex: 'BL_TM_GOV_GRANT_DPR_I',		width: 150, hidden : !useGovGrantCont},
        	
        	{ dataIndex: 'TM_REDUCE_I',				width: 120},
        	{ dataIndex: 'TM_DPR_TOT_I',			width: 120},
        	{ dataIndex: 'TM_GOV_GRANT_DPR_TOT_I',			width: 120, hidden : !useGovGrantCont},
        	{ dataIndex: 'BL_TM_GOV_GRANT_DPR_TOT_I',			width: 160, hidden : !useGovGrantCont},
        	
        	{ dataIndex: 'CT_DPR_I',				width: 120},
        	{ dataIndex: 'ASST_VARI_AMT_I_YYMM',	width: 120},
        	{ dataIndex: 'ASST_VARI_AMT_I',			width: 120},
        	{ dataIndex: 'TM_DMGLOS_EX_I',			width: 120},
        	{ dataIndex: 'TM_DMGLOS_IN_I',			width: 120},
        	{ dataIndex: 'TM_DMGLOS_TOT_I',			width: 140},
        	{ dataIndex: 'TM_BALN_I',				width: 120},
        	{ dataIndex: 'TM_GOV_GRANT_BALN_I',		width: 120, hidden : !useGovGrantCont},
        	{ dataIndex: 'BL_TM_GOV_GRANT_BALN_I',		width: 170, hidden : !useGovGrantCont},
        	
        	{ dataIndex: 'TM_CPT_I',				width: 120},
        	{ dataIndex: 'TM_SALE_I',				width: 120},
        	{ dataIndex: 'TM_REVAL_I',				width: 120},
        	{ dataIndex: 'DPR_STS',					width: 120},
        	{ dataIndex: 'ACQ_DATE',				width: 120},
        	{ dataIndex: 'ACQ_AMT_I',				width: 120},
        	{ dataIndex: 'GOV_GRANT_AMT_I',			width: 120, hidden : !useGovGrantCont},
        	{ dataIndex: 'DRB_YEAR',				width: 120},
        	{ dataIndex: 'DEP_CTL',					width: 120},
        	{ dataIndex: 'EX_DATE',					width: 120},
        	{ dataIndex: 'EX_NUM',					width: 120},
        	{ dataIndex: 'COST_POOL_NAME',			width: 120},
        	{ dataIndex: 'COST_DIRECT',				width: 120},
        	{ dataIndex: 'ITEMLEVEL1_NAME',			width: 120},
        	{ dataIndex: 'ITEMLEVEL2_NAME',			width: 120},
        	{ dataIndex: 'ITEMLEVEL3_NAME',			width: 120},
        	{ dataIndex: 'REMARK',					width: 120}
        ] 
		 
    });

    /**
	 * main app
	 */
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]	
		},
		panelSearch
		],
		 id  : 'aisc110skrvApp',
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
			masterGrid.reset();
			MasterStore.clearData();
			masterGrid.getStore().loadStoreRecords();
		},
        //링크로 넘어오는 params 받는 부분 (aisc105skrv)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			//넘어온 params에 값이 있을때만 아래 내용 적용 (params 중 항상 값이 있는 것으로 조건식 만들기)
			if(params.PGM_ID == 'aisc105skrv') {
				panelSearch.setValue('ACCNT',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelSearch.setValue('DVRY_DATE_FR',params.DVRY_DATE_FR);
				panelSearch.setValue('DVRY_DATE_TO',params.DVRY_DATE_TO);
				panelSearch.setValue('DPR_STS',params.DPR_STS2);
				panelSearch.setValue('ASSET_CODE_FR',params.ASST);
				panelSearch.setValue('ASSET_NAME_FR',params.ASST_NAME);
				panelSearch.setValue('ASSET_CODE_TO',params.ASST);
				panelSearch.setValue('ASSET_NAME_TO',params.ASST_NAME);
				
				panelResult.setValue('ACCNT',params.ACCNT);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('DVRY_DATE_FR',params.DVRY_DATE_FR);
				panelResult.setValue('DVRY_DATE_TO',params.DVRY_DATE_TO);;
				panelResult.setValue('DPR_STS',params.DPR_STS2);
				panelResult.setValue('ASSET_CODE_FR',params.ASST);
				panelResult.setValue('ASSET_NAME_FR',params.ASST_NAME);
				panelResult.setValue('ASSET_CODE_TO',params.ASST);
				panelResult.setValue('ASSET_NAME_TO',params.ASST_NAME);

				this.onQueryButtonDown();

				//masterGrid1.getStore().loadStoreRecords();
			}else if(params.PGM_ID == 'aisc106skrv') {
                panelSearch.setValue('ACCNT',params.ACCNT);
                panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
                panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
                panelSearch.setValue('DVRY_DATE_FR',params.DVRY_DATE_FR);
                panelSearch.setValue('DVRY_DATE_TO',params.DVRY_DATE_TO);
                panelSearch.setValue('DPR_STS',params.DPR_STS2);
                panelSearch.setValue('ASSET_CODE_FR',params.ASST);
                panelSearch.setValue('ASSET_NAME_FR',params.ASST_NAME);
                panelSearch.setValue('ASSET_CODE_TO',params.ASST);
                panelSearch.setValue('ASSET_NAME_TO',params.ASST_NAME);
                
                panelResult.setValue('ACCNT',params.ACCNT);
                panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
                panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
                panelResult.setValue('DVRY_DATE_FR',params.DVRY_DATE_FR);
                panelResult.setValue('DVRY_DATE_TO',params.DVRY_DATE_TO);;
                panelResult.setValue('DPR_STS',params.DPR_STS2);
                panelResult.setValue('ASSET_CODE_FR',params.ASST);
                panelResult.setValue('ASSET_NAME_FR',params.ASST_NAME);
                panelResult.setValue('ASSET_CODE_TO',params.ASST);
                panelResult.setValue('ASSET_NAME_TO',params.ASST_NAME);

                this.onQueryButtonDown();
			}
		}
	});
/*
	function lastFieldSpacialKey(elm, e)	{
		if( e.getKey() == Ext.event.Event.ENTER)	{
			if(elm.isExpanded)	{
    			var picker = elm.getPicker();
    			if(picker)	{
    				var view = picker.selectionModel.view;
    				if(view && view.highlightItem)	{
    					picker.select(view.highlightItem);
    				}
    			}
			}else {
				if((hideDivCode && elm.name == 'INPUT_PATH') || elm.name == 'DIV_CODE'){
					var grid = UniAppManager.app.getActiveGrid();
					var record = grid.getStore().getAt(0);
					if(record)	{
						e.stopEvent();
						grid.editingPlugin.startEdit(record,grid.getColumn('AC_DAY'))
					}else {
						UniAppManager.app.onQueryButtonDown();
					}
				}else {
                	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
                		Unilite.focusPrevField(elm, true, e);
                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
                		Unilite.focusNextField(elm, true, e);
                	}
            	}
			}
		}
	}*/
};
</script>
