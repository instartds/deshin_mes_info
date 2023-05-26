//@charset UTF-8
/**
 * 상세팝업용 윈도 모듈
 * 
 */
Ext.define('Unilite.com.window.UniBaseWindowApp', {
    extend: 'Unilite.com.window.UniWindow',
    header: {
        titlePosition: 0,
        titleAlign: 'left'
    },
        
    closable: false,
    closeAction: 'hide',
    modal: true,
    resizable: true,
    layout: {
        type: 'fit'
    },
    dockedItems: [],
    
    onSaveDataButtonDown:  Ext.emptyFn,
    onSaveAndCloseButtonDown:  Ext.emptyFn,
    onDeleteDataButtonDown:  Ext.emptyFn,
    onCloseButtonDown:  Ext.emptyFn, 
    onPrevDataButtonDown: Ext.emptyFn,
    onNextDataButtonDown: Ext.emptyFn,
    
    /**
     * extend init props
     */
   initComponent: function () {
        var me = this;
        me.callParent(arguments);
    }
//UniBaseWindowApp
});

