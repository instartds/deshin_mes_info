<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zcc610skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zcc610skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="WZ08" /> <!-- 외주/자재구분  -->
    <t:ExtComboStore comboType="AU" comboCode="WZ32" /> <!-- 부서구분  -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>
<script type="text/javascript" >

var BsaCodeInfo = {	
	gsAuthorityLevel: '${gsAuthorityLevel}'
};
function appMain() {

    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_zcc610skrv_kdService.selectDetail'
        }
    });
	
    Unilite.defineModel('detailModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'                 ,type: 'string'},
            {name: 'DIV_CODE'             ,text:'사업장'                   ,type: 'string'},
            {name: 'ENTRY_NUM'            ,text:'관리번호'                 ,type: 'string'},
            {name: 'SER_NO'            	,text:'관리순번'                   ,type: 'int'},
            
            {name: 'ENTRY_DATE'    			,text:'등록일자'           	,type: 'uniDate'},
            
            {name: 'ITEM_CODE'    			,text:'품번'           	,type: 'string'},
            {name: 'ITEM_NAME'    		,text:'품명'            		,type: 'string'},
//            {name: 'SPEC'    		,text:'규격'             				,type: 'string'},
            {name: 'CUSTOM_CODE'          ,text:'납품업체'             	,type: 'string'},
            {name: 'CUSTOM_NAME'          ,text:'업체명'              	,type: 'string'},
            {name: 'MAKE_QTY'             ,text:'제작수량'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'MAKE_UNIT',       text : '단위',                type : 'string'},
            {name: 'MAKE_END_YN'             ,text:'작업완료'              ,type: 'string', comboType:'AU', comboCode:'B131' },
            {name: 'WIRE_P'             ,text:'와이어'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'LASER_P'             ,text:'레이저'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'COAT_P'             ,text:'코팅'                 		,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'WIRE_S_P'             ,text:'와이어S'                 ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'ETC_P'             ,text:'기타'                 		,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'MATERIAL_AMT'             ,text:'재료비'              ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'MAKE_AMT'             ,text:'가공비'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'ETC_AMT'             ,text:'기타'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'COST_AMT'             ,text:'제작금액'                 ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'EST_AMT'             ,text:'견적가'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'NEGO_AMT'             ,text:'네고가'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},

            {name: 'MARGIN_AMT'             ,text:'마진금액'               ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'TEMP_AMT'             ,text:'임시가'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'DELIVERY_QTY'             ,text:'납품수량'            	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'DELIVERY_AMT'             ,text:'납품액'             	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'DELIVERY_DATE'             ,text:'납품일자'           ,type: 'uniDate'},
           
            {name: 'COLLECT_DATE'    	  ,text:'수금일자'         ,type: 'uniDate'},
            {name: 'COLLECT_QTY'    	  ,text:'수금수량'           	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'COLLECT_AMT'    	  ,text:'수금액'           	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'NO_COLLECT_AMT'    	  ,text:'미수금액'           	,type: 'float', decimalPrecision: 0, format:'0,000'},
             {name: 'CLOSE_YN'             ,text:'완료여부'                ,type: 'string', comboType:'AU', comboCode:'B131' },
            {name: 'EST_REMARK'             ,text:'비고'                 		,type: 'string'}
        ]
    });
    
    var detailStore = Unilite.createStore('detailStore',{
        model: 'detailModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
            this.load({
            	params : param,
				callback : function(records, operation, success) {
					if(success) {
						if(!Ext.isEmpty(records)){
            				UniAppManager.setToolbarButtons('print', false);
						}
					}
				}
            });         
        },
        groupField:'CUSTOM_NAME'
        
    });
    
    var panelSearch = Unilite.createSearchForm('panelSearch',{
        region: 'north',
        layout : {type : 'uniTable', columns : 5},
        padding:'1 1 1 1',
        border:true,
        items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            value: UserInfo.divCode
        },{
			fieldLabel: '작업구분',
			xtype: 'radiogroup',
			id: 'rdoSelect',
			items: [{
				boxLabel	: '개발금형',
				name		: 'WORK_TYPE',
				inputValue	: '1',
				width		: 80
			},{
				boxLabel	: '시작샘플',
				name		: 'WORK_TYPE',
				inputValue	: '2',
				width		: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
//					UniAppManager.app.setHiddenColumn(newValue.WORK_TYPE);
				}
			}
		},{
			fieldLabel: '등록일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'ENTRY_DATE_FR',
			endFieldName: 'ENTRY_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
//			allowBlank:false
		},{
            fieldLabel: '완료여부',
            name:'CLOSE_YN',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B131',
            colspan:2
        },{
            fieldLabel: '부서구분',
            name:'DEPT_TYPE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'WZ32'
        },{
            fieldLabel: '관리번호',
            name:'ENTRY_NUM',   
            xtype: 'uniTextfield'
        },{
            fieldLabel: '품번',
            name:'ITEM_CODE',   
            xtype: 'uniTextfield'
        },
        Unilite.popup('CUST',{
			fieldLabel		: '납품업체',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME'
		})]
    });
    
    var detailGrid = Unilite.createGrid('detailGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: detailStore,
        uniOpt: {
            expandLastColumn: true,
            useMultipleSorting: false,
            useGroupSummary: true,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: true,
            onLoadSelectFirst: true,
            useGroupSummary: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
        selModel:'rowmodel',
        tbar: [{
                itemId : 'GWBtn',
//                id:'GW',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelSearch.getValues();
                    if(confirm('기안 하시겠습니까?')) {
                    	UniAppManager.app.requestApprove();
                    }
                }
            }
        ],
        columns:  [ 
            { dataIndex: 'COMP_CODE'                                   ,width: 100,hidden:true},
            { dataIndex: 'DIV_CODE'                                    ,width: 100,hidden:true},
            { dataIndex: 'ENTRY_NUM'                                   ,width: 100},
            { dataIndex: 'SER_NO'                                      ,width: 100},
            { dataIndex: 'ENTRY_DATE'                                      ,width: 100},
            
            { dataIndex: 'ITEM_CODE'                                   ,width: 100},
            { dataIndex: 'ITEM_NAME'                                   ,width: 100},
//            { dataIndex: 'SPEC'                                   		,width: 100},
            { dataIndex: 'CUSTOM_CODE'                                 ,width: 100},
            { dataIndex: 'CUSTOM_NAME'                                 ,width: 100,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
            },
            { dataIndex: 'MAKE_QTY'                                    ,width: 100},
        	{ dataIndex: 'MAKE_UNIT'                                    ,width: 100},

            { dataIndex: 'MAKE_END_YN'                                 ,width: 100,hidden:true},
            { dataIndex: 'WIRE_P'                                      ,width: 100,hidden:true},
            { dataIndex: 'LASER_P'                                     ,width: 100,hidden:true},
            { dataIndex: 'COAT_P'                                      ,width: 100,hidden:true},
            { dataIndex: 'WIRE_S_P'                                    ,width: 100,hidden:true},
            { dataIndex: 'ETC_P'                                       ,width: 100,hidden:true},
            { dataIndex: 'MATERIAL_AMT'                                ,width: 100,hidden:true},
            { dataIndex: 'MAKE_AMT'                                    ,width: 100,hidden:true},
            { dataIndex: 'ETC_AMT'                                     ,width: 100,hidden:true},
            { dataIndex: 'COST_AMT'                                    ,width: 100},
            { dataIndex: 'EST_AMT'                                    ,width: 100},            
            	{ dataIndex: 'NEGO_AMT'                                    ,width: 100},

            { dataIndex: 'MARGIN_AMT'                                    ,width: 100,hidden:true},
            { dataIndex: 'TEMP_AMT'                                    ,width: 100,hidden:true},
            { dataIndex: 'DELIVERY_QTY'                                    ,width: 100},
            { dataIndex: 'DELIVERY_AMT'                                    ,width: 100,summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
            	}
            },
            { dataIndex: 'DELIVERY_DATE'                                    ,width: 100},
            { dataIndex: 'COLLECT_DATE'                           ,width: 100},
            { dataIndex: 'COLLECT_QTY'                            ,width: 100},
            { dataIndex: 'COLLECT_AMT'                            ,width: 100,summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
            	}
            },
            { dataIndex: 'NO_COLLECT_AMT'                            ,width: 100,summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
            	}
            },
            { dataIndex: 'CLOSE_YN'                                    ,width: 100},
            { dataIndex: 'EST_REMARK'                                    ,width: 300}
        ]
    });
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelSearch, detailGrid
            ]
        }],
        id  : 's_zcc610skrv_kdApp',
        fnInitBinding : function() {
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
            detailStore.loadStoreRecords();
        },
        onResetButtonDown: function() {
            panelSearch.clearForm(); 
            detailStore.clearData();
            detailGrid.reset();
            this.setDefault();
        },
        setDefault: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('ENTRY_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('ENTRY_DATE_TO', UniDate.get('today'));
            panelSearch.setValue('WORK_TYPE', '1');
            UniAppManager.setToolbarButtons('print', false);
        },
        onPrintButtonDown: function () {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
			var param = panelSearch.getValues();
			param["USER_LANG"] = UserInfo.userLang;
			param["PGM_ID"]= PGM_ID;
			param["DEPT_TYPE"] = panelSearch.getField('DEPT_TYPE').rawValue;
			if(Ext.getCmp('rdoSelect').getValue().WORK_TYPE == '1'){
				param["sTxtValue2_fileTitle"]='개발 금형비 미수금 관리대장';
			}else {
				param["sTxtValue2_fileTitle"]='시작 샘플비 미수금 관리대장';
			}
			var win = null;
			win = Ext.create('widget.ClipReport', {
				url: CPATH+'/z_kd/s_zcc610clskrv_kd.do',
				prgID: 's_zcc610skrv_kd',
				extParam: param
			});
			win.center();
			win.show();
		},        
		requestApprove : function() {     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
            
            var frm             = document.f1;
            var record          = detailGrid.getSelectedRecord();
            var compCode        = UserInfo.compCode;
            var divCode         = panelSearch.getValue('DIV_CODE');
//            var frDate          = UniDate.getDbDateStr(panelSearch.getValue('ENTRY_DATE_FR'));
//            var toDate          = UniDate.getDbDateStr(panelSearch.getValue('ENTRY_DATE_TO'));
            
            if(Ext.isEmpty(panelSearch.getValue('ENTRY_DATE_FR'))) {
                var frDate        = '';
            } else {
                var frDate        = UniDate.getDbDateStr(panelSearch.getValue('ENTRY_DATE_FR')); 
            }
            if(Ext.isEmpty(panelSearch.getValue('ENTRY_DATE_TO'))) {
                var toDate        = '';
            } else {
                var toDate        = UniDate.getDbDateStr(panelSearch.getValue('ENTRY_DATE_TO')); 
            }
            
            if(Ext.isEmpty(panelSearch.getValue('ENTRY_NUM'))) {
                var entryNum        = '';
            } else {
                var entryNum        = panelSearch.getValue('ENTRY_NUM'); 
            }
            
            if(Ext.isEmpty(panelSearch.getValue('WORK_TYPE'))) {
                var workType        = '';
            } else {
                var workType        = Ext.getCmp('rdoSelect').getValue().WORK_TYPE; 
            }
            
            if(Ext.isEmpty(panelSearch.getValue('DEPT_TYPE'))) {
                var deptType        = '';
            } else {
                var deptType        = panelSearch.getValue('DEPT_TYPE'); 
            }
            
            if(Ext.isEmpty(panelSearch.getValue('ITEM_CODE'))) {
                var itemCode     = '';
            } else {
                var itemCode     = panelSearch.getValue('ITEM_CODE'); 
            }
           
            if(Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))) {
                var customCode     = '';
            } else {
                var customCode     = panelSearch.getValue('CUSTOM_CODE'); 
            }
            
            if(Ext.isEmpty(panelSearch.getValue('CLOSE_YN'))) {
                var closeYN         = '';
            } else {
                var closeYN         = panelSearch.getValue('CLOSE_YN'); 
            }

            var prgNo = "";
            var spNm = "";
            
            if(workType == '1'){
	            prgNo = "s_zcc600skrv_kd";
            }else{
	            prgNo = "s_zcc700skrv_kd";
            }
            
            
            var spText          = 'EXEC omegaplus_kdg.unilite.USP_GW_S_ZCC600SKRV_KD ' +"'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + frDate + "'" + ', ' + "'" + toDate + "'"  + ', ' + "'" + entryNum + "'"  + ', '+ "'" + workType + "'"  + ', '+ "'" + deptType + "'"  + ', ' + "'" + itemCode + "'"  + ', ' + "'" + customCode + "'"  + ', ' + "'" + closeYN + "'";
            
            var spCall          = encodeURIComponent(spText); 
            
/* //            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_zcc600skrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_str900skrv2_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit(); */
            
            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=" + prgNo + "&draft_no=" + '0' + "&sp=" + spCall;
            UniBase.fnGw_Call(gwurl,frm); 
            
        },
        setHiddenColumn: function(newValue) {
        	if(newValue == '1'){
                detailGrid.getColumn('WIRE_P').setHidden(false);
                detailGrid.getColumn('LASER_P').setHidden(false);
                detailGrid.getColumn('COAT_P').setHidden(false);
                detailGrid.getColumn('WIRE_S_P').setHidden(false);
                detailGrid.getColumn('ETC_P').setHidden(false);
                detailGrid.getColumn('MATERIAL_AMT').setHidden(true);
                detailGrid.getColumn('MAKE_AMT').setHidden(true);
                detailGrid.getColumn('ETC_AMT').setHidden(true);
            } else {
                detailGrid.getColumn('WIRE_P').setHidden(true);
                detailGrid.getColumn('LASER_P').setHidden(true);
                detailGrid.getColumn('COAT_P').setHidden(true);
                detailGrid.getColumn('WIRE_S_P').setHidden(true);
                detailGrid.getColumn('ETC_P').setHidden(true);
                detailGrid.getColumn('MATERIAL_AMT').setHidden(false);
                detailGrid.getColumn('MAKE_AMT').setHidden(false);
                detailGrid.getColumn('ETC_AMT').setHidden(false);
            }
        }
    });
}
</script>
<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>