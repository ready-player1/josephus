//
//  main.swift
//  
//  
//  Created by Masahiro Oono on 2022/01/23
//  
//

import Foundation
import LinkedList
import ArgumentParser

struct Josephus: ParsableCommand {
  @Argument(help: "Total number of people in a circle.")
  var numberOfPeople: Int

  @Argument(help: "<number-to-be-executed>-th is executed.")
  var numberToBeExecuted: Int

  @Flag(name: .shortAndLong, help: "Show all the numbers in the execution list.")
  var verbose = false

  @Option(name: [.customShort("t"), .customLong("tail")], help: "Show the last <tail> numbers.")
  var number: Int = 1

  mutating func validate() throws {
    guard numberOfPeople > 0 && numberToBeExecuted > 0 else {
      throw ValidationError("Arguments must be greater than zero")
    }
    guard number <= numberOfPeople else {
      throw ValidationError("Cannot specify a number exceeding the total number of people")
    }
  }

  func printList(_ list: LinkedList<Int>) {
    print(list.map({ String($0) }).joined(separator: " "))
  }

  func execute(n: Int, k: Int) -> LinkedList<Int> {
    let executionList = LinkedList<Int>()
    let people = LinkedList<Int>().circulate()
    people.append(contentsOf: 1...n)

    while !people.isEmpty {
      executionList <-* people.advance(distance: k)
    }
    return executionList
  }

  func fetch(_ number: Int, from executionList: LinkedList<Int>) -> LinkedList<Int> {
    let survivors = LinkedList<Int>()
    executionList.pointToTail()

    while survivors.count < number {
      survivors <*- executionList.prevNode()
    }
    return survivors
  }

  mutating func run() throws {
    let executionList = execute(n: numberOfPeople, k: numberToBeExecuted)
    printList(verbose ? executionList : fetch(number, from: executionList))
  }
}

Josephus.main()
