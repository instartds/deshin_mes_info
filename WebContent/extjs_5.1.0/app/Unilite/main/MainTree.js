//@charset UTF-8

Ext.define("Unilite.main.MainTree", {
  extend: "Ext.tree.Panel",
  alias: "widget.doctree",
  cls: "doc-tree iScroll",
  useArrows: false,
  animCollapse: true,
  animate: true,
  rootVisible: false,
  border: true,
  bodyBorder: false,
  
  margins: '0 0 0 0',
  rowLines: false, lines: false,
  scroll: 'vertical',
			
  initComponent: function() {
  	//addEvents 제거 - 5.0.1 deprecated
    //this.addEvents("urlclick");
    
    //this.root.expanded = true;
    this.on("itemclick", this.onItemClick, this);
    this.on("beforeitemcollapse", this.handleBeforeExpandCollapse, this);
    this.on("beforeitemexpand", this.handleBeforeExpandCollapse, this);
    this.callParent();
    this.nodeTpl = new Ext.XTemplate('<a href="{url}" rel="{url}">{text}</a>');
   /// this.initNodeLinks()
  },
  /*
  initNodeLinks: function() {
    this.getRootNode().cascadeBy(this.applyNodeTpl, this)
  },
  applyNodeTpl: function(b) {
    if (b.get("leaf")) {
      b.set("text", this.nodeTpl.apply({
        text: b.get("text"),
        url: b.raw.url
      }));
      b.commit()
    }
  },
  */
  onItemClick: function(h, rec, k, l, i) {
    var url = rec.raw ? rec.raw.url : rec.data.url;
    if (url) {
      this.fireEvent("urlclick", rec, url, i)
    } else {
      if (!rec.isLeaf()) {
        if (rec.isExpanded()) {
          rec.collapse(false)
        } else {
          rec.expand(false)
        }
      }
    }
  },
  /*
  selectUrl: function(d) {
    var c = this.findNodeByUrl(d);
    if (c) {
      c.bubble(function(a) {
        a.expand()
      });
      this.getSelectionModel().select(c)
    } else {
      this.getSelectionModel().deselectAll()
    }
  },
  */
  findNodeByUrl: function(b) {
    //return this.getRootNode().findChildBy(function(a) { //4.2.2
  	return this.getRoot().findChildBy(function(a) {	//5.1
      return b === a.raw.url
    }, this, true)
  },
  findRecordByUrl: function(d) {
    var c = this.findNodeByUrl(d);
    return c ? c.raw : undefined
  },
  handleBeforeExpandCollapse: function(b) {
    if (this.getView().isAnimating(b)) {
      return false
    }
  }
});

