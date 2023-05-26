<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aisc125skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A038" /> <!-- 상각상태-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {   
var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aisc125skrvModel', {
	    fields: [  	  
	    	{name: 'ACCNT'   				, text: '계정코드' 				,type: 'string'},
		    {name: 'ACCNT_NAME'				, text: '계정과목'					,type: 'string'},
		    {name: 'ACQ_AMT_I'				, text: '취득가액' 				,type: 'uniPrice'},
		    {name: 'BA_BALN_I'				, text: '기초잔액'					,type: 'uniPrice'},
		    {name: 'CT_INCREASE_I'			, text: '당기증가액'				,type: 'uniPrice'},
		    {name: 'CT_REDUCE_I'			, text: '당기장부감소액'				,type: 'uniPrice'},
		    {name: 'ASST_VARI_AMT_I'		, text: '재평가후자산증감'			,type: 'uniPrice'},
		    {name: 'CT_BALN_I'				, text: '기말잔액'					,type: 'uniPrice'},
		    {name: 'PT_DPR_TOT_I'			, text: '전기말상각누계액'			,type: 'uniPrice'},
		    {name: 'CT_DPR_I'				, text: '당기상각액'				,type: 'uniPrice'},
		    {name: 'CT_DPR_REDUCE_I'		, text: '당기상각감소액'				,type: 'uniPrice'},
		    {name: 'CT_DPR_TOT_I'			, text: '당기말상각누계액'			,type: 'uniPrice'},
		    {name: 'CT_DMGLOS_TOT_I'		, text: '당기말손상차손누계액'			,type: 'uniPrice'},
		    {name: 'FL_BALN_I'				, text: '미상각잔액'				,type: 'uniPrice'}
		]          
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('aisc125skrvMasterStore',{
		model: 'aisc125skrvModel',
		uniOpt: {
            isMaster: 	true,			// 상위 버튼 연결 
            editable:	false,			// 수정 모드 사용 
            deletable:	false,			// 삭제 가능 여부 
	        useNavi	:	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'aisc125skrvService.selectList'                	
            }
        },
        loadStoreRecords: function() {
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
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    		masterGrid.focus();
				//조회된 데이터가 없을 때, 합계 안 보이게 설정 / 패널의 첫번째 필드에 포커스 가도록 변경
				}else{
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);	
					var activeSForm ;		
					if(!UserInfo.appOption.collapseLeftSearch)	{	
						activeSForm = panelSearch;	
					}else {		
						activeSForm = panelResult;	
					}		
					activeSForm.onLoadSelectText('DPR_YYMM_FR');		
				}
          	}          		
      	}
//			groupField: 'SUM'
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
		    items: [{ 
				fieldLabel: '상각년월',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'DPR_YYMM_FR',
		        endFieldName: 'DPR_YYMM_TO',
//		        width: 470,
		        allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DPR_YYMM_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DPR_YYMM_TO',newValue);
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
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
		    }]			
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '상각년월',
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'DPR_YYMM_FR',
	        endFieldName: 'DPR_YYMM_TO',
	        //width: 470,
	        allowBlank: false,
			tdAttrs: {width: 380},  
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('DPR_YYMM_FR',newValue);
                	}
			    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DPR_YYMM_TO',newValue);
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
//		    width: 325,
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
				panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
     		}
		}]
	});
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aisc125skrvGrid', {
    	layout : 'fit',
        region : 'center',
        store : MasterStore, 
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
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary',	showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  		showSummaryRow: false} ],
        columns: [        
			{dataIndex: 'ACCNT'   				, width: 53,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
				}
			},
			{dataIndex: 'ACCNT_NAME'			, width: 120},
			{dataIndex: 'ACQ_AMT_I'				, width: 120, 	summaryType: 'sum'},
			{dataIndex: 'BA_BALN_I'				, width: 120, 	summaryType: 'sum'},
			{dataIndex: 'CT_INCREASE_I'			, width: 120, 	summaryType: 'sum'},
			{dataIndex: 'CT_REDUCE_I'			, width: 120, 	summaryType: 'sum'},
			{dataIndex: 'ASST_VARI_AMT_I'		, width: 120, 	summaryType: 'sum'},
			{dataIndex: 'CT_BALN_I'				, width: 120, 	summaryType: 'sum'},
			{dataIndex: 'PT_DPR_TOT_I'			, width: 120, 	summaryType: 'sum'},
			{dataIndex: 'CT_DPR_I'				, width: 120, 	summaryType: 'sum'},
			{dataIndex: 'CT_DPR_REDUCE_I'		, width: 120, 	summaryType: 'sum'},
			{dataIndex: 'CT_DPR_TOT_I'			, width: 120, 	summaryType: 'sum'},
			{dataIndex: 'CT_DMGLOS_TOT_I'		, width: 150, 	summaryType: 'sum'},
			{dataIndex: 'FL_BALN_I'				, width: 120, 	summaryType: 'sum'}
		] ,
		listeners: {
	      	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
    		},
    		onGridDblClick:function(grid, record, cellIndex, colName, td)   {
    			grid.ownerGrid.gotoAsc105skr(record);
            }
		},
	
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
  			return true;
  		},
        uniRowContextMenu:{
			items: [{
            	text: '감가상각비명세서  보기',   
            	itemId	: 'linkAsc105skr',
            	handler: function(menuItem, event) {
            		var record	= masterGrid.getSelectedRecord();
					
            		masterGrid.gotoAsc105skr(record);
            	}
        	}]
	    },
		gotoAsc105skr :function(record)	{
			if(record)	{
				var params	= {
					'PGM_ID'		:	'aisc125skrv',
					'ACCNT'			:	record.data['ACCNT'],
					'ACCNT_NAME'	:	record.data['ACCNT_NAME'],
					'ACCNT_DIV_CODE':	panelSearch.getValue('ACCNT_DIV_CODE'),						//월까지만 넘기고, 상세내역조회에서도 월로 받아 조회
					'DVRY_DATE_FR'	:	panelSearch.getValue('DPR_YYMM_FR'),
					'DVRY_DATE_TO'	:	panelSearch.getValue('DPR_YYMM_TO')
				};
			}
	  		var rec1 = {data : {prgID : 'aisc105skrv', 'text':''}};							
			parent.openTab(rec1, '/accnt/aisc105skrv.do', params);
    	}             	        
    });                          
    
	 Unilite.Main( {
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
		id : 'aisc125skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DPR_YYMM_FR',[getStDt[0].STDT]);
			panelSearch.setValue('DPR_YYMM_TO',[getStDt[0].TODT]);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DPR_YYMM_FR',[getStDt[0].STDT]);
			panelResult.setValue('DPR_YYMM_TO',[getStDt[0].TODT]);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);

			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('DPR_YYMM_FR');	
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{		
			masterGrid.reset();
			MasterStore.clearData();

			var viewNormal = masterGrid.getView();
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);		

		    masterGrid.getStore().loadStoreRecords();
		    }
		}
	});
};

</script>
