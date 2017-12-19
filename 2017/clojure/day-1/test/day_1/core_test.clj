(ns day-1.core-test
  (:require [clojure.test :refer :all]
            [day-1.core :refer :all]))

(require '[clojure.string :as str])

(defn acl [input] (map #(Character/getNumericValue %) input))

(defn pairs [nums] (map vector nums (concat (rest nums) [(first nums)])))

(defn repetition [[a,b]] 
 (cond
  (= a b) a
  :else 0 ))

(defn shifted_pairs [nums] (map vector nums (flatten (reverse (partition (/ (count nums) 2) nums)))))

(defn part1 [input] (reduce + 0 (map repetition (pairs (acl input)))))
(defn part2 [input] (reduce + 0 (map repetition (shifted_pairs (acl input)))))

(deftest acl-test
  (testing "should translate input"
    (is (= '(1 2 3) (acl "123")))))

(deftest pairs-test
  (testing "should pair up input"
    (is (= [[1 2] [2 3] [3 1]] (pairs '(1 2 3))))))

(deftest repetition-test
  (testing "should convert pair to repetition"
    (is (= 1 (repetition [1 1])))
    (is (= 0 (repetition [1 2])))))

(deftest shifted_pairs-test
  (testing "should shift with half of list"
    (is (= [[1 3] [2 4] [3 1] [4 2]] (shifted_pairs '(1 2 3 4))))))

(deftest integration
  (testing "part 1"
    (is (= 1119 (part1 (str/trim (slurp "input.txt"))))))
  (testing "part 2"
    (is (= 1420 (part2 (str/trim (slurp "input.txt")))))))
