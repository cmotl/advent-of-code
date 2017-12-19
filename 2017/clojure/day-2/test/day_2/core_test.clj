(ns day-2.core-test
  (:require [clojure.test :refer :all]
            [day-2.core :refer :all]))

(require '[clojure.string :as str])
(require '[clojure.math.combinatorics :as combo])

(defn row [line]
  (map #(Integer/parseInt %) (str/split line #"\t")))

(defn spreadsheet [input]
  (map row (str/split input #"\n")))

(defn sorted-bounds [row]
  [(first row) (last row)])

(defn bounds [row]
  (sorted-bounds (sort row)))

(defn difference [[a b]]
  (Math/abs (- b a)))

(defn checksum [input]
  (reduce + 0 (map difference (map bounds (spreadsheet input)))))

(defn divisible [row]
  (first (filter (fn [[x y]] (= 0 (mod x y))) (combo/combinations (reverse (sort row)) 2)  )))

(defn checksum-divisible [input]
  (reduce + 0 (map (fn [[x y]] (/ x y)) (map divisible (spreadsheet input)))))

(deftest acl
  (testing "should translate a row"
    (is (= '(1 2 3) (row "1\t2\t3"))))
  (testing "should translate list of instructions"
    (is (= '((1 2 3) (4 5 6)) (spreadsheet "1\t2\t3\n4\t5\t6\n")))))

(deftest bounds-test
  (testing "should find bounds of unsorted list"
    (is (= [1 9] (bounds '(1 7 5 9 3))))))

(deftest difference-test
  (testing "should find difference in ascending order"
    (is (= 8 (difference [1 9]))))
  (testing "should find difference in descending order"
    (is (= 8 (difference [9 1])))))

(deftest checksum-test
  (testing "should calculate checksum"
    (is (= 18 (checksum "5\t1\t9\t5\n7\t5\t3\n2\t4\t6\t8")))))

(deftest integration
  (testing "part 1"
    (is (= 45972 (checksum (slurp "input.txt"))))))

(deftest divisible-test
  (testing "should find evenly divisible numbers"
    (is (= [8 2] (divisible '(5 9 2 8))))))

(deftest divisible-checksum-test
  (testing "should calculate divisible checksum"
    (is (= 9 (checksum-divisible "5\t9\t2\t8\n9\t4\t7\t3\n3\t8\t6\t5")))))

(deftest integration
  (testing "part 2"
    (is (= 326 (checksum-divisible (slurp "input.txt"))))))
