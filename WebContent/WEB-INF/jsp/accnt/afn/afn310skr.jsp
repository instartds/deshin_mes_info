<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afn310skr"  >
    <t:ExtComboStore comboType="BOR120"  />                         <!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afn310skrModel', {
	    fields: [  	  
	             {name: 'COMP_CODE'          ,text: 'COMP_CODE'     ,type: 'string', allowBlank: false},  
	             {name: 'LOANNO'             ,text: '차입금코드'    ,type: 'string', allowBlank: false},  
	             {name: 'LOAN_NAME'          ,text: '차입금명'      ,type: 'string', allowBlank: false},  
	             {name: 'PUB_DATE'           ,text: '차입일자'      ,type: 'uniDate', allowBlank: false},  
	             {name: 'DIV_CODE'           ,text: 'DIV_CODE'      ,type: 'string'     ,comboType: 'BOR120'}
		]         	
	});
	
	
	Unilite.defineModel('Afn310skrModel2', {
	    fields: [  	  
                 {name: 'BLN_DATE'           ,text: '결산기준일'    ,type: 'uniDate'},
                 {name: 'BLN_DAY_CNT'        ,text: '결산일수'      ,type: 'string'},
                 {name: 'BASE_DATE'          ,text: '이자지급일'    ,type: 'uniDate'},
                 {name: 'DAY_CNT'            ,text: '이자일수'      ,type: 'string'},
                 {name: 'TREAT_TYPE'         ,text: '처리유형'      ,type: 'string'     ,comboType: "AU", comboCode: "A369"},
                 {name: 'PUB_AMT'            ,text: '발행액'     ,type: 'uniPrice'},
                 {name: 'EX_REPAY_AMT'       ,text: '만기상환액'     ,type: 'uniPrice'},
                 {name: 'CASH_INT'           ,text: '현금이자'      ,type: 'uniPrice'},
                 {name: 'CASH_FLOW'          ,text: '현금흐름'      ,type: 'string'},
                 {name: 'SEQ'                ,text: '순번'        ,type: 'string'},
                 {name: 'EX_DATE'            ,text: '결의일자'      ,type: 'uniDate'},
                 {name: 'EX_NUM'             ,text: '번호'        ,type: 'string'}
		]         	
	});
		  
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'afn310skrService.selectList1'
        }
	});
	
	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'afn310skrService.selectList2'
        }
	});  
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('afn310skrMasterStore1',{
		model: 'Afn310skrModel',
		uniOpt: {
            isMaster: true,		// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directMasterProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success)	{
						UniAppManager.setToolbarButtons('newData', false);
					}
				}
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var config = {
					params:[panelSearch.getValues()],
					success : function()	{
						if(directDetailStore.isDirty())	{
							directDetailStore.saveStore();						
						}
					}
				}
				this.syncAllDirect(config);			
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
           		if(records != null && records.length > 0 ){
           			UniAppManager.setToolbarButtons('delete', true);
           		}//else{
           		    //alert("데이타없음.");
                    //directDetailStore.loadStoreRecords();                    
                //    }
			}
		}
	});
	
	var directDetailStore = Unilite.createStore('afn310skrMasterStore2',{
		model: 'Afn310skrModel2',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directDetailProxy,
        loadStoreRecords: function(record) {
      
			var searchParam= Ext.getCmp('searchForm').getValues();
//            var param = null;

    //if ( record.length > 0 ) {
        var param = {'LOANNO' : record.get( 'LOANNO' ) };
    //                } else {
    //                    param = {'LOANNO' : 'X' };
    //                }

                    var params = Ext.merge( searchParam, param );
                    console.log( param );
                    this.load( {params : params, callback : function( records,
                        options, success ) {
                        if ( success ) {
                            UniAppManager.setToolbarButtons( 'delete', false );
                        }
                    } } );
                }, saveStore : function() {
                    var inValidRecs = this.getInvalidRecords();

                    if ( inValidRecs.length == 0 ) {
                        var config = {params : [
                            panelSearch.getValues()
                        ], success : function() {
                        } }
                        this.syncAllDirect( config );
                    } else {
                        detailGrid.uniSelectInvalidColumnAndAlert( inValidRecs );
                    }

                }, listeners : {load : function( store, records, successful,
                    eOpts ) {
                    if ( records != null && records.length > 0 ) {
                        UniAppManager.setToolbarButtons( 'delete', true );
                    }
                } } } );

        /**
         * 검색조건 (Search Panel)
         * @type 
         */
        var panelSearch = Unilite
            .createSearchPanel(
                'searchForm',
                {title : '검색조건', defaultType : 'uniSearchSubPanel', collapsed : UserInfo.appOption.collapseLeftSearch, listeners : {collapse : function() {
                    panelResult.show();
                }, expand : function() {
                    panelResult.hide();
                } }, items : [
                    {title : '기본정보', itemId : 'search_panel1', layout : {type : 'uniTable', columns : 1 }, defaultType : 'uniTextfield', items : [
                    Unilite
                        .popup(
                            'DEBT_NO',
                            {fieldLabel : '차입금번호', validateBlank : false, valueFieldName : 'DEBT_NO_CODE', textFieldName : 'DEBT_NO_NAME', listeners : {onSelected : {fn : function(
                                records, type ) {
                                panelResult.setValue( 'DEBT_NO_CODE',
                                    panelSearch.getValue( 'DEBT_NO_CODE' ) );
                                panelResult.setValue( 'DEBT_NO_NAME',
                                    panelSearch.getValue( 'DEBT_NO_NAME' ) );
                            }, scope : this }, onClear : function( type ) {
                                panelResult.setValue( 'DEBT_NO_CODE', '' );
                                panelResult.setValue( 'DEBT_NO_NAME', '' );
                            } } } ), {fieldLabel : '사업장', name : 'DIV_CODE', xtype : 'uniCombobox', value : UserInfo.divCode, comboType : 'BOR120', multiSelect : true, typeAhead : false, listeners : {change : function(
                        field, newValue, oldValue, eOpts ) {
                        panelResult.setValue( 'DIV_CODE', newValue );
                    } } }
                    ] }
                ]

                } );

        var panelResult = Unilite
            .createSearchForm(
                'resultForm',
                {region : 'north', hidden : !UserInfo.appOption.collapseLeftSearch, layout : {type : 'uniTable', columns : 3 }, padding : '1 1 1 1', border : true, items : [
                Unilite
                    .popup(
                        'DEBT_NO',
                        {fieldLabel : '차입금번호', valueFieldName : 'DEBT_NO_CODE', textFieldName : 'DEBT_NO_NAME', tdAttrs : {width : 380 }, listeners : {onSelected : {fn : function(
                            records, type ) {
                            panelSearch.setValue( 'DEBT_NO_CODE', panelResult
                                .getValue( 'DEBT_NO_CODE' ) );
                            panelSearch.setValue( 'DEBT_NO_NAME', panelResult
                                .getValue( 'DEBT_NO_NAME' ) );

                        }, scope : this }, onClear : function( type ) {
                            panelSearch.setValue( 'DEBT_NO_CODE', '' );
                            panelSearch.setValue( 'DEBT_NO_NAME', '' );
                        }, applyextparam : function( popup ) {

                        } } } ), {fieldLabel : '사업장', name : 'DIV_CODE', xtype : 'uniCombobox', value : UserInfo.divCode, comboType : 'BOR120', tdAttrs : {width : 380 }, multiSelect : true, typeAhead : false, listeners : {change : function(
                    field, newValue, oldValue, eOpts ) {
                    panelSearch.setValue( 'DIV_CODE', newValue );
                } } }
                ] } );

        /**
         * Master Grid1 정의(Grid Panel)
         * @type 
         */

        var masterGrid = Unilite
            .createGrid(
                'afn310skrGrid1',
                {region : 'center', enableColumnMove : false, store : directMasterStore, uniOpt : {expandLastColumn : false, useRowNumberer : true }, itemId : 'masterGrid', columns : [
                {dataIndex : 'LOANNO', width : 100 }, {dataIndex : 'LOAN_NAME', width : 150 }, {dataIndex : 'PUB_DATE', width : 120 }, {dataIndex : 'COMP_CODE', width : 80, hidden : true }, {dataIndex : 'DIV_CODE', width : 80, hidden : true }
                ], features : [
                {id : 'masterGridSubTotal', ftype : 'uniGroupingsummary', showSummaryRow : false }, {id : 'masterGridTotal', ftype : 'uniSummary', showSummaryRow : false }
                ], listeners : {selectionchange : function( model1, selected,
                    eOpts ) {
                    if ( selected.length == 1 ) {
                        var record = selected[0];
                        directDetailStore.loadStoreRecords( record );
                    }
                } } } );

        /**
         * Master Grid2 정의(Grid Panel)
         * @type 
         */

        var detailGrid = Unilite
            .createGrid(
                'afn310skrGrid2',
                {enableColumnMove : false, itemId : 'detailGrid', store : directDetailStore, uniOpt : {expandLastColumn : false, }, columns : [

                {dataIndex : 'BLN_DATE', width : 100 }, {dataIndex : 'BLN_DAY_CNT', width : 100 }, {dataIndex : 'BASE_DATE', width : 100 }, {dataIndex : 'DAY_CNT', width : 100 }, {dataIndex : 'TREAT_TYPE', width : 100 }, {dataIndex : 'PUB_AMT', width : 120 }, {dataIndex : 'EX_REPAY_AMT', width : 120 }, {dataIndex : 'CASH_INT', width : 120 }, {dataIndex : 'CASH_FLOW', width : 120 }, {dataIndex : 'SEQ', width : 66 }, {dataIndex : 'EX_DATE', width : 100 }, {dataIndex : 'EX_NUM', width : 100 }
                ] } );

        Unilite
            .Main( {
            //grid 나누는 부분
            items : [
            panelResult, {xtype : 'container', flex : 1, layout : 'border', defaults : {collapsible : false, split : true }, items : [
            {region : 'center', xtype : 'container', layout : 'fit', items : [
                masterGrid
            ] }, {region : 'east', xtype : 'container', layout : 'fit', flex : 3, items : [
                detailGrid
            ] }, panelSearch
            ]

            }
            ], id : 'afn310skrApp', fnInitBinding : function() {
                UniAppManager.setToolbarButtons( 'detail', false );
                UniAppManager.setToolbarButtons( 'reset', false );

                //첫화면 로딩시, 검색조건 초기화
                var activeSForm;
                if ( !UserInfo.appOption.collapseLeftSearch ) {
                    activeSForm = panelSearch;
                } else {
                    activeSForm = panelResult;
                }
                panelSearch.setValue( 'DIV_CODE', UserInfo.divCode );
            }, onQueryButtonDown : function() {
                masterGrid.reset();
                detailGrid.reset();
                directMasterStore.loadStoreRecords();
            }

            } );

    };
</script>
