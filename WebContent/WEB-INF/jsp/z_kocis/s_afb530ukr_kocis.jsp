<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb530ukr_kocis"  >

	<t:ExtComboStore comboType="AU" comboCode="A132" />	<!-- 수지구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A170" opts='2;3'/> <!-- 이월/불용승인 구분 (예산구분) -->
	
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
    <t:ExtComboStore items="${COMBO_SAVE_CODE}" storeId="saveCode" /> <!--계좌코드-->
    
    <t:ExtComboStore comboType="AU" comboCode="A134" /> <!-- 결재상태 --> 
    
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var refWindow; // 편성예산 참조

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_afb530ukrkocisService.selectList',
			update: 's_afb530ukrkocisService.updateDetail',
			create: 's_afb530ukrkocisService.insertDetail',
			destroy: 's_afb530ukrkocisService.deleteDetail',
			syncAll: 's_afb530ukrkocisService.saveAll'
		}
	});
	
	Unilite.defineModel('afb510Model', {
		fields:[
		
            {name: 'BUDG_GUBUN'         ,text: '구분'            ,type: 'string', comboType: 'AU', comboCode: 'A170'},
            {name: 'AC_GUBUN'           ,text: '회계구분'          ,type: 'string', comboType: 'AU', comboCode: 'A390'},
            {name: 'STATUS'             ,text: '결재상태'          ,type: 'string', comboType: 'AU', comboCode: 'A134'},
            {name: 'DEPT_CODE'          ,text: '기관'            ,type: 'string'},
            {name: 'DEPT_NAME'          ,text: '기관명'           ,type: 'string'},
            {name: 'ACCT_NO'            ,text: '계좌'             ,type: 'string',store: Ext.data.StoreManager.lookup('saveCode')},
            {name: 'BUDG_CODE'          ,text: '예산과목'          ,type: 'string'},
            {name: 'BUDG_NAME_1'        ,text: '부문'             ,type: 'string'},
            {name: 'BUDG_NAME_4'        ,text: '세부사업'          ,type: 'string'},
            {name: 'BUDG_NAME_6'        ,text: '세목'             ,type: 'string'},
            {name: 'IWALL_YYYYMM'       ,text: '이월년월'          ,type: 'string'},
            {name: 'IWALL_AMT_I'        ,text: '이월예산금액'        ,type: 'uniUnitPrice'},
            {name: 'DOC_NO'             ,text: 'DOC_NO'          ,type: 'string'},
            {name: 'SEQ'                ,text: 'SEQ'          ,type: 'int'}
        ]
	});
	
	Unilite.defineModel('afb510Model2', {
        fields:[
            {name: 'COMP_CODE'          ,text: '법인코드'          ,type: 'string'},
            {name: 'DEPT_CODE'          ,text: '기관'             ,type: 'string'},
            {name: 'DEPT_NAME'          ,text: '기관명'            ,type: 'string'},
            {name: 'ACCT_NO'            ,text: '계좌'             ,type: 'string',store: Ext.data.StoreManager.lookup('saveCode')},
            {name: 'BUDG_CODE'          ,text: '예산과목'          ,type: 'string'},
            {name: 'BUDG_NAME_1'        ,text: '부문'             ,type: 'string'},
            {name: 'BUDG_NAME_4'        ,text: '세부사업'          ,type: 'string'},
            {name: 'BUDG_NAME_6'        ,text: '세목'             ,type: 'string'},
            
          
            {name: 'BUDG_TOT_I'         ,text: '이월가능예산'       ,type: 'uniUnitPrice'},
            {name: 'BUDG_TOT_I_EDIT'    ,text: '이월예산'          ,type: 'uniUnitPrice'}
        ]
	});		
	
	
   
    
	var detailStore = Unilite.createStore('Afb510DetailStore',{
		model: 'afb510Model',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:true,				// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						/*var master = batch.operations[0].getResultSet();
						panelSearch.setValue("ORDER_NUM", master.ORDER_NUM);*/
						//3.기타 처리
						
						detailStore.loadStoreRecords();
						
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
						
						
					} 
				};
				this.syncAllDirect(config);
			} else {
                detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var refStore = Unilite.createStore('Afb510RefStore',{
		model: 'afb510Model2',
		uniOpt: {
            isMaster: false,				// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_afb530ukrkocisService.selectRefPopup'                	
            }
        },
        listeners:{
        	load:function(store, records, successful, eOpts) {
        		if(successful)	{
        		   var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);  
        		   var refRecords = new Array();
        		   if(masterRecords.items.length > 0) {
        		   		console.log("store.items :", store.items);
        		   		console.log("records", records);
        		   		Ext.each(records, 
            		   		function(item, i) {
		   						Ext.each(masterRecords.items, function(record, i) {
                                    if( (record.data['BUDG_CODE'] == item.data['BUDG_CODE']) 
//                                     && (record.data['BUDG_CODE'] == item.data['BUDG_CODE']) 
                                      ){
                                      	
                                      	if(record.phantom === true){
                                            refRecords.push(item);
                                      	}
                                    }
	   							});		
            			   	}
            			);
            			store.remove(refRecords);
        			}
        		}
        	}
        },
        loadStoreRecords: function() {
			var param= refSearch.getValues();
			param.DEPT_CODE = panelResult.getValue('DEPT_CODE'); 
			this.load({
				params : param
			});
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
    	width: 360,
        defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
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
	    		fieldLabel: '이월년월', 
	    		xtype: 'uniMonthfield',
	    		name: 'IWALL_YYYYMM',
    			allowBlank: false,
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelResult.setValue('IWALL_YYYYMM', newValue);
			     	}
			    }
	    	},{
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name: 'AC_GUBUN',
                comboType: 'AU',
                comboCode: 'A390',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_GUBUN', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '이월/불용승인 구분',
                name: 'BUDG_GUBUN',
                comboType: 'AU',
                comboCode: 'A170',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('BUDG_GUBUN', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },
	        Unilite.popup('BUDG_KOCIS_NORMAL',{
		        fieldLabel: '예산과목',
			    valueFieldName:'BUDG_CODE',
			    textFieldName:'BUDG_NAME',
		        //validateBlank:false,
				listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME', newValue);             
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue('IWALL_YYYYMM')).substring(0, 4)}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
		    })]	
		}]
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
            fieldLabel: '이월년월', 
            xtype: 'uniMonthfield',
            name: 'IWALL_YYYYMM',
            width:245,
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('IWALL_YYYYMM', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            name: 'AC_GUBUN',
            comboType: 'AU',
            comboCode: 'A390',
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_GUBUN', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '이월/불용승인 구분',
            labelWidth:120,
            name: 'BUDG_GUBUN',
            comboType: 'AU',
            comboCode: 'A170',
            allowBlank: false,
            width:250,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('BUDG_GUBUN', newValue);
                }
            }
        },{
        	
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            tdAttrs: {align : 'right',width:'100%'},
            items :[{
                xtype: 'button',
                text: '결재상신',
                width: 110, 
                handler : function() {
                	var records = detailStore.data.items;
                	
                	var cnt = 0;
                	Ext.each(records, function(record, i){
                		if(record.phantom == true){
                			cnt = 1;
                			return false;
                		}
                	})
                	
                	if(cnt == 0){
                	
                        if(!Ext.isEmpty(records)){
                        	if(detailStore.data.items[0].phantom == false){
                        	
                            	if(records[0].get('STATUS') == '0'){
                                    openDocDetailTab_GW("6",records[0].get('DOC_NO'),null);
                            		
//                            		alert(records[0].get('DOC_NO'));
                            	}else{
                                    alert('결재상태를 확인해주십시오.');
                            	}
                            }
                    	}else{
                            alert('결재상신할 데이터가 없습니다.');
                        }
                        
                    }else{
                        alert('저장 후 진행해 주십시오.');
                    }
        /*        	
                    var selectRecord = detailGrid.getSelectedRecord();
                    if(!Ext.isEmpty(selectRecord)){
                        if(selectRecord.get('STATUS') == '0'){
                            openDocDetailTab_GW("6",selectRecord.get('DOC_NO'),null);
                       }else{
                            alert('결재상태를 확인해주십시오.');
                       }
                    }else{
                        alert('결재상신할 데이터가 없습니다.');
                    }*/
                }
            }]
        },{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },
        Unilite.popup('BUDG_KOCIS_NORMAL',{
            fieldLabel: '예산과목',
            valueFieldName:'BUDG_CODE',
            textFieldName:'BUDG_NAME',
            //validateBlank:false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME', newValue);             
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue('IWALL_YYYYMM')).substring(0, 4)}),
                    popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        })]
	});
	
	var refSearch = Unilite.createSearchForm('refPopupForm', {		// 예산 참조
    	layout : {type : 'uniTable', columns : 2},
        items:[/*{
    		fieldLabel: '예산년', 
    		xtype: 'uniMonthfield',
    		name: 'BUDG_YYYYMM',
            allowBlank: false,
            readOnly: true
    	},*/{
            xtype: 'uniYearField',
            fieldLabel: '예산년도',
            name: 'AC_YEAR',
            allowBlank:false
        },{
            xtype: 'uniCombobox',
            name: 'BUDG_TYPE',
            comboType:'AU',
			comboCode:'A132',
            fieldLabel: '수지구분',
        	value: '2',
            allowBlank:false,
            readOnly: true
        },
        Unilite.popup('BUDG_KOCIS_NORMAL',{
            fieldLabel: '예산과목',
            valueFieldName:'BUDG_CODE_FR',
            textFieldName:'BUDG_NAME_FR',
            autoPopup:true,
            //validateBlank:false,
            listeners: {
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': refSearch.getValue('AC_YEAR')}),//UniDate.getDbDateStr(panelResult.getValue('BUDG_YYYYMM')).substring(0, 4)}),
                    popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        }),
        Unilite.popup('BUDG_KOCIS_NORMAL',{
            fieldLabel: '~',
            valueFieldName:'BUDG_CODE_TO',
            textFieldName:'BUDG_NAME_TO',
            autoPopup:true,
            //validateBlank:false,
            listeners: {
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': refSearch.getValue('AC_YEAR')}),//UniDate.getDbDateStr(panelResult.getValue('BUDG_YYYYMM')).substring(0, 4)}),
                    popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        })
		]
    });
	
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var detailGrid = Unilite.createGrid('Afb510Grid1', {
    	tbar: [{
            itemId: 'MoveReleaseBtn',
            text: '예산참조',
            handler: function() {
                if(!panelResult.getInvalidMessage()) return;   //필수체크
                
                if(!Ext.isEmpty(UserInfo.deptCode)){
                    if(UserInfo.deptCode == '01'){
                        panelSearch.getForm().getFields().each(function(field){
                            if (
                                field.name == 'BUDG_GUBUN' ||
                                field.name == 'AC_GUBUN' ||
                                field.name == 'IWALL_YYYYMM' ||
                                field.name == 'DEPT_CODE'
                            ){
                                field.setReadOnly(true);
                            }
                        });
                        panelResult.getForm().getFields().each(function(field){
                            if (
                                field.name == 'BUDG_GUBUN' ||
                                field.name == 'AC_GUBUN' ||
                                field.name == 'IWALL_YYYYMM' ||
                                field.name == 'DEPT_CODE'
                            ){
                                field.setReadOnly(true);
                            }
                        });
                    }else{
                        panelSearch.getForm().getFields().each(function(field){
                            if (
                                field.name == 'BUDG_GUBUN' ||
                                field.name == 'AC_GUBUN' ||
                                field.name == 'IWALL_YYYYMM' 
                            ){
                                field.setReadOnly(true);
                            }
                        });
                        panelResult.getForm().getFields().each(function(field){
                            if (
                                field.name == 'BUDG_GUBUN' ||
                                field.name == 'AC_GUBUN' ||
                                field.name == 'IWALL_YYYYMM' 
                            ){
                                field.setReadOnly(true);
                            }
                        });
                    }
                }
                openRefWindow();
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
    		}
    	],
    	layout : 'fit',
        region : 'center',
		store: detailStore,
		uniOpt : {
			useMultipleSorting	: true,			 
    		useLiveSearch		: false,			
    		onLoadSelectFirst	: false,		
    		dblClickToEdit		: false,		
    		useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: false,		
			useRowContext		: false,	// rink 항목이 있을경우만 true			
			filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
		selModel:'rowmodel',
        columns: [
        
            { dataIndex: 'BUDG_GUBUN'             ,width:80},
            { dataIndex: 'AC_GUBUN'               ,width:80,hidden:true},
            { dataIndex: 'STATUS'                 ,width:80},
            { dataIndex: 'DEPT_CODE'              ,width:100,hidden:true},
            { dataIndex: 'DEPT_NAME'              ,width:100},
            { dataIndex: 'ACCT_NO'               ,width:100},
            { dataIndex: 'BUDG_CODE'              ,width:170,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },
            { dataIndex: 'BUDG_NAME_1'            ,width:150},
            { dataIndex: 'BUDG_NAME_4'            ,width:150},
            { dataIndex: 'BUDG_NAME_6'            ,width:150},
            { dataIndex: 'IWALL_YYYYMM'           ,width:100},
            { dataIndex: 'IWALL_AMT_I'            ,width:150},
            
            { dataIndex: 'DOC_NO'             ,width:80,hidden:true},
            { dataIndex: 'SEQ'             ,width:80,hidden:true}
        ],
        listeners: {
//	        beforeedit  : function( editor, e, eOpts ) {
//	        	if(!e.record.phantom) {
//	        		if(UniUtils.indexOf(e.field, ['BUDG_CONF_I', 'BUDG_CONF_I01', 'BUDG_CONF_I02', 'BUDG_CONF_I03', 'BUDG_CONF_I04', 'BUDG_CONF_I05', 'BUDG_CONF_I06',
//	        									  'BUDG_CONF_I07', 'BUDG_CONF_I08', 'BUDG_CONF_I09', 'BUDG_CONF_I10', 'BUDG_CONF_I11', 'BUDG_CONF_I12'])) 
//					{ 
//						return true;
//      				} else {
//      					return false;
//      				}
//	        	} else {
//	        		if(UniUtils.indexOf(e.field, ['BUDG_CONF_I', 'BUDG_CONF_I01', 'BUDG_CONF_I02', 'BUDG_CONF_I03', 'BUDG_CONF_I04', 'BUDG_CONF_I05', 'BUDG_CONF_I06',
//	        									  'BUDG_CONF_I07', 'BUDG_CONF_I08', 'BUDG_CONF_I09', 'BUDG_CONF_I10', 'BUDG_CONF_I11', 'BUDG_CONF_I12']))
//				   	{
//						return true;
//      				} else {
//      					return false;
//      				}
//	        	}
//	        }
		},
		setEstiData: function(record) {						// 예산참조 셋팅
       		var grdRecord = this.getSelectedRecord();
//       		grdRecord.set('COMP_CODE'		, UserInfo.compCode);
//			Ext.each(budgNameList, function(item, index) {
//				var name = 'BUDG_NAME_L'+(index + 1);
//				grdRecord.set(name	,record[name]);
//			});
       		
       		grdRecord.set('COMP_CODE'              , record['COMP_CODE']);
            grdRecord.set('DEPT_CODE'              , record['DEPT_CODE']);
            grdRecord.set('DEPT_NAME'              , record['DEPT_NAME']);
            
            grdRecord.set('BUDG_GUBUN'             , panelResult.getValue('BUDG_GUBUN'));
            grdRecord.set('AC_GUBUN'               , panelResult.getValue('AC_GUBUN'));
            grdRecord.set('IWALL_YYYYMM'           , UniDate.getDbDateStr(panelResult.getValue('IWALL_YYYYMM')).substring(0, 6));  
            
            grdRecord.set('ACCT_NO'                , record['ACCT_NO']);
            grdRecord.set('BUDG_CODE'              , record['BUDG_CODE']);
            grdRecord.set('BUDG_NAME_1'            , record['BUDG_NAME_1']);
            grdRecord.set('BUDG_NAME_4'            , record['BUDG_NAME_4']);
            grdRecord.set('BUDG_NAME_6'            , record['BUDG_NAME_6']);
            grdRecord.set('IWALL_AMT_I'             , record['BUDG_TOT_I_EDIT']);
       		
       		
       		/*
			grdRecord.set('BUDG_YYYYMM'		, record['BUDG_YYYYMM']);
			grdRecord.set('DEPT_CODE'		, record['DEPT_CODE']);
			grdRecord.set('DEPT_NAME'		, record['DEPT_NAME']);
			grdRecord.set('BUDG_CODE'		, record['BUDG_CODE']);
			grdRecord.set('BUDG_NAME'		, record['BUDG_NAME']);
			grdRecord.set('IWALL_YYYYMM'	, record['IWALL_YYYYMM']);
			grdRecord.set('IWALL_AMT_I'		, record['BUDG_AMT_I']);
			grdRecord.set('IWALL_DATE'		, UniDate.get('today'));
			grdRecord.set('USER_CODE'		, chargeInfoList[0].CHARGE_CODE);
			grdRecord.set('USER_NAME'		, chargeInfoList[0].CHARGE_NAME);*/
		}                
    });
    
    function openRefWindow() {    	//편성예산 참조	
  		/*refSearch.setValue('BUDG_YYYYMM', panelSearch.getValue('BUDG_YYYYMM'));
  		refSearch.setValue('BUDG_CODE_FR', panelSearch.getValue('BUDG_CODE'));
  		refSearch.setValue('BUDG_NAME_FR', panelSearch.getValue('BUDG_ANME'));
  		refSearch.setValue('BUDG_CODE_TO', panelSearch.getValue('BUDG_CODE'));
  		refSearch.setValue('BUDG_NAME_TO', panelSearch.getValue('BUDG_NAME'));
  		refSearch.setValue('BUDG_TYPE', panelSearch.getValue('BUDG_TYPE'));   	
  		refStore.loadStoreRecords();*/
  		
		if(!refWindow) {
			refWindow = Ext.create('widget.uniDetailWindow', {
                title: '예산참조',
                width: 1000,				                
                height: 650,
                layout:{type:'vbox', align:'stretch'},
                
                items: [refSearch, refGrid],
                tbar:  [
					{	itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							refStore.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '적용',
						handler: function() {
							refGrid.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '적용 후 닫기',
						handler: function() {
							refGrid.returnData();
							refWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},'->',{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							refWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{
                		refSearch.clearForm();
                		refGrid.reset();
                        refStore.clearData();
                	},
                	beforeclose: function(panel, eOpts) {
						refSearch.clearForm();
                		refGrid.reset();
                		refStore.clearData();
                	},
                	beforeshow: function (me, eOpts)	{
//                		refSearch.setValue('AC_YEAR', UniDate.getDbDateStr(panelResult.getValue('IWALL_YYYYMM')).substring(0, 4));
                		refSearch.setValue('AC_YEAR', UniDate.getDbDateStr(UniDate.add(UniDate.today(),{years: -1})).substring(0, 4));
                        refSearch.setValue('BUDG_CODE_FR', panelResult.getValue('BUDG_CODE'));
                        refSearch.setValue('BUDG_NAME_FR', panelResult.getValue('BUDG_NAME'));
                        refSearch.setValue('BUDG_CODE_TO', panelResult.getValue('BUDG_CODE'));
                        refSearch.setValue('BUDG_NAME_TO', panelResult.getValue('BUDG_NAME'));
                        refSearch.setValue('BUDG_TYPE', '2');
//                        refStore.loadStoreRecords();
                		
//                		refSearch.setValue('AC_YYYY', panelSearch.getValue('AC_YYYY'));
//				  		refSearch.setValue('BUDG_CODE_FR', panelSearch.getValue('BUDG_CODE'));
//				  		refSearch.setValue('BUDG_NAME_FR', panelSearch.getValue('BUDG_NAME'));
//				  		refSearch.setValue('BUDG_CODE_TO', panelSearch.getValue('BUDG_CODE'));
//				  		refSearch.setValue('BUDG_NAME_TO', panelSearch.getValue('BUDG_NAME'));
//				  		refSearch.setValue('BUDG_TYPE', panelSearch.getValue('BUDG_TYPE'));   
//				  		refStore.loadStoreRecords();
        			}
                }
			})
		}
        refWindow.center();
		refWindow.show();
    }
    
    var refGrid = Unilite.createGrid('Afb510Grid2', {		// 편성예산참조
    	features: [{
    			id: 'detailGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: false
    		},{
    			id: 'detailGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: false
    		}
    	],
    	layout : 'fit',
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                    
                    selectRecord.set('BUDG_TOT_I_EDIT',selectRecord.data.BUDG_TOT_I);
                    
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                    
                    selectRecord.set('BUDG_TOT_I_EDIT',0);
                  
                }
            }
        }), 
		store: refStore,
		uniOpt: {						
			useMultipleSorting	: true,			
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: false,				
		    dblClickToEdit		: true,			
		    useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: false,			
			useRowContext		: false,		
		    filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}
        },
        columns: [
            { dataIndex: 'COMP_CODE'             ,width:100,hidden:true},
            { dataIndex: 'DEPT_CODE'             ,width:100,hidden:true},
            { dataIndex: 'DEPT_NAME'             ,width:100,hidden:true},
            { dataIndex: 'ACCT_NO'               ,width:100},
            { dataIndex: 'BUDG_CODE'             ,width:170,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },
            { dataIndex: 'BUDG_NAME_1'           ,width:150},
            { dataIndex: 'BUDG_NAME_4'           ,width:150},
            { dataIndex: 'BUDG_NAME_6'           ,width:150},
            { dataIndex: 'BUDG_TOT_I'            ,width:120},
            { dataIndex: 'BUDG_TOT_I_EDIT'       ,width:120}
            
        ],
        listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['BUDG_TOT_I_EDIT'])) { 
					return true;
  				} else {
  					return false;
  				}
	        }
        },
        returnData: function()  {
//              var records = this.getSelectedRecords();
            var records = this.getSelectedRecords();
            Ext.each(records, function(record,i){   
                UniAppManager.app.onNewDataButtonDown();
                detailGrid.setEstiData(record.data);                                        
            }); 
//            this.deleteSelectedRow();
//            this.getStore().remove(records);
            this.deleteSelectedRow();
        }
       	/*returnData: function()	{
			//detailGrid.reset();
       		var records = this.getSelectedRecords();
       		Ext.each(records, function(record,i) {	
       			
       			var mainRecords = detailStore.data.items;
                Ext.each(mainRecords, function(mainRecord, i){
                    if(mainRecord.phantom === true){ 
                        if(record.get('BUDG_CODE') == mainRecord.get('BUDG_CODE')){
                           var values = values - mainRecord.get('IWALL_AMT_I');
                        }
                    }
                })
                
		       	UniAppManager.app.onNewDataButtonDown();
		       	detailGrid.setEstiData(record.data);
		       	
		       	
		    }); 
			this.getStore().remove(records);
       	}*/
    });
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailGrid, panelResult
			]
		},
			panelSearch  	
		], 
		id : 'Afb510App',
		fnInitBinding : function() {
            UniAppManager.app.fnInitInputFields(); 
		},
		onQueryButtonDown : function()	{
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			detailStore.saveStore();
//			MasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitInputFields();
		},
		onNewDataButtonDown: function()	{		// 행추가 
			
			detailGrid.createRow();
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow1 = detailGrid.getSelectedRecord();
			if(selRow1.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailGrid.deleteSelectedRow();
			}
		},
		fnInitInputFields: function(){
			var activeSForm;
            if(!UserInfo.appOption.collapseLeftSearch) {
                activeSForm = panelSearch;
            } else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('IWALL_YYYYMM');
            panelSearch.setValue('IWALL_YYYYMM', UniDate.get('today'));
            panelResult.setValue('IWALL_YYYYMM', UniDate.get('today'));
            UniAppManager.setToolbarButtons('reset',false);
			
            panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
            panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
            
            if(!Ext.isEmpty(UserInfo.deptCode)){
                if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                    panelResult.getField('DEPT_CODE').setReadOnly(false);
                }else{
                    panelSearch.getField('DEPT_CODE').setReadOnly(true);
                    panelResult.getField('DEPT_CODE').setReadOnly(true);
                }
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
            }
            
            panelSearch.getField('BUDG_GUBUN').setReadOnly(false);
            panelSearch.getField('AC_GUBUN').setReadOnly(false);
            panelSearch.getField('IWALL_YYYYMM').setReadOnly(false);
            panelResult.getField('BUDG_GUBUN').setReadOnly(false);
            panelResult.getField('AC_GUBUN').setReadOnly(false);
            panelResult.getField('IWALL_YYYYMM').setReadOnly(false);
            
            
            UniAppManager.setToolbarButtons(['save'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
		}
		
	});

	Unilite.createValidator('validator01', {
		store: refStore,
		grid: refGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "BUDG_TOT_I_EDIT" :			// 이월예산
					if(record.get('BUDG_TOT_I') < newValue) {
						
                        rv="이월예산금액이 이월가능금액보다 클 수 없습니다.";
						break;
					}
				break;
			}
			return rv;
		}
	})
};
</script>