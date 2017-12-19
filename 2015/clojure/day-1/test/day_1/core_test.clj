(ns day-1.core-test
  (:require [clojure.test :refer :all]
            [day-1.core :refer :all]))

(use 'clojure.string)

(defn elevator-acl [direction]
  (case direction
    \( :up 
    \) :down 
  ))

(defn elevator-instructions [instructions]
  (map elevator-acl instructions))

(defn elevate [floor direction]
  (case direction
    :up (+ floor 1)
    :down (- floor 1)
  ))

(defn elevate-all [instructions]
  (reduce elevate 0 instructions))

(defn main [instructions]
  (->
    instructions
    (elevator-instructions)
    (elevate-all)))

(deftest acl
  (testing "should translate up instruction"
    (is (= :up (elevator-acl \())))
  (testing "should translate down instructions"
    (is (= :down (elevator-acl \)))))
  (testing "should translate list of instructions"
    (is (= [:up :up :down :down] (elevator-instructions "(())")))))

(deftest elevator
  (testing "should move up a floor"
    (is (= 1 (elevate 0 :up))))
  (testing "should move down a floor"
    (is (= -1 (elevate 0 :down))))
  (testing "should move multiple floors"
    (is (= 2 (elevate-all [:up :up :up :down]))))
  )

(deftest integration
  (testing "should move to correct floor"
    (is (= 2 (main "((()")))))

(deftest full-integration
  (testing "should move to correct floor"
    (is (= 138 (main (trim (slurp "input.txt")))))))
