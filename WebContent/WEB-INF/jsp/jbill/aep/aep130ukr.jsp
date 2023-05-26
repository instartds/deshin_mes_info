<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep130ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J502" /> <!-- 이관취소사유 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 진행상태 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 관리구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A134" /> <!-- 결재상태 -->
    
    
    <t:ExtComboStore comboType="AU" comboCode="A177" /> <!-- 경비유형 -->
    <t:ExtComboStore comboType="AU" comboCode="A006" /> <!-- 원가구분 -->
    
    <t:ExtComboStore comboType="AU" comboCode="J518" /> <!-- 전표유형 -->
    
    
    <t:ExtComboStore comboType="AU" comboCode="J668" /> <!-- 지급방법코드 -->
    
    
  
    
    <t:ExtComboStore items="${COMBO_INDUS_CODE}" storeId="indusCodeList" />         <!--사업장-->
    
    <t:ExtComboStore items="${COMBO_DIV_CODE}" storeId="divCodeList" />         <!--사업장-->
    
    
    
    <t:ExtComboStore items="${COMBO_BUSINESS_AREA}" storeId="businessAreaList" />   <!--사업영역-->
    
    
    
    <t:ExtComboStore items="${COMBO_TAX_CD}" storeId="taxCdList" />                 <!--세금코드-->
    <t:ExtComboStore items="${COMBO_PAY_TERM_CD}" storeId="payTermCdList" />                 <!--지급조건-->
    
    <t:ExtComboStore items="${COMBO_BANK_TYPE}" storeId="bankType" />                 <!--입급계좌-->
    
    
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
//  ↑ 파일uplod용 plupload.full.js파일 include
</script>
<script type="text/javascript" >


var BsaCodeInfo = { 
	hiddenCheck_1: '${hiddenCheck_1}',
	hiddenCheck_2: '${hiddenCheck_2}',
	hiddenCheck_3: '${hiddenCheck_3}',
    hiddenCheck_4: '${hiddenCheck_4}',
    hiddenCheck_5: '${hiddenCheck_5}'
};
var personName   = '${personName}';

var buttonFlag = '';



var gsCustomCode   = '${gsCustomCode}';
var gsCustomName   = '${gsCustomName}';
var gsCompanyNum   = '${gsCompanyNum}';

var SAVE_FLAG = '';

var xmlUploadWindow; //xml업로드
function appMain() {
	
    Unilite.defineModel('aep130ukrSearchModel', {
        fields: [
            {name: 'RNUM'                   ,text: '번호'        ,type: 'string'},
            {name: 'SUP_COM_NAME'           ,text: '거래처'       ,type: 'string'},
            {name: 'SUP_COM_REGNO'          ,text: '사업자번호'    ,type: 'string'},
            {name: 'CONVERSATION_ID'        ,text: '세금계산서번호' ,type: 'string'},
            {name: 'SUP_AMOUNT'             ,text: '공급가액'     ,type: 'uniPrice'},
            {name: 'TAX_AMOUNT'             ,text: '부가세'       ,type: 'uniPrice'},
            {name: 'TOTAL_AMOUNT'           ,text: '합계금액'     ,type: 'uniPrice'},
            {name: 'ETAX_STATUS_CD'         ,text: '처리상태'     ,type: 'string'},
            {name: 'SUP_COM_CLASSIFY'       ,text: '업종'        ,type: 'string'},
            {name: 'SUP_COM_TYPE'           ,text: '업태'        ,type: 'string'},
            {name: 'TAX_DEMAND'             ,text: '영수구분'      ,type: 'string'},
            {name: 'ETAX_XML_FILE_NAME'     ,text: 'UPLOADF FILE'      ,type: 'string'}
            
        ]
    });
    
    Unilite.defineModel('aep130ukrSubModel', {
        fields: [
            {name: 'ITEM_MD_MONTH'            ,text: '월'       ,type: 'string'},
            {name: 'ITEM_MD_DAY'              ,text: '일'       ,type: 'string'},
            {name: 'ITEM_CODE'                ,text: '품목코드'   ,type: 'string'},
            {name: 'ITEM_NAME'                ,text: '품목'      ,type: 'string'},
            {name: 'ITEM_SIZE'                ,text: '규격'      ,type: 'string'},
            {name: 'ITEM_QTY'                 ,text: '수량'      ,type: 'uniQty'},
            {name: 'UNIT_PRICE'               ,text: '단가'      ,type: 'uniUnitPrice'},
            {name: 'SUP_AMOUNT'               ,text: '공급가액'   ,type: 'uniPrice'},
            {name: 'TAX_AMOUNT'               ,text: '세액'      ,type: 'uniPrice'},
            {name: 'REMARK'                   ,text: '비고'      ,type: 'string'}
        ]
    });
    

    var directSearchStore = Unilite.createStore('aep130ukrSearchStore', {
        model: 'aep130ukrSearchModel',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 'aep130ukrService.selectSearchList'                 
            }
        },
        
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('searchForm').getValues();
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
    var directSubStore = Unilite.createStore('aep130ukrSubStore', {
        model: 'aep130ukrSubModel',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 'aep130ukrService.selectSubList'                 
            }
        },
        
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('masterForm').getValues();
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
    
 /*   var subGrid = Unilite.createGrid('aep130ukrSubGrid', {
//      split:true,
        layout: 'fit',
    	width:1012,
        region: 'center',
//        height:250,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: false,
            useRowNumberer: false,
            expandLastColumn: false,
            useRowContext: false,
            state: {
                useState: true,         
                useStateList: true      
            }
        },
        features: [{
            id: 'detailGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false
        },{
            id: 'detailGridTotal', 
            ftype: 'uniSummary', 
            showSummaryRow: false
        }],
        store: directSubStore,
//        selModel:'rowmodel',
        columns: [
            { dataIndex: 'ITEM_MD_MONTH'  ,width:40,align:'center'},
            { dataIndex: 'ITEM_MD_DAY'    ,width:40,align:'center'},
            { dataIndex: 'ITEM_CODE'      ,width:120,hidden:true},
            { dataIndex: 'ITEM_NAME'      ,width:180},
            { dataIndex: 'ITEM_SIZE'      ,width:80},
            { dataIndex: 'ITEM_QTY'       ,width:80},
            { dataIndex: 'UNIT_PRICE'     ,width:80},
            { dataIndex: 'SUP_AMOUNT'     ,width:120},
            { dataIndex: 'TAX_AMOUNT'     ,width:100},
            { dataIndex: 'REMARK'         ,width:220}
            
            
        ],                  
        listeners: {
        
        
        }
    }); */
    var searchForm = Unilite.createForm('searchForm',{
//      split:true,
        region: 'north',
        layout : {type : 'uniTable', columns : 2
//            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
//          tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
    
        },
        padding:'1 1 1 1',
//        border:true,
        disabled:false,
        items: [
        	Unilite.popup('Employee',{
            fieldLabel: '사원정보', 
            valueFieldWidth: 90,
            textFieldWidth: 140,
            valueFieldName:'PERSON_NUMB',
            textFieldName:'NAME',
            readOnly:true
        }), 
        {
            xtype:'uniTextfield',
            fieldLabel:'담당자 메일',
            labelWidth:150,
            name:'',
            width:500,
            readOnly:true
        },		
        Unilite.popup('CUST',{
            fieldLabel: '거래처', 
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME'
        }),	
        {
            xtype:'uniTextfield',
            fieldLabel:'전자세금계산서번호',
            name:'CONVERSATION_ID',
            labelWidth:150,
            width:500
        },{ 
            fieldLabel: '조회기간',
            xtype: 'uniDateRangefield',
            startFieldName: 'DATE_FR',
            endFieldName: 'DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank:false
        },{
            xtype: 'uniCombobox',
            fieldLabel: '처리상태',
            labelWidth:150,
            name:'ETAX_STATUS_CD',   
            comboType:'AU',
            comboCode:'J653'
        }, 
        {
            xtype:'uniTextfield',
            fieldLabel:'',
            labelWidth:150,
            name:'CONVERSATION_IDS',
            hidden:true,
            readOnly:true
        }]
    });
    var masterForm = Unilite.createForm('masterForm',{
//        split:true,
//       title:'기본사항',
//    	flex:0.9,
        region: 'south',
        layout : {type : 'uniTable', columns : 1
//            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
//          tdAttrs: {style: 'border : 1px solid #ced9e7;',width: '100%'/*,align : 'left'*/}
    
        },
        padding:'1 1 1 1',
        border:true,
        disabled:false,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            border:true,
            padding:'1 1 1 1',
            items:[{
                xtype: 'container',
                margin: '0 0 0 0',
                layout: {type : 'uniTable', columns : 2},          
                items: [{
                    xtype: 'component',
                    width: 10
                },{
                    title: '',
                    xtype: 'fieldset',
                    id: 'fieldset1',
                    padding: '10 10 10 10',
                    margin: '0 0 0 0',
                    defaults: {readOnly: true, xtype: 'uniTextfield'},
                    layout: {type: 'uniTable' , columns: 2},
                    items: [{
                        xtype:'component',
                        html:'전자세금계산서',
//                        componentCls : 'component-text_green',
                        tdAttrs: {align : 'center'},   
                        width: 522,
                        style: {
                            marginTop: '3px !important',
                            font: '13px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
                            fontWeight:'bold'
                        }
            //            colspan:3
                    },{
                        xtype: 'uniTextfield',
                        fieldLabel:'승인번호',
                        name: 'CONVERSATION_ID',   
                        width: 490    
                    }]
                }]
            }]
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            border:true,
            padding:'1 1 1 1',
            items:[{
                xtype: 'container',
                margin: '0 0 0 0',
                layout: {type : 'uniTable', columns : 4},          
                items: [{
                    xtype: 'component',
                    width: 10
                },{
                    title: '공급자',
                    xtype: 'fieldset',
                    id: 'fieldset2',
                    padding: '0 10 10 10',
                    margin: '0 0 0 0',
                    defaults: {readOnly: true, xtype: 'uniTextfield'},
                    layout: {type: 'uniTable' , columns: 2},
                    items: [{
                        fieldLabel: '등록번호',
                        name:'SUP_COM_REGNO',   
                        width: 490,    
                        colspan:2
                    },{ 
                        fieldLabel: '상호(법인명)',
                        name: 'SUP_COM_NAME'
                    },{
                        fieldLabel: '성명(대표자)',
                        name:'SUP_REP_NAME'     
                    },{
                        fieldLabel: '사업장주소',
                        name:'SUP_COM_ADDR',     
                        width: 490,     
                        colspan: 2
                    },{
                        fieldLabel: '업태',
                        name:'SUP_COM_TYPE'    
                    },{
                        fieldLabel: '업종',
                        name:'SUP_COM_CLASSIFY'   
                    }]
                },{
                    xtype: 'component',
                    width: 10
                },{
                    title   : '공급받는자',
                    padding : '0 10 10 10',
                    margin  : '0 0 0 0',
                    xtype   : 'fieldset',
                    id      : 'fieldset3',
                    defaults: {readOnly: true, xtype: 'uniTextfield'},
                    layout  : {type: 'uniTable' , columns: 2},
                    items   : [{
                        fieldLabel: '등록번호',
                        name:'BYR_COM_REGNO',    
                        width: 490,   
                        colspan:2
                    },{ 
                        fieldLabel: '상호(법인명)',
                        name: 'BYR_COM_NAME'
                    },{
                        fieldLabel: '성명(대표자)',
                        name:'BYR_REP_NAME'     
                    },{
                        fieldLabel: '사업장주소',
                        name:'BYR_COM_ADDR',     
                        width: 490,     
                        colspan: 2
                    },{
                        fieldLabel: '업태',
                        name:'BYR_COM_TYPE'    
                    },{
                        fieldLabel: '업종',
                        name:'BYR_COM_CLASSIFY'   
                    }]
                }]
            }]
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            border:true,
            padding:'1 1 1 1',
            items:[{
                xtype: 'container',
                margin: '0 0 0 0',
                layout: {type : 'uniTable', columns : 2},          
                items: [{
                    xtype: 'component',
                    width: 10
                },{
                    title: '위/수탁자',
                    xtype: 'fieldset',
                    id: 'fieldset4',
                    padding: '0 10 10 10',
                    margin: '0 0 0 0',
                    defaults: {readOnly: true, xtype: 'uniTextfield'},
                    layout: {type: 'uniTable' , columns: 2},
                    items: [{
                        fieldLabel: '등록번호',
                        name:'BROKER_COM_REGNO',    
//                        allowBlank:false,  
                        width: 1012,
                        colspan: 2
                    },{ 
                        fieldLabel: '상호(법인명)',
                        name: 'BROKER_COM_NAME',   
                        width: 490
                    },{
                        fieldLabel: '성명(대표자)',
                        labelWidth:122,
                        name:'BROKER_REP_NAME',  
                        width: 522   
                    },{
                        fieldLabel: '사업장주소',
                        name:'BROKER_COM_ADDR', 
                        width: 1012,   
                        colspan: 2
                    },{
                        fieldLabel: '업태',
                        name:'BROKER_COM_TYPE',   
                        width: 490    
                    }, {
                        fieldLabel: '업종',
                        labelWidth:122,
                        name:'BROKER_COM_CLASSIFY',   
                        width: 522   
                    }]
                }]
            }]
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            border:true,
            padding:'1 1 1 1',
            items:[{
                xtype: 'component',
                width: 10
            },{
                title: '',
                xtype: 'fieldset',
                id: 'fieldset5',
                padding: '10 10 10 10',
                margin: '0 0 0 0',
                defaults: {xtype: 'uniTextfield'},
                layout: {type: 'uniTable' , columns: 4
//                    tdAttrs: {style: 'border : 1px solid #ced9e7;'}
                },
                items: [{
                    xtype: 'uniDatefield',
                    name: 'DTI_WDATE',
                    fieldLabel: '작성일자',
//                    allowBlank: false,
                    readOnly:true          
                },{
                	xtype:'component',
                	width:277
        		},{
                    xtype: 'uniTextfield',
                    name: 'AMEND_NM',             
                    fieldLabel: '수정사유',
                    width: 490,
                    readOnly:true,
                    colspan:2
                },{
                    xtype: 'uniNumberfield',
                    name: 'SUP_AMOUNT',            
                    fieldLabel: '공급가액',
                    readOnly:true
                },{
                    xtype: 'uniNumberfield',
                    name: 'TAX_AMOUNT',
                    fieldLabel: '세액',
                    readOnly:true
                },{
                    xtype: 'uniTextfield',
                    name: 'REMARK',           
                    fieldLabel: '비고',
                    width: 490,
                    readOnly:true,
                    colspan:2
                }]
            }]
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            border:true,
            padding:'1 1 1 1',
            items:[{
                xtype: 'component',
                width: 10
            },{
                title: '',
                xtype: 'fieldset',
                id: 'fieldset6',
                padding: '10 10 10 10',
                margin: '0 0 0 0',
//                    defaults: {xtype: 'uniTextfield'},
                layout: {type: 'uniTable' , columns: 1
//                        tdAttrs: {style: 'border : 1px solid #ced9e7;'}
                },
                items: [{
                    xtype: 'container',
                    layout: {type : 'uniTable', columns : 1},
                    items:[
//                        subGrid
                    {
                        xtype: 'grid',
//                        border: false,
//                        height:100,
                        width:1014,
                        id:'subGrid',
                        store: directSubStore,
                //        selModel:'rowmodel',
//                        useRowNumberer: false,
                        columns: [
                            { xtype: 'rownumberer'       , width:30},
                            { dataIndex: 'ITEM_MD_MONTH' ,text: '월'       ,type: 'string'         ,width:40,align:'center'},
                            { dataIndex: 'ITEM_MD_DAY'   ,text: '일'       ,type: 'string'         ,width:40,align:'center'},
                            { dataIndex: 'ITEM_CODE'     ,text: '품목코드'   ,type: 'string'          ,width:120, style: 'text-align:center',hidden:true},
                            { dataIndex: 'ITEM_NAME'     ,text: '품목'      ,type: 'string'         ,width:200, style: 'text-align:center'},
                            { dataIndex: 'ITEM_SIZE'     ,text: '규격'      ,type: 'string'        ,width:80, style: 'text-align:center'},
                            { dataIndex: 'ITEM_QTY'      ,text: '수량'      ,type: 'uniQty'         ,width:80, style: 'text-align:center', align:'right',
                                renderer: function(value, metaData, record) {
                                    return Ext.util.Format.number(value, '0,000');//UniFormat.Qty);
                                }
                            },
                            { dataIndex: 'UNIT_PRICE'    ,text: '단가'      ,type: 'uniUnitPrice'   ,width:80, style: 'text-align:center', align:'right',
                                renderer: function(value, metaData, record) {
                                    return Ext.util.Format.number(value, '0,000');//UniFormat.UnitPrice);
                                }
                            },
                            { dataIndex: 'SUP_AMOUNT'    ,text: '공급가액'   ,type: 'uniPrice'        ,width:120, style: 'text-align:center', align:'right',
                                renderer: function(value, metaData, record) {
                                    return Ext.util.Format.number(value, '0,000');// UniFormat.Price);
                                }
                            },
                            { dataIndex: 'TAX_AMOUNT'    ,text: '세액'      ,type: 'uniPrice'       ,width:100, style: 'text-align:center', align:'right',
                                renderer: function(value, metaData, record) {
                                    return Ext.util.Format.number(value, '0,000');// UniFormat.Price);
                                }
                            },
                            { dataIndex: 'REMARK'        ,text: '비고'      ,type: 'string'          ,width:240, style: 'text-align:center'}
                            
                        ]     
                    }]
                },{
                    xtype: 'container',
                    layout: {type : 'uniTable', columns : 6,
                        tableAttrs: {style:'border : 1px solid #ced9e7;'},
                        tdAttrs: {/*style:'border : 1px solid #ced9e7;',*/align : 'center'}
                    },
                    defaults: {xtype: 'uniNumberfield',readOnly:true,
                        style: {
                            marginTop: '3px !important',
                            font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
                        }
                    },
                    items:[{
                        xtype: 'component',  
                        html:'합계금액'
                    },{ 
                        xtype: 'component',  
                        html:'현금'
                    },{ 
                        xtype: 'component',  
                        html:'수표'
                    },{
                    	xtype: 'component', 
                    	html:'어음'
                    },{ 
                        xtype: 'component',  
                        html:'외상미수금'
                    },{ 
                        xtype: 'component',  
                        html:'이금액을(청구)함',
                        width:262,
                        rowspan: 2
                    },{
                        xtype:'uniNumberfield',
                        name:'TOTAL_AMOUNT'
                    },{
                        xtype:'uniNumberfield',
                        name:'CASH_AMOUNT'
                    },{
                        xtype:'uniNumberfield',
                        name:'CHECK_AMOUNT'
                    },{
                        xtype:'uniNumberfield',
                        name:'NOTE_AMOUNT'
                    },{
                        xtype:'uniNumberfield',
                        name:'RECEIVABLE_AMOUNT'
                    }]
                }]
            }]
        }],
        api: {
          load: 'aep130ukrService.selectMasterForm'  
        }
    });
   
    var searchGrid = Unilite.createGrid('aep130ukrSearchGrid', {
//      split:true,
    	flex:1,
        layout: 'fit',
        region: 'center',
        excelTitle: '전자세금계산서업로드',
        height:300,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: true,
            useRowNumberer: false,
            expandLastColumn: false,
            useRowContext: false,
            state: {
                useState: false,         
                useStateList: false     
            }
        },
        tbar:[{
            xtype: 'button',
            text: 'XML업로드',
            handler: function() {
                openXmlUploadWindow();
            
            }
        }],
        features: [{
            id: 'detailGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false
        },{
            id: 'detailGridTotal', 
            ftype: 'uniSummary', 
            showSummaryRow: false
        }],
        store: directSearchStore,
        selModel:'rowmodel',
        columns: [
            {dataIndex: 'RNUM'                   ,width:60,align:'center'},
            {dataIndex: 'SUP_COM_NAME'           ,width:200},
            {dataIndex: 'SUP_COM_REGNO'          ,width:150},
            {dataIndex: 'CONVERSATION_ID'        ,width:250},
            {dataIndex: 'SUP_AMOUNT'             ,width:100},
            {dataIndex: 'TAX_AMOUNT'             ,width:100},
            {dataIndex: 'TOTAL_AMOUNT'           ,width:120},
            {dataIndex: 'ETAX_STATUS_CD'         ,width:100},
            {dataIndex: 'SUP_COM_CLASSIFY'       ,width:120},
            {dataIndex: 'SUP_COM_TYPE'           ,width:120},
            {dataIndex: 'TAX_DEMAND'             ,width:100}
        ],  
        listeners: { 
            beforeselect: function(rowSelection, record, index, eOpts) {
            },
            
            selectionchangerecord:function(selected)    {
                masterForm.setValue('CONVERSATION_ID',selected.data.CONVERSATION_ID);
                
                
                masterForm.mask('loading...');
                //var param= masterForm.getValues();
                var param = {
                	'CONVERSATION_ID'	:selected.get("CONVERSATION_ID"),
         			'ETAX_XML_FILE_NAME':selected.get("ETAX_XML_FILE_NAME")
                }
                masterForm.getForm().load({
                    params: param,
                    success: function(form, action) {
                        directSubStore.loadStoreRecords();
                        masterForm.unmask();
                    },
                    failure: function(form, action) {
                        masterForm.unmask();
                    }
                });
                UniAppManager.setToolbarButtons('reset',true);
                
                UniAppManager.setToolbarButtons('save', false);
                
            },
            onGridDblClick: function(grid, record, cellIndex, colName) {
                /*var params = {
                    action: 'new',
                    DIV_CODE : masterForm.getValue('DIV_CODE'),
                    FR_DATE : panelResult.getValue('FR_DATE'),
                    TO_DATE : panelResult.getValue('TO_DATE'),
                    CUSTOM_CODE : record.get('CUSTOM_CODE'),
                    CUSTOM_NAME : record.get('CUSTOM_NAME')
                }
                var rec = {data : {prgID : 'aep120ukr'}};                          
                    parent.openTab(rec, '/jbill/aep120ukr.do', params); */ 
            }
        }
    }); 
    
    var fileUploadForm = Unilite.createForm('fileUploadForm',{
        region: 'center',
        border: false,
        disabled: false,
        padding: '0 0 0 0',
//      split:true,
        items: [{
            xtype: 'container',
//            layout: {type : 'uniTable', columns : 1},
            layout:{type:'vbox', align:'stretch'},
            width:1000,
            tdAttrs: {align : 'center'},
            items :[{
                xtype: 'xuploadpanel',
                height: 198,
                width:'100%',
//                flex: 1,
                padding: '0 0 0 0',
                listeners : {
                    change: function() {
//                        UniAppManager.app.setToolbarButtons('save', true);  //파일 추가or삭제시 저장버튼 on
                    }
                }
            },{
                xtype:'uniTextfield',
                fieldLabel: 'FILE_NO',          
                name:'FILE_NO',
                value: '',                //임시 파일 번호
                readOnly:true,
                hidden:true
            } ,{
                xtype:'uniTextfield',
                fieldLabel: '삭제파일FID'   ,       //삭제 파일번호를 set하기 위한 hidden 필드
                name:'DEL_FID',
                readOnly:true,
                hidden:true
            },{
                xtype:'uniTextfield',
                fieldLabel: '등록파일FID'   ,       //등록 파일번호를 set하기 위한 hidden 필드
                name:'ADD_FID',
                readOnly:true,
                hidden:true
            }]
        }],
        api: {
             submit: 'aep130ukrService.saveFile2'      //저장 api
        }
    });  
    
    function openXmlUploadWindow() {          

        if(!xmlUploadWindow) {
            xmlUploadWindow = Ext.create('widget.uniDetailWindow', {
                title: 'XML업로드',
                width: 1005,
                maxWidth:1005,
                minWidth:1005,
                height: 250,
                maxHeight: 250,
                minHeight: 250,
                padding: '0 0 0 0',
                layout:{type:'vbox', align:'stretch'},
                items: [fileUploadForm],
                tbar:  [
                    '->',{
                    	text: '저장',
	                    handler: function() {
	                        var fp = fileUploadForm.down('xuploadpanel'); 
	                        fp.store.data
	                        var addFiles = fp.getAddFiles();                
	                        var removeFiles = fp.getRemoveFiles();
	                        fileUploadForm.setValue('ADD_FID', addFiles);                  //추가 파일 담기
	                        fileUploadForm.setValue('DEL_FID', removeFiles);               //삭제 파일 담기
	                        var param= fileUploadForm.getValues();
	                        fileUploadForm.getEl().mask('로딩중...','loading-indicator'); //mask on
	                        fileUploadForm.getForm().submit({                              //폼 submit 함수 호출
	                             params : param,
	                             success : function(form, action) {
	                             	
	                                UniAppManager.updateStatus(Msg.sMB011);             //저장되었습니다.(message) 
	                                UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
	                                //searchForm.clearForm();
	                                
	                                fileUploadForm.getEl().unmask();                       //mask off
	                                 var param= {"CONVERSATION_IDS": action.result.CONVERSATION_IDS}
							            console.log( param );
							            directSearchStore.load({
							                params: param
							            });
							           
		                          	var fp = fileUploadForm.down('xuploadpanel');
		                          	fp.reset(); 
		                          	fp.clear(); 
		                            fileUploadForm.clearForm();
		                            xmlUploadWindow.hide();
	                             }
	                        });
	                    }
                
                    },{
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            xmlUploadWindow.hide();
//                          draftNoGrid.reset();
                            fileUploadForm.clearForm();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    },
                    show: function ( panel, eOpts ) {
                    }
                }
            })
        }
        xmlUploadWindow.center();
        xmlUploadWindow.show();
    }
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
//            layout : 'border',
            layout:{type:'vbox', align:'stretch'},
            border: false,
            autoScroll: true,
            
            items:[{
                region:'center',
                xtype:'container',
                layout:{type:'vbox', align:'stretch'},
//                split:true,
                items:[
                    searchForm, searchGrid, masterForm//, subGrid, subForm
                ]
            }]
        }],
        id  : 'aep130ukrApp',
        fnInitBinding: function(params){
            UniAppManager.setToolbarButtons(['newData'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            
            this.setDefault(params);
        },
        onQueryButtonDown: function() {   
        	directSearchStore.loadStoreRecords();   
        },
        onResetButtonDown: function() {
//          detailForm.clearForm();
        	masterForm.clearForm();
            searchGrid.reset();
            directSearchStore.clearData();
            directSubStore.clearData();
            Ext.getCmp('subGrid').view.refresh();
            
            UniAppManager.setToolbarButtons(['newData','save','delete'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.app.fnInitInputFields();  
            SAVE_FLAG = '';
        },
        
        onSaveDataButtonDown: function(config) {
        },
        
        onDeleteDataButtonDown: function() {
        
        },
        /*onDeleteAllButtonDown: function() {           
            var records = directDetailStore.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    if(confirm('전체삭제 하시겠습니까?')) {
                        var deletable = true;
                        if(deletable){      
                            detailGrid.reset();         
                            UniAppManager.app.onSaveDataButtonDown();   
                        }
                        isNewData = false;                          
                    }
                    return false;
                }
            });
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋          
                detailGrid.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }
        },*/
        setDefault: function(params){
            
            if(!Ext.isEmpty(params.CONF_RECE_NO)){
                this.processParams(params);
            }else{
                UniAppManager.app.fnInitInputFields();  
            }
        },
        processParams: function(params) {
            this.uniOpt.appParams = params;
            
           /* if(params.PGM_ID == 'aep130skr') {
                detailForm.setValue('CONF_RECE_NO',params.CONF_RECE_NO);
                
                
//                fileUploadForm.setDisabled(false);
                this.onQueryButtonDown();
            }*/
        },
        fnInitInputFields: function(){
            searchForm.setValue('PERSON_NUMB',UserInfo.personNumb);
            searchForm.setValue('NAME',personName);
        },
        fileUploadLoad: function(){
            var fp = fileUploadForm.down('xuploadpanel');                 //mask on
            fp.getEl().mask('로딩중...','loading-indicator');
            var fileNO = fileUploadForm.getValue('FILE_NO');
            aep130ukrService.getFileList({DOC_NO : fileNO},              //파일조회 메서드  호출(param - 파일번호) 
                function(provider, response) {                          
                    fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                    fp.getEl().unmask();                                //mask off
    //                                UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                }
             )
        }
        
    });
};

</script>