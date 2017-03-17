---
layout: post
title:  "front end study notes"
date:   2017-03-01 19:24:55 -0800
categories: front_end 
---
<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. javascript</a>
<ul>
<li><a href="#sec-1-1">1.1. keywords</a>
<ul>
<li><a href="#sec-1-1-1">1.1.1. closure</a></li>
<li><a href="#sec-1-1-2">1.1.2. "use strict"</a></li>
<li><a href="#sec-1-1-3">1.1.3. - "prototype"</a></li>
<li><a href="#sec-1-1-4">1.1.4. - constructor</a></li>
<li><a href="#sec-1-1-5">1.1.5. - LexicalEnvironment | closure | block</a></li>
<li><a href="#sec-1-1-6">1.1.6. - ECMAScript ES3/ES5/ES6</a></li>
<li><a href="#sec-1-1-7">1.1.7. - typeof | instanceof | null | undefined</a></li>
<li><a href="#sec-1-1-8">1.1.8. - compare</a></li>
<li><a href="#sec-1-1-9">1.1.9. - this</a></li>
</ul>
</li>
<li><a href="#sec-1-2">1.2. Built-in obj</a></li>
<li><a href="#sec-1-3">1.3. DOM document object model</a></li>
<li><a href="#sec-1-4">1.4. BOM browser object model</a></li>
<li><a href="#sec-1-5">1.5. FOP</a>
<ul>
<li><a href="#sec-1-5-1">1.5.1. Arrow Functions =&gt; (ES6 only, non IE support!)</a></li>
<li><a href="#sec-1-5-2">1.5.2. forEach/for in/for of</a></li>
<li><a href="#sec-1-5-3">1.5.3. every/some</a></li>
<li><a href="#sec-1-5-4">1.5.4. reverse/sort</a></li>
<li><a href="#sec-1-5-5">1.5.5. map/reduce/filter</a></li>
<li><a href="#sec-1-5-6">1.5.6. generator/yield/*yield</a></li>
<li><a href="#sec-1-5-7">1.5.7. Promise</a></li>
</ul>
</li>
<li><a href="#sec-1-6">1.6. OOP patterns</a>
<ul>
<li><a href="#sec-1-6-1">1.6.1. pseudo-class</a></li>
</ul>
</li>
<li><a href="#sec-1-7">1.7. Event</a>
<ul>
<li><a href="#sec-1-7-1">1.7.1. Asynchronous Event Queue</a></li>
<li><a href="#sec-1-7-2">1.7.2. Synchronous Event</a></li>
</ul>
</li>
<li><a href="#sec-1-8">1.8. other source code</a></li>
<li><a href="#sec-1-9">1.9. Ref</a></li>
</ul>
</li>
<li><a href="#sec-2">2. CSS</a>
<ul>
<li><a href="#sec-2-1">2.1. CSS3</a></li>
<li><a href="#sec-2-2">2.2. SASS</a></li>
<li><a href="#sec-2-3">2.3. Compass</a></li>
</ul>
</li>
</ul>
</div>
</div>

# javascript<a id="sec-1" name="sec-1"></a>

## keywords<a id="sec-1-1" name="sec-1-1"></a>

### closure<a id="sec-1-1-1" name="sec-1-1-1"></a>

1.  hide sth/ enable private method

2.  use lexicalEnv as memoizer

### "use strict"<a id="sec-1-1-2" name="sec-1-1-2"></a>

### - "prototype"<a id="sec-1-1-3" name="sec-1-1-3"></a>

-   obj.\_<sub>proto</sub>\_\_ | function.prototype/function.\_<sub>proto</sub>\_\_
    -   Object.create(proto, propertiesObject)

1.  obj = new Function;

    -   obj.\_<sub>proto</sub>\_\_ = Function.prototype
    -   obj.constructor = Function = Function.prototype.constructor

### - constructor<a id="sec-1-1-4" name="sec-1-1-4"></a>

-   obj.constructor | Object.prototype.constructor
    alert( rabbit.hasOwnProperty('constructor') ) */ false
    alert( Rabbit.prototype.hasOwnProperty('constructor') ) /* true

### - LexicalEnvironment | closure | block<a id="sec-1-1-5" name="sec-1-1-5"></a>

### - ECMAScript ES3/ES5/ES6<a id="sec-1-1-6" name="sec-1-1-6"></a>

### - typeof | instanceof | null | undefined<a id="sec-1-1-7" name="sec-1-1-7"></a>

### - compare<a id="sec-1-1-8" name="sec-1-1-8"></a>

1.  stric equal `=`
2.  abstract equal ==
3.  Object.is(val1,val2)

### - this<a id="sec-1-1-9" name="sec-1-1-9"></a>

1.  called as obj.method
2.  called as function
    -   Window/Global/undefined ("use strict")
3.  called in new
4.  explicit this
    func.call(context, args&#x2026;)
    func.apply(context, [arg]|args&#x2026;)
    func.bind(context, args&#x2026;)()

## Built-in obj<a id="sec-1-2" name="sec-1-2"></a>

-   Function
    1.  arguments | arguments.callee
    2.  static fields: arguments.callee.count

## DOM document object model<a id="sec-1-3" name="sec-1-3"></a>

## BOM browser object model<a id="sec-1-4" name="sec-1-4"></a>

-   alert/confirm/prompt
-   url
-   frame
-   XMLHttpRequest

## FOP<a id="sec-1-5" name="sec-1-5"></a>

### Arrow Functions => (ES6 only, non IE support!)<a id="sec-1-5-1" name="sec-1-5-1"></a>

1.  definition

    An arrow function expression has a shorter syntax than a function expression and does not bind its own this, arguments, super, or new.target. 
    These function expressions are best suited for non-method functions, and they cannot be used as constructors.
    
        (param1, param2, …, paramN) => { statements }
        (param1, param2, …, paramN) => expression
        // equivalent to: (param1, param2, …, paramN) => { return expression; }
        
        // Parentheses are optional when there's only one parameter:
        (singleParam) => { statements }
        singleParam => { statements }
        
        // A function with no parameters requires parentheses:
        () => { statements }
        () => expression // equivalent to: () => { return expression; }
        
        // Parenthesize the body to return an object literal expression:
        params => ({foo: bar})
        
        // Rest parameters and default parameters are supported
        (param1, param2, ...rest) => { statements }
        (param1 = defaultValue1, param2, …, paramN = defaultValueN) => { statements }
        
        // Destructuring within the parameter list is also supported
        var f = ([a, b] = [1, 2], {x: c} = {x: a + b}) => a + b + c;
        f();  // 6

2.  not bind its own this, arguments, super, or new.target; not as constructor

        'use strict';
        var obj = {
          i: 10,
          b: () => console.log(this.i, this),
          c: function() {
            console.log(this.i, this);
          }
        }
        obj.b(); // prints undefined, undefined
        obj.c(); // prints 10, Object {...}

### forEach/for in/for of<a id="sec-1-5-2" name="sec-1-5-2"></a>

    var s = 'a𝓌a';
    for(var c of s) console.log(c);
    
    for(var c in s) console.log(s[c]);
    Array.prototype.forEach.call(s, c => console.log(c));

### every/some<a id="sec-1-5-3" name="sec-1-5-3"></a>

### reverse/sort<a id="sec-1-5-4" name="sec-1-5-4"></a>

### map/reduce/filter<a id="sec-1-5-5" name="sec-1-5-5"></a>

    var materials = ['Hydrogen', 'Helium', 'Lithium', 'Beryllium'];
    var result = materials.map(material => material.length).filter(n=>n>7).reduce((a,b)=>a+b);

1.  reduce

        [0, 1, 2, 3, 4].reduce( (accumulator, currentValue, currentIndex, array) => accumulator + currentValue,
    
    100
    );

### generator/yield/\*yield<a id="sec-1-5-6" name="sec-1-5-6"></a>

### Promise<a id="sec-1-5-7" name="sec-1-5-7"></a>

## OOP patterns<a id="sec-1-6" name="sec-1-6"></a>

### pseudo-class<a id="sec-1-6-1" name="sec-1-6-1"></a>

    function Hamster() { 
      this.food = []
    }
    Hamster.prototype = {
      found: function(something) {
        this.food.push(something)
      }
    }
    
    speedy = new Hamster()
    lazy = new Hamster()
    
    speedy.found("apple")
    speedy.found("orange")
    
    alert(speedy.food.length) // 2
    alert(lazy.food.length) // 0(!)

## Event<a id="sec-1-7" name="sec-1-7"></a>

### Asynchronous Event Queue<a id="sec-1-7-1" name="sec-1-7-1"></a>

### Synchronous Event<a id="sec-1-7-2" name="sec-1-7-2"></a>

## other source code<a id="sec-1-8" name="sec-1-8"></a>

    // 1. Function declarations are initialized before the code is executed.
    // window = { f: function }
    
    // 2. Variables are added as window properties.
    // window = { f: function, a: undefined, g: undefined }
    
    var a = 5   // <-- var
    
    function f(arg) { alert('f:'+arg) }
    
    var g = function(arg) { alert('g:'+arg) } // <-- var
    
    //read vs set
    function f() {
      x = 5 // writing x puts it into outmost LexicalEnvironment
      console.log(typeof y); //undefined
      console.log(abc); //error
    }

## Ref<a id="sec-1-9" name="sec-1-9"></a>

-   javascript.info
    -   <http://javascript.info/tutorial/inheritance#inheritance-the-proto>
-   google: RegExp mdc/ regexp msdn jscript

# CSS<a id="sec-2" name="sec-2"></a>

## CSS3<a id="sec-2-1" name="sec-2-1"></a>

## SASS<a id="sec-2-2" name="sec-2-2"></a>

Sass is an extension of CSS3 which adds nested rules, variables, mixins, selector inheritance, and more. 
Sass generates well formatted CSS and makes your stylesheets easier to organize and maintain.

## Compass<a id="sec-2-3" name="sec-2-3"></a>

Compass is an open-source CSS authoring framework which uses the Sass stylesheet language to make writing stylesheets powerful and easy.
