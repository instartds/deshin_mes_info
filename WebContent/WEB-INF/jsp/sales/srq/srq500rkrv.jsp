<%--
'   프로그램명 : 패킹번호 출력
'
'   작  성  자 : (주)시너지시스템즈 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="srq500rkrv">
	<t:ExtComboStore comboType="BOR120"/> 			<!-- 사업장 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

function appMain() {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'west',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			labelWidth	: 100,
			allowBlank	: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.packingdate" default="패킹일자"/>',
			xtype		: 'uniDatefield',
			name		: 'PACKING_DATE',
			value		: UniDate.get('today'),
			labelWidth	: 100,
			allowBlank	: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.lastseq" default="마지막 패킹번호"/>',
			xtype		: 'uniTextfield',
			name		: 'LAST_SEQ',
			labelWidth	: 100,
			allowBlank	: false,
			readOnly	: true,
			fieldStyle	: 'text-align: center'
		},{
			fieldLabel	: '<t:message code="system.label.sales.printcount" default="출력수량"/>',
			xtype		: 'uniNumberfield',
			name		: 'PRINT_CNT',
			labelWidth	: 100,
			allowBlank	: false
		},{
			text		: '<t:message code="system.label.sales.print" default="출력"/>',
			xtype		: 'button',
			width		: 150,
			tdAttrs		: {style: 'padding-left: 105px;'},
			handler		: function() {
				UniAppManager.app.fnPrint();
			}
		},{
			xtype		: 'component',
			html		: '&nbsp;',
			margin		: '25 0 0 30'
		},{
			xtype		: 'container',
			layout		: {type : 'uniTable', columns : 3},
			//width		: 600,
			items:[{
				fieldLabel	: '<t:message code="system.label.sales.printeachdate" default="출력패킹번호"/>',
				xtype		: 'uniDatefield',
				name		: 'PACKING_DATE_EACH',
				value		: UniDate.get('today'),
				labelWidth	: 100,
				allowBlank	: false
			},{
				fieldLabel	: '<t:message code="system.label.sales.printeachseq" default="출력수량"/>',
				xtype		: 'uniTextfield',
				name		: 'PRINT_SEQ_EACH',
				hideLabel	: true,
				labelWidth	: 100
			}]
		},{
			text		: '<t:message code="system.label.sales.printeach" default="개별출력"/>',
			xtype		: 'button',
			width		: 150,
			tdAttrs		: {style: 'padding-left: 105px;'},
			handler		: function() {
				UniAppManager.app.fnPrintEach();
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
		id: 'srq500rkrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
			
			this.onQueryButtonDown();
		},
		onQueryButtonDown: function() {
			var param = {
				DIV_CODE	: panelResult.getValue('DIV_CODE'),
				BASIS_DATE	: Ext.Date.format(panelResult.getValue('PACKING_DATE'), 'ymd')			//	yymmdd
			};
			
			srq500rkrvService.checkMaxSeq(param, function(provider, response){
				if(!Ext.isEmpty(provider)) {
					panelResult.setValue('LAST_SEQ', provider[0].LAST_SEQ);
				}
			});
		},
		onPrintButtonDown: function(seqList) {
			if(Ext.isEmpty(seqList)) {
				seqList = [];
			}
			
			var dtBasis = Ext.Date.format(panelResult.getValue('PACKING_DATE'), 'ymd');
			var param = {
				DIV_CODE	: panelResult.getValue('DIV_CODE'),
				BASIS_DATE	: dtBasis,
				PRINT_CNT	: seqList.join(',')
			};
			
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/sales/srq500clrkrv.do',
				prgID: 'srq500rkrv',
				extParam: param
			});
			win.center();
			win.show();
		},
		fnPrint: function() {
			var seqFr, seqTo;
			var seqList = [];
			var dtBasis = Ext.Date.format(panelResult.getValue('PACKING_DATE'), 'ymd');
			
			if(!panelResult.getInvalidMessage()) {
				return;
			}
			
			seqFr = Number(panelResult.getValue('LAST_SEQ').substring(6, 9)) + 1;
			seqTo = seqFr + Number(panelResult.getValue('PRINT_CNT')) - 1;
			
			if(seqTo > 999) {
				Unilite.messageBox('패킹번호가 999를 초과했습니다. 수량을 조정하여 주십시오.');
				return;
			}
			
			for(var lLoop = seqFr; lLoop <= seqTo; lLoop++) {
				var seq;
				
				if(lLoop < 10) {
					seq = dtBasis + '00' + String(lLoop);
				}
				else if(lLoop < 100) {
					seq = dtBasis + '0' + String(lLoop);
				}
				else {
					seq = dtBasis + String(lLoop);
				}
				
				if(seqList.indexOf(seq) < 0) {
					seqList.push(seq);
				}
			}
			
			this.onPrintButtonDown(seqList);
			
			var dtBasis = Ext.Date.format(panelResult.getValue('PACKING_DATE'), 'ymd');
			var param = {
				DIV_CODE	: panelResult.getValue('DIV_CODE'),
				BASIS_DATE	: dtBasis,
				LAST_SEQ	: Number(seqList[seqList.length - 1].substring(6, 9))
			};
			
			srq500rkrvService.updateMaxSeq(param, function(provider, response){
				if(!Ext.isEmpty(provider)) {
					UniAppManager.app.onQueryButtonDown();
				}
				else {
					Unilite.messageBox('출력 순번 업데이트 중 오류가 발생하였습니다.');
				}
			});
		},
		fnPrintEach: function() {
			var eachCount = panelResult.getValue('PRINT_SEQ_EACH');
			var eachList = eachCount.split(',');
			var seqList = [];
			var dtBasis = Ext.Date.format(panelResult.getValue('PACKING_DATE'), 'ymd');
			
			Ext.each(eachList, function(seqs){
				if(seqs.indexOf('-') > 0) {
					var seqRange = seqs.split('-');
					var seqFr, seqTo;
					
					if(UniAppManager.app.trim(seqRange[0]) > UniAppManager.app.trim(seqRange[1])) {
						seqFr = UniAppManager.app.trim(seqRange[1]);
						seqTo = UniAppManager.app.trim(seqRange[0]);
					}
					else {
						seqFr = UniAppManager.app.trim(seqRange[0]);
						seqTo = UniAppManager.app.trim(seqRange[1]);
					}
					
					if(UniAppManager.app.isNumeric(seqFr) && UniAppManager.app.isNumeric(seqTo)) {
						for(var lLoop = seqFr; lLoop <= seqTo; lLoop++) {
							var seq;
							
							if(lLoop < 10) {
								seq = dtBasis + '00' + String(lLoop);
							}
							else if(lLoop < 100) {
								seq = dtBasis + '0' + String(lLoop);
							}
							else {
								seq = dtBasis + String(lLoop);
							}
							
							if(seqList.indexOf(seq) < 0) {
								seqList.push(seq);
							}
						}
					}
				}
				else {
					seqs = UniAppManager.app.trim(seqs);
					
					if(UniAppManager.app.isNumeric(seqs)) {
						var seq;
						
						if(lLoop < 10) {
							seq = dtBasis + '00' + String(seqs);
						}
						else if(lLoop < 100) {
							seq = dtBasis + '0' + String(seqs);
						}
						else {
							seq = dtBasis + String(seqs);
						}
						
						if(seqList.indexOf(seq) < 0) {
							seqList.push(seq);
						}
					}
				}
			});
			
			this.onPrintButtonDown(seqList);
		},
		isNumeric: function(value) {
			//return !Number.isNaN(UniAppManager.app.trim(value));
			return /^-?\d+$/.test(value);
		},
		trim: function(value) {
			return String(value).replace(/\s/g, '');
		}
	}); //End of 	Unilite.Main( {
	
}
</script>