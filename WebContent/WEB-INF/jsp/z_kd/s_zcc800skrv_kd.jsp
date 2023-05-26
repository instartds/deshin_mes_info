<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zcc800skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zcc800skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="WZ08" /> <!-- 외주/자재구분  --> 
    <t:ExtComboStore comboType="AU" comboCode="WZ21" /> <!-- 가공구분  -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}'
};
var remarkWindow; // 의뢰서작성디테일팝업
	var searchInfoWindow; // 검색창

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_zcc800skrv_kdService.selectList'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zcc800skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'                 ,type: 'string'},
            {name: 'DIV_CODE'             ,text:'사업장'                   ,type: 'string'},
            {name: 'REQ_DATE'             ,text:'의뢰일'                   ,type: 'uniDate'},
            {name: 'REQ_NUM'              ,text:'의뢰서번호'               ,type: 'string'},
            {name: 'REQ_SEQ'              ,text:'순번'                 ,type: 'int'},
            {name: 'CUSTOM_NAME'          ,text:'거래처'               ,type: 'string'},
            {name: 'MAKE_GUBUN'           ,text:'가공구분'                 ,type: 'string', comboType:'AU', comboCode:'WZ21'},
			{name: 'ITEM_NAME'            ,text:'금형품명'                   ,type: 'string'},
            {name: 'CHILD_ITEM_CODE'      ,text:'품목코드'             ,type: 'string'},
            {name: 'CHILD_ITEM_NAME'      ,text:'품목명'               ,type: 'string'},
            {name: 'CHILD_ITEM_SPEC'      ,text:'규격'               ,type: 'string'},
            {name: 'UNIT'            	,text:'단위'                 		,type: 'string'},
         	{name: 'HM_CODE'            ,text:'항목(부품)명'            ,type: 'string', comboType:'AU', comboCode:'WZ22'},
            {name: 'MATERIAL'           ,text:'재질'                 		,type: 'string'},
            {name: 'GARO_NUM'           ,text:'가로'                 		,type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'GARO_NUM_UNIT'      ,text:'단위'                 		,type: 'string',editable:false},
            {name: 'SERO_NUM'           ,text:'세로'                 		,type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'SERO_NUM_UNIT'      ,text:'단위'                 		,type: 'string',editable:false},
            {name: 'THICK_NUM'          ,text:'두께'                 		,type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'THICK_NUM_UNIT'     ,text:'단위'                 		,type: 'string',editable:false},
            {name: 'BJ_NUM'             ,text:'비중'                 		,type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'CAL_QTY'            ,text:'환산수량'                  ,type: 'float', decimalPrecision: 2, format:'0,000.00',editable:false},
            {name: 'CAL_UNIT'            ,text:'환산단위'                 ,type: 'string',editable:false},
            {name: 'PURCHASE_P'         ,text:'개별단가'                  ,type: 'float', decimalPrecision: 6, format:'0,000.00',editable:false},
            {name: 'PRICE'              ,text:'환산단가'                 		,type: 'float', decimalPrecision: 6, format:'0,000.00',editable:false},
            {name: 'AMT'            	,text:'금액'                 		,type: 'float', decimalPrecision: 0, format:'0,000',editable:false},
            {name: 'QTY'       			,text:'수량'                 		,type: 'float', decimalPrecision: 2, format:'0,000.00',allowBlank:false},
            {name: 'DELIVERY_DATE'      ,text:'납기일자'                 ,type: 'uniDate',allowBlank:false},
            {name: 'IN_DATE'      				,text:'입고일자'          ,type: 'uniDate'},
            {name: 'CLOSE_YN'             		,text:'완료구분'          	,type: 'string', comboType:'AU', comboCode:'B131'},
            {name: 'REMARK'             ,text:'비고'                 		,type: 'string'},
            
            {name: 'DEPT_NAME'          ,text:'부서명'               ,type: 'string'},
            {name: 'PERSON_NAME'          ,text:'담당자명'               ,type: 'string'},
            {name: 'REMARK_M'             ,text:'마스터 비고'                 		,type: 'string'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_zcc800skrv_kdMasterStore',{
        model: 's_zcc800skrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelResult.getValues();
            this.load({
                  params : param
            });         
        },
        groupField:'CUSTOM_NAME'
    });
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */ 
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
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
				fieldLabel: '의뢰서번호',
				xtype: 'uniTextfield',
	            name: 'REQ_NUM',
//				 	allowBlank:false,
				listeners: {
					render: function(component) {
                        component.getEl().on('dblclick', function( event, el ) {
                             openSearchInfoWindow();
                        });
                    }
				}
			}
            
//            Unilite.popup('REQ_NUM2',{ 
//                fieldLabel: '의뢰서번호',
//                valueFieldName: 'REQ_NUM', 
//                textFieldName: 'REQ_NUM', 
//                autoPopup:true,
//                listeners: {
//                    applyextparam: function(popup){ 
//                        popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
////                            popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['00','10']});
//                    }
//                }
//            })
            
            /*,{
                fieldLabel: '의뢰서번호',
                name:'REQ_NUM',   
                xtype: 'uniTextfield'
            }*/,{
                fieldLabel: '의뢰일자',
                startFieldName: 'REQ_DATE_FR',
                endFieldName: 'REQ_DATE_TO',
                xtype: 'uniDateRangefield',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
//                allowBlank: false
            },{
	            fieldLabel: '금형품명',
	            name:'ITEM_NAME',   
	            xtype: 'uniTextfield'
//	            width:650
        	},{
	            fieldLabel: '완료여부',
	            name:'CLOSE_YN',
	            xtype: 'uniCombobox',
	            comboType:'AU',
	            comboCode:'B131'
	        },{                 
                fieldLabel: '가공구분',
                name:'MAKE_GUBUN',
                xtype: 'uniCombobox',
                comboCode:'WZ21',
                comboType:'AU'
            },
            Unilite.popup('AGENT_CUST', {
                    fieldLabel:'거래처', 
                    valueFieldName: 'CUSTOM_CODE',
                    textFieldName: 'CUSTOM_NAME'
            }),
            Unilite.popup('DEPT', { 
                fieldLabel: '부서', 
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                autoPopup:true,
                listeners: {
                    applyextparam: function(popup){                         
                        var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                        var deptCode = UserInfo.deptCode;   //부서정보
                        var divCode = '';                   //사업장
                        if(authoInfo == "A"){   //자기사업장 
                            popup.setExtParam({'TREE_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                            popup.setExtParam({'TREE_CODE': ""});
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }else if(authoInfo == "5"){     //부서권한
                            popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
                }
            }), 
            Unilite.popup('Employee',{
                    fieldLabel: '담당자',
                    valueFieldName:'PERSON_NUMB',
                    textFieldName:'PERSON_NAME',
                    validateBlank:false,
                    autoPopup:true,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                var param= Ext.getCmp('resultForm').getValues();
                                s_zcc800skrv_kdService.selectPersonDept(param, function(provider, response)  {     
                                    if(!Ext.isEmpty(provider)){                                                
                                        panelResult.setValue('TREE_CODE', provider[0].DEPT_CODE);  
                                        panelResult.setValue('TREE_NAME', provider[0].DEPT_NAME);             
                                    }                                                                          
                                });    
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelResult.setValue('PERSON_NUMB', '');
                            panelResult.setValue('PERSON_NAME', '');
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DEPT_SEARCH': panelResult.getValue('TREE_NAME')});
                        }
                    }
            })
        ]
    });
    
    var masterGrid = Unilite.createGrid('s_zcc800skrv_kdmasterGrid1', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: true,
            useMultipleSorting: false,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: true,
            onLoadSelectFirst: true,
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
        columns:  [ 
            { dataIndex: 'COMP_CODE'                                   ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                                    ,           width: 80, hidden: true},
            { dataIndex: 'REQ_DATE'                                    ,           width: 100},
            { dataIndex: 'REQ_NUM'                                     ,           width: 120},
            { dataIndex: 'REQ_SEQ'                                     ,           width: 66, align: 'center'},
            { dataIndex: 'CUSTOM_NAME'                                 ,           width: 200,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
        	},
            { dataIndex: 'MAKE_GUBUN'                                  ,           width: 100},
            { dataIndex: 'ITEM_NAME'                                   ,           width: 200},
            { dataIndex: 'CHILD_ITEM_CODE'                             ,           width: 100},
            { dataIndex: 'CHILD_ITEM_NAME'                             ,           width: 200},
            { dataIndex: 'CHILD_ITEM_SPEC'                             ,           width: 100},
            { dataIndex: 'UNIT'                                        ,           width: 60, align: 'center'},
            { dataIndex: 'HM_CODE'                                     ,           width: 120},
            { dataIndex: 'MATERIAL'                                    ,           width: 120},
            { dataIndex: 'GARO_NUM'                                    ,           width: 100,
				renderer: function(value, metaData, record) {
					if(value == 0){
						return '';
					}else{
						return Ext.util.Format.number(value, '0,000.00');
					}
				}
			},
            { dataIndex: 'GARO_NUM_UNIT'                               ,           width: 60, align: 'center'},
            { dataIndex: 'SERO_NUM'                                    ,           width: 100,
				renderer: function(value, metaData, record) {
					if(value == 0){
						return '';
					}else{
						return Ext.util.Format.number(value, '0,000.00');
					}
				}
			},
            { dataIndex: 'SERO_NUM_UNIT'                               ,           width: 60, align: 'center'},
            { dataIndex: 'THICK_NUM'                                   ,           width: 100,
				renderer: function(value, metaData, record) {
					if(value == 0){
						return '';
					}else{
						return Ext.util.Format.number(value, '0,000.00');
					}
				}
			},
            { dataIndex: 'THICK_NUM_UNIT'                              ,           width: 60, align: 'center'},
            { dataIndex: 'BJ_NUM'                                      ,           width: 100,
				renderer: function(value, metaData, record) {
					if(value == 0){
						return '';
					}else{
						return Ext.util.Format.number(value, '0,000.00');
					}
				}
			},
            { dataIndex: 'CAL_QTY'                                     ,           width: 100,
				renderer: function(value, metaData, record) {
					if(value == 0){
						return '';
					}else{
						return Ext.util.Format.number(value, '0,000.00');
					}
				}
			},
            { dataIndex: 'CAL_UNIT'                                  ,           width: 80},
            { dataIndex: 'PURCHASE_P'                                  ,           width: 100,
				renderer: function(value, metaData, record) {
					if(value == 0){
						return '';
					}else{
						return Ext.util.Format.number(value, '0,000.00');
					}
				}
			},
            { dataIndex: 'PRICE'                                       ,           width: 100,
				renderer: function(value, metaData, record) {
					if(value == 0){
						return '';
					}else{
						return Ext.util.Format.number(value, '0,000.00');
					}
				}
			},
            { dataIndex: 'AMT'                                         ,           width: 100,summaryType:'sum',
				renderer: function(value, metaData, record) {
					if(value == 0){
						return '';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				},summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
            	}
			},
            { dataIndex: 'QTY'       		                           ,           width: 100,
				renderer: function(value, metaData, record) {
					if(value == 0){
						return '';
					}else{
						return Ext.util.Format.number(value, '0,000.00');
					}
				}
			},
            { dataIndex: 'DELIVERY_DATE'                               ,           width: 100},
            { dataIndex: 'IN_DATE'      			                   ,           width: 100},
            { dataIndex: 'CLOSE_YN'      			                   ,           width: 100, align: 'center'},
            { dataIndex: 'REMARK'      			                       ,           width: 100},
            { dataIndex: 'DEPT_NAME'      			                   ,           width: 100},
            { dataIndex: 'PERSON_NAME'      			               ,           width: 100}
        ],
        listeners: { 
			onGridDblClick:function(grid, record, cellIndex, colName) {
   				 openRemarkWindow();
			}
        }
    });
    var subForm = Unilite.createSearchForm('subForm', {
        height:400,
        width: 850,
//        masterGrid : detailGrid,
		region		: 'center',
		autoScroll	: false,
		border		: true,
		padding		: '1 1 1 1',
		layout		: {type: 'uniTable', columns: 3, tdAttrs: {valign:'top'}},
        items:[{
            fieldLabel: '마스터 비고',
            name:'REMARK',
            xtype: 'textareafield',
            width: 800,
            height : 350,
            readOnly:true
        }]
    });
    function openRemarkWindow() {
		if(!remarkWindow) {
			remarkWindow = Ext.create('widget.uniDetailWindow', {
				title: '의뢰서비고팝업',
				width: 900,
				height: 450,
				resizable:false,
				layout: {type:'vbox', align:'stretch'},
				items: [subForm],
				tbar:  ['->', {
					id : 'closeBtn',
					width: 100,
					text: '닫기',
					handler: function() {
						remarkWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts )	{
						var masterRecord = masterGrid.getSelectedRecord();
						subForm.setValue('REMARK', masterRecord.get('REMARK_M'));
					}
				}
			})
		}
		remarkWindow.center();
		remarkWindow.show();
	}
	
	Unilite.defineModel('searchInfoModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'                 ,type: 'string'},
            {name: 'DIV_CODE'             ,text:'사업장'                   ,type: 'string'},
            {name: 'REQ_NUM'              ,text:'의뢰번호'               ,type: 'string'},
            {name: 'REQ_DATE'             ,text:'의뢰일'                   ,type: 'uniDate'},
            {name: 'CUSTOM_CODE'          ,text:'거래처코드'               ,type: 'string'},
            {name: 'CUSTOM_NAME'          ,text:'거래처명'                 ,type: 'string'},
            {name: 'MOMEY_UNIT'          ,text:'MOMEY_UNIT'                 ,type: 'string'},
            {name: 'MAKE_GUBUN'          ,text:'가공구분'                 ,type: 'string', comboType:'AU', comboCode:'WZ21'},
            {name: 'REQ_GUBUN'            ,text:'외주/자재구분'            ,type: 'string', comboType:'AU', comboCode:'WZ08'},
//            {name: 'ITEM_CODE'            ,text:'품목코드'                 ,type: 'string'},
            {name: 'ITEM_NAME'            ,text:'품목명'                   ,type: 'string'},
            {name: 'DEPT_CODE'            ,text:'부서코드'                 ,type: 'string'},
            {name: 'DEPT_NAME'            ,text:'부서명'                 ,type: 'string'},
            {name: 'PERSON_NUMB'          ,text:'담당자코드'                 ,type: 'string'},
            {name: 'PERSON_NAME'          ,text:'담당자명'                   ,type: 'string'},
            {name: 'REMARK'               ,text:'비고'                     ,type: 'string'}
        ]
    });
	
    var searchInfoForm = Unilite.createSearchForm('searchInfoForm', {     // 검색 팝업창
        layout: {type: 'uniTable', columns : 3},
//        trackResetOnLoad: true,
        items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            value: UserInfo.divCode
        },
        Unilite.popup('AGENT_CUST', {
            fieldLabel:'거래처',
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME'
        }),
        {
			fieldLabel: '의뢰일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'REQ_DATE_FR',
			endFieldName: 'REQ_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},{
            fieldLabel: '가공구분',
            name:'MAKE_GUBUN',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'WZ21'
        },{
            fieldLabel: '품명',
            name:'ITEM_NAME',
            xtype: 'uniTextfield'
        },{
            fieldLabel: '의뢰번호',
            name:'REQ_NUM',
            xtype: 'uniTextfield'
        }]
    });
    
	var searchInfoStore = Unilite.createStore('searchInfoStore',{
        model: 'searchInfoModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  false,            // 수정 모드 사용
            deletable: false,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 's_zcc800ukrv_kdService.selectSearchInfo'
            }
        },
        loadStoreRecords : function()   {
            var param= searchInfoForm.getValues();
            this.load({
                  params : param
            });
        },groupField:'CUSTOM_NAME'
    });
    
	var searchInfoGrid = Unilite.createGrid('searchInfoGrid', {
        layout : 'fit',
        region: 'center',
        store: searchInfoStore,
        uniOpt: {
            expandLastColumn: true,
            useMultipleSorting: false,
            useGroupSummary: true,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: true,
            onLoadSelectFirst: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        features: [{		
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
        selModel:'rowmodel',
        columns:  [
            { dataIndex: 'COMP_CODE'                            ,width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                             ,width: 80, hidden: true},
            { dataIndex: 'REQ_NUM'                              ,width: 100},
            { dataIndex: 'REQ_DATE'                             ,width: 80},
            { dataIndex: 'CUSTOM_CODE'                          ,width: 110},
            { dataIndex: 'CUSTOM_NAME'                          ,width: 200},
            { dataIndex: 'MOMEY_UNIT'                           ,width: 100, hidden: true},
            { dataIndex: 'MAKE_GUBUN'                           ,width: 100},
            { dataIndex: 'REQ_GUBUN'                            ,width: 100, hidden: true},
//            { dataIndex: 'ITEM_CODE'                            ,width: 110},
            { dataIndex: 'ITEM_NAME'                            ,width: 200},
            { dataIndex: 'DEPT_CODE'                            ,width: 110},
            { dataIndex: 'DEPT_NAME'                            ,width: 200},
            { dataIndex: 'PERSON_NUMB'                          ,width: 110},
            { dataIndex: 'PERSON_NAME'                          ,width: 200},
            { dataIndex: 'REMARK'                               ,width: 200}
        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
                searchInfoGrid.returnData(record);
                UniAppManager.app.onQueryButtonDown();
                searchInfoWindow.hide();
            }
        },
        returnData: function(record)   {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelResult.setValues({'DIV_CODE':record.get('DIV_CODE')});
            panelResult.setValues({'REQ_NUM':record.get('REQ_NUM')});
            panelResult.setValues({'REQ_DATE_FR':record.get('REQ_DATE')});
            panelResult.setValues({'REQ_DATE_TO':record.get('REQ_DATE')});
            panelResult.setValues({'CUSTOM_CODE':record.get('CUSTOM_CODE')});
            panelResult.setValues({'CUSTOM_NAME':record.get('CUSTOM_NAME')});
            panelResult.setValues({'MONEY_UNIT':record.get('MONEY_UNIT')});
            panelResult.setValues({'MAKE_GUBUN':record.get('MAKE_GUBUN')});
            panelResult.setValues({'REQ_GUBUN':record.get('REQ_GUBUN')});
//            panelResult.setValues({'ITEM_CODE':record.get('ITEM_CODE')});
            panelResult.setValues({'ITEM_NAME':record.get('ITEM_NAME')});
            panelResult.setValues({'DEPT_CODE':record.get('DEPT_CODE')});
            panelResult.setValues({'DEPT_NAME':record.get('DEPT_NAME')});
            panelResult.setValues({'PERSON_NUMB':record.get('PERSON_NUMB')});
            panelResult.setValues({'PERSON_NAME':record.get('PERSON_NAME')});
//            panelResult.setValues({'REMARK':record.get('REMARK')});

        }
    });

    function openSearchInfoWindow() {   //검색팝업창
        if(!searchInfoWindow) {
            searchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '의뢰번호 검색',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [searchInfoForm, searchInfoGrid],
                tbar:  ['->',
                    {itemId : 'searchQueryBtn',
                    text: '조회',
                    handler: function() {
            			if(!searchInfoForm.getInvalidMessage()) return;   //필수체크
                        searchInfoStore.loadStoreRecords();
                    },
                    disabled: false
                    }, {
                        itemId : 'searchCloseBtn',
                        text: '닫기',
                        handler: function() {
                            searchInfoWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners: {beforehide: function(me, eOpt)
                    {
                        searchInfoForm.clearForm();
                        searchInfoGrid.getStore().loadData({});
                    },
                    beforeclose: function( panel, eOpts ) {
                        searchInfoForm.clearForm();
                        searchInfoGrid.getStore().loadData({});
                    },
                    beforeshow: function( panel, eOpts )    {
                        searchInfoForm.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
				        searchInfoForm.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
				        searchInfoForm.setValue('REQ_DATE_TO', UniDate.get('today'));
                    }
                }
            })
        }
        searchInfoWindow.show();
        searchInfoWindow.center();
    }
	
	
	
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                    masterGrid, panelResult
                ]
            }   
        ],
        id  : 's_zcc800skrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            directMasterStore.loadStoreRecords();
        },
        onResetButtonDown: function() {
            panelResult.clearForm(); 
            masterGrid.getStore().loadData({});
            this.setDefault();
        },
        setDefault: function() { 
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('REQ_DATE_TO', UniDate.get('today'));
        }                         
    });                         
}
</script>