//
//  Learn.m
//  App42
//
//  Created by Purnima Singh on 12/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "Learn.h"

@implementation Learn

@end

/*
 > Strong means that the reference count will be increased and the reference to it will be maintained through the life of the object.
 
 exampple:  var name : String?
 
 > Weak (non-strong reference), means that we are pointing to an object but not increasing its reference count. Its often used when creating a parent child relationship. The parent has a strong reference to the child but the child only has a weak reference to the parent.
 - every time used on var
 - every time used on an optional type
 - automatically changes itself to nil
 
 example: weak var name : String?
 
 Weak references must be declared as variables, to indicate that their value can change at runtime. A weak reference cannot be declared as a constant.
 
 > Guard Statement: 
 - It checks for some conditions and if it evaluates to be false then the else statment will executes which normally exit a method.
 - A guard let statment is another way of writting if let stament written in different way.
 - Unlike an if stament, guard always has a else clause- the code will executes if the condition will be false.
 - It provides an early exit and some brackets. Early exit means fast execution.
 - Unlike if let statment, any variables or constants that were assigned values using an optional binding as part of the condition are available for the rest of the code block that the guard staments appears in.
 
 example:  guard let name == person["name"] else
            {
                print("name is not valid")
            }
 
 
 
 > Atmoic:
    - Atomic is an default behaviour.
    - A single thread will be able to access the property at a given point.
    - Only one thread will be able to access the getter/ setter of a property.
    - Other threads have to wait until first thread releases get/set method.
    - It will ensure that the value of a property remains consistent throghhout the life cycle.
 
 
 > Non-Atomic:
    - Nonatomic is not default behaviour.
    - For non atmoic properties, multiple thread can access the propert simuntanously
    - so there is always a risk of inconsistency between values
 
 > NSArray & Array:  NSArray are immuatble nad reference type. Array are immutable when declare with let and mutable when declare with var, and they are valye type.
 
 
 */


/*

 classes and structures are general-purpose, flexible constructs that become the building blocks of the program's code. we define properties and methods to add functionality to the classes and structures by using exactly tha same syntax as for the constants, variables and functions
 
 > Classes are reference type and structures are value type
 Classes and structures are general-purpose, flexible constructs that become the building blocks of the program code.
 we define properties and method to add functionality to the classes and structures by using the same syntax as for constants, variables and functions.
 
 Classes and structures are general-purpose, flexible constructs that become the building blocks of your program’s code.
 You define properties and methods to add functionality to your classes and structures by using exactly the same syntax as for constants, variables, and functions.
 */







