(defproject moody-server "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.5.1"]
                 [ring/ring-core "1.2.2"]
                 [ring/ring-jetty-adapter "1.2.2"]
                 [ring/ring-json "0.3.1"]
                 [compojure "1.1.7"]
                 [postgresql "9.3-1101.jdbc4"]
                 [org.clojure/java.jdbc "0.3.3"]
                 [org.clojure/data.json "0.2.4"]]
  :uberjar-name "moody-standalone.jar"
  :min-lein-version "2.0.0")
