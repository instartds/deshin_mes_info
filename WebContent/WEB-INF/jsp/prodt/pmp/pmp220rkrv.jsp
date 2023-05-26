<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp220rkrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="pmp220rkrv"  /> 			<!-- 사업장 -->
<t:ExtComboStore comboType="W" /><!-- 작업장  -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="BPR100ukrvLevel1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="BPR100ukrvLevel2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="BPR100ukrvLevel3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var BsaCodeInfo = {
		gsReportGubun: '${gsReportGubun}'//클립리포트 추가로 인한 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
}
function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
//    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{
	    	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox',
	    	comboType:'BOR120',
	    	allowBlank:false,
	    	value: UserInfo.divCode,
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE','');
				}
    		}
    	},{
	    	fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
	    	name:'WORK_SHOP_CODE',
	    	xtype: 'uniCombobox',
	    	comboType:'W',
			listeners: {
                beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                    store.clearFilter();
                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                        store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                    }else{
                        store.filterBy(function(record){
                            return false;
                        });
                    }
                }
			}

    	},{
	    		fieldLabel: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>',
	    		xtype: 'uniDateRangefield',
	    		allowBlank:false,
	    		startFieldName: 'DATE_FR',
	    		endFieldName: 'DATE_TO',
	    		startDate: UniDate.get('today'),
	    		endDate: UniDate.get('today'),
	    		width:315
		},{
	    	xtype: 'container',
			layout : {type : 'uniTable'},
			columns: 2,
			items:[{
		    		fieldLabel:'<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>',
					name: 'FR_OUT_STOCK_NUM',
					xtype: 'uniTextfield'
		    	},{
		    		fieldLabel:'~',
		    		labelWidth:30,
					name: 'TO_OUT_STOCK_NUM',
					xtype: 'uniTextfield'
		}]
		},
		Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					validateBlank	: false,
					holdable		: 'hold',
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
		   }),{
		    	name: 'ITEM_LEVEL1',
    			fieldLabel: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
    			xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('BPR100ukrvLevel1Store'),

                child: 'ITEM_LEVEL2'

              }, {
              	name: 'ITEM_LEVEL2',
              	fieldLabel: '<t:message code="system.label.product.middlegroup" default="중분류"/>',
              	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('BPR100ukrvLevel2Store'),

                child: 'ITEM_LEVEL3'

             }, {
             	name: 'ITEM_LEVEL3',
             	fieldLabel: '<t:message code="system.label.product.minorgroup" default="소분류"/>',
             	xtype:'uniCombobox',

                store: Ext.data.StoreManager.lookup('BPR100ukrvLevel3Store')
            }, {
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.product.printcondition" default="출력조건"/>',
				items: [{
					boxLabel: '<t:message code="system.label.product.issuerequestnoby" default="출고요청번호별"/>',
					width: 150,
					name: 'opt',
					inputValue: '1',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.product.itemby" default="품목별"/>',
					width: 130,
					name: 'opt',
					inputValue: '2'
				}]
		}]
    });


    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]
		}
		],
		id  : 'pmp220rkrvApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DATE_FR',UniDate.get('today'));
			panelResult.setValue('DATE_TO',UniDate.get('today'));
			panelResult.setValue('opt','1');

			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons('query',false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
        onPrintButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			var param = panelResult.getValues();
			var win;

			//공통코드에서 설정한 리포트를 가져오기 위한 파라메터 세팅
     		param.PGM_ID = PGM_ID;  //프로그램ID
     		param.MAIN_CODE = 'P010' //해당 모듈의 출력정보를 가지고 있는 공통코드
     		param["RPT_ID"]='pmp220rkrv';
			param["PGM_ID"]='pmp220rkrv';
			param["sTxtValue2_fileTitle"]='출고요청현황';
     		var reportGubun = BsaCodeInfo.gsReportGubun //초기화 시 가져온 구분값, 값이 없거나 CR이면 크리스탈리포트나 jasper리포트 출력
			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
				win = Ext.create('widget.CrystalReport', {
	                url: CPATH+'/prodt/pmp220crkrv.do',
	                prgID: 'pmp220rkrv',
	                extParam: param
	            });
			}else{
				 win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/prodt/pmp220clrkrv.do',
	                prgID: 'pmp220rkrv',
	                extParam: param
	            });
			}
				win.center();
				win.show();
		}
	});
};

</script>
