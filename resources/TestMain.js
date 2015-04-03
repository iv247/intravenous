(function (console, $hx_exports) { "use strict";
$hx_exports.promhx = $hx_exports.promhx || {};
var $hxClasses = {},$estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
$hxClasses["EReg"] = EReg;
EReg.__name__ = ["EReg"];
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) return this.r.m[n]; else throw new js__$Boot_HaxeError("EReg::matched");
	}
	,__class__: EReg
};
var HxOverrides = function() { };
$hxClasses["HxOverrides"] = HxOverrides;
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
$hxClasses["Lambda"] = Lambda;
Lambda.__name__ = ["Lambda"];
Lambda.exists = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
};
Lambda.iter = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		f(x);
	}
};
Lambda.concat = function(a,b) {
	var l = new List();
	var $it0 = $iterator(a)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(x);
	}
	var $it1 = $iterator(b)();
	while( $it1.hasNext() ) {
		var x1 = $it1.next();
		l.add(x1);
	}
	return l;
};
var List = function() {
	this.length = 0;
};
$hxClasses["List"] = List;
List.__name__ = ["List"];
List.prototype = {
	add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,first: function() {
		if(this.h == null) return null; else return this.h[0];
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,iterator: function() {
		return new _$List_ListIterator(this.h);
	}
	,filter: function(f) {
		var l2 = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			if(f(v)) l2.add(v);
		}
		return l2;
	}
	,__class__: List
};
var _$List_ListIterator = function(head) {
	this.head = head;
	this.val = null;
};
$hxClasses["_List.ListIterator"] = _$List_ListIterator;
_$List_ListIterator.__name__ = ["_List","ListIterator"];
_$List_ListIterator.prototype = {
	hasNext: function() {
		return this.head != null;
	}
	,next: function() {
		this.val = this.head[0];
		this.head = this.head[1];
		return this.val;
	}
	,__class__: _$List_ListIterator
};
Math.__name__ = ["Math"];
var Reflect = function() { };
$hxClasses["Reflect"] = Reflect;
Reflect.__name__ = ["Reflect"];
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		haxe_CallStack.lastException = e;
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		return null;
	}
};
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
};
var Std = function() { };
$hxClasses["Std"] = Std;
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringTools = function() { };
$hxClasses["StringTools"] = StringTools;
StringTools.__name__ = ["StringTools"];
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
};
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && HxOverrides.substr(s,slen - elen,elen) == end;
};
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
StringTools.lpad = function(s,c,l) {
	if(c.length <= 0) return s;
	while(s.length < l) s = c + s;
	return s;
};
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
var buddy_BuddySuite = function() {
	this.suites = new List();
	this.befores = new List();
	this.afters = new List();
	this.suiteStack = new List();
	this.timeoutMs = 5000;
};
$hxClasses["buddy.BuddySuite"] = buddy_BuddySuite;
buddy_BuddySuite.__name__ = ["buddy","BuddySuite"];
buddy_BuddySuite.includeMode = null;
buddy_BuddySuite.prototype = {
	describe: function(name,addSpecs) {
		this.addSuite(new buddy_Suite(name,this),addSpecs);
	}
	,xdescribe: function(name,addSpecs) {
	}
	,before: function(init) {
		this.syncBefore(init,true);
	}
	,after: function(deinit) {
		this.syncAfter(deinit,true);
	}
	,it: function(desc,test) {
		this.syncIt(desc,test,true);
	}
	,xit: function(desc,test) {
		this.syncXit(desc,test,true);
	}
	,fail: function(desc) {
		if(desc == null) desc = "Manually";
	}
	,failSync: function(test,desc,p) {
		if(desc == null) desc = "Manually";
		var stackItem = [haxe_StackItem.FilePos(null,p.fileName,p.lineNumber)];
		test(false,Std.string(desc),stackItem);
	}
	,addSuite: function(suite,addSpecs) {
		if(this.suiteStack.isEmpty()) this.suites.add(suite); else {
			var current = this.suiteStack.first();
			suite.parent = current;
			current.steps.add(buddy_TestStep.TSuite(suite));
		}
		if(buddy_BuddySuite.includeMode && !suite.include) {
			suite.steps = suite.steps.filter(function(step) {
				switch(step[1]) {
				case 1:
					var s = step[2];
					return s.include;
				default:
					return true;
				}
			});
			if(suite.steps.length > 0 || suite.parent != null && suite.parent.include) suite.include = true;
		}
		this.suiteStack.push(suite);
		addSpecs();
		this.suiteStack.pop();
	}
	,describeInclude: function(name,addSpecs) {
		buddy_BuddySuite.includeMode = true;
		var suite = new buddy_Suite(name,this);
		suite.include = true;
		this.addSuite(suite,addSpecs);
	}
	,itInclude: function(desc,test) {
		buddy_BuddySuite.includeMode = true;
		this.syncIt(desc,test,true,true);
	}
	,syncItInclude: function(desc,test) {
		buddy_BuddySuite.includeMode = true;
		this.syncIt(desc,test,false,true);
	}
	,beforeDescribe: function(init) {
		this.syncBeforeDescribe(init,true);
	}
	,afterDescribe: function(init) {
		this.syncAfterDescribe(init,true);
	}
	,syncBeforeDescribe: function(init,async) {
		if(async == null) async = false;
		this.befores.add(new buddy_BeforeAfter(init,async));
	}
	,syncAfterDescribe: function(init,async) {
		if(async == null) async = false;
		this.afters.add(new buddy_BeforeAfter(init,async));
	}
	,syncBefore: function(init,async) {
		if(async == null) async = false;
		this.suiteStack.first().before.add(new buddy_BeforeAfter(init,async));
	}
	,syncAfter: function(deinit,async) {
		if(async == null) async = false;
		this.suiteStack.first().after.add(new buddy_BeforeAfter(deinit,async));
	}
	,syncIt: function(desc,test,async,include) {
		if(include == null) include = false;
		if(async == null) async = false;
		var suite = this.suiteStack.first();
		var spec = new buddy_Spec(suite,desc,test,async);
		spec.include = include;
		suite.steps.add(buddy_TestStep.TSpec(spec));
	}
	,syncXit: function(desc,test,async) {
		if(async == null) async = false;
		var suite = this.suiteStack.first();
		var spec = new buddy_Spec(suite,desc,test,async,true);
		suite.steps.add(buddy_TestStep.TSpec(spec));
	}
	,__class__: buddy_BuddySuite
};
var buddy_Buddy = function() { };
$hxClasses["buddy.Buddy"] = buddy_Buddy;
buddy_Buddy.__name__ = ["buddy","Buddy"];
var TestMain = function() {
	buddy_BuddySuite.call(this);
};
$hxClasses["TestMain"] = TestMain;
TestMain.__name__ = ["TestMain"];
TestMain.__interfaces__ = [buddy_Buddy];
TestMain.main = function() {
	var reporter = new buddy_reporting_ConsoleReporter();
	var suites = [];
	var _g = 0;
	var _g1 = haxe_rtti_Meta.getType(Type.resolveClass("TestMain")).autoIncluded;
	while(_g < _g1.length) {
		var a = _g1[_g];
		++_g;
		suites.push(Type.createInstance(Type.resolveClass(a),[]));
	}
	var testsRunning = true;
	var runner = new buddy_SuitesRunner(suites,reporter);
	runner.run();
};
TestMain.__super__ = buddy_BuddySuite;
TestMain.prototype = $extend(buddy_BuddySuite.prototype,{
	__class__: TestMain
});
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] };
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; };
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; };
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = function() { };
$hxClasses["Type"] = Type;
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null; else return js_Boot.getClass(o);
};
Type.getSuperClass = function(c) {
	return c.__super__;
};
Type.getClassName = function(c) {
	var a = c.__name__;
	if(a == null) return null;
	return a.join(".");
};
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
};
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || !cl.__name__) return null;
	return cl;
};
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || !e.__ename__) return null;
	return e;
};
Type.createInstance = function(cl,args) {
	var _g = args.length;
	switch(_g) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw new js__$Boot_HaxeError("Too many arguments");
	}
	return null;
};
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw new js__$Boot_HaxeError("No such constructor " + constr);
	if(Reflect.isFunction(f)) {
		if(params == null) throw new js__$Boot_HaxeError("Constructor " + constr + " need parameters");
		return Reflect.callMethod(e,f,params);
	}
	if(params != null && params.length != 0) throw new js__$Boot_HaxeError("Constructor " + constr + " does not need parameters");
	return f;
};
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	HxOverrides.remove(a,"__name__");
	HxOverrides.remove(a,"__interfaces__");
	HxOverrides.remove(a,"__properties__");
	HxOverrides.remove(a,"__super__");
	HxOverrides.remove(a,"__meta__");
	HxOverrides.remove(a,"prototype");
	return a;
};
Type["typeof"] = function(v) {
	var _g = typeof(v);
	switch(_g) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = js_Boot.getClass(v);
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
};
var buddy_TestStatus = $hxClasses["buddy.TestStatus"] = { __ename__ : ["buddy","TestStatus"], __constructs__ : ["Unknown","Passed","Pending","Failed"] };
buddy_TestStatus.Unknown = ["Unknown",0];
buddy_TestStatus.Unknown.toString = $estr;
buddy_TestStatus.Unknown.__enum__ = buddy_TestStatus;
buddy_TestStatus.Passed = ["Passed",1];
buddy_TestStatus.Passed.toString = $estr;
buddy_TestStatus.Passed.__enum__ = buddy_TestStatus;
buddy_TestStatus.Pending = ["Pending",2];
buddy_TestStatus.Pending.toString = $estr;
buddy_TestStatus.Pending.__enum__ = buddy_TestStatus;
buddy_TestStatus.Failed = ["Failed",3];
buddy_TestStatus.Failed.toString = $estr;
buddy_TestStatus.Failed.__enum__ = buddy_TestStatus;
var buddy_TestStep = $hxClasses["buddy.TestStep"] = { __ename__ : ["buddy","TestStep"], __constructs__ : ["TSuite","TSpec"] };
buddy_TestStep.TSuite = function(s) { var $x = ["TSuite",0,s]; $x.__enum__ = buddy_TestStep; $x.toString = $estr; return $x; };
buddy_TestStep.TSpec = function(s) { var $x = ["TSpec",1,s]; $x.__enum__ = buddy_TestStep; $x.toString = $estr; return $x; };
var buddy_BeforeAfter = function(run,async) {
	if(async == null) async = false;
	this.run = run;
	this.async = async;
};
$hxClasses["buddy.BeforeAfter"] = buddy_BeforeAfter;
buddy_BeforeAfter.__name__ = ["buddy","BeforeAfter"];
buddy_BeforeAfter.prototype = {
	__class__: buddy_BeforeAfter
};
var buddy_Suite = function(name,buddySuite) {
	if(name == null) throw new js__$Boot_HaxeError("Suite requires a name.");
	if(buddySuite == null) throw new js__$Boot_HaxeError("Suite requires a BuddySuite.");
	this.name = name;
	this.buddySuite = buddySuite;
	this.before = new List();
	this.after = new List();
	this.steps = new List();
};
$hxClasses["buddy.Suite"] = buddy_Suite;
buddy_Suite.__name__ = ["buddy","Suite"];
buddy_Suite.prototype = {
	get_specs: function() {
		var output = new List();
		var _g_head = this.steps.h;
		var _g_val = null;
		while(_g_head != null) {
			var step;
			step = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			switch(step[1]) {
			case 1:
				var s = step[2];
				output.add(s);
				break;
			default:
			}
		}
		return output;
	}
	,get_suites: function() {
		var output = new List();
		var _g_head = this.steps.h;
		var _g_val = null;
		while(_g_head != null) {
			var step;
			step = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			switch(step[1]) {
			case 0:
				var s = step[2];
				output.add(s);
				break;
			default:
			}
		}
		return output;
	}
	,__class__: buddy_Suite
};
var buddy_Spec = function(suite,description,run,async,pending) {
	if(pending == null) pending = false;
	if(async == null) async = false;
	this.suite = suite;
	this.description = description;
	this.run = run;
	this.async = async;
	this.traces = new List();
	if(run == null) this.status = buddy_TestStatus.Pending; else if(pending) this.status = buddy_TestStatus.Pending; else this.status = buddy_TestStatus.Unknown;
};
$hxClasses["buddy.Spec"] = buddy_Spec;
buddy_Spec.__name__ = ["buddy","Spec"];
buddy_Spec.prototype = {
	setStatus: function(s,err,stack) {
		this.status = s;
		this.error = err;
		this.stack = stack;
	}
	,__class__: buddy_Spec
};
var buddy_Should = function(value,assert,inverse) {
	if(inverse == null) inverse = false;
	this.value = value;
	this.assert = assert;
	this.inverse = inverse;
};
$hxClasses["buddy.Should"] = buddy_Should;
buddy_Should.__name__ = ["buddy","Should"];
buddy_Should.prototype = {
	be: function(expected,p) {
		this.test(this.value == expected,p,"Expected " + this.quote(expected) + ", was " + this.quote(this.value),"Didn't expect " + this.quote(expected) + " but was equal to that");
	}
	,beType: function(type,p) {
		this.test(js_Boot.__instanceof(this.value,type),p,"Expected " + this.quote(this.value) + " to be type " + this.quote(type),"Expected " + this.quote(this.value) + " not to be type " + this.quote(type));
	}
	,quote: function(v) {
		if(typeof(v) == "string") return "\"" + Std.string(v) + "\""; else return Std.string(v);
	}
	,stackPos: function(p) {
		return [haxe_StackItem.FilePos(null,p.fileName,p.lineNumber)];
	}
	,test: function(expr,p,error,errorInverted) {
		if(!this.inverse) this.assert(expr,error,this.stackPos(p)); else this.assert(!expr,errorInverted,this.stackPos(p));
	}
	,__class__: buddy_Should
};
var buddy_ShouldDynamic = function(value,assert,inverse) {
	buddy_Should.call(this,value,assert,inverse);
};
$hxClasses["buddy.ShouldDynamic"] = buddy_ShouldDynamic;
buddy_ShouldDynamic.__name__ = ["buddy","ShouldDynamic"];
buddy_ShouldDynamic.should = function(d,assert) {
	return new buddy_ShouldDynamic(d,assert);
};
buddy_ShouldDynamic.__super__ = buddy_Should;
buddy_ShouldDynamic.prototype = $extend(buddy_Should.prototype,{
	get_not: function() {
		return new buddy_ShouldDynamic(this.value,this.assert,!this.inverse);
	}
	,__class__: buddy_ShouldDynamic
});
var buddy_ShouldInt = function(value,assert,inverse) {
	if(inverse == null) inverse = false;
	buddy_Should.call(this,value,assert,inverse);
};
$hxClasses["buddy.ShouldInt"] = buddy_ShouldInt;
buddy_ShouldInt.__name__ = ["buddy","ShouldInt"];
buddy_ShouldInt.should = function(i,assert) {
	return new buddy_ShouldInt(i,assert);
};
buddy_ShouldInt.__super__ = buddy_Should;
buddy_ShouldInt.prototype = $extend(buddy_Should.prototype,{
	get_not: function() {
		return new buddy_ShouldInt(this.value,this.assert,!this.inverse);
	}
	,beLessThan: function(expected,p) {
		this.test(this.value < expected,p,"Expected less than " + this.quote(expected) + ", was " + this.quote(this.value),"Expected not less than " + this.quote(expected) + ", was " + this.quote(this.value));
	}
	,beGreaterThan: function(expected,p) {
		this.test(this.value > expected,p,"Expected greater than " + this.quote(expected) + ", was " + this.quote(this.value),"Expected not greater than " + this.quote(expected) + ", was " + this.quote(this.value));
	}
	,__class__: buddy_ShouldInt
});
var buddy_ShouldFloat = function(value,assert,inverse) {
	if(inverse == null) inverse = false;
	buddy_Should.call(this,value,assert,inverse);
};
$hxClasses["buddy.ShouldFloat"] = buddy_ShouldFloat;
buddy_ShouldFloat.__name__ = ["buddy","ShouldFloat"];
buddy_ShouldFloat.should = function(i,assert) {
	return new buddy_ShouldFloat(i,assert);
};
buddy_ShouldFloat.__super__ = buddy_Should;
buddy_ShouldFloat.prototype = $extend(buddy_Should.prototype,{
	get_not: function() {
		return new buddy_ShouldFloat(this.value,this.assert,!this.inverse);
	}
	,beLessThan: function(expected,p) {
		this.test(this.value < expected,p,"Expected less than " + this.quote(expected) + ", was " + this.quote(this.value),"Expected not less than " + this.quote(expected) + ", was " + this.quote(this.value));
	}
	,beGreaterThan: function(expected,p) {
		this.test(this.value > expected,p,"Expected greater than " + this.quote(expected) + ", was " + this.quote(this.value),"Expected not greater than " + this.quote(expected) + ", was " + this.quote(this.value));
	}
	,beCloseTo: function(expected,precision,p) {
		if(precision == null) precision = 2;
		var expr = Math.abs(expected - this.value) < Math.pow(10,-precision) / 2;
		this.test(expr,p,"Expected close to " + this.quote(expected) + ", was " + this.quote(this.value),"Expected " + this.quote(this.value) + " not to be close to " + this.quote(expected));
	}
	,__class__: buddy_ShouldFloat
});
var buddy_ShouldString = function(value,assert,inverse) {
	if(inverse == null) inverse = false;
	buddy_Should.call(this,value,assert,inverse);
};
$hxClasses["buddy.ShouldString"] = buddy_ShouldString;
buddy_ShouldString.__name__ = ["buddy","ShouldString"];
buddy_ShouldString.should = function(str,assert) {
	return new buddy_ShouldString(str,assert);
};
buddy_ShouldString.__super__ = buddy_Should;
buddy_ShouldString.prototype = $extend(buddy_Should.prototype,{
	get_not: function() {
		return new buddy_ShouldString(this.value,this.assert,!this.inverse);
	}
	,contain: function(substring,p) {
		this.test(this.value.indexOf(substring) >= 0,p,"Expected " + this.quote(this.value) + " to contain " + this.quote(substring),"Expected " + this.quote(this.value) + " not to contain " + this.quote(substring));
	}
	,startWith: function(substring,p) {
		this.test(StringTools.startsWith(this.value,substring),p,"Expected " + this.quote(this.value) + " to start with " + this.quote(substring),"Expected " + this.quote(this.value) + " not to start with " + this.quote(substring));
	}
	,endWith: function(substring,p) {
		this.test(StringTools.endsWith(this.value,substring),p,"Expected " + this.quote(this.value) + " to end with " + this.quote(substring),"Expected " + this.quote(this.value) + " not to end with " + this.quote(substring));
	}
	,match: function(regexp,p) {
		this.test(regexp.match(this.value),p,"Expected " + this.quote(this.value) + " to match regular expression","Expected " + this.quote(this.value) + " not to match regular expression");
	}
	,__class__: buddy_ShouldString
});
var buddy_ShouldIterable = function(value,assert,inverse) {
	if(inverse == null) inverse = false;
	buddy_Should.call(this,value,assert,inverse);
};
$hxClasses["buddy.ShouldIterable"] = buddy_ShouldIterable;
buddy_ShouldIterable.__name__ = ["buddy","ShouldIterable"];
buddy_ShouldIterable.should = function(value,assert) {
	return new buddy_ShouldIterable(value,assert);
};
buddy_ShouldIterable.__super__ = buddy_Should;
buddy_ShouldIterable.prototype = $extend(buddy_Should.prototype,{
	get_not: function() {
		return new buddy_ShouldIterable(this.value,this.assert,!this.inverse);
	}
	,contain: function(o,p) {
		this.test(Lambda.exists(this.value,function(el) {
			return el == o;
		}),p,"Expected " + this.quote(this.value) + " to contain " + this.quote(o),"Expected " + this.quote(this.value) + " not to contain " + this.quote(o));
	}
	,containAll: function(values,p) {
		var expr = true;
		var $it0 = $iterator(values)();
		while( $it0.hasNext() ) {
			var a = $it0.next();
			var a1 = [a];
			if(!Lambda.exists(this.value,(function(a1) {
				return function(v) {
					return v == a1[0];
				};
			})(a1))) {
				expr = false;
				break;
			}
		}
		this.test(expr,p,"Expected " + this.quote(this.value) + " to contain all of " + this.quote(values),"Expected " + this.quote(this.value) + " not to contain all of " + this.quote(values));
	}
	,containExactly: function(values,p) {
		var a = $iterator(this.value)();
		var b = $iterator(values)();
		var expr = true;
		while(a.hasNext() || b.hasNext()) if(a.next() != b.next()) {
			expr = false;
			break;
		}
		this.test(expr,p,"Expected " + this.quote(this.value) + " to contain exactly " + this.quote(values),"Expected " + this.quote(this.value) + " not to contain exactly " + this.quote(values));
	}
	,__class__: buddy_ShouldIterable
});
var buddy_ShouldFunctions = function(value,assert,inverse) {
	if(inverse == null) inverse = false;
	this.value = value;
	this.assert = assert;
	this.inverse = inverse;
};
$hxClasses["buddy.ShouldFunctions"] = buddy_ShouldFunctions;
buddy_ShouldFunctions.__name__ = ["buddy","ShouldFunctions"];
buddy_ShouldFunctions.should = function(value,assert) {
	return new buddy_ShouldFunctions(value,assert);
};
buddy_ShouldFunctions.prototype = {
	get_not: function() {
		return new buddy_ShouldFunctions(this.value,this.assert,!this.inverse);
	}
	,throwValue: function(v,p) {
		var expr = false;
		try {
			this.value();
		} catch( e ) {
			haxe_CallStack.lastException = e;
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			expr = e == v;
		}
		this.test(expr,p,"Expected " + this.quote(this.value) + " to throw " + this.quote(v),"Expected " + this.quote(this.value) + " not to throw " + this.quote(v));
	}
	,throwType: function(type,p) {
		var expr = false;
		var name = null;
		try {
			this.value();
		} catch( e ) {
			haxe_CallStack.lastException = e;
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			name = Type.getClassName(type);
			expr = js_Boot.__instanceof(e,type);
		}
		this.test(expr,p,"Expected " + this.quote(this.value) + " to throw type " + name,"Expected " + this.quote(this.value) + " not to throw type " + name);
	}
	,be: function(expected,p) {
		this.test(this.value == expected,p,"Expected " + this.quote(expected) + ", was " + this.quote(this.value),"Didn't expect " + this.quote(expected) + " but was equal to that");
	}
	,quote: function(v) {
		if(typeof(v) == "string") return "\"" + Std.string(v) + "\""; else return Std.string(v);
	}
	,stackPos: function(p) {
		return [haxe_StackItem.FilePos(null,p.fileName,p.lineNumber)];
	}
	,test: function(expr,p,error,errorInverted) {
		if(!this.inverse) this.assert(expr,error,this.stackPos(p)); else this.assert(!expr,errorInverted,this.stackPos(p));
	}
	,__class__: buddy_ShouldFunctions
};
var buddy_SuitesRunner = function(buddySuites,reporter) {
	var includeMode;
	includeMode = ((function($this) {
		var $r;
		var _g = [];
		var $it0 = $iterator(buddySuites)();
		while( $it0.hasNext() ) {
			var b = $it0.next();
			var _g1_head = b.suites.h;
			var _g1_val = null;
			while(_g1_head != null) {
				var s;
				s = (function($this) {
					var $r;
					_g1_val = _g1_head[0];
					_g1_head = _g1_head[1];
					$r = _g1_val;
					return $r;
				}($this));
				if(s.include) _g.push(s);
			}
		}
		$r = _g;
		return $r;
	}(this))).length > 0;
	var _g1 = [];
	var $it1 = $iterator(buddySuites)();
	while( $it1.hasNext() ) {
		var b1 = $it1.next();
		var _g2_head = b1.suites.h;
		var _g2_val = null;
		while(_g2_head != null) {
			var s1;
			s1 = (function($this) {
				var $r;
				_g2_val = _g2_head[0];
				_g2_head = _g2_head[1];
				$r = _g2_val;
				return $r;
			}(this));
			if(!includeMode || s1.include) _g1.push(s1);
		}
	}
	this.suites = _g1;
	if(reporter == null) this.reporter = new buddy_reporting_ConsoleReporter(); else this.reporter = reporter;
};
$hxClasses["buddy.SuitesRunner"] = buddy_SuitesRunner;
buddy_SuitesRunner.__name__ = ["buddy","SuitesRunner"];
buddy_SuitesRunner.prototype = {
	run: function() {
		var _g = this;
		var def = new promhx_Deferred();
		var defPr = def.promise();
		this.reporter.start().then(function(ok) {
			if(ok) buddy_tools_AsyncTools.iterateAsyncBool(_g.suites,$bind(_g,_g.runSuite)).pipe(function(_) {
				return _g.reporter.done(_g.suites,!_g.failed());
			}).then(function(_1) {
				def.resolve(ok);
			}); else {
				_g.aborted = true;
				def.resolve(ok);
			}
		});
		return defPr;
	}
	,failed: function() {
		var testFail = null;
		testFail = function(s) {
			var failed = false;
			var _g_head = s.steps.h;
			var _g_val = null;
			while(_g_head != null) {
				var step;
				step = (function($this) {
					var $r;
					_g_val = _g_head[0];
					_g_head = _g_head[1];
					$r = _g_val;
					return $r;
				}(this));
				switch(step[1]) {
				case 1:
					var sp = step[2];
					if(sp.status == buddy_TestStatus.Failed) return true;
					break;
				case 0:
					var s2 = step[2];
					if(testFail(s2)) return true;
					break;
				}
			}
			return false;
		};
		var $it0 = $iterator(this.suites)();
		while( $it0.hasNext() ) {
			var s1 = $it0.next();
			if(testFail(s1)) return true;
		}
		return false;
	}
	,statusCode: function() {
		if(this.aborted) return 1;
		if(this.failed()) return 1; else return 0;
	}
	,runSuite: function(suite) {
		return new buddy_internal_SuiteRunner(suite,this.reporter).run();
	}
	,__class__: buddy_SuitesRunner
};
var buddy_internal_SuiteRunner = function(suite,reporter) {
	this.buddySuite = suite.buddySuite;
	this.suite = suite;
	this.reporter = reporter;
};
$hxClasses["buddy.internal.SuiteRunner"] = buddy_internal_SuiteRunner;
buddy_internal_SuiteRunner.__name__ = ["buddy","internal","SuiteRunner"];
buddy_internal_SuiteRunner.prototype = {
	run: function() {
		var _g = this;
		var traceFunc = haxe_Log.trace;
		var def = new promhx_Deferred();
		var pr = def.promise();
		buddy_tools_AsyncTools.iterateAsyncBool(this.suite.steps,$bind(this,this.runSteps)).then(function(_) {
			haxe_Log.trace = traceFunc;
			def.resolve(_g.suite);
		});
		return pr;
	}
	,allBefores: function(suite,list) {
		list = Lambda.concat(suite.before,list);
		if(suite.parent != null) return this.allBefores(suite.parent,list); else return Lambda.concat(this.buddySuite.befores,list);
	}
	,allAfters: function(suite,list) {
		list = Lambda.concat(suite.after,list);
		if(suite.parent != null) return this.allAfters(suite.parent,list);
		list = Lambda.concat(this.buddySuite.afters,list);
		var output = new List();
		var _g_head = list.h;
		var _g_val = null;
		while(_g_head != null) {
			var a;
			a = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			output.push(a);
		}
		return output;
	}
	,runBeforeAfter: function(b) {
		var def = new promhx_Deferred();
		var pr = def.promise();
		var done = function(calledFromSpec) {
			if(calledFromSpec == null) calledFromSpec = false;
			def.resolve(b);
		};
		b.run(done,function(s,err,stack) {
		});
		if(!b.async) done();
		return pr;
	}
	,runSteps: function(step) {
		var stepDone = new promhx_Deferred();
		var stepPr = stepDone.promise();
		switch(step[1]) {
		case 1:
			var spec = step[2];
			this.runSpec(spec).then(function(_) {
				stepDone.resolve(step);
			});
			break;
		case 0:
			var s = step[2];
			new buddy_internal_SuiteRunner(s,this.reporter).run().then(function(_1) {
				stepDone.resolve(step);
			});
			break;
		}
		return stepPr;
	}
	,runSpec: function(spec) {
		var _g = this;
		var specDone = new promhx_Deferred();
		var specPr = specDone.promise();
		specPr.pipe(function(s1) {
			if(_g.reporter != null) return _g.reporter.progress(s1); else return specPr;
		});
		if(spec.status != buddy_TestStatus.Unknown) {
			specDone.resolve(spec);
			return specPr;
		}
		var itDone = new promhx_Deferred();
		var itPromise = itDone.promise();
		var hasStatus = false;
		var status = function(s,error,stack) {
			hasStatus = true;
			if(!s && !itPromise._resolved && !itDone._resolved) itDone.resolve({ status : buddy_TestStatus.Failed, error : error, stack : stack});
		};
		var done = function(calledFromSpec) {
			if(calledFromSpec == null) calledFromSpec = true;
			if(!itPromise._resolved && !itDone._resolved) {
				if(calledFromSpec) hasStatus = true;
				itDone.resolve({ status : hasStatus?buddy_TestStatus.Passed:buddy_TestStatus.Pending, error : null, stack : null});
			}
		};
		haxe_Log.trace = function(v,pos) {
			spec.traces.add(pos.fileName + ":" + pos.lineNumber + ": " + Std.string(v));
		};
		var befores = this.allBefores(this.suite,new List());
		var afters = this.allAfters(this.suite,new List());
		var errorTimeout = null;
		buddy_tools_AsyncTools.iterateAsyncBool(befores,$bind(this,this.runBeforeAfter)).pipe(function(_) {
			if(spec.async) {
				var timeout = _g.buddySuite.timeoutMs;
				errorTimeout = buddy_tools_AsyncTools.wait(timeout);
				errorTimeout.catchError(function(e) {
					if(e != null) throw new js__$Boot_HaxeError(e);
				}).then(function(_1) {
					status(false,"Timeout after " + timeout + " ms",null);
				});
			}
			try {
				spec.run(done,status);
				if(!spec.async) done(false);
			} catch( e1 ) {
				haxe_CallStack.lastException = e1;
				if (e1 instanceof js__$Boot_HaxeError) e1 = e1.val;
				status(false,Std.string(e1),haxe_CallStack.exceptionStack());
			}
			return itPromise;
		}).pipe(function(result) {
			if(errorTimeout != null) {
				errorTimeout.reject(null);
				errorTimeout = null;
			}
			spec.setStatus(result.status,result.error,result.stack);
			return buddy_tools_AsyncTools.iterateAsyncBool(afters,$bind(_g,_g.runBeforeAfter));
		}).then(function(_2) {
			specDone.resolve(spec);
		});
		return specPr;
	}
	,__class__: buddy_internal_SuiteRunner
};
var buddy_internal_sys_Js = function() { };
$hxClasses["buddy.internal.sys.Js"] = buddy_internal_sys_Js;
buddy_internal_sys_Js.__name__ = ["buddy","internal","sys","Js"];
buddy_internal_sys_Js.replaceSpace = function(s) {
	if(window.navigator.userAgent.indexOf("PhantomJS") >= 0) return s;
	return StringTools.replace(s," ","&nbsp;");
};
buddy_internal_sys_Js.print = function(s) {
	var sp;
	var _this = window.document;
	sp = _this.createElement("span");
	sp.innerHTML = buddy_internal_sys_Js.replaceSpace(s);
	window.document.body.appendChild(sp);
};
buddy_internal_sys_Js.println = function(s) {
	var div;
	var _this = window.document;
	div = _this.createElement("div");
	div.innerHTML = buddy_internal_sys_Js.replaceSpace(s);
	window.document.body.appendChild(div);
};
var buddy_reporting_Reporter = function() { };
$hxClasses["buddy.reporting.Reporter"] = buddy_reporting_Reporter;
buddy_reporting_Reporter.__name__ = ["buddy","reporting","Reporter"];
buddy_reporting_Reporter.prototype = {
	__class__: buddy_reporting_Reporter
};
var buddy_reporting_TraceReporter = function() {
};
$hxClasses["buddy.reporting.TraceReporter"] = buddy_reporting_TraceReporter;
buddy_reporting_TraceReporter.__name__ = ["buddy","reporting","TraceReporter"];
buddy_reporting_TraceReporter.__interfaces__ = [buddy_reporting_Reporter];
buddy_reporting_TraceReporter.prototype = {
	start: function() {
		return this.resolveImmediately(true);
	}
	,progress: function(spec) {
		return this.resolveImmediately(spec);
	}
	,done: function(suites,status) {
		var _g = this;
		this.println("");
		var total = 0;
		var failures = 0;
		var pending = 0;
		var countTests = null;
		var printTests = null;
		countTests = function(s) {
			var _g_head = s.steps.h;
			var _g_val = null;
			while(_g_head != null) {
				var sp;
				sp = (function($this) {
					var $r;
					_g_val = _g_head[0];
					_g_head = _g_head[1];
					$r = _g_val;
					return $r;
				}(this));
				switch(sp[1]) {
				case 1:
					var sp1 = sp[2];
					total++;
					if(sp1.status == buddy_TestStatus.Failed) failures++; else if(sp1.status == buddy_TestStatus.Pending) pending++;
					break;
				case 0:
					var s1 = sp[2];
					countTests(s1);
					break;
				}
			}
		};
		Lambda.iter(suites,countTests);
		printTests = function(s2,indentLevel) {
			var print = function(str) {
				_g.println(StringTools.lpad(str," ",str.length + indentLevel * 2));
			};
			print(s2.name);
			var _g_head1 = s2.steps.h;
			var _g_val1 = null;
			while(_g_head1 != null) {
				var step;
				step = (function($this) {
					var $r;
					_g_val1 = _g_head1[0];
					_g_head1 = _g_head1[1];
					$r = _g_val1;
					return $r;
				}(this));
				switch(step[1]) {
				case 1:
					var sp2 = step[2];
					if(sp2.status == buddy_TestStatus.Failed) {
						print("  " + sp2.description + " (FAILED: " + sp2.error + ")");
						_g.printTraces(sp2);
						if(sp2.stack == null || sp2.stack.length == 0) continue;
						var _g1 = 0;
						var _g2 = sp2.stack;
						while(_g1 < _g2.length) {
							var s3 = _g2[_g1];
							++_g1;
							switch(s3[1]) {
							case 2:
								var line = s3[4];
								var file = s3[3];
								if(file.indexOf("buddy/internal/") != 0) print("    @ " + file + ":" + line); else {
								}
								break;
							default:
							}
						}
					} else {
						print("  " + sp2.description + " (" + Std.string(sp2.status) + ")");
						_g.printTraces(sp2);
					}
					break;
				case 0:
					var s4 = step[2];
					printTests(s4,indentLevel + 1);
					break;
				}
			}
		};
		Lambda.iter(suites,(function(f,a2) {
			return function(a1) {
				f(a1,a2);
			};
		})(printTests,0));
		this.println("" + total + " specs, " + failures + " failures, " + pending + " pending");
		return this.resolveImmediately(suites);
	}
	,printTraces: function(spec) {
		var _g_head = spec.traces.h;
		var _g_val = null;
		while(_g_head != null) {
			var t;
			t = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			this.println("    " + t);
		}
	}
	,print: function(s) {
	}
	,println: function(s) {
		haxe_Log.trace(s,{ fileName : "TraceReporter.hx", lineNumber : 105, className : "buddy.reporting.TraceReporter", methodName : "println"});
	}
	,resolveImmediately: function(o) {
		var def = new promhx_Deferred();
		var pr = def.promise();
		def.resolve(o);
		return pr;
	}
	,__class__: buddy_reporting_TraceReporter
};
var buddy_reporting_ConsoleReporter = function() {
	buddy_reporting_TraceReporter.call(this);
};
$hxClasses["buddy.reporting.ConsoleReporter"] = buddy_reporting_ConsoleReporter;
buddy_reporting_ConsoleReporter.__name__ = ["buddy","reporting","ConsoleReporter"];
buddy_reporting_ConsoleReporter.__super__ = buddy_reporting_TraceReporter;
buddy_reporting_ConsoleReporter.prototype = $extend(buddy_reporting_TraceReporter.prototype,{
	start: function() {
		return this.resolveImmediately(true);
	}
	,progress: function(spec) {
		this.print((function($this) {
			var $r;
			var _g = spec.status;
			$r = (function($this) {
				var $r;
				switch(_g[1]) {
				case 3:
					$r = "X";
					break;
				case 1:
					$r = ".";
					break;
				case 2:
					$r = "P";
					break;
				case 0:
					$r = "?";
					break;
				}
				return $r;
			}($this));
			return $r;
		}(this)));
		return this.resolveImmediately(spec);
	}
	,done: function(suites,status) {
		var output = buddy_reporting_TraceReporter.prototype.done.call(this,suites,status);
		return output;
	}
	,print: function(s) {
		buddy_internal_sys_Js.print(s);
	}
	,println: function(s) {
		buddy_internal_sys_Js.println(s);
	}
	,__class__: buddy_reporting_ConsoleReporter
});
var buddy_tools_AsyncTools = function() { };
$hxClasses["buddy.tools.AsyncTools"] = buddy_tools_AsyncTools;
buddy_tools_AsyncTools.__name__ = ["buddy","tools","AsyncTools"];
buddy_tools_AsyncTools.iterateAsyncBool = function(it,action) {
	return buddy_tools_AsyncTools.iterateAsync(it,action,true);
};
buddy_tools_AsyncTools.iterateAsync = function(it,action,resolveWith) {
	var finished = new promhx_Deferred();
	var pr = finished.promise();
	buddy_tools_AsyncTools.next($iterator(it)(),action,finished,resolveWith);
	return pr;
};
buddy_tools_AsyncTools.wait = function(ms) {
	var def = new promhx_Deferred();
	var pr = def.promise();
	var done = function() {
		if(!pr._fulfilled) def.resolve(true);
	};
	haxe_Timer.delay(function() {
		done();
	},ms);
	return pr;
};
buddy_tools_AsyncTools.next = function(it,action,def,resolveWith) {
	if(!it.hasNext()) def.resolve(resolveWith); else {
		var n = it.next();
		action(n).then(function(_) {
			buddy_tools_AsyncTools.next(it,action,def,resolveWith);
		});
	}
};
var haxe_StackItem = $hxClasses["haxe.StackItem"] = { __ename__ : ["haxe","StackItem"], __constructs__ : ["CFunction","Module","FilePos","Method","LocalFunction"] };
haxe_StackItem.CFunction = ["CFunction",0];
haxe_StackItem.CFunction.toString = $estr;
haxe_StackItem.CFunction.__enum__ = haxe_StackItem;
haxe_StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
haxe_StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
haxe_StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
haxe_StackItem.LocalFunction = function(v) { var $x = ["LocalFunction",4,v]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
var haxe_CallStack = function() { };
$hxClasses["haxe.CallStack"] = haxe_CallStack;
haxe_CallStack.__name__ = ["haxe","CallStack"];
haxe_CallStack.lastException = null;
haxe_CallStack.getStack = function(e) {
	if(e == null) return [];
	var oldValue = Error.prepareStackTrace;
	Error.prepareStackTrace = function(error,callsites) {
		var stack = [];
		var _g = 0;
		while(_g < callsites.length) {
			var site = callsites[_g];
			++_g;
			if(haxe_CallStack.wrapCallSite != null) site = haxe_CallStack.wrapCallSite(site);
			var method = null;
			var fullName = site.getFunctionName();
			if(fullName != null) {
				var idx = fullName.lastIndexOf(".");
				if(idx >= 0) {
					var className = HxOverrides.substr(fullName,0,idx);
					var methodName = HxOverrides.substr(fullName,idx + 1,null);
					method = haxe_StackItem.Method(className,methodName);
				}
			}
			stack.push(haxe_StackItem.FilePos(method,site.getFileName(),site.getLineNumber()));
		}
		return stack;
	};
	var a = haxe_CallStack.makeStack(e.stack);
	Error.prepareStackTrace = oldValue;
	return a;
};
haxe_CallStack.wrapCallSite = null;
haxe_CallStack.exceptionStack = function() {
	return haxe_CallStack.getStack(haxe_CallStack.lastException);
};
haxe_CallStack.makeStack = function(s) {
	if(s == null) return []; else if(typeof(s) == "string") {
		var stack = s.split("\n");
		if(stack[0] == "Error") stack.shift();
		var m = [];
		var rie10 = new EReg("^   at ([A-Za-z0-9_. ]+) \\(([^)]+):([0-9]+):([0-9]+)\\)$","");
		var _g = 0;
		while(_g < stack.length) {
			var line = stack[_g];
			++_g;
			if(rie10.match(line)) {
				var path = rie10.matched(1).split(".");
				var meth = path.pop();
				var file = rie10.matched(2);
				var line1 = Std.parseInt(rie10.matched(3));
				m.push(haxe_StackItem.FilePos(meth == "Anonymous function"?haxe_StackItem.LocalFunction():meth == "Global code"?null:haxe_StackItem.Method(path.join("."),meth),file,line1));
			} else m.push(haxe_StackItem.Module(StringTools.trim(line)));
		}
		return m;
	} else return s;
};
var haxe_IMap = function() { };
$hxClasses["haxe.IMap"] = haxe_IMap;
haxe_IMap.__name__ = ["haxe","IMap"];
var haxe_Log = function() { };
$hxClasses["haxe.Log"] = haxe_Log;
haxe_Log.__name__ = ["haxe","Log"];
haxe_Log.trace = function(v,infos) {
	js_Boot.__trace(v,infos);
};
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
$hxClasses["haxe.Timer"] = haxe_Timer;
haxe_Timer.__name__ = ["haxe","Timer"];
haxe_Timer.delay = function(f,time_ms) {
	var t = new haxe_Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe_Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe_Timer
};
var haxe_ds_Option = $hxClasses["haxe.ds.Option"] = { __ename__ : ["haxe","ds","Option"], __constructs__ : ["Some","None"] };
haxe_ds_Option.Some = function(v) { var $x = ["Some",0,v]; $x.__enum__ = haxe_ds_Option; $x.toString = $estr; return $x; };
haxe_ds_Option.None = ["None",1];
haxe_ds_Option.None.toString = $estr;
haxe_ds_Option.None.__enum__ = haxe_ds_Option;
var haxe_ds__$StringMap_StringMapIterator = function(map,keys) {
	this.map = map;
	this.keys = keys;
	this.index = 0;
	this.count = keys.length;
};
$hxClasses["haxe.ds._StringMap.StringMapIterator"] = haxe_ds__$StringMap_StringMapIterator;
haxe_ds__$StringMap_StringMapIterator.__name__ = ["haxe","ds","_StringMap","StringMapIterator"];
haxe_ds__$StringMap_StringMapIterator.prototype = {
	hasNext: function() {
		return this.index < this.count;
	}
	,next: function() {
		return this.map.get(this.keys[this.index++]);
	}
	,__class__: haxe_ds__$StringMap_StringMapIterator
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.StringMap"] = haxe_ds_StringMap;
haxe_ds_StringMap.__name__ = ["haxe","ds","StringMap"];
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	set: function(key,value) {
		if(__map_reserved[key] != null) this.setReserved(key,value); else this.h[key] = value;
	}
	,get: function(key) {
		if(__map_reserved[key] != null) return this.getReserved(key);
		return this.h[key];
	}
	,exists: function(key) {
		if(__map_reserved[key] != null) return this.existsReserved(key);
		return this.h.hasOwnProperty(key);
	}
	,setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) return null; else return this.rh["$" + key];
	}
	,existsReserved: function(key) {
		if(this.rh == null) return false;
		return this.rh.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		if(__map_reserved[key] != null) {
			key = "$" + key;
			if(this.rh == null || !this.rh.hasOwnProperty(key)) return false;
			delete(this.rh[key]);
			return true;
		} else {
			if(!this.h.hasOwnProperty(key)) return false;
			delete(this.h[key]);
			return true;
		}
	}
	,keys: function() {
		var _this = this.arrayKeys();
		return HxOverrides.iter(_this);
	}
	,arrayKeys: function() {
		var out = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) out.push(key);
		}
		if(this.rh != null) {
			for( var key in this.rh ) {
			if(key.charCodeAt(0) == 36) out.push(key.substr(1));
			}
		}
		return out;
	}
	,__class__: haxe_ds_StringMap
};
var haxe_rtti_Meta = function() { };
$hxClasses["haxe.rtti.Meta"] = haxe_rtti_Meta;
haxe_rtti_Meta.__name__ = ["haxe","rtti","Meta"];
haxe_rtti_Meta.getType = function(t) {
	var meta = haxe_rtti_Meta.getMeta(t);
	if(meta == null || meta.obj == null) return { }; else return meta.obj;
};
haxe_rtti_Meta.getMeta = function(t) {
	return t.__meta__;
};
haxe_rtti_Meta.getFields = function(t) {
	var meta = haxe_rtti_Meta.getMeta(t);
	if(meta == null || meta.fields == null) return { }; else return meta.fields;
};
var iv247_intravenous_Context = function(mainView,autostart) {
	if(autostart == null) autostart = true;
	this.app = mainView;
	if(autostart) this.initialize();
};
$hxClasses["iv247.intravenous.Context"] = iv247_intravenous_Context;
iv247_intravenous_Context.__name__ = ["iv247","intravenous","Context"];
iv247_intravenous_Context.prototype = {
	initialize: function() {
		if(this.injector == null) this.injector = new iv247_intravenous_ioc_IV();
		this.configureMessaging();
		this.initialized = true;
	}
	,configureMessaging: function() {
		this.messageProcessor = new iv247_intravenous_messaging_MessageProcessor(this.injector);
		this.injector.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_messaging_MessageProcessor),this.messageProcessor);
		iv247_intravenous_ioc_IV.addExtension("dispatcher",iv247_intravenous_messaging_MessageProcessor.getDispatcher);
		iv247_intravenous_ioc_IV.addExtension("command",($_=this.messageProcessor,$bind($_,$_.processMeta)));
	}
	,mapCommand: function(commandClass) {
		this.messageProcessor.mapCommand(commandClass);
	}
	,mapView: function(view,mediator) {
	}
	,__class__: iv247_intravenous_Context
};
var iv247_intravenous_ContextSpec = function() {
	var _g = this;
	buddy_BuddySuite.call(this);
	var context;
	this.describe("Context",function() {
		_g.syncBefore(function(__asyncDone,__status) {
			context = null;
		});
		_g.syncIt("should initialize on instantiation by default",function(__asyncDone1,__status1) {
			context = new iv247_intravenous_Context();
			buddy_ShouldDynamic.should(context.initialized,__status1).be(true,{ fileName : "ContextSpec.hx", lineNumber : 19, className : "iv247.intravenous.ContextSpec", methodName : "new"});
		});
		_g.syncIt("should not initialize on instantiation",function(__asyncDone2,__status2) {
			context = new iv247_intravenous_Context(null,false);
			buddy_ShouldDynamic.should(context.initialized,__status2).get_not().be(true,{ fileName : "ContextSpec.hx", lineNumber : 24, className : "iv247.intravenous.ContextSpec", methodName : "new"});
		});
	});
};
$hxClasses["iv247.intravenous.ContextSpec"] = iv247_intravenous_ContextSpec;
iv247_intravenous_ContextSpec.__name__ = ["iv247","intravenous","ContextSpec"];
iv247_intravenous_ContextSpec.__super__ = buddy_BuddySuite;
iv247_intravenous_ContextSpec.prototype = $extend(buddy_BuddySuite.prototype,{
	__class__: iv247_intravenous_ContextSpec
});
var iv247_intravenous_ioc_ChildInjectorSpec = function() {
	var _g = this;
	buddy_BuddySuite.call(this);
	this.describe("Child injectors",function() {
		var iv;
		var setParent;
		setParent = function(parent,child) {
			child.set_parent(parent);
		};
		_g.syncBefore(function(__asyncDone,__status) {
			iv = new iv247_intravenous_ioc_IV();
		});
		_g.syncIt("should optionally add a parent injector through it's constructor",function(__asyncDone1,__status1) {
			var childInjector = new iv247_intravenous_ioc_IV(iv);
			buddy_ShouldDynamic.should(childInjector.parent,__status1).be(iv,{ fileName : "ChildInjectorSpec.hx", lineNumber : 25, className : "iv247.intravenous.ioc.ChildInjectorSpec", methodName : "new"});
		});
		_g.syncIt("should assign a parent injector through it's accessor",function(__asyncDone2,__status2) {
			var childInjector1 = new iv247_intravenous_ioc_IV();
			childInjector1.set_parent(iv);
			buddy_ShouldDynamic.should(childInjector1.parent,__status2).be(iv,{ fileName : "ChildInjectorSpec.hx", lineNumber : 31, className : "iv247.intravenous.ioc.ChildInjectorSpec", methodName : "new"});
		});
		_g.syncIt("should throw an error if the parent wants to be it's own child (circular reference)",function(__asyncDone3,__status3) {
			buddy_ShouldFunctions.should((function(f,a1,a2) {
				return function() {
					f(a1,a2);
				};
			})(setParent,iv,iv),__status3).throwType(String,{ fileName : "ChildInjectorSpec.hx", lineNumber : 35, className : "iv247.intravenous.ioc.ChildInjectorSpec", methodName : "new"});
		});
		_g.syncIt("should throw an error if a parent wants to be a child (circular reference)",function(__asyncDone4,__status4) {
			var childInjector2 = new iv247_intravenous_ioc_IV(iv);
			buddy_ShouldFunctions.should((function(f1,a11,a21) {
				return function() {
					f1(a11,a21);
				};
			})(setParent,childInjector2,iv),__status4).throwType(String,{ fileName : "ChildInjectorSpec.hx", lineNumber : 40, className : "iv247.intravenous.ioc.ChildInjectorSpec", methodName : "new"});
		});
		_g.syncIt("should allow removal of their parent",function(__asyncDone5,__status5) {
			var childInjector3 = new iv247_intravenous_ioc_IV();
			childInjector3.set_parent(iv);
			childInjector3.set_parent(null);
			buddy_ShouldDynamic.should(childInjector3.parent,__status5).be(null,{ fileName : "ChildInjectorSpec.hx", lineNumber : 48, className : "iv247.intravenous.ioc.ChildInjectorSpec", methodName : "new"});
		});
		_g.syncIt("should return mapped objects from their parents if child mapping doesn't exist",function(__asyncDone6,__status6) {
			var object = new iv247_intravenous_ioc_mock_InjectionMock();
			var childInjector4 = new iv247_intravenous_ioc_IV(iv);
			var result;
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock),object);
			result = childInjector4.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock));
			buddy_ShouldDynamic.should(object,__status6).be(result,{ fileName : "ChildInjectorSpec.hx", lineNumber : 58, className : "iv247.intravenous.ioc.ChildInjectorSpec", methodName : "new"});
		});
		_g.syncIt("should not return objects mapped on parent if child mapping exists",function(__asyncDone7,__status7) {
			var object1 = new iv247_intravenous_ioc_mock_InjectionMock();
			var childMappedObject = new iv247_intravenous_ioc_mock_InjectionMock();
			var childInjector5 = new iv247_intravenous_ioc_IV(iv);
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock),object1);
			childInjector5.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock),childMappedObject);
			buddy_ShouldDynamic.should(object1,__status7).get_not().be(childInjector5.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock)),{ fileName : "ChildInjectorSpec.hx", lineNumber : 70, className : "iv247.intravenous.ioc.ChildInjectorSpec", methodName : "new"});
			buddy_ShouldDynamic.should(childMappedObject,__status7).be(childInjector5.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock)),{ fileName : "ChildInjectorSpec.hx", lineNumber : 71, className : "iv247.intravenous.ioc.ChildInjectorSpec", methodName : "new"});
		});
		_g.syncIt("should return null on unmapped object on parent and child",function(__asyncDone8,__status8) {
			var childInjector6 = new iv247_intravenous_ioc_IV(iv);
			var result1 = new iv247_intravenous_ioc_mock_InjectionMock();
			result1 = childInjector6.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock));
			buddy_ShouldDynamic.should(result1,__status8).be(null,{ fileName : "ChildInjectorSpec.hx", lineNumber : 79, className : "iv247.intravenous.ioc.ChildInjectorSpec", methodName : "new"});
		});
	});
};
$hxClasses["iv247.intravenous.ioc.ChildInjectorSpec"] = iv247_intravenous_ioc_ChildInjectorSpec;
iv247_intravenous_ioc_ChildInjectorSpec.__name__ = ["iv247","intravenous","ioc","ChildInjectorSpec"];
iv247_intravenous_ioc_ChildInjectorSpec.__super__ = buddy_BuddySuite;
iv247_intravenous_ioc_ChildInjectorSpec.prototype = $extend(buddy_BuddySuite.prototype,{
	__class__: iv247_intravenous_ioc_ChildInjectorSpec
});
var iv247_intravenous_ioc_EnumSupportSpec = function() {
	var _g = this;
	buddy_BuddySuite.call(this);
	var iv;
	this.syncBeforeDescribe(function(__asyncDone,__status) {
		iv = new iv247_intravenous_ioc_IV();
	});
	this.describe("Enums",function() {
		_g.syncIt("should be mapped by type",function(__asyncDone1,__status1) {
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum),iv247_intravenous_ioc_mock_MockEnum.MockEnumValue);
			buddy_ShouldDynamic.should(iv.hasMapping(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum)),__status1).be(true,{ fileName : "EnumSupportSpec.hx", lineNumber : 22, className : "iv247.intravenous.ioc.EnumSupportSpec", methodName : "new"});
		});
		_g.syncIt("should umap enums",function(__asyncDone2,__status2) {
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum),iv247_intravenous_ioc_mock_MockEnum.MockEnumValue);
			iv.unmap(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum));
			buddy_ShouldDynamic.should(iv.hasMapping(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum)),__status2).be(false,{ fileName : "EnumSupportSpec.hx", lineNumber : 28, className : "iv247.intravenous.ioc.EnumSupportSpec", methodName : "new"});
		});
		_g.syncIt("should create an enum value without constructor",function(__asyncDone3,__status3) {
			var mockEnum = iv.instantiate(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum),"MockEnumValue");
			buddy_ShouldDynamic.should(mockEnum,__status3).be(iv247_intravenous_ioc_mock_MockEnum.MockEnumValue,{ fileName : "EnumSupportSpec.hx", lineNumber : 33, className : "iv247.intravenous.ioc.EnumSupportSpec", methodName : "new"});
		});
		_g.syncIt("should create enum and inject constructor values",function(__asyncDone4,__status4) {
			var obj1 = new iv247_intravenous_ioc_mock_InjectedObject();
			var mockEnum1;
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),obj1,"injectedObjectId");
			iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject));
			mockEnum1 = iv.instantiate(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum),"MockEnumCtor");
			switch(mockEnum1[1]) {
			case 1:
				var i3 = mockEnum1[4];
				var i2 = mockEnum1[3];
				var i1 = mockEnum1[2];
				buddy_ShouldDynamic.should(i1,__status4).be(obj1,{ fileName : "EnumSupportSpec.hx", lineNumber : 47, className : "iv247.intravenous.ioc.EnumSupportSpec", methodName : "new"});
				buddy_ShouldDynamic.should(js_Boot.__instanceof(i2,iv247_intravenous_ioc_mock_InjectedObject),__status4).be(true,{ fileName : "EnumSupportSpec.hx", lineNumber : 48, className : "iv247.intravenous.ioc.EnumSupportSpec", methodName : "new"});
				buddy_ShouldDynamic.should(i3,__status4).be(null,{ fileName : "EnumSupportSpec.hx", lineNumber : 49, className : "iv247.intravenous.ioc.EnumSupportSpec", methodName : "new"});
				break;
			default:
				throw new js__$Boot_HaxeError("enum not matched");
			}
		});
		_g.syncIt("should be injected into objects that have enum anotated with inject",function(__asyncDone5,__status5) {
			var mockEnum2;
			var injectionMockWithEnum;
			var mockEnumWCtor;
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum),iv247_intravenous_ioc_mock_MockEnum.MockEnumValue);
			iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMockWEnum),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMockWEnum));
			iv.mapSingleton(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum),"injectEnumCtorId","MockEnumCtor");
			injectionMockWithEnum = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMockWEnum));
			mockEnumWCtor = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum),"injectEnumCtorId");
			buddy_ShouldDynamic.should(injectionMockWithEnum.enumCtor,__status5).be(mockEnumWCtor,{ fileName : "EnumSupportSpec.hx", lineNumber : 66, className : "iv247.intravenous.ioc.EnumSupportSpec", methodName : "new"});
			buddy_ShouldDynamic.should(js_Boot.__instanceof(injectionMockWithEnum.enumValue,iv247_intravenous_ioc_mock_MockEnum),__status5).be(true,{ fileName : "EnumSupportSpec.hx", lineNumber : 67, className : "iv247.intravenous.ioc.EnumSupportSpec", methodName : "new"});
		});
		_g.syncIt("should inject enums into class constructors",function(__asyncDone6,__status6) {
			var injectionMockWithEnum1;
			var mockEnumWCtor1;
			iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMockWEnum),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMockWEnum));
			iv.mapSingleton(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum),"injectEnumCtorId","MockEnumCtor");
			injectionMockWithEnum1 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMockWEnum));
			mockEnumWCtor1 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockEnum),"injectEnumCtorId");
			buddy_ShouldDynamic.should(injectionMockWithEnum1.enumCtor,__status6).be(mockEnumWCtor1,{ fileName : "EnumSupportSpec.hx", lineNumber : 79, className : "iv247.intravenous.ioc.EnumSupportSpec", methodName : "new"});
		});
	});
};
$hxClasses["iv247.intravenous.ioc.EnumSupportSpec"] = iv247_intravenous_ioc_EnumSupportSpec;
iv247_intravenous_ioc_EnumSupportSpec.__name__ = ["iv247","intravenous","ioc","EnumSupportSpec"];
iv247_intravenous_ioc_EnumSupportSpec.__super__ = buddy_BuddySuite;
iv247_intravenous_ioc_EnumSupportSpec.prototype = $extend(buddy_BuddySuite.prototype,{
	__class__: iv247_intravenous_ioc_EnumSupportSpec
});
var iv247_intravenous_ioc_ExtensionSpec = function() {
	var _g = this;
	buddy_BuddySuite.call(this);
	this.describe("Extension functionality",function() {
		var iv;
		var extensionDef;
		var extensionMethodDef;
		var callCount = 0;
		var extFn = function(extDef) {
			callCount++;
			extensionDef = extDef;
		};
		var extFn2 = function(extDef1) {
			extensionMethodDef = extDef1;
		};
		iv247_intravenous_ioc_IV.addExtension("extension",extFn);
		iv247_intravenous_ioc_IV.addExtension("extensionMethod",extFn2);
		iv = new iv247_intravenous_ioc_IV();
		_g.syncBefore(function(__asyncDone,__status) {
			callCount = 0;
			extensionDef = null;
			extensionMethodDef = null;
			iv = new iv247_intravenous_ioc_IV();
		});
		_g.syncIt("should call the extension's method for each annotated property of an instance",function(__asyncDone1,__status1) {
			var mock = new iv247_intravenous_ioc_mock_MockExtensionObject();
			iv.injectInto(mock);
			buddy_ShouldString.should(extensionDef.metaname,__status1).be("extension",{ fileName : "ExtensionSpec.hx", lineNumber : 41, className : "iv247.intravenous.ioc.ExtensionSpec", methodName : "new"});
			buddy_ShouldDynamic.should(extensionDef.type,__status1).be(iv247_intravenous_ioc_ExtensionType.Property,{ fileName : "ExtensionSpec.hx", lineNumber : 42, className : "iv247.intravenous.ioc.ExtensionSpec", methodName : "new"});
			buddy_ShouldString.should(extensionMethodDef.metaname,__status1).be("extensionMethod",{ fileName : "ExtensionSpec.hx", lineNumber : 43, className : "iv247.intravenous.ioc.ExtensionSpec", methodName : "new"});
			buddy_ShouldDynamic.should(extensionMethodDef.type,__status1).be(iv247_intravenous_ioc_ExtensionType.Property,{ fileName : "ExtensionSpec.hx", lineNumber : 44, className : "iv247.intravenous.ioc.ExtensionSpec", methodName : "new"});
			buddy_ShouldFloat.should(callCount,__status1).be(2,{ fileName : "ExtensionSpec.hx", lineNumber : 45, className : "iv247.intravenous.ioc.ExtensionSpec", methodName : "new"});
		});
		_g.syncIt("should call the extension's method if method being called is annotated",function(__asyncDone2,__status2) {
			var mock1 = new iv247_intravenous_ioc_mock_MockExtensionObject();
			var methodDef;
			iv.call("mockMethod",mock1);
			buddy_ShouldString.should(extensionMethodDef.metaname,__status2).be("extensionMethod",{ fileName : "ExtensionSpec.hx", lineNumber : 53, className : "iv247.intravenous.ioc.ExtensionSpec", methodName : "new"});
			buddy_ShouldDynamic.should(extensionMethodDef.type,__status2).be(iv247_intravenous_ioc_ExtensionType.Method,{ fileName : "ExtensionSpec.hx", lineNumber : 54, className : "iv247.intravenous.ioc.ExtensionSpec", methodName : "new"});
		});
		_g.syncIt("should call the extensions's method if the constructor is annotated",function(__asyncDone3,__status3) {
			iv.instantiate(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockCtorExtensionObject));
			buddy_ShouldString.should(extensionDef.metaname,__status3).be("extension",{ fileName : "ExtensionSpec.hx", lineNumber : 59, className : "iv247.intravenous.ioc.ExtensionSpec", methodName : "new"});
			buddy_ShouldDynamic.should(extensionDef.type,__status3).be(iv247_intravenous_ioc_ExtensionType.Constructor,{ fileName : "ExtensionSpec.hx", lineNumber : 60, className : "iv247.intravenous.ioc.ExtensionSpec", methodName : "new"});
		});
	});
};
$hxClasses["iv247.intravenous.ioc.ExtensionSpec"] = iv247_intravenous_ioc_ExtensionSpec;
iv247_intravenous_ioc_ExtensionSpec.__name__ = ["iv247","intravenous","ioc","ExtensionSpec"];
iv247_intravenous_ioc_ExtensionSpec.__super__ = buddy_BuddySuite;
iv247_intravenous_ioc_ExtensionSpec.prototype = $extend(buddy_BuddySuite.prototype,{
	__class__: iv247_intravenous_ioc_ExtensionSpec
});
var iv247_intravenous_ioc_ExtensionType = $hxClasses["iv247.intravenous.ioc.ExtensionType"] = { __ename__ : ["iv247","intravenous","ioc","ExtensionType"], __constructs__ : ["Constructor","Method","Property"] };
iv247_intravenous_ioc_ExtensionType.Constructor = ["Constructor",0];
iv247_intravenous_ioc_ExtensionType.Constructor.toString = $estr;
iv247_intravenous_ioc_ExtensionType.Constructor.__enum__ = iv247_intravenous_ioc_ExtensionType;
iv247_intravenous_ioc_ExtensionType.Method = ["Method",1];
iv247_intravenous_ioc_ExtensionType.Method.toString = $estr;
iv247_intravenous_ioc_ExtensionType.Method.__enum__ = iv247_intravenous_ioc_ExtensionType;
iv247_intravenous_ioc_ExtensionType.Property = ["Property",2];
iv247_intravenous_ioc_ExtensionType.Property.toString = $estr;
iv247_intravenous_ioc_ExtensionType.Property.__enum__ = iv247_intravenous_ioc_ExtensionType;
var iv247_intravenous_ioc_IInjector = function() { };
$hxClasses["iv247.intravenous.ioc.IInjector"] = iv247_intravenous_ioc_IInjector;
iv247_intravenous_ioc_IInjector.__name__ = ["iv247","intravenous","ioc","IInjector"];
iv247_intravenous_ioc_IInjector.prototype = {
	__class__: iv247_intravenous_ioc_IInjector
};
var iv247_intravenous_ioc_IV = function(parentInjector) {
	this.injectionMap = new haxe_ds_StringMap();
	this.set_parent(parentInjector);
};
$hxClasses["iv247.intravenous.ioc.IV"] = iv247_intravenous_ioc_IV;
iv247_intravenous_ioc_IV.__name__ = ["iv247","intravenous","ioc","IV"];
iv247_intravenous_ioc_IV.__interfaces__ = [iv247_intravenous_ioc_IInjector];
iv247_intravenous_ioc_IV.extensionMap = null;
iv247_intravenous_ioc_IV.addExtension = function(metaname,func) {
	if(iv247_intravenous_ioc_IV.extensionMap == null) iv247_intravenous_ioc_IV.extensionMap = new haxe_ds_StringMap();
	iv247_intravenous_ioc_IV.extensionMap.set(metaname,func);
};
iv247_intravenous_ioc_IV.removeExtension = function(metaname) {
	iv247_intravenous_ioc_IV.extensionMap.remove(metaname);
};
iv247_intravenous_ioc_IV.prototype = {
	set_parent: function(value) {
		if(value == null) this.parent = value; else if(value.parent == this || this == value) throw new js__$Boot_HaxeError("Circular reference"); else this.parent = value;
		return value;
	}
	,mapValue: function(whenType,value,id) {
		if(id == null) id = "";
		var key = iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.getName(whenType) + id;
		var value1 = iv247_intravenous_ioc_Injection.Value(value);
		this.injectionMap.set(key,value1);
	}
	,mapDynamic: function(whenType,createType,id,constr) {
		if(id == null) id = "";
		var key = iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.getName(whenType) + id;
		var value = iv247_intravenous_ioc_Injection.DynamicObject(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(createType),constr);
		this.injectionMap.set(key,value);
	}
	,mapSingleton: function(whenType,getInstance,id,constr) {
		if(id == null) id = "";
		var key = iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.getName(whenType) + id;
		var value = iv247_intravenous_ioc_Injection.Singleton(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(whenType),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(getInstance),constr);
		this.injectionMap.set(key,value);
	}
	,hasMapping: function(type,id) {
		if(id == null) id = "";
		var key = iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.getName(type) + id;
		return this.injectionMap.exists(key);
	}
	,unmap: function(type,id) {
		if(id == null) id = "";
		var key = iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.getName(type) + id;
		this.injectionMap.remove(key);
	}
	,getInstance: function(type,id) {
		if(id == null) id = "";
		var injection = iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.getName(type) + id;
		var instance;
		var newInstance;
		if(!this.injectionMap.exists(injection)) if(this.parent != null) return this.parent.getInstance(type,id); else return null;
		{
			var _g = this.injectionMap.get(injection);
			switch(_g[1]) {
			case 0:
				var object = _g[2];
				instance = object;
				break;
			case 1:
				var ctor = _g[3];
				var type1 = _g[2];
				instance = this.instantiate(type1,ctor);
				break;
			case 2:
				var ctor1 = _g[4];
				var instanceType = _g[3];
				var type2 = _g[2];
				newInstance = this.instantiate(instanceType,ctor1);
				this.mapValue(type2,newInstance,id);
				instance = newInstance;
				break;
			}
		}
		return instance;
	}
	,instantiate: function(type,constr) {
		var meta = haxe_rtti_Meta.getFields(type);
		var ctorMeta = null;
		var args;
		var injectIds;
		var instance;
		var instanceType;
		var enumInstanceType;
		var id;
		if(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.isClass(type)) ctorMeta = meta._; else ctorMeta = this.getFieldMeta(meta,constr);
		args = this.getMethodArgInstances(ctorMeta);
		instance = iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.instantiate(type,args,constr);
		if(ctorMeta != null) this.callExtensions(ctorMeta,instance,iv247_intravenous_ioc_ExtensionType.Constructor);
		if(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.isClass(type)) this.injectInto(instance);
		return instance;
	}
	,injectInto: function(object) {
		var targetType;
		var type = Type.getClass(object);
		var fields;
		var metaField;
		var instanceId;
		var instance;
		var isFunction;
		var postMethods = new haxe_ds_StringMap();
		while(type != null) {
			fields = haxe_rtti_Meta.getFields(type);
			var _g = 0;
			var _g1 = Reflect.fields(fields);
			while(_g < _g1.length) {
				var field = _g1[_g];
				++_g;
				if(field == "_") continue;
				isFunction = Reflect.isFunction(Reflect.field(object,field));
				metaField = this.getFieldMeta(fields,field);
				if(isFunction) {
					if(Object.prototype.hasOwnProperty.call(metaField,"post") && !(__map_reserved[field] != null?postMethods.existsReserved(field):postMethods.h.hasOwnProperty(field))) postMethods.set(field,{ methodName : field, metaList : metaField, ids : metaField.post});
				} else {
					targetType = iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromString(Std.string(metaField.types[0]));
					if(metaField.inject != null) instanceId = metaField.inject[0]; else instanceId = "";
					instance = this.getInstance(targetType,instanceId);
					object[field] = instance;
				}
				this.callExtensions(metaField,object,iv247_intravenous_ioc_ExtensionType.Property,field);
			}
			type = Type.getSuperClass(type);
		}
		var $it0 = new haxe_ds__$StringMap_StringMapIterator(postMethods,postMethods.arrayKeys());
		while( $it0.hasNext() ) {
			var postMethod = $it0.next();
			this.callMethod(postMethod.metaList,postMethod.methodName,object,postMethod.ids);
		}
	}
	,getFieldMeta: function(meta,fieldName) {
		return Reflect.field(meta,fieldName);
	}
	,call: function(methodName,object) {
		var fields = haxe_rtti_Meta.getFields(Type.getClass(object));
		var metaList = Reflect.field(fields,methodName);
		var types = metaList.types;
		var result;
		result = this.callMethod(metaList,methodName,object);
		this.callExtensions(metaList,object,iv247_intravenous_ioc_ExtensionType.Method,methodName);
		return result;
	}
	,callMethod: function(metaList,methodName,object,ids) {
		var types = metaList.types;
		var args;
		var newInstance;
		var id;
		var result;
		args = this.getMethodArgInstances(metaList,ids);
		result = Reflect.callMethod(object,Reflect.field(object,methodName),args);
		this.callExtensions(metaList,object,iv247_intravenous_ioc_ExtensionType.Method);
		return result;
	}
	,getMethodArgInstances: function(meta,ids) {
		var id;
		var args = [];
		var instanceType;
		var instance;
		if(meta != null && meta.types != null) {
			if(ids == null) if(meta.inject == null) ids = []; else ids = meta.inject;
			var _g = 0;
			var _g1 = meta.types;
			while(_g < _g1.length) {
				var type = _g1[_g];
				++_g;
				id = ids[args.length];
				instanceType = iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromString(Std.string(type.type));
				instance = this.getInstance(instanceType,id);
				args.push(instance);
			}
		}
		return args;
	}
	,callExtensions: function(meta,object,extensionType,fieldName) {
		var $it0 = iv247_intravenous_ioc_IV.extensionMap.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			if(Object.prototype.hasOwnProperty.call(meta,key)) iv247_intravenous_ioc_IV.extensionMap.get(key)({ meta : meta, injector : this, metaname : key, object : object, type : extensionType, field : fieldName});
		}
	}
	,__class__: iv247_intravenous_ioc_IV
};
var iv247_intravenous_ioc_Injection = $hxClasses["iv247.intravenous.ioc.Injection"] = { __ename__ : ["iv247","intravenous","ioc","Injection"], __constructs__ : ["Value","DynamicObject","Singleton"] };
iv247_intravenous_ioc_Injection.Value = function(v) { var $x = ["Value",0,v]; $x.__enum__ = iv247_intravenous_ioc_Injection; $x.toString = $estr; return $x; };
iv247_intravenous_ioc_Injection.DynamicObject = function(t,ctor) { var $x = ["DynamicObject",1,t,ctor]; $x.__enum__ = iv247_intravenous_ioc_Injection; $x.toString = $estr; return $x; };
iv247_intravenous_ioc_Injection.Singleton = function(t,it,ctor) { var $x = ["Singleton",2,t,it,ctor]; $x.__enum__ = iv247_intravenous_ioc_Injection; $x.toString = $estr; return $x; };
var iv247_intravenous_ioc_InjectionsSpec = function() {
	var _g = this;
	buddy_BuddySuite.call(this);
	this.describe("IInjector implementation",function() {
		var iv;
		_g.syncBefore(function(__asyncDone,__status) {
			iv = new iv247_intravenous_ioc_IV();
		});
		_g.syncIt("should instantiate objects",function(__asyncDone1,__status1) {
			iv247_intravenous_ioc_mock_Foo.instantiated = false;
			iv.instantiate(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_Foo));
			buddy_ShouldDynamic.should(iv247_intravenous_ioc_mock_Foo.instantiated,__status1).be(true,{ fileName : "InjectionsSpec.hx", lineNumber : 22, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
		});
		_g.syncIt("should instantiate objects with constructor args when constructor is annotated with inject",function(__asyncDone2,__status2) {
			var object;
			iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject));
			object = iv.instantiate(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockConstructorArg));
			buddy_ShouldDynamic.should(object.mock,__status2).get_not().be(null,{ fileName : "InjectionsSpec.hx", lineNumber : 32, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
		});
		_g.syncIt("should use injections id's if available for constructor args",function(__asyncDone3,__status3) {
			var mock1;
			var mock2;
			var object1;
			iv.mapSingleton(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),"mockId");
			iv.mapSingleton(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),"mockId2");
			mock1 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),"mockId");
			mock2 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),"mockId2");
			object1 = iv.instantiate(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_WithId));
			buddy_ShouldDynamic.should(object1.mockWithId,__status3).be(mock1,{ fileName : "InjectionsSpec.hx", lineNumber : 46, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
			buddy_ShouldDynamic.should(object1.mockWithId2,__status3).be(mock2,{ fileName : "InjectionsSpec.hx", lineNumber : 47, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
			buddy_ShouldDynamic.should(object1.noId,__status3).be(null,{ fileName : "InjectionsSpec.hx", lineNumber : 48, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
		});
		_g.syncIt("should inject 'inject' annotated properties on an object if mapping exists",function(__asyncDone4,__status4) {
			var object2 = new iv247_intravenous_ioc_mock_InjectionMock();
			iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject));
			iv.injectInto(object2);
			buddy_ShouldDynamic.should(object2.injectedObject,__status4).get_not().be(null,{ fileName : "InjectionsSpec.hx", lineNumber : 57, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
			buddy_ShouldDynamic.should(object2.injectedObjectWithId,__status4).be(null,{ fileName : "InjectionsSpec.hx", lineNumber : 59, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
		});
		_g.syncIt("should inject 'inject' annotated properties with an id",function(__asyncDone5,__status5) {
			var object3 = new iv247_intravenous_ioc_mock_InjectionMock();
			iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),"injectedObjectId");
			iv.injectInto(object3);
			buddy_ShouldDynamic.should(object3.injectedObjectWithId,__status5).get_not().be(null,{ fileName : "InjectionsSpec.hx", lineNumber : 68, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
		});
		_g.syncIt("should inject 'injected' annotated properties defined on a super class",function(__asyncDone6,__status6) {
			var subclass = new iv247_intravenous_ioc_mock_SubClassInjectionMock();
			iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject));
			iv.injectInto(subclass);
			buddy_ShouldDynamic.should(subclass.injectedObject,__status6).get_not().be(null,{ fileName : "InjectionsSpec.hx", lineNumber : 78, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
		});
		_g.describe("calling inject annotated methods",function() {
			_g.syncIt("should have arguments injected",function(__asyncDone7,__status7) {
				var injectedObject = new iv247_intravenous_ioc_mock_InjectedObject();
				var object4 = new iv247_intravenous_ioc_mock_InjectionMock();
				var result;
				iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),injectedObject);
				result = iv.call("injectableMethod",object4);
				buddy_ShouldDynamic.should(injectedObject,__status7).be(result,{ fileName : "InjectionsSpec.hx", lineNumber : 92, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
			});
			_g.syncIt("should use argument id's if set",function(__asyncDone8,__status8) {
				var injectedObject1 = new iv247_intravenous_ioc_mock_InjectedObject();
				var injectedObjectWithId = new iv247_intravenous_ioc_mock_InjectedObject();
				var object5 = new iv247_intravenous_ioc_mock_InjectionMock();
				var result1;
				iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),injectedObjectWithId,"injectedObjectId");
				result1 = iv.call("injectableMethodWithId",object5);
				buddy_ShouldDynamic.should(injectedObjectWithId,__status8).be(result1.injectedObjectWithId,{ fileName : "InjectionsSpec.hx", lineNumber : 105, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
			});
			_g.syncIt("should support optional arguments",function(__asyncDone9,__status9) {
				var injectedObjectWithId1 = new iv247_intravenous_ioc_mock_InjectedObject();
				var object6 = new iv247_intravenous_ioc_mock_InjectionMock();
				var result2;
				iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),injectedObjectWithId1,"injectedObjectId");
				result2 = iv.call("injectableMethodWithOptionalArg",object6);
				buddy_ShouldDynamic.should(result2.injectedObjectWithId,__status9).be(injectedObjectWithId1,{ fileName : "InjectionsSpec.hx", lineNumber : 120, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
			});
		});
		_g.describe("mapped classes",function() {
			_g.syncIt("should have their 'inject' annotated properties injected",function(__asyncDone10,__status10) {
				var injectionMock;
				iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject));
				iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock));
				injectionMock = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock));
				buddy_ShouldDynamic.should(injectionMock.injectedObject,__status10).get_not().be(null,{ fileName : "InjectionsSpec.hx", lineNumber : 131, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
			});
			_g.syncIt("should not inject properties that are not mapped",function(__asyncDone11,__status11) {
				var injectionMock1;
				iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock));
				injectionMock1 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock));
				buddy_ShouldDynamic.should(injectionMock1.injectedObject,__status11).be(null,{ fileName : "InjectionsSpec.hx", lineNumber : 140, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
			});
			_g.syncIt("should use the property's inject id if set",function(__asyncDone12,__status12) {
				var injectedObjectWithId2 = new iv247_intravenous_ioc_mock_InjectedObject();
				var injectionMock2;
				iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock));
				iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),injectedObjectWithId2,"injectedObjectId");
				injectionMock2 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectionMock));
				buddy_ShouldDynamic.should(injectedObjectWithId2,__status12).be(injectionMock2.injectedObjectWithId,{ fileName : "InjectionsSpec.hx", lineNumber : 152, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
			});
			_g.syncIt("should have constructor args injected when instantiated",function(__asyncDone13,__status13) {
				var ctorInjectionMock;
				iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_CtorInjectionMock),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_CtorInjectionMock));
				iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),"injectedObjectId");
				iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject));
				ctorInjectionMock = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_CtorInjectionMock));
				buddy_ShouldDynamic.should(ctorInjectionMock.ctorObject,__status13).get_not().be(null,{ fileName : "InjectionsSpec.hx", lineNumber : 166, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
				buddy_ShouldDynamic.should(ctorInjectionMock.ctorObjectWithId,__status13).get_not().be(null,{ fileName : "InjectionsSpec.hx", lineNumber : 167, className : "iv247.intravenous.ioc.InjectionsSpec", methodName : "new"});
			});
		});
	});
};
$hxClasses["iv247.intravenous.ioc.InjectionsSpec"] = iv247_intravenous_ioc_InjectionsSpec;
iv247_intravenous_ioc_InjectionsSpec.__name__ = ["iv247","intravenous","ioc","InjectionsSpec"];
iv247_intravenous_ioc_InjectionsSpec.__super__ = buddy_BuddySuite;
iv247_intravenous_ioc_InjectionsSpec.prototype = $extend(buddy_BuddySuite.prototype,{
	__class__: iv247_intravenous_ioc_InjectionsSpec
});
var iv247_intravenous_ioc_SandboxTest = function() {
	var _g = this;
	buddy_BuddySuite.call(this);
	this.xdescribe("test suite",function() {
		var iv;
		_g.syncBefore(function(__asyncDone,__status) {
			iv = new iv247_intravenous_ioc_IV();
		});
	});
};
$hxClasses["iv247.intravenous.ioc.SandboxTest"] = iv247_intravenous_ioc_SandboxTest;
iv247_intravenous_ioc_SandboxTest.__name__ = ["iv247","intravenous","ioc","SandboxTest"];
iv247_intravenous_ioc_SandboxTest.__super__ = buddy_BuddySuite;
iv247_intravenous_ioc_SandboxTest.prototype = $extend(buddy_BuddySuite.prototype,{
	__class__: iv247_intravenous_ioc_SandboxTest
});
var iv247_intravenous_ioc_IVMappingTest = function() {
	var _g = this;
	buddy_BuddySuite.call(this);
	this.describe("IInjector implementations",function() {
		var iv;
		_g.syncBefore(function(__asyncDone,__status) {
			iv = new iv247_intravenous_ioc_IV();
		});
		_g.syncIt("should tell if a mapping exists",function(__asyncDone1,__status1) {
			buddy_ShouldDynamic.should(iv.hasMapping(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject)),__status1).be(false,{ fileName : "MappingSpec.hx", lineNumber : 22, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),new iv247_intravenous_ioc_mock_MockObject());
			buddy_ShouldDynamic.should(iv.hasMapping(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject)),__status1).be(true,{ fileName : "MappingSpec.hx", lineNumber : 26, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
		});
		_g.syncIt("should tell if a mapping with an id exists",function(__asyncDone2,__status2) {
			var id = "mockId";
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),new iv247_intravenous_ioc_mock_MockObject(),id);
			buddy_ShouldDynamic.should(iv.hasMapping(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject)),__status2).be(false,{ fileName : "MappingSpec.hx", lineNumber : 34, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
			buddy_ShouldDynamic.should(iv.hasMapping(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),id),__status2).be(true,{ fileName : "MappingSpec.hx", lineNumber : 35, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
		});
		_g.syncIt("should remove mappings",function(__asyncDone3,__status3) {
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),new iv247_intravenous_ioc_mock_MockObject());
			iv.unmap(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject));
			buddy_ShouldDynamic.should(iv.hasMapping(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject)),__status3).be(false,{ fileName : "MappingSpec.hx", lineNumber : 42, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
		});
		_g.syncIt("should remove mappings with an id",function(__asyncDone4,__status4) {
			var id1 = "mockId";
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),new iv247_intravenous_ioc_mock_MockObject());
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),new iv247_intravenous_ioc_mock_MockObject(),id1);
			iv.unmap(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),id1);
			buddy_ShouldDynamic.should(iv.hasMapping(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject)),__status4).be(true,{ fileName : "MappingSpec.hx", lineNumber : 53, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
			buddy_ShouldDynamic.should(iv.hasMapping(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),id1),__status4).be(false,{ fileName : "MappingSpec.hx", lineNumber : 54, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
		});
		_g.describe("values",function() {
			_g.syncIt("should be mapped to a type",function(__asyncDone5,__status5) {
				var mock = new iv247_intravenous_ioc_mock_MockObject();
				iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),mock);
				buddy_ShouldDynamic.should(mock,__status5).be(iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject)),{ fileName : "MappingSpec.hx", lineNumber : 63, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
			});
			_g.syncIt("should be mapped to a type based on an id",function(__asyncDone6,__status6) {
				var mock1 = new iv247_intravenous_ioc_mock_MockObject();
				var mockNoId = new iv247_intravenous_ioc_mock_MockObject();
				iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),mock1,"mymock");
				iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),mockNoId);
				buddy_ShouldDynamic.should(mock1,__status6).be(iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),"mymock"),{ fileName : "MappingSpec.hx", lineNumber : 73, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
				buddy_ShouldDynamic.should(mockNoId,__status6).get_not().be(iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),"mymock"),{ fileName : "MappingSpec.hx", lineNumber : 74, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
			});
		});
		_g.describe("dynamic types",function() {
			_g.syncIt("should be mapped to a compatible type",function(__asyncDone7,__status7) {
				var mock2;
				iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject));
				mock2 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject));
				buddy_ShouldDynamic.should(js_Boot.__instanceof(mock2,iv247_intravenous_ioc_mock_IMockObject),__status7).be(true,{ fileName : "MappingSpec.hx", lineNumber : 86, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
			});
			_g.syncIt("should be mapped to a compatible type based on an id",function(__asyncDone8,__status8) {
				var mock3;
				var foo;
				iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_Foo));
				iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),"mockId");
				mock3 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),"mockId");
				foo = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject));
				buddy_ShouldDynamic.should(js_Boot.__instanceof(mock3,iv247_intravenous_ioc_mock_MockObject),__status8).be(true,{ fileName : "MappingSpec.hx", lineNumber : 98, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
				buddy_ShouldDynamic.should(js_Boot.__instanceof(foo,iv247_intravenous_ioc_mock_Foo),__status8).be(true,{ fileName : "MappingSpec.hx", lineNumber : 99, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
			});
			_g.syncIt("should be instantiated on every request",function(__asyncDone9,__status9) {
				var mock4;
				var mock21;
				var foo1;
				var foo2;
				iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_Foo));
				iv.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),"mockId");
				mock4 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),"mockId");
				mock21 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),"mockId");
				foo1 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject));
				foo2 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject));
				buddy_ShouldDynamic.should(mock4 == mock21,__status9).get_not().be(true,{ fileName : "MappingSpec.hx", lineNumber : 113, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
				buddy_ShouldDynamic.should(foo1 == foo2,__status9).be(false,{ fileName : "MappingSpec.hx", lineNumber : 114, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
			});
		});
		_g.describe("singleton types",function() {
			_g.syncIt("should map to a compatible type",function(__asyncDone10,__status10) {
				var mock5;
				iv.mapSingleton(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject));
				mock5 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject));
				buddy_ShouldDynamic.should(js_Boot.__instanceof(mock5,iv247_intravenous_ioc_mock_IMockObject),__status10).be(true,{ fileName : "MappingSpec.hx", lineNumber : 124, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
			});
			_g.syncIt("should map to a compatible type based on an id",function(__asyncDone11,__status11) {
				var mock6;
				var foo3;
				iv.mapSingleton(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_MockObject),"mock");
				iv.mapSingleton(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_Foo),"foo");
				mock6 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),"mock");
				foo3 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_IMockObject),"foo");
				buddy_ShouldDynamic.should(js_Boot.__instanceof(mock6,iv247_intravenous_ioc_mock_MockObject),__status11).be(true,{ fileName : "MappingSpec.hx", lineNumber : 134, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
				buddy_ShouldDynamic.should(js_Boot.__instanceof(foo3,iv247_intravenous_ioc_mock_Foo),__status11).be(true,{ fileName : "MappingSpec.hx", lineNumber : 135, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
			});
			_g.syncIt("should be lazy loaded",function(__asyncDone12,__status12) {
				var foo4;
				iv247_intravenous_ioc_mock_Foo.instantiated = false;
				iv.mapSingleton(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_Foo),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_Foo));
				foo4 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_Foo));
				buddy_ShouldDynamic.should(iv247_intravenous_ioc_mock_Foo.instantiated,__status12).be(true,{ fileName : "MappingSpec.hx", lineNumber : 145, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
			});
			_g.syncIt("should be the same instance on every request",function(__asyncDone13,__status13) {
				var foo5;
				iv.mapSingleton(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_Foo),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_Foo));
				foo5 = iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_Foo));
				buddy_ShouldDynamic.should(foo5,__status13).be(iv.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_Foo)),{ fileName : "MappingSpec.hx", lineNumber : 153, className : "iv247.intravenous.ioc.IVMappingTest", methodName : "new"});
			});
		});
	});
};
$hxClasses["iv247.intravenous.ioc.IVMappingTest"] = iv247_intravenous_ioc_IVMappingTest;
iv247_intravenous_ioc_IVMappingTest.__name__ = ["iv247","intravenous","ioc","IVMappingTest"];
iv247_intravenous_ioc_IVMappingTest.__super__ = buddy_BuddySuite;
iv247_intravenous_ioc_IVMappingTest.prototype = $extend(buddy_BuddySuite.prototype,{
	__class__: iv247_intravenous_ioc_IVMappingTest
});
var iv247_intravenous_ioc_PostInjectionSpec = function() {
	var _g = this;
	buddy_BuddySuite.call(this);
	var iv;
	this.describe("IV, after injection into objects, ",function() {
		_g.syncBefore(function(__asyncDone,__status) {
			iv = new iv247_intravenous_ioc_IV();
		});
		_g.syncIt("should call methods annotated with post",function(__asyncDone1,__status1) {
			var object = new iv247_intravenous_ioc_mock_InjectionMock();
			var injectedObject = new iv247_intravenous_ioc_mock_InjectedObject();
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),injectedObject,"postInjectId");
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),injectedObject);
			iv.injectInto(object);
			buddy_ShouldDynamic.should(object.postInjectedObject,__status1).be(injectedObject,{ fileName : "PostInjectionSpec.hx", lineNumber : 26, className : "iv247.intravenous.ioc.PostInjectionSpec", methodName : "new"});
			buddy_ShouldDynamic.should(object.postInjectedObjectNoId,__status1).be(injectedObject,{ fileName : "PostInjectionSpec.hx", lineNumber : 27, className : "iv247.intravenous.ioc.PostInjectionSpec", methodName : "new"});
		});
		_g.syncIt("should only call post annotated method once if marked with override",function(__asyncDone2,__status2) {
			var object1 = new iv247_intravenous_ioc_mock_SubClassInjectionMock();
			var injectedObject1 = new iv247_intravenous_ioc_mock_InjectedObject();
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),injectedObject1,"postInjectId");
			iv.injectInto(object1);
			buddy_ShouldDynamic.should(object1.subPostInjectedObject,__status2).be(injectedObject1,{ fileName : "PostInjectionSpec.hx", lineNumber : 37, className : "iv247.intravenous.ioc.PostInjectionSpec", methodName : "new"});
			buddy_ShouldFloat.should(object1.postCount,__status2).be(1,{ fileName : "PostInjectionSpec.hx", lineNumber : 38, className : "iv247.intravenous.ioc.PostInjectionSpec", methodName : "new"});
		});
		_g.syncIt("should call methods annotated with post on super classes",function(__asyncDone3,__status3) {
			var object2 = new iv247_intravenous_ioc_mock_SubClassInjectionMock();
			var injectedObject2 = new iv247_intravenous_ioc_mock_InjectedObject();
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),injectedObject2,"postInjectId");
			iv.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_ioc_mock_InjectedObject),injectedObject2);
			iv.injectInto(object2);
			buddy_ShouldDynamic.should(object2.postInjectedObjectNoId,__status3).be(injectedObject2,{ fileName : "PostInjectionSpec.hx", lineNumber : 50, className : "iv247.intravenous.ioc.PostInjectionSpec", methodName : "new"});
		});
	});
};
$hxClasses["iv247.intravenous.ioc.PostInjectionSpec"] = iv247_intravenous_ioc_PostInjectionSpec;
iv247_intravenous_ioc_PostInjectionSpec.__name__ = ["iv247","intravenous","ioc","PostInjectionSpec"];
iv247_intravenous_ioc_PostInjectionSpec.__super__ = buddy_BuddySuite;
iv247_intravenous_ioc_PostInjectionSpec.prototype = $extend(buddy_BuddySuite.prototype,{
	__class__: iv247_intravenous_ioc_PostInjectionSpec
});
var iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$ = {};
$hxClasses["iv247.intravenous.ioc.internal._Injectable.Injectable_Impl_"] = iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$;
iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.__name__ = ["iv247","intravenous","ioc","internal","_Injectable","Injectable_Impl_"];
iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromString = function(path) {
	var classType = Type.resolveClass(path);
	var type;
	if(classType != null) type = classType; else type = Type.resolveEnum(path);
	return type;
};
iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic = function(v) {
	var inj = null;
	if(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.isAClass(v)) inj = Type.resolveClass(Type.getClassName(v)); else if(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.isEnum(v)) inj = Type.resolveEnum(Type.getEnumName(v)); else if(typeof(v) == "string") {
		inj = iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromString(js_Boot.__cast(v , String));
		if(inj == null) haxe_Log.trace("assigned invalid path",{ fileName : "Injectable.hx", lineNumber : 34, className : "iv247.intravenous.ioc.internal._Injectable.Injectable_Impl_", methodName : "fromDynamic"});
	} else haxe_Log.trace("assigned invalid type",{ fileName : "Injectable.hx", lineNumber : 38, className : "iv247.intravenous.ioc.internal._Injectable.Injectable_Impl_", methodName : "fromDynamic"});
	return inj;
};
iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.getName = function(this1) {
	if(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.isAClass(this1)) return Type.getClassName(this1); else return Type.getEnumName(this1);
};
iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.instantiate = function(this1,args,ctor) {
	if(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.isAClass(this1)) return Type.createInstance(this1,args); else return Type.createEnum(this1,ctor,args);
};
iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.isClass = function(this1) {
	return js_Boot.__instanceof(this1,Class);
};
iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.isEnum = function(v) {
	return js_Boot.__instanceof(v,Enum);
};
iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.isAClass = function(v) {
	return js_Boot.__instanceof(v,Class);
};
var iv247_intravenous_ioc_mock_IMockObject = function() { };
$hxClasses["iv247.intravenous.ioc.mock.IMockObject"] = iv247_intravenous_ioc_mock_IMockObject;
iv247_intravenous_ioc_mock_IMockObject.__name__ = ["iv247","intravenous","ioc","mock","IMockObject"];
var iv247_intravenous_ioc_mock_Foo = function() {
	iv247_intravenous_ioc_mock_Foo.instantiated = true;
};
$hxClasses["iv247.intravenous.ioc.mock.Foo"] = iv247_intravenous_ioc_mock_Foo;
iv247_intravenous_ioc_mock_Foo.__name__ = ["iv247","intravenous","ioc","mock","Foo"];
iv247_intravenous_ioc_mock_Foo.__interfaces__ = [iv247_intravenous_ioc_mock_IMockObject];
iv247_intravenous_ioc_mock_Foo.instantiated = null;
iv247_intravenous_ioc_mock_Foo.prototype = {
	__class__: iv247_intravenous_ioc_mock_Foo
};
var iv247_intravenous_ioc_mock_InjectionMock = function() {
};
$hxClasses["iv247.intravenous.ioc.mock.InjectionMock"] = iv247_intravenous_ioc_mock_InjectionMock;
iv247_intravenous_ioc_mock_InjectionMock.__name__ = ["iv247","intravenous","ioc","mock","InjectionMock"];
iv247_intravenous_ioc_mock_InjectionMock.prototype = {
	injectableMethod: function(injectedObject) {
		return injectedObject;
	}
	,injectableMethodWithId: function(v1,v2) {
		return { injectedObject : v1, injectedObjectWithId : v2};
	}
	,injectableMethodWithOptionalArg: function(v1,v2) {
		return { injectedObjectWithId : v1, injectedObject : v2};
	}
	,postInjectMethod: function(post) {
		this.postInjectedObject = post;
	}
	,anotherPostInjectMethod: function(post) {
		this.postInjectedObjectNoId = post;
	}
	,__class__: iv247_intravenous_ioc_mock_InjectionMock
};
var iv247_intravenous_ioc_mock_SubClassInjectionMock = function() {
	this.postCount = 0;
	iv247_intravenous_ioc_mock_InjectionMock.call(this);
};
$hxClasses["iv247.intravenous.ioc.mock.SubClassInjectionMock"] = iv247_intravenous_ioc_mock_SubClassInjectionMock;
iv247_intravenous_ioc_mock_SubClassInjectionMock.__name__ = ["iv247","intravenous","ioc","mock","SubClassInjectionMock"];
iv247_intravenous_ioc_mock_SubClassInjectionMock.__super__ = iv247_intravenous_ioc_mock_InjectionMock;
iv247_intravenous_ioc_mock_SubClassInjectionMock.prototype = $extend(iv247_intravenous_ioc_mock_InjectionMock.prototype,{
	postInjectMethod: function(post) {
		this.subPostInjectedObject = post;
		this.postCount++;
	}
	,__class__: iv247_intravenous_ioc_mock_SubClassInjectionMock
});
var iv247_intravenous_ioc_mock_CtorInjectionMock = function(io,ioId) {
	this.ctorObject = io;
	this.ctorObjectWithId = ioId;
	iv247_intravenous_ioc_mock_InjectionMock.call(this);
};
$hxClasses["iv247.intravenous.ioc.mock.CtorInjectionMock"] = iv247_intravenous_ioc_mock_CtorInjectionMock;
iv247_intravenous_ioc_mock_CtorInjectionMock.__name__ = ["iv247","intravenous","ioc","mock","CtorInjectionMock"];
iv247_intravenous_ioc_mock_CtorInjectionMock.__super__ = iv247_intravenous_ioc_mock_InjectionMock;
iv247_intravenous_ioc_mock_CtorInjectionMock.prototype = $extend(iv247_intravenous_ioc_mock_InjectionMock.prototype,{
	__class__: iv247_intravenous_ioc_mock_CtorInjectionMock
});
var iv247_intravenous_ioc_mock_InjectedObject = function() {
};
$hxClasses["iv247.intravenous.ioc.mock.InjectedObject"] = iv247_intravenous_ioc_mock_InjectedObject;
iv247_intravenous_ioc_mock_InjectedObject.__name__ = ["iv247","intravenous","ioc","mock","InjectedObject"];
iv247_intravenous_ioc_mock_InjectedObject.prototype = {
	__class__: iv247_intravenous_ioc_mock_InjectedObject
};
var iv247_intravenous_ioc_mock_InjectionMockWEnum = function(enumCtor,enumValue) {
	this.enumCtor = enumCtor;
	this.enumValue = enumValue;
};
$hxClasses["iv247.intravenous.ioc.mock.InjectionMockWEnum"] = iv247_intravenous_ioc_mock_InjectionMockWEnum;
iv247_intravenous_ioc_mock_InjectionMockWEnum.__name__ = ["iv247","intravenous","ioc","mock","InjectionMockWEnum"];
iv247_intravenous_ioc_mock_InjectionMockWEnum.prototype = {
	__class__: iv247_intravenous_ioc_mock_InjectionMockWEnum
};
var iv247_intravenous_ioc_mock_MockConstructorArg = function(value) {
	this.mock = value;
};
$hxClasses["iv247.intravenous.ioc.mock.MockConstructorArg"] = iv247_intravenous_ioc_mock_MockConstructorArg;
iv247_intravenous_ioc_mock_MockConstructorArg.__name__ = ["iv247","intravenous","ioc","mock","MockConstructorArg"];
iv247_intravenous_ioc_mock_MockConstructorArg.prototype = {
	__class__: iv247_intravenous_ioc_mock_MockConstructorArg
};
var iv247_intravenous_ioc_mock_WithId = function(v1,v2,v3) {
	this.mockWithId = v1;
	this.mockWithId2 = v2;
	this.noId = v3;
};
$hxClasses["iv247.intravenous.ioc.mock.WithId"] = iv247_intravenous_ioc_mock_WithId;
iv247_intravenous_ioc_mock_WithId.__name__ = ["iv247","intravenous","ioc","mock","WithId"];
iv247_intravenous_ioc_mock_WithId.prototype = {
	__class__: iv247_intravenous_ioc_mock_WithId
};
var iv247_intravenous_ioc_mock_MockEnum = $hxClasses["iv247.intravenous.ioc.mock.MockEnum"] = { __ename__ : ["iv247","intravenous","ioc","mock","MockEnum"], __constructs__ : ["MockEnumValue","MockEnumCtor"] };
iv247_intravenous_ioc_mock_MockEnum.MockEnumValue = ["MockEnumValue",0];
iv247_intravenous_ioc_mock_MockEnum.MockEnumValue.toString = $estr;
iv247_intravenous_ioc_mock_MockEnum.MockEnumValue.__enum__ = iv247_intravenous_ioc_mock_MockEnum;
iv247_intravenous_ioc_mock_MockEnum.MockEnumCtor = function(i,i2,i3) { var $x = ["MockEnumCtor",1,i,i2,i3]; $x.__enum__ = iv247_intravenous_ioc_mock_MockEnum; $x.toString = $estr; return $x; };
iv247_intravenous_ioc_mock_MockEnum.__meta__ = { fields : { MockEnumValue : { inject : null}, MockEnumCtor : { types : [{ opt : false, type : "iv247.intravenous.ioc.mock.InjectedObject"},{ opt : false, type : "iv247.intravenous.ioc.mock.InjectedObject"},{ opt : true, type : "iv247.intravenous.ioc.mock.MockEnum"}], inject : ["injectedObjectId"]}}};
var iv247_intravenous_ioc_mock_MockExtension = function() {
	this.test = "test";
};
$hxClasses["iv247.intravenous.ioc.mock.MockExtension"] = iv247_intravenous_ioc_mock_MockExtension;
iv247_intravenous_ioc_mock_MockExtension.__name__ = ["iv247","intravenous","ioc","mock","MockExtension"];
iv247_intravenous_ioc_mock_MockExtension.prototype = {
	onInjection: function(extensionDef) {
	}
	,__class__: iv247_intravenous_ioc_mock_MockExtension
};
var iv247_intravenous_ioc_mock_MockExtensionObject = function() {
};
$hxClasses["iv247.intravenous.ioc.mock.MockExtensionObject"] = iv247_intravenous_ioc_mock_MockExtensionObject;
iv247_intravenous_ioc_mock_MockExtensionObject.__name__ = ["iv247","intravenous","ioc","mock","MockExtensionObject"];
iv247_intravenous_ioc_mock_MockExtensionObject.prototype = {
	mockMethod: function(value) {
		return value;
	}
	,__class__: iv247_intravenous_ioc_mock_MockExtensionObject
};
var iv247_intravenous_ioc_mock_MockCtorExtensionObject = function() {
};
$hxClasses["iv247.intravenous.ioc.mock.MockCtorExtensionObject"] = iv247_intravenous_ioc_mock_MockCtorExtensionObject;
iv247_intravenous_ioc_mock_MockCtorExtensionObject.__name__ = ["iv247","intravenous","ioc","mock","MockCtorExtensionObject"];
iv247_intravenous_ioc_mock_MockCtorExtensionObject.prototype = {
	__class__: iv247_intravenous_ioc_mock_MockCtorExtensionObject
};
var iv247_intravenous_ioc_mock_MockObject = function() {
};
$hxClasses["iv247.intravenous.ioc.mock.MockObject"] = iv247_intravenous_ioc_mock_MockObject;
iv247_intravenous_ioc_mock_MockObject.__name__ = ["iv247","intravenous","ioc","mock","MockObject"];
iv247_intravenous_ioc_mock_MockObject.__interfaces__ = [iv247_intravenous_ioc_mock_IMockObject];
iv247_intravenous_ioc_mock_MockObject.prototype = {
	__class__: iv247_intravenous_ioc_mock_MockObject
};
var iv247_intravenous_messaging_Sequencer = function() { };
$hxClasses["iv247.intravenous.messaging.Sequencer"] = iv247_intravenous_messaging_Sequencer;
iv247_intravenous_messaging_Sequencer.__name__ = ["iv247","intravenous","messaging","Sequencer"];
iv247_intravenous_messaging_Sequencer.prototype = {
	__class__: iv247_intravenous_messaging_Sequencer
};
var iv247_intravenous_messaging_CommandSequencer = function(sequence,injector) {
	this.running = false;
	this.currentCommandDefIndex = 0;
	this.sequence = sequence;
	this.injector = injector;
};
$hxClasses["iv247.intravenous.messaging.CommandSequencer"] = iv247_intravenous_messaging_CommandSequencer;
iv247_intravenous_messaging_CommandSequencer.__name__ = ["iv247","intravenous","messaging","CommandSequencer"];
iv247_intravenous_messaging_CommandSequencer.__interfaces__ = [iv247_intravenous_messaging_Sequencer];
iv247_intravenous_messaging_CommandSequencer.prototype = {
	start: function() {
		if(this.started) throw new js__$Boot_HaxeError("Command Sequence has already been started");
		this.started = true;
		this.startSequence();
	}
	,startSequence: function() {
		if(this.sequence.interceptors != null) this.callCommands(this.sequence.interceptors,[this.sequence.message,this]);
		if(this.sequence.commands != null) this.callCommands(this.sequence.commands,[this.sequence.message]);
		if(this.sequence.completeMethods != null) this.callCommands(this.sequence.completeMethods,[this.sequence.message]);
	}
	,setCurrentCommandInfo: function(commandDefs,commandDefIndex,args) {
		this.currentCommandDefs = commandDefs;
		this.currentCommandDefIndex = commandDefIndex;
		this.currentArgs = args;
	}
	,stop: function() {
		this.stopped = true;
	}
	,resume: function() {
		if(this.stopped) {
			this.stopped = false;
			this.startSequence();
		}
	}
	,cancel: function() {
		this.stopped = true;
	}
	,callCommands: function(commandDefs,args,startIndex) {
		if(startIndex == null) startIndex = 0;
		var ref;
		var instance;
		var result;
		this.currentCommandDefs = commandDefs;
		this.currentArgs = args;
		this.running = true;
		var _g1 = startIndex;
		var _g = commandDefs.length;
		while(_g1 < _g) {
			var i = _g1++;
			ref = commandDefs[i];
			this.currentCommandDefIndex = i;
			if(this.stopped) {
				this.running = false;
				return;
			}
			if(ref.async) {
				args.push($bind(this,this.callback));
				this.currentCommandDefIndex++;
				this.stop();
			}
			{
				var _g2 = ref.t;
				switch(_g2[1]) {
				case 4:
					if(this.injector != null) instance = this.injector.instantiate(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(ref.o)); else instance = Type.createInstance(ref.o,[]);
					result = Reflect.callMethod(instance,Reflect.field(instance,ref.f),args);
					break;
				case 6:
					var c = _g2[2];
					result = Reflect.callMethod(ref.o,Reflect.field(ref.o,ref.f),args);
					break;
				default:
					result = null;
				}
			}
			if(result != null) this.stop();
		}
		this.commandDefsComplete(commandDefs);
	}
	,commandDefsComplete: function(commandDefs) {
		if(commandDefs == this.sequence.interceptors) this.sequence.interceptors = null; else if(commandDefs == this.sequence.commands) this.sequence.commands = null; else this.sequence.completeMethods = null;
	}
	,callback: function(restart) {
		if(restart && this.running) this.stopped = false; else if(restart) this.resume(); else this.cancel();
	}
	,__class__: iv247_intravenous_messaging_CommandSequencer
};
var iv247_intravenous_messaging_MessageProcessor = function(injector) {
	this.injector = injector;
	this.commandMap = new haxe_ds_StringMap();
	this.interceptMap = new haxe_ds_StringMap();
	this.completeMap = new haxe_ds_StringMap();
};
$hxClasses["iv247.intravenous.messaging.MessageProcessor"] = iv247_intravenous_messaging_MessageProcessor;
iv247_intravenous_messaging_MessageProcessor.__name__ = ["iv247","intravenous","messaging","MessageProcessor"];
iv247_intravenous_messaging_MessageProcessor.getDispatcher = function(ext) {
	var processor = ext.injector.getInstance(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_messaging_MessageProcessor));
	ext.object[ext.field] = processor.dispatch;
};
iv247_intravenous_messaging_MessageProcessor.prototype = {
	processMeta: function(def) {
		var _g = def.type;
		switch(_g[1]) {
		case 0:
			return;
		case 2:
			var metaValue = Reflect.field(def.meta,def.metaname);
			var order;
			if(metaValue == null) order = 0; else order = metaValue[0];
			var isAsync = Object.prototype.hasOwnProperty.call(def.meta,"async");
			var map;
			if(Object.prototype.hasOwnProperty.call(def.meta,"intercept")) map = this.interceptMap; else if(Object.prototype.hasOwnProperty.call(def.meta,"commandComplete")) map = this.completeMap; else map = this.commandMap;
			var messageType = Reflect.field(def.meta,"types")[0].type;
			var ref;
			if(!((order | 0) === order)) order = 0;
			ref = { o : def.object, f : def.field, i : order, t : Type["typeof"](def.object), async : isAsync};
			this.insertCommandRef(map,messageType,ref);
			break;
		default:
			return;
		}
	}
	,deregister: function(o) {
		var type = Type.getClass(o);
		var fields = Type.getClassFields(type);
		var meta = haxe_rtti_Meta.getFields(type);
		var fields1 = Reflect.fields(meta);
		var fieldMeta;
		var map;
		var _g = 0;
		while(_g < fields1.length) {
			var field = fields1[_g];
			++_g;
			fieldMeta = Reflect.field(meta,field);
			if(Object.prototype.hasOwnProperty.call(fieldMeta,"intercept")) map = this.interceptMap; else if(Object.prototype.hasOwnProperty.call(fieldMeta,"command")) map = this.commandMap; else if(Object.prototype.hasOwnProperty.call(fieldMeta,"commandComplete")) map = this.completeMap; else map = null;
			if(map != null) this.removeFromMap(o,type,map);
		}
	}
	,removeFromMap: function(object,type,map) {
		var $it0 = new haxe_ds__$StringMap_StringMapIterator(map,map.arrayKeys());
		while( $it0.hasNext() ) {
			var defArray = $it0.next();
			var _g = 0;
			while(_g < defArray.length) {
				var def = defArray[_g];
				++_g;
				if(def.o == object) HxOverrides.remove(defArray,def);
			}
		}
	}
	,mapCommand: function(commandClass) {
		var className = Type.getClassName(commandClass);
		var classMeta = haxe_rtti_Meta.getType(commandClass);
		var messageType = classMeta.messageTypes[0].type;
		var order;
		if(classMeta.command == null) order = -1; else order = classMeta.command[0];
		var isInterceptor = Object.prototype.hasOwnProperty.call(classMeta,"intercept");
		var isAsync = Object.prototype.hasOwnProperty.call(classMeta,"async");
		var map;
		if(isInterceptor) map = this.interceptMap; else map = this.commandMap;
		var ref = { o : commandClass, f : "execute", i : order, t : Type["typeof"](commandClass), async : isAsync};
		this.insertCommandRef(map,messageType,ref);
	}
	,removeCommand: function(commandClass) {
		var className = Type.getClassName(commandClass);
		var classMeta = haxe_rtti_Meta.getType(commandClass);
		var messageType = classMeta.messageTypes[0].type;
		var order;
		if(classMeta.command == null) order = -1; else order = classMeta.command[0];
		var isInterceptor = Object.prototype.hasOwnProperty.call(classMeta,"intercept");
		var map;
		if(isInterceptor) map = this.interceptMap; else map = this.commandMap;
		var ref = { o : commandClass, f : "execute", i : order, t : Type["typeof"](commandClass)};
		this.removeCommandRef(map,messageType,ref);
	}
	,insertCommandRef: function(map,messageType,def) {
		var mapArray;
		mapArray = __map_reserved[messageType] != null?map.getReserved(messageType):map.h[messageType];
		var newArray;
		if(mapArray == null) {
			mapArray = [];
			if(__map_reserved[messageType] != null) map.setReserved(messageType,mapArray); else map.h[messageType] = mapArray;
		}
		mapArray.push(def);
		mapArray.sort(function(ref,ref2) {
			if(ref.i < ref2.i) return -1; else if(ref.i > ref2.i) return 1; else return 0;
		});
	}
	,removeCommandRef: function(map,messageType,def) {
		var mapArray;
		mapArray = __map_reserved[messageType] != null?map.getReserved(messageType):map.h[messageType];
		if(mapArray != null) {
			var _g = 0;
			while(_g < mapArray.length) {
				var commandDef = mapArray[_g];
				++_g;
				if(commandDef.o == def.o) HxOverrides.remove(mapArray,commandDef);
			}
		}
	}
	,dispatch: function(o) {
		var messageType = Type.getClassName(Type.getClass(o));
		var interceptors = this.interceptMap.get(messageType);
		var commands = this.commandMap.get(messageType);
		var completeMethods = this.completeMap.get(messageType);
		var sequencer = new iv247_intravenous_messaging_CommandSequencer({ interceptors : interceptors, commands : commands, completeMethods : completeMethods, message : o, processor : this},this.injector);
		if(this.openSequencers == null) this.openSequencers = [];
		this.openSequencers.push(sequencer);
		sequencer.start();
	}
	,removeSequence: function(sequencer) {
		if(this.openSequencers != null) HxOverrides.remove(this.openSequencers,sequencer);
	}
	,__class__: iv247_intravenous_messaging_MessageProcessor
};
var iv247_intravenous_messaging_MessagingSpec = function() {
	var _g = this;
	buddy_BuddySuite.call(this);
	this.describe("Messaging",function() {
		_g.syncBefore(function(__asyncDone,__status) {
			_g.injector = new iv247_intravenous_ioc_IV();
			_g.processor = new iv247_intravenous_messaging_MessageProcessor(_g.injector);
			iv247_intravenous_messaging_mock_MockCommand.count = 0;
			iv247_intravenous_ioc_IV.addExtension("command",($_=_g.processor,$bind($_,$_.processMeta)));
			iv247_intravenous_ioc_IV.addExtension("commandComplete",($_=_g.processor,$bind($_,$_.processMeta)));
		});
		_g.describe("objects with command methods",function() {
			_g.syncIt("should call methods annotated with command",function(__asyncDone1,__status1) {
				var message = new iv247_intravenous_messaging_mock_Message();
				_g.injector.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_messaging_mock_MockController),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_messaging_mock_MockController));
				var mock = _g.injector.instantiate(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_messaging_mock_MockController));
				_g.processor.dispatch(message);
				buddy_ShouldDynamic.should(message.commandCalled,__status1).be(true,{ fileName : "MessagingSpec.hx", lineNumber : 36, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
			});
			_g.syncIt("should remove objects waiting for dispatched objects",function(__asyncDone2,__status2) {
				var message1 = new iv247_intravenous_messaging_mock_Message();
				var mock1;
				_g.injector.mapDynamic(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_messaging_mock_MockController),iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_messaging_mock_MockController));
				mock1 = _g.injector.instantiate(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_messaging_mock_MockController));
				_g.processor.deregister(mock1);
				_g.processor.dispatch(message1);
				buddy_ShouldDynamic.should(message1.commandCalled,__status2).get_not().be(true,{ fileName : "MessagingSpec.hx", lineNumber : 49, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
			});
		});
		_g.describe("command classes",function() {
			var message2;
			_g.syncBefore(function(__asyncDone3,__status3) {
				message2 = new iv247_intravenous_messaging_mock_Message();
				_g.processor.mapCommand(iv247_intravenous_messaging_mock_MockCommand);
			});
			_g.syncIt("should be instantiated on each dispatch",function(__asyncDone4,__status4) {
				_g.processor.dispatch(message2);
				_g.processor.dispatch(message2);
				buddy_ShouldFloat.should(iv247_intravenous_messaging_mock_MockCommand.count,__status4).be(2,{ fileName : "MessagingSpec.hx", lineNumber : 64, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
			});
			_g.syncIt("should call the execute method",function(__asyncDone5,__status5) {
				_g.processor.dispatch(message2);
				buddy_ShouldDynamic.should(iv247_intravenous_messaging_mock_MockCommand.message,__status5).be(message2,{ fileName : "MessagingSpec.hx", lineNumber : 69, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
			});
			_g.syncIt("should remove command class",function(__asyncDone6,__status6) {
				_g.processor.removeCommand(iv247_intravenous_messaging_mock_MockCommand);
				_g.processor.dispatch(message2);
				buddy_ShouldFloat.should(iv247_intravenous_messaging_mock_MockCommand.count,__status6).be(0,{ fileName : "MessagingSpec.hx", lineNumber : 75, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				buddy_ShouldDynamic.should(iv247_intravenous_messaging_mock_MockCommand.message,__status6).get_not().be(message2,{ fileName : "MessagingSpec.hx", lineNumber : 76, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
			});
			_g.describe("execution order",function() {
				_g.syncBefore(function(__asyncDone7,__status7) {
					var mock2 = _g.injector.instantiate(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_messaging_mock_MockCommandOrder));
					message2 = new iv247_intravenous_messaging_mock_Message();
					message2.commandStack = [];
					_g.injector.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_messaging_mock_MockCommandOrder),mock2);
					_g.processor.mapCommand(iv247_intravenous_messaging_mock_MockCommandOrderInterceptor);
					_g.processor.mapCommand(iv247_intravenous_messaging_mock_MockCommandOrderCommand);
					_g.processor.dispatch(message2);
				});
				_g.syncIt("should execute interceptors first",function(__asyncDone8,__status8) {
					buddy_ShouldString.should(message2.commandStack[0],__status8).be("intercept",{ fileName : "MessagingSpec.hx", lineNumber : 93, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
					buddy_ShouldString.should(message2.commandStack[1],__status8).be("intercept",{ fileName : "MessagingSpec.hx", lineNumber : 94, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				});
				_g.syncIt("should execute commands second",function(__asyncDone9,__status9) {
					buddy_ShouldString.should(message2.commandStack[2],__status9).be("command",{ fileName : "MessagingSpec.hx", lineNumber : 99, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
					buddy_ShouldString.should(message2.commandStack[3],__status9).be("command",{ fileName : "MessagingSpec.hx", lineNumber : 100, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				});
				_g.syncIt("should execute command complete methods last",function(__asyncDone10,__status10) {
					buddy_ShouldString.should(message2.commandStack[4],__status10).be("complete",{ fileName : "MessagingSpec.hx", lineNumber : 104, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				});
			});
		});
		_g.describe("asynchronous commands",function() {
			_g.syncIt("should stop notification flow",function(__asyncDone11,__status11) {
				var message3 = new iv247_intravenous_messaging_mock_Message();
				var sequencer;
				_g.processor.mapCommand(iv247_intravenous_messaging_mock_MockAsyncCommand);
				message3.asyncResume = false;
				_g.processor.dispatch(message3);
				sequencer = _g.processor.openSequencers[0];
				buddy_ShouldDynamic.should(sequencer.stopped,__status11).be(true,{ fileName : "MessagingSpec.hx", lineNumber : 121, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
			});
			_g.syncIt("should be able to resume the notification flow",function(__asyncDone12,__status12) {
				var message4 = new iv247_intravenous_messaging_mock_Message();
				var sequencer1;
				_g.processor.mapCommand(iv247_intravenous_messaging_mock_MockAsyncCommand);
				message4.asyncResume = true;
				_g.processor.dispatch(message4);
				sequencer1 = _g.processor.openSequencers[0];
				buddy_ShouldDynamic.should(sequencer1.stopped,__status12).be(false,{ fileName : "MessagingSpec.hx", lineNumber : 133, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
			});
		});
		_g.describe("interceptors",function() {
			_g.syncIt("should be able to stop notification flow",function(__asyncDone13,__status13) {
				var message5 = new iv247_intravenous_messaging_mock_Message();
				_g.processor.mapCommand(iv247_intravenous_messaging_mock_CommandInterceptor);
				_g.processor.mapCommand(iv247_intravenous_messaging_mock_MockCommand);
				_g.processor.dispatch(message5);
				buddy_ShouldDynamic.should(iv247_intravenous_messaging_mock_MockCommand.message,__status13).get_not().be(message5,{ fileName : "MessagingSpec.hx", lineNumber : 143, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
			});
			_g.syncIt("should be able to resume notification flow",function(__asyncDone14,__status14) {
				var message6 = new iv247_intravenous_messaging_mock_Message();
				_g.processor.mapCommand(iv247_intravenous_messaging_mock_CommandInterceptor);
				_g.processor.mapCommand(iv247_intravenous_messaging_mock_MockCommand);
				_g.processor.dispatch(message6);
				buddy_ShouldDynamic.should(iv247_intravenous_messaging_mock_MockCommand.message,__status14).get_not().be(message6,{ fileName : "MessagingSpec.hx", lineNumber : 150, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				_g.processor.openSequencers[0].resume();
				buddy_ShouldDynamic.should(iv247_intravenous_messaging_mock_MockCommand.message,__status14).be(message6,{ fileName : "MessagingSpec.hx", lineNumber : 152, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
			});
		});
		_g.describe("command flow utilizing all features",function() {
			var message7;
			_g.syncBefore(function(__asyncDone15,__status15) {
				var controller = _g.injector.instantiate(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_messaging_mock_FullMessageFlowController));
				message7 = new iv247_intravenous_messaging_mock_FullMessageFlow();
				_g.injector.mapValue(iv247_intravenous_ioc_internal__$Injectable_Injectable_$Impl_$.fromDynamic(iv247_intravenous_messaging_mock_FullMessageFlowController),controller);
				_g.processor.mapCommand(iv247_intravenous_messaging_mock_FullMessageFlowCommand);
				_g.processor.mapCommand(iv247_intravenous_messaging_mock_FullMessageFlowInterceptor);
				_g.processor.dispatch(message7);
			});
			_g.syncIt("should call intercepts in the correct order",function(__asyncDone16,__status16) {
				buddy_ShouldString.should(message7.interceptors[0],__status16).be("firstInterceptor",{ fileName : "MessagingSpec.hx", lineNumber : 170, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				buddy_ShouldString.should(message7.interceptors[1],__status16).be("secondInterceptor",{ fileName : "MessagingSpec.hx", lineNumber : 171, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				buddy_ShouldString.should(message7.interceptors[2],__status16).be("thirdInterceptor",{ fileName : "MessagingSpec.hx", lineNumber : 172, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				buddy_ShouldString.should(message7.interceptors[3],__status16).be("fourthInterceptor",{ fileName : "MessagingSpec.hx", lineNumber : 173, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
			});
			_g.syncIt("should call commands in the correct order",function(__asyncDone17,__status17) {
				buddy_ShouldString.should(message7.commands[0],__status17).be("firstCommand",{ fileName : "MessagingSpec.hx", lineNumber : 177, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				buddy_ShouldString.should(message7.commands[1],__status17).be("secondCommand",{ fileName : "MessagingSpec.hx", lineNumber : 178, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				buddy_ShouldString.should(message7.commands[2],__status17).be("thirdCommand",{ fileName : "MessagingSpec.hx", lineNumber : 179, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				buddy_ShouldString.should(message7.commands[3],__status17).be("fourthCommand",{ fileName : "MessagingSpec.hx", lineNumber : 180, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
			});
			_g.syncIt("should call complete methods in the correct order",function(__asyncDone18,__status18) {
				buddy_ShouldString.should(message7.completeMethods[0],__status18).be("firstComplete",{ fileName : "MessagingSpec.hx", lineNumber : 184, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				buddy_ShouldString.should(message7.completeMethods[1],__status18).be("secondComplete",{ fileName : "MessagingSpec.hx", lineNumber : 185, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
				buddy_ShouldString.should(message7.completeMethods[2],__status18).be("thirdComplete",{ fileName : "MessagingSpec.hx", lineNumber : 186, className : "iv247.intravenous.messaging.MessagingSpec", methodName : "new"});
			});
		});
	});
};
$hxClasses["iv247.intravenous.messaging.MessagingSpec"] = iv247_intravenous_messaging_MessagingSpec;
iv247_intravenous_messaging_MessagingSpec.__name__ = ["iv247","intravenous","messaging","MessagingSpec"];
iv247_intravenous_messaging_MessagingSpec.__super__ = buddy_BuddySuite;
iv247_intravenous_messaging_MessagingSpec.prototype = $extend(buddy_BuddySuite.prototype,{
	__class__: iv247_intravenous_messaging_MessagingSpec
});
var iv247_intravenous_messaging_mock_FullMessageFlow = function() {
	this.interceptors = [];
	this.commands = [];
	this.completeMethods = [];
};
$hxClasses["iv247.intravenous.messaging.mock.FullMessageFlow"] = iv247_intravenous_messaging_mock_FullMessageFlow;
iv247_intravenous_messaging_mock_FullMessageFlow.__name__ = ["iv247","intravenous","messaging","mock","FullMessageFlow"];
iv247_intravenous_messaging_mock_FullMessageFlow.prototype = {
	__class__: iv247_intravenous_messaging_mock_FullMessageFlow
};
var iv247_intravenous_messaging_mock_FullMessageFlowController = function() {
};
$hxClasses["iv247.intravenous.messaging.mock.FullMessageFlowController"] = iv247_intravenous_messaging_mock_FullMessageFlowController;
iv247_intravenous_messaging_mock_FullMessageFlowController.__name__ = ["iv247","intravenous","messaging","mock","FullMessageFlowController"];
iv247_intravenous_messaging_mock_FullMessageFlowController.prototype = {
	firstInterceptor: function(msg,sequence) {
		msg.interceptors.push("firstInterceptor");
	}
	,secondInterceptor: function(msg,sequence) {
		msg.interceptors.push("secondInterceptor");
	}
	,fourthInterceptor: function(msg,sequence) {
		msg.interceptors.push("fourthInterceptor");
	}
	,firstCommand: function(msg) {
		msg.commands.push("firstCommand");
	}
	,secondCommand: function(msg,cb) {
		msg.commands.push("secondCommand");
	}
	,fourthCommand: function(msg) {
		msg.commands.push("fourthCommand");
	}
	,fistComplete: function(msg) {
		msg.completeMethods.push("firstComplete");
	}
	,secondComplete: function(msg,cb) {
		msg.completeMethods.push("secondComplete");
	}
	,thirdComplete: function(msg) {
		msg.completeMethods.push("thirdComplete");
	}
	,__class__: iv247_intravenous_messaging_mock_FullMessageFlowController
};
var iv247_intravenous_messaging_mock_FullMessageFlowInterceptor = function() {
};
$hxClasses["iv247.intravenous.messaging.mock.FullMessageFlowInterceptor"] = iv247_intravenous_messaging_mock_FullMessageFlowInterceptor;
iv247_intravenous_messaging_mock_FullMessageFlowInterceptor.__name__ = ["iv247","intravenous","messaging","mock","FullMessageFlowInterceptor"];
iv247_intravenous_messaging_mock_FullMessageFlowInterceptor.prototype = {
	execute: function(msg,sequence) {
		msg.interceptors.push("thirdInterceptor");
	}
	,__class__: iv247_intravenous_messaging_mock_FullMessageFlowInterceptor
};
var iv247_intravenous_messaging_mock_FullMessageFlowInterceptorTwo = function() {
};
$hxClasses["iv247.intravenous.messaging.mock.FullMessageFlowInterceptorTwo"] = iv247_intravenous_messaging_mock_FullMessageFlowInterceptorTwo;
iv247_intravenous_messaging_mock_FullMessageFlowInterceptorTwo.__name__ = ["iv247","intravenous","messaging","mock","FullMessageFlowInterceptorTwo"];
iv247_intravenous_messaging_mock_FullMessageFlowInterceptorTwo.prototype = {
	execute: function(msg,sequence) {
		msg.interceptors.push("thirdInterceptor");
	}
	,__class__: iv247_intravenous_messaging_mock_FullMessageFlowInterceptorTwo
};
var iv247_intravenous_messaging_mock_FullMessageFlowCommand = function() {
};
$hxClasses["iv247.intravenous.messaging.mock.FullMessageFlowCommand"] = iv247_intravenous_messaging_mock_FullMessageFlowCommand;
iv247_intravenous_messaging_mock_FullMessageFlowCommand.__name__ = ["iv247","intravenous","messaging","mock","FullMessageFlowCommand"];
iv247_intravenous_messaging_mock_FullMessageFlowCommand.prototype = {
	execute: function(msg) {
		msg.commands.push("thirdCommand");
	}
	,__class__: iv247_intravenous_messaging_mock_FullMessageFlowCommand
};
var iv247_intravenous_messaging_mock_Message = function() {
	this.commandStack = [];
};
$hxClasses["iv247.intravenous.messaging.mock.Message"] = iv247_intravenous_messaging_mock_Message;
iv247_intravenous_messaging_mock_Message.__name__ = ["iv247","intravenous","messaging","mock","Message"];
iv247_intravenous_messaging_mock_Message.prototype = {
	__class__: iv247_intravenous_messaging_mock_Message
};
var iv247_intravenous_messaging_mock_MockAsyncCommand = function() {
};
$hxClasses["iv247.intravenous.messaging.mock.MockAsyncCommand"] = iv247_intravenous_messaging_mock_MockAsyncCommand;
iv247_intravenous_messaging_mock_MockAsyncCommand.__name__ = ["iv247","intravenous","messaging","mock","MockAsyncCommand"];
iv247_intravenous_messaging_mock_MockAsyncCommand.prototype = {
	execute: function(msg,cb) {
		cb(msg.asyncResume);
	}
	,__class__: iv247_intravenous_messaging_mock_MockAsyncCommand
};
var iv247_intravenous_messaging_mock_MockCommand = function() {
	iv247_intravenous_messaging_mock_MockCommand.count++;
};
$hxClasses["iv247.intravenous.messaging.mock.MockCommand"] = iv247_intravenous_messaging_mock_MockCommand;
iv247_intravenous_messaging_mock_MockCommand.__name__ = ["iv247","intravenous","messaging","mock","MockCommand"];
iv247_intravenous_messaging_mock_MockCommand.message = null;
iv247_intravenous_messaging_mock_MockCommand.prototype = {
	execute: function(msg) {
		iv247_intravenous_messaging_mock_MockCommand.message = msg;
	}
	,__class__: iv247_intravenous_messaging_mock_MockCommand
};
var iv247_intravenous_messaging_mock_CommandInterceptor = function() {
};
$hxClasses["iv247.intravenous.messaging.mock.CommandInterceptor"] = iv247_intravenous_messaging_mock_CommandInterceptor;
iv247_intravenous_messaging_mock_CommandInterceptor.__name__ = ["iv247","intravenous","messaging","mock","CommandInterceptor"];
iv247_intravenous_messaging_mock_CommandInterceptor.prototype = {
	execute: function(msg,sequencer) {
		sequencer.stop();
	}
	,__class__: iv247_intravenous_messaging_mock_CommandInterceptor
};
var iv247_intravenous_messaging_mock_MockCommandOrder = function() {
};
$hxClasses["iv247.intravenous.messaging.mock.MockCommandOrder"] = iv247_intravenous_messaging_mock_MockCommandOrder;
iv247_intravenous_messaging_mock_MockCommandOrder.__name__ = ["iv247","intravenous","messaging","mock","MockCommandOrder"];
iv247_intravenous_messaging_mock_MockCommandOrder.prototype = {
	intercept: function(msg,process) {
		msg.commandStack.push("intercept");
	}
	,command: function(msg) {
		msg.commandStack.push("command");
	}
	,commandResult: function(msg) {
		msg.commandStack.push("complete");
	}
	,__class__: iv247_intravenous_messaging_mock_MockCommandOrder
};
var iv247_intravenous_messaging_mock_MockCommandOrderInterceptor = function() {
};
$hxClasses["iv247.intravenous.messaging.mock.MockCommandOrderInterceptor"] = iv247_intravenous_messaging_mock_MockCommandOrderInterceptor;
iv247_intravenous_messaging_mock_MockCommandOrderInterceptor.__name__ = ["iv247","intravenous","messaging","mock","MockCommandOrderInterceptor"];
iv247_intravenous_messaging_mock_MockCommandOrderInterceptor.prototype = {
	execute: function(msg,process) {
		msg.commandStack.push("intercept");
	}
	,__class__: iv247_intravenous_messaging_mock_MockCommandOrderInterceptor
};
var iv247_intravenous_messaging_mock_MockCommandOrderCommand = function() {
};
$hxClasses["iv247.intravenous.messaging.mock.MockCommandOrderCommand"] = iv247_intravenous_messaging_mock_MockCommandOrderCommand;
iv247_intravenous_messaging_mock_MockCommandOrderCommand.__name__ = ["iv247","intravenous","messaging","mock","MockCommandOrderCommand"];
iv247_intravenous_messaging_mock_MockCommandOrderCommand.prototype = {
	execute: function(msg) {
		msg.commandStack.push("command");
	}
	,__class__: iv247_intravenous_messaging_mock_MockCommandOrderCommand
};
var iv247_intravenous_messaging_mock_MockController = function() {
};
$hxClasses["iv247.intravenous.messaging.mock.MockController"] = iv247_intravenous_messaging_mock_MockController;
iv247_intravenous_messaging_mock_MockController.__name__ = ["iv247","intravenous","messaging","mock","MockController"];
iv247_intravenous_messaging_mock_MockController.prototype = {
	intercept: function(object,processor) {
		object.interceptCalled = true;
	}
	,commandHandler: function(object) {
		object.commandCalled = true;
	}
	,commandResult: function(object) {
		object.commandCompleteCalled = true;
	}
	,__class__: iv247_intravenous_messaging_mock_MockController
};
var iv247_intravenous_view_View = function() { };
$hxClasses["iv247.intravenous.view.View"] = iv247_intravenous_view_View;
iv247_intravenous_view_View.__name__ = ["iv247","intravenous","view","View"];
iv247_intravenous_view_View.prototype = {
	__class__: iv247_intravenous_view_View
};
var iv247_intravenous_view_DomView = function() {
};
$hxClasses["iv247.intravenous.view.DomView"] = iv247_intravenous_view_DomView;
iv247_intravenous_view_DomView.__name__ = ["iv247","intravenous","view","DomView"];
iv247_intravenous_view_DomView.__interfaces__ = [iv247_intravenous_view_View];
iv247_intravenous_view_DomView.prototype = {
	add: function(view) {
	}
	,remove: function(view) {
	}
	,children: function() {
		return [];
	}
	,__class__: iv247_intravenous_view_DomView
};
var iv247_util_macro_TypeInfo = function() { };
$hxClasses["iv247.util.macro.TypeInfo"] = iv247_util_macro_TypeInfo;
iv247_util_macro_TypeInfo.__name__ = ["iv247","util","macro","TypeInfo"];
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
$hxClasses["js._Boot.HaxeError"] = js__$Boot_HaxeError;
js__$Boot_HaxeError.__name__ = ["js","_Boot","HaxeError"];
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
$hxClasses["js.Boot"] = js_Boot;
js_Boot.__name__ = ["js","Boot"];
js_Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
};
js_Boot.__trace = function(v,i) {
	var msg;
	if(i != null) msg = i.fileName + ":" + i.lineNumber + ": "; else msg = "";
	msg += js_Boot.__string_rec(v,"");
	if(i != null && i.customParams != null) {
		var _g = 0;
		var _g1 = i.customParams;
		while(_g < _g1.length) {
			var v1 = _g1[_g];
			++_g;
			msg += "," + js_Boot.__string_rec(v1,"");
		}
	}
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js_Boot.__unhtml(msg) + "<br/>"; else if(typeof console != "undefined" && console.log != null) console.log(msg);
};
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			haxe_CallStack.lastException = e;
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__cast = function(o,t) {
	if(js_Boot.__instanceof(o,t)) return o; else throw new js__$Boot_HaxeError("Cannot cast " + Std.string(o) + " to " + Std.string(t));
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	if(typeof window != "undefined") return window[name]; else return global[name];
};
var promhx_base_AsyncBase = function(d) {
	this._resolved = false;
	this._pending = false;
	this._errorPending = false;
	this._fulfilled = false;
	this._update = [];
	this._error = [];
	this._errored = false;
	if(d != null) promhx_base_AsyncBase.link(d,this,function(x) {
		return x;
	});
};
$hxClasses["promhx.base.AsyncBase"] = promhx_base_AsyncBase;
promhx_base_AsyncBase.__name__ = ["promhx","base","AsyncBase"];
promhx_base_AsyncBase.link = function(current,next,f) {
	current._update.push({ async : next, linkf : function(x) {
		next.handleResolve(f(x));
	}});
	promhx_base_AsyncBase.immediateLinkUpdate(current,next,f);
};
promhx_base_AsyncBase.immediateLinkUpdate = function(current,next,f) {
	if(current._errored) next.handleError(current._errorVal);
	if(current._resolved && !current._pending) try {
		next.handleResolve(f(current._val));
	} catch( e ) {
		haxe_CallStack.lastException = e;
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		next.handleError(e);
	}
};
promhx_base_AsyncBase.linkAll = function(all,next) {
	var cthen = function(arr,current,v) {
		if(arr.length == 0 || promhx_base_AsyncBase.allFulfilled(arr)) {
			var vals;
			var _g = [];
			var $it0 = $iterator(all)();
			while( $it0.hasNext() ) {
				var a = $it0.next();
				_g.push(a == current?v:a._val);
			}
			vals = _g;
			next.handleResolve(vals);
		}
		null;
		return;
	};
	var $it1 = $iterator(all)();
	while( $it1.hasNext() ) {
		var a1 = $it1.next();
		a1._update.push({ async : next, linkf : (function(f,a11,a2) {
			return function(v1) {
				f(a11,a2,v1);
				return;
			};
		})(cthen,(function($this) {
			var $r;
			var _g1 = [];
			var $it2 = $iterator(all)();
			while( $it2.hasNext() ) {
				var a21 = $it2.next();
				if(a21 != a1) _g1.push(a21);
			}
			$r = _g1;
			return $r;
		}(this)),a1)});
	}
	if(promhx_base_AsyncBase.allFulfilled(all)) next.handleResolve((function($this) {
		var $r;
		var _g2 = [];
		var $it3 = $iterator(all)();
		while( $it3.hasNext() ) {
			var a3 = $it3.next();
			_g2.push(a3._val);
		}
		$r = _g2;
		return $r;
	}(this)));
};
promhx_base_AsyncBase.pipeLink = function(current,ret,f) {
	var linked = false;
	var linkf = function(x) {
		if(!linked) {
			linked = true;
			var pipe_ret = f(x);
			pipe_ret._update.push({ async : ret, linkf : $bind(ret,ret.handleResolve)});
			promhx_base_AsyncBase.immediateLinkUpdate(pipe_ret,ret,function(x1) {
				return x1;
			});
		}
	};
	current._update.push({ async : ret, linkf : linkf});
	if(current._resolved && !current._pending) try {
		linkf(current._val);
	} catch( e ) {
		haxe_CallStack.lastException = e;
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		ret.handleError(e);
	}
};
promhx_base_AsyncBase.allResolved = function($as) {
	var $it0 = $iterator($as)();
	while( $it0.hasNext() ) {
		var a = $it0.next();
		if(!a._resolved) return false;
	}
	return true;
};
promhx_base_AsyncBase.allFulfilled = function($as) {
	var $it0 = $iterator($as)();
	while( $it0.hasNext() ) {
		var a = $it0.next();
		if(!a._fulfilled) return false;
	}
	return true;
};
promhx_base_AsyncBase.prototype = {
	catchError: function(f) {
		this._error.push(f);
		return this;
	}
	,errorThen: function(f) {
		this._errorMap = f;
		return this;
	}
	,isResolved: function() {
		return this._resolved;
	}
	,isErrored: function() {
		return this._errored;
	}
	,isFulfilled: function() {
		return this._fulfilled;
	}
	,isPending: function() {
		return this._pending;
	}
	,handleResolve: function(val) {
		this._resolve(val);
	}
	,_resolve: function(val) {
		var _g = this;
		if(this._pending) promhx_base_EventLoop.enqueue((function(f,a1) {
			return function() {
				f(a1);
			};
		})($bind(this,this._resolve),val)); else {
			this._resolved = true;
			this._pending = true;
			promhx_base_EventLoop.queue.add(function() {
				_g._val = val;
				var _g1 = 0;
				var _g2 = _g._update;
				while(_g1 < _g2.length) {
					var up = _g2[_g1];
					++_g1;
					try {
						up.linkf(val);
					} catch( e ) {
						haxe_CallStack.lastException = e;
						if (e instanceof js__$Boot_HaxeError) e = e.val;
						up.async.handleError(e);
					}
				}
				_g._fulfilled = true;
				_g._pending = false;
			});
			promhx_base_EventLoop.continueOnNextLoop();
		}
	}
	,handleError: function(error) {
		this._handleError(error);
	}
	,_handleError: function(error) {
		var _g = this;
		var update_errors = function(e) {
			if(_g._error.length > 0) {
				var _g1 = 0;
				var _g2 = _g._error;
				while(_g1 < _g2.length) {
					var ef = _g2[_g1];
					++_g1;
					ef(e);
				}
			} else if(_g._update.length > 0) {
				var _g11 = 0;
				var _g21 = _g._update;
				while(_g11 < _g21.length) {
					var up = _g21[_g11];
					++_g11;
					up.async.handleError(e);
				}
			} else throw new js__$Boot_HaxeError(e);
			_g._errorPending = false;
		};
		if(!this._errorPending) {
			this._errorPending = true;
			this._errored = true;
			this._errorVal = error;
			promhx_base_EventLoop.queue.add(function() {
				if(_g._errorMap != null) try {
					_g._resolve(_g._errorMap(error));
				} catch( e1 ) {
					haxe_CallStack.lastException = e1;
					if (e1 instanceof js__$Boot_HaxeError) e1 = e1.val;
					update_errors(e1);
				} else update_errors(error);
			});
			promhx_base_EventLoop.continueOnNextLoop();
		}
	}
	,then: function(f) {
		var ret = new promhx_base_AsyncBase();
		promhx_base_AsyncBase.link(this,ret,f);
		return ret;
	}
	,unlink: function(to) {
		var _g = this;
		promhx_base_EventLoop.queue.add(function() {
			_g._update = _g._update.filter(function(x) {
				return x.async != to;
			});
		});
		promhx_base_EventLoop.continueOnNextLoop();
	}
	,isLinked: function(to) {
		var updated = false;
		var _g = 0;
		var _g1 = this._update;
		while(_g < _g1.length) {
			var u = _g1[_g];
			++_g;
			if(u.async == to) return true;
		}
		return updated;
	}
	,__class__: promhx_base_AsyncBase
};
var promhx_Deferred = $hx_exports.promhx.Deferred = function() {
	promhx_base_AsyncBase.call(this);
};
$hxClasses["promhx.Deferred"] = promhx_Deferred;
promhx_Deferred.__name__ = ["promhx","Deferred"];
promhx_Deferred.__super__ = promhx_base_AsyncBase;
promhx_Deferred.prototype = $extend(promhx_base_AsyncBase.prototype,{
	resolve: function(val) {
		this.handleResolve(val);
	}
	,throwError: function(e) {
		this.handleError(e);
	}
	,promise: function() {
		return new promhx_Promise(this);
	}
	,stream: function() {
		return new promhx_Stream(this);
	}
	,publicStream: function() {
		return new promhx_PublicStream(this);
	}
	,__class__: promhx_Deferred
});
var promhx_Promise = $hx_exports.promhx.Promise = function(d) {
	promhx_base_AsyncBase.call(this,d);
	this._rejected = false;
};
$hxClasses["promhx.Promise"] = promhx_Promise;
promhx_Promise.__name__ = ["promhx","Promise"];
promhx_Promise.whenAll = function(itb) {
	var ret = new promhx_Promise();
	promhx_base_AsyncBase.linkAll(itb,ret);
	return ret;
};
promhx_Promise.promise = function(_val) {
	var ret = new promhx_Promise();
	ret.handleResolve(_val);
	return ret;
};
promhx_Promise.__super__ = promhx_base_AsyncBase;
promhx_Promise.prototype = $extend(promhx_base_AsyncBase.prototype,{
	isRejected: function() {
		return this._rejected;
	}
	,reject: function(e) {
		this._rejected = true;
		this.handleError(e);
	}
	,handleResolve: function(val) {
		if(this._resolved) {
			var msg = "Promise has already been resolved";
			throw new js__$Boot_HaxeError(promhx_error_PromiseError.AlreadyResolved(msg));
		}
		this._resolve(val);
	}
	,then: function(f) {
		var ret = new promhx_Promise();
		promhx_base_AsyncBase.link(this,ret,f);
		return ret;
	}
	,unlink: function(to) {
		var _g = this;
		promhx_base_EventLoop.queue.add(function() {
			if(!_g._fulfilled) {
				var msg = "Downstream Promise is not fullfilled";
				_g.handleError(promhx_error_PromiseError.DownstreamNotFullfilled(msg));
			} else _g._update = _g._update.filter(function(x) {
				return x.async != to;
			});
		});
		promhx_base_EventLoop.continueOnNextLoop();
	}
	,handleError: function(error) {
		this._rejected = true;
		this._handleError(error);
	}
	,pipe: function(f) {
		var ret = new promhx_Promise();
		promhx_base_AsyncBase.pipeLink(this,ret,f);
		return ret;
	}
	,errorPipe: function(f) {
		var ret = new promhx_Promise();
		this.catchError(function(e) {
			var piped = f(e);
			piped.then($bind(ret,ret._resolve));
		});
		this.then($bind(ret,ret._resolve));
		return ret;
	}
	,__class__: promhx_Promise
});
var promhx_Stream = $hx_exports.promhx.Stream = function(d) {
	promhx_base_AsyncBase.call(this,d);
	this._end_deferred = new promhx_Deferred();
	this._end_promise = this._end_deferred.promise();
};
$hxClasses["promhx.Stream"] = promhx_Stream;
promhx_Stream.__name__ = ["promhx","Stream"];
promhx_Stream.foreach = function(itb) {
	var s = new promhx_Stream();
	var $it0 = $iterator(itb)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		s.handleResolve(i);
	}
	s.end();
	return s;
};
promhx_Stream.wheneverAll = function(itb) {
	var ret = new promhx_Stream();
	promhx_base_AsyncBase.linkAll(itb,ret);
	return ret;
};
promhx_Stream.concatAll = function(itb) {
	var ret = new promhx_Stream();
	var $it0 = $iterator(itb)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		ret.concat(i);
	}
	return ret;
};
promhx_Stream.mergeAll = function(itb) {
	var ret = new promhx_Stream();
	var $it0 = $iterator(itb)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		ret.merge(i);
	}
	return ret;
};
promhx_Stream.stream = function(_val) {
	var ret = new promhx_Stream();
	ret.handleResolve(_val);
	return ret;
};
promhx_Stream.__super__ = promhx_base_AsyncBase;
promhx_Stream.prototype = $extend(promhx_base_AsyncBase.prototype,{
	then: function(f) {
		var ret = new promhx_Stream();
		promhx_base_AsyncBase.link(this,ret,f);
		this._end_promise.then(function(x) {
			ret.end();
		});
		return ret;
	}
	,detachStream: function(str) {
		var filtered = [];
		var removed = false;
		var _g = 0;
		var _g1 = this._update;
		while(_g < _g1.length) {
			var u = _g1[_g];
			++_g;
			if(u.async == str) removed = true; else filtered.push(u);
		}
		this._update = filtered;
		return removed;
	}
	,first: function() {
		var s = new promhx_Promise();
		this.then(function(x) {
			if(!s._resolved) s.handleResolve(x);
		});
		return s;
	}
	,handleResolve: function(val) {
		if(!this._end && !this._pause) this._resolve(val);
	}
	,pause: function(set) {
		if(set == null) set = !this._pause;
		this._pause = set;
	}
	,pipe: function(f) {
		var ret = new promhx_Stream();
		promhx_base_AsyncBase.pipeLink(this,ret,f);
		this._end_promise.then(function(x) {
			ret.end();
		});
		return ret;
	}
	,errorPipe: function(f) {
		var ret = new promhx_Stream();
		this.catchError(function(e) {
			var piped = f(e);
			piped.then($bind(ret,ret._resolve));
			piped._end_promise.then(($_=ret._end_promise,$bind($_,$_._resolve)));
		});
		this.then($bind(ret,ret._resolve));
		this._end_promise.then(function(x) {
			ret.end();
		});
		return ret;
	}
	,handleEnd: function() {
		if(this._pending) {
			promhx_base_EventLoop.queue.add($bind(this,this.handleEnd));
			promhx_base_EventLoop.continueOnNextLoop();
		} else if(this._end_promise._resolved) return; else {
			this._end = true;
			var o;
			if(this._resolved) o = haxe_ds_Option.Some(this._val); else o = haxe_ds_Option.None;
			this._end_promise.handleResolve(o);
			this._update = [];
			this._error = [];
		}
	}
	,end: function() {
		promhx_base_EventLoop.queue.add($bind(this,this.handleEnd));
		promhx_base_EventLoop.continueOnNextLoop();
		return this;
	}
	,endThen: function(f) {
		return this._end_promise.then(f);
	}
	,filter: function(f) {
		var ret = new promhx_Stream();
		this._update.push({ async : ret, linkf : function(x) {
			if(f(x)) ret.handleResolve(x);
		}});
		promhx_base_AsyncBase.immediateLinkUpdate(this,ret,function(x1) {
			return x1;
		});
		return ret;
	}
	,concat: function(s) {
		var ret = new promhx_Stream();
		this._update.push({ async : ret, linkf : $bind(ret,ret.handleResolve)});
		promhx_base_AsyncBase.immediateLinkUpdate(this,ret,function(x) {
			return x;
		});
		this._end_promise.then(function(_) {
			s.pipe(function(x1) {
				ret.handleResolve(x1);
				return ret;
			});
			s._end_promise.then(function(_1) {
				ret.end();
			});
		});
		return ret;
	}
	,merge: function(s) {
		var ret = new promhx_Stream();
		this._update.push({ async : ret, linkf : $bind(ret,ret.handleResolve)});
		s._update.push({ async : ret, linkf : $bind(ret,ret.handleResolve)});
		promhx_base_AsyncBase.immediateLinkUpdate(this,ret,function(x) {
			return x;
		});
		promhx_base_AsyncBase.immediateLinkUpdate(s,ret,function(x1) {
			return x1;
		});
		return ret;
	}
	,__class__: promhx_Stream
});
var promhx_PublicStream = $hx_exports.promhx.PublicStream = function(def) {
	promhx_Stream.call(this,def);
};
$hxClasses["promhx.PublicStream"] = promhx_PublicStream;
promhx_PublicStream.__name__ = ["promhx","PublicStream"];
promhx_PublicStream.publicstream = function(val) {
	var ps = new promhx_PublicStream();
	ps.handleResolve(val);
	return ps;
};
promhx_PublicStream.__super__ = promhx_Stream;
promhx_PublicStream.prototype = $extend(promhx_Stream.prototype,{
	resolve: function(val) {
		this.handleResolve(val);
	}
	,throwError: function(e) {
		this.handleError(e);
	}
	,update: function(val) {
		this.handleResolve(val);
	}
	,__class__: promhx_PublicStream
});
var promhx_base_EventLoop = function() { };
$hxClasses["promhx.base.EventLoop"] = promhx_base_EventLoop;
promhx_base_EventLoop.__name__ = ["promhx","base","EventLoop"];
promhx_base_EventLoop.nextLoop = null;
promhx_base_EventLoop.enqueue = function(eqf) {
	promhx_base_EventLoop.queue.add(eqf);
	promhx_base_EventLoop.continueOnNextLoop();
};
promhx_base_EventLoop.set_nextLoop = function(f) {
	if(promhx_base_EventLoop.nextLoop != null) throw new js__$Boot_HaxeError("nextLoop has already been set"); else promhx_base_EventLoop.nextLoop = f;
	return promhx_base_EventLoop.nextLoop;
};
promhx_base_EventLoop.queueEmpty = function() {
	return promhx_base_EventLoop.queue.isEmpty();
};
promhx_base_EventLoop.finish = function(max_iterations) {
	if(max_iterations == null) max_iterations = 1000;
	var fn = null;
	while(max_iterations-- > 0 && (fn = promhx_base_EventLoop.queue.pop()) != null) fn();
	return promhx_base_EventLoop.queue.isEmpty();
};
promhx_base_EventLoop.clear = function() {
	promhx_base_EventLoop.queue = new List();
};
promhx_base_EventLoop.f = function() {
	var fn = promhx_base_EventLoop.queue.pop();
	if(fn != null) fn();
	if(!promhx_base_EventLoop.queue.isEmpty()) promhx_base_EventLoop.continueOnNextLoop();
};
promhx_base_EventLoop.continueOnNextLoop = function() {
	if(promhx_base_EventLoop.nextLoop != null) promhx_base_EventLoop.nextLoop(promhx_base_EventLoop.f); else setImmediate(promhx_base_EventLoop.f);
};
var promhx_error_PromiseError = $hxClasses["promhx.error.PromiseError"] = { __ename__ : ["promhx","error","PromiseError"], __constructs__ : ["AlreadyResolved","DownstreamNotFullfilled"] };
promhx_error_PromiseError.AlreadyResolved = function(message) { var $x = ["AlreadyResolved",0,message]; $x.__enum__ = promhx_error_PromiseError; $x.toString = $estr; return $x; };
promhx_error_PromiseError.DownstreamNotFullfilled = function(message) { var $x = ["DownstreamNotFullfilled",1,message]; $x.__enum__ = promhx_error_PromiseError; $x.toString = $estr; return $x; };
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
$hxClasses.Math = Math;
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
$hxClasses.Array = Array;
Array.__name__ = ["Array"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = $hxClasses.Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
if(Array.prototype.filter == null) Array.prototype.filter = function(f1) {
	var a1 = [];
	var _g11 = 0;
	var _g2 = this.length;
	while(_g11 < _g2) {
		var i1 = _g11++;
		var e = this[i1];
		if(f1(e)) a1.push(e);
	}
	return a1;
};
var __map_reserved = {}
var global = window;
(function (global, undefined) {
    "use strict";

    var tasks = (function () {
        function Task(handler, args) {
            this.handler = handler;
            this.args = args;
        }
        Task.prototype.run = function () {
            // See steps in section 5 of the spec.
            if (typeof this.handler === "function") {
                // Choice of `thisArg` is not in the setImmediate spec; `undefined` is in the setTimeout spec though:
                // http://www.whatwg.org/specs/web-apps/current-work/multipage/timers.html
                this.handler.apply(undefined, this.args);
            } else {
                var scriptSource = "" + this.handler;
                /*jshint evil: true */
                eval(scriptSource);
            }
        };

        var nextHandle = 1; // Spec says greater than zero
        var tasksByHandle = {};
        var currentlyRunningATask = false;

        return {
            addFromSetImmediateArguments: function (args) {
                var handler = args[0];
                var argsToHandle = Array.prototype.slice.call(args, 1);
                var task = new Task(handler, argsToHandle);

                var thisHandle = nextHandle++;
                tasksByHandle[thisHandle] = task;
                return thisHandle;
            },
            runIfPresent: function (handle) {
                // From the spec: "Wait until any invocations of this algorithm started before this one have completed."
                // So if we're currently running a task, we'll need to delay this invocation.
                if (!currentlyRunningATask) {
                    var task = tasksByHandle[handle];
                    if (task) {
                        currentlyRunningATask = true;
                        try {
                            task.run();
                        } finally {
                            delete tasksByHandle[handle];
                            currentlyRunningATask = false;
                        }
                    }
                } else {
                    // Delay by doing a setTimeout. setImmediate was tried instead, but in Firefox 7 it generated a
                    // "too much recursion" error.
                    global.setTimeout(function () {
                        tasks.runIfPresent(handle);
                    }, 0);
                }
            },
            remove: function (handle) {
                delete tasksByHandle[handle];
            }
        };
    }());

    function canUseNextTick() {
        // Don't get fooled by e.g. browserify environments.
        return typeof process === "object" &&
               Object.prototype.toString.call(process) === "[object process]";
    }

    function canUseMessageChannel() {
        return !!global.MessageChannel;
    }

    function canUsePostMessage() {
        // The test against `importScripts` prevents this implementation from being installed inside a web worker,
        // where `global.postMessage` means something completely different and can't be used for this purpose.

        if (!global.postMessage || global.importScripts) {
            return false;
        }

        var postMessageIsAsynchronous = true;
        var oldOnMessage = global.onmessage;
        global.onmessage = function () {
            postMessageIsAsynchronous = false;
        };
        global.postMessage("", "*");
        global.onmessage = oldOnMessage;

        return postMessageIsAsynchronous;
    }

    function canUseReadyStateChange() {
        return "document" in global && "onreadystatechange" in global.document.createElement("script");
    }

    function installNextTickImplementation(attachTo) {
        attachTo.setImmediate = function () {
            var handle = tasks.addFromSetImmediateArguments(arguments);

            process.nextTick(function () {
                tasks.runIfPresent(handle);
            });

            return handle;
        };
    }

    function installMessageChannelImplementation(attachTo) {
        var channel = new global.MessageChannel();
        channel.port1.onmessage = function (event) {
            var handle = event.data;
            tasks.runIfPresent(handle);
        };
        attachTo.setImmediate = function () {
            var handle = tasks.addFromSetImmediateArguments(arguments);

            channel.port2.postMessage(handle);

            return handle;
        };
    }

    function installPostMessageImplementation(attachTo) {
        // Installs an event handler on `global` for the `message` event: see
        // * https://developer.mozilla.org/en/DOM/window.postMessage
        // * http://www.whatwg.org/specs/web-apps/current-work/multipage/comms.html#crossDocumentMessages

        var MESSAGE_PREFIX = "com.bn.NobleJS.setImmediate" + Math.random();

        function isStringAndStartsWith(string, putativeStart) {
            return typeof string === "string" && string.substring(0, putativeStart.length) === putativeStart;
        }

        function onGlobalMessage(event) {
            // This will catch all incoming messages (even from other windows!), so we need to try reasonably hard to
            // avoid letting anyone else trick us into firing off. We test the origin is still this window, and that a
            // (randomly generated) unpredictable identifying prefix is present.
            if (event.source === global && isStringAndStartsWith(event.data, MESSAGE_PREFIX)) {
                var handle = event.data.substring(MESSAGE_PREFIX.length);
                tasks.runIfPresent(handle);
            }
        }
        if (global.addEventListener) {
            global.addEventListener("message", onGlobalMessage, false);
        } else {
            global.attachEvent("onmessage", onGlobalMessage);
        }

        attachTo.setImmediate = function () {
            var handle = tasks.addFromSetImmediateArguments(arguments);

            // Make `global` post a message to itself with the handle and identifying prefix, thus asynchronously
            // invoking our onGlobalMessage listener above.
            global.postMessage(MESSAGE_PREFIX + handle, "*");

            return handle;
        };
    }

    function installReadyStateChangeImplementation(attachTo) {
        attachTo.setImmediate = function () {
            var handle = tasks.addFromSetImmediateArguments(arguments);

            // Create a <script> element; its readystatechange event will be fired asynchronously once it is inserted
            // into the document. Do so, thus queuing up the task. Remember to clean up once it's been called.
            var scriptEl = global.document.createElement("script");
            scriptEl.onreadystatechange = function () {
                tasks.runIfPresent(handle);

                scriptEl.onreadystatechange = null;
                scriptEl.parentNode.removeChild(scriptEl);
                scriptEl = null;
            };
            global.document.documentElement.appendChild(scriptEl);

            return handle;
        };
    }

    function installSetTimeoutImplementation(attachTo) {
        attachTo.setImmediate = function () {
            var handle = tasks.addFromSetImmediateArguments(arguments);

            global.setTimeout(function () {
                tasks.runIfPresent(handle);
            }, 0);

            return handle;
        };
    }

    if (!global.setImmediate) {
        // If supported, we should attach to the prototype of global, since that is where setTimeout et al. live.
        var attachTo = typeof Object.getPrototypeOf === "function" && "setTimeout" in Object.getPrototypeOf(global) ?
                          Object.getPrototypeOf(global)
                        : global;

        if (canUseNextTick()) {
            // For Node.js before 0.9
            installNextTickImplementation(attachTo);
        } else if (canUsePostMessage()) {
            // For non-IE10 modern browsers
            installPostMessageImplementation(attachTo);
        } else if (canUseMessageChannel()) {
            // For web workers, where supported
            installMessageChannelImplementation(attachTo);
        } else if (canUseReadyStateChange()) {
            // For IE 6–8
            installReadyStateChangeImplementation(attachTo);
        } else {
            // For older browsers
            installSetTimeoutImplementation(attachTo);
        }

        attachTo.clearImmediate = tasks.remove;
    }
}(typeof global === "object" && global ? global : this));
;
buddy_BuddySuite.exclude = "exclude";
buddy_BuddySuite.include = "include";
TestMain.__meta__ = { obj : { autoIncluded : ["TestMain","iv247.intravenous.ContextSpec","iv247.intravenous.ioc.ChildInjectorSpec","iv247.intravenous.ioc.EnumSupportSpec","iv247.intravenous.ioc.ExtensionSpec","iv247.intravenous.ioc.InjectionsSpec","iv247.intravenous.ioc.SandboxTest","iv247.intravenous.ioc.IVMappingTest","iv247.intravenous.ioc.PostInjectionSpec","iv247.intravenous.messaging.MessagingSpec"]}};
iv247_intravenous_ioc_mock_InjectionMock.__meta__ = { fields : { injectedObject : { types : ["iv247.intravenous.ioc.mock.InjectedObject"], inject : null}, injectedObjectWithId : { types : ["iv247.intravenous.ioc.mock.InjectedObject"], inject : ["injectedObjectId"]}, injectableMethod : { types : [{ opt : false, type : "iv247.intravenous.ioc.mock.InjectedObject"}], inject : null}, injectableMethodWithId : { types : [{ opt : false, type : "iv247.intravenous.ioc.mock.InjectedObject"},{ opt : false, type : "iv247.intravenous.ioc.mock.InjectedObject"}], inject : [null,"injectedObjectId"]}, injectableMethodWithOptionalArg : { types : [{ opt : false, type : "iv247.intravenous.ioc.mock.InjectedObject"},{ opt : true, type : "iv247.intravenous.ioc.mock.InjectedObject"}], inject : ["injectedObjectId"]}, postInjectMethod : { types : [{ opt : false, type : "iv247.intravenous.ioc.mock.InjectedObject"}], post : ["postInjectId"]}, anotherPostInjectMethod : { types : [{ opt : false, type : "iv247.intravenous.ioc.mock.InjectedObject"}], post : null}, _ : { types : null, inject : null}}};
iv247_intravenous_ioc_mock_SubClassInjectionMock.__meta__ = { fields : { postInjectMethod : { types : [{ opt : false, type : "iv247.intravenous.ioc.mock.InjectedObject"}], post : ["postInjectId"]}}};
iv247_intravenous_ioc_mock_CtorInjectionMock.__meta__ = { fields : { _ : { types : [{ opt : false, type : "iv247.intravenous.ioc.mock.InjectedObject"},{ opt : false, type : "iv247.intravenous.ioc.mock.InjectedObject"}], inject : [null,"injectedObjectId"]}}};
iv247_intravenous_ioc_mock_InjectionMockWEnum.__meta__ = { fields : { injectedEnum : { types : ["iv247.intravenous.ioc.mock.MockEnum"], inject : null}, injectedEnumCtor : { types : ["iv247.intravenous.ioc.mock.MockEnum"], inject : ["injectEnumCtorId"]}, _ : { types : [{ opt : false, type : "iv247.intravenous.ioc.mock.MockEnum"},{ opt : false, type : "iv247.intravenous.ioc.mock.MockEnum"}], inject : ["injectEnumCtorId"]}}};
iv247_intravenous_ioc_mock_MockConstructorArg.__meta__ = { fields : { _ : { types : [{ opt : false, type : "iv247.intravenous.ioc.mock.MockObject"}], inject : null}}};
iv247_intravenous_ioc_mock_WithId.__meta__ = { fields : { _ : { types : [{ opt : false, type : "iv247.intravenous.ioc.mock.MockObject"},{ opt : false, type : "iv247.intravenous.ioc.mock.MockObject"},{ opt : true, type : "iv247.intravenous.ioc.mock.MockObject"}], inject : ["mockId","mockId2",null]}}};
iv247_intravenous_ioc_mock_MockExtensionObject.__meta__ = { fields : { extension : { types : ["iv247.intravenous.ioc.mock.InjectedObject"], extension : null, inject : null}, extension2 : { types : ["iv247.intravenous.ioc.mock.InjectedObject"], extension : null}, mockMethod : { types : [{ opt : false, type : "iv247.intravenous.ioc.mock.InjectedObject"}], extensionMethod : null}}};
iv247_intravenous_ioc_mock_MockCtorExtensionObject.__meta__ = { fields : { _ : { types : null, extension : null}}};
iv247_intravenous_messaging_MessageProcessor.DISPATCHER_META = "dispatcher";
iv247_intravenous_messaging_mock_FullMessageFlowController.__meta__ = { fields : { firstInterceptor : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"},{ opt : false, type : "iv247.intravenous.messaging.CommandSequencer"}], intercept : null, command : null}, secondInterceptor : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"},{ opt : false, type : "iv247.intravenous.messaging.CommandSequencer"}], intercept : null, command : [1]}, fourthInterceptor : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"},{ opt : false, type : "iv247.intravenous.messaging.CommandSequencer"}], intercept : null, command : [3]}, firstCommand : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"}], command : null}, secondCommand : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"},{ opt : false, type : "iv247.intravenous.messaging.CallbackFunction"}], command : [1]}, fourthCommand : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"}], command : [3]}, fistComplete : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"}], commandComplete : [0]}, secondComplete : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"},{ opt : false, type : "iv247.intravenous.messaging.CallbackFunction"}], commandComplete : [1]}, thirdComplete : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"}], commandComplete : [2]}}};
iv247_intravenous_messaging_mock_FullMessageFlowInterceptor.__meta__ = { obj : { messageTypes : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"},{ opt : false, type : "iv247.intravenous.messaging.CommandSequencer"}], intercept : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"},{ opt : false, type : "iv247.intravenous.messaging.CommandSequencer"}], command : [2]}};
iv247_intravenous_messaging_mock_FullMessageFlowInterceptorTwo.__meta__ = { obj : { messageTypes : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"},{ opt : false, type : "iv247.intravenous.messaging.CommandSequencer"}], intercept : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"},{ opt : false, type : "iv247.intravenous.messaging.CommandSequencer"}], command : [2]}};
iv247_intravenous_messaging_mock_FullMessageFlowCommand.__meta__ = { obj : { messageTypes : [{ opt : false, type : "iv247.intravenous.messaging.mock.FullMessageFlow"}], command : [2]}};
iv247_intravenous_messaging_mock_MockAsyncCommand.__meta__ = { obj : { messageTypes : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"},{ opt : false, type : "iv247.intravenous.messaging.CallbackFunction"}], async : null, command : null}};
iv247_intravenous_messaging_mock_MockCommand.__meta__ = { obj : { messageTypes : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"}], command : [1]}};
iv247_intravenous_messaging_mock_MockCommand.count = 0;
iv247_intravenous_messaging_mock_CommandInterceptor.__meta__ = { obj : { messageTypes : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"},{ opt : false, type : "iv247.intravenous.messaging.CommandSequencer"}], intercept : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"},{ opt : false, type : "iv247.intravenous.messaging.CommandSequencer"}], command : null}};
iv247_intravenous_messaging_mock_MockCommandOrder.__meta__ = { fields : { intercept : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"},{ opt : false, type : "iv247.intravenous.messaging.CommandSequencer"}], intercept : null, command : null}, command : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"}], command : null}, commandResult : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"}], commandComplete : null}}};
iv247_intravenous_messaging_mock_MockCommandOrderInterceptor.__meta__ = { obj : { messageTypes : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"},{ opt : false, type : "iv247.intravenous.messaging.CommandSequencer"}], intercept : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"},{ opt : false, type : "iv247.intravenous.messaging.CommandSequencer"}], command : null}};
iv247_intravenous_messaging_mock_MockCommandOrderCommand.__meta__ = { obj : { messageTypes : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"}], command : null}};
iv247_intravenous_messaging_mock_MockController.__meta__ = { fields : { intercept : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"},{ opt : false, type : "iv247.intravenous.messaging.MessageProcessor"}], command : null}, commandHandler : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"}], command : null}, commandResult : { types : [{ opt : false, type : "iv247.intravenous.messaging.mock.Message"}], commandComplete : null}}};
iv247_intravenous_view_DomView.__meta__ = { fields : { dispatch : { dispatcher : null}}};
js_Boot.__toStr = {}.toString;
promhx_base_EventLoop.queue = new List();
TestMain.main();
})(typeof console != "undefined" ? console : {log:function(){}}, typeof window != "undefined" ? window : exports);
