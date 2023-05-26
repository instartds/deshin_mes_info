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
	title: '인쇄',
    closable: true,
    disabled: true,
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
		    collapseMode: 'header', //header, mini
		    baseParams: {
		    	'PGM_ID': me.prgID
		    },
		    layout:  {
		    	type: 'vbox',
		        align: 'stretch',
		        padding: '0 5 0 5'
		    },
		    title: '출력옵션',
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
				{fieldLabel: '제목', 	xtype:'textfield', name: 'PT_TITLENAME', labelAlign:'top', disabled: true, allowBlank: false ,style: {'margin-left': '2px' ,'margin-right':'5px' }},
				{boxLabel: '회사명',name: 'PT_COMPANY_YN',inputValue: 'Y', uncheckedValue:'N', disabled: true ,style: {'margin-left': '2px'}},
				{boxLabel: '결재란',name: 'PT_SANCTION_YN',inputValue: 'Y', uncheckedValue:'N', disabled: true ,style: {'margin-left': '2px'}},
				{boxLabel: '페이지',name: 'PT_PAGENUM_YN',inputValue: 'Y', uncheckedValue:'N', disabled: true ,style: {'margin-left': '2px'}},
				{	xtype:'fieldcontainer',
					layout:{
				    	type: 'hbox',
				        align: 'stretch'
				    },
					items: [
						{xtype:'checkbox', boxLabel: '출력일',name: 'PT_OUTPUTDATE_YN', inputValue:'Y', uncheckedValue:'N', disabled: true ,style: {'margin-left': '2px'}},
						{xtype:'uniDatefield', name: 'PT_OUTPUTDATE', labelPad: 0, flex:1,style: {'margin-left': '0px','margin-right':'5px' } , disabled: true, value: new Date()}
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
				                text: '설정저장',
								style: itemStyle,
								flex:1,
								margin: '0 5 5 2',
								formBind: true,
				                handler: function() {
					                if(me.validForm()) {
					                	me.onSaveConfig(me);
					                }
				                }
				        	},
				        	{   
								xtype:'button',
				                text: '기본값적용',
								style: itemStyle,
								flex:1,
								margin: '0 5 5 5',
				                handler: function() {me.onResetConfig(me);}
				        	}	
				        	]
				},
				{	xtype:'button',
	                text: '설정값 적용 미리보기',
					style: itemStyle,
					formBind: true,
	                handler: function() {me.updatePreview();}
	        	},
				{  
					xtype:'button', disabled: true,
					itemId: 'saveAsXLS',
					style: itemStyle,
					formBind: true,
	                text: '엑셀파일로 저장(xlsx)',
	                disabled: true,
	                handler: function() {me.onSaveAs(me,'xlsx');}
	        	},{   
					xtype:'button', disabled: true,
					itemId: 'saveAsDOC',
					style: itemStyle,
					formBind: true,
	                disabled: true,
	                text: '워드파일로 저장(docx)',
	                handler: function() {me.onSaveAs(me,'docx');}
	        	},{   
					xtype:'button', disabled: true,
					itemId: 'saveAsPDF',
					style: itemStyle,
					formBind: true,
	                disabled: true,
	                text: 'PDF파일로 저장(pdf)',
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
			alert('오류사항을 확인해 주세요');
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
			if(result.PT_SAVEASXLS_USE == 'Y') me.down("#saveAsXLS").enable();
			if(result.PT_SAVEASPDF_USE == 'Y') me.down("#saveAsPDF").enable();
			if(result.PT_SAVEASDOC_USE == 'Y') me.down("#saveAsDOC").enable();
			
			
			if(result.PT_COMPANY_USE == 'Y') form.getField("PT_COMPANY_YN").enable();
			if(result.PT_SANCTION_USE == 'Y') form.getField("PT_SANCTION_YN").enable();
			if(result.PT_PAGENUM_USE == 'Y') form.getField("PT_PAGENUM_YN").enable();
			if(result.PT_TITLENAME_USE == 'Y') {
				form.getField("PT_TITLENAME").enable();
				form.setValue("PT_TITLENAME", result.PT_TITLENAME);
			}
			
			if(result.PT_OUTPUTDATE_USE == 'Y') {
				form.getField("PT_OUTPUTDATE_YN").enable();
				form.getField("PT_OUTPUTDATE").enable();
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
		form.submit({success : function() {UniAppManager.updateStatus(Msg.sMB011);}});
		
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
			UniAppManager.updateStatus('기본값이 적용 되었습니다.');
		}
	},
     onShow: function() {
        var me = this;
     	//console.log('onShow');
     	
        me.callParent(arguments);
     }
});