#lang dssl2

#
# EFFECT: swaps elements in array at positions left and right
# ASSUME: left and right are valid indices in array
def swap(array,left,right):
    let temp = array[left]
    array[left] = array[right]
    array[right] = temp

test "swap-works":
  let arr = ["a","b","c"]
  swap(arr,1,2)
  assert arr == ["a","c","b"]

# Produces a tuple of the boundary indices separating the "bigs" and the "smalls"
# EFFECT: Shuffles array elements into the "bigs" and the "smalls"
# ASSUME: called when start - stop > 0, start, stop within bounds of array indices
def part(array : VecC[nat?], start : nat?, stop: nat?) -> TupC[nat?, nat?]:
    let pivot = array[start]
    let left = start #?? Seems we should be able to begin w/start + 1. Wasteful?
    let right = stop
    # Swap mismatched pairs until no more
    while left <= right:
        # Move leftptr right until we find a big with the smalls
        while array[left] < pivot:
            left = left + 1
        # Move rightptr left until we find a small with the bigs
        while array[right] > pivot:
            right = right - 1
        if (left <= right): #?? If they're equal, why swap? Wasteful?
            swap(array,left,right)
            left = left + 1
            right = right - 1
    return [right,left] #?? Seems if they're side by side, we only need one. Wasteful?

test "part#tiny_wrongsort":
  let arr = [5,2]
  let res = part(arr,0,1)
  assert res[0] == 0
  assert res[1] == 1

test "part#tiny_rightsort":
  let arr = [5,2]
  let res = part(arr,0,1)
  assert res[0] == 0
  assert res[1] == 1

test "part#tiny_middle":
  let arr = [5,2,7,1,3]
  let res = part(arr,3,4)
  assert res[0] == 2
  assert res[1] == 4

test "part#small":
  let arr = [5,2,7,1,3]
  let res = part(arr,0,4)
  assert res[0] == 2
  assert res[1] == 3


#
# EFFECT: Sort the sub-array of the given array between [start,stop]
# ASSUME: start, stop are within the bounds of 0, array.len() - 1
def _quicksort(array : VecC[nat?], start : nat?, stop : nat?) -> NoneC:
    if stop - start <= 0: #?? A one-element list is also sorted. Wasteful?
       return
    else:
       let r_l = part(array,start,stop)
       _quicksort(array, start, r_l[0])
       _quicksort(array, r_l[1], stop)

#
# EFFECT: Sort the given array
def quicksort(array):
    _quicksort(array, 0, len(array) - 1)


test "quicksorts decent sized list":
  let data3 = [7,8,5,2,1,3,0,9,6]
  quicksort(data3)
  assert data3 == [0,1,2,3,5,6,7,8,9]
