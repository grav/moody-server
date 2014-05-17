(ns moody-server.core
  (:require [ring.middleware.json :refer :all]
            [ring.adapter.jetty :as jetty]
            [ring.util.response :refer :all]
            [compojure.core :refer :all]
            [compojure.route :as route]
            [compojure.handler :as handler]
            [clojure.java.jdbc :as jdbc]
            [environ.core :as environ]))

(def *db*
  (environ/env :db))

(defn add-mood! [mood]
  (jdbc/insert!
   *db*
   :moods
   {:mood mood}))

(defn get-moods []
  (->> (jdbc/query
       *db*
       "SELECT * FROM moods")
      (map :mood)))

(defroutes app-routes
;  (GET "/test" [] "<h1>test</h1>")
  (GET "/moods" []
       (response (get-moods)))
  (POST "/moods" {moods :body}
        (let [new-moods (map add-mood! moods)]
          (response
           {:moods (count (first new-moods))} ))))

(def app
  (-> (handler/site app-routes)
      wrap-json-body
      wrap-json-response))

#_(defonce server (jetty/run-jetty #'app
                           {:port 3000 :join? false}))

(defn -main [port]
  (jetty/run-jetty app {:port (Integer. port) :join? false}))
