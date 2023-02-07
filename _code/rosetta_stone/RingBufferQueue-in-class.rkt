#lang dssl2


# A person a given name and a surname
class Person:
  let fname : str?
  let lname : str?

  def __init__(self, first, last):
      self.fname = first
      self.lname = last

  def getFirst(self) -> str? :
      return self.fname

let jason = Person("Jason","Hemann")
let bob = Person("Bob","Newhart")

## Ring Buffer Class Implementation

## A queue data structure
interface QUEUE[T]:

    #
    # EFFECT Adds the given element to the back of this queue
    def enqueue(self, element : T) -> NoneC

    # Returns the front element of this queue
    # EFFECT Removes the front element
    def dequeue(self) -> T

    # Decides if this queue is empty
    def empty?(self) -> bool

# A Vec backed Queue structure used as a ring buffer
class RingBufferQueue[T] (QUEUE):
    let ring : VecC[T] # Data structure backing this queue
    let head : nat?    # Index at which queue begins
    let len  : nat?    # Number of elements currently in the queue

    # Template
    ##############
    # Fields:
    # self.ring -- VecC[T]
    # self.head -- nat?
    # self.len -- nat?
    ##############
    # Methods:
    # self.enqueue(T) -- NoneC
    # self.dequeue() -- T
    # self.empty?() -- bool?
    ##############
    # Methods on fields
    # self.ring.len()
    # self.ring.get(nat?)
    # self.ring.put(nat?,T)
    # ...

    def __init__(self, size : nat?):
        if size < 0:
            error('RingBuf: given negative buffer size')
        else:
            self.ring = vec(size)
            self.head = 0
            self.len = 0

    def enqueue(self, elem : T) -> NoneC:
      if self.len == self.ring.len():
            error('RingBuf: buffer full')
      else:
            let idx : IntInC(0,self.ring.len()) = (self.head + self.len) % self.ring.len()
            self.ring[idx] = elem
            self.len = self.len + 1

    def dequeue(self) -> T:
        if self.empty?():
            error('RingBuf: attempt to dequeue from empty queue')
        else:
            let ret : T = self.ring[self.head]
            self.ring[self.head] = None
            self.head = (self.head + 1) % self.ring.len()
            self.len = self.len - 1
            return ret

    def empty?(self) -> bool?:
        return self.len == 0

test 'RingBufferQueue#constructor':
    assert_error RingBufferQueue(-1)

test 'RingBufferQueue#empty?':
    let rb = RingBufferQueue(3)
    assert RingBufferQueue?[AnyC](rb)
    assert rb.empty?()

test 'RingBufferQueue#enqueue and empty?':
    let rb = RingBufferQueue(3)
    rb.enqueue("cat")
    assert RingBufferQueue?[AnyC](rb)
    assert rb.empty?() == False

test 'RingBufferQueue#enqueue and dequeue, basic':
    let rb = RingBufferQueue(3)
    rb.enqueue("cat")
    assert(rb.dequeue() == "cat")

test 'RingBufferQueue#dequeue empty errors':
    let rb = RingBufferQueue(3)
    assert_error rb.dequeue()

test 'RingBufferQueue#enqueue and dequeue':
    let rb = RingBufferQueue(3)
    rb.enqueue("cat")
    assert(rb.dequeue() == "cat")
    rb.enqueue("dog")
    assert(rb.dequeue() == "dog")
    rb.enqueue("fish")
    rb.enqueue("turtle")
    rb.enqueue("whale")
    assert(rb.dequeue() == "fish")
    assert(rb.dequeue() == "turtle")
    assert(rb.dequeue() == "whale")

test 'RingBufferQueue#enqueue overfull':
    let rb = RingBufferQueue(3)
    rb.enqueue("cat")
    rb.enqueue("dog")
    rb.enqueue("fish")
    assert_error rb.enqueue("turtle")

test 'RingBufferQueue#enqueue and dequeue, nonlinear sequence':
    let rb2 = RingBufferQueue(3)
    rb2.enqueue("cat")
    rb2.enqueue("dog")
    assert(rb2.dequeue() == "cat")
    rb2.enqueue("turtle")
    assert(rb2.dequeue() == "dog")
    rb2.enqueue("giraffe")
    assert rb2.dequeue() == "turtle"
    assert rb2.dequeue() == "giraffe"
    assert rb2.empty?()

test 'PersonQueue':
    let rb = RingBufferQueue(3)
    rb.enqueue(Person("Jason","Hemann"))
    rb.enqueue(Person("Giancarlo", "Ayllon"))
    assert rb.dequeue() == Person("Jason", "Hemann")
    assert rb.empty?() == False
    rb.enqueue("cat")
    rb.dequeue()
    rb.dequeue()
