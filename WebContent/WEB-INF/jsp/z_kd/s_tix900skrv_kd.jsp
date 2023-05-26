<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_tix900skrv_kd"  >
	<t:ExtComboStore comboType="BOR120"  /> 				            <!-- 사업장 -->   
    <t:ExtComboStore comboType="AU" comboCode="T005" />                 <!-- 가격조건  -->
    <t:ExtComboStore comboType="AU" comboCode="T071" />                 <!--진행구분-->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {
    gsDefaultMoney      : '${gsDefaultMoney}'
};

function appMain() {
    
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_tix900skrv_kdService.selectList'
		}
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_tix900skrv_kdModel', {
	    fields: [
	    	{name: 'COMP_CODE'          ,text: '법인코드' 		      ,type: 'string'},
	    	{name: 'DIV_CODE'           ,text: '사업장'               ,type: 'string'},
            {name: 'OFFER_NO'           ,text: 'OFFER번호'            ,type: 'string'},
            {name: 'SEQ'                ,text: '순번'                 ,type: 'int'},
            {name: 'CHARGE_TYPE'        ,text: '경비구분'             ,type: 'string', comboType: "AU", comboCode: "T071"},
            {name: 'CHARGE_CODE'        ,text: '경비코드'             ,type: 'string'},
            {name: 'CHARGE_NAME'        ,text: '경비명'               ,type: 'string'},
            {name: 'AMT_CHARGE'         ,text: '공가불액'             ,type: 'uniPrice'},
            {name: 'SUPPLY_AMT'         ,text: '지급액'               ,type: 'uniPrice'},
            {name: 'BALANCE_AMT'        ,text: '잔액'                 ,type: 'uniPrice'},
            {name: 'ENTRY_DATE'         ,text: '입력일자'             ,type: 'uniDate'},
            {name: 'REMARK'             ,text: '비고'                 ,type: 'string'},
            {name: 'INSERT_DB_USER'     ,text: 'INSERT_DB_USER'       ,type: 'string'},
            {name: 'INSERT_DB_TIME'     ,text: 'INSERT_DB_TIME'       ,type: 'uniDate'},
            {name: 'UPDATE_DB_USER'     ,text: 'UPDATE_DB_USER'       ,type: 'string'},
            {name: 'UPDATE_DB_TIME'     ,text: 'UPDATE_DB_TIME'       ,type: 'uniDate'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('s_tix900skrv_kdMasterStore',{
			model: 's_tix900skrv_kdModel',
			uniOpt : {
            	isMaster: true,			    // 상위 버튼 연결
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			    // prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			}
		});

	/**
	 * 검색조건 (Search Panel)
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
				fieldLabel: '사업장',
				name:'DIV_CODE',	
				xtype: 'uniCombobox',
				comboType:'BOR120',
                holdable: 'hold',
                allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				} 
			},
			Unilite.popup('INCOM_OFFER', {     //수입 OFFER 관리번호
                fieldLabel: 'OFFER번호',
                id: 'INCOM_OFFER',
                holdable: 'hold',
                allowBlank: false,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('OFFER_NO', panelSearch.getValue('OFFER_NO'));
                            UniAppManager.app.onQueryButtonDown();
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('OFFER_NO', '');
                        panelResult.setValue('OFFER_NO', '');
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE':  panelSearch.getValue('DIV_CODE')});
                    }
                }
            }),{
                xtype: 'component',
                tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' }
            },
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
                holdable: 'hold',
                readOnly: true,
                extParam: {'CUSTOM_TYPE': ['1','2']},  
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
                            panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('CUSTOM_CODE', '');
                        panelSearch.setValue('CUSTOM_NAME', '');
                    }
                }
            }),{ 
                name: 'TERMS_PRICE',         
                fieldLabel: '가격조건',      
                xtype:'uniCombobox',   
                comboType:'AU', 
                comboCode:'T005',
                holdable: 'hold',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('TERMS_PRICE', newValue);
                    }
                } 
            },{
                fieldLabel: 'OFFER일자',
                name: 'DATE_DEPART',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                holdable: 'hold',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DATE_DEPART', newValue);
                    }
                }
            },{
                fieldLabel: '입고예정일',
                name: 'DELIVERY_DATE',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                holdable: 'hold',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DELIVERY_DATE', newValue);
                    }
                }
            },{
                fieldLabel: '화폐', 
                name: 'MONEY_UNIT', 
                xtype: 'uniCombobox', 
                comboType: 'AU', 
                comboCode: 'B004',
                displayField: 'value',
                holdable: 'hold',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('MONEY_UNIT', newValue);
//                        UniAppManager.app.fnExchngRateO();
                    }
                }
            },{
                fieldLabel: '환율',
                name:'EXCHG_RATE_O',
                xtype: 'uniNumberfield',
                holdable: 'hold',
                readOnly: true,
                decimalPrecision: 4,
                value: 1,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('EXCHG_RATE_O', newValue);
                    }
                }
            },{
                name: 'SO_AMT',
                fieldLabel: '화폐금액',
                xtype:'uniNumberfield',
                flex: 2,
                value: 0,
                holdable: 'hold',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('SO_AMT', newValue);
                    }
                }
            },{
                name: 'SO_AMT_WON',
                fieldLabel: '자사금액',
                xtype:'uniNumberfield',
                flex: 2,
                value: 0,
                holdable: 'hold',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('SO_AMT_WON', newValue);
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
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
        api:{
            load:'s_tix900skrv_kdService.selectFormMaster'
        },
	    items :[{                  
                fieldLabel: '사업장',
                name:'DIV_CODE',    
                xtype: 'uniCombobox',
                comboType:'BOR120',
                holdable: 'hold',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                } 
            },
            Unilite.popup('INCOM_OFFER', {     //수입 OFFER 관리번호
                fieldLabel: 'OFFER번호',
                id: 'INCOM_OFFER2',
                holdable: 'hold',
                allowBlank: false,
                colspan: 3,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('OFFER_NO', panelResult.getValue('OFFER_NO'));
                            UniAppManager.app.onQueryButtonDown();
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('OFFER_NO', '');
                        panelResult.setValue('OFFER_NO', '');
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE':  panelSearch.getValue('DIV_CODE')});
                    }
                }
            }),{
                xtype: 'component',
                tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' },
                colspan: 4
            },
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
                holdable: 'hold',
                readOnly: true,
                extParam: {'CUSTOM_TYPE': ['1','2']},  
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
                            panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('CUSTOM_CODE', '');
                        panelResult.setValue('CUSTOM_NAME', '');
                    }
                }
            }),{
                fieldLabel: 'OFFER일자',
                name: 'DATE_DEPART',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                holdable: 'hold',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DATE_DEPART', newValue);
                    }
                }
            },{
                fieldLabel: '화폐', 
                name: 'MONEY_UNIT', 
                xtype: 'uniCombobox', 
                comboType: 'AU', 
                comboCode: 'B004',
                displayField: 'value',
                holdable: 'hold',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('MONEY_UNIT', newValue);
//                        UniAppManager.app.fnExchngRateO();
                    }
                }
            },{
                name: 'SO_AMT',
                fieldLabel: '화폐금액',
                xtype:'uniNumberfield',
                flex: 2,
                value: 0,
                holdable: 'hold',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('SO_AMT', newValue);
                    }
                }
            },{ 
                name: 'TERMS_PRICE',         
                fieldLabel: '가격조건',      
                xtype:'uniCombobox',   
                comboType:'AU', 
                comboCode:'T005',
                holdable: 'hold',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('TERMS_PRICE', newValue);
                    }
                } 
            },{
                fieldLabel: '입고예정일',
                name: 'DELIVERY_DATE',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                holdable: 'hold',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DELIVERY_DATE', newValue);
                    }
                }
            },{
                fieldLabel: '환율',
                name:'EXCHG_RATE_O',
                xtype: 'uniNumberfield',
                holdable: 'hold',
                readOnly: true,
                decimalPrecision: 4,
                value: 1,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('EXCHG_RATE_O', newValue);
                    }
                }
            },{
                name: 'SO_AMT_WON',
                fieldLabel: '자사금액',
                xtype:'uniNumberfield',
                flex: 2,
                value: 0,
                holdable: 'hold',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('SO_AMT_WON', newValue);
                    }
                }
            }
        ],
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
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_tix900skrv_kdGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        sortableColumns : false,
    	store: MasterStore,
        tbar: [{                  
            itemId : 'GWBtn',
            id:'GW1',
            iconCls : 'icon-referance'  ,
            text: '기안',
            margin:'0 0 0 100',
            handler: function() {
                            
                if(!panelResult.setAllFieldsReadOnly(true)){
                    return false;
                }
                
                var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
                
                var frm         = document.f1;
                var compCode    = UserInfo.compCode;
                var divCode     = panelResult.getValue('DIV_CODE');
                var offerNo     = panelResult.getValue('OFFER_NO');
                var gubun1      = 'O';
                var gubun2      = 'M';
                var spText1     = 'EXEC omegaplus_kdg.unilite.USP_GW_S_TIX900SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + offerNo + "'" + ', ' + "'" + gubun1 + "'";
                var spText2     = 'EXEC omegaplus_kdg.unilite.USP_GW_S_TIX900SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + offerNo + "'" + ', ' + "'" + gubun2 + "'";
                var spCall      = encodeURIComponent(spText1 + "^" + spText2);

    //            frm.action = '/payment/payreq.php';
                frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_tix900skrv_kd&draft_no=" + '0' + "&sp=" + spCall;
    //            frm.action   = groupUrl + "&prg_no=s_ssa901rkrv_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
                frm.target   = "payviewer"; 
                frm.method   = "post";
                frm.submit();
            } 
        }],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
			//20191120: 그리드 합계 사용 - 공가불액, 지불액
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns:  [        
        	{ dataIndex: 'COMP_CODE'               , 		    width: 100, hidden: true},
            { dataIndex: 'DIV_CODE'                ,            width: 140, hidden: true},
            { dataIndex: 'OFFER_NO'                ,            width: 100, hidden: true},
            { dataIndex: 'SEQ'                     ,            width: 100, hidden: true},
            { dataIndex: 'CHARGE_TYPE'             ,            width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
				}},
            { dataIndex: 'CHARGE_CODE'             ,            width: 100},
            { dataIndex: 'CHARGE_NAME'             ,            width: 200},
            { dataIndex: 'AMT_CHARGE'              ,            width: 130, summaryType: 'sum'},
            { dataIndex: 'SUPPLY_AMT'              ,            width: 130, summaryType: 'sum'},
            { dataIndex: 'BALANCE_AMT'             ,            width: 130},
            { dataIndex: 'ENTRY_DATE'              ,            width: 100},
            { dataIndex: 'REMARK'                  ,            width: 300},
            { dataIndex: 'INSERT_DB_USER'          ,            width: 100, hidden: true},
            { dataIndex: 'INSERT_DB_TIME'          ,            width: 100, hidden: true},
            { dataIndex: 'UPDATE_DB_USER'          ,            width: 100, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'          ,            width: 100, hidden: true}
        ]
    });   
	
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, panelResult
			]	
		}		
		, panelSearch
		],
		id  : 's_tix900skrv_kdApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
            this.setDefault();
		},
		onQueryButtonDown : function()	{			
			if(panelSearch.setAllFieldsReadOnly(true) == false) {
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
			var param = panelResult.getValues();
            panelResult.uniOpt.inLoading = true;
            Ext.getBody().mask('로딩중...','loading-indicator');
            panelResult.getForm().load(
            {
                params:param,
                success:function(form, action)  {
                    console.log(action.result.data);
                    //var
                    //not syn
                    if(action.result.data){
                        panelSearch.setValues({
                            'CUSTOM_CODE'   : panelResult.getValue('CUSTOM_CODE'),
                            'CUSTOM_NAME'   : panelResult.getValue('CUSTOM_NAME'),
                            'DATE_DEPART'   : panelResult.getValue('DATE_DEPART'),
                            'MONEY_UNIT'    : panelResult.getValue('MONEY_UNIT'),
                            'SO_AMT'        : panelResult.getValue('SO_AMT'),
                            'TERMS_PRICE'   : panelResult.getValue('TERMS_PRICE'),
                            'DELIVERY_DATE' : panelResult.getValue('DELIVERY_DATE'),
                            'EXCHG_RATE_O'  : panelResult.getValue('EXCHG_RATE_O'),
                            'SO_AMT_WON'    : panelResult.getValue('SO_AMT_WON')                                
                        });
                        masterGrid.getStore().loadStoreRecords();
                        
                    }else{
                    	
                    }
                    Ext.getBody().unmask();
                    panelResult.uniOpt.inLoading = false;
                },
                failure:function(batch, option){
                    Ext.getBody().unmask();
                    panelResult.uniOpt.inLoading = false;
                }                   
            });
			UniAppManager.setToolbarButtons(['reset'], true); 
		},
		onResetButtonDown: function() {     // 초기화
            this.suspendEvents();
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            MasterStore.clearData();
            this.setDefault();
        },
        setDefault: function() {        // 기본값
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('MONEY_UNIT', BsaCodeInfo.gsDefaultMoney);
            panelResult.setValue('MONEY_UNIT', BsaCodeInfo.gsDefaultMoney);
            panelSearch.setValue('DATE_DEPART', UniDate.get('today'));
            panelResult.setValue('DATE_DEPART', UniDate.get('today'));
            panelSearch.setValue('DELIVERY_DATE', UniDate.get('today'));
            panelResult.setValue('DELIVERY_DATE', UniDate.get('today'));
            panelSearch.setValue('SO_AMT', '0');
            panelResult.setValue('SO_AMT', '0');
            panelSearch.setValue('SO_AMT_WON', '0');
            panelResult.setValue('SO_AMT_WON', '0');
            panelSearch.getForm().wasDirty = false;
            panelSearch.resetDirtyStatus();                            
            UniAppManager.setToolbarButtons(['reset', 'save'], false); 
        }/*,
        fnExchngRateO:function(isIni) {
            var param = {
                "AC_DATE"    : UniDate.getDbDateStr(panelSearch.getValue('INOUT_DATE')),
                "MONEY_UNIT" : panelSearch.getValue('MONEY_UNIT')
            };            
            salesCommonService.fnExchgRateO(param, function(provider, response) {   
                if(!Ext.isEmpty(provider)){
                    if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')) && panelSearch.getValue('MONEY_UNIT') != "KRW"){
                        alert('환율정보가 없습니다.')
                    }
                    panelSearch.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
                    panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
                }
                
            });
        }*/
	});

};
		
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>