**Acess Modifiers** - 
Public - The data members and member functions declared public can be accessed by other classes too.
Private - No one can access the class members declared private, outside that class.
Protected - Similar to Private but subclasses can access the members.

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
*Virtual Members*
Member function that can be redefined in a derived class.
Non-virtual members can also be redefined in derived classes, but non-virtual members of derived classes cannot be accessed through a reference of the base class.
*Abstract Base Class*
They are classes that can only be used as base classes, and thus are allowed to have virtual member functions without definition. It can not be instantiated
Sytax - 
*virtual int area()=0;* - Pure Virtual Function
The classes that contain atleas one pure virtual function are called abstract base class.
Abstract base classes cannot be used to instantiate objects.

*Virtual Destructor*
Making base class destructor virtual guarantees that the object of derived class is destructed properly, i.e., both base class and derived class destructors are called.As a guideline, any time you have a virtual function in a class, you should immediately add a virtual destructor (even if it does nothing).



*Function Pointers*
Pointer - Variable that holds address of anothre variable.
Fnc Ptrs - Point to functions.
Syntax - 
Pointer to a function that takes no arguments and returns an int
int (*fcnPtr)(); //brackets around fcnPtr are very important
int (*const fcnPtr)(); //const function pointer*
Assignment-
int (*fcnPtr)() = foo;*
Calling A function through a pointer
(*fcnPtr)(5);*
*fcnPtr(5)* - Implicit dereference method
Default parameters wont work.
Default parameres are resolved at compile time whereas function parameters are resolved at runtime.
Functions used as arguments to another function are sometimes called **callback functions**.
Uses - 
1. Callback Mechanism - The callback will be called by the function it is given to for instance when data is available or certain processing steps need to be performed.
2. Store an array of functions to call dynamically.
3. A virtual table contains one entry for each virtual function that can be called by objects of the class. Each entry in this table is simply a function pointer that points to the most-derived function accessible by that class.
**Function Templates**
Write functions that can be used with generic types.This allows us to create a function template whose functionality can be adapted to more than one type or class without repeating the entire code for each type.

template <class T>
T GetMax (T a, T b) {
  T result;
  result = (a>b)? a : b;
  return (result);
}

template <class T, class U>
T GetMin (T a, U b) {
  return (a<b?a:b);
}

**Class Templates**
template <class T>
class mypair {
    T a, b;
  public:
    mypair (T first, T second)
      {a=first; b=second;}
    T getmax ();
};

template <class T>
T mypair<T>::getmax ()A static global variable is visible only in the file it is declared but an extern global variable is visible across all the files of a program.
{
  T retval;
  retval = a>b? a : b;
  return retval;
}
  
**Storage Classes**
 A variable’s storage class gives information about the storage location of variable in memory, default initial value, scope of the variable and it’s lifetime.
Storage class specifiers supported in C++ are auto, register, static, extern and mutable.
A static global variable is visible only in the file it is declared but an extern global variable is visible across all the files of a program.
If a data member of a class is declared as *mutable*, then it can be modified by an object which is declared as constant. 
