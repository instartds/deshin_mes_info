<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa900rkr"  >
		<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
		<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
		<t:ExtComboStore comboType="AU" comboCode="H032" /> <!-- 지급구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 -->
		<t:ExtComboStore comboType="CBM600" comboCode="0"/>   		   <!--  Cost Pool        --> 
		<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
		<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!--차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	
	var hideYearPayYN = '${yearPayYN}' == 'Y' ? false : true;
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hpa900rkrMasterStore',{
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
	        //비고(*) 사용않함
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'hpa900rkrService.selectList'                	
            }
        }/*, //(사용 안 함 : 쿼리에서 처리)
        listeners : {
	        load : function(store) {
	            if (store.getCount() > 0) {
	            	setGridSummary(true);
	            } else {
	            	setGridSummary(false);
	            }
	        }
	    }*/,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'PAY_YYYYMM'
	}); //End of var masterStore = Unilite.createStore('hpa900rkrMasterStore',{


	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.printselection" default="출력선택"/>',						            		
				//itemId: 'RADIO4',
				id: 'optPrintGb',
				labelWidth: 90,
				items: [{
					boxLabel: '<t:message code="system.label.human.deptsuppledger" default="부서별지급대장"/>', 
					width: 120, 
					name: 'optPrint',
					checked: true, 
					inputValue: '1'
/*					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if (field.inputValue == '1'){
								//panelResult2.getField('optPrintYn1').setReadOnly(true);
								panelResult2.getField('optPrintYn1').setDisabled(true);
								panelResult2.getField('optPrintYn2').setDisabled(true);
								
								var doc_Kind = Ext.getCmp('optPrintGb').getValue().optPrint;
								
								
								return false;
							} else {
								panelResult2.getField('optPrintYn1').setDisabled(false);
								panelResult2.getField('optPrintYn2').setDisabled(false);
								return false;
							}
							
						}

					}*/
				},{
					boxLabel: '<t:message code="system.label.human.bydeptsummary" default="부서별집계표"/>', 
					width: 110, 
					name: 'optPrint',
					inputValue: '2'
/*					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if (field.inputValue == '2'){
								//panelResult2.getField('optPrintYn1').setReadOnly(true);
								panelResult2.getField('optPrintYn1').setDisabled(true);
								panelResult2.getField('optPrintYn2').setDisabled(true);
								
								var doc_Kind = Ext.getCmp('optPrintGb').getValue().optPrint;
								return false;
							} else {
								panelResult2.getField('optPrintYn1').setDisabled(false);
								panelResult2.getField('optPrintYn2').setDisabled(false);
								return false;
							}
							
						}

					}*/
				},{
					boxLabel: '<t:message code="system.label.human.divsuppledger" default="사업장별지급대장"/>1', 
					width: 140, 
					name: 'optPrint',
					inputValue: '3'
					//,					disabled : true
				},{
					boxLabel: '<t:message code="system.label.human.divsuppledger" default="사업장별지급대장"/>2', 
					width: 140, 
					name: 'optPrint',
					inputValue: '4'
					//,					disabled : true
				},{
					boxLabel: '<t:message code="system.label.human.payspecification" default="급여명세서"/>', 
					width: 100, 
					name: 'optPrint',
					inputValue: '5'
	/*				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if (field.inputValue == '5'){
								//panelResult2.getField('optPrintYn1').setReadOnly(true);
								panelResult2.getField('optPrintYn1').setDisabled(false);
								panelResult2.getField('optPrintYn2').setDisabled(false);
								
								var doc_Kind = Ext.getCmp('optPrintGb').getValue().optPrint;
								return false;
							} else {
								panelResult2.getField('optPrintYn1').setDisabled(true);
								panelResult2.getField('optPrintYn2').setDisabled(true);
								return false;
							}
							
						}

					}*/
				},{
					boxLabel: '<t:message code="system.label.human.payspecification" default="급여명세서"/>(1/2)', 
					width: 150, 
					name: 'optPrint',
					inputValue: '6'
					//,					disabled : true
				}],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                            if(newValue.optPrint == '5'){
                                panelResult2.getField('optPrintYn1').setDisabled(false);
                                panelResult2.getField('optPrintYn2').setDisabled(false);
                                panelResult2.getField('DISP_YEAR_PAY').setDisabled(false);
                            }else if(newValue.optPrint == '6'){
                                panelResult2.getField('optPrintYn1').setDisabled(true);
                                panelResult2.getField('optPrintYn2').setDisabled(false);
                                panelResult2.getField('DISP_YEAR_PAY').setDisabled(false);
                            }else if(newValue.optPrint == '3'){
                                panelResult2.getField('optPrintYn1').setDisabled(true);
                                panelResult2.getField('optPrintYn2').setDisabled(false);
                                panelResult2.getField('DISP_YEAR_PAY').setDisabled(true);
                            }else{
                                panelResult2.getField('optPrintYn1').setDisabled(true);
                                panelResult2.getField('optPrintYn2').setDisabled(true);
                                panelResult2.getField('DISP_YEAR_PAY').setDisabled(true);
                            }
                    }
                }
			},{
            	fieldLabel: '',
            	name: 'SUPP_TOTAL_I',
				//value: 'Y',
				xtype: 'checkbox',
				labelWidth: 200,
				boxLabel: '금액 0항목 제외'
			},{
            	fieldLabel: ' ',
            	name: 'IS_PRIVATE',
				//value: 'Y',
				xtype: 'checkbox',
				//labelWidth: 200,
				boxLabel: '개인정보 마스킹(*로 처리)'
    		}]
	});	
	
    var panelResult2 = Unilite.createSearchForm('resultForm2',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'west',
		layout : {type : 'uniTable', columns : 1
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        	fieldLabel: '<t:message code="system.label.human.suppyyyymm1" default="지급년월"/>', 
				xtype: 'uniMonthRangefield',   
				startFieldName: 'DATE_FR',
				endFieldName: 'DATE_TO',
				startDate: UniDate.get('startOfYear'),
				endDate: UniDate.get('endOfYear'),
				allowBlank: false
	        },{
		        fieldLabel: '<t:message code="system.label.human.supptype" default="지급구분"/>',
		        name:'SUPP_TYPE', 	
		        xtype: 'uniCombobox',
		        comboType: 'AU',
		        comboCode:'H032',
		        value: '1', 
		        allowBlank: false
		    },{
				fieldLabel	: '<t:message code="system.label.human.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				comboCode	: 'BILL'
			},
			Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
					textFieldWidth: 170,
					valueFieldName: 'DEPT_FR',
			    	textFieldName: 'DEPT_NAME',
					validateBlank: false,
					popupWidth: 710,
					autoPopup:true,
					listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult2.setValue('DEPT_FR', '');
                        panelResult2.setValue('DEPT_NAME', '');
                    }
                }
			}),
			    Unilite.popup('DEPT', {
			    	fieldLabel: '~',
			    	valueFieldName: 'DEPT_TO',
			    	textFieldName: 'DEPT_NAME2',
			    	textFieldWidth: 170,
			    	validateBlank: false,
			    	popupWidth: 710,
			    	autoPopup:true,
			    	listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult2.setValue('DEPT_TO', '');
                        panelResult2.setValue('DEPT_NAME2', '');
                    }
                }
			}),{
                fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
                name:'PAY_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H028'
            },{
				fieldLabel: '<t:message code="system.label.human.suppdate" default="지급일"/>',
				xtype: 'uniDatefield',
				name: 'SUPP_DATE'                    
				//value: new Date()
			},{
                fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
                name:'PAY_DAY_FLAG', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H031'
            },{
	            fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
	            name:'PAY_GUBUN', 	
	            xtype: 'uniCombobox', 
	            comboType:'AU',
	            comboCode:'H011'
	        },{
                fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
                name:'EMPLOY_TYPE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H024'
            },{
                fieldLabel: '<t:message code="system.label.human.employeegroup" default="사원그룹"/>',
                name:'PERSON_GROUP', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H181'
            },{
                fieldLabel: '<t:message code="system.label.human.costpoolname" default="회계부서"/>',
                name:'COST_KIND', 	
                xtype: 'uniCombobox',
                store : Ext.StoreManager.lookup('getHumanCostPool')
            },{
                fieldLabel: '<t:message code="system.label.human.serial" default="직렬"/>',
                name:'AFFIL_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H173'
            },
            Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult2.setValue('PERSON_NUMB', '');
                        panelResult2.setValue('NAME', '');
                    }
                }
			}),{
			 	fieldLabel: '<t:message code="system.label.human.reamark" default="적요사항"/>',
			 	xtype: 'textareafield',
			 	name: 'REMARK',
			 	height : 40,
			 	width: 325
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.wtprintyn" default="근태출력여부"/>',	
				labelWidth: 90,
				id: 'optPrintYn2',
				items: [{
					boxLabel: '<t:message code="system.label.human.yes" default="예"/>', 
					width: 50, 
					name: 'optPrint2',
					inputValue: 'Y',
					checked: true  
				},{
					boxLabel: '<t:message code="system.label.human.no" default="아니오"/>',  
					width: 70, 
					name: 'optPrint2',
					inputValue: 'N'
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.dutyprintyn" default="년차출력여부"/>',
				id: 'optPrintYn1',
				labelWidth: 90,
				items: [{
					boxLabel: '<t:message code="system.label.human.yes" default="예"/>', 
					width: 50, 
					name: 'optPrint1',
					inputValue: '1'
					 
				},{
					boxLabel: '<t:message code="system.label.human.no" default="아니오"/>',  
					width: 70, 
					name: 'optPrint1',
					inputValue: '2',
					checked: true
				}]
			},{
            	fieldLabel: '연차수당표시',
            	name: 'DISP_YEAR_PAY',
				//value: 'Y',
				xtype: 'checkbox',
				//labelWidth: 200,
				hidden : hideYearPayYN
			},{
             	xtype:'button',
             	text:'<t:message code="system.label.human.print" default="출력"/>',
             	width:235,
             	tdAttrs:{'align':'center', style:'padding-left:95px'},
             	handler:function()	{
             		UniAppManager.app.onPrintButtonDown();
             	}
            }]
	});		
	
	Unilite.Main({
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, panelResult2
			]	
		}		
		], 
		id: 'hpa900rkrApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult2.getField('optPrintYn1').setDisabled(true);
			panelResult2.getField('optPrintYn2').setDisabled(true);
			panelResult2.getField('DISP_YEAR_PAY').setDisabled(true);
			UniAppManager.setToolbarButtons(['reset','save','query'],false);
			
		},
		checkForNewDetail:function() { 			
			return panelResult.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{
		
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			
/*			if(!panelResult.setAllFieldsReadOnly(true)){
                return false;
            }*/
            
            // !this.isValidSearchForm()
            // !UniAppManager.app.isValidSearchForm()
            // !panelResult2.getInvalidMessage
            // !panelResult.setAllFieldsReadOnly(true)
            
            var invalid = panelResult2.getForm().getFields().filterBy(function(field) { return !field.validate();});
                if(invalid.length > 0) {
                   alert('<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>');
                   return false;
                }
            
			var param = Ext.getCmp('resultForm2').getValues();
			var param2 = Ext.getCmp('resultForm').getValues();
			
			
			var doc_Kind = Ext.getCmp('optPrintGb').getValue().optPrint;
			var suppI_0  = Ext.getCmp('resultForm').getValue('SUPP_TOTAL_I');
			
			if(suppI_0 == true){
			 SUPP_TOTAL_I = 'Y';
			}else{
			 SUPP_TOTAL_I = 'N';
			}
			
			var isPrivate = (Ext.getCmp('resultForm').getValue('IS_PRIVATE') ? 'Y' : 'N');
			var yearPayYN = (Ext.getCmp('resultForm2').getValue('DISP_YEAR_PAY') ? 'Y' : 'N');
			
			
			var memo = "";
			
			//if(param.REMARK == ""){
            //    memo = '@'; 
            //} else {
            	//memo = param.REMARK;
            	memo = Ext.isEmpty(param.REMARK) ?  '':(param.REMARK).replace(/\n/g, "\\n").replace(/\r/g, "\\r").replace(/\t/g, "\\t") ;
            	
            //}
			
			var optYn1 = Ext.getCmp('optPrintYn1').getValue().optPrint1;

            
            var dateFr = panelResult2.getValue('DATE_FR');
            var dateTo = panelResult2.getValue('DATE_TO');
            annFrDate = UniDate.getDbDateStr(dateFr);
            annToDate = UniDate.getDbDateStr(dateTo);
            
            if( dateFr > dateTo ){        // 근무기간 Check
                return false;
            }   
            
            var title_Doc = '';
            
            if(doc_Kind == '1' ){
                title_Doc = '부서별 지급대장'; 
            }
            else if(doc_Kind == '2'){
                title_Doc = '부서별 집계표'; 
            }
            else if(doc_Kind == '3'){
                title_Doc = '사업장별지급대장'; 
            }
            else if(doc_Kind == '4'){
                title_Doc = '사업장별지급대장'; 
            }
            else if(doc_Kind == '5'){
                title_Doc = '급여명세서'; 
            } 
            else if(doc_Kind == '6'){
                title_Doc = '급여명세서'; 
            } 
            
            var param = {
                   DOC_KIND     : Ext.getCmp('optPrintGb').getValue().optPrint,
                   // 부서별지급대장 : 1, 부서별집계표 : 2 , 사업장별지급대장1 : 3,  사업장별지급대장2 : 4
                   // 급여명세서 : 5, 급여명세서(1/2) : 6
                   
                   GUNTAE       : Ext.getCmp('optPrintYn2').getValue().optPrint2,
                   
                   DATE_FR      : param.DATE_FR,
                   DATE_TO      : param.DATE_TO,
                   SUPP_TYPE    : param.SUPP_TYPE,
                   DIV_CODE     : param.DIV_CODE, 
                   DEPT_FR 		: param.DEPT_FR,
                   DEPT_TO 		: param.DEPT_TO,
                   PAY_CODE     : param.PAY_CODE,
                   SUPP_DATE    : param.SUPP_DATE,
                   PAY_DAY_FLAG : param.PAY_DAY_FLAG,
                   PAY_GUBUN    : param.PAY_GUBUN,
                   EMPLOY_TYPE  : param.EMPLOY_TYPE,
                   COST_KIND    : param.COST_KIND,
                   AFFIL_CODE   : param.AFFIL_CODE,
                   PERSON_NUMB  : param.PERSON_NUMB,
                   SUPP_TOTAL_I : SUPP_TOTAL_I,
                   IS_PRIVATE   : isPrivate,
                   DISP_YEAR_PAY: yearPayYN,
                                      
                   // 레포트로 파라미터 넘기기 매개변수 (조회와 관련 없음)
                   TITLE    : title_Doc,
                   FR_MONTH : param.DATE_FR,
                   MEMO     : memo, 
                   OPTYN1   : optYn1,
                   FORMAT_I : '0'
            }
            Ext.getBody().mask("Loading...");
            
            if (doc_Kind =='5' || doc_Kind =='6'){   
            	
	            hpa900rkrService.createReportData(param, function(){
	            	Ext.getBody().unmask();
			        var win = Ext.create('widget.ClipReport', {
			            url: CPATH+'/human/hpa900clrkr.do',
			            prgID: 'hpa900rkr',
			            extParam: param
			        });
			        win.center();
			        win.show();		
	            });
            	
/*	            hpa900rkrService.createReportData(param, function(){
	            	Ext.getBody().unmask();
			        var win = Ext.create('widget.CrystalReport', {
			            url: CPATH+'/human/hpa900crkr.do',
			            prgID: 'hpa900crkr',
			            extParam: param
			        });
			        win.center();
			        win.show();		
	            });*/
	            
            }
            else /*if (doc_Kind == '1' || doc_Kind == '3' || doc_Kind == '4')*/ {
        		param.PRINT_TYPE = doc_Kind;
        		param.sTxtValue2_fileTitle = Ext.getCmp('optPrintGb').getChecked()[0].boxLabel;
        		
	            hpa900rkrService.createReportData(param, function(){
	            	Ext.getBody().unmask();
			        var win = Ext.create('widget.ClipReport', {
			            url: CPATH+'/human/hpa900clrkr.do',
			            prgID: 'hpa900rkr',
			            extParam: param
			        });
			        win.center();
			        win.show();
	            });
            }
            /*
            else {
            	
	            hpa900rkrService.createReportData(param, function(){
	            	Ext.getBody().unmask();
			        var win = Ext.create('widget.CrystalReport', {
			            url: CPATH+'/human/hpa900crkr.do',
			            prgID: 'hpa900crkr',
			            extParam: param
			        });
			        win.center();
			        win.show();
	            });
            };
            */
            
/*            hpa900rkrService.createReportData(param, function(){
            	Ext.getBody().unmask();
		        var win = Ext.create('widget.CrystalReport', {
		            url: CPATH+'/human/hpa900crkr.do',
		            prgID: 'hpa900crkr',
		            extParam: param
		        });
		        win.center();
		        win.show();		
            });*/
		}
		
	}); //End of 	Unilite.Main( {
};

</script>
