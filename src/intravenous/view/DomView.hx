package intravenous.view;
#if js

import haxe.extern.Rest;
import js.html.DOMTokenList;
import js.Browser;

class DomView implements View {
    public var parent(default, null):View;

    public var children(default, null):Array<View>;

    public var viewElement(default, null):js.html.Element;

    private var nodeType:String;
    private var classList : Array<String>;

    @dispatcher
    public var dispatch:Dynamic -> Void;

    public function new (type:String = "div", ?classes:Array<String>) {
        this.nodeType = type;
        this.classList = classes;
        this.create();
    }

    public function add (view:View):Void {
        if ( children == null ) {
            children = [];
        }

        if ( !Lambda.has( children, view ) ) {
            dispatch(new ViewMessage(ViewMessage.Types.ADDING, view));
            this.children.push( view );
            view.render();
            view.onRenderComplete( );
            viewElement.appendChild( view.viewElement );
        }

        dispatch( new ViewMessage(ViewMessage.Types.ADDED, view) );
    }

    public function create ():Void {
        var attr = Browser.document.createAttribute( 'view' );
        var type = Type.getClass( this );
        var className = Type.getClassName( type );
        var name = untyped type.__name__[type.__name__.length - 1];

        attr.value = Type.getClassName( type );
        viewElement = Browser.document.createElement( nodeType );
        viewElement.attributes.setNamedItem( attr );
        viewElement.classList.add(name);

        if(classList != null){
            Reflect.callMethod(viewElement.classList,viewElement.classList.add,classList);
        }

        this.createChildren();
    }

    private function createChildren():Void{};

    public function render ():Void {}

    public function onCreateComplete ():Void{}
    public function onRenderComplete ():Void {}

    public function remove (view:View):Void {
        if ( children.remove( view ) ) {
            view.viewElement.remove( );
        }

        dispatch( new ViewMessage(ViewMessage.Types.REMOVED, view) );
    }

}#end