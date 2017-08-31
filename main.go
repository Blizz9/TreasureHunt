package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math"
	"net/http"
	"strconv"
	"time"
)

const (
	port       = 8080
	bufferSize = 1024
)

type name struct {
	First string
	Last  string
}

func main() {
	http.Handle("/", http.FileServer(http.Dir(".")))

	http.HandleFunc("/name", nameHandler)
	http.HandleFunc("/namevalue", nameValueHandler)
	http.HandleFunc("/shrines", shrinesHandler)
	http.HandleFunc("/isnearshrines", isNearShrinesHandler)
	http.HandleFunc("/isinshrine", isInShrineHandler)

	panic(http.ListenAndServe(":"+strconv.Itoa(port), nil))
}

func nameHandler(w http.ResponseWriter, r *http.Request) {
	body, err := ioutil.ReadFile("treasure-hunt.html")
	if err != nil {
		http.Error(w, "Could not find name.html file.", http.StatusInternalServerError)
		return
	}
	fmt.Fprintf(w, "%s", body)
}

func nameValueHandler(w http.ResponseWriter, r *http.Request) {
	nameValue := name{First: "Nick", Last: "Blizard"}

	json, err := json.Marshal(nameValue)
	if err != nil {
		http.Error(w, "Unable to format JSON response.", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(json)
}

func shrinesHandler(w http.ResponseWriter, r *http.Request) {
	shrines := retreiveShrines()

	json, err := json.Marshal(shrines)
	if err != nil {
		http.Error(w, "Unable to format JSON response.", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(json)
}

func isNearShrinesHandler(w http.ResponseWriter, r *http.Request) {
	const earthRadius = 6378100

	shrineID := r.URL.Query().Get("shrineid")

	latitude, _ := strconv.ParseFloat(r.URL.Query().Get("latitude"), 64)   //38.292743
	longitude, _ := strconv.ParseFloat(r.URL.Query().Get("longitude"), 64) //-85.508319

	shrineCheck := shrineCheck{shrineID, time.Now().UnixNano() / int64(time.Millisecond), latitude, longitude}
	storeShrineCheck(shrineCheck)

	latitude = latitude * math.Pi / 180
	longitude = longitude * math.Pi / 180

	closeShrines := 0

	for _, shrine := range retreiveShrines() {
		shrineLatitude := shrine.Latitude * math.Pi / 180
		shrineLongitude := shrine.Longitude * math.Pi / 180

		havdr := hav(shrineLatitude-latitude) + math.Cos(latitude)*math.Cos(shrineLatitude)*hav(shrineLongitude-longitude)
		distance := 2 * earthRadius * math.Asin(math.Sqrt(havdr))

		if distance < 1000 {
			fmt.Println(distance)
			closeShrines++
		}
	}

	json, err := json.Marshal(closeShrines)
	if err != nil {
		http.Error(w, "Unable to format JSON response.", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(json)
}

func hav(theta float64) float64 {
	return math.Pow(math.Sin(theta/2), 2)
}

func isInShrineHandler(w http.ResponseWriter, r *http.Request) {
	json, err := json.Marshal(false)
	if err != nil {
		http.Error(w, "Unable to format JSON response.", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(json)
}
