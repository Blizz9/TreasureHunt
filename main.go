package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
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

	http.HandleFunc("/Name", nameHandler)
	http.HandleFunc("/NameValue", nameValueHandler)

	panic(http.ListenAndServe(":"+strconv.Itoa(port), nil))
}

func nameHandler(w http.ResponseWriter, r *http.Request) {
	body, err := ioutil.ReadFile("name.html")
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
