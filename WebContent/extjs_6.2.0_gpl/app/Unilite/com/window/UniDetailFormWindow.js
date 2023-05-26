//@charset UTF-8
/**
 * 상세팝업용 윈도 모듈
 * 
 */
Ext.define('Unilite.com.window.UniDetailFormWindow', {
    extend: 'Unilite.com.window.UniBaseWindowApp',
    alias: 'widget.uniDetailFormWindow',

    maximizable: true,
    buttonAlign: 'right',
    constructor : function (config) {
        var me = this;

        me.callParent(arguments);
        
        me.delayedSaveDataButtonDown = Ext.create('Ext.util.DelayedTask', me.onSaveDataButtonDown, me);
        me.delayedSaveAndCloseButtonDown = Ext.create('Ext.util.DelayedTask', me.onSaveAndCloseButtonDown, me);
    },
	/**
	 * extend init props
	 */
   initComponent: function () {
 		var me = this;
        
        var toolbarItems =  ['->',
	                {   
	                    itemId : 'saveBtn',
	                    text: me.text.btnSave,
	                    handler: function() {
                            me.delayedSaveDataButtonDown.delay(500);
	                        //me.onSaveDataButtonDown();
	                    },
	                    disabled: true
	                }, '-',{                    
	                    itemId : 'saveCloseBtn',
	                    text: '저장 후 닫기',
	                    handler: function() {                               
	                        me.delayedSaveAndCloseButtonDown.delay(500);                
                            //me.onSaveAndCloseButtonDown();
	                    },
	                    disabled: true
	                }, '-',' ',{                    
	                    itemId : 'deleteCloseBtn',
	                    text: me.text.btnDelete,
	                    handler: function() {
	                            me.onDeleteDataButtonDown();                        
	                    },
	                    disabled: false
	                }, '-',' ',{                    
                        itemId : 'prev',
                        text: '이전',
                        handler: function() {
//                            var frm = me.down('form');
//                            if(frm && !frm.isDirty())    {
                                me.onPrevDataButtonDown();   
//                            }
                        },
                        disabled: false
                    },{                    
                        itemId : 'next',
                        text: '다음',
                        handler: function() {
//                            var frm = me.down('form');
//                            if(frm && !frm.isDirty())  {
                                me.onNextDataButtonDown();   
//                            }
                        },
                        disabled: false
                    },'-',' ',{
	                    itemId : 'closeBtn',
	                    text: '닫기',
	                    handler: function() {
	                        me.onCloseButtonDown()
	                    },
	                    disabled: false
	                }
	            ];
        

        me.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
                dock : 'top',
                items : toolbarItems
        });
        me.dockedItems = me.toolbar;
        
        this.on('beforehide', me._beforeHide);
        this.on('beforeclose', me._beforeClose);
        me.callParent(arguments);
    },
    getForm: function(){
        var me = this;
        return me.down('form');
    },
    /**
     * 화면이 close 하기전에 저장 여부 확인
     * @param {} me
     * @param {} eOpt
     */
    _beforeHide: function(me, eOpt) {
        UniAppManager.app.confirmSaveData();
    },
    /**
     * @private 
     */
    _beforeClose: function() {
        UniAppManager.app.confirmSaveData();
    },
    onCloseButtonDown: function() {
        this.hide();
    }
});