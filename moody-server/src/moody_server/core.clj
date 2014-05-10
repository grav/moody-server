(ns moody-server.core
  (:require [ring.middleware.json :refer :all]
            [ring.adapter.jetty :as jetty]
            [ring.util.response :refer :all]
            [compojure.core :refer :all]
            [compojure.route :as route]
            [compojure.handler :as handler]))

(defn keywordify [obj]
  (let [keys (->> (keys obj)
                  (map keyword))]
    (zipmap keys (vals obj))))

(def moods (atom []))

(defn add-mood! [mood]
  (swap! moods conj (keywordify mood)))

(defn get-moods []
  @moods)

(defroutes app-routes
;  (GET "/test" [] "<h1>test</h1>")
  (GET "/moods" []
       (response @moods))
  (POST "/moods" {moods :body}
        (map add-mood! moods)))

(def app
  (-> (handler/site app-routes)
      wrap-json-body
      wrap-json-response))

#_(defonce server (jetty/run-jetty #'app
                           {:port 3000 :join? false}))

(defn -main [port]
  (jetty/run-jetty app {:port (Integer. port) :join? false}))
