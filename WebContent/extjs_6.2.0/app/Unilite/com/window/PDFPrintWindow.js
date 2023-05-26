//@charset UTF-8
Ext.define('Unilite.com.window.PDFPrintWindow', {
	extend: 'Unilite.com.window.UniWindow',
	requires: [
		'Ext.ux.IFrame',
		'Unilite.com.UniUtils',
		'Unilite.com.form.UniSearchPanel',
		'Unilite.com.form.UniSearchSubPanel',
		'Unilite.com.layout.UniTable',
		'Unilite.com.form.field.UniTextField',
		'Unilite.com.form.field.UniDateField'
	],
	alias: 'widget.PDFPrintWindow',
	width: 600,
	basePosition:'maximized',
	height: 700,
	title: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.title','인쇄'),
    closable: true,
    disabled: false,
	constructor: function(config){
        var me = this;
       	if (config) {
            Ext.apply(me, config);
        };




	    var itemStyle ={'margin-left':'2px','margin-bottom':'10px','margin-right':'5px'};
        var configForm = {
        	xtype: 'uniSearchForm',
        	itemId: 'configForm',
        	width: 200,
        	region: 'west',
        	padding: 0,
		    splitterResize: false,
//		    split: true,
		    collapsible: true,
		    disable:false,
		    collapseMode: 'header', //header, mini
		    baseParams: {
		    	'PGM_ID': me.prgID
		    },
		    layout:  {
		    	type: 'vbox',
		        align: 'stretch',
		        padding: '0 5 0 5'
		    },
		    title: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.fornTitle','출력옵션'),
		    fieldDefaults : {
				msgTarget : 'qtip',
				labelAlign : 'left',
				labelWidth : 90,
				labelSeparator : "",
				boxLabelAlign: 'after'
			},
        	defaultType: 'checkbox',
        	api: {
			    load: commonReportService.loadPdfWinUserConfig,
			    submit: commonReportService.savePdfWinUserConfig
			},
			items: [
				{fieldLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textSubject','제목'), 	xtype:'textfield', name: 'PT_TITLENAME', labelAlign:'top',  allowBlank: false ,style: {'margin-left': '2px' ,'margin-right':'5px' }},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textCompany','회사명'),name: 'PT_COMPANY_YN',inputValue: 'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textApproval','결재란'),name: 'PT_SANCTION_YN',inputValue: 'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textPage','페이지'),name: 'PT_PAGENUM_YN',inputValue: 'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
				{	xtype:'fieldcontainer',
					layout:{
				    	type: 'hbox',
				        align: 'stretch'
				    },
					items: [
						{xtype:'checkbox', boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textPrintDate','출력일'),name: 'PT_OUTPUTDATE_YN', inputValue:'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
						{xtype:'uniDatefield', name: 'PT_OUTPUTDATE', labelPad: 0, flex:1,style: {'margin-left': '0px','margin-right':'5px' } ,  value: new Date()}
					]
				},
				{
					xtype: 'container',
					layout: {
						type:'hbox',
    					align:'stretch'
					},
					items : [{
								xtype:'button',
				                text: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnConfigSave','설정저장'),
								style: itemStyle,
								flex:1,
								margin: '0 5 5 2',
								//formBind: true,
				                handler: function() {
					                if(me.validForm()) {
					                	me.onSaveConfig(me);
					                }
				                }
				        	},
				        	{
								xtype:'button',
				                text: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnDefaultSave','기본값적용'),
								style: itemStyle,
								flex:1,
								//formBind: true,
								margin: '0 5 5 5',
				                handler: function() {me.onResetConfig(me);}
				        	}
				        	]
				},
				{	xtype:'button',
	                text: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnPreview','설정값 적용 미리보기'),
					style: itemStyle,
					//formBind: true,
	                handler: function() {me.updatePreview();}
	        	},
				{
					xtype:'button',
					itemId: 'saveAsXLS',
					style: itemStyle,
					//formBind: true,
	                text: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnExcel','엑셀파일로 저장(xlsx)'),
	                //disabled: true,
	                handler: function() {me.onSaveAs(me,'xlsx');}
	        	},{
					xtype:'button',
					itemId: 'saveAsDOC',
					style: itemStyle,
					//formBind: true,
	                //disabled: true,
	                text: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnDoc','워드파일로 저장(docx)'),
	                handler: function() {me.onSaveAs(me,'docx');}
	        	},{
					xtype:'button',
					itemId: 'saveAsPDF',
					style: itemStyle,
					//formBind: true,
	                //disabled: true,
	                text: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnPdf','PDF파일로 저장(pdf)'),
	                handler: function() {me.onSaveAs(me,'pdfd');}
	        	}
	        ]
        }

        var iframe = {
	         xtype: 'uxiframe',
        	 region: 'center',
        	 itemId: 'previewWin',
	         flex: 1,
	         //src: fullUrl//fullUrl
	         src: 'about:blank'//fullUrl
	    }
        this.items= [configForm, iframe];
	    this.layout={
			type: 'border',
			align:'stretch'
		}
        this.callParent([config]);
	},
	validForm: function(form) {
		if(form == null) {
			form = this.getForm();
		}
		if( form.isValid() ) {
			return true;
		} else {
			Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.pdfprintwindow.invalidText','오류사항을 확인해 주세요'));
			return false;
		}
	},
	updatePreview: function() {
		var me = this;
		var fullUrl = ""; //me.getFullUrl();
		var viewer= CPATH+"/resources/pdfJS/web/viewer.jsp";
		if (! Ext.isIE8m ) {
			fullUrl= viewer+"?file="+me.getFullUrl(true);
		} else {
			fullUrl= me.getFullUrl();
		}
		console.log("full url:", fullUrl);
		var previewWin = me.down('#previewWin');
		previewWin.load( fullUrl);
	},
	getForm: function() {
		return this.down("#configForm");
	},
	initComponent: function () {
        var me = this;
        me.callParent(arguments);
		var nParam={
			'PGM_ID': me.prgID
		};
		commonReportService.getPdfWinConfig( nParam, this.onReceiveConfig, this	);
	    me.loadUserConfigInfo();
    },
    loadUserConfigInfo: function() {
		var me = this;
    	me.getForm().load({success:function() {me.updatePreview();}});
    },
	onReceiveConfig: function(result, response, success) {
		var me = this;
		var form = me.getForm();
		if(success && result) {
			if(result.PT_SAVEASXLS_USE == 'N') me.down("#saveAsXLS").disable();
			if(result.PT_SAVEASPDF_USE == 'N') me.down("#saveAsPDF").disable();
			if(result.PT_SAVEASDOC_USE == 'N') me.down("#saveAsDOC").disable();


			if(result.PT_COMPANY_USE == 'N') form.getField("PT_COMPANY_YN").disable();
			if(result.PT_SANCTION_USE == 'N') form.getField("PT_SANCTION_YN").disable();
			if(result.PT_PAGENUM_USE == 'N') form.getField("PT_PAGENUM_YN").disable();
			if(result.PT_TITLENAME_USE == 'N') {
				form.getField("PT_TITLENAME").disable();

			}else {
				form.setValue("PT_TITLENAME", result.PT_TITLENAME);
			}

			if(result.PT_OUTPUTDATE_USE == 'N') {
				form.getField("PT_OUTPUTDATE_YN").disable();
				form.getField("PT_OUTPUTDATE").disable();
				//form.getField("PT_OUTPUTDATE").enable();

				//form.setValue("PT_TITLENAME", result.PT_TITLENAME);
			}
		}
		me.enable();
	},
	enableCmp: function (name) {
		var me = this;

		var cmp = me.down(name);
		if(cmp) {
			cmd.enable();
		}
	},
	getFullUrl: function(forViewer) {
		var me = this;
		var form = me.getForm();
		var params = Ext.apply(me.extParam, form.getValues());
		if(forViewer) {
        	var fullUrl = me.url +'&params=' + UniUtils.stringifyJson(params);
		} else {
        	var fullUrl = me.url + '?'+UniUtils.param(params);
		}
        return fullUrl;
	},
	onPrint: function(me) {
		console.log('onPrint');
	},
	onSaveAs: function(me, reportType) {
		window.open(this.getFullUrl()+"&reportType="+reportType,'_blank');
		console.log('onSaveExcel');
	},
	onSaveConfig: function(me) {
		var form = me.getForm();
		//button이 formBind되어 있으므로 별도의 validation 필요 없음.
		form.submit({success : function() {UniAppManager.updateStatus(UniUtils.getMessage('system.message.commonJS.store.saved','저장되었습니다.'));}});

	},
	onResetConfig: function(me) {
		var nParam={
			'PGM_ID': me.prgID
		};
		commonReportService.resetPdfWinUserConfig( nParam, this.afterResetConfig, this	);
	},

	afterResetConfig: function(result, response, success) {
		if(result) {
			this.loadUserConfigInfo();
			UniAppManager.updateStatus(UniUtils.getMessage('system.message.commonJS.pdfprintwindow.savedDefault','기본값이 적용 되었습니다.'));
		}
	},
     onShow: function() {
        var me = this;
     	//console.log('onShow');

        me.callParent(arguments);
     }
});

Ext.define('Unilite.com.window.CrystalReport', {
	extend: 'Unilite.com.window.UniWindow',
	requires: [
		'Ext.ux.IFrame',
		'Unilite.com.UniUtils',
		'Unilite.com.form.UniSearchPanel',
		'Unilite.com.form.UniSearchSubPanel',
		'Unilite.com.layout.UniTable',
		'Unilite.com.form.field.UniTextField',
		'Unilite.com.form.field.UniDateField'
	],
	alias: 'widget.CrystalReport',
	width: 600,
	basePosition:'maximized',
	height: 700,
	title: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.title','인쇄'),
    closable: true,
    disabled: false,
	constructor: function(config){
        var me = this;
       	if (config) {
            Ext.apply(me, config);
        };




	    var itemStyle ={'margin-left':'2px','margin-bottom':'10px','margin-right':'5px'};
        var configForm = {
        	xtype: 'uniSearchForm',
        	itemId: 'configForm',
        	width: 200,
        	region: 'west',
        	padding: 0,
		    splitterResize: false,
//		    split: true,
		    collapsible: true,
		    disable:false,
		    collapseMode: 'header', //header, mini
		    baseParams: {
		    	'PGM_ID': me.prgID
		    },
		    layout:  {
		    	type: 'vbox',
		        align: 'stretch',
		        padding: '0 5 0 5'
		    },
		    title: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.fornTitle','출력옵션'),
		    fieldDefaults : {
				msgTarget : 'qtip',
				labelAlign : 'left',
				labelWidth : 90,
				labelSeparator : "",
				boxLabelAlign: 'after'
			},
        	defaultType: 'checkbox',
        	api: {
			    load: commonReportService.loadPdfWinUserConfig,
			    submit: commonReportService.savePdfWinUserConfig
			},
			items: [
				{fieldLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textSubject','제목'), 	xtype:'textfield', name: 'PT_TITLENAME', labelAlign:'top', allowBlank: true ,style: {'margin-left': '2px' ,'margin-right':'5px' },emptyText :"제목을 기본값으로 출력합니다."},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textCompany','회사명'),name: 'PT_COMPANY_YN',inputValue: 'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textApproval','결재란'),name: 'PT_SANCTION_YN',inputValue: 'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textPage','페이지'),name: 'PT_PAGENUM_YN',inputValue: 'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
				{	xtype:'fieldcontainer',
					layout:{
				    	type: 'hbox',
				        align: 'stretch'
				    },
					items: [
						{xtype:'checkbox', boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textPrintDate','출력일'),name: 'PT_OUTPUTDATE_YN', inputValue:'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
						{xtype:'uniDatefield', name: 'PT_OUTPUTDATE', labelPad: 0, flex:1,style: {'margin-left': '0px','margin-right':'5px' } ,
						  emptyText : UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4)+'.'+
						              UniDate.getDbDateStr(UniDate.get('today')).substring(4, 6)+'.'+
						              UniDate.getDbDateStr(UniDate.get('today')).substring(6, 8)/*value: new Date()*/}
					]
				},
				{
					xtype: 'container',
					layout: {
						type:'hbox',
    					align:'stretch'
					},
					items : [{
								xtype:'button',
				                text: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnConfigSave','설정저장'),
								style: itemStyle,
								flex:1,
								margin: '0 5 5 2',
				                handler: function() {
					                if(me.validForm()) {
					                	me.onSaveConfig(me);
					                }
				                }
				        	},
				        	{
								xtype:'button',
				                text: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnDefaultSave','기본값적용'),
								style: itemStyle,
								flex:1,
								margin: '0 5 5 5',
				                handler: function() {me.onResetConfig(me);}
				        	}
				        	]
				},
				{	xtype:'button',
	                text: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnPreview','설정값 적용 미리보기'),
					style: itemStyle,
	                handler: function() {me.updatePreview();}
	        	},
				{
					xtype:'button',
					itemId: 'saveAsPDF',
					style: itemStyle,
	                text: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnPdf','PDF파일로 저장(pdf)'),
	                handler: function() {me.onSaveAs(me,'pdfd');}
	        	}
	        ]
        }

        var iframe = {
	         xtype: 'uxiframe',
        	 region: 'center',
        	 itemId: 'previewWin',
	         flex: 1,
	         //src: fullUrl//fullUrl
	         src: 'about:blank'//fullUrl
	    }
        this.items= [configForm, iframe];
	    this.layout={
			type: 'border',
			align:'stretch'
		}
        this.callParent([config]);
	},
	validForm: function(form) {
		if(form == null) {
			form = this.getForm();
		}
		if( form.isValid() ) {
			return true;
		} else {
			Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.pdfprintwindow.invalidText','오류사항을 확인해 주세요'));
			return false;
		}
	},
	updatePreview: function() {
		var me = this;
		var fullUrl = ""; //me.getFullUrl();
		var viewer= CPATH+"/resources/pdfJS/web/viewer.jsp";
		if (! Ext.isIE8m ) {
			fullUrl= viewer+"?file="+me.getFullUrl(true);
		} else {
			fullUrl= me.getFullUrl();
		}
		//fullUrl = me.getFullUrl(false);
		console.log("full url:", fullUrl);
		var previewWin = me.down('#previewWin');
		previewWin.load( fullUrl);
	},
	getForm: function() {
		return this.down("#configForm");
	},
	initComponent: function () {
        var me = this;
        me.callParent(arguments);
		var nParam={
			'PGM_ID': me.prgID
		};
		commonReportService.getPdfWinConfig( nParam, this.onReceiveConfig, this	);
	    me.loadUserConfigInfo();
    },
    loadUserConfigInfo: function() {
		var me = this;
    	me.getForm().load({success:function() {me.updatePreview();}});
    },
	onReceiveConfig: function(result, response, success) {
		var me = this;
		var form = me.getForm();
		if(success && result) {
			if(result.PT_COMPANY_USE == 'N') form.getField("PT_COMPANY_YN").disable();
			if(result.PT_SANCTION_USE == 'N') form.getField("PT_SANCTION_YN").disable();
			if(result.PT_PAGENUM_USE == 'N') form.getField("PT_PAGENUM_YN").disable();
			if(result.PT_TITLENAME_USE == 'N') {
				form.getField("PT_TITLENAME").disable();

			}else {
				form.setValue("PT_TITLENAME", result.PT_TITLENAME);
			}

			if(result.PT_OUTPUTDATE_USE == 'N') {
				form.getField("PT_OUTPUTDATE_YN").disable();
				form.getField("PT_OUTPUTDATE").disable();
				//form.getField("PT_OUTPUTDATE").enable();

				//form.setValue("PT_TITLENAME", result.PT_TITLENAME);
			}
		}

//		else {
//			if(Ext.isDefined(PGM_TITLE))	{
//				form.setValue("PT_TITLENAME", PGM_TITLE);
//			}
//		}
		me.enable();
	},
	enableCmp: function (name) {
		var me = this;

		var cmp = me.down(name);
		if(cmp) {
			cmd.enable();
		}
	},
	getFullUrl: function(forViewer) {
		var me = this;
		var form = me.getForm();
		var params = Ext.apply(me.extParam, form.getValues());
		console.log("me.url : ", me.url);
		console.log("param : ", encodeURIComponent('&params=' + Ext.encode(params)));

		if(forViewer) {
        	var fullUrl = me.url +'&params=' + Ext.encode(params);//UniUtils.stringifyJson(params);
		} else {
        	var fullUrl = me.url + '?'+UniUtils.param(params);
		}
		console.log("me.fullUrl : ", me.url);
        return fullUrl+'#toolbar=0&navpanes=0&scrollbar=0';
	},
	onPrint: function(me) {
		console.log('onPrint');
	},
	onSaveAs: function(me, reportType) {
		window.open(this.getFullUrl()+"&reportType="+reportType,'_blank');

	},
	onSaveConfig: function(me) {
		var form = me.getForm();
		//button이 formBind되어 있으므로 별도의 validation 필요 없음.
		form.submit({success : function() {UniAppManager.updateStatus(UniUtils.getMessage('system.message.commonJS.store.saved','저장되었습니다.'));}});

	},
	onResetConfig: function(me) {
		var nParam={
			'PGM_ID': me.prgID
		};
		commonReportService.resetPdfWinUserConfig( nParam, this.afterResetConfig, this	);
	},

	afterResetConfig: function(result, response, success) {
		if(result) {
			this.loadUserConfigInfo();
			UniAppManager.updateStatus(UniUtils.getMessage('system.message.commonJS.pdfprintwindow.savedDefault','기본값이 적용 되었습니다.'));
		}
	},
     onShow: function() {
        var me = this;
     	//console.log('onShow');

        me.callParent(arguments);
     }
});

Ext.define('Unilite.com.window.ClipReport', {
	extend: 'Unilite.com.window.UniWindow',
	requires: [
		'Ext.ux.IFrame',
		'Unilite.com.UniUtils',
		'Unilite.com.form.UniSearchPanel',
		'Unilite.com.form.UniSearchSubPanel',
		'Unilite.com.layout.UniTable',
		'Unilite.com.form.field.UniTextField',
		'Unilite.com.form.field.UniDateField'
	],
	alias: 'widget.ClipReport',
	width: 600,
	basePosition:'maximized',
	height: 700,
	title: '인쇄 미리보기',//UniUtils.getLabel('system.label.commonJS.pdfprintwindow.title','인쇄'),
    closable: true,
    disabled: false,
    uniOpt:{
    	directPrint : false,
    	pdfPrint : false
    },
	constructor: function(config){
        var me = this;
       	if (config) {
            Ext.apply(me, config);
        };

	    var itemStyle ={'margin-left':'2px','margin-bottom':'10px','margin-right':'5px'};
        var configForm = {
        	xtype: 'uniSearchForm',
        	itemId: 'configForm',
        	width: 200,
        	region: 'west',
        	padding: 0,
		    splitterResize: false,
//		    split: true,
		    collapsible: true,
		    disable:false,
		    collapseMode: 'header', //header, mini
		    baseParams: {
		    	'PGM_ID': me.prgID
		    },
		    layout:  {
		    	type: 'vbox',
		        align: 'stretch',
		        padding: '0 5 0 5'
		    },
		    title: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.fornTitle','출력옵션'),
		    fieldDefaults : {
				msgTarget : 'qtip',
				labelAlign : 'left',
				labelWidth : 90,
				labelSeparator : "",
				boxLabelAlign: 'after'
			},
        	defaultType: 'checkbox',
        	submitEmptyText: false,
        	api: {
			    load: commonReportService.loadPdfWinUserConfig,
			    submit: commonReportService.savePdfWinUserConfig
			},
			items: [
				{fieldLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textSubject','제목'), 	xtype:'textfield', name: 'PT_TITLENAME', labelAlign:'top', allowBlank: true ,style: {'margin-left': '2px' ,'margin-right':'5px' },emptyText :"제목을 기본값으로 출력합니다."},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textCompany','회사명'),name: 'PT_COMPANY_YN',inputValue: 'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textApproval','결재란'),name: 'PT_SANCTION_YN',inputValue: 'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textPage','페이지'),name: 'PT_PAGENUM_YN',inputValue: 'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
				{	xtype:'fieldcontainer',
					layout:{
				    	type: 'hbox',
				        align: 'stretch'
				    },
					items: [
						{xtype:'checkbox', boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textPrintDate','출력일'),name: 'PT_OUTPUTDATE_YN', inputValue:'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
						{xtype:'uniDatefield', name: 'PT_OUTPUTDATE', labelPad: 0, flex:1,style: {'margin-left': '0px','margin-right':'5px' ,'margin-left':'10px' } ,
						  emptyText : UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4)+'.'+
						              UniDate.getDbDateStr(UniDate.get('today')).substring(4, 6)+'.'+
						              UniDate.getDbDateStr(UniDate.get('today')).substring(6, 8)/*value: new Date()*/}
					]
				},{
	        		xtype:'button',
	                text: '출력 옵션 적용 미리보기',//UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnPreview','설정값 적용 미리보기'),
					style: itemStyle,
	                handler: function() {me.updatePreview();}
	        	},{
					xtype:'button',
	                text: '출력 옵션 저장',//UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnConfigSave','설정저장'),
					style: itemStyle,
	                handler: function() {
		                if(me.validForm()) {
		                	me.onSaveConfig(me);
		                }
	                }
	        	},
	        	{
					xtype:'button',
	                text: '기본 옵션 불러오기',//UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnDefaultSave','기본값적용'),
					style: itemStyle,
	                handler: function() {me.onResetConfig(me);}
	        	}
	        ]
        }
	    var dataForm = {
        	xtype: 'form',
        	standardSubmit:true,
        	itemId: 'dataForm',
        	region:'west',
        	hidden:true,
        	target:'clipreportwin',
        	url: CPATH+"/resources/clipsoft/clipReport.jsp",
        	items:[
	        	{fieldLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textSubject','제목'), 	xtype:'textfield', name: 'PT_TITLENAME', labelAlign:'top', allowBlank: true },
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textCompany','회사명'),name: 'PT_COMPANY_YN',inputValue: 'Y', uncheckedValue:'N'},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textApproval','결재란'),name: 'PT_SANCTION_YN',inputValue: 'Y', uncheckedValue:'N'},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textPage','페이지'),name: 'PT_PAGENUM_YN',inputValue: 'Y', uncheckedValue:'N'},
				{xtype:'checkbox', boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textPrintDate','출력일'),name: 'PT_OUTPUTDATE_YN', inputValue:'Y', uncheckedValue:'N'},
				{xtype:'uniDatefield', name: 'PT_OUTPUTDATE', },
				{xtype:'textarea', name: 'file', },
			   	{
	        		xtype:'textarea',
	        		name:'params',
	        		hidden:true
	        	}
			]
        }

        var iframe = {
	         xtype: 'uxiframe',
        	 region: 'center',
        	 itemId: 'previewWin',
        	 frameName  : 'clipreportwin',
	         flex: 1,
	         //src: CPATH+"/resources/clipsoft/clipReport.jsp",
	         src: 'about:blank',
	         load: function (src) {
	        	 var me = this;
	        	 var rWin = this.up('window');
	        	 if(Ext.isDefined(rWin.submitType) && rWin.submitType == "POST")	{
		        	 var frame = this.getFrame();
		        	 frame.src = "about:blank" ;

			         var text = me.loadMask;

		        	 var dataForm = rWin.down("#dataForm").getForm();
		        	 var configForm = rWin.down("#configForm").getForm();
		        	 var paramData =  Ext.apply(rWin.extParam, configForm.getValues());//configForm.getValues();
		        	 var file = rWin.url;

		        	 if(rWin.uniOpt && rWin.uniOpt.pdfPrint){
		        		 paramData["pdfPrint"] = "Y";
		        		 rWin.hide();
		     		 }else if(rWin.uniOpt && rWin.uniOpt.directPrint){
		     			 paramData["directPrint"] = "Y";
		     		 }

		        	 dataForm.setValues(paramData);
		        	 dataForm.setValues({"params":encodeURI(JSON.stringify(rWin.extParam)), "file":file+'#toolbar=0&navpanes=0&scrollbar=0'});
		        	 dataForm.submit({
		        		 target : 'clipreportwin',
		        			url : CPATH+"/resources/clipsoft/clipReport.jsp",
		                 method :'POST'
		        	 });
	         	} else {
			        var text = me.loadMask,
			            frame = me.getFrame();
			        if (me.fireEvent('beforeload', me, src) !== false) {
			            frame.src = src ;
			        }
		        }
	         }
        }
        this.items= [configForm, dataForm, iframe];
	    this.layout={
			type: 'border',
			align:'stretch'
		}
        this.callParent([config]);

	},
	validForm: function(form) {
		if(form == null) {
			form = this.getForm();
		}
		if( form.isValid() ) {
			return true;
		} else {
			Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.pdfprintwindow.invalidText','오류사항을 확인해 주세요'));
			return false;
		}
	},
	updatePreview: function() {
		var me = this;
		var fullUrl = ""; //me.getFullUrl();
		var directPrintParam ="";
		var pdfPrintParam = "";

		if(me.uniOpt && me.uniOpt.pdfPrint){
			directPrintParam = "pdfPrint=Y&";
			me.hide();
		}else if(me.uniOpt && me.uniOpt.directPrint){
			pdfPrintParam = "directPrint=Y&";
		}

		var viewer= CPATH+"/resources/clipsoft/clipReport.jsp";
		if (! Ext.isIE8m ) {
			fullUrl= viewer+"?"+pdfPrintParam+directPrintParam+"file="+me.getFullUrl(true);
		} else {
			fullUrl= pdfPrintParam + directPrintParam + me.getFullUrl();
		}

		//fullUrl = me.getFullUrl(false);
		console.log("full url:", fullUrl);
		var previewWin = me.down('#previewWin');
		previewWin.load( fullUrl);
	},
	getForm: function() {
		return this.down("#configForm");
	},
	initComponent: function () {
        var me = this;
        me.callParent(arguments);
		var nParam={
			'PGM_ID': me.prgID
		};
		commonReportService.getPdfWinConfig( nParam, this.onReceiveConfig, this	);
	    me.loadUserConfigInfo();
	    if(Ext.isDefined(me.submitType) && me.submitType == "POST"){
	    	me.on("close", me.onHide, me);
	    }
    },
    loadUserConfigInfo: function() {
		var me = this;
    	me.getForm().load({success:function() {me.updatePreview();}});
    },
	onReceiveConfig: function(result, response, success) {
		var me = this;
		var form = me.getForm();
		if(success && result) {
			if(result.PT_COMPANY_USE == 'N') form.getField("PT_COMPANY_YN").disable();
			if(result.PT_SANCTION_USE == 'N') form.getField("PT_SANCTION_YN").disable();
			if(result.PT_PAGENUM_USE == 'N') form.getField("PT_PAGENUM_YN").disable();
			if(result.PT_TITLENAME_USE == 'N') {
				form.getField("PT_TITLENAME").disable();

			}else {
				form.setValue("PT_TITLENAME", result.PT_TITLENAME);
			}

			if(result.PT_OUTPUTDATE_USE == 'N') {
				form.getField("PT_OUTPUTDATE_YN").disable();
				form.getField("PT_OUTPUTDATE").disable();
				//form.getField("PT_OUTPUTDATE").enable();

				//form.setValue("PT_TITLENAME", result.PT_TITLENAME);
			}
		}

//		else {
//			if(Ext.isDefined(PGM_TITLE))	{
//				form.setValue("PT_TITLENAME", PGM_TITLE);
//			}
//		}
		me.enable();
	},
	enableCmp: function (name) {
		var me = this;

		var cmp = me.down(name);
		if(cmp) {
			cmd.enable();
		}
	},
	getFullUrl: function(forViewer) {
		var me = this;
		var form = me.getForm();
		var params = Ext.apply(me.extParam, form.getValues());

		console.log("me.url : ", me.url);
		console.log("param : ", encodeURIComponent('&params=' + Ext.encode(params)));

		if(forViewer) {
        	var fullUrl = me.url +'&params=' + UniUtils.stringifyJson(params);
		} else {
        	var fullUrl = me.url + '?'+UniUtils.param(params);
		}
		console.log("me.fullUrl : ", me.url);
        return fullUrl+'#toolbar=0&navpanes=0&scrollbar=0';
	},
	onPrint: function(me) {
		console.log('onPrint');
	},
	onSaveAs: function(me, reportType) {
		window.open(this.getFullUrl()+"&reportType="+reportType,'_blank');

	},
	onSaveConfig: function(me) {
		var form = me.getForm();
		//button이 formBind되어 있으므로 별도의 validation 필요 없음.
		form.submit({submitEmptyText:false, success : function() {UniAppManager.updateStatus(UniUtils.getMessage('system.message.commonJS.store.saved','저장되었습니다.'));}});

	},
	onResetConfig: function(me) {
		var nParam={
			'PGM_ID': me.prgID
		};
		commonReportService.resetPdfWinUserConfig( nParam, this.afterResetConfig, this	);
	},

	afterResetConfig: function(result, response, success) {
		if(result) {
			this.loadUserConfigInfo();
			UniAppManager.updateStatus(UniUtils.getMessage('system.message.commonJS.pdfprintwindow.savedDefault','기본값이 적용 되었습니다.'));
		}
	},
     onShow: function() {
        var me = this;
     	//console.log('onShow');

        me.callParent(arguments);
        if(me.uniOpt.directPrint || me.uniOpt.pdfPrint)	{
	    	me.setHeight(0);
	    	me.setWidth(0);
	    	me.hide();
	    }
     },
	onHide:function()	{
		this.destroy();
	}
});


Ext.define('Unilite.com.window.ClipReportFax', {
	extend: 'Unilite.com.window.UniWindow',
	requires: [
		'Ext.ux.IFrame',
		'Unilite.com.UniUtils',
		'Unilite.com.form.UniSearchPanel',
		'Unilite.com.form.UniSearchSubPanel',
		'Unilite.com.layout.UniTable',
		'Unilite.com.form.field.UniTextField',
		'Unilite.com.form.field.UniDateField'
	],
	alias: 'widget.ClipReportFax',
	width: 600,
	basePosition:'maximized',
	height: 700,
	title: '인쇄 미리보기',//UniUtils.getLabel('system.label.commonJS.pdfprintwindow.title','인쇄'),
    closable: true,
    disabled: false,
    uniOpt:{
    	directPrint : false,
    	pdfPrint : false
    },
	constructor: function(config){
        var me = this;
       	if (config) {
            Ext.apply(me, config);
        };

	    var itemStyle ={'margin-left':'2px','margin-bottom':'10px','margin-right':'5px'};
        var configForm = {
        	xtype: 'uniSearchForm',
        	itemId: 'configForm',
        	width: 200,
        	region: 'west',
        	padding: 0,
		    splitterResize: false,
//		    split: true,
		    collapsible: true,
		    disable:false,
		    collapseMode: 'header', //header, mini
		    baseParams: {
		    	'PGM_ID': me.prgID
		    },
		    layout:  {
		    	type: 'vbox',
		        align: 'stretch',
		        padding: '0 5 0 5'
		    },
		    title:'인쇄 미리보기',
		    fieldDefaults : {
				msgTarget : 'qtip',
				labelAlign : 'left',
				labelWidth : 90,
				labelSeparator : "",
				boxLabelAlign: 'after'
			},
        	defaultType: 'checkbox',
        	submitEmptyText: false,
        	api: {
			    load: commonReportService.loadPdfWinUserConfig,
			    submit: commonReportService.savePdfWinUserConfig
			},
			items: [
				{fieldLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textSubject','제목'), 	xtype:'textfield', name: 'PT_TITLENAME', labelAlign:'top', allowBlank: true ,style: {'margin-left': '2px' ,'margin-right':'5px' },emptyText :"제목을 기본값으로 출력합니다."},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textCompany','회사명'),name: 'PT_COMPANY_YN',inputValue: 'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textApproval','결재란'),name: 'PT_SANCTION_YN',inputValue: 'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textPage','페이지'),name: 'PT_PAGENUM_YN',inputValue: 'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
				{	xtype:'fieldcontainer',
					layout:{
				    	type: 'hbox',
				        align: 'stretch'
				    },
					items: [
						{xtype:'checkbox', boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textPrintDate','출력일'),name: 'PT_OUTPUTDATE_YN', inputValue:'Y', uncheckedValue:'N', style: {'margin-left': '2px'}},
						{xtype:'uniDatefield', name: 'PT_OUTPUTDATE', labelPad: 0, flex:1,style: {'margin-left': '0px','margin-right':'5px' ,'margin-left':'10px' } ,
						  emptyText : UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4)+'.'+
						              UniDate.getDbDateStr(UniDate.get('today')).substring(4, 6)+'.'+
						              UniDate.getDbDateStr(UniDate.get('today')).substring(6, 8)/*value: new Date()*/}
					]
				},{
	        		xtype:'button',
	                text: '출력 옵션 적용 미리보기',//UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnPreview','설정값 적용 미리보기'),
					style: itemStyle,
	                handler: function() {me.updatePreview();}
	        	},{
					xtype:'button',
	                text: '출력 옵션 저장',//UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnConfigSave','설정저장'),
					style: itemStyle,
	                handler: function() {
		                if(me.validForm()) {
		                	me.onSaveConfig(me);
		                }
	                }
	        	},
	        	{
					xtype:'button',
	                text: '기본 옵션 불러오기',//UniUtils.getLabel('system.label.commonJS.pdfprintwindow.btnDefaultSave','기본값적용'),
					style: itemStyle,
	                handler: function() {me.onResetConfig(me);}
	        	},{
                    xtype:'component',
                    html:'◆FAX 전송◆',
                    tdAttrs: {style: 'border : 0px solid #ced9e7;font-weight: bold; font: normal 18px "굴림",Gulim,tahoma, arial, verdana, sans-serif; color:red;', align : 'center'},
                    style		: {'text-align': 'center','margin-top':'15px'}
                },{
	    			fieldLabel	: '보내는사람 명',
	    			xtype		: 'uniTextfield',
	    			labelAlign	:'top',
	    			name		: 'FROM_NAME',
	    			style	    : {'margin-left': '2px' ,'margin-right':'5px' },
	    			allowBlank	: true,
	    			holdable	: 'hold'
	    		},{
	    			fieldLabel	: '보내는팩스번호',
	    			xtype		: 'uniTextfield',
	    			labelAlign	:'top',
	    			name		: 'FROM_FAX_NO',
	    			style	    : {'margin-left': '2px' ,'margin-right':'5px' },
	    			allowBlank	: false,
	    			holdable	: 'hold',
	    			emptyText   :"-하이픈 제외하고 입력해주세요."
	    		},{
	    			fieldLabel	: '받는사람 명',
	    			xtype		: 'uniTextfield',
	    			labelAlign:'top',
	    			name		: 'TO_NAME',
	    			style		: {'margin-left': '2px' ,'margin-right':'5px' },
	    			allowBlank	: false,
	    			holdable	: 'hold'
	    		},{
	    			fieldLabel	: '받는팩스번호',
	    			xtype		: 'uniTextfield',
	    			labelAlign  : 'top',
	    			name		: 'TO_FAX_NO',
	    			style	    : {'margin-left': '2px' ,'margin-right':'5px' },
	    			allowBlank	: false,
	    			holdable	: 'hold',
	    			emptyText   :"-하이픈 제외하고 입력해주세요."
	    		},{
	        		xtype:'button',
	                text: '전송',
	                itemId: 'btnFaxSend',
	                style	    : {'margin-left': '2px' ,'margin-right':'5px','margin-top':'10px' },
	                handler: function() {
	               /* 	 if(Ext.isEmpty(me.getForm().getValue('FROM_NAME'))){
	                		 Unilite.messageBox('보내는 사람명이 비어 있습니다.' + '\n' + '입력하신 후 다시 시도해주세요.');
	                		 me.getForm().getField('FROM_NAME').focus();
	                		 return;
	                	 }*/
	                	 if(Ext.isEmpty(me.getForm().getValue('FROM_FAX_NO'))){
							 Unilite.messageBox('보내는 팩스 번호가 비어 있습니다.' + '\n' + '입력하신 후 다시 시도해주세요.');
							 me.getForm().getField('FROM_FAX_NO').focus();
							 return;
						 }
	                	 if(Ext.isEmpty(me.getForm().getValue('TO_NAME'))){
	                		 Unilite.messageBox('받는 사람명이 비어 있습니다.' + '\n' + '입력하신 후 다시 시도해주세요.');
	                		 me.getForm().getField('TO_NAME').focus();
	                		 return;
	                	 }
						 if(Ext.isEmpty(me.getForm().getValue('TO_FAX_NO'))){
							 Unilite.messageBox('받는 팩스 번호가 비어 있습니다.' + '\n' + '입력하신 후 다시 시도해주세요.');
							 me.getForm().getField('TO_FAX_NO').focus();
							 return;
						 }
						 me.extParam.FROM_NAME   = me.getForm().getValue('FROM_NAME');
						 me.extParam.FROM_FAX_NO = me.getForm().getValue('FROM_FAX_NO');
						 me.extParam.TO_NAME     = me.getForm().getValue('TO_NAME');
						 me.extParam.TO_FAX_NO   = me.getForm().getValue('TO_FAX_NO');
						 Ext.getBody().mask("전송중...");
						 Unilite.messageBox('전송 중 입니다.');
						 me.getForm().down('#btnFaxSend').setDisabled(true);
	                	  Ext.Ajax.request({
		    				    url     : me.extParam.FAX_URL,
		    				    params  : me.extParam,
		    				    cors: true,
								useDefaultXhrHeader : false,
		    				    success : function(response){
									if(!Ext.isEmpty(response)){
										Unilite.messageBox('전송되었습니다.');
										me.getForm().down('#btnFaxSend').setDisabled(false);
										Ext.getBody().unmask();
									}
		    				    },
		    				    error:function(request,status,error){
		    				         alert("code = "+ request.status + " message = " + request.responseText + " error = " + error); // 실패 시 처리
		    				         Ext.getBody().unmask();
		    				    },
		    				    callback: function(request,status,error)	{
		    				    	if(error.request.success == false){
		    				    		Unilite.messageBox('전송 중 에러가 발생했습니다.');
		    				    	}
		    				    	me.getForm().down('#btnFaxSend').setDisabled(false);
		    				    	Ext.getBody().unmask();
		    				    }
		    			});
	                }
	        	}
	        ]
        }
	    var dataForm = {
        	xtype: 'form',
        	standardSubmit:true,
        	itemId: 'dataForm',
        	region:'west',
        	hidden:true,
        	target:'clipreportwin',
        	url: CPATH+"/resources/clipsoft/clipReport.jsp",
        	items:[
	        	{fieldLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textSubject','제목'), 	xtype:'textfield', name: 'PT_TITLENAME', labelAlign:'top', allowBlank: true },
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textCompany','회사명'),name: 'PT_COMPANY_YN',inputValue: 'Y', uncheckedValue:'N'},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textApproval','결재란'),name: 'PT_SANCTION_YN',inputValue: 'Y', uncheckedValue:'N'},
				{boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textPage','페이지'),name: 'PT_PAGENUM_YN',inputValue: 'Y', uncheckedValue:'N'},
				{xtype:'checkbox', boxLabel: UniUtils.getLabel('system.label.commonJS.pdfprintwindow.textPrintDate','출력일'),name: 'PT_OUTPUTDATE_YN', inputValue:'Y', uncheckedValue:'N'},
				{xtype:'uniDatefield', name: 'PT_OUTPUTDATE', },
				{xtype:'textarea', name: 'file', },
			   	{
	        		xtype:'textarea',
	        		name:'params',
	        		hidden:true
	        	}
			]
        }

        var iframe = {
	         xtype: 'uxiframe',
        	 region: 'center',
        	 itemId: 'previewWin',
        	 frameName  : 'clipreportwin',
	         flex: 1,
	         //src: CPATH+"/resources/clipsoft/clipReport.jsp",
	         src: 'about:blank',
	         load: function (src) {
	        	 var me = this;
	        	 var rWin = this.up('window');
	        	 if(Ext.isDefined(rWin.submitType) && rWin.submitType == "POST")	{
		        	 var frame = this.getFrame();
		        	 frame.src = "about:blank" ;

			         var text = me.loadMask;

		        	 var dataForm = rWin.down("#dataForm").getForm();
		        	 var configForm = rWin.down("#configForm").getForm();
		        	 var paramData =  Ext.apply(rWin.extParam, configForm.getValues());//configForm.getValues();
		        	 var file = rWin.url;

		        	 if(rWin.uniOpt && rWin.uniOpt.pdfPrint){
		        		 paramData["pdfPrint"] = "Y";
		        		 rWin.hide();
		     		 }else if(rWin.uniOpt && rWin.uniOpt.directPrint){
		     			 paramData["directPrint"] = "Y";
		     		 }

		        	 dataForm.setValues(paramData);
		        	 dataForm.setValues({"params":encodeURI(JSON.stringify(rWin.extParam)), "file":file+'#toolbar=0&navpanes=0&scrollbar=0'});
		        	 dataForm.submit({
		        		 target : 'clipreportwin',
		        			url : CPATH+"/resources/clipsoft/clipReport.jsp",
		                 method :'POST'
		        	 });
	         	} else {
			        var text = me.loadMask,
			            frame = me.getFrame();
			        if (me.fireEvent('beforeload', me, src) !== false) {
			            frame.src = src ;
			        }
		        }
	         }
        }
        this.items= [configForm, dataForm, iframe];
	    this.layout={
			type: 'border',
			align:'stretch'
		}
        this.callParent([config]);

	},
	validForm: function(form) {
		if(form == null) {
			form = this.getForm();
		}
		if( form.isValid() ) {
			return true;
		} else {
			Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.pdfprintwindow.invalidText','오류사항을 확인해 주세요'));
			return false;
		}
	},
	updatePreview: function() {
		var me = this;
		var fullUrl = ""; //me.getFullUrl();
		var directPrintParam ="";
		var pdfPrintParam = "";

		if(me.uniOpt && me.uniOpt.pdfPrint){
			directPrintParam = "pdfPrint=Y&";
			me.hide();
		}else if(me.uniOpt && me.uniOpt.directPrint){
			pdfPrintParam = "directPrint=Y&";
		}

		var viewer= CPATH+"/resources/clipsoft/clipReport.jsp";
		if (! Ext.isIE8m ) {
			fullUrl= viewer+"?"+pdfPrintParam+directPrintParam+"file="+me.getFullUrl(true);
		} else {
			fullUrl= pdfPrintParam + directPrintParam + me.getFullUrl();
		}

		//fullUrl = me.getFullUrl(false);
		console.log("full url:", fullUrl);
		var previewWin = me.down('#previewWin');
		previewWin.load( fullUrl);
	},
	getForm: function() {
		return this.down("#configForm");
	},
	initComponent: function () {
        var me = this;
        me.callParent(arguments);
		var nParam={
			'PGM_ID': me.prgID
		};
		commonReportService.getPdfWinConfig( nParam, this.onReceiveConfig, this	);
	    me.loadUserConfigInfo();
	    me.getForm().setValue('FROM_NAME'  ,UserInfo.userName);
	    me.getForm().setValue('FROM_FAX_NO',me.extParam.FROM_FAX_NO);
	    me.getForm().setValue('TO_NAME'	   ,me.extParam.TO_NAME);
	    me.getForm().setValue('TO_FAX_NO'  ,me.extParam.TO_FAX_NO);
	    if(Ext.isDefined(me.submitType) && me.submitType == "POST"){
	    	me.on("close", me.onHide, me);
	    }
    },
    loadUserConfigInfo: function() {
		var me = this;
    	me.getForm().load({success:function() {me.updatePreview();}});
    },
	onReceiveConfig: function(result, response, success) {
		var me = this;
		var form = me.getForm();
		if(success && result) {
			if(result.PT_COMPANY_USE == 'N') form.getField("PT_COMPANY_YN").disable();
			if(result.PT_SANCTION_USE == 'N') form.getField("PT_SANCTION_YN").disable();
			if(result.PT_PAGENUM_USE == 'N') form.getField("PT_PAGENUM_YN").disable();
			if(result.PT_TITLENAME_USE == 'N') {
				form.getField("PT_TITLENAME").disable();

			}else {
				form.setValue("PT_TITLENAME", result.PT_TITLENAME);
			}

			if(result.PT_OUTPUTDATE_USE == 'N') {
				form.getField("PT_OUTPUTDATE_YN").disable();
				form.getField("PT_OUTPUTDATE").disable();
				//form.getField("PT_OUTPUTDATE").enable();

				//form.setValue("PT_TITLENAME", result.PT_TITLENAME);
			}
		}

//		else {
//			if(Ext.isDefined(PGM_TITLE))	{
//				form.setValue("PT_TITLENAME", PGM_TITLE);
//			}
//		}
		me.enable();
	},
	enableCmp: function (name) {
		var me = this;

		var cmp = me.down(name);
		if(cmp) {
			cmd.enable();
		}
	},
	getFullUrl: function(forViewer) {
		var me = this;
		var form = me.getForm();
		var params = Ext.apply(me.extParam, form.getValues());

		console.log("me.url : ", me.url);
		console.log("param : ", encodeURIComponent('&params=' + Ext.encode(params)));

		if(forViewer) {
        	var fullUrl = me.url +'&params=' + UniUtils.stringifyJson(params);
		} else {
        	var fullUrl = me.url + '?'+UniUtils.param(params);
		}
		console.log("me.fullUrl : ", me.url);
        return fullUrl+'#toolbar=0&navpanes=0&scrollbar=0';
	},
	onPrint: function(me) {
		console.log('onPrint');
	},
	onSaveAs: function(me, reportType) {
		window.open(this.getFullUrl()+"&reportType="+reportType,'_blank');

	},
	onSaveConfig: function(me) {
		var form = me.getForm();
		//button이 formBind되어 있으므로 별도의 validation 필요 없음.
		form.submit({submitEmptyText:false, success : function() {UniAppManager.updateStatus(UniUtils.getMessage('system.message.commonJS.store.saved','저장되었습니다.'));}});

	},
	onResetConfig: function(me) {
		var nParam={
			'PGM_ID': me.prgID
		};
		commonReportService.resetPdfWinUserConfig( nParam, this.afterResetConfig, this	);
	},

	afterResetConfig: function(result, response, success) {
		if(result) {
			this.loadUserConfigInfo();
			UniAppManager.updateStatus(UniUtils.getMessage('system.message.commonJS.pdfprintwindow.savedDefault','기본값이 적용 되었습니다.'));
		}
	},
     onShow: function() {
        var me = this;
     	//console.log('onShow');
        console.log(arguments);
        me.callParent(arguments);
        if(me.uniOpt.directPrint || me.uniOpt.pdfPrint)	{
	    	me.setHeight(0);
	    	me.setWidth(0);
	    	me.hide();
	    }
     },
	onHide:function()	{
		this.destroy();
		UniAppManager.app.onQueryButtonDown();
	}
});