part of 'functions.dart';

syncExecutionAndReturn<T> (T value, void Function (T value) process){
  process(value);
  return value;
}