<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa980rkr"  >
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


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
	      api: {
	          read: 'hpa980rkrService.selectList'

	      }
    });
	Unilite.defineModel('hpa980rkrModel', {
        fields: [
			 {name: 'CNT'     ,text: '법인코드'       ,type: 'int' 		,allowBlank:true}
        ]
    });
	  /**
     * Store 정의(Service 정의)
     * @type
     */
    var detailStore = Unilite.createStore('hpa980rkrStore', {
        model: 'hpa980rkrModel',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            allDeletable:false,
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        saveStore : function(config)    {

        },
        listeners: {
            load: function(store, records, successful, eOpts) {

            }
        },
        loadStoreRecords: function() {

            var param = panelResult.getValues();
            console.log( param );
            this.load({
                params: param
            });
        }
    });

    var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'west',
		layout : {type : 'uniTable', columns : 1
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'radiogroup',
			fieldLabel: '출력선택',
			itemId: 'GBN',
			labelWidth: 90,
			items: [{
				boxLabel: '입금의뢰서',
				width: 80,
				name: 'GBN',
				inputValue: '1',
				checked: true
			},{
				boxLabel: '지출결의서',
				width: 80,
				name: 'GBN',
				inputValue: '2'
			}],listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue["GBN"] == "1"){

						Ext.getCmp('PAY_CODE').setReadOnly(false);
						Ext.getCmp('BANK_ACCOUNT').setReadOnly(false);
						Ext.getCmp('BANK_CODE').setReadOnly(false);

					}else{

						Ext.getCmp('PAY_CODE').setReadOnly(true);
						Ext.getCmp('BANK_ACCOUNT').setReadOnly(true);
						Ext.getCmp('BANK_CODE').setReadOnly(true);


					}


				}
			}
		},{
				fieldLabel: '지급년월',
				id: 'PAY_YYYYMM',
				xtype: 'uniMonthfield',
				name: 'PAY_YYYYMM',
				value: new Date(),
				allowBlank: false,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						detailStore.loadStoreRecords();
					}
				}
			},{
		        fieldLabel: '급상여구분',
		        id: 'SUPP_TYPE',
		        name:'SUPP_TYPE',
		        xtype: 'uniCombobox',
		        comboType: 'AU',
		        comboCode:'H032',
		        value: '1',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						detailStore.loadStoreRecords();
					}
				}
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
				autoPopup:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_CODE',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPT_CODES') ;
	                    	tagfield.setStoreData(records)
	                }
				}

			}),
			{
                fieldLabel: '급여지급방식',
                id:'PAY_CODE',
                name:'PAY_CODE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H028'

            },
            Unilite.popup('Employee',{
		      	fieldLabel : '성명|사번',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
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
				name: 'BANK_CODE',
				id:'BANK_CODE'

		}),Unilite.popup('COST_POOL_CBM600T',{
			fieldLabel: '회계부서',
			valueFieldName: 'COST_POOL_CODE',
			textFieldName: 'COST_POOL_NAME',
			colspan:2,
			name: 'COST_POOL_CODE'
	}),{
				xtype: 'radiogroup',
				fieldLabel: '계좌번호출력',
				id:'BANK_ACCOUNT',
				itemId: 'BANK_ACCOUNT',
				labelWidth: 90,
				items: [{
					boxLabel: '전체',
					width: 50,

					name: 'BANK_ACCOUNT',
					inputValue: '1',
					checked: true
				},{
					boxLabel: '계좌번호1',
					width: 80,

					name: 'BANK_ACCOUNT',
					inputValue: '2',

				},{
					boxLabel: '계좌번호2',
					width: 80,

					name: 'BANK_ACCOUNT',
					inputValue: '3'
				}]
			},
      			{
             	xtype:'button',
             	text:'출    력',
             	width:235,
             	tdAttrs:{'align':'center', style:'padding-left:40px'},
             	handler:function()	{

             		var records = detailStore.data.items;
             		var cnt = 0;
             		var comboPayYyyyMm = Ext.getCmp('PAY_YYYYMM');
             		var comboSuppType = Ext.getCmp('SUPP_TYPE');
             		var payYyyyMm = comboPayYyyyMm.getRawValue().replace('.','');
             		var payYyyy =  String(payYyyyMm).substring(0,4);
             		var payMm =  String(payYyyyMm).substring(4,6);
             		var suppTypeText = comboSuppType.getRawValue();
             		Ext.each(records, function(item, i){

             			cnt = item.get("CNT");

					})

				 	if(cnt == 0){
				 		alert(payYyyy + '년 ' + payMm + '월의'  + ' 급/상여 정보(' + suppTypeText + ')가 마감 안 되었습니다.\n마감 후 다시 시도해주세요.');
				 		return false;
				 	}

                  if(!panelResult.getInvalidMessage()) return;
                   		 var param= panelResult.getValues();
	                       //	param.OPT_PRINT_GB = panelResult.getValue('optPrintGb').optPrintGb;
	                           var win = Ext.create('widget.CrystalReport', {
	                               url: CPATH+'/human/hpa980rkrPrint.do',
	                               prgID: 'hpa981rkr',
	                               extParam: param
	                           });
	                           win.center();
	                           win.show();
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
		id: 'hpa980rkrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save',false);
		    UniAppManager.setToolbarButtons(['query'], false);
			detailStore.loadStoreRecords();
			panelResult.setValue('PAY_YYYYMM', new Date());
			panelResult.setValue('BANK_ACCOUNT', '1');
			panelResult.setValue('GBN', '1');
			panelResult.setValue('BANK_CODE', '');
			panelResult.setValue('BANK_NAME', '');
			panelResult.setValue('COST_POOL_CODE', '');
			panelResult.setValue('COST_POOL_NAME', '');
			panelResult.setValue('PERSON_NUMB', '');
			panelResult.setValue('NAME', '');
			panelResult.setValue('DEPT_CODE', '');
			panelResult.setValue('DEPT_NAME', '');
			panelResult.setValue('DEPT_CODES', '');

			panelResult.setValue('SUPP_TYPE', '1');
			panelResult.setValue('PAY_CODE', '');
			panelResult.setValue('DIV_CODE', '');

		},
		checkForNewDetail:function() {
        },
		onQueryButtonDown : function()	{

		},
		onResetButtonDown: function() {
			//this.fnInitBinding();
			panelResult.clearForm();
			panelResult.setValue('PAY_YYYYMM', new Date());
			panelResult.setValue('BANK_ACCOUNT', '1');
			panelResult.setValue('GBN', '1');
			panelResult.setValue('SUPP_TYPE', '1');
		}
	}); //End of
};

</script>
