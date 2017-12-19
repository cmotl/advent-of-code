>lein repl

(require '[clojure.tools.namespace.repl :as repl])  
(repl/refresh)
(clojure.test/run-tests 'day-2.core-test))
