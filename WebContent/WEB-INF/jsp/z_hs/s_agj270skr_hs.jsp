<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agj270skr_hs"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A011" /> <!-- 입력경로 -->      
	<t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 승인상태 -->
	<t:ExtComboStore comboType="AU" comboCode="A023" /> <!--결의회계구분-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var printType = '';

function appMain() {
	var baseInfo = {			
			'gsChargeCode'	: '${chargeCode}',
			'gsChargePNumb'	: '${chargePNumb}',
			'gsChargeName'	: '${chargeName}',
			'gsChargeDivi'  : '${chargeDivi}'=='1' ? false:true  //1:회계부서:2:현업부서	
		}
	
	var KeyValue  = '';
    
    var directReportProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 's_agj270skr_hsService.insertDetail',
            syncAll: 's_agj270skr_hsService.saveAll'
        }
    });
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_Agj270skr_hsModel1', {
		fields: [
			{name: 'AUTO_NUM'			,text: '자동채번' 	,type: 'string'},
	    	{name: 'AC_DATE'			,text: '전표일' 		,type: 'uniDate'},
	    	{name: 'SLIP_NUM'			,text: '번호' 		,type: 'string'},
	    	{name: 'EX_DATE'			,text: 'EX_DATE' 	,type: 'uniDate'},
	    	{name: 'EX_NUM'				,text: 'EX_NUM' 	,type: 'string'},
	    	{name: 'CUSTOM_NAME'		,text: '거래처명'    	,type: 'string'},
	    	{name: 'DR_AMT_I'			,text: '차변금액' 		,type: 'uniPrice'},
	    	{name: 'CR_AMT_I'			,text: '대변금액' 		,type: 'uniPrice'},
	    	{name: 'INPUT_PATH'			,text: '입력경로' 		,type: 'string' ,comboType:"AU", comboCode:"A011" },
	    	{name: 'CHARGE_NAME'		,text: '입력자' 		,type: 'string'},
	    	{name: 'INPUT_DATE'			,text: '입력일' 		,type: 'uniDate'},
	    	{name: 'AP_CHARGE_NAME'		,text: '승인자' 		,type: 'string'} ,
	    	{name: 'AP_DATE'			,text: '승인일' 		,type: 'uniDate'},
	    	{name: 'INPUT_DIVI'			,text: 'INPUT_DIVI' ,type: 'string'} 
		]
	});
	
	Unilite.defineModel('s_Agj270skr_hsModel2', {
		fields: [
	    	{name: 'EX_SEQ'			,text: '순번' 		,type: 'string'},
	    	{name: 'SLIP_SEQ'		,text: '순번' 		,type: 'string'},
	    	{name: 'SLIP_DIVI_NM'	,text: '차대구분' 		,type: 'string'},
	    	{name: 'ACCNT'			,text: '계정코드' 		,type: 'string'},
	    	{name: 'ACCNT_NAME'		,text: '계정과목명' 		,type: 'string'},  	
	    	{name: 'CUSTOM_NAME'	,text: '거래처명' 	    ,type: 'string'},
	    	{name: 'AMT_I'			,text: '금액' 		,type: 'uniPrice'},
	    	{name: 'MONEY_UNIT'		,text: '화폐' 		,type: 'string'},    	
	    	{name: 'EXCHG_RATE_O'	,text: '환율' 		,type: 'uniER'},
	    	{name: 'FOR_AMT_I'		,text: '외화금액' 		,type: 'uniFC'},
	    	{name: 'REMARK'			,text: '적요' 		,type: 'string'},
	    	{name: 'DEPT_CODE'		,text: '부서코드' 		,type: 'string'},
	    	{name: 'DEPT_NAME'		,text: '귀속부서' 		,type: 'string'},
	    	{name: 'DIV_NAME'		,text: '귀속사업장' 		,type: 'string'},
	    	{name: 'PROOF_KIND_NM'	,text: '증빙유형' 		,type: 'string'},
	    
	    	{name: 'POSTIT_YN'		,text: 'POSTIT_YN' 	,type: 'string'},
	    		
	    	/* Hidden */
	    	{name: 'AC_CODE1'		,text: 'AC_CODE1'	 	,type: 'string'},
	    	{name: 'AC_CODE2'		,text: 'AC_CODE2'	 	,type: 'string'},
	    	{name: 'AC_CODE3'		,text: 'AC_CODE3' 		,type: 'string'},
	    	{name: 'AC_CODE4'		,text: 'AC_CODE4' 		,type: 'string'},
	    	{name: 'AC_CODE5'		,text: 'AC_CODE5' 		,type: 'string'},
	    	{name: 'AC_CODE6'		,text: 'AC_CODE6' 		,type: 'string'},
	    	
	    	{name: 'AC_NAME1'		,text: 'AC_NAME1' 		,type: 'string'},
	    	{name: 'AC_NAME2'		,text: 'AC_NAME2' 		,type: 'string'},
	    	{name: 'AC_NAME3'		,text: 'AC_NAME3' 		,type: 'string'},
	    	{name: 'AC_NAME4'		,text: 'AC_NAME4' 		,type: 'string'},
	    	{name: 'AC_NAME5'		,text: 'AC_NAME5' 		,type: 'string'},
	    	{name: 'AC_NAME6'		,text: 'AC_NAME6' 		,type: 'string'},
	    	
	    	{name: 'AC_DATA1'		,text: 'AC_DATA1' 		,type: 'string'},
	    	{name: 'AC_DATA2'		,text: 'AC_DATA2' 		,type: 'string'},
	    	{name: 'AC_DATA3'		,text: 'AC_DATA3' 		,type: 'string'},
	    	{name: 'AC_DATA4'		,text: 'AC_DATA4' 		,type: 'string'},
	    	{name: 'AC_DATA5'		,text: 'AC_DATA5' 		,type: 'string'},
	    	{name: 'AC_DATA6'		,text: 'AC_DATA6'	 	,type: 'string'},
	    	
	    	{name: 'AC_DATA_NAME1'	,text: 'AC_DATA_NAME1' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME2'	,text: 'AC_DATA_NAME2' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME3'	,text: 'AC_DATA_NAME3' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME4'	,text: 'AC_DATA_NAME4' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME5'	,text: 'AC_DATA_NAME5' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME6'	,text: 'AC_DATA_NAME6' 	,type: 'string'},
	    	
	    	{name: 'AC_TYPE1'		,text: 'AC_TYPE1' 		,type: 'string'},
	    	{name: 'AC_TYPE2'		,text: 'AC_TYPE2' 		,type: 'string'},
	    	{name: 'AC_TYPE3'		,text: 'AC_TYPE3' 		,type: 'string'},
	    	{name: 'AC_TYPE4'		,text: 'AC_TYPE4' 		,type: 'string'},
	    	{name: 'AC_TYPE5'		,text: 'AC_TYPE5' 		,type: 'string'},
	    	{name: 'AC_TYPE6'		,text: 'AC_TYPE6' 		,type: 'string'},
	    	
	    	{name: 'AC_FORMAT1'		,text: 'AC_FORMAT1' 	,type: 'string'},
	    	{name: 'AC_FORMAT2'		,text: 'AC_FORMAT2' 	,type: 'string'},
	    	{name: 'AC_FORMAT3'		,text: 'AC_FORMAT3' 	,type: 'string'},
	    	{name: 'AC_FORMAT4'		,text: 'AC_FORMAT4' 	,type: 'string'},
	    	{name: 'AC_FORMAT5'		,text: 'AC_FORMAT5' 	,type: 'string'},
	    	{name: 'AC_FORMAT6'		,text: 'AC_FORMAT6' 	,type: 'string'},
	    	
	    	{name: 'AC_POPUP1' 		,text:'관리항목1팝업여부'		,type : 'string'}, 
			{name: 'AC_POPUP2'   	,text:'관리항목2팝업여부'		,type : 'string'},
			{name: 'AC_POPUP3'   	,text:'관리항목3팝업여부'		,type : 'string'}, 
			{name: 'AC_POPUP4'   	,text:'관리항목4팝업여부'		,type : 'string'}, 
			{name: 'AC_POPUP5'   	,text:'관리항목5팝업여부'		,type : 'string'}, 
			{name: 'AC_POPUP6'   	,text:'관리항목6팝업여부'		,type : 'string'} 
				
		]
	});			
	
    var reportStore = Unilite.createStore('s_Agj270skr_hsReportStore',{
        uniOpt: {
            isMaster: false,
            editable: false,
            deletable: false,
            useNavi: false
        },
        proxy: directReportProxy,
        saveStore: function() {
            config = {
            	useSavedMessage : false,
                success: function(batch, option) {                               
                    var resultValue = batch.operations[0].getResultSet();
                    KeyValue = resultValue[0].KEY_VALUE;
                    
                    var win = Ext.create('widget.CrystalReport', {
                        url: CPATH+'/accnt/agj270crkr.do',
                        prgID: 'agj270rkr_S3',
                            extParam: {
                                KEY_VALUE       : KeyValue,
                                FR_AC_DATE      : UniDate.getDbDateStr(panelSearch.getValue('FR_AC_DATE')),
                                TO_AC_DATE      : UniDate.getDbDateStr(panelSearch.getValue('TO_AC_DATE')),
                                SLIP_DIVI       : panelSearch.getValue('SLIP_DIVI'),
                                SLIP_NAME       : panelSearch.getField('SLIP_DIVI').getRawValue(),
                                PRINT_TYPE      : "S3",     
                                PGM_ID          : 'AGJ270SKR'
                            }
                        });
                        win.center();
                        win.show();
                        reportStore.clearData();
                 },
                 failure: function(batch, option) {
                    reportStore.clearData();
                 }
            };
            this.syncAllDirect(config);
        }
    });
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('s_agj270skr_hsDetailStore',{
		model: 's_Agj270skr_hsModel1',
		uniOpt : {
        	isMaster:	true,			// 상위 버튼 연결 
        	editable:	false,			// 수정 모드 사용 
        	deletable:	false,			// 삭제 가능 여부 
            useNavi:	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 's_agj270skr_hsService.selectList'
            }
        },
		loadStoreRecords : function()	{
			var form = Ext.getCmp('searchForm');
			var param= form.getValues();			
			console.log( param );
			if(form.isValid())	{
				detailForm.down('#formFieldArea1').removeAll();
				detailGrid.reset();
                detailStore.clearData();
				this.load({
					params : param
				});
			}
		},
		/*saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);
        	var rv = true;

        	
			if(inValidRecs.length == 0 )	{										
				config = {
						success: function(batch, option) {	
							
//                        reportStore.clearData();
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);								
							//directMasterStore.loadStoreRecords();	
							var resultValue = batch.operations[0].getResultSet();
							KeyValue = resultValue[0].KEY_VALUE;
							
							var win = Ext.create('widget.PDFPrintWindow', {
								url: CPATH+'/agj/agj270rkrPrint.do',
								prgID: 'agj270rkr_S3',
									extParam: {
										//AC_DATE			: acDate,
										KEY_VALUE       : KeyValue,
										FR_AC_DATE      : UniDate.getDbDateStr(panelSearch.getValue('FR_AC_DATE')),
										TO_AC_DATE		: UniDate.getDbDateStr(panelSearch.getValue('TO_AC_DATE')),
										SLIP_DIVI  		: panelSearch.getValue('SLIP_DIVI'),
										SLIP_NAME   	: panelSearch.getField('SLIP_DIVI').getRawValue(),
										PRINT_TYPE		: "S3",		
										PGM_ID			: 'AGJ270SKR'
									}
								});
								win.center();
								win.show();
						 } 
				};					
				this.syncAllDirect(config);
				
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},*/
		listeners:{
			load:function( store, records, successful, operation, eOpts ){
				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
				var viewNormal = masterGrid.getView();
				if(store.getCount() > 0){
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				}else{
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);	
				}
			}
		}
	});
	
	var detailStore = Unilite.createStore('s_agj270skr_hsDetailStore',{
			model: 's_Agj270skr_hsModel2',
			uniOpt : {
            	isMaster:	false,			// 상위 버튼 연결 
            	editable:	false,			// 수정 모드 사용 
            	deletable:	false,			// 삭제 가능 여부 
	            useNavi :	false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 's_agj270skr_hsService.selectList2'                	
                }
            },
            loadStoreRecords : function(record)	{
				 var searchParam = Ext.getCmp('searchForm').getValues();	 
				 if(!Ext.isEmpty(record)){
					 var param= {
					 	'AC_DATE': Ext.isEmpty(record.data.AC_DATE) ? '': UniDate.getDbDateStr(record.data.AC_DATE).substring(0.6),
						'SLIP_NUM':record.data.SLIP_NUM,
						'INPUT_PATH':record.data.INPUT_PATH
					};		
					
					var params = Ext.merge(searchParam, param);			
					console.log( param );
					this.load({
						params : params
					});
				}
			},
			listeners:{
				load: function(store, records, successful, eOpts) {
					if(!Ext.isEmpty(detailGrid.getSelectionModel())) {
						detailGrid.getSelectionModel().select(0);	
					}
					//masterGrid.focus();
				}
			} 
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
		    items : [{ 
    			fieldLabel: '전표일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_AC_DATE',
		        endFieldName: 'TO_AC_DATE',
		        width: 470,
		        allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
						panelResult.setValue('FR_AC_DATE',newValue);
			    	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_AC_DATE',newValue);
			    	}
			    }
	        }, { 
    			fieldLabel: '입력일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_IN_DATE',
		        endFieldName: 'TO_IN_DATE',
		        width: 470,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
							panelResult.setValue('FR_IN_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_IN_DATE',newValue);
			    	}
			    }
	        },{
		        fieldLabel: '사업장',
			    name:'DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
			    width: 325,
			    colspan:2,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
		    },   
		        Unilite.popup('DEPT',{
		        fieldLabel: '입력부서',
//		        validateBlank:false,
		    	valueFieldName:'IN_DEPT_CODE',
		    	textFieldName:'IN_DEPT_NAME',
	        	listeners: {
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					},
					onValueFieldChange:function( elm, newValue) {
						panelResult.setValue('IN_DEPT_CODE', newValue);
                	},
                	onTextFieldChange:function( elm, newValue) {
						panelResult.setValue('IN_DEPT_NAME', newValue);
                	}
				}
		    }),
	        	//CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
	        	Unilite.popup('ACCNT_PRSN',{
		        fieldLabel: '입력자',
//		        validateBlank:false,
		        autoPopup:true,
			    valueFieldName:'PRSN_CODE',
			    textFieldName:'PRSN_NAME',
			    readOnly : baseInfo.gsChargeDivi,
	        	listeners: {
	        		onValueFieldChange: function(field, newValue){
						panelResult.setValue('PRSN_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PRSN_NAME', newValue);				
					}
				}		        
		    }),{
		        fieldLabel: '입력경로',
			    name:'INPUT_PATH', 
			    xtype: 'uniCombobox',
//				multiSelect: true, 
//				typeAhead: false,
				comboType:'AU',
    			comboCode:'A011',
			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('INPUT_PATH', newValue);
					}
				}
		    },{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'회계번호', 
					xtype: 'uniTextfield',
					name: 'FR_SLIP_NUM', 
					width:195,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('FR_SLIP_NUM', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'TO_SLIP_NUM', 
					width: 110,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('TO_SLIP_NUM', newValue);
						}
					}
				}]
			}, {
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'결의번호', 
					xtype: 'uniTextfield',
					name: 'FR_EX_NUM', 
					width:195,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('FR_EX_NUM', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'TO_EX_NUM', 
					width: 110,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('TO_EX_NUM', newValue);
						}
					}
				}]
			},{
				fieldLabel: '전표구분',
				xtype: 'uniCombobox',
				name: 'SLIP_DIVI',
				comboType: 'AU',
				comboCode:'A023',
	        	allowBlank: false,
	        	value: '1',
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SLIP_DIVI', newValue);
					}
				}
			}
			,
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				extParam: {'CUSTOM_TYPE':'3'},
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				allowBlank:true,
				allowInputData:true,
				autoPopup:false,
				validateBlank:false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
						
						if(newValue == '') {
							panelResult.setValue('CUSTOM_NAME', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
						
						if(newValue == '') {
							panelResult.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':'3'});
					}
				}
			})]
		}, {	
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'금액', 
					xtype: 'uniTextfield',
					name: 'FR_AMT_I', 
					width:195
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'TO_AMT_I', 
					width: 110
				}]
			}, {
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'외화금액', 
					xtype: 'uniTextfield',
					name: 'FR_FOR_AMT_I', 
					width:195
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'TO_FOR_AMT_I', 
					width: 110
				}]
			},{
				fieldLabel: '승인여부',
				xtype: 'uniCombobox',
				name: 'AP_STS',
				comboType: 'AU',
				comboCode:'A014'
			}]		
		}]
	});  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
		region: 'north',
		layout : {type : 'uniTable', columns : 3
		},
		padding:'1 1 1 1',
		border:true,
		items : [{ 
			fieldLabel: '전표일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'FR_AC_DATE',
	        endFieldName: 'TO_AC_DATE',
	        //width: 470,
	        allowBlank: false,
	        tdAttrs: {width: 380},  
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
					panelSearch.setValue('FR_AC_DATE',newValue);
		    	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_AC_DATE',newValue);
		    	}
		    }
        },   
        	Unilite.popup('DEPT',{
	        fieldLabel: '입력부서',
//	        validateBlank:false,
		    valueFieldName:'IN_DEPT_CODE',
		    textFieldName:'IN_DEPT_NAME',
	        tdAttrs: {width: 380},  
        	listeners: {
				applyextparam: function(popup){							
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				},
				onValueFieldChange:function( elm, newValue) {
					panelSearch.setValue('IN_DEPT_CODE', newValue);
				},
				onTextFieldChange:function( elm, newValue) {
					panelSearch.setValue('IN_DEPT_NAME', newValue);
				}
			}
	    }),{
			fieldLabel: '사업장',
		    name:'DIV_CODE', 
		    xtype: 'uniCombobox',
			multiSelect: true, 
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
		    width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, { 
			fieldLabel: '입력일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'FR_IN_DATE',
	        endFieldName: 'TO_IN_DATE',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_IN_DATE',newValue);
                	}
			    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_IN_DATE',newValue);
		    	}
		    }
        },
        	Unilite.popup('ACCNT_PRSN',{
	        fieldLabel: '입력자',
//	        validateBlank:false,
	        autoPopup:true,
		    valueFieldName:'PRSN_CODE',
		    textFieldName:'PRSN_NAME',
		    readOnly : baseInfo.gsChargeDivi,
        	listeners: {
        		onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PRSN_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('PRSN_NAME', newValue);				
				}
			}		        
	    }),{
			fieldLabel: '입력경로',
		    name:'INPUT_PATH', 
		    xtype: 'uniCombobox',
//			multiSelect: true, 
//			typeAhead: false,
			comboType: 'AU',
			comboCode: 'A011',
		    width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('INPUT_PATH', newValue);
				}
			}
		},{
		    xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:325,
			items :[{
				fieldLabel:'회계번호', 
				xtype: 'uniTextfield',
				name: 'FR_SLIP_NUM', 
				width:195,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('FR_SLIP_NUM', newValue);
					}
				}
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniTextfield',
				name: 'TO_SLIP_NUM', 
				width: 110,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TO_SLIP_NUM', newValue);
					}
				}
			}]
		}, {
		    xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:325,
			items :[{
				fieldLabel:'결의번호', 
				xtype: 'uniTextfield',
				name: 'FR_EX_NUM', 
				width:195,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('FR_EX_NUM', newValue);
					}
				}
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniTextfield',
				name: 'TO_EX_NUM', 
				width: 110,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TO_EX_NUM', newValue);
					}
				}
			}]
		},{
			fieldLabel: '전표구분',
			xtype: 'uniCombobox',
			name: 'SLIP_DIVI',
			comboType: 'AU',
			comboCode:'A023',
			width: 172,
        	allowBlank: false,
        	value: '1',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SLIP_DIVI', newValue);
				}
			}
		}
		,
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				extParam: {'CUSTOM_TYPE':'3'},
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				allowBlank:true,
				allowInputData:true,
				autoPopup:false,
				validateBlank:false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);
						
						if(newValue == '') {
							panelResult.setValue('CUSTOM_NAME', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);
						
						if(newValue == '') {
							panelResult.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':'3'});
					}
				}
			})
		,{
			fieldLabel: '출력방식',
			    xtype: 'uniCheckboxgroup', 
			    width: 400, 
			    items: [{
			    	boxLabel: '건별출력',
			        name: 'EACH_PRINT',
			        inputValue: 'Y',
			        uncheckedValue: 'N'
				}]          		
   			}]
	});    
    
	/* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_agj270skr_hsGrid', {
        layout : 'fit',
        region:'center',
        flex: 3,
    	store: masterStore,
    	uniOpt : {
			useMultipleSorting	: true,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: false,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: true,			
	    	filter: {
				useFilter		: true,		
				autoCreate		: true		
			}
		},
        tbar:[
        	'->',
    	{
        	xtype:'button',
        	text:'전표출력',
        	handler:function()	{
        		printType = 'slip'; /* 전표  */
        		
        		if(masterGrid.getSelectedRecords().length > 0 ){
        			
        			UniAppManager.app.onPrintButtonDown(printType);
	    		}
	    		else{
	    			alert("선택된 자료가 없습니다.");
	    		}
    		}
    	}/*,{
        	xtype:'button',
        	text:'분개장출력',
        	handler:function()	{
        		printType = 'journal';  분개장 
        		
        		if(masterGrid.getSelectedRecords().length > 0 ){
	    			alert("분개장 출력 레포트를 만들어주세요.");
	    		}
	    		else{
	    			alert("선택된 자료가 없습니다.");
	    		}
    		}
    	}*//* ,{
        	xtype:'button',
        	text:'집계표출력',
        	handler:function()	{
        		printType = 'sheet';  // 집계표 
        		
        		if(masterGrid.getSelectedRecords().length > 0 ){
	    			UniAppManager.app.onPrintButtonDown(printType);
	    		}else{
	    			alert("선택된 자료가 없습니다.");
	    		}
    		}
    	} */],
        enableColumnHide :true,
        sortableColumns : false,
        border:true,
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false
        	/*listeners: {	
			select: function(grid, record, index, eOpts ){					
				var records = masterGrid.getSelectedRecords();
        			DetailStore.loadStoreRecords(records);
          	}
    	}*/
        }), 
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [ 
			{ dataIndex:'SEQ'				, 	width:50 ,	text : '순번',	align : 'center'},
	   		{ dataIndex:'AC_DATE'		 	, 	width:80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
		    	}
	   		}, 				
			{ dataIndex:'SLIP_NUM'			, 		width:50 ,	align : 'center'},
			{ dataIndex:'CUSTOM_NAME'		, 	    width:160},
			{ dataIndex:'DR_AMT_I'		 	, 		width:120,	summaryType: 'sum'}, 				
			{ dataIndex:'CR_AMT_I'		 	, 		width:120,	summaryType: 'sum'}, 				
			{ dataIndex:'INPUT_PATH'		, 		width:140},
			{ dataIndex:'CHARGE_NAME'		, 		width:120},
			{ dataIndex:'INPUT_DATE'		, 		width:100},
			{ dataIndex:'AP_CHARGE_NAME'	, 		width:100},
			{ dataIndex:'AP_DATE'			, 		width:100},
			{ dataIndex:'EX_NUM'			, 		width:100		, hidden: true},
			{ dataIndex:'EX_DATE'			, 		width:100		, hidden: true},
			{ dataIndex:'INPUT_DIVI'		, 		width:100		, hidden: true}
        ], 
        listeners: {
        	select: function(grid, record, index, eOpts ){		
        		detailStore.loadStoreRecords(record);
        	},
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
         		var slipDivi    = panelSearch.getValue('SLIP_DIVI');
                var inputDivi   = record.data['INPUT_DIVI'];
                var inputPath   = record.data['INPUT_PATH'];
				var apDate		= record.data['AP_DATE'];
        		//회계전표
    			if(slipDivi == '1' || !Ext.isEmpty(apDate)){		
    				if(inputDivi == '2' ){			//번호별 회계전표 화면 관련
    					masterGrid.gotoAgj205ukr(record);
    				} else if (inputDivi == '3'){	//INPUT_DIVI가 '3'일 경우 결의미결반제입력으로 이동
        				masterGrid.gotoAgj110ukr(record);
    				} else {						//일반 회계전표 화면 관련
    					masterGrid.gotoAgj200ukr(record);
    				}
    			} else {			//	결의전표
    				if(inputDivi == '2' ){			//번호별 결의전표 화면 관련
    					masterGrid.gotoAgj105ukr(record);
    				} else if (inputDivi == '3'){	//INPUT_DIVI가 '3'일 경우 결의미결반제입력으로 이동
        				masterGrid.gotoAgj110ukr(record);
    				} else {						//일반 결의전표 화면 관련
    					masterGrid.gotoAgj100ukr(record);
    				}
    			}
            }
        },
    	
		gotoAgj100ukr:function(record)	{
    		var param = {
    			'PGM_ID'			: 'agj270skr',
				'AC_DATE_FR'		: UniDate.getDbDateStr(record.data['AC_DATE']),
				'AC_DATE_TO'		: UniDate.getDbDateStr(record.data['AC_DATE']),
				'EX_NUM'			: record.data['SLIP_NUM'],
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				'DIV_CODE'			: panelSearch.getValue('DIV_CODE')
    		};
	  		var rec1 = {data : {prgID : 'agj100ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj100ukr.do', param);
    	},
		gotoAgj105ukr:function(record)	{
    		var param = {
    			'PGM_ID'			: 'agj270skr',
				'AC_DATE'		: UniDate.getDbDateStr(record.data['AC_DATE']),
				'EX_NUM'			: record.data['SLIP_NUM'],
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				'AP_STS'			: record.data['AP_STS']
    		};
    		
	  		var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj105ukr.do', param);
    	},
		gotoAgj110ukr:function(record)	{
			var param = {};
    		var slipDivi    = panelSearch.getValue('SLIP_DIVI');
    		if(slipDivi == '1' ){
    			param = {
   	    			'PGM_ID'			: 'agj270skr',
   					'AC_DATE_FR'		: UniDate.getDbDateStr(record.data['AC_DATE']),
   					'AC_DATE_TO'		: UniDate.getDbDateStr(record.data['AC_DATE']),
   					'EX_DATE_FR'		: UniDate.getDbDateStr(record.data['EX_DATE']),
   					'EX_DATE_TO'		: UniDate.getDbDateStr(record.data['EX_DATE']),
   					'INPUT_PATH'		: record.data['INPUT_PATH'],
   					'SLIP_NUM'			: record.data['SLIP_NUM'],
   					'EX_NUM'			: record.data['EX_NUM']
   	    		};
    		} else {
	    		 param = {
	    			'PGM_ID'			: 'agj270skr',
					'AC_DATE_FR'		: UniDate.getDbDateStr(record.data['EX_DATE']),
					'AC_DATE_TO'		: UniDate.getDbDateStr(record.data['EX_DATE']),
					'EX_DATE_FR'		: UniDate.getDbDateStr(record.data['AC_DATE']),
					'EX_DATE_TO'		: UniDate.getDbDateStr(record.data['AC_DATE']),
					'INPUT_PATH'		: record.data['INPUT_PATH'],
					'SLIP_NUM'			: record.data['EX_NUM'],
					'EX_NUM'			: record.data['SLIP_NUM']
	    		};
			}
	  		var rec1 = {data : {prgID : 'agj110ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj110ukr.do', param);
    	},    	
		gotoAgj200ukr:function(record)	{
    		var param = {};
    		var slipDivi    = panelSearch.getValue('SLIP_DIVI');
    		if(slipDivi == '1' ){
	    		param = {
	    			'PGM_ID'			: 'agj270skr',
					'AC_DATE_FR'		: UniDate.getDbDateStr(record.data['AC_DATE']),
					'AC_DATE_TO'		: UniDate.getDbDateStr(record.data['AC_DATE']),
					'INPUT_PATH'		: record.data['INPUT_PATH'],
					'SLIP_NUM'			: record.data['SLIP_NUM']
	    		};
    		} else {
    			param = {
   	    			'PGM_ID'			: 'agj270skr',
   					'AC_DATE_FR'		: UniDate.getDbDateStr(record.data['EX_DATE']),
   					'AC_DATE_TO'		: UniDate.getDbDateStr(record.data['EX_DATE']),
   					'INPUT_PATH'		: record.data['INPUT_PATH'],
   					'SLIP_NUM'			: record.data['EX_NUM']
   	    		};
    		}
	  		var rec1 = {data : {prgID : 'agj200ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj200ukr.do', param);
    	},
		gotoAgj205ukr:function(record)	{
			var param = {};
			var slipDivi    = panelSearch.getValue('SLIP_DIVI');
    		if(slipDivi == '1'){
    			param = {
	    			'PGM_ID'			: 'agj270skr',
					'AC_DATE'			: UniDate.getDbDateStr(record.data['AC_DATE']),
					'SLIP_NUM'			: record.data['SLIP_NUM'],
					'INPUT_PATH'		: record.data['INPUT_PATH']
	    		};
    		} else {
    			param = {
    	    			'PGM_ID'			: 'agj270skr',
    					'AC_DATE'			: UniDate.getDbDateStr(record.data['EX_DATE']),
    					'SLIP_NUM'			: record.data['EX_NUM'],
    					'INPUT_PATH'		: record.data['INPUT_PATH']
    	    		};
    		}
	  		var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj205ukr.do', param);
    	},
		returnCell: function(record){
        	var AC_DATE			= record.get("AC_DATE");
        	var SLIP_NUM		= record.get("SLIP_NUM");
        	var EX_NUM			= record.get("EX_NUM");
        	var AP_DATE			= record.get("AP_DATE");
        	var INPUT_PATH		= record.get("INPUT_PATH");
		}       
	});
    
    var detailGrid = Unilite.createGrid('s_agj270skr_hsGrid2', {
    	// for tab    	
        layout : 'fit',
        region:'south',
        flex: 2,
    	split: false,
    	store: detailStore,
    	uniOpt : {
			useMultipleSorting	: true,			 
	    	useLiveSearch		: false,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: false,			
			expandLastColumn	: false,		
			useRowContext		: false,			
            userToolbar			: false,
	    	filter: {
				useFilter	: false,		
				autoCreate	: false		
			}
		},
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [  
        	{ dataIndex:'EX_SEQ'		, 		width:50 ,align : 'center'},
			{ dataIndex:'SLIP_DIVI_NM'	, 		width:80},
			{ dataIndex:'ACCNT'			, 		width:100},
			{ dataIndex:'ACCNT_NAME'	, 		width:160},
			{ dataIndex:'CUSTOM_NAME'	, 	    width:160},

			{ dataIndex:'AMT_I'			, 		width:120},
			{ dataIndex:'MONEY_UNIT'	, 		width:66},
			{ dataIndex:'EXCHG_RATE_O'	, 		width:100},
			{ dataIndex:'FOR_AMT_I'		, 		width:100},
			{ dataIndex:'REMARK'		, 		width:333},
			{ dataIndex:'DEPT_NAME'		, 		width:120},
			{ dataIndex:'DIV_NAME'		, 		width:120},
			{ dataIndex:'PROOF_KIND_NM'	, 		width:200}
        ], 
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners:{
			selectionchange:function(grid, selected, eOpt)	{
        		if(selected && selected.length > 0)	{
	        		var dataMap = selected[selected.length-1].data;
		    		UniAccnt.addMadeFields(detailForm, dataMap, detailForm, '', Ext.isEmpty(selected)?null:selected[selected.length-1]);
		    		detailForm.setActiveRecord(selected[selected.length-1]);
	    		}
	    	}
		}
    });
    
    var detailForm = Unilite.createForm('s_agj270skr_hsDetailForm',  {	
        itemId: 's_agj270skr_hsDetailForm',
		masterGrid: detailGrid,
		minHeight :85,
		height: 85,
		disabled: false,
		border: true,
		padding: '1',
		layout : 'hbox',
		items:[{
			xtype: 'container',
			itemId: 'formFieldArea1',
			layout: {
				type: 'uniTable', 
				columns:3
			},
			defaults:{
				width:365,
				labelWidth: 130,
				readOnly: 'true',
				editable: false
			}
		}]
    });

    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
			 	panelResult,
				masterGrid, 
				{
					region:'south',
					xtype:'container',
					minHeight :220,
					flex:0.35,
					layout:{type:'vbox', align:'stretch'},
					items:[
						detailGrid, detailForm
					]
				}
			]	
		}		
		,panelSearch
		],
		id  : 's_agj270skr_hsApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_AC_DATE', UniDate.get('today'));	
			panelSearch.setValue('TO_AC_DATE', UniDate.get('today'));	
			panelResult.setValue('FR_AC_DATE', UniDate.get('today'));	
			panelResult.setValue('TO_AC_DATE', UniDate.get('today'));
			panelSearch.setValue('SLIP_DIVI', '1');
			
			if(baseInfo.gsChargeDivi)	{
				panelSearch.setValue('PRSN_CODE',baseInfo.gsChargeCode);
				panelSearch.setValue('PRSN_NAME',baseInfo.gsChargeName);
				panelResult.setValue('PRSN_CODE',baseInfo.gsChargeCode);
				panelResult.setValue('PRSN_NAME',baseInfo.gsChargeName);
			}
			UniAppManager.setToolbarButtons(['reset','save','print'],false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_AC_DATE');
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			detailForm.clearForm();
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
			beforeRowIndex = -1;
		},
		onResetButtonDown: function() {			
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			detailForm.clearForm();
			masterGrid.reset();
			detailGrid.reset();
			masterStore.clearData();
            detailStore.clearData();
			printType = '';
			this.fnInitBinding();
		},
		onPrintButtonDown: function(printType) {
			var mainPrintType = printType;
			var param= masterGrid.getSelectedRecords();
			var acDate = new Array();
			var acDate2 = new Array();
			var slipNum = new Array();  
			//var exNum = new Array();    20161014 삭제 
			var pgmId = 's_agj270skr_hs'	
			Ext.each(param, 
		   		function(record, i)	{
		   			
		   			if(!Ext.isEmpty(record.get('AC_DATE'))){
		   				acDate[i] = UniDate.getDbDateStr(record.get('AC_DATE')).substring(0, 8) + record.get('SLIP_NUM');  // 201601011
		   			}else{
		   				acDate[i] =' ';
		   			}
		   			
		   			if(!Ext.isEmpty(record.get('AC_DATE'))){
		   				acDate2[i] = UniDate.getDbDateStr(record.get('AC_DATE')).substring(0, 8);
		   			}else{
		   				acDate2[i] =' ';
		   			}
		   			if(!Ext.isEmpty(record.get('SLIP_NUM'))){
		   				slipNum[i] = record.get('SLIP_NUM');
		   			}
		   			else{
		   				slipNum[i] =' ';
		   			}
		   			
		   			/*
		   			
		   			
		   			if(!Ext.isEmpty(record.get('EX_DATE'))){
		   				exDate[i] = UniDate.getDbDateStr(record.get('EX_DATE')).substring(0, 8) + record.get('EX_NUM');
		   			}else{
		   				exDate[i] =' ';
		   			}
		   			if(!Ext.isEmpty(record.get('EX_NUM'))){
		   				exNum[i] = record.get('EX_NUM');
		   			}else{
		   				exNum[i] = ' ';
		   			}*/
		   	});  
			
		   	if(mainPrintType == 'slip'){  // 전표출력 일 경우
		   	//alert(documentOrder);
		   		
		   		var acDate = acDate.join(',');
		   		var acDate2 = acDate2.join(',');
		   		var slipNum = slipNum.join(',');
		   		var printLine = "";
		   		//var printMulti = "";
		   		var eachPrint = "F"
		   		
		   		//panelResult.getValue('EACH_PRINT')
		   		
		   		//	건별출력 - 전표번호 별 출력 후 강제 페이지 넘김.
				if(panelResult.getValue('EACH_PRINT') == true){
		   			//printMulti = "P3";
		   			eachPrint = "T";
		   		} else {
		   			//printMulti = "P1";
		   			eachPrint = "F";
		   		}
		   		
		   		var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                       "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                       "AC_DATE"    : acDate,
                                                       "FR_AC_DATE" : acDate2,
                                                       "TO_AC_DATE" : acDate2,
                                                       "FR_SLIP_NUM": slipNum,
                                                       "TO_SLIP_NUM": slipNum,
                                                       "PAGE_CNT"	: 5,
                                                       "PRINT_TYPE" : "P1",		// printMulti
                                                       "PRINT_LINE" : printLine,
                                                       "EACH_PRINT" : eachPrint
                                   };
						   		                   
					reportParam.PGM_ID = pgmId;
					   		
        			var win = Ext.create('widget.ClipReport', {
	            		url: CPATH+'/hs/s_agj270clrkr_hs.do',
	            		prgID: 's_agj270clrkr_hs',
	                	extParam: reportParam,
	                	submitType: 'POST'
	                });
                    
                    win.center();
                    win.show();		   		                   
		   		
/*			   	var proParam = {"S_COMP_CODE" : UserInfo.compCode};	   	
			   	accntCommonService.fnGetPrintSetting(proParam, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						
						printLine = provider[0].PRINT_LINE;
						
						if(provider[0].SLIP_PRINT == 1){			// 세로 2장모드
							
							if(provider[0].RETURN_YN == 1){			// 전표번호별 입력화면에서 귀속부서와 귀속사업장을  관리한다.
						   		var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                       "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                       "AC_DATE"    : acDate,
                                                       "FR_AC_DATE" : acDate2,
                                                       "TO_AC_DATE" : acDate2,
                                                       "FR_SLIP_NUM": slipNum,
                                                       "TO_SLIP_NUM": slipNum,
                                                       "PAGE_CNT"	: 5,
                                                       "PRINT_TYPE" : "P1",
                                                       "PRINT_LINE" : printLine	//"2"
						   		                   };
							}
							else{
								var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                       "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                       "AC_DATE"    : acDate,
                                                       "FR_AC_DATE" : acDate2,
                                                       "TO_AC_DATE" : acDate2,
                                                       "FR_SLIP_NUM": slipNum,
                                                       "TO_SLIP_NUM": slipNum,
                                                       "PAGE_CNT"	: 5,
                                                       "PRINT_TYPE" : "P2",
                                                       "PRINT_LINE" : printLine	//"2"
                                                   };
							}
					   	}
					   	else if(provider[0].SLIP_PRINT == 2){		// 세로 1장 모드
					   		if(provider[0].RETURN_YN == 1){			// 전표번호별 입력화면에서 귀속부서와 귀속사업장을  관리한다.
					   		      var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                       "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                       "AC_DATE"    : acDate,
                                                       "FR_AC_DATE" : acDate2,
                                                       "TO_AC_DATE" : acDate2,
                                                       "FR_SLIP_NUM": slipNum,
                                                       "TO_SLIP_NUM": slipNum,
                                                       "PAGE_CNT"	: 16,
                                                       "PRINT_TYPE" : "P3",
                                                       "PRINT_LINE" : "2"
                                                    };
					   		}else{
						   		var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                       "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                       "AC_DATE"    : acDate,
                                                      "FR_AC_DATE" : acDate2,
                                                       "TO_AC_DATE" : acDate2,
                                                       "FR_SLIP_NUM": slipNum,
                                                       "TO_SLIP_NUM": slipNum,
                                                       "PAGE_CNT"	: 16,
                                                       "PRINT_TYPE" : "P4",
                                                       "PRINT_LINE" : "2"
                                                   };
					   		}
					   	}
					   	else{									// 가로 1장모드
					   		if(provider[0].RETURN_YN == 1){		// 전표번호별 입력화면에서 귀속부서와 귀속사업장을  관리한다.
					   			var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                       "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                       "AC_DATE"    : acDate,
                                                       "FR_AC_DATE" : acDate2,
                                                       "TO_AC_DATE" : acDate2,
                                                       "FR_SLIP_NUM": slipNum,
                                                       "TO_SLIP_NUM": slipNum,
                                                       "PAGE_CNT"	: 6,
                                                       "PRINT_TYPE" : "L1",
                                                       "PRINT_LINE" : "1"
                                                   };
					   		}else{
					   			var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                       "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                       "AC_DATE"    : acDate,
                                                       "FR_AC_DATE" : acDate2,
                                                       "TO_AC_DATE" : acDate2,
                                                       "FR_SLIP_NUM": slipNum,
                                                       "TO_SLIP_NUM": slipNum,
                                                       "PAGE_CNT"	: 6,
                                                       "PRINT_TYPE" : "L2",
                                                       "PRINT_LINE" : "1"
                                                   };
					   		}
					   	}

					   	
					   		reportParam.PGM_ID = pgmId;
					   		
                			var win = Ext.create('widget.ClipReport', {
			            		url: CPATH+'/hs/s_agj270clrkr_hs.do',
			            		prgID: 's_agj270clrkr_hs',
			                	extParam: reportParam,
			                	submitType: 'POST'
			                });
                            
                            win.center();
                            win.show();
					}
				});*/
		   	}
		   	else if(mainPrintType == 'journal'){  // 분개장 일 경우
		   	}
		   	else if(mainPrintType == 'sheet'){	// 집계표 일 경우		
		   		var selectedRecords = masterGrid.getSelectedRecords();
                if(selectedRecords.length > 0){
                    reportStore.clearData();
                    Ext.each(selectedRecords, function(record,i){
                        record.phantom = true;
                        reportStore.insert(i, record);
                    });
                    reportStore.saveStore();
                }
		   	}
		}
	});
};


</script>
