<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aha996skr"  >
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     

	Unilite.defineModel('aha996skrModel', {
	    fields: [  	  
	    	{name: 'COMP_CODE'			, text: '법인코드'   , type: 'string'},
            {name: 'PAY_YYYYMM'         , text: '귀속년월'   , type: 'string'},
            {name: 'GUBUN'              , text: '소득구분'   , type: 'string'},
            {name: 'PAY_AMOUNT_I'       , text: '총지급액'   , type: 'uniPrice'},
            {name: 'SUPP_TOTAL_I'       , text: '소득금액'   , type: 'uniPrice'},
            {name: 'IN_TAX_I'           , text: '소득세'    , type: 'uniPrice'},
            {name: 'LOCAL_TAX_I'        , text: '주민세'    , type: 'uniPrice'},
            {name: 'AGB_IN_TAX_AMT_I'   , text: '소득세'    , type: 'uniPrice'},
            {name: 'AGB_LOCAL_TAX_I'    , text: '주민세'    , type: 'uniPrice'},
            {name: 'DIFF_IN_TAX_I'      , text: '소득세'    , type: 'uniPrice'},
            {name: 'DIFF_LOC_TAX_I'     , text: '주민세'    , type: 'uniPrice'},
            {name: 'HPA950_SUPP_TOT_I'  , text: '총지급액'   , type: 'uniPrice'},
            {name: 'HPA950_IN_TAX_I'    , text: '소득세'    , type: 'uniPrice'},
            {name: 'DIFF_HPA_IN_TAX_I'  , text: '총지급액'   , type: 'uniPrice'},
            {name: 'DIFF_HPA_LOC_TAX_I' , text: '소득세'    , type: 'uniPrice'}	    
	    ]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */	
	  
	var directMasterStore = Unilite.createStore('aha996skrMasterStore',{
		model: 'aha996skrModel',
		uniOpt: {
			isMaster: true,				// 상위 버튼 연결 
        	editable: false,				// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'aha996skrService.selectList'                	
            }
        },
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	}   	
		},		 
		loadStoreRecords : function()	{
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
	   }
	}); 

	var searchForm = Unilite.createForm('searchForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        disabled:false,
        items: [{
            fieldLabel: '귀속년월',
            xtype: 'uniMonthRangefield',
            startFieldName: 'PAY_YYYYMM_FR',
            endFieldName: 'PAY_YYYYMM_TO',                  
            value: new Date(),                    
            allowBlank: false
        },{
            fieldLabel: '지급년월',
            xtype: 'uniMonthRangefield',
            startFieldName: 'SUPP_YYYYMM_FR',
            endFieldName: 'SUPP_YYYYMM_TO',                  
            value: new Date(),                    
            allowBlank: false
        }]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aha996skrGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore, 
        uniOpt:{
			useRowNumberer: true
        },
        selModel:'rowmodel',
        columns: [
			{dataIndex: 'COMP_CODE'			,  width: 100 ,hidden:true},
            {dataIndex: 'PAY_YYYYMM'        ,  width: 100 ,hidden:true},
            {dataIndex: 'GUBUN'             ,  width: 150 },
            {
                text:'HR 및 원천데이터정보',
                columns:[
                    {dataIndex: 'PAY_AMOUNT_I'      ,  width: 100 },
                    {dataIndex: 'SUPP_TOTAL_I'      ,  width: 100 },
                    {dataIndex: 'IN_TAX_I'          ,  width: 100 },
                    {dataIndex: 'LOCAL_TAX_I'       ,  width: 100 }
                ]
            },
            {
                text:'보조부금액',
                columns:[
                    {dataIndex: 'AGB_IN_TAX_AMT_I'  ,  width: 100 },
                    {dataIndex: 'AGB_LOCAL_TAX_I'   ,  width: 100 }
                ]
            },
            {
                text:'차액(원천-보조부)',
                columns:[
                    {dataIndex: 'DIFF_IN_TAX_I'     ,  width: 100 },
                    {dataIndex: 'DIFF_LOC_TAX_I'    ,  width: 100 }
                ]
            },
            {
                text:'원천세신고자료',
                columns:[
                    {dataIndex: 'HPA950_SUPP_TOT_I' ,  width: 100 },
                    {dataIndex: 'HPA950_IN_TAX_I'   ,  width: 100 }
                ]
            },
            {
                text:'차액(원천-신고자료)',
                columns:[
                    {dataIndex: 'DIFF_HPA_IN_TAX_I' ,  width: 100 },
                    {dataIndex: 'DIFF_HPA_LOC_TAX_I',  width: 100 }
                ]
            }
		] ,
		listeners: {
            onGridDblClick :function( grid, record, cellIndex, colName ) {
            	alert('빌드중');
            	
                //진짜
//                var linkFlag    = record.data['ATTRIBUTE3'];
                //테스트용
//              var linkFlag    = record.data['ELEC_SLIP_TYPE_NM'];

              /*  if (linkFlag == '법인카드'){
                    masterGrid.gotoAep100ukr(record);
                    
                } else if (linkFlag == '실물증빙') {
                    masterGrid.gotoAep110ukr(record);

                } else if (linkFlag == '세금계산서') {
                    masterGrid.gotoAep120ukr(record);
                
                } else if (linkFlag == '전자세금계산서업로드') {
                    masterGrid.gotoAep130ukr(record);
                
                } else if (linkFlag == '전자세금계산서') {
                    masterGrid.gotoAep140ukr(record);
                    
                }else if (linkFlag == '원천세') {
                    masterGrid.gotoAep150ukr(record);
                
                } else if (linkFlag == '원천세-원고료') {
                    masterGrid.gotoAep160ukr(record);
                    
                } else if (linkFlag == '원천세-인세') {
                    masterGrid.gotoAep170ukr(record);
                }*/
            }
        }
        /*gotoAep100ukr:function(record)  {
            var param = {
                'PGM_ID'            : 'aep200skr',
                'ELEC_SLIP_NO'      : record.data['ELEC_SLIP_NO']
            };
            var rec1 = {data : {prgID : 'aep100ukr', 'text': ''}};                          
            parent.openTab(rec1, '/jbill/aep100ukr.do', param, CHOST+CPATH);
        },
        gotoAep110ukr:function(record)  {
            var param = {
                'PGM_ID'            : 'aep200skr',
                'ELEC_SLIP_NO'      : record.data['ELEC_SLIP_NO'],
                'INVOICE_DATE'      : record.data['INVOICE_DATE']
            };
            var rec1 = {data : {prgID : 'aep110ukr', 'text': ''}};                          
            parent.openTab(rec1, '/jbill/aep110ukr.do', param, CHOST+CPATH);
        },
        gotoAep120ukr:function(record)  {
            var param = {
                'PGM_ID'            : 'aep200skr',
                'ELEC_SLIP_NO'      : record.data['ELEC_SLIP_NO'],
                'INVOICE_DATE'      : record.data['INVOICE_DATE']
            };
            var rec1 = {data : {prgID : 'aep120ukr', 'text': ''}};                          
            parent.openTab(rec1, '/jbill/aep120ukr.do', param, CHOST+CPATH);
        },
        gotoAep130ukr:function(record)  {
            var param = {
                'PGM_ID'            : 'aep200skr',
                'ELEC_SLIP_NO'      : record.data['ELEC_SLIP_NO'],
                'INVOICE_DATE'      : record.data['INVOICE_DATE']
            };
            var rec1 = {data : {prgID : 'aep130ukr', 'text': ''}};                          
            parent.openTab(rec1, '/jbill/aep130ukr.do', param, CHOST+CPATH);
        },
        gotoAep140ukr:function(record)  {
            var param = {
                'PGM_ID'            : 'aep200skr',
                'ELEC_SLIP_NO'      : record.data['ELEC_SLIP_NO']
            };
            var rec1 = {data : {prgID : 'aep140ukr', 'text': ''}};                          
            parent.openTab(rec1, '/jbill/aep140ukr.do', param, CHOST+CPATH);
        },
        gotoAep150ukr:function(record)  {
            var param = {
                'PGM_ID'            : 'aep200skr',
                'ELEC_SLIP_NO'      : record.data['ELEC_SLIP_NO'],
                'INVOICE_DATE'      : record.data['INVOICE_DATE']
            };
            var rec1 = {data : {prgID : 'aep150ukr', 'text': ''}};                          
            parent.openTab(rec1, '/jbill/aep150ukr.do', param, CHOST+CPATH);
        },
        gotoAep160ukr:function(record)  {
            var param = {
                'PGM_ID'            : 'aep200skr',
                'ELEC_SLIP_NO'      : record.data['ELEC_SLIP_NO'],
                'INVOICE_DATE'      : record.data['INVOICE_DATE']
            };
            var rec1 = {data : {prgID : 'aep160ukr', 'text': ''}};                          
            parent.openTab(rec1, '/jbill/aep160ukr.do', param, CHOST+CPATH);
        },
        gotoAep170ukr:function(record)  {
            var param = {
                'PGM_ID'            : 'aep200skr',
                'ELEC_SLIP_NO'      : record.data['ELEC_SLIP_NO'],
                'INVOICE_DATE'      : record.data['INVOICE_DATE']
            };
            var rec1 = {data : {prgID : 'aep170ukr', 'text': ''}};                          
            parent.openTab(rec1, '/jbill/aep170ukr.do', param, CHOST+CPATH);
        }*/
    });
        
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
                masterGrid, searchForm
			]
		}],
		id  : 'aha996skrApp',
		fnInitBinding : function() {
			searchForm.setValue('PAY_YYYYMM_FR',UniDate.get('today'));
			searchForm.setValue('PAY_YYYYMM_TO',UniDate.get('today'));
			searchForm.setValue('SUPP_YYYYMM_FR',UniDate.get('today'));
            searchForm.setValue('SUPP_YYYYMM_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons(['save'] , false);
			
		},
		onQueryButtonDown : function()	{
            if(!searchForm.getInvalidMessage()){
                return false;
            }
            directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			searchForm.clearForm();
		
			masterGrid.reset();
            directMasterStore.clearData();
		
			this.fnInitBinding();
		}
	});
};


</script>
