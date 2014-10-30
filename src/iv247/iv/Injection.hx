package iv247.iv;
enum Injection {

    Value (v:Dynamic);

    DynamicObject (t:Class<Dynamic>);

    Singleton (t:Class<Dynamic>, it:Class<Dynamic>);
}
