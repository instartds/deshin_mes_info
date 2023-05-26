<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="aisc115skrv"  >
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

	Unilite.defineModel('aisc115skrvModel', {		
	    fields: [
	    	{name: 'ASST',					text: '자산코드'				,type: 'string'},
	    	{name: 'ASST_NAME',				text: '자산명'				,type: 'string'},
	    	{name: 'ACCNT',					text: '계정코드'				,type: 'string'},
	    	{name: 'ACCNT_NAME',			text: '계정명'				,type: 'string'},
	    	{name: 'ACQ_DATE',				text: '취득일'				,type: 'uniDate'},
	    	{name: 'DRB_YEAR',				text: '내용년수'				,type: 'int'},
	    	{name: 'ACQ_AMT_I',				text: '취득가액'				,type: 'uniPrice'},
	    	{name: 'GOV_ACQ_AMT_I',			text: '국고보조금'				,type: 'uniPrice'},
	    	{name: 'DPR_YYMM_1',			text: '1월'				,type: 'uniPrice'},
	    	{name: 'DPR_YYMM_2',			text: '2월'				,type: 'uniPrice'},
	    	{name: 'DPR_YYMM_3',			text: '3월'				,type: 'uniPrice'},
	    	{name: 'DPR_YYMM_4',			text: '4월'				,type: 'uniPrice'},
	    	{name: 'DPR_YYMM_5',			text: '5월'				,type: 'uniPrice'},
	    	{name: 'DPR_YYMM_6',			text: '6월'				,type: 'uniPrice'},
	    	{name: 'DPR_YYMM_7',			text: '7월'				,type: 'uniPrice'},
	    	{name: 'DPR_YYMM_8',			text: '8월'				,type: 'uniPrice'},
	    	{name: 'DPR_YYMM_9',			text: '9월'				,type: 'uniPrice'},
	    	{name: 'DPR_YYMM_10',			text: '10월'				,type: 'uniPrice'},
	    	{name: 'DPR_YYMM_11',			text: '11월'				,type: 'uniPrice'},
	    	{name: 'DPR_YYMM_12',			text: '12월'				,type: 'uniPrice'},
	    	{name: 'TM_DPR_TOT_I',			text: '상각누계액'			,type: 'uniPrice'},
	    	{name: 'TM_BALN_I',				text: '미상각잔액'			,type: 'uniPrice'},
	    	
	    	{name: 'GOV_DPR_YYMM_1',		text: '국고보조금<br/>1월'				,type: 'uniPrice'},
	    	{name: 'GOV_DPR_YYMM_2',		text: '국고보조금<br/>2월'				,type: 'uniPrice'},
	    	{name: 'GOV_DPR_YYMM_3',		text: '국고보조금<br/>3월'				,type: 'uniPrice'},
	    	{name: 'GOV_DPR_YYMM_4',		text: '국고보조금<br/>4월'				,type: 'uniPrice'},
	    	{name: 'GOV_DPR_YYMM_5',		text: '국고보조금<br/>5월'				,type: 'uniPrice'},
	    	{name: 'GOV_DPR_YYMM_6',		text: '국고보조금<br/>6월'				,type: 'uniPrice'},
	    	{name: 'GOV_DPR_YYMM_7',		text: '국고보조금<br/>7월'				,type: 'uniPrice'},
	    	{name: 'GOV_DPR_YYMM_8',		text: '국고보조금<br/>8월'				,type: 'uniPrice'},
	    	{name: 'GOV_DPR_YYMM_9',		text: '국고보조금<br/>9월'				,type: 'uniPrice'},
	    	{name: 'GOV_DPR_YYMM_10',		text: '국고보조금<br/>10월'				,type: 'uniPrice'},
	    	{name: 'GOV_DPR_YYMM_11',		text: '국고보조금<br/>11월'				,type: 'uniPrice'},
	    	{name: 'GOV_DPR_YYMM_12',		text: '국고보조금<br/>12월'				,type: 'uniPrice'},
	    	{name: 'GOV_TM_DPR_TOT_I',		text: '국고보조금<br/>누적차감액'			,type: 'uniPrice'},
	    	{name: 'GOV_TM_BALN_I',			text: '국고보조금<br/>미차감잔액'			,type: 'uniPrice'},
	    	{name: 'YRDPRI_GOV_DPR_TOT_I',	text: '상각누계<br/>-국고차감누계'		,type: 'uniPrice'},
	    	{name: 'BALNDPRI_GOV_BALN_I',	text: '미상각잔액<br/>-국고미차감잔액'	,type: 'uniPrice'}
		]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'aisc115skrvService.selectList'     
		}
	});
	var MasterStore = Unilite.createStore('aisc115skrvMasterStore',{
		model: 'aisc115skrvModel',
		uniOpt : {
        	isMaster:	true,			// 상위 버튼 연결 
        	editable:	false,			// 수정 모드 사용 
        	deletable:	false,			// 삭제 가능 여부 
            useNavi:	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
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
    			fieldLabel: '기준년도',
		        name: 'DPR_YEAR',
		        allowBlank:false,
		        fieldStyle:'text-align : center;',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('DPR_YEAR', newValue);
					}
				}
	        },Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
		    	valueFieldName: 'ACCNT',
		    	textFieldName: 'ACCNT_NAME',
		    	validateBlank: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT', records[0]['ACCNT_CODE']);
							panelResult.setValue('ACCNT_NAME', records[0]['ACCNT_NAME']);				 																							
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
		        fieldLabel: '사업장',
			    name:'ACCNT_DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
//			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
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
		items: [
			{ 
	   			fieldLabel: '기준년도',
	   			maxLength:4,
	   			enforceMaxLength :true,
		        name: 'DPR_YEAR',
		        fieldStyle:'text-align : center;',
		        allowBlank:false,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('DPR_YEAR', newValue);
					}
				}
	        },Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
		    	valueFieldName: 'ACCNT',
		    	textFieldName: 'ACCNT_NAME',
		    	validateBlank: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT', records[0]['ACCNT_CODE']);
							panelSearch.setValue('ACCNT_NAME',  records[0]['ACCNT_NAME']);				 																							
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
		        fieldLabel: '사업장',
			    name:'ACCNT_DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
//			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
		    }
		]
	});
	
	var masterGrid = Unilite.createGrid('aisc115skrvGrid', {
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
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns:  [
        	{ dataIndex: 'ASST',			width: 80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
			}},
        	{ dataIndex: 'ASST_NAME',		width: 170},
        	{ dataIndex: 'ACCNT',			width: 70, align:'center'},
        	{ dataIndex: 'ACCNT_NAME',		width: 100},
        	{ dataIndex: 'ACQ_DATE',		width: 70},
        	{ dataIndex: 'DRB_YEAR',		width: 70},
        	{ dataIndex: 'ACQ_AMT_I',		width: 100, summaryType:'sum'},
        	{ dataIndex: 'DPR_YYMM_1',		width: 80, summaryType:'sum'},
        	{ dataIndex: 'DPR_YYMM_2',		width: 80, summaryType:'sum'},
        	{ dataIndex: 'DPR_YYMM_3',		width: 80, summaryType:'sum'},
        	{ dataIndex: 'DPR_YYMM_4',		width: 80, summaryType:'sum'},
        	{ dataIndex: 'DPR_YYMM_5',		width: 80, summaryType:'sum'},
        	{ dataIndex: 'DPR_YYMM_6',		width: 80, summaryType:'sum'},
        	{ dataIndex: 'DPR_YYMM_7',		width: 80, summaryType:'sum'},
        	{ dataIndex: 'DPR_YYMM_8',		width: 80, summaryType:'sum'},
        	{ dataIndex: 'DPR_YYMM_9',		width: 80, summaryType:'sum'},
        	{ dataIndex: 'DPR_YYMM_10',		width: 80, summaryType:'sum'},
        	{ dataIndex: 'DPR_YYMM_11',		width: 80, summaryType:'sum'},
        	{ dataIndex: 'DPR_YYMM_12',		width: 80, summaryType:'sum'},
        	{ dataIndex: 'TM_DPR_TOT_I',	width: 100, summaryType:'sum'},
        	{ dataIndex: 'TM_BALN_I',		width: 100, summaryType:'sum'},
        	{ dataIndex: 'GOV_ACQ_AMT_I',	width: 100, summaryType:'sum'},
        	{ dataIndex: 'GOV_DPR_YYMM_1',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_DPR_YYMM_2',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_DPR_YYMM_3',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_DPR_YYMM_4',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_DPR_YYMM_5',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_DPR_YYMM_6',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_DPR_YYMM_7',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_DPR_YYMM_8',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_DPR_YYMM_9',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_DPR_YYMM_10',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_DPR_YYMM_11',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_DPR_YYMM_12',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_TM_DPR_TOT_I',	width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'YRDPRI_GOV_DPR_TOT_I',width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'GOV_TM_BALN_I',		width: 100, summaryType:'sum', hidden : !useGovGrantCont},
        	{ dataIndex: 'BALNDPRI_GOV_BALN_I',	width: 120, summaryType:'sum', hidden : !useGovGrantCont}
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
		 id  : 'aisc115skrvApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			
			if(getStDt && getStDt.length > 0 && getStDt[0].STDT ){
				panelSearch.setValue('DPR_YEAR', getStDt[0].STDT.substring(0,4));
				panelResult.setValue('DPR_YEAR', getStDt[0].STDT.substring(0,4));
			}
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);

			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.getField('DPR_YEAR').focus();	

			this.processParams(params);
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			
			masterGrid.getStore().loadStoreRecords();
		},
        //링크로 넘어오는 params 받는 부분 (aisc105skrv)
        processParams: function(params) {
			
		}
	});

};
</script>
