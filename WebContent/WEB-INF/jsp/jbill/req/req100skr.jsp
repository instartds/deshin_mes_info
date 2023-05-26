<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
// http://accnt.joins.net/jbill/req/req100skr.do?COMP_CODE=F20&KEY_VALUE=F201020161230140456630128
%>
<meta name="decorator" content="jbill_gw"/>
<script type="text/javascript" >
document.title = "전자결재 - 결재 문서 VIEW";
function appMain() {
	
    /**
     *   Model 정의 
     * @type 
     */

    Unilite.defineModel('req100skrModel', {
        fields: [
			 
            {name: 'RNUM'           	, text: '순번'      , type: 'string'},
            {name: 'COMP_CODE'          , text: '법인코드'  , type: 'string'},
            
            {name: 'IF_APPR_MANAGE_NO'     , text: '문서번호'  , type: 'string'},
            {name: 'ELEC_SLIP_NO'       , text: '전표번호'  , type: 'string'},
            {name: 'ELEC_SLIP_TYPE_NM'	, text: '전표유형'  , type: 'string'},
           
            {name: 'INVOICE_DATE'       , text: '증빙일자'  , type: 'uniDate'},
            {name: 'GL_DATE'          	, text: '회계일자'  , type: 'uniDate'},
            
            {name: 'INVOICE_AMT'        , text: '총금액'    , type: 'uniPrice'},
            {name: 'VENDOR_NM'         	, text: '거래처명'  , type: 'string'},
            {name: 'SLIP_DESC'         	, text: '사용내역'  , type: 'string'},
            {name: 'REG_DEPT_NM'        , text: '작성부서'  , type: 'string'},
            {name: 'REG_NM'         	, text: '작성자'    , type: 'string'},
            {name: 'REG_DT'         	, text: '등록일자'	, type: 'uniDate'}
           
        ]
    });
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var masterStore = Unilite.createStore('req999skrStore', {
        model: 'req100skrModel',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        data:{'records':${jsonData}},
        autoLoad: true,
        proxy: {
        	type: 'memory',
	        reader: {
	            type: 'json',
	            rootProperty: 'records'
	        }
	    }
    }); 
   
    var masterGrid = Unilite.createGrid('req999skrSearchGrid', {
//      split:true,
        layout: 'fit',
        region: 'center',
        excelTitle: '',
//        height:250,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: false,
            useContextMenu: false,
            useMultipleSorting: false,
            onLoadSelectFirst: false,
            useRowNumberer: false,
            expandLastColumn: false,
            useRowContext: false,
            state: {
                useState: false,         
                useStateList: false      
            },
            userToolbar :false
        },
        
        store: masterStore,
		features: [ {id : 'masterGridTotal', 	ftype: 'uniSummary',  dock:'bottom',	  showSummaryRow: true} ],
       
        selModel:'rowmodel',
        columns: [
          	{dataIndex: 'RNUM',          	width: 66, align:'center'},
            //{dataIndex: 'IF_APPR_MANAGE_NO',            width: 130},
            //{dataIndex: 'ELEC_SLIP_NO',            width: 130},
            {dataIndex: 'ELEC_SLIP_TYPE_NM',            width: 100},
            {dataIndex: 'INVOICE_DATE',            width: 100},
            {dataIndex: 'GL_DATE',            width: 100,	
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '합계', '합계');
		    	}
		    },
            {dataIndex: 'INVOICE_AMT',            width: 100,  summaryType: 'sum'},
            {dataIndex: 'VENDOR_NM',           width: 130},
            {dataIndex: 'SLIP_DESC',           width: 200},
            {dataIndex: 'REG_DEPT_NM',           width: 100},
            {dataIndex: 'REG_NM',           width: 100},
            {dataIndex: 'REG_DT',           minWidth: 100}
            
        ],
        listeners: { 
            onGridDblClick: function(grid, record, cellIndex, colName) {
            	var url = './req101skr.do?IF_CORP_CODE='+record.get('COMP_CODE')+"&IF_APPR_MANAGE_NO="+record.get('IF_APPR_MANAGE_NO');
            	window.open(url,"_blank ","width=730,height=500.location=yes,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no");
            }
        }
    });   

    
    Ext.create('Ext.Viewport',  {
     	xtype:'container',
        title : 'OMEGAPlus',
        defaults:{
            collapsible: false
        },
    	items:[
    		masterGrid
    	],
    	renderTo : Ext.getBody()
    });

};

</script>