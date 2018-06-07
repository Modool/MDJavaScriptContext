
function function1(){
    return "1";
}

function function2(arg1){
    return "2";
}

function function3(arg1, arg2){
    return "3";
}

function function4(arg1){
    return "4";
}

function function5(arg1, arg2){
    return "5";
}

function function6(arg1){
    return arg1;
}


var property1 = 10;
var object_import1 = {function6:function (){ return 6 }};

var object_import = {object_property:object_import1};
