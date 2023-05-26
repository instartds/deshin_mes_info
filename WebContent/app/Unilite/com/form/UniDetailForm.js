//@charset UTF-8
/**
 * 기본 상세 폼
 * 
 * Unilite.createForm을 통해 생성 함{@link Unilite#createForm}
 * 
 */
Ext.define('Unilite.com.form.UniDetailForm', {
	extend : 'Unilite.com.form.UniAbstractForm',
	alias : 'widget.uniDetailForm',

	collapsible : false,
	//formBind: true,		// true로 form 안에 grid가 disabled되는 경우 발생 
    trackResetOnLoad: true,
	autoScroll:true,
	disabled :true,
  	constructor: function(config) {
  		var me = this;
  		config = config || {};
	    config.trackResetOnLoad = true;
	    me.callParent([config]);
  	},  	
  	initComponent: function(){
  		
  		var me = this;
  		
  		console.log("uniDetailForm " + this.id + " init.");
       // this.on('afterrender',this._onAfterRenderFunction , this);
  		// form을 그리기 전에 fields 기본값 처리 
        this.on('beforerender',this._onAfterRenderFunction , this);
        //this.on('add',this._onFieldAddFunction , this); // 손자 이하의 field의 추가에 대해 반응 하지 않음.
  		console.log("uniDetailForm : " + this.id + " init End.");
        this.callParent();
	},

	beforeRender : function() {
		/*
		if (!this.allowBlank) {
			this.labelStyle = 'color:#FF0000';
		}

		if (this.readOnly) {
			this.fieldCls = 'readOnlyClass';
		}
		*/
		this.callParent();
	}
	
});