<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa800ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="A020" />
</t:appConfig>
<script type="text/javascript" >

var ReceiveWindow;

function appMain() {


	var memberStore = Unilite.createStore('bsa800ukrvCountStore', {  // 갯수 체크
	    fields: ['text', 'value'],
		data :  [
	        {'text':'1'		, 'value':'1'},
	        {'text':'2'		, 'value':'2'},
	        {'text':'3'		, 'value':'3'},
	        {'text':'4'		, 'value':'4'},
	        {'text':'5'		, 'value':'5'},
	        {'text':'6'		, 'value':'6'},
	        {'text':'7'		, 'value':'7'},
	        {'text':'8'		, 'value':'8'}
		]
	});
	var useStore = Unilite.createStore('bsa800ukrvUseStore', {  // 전표출력 추가결재란 사용여부 관련
        fields: ['text', 'value'],
        data :  [
            {'text':'<t:message code="system.label.base.unused" default="미사용"/>'   , 'value':'1'},
            {'text':'<t:message code="system.label.base.use" default="사용"/>'     , 'value':'2'}
        ]
    });

	/**
	 * 수주등록 Master Form
	 *
	 * @type
	 */
	var detailForm = Unilite.createForm('bsa800ukrvDetail', {
    	disabled :false,
        width:500,
        layout:{
        	type:'vbox'
        },
        margin: 10,
		items: [
	    	{
				xtype: 'uniFieldset',
				title: '<t:message code="system.label.base.basicoption" default="기본옵션"/>',
				height:40,
				layout: {type: 'vbox', align:'stretch'},
				hidden:true,
				items:[
					{ fieldLabel:'PGM_ID',
					  name: 'PGM_ID',
					  value:'$',
					  hidden:true
					},
					{
						fieldLabel: '<t:message code="system.label.base.sheetfocusyn" default="시트에서 포커스 이동방향은?"/>',
						name: 'BA_GRDFOCUS_YN',
						xtype: 'uniRadiogroup',
						labelWidth: 250,
						labelAlign: 'left',
						width: 380,
						allowBlank: false,
//						hidden:true,
						items: [
					            { boxLabel: '<t:message code="system.label.base.right" default="오른쪽"/>', name: 'BA_GRDFOCUS_YN', inputValue: 'Y' , checked: true},
					            { boxLabel: '<t:message code="system.label.base.left" default="왼쪽"/>' , name: 'BA_GRDFOCUS_YN', inputValue: 'N'}
					        ]
		        	}]
	    	},{
				xtype: 'uniFieldset',
				title: '<t:message code="system.label.base.pdfprintwindow.fornTitle" default="출력옵션"/>',
				layout: {type: 'vbox', align:'stretch'},
				items:[
					{
						fieldLabel: '<t:message code="system.label.base.companyyn" default="회사명을 인쇄 하시겠습니까?"/>',
						name: 'PT_COMPANY_YN',
						xtype: 'uniRadiogroup',
						labelWidth: 250,
						labelAlign: 'left',
						width: 380,
						allowBlank: false,
						items: [
					            { boxLabel: '<t:message code="system.label.base.yes" default="예"/>'		, name: 'PT_COMPANY_YN', inputValue: 'Y' , checked: true},
					            { boxLabel: '<t:message code="system.label.base.no" default="아니오"/>'  , name: 'PT_COMPANY_YN', inputValue: 'N'}
					        ]
		        	},{
						fieldLabel: '<t:message code="system.label.base.printdateyn" default="출력일을 인쇄 하시겠습니까?"/>',
						name: 'PT_OUTPUTDATE_YN',
						xtype: 'uniRadiogroup',
						labelWidth: 250,
						labelAlign: 'left',
						width: 380,
						allowBlank: false,
						items: [
					            { boxLabel: '<t:message code="system.label.base.yes" default="예"/>'		, name: 'PT_OUTPUTDATE_YN', inputValue: 'Y' , checked: true},
					            { boxLabel: '<t:message code="system.label.base.no" default="아니오"/>'  , name: 'PT_OUTPUTDATE_YN', inputValue: 'N'}
					        ]
		        	},{
						fieldLabel: '나나나난나나',
						name: 'PT_PAGENUM_YN',
						xtype: 'uniRadiogroup',
						labelWidth: 250,
						labelAlign: 'left',
						width: 380,
						allowBlank: false,
						items: [
					            { boxLabel: '<t:message code="system.label.base.yes" default="예"/>'		, name: 'PT_PAGENUM_YN', inputValue: 'Y' , checked: true},
					            { boxLabel: '<t:message code="system.label.base.no" default="아니오"/>'  , name: 'PT_PAGENUM_YN', inputValue: 'N'}
					        ]
		        	},{
						fieldLabel: '<t:message code="system.label.base.printsanctionyn" default="결제란을 인쇄 하시겠습니까?"/>',
						name: 'PT_SANCTION_YN',
						xtype: 'uniRadiogroup',
						labelWidth: 250,
						labelAlign: 'left',
						width: 380,
						allowBlank: false,
						items: [
					            { boxLabel: '<t:message code="system.label.base.yes" default="예"/>'		, name: 'PT_SANCTION_YN', inputValue: 'Y' , checked: true},
					            { boxLabel: '<t:message code="system.label.base.no" default="아니오"/>'  , name: 'PT_SANCTION_YN', inputValue: 'N'}
					        ]
		        	},{
				    	xtype: 'container',
				    	padding: '7 0 7 0',
				    	//margin: '0 50 0 20',
				    	layout: {
				    		type: 'hbox',
							align: 'center',
							pack: 'center'
				    	},
				    	items:[{
				    		xtype: 'button',
				    		text: '<t:message code="system.label.base.executetype" default="결제란 등록"/>',
				    		name: 'EXECUTE_TYPE',
					    	//inputValue: '1',
				    		width: 100,
				    		handler: function() {
				    			openReceiveWindow();
				    		}
				    	}]
				}]
	    }],
		api: {
			load: 'bsa800ukrvService.select',
			submit: 'bsa800ukrvService.save'
		},
		listeners: {
				dirtychange:function( basicForm, dirty, eOpts ) {
					console.log("onDirtyChange");
					UniAppManager.setToolbarButtons('save', true);
				},
				beforeaction:function(basicForm, action, eOpts)	{
					if(action.type =='directsubmit')	{
						var invalid = this.getForm().getFields().filterBy(function(field) {
						            return !field.validate();
						});
			        if(invalid.length > 0)	{
				        r=false;
				        var labelText = ''
				        if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
				        	var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				        }else if(Ext.isDefined(invalid.items[0].ownerCt))	{
				        	var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				        }
				        Unilite.messageBox(labelText+Msg.sMB083);
				        invalid.items[0].focus();
				        }
					}
				}
			}
	});

	var receiptSearch = Unilite.createSearchForm('receiptSearchForm', {		//결재란등록
		layout: {type: 'uniTable', columns : 1},
        padding: '0 0 0 0',
	    //trackResetOnLoad: true,
	    items: [{
            title: '<t:message code="system.label.base.comman" default="공통"/>',
            xtype: 'fieldset',
            id: 'fieldset1',
            padding: '0 5 5 5',
            margin: '0 0 5 5',
            width: 615,
            layout: {type: 'uniTable' , columns: 4
//                    tdAttrs: {style: 'border : 1px solid #ced9e7;'}
            },
            items: [{
                fieldLabel:'PGM_ID',
                name: 'PGM_ID',
                value:'$',
                hidden:true
            },{
                fieldLabel: '<t:message code="system.label.base.count" default="갯수"/>',
                name:'PT_SANCTION_NO',
                xtype: 'uniCombobox',
                allowBlank:false,
                colspan:2,
                store: Ext.data.StoreManager.lookup('bsa800ukrvCountStore'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        if(receiptSearch.getValue('PT_SANCTION_NO') == 1) {
                            receiptSearch.setValue('PT_SANCTION_NM2', '');
                            receiptSearch.setValue('PT_SANCTION_NM3', '');
                            receiptSearch.setValue('PT_SANCTION_NM4', '');
                            receiptSearch.setValue('PT_SANCTION_NM5', '');
                            receiptSearch.setValue('PT_SANCTION_NM6', '');
                            receiptSearch.setValue('PT_SANCTION_NM7', '');
                            receiptSearch.setValue('PT_SANCTION_NM8', '');

                            receiptSearch.getField("PT_SANCTION_NM2").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM3").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM4").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM5").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM6").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM7").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM8").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO') == 2){
                            receiptSearch.setValue('PT_SANCTION_NM3', '');
                            receiptSearch.setValue('PT_SANCTION_NM4', '');
                            receiptSearch.setValue('PT_SANCTION_NM5', '');
                            receiptSearch.setValue('PT_SANCTION_NM6', '');
                            receiptSearch.setValue('PT_SANCTION_NM7', '');
                            receiptSearch.setValue('PT_SANCTION_NM8', '');

                            receiptSearch.getField("PT_SANCTION_NM2").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM4").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM5").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM6").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM7").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM8").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO') == 3){
                            receiptSearch.setValue('PT_SANCTION_NM4', '');
                            receiptSearch.setValue('PT_SANCTION_NM5', '');
                            receiptSearch.setValue('PT_SANCTION_NM6', '');
                            receiptSearch.setValue('PT_SANCTION_NM7', '');
                            receiptSearch.setValue('PT_SANCTION_NM8', '');

                            receiptSearch.getField("PT_SANCTION_NM2").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM4").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM5").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM6").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM7").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM8").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO') == 4){
                            receiptSearch.setValue('PT_SANCTION_NM5', '');
                            receiptSearch.setValue('PT_SANCTION_NM6', '');
                            receiptSearch.setValue('PT_SANCTION_NM7', '');
                            receiptSearch.setValue('PT_SANCTION_NM8', '');

                            receiptSearch.getField("PT_SANCTION_NM2").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM4").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM5").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM6").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM7").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM8").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO') == 5){
                            receiptSearch.setValue('PT_SANCTION_NM6', '');
                            receiptSearch.setValue('PT_SANCTION_NM7', '');
                            receiptSearch.setValue('PT_SANCTION_NM8', '');

                            receiptSearch.getField("PT_SANCTION_NM2").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM4").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM5").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM6").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM7").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM8").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO') == 6){
                            receiptSearch.setValue('PT_SANCTION_NM7', '');
                            receiptSearch.setValue('PT_SANCTION_NM8', '');

                            receiptSearch.getField("PT_SANCTION_NM2").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM4").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM5").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM6").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM7").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM8").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO') == 7){
                            receiptSearch.setValue('PT_SANCTION_NM8', '');

                            receiptSearch.getField("PT_SANCTION_NM2").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM4").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM5").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM6").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM7").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM8").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO') == 8){
                            receiptSearch.getField("PT_SANCTION_NM2").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM4").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM5").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM6").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM7").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM8").setReadOnly(false);
                        }
                    }
                }
            },{
                xtype: 'radiogroup',
                fieldLabel: '<t:message code="system.label.base.location1" default="위치"/>',
                colspan:2,
                items: [{
                    boxLabel : '<t:message code="system.label.base.top" default="상"/>',
                    width: 60,
                    name: 'PT_SANCTION_PO',
                    inputValue: 'T',
                    checked: true
                }]
            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM1',
                maxLength: 4,
                enforceMaxLength: true
                //width:100,

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM2',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM3',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM4',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM5',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM6',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM7',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM8',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            }]
        },{
            fieldLabel: '<t:message code="system.label.base.addexecuteyn" default="추가결재란 사용여부"/>',
            name:'GUBUN_FLAG',
            xtype: 'uniCombobox',
            labelWidth:130,
            allowBlank:false,
            store: Ext.data.StoreManager.lookup('bsa800ukrvUseStore'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                	if(newValue == '1'){
                	   Ext.getCmp('fieldset2').setDisabled(true);
                	}else if(newValue == '2'){
                       Ext.getCmp('fieldset2').setDisabled(false);
                	}
                }
            }
        },{
            title: '<t:message code="system.label.base.printslipexecute" default="전표출력 결재란"/>2',
            xtype: 'fieldset',
            id: 'fieldset2',
            padding: '0 5 5 5',
            margin: '0 0 5 5',
            width: 615,
            disabled:true,
            layout: {type: 'uniTable' , columns: 4
//                    tdAttrs: {style: 'border : 1px solid #ced9e7;'}
            },
            items: [{
                fieldLabel: '<t:message code="system.label.base.count" default="갯수"/>',
                name:'PT_SANCTION_NO_SEC',
                xtype: 'uniCombobox',
                allowBlank:false,
                colspan:2,
                store: Ext.data.StoreManager.lookup('bsa800ukrvCountStore'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        if(receiptSearch.getValue('PT_SANCTION_NO_SEC') == 1) {
                            receiptSearch.setValue('PT_SANCTION_NM2_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM3_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM4_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM5_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM6_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM7_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM8_SEC', '');

                            receiptSearch.getField("PT_SANCTION_NM2_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM3_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM4_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM5_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM6_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM7_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM8_SEC").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO_SEC') == 2){
                            receiptSearch.setValue('PT_SANCTION_NM3_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM4_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM5_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM6_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM7_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM8_SEC', '');

                            receiptSearch.getField("PT_SANCTION_NM2_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM4_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM5_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM6_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM7_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM8_SEC").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO_SEC') == 3){
                            receiptSearch.setValue('PT_SANCTION_NM4_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM5_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM6_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM7_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM8_SEC', '');

                            receiptSearch.getField("PT_SANCTION_NM2_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM4_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM5_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM6_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM7_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM8_SEC").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO_SEC') == 4){
                            receiptSearch.setValue('PT_SANCTION_NM5_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM6_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM7_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM8_SEC', '');

                            receiptSearch.getField("PT_SANCTION_NM2_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM4_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM5_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM6_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM7_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM8_SEC").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO_SEC') == 5){
                            receiptSearch.setValue('PT_SANCTION_NM6_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM7_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM8_SEC', '');

                            receiptSearch.getField("PT_SANCTION_NM2_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM4_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM5_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM6_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM7_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM8_SEC").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO_SEC') == 6){
                            receiptSearch.setValue('PT_SANCTION_NM7_SEC', '');
                            receiptSearch.setValue('PT_SANCTION_NM8_SEC', '');

                            receiptSearch.getField("PT_SANCTION_NM2_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM4_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM5_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM6_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM7_SEC").setReadOnly(true);
                            receiptSearch.getField("PT_SANCTION_NM8_SEC").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO_SEC') == 7){
                            receiptSearch.setValue('PT_SANCTION_NM8_SEC', '');

                            receiptSearch.getField("PT_SANCTION_NM2_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM4_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM5_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM6_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM7_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM8_SEC").setReadOnly(true);

                        }else if(receiptSearch.getValue('PT_SANCTION_NO_SEC') == 8){
                            receiptSearch.getField("PT_SANCTION_NM2_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM3_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM4_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM5_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM6_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM7_SEC").setReadOnly(false);
                            receiptSearch.getField("PT_SANCTION_NM8_SEC").setReadOnly(false);
                        }
                    }
                }
            },{
                xtype: 'radiogroup',
                fieldLabel: '<t:message code="system.label.base.location1" default="위치"/>',
                colspan:2,
                items: [{
                    boxLabel : '<t:message code="system.label.base.top" default="상"/>',
                    width: 60,
                    name: 'PT_SANCTION_PO_SEC',
                    inputValue: 'T',
                    checked: true
                }]
            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM1_SEC',
                maxLength: 4,
                enforceMaxLength: true
                //width:100,

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM2_SEC',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM3_SEC',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM4_SEC',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM5_SEC',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM6_SEC',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM7_SEC',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            },{
                xtype: 'uniTextfield' ,
                name: 'PT_SANCTION_NM8_SEC',
                maxLength: 4,
                enforceMaxLength: true
                //,width:100

            }]
        }],
		api: {
			load: 'bsa800ukrvService.receiptSelect',
			submit: 'bsa800ukrvService.receiptSave'
		}
    });

	function openReceiveWindow() {
		if(!ReceiveWindow) {
			ReceiveWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.purchase.approvalcolumnentry" default="결재란등록"/>',
                width: 638,
                height: 315,
                minWidth: 638,
                maxWidth: 638,
                minHeight: 315,
                maxHeight: 315,
                layout: {type:'vbox', align:'stretch'},
                items: [receiptSearch],
				tbar: [{
                    itemId: 'saveBtn',
                    text: '<t:message code="system.label.base.save" default="저장 "/>',
                    handler: function() {
                        receiptSearch.getForm().submit({
                            success: function(form, action) {
                                UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
                                ReceiveWindow.hide();
                            }
                        });
                    },
					disabled: false
				},
				'->',
				{
				    itemId: 'OrderNoCloseBtn',
					text: '<t:message code="system.label.base.close" default="닫기"/>',
					handler: function() {
						ReceiveWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					/*beforehide: function(me, eOpt)	{

					},
					beforeclose: function( panel, eOpts )	{

					},*/
					show: function( panel, eOpts )	{
						receiptSearch.getForm().load();
				 	}
                }
			})
		}
		ReceiveWindow.center();
		ReceiveWindow.show();
    }

    /**
	 * main app
	 */
    Unilite.Main( {
		id: 'bsa800ukrvApp',
		items: [ detailForm],
		fnInitBinding : function() {
			this.setToolbarButtons(['newData','reset'],false);
			this.onQueryButtonDown();
		},
		onQueryButtonDown:function () {
			detailForm.getForm().load();
		},
		onSaveDataButtonDown: function (config) {
			var param= detailForm.getValues();
			detailForm.getForm().submit({
				params : param,
				success : function(form, action) {
					detailForm.getForm().wasDirty = false;
					detailForm.resetDirtyStatus();
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.app.onQueryButtonDown();
			        UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
				}
			});
		}
	});

}
</script>
