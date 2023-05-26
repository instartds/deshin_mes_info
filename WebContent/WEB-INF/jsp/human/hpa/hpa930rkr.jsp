<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa930rkr"  >
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
	
	var bHideRepreNumOptions = '${bHideRepreNumOptions}';
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
//	var masterStore = Unilite.createStore('hpa900rkrMasterStore',{
//		uniOpt: {
//            isMaster	: true,			// 상위 버튼 연결 
//            editable	: false,		// 수정 모드 사용 
//            deletable	: false,		// 삭제 가능 여부 
//	        useNavi		: false			// prev | newxt 버튼 사용
//	        //비고(*) 사용않함
//        },
//        autoLoad: false,
//        proxy: {
//            type: 'direct',
//            api: {			
//                read: 'hpa900rkrService.selectList'                	
//            }
//        }/*, //(사용 안 함 : 쿼리에서 처리)
//        listeners : {
//	        load : function(store) {
//	            if (store.getCount() > 0) {
//	            	setGridSummary(true);
//	            } else {
//	            	setGridSummary(false);
//	            }
//	        }
//	    }*/,
//		loadStoreRecords: function() {
//			var param= Ext.getCmp('searchForm').getValues();			
//			console.log( param );
//			this.load({
//				params : param
//			});
//		},
//		groupField: 'PAY_YYYYMM'
//	}); //End of var masterStore = Unilite.createStore('hpa900rkrMasterStore',{

    var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'west',
		layout : {type : 'uniTable', columns : 1
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '지급년월',
				id: 'PAY_YYYYMM',
				xtype: 'uniMonthfield',
				name: 'PAY_YYYYMM',                    
				value: new Date(),                    
				allowBlank: false
			},{
		        fieldLabel: '급상여구분',
		        name:'SUPP_TYPE', 	
		        xtype: 'uniCombobox',
		        comboType: 'AU',
		        comboCode:'H032',
		        value: '1'
		    },{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				comboCode	: 'BILL'
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT_CODE',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPT_CODES' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
//				textFieldWidth:89,
				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
				autoPopup:true
				
			}),
			{
                fieldLabel: '급여지급방식',
                name:'PAY_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H028'
            },{
                fieldLabel: '지급차수',
                name:'PAY_DAY_FLAG', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H031'
            },
            Unilite.popup('Employee',{
		      	fieldLabel : '사원',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
			    autoPopup:true,
//			    validateBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					}
				}
      		}),Unilite.popup('BANK',{
				fieldLabel: '은행코드',
				valueFieldName: 'BANK_CODE',
				textFieldName: 'BANK_NAME',
				validateBlank: false,
				colspan:2,
				autoPopup:true,
				name: 'BANK_CODE',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('BANK_CODE', '');
                        panelResult.setValue('BANK_NAME', '');
                    }
                }
		}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '출력기준',						            		
				itemId: 'RADIO4',
				labelWidth: 90,
				items: [{
					boxLabel: '은행별', 
					width: 80, 
					name: 'COST_POOL',
					inputValue: '1',
					checked: true  
				},{
					boxLabel: '전체', 
					width: 80, 
					name: 'COST_POOL',
					inputValue: '2'
				},{
					boxLabel: 'Cost Pool', 
					width: 80, 
					name: 'COST_POOL',
					inputValue: '3'
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '계좌번호출력',						            		
				itemId: 'BANK_ACCOUNT',
				labelWidth: 90,
				items: [{
					boxLabel: '계좌번호1', 
					width: 120, 
					name: 'BANK_ACCOUNT',
					inputValue: '1',
					checked: true  
				},{
					boxLabel: '계좌번호2', 
					width: 110, 
					name: 'BANK_ACCOUNT',
					inputValue: '2'
				}]
			}
			,{
				xtype: 'radiogroup',		            		
				fieldLabel: '주민등록번호',						            		
				itemId: 'REPRE_NUM',
				labelWidth: 90,
				hidden: (bHideRepreNumOptions == 'Y' ? false : true),
				items: [{
					boxLabel: '뒷자리만 암호화', 
					width: 120, 
					name: 'REPRE_NUM',
					inputValue: '1',
					checked: true  
				},{
					boxLabel: '전체 암호화', 
					width: 110, 
					name: 'REPRE_NUM',
					inputValue: '2'
				},{
					boxLabel: '암호화 없음', 
					width: 110, 
					name: 'REPRE_NUM',
					inputValue: '3'
				}]
			}
			,
      			{
             	xtype:'button',
             	text:'출    력',
             	width:235,
             	tdAttrs:{'align':'center', style:'padding-left:40px'},
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
				panelResult
			]	
		}		
		], 
		id: 'hpa930rkrApp',
		fnInitBinding : function() {
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		checkForNewDetail:function() { 			
        },
		onQueryButtonDown : function()	{
		
		},
		onResetButtonDown: function() {
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			var param = Ext.getCmp('resultForm').getValues();
			var ym = param.PAY_YYYYMM.substring(0, 4) + "년 " + param.PAY_YYYYMM.substring(4, 6) + "월  ";
			
            param.sTxtValue2_fileTitle = ym + '급여이체리스트';
			param.SHOW_REPRE_NUM = bHideRepreNumOptions;
			
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/human/hpa930clrkrv.do',
				prgID: 'hpa930rkr',
				extParam: param
			});
			
			win.center();
			win.show();
		},
		onPrintButtonDown_bak: function() {
			var param = Ext.getCmp('resultForm').getValues();
// 			var startField = panelResult.getField('DATE_FR');
//			var startDateValue = startField.getStartDate();
//			var endField = panelResult.getField('DATE_TO');
//			var endDateValue = endField.getEndDate();
//			param['DATE_FR'] = startDateValue;
//			param['DATE_TO'] = endDateValue;
			
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/hpa/hpa930rkrPrint.do',
				prgID: 'hpa930rkr',
				extParam: param
			});
			win.center();
			win.show();   				
		}
	}); //End of
};

</script>
