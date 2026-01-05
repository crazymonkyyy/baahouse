# Baahouse Metaprogramming Refactoring Plan

## Objective
Replace all manual switch-case statements with the template metaprogramming pattern demonstrated in `intoverloadset.d`, using `static foreach` and `overloadsetlength` template to avoid redundant manual statements.

## Priority: Critical

## Actions
- Implement `overloadsetlength` template for tile functions to automatically determine available tile count
- Refactor all tools (`tile_to_bitmap.d`, `uniqueness_checker.d`, `inverse_tool.d`) to use `static foreach` pattern
- Create generic runtime dispatch templates that automatically adapt to the number of tile functions
- Follow the exact pattern from `intoverloadset.d`: "dont ever write switch statements of 256 redunant statements"

## Benefits
- Eliminates the violation of the project's own design principles
- Automatic scalability when new tiles are added
- Proper use of D's metaprogramming features
- Reduced maintenance and errors

## Implementation
The project currently violates its own design principle by using manual switch statements. All runtime dispatch functions need to be updated to use the template metaprogramming approach demonstrated in the `intoverloadset.d` example file.

### Key Pattern from intoverloadset.d
```d
template overloadsetlength(alias A,int acc=0){
	static if( ! __traits(compiles,A!acc)){
		enum overloadsetlength=acc;
	} else {
		enum overloadsetlength=overloadsetlength!(A,acc+1);
	}
}

void runtimefoo(int i){
	label: switch(i){
		static foreach(int I;0..overloadsetlength!foo){
			case I: foo!I(); break label;
		}
		default: assert(0);
	}
}
```

This pattern should be applied to replace all manual switch statements in tile tools.