package main

import (
	"fmt"
	"io/ioutil"
	"net/http"

	"strconv"
)

const (
	port       = 8080
	bufferSize = 1024
)

func main() {
	http.HandleFunc("/test", testHandler)

	panic(http.ListenAndServe(":"+strconv.Itoa(port), nil))
}

func testHandler(w http.ResponseWriter, r *http.Request) {
	body, err := ioutil.ReadFile("test.html")
	if err != nil {
		http.Error(w, "Could not find test.html file.", http.StatusInternalServerError)
		return
	}
	fmt.Fprintf(w, "%s", body)
}
