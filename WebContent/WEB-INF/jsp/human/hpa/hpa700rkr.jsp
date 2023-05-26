<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa700rkr"  >
		<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태    -->
		<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분    -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수    -->
		<t:ExtComboStore comboType="AU" comboCode="H032" opts='F;G;'/> <!-- 지급구분    -->
		<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹    -->
		<t:ExtComboStore comboType="CBM600" comboCode="0"/> <!-- Cost Pool -->
		<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장      -->
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
	var masterStore = Unilite.createStore('hpa700rkrMasterStore',{
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
                read: 'hpa700rkrService.selectList'
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
	}); //End of var masterStore = Unilite.createStore('hpa700rkrMasterStore',{


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
				items: [{
					boxLabel: '부서별지급대장',
					width: 120,
					name: 'optPrint',
					checked: true,
					inputValue: '1'
				},{
					boxLabel: '부서별집계표',
					width: 110,
					name: 'optPrint',
					inputValue: '2'
				},{
					boxLabel: '명세서',
					width: 140,
					name: 'optPrint',
					inputValue: '3'
				}]
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
				xtype: 'uniMonthfield',
				name : 'SUPP_MONTH',
				value		: new Date(),
				allowBlank: false
	        },{
		        fieldLabel: '지급구분',
		        name:'SUPP_TYPE',
		        xtype: 'uniCombobox',
		        comboType: 'AU',
		        comboCode:'H032',
		        value: 'F',
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
					textFieldWidth: 170,
					valueFieldName: 'DEPT_FR',
			    	textFieldName: 'DEPT_NAME',
					validateBlank: false,
					popupWidth: 710,
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
				xtype: 'radiogroup',
				fieldLabel: '재직구분',
				labelWidth: 90,
				id: 'optPrintYn',
				items: [{
					boxLabel: '전체',
					width: 50,
					name: 'optPrint',
					inputValue: '1',
					checked: true
				},{
					boxLabel: '재직',
					width: 70,
					name: 'optPrint',
					inputValue: '2'
				},{
					boxLabel: '퇴직',
					width: 70,
					name: 'optPrint',
					inputValue: '3'
				}]
			},{
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
		id: 'hpa700rkrApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
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

            var invalid = panelResult2.getForm().getFields().filterBy(function(field) { return !field.validate();});
                if(invalid.length > 0) {
                   alert(Msg.sMB083);
                   return false;
                }

			var param = Ext.getCmp('resultForm2').getValues();	//조회조건
			var param2 = Ext.getCmp('resultForm').getValues();	//출력양식

			var doc_Kind = Ext.getCmp('optPrintGb').getValue().optPrint;	//출력양식
			var optYn = Ext.getCmp('optPrintYn').getValue().optPrint;		//재직구분

            var month = panelResult2.getValue('SUPP_MONTH');
            supp_month = UniDate.getDbDateStr(month);

            var title_Doc = '';

            if(doc_Kind == '1' ){
                title_Doc = '부서별 지급대장';
            }
            else if(doc_Kind == '2'){
                title_Doc = '부서별 집계표';
            }
            else if(doc_Kind == '3'){
                title_Doc = '명세서';
            }

            var param = {
                   DOC_KIND     : Ext.getCmp('optPrintGb').getValue().optPrint,
                   // 부서별지급대장 : 1, 부서별집계표 : 2 , 명세서 : 3

                   SUPP_MONTH   : param.SUPP_MONTH,
                   SUPP_TYPE    : param.SUPP_TYPE,
                   DIV_CODE     : param.DIV_CODE,
                   DEPT_CODE_FR : param.DEPT_FR,
                   DEPT_CODE_TO : param.DEPT_FR,
                   PAY_CODE     : param.PAY_CODE,			//급여지급방식
                   SUPP_DATE    : param.SUPP_DATE,			//지급일
                   PAY_DAY_FLAG : param.PAY_DAY_FLAG,		//지급차수
                   PAY_GUBUN    : param.PAY_GUBUN,			//고용형태
                   EMPLOY_TYPE  : param.EMPLOY_TYPE,		//사원구분
                   PERSON_GROUP : param.PERSON_GROUP,		//사원그룹
                   AFFIL_CODE   : param.AFFIL_CODE,			//직렬
                   PERSON_NUMB  : param.PERSON_NUMB,		//사원

                   // 레포트로 파라미터 넘기기 매개변수 (조회와 관련 없음)
                   TITLE    : title_Doc,
                   OPTYN    : optYn,
                   FORMAT_I : '0'
            }
			param.sTxtValue2_fileTitle = title_Doc;
        	//var param = Ext.getCmp('resultForm').getValues();
			/*var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/human/hpa700crkr.do',
                prgID: 'hpa700crkr',
                extParam: param
			});*/
             win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/human/hpa700clrkr.do',
	                prgID: 'hpa700rkrv',
	                extParam: param
	          });
			win.center();
			win.show();
		}

	}); //End of 	Unilite.Main( {
};

</script>
