Acess Modifiers - Public, Private, Protected

Inline Functions-  C++ provides an inline functions to reduce the function call overhead. Inline function is a function that is expanded in line when it is called. When the inline function is called whole code of the inline function gets inserted or substituted at the point of inline function call.
Inline call is a request to compiler. The compiler may ignore it.
All the functions defined inside class definition are by default inline, but you can also make any non-class function inline by using keyword inline with them.
It is adviced to define large functions outside the class definition using scope resolution :: operator, because if we define such functions inside class definition, then they become inline automatically.

Constructor - Class()
Destructor - ~Class()

Static Functions - These functions cannot access ordinary data members and member functions, but only static data members and static member functions can be called inside them.
Constant - such member functions can never modify the object or its related data members.
Friend Function-
Syntax 

friend void foo();
friend void otherclass::foo();
firend otherclass;

Friend Functions is a reason, why C++ is not called as a pure Object Oriented language. Because it violates the concept of Encapsulation.

**Inheritence - **
5 types of inheritence - 
1. Single -  one derived class inherits from only one base class.
2. Multiple -  a single derived class may inherit from two or more than two base classes.
3. Hierarchical - multiple derived classes inherits from a single base class.
4. Multilevel - the derived class inherits from a class, which in turn inherits from some other class.
5. Virtual - combination of Hierarchical and Mutilevel Inheritance.

**Polymorphism**
Something have multiple characteristics.
1. Compile Time Polymorphism - Funciton Overloading, Operator Overloading
2. Runtime Polymorphism - Function Overriding -  A derived class has a definition for one of the member functions of the base class. That base function is said to be overridden.
