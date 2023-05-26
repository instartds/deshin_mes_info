<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aisc126skrv"  >
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
	Unilite.defineModel('aisc126skrvModel', {
	    fields: [  	  
	    	{name: 'ACCNT'   				, text: '계정코드' 				,type: 'string'},
		    {name: 'ACCNT_NAME'				, text: '계정과목'					,type: 'string'},
		    {name: 'ACQ_AMT_I'				, text: '실취득가액'				,type: 'uniPrice'},
		    
		    
		    /* 상각대상금액 ↓
             * BA_BALN_I
             * CT_INCREASE_I
             * CT_REDUCE_I 
             * PT_DPR_TOT_I 
             * PT_DMGLOS_TOT_I
             * CT_BALN_I       
             */
            {name: 'BA_BALN_I'              , text: '취득가액(a)'             ,type: 'uniPrice'},
		    {name: 'CT_INCREASE_I'			, text: '당기증가액(b)'				,type: 'uniPrice'},
		    {name: 'CT_REDUCE_I'			, text: '당기감소액(c)'				,type: 'uniPrice'},
		    {name: 'ASST_VARI_AMT_I'        , text: '재평가후자산증감'           ,type: 'uniPrice'},
//		    {name: 'ASST_VARI_AMT_I'		, text: '재평가후자산증감'			,type: 'uniPrice'},
//		    {name: 'CT_BALN_I'				, text: '기말잔액'					,type: 'uniPrice'},
		    {name: 'PT_DPR_TOT_I'			, text: '충당금누계액(d)'		  	,type: 'uniPrice'},
		    {name: 'PT_DMGLOS_TOT_I'        , text: '손상차손누계액(e)'          ,type: 'uniPrice'},
		    {name: 'CT_BALN_I'              , text: '미상각액(f=a+b-c-d-e)'    ,type: 'uniPrice'}, //취득가액 + 당기증가액 - 당기감소액 - 충당금누계액
		    
		    /* 상각액 ↓
             * CT_DPR_I
             * CT_DPR_TOT_I
             * CT_DMGLOS_TOT_I
             * FL_BALN_I
             */
		    {name: 'CT_DPR_I'				, text: '당기상각액(g)'				,type: 'uniPrice'},
//		    {name: 'CT_DPR_REDUCE_I'		, text: '당기상각감소액'				,type: 'uniPrice'},
		    {name: 'CT_DPR_TOT_I'			, text: '당기말충당금(h=d+g)'			,type: 'uniPrice'},
		    {name: 'CT_DMGLOS_TOT_I'		, text: '당기말손상차손누계액(i)'		,type: 'uniPrice'},
		    {name: 'FL_BALN_I'				, text: '차기이월액(j=a+b-c-h-i)'		,type: 'uniPrice'}
		]          
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('aisc126skrvMasterStore',{
		model: 'aisc126skrvModel',
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
                read: 'aisc126skrvService.selectList'                	
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
    var masterGrid = Unilite.createGrid('aisc126skrvGrid', {
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
			{dataIndex: 'ACCNT'   				, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
				}
			},
			{dataIndex: 'ACCNT_NAME'			, width: 120},
			{dataIndex: 'ACQ_AMT_I'				, width: 120,hidden:true},
			
			
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
                    {dataIndex: 'ASST_VARI_AMT_I'   , width:120,    hidden:true},
                    {dataIndex: 'PT_DPR_TOT_I'      , width:120,    summaryType: 'sum'},
                    {dataIndex: 'PT_DMGLOS_TOT_I'   , width:130,    summaryType: 'sum'},
                    {dataIndex: 'CT_BALN_I'         , width:160,    summaryType: 'sum'}
               ]
            },
//			{dataIndex: 'ASST_VARI_AMT_I'		, width: 120, 	summaryType: 'sum'},
//			{dataIndex: 'CT_BALN_I'				, width: 120, 	summaryType: 'sum'},
			
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
            }
//			{dataIndex: 'CT_DPR_REDUCE_I'		, width: 120, 	summaryType: 'sum'},
		] ,
		listeners: {
	      	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
    		},
    		onGridDblClick:function(grid, record, cellIndex, colName) {
                masterGrid.gotoAisc106skrv(record);
            }
		},
	
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
  			return true;
  		},
        uniRowContextMenu:{
			items: [{
            	text: '감가상각비명세서  보기',   
            	itemId	: 'linkAsc106skr',
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
                    masterGrid.gotoAisc106skrv(param.record);
            	}
        	}]
	    },
		gotoAisc106skrv:function(record)	{
			if(record)	{
//				var record  = masterGrid.getSelectedRecord();
		    	var params = {
                    action:'select',
                    'PGM_ID'        :   'aisc126skrv',
                    'ACCNT'         :   record.data['ACCNT'],
                    'ACCNT_NAME'    :   record.data['ACCNT_NAME'],
                    'ACCNT_DIV_CODE':   panelSearch.getValue('ACCNT_DIV_CODE'),                    
                    'DVRY_DATE_FR'  :   panelSearch.getValue('DPR_YYMM_FR'),
                    'DVRY_DATE_TO'  :   panelSearch.getValue('DPR_YYMM_TO')
                }
			}
	  		var rec1 = {data : {prgID : 'aisc106skrv', 'text':''}};							
			parent.openTab(rec1, '/accnt/aisc106skrv.do', params);
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
		id : 'aisc126skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DPR_YYMM_FR',[getStDt[0].STDT]);
			panelSearch.setValue('DPR_YYMM_TO',[getStDt[0].TODT]);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DPR_YYMM_FR',[getStDt[0].STDT]);
			panelResult.setValue('DPR_YYMM_TO',[getStDt[0].TODT]);
			UniAppManager.setToolbarButtons(['detail','reset','save'],false);

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
