(ns moody-server.core
  (:require [ring.middleware.json :refer :all]
            [ring.middleware.session :as session]
            [ring.middleware.params :as params]
            [ring.middleware.nested-params :as nested-params]
            [ring.middleware.keyword-params :as keyword-params]
            [ring.adapter.jetty :as jetty]
            [ring.util.response :refer :all]
            [compojure.core :refer :all]
            [compojure.route :as route]
            [compojure.handler :as handler]
            [cemerick.drawbridge]))

(defn keywordify [obj]
  (let [keys (->> (keys obj)
                  (map keyword))]
    (zipmap keys (vals obj))))

(def moods (atom []))

(defn add-mood! [mood]
  (swap! moods conj (keywordify mood)))

(defroutes app-routes
;  (GET "/test" [] "<h1>test</h1>")
  (GET "/moods" []
       (response @moods))
  (POST "/moods" {moods :body}
        (let [new-moods (map add-mood! moods)]
          (response
           {:moods (count (first new-moods))} ))))

(def drawbridge-handler
  (-> (cemerick.drawbridge/ring-handler)
      (keyword-params/wrap-keyword-params)
      (nested-params/wrap-nested-params)
      (params/wrap-params)
      (session/wrap-session)))

(defn wrap-drawbridge [handler]
  (fn [req]
    (if (= "/repl" (:uri req))
      (drawbridge-handler req)
      (handler req))))



(def app
  (-> (handler/site app-routes)
      wrap-json-body
      wrap-json-response))

#_(defonce server (jetty/run-jetty #'app
                           {:port 3000 :join? false}))

(defn -main [port]
  (jetty/run-jetty (wrap-drawbridge app)
                   {:port (Integer. port) :join? false}))
