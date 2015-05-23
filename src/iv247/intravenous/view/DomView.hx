package iv247.intravenous.view;
#if js

import js.Browser;

class DomView implements View {
    public var parent(default, null):View;

    public var children(default, null):Array<View>;

    public var viewElement(default, null):js.html.Element;

    private var nodeType:String;

    @dispatcher
    public var dispatch:Dynamic -> Void;

    public function new (type:String = "div") {
        this.nodeType = type;
    }

    public function add (view:View):Void {
        if ( children == null ) {
            children = [];
        }

        if ( !Lambda.has( children, view ) ) {
            this.children.push( view );
            view.create( );
            view.render( );
            view.onRenderComplete( );
            viewElement.appendChild( view.viewElement );
        }

        dispatch( new ViewMessage(ViewMessage.Types.ADDED) );
    }

    public function create ():Void {
        var attr = Browser.document.createAttribute( 'view' );
        var type = Type.getClass( this );
        var className = Type.getClassName( type );
        var name = untyped type.__name__[type.__name__.length - 1];

        attr.value = Type.getClassName( type );
        viewElement = Browser.document.createElement( nodeType );
        viewElement.classList.add( name );
        viewElement.attributes.setNamedItem( attr );
    }

    public function render ():Void {}

    public function onRenderComplete ():Void {}

    public function remove (view:View):Void {
        if ( children.remove( view ) ) {
            view.viewElement.remove( );
        }

        dispatch( new ViewMessage(ViewMessage.Types.REMOVED) );
    }

}#end