// @charset UTF-8
Ext.define("Unilite.main.MainContentPanel", {
	extend : 'Ext.ux.IFrame',
    alias: 'widget.uniMainContent',
    text: {
    	closeWinMsgTitle: UniUtils.getLabel('system.label.commonJS.panel.closeWinMsgTitle','확인'),
	    closeWinMsgMessage : UniUtils.getMessage('system.message.commonJS.panel.closeWinMsgMessage','저장되지 않은 자료가 있습니다. 현재 페이지를 닫으시겠습니까?' )  	
    },
	initComponent : function() {
		var me = this;
		this.callParent();

		this.on("beforeclose",  this.onClose, this);
	},
	onClose : function(p) {
		var win = this.getWin();
		var isDirty = false;
		if(win) {
			try {
				isDirty = this.getWin().UniAppManager.getApp().isDirty();
			}catch(err) {
				console.log("MainContentPanel onClose Exception : ", err);
			}
		}
		if(isDirty) {
			Ext.MessageBox.show({
					title : this.text.closeWinMsgTitle,
					msg : this.text.closeWinMsgMessage,
					icon: Ext.Msg.WARNING,
					buttons : Ext.MessageBox.OKCANCEL,
					fn : function(buttonId) {
						switch (buttonId) {
	
							case 'ok' :
								//this.saveToFile();
								//this.ownerCt.remove(p);
								var tab = p.tab;
								if(tab && tab.closable) {
									//tab.onCloseClick();
									this.ownerCt.remove(p);
								}
								break;
							case 'cancel' :
								// leave blank if no action required on
								// cancel
								break;
						}
					},
					scope : this
				}); // MessageBox
			return false; // returning false to beforeclose cancels the
						  // close event
		} else {
			return true;
		}
	} // onClose
}); // MainContentPanel
