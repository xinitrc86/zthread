# ZThread
Simple parallel execution via Threads implemented in ABAP, based on JAVA Thread and its *Runnable* interface plus callback capabilities. 
```
data(someProcessing) = new zcl_some_processing( some_data ).
data(anotherProcessing) = new zcl_some_other( some_data ).

new zcl_thread( someProcessing )->start( ).
new zcl_thread( anotherProcessing )->start( ).

"waits for threads to finish"
zcl_thread=>join_all( ).

write: 'All done!'
```
You can check the ABAP Docs for info and the source for examples. Feel free to provide new examples or colaborate with this.

## Usage
Implement the *zif_runnable* interface with the logic you want to *fork* (start in a new thread), give it to a thread and start:
```
class zcl_my_runnable...
   interfaces zif_runnable.
   
   method constructor.
     "store data to process
   endmethod.
   
   method zif_runnable~run.
     "...process data.	 
   endmethod.
  
 endclass.
 
 data(firstSplit) = new zcl_my_runnable( data_to_process_1 ).
 data(secondSplit) = new zcl_my_runnable( data_to_process_2 ).
 
 new zcl_thread( firstSplit )->start( ).
 new zcl_thread( secondSplit )->start( ).
```
### Waiting for Threads to end
The static method join_all allows *join* (wait for threads to finish).
```
data(myThread) = new zcl_thread(aRunnable).
new zcl_thread(anotherRunnable)->start( ).
new zcl_thread(yetAnotherRunnable)->start( ).

myThread->start( ).
myThread->join( ). "waits for this specific thread" 

zcl_thread=>join_all( ). "waits for all threads to finish" 

```
### Retrieving threads results
You can retrieve results back from Threads by implementing the *zif_runnable_result* interface.
```
class zcl_my_runnable definition.
	"here runnable is implementing both interfaces"
	"but the result can be a separate object too"
	interfaces: zif_runnable, zif_runnable_result.
	data myNumbers type standard table of p...
	data myTotal type p.
	
	method get_total.
	  rv_result = myTotal.
	endmethod.
	
	method zif_runnable~run.
	  "sums numbers into myTotal"
	  myTotal = reduce #( 
		init total = 0.
		for number in myNumbers
		next
			total = total + number
	  ).
          "This is possoble because me is implementing 
          "zif_runnable_result. Could be another object.
          ro_result = me.
	endmethod.
	
endclass.

data(myRunnable) = new zcl_my_runnable( value #( ( 10 ) ( 10 ) ( 10 ) ) ).
data(myThread) = new zcl_thread( myRunnable ).

myThread->start( ).
myThread->join( ).

"retrieves the result, callers must know its type"
data(myResult) = cast zcl_my_runnable( myThread->get_result( ) ).
data(myTotal) = myResult->get_total( ).

write: myTotal. "30"

```

### Defining callbacks
To defined a callback, implement interface *zif_thread_callback|* and passe it along to the thread. For an callback object to be called back, it must still be referenced once the thread is finished.
```
class zcl_callback_example definition.
   interfaces zif_thread_callback.
   
   private section.
      data myTotal type p.
   
   method zif_thread_callback~on_result.
   	data(result) = cast zcl_my_result( io_result ).
	myTotal = myTotal + result->get_total( ).
   endmethod.
   
   method zif_thread_callback~on_error.
      	raise exception type zcx_myError
	  	exporting previous = io_error.
   endmethod.
   
   method sumAll.
   
     data(runnable1) = zcl_my_Runnable( value #( ( 10 ) ( 10 ) ( 10 ) ) ). "adds to 30"
	 data(runnable2) = zcl_my_Runnable( value #( ( 20 ) ( 20 ) ( 20 ) ) ). "adds to 60"
	 
	 new zcl_thread( io_runnable = runnable1, io_callback = me )->start( ).
	 new zcl_thread( io_runnable = runnable2, io_callback = me )->start( ).
	 
	 zcl_thread=>join_all( ).
	 write: myTotal. "sum 30 + 60 =  90 "
   
   endmethod.
   
endclass.
```
# Help welcomed
Reviews, examples, downports. Feel free to contribute.
