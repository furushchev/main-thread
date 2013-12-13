# Main-Thread
Thread Utility for CommonLisp

#### Description
Some routine must call in main thread. especially about sounds or gui works.
This macro interruption to main-thread, and wait until returning body form.

#### Require
- [Quicklisp](http://www.quicklisp.org)
- [ClozureCL](http://www.clozure.com/clozurecl.html) or [SBCL](http://www.sbcl.org) or [ECL](http://ecls.sourceforge.net)

#### Usage
- `mt:main-thread` Returns a main-thread of your CL implementations
- `mt:call-in-main-thread` Evaluate a given form in main-thrad
- `mt:get-semaphore-by-thread` Returns a one semaphore per thread
