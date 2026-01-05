/*

int indexed overload set example code

this is how tile should be used and why I made those demands on the api; dont ever write switch statements of 256 redunant statements


*/
import std;
void foo(int i:0)(){0.writeln;}
void foo(int i:1)(){assert(0);}
void foo(int i:2)(){static assert(0);}
enum maxfoo=2;

template overloadsetlength(alias A,int acc=0){
	static if( ! __traits(compiles,A!acc)){
		enum overloadsetlength=acc;
	} else {
		enum overloadsetlength=overloadsetlength!(A,acc+1);
}}
void bar(){}

unittest{
	static assert(overloadsetlength!foo==maxfoo);
	static assert(overloadsetlength!bar==0);
}

void runtimefoo(int i){
	label: switch(i){
		static foreach(int I;0..overloadsetlength!foo){
			case I: foo!I(); break label;
		}
		default: assert(0);
	}
}
unittest{
	runtimefoo(0);
}
