<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa900rkr_kd"  >
		<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
		<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
		<t:ExtComboStore comboType="AU" comboCode="H032" opts='1' /> <!-- 지급구분 -->
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
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('s_hpa900rkr_kdMasterStore',{
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
                read: 's_hpa900rkr_kdService.selectList'                	
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
		layout : {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
				xtype: 'radiogroup',		            		
				fieldLabel: '출력선택',						            		
				//itemId: 'RADIO4',
				id: 'optPrintGb',
				labelWidth: 90,
				items: [
/*					{
					boxLabel: '부서별지급대장', 
					width: 120, 
					name: 'optPrint',
					checked: true, 
					inputValue: '1'
					listeners: {
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

					}
				},{
					boxLabel: '부서별집계표', 
					width: 110, 
					name: 'optPrint',
					inputValue: '2'
					listeners: {
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

					}
				},{
					boxLabel: '사업장별지급대장1', 
					width: 140, 
					name: 'optPrint',
					inputValue: '3',
					disabled : true
				},{
					boxLabel: '사업장별지급대장2', 
					width: 140, 
					name: 'optPrint',
					inputValue: '4',
					disabled : true
				},*/
				{
					boxLabel: '급여명세서', 
					width: 100, 
					name: 'optPrint',
					checked: true, 
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
				}
/*				,{
					boxLabel: '급여명세서(1/2)', 
					width: 150, 
					name: 'optPrint',
					inputValue: '6',
					disabled : true
				}*/
				]
			},{
            	fieldLabel: '',
            	name: 'SUPP_TOTAL_I',
				value: 'Y',
				xtype: 'checkbox',
				labelWidth: 200,
				hidden : true,
				boxLabel: '&nbsp;급여가 0인 금액포함'
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
	        	fieldLabel: '지급년월', 
				//xtype: 'uniMonthRangefield',   
				//startFieldName: 'DATE_FR',
				//endFieldName: 'DATE_TO',
				//startDate: UniDate.get('startOfYear'),
				//endDate: UniDate.get('endOfYear'),
			xtype: 'uniMonthfield',
			name: 'DATE_FR',                    
			value: new Date(),                    
				allowBlank: false
	        },{
		        fieldLabel: '지급구분',
		        name:'SUPP_TYPE', 	
		        xtype: 'uniCombobox',
		        comboType: 'AU',
		        comboCode:'H032',
		        value: '1', 
		        allowBlank: false
		    },{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				comboCode	: 'BILL'
			},
			Unilite.popup('DEPT',{
	        fieldLabel: '부서',
		    valueFieldName:'FR_DEPT_CODE',
		    textFieldName:'FR_DEPT_NAME',
		    itemId:'FR_DEPT_CODE',
			autoPopup: true
	    }),Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        itemId:'TO_DEPT_CODE',
			    valueFieldName:'TO_DEPT_CODE',
			    textFieldName:'TO_DEPT_NAME',
				autoPopup: true
	    }),{
                fieldLabel: '급여지급방식',
                name:'PAY_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H028'
            },{
				fieldLabel: '지급일',
				xtype: 'uniDatefield',
				name: 'SUPP_DATE'                    
				//value: new Date()
			},{
                fieldLabel: '지급차수',
                name:'PAY_DAY_FLAG', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H031'
            },{
	            fieldLabel: '고용형태',
	            name:'PAY_GUBUN', 	
	            xtype: 'uniCombobox', 
	            comboType:'AU',
	            comboCode:'H011'
	        },{
                fieldLabel: '사원구분',
                name:'EMPLOY_TYPE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H024'
            },{
                fieldLabel: '사원그룹',
                name:'PERSON_GROUP', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H181'
            },{
                fieldLabel: '회계부서',
                name:'COST_KIND', 	
                xtype: 'uniCombobox',
                store : Ext.StoreManager.lookup('getHumanCostPool')
            },{
                fieldLabel: '직렬',
                name:'AFFIL_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H173'
            },
            Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true
			}),{
			 	fieldLabel: '적요사항',
			 	xtype: 'textareafield',
			 	name: 'REMARK',
			 	height : 40,
			 	width: 325
			}
/*			,{
				xtype: 'radiogroup',		            		
				fieldLabel: '년차출력여부',
				id: 'optPrintYn1',
				labelWidth: 90,
				items: [{
					boxLabel: '예', 
					width: 50, 
					name: 'optPrint1',
					inputValue: '1'
					 
				},{
					boxLabel: '아니오',  
					width: 70, 
					name: 'optPrint1',
					inputValue: '2',
					checked: true
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '근태출력여부',	
				labelWidth: 90,
				id: 'optPrintYn2',
				items: [{
					boxLabel: '예', 
					width: 50, 
					name: 'optPrint2',
					inputValue: 'Y',
					checked: true  
				},{
					boxLabel: '아니오',  
					width: 70, 
					name: 'optPrint2',
					inputValue: 'N'
				}]
			}*/
			,{
             	xtype:'button',
             	text:'출    력',
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
		id: 's_hpa900rkr_kdApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			//panelResult2.getField('optPrintYn1').setDisabled(true);
			//panelResult2.getField('optPrintYn2').setDisabled(true);
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
                   alert(Msg.sMB083);
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
			
			
			var memo = "";
			
			if(param.REMARK == ""){
                memo = '@'; 
            } else {
            	memo = param.REMARK;
            }
			
			//var optYn1 = Ext.getCmp('optPrintYn1').getValue().optPrint1;

            
            var dateFr = panelResult2.getValue('DATE_FR');
            //var dateTo = panelResult2.getValue('DATE_FR');
            annFrDate = UniDate.getDbDateStr(dateFr);
            //annToDate = UniDate.getDbDateStr(dateTo);
            
            //if( dateFr > dateTo ){        // 근무기간 Check
            //    return false;
            //}   
            
            var title_Doc = '';
            
            if(doc_Kind == '1' ){
                title_Doc = '부서별 지급대장'; 
            }
            else if(doc_Kind == '2'){
                title_Doc = '부서별 집계표'; 
            }
            else if(doc_Kind == '3'){
                title_Doc = '사업장별지급대장1'; 
            }
            else if(doc_Kind == '4'){
                title_Doc = '사업장별지급대장2'; 
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
                   
                   //GUNTAE       : Ext.getCmp('optPrintYn2').getValue().optPrint2,
                   
                   DATE_FR      : param.DATE_FR,
                   //DATE_TO      : param.DATE_TO,
                   SUPP_TYPE    : param.SUPP_TYPE,
                   DIV_CODE     : param.DIV_CODE, 
                   DEPT_CODE_FR : param.FR_DEPT_CODE,
                   DEPT_CODE_TO : param.TO_DEPT_CODE,
                   PAY_CODE     : param.PAY_CODE,
                   SUPP_DATE    : param.SUPP_DATE,
                   PAY_DAY_FLAG : param.PAY_DAY_FLAG,
                   PAY_GUBUN    : param.PAY_GUBUN,
                   EMPLOY_TYPE  : param.EMPLOY_TYPE,
                   COST_KIND    : param.COST_KIND,
                   AFFIL_CODE   : param.AFFIL_CODE,
                   PERSON_NUMB  : param.PERSON_NUMB,
                   SUPP_TOTAL_I : SUPP_TOTAL_I,
                                      
                   // 레포트로 파라미터 넘기기 매개변수 (조회와 관련 없음)
                   TITLE    : title_Doc,
                   FR_MONTH : param.DATE_FR,
                   MEMO     : memo, 
                   OPTYN1   : '1',
                   FORMAT_I : '0'
            }
            Ext.getBody().mask("Loading...");
            s_hpa900rkr_kdService.createReportData(param, function(){
            	Ext.getBody().unmask();
		        var win = Ext.create('widget.CrystalReport', {
		            url: CPATH+'/z_kd/s_hpa900crkr_kd.do',
		            prgID: 's_hpa900crkr_kd',
		            extParam: param
		        });
		        win.center();
		        win.show();		
            });
		}
		
	}); //End of 	Unilite.Main( {
};

</script>
