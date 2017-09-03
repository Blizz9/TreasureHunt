// Package main is my ARG game idea.
package main

import (
	"encoding/json"
	"fmt"
	"math"
	"net/http"
	"strconv"
	"time"
)

const earthRadius = 6378100

// Shrine is hidden locations in the world.
type Shrine struct {
	ShrineID     string
	Latitude     float64 `json:"Latitude,string"`
	Longitude    float64 `json:"Longitude,string"`
	ShrineNumber int
	ShrineType   int
}

// LocationQuery is a user in the world looking for shrines.
type LocationQuery struct {
	UserID    string
	Timestamp int64
	Latitude  float64 `json:"Latitude,string"`
	Longitude float64 `json:"Longitude,string"`
}

var shrines []Shrine

func main() {
	shrines = retreiveShrines()

	// for _, shrine := range shrines {
	// 	fmt.Println(shrine.Latitude, ",", shrine.Longitude)
	// }

	//http.Handle("/", http.FileServer(http.Dir(".")))

	http.HandleFunc("/test", testHandler)
	http.HandleFunc("/isnearshrines", isNearShrinesHandler)
	http.HandleFunc("/isinshrine", isInShrineHandler)

	panic(http.ListenAndServe(":8080", nil))
}

func testHandler(w http.ResponseWriter, r *http.Request) {
	locationQuery := LocationQuery{"9", time.Now().UnixNano() / int64(time.Millisecond), 30, -85}

	json, err := json.Marshal(locationQuery)
	if err != nil {
		http.Error(w, "Unable to format JSON response.", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(json)
}

func isNearShrinesHandler(w http.ResponseWriter, r *http.Request) {
	userID := r.URL.Query().Get("userid")
	latitude, _ := strconv.ParseFloat(r.URL.Query().Get("latitude"), 64)   //38.292743
	longitude, _ := strconv.ParseFloat(r.URL.Query().Get("longitude"), 64) //-85.508319
	locationQuery := LocationQuery{userID, time.Now().UnixNano() / int64(time.Millisecond), latitude, longitude}

	nearShrines := searchForShrines(locationQuery, 2000)

	json, err := json.Marshal(nearShrines)
	if err != nil {
		http.Error(w, "Unable to format JSON response.", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(json)
}

func isInShrineHandler(w http.ResponseWriter, r *http.Request) {
	userID := r.URL.Query().Get("userid")
	latitude, _ := strconv.ParseFloat(r.URL.Query().Get("latitude"), 64)   //38.292743
	longitude, _ := strconv.ParseFloat(r.URL.Query().Get("longitude"), 64) //-85.508319
	locationQuery := LocationQuery{userID, time.Now().UnixNano() / int64(time.Millisecond), latitude, longitude}

	nearShrines := searchForShrines(locationQuery, 150)

	json, err := json.Marshal(len(nearShrines) > 0)
	if err != nil {
		http.Error(w, "Unable to format JSON response.", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(json)
}

func searchForShrines(locationQuery LocationQuery, maximumDistance int) []Shrine {
	nearShrines := []Shrine{}

	storeLocationQuery(locationQuery)

	latitude := locationQuery.Latitude * math.Pi / 180
	longitude := locationQuery.Longitude * math.Pi / 180

	for _, shrine := range shrines {
		shrineLatitude := shrine.Latitude * math.Pi / 180
		shrineLongitude := shrine.Longitude * math.Pi / 180

		havdr := hav(shrineLatitude-latitude) + math.Cos(latitude)*math.Cos(shrineLatitude)*hav(shrineLongitude-longitude)
		distance := 2 * earthRadius * math.Asin(math.Sqrt(havdr))

		if distance < float64(maximumDistance) {
			fmt.Println(distance)
			nearShrines = append(nearShrines, shrine)
		}
	}

	return nearShrines
}

func hav(theta float64) float64 {
	return math.Pow(math.Sin(theta/2), 2)
}
