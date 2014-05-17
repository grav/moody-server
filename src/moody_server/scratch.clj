(ns moody-server.scratch
  (:require [mood-server.db :as db]
            [clojure.java.jdbc :as jdbc]))

(jdbc/query "jdbc:postgresql://grav@localhost:5432/test"
            "SELECT * FROM testtbl")
